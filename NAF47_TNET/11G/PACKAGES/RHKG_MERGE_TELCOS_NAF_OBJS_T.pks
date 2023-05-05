CREATE OR REPLACE PACKAGE            RHKG_MERGE_TELCOS_NAF_OBJS_T AS 
    /**
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @version 1.0 20-10-2018
     * Variable que permite escribir LOG
    **/
    Gv_LetLOG VARCHAR2(1) := 'N';


    /**
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * Variable que contiene usuario
     **/
    Gv_User VARCHAR2(50) := 'ssosync';

    /**
      * Obtiene de la base si el proceso escribe LOG o no y el usuario que escribe
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @return 
     **/
    FUNCTION F_PARAM (
        Fv_Nombre      IN             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
        Fv_EstadoCab   IN             DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
        Fv_EstadoDet   IN             DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
    ) RETURN VARCHAR2;
    /**
     * Obtiene un parametro de configuracion
     * @param Fv_NombreParametro   IN Nombre de parametro
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @version 1.0 20-10-2018
     **/

    FUNCTION F_GET_PARAM (
        Fv_NombreParametro   IN         VARCHAR2
    ) RETURN VARCHAR2;
    /**
      * P_MERGE_INFO_PERSONA
      * Inserta o actualiza persona
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */
    PROCEDURE P_MERGE_INFO_PERSONA (
        Pv_Login          IN                VARCHAR2,
        Pv_NoCia          IN                ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado   IN                V_INFO_EMPLEADO%ROWTYPE,
        Pr_InfoPersona    IN OUT            DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

    /**
      * P_MERGE_INFO_PERSONA_EMP_ROL
      * Inserta o actualiza persona empresa rol
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    PROCEDURE P_MERGE_INFO_PERSONA_EMP_ROL (
        Pv_NoCia               IN                     ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado        IN                     V_INFO_EMPLEADO%ROWTYPE,
        Pr_InfoPersona         IN                     DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pr_InfoPersonaEmpRol   IN OUT                 DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_TYPE.Tr_InfoPersonaEmpresaRol,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    );

    /**
      * P_MERGE_INFO_PER_FORM_CONT
      * Inserta o actualiza person forma contacto
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    PROCEDURE P_MERGE_INFO_PER_FORM_CONT (
        Pv_CodigoFormaContacto    IN                        DB_COMERCIAL.ADMI_FORMA_CONTACTO.CODIGO%TYPE,
        Pv_Valor                  IN                        DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.VALOR%TYPE,
        Pr_InfoPersona            IN                        DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pr_InfoPerFormaContacto   OUT                       DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pv_Status                 OUT                       VARCHAR2,
        Pv_Code                   OUT                       VARCHAR2,
        Pv_Msn                    OUT                       VARCHAR2
    );

    /**
      * P_MERGE_LOGIN_EMPLEADO
      * Inserta o actualiza login empleado
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    PROCEDURE P_MERGE_LOGIN_EMPLEADO (
        Pv_Login          IN                VARCHAR2,
        Pv_NoCia          IN                ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado   IN                V_INFO_EMPLEADO%ROWTYPE,
        Pv_Password       IN                VARCHAR2,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

    /**
      * P_MERGE_INFO_TELCOS
      * Une los procesos que insertan o actualizan estructuras del TELCOS
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    PROCEDURE P_MERGE_INFO_TELCOS (
        Pv_Login          IN                VARCHAR2,
        Pv_NoCia          IN                ARPLME.NO_CIA%TYPE,
        Pv_Mail           IN                VARCHAR2,
        Pr_InfoEmpleado   IN                V_INFO_EMPLEADO%ROWTYPE,
        Pv_Password       IN                VARCHAR2,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

END RHKG_MERGE_TELCOS_NAF_OBJS_T;
/


CREATE OR REPLACE PACKAGE BODY            RHKG_MERGE_TELCOS_NAF_OBJS_T AS

    FUNCTION F_PARAM (
        Fv_Nombre      IN             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
        Fv_EstadoCab   IN             DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
        Fv_EstadoDet   IN             DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
    ) RETURN VARCHAR2 AS    
        /*Obtiene parametros de configuracion la escritura de LOG
         *@cost 5, cardinalidad 1
         */

        CURSOR C_GetParametros (
            Cv_NombreParam   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
            Cv_EstadoCab     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
            Cv_EstadoDet     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
        ) IS
        SELECT
            NVL2(APD.VALOR1, APD.VALOR1, 'N') LOGGER
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB APC,
            DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE
            APC.ID_PARAMETRO = APD.PARAMETRO_ID
            AND APC.NOMBRE_PARAMETRO = Cv_NombreParam
            AND APC.ESTADO = Cv_EstadoCab
            AND APD.ESTADO = Cv_EstadoDet;

        Lc_GetParametros   C_GetParametros%ROWTYPE;
    BEGIN
        /*Busca configuracion para request*/
        IF C_GetParametros%ISOPEN THEN
            CLOSE C_GetParametros;
        END IF;
        OPEN C_GetParametros(Fv_Nombre, Fv_EstadoCab, Fv_EstadoDet);
        FETCH C_GetParametros INTO Lc_GetParametros;
        CLOSE C_GetParametros;
        RETURN Lc_GetParametros.LOGGER;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'N';
    END F_PARAM;

    PROCEDURE P_INFO (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    ) AS
    BEGIN
        IF UPPER(Gv_LetLOG) = 'S' THEN
            NAF47_TNET.P_INSERT_LOG('INFO', 'NAF47_TNET', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
            , Pv_Code, Pv_Message, Pv_Usr);

        END IF;
    END P_INFO;

    PROCEDURE P_ERROR (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    ) AS
    BEGIN
        IF UPPER(Gv_LetLOG) = 'S' THEN
            NAF47_TNET.P_INSERT_LOG('ERROR', 'NAF47_TNET', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
            , Pv_Code, Pv_Message, Pv_Usr);

        END IF;
    END P_ERROR;

    PROCEDURE P_WARNING (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    ) AS
    BEGIN
        IF UPPER(Gv_LetLOG) = 'S' THEN
            NAF47_TNET.P_INSERT_LOG('WARNING', 'NAF47_TNET', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
            , Pv_Code, Pv_Message, Pv_Usr);

        END IF;
    END P_WARNING;

    PROCEDURE P_REQUEST (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    ) AS
    BEGIN
        IF UPPER(Gv_LetLOG) = 'S' THEN
            NAF47_TNET.P_INSERT_LOG('REQUEST', 'NAF47_TNET', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
            , Pv_Code, Pv_Message, Pv_Usr);

        END IF;
    END P_REQUEST;

    PROCEDURE P_RESPONSE (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    ) AS
    BEGIN
        IF UPPER(Gv_LetLOG) = 'S' THEN
            NAF47_TNET.P_INSERT_LOG('RESPONSE', 'NAF47_TNET', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', 'RHKG_MERGE_TELCOS_NAF_OBJS_T', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
            , Pv_Code, Pv_Message, Pv_Usr);

        END IF;
    END P_RESPONSE;

    FUNCTION F_GET_PARAM (
        Fv_NombreParametro IN   VARCHAR2
    ) RETURN VARCHAR2 AS
        /*Obtiene parametros de configuracion para el request
         *@cost 5, cardinalidad 1
         */

        CURSOR C_GetParametros (
            Cv_NombreParam   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
            Cv_EstadoCab     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
            Cv_EstadoDet     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
        ) IS
        SELECT
            APD.VALOR1
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB APC,
            DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE
            APC.ID_PARAMETRO = APD.PARAMETRO_ID
            AND APC.NOMBRE_PARAMETRO = Cv_NombreParam
            AND APC.ESTADO = Cv_EstadoCab
            AND APD.ESTADO = Cv_EstadoDet;

        Lv_Conf   VARCHAR2(4000) := '';
    BEGIN
        /*Busca configuracion para request*/
        IF C_GetParametros%ISOPEN THEN
            CLOSE C_GetParametros;
        END IF;
        OPEN C_GetParametros(Fv_NombreParametro, 'Activo', 'Activo');
        FETCH C_GetParametros INTO Lv_Conf;
        CLOSE C_GetParametros;
        RETURN Lv_Conf;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '';
    END F_GET_PARAM;

    PROCEDURE P_MERGE_INFO_PERSONA (
        Pv_Login          IN                VARCHAR2,
        Pv_NoCia          IN                ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado   IN                V_INFO_EMPLEADO%ROWTYPE,
        Pr_InfoPersona    IN OUT            DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS

        Lv_Status       VARCHAR2(100);
        Lv_Code         VARCHAR2(5);
        Lv_Msn          VARCHAR2(4000);
        LrInfoPersona   DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona;
        Ln_IdPersona    NUMBER := 0;
        Le_Fail EXCEPTION;
    BEGIN
        Pr_InfoPersona.FE_CREACION := SYSDATE;
        Pr_InfoPersona.USR_CREACION := F_PARAM('USER_APP_SINC_EMPL_NAF_TELCOS', 'Activo', 'Activo');
        Pr_InfoPersona.IP_CREACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
        P_INFO('P_MERGE_INFO_PERSONA', '1', 'RHKG_PREPARE_TELCOS_OBJECTS_T.P_PREPARE_INFO_PERSONA', Pv_Login, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Prepara persona', Gv_User);
        RHKG_PREPARE_TELCOS_OBJECTS_T.P_PREPARE_INFO_PERSONA(Pv_Login, Pv_NoCia, Pr_InfoEmpleado, Pr_InfoPersona, Lv_Status, Lv_Code, Lv_Msn);
        P_INFO('P_MERGE_INFO_PERSONA', '2', 'RHKG_PREPARE_TELCOS_OBJECTS_T.P_PREPARE_INFO_PERSONA', Pv_Login, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        DB_COMERCIAL.CMKG_INFO_PERSONA_C.P_FIND_PERSONA_BY_IDENT(Pr_InfoPersona.IDENTIFICACION_CLIENTE, LrInfoPersona, Lv_Status, Lv_Code, Lv_Msn);

        Ln_IdPersona := LrInfoPersona.ID_PERSONA;
        IF GEKG_TYPE.FAILED_STATUS = Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        P_INFO('P_MERGE_INFO_PERSONA', '3', 'P_UPDATE_INFO_PERSONA_SINC_EMP.P_INSERT_INFO_PERSONA', Pv_Login || ' ' || Ln_IdPersona, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Antes de insertar persona', Gv_User);
        CASE Lv_Status
            WHEN GEKG_TYPE.FOUND_STATUS THEN
                Lv_Status := '';
                Lv_Code := '';
                Lv_Msn := '';
                DB_COMERCIAL.CMKG_INFO_PERSONA_T.P_UPDATE_INFO_PERSONA_SINC_EMP(Pr_InfoPersona, Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn);
            WHEN GEKG_TYPE.NOT_FOUND_STATUS THEN
                Lv_Status := '';
                Lv_Code := '';
                Lv_Msn := '';
                DB_COMERCIAL.CMKG_INFO_PERSONA_T.P_INSERT_INFO_PERSONA(Pr_InfoPersona, Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn);
        END CASE;
        P_INFO('P_MERGE_INFO_PERSONA', '4', 'P_UPDATE_INFO_PERSONA_SINC_EMP.P_INSERT_INFO_PERSONA', Pr_InfoPersona.LOGIN || ' ' || Pr_InfoPersona.ID_PERSONA || ' ' || Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        Pr_InfoPersona.ID_PERSONA := Ln_IdPersona;
        IF GEKG_TYPE.FAILED_STATUS = Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Se genero instancia de persona';
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := Lv_Status;
            Pv_Code := Lv_Code;
            Pv_Msn := Lv_Msn;
            P_ERROR('P_MERGE_INFO_PERSONA', '0', 'Le_Fail', Pr_InfoPersona.LOGIN || ' ' || Pr_InfoPersona.ID_PERSONA || ' ' || Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
            P_ERROR('P_MERGE_INFO_PERSONA', '0', 'OTHERS', Pr_InfoPersona.LOGIN || ' ' || Pr_InfoPersona.ID_PERSONA || ' ' || Ln_IdPersona, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
    END P_MERGE_INFO_PERSONA;

    PROCEDURE P_MERGE_INFO_PERSONA_EMP_ROL (
        Pv_NoCia               IN                     ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado        IN                     V_INFO_EMPLEADO%ROWTYPE,
        Pr_InfoPersona         IN                     DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pr_InfoPersonaEmpRol   IN OUT                 DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_TYPE.Tr_InfoPersonaEmpresaRol,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    ) AS

        Lv_Status                  VARCHAR2(100);
        Lv_Code                    VARCHAR2(5);
        Lv_Msn                     VARCHAR2(4000);
        Lr_InfoPersonaEmpresaRol   DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_TYPE.Tr_InfoPerEmpRol%ROWTYPE;
        Ln_IdPersonaEmpresaRol     NUMBER := 0;
        Le_Fail EXCEPTION;
    BEGIN
        P_INFO('P_MERGE_INFO_PERSONA_EMP_ROL', '1', 'P_PREPARE_INFO_PERSONA_EMP_ROL', Pr_InfoPersona.IDENTIFICACION_CLIENTE, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Merge info persona empresa rol', Gv_User);
        RHKG_PREPARE_TELCOS_OBJECTS_T.P_PREPARE_INFO_PERSONA_EMP_ROL(Pv_NoCia, Pr_InfoEmpleado, Pr_InfoPersona, Pr_InfoPersonaEmpRol, Lv_Status, Lv_Code
        , Lv_Msn);
        P_INFO('P_MERGE_INFO_PERSONA_EMP_ROL', '2', 'P_PREPARE_INFO_PERSONA_EMP_ROL', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_C.P_GET_INFO_PERSONA_EMPR_ROL(Pr_InfoPersona.IDENTIFICACION_CLIENTE, Pv_NoCia, Lr_InfoPersonaEmpresaRol,
        Lv_Status, Lv_Code, Lv_Msn);
        P_INFO('P_MERGE_INFO_PERSONA_EMP_ROL', '3', 'P_GET_INFO_PERSONA_EMPR_ROL', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        Ln_IdPersonaEmpresaRol := Lr_InfoPersonaEmpresaRol.ID_PERSONA_ROL;
        IF GEKG_TYPE.FAILED_STATUS = Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        CASE Lv_Status
            WHEN GEKG_TYPE.FOUND_STATUS THEN
                DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_T.P_UPDATE_INFO_PER_EMPRESA_ROL(Pr_InfoPersonaEmpRol, Ln_IdPersonaEmpresaRol, Lv_Status, Lv_Code
                , Lv_Msn);
                P_INFO('P_MERGE_INFO_PERSONA_EMP_ROL', '4', 'P_UPDATE_INFO_PER_EMPRESA_ROL', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
            WHEN GEKG_TYPE.NOT_FOUND_STATUS THEN
                DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_T.P_INSERT_INFO_PER_EMPRESA_ROL(Pr_InfoPersonaEmpRol, Ln_IdPersonaEmpresaRol, Lv_Status, Lv_Code
                , Lv_Msn);
                P_INFO('P_MERGE_INFO_PERSONA_EMP_ROL', '4', 'P_INSERT_INFO_PER_EMPRESA_ROL', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        END CASE;
        IF GEKG_TYPE.FAILED_STATUS = Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Se genero instancia de persona empresa rol';
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := Lv_Status;
            Pv_Code := Lv_Code;
            Pv_Msn := Lv_Msn;
            P_INFO('P_MERGE_INFO_PERSONA_EMP_ROL', '0', 'Le_Fail', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
            P_INFO('P_MERGE_INFO_PERSONA_EMP_ROL', '0', 'OTHERS', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
    END P_MERGE_INFO_PERSONA_EMP_ROL;

    PROCEDURE P_MERGE_INFO_PER_FORM_CONT (
        Pv_CodigoFormaContacto    IN                        DB_COMERCIAL.ADMI_FORMA_CONTACTO.CODIGO%TYPE,
        Pv_Valor                  IN                        DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.VALOR%TYPE,
        Pr_InfoPersona            IN                        DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pr_InfoPerFormaContacto   OUT                       DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pv_Status                 OUT                       VARCHAR2,
        Pv_Code                   OUT                       VARCHAR2,
        Pv_Msn                    OUT                       VARCHAR2
    ) AS

        Lv_Status                  VARCHAR2(100);
        Lv_Code                    VARCHAR2(5);
        Lv_Msn                     VARCHAR2(4000);
        Lr_InforPerFormaContacto   DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO%ROWTYPE;
        Ln_IdPersFormCont          NUMBER := 0;
        Le_Fail EXCEPTION;
    BEGIN
        RHKG_PREPARE_TELCOS_OBJECTS_T.P_PREPARE_INFO_PER_FORM_CONT(Pv_CodigoFormaContacto, Pv_Valor, Pr_InfoPersona, Pr_InfoPerFormaContacto, Lv_Status
        , Lv_Code, Lv_Msn);
        P_INFO('P_MERGE_INFO_PER_FORM_CONT', '1', 'P_PREPARE_INFO_PER_FORM_CONT', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        DB_COMERCIAL.CMKG_INFO_PER_FORMA_CONTACTO_C.P_GET_INFO_PER_FORMA_CONTACTO(Pr_InfoPersona.ID_PERSONA, Pr_InfoPerFormaContacto.FORMA_CONTACTO_ID,
        Pv_Valor, Lr_InforPerFormaContacto, Lv_Status, Lv_Code, Lv_Msn);
        P_INFO('P_MERGE_INFO_PER_FORM_CONT', '2', 'P_GET_INFO_PER_FORMA_CONTACTO', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);

        IF GEKG_TYPE.FAILED_STATUS = Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        Ln_IdPersFormCont := Lr_InforPerFormaContacto.ID_PERSONA_FORMA_CONTACTO;
        CASE Lv_Status
            WHEN GEKG_TYPE.FOUND_STATUS THEN
                DB_COMERCIAL.CMKG_INFO_PER_FORMA_CONTACTO_T.P_UPDATE_INFO_PER_FORM_CONT(Pr_InfoPerFormaContacto, Ln_IdPersFormCont, Lv_Status, Lv_Code,
                Lv_Msn);
                P_INFO('P_MERGE_INFO_PER_FORM_CONT', '3', 'P_UPDATE_INFO_PER_FORM_CONT', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
            WHEN GEKG_TYPE.NOT_FOUND_STATUS THEN
                DB_COMERCIAL.CMKG_INFO_PER_FORMA_CONTACTO_T.P_INSERT_INFO_PER_FORM_CONT(Pr_InfoPerFormaContacto, Ln_IdPersFormCont, Lv_Status, Lv_Code,
                Lv_Msn);
                P_INFO('P_MERGE_INFO_PER_FORM_CONT', '3', 'P_INSERT_INFO_PER_FORM_CONT', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        END CASE;

        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Se genero instancia de persona forma contacto';
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := Lv_Status;
            Pv_Code := Lv_Code;
            Pv_Msn := Lv_Msn;
            P_INFO('P_MERGE_INFO_PER_FORM_CONT', '0', 'Le_Fail', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
            P_INFO('P_MERGE_INFO_PER_FORM_CONT', '0', 'OTHERS', Pr_InfoPersona.IDENTIFICACION_CLIENTE, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
    END P_MERGE_INFO_PER_FORM_CONT;

    PROCEDURE P_MERGE_LOGIN_EMPLEADO (
        Pv_Login          IN                VARCHAR2,
        Pv_NoCia          IN                ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado   IN                V_INFO_EMPLEADO%ROWTYPE,
        Pv_Password       IN                VARCHAR2,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS

        Lr_LoginEmpleado   LOGIN_EMPLEADO%ROWTYPE;
        Lv_Status          VARCHAR2(100);
        Lv_Code            VARCHAR2(5);
        Lv_Msn             VARCHAR2(4000);
        Le_Fail EXCEPTION;
    BEGIN
        Lr_LoginEmpleado.NO_CIA := Pv_NoCia;
        Lr_LoginEmpleado.NO_EMPLE := Pr_InfoEmpleado.NO_EMPLE;
        Lr_LoginEmpleado.LOGIN := Pv_Login;
        Lr_LoginEmpleado.CEDULA := Pr_InfoEmpleado.CEDULA;
        RHKG_LOGIN_EMPLEADO_C.P_FIND_LOGIN_EMPLEADO(Lr_LoginEmpleado, Lv_Status, Lv_Code, Lv_Msn);
        P_INFO('P_MERGE_LOGIN_EMPLEADO', '1', 'P_FIND_LOGIN_EMPLEADO', Lr_LoginEmpleado.CEDULA, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        IF Lv_Status NOT IN (GEKG_TYPE.FOUND_STATUS, GEKG_TYPE.NOT_FOUND_STATUS) THEN
            RAISE Le_Fail;
        END IF;
        CASE Lv_Status
            WHEN GEKG_TYPE.FOUND_STATUS THEN
                RHKG_LOGIN_EMPLEADO_T.P_UPDATE_LOGIN_EMPLEADO(Lr_LoginEmpleado, Lv_Status, Lv_Code, Lv_Msn);
                P_INFO('P_MERGE_LOGIN_EMPLEADO', '2', 'P_UPDATE_LOGIN_EMPLEADO', Lr_LoginEmpleado.CEDULA, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
                IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
                    RAISE Le_Fail;
                END IF;
            WHEN GEKG_TYPE.NOT_FOUND_STATUS THEN
                Lr_LoginEmpleado.PASSWORD := Pv_Password;
                IF Lr_LoginEmpleado.PASSWORD IS NULL THEN
                  Lr_LoginEmpleado.PASSWORD := 'NOTHING';
                END IF;
                RHKG_LOGIN_EMPLEADO_T.P_INSERT_LOGIN_EMPLEADO(Lr_LoginEmpleado, Lv_Status, Lv_Code, Lv_Msn);
                P_INFO('P_MERGE_LOGIN_EMPLEADO', '2', 'P_INSERT_LOGIN_EMPLEADO', Lr_LoginEmpleado.CEDULA, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
                IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
                    RAISE Le_Fail;
                END IF;
        END CASE;

        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Se genero LOGIN EMPLEADO';
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := Lv_Status;
            Pv_Code := Lv_Code;
            Pv_Msn := Lv_Msn;
            P_INFO('P_MERGE_LOGIN_EMPLEADO', '0', 'Le_Fail', Lr_LoginEmpleado.CEDULA, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
            P_INFO('P_MERGE_LOGIN_EMPLEADO', '0', 'OTHERS', Lr_LoginEmpleado.CEDULA, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
    END P_MERGE_LOGIN_EMPLEADO;

    PROCEDURE P_MERGE_INFO_TELCOS (
        Pv_Login          IN                VARCHAR2,
        Pv_NoCia          IN                ARPLME.NO_CIA%TYPE,
        Pv_Mail           IN                VARCHAR2,
        Pr_InfoEmpleado   IN                V_INFO_EMPLEADO%ROWTYPE,
        Pv_Password       IN                VARCHAR2,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS

        Lv_Status                 VARCHAR2(100);
        Lv_Code                   VARCHAR2(5);
        Lv_UserCreacion           VARCHAR2(25) := F_GET_PARAM('USER_APP_SINC_EMPL_NAF_TELCOS');
        Lv_Msn                    VARCHAR2(4000);
        LrInfoPersona             DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona;
        LrInfoPerEmpRol           DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_TYPE.Tr_InfoPersonaEmpresaRol;
        Lr_InfoPerFormaContacto   DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO%ROWTYPE;
        Le_Fail EXCEPTION;
    BEGIN
        /*Inicializa LOG*/
        Gv_LetLOG := F_PARAM('LOGGER_APP_SINC_EMPL_NAF_TELCOS', 'Activo', 'Activo');
        IF Lv_UserCreacion IS NULL OR Lv_UserCreacion = '' THEN
            Lv_UserCreacion := 'ssosync';
        END IF;
        LrInfoPersona.FE_CREACION := SYSDATE;
        LrInfoPersona.USR_CREACION := Lv_UserCreacion;
        LrInfoPersona.IP_CREACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
        P_MERGE_INFO_PERSONA(Pv_Login, Pv_NoCia, Pr_InfoEmpleado, LrInfoPersona, Lv_Status, Lv_Code, Lv_Msn);
        P_INFO('P_MERGE_INFO_TELCOS', '1', 'P_MERGE_INFO_PERSONA', Pr_InfoEmpleado.CEDULA || ' ' || LrInfoPersona.ID_PERSONA, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        LrInfoPerEmpRol.FE_CREACION := SYSDATE;
        LrInfoPerEmpRol.USR_CREACION := Lv_UserCreacion;
        LrInfoPerEmpRol.FE_ULT_MOD := SYSDATE;
        LrInfoPerEmpRol.USR_ULT_MOD := Lv_UserCreacion;
        LrInfoPerEmpRol.IP_CREACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
        P_MERGE_INFO_PERSONA_EMP_ROL(Pv_NoCia, Pr_InfoEmpleado, LrInfoPersona, LrInfoPerEmpRol, Lv_Status, Lv_Code, Lv_Msn);
        P_INFO('P_MERGE_INFO_TELCOS', '2', 'P_MERGE_INFO_PERSONA_EMP_ROL', Pr_InfoEmpleado.CEDULA, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        Lr_InfoPerFormaContacto.FE_CREACION := SYSDATE;
        Lr_InfoPerFormaContacto.USR_CREACION := Lv_UserCreacion;
        Lr_InfoPerFormaContacto.FE_ULT_MOD := SYSDATE;
        Lr_InfoPerFormaContacto.USR_ULT_MOD := Lv_UserCreacion;
        Lr_InfoPerFormaContacto.IP_CREACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
        IF Pv_Mail IS NOT NULL OR TRIM(Pv_Mail) != '' THEN
            P_MERGE_INFO_PER_FORM_CONT('MAIL', TRIM(Pv_Mail), LrInfoPersona, Lr_InfoPerFormaContacto, Lv_Status, Lv_Code, Lv_Msn);
            P_INFO('P_MERGE_INFO_TELCOS', '1', 'P_MERGE_INFO_PER_FORM_CONT - MAIL', Pr_InfoEmpleado.CEDULA || ' ' || TRIM(Pv_Mail), Lv_Status, Lv_Code, Lv_Msn, Gv_User);
            IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
                RAISE Le_Fail;
            END IF;
        END IF;

        IF Pr_InfoEmpleado.CELULAR IS NOT NULL OR TRIM(Pr_InfoEmpleado.CELULAR) != '' THEN
            P_MERGE_INFO_PER_FORM_CONT('TMOV', TRIM(Pr_InfoEmpleado.CELULAR), LrInfoPersona, Lr_InfoPerFormaContacto, Lv_Status, Lv_Code, Lv_Msn);
            P_INFO('P_MERGE_INFO_TELCOS', '1', 'P_MERGE_INFO_PER_FORM_CONT - TMOV1', Pr_InfoEmpleado.CEDULA || ' ' || TRIM(Pr_InfoEmpleado.CELULAR), Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        END IF;

        IF Pr_InfoEmpleado.CELULAR2 IS NOT NULL OR TRIM(Pr_InfoEmpleado.CELULAR2) != '' THEN
            P_MERGE_INFO_PER_FORM_CONT('TMOV', TRIM(Pr_InfoEmpleado.CELULAR2), LrInfoPersona, Lr_InfoPerFormaContacto, Lv_Status, Lv_Code, Lv_Msn);
            P_INFO('P_MERGE_INFO_TELCOS', '1', 'P_MERGE_INFO_PER_FORM_CONT - TMOV2', Pr_InfoEmpleado.CEDULA || ' ' || TRIM(Pr_InfoEmpleado.CELULAR2), Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        END IF;

        IF Pr_InfoEmpleado.CELULAR3 IS NOT NULL OR TRIM(Pr_InfoEmpleado.CELULAR3) != '' THEN
            P_MERGE_INFO_PER_FORM_CONT('TMOV', TRIM(Pr_InfoEmpleado.CELULAR3), LrInfoPersona, Lr_InfoPerFormaContacto, Lv_Status, Lv_Code, Lv_Msn);
            P_INFO('P_MERGE_INFO_TELCOS', '1', 'P_MERGE_INFO_PER_FORM_CONT - TMOV3', Pr_InfoEmpleado.CEDULA || ' ' || TRIM(Pr_InfoEmpleado.CELULAR3), Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        END IF;

        P_MERGE_LOGIN_EMPLEADO(Pv_Login, Pv_NoCia, Pr_InfoEmpleado, Pv_Password, Lv_Status, Lv_Code, Lv_Msn);
        P_INFO('P_MERGE_INFO_TELCOS', '3', 'P_MERGE_LOGIN_EMPLEADO', Pr_InfoEmpleado.CEDULA, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
            RAISE Le_Fail;
        END IF;
        BEGIN
            UPDATE NAF47_TNET.ARPLME SET MAIL_CIA = Pv_Mail WHERE NO_CIA = Pv_NoCia and NO_EMPLE = Pr_InfoEmpleado.NO_EMPLE;
        EXCEPTION WHEN OTHERS THEN
            Lv_Status := GEKG_TYPE.FAILED_STATUS;
            Lv_Code := GEKG_TYPE.FAILED_CODE;
            Lv_Msn := 'No se ralizo UPDATE MAIL_CIA';
            RAISE Le_Fail;
        END;
        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'TELCOS - NAF Merged';
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := Lv_Status;
            Pv_Code := Lv_Code;
            Pv_Msn := Lv_Msn;
            P_INFO('P_MERGE_INFO_TELCOS', '0', 'Le_Fail', Pr_InfoEmpleado.CEDULA, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
            P_INFO('P_MERGE_INFO_TELCOS', '0', 'OTHERS', Pr_InfoEmpleado.CEDULA, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
    END P_MERGE_INFO_TELCOS;

END RHKG_MERGE_TELCOS_NAF_OBJS_T;
/
