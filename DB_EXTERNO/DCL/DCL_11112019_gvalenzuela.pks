/**
 * Privilegios para que el esquema 'DB_EXTERNO' puedan consultar las tablas de parámetros de 'DB_GENERAL'.
 */
GRANT SELECT ON DB_GENERAL.ADMI_PARAMETRO_CAB TO DB_EXTERNO;
GRANT SELECT ON DB_GENERAL.ADMI_PARAMETRO_DET TO DB_EXTERNO;
/
