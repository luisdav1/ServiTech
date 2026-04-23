using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace WebApplication1.Models
{
    /// <summary>
    /// Entidad que representa a un cliente del servicio de reparaciones.
    /// Gestiona su persistencia, actualización y consulta en la base de datos.
    /// </summary>
    public class Cliente
    {
        public int    IdCliente      { get; set; }
        public string Identificacion { get; set; }
        public string Nombre         { get; set; }
        public string Apellidos      { get; set; }
        public string Direccion      { get; set; }
        public string Celular        { get; set; }

        /// <summary>Cadena de conexión leída desde Web.config.</summary>
        private static readonly string CadenaConexion =
            ConfigurationManager.ConnectionStrings["CadenaReparaciones"].ConnectionString;

        /// <summary>
        /// Inserta el cliente actual en la base de datos.
        /// Retorna true si la operación tuvo éxito.
        /// </summary>
        public bool Registrar()
        {
            const string sql = @"INSERT INTO Clientes (Identificacion, Nombre, Apellidos, Direccion, Celular)
                                 VALUES (@Identificacion, @Nombre, @Apellidos, @Direccion, @Celular)";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Identificacion", Identificacion);
                cmd.Parameters.AddWithValue("@Nombre",         Nombre);
                cmd.Parameters.AddWithValue("@Apellidos",      Apellidos);
                cmd.Parameters.AddWithValue("@Direccion",      Direccion);
                cmd.Parameters.AddWithValue("@Celular",        Celular);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        /// <summary>
        /// Actualiza los datos del cliente en la base de datos (excepto Identificacion).
        /// Retorna true si se actualizó al menos un registro.
        /// </summary>
        public bool ActualizarDatos()
        {
            const string sql = @"UPDATE Clientes
                                 SET Nombre    = @Nombre,
                                     Apellidos = @Apellidos,
                                     Direccion = @Direccion,
                                     Celular   = @Celular
                                 WHERE IdCliente = @IdCliente";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Nombre",     Nombre);
                cmd.Parameters.AddWithValue("@Apellidos",  Apellidos);
                cmd.Parameters.AddWithValue("@Direccion",  Direccion);
                cmd.Parameters.AddWithValue("@Celular",    Celular);
                cmd.Parameters.AddWithValue("@IdCliente",  IdCliente);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        /// <summary>
        /// Recupera todos los clientes registrados, ordenados alfabéticamente.
        /// </summary>
        public static List<Cliente> Consultar()
        {
            var lista = new List<Cliente>();
            const string sql = @"SELECT IdCliente, Identificacion, Nombre, Apellidos, Direccion, Celular
                                 FROM Clientes
                                 ORDER BY IdCliente";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new Cliente
                        {
                            IdCliente      = (int) reader["IdCliente"],
                            Identificacion =        reader["Identificacion"].ToString(),
                            Nombre         =        reader["Nombre"].ToString(),
                            Apellidos      =        reader["Apellidos"].ToString(),
                            Direccion      =        reader["Direccion"].ToString(),
                            Celular        =        reader["Celular"].ToString()
                        });
                    }
                }
            }
            return lista;
        }

        /// <summary>Devuelve el nombre completo del cliente (Nombre + Apellidos).</summary>
        public string NombreCompleto => $"{Nombre} {Apellidos}";
    }
}
