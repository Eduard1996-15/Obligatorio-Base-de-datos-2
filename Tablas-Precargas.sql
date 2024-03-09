
--              OBLIGATORIO BASE DE DATOS 

--				INTEGRANTES:

--				NOMBRE          NumeroEstudiante
--				Eduard Suarez   252860
--				Ivan Zapater    275262


-- VIVERO PFLANZE

USE MASTER
drop database OBLIGATORIO_BD1
CREATE DATABASE OBLIGATORIO_BD1 
USE OBLIGATORIO_BD1
SET DATEFORMAT dmy;
--############################################   TABLAS    ###################################################

--////////////PLANTA\\\\\\\\\\\\\\\\\

CREATE TABLE HISTORIAL_PRODUCTO(
 ID INT IDENTITY,
 TIPO VARCHAR(200),
 SISTEMA VARCHAR(200),
 USUARIO VARCHAR(50),
 FECHA DATETIME,
 CODIGO CHARACTER(5),
 DESCRIPCION_ANTERIOR VARCHAR(50),
 PRECIO_DOLARXGRAMO_ANTERIOR DECIMAL,
 DESCRIPCION_NUEVO VARCHAR(50) ,
 PRECIO_DOLARXGRAMO_NUEVO DECIMAL,
 CONSTRAINT PK_HIST_PRODUCTO_ID PRIMARY KEY(ID)
 );
 GO

CREATE TABLE PLANTA(
ID NUMERIC IDENTITY NOT NULL,
NOMBRE_POPULAR VARCHAR(50) NOT NULL,
FECHA_NACIMIENTO DATE NOT NULL,
ALTURA NUMERIC(12),--CHECK DE NO SUPERAR 12.000 CM
FECHA_HORA_MEDIDA DATETIME,--NO PUEDE SER MENOR AL NACIMIENTO
PRECIO_VENTA DECIMAL(10,1),
CONSTRAINT PK_ID PRIMARY KEY(ID),
CONSTRAINT CK_PLANTA_ALTURAYFECHA CHECK(ALTURA IS NULL OR (ALTURA BETWEEN 0 AND 12 AND FECHA_HORA_MEDIDA > FECHA_NACIMIENTO AND FECHA_HORA_MEDIDA <= GETDATE())),
CONSTRAINT CK_PLANTA_FECHANAC CHECK(FECHA_NACIMIENTO <= GETDATE()),
CONSTRAINT CK_PLANTA_PRECIO CHECK(PRECIO_VENTA IS NULL OR PRECIO_VENTA >0)
);
GO
--////////////TAG\\\\\\\\\\\\\\\\\

CREATE TABLE TAG(
NOMBRE VARCHAR(30) NOT NULL,
ID_PLANTA NUMERIC NOT NULL,
CONSTRAINT FK_IDPLANTA FOREIGN KEY(ID_PLANTA) REFERENCES PLANTA(ID),
CONSTRAINT CK_NOMBRE CHECK(NOMBRE IN ('FRUTAL', 'SINFLOR', 'CONFLOR' , 'SOMBRA', 'HIERBA', 'PERFUMA','TRONCODOBLADO'))
);
GO
--////////////MANTENIMIENTO\\\\\\\\\\\\\\\\\

CREATE TABLE MANTENIMIENTO(
ID_MANTENIMIENTO NUMERIC IDENTITY,
FECHA_HORA DATETIME NOT NULL,
DESCRIPCION VARCHAR(200) NOT NULL,
ID_PLANTA NUMERIC NOT NULL,
CONSTRAINT FK_MANT_PLANTA FOREIGN KEY(ID_PLANTA) REFERENCES PLANTA(ID),
CONSTRAINT PK_ID_MANTENIMIENTO PRIMARY KEY(ID_MANTENIMIENTO),
CONSTRAINT HK_MANT_FECHA CHECK(FECHA_HORA <= GETDATE())
);
GO
--////////////OPERATIVO\\\\\\\\\\\\\\\\\

CREATE TABLE OPERATIVO(
HORAS DECIMAL(10,1) NOT NULL,
COSTO DECIMAL(10,1) NOT NULL,
ID_MANT_OPERATIVO NUMERIC NOT NULL,
CONSTRAINT FK_ID_MANT_OPERATIVO FOREIGN KEY(ID_MANT_OPERATIVO) REFERENCES MANTENIMIENTO(ID_MANTENIMIENTO),
CONSTRAINT PK_ID_MANT_OPERATIVO  PRIMARY KEY(ID_MANT_OPERATIVO),
CONSTRAINT HK_MANT_OPERATIVO_HORA CHECK(HORAS > 0),
CONSTRAINT HK_MANT_OPERATIVO_COSTO CHECK(COSTO > 0)
);
go

--////////////PRODUCTO\\\\\\\\\\\\\\\\\

CREATE TABLE PRODUCTO(
CODIGO CHARACTER(5) NOT NULL,
DESCRIPCION VARCHAR(200) UNIQUE NOT NULL,
PRECIO_DOLARXGRAMO DECIMAL NOT NULL,
CONSTRAINT PK_CODIGO_PRODUCTO PRIMARY KEY(CODIGO)
);
go

