using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplication1.Models;

namespace WebApplication1
{
    /// <summary>
    /// Página de gestión de datos maestros: Técnicos, Clientes y Electrodomésticos.
    /// Permite el registro y, en el caso de clientes, la actualización de datos.
    /// </summary>
    public partial class GestionDatos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                CargarGrids();
        }

        /// <summary>
        /// Carga los tres GridViews con los datos actuales de la base de datos.
        /// </summary>
        private void CargarGrids()
        {
            try
            {
                gvTecnicos.DataSource         = Tecnico.Consultar();
                gvTecnicos.DataBind();

                gvClientes.DataSource         = Cliente.Consultar();
                gvClientes.DataBind();

                gvElectrodomesticos.DataSource = Electrodomestico.Consultar();
                gvElectrodomesticos.DataBind();
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error al cargar los datos: {ex.Message}", "danger");
            }
        }

        // ── TÉCNICOS ──────────────────────────────────────────────────────────

        /// <summary>
        /// Registra un nuevo técnico con los datos del formulario.
        /// </summary>
        protected void btnRegistrarTecnico_Click(object sender, EventArgs e)
        {
            try
            {
                var tecnico = new Tecnico
                {
                    NIF       = txtTecNIF.Text.Trim().ToUpper(),
                    Nombre    = txtTecNombre.Text.Trim(),
                    Apellidos = txtTecApellidos.Text.Trim(),
                    Celular   = txtTecCelular.Text.Trim()
                };

                if (tecnico.Registrar())
                {
                    MostrarMensaje("Técnico registrado correctamente.", "success");
                    LimpiarFormularioTecnico();
                    hfTabActivo.Value = "tabTecnicos";
                    CargarGrids();
                }
                else
                {
                    MostrarMensaje("No se pudo registrar el técnico.", "warning");
                }
            }
            catch (Exception ex)
            {
                // El error más frecuente es violación de UNIQUE en NIF
                string detalle = ex.Message.Contains("UNIQUE") || ex.Message.Contains("unique")
                    ? "Ya existe un técnico con ese NIF."
                    : ex.Message;
                MostrarMensaje($"Error: {detalle}", "danger");
            }
        }

        // ── CLIENTES ──────────────────────────────────────────────────────────

        /// <summary>
        /// Registra un nuevo cliente con los datos del formulario.
        /// </summary>
        protected void btnRegistrarCliente_Click(object sender, EventArgs e)
        {
            try
            {
                var cliente = new Cliente
                {
                    Identificacion = txtCliId.Text.Trim().ToUpper(),
                    Nombre         = txtCliNombre.Text.Trim(),
                    Apellidos      = txtCliApellidos.Text.Trim(),
                    Direccion      = txtCliDireccion.Text.Trim(),
                    Celular        = txtCliCelular.Text.Trim()
                };

                if (cliente.Registrar())
                {
                    MostrarMensaje("Cliente registrado correctamente.", "success");
                    LimpiarFormularioCliente();
                    hfTabActivo.Value = "tabClientes";
                    CargarGrids();
                }
                else
                {
                    MostrarMensaje("No se pudo registrar el cliente.", "warning");
                }
            }
            catch (Exception ex)
            {
                string detalle = ex.Message.Contains("UNIQUE") || ex.Message.Contains("unique")
                    ? "Ya existe un cliente con esa identificación."
                    : ex.Message;
                MostrarMensaje($"Error: {detalle}", "danger");
            }
        }

        /// <summary>
        /// Actualiza los datos del cliente cuya identificación coincide con el campo del formulario.
        /// Implementa el método lógico ActualizarDatos() de la clase Cliente.
        /// </summary>
        protected void btnActualizarCliente_Click(object sender, EventArgs e)
        {
            // Para actualizar es necesario tener el Id del cliente cargado
            if (gvClientes.SelectedIndex < 0)
            {
                MostrarMensaje("Seleccione un cliente de la tabla para actualizar.", "warning");
                hfTabActivo.Value = "tabClientes";
                return;
            }

            try
            {
                int idCliente = (int)gvClientes.DataKeys[gvClientes.SelectedIndex].Value;

                var cliente = new Cliente
                {
                    IdCliente = idCliente,
                    Nombre    = txtCliNombre.Text.Trim(),
                    Apellidos = txtCliApellidos.Text.Trim(),
                    Direccion = txtCliDireccion.Text.Trim(),
                    Celular   = txtCliCelular.Text.Trim()
                };

                if (cliente.ActualizarDatos())
                {
                    MostrarMensaje("Datos del cliente actualizados correctamente.", "success");
                    LimpiarFormularioCliente();
                    hfTabActivo.Value = "tabClientes";
                    CargarGrids();
                }
                else
                {
                    MostrarMensaje("No se encontró el cliente para actualizar.", "warning");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error al actualizar: {ex.Message}", "danger");
            }
        }

        /// <summary>
        /// Carga los datos del cliente seleccionado en el GridView hacia el formulario.
        /// Se usa HtmlDecode porque GridView devuelve el texto con entidades HTML
        /// (p.ej. "ó" como "&#243;"), lo que dispararía la validación de Request.Form.
        /// </summary>
        protected void gvClientes_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow fila = gvClientes.SelectedRow;

            txtCliId.Text        = System.Web.HttpUtility.HtmlDecode(fila.Cells[1].Text);
            txtCliNombre.Text    = System.Web.HttpUtility.HtmlDecode(fila.Cells[2].Text);
            txtCliApellidos.Text = System.Web.HttpUtility.HtmlDecode(fila.Cells[3].Text);
            txtCliCelular.Text   = System.Web.HttpUtility.HtmlDecode(fila.Cells[4].Text);

            hfTabActivo.Value = "tabClientes";
            MostrarMensaje("Cliente cargado. Modifique los campos y pulse 'Actualizar'.", "info");
        }

        // ── ELECTRODOMÉSTICOS ─────────────────────────────────────────────────

        /// <summary>
        /// Registra un nuevo electrodoméstico con los datos del formulario.
        /// Convierte el precio a decimal aceptando tanto punto como coma decimal.
        /// </summary>
        protected void btnRegistrarElectrodomestico_Click(object sender, EventArgs e)
        {
            try
            {
                // Normaliza separador decimal para compatibilidad regional
                string precioTexto = txtElePrecio.Text.Trim().Replace(',', '.');
                decimal precio = decimal.Parse(precioTexto, System.Globalization.CultureInfo.InvariantCulture);

                var electro = new Electrodomestico
                {
                    Tipo   = txtEleType.Text.Trim(),
                    Modelo = txtEleModelo.Text.Trim(),
                    Precio = precio
                };

                if (electro.Registrar())
                {
                    MostrarMensaje("Electrodoméstico registrado correctamente.", "success");
                    LimpiarFormularioElectrodomestico();
                    hfTabActivo.Value = "tabElectrodomesticos";
                    CargarGrids();
                }
                else
                {
                    MostrarMensaje("No se pudo registrar el electrodoméstico.", "warning");
                }
            }
            catch (FormatException)
            {
                MostrarMensaje("El formato del precio no es válido.", "danger");
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error: {ex.Message}", "danger");
            }
        }

        // ── UTILIDADES PRIVADAS ───────────────────────────────────────────────

        /// <summary>
        /// Muestra un mensaje de alerta Bootstrap en la parte superior de la página.
        /// </summary>
        /// <param name="mensaje">Texto del mensaje.</param>
        /// <param name="tipo">Clase Bootstrap: success | danger | warning | info.</param>
        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible    = true;
            lblMensaje.Text       = mensaje;
            lblMensaje.CssClass   = $"alert alert-{tipo} alert-dismissible";
        }

        private void LimpiarFormularioTecnico()
        {
            txtTecNIF.Text       = string.Empty;
            txtTecNombre.Text    = string.Empty;
            txtTecApellidos.Text = string.Empty;
            txtTecCelular.Text   = string.Empty;
        }

        private void LimpiarFormularioCliente()
        {
            txtCliId.Text         = string.Empty;
            txtCliNombre.Text     = string.Empty;
            txtCliApellidos.Text  = string.Empty;
            txtCliDireccion.Text  = string.Empty;
            txtCliCelular.Text    = string.Empty;
        }

        private void LimpiarFormularioElectrodomestico()
        {
            txtEleType.Text   = string.Empty;
            txtEleModelo.Text = string.Empty;
            txtElePrecio.Text = string.Empty;
        }
    }
}
