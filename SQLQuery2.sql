

--              OBLIGATORIO BASE DE DATOS 

--				INTEGRANTES:

--				NOMBRE          NumeroEstudiante
--				Eduard Suarez   252860
--				Ivan Zapater    275262


-- VIVERO PFLANZE

USE master
USE OBLIGATORIO_BD1
SET DATEFORMAT dmy;
--#############################################   CONSULTAS     #####################################################################

--a. Mostrar Nombre de Planta y Descripción del Mantenimiento para el último(s)
--mantenimiento hecho en el año actual

SELECT DISTINCT P.NOMBRE_POPULAR, M.DESCRIPCION
FROM PLANTA P , MANTENIMIENTO M 
WHERE P.ID = M.ID_PLANTA 
AND M.FECHA_HORA = (SELECT MAX(FECHA_HORA) FROM MANTENIMIENTO)


--b. Mostrar la(s) plantas que recibieron más cantidad de mantenimientos
SELECT DISTINCT P.NOMBRE_POPULAR, COUNT(*) CANT_MANTENIMIENTO
FROM PLANTA P , MANTENIMIENTO M 
WHERE P.ID = M.ID_PLANTA 
GROUP BY P.NOMBRE_POPULAR
HAVING COUNT(*) >= ALL (SELECT DISTINCT COUNT(*)
						FROM PLANTA P1 JOIN MANTENIMIENTO M1 
						ON P1.ID = M1.ID_PLANTA
						GROUP BY P1.NOMBRE_POPULAR)
						

--c. Mostrar las plantas que este año ya llevan más de un 20% de costo de mantenimiento
--que el costo de mantenimiento de todo el año anterior para la misma planta ( solo
--considerar plantas nacidas en el año 2019 o antes)


SELECT DISTINCT P.*, 
SUM( ( ( (PR.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS) +N.COSTO_APLICACION_DOLARES )+ O.COSTO ) 
- ( ( ( (PR.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS) +N.COSTO_APLICACION_DOLARES )+ O.COSTO )/100*20) ) ESTE_ANIO, 
SUM( ( ( (PR1.PRECIO_DOLARXGRAMO*N1.CANT_GRAMOS) +N1.COSTO_APLICACION_DOLARES )+ O1.COSTO)) ANIO_PASADO 

FROM PLANTA P, MANTENIMIENTO M, OPERATIVO O, PRODUCTO PR, NUTRIENTE N, PRODUCTO_NUTRIENTE PN,
               MANTENIMIENTO M1, OPERATIVO O1, PRODUCTO PR1, NUTRIENTE N1, PRODUCTO_NUTRIENTE PN1

WHERE M.ID_PLANTA= P.ID 
	AND O.ID_MANT_OPERATIVO = M.ID_MANTENIMIENTO
	AND N.ID_MANT_NUTRIENTE = M.ID_MANTENIMIENTO
	AND PR.CODIGO = PN.CODIGO_PRODUCTO
	AND PN.ID_NUTRIENTE = N.ID_MANT_NUTRIENTE
	AND M.FECHA_HORA BETWEEN '01/01/2022'  AND getdate()
	AND M1.ID_PLANTA= P.ID 
	AND O1.ID_MANT_OPERATIVO = M1.ID_MANTENIMIENTO
	AND N1.ID_MANT_NUTRIENTE = M1.ID_MANTENIMIENTO
	AND PR1.CODIGO = PN1.CODIGO_PRODUCTO
	AND PN1.ID_NUTRIENTE = N1.ID_MANT_NUTRIENTE
	AND M1.FECHA_HORA BETWEEN '01/01/2021'  AND '31/12/2021'
	AND P.FECHA_NACIMIENTO < '01/01/2020'

GROUP BY P.ID , P.NOMBRE_POPULAR, P.FECHA_NACIMIENTO, P.ALTURA, P.FECHA_HORA_MEDIDA, P.PRECIO_VENTA
HAVING SUM( ( ( (PR.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS) +N.COSTO_APLICACION_DOLARES )+ O.COSTO ) 
		- ( ( ( (PR.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS) +N.COSTO_APLICACION_DOLARES )+ O.COSTO )/100*20) ) >
	   SUM( ( ( (PR1.PRECIO_DOLARXGRAMO*N1.CANT_GRAMOS) +N1.COSTO_APLICACION_DOLARES )+ O1.COSTO))   
