/*Integridad Referencial: Crear una referencia circular o recursiva.
Este tipo de referencia es donde una tabla se hace referencia a sí misma.

Para ponerlos en contexto, en la BD Taller vamos a crear una tabla
llamada Empleado, en dicha tabla cada empleado a va tener un jefe asignado
por medio de la columna JefeID; pero este JefeID debe coincidir con un EmpleadoID existente.
No todos los empleados tienen Jefe por lo tanto JefeID aceptará NULL.*/
USE Taller
GO

CREATE TABLE Empleado
(
	EmpleadoID bigint NOT NULL,
	Nombre varchar(150) NOT NULL,
	Puesto varchar(50) NOT NULL,
	Salario decimal(12,2) NOT NULL,
	JefeID bigint NULL,
	CONSTRAINT pkEmpleado PRIMARY KEY(EmpleadoID)
)
GO

--crear la llave foranea:
ALTER TABLE Empleado
ADD CONSTRAINT fkEmpleadoJefe FOREIGN KEY(JefeID) REFERENCES Empleado(EmpleadoID)
GO
--Observe que en FOREIGN KEY va la columna de la tabla Hija y REFERENCES lleva la columna en la tabla Padre

--ahora vamos a crear registros de prueba:
INSERT Empleado VALUES(1,'Don Cangrejo','Gerente General',100000.00,NULL) --Empleado 1 no tiene Jefe
INSERT Empleado VALUES(2,'Calamardo','Supervisor',2000.00,1) --Empleado 2 tiene como Jefe al empleado 1
INSERT Empleado VALUES(3,'Bob Esponja','Cocinero',500.00,2) --Empleado 3 tiene como Jefe al empleado 2
INSERT Empleado VALUES(4,'Gerardo','Conserje',1000.00,1) --Empleado 4 tiene como Jefe al empleado 1
INSERT Empleado VALUES(5,'Manolo','Aseador',1000.00,1) --Empleado 5 tiene como Jefe al empleado 1

--veamos los registros:
SELECT * FROM Empleado

--que pasa si agrego un registro y le pongo como jefe un EmpleadoID que no existe:
INSERT Empleado VALUES(6,'Patricio Estrella','Ayudante',5.00,8) --Empleado 6 tiene como Jefe al empleado 8 (no existe)
--lo anterior va a violentar la llave foranea fkEmpleadoJefe porque no existe el EmpleadoID = 8

--que pasa si elimino Don Cangrejo? él es jefe de Calamardo, Gerardo y Manolo?
DELETE FROM Empleado WHERE EmpleadoID = 1
--lo anterior va a violentar la llave foranea fkEmpleadoJefe porque es el JefeID de los empleados 2, 4 y 5