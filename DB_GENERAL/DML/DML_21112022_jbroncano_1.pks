/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * SE PARAMETRIZA  VARIABLE DE VELOCIDAD COMERCIAL EN CREACIÓN DE PLANES
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 21-11-2022 - Versión Inicial.
 */
 
INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'VARIABLES_VELOCIDAD_PLANES','SE PARAMETRIZA  VARIABLE DE VELOCIDAD
COMERCIAL EN CREACIÓN DE PLANES',null
,null,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'VARIABLES_VELOCIDAD_PLANES'),
'VELOCIDAD_MAXIMA',
(select adc.ID_CARACTERISTICA from DB_COMERCIAL.ADMI_CARACTERISTICA  adc where adc.DESCRIPCION_CARACTERISTICA='VELOCIDAD MÁXIMA COMERCIAL'),
NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null,null,null)

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'VARIABLES_VELOCIDAD_PLANES'),
'VELOCIDAD_MINIMA',
(select adc.ID_CARACTERISTICA from DB_COMERCIAL.ADMI_CARACTERISTICA  adc where adc.DESCRIPCION_CARACTERISTICA='VELOCIDAD MÍNIMA COMERCIAL'),
NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null,null,null);

COMMIT;

/