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

--uso del WHERE: se usa para filtrar la informacion de una consulta.-----------------------------
