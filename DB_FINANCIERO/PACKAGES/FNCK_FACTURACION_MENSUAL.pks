CREATE EDITIONABLE PACKAGE               FNCK_FACTURACION_MENSUAL AS 

/*
* Documentaci�n para TYPE 'TypeClientesFacturar'.
*
* Tipo de datos para el retorno de la informacion correspondiente a los documentos a notificar a los usuarios
*
* @author Edson Franco <efranco@telconet.ec>
* @version 1.1 10-02-2017 - Se agregan los campos 'CLIENTE' e 'IDENTIFICACION_CLIENTE'
* @since 1.0
*/
TYPE TypeClientesFacturar IS RECORD (
      empresa_id             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
      id_oficina             DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      id_persona_rol         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
      persona_id             DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
      login                  DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
      empresa_rol_id         DB_COMERCIAL.INFO_EMPRESA_ROL.ID_EMPRESA_ROL%TYPE,
      rol_id                 DB_GENERAL.ADMI_ROL.ID_ROL%TYPE,
      descripcion_rol        DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE,
      descripcion_tipo_rol   DB_GENERAL.ADMI_TIPO_ROL.DESCRIPCION_TIPO_ROL%TYPE,
      id_punto               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      CLIENTE                DB_COMERCIAL.INFO_PERSONA.RAZON_SOCIAL%TYPE,
      IDENTIFICACION_CLIENTE DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
      estado                 DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
      es_padre_facturacion   DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL.ES_PADRE_FACTURACION%TYPE,
      gasto_administrativo   DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL.GASTO_ADMINISTRATIVO%TYPE
);

/*
* Documentaci�n para TYPE 'T_ClientesFacturar'.
* Record para almacenar la data enviada al BULK.
*/
TYPE T_ClientesFacturar IS TABLE OF TypeClientesFacturar INDEX BY PLS_INTEGER;

/*
* Documentaci�n para TYPE 'TypeServiciosAsociados'.
* Record que me permite almancernar la informacion devuelta de los servicios asociados al punto de facturacion.
*/
TYPE TypeServiciosAsociados IS RECORD (
      id_servicio           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,  
      producto_id           ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
      plan_id               INFO_PLAN_CAB.ID_PLAN%TYPE,
      punto_id              INFO_PUNTO.ID_PUNTO%TYPE,
      cantidad              DB_COMERCIAL.INFO_SERVICIO.CANTIDAD%TYPE,
      precio_venta          DB_COMERCIAL.INFO_SERVICIO.PRECIO_VENTA%TYPE,
      porcentaje_descuento  DB_COMERCIAL.INFO_SERVICIO.PORCENTAJE_DESCUENTO%TYPE,
      valor_descuento       DB_COMERCIAL.INFO_SERVICIO.VALOR_DESCUENTO%TYPE,
      punto_facturacion_id  INFO_PUNTO.ID_PUNTO%TYPE,
      estado                DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE
);

/*
* Documentaci�n para TYPE 'TypeSolicitudes'.
* Record que me permite almancernar la informacion devuelta de las solicitudes asociados al punto de facturacion.
*/
Type TypeSolicitudes IS RECORD (
      id_detalle_solicitud  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
      descripcion_solicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
      estado_solicitud      DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE
);

/**
 * Documentaci�n para PROCEDURE 'GET_SOL_DESCT_PROMOCIONAL'.
 *
 * Procedimiento que obtiene la solicitud de descuento Promocional y su porcentaje de descuento para ser aplicada en la Facturaci�n
 * Costo:3
 *
 * PARAMETROS:
 * @Param Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
 * @Param Pn_IdDetalleSolicitud    OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
 * @Param Pn_PorcentajeDescuento   OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE
 *
 * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
 * @version 1.0 20-07-2019
 */
 PROCEDURE GET_SOL_DESCT_PROMOCIONAL(
   Pn_IdServicio            IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
   Pn_IdDetalleSolicitud    OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
   Pn_PorcentajeDescuento   OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE);
  
--Funcion para la sumatoria del subtotal del documento
FUNCTION F_SUMAR_SUBTOTAL(id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) RETURN NUMBER;

--Funcion para la sumatoria del descuento del documento
FUNCTION F_SUMAR_DESCUENTO(id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) RETURN NUMBER;

--Funcion para la sumatoria del impuesto del documento
FUNCTION P_SUMAR_IMPUESTOS(id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) RETURN NUMBER;