GO


--ANIO PASADO   
SELECT DISTINCT P.* ,SUM( ( ( (PR.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS) +N.COSTO_APLICACION_DOLARES )+ O.COSTO )) ANIO_PASADO
FROM PLANTA P, MANTENIMIENTO M, OPERATIVO O, PRODUCTO PR, NUTRIENTE N, PRODUCTO_NUTRIENTE PN
WHERE M.ID_PLANTA= P.ID 
	AND O.ID_MANT_OPERATIVO = M.ID_MANTENIMIENTO
	AND N.ID_MANT_NUTRIENTE = M.ID_MANTENIMIENTO
	AND PR.CODIGO = PN.CODIGO_PRODUCTO
	AND PN.ID_NUTRIENTE = N.ID_MANT_NUTRIENTE
	AND M.FECHA_HORA BETWEEN '01/01/2021'  AND '31/12/2021'
	AND P.FECHA_NACIMIENTO < '01/01/2020'
GROUP BY P.ID , P.NOMBRE_POPULAR, P.FECHA_NACIMIENTO, P.ALTURA, P.FECHA_HORA_MEDIDA, P.PRECIO_VENTA

--ESTE ANIO 

SELECT DISTINCT P.* ,SUM( ( ( (PR.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS) +N.COSTO_APLICACION_DOLARES )+ O.COSTO ) 
- ( ( ( (PR.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS) +N.COSTO_APLICACION_DOLARES )+ O.COSTO )/100*20) ) ESTE_ANIO
FROM PLANTA P, MANTENIMIENTO M, OPERATIVO O, PRODUCTO PR, NUTRIENTE N, PRODUCTO_NUTRIENTE PN
WHERE M.ID_PLANTA= P.ID 
	AND O.ID_MANT_OPERATIVO = M.ID_MANTENIMIENTO
	AND N.ID_MANT_NUTRIENTE = M.ID_MANTENIMIENTO
	AND PR.CODIGO = PN.CODIGO_PRODUCTO
	AND PN.ID_NUTRIENTE = N.ID_MANT_NUTRIENTE
		AND M.FECHA_HORA BETWEEN '01/01/2022'  AND getdate()
	AND P.FECHA_NACIMIENTO < '01/01/2020'
GROUP BY P.ID , P.NOMBRE_POPULAR, P.FECHA_NACIMIENTO, P.ALTURA, P.FECHA_HORA_MEDIDA, P.PRECIO_VENTA



--d. Mostrar las plantas que tienen el tag “FRUTAL”, a la vez tienen el tag “PERFUMA” y no
--tienen el tag “TRONCOROTO”. Y que adicionalmente miden medio metro de altura o
--más y tienen un precio de venta establecido

SELECT DISTINCT P.* FROM PLANTA P , TAG T 
WHERE T.ID_PLANTA = P.ID 
    AND T.NOMBRE BETWEEN  'FRUTAL' AND  'PERFUMA' 
    AND T.NOMBRE  <> 'TRONCODOBLADO' 
    AND P.ALTURA >= 0.5
    AND P.PRECIO_VENTA > 0


--e. Mostrar las Plantas que recibieron mantenimientos que en su conjunto incluyen todos
--los productos existentes

SELECT DISTINCT P.*, COUNT(PR.CODIGO) CANT_PRODUCTOS
FROM PLANTA P , MANTENIMIENTO M, PRODUCTO PR, PRODUCTO_NUTRIENTE PN
WHERE P.ID = M.ID_PLANTA  
    AND PR.CODIGO = PN.CODIGO_PRODUCTO
    AND M.ID_MANTENIMIENTO = PN.ID_NUTRIENTE
GROUP BY  P.ID ,P.NOMBRE_POPULAR,P.FECHA_NACIMIENTO ,P.ALTURA,P.FECHA_HORA_MEDIDA ,P.PRECIO_VENTA
HAVING COUNT(PR.CODIGO) >= (SELECT DISTINCT COUNT(PR.CODIGO)
						FROM  PRODUCTO PR)





