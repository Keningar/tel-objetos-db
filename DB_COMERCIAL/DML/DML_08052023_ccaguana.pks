           
 /**
 * Insert de parámetros 
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
 *
 * @version 1.0
 */

   
INSERT
INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'FIRMAS_CONTRATO',
    'PARAMETROS DE FIRMAS',
    'Activo',
    'ccaguana',
    CURRENT_TIMESTAMP,
    '127.0.0.1'
  );
  

INSERT
  INTO DB_GENERAL.ADMI_PARAMETRO_DET
  ( 
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO'
    ),
    'contratoMegadatos',
    'FIRMA_CONT_MD_FINAL_EMPRESA',
    '{"llx":"-150","lly":"-50","urx":"100","ury":"60","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '18'
  );


INSERT
  INTO DB_GENERAL.ADMI_PARAMETRO_DET
  ( 
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO'
    ),
    'adendumMegaDatos',
    'FIRMA_ADEN_MD_EMPRESA',
    '{"llx":"-120","lly":"-55","urx":"100","ury":"40","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '18'
  );
       

INSERT
  INTO DB_GENERAL.ADMI_PARAMETRO_DET
  ( 
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO'
    ),
    'contratoSecurityData',
    'FIRMA_CONT_SD_EMPRESA',
    '{"llx":"-170","lly":"30","urx":"100","ury":"60","pagina":"3","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
    NULL,
    NULL,
    NULL,
    'Inactivo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '18'
  );
   
  
  INSERT
  INTO DB_GENERAL.ADMI_PARAMETRO_DET
  ( 
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO'
    ),
    'terminosCondicionesMegadatos',
    'FIRMA_TERMINOS_MD_EMPRESA',
    '{"llx":"-120","lly":"-55","urx":"100","ury":"40","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
    NULL,
    NULL,
    NULL,
    'Activo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '18'
  );
   





   INSERT
  INTO DB_GENERAL.ADMI_PARAMETRO_DET
  ( 
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO'
    ),
    'contratoSecurityData',
    'FIRMA_CONT_SD_EMPRESA',
    '{"llx":"-170","lly":"30","urx":"100","ury":"60","pagina":"3","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
    NULL,
    NULL,
    NULL,
    'Inactivo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '33'
  );
   



INSERT
  INTO DB_GENERAL.ADMI_PARAMETRO_DET
  ( 
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO'
    ),
    'contratoEcuanet',
    'FIRMA_CONT_MD_FINAL_EMPRESA',
    '{"llx":"-150","lly":"-50","urx":"100","ury":"60","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
    NULL,
    NULL,
    NULL,
    'Activo',
   'Inactivo',
    SYSDATE,
    '127.0.0.1',
    '33'
  );



INSERT
  INTO DB_GENERAL.ADMI_PARAMETRO_DET
  ( 
    ID_PARAMETRO_DET,
    PARAMETRO_ID,
    DESCRIPCION,
    VALOR1,
    VALOR2,
    VALOR3,
    VALOR4,
    VALOR5,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (
      SELECT ID_PARAMETRO
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB
      WHERE NOMBRE_PARAMETRO='FIRMAS_CONTRATO'
    ),
    'adendumEcuanet',
    'FIRMA_ADEN_MD_EMPRESA',
    '{"llx":"-120","lly":"-55","urx":"100","ury":"40","pagina":"2","textSignature":"","modoPresentacion":"1", "firma":"SI"}',
    NULL,
    NULL,
    NULL,
    'Inactivo',
    'ccaguana',
    SYSDATE,
    '127.0.0.1',
    '33'
  );
       
        
COMMIT;
/