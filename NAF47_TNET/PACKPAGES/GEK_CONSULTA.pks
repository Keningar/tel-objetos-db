CREATE OR REPLACE PACKAGE NAF47_TNET.GEK_CONSULTA IS
/**
* Documentacion para NAF47_TNET.GEK_CONSULTA
* Packages que contiene procesos y funciones que pueden ser de uso general para todo el sistema
* @author llindao <llindao@telconet.ec>
* @version 1.0 26/04/2015
*/

  /**
  * Documentacion para GEF_ELIMINA_CARACTER_ESP
  * Function que permite eliminar caracteres especiales de un texto
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 26/04/2015
  *
  * Documentación para GEF_ELIMINA_CARACTER_ESP
  * Se hace el llamado a la tabla DB_GENERAL.ADMI_PARAMETRO_DET la cuál contiene en la columna
  * valor1 con los caracteres especiales que se desean reemplazar por espacios en blanco y se	
  * recorre cada uno de ellos por medio de un ciclo for loop.	
  * @author Douglas Natha <dnatha@telconet.ec>
  * @version 1.1 20/02/2020
  *
  * @param Pv_Texto IN VARCHAR2 Recibe texto a validar
  * @return            VARCHAR2 retorna texto sin caracteres especiales
  */
  FUNCTION GEF_ELIMINA_CARACTER_ESP(Pv_Texto IN VARCHAR2) RETURN VARCHAR2;

  /**
  * Documentacion para GEP_REG_PARAMETROS
  * Procedimiento que permite recuperar registro de un parametro general
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 26/04/2015
  *
  * @param Pv_IdEmpresa        IN VARCHAR2 Recibe codigo de empresa
  * @param Pv_IdAplicacion     IN VARCHAR2  recibe codigo de aplicacion
  * @param Pv_IdGrupoParametro IN VARCHAR2 recibe codigo de parametro general
  * @param Pv_IdParametro      IN VARCHAR2  recibe codigo de parametro
  * @param Pr_RegParametro     OUT GE_PARAMETROS%ROWTYPE retorna registro parametro general
  * @param Pv_CodigoError      OUT VARCHAR2 retorna codigo de error de base de datos
  * @param Pv_MensajeError     OUT VARCHAR2 retorna mensaje error
  */
  PROCEDURE GEP_REG_PARAMETROS(Pv_IdEmpresa        IN VARCHAR2,
                               Pv_IdAplicacion     IN VARCHAR2,
                               Pv_IdGrupoParametro IN VARCHAR2,
                               Pv_IdParametro      IN VARCHAR2,
                               Pr_RegParametro     OUT GE_PARAMETROS%ROWTYPE,
                               Pv_CodigoError      OUT VARCHAR2,
                               Pv_MensajeError     OUT VARCHAR2);  

  /**
  * Documentacion para F_RECUPERA_IP
  * Funcion que recupera la IP para asignar en la forma
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 15/02/2017
  *
  * @return VARCHAR2 retorna dirección IP del equipo que invoca a la funcion
  */
  FUNCTION F_RECUPERA_IP RETURN VARCHAR2;

  /**
  * Documentacion para F_RECUPERA_LOGIN
  * Funcion que recupera login de empleado
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 15/02/2017
  *
  * @return VARCHAR2 retorna login del usuario que invoca a la funcion
  */
  FUNCTION F_RECUPERA_LOGIN RETURN VARCHAR2;

  /**
  * Documentacion para F_RECUPERA_OSUSER
  * Funcion que recupera usuario de sistema operativo
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/09/2017
  *
  * @return VARCHAR2 retorna usuario de sistema operativo del equipo que invoca a la funcion
  */
  FUNCTION F_RECUPERA_OSUSER RETURN VARCHAR2;

  /**
  * Documentacion para F_DESC_ADMI_CUENTA_CONTABLE
  * Funcion que recupera descripcion de parametros segun el detalle plantilla por tipo cuenta contable
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 26/06/2019
  *
  * @param Pv_NombreTabla IN VARCHAR2 recibe nombre de estructura a realizar la busqueda
  * @param Pv_NombreCampo IN VARCHAR2 recibe nombre de campo que identifica el parametro de busqueda
  * @param Pv_ValorBuscar IN VARCHAR2 recibe codigo de parametro a buscar
  * @param Pv_NoCia       IN VARCHAR2 recibe codigo de empresa
  * @return VARCHAR2 retorna descripcion de acuerdo al parametro configurado
  */
  FUNCTION F_DESC_ADMI_CUENTA_CONTABLE (Pv_NombreTabla  IN VARCHAR2,
                                        Pv_NombreCampo  IN VARCHAR2,
                                        Pv_ValorBuscar  IN VARCHAR2,
                                        Pv_NoCia        IN VARCHAR2) RETURN VARCHAR2;

  /**
  * Documentacion para F_VALIDA_NUMEROS
  * Funcion que valida si el dato es numérico
  * @author afayala <afayala@telconet.ec>
  * @version 1.0 23/04/2019
  *
  * @param  Pv_Texto          IN  varchar2  Recibe la cantidad a generar
  * @param  Pv_Error          OUT varchar2  Mensajes de error si se generan
  */
  PROCEDURE F_VALIDA_NUMEROS (Pv_Texto IN VARCHAR2,Pv_Error OUT VARCHAR2);

  /**
  * Documentacion para F_GET_JSON_PROVEEDORES
  * Funcion genera JSON con datos de proveedores recibiendo como parametro de busqueda la cedula o RUC
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 03/05/2020
  *
  * @param  Pv_Identificacion IN  varchar2  Recibe identificación de proveedor
  * @param  Pv_NoCia          IN  varchar2  Recibe código de compañía
  * @param  Pv_Status         OUT varchar2  retorna estado a webservice api-naf
  * @param  Pv_Mensaje        OUT varchar2  retorna mensaje de error a webservice api-naf
  * @return CLOB                            retorna JSON con datos de proveedor
  */
  FUNCTION F_GET_JSON_PROVEEDORES ( Pv_Identificacion VARCHAR2,
                                    Pv_NoCia          VARCHAR2,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2 ) RETURN CLOB;

