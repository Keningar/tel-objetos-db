CREATE OR REPLACE PACKAGE            GEKG_TYPE AS
      /**
      * Contendra los HEADER
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    TYPE RequestHeader IS
        TABLE OF VARCHAR2(500) INDEX BY VARCHAR2(200);
      /**
      * Record para entidad LDAP
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */
    TYPE Lr_LdapEntity IS RECORD (
        UID                   VARCHAR2(100),
        UID_NUMBER            VARCHAR2(50),
        GID_NUMBER            VARCHAR2(50),
        USER_PASSWORD         VARCHAR2(100),
        CN                    VARCHAR2(100),
        SN                    VARCHAR2(200),
        EMPRESA               VARCHAR2(100),
        PROVINCIA             VARCHAR2(100),
        AREA                  VARCHAR2(100),
        DEPARTAMENTO          VARCHAR2(150),
        CARGO                 VARCHAR2(150),
        DISPLAY_NAME          VARCHAR2(200),
        BUSINESS_CATEGORY     VARCHAR2(200),
        MAIL_BOX              VARCHAR2(100),
        HOME_DIRECTORY        VARCHAR2(100),
        LOGIN_SHELL           VARCHAR2(100),
        OBJECT_CLASS          VARCHAR2(250),
        OBJECT_CLASS_DN       VARCHAR2(250),
        MAIL                  VARCHAR2(150),
        CEDULA                VARCHAR2(30),
        OU_1                  VARCHAR2(50),
        OU_2                  VARCHAR2(50),
        STATUS                VARCHAR2(25),
        CODE                  VARCHAR2(5)
    );

    /**
      * Constantes para respuesta de procesos
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */
    CREATED_STATUS        CONSTANT VARCHAR2(15) := 'CREATED';
    CREATED_CODE          CONSTANT VARCHAR2(3) := '100';
    NOT_CREATED_STATUS    CONSTANT VARCHAR2(15) := 'NOT_CREATED';
    NOT_CREATED_CODE      CONSTANT VARCHAR2(3) := '101';
    UPDATED_STATUS        CONSTANT VARCHAR2(15) := 'UPDATED';
    UPDATED_CODE          CONSTANT VARCHAR2(3) := '102';
    NOT_UPDATED_STATUS    CONSTANT VARCHAR2(15) := 'NOT_UPDATED';
    NOT_UPDATED_CODE      CONSTANT VARCHAR2(3) := '103';
    FOUND_STATUS          CONSTANT VARCHAR2(15) := 'FOUND';
    FOUND_CODE            CONSTANT VARCHAR2(3) := '104';
    NOT_FOUND_STATUS      CONSTANT VARCHAR2(15) := 'NOT_FOUND';
    NOT_FOUND_CODE        CONSTANT VARCHAR2(3) := '105';
    DELETED_STATUS        CONSTANT VARCHAR2(15) := 'DELETED';
    DELETED_CODE          CONSTANT VARCHAR2(3) := '106';
    NOT_DELETED_STATUS    CONSTANT VARCHAR2(15) := 'NOT_DELETED';
    NOT_DELETED_CODE      CONSTANT VARCHAR2(3) := '107';
    FAILED_STATUS         CONSTANT VARCHAR2(15) := 'FAILED';
    FAILED_CODE           CONSTANT VARCHAR2(3) := '108';
    GENERATED_STATUS      CONSTANT VARCHAR2(15) := 'GENERATED';
    GENERATED_CODE        CONSTANT VARCHAR2(3) := '109';
    OK_STATUS             CONSTANT VARCHAR2(15) := 'OK';
    OK_CODE               CONSTANT VARCHAR2(3) := '200';
    SERVER_ERROR_STATUS   CONSTANT VARCHAR2(15) := 'Server Error';
    SERVER_ERROR_CODE     CONSTANT VARCHAR2(3) := '500';
    NONE_STATUS           CONSTANT VARCHAR2(15) := 'NONE';
    NONE_CODE             CONSTANT VARCHAR2(3) := '110';

    /**
      * Constantes usadas para validaciones y seteo en los procesos de sincronizacion
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */
    SIZE_PASAPORTE        CONSTANT VARCHAR2(2) := 15;
    SIZE_CEDULA           CONSTANT VARCHAR2(2) := 10;
    SIZE_RUC              CONSTANT VARCHAR2(2) := 13;
    ECUATORIANA           CONSTANT VARCHAR2(1) := 'N';
    EXTRANJERA            CONSTANT VARCHAR2(1) := 'E';
    ACTIVO                CONSTANT VARCHAR2(1) := 'A';
    INACTIVO              CONSTANT VARCHAR2(1) := 'I';
    SOLTERO               CONSTANT VARCHAR2(1) := 'S';
    CASADO                CONSTANT VARCHAR2(1) := 'C';
    DIVORCIADO            CONSTANT VARCHAR2(1) := 'D';
    UNION_LIBRE           CONSTANT VARCHAR2(1) := 'U';
    VIUDO                 CONSTANT VARCHAR2(1) := 'V';
    OTRO                  CONSTANT VARCHAR2(1) := 'O';
    FEMENINO              CONSTANT VARCHAR2(1) := 'F';
    MASCULINO             CONSTANT VARCHAR2(1) := 'M';
    T_VIUDO               CONSTANT VARCHAR2(1) := 'V';
    T_UNION_LIBRE         CONSTANT VARCHAR2(1) := 'U';
    T_DIVORCIADO          CONSTANT VARCHAR2(1) := 'D';
    T_SOLTERO             CONSTANT VARCHAR2(1) := 'S';
    T_CASADO              CONSTANT VARCHAR2(1) := 'C';
    T_MASCULINO           CONSTANT VARCHAR2(1) := 'M';
    T_FEMENINO            CONSTANT VARCHAR2(1) := 'F';
    T_PUBLICA             CONSTANT VARCHAR2(15) := 'Publica';
    T_PRIVADA             CONSTANT VARCHAR2(15) := 'Privada';
    T_INACTIVO            CONSTANT VARCHAR2(15) := 'Inactivo';
    T_ACTIVO              CONSTANT VARCHAR2(15) := 'Activo';
    T_EXTRANJERA          CONSTANT VARCHAR2(3) := 'EXT';
    T_NACIONAL            CONSTANT VARCHAR2(3) := 'NAC';
    T_PASAPORTE           CONSTANT VARCHAR2(3) := 'PAS';
    T_CEDULA              CONSTANT VARCHAR2(3) := 'CED';
    T_RUC                 CONSTANT VARCHAR2(3) := 'RUC';
    T_NATURAL             CONSTANT VARCHAR2(3) := 'NAT';
    T_JURIDICA            CONSTANT VARCHAR2(3) := 'JUR';
END GEKG_TYPE;
/



/
