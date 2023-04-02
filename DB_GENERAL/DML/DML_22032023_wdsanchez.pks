/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear  detalle de parametros para configuracion opcion tareas - reubicacion 
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 22-03-2023 - Versión Inicial.
 */


insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where NOMBRE_PARAMETRO = 'PROCESO_REUBICACION'),
              'VIGENCIA_SOLICITUD_NC',
              '30',
              null,
              null,
              null,
              'Activo',
              'wdsanchez',
              sysdate,
              '127.0.0.1',
              null,
              null,
              null,
              null,
              33,
              null,
              null,
              null,
              null,
              null
              );



COMMIT;


/
     