END GEK_CONSULTA;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.GEK_CONSULTA IS

  FUNCTION GEF_ELIMINA_CARACTER_ESP(Pv_Texto IN VARCHAR2) RETURN VARCHAR2 IS
    Lv_Texto VARCHAR2(32767):=NULL;
    Lv_caracteres VARCHAR2(100);
  BEGIN
    Lv_Texto := Pv_Texto;
    SELECT VALOR1
    INTO Lv_caracteres
    FROM DB_GENERAL.ADMI_PARAMETRO_DET
    WHERE PARAMETRO_ID = (
    SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
    WHERE NOMBRE_PARAMETRO = 'CARACTERES_ESPECIALES');

    for i IN 1..length(Lv_caracteres) LOOP
      Lv_Texto := REPLACE(Lv_Texto,substr(Lv_caracteres,i,1),' ');
    END LOOP;

    Lv_Texto := REPLACE(Lv_Texto,CHR(10),' ');
    Lv_Texto := REPLACE(Lv_Texto,CHR(13),' ');
    Lv_Texto := TRIM(SUBSTR(UPPER(REGEXP_REPLACE(UTL_RAW.CAST_TO_VARCHAR2((NLSSORT(Lv_Texto, 'nls_sort=binary_ai'))), '[^a-z ^0-9@]', ' ')),1,32767));

    RETURN Lv_Texto;
  END GEF_ELIMINA_CARACTER_ESP;

  PROCEDURE GEP_REG_PARAMETROS(Pv_IdEmpresa        IN VARCHAR2,
                               Pv_IdAplicacion     IN VARCHAR2,
                               Pv_IdGrupoParametro IN VARCHAR2,
                               Pv_IdParametro      IN VARCHAR2,
                               Pr_RegParametro     OUT GE_PARAMETROS%ROWTYPE,
                               Pv_CodigoError      OUT VARCHAR2,
                               Pv_MensajeError     OUT VARCHAR2) IS
    --cursor que recupera datos de parametros
    CURSOR C_RegParametros IS
      SELECT P.*
      FROM NAF47_TNET.GE_PARAMETROS        P,
        NAF47_TNET.GE_GRUPOS_PARAMETROS GP
      WHERE P.ID_EMPRESA = GP.ID_EMPRESA
      AND P.ID_APLICACION = GP.ID_APLICACION
      AND P.ID_GRUPO_PARAMETRO = GP.ID_GRUPO_PARAMETRO
      AND P.PARAMETRO = Pv_IdParametro
      AND GP.ID_GRUPO_PARAMETRO = Pv_IdGrupoParametro
      AND GP.ID_APLICACION = Pv_IdAplicacion
      AND GP.ID_EMPRESA = Pv_IdEmpresa;

  BEGIN
    -- se recupeara datos de los parametros seleccionados.
    IF C_RegParametros%ISOPEN THEN
      CLOSE C_RegParametros;
    END IF;
    OPEN C_RegParametros;
    FETCH C_RegParametros
      INTO Pr_RegParametro;
    CLOSE C_RegParametros;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en GEK_CONSULTA.GEP_REG_PARAMETROS ' || Pv_CodigoError || '-' || SQLERRM;
  END GEP_REG_PARAMETROS;

  FUNCTION F_RECUPERA_IP RETURN VARCHAR2 IS
  BEGIN
    RETURN NVL(sys_context('userenv','ip_address'),'127.0.0.1');
  END F_RECUPERA_IP;

  FUNCTION F_RECUPERA_LOGIN RETURN VARCHAR2 IS

    -- Cursor que recupera login de usaurio conectado
    CURSOR C_LOGIN_USUARIO IS
      SELECT B.LOGIN
      FROM SEG47_TNET.TASGUSUARIO A,
        NAF47_TNET.LOGIN_EMPLEADO B
      WHERE A.ID_EMPLEADO = B.NO_EMPLE
      AND A.NO_CIA = B.NO_CIA
      AND A.USUARIO = USER
      AND B.LOGIN IS NOT NULL;
    --
    Lv_LoginEmpleado  VARCHAR2(50) := NULL;
    --
  BEGIN

    RETURN UPPER(USER);
    /*
    -- se busca login en tabla de empleados porque en naf hay usuarios antiguos que no son LDAP
    IF C_LOGIN_USUARIO%ISOPEN THEN
      CLOSE C_LOGIN_USUARIO;
    END IF;
    --
    OPEN C_LOGIN_USUARIO;
    FETCH C_LOGIN_USUARIO INTO Lv_LoginEmpleado;
    IF C_LOGIN_USUARIO%NOTFOUND THEN
      Lv_LoginEmpleado := USER;
    END IF;
    CLOSE C_LOGIN_USUARIO;

    --
    RETURN Lv_LoginEmpleado;
    --  
    */
  END F_RECUPERA_LOGIN;


  FUNCTION F_RECUPERA_OSUSER RETURN VARCHAR2 IS
  BEGIN
    RETURN sys_context('USERENV','OS_USER') ; 
  END F_RECUPERA_OSUSER;

  --
  FUNCTION F_DESC_ADMI_CUENTA_CONTABLE (Pv_NombreTabla  IN VARCHAR2,
                                        Pv_NombreCampo  IN VARCHAR2,
                                        Pv_ValorBuscar  IN VARCHAR2,
                                        Pv_NoCia        IN VARCHAR2) RETURN VARCHAR2 IS
    --
    Cl_Parametro       CONSTANT VARCHAR2(20) := 'PLANTILLA CONTABLE';
    Cl_ParRecuperaDesc CONSTANT VARCHAR2(20) := 'RECUPERA_DESCRIPCION';
    --
    CURSOR C_PARAMETRO IS
      SELECT VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION = Cl_ParRecuperaDesc
      AND APD.VALOR2 = Pv_NombreTabla
      AND APD.VALOR3 = Pv_NombreCampo
      AND APD.EMPRESA_COD = Pv_NoCia
      AND APC.NOMBRE_PARAMETRO = Cl_Parametro
      AND APD.PARAMETRO_ID = APC.ID_PARAMETRO;
    --
    Lv_SentenciaSQL  VARCHAR2(3000) := NULL;
    Lv_Resultado     VARCHAR2(3000) := NULL;
    --
  BEGIN
    --
    IF C_PARAMETRO%ISOPEN THEN
      CLOSE C_PARAMETRO;
    END IF;
    OPEN C_PARAMETRO;
    FETCH C_PARAMETRO INTO Lv_SentenciaSQL;
    IF C_PARAMETRO%NOTFOUND THEN 
      RETURN NULL;
    END IF;
    CLOSE C_PARAMETRO;
    --
    BEGIN
      EXECUTE IMMEDIATE Lv_SentenciaSQL INTO Lv_Resultado USING Pv_ValorBuscar ;
    EXCEPTION
      WHEN OTHERS THEN
        Lv_Resultado := 'Error ' || SQLERRM || ' : ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
    END;
    --
    RETURN Lv_Resultado;
    --
  END;

  PROCEDURE F_VALIDA_NUMEROS(Pv_Texto IN VARCHAR2, Pv_Error OUT VARCHAR2) IS
    Lv_Texto VARCHAR2(50) :=  NULL;
  BEGIN
    	IF LENGTH(TRIM(TRANSLATE(Pv_Texto , '0123456789',' '))) >= 1 THEN
        Lv_Texto:= 'Se deben ingresar sólo números enteros';
      END IF;
      Pv_Error:= Lv_Texto;
  END F_VALIDA_NUMEROS;



  FUNCTION F_GET_JSON_PROVEEDORES ( Pv_Identificacion VARCHAR2,
                                    Pv_NoCia          VARCHAR2,
                                    Pv_Status         OUT VARCHAR2,
                                    Pv_Mensaje        OUT VARCHAR2
                                   )
                                    RETURN CLOB IS
    --
    CURSOR C_PROVEEDOR IS
      SELECT MP.TIPO_ID_TRIBUTARIO,
             MP.CEDULA,
             REPLACE(REPLACE(MP.NOMBRE,CHR(13),' '), CHR(10), ' ') AS NOMBRE,
             REPLACE(REPLACE(MP.NOMBRE_LARGO,CHR(13),' '), CHR(10), ' ') AS NOMBRE_LARGO,
             REPLACE(REPLACE(MP.DIRECCION,CHR(13),' '), CHR(10), ' ') AS DIRECCION,
             MP.CANTON,
             (SELECT C.DESCRIPCION
              FROM NAF47_TNET.ARGECAN C
              WHERE C.CANTON = MP.CANTON
              AND C.PROVINCIA = MP.PROVINCIA
              AND C.PAIS = MP.PAIS) AS NOMBRE_CANTON,
             MP.CONDICION_TRIBUTARIA,
             (SELECT DESCRIPCION
              FROM NAF47_TNET.ARGECT
              WHERE CODIGO_CONDICION = MP.CONDICION_TRIBUTARIA) AS DESC_CONDICION_TRIBUTARIA,
             NVL(MP.TELEFONO, '222222') AS TELEFONO,
             NVL(MP.EMAIL1,'contabilidad_gye@telconet.ec') AS EMAIL1
      FROM NAF47_TNET.ARCPMP MP
      WHERE MP.CEDULA = Pv_Identificacion
      AND MP.NO_CIA = Pv_NoCia;     
    --
    Lv_JasonAux       VARCHAR2(32767) := NULL;
    Lv_RegJSon        VARCHAR2(1000) := NULL;
    Lv_Jason          CLOB := NULL;
    Ln_Linea          NUMBER := 0;
    Lv_Email          VARCHAR2(1000) := NULL;
    Lv_Telefono       NAF47_TNET.ARCPMP.TELEFONO%TYPE := NULL;
    --
    --Pv_Status         VARCHAR2(5) := NULL;
    --Pv_Mensaje        VARCHAR2(100) := NULL;
    --
  BEGIN
    --
    Pv_Mensaje := 'Transacción realizada con exito';
    Pv_Status  := '200';
    --
    Lv_Jason := '{'||chr(10);
    Lv_Jason := Lv_Jason||LPAD(' ',3, ' ')||'"proveedor":[';
    --
    FOR Lr_Datos in C_PROVEEDOR LOOP
      --
      IF Ln_Linea > 0 THEN
        Lv_JasonAux := Lv_JasonAux||',';
      END IF;
      --
      FOR I IN 1..LENGTH(Lr_datos.Telefono) LOOP
        IF SUBSTR(Lr_datos.Telefono, I, 1) >= CHR(48) 
          AND SUBSTR(Lr_datos.Telefono, I, 1) <= CHR(57) THEN
          IF Lv_Telefono IS NULL THEN
            Lv_Telefono := SUBSTR(Lr_datos.Telefono, I, 1);
          ELSE
            Lv_Telefono := Lv_Telefono || SUBSTR(Lr_datos.Telefono, I, 1);
          END IF;
        END IF;
      END LOOP;
      --
      IF INSTR(Lr_Datos.Email1,';') != 0 THEN
        Lv_Email := SUBSTR(Lr_Datos.Email1, 1, (INSTR(Lr_Datos.Email1,';')-1));
      ELSE
        Lv_Email := Lr_Datos.Email1;
      END IF;
      --
      Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
                    chr(10)||LPAD(' ',9, ' ')||'"tipoIdentificacion":"'||Lr_Datos.Tipo_Id_Tributario||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"identificacion":"'||Lr_Datos.Cedula||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"nombre":"'||Lr_Datos.Nombre||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"razonSocial":"'||Lr_Datos.Nombre_Largo||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"direccion":"'||Lr_Datos.Direccion||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"ciudad":"'||Lr_Datos.Nombre_Canton||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"tipoTributario":"'||Lr_Datos.Desc_Condicion_Tributaria||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"telefono":"'||Lv_Telefono||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"correo":"'||Lv_Email||'"'||
                    chr(10)||LPAD(' ',6, ' ')||'}';
      --
      IF LENGTH(Lv_JasonAux) + LENGTH(Lv_RegJSon)  > 32767 THEN
        Lv_Jason := Lv_Jason || Lv_JasonAux;
        Lv_JasonAux := Lv_RegJSon;
      ELSE
        Lv_JasonAux := Lv_JasonAux||Lv_RegJSon;
      END IF;
      --
      Ln_Linea := Ln_Linea + 1;
      --
    END LOOP;
    --
    Lv_Jason := Lv_Jason || Lv_JasonAux;
    Lv_Jason := Lv_Jason||chr(10)||LPAD(' ',3, ' ')||']';
    Lv_Jason := Lv_Jason||chr(10)||'}';
    --
    IF NVL(Ln_Linea,0) = 0 THEN
      Pv_Mensaje := 'No existen departamentos parametrizados para la Empresa';
      Pv_Status  := '404';
    END IF;
    --
    RETURN Lv_Jason;
    --
  END F_GET_JSON_PROVEEDORES;
END GEK_CONSULTA;
/
