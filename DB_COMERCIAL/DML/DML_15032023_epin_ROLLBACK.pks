DELETE FROM db_comercial.info_persona_empresa_rol_histo
WHERE usr_creacion = 'ecuanet';

DELETE FROM DB_COMERCIAL.info_persona_empresa_rol
WHERE EMPRESA_ROL_ID IN (SELECT ID_EMPRESA_ROL FROM  DB_COMERCIAL.info_empresa_rol WHERE empresa_cod = 33);

DELETE FROM DB_COMERCIAL.info_empresa_rol
WHERE usr_creacion = 'ecuanet';

DELETE FROM DB_GENERAL.admi_area
WHERE usr_creacion = 'ecuanet';

DELETE FROM DB_GENERAL.admi_departamento
WHERE usr_creacion = 'ecuanet';
COMMIT;
/