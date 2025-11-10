Use BaleadasGPT
GO
/*FUNCIONES DE AGREGADO
Son aquellas que nos permiten realizar un calculo sobre un conjunto de valores devolviendo un unico
resultado para cada grupo definido. Si no se definen grupos entonces el resultado se considera como general.
Los campos de agregado son conocidos como Totales o Sub-Totales dependendiendo de si agrupa o no.
IMPORTANTE: Una funcion de agregado no se puede combinar con otras columnas si no existe agrupamiento (GROUP BY)

Las funciones de agregado mas populares son:
	COUNT:	cuenta la cantidad de filas de una consulta, o tambien puede contar la cantidad de valores que no son NULL.
	SUM:	suma los valores numericos no nulos de una columna para una consulta
	AVG:	Average o promedio de los valores numericos de determnada consulta
	MAX:	devuelve el valor maximo de una columna para determinada consulta
	MIN:	devuelve el valor minimo de una columna para determinada consulta*/

--Muestre la cantidad de filas en la tabla Producto
--Cuando se cuenta filas se usa el simbolo * dentro de COUNT (esto no es incorrecto)
--Cuando COUNT se usa con * se cuenta filas sin importar halla valores nulos.
SELECT COUNT(*)
FROM Producto

--Muestre la cantidad de clientes
SELECT COUNT(*)
FROM Cliente

--Muestre la cantidad de fechas de Nacimiento para clientes
--Cuando se cuenta filas colocando el nombre de una columna dentro de COUNT se cuenta
--aquellos valores que no son nulos.
SELECT COUNT(Nacimiento)
FROM Cliente

--Muestre la cantidad de clientes que llenaron Telefono1
SELECT COUNT(Telefono1)
FROM Cliente

--Muestre la cantidad de clientes que llenaron Telefono1 y tambien el total de clientes en la tabla
SELECT COUNT(Telefono1) as [Tienen Telefono1], COUNT(*) as [Total de Clientes]
FROM Cliente

--Clausula GROUP BY: permite agrupar la informacion de acuerdo al listado de columnas que le proporcionemos
--a diferencia de DINSTICT este nos permite determinar que columnas forman parte del grupo con respecto
--a las funciones de agregado.
--GROUP BY se puede combinar con la clausula HAVING para filtrar los resultados de acuerdo a columnas de agregado
--cosa que no se puede hacer con DISTINCT

--lo siguiente da error porque las funciones de agregado no pueden combinarse con columnas
--que no estan en funciones de agregado de forma tradicional, para ello va a necesitar el uso de GROUP BY:
SELECT COUNT(*), Pais
FROM Cliente

--correccion de la consulta anterior:
SELECT COUNT(*), Pais
FROM Cliente
GROUP BY Pais
--Lo anterior me muestra cuantos registros hay por cada grupo en este caso por cada Pais

--Importante: la clausula GROUP BY se coloca despues de WHERE y antes de ORDER BY
SELECT Pais, COUNT(*) as [Cantidad de Clientes]
FROM Cliente
WHERE Pais <> 'Local'
GROUP BY Pais
ORDER BY 1 DESC
--Observe que puse ALIAS a la columna de agregado.

--Muestre la cantidad de productos por cada ProductoCategoriaID:
SELECT ProductoCategoriaID, COUNT(*) as Productos
FROM Producto
GROUP BY ProductoCategoriaID

--Muestre la cantidad de productos facturados por cada productoid mostrando primero el que mas vende
SELECT ProductoID, COUNT(*)
FROM FacturaDet
GROUP BY ProductoID
ORDER BY 2 DESC

--Cantidad de permisos por cada Modulo, Categoria, SubCategoria
SELECT Modulo, Categoria, SubCategoria, COUNT(*) as Permisos
FROM Permiso
GROUP BY Modulo, Categoria, SubCategoria

--muestre la cantidad de facturas por cada forma de pago que fueron generadas
--en el año 2011, muestre primero la forma de pago que mas facturas tiene
SELECT Pago, COUNT(*) as Facturas
FROM FacturaCab
GROUP BY Pago
ORDER BY 2 DESC

--muestre la cantidad de facturas por turno y por cada forma de pago que fueron generadas
--en el año 2011, muestre primero la combinacion que mas facturas tiene
SELECT Turno, Pago, COUNT(*) as Facturas
FROM FacturaCab
GROUP BY Turno, Pago
ORDER BY 3 DESC

