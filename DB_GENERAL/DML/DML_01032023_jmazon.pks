/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear cabecera y detalle de parametros para flujo de factibilidad con empresa Ecuanet.
 * @author Jonathan Mazón Sánchez <jmazon@telconet.ec>
 * @version 1.0 
 * @since 01-03-2023 - Versión Inicial.
 */

/* SE INSERTA EL REGISTRO PARA SABER QUE TIPO DE EQUIPO SE VA A INSTALAR */
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_DET
  (
    ID_PARAMETRO_DET,
    PARAMETRO_ID ,
    DESCRIPCION ,
    VALOR1 ,
    VALOR2 ,
    VALOR3 ,
    VALOR4 ,
    ESTADO ,
    USR_CREACION ,
    FE_CREACION ,
    IP_CREACION ,
    USR_ULT_MOD ,
    FE_ULT_MOD ,
    IP_ULT_MOD ,
    VALOR5  
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
    WHERE NOMBRE_PARAMETRO = 'FACTIBILIDAD_ELEMENTO_EQUIVALENTE'
    ),
    'ELEMENTO_EQUIVALENTE',
    'EN',
    'OLT',
    '',
    '',
    'Activo',
    'emartillo',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL, 
    NULL,
    NULL
  );    

/* INSERT CAMPOS PARA LA TOMA DE INFORMACION PARA INSTALACION DE OLT INTERNET ECUANET */

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
     DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'PARAMETROS_ASOCIADOS_A_SERVICIOS_EN',
    'Parámetros para diversas validaciones de planes EN',
    '',
    'Activo',
    'emartillo',
     SYSDATE,
    '127.0.0.1'
  ); 

/*INSERT CAMPOS PARA LA TOMA DE INFORMACION PARA INSTALACION DE OLT INTERNET ECUANET*/

INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET(
ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	VALOR4,
	VALOR5,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	EMPRESA_COD)
VALUES(
DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
(
SELECT
	ID_PARAMETRO
FROM
	ADMI_PARAMETRO_CAB
WHERE
	NOMBRE_PARAMETRO = 'PARAMETROS_ASOCIADOS_A_SERVICIOS_EN'),
'Valor3:Dist max. cobert,Valor4:Dist max. factib,Valor5-Valor6:# max. cajas-conectores Cobert-Factib',
'PROCESO_FACTIBILIDAD',
'CONFIG_RESPONSE',
'250',
'250',
'1',
'Activo',
'emartillo',
sysdate,
'127.0.0.1',
33);


/*INSERT CAMPOS PARA LA TOMA DE INFORMACION PARA INSTALACION DE OLT INTERNET ECUANET*/

INSERT
	INTO
	DB_GENERAL.ADMI_PARAMETRO_DET(
ID_PARAMETRO_DET,
	PARAMETRO_ID,
	DESCRIPCION,
	VALOR1,
	VALOR2,
	VALOR3,
	ESTADO,
	USR_CREACION,
	FE_CREACION,
	IP_CREACION,
	EMPRESA_COD)
VALUES(
DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
(
SELECT
	ID_PARAMETRO
FROM
	ADMI_PARAMETRO_CAB
WHERE
	NOMBRE_PARAMETRO = 'PARAMETROS_ASOCIADOS_A_SERVICIOS_EN'),
'Valor3: Tipo de elemento conector',
'PROCESO_FACTIBILIDAD',
'PARAMS_CONSULTA',
'SPLITTER',
'Activo',
'emartillo',
sysdate,
'127.0.0.1',
33);

/*SE AGREGA EL VALOR DE CODIGO EMPRESA EN EN EL VALOR4 */

 UPDATE
	DB_GENERAL.ADMI_PARAMETRO_DET
SET
	VALOR4 = '["MD","EN"]'
	WHERE PARAMETRO_ID = 1852
	AND DESCRIPCION = 'VALIDACION_FACTIBILIDAD_NUEVO_ALGORITMO';



COMMIT;


/
     
