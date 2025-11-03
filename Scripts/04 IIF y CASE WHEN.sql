/*Funciones de seleccion
Permiten determinar el valor de una columna por medio del cumplimiento de condiciones.
Las mas usadas son:
-> IIF			funciona como el operador ternario
-> CASE WHEN	funciona como la escructura switch de C++ permitiendo elegir entre varios casos

-> en IIF y CASE WHEN todos los valores de salida deben de ser del mismo tipo de dato.

-> IIF existe en SQL SERVER desde la version 2012, antes de esa version utilice CASE WHEN
-> IIF en otros DBMS se llama simplemente IF (MySQL)*/
USE BaleadasGPT
GO

/*Mostrar el codigo, descripcion, precio de venta de todos los productos.
-> Proyectar una columna llamada "Tasa ISV" donde si pagaISV es 1 entonces que muestre 0.15 de lo contrario que muestre 0.00
-> Mostrar otra columna llamada "Tasa ISV Lujo" donde si pagaISVLujo es 1 entonces que muestre 0.18 de lo contrario que muestre 0.00
-> Mostrar una columna mas, que indique si el producto paga algun tipo de impuesto en caso de que pasaISV ó PagaISVLujo sean 1
   mostrar la palabra Si de lo contrario mostrar No.*/

--Forma 1: usando IIF (solo SQL SERVER desde 2012)
SELECT	Codigo, Descripcion, PrecioVenta,
		IIF(PagaISV = 1,0.15,0.00) as [Tasa ISV],
		IIF(PagaISVLujo = 1,0.18,0.00) as [Tasa ISV Lujo],
		IIF(PagaISV = 1 OR PagaISVLujo = 1,'Si','No') as [Paga Algun Impuesto]
FROM Producto