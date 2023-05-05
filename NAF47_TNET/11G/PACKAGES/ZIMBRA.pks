CREATE OR REPLACE PACKAGE            ZIMBRA AS
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
    Gv_User VARCHAR2(50) := 'zimbra';

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
      * Inserta un log tipo INFO en INFO_LOGGER
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @return 
     **/

    PROCEDURE P_INFO (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    );

    /**
      * Inserta un log tipo ERROR en INFO_LOGGER
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @return 
     **/

    PROCEDURE P_ERROR (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    );

    /**
      * Inserta un log tipo WARNING en INFO_LOGGER
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @return 
     **/

    PROCEDURE P_WARNING (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    );

    /**
      * Inserta un log tipo REQUEST en INFO_LOGGER
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @return 
     **/

    PROCEDURE P_REQUEST (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    );

    /**
      * Inserta un log tipo RESPONSE en INFO_LOGGER
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @return 
     **/

    PROCEDURE P_RESPONSE (
        Pv_ProcessName    IN                NAF47_TNET.INFO_LOGGER.PROCESS_NAME%TYPE,
        Pv_OrderProcess   IN                NAF47_TNET.INFO_LOGGER.ORDER_PROCESS%TYPE,
        Pv_InfoProcess    IN                NAF47_TNET.INFO_LOGGER.INFORMATION%TYPE,
        Pv_Observation    IN                NAF47_TNET.INFO_LOGGER.OBSERVATION%TYPE,
        Pv_Status         IN                NAF47_TNET.INFO_LOGGER.STATUS%TYPE,
        Pv_Code           IN                NAF47_TNET.INFO_LOGGER.CODE%TYPE,
        Pv_Message        IN                NAF47_TNET.INFO_LOGGER.MESSAGE%TYPE,
        Pv_Usr            IN                NAF47_TNET.INFO_LOGGER.USR_CREACION%TYPE
    );

    /**
      * Http HEADER
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    TYPE Lr_HttpHeader IS RECORD (
        REQUEST DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
        URL_REQUEST DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
        METHOD_REQUEST DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
        VERSION_REQUEST DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE,
        HEADER_NAME DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
        HEADER_ATTR DB_GENERAL.ADMI_PARAMETRO_DET.VALOR6%TYPE,
        ACTION DB_GENERAL.ADMI_PARAMETRO_DET.VALOR7%TYPE
    );
    TYPE Tr_HttpHeader IS
        TABLE OF Lr_HttpHeader;

    /**
     * Obtiene parametros para request
     * @param Fv_Nombre            IN                 VARCHAR2 Nombre parametro CAB
     * @param Fv_Metodo            IN                 VARCHAR2 Metodo zimbra CRUD
     * @param Fv_EstadoCab         IN                 VARCHAR2 Estado parametro CAB
     * @param Fv_EstadoDet         IN                 VARCHAR2 Estado parametro DET
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @version 1.0 20-10-2018
     **/
    FUNCTION F_GET_PARAM_REQUEST (
        Fv_Nombre      IN             VARCHAR2,
        Fv_Metodo      IN             VARCHAR2,
        Fv_EstadoCab   IN             VARCHAR2,
        Fv_EstadoDet   IN             VARCHAR2
    ) RETURN Lr_HttpHeader;

    /**
    * Obtiene el detalle de error de una peticion
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    PROCEDURE P_GET_ERROR (
        Pv_XML     IN         VARCHAR2,
        Pv_Code    OUT        VARCHAR2,
        Pv_Trace   OUT        VARCHAR2
    );

    /**
    * Obtiene respuesta de AuthRequest 
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    PROCEDURE P_GET_RESPONSE_AUTH (
        Pv_XML         IN             VARCHAR2,
        Pv_AuthToken   OUT            CLOB,
        Pv_LifeTime    OUT            CLOB
    );

    /**
    * Obtiene token de aministracion
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    PROCEDURE P_GET_TOKEN_AUTH (
        Pv_Token    OUT         CLOB,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    );

    /**
    * Obtiene respuesta de GetAccountRequest 
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    PROCEDURE P_GET_RESPONSE_ACCOUNT (
        Pv_XML    IN        VARCHAR2,
        Pv_Name   OUT       VARCHAR2,
        Pv_Id     OUT       VARCHAR2,
        Pv_Urn    OUT       CLOB
    );

    /**
    * Obtiene info de correo
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    PROCEDURE P_GET_ACCOUNT_INFO (
        Pv_Token    IN          VARCHAR2,
        Pv_Name     IN          VARCHAR2,
        Pv_Id       OUT         VARCHAR2,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    );


    /**
    * Crea cuenta en zimbra
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    PROCEDURE P_ACCOUNT_CREATE (
        Pv_Token    IN          VARCHAR2,
        Pv_Name     IN          VARCHAR2,
        Pv_Passwd   IN          VARCHAR2,
        Pv_Urn      IN          CLOB,
        Pv_Id       OUT         VARCHAR2,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    );

    /**
    * Modifica cuenta en zimbra
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    PROCEDURE P_ACCOUNT_MODIFY (
        Pv_Token    IN          VARCHAR2,
        Pv_Id       IN OUT      VARCHAR2,
        Pv_Urn      IN OUT      CLOB,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    );

    /**
    * Elimina cuenta en zimbra
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    **/

    PROCEDURE P_ACCOUNT_DELETE (
        Pv_Token    IN          VARCHAR2,
        Pv_Id       IN          VARCHAR2,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    );

