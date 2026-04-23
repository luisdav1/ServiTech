<%@ Page Title="Gestión de Datos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GestionDatos.aspx.cs" Inherits="WebApplication1.GestionDatos" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h2>
            <span class="glyphicon glyphicon-th-list"></span>
            Gestión de Datos
            <small>Técnicos, Clientes y Electrodomésticos</small>
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

    <%-- ═══ PESTAÑAS DE NAVEGACIÓN ═══ --%>
    <ul class="nav nav-tabs" role="tablist" style="margin-bottom:20px;">
        <li role="presentation" class="active">
            <a href="#tabTecnicos" aria-controls="tabTecnicos" role="tab" data-toggle="tab">
                <span class="glyphicon glyphicon-user"></span> Técnicos
            </a>
        </li>
        <li role="presentation">
            <a href="#tabClientes" aria-controls="tabClientes" role="tab" data-toggle="tab">
                <span class="glyphicon glyphicon-briefcase"></span> Clientes
            </a>
        </li>
        <li role="presentation">
            <a href="#tabElectrodomesticos" aria-controls="tabElectrodomesticos" role="tab" data-toggle="tab">
                <span class="glyphicon glyphicon-cog"></span> Electrodomésticos
            </a>
        </li>
    </ul>

    <div class="tab-content">

        <%-- ══════════════════════ TAB 1: TÉCNICOS ══════════════════════ --%>
        <div role="tabpanel" class="tab-pane active" id="tabTecnicos">
            <div class="row">

                <%-- Formulario de registro --%>
                <div class="col-md-5">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <span class="glyphicon glyphicon-plus"></span> Registrar Técnico
                            </h3>
                        </div>
                        <div class="panel-body">

                            <div class="form-group">
                                <label for="txtTecNIF">NIF <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtTecNIF" runat="server" CssClass="form-control"
                                    placeholder="Ej: 12345678A" MaxLength="20"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvTecNIF" runat="server"
                                    ControlToValidate="txtTecNIF"
                                    ValidationGroup="vgTecnico"
                                    CssClass="text-danger small"
                                    ErrorMessage="El NIF es obligatorio." Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revTecNIF" runat="server"
                                    ControlToValidate="txtTecNIF"
                                    ValidationGroup="vgTecnico"
                                    ValidationExpression="^\d{8}[A-Za-z]$"
                                    CssClass="text-danger small"
                                    ErrorMessage="Formato de NIF inválido (8 dígitos + letra)." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtTecNombre">Nombre <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtTecNombre" runat="server" CssClass="form-control"
                                    placeholder="Nombre del técnico" MaxLength="100"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvTecNombre" runat="server"
                                    ControlToValidate="txtTecNombre"
                                    ValidationGroup="vgTecnico"
                                    CssClass="text-danger small"
                                    ErrorMessage="El nombre es obligatorio." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtTecApellidos">Apellidos <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtTecApellidos" runat="server" CssClass="form-control"
                                    placeholder="Apellidos del técnico" MaxLength="150"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvTecApellidos" runat="server"
                                    ControlToValidate="txtTecApellidos"
                                    ValidationGroup="vgTecnico"
                                    CssClass="text-danger small"
                                    ErrorMessage="Los apellidos son obligatorios." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtTecCelular">Número Celular <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtTecCelular" runat="server" CssClass="form-control"
                                    placeholder="Ej: 3001234567" MaxLength="10"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvTecCelular" runat="server"
                                    ControlToValidate="txtTecCelular"
                                    ValidationGroup="vgTecnico"
                                    CssClass="text-danger small"
                                    ErrorMessage="El número celular es obligatorio." Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revTecCelular" runat="server"
                                    ControlToValidate="txtTecCelular"
                                    ValidationGroup="vgTecnico"
                                    ValidationExpression="^3\d{9}$"
                                    CssClass="text-danger small"
                                    ErrorMessage="Celular inválido (10 dígitos, debe empezar por 3)." Display="Dynamic" />
                            </div>

                            <asp:Button ID="btnRegistrarTecnico" runat="server" Text="Registrar Técnico"
                                CssClass="btn btn-primary btn-block"
                                ValidationGroup="vgTecnico"
                                OnClick="btnRegistrarTecnico_Click" />
                        </div>
                    </div>
                </div>

                <%-- Listado de técnicos --%>
                <div class="col-md-7">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <span class="glyphicon glyphicon-list"></span> Técnicos Registrados
                            </h3>
                        </div>
                        <div class="panel-body" style="padding:0;">
                            <asp:GridView ID="gvTecnicos" runat="server"
                                CssClass="table table-striped table-hover table-condensed"
                                AutoGenerateColumns="false"
                                GridLines="None"
                                EmptyDataText="No hay técnicos registrados."
                                EmptyDataRowStyle-CssClass="text-center text-muted">
                                <Columns>
                                    <asp:BoundField DataField="IdTecnico" HeaderText="#"         HeaderStyle-Width="40px" />
                                    <asp:BoundField DataField="NIF"       HeaderText="NIF" />
                                    <asp:BoundField DataField="Nombre"    HeaderText="Nombre" />
                                    <asp:BoundField DataField="Apellidos" HeaderText="Apellidos" />
                                    <asp:BoundField DataField="Celular"   HeaderText="Celular" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

            </div><%-- /row tecnicos --%>
        </div><%-- /tabTecnicos --%>


        <%-- ══════════════════════ TAB 2: CLIENTES ══════════════════════ --%>
        <div role="tabpanel" class="tab-pane" id="tabClientes">
            <div class="row">

                <%-- Formulario de registro --%>
                <div class="col-md-5">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <span class="glyphicon glyphicon-plus"></span> Registrar / Actualizar Cliente
                            </h3>
                        </div>
                        <div class="panel-body">

                            <div class="form-group">
                                <label for="txtCliId">Identificación (DNI/NIE) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtCliId" runat="server" CssClass="form-control"
                                    placeholder="Ej: 12345678Z" MaxLength="20"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCliId" runat="server"
                                    ControlToValidate="txtCliId"
                                    ValidationGroup="vgCliente"
                                    CssClass="text-danger small"
                                    ErrorMessage="La identificación es obligatoria." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtCliNombre">Nombre <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtCliNombre" runat="server" CssClass="form-control"
                                    placeholder="Nombre del cliente" MaxLength="100"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCliNombre" runat="server"
                                    ControlToValidate="txtCliNombre"
                                    ValidationGroup="vgCliente"
                                    CssClass="text-danger small"
                                    ErrorMessage="El nombre es obligatorio." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtCliApellidos">Apellidos <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtCliApellidos" runat="server" CssClass="form-control"
                                    placeholder="Apellidos del cliente" MaxLength="150"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCliApellidos" runat="server"
                                    ControlToValidate="txtCliApellidos"
                                    ValidationGroup="vgCliente"
                                    CssClass="text-danger small"
                                    ErrorMessage="Los apellidos son obligatorios." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtCliDireccion">Dirección <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtCliDireccion" runat="server" CssClass="form-control"
                                    placeholder="Dirección completa" MaxLength="250"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCliDireccion" runat="server"
                                    ControlToValidate="txtCliDireccion"
                                    ValidationGroup="vgCliente"
                                    CssClass="text-danger small"
                                    ErrorMessage="La dirección es obligatoria." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtCliCelular">Número Celular <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtCliCelular" runat="server" CssClass="form-control"
                                    placeholder="Ej: 3101234567" MaxLength="10"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCliCelular" runat="server"
                                    ControlToValidate="txtCliCelular"
                                    ValidationGroup="vgCliente"
                                    CssClass="text-danger small"
                                    ErrorMessage="El número celular es obligatorio." Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revCliCelular" runat="server"
                                    ControlToValidate="txtCliCelular"
                                    ValidationGroup="vgCliente"
                                    ValidationExpression="^3\d{9}$"
                                    CssClass="text-danger small"
                                    ErrorMessage="Celular inválido (10 dígitos, debe empezar por 3)." Display="Dynamic" />
                            </div>

                            <div class="row">
                                <div class="col-xs-6">
                                    <asp:Button ID="btnRegistrarCliente" runat="server" Text="Registrar"
                                        CssClass="btn btn-success btn-block"
                                        ValidationGroup="vgCliente"
                                        OnClick="btnRegistrarCliente_Click" />
                                </div>
                                <div class="col-xs-6">
                                    <asp:Button ID="btnActualizarCliente" runat="server" Text="Actualizar"
                                        CssClass="btn btn-warning btn-block"
                                        ValidationGroup="vgCliente"
                                        OnClick="btnActualizarCliente_Click" />
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <%-- Listado de clientes --%>
                <div class="col-md-7">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <span class="glyphicon glyphicon-list"></span> Clientes Registrados
                            </h3>
                        </div>
                        <div class="panel-body" style="padding:0;">
                            <asp:GridView ID="gvClientes" runat="server"
                                CssClass="table table-striped table-hover table-condensed"
                                AutoGenerateColumns="false"
                                GridLines="None"
                                EmptyDataText="No hay clientes registrados."
                                EmptyDataRowStyle-CssClass="text-center text-muted"
                                OnSelectedIndexChanged="gvClientes_SelectedIndexChanged"
                                DataKeyNames="IdCliente">
                                <Columns>
                                    <asp:BoundField DataField="IdCliente"      HeaderText="#"             HeaderStyle-Width="40px" />
                                    <asp:BoundField DataField="Identificacion" HeaderText="Identificación" />
                                    <asp:BoundField DataField="Nombre"         HeaderText="Nombre" />
                                    <asp:BoundField DataField="Apellidos"      HeaderText="Apellidos" />
                                    <asp:BoundField DataField="Celular"        HeaderText="Celular" />
                                    <asp:CommandField ShowSelectButton="true" SelectText="Cargar"
                                        ButtonType="Button"
                                        ControlStyle-CssClass="btn btn-xs btn-info" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

            </div><%-- /row clientes --%>
        </div><%-- /tabClientes --%>


        <%-- ══════════════════════ TAB 3: ELECTRODOMÉSTICOS ══════════════════════ --%>
        <div role="tabpanel" class="tab-pane" id="tabElectrodomesticos">
            <div class="row">

                <%-- Formulario de registro --%>
                <div class="col-md-5">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <span class="glyphicon glyphicon-plus"></span> Registrar Electrodoméstico
                            </h3>
                        </div>
                        <div class="panel-body">

                            <div class="form-group">
                                <label for="txtEleType">Tipo <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtEleType" runat="server" CssClass="form-control"
                                    placeholder="Ej: Lavadora, Frigorífico..." MaxLength="100"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEleType" runat="server"
                                    ControlToValidate="txtEleType"
                                    ValidationGroup="vgElectrodomestico"
                                    CssClass="text-danger small"
                                    ErrorMessage="El tipo es obligatorio." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtEleModelo">Modelo <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtEleModelo" runat="server" CssClass="form-control"
                                    placeholder="Ej: Samsung WW80T534" MaxLength="150"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEleModelo" runat="server"
                                    ControlToValidate="txtEleModelo"
                                    ValidationGroup="vgElectrodomestico"
                                    CssClass="text-danger small"
                                    ErrorMessage="El modelo es obligatorio." Display="Dynamic" />
                            </div>

                            <div class="form-group">
                                <label for="txtElePrecio">Precio (COP) <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtElePrecio" runat="server" CssClass="form-control"
                                    placeholder="Ej: 59999,99" MaxLength="12"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvElePrecio" runat="server"
                                    ControlToValidate="txtElePrecio"
                                    ValidationGroup="vgElectrodomestico"
                                    CssClass="text-danger small"
                                    ErrorMessage="El precio es obligatorio." Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revElePrecio" runat="server"
                                    ControlToValidate="txtElePrecio"
                                    ValidationGroup="vgElectrodomestico"
                                    ValidationExpression="^\d+([.,]\d{1,2})?$"
                                    CssClass="text-danger small"
                                    ErrorMessage="Formato de precio inválido (use punto o coma decimal)." Display="Dynamic" />
                            </div>

                            <asp:Button ID="btnRegistrarElectrodomestico" runat="server"
                                Text="Registrar Electrodoméstico"
                                CssClass="btn btn-warning btn-block"
                                ValidationGroup="vgElectrodomestico"
                                OnClick="btnRegistrarElectrodomestico_Click" />
                        </div>
                    </div>
                </div>

                <%-- Listado de electrodomésticos --%>
                <div class="col-md-7">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <span class="glyphicon glyphicon-list"></span> Electrodomésticos Registrados
                            </h3>
                        </div>
                        <div class="panel-body" style="padding:0;">
                            <asp:GridView ID="gvElectrodomesticos" runat="server"
                                CssClass="table table-striped table-hover table-condensed"
                                AutoGenerateColumns="false"
                                GridLines="None"
                                EmptyDataText="No hay electrodomésticos registrados."
                                EmptyDataRowStyle-CssClass="text-center text-muted">
                                <Columns>
                                    <asp:BoundField DataField="IdElectrodomestico" HeaderText="#"       HeaderStyle-Width="40px" />
                                    <asp:BoundField DataField="Tipo"               HeaderText="Tipo" />
                                    <asp:BoundField DataField="Modelo"             HeaderText="Modelo" />
                                    <asp:BoundField DataField="Precio"             HeaderText="Precio"
                                        DataFormatString="{0:C2}" HtmlEncode="false" />
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

            </div><%-- /row electrodomesticos --%>
        </div><%-- /tabElectrodomesticos --%>

    </div><%-- /tab-content --%>

    <%-- Script para activar la pestaña correcta tras un PostBack --%>
    <asp:HiddenField ID="hfTabActivo" runat="server" Value="tabTecnicos" />
    <script>
        $(function () {
            var tabActivo = $('#<%= hfTabActivo.ClientID %>').val();
            $('a[href="#' + tabActivo + '"]').tab('show');
            $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
                $('#<%= hfTabActivo.ClientID %>').val($(e.target).attr('href').replace('#', ''));
            });
        });
    </script>

</asp:Content>
