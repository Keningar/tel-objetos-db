CREATE OR REPLACE package NAF47_TNET.INKG_CONSULTA is
/**
* Documentacion para NAF47_TNET.INKG_CONSULTA
* Packages que contiene funciones para retornar json para uso de webservices ApiNAF
* @author llindao <llindao@telconet.ec>
* @version 1.0 06/04/2020
*/

  /**
  * Documentacion para F_JSON_CARACTERISTICAS
  * Funcion que retorna JSON con los datos de las caracteristicas de NAF.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 06/04/2020
  *
  * @return CLOB retorna JSON con datos de caracteristicas
  */
  FUNCTION F_JSON_CARACTERISTICAS RETURN CLOB;

  /**
  * Documentacion para F_GET_JSON_ARTICULOS
  * Funcion que retorna JSON con los datos de las caracteristicas de NAF.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 06/04/2020
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 14/04/2020 - Se agrega parametro login para identificar ubicación de empleado y presentar articulos de bodega de misma localidad
  *
  * @param Pv_Articulo       IN VARCHAR2 Recibe decripción para filtro por artículo
  * @param Pv_Grupo          IN VARCHAR2 Recibe decripción para filtro por grupo
  * @param Pv_SubGrupo       IN VARCHAR2 Recibe decripción para filtro por sub grupo
  * @param Pv_Login          IN VARCHAR2 Recibe Login para filtro de articulos por localidad
  * @param Pv_NoCia          IN VARCHAR2 Recibe codigo de empresa
  * @return CLOB retorna JSON con datos de artículos por caracteristicas
  */
  FUNCTION F_GET_JSON_ARTICULOS (Pv_Articulo    VARCHAR2,
                                 Pv_Grupo       VARCHAR2,
                                 Pv_SubGrupo    VARCHAR2,
                                 Pv_Login       VARCHAR2,
                                 Pv_NoCia       VARCHAR2,
                                 Pv_Status  OUT VARCHAR2,
                                 Pv_Mensaje OUT VARCHAR2) RETURN CLOB;

  /**
  * Documentacion para F_GET_JSON_DEPARTAMENTOS
  * Funcion que retorna JSON con los datos de departamentos por compañia en NAF.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 22/04/2020
  *
  * @return CLOB retorna JSON con datos de departamentos
  */
  FUNCTION F_GET_JSON_DEPARTAMENTOS ( Pv_NoCia       VARCHAR2,
                                       Pv_Status  OUT VARCHAR2,
                                       Pv_Mensaje OUT VARCHAR2) RETURN CLOB;

  /**
  * Documentacion para F_GET_FECHA
  * Funcion que retorna fecha que puede ser usado como parametro en una vista.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 06/04/2020
  *
  * @return VARCHAR2 retorna fecha del sistema
  */
  FUNCTION F_GET_FECHA RETURN VARCHAR2;

  /**
  * Documentacion para F_GET_JSON_GRUPO
  * Función que retorna JSON con los datos de grupos por compañia en NAF.
  * @author Kevin Baque Puya <kbaque@telconet.ec>
  * @version 1.0 - 27/11/2020
  *
  * @return CLOB retorna JSON con datos de grupos
  */
  FUNCTION F_GET_JSON_GRUPO ( Pv_NoCia   VARCHAR2,
                              Pv_Estado  VARCHAR2,
                              Pv_Status  OUT VARCHAR2,
                              Pv_Mensaje OUT VARCHAR2) RETURN CLOB;

  /**
  * Documentacion para F_GET_JSON_SUBGRUPO
  * Función que retorna JSON con los datos de los subgrupos por compañia en NAF.
  * @author Kevin Baque Puya <kbaque@telconet.ec>
  * @version 1.0 - 27/11/2020
  *
  * @return CLOB retorna JSON con datos de subgrupos
  */
  FUNCTION F_GET_JSON_SUBGRUPO ( Pv_Grupo   VARCHAR2,
                                 Pv_NoCia   VARCHAR2,
                                 Pv_Estado  VARCHAR2,
                                 Pv_Status  OUT VARCHAR2,
                                 Pv_Mensaje OUT VARCHAR2) RETURN CLOB;

  /**
  * Documentacion para F_NUEVO_FLUJO_TRANSFERENCIA
  * Funcion que retorna si la empresa manjea nuevo flujo de transferencias
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 07/12/2020
  *
  * @return VARCHAR2 retorna fecha del sistema
  */
  FUNCTION F_NUEVO_FLUJO_TRANSFERENCIA (Pv_NoCia VARCHAR2) RETURN BOOLEAN;

  /**
  * Documentacion para F_VALIDA_NUMERO_SERIE
  * Funcion que retorna si número de serie puede ser ingresado en bodega.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 25/01/2021
  *
  * @param Pv_NumeroSerie   IN VARCHAR2          Número de serie a validar
  * @param Pv_NoCia         IN VARCHAR2          Código que identifica a la empresa 
  * @param Pv_MensajeError  IN OUT VARCHAR2      Retorna mensaje de error
  * @return BOOLEAN         retorna verdadero o falso.
  */
  FUNCTION F_VALIDA_NUMERO_SERIE ( Pv_NumeroSerie  IN VARCHAR2,
                                   Pv_NoCia        IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2,
                                   Pb_OtrasEmpresas IN BOOLEAN DEFAULT TRUE) RETURN BOOLEAN;


  /**
  * Documentacion para F_RECUPERA_FORMATO_SERIE
  * Funcion que retorna la descripcion total del detalle de formato número serie.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 30/07/2021
  *
  * @param Pn_FormatoSerieId   IN VARCHAR2  Recibe código de formato serie
  * @return BOOLEAN            retorna descripcion de formato serie.
  */
  FUNCTION F_RECUPERA_FORMATO_SERIE ( Pn_FormatoSerieId  IN VARCHAR2) RETURN VARCHAR2;


