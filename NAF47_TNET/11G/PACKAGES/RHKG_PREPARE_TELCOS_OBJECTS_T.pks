CREATE OR REPLACE PACKAGE            RHKG_PREPARE_TELCOS_OBJECTS_T AS 
    

  /**
   * Obtiene de la base si el proceso escribe LOG o no y el usuario que escribe
   * @author Alexander Samaniego <awsamaniego@telconet.ec>
   * @version 1.0 20-10-2018
   * @return 
  **/
  FUNCTION F_PARAM(Fv_Nombre    IN DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                   Fv_EstadoCab IN DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                   Fv_EstadoDet IN DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE)
    RETURN VARCHAR2;

    /**
    * Ayudara a obtener los parametros de configuracion para hacer REQUEST REST
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    */
    TYPE Lr_ParamRequest IS RECORD (
        Lv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
        Lv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
        Lv_Valor3 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
        Lv_Valor4 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE,
        Lv_Valor5 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
        Lv_Valor6 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR6%TYPE
    );

    /**
    * Ayudara a validar los parametros de configuracion de ADMI_PARAMETRO_DET
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    */
    TYPE Tr_Validate IS
        TABLE OF INTEGER;

    /**
      * Obtiene parametros
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @param  Pv_Nombre      IN    DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
      * @param  Pv_EstadoCab   IN    DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
      * @param  Pv_EstadoDet   IN    DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
      * @param  Pv_Valor1      OUT   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE,
      * @param  Pv_Valor2      OUT   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
      * @param  Pv_Valor3      OUT   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE,
      * @param  Pv_Valor4      OUT   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE,
      * @param  Pv_Valor5      OUT   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE,
      * @param  Pv_Valor6      OUT   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR6%TYPE
     **/
    PROCEDURE P_PARAMETROS (
        Pv_Nombre         IN                DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
        Pv_EstadoCab      IN                DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
        Pv_EstadoDet      IN                DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
        Pr_ParamRequest   OUT               Lr_ParamRequest,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

    /**
      * Valida el resultado de los parametros configurados
      * @param Pr_Validate       IN                Pr_Validate     Recibe el numero de los parametros a configurar
      * @param Pr_ParamRequest   IN                Lr_ParamRequest
      * @param Pv_Status         OUT               VARCHAR2
      * @param Pv_Code           OUT               VARCHAR2
      * @param Pv_Msn            OUT               VARCHAR2
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      **/

    PROCEDURE P_VALIDATE_PARAM (
        Pr_Validate       IN                Tr_Validate,
        Pr_ParamRequest   IN                Lr_ParamRequest,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

    /**
      * Obtiene los nombres separados por un espacio y sin caracteres especiales
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
     **/

    FUNCTION F_GET_NOMBRES (
        Fv_Valor1   IN          VARCHAR2,
        Fv_Valor2   IN          VARCHAR2
    ) RETURN VARCHAR2;

    /**
      * Obtiene el departamento del empleado
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @param Fv_NoCia    IN         ARPLME.NO_CIA%TYPE
      * @param Fv_Cedula   IN         ARPLME.CEDULA%TYPE
      * @param Fv_Estado   IN         ARPLME.ESTADO%TYPE
      * @return 
     **/

    FUNCTION F_OBTIENE_DEPARTAMENTO (
        Fv_NoCia    IN          ARPLME.NO_CIA%TYPE,
        Fv_Cedula   IN          ARPLME.CEDULA%TYPE,
        Fv_Estado   IN          ARPLME.ESTADO%TYPE
    ) RETURN VARCHAR2;

    /**
      * Prepara el JSON LDAP
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @param  Fv_Login      IN VARCHAR2 Login
      * @param  Fv_NoCia      IN ARPLME.NO_CIA%TYPE Numero de compania
      * @param  Fr_LdapEntity IN V_INFO_EMPLEADO%ROWTYPE Datos de la entidad LDAP
     **/

    FUNCTION F_PREPARE_ENTITY_LDAP (
        Fv_Login        IN              VARCHAR2,
        Fv_NoCia        IN              ARPLME.NO_CIA%TYPE,
        Fr_LdapEntity   IN              V_INFO_EMPLEADO%ROWTYPE,
        Pv_Status       OUT             VARCHAR2,
        Pv_Code         OUT             VARCHAR2,
        Pv_Msn          OUT             VARCHAR2
    ) RETURN GEKG_TYPE.Lr_LdapEntity;

    /**
      * P_PREPARE_INFO_PERSONA
      * Prepara la entidad INFO_PERSONA
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    PROCEDURE P_PREPARE_INFO_PERSONA (
        Pv_Login          IN                VARCHAR2,
        Pv_NoCia          IN                ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado   IN                V_INFO_EMPLEADO%ROWTYPE,
        Pr_InfoPersona    IN OUT            DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    );

    /**
      * P_INSERTA_EN_TELCOS
      * Prepara la entidad de INFO_PERSONA_EMPRESA_ROL
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      *
      * Se valida que si INFO_PERSONA_EMPRESA_ROL tiene información
      * en los campos CUADRILLA_ID Y REPORTA_PERSONA_EMPRESA_ROL_ID
      * se actualize el registro con los mismos valores.
      * @author Douglas Natha <dnatha@telconet.ec>
      * @version 2.0 17-04-2020
      */

    PROCEDURE P_PREPARE_INFO_PERSONA_EMP_ROL (
        Pv_NoCia               IN                     ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado        IN                     V_INFO_EMPLEADO%ROWTYPE,
        Pr_InfoPersona         IN                     DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pr_InfoPersonaEmpRol   IN OUT                 DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_TYPE.Tr_InfoPersonaEmpresaRol,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    );

    /**
      * P_PREPARE_INFO_PERSONA_FORM_CONT
      * Prepara la entidad INFO_PERSONA_CONTACTO
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      */

    PROCEDURE P_PREPARE_INFO_PER_FORM_CONT (
        Pv_CodigoFormaContacto    IN                        DB_COMERCIAL.ADMI_FORMA_CONTACTO.CODIGO%TYPE,
        Pv_Valor                  IN                        DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.VALOR%TYPE,
        Pr_InfoPersona            IN                        DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pr_InfoPerFormaContacto   OUT                       DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pv_Status                 OUT                       VARCHAR2,
        Pv_Code                   OUT                       VARCHAR2,
        Pv_Msn                    OUT                       VARCHAR2
    );

END RHKG_PREPARE_TELCOS_OBJECTS_T;
/


CREATE OR REPLACE PACKAGE BODY            RHKG_PREPARE_TELCOS_OBJECTS_T AS

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

    PROCEDURE P_PARAMETROS (
        Pv_Nombre         IN                DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
        Pv_EstadoCab      IN                DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
        Pv_EstadoDet      IN                DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
        Pr_ParamRequest   OUT               Lr_ParamRequest,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS
        /*Obtiene parametros de configuracion para el request
         *@cost 5, cardinalidad 1
         */

        CURSOR C_GetParametros (
            Cv_NombreParam   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
            Cv_EstadoCab     DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
            Cv_EstadoDet     DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE
        ) IS
        SELECT
            APD.VALOR1,
            APD.VALOR2,
            APD.VALOR3,
            APD.VALOR4,
            APD.VALOR5,
            APD.VALOR6
        FROM
            DB_GENERAL.ADMI_PARAMETRO_CAB APC,
            DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE
            APC.ID_PARAMETRO = APD.PARAMETRO_ID
            AND APC.NOMBRE_PARAMETRO = Cv_NombreParam
            AND APC.ESTADO = Cv_EstadoCab
            AND APD.ESTADO = Cv_EstadoDet;

        Le_Exception EXCEPTION;
    BEGIN
        /*Busca configuracion para request*/
        IF C_GetParametros%ISOPEN THEN
            CLOSE C_GetParametros;
        END IF;
        OPEN C_GetParametros(Pv_Nombre, Pv_EstadoCab, Pv_EstadoDet);
        FETCH C_GetParametros INTO Pr_ParamRequest;
        IF C_GetParametros%NOTFOUND THEN
            RAISE Le_Exception;
        END IF;
        CLOSE C_GetParametros;
        Pv_Status := GEKG_TYPE.FOUND_STATUS;
        Pv_Code := GEKG_TYPE.FOUND_CODE;
        Pv_Msn := 'Parametros encontrados';
    EXCEPTION
        WHEN Le_Exception THEN
            Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
            Pv_Code := GEKG_TYPE.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro parametro';
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_PARAMETROS;

    PROCEDURE P_VALIDATE_PARAM (
        Pr_Validate       IN                Tr_Validate,
        Pr_ParamRequest   IN                Lr_ParamRequest,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS
    BEGIN
        Pv_Status := GEKG_TYPE.OK_STATUS;
        Pv_Code := GEKG_TYPE.OK_CODE;
        Pv_Msn := 'Parametros llenos';
        FOR I_Element IN 1..Pr_Validate.COUNT LOOP
            IF Pr_Validate(I_Element) = 1 THEN
                IF Pr_ParamRequest.Lv_Valor1 IS NULL OR TRIM(Pr_ParamRequest.Lv_Valor1) = '' THEN
                    Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
                    Pv_Code := GEKG_TYPE.NOT_FOUND_CODE;
                    Pv_Msn := 'Parametro 1 NULL';
                    EXIT;
                END IF;
            END IF;

            IF Pr_Validate(I_Element) = 2 THEN
                IF Pr_ParamRequest.Lv_Valor2 IS NULL OR TRIM(Pr_ParamRequest.Lv_Valor2) = '' THEN
                    Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
                    Pv_Code := GEKG_TYPE.NOT_FOUND_CODE;
                    Pv_Msn := 'Parametro 2 NULL';
                    EXIT;
                END IF;

            END IF;

            IF Pr_Validate(I_Element) = 3 THEN
                IF Pr_ParamRequest.Lv_Valor3 IS NULL OR TRIM(Pr_ParamRequest.Lv_Valor3) = '' THEN
                    Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
                    Pv_Code := GEKG_TYPE.NOT_FOUND_CODE;
                    Pv_Msn := 'Parametro 3 NULL';
                    EXIT;
                END IF;
            END IF;

            IF Pr_Validate(I_Element) = 4 THEN
                IF Pr_ParamRequest.Lv_Valor4 IS NULL OR TRIM(Pr_ParamRequest.Lv_Valor4) = '' THEN
                    Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
                    Pv_Code := GEKG_TYPE.NOT_FOUND_CODE;
                    Pv_Msn := 'Parametro 4 NULL';
                    EXIT;
                END IF;
            END IF;

            IF Pr_Validate(I_Element) = 5 THEN
                IF Pr_ParamRequest.Lv_Valor5 IS NULL OR TRIM(Pr_ParamRequest.Lv_Valor5) = '' THEN
                    Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
                    Pv_Code := GEKG_TYPE.NOT_FOUND_CODE;
                    Pv_Msn := 'Parametro 5 NULL';
                    EXIT;
                END IF;
            END IF;

            IF Pr_Validate(I_Element) = 6 THEN
                IF Pr_ParamRequest.Lv_Valor6 IS NULL OR TRIM(Pr_ParamRequest.Lv_Valor6) = '' THEN
                    Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
                    Pv_Code := GEKG_TYPE.NOT_FOUND_CODE;
                    Pv_Msn := 'Parametro 6 NULL';
                    EXIT;
                END IF;
            END IF;

        END LOOP;

    END P_VALIDATE_PARAM;

    FUNCTION F_GET_NOMBRES (
        Fv_Valor1   IN          VARCHAR2,
        Fv_Valor2   IN          VARCHAR2
    ) RETURN VARCHAR2 AS
    BEGIN
        RETURN RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(Fv_Valor1), 'TRANSL_1', 'TRANSL_2')
               || ' '
               || RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(Fv_Valor2), 'TRANSL_1', 'TRANSL_2');
    END F_GET_NOMBRES;

    FUNCTION F_OBTIENE_DEPARTAMENTO (
        Fv_NoCia    IN          ARPLME.NO_CIA%TYPE,
        Fv_Cedula   IN          ARPLME.CEDULA%TYPE,
        Fv_Estado   IN          ARPLME.ESTADO%TYPE
    ) RETURN VARCHAR2 AS

        /**
          * Obtiene el departamento
          * @author Alexander Samaniego <awsamaniego@telconet.ec>
          * @version 1.0 20-10-2018
          * @costo 5, cardinalidad 1
          */

        CURSOR C_GetDepartamento (
            Cv_NoCia    ARPLME.NO_CIA%TYPE,
            Cv_Cedula   ARPLME.CEDULA%TYPE,
            Cv_Estado   ARPLME.ESTADO%TYPE
        ) IS
        SELECT
            D.DESCRI   DEPARTAMENTO
        FROM
            ARPLME E,
            ARPLDP D
        WHERE
            E.NO_CIA = D.NO_CIA
            AND E.DEPTO = D.DEPA
            AND E.NO_CIA = Cv_NoCia
            AND E.CEDULA = Cv_Cedula
            AND E.ESTADO = Cv_Estado;

        Lc_GetDepartamento   C_GetDepartamento%ROWTYPE;
    BEGIN
        IF C_GetDepartamento%ISOPEN THEN
            CLOSE C_GetDepartamento;
        END IF;
        OPEN C_GetDepartamento(Fv_NoCia, Fv_Cedula, Fv_Estado);
        FETCH C_GetDepartamento INTO Lc_GetDepartamento;
        IF C_GetDepartamento%NOTFOUND THEN
            CLOSE C_GetDepartamento;
            RETURN GEKG_TYPE.NOT_FOUND_STATUS;
        END IF;
        CLOSE C_GetDepartamento;
        RETURN Lc_GetDepartamento.DEPARTAMENTO;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN GEKG_TYPE.FAILED_STATUS;
    END F_OBTIENE_DEPARTAMENTO;

    FUNCTION F_PREPARE_ENTITY_LDAP (
        Fv_Login        IN              VARCHAR2,
        Fv_NoCia        IN              ARPLME.NO_CIA%TYPE,
        Fr_LdapEntity   IN              V_INFO_EMPLEADO%ROWTYPE,
        Pv_Status       OUT             VARCHAR2,
        Pv_Code         OUT             VARCHAR2,
        Pv_Msn          OUT             VARCHAR2
    ) RETURN GEKG_TYPE.Lr_LdapEntity AS

        Lrt_LdapEntity    GEKG_TYPE.Lr_LdapEntity;
        Lv_Empty          VARCHAR2(300) := '';
        Lv_DnUsrIn        VARCHAR2(300) := '';
        Lv_DnUsr          VARCHAR2(300) := '';
        Lr_ParamRequest   RHKG_PREPARE_TELCOS_OBJECTS_T.Lr_ParamRequest;
        Lr_Validate       RHKG_PREPARE_TELCOS_OBJECTS_T.Tr_Validate;
        Le_Fail EXCEPTION;
    BEGIN
        Lrt_LdapEntity.UID := Fv_Login;
        Lrt_LdapEntity.UID_NUMBER := Fr_LdapEntity.NO_EMPLE;
        Lrt_LdapEntity.GID_NUMBER := Fr_LdapEntity.NO_EMPLE;
        Lrt_LdapEntity.USER_PASSWORD := Fv_Login;
        Lrt_LdapEntity.CN := F_GET_NOMBRES(Fr_LdapEntity.NOMBRE_PILA, Fr_LdapEntity.NOMBRE_SEGUNDO);
        Lrt_LdapEntity.SN := F_GET_NOMBRES(Fr_LdapEntity.APE_PAT, Fr_LdapEntity.APE_MAT);
        Lrt_LdapEntity.EMPRESA := REPLACE(REPLACE(Fr_LdapEntity.CIA_NOMBRE_CORTO, '.', ''), ',', '');

        Lrt_LdapEntity.PROVINCIA := REPLACE(REPLACE(Fr_LdapEntity.PRO_DESCRIPCION, '.', ''), ',', '');

        Lrt_LdapEntity.AREA := REPLACE(REPLACE(Fr_LdapEntity.ARE_DESCRI, '.', ''), ',', '');

        Lrt_LdapEntity.DEPARTAMENTO := REPLACE(REPLACE(F_OBTIENE_DEPARTAMENTO(Fv_NoCia, Fr_LdapEntity.CEDULA, Fr_LdapEntity.ESTADO), '.', ''), ',', ''

        );

        IF Lrt_LdapEntity.DEPARTAMENTO IN (
            GEKG_TYPE.NOT_FOUND_STATUS,
            GEKG_TYPE.FAILED_STATUS
        ) THEN /*Lrt_LdapEntity.DEPARTAMENTO IN (GEKG_TYPE.NOT_FOUND_STATUS, GEKG_TYPE.FAILED_STATUS)*/
            RAISE Le_Fail;
        END IF; /*Lrt_LdapEntity.DEPARTAMENTO IN (GEKG_TYPE.NOT_FOUND_STATUS, GEKG_TYPE.FAILED_STATUS)*/
        /*Obtiene el valor de la segunda posicion con la coincidencia ";"*/

        Lrt_LdapEntity.CARGO := REGEXP_SUBSTR(Fr_LdapEntity.PUESTO_, '[^;]+', 1, 2);
        Lrt_LdapEntity.DISPLAY_NAME := Lrt_LdapEntity.CN
                                       || ' '
                                       || Lrt_LdapEntity.SN;
        Lrt_LdapEntity.MAIL_BOX := Fv_Login;
        /**Buscamos parametros para generacion LDAP**/
        P_PARAMETROS('LDAP_CLASS_ATTR_ENTITY', 'Activo', 'Activo', Lr_ParamRequest, Pv_Status, Pv_Code, Pv_Msn);
        /**Validamos los 6 parametros**/
        Lr_Validate := Tr_Validate(1, 2, 3, 4, 5, 6);
        P_VALIDATE_PARAM(Lr_Validate, Lr_ParamRequest, Pv_Status, Pv_Code, Pv_Msn);
        IF GEKG_TYPE.OK_STATUS <> Pv_Status THEN
            RAISE Le_Fail;
        END IF;
        Lrt_LdapEntity.HOME_DIRECTORY := Lr_ParamRequest.Lv_Valor1;
        Lrt_LdapEntity.LOGIN_SHELL := Lr_ParamRequest.Lv_Valor2;
        Lrt_LdapEntity.OBJECT_CLASS := Lr_ParamRequest.Lv_Valor3;
        Lv_DnUsrIn := Lr_ParamRequest.Lv_Valor4;
        Lv_DnUsr := Lr_ParamRequest.Lv_Valor5;
        Lrt_LdapEntity.OBJECT_CLASS_DN := Lr_ParamRequest.Lv_Valor6;
        Lrt_LdapEntity.HOME_DIRECTORY := Lrt_LdapEntity.HOME_DIRECTORY || Fv_Login;
        Lrt_LdapEntity.MAIL := Fv_Login
                               || '@'
                               || Fr_LdapEntity.CIA_DOMINIO;
        Lrt_LdapEntity.CEDULA := Fr_LdapEntity.CEDULA;
        Lrt_LdapEntity.OU_1 := Lv_DnUsrIn;
        Lrt_LdapEntity.OU_2 := Lv_DnUsr;
        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Ldap entity';
        RETURN Lrt_LdapEntity;
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Ocurrio un error preparando LDAP entity';
            RETURN NULL;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
            RETURN NULL;
    END F_PREPARE_ENTITY_LDAP;

    PROCEDURE P_PREPARE_INFO_PERSONA (
        Pv_Login          IN                VARCHAR2,
        Pv_NoCia          IN                ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado   IN                V_INFO_EMPLEADO%ROWTYPE,
        Pr_InfoPersona    IN OUT            DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pv_Status         OUT               VARCHAR2,
        Pv_Code           OUT               VARCHAR2,
        Pv_Msn            OUT               VARCHAR2
    ) AS
        Lr_AdmiTitulo   DB_COMERCIAL.ADMI_TITULO%ROWTYPE;
        Le_Fail EXCEPTION;
    BEGIN
        Pr_InfoPersona.ORIGEN_PROSPECTO := 'N';
        Pr_InfoPersona.IDENTIFICACION_CLIENTE := Pr_InfoEmpleado.CEDULA;
        Pr_InfoPersona.NOMBRES := F_GET_NOMBRES(Pr_InfoEmpleado.NOMBRE_PILA, Pr_InfoEmpleado.NOMBRE_SEGUNDO);
        Pr_InfoPersona.APELLIDOS := F_GET_NOMBRES(Pr_InfoEmpleado.APE_PAT, Pr_InfoEmpleado.APE_MAT);
        Pr_InfoPersona.LOGIN := Pv_Login;
        Pr_InfoPersona.FECHA_NACIMIENTO := Pr_InfoEmpleado.F_NACIMI;
        Pr_InfoPersona.CALIFICACION_CREDITICIA := NULL;
        Pr_InfoPersona.DIRECCION := Pr_InfoEmpleado.DIRECCION;
        Pr_InfoPersona.DIRECCION_TRIBUTARIA := Pr_InfoEmpleado.DIRECCION;
        Pr_InfoPersona.CARGO := REGEXP_SUBSTR(Pr_InfoEmpleado.PUESTO_, '[^;]+', 1, 2);
        Pr_InfoPersona.RAZON_SOCIAL := NULL;
        Pr_InfoPersona.REPRESENTANTE_LEGAL := NULL;

        /*Setea tipo de documento por la longitud del campo CEDULA*/
        CASE LENGTH(TRIM(Pr_InfoEmpleado.CEDULA))
            WHEN GEKG_TYPE.SIZE_CEDULA THEN
                Pr_InfoPersona.TIPO_IDENTIFICACION := GEKG_TYPE.T_CEDULA;
                Pr_InfoPersona.TIPO_TRIBUTARIO := GEKG_TYPE.T_NATURAL;
            WHEN GEKG_TYPE.SIZE_RUC THEN
                Pr_InfoPersona.TIPO_IDENTIFICACION := GEKG_TYPE.T_RUC;
                Pr_InfoPersona.TIPO_TRIBUTARIO := GEKG_TYPE.T_JURIDICA;
            WHEN GEKG_TYPE.SIZE_PASAPORTE THEN
                Pr_InfoPersona.TIPO_IDENTIFICACION := GEKG_TYPE.T_PASAPORTE;
                Pr_InfoPersona.TIPO_TRIBUTARIO := GEKG_TYPE.T_NATURAL;
            ELSE
                Pr_InfoPersona.TIPO_IDENTIFICACION := GEKG_TYPE.T_CEDULA;
                Pr_InfoPersona.TIPO_TRIBUTARIO := GEKG_TYPE.T_NATURAL;
        END CASE;
        /*Setea nacionalidad segun la primer letra del campo NACION*/

        CASE SUBSTR(TRIM(Pr_InfoEmpleado.NACION), 1, 1)
            WHEN GEKG_TYPE.ECUATORIANA THEN
                Pr_InfoPersona.NACIONALIDAD := GEKG_TYPE.T_NACIONAL;
            WHEN GEKG_TYPE.EXTRANJERA THEN
                Pr_InfoPersona.NACIONALIDAD := GEKG_TYPE.T_EXTRANJERA;
        END CASE;

        /*Setea el estado segun la primer letra del campo ESTADO*/

        CASE SUBSTR(TRIM(Pr_InfoEmpleado.ESTADO), 1, 1)
            WHEN GEKG_TYPE.ACTIVO THEN
                Pr_InfoPersona.ESTADO := GEKG_TYPE.T_ACTIVO;
            WHEN GEKG_TYPE.INACTIVO THEN
                Pr_InfoPersona.ESTADO := GEKG_TYPE.T_INACTIVO;
        END CASE;

        /*Setea el estado civil segun la primer letra del campo E_CIVIL*/

        CASE SUBSTR(TRIM(Pr_InfoEmpleado.E_CIVIL), 1, 1)
            WHEN GEKG_TYPE.SOLTERO THEN
                Pr_InfoPersona.ESTADO_CIVIL := GEKG_TYPE.T_SOLTERO;
            WHEN GEKG_TYPE.CASADO THEN
                Pr_InfoPersona.ESTADO_CIVIL := GEKG_TYPE.T_CASADO;
            WHEN GEKG_TYPE.DIVORCIADO THEN
                Pr_InfoPersona.ESTADO_CIVIL := GEKG_TYPE.T_DIVORCIADO;
            WHEN GEKG_TYPE.UNION_LIBRE THEN
                Pr_InfoPersona.ESTADO_CIVIL := GEKG_TYPE.T_UNION_LIBRE;
            WHEN GEKG_TYPE.VIUDO THEN
                Pr_InfoPersona.ESTADO_CIVIL := GEKG_TYPE.T_VIUDO;
        END CASE;

        /*Setea el genereo segun la primer letra del campo SEXO*/

        CASE SUBSTR(TRIM(Pr_InfoEmpleado.SEXO), 1, 1)
            WHEN GEKG_TYPE.FEMENINO THEN
                Pr_InfoPersona.GENERO := GEKG_TYPE.T_FEMENINO;
            WHEN GEKG_TYPE.MASCULINO THEN
                Pr_InfoPersona.GENERO := GEKG_TYPE.T_MASCULINO;
        END CASE;

        IF GEKG_TYPE.T_JURIDICA = Pr_InfoPersona.TIPO_TRIBUTARIO THEN
            Pr_InfoPersona.TIPO_EMPRESA := GEKG_TYPE.T_PRIVADA;
        END IF;

        DB_COMERCIAL.CMKG_ADMI_TITULO_C.P_GET_TITULO_BY_CODIGO(Pr_InfoEmpleado.TIT_TITULO, Lr_AdmiTitulo, Pv_Status, Pv_Code, Pv_Msn);

        IF GEKG_TYPE.FOUND_STATUS <> Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
            RAISE Le_Fail;
        END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
        Pr_InfoPersona.TITULO_ID := Lr_AdmiTitulo.ID_TITULO;
        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Se genero instancia de persona';
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := Pv_Status;
            Pv_Code := Pv_Code;
            Pv_Msn := Pv_Msn;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_PREPARE_INFO_PERSONA;

    PROCEDURE P_PREPARE_INFO_PERSONA_EMP_ROL (
        Pv_NoCia               IN                     ARPLME.NO_CIA%TYPE,
        Pr_InfoEmpleado        IN                     V_INFO_EMPLEADO%ROWTYPE,
        Pr_InfoPersona         IN                     DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pr_InfoPersonaEmpRol   IN OUT                 DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_TYPE.Tr_InfoPersonaEmpresaRol,
        Pv_Status              OUT                    VARCHAR2,
        Pv_Code                OUT                    VARCHAR2,
        Pv_Msn                 OUT                    VARCHAR2
    ) AS

        Lr_AdmiDepartamento   DB_GENERAL.ADMI_DEPARTAMENTO%ROWTYPE;
        Lr_AdmiRol            DB_GENERAL.ADMI_ROL%ROWTYPE;
        Ln_IdAdmiRol          DB_GENERAL.ADMI_ROL.ID_ROL%TYPE;
        Lr_AdmiTipoRol        DB_GENERAL.ADMI_TIPO_ROL%ROWTYPE;
        Lr_InfoOficinaGrupo   DB_COMERCIAL.INFO_OFICINA_GRUPO%ROWTYPE;
        Lr_InfoEmpresaRol     DB_COMERCIAL.INFO_EMPRESA_ROL%ROWTYPE;
        Lr_InfoPerEmpresaRol  DB_COMERCIAL.V_INFO_PERSONA_EMPRESA_ROL%ROWTYPE;
        Ln_IdEmpresaRol       DB_COMERCIAL.INFO_EMPRESA_ROL.ID_EMPRESA_ROL%TYPE;
        Ln_IdTipoRol          DB_GENERAL.ADMI_TIPO_ROL.ID_TIPO_ROL%TYPE;
        Lr_GeParametros       GE_PARAMETROS%ROWTYPE;
        Ln_TipoEmpleado       V_INFO_EMPLEADO.TIPO_EMPLEADO%TYPE;
        Le_Fail EXCEPTION;
    BEGIN

        DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_C.P_GET_INFO_PERSONA_EMPR_ROL(Pr_InfoEmpleado.CEDULA, Pv_NoCia, Lr_InfoPerEmpresaRol, Pv_Status, Pv_Code, Pv_Msn);

        IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN
            RAISE Le_Fail;
        END IF;
        IF Lr_InfoPerEmpresaRol.CUADRILLA_ID IS NOT NULL AND Lr_InfoPerEmpresaRol.REPORTA_PERSONA_EMPRESA_ROL_ID IS NOT NULL THEN
          Pr_InfoPersonaEmpRol.CUADRILLA_ID := Lr_InfoPerEmpresaRol.CUADRILLA_ID;
          Pr_InfoPersonaEmpRol.REPORTA_PERSONA_EMPRESA_ROL_ID := Lr_InfoPerEmpresaRol.REPORTA_PERSONA_EMPRESA_ROL_ID;
	ELSE
          IF Lr_InfoPerEmpresaRol.REPORTA_PERSONA_EMPRESA_ROL_ID IS NOT NULL THEN
            Pr_InfoPersonaEmpRol.REPORTA_PERSONA_EMPRESA_ROL_ID := Lr_InfoPerEmpresaRol.REPORTA_PERSONA_EMPRESA_ROL_ID;
          END IF;	
        END IF;

        DB_GENERAL.GNKG_ADMI_DEPARTAMENTO_C.P_GET_ADMI_DEPARTAMENTO(Pr_InfoEmpleado.DEP_DESCRI, Pv_NoCia, Lr_AdmiDepartamento, Pv_Status, Pv_Code, Pv_Msn
        );

        IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
            RAISE Le_Fail;
        END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
        Pr_InfoPersonaEmpRol.DEPARTAMENTO_ID := Lr_AdmiDepartamento.ID_DEPARTAMENTO;
        /*El tipo empleado del NAF es el ID_TIPO_ROL, en caso de estar NULL se busca si no existe se inserta*/
        Ln_TipoEmpleado := Pr_InfoEmpleado.TIPO_EMPLEADO;
        IF Pr_InfoEmpleado.TIPO_EMPLEADO IS NULL OR Pr_InfoEmpleado.TIPO_EMPLEADO = '' THEN
            /*Busca el tipo rol en TELCOS*/
            DB_GENERAL.GNKG_ADMI_TIPO_ROL_C.P_GET_ADMI_TIPO_ROL(Pr_InfoEmpleado.TIPO_EMPLEADO_DESCRIP, Lr_AdmiTipoRol, Pv_Status, Pv_Code, Pv_Msn);

            IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
                RAISE Le_Fail;
            END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
            IF GEKG_TYPE.NOT_FOUND_STATUS = Pv_Status THEN
                Lr_AdmiTipoRol.DESCRIPCION_TIPO_ROL := Pr_InfoEmpleado.TIPO_EMPLEADO_DESCRIP;
                Lr_AdmiTipoRol.ESTADO := 'Activo';
                Lr_AdmiTipoRol.USR_CREACION := Pr_InfoPersonaEmpRol.USR_CREACION;
                Lr_AdmiTipoRol.FE_CREACION := SYSDATE;
                /*Inserta tipo rol en TELCOS*/
                DB_GENERAL.GNKG_ADMI_TIPO_ROL_T.P_INSERT_ADMI_ROL(Lr_AdmiTipoRol, Ln_IdTipoRol, Pv_Status, Pv_Code, Pv_Msn);
                IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
                    RAISE Le_Fail;
                END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
                Lr_AdmiTipoRol.ID_TIPO_ROL := Ln_IdTipoRol;
                Lr_GeParametros.ID_EMPRESA := Pv_NoCia;
                Lr_GeParametros.ID_APLICACION := 'PL';
                Lr_GeParametros.ID_GRUPO_PARAMETRO := 'TIPO_EMPL';
                Lr_GeParametros.PARAMETRO := Pr_InfoEmpleado.TIPO_EMP_NAF;
                Lr_GeParametros.PARAMETRO_ALTERNO := Lr_AdmiTipoRol.ID_TIPO_ROL;
                Lr_GeParametros.NUMERICO := NULL;
                Lr_GeParametros.NUMERICO_ALTERNO := NULL;
                Lr_GeParametros.DESCRIPCION := Pr_InfoEmpleado.TIPO_EMPLEADO_DESCRIP;
                Lr_GeParametros.ESTADO := 'A';
                Lr_GeParametros.USUARIO_CREA := Pr_InfoPersonaEmpRol.USR_CREACION;
                Lr_GeParametros.FECHA_CREA := SYSDATE;
                /*Inserta en GE_PARAMETROS del NAF*/
                GEKG_GE_PARAMETROS_T.P_INSERT_GE_PARAMETROS(Lr_GeParametros, Pv_Status, Pv_Code, Pv_Msn);
                IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
                    RAISE Le_Fail;
                END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
            END IF;

            Ln_TipoEmpleado := Lr_AdmiTipoRol.ID_TIPO_ROL;
        END IF;
        /*Buscar ROL y luego EMPRESA ROL si no los encuentra los insertara*/

        DB_GENERAL.GNKG_ADMI_ROL_C.P_GET_ADMI_ROL(Pr_InfoPersona.CARGO, Ln_TipoEmpleado, Lr_AdmiRol, Pv_Status, Pv_Code, Pv_Msn);

        IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
            RAISE Le_Fail;
        END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
        Ln_IdAdmiRol := Lr_AdmiRol.ID_ROL;
        IF GEKG_TYPE.NOT_FOUND_STATUS = Pv_Status THEN
            Lr_AdmiRol.TIPO_ROL_ID := Ln_TipoEmpleado;
            Lr_AdmiRol.DESCRIPCION_ROL := Pr_InfoPersona.CARGO;
            Lr_AdmiRol.ESTADO := 'Activo';
            Lr_AdmiRol.USR_CREACION := Pr_InfoPersonaEmpRol.USR_CREACION;
            Lr_AdmiRol.FE_CREACION := SYSDATE;
            Lr_AdmiRol.ES_JEFE := 'N';
            Lr_AdmiRol.PERMITE_ASIGNACION := 'N';
            DB_GENERAL.GNKG_ADMI_ROL_T.P_INSERT_ADMI_ROL(Lr_AdmiRol, Ln_IdAdmiRol, Pv_Status, Pv_Code, Pv_Msn);
            IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
                RAISE Le_Fail;
            END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
        END IF;

        DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_C.P_GET_INFO_EMPRESA_ROL(Pv_NoCia, Ln_IdAdmiRol, Lr_InfoEmpresaRol, Pv_Status, Pv_Code, Pv_Msn);

        IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
            RAISE Le_Fail;
        END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
        Ln_IdEmpresaRol := Lr_InfoEmpresaRol.ID_EMPRESA_ROL;
        IF GEKG_TYPE.NOT_FOUND_STATUS = Pv_Status THEN
            Lr_InfoEmpresaRol.EMPRESA_COD := Pv_NoCia;
            Lr_InfoEmpresaRol.ROL_ID := Ln_IdAdmiRol;
            Lr_InfoEmpresaRol.ESTADO := 'Activo';
            Lr_InfoEmpresaRol.USR_CREACION := Pr_InfoPersonaEmpRol.USR_CREACION;
            Lr_InfoEmpresaRol.FE_CREACION := SYSDATE;
            Lr_InfoEmpresaRol.IP_CREACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
            DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_T.P_INSERT_INFO_EMPRESA_ROL(Lr_InfoEmpresaRol, Ln_IdEmpresaRol, Pv_Status, Pv_Code, Pv_Msn);
            IF GEKG_TYPE.FAILED_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
                RAISE Le_Fail;
            END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
        END IF;

        Pr_InfoPersonaEmpRol.EMPRESA_ROL_ID := Ln_IdEmpresaRol;
                /*Setea el estado segun la primer letra del campo ESTADO*/
        CASE SUBSTR(TRIM(Pr_InfoEmpleado.ESTADO), 1, 1)
            WHEN GEKG_TYPE.ACTIVO THEN
                Pr_InfoPersonaEmpRol.ESTADO := GEKG_TYPE.T_ACTIVO;
            WHEN GEKG_TYPE.INACTIVO THEN
                Pr_InfoPersonaEmpRol.ESTADO := GEKG_TYPE.T_INACTIVO;
        END CASE;

        DB_COMERCIAL.CMKG_INFO_OFICINA_GRUPO_C.P_GET_INFO_OFICINA_GRUPO(Pr_InfoEmpleado.OFICINA, Pv_NoCia, 'Activo', Lr_InfoOficinaGrupo, Pv_Status, Pv_Code

        , Pv_Msn);

        IF GEKG_TYPE.FAILED_STATUS = Pv_Status OR GEKG_TYPE.NOT_FOUND_STATUS = Pv_Status THEN /*GEKG_TYPE.FAILED_STATUS = Pv_Status*/
            RAISE Le_Fail;
        END IF; /*GEKG_TYPE.FAILED_STATUS = Lv_Status*/
        Pr_InfoPersonaEmpRol.OFICINA_ID := Lr_InfoOficinaGrupo.ID_OFICINA;
        Pr_InfoPersonaEmpRol.PERSONA_ID := Pr_InfoPersona.ID_PERSONA;
        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Se genero instancia persona empresa rol';
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := Pv_Status;
            Pv_Code := Pv_Code;
            Pv_Msn := Pv_Msn;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_PREPARE_INFO_PERSONA_EMP_ROL;

    PROCEDURE P_PREPARE_INFO_PER_FORM_CONT (
        Pv_CodigoFormaContacto    IN                        DB_COMERCIAL.ADMI_FORMA_CONTACTO.CODIGO%TYPE,
        Pv_Valor                  IN                        DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO.VALOR%TYPE,
        Pr_InfoPersona            IN                        DB_COMERCIAL.CMKG_INFO_PERSONA_TYPE.Tr_InfoPersona,
        Pr_InfoPerFormaContacto   OUT                       DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO%ROWTYPE,
        Pv_Status                 OUT                       VARCHAR2,
        Pv_Code                   OUT                       VARCHAR2,
        Pv_Msn                    OUT                       VARCHAR2
    ) AS
        Lr_AdmiFormaContacto   DB_COMERCIAL.ADMI_FORMA_CONTACTO%ROWTYPE;
    BEGIN
        DB_COMERCIAL.CMKG_ADMI_FORMA_CONTACTO_C.P_GET_ADMI_FORMA_CONTACTO(Pv_CodigoFormaContacto, Lr_AdmiFormaContacto, Pv_Status, Pv_Code, Pv_Msn);
        Pr_InfoPerFormaContacto.PERSONA_ID := Pr_InfoPersona.ID_PERSONA;
        Pr_InfoPerFormaContacto.FORMA_CONTACTO_ID := Lr_AdmiFormaContacto.ID_FORMA_CONTACTO;
        Pr_InfoPerFormaContacto.VALOR := Pv_Valor;
        Pr_InfoPerFormaContacto.ESTADO := 'Activo';
        Pr_InfoPerFormaContacto.FE_CREACION := SYSDATE;
        Pr_InfoPerFormaContacto.USR_CREACION := Pr_InfoPersona.USR_CREACION;
        Pr_InfoPerFormaContacto.IP_CREACION := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        Pv_Msn := 'Se genero instancia de persona forma contacto';
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_PREPARE_INFO_PER_FORM_CONT;

END RHKG_PREPARE_TELCOS_OBJECTS_T;
/
