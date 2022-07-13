/**
 * @author Walther Joao Gaibor <wgaibor@telconet.ec>
 * @version 1.0
 * @since 06-07-2022  
 * Se crea parametros de configuraciones para transferencia de documentos
 */
SET DEFINE OFF; 
   
DELETE FROM DB_GENERAL.ADMI_PARAMETRO_DET
WHERE PARAMETRO_ID = (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO = 'REGULARIZA_DOCUMENTOS_CD'
      AND ESTADO             = 'Activo'
    );

DELETE FROM DB_GENERAL.ADMI_PARAMETRO_CAB
WHERE NOMBRE_PARAMETRO = 'REGULARIZA_DOCUMENTOS_CD'
AND ESTADO             = 'Activo';

COMMIT; 
/


