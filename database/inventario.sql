USE [INVENTARIO]
GO
/****** Object:  Table [dbo].[inventario]    Script Date: 21/07/2019 10:45:38 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inventario](
	[id] [int] NOT NULL,
	[nombre] [varchar](50) NULL,
	[descripcion] [varchar](250) NULL,
	[precio] [decimal](18, 2) NULL,
	[cantidad] [int] NULL,
	[fecha_creado] [datetime] NULL,
 CONSTRAINT [PK_inventario] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[inventario] ([id], [nombre], [descripcion], [precio], [cantidad], [fecha_creado]) VALUES (1, N'Papas Sabritas 55G', N'Papas Sabritas Recien Horneadas Producto Nuevo', CAST(10.00 AS Decimal(18, 2)), 9, CAST(N'2019-07-21T22:42:39.577' AS DateTime))
/****** Object:  StoredProcedure [dbo].[add_inventario]    Script Date: 21/07/2019 10:45:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[add_inventario]
(
   @pi_nombre		 VARCHAR(50)
  ,@pi_descripcion	 VARCHAR(200)
  ,@pi_precio		 DECIMAL(18,2)
  ,@pi_cantidad		 INT
  ,@po_id            INT OUTPUT
) AS
BEGIN
----------------------------------------------------------------------
--  Descripción: Ejemplo CRUD
--  Versión:     1.0
--  Historia:    Carlos García Garza
----------------------------------------------------------------------

DECLARE @l_id INT;
DECLARE @l_fecha DATETIME;
SET     @l_id = (SELECT ISNULL(MAX(Id),0) from inventario)
SET     @l_fecha = (SELECT GETDATE() AS DATETIME)

   -- Validacion de datos

   IF @pi_nombre IS NULL OR ISNULL(@pi_nombre,'') = '' BEGIN

      PRINT('El parametro @pi_nombre esta nulo o vacío')

   END

   -- Generar el ID que se le va a asignar
   IF @l_id = 0 BEGIN

      SET @l_id     =  1
	  SELECT @po_id = @l_id 
   
   END
   ELSE BEGIN

      SET    @l_id = @l_id + 1
      SELECT @po_id = @l_id 

   END 
   -- Fin de generacion de ID

   -- Inserción en inventario
   INSERT INTO dbo.inventario
   (
    id      ,nombre			,descripcion		,precio			,cantidad			,fecha_creado   
   )
   values
   (
    @po_id ,@pi_nombre		,@pi_descripcion	,@pi_precio		,@pi_cantidad		,@l_fecha
   )

END
GO
