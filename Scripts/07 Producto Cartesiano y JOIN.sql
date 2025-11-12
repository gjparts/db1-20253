USE BaleadasGPT
GO

/*USO DE LOS JOIN*/
--Relacionar tablas en una consulta en SQL

--PRODUCTO CARTESIANO
SELECT *
FROM Turno, Cliente
--Lo anterior hace un producto cartesiano. Columnas (5+14), Filas (2*9)

SELECT *
FROM Turno, Cliente, Proveedor

--Si quiere solo puede mostrar ciertas columnas
SELECT TurnoID, Pais
FROM Turno, Cliente

--Lo ideal es decir a que tabla corresponde cada columna, sobre todo cuando se presentan
--columnas duplicadas.
SELECT Turno.TurnoID, Cliente.Pais
FROM Turno, Cliente
--Note que en lenguaje SQL no se elimina los duplicados luego del producto carteasiano

--a menos que use DISINCT:
SELECT DISTINCT Turno.TurnoID, Cliente.Pais
FROM Turno, Cliente

--Producto cartesiano relacionando dos columnas clave entre dos tablas: ------------------
--A esto se le conoce como JOIN o INNER JOIN

--pasar a la base de datos pubs
USE pubs
GO

SELECT * FROM sales
SELECT * FROM titles

/*en la base de datos pubs para cada venta realizada en la tabla sales muestre:
-> El numero de orden
-> La cantidad
-> la fecha de la venta
-> el codigo del libro
-> el nombre del libro (este lo obtiene de la tabla titles)
-> relacione los campos clave segun se necesita para esta consulta.*/

--sales X titles
SELECT *
FROM sales, titles
--note que lo anterior es un producto cartesiano, tocara relacionar la informacion:

-- sales X titles relacionando campos clave
SELECT sales.ord_num, sales.qty, sales.ord_date, sales.title_id, titles.title
FROM sales, titles
WHERE sales.title_id = titles.title_id
--a esto se le conoce como JOIN o INNER JOIN (producto cartesiano con relacion por campos clave)

/*En la base de datos pubs, para cada venta (sales) muestre:
-> el numero de orden
-> la fecha de la orden
-> el nombre de la tienda donde se realizo la venta (tabla stores)
*/

SELECT sales.ord_num, sales.ord_date, stores.stor_name
FROM sales, stores
WHERE sales.stor_id = stores.stor_id

--Producto cartesiano tiple con relacion de registros
/*en la base de datos pubs, para cada venta (sales) muestre:
-> el numero de orden
-> la fecha de la venta
-> el nombre de la tienda (tabla stores)
-> el nombre del libro para cada venta (tabla titles)*/

SELECT sales.ord_num, sales.ord_date, stores.stor_name, titles.title
FROM sales, titles, stores
WHERE sales.stor_id = stores.stor_id AND sales.title_id = titles.title_id

/*Agreguemos mas complejidad:
en la base de datos pubs, para cada venta (sales) muestre:
-> el numero de orden
-> la fecha de la venta
-> el nombre de la tienda (tabla stores)
-> el nombre del libro para cada venta (tabla titles)
Para todas aquellas ordenes realizadas en 1994 cuya cantidad sea mejor o igual a 20
para libros de tipo business o psychology*/

SELECT sales.ord_num, sales.ord_date, stores.stor_name, titles.title
FROM sales, titles, stores
WHERE	sales.stor_id = stores.stor_id AND sales.title_id = titles.title_id
		AND YEAR(sales.ord_date) = 1994 AND sales.qty <= 20
		AND titles.type IN ('business','psychology')

/*el problema del producto cartesiano con campos relacionados es que es dificil de darle
mantenimiento y en consultas grandes se vuelve tedioso de leer.
Por tal razon se creó la clausula JOIN la cual permite crear un producto cartesiano
pero obligando a relacionar las columnas clave o llaves foraneas*/

/*Haremos la consulta anterior pero usando JOIN:
en la base de datos pubs, para cada venta (sales) muestre:
-> el numero de orden
-> la fecha de la venta
-> el nombre de la tienda (tabla stores)
-> el nombre del libro para cada venta (tabla titles)
Para todas aquellas ordenes realizadas en 1994 cuya cantidad sea mejor o igual a 20
para libros de tipo business o psychology*/
SELECT sales.ord_num, sales.ord_date, stores.stor_name, titles.title
FROM sales
	JOIN titles ON sales.title_id = titles.title_id
	JOIN stores ON sales.stor_id = stores.stor_id
WHERE YEAR(sales.ord_date) = 1994 AND sales.qty <= 20 AND titles.type IN ('business','psychology')
--Observe que usando JOIN se separa la relacion entre tablas del WHERE.

