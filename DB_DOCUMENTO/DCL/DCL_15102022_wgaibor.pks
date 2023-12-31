/*
 * SCRIPT DCL DEL ESQUEMA DB_COMERCIAL. 
 */

GRANT SELECT  ON db_documento.admi_respuesta TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.admi_enunciado to DB_COMERCIAL;
GRANT REFERENCES on db_documento.INFO_DOC_RESPUESTA to DB_COMERCIAL;
GRANT SELECT  ON db_documento.INFO_DOC_RESPUESTA TO DB_COMERCIAL;

GRANT SELECT  ON db_documento.info_documento_relacion TO DB_COMERCIAL;
GRANT INSERT  ON db_documento.info_documento_relacion TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.info_documento_relacion to DB_COMERCIAL;

GRANT SELECT  ON db_documento.INFO_DOCUMENTO_CARAC TO DB_COMERCIAL;
GRANT INSERT  ON db_documento.INFO_DOCUMENTO_CARAC TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.INFO_DOCUMENTO_CARAC to DB_COMERCIAL;

GRANT SELECT  ON db_documento.INFO_DOC_RESPUESTA TO DB_COMERCIAL;
GRANT INSERT  ON db_documento.INFO_DOC_RESPUESTA TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.INFO_DOC_RESPUESTA to DB_COMERCIAL;

GRANT SELECT  ON db_documento.ADMI_CAB_ENUNCIADO TO DB_COMERCIAL;
GRANT INSERT  ON db_documento.ADMI_CAB_ENUNCIADO TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.ADMI_CAB_ENUNCIADO to DB_COMERCIAL;

GRANT SELECT  ON db_documento.ADMI_ATRIBUTO_ENUNCIADO TO DB_COMERCIAL;
GRANT INSERT  ON db_documento.ADMI_ATRIBUTO_ENUNCIADO TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.ADMI_ATRIBUTO_ENUNCIADO to DB_COMERCIAL;

GRANT SELECT  ON db_documento.ADMI_ENUNCIADO TO DB_COMERCIAL;
GRANT INSERT  ON db_documento.ADMI_ENUNCIADO TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.ADMI_ENUNCIADO to DB_COMERCIAL;

GRANT SELECT  ON db_documento.ADMI_DOCUMENTO_ENUNCIADO TO DB_COMERCIAL;
GRANT INSERT  ON db_documento.ADMI_DOCUMENTO_ENUNCIADO TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.ADMI_DOCUMENTO_ENUNCIADO to DB_COMERCIAL;

GRANT SELECT  ON db_documento.INFO_DOCUMENTO_RELACION_HIST TO DB_COMERCIAL;
GRANT INSERT  ON db_documento.INFO_DOCUMENTO_RELACION_HIST TO DB_COMERCIAL;
GRANT REFERENCES on db_documento.INFO_DOCUMENTO_RELACION_HIST to DB_COMERCIAL;

GRANT SELECT on db_documento.SEQ_INFO_DOCUMENTO_RELACION to DB_COMERCIAL;
GRANT SELECT on db_documento.SEQ_INFO_DOCUMENTO_CARAC to DB_COMERCIAL;
GRANT SELECT on db_documento.SEQ_INFO_DOC_RESPUESTA to DB_COMERCIAL;
GRANT SELECT on db_documento.SEQ_INFO_DOC_RELACION_HIST to DB_COMERCIAL;
/
