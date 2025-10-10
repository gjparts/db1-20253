--Comentario de una linea

/*Comentario de
varias
lineas*/

/*DML: Data Manipulation Language
Lenguage de Manipulacion de datos
Instrucciones que permiten interactuar con informacion
de los objetos de datos (Tablas, Vistas, Funciones)
Las mas usadas son: SELECT INSERT DELETE UPDATE*/

--Lo primer que se hace siempre antes de comenzar a trabajar en una base
--de datos es USARLA o seleccionarla.
USE BaleadasGPT
GO
--USE: permite posicionarse en una BASE DE DATOS dentro del servidor
--USE cambia el contexto de base de datos para el lote en ejecucion.

--GO: Es un separador de lotes, o sea de varias instrucciones.
--GO se utiliza para esperar a que se ejecuten las instrucciones previas a el
--antes de continuar con el script.

/*Si luego de USE no pusieran GO, y luego escriben otra sentencia; entonces
SQL Server la ejecuraria en el contexto anterior o sea antes de que se haga
el cambio de base de datos.

En resumen: colocamos GO despues de USE para asegurarnos de que el cambio
del bas de datos surta efecto antes de ejecutar otras instrucciones y asi
evitamos malos entendidos a futuro.*/

--procedimiento almacenado que permite saber que tablas tiene la base de datos actual
USE tempdb
GO

sp_tables

/*Que son las bases de datos master, model, msdb, tempdb?
master: es la base que contiene los programas para gestionar el motor de BD,
        asi como tablas para controlar ciertos aspectos del servidor.
		Aqui se guarda la definicion de las tablas y sus columnas (diccionario de datos)
model:	es la base de datos modelo o plantilla usada para crear mas bases de datos
msdb:	es la base de datos usada para el control de trabajos (jobs), tareas de
		mantenimiento, backups, auditoria y otras funciones de control.
		Significa Microsoft Data Base
tempdb:	se usa para crear/eliminar tablas temporales usadas en las diferentes
		consultas al servidor*/

/*INSTRUCCION SELECT ----------------------------------------------------------
Consulra el contenido de una tabla, el resultado va depender de los modificadores
que le coloquemos.*/

--Consultar o seleccionar todos los registros para todas las columnas de la tabla Cliente
USE BaleadasGPT
GO

SELECT * FROM Cliente
--lo anterior corresponde a la operacion SELECCION que aprendimos en Algebra Relacional

--Consulta todos los registros para todas las columnas de la tabla Producto
SELECT * FROM Producto
--Importante: en SQL Server no importa la capitalizacion
--puede usar mayusculas/minusculas al gusto
select * from producto
SelECT * FroM ProductO
--Cuidado: en algunas versiones de MySQL, Oracle o PostgreeSQL si exige el correcto
--uso de la capitalizacion.

--Consultar la tabla Usuario
SELECT * FROM Usuario

--Consultar tablas de otras bases de datos sin necesidad de hacer USE
SELECT * FROM pubs.dbo.authors
SELECT * FROM Northwind.dbo.Employees
SELECT * FROM BaleadasGPT.dbo.MateriaPrima
--dbo significa DataBase Owner o propietario de la base de datos
--no todas las bases de datos tienen dbo para seleccionar sus tablas, por ejemplo AdventureWorks:
SELECT * FROM AdventureWorks.HumanResources.Employee
SELECT * FROM AdventureWorks.Production.Illustration
SELECT * FROM AdventureWorks.Sales.Customer
--HumanResources, Production y Sales son roles que agrupan tablas (no es tan comun ver esto)

