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
USE BaleadasGPT
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

/*IMPORTANTE: El uso de * en SELECT es considerado una mala práctica cuando ya
se tiene pensando liberar un software a produccion/distribucion. El de * en SELECT
crea la necesidad por parte del DBMS de ir a consultar que columnas tiene esa tabla
lo que representa un trabajo adicional que puede consumir recursos de forma innecesaria
cuya repercusion se siente en escenarios a gran escala.
Lo correcto en un SELECT es proyectar que columnas va a consultar:*/
SELECT ProductoID, Codigo, Descripcion, PrecioVenta, CostoPromedio FROM Producto
SELECT Nombre, Pais, Departamento, Municipio, Comentarios FROM Cliente
--lo anterior correspone a la operacion de PROYECCION que aprendimos en algebra relacional

--en SQL no es necesario hacer toda la sentencia en una sola linea, puede hacerlas tambien
--en varios renglones:
SELECT	ProductoID, Codigo, Descripcion,
		PrecioVenta, CostoPromedio
FROM Producto

--seleccionar todas la filas de la tabla Producto pero solo proyecte las columnas
--Descripcion, Codigo y Comentarios
SELECT Descripcion, Codigo, Comentarios FROM Producto
--seleccionar todas las filas de la tabla Producto, proyecte unicamente Descripcion,
--PrecioVenta y CostoPromedio
SELECT Descripcion, PrecioVenta, CostoPromedio FROM Producto
--seleccionar todas las filas de la tabla Cliente, proyecte solo el nombre de cada cliente
--y la fecha de nacimiento de cada uno
SELECT Nombre, Nacimiento FROM Cliente

--uso del PUNTO Y COMA -----------------------------------------
--tambien es posible separar cada sentencia con ;
--pero en SQL SERVER no es obligatorio, en cambio en algunos clientes
--de MySQL si obliga a usarlo.
--en SQL SERVER es muy util para poner dos sentencias en un mismo renglon:
SELECT * FROM MateriaPrima; SELECT * FROM Cliente; SELECT * FROM Usuario;

--Utilizacion de Alias de columna ---------------------------------
SELECT	ProductoID as Numero, Codigo, Descripcion as [Nombre del Producto],
		PrecioVenta as [Precio de Venta], Comentarios as Observaciones
FROM Producto
--colocar alias forma parte de RENOMBRAMIENTO en algebra relacional
--si desea colocar mas de una palabra use corchetes
--esto no afecta a la base de datos, solo se aplica a la proyeccion.

--Trabajar con valores NULL (nulos)
SELECT Nombre, Pais, Telefono1
FROM Cliente
--no como Telefono1 tiene algunos valores sin llenar (NULL)

--reemplazar NULL por algun valor generico a la hora de la consulta
--si la columna es de texto entonces debera reemplazarse por un valor de texto:
SELECT Nombre, Pais, ISNULL(Telefono1,'No tiene') as Telefono1
FROM Cliente
--los valores de texto en SQL SERVER van dentro de comillas simples: 'texto'
--IMPORTANTE: en valor de reemplazo en ISNULL debe tener el mismo tamaño maximo
--en caracteres que la columna original

--si es columna numerica; entonces debe reemplazarse por un valor numerico
SELECT title, type, price, ytd_sales
FROM pubs.dbo.titles
--note que price y ytd_sales tienen valores nulos

SELECT	title as Libro, type as Tipo,
		ISNULL(price,0.00) as Precio,
		ISNULL(ytd_sales,0.00) as [Ventas anuales]
FROM pubs.dbo.titles
--IMPORTANTE: en valor de reemplazo en ISNULL debe tener la misma
--precision numerica que la columna original

--Si es columna de fecha, el valor de reemplazo debe de ser una fecha
SELECT Nombre, Pais, ISNULL(Nacimiento,'1900-1-1') as Nacimiento
FROM Cliente

--aplicar ISNULL para generar nueva informacion en una columna es considerado un campo calculado

--CAMPOS CALCULADOS -------------------------------------------------------------------
--Son columnas que se generan a partir de la aplicacion de funciones o de operaciones matematicas
--que generan nueva informacion, la cual no queda almacena en la base de datos, ya que es informacion
--temporal generada unicamente durante la consulta o sea son valores proyectados.
SELECT	Codigo, Descripcion, CostoPromedio, PrecioVenta,
		PrecioVenta-CostoPromedio as Utilidad,
		PrecioVenta*0.15 as [I.S.V.],
		(PrecioVenta-CostoPromedio)/ProductoID as [Calculo raro], --no es necesario que la columna sea visible para usarla
		POWER(CostoPromedio,2) as [Costo al cuadrado],
		SQRT(PrecioVenta) as [Raiz Cuadrada de Venta],
		CostoPromedio-PrecioVenta as [Costo-Venta],
		ABS(CostoPromedio-PrecioVenta) as [Valor Absoluto de Costo-Venta],
		SIN(CostoPromedio) as [Seno del Costo],
		COS(CostoPromedio) as [Coseno del Costo],
		TAN(CostoPromedio) as [Tangente del Costo],
		PI() as [Valor de PI],
		PI()*POWER(ProductoID,2) as [Area de un Circulo basado en ProductoID],
		2 as NumeroDos
FROM Producto
--IMPORTANTE: se recomienda siempre colocar ALIAS a los campos calculados para evitar confusiones

--Tambien puede combinar el uso de * junto con campos calculados
SELECT	*, Cantidad*PrecioVenta as SubTotal,
		Cantidad*PrecioVenta*ISVTasa as ISV,
		Cantidad*PrecioVenta*(1+ISVTasa) as Total
FROM FacturaDet