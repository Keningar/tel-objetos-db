/*
 * Script para reversar los privilegios de consulta a las tablas de parámetros.
 */
REVOKE SELECT ON DB_GENERAL.ADMI_PARAMETRO_CAB FROM DB_EXTERNO;
REVOKE SELECT ON DB_GENERAL.ADMI_PARAMETRO_DET FROM DB_EXTERNO;
/
