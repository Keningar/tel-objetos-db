/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para ejecucion rollback  detalle de parametros para configuracion opcion tareas - reubicacion
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 17-03-2023 - Versión Inicial.
 */

             delete  from DB_GENERAL.Admi_Parametro_Det where parametro_id in (
              select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where NOMBRE_PARAMETRO = 'PROCESO_REUBICACION'
              ) and descripcion = 'MOTIVO_SOLICITUD_FACT' and usr_creacion = 'wdsanchez';



            delete from DB_GENERAL.Admi_Parametro_Det where parametro_id in (
              select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where NOMBRE_PARAMETRO = 'NOMBRES_TAREAS_REUBICACION'
              )  and usr_creacion = 'wdsanchez';


COMMIT;


/
     