end INKG_CONSULTA;
/

CREATE OR REPLACE package body NAF47_TNET.INKG_CONSULTA is
  --
  Cl_ParDeptoCrm  CONSTANT VARCHAR2(28) := 'DEPARTAMENTOS_CRM_INSPECCION';
  Cl_EstadoActivo CONSTANT VARCHAR2(6) := 'Activo';
  --

  FUNCTION F_JSON_CARACTERISTICAS RETURN CLOB IS
    --
    CURSOR C_CARACTERISTICAS IS
      SELECT ID_CARACTERISTICA,
             DESCRIPCION
      FROM NAF47_TNET.ARIN_CARACTERISTICA
      WHERE ESTADO = 'A'
      AND ULTIMO_NIVEL = 'N'
      AND NIVEL = 1
      ORDER BY DESCRIPCION;
    --
    Lv_JasonAux VARCHAR2(32767) := NULL;
    Lv_RegJSon  VARCHAR2(1000) := NULL;
    Lv_Jason    CLOB := NULL;
    Ln_Linea    NUMBER := 0;
    --
  BEGIN
    --
    Lv_Jason := '{'||chr(10);
    Lv_Jason := Lv_Jason||LPAD(' ',3, ' ')||'"caracteristicas":['||chr(10);
    --
    FOR Lr_Datos IN C_CARACTERISTICAS LOOP
      --
      IF Ln_Linea > 0 THEN
        Lv_JasonAux := Lv_JasonAux||',';
      END IF;
      if Ln_Linea = 763 then
        dbms_output.put_line('revisar');
      end if;
      --
      Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
                    chr(10)||LPAD(' ',9, ' ')||'"caracteristicaId":"'||Lr_Datos.ID_CARACTERISTICA||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"descripcion":"'||Lr_Datos.DESCRIPCION||'"'||
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
    RETURN Lv_Jason;
    --
  END F_JSON_CARACTERISTICAS;
  --
  --
  FUNCTION F_GET_JSON_ARTICULOS (Pv_Articulo    VARCHAR2,
                                 Pv_Grupo       VARCHAR2,
                                 Pv_SubGrupo    VARCHAR2,
                                 Pv_Login       VARCHAR2,
                                 Pv_NoCia       VARCHAR2,
                                 Pv_Status  OUT VARCHAR2,
                                 Pv_Mensaje OUT VARCHAR2) RETURN CLOB IS
    --
    CURSOR C_CANTON_USUARIO IS
      SELECT IOG.CANTON_ID
      FROM DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
           NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
      WHERE VE.LOGIN_EMPLE = Pv_Login
      AND VE.NO_CIA = Pv_NoCia
      AND VE.OFICINA = IOG.ID_OFICINA;
    --
   CURSOR C_ARTICULOS (Cn_CantonId NUMBER) IS
    SELECT
         *
    FROM
        NAF47_TNET.V_ARTICULOS_CARACTERISTICAS MA
    WHERE MA.NO_CIA               = Pv_NoCia
        AND MA.ID_CANTON          = Cn_CantonId
        AND MA.ESTADO_ARTI_ACTIVO = 'S'
        AND MA.GRUPO              = Pv_Grupo
        AND MA.SUBGRUPO           = Pv_SubGrupo
        AND MA.DESC_ARTICULO LIKE '%'||UPPER(TRIM(Pv_Articulo))||'%'
     ORDER BY MA.BODEGA, MA.DESC_ARTICULO;
    --
    CURSOR C_VALOR_COMPRA (Cv_NoArti VARCHAR2,
                           Cv_NoCia  VARCHAR2) IS
      SELECT MN.COSTO_UNI
      FROM NAF47_TNET.ARINVTM TM,
           NAF47_TNET.ARINMN MN
      WHERE MN.NO_ARTI = Cv_NoArti
      AND MN.NO_CIA = Cv_NoCia
      AND TM.MOVIMI = 'E'
      AND TM.REG_MOV = 'S'
      AND TM.CONSUM = 'N'
      AND TM.COMPRA = 'S'
      AND TM.PRODUCCION = 'N'
      AND TM.VENTAS = 'N'
      AND TM.INTERFACE <> 'IM'
      AND TM.ESTADO = 'A'
      AND TM.CLASE_MOVIMIENTO = 'CM'
      AND MN.TIPO_DOC = TM.TIPO_M
      AND MN.NO_CIA = TM.NO_CIA
      ORDER BY MN.TIME_STAMP DESC;
    --
    Lv_JasonAux       VARCHAR2(32767) := NULL;
    Lv_RegJSon        VARCHAR2(1000) := NULL;
    Lv_Jason          CLOB := NULL;
    Ln_Linea          NUMBER := 0;
    Ln_ValorUltCompra NUMBER := 0;
    Ln_CantonLogin    NUMBER := 0;
    --
  BEGIN
    --
    Pv_Status  := '200';
    Pv_Mensaje := 'Transacción realizada con éxito';
    --
    -- se recupera canto de usuario
    IF C_CANTON_USUARIO%ISOPEN THEN
      CLOSE C_CANTON_USUARIO;
    END IF;
    OPEN C_CANTON_USUARIO;
    FETCH C_CANTON_USUARIO INTO Ln_CantonLogin;
    IF C_CANTON_USUARIO%NOTFOUND THEN
      Ln_CantonLogin := 0;
    END IF;
    CLOSE C_CANTON_USUARIO;
    --
    Lv_Jason := '{'||chr(10);
    Lv_Jason := Lv_Jason||LPAD(' ',3, ' ')||'"articulos":[';
    --
    IF NVL(Ln_CantonLogin,0) = 0 THEN
      Pv_Status  := '404';
      Pv_Mensaje := 'No se encontró ciudad a la que pertenece usuario '||Pv_Login;
      GOTO ET01_FIN_JSON;
    END IF;
    --
    FOR Lr_Datos in C_ARTICULOS (Ln_CantonLogin) LOOP
      --
      IF C_VALOR_COMPRA%ISOPEN THEN
        CLOSE C_VALOR_COMPRA;
      END IF;
      OPEN C_VALOR_COMPRA(Lr_Datos.No_Arti,
                          Pv_NoCia);
      FETCH C_VALOR_COMPRA INTO Ln_ValorUltCompra;
      IF C_VALOR_COMPRA%NOTFOUND THEN
        Ln_ValorUltCompra := 0;
      END IF;
      CLOSE C_VALOR_COMPRA;
      --
      IF Ln_Linea > 0 THEN
        Lv_JasonAux := Lv_JasonAux||',';
      END IF;
      --
      Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
                    chr(10)||LPAD(' ',9, ' ')||'"articuloId":"'||Lr_Datos.No_Arti||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"modeloArticulo":"'||Lr_Datos.Modelo||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"descArticulo":"'||Lr_Datos.Desc_Articulo||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"marca":"'||Lr_Datos.Marca||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"bodegaId":"'||Lr_Datos.Bodega||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"descBodega":"'||Lr_Datos.Desc_Bodega||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"stock":"'||Lr_Datos.Stock||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"Precio":"'||trim(to_char(Ln_ValorUltCompra,'999,999,990.99'))||'"'||
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
    --
    IF Ln_Linea = 0 THEN
      Pv_Status  := '404';
      Pv_Mensaje := 'No se encontraron artículos en localidad a la que pertenece el usuario '||Pv_Login;
    END IF;
    --
    <<ET01_FIN_JSON>>
    --
    Lv_Jason := Lv_Jason||chr(10)||LPAD(' ',3, ' ')||']';
    Lv_Jason := Lv_Jason||chr(10)||'}';
    --
    RETURN Lv_Jason;
    --
  END F_GET_JSON_ARTICULOS;  
  --
  --  
  FUNCTION F_GET_JSON_DEPARTAMENTOS ( Pv_NoCia       VARCHAR2,
                                       Pv_Status  OUT VARCHAR2,
                                       Pv_Mensaje OUT VARCHAR2) RETURN CLOB IS
    --
    CURSOR C_DEPARTAMENTOS IS
      SELECT DP.NO_CIA,
             DP.DEPA DEPTO,
             REPLACE(REPLACE(DP.DESCRI,CHR(10),' '),CHR(13),' ') NOMBRE_DEPTO,
             DP.AREA,
             REPLACE(REPLACE(AR.DESCRI,CHR(10),' '),CHR(13),' ') NOMBRE_AREA
      FROM NAF47_TNET.ARPLDP DP,
           NAF47_TNET.ARPLAR AR
      WHERE DP.NO_CIA = Pv_NoCia
      AND DP.AREA = AR.AREA
      AND DP.NO_CIA = AR.NO_CIA
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                       DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APD.ESTADO = Cl_EstadoActivo
                  AND APD.VALOR1 = DP.DEPA
                  AND APD.VALOR2 = DP.AREA
                  AND APD.EMPRESA_COD = DP.NO_CIA
                  AND APC.ESTADO = Cl_EstadoActivo
                  AND APC.NOMBRE_PARAMETRO = Cl_ParDeptoCrm
                  AND APD.PARAMETRO_ID = APC.ID_PARAMETRO)
      ORDER BY DP.AREA, DP.DEPA;
    --
    Lv_JasonAux       VARCHAR2(32767) := NULL;
    Lv_RegJSon        VARCHAR2(1000) := NULL;
    Lv_Jason          CLOB := NULL;
    Ln_Linea          NUMBER := 0;
    --
  BEGIN
    --
    Pv_Mensaje := 'Transacción realizada con exito';
    Pv_Status  := '200';
    --
    Lv_Jason := '{'||chr(10);
    Lv_Jason := Lv_Jason||LPAD(' ',3, ' ')||'"departamentos":[';
    --
    FOR Lr_Datos in C_DEPARTAMENTOS LOOP
      --
      IF Ln_Linea > 0 THEN
        Lv_JasonAux := Lv_JasonAux||',';
      END IF;
      --
      Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
                    chr(10)||LPAD(' ',9, ' ')||'"noCia":"'||Lr_Datos.No_Cia||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"departamento":"'||Lr_Datos.Depto||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"nombreDepartamento":"'||Lr_Datos.Nombre_Depto||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"area":"'||Lr_Datos.Area||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"nombreArea":"'||Lr_Datos.Nombre_Area||'"'||
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
  END F_GET_JSON_DEPARTAMENTOS;
  --
  --
  FUNCTION F_GET_FECHA RETURN VARCHAR2 IS
    Lv_Fecha VARCHAR2(20) := TO_CHAR(SYSDATE, 'DD-MM-YYYY HH24:MI:SS');
  BEGIN
    RETURN Lv_Fecha;
  END;
  --
  --
  FUNCTION F_GET_JSON_GRUPO ( Pv_NoCia   VARCHAR2,
                              Pv_Estado  VARCHAR2,
                              Pv_Status  OUT VARCHAR2,
                              Pv_Mensaje OUT VARCHAR2) RETURN CLOB IS
    --
    CURSOR C_GRUPOS IS
    SELECT
        *
    FROM
        NAF47_TNET.ARINDIV
    WHERE
        NO_CIA     = Pv_NoCia
        AND ESTADO = Pv_Estado
    ORDER BY
        DESCRIPCION ASC;
    --
    Lv_JasonAux       VARCHAR2(32767) := NULL;
    Lv_RegJSon        VARCHAR2(1000)  := NULL;
    Lv_Jason          CLOB := NULL;
    Ln_Linea          NUMBER := 0;
    --
  BEGIN
    --
    Pv_Status  := '200';
    Pv_Mensaje := 'Transacción realizada con éxito';
    --
    Lv_Jason := '{'||chr(10);
    Lv_Jason := Lv_Jason||LPAD(' ',3, ' ')||'"grupos":[';
    --
    FOR Lr_Datos in C_GRUPOS LOOP
      --
      IF Ln_Linea > 0 THEN
        Lv_JasonAux := Lv_JasonAux||',';
      END IF;
      --
      Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
                    chr(10)||LPAD(' ',9, ' ')||'"intIdGrupo":"'||TRIM(Lr_Datos.Division)||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"strDescripcion":"'||TRIM(Lr_Datos.Descripcion)||'"'||
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
    --
    IF Ln_Linea = 0 THEN
      Pv_Status  := '404';
      Pv_Mensaje := 'No se encontraron Grupos ';
    END IF;

    Lv_Jason := Lv_Jason||chr(10)||LPAD(' ',3, ' ')||']';
    Lv_Jason := Lv_Jason||chr(10)||'}';
    --
    RETURN Lv_Jason;
    --
  END F_GET_JSON_GRUPO;

