<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Demo_PDF._Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>


<asp:Content ID="Head" ContentPlaceHolderID="HeadContent" runat="server">
    
    <%-- Estilo custom solo a nivel de Página--%>
    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <link href="Content/bootstrap.css" rel="stylesheet" />

    <link href="Content/jquery.pnotify.css" rel="stylesheet" />
    <script src="Scripts/jquery.pnotify.js"></script>

    <style type="text/css">
        .customButton{
            margin-top: 20px;
        }

        .modalBackground{
            background-color: Gray;
            filter:alpha(opacity=50);
            opacity:0.7;
        }

        .pnlBackGround{
         
            top:10%;
            left:10px;
            text-align:center;
            background-color:White;
            border:solid 3px black;
        }

        .modalRow{
            margin-left: 10px;
        }
    </style>
        
</asp:Content>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
 
<asp:UpdatePanel ID="pnlInventario" runat="server" UpdateMode="Conditional">
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnIngresar" />
    </Triggers>
    <ContentTemplate>
    <div class="row">
        <div class="col-sm-12">
            <h2>Formulario de alta para inventario</h2>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-1">
            <p>Nombre:</p>
        </div>
        <div class="col-sm-8">
            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-1">
            <p>Descripción</p>
        </div>
        <div class="col-sm-8">
            <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-1">
            <p>Precio</p>
        </div>
        <div class="col-sm-2">
            <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
        <div class="col-sm-1">
            <p>Cantidad:</p>
        </div>
        <div class="col-sm-1">
            <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control"></asp:TextBox>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-1"></div>
        <div class="col-sm-4">
            <asp:Button runat="server" ID="btnIngresar" Text="Agregar al inventario" CssClass="btn btn-primary" OnClick="btnIngresar_Click" />
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-4">
            <asp:Label runat="server" ID="lblResultado"></asp:Label>
        </div>
    </div>
    <hr />
    <div class="row">
        <div class="col-sm-4">
            <h2 class="title">Lista de Inventario</h2>
        </div>
        <div class="col-sm-4">
            <asp:Button runat="server" ID="btnExportar" CssClass="btn btn-primary customButton" Text="Exportar a PDF" OnClick="btnExportar_Click" />
        </div>
    </div>
    <br />
    <asp:GridView runat="server" ID="gridInventarios" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="sqlDataSourceInventarios"
        CssClass="table" OnRowCommand="gridInventarios_RowCommand">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="No. Item" ReadOnly="True" SortExpression="id" />
            <asp:BoundField DataField="nombre" HeaderText="Nombre" SortExpression="nombre" />
            <asp:BoundField DataField="descripcion" HeaderText="Descripción" SortExpression="descripcion" />
            <asp:BoundField DataField="precio" HeaderText="Precio" SortExpression="precio" />
            <asp:BoundField DataField="cantidad" HeaderText="Cantidad" SortExpression="cantidad" />
            <asp:BoundField DataField="fecha_creado" HeaderText="Ultima actualización" SortExpression="fecha_creado" Visible="false" />
            <asp:TemplateField HeaderText="Acciones" >
                <ItemTemplate>
                    <asp:Button ID="btnEditar" Text="Editar" runat="server" CommandName="Editar" CommandArgument="<%# Container.DataItemIndex %>" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:SqlDataSource runat="server" ID="sqlDataSourceInventarios" 
        ConnectionString="<%$ ConnectionStrings:INVENTARIOConnectionString %>" 
        SelectCommand="SELECT * FROM [inventario]"></asp:SqlDataSource>
      
    <asp:Panel ID="PanelModal" runat="server" Width="500px" CssClass="pnlBackGround">
        <div class="row modalRow">
            <h3>Editar Información</h3>
        </div>
        <asp:Label runat="server" ID="lblEditId" Text="" Visible="false"></asp:Label>
        <div class="row modalRow">
            <div class="col-sm-2">
                <p>Nombre </p>
            </div>
            <div class="col-sm-3">
                <asp:TextBox runat="server" ID="txtEditNombre"></asp:TextBox>
            </div>
        </div>
        <br />
        <div class="row modalRow">
            <div class="col-sm-2">
                <p>Descripción </p>
            </div>
            <div class="col-sm-3">
                <asp:TextBox runat="server" ID="txtEditDescripcion"></asp:TextBox>
            </div>
        </div>
        <br />
        <div class="row modalRow">
            <div class="col-sm-2">
                <p>Precio </p>
            </div>
            <div class="col-sm-3">
                <asp:TextBox runat="server" ID="txtEditPrecio"></asp:TextBox>
            </div>
        </div>
        <br />
        <div class="row modalRow">
            <div class="col-sm-2">
                <p>Cantidad </p>
            </div>
            <div class="col-sm-3">
                <asp:TextBox runat="server" ID="txtEditCantidad"></asp:TextBox>
            </div>
        </div>
        <div class="row modalRow">
            <div class="col-sm-2">
                <asp:Button runat="server" ID="btnModalAceptar" Text="Aceptar" CssClass="btn btn-primary" OnClick="btnModalAceptar_Click" />
            </div>
            <div class="col-sm-2">
                <asp:Button runat="server" ID="btnModalCerrar" Text="Cerrar" CssClass="btn btn-default" />
            </div>
        </div>
    </asp:Panel>
    <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>

    <ajaxToolkit:ModalPopupExtender runat="server" ID="ModalPopup" TargetControlID="lnkFake" PopupControlID="PanelModal"
        OkControlID="btnModalAceptar" CancelControlID="btnModalCerrar" BackgroundCssClass="modalBackground">
    </ajaxToolkit:ModalPopupExtender>

</ContentTemplate>
</asp:UpdatePanel>

</asp:Content>
