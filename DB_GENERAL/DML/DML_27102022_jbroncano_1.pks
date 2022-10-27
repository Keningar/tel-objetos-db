
/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones de la fecha para que se visualize el boton de reenvio correo compra 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 27-10-2022 - Versión Inicial.
 */


INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'CRC_FECHA_REENVIO_CORREO'),
'CRC_FECHA_REGULARIZACION_CORREO_RESUMEN',1,NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null);


/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones de la fecha para que se visualize el boton de reenvio correo compra 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */


INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'CRC_FECHA_REENVIO_CORREO','SE PARAMETRIZA  DONDE LOS SERVICIOS CREADOS A PARTIR DE ESTA FECHA SE MOSTRARA EL BOTON DE REENVIO DEL CORREO RESUMEN COMPRA',null
,null,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'CRC_FECHA_REENVIO_CORREO'),
'CRC_FECHA_REENVIO_CORREO_RESUMEN',SYSDATE,NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null);


/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones de la fecha para que se visualize el boton de reenvio correo compra 
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */
 
INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'CRC_EMPRESA_RESUMEN_CORREO','SE PARAMETRIZA  LAS EMPRESAS DONDE SE ENVIARA EL CORREO',null
,null,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'CRC_EMPRESA_RESUMEN_CORREO'),
'EMPRESA_RESUMEN_CORREO','18',NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null);

COMMIT;
/