FUNCTION F_GET_JSON_SUBGRUPO ( Pv_Grupo   VARCHAR2,
                               Pv_NoCia   VARCHAR2,
                               Pv_Estado  VARCHAR2,
                               Pv_Status  OUT VARCHAR2,
                               Pv_Mensaje OUT VARCHAR2) RETURN CLOB IS
    --
    CURSOR C_SUBGRUPOS IS
    SELECT
        SUBGRUPO.DIVISION      AS INTIDGRUPO,
        SUBGRUPO.SUBDIVISION   AS INTIDSUBGRUPO,
        SUBGRUPO.DESCRIPCION   AS STRDESCRIPCIONSUBGRUPO
    FROM
        NAF47_TNET.ARINSUBDIV   SUBGRUPO
        JOIN NAF47_TNET.ARINDIV      GRUPO ON GRUPO.DIVISION = SUBGRUPO.DIVISION
    WHERE
        SUBGRUPO.NO_CIA       = Pv_NoCia
        AND GRUPO.NO_CIA      = Pv_NoCia
        AND SUBGRUPO.ESTADO   = Pv_Estado
        AND GRUPO.ESTADO      = Pv_Estado
        AND SUBGRUPO.DIVISION = Pv_Grupo
    ORDER BY
        SUBGRUPO.DESCRIPCION ASC;
    --
    Lv_JasonAux       VARCHAR2(32767) := NULL;
    Lv_RegJSon        VARCHAR2(1000)  := NULL;
    Lv_Jason          CLOB := NULL;
    Ln_Linea          NUMBER := 0;
    --
  BEGIN
    --
    Pv_Status  := '200';
    Pv_Mensaje := 'Transacción realizada con éxito';
    --
    Lv_Jason := '{'||chr(10);
    Lv_Jason := Lv_Jason||LPAD(' ',3, ' ')||'"subgrupos":[';
    --
    FOR Lr_Datos in C_SUBGRUPOS LOOP
      --
      IF Ln_Linea > 0 THEN
        Lv_JasonAux := Lv_JasonAux||',';
      END IF;
      --
      Lv_RegJSon := chr(10)||LPAD(' ',6, ' ')||'{'||
                    chr(10)||LPAD(' ',9, ' ')||'"intIdGrupo":"'||TRIM(Lr_Datos.INTIDGRUPO)||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"intIdSubGrupo":"'||TRIM(Lr_Datos.INTIDSUBGRUPO)||'",'||
                    chr(10)||LPAD(' ',9, ' ')||'"strDescripcion":"'||TRIM(Lr_Datos.STRDESCRIPCIONSUBGRUPO)||'"'||
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
    --
    IF Ln_Linea = 0 THEN
      Pv_Status  := '404';
      Pv_Mensaje := 'No se encontraron SubGrupos ';
    END IF;

    Lv_Jason := Lv_Jason||chr(10)||LPAD(' ',3, ' ')||']';
    Lv_Jason := Lv_Jason||chr(10)||'}';
    --
    RETURN Lv_Jason;
    --
  END F_GET_JSON_SUBGRUPO;
  --
  --
  FUNCTION F_NUEVO_FLUJO_TRANSFERENCIA (Pv_NoCia VARCHAR2) RETURN BOOLEAN IS
    --
    P_CENTRO_DISTRIBUCION    CONSTANT VARCHAR2(19) := 'CENTRO_DISTRIBUCION';
    P_PARAMETROS_INVENTARIOS CONSTANT VARCHAR2(22) := 'PARAMETROS-INVENTARIOS';
    --
    CURSOR C_VALIDA_NUEVO_FLUJO IS
      SELECT COUNT(APD.ID_PARAMETRO_DET) CANTIDAD
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.EMPRESA_COD = Pv_NoCia
      AND APD.DESCRIPCION = P_CENTRO_DISTRIBUCION
      AND APD.ESTADO = GEK_VAR.Gr_Estado.ACTIVO
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                  AND APC.NOMBRE_PARAMETRO = P_PARAMETROS_INVENTARIOS);
   --
   Lb_EsNuevoFlujo  BOOLEAN := TRUE;
   Ln_CentrosConf   NUMBER(3) := 0;
   --
  BEGIN
    --
    IF C_VALIDA_NUEVO_FLUJO%ISOPEN THEN
      CLOSE C_VALIDA_NUEVO_FLUJO;
    END IF;
    OPEN C_VALIDA_NUEVO_FLUJO;
    FETCH C_VALIDA_NUEVO_FLUJO INTO Ln_CentrosConf;
    IF C_VALIDA_NUEVO_FLUJO%NOTFOUND THEN
      Ln_CentrosConf := 0;
    END IF;
    CLOSE C_VALIDA_NUEVO_FLUJO;
    --
    IF Ln_CentrosConf = 0 THEN
      Lb_EsNuevoFlujo := FALSE;
    END IF;
    --
    RETURN Lb_EsNuevoFlujo;
  END;
  --
  --

  FUNCTION F_VALIDA_NUMERO_SERIE ( Pv_NumeroSerie  IN VARCHAR2,
                                   Pv_NoCia        IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2,
                                   Pb_OtrasEmpresas IN BOOLEAN DEFAULT TRUE) RETURN BOOLEAN IS
    --
    EMBODEGADO             CONSTANT VARCHAR2(2) := 'EB';
    INSTALADO              CONSTANT VARCHAR2(2) := 'IN';
    PENDIENTE_INSTALAR     CONSTANT VARCHAR2(2) := 'PI';
    ENTRADA                CONSTANT VARCHAR2(1) := 'E';
    SALIDA                 CONSTANT VARCHAR2(1) := 'S';
    PENDIENTE              CONSTANT VARCHAR2(1) := 'P';
    PROCESADO              CONSTANT VARCHAR2(9) := 'Procesado';
    SIN_BOD_TRANSITO       CONSTANT VARCHAR2(19) := 'SinBodegaEnTransito';
    VALIDA_SERIE_EMPRESA   CONSTANT VARCHAR2(20) := 'VALIDA-SERIE-EMPRESA';
    PARAMETROS_INVENTARIOS CONSTANT VARCHAR2(22) := 'PARAMETROS-INVENTARIOS';
    --
    CURSOR C_NUMERO_SERIE IS
      SELECT COMPANIA,
             NO_ARTICULO, 
             ID_BODEGA,
             ESTADO
      FROM NAF47_TNET.INV_NUMERO_SERIE
      WHERE SERIE  = Pv_NumeroSerie
      AND COMPANIA = Pv_NoCia
      AND ESTADO = EMBODEGADO;
    --
    CURSOR C_VERIFICA_REPOSITORIO IS
      SELECT A.ESTADO,
             'INSTALADO' AS DESC_ESTADO,
             A.FE_CREACION, 
             A.FE_ULT_MOD
      FROM NAF47_TNET.IN_ARTICULOS_INSTALACION A
      WHERE A.NUMERO_SERIE = Pv_NumeroSerie
      AND A.ESTADO = INSTALADO
      AND A.ID_COMPANIA = Pv_NoCia
      UNION ALL
      SELECT A.ESTADO,
             'PENDIENTE INSTALAR' AS DESC_ESTADO,
             A.FE_CREACION, 
             A.FE_ULT_MOD
      FROM NAF47_TNET.IN_ARTICULOS_INSTALACION A
      WHERE A.NUMERO_SERIE = Pv_NumeroSerie
      AND A.ESTADO = PENDIENTE_INSTALAR
      AND A.ID_COMPANIA = Pv_NoCia;
    --
    CURSOR C_ACTIVO_FIJO IS
      SELECT NO_ACTI
      FROM NAF47_TNET.ARAFMA
      WHERE SERIE = Pv_NumeroSerie
      AND NO_CIA = Pv_NoCia
      AND EXISTS (SELECT NULL
                  FROM NAF47_TNET.ARAFMM
                  WHERE ARAFMM.NO_ACTI = ARAFMA.NO_ACTI
                  AND ARAFMM.NO_CIA = ARAFMA.NO_CIA
                  AND ARAFMM.TIPO_M = SALIDA
                  AND ARAFMA.ESTADO != PENDIENTE);
    --
    CURSOR C_VALIDA_TRANSFERENCIA IS
      SELECT PINS.NO_DOCUMENTO,
             TE.FECHA,
             TE.BOD_DEST,
             BO.DESCRIPCION
      FROM NAF47_TNET.ARINBO BO,
           NAF47_TNET.ARINTE TE,
           NAF47_TNET.ARINTL TL,
           NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE PINS
      WHERE PINS.SERIE = Pv_NumeroSerie
      AND PINS.ESTADO = PROCESADO
      AND TE.TIPO_FLUJO = SIN_BOD_TRANSITO
      AND TL.SALDO > 0
      AND PINS.COMPANIA = Pv_NoCia
      AND NOT EXISTS (SELECT NULL
                      FROM NAF47_TNET.ARINVTM TMTE,
                           NAF47_TNET.ARINME UTE
                      WHERE UTE.NO_DOCU = TE.NO_DOCU_REF
                      AND UTE.NO_CIA = TE.NO_CIA
                      AND UTE.ESTADO != PENDIENTE
                      AND TMTE.MOVIMI = ENTRADA
                      AND TMTE.TRASLA = SALIDA --SI
                      AND EXISTS (SELECT NULL
                                  FROM NAF47_TNET.ARINVTM TMTT,
                                       NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE SIB,
                                       NAF47_TNET.ARINMN MN,
                                       NAF47_TNET.ARINME TTE
                                  WHERE TTE.NO_DOCU_REFE = UTE.NO_DOCU_REFE
                                  AND TTE.NO_CIA = UTE.NO_CIA
                                  AND TTE.ESTADO != PENDIENTE
                                  AND TMTT.MOVIMI = ENTRADA
                                  AND TMTT.TRASLA = SALIDA --SI
                                  AND TTE.TIPO_DOC = TMTT.TIPO_M
                                  AND TTE.NO_CIA = TMTT.NO_CIA
                                  AND SIB.SERIE = PINS.SERIE
                                  AND SIB.NO_ARTICULO = PINS.NO_ARTICULO
                                  AND SIB.COMPANIA = PINS.COMPANIA
                                  AND MN.NO_ARTI = SIB.NO_ARTICULO
                                  AND MN.NO_DOCU = SIB.NO_DOCUMENTO
                                  AND MN.NO_CIA = SIB.COMPANIA
                                  AND TTE.NO_CIA = MN.NO_CIA
                                  AND TTE.NO_DOCU = MN.NO_DOCU)
                     AND UTE.TIPO_DOC = TMTE.TIPO_M
                     AND UTE.NO_CIA = TMTE.NO_CIA
                     )
      AND TE.BOD_DEST = BO.CODIGO
      AND TE.NO_CIA = BO.NO_CIA
      AND TL.NO_DOCU = TE.NO_DOCU
      AND TL.NO_CIA = TE.NO_CIA
      AND PINS.NO_ARTICULO = TL.NO_ARTI
      AND PINS.NO_DOCUMENTO = TL.NO_DOCU
      AND PINS.COMPANIA = TL.NO_CIA;
    --
    CURSOR C_VALIDA_OTRAS_EMPRESAS IS
      SELECT APD.VALOR1 AS NO_CIA
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION = VALIDA_SERIE_EMPRESA
      AND APD.EMPRESA_COD = Pv_NoCia
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                  AND APC.ID_PARAMETRO = APD.PARAMETRO_ID);
    --
    Lr_Transferencia C_VALIDA_TRANSFERENCIA%ROWTYPE;
    Lr_numeroSerie   C_NUMERO_SERIE%ROWTYPE;
    Lr_Datos         C_VALIDA_OTRAS_EMPRESAS%ROWTYPE;
    Ln_IdActivo      ARAFMA.NO_ACTI%TYPE := NULL;
    --
    Lb_SerieValida    BOOLEAN := TRUE;
    --
  BEGIN
    --
    --Si existe se valida que este fuera de bodega para reingresarse.
    IF C_NUMERO_SERIE%ISOPEN THEN CLOSE C_NUMERO_SERIE; END IF;
    OPEN C_NUMERO_SERIE;
    FETCH C_NUMERO_SERIE INTO Lr_numeroSerie;
    CLOSE C_NUMERO_SERIE;
    --
    IF Lr_numeroSerie.Compania IS NOT NULL THEN
           Pv_MensajeError := 'Numero serie ' || Pv_NumeroSerie || ' se encuentra en bodega ' ||
                              Lr_numeroSerie.id_bodega || ' asociado a producto ' ||
                              Lr_numeroSerie.no_articulo || ' de la Empresa ' ||
                              Lr_numeroSerie.compania || ', no puede ser ingresado.';
      Lb_SerieValida := FALSE;
      GOTO ET_FIN_VALIDACION;
    END IF;
    -- se valida que activo fijo no se ecnuentre dado de baja
    IF C_ACTIVO_FIJO%ISOPEN THEN
      CLOSE C_ACTIVO_FIJO;
    END IF;
    OPEN C_ACTIVO_FIJO;
    FETCH C_ACTIVO_FIJO INTO Ln_IdActivo;
    CLOSE C_ACTIVO_FIJO;
    --
    IF Ln_IdActivo IS NOT NULL THEN
      Pv_MensajeError := 'Número de serie pertenece a acivo fijo '||Ln_IdActivo||' dado de Baja';
      Lb_SerieValida := FALSE;
      GOTO ET_FIN_VALIDACION;
    END IF;
    --
    -- Se verifica si numero dew serie existe en el repositorio --
    FOR VR IN C_VERIFICA_REPOSITORIO LOOP
      IF VR.ESTADO = INSTALADO THEN
        IF Pv_MensajeError IS NULL THEN
          Pv_MensajeError := VR.DESC_ESTADO||' desde '||TO_CHAR(VR.FE_ULT_MOD,'DD/MM/YYYY');
        ELSE
          Pv_MensajeError := Pv_MensajeError||CHR(13)||VR.DESC_ESTADO||' desde '||TO_CHAR(VR.FE_ULT_MOD,'DD/MM/YYYY');
        END IF;
      ELSIF VR.ESTADO = PENDIENTE_INSTALAR THEN
        IF Pv_MensajeError IS NULL THEN
          Pv_MensajeError := VR.DESC_ESTADO||' desde '||TO_CHAR(VR.FE_CREACION,'DD/MM/YYYY');
        ELSE
          Pv_MensajeError := Pv_MensajeError||CHR(13)||VR.DESC_ESTADO||' desde '||TO_CHAR(VR.FE_CREACION,'DD/MM/YYYY');
        END IF;
      END IF;
    END LOOP;
    --
    IF Pv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := 'No. Serie '||Pv_NumeroSerie||' se encuentra en Repositorio '||chr(13)||Pv_MensajeError||', Favor regule repositorio instalación';
      Lb_SerieValida := FALSE;
      GOTO ET_FIN_VALIDACION;
    END IF;
    --
    -- Valida transferencias
    IF C_VALIDA_TRANSFERENCIA%ISOPEN THEN
      CLOSE C_VALIDA_TRANSFERENCIA;
    END IF;
    OPEN C_VALIDA_TRANSFERENCIA;
    FETCH C_VALIDA_TRANSFERENCIA INTO Lr_Transferencia;
    CLOSE C_VALIDA_TRANSFERENCIA;
    --
    IF Lr_Transferencia.No_Documento IS NOT NULL THEN
      Pv_MensajeError := 'No. Serie '||Pv_NumeroSerie||' se encuentra transferencia '||Lr_Transferencia.No_Documento||
                         ' pendiente recibir en '||Lr_Transferencia.Descripcion||' ['||Lr_Transferencia.Bod_Dest||']';
      Lb_SerieValida := FALSE;
      GOTO ET_FIN_VALIDACION;
    END IF;
    --
    -- or defecto viene TRUE pero al ser invocado recursivamente se envia FALSE para que no genere ciclo infinito
    IF Pb_OtrasEmpresas THEN
      --
      IF C_VALIDA_OTRAS_EMPRESAS%ISOPEN THEN
        CLOSE C_VALIDA_OTRAS_EMPRESAS;
      END IF;
      OPEN C_VALIDA_OTRAS_EMPRESAS;
      FETCH C_VALIDA_OTRAS_EMPRESAS INTO Lr_Datos;
      --
      LOOP
        --
        Lb_SerieValida := F_VALIDA_NUMERO_SERIE( Pv_NumeroSerie,
                                                 Lr_Datos.No_Cia,
                                                 Pv_MensajeError,
                                                 FALSE);
       EXIT WHEN NOT Lb_SerieValida OR C_VALIDA_OTRAS_EMPRESAS%NOTFOUND;
       FETCH C_VALIDA_OTRAS_EMPRESAS INTO Lr_Datos;
      END LOOP;
      --
    END IF;
    --
    <<ET_FIN_VALIDACION>>
    --
    RETURN Lb_SerieValida;
    --
  END F_VALIDA_NUMERO_SERIE;
  --
  --
  FUNCTION F_RECUPERA_FORMATO_SERIE ( Pn_FormatoSerieId  IN VARCHAR2) RETURN VARCHAR2 IS
    --
    DETALLE_FORMATO_SERIE  CONSTANT VARCHAR2(21) := 'DETALLE-FORMATO-SERIE';
    PARAMETROS_INVENTARIOS CONSTANT VARCHAR2(22) := 'PARAMETROS-INVENTARIOS';
    --
    -- costo query: 5
    CURSOR C_DETALLE_FORMATO IS
      SELECT APD.VALOR4 AS TIPO,
             APD.VALOR5 AS NOMBRE,
             APD.VALOR1 AS VALORES,
             APD.ESTADO
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.VALOR2 = TO_CHAR(Pn_FormatoSerieId)
      AND APD.DESCRIPCION = DETALLE_FORMATO_SERIE
      AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
      AND EXISTS (SELECT NULL 
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC  
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID 
                  AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS) 
      ORDER BY TO_NUMBER(VALOR3);
    --
    Lv_FormatoSerie VARCHAR2(1000);
    --
  BEGIN
    --
    FOR Lr_FormatoSerie IN C_DETALLE_FORMATO LOOP
      --
      IF Lr_FormatoSerie.Tipo = 'Variable' THEN
        Lv_FormatoSerie := Lv_FormatoSerie||'['||Lr_FormatoSerie.Nombre||']';
      ELSIF Lr_FormatoSerie.Tipo = 'Fijo' THEN
        Lv_FormatoSerie := Lv_FormatoSerie||Lr_FormatoSerie.Valores;
      END IF;
      -- 
    END LOOP;
    --
    RETURN Lv_FormatoSerie;
    --
  END F_RECUPERA_FORMATO_SERIE;
  --
  --
end INKG_CONSULTA;
/
