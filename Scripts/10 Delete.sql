/*Instruccion DELETE: elimina uno o varios registros de una tabla
dependiendo del WHERE usado.
-> Esta instruccion no altera la numeracion de campos Identity
-> Se recomienda combinarlo con WHERE
-> Se recomienda que antas de hacer DELETE haga una vista previa con SELECT
-> Si algun registro de la tabla tiene asociacion con otra tabla por medio
   de una llave foranea (foreign key); entonces no se elimina ese registro.
   
Para estas practicas con DELETE recomiendo trabajar en una base
de datos COPIA que sea a partir del backup de BaleadasGPT*/
USE COPIA
GO

--DELETE sin WHERE (potencialmente peligroso)
--borrar todos los registros de la tabla Permiso
--vista previa:
SELECT * FROM Permiso
--ejecutar:
DELETE Permiso
--tambien puede usar DELETE FROM

--DELETE con WHERE (mas seguro)
--Borre de la tabla Permiso aquellos registros cuyo Objeto sea btnRoles
--vista previa
SELECT * FROM Permiso WHERE Objeto = 'btnRoles'
--ejecutar:
DELETE Permiso WHERE Objeto = 'btnRoles'

--Borre aquellos permisos cuya categoria sea General o Reportes
--y cuya subcategoria lleve en cualquier parte la palabra Ventas.
--vista previa:
SELECT *
FROM Permiso
WHERE Categoria IN ('General','Reportes') AND SubCategoria LIKE '%ventas%'
--ejecutar:
DELETE Permiso
WHERE Categoria IN ('General','Reportes') AND SubCategoria LIKE '%ventas%'

--Que pasa si borramos un registro relaciona con otra tabla por medio de una llave foranea?
--Borrar el cliente con id = 1
SELECT * FROM Cliente WHERE ClienteID = 1
DELETE Cliente WHERE ClienteID = 1
--obtendra n error de conflicto con la restriccion REFERENCE
--ya que el ClienteID 1 esta siendo usado por Facturas en FacturaCab

--Elimine todos los detalles de facturacion cuya cantidad sea >= 50
--y que su precio de venta sea <= 10
SELECT * FROM FacturaDet WHERE Cantidad >= 50 AND PrecioVenta <= 10
DELETE FacturaDet WHERE Cantidad >= 50 AND PrecioVenta <= 10

--Eliminar registros usando JOIN
--Elimine todos los detalles para las compras realizadas en Diciembre de 2010
--y cuyo renglon sea CERO en el turno B
SELECT *
FROM CompraDet a
	INNER JOIN CompraCab b ON a.CompraID = b.CompraID
WHERE YEAR(b.Fecha) = 2010 AND MONTH(b.Fecha) = 12 AND a.Renglon = 0 AND b.Turno = 'B'

--se toma a partir de FROM
DELETE CompraDet
FROM CompraDet a
	INNER JOIN CompraCab b ON a.CompraID = b.CompraID
WHERE YEAR(b.Fecha) = 2010 AND MONTH(b.Fecha) = 12 AND a.Renglon = 0 AND b.Turno = 'B'