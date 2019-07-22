using iText.IO.Font.Constants;
using iText.Kernel.Colors;
using iText.Kernel.Font;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.Layout.Properties;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Demo_PDF
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PanelModal.Style.Value = "display: none;";
        }

        protected void btnIngresar_Click(object sender, EventArgs e)
        {
            /* Recoger Informacion para el Store Procedure */

            String nombre = txtNombre.Text;
            String descripcion = txtDescripcion.Text;
            Decimal precio = 0.0M;
            int cantidad = 0;
            int idProducto = 0;

            try
            {
                precio = Decimal.Parse(txtPrecio.Text);
            } catch(Exception ex)
            {
                Console.WriteLine("Error al convertir precio a decimal " + ex.Message);
                lblResultado.Text = "Error al convertir precio a decimal " + ex.Message;
            }

            try
            {
                cantidad = Int16.Parse(txtCantidad.Text);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al convertir catidad a Int32 " + ex.Message);
                lblResultado.Text = "Error al convertir catidad a Int32 " + ex.Message;
            }


            /* Llamar al SP de la base de datos */
            String conexion = System.Configuration.ConfigurationManager.ConnectionStrings["INVENTARIOConnectionString"].ConnectionString;
            SqlConnection sql = new SqlConnection(conexion);

            SqlCommand sqlCmd = new SqlCommand("add_inventario", sql);

            SqlParameter pi_nombre = new SqlParameter("@pi_nombre", SqlDbType.VarChar);
            SqlParameter pi_descripcion = new SqlParameter("@pi_descripcion", SqlDbType.VarChar);
            SqlParameter pi_precio = new SqlParameter("@pi_precio", SqlDbType.Decimal);
            SqlParameter pi_cantidad = new SqlParameter("@pi_cantidad", SqlDbType.Int);
            SqlParameter po_id = new SqlParameter("@po_id", SqlDbType.Int);

            po_id.Direction = ParameterDirection.Output;

            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add(pi_nombre).Value = nombre;
            sqlCmd.Parameters.Add(pi_descripcion).Value = descripcion;
            sqlCmd.Parameters.Add(pi_precio).Value = precio;
            sqlCmd.Parameters.Add(pi_cantidad).Value = cantidad;
            sqlCmd.Parameters.Add(po_id);

            sql.Open();
            int filas = sqlCmd.ExecuteNonQuery();

            try
            {
                idProducto = Int16.Parse(sqlCmd.Parameters["@po_id"].Value.ToString());
                lblResultado.Text = "Producto registrado con el Id " + idProducto;
            }
            catch(FormatException ex)
            {
                Console.WriteLine(ex.Message);
                lblResultado.Text = ex.Message;
            }

            refrescarInventario();
            
        }

        private void refrescarInventario()
        {
            
            sqlDataSourceInventarios.DataBind();
            gridInventarios.DataBind();
        }

        protected void gridInventarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName =="Editar")
            {
                int rowIndex = Convert.ToInt16(e.CommandArgument);
                GridViewRow row = gridInventarios.Rows[rowIndex];

                // int id = Convert.ToInt16((row.FindControl("id") as Label).Text);
                // String nombre = (row.FindControl("nombre") as TextBox).Text;
                // String descripcion = (row.FindControl("descripcion") as TextBox).Text;
                // String cantidad = (row.FindControl("cantidad") as TextBox).Text;
                // String precio = (row.FindControl("precio") as TextBox).Text;

                int id = Convert.ToInt16(row.Cells[0].Text);
                String nombre = row.Cells[1].Text;
                String descripcion = row.Cells[2].Text;
                String precio = row.Cells[3].Text;
                String cantidad = row.Cells[4].Text;

                lblEditId.Text = "" + id;
                txtEditNombre.Text = nombre;
                txtEditDescripcion.Text = descripcion;
                txtEditCantidad.Text = cantidad;
                txtEditPrecio.Text = precio;

                ModalPopup.Show();
            }
        }

        protected void btnModalAceptar_Click(object sender, EventArgs e)
        {
            /* Actalizar los datos del panel */
            /* Recoger Informacion para el Store Procedure */

            String nombre = txtEditNombre.Text;
            String descripcion = txtEditDescripcion.Text;
            Decimal precio = 0.0M;
            int cantidad = 0;
            int idProducto = 0;

            try
            {
                precio = Decimal.Parse(txtPrecio.Text);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al convertir precio a decimal " + ex.Message);
                lblResultado.Text = "Error al convertir precio a decimal " + ex.Message;
            }

            try
            {
                cantidad = Int16.Parse(txtCantidad.Text);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al convertir catidad a Int32 " + ex.Message);
                lblResultado.Text = "Error al convertir catidad a Int32 " + ex.Message;
            }


            /* Llamar al SP de la base de datos */
            String conexion = System.Configuration.ConfigurationManager.ConnectionStrings["INVENTARIOConnectionString"].ConnectionString;
            SqlConnection sql = new SqlConnection(conexion);

            SqlCommand sqlCmd = new SqlCommand("add_inventario", sql);

            SqlParameter pi_nombre = new SqlParameter("@pi_nombre", SqlDbType.VarChar);
            SqlParameter pi_descripcion = new SqlParameter("@pi_descripcion", SqlDbType.VarChar);
            SqlParameter pi_precio = new SqlParameter("@pi_precio", SqlDbType.Decimal);
            SqlParameter pi_cantidad = new SqlParameter("@pi_cantidad", SqlDbType.Int);
            SqlParameter po_id = new SqlParameter("@po_id", SqlDbType.Int);

            po_id.Direction = ParameterDirection.Output;

            sqlCmd.CommandType = CommandType.StoredProcedure;
            sqlCmd.Parameters.Add(pi_nombre).Value = nombre;
            sqlCmd.Parameters.Add(pi_descripcion).Value = descripcion;
            sqlCmd.Parameters.Add(pi_precio).Value = precio;
            sqlCmd.Parameters.Add(pi_cantidad).Value = cantidad;
            sqlCmd.Parameters.Add(po_id);

            sql.Open();
            int filas = sqlCmd.ExecuteNonQuery();

            try
            {
                idProducto = Int16.Parse(sqlCmd.Parameters["@po_id"].Value.ToString());
                lblResultado.Text = "Producto registrado con el Id " + idProducto;
            }
            catch (FormatException ex)
            {
                Console.WriteLine(ex.Message);
                lblResultado.Text = ex.Message;
            }

            refrescarInventario();
        }

        protected void btnExportar_Click(object sender, EventArgs e)
        {
            String filepath = Server.MapPath("documento.pdf");
            PdfWriter writer = new PdfWriter(filepath);
            PdfDocument pdf = new PdfDocument(writer);
            Document doc = new Document(pdf);
            PdfFont f = PdfFontFactory.CreateFont(StandardFonts.HELVETICA);
            
            Paragraph p = new Paragraph("Lista de Inventario");
            p.SetFont(f);
            //doc.Add(p);

            float[] columnWidths = { 1, 5, 5, 5, 5 };
            iText.Layout.Element.Table table = new iText.Layout.Element.Table(UnitValue.CreatePercentArray(columnWidths));
            Cell cell = new Cell(1, 5)
                .Add(new Paragraph("Lista de Inventario"))
                .SetFont(f)
                .SetFontSize(13)
                .SetFontColor(DeviceGray.WHITE)
                .SetBackgroundColor(DeviceGray.BLACK)
                .SetTextAlignment(TextAlignment.CENTER);
            table.AddHeaderCell(cell);

            // Agregar el encabezado de los datos
            Cell c1 = new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Id").SetFont(f));
            Cell c2 = new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Nombre").SetFont(f));
            Cell c3 = new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Descripción").SetFont(f));
            Cell c4 = new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Precio").SetFont(f));
            Cell c5 = new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph("Cantidad").SetFont(f));
            
            table.AddHeaderCell(c1);
            table.AddHeaderCell(c2);
            table.AddHeaderCell(c3);
            table.AddHeaderCell(c4);
            table.AddHeaderCell(c5);

            // Agregar los datos del Grid
            foreach (GridViewRow row in gridInventarios.Rows)
            {
                table.AddCell(new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph(row.Cells[0].Text).SetFont(f)));
                table.AddCell(new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph(row.Cells[1].Text).SetFont(f)));
                table.AddCell(new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph(row.Cells[2].Text).SetFont(f)));
                table.AddCell(new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph(row.Cells[3].Text).SetFont(f)));
                table.AddCell(new Cell().SetTextAlignment(TextAlignment.CENTER).Add(new Paragraph(row.Cells[4].Text).SetFont(f)));
            }
            
            doc.Add(table);
            doc.Close();

            pdf.Close();
            writer.Close();
            
            /* Abrir archivo en una nueva ventana */
            FileStream fs = new FileStream(filepath, FileMode.Open, FileAccess.Read);
            byte[] ar = new byte[(int)fs.Length];

            Response.ContentType = "Application/pdf";
            Response.TransmitFile(filepath);


        }
    }
}