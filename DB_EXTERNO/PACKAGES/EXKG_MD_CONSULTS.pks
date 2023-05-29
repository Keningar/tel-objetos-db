SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_EXTERNO.EXKG_MD_CONSULTS AS

  /**
   * Documentación para el procedimiento 'P_OBTIENE_PROMOCIONES'.
   *
   * Proceso encargado de obtener todas las promociones en estado Pendiente.
   *
   * Costo Query Pr_Promociones : 10
   * Costo Query C_Parametros   : 4
   *
   * @Param Pv_FechaInicio   IN  VARCHAR2      : Fecha Inicio de consulta de las promociones (RRRR-MM-DD).
   * @Param Pv_FechaFin      IN  VARCHAR2      : Fecha Fin de consulta de las promociones (RRRR-MM-DD).
   * @Param Pv_TipoPromocion IN  VARCHAR2      : Tipo de promoción a consultar.
   * @Param Pv_TipoProceso   IN  VARCHAR2      : Tipo de proceso a consultar.
   * @Param Pv_LoginPunto    IN  VARCHAR2      : Login del punto a consultar.
   * @Param Pr_Promociones   OUT SYS_REFCURSOR : Retorna un record de toda las promociones en estado Pendiente.
   * @Param Pv_Mensaje       OUT VARCHAR2      : Mensaje de error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.1 12-11-2019 - Se agrega el cursor 'C_Parametros' para obtener la cantidad de días permitidos
   *                           para consultar los procesos de promoción.
   */
  PROCEDURE P_OBTIENE_PROMOCIONES(Pv_FechaInicio   IN  VARCHAR2,
                                  Pv_FechaFin      IN  VARCHAR2,
                                  Pv_TipoPromocion IN  VARCHAR2,
                                  Pv_TipoProceso   IN  VARCHAR2,
                                  Pv_LoginPunto    IN  VARCHAR2,
                                  Pr_Promociones   OUT SYS_REFCURSOR,
                                  Pv_Mensaje       OUT VARCHAR2);

  TYPE Crf_Result
  IS
    REF
    CURSOR;
  
  /**
   * Documentación para P_CONSULTA_DATA
   * Procedimiento principal que permite realizar consultas hacia data de MD, de información
   * comercial, tecnica y de soporte
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param PCL_JSONFILTROS IN CLOB Recibe en formato Json, los filtros y columnas a mostrar de la consulta
   * @param Pv_MensaError   OUT VARCHAR2 Muestra si hubo algún error en el proceso
   * @param Prf_Result      OUT Crf_Result Devuelve un cursor con toda la información consultada.
   */
  PROCEDURE P_CONSULTA_DATA(PCL_JSONFILTROS IN CLOB,
                             Pv_MensaError OUT VARCHAR2,
                             Prf_Result OUT Crf_Result);
  
  /**
   * Documentación para P_INFO_BASICA
   * Procedimiento que permite realizar consultas de información básica hacia data de MD
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param PCL_JSONFILTROS IN CLOB Recibe en formato Json, los filtros y columnas a mostrar de la consulta
   * @param Pv_MensaError   OUT VARCHAR2 Muestra si hubo algún error en el proceso
   * @param Prf_Result      OUT Crf_Result Devuelve un cursor con toda la información consultada.
   */
  PROCEDURE P_INFO_BASICA(PCL_JSONFILTROS IN CLOB,
                           Pv_MensaError OUT VARCHAR2,
                           Prf_Result OUT Crf_Result);
  
  /**
   * Documentación para P_INFO_PUNTO
   * Procedimiento que permite realizar consultas de información del punto, hacia data de MD, información
   * técnica y comercial
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param PCL_JSONFILTROS IN CLOB Recibe en formato Json, los filtros y columnas a mostrar de la consulta
   * @param Pv_MensaError   OUT VARCHAR2 Muestra si hubo algún error en el proceso
   * @param Prf_Result      OUT Crf_Result Devuelve un cursor con toda la información consultada.
   */
  PROCEDURE P_INFO_PUNTO(PCL_JSONFILTROS IN CLOB,
                          Pv_MensaError OUT VARCHAR2,
                          Prf_Result OUT Crf_Result);
  
  /**
   * Documentación para P_INFO_CASOS
   * Procedimiento que permite realizar consultas de información de casos por cliente, hacia data de MD, información
   * de soporte
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param PCL_JSONFILTROS IN CLOB Recibe en formato Json, los filtros y columnas a mostrar de la consulta
   * @param Pv_MensaError   OUT VARCHAR2 Muestra si hubo algún error en el proceso
   * @param Prf_Result      OUT Crf_Result Devuelve un cursor con toda la información consultada.
   */                         
  PROCEDURE P_INFO_CASOS(PCL_JSONFILTROS IN CLOB,
                          Pv_MensaError OUT VARCHAR2,
                          Prf_Result OUT Crf_Result);
  
  /**
   * Documentación para P_INFO_CONTACTOS
   * Procedimiento que permite realizar consultas de contactos por cliente y punto, hacia data de MD
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param PCL_JSONFILTROS IN CLOB Recibe en formato Json, los filtros y columnas a mostrar de la consulta
   * @param Pv_MensaError   OUT VARCHAR2 Muestra si hubo algún error en el proceso
   * @param Prf_Result      OUT Crf_Result Devuelve un cursor con toda la información consultada.
   */                           
  PROCEDURE P_INFO_CONTACTOS(PCL_JSONFILTROS IN CLOB,
                              Pv_MensaError OUT VARCHAR2,
                              Prf_Result OUT Crf_Result);
  
  /**
   * Documentación para F_GET_JURISDICCION
   * Función que obtiene todas las jurisdicciones de un cliente en especifico
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param Pv_id_persona_rol IN NUMBER Recibe el ID PERSONA ROL DEL CLIENTE MD
   * @return VARCHAR2 Retorna todas las jurisdicciones del cliente separados por coma ","
   */
  FUNCTION F_GET_JURISDICCION(Fv_id_persona_rol NUMBER) 
  RETURN VARCHAR2;
  
  /**
   * Documentación para F_GET_ELEMENTO
   * Función que obtiene ELEMENTO, MARCA, MODELO, PUERTO, IP, de los diferentes Elementos disponibles
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param Pn_id_servicio IN NUMBER Recibe el Id del Servicio del cliente
   * @param Pv_campo IN VARCHAR2 Recibe el tipo de información que requiero : ELEMENTO, PUERTO, MARCA, MODELO, IP, SERIAL
   * @param Pv_elemento IN VARCHAR2 Recibe el elemento a consultar: OLT, ONT, CAJA, SPLITTER
   * @return VARCHAR2 Retorna el valor del elemento seleccionado en los parámetros de entrada
   */
  FUNCTION F_GET_ELEMENTO(Fn_id_servicio NUMBER, 
                           Fv_campo VARCHAR2, 
                           Fv_elemento VARCHAR2)
  RETURN VARCHAR2;
  
  /**
   * Documentación para F_GET_IPS_FIJAS
   * Función que obtiene el listado de IPs FIjas por servicio
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param Pn_id_servicio IN NUMBER Recibe el Id del Servicio del cliente
   * @return VARCHAR2 Retorna las ips fijas separadas por coma ","
   */
  FUNCTION F_GET_IPS_FIJAS(Fn_id_servicio NUMBER)
  RETURN VARCHAR2;
  
  /**
   * Documentación para F_GET_IPS_ADICIONALES
   * Función que obtiene el listado de IPs Adicionales por punto
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param Pn_id_punto IN NUMBER Recibe el Id del punto del cliente
   * @return VARCHAR2 Retorna las ips adicionales separadas por coma ","
   */
  FUNCTION F_GET_IPS_ADICIONALES(Fn_id_punto NUMBER)
  RETURN VARCHAR2;
  
  /**
   * Documentación para F_GET_SALDO_TOTAL
   * Función que obtiene el saldo total de un cliente 
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 19/10/2019
   * 
   * @param Pv_identificacion IN VARCHAR2 Recibe la identificación del Cliente
   * @return VARCHAR2 Retorna el saldo total del cliente
   */
  FUNCTION F_GET_SALDO_TOTAL(Fv_identificacion VARCHAR2)
  RETURN NUMBER;
  
  /**
   * Documentación para F_GET_PLAN
   * Función que obtiene el plan asociado al login
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 28/01/2020
   * 
   * @param Fv_login IN VARCHAR2 Recibe el login del punto
   * @param Fv_estado_servicio IN VARCHAR2 Recibe estado del servicio
   * @return VARCHAR2 Retorna el plan del cliente
   */
  FUNCTION F_GET_PLAN(Fv_login VARCHAR2,
                      Fv_estado_servicio VARCHAR2)
  RETURN VARCHAR2;
  
  /**
   * Documentación para F_GET_PRODUCTOS
   * Función que obtiene los productos adicionales de un punto
   * 
   * @author José Bedón Sánchez <jobedon@telconet.ec>
   * @version 1.0 28/01/2020
   * 
   * @param Fn_id_punto IN NUMBER Recibe id del punto del cliente
   * @param Fv_estado_servicio IN VARCHAR2 Recibe estado del servicio
   * @return CLOB Retorna una cadena separado por comas con los servicios adicionales
   */
  FUNCTION F_GET_PRODUCTOS(Fn_id_punto NUMBER,
                           Fv_estado_servicio VARCHAR2)
  RETURN CLOB;

