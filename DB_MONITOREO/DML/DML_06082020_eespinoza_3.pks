/**
 * Insert de motivos por definidos para tabla DB_MONITOREO.ADMI_MOTIVO
 * @author Leonardo Espinoza <eespinoza@telconet.ec>
 * @since 09-07-2020
 */

INSERT INTO DB_MONITOREO.ADMI_MOTIVO(
    ID_MOTIVO,
    NOMBRE_MOTIVO,
    FE_CREACION,
    USR_CREACION,
    IP_CREACION,
    ESTADO)
    VALUES (
        DB_MONITOREO.SEQ_ADMI_MOTIVO.nextval,
        'Robado',
        SYSDATE,
        'eespinoza',
        '127.0.0.1',
        'Activo'
        );

INSERT INTO DB_MONITOREO.ADMI_MOTIVO(
    ID_MOTIVO,
    NOMBRE_MOTIVO,
    FE_CREACION,
    USR_CREACION,
    IP_CREACION,
    ESTADO)
    VALUES (
        DB_MONITOREO.SEQ_ADMI_MOTIVO.nextval,
        'Mantenimiento',
        SYSDATE,
        'eespinoza',
        '127.0.0.1',
        'Activo'
        );

INSERT INTO DB_MONITOREO.ADMI_MOTIVO(
    ID_MOTIVO,
    NOMBRE_MOTIVO,
    FE_CREACION,
    USR_CREACION,
    IP_CREACION,
    ESTADO)
    VALUES (
        DB_MONITOREO.SEQ_ADMI_MOTIVO.nextval,
        'Dado de Baja',
        SYSDATE,
        'eespinoza',
        '127.0.0.1',
        'Activo'
        );

COMMIT;
/