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
  /*  FUNCTION F_PARAM (
        Fv_Nombre      IN             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
        Fv_EstadoCab   IN             DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
        Fv_EstadoDet   IN             DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
    ) RETURN VARCHAR2;

  \**
   * Inserta un log tipo INFO en INFO_LOGGER
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @version 1.0 20-10-2018
   * @return
  **\

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

  \**
   * Inserta un log tipo ERROR en INFO_LOGGER
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @version 1.0 20-10-2018
   * @return
  **\

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

  \**
   * Inserta un log tipo WARNING en INFO_LOGGER
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @version 1.0 20-10-2018
   * @return
  **\

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

  \**
   * Inserta un log tipo REQUEST en INFO_LOGGER
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @version 1.0 20-10-2018
   * @return
  **\

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

  \**
   * Inserta un log tipo RESPONSE en INFO_LOGGER
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @version 1.0 20-10-2018
   * @return
  **\

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

    \**
    * Documentacion para la funcion F_CLOB_REPLACE
    * la funcion F_CLOB_REPLACE realiza el replace entre CLOBS
    *
    * @param  Fc_String  IN CLOB      Recibe el CLOB al cual se requiere hacer un replace
    * @param  Fv_Search  IN VARCHAR   Recibe string a buscar en el CLOB
    * @param  Fc_Replace IN CLOB      Recibe el CLOB con el que se hara el replace
    * @return CLOB                    Retorna el CLOB al cual se ha hecho el replace
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 09-12-2018
    *\
    \*
    FUNCTION F_CLOB_REPLACES (
        Fc_String    IN           CLOB,
        Fv_Search    IN           VARCHAR2,
        Fc_Replace   IN           CLOB
    ) RETURN CLOB;
*\
  \**
  * Obtiene un parametro de configuracion
  * @param Fv_NombreParametro   IN Nombre de parametro
  * @author Alexander Samaniego <awsamaniego@telconet.ec>
  * @version 1.0 20-10-2018
  **\
*/
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
      /*
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
    
    */
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
    ) ;

