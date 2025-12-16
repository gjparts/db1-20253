--Para explicar este tema crearemos una nueva base de datos:
CREATE DATABASE Taller
GO
/*Integridad Referencial:
Es conocido como el segundo tipo de integridad declarativa y consiste en la creación de
llaves foráneas.
Una llave foránea es aquella que relaciona dos tablas por medio de uno o varios campos
con la finalidad de evitar registros huerfanos. Por ejemplo: Evitar realizar facturas a clientes
que no existen.
-> No podemos crear una llave foranea que relacione tres tablas.

Ejemplo práctico:
Crearemos dos tablas en la BD Taller, una para el catalogo de Clientes y otra para
las facturas con sus respectivas llaves primarias.
*/
USE Taller
GO

CREATE TABLE Cliente
(
	ClienteID bigint NOT NULL,
	Nombre varchar(150) NOT NULL,
	CONSTRAINT pkCliente PRIMARY KEY(ClienteID)
)
GO

CREATE TABLE Factura
(
	FacturaID bigint NOT NULL,
	ClienteID bigint NOT NULL,
	Valor decimal(12,2) NOT NULL,
	CONSTRAINT pkFactura PRIMARY KEY(FacturaID)
)
GO

/*vamos a impedir que se pueda hacer registros en Factura si no existe el ClienteID
respectivo en la tabla Cliente.
Para que exista una relación entre dos tablas se establece dos personajes:
a) La tabla Maestro o tabla Padre que es donde está el registro del cual depende la segunda tabla.
b) La tabla Dependiente o tabla Hija que es donde están los registros que hacen referencia al registro de la tabla Maestro.
-> La llave Foránea crea dicha relación.

Una llave foránea se crea en la tabla Hija haciendo referencia hacia la tabla Padre.
Para crear una llave foranea existe tres requisitos:
1) La tabla Padre debe tener una llave primaria
2) La llave foranea de la tabla Hija debe ser equivalente con la llave primaria de la tabla Padre
3) en la tabla Hija no debe de existir registros que violenten la llave foranea.
4) Debe existir equivalencia de tipos entre los campos a relacionar entre las tablas.
*/
--Creacion de la llave foreanea entre Factura y Cliente:
ALTER TABLE Factura
ADD CONSTRAINT fkFacturaCliente FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
GO
/*Observe que el campo en comun entre ambas tablas será ClienteID, o sea que si usamos un
numero de cliente que no existe entonces no nos dejará crear facturas.
No el nombrado de la llave, puse fkFacturaCliente como nombre para indicar que esa llave foranea
relaciona esas dos tablas; pero Usted puede nombrar estas llaves como Usted guste.
-> Note que en FOREIGN KEY va la columna de la tabla Hija y REFERENCES lleva la columna en la tabla Padre*/

--pruebas:
--insertar algunos clientes
INSERT Cliente VALUES(1,'Gerardo')
INSERT Cliente VALUES(2,'Master Chief')
INSERT Cliente VALUES(3,'Doom Guy')
INSERT Cliente VALUES(4,'Frog')
INSERT Cliente VALUES(5,'El Barto')

--insertar algunas facturas validas:
INSERT Factura VALUES(1,4,2500.00) --factura 1 al cliente 4: Frog
INSERT Factura VALUES(2,1,900.00) --factura 2 al cliente 1: Gerardo
INSERT Factura VALUES(3,1,4000.00) --factura 3 al cliente 1: Gerardo
INSERT Factura VALUES(4,2,9000.00) --factura 4 al cliente 2: Master Chief
INSERT Factura VALUES(5,3,1.00) --factura 5 al cliente 3: Doom Guy
--observe que las facturas pudieron crearse porque hacen referencia a registros cuyo ClienteID que si existe
--en la tabla Padre; porque se cumple la integridad referencial.

--que pasa si agregamos facturas a clientes que no existen en la tabla Padre?
INSERT Factura VALUES(6,90,8000.00) --factura 6 al cliente 90 (no existe)
--lo anterior dará un error que se está violentando la restriccion FOREIGN KEY: fkFacturaCliente
--la cual es la llave foranea que creamos anteriormente.
--por lo tanto dicho registro a Factura no podrá insertarse:
SELECT * FROM Factura
--note que no se insertó la factura 6.

--que pasa si intento eliminar un registro de la tabla Cliente cuyo ClienteID
--fue utilizado en registros de la tabla Factura?
--por ejemplo voy a eliminar al registro con ClienteID igual a 1 que es Gerardo:
DELETE FROM Cliente WHERE ClienteID = 1
--lo anterior también dará un error que se está violentando la restriccion FOREIGN KEY: fkFacturaCliente
--porque no se puede eliminar registros de la tabla Padre que estan referenciados en la tabla Hija.

--pero si puedo eliminar de la tabla Cliente cualquier registro que no tenga registros
--referenciados en la tabla Factura, por ejemplo el registro cuyo ClienteID sea 5 (El Barto)
DELETE FROM Cliente WHERE ClienteID = 5

--en resumen: la llave foranea aparte de evitar insertar registros huerfanos también impide eliminar
--aquellos registros que ya fueron referenciados entre ambas tablas de la relación.

--Tampoco se puede modificar un registro en la tabla padre si tiene hijos que dependen de él:
--por ejemplo le voy a cambiar el ClienteID a Frog:
UPDATE Cliente SET ClienteID = 8 WHERE ClienteID = 4
--no lo permitirá porque crearia inconsistencia entre Cliente y Factura.

--Las llaves foraneas se utilizan para mantener la integridad de los datos.

