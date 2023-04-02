/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Creacion de Parametros para Canal Activa Ecuador Ecuanet
 *
 * @author Javier Hidalgo <jihidalgo@telconet.ec>
 * @version 1.0 04/03/2023
 */
INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADOS_CLIENTE_CONSULTA_PL'),
    'ESTADO_CLIENTE_CONSULTA_SALDOS_PL',
    'Activo',
    'SI',
    NULL,
    NULL,
    'Activo',
    'jihidalgo',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'EN',
    '33',
    NULL,
    NULL,
    'Estado permitido que tiene el cliente para consultar saldos en Bus de Pagos ECUANET',
    NULL,
    NULL
);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'ESTADOS_CLIENTE_CONSULTA_PL'),
    'ESTADO_CLIENTE_CONSULTA_SALDOS_PL',
    'Cancelado',
    'SI',
    NULL,
    NULL,
    'Activo',
    'jihidalgo',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    'EN',
    '33',
    NULL,
    NULL,
    'Estado permitido que tiene el cliente para consultar saldos en Bus de Pagos ECUANET',
    NULL,
    NULL
);

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'LIMITE_SALDO_REACTIVACION'),
    'SE DEFINE POR CUANTO VALOR ES PERMISIBLE PARA ACTIVAR UN CLIENTE ECUANET.',
    'VALOR_PERMISIBLE',
    '1.50',
    NULL,
    NULL,
    'Activo',
    'jihidalgo',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    '33',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL       
);

COMMIT;
/
         