--////////////NUTRIENTE\\\\\\\\\\\\\\\\\

CREATE TABLE NUTRIENTE(
ID_MANT_NUTRIENTE NUMERIC NOT NULL,
CANT_GRAMOS INT NOT NULL,
COSTO_APLICACION_DOLARES DECIMAL(10,1) NOT NULL, --COSTO POR MANO DE OBRA 
CONSTRAINT FK_ID_MANT_NUTRIENTE FOREIGN KEY(ID_MANT_NUTRIENTE) REFERENCES MANTENIMIENTO(ID_MANTENIMIENTO),
CONSTRAINT HK_MANT_NUTRIENTE_CANTGRAM CHECK(CANT_GRAMOS > 0),
CONSTRAINT HK_MANT_NUTRIENTE_COST_AP CHECK(COSTO_APLICACION_DOLARES > 0),
CONSTRAINT PK_ID_MANT_NUTRIENTE PRIMARY KEY(ID_MANT_NUTRIENTE)
);
go

CREATE TABLE PRODUCTO_NUTRIENTE(
--ID INT IDENTITY,
ID_NUTRIENTE NUMERIC NOT NULL,
CODIGO_PRODUCTO CHARACTER(5) NOT NULL,
CONSTRAINT FK_ID_PRODUCTO FOREIGN KEY(CODIGO_PRODUCTO) REFERENCES PRODUCTO(CODIGO),
CONSTRAINT FK_ID_NUTRIENTE FOREIGN KEY(ID_NUTRIENTE) REFERENCES NUTRIENTE(ID_MANT_NUTRIENTE),
CONSTRAINT PK_ PRIMARY KEY(ID_NUTRIENTE,CODIGO_PRODUCTO)
--PARA QUE NO PUEDA USAR EL MISMO PRODUCTO DOS VECES EN EL MISMO MANTENIMIENTO
);
GO


--#############################################   ELIMINAR TABLAS Y BASE DE DATOS ###########################################################
USE master 
DROP DATABASE OBLIGATORIO_BD
DROP TABLE PLANTA
DROP TABLE TAG
DROP TABLE MANTENIMIENTO
DROP TABLE OPERATIVO
DROP TABLE PRODUCTO
DROP TABLE NUTRIENTE
DROP TABLE PRODUCTO_NUTRIENTE
DROP TABLE HISTORIAL_PRODUCTO
--##########################################################################################################################################


--####################################################    PRECARGAS    #####################################################################


INSERT INTO PLANTA  VALUES('Drácena','22/05/2021',5,'22/03/2022',210), --SINFLOR
								   		  ('Cyperus alternifolius','13/10/2018',11,'10/04/2022',200),
										  ('Areca simplificada','28/02/2021',12,'22/01/2022',200),
										  ('Crotón','01/02/2019',9,'24/01/2022',160),
										  ('Sanseviera','19/03/2018',11,'24/01/2022',120), 
								   		  ('Dieffembaquia','24/11/2018',10,'10/04/2022',123),
										   ('Zamioculca','11/11/2021',12,'13/01/2022',100),
										   --CONFLOR
										  ('Espatifilo','28/05/2021',8,'17/01/2022',100),
							  			  ('Ciclamen','12/01/2022',6,'12/02/2022',110),
										  --PERFUMA
										  ('jazmín','12/06/2021',9,'28/10/2021',80),
										  --SOMBRA
										  ('Bromelia','02/08/2021',11,'24/01/2022',210),
										  --FRUTAL
										  ('Almendro','14/08/2021',12,'04/05/2022',110),
										  ('Damasco','12/09/2021',12,'04/05/2022',100), 
										  ('Manzano','19/08/2021',12,'04/05/2022',80),
										  ('Naranjo','22/09/2021',12,'04/05/2022',80),
										  ('Fresa','28/08/2019',6,'04/05/2022',130),
										  ('Kiwi','23/09/2019',11,'04/05/2022',120);


GO
INSERT INTO TAG(NOMBRE,ID_PLANTA) VALUES('SINFLOR',1),
										('SINFLOR',2),
										('SINFLOR',3),
										('SINFLOR',4),
										('SINFLOR',5),
										('SINFLOR',6),
										('SINFLOR',7),
										('CONFLOR',8),
										('CONFLOR',9),
										('PERFUMA',10),('FRUTAL',10),
										('SOMBRA',11),
										('FRUTAL',12),
										('FRUTAL',13),
										('FRUTAL',14),
										('FRUTAL',15), ('PERFUMA',15),
										('FRUTAL',16), ('PERFUMA',16),
										('FRUTAL',17), ('PERFUMA',17);
GO

