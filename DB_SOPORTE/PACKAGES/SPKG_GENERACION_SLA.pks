CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_GENERACION_SLA AS

  /*
  Funcion que permite calcular la disponibilidad del servicio del cliente dado un rango de fechas, este dista de si el tipo de afectacion del
  caso sea por CAIDA o por INTERMITENCIA y el calulo se lo realiza de la siguiente manera:
  CAIDA
  - Reporte Consolidado
      disponibilidad = 100 - (m * 100)/t
  - Reporte Detallado
      disponibilidad = 100 - (m * 100)/1440 ( se establece porcentajes diarios por caida del servicio
  INTERMITENCIA
  - Reporte Detallado
      disponibilidad = 100 _ (m * 0,30 * 100)/1440 ( se establece una facor del 30% de indisponibilidad del servicio por intermitencia)
  @author Allan Suarez <arsuarez@telconet.ec>
  @version 1.0
  @since 18-12-2015
  @author Modificado: Richard Cabrera <rcabrera@telconet.ec>
  @version 1.1 13-10-2016 - Se le aumenta un dia a la diferencia entre la fecha de inicio y fin del Calculo del SLA
  @author Modificado: Richard Cabrera <rcabrera@telconet.ec>
  @version 1.2 23-11-2016 - Se realiza ajustes en el calculo de la disponibilidad que muestra el SLA, para que no se tome en
                            cuenta los casos que fueron SIN AFECTACION
  @author Modificado: Miguel Angulo <jmangulos@telconet.ec>
  @version 1.3 03-04-2019 - Se realiz� ajuste al query de c�lculo de SLA, para que no tome datos repetidos en el Package
                            P_GENERACION_RESUMEN_SLA -> C_CalculoSla
  @param Pn_minutos
  @param Pn_puntoId
  @param Pn_tipoReporte
  @param Pn_tipoAfectacion
  @param Pn_fechaDesde
  @param Pn_fechaHasta
  @return float
  */
  FUNCTION            FN_CALCULAR_DISPONIBILIDAD_SLA(
    Pn_minutos        INTEGER,
    Pn_puntoId        INTEGER,
    Pn_tipoReporte    VARCHAR2,
    Pn_tipoAfectacion VARCHAR2,
    Pn_fechaDesde     VARCHAR2,
    Pn_fechaHasta     VARCHAR2)
  RETURN FLOAT;

  FUNCTION FN_REPORTE_DETALLADO_SLA(
    Pn_minutos        INTEGER,        
    Pn_fechaDesde     VARCHAR2,
    Pn_fechaHasta     VARCHAR2,
    Pn_InicioIncidencia TIMESTAMP,
    Pn_FinIncidencia  TIMESTAMP,
    Pn_select         VARCHAR2,
    Pn_tipoAfectacion VARCHAR2,
    Pn_rango          VARCHAR2)    
  RETURN VARCHAR2;

  FUNCTION FN_GET_SERVICIO_CLIENTE_SLA (
   Pn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
   Pn_servicio NUMBER)
  RETURN VARCHAR2;

  /*
     Se modifica tipo de variable de retorno, por motivo de gran cantidad de casos por punto

     @author Jose Bedon <jobedon@telconet.ec>
     @version 1.0
     @since 25-09-2020

     Se agrega distinct para evitar duplicados de casos

     @author Jose Bedon <jobedon@telconet.ec>
     @version 2.0
     @since 28-06-2021

     @param Pn_IdPunto
     @param Pn_desde
     @param Pn_hasta
     @return CLOB
  */
  FUNCTION FN_GET_CASOS_CLIENTE_SLA(
    Pn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_desde VARCHAR2,
    Pn_hasta VARCHAR2)
  RETURN CLOB;

  /*
     Funci�n encargada de realizar el ingreso de la cabecera donde se encuentra al informaci�n b�sica de cada cliente y donde se ingresa
     el resumen del promedio del SLA calculado a partir de los puntos de un cliente.

     @author Allan Su�rez <arsuarez@telconet.ec>
     @version 1.0
     @since 14-11-2018

     @param Fv_RazonSocial
     @param Fv_Identificador
     @param Fv_Empresa
     @param Fv_Oficina
     @param Ff_Porcentaje
     @param Fn_Minutos
     @param Ft_FechaInicio
     @param Ft_FechaFin
     @param Fn_EmpresaCod
     @param Fn_PersonaRolId
     @return NUMBER
  */
  FUNCTION F_INSERTA_RESUMEN_SLA_CABECERA(
                                          Fv_RazonSocial    IN  VARCHAR2,
                                          Fv_Identificador  IN  VARCHAR2,
                                          Fv_Empresa        IN  VARCHAR2,
                                          Fv_Oficina        IN  VARCHAR2,
                                          Fv_Canton         IN  VARCHAR2,
                                          Ff_Porcentaje     IN  FLOAT,
                                          Fn_Minutos        IN  NUMBER,
                                          Ft_FechaInicio    IN  DATE,
                                          Ft_FechaFin       IN  DATE,
                                          Fn_EmpresaCod     IN  VARCHAR2,
                                          Fn_PersonaRolId   IN  NUMBER)
  RETURN NUMBER;

  /*
     Funci�n encargada de realizar el ingreso detallo por cliente donde se ingresan los logines con sus respectivos porcentajes de
     disponibilidad calculados con la f�rmula de SLA

     @author Allan Su�rez <arsuarez@telconet.ec>
     @version 1.0
     @since 14-11-2018

     @param Fn_ResumenSlaCabId
     @param Fv_Login
     @param Ff_PorcentajeDisponibilidad
     @param Fn_TiempoIncidencia
     @param Fn_PuntoId   
     @param Fn_Casos  
     @return NUMBER
  */
  FUNCTION F_INSERTA_RESUMEN_SLA_DETALLE(
                                          Fn_ResumenSlaCabId           IN  NUMBER,
                                          Fv_Login                     IN  VARCHAR2,
                                          Ff_PorcentajeDisponibilidad  IN  FLOAT,
                                          Fn_TiempoIncidencia          IN  NUMBER,
                                          Fn_PuntoId                   IN  NUMBER,
                                          Fv_Casos                     IN  VARCHAR2
                                        )
  RETURN NUMBER;

/*
  * Funci�n encargado de obtener reporte de SLA detallado para Telcograf.

  @author Karen Rodr�guez <kyrodriguez@telconet.ec>
  @version 1.0 30-07-2019

  @author Nestor Naula <nnaulal@telconet.ec>
  @version 1.1 14-10-2019 - cambio de rango de fecha menor e igual a un mes

  @param Pv_RazonSocial
  @param Pv_Nombres
  @param Pv_Apellidos
  @param Pv_FechaInicio
  @param Pv_FechaFin
  @return clob
*/     
  FUNCTION FN_CONSULTAR_SLA(
                            Pv_RazonSocial IN VARCHAR2,
                            Pv_Nombres IN VARCHAR2,
                            Pv_Apellidos IN VARCHAR2,
                            Pv_FechaInicio IN VARCHAR2,
                            Pv_FechaFin IN VARCHAR2  
                          )
RETURN CLOB;

  /*
     Funci�n encargada de realizar el c�lculo del SLA y respectiva poblaci�n de las tablas de resumen para todos los clientes de TN/MD
     que posean servicios de DATOS o INTERNET Activos por punto.

     @author Allan Su�rez <arsuarez@telconet.ec>
     @version 1.0
     @since 14-11-2018

     @param Ln_FechaInicial
     @param Ln_FechaFinal    
  */
  PROCEDURE P_GENERACION_RESUMEN_SLA(Ln_FechaInicial DATE,
                                     Ln_FechaFinal   DATE);

  /**
   * Documentaci�n para TYPE 'Gr_DisponibilidadCliente'.
   * Record para almacenar la disponibilidad consolidada del cliente.
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   */
  TYPE Gr_DisponibilidadCliente IS RECORD (
    CLIENTE         VARCHAR2(300),
    ID_PUNTO        NUMBER,
    LOGIN           VARCHAR2(50),
    NOMBRE_PUNTO    VARCHAR2(500),
    DISPONIBILIDAD  VARCHAR2(20),
    TIEMPO_TOTAL    VARCHAR2(20),
    CASOS           VARCHAR2(4000)
  );

  /**
   * Documentaci�n para TYPE 'Gtl_DisponibilidadCliente'.
   *
   * Tabla para almacenar la disponibilidad consolidada del cliente.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   */
  TYPE Gtl_DisponibilidadCliente IS TABLE OF Gr_DisponibilidadCliente INDEX BY PLS_INTEGER;

  /**
   * Documentaci�n para TYPE 'Gr_DisponibilidadDetCliente'.
   * Record para almacenar la disponibilidad detallada del cliente.
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   */
  TYPE Gr_DisponibilidadDetCliente IS RECORD (
    RANGO               VARCHAR2(50),
    FECHA               VARCHAR2(50),
    UPTIME              VARCHAR2(20),
    MINUTOS             VARCHAR2(20),
    INICIO_INDICENCIA   VARCHAR2(50),
    FIN_INCIDENCIA      VARCHAR2(50),
    AFECTACION          VARCHAR2(50),
    CASO                VARCHAR2(200),
    LOGIN               VARCHAR2(50),
    SERVICIOS_AFECTADOS VARCHAR2(2000),
    HIPOTESIS           CLOB
  );

  /**
   * Documentaci�n para TYPE 'Gtl_DisponibilidadDetCliente'.
   *
   * Tabla para almacenar la disponibilidad detallada del cliente.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   */
  TYPE Gtl_DisponibilidadDetCliente IS TABLE OF Gr_DisponibilidadDetCliente INDEX BY PLS_INTEGER;

  /*
   * Documentaci�n para el procedimiento 'P_REPORTE_SLA_CONSOLIDADO'.
   *
   * M�todo que permite generar el reporte SLA CONSOLIDADO.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.1 09-03-2021 - Se modifica la manera de generar el reporte, para utilizar el paquete GNKG_AS_XLSX.
   */
  PROCEDURE P_REPORTE_SLA_CONSOLIDADO(Pcl_Request IN  CLOB,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2);

  /*
   * Documentaci�n para el procedimiento 'P_REPORTE_SLA_DETALLADO'.
   *
   * M�todo que permite generar el reporte SLA DETALLADO.
   *
   * @param Pcl_Request IN  CLOB Recibe json request.
   * @param Pv_Status   OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.1 09-03-2021 - Se modifica la manera de generar el reporte, para utilizar el paquete GNKG_AS_XLSX.
   */
  PROCEDURE P_REPORTE_SLA_DETALLADO(Pcl_Request IN  CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2);

  /*
   * Documentaci�n para la procedimiento 'P_OBTENER_DISP_CON_CLIENTE'.
   *
   * M�todo que obtiene la disponibilidad consolidada del cliente.
   *
   * @param Pcl_Request    IN  CLOB Recibe json request.
   * @param Pr_DispCliente OUT SYS_REFCURSOR Retorna la disponibilidad consolidada del cliente.
   * @param Pv_Status      OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje     OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   *
   * Se modifica logica para obtener el tiempo total de los casos, ya que se duplicaba registros
   *
   * @author Jose Bedon <jobedon@telconet.ec>
   * @versi�n 2.0 28-06-2021
   *
   * Se modifica logica para cuando se filtra los puntos por estado activo, este tenga tambien un servicio activo
   *
   * @author Ivan Mata <imata@telconet.ec>
   * @versi�n 2.0 08-09-2022
   *
   */
  PROCEDURE P_OBTENER_DISP_CON_CLIENTE(Pcl_Request    IN CLOB,
                                       Pr_DispCliente OUT SYS_REFCURSOR,
                                       Pv_Status      OUT VARCHAR2,
                                       Pv_Mensaje     OUT VARCHAR2);

  /*
   * Documentaci�n para la procedimiento 'P_OBTENER_DISP_DET_CLIENTE'.
   *
   * M�todo que obtiene la disponibilidad detallada del cliente.
   *
   * @param Pcl_Request       IN  CLOB Recibe json request.
   * @param Pr_DispDetCliente OUT SYS_REFCURSOR Retorna la disponibilidad detallada del cliente.
   * @param Pv_Status         OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje        OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   */
  PROCEDURE P_OBTENER_DISP_DET_CLIENTE(Pcl_Request       IN  CLOB,
                                       Pr_DispDetCliente OUT SYS_REFCURSOR,
                                       Pv_Status         OUT VARCHAR2,
                                       Pv_Mensaje        OUT VARCHAR2);

  /*
   * Documentaci�n para el procedimiento 'P_OBTENER_TIPO_ENLACE'.
   *
   * M�todo que obtiene los tipos de enlaces que se vieron
   * afectados en un caso.
   *
   * @param Pcl_Request   IN  CLOB Recibe json request.
   * @param Pv_TipoEnlace OUT VARCHAR2 Retorna el tipo de enlace.
   * @param Pv_Status     OUT VARCHAR2 Retorna el estado de la transacci�n.
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna el mensaje de la transacci�n.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @versi�n 1.0 11-01-2021
   */
  PROCEDURE P_OBTENER_TIPO_ENLACE(Pcl_Request   IN  CLOB,
                                  Pv_TipoEnlace OUT VARCHAR2,
                                  Pv_Status     OUT VARCHAR2,
                                  Pv_Mensaje    OUT VARCHAR2);

  /**
   * Documentaci�n para la funci�n 'F_LIMPIAR_CADENA_CARACTERES'
   *
   * Funci�n que limpia ciertos caracteres especiales para los reportes.
   *
   * @Param CLOB Fv_Cadena Recibe la cadena de caracteres a limpiar.
   * @return CLOB Retorna la cadena sin car�cteres especiales.
   *
   * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 02-10-2020
   */
  FUNCTION F_LIMPIAR_CADENA_CARACTERES(Fv_Cadena IN CLOB) RETURN CLOB;

END SPKG_GENERACION_SLA;
/
CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_GENERACION_SLA AS

FUNCTION FN_CALCULAR_DISPONIBILIDAD_SLA(
    Pn_minutos        INTEGER,
    Pn_puntoId        INTEGER,
    Pn_tipoReporte    VARCHAR2,
    Pn_tipoAfectacion VARCHAR2,
    Pn_fechaDesde     VARCHAR2,
    Pn_fechaHasta     VARCHAR2)
  RETURN FLOAT
IS
  Ln_factor              FLOAT;
  Ln_disponibilidad      FLOAT;
  Ln_rango               INTEGER;
  Ln_tiempoSinAfectacion INTEGER := 0;
  Ln_minutos             INTEGER;

  --Cursor que obtiene el tiempo de los casos sin afectacion
  CURSOR C_GetTiempoSinAfectacion(cn_puntoId number,cv_tipoAfectado varchar2,cv_estadoCaso varchar2,
                                  cd_feApertura date,cd_feCierre date,cv_tipoAfectacion varchar2) IS

  SELECT SUM(NVL(INFOCASOTIEMPOASIGNACION.TIEMPO_TOTAL_CASO_SOLUCION,0))
  FROM INFO_CASO INFOCASO,
  INFO_DETALLE_HIPOTESIS INFODETALLEHIPOTESIS,INFO_DETALLE INFODETALLE,
  INFO_CASO_HISTORIAL INFOCASOHISTORIAL,INFO_CASO_TIEMPO_ASIGNACION INFOCASOTIEMPOASIGNACION
  WHERE INFOCASO.ID_CASO = INFODETALLEHIPOTESIS.CASO_ID
  AND INFODETALLEHIPOTESIS.ID_DETALLE_HIPOTESIS = INFODETALLE.DETALLE_HIPOTESIS_ID
  AND INFOCASO.ID_CASO = INFOCASOHISTORIAL.CASO_ID
  AND INFOCASOTIEMPOASIGNACION.CASO_ID = INFOCASO.ID_CASO
  AND INFODETALLE.ID_DETALLE IN (
    SELECT DETALLE_ID FROM INFO_PARTE_AFECTADA A
  WHERE AFECTADO_ID = cn_puntoId
  AND TIPO_AFECTADO = cv_tipoAfectado)
  AND INFOCASOHISTORIAL.ESTADO = cv_estadoCaso
  AND INFOCASO.FE_APERTURA >= cd_feApertura
  AND INFOCASO.FE_APERTURA <= cd_feCierre
  AND INFOCASO.TIPO_AFECTACION = cv_tipoAfectacion;

BEGIN

  IF(Pn_puntoId <> 0) THEN

    IF C_GetTiempoSinAfectacion%ISOPEN THEN
      CLOSE C_GetTiempoSinAfectacion;
    END IF;

    OPEN C_GetTiempoSinAfectacion(Pn_puntoId,'Cliente','Cerrado',TO_DATE(Pn_fechaDesde,'YYYY/MM/DD')+1,
    TO_DATE(Pn_fechaHasta,'YYYY/MM/DD')+1,'SINAFECTACION');
    FETCH C_GetTiempoSinAfectacion INTO Ln_tiempoSinAfectacion;
    CLOSE C_GetTiempoSinAfectacion;

  END IF;

  IF Pn_tipoReporte = 'consolidado' THEN
    Ln_rango       := ROUND(((TO_DATE(Pn_fechaHasta,'YYYY/MM/DD') - TO_DATE(Pn_fechaDesde,'YYYY/MM/DD')) + 1 )*1440);
  ELSE -- detallado
    Ln_rango:= 1440;
  END IF;
  ---
  IF Pn_tipoAfectacion IS NULL OR Pn_tipoAfectacion = 'CAIDA' THEN
    Ln_factor := 1;
  ELSE -- incidencia
    Ln_factor := 0.30;
  END IF;
  --
    Ln_minutos := Pn_minutos;
    IF Pn_minutos >= Ln_tiempoSinAfectacion THEN
      Ln_minutos := Pn_minutos - Ln_tiempoSinAfectacion;
    END IF;  

   Ln_disponibilidad := NVL((ROUND(100 - ((Ln_minutos*Ln_factor*100)/ Ln_rango ),2)),100);
   --dbms_output.put_line('FS1 Blocks = '||Ln_disponibilidad); 
   RETURN Ln_disponibilidad;
END FN_CALCULAR_DISPONIBILIDAD_SLA;

/*
  Funcion que devuelve los valores que se mostraran en la consulta del reporte detallado SLA enviando
  una referencia de la columna a mostrar

  @author Allan Suarez <arsuarez@telconet.ec>
  @version 1.0
  @since 18-12-2015
  @author Modificado: Richard Cabrera <rcabrera@telconet.ec>
  @version 1.2 23-11-2016 - Se realiza ajustes en el calculo de la disponibilidad que muestra el SLA, para que no se tome en
                            cuenta los casos que fueron SIN AFECTACION
  @param Pn_InicioIncidencia
  @param Pn_FinIncidencia
  @param Pn_select
  @param Pn_tipoAfectacion
  @param Pn_fechaDesde
  @param Pn_fechaHasta
  @return varchar2
  */
FUNCTION FN_REPORTE_DETALLADO_SLA(
    Pn_minutos          INTEGER,
    Pn_fechaDesde       VARCHAR2,
    Pn_fechaHasta       VARCHAR2,
    Pn_InicioIncidencia TIMESTAMP,
    Pn_FinIncidencia    TIMESTAMP,
    Pn_select           VARCHAR2,
    Pn_tipoAfectacion   VARCHAR2,
    Pn_rango            VARCHAR2)
  RETURN VARCHAR2
