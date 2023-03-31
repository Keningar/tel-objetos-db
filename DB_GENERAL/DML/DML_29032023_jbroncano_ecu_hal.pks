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
              nombre_parametro = 'PROGRAMAR_MOTIVO_HAL'
              AND estado = 'Activo'
      ),
      'ID MOTIVOS HAL PROGRAMAR',
      '2577,2576',
      NULL,
      NULL,
      NULL,
      'Activo',
      'wgaibor',
      sysdate,
      '127.0.0.1',
      NULL,
      '33',
      NULL,
      NULL
  );


  commit;
  /
  