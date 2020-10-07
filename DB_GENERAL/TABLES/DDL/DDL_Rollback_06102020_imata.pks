
/*
 * Revocar los permisos de las tablas ADMI_PARAMETRO_CAB y ADMI_PARAMETRO_DET en la estructura de DB_HORAS_EXTRAS
 */

revoke SELECT on "DB_GENERAL"."ADMI_PARAMETRO_CAB" from "DB_HORAS_EXTRAS" ;
revoke SELECT on "DB_GENERAL"."ADMI_PARAMETRO_DET" from "DB_HORAS_EXTRAS" ;

/