--Funcion para obtener la fecha de activacion de los servicios
FUNCTION GET_FECHA_ACTIVACION(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN  VARCHAR2;

--Funcion para obtener el porcentaje correspondiente al impuesto
FUNCTION F_OBTENER_IMPUESTO(Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) RETURN NUMBER;

--Funcion para obtener el porcentaje correspondiente al impuesto mediante la descripcion
FUNCTION F_OBTENER_IMPUESTO_POR_DESC(
    Fv_DescripcionImpuesto IN DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE)
RETURN NUMBER;

--Funcion para obtener el id_impuesto correspondiente al impuesto
FUNCTION F_CODIGO_IMPUESTO(Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) RETURN NUMBER;

--Funcion para obtener el id_impuesto correspondiente al impuesto por medio del porcentaje
FUNCTION F_CODIGO_IMPUESTO_X_PORCEN(
    Fv_Porcentaje IN DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE)
RETURN NUMBER;

--Funcion para retornar el id_ciclo segun el nombre el proceso
FUNCTION F_OBTENER_CICLO(Fv_NombreCiclo IN DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE) RETURN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE;

--Funcion para verificar si existe informacion relacionada con el ciclo y el mes/ a�o facturado

FUNCTION F_VERIFICAR_CICLO(Fv_NombreCiclo       IN DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE,
                            Fv_MesVerificar     IN DB_FINANCIERO.INFO_CICLO_FACTURADO.MES_FACTURADO%TYPE,
                            Fv_AnioVerificar    IN DB_FINANCIERO.INFO_CICLO_FACTURADO.ANIO_FACTURADO%TYPE,
                            Fv_TipoFacturacion  IN VARCHAR2,
                            Fn_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
RETURN NUMBER;
/**
  * Documentacion para el procedimiento P_GENERAR_FECHA_EMISION
  *
  * @version 1.0 Version Inicial
  * Procedimiento para obtener la fecha de emision dependiendo de la fecha actual
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.1 22-06-2017 - Modificacion del procedimiento para extraer el mes en espa�ol
  */
PROCEDURE P_GENERAR_FECHA_EMISION(Fv_TipoFacturacion  IN VARCHAR2,
                                    Pv_FeEmision        OUT VARCHAR2,
                                    Pv_MesEmision       OUT VARCHAR2,
                                    Pn_MesEmision       OUT VARCHAR2,
                                    Pv_AnioEmision      OUT VARCHAR2
);
--
--
  /*
  * Documentaci�n para el PROCEDURE 'P_PROCESAR_INFORMACION'.
  *
  * Procedimiento para procesar la informaci�n de los clientes a facturar
  *
  * @param Prf_ClientesFacturar        IN T_ClientesFacturar  (Cursor que contiene los clientes a facturar)
  * @param Pv_MesEmisionNumeros        IN VARCHAR2  (Mes de emision de la factura en numero)
  * @param Pv_MesEmisionLetras         IN VARCHAR2  (Mes de emision de la factura en letras)
  * @param Pv_AnioEmision              IN VARCHAR2  (A�o de emision de la factura)
  * @param Pv_PrefijoEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE (Prefijo de la empresa a facturar)
  * @param Pn_IdOficina                IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE (Id de la oficina del cliente)
  * @param Pv_FeEmision                IN VARCHAR2  (Fecha de emision de la factura)
  * @param Pn_Porcentaje               IN NUMBER  (Porcentaje del IVA que se va a facturar)
  * @param Pn_RecordCount              IN OUT NUMBER  (Cantidad de clientes que se les proces� la informaci�n de facturaci�n)
  * @param Pv_CuerpoClieNoCompensados  IN OUT NUMBER  (Informaci�n de los clientes que deb�an compensar y no fueron compensados)
  * @param Pn_ClientesFacturados       IN OUT NUMBER  (Cantidad de clientes facturados)
  * @param Pn_ClientesCompensados      IN OUT NUMBER  (Cantidad de clientes compensados)
  * @param Pn_ClientesNoCompensados    IN OUT NUMBER  (Cantidad de clientes no compensados)
  * @param Pn_CantNoCompensados        IN OUT NUMBER  (Contador que indicar� cantidad de clientes no compensados, pero el cual ser� reiniciado cada
  *                                                    100 clientes puesto que ser�n notificados al usuario correspondientes)
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.2 24-03-2017 - Se realiza modificaci�n para el ingreso de un nuevo detalle a la factura por cargo de reproceso de d�bito.
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 07-02-2017 - Se modifica la funci�n para realizar la facturaci�n por compensaci�n a los clientes que tienen asociado el cant�n
  *                           'MANTA' y 'PORTOVIEJO'. Estos cantones son tomados de la tabla 'DB_GENERAL.ADMI_PARAMETRO_DET' los cuales pertenecen al
  *                           par�metro cabecera llamado 'CANTONES_OFICINAS_COMPENSADAS'.
  *                           Tambi�n se elimina el round que se realiza a los impuestos por cada detalle de la factura.
  *                           Adicional se agregan los siguientes par�metros 'Pv_CuerpoClieNoCompensados', 'Pn_ClientesFacturados',
  *                           'Pn_ClientesCompensados' y 'Pn_ClientesNoCompensados' los cuales ayudan a verificar la informaci�n de los clientes que
  *                           se est�n facturando para luego ser notificado v�a correo a los usuarios correspondientes.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.3 25-07-2019 - Se valida si existe Solicitud de Descuento Promocional Mensual para ser aplicada en la Facturaci�n
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.4 02-02-2021 - Se actualizan las cabeceras a estado Eliminado de los servicios que tienen caracteristica "FACTURACION_CRS_CICLO_FACT",
  *                           debido a que no tienen detalle y su valor total es 0 o nulo. Adicional se crea un historial del estado eliminado. 
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.5 02-03-2023  Se agrega par�metro CvEmpresaCod en el cursor C_GetValorCargoReproceso para filtrar el resultado por empresa.
  *
  * @since 1.0
  */
  PROCEDURE P_PROCESAR_INFORMACION(
      Prf_ClientesFacturar        IN T_ClientesFacturar,
      Pv_MesEmisionNumeros        IN VARCHAR2,
      Pv_MesEmisionLetras         IN VARCHAR2,
      Pv_AnioEmision              IN VARCHAR2,
      Pv_PrefijoEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pn_IdOficina                IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pv_FeEmision                IN VARCHAR2,
      Pn_Porcentaje               IN NUMBER,
      Pn_RecordCount              IN OUT NUMBER,
      Pv_CuerpoClieNoCompensados  IN OUT CLOB,
      Pn_ClientesFacturados       IN OUT NUMBER,
      Pn_ClientesCompensados      IN OUT NUMBER,
      Pn_ClientesNoCompensados    IN OUT NUMBER,
      Pn_CantNoCompensados        IN OUT NUMBER);
--
--
--Procedimiento para obtener prefijo de la empresa
PROCEDURE GET_PREFIJO_OFICINA(Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Pv_Prefijo OUT DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
                                Pn_Id_Oficina OUT DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE);

--Procedimiento para eliminar los documentos nulos
PROCEDURE P_ELIMINAR_DOC_NULOS(Pn_UsrCreacion IN VARCHAR2);

--Procedimiento para actualizar las solicitud de descuento unico
PROCEDURE UPD_SOL_DESCT_UNICO (Pn_IdDetalleSol IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE);

 /**
  * Documentaci�n para PROCEDURE 'GET_SERVICIO_ASOCIADOS'.
  * Procedimiento para obtener los servicios asociados a los ptos de facturacion
  *
  * PARAMETROS:
  * @Param Pn_PuntoFacturacionId   IN    DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * @param Pn_CaracteristicaId     IN    DB_COMERCIAL.ADMI_CARACTERISTICA%TYPE
  * @Param Cn_Servicios            OUT SYS_REFCURSOR
  * @version 1.0 Version Inicial
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.1 22-02-2018 - Se Trunca Valor de Precio de Venta del Servicio a 2 decimales debido a errores de cuadratura
  *                           provocado por Precios de Venta a 9 decimales  
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.2
  * @since 13-06-2018
  * Se agrega el par�metro Pn_CaracteristicaId.
  * Se agrega el filtro de los servicios que no tengan la caracter�stica por CRS (FACTURACION_CRS_CICLO_FACT). Es decir,
  * obtiene �nicamente los servicios que no han sido creados a trav�s del Cambio de Raz�n Social.
  *  
  */    
PROCEDURE GET_SERVICIO_ASOCIADOS(Pn_PuntoFacturacionId IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                 Pn_CaracteristicaId   IN  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
                                 Cn_Servicios          OUT SYS_REFCURSOR);

--Procedimiento para obtener las solicitudes de cancelacion y suspension relacionadas al servicio
PROCEDURE GET_SOLICITUDES_CANCEL_SUSP(Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,Cn_Solicitudes OUT SYS_REFCURSOR);

--Procedimiento para obtener la solicitud de descuento unico asociada al servicio
PROCEDURE GET_SOL_DESCT_UNICO(Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Id_Det_Sol OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                Porcen_Desct OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE);

--Procedimiento para simular la facturacion basica por porcentaje o por valor de descuento segun la informacion del punto
PROCEDURE P_SIMULAR_FACT_MENSUAL(Pn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                  Pn_PorPorcentaje OUT DB_COMERCIAL.INFO_SERVICIO.PORCENTAJE_DESCUENTO%TYPE, 
                                  Pn_PorValor OUT DB_COMERCIAL.INFO_SERVICIO.VALOR_DESCUENTO%TYPE);

  /*
  * Documentaci�n para el PROCEDURE 'P_FACTURACION_MENSUAL'.
  *
  * Procedimiento para realizar la facturacion mensual de todos los puntos de facturacion
  *
  * @param Pv_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (C�digo de la empresa que va a ejecutar el proceso de
  *                                                                                     facturaci�n)
  * @param Pv_DescripcionImpuesto IN DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE  (Descripci�n del impuesto a facturar)
  * @param Pv_TipoFacturacion     IN VARCHAR2  (Tipo de ciclo de facturaci�n a ejecutar)
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.2 03-10-2017 - Se modifica la funcionalidad del procedimiento para que considere por ciclos la facturaci�n.
  *                           Se modifica el query principal para que tome solo los clientes del ciclo a facturar.
  *                           Se extrae las fechas de la facturaci�n del procedimiento P_GENERAR_FECHA_EMISION_CICLOS.
  *
  * @author Edson Franco <efranco@telconet.ec>
  * @version 1.1 10-02-2017 - Se modifica la funci�n para agregar al query principal el nombre del cliente y su identificaci�n, adicional se agrega
  *                           una validaci�n para notificar a los usuarios la cantidad de clientes facturados, compensados, y no compensados para que
  *                           realicen la gesti�n correspondiente. Tambi�n se modifica la funci�n 'P_PROCESAR_INFORMACION' para enviarle los 
  *                           par�metros correspondientes que son 'Lv_CuerpoClieNoCompensados', 'Ln_ClientesFacturados', 'Ln_ClientesCompensados' y 
  *                           'Ln_ClientesNoCompensados'
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.3 02-03-2023  Se agrega par�metro CvEmpresaCod en el cursor C_ConsultaCiclos para filtrar el resultado por empresa.
  * @since 1.0
  */
  PROCEDURE P_FACTURACION_MENSUAL(
      Pn_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_DescripcionImpuesto IN DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE,
      Pv_TipoFacturacion     IN VARCHAR2);

  /*
  * Documentaci�n para el PROCEDURE 'P_GENERAR_FECHA_EMISION_CICLOS'.
  *
  * Procedimiento para devolver las fechas de emision de forma detallada
  *
  * @param Pn_CicloFacturacion   IN  NUMBER    (C�digo del ciclo de facturaci�n)
  * @param Pv_FeEmision          OUT VARCHAR2  (Fecha de Inicio del ciclo)
  * @param Pv_MesEmision         OUT VARCHAR2  (Mes del ciclo en letras)
  * @param Pn_MesEmision         OUT VARCHAR2  (Mes del ciclo en n�mero)
  * @param Pv_AnioEmision        OUT VARCHAR2  (A�o del ciclo)
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  *
  * @since 1.0 03-10-2017
  */
  PROCEDURE P_GENERAR_FECHA_EMISION_CICLOS(
    Pn_CicloFacturacion IN  NUMBER,
    Pv_FeEmision        OUT VARCHAR2,
    Pv_MesEmision       OUT VARCHAR2,
    Pn_MesEmision       OUT VARCHAR2,
    Pv_AnioEmision      OUT VARCHAR2
    );
  
  /*
  * Documentaci�n para el PROCEDURE 'P_GET_CLIENT_FACT'.
  *
  * Procedimiento para devolver las fechas de emision de forma detallada
  *
  * @param Pn_PuntoFact      IN  NUMBER    (Punto de Facturaci�n)
  * @param Pd_FecIniRango    OUT DATE      (Fecha de Inicio Rango)
  * @param Pd_FecFinRango    OUT DATE      (Fecha de Fin Rango)
  * @param Pb_ValidaCliente  OUT NUMBER    (Bandera para facturar)
  * @param Pv_RangoFactura   OUT NUMBER    (Rango de la facturaci�n)
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  *
  * @since 1.0 05-10-2017
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.0 25-10-2017 - Se transforma en un procedimiento y se agregan parametros de salida para obtener el rango de la factura
  *
  * @author Jorge Guerrero <jguerrerop@telconet.ec>
  * @version 1.1 1-11-2017 - Se agrega la validacion para calcular mejor el rango de fechas por ciclo
  *
  * Se agrega la conversi�n a TO_DATE en los rangos de fechas. Se agrega el FORMAT_ERROR_BACKTRACE en el mensaje de error.
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.2
  * @since 01-05-2018
  *
  * Se agrega el insert en la INFO_ERROR cuando el punto no cumple la validaci�n del rango de fecha del mes de consumo.
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.3
  * @since 28-09-2018
  *
  * Se modifica validaci�n de facturaci�n generada por ciclo de facturaci�n.
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.4
  * @since 16-01-2019
  *
  * Se remueve la validacion de la 
  * factura proporcional(5) en el cursor C_VerificFact
  * @author Gustavo Narea <gnarea@telconet.ec>
  * @version 1.5
  * @since 25-09-2020
  * Costo query C_VerificFact: 54
  */
  PROCEDURE P_GET_CLIENT_FACT(Pn_PuntoFact     IN NUMBER,
                              Pd_FecIniRango   OUT DATE,
                              Pd_FecFinRango   OUT DATE,
                              Pb_ValidaCliente OUT BOOLEAN,
                              Pv_RangoFactura  OUT VARCHAR2);

END FNCK_FACTURACION_MENSUAL;
/

CREATE EDITIONABLE PACKAGE BODY               FNCK_FACTURACION_MENSUAL
AS

PROCEDURE GET_SOL_DESCT_PROMOCIONAL(
  Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
  Pn_IdDetalleSolicitud    OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
  Pn_PorcentajeDescuento   OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE)
  AS
  --Permite obtener la solicitud de descuento Promocional Mensual
  CURSOR C_GetSolicitudPromocional(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT ID_DETALLE_SOLICITUD,
      PORCENTAJE_DESCUENTO
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    WHERE ID_DETALLE_SOLICITUD IN
      (SELECT MIN(IDS.ID_DETALLE_SOLICITUD)
       FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
       LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
       ON ATS.ID_TIPO_SOLICITUD      =IDS.TIPO_SOLICITUD_ID
       WHERE IDS.SERVICIO_ID         =Cn_IdServicio
       AND ATS.DESCRIPCION_SOLICITUD IN ('SOLICITUD DESCUENTO TOTAL EN MENSUALIDAD',
                                         'SOLICITUD DESCUENTO EN MENSUALIDAD DE PRODUCTOS',
                                         'SOLICITUD DESCUENTO EN MENSUALIDAD DE PLANES',
                                         'SOLICITUD DESCUENTO EN MENSUALIDAD MIX DE PLANES Y PRODUCTOS')
      AND IDS.ESTADO                 ='Aprobado'
      AND ROWNUM                     =1
      );
  
BEGIN
  IF C_GetSolicitudPromocional%ISOPEN THEN
    CLOSE C_GetSolicitudPromocional;
  END IF;

  OPEN C_GetSolicitudPromocional(Pn_IdServicio);
  --
  FETCH C_GetSolicitudPromocional INTO Pn_IdDetalleSolicitud, Pn_PorcentajeDescuento;
  --
  IF Pn_IdDetalleSolicitud IS NULL THEN
    Pn_IdDetalleSolicitud := 0;
  END IF;
  --
  IF Pn_PorcentajeDescuento IS NULL THEN
    Pn_PorcentajeDescuento := 0;
  END IF;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
                                                       'FNCK_FACTURACION_MENSUAL.GET_SOL_DESCT_PROMOCIONAL',
                                                       'Error al obtener la Solicitud de Descuento Promocional ID_SERVICIO=' ||Pn_IdServicio || 
                                                       ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM); 
END GET_SOL_DESCT_PROMOCIONAL;

PROCEDURE GET_SERVICIO_ASOCIADOS(
    Pn_PuntoFacturacionId IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_CaracteristicaId   IN  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
    Cn_Servicios          OUT SYS_REFCURSOR)
AS
  --Listado de Servicios asociados al pto de facturacion
  --Tema de Frecuencias??
    Lv_Estado VARCHAR2(15) := 'Activo';
    Lv_Valor  VARCHAR2(15) := 'S';
BEGIN
  OPEN Cn_Servicios FOR 
    --COSTO DEL QUERY 7
    SELECT iser.id_servicio, 
    iser.producto_id, 
    iser.plan_id, 
    iser.punto_id, 
    iser.cantidad, 
    TRUNC(iser.precio_venta,2), 
    NVL(iser.porcentaje_descuento,0) AS  porcentaje_descuento, 
    NVL(iser.valor_descuento,0) AS  valor_descuento, 
    iser.punto_facturacion_id, 
    iser.estado 
    FROM DB_COMERCIAL.INFO_SERVICIO iser 
    WHERE iser.PUNTO_FACTURACION_ID=Pn_PuntoFacturacionId 
    AND iser.ESTADO='Activo' 
    AND iser.cantidad>0 
    AND iser.ES_VENTA='S' 
    AND iser.precio_venta>0 
    AND iser.frecuencia_producto=1 
    AND NVL(iser.PRECIO_VENTA*iser.CANTIDAD,0)>=NVL(iser.VALOR_DESCUENTO,0)
    AND 0 = (SELECT COUNT(*)
               FROM DB_COMERCIAL.INFO_SERVICIO_CARACTERISTICA ISC
              WHERE ISC.SERVICIO_ID = ISER.ID_SERVICIO
                AND ISC.ESTADO = Lv_Estado
                AND ISC.VALOR  = Lv_Valor
                AND CARACTERISTICA_ID = Pn_CaracteristicaId
                    );
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
                                                         'FNCK_FACTURACION_MENSUAL.GET_SERVICIO_ASOCIADOS', 
                                                          DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));       
END GET_SERVICIO_ASOCIADOS;

PROCEDURE GET_SOLICITUDES_CANCEL_SUSP(
    Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Cn_Solicitudes OUT SYS_REFCURSOR)
AS
  --Verificar las solicitudes de cancelacion o suspension temporal del servicio
BEGIN
  OPEN Cn_Solicitudes FOR 
    SELECT MAX(ids.id_detalle_solicitud) AS  id_detalle_solicitud, 
    ats.descripcion_solicitud, 
    ids.estado AS estado_solicitud 
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids 
    left join DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats ON ats.id_tipo_solicitud=ids.tipo_solicitud_id 
    WHERE ids.servicio_id=Pn_IdServicio 
    AND (ats.descripcion_solicitud='SOLICITUD CANCELACION' OR ats.descripcion_solicitud='SOLICITUD SUSPENSION TEMPORAL') 
    AND ids.estado='Pendiente' 
    group by ats.descripcion_solicitud,ids.estado;
  EXCEPTION
  WHEN OTHERS THEN
     DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.GET_SOLICITUDES_CANCEL_SUSP', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));    
END GET_SOLICITUDES_CANCEL_SUSP;

PROCEDURE GET_SOL_DESCT_UNICO(
    Pn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    Id_Det_Sol OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    Porcen_Desct OUT DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE)
