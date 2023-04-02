/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para ejecucion rollback  detalle de parametros para configuracion opcion tareas
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 09-03-2023 - Versión Inicial.
 */


              delete from  DB_GENERAL.Admi_Parametro_Det det where parametro_id in (
              select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'EMPRESAS_VISIBLES_EN_TAREAS'
              ) and descripcion = 'EMPRESA VISIBLE PARA ECUANET' ;
              
                                 
              delete from  DB_GENERAL.Admi_Parametro_Det det where parametro_id in (
              select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'EMPRESAS_VISIBLES_EN_TAREAS'
              ) and valor1 = 'MD' and valor2= '33';
              
              
              delete from  DB_GENERAL.Admi_Parametro_Det det where parametro_id in (
              select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'EMPRESAS_VISIBLES_EN_TAREAS'
              ) and valor1 = 'TN' and valor2= '33';
              
              
              delete from db_general.Admi_Gestion_Directorios where aplicacion = 'TelcosWeb'  and SUBMODULO = 'Tareas' and empresa = 'EN';
              delete from db_general.Admi_Gestion_Directorios where aplicacion = 'TelcosWeb'  and SUBMODULO = 'Casos' and empresa = 'EN';

COMMIT;


/
     
