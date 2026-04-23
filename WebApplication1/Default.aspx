<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1._Default" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- ═══════════════════ CABECERA ═══════════════════ --%>
    <div class="page-header">
        <h2>
            <span class="glyphicon glyphicon-dashboard"></span>
            Panel de Control
            <small>Resumen del sistema</small>
        </h2>
    </div>

    <%-- ═══════════════════ MENSAJE DE ALERTA ═══════════════════ --%>
    <asp:Panel ID="pnlAlerta" runat="server" Visible="false"
        style="position:fixed; bottom:24px; left:50%; transform:translateX(-50%);
               z-index:9999; min-width:340px; max-width:600px; width:auto;">
        <div class="alert alert-danger alert-dismissible" role="alert"
             style="box-shadow:0 4px 16px rgba(0,0,0,.25); border-radius:6px; margin:0;">
            <button type="button" class="close" data-dismiss="alert" aria-label="Cerrar">
                <span aria-hidden="true">&times;</span>
            </button>
            <strong>Error:</strong>
            <asp:Label ID="lblError" runat="server"></asp:Label>
        </div>
    </asp:Panel>

    <%-- ═══════════════════ TARJETAS DE ESTADÍSTICAS ═══════════════════ --%>
    <div class="row">

        <div class="col-md-2 col-sm-4 col-xs-12">
            <div class="panel panel-primary text-center">
                <div class="panel-body">
                    <span class="glyphicon glyphicon-user" style="font-size:2em;"></span>
                    <h2 class="margin-0">
                        <asp:Label ID="lblTotalTecnicos" runat="server" Text="0"></asp:Label>
                    </h2>
                    <p class="text-muted">Técnicos</p>
                </div>
                <div class="panel-footer">
                    <a href="GestionDatos" class="btn btn-xs btn-default">Ver todos</a>
                </div>
            </div>
        </div>

        <div class="col-md-2 col-sm-4 col-xs-12">
            <div class="panel panel-success text-center">
                <div class="panel-body">
                    <span class="glyphicon glyphicon-briefcase" style="font-size:2em;"></span>
                    <h2 class="margin-0">
                        <asp:Label ID="lblTotalClientes" runat="server" Text="0"></asp:Label>
                    </h2>
                    <p class="text-muted">Clientes</p>
                </div>
                <div class="panel-footer">
                    <a href="GestionDatos" class="btn btn-xs btn-default">Ver todos</a>
                </div>
            </div>
        </div>

        <div class="col-md-2 col-sm-4 col-xs-12">
            <div class="panel panel-warning text-center">
                <div class="panel-body">
                    <span class="glyphicon glyphicon-cog" style="font-size:2em;"></span>
                    <h2 class="margin-0">
                        <asp:Label ID="lblTotalElectrodomesticos" runat="server" Text="0"></asp:Label>
                    </h2>
                    <p class="text-muted">Electrodomésticos</p>
                </div>
                <div class="panel-footer">
                    <a href="GestionDatos" class="btn btn-xs btn-default">Ver todos</a>
                </div>
            </div>
        </div>

        <div class="col-md-2 col-sm-4 col-xs-12">
            <div class="panel panel-info text-center">
                <div class="panel-body">
                    <span class="glyphicon glyphicon-list-alt" style="font-size:2em;"></span>
                    <h2 class="margin-0">
                        <asp:Label ID="lblTotalReparaciones" runat="server" Text="0"></asp:Label>
                    </h2>
                    <p class="text-muted">Reparaciones</p>
                </div>
                <div class="panel-footer">
                    <a href="Historico" class="btn btn-xs btn-default">Ver histórico</a>
                </div>
            </div>
        </div>

        <div class="col-md-2 col-sm-4 col-xs-12">
            <div class="panel panel-danger text-center">
                <div class="panel-body">
                    <span style="font-size:2em;">(COP)</span>
                    <h2 class="margin-0" style="font-size:1.6em;">
                        <asp:Label ID="lblTotalFacturado" runat="server" Text="$ 0"></asp:Label>
                    </h2>
                    <p class="text-muted">Total Facturado</p>
                </div>
                <div class="panel-footer">
                    <a href="Historico" class="btn btn-xs btn-default">Ver detalle</a>
                </div>
            </div>
        </div>

        <div class="col-md-2 col-sm-4 col-xs-12">
            <div class="panel panel-default text-center">
                <div class="panel-body">
                    <span class="glyphicon glyphicon-ok-circle" style="font-size:2em; color:#5cb85c;"></span>
                    <h2 class="margin-0">
                        <asp:Label ID="lblReparacionesGarantia" runat="server" Text="0"></asp:Label>
                    </h2>
                    <p class="text-muted">En Garantía</p>
                </div>
                <div class="panel-footer">
                    <a href="Historico" class="btn btn-xs btn-default">Ver historial</a>
                </div>
            </div>
        </div>

    </div><%-- /row estadísticas --%>

    <%-- ═══════════════════ ACCIONES RÁPIDAS + ACTIVIDAD RECIENTE ═══════════════════ --%>
    <div class="row" style="margin-top:20px;">

        <%-- Acciones rápidas --%>
        <div class="col-md-4">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <span class="glyphicon glyphicon-flash"></span> Acciones Rápidas
                    </h3>
                </div>
                <div class="panel-body">
                    <div class="list-group">
                        <a href="RegistroReparacion" class="list-group-item">
                            <span class="glyphicon glyphicon-plus"></span>
                            &nbsp; Registrar nueva reparación
                        </a>
                        <a href="GestionDatos" class="list-group-item">
                            <span class="glyphicon glyphicon-user"></span>
                            &nbsp; Añadir técnico
                        </a>
                        <a href="GestionDatos" class="list-group-item">
                            <span class="glyphicon glyphicon-briefcase"></span>
                            &nbsp; Añadir cliente
                        </a>
                        <a href="GestionDatos" class="list-group-item">
                            <span class="glyphicon glyphicon-cog"></span>
                            &nbsp; Añadir electrodoméstico
                        </a>
                        <a href="Historico" class="list-group-item">
                            <span class="glyphicon glyphicon-search"></span>
                            &nbsp; Consultar histórico
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <%-- Actividad reciente --%>
        <div class="col-md-8">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <span class="glyphicon glyphicon-time"></span> Últimas Reparaciones
                    </h3>
                </div>
                <div class="panel-body" style="padding:0; overflow-x:auto;">
                    <asp:GridView ID="gvRecientes" runat="server"
                        CssClass="table table-striped table-hover table-condensed"
                        AutoGenerateColumns="false"
                        GridLines="None"
                        EmptyDataText="No hay reparaciones registradas aún."
                        EmptyDataRowStyle-CssClass="text-center text-muted">
                        <Columns>
                            <asp:BoundField DataField="IdReparacion" HeaderText="#"       HeaderStyle-Width="40px" />
                            <asp:BoundField DataField="Cliente"      HeaderText="Cliente" />
                            <asp:BoundField DataField="Electrodomestico" HeaderText="Electrodoméstico" />
                            <asp:BoundField DataField="Coste"        HeaderText="Coste"  DataFormatString="{0:C2}" />
                            <asp:TemplateField HeaderText="Garantía">
                                <ItemTemplate>
                                    <asp:Label runat="server"
                                        Text='<%# (bool)Eval("EnGarantia") ? "Sí" : "No" %>'
                                        CssClass='<%# (bool)Eval("EnGarantia") ? "label label-success" : "label label-default" %>'>
                                    </asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="panel-footer text-right">
                    <a href="Historico" class="btn btn-sm btn-default">
                        Ver historial completo
                        <span class="glyphicon glyphicon-arrow-right"></span>
                    </a>
                </div>
            </div>
        </div>

    </div><%-- /row acciones --%>

</asp:Content>
