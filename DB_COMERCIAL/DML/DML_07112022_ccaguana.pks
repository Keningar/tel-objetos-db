           
 /**
 * Insert de parámetros de las cláusulas de contrato
 *
 * @author Carlos Caguana <ccaguana@telconet.ec>
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
    'ccaguana',
    sysdate,
    '127.0.0.1',
    18
);
           
   
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
    'REQUIERE_ACTUALIZAR_PERSONA',
    'BANDERA QUE VALIDA SI SE DEBE ACTUALIZAR LA PERSONA',
    'Activo',
    'wgaibor',
    CURRENT_TIMESTAMP,
    '127.0.0.1'
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
    'wgaibor',
    SYSDATE,
    '127.0.0.1',
    '18'
  );
        
COMMIT;
/