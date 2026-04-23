using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace WebApplication1.Models
{
    /// <summary>
    /// Entidad que representa a un técnico del servicio de reparaciones.
    /// Gestiona su persistencia y consulta en la base de datos.
    /// </summary>
    public class Tecnico
    {
        public int    IdTecnico { get; set; }
        public string NIF       { get; set; }
        public string Nombre    { get; set; }
        public string Apellidos { get; set; }
        public string Celular   { get; set; }

        /// <summary>Cadena de conexión leída desde Web.config.</summary>
        private static readonly string CadenaConexion =
            ConfigurationManager.ConnectionStrings["CadenaReparaciones"].ConnectionString;

        /// <summary>
        /// Inserta el técnico actual en la base de datos.
        /// Retorna true si la operación tuvo éxito.
        /// </summary>
        public bool Registrar()
        {
            const string sql = @"INSERT INTO Tecnicos (NIF, Nombre, Apellidos, Celular)
                                 VALUES (@NIF, @Nombre, @Apellidos, @Celular)";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@NIF",       NIF);
                cmd.Parameters.AddWithValue("@Nombre",    Nombre);
                cmd.Parameters.AddWithValue("@Apellidos", Apellidos);
                cmd.Parameters.AddWithValue("@Celular",   Celular);

                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        /// <summary>
        /// Recupera todos los técnicos registrados, ordenados alfabéticamente.
        /// </summary>
        public static List<Tecnico> Consultar()
        {
            var lista = new List<Tecnico>();
            const string sql = @"SELECT IdTecnico, NIF, Nombre, Apellidos, Celular
                                 FROM Tecnicos
                                 ORDER BY IdTecnico";

            using (var conn = new SqlConnection(CadenaConexion))
            using (var cmd  = new SqlCommand(sql, conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        lista.Add(new Tecnico
                        {
                            IdTecnico = (int)    reader["IdTecnico"],
                            NIF       =          reader["NIF"].ToString(),
                            Nombre    =          reader["Nombre"].ToString(),
                            Apellidos =          reader["Apellidos"].ToString(),
                            Celular   =          reader["Celular"].ToString()
                        });
                    }
                }
            }
            return lista;
        }

        /// <summary>Devuelve el nombre completo del técnico (Nombre + Apellidos).</summary>
        public string NombreCompleto => $"{Nombre} {Apellidos}";
    }
}