INSERT INTO MANTENIMIENTO(FECHA_HORA, DESCRIPCION, ID_PLANTA)
									VALUES('13/01/2021 08:00:00.000','Transplantar',1),
										  ('22/05/2022 08:00:00.000','Pulverizar planta',2),
										  ('18/10/2021 09:00:00.000','Pulverizar planta',11),
										  ('22/04/2022 09:00:00.000','Trasplantar',3),
									      ('22/04/2022 10:00:00.000','Transplantar',4),
										  ('21/04/2022 08:00:00.000','Transplante y quitar hojas secas',5),
										  ('21/04/2022 09:00:00.000','Tiene algunas hojas amarillas',6),
										  ('20/04/2022 08:00:00.000','Podar',8),
										  ('22/04/2022 11:00:00.000','Agregar Fertilizantes',7),
										  ('23/01/2022 08:00:00.000','Podar flores o tallos que empezaron a marchitarse',9),
										  ('19/02/2021 06:00:00.000','Agregar Pesticidas',2),
										  ('17/03/2022 01:00:00.000','Agregar tierra orgánica',11),
										  ('13/05/2022 11:00:00.000','Agregar Fertilizantes',8),
										  ('14/02/2022 01:00:00.000','Agregar alimento para plantas',9),
										  ('25/03/2021 12:00:00.000','Transplante y quitar hojas secas',4),
										  ('16/01/2022 07:00:00.000','curar tallos ',10),
										  ('17/02/2022 02:00:00.000','Agregar alimento para plantas',12),
										  ('18/03/2022 07:00:00.000','Agregar alimento para plantas',13),
										  ('13/05/2022 07:00:00.000','Agregar alimento para plantas',14),
										  ('11/05/2021 03:00:00.000','Agregar alimento para plantas',15),
										  ('10/03/2021 07:00:00.000','Agregar alimento para plantas',16),
										  ('14/04/2022 05:00:00.000','Agregar remedios para plantas',17),
										  ('15/07/2021 04:00:00.000','Agregar Pesticidas',12),
										  ('13/02/2022 03:00:00.000','Agregar tierra orgánica',11),
										  ('12/03/2022 02:00:00.000','Agregar Fertilizantes',15),
										  ('10/02/2022 06:00:00.000','Agregar Pesticidas',12),
										  ('09/01/2022 07:00:00.000','Agregar tierra orgánica',11),
										  ('01/04/2022 09:00:00.000','Agregar Fertilizantes',8),
										  ('21/04/2021 08:00:00.000','Transplante y quitar hojas secas',5),
										  ('21/04/2021 09:00:00.000','Tiene algunas hojas amarillas',6);
										  
GO


INSERT INTO OPERATIVO(HORAS, COSTO, ID_MANT_OPERATIVO)
									VALUES(1,20,1),
										  (1,50,2),
										  (1,10,3),
										  (1,55,4),
										  (1,55,5),
										  (1,56,12),
										  (2,68,6),
										  (3,30,7),
										  (1,25,8),
										  (2,40,10),
										  (1,20,11),
										  (3,30,9),
										  (1,25,15),
										  (2,40,13),
										  (1,20,14),
										  (3,10,30);
GO


INSERT INTO PRODUCTO(CODIGO, DESCRIPCION,PRECIO_DOLARXGRAMO) 
									VALUES('2ABC3','Mejora la calidad de la tierra',2), --Fertilizantes
										  ('12AFD','Mata, repele o atrae a las plagas',4), --pesticidas
										  ('A2FG2','Fertilizante compuesto de residuos orgánicos',2), --compost
										  ('GGH45','Tierra orgánica potenciada',3),
										  ('VB3YU','Estimula un acelerado desarrollo de raíces',3); --alimento para plantas
GO


INSERT INTO NUTRIENTE(ID_MANT_NUTRIENTE,CANT_GRAMOS, COSTO_APLICACION_DOLARES) 
										 VALUES(3,10,20),
											   (5,10,23),
											   (12,10,22),
											   (6,10,32),
											   (7,10,44),
											   (8,10,10),
											   (9,10,15),
											   (10,10,30),
											   (1,10,20),
											   (2,10,10),
											   (13,10,22),
											   (4,10,23),
											   (11,10,12),
											   (14,10,10),
											   (15,10,15),
											   (29,10,10),
											   (30,10,10);

											   
GO


INSERT INTO PRODUCTO_NUTRIENTE(ID_NUTRIENTE, CODIGO_PRODUCTO)
						VALUES(1,'VB3YU'),
						(3,'VB3YU'),
						(1,'2ABC3'),
						(3,'12AFD'),
						(3,'GGH45'),
						(4,'VB3YU'),
						(4,'12AFD'),
						(5,'VB3YU'),
						(6,'VB3YU'),
						(7,'GGH45'),
						(2,'12AFD'),
						(2,'VB3YU'),
						(8,'12AFD'),
						(9,'VB3YU'),
						(9,'2ABC3'),
						(10,'12AFD'),
						(10,'A2FG2'),
						(10,'GGH45'),
						(11,'2ABC3'),
						(12,'VB3YU'),
						(12,'GGH45'),
						(13,'VB3YU'),
						(13,'2ABC3'),
						(29,'2ABC3'),
						(30,'VB3YU');



SELECT * FROM PLANTA
SELECT * FROM TAG
SELECT * FROM MANTENIMIENTO
select * FROM OPERATIVO;
select * FROM PRODUCTO;
SELECT * FROM NUTRIENTE
SELECT * FROM PRODUCTO_NUTRIENTE