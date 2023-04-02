SET SERVEROUTPUT ON
--Creación de perfiles equivalentes
DECLARE
  Ln_IdParamMigraPerfilEquiV2 NUMBER(5,0);
BEGIN
  SELECT ID_PARAMETRO
  INTO Ln_IdParamMigraPerfilEquiV2
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO='MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2';--190

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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamMigraPerfilEquiV2,
    'EQUIVALENCIA_PERFIL',
    'EN_PLAN_30M',
    'PERFIL_H_HOME_DEFAULT',
    'EN_PLAN_30M',
    'SI',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '33'
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalles de parámetro MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2 para flujo con EN_PLAN_30M');
  
  
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamMigraPerfilEquiV2,
    'EQUIVALENCIA_PERFIL',
    'EN_PLAN_50M',
    'PERFIL_H_HOME_DEFAULT',
    'EN_PLAN_50M',
    'SI',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '33'
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalles de parámetro MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2 para flujo con EN_PLAN_50M'); 
      
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamMigraPerfilEquiV2,
    'EQUIVALENCIA_PERFIL',
    'EN_PLAN_100M',
    'PERFIL_H_HOME_DEFAULT',
    'EN_PLAN_100M',
    'SI',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '33'
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalles de parámetro MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2 para flujo con EN_PLAN_100M'); 
  
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamMigraPerfilEquiV2,
    'EQUIVALENCIA_PERFIL',
    'EN_PLAN_130M',
    'PERFIL_H_HOME_DEFAULT',
    'EN_PLAN_130M',
    'SI',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '33'
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalles de parámetro MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2 para flujo con EN_PLAN_130M');   
    
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamMigraPerfilEquiV2,
    'EQUIVALENCIA_PERFIL',
    'EN_PLAN_150M',
    'PERFIL_H_HOME_DEFAULT',
    'EN_PLAN_150M',
    'SI',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '33'
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalles de parámetro MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2 para flujo con EN_PLAN_150M');   
    
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamMigraPerfilEquiV2,
    'EQUIVALENCIA_PERFIL',
    'EN_PLAN_200M',
    'PERFIL_H_HOME_DEFAULT',
    'EN_PLAN_200M',
    'SI',
     NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    '33'
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalles de parámetro MIGRA_PLANES_MASIVOS_PERFIL_EQUI_V2 para flujo con EN_PLAN_200M');   
  
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                           || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
  ROLLBACK;
END;
/



--Creación de valores requeridos para el LDAP
DECLARE
  Ln_IdParamPerfilClientPck NUMBER(5,0);
  Ln_IdParamEqPlanesSi NUMBER(5,0);
BEGIN
  
  SELECT ID_PARAMETRO
  INTO Ln_IdParamEqPlanesSi
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO='EQ_NUEVOS_PLANES_SI_ACEPTACION';--135

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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamEqPlanesSi,
    NULL,
    'EN_PLAN_30M',
    'EN_PLAN_30M',
    '38',--package id
    'HOME',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro EQ_NUEVOS_PLANES_SI_ACEPTACION para EN_PLAN_30M');
  
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamEqPlanesSi,
    NULL,
    'EN_PLAN_50M',
    'EN_PLAN_50M',
    '38',--package id
    'HOME',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro EQ_NUEVOS_PLANES_SI_ACEPTACION para EN_PLAN_50M');
  
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamEqPlanesSi,
    NULL,
    'EN_PLAN_100M',
    'EN_PLAN_100M',
    '38',--package id
    'HOME',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro EQ_NUEVOS_PLANES_SI_ACEPTACION para EN_PLAN_100M');
  
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamEqPlanesSi,
    NULL,
    'EN_PLAN_130M',
    'EN_PLAN_130M',
    '38',--package id
    'HOME',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro EQ_NUEVOS_PLANES_SI_ACEPTACION para EN_PLAN_130M');
  
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamEqPlanesSi,
    NULL,
    'EN_PLAN_150M',
    'EN_PLAN_150M',
    '38',--package id
    'HOME',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro EQ_NUEVOS_PLANES_SI_ACEPTACION para EN_PLAN_150M');
  
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
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamEqPlanesSi,
    NULL,
    'EN_PLAN_200M',
    'EN_PLAN_200M',
    '38',--package id
    'HOME',
    NULL,
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro EQ_NUEVOS_PLANES_SI_ACEPTACION para EN_PLAN_200M');
  
  
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                           || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
  ROLLBACK;
END;
/
  

--Creación de valores requeridos para el LDAP
DECLARE
  Ln_IdParamPerfilClientPck NUMBER(5,0);
BEGIN
  SELECT ID_PARAMETRO
  INTO Ln_IdParamPerfilClientPck
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO='CNR_PERFIL_CLIENT_PCK';
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamPerfilClientPck,
    'EN_PLAN_30M',
    'EN_PLAN_30M',--detalle valor del olt, perfil jar
    'EN_PLAN_30M',--valor del perfil equivalente
    '38',--package id
    'EN_PLAN_30M',--client class
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SI',
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro CNR_PERFIL_CLIENT_PCK para EN_PLAN_30M');
  
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamPerfilClientPck,
    'EN_PLAN_50M',
    'EN_PLAN_50M',--detalle valor del olt, perfil jar
    'EN_PLAN_50M',--valor del perfil equivalente
    '38',--package id
    'EN_PLAN_50M',--client class
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SI',
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro CNR_PERFIL_CLIENT_PCK para EN_PLAN_50M');
  
  
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamPerfilClientPck,
    'EN_PLAN_100M',
    'EN_PLAN_100M',--detalle valor del olt, perfil jar
    'EN_PLAN_100M',--valor del perfil equivalente
    '38',--package id
    'EN_PLAN_100M',--client class
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SI',
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro CNR_PERFIL_CLIENT_PCK para EN_PLAN_100M');
    
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamPerfilClientPck,
    'EN_PLAN_130M',
    'EN_PLAN_130M',--detalle valor del olt, perfil jar
    'EN_PLAN_130M',--valor del perfil equivalente
    '38',--package id
    'EN_PLAN_130M',--client class
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SI',
    NULL
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro CNR_PERFIL_CLIENT_PCK para EN_PLAN_130M');
  
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamPerfilClientPck,
    'EN_PLAN_150M',
    'EN_PLAN_150M',--detalle valor del olt, perfil jar
    'EN_PLAN_150M',--valor del perfil equivalente
    '38',--package id
    'EN_PLAN_150M',--client class
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SI',
    NULL
  );
   SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro CNR_PERFIL_CLIENT_PCK para EN_PLAN_150M');

  
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
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD,
    VALOR5,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamPerfilClientPck,
    'EN_PLAN_200M',
    'EN_PLAN_200M',--detalle valor del olt, perfil jar
    'EN_PLAN_200M',--valor del perfil equivalente
    '38',--package id
    'EN_PLAN_200M',--client class
    'Activo',
    'jpiloso',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'SI',
    NULL
  );
   SYS.DBMS_OUTPUT.PUT_LINE('Detalle de parámetro CNR_PERFIL_CLIENT_PCK para EN_PLAN_200M');
  

  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                           || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
  ROLLBACK;
END;
/

