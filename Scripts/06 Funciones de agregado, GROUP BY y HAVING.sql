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





