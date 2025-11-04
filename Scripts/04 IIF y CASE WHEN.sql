/*Funciones de seleccion
Permiten determinar el valor de una columna por medio del cumplimiento de condiciones.
Las mas usadas son:
-> IIF			funciona como el operador ternario
-> CASE WHEN	funciona como la escructura switch de C++ permitiendo elegir entre varios casos

-> en IIF y CASE WHEN todos los valores de salida deben de ser del mismo tipo de dato.

-> IIF existe en SQL SERVER desde la version 2012, antes de esa version utilice CASE WHEN
-> IIF en otros DBMS se llama simplemente IF (MySQL)*/
USE BaleadasGPT
GO

/*Mostrar el codigo, descripcion, precio de venta de todos los productos.
-> Proyectar una columna llamada "Tasa ISV" donde si pagaISV es 1 entonces que muestre 0.15 de lo contrario que muestre 0.00
-> Mostrar otra columna llamada "Tasa ISV Lujo" donde si pagaISVLujo es 1 entonces que muestre 0.18 de lo contrario que muestre 0.00
-> Mostrar una columna mas, que indique si el producto paga algun tipo de impuesto en caso de que pasaISV ó PagaISVLujo sean 1
   mostrar la palabra Si de lo contrario mostrar No.*/

--Forma 1: usando IIF (solo SQL SERVER desde 2012)
SELECT	Codigo, Descripcion, PrecioVenta,
		IIF(PagaISV = 1,0.15,0.00) as [Tasa ISV],
		IIF(PagaISVLujo = 1,0.18,0.00) as [Tasa ISV Lujo],
		IIF(PagaISV = 1 OR PagaISVLujo = 1,'Si','No') as [Paga Algun Impuesto]
FROM Producto

--Forma 2: usando CASE WHEN (mas universal)
SELECT	Codigo, Descripcion, PrecioVenta,
		CASE WHEN PagaISV = 1 THEN 0.15 ELSE 0.00 END as [Tasa ISV],
		CASE WHEN PagaISVLujo = 1 THEN 0.18 ELSE 0.00 END as [Tasa ISV Lujo],
		CASE WHEN PagaISV = 1 OR PagaISVLujo = 1 THEN 'Si' ELSE 'No' END as [Paga Algun Impuesto]
FROM Producto

/*Los dos ejemplos anteriores estan diseñados para funcionar como si fueran el operador ternario.
donde hay un valor se devuelve en caso de cumplir los criterios y otro en caso de no cumplirse.*/

/*Otro ejemplo:
Mostrar el ClienteID, nombre y año de nacimiento de todos los clientes.
-> Muestre una columna que indique si el cliente es Nacional o Extranjero
   dependiendo de si Pais es Honduras o no.
-> Mostrar si el cliente nacio o no en año biciesto
-> Excluir de la consulta el cliente con ID igual a 1
-> Muestre el nombre sin espacios de relleno
-> ordenar la informacion por nombre sin espacios de relleno*/
SELECT	ClienteID, TRIM(Nombre) as Nombre, Nacimiento,
		CASE WHEN Pais = 'Honduras' THEN 'Nacional' ELSE 'Extranjero' END as [Origen],
		IIF(Pais = 'Honduras','Nacional','Extranjero') as [Origen usando IIF],
		CASE WHEN Year(Nacimiento)%4 = 0 THEN 'Si' ELSE 'No' END as [Nace en año biciesto],
		IIF(Year(Nacimiento)%4 = 0,'Si','No') as [Nace en año biciesto usando IIF]
FROM Cliente
WHERE ClienteID <> 1
ORDER BY 2 ASC

/*otro ejemplo:
Muestra el ID, Total y la utilidad obtenida por cada factura para todas las facturas
realizadas en el mes de Octubre de 2010 cuyo Estado sea NOR y cuyo tipo sea Contado.
-> Muestre una columna llamada Utilidad/Perdida que muestre Ganancia o Perdida
   dependiendo de si la Utilidad es positiva o negativa.
-> Mostrar una columna que muestre Dia si el turno es A de lo contrario que muestre Tarde/Noche
-> Mostrar una columna llamada "Pago con Tarjeta" que muestre Si cuando Pago es TCredito o TDebito
   de lo contrario que muestre No.
-> Mostrar una columna que diga si FacturaID es par o impar*/
SELECT	FacturaID, Total, Total-CostoPromedioTotal as Utilidad,
		CASE WHEN Total-CostoPromedioTotal >= 0 THEN 'Ganancia' ELSE 'Perdida' END as [Utilidad/Perdida],
		CASE WHEN Turno = 'A' THEN 'Dia' ELSE 'Tarde/Noche' END as Jornada,
		CASE WHEN Pago = 'TCredito' OR Pago = 'TDebito' THEN 'Si' ELSE 'No' END as [Pago con Tarjeta],
		CASE WHEN FacturaID%2 = 0 THEN 'Par' ELSE 'Impar' END as [FacturaID Par/Impar]
FROM FacturaCab
WHERE Estado = 'NOR' AND Tipo = 'Contado' AND MONTH(Fecha) = 10 AND YEAR(Fecha) = 2010

-- USO DE CASE WHEN PARA SELECCION DE MULTIPLES CASOS ------------------------------
/*Case WHEN se puede formular de manera que responda de diversas formas de acuerdo a un valor de entrada
que puede ser texto, nuero, calculo, etc.
Ejemplo:
Para la tabla Person de la base de datos AdventureWorks dentro del Rol Person
realice la consulta siguiente:

Mostrar el FirstName y el LastName, tambien muestre una columna llama Type
la cual dependiendo del valor de PersonType mostrar un texto de acuerdo a la escala siguiente:
EM	Empleado
SP	Vendedor
SC	Contacto de Tienda
VC	Proveedor
IN	Cliente
cualquier otro valor que muestre el texto: Otros
Ordene los datos de acuerdo a esta ultima columna.
*/

SELECT	FirstName, LastName,
		CASE PersonType
			WHEN 'EM' THEN 'Empleado'
			WHEN 'SP' THEN 'Vendedor'
			WHEN 'SC' THEN 'Contacto de Tienda'
			WHEN 'VC' THEN 'Proveedor'
			WHEN 'IN' THEN 'Cliente'
			ELSE 'Otros'
		END as Type
FROM AdventureWorks.Person.Person
ORDER BY 3

