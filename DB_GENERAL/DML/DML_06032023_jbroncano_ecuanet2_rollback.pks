DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA'
            AND estado = 'Activo') and estado='Activo' ;

DELETE DB_GENERAL.admi_parametro_cab 
 WHERE  nombre_parametro = 'DIGITAL_ASUNTO_CORREO_EMPRESA';



 DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PROCESO_EMER_SANITARIA'
            AND estado = 'Activo') and estado='Activo' and empresa_cod='33';


COMMIT;

/