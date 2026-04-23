using System;
using System.Collections.Generic;
using System.Web.UI;
using WebApplication1.Models;

namespace WebApplication1
{
    /// <summary>
    /// Página para registrar nuevas reparaciones.
    /// Carga mediante DropDownList los técnicos, clientes y electrodomésticos disponibles,
    /// garantizando la integridad referencial antes de insertar.
    /// </summary>
    public partial class RegistroReparacion : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarDropDownLists();

                // Establece la fecha actual por defecto
                txtFecha.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtCoste.Text = "0.00";
                ActualizarResumen();
            }
        }

        /// <summary>
        /// Puebla los tres DropDownList con los datos de la base de datos.
        /// Si alguna entidad no tiene registros, muestra un aviso al usuario.
        /// </summary>
        private void CargarDropDownLists()
        {
            try
            {
                // ── Técnicos ───────────────────────────────────────────────────
                List<Tecnico> tecnicos = Tecnico.Consultar();
                ddlTecnico.Items.Clear();
                ddlTecnico.Items.Add(new System.Web.UI.WebControls.ListItem("-- Seleccione un técnico --", "0"));
                foreach (var t in tecnicos)
                    ddlTecnico.Items.Add(new System.Web.UI.WebControls.ListItem(
                        $"{t.Apellidos}, {t.Nombre} ({t.NIF})", t.IdTecnico.ToString()));

                if (tecnicos.Count == 0)
                    MostrarMensaje("No hay técnicos registrados. Regístrelos primero en Gestión de Datos.", "warning");

                // ── Clientes ───────────────────────────────────────────────────
                List<Cliente> clientes = Cliente.Consultar();
                ddlCliente.Items.Clear();
                ddlCliente.Items.Add(new System.Web.UI.WebControls.ListItem("-- Seleccione un cliente --", "0"));
                foreach (var c in clientes)
                    ddlCliente.Items.Add(new System.Web.UI.WebControls.ListItem(
                        $"{c.Apellidos}, {c.Nombre} ({c.Identificacion})", c.IdCliente.ToString()));

                if (clientes.Count == 0)
                    MostrarMensaje("No hay clientes registrados. Regístrelos primero en Gestión de Datos.", "warning");

                // ── Electrodomésticos ──────────────────────────────────────────
                List<Electrodomestico> electros = Electrodomestico.Consultar();
                ddlElectrodomestico.Items.Clear();
                ddlElectrodomestico.Items.Add(new System.Web.UI.WebControls.ListItem("-- Seleccione un electrodoméstico --", "0"));
                foreach (var el in electros)
                    ddlElectrodomestico.Items.Add(new System.Web.UI.WebControls.ListItem(
                        $"{el.Tipo} - {el.Modelo} ({el.Precio:C2})", el.IdElectrodomestico.ToString()));

                if (electros.Count == 0)
                    MostrarMensaje("No hay electrodomésticos registrados. Regístrelos primero en Gestión de Datos.", "warning");
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error al cargar los datos: {ex.Message}", "danger");
            }
        }

        /// <summary>
        /// Actualiza el label de precio cuando el usuario cambia el electrodoméstico seleccionado.
        /// </summary>
        protected void ddlElectrodomestico_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlElectrodomestico.SelectedValue == "0")
            {
                lblPrecioElectro.Text = "—";
            }
            else
            {
                // El precio está embebido en el texto del ítem entre paréntesis
                string texto = ddlElectrodomestico.SelectedItem.Text;
                int inicio = texto.LastIndexOf('(');
                int fin    = texto.LastIndexOf(')');
                lblPrecioElectro.Text = (inicio >= 0 && fin > inicio)
                    ? texto.Substring(inicio + 1, fin - inicio - 1)
                    : "—";
            }
            ActualizarResumen();
        }

        /// <summary>
        /// Al marcar/desmarcar garantía, deshabilita el campo de coste si aplica
        /// y actualiza el resumen del total a facturar.
        /// </summary>
        protected void chkGarantia_CheckedChanged(object sender, EventArgs e)
        {
            if (chkGarantia.Checked)
            {
                txtCoste.Text    = "0.00";
                txtCoste.Enabled = false;
            }
            else
            {
                txtCoste.Enabled = true;
            }
            ActualizarResumen();
        }

        /// <summary>
        /// Recalcula y muestra el total a facturar teniendo en cuenta si hay garantía.
        /// </summary>
        private void ActualizarResumen()
        {
            if (chkGarantia.Checked)
            {
                lblTotalCalculado.Text     = "0,00 € (garantía aplicada)";
                lblTotalCalculado.CssClass = "label label-success";
            }
            else if (decimal.TryParse(txtCoste.Text.Replace(',', '.'),
                System.Globalization.NumberStyles.Any,
                System.Globalization.CultureInfo.InvariantCulture,
                out decimal coste))
            {
                lblTotalCalculado.Text     = $"{coste:C2}";
                lblTotalCalculado.CssClass = "label label-info";
            }
            else
            {
                lblTotalCalculado.Text     = "—";
                lblTotalCalculado.CssClass = "label label-default";
            }
        }

        /// <summary>
        /// Guarda la reparación en la base de datos.
        /// Aplica la lógica de AsignarTecnico(), VerificarGarantia() y CalcularTotal().
        /// </summary>
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Valida selecciones de los DropDownList
                if (ddlTecnico.SelectedValue == "0" ||
                    ddlCliente.SelectedValue == "0" ||
                    ddlElectrodomestico.SelectedValue == "0")
                {
                    MostrarMensaje("Debe seleccionar técnico, cliente y electrodoméstico.", "warning");
                    return;
                }

                // Parsea la fecha
                if (!DateTime.TryParse(txtFecha.Text, out DateTime fecha))
                {
                    MostrarMensaje("La fecha introducida no es válida.", "warning");
                    return;
                }

                // Parsea el coste
                string costoTexto = txtCoste.Text.Trim().Replace(',', '.');
                if (!decimal.TryParse(costoTexto,
                    System.Globalization.NumberStyles.Any,
                    System.Globalization.CultureInfo.InvariantCulture,
                    out decimal coste))
                {
                    MostrarMensaje("El coste introducido no es válido.", "warning");
                    return;
                }

                // Construye la entidad Reparacion
                var reparacion = new Reparacion
                {
                    IdCliente          = int.Parse(ddlCliente.SelectedValue),
                    IdElectrodomestico = int.Parse(ddlElectrodomestico.SelectedValue),
                    Descripcion        = txtDescripcion.Text.Trim(),
                    Coste              = coste,
                    EnGarantia         = chkGarantia.Checked,
                    Fecha              = fecha
                };

                // Asigna el técnico mediante el método del modelo (UML: AsignarTecnico)
                reparacion.AsignarTecnico(int.Parse(ddlTecnico.SelectedValue));

                // VerificarGarantia() y CalcularTotal() se invocan dentro de Registrar()
                if (reparacion.Registrar())
                {
                    MostrarMensaje(
                        $"Reparación registrada correctamente. Total facturado: {reparacion.CalcularTotal():C2}",
                        "success");
                    LimpiarFormulario();
                }
                else
                {
                    MostrarMensaje("No se pudo guardar la reparación.", "warning");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error al guardar: {ex.Message}", "danger");
            }
        }

        /// <summary>
        /// Limpia todos los campos del formulario y vuelve a los valores iniciales.
        /// </summary>
        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
            pnlMensaje.Visible = false;
        }

        private void LimpiarFormulario()
        {
            CargarDropDownLists();
            txtDescripcion.Text  = string.Empty;
            txtCoste.Text        = "0.00";
            txtCoste.Enabled     = true;
            chkGarantia.Checked  = false;
            txtFecha.Text        = DateTime.Today.ToString("yyyy-MM-dd");
            lblPrecioElectro.Text = "—";
            ActualizarResumen();
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible  = true;
            lblMensaje.Text     = mensaje;
            lblMensaje.CssClass = $"alert alert-{tipo} alert-dismissible";
        }
    }
}