--f. Para cada Planta con 2 años de vida o más y con un precio menor a 200 dólares:
--sumarizar su costo de Mantenimiento total ( contabilizando tanto mantenimientos de
--tipo “OPERATIVO” como de tipo “NUTRIENTES”) y mostrar solamente las plantas que
--su costo sumarizado es mayor que 100 dólares.


SELECT PL.ID, PL.NOMBRE_POPULAR, SUM( ( (P.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS)+N.COSTO_APLICACION_DOLARES) + O.COSTO)  COSTO_TOTAL
FROM PLANTA PL, PRODUCTO P, NUTRIENTE N, OPERATIVO O, MANTENIMIENTO M, PRODUCTO_NUTRIENTE PN
WHERE DATEDIFF(YEAR,PL.FECHA_NACIMIENTO,GETDATE()) > 2 
    AND PL.PRECIO_VENTA <200 
	AND P.CODIGO = PN.CODIGO_PRODUCTO
	AND O.ID_MANT_OPERATIVO = M.ID_MANTENIMIENTO
	AND N.ID_MANT_NUTRIENTE = M.ID_MANTENIMIENTO 
	AND N.ID_MANT_NUTRIENTE= PN.ID_NUTRIENTE
	AND PL.ID = M.ID_PLANTA
GROUP BY PL.ID, PL.NOMBRE_POPULAR
HAVING SUM( ( (P.PRECIO_DOLARXGRAMO*N.CANT_GRAMOS) +N.COSTO_APLICACION_DOLARES) + O.COSTO) > 100


				

 --############################################## FIN CONSULTAS #################################################################



--######################################### PROCEDIMIENTOS ALMACENADOS  #####################################################

--a. Implementar un procedimiento AumentarCostosPlanta que reciba por parámetro:
--un Id de Planta, un porcentaje y un rango de fechas.
--El procedimiento debe aumentar en el porcentaje dado, para esa planta, los costos de mantenimiento que se dieron en ese rango
--de fechas. Esto tanto para mantenimientos de tipo “OPERATIVO” donde se aumenta el
--costo por concepto de mano de obra (no se aumentan las horas, solo el costo) como de
--tipo “NUTRIENTES” donde se debe aumentar los costos por concepto de uso de producto
--(no se debe aumentar ni los gramos de producto usado ni actualizar nada del maestro de
--productos)
--El procedimiento debe retornar cuanto fue el aumento total de costo en dólares para la
--planta en cuestión.

DROP PROCEDURE AumentarCostosPlanta


CREATE PROCEDURE AumentarCostosPlanta
@ID NUMERIC,
@PORCENTAJE DECIMAL(10,2),
@FECHAI DATE,
@FECHAF DATE
AS
BEGIN
IF EXISTS(SELECT P.* FROM PLANTA P, MANTENIMIENTO M WHERE M.ID_PLANTA= P.ID 
		    AND M.FECHA_HORA BETWEEN  @FECHAI AND @FECHAF AND P.ID = @ID)
	BEGIN
		DECLARE @COSTO_TOTAL VARCHAR(40);
			BEGIN TRY
				 UPDATE OPERATIVO set COSTO = COSTO +((@PORCENTAJE/100)*COSTO)
					              where ID_MANT_OPERATIVO in(Select O.ID_MANT_OPERATIVO
												             from OPERATIVO O, MANTENIMIENTO M
															 WHERE O.ID_MANT_OPERATIVO = M.ID_MANTENIMIENTO 
															 AND M.ID_PLANTA = @ID 
															 AND M.FECHA_HORA BETWEEN @FECHAI  AND @FECHAF);

				   UPDATE NUTRIENTE set COSTO_APLICACION_DOLARES = COSTO_APLICACION_DOLARES + ((@PORCENTAJE/100)*COSTO_APLICACION_DOLARES)
					               where ID_MANT_NUTRIENTE in (Select N.ID_MANT_NUTRIENTE
														       from NUTRIENTE N, MANTENIMIENTO M
														       WHERE N.ID_MANT_NUTRIENTE = M.ID_MANTENIMIENTO 
														       AND M.ID_PLANTA = @ID 
														       AND M.FECHA_HORA BETWEEN @FECHAI  AND @FECHAF);
					      
						SET @COSTO_TOTAL = (SELECT SUM(N.COSTO_APLICACION_DOLARES + O.COSTO)  
											FROM NUTRIENTE N, OPERATIVO O, MANTENIMIENTO M 
											WHERE N.ID_MANT_NUTRIENTE = O.ID_MANT_OPERATIVO		
											AND O.ID_MANT_OPERATIVO=M.ID_MANTENIMIENTO 
											AND M.ID_PLANTA= @ID 
											AND M.FECHA_HORA BETWEEN @FECHAI AND @FECHAF);
						PRINT 'PRECIO TOTAL '+ @COSTO_TOTAL
				END TRY
				BEGIN CATCH
				       PRINT 'NO SE CAMBIO0 PRECIO'
				END CATCH
	END
	ELSE
	       PRINT 'NO SE CAMBIO PRECIO';
