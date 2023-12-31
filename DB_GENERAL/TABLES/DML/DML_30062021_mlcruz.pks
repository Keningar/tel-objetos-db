SET SERVEROUTPUT ON
DECLARE
  Ln_IdParamEarthRadius NUMBER(5,0);
BEGIN
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
      'EARTH_RADIUS_DISTANCIA_COORDENADAS',
      'Valor del Earth Radius usado para el cálculo de la distancia entre coordenadas',
      'Activo',
      'mlcruz',
      CURRENT_TIMESTAMP,
      '127.0.0.1'
    );
  SELECT ID_PARAMETRO
  INTO Ln_IdParamEarthRadius
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO='EARTH_RADIUS_DISTANCIA_COORDENADAS'
  AND ESTADO            = 'Activo';
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
      VALOR6,
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
      Ln_IdParamEarthRadius,
      'Valor1: Valor del Earth Radius',
      '6371000',
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      'Activo',
      'mlcruz',
      sysdate,
      '127.0.0.1',
      NULL,
      NULL,
      NULL,
      NULL
    );
  SYS.DBMS_OUTPUT.PUT_LINE('Se creó correctamente el parámetro para el Earth Radius');
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                           || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
END;
/
DECLARE
  Ln_IdParamsServiciosMd    NUMBER;
BEGIN
  SELECT ID_PARAMETRO
  INTO Ln_IdParamsServiciosMd
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB
  WHERE NOMBRE_PARAMETRO='PARAMETROS_ASOCIADOS_A_SERVICIOS_MD';

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
    Ln_IdParamsServiciosMd,
    'Valor3: Tipo de elemento conector',
    'PROCESO_PREFACTIBILIDAD',
    'PARAMS_CONSULTA',
    'SPLITTER',
    NULL,
    NULL,
    'Activo',
    'mlcruz',
    sysdate,
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
    VALOR6,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    EMPRESA_COD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    Ln_IdParamsServiciosMd,
    'Valor3:Dist max. cobert,Valor4:Dist max. factib,Valor5-Valor6:# max. cajas-conectores Cobert-Factib',
    'PROCESO_PREFACTIBILIDAD',
    'CONFIG_RESPONSE',
    '500',
    '250',
    '1',
    '3',
    'Activo',
    'mlcruz',
    sysdate,
    '127.0.0.1',
    '18'
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Se han ingresado correctamente los parámetros de PARAMETROS_ASOCIADOS_A_SERVICIOS_MD');
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                           || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
END;
/

INSERT
INTO DB_GENERAL.ADMI_TIPO_ROL
( 
  ID_TIPO_ROL,
  DESCRIPCION_TIPO_ROL,
  ESTADO,
  USR_CREACION,
  FE_CREACION
)
VALUES
(
  DB_GENERAL.SEQ_ADMI_TIPO_ROL.NEXTVAL,
  'PreFactibilidad',
  'Activo',
  'mlcruz',
  SYSDATE
);
INSERT
INTO DB_GENERAL.ADMI_ROL
( 
  ID_ROL,
  TIPO_ROL_ID,
  DESCRIPCION_ROL,
  ESTADO,
  USR_CREACION,
  FE_CREACION
)
VALUES
(
  DB_GENERAL.SEQ_ADMI_ROL.NEXTVAL,
  (SELECT ID_TIPO_ROL FROM DB_GENERAL.ADMI_TIPO_ROL WHERE DESCRIPCION_TIPO_ROL = 'PreFactibilidad'),
  'Prospecto PreFactibilidad',
  'Activo',
  'mlcruz',
  SYSDATE
);
INSERT
INTO DB_COMERCIAL.INFO_EMPRESA_ROL
( 
  ID_EMPRESA_ROL,
  EMPRESA_COD,
  ROL_ID,
  ESTADO,
  USR_CREACION,
  FE_CREACION,
  IP_CREACION
)
VALUES
(
  DB_COMERCIAL.SEQ_INFO_EMPRESA_ROL.NEXTVAL,
  '18',
  (SELECT ID_ROL FROM DB_GENERAL.ADMI_ROL WHERE DESCRIPCION_ROL = 'Prospecto PreFactibilidad'),
  'Activo',
  'mlcruz',
  SYSDATE,
  '127.0.0.1'
);

INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'IDENTIFICACION_PERSONA_CONSULTA_PREFACTIBILIDAD',
  'S',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar la identificación de la persona que desea consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'CANAL_CONSULTA_PREFACTIBILIDAD',
  'S',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar el canal al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'LATITUD_CONSULTA_PREFACTIBILIDAD',
  'N',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar la latitud al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'LONGITUD_CONSULTA_PREFACTIBILIDAD',
  'N',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar la longitud al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'ID_PUNTO_COBERTURA_CONSULTA_PREFACTIBILIDAD',
  'N',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar el id del punto de cobertura al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'ID_CANTON_CONSULTA_PREFACTIBILIDAD',
  'N',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar el id del canton al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'ID_PARROQUIA_CONSULTA_PREFACTIBILIDAD',
  'N',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar el id de la parroquia al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'ID_SECTOR_CONSULTA_PREFACTIBILIDAD',
  'N',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar el id del sector al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'NOVEDAD_CONSULTA_PREFACTIBILIDAD',
  'S',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar la novedad ya sea Caja o Puertos al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'ID_CAJA_MAS_CERCANA_CONSULTA_PREFACTIBILIDAD',
  'N',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar el id de la caja más cercana a las coordenadas ingresadas al consultar la preFactibilidad'
);
INSERT
INTO DB_COMERCIAL.ADMI_CARACTERISTICA
( 
  ID_CARACTERISTICA,
  DESCRIPCION_CARACTERISTICA,
  TIPO_INGRESO,
  ESTADO,
  FE_CREACION,
  USR_CREACION,
  TIPO,
  DETALLE_CARACTERISTICA
)
VALUES
(
  DB_COMERCIAL.SEQ_ADMI_CARACTERISTICA.NEXTVAL,
  'DISTANCIA_CAJA_MAS_CERCANA_CONSULTA_PREFACTIBILIDAD',
  'N',
  'Activo',
  SYSDATE,
  'mlcruz',
  'COMERCIAL',
  'Usada para guardar la distancia en metros de la caja más cercana hacia las coordenadas ingresadas al consultar la preFactibilidad'
);
COMMIT;
/