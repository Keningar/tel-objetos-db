/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear  detalle de parametros para configuracion opcion tareas - reubicacion 
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 17-03-2023 - Versión Inicial.
 */


insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where NOMBRE_PARAMETRO = 'NOMBRES_TAREAS_REUBICACION'),
              'Reubicacion Equipos en Cliente',
              'Reubicacion Equipos en Cliente',
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
              
              
              
insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where NOMBRE_PARAMETRO = 'NOMBRES_TAREAS_REUBICACION'),
              'Reubicacion Equipos en Cliente Sin Fibra',
              'Reubicacion Equipos en Cliente Sin Fibra',
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
              
              


insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where NOMBRE_PARAMETRO = 'PROCESO_REUBICACION'),
              'MOTIVO_SOLICITUD_FACT',
              'Traslado / Reubicacion',
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
     