END ZIMBRA;
/


CREATE OR REPLACE PACKAGE BODY            ZIMBRA AS

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
            NAF47_TNET.P_INSERT_LOG('INFO', 'NAF47_TNET', 'ZIMBRA', 'ZIMBRA', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
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
            NAF47_TNET.P_INSERT_LOG('ERROR', 'NAF47_TNET', 'ZIMBRA', 'ZIMBRA', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
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
            NAF47_TNET.P_INSERT_LOG('WARNING', 'NAF47_TNET', 'ZIMBRA', 'ZIMBRA', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
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
            NAF47_TNET.P_INSERT_LOG('REQUEST', 'NAF47_TNET', 'ZIMBRA', 'ZIMBRA', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
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
            NAF47_TNET.P_INSERT_LOG('RESPONSE', 'NAF47_TNET', 'ZIMBRA', 'ZIMBRA', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
            , Pv_Code, Pv_Message, Pv_Usr);

        END IF;
    END P_RESPONSE;

    FUNCTION F_GET_PARAM_REQUEST (
        Fv_Nombre      IN             VARCHAR2,
        Fv_Metodo      IN             VARCHAR2,
        Fv_EstadoCab   IN             VARCHAR2,
        Fv_EstadoDet   IN             VARCHAR2
    ) RETURN Lr_HttpHeader AS

        /*Obtiene parametros de configuracion para el request
         *@cost 5, cardinalidad 1
         */

        CURSOR C_GetParamForRequest (
            Cv_NombreParam   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
            Cv_Descripcion   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
            Cv_EstadoCab     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
            Cv_EstadoDet     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
        ) IS
        SELECT
            VALOR1   REQUEST,
            VALOR2   URL_REQUEST,
            VALOR3   METHOD_REQUEST,
            VALOR4   VERSION_REQUEST,
            VALOR5   HEADER_NAME,
            VALOR6   HEADER_ATTR,
            VALOR7   ACTION
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB APC,
            DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE
            APC.ID_PARAMETRO = APD.PARAMETRO_ID
            AND APC.NOMBRE_PARAMETRO = Cv_NombreParam
            AND APD.DESCRIPCION = Cv_Descripcion
            AND APC.ESTADO = Cv_EstadoCab
            AND APD.ESTADO = Cv_EstadoDet;

        Lc_GetParamForRequest   C_GetParamForRequest%ROWTYPE;
        Tr_HttpHeader           Lr_HttpHeader := NULL;
    BEGIN
         /*Busca configuracion para request*/
        IF C_GetParamForRequest%ISOPEN THEN
            CLOSE C_GetParamForRequest;
        END IF;
        OPEN C_GetParamForRequest(Fv_Nombre, Fv_Metodo, Fv_EstadoCab, Fv_EstadoDet);
        FETCH C_GetParamForRequest INTO Lc_GetParamForRequest;
        /*Valida que los parametros esten configurados*/
        IF C_GetParamForRequest%FOUND THEN
            Tr_HttpHeader.REQUEST := Lc_GetParamForRequest.REQUEST;
            Tr_HttpHeader.URL_REQUEST := Lc_GetParamForRequest.URL_REQUEST;
            Tr_HttpHeader.METHOD_REQUEST := Lc_GetParamForRequest.METHOD_REQUEST;
            Tr_HttpHeader.VERSION_REQUEST := Lc_GetParamForRequest.VERSION_REQUEST;
            Tr_HttpHeader.HEADER_NAME := Lc_GetParamForRequest.HEADER_NAME;
            Tr_HttpHeader.HEADER_ATTR := Lc_GetParamForRequest.HEADER_ATTR;
            Tr_HttpHeader.ACTION := Lc_GetParamForRequest.ACTION;
        END IF;

        CLOSE C_GetParamForRequest;
        RETURN Tr_HttpHeader;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN Tr_HttpHeader;
    END F_GET_PARAM_REQUEST;

    PROCEDURE P_GET_ERROR (
        Pv_XML     IN         VARCHAR2,
        Pv_Code    OUT        VARCHAR2,
        Pv_Trace   OUT        VARCHAR2
    ) AS

        Ld_DocumentParser   DBMS_XMLPARSER.PARSER;
        Lv_Document         DBMS_XMLDOM.DOMDOCUMENT;
        Lv_RootElement      DBMS_XMLDOM.DOMELEMENT;
        Lv_ChildNodes       DBMS_XMLDOM.DOMNODELIST;
        Lv_ChildNode        DBMS_XMLDOM.DOMNODE;
        Lv_TextNode         DBMS_XMLDOM.DOMNODE;
        Lv_ResultNodes      DBMS_XMLDOM.DOMNODELIST;
        Lv_ResultNode       DBMS_XMLDOM.DOMNODE;
        Lv_Trace            VARCHAR2(10) := 'Trace';
        Lv_Code             VARCHAR2(10) := 'Code';
        Lv_NameTag          VARCHAR2(20) := 'Error';
        Lv_NodeName         VARCHAR2(50) := '';
        Lv_NodeValue        VARCHAR2(1000) := '';
    BEGIN
        /**Obtendremos los tags Code y Trace del elemento Error**/
        Ld_DocumentParser := DBMS_XMLPARSER.Newparser;
        DBMS_XMLPARSER.SETVALIDATIONMODE(Ld_DocumentParser, FALSE);
        DBMS_XMLPARSER.PARSEBUFFER(Ld_DocumentParser, Pv_XML);
        Lv_Document := DBMS_XMLPARSER.GETDOCUMENT(Ld_DocumentParser);
        Lv_RootElement := DBMS_XMLDOM.GETDOCUMENTELEMENT(Lv_Document);
        Lv_ResultNodes := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(Lv_RootElement, Lv_NameTag);
        FOR I_Node IN 0..DBMS_XMLDOM.GETLENGTH(Lv_ResultNodes) - 1 LOOP
            Lv_ResultNode := DBMS_XMLDOM.ITEM(Lv_ResultNodes, I_Node);
            Lv_ChildNodes := DBMS_XMLDOM.GETCHILDNODES(Lv_ResultNode);
            FOR I_ChildNode IN 0..DBMS_XMLDOM.GETLENGTH(Lv_ChildNodes) - 1 LOOP
                Lv_ChildNode := DBMS_XMLDOM.ITEM(Lv_ChildNodes, I_ChildNode);
                Lv_NodeName := DBMS_XMLDOM.GETNODENAME(Lv_ChildNode);
                Lv_TextNode := DBMS_XMLDOM.GETFIRSTCHILD(Lv_ChildNode);
                Lv_NodeValue := DBMS_XMLDOM.GETNODEVALUE(Lv_TextNode);
                IF Lv_NodeName = Lv_Trace THEN
                    Pv_Trace := Lv_NodeValue;
                ELSIF Lv_NodeName = Lv_Code THEN
                    Pv_Code := Lv_NodeValue;
                END IF;

            END LOOP;

        END LOOP;

    END P_GET_ERROR;

    PROCEDURE P_GET_RESPONSE_AUTH (
        Pv_XML         IN             VARCHAR2,
        Pv_AuthToken   OUT            CLOB,
        Pv_LifeTime    OUT            CLOB
    ) AS

        Ld_DocumentParser   DBMS_XMLPARSER.PARSER;
        Lv_Document         DBMS_XMLDOM.DOMDOCUMENT;
        Lv_RootElement      DBMS_XMLDOM.DOMELEMENT;
        Lv_ChildNodes       DBMS_XMLDOM.DOMNODELIST;
        Lv_ChildNode        DBMS_XMLDOM.DOMNODE;
        Lv_TextNode         DBMS_XMLDOM.DOMNODE;
        Lv_ResultNodes      DBMS_XMLDOM.DOMNODELIST;
        Lv_ResultNode       DBMS_XMLDOM.DOMNODE;
        Lv_Token            VARCHAR2(10) := 'authToken';
        Lv_LifeTime         VARCHAR2(10) := 'lifetime';
        Lv_NameTag          VARCHAR2(20) := 'AuthResponse';
        Lv_NodeName         VARCHAR2(50) := '';
        Lv_NodeValue        VARCHAR2(1000) := '';
    BEGIN
        /**Obtendremos los tags authToken, lifetime del elemento AuthResponse**/
        Ld_DocumentParser := DBMS_XMLPARSER.Newparser;
        DBMS_XMLPARSER.SETVALIDATIONMODE(Ld_DocumentParser, FALSE);
        DBMS_XMLPARSER.PARSEBUFFER(Ld_DocumentParser, Pv_XML);
        Lv_Document := DBMS_XMLPARSER.GETDOCUMENT(Ld_DocumentParser);
        Lv_RootElement := DBMS_XMLDOM.GETDOCUMENTELEMENT(Lv_Document);
        Lv_ResultNodes := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(Lv_RootElement, Lv_NameTag);
        FOR I_Node IN 0..DBMS_XMLDOM.GETLENGTH(Lv_ResultNodes) - 1 LOOP
            Lv_ResultNode := DBMS_XMLDOM.ITEM(Lv_ResultNodes, I_Node);
            Lv_ChildNodes := DBMS_XMLDOM.GETCHILDNODES(Lv_ResultNode);
            FOR I_ChildNode IN 0..DBMS_XMLDOM.GETLENGTH(Lv_ChildNodes) - 1 LOOP
                Lv_ChildNode := DBMS_XMLDOM.ITEM(Lv_ChildNodes, I_ChildNode);
                Lv_NodeName := DBMS_XMLDOM.GETNODENAME(Lv_ChildNode);
                Lv_TextNode := DBMS_XMLDOM.GETFIRSTCHILD(Lv_ChildNode);
                Lv_NodeValue := DBMS_XMLDOM.GETNODEVALUE(Lv_TextNode);
                IF Lv_NodeName = Lv_Token THEN
                    Pv_AuthToken := Lv_NodeValue;
                ELSIF Lv_NodeName = Lv_LifeTime THEN
                    Pv_LifeTime := Lv_NodeValue;
                END IF;

            END LOOP;

        END LOOP;

    END P_GET_RESPONSE_AUTH;

    PROCEDURE P_GET_TOKEN_AUTH (
        Pv_Token    OUT         CLOB,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    ) AS

        Tr_Crendentials      Lr_HttpHeader := NULL;
        Tr_ParamRequest      Lr_HttpHeader := NULL;
        Lrry_RequestHeader   GEKG_TYPE.RequestHeader;
        Lv_Request           VARCHAR2(32767) := '';
        Lc_Result            CLOB := NULL;
        Le_Fail EXCEPTION;
        Lv_Msn               VARCHAR2(1000) := '';
        Lv_LifeTime          VARCHAR2(100) := '';
    BEGIN
        /*Inicializa LOG*/
        Gv_LetLOG := F_PARAM('LOGGER_ZIMBRA', 'Activo', 'Activo');
        /*Inicializa user*/
        Gv_User := F_PARAM('USER_ZIMBRA', 'Activo', 'Activo');
        /*REQUEST => username , URL_REQUEST => password */
        Tr_Crendentials := F_GET_PARAM_REQUEST('ZIMBRA_API_SOAP', 'zimbraPassword', 'Activo', 'Activo');
        IF Tr_Crendentials.REQUEST IS NULL OR Tr_Crendentials.URL_REQUEST IS NULL THEN
            Lv_Msn := 'Credenciales no configuradas';
            RAISE Le_Fail;
        END IF;
        /**Obtiene parametros para hacer el request**/

        Tr_ParamRequest := F_GET_PARAM_REQUEST('ZIMBRA_API_SOAP', 'AuthRequest', 'Activo', 'Activo');
        /**Se valida que los parametros esten llenos**/
        IF Tr_ParamRequest.REQUEST IS NULL OR Tr_ParamRequest.URL_REQUEST IS NULL OR Tr_ParamRequest.HEADER_NAME IS NULL OR Tr_ParamRequest.HEADER_ATTR
        IS NULL OR Tr_ParamRequest.ACTION IS NULL OR Tr_ParamRequest.METHOD_REQUEST IS NULL OR Tr_ParamRequest.VERSION_REQUEST IS NULL THEN
            Lv_Msn := 'Parametros no configurados';
            RAISE Le_Fail;
        END IF;
        /**Se reemplaza los valores por las variables ${}**/

        Lv_Request := REPLACE(Tr_ParamRequest.REQUEST, '${name}', DB_GENERAL.GNCK_STRING.DECRYPT_STR(Tr_Crendentials.REQUEST));
        /**Se reemplaza los valores por las variables ${}**/

        Lv_Request := REPLACE(Lv_Request, '${password}', DB_GENERAL.GNCK_STRING.DECRYPT_STR(Tr_Crendentials.URL_REQUEST));
        /**Se inicializan los HEADER**/

        Lrry_RequestHeader(Tr_ParamRequest.HEADER_NAME) := Tr_ParamRequest.HEADER_ATTR;
        Lrry_RequestHeader('Content-Length') := LENGTH(Lv_Request);
        Lrry_RequestHeader('SOAPAction') := Tr_ParamRequest.ACTION;
        P_REQUEST('P_GET_TOKEN_AUTH', '1', 'Request', Tr_ParamRequest.REQUEST, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Request para obtener TOKEN'
        , Gv_User);
        /**Realiza el request**/

        GEKG_HTTP.P_REQUEST_SOAP(Tr_ParamRequest.URL_REQUEST, Lv_Request, Tr_ParamRequest.METHOD_REQUEST, Tr_ParamRequest.VERSION_REQUEST, Lrry_RequestHeader

        , Lc_Result, Pv_Status, Pv_Code, Pv_Msn);

        P_RESPONSE('P_GET_TOKEN_AUTH', '2', 'Response', Lc_Result, Pv_Status, Pv_Code, 'Response TOKEN', Gv_User);
        /**Cuando zimbra proceso correctamente, responde code 200, caso contrario 500**/

        IF Pv_Code = GEKG_TYPE.OK_CODE THEN
            P_GET_RESPONSE_AUTH(Lc_Result, Pv_Token, Lv_LifeTime);
        ELSE
            P_GET_ERROR(Lc_Result, Pv_Msn, Lv_Msn);
            RAISE Le_Fail;
        END IF;

    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_GET_TOKEN_AUTH;

    PROCEDURE P_GET_RESPONSE_ACCOUNT (
        Pv_XML    IN        VARCHAR2,
        Pv_Name   OUT       VARCHAR2,
        Pv_Id     OUT       VARCHAR2,
        Pv_Urn    OUT       CLOB
    ) AS

        Ld_DocumentParser   DBMS_XMLPARSER.PARSER;
        Lv_Document         DBMS_XMLDOM.DOMDOCUMENT;
        Lv_RootElement      DBMS_XMLDOM.DOMELEMENT;
        Lv_ResultNodes      DBMS_XMLDOM.DOMNODELIST;
        Lv_ResultNode       DBMS_XMLDOM.DOMNODE;
        Lv_AttrNodes        DBMS_XMLDOM.DOMNAMEDNODEMAP;
        Lv_AttrNode         DBMS_XMLDOM.DOMNODE;
        Lv_Id               VARCHAR2(2) := 'id';
        Lv_Name             VARCHAR2(4) := 'name';
        Lv_NameTag          VARCHAR2(8) := 'account';
        Lv_NodeName         VARCHAR2(50) := '';
    BEGIN
        /**Obtendremos los tag id, name del elemento account**/
        Ld_DocumentParser := DBMS_XMLPARSER.Newparser;
        DBMS_XMLPARSER.SETVALIDATIONMODE(Ld_DocumentParser, FALSE);
        DBMS_XMLPARSER.PARSEBUFFER(Ld_DocumentParser, Pv_XML);
        Lv_Document := DBMS_XMLPARSER.GETDOCUMENT(Ld_DocumentParser);
        Lv_RootElement := DBMS_XMLDOM.GETDOCUMENTELEMENT(Lv_Document);
        Lv_ResultNodes := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(Lv_RootElement, Lv_NameTag);
        FOR I_Node IN 0..DBMS_XMLDOM.GETLENGTH(Lv_ResultNodes) - 1 LOOP
            Lv_ResultNode := DBMS_XMLDOM.ITEM(Lv_ResultNodes, I_Node);
            Lv_AttrNodes := DBMS_XMLDOM.Getattributes(Lv_ResultNode);
            IF ( DBMS_XMLDOM.Isnull(Lv_AttrNodes) = False ) THEN
                FOR i IN 0..DBMS_XMLDOM.Getlength(Lv_AttrNodes) - 1 LOOP
                    Lv_AttrNode := DBMS_XMLDOM.ITEM(Lv_AttrNodes, i);
                    Lv_NodeName := DBMS_XMLDOM.GETNODENAME(Lv_AttrNode);
                    IF Lv_NodeName = Lv_Id THEN
                        Pv_Id := DBMS_XMLDOM.GETNODEVALUE(Lv_AttrNode);
                    ELSIF Lv_NodeName = Lv_Name THEN
                        Pv_Name := DBMS_XMLDOM.GETNODEVALUE(Lv_AttrNode);
                    END IF;

                END LOOP;
            END IF;

        END LOOP;

    END P_GET_RESPONSE_ACCOUNT;

    PROCEDURE P_GET_ACCOUNT_INFO (
        Pv_Token    IN          VARCHAR2,
        Pv_Name     IN          VARCHAR2,
        Pv_Id       OUT         VARCHAR2,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    ) AS

        Tr_Crendentials      Lr_HttpHeader := NULL;
        Tr_ParamRequest      Lr_HttpHeader := NULL;
        Lrry_RequestHeader   GEKG_TYPE.RequestHeader;
        Lv_Request           VARCHAR2(32767) := '';
        Lc_Result            CLOB := NULL;
        Lc_Urn               CLOB := NULL;
        Le_Fail EXCEPTION;
        Lv_Msn               VARCHAR2(1000) := '';
        Lv_Name              VARCHAR2(1000) := '';
    BEGIN
        /*Inicializa LOG*/
        Gv_LetLOG := F_PARAM('LOGGER_ZIMBRA', 'Activo', 'Activo');
        /*Inicializa user*/
        Gv_User := F_PARAM('USER_ZIMBRA', 'Activo', 'Activo');
        /**Obtiene parametros para hacer el request**/
        Tr_ParamRequest := F_GET_PARAM_REQUEST('ZIMBRA_API_SOAP', 'GetAccountRequest', 'Activo', 'Activo');
        /**Se valida que los parametros esten llenos**/
        IF Tr_ParamRequest.REQUEST IS NULL OR Tr_ParamRequest.URL_REQUEST IS NULL OR Tr_ParamRequest.HEADER_NAME IS NULL OR Tr_ParamRequest.HEADER_ATTR
        IS NULL OR Tr_ParamRequest.ACTION IS NULL OR Tr_ParamRequest.METHOD_REQUEST IS NULL OR Tr_ParamRequest.VERSION_REQUEST IS NULL THEN
            Lv_Msn := 'Parametros no configurados';
            RAISE Le_Fail;
        END IF;
        /**Se reemplaza los valores por las variables ${}**/
        Lv_Request := REPLACE(Tr_ParamRequest.REQUEST, '${token}', Pv_Token);
        Lv_Request := REPLACE(Lv_Request, '${name}', Pv_Name);
        /**Se inicializan los HEADER**/
        Lrry_RequestHeader(Tr_ParamRequest.HEADER_NAME) := Tr_ParamRequest.HEADER_ATTR;
        Lrry_RequestHeader('Content-Length') := LENGTH(Lv_Request);
        Lrry_RequestHeader('SOAPAction') := Tr_ParamRequest.ACTION;
        /**Realiza el request**/
        P_REQUEST('P_GET_ACCOUNT_INFO', '1', 'Request', Lv_Request, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Request para obtener info de cuenta', Gv_User
        );

        GEKG_HTTP.P_REQUEST_SOAP(Tr_ParamRequest.URL_REQUEST, Lv_Request, Tr_ParamRequest.METHOD_REQUEST, Tr_ParamRequest.VERSION_REQUEST, Lrry_RequestHeader

        , Lc_Result, Pv_Status, Pv_Code, Pv_Msn);

        P_RESPONSE('P_GET_ACCOUNT_INFO', '2', 'Response', Lc_Result, Pv_Status, Pv_Code, 'Informacino de cuenta', Gv_User);
        /**Cuando zimbra proceso correctamente, responde code 200, caso contrario 500**/
        IF Pv_Code = GEKG_TYPE.OK_CODE THEN
            P_GET_RESPONSE_ACCOUNT(Lc_Result, Lv_Name, Pv_Id, Lc_Urn);
        ELSE
            P_GET_ERROR(Lc_Result, Pv_Msn, Lv_Msn);
            RAISE Le_Fail;
        END IF;

    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_GET_ACCOUNT_INFO;

    PROCEDURE P_ACCOUNT_CREATE (
        Pv_Token    IN          VARCHAR2,
        Pv_Name     IN          VARCHAR2,
        Pv_Passwd   IN          VARCHAR2,
        Pv_Urn      IN          CLOB,
        Pv_Id       OUT         VARCHAR2,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    ) AS

        Tr_Crendentials      Lr_HttpHeader := NULL;
        Tr_ParamRequest      Lr_HttpHeader := NULL;
        Lrry_RequestHeader   GEKG_TYPE.RequestHeader;
        Lv_Request           VARCHAR2(32767) := '';
        Lc_Result            CLOB := NULL;
        Lc_Urn               CLOB := NULL;
        Le_Fail EXCEPTION;
        Lv_Msn               VARCHAR2(1000) := '';
        Lv_Name              VARCHAR2(1000) := '';
    BEGIN
        /*Inicializa LOG*/
        Gv_LetLOG := F_PARAM('LOGGER_ZIMBRA', 'Activo', 'Activo');
        /*Inicializa user*/
        Gv_User := F_PARAM('USER_ZIMBRA', 'Activo', 'Activo');
        /**Obtiene parametros para hacer el request**/
        Tr_ParamRequest := F_GET_PARAM_REQUEST('ZIMBRA_API_SOAP', 'CreateAccountRequest', 'Activo', 'Activo');
        /**Se valida que los parametros esten llenos**/
        IF Tr_ParamRequest.REQUEST IS NULL OR Tr_ParamRequest.URL_REQUEST IS NULL OR Tr_ParamRequest.HEADER_NAME IS NULL OR Tr_ParamRequest.HEADER_ATTR
        IS NULL OR Tr_ParamRequest.ACTION IS NULL OR Tr_ParamRequest.METHOD_REQUEST IS NULL OR Tr_ParamRequest.VERSION_REQUEST IS NULL THEN
            Lv_Msn := 'Parametros no configurados';
            RAISE Le_Fail;
        END IF;
        /**Se reemplaza los valores por las variables ${}**/
        Lv_Request := REPLACE(Tr_ParamRequest.REQUEST, '${token}', Pv_Token);
        Lv_Request := REPLACE(Lv_Request, '${name}', Pv_Name);
        Lv_Request := REPLACE(Lv_Request, '${password}', Pv_Passwd);
        Lv_Request := REPLACE(Lv_Request, '${urn}', Pv_Urn);
        /**Se inicializan los HEADER**/
        Lrry_RequestHeader(Tr_ParamRequest.HEADER_NAME) := Tr_ParamRequest.HEADER_ATTR;
        Lrry_RequestHeader('Content-Length') := LENGTH(Lv_Request);
        Lrry_RequestHeader('SOAPAction') := Tr_ParamRequest.ACTION;
        /**Realiza el request**/
        P_REQUEST('P_ACCOUNT_CREATE', '1', 'Request', Lv_Request, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Request para crear cuenta', Gv_User);

        GEKG_HTTP.P_REQUEST_SOAP(Tr_ParamRequest.URL_REQUEST, Lv_Request, Tr_ParamRequest.METHOD_REQUEST, Tr_ParamRequest.VERSION_REQUEST, Lrry_RequestHeader

        , Lc_Result, Pv_Status, Pv_Code, Pv_Msn);

        P_RESPONSE('P_ACCOUNT_CREATE', '2', 'Response', Lc_Result, Pv_Status, Pv_Code, 'Response crear cuenta', Gv_User);
        /**Cuando zimbra proceso correctamente, responde code 200, caso contrario 500**/
        IF Pv_Code = GEKG_TYPE.OK_CODE THEN
            P_GET_RESPONSE_ACCOUNT(Lc_Result, Lv_Name, Pv_Id, Lc_Urn);
        ELSE
            P_GET_ERROR(Lc_Result, Pv_Msn, Lv_Msn);
            RAISE Le_Fail;
        END IF;

    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_ACCOUNT_CREATE;

    PROCEDURE P_ACCOUNT_MODIFY (
        Pv_Token    IN          VARCHAR2,
        Pv_Id       IN OUT      VARCHAR2,
        Pv_Urn      IN OUT      CLOB,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    ) AS

        Tr_Crendentials      Lr_HttpHeader := NULL;
        Tr_ParamRequest      Lr_HttpHeader := NULL;
        Lrry_RequestHeader   GEKG_TYPE.RequestHeader;
        Lv_Request           VARCHAR2(32767) := '';
        Lc_Result            CLOB := NULL;
        Lc_Urn               CLOB := NULL;
        Le_Fail EXCEPTION;
        Lv_Msn               VARCHAR2(1000) := '';
        Lv_Name              VARCHAR2(1000) := '';
    BEGIN
        /*Inicializa LOG*/
        Gv_LetLOG := F_PARAM('LOGGER_ZIMBRA', 'Activo', 'Activo');
        /*Inicializa user*/
        Gv_User := F_PARAM('USER_ZIMBRA', 'Activo', 'Activo');
        /**Obtiene parametros para hacer el request**/
        Tr_ParamRequest := F_GET_PARAM_REQUEST('ZIMBRA_API_SOAP', 'ModifyAccountRequest', 'Activo', 'Activo');
        /**Se valida que los parametros esten llenos**/
        IF Tr_ParamRequest.REQUEST IS NULL OR Tr_ParamRequest.URL_REQUEST IS NULL OR Tr_ParamRequest.HEADER_NAME IS NULL OR Tr_ParamRequest.HEADER_ATTR
        IS NULL OR Tr_ParamRequest.ACTION IS NULL OR Tr_ParamRequest.METHOD_REQUEST IS NULL OR Tr_ParamRequest.VERSION_REQUEST IS NULL THEN
            Lv_Msn := 'Parametros no configurados';
            RAISE Le_Fail;
        END IF;
        /**Se reemplaza los valores por las variables ${}**/
        Lv_Request := REPLACE(Tr_ParamRequest.REQUEST, '${token}', Pv_Token);
        Lv_Request := REPLACE(Lv_Request, '${id}', Pv_Id);
        Lv_Request := REPLACE(Lv_Request, '${urn}', Pv_Urn);
        /**Se inicializan los HEADER**/
        Lrry_RequestHeader(Tr_ParamRequest.HEADER_NAME) := Tr_ParamRequest.HEADER_ATTR;
        Lrry_RequestHeader('Content-Length') := LENGTH(Lv_Request);
        Lrry_RequestHeader('SOAPAction') := Tr_ParamRequest.ACTION;
        P_REQUEST('P_ACCOUNT_MODIFY', '1', 'Request', Lv_Request, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Request para modificar cuenta', Gv_User)
        ;
        /**Realiza el request**/
        GEKG_HTTP.P_REQUEST_SOAP(Tr_ParamRequest.URL_REQUEST, Lv_Request, Tr_ParamRequest.METHOD_REQUEST, Tr_ParamRequest.VERSION_REQUEST, Lrry_RequestHeader

        , Lc_Result, Pv_Status, Pv_Code, Pv_Msn);

        P_RESPONSE('P_ACCOUNT_MODIFY', '2', 'Response', Lc_Result, Pv_Status, Pv_Code, 'Response modificar cuenta', Gv_User);
        /**Cuando zimbra proceso correctamente, responde code 200, caso contrario 500**/
        IF Pv_Code = GEKG_TYPE.OK_CODE THEN
            P_GET_RESPONSE_ACCOUNT(Lc_Result, Lv_Name, Pv_Id, Lc_Urn);
        ELSE
            P_GET_ERROR(Lc_Result, Pv_Msn, Lv_Msn);
            RAISE Le_Fail;
        END IF;

    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_ACCOUNT_MODIFY;

    PROCEDURE P_ACCOUNT_DELETE (
        Pv_Token    IN          VARCHAR2,
        Pv_Id       IN          VARCHAR2,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    ) AS

        Tr_Crendentials      Lr_HttpHeader := NULL;
        Tr_ParamRequest      Lr_HttpHeader := NULL;
        Lrry_RequestHeader   GEKG_TYPE.RequestHeader;
        Lv_Request           VARCHAR2(32767) := '';
        Lc_Result            CLOB := NULL;
        Lc_Urn               CLOB := NULL;
        Le_Fail EXCEPTION;
        Lv_Msn               VARCHAR2(1000) := '';
        Lv_Name              VARCHAR2(1000) := '';
    BEGIN
        /*Inicializa LOG*/
        Gv_LetLOG := F_PARAM('LOGGER_ZIMBRA', 'Activo', 'Activo');
        /*Inicializa user*/
        Gv_User := F_PARAM('USER_ZIMBRA', 'Activo', 'Activo');
        /**Obtiene parametros para hacer el request**/
        Tr_ParamRequest := F_GET_PARAM_REQUEST('ZIMBRA_API_SOAP', 'DeleteAccountRequest', 'Activo', 'Activo');
        /**Se valida que los parametros esten llenos**/
        IF Tr_ParamRequest.REQUEST IS NULL OR Tr_ParamRequest.URL_REQUEST IS NULL OR Tr_ParamRequest.HEADER_NAME IS NULL OR Tr_ParamRequest.HEADER_ATTR
        IS NULL OR Tr_ParamRequest.ACTION IS NULL OR Tr_ParamRequest.METHOD_REQUEST IS NULL OR Tr_ParamRequest.VERSION_REQUEST IS NULL THEN
            Lv_Msn := 'Parametros no configurados';
            RAISE Le_Fail;
        END IF;
        /**Se reemplaza los valores por las variables ${}**/
        Lv_Request := REPLACE(Tr_ParamRequest.REQUEST, '${token}', Pv_Token);
        Lv_Request := REPLACE(Lv_Request, '${id}', Pv_Id);
        /**Se inicializan los HEADER**/
        Lrry_RequestHeader(Tr_ParamRequest.HEADER_NAME) := Tr_ParamRequest.HEADER_ATTR;
        Lrry_RequestHeader('Content-Length') := LENGTH(Lv_Request);
        Lrry_RequestHeader('SOAPAction') := Tr_ParamRequest.ACTION;
        P_REQUEST('P_ACCOUNT_DELETE', '1', 'Request', Lv_Request, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Request para eliminar cuenta', Gv_User);
        /**Realiza el request**/
        GEKG_HTTP.P_REQUEST_SOAP(Tr_ParamRequest.URL_REQUEST, Lv_Request, Tr_ParamRequest.METHOD_REQUEST, Tr_ParamRequest.VERSION_REQUEST, Lrry_RequestHeader

        , Lc_Result, Pv_Status, Pv_Code, Pv_Msn);

        P_RESPONSE('P_ACCOUNT_DELETE', '2', 'Response', Lc_Result, Pv_Status, Pv_Code, 'Response eliminar cuenta', Gv_User);
        /**Cuando zimbra proceso correctamente, responde code 200, caso contrario 500**/
        IF Pv_Code <> GEKG_TYPE.OK_CODE THEN
            P_GET_ERROR(Lc_Result, Pv_Msn, Lv_Msn);
        END IF;

    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_ACCOUNT_DELETE;

END ZIMBRA;
/
