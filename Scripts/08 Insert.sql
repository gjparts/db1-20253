/*Demas instrucciones DML
Antes de hablar de las demas instrucciones del DML vamos a crear una tabla
para practicar en ella la insercion, eliminado y actualizacion de datos.
Por el momento no se preocupen por la explican de como crear tablas
porque eso lo vamos a tener en el contenido que sigue.*/
--primero pasar a la base de datos donde va a crear la tabla:
USE BaleadasGPT
GO
CREATE TABLE Bodega(
	Numero INT	NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	AreaEnMetros DECIMAL(12,2) NOT NULL,
	Observaciones VARCHAR(100) NULL,
	FechaRegistro DATE NULL,
	PRIMARY KEY(Numero)
)
GO
--borrar la tabla creada: (destruir la tabla)
DROP TABLE Bodega
GO

--saber que columnas y llaves tiene una tabla
sp_help Bodega
GO

/*Importante: el GO es recomendado luego de usar SP_HELP o de usar alguna instruccion del DDL.
No es obligatorio.
Observe que en SP_HELP se muestra por cada columna el tipo de dato (type) su longitud en bytes (Length),
la longitud en digitos (Prec) y la cantidad de decimales reservados (Scale). En la columna Nullable
se menciona si cada campo de la tabla acepta o no valores nulos.*/

/*Instruccion INSERT: agrega uno o varios registyros a una tabla.
Consideraciones:
-> INSERT debe incluir todos los campos NOT NULL los cuales son obligatorios excepto el campo marcado como IDENTITY.
-> Los campos NULL son opcionales, se pueden incluir solo si Usted lo requiere.

Existes varias formas de insertar en una tabla:
1) Por correspondencia
2) Indicando las columnas para cada registro
3) Por medio del resultado de una consulta

Insercion por correspondencia: --------------------------------------------------------
Ocurre cuando en el INSERT no se menciona las columnas de la tabla a afectar.
-> Esto hace que sea obligatorio colocar los valores para todas las columnas sean o n obligatorias
   excepto para el campo IDENTITY.
-> Los valores se colocan de acuerdo al orden de las columnas dentro de la tabla
*/
INSERT Bodega VALUES(1,'Bodega Principal',100.4,'La mas centrica','2015/11/15')
/*Note que dentro de VALUES se colocó los valores para las 5 columnas de la tabla
las columnas de tipo texto y fecha van entre comillas simples '' en cambio las 
de numeros (int, decimal) no llevan dichas comillas.*/
--insertemos mas bodegas:
INSERT Bodega VALUES(2,'Bodega Guamilito',70.5,'Para papeleria','2025/11/18')
INSERT Bodega VALUES(3,'Bodega Bermejo',400,'Aqui se deposita equipo de cocina','2025/11/18')
INSERT Bodega VALUES(4,'Bodega Choloma',1000.25,'Destinada a containers','2025/11/18')

/*En las tablas existen columnas llamadas PRIMARY KEY o llave primaria.
Si ve la tabla con sp_help vera que en una parte se menciona sobre la llave primaria.
Estas columnas hacen unico a cada registro e impiden que alguien inserte un valor
duplicado en dicha columna.
que pasa si intenta insertar un valor duplicado en una columna Primary key?*/
INSERT Bodega VALUES(2,'Bodega random',50,'Aqui va pura basura','2025/11/18')
--lo anterior devolverá un error de clave duplicada (duplicated key)
--para resolverlo deberá colocar el valor correspondiente a la llave primaria como un valor
--que no se halla utilizado antes:
INSERT Bodega VALUES(5,'Bodega random',50,'Aqui va pura basura','2025/11/18')

--que pasa si intenta hacer un insert por correspodencia y todos los valores
--de la tabla no son especificados?:
INSERT Bodega VALUES(6,'Bodega La Guardia')
--obtendra un error indicando que los valores no corresponden a la definicion de la tabla

--Que pasa si intenta insertar un registro y el tipo de dato de cada valor
--no concuerca con el tipo de dato de cada columna?
INSERT Bodega VALUES('Bodega La Guardia','2025/11/17',6,'Soy una observacion',200)
--obtendra un errro de conversion

/*Insercion indicando las columnas para cada registro: -------------------------------
Consiste en mencionar que columnas de la tabla va a llenar en el INSERT.
En este caso lo valores de cada columna serán de acuerdo al orden en que las defina.*/
INSERT Bodega(Numero, Nombre, AreaEnMetros, Observaciones, FechaRegistro)
VALUES(6,'Bodega El Benque',200,'en construcciones','2025/11/17')

INSERT Bodega(Nombre, Numero, Observaciones, FechaRegistro, AreaEnMetros)
VALUES('Bodega Zona Viva',7,'Aqui van las bebidas','2025/11/18',250)
--Observe que en este caso el orden de las columnas no es el mismo definido en la tabla
--lo que indica que INSERT cuando se define las columnas no obliga a respetar el orden original

--El INSERT que define columnas nos permite omitir aquellas que sean opcionales (NULL)
--podemos ignorarlas si asi lo deseamos:
INSERT Bodega(Numero, Nombre, AreaEnMetros, FechaRegistro)
VALUES(8,'Bodega Tegucigalpa',200,'2025/11/18')
--en el ejemplo anterior ignoramos el valor para Observaciones

--otro ejemplo: ignoremos FechaRegistro
INSERT Bodega(Numero, Nombre, AreaEnMetros, Observaciones)
VALUES(9,'Bodega La Ceiba',500,'para almacenar producto importado por mar')

