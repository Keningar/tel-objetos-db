/** UPDATE INFORMACION **/
UPDATE DB_SSO.ADMI_SERVICIO_SSO 
SET TIPO_AUTENTICACION = NULL,
    DEPARTAMENTO_RESPONSABLE = NULL,
    NOMBRE_RESPONSABLE = NULL,
    CORREO_RESPONSABLE = NULL,
    AUTORIZAR_CAS = NULL
WHERE TIPO_AUTENTICACION = 'CAS'
AND DEPARTAMENTO_RESPONSABLE = 'Sistemas'
AND NOMBRE_RESPONSABLE = 'Jessica Suarez'
AND CORREO_RESPONSABLE = 'jmsuarez@telconet.ec'
AND AUTORIZAR_CAS = 1;

COMMIT;

/
