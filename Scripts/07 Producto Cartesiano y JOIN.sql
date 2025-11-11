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