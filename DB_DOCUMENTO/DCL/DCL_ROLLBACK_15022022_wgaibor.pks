/*
 * SCRIPT DCL DE REVERSO DEL ESQUEMA DB_COMERCIAL. 
 */
REVOKE REFERENCES ON DB_COMERCIAL.INFO_EMPRESA_GRUPO FROM DB_DOCUMENTO;
REVOKE SELECT  ON DB_COMERCIAL.INFO_EMPRESA_GRUPO FROM DB_DOCUMENTO;
REVOKE SELECT  ON db_documento.admi_respuesta FROM DB_DOCUMENTO;
REVOKE SELECT  ON db_documento.admi_enunciado FROM DB_DOCUMENTO;
REVOKE SELECT  ON db_documento.admi_documento_enunciado FROM DB_DOCUMENTO;

/