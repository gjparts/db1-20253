--Gerardo Portillo 20012002049
USE BaleadasGPT
GO
--ORDER BY: permite ordenar la informacion a travea de una o mas columnas
-----------------------------------------------------------------------------
--Todos los productos ordenados por nombre ascendentemente
SELECT *
FROM Producto
ORDER BY Descripcion ASC
--ASC = Ascendent

--Todos los productos ordenados por costo de menor a mayor
SELECT *
FROM Producto
ORDER BY CostoPromedio ASC

--Recuerde que puede proyectar cietas columnas y aunque la columna
--de ordenamiento no este proyecta siempre se puede usar
SELECT Codigo, Descripcion, PrecioVenta
FROM Producto
ORDER BY CostoPromedio ASC

--Todos los productos ordenados del mas caro al mas barato
SELECT *
FROM Producto
ORDER BY PrecioVenta DESC
--DESC = Descendent o sea de mayor a menor

--Si no colocan ASC o DESC; entonces SQL asume que se ordenara usando ASC
SELECT *
FROM Producto
ORDER BY PrecioVenta

--Tambien puede usar mas de un campo para ordenar
--Todos los productos ordenados primero por precio de venta de mayor a menor
--y luego por nombre de menor a mayor
SELECT Codigo, Descripcion, PrecioVenta
FROM Producto
ORDER BY PrecioVenta DESC, Descripcion ASC

--todos los clientes ordenados por Pais y luego por nombre ambos de
--forma ascendenente
SELECT ClienteID, Nombre, Pais, Municipio
FROM Cliente
ORDER BY Pais ASC, Nombre ASC

--Cuando tenga campos calculados deberá ordenar usando el calculo de dicho campo SIN EL ALIAS.
SELECT ClienteID, TRIM(Nombre) as [Nombre del cliente], Pais, Municipio
FROM Cliente
ORDER BY Pais ASC, TRIM(Nombre) ASC

--mostrar todas las compras ordenadas por Fecha de forma ascendente
--luego por el tipo y luego por su total.
--IMPORTANTE: cuando no se le dice si es ascendente o descendente en un
--enunciado usted debe asumir que se es ascendente.
SELECT UsuarioIngresa, Fecha, Tipo, Total, Turno
FROM CompraCab
ORDER BY Fecha ASC, Tipo ASC, Total ASC

--otro ejemplo para ordenar usando un campo calculado:
--Ordenar todos los productos de acuerdo a las ganancias que dejen de mayor a menor
--Queremos ver el Codigo, descripcion y la ganancia
SELECT Codigo, Descripcion, PrecioVenta-CostoPromedio as Utilidad
FROM Producto
ORDER BY PrecioVenta-CostoPromedio DESC

--Recuerde que en SQL SERVER a partir de la version 2016 es posible
--utilizar el ALIAS de columna para ordenar; pero en otros motores
--como MySQL 5.6 u ORACLE posiblemente no les dejen ordenar por ALIAS.
--Asi se ordena por ALIAS en SQL SERVER moderno:
SELECT Codigo, Descripcion, PrecioVenta-CostoPromedio as Utilidad
FROM Producto
ORDER BY Utilidad DESC

--Pero en cualquier motor de base de datos lo que si puede hacer es ordenar
--usando la posicion de la columnas deseada:
SELECT Codigo, Descripcion, PrecioVenta-CostoPromedio as Utilidad
FROM Producto
ORDER BY 3 DESC
--IMPORTANTE: la columna debe de estar proyectada en la consulta.

--un ejemplo mas:
SELECT TRIM(Nombre) as Nombre, Pais
FROM Cliente
ORDER BY 2 ASC, 1 ASC

--Clausula WHERE: se usa para filtrar la informacion de una consulta.-----------------------------
--Producto cuyo codigo sea 
SELECT ProductoID, Codigo, Descripcion, CostoPromedio, PrecioVenta
FROM Producto
WHERE Codigo = 'P0302'

--Productos cuyo codigo sea P0107, P0206 o P0409
SELECT ProductoID, Codigo, Descripcion, CostoPromedio, PrecioVenta
FROM Producto
WHERE Codigo = 'P0107' OR Codigo = 'P0206' OR Codigo = 'P0409'

--Productos cuyo codigo sea P0107, P0206 o P0409 (Usando IN)
SELECT ProductoID, Codigo, Descripcion, CostoPromedio, PrecioVenta
FROM Producto
WHERE Codigo IN ('P0107','P0206','P0409')
--IN es mas práctico cuando necesitamos seleccionar cualquier de los valores
--de una lista para determinado campo

