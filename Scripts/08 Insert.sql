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

SELECT * FROM Bodega
sp_help Bodega




