--FUNCIONES PARA CADENA DE TEXTO
Use BaleadasGPT
GO

--Funcion LEN: permite saber cuantos caracteres tiene cada valor
--en una columna
SELECT	ClienteID, Nombre,
		LEN(Nombre) as [Longitud de Nombre],
		LEN(ClienteID) as [Longitud de ClienteID] --SQL SERVER permite usar LEN en campos numericos
FROM Cliente

--Funciones UPPER y LOWER, conviertem a mayusculas y minusculas cada valor de la columna
SELECT	Nombre, Pais,
		UPPER(Nombre) as Nombre, UPPER(Pais) as Pais,
		LOWER(Nombre) as Nombre, LOWER(Pais) as Pais
FROM Proveedor

--Concatenar texto a columna varchar (SOLO EN SQL SERVER) -------------------------------
-- '   ALT + 39
--SQL Server se concatena con signo +
SELECT	'oO0 '+Nombre+' 0Oo' as Nombre,
		'----------'+UPPER(Nombre)+'----------' as Titulo,
		'"'+Nombre+'"' as [Nombre en comillas],
		''''+Nombre+'''' as [Nombre en comilla simple],
		Nombre+Pais as [Dos campos], --solo se puede concatenar campos de texto
		Nombre+' - '+Pais as [Dos campos y string],
		CAST(ProveedorID as varchar)+' '+Nombre as [Codigo mas Nombre]
FROM Proveedor

--Observe que para concatenar campos numericos o de fecha es necesario
--hacer la conversion a VARCHAR del campo respectivo:
SELECT CAST(ClienteID as varchar)+' '+Nombre+' '+CAST(ISNULL(Nacimiento,'1900/1/1') as varchar)
FROM Cliente
--En el caso de Nacimiento algunos clientes lo tienen NULL si es asi se reemplaza por 1900/1/1

--Concatenar texto en MySQL y en SQL Server
SELECT	CONCAT('oO0 ',Nombre,' 0Oo') as Nombre,
		CONCAT('----------',UPPER(Nombre),'----------') as Titulo,
		CONCAT('"',Nombre,'"') as [Nombre en comillas],
		CONCAT('''',Nombre,'''') as [Nombre en comilla simple],
		CONCAT(Nombre,Pais) as [Dos campos],
		CONCAT(Nombre,' - ',Pais) as [Dos campos y string],
		CONCAT(ProveedorID,' ',Nombre) as [Codigo mas Nombre] --CONCAT no le obliga a convertir numeros a texto
FROM Proveedor

--CONCAT a diferencia de usar + es mas practico porque no exige convertir numeros o fechas
--a texto y si encuentra un valor NULL lo ignora sin afedctar al resto de la cadena de texto
SELECT CONCAT(ClienteID,' ',Nombre,' ',Nacimiento)
FROM Cliente

--Vea este otro ejemplo:
SELECT	Nombre, Direccion,
		Pais+', '+Departamento+', '+Municipio+', '+Direccion as [Direccion usando +],
		CONCAT(Pais,', ',Departamento,', ',Municipio,', ',Direccion) as [Direccion usando CONCAT],
		CONCAT('Llamar al Telefono: ',Telefono1) as Telefono,
		CONCAT('Llamar al Telefono: ',ISNULL(Telefono1,'No tiene')) as [Telefono detallado]
FROM Cliente
--CONCAT no obliga a usar ISNULL; pero en algunos casos por cuestiones esteticas se deberia usar.

--Funcion TRIM: elimina los espacios de relleno al inicio y al final del valor ----------------------------
SELECT	Nombre,
		TRIM(Nombre) as [Nombre con TRIM]
FROM Cliente

--Funcion LEFT: devuelve N cantidad de caracteres a partir de la posicion 0 ----------------------
SELECT LEFT(Descripcion,10)
FROM Producto

--Funcion RIGHT: devuelve N cantidad de caracteres a partir de la ultima posicion ----------------------
SELECT RIGHT(Descripcion,6)
FROM Producto

--Funcion SUBSTRING: permite extraer cierta parte de una cadena de texto ---------------------------------
--de debe proporcionar una posicion de inicio y de fin, en caso de no existir las posiciones
--devuelve un texto en blanco.
SELECT Descripcion, SUBSTRING(Descripcion,5,10)
FROM Producto

--Funcion REPLACE: reemplaza un texto dentro de otro -------------------------------------------
--OJO: esto no afecta a la base de datos ya que es una proyeccion
SELECT	Descripcion,
		REPLACE(Descripcion,'Pollo','Chicken'),
		REPLACE(Descripcion,' ','_'),
		REPLACE(REPLACE(REPLACE(REPLACE(Descripcion,'A','4'),'e','3'),'i','1'),'o','0'),
		REPLACE(Descripcion,' ',''), --si el segundo param. es vacio se remueve lo encontrado
		REPLACE(Descripcion,'FULL','') --eliminar FULL dentro de descripcion
FROM Producto
--Observe que es posible encadenar varios REPLACE

--Otro ejemplo:
SELECT Nombre, Pais, Departamento, Municipio, REPLACE(Telefono1,'-','') as Telefono1
FROM Cliente
--Eliminacion de guiones en los numeros de telefono

--Funcion CHARINDEX: devuelve la posicion en la que se encontro determinado texto por primera vez --------------
--Si no encuentra nada devuelve CERO
--esta funcion maneja las posiciones desde 1 hasta N
SELECT	Descripcion,
		CHARINDEX('Carne',Descripcion) as Carne,
		CHARINDEX('Pollo',Descripcion) as Pollo,
		CHARINDEX('a',Descripcion) as [Letra a]
FROM Producto