--a los JOIN se les conoce mayormente como INNER JOIN
SELECT sales.ord_num, sales.ord_date, stores.stor_name, titles.title
FROM sales
	INNER JOIN titles ON sales.title_id = titles.title_id
	INNER JOIN stores ON sales.stor_id = stores.stor_id
WHERE YEAR(sales.ord_date) = 1994 AND sales.qty <= 20 AND titles.type IN ('business','psychology')
--de aqui en adelante a los JOIN los vamos a usar como INNER JOIN.

--Para ser mas productivos, cuando se crea consultas con JOIN se recomienda colocar ALIAS a cada
--tabla involucrada, asi se ahorra tener que estar poniendo en nombre de la tabla cuando necesite
--referirsa a una columna de esta.
SELECT a.ord_num, a.ord_date, c.stor_name, b.title
FROM sales a
	INNER JOIN titles b ON a.title_id = b.title_id
	INNER JOIN stores c ON a.stor_id = c.stor_id
WHERE YEAR(a.ord_date) = 1994 AND a.qty <= 20 AND b.type IN ('business','psychology')
--Note que queda aun mas corta la consulta.
--Esta es la forma mas comun de trabajar consultas en SQL.

--Pasemos a la base de datos BaleadasGPT
USE BaleadasGPT
GO

/*Mostrar del catalogo de productos las columnas: codigo, descripcion y el nombre de la categoria a la que
pertenece cada producto.*/
SELECT a.Codigo, a.Descripcion, b.Nombre as Categoria
FROM Producto a
	INNER JOIN ProductoCategoria b ON a.ProductoCategoriaID = b.ProductoCategoriaID

/*Mostrar del catalogo de materias primas las columnas: codigo, descripcion, unidad de medida y el nombre de la categoria a la que
pertenece cada una.*/
SELECT a.Codigo, a.Descripcion, a.UnidadMedida, b.Nombre as Categoria
FROM MateriaPrima a
	INNER JOIN MateriaPrimaCategoria b ON a.MateriaPrimaCategoriaID = b.MateriaPrimaCategoriaID

/*Para todas las compras cuyo estado sea NOR y realizadas en Septiembre de 2010 muestre lo siguiente:
-> Id de compra, Fecha, Tipo, Documento, nombre del proveedor, total y turno.*/
SELECT a.CompraID, a.Fecha, a.Tipo, a.Documento, b.Nombre as Proveedor, a.Total, a.Turno
FROM CompraCab a
	INNER JOIN Proveedor b ON a.ProveedorID = b.ProveedorID
WHERE YEAR(a.Fecha) = 2010 AND MONTH(a.Fecha) = 9

/*Para todas las facturas cuyo estado sea NOR y realizadas en Noviembre de 2010 muestre lo siguiente:
-> Id de la factura, Fecha, Tipo, forma de pago, nombre del cliente, total y turno.*/
SELECT a.FacturaID, a.Fecha, a.Tipo, a.Pago, b.Nombre as Cliente, a.Total, a.Turno
FROM FacturaCab a
	INNER JOIN Cliente b ON a.ClienteID = b.ClienteID
WHERE YEAR(a.Fecha) = 2010 AND MONTH(a.Fecha) = 11

/*Mostrar los detalles de las facturas (FacturaDet) realizadas en Enero de 2011, la columnas
a mostrar que sea: FacturaID, Renglon, ProductoID, Fecha de la factura, nombre del producto, 
cantidad, precio de venta en cada renglon, nombre de la categoria a la que pertenece el producto en cada fila así
como el nombre del cliente al que se le facturó
Tablas: FacturaDet, Producto, FacturaCab, Cliente, ProductoCategoria*/
SELECT	a.FacturaID, a.Renglon, a.ProductoID, b.Fecha, c.Descripcion as Producto, a.Cantidad, a.PrecioVenta,
		d.Nombre as [Categoria del producto], e.Nombre as Cliente
FROM FacturaDet a
	INNER JOIN FacturaCab b ON a.FacturaID = b.FacturaID
	INNER JOIN Producto c ON a.ProductoID = c.ProductoID
	INNER JOIN ProductoCategoria d ON c.ProductoCategoriaID = d.ProductoCategoriaID
	INNER JOIN Cliente e ON b.ClienteID = e.ClienteID
WHERE YEAR(b.Fecha) = 2011 AND MONTH(b.Fecha) = 1
--Observe que aqui hay relaciones tanto con la tabla a, asi como entre las demas tablas b,c,d,e.