AS
  --Permite obtener la solicitud de descuento unico asociada al servicio
  CURSOR Cn_Solicitud(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT id_detalle_solicitud,
      porcentaje_descuento
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    WHERE id_detalle_solicitud IN
      (SELECT MIN(ids.id_detalle_solicitud)
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD ids
      LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ats
      ON ats.id_tipo_solicitud     =ids.tipo_solicitud_id
      WHERE ids.servicio_id        =Cn_IdServicio
      AND ats.descripcion_solicitud='SOLICITUD DESCUENTO UNICO'
      AND ids.estado               ='Aprobado'
      AND rownum                   =1
      );

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF Cn_Solicitud%ISOPEN THEN
    CLOSE Cn_Solicitud;
  END IF;

  OPEN Cn_Solicitud(Pn_IdServicio);
  --
  FETCH Cn_Solicitud INTO Id_Det_Sol, Porcen_Desct;
  --
  IF Id_Det_Sol IS NULL THEN
    Id_Det_Sol := 0;
  END IF;
  --
  IF Porcen_Desct IS NULL THEN
    Porcen_Desct := 0;
  END IF;
  --
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.GET_SOL_DESCT_UNICO', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));           
END GET_SOL_DESCT_UNICO;

PROCEDURE UPD_SOL_DESCT_UNICO(
    Pn_IdDetalleSol IN DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE)
AS
  --Actualiza el estado de la solicitud
  --Crea historial de ejecucion por la Facturacion
BEGIN
  --Finalizo la solicitud actual
  UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
  SET estado                ='Finalizada'
  WHERE id_detalle_solicitud=Pn_IdDetalleSol;
  --Inserto el historia nuevo
  INSERT
  INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
    (
      ID_SOLICITUD_HISTORIAL,
      DETALLE_SOLICITUD_ID,
      ESTADO,
      OBSERVACION,
      USR_CREACION,
      FE_CREACION
    )
    VALUES
    (
      DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,
      Pn_IdDetalleSol,
      'Finalizada',
      'Proceso de Facturacion masiva telcos',
      'telcos',
      sysdate
    );
END UPD_SOL_DESCT_UNICO;

PROCEDURE GET_PREFIJO_OFICINA(
    Pn_EmpresaCod IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_Prefijo OUT DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pn_Id_Oficina OUT DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE)
AS
  -- Permite obtener el prefijo y la oficina
  CURSOR Cn_EmpresaOficina(Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
  IS
    SELECT ieg.prefijo,
      iog.ID_OFICINA
    FROM DB_COMERCIAL.info_empresa_grupo ieg
    JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO iog
    ON iog.EMPRESA_ID             =ieg.COD_EMPRESA
    AND iog.ES_MATRIZ             ='S'
    AND iog.ES_OFICINA_FACTURACION='S'
    WHERE ieg.COD_EMPRESA         =Cn_EmpresaCod
    AND iog.ESTADO                ='Activo'
    AND rownum                    =1;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN

  IF Cn_EmpresaOficina%ISOPEN THEN
    CLOSE Cn_EmpresaOficina;
  END IF;

  OPEN Cn_EmpresaOficina(Pn_EmpresaCod);
  --
  FETCH Cn_EmpresaOficina INTO Pv_Prefijo, Pn_Id_Oficina;
  --
  IF Pv_Prefijo IS NULL THEN
    Pv_Prefijo := '';
  END IF;
  --
  IF Pn_Id_Oficina IS NULL THEN
    Pn_Id_Oficina := 0;
  END IF;
  --
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.GET_PREFIJO_OFICINA', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));        
END GET_PREFIJO_OFICINA;

FUNCTION F_SUMAR_SUBTOTAL(
    id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_SumarSubtotal (Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS 
    SELECT SUM(PRECIO_VENTA_FACPRO_DETALLE*CANTIDAD)
    FROM INFO_DOCUMENTO_FINANCIERO_DET
    WHERE DOCUMENTO_ID = Cn_IdDocumento;
  --
  Ln_SubtotalCeroImpuesto INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN 
  IF C_SumarSubtotal%ISOPEN THEN
    CLOSE C_SumarSubtotal;
  END IF;
  --
  OPEN C_SumarSubtotal(id_documento);
  --
  FETCH C_SumarSubtotal INTO Ln_SubtotalCeroImpuesto;
  --
  CLOSE C_SumarSubtotal;
  --
  IF Ln_SubtotalCeroImpuesto IS NULL THEN
    Ln_SubtotalCeroImpuesto  := 0.00;
  END IF;
  --
  RETURN Ln_SubtotalCeroImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_InfoError:='Error al obtener Ln_SubtotalCeroImpuesto en Id_Documento: '||id_documento;
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 'FNCK_FACTURACION_MENSUAL.F_SUMAR_SUBTOTAL', Lv_InfoError);
    DB_FINANCIERO.FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA(
        'facturacion@telcos.ec',
        'Error Facturacion Masiva',
        DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),
        'FACE');    
END F_SUMAR_SUBTOTAL;

FUNCTION F_SUMAR_DESCUENTO(
    id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_SumaDescuento(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS
    SELECT SUM(DESCUENTO_FACPRO_DETALLE)
    FROM INFO_DOCUMENTO_FINANCIERO_DET
    WHERE DOCUMENTO_ID = Cn_IdDocumento;
  --
  Ln_SubtotalDescuento INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);

BEGIN
  IF C_SumaDescuento%ISOPEN THEN
    CLOSE C_SumaDescuento;
  END IF;
  --
  OPEN C_SumaDescuento(id_documento);
  --
  FETCH C_SumaDescuento INTO Ln_SubtotalDescuento;
  --
  CLOSE C_SumaDescuento;
  --
  IF Ln_SubtotalDescuento IS NULL THEN
    Ln_SubtotalDescuento  := 0.00;
  END IF;
  --
  RETURN Ln_SubtotalDescuento;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.F_SUMAR_DESCUENTO', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));           
END F_SUMAR_DESCUENTO;

FUNCTION P_SUMAR_IMPUESTOS(
    id_documento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_SumaImpuesto(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE) IS
    SELECT SUM(IDFI.VALOR_IMPUESTO)
    FROM INFO_DOCUMENTO_FINANCIERO_DET IDFD
    JOIN INFO_DOCUMENTO_FINANCIERO_IMP IDFI
    ON IDFI.DETALLE_DOC_ID  =IDFD.ID_DOC_DETALLE
    WHERE IDFD.DOCUMENTO_ID = Cn_IdDocumento;
  --
  Ln_SubtotalConImpuesto INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_SumaImpuesto%ISOPEN THEN
    CLOSE C_SumaImpuesto;
  END IF;
  --
  OPEN C_SumaImpuesto(id_documento);
  --
  FETCH C_SumaImpuesto INTO Ln_SubtotalConImpuesto;
  --
  CLOSE C_SumaImpuesto;
  --
  IF Ln_SubtotalConImpuesto IS NULL THEN
    Ln_SubtotalConImpuesto  := 0.00;
  END IF;
  --
  RETURN Ln_SubtotalConImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.P_SUMAR_IMPUESTOS', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));          
END P_SUMAR_IMPUESTOS;

PROCEDURE P_ELIMINAR_DOC_NULOS(
    Pn_UsrCreacion IN VARCHAR2)
AS
BEGIN
  DELETE
  FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL
  WHERE DOCUMENTO_ID IN
    (SELECT ID_DOCUMENTO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
    WHERE ESTADO_IMPRESION_FACT IS NULL
    AND USR_CREACION             =Pn_UsrCreacion
    AND ES_AUTOMATICA            ='S'
    AND NUMERO_FACTURA_SRI      IS NULL
    );
  DELETE
  FROM INFO_DOCUMENTO_FINANCIERO_CAB
  WHERE ESTADO_IMPRESION_FACT IS NULL
  AND USR_CREACION             =Pn_UsrCreacion
  AND ES_AUTOMATICA            ='S'
  AND NUMERO_FACTURA_SRI      IS NULL;
END P_ELIMINAR_DOC_NULOS;

FUNCTION GET_FECHA_ACTIVACION(
    Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_FechaActivacion(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) IS
    SELECT TRUNC(MAX(FE_CREACION))
    FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
    WHERE SERVICIO_ID = Cn_IdServicio
    AND (UPPER (DBMS_LOB.SUBSTR( OBSERVACION,4000,1)) = 'SE CONFIRMO EL SERVICIO' OR UPPER (ACCION) = 'CONFIRMARSERVICIO')
    AND ESTADO = 'Activo';
  --
  Lv_FeCreacion VARCHAR2(200);

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_FechaActivacion%ISOPEN THEN
    CLOSE C_FechaActivacion;
  END IF;
  --
  OPEN C_FechaActivacion(Fn_IdServicio);
  --
  FETCH C_FechaActivacion INTO Lv_FeCreacion;
  --
  CLOSE C_FechaActivacion;
  --
  IF Lv_FeCreacion IS NULL THEN
    Lv_FeCreacion  := '';
  END IF;
  --
  RETURN Lv_FeCreacion;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.GET_FECHA_ACTIVACION', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));         
END GET_FECHA_ACTIVACION;

PROCEDURE P_SIMULAR_FACT_MENSUAL(
    Pn_IdPuntoFacturacion IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    Pn_PorPorcentaje OUT DB_COMERCIAL.INFO_SERVICIO.PORCENTAJE_DESCUENTO%TYPE,
    Pn_PorValor OUT DB_COMERCIAL.INFO_SERVICIO.VALOR_DESCUENTO%TYPE)
AS
  CURSOR Cn_FacturacionMensual
  IS
    SELECT SUM(ROUND((CANTIDAD*PRECIO_VENTA)-((CANTIDAD*PRECIO_VENTA)*NVL(PORCENTAJE_DESCUENTO,0)/100),2)),
      SUM(ROUND((CANTIDAD     *PRECIO_VENTA)-NVL(VALOR_DESCUENTO,0)))
    FROM DB_COMERCIAL.INFO_SERVICIO
    WHERE PUNTO_FACTURACION_ID=Pn_IdPuntoFacturacion
    AND ESTADO                ='Activo'
    AND CANTIDAD              >0
    AND ES_VENTA              ='S'
    AND PRECIO_VENTA          >0
    AND FRECUENCIA_PRODUCTO   =1;
BEGIN
  --Con el punto de facturacion hago el query para la sumatoria de los valores de servicios
  OPEN Cn_FacturacionMensual;
  LOOP
    FETCH Cn_FacturacionMensual INTO Pn_PorPorcentaje, Pn_PorValor;
    EXIT
  WHEN Cn_FacturacionMensual%NOTFOUND;
  END LOOP;
  CLOSE Cn_FacturacionMensual;

  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.P_SIMULAR_FACT_MENSUAL', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));     
END P_SIMULAR_FACT_MENSUAL;

FUNCTION F_OBTENER_IMPUESTO(
    Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_ObtenerImpuesto(Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) IS
    SELECT PORCENTAJE_IMPUESTO
    FROM DB_GENERAL.ADMI_IMPUESTO
    WHERE UPPER(TIPO_IMPUESTO)=Cv_TipoImpuesto
    AND ESTADO                ='Activo';
  --
  Ln_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_ObtenerImpuesto%ISOPEN THEN
    CLOSE C_ObtenerImpuesto;
  END IF;
  --
  OPEN C_ObtenerImpuesto(Fv_TipoImpuesto);
  --
  FETCH C_ObtenerImpuesto INTO Ln_PorcentajeImpuesto;
  --
  CLOSE C_ObtenerImpuesto;
  --
  IF Ln_PorcentajeImpuesto IS NULL THEN
    Ln_PorcentajeImpuesto  := 0;
  END IF;
  --
  RETURN Ln_PorcentajeImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.F_OBTENER_IMPUESTO', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));     
END F_OBTENER_IMPUESTO;

--
FUNCTION F_OBTENER_IMPUESTO_POR_DESC(
    Fv_DescripcionImpuesto IN DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_ObtenerImpuesto(Cv_DescripcionImpuesto DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE) IS
    SELECT PORCENTAJE_IMPUESTO
    FROM DB_GENERAL.ADMI_IMPUESTO
    WHERE UPPER(DESCRIPCION_IMPUESTO)=Cv_DescripcionImpuesto;
  --
  Ln_PorcentajeImpuesto DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_ObtenerImpuesto%ISOPEN THEN
    CLOSE C_ObtenerImpuesto;
  END IF;
  --
  OPEN C_ObtenerImpuesto(Fv_DescripcionImpuesto);
  --
  FETCH C_ObtenerImpuesto INTO Ln_PorcentajeImpuesto;
  --
  CLOSE C_ObtenerImpuesto;
  --
  IF Ln_PorcentajeImpuesto IS NULL THEN
    Ln_PorcentajeImpuesto  := 0;
  END IF;
  --
  RETURN Ln_PorcentajeImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.F_OBTENER_IMPUESTO_POR_DESC', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));  
END F_OBTENER_IMPUESTO_POR_DESC;
--

FUNCTION F_CODIGO_IMPUESTO(
    Fv_TipoImpuesto IN DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_CodigoImpuesto(Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE) IS
    SELECT ID_IMPUESTO
    FROM DB_GENERAL.ADMI_IMPUESTO
    WHERE UPPER(TIPO_IMPUESTO)=Cv_TipoImpuesto
    AND ESTADO                ='Activo';
  --
  Ln_IdImpuesto DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_CodigoImpuesto%ISOPEN THEN
    CLOSE C_CodigoImpuesto;
  END IF;
  --
  OPEN C_CodigoImpuesto(Fv_TipoImpuesto);
  --
  FETCH C_CodigoImpuesto INTO Ln_IdImpuesto;
  --
  CLOSE C_CodigoImpuesto;
  --
  IF Ln_IdImpuesto IS NULL THEN
    Ln_IdImpuesto  := 0;
  END IF;
  --
  RETURN Ln_IdImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.F_CODIGO_IMPUESTO', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));  
END F_CODIGO_IMPUESTO;

--
FUNCTION F_CODIGO_IMPUESTO_X_PORCEN(
    Fv_Porcentaje IN DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE)
  RETURN NUMBER
IS
  CURSOR C_CodigoImpuesto(Cv_Porcentaje DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE) IS
    SELECT ID_IMPUESTO
    FROM DB_GENERAL.ADMI_IMPUESTO
    WHERE PORCENTAJE_IMPUESTO=Cv_Porcentaje;
  --
  Ln_IdImpuesto DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_CodigoImpuesto%ISOPEN THEN
    CLOSE C_CodigoImpuesto;
  END IF;
  --
  OPEN C_CodigoImpuesto(Fv_Porcentaje);
  --
  FETCH C_CodigoImpuesto INTO Ln_IdImpuesto;
  --
  CLOSE C_CodigoImpuesto;
  --
  IF Ln_IdImpuesto IS NULL THEN
    Ln_IdImpuesto  := 0;
  END IF;
  --
  RETURN Ln_IdImpuesto;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.F_CODIGO_IMPUESTO_X_PORCEN', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));  
END F_CODIGO_IMPUESTO_X_PORCEN;
--

FUNCTION F_OBTENER_CICLO(Fv_NombreCiclo IN DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE) 
RETURN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE
IS
  CURSOR C_ObtenerCiclo(Cv_NombreCiclo DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE) IS
    SELECT AC.ID_CICLO
    FROM DB_FINANCIERO.ADMI_CICLO AC
    WHERE UPPER(TRIM(AC.NOMBRE_CICLO))=Cv_NombreCiclo;
  --
  Ln_IdCiclo DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);
BEGIN
  IF C_ObtenerCiclo%ISOPEN THEN
    CLOSE C_ObtenerCiclo;
  END IF;
  --
  OPEN C_ObtenerCiclo(Fv_NombreCiclo);
  --
  FETCH C_ObtenerCiclo INTO Ln_IdCiclo;
  --
  CLOSE C_ObtenerCiclo;
  --
  IF Ln_IdCiclo IS NULL THEN
    Ln_IdCiclo  := 0;
  END IF;
  --
  RETURN Ln_IdCiclo;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.F_OBTENER_CICLO', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));  
END F_OBTENER_CICLO;

FUNCTION F_VERIFICAR_CICLO(Fv_NombreCiclo       IN DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE,
                            Fv_MesVerificar     IN DB_FINANCIERO.INFO_CICLO_FACTURADO.MES_FACTURADO%TYPE,
                            Fv_AnioVerificar    IN DB_FINANCIERO.INFO_CICLO_FACTURADO.ANIO_FACTURADO%TYPE,
                            Fv_TipoFacturacion  IN VARCHAR2,
                            Fn_EmpresaCod       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
RETURN NUMBER
IS
  CURSOR C_VerificarCiclo(Cv_NombreCiclo   DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE,
                          Cv_MesVerificar  DB_FINANCIERO.INFO_CICLO_FACTURADO.MES_FACTURADO%TYPE,
                          Cv_AnioVerificar DB_FINANCIERO.INFO_CICLO_FACTURADO.ANIO_FACTURADO%TYPE,
                          Cn_EmpresaCod    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE) 
  IS
    SELECT COUNT(ICF.ID_CICLO_FACTURADO) AS CANTIDAD 
    FROM DB_FINANCIERO.INFO_CICLO_FACTURADO ICF
    JOIN DB_FINANCIERO.ADMI_CICLO AC ON AC.ID_CICLO=ICF.CICLO_ID
    WHERE
    UPPER(TRIM(AC.NOMBRE_CICLO))       = Cv_NombreCiclo
    AND UPPER(TRIM(ICF.MES_FACTURADO)) = Cv_MesVerificar
    AND ICF.ANIO_FACTURADO             = Cv_AnioVerificar
    AND ICF.EMPRESA_COD                = Cn_EmpresaCod;
  --
  CURSOR C_VerificarCicloComp(Cv_NombreCiclo  DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE,
                          Cv_MesVerificar     DB_FINANCIERO.INFO_CICLO_FACTURADO.MES_FACTURADO%TYPE,
                          Cv_AnioVerificar    DB_FINANCIERO.INFO_CICLO_FACTURADO.ANIO_FACTURADO%TYPE,
                          Cv_TipoFacturacion  VARCHAR2
                          ) 
  IS
    SELECT COUNT(ICF.ID_CICLO_FACTURADO) AS CANTIDAD 
    FROM DB_FINANCIERO.INFO_CICLO_FACTURADO ICF
    JOIN DB_FINANCIERO.ADMI_CICLO AC ON AC.ID_CICLO=ICF.CICLO_ID
    WHERE
    UPPER(TRIM(AC.NOMBRE_CICLO))=Cv_NombreCiclo
    AND UPPER(TRIM(ICF.MES_FACTURADO))=Cv_MesVerificar
    AND ICF.ANIO_FACTURADO=Cv_AnioVerificar
    AND ICF.PROCESO=Cv_TipoFacturacion;
  --
  Ln_Cantidad   NUMBER;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError  VARCHAR2(2000);
BEGIN
  --
  IF C_VerificarCiclo%ISOPEN THEN
    CLOSE C_VerificarCiclo;
  END IF;
  --
  OPEN C_VerificarCiclo(Fv_NombreCiclo,Fv_MesVerificar,Fv_AnioVerificar,Fn_EmpresaCod);
  --
  FETCH C_VerificarCiclo INTO Ln_Cantidad;
  --
  CLOSE C_VerificarCiclo;
  --
  IF Ln_Cantidad IS NULL THEN
    Ln_Cantidad  := 0;
  END IF;
  --
  RETURN Ln_Cantidad;
  EXCEPTION
  WHEN OTHERS THEN
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.F_VERIFICAR_CICLO', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));  
END F_VERIFICAR_CICLO;

PROCEDURE P_GENERAR_FECHA_EMISION(
    Fv_TipoFacturacion  IN VARCHAR2,
    Pv_FeEmision        OUT VARCHAR2,
    Pv_MesEmision       OUT VARCHAR2,
    Pn_MesEmision       OUT VARCHAR2,
    Pv_AnioEmision      OUT VARCHAR2
    )
AS
  Fv_Dia NUMBER;
BEGIN
  --
  SELECT TO_NUMBER(TO_CHAR(SYSDATE,'dd')) INTO Fv_Dia FROM DUAL;
  --Pregunto por el grupo de fechas establecidos
  IF (Fv_Dia>=1 AND Fv_Dia<=15) THEN
    Pv_FeEmision:=TO_CHAR(SYSDATE,'dd/mm/yyyy');
    Pv_MesEmision:=TO_CHAR(SYSDATE,'MONTH','NLS_DATE_LANGUAGE = SPANISH');
    Pn_MesEmision:=TO_CHAR(SYSDATE,'mm');
    Pv_AnioEmision:=TO_CHAR(SYSDATE,'yyyy');
  ELSIF(Fv_Dia>=23 AND Fv_Dia<=31) THEN
    Pv_FeEmision:=TO_CHAR(LAST_DAY(ADD_MONTHS(add_months(SYSDATE,1),-1))+1,'dd/mm/yyyy');
    Pv_MesEmision:=TO_CHAR(LAST_DAY(ADD_MONTHS(add_months(SYSDATE,1),-1))+1,'MONTH','NLS_DATE_LANGUAGE = SPANISH');
    Pn_MesEmision:=TO_CHAR(LAST_DAY(ADD_MONTHS(add_months(SYSDATE,1),-1))+1,'mm');
    Pv_AnioEmision:=TO_CHAR(LAST_DAY(ADD_MONTHS(add_months(SYSDATE,1),-1))+1,'yyyy');
  END IF;
  --
END P_GENERAR_FECHA_EMISION;
  --
  --
  PROCEDURE P_PROCESAR_INFORMACION(
      Prf_ClientesFacturar        IN T_ClientesFacturar,
      Pv_MesEmisionNumeros        IN VARCHAR2,
      Pv_MesEmisionLetras         IN VARCHAR2,
      Pv_AnioEmision              IN VARCHAR2,
      Pv_PrefijoEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
      Pn_IdOficina                IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
      Pv_FeEmision                IN VARCHAR2,
      Pn_Porcentaje               IN NUMBER,
      Pn_RecordCount              IN OUT NUMBER,
      Pv_CuerpoClieNoCompensados  IN OUT CLOB,
      Pn_ClientesFacturados       IN OUT NUMBER,
      Pn_ClientesCompensados      IN OUT NUMBER,
      Pn_ClientesNoCompensados    IN OUT NUMBER,
      Pn_CantNoCompensados        IN OUT NUMBER)
  AS
    --
    --CURSOR QUE RETORNA EL SECTOR_ID DEL PUNTO DE FACTURACION
    --COSTO DEL QUERY: 3
    CURSOR C_GetSectorByPunto(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      --
      SELECT
        SECTOR_ID
      FROM
        DB_COMERCIAL.INFO_PUNTO
      WHERE
        ID_PUNTO = Cn_IdPunto;
      --
    -- C_GetTipoSolicitudReproceso - Costo Query: 5
    CURSOR C_GetValorCargoReproceso (Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
      IS
        SELECT TO_NUMBER(APD.VALOR2)
        FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
        JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC ON   APD.PARAMETRO_ID = APC.ID_PARAMETRO
        WHERE  APC.NOMBRE_PARAMETRO = 'CARGO REPROCESO DEBITO'
        AND    APC.ESTADO           = 'Activo'
        AND    APD.EMPRESA_COD      = Cn_EmpresaCod;
    --
    Lr_Punto                      TypeClientesFacturar;
    Ln_SimularionPorPorcentaje    NUMBER;
    Ln_SimulacionPorValor         NUMBER;
    Ln_DescuentoFacProDetalle     NUMBER;
    Ln_PrecioVentaFacProDetalle   NUMBER;
    Ln_ValorImpuesto              NUMBER;
    Lv_FeActivacion               VARCHAR2(100);

    Ln_IdDetalleSolicitud         DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE;
    Ln_PorcentajeDescuento        DB_COMERCIAL.INFO_DETALLE_SOLICITUD.PORCENTAJE_DESCUENTO%TYPE;
    Ln_Subtotal                   INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL%TYPE;
    Ln_SubtotalConImpuesto        INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_CON_IMPUESTO%TYPE;
    Ln_SubtotalDescuento          INFO_DOCUMENTO_FINANCIERO_CAB.SUBTOTAL_DESCUENTO%TYPE;
    Ln_ValorTotal                 INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;

    Lr_InfoDocumentoFinancieroCab INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocumentoFinancieroDet INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
    Lr_InfoDocumentoFinancieroImp INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
    Lr_InfoDocumentoFinancieroHis INFO_DOCUMENTO_HISTORIAL%ROWTYPE;

    Pv_MsnError                   VARCHAR2(5000);
    LV_BanderaPoseeDetalle        VARCHAR2(2);
    Lv_BanderaSolicitud           VARCHAR2(2);
    Lr_Servicios                  TypeServiciosAsociados;
    Lr_Solicitud                  TypeSolicitudes;

    Lc_ServiciosFacturar          SYS_REFCURSOR;
    Lc_Solicitud                  SYS_REFCURSOR;

    --Mensaje de ERROR para control de la simulacion
    Lv_InfoError                  VARCHAR2(2000);
    Ln_Contador                   NUMBER;

    --Variables de la numeracion
    Lrf_Numeracion                FNKG_TYPES.Lrf_AdmiNumeracion;
    Lr_AdmiNumeracion             FNKG_TYPES.Lr_AdmiNumeracion;

    Lv_EsMatriz                   INFO_OFICINA_GRUPO.ES_MATRIZ%TYPE;
    Lv_EsOficinaFacturacion       INFO_OFICINA_GRUPO.ES_OFICINA_FACTURACION%TYPE;
    Lv_CodigoNumeracion           ADMI_NUMERACION.CODIGO%TYPE;

    Lv_Numeracion                 VARCHAR2(1000);
    Lv_Secuencia                  VARCHAR2(1000);

    Ln_IdImpuesto                 DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE;
    --
    Ln_SectorId                   DB_COMERCIAL.INFO_PUNTO.SECTOR_ID%TYPE;
    Ln_DescuentoCompensacion      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.DESCUENTO_COMPENSACION%TYPE;
    Ln_PorcentajeCompensacion     DB_GENERAL.ADMI_IMPUESTO.PORCENTAJE_IMPUESTO%TYPE;
    Lv_EsCompensado               VARCHAR2(2);
    Ln_ClientesNoCompensados      NUMBER := 0;
    Ln_PtoSolicitudReprocesoId    NUMBER := 0;
    Ln_CantidadSolReproceso       NUMBER := 0;
    Ln_PrecioCargoReproceso       NUMBER := 0;
    Ln_ServicioIdCargoReproceso   NUMBER := 0;
    Lr_SolicitudReprocesoDebito   DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_ProductoReproceso          DB_COMERCIAL.ADMI_PRODUCTO%ROWTYPE;
    Lv_TieneSolCargoReproceso     VARCHAR2(2);
    Lrf_GetSolicitudesReproceso   SYS_REFCURSOR;
    Lb_ValidaFechas               BOOLEAN := TRUE;
    Lv_RangoConsumo               VARCHAR2(2000):='';
    Ld_FechInicioRango            DATE;
    Ld_FechFinRango               DATE;
    Ln_CaracteristicaId           NUMBER := 0;
    Lv_EmpresaCod                 DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE := '';
    --

    --Cursor que obtiene el id de una caracter�stica seg�n su descripci�n, estado y tipo.
    CURSOR C_ObtieneCaracteristica (Cv_DescripcionCaract DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                    Cv_Tipo              DB_COMERCIAL.ADMI_CARACTERISTICA.TIPO%TYPE,
                                    Cv_Estado            DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE) IS
        SELECT ID_CARACTERISTICA
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA
         WHERE DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
           AND ESTADO = Cv_Estado
           AND TIPO   = Cv_Tipo;
    Lr_ObtieneCaracteristica  C_ObtieneCaracteristica%ROWTYPE;
  BEGIN
    --Inicializando
    Lv_EsMatriz               := 'S';
    Lv_EsOficinaFacturacion   := 'S';
    Lv_CodigoNumeracion       := 'FACE';
    Ln_PorcentajeCompensacion := DB_FINANCIERO.FNCK_FACTURACION_MENSUAL.F_OBTENER_IMPUESTO_POR_DESC('COMPENSACION 2%');
    Lv_EmpresaCod             := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP(Pv_PrefijoEmpresa);
    --
    --
    IF Ln_PorcentajeCompensacion IS NULL OR Ln_PorcentajeCompensacion = 0 THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                            'FNCK_FACTURACION_MENSUAL.P_PROCESAR_INFORMACION', 
                                            'No se pudo obtener el porcentaje de compensacion - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                            NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                            SYSDATE, 
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
      --
    END IF;
    --
    IF C_GetValorCargoReproceso%ISOPEN THEN

      CLOSE C_GetValorCargoReproceso;

    END IF;
    --
    OPEN C_GetValorCargoReproceso (Lv_EmpresaCod);
    --
    FETCH C_GetValorCargoReproceso INTO Ln_PrecioCargoReproceso;
    --
    CLOSE C_GetValorCargoReproceso;
    --

    --Se obtiene la caracter�stica por CRS para excluir los servicios.
    OPEN C_ObtieneCaracteristica('FACTURACION_CRS_CICLO_FACT', 'COMERCIAL', 'Activo');
    FETCH C_ObtieneCaracteristica
        INTO Lr_ObtieneCaracteristica;
    CLOSE C_ObtieneCaracteristica;
    Ln_CaracteristicaId := Lr_ObtieneCaracteristica.ID_CARACTERISTICA;

    FOR indx IN 1 .. Prf_ClientesFacturar.COUNT 
    LOOP
      --Contador para los commits, a los 5k se ejecuta
      Pn_RecordCount:= Pn_RecordCount + 1;     

      --Recorriendo la data
      Lr_Punto := Prf_ClientesFacturar(indx);
      --
      --
      --SE CONSULTA EL SECTOR_ID DEL PUNTO DE FACTURACION
      IF C_GetSectorByPunto%ISOPEN THEN
        --
        CLOSE C_GetSectorByPunto;
        --
      END IF;
      --
      OPEN C_GetSectorByPunto( Lr_Punto.id_punto );
      --
      FETCH C_GetSectorByPunto INTO Ln_SectorId;
      --
      CLOSE C_GetSectorByPunto;
      --
      --
      --SE VALIDA SI SE ENCONTRO EL SECTOR DEL PUNTO A FACTURAR
      IF Ln_SectorId IS NULL OR Ln_SectorId = 0 THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_FACTURACION_MENSUAL.P_PROCESAR_INFORMACION', 
                                              'No se pudo obtener el sector del siguiente punto (' || Lr_Punto.id_punto || ') - ' || SQLCODE || 
                                              ' -ERROR- ' || SQLERRM, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      END IF;
      --
      --Simulacion de facturacion que se puede dar en el punto
      P_SIMULAR_FACT_MENSUAL(Lr_Punto.id_punto,Ln_SimularionPorPorcentaje,Ln_SimulacionPorValor);
      
      FNCK_FACTURACION_MENSUAL.P_GET_CLIENT_FACT(Lr_Punto.id_punto,
                                                 Ld_FechInicioRango,
                                                 Ld_FechFinRango,
                                                 Lb_ValidaFechas,
                                                 Lv_RangoConsumo);

      IF (Ln_SimularionPorPorcentaje>0 AND Ln_SimulacionPorValor>0 AND Lb_ValidaFechas) THEN
        --Con el pto ya seleccionado procedemos a ingresar la cabcera, con la informacion existente
        Lr_InfoDocumentoFinancieroCab                       :=NULL;
        Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO          :=SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
        Lr_InfoDocumentoFinancieroCab.OFICINA_ID            :=Lr_Punto.id_oficina;
        Lr_InfoDocumentoFinancieroCab.PUNTO_ID              :=Lr_Punto.id_punto;
        --Modificar a funcion de tipo de documento
        Lr_InfoDocumentoFinancieroCab.TIPO_DOCUMENTO_ID     :=1;
        Lr_InfoDocumentoFinancieroCab.ES_AUTOMATICA         :='S';
        Lr_InfoDocumentoFinancieroCab.PRORRATEO             :='N';
        Lr_InfoDocumentoFinancieroCab.REACTIVACION          :='N';
        Lr_InfoDocumentoFinancieroCab.RECURRENTE            :='S';
        Lr_InfoDocumentoFinancieroCab.COMISIONA             :='S';
        Lr_InfoDocumentoFinancieroCab.FE_CREACION           :=sysdate;
        Lr_InfoDocumentoFinancieroCab.USR_CREACION          :='telcos';
        Lr_InfoDocumentoFinancieroCab.ES_ELECTRONICA        :='S';
        Lr_InfoDocumentoFinancieroCab.RANGO_CONSUMO         :=Lv_RangoConsumo;
        Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT :='Pendiente';
        FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab,Pv_MsnError);
        --Con la informacion de cabecera se inserta el historial
        Lr_InfoDocumentoFinancieroHis                       :=NULL;
        Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:=SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
        Lr_InfoDocumentoFinancieroHis.FE_CREACION           :=SYSDATE;
        Lr_InfoDocumentoFinancieroHis.USR_CREACION          :='telcos';
        Lr_InfoDocumentoFinancieroHis.ESTADO                :='Pendiente';
        Lr_InfoDocumentoFinancieroHis.OBSERVACION           :='Se crea la factura';
        FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Pv_MsnError);
        --Inicializo la bandera que se utilizara para los detalles
        LV_BanderaPoseeDetalle:='N';
        --Inicializo la bandera que se utilizara para agregar los detalles  por reproceso de d�bito.
        Lv_TieneSolCargoReproceso := 'N';
        --Con el pto de facturacion podemos obtener los servicios asociados al punto
        GET_SERVICIO_ASOCIADOS(Lr_Punto.id_punto, Ln_CaracteristicaId ,Lc_ServiciosFacturar);
        LOOP
          --Inicializo la bandera por cada servicio, como por defecto que se facture todos los servicios
          Lv_BanderaSolicitud:='S';
          FETCH Lc_ServiciosFacturar INTO Lr_Servicios;
          IF Lc_ServiciosFacturar%notfound THEN
            Lv_BanderaSolicitud:='N';
          END IF;
          EXIT
          WHEN Lc_ServiciosFacturar%notfound;

          -- Se verifica si existe solicitud de reproceso de d�bito.
          IF Lv_TieneSolCargoReproceso = 'N' THEN

            Ln_PtoSolicitudReprocesoId   := 0;
            Ln_ServicioIdCargoReproceso  := 0;
            Lr_ProductoReproceso         := NULL;
            Lrf_GetSolicitudesReproceso  := NULL;

            Lrf_GetSolicitudesReproceso  := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_SOL_PEND_BY_SER_ID('SOLICITUD CARGO REPROCESO DEBITO', 
                                                                                                  Lr_Servicios.id_servicio);

            Ln_CantidadSolReproceso      := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_SOL_BY_SERVICIO_ID(Lr_Servicios.id_servicio,
                                                                                                  'SOLICITUD CARGO REPROCESO DEBITO',
                                                                                                  'Pendiente');
            IF Ln_CantidadSolReproceso > 0 THEN
              Lv_TieneSolCargoReproceso   := 'S';
              Ln_ServicioIdCargoReproceso := Lr_Servicios.id_servicio;
              Ln_PtoSolicitudReprocesoId  := Lr_Servicios.punto_id;
              Lr_ProductoReproceso        := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_PRODUCTO_BY_COD('CGC');

            END IF;
          END IF;

          --Con los servicios verifico si posee solicitudes
          GET_SOLICITUDES_CANCEL_SUSP(Lr_Servicios.id_servicio,Lc_Solicitud);
          LOOP
            FETCH Lc_Solicitud INTO Lr_Solicitud;
            IF Lc_Solicitud%notfound THEN
              Lv_BanderaSolicitud:='S';
            END IF;
            EXIT
            WHEN Lc_Solicitud%notfound;
            --Segun el tipo de solicitud verifico si el servicio se facturara o no
            IF Lr_Solicitud.descripcion_solicitud   ='SOLICITUD CANCELACION' THEN
              Lv_BanderaSolicitud                  :='N';
            ELSIF Lr_Solicitud.descripcion_solicitud='SOLICITUD SUSPENSION TEMPORAL' THEN
              Lv_BanderaSolicitud                  :='N';
            ELSE
              Lv_BanderaSolicitud:='S';
            END IF;
          END LOOP;
          --Cierro el cursor de las solicitudes
          CLOSE Lc_Solicitud;

          --Dependiendo de la bandera de solicitud hago los sigts pasos
          IF Lv_BanderaSolicitud='S' THEN
            --Inicializo

            Ln_DescuentoFacProDetalle:=0;
            --Con los servicios verifico si posee descuento unico

            GET_SOL_DESCT_UNICO(Lr_Servicios.id_servicio,Ln_IdDetalleSolicitud,Ln_PorcentajeDescuento);
            --Si posee porcentaje de descuento, realizo los calculos
            --Debo actualizar la solicitud
            IF Ln_PorcentajeDescuento IS NOT NULL AND Ln_PorcentajeDescuento>0 THEN
              UPD_SOL_DESCT_UNICO(Ln_IdDetalleSolicitud);
              Ln_DescuentoFacProDetalle:=ROUND(((Lr_Servicios.cantidad*Lr_Servicios.precio_venta)*Ln_PorcentajeDescuento)/100,2);
            --Verifico si posee descuento fijo por porcentaje o valor; ya que este es el mandatorio  
            ELSIF Lr_Servicios.porcentaje_descuento>0 THEN
               Ln_DescuentoFacProDetalle        :=ROUND(((Lr_Servicios.cantidad*Lr_Servicios.precio_venta)*Lr_Servicios.porcentaje_descuento)/100,2);
            ELSIF Lr_Servicios.valor_descuento  >0 THEN
              Ln_DescuentoFacProDetalle        :=ROUND(Lr_Servicios.valor_descuento,2); 
            ELSE                
              GET_SOL_DESCT_PROMOCIONAL(Lr_Servicios.id_servicio,Ln_IdDetalleSolicitud,Ln_PorcentajeDescuento); 
              IF Ln_PorcentajeDescuento IS NOT NULL AND Ln_PorcentajeDescuento>0 THEN
                UPD_SOL_DESCT_UNICO(Ln_IdDetalleSolicitud);
                Ln_DescuentoFacProDetalle:=ROUND(((Lr_Servicios.cantidad*Lr_Servicios.precio_venta)*Ln_PorcentajeDescuento)/100,2);
              END IF;  
            END IF;

            --Con los valores obtenidos procedo hacer los calculos para cada servicio
            Ln_PrecioVentaFacProDetalle:=0;
            Ln_PrecioVentaFacProDetalle:=ROUND((Lr_Servicios.cantidad*Lr_Servicios.precio_venta),2);
            --
            --Calcula el valor del impuesto correspondiente al detalle
            Ln_ValorImpuesto := 0;
            Ln_ValorImpuesto := ((Ln_PrecioVentaFacProDetalle-Ln_DescuentoFacProDetalle)*Pn_Porcentaje/100);

            --Con el precio de venta nuevo procedemos a ingresar los valores del detalle
            Lr_InfoDocumentoFinancieroDet                            :=NULL;
            Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE             :=SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
            Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID               :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
            Lr_InfoDocumentoFinancieroDet.PUNTO_ID                   :=Lr_Servicios.punto_id;
            Lr_InfoDocumentoFinancieroDet.PLAN_ID                    :=Lr_Servicios.plan_id;
            Lr_InfoDocumentoFinancieroDet.CANTIDAD                   :=Lr_Servicios.cantidad;
            Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE:=ROUND(Lr_Servicios.precio_venta,2);
            Lr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO:=Ln_PorcentajeDescuento;
            Lr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE   :=Ln_DescuentoFacProDetalle;
            Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE       :=ROUND(Lr_Servicios.precio_venta,2);
            Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE       :=ROUND(Lr_Servicios.precio_venta,2);
            Lr_InfoDocumentoFinancieroDet.FE_CREACION                :=sysdate;
            Lr_InfoDocumentoFinancieroDet.USR_CREACION               :='telcos';
            Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                :=Lr_Servicios.producto_id;
            Lr_InfoDocumentoFinancieroDet.SERVICIO_ID                :=Lr_Servicios.id_servicio;
            --Obtengo la Fe_activacion del servicio
            Lv_FeActivacion                                              :=GET_FECHA_ACTIVACION(Lr_Servicios.id_servicio);
            Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE  :=TRIM('Consumo: '||Lv_RangoConsumo);  
            IF Lv_FeActivacion                                           IS NOT NULL THEN
              Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE:=TRIM(Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE 
                                                                                || ', Fecha de Activacion: '|| Lv_FeActivacion);
            END IF;
            FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinancieroDet,Pv_MsnError);
            --Pregunto si se guardo el detalle
            IF Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE>0 THEN
              LV_BanderaPoseeDetalle:='S';
            ELSE
              LV_BanderaPoseeDetalle:='N';
            END IF;


            --Con los valores de detalle insertado, podemos ingresar el impuesto
            Lr_InfoDocumentoFinancieroImp               :=NULL;
            Lr_InfoDocumentoFinancieroImp.ID_DOC_IMP    :=SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
            Lr_InfoDocumentoFinancieroImp.DETALLE_DOC_ID:=Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE;

            --Modificar funcion del impuesto
            --Debemos obtener el impuesto en base al porcentaje enviado en el arreglo
            Ln_IdImpuesto                               :=F_CODIGO_IMPUESTO_X_PORCEN(Pn_Porcentaje);
            --
            Lr_InfoDocumentoFinancieroImp.IMPUESTO_ID   :=Ln_IdImpuesto;
            Lr_InfoDocumentoFinancieroImp.VALOR_IMPUESTO:=Ln_ValorImpuesto;
            Lr_InfoDocumentoFinancieroImp.PORCENTAJE    :=Pn_Porcentaje;
            Lr_InfoDocumentoFinancieroImp.FE_CREACION   :=sysdate;
            Lr_InfoDocumentoFinancieroImp.USR_CREACION  :='telcos';
            FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinancieroImp,Pv_MsnError);
          ELSE
            --
            Lv_InfoError := 'Punto de Facturacion:' || Lr_Punto.id_punto || ' No se factura el servicio: ' || Lr_Servicios.id_servicio 
                            || ' Bandera de solicitud:'||Lv_BanderaSolicitud;
            --
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                  'FNCK_FACTURACION_MENSUAL.P_PROCESAR_INFORMACION', 
                                                  Lv_InfoError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                  NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                                  SYSDATE, 
                                                  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
            --
          END IF;
        END LOOP;

        --Se termina de procesar los servicios
        --Cierro el cursor de los servicios
        CLOSE Lc_ServiciosFacturar;

        IF Lv_TieneSolCargoReproceso = 'S' THEN

          Ln_PrecioVentaFacProDetalle:=ROUND((Ln_CantidadSolReproceso*Ln_PrecioCargoReproceso),2);

          -- Finalizamos la solicitud de cargo por reproceso de d�bito
          LOOP
            --
            FETCH
              Lrf_GetSolicitudesReproceso
            INTO
              Lr_SolicitudReprocesoDebito;
            --
            EXIT
              WHEN Lrf_GetSolicitudesReproceso%NOTFOUND;

            UPD_SOL_DESCT_UNICO(Lr_SolicitudReprocesoDebito.ID_DETALLE_SOLICITUD);

          END LOOP;

          CLOSE Lrf_GetSolicitudesReproceso;

          -- Se agrega detalle por cargo de reproceso de d�bito.
          Lr_InfoDocumentoFinancieroDet                                := NULL;
          Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE                 := SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
          Lr_InfoDocumentoFinancieroDet.DOCUMENTO_ID                   := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
          Lr_InfoDocumentoFinancieroDet.PUNTO_ID                       := Ln_PtoSolicitudReprocesoId;
          Lr_InfoDocumentoFinancieroDet.PLAN_ID                        := 0;
          Lr_InfoDocumentoFinancieroDet.CANTIDAD                       := Ln_CantidadSolReproceso;
          Lr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE    := ROUND(Ln_PrecioCargoReproceso,2);
          Lr_InfoDocumentoFinancieroDet.PORCETANJE_DESCUENTO_FACPRO    := 0;
          Lr_InfoDocumentoFinancieroDet.DESCUENTO_FACPRO_DETALLE       := 0;
          Lr_InfoDocumentoFinancieroDet.VALOR_FACPRO_DETALLE           := ROUND(Ln_PrecioCargoReproceso,2);
          Lr_InfoDocumentoFinancieroDet.COSTO_FACPRO_DETALLE           := ROUND(Ln_PrecioCargoReproceso,2);
          Lr_InfoDocumentoFinancieroDet.FE_CREACION                    := sysdate;
          Lr_InfoDocumentoFinancieroDet.USR_CREACION                   := 'telcos';
          Lr_InfoDocumentoFinancieroDet.PRODUCTO_ID                    := Lr_ProductoReproceso.ID_PRODUCTO;
          Lr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE  := '';
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinancieroDet,Pv_MsnError);

          --Con los valores de detalle insertado, podemos ingresar el impuesto

          Ln_ValorImpuesto := (Ln_PrecioVentaFacProDetalle*Pn_Porcentaje/100);

          Lr_InfoDocumentoFinancieroImp                := NULL;
          Lr_InfoDocumentoFinancieroImp.ID_DOC_IMP     := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
          Lr_InfoDocumentoFinancieroImp.DETALLE_DOC_ID := Lr_InfoDocumentoFinancieroDet.ID_DOC_DETALLE;

          Ln_IdImpuesto                                := F_CODIGO_IMPUESTO_X_PORCEN(Pn_Porcentaje);
          --
          Lr_InfoDocumentoFinancieroImp.IMPUESTO_ID    := Ln_IdImpuesto;
          Lr_InfoDocumentoFinancieroImp.VALOR_IMPUESTO := Ln_ValorImpuesto;
          Lr_InfoDocumentoFinancieroImp.PORCENTAJE     := Pn_Porcentaje;
          Lr_InfoDocumentoFinancieroImp.FE_CREACION    := sysdate;
          Lr_InfoDocumentoFinancieroImp.USR_CREACION   := 'telcos';
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinancieroImp,Pv_MsnError);

        END IF;
        --

        --Se debe obtener las sumatorias de los Subtotales y se actualiza las cabeceras
        Ln_Subtotal              := 0;
        Ln_SubtotalDescuento     := 0;
        Ln_SubtotalConImpuesto   := 0;
        Ln_ValorTotal            := 0;
        Ln_DescuentoCompensacion := 0;
        Lv_EsCompensado          := 'N';

        Ln_Subtotal            := ROUND( NVL(F_SUMAR_SUBTOTAL(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0), 2);
        Ln_SubtotalDescuento   := ROUND( NVL(F_SUMAR_DESCUENTO(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0), 2);
        Ln_SubtotalConImpuesto := ROUND( NVL(P_SUMAR_IMPUESTOS(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO),0), 2);

        /**
        * BLOQUE COMPENSACION
        * SE VERIFICA SI EL CLIENTE DEBE COMPENSAR, Y SE CALCULA EL VALOR DE COMPENSACION
        */
        --
        --PRIMERO VERIFICAMOS SI EL CLIENTE COMPENSA
        IF Ln_SectorId IS NOT NULL AND Ln_SectorId > 0 THEN
          --
          Lv_EsCompensado := DB_FINANCIERO.FNCK_CONSULTS.F_VALIDA_CLIENTE_COMPENSADO(Lr_Punto.ID_PERSONA_ROL,
                                                                                     Lr_Punto.ID_OFICINA,
                                                                                     Lr_Punto.EMPRESA_ID,
                                                                                     Ln_SectorId,
                                                                                     Lr_Punto.ID_PUNTO);
          --
          IF Lv_EsCompensado IS NOT NULL AND Lv_EsCompensado = 'S' THEN
            --
            --VERIFICAMOS SI EXISTE EL PORCENTAJE PARA COMPENSAR AL CLIENTE
            IF Ln_PorcentajeCompensacion IS NOT NULL AND Ln_PorcentajeCompensacion > 0 THEN
              --
              Ln_DescuentoCompensacion := NVL( (ROUND( (( NVL( (ROUND(NVL(Ln_Subtotal, 0), 2) - ROUND(NVL(Ln_SubtotalDescuento, 0), 2)), 0 )
                                                        * Ln_PorcentajeCompensacion) / 100), 2)) , 0);
              --
            END IF;
            --
          END IF;
          --
        END IF;
        --
        /**
        * FIN BLOQUE COMPENSACION
        */

        Ln_ValorTotal := NVL( NVL(Ln_Subtotal, 0) - NVL(Ln_SubtotalDescuento, 2) - NVL(Ln_DescuentoCompensacion, 0) + NVL(Ln_SubtotalConImpuesto, 0)
                              , 0);

        --Actualizo los valores
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL               := Ln_Subtotal;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CERO_IMPUESTO := Ln_Subtotal;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_CON_IMPUESTO  := Ln_SubtotalConImpuesto;
        Lr_InfoDocumentoFinancieroCab.SUBTOTAL_DESCUENTO     := Ln_SubtotalDescuento;
        Lr_InfoDocumentoFinancieroCab.DESCUENTO_COMPENSACION := Ln_DescuentoCompensacion;
        Lr_InfoDocumentoFinancieroCab.VALOR_TOTAL            := Ln_ValorTotal;

        --Actualizo la numeracion y el estado
        IF Ln_ValorTotal >0 THEN
          Lrf_Numeracion:=FNCK_CONSULTS.F_GET_NUMERACION(Pv_PrefijoEmpresa,Lv_EsMatriz,Lv_EsOficinaFacturacion,Pn_IdOficina,Lv_CodigoNumeracion);
          --Debo recorrer la numeracion obtenida
          LOOP
            FETCH Lrf_Numeracion INTO Lr_AdmiNumeracion;
            EXIT
          WHEN Lrf_Numeracion%notfound;
            Lv_Secuencia :=LPAD(Lr_AdmiNumeracion.SECUENCIA,9,'0');
            Lv_Numeracion:=Lr_AdmiNumeracion.NUMERACION_UNO || '-'||Lr_AdmiNumeracion.NUMERACION_DOS||'-'||Lv_Secuencia;
          END LOOP;
          --Cierro la numeracion
          CLOSE Lrf_Numeracion;
          Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI   :=Lv_Numeracion;
          Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:='Pendiente';
          Lr_InfoDocumentoFinancieroCab.FE_EMISION           :=TO_DATE(Pv_FeEmision,'dd-mm-yyyy');

          --Actualizo los valores de la cabecera
          FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Pv_MsnError);

          --Incremento la numeracion
          Lr_AdmiNumeracion.SECUENCIA:=Lr_AdmiNumeracion.SECUENCIA+1;
          FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lr_AdmiNumeracion.ID_NUMERACION,Lr_AdmiNumeracion,Pv_MsnError);
          --
          --SE AUMENTA EN UNO A LA CANTIDAD DE CLIENTES FACTURADOS
          Pn_ClientesFacturados := Pn_ClientesFacturados + 1;
          --
          --SE VERIFICA SI EL CLIENTE DEBIA COMPENSAR
          IF Lv_EsCompensado IS NOT NULL AND Lv_EsCompensado = 'S' THEN
            --
            --SE VERIFICA SI EL CLIENTE FUE COMPENSADO
            IF Ln_DescuentoCompensacion IS NOT NULL AND Ln_DescuentoCompensacion > 0 THEN
              --
              --SE AUMENTA EN UNO A LA CANTIDAD DE CLIENTES COMPENSADOS
              Pn_ClientesCompensados := Pn_ClientesCompensados + 1;
              --
            ELSE
              --
              --SE AUMENTA EN UNO A LA CANTIDAD DE CLIENTES NO COMPENSADOS Y SE GUARDA LA INFORMACION DEL CLIENTE NO COMPENSADO QUE DEBIA COMPENSAR
              --PARA LUEGO SER NOTIFICADO AL USUARIO
              Pn_ClientesNoCompensados   := Pn_ClientesNoCompensados + 1;
              Pn_CantNoCompensados       := Pn_CantNoCompensados + 1;
              Pv_CuerpoClieNoCompensados := Pv_CuerpoClieNoCompensados || '<tr>' ||
                                                                            '<td>' || Lr_Punto.IDENTIFICACION_CLIENTE  ||'</td>' ||
                                                                            '<td>' || Lr_Punto.CLIENTE  ||'</td>' ||
                                                                            '<td>' || Lr_Punto.LOGIN  ||'</td>' ||
                                                                          '</tr>';
              --
              --
              IF Pn_CantNoCompensados = 100 THEN
                --
                DB_FINANCIERO.FNKG_NOTIFICACIONES.P_NOTIFICAR_FACTURACION_MASIVA(Pv_CuerpoClieNoCompensados, 
                                                                                 'FAC_MD_SIN_COMP', 
                                                                                 Lr_Punto.EMPRESA_ID, 
                                                                                 Lv_InfoError);
                --
                IF TRIM(Lv_InfoError) IS NOT NULL THEN
                  --
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                                        'FNCK_FACTURACION_MENSUAL.P_PROCESAR_INFORMACION', 
                                                        Lv_InfoError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                        NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                                        SYSDATE, 
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                  --
                END IF;
                --
                Pn_CantNoCompensados       := 0;
                Pv_CuerpoClieNoCompensados := '';
                --
              END IF;
              --
              --
            END IF;
            --
          END IF;
          --
        ELSE
          -- Se actualiza el estado de la cabecera de la factura a Eliminado, debido a que no posee detalles y su valorTotal es 0 o nulo.
          Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:='Eliminado';
          FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,Lr_InfoDocumentoFinancieroCab,Pv_MsnError);
          
          --Se inserta el historial de Eliminado.
          Lr_InfoDocumentoFinancieroHis                       :=NULL;
          Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:=SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
          Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          :=Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
          Lr_InfoDocumentoFinancieroHis.FE_CREACION           :=SYSDATE;
          Lr_InfoDocumentoFinancieroHis.USR_CREACION          :='telcos';
          Lr_InfoDocumentoFinancieroHis.ESTADO                :='Eliminado';
          Lr_InfoDocumentoFinancieroHis.OBSERVACION           :='Se elimina el documento debido a que no posee detalles';
          FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Pv_MsnError);
          --
        END IF;
        --
        -- Verifica Incremento el contador, para poder hacer el commit
        IF Pn_RecordCount>=5000 THEN
          COMMIT;
          Pn_RecordCount:=0;
        END IF;

      ELSE
        Lv_InfoError := 'Punto de Facturacion:' || Lr_Punto.id_punto || ' Ln_SimularionPorPorcentaje:' || Ln_SimularionPorPorcentaje || 
                        ' Ln_SimulacionPorValor:' || Ln_SimulacionPorValor;
        --
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_FACTURACION_MENSUAL.P_PROCESAR_INFORMACION', 
                                              Lv_InfoError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      END IF;

    END LOOP;

    EXCEPTION
    WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO.SEND_MAIL_PLANTILLA(
        'facturacion@telcos.ec',
        'Error Facturacion Masiva',
        DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13),
        'FACE');    
    --Salida del BULK
  END P_PROCESAR_INFORMACION;
  --
  --
  PROCEDURE P_FACTURACION_MENSUAL(
      Pn_EmpresaCod          IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
      Pv_DescripcionImpuesto IN DB_GENERAL.ADMI_IMPUESTO.DESCRIPCION_IMPUESTO%TYPE,
      Pv_TipoFacturacion     IN VARCHAR2)
  IS
  
  --Consulta del ciclo de facturaci�n
  CURSOR C_ConsultaCiclos (Cn_EmpresaCod DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT AC.ID_CICLO,UPPER(TRIM(AC.NOMBRE_CICLO)) as NOMBRE_CICLO, 1 as BANDERA
      FROM DB_FINANCIERO.ADMI_CICLO AC
      WHERE TO_CHAR(AC.FE_INICIO,'DD') = TO_CHAR(SYSDATE,'DD')
      AND AC.ESTADO                    IN ('Activo','Inactivo')
      AND   AC.EMPRESA_COD             = Cn_EmpresaCod;

  --Variable cursor de los ciclos
  Lc_ConsultaCiclos C_ConsultaCiclos%ROWTYPE;

  --Listados
  Lc_PuntosFacturar     SYS_REFCURSOR;
  C_PuntosFacturar      SYS_REFCURSOR;

  --Tipos definidos
  Lr_Punto              TypeClientesFacturar;

  --Tipos de equivalentes a las tablas
  Ln_Id_Producto                DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE;
  Lv_PrefijoEmpresa             INFO_EMPRESA_GRUPO.PREFIJO%TYPE;
  Ln_IdOficina                  INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;
  Lr_InfoCicloFacturacion       INFO_CICLO_FACTURADO%ROWTYPE;

  --Variables
  Pv_MsnError                 VARCHAR2(5000);
  Ln_Precio                   NUMBER;
  Pn_UsrCreacion              VARCHAR2(20);
  Ln_Porcentaje               NUMBER;

  --Log de ejecucion
  Lv_ArchivoNombre            VARCHAR2(2000);
  Log_File                    UTL_FILE.FILE_TYPE;

  --Mensaje de ERROR para control de la simulacion
  Lv_InfoError                VARCHAR2(2000);

  --Tipo para el BULK
  Cn_Puntos_Facturar          T_ClientesFacturar;
  indx                        NUMBER;
  Ln_RecordCount              NUMBER(04):=0;

  --Generacion de fecha emision
  Lv_FeEmision                VARCHAR2(20);
  Ln_MesEmision               VARCHAR2(20);
  Lv_MesEmision               DB_FINANCIERO.INFO_CICLO_FACTURADO.MES_FACTURADO%TYPE;
  Lv_AnioEmision              DB_FINANCIERO.INFO_CICLO_FACTURADO.ANIO_FACTURADO%TYPE;

  --Informacion del ciclo
  Lv_NombreCiclo              DB_FINANCIERO.ADMI_CICLO.NOMBRE_CICLO%TYPE;
  Ln_CantidadCiclo            NUMBER;

  --Query de consulta del script
  Lv_Consulta                 VARCHAR2(30000);
  --
  --
  Lv_CuerpoClieNoCompensados  CLOB   := '';
  Ln_ClientesFacturados       NUMBER := 0;
  Ln_ClientesCompensados      NUMBER := 0;
  Ln_ClientesNoCompensados    NUMBER := 0;
  Ln_CantNoCompensados        NUMBER := 0;
  Lv_CuerpoMensaje            CLOB   := '';
  --
BEGIN

  OPEN C_ConsultaCiclos (Pn_EmpresaCod);
  FETCH C_ConsultaCiclos INTO Lc_ConsultaCiclos;
  CLOSE C_ConsultaCiclos;
  --Validacion de Ciclo de Facturaci�n
  IF Lc_ConsultaCiclos.BANDERA IS NULL THEN
    RETURN;
  END IF;

  --Seteamos el porcentaje de IVA
  --Se debe recibir como parametro el IVA a facturar
  Ln_Porcentaje:=F_OBTENER_IMPUESTO_POR_DESC(Pv_DescripcionImpuesto);
  
  --Generamos la consulta como string para segun el TipoFacturacion procesar
  --COSTO QUERY: 376
  Lv_Consulta := 'SELECT 
    iog.empresa_id, 
    iog.id_oficina, 
    iper.id_persona_rol, 
    iper.persona_id, 
    ipu.login, 
    iper.empresa_rol_id, 
    ier.rol_id, 
    ar.descripcion_rol, 
    atr.descripcion_tipo_rol, 
    ipu.id_punto,
    CASE
      WHEN per.RAZON_SOCIAL IS NOT NULL THEN
        per.RAZON_SOCIAL
      ELSE
        CONCAT(per.NOMBRES, CONCAT('' '', per.APELLIDOS))
    END AS CLIENTE,
    per.IDENTIFICACION_CLIENTE,
    ipu.estado,'||q'['S']'||' as es_padre_facturacion,' || q'['N']'||'as gasto_administrativo
    FROM DB_COMERCIAL.info_oficina_grupo iog 
    JOIN DB_COMERCIAL.info_persona_empresa_rol iper ON iper.oficina_id=iog.id_oficina 
    JOIN DB_COMERCIAL.info_persona per ON per.id_persona=iper.persona_id 
    JOIN DB_COMERCIAL.info_empresa_rol ier ON ier.id_empresa_rol=iper.empresa_rol_id 
    JOIN DB_GENERAL.admi_rol ar ON ar.id_rol=ier.rol_id 
    JOIN DB_GENERAL.admi_tipo_rol atr ON atr.id_tipo_rol=ar.tipo_rol_id 
    JOIN DB_COMERCIAL.info_punto ipu ON IPU.PERSONA_EMPRESA_ROL_ID=iper.id_persona_rol 
    JOIN DB_GENERAL.ADMI_SECTOR ASE ON ASE.ID_SECTOR=ipu.SECTOR_ID
    JOIN DB_GENERAL.ADMI_PARROQUIA AP ON AP.ID_PARROQUIA=ASE.PARROQUIA_ID
    JOIN DB_GENERAL.ADMI_CANTON AC ON AC.ID_CANTON=AP.CANTON_ID
    JOIN DB_COMERCIAL.info_servicio iser ON iser.PUNTO_FACTURACION_ID=ipu.id_punto 
    WHERE iog.empresa_id='||Pn_EmpresaCod||
    ' AND ier.empresa_cod='||Pn_EmpresaCod||
    ' AND (iper.estado='||q'['Activo']'||' OR iper.estado='||q'['Modificado']'||')
      AND EXISTS (
        SELECT null from DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL ipda 
        WHERE ipda.punto_id=ipu.id_punto
        AND ipda.es_padre_facturacion='||q'['S']'||'
      )
      AND atr.descripcion_tipo_rol='||q'['Cliente']'||'
      AND ar.descripcion_rol='||q'['Cliente']'||'
      AND iser.ESTADO='||q'['Activo']'||'
      AND iser.cantidad>0 
      AND iser.ES_VENTA='||q'['S']'||'
      AND iser.precio_venta>0 
      AND iser.frecuencia_producto=1
      AND EXISTS (
        Select 1
        from DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC iperc,
             DB_COMERCIAL.ADMI_CARACTERISTICA ac
        where iperc.PERSONA_EMPRESA_ROL_ID=iper.id_persona_rol
          and AC.ID_CARACTERISTICA=IPERC.CARACTERISTICA_ID
          and iperc.ESTADO=''Activo''
          and IPERC.VALOR = '''||Lc_ConsultaCiclos.ID_CICLO||'''
          and AC.DESCRIPCION_CARACTERISTICA=''CICLO_FACTURACION''
      )';

     Lv_Consulta:= Lv_Consulta || ' group by iog.empresa_id, 
      iog.id_oficina, 
      iper.id_persona_rol, 
      iper.persona_id, 
      ipu.login, 
      iper.empresa_rol_id, 
      ier.rol_id, 
      ar.descripcion_rol, 
      atr.descripcion_tipo_rol, 
      ipu.id_punto, 
      ipu.estado,
      per.IDENTIFICACION_CLIENTE,
      per.NOMBRES,
      per.APELLIDOS,
      per.RAZON_SOCIAL';

  --Seteamos fe_emision
  P_GENERAR_FECHA_EMISION_CICLOS(Lc_ConsultaCiclos.ID_CICLO,Lv_FeEmision,Lv_MesEmision,Ln_MesEmision,Lv_AnioEmision);

  --Previo a la ejecucion del proceso de facturacion, verifico , valido o ingreso el log de la ejecucion de la facturacion
  Ln_CantidadCiclo:= 0;
  Lv_NombreCiclo  := Lc_ConsultaCiclos.NOMBRE_CICLO;
  Ln_CantidadCiclo:= F_VERIFICAR_CICLO(Lv_NombreCiclo,UPPER(TRIM(Lv_MesEmision)),UPPER(TRIM(Lv_AnioEmision)),Pv_TipoFacturacion,Pn_EmpresaCod);

  --Inicializando variable de error
  Lv_InfoError:='';
  IF(Ln_CantidadCiclo>0)THEN
    --Escribir que el proceso ya se ejecuto
    Lv_InfoError:='F_VERIFICAR_CICLO, Ln_CantidadCiclo: '||Ln_CantidadCiclo ||
                    ', Ciclo ya procesado: Lv_NombreCiclo:'||Lv_NombreCiclo ||'-'||
                    'Lv_MesEmision:'||UPPER(TRIM(Lv_MesEmision))||'-'||
                    'Lv_AnioEmision'||UPPER(TRIM(Lv_AnioEmision));
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 'FNCK_FACTURACION_MENSUAL.P_FACTURACION_MENSUAL', Lv_InfoError);
  ELSE

    --Si no hay un registro debemos crear la ejecucion del proceso
    Lr_InfoCicloFacturacion.ID_CICLO_FACTURADO  := DB_FINANCIERO.SEQ_INFO_CICLO_FACTURADO.NEXTVAL;
    Lr_InfoCicloFacturacion.CICLO_ID            := Lc_ConsultaCiclos.ID_CICLO;
    Lr_InfoCicloFacturacion.EMPRESA_COD         := Pn_EmpresaCod;
    Lr_InfoCicloFacturacion.MES_FACTURADO       := UPPER(TRIM(Lv_MesEmision));
    Lr_InfoCicloFacturacion.ANIO_FACTURADO      := Lv_AnioEmision;
    Lr_InfoCicloFacturacion.FE_EJE_INICIO       := SYSDATE;
    Lr_InfoCicloFacturacion.USR_CREACION        := 'telcos';
    --Se mete la informacion referente al proceso ejecutado
    Lr_InfoCicloFacturacion.PROCESO           := 'MENSUAL';
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_CICLO_FACTURACION(Lr_InfoCicloFacturacion,Lv_InfoError);

    --Guardamos la confirmacion de la ejecuci�n del paquete
    IF(Lv_InfoError IS NULL) THEN
      COMMIT;
    END IF;

    --Seteamos variables para obtener las numeraciones
    GET_PREFIJO_OFICINA(Pn_EmpresaCod,Lv_PrefijoEmpresa,Ln_IdOficina);

    --Obtengo los pos a facturar: Para las pruebas se han considerado 10
    --Se llama el cursor del BULK
    --Se llama al cursor de diferente manera ya que evaluamos un string
    OPEN C_PuntosFacturar FOR Lv_Consulta;
    LOOP
      FETCH C_PuntosFacturar BULK COLLECT INTO Cn_Puntos_Facturar LIMIT 5000;
      --Llamada al proceso de escritura
      P_PROCESAR_INFORMACION (
      Cn_Puntos_Facturar,
      Ln_MesEmision,
      Lv_MesEmision,
      Lv_AnioEmision,
      Lv_PrefijoEmpresa,
      Ln_IdOficina,
      Lv_FeEmision,
      Ln_Porcentaje,
      Ln_RecordCount,
      Lv_CuerpoClieNoCompensados,
      Ln_ClientesFacturados,
      Ln_ClientesCompensados,
      Ln_ClientesNoCompensados,
      Ln_CantNoCompensados
      );
      --Llamada al proceso de escritura
      EXIT WHEN C_PuntosFacturar%NOTFOUND;

    END LOOP;
    CLOSE C_PuntosFacturar;

    --Ha terminado el proceso
    Lr_InfoCicloFacturacion.FE_EJE_FIN:= SYSDATE;
    DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_CICLO_FACTURACION(Lr_InfoCicloFacturacion.ID_CICLO_FACTURADO,Lr_InfoCicloFacturacion,Lv_InfoError);

    if Ln_RecordCount >=0 then
       commit;
    End if;
    --
    --
    IF Ln_CantNoCompensados < 100 THEN
      --
      DB_FINANCIERO.FNKG_NOTIFICACIONES.P_NOTIFICAR_FACTURACION_MASIVA(Lv_CuerpoClieNoCompensados, 
                                                                       'FAC_MD_SIN_COMP', 
                                                                       Pn_EmpresaCod, 
                                                                       Lv_InfoError);
      --
      --
      IF TRIM(Lv_InfoError) IS NOT NULL THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_FACTURACION_MENSUAL.P_FACTURACION_MENSUAL', 
                                              Lv_InfoError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      END IF;
      --
    END IF;
    --
    --
    IF Ln_ClientesFacturados IS NOT NULL AND Ln_ClientesFacturados > 0 THEN
      --
      Lv_InfoError     := NULL;
      Lv_CuerpoMensaje := '<table class = ''cssTable'' align=''center'' >' ||
                            '<tr>' ||
                              '<th> Total de Clientes Facturados </th>' ||
                              '<td>' || Ln_ClientesFacturados || '</td>' ||
                            '</tr>' ||
                            '<tr>' ||
                              '<th> Total de Clientes Compensados </th>' ||
                              '<td>' || NVL(Ln_ClientesCompensados, 0) || '</td>' ||
                            '</tr>' ||
                            '<tr>' ||
                              '<th> Total de Clientes No Compensados </th>' ||
                              '<td>' || NVL(Ln_ClientesNoCompensados, 0) || '</td>' ||
                            '</tr>' ||
                          '</table>';
      --
      --
      DB_FINANCIERO.FNKG_NOTIFICACIONES.P_NOTIFICAR_FACTURACION_MASIVA(Lv_CuerpoMensaje, 'FAC_MASIVA_MD', Pn_EmpresaCod, Lv_InfoError);
      --
      --
      IF TRIM(Lv_InfoError) IS NOT NULL THEN
        --
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                              'FNCK_FACTURACION_MENSUAL.P_FACTURACION_MENSUAL', 
                                              Lv_InfoError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                              NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                              SYSDATE, 
                                              NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
        --
      END IF;
      --
      --
    END IF;
    --
  END IF;
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('FACTURACION MASIVA', 
     'FNCK_FACTURACION_MENSUAL.P_FACTURACION_MENSUAL', 
     DBMS_UTILITY.FORMAT_ERROR_STACK||'-'||DBMS_UTILITY.format_call_stack||chr(13));      
END P_FACTURACION_MENSUAL;

PROCEDURE P_GENERAR_FECHA_EMISION_CICLOS(
    Pn_CicloFacturacion IN  NUMBER,
    Pv_FeEmision        OUT VARCHAR2,
    Pv_MesEmision       OUT VARCHAR2,
    Pn_MesEmision       OUT VARCHAR2,
    Pv_AnioEmision      OUT VARCHAR2
    )
AS
  Ld_FechaFact DATE;
BEGIN

  SELECT TO_DATE(TO_CHAR(AC.FE_INICIO,'DD'),'DD')
  INTO Ld_FechaFact
  FROM DB_FINANCIERO.ADMI_CICLO AC
  WHERE AC.ID_CICLO=Pn_CicloFacturacion
  AND AC.ESTADO IN ('Activo','Inactivo');

  Pv_FeEmision:=TO_CHAR(Ld_FechaFact,'dd/mm/yyyy');
  Pv_MesEmision:=TO_CHAR(Ld_FechaFact,'MONTH','NLS_DATE_LANGUAGE = SPANISH');
  Pn_MesEmision:=TO_CHAR(Ld_FechaFact,'mm');
  Pv_AnioEmision:=TO_CHAR(Ld_FechaFact,'yyyy');

END P_GENERAR_FECHA_EMISION_CICLOS;

PROCEDURE P_GET_CLIENT_FACT(Pn_PuntoFact     IN NUMBER,
                            Pd_FecIniRango   OUT DATE,
                            Pd_FecFinRango   OUT DATE,
                            Pb_ValidaCliente OUT BOOLEAN,
                            Pv_RangoFactura  OUT VARCHAR2)
AS
  CURSOR C_VerificFact(Pn_Punto NUMBER)
  IS
    SELECT TO_NUMBER(CAB.MES_CONSUMO) AS MES_CONSUMO,
        CAB.ANIO_CONSUMO,
        (SELECT MAX(CAR.VALOR)
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA CAR,
          DB_COMERCIAL.ADMI_CARACTERISTICA AC
        WHERE CAR.CARACTERISTICA_ID      =AC.ID_CARACTERISTICA
        AND CAR.DOCUMENTO_ID             =CAB.ID_DOCUMENTO
        AND AC.DESCRIPCION_CARACTERISTICA='CICLO_FACTURACION'
        AND AC.ESTADO                    ='Activo'
        AND CAR.ESTADO                   ='Activo'
        ) AS CICLO,
        CAB.RANGO_CONSUMO,
        (SELECT MAX(CAR.VALOR)
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA CAR,
          DB_COMERCIAL.ADMI_CARACTERISTICA AC
        WHERE CAR.CARACTERISTICA_ID      =AC.ID_CARACTERISTICA
        AND CAR.DOCUMENTO_ID             =CAB.ID_DOCUMENTO
        AND AC.DESCRIPCION_CARACTERISTICA='CICLO_FACTURADO_MES'
        AND AC.ESTADO                    ='Activo'
        AND CAR.ESTADO                   ='Activo'
        ) as CAR_MES,
        (SELECT MAX(CAR.VALOR)
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA CAR,
          DB_COMERCIAL.ADMI_CARACTERISTICA AC
        WHERE CAR.CARACTERISTICA_ID      =AC.ID_CARACTERISTICA
        AND CAR.DOCUMENTO_ID             =CAB.ID_DOCUMENTO
        AND AC.DESCRIPCION_CARACTERISTICA='CICLO_FACTURADO_ANIO'
        AND AC.ESTADO                    ='Activo'
        AND CAR.ESTADO                   ='Activo'
        ) as CAR_ANIO,
        CAB.FE_CREACION
      FROM INFO_DOCUMENTO_FINANCIERO_CAB CAB
      WHERE CAB.PUNTO_ID             =Pn_Punto
      AND CAB.ESTADO_IMPRESION_FACT IN ('Activo','Pendiente','Cerrado')
      AND CAB.TIPO_DOCUMENTO_ID IN (1) 
      AND CAB.ES_AUTOMATICA='S'
      AND NOT EXISTS (SELECT 1
                    FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDCAR,
                         DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
                    WHERE IDCAR.DOCUMENTO_ID=CAB.ID_DOCUMENTO
                    AND ACAR.ID_CARACTERISTICA=IDCAR.CARACTERISTICA_ID
                    AND ACAR.DESCRIPCION_CARACTERISTICA='FACTURA_ALCANCE')
      ORDER BY CAB.ID_DOCUMENTO DESC;

  CURSOR C_GetCicloCliente(Pn_PuntoCliente NUMBER)
  IS
    SELECT MAX(TRIM(IPERC.VALOR)) AS CICLO_CLIENTE
    FROM DB_COMERCIAL.INFO_PUNTO PUNT,
         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
         DB_COMERCIAL.ADMI_CARACTERISTICA AC
    WHERE PUNT.ID_PUNTO=Pn_PuntoCliente
    AND IPERC.PERSONA_EMPRESA_ROL_ID=PUNT.PERSONA_EMPRESA_ROL_ID
    AND IPERC.ESTADO='Activo'
    AND AC.ESTADO='Activo'
    AND IPERC.CARACTERISTICA_ID=AC.ID_CARACTERISTICA
    AND AC.DESCRIPCION_CARACTERISTICA='CICLO_FACTURACION';

  CURSOR C_Ciclo(Pn_Ciclo NUMBER)
  IS
    SELECT TO_CHAR(AC.FE_INICIO,'DD') as DIA_INICIO
    FROM ADMI_CICLO AC
    WHERE AC.ID_CICLO=Pn_Ciclo;

  Lc_VerificFact     C_VerificFact%ROWTYPE;
  Lc_GetCicloCliente C_GetCicloCliente%ROWTYPE;
  Lc_Ciclo           C_Ciclo%ROWTYPE;
  Lb_Resultado   BOOLEAN:=TRUE;
  Ln_MesActual   NUMBER;
  Ln_AnioActual  NUMBER;
  Lv_Dia         VARCHAR2(5);

  Ld_FecInicio   DATE;
  Ld_FecFin      DATE;

  Lv_FecInicioActual VARCHAR2(100);
  Lv_FecFinActual    VARCHAR2(100);

BEGIN

  OPEN C_VerificFact(Pn_PuntoFact);
  FETCH C_VerificFact INTO Lc_VerificFact;
  CLOSE C_VerificFact;
  
  IF Lc_VerificFact.MES_CONSUMO IS NOT NULL OR Lc_VerificFact.CAR_MES IS NOT NULL THEN

    IF Lc_VerificFact.CICLO IS NULL THEN
      Lv_Dia:='01';
    ELSE
      Lc_Ciclo:=NULL;
      OPEN C_Ciclo(Lc_VerificFact.CICLO);
      FETCH C_Ciclo INTO Lc_Ciclo;
      CLOSE C_Ciclo;
      Lv_Dia:=Lc_Ciclo.DIA_INICIO;
    END IF;
  
    IF Lc_VerificFact.RANGO_CONSUMO IS NULL AND Lc_VerificFact.MES_CONSUMO IS NOT NULL THEN
      Ld_FecInicio:=TO_DATE(Lv_Dia||'/'||Lc_VerificFact.MES_CONSUMO||'/'||Lc_VerificFact.ANIO_CONSUMO,'DD/MM/YYYY');
    ELSE
      Ld_FecInicio:=TO_DATE(Lv_Dia||'/'||Lc_VerificFact.CAR_MES||'/'||Lc_VerificFact.CAR_ANIO,'DD/MM/YYYY');
    END IF;
    
    IF Lc_VerificFact.FE_CREACION < Ld_FecInicio THEN
      Ld_FecFin   :=Ld_FecInicio-1;
    ELSE
      Ld_FecFin   :=ADD_MONTHS(Ld_FecInicio,1)-1;
    END IF;
  
    Pd_FecIniRango:=Ld_FecInicio;
    Pd_FecFinRango:=Ld_FecFin;
  
    IF Ld_FecInicio <= sysdate AND Ld_FecFin >= sysdate THEN
      Lb_Resultado:=FALSE;
      --Se inserta en la INFO_ERROR para llevar el control de los clientes que no se facturaron.
      DB_FINANCIERO.FNCK_COM_ELECTRONICO_TRAN.INSERT_ERROR('VALIDACION_FACTURACION_MASIVA',
                                                           'FNCK_FACTURACION_MENSUAL.P_GET_CLIENT_FACT',
                                                           'El punto ' || Pn_PuntoFact || ' no pas� la validaci�n de rangos de consumo.');
    END IF;
  
  END IF;

  Pb_ValidaCliente:=Lb_Resultado;

  IF Lb_Resultado THEN
    Ln_MesActual:=TO_CHAR(SYSDATE,'MM');
    Ln_AnioActual:=TO_CHAR(SYSDATE,'YYYY');

    OPEN C_GetCicloCliente(Pn_PuntoFact);
    FETCH C_GetCicloCliente INTO Lc_GetCicloCliente;
    CLOSE C_GetCicloCliente;

    Lc_Ciclo:=NULL;
    OPEN C_Ciclo(Lc_GetCicloCliente.CICLO_CLIENTE);
    FETCH C_Ciclo INTO Lc_Ciclo;
    CLOSE C_Ciclo;

    Lv_FecInicioActual:=Lc_Ciclo.DIA_INICIO||'/'||Ln_MesActual||'/'||Ln_AnioActual;
    Pd_FecIniRango:=TO_DATE(Lv_FecInicioActual,'DD/MM/YYYY');
    Lv_FecFinActual:=TO_CHAR(ADD_MONTHS(Pd_FecIniRango,1)-1,'DD/MM/YYYY');
    Pd_FecFinRango:=TO_DATE(Lv_FecFinActual,'DD/MM/YYYY');

    Pd_FecIniRango:=TO_DATE(Lv_FecInicioActual,'DD/MM/YYYY');
    Pd_FecFinRango:=TO_DATE(Lv_FecFinActual,'DD/MM/YYYY');

    Pv_RangoFactura:='Del '|| TO_CHAR(TO_DATE(Lv_FecInicioActual,'DD/MM/YYYY'),'DD MONTH YYYY','nls_date_language=Spanish') ||' al '|| TO_CHAR(TO_DATE(Lv_FecFinActual,'DD/MM/YYYY'),'DD MONTH YYYY','nls_date_language=Spanish');
  ELSE
    Pv_RangoFactura:='Del '|| TO_CHAR(TO_DATE(Ld_FecInicio,'DD/MM/YYYY'),'DD MONTH YYYY','nls_date_language=Spanish') ||' al '|| TO_CHAR(TO_DATE(Ld_FecFin,'DD/MM/YYYY'),'DD MONTH YYYY','nls_date_language=Spanish');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    Pb_ValidaCliente:= FALSE;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+',
                                          'FNCK_FACTURACION_MENSUAL.P_GET_CLIENT_FACT',
                                          'Error en el punto :'|| Pn_PuntoFact || ' | Error: ' || SQLCODE || ' - ERROR_STACK: '
                                                 || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                          SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
END P_GET_CLIENT_FACT;

END FNCK_FACTURACION_MENSUAL;
/
