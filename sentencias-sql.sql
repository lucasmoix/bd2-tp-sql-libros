
-- 1. ¿Cuáles son los títulos y nombres de los autores de los libros cuyo tipo sea ‘no’ o aquellos cuyos precios de origen superan $21?

SELECT TITULO,AUTOR  FROM LIBRO WHERE (TIPO='no' OR PRECIO_ORI >21) ORDER BY TIPO 

--2. Obtener la lista de títulos y precios originales de los libros que se editaron en 1948, 1978 y 1985

SELECT TITULO, PRECIO_ORI FROM LIBRO WHERE EDICION IN(1948,1978,1985)

-- 3. Obtener los títulos y ediciones de los libros cuyos precios originales estén dentro del rango de $12 a $25 inclusive

SELECT TITULO, EDICION,PRECIO_ORI,* FROM LIBRO WHERE PRECIO_ORI BETWEEN  12 AND 25
SELECT TITULO, EDICION,PRECIO_ORI,* FROM LIBRO WHERE PRECIO_ORI >=  12 AND PRECIO_ORI <=25

--4. Obtener la lista de títulos, precios originales y ediciones de aquellos libros cuyos títulos tengan las letras "R" y "S" en algún lugar y en ese orden.

SELECT TITULO,PRECIO_ORI, EDICION,* FROM LIBRO WHERE TITULO LIKE '%R%S%'

-- 5. Obtener la lista de autores y ediciones de los libros cuyos nombres de autores no comiencen con la letra G.

 SELECT AUTOR,EDICION,* FROM LIBRO WHERE AUTOR LIKE 'G%'

-- 6. Ordenar en secuencia ascendente por año de edición los títulos de los libros cuyo tipo sea ‘no’. Listar también la edición.

SELECT TITULO,TIPO, EDICION FROM LIBRO WHERE TIPO='no' ORDER BY EDICION   ASC

-- 7. Obtener todos los tipos y ediciones DISTINTAS (en tipo y Edición) de los libros, ordenado por Edición y año de edición ascendente.

SELECT DISTINCT TIPO, EDICION FROM LIBRO  ORDER BY EDICION   


--8. Obtener la suma y el promedio de los precios originales y el mínimo y el máximo de los precios actuales para todos los libros cuyo año de edición sea mayor a 1970

SELECT SUM(PRECIO_ORI) SUM_PRECIO_ORI,AVG(PRECIO_ORI) PROM_PRECIO_ORI, MIN(PRECIO_ACT) MIN_PRECIO_ACT, MAX(PRECIO_ACT) MAX_PRECIO_ACT  
FROM LIBRO WHERE  EDICION  > 1970

--9. Obtener de la suma total de la suma de los precios originales más los actuales, el promedio de dicha suma 
--y el mínimo y el máximo de las diferencias de precios para todos los libros cuyo año de edición sea superior a 1970.

SELECT SUM(PRECIO_ORI + PRECIO_ACT)TOTAL, AVG((PRECIO_ORI + PRECIO_ACT))PROM 
,MIN( PRECIO_ACT-PRECIO_ORI)MIN_DIF , MAX( PRECIO_ACT-PRECIO_ORI) MAX_DIF
FROM LIBRO WHERE  EDICION  > 1970




-- 10. Contar la cantidad de libros, los distintos tipos de libros, el mínimo y el máximo del precio original, pero sólo 
-- para aquellos libros cuyo precio original supere los $30.

SELECT   TIPO , COUNT(1) TOTAL , MIN(PRECIO_ORI) MIN_PRECIO_ORI, MAX(PRECIO_ORI) MAX_PRECIO_ORI  
FROM LIBRO 
WHERE  PRECIO_ORI  >30
GROUP BY TIPO 


-- 11. Calcular el promedio y el total de los precios actuales de todos los libros,imprimiendo los títulos adicionales "PROMEDIO --->" y "TOTAL --->" 
-- en la línea de resumen.

SELECT   AVG(PRECIO_ACT) PROMEDIO , SUM(PRECIO_ACT) TOTAL 
FROM LIBRO 

--12. Listar los nombres y la dirección de los lectores que tienen libros a préstamo (usar subconsultas)

SELECT NOMBRE, DIRECCION 
FROM LECTOR 
WHERE NRO_LECTOR IN(SELECT NRO_LECTOR FROM PRESTAMO WHERE F_DEVOL IS NULL)