--IN tambien se puede usar con datos numericos
--Productos cuyo ProductoID sea 4, 8, 11 o 15
SELECT ProductoID, Codigo, Descripcion, CostoPromedio, PrecioVenta
FROM Producto
WHERE ProductoID IN (4,8,11,15)
--Si IN no encuentra alguno de los valores de la lista simplemente
--no lo incluye en el resultado

--Existe el operador NOT el cual invierte el resultado de una condicion
--se puede combinar con el IN
--Productos cuyo Codigo NO SEA P0101, P0102 o P0110
SELECT ProductoID, Codigo, Descripcion, CostoPromedio, PrecioVenta
FROM Producto
WHERE NOT Codigo IN ('P0101','P0102','P0110')

--Uso del operador DISTINTO DE <>   (NO ES IGUAL A)
--Facturas cuyo ClienteID sea distinto de 1
SELECT *
FROM FacturaCab
WHERE ClienteID <> 1

--el anterior usando NOT
--Facturas cuyo ClienteID sea distinto de 1
SELECT *
FROM FacturaCab
WHERE NOT ClienteID = 1

--Uso del operador LIKE (parecido o similar)
--En SQL SERVER este operador solo se puede utilizar en campos que manejen texto
--Si la base de datos utiliza un COLLATION que maneje CI (Case Insensitive)
--entonces LIKE va a ignorar mayusculas y minusculas

--Mostrar los productos que tengan el texto LLEVAR en cualquier parte de su descripcion
SELECT *
FROM Producto
WHERE Descripcion LIKE '%LLEVAR%'

--Productos que llevan la palabra SENCILLA en cualquier parte de la descripcion
SELECT *
FROM Producto
WHERE Descripcion LIKE '%SENCILLA%'

--Productos cuya descripcion comience con la letra A
SELECT *
FROM Producto
WHERE Descripcion LIKE 'A%'
--aqui estos diciendo que el texto comienza con A y el % indica que no importa
--que caracteres vayan despues
--al % se le conoce Wildcard (comodín)

--la consulta anterior se puede hacer sin LIKE de esta forma:
SELECT *
FROM Producto
WHERE LEFT(Descripcion,1) = 'A'

--productos cuya descripcion comience con la palabra pollo
SELECT *
FROM Producto
WHERE Descripcion LIKE 'pollo%'

--productos cuya descripcion termine con la palabra VAR
SELECT *
FROM Producto
WHERE Descripcion LIKE '%VAR'

--Tambien es posible incrustar los wildcard en medio de las expresiones:
--productos cuya descripcion lleve la palabra MIXTA antes que la palabra LLEVAR
SELECT *
FROM Producto
WHERE Descripcion LIKE '%MIXTA%LLEVAR%'

--productos cuya descripcion lleve la palabra MIXTA antes que la palabra LLEVAR
--ó que lleve la palabra LLEVAR antes que la palabra MIXTA
SELECT *
FROM Producto
WHERE Descripcion LIKE '%MIXTA%LLEVAR%' OR Descripcion LIKE '%LLEVAR%MIXTA%'

--Otro comodin que se puede usar con LIKE es el GUION BAJO
--Este se utiliza para indicar que no importa que caracter vaya en determinada posicion:
--Mostrar los productos cuya tercera letra sea A
SELECT *
FROM Producto
WHERE Descripcion LIKE '__A%'

--tambien se puede hacer con SUBSTRING
SELECT *
FROM Producto
WHERE SUBSTRING(Descripcion,3,1) = 'A'

--mostrar los productos cuya penultima letra sea E
SELECT *
FROM Producto
WHERE Descripcion LIKE '%E_'

--mostrar los productos cuya penultima letra sea E
SELECT *
FROM Producto
WHERE TRIM(Descripcion) LIKE '%E_'  --TRIM para evitar que espacios en blanco afecten el resultado

--LIKE tambien soporta los wildcard [ ] los cuales se utilizan
--para establecer listas de seleccion

--Mostrar los productos cuya segunda letra sea A, E, I
SELECT *
FROM Producto
WHERE Descripcion LIKE '_[AEI]%'

--Mostrar los productos cuya primera letra sea S, C, M
SELECT *
FROM Producto
WHERE Descripcion LIKE '[SCM]%'

--Mostrar los productos cuya primer letra este entre A y D
--ordenarlos por Descripcion
SELECT *
FROM Producto
WHERE Descripcion LIKE '[A-D]%'
ORDER BY Descripcion

--los anterior se puede hacer con SUBSTRING:
SELECT *
FROM Producto
WHERE SUBSTRING(Descripcion,1,1) IN ('A','B','C','D')
ORDER BY Descripcion

