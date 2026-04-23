using System;
using System.Data;
using System.Web.UI;
using WebApplication1.Models;

namespace WebApplication1
{
    /// <summary>
    /// Página de inicio: Dashboard con estadísticas globales del sistema
    /// y las últimas reparaciones registradas.
    /// </summary>
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                CargarDashboard();
        }

        /// <summary>
        /// Carga las estadísticas y la actividad reciente desde la base de datos.
        /// Captura excepciones de conexión para mostrar un mensaje amigable.
        /// </summary>
        private void CargarDashboard()
        {
            try
            {
                // ── Estadísticas globales ──────────────────────────────────────
                DataTable stats = Reparacion.ObtenerEstadisticas();

                if (stats.Rows.Count > 0)
                {
                    DataRow fila = stats.Rows[0];

                    lblTotalTecnicos.Text           = fila["TotalTecnicos"].ToString();
                    lblTotalClientes.Text           = fila["TotalClientes"].ToString();
                    lblTotalElectrodomesticos.Text  = fila["TotalElectrodomesticos"].ToString();
                    lblTotalReparaciones.Text       = fila["TotalReparaciones"].ToString();
                    lblReparacionesGarantia.Text    = fila["ReparacionesGarantia"].ToString();

                    // Formatea el total facturado como moneda
                    decimal totalFacturado = Convert.ToDecimal(fila["TotalFacturado"]);
                    lblTotalFacturado.Text = totalFacturado.ToString("C2");
                }

                // ── Actividad reciente (últimas 5 reparaciones) ────────────────
                DataTable recientes = Reparacion.ObtenerRecientes(5);
                gvRecientes.DataSource = recientes;
                gvRecientes.DataBind();
            }
            catch (Exception ex)
            {
                // Muestra el error sin detener la carga de la página
                pnlAlerta.Visible = true;
                lblError.Text = $"No se pudo conectar con la base de datos. Verifique la cadena de conexión. Detalle: {ex.Message}";
            }
        }
    }
}
