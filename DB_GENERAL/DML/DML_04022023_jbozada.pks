--Bloque anónimo para crear un nuevo proceso para migración AD
SET SERVEROUTPUT ON
DECLARE
  Ln_IdProceso NUMBER(5,0);
BEGIN
  INSERT
  INTO DB_GENERAL.ADMI_PARAMETRO_CAB
  (
    ID_PARAMETRO,
    NOMBRE_PARAMETRO,
    DESCRIPCION,
    MODULO,
    PROCESO,
    ESTADO,
    USR_CREACION,
    FE_CREACION,
    IP_CREACION,
    USR_ULT_MOD,
    FE_ULT_MOD,
    IP_ULT_MOD
  )
  VALUES
  (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_CAB.NEXTVAL,
    'PARAMETROS_MIGRACION_ALTA_DENSIDAD',
    'Parámetros para la migración de clientes que cambiarán a OLTS alta densidad',
    'TECNICO',
    NULL,
    'Activo',
    'jbozada',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'CANTIDAD_AGRUPAMIENTO_OLT',
    '1',
    'hilosClientes',
    'ProcesandoClientes',
    'Ok',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'ErrorClientes',
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'CANTIDAD_AGRUPAMIENTO_ENLACE',
    '100',
    'hilosEnlaces',
    'ProcesandoEnlaces',
    'Pendiente',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'ErrorEnlaces',
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'CANTIDAD_AGRUPAMIENTO_SCOPE',
    '100',
    'hilosScopes',
    'ProcesandoScopes',
    'Pendiente',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'ErrorScopes',
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'CANTIDAD_AGRUPAMIENTO_SPLITTER',
    '100',
    'hilosSplitters',
    'ProcesandoSplitters',
    'Pendiente',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'ErrorSplitters',
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON-MPLS',
    'DATOS SAFECITY',
    NULL,
    'SI',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON-MPLS',
    'SAFECITYDATOS',
    NULL,
    'SI',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON-MPLS',
    'SAFECITYWIFI',
    NULL,
    'SI',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON-MPLS',
    'SAFECITYSWPOE',
    NULL,
    'NO',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON-MPLS',
    'OTROS',
    'SAFE ANALYTICS CAM',
    'NO',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON',
    'INTERNET',
    NULL,
    'SI',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON',
    'IP',
    NULL,
    'NO',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON',
    'INTERNET SMALL BUSINESS',
    NULL,
    'SI',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON',
    'TELCOHOME',
    NULL,
    'SI',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'NOMBRES_TECNICOS',
    'GPON',
    'IPSB',
    NULL,
    'NO',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'ESTADO_NO_CONSIDERADOS',
    'Anulado',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'ESTADO_NO_CONSIDERADOS',
    'Rechazada',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'ESTADO_NO_CONSIDERADOS',
    'Cancel',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'ESTADO_NO_CONSIDERADOS',
    'Cancelado',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'ESTADO_NO_CONSIDERADOS',
    'Eliminado',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
     FROM DB_GENERAL.ADMI_PARAMETRO_CAB
     WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
     AND estado            ='Activo'
    ),
    'ESTADO_NO_CONSIDERADOS',
    'Trasladado',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '1',
    '402718976',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '2',
    '402784512',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '3',
    '402850048',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '4',
    '402915584',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '5',
    '402981120',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '6',
    '403046656',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '7',
    '403112192',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '8',
    '403177728',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '9',
    '403243264',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '10',
    '403308800',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '11',
    '403374336',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '12',
    '403439872',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '13',
    '403505408',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '14',
    '403570944',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '15',
    '403636480',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '16',
    '403702016',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '17',
    '403767552',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '18',
    '403833088',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '19',
    '403898624',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '20',
    '403964160',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '21',
    '404029696',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '22',
    '404095232',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '23',
    '404160768',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '24',
    '404226304',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '25',
    '404291840',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '26',
    '404357376',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '27',
    '404422912',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '28',
    '404488448',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '29',
    '404553984',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '30',
    '404619520',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '31',
    '404685056',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '32',
    '404750592',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '33',
    '404816128',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '34',
    '404881664',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '35',
    '404947200',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '36',
    '405012736',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '37',
    '405078272',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '38',
    '405143808',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '39',
    '405209344',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '40',
    '405274880',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '41',
    '405340416',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '42',
    '405405952',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '43',
    '405471488',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '44',
    '405537024',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '45',
    '405602560',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '46',
    '405668096',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '47',
    '405733632',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '48',
    '405799168',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '49',
    '405864704',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '50',
    '405930240',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '51',
    '405995776',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '52',
    '406061312',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '53',
    '406126848',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '54',
    '406192384',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '55',
    '406257920',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '56',
    '406323456',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '57',
    '406388992',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '58',
    '406454528',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '59',
    '406520064',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '60',
    '406585600',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '61',
    '406651136',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '62',
    '406716672',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '63',
    '406782208',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '64',
    '406847744',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'SPID-ZTE',
    '100',
    '409207040',
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'ESTADOS_CABECERAS',
    'ProcesandoOlts',
    'OkOlts',
    'ErrorOlts',
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'ESTADOS_CABECERAS',
    'ProcesandoSplitters',
    'OkSplitters',
    'ErrorSplitters',
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'ESTADOS_CABECERAS',
    'ProcesandoEnlaces',
    'OkEnlaces',
    'ErrorEnlaces',
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'ESTADOS_CABECERAS',
    'ProcesandoClientes',
    'OkClientes',
    'ErrorClientes',
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'ESTADOS_CABECERAS',
    'ProcesandoScopes',
    'Migrado',
    'MigradoConErrores',
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'MAXIMA_CANTIDAD_CLIENTES_CON_ERROR',
    '10',
    NULL,
    NULL,
    NULL,
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
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
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT Id_Parametro
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE Nombre_Parametro='PARAMETROS_MIGRACION_ALTA_DENSIDAD'
    AND estado            ='Activo'
    ),
    'DATOS_MW',
    'http://telcos-ws-ext-lb.telconet.ec/middleware-md/ws/process',
    'SI',
    'NO',
    '30',
    'Activo',
    'jbozada',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '18',
    NULL,
    NULL,
    NULL
  );
  
  UPDATE DB_INFRAESTRUCTURA.INFO_ENLACE INFO_E
  SET INFO_E.ESTADO = 'Eliminado'
  WHERE INFO_E.ID_ENLACE IN (
  SELECT IE.id_enlace
    FROM DB_INFRAESTRUCTURA.INFO_ENLACE IE,
      DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEA,
      DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AMEA,
      DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TEA,
      DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IEA,
      DB_INFRAESTRUCTURA.INFO_ELEMENTO ELEB,
      DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AMEB,
      DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TEB,
      DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO IEB
    WHERE IE.INTERFACE_ELEMENTO_INI_ID = IEA.ID_INTERFACE_ELEMENTO
    AND IEA.ELEMENTO_ID                = ELEA.ID_ELEMENTO
    AND ELEA.MODELO_ELEMENTO_ID        = AMEA.ID_MODELO_ELEMENTO
    AND AMEA.TIPO_ELEMENTO_ID          = TEA.ID_TIPO_ELEMENTO
    AND IE.INTERFACE_ELEMENTO_FIN_ID   = IEB.ID_INTERFACE_ELEMENTO
    AND IEB.ELEMENTO_ID                = ELEB.ID_ELEMENTO
    AND ELEB.MODELO_ELEMENTO_ID        = AMEB.ID_MODELO_ELEMENTO
    AND AMEB.TIPO_ELEMENTO_ID          = TEB.ID_TIPO_ELEMENTO
    AND IEA.ESTADO                    !='Eliminado'
    AND ELEA.ESTADO                    = 'Activo'
    AND IE.ESTADO                      = 'Activo'
    AND TEA.NOMBRE_TIPO_ELEMENTO       ='OLT'
    AND TEB.NOMBRE_TIPO_ELEMENTO NOT  IN ('ODF','SPLITTER','CASSETTE'));
  
  COMMIT;
EXCEPTION
WHEN OTHERS THEN
  SYS.DBMS_OUTPUT.PUT_LINE('Error: '|| SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  ROLLBACK;
END;
/