END 



--EXEC
EXEC AumentarCostosPlanta 4,1,'13/04/2022','12/12/2022'
--------------------

--SELECT DE PRUEBA PARA EL EXEC, IDPLANTA ES 4, PERO SU ID DE MANTENIMIENTO ES 4
SELECT SUM(O.Costo + N.COSTO_APLICACION_DOLARES) as Suma
FROM OPERATIVO O, NUTRIENTE N
WHERE O.ID_MANT_OPERATIVO=4 AND N.ID_MANT_NUTRIENTE=4

SELECT * FROM OPERATIVO WHERE OPERATIVO.ID_MANT_OPERATIVO=4
SELECT * FROM NUTRIENTE WHERE NUTRIENTE.ID_MANT_NUTRIENTE=4


--b. Mediante una función que recibe como parámetro un año: retornar el costo promedio de
--los mantenimientos de tipo “OPERATIVO” de ese año

CREATE FUNCTION CostoPromedioOperativo(@FECHA INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
DECLARE @costo DECIMAL(10,2)
		SELECT @costo= AVG(O.COSTO)
		FROM OPERATIVO O, MANTENIMIENTO M
		WHERE O.ID_MANT_OPERATIVO  = M.ID_MANTENIMIENTO 
		AND YEAR(M.FECHA_HORA) = @FECHA
		RETURN @costo
END	

--SELECT QUE MUESTRA EL RESULTADO DE LA FUNCION
select dbo.CostoPromedioOperativo(2021)as CostoPromedio



--SELECT DE PRUEBA, RETORNA LO MISMO QUE EL SELECT DE ARRIBA, PERO CON MAS DECIMALES
SELECT  AVG(O.COSTO)
		FROM OPERATIVO O, MANTENIMIENTO M										--PONER EL ANIO
		WHERE O.ID_MANT_OPERATIVO  = M.ID_MANTENIMIENTO AND YEAR(M.FECHA_HORA) = 2021


--######################################### FIN PROCEDIMIENTOS #############################################################


--######################################### disparadores    ##################################################

--a. Auditar cualquier cambio del maestro de Productos. Se debe llevar un registro detallado de
--las inserciones, modificaciones y borrados, en todos los casos registrar desde que PC se
--hacen los movimientos, la fecha y la hora, el usuario y todos los datos que permitan una
--correcta auditoría (si son modificaciones que datos se modificaron, qué datos había antes,
--que datos hay ahora, etc). La/s estructura/s necesaria para este punto es libre y queda a
--criterio del alumno

INSERT INTO PRODUCTO(CODIGO, DESCRIPCION,PRECIO_DOLARXGRAMO) 
									VALUES('3ACC5','Mejora la calidad de la tiera',2)

DELETE PRODUCTO WHERE CODIGO = '3ACC5'
UPDATE PRODUCTO SET PRECIO_DOLARXGRAMO=5 WHERE PRECIO_DOLARXGRAMO=2
SELECT * FROM PRODUCTO

SELECT * FROM HISTORIAL_PRODUCTO


CREATE TRIGGER AUDITORIA_MAESTRO_PRODCUCTO
ON PRODUCTO AFTER INSERT,DELETE,UPDATE
AS BEGIN

 IF EXISTS(SELECT * FROM INSERTED) AND NOT EXISTS(SELECT * FROM DELETED)--INSERTED
 BEGIN 
      INSERT   HISTORIAL_PRODUCTO
	  SELECT ' INSERCION ', HOST_NAME(), SYSTEM_USER, GETDATE(), 
	  I.CODIGO, NULL, NULL, I.DESCRIPCION ,I.PRECIO_DOLARXGRAMO
	  FROM INSERTED I
 END

 IF EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED)--DELETED
 BEGIN
		 INSERT   HISTORIAL_PRODUCTO 
		 SELECT ' ELIMINACION ', HOST_NAME(), SYSTEM_USER, GETDATE(), D.CODIGO, 
	     D.DESCRIPCION, D.PRECIO_DOLARXGRAMO, NULL ,NULL 
		 FROM DELETED D
 END

 IF EXISTS(SELECT * FROM DELETED) AND EXISTS(SELECT * FROM INSERTED)--UPDATED
   BEGIN
         
		  IF UPDATE(PRECIO_DOLARXGRAMO)
		  INSERT   HISTORIAL_PRODUCTO 
		         SELECT 'MODIFICACION PRECIO', HOST_NAME(), SYSTEM_USER, GETDATE(),
				 D.CODIGO, NULL, D.PRECIO_DOLARXGRAMO, NULL ,I.PRECIO_DOLARXGRAMO 
				 FROM INSERTED I JOIN DELETED D
				 ON D.CODIGO = I.CODIGO
		  IF UPDATE(DESCRIPCION)
		  INSERT   HISTORIAL_PRODUCTO 
				 SELECT 'MODIFICACION DESCRIPCION', HOST_NAME(), SYSTEM_USER, GETDATE(),
				 D.CODIGO, D.DESCRIPCION, NULL, I.DESCRIPCION ,NULL 
				 FROM INSERTED I JOIN DELETED D
				 ON D.CODIGO = I.CODIGO
		 IF (UPDATE(DESCRIPCION) and UPDATE(PRECIO_DOLARXGRAMO))
		 INSERT   HISTORIAL_PRODUCTO 
		         SELECT 'MODIFICACION COMPLETA', HOST_NAME(), SYSTEM_USER, GETDATE(),
				 D.CODIGO, D.DESCRIPCION, D.PRECIO_DOLARXGRAMO, I.DESCRIPCION ,I.PRECIO_DOLARXGRAMO 
				 FROM INSERTED I JOIN DELETED D
				 ON D.CODIGO = I.CODIGO
  END
