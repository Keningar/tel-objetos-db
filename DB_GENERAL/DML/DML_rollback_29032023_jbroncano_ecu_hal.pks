DELETE  DB_GENERAL.admi_parametro_det 
  where parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'PROGRAMAR_MOTIVO_HAL'
            AND estado = 'Activo') and empresa_cod='33' and estado='Activo' AND descripcion='ID MOTIVOS HAL PROGRAMAR';


COMMIT;
/