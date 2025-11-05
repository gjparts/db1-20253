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

/*En la base de datos pubs para la tabla titles se dará un descuento de acuerdo al type
de cada uno de los libros, la escala a utilizar sera la siguiente:
	business		10%
	mod_cook		15%
	popular_comp	10%
	psychology		25%
	trad_cook		15%
	otros			5%
Mostrar el title_id, title, type, notes asi como el descuento otorgado para cada libro.
*/
SELECT	title_id, title, type, notes,
		CASE type
			WHEN 'business'		THEN 0.10
			WHEN 'mod_cook'		THEN 0.15
			WHEN 'popular_comp' THEN 0.10
			WHEN 'psychology'	THEN 0.25
			WHEN 'trad_cook'	THEN 0.15
			ELSE				0.05
		END as [% de descuento]
FROM pubs.dbo.titles

--Tambien se puede optimizar la estructura anterior agrupando los casos en comun:
SELECT	title_id, title, type, notes,
		CASE
			WHEN type IN ('business','popular_comp')	THEN 0.10
			WHEN type IN ('mod_cook','trad_cook')		THEN 0.15
			WHEN type = 'psychology'					THEN 0.25
			ELSE										0.05
		END as [% de descuento]
FROM pubs.dbo.titles

--Ademas que si una estructura CASE WHEN devuelve un valor numerico este se puede operar:
--Para el ejemplo anterior en lugar de mostrar el % de descuento, mostraremos el precio ya con el descuento
--y redondeado a dos decimales
SELECT	title_id, title, type, notes, price,
		CAST(price-price*
			CASE
				WHEN type IN ('business','popular_comp')	THEN 0.10
				WHEN type IN ('mod_cook','trad_cook')		THEN 0.15
				WHEN type = 'psychology'					THEN 0.25
				ELSE										0.05
			END
		as decimal(12,2)) as [precio final con descuento]
FROM pubs.dbo.titles

--CASE WHEN como se vio en el ejemplo anterior se puede combinar con campos calculados
--otro ejemplo:
use BaleadasGPT
go

/*Mostrar el ID, fecha y utilidad para todas las facturas cuyo Estado sea NOR,
por ultimo muestre una columna llamada Observaciones la cual mostrara un texto
de acuerdo al rango de utilidad obtenida por factura segun la escala siguiente:
	menos de CERO						Perdida
	igual a CERO						No hay ganancia
	mayor a CERO y menor o igual a 50	Poca ganancia
	mayor a 50 y menor o igual a 100	Ganancia moderada
	mayor a 100 y menor o igual a 300	Buenas ganancias
	mayor a 300							Excelente
Ordene la informacion de acuerdo a la utilidad de mayor a menor
*/
SELECT	FacturaID, Fecha, Total-CostoPromedioTotal as Utilidad,
		CASE
			WHEN Total-CostoPromedioTotal < 0 THEN 'Perdida'
			WHEN Total-CostoPromedioTotal = 0 THEN 'No hay ganancia'
			WHEN Total-CostoPromedioTotal > 0 AND Total-CostoPromedioTotal <= 50 THEN 'Poca ganancia'
			WHEN Total-CostoPromedioTotal > 50 AND Total-CostoPromedioTotal <= 100 THEN 'Ganancia moderada'
			WHEN Total-CostoPromedioTotal > 100 AND Total-CostoPromedioTotal <= 300 THEN 'Buenas ganancias'
			WHEN Total-CostoPromedioTotal > 300 THEN 'Excelente'
		END as Observaciones
FROM FacturaCab
WHERE Estado = 'NOR'
ORDER BY 3 DESC
--En el ejemplo anterior no se necesita ELSE porque ya cubrio todos los escenarios posibles y en
--caso de tener algun escenario no controlado el valor a devolver sera NULL

/*Otro Ejemplo:
Para todas las facturas cuyo estado sea NOR muestre el ID, Fecha y Total asi como una columna
lamada Temporada que indique en que epoca del año fue realizada la venta basados en el Mes de acuerdo
a la tabla siguiente:
	Meses					Temporada
	1 y 8					Temporada baja
	2						Mes de los enamorados
	entre 3 y 7				Verano
	entre 9 y 12			Temporada Navideña*/
SELECT	FacturaID, CAST(Fecha as Date) as [Fecha sin hora], Total,
		CASE
			WHEN MONTH(Fecha) IN (1,8)			THEN 'Temporada baja'
			WHEN MONTH(Fecha) = 2				THEN 'Mes de los enamorados'
			WHEN MONTH(Fecha) BETWEEN 3 AND 7	THEN 'Verano'
			WHEN MONTH(Fecha) BETWEEN 9 AND 12	THEN 'Temporada Navideña'
		END as Temporada
FROM FacturaCab
WHERE Estado = 'NOR'