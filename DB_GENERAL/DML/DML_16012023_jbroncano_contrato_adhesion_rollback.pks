/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones bandera para utilizacion de enviar correo o whtssap
 * @author Joel Broncano<jbroncano@telconet.ec>
 * @version 1.0 12-01-2023 - Versión Inicial.
 */
 
delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'NOTIFICACION_WHATSAPP'
and parametro_id=(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO');

delete from DB_GENERAL.admi_parametro_det WHERE DESCRIPCION = 'PLANTILLA_WHATSAPP'
and parametro_id=(select cab.id_parametro from DB_GENERAL.admi_parametro_cab cab where cab.nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO');


COMMIT;
/

