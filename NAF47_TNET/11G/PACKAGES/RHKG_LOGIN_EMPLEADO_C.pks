CREATE OR REPLACE PACKAGE            RHKG_LOGIN_EMPLEADO_C AS
    /**
    * Ayudara a validar los parametros de configuracion de ADMI_PARAMETRO_DET
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    */
    TYPE Tr_Validate IS
        TABLE OF INTEGER;

    /**
    * Ayudara a setar los filtros para buscar en LOGIN_EMPLEADO
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    */
    TYPE Tr_FiltersEmp IS
        TABLE OF VARCHAR2(200) INDEX BY VARCHAR2(20);

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
    * Retorna una cadena sin caracteres especiales segun los parametros
    * de configuracion
    * @param Fv_String IN Recibe la cadena
    * @param Fv_TranlateStart IN Recibe el parametro de busqueda
    * @param Fv_TranlateEnd IN Recibe el parametro de reemplazo
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    * @return VARCHAR2
    */
    FUNCTION F_REPLACE_SC (
        Fv_String          IN                 VARCHAR2,
        Fv_TranlateStart   IN                 VARCHAR2,
        Fv_TranlateEnd     IN                 VARCHAR2
    ) RETURN VARCHAR2;

    /**
    * Retorna el query con sus filtros enviados
    * @param Frry_Filtros IN Tr_FiltersEmp
    * @return El query completo con filtros
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    */

    FUNCTION F_CREATE_QUERY (
        Fv_Query       IN             VARCHAR2,
        Frry_Filtros   IN             Tr_FiltersEmp
    ) RETURN VARCHAR2;

    /**
    * Retorna el ID CURSOR del query que se enlazaron las variables
    * @param Frry_Filtros IN Tr_FiltersEmp
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    * @return CURSOR ID
    */

    FUNCTION F_BIND_QUERY (
        CursorID       IN             NUMBER,
        Frry_Filtros   IN             Tr_FiltersEmp
    ) RETURN NUMBER;

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
      * Genera un password en caso de haber un error retorna el LOGIN
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      **/

    FUNCTION F_GENERATE_PASSWORD (
        Pv_Login             IN                   VARCHAR2,
        Pv_NombreParametro   IN                   VARCHAR2,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    ) RETURN VARCHAR2;

    /**
      * Crea entidad en LDAP
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @param Pv_Request           IN   VARCHAR2, Request a crear 
      * @param Pv_NombreParametro   IN   VARCHAR2, Nombre del parametro para obtener configuracion del request
      * @param Pv_Result            OUT  VARCHAR2, Resultado del request
      * @param Pv_Status            OUT  VARCHAR2, Estatus del request
      * @param Pv_Code              OUT  VARCHAR2, Codigo de estatus
      * @param Pv_Msn               OUT  VARCHAR2  Mensaje del request
     **/

    PROCEDURE P_MAKE_REQUEST_REST (
        Pv_Request           IN                   VARCHAR2,
        Pv_NombreParametro   IN                   VARCHAR2,
        Pv_Result            OUT                  VARCHAR2,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    );

    /** Retorna el objeto LDAP, buscando por cedula o login
      * @param Pv_Attr VARCHAR2 Atributo a buscar
      * @param Pv_Valor VARCHAR2 Valor a buscar
      * @param Pv_Login VARCHAR2 Login
      * @param Pv_Result VARCHAR2 Resouesta en formato JSON
      * @param Pv_Status VARCHAR2 Estado de la consulta
      * @param Pv_Code VARCHAR2 Codigo de estado de consulta
      * @param Pv_Msn VARCHAR2 Mensaje de consulta
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @return LOGIN
      */

    PROCEDURE P_FIND_ENTITY_LDAP (
        Pv_Attr     IN          VARCHAR2,
        Pv_Valor    IN          VARCHAR2,
        Pv_Login    OUT         VARCHAR2,
        Pv_Result   OUT         VARCHAR2,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    );

    /**
     * Devuelve un registro de LOGIN empleado en caso de encontrarlo
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @version 1.0 20-10-2018
     **/

    PROCEDURE P_FIND_LOGIN_EMPLEADO (
        Pr_LoginEmpleado   IN OUT             LOGIN_EMPLEADO%ROWTYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    );

    /**
    * Retorna un true en caso de que el registro exista segun los filtros
    * enviados
    * @param Fr_LoginEmpleado IN Tr_FiltersEmp
    * @author Alexander Samaniego <awsamaniego@telconet.ec>
    * @version 1.0 20-10-2018
    * @return true|false
    * Test Function
    * <code>
        DECLARE
        LrEmpleado   RHKG_LOGIN_EMPLEADO_C.Tr_FiltersEmp;
        Exist        BOOLEAN := false;
        BEGIN
            LrEmpleado('AND@:CEDULA') := '0927152967';
            LrEmpleado('OR@:LOGIN') := 'awsamaniego';
            Exist := RHKG_LOGIN_EMPLEADO_C.F_EXIST_LOGIN_EMPLEADO(LrEmpleado);
            IF Exist THEN
                DBMS_OUTPUT.put_line('EXISTE');
            ELSE
                DBMS_OUTPUT.put_line('NO EXISTE');
            END IF;
        END;
    * </code>
    */

    FUNCTION F_EXIST_LOGIN_EMPLEADO (
        Frry_LoginEmpleado IN   Tr_FiltersEmp
    ) RETURN VARCHAR2;

    /** Realiza las validacion para verificar un LOGIN existente
      * @param Fv_Login VARCHAR2 Login empleado
      * @param Fv_Cedula VARCHAR2 Cedula empleado
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @return Retorna si existe o no
      */

    FUNCTION F_VALIDA_LOGIN_EXISTENTE (
        Fv_Login    IN          VARCHAR2,
        Fv_Cedula   IN          VARCHAR2
    ) RETURN VARCHAR2;

    /**
     * Obtiene las posibles configuraciones para generar un login
     * Ejemplo: Samuel Finley Breese Morse, 1[S]amuel 2[F]inley X[Breese] 3[M]orse
     * Se pueden realizar las siguientes combinaciones:
     * 1x => sbreese ; 12X => sfbreese ; 12X3 => sfbreesem ; 12X3(n+1) => sfbreesem1
     * @param Pn_NoEmp       IN             ARPLME.NO_EMPLE%TYPE Recibe el numero de empleado
     * @param Pv_LoginFX     OUT            VARCHAR2 Primera alternativa
     * @param Pv_LoginFSX    OUT            VARCHAR2 Segunda alternativa
     * @param Pv_LoginFSXL   OUT            VARCHAR2 Tercera alternativa
     * @param Pv_Status      OUT            VARCHAR2 Estado de la consulta
     * @param Pv_Msn         OUT            VARCHAR2 Mensaje
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @version 1.0 20-10-2018
     **/

    PROCEDURE P_CREATE_LOGIN (
        Pn_NoEmp       IN             ARPLME.NO_EMPLE%TYPE,
        Pn_NoCIa       IN             ARPLME.NO_CIA%TYPE,
        Pv_LoginFX     OUT            VARCHAR2,
        Pv_LoginFSX    OUT            VARCHAR2,
        Pv_LoginFSXL   OUT            VARCHAR2,
        Pv_Cedula      OUT            VARCHAR2,
        Pv_Status      OUT            VARCHAR2,
        Pv_Code        OUT            VARCHAR2,
        Pv_Msn         OUT            VARCHAR2
    );

    /**
     * Obtiene un login resultante
     * Usa P_CREATE_LOGIN para crear un login y realiza las validaciones para devolver uno
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @version 1.0 20-10-2018
     **/

    FUNCTION F_RESULT_LOGIN (
        Pn_NoEmp    IN          ARPLME.NO_EMPLE%TYPE,
        Pn_NoCIa    IN          ARPLME.NO_CIA%TYPE,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    ) RETURN VARCHAR2;

    /**
     * Crea el JSON para busqueda por cedula y uid
     * @param Fv_Type   IN         VARCHAR2 Recibe tipo cedula o uid
     * @param Fv_Valor  IN         VARCHAR2 Recibe le valor
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @version 1.0 20-10-2018
     * @return 
     **/

    FUNCTION F_GET_JSON_FIND_EMP (
        Fv_Type    IN         VARCHAR2,
        Fv_Valor   IN         VARCHAR2
    ) RETURN VARCHAR2;

    /**
      * Crea JSON de una entidad LDAP
      * @author Alexander Samaniego <awsamaniego@telconet.ec>
      * @version 1.0 20-10-2018
      * @param  Fr_LdapEntity IN   GEKG_TYPE.Lr_LdapEntity Infomacion para crear entidad LDAP
      * Debe generar algo asi, copiar el string y darle formato <link>https://jsoneditoronline.org/</link>
      * <code>
      {"dn":{"1":{"buildName":{"ou":"Administrativos"}},"2":{"buildName":{"ou":"Aplicativos"}},"3":{"buildName":{"ou":"Correisa"},
      "attr":{"objectClass":"{0} organizationalUnit, top"}},"4":{"buildName":{"ou":"Correisssa"},
      "attr":{"objectClass":"{0} organizationalUnit, top"}}},"usr":{"2":{"buildName":{"uid":"yizuz"},
      "attr":{"cn":"Alexander","gidNumber":"123456","objectClass":"{0} telcoPerson, inetOrgPerson, organizationalPerson, person, top,
      posixAccount","sn":"YIZUZ SN","homeDirectory":"/home/yizuz","uidNumber":"501","businessCategory":"tecnico",
      "cargo":"ING3","cedula":"01234567890","displayName":"YIZUZ SUAREZ","gecos":"gitlab, kandboard",
      "loginShell":"/bin/ash","mail":"yizuz@telconet.ec","mailBox":"yizuz","userPassword":"kbayiz"}}}}
      * </code>
     **/

    FUNCTION F_CREATE_JSON_ENTITY_LDAP (
        Fr_LdapEntity IN   GEKG_TYPE.Lr_LdapEntity
    ) RETURN VARCHAR2;

    /**
     * Obtiene DN 
     * Ejm: uid=cbavila,ou=ResponsabilidadSocial,ou=Administracion,ou=Guayas,ou=Usuarios,ou=Telconet,ou=UsuarioIntern
     * @author Alexander Samaniego <awsamaniego@telconet.ec>
     * @version 1.0 20-10-2018
     **/

    FUNCTION F_CREATE_JSON_DN_LDAP (
        Fr_LdapEntity IN   GEKG_TYPE.Lr_LdapEntity
    ) RETURN VARCHAR2;