--tambien se puede tener varias columnas con funciones de agregado:
SELECT	COUNT(*) as Clientes,
		COUNT(Nacimiento) as [Clientes con fecha de nacimiento],
		COUNT(Telefono1) as [Clientes con telefono1]
FROM Cliente
--recuerde que COUNT para una columna cuenta los valores que no son NULL

--una variante del anterior: agrupados por Pais
SELECT	Pais, COUNT(*) as Clientes,
		COUNT(Nacimiento) as [Clientes con fecha de nacimiento],
		COUNT(Telefono1) as [Clientes con telefono1]
FROM Cliente
GROUP BY Pais

--Trabajemos con otras funciones de agregado
--Mostrar el total facturado
SELECT SUM(Total)
FROM FacturaCab

--Mostrar el total facturado en el año 2011
SELECT SUM(Total)
FROM FacturaCab
WHERE YEAR(Fecha) = 2011

--Muestre el total facturado en 2010 por forma de pago mostrando primero la que mas factura
SELECT Pago, SUM(Total) as Total
FROM FacturaCab
WHERE YEAR(Fecha) = 2010
GROUP BY Pago
ORDER BY 2 DESC

--Muestra el total facturado por turno y por usuario ordenado por turno y por total facturado
SELECT Turno, UsuarioIngresa, SUM(Total) as Total
FROM FacturaCab
GROUP BY Turno, UsuarioIngresa
ORDER BY Turno, 3 DESC

--Tambien es posible usar campos calculados como agrupamiento
--Muestre el total facturado por año
SELECT YEAR(Fecha) as Año, SUM(Total) as Total
FROM FacturaCab
GROUP BY YEAR(Fecha)

--Muestre el total facturado por año y luego por Mes, ordenado por año y luego por mes
SELECT YEAR(Fecha) as Año, MONTH(Fecha) as Mes, SUM(Total) as Total
FROM FacturaCab
GROUP BY YEAR(Fecha), MONTH(Fecha)
ORDER BY 1,2

--Tambien es posible combinar las funciones de agregado:
--Muestre el total facturado por forma de pago mostrando primero la que mas factura
--asi como la cantidad de facturas que hay en cada forma de pago.
SELECT Pago, SUM(Total) as Total, COUNT(*) as Facturas
FROM FacturaCab
GROUP BY Pago
ORDER BY 2 DESC

--Muestre el total facturado en 2011 por turno y luego por usuario ordenado por turno y por total descendente
--ademas de la cantidad de facturas por cada grupo.
SELECT Turno, UsuarioIngresa, SUM(Total) as Total, COUNT(*) as Facturas
FROM FacturaCab
GROUP BY Turno, UsuarioIngresa
ORDER BY Turno, 2 DESC

--Muestre el total facturado por año y luego por Mes, ordenado por año y luego por mes
--asi como la cantidad de facturas en cada grupo
SELECT YEAR(Fecha) as Año, MONTH(Fecha) as Mes, SUM(Total) as Total, COUNT(*) as Facturas
FROM FacturaCab
GROUP BY YEAR(Fecha), MONTH(Fecha)
ORDER BY 1,2

--Ahora veamos ejemplos usando AVG (Promedio o Average) ---------------------------------
--Obtener el precio de venta promedio de todos los productos
SELECT AVG(PrecioVenta)
FROM Producto

--Obtener el promedio de todo lo facturado
SELECT AVG(Total)
FROM FacturaCab

--Obtener el promedio de todo lo facturado por año
SELECT YEAR(Fecha) as Año, AVG(Total) as Promedio
FROM FacturaCab
GROUP BY YEAR(Fecha)

--Muestre el total facturado por año y luego por Mes, ordenado por año y luego por mes
--asi como la cantidad de facturas en cada grupo y el promedio facturado por grupo
SELECT YEAR(Fecha) as Año, MONTH(Fecha) as Mes, SUM(Total) as Total, COUNT(*) as Facturas, AVG(Total) as Promedio
FROM FacturaCab
GROUP BY YEAR(Fecha), MONTH(Fecha)
ORDER BY 1,2

--Funciones de agregado MAX y MIN -----------------------------------------
--Mostrar el ultimo numero de factura generado
SELECT MAX(FacturaID)
FROM FacturaCab

--Mostrar el ultimo numero de factura generado y en otra columna el numero que le sigue
SELECT MAX(FacturaID) as Ultima, MAX(FacturaID)+1 as Siguiente
FROM FacturaCab
--Importante: se puede realizar operaciones matematicas involucrando funciones de agregado

