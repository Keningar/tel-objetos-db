/**
 * Reverso de creación de la plantilla de regularización
 *
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 * @version 1.0 06-03-2023
 */


DELETE FROM DB_COMUNICACION.ADMI_PLANTILLA WHERE CODIGO ='REGULARIZA_CLI'  AND EMPRESA_COD=33;

DELETE FROM DB_COMUNICACION.ADMI_PLANTILLA WHERE CODIGO ='PROSPECTO_INFOR'  AND EMPRESA_COD=33;

   
 COMMIT;
/