IS
  valor VARCHAR2(2000);  
BEGIN

  CASE
  WHEN Pn_rango = TRUNC(Pn_InicioIncidencia) AND Pn_rango = TRUNC(Pn_FinIncidencia) THEN  
    CASE
    WHEN Pn_select = 'uptime' THEN
      SELECT SPKG_GENERACION_SLA.FN_CALCULAR_DISPONIBILIDAD_SLA(Pn_minutos,0,'detallado',Pn_tipoAfectacion,Pn_fechaDesde,Pn_fechaHasta)
      INTO VALOR
      FROM DUAL;
    WHEN Pn_select = 'minutos' THEN
      VALOR       := Pn_minutos;--EXTRACT( DAY FROM (Pn_FinIncidencia - Pn_InicioIncidencia)*1440);
    WHEN Pn_select = 'inicioIncidencia' THEN
      VALOR       := TO_CHAR(Pn_InicioIncidencia,'DD-MM-YYYY HH24:MI');
    WHEN Pn_select = 'finIncidencia' THEN
      VALOR       := TO_CHAR(Pn_FinIncidencia,'DD-MM-YYYY HH24:MI');
    END CASE;
  ELSE -- CUANDO EL CASO DURA ABIERTO MAS DE 1 DIA      
    CASE
    WHEN Pn_select = 'uptime' THEN
      CASE
      WHEN Pn_rango = TRUNC(Pn_InicioIncidencia) THEN
        SELECT SPKG_GENERACION_SLA.FN_CALCULAR_DISPONIBILIDAD_SLA(EXTRACT( DAY FROM (TO_DATE(Pn_rango)+1 - Pn_InicioIncidencia)*1440), 
                0,'detallado',Pn_tipoAfectacion,Pn_fechaDesde,Pn_fechaHasta)
        INTO VALOR
        FROM DUAL;
      WHEN Pn_rango = TRUNC(Pn_FinIncidencia) THEN
        SELECT SPKG_GENERACION_SLA.FN_CALCULAR_DISPONIBILIDAD_SLA(EXTRACT( DAY FROM (Pn_FinIncidencia - TO_DATE(Pn_rango))*1440), 
                0,'detallado',Pn_tipoAfectacion,Pn_fechaDesde,Pn_fechaHasta)
        INTO VALOR
        FROM DUAL;        
      WHEN Pn_rango > TRUNC(Pn_InicioIncidencia) AND Pn_rango < TRUNC(Pn_FinIncidencia) THEN
        VALOR      := 0;
      ELSE
        VALOR      := 100;
      END CASE;

    WHEN Pn_select = 'minutos' THEN
      CASE
      WHEN Pn_rango = TRUNC(Pn_InicioIncidencia) THEN
        SELECT EXTRACT( DAY FROM (TO_DATE(Pn_rango)+1 - Pn_InicioIncidencia)*1440)
        INTO VALOR
        FROM DUAL;
      WHEN Pn_rango = TRUNC(Pn_FinIncidencia) THEN
        SELECT EXTRACT( DAY FROM (Pn_FinIncidencia - TO_DATE(Pn_rango))*1440)
        INTO VALOR
        FROM DUAL;
      WHEN Pn_rango > TRUNC(Pn_InicioIncidencia) AND Pn_rango < TRUNC(Pn_FinIncidencia) THEN
        VALOR      :=1440;
      ELSE
        VALOR := 0;
      END CASE;

    WHEN Pn_select = 'inicioIncidencia' THEN
      CASE
      WHEN Pn_rango = TRUNC(Pn_InicioIncidencia) THEN
        VALOR      := TO_CHAR(Pn_InicioIncidencia,'DD-MM-YYYY HH24:MI');
      WHEN Pn_rango = TRUNC(Pn_FinIncidencia) THEN
        VALOR      := TO_CHAR(Pn_FinIncidencia,'DD-MM-YYYY')||' 00:00';
      WHEN Pn_rango > TRUNC(Pn_InicioIncidencia) AND Pn_rango < TRUNC(Pn_FinIncidencia) THEN
        VALOR      := TO_CHAR(TO_DATE(Pn_rango),'DD-MM-YYYY')||' 00:00';
      ELSE
        VALOR := NULL;
      END CASE;

    WHEN Pn_select = 'finIncidencia' THEN
      CASE
      WHEN Pn_rango = TRUNC(Pn_InicioIncidencia) THEN
        VALOR      := TO_CHAR(Pn_InicioIncidencia,'DD-MM-YYYY')||' 23:59';
      WHEN Pn_rango = TRUNC(Pn_FinIncidencia) THEN
        VALOR      := TO_CHAR(Pn_FinIncidencia,'DD-MM-YYYY HH24:MI');
      WHEN Pn_rango > TRUNC(Pn_InicioIncidencia) AND Pn_rango < TRUNC(Pn_FinIncidencia) THEN
        VALOR      := TO_CHAR(TO_DATE(Pn_rango),'DD-MM-YYYY')||' 23:59';
      ELSE
        VALOR := NULL;
      END CASE;

    END CASE;


  END CASE;
  RETURN VALOR;
END FN_REPORTE_DETALLADO_SLA;

/*
  Funcion que devuelve los servicios afectados cuando se crean los clientes para efecto de reporte detallado de sla

  - Si el caso es creado de manera generica sin seleccion de un servicios mostrara todos, caso contrario mostrada
    el servicio afectado en un inicio

  @author Allan Suarez <arsuarez@telconet.ec>
  @version 1.0
  @since 18-12-2015

  @author Allan Suarez <arsuarez@telconet.ec>
  @version 1.1 - Se modifica funcion para que devuelva el servicio afectado elegido por cada cliente
  @since 18-06-2016

  @param Pn_servicio
  @param Pn_IdPunto
  @return varchar2
  */
FUNCTION FN_GET_SERVICIO_CLIENTE_SLA(
    Pn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_servicio NUMBER)
  RETURN VARCHAR2
