--
-- DB_DOCUMENTO 
--
ALTER TABLE DB_DOCUMENTO.ADMI_DOCUMENTO ADD  (LLENAR_TODO_DOCUMENTO VARCHAR2(1) DEFAULT 'S' );

COMMENT ON COLUMN DB_DOCUMENTO.ADMI_DOCUMENTO.LLENAR_TODO_DOCUMENTO IS 'CAMPO QUE PERMITE LA VALIDAR SI REQUIERE LLENAR TODAS LAS POLITICAS(S) O NO (N)';
/