--Muestre el precio del producto que se vende mas caro y del que se vende mas barato
SELECT MAX(PrecioVenta) as Caro, MIN(PrecioVenta) as Barato
FROM Producto

--Muestre el nombre y precio de venta del producto o productos que se venden mas caro
SELECT Descripcion, PrecioVenta
FROM Producto
WHERE PrecioVenta = ( SELECT MAX(PrecioVenta) FROM Producto )
--Observe que aqui utilicé una subconsulta como las que vimos temas atras

--Combinemos funciones de agregado con campos calculados ---------------------------------
--Muestre la suma de las utilidades obtenidas para todas las facturas cuyo Estado sea NOR
SELECT SUM(Total-CostoPromedioTotal) as [Utilidad Total]
FROM FacturaCab
WHERE Estado = 'NOR'

--Muestre la suma de las utilidades obtenidas para todas las facturas cuyo Estado sea NOR
--y agrupadas por Tipo
SELECT Tipo, SUM(Total-CostoPromedioTotal) as [Utilidad Total]
FROM FacturaCab
WHERE Estado = 'NOR'
GROUP BY Tipo

--Combinar funciones de agregado con CASE WHEN ----------------------------------------------
/*Para las facturas cuyo estado sea NOR muestre en una columna la suma del total de las facturas
realizadas en 2010 y en otra columna el total de las facturas realizadas en 2011*/
SELECT	SUM( CASE WHEN YEAR(Fecha) = 2010 THEN Total ELSE 0.00 END ) as [Facturado en 2010],
		SUM( CASE WHEN YEAR(Fecha) = 2011 THEN Total ELSE 0.00 END ) as [Facturado en 2011]
FROM FacturaCab
WHERE Estado = 'NOR'
--Observe que dentro de SUM colocamos una toma de decision de lo que se va a sumar de acuerdo
--al cumplimiento de una condicion.

/*Para las facturas cuyo estado sea NOR muestre en una columna la suma del total de las facturas
realizadas en 2010 y en otra columna el total de las facturas realizadas en 2011 agrupadas por forma de pago*/
SELECT	Pago,
		SUM( CASE WHEN YEAR(Fecha) = 2010 THEN Total ELSE 0.00 END ) as [Facturado en 2010],
		SUM( CASE WHEN YEAR(Fecha) = 2011 THEN Total ELSE 0.00 END ) as [Facturado en 2011]
FROM FacturaCab
WHERE Estado = 'NOR'
GROUP BY Pago

/*Para las facturas realizadas con estado NOR muestre en una columna la cantidad de facturas
realizadas al Contado y la cantidad realizada al Credito*/
SELECT	COUNT( CASE WHEN Tipo = 'Contado' THEN 1 ELSE NULL END ) as [Facturas de Contado],
		COUNT( CASE WHEN Tipo = 'Credito' THEN 1 ELSE NULL END ) as [Facturas de Credito]
FROM FacturaCab
WHERE Estado = 'NOR'
/*Observe que si se cumple la condicion se retorna un valor para ser contado en caso contrario
se retorna NULL el cual no sera contado por COUNT.*/

/*Para las facturas realizadas con estado NOR muestre en una columna la cantidad de facturas
realizadas al Contado y la cantidad realizada al Credito agrupadas por forma de Pago ordenadas
por forma de pago*/
SELECT	Pago,
		COUNT( CASE WHEN Tipo = 'Contado' THEN 1 ELSE NULL END ) as [Facturas de Contado],
		COUNT( CASE WHEN Tipo = 'Credito' THEN 1 ELSE NULL END ) as [Facturas de Credito]
FROM FacturaCab
WHERE Estado = 'NOR'
GROUP BY Pago
ORDER BY Pago

/*Clausula HAVING
Permite filtrar los registros de una consulta luego de haber agrupado. HAVING se hace en base a
los campos de agregado y se coloca despues del GROUP BY.*/

/*Para las facturas cuyo estado sea NOR, muestre el total facturado por año y por mes
ordenadas por Año y luego por Mes, incluya la cantidad de Facturas por cada grupo.
Deje unicamente aquellos meses cuyo total facturado supere los 600000.*/
SELECT	YEAR(Fecha) as Año, MONTH(Fecha) as Mes,
		SUM(Total) as Total, COUNT(*) as Facturas
FROM FacturaCab
WHERE Estado = 'NOR'
GROUP BY YEAR(Fecha), MONTH(Fecha)
HAVING SUM(Total) > 600000
ORDER BY 1,2