IS
  ---
  Lv_servicios VARCHAR2(1000) := 'SERVICIOS : ';
  CURSOR C_Servicios ( Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    (SELECT PROD.DESCRIPCION_PRODUCTO,
      PROD.ID_PRODUCTO,
      ISR.ID_SERVICIO
    FROM INFO_SERVICIO ISR,
      INFO_PLAN_CAB IPC,
      INFO_PLAN_DET IPD,
      ADMI_PRODUCTO PROD
    WHERE ISR.PLAN_ID   = IPC.ID_PLAN
    AND IPC.ID_PLAN     = IPD.PLAN_ID
    AND IPD.PRODUCTO_ID = PROD.ID_PRODUCTO
    AND PROD.ESTADO     = 'Activo'
    AND ISR.PUNTO_ID    = Cn_IdPunto
  UNION
  SELECT PROD.DESCRIPCION_PRODUCTO,
    PROD.ID_PRODUCTO,
    ISR.ID_SERVICIO
  FROM INFO_SERVICIO ISR,
    ADMI_PRODUCTO PROD
  WHERE ISR.PRODUCTO_ID = PROD.ID_PRODUCTO
  AND PROD.ESTADO       = 'Activo'
  AND ISR.PUNTO_ID      = Cn_IdPunto
    );

  TYPE t_cursorServicios IS TABLE OF C_Servicios%ROWTYPE INDEX BY PLS_INTEGER;
  CursorServicios t_cursorServicios;
  Lv_nombreProducto VARCHAR2(100);

BEGIN

  OPEN C_Servicios (Pn_IdPunto);
  FETCH C_Servicios BULK COLLECT INTO CursorServicios;

  FOR I IN 1 .. CursorServicios.COUNT
  LOOP
    Lv_nombreProducto := CursorServicios (I).DESCRIPCION_PRODUCTO;

    EXIT WHEN
      LENGTH(Lv_servicios||' - '||Lv_nombreProducto) > 1000 OR
      LENGTH(Lv_servicios||Lv_nombreProducto)        > 1000;

    IF Pn_servicio     = 0 THEN
      Lv_servicios    := Lv_servicios ||' - '||Lv_nombreProducto;
    ELSE
      IF (CursorServicios (I).ID_SERVICIO = Pn_servicio) THEN
        Lv_servicios                     := Lv_servicios || Lv_nombreProducto;
      END IF;
    END IF;

  END LOOP;

  RETURN Lv_servicios;

END FN_GET_SERVICIO_CLIENTE_SLA;

/*
  Funcion que devuelve los casos de donde se deriva la afectacion de cada cliente consultado

  @author Allan Suarez <arsuarez@telconet.ec>
  @version 1.0
  @since 19-12-2015

  @param Pn_servicio
  @param Pn_desde
  @param Pn_hasta
  @return varchar2
  */
FUNCTION FN_GET_CASOS_CLIENTE_SLA(
    Pn_IdPunto IN INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_desde VARCHAR2,
    Pn_hasta VARCHAR2)
  RETURN CLOB
IS
  ---
  Lv_casos CLOB;
  CURSOR C_Casos ( Cn_IdPunto INFO_PUNTO.ID_PUNTO%TYPE,Pn_desde VARCHAR2,Pn_hasta VARCHAR2)
  IS
    (SELECT DISTINCT CASO.NUMERO_CASO
      FROM INFO_CASO CASO,
        INFO_CASO_HISTORIAL HISTORIAL,
        INFO_DETALLE_HIPOTESIS DETALLE_HIPOTESIS,
        INFO_DETALLE DETALLE,
        INFO_PARTE_AFECTADA PARTE_AFECTADA
      WHERE CASO.ID_CASO                         = DETALLE_HIPOTESIS.CASO_ID
      AND DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS = DETALLE.DETALLE_HIPOTESIS_ID
      AND DETALLE.ID_DETALLE                     = PARTE_AFECTADA.DETALLE_ID
      AND CASO.ID_CASO                           = HISTORIAL.CASO_ID
      AND PARTE_AFECTADA.AFECTADO_ID             = Cn_IdPunto
      AND TO_CHAR(CASO.FE_APERTURA,'RRRR-MM-DD') >= Pn_desde
      AND TO_CHAR(CASO.FE_APERTURA,'RRRR-MM-DD') <= Pn_hasta
      AND PARTE_AFECTADA.TIPO_AFECTADO           = 'Cliente'
      AND HISTORIAL.ESTADO                       = 'Cerrado');

  TYPE t_cursorCasos IS TABLE OF C_Casos%ROWTYPE INDEX BY PLS_INTEGER;
  CursorCasos t_cursorCasos;
  Lv_numeroCaso VARCHAR2(100);

BEGIN

  OPEN C_Casos (Pn_IdPunto,Pn_desde,Pn_hasta);
  FETCH C_Casos BULK COLLECT INTO CursorCasos;

  FOR I IN 1 .. CursorCasos.COUNT
  LOOP
    Lv_numeroCaso := CursorCasos (I).NUMERO_CASO;    
    Lv_casos    := Lv_casos ||' - '||Lv_numeroCaso;

  END LOOP;

  CLOSE C_Casos;

  RETURN Lv_casos;

END FN_GET_CASOS_CLIENTE_SLA;

FUNCTION F_INSERTA_RESUMEN_SLA_CABECERA(
                                        Fv_RazonSocial    IN  VARCHAR2,
                                        Fv_Identificador  IN  VARCHAR2,
                                        Fv_Empresa        IN  VARCHAR2,
                                        Fv_Oficina        IN  VARCHAR2,
                                        Fv_Canton         IN  VARCHAR2,
                                        Ff_Porcentaje     IN  FLOAT,
                                        Fn_Minutos        IN  NUMBER,
                                        Ft_FechaInicio    IN  DATE,
                                        Ft_FechaFin       IN  DATE,
                                        Fn_EmpresaCod     IN  VARCHAR2,
                                        Fn_PersonaRolId   IN  NUMBER
                                       ) RETURN NUMBER IS
      Ln_CabeceraId NUMBER;

  BEGIN

      Ln_CabeceraId := DB_SOPORTE.SEQ_INFO_RESUMEN_SLA_CAB.NEXTVAL;

      INSERT INTO DB_SOPORTE.INFO_RESUMEN_SLA_CAB(
        ID_RESUMEN_SLA_CAB,
        RAZON_SOCIAL,
        IDENTIFICADOR_CLIENTE,
        EMPRESA,
        OFICINA,
        CANTON,
        PORCENTAJE_DISP_PROMEDIO,
        MINUTOS_INCIDENCIA_PROMEDIO,
        FECHA_INICIO,
        FECHA_FIN,
        EMPRESA_COD,
        PERSONA_ROL_ID,
        USR_CREACION,
        FE_CREACION,
        ESTADO
    ) VALUES (
        Ln_CabeceraId,
        Fv_RazonSocial,
        Fv_Identificador,
        Fv_Empresa,
        Fv_Oficina,
        Fv_Canton,
        Ff_Porcentaje,
        Fn_Minutos,
        Ft_FechaInicio,
        Ft_FechaFin,
        Fn_EmpresaCod,
        Fn_PersonaRolId,
        'telcos',
        SYSDATE,
       'Activo'
    );

    RETURN Ln_CabeceraId;

  EXCEPTION
        WHEN OTHERS THEN            
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                                 'F_INSERTA_RESUMEN_SLA_CABECERA',
                                                 'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                  NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
            RETURN NULL;
END F_INSERTA_RESUMEN_SLA_CABECERA;


FUNCTION F_INSERTA_RESUMEN_SLA_DETALLE(
                                        Fn_ResumenSlaCabId           IN  NUMBER,
                                        Fv_Login                     IN  VARCHAR2,
                                        Ff_PorcentajeDisponibilidad  IN  FLOAT,
                                        Fn_TiempoIncidencia          IN  NUMBER,
                                        Fn_PuntoId                   IN  NUMBER,
                                        Fv_Casos                     IN  VARCHAR2
                                      ) RETURN NUMBER IS
      Ln_DetalleId NUMBER;

  BEGIN

      Ln_DetalleId := DB_SOPORTE.SEQ_INFO_RESUMEN_SLA_DET.NEXTVAL;

      INSERT INTO DB_SOPORTE.INFO_RESUMEN_SLA_DET(
        ID_RESUMEN_SLA_DET,
        RESUMEN_SLA_CAB_ID,
        LOGIN,
        PORCENTAJE_DISPONIBILIDAD,
        TIEMPO_INCIDENCIA,
        PUNTO_ID,
        CASOS,
        USR_CREACION,
        FE_CREACION,
        ESTADO
    ) VALUES (
        Ln_DetalleId,
        Fn_ResumenSlaCabId,
        Fv_Login,
        Ff_PorcentajeDisponibilidad,
        Fn_TiempoIncidencia,
        Fn_PuntoId,
        Fv_Casos,
        'telcos',
        SYSDATE,
       'Activo'
    );

    RETURN Ln_DetalleId;

  EXCEPTION
        WHEN OTHERS THEN           
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                                 'F_INSERTA_RESUMEN_SLA_DETALLE',
                                                 'Error: ' || SQLCODE || ' - ERROR_STACK: '||
                                                  DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                  NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                                  SYSDATE,
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
            RETURN NULL;

END F_INSERTA_RESUMEN_SLA_DETALLE;


PROCEDURE P_GENERACION_RESUMEN_SLA(Ln_FechaInicial DATE,
                                   Ln_FechaFinal   DATE)
AS              
    --CURSOS QUE CONSULTA TODOS LOS CLIENTES TANTO DE TELCONET COMO MEGADATOS BAJO LAS SIGUIENTES CONSIDERACIONES:
    -- 1. Clientes Activos
    -- 2. Contegan Puntos Activos ( al menos uno )
    -- 3. Cada Punto contenga al menos un Servicio Activo
    -- 4. Cada Servicio Activo que exista en el Punto si es telconet que sea producto ( DATOS/INTERNET )
    CURSOR C_Clientes 
      IS
        (SELECT 
          PERSONA.ID_PERSONA,
          PERSONA_ROL.ID_PERSONA_ROL,
          EMPRESA.NOMBRE_EMPRESA,
          NVL(PERSONA.RAZON_SOCIAL,PERSONA.NOMBRES
          ||' '
          ||PERSONA.APELLIDOS) AS RAZON_SOCIAL,
          PERSONA.IDENTIFICACION_CLIENTE,    
          OFICINA.NOMBRE_OFICINA,
          CANTON.NOMBRE_CANTON,
          EMPRESA_ROL.EMPRESA_COD
        FROM 
          DB_COMERCIAL.INFO_PERSONA PERSONA,
          DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_ROL,
          DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL,
          DB_COMERCIAL.ADMI_ROL ROL,
          DB_COMERCIAL.INFO_OFICINA_GRUPO OFICINA,
          DB_COMERCIAL.ADMI_CANTON CANTON,
          DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPRESA
        WHERE PERSONA.ID_PERSONA       = PERSONA_ROL.PERSONA_ID
        AND PERSONA_ROL.EMPRESA_ROL_ID = EMPRESA_ROL.ID_EMPRESA_ROL
        AND EMPRESA_ROL.ROL_ID         = ROL.ID_ROL
        AND PERSONA_ROL.OFICINA_ID     = OFICINA.ID_OFICINA
        AND OFICINA.CANTON_ID          = CANTON.ID_CANTON
        AND EMPRESA_ROL.EMPRESA_COD    = EMPRESA.COD_EMPRESA
        AND ROL.DESCRIPCION_ROL        = 'Cliente'        
        AND EMPRESA_ROL.ESTADO         = 'Activo'
        AND PERSONA_ROL.ESTADO         = 'Activo'
        AND OFICINA.ESTADO             = 'Activo'
        AND EMPRESA_ROL.EMPRESA_COD   IN (10,18)
        AND EXISTS (SELECT 1 FROM DB_COMERCIAL.INFO_PUNTO PUNTO WHERE PUNTO.PERSONA_EMPRESA_ROL_ID = PERSONA_ROL.ID_PERSONA_ROL AND ESTADO = 'Activo' 
        AND EXISTS (
           SELECT 1
            FROM 
                DB_COMERCIAL.INFO_SERVICIO S
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO P
            ON P.ID_PRODUCTO = S.PRODUCTO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB C
            ON C.ID_PLAN          = S.PLAN_ID
            WHERE S.PUNTO_ID      = PUNTO.ID_PUNTO
            AND S.ESTADO          = 'Activo'
            AND (P.CLASIFICACION IN ('DATOS','INTERNET')
            OR C.TIPO            IN ('HOME','PYME','PRO')) )
        )       
    );      

    --CURSOR QUE OBTIENE TODOS LOS PUNTOS DADO LA PERSONA ROL DE UN CLIENTE
    CURSOR C_Puntos (Pn_IdPersonaEmpresaRol INTEGER)
    IS
    (
      SELECT ID_PUNTO
          FROM 
              DB_COMERCIAL.INFO_PUNTO
          WHERE PERSONA_EMPRESA_ROL_ID = Pn_IdPersonaEmpresaRol
          AND ESTADO                   = 'Activo'
          AND EXISTS
            (SELECT 1
            FROM DB_COMERCIAL.INFO_SERVICIO S
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO P
            ON P.ID_PRODUCTO = S.PRODUCTO_ID
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB C
            ON C.ID_PLAN = S.PLAN_ID ,
              DB_COMERCIAL.INFO_SERVICIO_HISTORIAL H
            WHERE S.PUNTO_ID      = ID_PUNTO
            AND S.ID_SERVICIO     = H.SERVICIO_ID
            AND S.ESTADO          = 'Activo'
            AND (P.CLASIFICACION IN ('DATOS','INTERNET')
            OR C.TIPO            IN ('HOME','PYME','PRO'))
            AND H.FE_CREACION     =
              (SELECT MIN(FE_CREACION)
              FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
              WHERE SERVICIO_ID = S.ID_SERVICIO
              AND ESTADO        = 'Activo'
              )
            AND TRUNC(h.FE_CREACION) <= Ln_FechaFinal
            )
    );      

    --CURSOR QUE CALCULA EL SLA CONSOLIDADO EN EL RANGO DE TIEMPO DEFINIDO POR LOGIN DE UN CLIENTE
    CURSOR C_CalculoSla(Pn_IdPunto INTEGER, Pn_FechaInicial DATE, Pn_FechaFinal DATE)
    IS
    (
        SELECT      
          PUNTO.ID_PUNTO,
          PUNTO.LOGIN,
          SPKG_GENERACION_SLA.FN_CALCULAR_DISPONIBILIDAD_SLA(
              SUM(NVL(TIEMPO.TIEMPO_TOTAL_CASO_SOLUCION,0)),
              PUNTO.ID_PUNTO,
              'consolidado',
              'CAIDA',
              TO_CHAR( Pn_FechaInicial ,'YYYY/MM/DD'),
              TO_CHAR( Pn_FechaFinal,   'YYYY/MM/DD')
          ) AS DISPONIBILIDAD,
          SUM(NVL(TIEMPO.TIEMPO_TOTAL_CASO_SOLUCION,0)) AS TIEMPO_INCIDENCIA                
                  FROM INFO_PUNTO PUNTO
                    LEFT JOIN INFO_PERSONA_EMPRESA_ROL EMPRESA_ROL
                    ON EMPRESA_ROL.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID
                    LEFT JOIN INFO_PERSONA PERSONA
                    ON PERSONA.ID_PERSONA = EMPRESA_ROL.PERSONA_ID
                    LEFT JOIN INFO_PARTE_AFECTADA PARTE_AFECTADA
                    ON PUNTO.ID_PUNTO                = PARTE_AFECTADA.AFECTADO_ID
                    AND PARTE_AFECTADA.TIPO_AFECTADO = 'Cliente'
                    LEFT JOIN INFO_DETALLE DETALLE
                    ON PARTE_AFECTADA.DETALLE_ID = DETALLE.ID_DETALLE
                    LEFT JOIN INFO_DETALLE_HIPOTESIS DETALLE_HIPOTESIS
                    ON DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS = DETALLE.DETALLE_HIPOTESIS_ID
                    LEFT JOIN INFO_CASO CASO
                    ON CASO.ID_CASO              = DETALLE_HIPOTESIS.CASO_ID
                    AND TRUNC(CASO.FE_APERTURA) >= Pn_FechaInicial
                    AND TRUNC(CASO.FE_APERTURA) <= Pn_FechaFinal
                    LEFT JOIN INFO_CASO_HISTORIAL HISTORIAL
                    ON HISTORIAL.CASO_ID         = CASO.ID_CASO
                    AND HISTORIAL.ESTADO         = 'Cerrado'
                    LEFT JOIN INFO_CASO_TIEMPO_ASIGNACION TIEMPO
                    ON TIEMPO.CASO_ID            = CASO.ID_CASO                
                    WHERE PUNTO.ID_PUNTO         = Pn_IdPunto
                    AND DETALLE.ID_DETALLE       = (SELECT MIN(DET.ID_DETALLE)
                                                      FROM INFO_DETALLE DET
                                                     WHERE DET.DETALLE_HIPOTESIS_ID = DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS) 
                    AND TIEMPO.ID_CASO_TIEMPO_ASIGNACION 
                                                 = (SELECT MIN(ICTA.ID_CASO_TIEMPO_ASIGNACION)
                                                      FROM INFO_CASO_TIEMPO_ASIGNACION ICTA
                                                     WHERE ICTA.CASO_ID = CASO.ID_CASO)
                    AND HISTORIAL.ID_CASO_HISTORIAL 
                                                 = (SELECT MIN(ID_CASO_HISTORIAL) 
                                                     FROM INFO_CASO_HISTORIAL ICH 
                                                    WHERE ICH.CASO_ID = CASO.ID_CASO 
                                                      AND ICH.ESTADO = 'Cerrado')
                  GROUP BY 
                    PUNTO.ID_PUNTO,
                    PUNTO.LOGIN
    );

    --CURSOR QUE OBTIENE LOS CASOS POR PUNTOS
    CURSOR C_ObtenerCasosPorPunto(Pn_IdPunto INTEGER, Pn_FechaInicial DATE, Pn_FechaFinal DATE)
    IS
    (
        SELECT 
          CASO.ID_CASO,
          CASO.NUMERO_CASO,
          TIEMPO_CASO.TIEMPO_TOTAL_CASO_SOLUCION
        FROM 
          DB_SOPORTE.INFO_CASO CASO,
          DB_SOPORTE.INFO_CASO_HISTORIAL HISTORIAL,
          DB_SOPORTE.INFO_DETALLE_HIPOTESIS DETALLE_HIPOTESIS,
          DB_SOPORTE.INFO_DETALLE DETALLE,
          DB_SOPORTE.INFO_PARTE_AFECTADA PARTE_AFECTADA,
          DB_SOPORTE.INFO_CASO_TIEMPO_ASIGNACION TIEMPO_CASO
        WHERE CASO.ID_CASO                         = DETALLE_HIPOTESIS.CASO_ID
        AND DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS = DETALLE.DETALLE_HIPOTESIS_ID
        AND DETALLE.ID_DETALLE                     = PARTE_AFECTADA.DETALLE_ID
        AND CASO.ID_CASO                           = HISTORIAL.CASO_ID
        AND CASO.ID_CASO                           = TIEMPO_CASO.CASO_ID
        AND PARTE_AFECTADA.AFECTADO_ID             = Pn_IdPunto
        AND TRUNC(CASO.FE_APERTURA)               >= Pn_FechaInicial
        AND TRUNC(CASO.FE_APERTURA)               <= Pn_FechaFinal
        AND PARTE_AFECTADA.TIPO_AFECTADO           = 'Cliente'
        AND HISTORIAL.ESTADO                       = 'Cerrado'
    );

      --DECLARACI�N DE CURSORES
      TYPE t_cursorClientes IS TABLE OF C_Clientes%ROWTYPE INDEX BY PLS_INTEGER;
      CursorClientes t_cursorClientes;    

      TYPE t_cursorPuntos IS TABLE OF C_Puntos%ROWTYPE INDEX BY PLS_INTEGER;
      CursorPuntos t_cursorPuntos; 

      TYPE t_cursorCalculoSla IS TABLE OF C_CalculoSla%ROWTYPE INDEX BY PLS_INTEGER;
      CursorCalculoSla t_cursorCalculoSla; 

      TYPE t_cursorCasosPorPunto IS TABLE OF C_ObtenerCasosPorPunto%ROWTYPE INDEX BY PLS_INTEGER;
      CursorCasosPorPunto t_cursorCasosPorPunto;

      Ln_idPunto                   NUMBER := 0;
      Lf_disponibilidadPromedio    FLOAT;
      Ln_MinutosIncidenciaPromedio FLOAT;
      Ln_CantidadPuntosPorCliente  NUMBER;   
      Ln_CabeceraId                NUMBER;
      Ln_DetalleId                 NUMBER;      
      Ln_contadorCommit            NUMBER := 0;
      Ln_esProcesado               NUMBER := 0;

      Pv_Error                     VARCHAR2(4000):=NULL;
      Lv_Error                     VARCHAR2(4000):=NULL;
      Le_MyException               EXCEPTION;
      Li_i_clientes                PLS_INTEGER;
      Li_i_puntos                  PLS_INTEGER;
      Li_i_disp                    PLS_INTEGER;      
      Ln_idCLienteProcesado        NUMBER;
      Ln_cabeceraIngresada         NUMBER;

  BEGIN 

      IF C_Clientes%ISOPEN THEN
        CLOSE C_Clientes;
      END IF;

    OPEN C_Clientes;
    LOOP
        FETCH C_Clientes BULK COLLECT INTO CursorClientes LIMIT 500;
        EXIT
        WHEN CursorClientes.COUNT = 0;

        Li_i_clientes := CursorClientes.FIRST;

        --Recorrer todos los clientes que est�n dentro de la consideraci�n para el c�lculo del SLA
        WHILE(Li_i_clientes IS NOT NULL)
        LOOP

            Ln_cabeceraIngresada := 0;

          --Validar que el registro para el periodo especificado no haya sido ya procesado
            SELECT COUNT(*)
            INTO Ln_esProcesado
            FROM DB_SOPORTE.INFO_RESUMEN_SLA_CAB
            WHERE IDENTIFICADOR_CLIENTE = CursorClientes(Li_i_clientes).IDENTIFICACION_CLIENTE
            AND FECHA_INICIO            = Ln_FechaInicial
            AND FECHA_FIN               = Ln_FechaFinal
            AND EMPRESA_COD             = CursorClientes(Li_i_clientes).EMPRESA_COD;

            IF Ln_esProcesado = 0 THEN

                Lf_disponibilidadPromedio    := 0;
                Ln_MinutosIncidenciaPromedio := 0;
                Ln_CantidadPuntosPorCliente  := 0;

                Ln_idCLienteProcesado := CursorClientes(Li_i_clientes).ID_PERSONA_ROL;

                 -------------------------------------------------------------------------------------
                IF C_Puntos%ISOPEN THEN
                  CLOSE C_Puntos;
                END IF; 

                --Se inicializa el contador de puntos a analizar por cliente
                Ln_CantidadPuntosPorCliente := 0;

                OPEN C_Puntos(CursorClientes(Li_i_clientes).ID_PERSONA_ROL);
                LOOP

                    FETCH C_Puntos BULK COLLECT INTO CursorPuntos LIMIT 100;
                    EXIT
                    WHEN CursorPuntos.COUNT = 0;

                    --SOLO SE INGRESA UNA VEZ LA CABECERA DEL CLIENTE CUANDO SUS PUNTOS/SERVICIO CUMPLEN CON LA CONDICION
                    IF Ln_cabeceraIngresada = 0 THEN

                          --Se realiza el ingreso de la cabecera por cliente del SLA de la informaci�n b�sica de cada cliente
                          Ln_CabeceraId := DB_SOPORTE.SPKG_GENERACION_SLA.F_INSERTA_RESUMEN_SLA_CABECERA(
                                                                                              CursorClientes(Li_i_clientes).RAZON_SOCIAL,
                                                                                              CursorClientes(Li_i_clientes).IDENTIFICACION_CLIENTE,
                                                                                              CursorClientes(Li_i_clientes).NOMBRE_EMPRESA,
                                                                                              CursorClientes(Li_i_clientes).NOMBRE_OFICINA,
                                                                                              CursorClientes(Li_i_clientes).NOMBRE_CANTON,
                                                                                              0,
                                                                                              0,
                                                                                              Ln_FechaInicial,
                                                                                              Ln_FechaFinal,
                                                                                              CursorClientes(Li_i_clientes).EMPRESA_COD,
                                                                                              CursorClientes(Li_i_clientes).ID_PERSONA_ROL
                                                                                              );

                          IF (Ln_CabeceraId IS NULL) THEN
                            RAISE Le_MyException;
                          END IF;      

                          Ln_cabeceraIngresada := 1; 

                    END IF;

                    Li_i_puntos := CursorPuntos.FIRST;

                    --Recorrer todos los puntos activos que contenga productos definidos para cada cliente
                    WHILE (Li_i_puntos IS NOT NULL)
                    LOOP

                        IF C_CalculoSla%ISOPEN THEN
                          CLOSE C_CalculoSla;
                        END IF;                       

                        OPEN C_CalculoSla(CursorPuntos(Li_i_puntos).ID_PUNTO,Ln_FechaInicial,Ln_FechaFinal);
                        LOOP
                            FETCH C_CalculoSla BULK COLLECT INTO CursorCalculoSla LIMIT 1;
                            EXIT
                            WHEN CursorCalculoSla.COUNT = 0;

                            Li_i_disp := CursorCalculoSla.FIRST;

                            WHILE(Li_i_disp IS NOT NULL)

                            --Se obtiene los valores una vez realizado el c�lculo del SLA por login para luego determinar el promedio por cliente en un per�odo de tiempo                            
                            LOOP                          

                                Lf_disponibilidadPromedio    := Lf_disponibilidadPromedio    + CursorCalculoSla(Li_i_disp).DISPONIBILIDAD;
                                Ln_MinutosIncidenciaPromedio := Ln_MinutosIncidenciaPromedio + CursorCalculoSla(Li_i_disp).TIEMPO_INCIDENCIA;

                                --SE REALIZA LA INSERCI�N DEL DETALLE POR CADA CLIENTE EN CASO DE TENER MAS DE UN LOGIN
                                Ln_DetalleId := DB_SOPORTE.SPKG_GENERACION_SLA.F_INSERTA_RESUMEN_SLA_DETALLE(
                                                                                            Ln_CabeceraId,                                                                            
                                                                                            CursorCalculoSla(Li_i_disp).LOGIN,
                                                                                            CursorCalculoSla(Li_i_disp).DISPONIBILIDAD,
                                                                                            CursorCalculoSla(Li_i_disp).TIEMPO_INCIDENCIA,
                                                                                            CursorCalculoSla(Li_i_disp).ID_PUNTO,
                                                                                            NULL
                                                                                            );

                                IF ( Ln_DetalleId IS NULL) THEN
                                  RAISE Le_MyException;
                                END IF;      

                                Li_i_disp := CursorCalculoSla.NEXT(Li_i_disp);

                            END LOOP;--END LOOP DE RECORRIDO DE RESULTADO DE DISPONIBILIDADES

                        END LOOP;--END LOOP DEL BULK COLLECTION

                        CLOSE C_CalculoSla;

                        Ln_CantidadPuntosPorCliente := Ln_CantidadPuntosPorCliente + 1;

                        --se obtiene el siguiente registro de la colecci�n
                        Li_i_puntos := CursorPuntos.NEXT(Li_i_puntos);

                    END LOOP;--END LOOP RECORRIDO DE PUNTOS WHILE                                                                            

                END LOOP;--END LOOP BULK COLLECT PUNTOS

                IF Ln_CantidadPuntosPorCliente > 0 THEN

                    /*
                    SE REALIZA EL C�LCULO PROMEDIO DEL PORCENTAJE DE DISPONIBILIDAD PROMEDIO DE UN CLIENTE DE ACUERDO AL N�MERO DE PUNTOS ACTIVOS EN DONDE
                    SE REALIZ� EL AN�LISIS DE SLA 
                    */
                    Lf_disponibilidadPromedio    := ROUND((Lf_disponibilidadPromedio/Ln_CantidadPuntosPorCliente),2);
                    Ln_MinutosIncidenciaPromedio := ROUND((Ln_MinutosIncidenciaPromedio/Ln_CantidadPuntosPorCliente),2);

                    --SE ACTUALIZA EL PROMEDIO DE DISPONIBILIDAD Y MINUTOS DE INCIDENCIA CALCULADO A PARTIR DE LOS PUNTOS            

                    UPDATE DB_SOPORTE.INFO_RESUMEN_SLA_CAB
                      SET PORCENTAJE_DISP_PROMEDIO  = Lf_disponibilidadPromedio,
                        MINUTOS_INCIDENCIA_PROMEDIO = Ln_MinutosIncidenciaPromedio
                      WHERE ID_RESUMEN_SLA_CAB      = Ln_CabeceraId;                              

                END IF;

                CLOSE C_Puntos;

            END IF;--END IF VALIDACION SI EL REGISTRO YA FUE PROCESADO

            --Se realizar� commit cada 100 ingresos de informaci�n de cliente
            IF Ln_contadorCommit < 100 THEN
              Ln_contadorCommit := Ln_contadorCommit + 1;
            ELSE
              Ln_contadorCommit := 0;
              COMMIT;
            END IF;   

            --se obtiene el siguiente registro de la colecci�n
            Li_i_clientes :=  CursorClientes.NEXT(Li_i_clientes);  

        END LOOP;

    END LOOP; --END LOOP BULK COLLECT DE TODOS LOS CLIENTES 

    CLOSE C_Clientes;

    COMMIT;

EXCEPTION

    WHEN Le_MyException THEN      
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_GENERACION_RESUMEN_SLA',
                                            'ERROR EN EL INGRESO DE LA INFORMACION EN CLIENTE '||Ln_idCLienteProcesado,
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    WHEN OTHERS THEN
     Pv_Error := 'Error: SPKG_GENERACION_SLA.P_GENERACION_RESUMEN_SLA - Error: ' || SQLERRM;
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                          'P_GENERACION_RESUMEN_SLA',
                                          'Error: ' || SQLCODE || ' - ERROR_STACK('||Ln_idCLienteProcesado||' PERIODO '||Ln_FechaInicial||'): '||
                                           DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_SOPORTE'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));


END P_GENERACION_RESUMEN_SLA;

/*
  * M�todo encargado de obtener reporte de SLA detallado para Telcograf.

  @author Karen Rodr�guez <kyrodriguez@telconet.ec>
  @version 1.0 30-07-2019

  @author Nestor Naula <nnaulal@telconet.ec>
  @version 1.1 14-10-2019 - cambio de rango de fecha menor e igual a un mes

  @param Pv_RazonSocial
  @param Pv_Nombres
  @param Pv_Apellidos
  @param Pv_FechaInicio
  @param Pv_FechaFin
  @return clob
  */

  FUNCTION FN_CONSULTAR_SLA ( Pv_RazonSocial  IN VARCHAR2,
                              Pv_Nombres      IN VARCHAR2,
                              Pv_Apellidos    IN VARCHAR2,
                              Pv_FechaInicio  IN VARCHAR2,
                              Pv_FechaFin     IN VARCHAR2  )
  RETURN CLOB
  AS
  CURSOR Lc_GetInfoCliente(Pv_FechaInicio VARCHAR2,
                           Pv_FechaFin    VARCHAR2,
                           Pv_RazonSocial VARCHAR2,
                           Pv_Nombres     VARCHAR2,
                           Pv_Apellidos   VARCHAR2
                          )
  IS
         SELECT DISTINCT
         PERSONA.RAZON_SOCIAL AS razonSocial,
         PERSONA.NOMBRES AS nombres,
         PERSONA.APELLIDOS AS apellidos,
         PERSONA.IDENTIFICACION_CLIENTE AS ruc,
         OFICINA.NOMBRE_OFICINA AS oficina,
         CANTON.NOMBRE_CANTON AS canton,
         Pv_FechaInicio AS fechaInicio,
         Pv_FechaFin AS fechaFin
         FROM
         DB_COMERCIAL.INFO_PERSONA PERSONA,
         DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL,
         DB_COMERCIAL.ADMI_ROL ROL,
         DB_COMERCIAL.INFO_OFICINA_GRUPO OFICINA,
         DB_COMERCIAL.ADMI_CANTON CANTON,
         DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPRESA,
         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL PERSONA_ROL
         JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
         ON PUNTO.PERSONA_EMPRESA_ROL_ID = PERSONA_ROL.ID_PERSONA_ROL AND PUNTO.ESTADO ='Activo'
         JOIN DB_COMERCIAL.INFO_SERVICIO SERVICIO
         ON SERVICIO.PUNTO_ID = PUNTO.ID_PUNTO
         AND SERVICIO.ESTADO          = 'Activo'
         JOIN DB_COMERCIAL.ADMI_PRODUCTO PRODUCTO
         ON PRODUCTO.ID_PRODUCTO = SERVICIO.PRODUCTO_ID
         AND PRODUCTO.CLASIFICACION IN ('DATOS','INTERNET')

         WHERE PERSONA.ID_PERSONA       = PERSONA_ROL.PERSONA_ID
         AND PERSONA_ROL.EMPRESA_ROL_ID = EMPRESA_ROL.ID_EMPRESA_ROL
         AND EMPRESA_ROL.ROL_ID         = ROL.ID_ROL
         AND PERSONA_ROL.OFICINA_ID     = OFICINA.ID_OFICINA
         AND OFICINA.CANTON_ID          = CANTON.ID_CANTON
         AND EMPRESA_ROL.EMPRESA_COD    = EMPRESA.COD_EMPRESA
         AND ROL.DESCRIPCION_ROL        = 'Cliente'
         AND EMPRESA_ROL.ESTADO         = 'Activo'
         AND PERSONA_ROL.ESTADO         = 'Activo'
         AND OFICINA.ESTADO             = 'Activo'
         AND (PERSONA.RAZON_SOCIAL      = Pv_RazonSocial 
              OR (PERSONA.NOMBRES        = Pv_Nombres
                  AND PERSONA.APELLIDOS        = Pv_Apellidos));

   Lv_Json          CLOB;

   CURSOR Lc_GetInfoPuntos(
                           Pn_FechaInicial VARCHAR2,
                           Pn_FechaFinal   VARCHAR2,
                           Pv_RazonSocial VARCHAR2,
                           Pv_Nombres     VARCHAR2,
                           Pv_Apellidos   VARCHAR2
                          )
  IS
  SELECT 
  IPU.ID_PUNTO  as puntoId,
  IPU.LOGIN as login,
  DB_SOPORTE.SPKG_GENERACION_SLA.FN_CALCULAR_DISPONIBILIDAD_SLA(
                SUM(NVL(ICTA.TIEMPO_TOTAL_CASO_SOLUCION,0)),
                IPU.ID_PUNTO,
                'consolidado',
                'CAIDA',
                TO_CHAR(TO_DATE(Pn_FechaInicial,'DD/MM/YYYY'),'YYYY-MM-DD'),
                TO_CHAR(TO_DATE(Pn_FechaFinal,'DD/MM/YYYY'),'YYYY-MM-DD')
  ) AS disponibilidad,
            SUM(NVL(ICTA.TIEMPO_TOTAL_CASO_SOLUCION,0)) AS TIEMPOINCIDENCIA 
  FROM
  DB_COMERCIAL.INFO_PERSONA IP
  INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.PERSONA_ID = IP.ID_PERSONA
  INNER JOIN DB_COMERCIAL.INFO_PUNTO IPU ON IPER.ID_PERSONA_ROL = IPU.PERSONA_EMPRESA_ROL_ID
  LEFT JOIN DB_SOPORTE.INFO_PARTE_AFECTADA IPA ON IPU.ID_PUNTO = IPA.AFECTADO_ID 
                                                AND IPA.TIPO_AFECTADO = 'Cliente'
  LEFT JOIN DB_SOPORTE.INFO_DETALLE ID ON IPA.DETALLE_ID = ID.ID_DETALLE
  LEFT JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDH ON IDH.ID_DETALLE_HIPOTESIS = ID.DETALLE_HIPOTESIS_ID
  LEFT JOIN DB_SOPORTE.INFO_CASO IC ON IC.ID_CASO = IDH.CASO_ID
                            AND TRUNC(IC.FE_APERTURA) >= TO_DATE(Pn_FechaInicial,'DD/MM/YYYY')
                            AND TRUNC(IC.FE_APERTURA) <= TO_DATE(Pn_FechaFinal,'DD/MM/YYYY')
  LEFT JOIN DB_SOPORTE.INFO_CASO_HISTORIAL ICH  ON ICH.CASO_ID   = IC.ID_CASO
                                                AND ICH.ESTADO   = 'Cerrado'
  LEFT JOIN DB_SOPORTE.INFO_CASO_TIEMPO_ASIGNACION ICTA ON ICTA.CASO_ID  = IC.ID_CASO               
  WHERE 
  IPER.ESTADO         = 'Activo'
  AND IP.ESTADO       = 'Activo'
  AND NVL(ID.ID_DETALLE,0)   = NVL((SELECT MIN(DET.ID_DETALLE)
                                    FROM DB_SOPORTE.INFO_DETALLE DET
                                    WHERE DET.DETALLE_HIPOTESIS_ID = IDH.ID_DETALLE_HIPOTESIS) ,0)

  AND NVL(ICH.ID_CASO_HISTORIAL,0) IN NVL((SELECT MAX(ID_CASO_HISTORIAL) 
                                          FROM DB_SOPORTE.INFO_CASO_HISTORIAL ICH 
                                          WHERE ICH.CASO_ID = IC.ID_CASO),0)

  AND NVL(ICTA.ID_CASO_TIEMPO_ASIGNACION,0) = NVL((SELECT MIN(ICTA.ID_CASO_TIEMPO_ASIGNACION)
                                                  FROM DB_SOPORTE.INFO_CASO_TIEMPO_ASIGNACION ICTA
                                                  WHERE ICTA.CASO_ID = IC.ID_CASO),0)

  AND (IP.RAZON_SOCIAL = Pv_RazonSocial OR  (IP.NOMBRES = Pv_Nombres AND IP.APELLIDOS = Pv_Apellidos))
  GROUP BY 
  IPU.ID_PUNTO, IPU.LOGIN;

  CURSOR Lc_GetInfoCasos(
                            Pn_PuntoId      NUMBER, 
                            Pv_FechaInicio  VARCHAR2,
                            Pv_FechaFin     VARCHAR2
                          )
  IS

  SELECT 
          CASO.NUMERO_CASO AS numeroCaso,
          TIPO_CASO.NOMBRE_TIPO_CASO AS tipoCaso,
          CASO_ASIGNACION.ASIGNADO_NOMBRE AS departamentoAsignado,
          CASO_ASIGNACION.REF_ASIGNADO_NOMBRE AS asignadoPor,
         ( SELECT USR.NOMBRES || ' ' || USR.APELLIDOS 
          FROM DB_COMERCIAL.INFO_PERSONA USR
          WHERE CASO.USR_CREACION = USR.LOGIN) AS usuarioApertura,
          ( SELECT USR.NOMBRES || ' ' || USR.APELLIDOS 
           FROM DB_COMERCIAL.INFO_PERSONA USR
           WHERE HISTORIAL.USR_CREACION = USR.LOGIN) AS usuarioCierre,
          NIVEL_CRITICIDAD.NOMBRE_NIVEL_CRITICIDAD AS nivelCriticidad,
          'SI' as tareasCreadas,
          CASE (SELECT DETALLE_SOLUCION.ES_SOLUCION 
                FROM DB_SOPORTE.INFO_DETALLE DETALLE_SOLUCION
                WHERE DETALLE_SOLUCION.DETALLE_HIPOTESIS_ID = DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS
                AND DETALLE_SOLUCION.ES_SOLUCION ='S' and rownum<2)
          WHEN 'S' THEN 'SI'
          ELSE 'NO' 
          END as tareasSolucionadas,
          'CERRADO' AS ultimoEstado,
          CASO.TITULO_INI AS tituloInicial,
          HIPOTESIS.NOMBRE_HIPOTESIS AS tituloFinal,
          CASO.FE_APERTURA AS fechaCreacion,
          CASO.FE_CIERRE AS fechaCierre,
          CASO.VERSION_INI AS versionInicial,
          CASO.VERSION_FIN AS versionFinal,
          TIEMPO.TIEMPO_TOTAL AS tiempoTotalCaso,
          TIEMPO.TIEMPO_TOTAL_CASO AS tiempoIncidencia,
          TIEMPO.TIEMPO_EMPRESA_ASIGNADO AS tiempoEmpresa,
          TIEMPO.TIEMPO_CLIENTE_ASIGNADO AS tiempoCliente,
          DETALLE.ID_DETALLE AS detalle,
          CASO.TIPO_AFECTACION as tipoAfectacion
   FROM
     DB_SOPORTE.INFO_CASO CASO,
     DB_SOPORTE.INFO_CASO_HISTORIAL HISTORIAL,
     DB_SOPORTE.INFO_DETALLE DETALLE,
     DB_SOPORTE.INFO_PARTE_AFECTADA PARTE_AFECTADA,
     DB_SOPORTE.INFO_CASO_TIEMPO_ASIGNACION TIEMPO,
     DB_SOPORTE.ADMI_TIPO_CASO TIPO_CASO,
     DB_SOPORTE.ADMI_NIVEL_CRITICIDAD NIVEL_CRITICIDAD,
     DB_COMERCIAL.INFO_PUNTO PUNTO,
     DB_SOPORTE.ADMI_HIPOTESIS HIPOTESIS,
     DB_SOPORTE.INFO_DETALLE_HIPOTESIS DETALLE_HIPOTESIS
     LEFT JOIN  DB_SOPORTE.INFO_CASO_ASIGNACION CASO_ASIGNACION 
     ON CASO_ASIGNACION.DETALLE_HIPOTESIS_ID = DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS
   WHERE  CASO.ID_CASO                         =  DETALLE_HIPOTESIS.CASO_ID
   AND DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS =  DETALLE.DETALLE_HIPOTESIS_ID
   AND DETALLE.ID_DETALLE                     =  PARTE_AFECTADA.DETALLE_ID
   AND CASO.ID_CASO                           = HISTORIAL.CASO_ID
   AND CASO.ID_CASO                           = TIEMPO.CASO_ID
   AND PARTE_AFECTADA.AFECTADO_ID             = Pn_PuntoId
   AND PARTE_AFECTADA.TIPO_AFECTADO           = 'Cliente'
   AND HISTORIAL.ESTADO                       = 'Cerrado'
   AND  TRUNC(CASO.FE_APERTURA)               >= TO_DATE(Pv_FechaInicio,'DD-MM-YY')
   AND  TRUNC(CASO.FE_APERTURA)               <= TO_DATE(Pv_FechaFin,'DD-MM-YY') --to_Date(Pv_FechaFin)
   AND TIPO_CASO.ID_TIPO_CASO                 = CASO.TIPO_CASO_ID
   AND NIVEL_CRITICIDAD.ID_NIVEL_CRITICIDAD   = CASO.NIVEL_CRITICIDAD_ID
   AND PARTE_AFECTADA.AFECTADO_ID             = PUNTO.ID_PUNTO
   AND HIPOTESIS.ID_HIPOTESIS                 = CASO.TITULO_FIN_HIP;


   CURSOR Lc_GetInfoServicios(
                              Pn_DetalleId      NUMBER
                            )
  IS

   SELECT PARTE_AFECTADA.AFECTADO_NOMBRE as afectado
   FROM DB_SOPORTE.INFO_PARTE_AFECTADA PARTE_AFECTADA 
   WHERE PARTE_AFECTADA.TIPO_AFECTADO IN ('Servicio')
   AND PARTE_AFECTADA.DETALLE_ID = Pn_DetalleId;

  Lr_InfoCliente   Lc_GetInfoCliente%ROWTYPE;

  BEGIN

    --
    apex_json.initialize_clob_output;
    apex_json.open_object;
    APEX_JSON.OPEN_ARRAY('result');
    --

    OPEN Lc_GetInfoCliente(Pv_FechaInicio, Pv_FechaFin, Pv_RazonSocial, Pv_Nombres, Pv_Apellidos);
    FETCH Lc_GetInfoCliente INTO Lr_InfoCliente;
    CLOSE Lc_GetInfoCliente;

    IF Lr_InfoCliente.razonSocial IS NOT NULL OR Lr_InfoCliente.nombres IS NOT NULL THEN
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('razonSocial', Lr_InfoCliente.razonSocial);
      APEX_JSON.WRITE('nombres', Lr_InfoCliente.nombres);
      APEX_JSON.WRITE('apellidos', Lr_InfoCliente.apellidos);
      APEX_JSON.WRITE('ruc', Lr_InfoCliente.ruc);
      APEX_JSON.WRITE('oficina', Lr_InfoCliente.oficina);
      APEX_JSON.WRITE('canton', Lr_InfoCliente.canton);
      APEX_JSON.WRITE('fechaInicio', Lr_InfoCliente.fechaInicio);
      APEX_JSON.WRITE('fechaFin', Lr_InfoCliente.fechaFin);
      APEX_JSON.OPEN_ARRAY('puntos');

      FOR Lr_Punto IN Lc_GetInfoPuntos(Pv_FechaInicio,Pv_FechaFin,Lr_InfoCliente.razonSocial,Lr_InfoCliente.nombres,Lr_InfoCliente.apellidos)
      LOOP
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('login', Lr_Punto.login);
        APEX_JSON.WRITE('disponibilidad', Lr_Punto.disponibilidad);
        APEX_JSON.WRITE('tiempoIncidencia', Lr_Punto.tiempoIncidencia);
        APEX_JSON.OPEN_ARRAY('casos');
          FOR Lr_Caso IN Lc_GetInfoCasos(Lr_Punto.puntoId,Pv_FechaInicio, Pv_FechaFin)
          LOOP
          APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE('numeroCaso', Lr_Caso.numeroCaso);
            APEX_JSON.WRITE('tipoCaso', Lr_Caso.tipoCaso);
            APEX_JSON.WRITE('departamentoAsignado', Lr_Caso.departamentoAsignado);
            APEX_JSON.WRITE('asignadoPor', Lr_Caso.asignadoPor);
            APEX_JSON.WRITE('usuarioApertura', Lr_Caso.usuarioApertura);
            APEX_JSON.WRITE('usuarioCierre', Lr_Caso.usuarioCierre);
            APEX_JSON.WRITE('tareasCreadas', Lr_Caso.tareasCreadas);
            APEX_JSON.WRITE('tareasSolucionadas', Lr_Caso.tareasSolucionadas);
            APEX_JSON.WRITE('ultimoEstado', Lr_Caso.ultimoEstado);
            APEX_JSON.WRITE('tituloInicial', Lr_Caso.tituloInicial);
            APEX_JSON.WRITE('tituloFinal', Lr_Caso.tituloFinal);
            APEX_JSON.WRITE('fechaCreacion', Lr_Caso.fechaCreacion);
            APEX_JSON.WRITE('fechaCierre', Lr_Caso.fechaCierre);
            APEX_JSON.WRITE('versionInicial', Lr_Caso.versionInicial);
            APEX_JSON.WRITE('versionFinal', Lr_Caso.versionFinal);
            APEX_JSON.WRITE('tiempoTotalCaso', Lr_Caso.tiempoTotalCaso);
            APEX_JSON.WRITE('tiempoIncidencia', Lr_Caso.tiempoIncidencia);
            APEX_JSON.WRITE('tiempoEmpresa', Lr_Caso.tiempoEmpresa);
            APEX_JSON.WRITE('tiempoCliente', Lr_Caso.tiempoCliente);
            APEX_JSON.WRITE('tipoAfectacion', Lr_Caso.tipoAfectacion);
            APEX_JSON.OPEN_ARRAY('serviciosAfectados');
                FOR Lr_Servicio IN Lc_GetInfoServicios(Lr_Caso.detalle)
                LOOP
                APEX_JSON.OPEN_OBJECT;
                  APEX_JSON.WRITE('producto', Lr_Servicio.afectado);
                  APEX_JSON.CLOSE_OBJECT; 
                END LOOP;
            APEX_JSON.CLOSE_ARRAY();
            APEX_JSON.CLOSE_OBJECT; 
          END LOOP;
          APEX_JSON.CLOSE_ARRAY();
        APEX_JSON.CLOSE_OBJECT; 
      END LOOP;

      APEX_JSON.CLOSE_ARRAY();
      APEX_JSON.CLOSE_OBJECT;

    END IF;

    --
    APEX_JSON.CLOSE_ARRAY();
    APEX_JSON.CLOSE_OBJECT;
    Lv_Json := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;
    --
    RETURN Lv_Json;
    --

EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Lv_Json := 'Ha ocurrido un error inesperado: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      --
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('message', SQLERRM);
      APEX_JSON.WRITE('status', 'fail');
      APEX_JSON.CLOSE_OBJECT;
      Lv_Json := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos-TelcografSLA ',
                                           'SPKG_GENERACION_SLA.FN_CONSULTAR_SLA',
                                           Lv_Json,
                                           NVL(SYS_CONTEXT('USERENV', 'HOST'), 'DB_SOPORTE'),
                                           SYSDATE, 
                                           NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
      RETURN Lv_Json;
  END FN_CONSULTAR_SLA;
----
----
  PROCEDURE P_REPORTE_SLA_CONSOLIDADO(Pcl_Request IN  CLOB,
                                      Pv_Status   OUT VARCHAR2,
                                      Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursor para obtener el correo del usuario quien genera el reporte
    CURSOR C_ObtenerCorreoUsuario(Cv_Estado VARCHAR2,Cv_Login VARCHAR2)
    IS
        SELECT (LISTAGG(NVEE.MAIL_CIA,',')
                WITHIN GROUP (ORDER BY NVEE.MAIL_CIA)) AS VALOR
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS NVEE
        WHERE NVEE.LOGIN_EMPLE   = Cv_Login
          AND UPPER(NVEE.ESTADO) = UPPER(Cv_Estado);

    --Cursor para obtener el valor de configuraci�n
    CURSOR C_ParametrosConfiguracion(Cv_NombreParametro VARCHAR2,Cv_Descripcion VARCHAR2)
    IS
      SELECT APCDET.VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
               DB_GENERAL.ADMI_PARAMETRO_DET APCDET
      WHERE APCAB.ID_PARAMETRO = APCDET.PARAMETRO_ID
        AND APCAB.ESTADO  = 'Activo'
        AND APCDET.ESTADO = 'Activo'
        AND APCAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APCDET.DESCRIPCION     = Cv_Descripcion;

    Lt_JsonIndex        APEX_JSON.T_VALUES;
    Ln_Total            NUMBER;
    Lv_RangoDesde       VARCHAR2(20);
    Lv_RangoHasta       VARCHAR2(20);
    Lv_Usuario          VARCHAR2(50);
    Lv_IpUsuario        VARCHAR2(15);
    Lv_Cliente          VARCHAR2(400);
    Lv_ClienteTitulo    VARCHAR2(300);
    Le_Exception        EXCEPTION;
    Lv_Status           VARCHAR2(50);
    Lv_Mensaje          VARCHAR2(3000);
    Lb_Fexists          BOOLEAN;
    Ln_FileLength       NUMBER;
    Lbi_BlockSize       BINARY_INTEGER;
    Ltl_DisponibilidadCliente Gtl_DisponibilidadCliente;
    Lr_DispCliente      Gr_DisponibilidadCliente;
    Lr_SysRefcursor     SYS_REFCURSOR;
    Ln_Index            NUMBER;
    Lr_Plantilla        DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Codigo           VARCHAR2(30)  :=  ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
    Lv_Extension        VARCHAR2(5)   := '.gz';
    Lv_NombreParametro  VARCHAR2(50)  := 'PARAMETROS_REPORTE_SLA';
    Lv_Remitente        VARCHAR2(500) := 'notificaciones_telcos@telconet.ec';
    Lv_Para             VARCHAR2(500);
    Lv_NombreArchivo    VARCHAR2(300);
    Lv_CodigoPlantilla  VARCHAR2(50);
    Lv_NombreDirectorio VARCHAR2(100);
    Lv_RutaDirectorio   VARCHAR2(100);
    Lv_Plantilla        VARCHAR2(4000);
    Ln_Fila             NUMBER := 5;
    Lcl_Request         CLOB;

  BEGIN

    IF C_ObtenerCorreoUsuario%ISOPEN THEN
        CLOSE C_ObtenerCorreoUsuario;
    END IF;

    IF C_ParametrosConfiguracion%ISOPEN THEN
        CLOSE C_ParametrosConfiguracion;
    END IF;

    Lcl_Request := Pcl_Request;
    APEX_JSON.PARSE(Lt_JsonIndex,Lcl_Request);
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);
    IF Ln_Total IS NULL OR Ln_Total < 1 THEN
      Lv_Mensaje := 'Json request vacio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos los datos principales
    Lv_RangoDesde      := APEX_JSON.GET_VARCHAR2(P_PATH  => 'rangoDesde' , P_VALUES => Lt_JsonIndex);
    Lv_RangoHasta      := APEX_JSON.GET_VARCHAR2(P_PATH  => 'rangoHasta' , P_VALUES => Lt_JsonIndex);
    Lv_Usuario         := APEX_JSON.GET_VARCHAR2(P_PATH  => 'usuario'    , P_VALUES => Lt_JsonIndex);
    Lv_IpUsuario       := APEX_JSON.GET_VARCHAR2(P_PATH  => 'ipUsuario'  , P_VALUES => Lt_JsonIndex);
    Lv_Cliente         := APEX_JSON.GET_VARCHAR2(P_PATH  => 'cliente'    , P_VALUES => Lt_JsonIndex);

    OPEN C_ObtenerCorreoUsuario('A',Lv_Usuario);
        FETCH C_ObtenerCorreoUsuario INTO Lv_Para;
    CLOSE C_ObtenerCorreoUsuario;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,'DIRECTORIO');
      FETCH C_ParametrosConfiguracion INTO Lv_NombreDirectorio;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,'RUTA_DIRECTORIO');
      FETCH C_ParametrosConfiguracion INTO Lv_RutaDirectorio;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,'CODIGO_PLANTILLA');
      FETCH C_ParametrosConfiguracion INTO Lv_CodigoPlantilla;
    CLOSE C_ParametrosConfiguracion;

    --Inicio del proceso.
    DB_SOPORTE.SPKG_GENERACION_SLA.P_OBTENER_DISP_CON_CLIENTE(Lcl_Request,Lr_SysRefcursor,Lv_Status,Lv_Mensaje);
    IF Lr_SysRefcursor IS NULL THEN
      Lv_Status  := NVL(Lv_Status ,'ERROR');
      Lv_Mensaje := NVL(Lv_Mensaje,'No se tiene datos para realizar el reporte.');
      RAISE Le_Exception;
    END IF;

    DB_GENERAL.GNKG_AS_XLSX.CLEAR_WORKBOOK;
    DB_GENERAL.GNKG_AS_XLSX.NEW_SHEET(P_SHEETNAME => 'Reporte Sla');
    DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(1,40);
    DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(2,30);
    DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(3,35);
    DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(4,30);
    DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(5,55);

    --Cabecera del reporte.
    DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
      P_ROW       => 1,
      P_HEIGHT    => 32,
      P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 18, P_NAME => 'LKLUG', P_RGB => '305496'),
      P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'left', P_VERTICAL => 'bottom'),
      P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
    DB_GENERAL.GNKG_AS_XLSX.CELL(1,1,'TELCONET S.A');
    DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,1,5,1);

    --T�tulo del reporte.
    DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
      P_ROW       => 2,
      P_HEIGHT    => 21,
      P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 12, P_NAME => 'LKLUG', P_RGB => '006699'),
      P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'bottom'),
      P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
    DB_GENERAL.GNKG_AS_XLSX.CELL(1,2,'Reporte SLA Consolidado');
    DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,2,5,2);

    Lv_ClienteTitulo := DB_SOPORTE.SPKG_GENERACION_SLA.F_LIMPIAR_CADENA_CARACTERES(Lv_Cliente);
    DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
      P_ROW       => 3,
      P_HEIGHT    => 21,
      P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 12, P_NAME => 'LKLUG', P_RGB => '006699'),
      P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'bottom'),
      P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
    DB_GENERAL.GNKG_AS_XLSX.CELL(1,3,'Cliente : '||Lv_ClienteTitulo);
    DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,3,5,3);

    --Columnas del reporte.
    DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
      P_ROW       => 4,
      P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 10, P_NAME => 'LKLUG', P_RGB => 'FFFFFF'),
      P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
      P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
      P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => '888888'));
    DB_GENERAL.GNKG_AS_XLSX.CELL(1,4,'Punto Sucursal');
    DB_GENERAL.GNKG_AS_XLSX.CELL(2,4,'Login');
    DB_GENERAL.GNKG_AS_XLSX.CELL(3,4,'Porcentaje de Disponibilidad (%)');
    DB_GENERAL.GNKG_AS_XLSX.CELL(4,4,'Minutos Total de Tickets');
    DB_GENERAL.GNKG_AS_XLSX.CELL(5,4,'Casos');

    --Cuerpo del reporte.
    LOOP
      FETCH Lr_SysRefcursor BULK COLLECT INTO Ltl_DisponibilidadCliente LIMIT 1000;
      EXIT WHEN Ltl_DisponibilidadCliente.COUNT() < 1;
      Ln_Index := Ltl_DisponibilidadCliente.FIRST;
      WHILE (Ln_Index IS NOT NULL) LOOP
        Lr_DispCliente := Ltl_DisponibilidadCliente(Ln_Index);
        Ln_Index       := Ltl_DisponibilidadCliente.NEXT(Ln_Index);
        DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
          P_ROW       => Ln_Fila,
          P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => '000000'),
          P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
          P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
          P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
        DB_GENERAL.GNKG_AS_XLSX.CELL(1,Ln_Fila,Lv_ClienteTitulo);
        DB_GENERAL.GNKG_AS_XLSX.CELL(2,Ln_Fila,Lr_DispCliente.LOGIN);
        DB_GENERAL.GNKG_AS_XLSX.CELL(3,Ln_Fila,Lr_DispCliente.DISPONIBILIDAD);
        DB_GENERAL.GNKG_AS_XLSX.CELL(4,Ln_Fila,Lr_DispCliente.TIEMPO_TOTAL);
        DB_GENERAL.GNKG_AS_XLSX.CELL(5,Ln_Fila,Lr_DispCliente.CASOS);
        Ln_Fila := Ln_Fila + 1;
      END LOOP;
    END LOOP;
    CLOSE Lr_SysRefcursor;

    --Observaci�n.
    Ln_Fila := Ln_Fila + 1;
    DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
      P_ROW       => Ln_Fila,
      P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => '006699'),
      P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'left', P_VERTICAL => 'bottom'));
    DB_GENERAL.GNKG_AS_XLSX.CELL(1,Ln_Fila,'Porcentaje promedio del "uptime" desde '||Lv_RangoDesde||' hasta '||Lv_RangoHasta);
    DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,Ln_Fila,3,Ln_Fila);

    Ln_Fila := Ln_Fila + 1;
    DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
      P_ROW       => Ln_Fila,
      P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => '006699'),
      P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'left', P_VERTICAL => 'bottom'));
    DB_GENERAL.GNKG_AS_XLSX.CELL(1,Ln_Fila,'Para poder ver el detalle de los puntos, por favor descargar el Reporte de SLA Detallado.');
    DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,Ln_Fila,3,Ln_Fila);

    Ln_Fila := Ln_Fila + 1;
    DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
      P_ROW       => Ln_Fila,
      P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => '006699'),
      P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'left', P_VERTICAL => 'bottom'));
    DB_GENERAL.GNKG_AS_XLSX.CELL(1,Ln_Fila,'Por favor cualquier duda comunicarse al departamento IPCC 3900111 ext. 8000');
    DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,Ln_Fila,3,Ln_Fila);

    --Fin de la creaci�n del Archivo.
    Lv_NombreArchivo := 'REPORTE_SLA_CONSOLIDADO_DEL_'||Lv_RangoDesde||'_AL_'||Lv_RangoHasta||'.xlsx';
    DB_GENERAL.GNKG_AS_XLSX.SAVE(Lv_NombreDirectorio,Lv_NombreArchivo);

    --Ejecuci�n del comando para crear el archivo comprimido.
    DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND('gzip'||' '||Lv_RutaDirectorio||Lv_NombreArchivo));

    Lr_Plantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_CodigoPlantilla);
    Lv_Plantilla := Lr_Plantilla.PLANTILLA;
    IF Lv_Plantilla IS NULL THEN
      Lv_Plantilla := 'Se adjunta el reporte SLA consolidado para el cliente '||Lv_Cliente||
                     ' desde '||Lv_RangoDesde||' hasta '||Lv_RangoHasta;
    ELSE
      Lv_Plantilla := REPLACE(Lv_Plantilla,'{{tipo_reporte}}','consolidado');
      Lv_Plantilla := REPLACE(Lv_Plantilla,'{{cliente}}'     , Lv_Cliente);
      Lv_Plantilla := REPLACE(Lv_Plantilla,'{{fechaInicio}}' , Lv_RangoDesde);
      Lv_Plantilla := REPLACE(Lv_Plantilla,'{{fechaFin}}'    , Lv_RangoHasta);
    END IF;

    IF Lr_Plantilla.ALIAS_CORREOS IS NOT NULL THEN
      Lv_Remitente := Lr_Plantilla.ALIAS_CORREOS;
    END IF;

    --Env�o del archivo comprimido por correo.
    DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lv_Remitente,
                                              Lv_Para||',',
                                             'REPORTE SLA CONSOLIDADO - '||Lv_Cliente,
                                              Lv_Plantilla,
                                              Lv_NombreDirectorio,
                                              Lv_NombreArchivo||Lv_Extension);

    --Eliminaci�n del archivo xlsx.
    UTL_FILE.FGETATTR(Lv_NombreDirectorio, Lv_NombreArchivo, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
    IF Lb_Fexists THEN
      UTL_FILE.FREMOVE(Lv_NombreDirectorio,Lv_NombreArchivo);
      DBMS_OUTPUT.PUT_LINE('Archivo '||Lv_NombreArchivo||' eliminado.');
    END IF;

    --Eliminaci�n del archivo gz.
    UTL_FILE.FGETATTR(Lv_NombreDirectorio, Lv_NombreArchivo||Lv_Extension, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
    IF Lb_Fexists THEN
      UTL_FILE.FREMOVE(Lv_NombreDirectorio,Lv_NombreArchivo||Lv_Extension);
      DBMS_OUTPUT.PUT_LINE('Archivo '||Lv_NombreArchivo||Lv_Extension||' eliminado.');
    END IF;

    --Mensaje de respuesta
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Proceso ejecutado correctamente.';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := Lv_Status;
      Pv_Mensaje := Lv_Mensaje;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_CON',
                                            Lv_Codigo ||'|Error: '||Lv_Mensaje,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));

      Lcl_Request := SUBSTR(Pcl_Request,0,3000);
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_CON',
                                            Lv_Codigo||'|1- '||Lcl_Request,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));

      Lcl_Request := SUBSTR(Pcl_Request,3001,6000);
      IF Lcl_Request IS NOT NULL THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_CON',
                                            Lv_Codigo||'|2- '||Lcl_Request,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));
      END IF;

      IF Lv_Para IS NULL THEN
        Lv_Para := 'sistemas-soporte@telconet.ec';
      END IF;

      IF Lv_Remitente IS NULL THEN
        Lv_Remitente := 'notificaciones_telcos@telconet.ec';
      END IF;

      Lv_Plantilla := 'Estimado usuario <b>'||Lv_Usuario||'</b>,<br/><br/>'||
                      'El reporte SLA consolidado que se solicit&oacute generar el d&iacute;a <b>'||
                       TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')||'</b>, no se pudo crear.<br/>'  ||
                      'Si el problema persiste por favor comunicar a Sistemas.';

      UTL_MAIL.SEND(SENDER     =>  Lv_Remitente,
                    RECIPIENTS =>  Lv_Para,
                    SUBJECT    => 'REPORTE SLA CONSOLIDADO ERROR - '||Lv_Cliente,
                    MESSAGE    =>  Lv_Plantilla,
                    MIME_TYPE  => 'text/html; charset=UTF-8');

    WHEN OTHERS THEN
      Pv_Status   := 'ERROR';
      Pv_Mensaje  := SUBSTR(SQLERRM ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,200);

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_CON',
                                            Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));

      Lcl_Request := SUBSTR(Pcl_Request,0,3000);
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_CON',
                                            Lv_Codigo||'|1- '||Lcl_Request,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));

      Lcl_Request := SUBSTR(Pcl_Request,3001,6000);
      IF Lcl_Request IS NOT NULL THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_CON',
                                            Lv_Codigo||'|2- '||Lcl_Request,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));
      END IF;

      IF Lv_Para IS NULL THEN
        Lv_Para := 'sistemas-soporte@telconet.ec';
      END IF;

      IF Lv_Remitente IS NULL THEN
        Lv_Remitente := 'notificaciones_telcos@telconet.ec';
      END IF;

      Lv_Plantilla := 'Estimado usuario <b>'||Lv_Usuario||'</b>,<br/><br/>'||
                      'El reporte SLA consolidado que se solicit&oacute generar el d&iacute;a <b>'||
                       TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')||'</b>, no se pudo crear.<br/>'  ||
                      'Si el problema persiste por favor comunicar a Sistemas.';

      UTL_MAIL.SEND(SENDER     =>  Lv_Remitente,
                    RECIPIENTS =>  Lv_Para,
                    SUBJECT    => 'REPORTE SLA CONSOLIDADO ERROR - '||Lv_Cliente,
                    MESSAGE    =>  Lv_Plantilla,
                    MIME_TYPE  => 'text/html; charset=UTF-8');

  END P_REPORTE_SLA_CONSOLIDADO;
