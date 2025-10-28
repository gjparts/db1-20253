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