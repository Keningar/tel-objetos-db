create or replace PROCEDURE            P_INSERT_LOG (
    Pv_TypeLog        IN                NAF47_TNET.INFO_LOGGER.TYPE_LOG%TYPE,
    Pv_Owner          IN                NAF47_TNET.INFO_LOGGER.OWNER_NAME%TYPE,
    Pv_AppName        IN                NAF47_TNET.INFO_LOGGER.APP_NAME%TYPE,
    Pv_PackageName    IN                NAF47_TNET.INFO_LOGGER.PACKAGE_NAME%TYPE,
    Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
    Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
    Pv_Information    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
    Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
    Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
    Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
    Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
    Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
) AS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO NAF47_TNET.INFO_LOGGER (
        ID_LOGGER,
        TYPE_LOG,
        OWNER_NAME,
        APP_NAME,
        PACKAGE_NAME,
        PROCESS_NAME,
        ORDER_PROCESS,
        INFORMATION,
        OBSERVATION,
        STATUS,
        CODE,
        MESSAGE,
        FE_CREACION,
        USR_CREACION
    ) VALUES (
        NAF47_TNET.SEQ_INFO_LOGGER.NEXTVAL,
        Pv_TypeLog,
        Pv_Owner,
        Pv_AppName,
        Pv_PackageName,
        Pv_ProcessName,
        Pv_OrderProcess,
        Pv_Information,
        Pv_Observation,
        Pv_Status,
        Pv_Code,
        Pv_Message,
        SYSDATE,
        Pv_Usr
    );

    COMMIT;
END P_INSERT_LOG;