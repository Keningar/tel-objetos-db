CREATE  FORCE VIEW "NAF47_TNET"."INFO_TRIBUTARIA_DOC" ("SECUENCIA_CARGA_ID", "AMBIENTE_ID", "TIPO_EMISION_ID", "RAZON_SOCIAL", "NOMBRE_COMERCIAL", "RUC", "CLAVE_ACCESO", "DOCUMENTO_ID", "ESTABLECIMIENTO", "PUNTO_EMISION", "SECUENCIAL_ID", "DIR_MATRIZ") AS 
  SELECT "SECUENCIA_CARGA_ID","AMBIENTE_ID","TIPO_EMISION_ID","RAZON_SOCIAL","NOMBRE_COMERCIAL","RUC","CLAVE_ACCESO","DOCUMENTO_ID","ESTABLECIMIENTO","PUNTO_EMISION","SECUENCIAL_ID","DIR_MATRIZ"
FROM NAF47_TNET.INFO_TRIBUTARIA_DOC@GPOETNET;