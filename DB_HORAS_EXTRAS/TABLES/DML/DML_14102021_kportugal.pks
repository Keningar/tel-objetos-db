DECLARE
  n_exists NUMBER := 0;
BEGIN
 
 UPDATE DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATH SET ATH.TOTAL_HORAS_DIA ='8' WHERE ATH.TIPO_HORAS_EXTRA = 'NOCTURNO';
 UPDATE DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATH SET ATH.HORA_FIN ='23:59' WHERE ATH.TIPO_HORAS_EXTRA = 'HORA_FIN_DIA';
 UPDATE DB_HORAS_EXTRAS.ADMI_TIPO_HORAS_EXTRA ATH SET ATH.HORA_INICIO ='06:00' WHERE ATH.TIPO_HORAS_EXTRA = 'SIMPLE';


    SELECT COUNT(*)  
    into n_exists
    FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS
    WHERE NOMBRE_TIPO_HORARIO ='LINEA BASE';
	
  IF n_exists = 0 THEN
    INSERT
    INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS VALUES
      (
        DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORARIOS.NEXTVAL,
        'LINEA BASE',
        'Activo',
        SYSDATE,
        'kportugal',
        NULL,
        NULL,
        NULL
      );
  END IF;
  
    SELECT count(*)  
    into n_exists
    FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS
    WHERE NOMBRE_TIPO_HORARIO ='TEMPORAL';
    
  IF n_exists = 0 THEN
    INSERT
    INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS VALUES
      (
        DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORARIOS.NEXTVAL,
         'TEMPORAL',
        'Activo',
        SYSDATE,
        'kportugal',
        NULL,
        NULL,
        NULL
      );
  END IF;
  
  
    SELECT count(*) 
    into n_exists
    FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS
    WHERE NOMBRE_TIPO_HORARIO ='CANJE';
	
  IF n_exists =0 THEN
    INSERT
    INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS VALUES
      (
        DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORARIOS.NEXTVAL,
         'CANJE',
        'Activo',
        SYSDATE,
        'kportugal',
        NULL,
        NULL,
        NULL
      );
  END IF;
  
  
    SELECT count(*) 
    into n_exists
    FROM DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS
    WHERE NOMBRE_TIPO_HORARIO ='REEMPLAZO JORNADA';
  
  IF n_exists = 0 THEN
    INSERT
    INTO DB_HORAS_EXTRAS.ADMI_TIPO_HORARIOS VALUES
      (
        DB_HORAS_EXTRAS.SEQ_ADMI_TIPO_HORARIOS.NEXTVAL,
         'REEMPLAZO JORNADA',
        'Activo',
        SYSDATE,
        'kportugal',
        NULL,
        NULL,
        NULL
      );
  END IF;

  SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='TOTAL DE HORAS EXTRAS';
	
  IF n_exists = 0 THEN
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
          'TOTAL DE HORAS EXTRAS',
          'NUMERO TOTAL DE HORAS EXTRAS PARA GENERAR SOLICITUD DESDE UNA TAREA TIPO PROCESO HORAS EXTRAS',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
  
    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='NUMERO TOTAL DE HORAS EXTRAS PARA GENERAR SOLICITUD DESDE UNA TAREA TIPO PROCESO HORAS EXTRAS';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='TOTAL DE HORAS EXTRAS'
        ),
        'NUMERO TOTAL DE HORAS EXTRAS PARA GENERAR SOLICITUD DESDE UNA TAREA TIPO PROCESO HORAS EXTRAS',
        '11',
        null,
        null,
        null,
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;
  
  SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='ESTADO DEPARTAMENTOS_ADMINISTRATIVA';
	
  IF n_exists = 0 THEN
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
          'ESTADO DEPARTAMENTOS_ADMINISTRATIVA',
          'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS ADMINISTRATIVA',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
  
    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS ADMINISTRATIVA';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='ESTADO DEPARTAMENTOS_ADMINISTRATIVA'
        ),
        'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS ADMINISTRATIVA',
        'Verificacion',
        null,
        null,
        null,
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;

        
  SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='ESTADO DEPARTAMENTOS TECNICA';
	
  IF n_exists = 0 THEN
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
          'ESTADO DEPARTAMENTOS TECNICA',
          'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS TECNICA',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
  
    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS TECNICA';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='ESTADO DEPARTAMENTOS TECNICA'
        ),
        'ESTADO A GENERARSE LAS SOLICITUDES DE LOS DEPARTAMENTOS TECNICA',
        'Verificacion',
        null,
        null,
        null,
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;

   SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='ESTADO TAREA PROCESO HE';
	
  IF n_exists = 0 THEN
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
          'ESTADO TAREA PROCESO HE',
          'ESTADO A GENERARSE LAS SOLICITUDES DE LAS TAREAS PROCESO HE',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
  
    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='ESTADO A GENERARSE LAS SOLICITUDES DE LAS TAREAS PROCESO HE';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='ESTADO TAREA PROCESO HE'
        ),
        'ESTADO A GENERARSE LAS SOLICITUDES DE LAS TAREAS PROCESO HE',
        'Verificacion',
        null,
        null,
        null,
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;

  SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='NUMERO DIAS PARA BARRIDO TAREAS';
	
  IF n_exists = 0 THEN
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
          'NUMERO DIAS PARA BARRIDO TAREAS',
          'NUMERO DIAS PARA BARRIDO TAREAS',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
  
    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='NUMERO DIAS PARA BARRIDO TAREAS';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='NUMERO DIAS PARA BARRIDO TAREAS'
        ),
        'NUMERO DIAS PARA BARRIDO TAREAS',
        '7',
        null,
        null,
        null,
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;

   SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='DEPARTAMENTOS_TECNICA';
	
  IF n_exists = 0 THEN
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
          'DEPARTAMENTOS_TECNICA',
          'DEP. TEC. (ATENCION AL USUARIO) PARA JOB BARRIDO DE TAREA Y GENERACION DE HE AUTORIZADAS',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
      
  SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='DEPARTAMENTOS_ADMINISTRATIVA';
	
  IF n_exists = 0 THEN
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
          'DEPARTAMENTOS_ADMINISTRATIVA',
          'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
  
    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='DEPARTAMENTOS_ADMINISTRATIVA'
        ),
        'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS',
        'HELP DESK',
        null,
        null,
        null,
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;

  SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='DEPARTAMENTOS_ADMINISTRATIVA'
        ),
        'DEP. ADM. (ATENCION INTERNA) PARA JOB BARRIDO DE TAREA Y GENERACION DE HORAS EXTRAS',
        'GERENCIA TECNICA NACIONAL',
        null,
        null,
        null,
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;

 SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='DEP_APLICA_FERIADOS';
	
  IF n_exists = 0 THEN
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
          'DEP_APLICA_FERIADOS',
          'DEP. QUE SE LE PAGAN FERIADOS TIPO SOLICITUD DOBLE',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
  
    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='DEP. QUE SE LE PAGAN FERIADOS TIPO SOLICITUD DOBLE';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='DEP_APLICA_FERIADOS'
        ),
        'DEP. QUE SE LE PAGAN FERIADOS TIPO SOLICITUD DOBLE',
        'SISTEMAS',
        null,
        null,
        null,
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;
  

    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_Cab
    WHERE nombre_parametro='DASHBOARD PORTAL HORAS EXTRAS';
	
  IF n_exists = 0 THEN
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
          'DASHBOARD PORTAL HORAS EXTRAS',
          'TOTAL MAX HORAS,NUMERO DE REG,ESTADO A GENERAR LA SOLICITUD,NUM MES A RESTAR AL SYSDATE',
          'HORAS_EXTRA',
          'Activo',
          'kportugal',
          sysdate,
          '127.0.0.1'
      );
  END IF;
  
  
    SELECT count(*)  
    into n_exists
    FROM db_general.admi_parametro_det
    WHERE DESCRIPCION='TOTAL MAX HORAS,NUMERO DE REG,ESTADO A GENERAR LA SOLICITUD,NUM MES A RESTAR AL SYSDATE';
  
  IF n_exists = 0 THEN
    INSERT
    INTO db_general.admi_parametro_det
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
        EMPRESA_COD,
        VALOR6,
        VALOR7,
        OBSERVACION
      )
      VALUES
      (
        db_general.seq_admi_parametro_det.nextval,
        (SELECT ID_PARAMETRO
        FROM db_general.admi_parametro_Cab
        WHERE nombre_parametro='DASHBOARD PORTAL HORAS EXTRAS'
        ),
        'TOTAL MAX HORAS,NUMERO DE REG,ESTADO A GENERAR LA SOLICITUD,NUM MES A RESTAR AL SYSDATE',
        '40',
        '3',
        'Verificacion',
        '1',
        'Activo',
        'kportugal',
        sysdate,
        '127.0.0.1',
        NULL,
        NULL,
        NULL,
        NULL,
        '10',
        NULL,
        NULL,
        NULL
      );
      END IF;


    SELECT count(*) 
    into n_exists
    FROM DB_SOPORTE.ADMI_PROCESO
    WHERE NOMBRE_PROCESO='TAREAS DE HORAS EXTRA';

  IF n_exists = 0 THEN
    INSERT 
    INTO DB_SOPORTE.ADMI_PROCESO
    (
      ID_PROCESO,
      PROCESO_PADRE_ID,
      NOMBRE_PROCESO,
      DESCRIPCION_PROCESO,
      APLICA_ESTADO,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      USR_ULT_MOD,
      FE_ULT_MOD,
      VISIBLE,
      PLANMANTENIMIENTO
    )
    VALUES
    (
      DB_SOPORTE.SEQ_ADMI_PROCESO.NEXTVAL,
      NULL,
      'TAREAS DE HORAS EXTRA',
      'TAREAS DE HORAS EXTRA',
      NULL,
      'Activo',
      'kportugal',
      SYSDATE,
      'kportugal',
      SYSDATE,
      'SI',
      NULL
    );
      END IF;

    SELECT count(*) 
    into n_exists
    FROM DB_SOPORTE.ADMI_PROCESO_EMPRESA
    WHERE PROCESO_ID =(SELECT ID_PROCESO FROM DB_SOPORTE.ADMI_PROCESO WHERE NOMBRE_PROCESO='TAREAS DE HORAS EXTRA' AND ESTADO='Activo');
  
  IF n_exists = 0 THEN
    INSERT 
  INTO DB_SOPORTE.ADMI_PROCESO_EMPRESA
  (
   ID_PROCESO_EMPRESA,
   PROCESO_ID,
   EMPRESA_COD,
   ESTADO,
   USR_CREACION,
   FE_CREACION
  )
  VALUES
  (
  DB_SOPORTE.SEQ_ADMI_PROCESO_EMPRESA.NEXTVAL,
  (SELECT ID_PROCESO FROM DB_SOPORTE.ADMI_PROCESO WHERE NOMBRE_PROCESO='TAREAS DE HORAS EXTRA' AND ESTADO='Activo'),
  '10',
  'Activo',
  'kportugal',
  SYSDATE
  );
      END IF;

    SELECT count(*)  
    into n_exists
    FROM DB_SOPORTE.ADMI_TAREA
    WHERE PROCESO_ID =(SELECT ID_PROCESO FROM DB_SOPORTE.ADMI_PROCESO WHERE NOMBRE_PROCESO='TAREAS DE HORAS EXTRA' AND ESTADO='Activo');

  IF n_exists = 0 THEN
    INSERT
      INTO DB_SOPORTE.ADMI_TAREA
        (
          ID_TAREA,
          PROCESO_ID,
          ROL_AUTORIZA_ID,
          TAREA_ANTERIOR_ID,
          TAREA_SIGUIENTE_ID,
          PESO,
          ES_APROBADA,
          NOMBRE_TAREA,
          DESCRIPCION_TAREA,
          TIEMPO_MAX,
          UNIDAD_MEDIDA_TIEMPO,
          COSTO,
          PRECIO_PROMEDIO,
          ESTADO,
          USR_CREACION,
          FE_CREACION,
          USR_ULT_MOD,
          FE_ULT_MOD,
          AUTOMATICA_WS,
          CATEGORIA_TAREA_ID,
          PRIORIDAD,
          REQUIERE_FIBRA,
          VISUALIZAR_MOVIL
        )
        VALUES
        (
          DB_SOPORTE.SEQ_ADMI_TAREA.NEXTVAL,
          (SELECT ID_PROCESO
          FROM DB_SOPORTE.ADMI_PROCESO
          WHERE NOMBRE_PROCESO='TAREAS DE HORAS EXTRA'
          AND ESTADO          ='Activo'
          ),
          NULL,
          NULL,
          NULL,
          NULL,
          NULL,
          'REGISTRO DE HORAS EXTRAS',
          'REGISTRO DE TAREAS TIPO HORAS EXTRAS',
          NULL,
          NULL,
          NULL,
          NULL,
          'Activo',
          'kportugal',
          sysdate,
          'kportugal',
          sysdate,
          NULL,
          NULL,
          NULL,
          NULL,
          NULL
        );
      END IF;


      COMMIT;
END;

