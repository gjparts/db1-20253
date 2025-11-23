/*Instruccion UPDATE: Modifica los valores de uno o
varios registros de la tabla.
-> Se recomienda combinarlo junto WHERE
-> Se recomienda hacer una vista previa por medio de SELECT
   para saber que registros va a afectar.*/
USE BaleadasGPT
GO

--UPDATE sin WHERE (potencialmente peligroso) ---------------------
--Ejemplo: dejar en cero el area en metros para todas las bodegas
--Vista previa:
SELECT * FROM Bodega
--aplicar cambios:
UPDATE Bodega
SET AreaEnMetros = 0
--lo anterior afecta a todos registros de la tabla
--lo que en ciertas circunstancias puede ser peligroso.

--UPDATE con WHERE (mas seguro) -------------------------------------------
--Colocar 200 al area en metros para la bodegas con numero 2, 3 y 5
--Vista previa:
SELECT *
FROM Bodega
WHERE Numero IN (2,3,5)

--aplicacion de cambios:
UPDATE Bodega
SET AreaEnMetros = 200
WHERE Numero IN (2,3,5)

--Mas ejemplos:
--convertir a mayusculas el nombre de la bodega 1
--Vista previa:
SELECT *
FROM Bodega
WHERE Numero = 1

--aplicacion de cambios:
UPDATE Bodega
SET Nombre = UPPER(Nombre)
WHERE Numero = 1

--colocar en NULL las observaciones para las bodegas cuyo numero esté entre 2 y 4 incluyendolos
--Vista previa:
SELECT *
FROM Bodega
WHERE Numero BETWEEN 2 AND 4

--aplicacion de cambios:
UPDATE Bodega
SET Observaciones = NULL
WHERE Numero BETWEEN 2 AND 4

/*Tambien es posible afectar varios campos -------------------------------
Colocar en 100 el area en metros, Revisado como Observacion y
fecha de registro NULL para las bodegas con nombres:
Bodega Choloma, Bodega Yoro, Bodega Guamilito, Bodega abandonada, Bodega Islas*/
--Vista previa:
SELECT *
FROM Bodega
WHERE Nombre IN('Bodega Choloma', 'Bodega Yoro', 'Bodega Guamilito', 'Bodega abandonada', 'Bodega Islas')

--aplicacion de cambios:
UPDATE Bodega
SET AreaEnMetros = 100, Observaciones = 'Revisado', FechaRegistro = NULL
WHERE Nombre IN('Bodega Choloma', 'Bodega Yoro', 'Bodega Guamilito', 'Bodega abandonada', 'Bodega Islas')

/*Coloque el area en metros igual a 50 y en mayusculas todos los nombres de todas
las bodegas cuyo nombre termine con la letra O ó A y que en Observaciones lleve en cualquier parte
la palabra: Revisa*/
--Vista previa:
SELECT *
FROM Bodega
WHERE (Nombre LIKE '%O' OR Nombre LIKE '%A') AND Observaciones LIKE '%revisa%'

--aplicacion de cambios:
UPDATE Bodega
SET AreaEnMetros= 50, Nombre = UPPER(Nombre)
WHERE (Nombre LIKE '%O' OR Nombre LIKE '%A') AND Observaciones LIKE '%revisa%'

/*Antes de continuar vamos a restaurar un BACKUP de la base de dtos BaleadasGPT
Pero le vamos a colocar como nombre COPIA a esta nueva base de datos.
--> Esto lo hacemos para hacer pruebas en COPIA y asi no afectar a BaleadasGPT*/

--pasemos a la base de datos copia
USE COPIA
GO

--en la base de datos copia:
/*Colocar como Estado el valor REV para todas las facturas realizadas
antes de las 8 AM el dia 10 de Septiembre de 2010*/
--Vista previa:
SELECT *
FROM FacturaCab
WHERE CAST(Fecha as TIME) < '8:00' AND CAST(Fecha AS Date) = '2010/09/10'

--aplicacion de cambios:
UPDATE FacturaCab
SET Estado = 'REV'
WHERE CAST(Fecha as TIME) < '8:00' AND CAST(Fecha AS Date) = '2010/09/10'

--en la base de datos copia:
/*Concatenar la palabra VIP a los comentarios para todos los clientes cuyo Pais sea
Honduras ó Local*/
--Vista previa:
SELECT *
FROM Cliente
WHERE Pais IN ('Honduras','Local')

--aplicacion de cambios:
UPDATE Cliente
SET Comentarios = CONCAT(Comentarios,' VIP')
WHERE Pais IN ('Honduras','Local')

--UPDATE tambien se puede combinar con JOIN ------------------
--en la base de datos copia:
/*Coloque en CERO la columna MostrarEnFacturacion, coloque tambien
el valor Extras en la columna Etiqueta para todos los productos
con categoria llamada Otros ó Adiciones*/
--Vista previa:
SELECT *
FROM Producto a
	INNER JOIN ProductoCategoria b ON a.ProductoCategoriaID = b.ProductoCategoriaID
WHERE b.Nombre IN ('Otros','Adiciones')

--aplicacion de cambios:
UPDATE Producto
SET MostrarEnFacturacion = 0, Etiqueta = 'Extras'
FROM Producto a
	INNER JOIN ProductoCategoria b ON a.ProductoCategoriaID = b.ProductoCategoriaID
WHERE b.Nombre IN ('Otros','Adiciones')
/*Observe que primero se hace la vista previa y luego se copia a partir
del FROM de la misma, y antes del FROM va el UPDATE y el SET.
IMPORTANTE: El UPDATE con JOIN solo afecta a la tabla junto al FROM que
debe de ser la misma junto al UPDATE*/

--Otro ejemplo:
--en la base de datos copia:
/*Colocar el valor OJO para el Estado de las facturas realizadas
en Septiembre de 2010 y donde el Pais de los clientes de dichas
facturas NO sean de Honduras o de Local*/
SELECT *
FROM FacturaCab a
	INNER JOIN Cliente b ON a.ClienteID = b.ClienteID
WHERE	MONTH(a.Fecha) = 9 AND YEAr(a.Fecha) = 2010
		AND NOT b.Pais IN ('Honduras','Local')

--aplicacion de cambios:
UPDATE FacturaCab
SET Estado = 'OJO'
FROM FacturaCab a
	INNER JOIN Cliente b ON a.ClienteID = b.ClienteID
WHERE	MONTH(a.Fecha) = 9 AND YEAr(a.Fecha) = 2010
		AND NOT b.Pais IN ('Honduras','Local')

--Otro ejemplo:
--en la base de datos copia:
/*Coloque en cero la cantidad para los detalle de compras realizadas
en Diciembre de 2010 y cuyas materias primas tenga como unidad de medida Libra
y cuya cantidad sea <= 10*/
SELECT *
FROM CompraDet a
	INNER JOIN CompraCab b ON a.CompraID  = b.CompraID
	INNER JOIN MateriaPrima c ON a.MateriaPrimaID = c.MateriaPrimaID
WHERE	YEAR(b.Fecha) = 2010 AND MONTH(b.Fecha) = 12
		AND c.UnidadMedida = 'Libra' AND a.Cantidad <= 10

--aplicacion de cambios:
UPDATE CompraDet
SET Cantidad = 0
FROM CompraDet a
	INNER JOIN CompraCab b ON a.CompraID  = b.CompraID
	INNER JOIN MateriaPrima c ON a.MateriaPrimaID = c.MateriaPrimaID
WHERE	YEAR(b.Fecha) = 2010 AND MONTH(b.Fecha) = 12
		AND c.UnidadMedida = 'Libra' AND a.Cantidad <= 10