--otro ejemplo: ignoremos FechaRegistro y Observaciones
INSERT Bodega(Numero, Nombre, AreaEnMetros)
VALUES(10,'Bodega Yoro',300)

--Tambien es posible no mencionar la columnas (por correspondencia) y poner NULL a los values
--para las columnas opcionales.
INSERT Bodega VALUES(11,'Bodega abandonada',50,NULL,NULL)
--o tambien indicando las columnas:
INSERT Bodega(Numero, Nombre, AreaEnMetros, Observaciones, FechaRegistro)
VALUES(12,'Bodega en ruinas',10,NULL,NULL)

--INSERT Multiregistro ----------------------------------------------
--es posible tambien agregar varios registros mediante una sola definicion de INSERT
--el siguiente ejemplo agrega varios registros por correspondencia:
INSERT Bodega
VALUES
(13,'Bodega Puerto Cortés',1000,'Para desembarco','2025/11/20'),
(14,'Bodega La Masica',200.5,NULL,'2025/11/20'),
(15,'Bodega El Rodeo',400.1,'Cosas Varias','2025/11/20'),
(16,'Bodega El Carmen',300,'Equipo de mantenimiento',NULL),
(17,'Bodega Rivera Hernandez',100,NULL,NULL)

--otro ejemplo; pero indicando las columnas:
INSERT Bodega(Numero, Nombre, AreaEnMetros, Observaciones, FechaRegistro)
VALUES
(18,'Bodega en la zona negativa',30,NULL,'2025/11/20'),
(19,'Bodega Express',100.25,'Para cosas express','2025/11/20'),
(20,'Bodega Islas',400,NULL,NULL)

--un ejemplo mas:
INSERT Bodega(Numero,Nombre,AreaEnMetros)
VALUES
(21,'Bodega Alfa',70.5),
(22,'Bodega Beta',300),
(23,'Bodega Omega',122.8)

/*Insercion por medio del resultado de una consulta -----------------------
Es posible volcar el resultadode una consulta SELECT hacia un INSERT
de tabla.
IMPORTANTE: los datos de la consulta deben de ser compatibles con el tipo
de dato de cada columna en la tabla donde se va a insertar.*/
SELECT * FROM Bodega
SELECT * FROM Cliente

--Debe diseñar su consulta (origen) de tal manera que las columnas de la misma
--concuerden con las columnas del INSERT para la tabla destino.
INSERT BaleadasGPT.dbo.Bodega(Numero, Nombre, AreaEnMetros,Observaciones,FechaRegistro)
SELECT ClienteID*100, TRIM(Nombre), 100, Comentarios, Nacimiento FROM Cliente

--Ahora vamos a insertar datos desde otra base de datos (siempre y cuando esten en el mismo server)
--primero previsualice las tablas origen y destino
SELECT * FROM BaleadasGPT.dbo.Bodega
SELECT * FROM AdventureWorks.Sales.Store

--consulta:
SELECT * FROM BaleadasGPT.dbo.Bodega
SELECT TOP(5) SalesPersonID*10, Name, 0, NULL, ModifiedDate FROM AdventureWorks.Sales.Store

--insercion:
INSERT BaleadasGPT.dbo.Bodega
SELECT TOP(5) SalesPersonID*10, Name, 0, NULL, ModifiedDate FROM AdventureWorks.Sales.Store

SELECT * FROM Bodega

/*INSERT cuando existe un campo autonumerico o identity --------------------------------
Algunas tablas cuentan con campos que son autonumerados por
el propio motor de base de datos, aqui se debe tener ciertas consideraciones:*/

--Primero, crearemos una tabla que lleve un campo autonumerico
CREATE TABLE Profesion(
	ProfesionID bigint NOT NULL IDENTITY(1,1),
	Nombre varchar(50) NOT NULL,
	SalarioPromedio decimal(12,2) NULL,
	PRIMARY KEY(ProfesionID)
)
GO

DROP TABLE Profesion
GO

sp_help Profesion
GO

--Insercion por correspondencia
INSERT Profesion VALUES ('Programador',80000)
/*Observe que no se coloco VALUES a la columna ProfesionID,
esto se debe a que dicha columna es Identity.*/

--Mas ejemplos:
INSERT Profesion VALUES('Chef',30000)
INSERT Profesion VALUES('Guardia de Seguridad',25000)
INSERT Profesion VALUES('Astronauta',NULL)

--si llega a fallar una insercion, la base de datos perderá ese numero
--esto es considerado una desventaja.
INSERT Profesion VALUES('Hojalatero','esto deberia ser un numero')
--insercion correcta:
INSERT Profesion VALUES('Hojalatero',20000)
--observe que se perdio un numero por causa del error
SELECT * FROM Profesion

--insert multiregistro
INSERT Profesion
VALUES
('Policia',30000),
('Medico',NULL),
('Docente',40000)

--Insercion, indicando las columnas
INSERT Profesion(Nombre,SalarioPromedio)
VALUES('Gerente',50000)
--no se meciona la columna identity

INSERT Profesion(Nombre)
VALUES('Taxista')

INSERT Profesion(Nombre, SalarioPromedio)
VALUES
('Albañil',NULL),
('Etrenador Pokémon',70000),
('Bartender',45000),
('Diputado',0)

INSERT Profesion(Nombre)
VALUES
('Acrobata'),
('Gamer'),
('Trailero')

SELECT * FROM Profesion