use BaleadasGPT
GO

--OPERACIONES ARITMETICAS CON NULL --------------------------------------
--recuerde que en SQL cuando se opera un valor NULL sin importar el tipo
--de calculo aritmetico que haga, el resultado siempre sera NULL a menos
--que utilice las funciones para reemplazo de NULL.
--en SQL SERVER esta funcion se llama ISNULL
--MySQL esta funcion se llama COALESCE

/*aunque no tenga mucho sentido; pero en la tabla AdventureWorks.Sales.SalesOrderHeader
vamos a hacer la siguiente operacion:

(CurrencyRateID+CreditCardID)/TerritoryID

en caso de venir NULL alguno de los valores reemplacelo por CERO
Muestre otras columnas al gusto.
*/
SELECT	CurrencyRateID, CreditCardID, TerritoryID,
		(CurrencyRateID+CreditCardID)/TerritoryID as Operacion
FROM AdventureWorks.Sales.SalesOrderHeader
--Observe que donde hay un valor NULL el resultado de la operacion es NULL

--Ahora hare la misma consulta; pero reemplazando los NULL por CERO
SELECT	CurrencyRateID, CreditCardID, TerritoryID,
		(ISNULL(CurrencyRateID,0.00)+ISNULL(CreditCardID,0.00))/ISNULL(TerritoryID,0.00) as Operacion
FROM AdventureWorks.Sales.SalesOrderHeader

--USO de TOP ---------------------------------------------------
--Esta clausula se usa para evitar tener que estar leyendo todas las filas en una consulta y asi solo obtener
--una muestra de registros.

--mostrar los primeros 5 productos
SELECT TOP(5) * FROM Producto

--se puede proyectar ciertas columnas:
SELECT TOP(5) Codigo, Descripcion FROM Producto

--mostrar el producto mas caro de vender
SELECT TOP(1) Codigo, Descripcion, PrecioVenta FROM Producto ORDER BY PrecioVenta DESC

--mostrar los ultimos 5 productos en base a su ID
SELECT TOP(5) * FROM Producto ORDER BY ProductoID DESC

--mostrar el producto mas barato
SELECT TOP(1) Codigo, Descripcion, PrecioVenta FROM Producto ORDER BY PrecioVenta ASC

--mostrar  los primeros 50 registros de la tabla Producto
SELECT TOP(50) * FROM Producto

--mostrar los primeros 20 registros de la tabla FacturaCab cuyo Total sea menor o igual a 100
SELECT TOP(20) *
FROM FacturaCab
WHERE Total <= 100

--Un uso practico de TOP es usarlo para saber que columnas tiene una tabla sin necesidad de ver sus registros
SELECT TOP(0) * FROM FacturaDet

--TOP tambien se puede representar en porcentaje:
--muestre el 10% de los registros de la tabla Producto
SELECT TOP 10 PERCENT * FROM Producto
SELECT TOP 10 PERCENT ProductoID, Descripcion FROM Producto

--CLAUSULA DINSTICT --------------------------------------------------------------------------------------
--Se utiliza para eliminar las tuplas duplicadas en un resultado de acuerdo a las columnas proyectadas
--Quiero saber que valores suele tener la columna Pago en FacturaCab
SELECT DISTINCT Pago FROM FacturaCab
--Quiero saber todas las combinaciones que hay de Tipo y Pago en la tabla FacturaCab
SELECT DISTINCT Tipo, Pago FROM FacturaCab

SELECT Descripcion
FROM Producto
ORDER BY Descripcion
--observe que hay varios productos cuya descripcion se repite

--veamos la lista de descripciones de productos eliminand los duplados
SELECT DISTINCT Descripcion
FROM Producto
ORDER BY Descripcion

--Que valores son los mas usados en la columna Tipo para la tabla FacturaCab
SELECT DISTINCT Tipo FROM FacturaCab

--Que roles son los mas usados en la tabla Usuario
SELECT DISTINCT RolID
FROM Usuario

--para FacturaCab muestre que Usuarios son los que han registrado facturas en el mes de Marzo de 2011 en orden alfabetico
SELECT DISTINCT UsuarioIngresa
FROM FacturaCab
WHERE MONTH(Fecha) = 3 AND YEAR(Fecha) = 2011

--mostrar las compras agrupadas por tipo, turno y estado ordenadas.
SELECT DISTINCT Tipo, Turno, Estado
FROM CompraCab
ORDER BY Tipo, Turno, Estado
--observe que se muestra las posibles combinaciones entre las columnas proyectadas

--mostrar el contenido de la tabla Permiso agrupado por Modulo, Categoria y SubCategoria y ordenados
SELECT DISTINCT Modulo, Categoria, SubCategoria
FROM Permiso
ORDER BY 1,2,3

--mostrar el contenido de la tabla Permiso cuya Categoria sea Reportes agrupado por Modulo, Categoria y SubCategoria y ordenados
SELECT DISTINCT Modulo, Categoria, SubCategoria
FROM Permiso
WHERE Categoria = 'Reportes'
ORDER BY 1,2,3

--mostrar las facturas del mes de septiembre de 2010 agrupadas por su utilidad y odenadas de mayor a menor
SELECT DISTINCT Total-CostoPromedioTotal as Utilidad
FROM FacturaCab
WHERE MONTH(Fecha) = 9 AND YEAR(Fecha) = 2010
ORDER BY 1 DESC



