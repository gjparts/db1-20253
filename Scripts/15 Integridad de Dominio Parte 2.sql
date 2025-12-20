--Integridad de Dominio (parte 2):
USE Dominio
GO

--REGLAS (Rules) -----------------------------------------------------------------------------
--al igual que los Checks permiten limitar los valores permitidos para un registro determinado
--con la diferencia que un Rule se pueden aplicar a diferentes tablas, en cambio un check
--solo se limita a una sola tabla.

--primer vamos a crear unas tablas para nuestras pruebas
CREATE TABLE Historial
(
	EstudianteID	bigint NOT NULL,
	AsignaturaID	varchar(6) NOT NULL,
	Parcial1		tinyint NOT NULL,
	Parcial2		tinyint NOT NULL,
	Parcial3		tinyint NOT NULL
)
GO

CREATE TABLE PromedioGlobal
(
	EstudianteID	bigint NOT NULL,
	Promedio		tinyint NOT NULL
)
GO

CREATE TABLE Asignatura
(
	AsignaturaID	varchar(6) NOT NULL,
	Nombre			varchar(100) NOT NULL
)
GO
/*estableceremos las reglas siguientes:
a) AsignaturaID debe de ser de exactamente 6 caracteres (no menos, no mas) para las tablas Historial y Asignatura
b) Parcial1, Parcial2 y Parcial3 solo admitirán valores entre 0 y 100 para la tabla Historial
c) Promedio solo admitirán valores entre 0 y 100 para la tabla PromedioGlobal
*/
--para AsignaturaID:
CREATE RULE rLongitudSeisCaracteres as ( LEN(@columna) = 6 )
GO
--note que @columna se refiere a que a la columna que le apliquemos esta regla le aplicará la condición o condiciones establecidas

--asignar la regla a las tablas Historial y Asignatura
sp_bindrule 'rLongitudSeisCaracteres','Historial.AsignaturaID'
GO
sp_bindrule 'rLongitudSeisCaracteres','Asignatura.AsignaturaID'
GO
--el GO es importante entre cada sp_bindrule

--Para las calificaciones y promedio:
CREATE RULE rCalificacion as ( @columna >= 0 AND @columna <= 100 )
GO

--asignar la regla a las tablas respectivas:
sp_bindrule 'rCalificacion','Historial.Parcial1'
GO
sp_bindrule 'rCalificacion','Historial.Parcial2'
GO
sp_bindrule 'rCalificacion','Historial.Parcial3'
GO
sp_bindrule 'rCalificacion','PromedioGlobal.Promedio'
GO

--con sp_help puede ver las reglas asignadas a la tablas:
sp_help Historial
GO
sp_help PromedioGlobal
GO
sp_help Asignatura
GO

--hagamos las pruebas:
INSERT Historial VALUES(1,'ISC102',80,81,90)
INSERT Historial VALUES(1,'ISC204',75,65,80)
INSERT Historial VALUES(1,'ISC103',90,99,100)
INSERT Historial VALUES(2,'ISC102',0,0,0)

INSERT PromedioGlobal VALUES(8,100)
INSERT PromedioGlobal VALUES(5,80)
INSERT PromedioGlobal VALUES(70,75)

INSERT Asignatura VALUES('ISC102','PROGRAMACIÓN ESTRUCTURADA')
INSERT Asignatura VALUES('ISC103','PROGRAMACIÓN ORIENTADA A OBJETOS')
INSERT Asignatura VALUES('ISC204','PARADIGMAS DE PROGRAMACIÓN')

--los registros anterior cumplen las reglas establecidas

--ahora vamos a ver que pasa si se violentan reglas:
INSERT Historial VALUES(5,'ISC102',65,200,90)
--Parcial2 viola la regla rCalificacion

UPDATE Historial SET Parcial1 = 110 WHERE EstudianteID = 1 AND AsignaturaID = 'ISC102'
--Parcial1 viola la regla rCalificacion

INSERT PromedioGlobal VALUES(7,120)
--Promedio viola la regla rCalificacion

INSERT Asignatura VALUES('ISC99','Teoría de Todo')
--AsignaturaID viola la regla rLongitudSeisCaracteres

INSERT Historial VALUES(1,'ABC',100,100,100)
--AsignaturaID viola la regla rLongitudSeisCaracteres
GO

--QUITAR UNA REGLA DE UNA COLUMNA DE UNA TABLA: --------------------------
sp_unbindrule 'Asignatura.AsignaturaID'
GO

--TIPOS DE DATOS PREDEFINIDOS POR EL USUARIO -----------------------------------------------------
--podemos crear variantes de los tipos de datos ya existentes (bigint, int, date, decimal, etc)
--pero que tengan incluida cierta configuracion, cierto check o cierto valor predeterminado.
--a estos tambien se les conoce como tipos de datos personalizados.

--por ejemplo vamos a crear un tipo de datos personalizado que sea DECIMAL(12,2), que no permita numeros negativos
--y que su valor predeterminado sea 1.00, nombra a este nuevo tipo como Dinero
--primer se crean el valor predeterminado
CREATE DEFAULT dfZero as 0.00
GO
--luego se crean las rules
CREATE RULE rPositivo as ( @columna >= 0 )
GO
--luego creamos el tipo de datos personalizado
sp_addType 'Dinero', 'decimal(12,2)'
GO
--por ultimo se asingan el valor predeterminado y las reglas a este nuevo tipo de dato personalizado
sp_bindefault 'dfZero', 'Dinero'
GO
sp_bindrule 'rPositivo', 'Dinero'
GO

--Este nuevo tipo de dato personalizado lo puedo usar a la hora de hacer tablas:
CREATE TABLE Facturacion
(
	FacturaID bigint NOT NULL,
	ClienteID bigint NOT NULL,
	SubTotal Dinero NOT NULL,
	ISV Dinero NOT NULL,
	Descuento Dinero NOT NULL
)
GO
--Note que las columnas SubTotal, ISV y Descuento su tipo de dato es Dinero (nuestro tipo de dato personalizado)

--Pruebas:
INSERT Facturacion(FacturaID, ClienteID) VALUES(1,1)
--note que el valor DEFAULT para las columnas de tipo dinero es 0.00
SELECT * FROM Facturacion

INSERT Facturacion VALUES(2,1,100,15,-90)
--Descuento esta violando la regla rPositivo la cual le aplicamos al tipo de dato Dinero.

--Si desea eliminar un tipo de dato personalizado: -------------------
sp_dropType 'Dinero'
GO
--si ya lo uso en la creacion de tablas no se le permitirá eliminarlo.