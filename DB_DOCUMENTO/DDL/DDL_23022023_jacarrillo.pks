/*
* Se realiza cambios en estructura de unique key para multi empresa
* @author Jefferson Alexy Carrillo <jacarrillo@telconet.ec>
* @version 1.0 23-02-2023
*/ 
ALTER TABLE DB_DOCUMENTO.ADMI_PROCESO DROP CONSTRAINT UQ_ADMI_PROCESO DROP INDEX;  
ALTER TABLE DB_DOCUMENTO.ADMI_PROCESO ADD CONSTRAINT UQ_ADMI_PROCESO UNIQUE (EMPRESA_COD,CODIGO,NOMBRE);  
 


ALTER TABLE DB_DOCUMENTO.ADMI_RESPUESTA DROP CONSTRAINT UQ_ADMI_RESPUESTA DROP INDEX; 
ALTER TABLE DB_DOCUMENTO.ADMI_RESPUESTA ADD CONSTRAINT UQ_ADMI_RESPUESTA UNIQUE (EMPRESA_COD,NOMBRE);  


ALTER TABLE DB_DOCUMENTO.ADMI_DOCUMENTO DROP CONSTRAINT UQ_ADMI_DOCUMENTO DROP INDEX; 
ALTER TABLE DB_DOCUMENTO.ADMI_DOCUMENTO ADD CONSTRAINT UQ_ADMI_DOCUMENTO UNIQUE  (PROCESO_ID,CODIGO,NOMBRE);  



ALTER TABLE DB_DOCUMENTO.ADMI_CAB_ENUNCIADO DROP CONSTRAINT UQ_ADMI_CAB_ENUNCIADO DROP INDEX;
ALTER TABLE DB_DOCUMENTO.ADMI_CAB_ENUNCIADO ADD CONSTRAINT UQ_ADMI_CAB_ENUNCIADO UNIQUE (EMPRESA_COD,CODIGO,NOMBRE);  

 

ALTER TABLE DB_DOCUMENTO.ADMI_ENUNCIADO DROP CONSTRAINT UQ_ADMI_ENUNCIADO DROP INDEX;  
ALTER TABLE DB_DOCUMENTO.ADMI_ENUNCIADO ADD CONSTRAINT UQ_ADMI_ENUNCIADO UNIQUE (EMPRESA_COD,CODIGO,NOMBRE);  

 /