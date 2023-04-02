 /**
 * Parámetros de la jurisdicciones con planificacion
 *
 * @author Miguel Guzman <mguzman@telconet.ec>
 *
 * @version 1.0
 */

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_CAB (
  id_parametro,
  nombre_parametro,
  descripcion,
  modulo,
  estado,
  usr_creacion,
  fe_creacion,
  ip_creacion
) VALUES (
  DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.nextval,
  'JURISDICCIONES',
  'VARIABLES CORRESPONDIENTE A JURISDICCIONES',
  'COMERCIAL',
  'Activo',
  'mguzman',
  SYSDATE,
  '127.0.0.1'
);



INSERT  INTO DB_GENERAL.ADMI_PARAMETRO_DET (
  ID_PARAMETRO_DET,
  PARAMETRO_ID,
  DESCRIPCION,
  VALOR1,
  VALOR2,
  VALOR3,
  VALOR4,
  VALOR5,
  OBSERVACION, 
  ESTADO,
  USR_CREACION,
  FE_CREACION,
  IP_CREACION,
  EMPRESA_COD
) VALUES (
  DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (
    SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO='JURISDICCIONES'
      AND estado = 'Activo'
  ),
  'GUAYAQUIL',
  (
    SELECT ID_JURISDICCION FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION
    WHERE NOMBRE_JURISDICCION = 'MEGADATOS GUAYAQUIL'
  ),
  'MEGADATOS GUAYAQUIL',
  NULL,
  NULL,
  NULL,
  'Identificador de la Jurisdiccion MEGADATOS GUAYAQUIL',
  'Activo',
  'mguzman',
  SYSDATE,
  '127.0.0.1',
  '18'
);



INSERT  INTO DB_GENERAL.ADMI_PARAMETRO_DET (
  ID_PARAMETRO_DET,
  PARAMETRO_ID,
  DESCRIPCION,
  VALOR1,
  VALOR2,
  VALOR3,
  VALOR4,
  VALOR5,
  OBSERVACION, 
  ESTADO,
  USR_CREACION,
  FE_CREACION,
  IP_CREACION,
  EMPRESA_COD
) VALUES (
  DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (
    SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO='JURISDICCIONES'
      AND estado = 'Activo'
  ),
  'GUAYAQUIL',
  (
    SELECT ID_JURISDICCION FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION
    WHERE NOMBRE_JURISDICCION = 'ECUANET GUAYAQUIL'
  ),
  'ECUANET GUAYAQUIL',
  NULL,
  NULL,
  NULL,
  'Identificador de la Jurisdiccion ECUANET GUAYAQUIL',
  'Activo',
  'mguzman',
  SYSDATE,
  '127.0.0.1',
  '33'
);



INSERT  INTO DB_GENERAL.ADMI_PARAMETRO_DET (
  ID_PARAMETRO_DET,
  PARAMETRO_ID,
  DESCRIPCION,
  VALOR1,
  VALOR2,
  VALOR3,
  VALOR4,
  VALOR5,
  OBSERVACION, 
  ESTADO,
  USR_CREACION,
  FE_CREACION,
  IP_CREACION,
  EMPRESA_COD
) VALUES (
  DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (
    SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO='JURISDICCIONES'
      AND estado = 'Activo'
  ),
  'QUITO',
  (
    SELECT ID_JURISDICCION FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION
    WHERE NOMBRE_JURISDICCION = 'MEGADATOS QUITO'
  ),
  'MEGADATOS QUITO',
  NULL,
  NULL,
  NULL,
  'Identificador de la Jurisdiccion MEGADATOS QUITO',
  'Activo',
  'mguzman',
  SYSDATE,
  '127.0.0.1',
  '18'
);



INSERT  INTO DB_GENERAL.ADMI_PARAMETRO_DET (
  ID_PARAMETRO_DET,
  PARAMETRO_ID,
  DESCRIPCION,
  VALOR1,
  VALOR2,
  VALOR3,
  VALOR4,
  VALOR5,
  OBSERVACION, 
  ESTADO,
  USR_CREACION,
  FE_CREACION,
  IP_CREACION,
  EMPRESA_COD
) VALUES (
  DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (
    SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO='JURISDICCIONES'
      AND estado = 'Activo'
  ),
  'QUITO',
  (
    SELECT ID_JURISDICCION FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION
    WHERE NOMBRE_JURISDICCION = 'ECUANET QUITO'
  ),
  'ECUANET QUITO',
  NULL,
  NULL,
  NULL,
  'Identificador de la Jurisdiccion ECUANET QUITO',
  'Activo',
  'mguzman',
  SYSDATE,
  '127.0.0.1',
  '33'
);



INSERT  INTO DB_GENERAL.ADMI_PARAMETRO_DET (
  ID_PARAMETRO_DET,
  PARAMETRO_ID,
  DESCRIPCION,
  VALOR1,
  VALOR2,
  VALOR3,
  VALOR4,
  VALOR5,
  OBSERVACION, 
  ESTADO,
  USR_CREACION,
  FE_CREACION,
  IP_CREACION,
  EMPRESA_COD
) VALUES (
  DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (
    SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO='CANT_DIA_MAX_PLANIFICACION'
      AND estado = 'Activo'
  ),
  'CANTIDAD DE DÍA MAXIMO PARA PLANIFICAR',
  '6',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'Activo',
  'mguzman',
  SYSDATE,
  '127.0.0.1',
  '18'
);



INSERT  INTO DB_GENERAL.ADMI_PARAMETRO_DET (
  ID_PARAMETRO_DET,
  PARAMETRO_ID,
  DESCRIPCION,
  VALOR1,
  VALOR2,
  VALOR3,
  VALOR4,
  VALOR5,
  OBSERVACION, 
  ESTADO,
  USR_CREACION,
  FE_CREACION,
  IP_CREACION,
  EMPRESA_COD
) VALUES (
  DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
  (
    SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO='CANT_DIA_MAX_PLANIFICACION'
      AND estado = 'Activo'
  ),
  'CANTIDAD DE DÍA MAXIMO PARA PLANIFICAR',
  '6',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'Activo',
  'mguzman',
  SYSDATE,
  '127.0.0.1',
  '33'
);

/
COMMIT;