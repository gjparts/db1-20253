/*DDL: Data Definition Language
Es el lenguaje de definicion de datos y son las instrucciones
usadas para interacturas con los objetos de la base de datos
como ser: Tablas, Vistas, Funciones, Stored Procedures, etc.
Las instrucciones mas utilizadas son: CREATE, ALTER, TRUNCATE y DROP.*/

--Creacion de una base de datos
CREATE DATABASE Supermercado
GO

--borrar una base de datos existente (peligroso)
--1) cambiarse a la base de datos master para dejar de
--usar la base de datos a borrar
USE master
GO
--eliminar la bd
DROP DATABASE Supermercado
GO

/*Si la base de datos no se puede eliminar con los pasos anteriores
deberá reiniciar el servicio de SQL SERVER e intentar eliminarla
 de nuevo asegurandose que nadie la este intentando usar.*/

 --Crear una tabla
 --primero pasarse a la base de datos:
USE Supermercado
GO
--segundo definir la estructura de la tabla:
CREATE TABLE Bodega
(
	BodegaID		bigint NOT NULL IDENTITY(1,1),
	Nombre			varchar(50) NOT NULL,
	Area			decimal(12,2) NOT NULL,
	Disponible		bit NOT NULL,
	FechaRegistro	date NULL,
	Direccion		varchar(max) NULL,
	CONSTRAINT pkBodega PRIMARY KEY(BodegaID)
)
GO
/*Tipos de datos:
--Almacenamiento de numeros enteros:
	tinyint		1 byte	2^8
	smallint	2 bytes	2^16
	int			4 bytes	2^32
	bigint		8 bytes	2^64
--Almacenamiento de valores booleanos: bit	(1 ó 0)
--Almacenamiento de texto:
	varchar	 (cada caracter ocupa 1 byte, funciona con 1 alfabeto, no desperdicia espacio de almacenamiento)
	nvarchar (cada caracter ocupa 2 bytes, funciona multiples alfabetos, es como el varchar)
	text	 (obsoleto aun soportado use en su lugar varchar(max) cada celda puede llegar a guardar 2GB)
	char	 (guarda texto, 1 byte por caracter, si no usa todo el tamaño el resto se rellena
	          de espacios en blanco, desperdicia almacenamiento)
--Almacenamiento de numeros decimales
	float		4 a 8 bytes
	decimal		5 a 17 bytes
	number		otra forma de nombrar decimal
--Almacenamiento de tiempo:
	Date		solo fecha
	Time		solo hora
	DateTime	fecha y hora

Condiciones de Nulidad:
	NOT NULL	la columna no admite valores nulos (es obliogatoria)
	NULL		la columna si admite valores nulos (es opcional)

Que es eso de IDENTITY?
Es una clausula que indica que la columna va a ser autonumerada por la BD,
tiene dos parametros:
	el primero indica desde donde vamos a comenzar a contar
	el segundo indica cuando seran los saltos de numeracion entre cada registro.

Que es eso otro de PRIMARY KEY?
Indica cuales o cual va a ser el campo utilizado para hacer único a cada
registro, o sea que el campo que indiquemos ahí va a ser usado para colocar
un valor unico el cual identificará a cada registro, el nombre pkBodega es el
nombre que le daremos a la llave primaria para reconocerla, es una buena práctica
colocar nombres a las llaves primarias.
La palabra constraint se traduce como restricción.
-> La implementación de llaves primarias en las tablas es conocida como Integridad de Entidad.
-> IMPORTANTE: una tabla no puede tener dos llaves primarias; pero si puede tener varias
   columnas como llave primaria.
*/
--ver la informacion de la tabla creada:
sp_help Bodega
GO

--borrar una tabla de la bd:
DROP TABLE Bodega
GO

--Insertar registros de prueba en la tabla bodega:
INSERT Bodega VALUES('Principal',344.45,1,'2025/11/25','En algun lugar')
INSERT Bodega VALUES('Secundaria',100,1,'2025/11/25',NULL)
INSERT Bodega VALUES('Ceiba',202.4,0,NULL,'Cerca del mar')

INSERT Bodega VALUES('Comayagua Comayagua Comayagua Comayagua Comayagua Comayagua Comayagua',400,1,NULL,NULL)
--como el campo Nombre en Bodega soporta 50 caracteres varchar(50) si nos pasamos
--de ese tamaño tendremos un error que los datos deberia ser truncados (truncated)
--y el registro no va a ser insertado

--Cambiar el tamaño de una columna existente de una tabla
--sin necesidad de borrar los datos de la tabla
ALTER TABLE Bodega
ALTER COLUMN Nombre varchar(100) NOT NULL
GO
--lo anterior aumenta el tamaño de la columna Nombre de 50 a 100 caracteres
--ya podemos insertar el registro:
INSERT Bodega VALUES('Comayagua Comayagua Comayagua Comayagua Comayagua Comayagua Comayagua',400,1,NULL,NULL)

