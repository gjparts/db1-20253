/*Integridad de Dominio:
Es conocido como el tercer tipo de integridad declarativa que se asegura
de mantener la precisión y exactitud de la información garantizando que los
datos se mantengan en un conjunto determinado (dominio).
Se implementa por medio de:
1) valores predeterminados (default)
2) checks (restricciones de columna)
3) rules (reglas)
4) Tipos de dato definidos por el usuario
*/
--para esta práctica haremos una nueva base de datos
CREATE DATABASE Dominio
GO
USE Dominio
GO

--VALORES PREDETERMINADOS (DEFAULT)----------------------------------------------------
--Se utilizan para establecer un valor de inicio cuando este no es definido a la hora de insertar.
--> Una columna solo puede tener asignado un DEFAULT a la vez.
--> Un DEFAULT se puede asignar tanto a columnas NULL como NOT NULL

--crearemos una tabla para nuestras pruebas:
CREATE TABLE Factura
(
	FacturaID	bigint NOT NULL,
	ClienteID	bigint NOT NULL,
	Fecha		date NOT NULL,
	SubTotal	decimal(12,2) NOT NULL,
	ISV			decimal(12,2) NOT NULL
)
GO
--Insertar algunos registros
INSERT Factura VALUES(1,1,'2025/12/15',100,15)
INSERT Factura VALUES(2,1,'2025/12/16',200,30)
INSERT Factura VALUES(3,1,'2025/12/17',10,1.5)
SELECT * FROM Factura
GO
--Como las 5 columnas son obligatorias pues es logico que nos veamos
--en la obligacion de llenar todos sus datos.
--Gracias al uso de valores predeterminados podemos decir que al insertar
--un nuevo registro y se de el caso de no asignar un valor a determinada columna;
--entonces se le asigne un valor predefinido.
--por ejemplo, en la tabla Factura que al insertar un registro
--y no se le asigne Fecha pues que automaticamente se ponga la fecha actual:

--primero se crea el valor default (aun no asociado a ninguna tabla)
CREATE DEFAULT dftFechaHoy as GETDATE()
GO

--ahora toca relacionar este default a la columna de la tabla:
sp_binDefault 'dftFechaHoy','Factura.Fecha'
GO
--Observe que Factura.Fecha se refiere a la tabla Factura y su columna Fecha.

--ahora hagamos nuestras pruebas:
--Agregamos una fila; pero no mecionamos la columna Fecha (a pesar que es obligatoria o NOT NULL)
INSERT Factura(FacturaID, ClienteID, SubTotal, ISV) VALUES (4,1,300,45)
--note que el registro fue insertado exitosamente a pesar de no colocar valor a Fecha:
SELECT * FROM Factura
GO
--y observe que Fecha toma como valor a la fecha actual como lo definimos al crear el
--valor Default dftFechaHoy el cual devolverá la fecha del servidor (GETDATE)

--Otro ejemplo:
--Para la tabla Factura colocaremos como valor predeterminado a 0.00 para las columnas SubTotal e ISV:
--1) crear el valor predeterminado:
CREATE DEFAULT dftCero as 0.00
GO

--2) Asignar el valor predeterminado recien creado a la columnas respectivas:
sp_binDefault 'dftCero','Factura.SubTotal'
GO
sp_binDefault 'dftCero','Factura.ISV'
GO

--hagamos las pruebas:
INSERT Factura(FacturaID, ClienteID) VALUES (5,1)
SELECT * FROM Factura
GO
--note que no mencionamos valor para SubTotal e ISV; entonces en esos casos la base
--de datos rellenará con el valor Default en este caso 0.00

--pero podemos seguir insertando nuestro registros con normalidad:
INSERT Factura VALUES(6,999,'2025/12/11',50,7.5)
INSERT Factura VALUES(7,123,'2025/12/17',400,60)
--o incluso omitir ya sea fecha, subtotal o isv gracias a los valores default:
INSERT Factura(FacturaID, ClienteID, Fecha) VALUES (8,1,'2025/12/01')
INSERT Factura(FacturaID, ClienteID, SubTotal, ISV) VALUES (9,1,500,75)
INSERT Factura(FacturaID, ClienteID, ISV) VALUES (10,1,0.10)
INSERT Factura(FacturaID, ClienteID, Fecha, SubTotal) VALUES (11,1,'2025/12/05',800)
SELECT * FROM Factura

--Si desea desactivar el valor DEFAULT para una columna donde ya lo asignó debe hacer lo siguiente:
sp_unbinDefault 'Factura.Fecha'
GO
--no importa si ya hay registros insertados. No afecta a la informacion previa, esto solo afectará a los nuevos
--registros que vaya a insertar.

--CHECKS ---------------------------------------------------------------------------
--Permite establecer condiciones para limitar los valores permitidos para un registro determinado
--Por ejemplo: impedir valores negativos en una columna, o impedir valores fuera de determinado rango.
--o solo aceptar ciertos valores de una lista.
USE Dominio
GO
--crearemos una tabla
CREATE TABLE Empleado
(
	EmpleadoID		bigint	NOT NULL,
	Nombre			varchar(100) NOT NULL,
	Genero			varchar(1) NOT NULL,
	EstadoCivil		varchar(1) NOT NULL,
	Edad			smallint NOT NULL,
	CONSTRAINT pkEmpleado PRIMARY KEY(EmpleadoID)
)
GO
/*Para este ejemplo estableceremos los siguientes Checks:
a) Genero solo va a permitir los caracteres:
	M para Masculino
	F para Femenino
	X para Otros
b) EstadoCivil solo va a permitir los caracteres:
	S para Soltero,
	C para Casado,
	D para Divorciado,
	V para Viudo,
	U para Unión Libre
c) Edad no va a permitir numeros negativos
d) El nombre debe tener 5 o más caracteres
*/
--para el Genero:
ALTER TABLE Empleado
ADD CONSTRAINT chkEmpleadoGenero CHECK (Genero = 'M' OR Genero = 'F' OR Genero = 'X')
GO

