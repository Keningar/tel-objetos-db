CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA
AS
  /*
  * Documentación para TYPE 'Lr_InfoCajaConector'.
  *
  * Tipo de datos para el retorno de la información correspondiente a la cobertura
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 02-07-2021
  */
  TYPE Lr_InfoCajaConector IS RECORD
  (
    ID_CAJA                 DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_CAJA             DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    ESTADO_CAJA             DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO%TYPE,
    ID_CONECTOR             DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_CONECTOR         DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    ESTADO_CONECTOR         DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO%TYPE,
    LATITUD_CAJA            NUMBER,
    LONGITUD_CAJA           NUMBER,
    DISTANCIA               NUMBER,
    NUM_PUERTOS_DISPONIBLES NUMBER
  );

  /*
  * Documentación para TYPE 'Lt_InfoCajaConector'.
  *
  * Tabla para almacenar la data enviada con la información correspondiente a la cobertura
  *
  * @author Lizbeth Cruz <mlcruz@telconet.ec>
  * @version 1.0 02-07-2021
  */
  TYPE Lt_InfoCajaConector
  IS
    TABLE OF Lr_InfoCajaConector INDEX BY PLS_INTEGER;  


  /**
   * F_CALCULA_DISTANCIA
   *
   * Función que permite obtener distancia entre 2 coordenadas
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 29-06-2021
   *
   * @param Fn_LatitudPunto1    IN NUMBER Latitud del punto 1
   * @param Fn_LongitudPunto1   IN NUMBER Longitud del punto 1
   * @param Fn_LatitudPunto2    IN NUMBER Latitud del punto 2 
   * @param Fn_LongitudPunto2   IN NUMBER Longitud del punto 2
   * @param Fn_EarthRadius      IN NUMBER DEFAULT 6371000 Valor del Earth Radius
   * @return OUT FLOAT
   */
  FUNCTION F_CALCULA_DISTANCIA(
    Fn_LatitudPunto1    IN NUMBER, 
    Fn_LongitudPunto1   IN NUMBER,
    Fn_LatitudPunto2    IN NUMBER, 
    Fn_LongitudPunto2   IN NUMBER,
    Fn_EarthRadius      IN NUMBER DEFAULT 6371000)
    RETURN NUMBER;

  /**
   * P_OBTIENE_LISTADO_COBERTURA
   * Función que obtiene la información de cobertura de acuerdo a los parámetros enviados en el json
   *
   * @param  Pcl_JsonRequest    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Prf_Registros      OUT SYS_REFCURSOR Cursor con los registros de la consulta
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 02-07-2021
   *
   */
  PROCEDURE P_OBTIENE_LISTADO_COBERTURA(
    Pcl_JsonRequest IN CLOB,
    Pv_Status       OUT VARCHAR2,
    Pv_Mensaje      OUT VARCHAR2,
    Prf_Registros   OUT SYS_REFCURSOR);

  /**
   * P_OBTIENE_INFO_PREFACTIBILIDAD
   * Procedimiento que obtiene la respuesta en formato json de la consulta de prefactibilidad
   *
   * @param  Pcl_JsonRequest    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pcl_JsonResponse   OUT CLOB Respuesta en formato json de la consulta
   *
   * @author Lizbeth Cruz <mlcruz@telconet.ec>
   * @version 1.0 01-07-2021
   *
   */
  PROCEDURE P_OBTIENE_INFO_PREFACTIBILIDAD(
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_JsonResponse    OUT CLOB);

END
INKG_FACTIB_CONNECTIV_CONSULTA;

/

CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA
AS
  FUNCTION F_CALCULA_DISTANCIA(
    Fn_LatitudPunto1    IN NUMBER, 
    Fn_LongitudPunto1   IN NUMBER,
    Fn_LatitudPunto2    IN NUMBER, 
    Fn_LongitudPunto2   IN NUMBER,
    Fn_EarthRadius      IN NUMBER DEFAULT 6371000)
    RETURN NUMBER
  IS
    Ln_LatitudPunto1Radianes    NUMBER;
    Ln_LongitudPunto1Radianes   NUMBER;
    Ln_LatitudPunto2Radianes    NUMBER;
    Ln_LongitudPunto2Radianes   NUMBER;
    Ln_LatitudDelta             NUMBER;
    Ln_LongitudDelta            NUMBER;
    Ln_ValorConstantePi         CONSTANT NUMBER := 3.1415927;
    Ln_ValorCalculadoSqrt       NUMBER;
    Ln_Distancia                NUMBER;

  BEGIN
    --Para la conversión de grados a radianes, se toma en cuenta que 180 grados es equivalente a PI radianes.
    Ln_LatitudPunto1Radianes    := Fn_LatitudPunto1 * Ln_ValorConstantePi/180;
    Ln_LongitudPunto1Radianes   := Fn_LongitudPunto1 * Ln_ValorConstantePi/180;
    Ln_LatitudPunto2Radianes    := Fn_LatitudPunto2 * Ln_ValorConstantePi/180;
    Ln_LongitudPunto2Radianes   := Fn_LongitudPunto2 * Ln_ValorConstantePi/180;

    Ln_LatitudDelta             := Ln_LatitudPunto1Radianes - Ln_LatitudPunto2Radianes;
    Ln_LongitudDelta            := Ln_LongitudPunto1Radianes - Ln_LongitudPunto2Radianes;
    
    /**
     * Para el cálculo de la distancia, se aplica la fórmula de Haversine expresada en arcotangente y no en arcoseno como se la usa en Telcos+,
     * ya que al ser usada la de Telcos+ desde un query de factibilidad, provoca que la respuesta demore aproximadamente 7 minutos, mientras que al
     * usar la implementada en esta función demora 25 segundos aproximadamente. Cabe mencionar que ambas funciones mencionadas son equivalentes.
     * Referencia Web: https://www.movable-type.co.uk/scripts/latlong.html
     */
    Ln_ValorCalculadoSqrt       :=  POWER(SIN(Ln_LatitudDelta/2),2) 
                                    + COS(Ln_LatitudPunto2Radianes) * COS(Ln_LatitudPunto1Radianes) * POWER(SIN(Ln_LongitudDelta/2),2);
    Ln_Distancia                := ROUND(2 * Fn_EarthRadius * ATAN2(SQRT(Ln_ValorCalculadoSqrt), SQRT(1-Ln_ValorCalculadoSqrt)), 2);
    RETURN Ln_Distancia;

  EXCEPTION
  WHEN OTHERS THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(   'Telcos+', 'INKG_FACTIB_CONNECTIV_CONSULTA.F_CALCULA_DISTANCIA', 
                                            SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || 
                                            ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    RETURN NULL;
  END F_CALCULA_DISTANCIA;

  PROCEDURE P_OBTIENE_LISTADO_COBERTURA(
    Pcl_JsonRequest IN CLOB,
    Pv_Status       OUT VARCHAR2,
    Pv_Mensaje      OUT VARCHAR2,
    Prf_Registros   OUT SYS_REFCURSOR)
  AS
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_NombreParametroEarthRadius   VARCHAR2(35) := 'EARTH_RADIUS_DISTANCIA_COORDENADAS';
    CURSOR Lc_GetValorEarthRadius
    IS
      SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR1,'^\d+')),1) AS VALOR
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Lv_NombreParametroEarthRadius
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;


    CURSOR Lc_GetInfoParams(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                            Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE, 
                            Cv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                            Cv_CodEmpresa DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT DET.VALOR3, DET.VALOR4, DET.VALOR5
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND DET.EMPRESA_COD        = Cv_CodEmpresa
      AND DET.VALOR1             = Cv_Valor1
      AND DET.VALOR2             = Cv_Valor2
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;
    Lv_NombreParamGeneral           VARCHAR2(40) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ProcesoPrefactib             VARCHAR2(24) := 'PROCESO_PREFACTIBILIDAD';
    Lv_ParamsConsulta               VARCHAR2(16) := 'PARAMS_CONSULTA';
    Lv_ConfigResponse               VARCHAR2(16) := 'CONFIG_RESPONSE';
    Lv_TipoElementoConector         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE;
    Lv_Valor4ParamsConsulta         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR4%TYPE;
    Lv_Valor5ParamsConsulta         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR5%TYPE;
    Ln_EarthRadius                  NUMBER;
    Lv_ValorCajaDispersion          VARCHAR2(16) := 'CAJA DISPERSION';
    Lv_ValorRestringido             VARCHAR2(12) := 'Restringido';
    Lv_ValorDetalleNombreNivel      VARCHAR2(5) := 'NIVEL';
    Lv_ValorDetalleValorNivel       VARCHAR2(1) := '2';
    Lv_ValorEdificacion             VARCHAR2(12) := 'EDIFICACION';
    Lv_ValorInterfaceNotLikeIn      VARCHAR2(3) := 'IN%';
    Lv_ValorNotConnect              VARCHAR2(11) := 'not connect';
    Le_Exception                    EXCEPTION;
    Lv_Mensaje                      VARCHAR2(4000);
    Lcl_Select                      CLOB;
    Lcl_From                        CLOB;
    Lcl_Join                        CLOB;
    Lcl_Where                       CLOB;
    Lcl_ConsultaPrincipal           CLOB;
    Lcl_JsonFiltrosBusqueda         CLOB;
    Lv_Latitud                      VARCHAR2(50);
    Lv_Longitud                     VARCHAR2(50);
    Lv_DependeDeEdificio            VARCHAR2(2);
    Lv_CodEmpresa                   VARCHAR2(2);
    Lv_PrefijoEmpresa               VARCHAR2(5);
    Ln_DistanciaMaxCobertura        NUMBER;
  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonRequest;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_Latitud                  := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'latitud'));
    Lv_Longitud                 := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'longitud'));
    Lv_DependeDeEdificio        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'dependeDeEdificio'));
    Lv_CodEmpresa               := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'idEmpresa'));
    Lv_PrefijoEmpresa           := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'prefijoEmpresa'));
    Ln_DistanciaMaxCobertura    := TRIM(APEX_JSON.GET_NUMBER(p_path => 'distanciaMaxCobertura'));

    IF Lv_PrefijoEmpresa IS NULL OR Lv_CodEmpresa IS NULL THEN
      Lv_Mensaje := 'No se han enviado los parámetros obligatorios referentes a la empresa';
      RAISE Le_Exception;
    END IF;

    Lv_NombreParamGeneral := Lv_NombreParamGeneral || Lv_PrefijoEmpresa;
    IF Lc_GetInfoParams%ISOPEN THEN
    CLOSE Lc_GetInfoParams;
    END IF;

    OPEN Lc_GetInfoParams(Lv_NombreParamGeneral, Lv_ProcesoPrefactib, Lv_ParamsConsulta, Lv_CodEmpresa);
    FETCH Lc_GetInfoParams INTO Lv_TipoElementoConector, Lv_Valor4ParamsConsulta, Lv_Valor5ParamsConsulta;
    CLOSE Lc_GetInfoParams;

    IF (Lv_TipoElementoConector IS NULL OR Ln_DistanciaMaxCobertura IS NULL) THEN
      Lv_Mensaje := 'No existe la configuración general para realizar la consulta con el prefijo empresa ' || Lv_PrefijoEmpresa;
      RAISE Le_Exception;
    END IF;

    IF Lc_GetValorEarthRadius%ISOPEN THEN
    CLOSE Lc_GetValorEarthRadius;
    END IF;
    OPEN Lc_GetValorEarthRadius;
    FETCH Lc_GetValorEarthRadius INTO Ln_EarthRadius;
    CLOSE Lc_GetValorEarthRadius;

    Lcl_Select      := 'SELECT DISTINCT CAJA.ID_ELEMENTO AS ID_CAJA,
                        CAJA.NOMBRE_ELEMENTO AS NOMBRE_CAJA,
                        CAJA.ESTADO AS ESTADO_CAJA,
                        CONECTOR.ID_ELEMENTO AS ID_CONECTOR,
                        CONECTOR.NOMBRE_ELEMENTO AS NOMBRE_CONECTOR,
                        CONECTOR.ESTADO AS ESTADO_CONECTOR,
                        UBICACION_CAJA.LATITUD_UBICACION  AS LATITUD_CAJA,
                        UBICACION_CAJA.LONGITUD_UBICACION AS LONGITUD_CAJA,
                        DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.F_CALCULA_DISTANCIA(  UBICACION_CAJA.LATITUD_UBICACION, 
                                                                                                UBICACION_CAJA.LONGITUD_UBICACION, 
                                                                                                TO_NUMBER(''' || Lv_Latitud || '''),
                                                                                                TO_NUMBER(''' || Lv_Longitud || '''),
                                                                                                ' || Ln_EarthRadius || ' ) AS DISTANCIA,
                        NVL((SELECT COUNT(INTERFACE_CONECTOR.ID_INTERFACE_ELEMENTO)
                            FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_CONECTOR
                            WHERE INTERFACE_CONECTOR.ELEMENTO_ID = CONECTOR.ID_ELEMENTO
                            AND INTERFACE_CONECTOR.ESTADO = ''' || Lv_ValorNotConnect || ''' 
                            AND INTERFACE_CONECTOR.NOMBRE_INTERFACE_ELEMENTO NOT LIKE ''' || Lv_ValorInterfaceNotLikeIn || ''' 
                            GROUP BY INTERFACE_CONECTOR.ELEMENTO_ID
                        ), 0) AS NUM_PUERTOS_DISPONIBLES ';
    Lcl_From        := 'FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO REL_CAJA_CONECTOR
                        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CAJA
                        ON REL_CAJA_CONECTOR.ELEMENTO_ID_A = CAJA.ID_ELEMENTO
                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_CAJA
                        ON MODELO_CAJA.ID_MODELO_ELEMENTO = CAJA.MODELO_ELEMENTO_ID
                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_CAJA
                        ON TIPO_CAJA.ID_TIPO_ELEMENTO = MODELO_CAJA.TIPO_ELEMENTO_ID
                        INNER JOIN DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA EMPRESA_CAJA_UBICA
                        ON EMPRESA_CAJA_UBICA.ELEMENTO_ID = CAJA.ID_ELEMENTO
                        INNER JOIN DB_INFRAESTRUCTURA.INFO_UBICACION UBICACION_CAJA
                        ON UBICACION_CAJA.ID_UBICACION = EMPRESA_CAJA_UBICA.UBICACION_ID
                        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CONECTOR
                        ON CONECTOR.ID_ELEMENTO = REL_CAJA_CONECTOR.ELEMENTO_ID_B
                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_CONECTOR
                        ON MODELO_CONECTOR.ID_MODELO_ELEMENTO = CONECTOR.MODELO_ELEMENTO_ID
                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_CONECTOR
                        ON MODELO_CONECTOR.TIPO_ELEMENTO_ID = TIPO_CONECTOR.ID_TIPO_ELEMENTO ';
    Lcl_Where       := 'WHERE TIPO_CAJA.NOMBRE_TIPO_ELEMENTO = ''' || Lv_ValorCajaDispersion || ''' 
                        AND REL_CAJA_CONECTOR.ESTADO IN (''' || Lv_EstadoActivo || ''', ''' || Lv_ValorRestringido || ''' ) 
                        AND TIPO_CONECTOR.NOMBRE_TIPO_ELEMENTO = ''' || Lv_TipoElementoConector || ''' ';

    IF Lv_PrefijoEmpresa = 'MD' THEN 
      Lcl_Join      := 'INNER JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DETALLE_NIVEL_CAJA
                        ON DETALLE_NIVEL_CAJA.ELEMENTO_ID = CAJA.ID_ELEMENTO ';
      Lcl_Where     := Lcl_Where || 'AND CONECTOR.ESTADO <> ''' || Lv_ValorRestringido || ''' 
                                     AND EMPRESA_CAJA_UBICA.EMPRESA_COD = ''' || Lv_CodEmpresa || ''' 
                                     AND DETALLE_NIVEL_CAJA.DETALLE_NOMBRE = ''' || Lv_ValorDetalleNombreNivel || ''' 
                                     AND DETALLE_NIVEL_CAJA.DETALLE_VALOR = ''' || Lv_ValorDetalleValorNivel || ''' ';
      IF Lv_DependeDeEdificio <> 'SI' THEN
        Lcl_Where   := Lcl_Where || 'AND CAJA.ID_ELEMENTO NOT IN
                                     (
                                        SELECT CAJA_EDIFICIO.ID_ELEMENTO
                                        FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO REL_EDIFICACION_CAJA
                                        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CAJA_EDIFICIO
                                        ON CAJA_EDIFICIO.ID_ELEMENTO = REL_EDIFICACION_CAJA.ELEMENTO_ID_B
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_CAJA_EDIFICIO
                                        ON MODELO_CAJA_EDIFICIO.ID_MODELO_ELEMENTO = CAJA_EDIFICIO.MODELO_ELEMENTO_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_CAJA_EDIFICIO
                                        ON MODELO_CAJA_EDIFICIO.TIPO_ELEMENTO_ID = TIPO_CAJA_EDIFICIO.ID_TIPO_ELEMENTO
                                        INNER JOIN DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA EMPRESA_CAJA_EDIFICIO_UBICA
                                        ON EMPRESA_CAJA_EDIFICIO_UBICA.ELEMENTO_ID = CAJA_EDIFICIO.ID_ELEMENTO
                                        INNER JOIN DB_INFRAESTRUCTURA.INFO_UBICACION UBICACION_CAJA_EDIFICIO
                                        ON UBICACION_CAJA_EDIFICIO.ID_UBICACION = EMPRESA_CAJA_EDIFICIO_UBICA.UBICACION_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO EDIFICACION
                                        ON EDIFICACION.ID_ELEMENTO = REL_EDIFICACION_CAJA.ELEMENTO_ID_A
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_EDIFICACION
                                        ON MODELO_EDIFICACION.ID_MODELO_ELEMENTO = EDIFICACION.MODELO_ELEMENTO_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_EDIFICACION
                                        ON TIPO_EDIFICACION.ID_TIPO_ELEMENTO = MODELO_EDIFICACION.TIPO_ELEMENTO_ID
                                        INNER JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DETALLE_NIVEL_CAJA_EDIFICACION
                                        ON DETALLE_NIVEL_CAJA_EDIFICACION.ELEMENTO_ID = CAJA_EDIFICIO.ID_ELEMENTO
                                        WHERE TIPO_CAJA_EDIFICIO.NOMBRE_TIPO_ELEMENTO = ''' || Lv_ValorCajaDispersion || ''' 
                                        AND EMPRESA_CAJA_EDIFICIO_UBICA.EMPRESA_COD = ''' || Lv_CodEmpresa || ''' 
                                        AND CAJA_EDIFICIO.ESTADO = ''' || Lv_EstadoActivo || '''
                                        AND REL_EDIFICACION_CAJA.ESTADO = ''' || Lv_EstadoActivo || '''
                                        AND DETALLE_NIVEL_CAJA_EDIFICACION.DETALLE_NOMBRE = ''' || Lv_ValorDetalleNombreNivel || ''' 
                                        AND DETALLE_NIVEL_CAJA_EDIFICACION.DETALLE_VALOR = ''' || Lv_ValorDetalleValorNivel || ''' 
                                        AND TIPO_EDIFICACION.NOMBRE_TIPO_ELEMENTO =  ''' || Lv_ValorEdificacion || ''' 
                                        AND EDIFICACION.ESTADO = ''' || Lv_EstadoActivo || '''
                                     ) ';
      END IF;
    END IF;

    Lcl_ConsultaPrincipal := 'SELECT *
                              FROM (' || Lcl_Select || Lcl_From || Lcl_Join || Lcl_Where || ')
                              WHERE ' || Ln_DistanciaMaxCobertura || ' >= DISTANCIA 
                              ORDER BY DISTANCIA ASC ';
                              
    OPEN Prf_Registros FOR Lcl_ConsultaPrincipal;
    Pv_Status   := 'OK';
    Pv_Mensaje  := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status       := 'ERROR';
    Pv_Mensaje      := Lv_Mensaje || '. Por favor consultar con Sistemas!';
    Prf_Registros   := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_LISTADO_COBERTURA', 
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se ha podido realizar correctamente la consulta de prefactibilidad. Por favor consultar con Sistemas!';
    Prf_Registros   := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_LISTADO_COBERTURA',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTIENE_LISTADO_COBERTURA;

  PROCEDURE P_OBTIENE_INFO_PREFACTIBILIDAD(
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_JsonResponse    OUT CLOB)
  AS
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Lv_Elemento                     VARCHAR2(8) := 'ELEMENTO';
    Lv_Olt                          VARCHAR2(3) := 'OLT';
    Lv_DetDescripcionOltOperativo   VARCHAR2(14) := 'OLT OPERATIVO';
    Lv_DetValorOltOperativo         VARCHAR2(2) := 'NO';
    Lv_ValidacionOkRegistro         VARCHAR2(5);
    Ln_IdElementoOltNoOperativo     DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE;
    CURSOR Lc_GetInfoParamsConfigResponse(  Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                                            Cv_Valor1 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE, 
                                            Cv_Valor2 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE,
                                            Cv_CodEmpresa DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE)
    IS
      SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR3,'^\d+')),1) AS DISTANCIA_MAX_COBERTURA, 
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR4,'^\d+')),1) AS DISTANCIA_MAX_FACTIBILIDAD,
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR5,'^\d+')),1) AS NUM_CAJAS_CONECTORES_COBERT,
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(DET.VALOR6,'^\d+')),1) AS NUM_CAJAS_CONECTORES_FACTIB
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO        = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND DET.EMPRESA_COD        = Cv_CodEmpresa
      AND DET.VALOR1             = Cv_Valor1
      AND DET.VALOR2             = Cv_Valor2
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;

    CURSOR Lc_GetValidaOperatividadOltMd(Cn_IdElementoSplitter DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE)
    IS
      SELECT DISTINCT INTERFACE_OLT.ELEMENTO_ID ID_ELEMENTO
      FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_OLT
      INNER JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DET_OLT_OPERATIVO
      ON INTERFACE_OLT.ELEMENTO_ID = DET_OLT_OPERATIVO.ELEMENTO_ID 
      WHERE INTERFACE_OLT.ID_INTERFACE_ELEMENTO = DB_INFRAESTRUCTURA.GET_ELEMENTO_PADRE(Cn_IdElementoSplitter, Lv_Elemento, Lv_Olt)
      AND DET_OLT_OPERATIVO.DETALLE_DESCRIPCION = Lv_DetDescripcionOltOperativo
      AND DET_OLT_OPERATIVO.DETALLE_VALOR = Lv_DetValorOltOperativo;

    Lv_NombreParamGeneral           VARCHAR2(40) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ProcesoPrefactib             VARCHAR2(24) := 'PROCESO_PREFACTIBILIDAD';
    Lv_ConfigResponse               VARCHAR2(16) := 'CONFIG_RESPONSE';
    Ln_DistanciaMaxCobertura        NUMBER;
    Ln_DistanciaMaxFactibilidad     NUMBER;
    Ln_NumMaxCajasConectoresCobert  NUMBER;
    Ln_ContCajasConectoresCobert    NUMBER;
    Ln_IndxCajasConectoresCobert    NUMBER;
    Lr_RegCajasConectoresCobert     DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lr_InfoCajaConector;
    Lt_TRegsCajasConectoresCobert   DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConector;
    Ln_NumMaxCajasConectoresFactib  NUMBER;
    Ln_ContCajasConectoresFactib    NUMBER;
    Ln_IndxCajasConectoresFactib    NUMBER;
    Lr_RegCajasConectoresFactib     DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lr_InfoCajaConector;
    Lt_TRegsCajasConectoresFactib   DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConector;
    Lcl_JsonFiltrosCobertura        CLOB;
    Ln_IndxRegListadoCobertura      NUMBER;
    Lr_RegListadoCobertura          DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lr_InfoCajaConector;
    Lt_TRegsListadoCobertura        DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConector;
    Lrf_RegistrosListadoCobertura   SYS_REFCURSOR;
    Lcl_JsonFiltrosBusqueda         CLOB;
    Ln_Latitud                      NUMBER;
    Ln_Longitud                     NUMBER;
    Lv_DependeDeEdificio            VARCHAR2(2);
    Lv_CodEmpresa                   VARCHAR2(2);
    Lv_PrefijoEmpresa               VARCHAR2(5);
    Lv_ContinuaLoopCobertura        VARCHAR2(2) := 'SI';
    Lv_ExisteCobertura              VARCHAR2(2) := 'NO';
    Lv_ExisteFactibilidad           VARCHAR2(2) := 'NO';
    Lcl_JsonResponse                CLOB;
    Lv_Status                       VARCHAR2(5);
    Lv_Mensaje                      VARCHAR2(4000);
    Le_Exception                    EXCEPTION;
  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonRequest;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Ln_Latitud                  := TRIM(APEX_JSON.GET_NUMBER(p_path => 'latitud'));
    Ln_Longitud                 := TRIM(APEX_JSON.GET_NUMBER(p_path => 'longitud'));
    Lv_DependeDeEdificio        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'dependeDeEdificio'));
    Lv_CodEmpresa               := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'idEmpresa'));
    Lv_PrefijoEmpresa           := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'prefijoEmpresa'));

    IF Lv_PrefijoEmpresa IS NULL OR Lv_CodEmpresa IS NULL THEN
      Lv_Mensaje := 'No se han enviado los parámetros obligatorios referentes a la empresa';
      RAISE Le_Exception;
    END IF;

    Lv_NombreParamGeneral := Lv_NombreParamGeneral || Lv_PrefijoEmpresa;
    IF Lc_GetInfoParamsConfigResponse%ISOPEN THEN
    CLOSE Lc_GetInfoParamsConfigResponse;
    END IF;

    OPEN Lc_GetInfoParamsConfigResponse(Lv_NombreParamGeneral, Lv_ProcesoPrefactib, Lv_ConfigResponse, Lv_CodEmpresa);
    FETCH Lc_GetInfoParamsConfigResponse INTO Ln_DistanciaMaxCobertura, Ln_DistanciaMaxFactibilidad, 
                                              Ln_NumMaxCajasConectoresCobert, Ln_NumMaxCajasConectoresFactib;
    CLOSE Lc_GetInfoParamsConfigResponse;

    IF (Ln_DistanciaMaxCobertura IS NULL OR Ln_DistanciaMaxFactibilidad IS NULL 
        OR Ln_NumMaxCajasConectoresCobert IS NULL OR Ln_NumMaxCajasConectoresFactib IS NULL) THEN
      Lv_Mensaje := 'No existe la configuración general para realizar la consulta con el prefijo empresa ' || Lv_PrefijoEmpresa;
      RAISE Le_Exception;
    END IF;

    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object; -- {
    APEX_JSON.write('latitud', Ln_Latitud);
    APEX_JSON.write('longitud', Ln_Longitud);
    APEX_JSON.write('dependeDeEdificio', Lv_DependeDeEdificio);
    APEX_JSON.write('idEmpresa', Lv_CodEmpresa);
    APEX_JSON.write('prefijoEmpresa', Lv_PrefijoEmpresa);
    APEX_JSON.write('distanciaMaxCobertura', Ln_DistanciaMaxCobertura);
    APEX_JSON.close_object; -- }
    Lcl_JsonFiltrosCobertura    := APEX_JSON.get_clob_output;
    APEX_JSON.free_output;

    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object; -- {
    DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_LISTADO_COBERTURA(  Lcl_JsonFiltrosCobertura,
                                                                                    Lv_Status,
                                                                                    Lv_Mensaje,
                                                                                    Lrf_RegistrosListadoCobertura);
    IF Lv_Status = 'OK' THEN
      Ln_ContCajasConectoresCobert  := 0;
      Ln_ContCajasConectoresFactib  := 0;
      LOOP
        FETCH Lrf_RegistrosListadoCobertura BULK COLLECT
        INTO Lt_TRegsListadoCobertura LIMIT 100;
        Ln_IndxRegListadoCobertura := Lt_TRegsListadoCobertura.FIRST;
        WHILE (Ln_IndxRegListadoCobertura IS NOT NULL AND Lv_ContinuaLoopCobertura = 'SI')
        LOOP
          Lr_RegListadoCobertura        := Lt_TRegsListadoCobertura(Ln_IndxRegListadoCobertura);
          Lv_ExisteCobertura            := 'SI';
          Ln_ContCajasConectoresCobert  := Ln_ContCajasConectoresCobert + 1;
          IF Ln_ContCajasConectoresCobert <= Ln_NumMaxCajasConectoresCobert THEN
            Lt_TRegsCajasConectoresCobert(Ln_ContCajasConectoresCobert) := Lr_RegListadoCobertura;
          END IF;
          Lv_ValidacionOkRegistro       := '';
          Ln_IdElementoOltNoOperativo   := NULL;
          IF (Lr_RegListadoCobertura.DISTANCIA IS NOT NULL AND Lr_RegListadoCobertura.DISTANCIA <= Ln_DistanciaMaxFactibilidad
              AND Lr_RegListadoCobertura.NUM_PUERTOS_DISPONIBLES > 0) THEN
            IF Lv_PrefijoEmpresa = 'MD' THEN
              OPEN Lc_GetValidaOperatividadOltMd(Lr_RegListadoCobertura.ID_CONECTOR);
              FETCH Lc_GetValidaOperatividadOltMd INTO Ln_IdElementoOltNoOperativo;
              CLOSE Lc_GetValidaOperatividadOltMd;
              IF Ln_IdElementoOltNoOperativo IS NOT NULL THEN
                Lv_ValidacionOkRegistro := 'ERROR';
              ELSE
                Lv_ValidacionOkRegistro := 'OK';
              END IF;
            ELSE
              Lv_ValidacionOkRegistro := 'OK';
            END IF;

            IF Lv_ValidacionOkRegistro = 'OK' THEN
              Lv_ExisteFactibilidad := 'SI';
              Ln_ContCajasConectoresFactib := Ln_ContCajasConectoresFactib + 1;
              Lt_TRegsCajasConectoresFactib(Ln_ContCajasConectoresFactib) := Lr_RegListadoCobertura;
              IF Ln_ContCajasConectoresFactib >= Ln_NumMaxCajasConectoresFactib THEN
                Lv_ContinuaLoopCobertura := 'NO';
              END IF;
            END IF;
          END IF;
          Ln_IndxRegListadoCobertura  := Lt_TRegsListadoCobertura.NEXT(Ln_IndxRegListadoCobertura);
        END LOOP;
        EXIT
      WHEN Lrf_RegistrosListadoCobertura%NOTFOUND;
      END LOOP;
      CLOSE Lrf_RegistrosListadoCobertura;
      Ln_ContCajasConectoresFactib := 0;
      APEX_JSON.write('distanciaMaxCobertura', Ln_DistanciaMaxCobertura);
      APEX_JSON.write('distanciaMaxFactibilidad', Ln_DistanciaMaxFactibilidad);
      APEX_JSON.write('existeCobertura', Lv_ExisteCobertura);
      APEX_JSON.write('existeFactibilidad', Lv_ExisteFactibilidad);
      APEX_JSON.open_array('infoCajasConectores'); -- infoCajasConectores: [
      IF Lv_ExisteFactibilidad = 'SI' THEN
        Ln_IndxCajasConectoresFactib :=  Lt_TRegsCajasConectoresFactib.FIRST;
        WHILE (Ln_IndxCajasConectoresFactib IS NOT NULL)
        LOOP
          Lr_RegCajasConectoresFactib   := Lt_TRegsCajasConectoresFactib(Ln_IndxCajasConectoresFactib);
          APEX_JSON.open_object; -- {
          APEX_JSON.write('idCaja', Lr_RegCajasConectoresFactib.ID_CAJA);
          APEX_JSON.write('nombreCaja', Lr_RegCajasConectoresFactib.NOMBRE_CAJA);
          APEX_JSON.write('nombreConector', Lr_RegCajasConectoresFactib.NOMBRE_CONECTOR);
          APEX_JSON.write('distancia', Lr_RegCajasConectoresFactib.DISTANCIA);
          APEX_JSON.write('numPuertosDisponibles', Lr_RegCajasConectoresFactib.NUM_PUERTOS_DISPONIBLES);
          APEX_JSON.close_object; -- } infoCajaConectorFactibilidad
          Ln_IndxCajasConectoresFactib  := Lt_TRegsCajasConectoresFactib.NEXT(Ln_IndxCajasConectoresFactib);
        END LOOP;
      ELSIF Lv_ExisteCobertura = 'SI' THEN
        Ln_IndxCajasConectoresCobert :=  Lt_TRegsCajasConectoresCobert.FIRST;
        WHILE (Ln_IndxCajasConectoresCobert IS NOT NULL)
        LOOP
          Lr_RegCajasConectoresCobert   := Lt_TRegsCajasConectoresCobert(Ln_IndxCajasConectoresCobert);
          APEX_JSON.open_object; -- {
          APEX_JSON.write('idCaja', Lr_RegCajasConectoresCobert.ID_CAJA);
          APEX_JSON.write('nombreCaja', Lr_RegCajasConectoresCobert.NOMBRE_CAJA);
          APEX_JSON.write('nombreConector', Lr_RegCajasConectoresCobert.NOMBRE_CONECTOR);
          APEX_JSON.write('distancia', Lr_RegCajasConectoresCobert.DISTANCIA);
          APEX_JSON.write('numPuertosDisponibles', Lr_RegCajasConectoresCobert.NUM_PUERTOS_DISPONIBLES);
          APEX_JSON.close_object; -- } infoCajaConectorFactibilidad
          Ln_IndxCajasConectoresCobert  := Lt_TRegsCajasConectoresCobert.NEXT(Ln_IndxCajasConectoresCobert);
        END LOOP;
      END IF;
      APEX_JSON.close_array; -- ] infoCajasConectores
    ELSE
      APEX_JSON.write('existeCobertura', '');
      APEX_JSON.write('existeFactibilidad', '');
      APEX_JSON.open_array('infoCajasConectores'); -- infoCajasConectores: [
      APEX_JSON.close_array; -- ] infoCajasConectores
    END IF;
    APEX_JSON.close_object; -- }
    Lcl_JsonResponse    := apex_json.get_clob_output;
    APEX_JSON.free_output;
    Pv_Status           := Lv_Status;
    Pv_Mensaje          := Lv_Mensaje;
    Pcl_JsonResponse    := Lcl_JsonResponse;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status           := 'ERROR';
    Pv_Mensaje          := Lv_Mensaje;
    Pcl_JsonResponse    := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_INFO_PREFACTIBILIDAD', 
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Lv_Mensaje          := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje          := 'No se ha podido realizar correctamente la consulta. Por favor consultar con Sistemas!';
    Pcl_JsonResponse    := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_INFO_PREFACTIBILIDAD',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTIENE_INFO_PREFACTIBILIDAD;

END INKG_FACTIB_CONNECTIV_CONSULTA;
/
