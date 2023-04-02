/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para crear  detalle de parametros para configuracion opcion tareas
 * @author William Sanchez <wdsanchez@telconet.ec>
 * @version 1.0 
 * @since 09-03-2023 - Versión Inicial.
 */




 insert into DB_GENERAL.Admi_Parametro_Det  values(
              DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'EMPRESAS_VISIBLES_EN_TAREAS'),
              'EMPRESA VISIBLE PARA ECUANET',
              'EN',
              33,
              'S',
              'S',
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
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'EMPRESAS_VISIBLES_EN_TAREAS'),
              'EMPRESA VISIBLE PARA ECUANET',
              'EN',
              18,
              'S',
              'S',
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
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'EMPRESAS_VISIBLES_EN_TAREAS'),
              'EMPRESA VISIBLE PARA ECUANET',
              'EN',
              10,
              'S',
              'S',
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
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'EMPRESAS_VISIBLES_EN_TAREAS'),
              'EMPRESA VISIBLE PARA TELCONET',
              'TN',
              33,
              'S',
              'S',
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
              (select id_parametro from  DB_GENERAL.Admi_Parametro_Cab where nombre_parametro = 'EMPRESAS_VISIBLES_EN_TAREAS'),
              'EMPRESA VISIBLE PARA MEGADATOS',
              'MD',
              33,
              'S',
              'S',
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
              
              
insert into db_general.Admi_Gestion_Directorios values 
(
db_general.SEQ_ADMI_GESTION_DIRECTORIOS.nextval, 
4,
73,
'TelcosWeb',
'593',
'EN',
'Soporte',
'Tareas',
'Activo',
sysdate,
null,
'wdsanchez',
null
); 



insert into db_general.Admi_Gestion_Directorios values 
(
db_general.SEQ_ADMI_GESTION_DIRECTORIOS.nextval, 
4,
74,
'TelcosWeb',
'593',
'EN',
'Soporte',
'Casos',
'Activo',
sysdate,
null,
'wdsanchez',
null
);     

COMMIT;


/
     
