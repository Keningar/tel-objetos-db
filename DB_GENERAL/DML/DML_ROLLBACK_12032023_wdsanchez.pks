/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para ejecucion rollback  detalle de parametros para configuracion opcion casos
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 12-03-2023 - Versión Inicial.
 */


              delete from DB_GENERAL.Admi_Parametro_Det 
              where valor2= '33' 
                and valor3 = 'EN'
                and PARAMETRO_ID in 
                (select ID_PARAMETRO from DB_GENERAL.ADMI_PARAMETRO_CAB where NOMBRE_PARAMETRO = 'SISTEMA_EMPRESAS');
                
                
delete 
  from DB_GENERAL.ADMI_PARAMETRO_DET APDET 
 where parametro_id in (select id_parametro from DB_GENERAL.ADMI_PARAMETRO_CAB APCAB where APCAB.NOMBRE_PARAMETRO = 'WEB SERVICE TAREAS') 
   and APDET.DESCRIPCION <> 'Tarea de app de Cert' 
   and valor1 in ('33');
   

COMMIT;


/
     