----
----
  PROCEDURE P_REPORTE_SLA_DETALLADO(Pcl_Request IN  CLOB,
                                    Pv_Status   OUT VARCHAR2,
                                    Pv_Mensaje  OUT VARCHAR2)
  IS

    --Cursor para obtener el correo del usuario quien genera el reporte
    CURSOR C_ObtenerCorreoUsuario(Cv_Estado VARCHAR2,Cv_Login VARCHAR2)
    IS
        SELECT (LISTAGG(NVEE.MAIL_CIA,',')
                WITHIN GROUP (ORDER BY NVEE.MAIL_CIA)) AS VALOR
            FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS NVEE
        WHERE NVEE.LOGIN_EMPLE   = Cv_Login
          AND UPPER(NVEE.ESTADO) = UPPER(Cv_Estado);

    --Cursor para obtener el valor de configuraci�n
    CURSOR C_ParametrosConfiguracion(Cv_NombreParametro VARCHAR2,Cv_Descripcion VARCHAR2)
    IS
      SELECT APCDET.VALOR1
          FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
               DB_GENERAL.ADMI_PARAMETRO_DET APCDET
      WHERE APCAB.ID_PARAMETRO = APCDET.PARAMETRO_ID
        AND APCAB.ESTADO  = 'Activo'
        AND APCDET.ESTADO = 'Activo'
        AND APCAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APCDET.DESCRIPCION     = Cv_Descripcion;

    Lt_JsonIndex        APEX_JSON.T_VALUES;
    Lv_TipoAfectado     VARCHAR2(50);
    Lv_EstadoCaso       VARCHAR2(50);
    Lv_RangoDesde       VARCHAR2(20);
    Lv_RangoHasta       VARCHAR2(20);
    Lb_VersionOficial   BOOLEAN;
    Lv_Usuario          VARCHAR2(50);
    Lv_IpUsuario        VARCHAR2(15);
    Lv_TipoEnlace       VARCHAR2(200);
    Lv_Cliente          VARCHAR2(500);
    Lv_ClienteTitulo    VARCHAR2(500);
    Lv_NombrePunto      VARCHAR2(1000);
    Ln_Total            NUMBER;
    Le_Exception        EXCEPTION;
    Lv_Status           VARCHAR2(50);
    Lv_Mensaje          VARCHAR2(3000);
    Ln_IndexCon         NUMBER;
    Lr_SysRefcursor     SYS_REFCURSOR;
    Ltl_DisponibilidadCliente Gtl_DisponibilidadCliente;
    Lr_DispCliente      Gr_DisponibilidadCliente;
    Ln_IndexDet         NUMBER;
    Lr_SysRefcursorDet  SYS_REFCURSOR;
    Ltl_DisponibilidadDetCliente Gtl_DisponibilidadDetCliente;
    Lr_DispDetCliente   Gr_DisponibilidadDetCliente;
    Lb_Fexists          BOOLEAN;
    Ln_FileLength       NUMBER;
    Lbi_BlockSize       BINARY_INTEGER;
    Lv_Extension        VARCHAR2(5)  := '.gz';
    Lv_NombreParametro  VARCHAR2(50) := 'PARAMETROS_REPORTE_SLA';
    Lr_Plantilla        DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_Codigo           VARCHAR2(30)  := ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
    Lv_Remitente        VARCHAR2(500) := 'notificaciones_telcos@telconet.ec';
    Lv_Para             VARCHAR2(500);
    Lv_NombreDirectorio VARCHAR2(100);
    Lv_RutaDirectorio   VARCHAR2(100);
    Lv_CodigoPlantilla  VARCHAR2(50);
    Lv_Plantilla        VARCHAR2(4000);
    Lv_NombreArchivo    VARCHAR2(300);
    Ln_NumeroColumnas   NUMBER := 10;
    Ln_ContadorPagina   NUMBER := 0;
    Ln_Fila             NUMBER;
    Lcl_Hipotesis       CLOB;
    Lcl_Request         CLOB;

  BEGIN

    IF C_ObtenerCorreoUsuario%ISOPEN THEN
        CLOSE C_ObtenerCorreoUsuario;
    END IF;

    IF C_ParametrosConfiguracion%ISOPEN THEN
        CLOSE C_ParametrosConfiguracion;
    END IF;

    Lcl_Request := Pcl_Request;
    APEX_JSON.PARSE(Lt_JsonIndex,Lcl_Request);
    Ln_Total := APEX_JSON.GET_COUNT(P_PATH => '.' , P_VALUES => Lt_JsonIndex);
    IF Ln_Total IS NULL OR Ln_Total < 1 THEN
      Lv_Mensaje := 'Json request vacio.';
      RAISE Le_Exception;
    END IF;

    --Obtenemos los datos principales
    Lv_RangoDesde     := APEX_JSON.GET_VARCHAR2(P_PATH  => 'rangoDesde'     , P_VALUES => Lt_JsonIndex);
    Lv_RangoHasta     := APEX_JSON.GET_VARCHAR2(P_PATH  => 'rangoHasta'     , P_VALUES => Lt_JsonIndex);
    Lb_VersionOficial := APEX_JSON.GET_BOOLEAN(P_PATH   => 'versionOficial' , P_VALUES => Lt_JsonIndex);
    Lv_Usuario        := APEX_JSON.GET_VARCHAR2(P_PATH  => 'usuario'        , P_VALUES => Lt_JsonIndex);
    Lv_IpUsuario      := APEX_JSON.GET_VARCHAR2(P_PATH  => 'ipUsuario'      , P_VALUES => Lt_JsonIndex);
    Lv_TipoAfectado   := APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoAfectado'   , P_VALUES => Lt_JsonIndex);
    Lv_EstadoCaso     := APEX_JSON.GET_VARCHAR2(P_PATH  => 'estadoCaso'     , P_VALUES => Lt_JsonIndex);
    Lv_Cliente        := APEX_JSON.GET_VARCHAR2(P_PATH  => 'cliente'        , P_VALUES => Lt_JsonIndex);

    --Se habren los cursores para obtener las informaciones necesarias para completar el flujo del reporte.
    OPEN C_ObtenerCorreoUsuario('A',Lv_Usuario);
        FETCH C_ObtenerCorreoUsuario INTO Lv_Para;
    CLOSE C_ObtenerCorreoUsuario;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,'DIRECTORIO');
      FETCH C_ParametrosConfiguracion INTO Lv_NombreDirectorio;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,'RUTA_DIRECTORIO');
      FETCH C_ParametrosConfiguracion INTO Lv_RutaDirectorio;
    CLOSE C_ParametrosConfiguracion;

    OPEN C_ParametrosConfiguracion(Lv_NombreParametro,'CODIGO_PLANTILLA');
      FETCH C_ParametrosConfiguracion INTO Lv_CodigoPlantilla;
    CLOSE C_ParametrosConfiguracion;

    --Inicio del proceso.
    DB_SOPORTE.SPKG_GENERACION_SLA.P_OBTENER_DISP_CON_CLIENTE(Lcl_Request,Lr_SysRefcursor,Lv_Status,Lv_Mensaje);
    IF Lr_SysRefcursor IS NULL THEN
      Lv_Status  := NVL(Lv_Status ,'ERROR');
      Lv_Mensaje := NVL(Lv_Mensaje,'No se tiene datos para realizar el reporte.');
      RAISE Le_Exception;
    END IF;

    IF Lb_VersionOficial IS NOT NULL AND Lb_VersionOficial THEN
      Ln_NumeroColumnas := Ln_NumeroColumnas + 1;
    END IF;

    DB_GENERAL.GNKG_AS_XLSX.CLEAR_WORKBOOK;

    --Loop Principal.
    LOOP
      FETCH Lr_SysRefcursor BULK COLLECT INTO Ltl_DisponibilidadCliente LIMIT 1000;
      EXIT WHEN Ltl_DisponibilidadCliente.COUNT() < 1;
      Ln_IndexCon := Ltl_DisponibilidadCliente.FIRST;

      WHILE (Ln_IndexCon IS NOT NULL) LOOP

        Lr_DispCliente    := Ltl_DisponibilidadCliente(Ln_IndexCon);
        Ln_IndexCon       := Ltl_DisponibilidadCliente.NEXT(Ln_IndexCon);
        Ln_ContadorPagina := Ln_ContadorPagina + 1;
        Ln_Fila           := 6;

        DB_GENERAL.GNKG_AS_XLSX.NEW_SHEET(P_SHEETNAME => Lr_DispCliente.LOGIN);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(1,15);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(2,15);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(3,25);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(4,22);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(5,22);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(6,20);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(7,20);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(8,25);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(9,20);
        DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(10,45);
        IF Lb_VersionOficial IS NOT NULL AND Lb_VersionOficial THEN
          DB_GENERAL.GNKG_AS_XLSX.SET_COLUMN_WIDTH(11,45);
        END IF;

        --Cabecera del reporte.
        DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
          P_ROW       => 1,
          P_HEIGHT    => 32,
          P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 18, P_NAME => 'LKLUG', P_RGB => '305496'),
          P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'left', P_VERTICAL => 'bottom'),
          P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
        DB_GENERAL.GNKG_AS_XLSX.CELL(1,1,'TELCONET S.A');
        DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,1,Ln_NumeroColumnas,1);

        --T�tulo del reporte.
        DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
          P_ROW       => 2,
          P_HEIGHT    => 21,
          P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 12, P_NAME => 'LKLUG', P_RGB => '006699'),
          P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'bottom'),
          P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
        DB_GENERAL.GNKG_AS_XLSX.CELL(1,2,'Reporte SLA Detallado');
        DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,2,Ln_NumeroColumnas,2);

        Lv_ClienteTitulo := DB_SOPORTE.SPKG_GENERACION_SLA.F_LIMPIAR_CADENA_CARACTERES(Lv_Cliente);
        DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
          P_ROW       => 3,
          P_HEIGHT    => 21,
          P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 12, P_NAME => 'LKLUG', P_RGB => '006699'),
          P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'bottom'),
          P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
        DB_GENERAL.GNKG_AS_XLSX.CELL(1,3,'Cliente : '||Lv_ClienteTitulo);
        DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,3,Ln_NumeroColumnas,3);

        Lv_NombrePunto := DB_SOPORTE.SPKG_GENERACION_SLA.F_LIMPIAR_CADENA_CARACTERES(Lr_DispCliente.NOMBRE_PUNTO);
        DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
          P_ROW       => 4,
          P_HEIGHT    => 21,
          P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 12, P_NAME => 'LKLUG', P_RGB => '006699'),
          P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'bottom'),
          P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
        DB_GENERAL.GNKG_AS_XLSX.CELL(1,4,'"'||Lv_NombrePunto||'"');
        DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(1,4,Ln_NumeroColumnas,4);

        --Columnas del reporte.
        DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
          P_ROW       => 5,
          P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 10, P_NAME => 'LKLUG', P_RGB => 'FFFFFF'),
          P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
          P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
          P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => '888888'));
        DB_GENERAL.GNKG_AS_XLSX.CELL(1,5,'Fecha');
        DB_GENERAL.GNKG_AS_XLSX.CELL(2,5,'Uptime (%)');
        DB_GENERAL.GNKG_AS_XLSX.CELL(3,5,'Tiempo Incidencia (Min.)');
        DB_GENERAL.GNKG_AS_XLSX.CELL(4,5,'Inicio de Incidencia');
        DB_GENERAL.GNKG_AS_XLSX.CELL(5,5,'Fin de Incidencia');
        DB_GENERAL.GNKG_AS_XLSX.CELL(6,5,'Tipo Evento');
        DB_GENERAL.GNKG_AS_XLSX.CELL(7,5,'Numero Caso');
        DB_GENERAL.GNKG_AS_XLSX.CELL(8,5,'Login');
        DB_GENERAL.GNKG_AS_XLSX.CELL(9,5,'T. Enlace');
        DB_GENERAL.GNKG_AS_XLSX.CELL(10,5,'Servicios Afectados');
        IF Lb_VersionOficial IS NOT NULL AND Lb_VersionOficial THEN
          DB_GENERAL.GNKG_AS_XLSX.CELL(11,5,'Version Oficial');
        END IF;

        --Cuerpo del reporte.
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('rangoDesde'   , Lv_RangoDesde);
        APEX_JSON.WRITE('rangoHasta'   , Lv_RangoHasta);
        APEX_JSON.WRITE('tipoAfectado' , Lv_TipoAfectado);
        APEX_JSON.WRITE('estadoCaso'   , Lv_EstadoCaso);
        APEX_JSON.WRITE('idPunto'      , Lr_DispCliente.ID_PUNTO);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        DB_SOPORTE.SPKG_GENERACION_SLA.P_OBTENER_DISP_DET_CLIENTE(Lcl_Request,Lr_SysRefcursorDet,Lv_Status,Lv_Mensaje);
        IF Lr_SysRefcursorDet IS NULL THEN
          Lv_Status  := NVL(Lv_Status ,'ERROR');
          Lv_Mensaje := NVL(Lv_Mensaje,'No se tiene datos para realizar el cuerpo del reporte.');
          RAISE Le_Exception;
        END IF;

        --Loop Secundario.
        LOOP
          FETCH Lr_SysRefcursorDet BULK COLLECT INTO Ltl_DisponibilidadDetCliente LIMIT 1000;
          EXIT WHEN Ltl_DisponibilidadDetCliente.COUNT() < 1;
          Ln_IndexDet := Ltl_DisponibilidadDetCliente.FIRST;

          WHILE (Ln_IndexDet IS NOT NULL) LOOP

            Lr_DispDetCliente := Ltl_DisponibilidadDetCliente(Ln_IndexDet);
            Ln_IndexDet       := Ltl_DisponibilidadDetCliente.NEXT(Ln_IndexDet);
            --Obtener el tipo de enlace afectado.
            Lv_TipoEnlace := NULL;
            IF Lr_DispDetCliente.SERVICIOS_AFECTADOS IS NOT NULL AND
               Lr_DispDetCliente.LOGIN               IS NOT NULL THEN
              APEX_JSON.INITIALIZE_CLOB_OUTPUT;
              APEX_JSON.OPEN_OBJECT;
              APEX_JSON.WRITE('numeroCaso', Lr_DispDetCliente.CASO);
              APEX_JSON.WRITE('login'     , Lr_DispDetCliente.LOGIN);
              APEX_JSON.WRITE('idPunto'   , Lr_DispCliente.ID_PUNTO);
              APEX_JSON.CLOSE_OBJECT;
              Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
              APEX_JSON.FREE_OUTPUT;
              DB_SOPORTE.SPKG_GENERACION_SLA.P_OBTENER_TIPO_ENLACE(Lcl_Request,Lv_TipoEnlace,Lv_Status,Lv_Mensaje);
            END IF;
            DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
              P_ROW       => Ln_Fila,
              P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => '000000'),
              P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
              P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
              P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => 'FFFFFF'));
            DB_GENERAL.GNKG_AS_XLSX.CELL(1,Ln_Fila,Lr_DispDetCliente.FECHA);
            DB_GENERAL.GNKG_AS_XLSX.CELL(2,Ln_Fila,Lr_DispDetCliente.UPTIME);
            DB_GENERAL.GNKG_AS_XLSX.CELL(3,Ln_Fila,Lr_DispDetCliente.MINUTOS);
            DB_GENERAL.GNKG_AS_XLSX.CELL(4,Ln_Fila,Lr_DispDetCliente.INICIO_INDICENCIA);
            DB_GENERAL.GNKG_AS_XLSX.CELL(5,Ln_Fila,Lr_DispDetCliente.FIN_INCIDENCIA);
            DB_GENERAL.GNKG_AS_XLSX.CELL(6,Ln_Fila,Lr_DispDetCliente.AFECTACION);
            DB_GENERAL.GNKG_AS_XLSX.CELL(7,Ln_Fila,Lr_DispDetCliente.CASO);
            DB_GENERAL.GNKG_AS_XLSX.CELL(8,Ln_Fila,Lr_DispDetCliente.LOGIN);
            DB_GENERAL.GNKG_AS_XLSX.CELL(9,Ln_Fila,Lv_TipoEnlace);
            DB_GENERAL.GNKG_AS_XLSX.CELL(10,Ln_Fila,Lr_DispDetCliente.SERVICIOS_AFECTADOS);
            IF Lb_VersionOficial IS NOT NULL AND Lb_VersionOficial THEN
              Lcl_Hipotesis := DB_SOPORTE.SPKG_GENERACION_SLA.F_LIMPIAR_CADENA_CARACTERES(Lr_DispDetCliente.HIPOTESIS);
              DB_GENERAL.GNKG_AS_XLSX.CELL(11,Ln_Fila,Lcl_Hipotesis);
            END IF;
            Ln_Fila := Ln_Fila + 1;
          END LOOP;
        END LOOP;
        CLOSE Lr_SysRefcursorDet;

      --Observaci�n.
      DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
          P_ROW       => Ln_Fila,
          P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => 'FFFFFF'),
          P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'bottom'));
      DB_GENERAL.GNKG_AS_XLSX.CELL(1,Ln_Fila,'Pag. '||Ln_ContadorPagina);

      DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
        P_ROW       => Ln_Fila,
        P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 10, P_NAME => 'LKLUG', P_RGB => 'FFFFFF'),
        P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
        P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
        P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => '888888'));
      DB_GENERAL.GNKG_AS_XLSX.CELL(2,Ln_Fila,Lr_DispCliente.DISPONIBILIDAD);

      DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
        P_ROW       => Ln_Fila,
        P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => FALSE, P_FONTSIZE => 10, P_NAME => 'LKLUG', P_RGB => 'FFFFFF'),
        P_BORDERID  => DB_GENERAL.GNKG_AS_XLSX.GET_BORDER('thin','thin','thin','thin'),
        P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'center'),
        P_FILLID    => DB_GENERAL.GNKG_AS_XLSX.GET_FILL(P_PATTERNTYPE => 'solid',P_FGRGB => '888888'));
      DB_GENERAL.GNKG_AS_XLSX.CELL(3,Ln_Fila,Lr_DispCliente.TIEMPO_TOTAL);

      DB_GENERAL.GNKG_AS_XLSX.SET_ROW(
        P_ROW       => Ln_Fila,
        P_FONTID    => DB_GENERAL.GNKG_AS_XLSX.GET_FONT(P_BOLD => TRUE, P_FONTSIZE => 8, P_NAME => 'LKLUG', P_RGB => '006699'),
        P_ALIGNMENT => DB_GENERAL.GNKG_AS_XLSX.GET_ALIGNMENT(P_HORIZONTAL => 'center', P_VERTICAL => 'bottom'));
      DB_GENERAL.GNKG_AS_XLSX.CELL(4,Ln_Fila,'Porcentaje promedio del "uptime" desde '||Lv_RangoDesde||' hasta '||Lv_RangoHasta);
      DB_GENERAL.GNKG_AS_XLSX.MERGECELLS(4,Ln_Fila,7,Ln_Fila);

      END LOOP;
    END LOOP;
    CLOSE Lr_SysRefcursor;

    --Fin de la creaci�n del Archivo.
    Lv_NombreArchivo := 'REPORTE_SLA_DETALLADO_DEL_'||Lv_RangoDesde||'_AL_'||Lv_RangoHasta||'.xlsx';
    DB_GENERAL.GNKG_AS_XLSX.SAVE(Lv_NombreDirectorio,Lv_NombreArchivo);

    --Ejecuci�n del comando para crear el archivo comprimido.
    DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND('gzip'||' '||Lv_RutaDirectorio||Lv_NombreArchivo));

    Lr_Plantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_CodigoPlantilla);
    Lv_Plantilla := Lr_Plantilla.PLANTILLA;
    IF Lv_Plantilla IS NULL THEN
      Lv_Plantilla := 'Se adjunta el reporte SLA detallado para el cliente '||Lv_Cliente||
                     ' desde '||Lv_RangoDesde||' hasta '||Lv_RangoHasta;
    ELSE
      Lv_Plantilla := REPLACE(Lv_Plantilla,'{{tipo_reporte}}','detallado');
      Lv_Plantilla := REPLACE(Lv_Plantilla,'{{cliente}}'     , Lv_Cliente);
      Lv_Plantilla := REPLACE(Lv_Plantilla,'{{fechaInicio}}' , Lv_RangoDesde);
      Lv_Plantilla := REPLACE(Lv_Plantilla,'{{fechaFin}}'    , Lv_RangoHasta);
    END IF;

    IF Lr_Plantilla.ALIAS_CORREOS IS NOT NULL THEN
      Lv_Remitente := Lr_Plantilla.ALIAS_CORREOS;
    END IF;

    --Env�o del archivo comprimido por correo.
    DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lv_Remitente,
                                              Lv_Para||',',
                                             'REPORTE SLA DETALLADO - '||Lv_Cliente,
                                              Lv_Plantilla,
                                              Lv_NombreDirectorio,
                                              Lv_NombreArchivo||Lv_Extension);

    --Eliminaci�n del archivo xlsx.
    UTL_FILE.FGETATTR(Lv_NombreDirectorio, Lv_NombreArchivo, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
    IF Lb_Fexists THEN
      UTL_FILE.FREMOVE(Lv_NombreDirectorio,Lv_NombreArchivo);
      DBMS_OUTPUT.PUT_LINE('Archivo '||Lv_NombreArchivo||' eliminado.');
    END IF;

    --Eliminaci�n del archivo gz.
    UTL_FILE.FGETATTR(Lv_NombreDirectorio, Lv_NombreArchivo||Lv_Extension, Lb_Fexists, Ln_FileLength, Lbi_BlockSize);
    IF Lb_Fexists THEN
      UTL_FILE.FREMOVE(Lv_NombreDirectorio,Lv_NombreArchivo||Lv_Extension);
      DBMS_OUTPUT.PUT_LINE('Archivo '||Lv_NombreArchivo||Lv_Extension||' eliminado.');
    END IF;

    --Mensaje de respuesta
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Proceso ejecutado correctamente.';

  EXCEPTION
    WHEN Le_Exception THEN
      Pv_Status  := Lv_Status;
      Pv_Mensaje := Lv_Mensaje;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_DET',
                                            Lv_Codigo ||'|Error: '||Lv_Mensaje,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));

      Lcl_Request := SUBSTR(Pcl_Request,0,3000);
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_DET',
                                            Lv_Codigo||'|1- '||Lcl_Request,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));

      Lcl_Request := SUBSTR(Pcl_Request,3001,6000);
      IF Lcl_Request IS NOT NULL THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_DET',
                                            Lv_Codigo||'|2- '||Lcl_Request,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));
      END IF;

      IF Lv_Para IS NULL THEN
        Lv_Para := 'sistemas-soporte@telconet.ec';
      END IF;

      IF Lv_Remitente IS NULL THEN
        Lv_Remitente := 'notificaciones_telcos@telconet.ec';
      END IF;

      Lv_Plantilla := 'Estimado usuario <b>'||Lv_Usuario||'</b>,<br/><br/>'||
                      'El reporte SLA detallado que se solicit&oacute generar el d&iacute;a <b>'||
                       TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')||'</b>, no se pudo crear.<br/>'||
                      'Si el problema persiste por favor comunicar a Sistemas.';

      UTL_MAIL.SEND(SENDER     =>  Lv_Remitente,
                    RECIPIENTS =>  Lv_Para,
                    SUBJECT    => 'REPORTE SLA DETALLADO ERROR - '||Lv_Cliente,
                    MESSAGE    =>  Lv_Plantilla,
                    MIME_TYPE  => 'text/html; charset=UTF-8');

    WHEN OTHERS THEN
      Pv_Status   := 'ERROR';
      Pv_Mensaje  := SUBSTR(SQLERRM ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,200);

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_DET',
                                            Lv_Codigo ||'|Error: ' || SQLCODE || ' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));

      Lcl_Request := SUBSTR(Pcl_Request,0,3000);
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_DET',
                                            Lv_Codigo||'|1- '||Lcl_Request,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));

      Lcl_Request := SUBSTR(Pcl_Request,3001,6000);
      IF Lcl_Request IS NOT NULL THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SPKG_GENERACION_SLA',
                                           'P_REPORTE_SLA_DET',
                                            Lv_Codigo||'|2- '||Lcl_Request,
                                            NVL(Lv_Usuario, 'DB_SOPORTE'),
                                            SYSDATE,
                                            NVL(Lv_IpUsuario,NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')));
      END IF;

      IF Lv_Para IS NULL THEN
        Lv_Para := 'sistemas-soporte@telconet.ec';
      END IF;

      IF Lv_Remitente IS NULL THEN
        Lv_Remitente := 'notificaciones_telcos@telconet.ec';
      END IF;

      Lv_Plantilla := 'Estimado usuario <b>'||Lv_Usuario||'</b>,<br/><br/>'||
                      'El reporte SLA detallado que se solicit&oacute generar el d&iacute;a <b>'||
                       TO_CHAR(SYSDATE,'RRRR-MM-DD HH24:MI:SS')||'</b>, no se pudo crear.<br/>'||
                      'Si el problema persiste por favor comunicar a Sistemas.';

      UTL_MAIL.SEND(SENDER     =>  Lv_Remitente,
                    RECIPIENTS =>  Lv_Para,
                    SUBJECT    => 'REPORTE SLA DETALLADO ERROR - '||Lv_Cliente,
                    MESSAGE    =>  Lv_Plantilla,
                    MIME_TYPE  => 'text/html; charset=UTF-8');

  END P_REPORTE_SLA_DETALLADO;
----
----
  PROCEDURE P_OBTENER_DISP_CON_CLIENTE(Pcl_Request    IN CLOB,
                                       Pr_DispCliente OUT SYS_REFCURSOR,
                                       Pv_Status      OUT VARCHAR2,
                                       Pv_Mensaje     OUT VARCHAR2)
  IS

    Lt_JsonIndex         APEX_JSON.T_VALUES;
    Lv_RangoDesde        VARCHAR2(50);
    Lv_RangoHasta        VARCHAR2(50);
    Lv_TipoAfectado      VARCHAR2(50);
    Lv_EstadoCaso        VARCHAR2(50);
    Lv_EstadoPunto       VARCHAR2(50);
    Lv_TipoReporte       VARCHAR2(50);
    Lv_TipoAfectacion    VARCHAR2(50);
    Lv_SinTipoAfectacion VARCHAR2(50);
    Lv_Puntos            VARCHAR2(4000);
    Lb_GeneracionTotal   BOOLEAN;
    Lv_RazonSocial       VARCHAR2(250);
    Lv_Nombres           VARCHAR2(125);
    Lv_Apellidos         VARCHAR2(125);
    Lv_Identificacion    VARCHAR2(50);
    Lv_TipoRol           VARCHAR2(50);
    Lv_Empresa           VARCHAR2(50);
    Lv_Producto          VARCHAR2(50);
    Lv_Oficina           VARCHAR2(50);
    Lcl_Select           CLOB;
    Lcl_From             CLOB;
    Lcl_Where            CLOB;
    Lcl_Query            CLOB;
    Lcl_Union            CLOB;
    Lcl_Where2           CLOB;
    Lcl_Where3           CLOB;
    Lcl_Where4           CLOB;

  BEGIN

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);
    Lv_RangoDesde        := APEX_JSON.GET_VARCHAR2(P_PATH  => 'rangoDesde'        , P_VALUES => Lt_JsonIndex);
    Lv_RangoHasta        := APEX_JSON.GET_VARCHAR2(P_PATH  => 'rangoHasta'        , P_VALUES => Lt_JsonIndex);
    Lv_TipoAfectado      := APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoAfectado'      , P_VALUES => Lt_JsonIndex);
    Lv_EstadoCaso        := APEX_JSON.GET_VARCHAR2(P_PATH  => 'estadoCaso'        , P_VALUES => Lt_JsonIndex);
    Lv_EstadoPunto       := APEX_JSON.GET_VARCHAR2(P_PATH  => 'estadoPunto'       , P_VALUES => Lt_JsonIndex);
    Lv_TipoReporte       := APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoReporte'       , P_VALUES => Lt_JsonIndex);
    Lv_TipoAfectacion    := APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoAfectacion'    , P_VALUES => Lt_JsonIndex);
    Lv_SinTipoAfectacion := APEX_JSON.GET_VARCHAR2(P_PATH  => 'sinTipoAfectacion' , P_VALUES => Lt_JsonIndex);
    Lv_Puntos            := APEX_JSON.GET_VARCHAR2(P_PATH  => 'puntos'            , P_VALUES => Lt_JsonIndex);
    Lb_GeneracionTotal   := APEX_JSON.GET_BOOLEAN(P_PATH   => 'generacionTotal'   , P_VALUES => Lt_JsonIndex);
    Lv_RazonSocial       := APEX_JSON.GET_VARCHAR2(P_PATH  => 'razonSocial'       , P_VALUES => Lt_JsonIndex);
    Lv_Nombres           := APEX_JSON.GET_VARCHAR2(P_PATH  => 'nombres'           , P_VALUES => Lt_JsonIndex);
    Lv_Apellidos         := APEX_JSON.GET_VARCHAR2(P_PATH  => 'apellidos'         , P_VALUES => Lt_JsonIndex);
    Lv_Identificacion    := APEX_JSON.GET_VARCHAR2(P_PATH  => 'identificacion'    , P_VALUES => Lt_JsonIndex);
    Lv_TipoRol           := APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoRol'           , P_VALUES => Lt_JsonIndex);
    Lv_Empresa           := APEX_JSON.GET_VARCHAR2(P_PATH  => 'empresa'           , P_VALUES => Lt_JsonIndex);
    Lv_Producto          := APEX_JSON.GET_VARCHAR2(P_PATH  => 'producto'          , P_VALUES => Lt_JsonIndex);
    Lv_Oficina           := APEX_JSON.GET_VARCHAR2(P_PATH  => 'oficina'           , P_VALUES => Lt_JsonIndex);

    Lcl_Select :=
      'SELECT '||
        'NVL(PERSONA.RAZON_SOCIAL,PERSONA.NOMBRES||'' ''|| PERSONA.APELLIDOS) CLIENTE,'||
        'PUNTO.ID_PUNTO,'    ||
        'PUNTO.LOGIN,'       ||
        'PUNTO.NOMBRE_PUNTO,'||
        'DB_SOPORTE.SPKG_GENERACION_SLA.FN_CALCULAR_DISPONIBILIDAD_SLA(SUM(NVL(TIEMPO.TIEMPO_TOTAL_CASO_SOLUCION,0)),'||
          'PUNTO.ID_PUNTO,:tipoReporte,:tipoAfectacion,:desde,:hasta) DISPONIBILIDAD,'||
        'SUM(NVL(TIEMPO.TIEMPO_TOTAL_CASO_SOLUCION,0)) TIEMPO_TOTAL,'||
        'DB_SOPORTE.SPKG_GENERACION_SLA.FN_GET_CASOS_CLIENTE_SLA(PUNTO.ID_PUNTO,:desde,:hasta) CASOS ';

    Lcl_Select := REPLACE(Lcl_Select,':tipoReporte',''''   ||Lv_TipoReporte   ||'''');
    Lcl_Select := REPLACE(Lcl_Select,':tipoAfectacion',''''||Lv_TipoAfectacion||'''');
    Lcl_Select := REPLACE(Lcl_Select,':desde',''''         ||Lv_RangoDesde    ||'''');
    Lcl_Select := REPLACE(Lcl_Select,':hasta',''''         ||Lv_RangoHasta    ||'''');

    Lcl_From :=
      'FROM '||
        'DB_COMERCIAL.INFO_PUNTO PUNTO '||
        'LEFT JOIN (SELECT distinct(PUNTO_ID), ESTADO FROM DB_COMERCIAL.INFO_SERVICIO) SERVICIO on SERVICIO.PUNTO_ID = PUNTO.ID_PUNTO ' ||
        'LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL = PUNTO.PERSONA_EMPRESA_ROL_ID ' ||
        'LEFT JOIN DB_COMERCIAL.INFO_PERSONA PERSONA ON PERSONA.ID_PERSONA = IPER.PERSONA_ID '||
        'LEFT JOIN ' ||
        '(SELECT DISTINCT IDE.ID_DETALLE, IDE.DETALLE_HIPOTESIS_ID, IPA.AFECTADO_ID FROM DB_SOPORTE.INFO_PARTE_AFECTADA IPA ' ||
        'LEFT JOIN DB_SOPORTE.INFO_DETALLE IDE  ON IPA.DETALLE_ID = IDE.ID_DETALLE WHERE IPA.TIPO_AFECTADO = :tipoAfectado ' ||
        ') DETALLE ON PUNTO.ID_PUNTO = DETALLE.AFECTADO_ID ' ||
        'LEFT JOIN DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDH ON IDH.ID_DETALLE_HIPOTESIS  = DETALLE.DETALLE_HIPOTESIS_ID '||
        'LEFT JOIN DB_SOPORTE.INFO_CASO CASO ON CASO.ID_CASO = IDH.CASO_ID '||
          'AND TO_CHAR(CASO.FE_APERTURA,''RRRR-MM-DD'') >= :rangoDesde '    ||
          'AND TO_CHAR(CASO.FE_APERTURA,''RRRR-MM-DD'') <= :rangoHasta '   ||
          'AND CASO.TIPO_AFECTACION != :sinTipoAfectacion '||
        'LEFT JOIN DB_SOPORTE.INFO_CASO_HISTORIAL HISTORIAL ON HISTORIAL.CASO_ID = CASO.ID_CASO '||
          'AND HISTORIAL.ESTADO = :estadoCaso '||
        'LEFT JOIN DB_SOPORTE.INFO_CASO_TIEMPO_ASIGNACION TIEMPO ON TIEMPO.CASO_ID = CASO.ID_CASO ';

    Lcl_From := REPLACE(Lcl_From,':estadoCaso',''''       ||Lv_EstadoCaso       ||'''');
    Lcl_From := REPLACE(Lcl_From,':sinTipoAfectacion',''''||Lv_SinTipoAfectacion||'''');
    Lcl_From := REPLACE(Lcl_From,':rangoDesde',''''       ||Lv_RangoDesde       ||'''');
    Lcl_From := REPLACE(Lcl_From,':rangoHasta',''''       ||Lv_RangoHasta       ||'''');
    Lcl_From := REPLACE(Lcl_From,':tipoAfectado',''''     ||Lv_TipoAfectado     ||'''');

    Lcl_Where4 := 'WHERE 1 = 1 ';

    IF Lb_GeneracionTotal IS NULL OR NOT Lb_GeneracionTotal THEN

      Lcl_Where := Lcl_Where||'AND PUNTO.ID_PUNTO IN (:puntos) ';
      Lcl_Where := REPLACE(Lcl_Where,':puntos',Lv_Puntos);

      IF Lv_EstadoPunto = 'Activo' THEN

        Lcl_Where := Lcl_Where||'AND PUNTO.ESTADO = :estadoPunto  AND SERVICIO.ESTADO = :estadoPunto ';
        Lcl_Where := REPLACE(Lcl_Where,':estadoPunto',''''||Lv_EstadoPunto||'''');

      END IF;


    ELSE

      Lcl_From := Lcl_From||
        'LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EMPRESA_ROL ON EMPRESA_ROL.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID '||
        'LEFT JOIN DB_GENERAL.ADMI_ROL ROL ON ROL.ID_ROL = EMPRESA_ROL.ROL_ID '||
        'LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO OFICINA ON OFICINA.ID_OFICINA = IPER.OFICINA_ID '||
        'LEFT JOIN DB_GENERAL.ADMI_TIPO_ROL TIPO_ROL ON TIPO_ROL.ID_TIPO_ROL = ROL.TIPO_ROL_ID '||
          'AND TIPO_ROL.DESCRIPCION_TIPO_ROL = :tipoRol ';
      
      Lcl_From := REPLACE(Lcl_From,':tipoRol',''''||Lv_TipoRol||'''');


      IF Lv_EstadoPunto IS NOT NULL AND Lv_EstadoPunto != 'Todos' THEN
        Lcl_Where := Lcl_Where||'AND PUNTO.ESTADO = :estadoPunto ';
        Lcl_Where := REPLACE(Lcl_Where,':estadoPunto',''''||Lv_EstadoPunto||'''');
      ELSE
        Lcl_Where3 := Lcl_Where3||'AND PUNTO.ESTADO IN (''Cancelado'',''In-Corte'')  ';
        Lcl_Where2 := Lcl_Where2|| 'AND PUNTO.ESTADO IN (''Activo'') AND SERVICIO.ESTADO IN (''Activo'')  ';
      END IF;

      Lcl_Where := Lcl_Where||' AND EMPRESA_ROL.EMPRESA_COD = :empresa ';

      Lcl_Where := REPLACE(Lcl_Where,':empresa',''''||Lv_Empresa||'''');

      IF Lv_EstadoPunto = 'Activo' THEN

        Lcl_Where := Lcl_Where||'AND SERVICIO.ESTADO = :estadoPunto ';
        Lcl_Where := REPLACE(Lcl_Where,':estadoPunto',''''||Lv_EstadoPunto||'''');

      END IF; 

      IF Lv_Oficina IS NOT NULL THEN
        Lcl_Where := Lcl_Where||'AND OFICINA.ID_OFICINA = :oficina ';
        Lcl_Where := REPLACE(Lcl_Where,':oficina',Lv_Oficina);
      END IF;

      IF Lv_RazonSocial IS NOT NULL THEN
        Lcl_Where := Lcl_Where||'AND UPPER(PERSONA.RAZON_SOCIAL) LIKE UPPER(:razonSocial) ';
        Lcl_Where := REPLACE(Lcl_Where,':razonSocial','''%'||Lv_RazonSocial||'%''');
      END IF;

      IF Lv_Nombres IS NOT NULL THEN
        Lcl_Where := Lcl_Where||'AND UPPER(PERSONA.NOMBRES) LIKE UPPER(:nombres) ';
        Lcl_Where := REPLACE(Lcl_Where,':nombres','''%'||Lv_Nombres||'%''');
      END IF;

      IF Lv_Apellidos IS NOT NULL THEN
        Lcl_Where := Lcl_Where||'AND UPPER(PERSONA.APELLIDOS) LIKE UPPER(:apellidos) ';
        Lcl_Where := REPLACE(Lcl_Where,':apellidos','''%'||Lv_Apellidos||'%''');
      END IF;

      IF Lv_Identificacion IS NOT NULL THEN
        Lcl_Where := Lcl_Where||'AND PERSONA.IDENTIFICACION_CLIENTE = :identificacion ';
        Lcl_Where := REPLACE(Lcl_Where,':identificacion',''''||Lv_Identificacion||'''');
      END IF;

    END IF;


    IF(Lv_EstadoPunto  = 'Todos' ) THEN

         Lcl_Union := Lcl_Union || ' UNION ALL ';

    END IF;


    Lcl_Where := Lcl_Where      ||
      'GROUP BY '               ||
        'PUNTO.ID_PUNTO, '      ||
        'PUNTO.LOGIN, '         ||
        'PUNTO.NOMBRE_PUNTO,'   ||
        'PERSONA.RAZON_SOCIAL, '||
        'PERSONA.NOMBRES, '     ||
        'PERSONA.APELLIDOS';


    IF(Lv_EstadoPunto  = 'Todos' ) THEN

      Lcl_Query := Lcl_Select||Lcl_From||Lcl_Where4||Lcl_Where3||Lcl_Where||Lcl_Union||Lcl_Select||Lcl_From||Lcl_Where4||Lcl_Where2||Lcl_Where;

    ELSE
      Lcl_Query := Lcl_Select||Lcl_From||Lcl_Where4||Lcl_Where;
    END IF;


    DBMS_OUTPUT.PUT_LINE(Lcl_Query);
    OPEN Pr_DispCliente FOR Lcl_Query;
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacci�n exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status      := 'ERROR';
      Pv_Mensaje     :=  SUBSTR(SQLERRM ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,200);
      Pr_DispCliente :=  NULL;
  END P_OBTENER_DISP_CON_CLIENTE;
----
----
  PROCEDURE P_OBTENER_DISP_DET_CLIENTE(Pcl_Request       IN  CLOB,
                                       Pr_DispDetCliente OUT SYS_REFCURSOR,
                                       Pv_Status         OUT VARCHAR2,
                                       Pv_Mensaje        OUT VARCHAR2)
  IS

    Lt_JsonIndex     APEX_JSON.T_VALUES;
    Lv_RangoDesde    VARCHAR2(50);
    Lv_RangoHasta    VARCHAR2(50);
    Lv_TipoAfectado  VARCHAR2(50);
    Lv_EstadoCaso    VARCHAR2(50);
    Ln_IdPunto       NUMBER;
    Lcl_Select       CLOB;
    Lcl_From         CLOB;
    Lcl_Where        CLOB;
    Lcl_Query        CLOB;

  BEGIN

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);
    Lv_RangoDesde   := APEX_JSON.GET_VARCHAR2(P_PATH  => 'rangoDesde'   , P_VALUES => Lt_JsonIndex);
    Lv_RangoHasta   := APEX_JSON.GET_VARCHAR2(P_PATH  => 'rangoHasta'   , P_VALUES => Lt_JsonIndex);
    Lv_TipoAfectado := APEX_JSON.GET_VARCHAR2(P_PATH  => 'tipoAfectado' , P_VALUES => Lt_JsonIndex);
    Lv_EstadoCaso   := APEX_JSON.GET_VARCHAR2(P_PATH  => 'estadoCaso'   , P_VALUES => Lt_JsonIndex);
    Ln_IdPunto      := APEX_JSON.GET_NUMBER(P_PATH    => 'idPunto'      , P_VALUES => Lt_JsonIndex);

    Lcl_Select :=
      'SELECT '||
        'TRUNC(RANGO.RANGO) RANGO, '||
        'TO_CHAR(RANGO.RANGO,''RRRR-MM-DD'') FECHA, '||
        'CASE '||
          'WHEN RESUMEN.TIPO_AFECTACION = ''SINAFECTACION'' '||
          'THEN ''100'' '||
          'ELSE '||
          'DB_SOPORTE.SPKG_GENERACION_SLA.FN_REPORTE_DETALLADO_SLA(RESUMEN.TIEMPO,:rangoDesde,:rangoHasta, '||
            'RESUMEN.FE_APERTURA,RESUMEN.FE_SOLUCION,''uptime'',RESUMEN.TIPO_AFECTACION,RANGO.RANGO) '||
        'END UPTIME, '||
        'CASE WHEN RESUMEN.TIPO_AFECTACION = ''SINAFECTACION'' '||
          'THEN ''0'' '||
          'ELSE '||
          'DB_SOPORTE.SPKG_GENERACION_SLA.FN_REPORTE_DETALLADO_SLA(RESUMEN.TIEMPO,:rangoDesde,:rangoHasta, '||
            'RESUMEN.FE_APERTURA,RESUMEN.FE_SOLUCION,''minutos'',RESUMEN.TIPO_AFECTACION,RANGO) '||
        'END MINUTOS, '||
        'DB_SOPORTE.SPKG_GENERACION_SLA.FN_REPORTE_DETALLADO_SLA(RESUMEN.TIEMPO,:rangoDesde,:rangoHasta, '||
          'RESUMEN.FE_APERTURA,RESUMEN.FE_SOLUCION,''inicioIncidencia'',RESUMEN.TIPO_AFECTACION,RANGO) INICIO_INDICENCIA, '||
        'DB_SOPORTE.SPKG_GENERACION_SLA.FN_REPORTE_DETALLADO_SLA(RESUMEN.TIEMPO,:rangoDesde,:rangoHasta, '||
          'RESUMEN.FE_APERTURA,RESUMEN.FE_SOLUCION,''finIncidencia'',RESUMEN.TIPO_AFECTACION,RANGO) FIN_INCIDENCIA, '||
        'CASE '||
          'WHEN RANGO.RANGO = TRUNC(RESUMEN.FE_APERTURA) OR RANGO.RANGO = TRUNC(RESUMEN.FE_SOLUCION) '||
          'THEN NVL(CASE WHEN RESUMEN.TIPO_AFECTACION = ''SINAFECTACION'' '||
                    'THEN ''SIN AFECTACION'' '||
                    'ELSE RESUMEN.TIPO_AFECTACION '||
                   'END,''CAIDA'') '||
          'ELSE NULL '||
        'END AFECTACION, '||
        'CASE '||
          'WHEN RANGO.RANGO = TRUNC(RESUMEN.FE_APERTURA) OR RANGO.RANGO = TRUNC(RESUMEN.FE_SOLUCION) '||
          'THEN RESUMEN.NUMERO_CASO '||
          'ELSE NULL '||
        'END CASO, '||
        'CASE '||
          'WHEN RANGO.RANGO = TRUNC(RESUMEN.FE_APERTURA) OR RANGO.RANGO = TRUNC(RESUMEN.FE_SOLUCION) '||
          'THEN RESUMEN.LOGIN '||
          'ELSE NULL '||
        'END LOGIN, '||
        'CASE '||
          'WHEN RANGO.RANGO = TRUNC(RESUMEN.FE_APERTURA) OR RANGO.RANGO = TRUNC(RESUMEN.FE_SOLUCION) '||
          'THEN DB_SOPORTE.SPKG_GENERACION_SLA.FN_GET_SERVICIO_CLIENTE_SLA(RESUMEN.ID_PUNTO,RESUMEN.SERVICIO_AFECTADO) '||
          'ELSE NULL '||
        'END SERVICIOS_AFECTADOS, '||
        'CASE '||
          'WHEN RANGO.RANGO = TRUNC(RESUMEN.FE_APERTURA) OR RANGO.RANGO = TRUNC(RESUMEN.FE_SOLUCION) '||
          'THEN RESUMEN.DESCRIPCION_HIPOTESIS '||
          'ELSE NULL '||
        'END HIPOTESIS ';

    Lcl_Select := REPLACE(Lcl_Select,':rangoDesde',''''||Lv_RangoDesde||'''');
    Lcl_Select := REPLACE(Lcl_Select,':rangoHasta',''''||Lv_RangoHasta||'''');

    Lcl_From :=
      'FROM '||
        '(SELECT TO_DATE(:rangoDesde,''YYYY-MM-DD'') + ROWNUM -1 RANGO FROM DUAL '||
         'CONNECT BY LEVEL <= TO_DATE(:rangoHasta,''YYYY-MM-DD'') - TO_DATE(:rangoDesde,''YYYY-MM-DD'') + 1 '||
        ') RANGO '||
        'LEFT JOIN ( '||
          'SELECT '||
            'CASO.FE_APERTURA, '||
            'CASO.TIPO_AFECTACION, '||
            'TIEMPO.TIEMPO_TOTAL_CASO_SOLUCION TIEMPO, '||
            'CASO.NUMERO_CASO, '||
            'PUNTO.LOGIN, '||
            'PUNTO.ID_PUNTO, '||
            'CASO.VERSION_FIN AS DESCRIPCION_HIPOTESIS, '||
            'NVL(( '||
              'SELECT HIST.FE_CREACION '||
                'FROM DB_SOPORTE.INFO_DETALLE DET, '||
                     'DB_SOPORTE.INFO_DETALLE_HISTORIAL HIST '||
              'WHERE DET.DETALLE_HIPOTESIS_ID =  DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS '||
                'AND DET.ID_DETALLE           =  HIST.DETALLE_ID '||
                'AND HIST.ESTADO              = ''Finalizada'' '||
                'AND DET.ES_SOLUCION          = ''S'' '||
                'AND DET.ID_DETALLE           = ( '||
                  'SELECT MAX(ID_DETALLE) '||
                    'FROM DB_SOPORTE.INFO_DETALLE D '||
                  'WHERE D.DETALLE_HIPOTESIS_ID = DET.DETALLE_HIPOTESIS_ID '||
                    'AND D.ES_SOLUCION          = ''S'' '||
                ') '||
            '),HISTORIAL.FE_CREACION) FE_SOLUCION, '||
            'NVL(( '||
              'SELECT MAX(PARTE.AFECTADO_ID) '||
                'FROM DB_SOPORTE.INFO_DETALLE DET, '||
                     'DB_SOPORTE.INFO_PARTE_AFECTADA PARTE '||
              'WHERE DET.ID_DETALLE      =  PARTE.DETALLE_ID '||
                'AND DET.ID_DETALLE      =  DETALLE.ID_DETALLE '||
                'AND PARTE.TIPO_AFECTADO = ''Servicio'' '||
            '), 0) SERVICIO_AFECTADO '||
          'FROM '||
            'DB_SOPORTE.INFO_CASO CASO, '||
            'DB_SOPORTE.INFO_CASO_HISTORIAL HISTORIAL, '||
            'DB_COMERCIAL.INFO_PUNTO PUNTO, '||
            'DB_SOPORTE.INFO_DETALLE_HIPOTESIS DETALLE_HIPOTESIS, '||
            'DB_SOPORTE.INFO_DETALLE DETALLE, '||
            'DB_SOPORTE.INFO_PARTE_AFECTADA PARTE_AFECTADA, '||
            'DB_SOPORTE.INFO_CASO_TIEMPO_ASIGNACION TIEMPO, '||
            'DB_SOPORTE.ADMI_HIPOTESIS HIPOTESIS ';

    Lcl_From := REPLACE(Lcl_From,':rangoDesde',''''||Lv_RangoDesde||'''');
    Lcl_From := REPLACE(Lcl_From,':rangoHasta',''''||Lv_RangoHasta||'''');

    Lcl_Where :=
      'WHERE CASO.ID_CASO                              =  DETALLE_HIPOTESIS.CASO_ID '||
        'AND CASO.ID_CASO                              =  TIEMPO.CASO_ID '||
        'AND DETALLE_HIPOTESIS.ID_DETALLE_HIPOTESIS    =  DETALLE.DETALLE_HIPOTESIS_ID '||
        'AND DETALLE.ID_DETALLE                        =  PARTE_AFECTADA.DETALLE_ID '||
        'AND CASO.ID_CASO                              =  HISTORIAL.CASO_ID '||
        'AND PUNTO.ID_PUNTO                            =  PARTE_AFECTADA.AFECTADO_ID '||
        'AND CASO.TITULO_FIN_HIP                       =  HIPOTESIS.ID_HIPOTESIS '||
        'AND TO_CHAR(CASO.FE_APERTURA,''RRRR-MM-DD'') >= :rangoDesde '  ||
        'AND TO_CHAR(CASO.FE_APERTURA,''RRRR-MM-DD'') <= :rangoHasta '  ||
        'AND PARTE_AFECTADA.TIPO_AFECTADO              = :tipoAfectado '||
        'AND PUNTO.ID_PUNTO                            = :idPunto '     ||
        'AND HISTORIAL.ESTADO                          = :estadoCaso '  ||
      ') RESUMEN '||
      'ON RANGO.RANGO >= TRUNC(RESUMEN.FE_APERTURA) AND RANGO.RANGO <= TRUNC(RESUMEN.FE_SOLUCION)';

    Lcl_Where := REPLACE(Lcl_Where,':rangoDesde'  ,''''||Lv_RangoDesde  ||'''');
    Lcl_Where := REPLACE(Lcl_Where,':rangoHasta'  ,''''||Lv_RangoHasta  ||'''');
    Lcl_Where := REPLACE(Lcl_Where,':tipoAfectado',''''||Lv_TipoAfectado||'''');
    Lcl_Where := REPLACE(Lcl_Where,':estadoCaso'  ,''''||Lv_EstadoCaso  ||'''');
    Lcl_Where := REPLACE(Lcl_Where,':idPunto'     ,Ln_IdPunto);

    Lcl_Query := Lcl_Select||Lcl_From||Lcl_Where;
    --DBMS_OUTPUT.PUT_LINE(Lcl_Query);
    OPEN Pr_DispDetCliente FOR Lcl_Query;
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transacci�n exitosa';

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status         := 'ERROR';
      Pv_Mensaje        :=  SUBSTR(SQLERRM ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,200);
      Pr_DispDetCliente :=  NULL;
  END P_OBTENER_DISP_DET_CLIENTE;
----
----
  PROCEDURE P_OBTENER_TIPO_ENLACE(Pcl_Request   IN  CLOB,
                                  Pv_TipoEnlace OUT VARCHAR2,
                                  Pv_Status     OUT VARCHAR2,
                                  Pv_Mensaje    OUT VARCHAR2)
  IS

    CURSOR C_DetalleInicialCaso(Cv_NumeroCaso VARCHAR2)
    IS
      SELECT
        MIN(IDE.ID_DETALLE)
      FROM
        DB_SOPORTE.INFO_CASO              ICA,
        DB_SOPORTE.INFO_DETALLE_HIPOTESIS IDH,
        DB_SOPORTE.INFO_DETALLE           IDE
      WHERE ICA.ID_CASO              = IDH.CASO_ID
        AND IDH.ID_DETALLE_HIPOTESIS = IDE.DETALLE_HIPOTESIS_ID
        AND ICA.NUMERO_CASO          = Cv_NumeroCaso;

    CURSOR C_TipoEnlacesPorCaso(Cn_IdDetalle    NUMBER,
                                Cv_TipoAfectado VARCHAR2,
                                Cv_Login        VARCHAR2,
                                Cv_EstadoPunto  VARCHAR2)
    IS
      SELECT
        LISTAGG(A.TIPO_ENLACE, ';') WITHIN GROUP (ORDER BY A.TIPO_ENLACE DESC) TIPO_ENLACES
      FROM (
        SELECT DISTINCT(ist.TIPO_ENLACE)
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
        WHERE ist.SERVICIO_ID IN (
          SELECT ise.ID_SERVICIO
          FROM DB_COMERCIAL.INFO_SERVICIO ise
          WHERE ise.ID_SERVICIO IN (
            SELECT ist1.SERVICIO_ID
            FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ist1
            WHERE ist1.INTERFACE_ELEMENTO_ID IN (
              SELECT iie.ID_INTERFACE_ELEMENTO
              FROM DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO iie
              WHERE iie.ELEMENTO_ID IN (
                SELECT DISTINCT(ipa.AFECTADO_ID)
                FROM DB_SOPORTE.INFO_PARTE_AFECTADA ipa
                WHERE ipa.DETALLE_ID    = Cn_IdDetalle
                  AND ipa.TIPO_AFECTADO = Cv_TipoAfectado
              )
            )
          )
          AND ise.PUNTO_ID = (
            SELECT ip.ID_PUNTO
            FROM DB_COMERCIAL.INFO_PUNTO ip
            WHERE ip.LOGIN  = Cv_Login
              AND ip.ESTADO = Cv_EstadoPunto
          ))) A;

    CURSOR C_TipoEnlacesPorCasoServ(Cn_IdDetalle    NUMBER,
                                    Cv_TipoAfectado VARCHAR2,
                                    Cv_Login        VARCHAR2,
                                    Cv_EstadoPunto  VARCHAR2)
    IS
      SELECT
        LISTAGG(A.TIPO_ENLACE, ';') WITHIN GROUP (ORDER BY A.TIPO_ENLACE DESC) TIPO_ENLACES
      FROM (
        SELECT DISTINCT(ist.TIPO_ENLACE)
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ist
        WHERE ist.SERVICIO_ID IN (
          SELECT ise.ID_SERVICIO
          FROM DB_COMERCIAL.INFO_SERVICIO ise
          WHERE ise.ID_SERVICIO IN (
            SELECT DISTINCT(ipa.AFECTADO_ID)
            FROM DB_SOPORTE.INFO_PARTE_AFECTADA ipa
            WHERE ipa.DETALLE_ID    = Cn_IdDetalle
              AND ipa.TIPO_AFECTADO = Cv_TipoAfectado
          )
          AND ise.PUNTO_ID = (
            SELECT ip.ID_PUNTO
            FROM DB_COMERCIAL.INFO_PUNTO ip
            WHERE ip.LOGIN  = Cv_Login
              AND ip.ESTADO = Cv_EstadoPunto
          ))) A;

    CURSOR C_TipoEnlacesPorPunto(Cn_IdPunto NUMBER,
                                 Cv_Estado  VARCHAR2)
    IS
      SELECT
        LISTAGG(A.TIPO_ENLACE, ';') WITHIN GROUP (ORDER BY A.FE_CREACION DESC) TIPO_ENLACES
      FROM (
        SELECT
          PROD.DESCRIPCION_PRODUCTO,
          PROD.ID_PRODUCTO,
          ISR.ID_SERVICIO,
          IST.TIPO_ENLACE,
          ISR.FE_CREACION
        FROM
          DB_SOPORTE.INFO_SERVICIO ISR,
          DB_SOPORTE.INFO_PLAN_CAB IPC,
          DB_SOPORTE.INFO_PLAN_DET IPD,
          DB_SOPORTE.ADMI_PRODUCTO PROD,
          DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
        WHERE ISR.PLAN_ID     = IPC.ID_PLAN
          AND IPC.ID_PLAN     = IPD.PLAN_ID
          AND IPD.PRODUCTO_ID = PROD.ID_PRODUCTO
          AND ISR.ID_SERVICIO = IST.SERVICIO_ID
          AND ISR.PUNTO_ID    = Cn_IdPunto
          AND PROD.ESTADO     = Cv_Estado
        UNION
        SELECT
          PROD.DESCRIPCION_PRODUCTO,
          PROD.ID_PRODUCTO,
          ISR.ID_SERVICIO,
          IST.TIPO_ENLACE,
          ISR.FE_CREACION
        FROM
          DB_SOPORTE.INFO_SERVICIO ISR,
          DB_SOPORTE.ADMI_PRODUCTO PROD,
          DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
        WHERE ISR.PRODUCTO_ID = PROD.ID_PRODUCTO
          AND ISR.ID_SERVICIO = IST.SERVICIO_ID
          AND ISR.PUNTO_ID    = Cn_IdPunto
          AND PROD.ESTADO     = Cv_Estado
      ) A;

    Lt_JsonIndex    APEX_JSON.T_VALUES;
    Lv_TipoEnlace   VARCHAR2(200);
    Ln_IdDetalle    NUMBER;
    Ln_IdPunto      NUMBER;
    Lv_NumeroCaso   VARCHAR2(200);
    Lv_Login        VARCHAR2(50);

  BEGIN

    IF C_DetalleInicialCaso%ISOPEN THEN
      CLOSE C_DetalleInicialCaso;
    END IF;

    IF C_TipoEnlacesPorCaso%ISOPEN THEN
      CLOSE C_TipoEnlacesPorCaso;
    END IF;

    IF C_TipoEnlacesPorCasoServ%ISOPEN THEN
      CLOSE C_TipoEnlacesPorCasoServ;
    END IF;

    IF C_TipoEnlacesPorPunto%ISOPEN THEN
      CLOSE C_TipoEnlacesPorPunto;
    END IF;

    APEX_JSON.PARSE(Lt_JsonIndex,Pcl_Request);
    Lv_NumeroCaso := APEX_JSON.GET_VARCHAR2(P_PATH => 'numeroCaso', P_VALUES => Lt_JsonIndex);
    Lv_Login      := APEX_JSON.GET_VARCHAR2(P_PATH => 'login'     , P_VALUES => Lt_JsonIndex);
    Ln_IdPunto    := APEX_JSON.GET_NUMBER(P_PATH   => 'idPunto'   , P_VALUES => Lt_JsonIndex);

    OPEN C_DetalleInicialCaso(Lv_NumeroCaso);
    FETCH C_DetalleInicialCaso INTO Ln_IdDetalle;
    CLOSE C_DetalleInicialCaso;

    IF Ln_IdDetalle IS NULL THEN
      RETURN;
    END IF;

    OPEN C_TipoEnlacesPorCaso(Ln_IdDetalle,'Elemento',Lv_Login,'Activo');
    FETCH C_TipoEnlacesPorCaso INTO Lv_TipoEnlace;
    CLOSE C_TipoEnlacesPorCaso;

    IF Lv_TipoEnlace IS NOT NULL THEN
      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacci�n exitosa';
      Pv_TipoEnlace :=  Lv_TipoEnlace;
      RETURN;
    END IF;

    OPEN C_TipoEnlacesPorCasoServ(Ln_IdDetalle,'Servicio',Lv_Login,'Activo');
    FETCH C_TipoEnlacesPorCasoServ INTO Lv_TipoEnlace;
    CLOSE C_TipoEnlacesPorCasoServ;

    IF Lv_TipoEnlace IS NOT NULL THEN
      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacci�n exitosa';
      Pv_TipoEnlace :=  Lv_TipoEnlace;
      RETURN;
    END IF;

    OPEN C_TipoEnlacesPorPunto(Ln_IdPunto,'Activo');
    FETCH C_TipoEnlacesPorPunto INTO Lv_TipoEnlace;
    CLOSE C_TipoEnlacesPorPunto;

    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacci�n exitosa';
    Pv_TipoEnlace :=  Lv_TipoEnlace;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Status     := 'ERROR';
      Pv_Mensaje    :=  SUBSTR(SQLERRM ||' - ERROR_BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,200);
      Pv_TipoEnlace :=  NULL;
  END P_OBTENER_TIPO_ENLACE;
----
----
  FUNCTION F_LIMPIAR_CADENA_CARACTERES(Fv_Cadena IN CLOB)
      RETURN CLOB IS
  BEGIN
      RETURN TRIM(
              REPLACE(
              REPLACE(
              REPLACE(
              REPLACE(
              TRANSLATE(
              REGEXP_REPLACE(
              REGEXP_REPLACE(Fv_Cadena,'^[^A-Z|^a-z|^0-9]|[?|�|&|<|>|/|;|.|%|"]|+$',' ')
              ,'[^A-Za-z0-9������������&()-_ ]',' ')
              ,'������������','AEIOUNaeioun')
              , Chr(9) ,' ')
              , Chr(10),' ')
              , Chr(13),' ')
              , Chr(59),' '));
  END F_LIMPIAR_CADENA_CARACTERES;
----
----
END SPKG_GENERACION_SLA;
/