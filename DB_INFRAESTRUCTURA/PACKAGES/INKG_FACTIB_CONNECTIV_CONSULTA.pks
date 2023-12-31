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

  /*
  * Documentación para TYPE 'Lr_InfoCajaConectorFact'.
  *
  * Tipo de datos para el retorno de la información correspondiente a la cobertura
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 05-08-2022
  */
  TYPE Lr_InfoCajaConectorFact IS RECORD
  (
    ID_CAJA                     DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_CAJA                 DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    ESTADO_CAJA                 DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO%TYPE,
    ID_CONECTOR                 DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
    NOMBRE_CONECTOR             DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
    ESTADO_CONECTOR             DB_INFRAESTRUCTURA.INFO_ELEMENTO.ESTADO%TYPE,
    LATITUD_CAJA                NUMBER,
    LONGITUD_CAJA               NUMBER,
    DISTANCIA                   NUMBER,
    NUM_PUERTOS_DISPONIBLES     NUMBER,
    NOMBRE_INTERFACE_ELEMENTO   DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.NOMBRE_INTERFACE_ELEMENTO%TYPE,
    ID_INTERFACE_ELEMENTO       DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO.ID_INTERFACE_ELEMENTO%TYPE

  );

  /*
  * Documentación para TYPE 'Lt_InfoCajaConectorFact'.
  *
  * Tabla para almacenar la data enviada con la información correspondiente a la cobertura
  *
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 05-08-2022
  */
  TYPE Lt_InfoCajaConectorFact
  IS
    TABLE OF Lr_InfoCajaConectorFact INDEX BY PLS_INTEGER;  


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

  /**
   * P_OBTIENE_DATOS_FACTIBILIDAD
   * Procedimiento que obtiene la respuesta en formato json de la consulta de factibilidad
   *
   * @param  Pcl_JsonRequest    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pcl_JsonResponse   OUT CLOB Respuesta en formato json de la consulta
   *
   * @author Antonio Ayala <afayala@telconet.ec>
   * @version 1.0 14-07-2022
   *
   * @author Steven Ruano <sruano@telconet.ec>
   * @version 1.1 21-11-2022
   *
   * @author Steven Ruano <sruano@telconet.ec>
   * @version 1.2 20-12-2022  Se realizo el insert en la info servicio historial
   *
   * @author Antonio Ayala <afayala@telconet.ec>
   * @version 1.3 30-01-2023  Se valida que si no hay respuesta del servidor de Arcgis
   *                          debe ir a la función de la factibilidad lineal
   *
   * @author Emmanuel Martillo <emartillo@telconet.ec>
   * @version 1.4 13-02-2023  Se agrega bandera de Prefijo Empresa EN para Ecuanet.
   *
   * @author Steven Ruano <sruano@telconet.ec>
   * @version 1.5 31-03-2023  Se agrega variable para verificar que el proceso pasa por
   *                          Nuevo Algoritmo Factiblidad o Factbilidad Lineal
   *
   * @author Steven Ruano <sruano@telconet.ec>
   * @version 1.6 03-05-2023  1.- Se agrega cursor para bandera de obtener Canton_Id y se envia al procedimiento
   *                          DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTENER_LISTADO_FACTIBLIDAD
   *                          el valor de la bandera y el id_servicio.
   *                          2.- Quitar el while de la respuesta para que sea mas rapida y bajando el costo de ejecucion
   *                          del paquete.
   *
   * @author Steven Ruano <sruano@telconet.ec>
   * @version 1.7 19-05-2023  Se corrige el error del id de la caja incorrecta al generar la respuesta
   *                          de los datos de factibilidad.    
   *
   */
  PROCEDURE P_OBTIENE_DATOS_FACTIBILIDAD(
    Pcl_JsonRequest     IN CLOB,
    Pv_Status           OUT VARCHAR2,
    Pv_Mensaje          OUT VARCHAR2,
    Pcl_JsonResponse    OUT CLOB); 

  /**
   * P_OBTIENE_LISTADO_FACTIBILIDAD
   * Función que obtiene la información de cobertura de acuerdo a los parámetros enviados en el json
   *
   * @param  Pcl_JsonRequest    IN CLOB Parámetros por los cuáles se realizará la consulta
   * @param  Pv_Status          OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje         OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Prf_Registros      OUT SYS_REFCURSOR Cursor con los registros de la consulta
   *
   * @author Antonio Ayala <afayala@telconet.ec>
   * @version 1.0 14-07-2022
   *
   * @author Steven Ruano <sruano@telconet.ec>
   * @version 1.1 20-12-2022  Agregar validacion para factilibdad de servicios de GPON_MPLS
   *
   * @author Emmanuel Martillo <emartillo@telconet.ec>
   * @version 1.2 13-02-2023  Se agrega Prefijo Empresa EN para Ecuanet y validacion para
   *                          obtener el listado de factibilidad de Megadatos.
   *
   * @author Steven Ruano <sruano@telconet.ec>
   * @version 1.3 03-05-2023  Se agrega validacion por canton id para agilizar la respuesta de factbilidad
   *                          y reducir los costos.
   *
   */
  PROCEDURE P_OBTIENE_LISTADO_FACTIBILIDAD(
    Pcl_JsonRequest IN CLOB,
    Pv_Status       OUT VARCHAR2,
    Pv_Mensaje      OUT VARCHAR2,
    Prf_Registros   OUT SYS_REFCURSOR);  

  /**
   * P_FACTIBILIDAD_LINEAL
   * Procedimiento que obtiene la respuesta en formato json de la consulta de factibilidad
   *
   * @param  Pt_TRegsCajasConectoresFactib   IN DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConectorFact
   *                                                   Parámetros por los cuáles se realizará la consulta
   * @param  Pn_IndxCajasConectoresFactib    IN NUMBER Parámetros por los cuáles se realizará la consulta
   * @param  Pv_PrefijoEmpresa               IN VARCHAR2 Prefijo de la empresa
   * @param  Pv_Status                       OUT VARCHAR2 Estado del procedimiento
   * @param  Pv_Mensaje                      OUT VARCHAR2 Mensaje de error del procedimiento
   * @param  Pcl_JsonReturn                  OUT CLOB Respuesta en formato json de la consulta
   *
   * @author Antonio Ayala <afayala@telconet.ec>
   * @version 1.0 08-08-2022
   * 
   * @author Steven Ruano <sruano@telconet.ec>
   * @version 1.1 31-03-2023  Se agrega variable para verificar que el proceso pasa por
   *                          Nuevo Algoritmo Factiblidad o Factbilidad Lineal.
   *
   */
  PROCEDURE P_FACTIBILIDAD_LINEAL(
    Pt_TRegsCajasConectoresFactib   IN DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConectorFact,
    Pn_IndxCajasConectoresFactib    IN NUMBER,
    Pv_PrefijoEmpresa               IN VARCHAR2,
    Pv_Status                       OUT VARCHAR2,
    Pv_Mensaje                      OUT VARCHAR2,
    Pcl_JsonReturn                  OUT CLOB);

