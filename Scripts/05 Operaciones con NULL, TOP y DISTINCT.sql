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