SELECT L.NOMBRE, L.DIRECCION 
FROM LECTOR L
WHERE L.NRO_LECTOR =(SELECT NRO_LECTOR FROM PRESTAMO WHERE F_DEVOL IS NULL AND NRO_LECTOR= L.NRO_LECTOR)

--13. Listar el número, título y precio actual del libro que tenga el máximo precio original.
SELECT NRO_LIBRO,TITULO,PRECIO_ACT FROM LIBRO WHERE PRECIO_ORI=(SELECT MAX(PRECIO_ORI) FROM LIBRO)
--14. Obtener por cada libro el tiempo promedio del préstamo (fechadevolución–fechapréstamo). Tomar en cuenta solo los préstamos ya devueltos

SELECT NRO_LIBRO, 
AVG(DATEDIFF(day, F_PREST, F_DEVOL)) TIEMPO_PROMEDIO
FROM PRESTAMO 
WHERE F_DEVOL IS NOT NULL
GROUP BY NRO_LIBRO
--15. ¿Hay error de sintaxis en el siguiente SQL?
SELECT * FROM (SELECT NRO_LIBRO, TITULO FROM LIBRO)

Sí, hay error de sintaxis, falta el alias:
SELECT * FROM (SELECT NRO_LIBRO, TITULO FROM LIBRO)A
--16. Listar los nombres de los lectores y los autores de los libros, ordenados de manera ascendente, indicar además un campo en el que se identifique si es “autor” o “lector”
SELECT AUTOR AS NOMBRE, 'AUTOR' AUTOR FROM LIBRO
UNION
SELECT NOMBRE, 'LECTOR'  FROM LECTOR
ORDER BY NOMBRE ASC

--17. Listar el número de lector, su nombre y la cantidad de préstamos realizados a ese lector
SELECT LECTOR.NRO_LECTOR, LECTOR.NOMBRE, COUNT(PRESTAMO.F_PREST) AS CANT_PRESTAMOS
FROM LECTOR INNER JOIN PRESTAMO ON LECTOR.NRO_LECTOR = PRESTAMO.NRO_LECTOR
GROUP BY LECTOR.NRO_LECTOR, LECTOR.NOMBRE

--18. Ídem anterior, pero listando la cantidad de préstamos sobre libros diferentes (si llevó dos veces el mismo libro se cuenta como una sola) 
SELECT LECTOR.NRO_LECTOR, LECTOR.NOMBRE, COUNT(DISTINCT NRO_LIBRO) AS CANT_PRESTAMOS
FROM LECTOR INNER JOIN PRESTAMO ON LECTOR.NRO_LECTOR = PRESTAMO.NRO_LECTOR
GROUP BY LECTOR.NRO_LECTOR, LECTOR.NOMBRE

--19. Listar el número de libro, el título, el número de copia, y la cantidad de préstamos realizados para cada copia de cada libro, pero sólo para aquellas copias que se hayan prestado más de 1 vez. 
SELECT A.NRO_LIBRO, A.TITULO, B.NRO_COPIA,COUNT(C.F_PREST) PRESTAMOS_POR_COPIA
FROM LIBRO A INNER JOIN COPIAS B ON A.NRO_LIBRO= B.NRO_LIBRO
INNER JOIN PRESTAMO C ON C.NRO_LIBRO=B.NRO_LIBRO 
GROUP BY A.NRO_LIBRO, A.TITULO, B.NRO_COPIA
HAVING COUNT(C.NRO_COPIA)>1
--20.  Obtener la lista de los títulos de los libros prestados y los nombres de los lectores que los tienen en préstamo 
SELECT A.TITULO, C.NOMBRE,B.*
FROM LIBRO A 
INNER JOIN PRESTAMO B ON A.NRO_LIBRO= B.NRO_LIBRO
INNER JOIN LECTOR C ON B.NRO_LECTOR=C.NRO_LECTOR
WHERE B.F_DEVOL IS  NULL

--21. Listar los libros que no hayan sido prestados – Realizar utilizando IN 
SELECT * FROM LIBRO WHERE LIBRO.NRO_LIBRO NOT IN (SELECT NRO_LIBRO FROM PRESTAMO)
--22. Ídem anterior, pero utilizando EXISTS 
SELECT * FROM LIBRO WHERE NOT EXISTS 
(SELECT NRO_LIBRO FROM PRESTAMO WHERE PRESTAMO.NRO_LIBRO = LIBROO.NRO_LIBRO)
