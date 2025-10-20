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
CONCAT