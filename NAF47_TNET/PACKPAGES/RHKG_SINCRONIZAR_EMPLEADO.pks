CREATE OR REPLACE PACKAGE NAF47_TNET.RHKG_SINCRONIZAR_EMPLEADO AS

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
  /**
   * @author Liseth Chunga <lchunga@telconet.ec>
   * @version 1.2 10-05-2023
   *
   * SE AGREGA EL LLAMADO AL PAQUETE CMKG_ARCHIVOS_EMPLEADOS PARA GUARDAR LA URL DEL EMPLEADO EN LA TABLA CARACTERÍSTICA(VALOR)
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
    * Documentacion para la funcion F_CLOB_REPLACE
    * la funcion F_CLOB_REPLACE realiza el replace entre CLOBS
    *
    * @param  Fc_String  IN CLOB      Recibe el CLOB al cual se requiere hacer un replace
    * @param  Fv_Search  IN VARCHAR   Recibe string a buscar en el CLOB
    * @param  Fc_Replace IN CLOB      Recibe el CLOB con el que se hara el replace
    * @return CLOB                    Retorna el CLOB al cual se ha hecho el replace
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 09-12-2018
    */

    FUNCTION F_CLOB_REPLACES (
        Fc_String    IN           CLOB,
        Fv_Search    IN           VARCHAR2,
        Fc_Replace   IN           CLOB
    ) RETURN CLOB;

  /**
  * Obtiene un parametro de configuracion
  * @param Fv_NombreParametro   IN Nombre de parametro
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 20-10-2018
  **/

    FUNCTION F_GET_PARAM (
        Fv_NombreParametro IN   VARCHAR2
    ) RETURN VARCHAR2;

    /**
      * P_ENVIA_NOTIFICACION
      * Envia una notificacion
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    /**
      * P_ENVIA_NOTIFICACION
      * Validación de nueva plantilla de ingreso de nuevos empleados TN
      * @author Bolìvar Romero <bdromero@telconet.ec>
      * @version 1.1 22-07-2020
      */

    /**
      * P_ENVIA_NOTIFICACION
      * Correcciòn de nueva plantilla de ingreso de nuevos empleados TN
      * @author Bolìvar Romero <bdromero@telconet.ec>
      * @version 1.2 14-08-2020
      */

    PROCEDURE P_ENVIA_NOTIFICACION (
        Pv_CodigoPlantilla   IN                   VARCHAR2,
        Pv_Correo            IN                   VARCHAR2,
        Pv_Password          IN                   VARCHAR2,
        Pr_InfoEmpleado      IN                   V_INFO_EMPLEADO%ROWTYPE,
        Lr_LdapEntity        IN                   GEKG_TYPE.Lr_LdapEntity,
        Pv_Mensaje           IN                   VARCHAR2,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    );

  /**
  * Contiene la union de procesos que realizan la sincronizacion de empleados
  * LDAP, ZIMBRA, TELCOS, NAF
  * @param Fv_NombreParametro   IN Nombre de parametro
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 20-10-2018
  *
  * @author Richard Cabrera <rcabrera@telconet.ec>
  * @version 1.1 19/02/2021    Se agrega llamada al ws de eliminacion del TACACS
  **/

    PROCEDURE P_SINCRIONIZACION_EMPLEADO (
        Pn_NoEmp    IN          ARPLME.NO_EMPLE%TYPE,
        Pn_NoCIa    IN          ARPLME.NO_CIA%TYPE,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    );

