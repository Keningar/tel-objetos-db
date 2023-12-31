/**
 * DEBE EJECUTARSE EN DB_INFRAESTRUCTURA.
 * Script para realizar select para DB_EXTERNO para consultas de información en MG
 * @author Joseé Bedón Sánchez <jobedon@telconet.ec>
 * @version 1.0 19-09-2019 - Versión Inicial.
 */
GRANT SELECT ON DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO TO DB_EXTERNO;
GRANT SELECT ON DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO TO DB_EXTERNO;
GRANT SELECT ON DB_INFRAESTRUCTURA.ADMI_JURISDICCION TO DB_EXTERNO;
GRANT SELECT ON DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO TO DB_EXTERNO;
GRANT SELECT ON DB_INFRAESTRUCTURA.INFO_ELEMENTO TO DB_EXTERNO;
GRANT SELECT ON DB_INFRAESTRUCTURA.INFO_IP TO DB_EXTERNO;

/**
 * DEBE EJECUTARSE EN DB_COMERCIAL.
 * Script para realizar select para DB_EXTERNO para consultas de información en MG
 * @author Joseé Bedón Sánchez <jobedon@telconet.ec>
 * @version 1.0 19-09-2019 - Versión Inicial.
 */
GRANT SELECT ON DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_SERVICIO_TECNICO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_EMPRESA_ROL TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_SERVICIO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_CONTRATO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_PERSONA TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_PUNTO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_PUNTO_CONTACTO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_PLAN_DET TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.ADMI_PRODUCTO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_PUNTO_SALDO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_SERVICIO_HISTORIAL TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.ADMI_FORMA_CONTACTO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.ADMI_TIPO_NEGOCIO TO DB_EXTERNO;
GRANT SELECT ON DB_COMERCIAL.INFO_PLAN_CAB TO DB_EXTERNO;  

GRANT EXECUTE ON DB_COMERCIAL.TECNK_SERVICIOS TO DB_EXTERNO;

/**
 * DEBE EJECUTARSE EN DB_GENERAL
 * Script para realizar select para DB_EXTERNO para consultas de información en MG
 * @author Joseé Bedón Sánchez <jobedon@telconet.ec>
 * @version 1.0 19-09-2019 - Versión Inicial.
 */
GRANT SELECT ON DB_GENERAL.ADMI_TIPO_ROL TO DB_EXTERNO;
GRANT SELECT ON DB_GENERAL.ADMI_ROL TO DB_EXTERNO;
GRANT SELECT ON DB_GENERAL.ADMI_FORMA_PAGO TO DB_EXTERNO;
GRANT SELECT ON DB_GENERAL.ADMI_SECTOR TO DB_EXTERNO;
GRANT SELECT ON DB_GENERAL.ADMI_PARROQUIA TO DB_EXTERNO;
GRANT SELECT ON DB_GENERAL.ADMI_CANTON TO DB_EXTERNO;
GRANT SELECT ON DB_GENERAL.ADMI_PROVINCIA TO DB_EXTERNO;
GRANT SELECT ON DB_GENERAL.ADMI_REGION TO DB_EXTERNO;

GRANT EXECUTE ON DB_GENERAL.GNRLPCK_UTIL TO DB_EXTERNO;

/**
 * DEBE EJECUTARSE EN DB_SOPORTE
 * Script para realizar select para DB_EXTERNO para consultas de información en MG
 * @author Joseé Bedón Sánchez <jobedon@telconet.ec>
 * @version 1.0 19-09-2019 - Versión Inicial.
 */
GRANT SELECT ON DB_SOPORTE.INFO_PARTE_AFECTADA TO DB_EXTERNO;
GRANT SELECT ON DB_SOPORTE.INFO_DETALLE TO DB_EXTERNO;
GRANT SELECT ON DB_SOPORTE.INFO_DETALLE_HIPOTESIS TO DB_EXTERNO;
GRANT SELECT ON DB_SOPORTE.INFO_CASO TO DB_EXTERNO;
GRANT SELECT ON DB_SOPORTE.ADMI_TIPO_CASO TO DB_EXTERNO;
GRANT SELECT ON DB_SOPORTE.ADMI_HIPOTESIS TO DB_EXTERNO;
GRANT SELECT ON DB_SOPORTE.INFO_CASO_HISTORIAL TO DB_EXTERNO;

/