--Mostrar los prpductos cuya primer letra NO este entre A y D
--ordenarlos por Descripcion
SELECT *
FROM Producto
WHERE NOT Descripcion LIKE '[A-D]%'
ORDER BY Descripcion

--Operador MODULO: devuelve el residuo de la division --------------------
--Productos cuyo ProductoID sea PAR
SELECT *
FROM Producto
WHERE ProductoID%2 = 0

--Productos cuyo ProductoID sea IMPAR
SELECT *
FROM Producto
WHERE ProductoID%2 = 1

--USO DE OPERADORES LOGICOS --------------------------------------
--son AND, OR, NOT.
--Se usa la misma mecanica que en cualquier lenguaje de programacion:
--* se evaluan de izquierda a derecha
--* se pueden combinar e incluso se pueden agrupar con parentesis
--* el orden de precedencia de operadores es: (), NOT, AND, OR

--Productos que lleven la palabra "LLEVAR" y la palabra "MIXT" en cualquier parte de su descripcion
SELECT ProductoID, Descripcion, Comentarios, PrecioVenta
FROM Producto
WHERE Descripcion LIKE '%LLEVAR%' AND Descripcion LIKE '%MIXT%'

--Productos que lleven la palabra "LLEVAR" ó la palabra "MIXT" en cualquier parte de su descripcion
SELECT ProductoID, Descripcion, Comentarios, PrecioVenta
FROM Producto
WHERE Descripcion LIKE '%LLEVAR%' OR Descripcion LIKE '%MIXT%'

--Productos cuyo comentario lleve la palabra "LLEVAR" en cualquier parte y cuyo precio
--de venta sea mayor o igual a 25
SELECT ProductoID, Descripcion, PrecioVenta
FROM Producto
WHERE Descripcion LIKE '%LLEVAR%' AND PrecioVenta >= 25

--Productos cuyo precio de venta sea mayor o igual a 15 y cuyo precio de venta sea menor o igual a 20
--Ordenar por precio de venta de menor a mayor
SELECT ProductoID, Descripcion
FROM Producto
WHERE PrecioVenta >= 15 AND PrecioVenta <= 20
ORDER BY PrecioVenta
--Observe que no es necesario proyectar la columna sobre la que se ordena y sobre
--la que se condiciona.

--en SQL exsite un operador llamado BETWEEN que permite mostrar valores
--que se encuentre comprendidos entre dos rangos, incluyendo los limites:

--Productos cuyo precio de venta sea mayor o igual a 15 y cuyo precio de venta sea menor o igual a 20
--Ordenar por precio de venta de menor a mayor
SELECT ProductoID, Descripcion, PrecioVenta
FROM Producto
WHERE PrecioVenta BETWEEN 15 AND 20
ORDER BY PrecioVenta

--Productos cuyo precio este entre 15 y 20 ó entre 50 y 100
SELECT ProductoID, Descripcion, PrecioVenta
FROM Producto
WHERE PrecioVenta BETWEEN 15 AND 20 OR PrecioVenta BETWEEN 50 AND 100
ORDER BY PrecioVenta

--Productos cuyo costo promedio sea menor a 3 ó cuyo costo promedio sea mayor a 100
SELECT *
FROM Producto
WHERE CostoPromedio < 3 OR CostoPromedio > 100

--Productos cuyo ProductoCategoriaID sea igual a 9 ó cuya descripcion lleve la palabra huevo
SELECT *
FROM Producto
WHERE ProductoCategoriaID = 9 OR Descripcion LIKE '%huevo%'

--USAR EL OPERADOR DINSTITO DE <>
--Facturas cuyo ClienteID no sea 1 y cuyo ClienteID no sea 3
SELECT *
FROM FacturaCab
WHERE ClienteID <> 1 AND ClienteID <> 3

--Productos cuyo ProductoID sea 8, 11 ó 15
SELECT *
FROM Producto
WHERE ProductoID = 8 OR ProductoID = 11 OR ProductoID = 15

--Esta es otra forma de hacer el problema anterior
SELECT *
FROM Producto
WHERE ProductoID IN (8,11,15)

--OPERADOR NOT
--A diferencia de <> el operador NOT se usa para cambiar el sentido de una exprresion logica
--Mostrar las materias primas cuya Unidad de medida no sea Unidad
SELECT *
FROM MateriaPrima
WHERE NOT UnidadMedida = 'Unidad'

--mostrar las materias primas cuya Unidad de medida no sea Libra ó Galon
SELECT *
FROM MateriaPrima
WHERE NOT UnidadMedida = 'Libra' AND NOT UnidadMedida = 'Galón'
--Recuerde que si el COLLATION de su base de datos es _AS quiere decir
--que no ignora la tildes (Accent Sensitive)