END
GO

--B) Controlar que no se pueda dar de alta un mantenimiento cuya fecha-hora es menor que la
--fecha de nacimiento de la planta

CREATE TRIGGER TR__ALTA_MANTENIMIENTO
ON MANTENIMIENTO INSTEAD OF INSERT
AS BEGIN
  INSERT INTO MANTENIMIENTO
  SELECT I.FECHA_HORA, I.DESCRIPCION, I.ID_PLANTA
  FROM INSERTED I, PLANTA P 
  WHERE P.ID = I.ID_PLANTA
  AND I.FECHA_HORA > P.FECHA_NACIMIENTO;
     IF(@@ROWCOUNT >0 )  --MENSAJES DE PRUEBA INSTANTANEA
        PRINT 'SE AGREGO MANTENIMIENTO'
     ELSE
	 ROLLBACK TRANSACTION;
        PRINT '-ERROR- FECHA_MEDIDA DEBE SER MAYOR FECHA NAC DE [PLANTA]'
END
GO
'22/05/2021'
INSERT INTO MANTENIMIENTO(FECHA_HORA, DESCRIPCION, ID_PLANTA)
									VALUES('13/01/2021 08:00:00.000','PRUEBA',1);

--##########################################   fin disparadores   #####################################################

--indices
create index I_mantenimientoPlanta on Mantenimiento(id_Planta);
create index I_Nutriente on Producto_Nutriente(ID_NUTRIENTE);
create index I_Producto on Producto_Nutriente(Codigo_Producto);
create index I_Tag_idplanta on Tag(ID_planta);