--COMO PUEDO ELIMINAR UN REGISTRO DE TABLA PADRE SI TIENE HIJOS? ------------------------------------
--Por ejemplo quiero eliminar a Gerardo de la tabla Cliente.

--Para lograrlo primero deberá eliminar los registros hijos de dicho cliente:
DELETE FROM Factura WHERE ClienteID = 1
--y luego eliminar el registro Padre:
DELETE FROM Cliente WHERE ClienteID = 1
--comprobar en ambas tablas:
SELECT * FROM Cliente
SELECT * FROM Factura
--es importante que Usted debe de estar seguro de lo que está haciendo.

/*CREAR UNA LLAVE FORANEA QUE PERMITA LA ELIMINACION/ACTUALIZACION EN CASCADA ------------------------
SQL ofrece la posibilidad de crear llaves foraneas que funcionen en algo conocido como CASCADA,
esta funcionalidad lo hace es que al eliminar o actualizar un registro en la tabla Padre dicho
cambio se replique en la tabla Hija sin necesidad de nosotros hacerlos manualmente.
-> en mi caso no recomiendo habilitar la casada; pero quizá Ustedes encuentren alguna situación
   donde les sirva.
-> La cascada mal utilizada pone en peligro la protección de los registros hijos.
*/
--ejemplo. En la BD Taller crearemos dos tablas una para compras y otra para Proveedores y haremos
--la relación entre ambas con una llave foránea a través del campo ProveedorID
USE Taller
GO
CREATE TABLE Proveedor
(
	ProveedorID bigint NOT NULL,
	Nombre varchar(100) NOT NULL,
	CONSTRAINT pkProveedor PRIMARY KEY(ProveedorID)
)
GO

CREATE TABLE Compra
(
	CompraID bigint NOT NULL,
	ProveedorID bigint NOT NULL,
	Total decimal(12,2) NOT NULL,
	CONSTRAINT pkCompra PRIMARY KEY(CompraID)
)
GO
--creacion de llave foranea:
ALTER TABLE Compra
ADD CONSTRAINT fkCompraProveedor FOREIGN KEY (ProveedorID) REFERENCES Proveedor(ProveedorID)
ON DELETE CASCADE --si coloca esto hará cascada al eliminar
ON UPDATE CASCADE --si coloca esto hará cascada al hacer update
GO

--insertar algunos proveedores
INSERT Proveedor VALUES(1,'Cerveceria Hondureña')
INSERT Proveedor VALUES(2,'PACASA')
INSERT Proveedor VALUES(3,'PRONORSA')
INSERT Proveedor VALUES(4,'Agua Azul')

--crear algunas compras que referencien a los proveedores
INSERT Compra VALUES(1,4,5000.00) --compra 1 a Agua Azul 
INSERT Compra VALUES(2,4,15000.00) --compra 2 a Agua Azul
INSERT Compra VALUES(3,2,2000.00) --compra 3 a PACASA
INSERT Compra VALUES(4,1,7000.00) --compra 4 a Cerveceria Hondureña
INSERT Compra VALUES(5,1,9000.00) --compra 5 a Cerveceria Hondureña
INSERT Compra VALUES(6,3,32000.00) --compra 6 a PRONORSA
INSERT Compra VALUES(7,4,7000.00) --compra 7 a Agua Azul

--verificar tablas:
SELECT * FROM Proveedor
SELECT * FROm Compra
--note que Agua Azul (ProveedorID = 4) tiene tres compras

--ahora voy a eliminar al proveedor 4: Agua Azul de la tabla Padre
DELETE FROM Proveedor WHERE ProveedorID = 4
--Observe que no dio Error de Llave Foranea, porque tenemos activado CASCADE para DELETE:
--Pero si revisa ambas tablas de la relación eliminó los registros de la tabla Hija y
--de la tabla Padre. Por eso la cascada es algo peligroso si no se sabe usar.
SELECT * FROM Proveedor
SELECT * FROm Compra

--ahora vamos a cambiarle el ProveedorID a Cerveceria Hondureña, lo pasaremos de 1 a 999:
UPDATE Proveedor SET ProveedorID = 999 WHERE ProveedorID = 1
--vea que tampoco dio error de llave foranea porque habilitamos CASCADE para UPDATE
--por lo tanto al cambiar el ID en la tabla Padre tambien se cambio en la tabla Hija:
SELECT * FROM Proveedor
SELECT * FROm Compra
--ahora las compras al ProveedorID = 1 se cambiarion a 999

--IMPORTANTE: en lo personal no recomiendo usar CASCADE.

--ELIMINAR UNA LLAVE FORANEA de una tabla Hija ------------------------------------------------------
ALTER TABLE Compra
DROP CONSTRAINT fkCompraProveedor
GO

--ELIMINAR UNA TABLA QUE ESTA DENTRO DE UNA RELACION FOREIGN KEY -------------------------------------
--si desea eliminar una tabla que tiene una llave foranea no los dejará:
DROP Table Cliente
GO
--dará error de restriccion FOREIGN KEY.
--Para poder eliminar la tabla cliente deberá quitar dicha llave ya que una
--llave foranea protege a la tabla Padre de ser eliminada.
--deberá eliminar cualquier llave foranea que haga referencia a ella si desea quitarla
--OJO: esto ya en producción no es recomendado; pero en caso de necesitarlo estos son los pasos:
--1) quitar la llave foranea de la tabla Hija:
ALTER TABLE Factura
DROP CONSTRAINT fkFacturaCliente
GO
--2) eliminar la tabla Padre:
DROP TABLE Cliente
GO