--otra forma:
SELECT *
FROM MateriaPrima
WHERE NOT UnidadMedida IN ('Libra','Galón')

--otra forma: (usando parentesis)
SELECT *
FROM MateriaPrima
WHERE NOT (UnidadMedida = 'Libra' OR UnidadMedida = 'Galón')

--Combinaciones de operadores logicos -----------------------------------------------------
--No olviden que los parentesis cambian el sentido de las expresiones

--Mostrar las materias primas cuya unidad de media no sea libra Y cuyo costo promedio ente entre 50 y 70
--Ordenar por costo promedio.
SELECT *
FROM MateriaPrima
WHERE NOT UnidadMedida = 'Libra' AND ( CostoPromedio >= 50 AND CostoPromedio <= 70 )
ORDER BY CostoPromedio

--Mostrar las materias primas cuyo precio de compra este entre 5 y 10 ó entre 70 y 90
--ordenar por precio de compra de mayor a menor
SELECT *
FROM MateriaPrima
WHERE (PrecioCompra >= 5 AND PrecioCompra <= 10) OR (PrecioCompra >= 70 AND PrecioCompra <= 90)
ORDER BY CostoPromedio

--lo anterior se puede escribir de otra forma:
SELECT *
FROM MateriaPrima
WHERE PrecioCompra BETWEEN 5 AND 10 OR PrecioCompra BETWEEN 70 AND 90
ORDER BY CostoPromedio

--WHERE CON CAMPOS CALCULADOS ------------------------------------------------

--para la base de datos pubs: mostrar todos los empleados que fueron contratatos en 1990
--concatenar el primer nombre y el primer apellido en una sola columna llamada name
--ordene los datos por dicha columna
SELECT CONCAT(fname,' ',lname) as name, hire_date
FROM pubs.dbo.employee
WHERE YEAR(hire_date) = 1990
ORDER BY 1

--mostrar todos los clientes cuyo mes de nacimiento es Octubre y cuyo dia de nacimimento es 15
SELECT *
FROM Cliente
WHERE MONTH(Nacimiento) = 10 AND DAY(Nacimiento) = 15

--mostrar todas las facturas emitidas en el mes de octubre de cualquier dia; pero que esten
--entre las 3 y 5 PM
SELECT *
FROM FacturaCab
WHERE MONTH(Fecha) = 10 AND DATEPART(HOUR, Fecha) BETWEEN 3 AND 5

--mostrar todas las facturas que hallan generado ganancias de mas de 1000, ordenadas de acuerdo a la ganancia
--de mayor a menor: debera mostrar FacturaID, Fecha, Total, CostoPromedioTotal y la Ganancia
SELECT  FacturaID, Fecha, Total, CostoPromedioTotal, Total-CostoPromedioTotal as Ganancia
FROM FacturaCab
WHERE Total-CostoPromedioTotal > 1000
ORDER BY 5 DESC

--Importante en el WHERE NO SE PUEDE usar el ALIAS para referirse a un campp calculado:
SELECT  FacturaID, Fecha, Total, CostoPromedioTotal, Total-CostoPromedioTotal as Ganancia
FROM FacturaCab
WHERE Ganancia > 1000
ORDER BY 5 DESC

--Mostrar todas las facturas emitidas en Octubre y Noviembre; pero que NO hallan sido
--generadas a las 8, 11 o 19 horas.
SELECT *
FROM FacturaCab
WHERE MONTH(Fecha) IN (10,11) AND NOT DATEPART(HOUR,Fecha) IN (8,11,19)

--WHERE Y VALORES NULL ------------------------------------------------------
--IMPORTANTE: los valores NULL no pueden ser comparados con =
--estos se deben comparar con el operador IS

--Mostrar todos aquellos clientes cuyo Telefono1 sea NULL
--incorrecto: usar = (no devuelve nada; pero no da error)
SELECT *
FROM Cliente
WHERE Telefono1 = NULL

--correcto: usar IS
SELECT *
FROM Cliente
WHERE Telefono1 IS NULL

--Mostrar los clientes cuyo Telefono1 NO sea NULL
--forma 1:
SELECT *
FROM Cliente
WHERE Telefono1 IS NOT NULL

--forma 2:
SELECT *
FROM Cliente
WHERE NOT Telefono1 IS NULL

--Mostrar las facturas que tengan valor en UsuarioAnula generadas en el turno A
SELECT *
FROM FacturaCab
WHERE UsuarioAnula IS NOT NULL AND Turno = 'A'

