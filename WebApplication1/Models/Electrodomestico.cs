using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace WebApplication1.Models
{
    /// <summary>
    /// Entidad que representa un electrodoméstico del catálogo del servicio técnico.
    /// Gestiona su persistencia y consulta en la base de datos.
    /// </summary>
    public class Electrodomestico
    {
        public int     IdElectrodomestico { get; set; }
        public string  Tipo               { get; set; }
        public string  Modelo             { get; set; }
        public decimal Precio             { get; set; }

        /// <summary>Cadena de conexión leída desde Web.config.</summary>
        private static readonly string CadenaConexion =
            ConfigurationManager.ConnectionStrings["CadenaReparaciones"].ConnectionString;

        /// <summary>
        /// Inserta el electrodoméstico actual en la base de datos.
        /// Retorna true si la operación tuvo éxito.
        /// </summary>
        public bool Registrar()
        {
            const string sql = @"INSERT INTO Electrodomesticos (Tipo, Modelo, Precio)
                                 VALUES (@Tipo, @Modelo, @Precio)";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Tipo",   Tipo);
                cmd.Parameters.AddWithValue("@Modelo", Modelo);
                cmd.Parameters.AddWithValue("@Precio", Precio);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        /// <summary>
        /// Recupera todos los electrodomésticos registrados, ordenados por tipo y modelo.
        /// </summary>
        public static List<Electrodomestico> Consultar()
        {
            var lista = new List<Electrodomestico>();
            const string sql = @"SELECT IdElectrodomestico, Tipo, Modelo, Precio
                                 FROM Electrodomesticos
                                 ORDER BY IdElectrodomestico";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new Electrodomestico
                        {
                            IdElectrodomestico = (int)     reader["IdElectrodomestico"],
                            Tipo               =            reader["Tipo"].ToString(),
                            Modelo             =            reader["Modelo"].ToString(),
                            Precio             = (decimal)  reader["Precio"]
                        });
                    }
                }
            }
            return lista;
        }

        /// <summary>Descripción completa: Tipo - Modelo (Precio COP).</summary>
        public string Descripcion => $"{Tipo} - {Modelo} ({Precio:C2})";
    }
}
