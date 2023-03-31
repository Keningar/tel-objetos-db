  UPDATE 	DB_GENERAL.admi_parametro_det
SET DESCRIPCION='Parámetro con validaciones de contrato fisico validaciones VALOR1: -PREGUNTA1-, VALOR2: -RESPUESTA1- VALOR3: -PREGUNTA2-, VALOR4: -RESPUESTA2-, VALOR5: -RESPUESTA POR default-',
OBSERVACION=''
WHERE  parametro_id in (SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'CONTRATO_FISICO_VALIDACION'
            AND estado = 'Activo')   and estado='Activo';


COMMIT;
/