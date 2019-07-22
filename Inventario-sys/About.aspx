<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Demo_PDF.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2><%: Title %>.</h2>
    <h3>Sistema de Inventario simple.</h3>
    <p>Manejo de una operación CRUD para bases de datos</p>
    <p> + Altas de inventario</p>
    <p> + Bajas de inventario</p>
    <p> + Modificaciones de inventario</p>
    <p> + Consultas de información</p>
    <p>Exportación de datos usando la librería IText 7 a pdf</p>
</asp:Content>
