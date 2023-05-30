CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO AS

  /**
  * Documentación para la función 'F_GET_DCTO_FACTURADO'.
  *
  * Función que permite obtener el total de descuentos facturados del punto enviado como parámetro.
  * @param  Fn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                                  Recibe el id del punto.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE                 Retorna el valor total facturado.  
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 17-12-2019
  *
  */    
  FUNCTION F_GET_DCTO_FACTURADO(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;

  /**
  * Documentación para la función 'F_GET_TIPOMEDIO'.
  *
  * Función que permite obtener el tipo medio.
  * @param  Fn_ServicioId DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE  Recibe el id del servicio.
  * @param  Fv_Estado     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE        Recibe el estado del servicio.
  * @return VARCHAR2
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 17-12-2019
  */  
  FUNCTION F_GET_TIPOMEDIO(Fn_ServicioId DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                           Fv_Estado     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                           Fn_IdPunto    DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE DEFAULT NULL)
    RETURN VARCHAR2;


/**
  * Documentación para la función 'F_GET_PERMANENCIA_VIGENTE'
  *
  * Función que permite obtener la permanencia mínima desde la fecha de activación del servicio.
  * @param  Fv_EmpresaCod   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  recibe el código de la empresa.
  * @param  Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE             recibe el id del punto.
  * @return NUMBER  
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 18-12-2019
  */    
  FUNCTION F_GET_PERMANENCIA_VIGENTE (Fv_EmpresaCod   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN NUMBER;
  

  
/**
  * Documentación para la función 'F_GET_VALOR_INST_PROMO'.
  *
  * Función que permite obtener el valor promocional por instalación del servicio enviado como parámetro.
  * @param  Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  recibe el código de la empresa.
  * @param  Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE             recibe el id del punto.
  * @param  Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE        recibe el id del servicio.
  * @param  Fn_IdContrato         IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE        recibe el id del contrato.
  * @param  Fn_FormaPagoId        IN DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE      recibe el id de la forma de pado.
  * @param  Fn_TipoCuentaId       IN DB_COMERCIAL.DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE  recibe el id del TipoCuenta.
  * @param  Fn_BancoTipoCuentaId  IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE         recibe el id del BancoTipoCuenta.
  * @return NUMBER
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 17-12-2019
  */

FUNCTION F_GET_VALOR_INST_PROMO (Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                 Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                 Fn_IdServicio         IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Fn_IdContrato         IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                 Fn_FormaPagoId        IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                 Fn_TipoCuentaId       IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                 Fn_BancoTipoCuentaId  IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE)
    RETURN NUMBER;

/**
  * Documentación para la función 'F_GET_PORCENTAJE_MAPEO_PROMO'
  *
  * Función que permite obtener el porcentaje de descuento del servicio con el tipo de promoción enviados como parámetro.
  * El tipo de promoción utilizado para instalación es 'PROM_INS'
  * @param  Fv_TipoPromocion   IN  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE    recibe el tipo de promoción.
  * @param  Fn_IdServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE                  recibe el id del servicio.
  * @return NUMBER  
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 18-12-2019
  */    
  FUNCTION F_GET_PORCENTAJE_MAPEO_PROMO (Fv_TipoPromocion   IN  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                                         Fn_IdServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN NUMBER;

/**
  * Documentación para la función 'F_GET_FE_ACT_INT'
  *
  * Función que permite obtener  la fecha de activación del servicio de internet.
  * @param  Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  recibe el id del punto.
  * @return VARCHAR2  
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 18-12-2019
  *
  * @author Emmanuel Martillo <emartillo@telconet.ec>
  * @version 1.1 18-10-2022 Se agrega FechadeOrigenNetlifecam 
  */ 
FUNCTION F_GET_FE_ACT_INT(Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2;
         
/**
  * Documentación para la función 'GET_FECHA_ACTIVACION'
  *
  * Función que permite obtener  la fecha de activación del servicio.
  * @param  Fn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE  recibe el id del servicio.
  * @return VARCHAR2  
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 18-12-2019
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.1 03-03-2021 Se agrega observación por CRS para servicios antiguos
  */ 
FUNCTION GET_FECHA_ACTIVACION(Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) RETURN  VARCHAR2;

  /*
  * Documentación para TYPE 'T_ValorTotal'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 05-02-2020
  */
  TYPE T_ValorTotal IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_ValorTotal INDEX BY PLS_INTEGER;


  /*
  * Documentación para TYPE 'T_HistFormaPago'.
  * Record para almacenar la data enviada al BULK.
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.00 15-09-2019
  */
  TYPE T_HistFormaPago IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_PtosCambioFormaPago INDEX BY PLS_INTEGER;

  /**
  * Documentación para el procedimiento P_GET_PTOS_CAMBIO_FORMA_PAGO
  *
  * Procedimiento que retorna cursor de puntos afectados.
  *
  * Costo del query 94218
  *
  * @param Pv_PrejifoEmpresa             IN DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE  Prefijo de la empresa.
  * @param Pr_ParamFechaDesde            IN IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE  Parámetro  para rango de fecha fin .
  * @param Pr_ParamFechaHasta            IN IN DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE  Parámetro  para rango de fecha de inicio .
  * @param Prf_PtosCambioFormaPago       OUT VARCHAR2  Retorna cursor de puntos afectados.
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.00 13-09-2019
  */
  PROCEDURE P_GET_PTOS_CAMBIO_FORMA_PAGO(
    Pv_PrefijoEmpresa        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pr_ParamFechaDesde       IN  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Pr_ParamFechaHasta       IN  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Prf_PtosCambioFormaPago  OUT SYS_REFCURSOR);

  /**
  * Documentación para el procedimiento P_NOTIF_CAMBIO_FORMA_PAGO
  *
  * Procedimiento que realiza envío de notificación de puntos no facturados.
  *
  * @param Pv_PrefijoEmpresa             IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE  Prefijo de la empresa.
  * @param Pv_CodigoPlantilla            IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE  Código de la plantilla .
  * @param Pv_MensajeError               OUT VARCHAR2  Retorna un mensaje de error en caso de existir.
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.00 13-08-2019
  */
  PROCEDURE P_NOTIF_CAMBIO_FORMA_PAGO(
    Pv_PrefijoEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_MensajeError              OUT VARCHAR2);

/**
  * Documentación para la función 'F_GET_MIN_FE_ACT_INT'
  *
  * Función que permite obtener  la fecha mínima de activación del servicio de internet.
  * @param  Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  recibe el id del punto.
  * @return VARCHAR2  
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 18-12-2019
  */ 
FUNCTION F_GET_MIN_FE_ACT_INT(Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2;

/**
  * Documentación para la función 'F_GET_FORMA_PAGO_ACT'
  *
  * Función que permite obtener  la forma actual del contrato enviado como parámetro.
  * @param  Fn_IdContrato   IN   DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE  recibe el id del contrato.
  * @return VARCHAR2  
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 11-02-2020
  */ 
FUNCTION F_GET_FORMA_PAGO_ACT (Fn_IdContrato   IN   DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
  RETURN VARCHAR2;

/**
  * Documentación para la función 'F_GET_HIST_TRASL_CRS'
  *
  * Función que permite obtener el id del historial por traslado o CRS con feActivación del servicio orígen del punto enviado como parámetro.
  * @param  Fn_IdPunto   IN   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  recibe el id del punto destino.
  * @return VARCHAR2   Retorna el origen (T-traslado o CRS- Cambio de razón social concatenado con el id del punto de orígen)
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 20-02-2020
  *
  * @author Emmanuel Martillo <emartillo@telconet.ec>
  * @version 1.1 18-10-2022 Se agrega FechadeOrigenNetlifecam 
  */ 
FUNCTION F_GET_ORIGEN_TRASL_CRS(Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2;

/**
  * Documentación para la función 'F_GET_PTO_ORIGEN_TRASLADO'
  *
  * Función que permite obtener el id del punto orígen proveniente de un traslado.
  * @param  Fn_IdPuntoDestino   IN   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  recibe el id del punto destino.
  * @return NUMBER   Retorna el id del punto  origen.
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 20-02-2020
  */ 
FUNCTION F_GET_PTO_ORIGEN_TRASLADO(Fn_IdPuntoDestino   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN NUMBER;

/**
  * Documentación para la función 'F_GET_PTO_ORI_CRS_LOGIN'
  *
  * Función que permite obtener el id del punto orígen proveniente de un CRS por login.
  * @param  Fn_IdPuntoDestino   IN   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  recibe el id del punto destino.
  * @return NUMBER   Retorna el id del punto  origen.
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 20-02-2020
  */ 
FUNCTION F_GET_PTO_ORI_CRS_LOGIN(Fn_IdPuntoDestino   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN NUMBER;


/**
  * Documentación para la función 'F_GET_PTO_ORI_CRS_TRAD'
  *
  * Función que permite obtener el id del punto orígen proveniente de un CRS tradicional.
  * @param  Fn_IdPuntoDestino   IN   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  recibe el id del punto destino.
  * @return NUMBER   Retorna el id del punto  origen.
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 20-02-2020
  */
FUNCTION F_GET_PTO_ORI_CRS_TRAD(Fn_IdPuntoDestino   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN NUMBER;

  /**
  * Documentación para la función 'F_GET_MESES_ACTIVO'
  *
  * Función que permite obtener el número de meses activo de un servicio (Entero menor).
  * @param  Fn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE  recibe el id del servicio.
  * @return NUMBER
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 16-09-2018
  *
  * @author Emmanuel Martillo <emartillo@telconet.ec>
  * @version 1.1 18-10-2022 Se agrega FechadeOrigenNetlifecam 
  */
  FUNCTION F_GET_MESES_ACTIVO(Fn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL)
    RETURN NUMBER;

/**
  * Documentación para la función 'F_GET_DCTO_ULT_FORMA_PAG'
  *
  * Función que permite obtener el porcentaje de descuento aplicado en el último cambio de forma de pago.
  * El tipo de promoción utilizado para instalación es 'PROM_INS'
  * @param  Fn_IdContrato   IN   DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE    recibe el id del contrato.
  * @return NUMBER  
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 27-05-2020
  */    
  FUNCTION F_GET_DCTO_ULT_FORMA_PAG (Fn_IdContrato   IN   DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
    RETURN NUMBER;
  
/**
  * Documentación para la función 'F_GET_PORCENTAJE_DCTO_INST'.
  *
  * Función que permite obtener el porcentaje de descuento de instalación a aplicar en el cambio de forma de pago.
  * @param  Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  recibe el código de la empresa.
  * @param  Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE             recibe el id del punto.
  * @param  Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE        recibe el id del servicio.
  * @param  Fn_IdContrato         IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE        recibe el id del contrato.
  * @param  Fn_FormaPagoId        IN DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE      recibe el id de la forma de pado.
  * @param  Fn_TipoCuentaId       IN DB_COMERCIAL.DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE  recibe el id del TipoCuenta.
  * @param  Fn_BancoTipoCuentaId  IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE         recibe el id del BancoTipoCuenta.
  * @return NUMBER
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 27-05-2020
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.1 25-02-2021 Se agrega búsqueda de id de servicio facturado por instalación para cálculo de porcentaje de descuento.
  */
FUNCTION F_GET_PORCENTAJE_DCTO_INST (Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Fn_IdServicio         IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Fn_IdContrato         IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                     Fn_FormaPagoId        IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                     Fn_TipoCuentaId       IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                     Fn_BancoTipoCuentaId  IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE)
RETURN NUMBER;

/**
  * Documentación para la función 'F_GET_PORCENTAJE_DCTO_DEST'.
  *
  * Función que permite obtener el porcentaje de descuento testativo para la forma de pago destino.
  * @param  Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  recibe el código de la empresa.
  * @param  Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE             recibe el id del punto.
  * @param  Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE        recibe el id del servicio.
  * @param  Fn_IdContrato         IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE        recibe el id del contrato.
  * @param  Fn_FormaPagoId        IN DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE      recibe el id de la forma de pado.
  * @param  Fn_TipoCuentaId       IN DB_COMERCIAL.DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE  recibe el id del TipoCuenta.
  * @param  Fn_BancoTipoCuentaId  IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE         recibe el id del BancoTipoCuenta.
  * @return NUMBER
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 27-05-2020
  */
FUNCTION F_GET_PORCENTAJE_DCTO_DEST (Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Fn_IdServicio         IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Fn_IdContrato         IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                     Fn_FormaPagoId        IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                     Fn_TipoCuentaId       IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                     Fn_BancoTipoCuentaId  IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE)
RETURN NUMBER;

/**
  * Documentación para la función 'P_GET_PORCENTAJE_DCTO_INST'.
  *
  * Proceso que permite obtener el porcentaje de descuento de forma de pago inicial , final y calculado.
  * @param  Fv_EmpresaCod          IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  recibe el código de la empresa.
  * @param  Fn_IdPunto             IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE             recibe el id del punto.
  * @param  Pn_IdServicio          IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE        recibe el id del servicio.
  * @param  Fn_IdContrato          IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE        recibe el id del contrato.
  * @param  Fn_FormaPagoId         IN DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE      recibe el id de la forma de pado.
  * @param  Fn_TipoCuentaId        IN DB_COMERCIAL.DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE  recibe el id del TipoCuenta.
  * @param  Fn_BancoTipoCuentaId   IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE         recibe el id del BancoTipoCuenta.
  * @param  Pn_PorcFormaPagOrigen  OUT NUMBER variable de salida. 
  * @param  Pn_PorcFormaPagDestino OUT NUMBER variable de salida.            
  * @param  Pn_PorcDescuentoInst   OUT NUMBER variable de salida.       
  *
  * @author Edgar Holguín <eholguin@telconet.ec>
  * @version 1.0 18-02-2022
  */
PROCEDURE P_GET_PORCENTAJE_DCTO_INST (Pv_EmpresaCod          IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pn_IdPunto             IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pn_IdServicio          IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pn_IdContrato          IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                      Pn_FormaPagoId         IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                      Pn_TipoCuentaId        IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                      Pn_BancoTipoCuentaId   IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE,
                                      Pn_PorcFormaPagOrigen  OUT NUMBER,
                                      Pn_PorcFormaPagDestino OUT NUMBER,
                                      Pn_PorcDescuentoInst   OUT NUMBER);
  
END FNCK_CAMBIO_FORMA_PAGO;
/


CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO AS


FUNCTION F_GET_DCTO_FACTURADO(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
IS
    -- Costo del Query: 30
    CURSOR C_GET_DCTO_FACT(Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
        SELECT  ROUND(NVL(SUM(A.SUBTOTAL_DESCUENTO),0), 2) AS VALOR
        FROM(  
              SELECT CAB.SUBTOTAL_DESCUENTO,CAB.ID_DOCUMENTO, CAB.NUMERO_FACTURA_SRI 
              FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  CAB
              JOIN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA  CAR  ON  CAR.DOCUMENTO_ID         = CAB.ID_DOCUMENTO
              JOIN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON  ATDF.ID_TIPO_DOCUMENTO    = CAB.TIPO_DOCUMENTO_ID
              JOIN  DB_COMERCIAL.INFO_PUNTO IPT                       ON  IPT.ID_PUNTO              = CAB.PUNTO_ID
              JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER        ON  IPER.ID_PERSONA_ROL       = IPT.PERSONA_EMPRESA_ROL_ID
              JOIN  DB_COMERCIAL.INFO_PERSONA IPE                     ON  IPE.ID_PERSONA            = IPER.PERSONA_ID
              WHERE IPE.NUMERO_CONADIS IS NULL
              AND   ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
              AND   CAB.ES_AUTOMATICA          = 'S'
              AND   CAB.PUNTO_ID               = Cn_PuntoId
              AND   CAB.SUBTOTAL_DESCUENTO    <> 0             
              AND   CAB.ESTADO_IMPRESION_FACT IN (
                                                    SELECT APD.DESCRIPCION
                                                    FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                    JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                                    ON     APD.PARAMETRO_ID       = APC.ID_PARAMETRO
                                                    WHERE  APC.NOMBRE_PARAMETRO   = 'ESTADOS_FACTURAS_VALIDAS'
                                                    AND    APC.ESTADO             = 'Activo'
                                                    AND    APD.ESTADO             = 'Activo'
                                                 )
             AND NOT EXISTS ( SELECT IDC.* 
                              FROM   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                              JOIN   DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = IDC.CARACTERISTICA_ID
                              WHERE  IDC.DOCUMENTO_ID  = CAB.ID_DOCUMENTO
                              AND    AC.DESCRIPCION_CARACTERISTICA IN (SELECT APD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ON APC.ID_PARAMETRO = APD.PARAMETRO_ID
                                                      AND APC.NOMBRE_PARAMETRO = 'SOLICITUDES_DE_CONTRATO' AND APC.ESTADO = 'Activo') 
                              AND    AC.ESTADO        = 'Activo')
             AND NOT EXISTS (SELECT IDC.* 
                             FROM   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                             JOIN   DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = IDC.CARACTERISTICA_ID
                             WHERE  IDC.DOCUMENTO_ID              = CAB.ID_DOCUMENTO
                             AND    AC.DESCRIPCION_CARACTERISTICA = 'CAMBIO_FORMA_PAGO' 
                             AND    AC.ESTADO                     = 'Activo')  
            GROUP BY  CAB.ID_DOCUMENTO, CAB.NUMERO_FACTURA_SRI, CAB.SUBTOTAL_DESCUENTO) A;          
  --
  Lf_TotalFacturado DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;
  Lc_TotalFacturado C_GET_DCTO_FACT%ROWTYPE;
  --
BEGIN
  --
  --
  IF C_GET_DCTO_FACT%ISOPEN THEN
    CLOSE C_GET_DCTO_FACT;
  END IF;


  OPEN C_GET_DCTO_FACT(Fn_IdPunto);
   FETCH C_GET_DCTO_FACT
     INTO Lc_TotalFacturado;
   CLOSE C_GET_DCTO_FACT;
   Lf_TotalFacturado :=  NVL(Lc_TotalFacturado.VALOR,0);
  --
  RETURN Lf_TotalFacturado;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO','FNCK_CAMBIO_FORMA_PAGO.F_GET_DCTO_FACTURADO', SQLERRM);
  --
END F_GET_DCTO_FACTURADO;

FUNCTION F_GET_TIPOMEDIO(Fn_ServicioId DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                         Fv_Estado     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                         Fn_IdPunto    DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE DEFAULT NULL)
  RETURN VARCHAR2
IS
  -- Costo Query: 5
  CURSOR C_GET_TIPOMEDIO(Cn_ServicioId DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                         Cv_Estado     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE) IS
    SELECT ATM.CODIGO_TIPO_MEDIO,
           ATM.NOMBRE_TIPO_MEDIO
    FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
    JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO ATM ON ATM.ID_TIPO_MEDIO = IST.ULTIMA_MILLA_ID
    WHERE IST.SERVICIO_ID    =  Cn_ServicioId
    AND ATM.ESTADO           =  Cv_Estado;
  -- -- Costo Query: 9
    CURSOR C_GET_TIPOMEDIO_PUNTO(Cn_PuntoId    DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                 Cv_Estado     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    IS
      SELECT ATM.CODIGO_TIPO_MEDIO                
      FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO IST
      JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_MEDIO ATM ON ATM.ID_TIPO_MEDIO = IST.ULTIMA_MILLA_ID
      WHERE IST.SERVICIO_ID    IN  (SELECT ISF.ID_SERVICIO FROM DB_COMERCIAL.INFO_SERVICIO ISF
                                     WHERE ISF.PUNTO_ID  = Cn_PuntoId
                                    AND ISF.ESTADO      = Cv_Estado)
      AND ATM.ESTADO           =  Fv_Estado
      GROUP BY ATM.CODIGO_TIPO_MEDIO;
  --
  Lv_TipoMedio       VARCHAR2(5);
  Lc_TipoMedio       C_GET_TIPOMEDIO%ROWTYPE;

BEGIN
  --
    IF Fn_ServicioId IS NOT NULL THEN
        IF C_GET_TIPOMEDIO%ISOPEN THEN
        CLOSE C_GET_TIPOMEDIO;
        END IF;

        OPEN C_GET_TIPOMEDIO(Fn_ServicioId,Fv_Estado);
        FETCH C_GET_TIPOMEDIO
        INTO Lc_TipoMedio;
        CLOSE C_GET_TIPOMEDIO;
        
        Lv_TipoMedio := NVL(Lc_TipoMedio.CODIGO_TIPO_MEDIO,'');
    END IF;
  --
  IF Fn_IdPunto IS NOT NULL THEN
        IF C_GET_TIPOMEDIO_PUNTO%ISOPEN THEN
        CLOSE C_GET_TIPOMEDIO_PUNTO;
        END IF;

        OPEN C_GET_TIPOMEDIO_PUNTO(Fn_IdPunto,Fv_Estado);
            FETCH C_GET_TIPOMEDIO_PUNTO INTO Lc_TipoMedio.CODIGO_TIPO_MEDIO;
        CLOSE C_GET_TIPOMEDIO_PUNTO;
        
        Lv_TipoMedio := NVL(Lc_TipoMedio.CODIGO_TIPO_MEDIO,'');
    END IF;
  --
  RETURN Lv_TipoMedio;
  --
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO','FNCK_CAMBIO_FORMA_PAGO.F_GET_TIPOMEDIO', SQLERRM);
  --
  END F_GET_TIPOMEDIO;

FUNCTION F_GET_PERMANENCIA_VIGENTE (Fv_EmpresaCod   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
RETURN NUMBER

IS
--  Costo del query 3
    CURSOR C_GET_PARAMETROS_PERMANENCIA(Cv_EmpresaCod VARCHAR2, Cv_NombreParametro VARCHAR2, Cv_Modulo VARCHAR2, Cv_Estado VARCHAR2, Cv_Valor VARCHAR2) IS
      SELECT DET.VALOR2,
             DET.VALOR3
      FROM   DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE  CAB.ID_PARAMETRO     =  DET.PARAMETRO_ID
      AND    CAB.ESTADO           =  Cv_Estado
      AND    DET.ESTADO           =  Cv_Estado
      AND    CAB.MODULO           =  Cv_Modulo
      AND    DET.VALOR1           =  Cv_Valor
      AND    DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND    CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;
--
Lv_FeActivacion               VARCHAR2(12);
Ln_ParamPermanencia           NUMBER;
Ld_ValorParamPermanencia24    DATE;
Ld_ValorParamPermanencia36    DATE;
Ld_FeActivacion               DATE; 

Lv_ParamCancelVoluntaria      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE   := 'CAMBIO FORMA PAGO'; 
Lv_ModuloFinanciero           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE             := 'FINANCIERO';
Lv_EstadoActivo               DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';
Lv_fec_PermanenciaMinima24    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE             := 'PERMANENCIA MINIMA 24 MESES';
Lv_fec_PermanenciaMinima36    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE             := 'PERMANENCIA MINIMA 36 MESES';

Lc_ParamPermanencia24         C_GET_PARAMETROS_PERMANENCIA%ROWTYPE;
Lc_ParamPermanencia36         C_GET_PARAMETROS_PERMANENCIA%ROWTYPE;

--
BEGIN
  
  Lv_FeActivacion := NVL(DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_FE_ACT_INT(Fn_IdPunto),'');

  IF Lv_FeActivacion IS NULL THEN
    Lv_FeActivacion := NVL(DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_MIN_FE_ACT_INT(Fn_IdPunto),'');
  END IF;
  
  Ld_FeActivacion := TO_DATE(NVL(Lv_FeActivacion,''),'dd/mm/yyyy');
  
  IF C_GET_PARAMETROS_PERMANENCIA%ISOPEN THEN
    CLOSE C_GET_PARAMETROS_PERMANENCIA;
  END IF;

  OPEN C_GET_PARAMETROS_PERMANENCIA (Fv_EmpresaCod,Lv_ParamCancelVoluntaria,Lv_ModuloFinanciero,Lv_EstadoActivo,Lv_fec_PermanenciaMinima24);
    FETCH C_GET_PARAMETROS_PERMANENCIA INTO Lc_ParamPermanencia24;
  CLOSE C_GET_PARAMETROS_PERMANENCIA;

  Ld_ValorParamPermanencia24 := TO_DATE(NVL(Lc_ParamPermanencia24.VALOR3,0),'dd/mm/yyyy');
  
  IF Ld_FeActivacion <=  Ld_ValorParamPermanencia24 THEN 
     Ln_ParamPermanencia := TO_NUMBER(NVL(Lc_ParamPermanencia24.VALOR2,0));     
  END IF;
  
  IF C_GET_PARAMETROS_PERMANENCIA%ISOPEN THEN
    CLOSE C_GET_PARAMETROS_PERMANENCIA;
  END IF;

  OPEN C_GET_PARAMETROS_PERMANENCIA (Fv_EmpresaCod,Lv_ParamCancelVoluntaria,Lv_ModuloFinanciero,Lv_EstadoActivo,Lv_fec_PermanenciaMinima36);
    FETCH C_GET_PARAMETROS_PERMANENCIA INTO Lc_ParamPermanencia36;
  CLOSE C_GET_PARAMETROS_PERMANENCIA;

  Ld_ValorParamPermanencia36 := TO_DATE(NVL(Lc_ParamPermanencia36.VALOR3,0),'dd/mm/yyyy');   
  
  IF Ld_FeActivacion >= Ld_ValorParamPermanencia36 THEN 
     Ln_ParamPermanencia := TO_NUMBER(NVL(Lc_ParamPermanencia36.VALOR2,0));
     
  END IF;
  
 RETURN Ln_ParamPermanencia;
--
EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO','FNCK_CAMBIO_FORMA_PAGO.F_GET_PERMANENCIA_VIGENTE', SQLERRM);
  --
END F_GET_PERMANENCIA_VIGENTE;

FUNCTION F_GET_VALOR_INST_PROMO (Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                 Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                 Fn_IdServicio         IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Fn_IdContrato         IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                 Fn_FormaPagoId        IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                 Fn_TipoCuentaId       IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                 Fn_BancoTipoCuentaId  IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE)
RETURN NUMBER
IS
  --Costo: 2
  CURSOR C_GET_MES_ACTUAL  IS
    SELECT TO_CHAR(SYSDATE,'MM') FROM DUAL;


  Ln_PermanenciaMinima              NUMBER := 0;
  Ln_ValorBaseInstalacion           NUMBER := 0;
  Ln_TotalFactInstalacion           NUMBER := 0;
  Ln_PorcentajeDescuentoInstalac    NUMBER := 0;
  Lv_TipoMedio                      VARCHAR2 (2) ; 
  Lv_Formula                        VARCHAR2 (4000) ;
  Lv_SqlFormula                     VARCHAR2 (4000) ;
  Lrf_GetAdmiParamtrosDet           SYS_REFCURSOR ;
  Lrf_GetAdmiParamDetCfp            SYS_REFCURSOR ;
  Lrf_Formula                       SYS_REFCURSOR ;                               
  Lr_GetAdmiParamtrosDet            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE ;
  Lr_GetAdmiParamDetFormula         DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE ;
  Lv_ParamPorcDescInsta             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'PORCENTAJE_DESCUENTO_INSTALACION'; 
  Lv_EstadoActivo                   DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
  Lv_ParamCambioFormaPago           DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'CAMBIO FORMA PAGO';
  Lv_ParamDetFormula                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                 := 'FORMULA PROMOCIONAL INSTALACION';
  Lv_TipoPromocion                  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE := 'PROM_INS';
  Lv_FormaPagoBaseMap               VARCHAR2(8)                                               := 'EFECTIVO';
  Lv_MesCambioFormaPago             VARCHAR2(2);
  Ln_Indsx                          NUMBER;
  Lrt_ArrayValorTotal               T_ValorTotal;
  Lr_ValorTotal                     DB_FINANCIERO.FNKG_TYPES.Lr_ValorTotal;
  Ln_CantPeriodo                    NUMBER;
  Lv_ObdDctoVigente                 VARCHAR2(4000);

BEGIN

  Ln_PermanenciaMinima    :=  NVL(FNCK_CAMBIO_FORMA_PAGO.F_GET_PERMANENCIA_VIGENTE(Fv_EmpresaCod,Fn_IdPunto),0);
  Lv_TipoMedio            :=  NVL(FNCK_CAMBIO_FORMA_PAGO.F_GET_TIPOMEDIO(Fn_IdServicio,Lv_EstadoActivo,NULL),'');

  Lv_MesCambioFormaPago   :=  DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_MESES_ACTIVO(Fn_IdServicio);
  
  Lrf_GetAdmiParamtrosDet :=  FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamPorcDescInsta, Lv_EstadoActivo, Lv_EstadoActivo, Lv_TipoMedio, Lv_FormaPagoBaseMap, NULL, NULL);
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  CLOSE Lrf_GetAdmiParamtrosDet;  

  Ln_ValorBaseInstalacion        := TO_NUMBER(NVL(Lr_GetAdmiParamtrosDet.VALOR5,0));

  Ln_PorcentajeDescuentoInstalac := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_DCTO_INST(Fv_EmpresaCod,
                                                                                                    Fn_IdPunto,
                                                                                                    Fn_IdServicio,
                                                                                                    Fn_IdContrato,
                                                                                                    Fn_FormaPagoId,
                                                                                                    Fn_TipoCuentaId,
                                                                                                    Fn_BancoTipoCuentaId);

  IF Ln_PorcentajeDescuentoInstalac <= 0  THEN
    RETURN 0;
  ELSE
    Lrf_GetAdmiParamDetCfp :=  FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamCambioFormaPago, Lv_EstadoActivo, Lv_EstadoActivo, Lv_ParamDetFormula, NULL, 'NULL', 'NULL');
    FETCH Lrf_GetAdmiParamDetCfp INTO Lr_GetAdmiParamDetFormula;
    CLOSE Lrf_GetAdmiParamDetCfp;

    DBMS_OUTPUT.PUT_LINE('Lv_Formula = ' || Lr_GetAdmiParamDetFormula.VALOR2);
    
    Lv_Formula := REPLACE(Lr_GetAdmiParamDetFormula.VALOR2, 'Ln_ValorInstalacion', Ln_ValorBaseInstalacion);
    Lv_Formula := REPLACE(Lv_Formula, 'Ln_DctoInstalacion', Ln_PorcentajeDescuentoInstalac);
    Lv_Formula := REPLACE(Lv_Formula, 'Ln_MesCambioFormaPago', TO_NUMBER(Lv_MesCambioFormaPago));
    Lv_Formula := REPLACE(Lv_Formula, 'Ln_TiempoPermanencia', Ln_PermanenciaMinima);

  END IF;




  Lv_SqlFormula := 'SELECT '||Lv_Formula||' FROM DUAL ';
  OPEN Lrf_Formula FOR Lv_SqlFormula;
  LOOP
    FETCH Lrf_Formula BULK COLLECT INTO Lrt_ArrayValorTotal  LIMIT 100; 
    Ln_Indsx := Lrt_ArrayValorTotal.FIRST;
    WHILE (Ln_Indsx IS NOT NULL)
      LOOP
        Lr_ValorTotal           := Lrt_ArrayValorTotal(Ln_Indsx);
        Ln_TotalFactInstalacion := Lr_ValorTotal.VALOR_TOTAL;
        Ln_Indsx                := Lrt_ArrayValorTotal.NEXT(Ln_Indsx);
      END LOOP;   
      EXIT
      WHEN Lrf_Formula%NOTFOUND;
  END LOOP;

  IF Ln_TotalFactInstalacion < 0 THEN 
    Ln_TotalFactInstalacion := 0;       
  END IF;

RETURN Ln_TotalFactInstalacion;

EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO','FNCK_CAMBIO_FORMA_PAGO.F_GET_VALOR_INST_PROMO', SQLERRM);
  --
END F_GET_VALOR_INST_PROMO;


FUNCTION F_GET_PORCENTAJE_MAPEO_PROMO (Fv_TipoPromocion   IN  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                                       Fn_IdServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN NUMBER
IS
  -- Costo del query: 2
  CURSOR GetPorcentajeMapeoPromo(Cv_TipoPromocion   IN  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE,
                                 Cn_IdServicio      IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT NVL(IDMP.PORCENTAJE,0)
    FROM   DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP 
    WHERE  IDMP.ID_DETALLE_MAPEO  = (SELECT MIN(IDMPR.ID_DETALLE_MAPEO)
                                     FROM   DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMPR
                                     JOIN   DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS ON IDMS.DETALLE_MAPEO_ID = IDMPR.ID_DETALLE_MAPEO
                                     WHERE  IDMPR.TIPO_PROMOCION = Cv_TipoPromocion AND IDMS.SERVICIO_ID = Cn_IdServicio)
    AND    IDMP.ESTADO = 'Finalizado';

  --
  Ln_PorcentajePromo NUMBER;
  --
BEGIN
  --
  IF Fn_IdServicio IS NOT NULL THEN
  --
    IF GetPorcentajeMapeoPromo%ISOPEN THEN
        CLOSE GetPorcentajeMapeoPromo;
    END IF;
    --
    OPEN GetPorcentajeMapeoPromo(Fv_TipoPromocion, Fn_IdServicio);
    --
    FETCH GetPorcentajeMapeoPromo INTO Ln_PorcentajePromo;

    IF GetPorcentajeMapeoPromo%notfound THEN
      RETURN 0;
    END IF;
    --
    CLOSE GetPorcentajeMapeoPromo;
  --
  END IF;
  --
  RETURN Ln_PorcentajePromo;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_MAPEO_PROMO', SQLERRM);
  RETURN NULL;
  --
END F_GET_PORCENTAJE_MAPEO_PROMO;


FUNCTION F_GET_FE_ACT_INT(Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GET_FE_ACTIVACION_INT(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MIN(ISH.FE_CREACION),'DD-MM-YYYY')
    FROM DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH    ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID   = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD              ON IPD.PLAN_ID     = ISER.PLAN_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP               ON AP.ID_PRODUCTO  = IPD.PRODUCTO_ID
    WHERE (UPPER (ISH.ACCION)      = 'FEORIGSERVICIOTRASLADADO'
           OR  UPPER (ISH.ACCION)  = 'FEORIGENCAMBIORAZONSOCIAL'
           OR  UPPER (ISH.ACCION)  = 'FEORIGSERVICIONETLIFECAM'
           OR  UPPER (ISH.ACCION)  = 'CONFIRMARSERVICIO'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CONFIRMO EL SERVICIO'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CREO EL SERVICIO'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'FECHA INICIAL DE SERVICIO NETLIFECAM.'
           )
    AND ISER.PUNTO_ID      = Cn_IdPunto
    AND AP.CODIGO_PRODUCTO = 'INTD'
    AND ISER.ESTADO       NOT IN ('Eliminado','Anulado','Rechazada')
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;
  --
  Lv_FeActivacionInternet VARCHAR2(10);
  --
BEGIN
  --
  --
  IF C_GET_FE_ACTIVACION_INT%ISOPEN THEN
    CLOSE C_GET_FE_ACTIVACION_INT;
  END IF;
  --
  OPEN C_GET_FE_ACTIVACION_INT(Fn_IdPunto);
  --
  FETCH C_GET_FE_ACTIVACION_INT INTO Lv_FeActivacionInternet;
  --
  CLOSE C_GET_FE_ACTIVACION_INT;
  --
  RETURN NVL(Lv_FeActivacionInternet,'');
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_FE_ACT_INT', SQLERRM);
  --
END F_GET_FE_ACT_INT;

FUNCTION GET_FECHA_ACTIVACION(
    Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN VARCHAR2
IS
  CURSOR C_FechaActivacion(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) IS
    SELECT MIN (FE_CREACION)
    FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
    WHERE ISH.SERVICIO_ID = Cn_IdServicio
    AND   (UPPER (ISH.ACCION)      = 'FEORIGSERVICIOTRASLADADO'
           OR  UPPER (ISH.ACCION)  = 'FEORIGENCAMBIORAZONSOCIAL'
           OR  UPPER (ISH.ACCION)  = 'FEORIGSERVICIONETLIFECAM'
           OR  UPPER (ISH.ACCION)  = 'CONFIRMARSERVICIO'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'FECHA INICIAL DE SERVICIO NETLIFECAM.'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CONFIRMO EL SERVICIO'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CREO EL SERVICIO'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'CAMBIO DE RAZON SOCIAL'
           )
    AND ISH.ESTADO = 'Activo';
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
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.GET_FECHA_ACTIVACION', SQLERRM);    
END GET_FECHA_ACTIVACION;

  PROCEDURE P_GET_PTOS_CAMBIO_FORMA_PAGO(
    Pv_PrefijoEmpresa        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pr_ParamFechaDesde       IN  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Pr_ParamFechaHasta       IN  DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE,
    Prf_PtosCambioFormaPago  OUT SYS_REFCURSOR)
  IS
    Lcl_Query                 CLOB ;
    Lv_InfoError              VARCHAR2(3000);
  BEGIN

      Lcl_Query :='SELECT DISTINCT(IPT.LOGIN)            AS LOGIN,
                          CASE
                            WHEN AFPANT.DESCRIPCION_FORMA_PAGO = ''DEBITO BANCARIO''
                            THEN AFPANT.DESCRIPCION_FORMA_PAGO||''-''||NVL(TCTA2.DESCRIPCION_CUENTA,'' '')||''-''||NVL(BCO2.DESCRIPCION_BANCO,'' '')
                            ELSE AFPANT.DESCRIPCION_FORMA_PAGO
                          END FP_ANTERIOR,
                          CASE
                            WHEN AFPACT.DESCRIPCION_FORMA_PAGO = ''DEBITO BANCARIO''
                            THEN AFPACT.DESCRIPCION_FORMA_PAGO||''-''||NVL(TCTA.DESCRIPCION_CUENTA,'' '')||''-''||NVL(BCO.DESCRIPCION_BANCO,'' '')
                            ELSE AFPACT.DESCRIPCION_FORMA_PAGO
                          END FP_ACTUAL,
                          NVL(ICFPH.NUMERO_ACTA,0)                                      AS NUMERO_ACTA,
                          NVL(DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_FE_ACT_INT(IPT.ID_PUNTO),'' '') AS FE_ACTIVACION,
                          NVL(ICFPH.USR_CREACION,'' '')                                     AS USUARIO,
                          NVL(AM.NOMBRE_MOTIVO, '' '')                                      AS MOTIVO,
                          ''SI''                                                            AS  ES_FACTURABLE ,
                          NVL(IDFC.NUMERO_FACTURA_SRI,'' '')                                AS NUM_FACTURA,
                          NVL(TO_CHAR(IDFC.FE_EMISION, ''DD-MM-YYYY HH24:MI:SS''),'' '')    AS FECHA , 
                          NVL(IDFC.VALOR_TOTAL,0)   AS VALOR
                   FROM  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST        ICFPH
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_BANCO_TIPO_CUENTA     BTC2  ON ICFPH.BANCO_TIPO_CUENTA_ID  = BTC2.ID_BANCO_TIPO_CUENTA
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_BANCO                 BCO2  ON BTC2.BANCO_ID               = BCO2.ID_BANCO
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_TIPO_CUENTA           TCTA2 ON BTC2.TIPO_CUENTA_ID         = TCTA2.ID_TIPO_CUENTA 
                   LEFT  JOIN DB_COMERCIAL.INFO_CONTRATO                   IC   ON IC.ID_CONTRATO               = ICFPH.CONTRATO_ID
                   LEFT  JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO        ICFP ON ICFP.CONTRATO_ID             = IC.ID_CONTRATO 
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_BANCO_TIPO_CUENTA     BTC  ON ICFP.BANCO_TIPO_CUENTA_ID    = BTC.ID_BANCO_TIPO_CUENTA
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_BANCO                 BCO  ON BTC.BANCO_ID                 = BCO.ID_BANCO
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_TIPO_CUENTA           TCTA ON BTC.TIPO_CUENTA_ID           = TCTA.ID_TIPO_CUENTA
                   LEFT  JOIN DB_COMERCIAL.INFO_PUNTO                      IPT  ON IPT.PERSONA_EMPRESA_ROL_ID   = IC.PERSONA_EMPRESA_ROL_ID
                   LEFT  JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC ON IPT.ID_PUNTO                 = IDFC.PUNTO_ID
                   LEFT  JOIN DB_GENERAL.ADMI_FORMA_PAGO                   AFPANT  ON AFPANT.ID_FORMA_PAGO      = ICFPH.FORMA_PAGO
                   LEFT  JOIN DB_GENERAL.ADMI_FORMA_PAGO                   AFPACT  ON AFPACT.ID_FORMA_PAGO      = ICFPH.FORMA_PAGO_ACTUAL_ID
                   LEFT  JOIN DB_GENERAL.ADMI_MOTIVO                       AM      ON AM.ID_MOTIVO              = ICFPH.MOTIVO_ID
                   WHERE ICFPH.FACTURA     = ''S''
                   AND   ICFPH.FE_CREACION >= TRUNC(SYSDATE) 
                   AND   IDFC.FE_CREACION  >= TRUNC(SYSDATE) 
                   AND   IDFC.USR_CREACION = ''telcosCambioFormaPag''
                   UNION
                   SELECT DISTINCT(IPT.LOGIN)            AS LOGIN,
                          CASE
                            WHEN AFPANT.DESCRIPCION_FORMA_PAGO = ''DEBITO BANCARIO''
                            THEN AFPANT.DESCRIPCION_FORMA_PAGO||''-''||NVL(TCTA2.DESCRIPCION_CUENTA,'' '')||''-''||NVL(BCO2.DESCRIPCION_BANCO,'' '')
                            ELSE AFPANT.DESCRIPCION_FORMA_PAGO
                          END FP_ANTERIOR,
                          CASE
                            WHEN AFPACT.DESCRIPCION_FORMA_PAGO = ''DEBITO BANCARIO''
                            THEN AFPACT.DESCRIPCION_FORMA_PAGO||''-''||NVL(TCTA.DESCRIPCION_CUENTA,'' '')||''-''||NVL(BCO.DESCRIPCION_BANCO,'' '')
                            ELSE AFPACT.DESCRIPCION_FORMA_PAGO
                          END FP_ACTUAL,
                          NVL(ICFPH.NUMERO_ACTA,0)                                      AS NUMERO_ACTA,
                          NVL(DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_FE_ACT_INT(IPT.ID_PUNTO),'' '') AS FE_ACTIVACION,
                          NVL(ICFPH.USR_CREACION,'' '')  AS USUARIO,
                          NVL(AM.NOMBRE_MOTIVO, '' '')   AS MOTIVO,
                          ''NO''                         AS  ES_FACTURABLE ,
                          '' ''  AS NUM_FACTURA,
                          '' ''  AS FECHA, 
                          0      AS VALOR
                   FROM  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST        ICFPH
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_BANCO_TIPO_CUENTA     BTC2  ON ICFPH.BANCO_TIPO_CUENTA_ID  = BTC2.ID_BANCO_TIPO_CUENTA
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_BANCO                 BCO2  ON BTC2.BANCO_ID               = BCO2.ID_BANCO
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_TIPO_CUENTA           TCTA2 ON BTC2.TIPO_CUENTA_ID         = TCTA2.ID_TIPO_CUENTA 
                   LEFT  JOIN DB_COMERCIAL.INFO_CONTRATO                   IC   ON IC.ID_CONTRATO               = ICFPH.CONTRATO_ID
                   LEFT  JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO        ICFP ON ICFP.CONTRATO_ID             = IC.ID_CONTRATO 
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_BANCO_TIPO_CUENTA     BTC  ON ICFP.BANCO_TIPO_CUENTA_ID    = BTC.ID_BANCO_TIPO_CUENTA
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_BANCO                 BCO  ON BTC.BANCO_ID                 = BCO.ID_BANCO
                   LEFT  OUTER JOIN  DB_GENERAL.ADMI_TIPO_CUENTA           TCTA ON BTC.TIPO_CUENTA_ID           = TCTA.ID_TIPO_CUENTA
                   LEFT  JOIN DB_COMERCIAL.INFO_PUNTO                      IPT  ON IPT.PERSONA_EMPRESA_ROL_ID   = IC.PERSONA_EMPRESA_ROL_ID
                   LEFT  JOIN DB_GENERAL.ADMI_FORMA_PAGO                   AFPANT  ON AFPANT.ID_FORMA_PAGO      = ICFPH.FORMA_PAGO
                   LEFT  JOIN DB_GENERAL.ADMI_FORMA_PAGO                   AFPACT  ON AFPACT.ID_FORMA_PAGO      = ICFPH.FORMA_PAGO_ACTUAL_ID
                   LEFT  JOIN DB_GENERAL.ADMI_MOTIVO                       AM      ON AM.ID_MOTIVO              = ICFPH.MOTIVO_ID
                   WHERE ICFPH.FACTURA     = ''N'' 
                   AND   ICFPH.FE_CREACION >= TRUNC(SYSDATE) ';

      
    OPEN Prf_PtosCambioFormaPago FOR Lcl_Query;

    EXCEPTION
    WHEN OTHERS THEN
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.P_GET_PTOS_CAMBIO_FORMA_PAGO', SQLERRM);
  END P_GET_PTOS_CAMBIO_FORMA_PAGO;



  PROCEDURE P_NOTIF_CAMBIO_FORMA_PAGO(
    Pv_PrefijoEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
    Pv_CodigoPlantilla           IN DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE,
    Pv_MensajeError              OUT VARCHAR2) IS

  -- Costo del query: 4
  CURSOR C_GetParametro(Cv_NombreParamCab VARCHAR2, Cv_EstadoParametroCab VARCHAR2, Cv_EstadoParametroDet VARCHAR2, Cv_Valor1 VARCHAR2, 
                        Cv_Valor2 VARCHAR2, Cv_Valor3 VARCHAR2, Cv_Valor4 VARCHAR2, Cv_Valor5 VARCHAR2, Cv_EmpresaCod VARCHAR2)
  IS
    SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
      DB_GENERAL.ADMI_PARAMETRO_DET APD
    WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
    AND APC.ESTADO           = NVL(Cv_EstadoParametroCab, APC.ESTADO)
    AND APD.ESTADO           = NVL(Cv_EstadoParametroDet, APD.ESTADO)
    AND APC.NOMBRE_PARAMETRO = NVL(Cv_NombreParamCab, APC.NOMBRE_PARAMETRO)
    AND APD.VALOR1           = NVL(Cv_Valor1, APD.VALOR1)
    AND APD.VALOR2           = NVL(Cv_Valor2, APD.VALOR2)
    AND APD.VALOR3           = NVL(Cv_Valor3, APD.VALOR3)
    AND APD.VALOR4           = NVL(Cv_Valor4, APD.VALOR4)
    AND APD.VALOR5           = NVL(Cv_Valor5, APD.VALOR5)
    AND APD.EMPRESA_COD      = NVL(Cv_EmpresaCod, APD.EMPRESA_COD);
    


  Lr_GetAdmiParametrosDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lrf_GetAdmiParametrosDet       SYS_REFCURSOR;
  Lrf_GetHistFormasPago          SYS_REFCURSOR; 
  Lv_NombreParametroCab          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'NOTIFICACION_CAMBIO_FORMA_PAGO';
  Lv_PrefijoEmpresa              DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE                        := Pv_PrefijoEmpresa;
  Lr_Parametro                   C_GetParametro%ROWTYPE;
  Lr_ParamFechaDesde             C_GetParametro%ROWTYPE;
  Lr_ParamFechaHasta             C_GetParametro%ROWTYPE;
  Lr_ParametroFeDesde            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lr_ParametroFeHasta            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_ValidacionFechas            DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := 'FECHAS_NOTIFICACION_CAMBIOFORMAPAGO';
  Lv_FechaDesde                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := 'VALIDACION_FECHA_DESDE';
  Lv_FechaHasta                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := 'VALIDACION_FECHA_HASTA';
  Lv_ValorActivo                 DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                        := 'S';
  Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE                        := 'Activo';
  Lr_HistFormasPago              T_HistFormaPago;
  Lr_GetAliasPlantilla           DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
  Lr_HistFormaPago               DB_FINANCIERO.FNKG_TYPES.Lr_PtosCambioFormaPago;
  Lcl_TableDocumento             CLOB;
  Lv_CodigoPlantilla             DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE                       := Pv_CodigoPlantilla;
  Lv_Datosmail                   DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                        := Lv_CodigoPlantilla || '_HEADERS';
  Lv_NombreCabeceraEnviocorreo   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE              := Lv_CodigoPlantilla || '_HEADERS';
  Le_Exception                   EXCEPTION;
  Ln_Indsx                       NUMBER;
  Ln_CounterCommit               NUMBER                                                           := 0;
  Lcl_MessageMail                CLOB;
  Lv_MimeType                    VARCHAR2(50)                                                     := 'text/html; charset=UTF-8';


  Lfile_Archivo                  utl_file.file_type;
  Lv_Delimitador                 VARCHAR2(1)    := '|';
  Lv_NombreArchivo               VARCHAR2(100)  := 'ReporteCambiosFormaPago_'||Pv_PrefijoEmpresa||'.csv';
  Lv_NombreArchivoCsv            VARCHAR2(200)  := Lv_NombreArchivo||'.csv';
  Lv_NombreArchivoGz             VARCHAR2(200)  := Lv_NombreArchivoCsv||'.gz';
  Lv_NombreArchivoZip            VARCHAR2(200)  := Lv_NombreArchivo||'.zip';
  Lv_Gzip                        VARCHAR2(100)  := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
  Lv_Directorio                  VARCHAR2(50)   := 'DIR_REPGERENCIA';
 
  CURSOR C_Directory(Cv_Directorio VARCHAR2) IS
    SELECT DIRECTORY_PATH
    FROM ALL_DIRECTORIES
    WHERE UPPER(DIRECTORY_NAME) = Cv_Directorio;

  Lc_Directory                   C_Directory%ROWTYPE;

  BEGIN

    OPEN C_Directory(Lv_Directorio);
    FETCH C_Directory INTO Lc_Directory;
    CLOSE C_Directory;

    Lv_Gzip              :='gzip '||Lc_Directory.DIRECTORY_PATH||Lv_NombreArchivoCsv; 
    Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,Lv_NombreArchivoCsv,'w',3000);

     --Verifica que pueda enviar correo para los puntos no facturados
    Lrf_GetAdmiParametrosDet := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET( Lv_NombreParametroCab, 
                                                                                       Lv_EstadoActivo, 
                                                                                       Lv_EstadoActivo, 
                                                                                       Lv_NombreParametroCab, 
                                                                                       Lv_PrefijoEmpresa, 
                                                                                       Lv_ValorActivo, 
                                                                                       NULL);

    FETCH
      Lrf_GetAdmiParametrosDet
    INTO
      Lr_GetAdmiParametrosDet;
    CLOSE Lrf_GetAdmiParametrosDet;
    
    IF Lr_GetAdmiParametrosDet.parametro_id IS NOT NULL THEN

      --Se valida si esta activo el filtro por fecha desde
      Lr_ParamFechaDesde :=NULL;
      OPEN C_GetParametro(Lv_ValidacionFechas, Lv_EstadoActivo, Lv_EstadoActivo, Lv_FechaDesde, Lv_ValorActivo, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);
      
      FETCH C_GetParametro INTO Lr_ParamFechaDesde;
      CLOSE C_GetParametro;

      --Se valida si esta activo el filtro por fecha hasta
      Lr_ParamFechaHasta :=NULL;
      OPEN C_GetParametro(Lv_ValidacionFechas, Lv_EstadoActivo, Lv_EstadoActivo, Lv_FechaHasta, Lv_ValorActivo, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);

      FETCH C_GetParametro INTO Lr_ParamFechaHasta;
      CLOSE C_GetParametro;
      
      Lr_ParametroFeDesde.VALOR1 := Lr_ParamFechaDesde.VALOR1;
      Lr_ParametroFeDesde.VALOR3 := Lr_ParamFechaDesde.VALOR3;
      Lr_ParametroFeDesde.VALOR4 := Lr_ParamFechaDesde.VALOR4;

      Lr_ParametroFeHasta.VALOR1 := Lr_ParamFechaHasta.VALOR1;
      Lr_ParametroFeHasta.VALOR3 := Lr_ParamFechaHasta.VALOR3;
      Lr_ParametroFeHasta.VALOR4 := Lr_ParamFechaHasta.VALOR4;
        
      --Se obtiene los parámetros para enviar el correo
      OPEN C_GetParametro(Lv_NombreCabeceraEnvioCorreo, Lv_EstadoActivo, Lv_EstadoActivo, Lv_DatosMail, NULL, NULL, NULL, NULL, 
                          Lr_GetAdmiParametrosDet.Empresa_Cod);

      FETCH C_GetParametro INTO Lr_Parametro;
      CLOSE C_GetParametro;
      
      --Se obtiene el alias y la plantilla donde se enviará la notificación   
      Lr_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_CodigoPlantilla);    
      --Si no esta configurado la plantilla con alias y el parámetro con los datos del remitente y asunto
      --no se enviará la notificación
      IF Lr_Parametro.ID_PARAMETRO_DET     IS NOT NULL AND
        Lr_GetAliasPlantilla.PLANTILLA     IS NOT NULL AND
        Lr_Parametro.VALOR2                IS NOT NULL AND
        Lr_Parametro.VALOR3                IS NOT NULL AND
        Lr_GetAliasPlantilla.ALIAS_CORREOS IS NOT NULL THEN
        
        DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);

        IF Lrf_GetHistFormasPago%ISOPEN THEN
          CLOSE Lrf_GetHistFormasPago;
        END IF;

        DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.P_GET_PTOS_CAMBIO_FORMA_PAGO(Pv_PrefijoEmpresa,
                                                                          Lr_ParametroFeDesde,
                                                                          Lr_ParametroFeHasta,
                                                                          Lrf_GetHistFormasPago);

        -- CABECERA DEL REPORTE
        utl_file.put_line(Lfile_Archivo, 'LOGIN'||Lv_Delimitador 
                                       ||'FP_ANTERIOR'||Lv_Delimitador 
                                       ||'FP_ACTUAL'||Lv_Delimitador 
                                       ||'NUMERO_ACTA'||Lv_Delimitador 
                                       ||'FE_ACTIVACION'||Lv_Delimitador 
                                       ||'USUARIO'||Lv_Delimitador 
                                       ||'MOTIVO'||Lv_Delimitador 
                                       ||'ES_FACTURABLE'||Lv_Delimitador 
                                       ||'NUM_FACTURA'||Lv_Delimitador 
                                       ||'FECHA EMISION'||Lv_Delimitador 
                                       ||'VALOR'||Lv_Delimitador );
     
        LOOP

          FETCH Lrf_GetHistFormasPago BULK COLLECT INTO Lr_HistFormasPago LIMIT 1000;
          Ln_Indsx := Lr_HistFormasPago.FIRST;
          WHILE (Ln_Indsx IS NOT NULL)
            LOOP
              Lr_HistFormaPago:=Lr_HistFormasPago(Ln_Indsx);
              DBMS_LOB.APPEND(Lcl_TableDocumento, '<tr><td> ' ||
                             NVL(Lr_HistFormaPago.LOGIN,''' ''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.FP_ANTERIOR,''' ''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.FP_ACTUAL,''' ''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.NUMERO_ACTA,0) || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.FE_ACTIVACION,''' ''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.USUARIO,''' ''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.MOTIVO,''' ''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.ES_FACTURABLE,''' ''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.NUM_FACTURA,'''''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.FECHA,''' ''') || ' </td><td> ' ||
                             NVL(Lr_HistFormaPago.VALOR,0) || ' </td></tr>');
              Ln_Indsx := Lr_HistFormasPago.NEXT(Ln_Indsx);



              utl_file.put_line(Lfile_Archivo, NVL(Lr_HistFormaPago.LOGIN,''' ''')||Lv_Delimitador 
                                             ||NVL(Lr_HistFormaPago.FP_ANTERIOR,''' ''')||Lv_Delimitador 
                                             ||NVL(Lr_HistFormaPago.FP_ACTUAL,''' ''')||Lv_Delimitador  
                                             ||NVL(Lr_HistFormaPago.NUMERO_ACTA,0)||Lv_Delimitador 
                                             ||NVL(Lr_HistFormaPago.FE_ACTIVACION,''' ''')||Lv_Delimitador 
                                             ||NVL(Lr_HistFormaPago.USUARIO,''' ''')||Lv_Delimitador 
                                             ||NVL(Lr_HistFormaPago.MOTIVO,''' ''') ||Lv_Delimitador 
                                             ||NVL(Lr_HistFormaPago.ES_FACTURABLE,''' ''')||Lv_Delimitador 
                                             ||NVL(Lr_HistFormaPago.NUM_FACTURA,'''''')||Lv_Delimitador 
                                             ||NVL(Lr_HistFormaPago.FECHA,''' ''')||Lv_Delimitador                                              
                                             ||NVL(Lr_HistFormaPago.VALOR,0) ||Lv_Delimitador );
            END LOOP;

            UTL_FILE.fclose(Lfile_Archivo);
            DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 

            UTL_FILE.FCOPY(Lv_Directorio,Lv_NombreArchivoGz,Lv_Directorio,Lv_NombreArchivoZip); 

            Ln_CounterCommit := Ln_CounterCommit + 1;

            IF Ln_CounterCommit >= 50 THEN
            
              Ln_CounterCommit := 0;
              Lcl_MessageMail  := NULL;
              Lcl_MessageMail  := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA, 
                                                                            '{{ plContratoHist | raw }}', 
                                                                            Lcl_TableDocumento);
              --Envía correo
              DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR2, 
                                                      Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                      Lr_Parametro.VALOR3,
                                                      SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                      Lv_MimeType,
                                                      Pv_MensajeError);

              DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lr_Parametro.VALOR2||',', 
                                                        Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                        Lr_Parametro.VALOR3, 
                                                        Lcl_MessageMail, 
                                                        Lv_Directorio,
                                                        Lv_MimeType,
                                                        Lv_NombreArchivoZip);

              UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip); 
              UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoGz); 
              UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoCsv); 
              
              
              IF TRIM(Pv_MensajeError) IS NOT NULL THEN
                
                Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;          
                RAISE Le_Exception;
                
              END IF;
               
              DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
              Lcl_TableDocumento := '';
              DBMS_LOB.CREATETEMPORARY(Lcl_TableDocumento, TRUE);
              COMMIT;
              
            END IF;           

            EXIT
              WHEN Lrf_GetHistFormasPago%notfound;
          
        END LOOP;
        CLOSE Lrf_GetHistFormasPago;
        
        --En caso de que el contador no haya llegado a 50 se envía los documentos obtenidos hasta el momento
        IF Ln_CounterCommit < 50 AND Ln_CounterCommit > 0 THEN

          Lcl_MessageMail := NULL;
          Lcl_MessageMail := DB_FINANCIERO.FNCK_CONSULTS.F_CLOB_REPLACE(Lr_GetAliasPlantilla.PLANTILLA,
                                                                        '{{ plContratoHist | raw }}', 
                                                                        Lcl_TableDocumento);   
          --Envía correo
          DB_FINANCIERO.FNCK_CONSULTS.P_SEND_MAIL(Lr_Parametro.VALOR2, 
                                                  Lr_GetAliasPlantilla.ALIAS_CORREOS,
                                                  Lr_Parametro.VALOR3,
                                                  SUBSTR(Lcl_MessageMail, 1, 32767), 
                                                  Lv_MimeType,
                                                  Pv_MensajeError);

          DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lr_Parametro.VALOR2, 
                                                    Lr_GetAliasPlantilla.ALIAS_CORREOS||',',
                                                    Lr_Parametro.VALOR3, 
                                                    Lcl_MessageMail, 
                                                    Lv_Directorio,
                                                    Lv_MimeType,
                                                    Lv_NombreArchivoZip);

          UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip); 
          UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoGz); 
          UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoCsv); 

          IF TRIM(Pv_MensajeError) IS NOT NULL THEN
            Pv_MensajeError := 'No se pudo notificar por correo - ' || Pv_MensajeError ;
            RAISE Le_Exception;
          END IF;

          DBMS_LOB.FREETEMPORARY(Lcl_TableDocumento);
          Lcl_TableDocumento := '';
          COMMIT;
        END IF;
        
      END IF;
      
    END IF;
  EXCEPTION
    WHEN Le_Exception THEN
      ROLLBACK;
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.P_NOTIF_CAMBIO_FORMA_PAGO', SQLERRM);    
    WHEN OTHERS THEN
      ROLLBACK;
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.P_NOTIF_CAMBIO_FORMA_PAGO', SQLERRM);
  END P_NOTIF_CAMBIO_FORMA_PAGO;

FUNCTION F_GET_MIN_FE_ACT_INT(Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GET_FE_ACTIVACION_INT(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MIN(ISH.FE_CREACION),'DD-MM-YYYY')
    FROM DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH    ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID   = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD              ON IPD.PLAN_ID     = ISER.PLAN_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP               ON AP.ID_PRODUCTO  = IPD.PRODUCTO_ID
    WHERE ISER.PUNTO_ID      = Cn_IdPunto
    AND AP.CODIGO_PRODUCTO   = 'INTD'
    AND ISER.ESTADO          = 'Activo'
    AND ISER.PUNTO_FACTURACION_ID IS NOT NULL;
  --
  Lv_FeActivacionInternet VARCHAR2(10);
  --
BEGIN
  --
  --
  IF C_GET_FE_ACTIVACION_INT%ISOPEN THEN
    CLOSE C_GET_FE_ACTIVACION_INT;
  END IF;
  --
  OPEN C_GET_FE_ACTIVACION_INT(Fn_IdPunto);
  --
  FETCH C_GET_FE_ACTIVACION_INT INTO Lv_FeActivacionInternet;
  --
  CLOSE C_GET_FE_ACTIVACION_INT;
  --
  RETURN NVL(Lv_FeActivacionInternet,'');
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_MIN_FE_ACT_INT', SQLERRM);
  --
END F_GET_MIN_FE_ACT_INT;



FUNCTION F_GET_FORMA_PAGO_ACT (Fn_IdContrato   IN   DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
  RETURN VARCHAR2
  IS
  -- Costo: 0,011
  CURSOR C_GET_FORMA_PAGO(Cn_IdContrato DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE) IS
    SELECT NVL(AFP.DESCRIPCION_FORMA_PAGO,'') AS FORMA_PAGO
    FROM   DB_COMERCIAL.INFO_CONTRATO IC
    JOIN   DB_GENERAL.ADMI_FORMA_PAGO AFP  ON     AFP.ID_FORMA_PAGO  = IC.FORMA_PAGO_ID 
    WHERE  IC.ESTADO                 = 'Activo'
    AND    IC.ID_CONTRATO            = Cn_IdContrato;

  CURSOR C_GET_TIPO_CUENTA(Cn_IdContrato DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE) IS
    SELECT NVL(ATC.DESCRIPCION_CUENTA,'') AS FORMA_PAGO
    FROM   DB_COMERCIAL.INFO_CONTRATO IC
    JOIN   DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP  ON ICFP.CONTRATO_ID           = IC.ID_CONTRATO
    JOIN   DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC      ON ABTC.ID_BANCO_TIPO_CUENTA  = ICFP.BANCO_TIPO_CUENTA_ID 
    JOIN   DB_GENERAL.ADMI_TIPO_CUENTA       ATC       ON ATC.ID_TIPO_CUENTA         = ABTC.TIPO_CUENTA_ID
    WHERE  IC.ESTADO                 = 'Activo'
    AND    IC.ID_CONTRATO            = Cn_IdContrato;
    
    Lv_FormaPagoActual   DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE;
    Lv_TipoCuenta        DB_GENERAL.ADMI_TIPO_CUENTA.DESCRIPCION_CUENTA%TYPE;
    
    BEGIN
    
    IF C_GET_FORMA_PAGO %ISOPEN THEN
      CLOSE C_GET_FORMA_PAGO;
    END IF;

    IF C_GET_TIPO_CUENTA %ISOPEN THEN
      CLOSE C_GET_TIPO_CUENTA;
    END IF;

    OPEN C_GET_FORMA_PAGO(Fn_IdContrato);
      FETCH C_GET_FORMA_PAGO INTO Lv_FormaPagoActual;
    CLOSE C_GET_FORMA_PAGO;

    IF Lv_FormaPagoActual = 'DEBITO BANCARIO' THEN
      OPEN C_GET_TIPO_CUENTA(Fn_IdContrato);
        FETCH C_GET_TIPO_CUENTA INTO Lv_FormaPagoActual;
      CLOSE C_GET_TIPO_CUENTA;     
    END IF;  

  RETURN NVL(Lv_FormaPagoActual,'');
  --
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_FORMA_PAGO_ACT', SQLERRM);
  --
  END F_GET_FORMA_PAGO_ACT;

FUNCTION F_GET_ORIGEN_TRASL_CRS(Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GET_HISTORIAL(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT ISH.ID_SERVICIO_HISTORIAL, ISH.ACCION, ISH.OBSERVACION
    FROM DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH    ON ISH.SERVICIO_ID = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID   = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD              ON IPD.PLAN_ID     = ISER.PLAN_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP               ON AP.ID_PRODUCTO  = IPD.PRODUCTO_ID
    WHERE (UPPER (ISH.ACCION)      = 'FEORIGSERVICIOTRASLADADO'
           OR  UPPER (ISH.OBSERVACION) LIKE 'SE CREÓ EL SERVICIO POR TRASLADO DEL LOGIN%'
           OR  UPPER (ISH.ACCION)  = 'FEORIGENCAMBIORAZONSOCIAL'
           OR  UPPER (ISH.ACCION)  = 'FEORIGSERVICIONETLIFECAM'
           OR  UPPER (ISH.OBSERVACION) LIKE 'SE CONFIRMÓ EL SERVICIO POR CAMBIO DE RAZÓN SOCIAL%'
           OR  UPPER (ISH.OBSERVACION) LIKE 'FECHA INICIAL DE SERVICIO NETLIFECAM%'
           OR  UPPER (ISH.OBSERVACION) LIKE 'FECHA INICIAL DE SERVICIO POR CAMBIO DE RAZÓN SOCIAL%'           
           OR  UPPER (ISH.OBSERVACION) LIKE 'CREADO POR CAMBIO DE RAZON SOCIAL POR LOGIN%'
           )
    AND ISER.PUNTO_ID      = Cn_IdPunto;
  --
  Lv_Origen         VARCHAR2(30);
  Ln_IdPuntoOrigen  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
  Lr_InfoServHist   C_GET_HISTORIAL%ROWTYPE;
  --
BEGIN
  --
  --
  IF C_GET_HISTORIAL%ISOPEN THEN
    CLOSE C_GET_HISTORIAL;
  END IF;
  --
  OPEN C_GET_HISTORIAL(Fn_IdPunto);
  --
  FETCH C_GET_HISTORIAL INTO Lr_InfoServHist;
  --
  CLOSE C_GET_HISTORIAL;
  --
  IF UPPER (Lr_InfoServHist.ACCION) = 'FEORIGSERVICIOTRASLADADO' OR 
     UPPER (Lr_InfoServHist.ACCION) = 'FEORIGSERVICIONETLIFECAM' OR
     (INSTR(UPPER(Lr_InfoServHist.OBSERVACION),'SE CREÓ EL SERVICIO POR TRASLADO DEL LOGIN') <> 0)THEN
    Lv_Origen := 'Traslado';
  ELSIF UPPER (Lr_InfoServHist.ACCION) = 'FEORIGENCAMBIORAZONSOCIAL' OR
        UPPER (Lr_InfoServHist.ACCION) = 'FEORIGSERVICIONETLIFECAM'  OR 
       (INSTR(UPPER(Lr_InfoServHist.OBSERVACION),'CAMBIO DE RAZÓN SOCIAL') <> 0) OR 
       (INSTR(UPPER(Lr_InfoServHist.OBSERVACION),'CAMBIO DE RAZON SOCIAL') <> 0)THEN
    Lv_Origen := 'CRS';
  END IF;

  IF Lv_Origen = 'Traslado' THEN
    Ln_IdPuntoOrigen := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PTO_ORIGEN_TRASLADO(Fn_IdPunto);
  ELSIF Lv_Origen = 'CRS' THEN
    Ln_IdPuntoOrigen := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PTO_ORI_CRS_LOGIN(Fn_IdPunto);
    IF Ln_IdPuntoOrigen = 0 THEN
      Ln_IdPuntoOrigen := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PTO_ORI_CRS_TRAD(Fn_IdPunto);
    END IF;
  END IF;
  Lv_Origen := Lv_Origen || '|' ||Ln_IdPuntoOrigen;
  RETURN NVL(Lv_Origen,'');
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_HIST_TRASL_CRS', SQLERRM);
  --
END F_GET_ORIGEN_TRASL_CRS;


FUNCTION F_GET_PTO_ORIGEN_TRASLADO(Fn_IdPuntoDestino   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_GET_PTO_ORIGEN_TRASLADO(Cn_IdPuntoDestino DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE) IS
    SELECT IPT.ID_PUNTO
    FROM  DB_COMERCIAL.INFO_SERVICIO                ISER  
    JOIN  DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT    ISPC       ON ISER.ID_SERVICIO                = ISPC.SERVICIO_ID
    JOIN  DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC        ON APC.ID_PRODUCTO_CARACTERISITICA = ISPC.PRODUCTO_CARACTERISITICA_ID
    JOIN  DB_COMERCIAL.ADMI_CARACTERISTICA          AC         ON AC.ID_CARACTERISTICA            = APC.CARACTERISTICA_ID
    JOIN  DB_COMERCIAL.INFO_SERVICIO                ISER_ORG   ON   ISER_ORG.ID_SERVICIO    = COALESCE(TO_NUMBER(REGEXP_SUBSTR(ISPC.VALOR,'^\d+')),0)
    JOIN  DB_COMERCIAL.INFO_PUNTO                   IPT        ON IPT.ID_PUNTO              = ISER_ORG.PUNTO_ID
    WHERE AC.DESCRIPCION_CARACTERISTICA = 'TRASLADO'
    AND   ISER.PUNTO_ID                 = Cn_IdPuntoDestino;    
  --
  Ln_IdPuntoOrigen  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
  --
BEGIN
  --
  --
  IF C_GET_PTO_ORIGEN_TRASLADO%ISOPEN THEN
    CLOSE C_GET_PTO_ORIGEN_TRASLADO;
  END IF;
  --
  OPEN C_GET_PTO_ORIGEN_TRASLADO(Fn_IdPuntoDestino);
  --
  FETCH C_GET_PTO_ORIGEN_TRASLADO INTO Ln_IdPuntoOrigen;
  --
  CLOSE C_GET_PTO_ORIGEN_TRASLADO;
  --
  RETURN NVL(Ln_IdPuntoOrigen,0);
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_PTO_ORIGEN_TRASLADO', SQLERRM);
  --
END F_GET_PTO_ORIGEN_TRASLADO;


FUNCTION F_GET_PTO_ORI_CRS_LOGIN(Fn_IdPuntoDestino   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_GET_PTO_ORIGEN_CRS(Cn_IdPuntoDestino DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE) IS
    SELECT IPT_ORIGEN.ID_PUNTO
    FROM  DB_COMERCIAL.INFO_PUNTO_CARACTERISTICA    IPC
    JOIN  DB_COMERCIAL.ADMI_CARACTERISTICA          AC          ON AC.ID_CARACTERISTICA = IPC.CARACTERISTICA_ID
    JOIN  DB_COMERCIAL.INFO_PUNTO                   IPT_ORIGEN  ON IPT_ORIGEN.ID_PUNTO  = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IPC.VALOR,'^\d+')),0)
    WHERE AC.DESCRIPCION_CARACTERISTICA = 'PUNTO CAMBIO RAZON SOCIAL'
    AND   IPC.PUNTO_ID                  = Cn_IdPuntoDestino;    
  --
  Ln_IdPuntoOrigen  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
  --
BEGIN
  --
  --
  IF C_GET_PTO_ORIGEN_CRS%ISOPEN THEN
    CLOSE C_GET_PTO_ORIGEN_CRS;
  END IF;
  --
  OPEN C_GET_PTO_ORIGEN_CRS(Fn_IdPuntoDestino);
  --
  FETCH C_GET_PTO_ORIGEN_CRS INTO Ln_IdPuntoOrigen;
  --
  CLOSE C_GET_PTO_ORIGEN_CRS;
  --
  RETURN NVL(Ln_IdPuntoOrigen,0);
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_PTO_ORI_CRS_LOGIN', SQLERRM);
  --
END F_GET_PTO_ORI_CRS_LOGIN;


FUNCTION F_GET_PTO_ORI_CRS_TRAD(Fn_IdPuntoDestino   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN NUMBER
IS
  --
  CURSOR C_GET_PTO_ORIGEN_CRS(Cn_IdPuntoDestino DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ID_SERVICIO_HISTORIAL%TYPE) IS
    SELECT IPT_ORIGEN.ID_PUNTO
    FROM  DB_COMERCIAL.INFO_PUNTO                  IPT_DESTINO
    JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL    IPER_DETINO         ON IPER_DETINO.ID_PERSONA_ROL  = IPT_DESTINO.PERSONA_EMPRESA_ROL_ID
    JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL    IPER_ORIGEN         ON IPER_ORIGEN.ID_PERSONA_ROL  = IPER_DETINO.PERSONA_EMPRESA_ROL_ID
    JOIN  DB_COMERCIAL.INFO_PUNTO                  IPT_ORIGEN          ON IPT_ORIGEN.PERSONA_EMPRESA_ROL_ID  = IPER_ORIGEN.ID_PERSONA_ROL
    WHERE IPT_DESTINO.ID_PUNTO = Cn_IdPuntoDestino;    
  --
  Ln_IdPuntoOrigen  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
  --
BEGIN
  --
  --
  IF C_GET_PTO_ORIGEN_CRS%ISOPEN THEN
    CLOSE C_GET_PTO_ORIGEN_CRS;
  END IF;
  --
  OPEN C_GET_PTO_ORIGEN_CRS(Fn_IdPuntoDestino);
  --
  FETCH C_GET_PTO_ORIGEN_CRS INTO Ln_IdPuntoOrigen;
  --
  CLOSE C_GET_PTO_ORIGEN_CRS;
  --
  RETURN NVL(Ln_IdPuntoOrigen,0);
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_PTO_ORI_CRS_TRAD', SQLERRM);
  --
END F_GET_PTO_ORI_CRS_TRAD;

FUNCTION F_GET_MESES_ACTIVO(Fn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL)
  RETURN NUMBER
IS
  -- Costo del query: 5
  CURSOR GetNumMesesActivo(Cn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE,MIN(ISH.FE_CREACION)))
    FROM   DB_COMERCIAL.INFO_SERVICIO SERV 
    JOIN   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON SERV.ID_SERVICIO = ISH.SERVICIO_ID
    WHERE  
    (UPPER (ISH.ACCION)      = 'FEORIGENCAMBIORAZONSOCIAL'
     OR  UPPER (ISH.ACCION)  = 'FEORIGSERVICIOTRASLADADO'
     OR  UPPER (ISH.ACCION)  = 'CONFIRMARSERVICIO'
     OR  UPPER (ISH.ACCION)  = 'FEORIGSERVICIONETLIFECAM'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'FECHA INICIAL DE SERVICIO NETLIFECAM.'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CONFIRMO EL SERVICIO'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CREO EL SERVICIO'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE ACTIVO EL SERVICIO TRASLADO'
    )                                        
    AND ISH.SERVICIO_ID   =  Cn_IdServicio                                    
    AND ISH.ESTADO        = 'Activo';
  --
  Ln_NumMesesActivo NUMBER;
  --
BEGIN
  --
  --
  IF GetNumMesesActivo%ISOPEN THEN
      CLOSE GetNumMesesActivo;
  END IF;
  --
  OPEN GetNumMesesActivo(Fn_IdServicio);
  --
  FETCH GetNumMesesActivo INTO Ln_NumMesesActivo;
  --
  CLOSE GetNumMesesActivo;
  --
  IF Ln_NumMesesActivo <= 0 THEN
      Ln_NumMesesActivo := 1;
  END IF;
  --
  RETURN Ln_NumMesesActivo;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_MESES_ACTIVO', SQLERRM);
  --
END F_GET_MESES_ACTIVO;

FUNCTION F_GET_DCTO_ULT_FORMA_PAG(Fn_IdContrato   IN   DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
    RETURN NUMBER
IS
  --
  CURSOR C_GET_DCTO_ULT_FORMA_PAG(Cn_IdContrato  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE) IS
    SELECT NVL(ICFPH.DCTO_APLICADO,NULL) 
    FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST ICFPH 
    WHERE ICFPH.CONTRATO_ID   = Cn_IdContrato
    AND   ICFPH.ID_DATOS_PAGO = (SELECT MAX(ICFH.ID_DATOS_PAGO) 
                                 FROM   DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST ICFH
                                 WHERE  ICFH.CONTRATO_ID   = Cn_IdContrato);
  --
  Ln_PorcentajeDcto DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST.DCTO_APLICADO%TYPE;
  --
BEGIN
  --
  --
  IF C_GET_DCTO_ULT_FORMA_PAG%ISOPEN THEN
    CLOSE C_GET_DCTO_ULT_FORMA_PAG;
  END IF;
  --
  OPEN C_GET_DCTO_ULT_FORMA_PAG(Fn_IdContrato);
  --
  FETCH C_GET_DCTO_ULT_FORMA_PAG INTO Ln_PorcentajeDcto;
  --
  CLOSE C_GET_DCTO_ULT_FORMA_PAG;
  --
  RETURN Ln_PorcentajeDcto;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO', 'FNCK_CAMBIO_FORMA_PAGO.F_GET_DCTO_ULT_FORMA_PAG', SQLERRM);
  --
END F_GET_DCTO_ULT_FORMA_PAG;



FUNCTION F_GET_PORCENTAJE_DCTO_INST (Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Fn_IdServicio         IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Fn_IdContrato         IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                     Fn_FormaPagoId        IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                     Fn_TipoCuentaId       IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                     Fn_BancoTipoCuentaId  IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE)
RETURN NUMBER
IS
  Ln_PorcentajeDtoFormaPagOrigen    NUMBER := 0;
  Ln_PorcentDctoFormaPagDestino     NUMBER := 0;
  Ln_PorcentajeDescuentoInstalac    NUMBER := 0;
  Lv_TipoMedio                      VARCHAR2 (2) ;
  Lrf_GetAdmiParamtrosDet           SYS_REFCURSOR ;
  Ln_IdServicioInst                 DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE;
  Lr_GetAdmiParamtrosDet            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE ;
  Lv_TipoPromocion                  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE := 'PROM_INS';
  Lv_ParamPorcDescInsta             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'PORCENTAJE_DESCUENTO_INSTALACION'; 
  Lv_EstadoActivo                   DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
  Lv_FormaPagoBaseMap               VARCHAR2(8)                                               := 'EFECTIVO';
  Lv_TipoMedioBase                  VARCHAR2 (2)                                              := 'FO'; 
  Lv_FormaPagoBase                  VARCHAR2(250);

BEGIN

  Lv_TipoMedio            :=  NVL(FNCK_CAMBIO_FORMA_PAGO.F_GET_TIPOMEDIO(Fn_IdServicio,Lv_EstadoActivo,NULL),'');
  Lv_FormaPagoBase        :=  NVL(FNCK_CAMBIO_FORMA_PAGO.F_GET_FORMA_PAGO_ACT(Fn_IdContrato),0);  
  Lrf_GetAdmiParamtrosDet :=  FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamPorcDescInsta, Lv_EstadoActivo, Lv_EstadoActivo, Lv_TipoMedio, Lv_FormaPagoBaseMap, NULL, NULL);
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  CLOSE Lrf_GetAdmiParamtrosDet;  

-- Porcentage promocional vigente forma de pago destino

 Ln_PorcentDctoFormaPagDestino := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_DCTO_DEST ( Fv_EmpresaCod,
                                                                                                    Fn_IdPunto,
                                                                                                    Fn_IdServicio,
                                                                                                    Fn_IdContrato,
                                                                                                    Fn_FormaPagoId,
                                                                                                    Fn_TipoCuentaId,
                                                                                                    Fn_BancoTipoCuentaId);

  -- Porcentaje Dcto forma de pago orígen
  Ln_PorcentajeDtoFormaPagOrigen :=  DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_DCTO_ULT_FORMA_PAG(Fn_IdContrato);

  IF Ln_PorcentajeDtoFormaPagOrigen IS NULL THEN

    Ln_PorcentajeDtoFormaPagOrigen := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_MAPEO_PROMO(Lv_TipoPromocion,Fn_IdServicio);

    IF Ln_PorcentajeDtoFormaPagOrigen = 0  THEN

      Ln_IdServicioInst    := DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_SERVICIO_ID_FACT_INST(Fn_IdPunto);
      
      Ln_PorcentajeDtoFormaPagOrigen := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_MAPEO_PROMO(Lv_TipoPromocion,Ln_IdServicioInst);

    END IF;

    IF Ln_PorcentajeDtoFormaPagOrigen = 0  THEN
      Lrf_GetAdmiParamtrosDet :=  FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamPorcDescInsta, Lv_EstadoActivo, Lv_EstadoActivo, Lv_TipoMedioBase, Lv_FormaPagoBase, NULL, NULL);
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      CLOSE Lrf_GetAdmiParamtrosDet;

      Ln_PorcentajeDtoFormaPagOrigen := NVL(TO_NUMBER(Lr_GetAdmiParamtrosDet.VALOR3),0);

    END IF;
   END IF;

  IF Ln_PorcentajeDtoFormaPagOrigen IS NOT NULL  THEN
    Ln_PorcentajeDtoFormaPagOrigen := NVL(Ln_PorcentajeDtoFormaPagOrigen/100,0);
  ELSE
    Ln_PorcentajeDtoFormaPagOrigen := 0;
  END IF;  
  Ln_PorcentajeDescuentoInstalac := Ln_PorcentajeDtoFormaPagOrigen - Ln_PorcentDctoFormaPagDestino;

  IF Ln_PorcentajeDescuentoInstalac <= 0  THEN
    RETURN 0;
  END IF;

RETURN Ln_PorcentajeDescuentoInstalac;

EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO','FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_DCTO_INST', SQLERRM);
  --
END F_GET_PORCENTAJE_DCTO_INST;


FUNCTION F_GET_PORCENTAJE_DCTO_DEST (Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Fn_IdServicio         IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Fn_IdContrato         IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                     Fn_FormaPagoId        IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                     Fn_TipoCuentaId       IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                     Fn_BancoTipoCuentaId  IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE)
RETURN NUMBER
IS
  Ln_PorcentDctoFormaPagDestino     NUMBER := 0;
  Ln_CantPeriodo                    NUMBER;
  Lv_ObdDctoVigente                 VARCHAR2(4000);
  Lv_TipoPromocion                  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE := 'PROM_INS';

BEGIN
-- Porcentage promocional vigente forma de pago destino

  DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_PROMO_TENTATIVA
               (
                   Fn_IdPunto,
                   Fn_IdServicio,
                   Lv_TipoPromocion,
                   Fv_EmpresaCod,
                   Fn_FormaPagoId,
                   Fn_TipoCuentaId,
                   Fn_BancoTipoCuentaId,
                   Ln_PorcentDctoFormaPagDestino,
                   Ln_CantPeriodo,
                   Lv_ObdDctoVigente
               );
  IF Ln_PorcentDctoFormaPagDestino IS NOT NULL  THEN
    Ln_PorcentDctoFormaPagDestino := NVL(TO_NUMBER(Ln_PorcentDctoFormaPagDestino)/100,0);
  ELSE
    Ln_PorcentDctoFormaPagDestino := 0;
  END IF;

RETURN Ln_PorcentDctoFormaPagDestino;

EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO','FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_DCTO_DEST', SQLERRM);
  --
END F_GET_PORCENTAJE_DCTO_DEST;

PROCEDURE P_GET_PORCENTAJE_DCTO_INST (Pv_EmpresaCod          IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pn_IdPunto             IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pn_IdServicio          IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pn_IdContrato          IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                      Pn_FormaPagoId         IN  DB_COMERCIAL.INFO_CONTRATO.FORMA_PAGO_ID%TYPE,
                                      Pn_TipoCuentaId        IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.TIPO_CUENTA_ID%TYPE,
                                      Pn_BancoTipoCuentaId   IN  DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO.BANCO_TIPO_CUENTA_ID%TYPE,
                                      Pn_PorcFormaPagOrigen  OUT NUMBER,
                                      Pn_PorcFormaPagDestino OUT NUMBER,
                                      Pn_PorcDescuentoInst   OUT NUMBER)
IS
  Lv_TipoMedio                      VARCHAR2 (2) ;
  Lrf_GetAdmiParamtrosDet           SYS_REFCURSOR ;
  Ln_IdServicioInst                 DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE;
  Lr_GetAdmiParamtrosDet            DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE ;
  Lv_TipoPromocion                  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE := 'PROM_INS';
  Lv_ParamPorcDescInsta             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'PORCENTAJE_DESCUENTO_INSTALACION'; 
  Lv_EstadoActivo                   DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
  Lv_FormaPagoBaseMap               VARCHAR2(8)                                               := 'EFECTIVO';
  Lv_TipoMedioBase                  VARCHAR2 (2)                                              := 'FO'; 
  Lv_FormaPagoBase                  VARCHAR2(250);

BEGIN
  Pn_PorcFormaPagOrigen   := 0;
  Pn_PorcFormaPagDestino  := 0;
  Pn_PorcDescuentoInst    := 0;
  Lv_TipoMedio            :=  NVL(FNCK_CAMBIO_FORMA_PAGO.F_GET_TIPOMEDIO(Pn_IdServicio,Lv_EstadoActivo,NULL),'');
  Lv_FormaPagoBase        :=  NVL(FNCK_CAMBIO_FORMA_PAGO.F_GET_FORMA_PAGO_ACT(Pn_IdContrato),0);  
  Lrf_GetAdmiParamtrosDet :=  FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamPorcDescInsta, Lv_EstadoActivo, Lv_EstadoActivo, Lv_TipoMedio, Lv_FormaPagoBaseMap, NULL, NULL);
  FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
  CLOSE Lrf_GetAdmiParamtrosDet;  

-- Porcentage promocional vigente forma de pago destino

 Pn_PorcFormaPagDestino := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_DCTO_DEST (Pv_EmpresaCod,
                                                                                            Pn_IdPunto,
                                                                                            Pn_IdServicio,
                                                                                            Pn_IdContrato,
                                                                                            Pn_FormaPagoId,
                                                                                            Pn_TipoCuentaId,
                                                                                            Pn_BancoTipoCuentaId);

  -- Porcentaje Dcto forma de pago orígen
  Pn_PorcFormaPagOrigen :=  DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_DCTO_ULT_FORMA_PAG(Pn_IdContrato);

  IF Pn_PorcFormaPagOrigen IS NULL THEN

    Pn_PorcFormaPagOrigen := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_MAPEO_PROMO(Lv_TipoPromocion,Pn_IdServicio);

    IF Pn_PorcFormaPagOrigen = 0  THEN

      Ln_IdServicioInst    := DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_SERVICIO_ID_FACT_INST(Pn_IdPunto);
      
      Pn_PorcFormaPagOrigen := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_MAPEO_PROMO(Lv_TipoPromocion,Ln_IdServicioInst);

    END IF;

    IF Pn_PorcFormaPagOrigen = 0  THEN
      Lrf_GetAdmiParamtrosDet :=  FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamPorcDescInsta, Lv_EstadoActivo, Lv_EstadoActivo, Lv_TipoMedioBase, Lv_FormaPagoBase, NULL, NULL);
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      CLOSE Lrf_GetAdmiParamtrosDet;

      Pn_PorcFormaPagOrigen := NVL(TO_NUMBER(Lr_GetAdmiParamtrosDet.VALOR3),0);

    END IF;
   END IF;

  IF Pn_PorcFormaPagOrigen IS NOT NULL  THEN
    Pn_PorcFormaPagOrigen := NVL(Pn_PorcFormaPagOrigen/100,0);
  ELSE
    Pn_PorcFormaPagOrigen := 0;
  END IF;  
  Pn_PorcDescuentoInst := Pn_PorcFormaPagOrigen - Pn_PorcFormaPagDestino;

  IF Pn_PorcDescuentoInst <= 0  THEN
    Pn_PorcDescuentoInst := 0;
  END IF;

EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CAMBIO_FORMA_PAGO','FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_DCTO_INST', SQLERRM);
  --
END P_GET_PORCENTAJE_DCTO_INST;

END FNCK_CAMBIO_FORMA_PAGO;
/
