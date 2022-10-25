
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
 * DEBE EJECUTARSE EN DB_GENERAL
 * SE PARAMETRIZA LA OBSERVACION DE LAS PROMOCIONES
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */

INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'CORREO_RESUMEN_COMPRA_PROM','SE PARAMETRIZA LA OBSERVACION DE LAS PROMOCIONES',null
,null,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'CORREO_RESUMEN_COMPRA_PROM'),
'TERMINOS_Y_CONDICIONES','Leer los términos y condiciones  del adendum Servicio adjunto','',NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null);

/**
 * DEBE EJECUTARSE EN DB_GENERAL 
 * SE PARAMETRIZA LOS ESTADOS EN LOS QUE SE ENVIARA EL CORREO
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */

INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'CRC_ESTADOS_PRODUCTOS_ADICIONALES','SE PARAMETRIZA LOS ESTADOS A CONSULTAR DE LOS PRODUCTOS ADICIONALES QUE SE ENVIARA CORREO RESUMEN COMPRA',null
,null,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'CRC_ESTADOS_PRODUCTOS_ADICIONALES'),
'CRC_ESTADOS_PRODUCTOS_ACTIVOS','Activo',NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'CRC_ESTADOS_PRODUCTOS_ADICIONALES'),
'CRC_ESTADOS_PRODUCTOS_INTERVENCION_HUMANA','Pendiente,Pre-servicio,PrePlanificada,PreAsignacionInfoTecnica,Asignada',NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null);


/**DEBE EJECUTARSE EN DB_GENERAL
 * CREACION DE NUEVO DIRECTORIO
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */

INSERT INTO db_general.ADMI_GESTION_DIRECTORIOS
(
    ID_GESTION_DIRECTORIO,
    CODIGO_APP,
    CODIGO_PATH,
    APLICACION,
    PAIS,
    EMPRESA,
    MODULO,
    SUBMODULO,
    ESTADO,
    FE_CREACION,
    USR_CREACION
)
VALUES
(
    db_general.SEQ_ADMI_GESTION_DIRECTORIOS.nextval,
    4,
    (SELECT (CASE WHEN MAX(CODIGO_PATH) IS NULL THEN 0+1 ELSE (MAX(CODIGO_PATH)+1) END) AS CODIGO_PATH
        FROM db_general.ADMI_GESTION_DIRECTORIOS WHERE CODIGO_APP=4),
    'ResumenCompra',
    '593',
    'MD',
    'Comercial',
    'DocResumenCompra',
    'Activo',
    sysdate,
    'jbroncano'
); 

/**
 * DEBE EJECUTARSE EN DB_GENERAL 
 * SE PARAMETRIZA LAS PROMOCIONES
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 06-06-2022 - Versión Inicial.
 */

INSERT INTO DB_GENERAL.admi_parametro_cab 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,'CRC_USUARIOS_PROMOCION_PRODUCTO','SE PARAMETRIZA  USUARIO PARA CONSULTAR LAS PROMOCIONES',null
,null,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null);

INSERT INTO DB_GENERAL.admi_parametro_det 
VALUES(DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.nextval,
(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'CRC_USUARIOS_PROMOCION_PRODUCTO'),
'CRC_USUARIOS_PROMOCION_RSC','telcos_map_prom',NULL,NULL,NULL,'Activo','jbroncano',SYSDATE,'0.0.0.0',null,null,null,null,'18',null,null,null);
COMMIT;
/