END RHKG_SINCRONIZAR_EMPLEADO;
/
CREATE OR REPLACE PACKAGE BODY NAF47_TNET.RHKG_SINCRONIZAR_EMPLEADO AS

    /*FUNCTION F_PARAM (
        Fv_Nombre      IN             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
        Fv_EstadoCab   IN             DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
        Fv_EstadoDet   IN             DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
    ) RETURN VARCHAR2 AS
        \*Obtiene parametros de configuracion la escritura de LOG
         *@cost 5, cardinalidad 1
         *\


    BEGIN
        \*Busca configuracion para request*\
        RETURN RHKG_SINCRONIZAR_EMPLEADO.F_PARAM@GPOETNET(Fv_Nombre => Fv_Nombre,
                                               Fv_EstadoCab => Fv_EstadoCab,
                                               Fv_EstadoDet => Fv_EstadoDet);

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

      RHKG_SINCRONIZAR_EMPLEADO.P_INFO@GPOETNET(Pv_ProcessName => Pv_ProcessName,
                                   Pv_OrderProcess => Pv_OrderProcess,
                                   Pv_InfoProcess => Pv_InfoProcess,
                                   Pv_Observation => Pv_Observation,
                                   Pv_Status => Pv_Status,
                                   Pv_Code => Pv_Code,
                                   Pv_Message => Pv_Message,
                                   Pv_Usr => Pv_Usr);
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
        RHKG_SINCRONIZAR_EMPLEADO.P_ERROR@GPOETNET(Pv_ProcessName => Pv_ProcessName,
                                                                      Pv_OrderProcess => Pv_OrderProcess,
                                                                      Pv_InfoProcess => Pv_InfoProcess,
                                                                      Pv_Observation => Pv_Observation,
                                                                      Pv_Status => Pv_Status,
                                                                      Pv_Code => Pv_Code,
                                                                      Pv_Message => Pv_Message,
                                                                      Pv_Usr => Pv_Usr);
    END P_ERROR;*/

    /*PROCEDURE P_WARNING (
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
        RHKG_SINCRONIZAR_EMPLEADO.P_WARNING@GPOETNET(Pv_ProcessName => Pv_ProcessName,
                                      Pv_OrderProcess => Pv_OrderProcess,
                                      Pv_InfoProcess => Pv_InfoProcess,
                                      Pv_Observation => Pv_Observation,
                                      Pv_Status => Pv_Status,
                                      Pv_Code => Pv_Code,
                                      Pv_Message => Pv_Message,
                                      Pv_Usr => Pv_Usr);
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

        RHKG_SINCRONIZAR_EMPLEADO.P_REQUEST@GPOETNET(Pv_ProcessName => Pv_ProcessName,
                                      Pv_OrderProcess => Pv_OrderProcess,
                                      Pv_InfoProcess => Pv_InfoProcess,
                                      Pv_Observation => Pv_Observation,
                                      Pv_Status => Pv_Status,
                                      Pv_Code => Pv_Code,
                                      Pv_Message => Pv_Message,
                                      Pv_Usr => Pv_Usr);

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
    RHKG_SINCRONIZAR_EMPLEADO.P_RESPONSE@GPOETNET(Pv_ProcessName => Pv_ProcessName,
                                       Pv_OrderProcess => Pv_OrderProcess,
                                       Pv_InfoProcess => Pv_InfoProcess,
                                       Pv_Observation => Pv_Observation,
                                       Pv_Status => Pv_Status,
                                       Pv_Code => Pv_Code,
                                       Pv_Message => Pv_Message,
                                       Pv_Usr => Pv_Usr);

    END P_RESPONSE;*/



    FUNCTION F_GET_PARAM (
        Fv_NombreParametro IN   VARCHAR2
    ) RETURN VARCHAR2 AS
    /*Obtiene parametros de configuracion para el request
    *@cost 5, cardinalidad 1
    */


    BEGIN

       return RHKG_SINCRONIZAR_EMPLEADO.F_GET_PARAM@GPOETNET(Fv_NombreParametro => Fv_NombreParametro);
    EXCEPTION
        WHEN OTHERS THEN
             
            RETURN '';
    END F_GET_PARAM;

  PROCEDURE P_SINCRIONIZACION_EMPLEADO(Pn_NoEmp  IN ARPLME.NO_EMPLE%TYPE,
                                       Pn_NoCIa  IN ARPLME.NO_CIA%TYPE,
                                       Pv_Status OUT VARCHAR2,
                                       Pv_Code   OUT VARCHAR2,
                                       Pv_Msn    OUT VARCHAR2) AS PRAGMA AUTONOMOUS_TRANSACTION;
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
    Lc_InfoEmpleado     C_InfoEmpleado%ROWTYPE;
    Le_Fail EXCEPTION;
    Lv_Status           VARCHAR2(15) := '';
    Lv_Code             VARCHAR2(5) := '';
    Lv_Msn              VARCHAR2(4000) := '';
    Lr_LdapEntity       GEKG_TYPE.Lr_LdapEntity;
  BEGIN
    
   
    
   RHKG_SINCRONIZAR_EMPLEADO.P_SINCRIONIZACION_EMPLEADO@GPOETNET(Pn_NoEmp => Pn_NoEmp,
                                                       Pn_NoCIa => Pn_NoCIa,
                                                       Pv_Status => Pv_Status,
                                                       Pv_Code => Pv_Code,
                                                       Pv_Msn => Pv_Msn);
   COMMIT;
  EXCEPTION

    WHEN OTHERS THEN
      Pv_Status := GEKG_TYPE.FAILED_STATUS;
      Pv_Code   := GEKG_TYPE.FAILED_CODE;
      Pv_Msn    := SQLERRM;
      /*
      P_ERROR('P_SINCRIONIZACION_EMPLEADO', '0', 'OTHERS', 'CEDULA ' || Lc_InfoEmpleado.CEDULA, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
      
      P_ENVIA_NOTIFICACION('EMP_SYNC_ERR', '', Lr_LdapEntity.USER_PASSWORD, Lc_InfoEmpleado, Lr_LdapEntity, Lv_Status
                                                                                                            || ' '
                                                                                                            || Lv_Code
                                                                                                            || ' '
                                                                                                            || Lv_Msn, Lv_StatusII, Lv_CodeII, Lv_MsnII
                                                                                                            );
                                                                                                            */
  END P_SINCRIONIZACION_EMPLEADO;
  /*
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
        RHKG_SINCRONIZAR_EMPLEADO.P_ENVIA_NOTIFICACION@GPOETNET(Pv_CodigoPlantilla => Pv_CodigoPlantilla,
                                                 Pv_Correo => Pv_Correo,
                                                 Pv_Password => Pv_Password,
                                                 Pr_InfoEmpleado => Pr_InfoEmpleado,
                                                 Lr_LdapEntity => Lr_LdapEntity,
                                                 Pv_Mensaje => Pv_Mensaje,
                                                 Pv_Status => Pv_Status,
                                                 Pv_Code => Pv_Code,
                                                 Pv_Msn => Pv_Msn);
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
            --P_ERROR('P_ENVIA_NOTIFICACION', '0', 'OTHERS', 'Alias ' || Lv_Alias, Pv_Status, Pv_Code, Pv_Msn, Gv_User);
    END P_ENVIA_NOTIFICACION;
    */
END RHKG_SINCRONIZAR_EMPLEADO;
/
