
DELETE FROM db_general.admi_area
WHERE
        nombre_area = 'Administrativo'
    AND empresa_cod = (
        SELECT
            iegr.cod_empresa
        FROM
            db_comercial.info_empresa_grupo iegr
        WHERE
                iegr.prefijo = 'EN'
            AND iegr.estado = 'Activo'
    );

DELETE FROM db_general.admi_area
WHERE
        nombre_area = 'Comercial'
    AND empresa_cod = (
        SELECT
            iegr.cod_empresa
        FROM
            db_comercial.info_empresa_grupo iegr
        WHERE
                iegr.prefijo = 'EN'
            AND iegr.estado = 'Activo'
    );

DELETE FROM db_general.admi_area
WHERE
        nombre_area = 'Tecnico'
    AND empresa_cod = (
        SELECT
            iegr.cod_empresa
        FROM
            db_comercial.info_empresa_grupo iegr
        WHERE
                iegr.prefijo = 'EN'
            AND iegr.estado = 'Activo'
    );

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET 
WHERE PARAMETRO_ID IN 
(SELECT ID_PARAMETRO 
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
  WHERE NOMBRE_PARAMETRO IN ('PARAM_FLUJO_SOLICITUD_DESC_DISCAPACIDAD', 'PARAM_FLUJO_ADULTO_MAYOR', 'DESCUENTOS_FACTURAS', 'NOMBRE_TECNICO_PRODUCTO', 'NOMBRE_TECNICO', 'DOCUMENTOS_ENTREGABLES_CONTRATO', 'TIEMPO_BANDEJA_PLAN_AUTOMATICA', 'DESCUENTOS_FACTURAS',  'VARIABLES_VELOCIDAD_PLANES'))
AND EMPRESA_COD = 33;  


DELETE FROM DB_GENERAL.admi_gestion_directorios 
WHERE aplicacion = 'TmComercial'
   AND EMPRESA = 'EN';
   
DELETE FROM DB_GENERAL.admi_sector
where empresa_cod = 33;

commit;

DECLARE
    CURSOR persona_empresa_rol IS
    SELECT
        id_persona_rol
    FROM
        db_comercial.info_persona_empresa_rol
    WHERE
        id_persona_rol IN (
            SELECT
                id_persona_rol
            FROM
                db_comercial.info_persona_empresa_rol iper
                LEFT JOIN db_comercial.info_empresa_rol         ier ON iper.empresa_rol_id = ier.id_empresa_rol
            WHERE
                ier.empresa_cod = 33
        );

BEGIN
    FOR i IN persona_empresa_rol LOOP
        DELETE FROM db_comercial.info_persona_empresa_rol
        WHERE
            id_persona_rol = i.id_persona_rol;

    END LOOP;
    COMMIT;
END;

/
DELETE FROM DB_COMERCIAL.ADMI_TIPO_NEGOCIO WHERE EMPRESA_COD = 33;

DELETE FROM DB_COMERCIAL.ADMI_TIPO_CONTRATO WHERE EMPRESA_COD = 33;

DELETE FROM db_general.admi_departamento WHERE empresa_cod = 33;

DELETE FROM DB_FINANCIERO.ADMI_CICLO WHERE empresa_cod = 33;

DELETE FROM DB_INFRAESTRUCTURA.admi_canton_jurisdiccion 
WHERE jurisdiccion_id IN (SELECT ID_JURISDICCION FROM DB_INFRAESTRUCTURA.admi_jurisdiccion JUR
                            LEFT JOIN DB_COMERCIAL.info_oficina_grupo OFI 
                            ON jur.oficina_id = ofi.id_oficina
                            WHERE ofi.empresa_id = 33);

DELETE FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION WHERE OFICINA_ID IN (SELECT ID_OFICINA FROM DB_COMERCIAL.info_oficina_grupo WHERE empresa_id = 33);                            
DELETE FROM DB_COMERCIAL.info_oficina_grupo WHERE empresa_id = 33;

COMMIT;



/

