

INSERT INTO db_general.admi_parametro_cab (
    id_parametro,
    nombre_parametro,
    descripcion,
    modulo,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion
  ) VALUES (
      db_general.seq_admi_parametro_cab.nextval,
      'PLANIFICACION_COMERCIAL_HAL',
      'VARIABLES CORRESPONDIENTE A PLANIFICACION COMERCIAL AUTOMATICA',
      'COMERCIAL',
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1'
  );



/

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'PLANIFICACION_COMERCIAL_HAL'
              AND estado = 'Activo'
      ),
      'MAXIMO DE DIAS VISUALIZAR PLANIFICACION',
      '6',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );



/


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'PLANIFICACION_COMERCIAL_HAL'
              AND estado = 'Activo'
      ),
      'DIA INICIO DE PLANIFICACION',
      '1',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );




/

  INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'PLANIFICACION_COMERCIAL_HAL'
              AND estado = 'Activo'
      ),
      'MIN HORAS PLANIFICACION COMERCIAL',
      '00:00',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );



/
  INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'PLANIFICACION_COMERCIAL_HAL'
              AND estado = 'Activo'
      ),
      'MAX HORAS PLANIFICACION COMERCIAL',
      '23:59',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );


/

  INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'PLANIFICACION_COMERCIAL_HAL'
              AND estado = 'Activo'
      ),
      'INCREMENT MIN DE LAS HORAS PLANIFICACION COMERCIAL',
      '15',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );





/


INSERT INTO db_general.admi_parametro_cab (
    id_parametro,
    nombre_parametro,
    descripcion,
    modulo,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion
  ) VALUES (
      db_general.seq_admi_parametro_cab.nextval,
      'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO',
      'Estados no permitidos de un punto para la agregacion de servicios .',
      'COMERCIAL',
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1'
  );



/


  INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO'
              AND estado = 'Activo'
      ),
     'Estado del servicio de internet no permitido para agregacion de servicio.',
     'Eliminado',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );



/

  INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO'
              AND estado = 'Activo'
      ),
     'Estado del servicio de internet no permitido para agregacion de servicio.',
     'Anulado',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );



/

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO'
              AND estado = 'Activo'
      ),
     'Estado del servicio de internet no permitido para agregacion de servicio.',
     'Cancelado',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );



/


INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO'
              AND estado = 'Activo'
      ),
     'Estado del servicio de internet no permitido para agregacion de servicio.',
     'Rechazada',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );



/

INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO'
              AND estado = 'Activo'
      ),
     'Estado del punto no permitido para agregacion de servicio.',
     'Anulado',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );



/

  INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO'
              AND estado = 'Activo'
      ),
     'Estado del punto no permitido para agregacion de servicio.',
     'Eliminado',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );

/
INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO'
              AND estado = 'Activo'
      ),
     'Estado del punto no permitido para agregacion de servicio.',
     'Cancel',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );


/

  INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    valor5,
    EMPRESA_COD,
    valor6,
    valor7
  ) VALUES (
      db_general.seq_admi_parametro_det.nextval,
      (
          SELECT
              id_parametro
          FROM
              db_general.admi_parametro_cab
          WHERE
              nombre_parametro = 'ESTADOS_RESTRICCION_PUNTO_ADDSERVICIO'
              AND estado = 'Activo'
      ),
     'Estado del punto no permitido para agregacion de servicio.',
     'Cancelado',
      NULL,
      NULL,
      NULL,
      'Activo',
      'ccaguana',
      sysdate,
      '127.0.0.1',
      NULL,
      '18',
      NULL,
      NULL
  );

/

  UPDATE  DB_GENERAL.admi_parametro_det       
  SET VALOR1 ='FO-VEN-01', VALOR2 ='ver-08 | Dic-2021',USR_ULT_MOD='ccaguana',FE_ULT_MOD = SYSDATE
  WHERE PARAMETRO_ID  in (SELECT id_parametro FROM db_general.admi_parametro_cab WHERE nombre_parametro = 'DOC_VERSION_CONTRATO_DIGITAL' AND estado = 'Activo')
  AND DESCRIPCION  = 'adendumMegaDatos';    

/

  UPDATE  DB_GENERAL.admi_parametro_det       
  SET VALOR1 ='FO-VEN-01',USR_ULT_MOD='ccaguana',FE_ULT_MOD = SYSDATE
  WHERE PARAMETRO_ID  in (SELECT id_parametro FROM db_general.admi_parametro_cab WHERE nombre_parametro = 'DOC_VERSION_CONTRATO_DIGITAL' AND estado = 'Activo')
  AND DESCRIPCION  = 'terminosCondicionesMegadatos';        

/

commit;
/