--WHERE con Fecha/Hora ---------------------------------------------------------
--Mostrar todas las facturas cuya fecha sea el 2 de Septiembre de 2010
--Forma 1:
SELECT *
FROM FacturaCab
WHERE YEAR(Fecha) = 2010 AND MONTH(Fecha) = 9 AND DAY(Fecha) = 2

--Forma 2: por medio de la conversion de la fecha/hora a un formato unicamente de fecha
SELECT *
FROM FacturaCab
WHERE CAST(Fecha as DATE) = '2010/09/02'

--Y si necesitamos filtrar a cierta hora del dia?
--Mostrar todas las facturas realizadas el 2 de Septiembre de 2010 a las 9 PM
--Forma 1: mas larga; pero segura
SELECT *
FROM FacturaCab
WHERE YEAR(Fecha) = 2010 AND MONTH(Fecha) = 9 AND DAY(Fecha) = 2 AND DATEPART(HOUR,Fecha) = 21

--Forma 2: Comparar usando un rango de fecha/hora por medio de BETWEEN
SELECT *
FROM FacturaCab
WHERE Fecha BETWEEN '02/09/2010 21:00:00' AND '02/09/2010 21:59:59'

--SUBCONSULTAS --------------------------------------------------------------------------------
/*Son consultas que se pueden incrustar dentro de otras consultas.
-> Siempre van entre parentesis.
-> Solo deben contener una columna (un campo)
-> Si no se usan con moderacion pueden llegar a costar muchos recursos y hacer mas
   lentas las consultas.
-> Para evitar abusar de la subconsultas es mejor ir pensando en hacer buenas implementaciones
   de los JOIN los cuales veremos mas adelante.

--Subconsulta que alimenta una lista de seleccion IN----------------------------------------*/
SELECT *
FROM Producto
WHERE ProductoCategoriaID IN ( SELECT ProductoCategoriaID FROM ProductoCategoria WHERE Nombre LIKE '%bebida%' )
/*En una subconsulta que alimenta una lista de seleccion IN debe unicamente hacerse referencia
a un campo que tenga relacion con la columna que ejecuta la lista IN. Tanto la columna origen
como la columna destino deben de ser del mismo tipo de dato o al menos compatible.*/

--Si pone mas de una columna en la subconsulta se generara un error:
SELECT *
FROM Producto
WHERE ProductoCategoriaID IN ( SELECT * FROM ProductoCategoria WHERE Nombre LIKE '%bebida%' )
--ya que la subconsulta solo debe devolver un campo y no varios (*)

--Columna destino debe de ser de tipo compatible con columna origen, sino habrá error:
SELECT *
FROM Producto
WHERE ProductoCategoriaID IN ( SELECT Descripcion FROM ProductoCategoria WHERE Nombre LIKE '%bebida%' )

--Otro ejemplo:
--todos los detalles de facturas cuyo productoID en su descripcion tenga la palabra baleada
SELECT *
FROM FacturaDet
WHERE ProductoID IN ( SELECT ProductoID FROM Producto WHERE Descripcion LIKE '%baleada%' )
ORDER BY ProductoID

--Subconsulta para alimentar un valor en una columna -------------------------------------
--A esto se le conoce como Escalar o Valor escalar porque la subconsulta debe devolver una fila y una columna TOP(1)
--En estos casos se recomienda colocar un ALIAS a cada TABLA (Renombramiento).

--Mostrar el codigo y descripcion de todos los productos, ademas de agregar una columna
--que muestre el nombre de la categoria a la que cada producto pertenece usando subconsultas
--IMPORTANTE: este problema se puede resolver de forma mas optima usando JOIN.
SELECT	a.Codigo, a.Descripcion,
		( SELECT TOP(1) b.Nombre FROM ProductoCategoria as b WHERE a.ProductoCategoriaID = b.ProductoCategoriaID ) as Categoria
FROM Producto as a
/*Observem que a la tabla ProductoCategoria en la subconsulta le he colocado un ALIAS el cual es b
y a Producto le he colocado un ALIAS el cual es a. Esto se hace para que al establecer una relacion entre
tablas se sepa a que tabla corresponen cada columna en la relación.
-> En resumen para cada registro en A va a buscar un registro en B que haga MATCH de acuerdo al WHERE
en la subconsulta.
-> Abusar de esto cuesta muchos ciclos de CPU y Memoria (use JOIN en su lugar)*/

--Los alias pueden ir sin la palabra AS:
SELECT	a.Codigo, a.Descripcion,
		( SELECT TOP(1) b.Nombre FROM ProductoCategoria b WHERE a.ProductoCategoriaID = b.ProductoCategoriaID ) Categoria
FROM Producto a

