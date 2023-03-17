/**
 * Creacion de los parametros para el consumo del WS de Networking
 * para el proceso de Migracion de los OLTs
 *
 * @author Leonardo Mero <lemero@telconet.ec>
 * @version 1.0 08-03-2022
 */


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
    (SELECT ID_PARAMETRO
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'MIGRACION_OLT_PARAMETROS'
    AND MODULO             = 'TECNICO'
    AND ESTADO             = 'Activo'
    ),
    'Parametros Consumo NW',
    'prod', -- Ambiente
    'GENERAL', --Servicio
    'Cancelar', -- Accion 
    'http://ws-tecnico.telconet.ec/ws/telcos/olt/setupPE', -- URL
    'eliminar', -- Accion 2
    'http://ws-tecnico.telconet.ec/ws/telcos/olt/deleteResources', -- URL 2
    'Activo',
    'lemero',
    SYSDATE,
    '127.0.0.1',
    '10'
  );


COMMIT;
/