END RHKG_SINCRONIZAR_EMPLEADO;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.RHKG_SINCRONIZAR_EMPLEADO AS

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
            NAF47_TNET.P_INSERT_LOG('INFO', 'NAF47_TNET', 'RHKG_SINCRONIZAR_EMPLEADO', 'RHKG_SINCRONIZAR_EMPLEADO', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
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
            NAF47_TNET.P_INSERT_LOG('ERROR', 'NAF47_TNET', 'RHKG_SINCRONIZAR_EMPLEADO', 'RHKG_SINCRONIZAR_EMPLEADO', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
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
            NAF47_TNET.P_INSERT_LOG('WARNING', 'NAF47_TNET', 'RHKG_SINCRONIZAR_EMPLEADO', 'RHKG_SINCRONIZAR_EMPLEADO', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
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
            NAF47_TNET.P_INSERT_LOG('REQUEST', 'NAF47_TNET', 'RHKG_SINCRONIZAR_EMPLEADO', 'RHKG_SINCRONIZAR_EMPLEADO', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
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
            NAF47_TNET.P_INSERT_LOG('RESPONSE', 'NAF47_TNET', 'RHKG_SINCRONIZAR_EMPLEADO', 'RHKG_SINCRONIZAR_EMPLEADO', Pv_ProcessName, Pv_OrderProcess, Pv_InfoProcess, Pv_Observation, Pv_Status
            , Pv_Code, Pv_Message, Pv_Usr);

        END IF;
    END P_RESPONSE;

    FUNCTION F_CLOB_REPLACES (
        Fc_String    IN           CLOB,
        Fv_Search    IN           VARCHAR2,
        Fc_Replace   IN           CLOB
    ) RETURN CLOB IS
      /**/
        Lc_Null         CLOB := '';
        Ln_PlsInteger   PLS_INTEGER;
    BEGIN
        Ln_PlsInteger := INSTR(Fc_String, Fv_Search);
        IF Ln_PlsInteger > 0 THEN
            RETURN SUBSTR(Fc_String, 1, Ln_PlsInteger - 1)
                   || Fc_Replace
                   || SUBSTR(Fc_String, Ln_PlsInteger + LENGTH(Fv_Search));

        END IF;

        RETURN Fc_String;
      /**/
    EXCEPTION
        WHEN OTHERS THEN
      /**/
            RETURN Lc_Null;
      /**/
    END F_CLOB_REPLACES;

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

    PROCEDURE P_ENVIA_NOTIFICACION (
        Pv_CodigoPlantilla   IN                   VARCHAR2,
        Pv_Correo            IN                   VARCHAR2,
        Pv_Password          IN                   VARCHAR2,
        Pr_InfoEmpleado      IN                   V_INFO_EMPLEADO%ROWTYPE,
        Lr_LdapEntity        IN                   GEKG_TYPE.Lr_LdapEntity,
        Pv_Mensaje           IN                   VARCHAR2,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    ) AS

        Lc_Plantilla      CLOB;
        Lc_MessageMail    CLOB;
        Lv_Alias          VARCHAR2(4000) := '';
        Lv_Status         VARCHAR2(15) := '';
        Lv_Code           VARCHAR2(5) := '';
        Lv_Msn            VARCHAR2(4000) := '';
        Lv_Subject        VARCHAR2(400) := '';
        Lv_Mail           VARCHAR2(400) := '';
        Lr_ParamRequest   RHKG_PREPARE_TELCOS_OBJECTS_T.Lr_ParamRequest;
    BEGIN
        RHKG_PREPARE_TELCOS_OBJECTS_T.P_PARAMETROS('MAIL_SYNC_EMPLEADO', 'Activo', 'Activo', Lr_ParamRequest, Lv_Status, Lv_Code, Lv_Msn);

        DB_COMUNICACION.CUKG_ALIAS_PLANITLLA_C.P_GET_ALIAS_PLANTILLA(Pv_CodigoPlantilla, Lc_Plantilla, Lv_Alias, Lv_Status, Lv_Code, Lv_Msn);
        Lv_Alias :=  Lv_Mail || Lv_Alias || Pv_Correo;

        IF GEKG_TYPE.FOUND_STATUS = Lv_Status THEN
            CASE Pv_CodigoPlantilla
                WHEN 'EMP_SYNC_ING' THEN
                  /*Se valida a que compañía pertenece*/
                  if(Pr_InfoEmpleado.no_cia <> '10') then/*Si la empresa es distinta a 'TN', se deja la plantilla por defecto*/
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_Plantilla, '${displayName}', Lr_LdapEntity.DISPLAY_NAME);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cargo}', Lr_LdapEntity.CARGO);
		    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cedula}', Lr_LdapEntity.CEDULA);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${password}', Lr_LdapEntity.USER_PASSWORD);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${idNumber}', Lr_LdapEntity.GID_NUMBER);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${uid}', Lr_LdapEntity.UID);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${mail}', Lr_LdapEntity.MAIL);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${departamento}', Pr_InfoEmpleado.DEP_DESCRI);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${sangre}', Pr_InfoEmpleado.SANGRE);
		    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${direccion}', Pr_InfoEmpleado.DIRECCION);
	            Lv_Subject := Lr_ParamRequest.Lv_Valor2;
                  elsif(Pr_InfoEmpleado.no_cia ='10')then/*Si la empresa es 'TN', se muestra la nueva vista de la plantilla*/
                   Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_Plantilla, '<h1 style="color: #5e9ca0;">Correo corporativo</h1>', '<img align="right" style="width:18%; height:18%" src="https://sites.telconet.ec/TelcoCRM/custom/themes/default/images/company_logo.png"/>
                                                                                                                                                     <h1 style="color: #5e9ca0;"><p><center>TELCONET LATAM TE DA LA BIENVENIDA</center></p></h1>
                                                                                                                                                     <h2 style="color: #000000;"><p>Estimado Usuario, </p></h2>
                                                                                                                                                     <h2 style="color: #000000;"><p>La presente es para informarle que los datos necesarios para el acceso son: </p></h2>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'Nombres', '<b>Cuenta registrada a nombre de:  </b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${displayName}', Lr_LdapEntity.DISPLAY_NAME);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'Cargo', '<b>Cargo:</b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cargo}', Lr_LdapEntity.CARGO);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'Cédula', '<b>Cedula:</b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cedula}', Lr_LdapEntity.CEDULA);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'Password', '<b>Password:</b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${password}', Lr_LdapEntity.USER_PASSWORD);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'No empleado', '<b>Codigo de Empleado:</b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${idNumber}', Lr_LdapEntity.GID_NUMBER);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${uid}', Lr_LdapEntity.UID);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'eMail', '<b>E-mail Corporativo:</b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${mail}', Lr_LdapEntity.MAIL);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'Departamento', '<b>Departamento:</b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${departamento}', Pr_InfoEmpleado.DEP_DESCRI);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'Sangre', '<b>Tipo de Sangre:</b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${sangre}', Pr_InfoEmpleado.SANGRE);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, 'Dirección', '<b>Direccion:</b>');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${direccion}', Pr_InfoEmpleado.DIRECCION);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '</table>', '</table>
                                                                                                             <h2><p>Para cambiar su clave debe de acceder a la siguiente direccion, siempre y cuando se encuentre dentro de la red corporativa:</p></h2>
                                                                                                             <p><a href="https://telcos.telconet.ec">https://telcos.telconet.ec</a>
                                                                                                             <h2><p>Para ingresar al correo desde cualquier lugar:</p></h2>
                                                                                                             <p><a href="https://mail.telconet.ec">https://mail.telconet.ec</a>');
                    Lv_Subject := 'BIENVENIDO A TELCONET LATAM';
                  end if;
                 WHEN 'EMP_SYNC_ACT' THEN
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_Plantilla, '${displayName}', Lr_LdapEntity.DISPLAY_NAME);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cargo}', Lr_LdapEntity.CARGO);
		    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cedula}', Lr_LdapEntity.CEDULA);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${idNumber}', Lr_LdapEntity.GID_NUMBER);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${uid}', Lr_LdapEntity.UID);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${mail}', Lr_LdapEntity.MAIL);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${departamento}', Pr_InfoEmpleado.DEP_DESCRI);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${sangre}', Pr_InfoEmpleado.SANGRE);
		    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${direccion}', Pr_InfoEmpleado.DIRECCION);
                    Lv_Subject := Lr_ParamRequest.Lv_Valor3;
                WHEN 'EMP_SYNC_SAL' THEN
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_Plantilla, '${displayName}', Lr_LdapEntity.DISPLAY_NAME);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cargo}', Lr_LdapEntity.CARGO);
		    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cedula}', Lr_LdapEntity.CEDULA);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${idNumber}', Lr_LdapEntity.GID_NUMBER);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${uid}', Lr_LdapEntity.UID);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${mail}', Lr_LdapEntity.MAIL);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${departamento}', Pr_InfoEmpleado.DEP_DESCRI);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${sangre}', Pr_InfoEmpleado.SANGRE);
		    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${direccion}', Pr_InfoEmpleado.DIRECCION);
                    Lv_Subject := Lr_ParamRequest.Lv_Valor4;
                WHEN 'EMP_SYNC_ERR' THEN
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_Plantilla, '${nombres}', 'Alexander');
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_Plantilla, '${displayName}', Lr_LdapEntity.DISPLAY_NAME);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cargo}', Lr_LdapEntity.CARGO);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${cedula}', Lr_LdapEntity.CEDULA);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${idNumber}', Lr_LdapEntity.GID_NUMBER);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${uid}', Lr_LdapEntity.UID);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${mail}', Lr_LdapEntity.MAIL);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${departamento}', Pr_InfoEmpleado.DEP_DESCRI);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${sangre}', Pr_InfoEmpleado.SANGRE);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_MessageMail, '${direccion}', Pr_InfoEmpleado.DIRECCION);
                    Lc_MessageMail := RHKG_SINCRONIZAR_EMPLEADO.F_CLOB_REPLACES(Lc_Plantilla, '${error}', Pv_Mensaje);
                    Lv_Subject := Lr_ParamRequest.Lv_Valor5;
            END CASE;
            P_INFO('P_ENVIA_NOTIFICACION', '1', 'Send', 'Subject ' || Lv_Subject || ' Codigo ' || Pv_CodigoPlantilla || ' alias ' || Lv_Alias, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Envio de correo', Gv_User);

            UTL_MAIL.SEND(SENDER => Lr_ParamRequest.Lv_Valor1, RECIPIENTS => Lv_Alias, SUBJECT => Lv_Subject, MESSAGE => SUBSTR(Lc_MessageMail, 1, 32767
            ), MIME_TYPE => 'text/html; charset=UTF-8');

        END IF;

        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Envio notificacion';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
            P_ERROR('P_ENVIA_NOTIFICACION', '0', 'OTHERS', 'Alias ' || Lv_Alias, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
    END P_ENVIA_NOTIFICACION;

  PROCEDURE P_SINCRIONIZACION_EMPLEADO(Pn_NoEmp  IN ARPLME.NO_EMPLE%TYPE,
                                       Pn_NoCIa  IN ARPLME.NO_CIA%TYPE,
                                       Pv_Status OUT VARCHAR2,
                                       Pv_Code   OUT VARCHAR2,
                                       Pv_Msn    OUT VARCHAR2) AS
    /**
    * Consulta vista empleados
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    * @costo 6, cardinalidad 1
    */

    CURSOR C_InfoEmpleado(Cv_NoCia V_INFO_EMPLEADO.NO_CIA%TYPE,
                          Cv_NoEmp V_INFO_EMPLEADO.NO_EMPLE%TYPE) IS
      SELECT VE.*
        FROM V_INFO_EMPLEADO VE
       WHERE VE.NO_CIA = Cv_NoCia
         AND VE.NO_EMPLE = Cv_NoEmp;

    CURSOR C_getParametros (cv_nombre_parametro VARCHAR2,cv_descripcion VARCHAR2) IS
    SELECT
        valor1,
        valor2
    FROM
        db_general.admi_parametro_cab   apc,
        db_general.admi_parametro_det   apt
    WHERE
        apc.id_parametro = apt.parametro_id
        AND apc.nombre_parametro = cv_nombre_parametro
        AND apt.descripcion = cv_descripcion
        AND apt.estado      = 'Activo';   

    CURSOR C_getIdPersonaEmpresaRol (cv_login VARCHAR2) IS
    SELECT ID_PERSONA_ROL FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER2 WHERE IPER2.ID_PERSONA_ROL = (
    SELECT MAX(ID_PERSONA_ROL) FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER WHERE IPER.PERSONA_ID IN (
    SELECT ID_PERSONA FROM DB_COMERCIAL.INFO_PERSONA WHERE ID_PERSONA = (
    SELECT MAX(ID_PERSONA) FROM DB_COMERCIAL.INFO_PERSONA WHERE LOWER(LOGIN) = LOWER(cv_login)))
    AND IPER.DEPARTAMENTO_ID IN (SELECT ID_DEPARTAMENTO FROM DB_COMERCIAL.ADMI_DEPARTAMENTO WHERE EMPRESA_COD = '10'));

    Lc_InfoEmpleado     C_InfoEmpleado%ROWTYPE;
    Lv_Login            VARCHAR2(100) := '';
    Lv_DN_1             VARCHAR2(4000) := '';
    Lv_DN_2             VARCHAR2(4000) := '';
    Lv_Status           VARCHAR2(15) := '';
    Lv_Code             VARCHAR2(5) := '';
    Lv_Msn              VARCHAR2(4000) := '';
    Lv_StatusII         VARCHAR2(15) := '';
    Lv_CodeII           VARCHAR2(5) := '';
    Lv_MsnII            VARCHAR2(4000) := '';
    Lv_Token            VARCHAR2(4000) := '';
    Lv_Urn              VARCHAR2(4000) := '';
    Lv_IdZimbra         VARCHAR2(250) := '';
    Lr_LdapEntity       GEKG_TYPE.Lr_LdapEntity;
    Lv_Request          VARCHAR2(32766) := '';
    Lv_Result           VARCHAR2(32766) := '';
    Lb_LetsCreate       BOOLEAN := FALSE;
    Lb_LetsUpdate       BOOLEAN := FALSE;
    Lb_LetsInsert       BOOLEAN := FALSE;
    Lb_LetsDelete       BOOLEAN := FALSE;
    Ln_IdPersona        NUMBER := 0;
    Ln_Oficina          NUMBER := 0;
    Lr_InfoOficinaGrupo DB_COMERCIAL.INFO_OFICINA_GRUPO%ROWTYPE;
    Lr_InfoPersona      DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona;
    Le_Fail EXCEPTION;

    /*Variables para el proceso del TACACS*/
    Lv_Metodo               VARCHAR2(20);
    Lv_Version              VARCHAR2(20);
    Lv_Aplicacion           VARCHAR2(50);
    Lc_Json                 CLOB;
    Lhttp_Request           UTL_HTTP.req;
    Lhttp_Response          UTL_HTTP.resp;
    Lv_Data                 VARCHAR2(4000);         
    Lv_Url_eliminarTacacs   VARCHAR2(300) := 'http://test-apps1.telconet.ec/deleteUserTacacs'; 
    Lv_bandera_cod          VARCHAR2(5):= 'S';
    Ln_idPersonaEmpresaRol  NUMBER:= 0;

  BEGIN
    /*Inicializa LOG*/
    Gv_LetLOG := F_PARAM('LOGGER_APP_SINC_EMPL_NAF_TELCOS', 'Activo', 'Activo');
    /*Inicializa user*/
    Gv_User := F_PARAM('USER_APP_SINC_EMPL_NAF_TELCOS', 'Activo', 'Activo');
    P_INFO('P_SINCRIONIZACION_EMPLEADO', '1', 'Start', 'Init process', GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Inicio del proceso', Gv_User);
    /*Busca informacion de emplado*/
    IF C_InfoEmpleado%ISOPEN THEN
      CLOSE C_InfoEmpleado;
    END IF;
    OPEN C_InfoEmpleado(Pn_NoCIa, Pn_NoEmp);
    FETCH C_InfoEmpleado
      INTO Lc_InfoEmpleado;
    IF C_InfoEmpleado%NOTFOUND THEN
      Lv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
      Lv_Code   := GEKG_TYPE.NOT_FOUND_CODE;
      Lv_Msn    := 'Empleyee not Found cursor';
      RAISE Le_Fail;
    END IF;

    CLOSE C_InfoEmpleado;
    /*Cuando empleado no tiene LOGIN */
    IF Lc_InfoEmpleado.LOGIN IS NULL THEN
      P_INFO('P_SINCRIONIZACION_EMPLEADO', '2', 'Find LDAP cedula', Lc_InfoEmpleado.CEDULA, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Busca por cedula', Gv_User);
      /*Lc_InfoEmpleado.LOGIN*/
      /**Se busca objeto LDAP por cedula**/
      RHKG_LOGIN_EMPLEADO_C.P_FIND_ENTITY_LDAP('cedula',
                                               Lc_InfoEmpleado.CEDULA,
                                               Lv_Login,
                                               Lv_Result,
                                               Lv_Status,
                                               Lv_Code,
                                               Lv_Msn);
      IF GEKG_TYPE.FAILED_STATUS = Lv_Status THEN
          RAISE Le_Fail;
      END IF;
    ELSE
      P_INFO('P_SINCRIONIZACION_EMPLEADO', '2', 'Find LDAP uid', Lc_InfoEmpleado.LOGIN, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Busca por uid', Gv_User);
      /**Se busca objeto LDAP por uid**/
      RHKG_LOGIN_EMPLEADO_C.P_FIND_ENTITY_LDAP('uid',
                                               Lc_InfoEmpleado.LOGIN,
                                               Lv_Login,
                                               Lv_Result,
                                               Lv_Status,
                                               Lv_Code,
                                               Lv_Msn);
      IF GEKG_TYPE.FAILED_STATUS = Lv_Status THEN
          RAISE Le_Fail;
      END IF;

    END IF; /*Lc_InfoEmpleado.LOGIN*/
    P_INFO('P_SINCRIONIZACION_EMPLEADO', '3', 'Find LDAP result', Lv_Login, Lv_Status, Lv_Code, Lv_Result, Gv_User);

    IF Lv_Status NOT IN
       (GEKG_TYPE.FOUND_STATUS, GEKG_TYPE.NOT_FOUND_STATUS) THEN
      /*Lv_Status NOT IN*/
      Lv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
      Lv_Code   := GEKG_TYPE.NOT_FOUND_CODE;
      Lv_Msn    := 'Employee LDAP not Found';
      RAISE Le_Fail;
    END IF; /*Lv_Status NOT IN*/

    CASE Lv_Status
    /**Si no se encuentra el objeto LDAP, se genera un LOGIN y se envia a crear el objeto**/
      WHEN GEKG_TYPE.NOT_FOUND_STATUS THEN
        Lv_Login := RHKG_LOGIN_EMPLEADO_C.F_RESULT_LOGIN(Lc_InfoEmpleado.NO_EMPLE,
                                                         Pn_NoCIa,
                                                         Lv_Status,
                                                         Lv_Code,
                                                         Lv_Msn);
        P_INFO('P_SINCRIONIZACION_EMPLEADO', '3.1', 'F_RESULT_LOGIN-NOT_FOUND_STATUS', Lv_Login, Lv_Status, GEKG_TYPE.NONE_CODE, Lv_Result, Gv_User);
        IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
          /*GEKG_TYPE.GENERATED_STATUS = Lv_Status*/
          RAISE Le_Fail;
        END IF; /*GEKG_TYPE.GENERATED_STATUS = Lv_Status*/
        Lb_LetsCreate := TRUE;
      WHEN GEKG_TYPE.FOUND_STATUS THEN
        P_INFO('P_SINCRIONIZACION_EMPLEADO', '3.1', 'F_RESULT_LOGIN-FOUND_STATUS', Lv_Login, Lv_Status, GEKG_TYPE.NONE_CODE, Lv_Result, Gv_User);
        IF Lv_Login IS NULL OR Lv_Login = '' THEN
          /*Lv_Login IS NULL OR Lv_Login = ''*/
          RAISE Le_Fail;
        END IF; /*Lv_Login IS NULL OR Lv_Login = ''*/
        /**Obtenemos el DN actual**/
        APEX_JSON.PARSE(Lv_Result);
        Lv_DN_1       := APEX_JSON.GET_VARCHAR2('object.dnStr');
        Lb_LetsUpdate := TRUE;
    END CASE;

    Lc_InfoEmpleado.LOGIN := Lv_Login;
    P_INFO('P_SINCRIONIZACION_EMPLEADO', '4', 'Find LDAP login', Lc_InfoEmpleado.LOGIN || ' ' || Lv_DN_1, GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Resultado final de la busqueda de LOGIN', Gv_User);
    /**Se prepara entidad LDAP**/
    Lr_LdapEntity := RHKG_PREPARE_TELCOS_OBJECTS_T.F_PREPARE_ENTITY_LDAP(Lc_InfoEmpleado.LOGIN,
                                                                         Pn_NoCIa,
                                                                         Lc_InfoEmpleado,
                                                                         Lv_Status,
                                                                         Lv_Code,
                                                                         Lv_Msn);
    /**Valida que la preparacion de objeto LDAP sea correcta **/

    IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
      RAISE Le_Fail;
    END IF;
    Lr_LdapEntity.USER_PASSWORD := NULL;
    /**Genera password cuando el empleado se va a crear**/
    IF Lb_LetsCreate AND Lc_InfoEmpleado.ESTADO = GEKG_TYPE.ACTIVO THEN
      Lr_LdapEntity.USER_PASSWORD := RHKG_LOGIN_EMPLEADO_C.F_GENERATE_PASSWORD(Lc_InfoEmpleado.LOGIN,
                                                                               'STRING_PASSWD',
                                                                               Lv_Status,
                                                                               Lv_Code,
                                                                               Lv_Msn);

    END IF;
    /**Crea el request**/

    Lv_Request := RHKG_LOGIN_EMPLEADO_C.F_CREATE_JSON_ENTITY_LDAP(Lr_LdapEntity);
    /**Levanta excepcion cuando no se genera el JSON**/
    IF GEKG_TYPE.FAILED_STATUS = Lv_Request THEN
      RAISE Le_Fail;
    END IF;

    Lv_DN_2      := RHKG_LOGIN_EMPLEADO_C.F_CREATE_JSON_DN_LDAP(Lr_LdapEntity);
    /**Crea empleado**/
    IF Lb_LetsCreate AND Lc_InfoEmpleado.ESTADO = GEKG_TYPE.ACTIVO THEN
      P_REQUEST('P_SINCRIONIZACION_EMPLEADO', '5', 'REQUEST_CREATE_LDAP', Lv_Request , GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, Lv_Request, Gv_User);
      RHKG_LOGIN_EMPLEADO_C.P_MAKE_REQUEST_REST(Lv_Request,
                                                'REQUEST_CREATE_LDAP',
                                                Lv_Result,
                                                Lv_Status,
                                                Lv_Code,
                                                Lv_Msn);
     P_RESPONSE('P_SINCRIONIZACION_EMPLEADO', '6', 'REQUEST_CREATE_LDAP', Lv_Result, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
      IF Lv_Status NOT IN
         (GEKG_TYPE.FOUND_STATUS, GEKG_TYPE.CREATED_STATUS) THEN
        /*Lv_Status NOT IN*/
       RAISE Le_Fail;
      END IF; /*Lv_Status NOT IN*/


      IF Pn_NoCIa = F_GET_PARAM('USE_ZIMBRA') THEN
          ZIMBRA.P_GET_TOKEN_AUTH(Lv_Token, Lv_Status, Lv_Code, Lv_Msn);
          IF GEKG_TYPE.OK_STATUS <> Lv_Status THEN
              RAISE Le_Fail;
          END IF;
          ZIMBRA.P_GET_ACCOUNT_INFO(Lv_Token, Lr_LdapEntity.MAIL, Lv_IdZimbra, Lv_Status, Lv_Code, Lv_Msn);

          IF GEKG_TYPE.OK_STATUS <> Lv_Status THEN
              Lv_Urn := F_GET_PARAM('CREATE_UPDATE_URN_ZIMBRA');
              Lv_Urn := REPLACE(Lv_Urn, '${dn}', Lv_DN_2);
              Lv_Urn := REPLACE(Lv_Urn, '${displayName}', Lr_LdapEntity.DISPLAY_NAME);
              Lv_Urn := REPLACE(Lv_Urn, '${givenName}', Lr_LdapEntity.CN);
              ZIMBRA.P_ACCOUNT_CREATE(Lv_Token, Lr_LdapEntity.MAIL, Lr_LdapEntity.USER_PASSWORD, Lv_Urn, Lv_IdZimbra, Lv_Status, Lv_Code, Lv_Msn);

          END IF;
      END IF;

    END IF;
    /**Actualiza empleado**/

    IF Lb_LetsUpdate AND Lc_InfoEmpleado.ESTADO = GEKG_TYPE.ACTIVO THEN
      P_REQUEST('P_SINCRIONIZACION_EMPLEADO', '5', 'REQUEST_UPDATE_LDAP', Lv_Request , GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, Lv_Request, Gv_User);
      RHKG_LOGIN_EMPLEADO_C.P_MAKE_REQUEST_REST(Lv_Request,
                                                'REQUEST_UPDATE_LDAP',
                                                Lv_Result,
                                                Lv_Status,
                                                Lv_Code,
                                                Lv_Msn);
      P_RESPONSE('P_SINCRIONIZACION_EMPLEADO', '6', 'REQUEST_UPDATE_LDAP', Lv_Result, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
      IF Lv_Status <> GEKG_TYPE.UPDATED_STATUS THEN
        /*Lv_Status <> GEKG_TYPE.UPDATED_STATUS  */
       RAISE Le_Fail;
     END IF; /*Lv_Status <> GEKG_TYPE.UPDATED_STATUS  */

      IF Pn_NoCIa = F_GET_PARAM('USE_ZIMBRA') THEN
          ZIMBRA.P_GET_TOKEN_AUTH(Lv_Token, Lv_Status, Lv_Code, Lv_Msn);
          IF GEKG_TYPE.OK_STATUS <> Lv_Status THEN
              RAISE Le_Fail;
          END IF;
          ZIMBRA.P_GET_ACCOUNT_INFO(Lv_Token, Lr_LdapEntity.MAIL, Lv_IdZimbra, Lv_Status, Lv_Code, Lv_Msn);

          Lv_Urn := F_GET_PARAM('CREATE_UPDATE_URN_ZIMBRA');
          Lv_Urn := REPLACE(Lv_Urn, '${dn}', Lv_DN_2);
          Lv_Urn := REPLACE(Lv_Urn, '${displayName}', Lr_LdapEntity.DISPLAY_NAME);
          Lv_Urn := REPLACE(Lv_Urn, '${givenName}', Lr_LdapEntity.CN);
          Lv_Urn := REPLACE(Lv_Urn, '${sn}', Lr_LdapEntity.SN);
          IF GEKG_TYPE.OK_STATUS = Lv_Status THEN
              ZIMBRA.P_ACCOUNT_MODIFY(Lv_Token, Lv_IdZimbra, Lv_Urn, Lv_Status, Lv_Code, Lv_Msn);
          ELSIF 'account.NO_SUCH_ACCOUNT' = Lv_Msn THEN
              ZIMBRA.P_ACCOUNT_CREATE(Lv_Token, Lr_LdapEntity.MAIL, 'PbTh-D=vu=', Lv_Urn, Lv_IdZimbra, Lv_Status, Lv_Code, Lv_Msn);
          END IF;
        END IF;

    END IF;
    /**Elimina empleado**/
    IF Lb_LetsUpdate AND Lc_InfoEmpleado.ESTADO = GEKG_TYPE.INACTIVO THEN
      Lv_Request := RHKG_LOGIN_EMPLEADO_C.F_GET_JSON_FIND_EMP('uid',
                                                              Lc_InfoEmpleado.LOGIN);
      P_REQUEST('P_SINCRIONIZACION_EMPLEADO', '5', 'REQUEST_DELETE_LDAP', Lv_Request , GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, Lv_Request, Gv_User);
      RHKG_LOGIN_EMPLEADO_C.P_MAKE_REQUEST_REST(Lv_Request,
                                                'REQUEST_DELETE_LDAP',
                                                Lv_Result,
                                                Lv_Status,
                                                Lv_Code,
                                                Lv_Msn);
      P_RESPONSE('P_SINCRIONIZACION_EMPLEADO', '6', 'REQUEST_DELETE_LDAP', Lv_Result, Lv_Status, Lv_Code, Lv_Msn, Gv_User);

     IF Lv_Status NOT IN
         (GEKG_TYPE.NOT_FOUND_STATUS, GEKG_TYPE.DELETED_STATUS) THEN
        /*Lv_Status NOT IN*/
       RAISE Le_Fail;
    END IF; /*Lv_Status NOT IN*/


      IF Pn_NoCIa = F_GET_PARAM('USE_ZIMBRA') THEN
          ZIMBRA.P_GET_TOKEN_AUTH(Lv_Token, Lv_Status, Lv_Code, Lv_Msn);
          IF GEKG_TYPE.OK_STATUS <> Lv_Status THEN
              RAISE Le_Fail;
          END IF;
          ZIMBRA.P_GET_ACCOUNT_INFO(Lv_Token, Lr_LdapEntity.MAIL, Lv_IdZimbra, Lv_Status, Lv_Code, Lv_Msn);

          IF GEKG_TYPE.OK_STATUS = Lv_Status THEN
              ZIMBRA.P_ACCOUNT_DELETE(Lv_Token, Lv_IdZimbra, Lv_Status, Lv_Code, Lv_Msn);
          END IF;
       END IF;

         OPEN C_getParametros('PARAMETROS_PROYECTO_TACACS','parametros_tacacs');
         FETCH C_getParametros INTO Lv_bandera_cod,Lv_Url_eliminarTacacs;
         CLOSE C_getParametros; 
         
       IF(Lv_bandera_cod = 'S') THEN
           /*Eliminar usuario del servidor del TACACS*/
           BEGIN                                           

              Lv_Metodo       := 'POST';
              Lv_Version      := ' HTTP/1.1';
              Lv_Aplicacion   := 'application/json';
            
              Lc_Json := '{';
              Lc_Json := Lc_Json || '"uid":"' || Lc_InfoEmpleado.LOGIN;
              Lc_Json := Lc_Json ||'"}';             
            
              Lhttp_Request := UTL_HTTP.begin_request(Lv_Url_eliminarTacacs,Lv_Metodo,Lv_Version);    
              UTL_HTTP.set_body_charset( Lhttp_Request, 'utf-8');
              UTL_HTTP.set_header(Lhttp_Request, 'Content-Type', Lv_Aplicacion);
              UTL_HTTP.set_header(Lhttp_Request, 'Accept', Lv_Aplicacion);
              UTL_HTTP.set_header(Lhttp_Request, 'Content-Length', LENGTH(Lc_Json));      
              UTL_HTTP.write_text(Lhttp_Request, Lc_Json);
            
              Lhttp_Response := UTL_HTTP.get_response(Lhttp_Request);
              UTL_HTTP.end_response(Lhttp_Response);  

              --Se consulta el id_persona_empresa_rol del empleado a eliminar
              IF C_getIdPersonaEmpresaRol%ISOPEN THEN
	          CLOSE C_getIdPersonaEmpresaRol;
	      END IF;
	      OPEN C_getIdPersonaEmpresaRol(Lc_InfoEmpleado.LOGIN);
		 FETCH C_getIdPersonaEmpresaRol
		   INTO Ln_idPersonaEmpresaRol;
	      IF C_getIdPersonaEmpresaRol%NOTFOUND THEN
		   Ln_idPersonaEmpresaRol := 0;
	      END IF;

	      --Se registra la accion en la tabla DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO
	      insert into DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO
	      (ID_PERSONA_EMPRESA_ROL_HISTO,
	      USR_CREACION,
	      FE_CREACION,
	      IP_CREACION,
	      ESTADO,
              PERSONA_EMPRESA_ROL_ID,
	      OBSERVACION,
	      MOTIVO_ID)
	      values(DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.nextval,
                        'NAF47_TNET',
			SYSDATE,
			GEK_CONSULTA.F_RECUPERA_IP,
			'Activo',
			Ln_idPersonaEmpresaRol,
			'Se quitaron los accesos en el servidor TACACS para el usuario: '|| Lc_InfoEmpleado.LOGIN,
			(select id_motivo from DB_GENERAL.ADMI_MOTIVO where nombre_motivo = 'Actualizar accesos de usuario' and estado = 'Activo'));

	   COMMIT;
      
           EXCEPTION
           WHEN OTHERS THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF', 'RHKG_SINCRONIZAR_EMPLEADO.P_SINCRIONIZACION_EMPLEADO', 
                                            SQLERRM, 
                                            GEK_CONSULTA.F_RECUPERA_LOGIN,
                                            SYSDATE, 
                                            GEK_CONSULTA.F_RECUPERA_IP);
           END;
           /*Eliminar usuario del servidor del TACACS*/       
       END IF;


    END IF;
    DB_COMERCIAL.CMKG_INFO_OFICINA_GRUPO_C.P_GET_INFO_OFICINA_GRUPO(Lc_InfoEmpleado.OFICINA,
                                                                    Pn_NoCIa,
                                                                    'Activo',
                                                                    Lr_InfoOficinaGrupo,
                                                                    Lv_Status,
                                                                    Lv_Code,
                                                                    Lv_Msn);
    Ln_Oficina   := Lr_InfoOficinaGrupo.ID_OFICINA;

    P_INFO('P_SINCRIONIZACION_EMPLEADO', '7', 'RHKG_MERGE_TELCOS_NAF_OBJS_T.P_MERGE_INFO_TELCOS', Lc_InfoEmpleado.LOGIN , GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, 'Envia hacer merge con objetos telcos y naf', Gv_User);
    RHKG_MERGE_TELCOS_NAF_OBJS_T.P_MERGE_INFO_TELCOS(Lc_InfoEmpleado.LOGIN, Pn_NoCIa, Lr_LdapEntity.MAIL, Lc_InfoEmpleado, Lr_LdapEntity.USER_PASSWORD
    , Lv_Status, Lv_Code, Lv_Msn);
    P_INFO('P_SINCRIONIZACION_EMPLEADO', '8', 'RHKG_MERGE_TELCOS_NAF_OBJS_T.P_MERGE_INFO_TELCOS', Lc_InfoEmpleado.LOGIN , Lv_Status, Lv_Code, Lv_Msn, Gv_User);
    IF GEKG_TYPE.GENERATED_STATUS <> Lv_Status THEN
        IF Lb_LetsCreate AND Lc_InfoEmpleado.ESTADO = GEKG_TYPE.ACTIVO THEN
          Lv_Request := RHKG_LOGIN_EMPLEADO_C.F_GET_JSON_FIND_EMP('uid',
                                                                  Lc_InfoEmpleado.LOGIN);
          P_REQUEST('P_SINCRIONIZACION_EMPLEADO', '8.1', 'P_MERGE_INFO_TELCOS-REQUEST_DELETE_LDAP', Lv_Request , GEKG_TYPE.NONE_STATUS, GEKG_TYPE.NONE_CODE, Lv_Request, Gv_User);
          RHKG_LOGIN_EMPLEADO_C.P_MAKE_REQUEST_REST(Lv_Request,
                                                    'REQUEST_DELETE_LDAP',
                                                    Lv_Result,
                                                    Lv_StatusII,
                                                    Lv_CodeII,
                                                    Lv_MsnII);
          P_RESPONSE('P_SINCRIONIZACION_EMPLEADO', '8.2', 'P_MERGE_INFO_TELCOS-REQUEST_DELETE_LDAP', Lv_Result, Lv_StatusII, Lv_CodeII, Lv_MsnII, Gv_User);
        END IF;
        RAISE Le_Fail;
    END IF;
    DB_COMERCIAL.CMKG_INFO_PERSONA_C.P_FIND_PERSONA_BY_IDENT(Lc_InfoEmpleado.CEDULA,
                                                             Lr_InfoPersona,
                                                             Lv_Status,
                                                             Lv_Code,
                                                             Lv_Msn);

    Ln_IdPersona := Lr_InfoPersona.ID_PERSONA;
    /*Inserta perfiles*/

    IF Lb_LetsCreate AND Lc_InfoEmpleado.ESTADO = GEKG_TYPE.ACTIVO THEN
      DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_DELETE_PERFIL_PERSONA(Ln_IdPersona,
                                                                      Lv_Status,
                                                                      Lv_Code,
                                                                      Lv_Msn);
      P_INFO('P_SINCRIONIZACION_EMPLEADO', '9', 'DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_DELETE_PERFIL_PERSONA', 'ID_PERSONA ' || Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
      DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_INSERT_PERFIL_PER_SINC_EMPL(Pn_NoCIa,
                                                                            Ln_IdPersona,
                                                                            Ln_Oficina,
                                                                            F_GET_PARAM('USER_APP_SINC_EMPL_NAF_TELCOS'),
                                                                            Lv_Status,
                                                                            Lv_Code,
                                                                            Lv_Msn);
      P_INFO('P_SINCRIONIZACION_EMPLEADO', '10', 'DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_INSERT_PERFIL_PER_SINC_EMPL', 'ID_PERSONA ' || Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn, Gv_User);

      P_ENVIA_NOTIFICACION('EMP_SYNC_ING', Lc_InfoEmpleado.MAIL || ';', Lr_LdapEntity.USER_PASSWORD, Lc_InfoEmpleado, Lr_LdapEntity, '', Lv_StatusII, Lv_CodeII, Lv_MsnII);
    END IF;
    /**Cuando se cambia de departamento se elminan perfiles y se crean por default**/

    IF Lb_LetsUpdate AND Lc_InfoEmpleado.ESTADO = GEKG_TYPE.ACTIVO THEN
      IF Lv_DN_1 <> Lv_DN_2 THEN
        DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_DELETE_PERFIL_PERSONA(Ln_IdPersona,
                                                                        Lv_Status,
                                                                        Lv_Code,
                                                                        Lv_Msn);
        P_INFO('P_SINCRIONIZACION_EMPLEADO', '9', 'DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_DELETE_PERFIL_PERSONA <> DN', 'ID_PERSONA ' || Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
        DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_INSERT_PERFIL_PER_SINC_EMPL(Pn_NoCIa,
                                                                              Ln_IdPersona,
                                                                              Ln_Oficina,
                                                                              F_GET_PARAM('USER_APP_SINC_EMPL_NAF_TELCOS'),
                                                                              Lv_Status,
                                                                              Lv_Code,
                                                                              Lv_Msn);
        P_INFO('P_SINCRIONIZACION_EMPLEADO', '10', 'DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_DELETE_PERFIL_PERSONA', 'ID_PERSONA ' || Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn, Gv_User);

      END IF;
      P_ENVIA_NOTIFICACION('EMP_SYNC_ACT', Lr_LdapEntity.MAIL || ';', Lr_LdapEntity.USER_PASSWORD, Lc_InfoEmpleado, Lr_LdapEntity, '', Lv_StatusII, Lv_CodeII, Lv_MsnII);
    END IF;
    /*Elimina perfiles*/

    IF Lb_LetsUpdate AND Lc_InfoEmpleado.ESTADO = GEKG_TYPE.INACTIVO THEN
      DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_DELETE_PERFIL_PERSONA(Ln_IdPersona,
                                                                      Lv_Status,
                                                                      Lv_Code,
                                                                      Lv_Msn);
      P_INFO('P_SINCRIONIZACION_EMPLEADO', '9', 'DB_SEGURIDAD.SEKG_SEGU_PERFIL_PERSONA_T.P_DELETE_PERFIL_PERSONA DELETE', 'ID_PERSONA ' || Ln_IdPersona, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
      P_ENVIA_NOTIFICACION('EMP_SYNC_SAL', Lc_InfoEmpleado.MAIL || ';', Lr_LdapEntity.USER_PASSWORD, Lc_InfoEmpleado, Lr_LdapEntity, '', Lv_StatusII, Lv_CodeII, Lv_MsnII);
    END IF;

    COMMIT;

    BEGIN
        DB_COMERCIAL.CMKG_ARCHIVOS_EMPLEADOS.P_GUARDAR_FOTO_EMPLEADO(Lc_InfoEmpleado.CEDULA,
                                                                      Pn_NoCIa,
                                                                      'NAF',
                                                                      Lv_Code,
                                                                      Lv_Msn);
        exception
        when others then
        null;
    END;


    Pv_Status := GEKG_TYPE.GENERATED_STATUS;
    Pv_Code   := GEKG_TYPE.GENERATED_CODE;
    Pv_Msn    := 'Se realizo la sincronizacion correctamente';
  EXCEPTION
    WHEN Le_Fail THEN
      Pv_Status := Lv_Status;
      Pv_Code   := Lv_Code;
      Pv_Msn    := Lv_Msn;
      P_ERROR('P_SINCRIONIZACION_EMPLEADO', '0', 'Le_Fail', 'CEDULA ' || Lc_InfoEmpleado.CEDULA, Lv_Status, Lv_Code, Lv_Msn, Gv_User);
      P_ENVIA_NOTIFICACION('EMP_SYNC_ERR', '', Lr_LdapEntity.USER_PASSWORD, Lc_InfoEmpleado, Lr_LdapEntity, Lv_Status
                                                                                                            || ' '
                                                                                                            || Lv_Code
                                                                                                            || ' '
                                                                                                            || Lv_Msn, Lv_StatusII, Lv_CodeII, Lv_MsnII
                                                                                                            );
    WHEN OTHERS THEN
      Pv_Status := GEKG_TYPE.FAILED_STATUS;
      Pv_Code   := GEKG_TYPE.FAILED_CODE;
      Pv_Msn    := SQLERRM;
      P_ERROR('P_SINCRIONIZACION_EMPLEADO', '0', 'OTHERS', 'CEDULA ' || Lc_InfoEmpleado.CEDULA, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
      P_ENVIA_NOTIFICACION('EMP_SYNC_ERR', '', Lr_LdapEntity.USER_PASSWORD, Lc_InfoEmpleado, Lr_LdapEntity, Lv_Status
                                                                                                            || ' '
                                                                                                            || Lv_Code
                                                                                                            || ' '
                                                                                                            || Lv_Msn, Lv_StatusII, Lv_CodeII, Lv_MsnII
                                                                                                            );
  END P_SINCRIONIZACION_EMPLEADO;

END RHKG_SINCRONIZAR_EMPLEADO;
/
