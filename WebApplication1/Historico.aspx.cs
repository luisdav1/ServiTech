using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1.Models;

namespace WebApplication1
{
    /// <summary>
    /// Página de histórico: muestra todas las reparaciones en un GridView paginado
    /// con soporte de búsqueda/filtrado por técnico, cliente o electrodoméstico.
    /// </summary>
    public partial class Historico : Page
    {
        /// <summary>
        /// Almacena el filtro actual en ViewState para mantenerlo entre paginaciones.
        /// </summary>
        private string FiltroActual
        {
            get => ViewState["FiltroHistorico"] as string ?? string.Empty;
            set => ViewState["FiltroHistorico"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                CargarGridHistorico(string.Empty);
        }

        /// <summary>
        /// Carga el GridView con las reparaciones filtradas y actualiza el resumen.
        /// </summary>
        /// <param name="filtro">Texto de búsqueda; vacío para mostrar todo.</param>
        private void CargarGridHistorico(string filtro)
        {
            try
            {
                List<Reparacion> reparaciones = Reparacion.ConsultarTodas(filtro);

                gvHistorico.DataSource = reparaciones;
                gvHistorico.DataBind();

                // ── Resumen financiero ─────────────────────────────────────────
                int     total     = reparaciones.Count;
                decimal importe   = 0m;
                int     garantia  = 0;

                foreach (var r in reparaciones)
                {
                    importe  += r.Coste;
                    if (r.EnGarantia) garantia++;
                }

                lblResumenTotal.Text    = total.ToString();
                lblResumenImporte.Text  = importe.ToString("C2");
                lblResumenGarantia.Text = garantia.ToString();

                // Indicador de resultados
                lblContador.Text = filtro.Length > 0
                    ? $"{total} resultado(s) para &quot;{filtro}&quot;"
                    : $"{total} reparaciones en total";
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error al cargar el histórico: {ex.Message}", "danger");
            }
        }

        /// <summary>
        /// Ejecuta la búsqueda con el texto introducido por el usuario.
        /// Reinicia la página del GridView a la primera.
        /// </summary>
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            FiltroActual           = txtBuscar.Text.Trim();
            gvHistorico.PageIndex  = 0;
            CargarGridHistorico(FiltroActual);
        }

        /// <summary>
        /// Elimina el filtro y muestra todas las reparaciones.
        /// </summary>
        protected void btnLimpiarFiltro_Click(object sender, EventArgs e)
        {
            FiltroActual          = string.Empty;
            txtBuscar.Text        = string.Empty;
            gvHistorico.PageIndex = 0;
            CargarGridHistorico(string.Empty);
            pnlMensaje.Visible    = false;
        }

        /// <summary>
        /// Gestiona el cambio de página del GridView manteniendo el filtro activo.
        /// </summary>
        protected void gvHistorico_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvHistorico.PageIndex = e.NewPageIndex;
            CargarGridHistorico(FiltroActual);
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible  = true;
            lblMensaje.Text     = mensaje;
            lblMensaje.CssClass = $"alert alert-{tipo}";
        }
    }
}
