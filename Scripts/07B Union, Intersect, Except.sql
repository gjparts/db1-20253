USE BaleadasGPT
GO

--Enumerar las filas de una consulta
SELECT RANK() OVER (ORDER BY ProductoID) as Renglon, *
FROM Producto

--Otro ejemplo con menos columnas
SELECT RANK() OVER (ORDER BY ProductoID) as Renglon, Codigo, Descripcion, PrecioVenta
FROM Producto

--CREAR UNA TABLA A PARTIR DEL RESULTADO DE UNA CONSULTA ---------------------------------
--primero se recomienda hacer una vista previa:
SELECT *
FROM Producto
WHERE Descripcion LIKE '%Pollo%'

--si estamos seguros que deseamos que dicho resultado cree una nueva tabla
--entonces ejecutamos el SELECT de la siguiente forma:
SELECT *
INTO NuevaTabla
FROM Producto
WHERE Descripcion LIKE '%Pollo%'
--lo anterior crea una tabla llamada NuevaTabla con el resultado de la consulta:

--consulta de la tabla creada:
SELECT * FROM NuevaTabla

--si desea eliminar la tabla creada:
DROP TABLE NuevaTabla

--UNION: combina las filas de una o varias consultas (se aprendió en Algebra Relacional) -------------------
---> es obligatorio desglosar las columnas en cada consulta.
---> Debe haber el mismo numero de columnas en todas las consultas
---> debe haber coincidencia de tipos entre las columnas desglosadas
---> UNION elimina los duplicados luego de la union
---> UNION ALL no elimina los duplicados luego de la union

--ejemplo con UNION:
SELECT ClienteID, Pais FROM Cliente --9 filas
UNION
SELECT ProveedorID, Pais FROM Proveedor --4 filas
--luego de eliminar los duplicados solo quedan 9 filas

--ejemplo con UNION ALL:
SELECT ClienteID, Pais FROM Cliente --9 filas
UNION ALL
SELECT ProveedorID, Pais FROM Proveedor --4 filas
--no elimina los duplicados quedando las 13 filas

--otro ejemplo:
SELECT ProductoID, Descripcion FROM Producto
UNION ALL
SELECT ClienteID, Nombre FROM Cliente
UNION ALL
SELECT ProveedorID, Nombre FROM Proveedor
--Observe que ProductoID, ClienteID y ProveedorID son compatibles entre si (son numericas)
--luego Descripcion, Nombre y Nombre de cada tabla son de texto y tambien con compatibles.

--lo siguiente se iría a falla:
--porque ProductoID y ProveedorID no tienen tipos compatibles con Nombre
SELECT ProductoID, Descripcion FROM Producto
UNION ALL
SELECT Nombre, ClienteID FROM Cliente
UNION ALL
SELECT ProveedorID, Nombre FROM Proveedor

--otro ejemplo:
SELECT ProductoID as Identificador, Descripcion as Sinopsis FROM Producto
UNION ALL
SELECT ClienteID, Nombre FROM Cliente
UNION ALL
SELECT ProveedorID, Nombre FROM Proveedor
--observe que la primera consulta es la que determina los ALIAS de las columnas

--Lo anterior puede usarse mucho en reportes, por ejemplo:
/*Hacer un reporte de movimientos tanto compras como facturas del mes de Marzo de 2011
desglosando el id, fecha y valor de cada documento así como colocando
en una columna un texto que indique cuando algo es factura y cuando algo es compra.
Orden por Fecha la informacion mostrada.*/
SELECT FacturaID, Fecha, Total, 'Venta' as Tipo
FROM FacturaCab
WHERE MONTH(Fecha) = 3 AND YEAR(Fecha) = 2011
UNION ALL
SELECT CompraID, Fecha, Total, 'Compra'
FROM CompraCab
WHERE MONTH(Fecha) = 3 AND YEAR(Fecha) = 2011
ORDER BY 2 ASC
--Observe que el ORDER BY va al final de todas las uniones
--No puede haber un ORDER BY entre cada union

--INTERSECT: muestra los registros que concuerdan entre una o varias consultas.
---> es obligatorio desglosar las columnas en cada consulta.
---> Debe haber el mismo numero de columnas en todas las consultas
---> elimina los duplicados en el resultado
---> debe haber coincidencia de tipos entre las columnas desglosadas

--Mostrar los ID de los clientes que tengan facturas generadas el primero de Diciembre de 2010
SELECT ClienteID FROM Cliente
INTERSECT
SELECT ClienteID FROM FacturaCab WHERE CAST(Fecha as Date) = '2010/12/01'
--note que de los 9 ClienteID de la primer consulta solo 6 hacen Match en los ClienteID de la segunda consulta.

/*Para todas las facturas hechas el primero de Diciembre de 2010 muestre el ProductoID y PrecioVenta
que concuerden con el ProductoID y PrecioVenta del catalogo de productos.*/
SELECT ProductoID, PrecioVenta FROM Producto
INTERSECT
SELECT a.ProductoID, a.PrecioVenta
FROM FacturaDet a
	INNER JOIN FacturaCab b ON a.FacturaID = b.FacturaID
WHERE CAST(b.Fecha as Date) = '2010/12/01'

--EXCEPT: muestra los registros que no concuerdan entre una o varias consultas.
--en Algebra Relacional se le conoce como Diferencia de Conjuntos.
---> es obligatorio desglosar las columnas en cada consulta.
---> Debe haber el mismo numero de columnas en todas las consultas
---> elimina los duplicados en el resultado
---> debe haber coincidencia de tipos entre las columnas desglosadas

--Mostrar los ID de los clientes que NO tengan facturas generadas el primero de Diciembre de 2010
SELECT ClienteID FROM Cliente
EXCEPT
SELECT ClienteID FROM FacturaCab WHERE CAST(Fecha as Date) = '2010/12/01'

/*Para todas las facturas hechas el primero de Diciembre de 2010 muestre el ProductoID y PrecioVenta
que NO concuerden con el ProductoID y PrecioVenta del catalogo de productos.*/
SELECT ProductoID, PrecioVenta FROM Producto
EXCEPT
SELECT a.ProductoID, a.PrecioVenta
FROM FacturaDet a
	INNER JOIN FacturaCab b ON a.FacturaID = b.FacturaID
WHERE CAST(b.Fecha as Date) = '2010/12/01'