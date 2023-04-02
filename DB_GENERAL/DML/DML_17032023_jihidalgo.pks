/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones para modulo pagos Ecuanet
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 17-03-2023 - Versión Inicial.
 */

 INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT A.ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB A WHERE A.NOMBRE_PARAMETRO = 'PROCESO CONTABILIZACION EMPRESA'),
    'DEFINE SI SE HABILITA CONTABILIZACION DE EN',
    'EN',
    'S',
    'MASIVO',
    NULL,
    'Activo',
    'jihidalgo',
    SYSDATE,
    '127.0.0.1',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
);

COMMIT;
/