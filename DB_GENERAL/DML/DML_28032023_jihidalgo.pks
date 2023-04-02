/**
 * DEBE EJECUTARSE EN DB_GENERAL.
 * Parametrizaciones para modulo pagos Ecuanet
 * @author Javier Hidalgo Fernández <jihidalgo@telconet.ec>
 * @version 1.0 28-03-2023 - Versión Inicial.
 */

INSERT INTO DB_GENERAL.ADMI_PARAMETRO_DET VALUES (
    DB_GENERAL.SEQ_ADMI_PARAMETRO_DET.NEXTVAL,
    (SELECT A.ID_PARAMETRO FROM db_general.admi_parametro_cab A WHERE A.nombre_parametro = 'NUMERO_DE_DIAS_ANULAR_PAGOS'),
    'PARAMETRO DONDE SE CONFIGURA EL NUMERO DE DIAS MAXIMO PERMISIBLE PARA ANULAR LOS PAGOS DE EN',
    'NUMERO_DIAS_AP',
    '90',
    NULL,
    'EN',
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