END RHKG_LOGIN_EMPLEADO_C;
/


CREATE OR REPLACE PACKAGE BODY            RHKG_LOGIN_EMPLEADO_C AS

    FUNCTION F_REPLACE_SC (
        Fv_String          IN                 VARCHAR2,
        Fv_TranlateStart   IN                 VARCHAR2,
        Fv_TranlateEnd     IN                 VARCHAR2
    ) RETURN VARCHAR2 AS

        CURSOR C_GetTranslate (
            Cv_Param   NAF47_TNET.GE_PARAMETROS.PARAMETRO%TYPE
        ) IS
        SELECT
            DESCRIPCION
        FROM
            NAF47_TNET.GE_PARAMETROS
        WHERE
            PARAMETRO = Cv_Param
            AND ESTADO = GEKG_TYPE.ACTIVO;

        Lc_GetTranslate   C_GetTranslate%ROWTYPE := NULL;
        Lv_Translate1     VARCHAR2(1000) := '';
        Lv_Translate2     VARCHAR2(1000) := '';
    BEGIN
        IF C_GetTranslate%ISOPEN THEN
            CLOSE C_GetTranslate;
        END IF;
        OPEN C_GetTranslate(Fv_TranlateStart);
        FETCH C_GetTranslate INTO Lc_GetTranslate;
        IF C_GetTranslate%NOTFOUND THEN
            RETURN '';
        END IF;
        Lv_Translate1 := Lc_GetTranslate.DESCRIPCION;
        CLOSE C_GetTranslate;
        Lc_GetTranslate := NULL;
        OPEN C_GetTranslate(Fv_TranlateEnd);
        FETCH C_GetTranslate INTO Lc_GetTranslate;
        IF C_GetTranslate%NOTFOUND THEN
            RETURN '';
        END IF;
        Lv_Translate2 := Lc_GetTranslate.DESCRIPCION;
        CLOSE C_GetTranslate;
        RETURN TRANSLATE(Fv_String, Lv_Translate1, Lv_Translate2);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '';
    END F_REPLACE_SC;

    FUNCTION F_CREATE_QUERY (
        Fv_Query       IN             VARCHAR2,
        Frry_Filtros   IN             Tr_FiltersEmp
    ) RETURN VARCHAR2 AS
        ArrayIndex   VARCHAR2(50);
        SqlStmt      VARCHAR2(1000) := Fv_Query;
    BEGIN
        ArrayIndex := Frry_Filtros.FIRST;
        /*Itera el array [Frry_Filtros] con los filtros enviados para formar el query,
        REPLACE(ArrayIndex, '@:', ' ') => El formato es [AND@:CAMPO] el resultado [AND CAMPO] para hacer el filtro
        REGEXP_SUBSTR(ArrayIndex, ':[^.]*') => El formato es [AND@:CAMPO] el resultado [:CAMPO] para crear el bind*/
        WHILE ( ArrayIndex IS NOT NULL ) LOOP
            SqlStmt := SqlStmt
                       || ' '
                       || REPLACE(ArrayIndex, '@:', ' ')
                       || ' = '
                       || REGEXP_SUBSTR(ArrayIndex, ':[^.]*')
                       || ' ';

            ArrayIndex := Frry_Filtros.next(ArrayIndex);
        END LOOP;

        RETURN SqlStmt;
    END F_CREATE_QUERY;

    FUNCTION F_BIND_QUERY (
        CursorID       IN             NUMBER,
        Frry_Filtros   IN             Tr_FiltersEmp
    ) RETURN NUMBER AS
        ArrayIndex   VARCHAR2(50);
    BEGIN
        ArrayIndex := Frry_Filtros.FIRST;
        /*Itera el array [Frry_Filtros] con los filtros enviados hacer los enlaces de variables.
        REGEXP_SUBSTR(ArrayIndex, ':[^.]*') => El formato es [AND@:CAMPO] el resultado [:CAMPO] para crear el bind*/
        WHILE ( ArrayIndex IS NOT NULL ) LOOP
            DBMS_SQL.BIND_VARIABLE(CursorID, REGEXP_SUBSTR(ArrayIndex, ':[^.]*'), Frry_Filtros(ArrayIndex));

            ArrayIndex := Frry_Filtros.next(ArrayIndex);
        END LOOP;

        RETURN CursorID;
    END F_BIND_QUERY;

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

    FUNCTION F_GENERATE_PASSWORD (
        Pv_Login             IN                   VARCHAR2,
        Pv_NombreParametro   IN                   VARCHAR2,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    ) RETURN VARCHAR2 AS

        CURSOR C_GetStringRandom (
            Cv_String      VARCHAR2,
            Cn_LengthStr   NUMBER,
            Cn_Length      NUMBER
        ) IS
        WITH RANDOM_STR AS (
            SELECT
                LEVEL   Lo_Level,
                SUBSTR(Cv_String, MOD(ABS(DBMS_RANDOM.RANDOM), Cn_LengthStr) + 1, 1) STR
            FROM
                DUAL
            CONNECT BY
                LEVEL <= Cn_Length
        )
        SELECT
            REPLACE(SYS_CONNECT_BY_PATH(STR, '/'), '/') PSSWD
        FROM
            RANDOM_STR
        WHERE
            Lo_Level = 1
        START WITH
            Lo_Level = Cn_Length
        CONNECT BY
            Lo_Level + 1 = PRIOR Lo_Level;

        Lr_ParamRequest      RHKG_LOGIN_EMPLEADO_C.Lr_ParamRequest;
        Lr_Validate          RHKG_LOGIN_EMPLEADO_C.Tr_Validate;
        Lc_GetStringRandom   C_GetStringRandom%ROWTYPE;
        Le_Fail EXCEPTION;
    BEGIN
        RHKG_LOGIN_EMPLEADO_C.P_PARAMETROS(TRIM(Pv_NombreParametro), 'Activo', 'Activo', Lr_ParamRequest, Pv_Status, Pv_Code, Pv_Msn);

        IF GEKG_TYPE.FOUND_STATUS <> Pv_Status THEN
            RAISE Le_Fail;
        END IF;
        Lr_Validate := RHKG_LOGIN_EMPLEADO_C.Tr_Validate(1, 2, 3);
        RHKG_LOGIN_EMPLEADO_C.P_VALIDATE_PARAM(Lr_Validate, Lr_ParamRequest, Pv_Status, Pv_Code, Pv_Msn);
        IF GEKG_TYPE.OK_STATUS <> Pv_Status THEN
            RAISE Le_Fail;
        END IF;
        IF C_GetStringRandom%ISOPEN THEN
            CLOSE C_GetStringRandom;
        END IF;
        OPEN C_GetStringRandom(Lr_ParamRequest.Lv_Valor1, Lr_ParamRequest.Lv_Valor2, Lr_ParamRequest.Lv_Valor3);
        FETCH C_GetStringRandom INTO Lc_GetStringRandom;
        IF C_GetStringRandom%NOTFOUND THEN
            RAISE Le_Fail;
        END IF;
        RETURN Lc_GetStringRandom.PSSWD;
    EXCEPTION
        WHEN Le_Fail THEN
            RETURN Pv_Login;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
            RETURN Pv_Login;
    END F_GENERATE_PASSWORD;

    PROCEDURE P_MAKE_REQUEST_REST (
        Pv_Request           IN                   VARCHAR2,
        Pv_NombreParametro   IN                   VARCHAR2,
        Pv_Result            OUT                  VARCHAR2,
        Pv_Status            OUT                  VARCHAR2,
        Pv_Code              OUT                  VARCHAR2,
        Pv_Msn               OUT                  VARCHAR2
    ) AS

        Lrry_RequestHeader   GEKG_TYPE.RequestHeader;
        Lr_Validate          RHKG_LOGIN_EMPLEADO_C.Tr_Validate;
        Lr_ParamRequest      RHKG_LOGIN_EMPLEADO_C.Lr_ParamRequest;
        Lv_Status            VARCHAR2(100) := '';
        Lv_Code              VARCHAR2(5) := '';
        Lv_Msn               VARCHAR2(4000) := '';
        Le_Fail EXCEPTION;
    BEGIN
        IF Pv_Request IS NULL OR TRIM(Pv_Request) = '' THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'No envio request';
        END IF;

        IF Pv_NombreParametro IS NULL OR TRIM(Pv_NombreParametro) = '' THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'No envio parametro de configuracion de request';
        END IF;
        /**
         * Lr_ParamRequest.Lv_Valor1 URL
         * Lr_ParamRequest.Lv_Valor2 Method
         * Lr_ParamRequest.Lv_Valor3 Version
         * Lr_ParamRequest.Lv_Valor4 Name HEADER
         * Lr_ParamRequest.Lv_Valor5 Attr value HEADER
         **/
        /**Envia a buscar parametros de configuracion para request**/

        RHKG_LOGIN_EMPLEADO_C.P_PARAMETROS(TRIM(Pv_NombreParametro), 'Activo', 'Activo', Lr_ParamRequest, Lv_Status, Lv_Code, Lv_Msn);

        IF GEKG_TYPE.FOUND_STATUS <> Pv_Status THEN
            RAISE Le_Fail;
        END IF;
        /**Valida que deba traer los 5 campos no nulos**/
        Lr_Validate := RHKG_LOGIN_EMPLEADO_C.Tr_Validate(1, 2, 3, 4, 5);
        RHKG_LOGIN_EMPLEADO_C.P_VALIDATE_PARAM(Lr_Validate, Lr_ParamRequest, Lv_Status, Lv_Code, Lv_Msn);
        IF GEKG_TYPE.OK_STATUS <> Pv_Status THEN
            RAISE Le_Fail;
        END IF;
        /*Setea el HEADER*/
        Lrry_RequestHeader(Lr_ParamRequest.Lv_Valor4) := Lr_ParamRequest.Lv_Valor5;
        /*Realiza la peticion*/
        GEKG_HTTP.P_REQUEST_REST(TRIM(Lr_ParamRequest.Lv_Valor1), TRIM(Pv_Request), TRIM(Lr_ParamRequest.Lv_Valor2), TRIM(Lr_ParamRequest.Lv_Valor3), Lrry_RequestHeader
        , Pv_Result, Pv_Status, Pv_Code, Pv_Msn);

    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := Lv_Status;
            Pv_Code := Lv_Code;
            Pv_Msn := Lv_Msn;
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_MAKE_REQUEST_REST;

    PROCEDURE P_FIND_ENTITY_LDAP (
        Pv_Attr     IN          VARCHAR2,
        Pv_Valor    IN          VARCHAR2,
        Pv_Login    OUT         VARCHAR2,
        Pv_Result   OUT         VARCHAR2,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    ) AS
        TYPE Type_Generic IS
            TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(200);
        Array_Generic   Type_Generic;
    BEGIN
        /*Construye JSON*/
        Array_Generic('request') := RHKG_LOGIN_EMPLEADO_C.F_GET_JSON_FIND_EMP(Pv_Attr, Pv_Valor);
        /*Realiza la peticion*/
        RHKG_LOGIN_EMPLEADO_C.P_MAKE_REQUEST_REST(Array_Generic('request'), 'REQUEST_FIND_LDAP', Array_Generic('result'), Pv_Status, Pv_Code, Pv_Msn);
        /*Parsea el resultado*/

        Pv_Result := Array_Generic('result');
        APEX_JSON.PARSE(Array_Generic('result'));
        Pv_Login := APEX_JSON.GET_VARCHAR2('object.uid');
        Pv_Status := APEX_JSON.GET_VARCHAR2('status');
        Pv_Code := APEX_JSON.GET_VARCHAR2('code');
        Pv_Msn := APEX_JSON.GET_VARCHAR2('msn');
        IF NVL(Pv_Login, 'X') = 'X' THEN
         Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := SQLERRM;
    END P_FIND_ENTITY_LDAP;

    FUNCTION F_EXIST_LOGIN_EMPLEADO (
        Frry_LoginEmpleado IN   Tr_FiltersEmp
    ) RETURN VARCHAR2 AS

        CurID        NUMBER;
        SqlStmt      VARCHAR2(1000) := 'SELECT * FROM LOGIN_EMPLEADO WHERE 1 = 1 ';
        ResultExec   NUMBER;
        ExistLogin   VARCHAR2(10) := '';
    BEGIN
        /*Crear el cursor*/
        CurID := DBMS_SQL.OPEN_CURSOR;
        /*Obtiene el query*/
        SqlStmt := F_CREATE_QUERY(SqlStmt, Frry_LoginEmpleado);
        DBMS_OUTPUT.PUT_LINE('SQL ' || SqlStmt);
        /*Realiza el PARSE*/
        DBMS_SQL.PARSE(CurID, SqlStmt, DBMS_SQL.NATIVE);
        /*Hace los enlace de variables*/
        ResultExec := F_BIND_QUERY(CurID, Frry_LoginEmpleado);
        /*Ejecuta*/
        ResultExec := DBMS_SQL.EXECUTE(CurID);
        /*Pregunta si hay mas de 0 columnas*/
        IF DBMS_SQL.FETCH_ROWS(CurID) > 0 THEN
            ExistLogin := GEKG_TYPE.FOUND_STATUS;
            DBMS_OUTPUT.PUT_LINE('EXISTE');
        ELSE
            ExistLogin := GEKG_TYPE.NOT_FOUND_STATUS;
            DBMS_OUTPUT.PUT_LINE('NO EXISTE');
        END IF;
        /*Cierra el cursor*/

        DBMS_SQL.CLOSE_CURSOR(CurID);
        RETURN ExistLogin;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN GEKG_TYPE.FAILED_STATUS;
    END F_EXIST_LOGIN_EMPLEADO;

    PROCEDURE P_FIND_LOGIN_EMPLEADO (
        Pr_LoginEmpleado   IN OUT             LOGIN_EMPLEADO%ROWTYPE,
        Pv_Status          OUT                VARCHAR2,
        Pv_Code            OUT                VARCHAR2,
        Pv_Msn             OUT                VARCHAR2
    ) AS
        /*Obtiene registro de LOGIN_EMPLEADO
         *@cost 2, cardinalidad 1
         */

        CURSOR C_GetLoginEmpleado (
            Cv_NoCia     LOGIN_EMPLEADO.NO_CIA%TYPE,
            Cv_NoEmple   LOGIN_EMPLEADO.NO_EMPLE%TYPE
        ) IS
        SELECT
            *
        FROM
            LOGIN_EMPLEADO
        WHERE
            NO_CIA = Cv_NoCia
            AND NO_EMPLE = Cv_NoEmple;

        Le_Exception EXCEPTION;
    BEGIN
        /*Busca configuracion para request*/
        IF C_GetLoginEmpleado%ISOPEN THEN
            CLOSE C_GetLoginEmpleado;
        END IF;
        OPEN C_GetLoginEmpleado(Pr_LoginEmpleado.NO_CIA, Pr_LoginEmpleado.NO_EMPLE);
        FETCH C_GetLoginEmpleado INTO Pr_LoginEmpleado;
        IF C_GetLoginEmpleado%NOTFOUND THEN
            RAISE Le_Exception;
        END IF;
        CLOSE C_GetLoginEmpleado;
        Pv_Status := GEKG_TYPE.FOUND_STATUS;
        Pv_Code := GEKG_TYPE.FOUND_CODE;
        Pv_Msn := 'Se encontro LOGIN empleado';
    EXCEPTION
        WHEN Le_Exception THEN
            Pv_Status := GEKG_TYPE.NOT_FOUND_STATUS;
            Pv_Code := GEKG_TYPE.NOT_FOUND_CODE;
            Pv_Msn := 'No se encontro login empleado';
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_FIND_LOGIN_EMPLEADO;

    FUNCTION F_VALIDA_LOGIN_EXISTENTE (
        Fv_Login VARCHAR2,
        Fv_Cedula VARCHAR2
    ) RETURN VARCHAR2 AS

        LrEmpleado       Tr_FiltersEmp;
        Lv_ExistLogin    VARCHAR2(25) := '';
        Lv_LoginLdap     VARCHAR2(25) := '';
        Lv_ExistLogCed   VARCHAR2(25) := '';
        Lv_result        VARCHAR2(4000) := '';
        Lv_Status        VARCHAR2(100) := '';
        Lv_Code          VARCHAR2(5) := '';
        Lv_Msn           VARCHAR2(4000) := '';
    BEGIN
        /*Busca en la LOGIN_EMPLEADO por LOGIN*/
        LrEmpleado('AND@:LOGIN') := Fv_Login;
        Lv_ExistLogin := F_EXIST_LOGIN_EMPLEADO(LrEmpleado);
        DBMS_OUTPUT.PUT_LINE('CON LOGIN F_EXIST_LOGIN_EMPLEADO ' || Lv_ExistLogin);
        IF GEKG_TYPE.FAILED_STATUS = Lv_ExistLogin THEN
            RETURN Lv_ExistLogin;
        END IF;
        /*Busca en LDAP por uid*/
        RHKG_LOGIN_EMPLEADO_C.P_FIND_ENTITY_LDAP('uid', Fv_Login, Lv_LoginLdap, Lv_result, Lv_Status, Lv_Code, Lv_Msn);

        DBMS_OUTPUT.PUT_LINE('P_FIND_ENTITY_LDAP UID '
                             || Fv_Login
                             || ' '
                             || Lv_Status
                             || ' '
                             || Lv_Code);

        IF Lv_Status NOT IN (
           GEKG_TYPE.NOT_FOUND_STATUS,
           GEKG_TYPE.FOUND_STATUS
        ) THEN
            RETURN Lv_Status;
        END IF;

        /*Busca en la LOGIN_EMPLEADO por LOGIN AND CEDULA*/

        LrEmpleado('AND@:CEDULA') := Fv_Cedula;
        Lv_ExistLogCed := F_EXIST_LOGIN_EMPLEADO(LrEmpleado);
        DBMS_OUTPUT.PUT_LINE('CON CEDULA F_EXIST_LOGIN_EMPLEADO ' || Lv_ExistLogCed);
        IF GEKG_TYPE.FAILED_STATUS = Lv_ExistLogCed THEN
            RETURN Lv_ExistLogCed;
        END IF;
        /*Si entra quiere decir que se le asignara el LOGIN al empleado, sino se buscara otro*/
        IF ( GEKG_TYPE.NOT_FOUND_STATUS = Lv_ExistLogin AND GEKG_TYPE.NOT_FOUND_STATUS = Lv_Status ) OR GEKG_TYPE.FOUND_STATUS = Lv_ExistLogCed THEN
            DBMS_OUTPUT.PUT_LINE('FOUNDED ' || Fv_Login);
            RETURN GEKG_TYPE.FOUND_STATUS;
        END IF;

        RETURN GEKG_TYPE.NOT_FOUND_STATUS;
    END F_VALIDA_LOGIN_EXISTENTE;

    PROCEDURE P_CREATE_LOGIN (
        Pn_NoEmp       IN             ARPLME.NO_EMPLE%TYPE,
        Pn_NoCIa       IN             ARPLME.NO_CIA%TYPE,
        Pv_LoginFX     OUT            VARCHAR2,
        Pv_LoginFSX    OUT            VARCHAR2,
        Pv_LoginFSXL   OUT            VARCHAR2,
        Pv_Cedula      OUT            VARCHAR2,
        Pv_Status      OUT            VARCHAR2,
        Pv_Code        OUT            VARCHAR2,
        Pv_Msn         OUT            VARCHAR2
    ) AS 
       /**Obtiene los nombres e iniciales del empleado
         * para la generacion del login
         * @costo 16, cardinalidad 1
        **/

        CURSOR C_GetNameEmpleado (
            Cv_NoEmpe ARPLME.NO_EMPLE%TYPE,
            Cn_NoCIa ARPLME.NO_CIA%TYPE
        ) IS
        SELECT
            RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.NOMBRE_PILA), 'TRANSL_1', 'TRANSL_2') NOMBRE_PILA,
            RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.NOMBRE_SEGUNDO), 'TRANSL_1', 'TRANSL_2') NOMBRE_SEGUNDO,
            REPLACE(RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.APE_PAT), 'TRANSL_1', 'TRANSL_2'),' ','') APE_PAT,
            --RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.APE_PAT), 'TRANSL_1', 'TRANSL_2') APE_PAT,
            RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.APE_MAT), 'TRANSL_1', 'TRANSL_2') APE_MAT,
            RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.NOMBRE), 'TRANSL_1', 'TRANSL_2') NOMBRE,
            SUBSTR(RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.NOMBRE_PILA), 'TRANSL_1', 'TRANSL_2'), 1, 1) INITIAL_FN,
            SUBSTR(RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.NOMBRE_SEGUNDO), 'TRANSL_1', 'TRANSL_2'), 1, 1) INITIAL_SN,
            SUBSTR(RHKG_LOGIN_EMPLEADO_C.F_REPLACE_SC(TRIM(APS.APE_MAT), 'TRANSL_1', 'TRANSL_2'), 1, 1) INITIAL_FLN,
            APS.CEDULA   CEDULA
        FROM
            ARPLME APS
        WHERE
            NO_EMPLE = Cv_NoEmpe
            AND NO_CIA = Cn_NoCIa;

        Lc_GetNameEmpleado   C_GetNameEmpleado%ROWTYPE;
        Le_NotFound EXCEPTION;
    BEGIN
        IF C_GetNameEmpleado%ISOPEN THEN
            CLOSE C_GetNameEmpleado;
        END IF;
        OPEN C_GetNameEmpleado(Pn_NoEmp, Pn_NoCIa);
        FETCH C_GetNameEmpleado INTO Lc_GetNameEmpleado;
        IF C_GetNameEmpleado%NOTFOUND THEN
            RAISE Le_NotFound;
        END IF;
        Pv_LoginFX := LOWER(TRIM(Lc_GetNameEmpleado.INITIAL_FN || Lc_GetNameEmpleado.APE_PAT));
        Pv_LoginFSX := LOWER(TRIM(Lc_GetNameEmpleado.INITIAL_FN
                                  || Lc_GetNameEmpleado.INITIAL_SN
                                  || Lc_GetNameEmpleado.APE_PAT));

        Pv_LoginFSXL := LOWER(TRIM(Lc_GetNameEmpleado.INITIAL_FN
                                   || Lc_GetNameEmpleado.INITIAL_SN
                                   || Lc_GetNameEmpleado.APE_PAT
                                   || Lc_GetNameEmpleado.INITIAL_FLN));

        Pv_Cedula := Lc_GetNameEmpleado.CEDULA;
        CLOSE C_GetNameEmpleado;
        Pv_Status := GEKG_TYPE.FOUND_STATUS;
        Pv_Code := GEKG_TYPE.FOUND_CODE;
        Pv_Msn := 'Empleado encontrado';
    EXCEPTION
        WHEN Le_NotFound THEN
            Pv_Code := GEKG_TYPE.NOT_FOUND_STATUS;
            Pv_Status := GEKG_TYPE.NOT_FOUND_CODE;
            Pv_Msn := 'Empleado no encontrado';
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
    END P_CREATE_LOGIN;

    FUNCTION F_RESULT_LOGIN (
        Pn_NoEmp    IN          ARPLME.NO_EMPLE%TYPE,
        Pn_NoCIa    IN          ARPLME.NO_CIA%TYPE,
        Pv_Status   OUT         VARCHAR2,
        Pv_Code     OUT         VARCHAR2,
        Pv_Msn      OUT         VARCHAR2
    ) RETURN VARCHAR2 AS

        Lv_LoginFX      VARCHAR2(25) := '';
        Lv_LoginFSX     VARCHAR2(25) := '';
        Lv_LoginFSXL    VARCHAR2(25) := '';
        Lv_Cedula       VARCHAR2(25) := '';
        Lv_LoginCount   VARCHAR2(25) := '';
        Ln_LoginCount   NUMBER := 1;
        Le_Fail EXCEPTION;
    BEGIN
        P_CREATE_LOGIN(Pn_NoEmp, Pn_NoCIa, Lv_LoginFX, Lv_LoginFSX, Lv_LoginFSXL, Lv_Cedula, Pv_Status, Pv_Code, Pv_Msn);

        IF GEKG_TYPE.FOUND_STATUS <> Pv_Status THEN
            RAISE Le_Fail;
        END IF;
        Pv_Status := GEKG_TYPE.GENERATED_STATUS;
        Pv_Code := GEKG_TYPE.GENERATED_CODE;
        IF GEKG_TYPE.FOUND_STATUS = F_VALIDA_LOGIN_EXISTENTE(Lv_LoginFX, Lv_Cedula) THEN
            Pv_Msn := 'Login generado ' || Lv_LoginFX;
            RETURN Lv_LoginFX;
        END IF;

        IF GEKG_TYPE.FOUND_STATUS = F_VALIDA_LOGIN_EXISTENTE(Lv_LoginFSX, Lv_Cedula) THEN
            Pv_Msn := 'Login generado ' || Lv_LoginFSX;
            RETURN Lv_LoginFSX;
        END IF;

        IF GEKG_TYPE.FOUND_STATUS = F_VALIDA_LOGIN_EXISTENTE(Lv_LoginFSXL, Lv_Cedula) THEN
            Pv_Msn := 'Login generado ' || Lv_LoginFSXL;
            RETURN Lv_LoginFSXL;
        END IF;

        LOOP
            Lv_LoginCount := Lv_LoginFSXL || Ln_LoginCount;
            IF GEKG_TYPE.FOUND_STATUS = F_VALIDA_LOGIN_EXISTENTE(Lv_LoginCount, Lv_Cedula) THEN
                Pv_Msn := 'Login generado ' || Lv_LoginCount;
                RETURN Lv_LoginCount;
            END IF;

            Ln_LoginCount := Ln_LoginCount + 1;
        END LOOP;

        Pv_Status := GEKG_TYPE.FAILED_STATUS;
        Pv_Code := GEKG_TYPE.FAILED_CODE;
        Pv_Msn := 'Login no generado';
        RETURN '';
    EXCEPTION
        WHEN Le_Fail THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            RETURN '';
        WHEN OTHERS THEN
            Pv_Status := GEKG_TYPE.FAILED_STATUS;
            Pv_Code := GEKG_TYPE.FAILED_CODE;
            Pv_Msn := 'Error: ' || SQLERRM;
            RETURN '';
    END F_RESULT_LOGIN;

    FUNCTION F_GET_JSON_FIND_EMP (
        Fv_Type    IN         VARCHAR2,
        Fv_Valor   IN         VARCHAR2
    ) RETURN VARCHAR2 AS
        Lv_Json   VARCHAR2(1000);
    BEGIN
        /*Creando JSON*/
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE_RAW('"baseDn":""');
        APEX_JSON.WRITE('searchControl', '2');
        APEX_JSON.OPEN_OBJECT('findBy');
        APEX_JSON.WRITE(Fv_Type, Fv_Valor);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
        Lv_Json := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        RETURN Lv_Json;
    END F_GET_JSON_FIND_EMP;

    FUNCTION F_CREATE_JSON_ENTITY_LDAP (
        Fr_LdapEntity IN   GEKG_TYPE.Lr_LdapEntity
    ) RETURN VARCHAR2 AS

        Lv_Json   VARCHAR2(4000) := '';
        TYPE Tb_OU IS
            TABLE OF VARCHAR2(150);
        Lb_OU     Tb_OU;
    BEGIN
        /*Debe ser ingresado en orden*/
        Lb_OU := Tb_OU(Fr_LdapEntity.OU_1, Fr_LdapEntity.EMPRESA, Fr_LdapEntity.OU_2, Fr_LdapEntity.PROVINCIA, Fr_LdapEntity.AREA, Fr_LdapEntity.DEPARTAMENTO
        );

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT; /*{*/
        APEX_JSON.OPEN_OBJECT('dn'); /*dn {*/
        /*Itera los OU para formar la direccion del arbol, BASE DN*/
        FOR I_Index IN 1..Lb_OU.COUNT LOOP
            APEX_JSON.OPEN_OBJECT(I_Index); /*1 {*/
            APEX_JSON.OPEN_OBJECT('buildName'); /*buildName {*/
            /*Esto simplemente pone en mayúscula el primer carácter de cada palabra 
            y luego reemplaza los espacios con nada.*/
            APEX_JSON.WRITE('ou', REGEXP_REPLACE(INITCAP(Lb_OU(I_Index)), '([[:punct:] | [:blank:]])', ''));

            APEX_JSON.CLOSE_OBJECT; /*buildName }*/
            APEX_JSON.OPEN_OBJECT('attr'); /*attr {*/
            APEX_JSON.WRITE('objectClass', Fr_LdapEntity.OBJECT_CLASS_DN);
            APEX_JSON.CLOSE_OBJECT; /*attr }*/
            APEX_JSON.CLOSE_OBJECT; /*1 }*/
        END LOOP;

        APEX_JSON.CLOSE_OBJECT; /*dn }*/
        APEX_JSON.OPEN_OBJECT('usr'); /*usr {*/
        APEX_JSON.OPEN_OBJECT(1); /*1 {*/
        APEX_JSON.OPEN_OBJECT('buildName'); /*buildName {*/
        APEX_JSON.WRITE('uid', Fr_LdapEntity.UID);
        APEX_JSON.CLOSE_OBJECT; /*buildName }*/
        APEX_JSON.OPEN_OBJECT('attr'); /*attr {*/
        APEX_JSON.WRITE('cn', Fr_LdapEntity.CN);
        APEX_JSON.WRITE('gidNumber', Fr_LdapEntity.GID_NUMBER);
        APEX_JSON.WRITE('objectClass', Fr_LdapEntity.OBJECT_CLASS);
        APEX_JSON.WRITE('sn', Fr_LdapEntity.SN);
        APEX_JSON.WRITE('homeDirectory', Fr_LdapEntity.HOME_DIRECTORY);
        APEX_JSON.WRITE('uidNumber', Fr_LdapEntity.UID_NUMBER);
        APEX_JSON.WRITE('businessCategory', Fr_LdapEntity.BUSINESS_CATEGORY);
        APEX_JSON.WRITE('cargo', Fr_LdapEntity.CARGO);
        APEX_JSON.WRITE('cedula', Fr_LdapEntity.CEDULA);
        APEX_JSON.WRITE('displayName', Fr_LdapEntity.DISPLAY_NAME);
        APEX_JSON.WRITE('loginShell', Fr_LdapEntity.LOGIN_SHELL);
        APEX_JSON.WRITE('mail', Fr_LdapEntity.MAIL);
        APEX_JSON.WRITE('mailBox', Fr_LdapEntity.MAIL_BOX);
        APEX_JSON.WRITE('userPassword', Fr_LdapEntity.USER_PASSWORD);
        APEX_JSON.CLOSE_OBJECT; /*attr }  */
        APEX_JSON.CLOSE_OBJECT; /*1 }*/
        APEX_JSON.CLOSE_OBJECT; /*usr }*/
        APEX_JSON.CLOSE_OBJECT; /*}*/
        Lv_Json := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        RETURN Lv_Json;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN GEKG_TYPE.FAILED_STATUS;
    END F_CREATE_JSON_ENTITY_LDAP;

    FUNCTION F_CREATE_JSON_DN_LDAP (
        Fr_LdapEntity IN   GEKG_TYPE.Lr_LdapEntity
    ) RETURN VARCHAR2 AS

        Lv_Json   VARCHAR2(4000) := '';
        TYPE Tb_OU IS
            TABLE OF VARCHAR2(150);
        Lb_OU     Tb_OU;
    BEGIN
        /*Debe ser ingresado en orden*/
        Lb_OU := Tb_OU(Fr_LdapEntity.OU_1, Fr_LdapEntity.EMPRESA, Fr_LdapEntity.OU_2, Fr_LdapEntity.PROVINCIA, Fr_LdapEntity.AREA, Fr_LdapEntity.DEPARTAMENTO
        );

        FOR I_Index IN 1..Lb_OU.COUNT LOOP
            Lv_Json := ',ou=' || TRIM(REGEXP_REPLACE(INITCAP(Lb_OU(I_Index)), '([[:punct:] | [:blank:]])', '')) || Lv_Json;
        END LOOP;
        RETURN 'uid=' || Fr_LdapEntity.UID || Lv_Json;
    END F_CREATE_JSON_DN_LDAP;

END RHKG_LOGIN_EMPLEADO_C;
/
