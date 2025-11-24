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