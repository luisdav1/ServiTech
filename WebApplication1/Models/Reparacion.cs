using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WebApplication1.Models
{
    /// <summary>
    /// Entidad central del sistema. Representa una reparación registrada.
    /// Gestiona la lógica de negocio (garantía, coste total) y la persistencia.
    /// </summary>
    public class Reparacion
    {
        // ── Propiedades de la entidad ──────────────────────────────────────────
        public int      IdReparacion       { get; set; }
        public int      IdTecnico          { get; set; }
        public int      IdCliente          { get; set; }
        public int      IdElectrodomestico { get; set; }
        public string   Descripcion        { get; set; }
        public decimal  Coste              { get; set; }
        public bool     EnGarantia         { get; set; }
        public DateTime Fecha              { get; set; }

        // ── Propiedades de navegación (datos desnormalizados para vistas) ──────
        public string  NombreTecnico               { get; set; }
        public string  NombreCliente               { get; set; }
        public string  DescripcionElectrodomestico { get; set; }
        public decimal PrecioElectrodomestico      { get; set; }

        /// <summary>Cadena de conexión leída desde Web.config.</summary>
        private static readonly string CadenaConexion =
            ConfigurationManager.ConnectionStrings["CadenaReparaciones"].ConnectionString;

        // ── Métodos de lógica de negocio ───────────────────────────────────────

        /// <summary>
        /// Asigna un técnico a la reparación actual.
        /// Implementa la operación UML AsignarTecnico().
        /// </summary>
        /// <param name="idTecnico">Identificador del técnico a asignar.</param>
        public void AsignarTecnico(int idTecnico)
        {
            IdTecnico = idTecnico;
        }

        /// <summary>
        /// Calcula el coste total efectivo de la reparación.
        /// Cuando la reparación está cubierta por garantía, el coste de mano de obra es cero.
        /// Implementa la operación UML CalcularTotal().
        /// </summary>
        /// <returns>Importe a facturar al cliente.</returns>
        public decimal CalcularTotal()
        {
            // Las reparaciones en garantía no generan cargo al cliente
            return EnGarantia ? 0m : Coste;
        }

        /// <summary>
        /// Verifica si la reparación está amparada por garantía.
        /// Implementa la operación UML VerificarGarantia().
        /// </summary>
        /// <returns>True si el electrodoméstico se encuentra en periodo de garantía.</returns>
        public bool VerificarGarantia()
        {
            return EnGarantia;
        }

        // ── Métodos de acceso a datos ──────────────────────────────────────────

        /// <summary>
        /// Persiste la reparación en la base de datos.
        /// Aplica CalcularTotal() antes de insertar para reflejar la garantía.
        /// Retorna true si la inserción fue correcta.
        /// </summary>
        public bool Registrar()
        {
            const string sql = @"
                INSERT INTO Reparaciones
                    (IdTecnico, IdCliente, IdElectrodomestico, Descripcion, Coste, EnGarantia, Fecha)
                VALUES
                    (@IdTecnico, @IdCliente, @IdElectrodomestico, @Descripcion, @Coste, @EnGarantia, @Fecha)";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@IdTecnico",          IdTecnico);
                cmd.Parameters.AddWithValue("@IdCliente",          IdCliente);
                cmd.Parameters.AddWithValue("@IdElectrodomestico", IdElectrodomestico);
                cmd.Parameters.AddWithValue("@Descripcion",        Descripcion);
                cmd.Parameters.AddWithValue("@Coste",              CalcularTotal()); // Aplica regla de garantía
                cmd.Parameters.AddWithValue("@EnGarantia",         EnGarantia);
                cmd.Parameters.AddWithValue("@Fecha",              Fecha);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        /// <summary>
        /// Recupera todas las reparaciones con sus datos relacionados (JOIN múltiple).
        /// Soporta filtrado opcional por nombre de cliente o técnico.
        /// </summary>
        /// <param name="filtro">Texto a buscar en cliente, técnico o electrodoméstico (puede ser nulo o vacío).</param>
        public static List<Reparacion> ConsultarTodas(string filtro = null)
        {
            var lista = new List<Reparacion>();

            string sql = @"
                SELECT r.IdReparacion, r.IdTecnico, r.IdCliente, r.IdElectrodomestico,
                       r.Descripcion, r.Coste, r.EnGarantia, r.Fecha,
                       t.Nombre + ' ' + t.Apellidos          AS NombreTecnico,
                       c.Nombre + ' ' + c.Apellidos          AS NombreCliente,
                       e.Tipo + ' - ' + e.Modelo             AS DescripcionElectrodomestico,
                       e.Precio                              AS PrecioElectrodomestico
                FROM Reparaciones r
                INNER JOIN Tecnicos          t ON r.IdTecnico          = t.IdTecnico
                INNER JOIN Clientes          c ON r.IdCliente          = c.IdCliente
                INNER JOIN Electrodomesticos e ON r.IdElectrodomestico = e.IdElectrodomestico";

            // Filtrado dinámico si se proporciona texto de búsqueda
            if (!string.IsNullOrWhiteSpace(filtro))
            {
                sql += @" WHERE (t.Nombre + ' ' + t.Apellidos) LIKE @Filtro
                          OR    (c.Nombre + ' ' + c.Apellidos) LIKE @Filtro
                          OR    (e.Tipo   + ' - ' + e.Modelo)  LIKE @Filtro";
            }

            sql += " ORDER BY r.Fecha DESC";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                if (!string.IsNullOrWhiteSpace(filtro))
                    cmd.Parameters.AddWithValue("@Filtro", $"%{filtro}%");

                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new Reparacion
                        {
                            IdReparacion               = (int)     reader["IdReparacion"],
                            IdTecnico                  = (int)     reader["IdTecnico"],
                            IdCliente                  = (int)     reader["IdCliente"],
                            IdElectrodomestico         = (int)     reader["IdElectrodomestico"],
                            Descripcion                =            reader["Descripcion"].ToString(),
                            Coste                      = (decimal)  reader["Coste"],
                            EnGarantia                 = (bool)    reader["EnGarantia"],
                            Fecha                      = (DateTime) reader["Fecha"],
                            NombreTecnico              =            reader["NombreTecnico"].ToString(),
                            NombreCliente              =            reader["NombreCliente"].ToString(),
                            DescripcionElectrodomestico=            reader["DescripcionElectrodomestico"].ToString(),
                            PrecioElectrodomestico     = (decimal)  reader["PrecioElectrodomestico"]
                        });
                    }
                }
            }
            return lista;
        }

        /// <summary>
        /// Devuelve un DataTable con estadísticas globales del sistema
        /// para mostrar en el dashboard (Default.aspx).
        /// </summary>
        public static DataTable ObtenerEstadisticas()
        {
            const string sql = @"
                SELECT
                    (SELECT COUNT(*)            FROM Tecnicos)                         AS TotalTecnicos,
                    (SELECT COUNT(*)            FROM Clientes)                         AS TotalClientes,
                    (SELECT COUNT(*)            FROM Electrodomesticos)                AS TotalElectrodomesticos,
                    (SELECT COUNT(*)            FROM Reparaciones)                     AS TotalReparaciones,
                    (SELECT ISNULL(SUM(Coste),0) FROM Reparaciones)                   AS TotalFacturado,
                    (SELECT COUNT(*)            FROM Reparaciones WHERE EnGarantia=1)  AS ReparacionesGarantia,
                    (SELECT COUNT(*)            FROM Reparaciones WHERE EnGarantia=0)  AS ReparacionesPago";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var da   = new SqlDataAdapter(sql, conn))
            {
                var dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        /// <summary>
        /// Recupera las últimas N reparaciones para el panel de actividad reciente del dashboard.
        /// </summary>
        public static DataTable ObtenerRecientes(int cantidad = 5)
        {
            string sql = $@"
                SELECT TOP {cantidad}
                    r.IdReparacion,
                    c.Nombre + ' ' + c.Apellidos AS Cliente,
                    e.Tipo + ' - ' + e.Modelo    AS Electrodomestico,
                    r.Coste,
                    r.EnGarantia,
                    r.Fecha
                FROM Reparaciones r
                INNER JOIN Clientes          c ON r.IdCliente          = c.IdCliente
                INNER JOIN Electrodomesticos e ON r.IdElectrodomestico = e.IdElectrodomestico
                ORDER BY r.Fecha DESC";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var da   = new SqlDataAdapter(sql, conn))
            {
                var dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }
    }
}
