<%@ Page Title="Nueva Reparación" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistroReparacion.aspx.cs" Inherits="WebApplication1.RegistroReparacion" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h2>
            <span class="glyphicon glyphicon-plus-sign"></span>
            Registro de Reparación
            <small>Complete los datos para crear una nueva reparación</small>
        </h2>
    </div>

    <%-- ═══ MENSAJES DE RETROALIMENTACIÓN ═══ --%>
    <asp:Panel ID="pnlMensaje" runat="server" Visible="false"
        style="position:fixed; bottom:24px; left:50%; transform:translateX(-50%);
               z-index:9999; min-width:340px; max-width:600px; width:auto;">
        <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-block alert-dismissible"
            style="display:block; box-shadow:0 4px 16px rgba(0,0,0,.25); border-radius:6px; margin:0;">
        </asp:Label>
    </asp:Panel>

    <div class="row">
        <div class="col-md-8 col-md-offset-2">

            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <span class="glyphicon glyphicon-wrench"></span> Datos de la Reparación
                    </h3>
                </div>
                <div class="panel-body">

                    <%-- ── Técnico asignado ── --%>
                    <div class="form-group">
                        <label for="ddlTecnico">
                            <span class="glyphicon glyphicon-user"></span>
                            Técnico Asignado <span class="text-danger">*</span>
                        </label>
                        <asp:DropDownList ID="ddlTecnico" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvTecnico" runat="server"
                            ControlToValidate="ddlTecnico"
                            ValidationGroup="vgReparacion"
                            InitialValue="0"
                            CssClass="text-danger small"
                            ErrorMessage="Debe seleccionar un técnico." Display="Dynamic" />
                    </div>

                    <%-- ── Cliente ── --%>
                    <div class="form-group">
                        <label for="ddlCliente">
                            <span class="glyphicon glyphicon-briefcase"></span>
                            Cliente <span class="text-danger">*</span>
                        </label>
                        <asp:DropDownList ID="ddlCliente" runat="server" CssClass="form-control">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCliente" runat="server"
                            ControlToValidate="ddlCliente"
                            ValidationGroup="vgReparacion"
                            InitialValue="0"
                            CssClass="text-danger small"
                            ErrorMessage="Debe seleccionar un cliente." Display="Dynamic" />
                    </div>

                    <%-- ── Electrodoméstico ── --%>
                    <div class="form-group">
                        <label for="ddlElectrodomestico">
                            <span class="glyphicon glyphicon-cog"></span>
                            Electrodoméstico <span class="text-danger">*</span>
                        </label>
                        <asp:DropDownList ID="ddlElectrodomestico" runat="server" CssClass="form-control"
                            AutoPostBack="true" OnSelectedIndexChanged="ddlElectrodomestico_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvElectrodomestico" runat="server"
                            ControlToValidate="ddlElectrodomestico"
                            ValidationGroup="vgReparacion"
                            InitialValue="0"
                            CssClass="text-danger small"
                            ErrorMessage="Debe seleccionar un electrodoméstico." Display="Dynamic" />
                        <%-- Información del precio del electrodoméstico seleccionado --%>
                        <small class="text-muted">
                            Precio del electrodoméstico:
                            <strong>
                                <asp:Label ID="lblPrecioElectro" runat="server" Text="—"></asp:Label>
                            </strong>
                        </small>
                    </div>

                    <hr />

                    <%-- ── Descripción ── --%>
                    <div class="form-group">
                        <label for="txtDescripcion">
                            Descripción de la avería <span class="text-danger">*</span>
                        </label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="4"
                            placeholder="Describa el problema detectado y la reparación realizada..."
                            MaxLength="500"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server"
                            ControlToValidate="txtDescripcion"
                            ValidationGroup="vgReparacion"
                            CssClass="text-danger small"
                            ErrorMessage="La descripción es obligatoria." Display="Dynamic" />
                    </div>

                    <%-- ── En garantía (checkbox) ── --%>
                    <div class="form-group">
                        <div class="checkbox">
                            <label>
                                <asp:CheckBox ID="chkGarantia" runat="server"
                                    AutoPostBack="true"
                                    OnCheckedChanged="chkGarantia_CheckedChanged" />
                                <strong>Reparación cubierta por garantía</strong>
                                <small class="text-muted">(el coste se establecerá en $ 0)</small>
                            </label>
                        </div>
                    </div>

                    <%-- ── Coste ── --%>
                    <div class="form-group">
                        <label for="txtCoste">
                            Coste de la reparación (COP) <span class="text-danger">*</span>
                        </label>
                        <div class="input-group">
                            <asp:TextBox ID="txtCoste" runat="server" CssClass="form-control"
                                placeholder="Ej: 65000,99" MaxLength="12"></asp:TextBox>
                            <span class="input-group-addon">$</span>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvCoste" runat="server"
                            ControlToValidate="txtCoste"
                            ValidationGroup="vgReparacion"
                            CssClass="text-danger small"
                            ErrorMessage="El coste es obligatorio." Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revCoste" runat="server"
                            ControlToValidate="txtCoste"
                            ValidationGroup="vgReparacion"
                            ValidationExpression="^\d+([.,]\d{1,2})?$"
                            CssClass="text-danger small"
                            ErrorMessage="Formato de coste inválido." Display="Dynamic" />
                    </div>

                    <%-- ── Fecha ── --%>
                    <div class="form-group">
                        <label for="txtFecha">
                            Fecha de reparación <span class="text-danger">*</span>
                        </label>
                        <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control"
                            TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFecha" runat="server"
                            ControlToValidate="txtFecha"
                            ValidationGroup="vgReparacion"
                            CssClass="text-danger small"
                            ErrorMessage="La fecha es obligatoria." Display="Dynamic" />
                    </div>

                    <hr />

                    <%-- ── Resumen calculado ── --%>
                    <div class="well well-sm">
                        <strong>Resumen:</strong>
                        Total a facturar:
                        <asp:Label ID="lblTotalCalculado" runat="server"
                            CssClass="label label-info" Text="—" style="font-size:1em;"></asp:Label>
                        <span class="text-muted small">
                            (se recalcula al marcar/desmarcar garantía)
                        </span>
                    </div>

                    <%-- ── Botones de acción ── --%>
                    <div class="row">
                        <div class="col-sm-6">
                            <asp:Button ID="btnGuardar" runat="server" Text="Guardar Reparación"
                                CssClass="btn btn-info btn-block btn-lg"
                                ValidationGroup="vgReparacion"
                                OnClick="btnGuardar_Click" />
                        </div>
                        <div class="col-sm-6">
                            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar Formulario"
                                CssClass="btn btn-default btn-block btn-lg"
                                CausesValidation="false"
                                OnClick="btnLimpiar_Click" />
                        </div>
                    </div>

                </div><%-- /panel-body --%>
            </div><%-- /panel --%>

        </div><%-- /col --%>
    </div><%-- /row --%>

</asp:Content>