END EXKG_MD_CONSULTS;
/
CREATE OR REPLACE PACKAGE BODY DB_EXTERNO.EXKG_MD_CONSULTS AS

  PROCEDURE P_OBTIENE_PROMOCIONES(Pv_FechaInicio   IN  VARCHAR2,
                                  Pv_FechaFin      IN  VARCHAR2,
                                  Pv_TipoPromocion IN  VARCHAR2,
                                  Pv_TipoProceso   IN  VARCHAR2,
                                  Pv_LoginPunto    IN  VARCHAR2,
                                  Pr_Promociones   OUT SYS_REFCURSOR,
                                  Pv_Mensaje       OUT VARCHAR2) IS

    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Valor1          VARCHAR2,
                        Cv_EstadoCab       VARCHAR2,
                        Cv_EstadoDet       VARCHAR2)
    IS
      SELECT APDET.*
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
             DB_GENERAL.ADMI_PARAMETRO_DET APDET
      WHERE APCAB.ID_PARAMETRO     = APDET.PARAMETRO_ID
        AND APCAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APDET.VALOR1           = Cv_Valor1
        AND APCAB.ESTADO           = Cv_EstadoCab
        AND APDET.ESTADO           = Cv_EstadoDet;

    --Variables Locales
    Ld_FechaInicio     DATE;
    Ld_FechaFin        DATE;
    Lv_Error           VARCHAR2(4000);
    Lv_FechaActual     VARCHAR2(10) := TO_CHAR(SYSDATE,'RRRR-MM-DD');
    Ld_FechaActual     DATE         := TO_DATE(Lv_FechaActual,'RRRR-MM-DD');
    Le_MyException     EXCEPTION;
    Lc_Parametros      C_Parametros%ROWTYPE;
    Ln_DiasPermitidos  NUMBER := 4; --días por defecto

  BEGIN

    IF C_Parametros%ISOPEN THEN
      CLOSE C_Parametros;
    END IF;

    IF Pr_Promociones%ISOPEN THEN
      CLOSE Pr_Promociones;
    END IF;

    --Cursor que obtiene los días permitidos de consulta para los procesos de promoción.
    OPEN C_Parametros('DIAS_CONSULTA_PROCESOS_PROMOCION','DIAS_PERMITIDOS','Activo','Activo');
      FETCH C_Parametros INTO Lc_Parametros;
    CLOSE C_Parametros;

    IF Lc_Parametros.VALOR2 IS NOT NULL THEN
      Ln_DiasPermitidos := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_Parametros.VALOR2,'^\d+')),Ln_DiasPermitidos);
    END IF;

    IF Pv_FechaInicio IS NULL OR Pv_FechaFin IS NULL OR Pv_TipoPromocion IS NULL OR Pv_TipoProceso IS NULL THEN
      Lv_Error := 'Todos los parámetros de entrada deben ser obligatorios '
          ||'(Pv_FechaInicio,Pv_FechaFin,Pv_TipoPromocion,Pv_TipoProceso)';
      RAISE Le_MyException;
    END IF;

    BEGIN
      SELECT TO_DATE(Pv_FechaInicio,'RRRR-MM-DD') INTO Ld_FechaInicio FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        Lv_Error := 'Error en el formato de Fecha Inicio. Formato esperado (YYYY-MM-DD)';
        RAISE Le_MyException;
    END;

    BEGIN
      SELECT TO_DATE(Pv_FechaFin,'RRRR-MM-DD') INTO Ld_FechaFin FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        Lv_Error := 'Error en el formato de Fecha Fin. Formato esperado (YYYY-MM-DD)';
        RAISE Le_MyException;
    END;

    IF Ld_FechaInicio > Ld_FechaFin THEN
      Lv_Error := 'La Fecha Inicio no puede ser mayor a la Fecha Fin.';
      RAISE Le_MyException;
    END IF;

    IF Ld_FechaFin <> Ld_FechaActual THEN
      Lv_Error := 'La Fecha Fin debe ser igual a la Fecha Actual: '||
                  'Fecha Fin: '||Pv_FechaFin||', Fecha Actual: '||Lv_FechaActual;
      RAISE Le_MyException;
    END IF;

    IF Ld_FechaInicio < (Ld_FechaActual - Ln_DiasPermitidos)THEN
      Lv_Error := 'La Fecha Inicio debe ser como máximo '||Ln_DiasPermitidos||' día(s) antes de la Fecha Actual.';
      RAISE Le_MyException;
    END IF;

    OPEN Pr_Promociones FOR
      SELECT IPP.ID_PROCESO_PROMO,
             TO_CHAR(IPP.FE_INI_MAPEO,'RRRR-MM-DD') AS FE_INI_MAPEO,
             TO_CHAR(IPP.FE_FIN_MAPEO,'RRRR-MM-DD') AS FE_FIN_MAPEO,
             IPP.LOGIN_PUNTO,
             IPP.ESTADO_SERVICIO,
             IPP.SERIE,
             IPP.MAC,
             IPP.NOMBRE_OLT,
             IPP.PUERTO,
             IPP.SERVICE_PORT,
             IPP.ONT_ID,
             IPP.TRAFFIC_PROMO,
             IPP.GEMPORT_PROMO,
             IPP.LINE_PROFILE_PROMO,
             IPP.NUM_IPS_FIJAS,
             CAPACIDAD_UP_PROMO,
             IPP.CAPACIDAD_DOWN_PROMO,
             IPP.TIPO_NEGOCIO,
             IPP.TRAFFIC_ORIGIN,
             IPP.GEMPORT_ORIGIN,
             IPP.LINE_PROFILE_ORIGIN,
             IPP.VLAN_ORIGIN,
             IPP.SERVICE_PROFILE,
             CAPACIDAD_UP_ORIGIN,
             IPP.CAPACIDAD_DOWN_ORIGIN,
             IPP.TIPO_PROCESO
          FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
      WHERE IPP.ESTADO             = 'Pendiente'
        AND UPPER(TIPO_PROMO)      =  UPPER(Pv_TipoPromocion)
        AND UPPER(TIPO_PROCESO)    =  UPPER(Pv_TipoProceso)
        AND UPPER(IPP.LOGIN_PUNTO) =  NVL(UPPER(Pv_LoginPunto),UPPER(IPP.LOGIN_PUNTO))
        AND TO_CHAR(IPP.FE_INI_MAPEO,'RRRR-MM-DD') >= Pv_FechaInicio
        AND TO_CHAR(IPP.FE_INI_MAPEO,'RRRR-MM-DD') <= Pv_FechaFin
      ORDER BY UPPER(TRIM(IPP.NOMBRE_OLT)) ASC;

  EXCEPTION
    WHEN Le_MyException THEN
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('EXKG_MD_CONSULTS',
                                           'P_OBTIENE_PROMOCIONES',
                                            Lv_Error,
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_Mensaje := 'Error al devolver los datos';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('EXKG_MD_CONSULTS',
                                           'P_OBTIENE_PROMOCIONES',
                                            SQLCODE||' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_OBTIENE_PROMOCIONES;

  PROCEDURE P_CONSULTA_DATA(PCL_JSONFILTROS IN CLOB,
                             Pv_MensaError OUT VARCHAR2,
                             Prf_Result OUT Crf_Result) IS
                            
    Lv_tipo_consulta VARCHAR2(100);
    Lv_MensaError    VARCHAR2(500);
    Lv_IpCreacion    VARCHAR2(30) := '127.0.0.1';
    
    Lrf_Result Crf_Result;
                             
  BEGIN
    APEX_JSON.PARSE(PCL_JSONFILTROS);
    
    Lv_tipo_consulta := APEX_JSON.get_varchar2(p_path => 'tipo_consulta');
    
    CASE Lv_tipo_consulta
      WHEN 'INFO_BASICA' THEN
        DB_EXTERNO.EXKG_MD_CONSULTS.P_INFO_BASICA(PCL_JSONFILTROS => PCL_JSONFILTROS,
                                        Pv_MensaError => Lv_MensaError,
                                        Prf_Result => Lrf_Result);
      WHEN 'INFO_PUNTO' THEN
        DB_EXTERNO.EXKG_MD_CONSULTS.P_INFO_PUNTO(PCL_JSONFILTROS => PCL_JSONFILTROS,
                                        Pv_MensaError => Lv_MensaError,
                                        Prf_Result => Lrf_Result);
      WHEN 'INFO_CONTACTOS' THEN
        DB_EXTERNO.EXKG_MD_CONSULTS.P_INFO_CONTACTOS(PCL_JSONFILTROS => PCL_JSONFILTROS,
                                        Pv_MensaError => Lv_MensaError,
                                        Prf_Result => Lrf_Result);
      WHEN 'INFO_CASOS' THEN
        DB_EXTERNO.EXKG_MD_CONSULTS.P_INFO_CASOS(PCL_JSONFILTROS => PCL_JSONFILTROS,
                                        Pv_MensaError => Lv_MensaError,
                                        Prf_Result => Lrf_Result);
      ELSE
        Lv_MensaError := 'Campo tipo_consulta incorrecto, los correctos son: INFO_BASICA, INFO_PUNTO, INFO_CONTACTOS, INFO_CASOS';
    END CASE;
    
    Prf_Result := Lrf_Result;
    Pv_MensaError := Lv_MensaError;
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensaError := 'ERROR PROCEDURE DB_EXTERNO.EXKG_MD_CONSULTS.P_CONSULTA_DATA : ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_CONSULTA_DATA',
        SQLERRM,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
      
  END P_CONSULTA_DATA;
  
  
  PROCEDURE P_INFO_BASICA(PCL_JSONFILTROS IN CLOB,
                           Pv_MensaError OUT VARCHAR2,
                           Prf_Result OUT Crf_Result) IS
  
    Lv_query          CLOB;
    Lv_query_columnas CLOB;
    Lv_query_filtros  CLOB;
    Lv_columna        varchar2(50);
    
    Lv_identificacion      DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE;
    Lv_forma_pago          DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE;
    Lv_tipo_identificacion DB_COMERCIAL.INFO_PERSONA.TIPO_IDENTIFICACION%TYPE;
    Lv_jurisdiccion        DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE;
    
    Ln_count       PLS_INTEGER := 0;
    Le_empty_field EXCEPTION;
    Le_custom      EXCEPTION;
    lv_error       VARCHAR2(500);
    Lv_IpCreacion  VARCHAR2(30) := '127.0.0.1';
    
    Lb_saldo_detalle boolean := false;
    
    Lv_query_join_from_saldo  varchar2(500);
    Lv_query_join_where_saldo varchar2(500);
      
  BEGIN
  
    APEX_JSON.PARSE(PCL_JSONFILTROS);
    
    Lv_identificacion      := APEX_JSON.get_varchar2(p_path => 'filtros.identificacion');
    Lv_tipo_identificacion := APEX_JSON.get_varchar2(p_path => 'filtros.tipo_identificacion');
    Lv_forma_pago          := APEX_JSON.get_varchar2(p_path => 'filtros.forma_pago');
    Lv_jurisdiccion        := APEX_JSON.get_varchar2(p_path => 'filtros.jurisdiccion');
        
    IF Lv_jurisdiccion IS NULL AND Lv_identificacion IS NULL THEN
      lv_error := 'jurisdiccion';
      RAISE Le_empty_field;
    END IF;
    
    Ln_count := APEX_JSON.GET_COUNT(p_path => 'columnas');
       
    
    FOR i IN 1 .. Ln_count LOOP
      Lv_columna := APEX_JSON.get_varchar2(p_path => 'columnas[%d]', p0 => i);
      CASE UPPER(Lv_columna)
        WHEN 'IDENTIFICACION' THEN
          Lv_query_columnas := Lv_query_columnas || 'A.IDENTIFICACION_CLIENTE,';
        WHEN 'TIPO_IDENTIFICACION' THEN
          Lv_query_columnas := Lv_query_columnas || 'A.TIPO_IDENTIFICACION,';
        WHEN 'FORMA_PAGO' THEN
          Lv_query_columnas := Lv_query_columnas || 'G.DESCRIPCION_FORMA_PAGO AS FORMA_PAGO,';
        WHEN 'JURISDICCION' THEN
          Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_JURISDICCION(B.ID_PERSONA_ROL) AS JURISDICCION,';
        WHEN 'SALDO_TOTAL' THEN
          Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_SALDO_TOTAL(A.IDENTIFICACION_CLIENTE) AS SALDO_TOTAL,';
        WHEN 'SALDO_DETALLE' THEN
          IF Lv_identificacion IS NULL THEN
            lv_error := 'Debe ingresar una identificación para consultar detalle de saldo';
            RAISE Le_custom;
          END IF;
          Lv_query_columnas := Lv_query_columnas || 'X.LOGIN, Y.SALDO,';
          Lb_saldo_detalle := true;
        ELSE
          Lv_query_columnas := Lv_query_columnas || ' ';
      END CASE;
    END LOOP;
    
    
    -- detalle de saldo
    IF Lb_saldo_detalle THEN
      Lv_query_join_from_saldo  := Lv_query_join_from_saldo || ' DB_COMERCIAL.INFO_PUNTO X, DB_COMERCIAL.INFO_PUNTO_SALDO Y, ';
      Lv_query_join_where_saldo := ' X.PERSONA_EMPRESA_ROL_ID = B.ID_PERSONA_ROL AND X.ESTADO <> ''Inactivo'' AND X.ID_PUNTO = Y.PUNTO_ID AND ';
    END IF;
    
    -- validacion de filtros
    IF Lv_identificacion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND A.IDENTIFICACION_CLIENTE = ''' || Lv_identificacion || '''';
    END IF;
    
    IF Lv_tipo_identificacion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND A.TIPO_IDENTIFICACION = ''' || Lv_tipo_identificacion || '''';
    END IF;
    
    IF Lv_forma_pago IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND G.DESCRIPCION_FORMA_PAGO = ''' || Lv_forma_pago || '''';
    END IF;
    
    IF Lv_jurisdiccion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND EXISTS (SELECT
                                              1
                                           FROM 
                                              DB_COMERCIAL.INFO_PUNTO H,
                                              DB_INFRAESTRUCTURA.ADMI_JURISDICCION I
                                           WHERE
                                              H.PERSONA_EMPRESA_ROL_ID = B.ID_PERSONA_ROL AND
                                              H.PUNTO_COBERTURA_ID = I.ID_JURISDICCION AND
                                              I.NOMBRE_JURISDICCION = ''' || Lv_jurisdiccion || ''')';
    END IF;
    
    Lv_query := '
      SELECT 
        ' || Lv_query_columnas || '
        A.NOMBRES,
        A.APELLIDOS,
        A.RAZON_SOCIAL,
        A.REPRESENTANTE_LEGAL
      FROM 
        DB_COMERCIAL.INFO_PERSONA A, 
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL B,
        ' || Lv_query_join_from_saldo || '
        DB_COMERCIAL.INFO_EMPRESA_ROL C,
        DB_GENERAL.ADMI_ROL D,
        DB_GENERAL.ADMI_TIPO_ROL E,
        DB_COMERCIAL.INFO_CONTRATO F,
        DB_GENERAL.ADMI_FORMA_PAGO G
      WHERE 
        A.ID_PERSONA = B.PERSONA_ID AND 
        C.ID_EMPRESA_ROL = B.EMPRESA_ROL_ID AND
        ' || Lv_query_join_where_saldo || '
        C.ROL_ID = D.ID_ROL AND
        D.TIPO_ROL_ID = E.ID_TIPO_ROL AND
        B.ID_PERSONA_ROL = F.PERSONA_EMPRESA_ROL_ID AND
        F.FORMA_PAGO_ID = G.ID_FORMA_PAGO AND
        A.ESTADO = ''Activo'' AND 
        B.ESTADO = ''Activo'' AND 
        C.ESTADO = ''Activo'' AND 
        D.ESTADO = ''Activo'' AND 
        E.ESTADO = ''Activo'' AND
        F.ESTADO = ''Activo'' AND
        G.ESTADO = ''Activo'' AND
        C.EMPRESA_COD = 18 AND
        E.DESCRIPCION_TIPO_ROL = ''Cliente'' 
        ' || Lv_query_filtros || '
    ';
                  
    OPEN Prf_Result FOR Lv_query;
    
  EXCEPTION
    WHEN Le_custom THEN
      Pv_MensaError := lv_error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_BASICA',
        Pv_MensaError,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
    WHEN Le_empty_field THEN
      Pv_MensaError := 'Campo ' || lv_error || ' es obligatorio';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_BASICA',
        Pv_MensaError,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
    WHEN OTHERS THEN
      Pv_MensaError := 'ERROR PROCEDURE DB_EXTERNO.EXKG_MD_CONSULTS.P_INFO_BASICA : ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_BASICA',
        SQLERRM,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
    
  END P_INFO_BASICA;
  
  FUNCTION F_GET_JURISDICCION(Fv_id_persona_rol NUMBER) 
  RETURN VARCHAR2 IS
    Lv_jurisdicciones VARCHAR2(2000);
    
    CURSOR C_JURISDICCION IS
    SELECT
      DISTINCT B.NOMBRE_JURISDICCION AS JURISDICCION
    FROM 
      DB_COMERCIAL.INFO_PUNTO A,
      DB_INFRAESTRUCTURA.ADMI_JURISDICCION B
    WHERE
      A.PERSONA_EMPRESA_ROL_ID = Fv_id_persona_rol AND
      A.PUNTO_COBERTURA_ID = B.ID_JURISDICCION;
    
  BEGIN

    FOR i IN C_JURISDICCION LOOP
      Lv_jurisdicciones := Lv_jurisdicciones || i.JURISDICCION || ',';
    END LOOP;
  
    RETURN Lv_jurisdicciones;
  END F_GET_JURISDICCION;
  
  PROCEDURE P_INFO_PUNTO(PCL_JSONFILTROS IN CLOB,
                           Pv_MensaError OUT VARCHAR2,
                           Prf_Result OUT Crf_Result) IS
    
    Lv_query          CLOB;
    Lv_query_columnas CLOB;
    Lv_query_filtros  CLOB;
    Lv_columna        varchar2(50); 
    Lv_query_saldos   varchar2(100);
    
    Lv_identificacion      DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE;
    Lv_tipo_identificacion DB_COMERCIAL.INFO_PERSONA.TIPO_IDENTIFICACION%TYPE;
    Lv_login               DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Lv_saldo_min           number;
    Lv_saldo_max           number;
    Lv_jurisdiccion        DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE;
    Lv_estado_servicio     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE;
    Lv_gem_port            DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_vlan                DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_traffic_table       DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_line_profile        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_service_profile     DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_service_port        DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    Lv_indice_cliente      DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT.VALOR%TYPE;
    
    Le_empty_field EXCEPTION;
    Le_max_min     EXCEPTION;
    lv_error       VARCHAR2(50);
    Lv_IpCreacion  VARCHAR2(30) := '127.0.0.1';
    
    Ln_count PLS_INTEGER := 0;
    
    Lv_olt        DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE;
    Lv_ont        DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE;
    Lv_ont_serial DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE;
    Lv_olt_puerto DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE;
    Lv_olt_modelo DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE;
    
    Lv_sector       DB_GENERAL.ADMI_SECTOR.NOMBRE_SECTOR%TYPE;
    Lv_parroquia    DB_GENERAL.ADMI_PARROQUIA.NOMBRE_PARROQUIA%TYPE;
    Lv_canton       DB_GENERAL.ADMI_CANTON.NOMBRE_CANTON%TYPE; 
    Lv_provincia    DB_GENERAL.ADMI_PROVINCIA.NOMBRE_PROVINCIA%TYPE;
    Lv_region       DB_GENERAL.ADMI_REGION.NOMBRE_REGION%TYPE;
    Lv_tipo_negocio DB_COMERCIAL.ADMI_TIPO_NEGOCIO.NOMBRE_TIPO_NEGOCIO%TYPE;
    
    Lb_sector       boolean := false;
    Lb_parroquia    boolean := false;
    Lb_canton       boolean := false;
    Lb_provincia    boolean := false;
    Lb_region       boolean := false;
    Lb_tipo_negocio boolean := false;
    Lb_productos    boolean := false;
    
    Lv_query_join_from_sector  varchar2(500);
    Lv_query_join_where_sector varchar2(500);
    
    Lv_query_join_from_tiponeg  varchar2(500);
    Lv_query_join_where_tiponeg varchar2(500);
    
    Lv_query_join_from_prods varchar2(500);
    Lv_query_join_where_prods varchar2(500) := '';
                           
  BEGIN
    
    APEX_JSON.PARSE(PCL_JSONFILTROS);
    
    Lv_jurisdiccion        := APEX_JSON.get_varchar2(p_path => 'filtros.jurisdiccion');
    Lv_estado_servicio     := APEX_JSON.get_varchar2(p_path => 'filtros.estado_servicio');
    Lv_identificacion      := APEX_JSON.get_varchar2(p_path => 'filtros.identificacion');
    Lv_tipo_identificacion := APEX_JSON.get_varchar2(p_path => 'filtros.tipo_identificacion');
    Lv_login               := APEX_JSON.get_varchar2(p_path => 'filtros.login');
    
    Lv_saldo_max := APEX_JSON.get_number(p_path => 'filtros.saldo_max');
    Lv_saldo_min := APEX_JSON.get_number(p_path => 'filtros.saldo_min');
    
    Lv_gem_port        := APEX_JSON.get_varchar2(p_path => 'filtros.gem_port');
    Lv_vlan            := APEX_JSON.get_varchar2(p_path => 'filtros.vlan');
    Lv_traffic_table   := APEX_JSON.get_varchar2(p_path => 'filtros.traffic_table');
    Lv_line_profile    := APEX_JSON.get_varchar2(p_path => 'filtros.line_profile');
    Lv_service_profile := APEX_JSON.get_varchar2(p_path => 'filtros.service_profile');
    Lv_service_port    := APEX_JSON.get_varchar2(p_path => 'filtros.service_port');
    Lv_indice_cliente  := APEX_JSON.get_varchar2(p_path => 'filtros.indice_cliente');
    
    Lv_olt        := APEX_JSON.get_varchar2(p_path => 'filtros.olt');
    Lv_ont        := APEX_JSON.get_varchar2(p_path => 'filtros.ont');
    Lv_ont_serial := APEX_JSON.get_varchar2(p_path => 'filtros.ont_serial');
    Lv_olt_puerto := APEX_JSON.get_varchar2(p_path => 'filtros.olt_puerto');
    Lv_olt_modelo := APEX_JSON.get_varchar2(p_path => 'filtros.olt_modelo');
    
    Lv_sector    := APEX_JSON.get_varchar2(p_path => 'filtros.sector');
    Lv_parroquia := APEX_JSON.get_varchar2(p_path => 'filtros.parroquia');
    Lv_canton    := APEX_JSON.get_varchar2(p_path => 'filtros.canton');
    Lv_provincia := APEX_JSON.get_varchar2(p_path => 'filtros.provincia');
    Lv_region    := APEX_JSON.get_varchar2(p_path => 'filtros.region');
    
    Lv_tipo_negocio := APEX_JSON.get_varchar2(p_path => 'filtros.tipo_negocio');
        
    IF Lv_jurisdiccion IS NULL AND Lv_identificacion IS NULL THEN
      lv_error := 'jurisdiccion';
      RAISE Le_empty_field;
    END IF;
    
    IF Lv_estado_servicio IS NULL AND Lv_identificacion IS NULL THEN
      lv_error := 'estado_servicio';
      RAISE Le_empty_field;
    END IF;
    
    IF Lv_saldo_max IS NOT NULL AND Lv_saldo_min IS NULL THEN
      Lv_error := 'Debe especificar un valor mínimo, ya que el máximo fue dado';
      RAISE Le_max_min;
    END IF;
    
    IF Lv_saldo_min IS NOT NULL AND Lv_saldo_max IS NULL THEN
      Lv_error := 'Debe especificar un valor máximo, ya que el mínimo fue dado';
      RAISE Le_max_min;
    END IF;
    
    Ln_count := APEX_JSON.GET_COUNT(p_path => 'columnas');
    
    IF Lv_saldo_max IS NOT NULL OR Lv_saldo_min IS NOT NULL THEN
      Lv_query_saldos := Lv_query_saldos || 'AND (P.SALDO BETWEEN ' || Lv_saldo_min || ' AND ' || Lv_saldo_max || ')';
    END IF;
    
    FOR i IN 1 .. Ln_count LOOP
    
      Lv_columna := UPPER(APEX_JSON.get_varchar2(p_path => 'columnas[%d]', p0 => i));
            
      IF Lv_columna = 'IDENTIFICACION' THEN
        Lv_query_columnas := Lv_query_columnas || 'A.IDENTIFICACION_CLIENTE, ';
      ELSIF Lv_columna = 'TIPO_IDENTIFICACION' THEN
        Lv_query_columnas := Lv_query_columnas || 'A.TIPO_IDENTIFICACION,';
      ELSIF Lv_columna = 'LOGIN' THEN
        Lv_query_columnas := Lv_query_columnas || 'F.LOGIN, ';
      ELSIF Lv_columna = 'SALDO' THEN
        Lv_query_columnas := Lv_query_columnas || '
        (SELECT 
            P.SALDO
          FROM 
            DB_COMERCIAL.INFO_PUNTO_SALDO P 
          WHERE 
            P.PUNTO_ID = F.ID_PUNTO
          ' || Lv_query_saldos || '
        ) AS SALDO, 
        ';
      ELSIF Lv_columna = 'JURISDICCION' THEN
        Lv_query_columnas := Lv_query_columnas || 'G.NOMBRE_JURISDICCION,';
      ELSIF Lv_columna = 'SECTOR' THEN
        Lv_query_columnas := Lv_query_columnas || 'H.NOMBRE_SECTOR AS SECTOR, ';
        Lb_sector         := true;
      ELSIF Lv_columna = 'PARROQUIA' THEN
        Lv_query_columnas := Lv_query_columnas || 'I.NOMBRE_PARROQUIA AS PARROQUIA,';
        Lb_parroquia      := true;
      ELSIF Lv_columna = 'CANTON' THEN
        Lv_query_columnas := Lv_query_columnas || 'J.NOMBRE_CANTON AS CANTON, ';
        Lb_canton         := true;
      ELSIF Lv_columna = 'PROVINCIA' THEN
        Lv_query_columnas := Lv_query_columnas || 'K.NOMBRE_PROVINCIA AS PROVINCIA, ';
        Lb_provincia      := true;
      ELSIF Lv_columna = 'REGION' THEN
        Lv_query_columnas := Lv_query_columnas || 'L.NOMBRE_REGION AS REGION, ';
        Lb_region         := true;
      ELSIF Lv_columna = 'TIPO_NEGOCIO' THEN
        Lv_query_columnas := Lv_query_columnas || 'N.NOMBRE_TIPO_NEGOCIO AS TIPO_NEGOCIO, ';
        Lb_tipo_negocio   := true;
      ELSIF Lv_columna = 'ESTADO_SERVICIO' THEN
        Lv_query_columnas := Lv_query_columnas || 'M.ESTADO AS ESTADO_SERVICIO,';
      ELSIF Lv_columna = 'FECHA_INSTALACION' THEN
        Lv_query_columnas := Lv_query_columnas || '
        (SELECT
            MIN(SH3.FE_CREACION)
          FROM
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SH3
          WHERE 
            SH3.SERVICIO_ID = M.ID_SERVICIO AND
            SH3.ESTADO = ''Activo''
        ) FECHA_INSTALACION,
        ';
      ELSIF Lv_columna = 'FECHA_CORTE' THEN
        Lv_query_columnas := Lv_query_columnas || '
        (SELECT 
            MAX(SH1.FE_CREACION)
          FROM 
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SH1
          WHERE 
            SH1.ESTADO = ''In-Corte'' AND
            SH1.SERVICIO_ID = M.ID_SERVICIO
          ) FECHA_ULTIMO_CORTE,
        ';
      ELSIF Lv_columna = 'FECHA_REACTIVACION' THEN
        Lv_query_columnas := Lv_query_columnas || '
        (SELECT
            MAX(SH2.FE_CREACION)
          FROM
            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL SH2
          WHERE 
            SH2.SERVICIO_ID = M.ID_SERVICIO AND
            (DBMS_LOB.COMPARE(UPPER(SH2.OBSERVACION), ''SE REACTIVO EL SERVICIO'') = 0 OR 
             DBMS_LOB.COMPARE(UPPER(SH2.OBSERVACION), ''EL SERVICIO SE REACTIVO EXITOSAMENTE'') = 0)
        ) FECHA_ULTIMO_REACTIVACION,
        ';
      
      ELSIF Lv_columna = 'PRODUCTOS' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_PRODUCTOS(F.ID_PUNTO, ''' || Lv_estado_servicio || ''') AS PRODUCTOS,';
        Lb_productos := true;
      ELSIF Lv_columna = 'PLAN' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_PLAN(F.LOGIN, ''' || Lv_estado_servicio || ''') AS PLAN,';
      ELSIF Lv_columna = 'OLT' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''ELEMENTO'',''OLT'') AS OLT,';
      ELSIF Lv_columna = 'OLT_IP' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''IP'',''OLT'') AS OLT_IP,';
      ELSIF Lv_columna = 'OLT_PUERTO' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''PUERTO'',''OLT'') AS OLT_PUERTO,';
      ELSIF Lv_columna = 'OLT_MODELO' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MODELO'',''OLT'') AS OLT_MODELO,';
      ELSIF Lv_columna = 'OLT_MARCA' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MARCA'',''OLT'') AS OLT_MARCA,';
      ELSIF Lv_columna = 'ONT' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''ELEMENTO'',''ONT'') AS ONT,';
      ELSIF Lv_columna = 'ONT_MODELO' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MODELO'',''ONT'') AS ONT_MODELO,';
      ELSIF Lv_columna = 'ONT_MARCA' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MARCA'',''ONT'') AS ONT_MARCA,';
      ELSIF Lv_columna = 'ONT_SERIAL' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''SERIE'',''ONT'') AS ONT_SERIAL,';
      ELSIF Lv_columna = 'CAJA' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''ELEMENTO'',''CAJA'') AS CAJA,';
      ELSIF Lv_columna = 'CAJA_MODELO' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MODELO'',''CAJA'') AS CAJA_MODELO,';
      ELSIF Lv_columna = 'CAJA_MARCA' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MARCA'',''CAJA'') AS CAJA_MARCA,';
      ELSIF Lv_columna = 'SPLITTER' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''ELEMENTO'',''SPLITTER'') AS SPLITTER,';
      ELSIF Lv_columna = 'SPLITTER_PUERTO' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''PUERTO'',''SPLITTER'') AS SPLITTER_PUERTO,';
      ELSIF Lv_columna = 'SPLITTER_MODELO' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MODELO'',''SPLITTER'') AS SPLITTER_MODELO,';
      ELSIF Lv_columna = 'SPLITTER_MARCA' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MARCA'',''SPLITTER'') AS SPLITTER_MARCA,';
      ELSIF Lv_columna = 'GEM_PORT' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''GEM-PORT'') AS GEM_PORT,';
      ELSIF Lv_columna = 'VLAN' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''VLAN'') AS VLAN,';
      ELSIF Lv_columna = 'TRAFFIC_TABLE' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''TRAFFIC-TABLE'') AS TRAFFIC_TABLE,';
      ELSIF Lv_columna = 'LINE_PROFILE' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''LINE-PROFILE-NAME'') AS LINE_PROFILE,';
      ELSIF Lv_columna = 'SERVICE_PROFILE' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''SERVICE-PROFILE'') AS SERVICE_PROFILE,';
      ELSIF Lv_columna = 'SERVICE_PORT' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''SPID'') AS SERVICE_PORT,';
      ELSIF Lv_columna = 'INDICE_CLIENTE' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''INDICE CLIENTE'') AS INDICE_CLIENTE,';
      ELSIF Lv_columna = 'IPS_FIJAS' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_IPS_FIJAS(M.ID_SERVICIO) AS IPS_FIJAS,';
      ELSIF Lv_columna = 'IPS_ADICIONALES' THEN
        Lv_query_columnas := Lv_query_columnas || 'DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_IPS_ADICIONALES(F.ID_PUNTO) AS IPS_ADICIONALES,';
      ELSE
        Lv_query_columnas := Lv_query_columnas || ' ';
      END IF;
      
    END LOOP;
        
    -- validacion de filtros
    IF Lv_identificacion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND A.IDENTIFICACION_CLIENTE = ''' || Lv_identificacion || '''';
    END IF;
    
    IF Lv_tipo_identificacion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND A.TIPO_IDENTIFICACION = ''' || Lv_tipo_identificacion || '''';
    END IF;
    
    IF Lv_login IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND F.LOGIN = ''' || Lv_login || ''' ';
    END IF;
    
    IF Lv_estado_servicio IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND M.ESTADO = ''' || Lv_estado_servicio || ''' ';
    END IF;
    
    IF Lv_jurisdiccion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND G.NOMBRE_JURISDICCION = ''' || Lv_jurisdiccion || ''' ';
    END IF;
    
    IF Lv_sector IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND H.NOMBRE_SECTOR = ''' || Lv_sector || ''' ';
      Lb_sector := true;
    END IF;
    
    IF Lv_parroquia IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND I.NOMBRE_PARROQUIA = ''' || Lv_parroquia || ''' ';
      Lb_parroquia := true;
    END IF;
    
    IF Lv_canton IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND J.NOMBRE_CANTON = ''' || Lv_canton || ''' ';
      Lb_canton := true;
    END IF;
    
    IF Lv_provincia IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND K.NOMBRE_PROVINCIA = ''' || Lv_provincia || ''' ';
      Lb_provincia := true;
    END IF;
    
    IF Lv_region IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND L.NOMBRE_REGION = ''' || Lv_region || ''' ';
      Lb_region := true;
    END IF;
    
    IF Lv_tipo_negocio IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND N.NOMBRE_TIPO_NEGOCIO = ''' || Lv_tipo_negocio || ''' ';
      Lb_tipo_negocio := true;
    END IF;
    
    IF Lv_olt IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''ELEMENTO'',''OLT'') = ''' || Lv_olt || ''' ';
    END IF;
    
    IF Lv_ont IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''ELEMENTO'',''ONT'') = ''' || Lv_ont || ''' ';
    END IF;
    
    IF Lv_ont_serial IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''SERIE'',''ONT'') = ''' || Lv_ont_serial || ''' ';
    END IF;
    
    IF Lv_olt_puerto IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''PUERTO'',''OLT'') = ''' || Lv_olt_puerto || ''' ';
    END IF;
    
    IF Lv_olt_modelo IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_EXTERNO.EXKG_MD_CONSULTS.F_GET_ELEMENTO(M.ID_SERVICIO,''MODELO'',''OLT'') = ''' || Lv_olt_modelo || ''' ';
    END IF;
    
    IF Lv_gem_port IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''GEM-PORT'') = ''' || Lv_gem_port || ''' ';
    END IF;
    
    IF Lv_vlan IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''VLAN'') = ''' || Lv_vlan || ''' ';
    END IF;
    
    IF Lv_traffic_table IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''TRAFFIC-TABLE'') = ''' || Lv_traffic_table || ''' ';
    END IF;
    
    IF Lv_line_profile IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''LINE-PROFILE-NAME'') = ''' || Lv_line_profile || ''' ';
    END IF;
    
    IF Lv_service_profile IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''SERVICE-PROFILE'') = ''' || Lv_service_profile || ''' ';
    END IF;
    
    IF Lv_service_port IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''SPID'') = ''' || Lv_service_port || ''' ';
    END IF;
    
    IF Lv_indice_cliente IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(M.ID_SERVICIO,''INDICE CLIENTE'') = ''' || Lv_indice_cliente || ''' ';
    END IF;
    
    
    -- Valida segmentacion por sector, parroquia, canton, provincia, region
    IF Lb_sector OR Lb_parroquia OR Lb_canton OR Lb_provincia OR Lb_region THEN
      Lv_query_join_from_sector  := Lv_query_join_from_sector || 'DB_GENERAL.ADMI_SECTOR H,';
      Lv_query_join_where_sector := Lv_query_join_where_sector || ' AND F.SECTOR_ID = H.ID_SECTOR ';
    END IF;
    IF Lb_parroquia OR Lb_canton OR Lb_provincia OR Lb_region THEN
      Lv_query_join_from_sector  := Lv_query_join_from_sector || 'DB_GENERAL.ADMI_PARROQUIA I,';
      Lv_query_join_where_sector := Lv_query_join_where_sector || ' AND H.PARROQUIA_ID = I.ID_PARROQUIA ';
    END IF;
    IF Lb_canton OR Lb_provincia OR Lb_region THEN
      Lv_query_join_from_sector  := Lv_query_join_from_sector || 'DB_GENERAL.ADMI_CANTON J,';
      Lv_query_join_where_sector := Lv_query_join_where_sector || ' AND I.CANTON_ID = J.ID_CANTON ';
    END IF;
    IF Lb_provincia OR Lb_region THEN
      Lv_query_join_from_sector  := Lv_query_join_from_sector || 'DB_GENERAL.ADMI_PROVINCIA K,';
      Lv_query_join_where_sector := Lv_query_join_where_sector || ' AND J.PROVINCIA_ID = K.ID_PROVINCIA ';
    END IF;
    IF Lb_region THEN
      Lv_query_join_from_sector  := Lv_query_join_from_sector || 'DB_GENERAL.ADMI_REGION L,';
      Lv_query_join_where_sector := Lv_query_join_where_sector || ' AND K.REGION_ID = L.ID_REGION ';
    END IF;
    
    -- Valida tipo negocio
    IF Lb_tipo_negocio THEN
      Lv_query_join_from_tiponeg  := Lv_query_join_from_tiponeg || 'DB_COMERCIAL.ADMI_TIPO_NEGOCIO N,';
      Lv_query_join_where_tiponeg := Lv_query_join_where_tiponeg || ' AND N.ID_TIPO_NEGOCIO = F.TIPO_NEGOCIO_ID ';
    END IF;
            
    lv_query := '
      SELECT 
        ' || Lv_query_columnas || '
        F.DIRECCION
      FROM DB_COMERCIAL.INFO_PERSONA A, 
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL B, 
        DB_COMERCIAL.INFO_EMPRESA_ROL C, 
        DB_GENERAL.ADMI_ROL D, 
        DB_GENERAL.ADMI_TIPO_ROL E, 
        DB_COMERCIAL.INFO_PUNTO F, 
        DB_INFRAESTRUCTURA.ADMI_JURISDICCION G,
        ' || Lv_query_join_from_sector || '
        ' || Lv_query_join_from_tiponeg || '
        ' || Lv_query_join_from_prods || '
        DB_COMERCIAL.INFO_SERVICIO M
      WHERE A.ID_PERSONA = B.PERSONA_ID 
       AND C.ID_EMPRESA_ROL = B.EMPRESA_ROL_ID 
       AND C.ROL_ID = D.ID_ROL 
       AND D.TIPO_ROL_ID = E.ID_TIPO_ROL 
       AND F.PERSONA_EMPRESA_ROL_ID = B.ID_PERSONA_ROL 
       AND F.PUNTO_COBERTURA_ID = G.ID_JURISDICCION 
       AND F.ID_PUNTO = M.PUNTO_ID
        ' || Lv_query_join_where_sector || '
        ' || Lv_query_join_where_tiponeg || '
        ' || Lv_query_join_where_prods || '
       AND A.ESTADO = ''Activo'' 
       AND B.ESTADO = ''Activo'' 
       AND C.ESTADO = ''Activo'' 
       AND D.ESTADO = ''Activo'' 
       AND E.ESTADO = ''Activo'' 
       AND F.ESTADO = ''Activo'' 
       AND C.EMPRESA_COD = 18 
       AND E.DESCRIPCION_TIPO_ROL = ''Cliente''
        ' || Lv_query_filtros || '
       AND EXISTS (SELECT
                      1
                    FROM
                      DB_COMERCIAL.INFO_PLAN_DET X,
                      DB_COMERCIAL.ADMI_PRODUCTO Y
                    WHERE
                      X.PLAN_ID = M.PLAN_ID
                      AND X.PRODUCTO_ID = Y.ID_PRODUCTO
                      AND Y.NOMBRE_TECNICO = ''INTERNET''                           
                      )
    ';
    
    
    OPEN Prf_Result FOR Lv_query;
  
  EXCEPTION
    WHEN Le_empty_field THEN
      Pv_MensaError := 'Campo ' || lv_error || ' es obligatorio';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_PUNTO',
        Pv_MensaError,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
    WHEN Le_max_min THEN
      Pv_MensaError := lv_error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_PUNTO',
        Pv_MensaError,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
    WHEN OTHERS THEN
      Pv_MensaError := 'ERROR PROCEDURE DB_EXTERNO.EXKG_MD_CONSULTS.P_INFO_PUNTO : ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_PUNTO',
        SQLERRM,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
  
  END P_INFO_PUNTO;
  
  
  PROCEDURE P_INFO_CONTACTOS(PCL_JSONFILTROS IN CLOB,
                           Pv_MensaError OUT VARCHAR2,
                           Prf_Result OUT Crf_Result) IS
    
    Lv_query          CLOB;
    Lv_query_columnas CLOB;
    Lv_query_filtros  CLOB;
    Lv_columna        varchar2(25); 
    
    Lv_identificacion      varchar2(20);
    Lv_tipo_identificacion varchar2(3);
    Lv_login               varchar2(60);
    Lv_tipo_contacto       varchar2(50);
    
    Le_empty_field EXCEPTION;
    lv_error       VARCHAR2(50);
    Lv_IpCreacion  VARCHAR2(30) := '127.0.0.1';
    
    Ln_count PLS_INTEGER := 0;
    
  BEGIN
  
    APEX_JSON.PARSE(PCL_JSONFILTROS);
       
    Lv_identificacion      := APEX_JSON.get_varchar2(p_path => 'filtros.identificacion');
    Lv_tipo_identificacion := APEX_JSON.get_varchar2(p_path => 'filtros.tipo_identificacion');
    Lv_login               := APEX_JSON.get_varchar2(p_path => 'filtros.login');
    Lv_tipo_contacto       := APEX_JSON.get_varchar2(p_path => 'filtros.tipo_contacto');
    
    IF Lv_identificacion IS NULL AND Lv_login IS NULL THEN
      lv_error := 'identificacion o login';
      RAISE Le_empty_field;
    END IF;
    
    Ln_count := APEX_JSON.GET_COUNT(p_path => 'columnas');
    
    FOR i IN 1 .. Ln_count LOOP
    
      Lv_columna := UPPER(APEX_JSON.get_varchar2(p_path => 'columnas[%d]', p0 => i));
      
      CASE Lv_columna
        WHEN 'IDENTIFICACION' THEN
          Lv_query_columnas := Lv_query_columnas || 'A.IDENTIFICACION_CLIENTE, ';
        WHEN 'TIPO_IDENTIFICACION' THEN
          Lv_query_columnas := Lv_query_columnas || 'A.TIPO_IDENTIFICACION, ';
        WHEN 'LOGIN' THEN
          Lv_query_columnas := Lv_query_columnas || 'F.LOGIN, ';
        WHEN 'TIPO_CONTACTO' THEN
          Lv_query_columnas := Lv_query_columnas || 'H.DESCRIPCION_FORMA_CONTACTO AS TIPO_CONTACTO, ';
        ELSE
          Lv_query_columnas := Lv_query_columnas || ' ';
      END CASE;
      Lv_query_columnas := Lv_query_columnas || '
      ';
    END LOOP;
    
    IF Lv_identificacion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND A.IDENTIFICACION_CLIENTE = ''' || Lv_identificacion || '''';
    END IF;
    
    IF Lv_tipo_identificacion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND A.TIPO_IDENTIFICACION = ''' || Lv_tipo_identificacion || '''';
    END IF;
    
    IF Lv_login IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND F.LOGIN = ''' || Lv_login || '''';
    END IF;
    
    IF Lv_tipo_contacto IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND H.DESCRIPCION_FORMA_CONTACTO = ''' || Lv_tipo_contacto || '''';
    END IF;
    
    lv_query := '
      SELECT
        ' || Lv_query_columnas || '
        G.VALOR
      FROM
        DB_COMERCIAL.INFO_PERSONA A, 
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL B, 
        DB_COMERCIAL.INFO_EMPRESA_ROL C, 
        DB_GENERAL.ADMI_ROL D, 
        DB_GENERAL.ADMI_TIPO_ROL E, 
        DB_COMERCIAL.INFO_PUNTO F,
        DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO G,
        DB_COMERCIAL.ADMI_FORMA_CONTACTO H
      WHERE
        A.ID_PERSONA = B.PERSONA_ID 
        AND C.ID_EMPRESA_ROL = B.EMPRESA_ROL_ID 
        AND C.ROL_ID = D.ID_ROL 
        AND D.TIPO_ROL_ID = E.ID_TIPO_ROL 
        AND F.PERSONA_EMPRESA_ROL_ID = B.ID_PERSONA_ROL
        AND G.PUNTO_ID = F.ID_PUNTO
        AND G.FORMA_CONTACTO_ID = H.ID_FORMA_CONTACTO
        AND A.ESTADO = ''Activo''
        AND B.ESTADO = ''Activo'' 
        AND C.ESTADO = ''Activo'' 
        AND D.ESTADO = ''Activo'' 
        AND E.ESTADO = ''Activo'' 
        AND F.ESTADO = ''Activo''
        AND C.EMPRESA_COD = 18 
        AND E.DESCRIPCION_TIPO_ROL = ''Cliente''
        ' || Lv_query_filtros || '
    ';
          
    OPEN Prf_Result FOR Lv_query;
    
  EXCEPTION
    WHEN Le_empty_field THEN
      Pv_MensaError := 'Campo ' || lv_error || ' es obligatorio';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_CONTACTOS',
        Pv_MensaError,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
    WHEN OTHERS THEN
      Pv_MensaError := 'ERROR PROCEDURE DB_EXTERNO.EXKG_MD_CONSULTS.P_INFO_CONTACTOS : ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_CONTACTOS',
        SQLERRM,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
      
  END P_INFO_CONTACTOS;
 
  
  PROCEDURE P_INFO_CASOS(PCL_JSONFILTROS IN CLOB,
                           Pv_MensaError OUT VARCHAR2,
                           Prf_Result OUT Crf_Result) IS
    
    Lv_query          CLOB;
    Lv_query_columnas CLOB;
    Lv_query_filtros  CLOB;
    Lv_columna        varchar2(25); 
    
    Lv_identificacion      varchar2(20);
    Lv_tipo_identificacion varchar2(3);
    Lv_login               varchar2(60);
    Lv_numero_caso         varchar2(100);
    Lv_tipo_caso           varchar2(100);
    
    Le_empty_field EXCEPTION;
    Le_max_min     EXCEPTION;
    lv_error       VARCHAR2(50);
    Lv_IpCreacion  VARCHAR2(30) := '127.0.0.1';
    
    Ln_count PLS_INTEGER := 0;
    
  BEGIN
   
    APEX_JSON.PARSE(PCL_JSONFILTROS);
       
    Lv_identificacion      := APEX_JSON.get_varchar2(p_path => 'filtros.identificacion');
    Lv_tipo_identificacion := APEX_JSON.get_varchar2(p_path => 'filtros.tipo_identificacion');
    Lv_login               := APEX_JSON.get_varchar2(p_path => 'filtros.login');
    Lv_numero_caso         := APEX_JSON.get_varchar2(p_path => 'filtros.numero_caso');
    Lv_tipo_caso           := APEX_JSON.get_varchar2(p_path => 'filtros.tipo_caso');
    
    IF Lv_identificacion IS NULL AND Lv_login IS NULL THEN
      lv_error := 'identificacion o login';
      RAISE Le_empty_field;
    END IF;
    
    Ln_count := APEX_JSON.GET_COUNT(p_path => 'columnas');
    
    FOR i IN 1 .. Ln_count LOOP
    
      Lv_columna := UPPER(APEX_JSON.get_varchar2(p_path => 'columnas[%d]', p0 => i));
      
      CASE Lv_columna
        WHEN 'IDENTIFICACION' THEN
          Lv_query_columnas := Lv_query_columnas || 'A.IDENTIFICACION_CLIENTE, ';
        WHEN 'TIPO_IDENTIFICACION' THEN
          Lv_query_columnas := Lv_query_columnas || 'A.TIPO_IDENTIFICACION, ';
        WHEN 'LOGIN' THEN
          Lv_query_columnas := Lv_query_columnas || 'F.LOGIN, ';
        WHEN 'TIPO_CASO' THEN
          Lv_query_columnas := Lv_query_columnas || 'K.NOMBRE_TIPO_CASO AS TIPO_CASO, ';
        WHEN 'NUMERO_CASO' THEN
          Lv_query_columnas := Lv_query_columnas || 'J.NUMERO_CASO, ';
        WHEN 'HIPOTESIS' THEN
          Lv_query_columnas := Lv_query_columnas || 'L.NOMBRE_HIPOTESIS AS HIPOTESIS, ';
        ELSE
          Lv_query_columnas := Lv_query_columnas || ' ';
      END CASE;
      Lv_query_columnas := Lv_query_columnas || '
      ';
    END LOOP;
    
    IF Lv_identificacion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND A.IDENTIFICACION_CLIENTE = ''' || Lv_identificacion || '''';
    END IF;
    
    IF Lv_tipo_identificacion IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND A.TIPO_IDENTIFICACION = ''' || Lv_tipo_identificacion || '''';
    END IF;
    
    IF Lv_login IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND F.LOGIN = ''' || Lv_login || '''';
    END IF;
    
    IF Lv_numero_caso IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND J.NUMERO_CASO = ''' || Lv_numero_caso || '''';
    END IF;
    
    IF Lv_tipo_caso IS NOT NULL THEN
      Lv_query_filtros := Lv_query_filtros || 'AND K.NOMBRE_TIPO_CASO = ''' || Lv_tipo_caso || '''';
    END IF;
    
    lv_query := '
      SELECT
       ' || Lv_query_columnas || '
        J.VERSION_INI AS VERSION_INICIAL,
        J.FE_APERTURA
      FROM
        DB_COMERCIAL.INFO_PERSONA A, 
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL B, 
        DB_COMERCIAL.INFO_EMPRESA_ROL C, 
        DB_GENERAL.ADMI_ROL D, 
        DB_GENERAL.ADMI_TIPO_ROL E, 
        DB_COMERCIAL.INFO_PUNTO F,
        DB_SOPORTE.INFO_PARTE_AFECTADA G,
        DB_SOPORTE.INFO_DETALLE H,
        DB_SOPORTE.INFO_DETALLE_HIPOTESIS I,
        DB_SOPORTE.INFO_CASO J,
        DB_SOPORTE.ADMI_TIPO_CASO K,
        DB_SOPORTE.ADMI_HIPOTESIS L
      WHERE
        A.ID_PERSONA = B.PERSONA_ID 
        AND C.ID_EMPRESA_ROL = B.EMPRESA_ROL_ID 
        AND C.ROL_ID = D.ID_ROL 
        AND D.TIPO_ROL_ID = E.ID_TIPO_ROL 
        AND F.PERSONA_EMPRESA_ROL_ID = B.ID_PERSONA_ROL
        AND G.AFECTADO_NOMBRE = F.LOGIN
        AND G.AFECTADO_ID = F.ID_PUNTO
        AND H.ID_DETALLE = G.DETALLE_ID
        AND I.HIPOTESIS_ID = L.ID_HIPOTESIS
        AND I.ID_DETALLE_HIPOTESIS = H.DETALLE_HIPOTESIS_ID
        AND J.ID_CASO = I.CASO_ID
        AND K.ID_TIPO_CASO = J.TIPO_CASO_ID
        AND H.DETALLE_HIPOTESIS_ID IS NOT NULL
        AND A.ESTADO <> ''Inactivo'' 
        AND B.ESTADO <> ''Inactivo'' 
        AND C.ESTADO <> ''Inactivo'' 
        AND D.ESTADO <> ''Inactivo'' 
        AND E.ESTADO <> ''Inactivo'' 
        AND F.ESTADO <> ''Inactivo'' 
        AND C.EMPRESA_COD = 18 
        AND E.DESCRIPCION_TIPO_ROL = ''Cliente''
        AND H.ID_DETALLE = (
          SELECT
            MIN (X.ID_DETALLE)
          FROM
            DB_SOPORTE.INFO_DETALLE X
          WHERE
            X.ID_DETALLE = G.DETALLE_ID
            AND X.DETALLE_HIPOTESIS_ID IS NOT NULL
        )
        AND NOT EXISTS (
          SELECT 
            1
          FROM
            DB_SOPORTE.INFO_CASO_HISTORIAL Y
          WHERE
            Y.CASO_ID = J.ID_CASO
            AND Y.ESTADO = ''Cerrado''
        )
        ' || Lv_query_filtros || '
    ';
          
    OPEN Prf_Result FOR Lv_query;
    
  EXCEPTION
    WHEN Le_empty_field THEN
      Pv_MensaError := 'Campo ' || lv_error || ' es obligatorio';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_CASOS',
        Pv_MensaError,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
    WHEN Le_max_min THEN
      Pv_MensaError := lv_error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_CASOS',
        Pv_MensaError,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
    WHEN OTHERS THEN
      Pv_MensaError := 'ERROR PROCEDURE DB_EXTERNO.EXKG_MD_CONSULTS.P_INFO_CASOS : ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'EXKG_MD_CONSULTS',
        'P_INFO_CASOS',
        SQLERRM,
        'APP_OSS',
        SYSDATE,
        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
      );
      
  END P_INFO_CASOS;
  
  
  FUNCTION F_GET_ELEMENTO(Fn_id_servicio NUMBER, 
                           Fv_campo VARCHAR2,
                           Fv_elemento VARCHAR2)
  RETURN VARCHAR2 IS
  
    CURSOR C_GET_ELEMENTO_TMP IS
    SELECT
      CASE Fv_campo
        WHEN 'ELEMENTO' THEN B.NOMBRE_ELEMENTO
        WHEN 'MODELO' THEN C.NOMBRE_MODELO_ELEMENTO
        WHEN 'MARCA' THEN D.NOMBRE_MARCA_ELEMENTO
        WHEN 'SERIE' THEN B.SERIE_FISICA
        ELSE ''
      END AS CAMPO
    FROM
      DB_COMERCIAL.INFO_SERVICIO_TECNICO A,
      DB_INFRAESTRUCTURA.INFO_ELEMENTO B,
      DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO C,
      DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO D
    WHERE
      ((A.ELEMENTO_ID = B.ID_ELEMENTO AND Fv_elemento = 'OLT') OR
      (A.ELEMENTO_CLIENTE_ID = B.ID_ELEMENTO AND Fv_elemento = 'ONT') OR
      (A.ELEMENTO_CONTENEDOR_ID = B.ID_ELEMENTO AND Fv_elemento = 'CAJA') OR
      (A.ELEMENTO_CONECTOR_ID = B.ID_ELEMENTO AND Fv_elemento = 'SPLITTER')) AND    
      B.MODELO_ELEMENTO_ID = C.ID_MODELO_ELEMENTO AND
      C.MARCA_ELEMENTO_ID = D.ID_MARCA_ELEMENTO AND
      A.SERVICIO_ID = Fn_id_servicio;
      
      
    CURSOR C_GET_ELEMENTO IS
    SELECT
      CASE Fv_campo
        WHEN 'ELEMENTO' THEN B.NOMBRE_ELEMENTO
        WHEN 'SERIE' THEN B.SERIE_FISICA
        ELSE ''
      END AS CAMPO
    FROM
      DB_COMERCIAL.INFO_SERVICIO_TECNICO A,
      DB_INFRAESTRUCTURA.INFO_ELEMENTO B
    WHERE
      ((A.ELEMENTO_ID = B.ID_ELEMENTO AND Fv_elemento = 'OLT') OR
      (A.ELEMENTO_CLIENTE_ID = B.ID_ELEMENTO AND Fv_elemento = 'ONT') OR
      (A.ELEMENTO_CONTENEDOR_ID = B.ID_ELEMENTO AND Fv_elemento = 'CAJA') OR
      (A.ELEMENTO_CONECTOR_ID = B.ID_ELEMENTO AND Fv_elemento = 'SPLITTER')) AND    
      A.SERVICIO_ID = Fn_id_servicio;
      
    CURSOR C_GET_ELEMENTO_MODELO IS
    SELECT
      C.NOMBRE_MODELO_ELEMENTO
    FROM
      DB_COMERCIAL.INFO_SERVICIO_TECNICO A,
      DB_INFRAESTRUCTURA.INFO_ELEMENTO B,
      DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO C
    WHERE
      ((A.ELEMENTO_ID = B.ID_ELEMENTO AND Fv_elemento = 'OLT') OR
      (A.ELEMENTO_CLIENTE_ID = B.ID_ELEMENTO AND Fv_elemento = 'ONT') OR
      (A.ELEMENTO_CONTENEDOR_ID = B.ID_ELEMENTO AND Fv_elemento = 'CAJA') OR
      (A.ELEMENTO_CONECTOR_ID = B.ID_ELEMENTO AND Fv_elemento = 'SPLITTER')) AND    
      B.MODELO_ELEMENTO_ID = C.ID_MODELO_ELEMENTO AND
      A.SERVICIO_ID = Fn_id_servicio;
      
    CURSOR C_GET_ELEMENTO_MARCA IS
    SELECT
      D.NOMBRE_MARCA_ELEMENTO
    FROM
      DB_COMERCIAL.INFO_SERVICIO_TECNICO A,
      DB_INFRAESTRUCTURA.INFO_ELEMENTO B,
      DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO C,
      DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO D
    WHERE
      ((A.ELEMENTO_ID = B.ID_ELEMENTO AND Fv_elemento = 'OLT') OR
      (A.ELEMENTO_CLIENTE_ID = B.ID_ELEMENTO AND Fv_elemento = 'ONT') OR
      (A.ELEMENTO_CONTENEDOR_ID = B.ID_ELEMENTO AND Fv_elemento = 'CAJA') OR
      (A.ELEMENTO_CONECTOR_ID = B.ID_ELEMENTO AND Fv_elemento = 'SPLITTER')) AND    
      B.MODELO_ELEMENTO_ID = C.ID_MODELO_ELEMENTO AND
      C.MARCA_ELEMENTO_ID = D.ID_MARCA_ELEMENTO AND
      A.SERVICIO_ID = Fn_id_servicio;
    
    CURSOR C_GET_IPS IS
    SELECT
      B.*
    FROM
      DB_COMERCIAL.INFO_SERVICIO_TECNICO A,
      DB_INFRAESTRUCTURA.INFO_IP B
    WHERE
      ((A.ELEMENTO_ID = B.ELEMENTO_ID AND Fv_elemento = 'OLT') OR
      (A.ELEMENTO_CLIENTE_ID = B.ELEMENTO_ID AND Fv_elemento = 'ONT') OR
      (A.ELEMENTO_CONTENEDOR_ID = B.ELEMENTO_ID AND Fv_elemento = 'CAJA') OR
      (A.ELEMENTO_CONECTOR_ID = B.ELEMENTO_ID AND Fv_elemento = 'SPLITTER')) AND  
      A.SERVICIO_ID = Fn_id_servicio AND
      B.ESTADO = 'Activo';
      
    Lv_elemento        DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE;
    Lv_modelo          DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE;
    Lv_marca           DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE;
    Lv_serial_elemento DB_INFRAESTRUCTURA.INFO_ELEMENTO.SERIE_FISICA%TYPE;
    
    CURSOR C_GET_PUERTOS IS
    SELECT
      B.*
    FROM
      DB_COMERCIAL.INFO_SERVICIO_TECNICO A,
      DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO B
    WHERE 
      ((A.INTERFACE_ELEMENTO_ID = B.ID_INTERFACE_ELEMENTO AND Fv_elemento = 'OLT') OR
      (A.INTERFACE_ELEMENTO_CLIENTE_ID = B.ID_INTERFACE_ELEMENTO AND Fv_elemento = 'ONT') OR
      (A.INTERFACE_ELEMENTO_CONECTOR_ID = B.ID_INTERFACE_ELEMENTO AND Fv_elemento = 'SPLITTER')) AND  
      A.SERVICIO_ID = Fn_id_servicio;
    
    Lv_ips        VARCHAR2(1000);
    Lv_interfaces VARCHAR2(1000);
    
  BEGIN
    
    CASE Fv_campo
      WHEN 'ELEMENTO' THEN
        OPEN C_GET_ELEMENTO;
        FETCH
          C_GET_ELEMENTO
        INTO
          Lv_elemento;
        CLOSE C_GET_ELEMENTO;
        RETURN Lv_elemento;
      WHEN 'MODELO' THEN
        OPEN C_GET_ELEMENTO_MODELO;
        FETCH
          C_GET_ELEMENTO_MODELO
        INTO
          Lv_modelo;
        CLOSE C_GET_ELEMENTO_MODELO;
        RETURN Lv_modelo;
      WHEN 'MARCA' THEN
        OPEN C_GET_ELEMENTO_MARCA;
        FETCH
          C_GET_ELEMENTO_MARCA
        INTO
          Lv_marca;
        CLOSE C_GET_ELEMENTO_MARCA;
        RETURN Lv_marca;
      WHEN 'SERIE' THEN
        OPEN C_GET_ELEMENTO;
        FETCH
          C_GET_ELEMENTO
        INTO
          Lv_serial_elemento;
        CLOSE C_GET_ELEMENTO;
        RETURN Lv_serial_elemento;
      WHEN 'IP' THEN
        FOR i IN C_GET_IPS LOOP
          Lv_ips := Lv_ips || i.ip || ',';
        END LOOP;
        Lv_ips := SUBSTR(Lv_ips,0,LENGTH(Lv_ips) - 1);
        RETURN Lv_ips;
      WHEN 'PUERTO' THEN
        FOR i IN C_GET_PUERTOS LOOP
          Lv_interfaces := Lv_interfaces || i.NOMBRE_INTERFACE_ELEMENTO || ',';
        END LOOP;
        Lv_interfaces := SUBSTR(Lv_interfaces,0,LENGTH(Lv_interfaces) - 1);
        RETURN Lv_interfaces;
      
    END CASE;
    
    RETURN '';
  
  END F_GET_ELEMENTO;
  
  FUNCTION F_GET_IPS_FIJAS(Fn_id_servicio NUMBER)
  RETURN VARCHAR2 IS
  
    CURSOR C_GET_IPS_FIJAS IS
    SELECT A.ip FROM DB_INFRAESTRUCTURA.INFO_IP A WHERE A.SERVICIO_ID = Fn_id_servicio AND A.ESTADO = 'Activo';
    
    Lv_ips_fijas varchar2(1000);
    
  BEGIN
    
    FOR i IN C_GET_IPS_FIJAS LOOP
      Lv_ips_fijas := Lv_ips_fijas || i.ip || ',';
    END LOOP;
    
    Lv_ips_fijas := SUBSTR(Lv_ips_fijas,0,LENGTH(Lv_ips_fijas) - 1);
    
    RETURN Lv_ips_fijas;
    
  END F_GET_IPS_FIJAS;
  
  
  FUNCTION F_GET_IPS_ADICIONALES(Fn_id_punto NUMBER)
  RETURN VARCHAR2 IS
    
    CURSOR C_GET_IPS_ADICIONALES IS
    SELECT
      B.ip
    FROM
      DB_COMERCIAL.INFO_SERVICIO A,
      DB_INFRAESTRUCTURA.INFO_IP B
    WHERE
      A.PUNTO_ID = Fn_id_punto AND
      B.SERVICIO_ID = A.ID_SERVICIO AND
      A.PLAN_ID IS NULL AND
      A.PRODUCTO_ID IS NOT NULL AND
      B.ESTADO = 'Activo';
    
    Lv_ips_adicionales varchar2(1000);
    
  BEGIN
  
    FOR i IN C_GET_IPS_ADICIONALES LOOP
      Lv_ips_adicionales := Lv_ips_adicionales || i.ip || ',';
    END LOOP;
    
    Lv_ips_adicionales := SUBSTR(Lv_ips_adicionales,0,LENGTH(Lv_ips_adicionales) - 1);
    
    RETURN Lv_ips_adicionales;
  
  END F_GET_IPS_ADICIONALES;
  
  FUNCTION F_GET_SALDO_TOTAL(Fv_identificacion VARCHAR2)
  RETURN NUMBER IS
    
    CURSOR C_GET_SALDO_TOTAL IS
    SELECT
      SUM(D.SALDO) AS SALDO_TOTAL
    FROM
      DB_COMERCIAL.INFO_PERSONA A,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL B,
      DB_COMERCIAL.INFO_PUNTO C,
      DB_COMERCIAL.INFO_PUNTO_SALDO D
    WHERE
      B.PERSONA_ID = A.ID_PERSONA AND
      C.PERSONA_EMPRESA_ROL_ID = B.ID_PERSONA_ROL AND
      D.PUNTO_ID = C.ID_PUNTO
      AND A.IDENTIFICACION_CLIENTE = Fv_identificacion
      AND B.ESTADO <> 'Inactivo'
      AND A.ESTADO <> 'Inactivo'
      AND C.ESTADO <> 'Inactivo';
    
    Lv_saldo_total DB_COMERCIAL.INFO_PUNTO_SALDO.SALDO%TYPE;
    
  BEGIN
  
    OPEN C_GET_SALDO_TOTAL;
    FETCH
      C_GET_SALDO_TOTAL
    INTO
      Lv_saldo_total;
    CLOSE C_GET_SALDO_TOTAL;
      
    RETURN Lv_saldo_total;
  
  END F_GET_SALDO_TOTAL;
  
  FUNCTION F_GET_PLAN(Fv_login VARCHAR2,
                       Fv_estado_servicio VARCHAR2)
  RETURN VARCHAR2 IS
  
    CURSOR C_GET_PLAN(Cv_login VARCHAR2, Cv_estado_servicio VARCHAR2) IS
    SELECT 
      IPC.NOMBRE_PLAN
    FROM 
      DB_COMERCIAL.INFO_PUNTO IP,
      DB_COMERCIAL.INFO_SERVICIO ISRV,
      DB_COMERCIAL.INFO_PLAN_CAB IPC,
      DB_COMERCIAL.INFO_PLAN_DET IPD,
      DB_COMERCIAL.ADMI_PRODUCTO AP
    WHERE
      IP.ID_PUNTO = ISRV.PUNTO_ID AND
      IPC.ID_PLAN = ISRV.PLAN_ID AND
      IPD.PLAN_ID = IPC.ID_PLAN AND
      AP.ID_PRODUCTO = IPD.PRODUCTO_ID AND
      ISRV.ESTADO = Cv_estado_servicio AND
      AP.NOMBRE_TECNICO = 'INTERNET' AND
      IP.LOGIN = Cv_login;
    
    Lv_plan DB_COMERCIAL.INFO_PLAN_CAB.NOMBRE_PLAN%TYPE;
    
  BEGIN
    
    OPEN C_GET_PLAN(Fv_login, Fv_estado_servicio);
    FETCH
      C_GET_PLAN
    INTO
      Lv_plan;
    CLOSE C_GET_PLAN;
      
    RETURN Lv_plan;
    
  END F_GET_PLAN;
  
  FUNCTION F_GET_PRODUCTOS(Fn_id_punto        NUMBER,
                            Fv_estado_servicio VARCHAR2)
  RETURN CLOB IS
  
    CURSOR C_GET_PRODUCTOS IS
    SELECT
      AP.DESCRIPCION_PRODUCTO
    FROM 
      DB_COMERCIAL.INFO_PUNTO IP,
      DB_COMERCIAL.INFO_SERVICIO ISRV,
      DB_COMERCIAL.ADMI_PRODUCTO AP
    WHERE 
      IP.ID_PUNTO = ISRV.PUNTO_ID AND
      ISRV.PRODUCTO_ID = AP.ID_PRODUCTO AND
      ISRV.PRODUCTO_ID IS NOT NULL AND
      ISRV.ESTADO = Fv_estado_servicio AND
      IP.ID_PUNTO = Fn_id_punto;
    
    Lc_productos CLOB;
    
  BEGIN
    
    FOR i IN C_GET_PRODUCTOS LOOP
      Lc_productos := Lc_productos || i.DESCRIPCION_PRODUCTO || ',';
    END LOOP;
    
    Lc_productos := SUBSTR(Lc_productos,0,LENGTH(Lc_productos) - 1);    
    
    RETURN Lc_productos;
    
  END F_GET_PRODUCTOS;

END EXKG_MD_CONSULTS;
/
