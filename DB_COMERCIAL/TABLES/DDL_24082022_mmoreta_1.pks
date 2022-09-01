
 
 
 --crear tabla control BI

    /**
    * Documentación para tabla INFO_PERSONA_BI
    * tabla control BI para guardar fechas de modificación de tabla INFO_PERSONA
    * @author Mónica Moreta <mmoreta@telconet.ec>
    * @version 2.0 24-08-2022
    */
CREATE TABLE DB_COMERCIAL.INFO_PERSONA_BI 
( 
 PERSONA_ID NUMBER, 
 FE_ULT_MOD TIMESTAMP
 ); 
 


 --crear tabla control BI

    /**
    * Documentación para tabla INFO_SERVICIO_HISTORIAL_BI 
    * tabla control BI para guardar fechas de modificación de tabla INFO_SERVICIO_HISTORIAL
    * @author Mónica Moreta <mmoreta@telconet.ec>
    * @version 2.0 24-08-2022
    */
CREATE TABLE DB_COMERCIAL.INFO_SERVICIO_HISTORIAL_BI 
(
SERVICIO_HISTORIAL_ID NUMBER(10,0), 
FE_ULT_MOD TIMESTAMP
);
    




  --crear tabla control BI

    /**
    * Documentación para tabla INFO_SERVICIO_PRODCARACT_BI 
    * tabla control BI para guardar fechas de modificación de tabla INFO_SERVICIO_PROD_CARACT
    * @author Mónica Moreta <mmoreta@telconet.ec>
    * @version 2.0 24-08-2022
    */
CREATE TABLE DB_COMERCIAL.INFO_SERVICIO_PRODCARACT_BI 
(
SERVICIO_PROD_CARACT_ID NUMBER, 
FE_ULT_MOD TIMESTAMP
);



/