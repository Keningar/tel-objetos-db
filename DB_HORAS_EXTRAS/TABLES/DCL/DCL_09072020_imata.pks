
--Grant para poder consultar la tabla V_EMPLEADOS_EMPRESAS
grant SELECT on "NAF47_TNET"."V_EMPLEADOS_EMPRESAS" to "DB_HORAS_EXTRAS" ;

--Grant para poder consultar el paquete GNRLPCK_UTIL para el envio de correos.
grant EXECUTE on "DB_GENERAL"."GNRLPCK_UTIL" to "DB_HORAS_EXTRAS" ;

-- Grant para poder consultar la tabla ARPLDP
grant SELECT on "NAF47_TNET"."ARPLDP" to "DB_HORAS_EXTRAS" ;

-- Grant para poder consultar la tablas de la estructura db_comercial en la estructura db_horas_extras
grant SELECT on "DB_COMERCIAL"."INFO_PERSONA" to "DB_HORAS_EXTRAS" ;
grant SELECT on "DB_COMERCIAL"."INFO_PERSONA_EMPRESA_ROL" to "DB_HORAS_EXTRAS" ;
grant SELECT on "DB_COMERCIAL"."INFO_EMPRESA_ROL" to "DB_HORAS_EXTRAS" ;
grant SELECT on "DB_COMERCIAL"."ADMI_CUADRILLA" to "DB_HORAS_EXTRAS" ;

/