--para el EstadoCivil:
ALTER TABLE Empleado
ADD CONSTRAINT chkEmpleadoEstadoCivil CHECK (EstadoCivil IN ('S','C','D','V','U'))
GO
--Para la Edad:
ALTER TABLE Empleado
ADD CONSTRAINT chkEmpleadoEdad CHECK (Edad >= 0)
GO

--Para el Nombre:
ALTER TABLE Empleado
ADD CONSTRAINT chkEmpleadoNombre CHECK(LEN(Nombre) >= 5)
GO

--con sp_help puede verificar como están establecidos los Check de la tabla para referencia:
sp_help Empleado
GO

--hagamos las pruebas:
INSERT INTO Empleado VALUES(1,'Gerardo Portillo','M','C',42)
--el insert anterior cumple todos los checks

INSERT INTO Empleado VALUES(2,'Gerardo Portillo','M','Z',42)
--el insert anterior viola el check para el estado civil

INSERT INTO Empleado VALUES(3,'Gerardo Portillo','M','C',-5)
--el insert anterior viola el check para la edad

INSERT INTO Empleado VALUES(4,'Gerardo Portillo','Z','C',42)
--el insert anterior viola el check para el genero

INSERT INTO Empleado VALUES(5,'Kyo','M','C',42)
--el insert anterior viola el check del nombre

INSERT INTO Empleado VALUES(6,'Kyo Kusanagi','M','S',16)
--el insert anterior cumple todos los checks

--tambien el Check actúa sobre los UPDATE:
UPDATE Empleado SET Edad = -999 WHERE EmpleadoID = 1
--lo anterior no se permitirá

--verificar los registros insertados:
SELECT * FROM Empleado
--solo se insertaron los registros que cumplen los checks.

--Se puede tener Check que acepte valores de acuerdo a lo almacenado en varias columnas?
--Por medio del uso de operadores logicos es posible.
--Para este ejemplo crearemos la tabla siguiente:
CREATE TABLE TemperaturasLeidas
(
	LecturaID	bigint	NOT NULL IDENTITY(1,1),
	Escala		varchar(1)	NOT NULL,
	Temperatura	decimal(6,2) NOT NULL,
	CONSTRAINT pkTemperaturasLeidas PRIMARY KEY(LecturaID)
)
GO
/*La tabla tendrá los checks siguientes:
a) Escala solo permite alguno de los siguientes caracteres:
	C para Celsius
	F para Farenheit
	K para Kelvin
b) Temperatura solo aceptará cierto rango de valores de acuerdo a lo establecido en la columna Escala:
	para C solo admitiremos valores entre 0 y 100
	para F solo admitiremos valores entre 32 y 212
	para K solo admitiremos valores entre 273.15 y 373
*/
--para la Escala:
ALTER TABLE TemperaturasLeidas
ADD CONSTRAINT chkTemperaturasLeidasEscala CHECK (Escala IN ('C','F','K'))
GO

--para la Temperatura:
ALTER TABLE TemperaturasLeidas
ADD CONSTRAINT chkTemperaturasLeidasTemperatura CHECK (
	(Escala = 'C' AND Temperatura BETWEEN 0 AND 100) OR
	(Escala = 'F' AND Temperatura BETWEEN 32 AND 212) OR
	(Escala = 'K' AND Temperatura BETWEEN 273.15 AND 373)
)
--observe la logica de AND y OR así como los juegos de parentesis para cada Escala
GO

--pruebas:
INSERT TemperaturasLeidas VALUES('C',37.5)
INSERT TemperaturasLeidas VALUES('C',75)
INSERT TemperaturasLeidas VALUES('F',48.2)
INSERT TemperaturasLeidas VALUES('F',212)
INSERT TemperaturasLeidas VALUES('K',290)
INSERT TemperaturasLeidas VALUES('K',350)
--los registros anterior todos cumplen con los checks

INSERT TemperaturasLeidas VALUES('X',100)
--el insert anterior viola el check para la Escala

INSERT TemperaturasLeidas VALUES('C',500)
--el insert anterior viola el check para la Temperatura (para Celsius no admitiremos que no esten entre 0 y 100

INSERT TemperaturasLeidas VALUES('F',0)
--el insert anterior viola el check para la Temperatura (para Farenheit no admitiremos que no esten entre 32 y 212

INSERT TemperaturasLeidas VALUES('K',15)
--el insert anterior viola el check para la Temperatura (para Kelvin no admitiremos que no esten entre 273.15 y 373

--verificar los registros de la tabla
SELECT * FROM TemperaturasLeidas

--Quitar un Check de una tabla: ----------------------------------------------------
ALTER TABLE TemperaturasLeidas
DROP CONSTRAINT chkTemperaturasLeidasTemperatura
GO

INSERT TemperaturasLeidas VALUES('K',15)
--como quité el check que impedia insertar valores incorrectos para Kelvin, ahora ya me deja insertar el registro

--verificar los registros de la tabla
SELECT * FROM TemperaturasLeidas

--si quiere volver a poner un Check a una tabla y alguno de los registros ya existentes en la tabla viola dicho check
--entonces dicho check no podrá ser creado a menos que arregle los registros que lo violentan.