END INKG_FACTIB_CONNECTIV_CONSULTA;
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
    Lcl_JsonResponse                VARCHAR2(4000);--CLOB;
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

  PROCEDURE P_OBTIENE_DATOS_FACTIBILIDAD(
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
    Lv_NombreParamCalculo           VARCHAR2(22) := 'URL_CALCULO_DISTANCIA';
    Lv_ParamValidaCanton            VARCHAR2(40) := 'VALIDACION_CANTON_ID_CAJAS';
    Lv_Valor1InfoDetParam           VARCHAR2(300);
    Lv_Valor2InfoDetParam           VARCHAR2(100);
    Lv_Valor3InfoDetParam           VARCHAR2(100);
    Lv_ValidaCantonValor            VARCHAR2(200);

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

    CURSOR Lc_GetInfoDetParam(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      SELECT DET.VALOR1, DET.VALOR2,DET.VALOR3
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET  
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;

    CURSOR Lc_GetInfoDetParamCanton(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE)
    IS
      SELECT DET.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET  
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO             = Lv_EstadoActivo
      AND DET.ESTADO             = Lv_EstadoActivo;

    Lv_NombreParamGeneral           VARCHAR2(40) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ProcesoFactibilidad          VARCHAR2(24) := 'PROCESO_FACTIBILIDAD';
    Lv_ConfigResponse               VARCHAR2(16) := 'CONFIG_RESPONSE';
    Ln_DistanciaMaxCobertura        NUMBER;
    Ln_DistanciaMaxFactibilidad     NUMBER;
    Ln_NumMaxCajasConectoresCobert  NUMBER;
    Ln_ContCajasConectoresCobert    NUMBER;
    Ln_IndxCajasConectoresCobert    NUMBER;
    Lr_RegCajasConectoresCobert     DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lr_InfoCajaConectorFact;
    Lt_TRegsCajasConectoresCobert   DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConectorFact;
    Ln_NumMaxCajasConectoresFactib  NUMBER;
    Ln_ContCajasConectoresFactib    NUMBER;
    Ln_IndxCajasConectoresFactib    NUMBER;
    Lr_RegCajasConectoresFactib     DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lr_InfoCajaConectorFact;
    Lt_TRegsCajasConectoresFactib   DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConectorFact;
    Lcl_JsonFiltrosCobertura        CLOB;
    Ln_IndxRegListadoCobertura      NUMBER;
    Lr_RegListadoCobertura          DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lr_InfoCajaConectorFact;
    Lt_TRegsListadoCobertura        DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConectorFact;
    Lv_Login                        DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE;
    Lr_ServicioHistorial            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lrf_RegistrosListadoCobertura   SYS_REFCURSOR;
    Lcl_JsonFiltrosBusqueda         CLOB;
    Ln_Latitud                      NUMBER;
    Ln_Longitud                     NUMBER;
    Ln_Longitud_login               NUMBER;
    Ln_Latitud_login                NUMBER;
    Ln_Latitud_caja                 NUMBER;
    Ln_Longitud_caja                NUMBER;
    Lv_DependeDeEdificio            VARCHAR2(2);
    Lv_CodEmpresa                   VARCHAR2(2);
    Lv_PrefijoEmpresa               VARCHAR2(5);
    Lv_ContinuaLoopCobertura        VARCHAR2(2) := 'SI';
    Lv_ExisteCobertura              VARCHAR2(2) := 'NO';
    Lv_ExisteFactibilidad           VARCHAR2(2) := 'NO';
    Lcl_JsonResponse                CLOB;
    Lcl_JsonReturn                  CLOB;
    Lv_Status                       VARCHAR2(5);
    Lv_Mensaje                      VARCHAR2(4000);
    Le_Exception                    EXCEPTION;
    Le_FactLineal                   EXCEPTION;
    Ln_IdCaja                       NUMBER;
    Lv_NombreCaja                   VARCHAR2(4000);
    Lv_NombreCajaFinal              VARCHAR2(4000);
    Ln_DistanciaCaja                NUMBER;
    Lv_rensponse                    CLOB;
    Lv_url                          VARCHAR2(3000);
    Lv_req                          utl_http.req;
    Lv_res                          utl_http.resp;
    Ln_DistanciaMetrosCaja          NUMBER := 0; 
    Ln_DistanciaInicial             NUMBER := 0;
    Ln_DistanciaFinal               NUMBER := 0;
    Lv_response                     CLOB;
    Lb_booleanTipoRedGpon           BOOLEAN;
    Lv_IpCreacion                   VARCHAR2(9) := '127.0.0.1';
    Ln_IdServicio                   NUMBER;
    Ln_IdCajaFinal                  NUMBER;
    Ln_IdCajaInicial                NUMBER;  
    Lv_EstadoCaja                   VARCHAR2(20);
    Ln_IdConector                   NUMBER;
    Lv_NombreConector               VARCHAR2(4000);
    Lv_EstadoConector               VARCHAR2(20);
    Ln_IdInterfaceElemento          NUMBER;
    Lv_NombreInterfaceElemento      VARCHAR2(4000);
    Lv_EstadoCajaFinal              VARCHAR2(20);
    Ln_IdConectorFinal              NUMBER;
    Lv_NombreConectorFinal          VARCHAR2(4000);
    Lv_EstadoConectorFinal          VARCHAR2(20);              
    Ln_IdServicioFinal              NUMBER;
    Ln_IdInterfaceElementoFinal     NUMBER;
    Lv_NombreInterfaceElemFinal     VARCHAR2(5000);

  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonRequest;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Ln_Latitud                  := TRIM(APEX_JSON.GET_NUMBER(p_path => 'latitud'));
    Ln_Longitud                 := TRIM(APEX_JSON.GET_NUMBER(p_path => 'longitud'));
    Lv_DependeDeEdificio        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'dependeDeEdificio'));
    Lv_CodEmpresa               := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'idEmpresa'));
    Lv_PrefijoEmpresa           := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'prefijoEmpresa'));
    Lv_Login                    := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'strLogin'));
    Lb_booleanTipoRedGpon       := APEX_JSON.GET_BOOLEAN(p_path => 'booleanTipoRedGpon');
    Ln_IdServicio               := TRIM(APEX_JSON.GET_NUMBER(p_path => 'intIdServicio'));
    Ln_IdCaja                   := 0;
    Ln_DistanciaCaja            := 0;

    OPEN Lc_GetInfoDetParam(Lv_NombreParamCalculo);
    FETCH Lc_GetInfoDetParam INTO Lv_Valor1InfoDetParam, Lv_Valor2InfoDetParam, Lv_Valor3InfoDetParam;
    CLOSE Lc_GetInfoDetParam;

    IF Lv_PrefijoEmpresa IS NULL OR Lv_CodEmpresa IS NULL THEN
      Lv_Mensaje := 'No se han enviado los parámetros obligatorios referentes a la empresa';
      RAISE Le_Exception;
    END IF;

    Lv_NombreParamGeneral := Lv_NombreParamGeneral || Lv_PrefijoEmpresa;
    IF Lc_GetInfoParamsConfigResponse%ISOPEN THEN
    CLOSE Lc_GetInfoParamsConfigResponse;
    END IF;

    OPEN Lc_GetInfoParamsConfigResponse(Lv_NombreParamGeneral, Lv_ProcesoFactibilidad, Lv_ConfigResponse, Lv_CodEmpresa);
    FETCH Lc_GetInfoParamsConfigResponse INTO Ln_DistanciaMaxCobertura, Ln_DistanciaMaxFactibilidad, 
                                              Ln_NumMaxCajasConectoresCobert, Ln_NumMaxCajasConectoresFactib;
    CLOSE Lc_GetInfoParamsConfigResponse;

    OPEN Lc_GetInfoDetParamCanton(Lv_ParamValidaCanton);
    FETCH Lc_GetInfoDetParamCanton INTO Lv_ValidaCantonValor;
    CLOSE Lc_GetInfoDetParamCanton;    

    IF (Ln_DistanciaMaxCobertura IS NULL OR Ln_DistanciaMaxFactibilidad IS NULL 
        OR Ln_NumMaxCajasConectoresCobert IS NULL) THEN
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
    APEX_JSON.write('booleanTipoRedGpon', Lb_booleanTipoRedGpon);
    APEX_JSON.write('validarCanton', Lv_ValidaCantonValor);
    APEX_JSON.write('idServicio', Ln_IdServicio);
    APEX_JSON.close_object; -- }
    Lcl_JsonFiltrosCobertura    := APEX_JSON.get_clob_output;
    APEX_JSON.free_output;
    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object; -- {
    DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_LISTADO_FACTIBILIDAD(  Lcl_JsonFiltrosCobertura,
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
          IF Lv_PrefijoEmpresa = 'MD'   OR Lv_PrefijoEmpresa = 'EN' THEN
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
            END IF;
          END IF;
          Ln_IdCaja := Lr_RegListadoCobertura.ID_CAJA;
          Ln_IndxRegListadoCobertura  := Lt_TRegsListadoCobertura.NEXT(Ln_IndxRegListadoCobertura);
        END LOOP;
        EXIT
      WHEN Lrf_RegistrosListadoCobertura%NOTFOUND;
      END LOOP;

      CLOSE Lrf_RegistrosListadoCobertura;
      Ln_ContCajasConectoresFactib := 0;
      APEX_JSON.open_object('data'); -- data {
      APEX_JSON.write('login', Lv_Login);
      APEX_JSON.write('logintud', Ln_Longitud);
      APEX_JSON.write('latitud', Ln_Latitud);
      APEX_JSON.open_array('infoCajasConectores'); -- infoCajasConectores: [
      IF Lv_ExisteFactibilidad = 'SI' THEN
        Ln_IndxCajasConectoresFactib :=  Lt_TRegsCajasConectoresFactib.FIRST;
        WHILE (Ln_IndxCajasConectoresFactib IS NOT NULL)
        LOOP
          Lr_RegCajasConectoresFactib   := Lt_TRegsCajasConectoresFactib(Ln_IndxCajasConectoresFactib);

          Lv_NombreCaja              := Lr_RegCajasConectoresFactib.NOMBRE_CAJA;
          Ln_Longitud_login          := Ln_Longitud;
          Ln_Latitud_login           := Ln_Latitud;
          Ln_Longitud_caja           := Lr_RegCajasConectoresFactib.LONGITUD_CAJA;
          Ln_Latitud_caja            := Lr_RegCajasConectoresFactib.LATITUD_CAJA;
          Ln_IdCajaInicial           := Lr_RegCajasConectoresFactib.ID_CAJA; 
          Lv_EstadoCaja              := Lr_RegCajasConectoresFactib.ESTADO_CAJA;
          Ln_IdConector              := Lr_RegCajasConectoresFactib.ID_CONECTOR;
          Lv_NombreConector          := Lr_RegCajasConectoresFactib.NOMBRE_CONECTOR;
          Lv_EstadoConector          := Lr_RegCajasConectoresFactib.ESTADO_CONECTOR;
          Ln_IdInterfaceElemento     := Lr_RegCajasConectoresFactib.ID_INTERFACE_ELEMENTO;
          Lv_NombreInterfaceElemento := Lr_RegCajasConectoresFactib.NOMBRE_INTERFACE_ELEMENTO;

          APEX_JSON.open_object; -- {
          APEX_JSON.write('nombreCaja', Lr_RegCajasConectoresFactib.NOMBRE_CAJA);
          APEX_JSON.write('longitud', Lr_RegCajasConectoresFactib.LONGITUD_CAJA);
          APEX_JSON.write('latitud', Lr_RegCajasConectoresFactib.LATITUD_CAJA);
          APEX_JSON.close_object; -- } infoCajaConectorFactibilidad

          Lv_url := Lv_Valor1InfoDetParam || Lv_Valor2InfoDetParam || Lv_Valor3InfoDetParam || REPLACE( Ln_Longitud_login, ',', '.') || ',' || REPLACE( Ln_Latitud_login , ',', '.') || ';' || REPLACE(Ln_Longitud_caja, ',', '.') || ',' || REPLACE(Ln_Latitud_caja, ',', '.');  

          Lv_req := UTL_HTTP.BEGIN_REQUEST(Lv_url, 'GET', 'HTTP/1.1'); 
          UTL_HTTP.SET_HEADER(Lv_req, 'user-agent', 'mozilla/4.0');
          UTL_HTTP.SET_HEADER(Lv_req, 'content-type', 'application/json');
          Lv_res := UTL_HTTP.GET_RESPONSE(Lv_req);

          UTL_HTTP.READ_TEXT(Lv_res, Lv_response); 

          UTL_HTTP.END_RESPONSE(Lv_res);

          APEX_JSON.PARSE(Lv_response);

          Ln_DistanciaMetrosCaja   := APEX_JSON.GET_NUMBER(p_path=>'routes.features[%d].attributes.Total_Length',p0=> 1);

          IF Ln_DistanciaInicial = 0  THEN
            Ln_DistanciaInicial              := Ln_DistanciaMetrosCaja;
            Ln_DistanciaFinal                := Ln_DistanciaInicial;
            Lv_NombreCajaFinal               := Lv_NombreCaja;
            Ln_IdCajaFinal                   := Ln_IdCajaInicial; 
            Lv_EstadoCajaFinal               := Lv_EstadoCaja;
            Ln_IdConectorFinal               := Ln_IdConector;
            Lv_NombreConectorFinal           := Lv_NombreConector;
            Lv_EstadoConectorFinal           := Lv_EstadoConector;
            Ln_IdInterfaceElementoFinal      := Ln_IdInterfaceElemento;
            Lv_NombreInterfaceElemFinal      := Lv_NombreInterfaceElemento;
            Ln_IdServicioFinal               := Ln_IdServicio; 
          ELSE
            IF Ln_DistanciaMetrosCaja < Ln_DistanciaFinal THEN
              Ln_IdCajaFinal                   := Ln_IdCajaInicial; 
              Lv_EstadoCajaFinal               := Lv_EstadoCaja;
              Ln_IdConectorFinal               := Ln_IdConector;
              Lv_NombreConectorFinal           := Lv_NombreConector;
              Lv_EstadoConectorFinal           := Lv_EstadoConector;
              Ln_IdInterfaceElementoFinal      := Ln_IdInterfaceElemento;
              Lv_NombreInterfaceElemFinal      := Lv_NombreInterfaceElemento;
              Ln_IdServicioFinal               := Ln_IdServicio;
              Ln_DistanciaFinal                := Ln_DistanciaMetrosCaja;
              Lv_NombreCajaFinal               := Lv_NombreCaja;
            END IF;
          END IF;

          Ln_IndxCajasConectoresFactib  := Lt_TRegsCajasConectoresFactib.NEXT(Ln_IndxCajasConectoresFactib);

        END LOOP;
      ELSIF Lv_ExisteCobertura = 'SI' THEN
        Ln_IndxCajasConectoresCobert :=  Lt_TRegsCajasConectoresCobert.FIRST;
        WHILE (Ln_IndxCajasConectoresCobert IS NOT NULL)
        LOOP
          Lr_RegCajasConectoresCobert   := Lt_TRegsCajasConectoresCobert(Ln_IndxCajasConectoresCobert);

          Lv_NombreCaja                 := Lr_RegCajasConectoresCobert.NOMBRE_CAJA;
          Ln_IdCajaInicial              := Lr_RegCajasConectoresCobert.ID_CAJA; 
          Lv_EstadoCaja                 := Lr_RegCajasConectoresCobert.ESTADO_CAJA;
          Ln_IdConector                 := Lr_RegCajasConectoresCobert.ID_CONECTOR;
          Lv_NombreConector             := Lr_RegCajasConectoresCobert.NOMBRE_CONECTOR;
          Lv_EstadoConector             := Lr_RegCajasConectoresCobert.ESTADO_CONECTOR;
          Ln_IdInterfaceElemento        := Lr_RegCajasConectoresCobert.ID_INTERFACE_ELEMENTO;
          Lv_NombreInterfaceElemento    := Lr_RegCajasConectoresCobert.NOMBRE_INTERFACE_ELEMENTO;
          Ln_Longitud_login             := Ln_Longitud;
          Ln_Latitud_login              := Ln_Latitud;
          Ln_Longitud_caja              := Lr_RegCajasConectoresCobert.LONGITUD_CAJA;
          Ln_Latitud_caja               := Lr_RegCajasConectoresCobert.LATITUD_CAJA;

          APEX_JSON.open_object; -- {
          APEX_JSON.write('nombreCaja', Lr_RegCajasConectoresCobert.NOMBRE_CAJA);
          APEX_JSON.write('longitud', Lr_RegCajasConectoresCobert.LONGITUD_CAJA);
          APEX_JSON.write('latitud', Lr_RegCajasConectoresCobert.LATITUD_CAJA);
          APEX_JSON.close_object; -- } infoCajaConectorFactibilidad

          Lv_url := Lv_Valor1InfoDetParam || Lv_Valor2InfoDetParam || Lv_Valor3InfoDetParam || REPLACE( Ln_Longitud, ',', '.') || ',' || REPLACE( Ln_Latitud , ',', '.') || ';' || REPLACE(Ln_Longitud_caja, ',', '.') || ',' || REPLACE(Ln_Latitud_caja, ',', '.');


          Lv_req := utl_http.begin_request(Lv_url, 'GET', 'HTTP/1.1'); 
          utl_http.set_header(Lv_req, 'user-agent', 'mozilla/4.0');
          utl_http.set_header(Lv_req, 'content-type', 'application/json');
          Lv_res := utl_http.get_response(Lv_req);

          UTL_HTTP.read_text(Lv_res, Lv_response);

          UTL_HTTP.END_RESPONSE(Lv_res);

          APEX_JSON.PARSE(Lv_response);

          Ln_DistanciaMetrosCaja   := APEX_JSON.GET_NUMBER(p_path=>'routes.features[%d].attributes.Total_Length',p0=> 1);

         IF Ln_DistanciaInicial = 0  THEN
            Ln_DistanciaInicial              := Ln_DistanciaMetrosCaja;
            Ln_DistanciaFinal                := Ln_DistanciaInicial;
            Lv_NombreCajaFinal               := Lv_NombreCaja;
            Ln_IdCajaFinal                   := Ln_IdCajaInicial; 
            Lv_EstadoCajaFinal               := Lv_EstadoCaja;
            Ln_IdConectorFinal               := Ln_IdConector;
            Lv_NombreConectorFinal           := Lv_NombreConector;
            Lv_EstadoConectorFinal           := Lv_EstadoConector;
            Ln_IdInterfaceElementoFinal      := Ln_IdInterfaceElemento;
            Lv_NombreInterfaceElemFinal      := Lv_NombreInterfaceElemento;
            Ln_IdServicioFinal               := Ln_IdServicio;

          ELSE
            IF Ln_DistanciaMetrosCaja < Ln_DistanciaFinal THEN
              Ln_IdCajaFinal                   := Ln_IdCajaInicial; 
              Lv_EstadoCajaFinal               := Lv_EstadoCaja;
              Ln_IdConectorFinal               := Ln_IdConector;
              Lv_NombreConectorFinal           := Lv_NombreConector;
              Lv_EstadoConectorFinal           := Lv_EstadoConector;
              Ln_IdInterfaceElementoFinal      := Ln_IdInterfaceElemento;
              Lv_NombreInterfaceElemFinal      := Lv_NombreInterfaceElemento;
              Ln_IdServicioFinal               := Ln_IdServicio;
              Ln_DistanciaFinal                := Ln_DistanciaMetrosCaja;
              Lv_NombreCajaFinal               := Lv_NombreCaja;
            END IF;
          END IF;

          Ln_IndxCajasConectoresCobert  := Lt_TRegsCajasConectoresCobert.NEXT(Ln_IndxCajasConectoresCobert);
        END LOOP;
      END IF;
      APEX_JSON.close_array; -- ] infoCajasConectores
      APEX_JSON.close_object; -- }
    ELSE
      APEX_JSON.open_object('data'); -- data {
      APEX_JSON.write('login', '');
      APEX_JSON.write('logintud', '');
      APEX_JSON.write('latitud', '');
      APEX_JSON.open_array('infoCajasConectores'); -- infoCajasConectores: [
      APEX_JSON.close_array; -- ] infoCajasConectores
      APEX_JSON.close_object; -- }
    END IF;
    APEX_JSON.close_object; -- }

    Lcl_JsonResponse    := apex_json.get_clob_output;

    APEX_JSON.free_output;

    -- CONVERITR EN JSON EL CLOB OUTPUT Y OBTENER LAS LONGITUDES Y LATITUDES DE LAS CAJAS PARA EL CALCULO DE LA FACTIBILIDAD
    APEX_JSON.PARSE(Lcl_JsonResponse);

    Ln_ContCajasConectoresFactib := APEX_JSON.GET_COUNT(p_path => 'data.infoCajasConectores');

    Pv_Status           := Lv_Status;
    Pv_Mensaje          := Lv_Mensaje;

      --si no tiene valores en distancia final
      IF Ln_DistanciaFinal = 0 OR Ln_DistanciaFinal IS NULL THEN
        RAISE Le_FactLineal;
      END IF;

      -- Si existe respuesta por el webservice de ARCGIS se envia los datos de la caja seleccionada
      APEX_JSON.initialize_clob_output;
      APEX_JSON.open_object; -- {
      APEX_JSON.write('idCaja', Ln_IdCajaFinal);
      APEX_JSON.write('nombreCaja', Lv_NombreCajaFinal);
      APEX_JSON.write('estadoCaja', Lv_EstadoCajaFinal);
      APEX_JSON.write('idElementoConector', Ln_IdConectorFinal);
      APEX_JSON.write('nombreElementoConector', Lv_NombreConectorFinal);
      APEX_JSON.write('estadoElementoConector', Lv_EstadoConectorFinal);
      APEX_JSON.write('idInterfaceElementoConector', Ln_IdInterfaceElementoFinal);
      APEX_JSON.write('idServicio', Ln_IdServicioFinal);
      APEX_JSON.write('nombreInterfaceElementoConector', Lv_NombreInterfaceElemFinal);
      APEX_JSON.write('distancia', Ln_DistanciaFinal);
      APEX_JSON.write('pasaNuevoAlgoritmo', 'SI');
      APEX_JSON.close_object; -- }
      Lcl_JsonReturn    := apex_json.get_clob_output;
      APEX_JSON.free_output;

      IF Lv_Mensaje IS NOT NULL THEN
          RAISE Le_Exception;
      END IF;

      Pcl_JsonResponse    := Lcl_JsonReturn;

  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status           := 'ERROR';
    Pv_Mensaje          := Lv_Mensaje;
    Pcl_JsonResponse    := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_DATOS_FACTIBILIDAD', 
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN Le_FactLineal THEN
    -- Se llama al procedimiento donde recorre el arreglo de la consulta
    DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.P_FACTIBILIDAD_LINEAL(  Lt_TRegsCajasConectoresFactib,
                                                                                    Ln_IndxCajasConectoresFactib,
                                                                                    Lv_PrefijoEmpresa,
                                                                                    Lv_Status,
                                                                                    Lv_Mensaje,
                                                                                    Lcl_JsonReturn);

    Pcl_JsonResponse    := Lcl_JsonReturn;
  WHEN OTHERS THEN
    Pv_Status           := 'ERROR';
    Lv_Mensaje          := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje          := 'No se ha podido realizar correctamente la consulta. Por favor consultar con Sistemas!';
    Pcl_JsonResponse    := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_DATOS_FACTIBILIDAD',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.P_FACTIBILIDAD_LINEAL(  Lt_TRegsCajasConectoresFactib,
                                                                                    Ln_IndxCajasConectoresFactib,
                                                                                    Lv_PrefijoEmpresa,
                                                                                    Lv_Status,
                                                                                    Lv_Mensaje,
                                                                                    Lcl_JsonReturn);

    Pcl_JsonResponse    := Lcl_JsonReturn;
    Pv_Status           := Lv_Status;
    Pv_Mensaje          := Lv_Mensaje;  

  END P_OBTIENE_DATOS_FACTIBILIDAD;

  PROCEDURE P_OBTIENE_LISTADO_FACTIBILIDAD(
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

    CURSOR Lc_GetCantonId(Cv_ServicioId DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT CANTON.ID_CANTON
      FROM DB_COMERCIAL.INFO_PUNTO PUNTO
      INNER JOIN DB_GENERAL.ADMI_SECTOR SECTOR
      ON SECTOR.ID_SECTOR = PUNTO.SECTOR_ID
      INNER JOIN DB_GENERAL.ADMI_PARROQUIA PARROQUIA
      ON PARROQUIA.ID_PARROQUIA = SECTOR.PARROQUIA_ID
      INNER JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
      ON PUNTO.ID_PUNTO =SERVICIO.PUNTO_ID
      INNER JOIN DB_GENERAL.ADMI_CANTON CANTON
      ON CANTON.ID_CANTON = PARROQUIA.CANTON_ID
      WHERE ID_SERVICIO   = Cv_ServicioId;

    Lv_NombreParamGeneral           VARCHAR2(40) := 'PARAMETROS_ASOCIADOS_A_SERVICIOS_';
    Lv_ProcesoFactibilidad          VARCHAR2(24) := 'PROCESO_FACTIBILIDAD';
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
    Lb_booleanTipoRedGpon           BOOLEAN;
    Ln_IdCanton                     NUMBER;
    Ln_ServicioId                   NUMBER;
    Lv_ValidacionCanton             VARCHAR2(200);

  BEGIN
    Lcl_JsonFiltrosBusqueda := Pcl_JsonRequest;
    APEX_JSON.PARSE(Lcl_JsonFiltrosBusqueda);
    Lv_Latitud                  := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'latitud'));
    Lv_Longitud                 := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'longitud'));
    Lb_booleanTipoRedGpon       := APEX_JSON.GET_BOOLEAN(p_path => 'booleanTipoRedGpon');
    Lv_DependeDeEdificio        := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'dependeDeEdificio'));
    Lv_CodEmpresa               := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'idEmpresa'));
    Lv_PrefijoEmpresa           := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'prefijoEmpresa'));
    Ln_DistanciaMaxCobertura    := TRIM(APEX_JSON.GET_NUMBER(p_path => 'distanciaMaxCobertura'));
    Lv_ValidacionCanton         := TRIM(APEX_JSON.GET_VARCHAR2(p_path => 'validarCanton'));
    Ln_ServicioId               := TRIM(APEX_JSON.GET_NUMBER(p_path => 'idServicio'));

    IF Lv_PrefijoEmpresa IS NULL OR Lv_CodEmpresa IS NULL THEN
      Lv_Mensaje := 'No se han enviado los parámetros obligatorios referentes a la empresa';
      RAISE Le_Exception;
    END IF;

    Lv_NombreParamGeneral := Lv_NombreParamGeneral || Lv_PrefijoEmpresa;
    IF Lc_GetInfoParams%ISOPEN THEN
    CLOSE Lc_GetInfoParams;
    END IF;

    OPEN Lc_GetInfoParams(Lv_NombreParamGeneral, Lv_ProcesoFactibilidad, Lv_ParamsConsulta, Lv_CodEmpresa);
    FETCH Lc_GetInfoParams INTO Lv_TipoElementoConector, Lv_Valor4ParamsConsulta, Lv_Valor5ParamsConsulta;
    CLOSE Lc_GetInfoParams;

    OPEN Lc_GetCantonId(Ln_ServicioId);
    FETCH Lc_GetCantonId INTO Ln_IdCanton;
    CLOSE Lc_GetCantonId;

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

    IF Lv_PrefijoEmpresa = 'EN' THEN
      Lv_CodEmpresa:= 18;
    END IF;

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
                        ), 0) AS NUM_PUERTOS_DISPONIBLES,
                       (SELECT INTERFACE_CONECTOR.NOMBRE_INTERFACE_ELEMENTO
                            FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_CONECTOR
                            WHERE INTERFACE_CONECTOR.ELEMENTO_ID = CONECTOR.ID_ELEMENTO
                            AND INTERFACE_CONECTOR.ESTADO = ''' || Lv_ValorNotConnect || ''' 
                            AND INTERFACE_CONECTOR.NOMBRE_INTERFACE_ELEMENTO NOT LIKE ''' || Lv_ValorInterfaceNotLikeIn || ''' 
                            AND ROWNUM = 1) AS NOMBRE_INTERFACE_ELEMENTO,
                        (SELECT INTERFACE_CONECTOR.ID_INTERFACE_ELEMENTO
                            FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_CONECTOR
                            WHERE INTERFACE_CONECTOR.ELEMENTO_ID = CONECTOR.ID_ELEMENTO
                            AND INTERFACE_CONECTOR.ESTADO = ''' || Lv_ValorNotConnect || ''' 
                            AND INTERFACE_CONECTOR.NOMBRE_INTERFACE_ELEMENTO NOT LIKE ''' || Lv_ValorInterfaceNotLikeIn || ''' 
                            AND ROWNUM = 1) AS ID_INTERFACE_ELEMENTO ';
    Lcl_From        := 'FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO REL_CAJA_CONECTOR
                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CAJA
                        ON REL_CAJA_CONECTOR.ELEMENTO_ID_A = CAJA.ID_ELEMENTO
                        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_CAJA
                        ON MODELO_CAJA.ID_MODELO_ELEMENTO = CAJA.MODELO_ELEMENTO_ID
                        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_CAJA
                        ON TIPO_CAJA.ID_TIPO_ELEMENTO = MODELO_CAJA.TIPO_ELEMENTO_ID
                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA EMPRESA_CAJA_UBICA
                        ON EMPRESA_CAJA_UBICA.ELEMENTO_ID = CAJA.ID_ELEMENTO
                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_UBICACION UBICACION_CAJA
                        ON UBICACION_CAJA.ID_UBICACION = EMPRESA_CAJA_UBICA.UBICACION_ID
                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CONECTOR
                        ON CONECTOR.ID_ELEMENTO = REL_CAJA_CONECTOR.ELEMENTO_ID_B
                        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_CONECTOR
                        ON MODELO_CONECTOR.ID_MODELO_ELEMENTO = CONECTOR.MODELO_ELEMENTO_ID
                        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_CONECTOR
                        ON MODELO_CONECTOR.TIPO_ELEMENTO_ID = TIPO_CONECTOR.ID_TIPO_ELEMENTO ';
    Lcl_Where       := 'WHERE TIPO_CAJA.NOMBRE_TIPO_ELEMENTO = ''' || Lv_ValorCajaDispersion || ''' 
                        AND REL_CAJA_CONECTOR.ESTADO IN (''' || Lv_EstadoActivo || ''', ''' || Lv_ValorRestringido || ''' ) 
                        AND TIPO_CONECTOR.NOMBRE_TIPO_ELEMENTO = ''' || Lv_TipoElementoConector || ''' ';

    IF Lv_ValidacionCanton IS NOT NULL AND Lv_ValidacionCanton = 'SI' THEN
        Lcl_From := Lcl_From || ' LEFT JOIN DB_INFRAESTRUCTURA.ADMI_PARROQUIA PARROQUIA ON PARROQUIA.ID_PARROQUIA = UBICACION_CAJA.PARROQUIA_ID ';
        Lcl_Where := Lcl_Where || ' AND PARROQUIA.CANTON_ID = ' || Ln_IdCanton || ' ';--SETEAR ID CANTON DEL PUNTO
    END IF;

    IF Lv_PrefijoEmpresa = 'MD' OR Lv_PrefijoEmpresa = 'EN' THEN 
      Lcl_Join      := 'LEFT JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DETALLE_NIVEL_CAJA
                        ON DETALLE_NIVEL_CAJA.ELEMENTO_ID = CAJA.ID_ELEMENTO ';
      Lcl_Where     := Lcl_Where || 'AND CONECTOR.ESTADO <> ''' || Lv_ValorRestringido || ''' 
                                     AND EMPRESA_CAJA_UBICA.EMPRESA_COD = ''' || Lv_CodEmpresa || ''' 
                                     AND DETALLE_NIVEL_CAJA.DETALLE_NOMBRE = ''' || Lv_ValorDetalleNombreNivel || ''' 
                                     AND DETALLE_NIVEL_CAJA.DETALLE_VALOR = ''' || Lv_ValorDetalleValorNivel || ''' ';
      IF Lv_DependeDeEdificio <> 'S' THEN
        Lcl_Where   := Lcl_Where || 'AND CAJA.ID_ELEMENTO NOT IN
                                     (
                                        SELECT CAJA_EDIFICIO.ID_ELEMENTO
                                        FROM DB_INFRAESTRUCTURA.INFO_RELACION_ELEMENTO REL_EDIFICACION_CAJA
                                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO CAJA_EDIFICIO
                                        ON CAJA_EDIFICIO.ID_ELEMENTO = REL_EDIFICACION_CAJA.ELEMENTO_ID_B
                                        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_CAJA_EDIFICIO
                                        ON MODELO_CAJA_EDIFICIO.ID_MODELO_ELEMENTO = CAJA_EDIFICIO.MODELO_ELEMENTO_ID
                                        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_CAJA_EDIFICIO
                                        ON MODELO_CAJA_EDIFICIO.TIPO_ELEMENTO_ID = TIPO_CAJA_EDIFICIO.ID_TIPO_ELEMENTO
                                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA EMPRESA_CAJA_EDIFICIO_UBICA
                                        ON EMPRESA_CAJA_EDIFICIO_UBICA.ELEMENTO_ID = CAJA_EDIFICIO.ID_ELEMENTO
                                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_UBICACION UBICACION_CAJA_EDIFICIO
                                        ON UBICACION_CAJA_EDIFICIO.ID_UBICACION = EMPRESA_CAJA_EDIFICIO_UBICA.UBICACION_ID
                                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO EDIFICACION
                                        ON EDIFICACION.ID_ELEMENTO = REL_EDIFICACION_CAJA.ELEMENTO_ID_A
                                        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO_EDIFICACION
                                        ON MODELO_EDIFICACION.ID_MODELO_ELEMENTO = EDIFICACION.MODELO_ELEMENTO_ID
                                        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIPO_EDIFICACION
                                        ON TIPO_EDIFICACION.ID_TIPO_ELEMENTO = MODELO_EDIFICACION.TIPO_ELEMENTO_ID
                                        LEFT JOIN DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO DETALLE_NIVEL_CAJA_EDIFICACION
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
                              FROM (' || Lcl_Select || Lcl_From || Lcl_Join || Lcl_Where || ')';

    Lcl_ConsultaPrincipal:= 'SELECT  DISTINCT TBL.ID_CAJA ,
                                              TBL.NOMBRE_CAJA,
                                              TBL.ESTADO_CAJA,
                                              TBL.ID_CONECTOR ,
                                              TBL.NOMBRE_CONECTOR,
                                              TBL.ESTADO_CONECTOR,
                                              TBL.LATITUD_CAJA,
                                              TBL.LONGITUD_CAJA,
                                              TBL.DISTANCIA,
                                              TBL.NUM_PUERTOS_DISPONIBLES,
                                              TBL.NOMBRE_INTERFACE_ELEMENTO,
                                              TBL.ID_INTERFACE_ELEMENTO FROM ( ' || Lcl_ConsultaPrincipal || ' ) TBL WHERE TBL.NUM_PUERTOS_DISPONIBLES > 0';


    IF (Lv_PrefijoEmpresa = 'MD' OR Lv_PrefijoEmpresa = 'EN') AND Lb_booleanTipoRedGpon THEN  
        Lcl_ConsultaPrincipal := Lcl_ConsultaPrincipal || ' AND EXISTS (
            SELECT 1
            FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO INTERFACE_CONECTOR
            WHERE
            INTERFACE_CONECTOR.ID_INTERFACE_ELEMENTO = DB_INFRAESTRUCTURA.INFRK_DML.GET_ELEMENTO_FILTER_DETALLE(
                                                                TBL.ID_INTERFACE_ELEMENTO,
                                                                ''MISMO_ID'',
                                                                ''MULTIPLATAFORMA'',
                                                                ''SI'')
            AND ROWNUM = 1
        )';
    END IF;

    Lcl_ConsultaPrincipal := Lcl_ConsultaPrincipal || ' GROUP BY TBL.ID_CAJA,
                                                                 TBL.DISTANCIA,
                                                                 TBL.NOMBRE_CAJA,
                                                                 TBL.ESTADO_CAJA,
                                                                 TBL.ID_CONECTOR,
                                                                 TBL.NOMBRE_CONECTOR,
                                                                 TBL.ESTADO_CONECTOR,
                                                                 TBL.LATITUD_CAJA,
                                                                 TBL.LONGITUD_CAJA,
                                                                 TBL.NUM_PUERTOS_DISPONIBLES,
                                                                 TBL.NOMBRE_INTERFACE_ELEMENTO,
                                                                 TBL.ID_INTERFACE_ELEMENTO
                                                                 HAVING TBL.DISTANCIA <= '|| Ln_DistanciaMaxCobertura ||
                                                                ' order by TBL.DISTANCIA ASC';

    OPEN Prf_Registros FOR Lcl_ConsultaPrincipal;                         
    Pv_Status   := 'OK';
    Pv_Mensaje  := '';
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status       := 'ERROR';
    Pv_Mensaje      := Lv_Mensaje || '. Por favor consultar con Sistemas!';
    Prf_Registros   := NULL;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_LISTADO_FACTIBILIDAD', 
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
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_OBTIENE_LISTADO_FACTIBILIDAD',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_OBTIENE_LISTADO_FACTIBILIDAD;

  PROCEDURE P_FACTIBILIDAD_LINEAL(
    Pt_TRegsCajasConectoresFactib   IN DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConectorFact,
    Pn_IndxCajasConectoresFactib    IN NUMBER,
    Pv_PrefijoEmpresa               IN VARCHAR2,
    Pv_Status                       OUT VARCHAR2,
    Pv_Mensaje                      OUT VARCHAR2,
    Pcl_JsonReturn                  OUT CLOB)
  AS
    Lv_EstadoActivo                 VARCHAR2(6) := 'Activo';
    Le_Exception                    EXCEPTION;
    Lv_Mensaje                      VARCHAR2(4000);
    Ln_IndxCajasConectoresFactib    NUMBER;
    Lt_TRegsCajasConectoresFactib   DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lt_InfoCajaConectorFact;
    Lr_RegCajasConectoresFactib     DB_INFRAESTRUCTURA.INKG_FACTIB_CONNECTIV_CONSULTA.Lr_InfoCajaConectorFact;
    Lcl_JsonReturn                  CLOB;
    Ln_IdCaja                       NUMBER;
    Lv_NombreCaja                   VARCHAR2(4000);
    Ln_DistanciaCaja                NUMBER;
    Lv_EstadoCaja                   VARCHAR2(20);
    Ln_IdConector                   NUMBER;
    Lv_NombreConector               VARCHAR2(4000);
    Lv_EstadoConector               VARCHAR2(20);
    Ln_IdInterface                  NUMBER;
    Lv_NombreInterface              VARCHAR2(4000);

  BEGIN
    Ln_IndxCajasConectoresFactib  := Pn_IndxCajasConectoresFactib;
    Lt_TRegsCajasConectoresFactib := Pt_TRegsCajasConectoresFactib; 
    Ln_IndxCajasConectoresFactib :=  Lt_TRegsCajasConectoresFactib.FIRST;
    WHILE (Ln_IndxCajasConectoresFactib IS NOT NULL)
      LOOP
        Lr_RegCajasConectoresFactib   := Lt_TRegsCajasConectoresFactib(Ln_IndxCajasConectoresFactib);
        Ln_IdCaja          := Lr_RegCajasConectoresFactib.ID_CAJA;
        Lv_NombreCaja      := Lr_RegCajasConectoresFactib.NOMBRE_CAJA;
        Ln_DistanciaCaja   := Lr_RegCajasConectoresFactib.DISTANCIA;
        Lv_EstadoCaja      := Lr_RegCajasConectoresFactib.ESTADO_CAJA;
        Ln_IdConector      := Lr_RegCajasConectoresFactib.ID_CONECTOR;
        Lv_NombreConector  := Lr_RegCajasConectoresFactib.NOMBRE_CONECTOR;
        Lv_EstadoConector  := Lr_RegCajasConectoresFactib.ESTADO_CONECTOR;
        Ln_IdInterface     := Lr_RegCajasConectoresFactib.ID_INTERFACE_ELEMENTO;
        Lv_NombreInterface := Lr_RegCajasConectoresFactib.NOMBRE_INTERFACE_ELEMENTO;
        Ln_IndxCajasConectoresFactib  := Lt_TRegsCajasConectoresFactib.NEXT(Ln_IndxCajasConectoresFactib);
    END LOOP;

    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object; -- {
    APEX_JSON.write('idCaja', Ln_IdCaja);
    APEX_JSON.write('nombreCaja', Lv_NombreCaja);
    APEX_JSON.write('estadoCaja', Lv_EstadoCaja);
    APEX_JSON.write('idElementoConector', Ln_IdConector);
    APEX_JSON.write('nombreElementoConector', Lv_NombreConector);
    APEX_JSON.write('estadoElementoConector', Lv_EstadoConector);
    APEX_JSON.write('idInterfaceElementoConector', Ln_IdInterface);
    APEX_JSON.write('nombreInterfaceElementoConector', Lv_NombreInterface);
    APEX_JSON.write('distancia', Ln_DistanciaCaja);
    APEX_JSON.write('pasaNuevoAlgoritmo', 'NO');    
    APEX_JSON.close_object; -- }

    Lcl_JsonReturn    := apex_json.get_clob_output;
    APEX_JSON.free_output;
    Pv_Status   := 'OK';
    Pv_Mensaje  := 'Transaccion realizada correctamente aqui';
    Pcl_JsonReturn    := Lcl_JsonReturn;
  EXCEPTION
  WHEN Le_Exception THEN
    Pv_Status       := 'ERROR';
    Pv_Mensaje      := Lv_Mensaje || '. Por favor consultar con Sistemas!';

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_FACTIBILIDAD_LINEAL', 
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  WHEN OTHERS THEN
    Pv_Status       := 'ERROR';
    Lv_Mensaje      := 'Error inesperado ' || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' 
                               || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    Pv_Mensaje      := 'No se ha podido realizar correctamente la consulta de prefactibilidad. Por favor consultar con Sistemas!';

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'INKG_FACTIB_CONNECTIV_CONSULTA.P_FACTIBILIDAD_LINEAL',
                                          Lv_Mensaje, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_INFRAESTRUCTURA'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
  END P_FACTIBILIDAD_LINEAL;
END INKG_FACTIB_CONNECTIV_CONSULTA;
/