/*Para las facturas cuyo estado sea NOR, muestre el total facturado por año y por mes
ordenadas por Año y luego por Mes, incluya la cantidad de Facturas por cada grupo.
Deje unicamente aquellos meses cuyo total facturado supere los 600000 y que tengan mas de 13000 facturas.*/
SELECT	YEAR(Fecha) as Año, MONTH(Fecha) as Mes,
		SUM(Total) as Total, COUNT(*) as Facturas
FROM FacturaCab
WHERE Estado = 'NOR'
GROUP BY YEAR(Fecha), MONTH(Fecha)
HAVING SUM(Total) > 600000 AND COUNT(*) > 13000
ORDER BY 1,2

/*Para la tabla de clientes (Customers) de la base de datos Northwind, muestre cuantos
clientes hay por cada Pais (Country).
Debe mostrar unicamente aquellos paises con 10 o mas clientes. Ordene la informacion por numero de clientes.*/
SELECT Country, COUNT(*) as Clientes
FROM Northwind.dbo.Customers
GROUP BY Country
HAVING COUNT(*) >= 10
ORDER BY 2

/*Para la tabla de clientes (Customers) de la base de datos Northwind, muestre cuantos
clientes hay por cada Pais (Country).
Debe mostrar unicamente aquellos paises que tengan entre 5 y 10 clientes. Ordene la informacion por numero de clientes.*/
SELECT Country, COUNT(*) as Clientes
FROM Northwind.dbo.Customers
GROUP BY Country
HAVING COUNT(*) BETWEEN 5 AND 10
ORDER BY 2
--puede usar todos los operadores que aprendio en WHERE dentro de HAVING; pero siempre
--comando en cuenta que HAVING es exclusivo para funciones de agregado.

--ejemplos de agrupamiento usando CASE WHEN -------------------------------------
/*Case WHEN se puede formular de manera que responda de diversas formas de acuerdo a un valor de entrada
que puede ser texto, nuero, calculo, etc.
Ejemplo:
Para la tabla Person de la base de datos AdventureWorks dentro del Rol Person
realice la consulta siguiente:

Muestre una columna llama Type
la cual dependiendo del valor de PersonType mostrar un texto de acuerdo a la escala siguiente:
EM	Empleado
SP	Vendedor
SC	Contacto de Tienda
VC	Proveedor
IN	Cliente
cualquier otro valor que muestre el texto: Otros
-> Muestre otra columna con la cantidad de clientes por cada Type de la columna anterior
-> Deje unicamente aquellos grupos con 200 o mas personas
Ordene los datos de acuerdo a esta ultima columna.
*/

SELECT	CASE PersonType
			WHEN 'EM' THEN 'Empleado'
			WHEN 'SP' THEN 'Vendedor'
			WHEN 'SC' THEN 'Contacto de Tienda'
			WHEN 'VC' THEN 'Proveedor'
			WHEN 'IN' THEN 'Cliente'
			ELSE 'Otros'
		END as Type,
		COUNT(*) as Cantidad
FROM AdventureWorks.Person.Person
GROUP BY CASE PersonType
			WHEN 'EM' THEN 'Empleado'
			WHEN 'SP' THEN 'Vendedor'
			WHEN 'SC' THEN 'Contacto de Tienda'
			WHEN 'VC' THEN 'Proveedor'
			WHEN 'IN' THEN 'Cliente'
			ELSE 'Otros'
		END
HAVING COUNT(*) > 200
ORDER BY 2
--Lastimosamente lo anterior obliga a escribir dos veces el campo calculado (CASE WHEN)
--esto se puede evitar mediante el uso de subconsultas:

SELECT Type, COUNT(*) as Cantidad
FROM (
	SELECT	CASE PersonType
				WHEN 'EM' THEN 'Empleado'
				WHEN 'SP' THEN 'Vendedor'
				WHEN 'SC' THEN 'Contacto de Tienda'
				WHEN 'VC' THEN 'Proveedor'
				WHEN 'IN' THEN 'Cliente'
				ELSE 'Otros'
			END as Type
	FROM AdventureWorks.Person.Person
) as Subconsulta
GROUP BY Type
HAVING COUNT(*) > 200
ORDER BY 2
--Observe que la clasificacion de datos con CASE WHEN va dentro de la subconsulta.
--fuera de la subconsulta hacemos el GROUP BY, HAVING y COUNT