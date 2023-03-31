/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones bandera para utilizacion de enviar correo o whtssap
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 20-03-2023 - Versión Inicial.
 */
 
delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'NOTIFICACION_WHATSAPP'
and parametro_id=(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO')
and EMPRESA_COD=33;
delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'PLANTILLA_WHATSAPP'
and parametro_id=(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO')
and EMPRESA_COD=33;

DELETE FROM  DB_GENERAL.ADMI_PARAMETRO_DET WHERE PARAMETRO_ID=(
        SELECT
            ID_PARAMETRO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE
            NOMBRE_PARAMETRO = 'URL_CONTRATO_ADHESION' AND ESTADO='Activo') AND 
DESCRIPCION='URL_SITIO_WEB_CONSULTA_TARIFAS' AND ESTADO='Activo' and EMPRESA_COD=33;

DELETE FROM  DB_GENERAL.ADMI_PARAMETRO_DET WHERE PARAMETRO_ID=(
        SELECT
            ID_PARAMETRO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE
            NOMBRE_PARAMETRO = 'URL_CONTRATO_ADHESION' AND ESTADO='Activo') AND 
DESCRIPCION='URL_SITIO_WEB_CONSULTA_CALIDAD_SERVICIO' AND ESTADO='Activo' and EMPRESA_COD=33;

DELETE FROM  DB_GENERAL.ADMI_PARAMETRO_DET WHERE PARAMETRO_ID=(
        SELECT
            ID_PARAMETRO
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB
        WHERE
            NOMBRE_PARAMETRO = 'URL_CONTRATO_ADHESION' AND ESTADO='Activo') AND 
DESCRIPCION='URL_SITIO_WEB_DATOS_PERSONALES' AND ESTADO='Activo' and EMPRESA_COD=33;
            

COMMIT;
/
