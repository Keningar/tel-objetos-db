/*
 * Grant para poder utilizar las tablas de ADMI_PARAMETRO_CAB y ADMI_PARAMETRO_DET en la estructura de DB_HORAS_EXTRAS.
 */

grant SELECT on "DB_GENERAL"."ADMI_PARAMETRO_CAB" to "DB_HORAS_EXTRAS" ;
grant SELECT on "DB_GENERAL"."ADMI_PARAMETRO_DET" to "DB_HORAS_EXTRAS" ;

/
