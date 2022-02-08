
/**
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 * @version 1.0 14-01-2022 
 *
 *Se elimina los nuevos parametros de control de version de documentos
 * digitales
 **/

DELETE FROM  DB_GENERAL.ADMI_PARAMETRO_DET  WHERE PARAMETRO_ID IN (SELECT ID_PARAMETRO        
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'DOC_VERSION_CONTRATO_DIGITAL' AND ESTADO= 'Activo');
  
/

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE 
     NOMBRE_PARAMETRO= 'DOC_VERSION_CONTRATO_DIGITAL';
COMMIT;

/

