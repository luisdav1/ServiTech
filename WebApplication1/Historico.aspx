<%@ Page Title="Histórico de Reparaciones" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Historico.aspx.cs" Inherits="WebApplication1.Historico" ResponseEncoding="utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <h2>
            <span class="glyphicon glyphicon-list-alt"></span>
            Histórico de Reparaciones
            <small>Consulta y filtrado del registro completo</small>
        </h2>
    </div>

    <%-- ═══ MENSAJES ═══ --%>
    <asp:Panel ID="pnlMensaje" runat="server" Visible="false"
        style="position:fixed; bottom:24px; left:50%; transform:translateX(-50%);
               z-index:9999; min-width:340px; max-width:600px; width:auto;">
        <asp:Label ID="lblMensaje" runat="server" CssClass="alert alert-block alert-dismissible"
            style="display:block; box-shadow:0 4px 16px rgba(0,0,0,.25); border-radius:6px; margin:0;">
        </asp:Label>
    </asp:Panel>

    <%-- ═══ BARRA DE BÚSQUEDA Y FILTROS ═══ --%>
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="row">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-search"></span>
                        </span>
                        <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control"
                            placeholder="Buscar por técnico, cliente o electrodoméstico..."
                            MaxLength="100"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar"
                        CssClass="btn btn-primary btn-block"
                        OnClick="btnBuscar_Click" />
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnLimpiarFiltro" runat="server" Text="Mostrar todos"
                        CssClass="btn btn-default btn-block"
                        OnClick="btnLimpiarFiltro_Click" />
                </div>
                <div class="col-md-2 text-right" style="padding-top:7px;">
                    <asp:Label ID="lblContador" runat="server" CssClass="text-muted">
                    </asp:Label>
                </div>
            </div>
        </div>
    </div>

    <%-- ═══ GRID DE REPARACIONES ═══ --%>
    <div class="panel panel-default">
        <div class="panel-body" style="padding:0; overflow-x:auto;">
            <asp:GridView ID="gvHistorico" runat="server"
                CssClass="table table-striped table-hover table-bordered"
                AutoGenerateColumns="false"
                GridLines="None"
                AllowPaging="true"
                PageSize="10"
                OnPageIndexChanging="gvHistorico_PageIndexChanging"
                EmptyDataText="No se encontraron reparaciones."
                EmptyDataRowStyle-CssClass="text-center text-muted"
                DataKeyNames="IdReparacion">

                <PagerStyle CssClass="pagination-compat" HorizontalAlign="Center" />
                <PagerSettings Mode="NumericFirstLast" FirstPageText="&laquo;" LastPageText="&raquo;" PageButtonCount="5" />

                <HeaderStyle CssClass="info" />

                <Columns>
                    <asp:BoundField DataField="IdReparacion" HeaderText="#"
                        HeaderStyle-Width="45px" ItemStyle-CssClass="text-center text-muted" />

                    <asp:BoundField DataField="Fecha" HeaderText="Fecha"
                        DataFormatString="{0:dd/MM/yyyy}" HeaderStyle-Width="90px"
                        ItemStyle-CssClass="text-center" />

                    <asp:BoundField DataField="NombreCliente"               HeaderText="Cliente" />
                    <asp:BoundField DataField="NombreTecnico"               HeaderText="Técnico" />
                    <asp:BoundField DataField="DescripcionElectrodomestico" HeaderText="Electrodoméstico" />

                    <asp:BoundField DataField="Descripcion" HeaderText="Descripción avería"
                        ItemStyle-CssClass="text-muted small" />

                    <asp:BoundField DataField="Coste" HeaderText="Coste"
                        DataFormatString="{0:C2}" HtmlEncode="false"
                        HeaderStyle-Width="80px" ItemStyle-CssClass="text-right" />

                    <%-- Columna de garantía con badge de color --%>
                    <asp:TemplateField HeaderText="Garantía" HeaderStyle-Width="80px"
                        ItemStyle-CssClass="text-center">
                        <ItemTemplate>
                            <asp:Label runat="server"
                                Text='<%# (bool)Eval("EnGarantia") ? "Sí" : "No" %>'
                                CssClass='<%# (bool)Eval("EnGarantia") ? "label label-success" : "label label-default" %>'>
                            </asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>

        <%-- Resumen financiero al pie --%>
        <div class="panel-footer">
            <div class="row text-center">
                <div class="col-sm-4">
                    <strong>Total reparaciones:</strong>
                    <asp:Label ID="lblResumenTotal" runat="server" CssClass="text-info" Text="0"></asp:Label>
                </div>
                <div class="col-sm-4">
                    <strong>Importe facturado:</strong>
                    <asp:Label ID="lblResumenImporte" runat="server" CssClass="text-success" Text="$ 0"></asp:Label>
                </div>
                <div class="col-sm-4">
                    <strong>En garantía:</strong>
                    <asp:Label ID="lblResumenGarantia" runat="server" CssClass="text-warning" Text="0"></asp:Label>
                </div>
            </div>
        </div>
    </div>

    <%-- Estilo de paginación compatible con Bootstrap 3 --%>
    <style>
        .pagination-compat table { display: inline-block; }
        .pagination-compat td    { padding: 2px 4px; }
        .pagination-compat a,
        .pagination-compat span  {
            display: inline-block;
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 3px;
            color: #337ab7;
            text-decoration: none;
            background: #fff;
        }
        .pagination-compat span  { background: #337ab7; color: #fff; }
    </style>

</asp:Content>
