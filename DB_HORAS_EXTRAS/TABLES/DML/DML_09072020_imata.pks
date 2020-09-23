
 /*
  *Ingreso de parametros de rango de horas extras en la tabla ADMI_TIPO_HORAS_EXTRA
  */


INSERT
INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA VALUES
  (
    DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORAS_EXTRA.NEXTVAL,
    'NOCTURNO',
    '19:00',
    '06:00',
    NULL,
    NULL,
    '25%',
    'Activo',
    '10',
    'imata',
    SYSDATE,
    NULL,
    NULL,
    NULL
  );


INSERT  
INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA VALUES
  (
    DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORAS_EXTRA.NEXTVAL,
    'SIMPLE',
    '18:00',
    '00:00',
    '04:00',
    '12:00',
    '50%',
    'Activo',
    '10',
    'imata',
    SYSDATE,
    NULL,
    NULL,
    NULL
  );
  
  INSERT
INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA VALUES
  (
    DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORAS_EXTRA.NEXTVAL,
    'DOBLES',
    '00:00',
    '06:00',
    NULL,
    NULL,
    '100%',
    'Activo',
    '10',
    'imata',
    SYSDATE,
    NULL,
    NULL,
    NULL
  );

  INSERT
INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA VALUES
  (
    DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORAS_EXTRA.NEXTVAL,
    'HORAS_NO_ESTIMADAS_MATUTINA',
    '06:00',
    '18:00',
    NULL,
    NULL,
    NULL,
    'Activo',
    '10',
    'imata',
    SYSDATE,
    NULL,
    NULL,
    NULL
  );

INSERT
INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA VALUES
  (
    DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORAS_EXTRA.NEXTVAL,
    'HORAS_NO_ESTIMADAS_NOCTURNA',
    '10:00',
    '18:00',
    NULL,
    NULL,
    NULL,
    'Activo',
    '10',
    'imata',
    SYSDATE,
    NULL,
    NULL,
    NULL
  );



  INSERT
INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA VALUES
  (
    DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORAS_EXTRA.NEXTVAL,
    'HORA_FIN_DIA',
    NULL,
    '00:00',
    NULL,
    NULL,
    NULL,
    'Activo',
    '10',
    'imata',
    SYSDATE,
    NULL,
    NULL,
    NULL
  );

INSERT
INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA VALUES
  (
    DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORAS_EXTRA.NEXTVAL,
    'DIALIBRE_DOBLE',
    NULL,
    NULL,
    NULL,
    NULL,
    '100%',
    'Activo',
    '10',
    'imata',
    SYSDATE,
    NULL,
    NULL,
    NULL
  );

COMMIT;

/
