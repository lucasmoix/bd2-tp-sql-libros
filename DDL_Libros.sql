/* DDL de Creacion de Tablas */

CREATE TABLE LIBRO (NRO_LIBRO int PRIMARY KEY not null, 
                     TITULO char(40),
                     AUTOR char(30),
                     TIPO char(2),
                     PRECIO_ORI smallmoney,
                     PRECIO_ACT smallmoney, 
                     EDICION smallint,
					 ESTADO char(1),
					 FOREIGN KEY (TIPO) REFERENCES TIPOLIBRO(TIPO)
					 )
					 
					 DELETE FROM LIBRO
					 DROP TABLE LIBRO
					 DROP TABLE PRESTAMO
					 DROP TABLE COPIAS
--
CREATE TABLE TIPOLIBRO (TIPO char(2) PRIMARY KEY not null,
			DESCTIPO char(40))
--
CREATE TABLE LECTOR (NRO_LECTOR int PRIMARY KEY NOT NULL,
                     NOMBRE char(22),
                     DIRECCION char(30),
                     TRABAJO char(10),
                     SALARIO smallmoney,
					 ESTADO char(1))
--
CREATE TABLE COPIAS (NRO_LIBRO int not null,
                       NRO_COPIA smallint  NOT NULL,
					   ESTADO char(1),
					   FOREIGN KEY (NRO_LIBRO) REFERENCES LIBRO(NRO_LIBRO)
                       )
CREATE UNIQUE INDEX index_copias
 ON COPIAS (NRO_LIBRO,NRO_COPIA)

 SELECT * FROM COPIAS
--
CREATE TABLE PRESTAMO (NRO_LECTOR int,
                       NRO_LIBRO int,
                       NRO_COPIA smallint,
                       F_PREST datetime,
                       F_DEVOL datetime,
					   FOREIGN KEY (NRO_LECTOR) REFERENCES LECTOR(NRO_LECTOR),
					   FOREIGN KEY (NRO_LIBRO) REFERENCES LIBRO(NRO_LIBRO),
					   )
CREATE UNIQUE INDEX index_prestamos
 ON PRESTAMO (NRO_LECTOR,NRO_LIBRO,NRO_COPIA, F_DEVOL)