--Se puede cambiar la condicion de nulidad de una columna? Si
ALTER TABLE Bodega
ALTER COLUMN Direccion varchar(max) NOT NULL
GO
--lo anterior no va a permitir porque hay valores nulos en Direccion
--para poder hacerlo debera llenar esos valores nulos antes:
UPDATE Bodega SET Direccion = '' WHERE Direccion IS NULL
--hecho lo anterior ya se puede cambiar la Direccion a obligatoria.

--Agrega una columna a una tabla ya existente -------------
ALTER TABLE Bodega
ADD Encargado varchar(100) NULL

--Agregar una columna que no admite nulos en una tabla
--que ya tiene datos, para ello debe seguir estos pasos:
--1) Agregar la columna pero aceptando NULL
ALTER TABLE Bodega
ADD Tipo varchar(8) NULL
--2) haga un UPDATE para dicha columna en la tabla y rellene
--   los registros existentes con un valor predeterminado:
UPDATE Bodega SET Tipo = 'Normal'
--3) ya con datos en la nueva columna la alteramos a NOT NULL:
ALTER TABLE Bodega
ALTER COLUMN Tipo varchar(8) NOT NULL

--Eliminar una columna de una tabla ---------------
ALTER TABLE Bodega
DROP COLUMN Encargado
--ojo: se pierde la info. de la columna

--Crear una tabla sin campo autonumerico; pero con llave primaria
CREATE TABLE Categoria
(
	Codigo	varchar(10) NOT NULL,
	Nombre	varchar(50) NOT NULL,
	Comentarios varchar(max) NULL,
	CONSTRAINT pkCategoria PRIMARY KEY(Codigo)
)
GO

INSERT Categoria VALUES('B01','Bebidas',NULL)
INSERT Categoria VALUES('V10','Verduras','Mantener frescas')
INSERT Categoria VALUES('F00','Frutas','Mantener frescas')
INSERT Categoria VALUES('B02','Bebidas alcoholicas','no venda a menores')
INSERT Categoria VALUES('B03','Bebidas energizantes',NULL)

--y que pasa si coloca un valor repetido en un campo que es llave primaria?
INSERT Categoria VALUES('B01','Bebidas varias',NULL)
--obtendra un error de duplicate key o clave duplicada.

SELECT * FROM Categoria

--Crear una tabla sin llave primaria (no recomendado)
CREATE TABLE Amigos
(
	Nombre varchar(100) NOT NULL,
	EMail  varchar(255) NOT NULL
)
GO

--insertar registros
INSERT Amigos VALUES('Gerardo','gerardo.portillo@unah.edu.hn')
INSERT Amigos VALUES('Totoro','no tiene')
INSERT Amigos VALUES('Spiderman','spiderman@avengers.com')

--insertar registro parecido a otro
INSERT Amigos VALUES('Totoro','sin correo')

--eliminar Amigos con nombre totoro
DELETE FROM Amigos WHERE Nombre = 'Totoro'
--Observe que se borran los dos registors Totoro porque
--no hay algo que haga unico a cada registro; la salida para solo eliminar
--un Totoro es haciendo match completo campo por campo:
DELETE Amigos WHERE Nombre = 'Totoro' AND EMail = 'no tiene'

--por tal razon es importante el uso de llaves primarias.

/*Agregar llave primaria con autonumeracion a tabla ya existe --------------------
y la cual no tiene llave primaria ni campo autonumerico:*/
--1) primero, agregar campo autonumerico:
ALTER TABLE Amigos
ADD AmigoID bigint NOT NULL IDENTITY(1,1)
GO
--2) segundo, agregue la llave primaria:
ALTER TABLE Amigos
ADD CONSTRAINT pkAmigos PRIMARY KEY(AmigoID)

--verificar:
sp_help Amigos
GO

SELECT * FROM Amigos

--Crear una tabla con llave primaria compuesta
--Una llave primaria puede llegar a tener dos o mas campos
CREATE TABLE Departamentos
(
	Pais			varchar(50) NOT NULL,
	Departamento	varchar(150) NOT NULL,
	Comentarios		varchar(max) NULL,
	CONSTRAINT pkDepartamentos PRIMARY KEY(Pais,Departamento)
)
GO

--verificar:
sp_help Departamentos
GO

--insertar registros:
INSERT Departamentos VALUES('Honduras','Cortes',NULL)
INSERT Departamentos VALUES('Honduras','Francisco Morazan','La capital esta aqui')
INSERT Departamentos VALUES('Honduras','Comayagua',NULL)
INSERT Departamentos VALUES('Honduras','La Paz',NULL)
INSERT Departamentos VALUES('Bolivia','La Paz',NULL)

--intentar violentar la llave primaria compuesta:
INSERT Departamentos VALUES('Honduras','Cortes',NULL)
--la llave primaria compuesta verifica que no halla dos registros con la misma
--combinacion de campos en este caso Pais, Departamento.

--mas intentos:
INSERT Departamentos VALUES('Honduras','Cortes','en el norte del pais')
--tampoco va a dejar poque Comentarios no es parte de la llave primaria compuesta

INSERT Departamentos VALUES('Honduras','Cortés','en el norte del pais')
--la tilde ya cambia el sentido y permite insertarlo porque no es lo mismo
--Cortés que Cortes

SELECT * FROM Departamentos