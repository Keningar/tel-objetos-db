/**
 * DEBE EJECUTARSE EN DB_BUSPAGOS.
 * @author Milen Ortega <mortega1@telconet.ec>
 * @version 1.0 28/12/2022
 */ 
    GRANT SELECT ON DB_BUSPAGOS.INFO_CLIENTE TO DB_FINANCIERO;
    GRANT SELECT ON DB_BUSPAGOS.INFO_PAGO_EVENTO TO DB_FINANCIERO;
    GRANT SELECT ON DB_BUSPAGOS.INFO_PAGO_DETALLE TO DB_FINANCIERO; 
    GRANT SELECT ON DB_BUSPAGOS.INFO_PAGO TO DB_FINANCIERO; 
    GRANT SELECT ON DB_BUSPAGOS.INFO_ENTIDAD_REC_EMPRESA TO DB_FINANCIERO; 
    GRANT SELECT ON DB_BUSPAGOS.ADMI_EMPRESA TO DB_FINANCIERO;   
    GRANT SELECT ON DB_BUSPAGOS.INFO_CONFIG_ENT_REC_EMP TO DB_FINANCIERO;  
    GRANT SELECT ON DB_BUSPAGOS.ADMI_PERSONA TO DB_FINANCIERO;   

COMMIT;
/