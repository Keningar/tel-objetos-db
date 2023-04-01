 /**
 * Parámetros de las cláusulas de contrato
 *
 * @author Miguel Guzman <mguzman@telconet.ec>
 *
 * @version 1.0
 */
 
 INSERT INTO db_general.admi_parametro_det (
    id_parametro_det,
    parametro_id,
    descripcion,
    valor1,
    valor2,
    valor3,
    valor4,
    valor5,
    valor6,
    valor7,
    estado,
    usr_creacion,
    fe_creacion,
    ip_creacion,
    empresa_cod
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'CONTACTOS FILTRO',
    '4-25-26-27-5',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'Activo',
    'mguzman',
    sysdate,
    '127.0.0.1',
    33
);
           

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
    valor6,
    valor7,
    EMPRESA_COD
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'URL REDIRECCION',
    'http://ecuanet.com.ec/',
    'URL_PORTAL',
    NULL,
    NULL,
    'Activo',
   'jacarrillo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    33
);
--
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
    valor6,
    valor7,
    EMPRESA_COD
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'NUMERO DE INTENTOS',
    '3',
    'LINK_BANCARIO',
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
   33
);
--

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
    valor6,
    valor7,
    EMPRESA_COD
) VALUES (
    db_general.seq_admi_parametro_det.nextval,
    (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    ),
    'CADUCAR CREDENCIALES',
    '<h1> Estimado asesor</h1>
    <p> Las credenciales del cliente {{cliente}} se han caducado.</p>',
    'sistemas-qa@telconet.ec',
    NULL,
    NULL,
    'Activo',
    'jacarrillo',
    sysdate,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
   33
);
 


UPDATE  db_general.admi_parametro_det
SET 
descripcion = 'URL REDIRECCION',
valor1      = 'http://netlife.com.ec/',
valor2      = 'URL_PORTAL',    
USR_ULT_MOD = 'jacarrillo',
FE_ULT_MOD  =  sysdate
WHERE  
    parametro_id = (
        SELECT
            id_parametro
        FROM
            db_general.admi_parametro_cab
        WHERE
            nombre_parametro = 'ACEPTACION_CLAUSULA_CONTRATO'
            AND estado = 'Activo'
    )
AND     descripcion = 'URL NETLIFE'
AND  EMPRESA_COD = 18 ; 
  

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
      WHERE NOMBRE_PARAMETRO='REQUIERE_ACTUALIZAR_PERSONA'
    ),
    'BANDERA QUE VALIDA SI SE DEBE ACTUALIZAR LA PERSONA',
    'S',
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
        
COMMIT;
/