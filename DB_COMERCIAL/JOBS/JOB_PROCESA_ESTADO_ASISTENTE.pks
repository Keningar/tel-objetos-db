BEGIN 
dbms_scheduler.create_job('"JOB_PROCESA_ESTADO_ASISTENTE"',
job_type=>'PLSQL_BLOCK', job_action=>
'DECLARE
  CURSOR C_ASISTENTES
  IS
    SELECT IAS.PERSONA_EMPRESA_ROL_ID_ASIST AS ID_ASISTENTE,
      IAS.PERSONA_EMPRESA_ROL_ID_VEND       AS ID_VENDEDOR,
      IP.ID_PERSONA                         AS ID_PERSONA_VENDEDOR
    FROM DB_COMERCIAL.INFO_ASIGNACION IAS
    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
    ON IPER.ID_PERSONA_ROL=IAS.PERSONA_EMPRESA_ROL_ID_VEND
    JOIN INFO_PERSONA IP
    ON IP.ID_PERSONA                       =IPER.PERSONA_ID
    WHERE IAS.ESTADO                       =''Activo''
    AND IPER.ESTADO                        =''Activo''
    AND IP.ESTADO                          =''Activo''
    AND TO_DATE(IAS.TIEMPO_DIAS,''dd-mm-yy'')=TRUNC(SYSDATE);
  LN_ID_ASISTENTE        NUMBER;
  LN_ID_VENDEDOR         NUMBER;
  LN_ID_PERSONA_VENDEDOR NUMBER;
  LV_MENSAJEERROR        VARCHAR2(4000);
BEGIN
  OPEN C_ASISTENTES;
  LOOP
    FETCH C_ASISTENTES
    INTO LN_ID_ASISTENTE,
      LN_ID_VENDEDOR,
      LN_ID_PERSONA_VENDEDOR;
    EXIT
  WHEN C_ASISTENTES%NOTFOUND;
    --
    DBMS_OUTPUT.PUT_LINE(LN_ID_ASISTENTE || ''|'' || LN_ID_VENDEDOR ||''|''||LN_ID_PERSONA_VENDEDOR);
    UPDATE INFO_PERSONA_EMPRESA_ROL_CARAC
    SET ESTADO                  =''Eliminado'',
      USR_ULT_MOD               =USER,
      FE_ULT_MOD                =SYSDATE
    WHERE PERSONA_EMPRESA_ROL_ID=LN_ID_ASISTENTE
    AND VALOR                   =LN_ID_PERSONA_VENDEDOR;
    --
    UPDATE DB_COMERCIAL.INFO_ASIGNACION
    SET USR_ULT_MOD                   =USER,
      FE_ULT_MOD                      =SYSDATE,
      ESTADO                          =''Eliminado''
    WHERE PERSONA_EMPRESA_ROL_ID_ASIST=LN_ID_ASISTENTE
    AND PERSONA_EMPRESA_ROL_ID_VEND   =LN_ID_VENDEDOR
    AND ESTADO                        =''Activo'';
    COMMIT;
  END LOOP;
  --
  IF C_ASISTENTES%ISOPEN THEN
    CLOSE C_ASISTENTES;
  END IF;
EXCEPTION
  --
WHEN OTHERS THEN
  LV_MENSAJEERROR := ''Error al cambiar de estado los vendedores de los asistentes.'';
  ROLLBACK;
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(''Telcos+'', ''Job_procesa_estado_asistente'', 
                                       LV_MENSAJEERROR || SQLCODE || '' -ERROR- '' || SQLERRM || '' - ERROR_STACK: '' 
                                       || DBMS_UTILITY.FORMAT_ERROR_STACK || '' - ERROR_BACKTRACE: '' 
                                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, NVL(SYS_CONTEXT(''USERENV'',''HOST''), ''DB_COMERCIAL''), 
                                       SYSDATE, NVL(SYS_CONTEXT(''USERENV'',''IP_ADDRESS''), ''127.0.0.1''));
END;
'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('31-DEC-2018 09.18.05.000000000 PM AMERICA/GUAYAQUIL','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN;BYHOUR=0;BYMINUTE=15;BYSECOND=0'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
'Job que se encarga de cambiar el estado a Eliminado cuando en la columa TIEMPO_DIAS de la tabla INFO_ASIGNACION sea igual al sysdate'
);
sys.dbms_scheduler.set_attribute('"JOB_PROCESA_ESTADO_ASISTENTE"','NLS_ENV','NLS_LANGUAGE=''AMERICAN'' NLS_TERRITORY=''AMERICA'' NLS_CURRENCY=''$'' NLS_ISO_CURRENCY=''AMERICA'' NLS_NUMERIC_CHARACTERS=''.,'' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD-MON-RR'' NLS_DATE_LANGUAGE=''AMERICAN'' NLS_SORT=''BINARY'' NLS_TIME_FORMAT=''HH.MI.SSXFF AM'' NLS_TIMESTAMP_FORMAT=''DD-MON-RR HH.MI.SSXFF AM'' NLS_TIME_TZ_FORMAT=''HH.MI.SSXFF AM TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD-MON-RR HH.MI.SSXFF AM TZR'' NLS_DUAL_CURRENCY=''$'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"JOB_PROCESA_ESTADO_ASISTENTE"');
COMMIT; 
END; 
/ 