/*
 * SCRIPT DEL ESQUEMA DB_GENERAL. 
 * SCRIPT QUE ELIMINAN TODOS LOS PARAMETROS CONFIGURADOS PARA CALCULADORA 
 */
DELETE FROM DB_GENERAL.admi_parametro_det det 
WHERE det.parametro_id = (select cab.id_parametro 
                          from DB_GENERAL.admi_parametro_cab cab 
                          where cab.nombre_parametro = 'INSP_CALC_PARAM_INI');
                                 
DELETE FROM DB_GENERAL.admi_parametro_det det 
WHERE det.parametro_id = (select cab.id_parametro 
                          from DB_GENERAL.admi_parametro_cab cab 
                          where cab.nombre_parametro = 'INSP_CALC_PARAM_NOTIF');
                          
DELETE FROM DB_GENERAL.admi_parametro_det det 
WHERE det.parametro_id = (select cab.id_parametro 
                          from DB_GENERAL.admi_parametro_cab cab 
                          where cab.nombre_parametro = 'CARACT_TOKEN_PUSH_NOTIF');


DELETE FROM DB_GENERAL.admi_parametro_det det 
WHERE det.parametro_id = (select cab.id_parametro 
                          from DB_GENERAL.admi_parametro_cab cab 
                          where cab.nombre_parametro = 'INSP_CALC_PARAM_INSPECTION');
                          
DELETE FROM DB_GENERAL.admi_parametro_det det 
WHERE det.parametro_id = (select cab.id_parametro 
                          from DB_GENERAL.admi_parametro_cab cab 
                          where cab.nombre_parametro = 'INSP_CALC_PARAMS_REPORT');

DELETE from DB_GENERAL.admi_parametro_cab cab WHERE  cab.nombre_parametro = 'INSP_CALC_PARAM_INSPECTION';                  

DELETE from DB_GENERAL.admi_parametro_cab cab WHERE  cab.nombre_parametro = 'INSP_CALC_PARAM_INI';

DELETE from DB_GENERAL.admi_parametro_cab cab WHERE  cab.nombre_parametro = 'INSP_CALC_PARAM_NOTIF';

DELETE from DB_GENERAL.admi_parametro_cab cab WHERE  cab.nombre_parametro = 'CARACT_TOKEN_PUSH_NOTIF';

DELETE from DB_GENERAL.admi_parametro_cab cab WHERE  cab.nombre_parametro = 'INSP_CALC_PARAMS_REPORT';

COMMIT;
/