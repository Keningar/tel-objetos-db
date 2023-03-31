/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear  detalle de parametros para configuracion opcion casos
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 12-03-2023 - Versión Inicial.
 */


insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'SISTEMA_EMPRESAS'),
              'RELACION SISTEMAS Y EMPRESAS HABILITADAS',
              'TELCOS',
              33,
              'EN',
              '1',
              'Activo',
              'wdsanchez',
              sysdate,
              '127.0.0.1',
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null,
              null
              );
              
              
              
                insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from DB_GENERAL.ADMI_PARAMETRO_CAB APCAB where APCAB.NOMBRE_PARAMETRO = 'WEB SERVICE TAREAS'),
              'Cobranzas Y Facturacion',
              '33',
              'Cobranzas Y Facturacion',
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
              null,
              null,
              null,
              null,
              null,
              null
              );
              
              
              
               insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from DB_GENERAL.ADMI_PARAMETRO_CAB APCAB where APCAB.NOMBRE_PARAMETRO = 'WEB SERVICE TAREAS'),
              'Ip Contact Center',
              '33',
              'Ip Contact Center',
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
              null,
              null,
              null,
              null,
              null,
              null
              );
              
              
                 insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from DB_GENERAL.ADMI_PARAMETRO_CAB APCAB where APCAB.NOMBRE_PARAMETRO = 'WEB SERVICE TAREAS'),
              'Calidad',
              '33',
              'Calidad',
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
              null,
              null,
              null,
              null,
              null,
              null
              );
              
              
                     insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from DB_GENERAL.ADMI_PARAMETRO_CAB APCAB where APCAB.NOMBRE_PARAMETRO = 'WEB SERVICE TAREAS'),
              'Gepon',
              '33',
              'Gepon',
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
              null,
              null,
              null,
              null,
              null,
              null
              );
              

 

COMMIT;


/
     