/*Tipos basicos de JOIN
1) INNER JOIN:	el que acabamos de aprender, tambien conocido como JOIN, muestra
				solo aquellos registros donde el campo relacionado coincide en ambas tablas.
2) LEFT JOIN:	es el segundo mas usado, devuelve todas las filas de la tabla de la izquierda de
				la relación así como las coincidencias de la derecha de la relación, si no existen
				coincidencias entonces devolverá valores NULL a la derecha del resultado.
3) RIGHT JOIN:	casi no usa, devuelve todas las filas de la tabla de la derecha de la relación
				así como las coincidencias de la izquierda de la relación, si no existe coincidencias
				entonces va a devolver valores NULL a la izquierda del resultado.
4) FULL JOIN:	Devuelve todas las filas: las coincidencias entre izquierda y derecha aí como las no coincidencias
				entre ambos lados las cuales seran mostradas como valores NULL.
5) CROSS JOIN:	es el producto cartesiano de dos tablas, une todo y no lleva la clausula ON
*/

/*LEFT JOIN ------------------------------------------------------------------------------------------
es el segundo mas usado, devuelve todas las filas de la tabla de la izquierda de
la relación así como las coincidencias de la derecha de la relación, si no existen
coincidencias entonces devolverá valores NULL a la derecha del resultado.
*/
--pasemos a la base de datos AdventureWorks
USE AdventureWorks
GO

--primer veamos como seris con INNER JOIN (deben coincidir en a,b)
/*en la tabla de Productos de AdventureWorks ,muestre el ProductID, Name, ListPrice y el Name del ProductoModel.
para los registros que coincidan entre Product y ProductModel
Ordene la informacion por nombre del producto.
Tablas: Production.Product, Production.ProductModel*/
SELECT a.ProductID, a.Name, a.ListPrice, b.Name as Model
FROM Production.Product a
	INNER JOIN Production.ProductModel b ON a.ProductModelID = b.ProductModelID
ORDER BY a.Name

/*La tabla Product tiene 504 registros, de los cuales no todos tienen ProductModelID que se pueda relacionar
con la tabla ProductoModel, por lo tanto INNER JOIN solo deja 295 registros que si logro relacionar con
ProductoModel. Si Usted quisiera que siempre se mostraran los 504 productos lo mas recomendado es usar un LEFT JOIN.*/

/*en la tabla de Productos de AdventureWorks ,muestre el ProductID, Name, ListPrice y el Name del ProductoModel.
para los registros que que hay en Product aunque no coincidan con ProductModel
Ordene la informacion por nombre del producto.
Tablas: Production.Product, Production.ProductModel*/

SELECT a.ProductID, a.Name, a.ListPrice, b.Name as Model
FROM Production.Product a
	LEFT JOIN Production.ProductModel b ON a.ProductModelID = b.ProductModelID
ORDER BY a.Name
/*Observe que en el resultado se muestra las 504 filas de la tabla de la izquierda de la relacion (Product)
y los registros que coinciden muestras datos de ambos lados, los que no, muestra NULL.*/

--por estetica para el query anterior puede usar ISNULL para que Model diga un texto que no sea NULL:
SELECT a.ProductID, a.Name, a.ListPrice, ISNULL(b.Name,'Undefined') as Model
FROM Production.Product a
	LEFT JOIN Production.ProductModel b ON a.ProductModelID = b.ProductModelID
ORDER BY a.Name

/*Para el ejemplo anterior:
Muestre todas las columnas*/
SELECT *
FROM Production.Product a
	LEFT JOIN Production.ProductModel b ON a.ProductModelID = b.ProductModelID
ORDER BY a.Name

/*Para el ejemplo anterior:
Muestre todas las columnas y preserve solo las filas donde se pudo relacionar los datos.*/
SELECT *
FROM Production.Product a
	LEFT JOIN Production.ProductModel b ON a.ProductModelID = b.ProductModelID
WHERE NOT b.ProductModelID IS NULL
ORDER BY a.Name
--esto devuelve algo similar a lo que haria un INNER JOIN

/*Para el ejemplo anterior:
Muestre todas las columnas y preserve solo las filas donde NO se pudo relacionar los datos.*/
SELECT *
FROM Production.Product a
	LEFT JOIN Production.ProductModel b ON a.ProductModelID = b.ProductModelID
WHERE b.ProductModelID IS NULL
ORDER BY a.Name
--de los 504 productos, 209 no tiene ProductModel existente.

--Otro ejemplo:
/*De la tabla Sales.SalesOrderHeader en AdventureWorks, para todas las ordenes procesadas en Agosto de 2011:
muestre el id, fecha de la orden, total, valor de la tasa de cambio (CurrencyRate),
el nombre del metodo de envio (ShipMethod) y numero de tarjeta de credito (CreditCard)
->	Si alguna de las ordenes no tiene tasa de cambio, metodo de envio o tarjeta de credito
	siempre deberá ser mostrado.
-> ordene los registros por fecha
Tablas: FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI FALTA AQUI
*/
SELECT *
FROM Sales.SalesOrderHeader