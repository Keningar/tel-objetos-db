
UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR2='hproano',VALOR1='S' 
    WHERE VALOR2='Gerente Tecnico Regional' AND PARAMETRO_ID=(SELECT A.ID_PARAMETRO 
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR');
    
    UPDATE DB_GENERAL.ADMI_PARAMETRO_DET SET VALOR2='ichavez', VALOR1='S' 
    WHERE VALOR2='Subgerente Téc. Regional' AND PARAMETRO_ID=(SELECT A.ID_PARAMETRO 
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PERMISOS_ADMINISTRADOR');

COMMIT;

DELETE FROM db_general.admi_parametro_det
WHERE
    valor1 IN (
        'Jefatura',
        'Coordinacion',
        'Gerencia'
    )
    AND parametro_id = (
        SELECT
            a.id_parametro
        FROM
            db_general.admi_parametro_cab a
        WHERE
            a.nombre_parametro = 'PERMISOS_ADMINISTRADOR'
    );






COMMIT;

/
