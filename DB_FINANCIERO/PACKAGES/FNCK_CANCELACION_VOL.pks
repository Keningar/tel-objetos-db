CREATE EDITIONABLE PACKAGE               FNCK_CANCELACION_VOL AS

  /*
  * Documentaci�n para TYPE 'Lrf_Result'.
  *
  * Tipo de datos para el retorno de la informaci�n correspondiente a facturas.
  *
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.0 12-07-2019
  *
  */
  TYPE Lr_Listado IS RECORD(
    TOTAL_REGISTRO NUMBER);
    --
  TYPE Lt_Result IS TABLE OF Lr_Listado;
   --
  TYPE Lrf_Result
    IS
      REF CURSOR;
  /*
  * Documentaci�n para TYPE 'TypeArreglo'.
  * Tipo que me permite almacenar datos en forma de array.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 06-12-2022
  */
  TYPE TypeArreglo IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

  /**
  * Documentacion para el procedimiento 'P_GET_VALORES_FACT'
  *
  * Funci�n que permite obtener el total de descuentos del punto enviado como par�metro.
  *
  * @param Pv_EmpresaCod        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA, Id del punto a consultar
  * @param Pn_IdPtoFacturacion  IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, Id del punto a consultar
  * @param Pn_IdServicio        IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, Id del punto a consultar
  * @param Pv_DescProducto      IN  VARCHAR2, Descripcion del Producto 
  * @param Pn_ValorDcto         OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE, Id del punto a consultar
  * @param Pn_ValorInstalacion  OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE, Id del punto a consultar
  * @param Pn_NetlifeCloud      OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE, Id del punto a consultar
  * @param Pn_NetlifeAssistance OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE, Id del punto a consultar
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 04-09-2018
  * 
  * Se modifica el valor total de la instalaci�n por funci�n que eval�a f�rmula de amortizaci�n.
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.1 07-06-2019  
  *
  * Se modifica el valor total de la instalaci�n por funci�n que eval�a f�rmula parametrizada en 'FORMULA PROMOCIONAL INSTALACION'.
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.2 01-12-2020
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.3 22-03-2021  Se agrega funcionalidad para c�lculo de descuento facturado proveniente de un punto trasladado.
  *
  * @author Jonathan Mazon Sanchez <jmazon@telconet.ec>
  * @version 1.4 28-09-2021  Se agrega funcionalidad para c�lculo del producto ECDF
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.5 5-09-2022  Se agrega parametro de Descripcion del Producto, se modifican cursores para que reciban el IdServicio y se modifica 
  *                         funcionalidad para obtener los meses activos del servicio de ECDF(Cast de fecha a formato Date).
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.6 25-04-2023  Se modifica query del cursor C_GET_ID_SERV_INT, para obtener el servicio de internet del punto procesado,
  *                          con historial en estado Activo.
  *
  * Costo Query C_GET_CONTRATO: 12
  */
  PROCEDURE P_GET_VALORES_FACT (Pv_EmpresaCod        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                                Pn_IdPtoFacturacion  IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, 
                                Pn_IdServicio        IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, 
                                Pv_DescProducto      IN  VARCHAR2, 
                                Pn_ValorDcto         OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE,
                                Pn_ValorInstalacion  OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE,
                                Pn_NetlifeCloud      OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE,
                                Pn_NetlifeAssistance OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE,
                                Pn_ElCanalDelFutbol  OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE);

  /**
  * Documentaci�n para la funci�n 'F_GET_MESES_ACTIVO'
  *
  * Funci�n que permite obtener el n�mero de meses activo de un servicio.
  * @param  Fn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE  recibe el id del servicio.
  * @return NUMBER
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 16-09-2018
  *
  * Se modifica la funci�n para traer los meses activos del contrato.
  * se agrega como par�metro id del contrato.
  * @param  Fn_IdContrato   IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE  recibe el id del contrato.
  * @author Josselhin Moreira Q. <kjmoreira@telconet.ec>
  * @version 1.1 27-06-2019
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.2 08-01-2020 Se elimina el par�metro idContrato, se agregan nuevas consultas .
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.3 03-03-2021 Se agrega observaci�n por CRS para servicios antiguos
  *
  * @author Emmanuel Martillo <emartillo@telconet.ec>
  * @version 1.4 18-10-2022 Se agrega FechadeOrigenNetlifecam 
  *
  * @author Emmanuel Martillo <emartillo@telconet.ec>
  * @version 1.5 08-02-2023 Se agrega validacion para obtener de manera correcta la fecha para los netlifecam.
  */
  FUNCTION F_GET_MESES_ACTIVO(Fn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL)
    RETURN NUMBER;

  /**
  * Documentaci�n para la funci�n 'F_GET_TOTAL_FACTURADO'.
  *
  * Funci�n que permite obtener el total facturado del servicio con respecto a la fecha de vigencia enviada como par�metro.
  * @param  Fv_DescProducto   IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE   Recibe la descripci�n del producto.
  * @param  Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE            Recibe el id del servicio.
  * @param  Fd_FeCreacionHist IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE  Recibe la fecha de creaci�n del historial del servicio.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-10-2018
  */
  FUNCTION F_GET_TOTAL_FACTURADO(Fv_DescProducto   IN DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
                                 Fn_IdServicio     IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                 Fd_FeCreacionHist IN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE; 

  /**
  * Documentaci�n para la funci�n 'F_GET_DCTO_FACTURADO'.
  *
  * Funci�n que permite obtener el total de descuentos facturados del punto enviado como par�metro.
  * @param  Fn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                                   Recibe el id del punto.
  * @param  Fv_TipoDoc     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Recibe el c�digo de tipo de documento.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE                  Retorna el valor total facturado.  
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-10-2018
  * 
  * Se modifica query para que tome los valores que no hayan sido facturados con la caracteristica cambio forma de pago.
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.1 12-07-2019
  *
  * Se modifica query para que tome el valor sumarizado de decuentos, se excluye facturas de instalaci�n.
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.2 08-05-2020
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.3 10-05-2020 Se mejora condici�n para excluir documentos con caracter�stica de cambio de forma de pago y por instalaci�n.
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.4 24-03-2021 Se agrega par�metro tipo de documento.
  */    
FUNCTION F_GET_DCTO_FACTURADO(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Fv_TipoDoc     IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;


  /**
  * Documentaci�n para la funci�n 'F_GET_DCTO_FACTURADO_SERVICIO'.
  *
  * Funci�n que permite obtener el total de descuentos facturados del punto y servicio enviado como par�metro.
  * @param  Fn_IdPunto     DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                                   Recibe el id del punto.
  * @param  Fn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE                             Recibe el id del servicio.
  * @param  Fv_TipoDoc     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE Recibe el c�digo de tipo de documento.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE                  Retorna el valor total facturado.  
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 29-08-2022 
  */    
FUNCTION F_GET_DCTO_FACTURADO_SERVICIO(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                       Fn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Fv_TipoDoc     IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
    RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;


  /**
  * Documentaci�n para la funci�n 'F_GET_NUM_TAREAS'.
  *
  * Funci�n que permite obtener el n�mero de tareas asociadas al punto enviado como par�metro.
  * @param  Fn_IdPunto         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                             Recibe el id del punto.
  * @param  Fv_NombreTarea     DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE                           Recibe el nombre de la tarea.
  * @param  Fv_PrefijoEmpresa  DB_COMERCIAL.INFO_EMPRESA_GRUPO%TYPE                              Recibe el prefijo.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE                Retorna el valor total facturado.
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-10-2018
  */  

FUNCTION F_GET_NUM_TAREAS(Fn_PuntoId        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                          Fv_NombreTarea    IN DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE,
                          Fv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
  RETURN NUMBER;

  /**
  * Documentaci�n para la funci�n 'F_GET_TIPOMEDIO'.
  *
  * Funci�n que permite obtener el tipo medio.
  * @param  Fn_ServicioId DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE  Recibe el id del servicio.
  * @param  Fv_Estado     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE        Recibe el estado del servicio.
  * @return VARCHAR2
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-10-2018
  *
  * Se modifica la funci�n para traer los tipo de medio para el proceso de Cambio de forma de pago, 
  * Filtrando por el punto, se agrega como par�metro id del punto.
  * @param  Fn_IdPunto         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  Recibe el id del punto.
  * @author Josselhin Moreira Q. <kjmoreira@telconet.ec>
  * @version 1.1 27-09-2019
  */  
  FUNCTION F_GET_TIPOMEDIO(Fn_ServicioId DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL,
                           Fv_Estado     DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                           Fn_IdPunto    DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE DEFAULT NULL)
    RETURN VARCHAR2;
  /**
  * Documentaci�n para la funci�n F_GET_SERVICIOS_BY_PTO.
  * Funci�n que retorna los servicios seg�n los criterios enviados como Par�metro.
  *
  * @param  Fn_PuntoId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE      Recibe el id del punto.
  * @param  Fv_Codigo  IN DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO Recibe el codigo del producto.
  * @param  Fv_Estado  IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE     Recibe el estado del servicio.
  * @return SYS_REFCURSOR                Retorna los servicios con los criterios enviados como Parametros..
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-10-2018
  */
  FUNCTION F_GET_SERVICIOS_BY_PTO(Fn_PuntoId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                  Fv_Codigo  IN DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE,
                                  Fv_Estado  IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    RETURN SYS_REFCURSOR;

  /**
  * Documentaci�n para la funci�n F_GET_TOTAL_FACT_INST.
  * Funci�n que retorna el total facturado por instalaci�n.
  *
  * @param  Fn_PuntoId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  Recibe el id del punto.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE   Retorna el total facturado.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-10-2018
  *
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.1 26-08-2019 Se resta valor de descuento al valor total para obtener el valor con el descuento.
  */
FUNCTION F_GET_TOTAL_FACT_INST(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;


  /**
  * Documentaci�n para la funci�n F_GET_TOTAL_NC_FACT_INST.
  * Funci�n que retorna el valor total de las notas de cr�dito aplicados a la factura de instalaci�n.
  *
  * @param  Fn_PuntoId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  Recibe el id del punto.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE   Retorna el total facturado.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-08-2019
  */
FUNCTION F_GET_TOTAL_NC_FACT_INST(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE; 

  /**
  * Documentaci�n para la funci�n F_GET_TOTAL_FACT_PRO
  * Funcion que retorna el total facturado por instalaci�n.
  *
  * @param  Fv_CodProducto DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE  Recibe el c�digo de producto.
  * @param  Fn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  Recibe el id del punto.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE   Retorna el total facturado del producto enviado como par�metro.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 26-10-2018
  * 
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.1 20-12-2022 Se elimina como par�metro el id punto y se agrega el id servicio.
  */
FUNCTION F_GET_TOTAL_FACT_PRO(Fv_CodProducto    DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE,
                              Fn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;

/**
  * Documentaci�n para la funci�n 'F_GET_PERMANENCIA_VIGENTE'
  *
  * Funci�n que permite obtener la permanencia m�nima desde la fecha de activaci�n del servicio y del contrato.
  * @param  Fv_EmpresaCod   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  recibe el c�digo de la empresa.
  * @param  Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE             recibe el id del punto.
  * @return NUMBER  
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.0 18-06-2019
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.1 08-01-2020 Se elimina como par�metro el id del contrato.
  */    
  FUNCTION F_GET_PERMANENCIA_VIGENTE (Fv_EmpresaCod   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN NUMBER;

  /**
  * Documentaci�n para la funcion F_GET_FE_ACT_INT.
  * Funci�n que retorna la fecha de activaci�n del servicio de Internet.
  *
  * @param  Fn_PuntoId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE  Recibe el id del punto.
  * @return VARCHAR2   Retorna la fecha de activaci�n en formato DD-MM-YYYY.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 28-11-2018
  *    
  * Se modifican condiciones de b�squeda en el historial del servicio.
  * Se inserta la acci�n 'CONFIRMARCANCELACIONVOLUN' en la b�squeda de la activaci�n del sercicio.
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.1 03-07-2019
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.1 03-03-2021 Se agrega observaci�n por CRS para servicios antiguos
  *
  */
FUNCTION F_GET_FE_ACT_INT(Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2;

/**
  * Documentaci�n para la funci�n 'F_GET_CANCEL_VOL_INST_AMORT'.
  *
  * Funci�n que permite obtener la permanencia el valor de la instalaci�n desde la evaluaci�n de la f�rmula de amortizaci�n.
  * @param  Fv_EmpresaCod   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  recibe el c�digo de la empresa.
  * @param  Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE             recibe el id del punto.
  * @param  Pn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE  recibe el id del servicio.
  * @return NUMBER
  *
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.0 21-06-2019
  *
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.1 08-01-2020 Se reversa como par�metro el id del contrato
  */

FUNCTION F_GET_CANCEL_VOL_INST_AMORT (Fv_EmpresaCod   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Fn_IdServicio   IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    RETURN NUMBER;  

  /**
  * Documentaci�n para la funci�n 'F_GET_FECHA_CONTRATO'
  *
  * Funci�n que permite obtener la fecha de creaci�n del contrato.
  * @param  Fn_IdContrato   IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE recibe el id del contrato.
  * @return VARCHAR2
  *
  * @author Josselhin Moreira <kjmoreira@telconet.ec>
  * @version 1.0 27-06-2019
  */    
    FUNCTION F_GET_FECHA_CONTRATO(Fn_IdContrato   IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
      RETURN VARCHAR2;


/**
  * Documentacion para la funci�n 'F_GET_TIPO_CUENTA_SELEC'.
  *
  * Funci�n que obtiene la forma de pago y el tipo de cuenta seleccionados desde el formulario.
  *    
  * @param   Fn_IdFormaPago     IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE    recibe el id de la forma de pago.
  * @param   Fn_IdTipoCuenta    IN  DB_GENERAL.ADMI_TIPO_CUENTA.ID_TIPO_CUENTA%TYPE  recibe el id del tipo de cuenta.
  * @return  VARCHAR2
  *
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.0 12-07-2019
  */ 
FUNCTION F_GET_TIPO_CUENTA_SELEC(Fn_IdFormaPago  IN DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
                                 Fn_IdTipoCuenta IN DB_GENERAL.ADMI_TIPO_CUENTA.ID_TIPO_CUENTA%TYPE)
  RETURN VARCHAR2;    

  /**
  * Documentaci�n para la funci�n 'F_GET_FORMA_PAGO_ACT'.
  *
  * Funci�n que permite obtener la forma de pago actual del punto para el proceso de Cambio de Forma de Pago.
  * @param  Fn_IdContrato   IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE       recibe el id del contrato.
  * @return VARCHAR2
  *
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.0 10-07-2019
  */ 
  FUNCTION F_GET_FORMA_PAGO_ACT (Fn_IdContrato   IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
    RETURN VARCHAR2;      

  /**
  * Documentaci�n para la funci�n 'F_GET_FORMA_PAGO_HIST'.
  *
  * Funci�n que obtiene la forma de pago  del historial del punto y si esta gener� o no factura.
  * @param  Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE    recibe el id del punto.
  * @return VARCHAR2
  *
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.0 10-07-2019
  */ 
  FUNCTION F_GET_FORMA_PAGO_HIST (Fn_IdPunto   IN   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN VARCHAR2;  

/**
  * Documentaci�n para la funci�n 'F_GET_BASE_INSTALACION_FP'.
  *
  * Funci�n que permite obtener la base monetaria de la instalaci�n a amortizar 
  * seg�n la forma de pago Actual y la seleccionada por parte del cliente.  
  * @param  Fv_TipoFormaPagoSelec   IN  DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE  recibe la forma de pago seleccionada.
  * @param  Fn_IdContrato           IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE             recibe el id del contrato.
  * @return NUMBER
  *
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.0 10-07-2019
  */ 
FUNCTION F_GET_BASE_INSTALACION_FP(Fv_TipoFormaPagoSelec   IN  DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,                                   
                                   Fn_IdContrato           IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                   Fn_IdPunto              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
RETURN NUMBER;

/**
  * Documentaci�n para el procedimiento 'P_GET_FACT_PROM_MENSUALES'
  *
  * Procedimiento que permite obtener el valor total del descuento realizado a las facturas mensuales.
  * @param  Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE    recibe el id del punto.
  * @return NUMBER
  *
  * @author Madeline Haz <mhaz@telconet.ec>
  * @version 1.0 09-07-2019
  */ 


PROCEDURE P_GET_FACT_PROM_MENSUALES (Pn_IdPunto       IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,                                                                          
                                     Prf_Result       OUT Lrf_Result)  ;
  /**
  * Documentaci�n para el procedimiento P_RPT_CANC_NOFACTURADAS
  * Procedimiento que realiza el env�o del reporte de cancelaciones no facturadas.
  *
  * @param  Pv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE  Recibe el prefijo empresa.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 27-11-2018
  */

PROCEDURE P_RPT_CANC_NOFACTURADAS(Pv_PrefijoEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE);

  /**
  * Documentaci�n para el procedimiento P_GET_FACTURAS_BY_PTOCARACTID
  * Procedimiento que retorna el listado de facturas asocidas al punto enviado como par�metro.
  * Costo de query: 42
  *
  * @param  Pn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                              Recibe el id del punto.
  * @param  Pn_CaracteristicaId  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE  Recibe el id de la caracter�stica a consultar.
  * @param  Prf_Facturas                                                                  Cursor de salida.
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 06-09-2019
  */

  PROCEDURE P_GET_FACTURAS_BY_PTOCARACTID(
      Pn_PuntoId           IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Pn_CaracteristicaId  IN  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
      Prf_Facturas         OUT SYS_REFCURSOR);          

   /**
    * Documentaci�n para TYPE 'T_ValorTotal'.
    * Record para almacenar la data enviada al BULK.
    * @author Hector Lozano <hlozano@telconet.ec>
    * @version 1.0 01-12-2020
    */
    TYPE T_ValorTotal IS TABLE OF DB_FINANCIERO.FNKG_TYPES.Lr_ValorTotal INDEX BY PLS_INTEGER;  

   /**
    * Documentaci�n para la funci�n 'F_GET_DESC_INST_PROMO'.
    *
    * Funci�n que permite obtener el valor promocional por instalaci�n del servicio enviado como par�metro.
    * @param  Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  recibe el c�digo de la empresa.
    * @param  Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE             recibe el id del punto.
    * @param  Fn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE        recibe el id del servicio.
    * @param  Fv_DescProducto       IN VARCHAR2                                           recibe la descripcion del producto.
    * @param  Fn_IdContrato         IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE        recibe el id del contrato.
    * @return NUMBER  
    *
    * @author Hector Lozano <hlozano@telconet.ec>
    * @version 1.0 01-12-2020
    *
    * @author Edgar Holgu�n <eholguin@telconet.ec>
    * @version 1.1 25-02-2021 Se agrega b�squeda de id de servicio facturado por instalaci�n para c�lculo de porcentaje de descuento.
    *
    * @author Hector Lozano <hlozano@telconet.ec>
    * @version 1.2 5-09-2022 Se agrega parametro de descripcion de producto.
    */
    FUNCTION F_GET_DESC_INST_PROMO (Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                    Fn_IdServicio         IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Fv_DescProducto       IN  VARCHAR2,
                                    Fn_IdContrato         IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
    RETURN NUMBER; 


  /**
  * Documentaci�n para la funcion F_GET_SERVICIO_ID_FACT_INST
  * Costo 177
  * La funcion retorna el id servicio de la factura de instalaci�n .
  *
  * @param Fn_PuntoId  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE
  * 
  * @author Edgar Holgu�n <eholguin@telconet.ec>
  * @version 1.0 25-02-2021 
  */

    FUNCTION F_GET_SERVICIO_ID_FACT_INST(Pn_PuntoId DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE)
    RETURN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;



  /**
  * Documentaci�n para la funci�n 'F_GET_DCTO_BY_PRODUCTO'.
  * Costo: 45
  * Funci�n que permite obtener el total de descuentos facturados del producto enviado como par�metro en el punto.
  * @param  Fn_IdPunto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                  Recibe el id del punto.
  * @param  Fv_CodigoProducto   DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO %TYPE       Recibe el c�digo del producto.
  * @param  Fv_TipoDoc          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE  Recibe el c�digo del tipo de documento.
  * @return DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE      Retorna el valor total facturado.  
  * @author Edgar Holguin <eholguin@telconet.ec>
  * @version 1.0 03-03-2021
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.1 29-08-2022 Se agrega parametro Fn_IdServicio,para obtener el total de descuentos facturados del punto y id_servicio enviado como par�metro.
  */    
FUNCTION F_GET_DCTO_BY_PRODUCTO(Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                Fn_IdServicio        IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Fv_CodigoProducto    IN DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE,
                                Fv_TipoDoc           IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;

  /**
  * Documentacion para la funcion F_GET_ID_PTO_TRASLADADO
  *
  * Funci�n que retorna el id del punto trasladado con respecto al id de servicio activo enviado como par�metro.
  *
  * @param Fn_ServicioId            IN _COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * return Fn_PuntoId               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  * 
  * @author Edgar Holgu�n <eholgu�n@telconet.ec>
  * @version 1.0 19-03-2021 
  */
  FUNCTION F_GET_ID_PTO_TRASLADADO(
      Fn_ServicioId         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;

  /**
  * Documentacion para procedimiento P_SPLIT
  *
  * Procedimiento que permite dividir una cadena en subcadenas seg�n el caracter delimitador enviado como par�metro. 
  *
  * @param Pv_Cadena 
  * @param Pv_Caracter                       
  * return Pr_Arreglo               
  * 
  * @author Edgar Holgu�n <eholgu�n@telconet.ec>
  * @version 1.0 06-12-2021 
  */
  PROCEDURE P_SPLIT(
    Pv_Cadena   IN VARCHAR2,
    Pv_Caracter IN VARCHAR2,
    Pr_Arreglo  OUT TypeArreglo
  );

END FNCK_CANCELACION_VOL;
/

CREATE EDITIONABLE PACKAGE BODY               FNCK_CANCELACION_VOL AS

  ACTIVO  CONSTANT VARCHAR2(6):= 'Activo';

  PROCEDURE P_GET_VALORES_FACT (Pv_EmpresaCod        IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                                Pn_IdPtoFacturacion  IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, 
                                Pn_IdServicio        IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Pv_DescProducto      IN  VARCHAR2, 
                                Pn_ValorDcto         OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE,
                                Pn_ValorInstalacion  OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE,
                                Pn_NetlifeCloud      OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE,
                                Pn_NetlifeAssistance OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE,
                                Pn_ElCanalDelFutbol  OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE) IS

    -- Costo Query: 3
    CURSOR C_GET_PARAMETROS(Cv_EmpresaCod VARCHAR2, Cv_NombreParametro VARCHAR2, Cv_Modulo VARCHAR2, Cv_Estado VARCHAR2, Cv_Valor VARCHAR2) IS
      SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           =  Cv_Estado
      AND DET.ESTADO           =  Cv_Estado
      AND CAB.MODULO           =  Cv_Modulo
      AND DET.VALOR1           =  Cv_Valor
      AND DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

  --Cursor que sirve para  obtener para obtener las caracter�sticas seg�n los filtros enviados como par�metro.
    CURSOR C_GET_PARAM(Cv_EmpresaCod VARCHAR2, Cv_NombreParametro VARCHAR2, Cv_Modulo VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM   DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO     =  DET.PARAMETRO_ID
      AND   CAB.ESTADO           =  Cv_Estado
      AND   DET.ESTADO           =  Cv_Estado
      AND   CAB.MODULO           =  Cv_Modulo
      AND   DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND   CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;


    CURSOR C_GET_SERV_NETLASSI(Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) IS
      SELECT  ISE.ID_SERVICIO 
      FROM DB_COMERCIAL.INFO_SERVICIO ISE
      JOIN DB_COMERCIAL.ADMI_PRODUCTO AP   ON AP.ID_PRODUCTO  = ISE.PRODUCTO_ID
      WHERE AP.CODIGO_PRODUCTO = 'ASSI'
      AND   ISE.ID_SERVICIO = Cn_IdServicio
      AND   ISE.ESTADO      = 'Activo'
      AND   AP.ESTADO       = 'Activo';

    -- NetlifeCloud
    CURSOR C_GET_SERV_NETLF_FACTURAR(Cn_IdServicio          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Cv_CodEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Cv_DescripcionProducto DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE, 
                                     Cv_EstadoServicio      DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                     Cv_AccionHistRen       DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE,
                                     Cv_AccionHistAct       DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE) IS
        SELECT ISE.ID_SERVICIO,
               ISE.PRODUCTO_ID,
               ISE.PLAN_ID,
               ISE.PUNTO_ID,
               ISE.CANTIDAD,
               TRUNC(ISE.PRECIO_VENTA,2) AS PRECIO_VENTA,
               NVL(ISE.PORCENTAJE_DESCUENTO,0) AS  PORCENTAJE_DESCUENTO, 
               NVL(ISE.VALOR_DESCUENTO,0) AS  VALOR_DESCUENTO, 
               ISE.PUNTO_FACTURACION_ID, 
               ISE.ESTADO,
               ISH.FE_CREACION
           FROM DB_COMERCIAL.INFO_SERVICIO            ISE
           JOIN DB_COMERCIAL.ADMI_PRODUCTO            PRO  ON PRO.ID_PRODUCTO     = ISE.PRODUCTO_ID
           JOIN DB_COMERCIAL.INFO_PUNTO               PTO  ON PTO.ID_PUNTO        = ISE.PUNTO_ID
           JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
           JOIN DB_COMERCIAL.INFO_EMPRESA_ROL         IER  ON IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID 
           JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO       IEG  ON IEG.COD_EMPRESA     = IER.EMPRESA_COD
           JOIN DB_COMERCIAL.INFO_PERSONA             PERS ON PERS.ID_PERSONA     = IPER.PERSONA_ID 
           JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL  ISH  ON ISE.ID_SERVICIO     = ISH.SERVICIO_ID
           WHERE PRO.DESCRIPCION_PRODUCTO = Cv_DescripcionProducto
           AND ISE.ID_SERVICIO            = Cn_IdServicio
           AND ISE.ESTADO                 = Cv_EstadoServicio
           AND IEG.COD_EMPRESA            = Cv_CodEmpresa
        AND (ISH.ID_SERVICIO_HISTORIAL = (

                                           SELECT MAX(ISHS.ID_SERVICIO_HISTORIAL) 
                                           FROM   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISHS 
                                           WHERE  ISHS.ACCION      = Cv_AccionHistRen 
                                           AND    ISHS.SERVICIO_ID = ISE.ID_SERVICIO

                                         )
        OR ISH.ID_SERVICIO_HISTORIAL =   (
                                           SELECT MAX(ISHS.ID_SERVICIO_HISTORIAL) 
                                           FROM   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISHS 
                                           WHERE  ISHS.ACCION      = Cv_AccionHistAct 
                                           AND    ISHS.SERVICIO_ID = ISE.ID_SERVICIO
                                         )      
        AND NOT EXISTS (SELECT IH.* FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL IH 
                        WHERE  IH.SERVICIO_ID = ISE.ID_SERVICIO 
                        AND    IH.ACCION      = Cv_AccionHistRen ));

    -- Cursor que obtiene el id de Contrato, por medio de estados parametrizados 'DEBITOS_ESTADOS_CONTRATO'.
    -- Costo Query: 12
    CURSOR C_GET_CONTRATO(Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
      SELECT MAX(IC.ID_CONTRATO) AS ID_CONTRATO
        FROM DB_COMERCIAL.INFO_PUNTO IP,
             DB_COMERCIAL.INFO_CONTRATO IC
      WHERE IP.PERSONA_EMPRESA_ROL_ID = IC.PERSONA_EMPRESA_ROL_ID
        AND IP.ID_PUNTO               = Cn_PuntoId
        AND IC.ESTADO                 NOT IN (SELECT APD.VALOR1
                                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                                  DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                                AND APC.ESTADO           = 'Activo'
                                                AND APD.ESTADO           = 'Activo'
                                                AND APC.NOMBRE_PARAMETRO = 'DEBITOS_ESTADOS_CONTRATO');

    -- CURSOR EL CANAL DEL FUTBOL Obtiene fecha de activacion y valor del producto
    CURSOR C_GET_SERV_ECDF_FACT(     Cn_IdServicio          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Cv_CodEmpresa          DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Cv_NombreTecnicoProd   DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE, 
                                     Cv_EstadoServicio      DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                     Cv_DescripcionCaract   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE) IS
    SELECT ISE.ID_SERVICIO,
               ISE.PRODUCTO_ID,
               ISE.PLAN_ID,
               ISE.PUNTO_ID,
               ISE.CANTIDAD,
               TRUNC(ISE.PRECIO_VENTA,2) AS PRECIO_VENTA,
               NVL(ISE.PORCENTAJE_DESCUENTO,0) AS  PORCENTAJE_DESCUENTO, 
               NVL(ISE.VALOR_DESCUENTO,0) AS  VALOR_DESCUENTO, 
               ISE.PUNTO_FACTURACION_ID, 
               ISE.ESTADO,
               ISPC.VALOR AS FECHA_ACTIVACION
           FROM DB_COMERCIAL.INFO_SERVICIO                  ISE
           JOIN DB_COMERCIAL.ADMI_PRODUCTO                  PRO  ON PRO.ID_PRODUCTO     = ISE.PRODUCTO_ID
           JOIN DB_COMERCIAL.INFO_PUNTO                     PTO  ON PTO.ID_PUNTO        = ISE.PUNTO_ID
           JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL       IPER ON IPER.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
           JOIN DB_COMERCIAL.INFO_EMPRESA_ROL               IER  ON IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID 
           JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO             IEG  ON IEG.COD_EMPRESA     = IER.EMPRESA_COD
           JOIN DB_COMERCIAL.INFO_PERSONA                   PERS ON PERS.ID_PERSONA     = IPER.PERSONA_ID 
           JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT      ISPC ON ISE.ID_SERVICIO     =   ISPC.SERVICIO_ID
           JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA   APC ON ISPC.PRODUCTO_CARACTERISITICA_ID   =   APC.ID_PRODUCTO_CARACTERISITICA
           JOIN DB_COMERCIAL.ADMI_CARACTERISTICA            AC ON APC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
           WHERE AC.DESCRIPCION_CARACTERISTICA = Cv_DescripcionCaract
           AND PRO.NOMBRE_TECNICO         = Cv_NombreTecnicoProd
           AND ISE.ID_SERVICIO            = Cn_IdServicio
           AND ISE.ESTADO                 = Cv_EstadoServicio
           AND IEG.COD_EMPRESA            = Cv_CodEmpresa;

    --CURSOR PARAMETRO DE MESES DE SUSCRIPCION PARA EL PRODUCTO ECDF
    CURSOR C_GET_PARAM_MESES_ECDF (Cv_Estado VARCHAR2,
                                   Cv_Modulo VARCHAR2,  
                                   Cv_EmpresaCod VARCHAR2,
                                   Cv_NombreParametro VARCHAR2,
                                   Cv_DescripcionDet VARCHAR2) IS
    SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM   DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
             DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO     =  DET.PARAMETRO_ID
      AND   DET.DESCRIPCION      =  Cv_DescripcionDet
      AND   DET.VALOR1           = 'ECDF'
      AND   CAB.ESTADO           =  Cv_Estado
      AND   DET.ESTADO           =  Cv_Estado
      AND   CAB.MODULO           =  Cv_Modulo
      AND   DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND   CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

    --CURSOR TRAE VALOR FACTURADO POR SERVICIO
    CURSOR C_GET_VALOR_FACT_SERVICIO ( Cv_FeActivacion DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE,
                                       Cv_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Cv_DescripcionProd   DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE) IS
        SELECT ROUND(SUM(NVL(IDFD.VALOR_FACPRO_DETALLE * IDFD.CANTIDAD,0)),2) AS VALOR
              FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC
              JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET  IDFD  ON IDFC.ID_DOCUMENTO      = IDFD.DOCUMENTO_ID
              JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID 
              JOIN DB_COMERCIAL.ADMI_PRODUCTO  AP                    ON AP.ID_PRODUCTO         = IDFD.PRODUCTO_ID
              WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP') 
              AND   AP.DESCRIPCION_PRODUCTO    =  Cv_DescripcionProd
              AND IDFD.SERVICIO_ID = Cv_IdServicio
              AND   IDFC.FE_CREACION           >= Cv_FeActivacion;

    --CURSOR OBTIENE ID DE SERVICIO DE INTERNET
    CURSOR C_GET_ID_SERV_INT (Cn_PuntoId  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT DISTINCT(STE.SERVICIO_ID)
    FROM  DB_COMERCIAL.INFO_SERVICIO S,
          DB_COMERCIAL.INFO_PLAN_DET PD,
          DB_COMERCIAL.ADMI_PRODUCTO P,
          DB_COMERCIAL.INFO_SERVICIO_TECNICO STE,
          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH        
    WHERE S.PLAN_ID      = PD.PLAN_ID
    AND PD.PRODUCTO_ID   = P.ID_PRODUCTO
    AND STE.SERVICIO_ID  = S.ID_SERVICIO
    AND S.ID_SERVICIO    = ISH.SERVICIO_ID
    AND P.NOMBRE_TECNICO = 'INTERNET'
    AND ISH.ESTADO       = 'Activo'
    AND S.PUNTO_ID       = Cn_PuntoId; 

    /* Variables locales */
    Lc_ParametroInst              C_GET_PARAMETROS%ROWTYPE;
    Lc_ParamNetlifeAssistance     C_GET_PARAMETROS%ROWTYPE;
    Lc_ServicioNetlifeCloud       C_GET_SERV_NETLF_FACTURAR%ROWTYPE;
    Lc_ServicioNetlfAssistance    C_GET_SERV_NETLASSI%ROWTYPE;
    type Lt_ServicioEcdfType 	  is table of C_GET_SERV_ECDF_FACT%ROWTYPE;
    Lc_ServicioElCanalDelFutbol   Lt_ServicioEcdfType;

    Lc_ParametrosCm               C_GET_PARAM%ROWTYPE;
    Lc_ParamMesesSuscripcionECDF  C_GET_PARAM_MESES_ECDF%ROWTYPE;
    Lc_GetValorFactxServicio      C_GET_VALOR_FACT_SERVICIO%ROWTYPE;
    Lv_EstadoActivo               DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                                     := 'Activo';
    Lv_ModuloFinanciero           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE                                     := 'FINANCIERO';
    Lv_ModuloComercial            DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE                                     := 'COMERCIAL';
    Lv_ModuloTecnico              DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE                                     := 'TECNICO';
    Lv_EstadoCerrado              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE        := 'Cerrado';
    Lv_TareaNetlAssistance        DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE                                       := 'NETLIFE ASSISTANCE';
    Lv_DescripcionProducto        DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE                          := 'NetlifeCloud';
    Lv_DescProdNtlAssistance      DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE                          := 'NetlifeAssistance';
    Lv_DescripcionProductoECDF    DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE                          := 'El Canal Del F�tbol';
    Lv_NombreTecnicoProdECDF      DB_COMERCIAL.ADMI_PRODUCTO.NOMBRE_TECNICO%TYPE                                := 'ECDF';
    Lv_DescripcionCaractECDF      DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE              := 'FECHA_ACTIVACION';
    Lv_NombreParamFechaMinima     DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                           := 'PRODUCTO_FECHA_MINIMA_SUSCRIPCION';
    Lv_DescripcionDetMeses        DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE                                := 'MESES_MINIMOS';

    Lv_AccionHistActivacion       DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE                              := 'confirmarServicio';
    Lv_AccionHistRenovacion       DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ACCION%TYPE                              := 'renovarLicenciaOffice365';
    Lv_ParametroInstalacion       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                           := 'PROM_PRECIO_INSTALACION';
    Lv_ParamCancelVoluntaria      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                           := 'CANCELACION VOLUNTARIA';
    Lv_ParametroPeriodoRenovacion DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE                           := 'PERIODO_RENOVAR_LICOFFICE365';
    Lv_ParamNetlifeAssistance     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                                     := 'NETLIFFEASSISTANCE';
    Lv_TipoMedio                  DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                                     ;
    Ln_ValorNetlifeAssistance     DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE                                     ;
    Ln_ValorParametroInst         DB_GENERAL.ADMI_PARAMETRO_DET.VALOR3%TYPE                                     ;    
    Ln_ValorFacturadoInst         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE  := 0;
    Ln_ValorNetlifeCloudFact      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE  := 0;
    Ln_ValorEcdfFact              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE  := 0;
    Pn_AcumuladorEcdfEnTiempo     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE         := 0;
    Lv_CountRow                   PLS_INTEGER;
    Ln_ValorNetlifeAssistanceFact DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRECIO_VENTA_FACPRO_DETALLE%TYPE  := 0;
    Ln_NumMesesRestantesFacturar  NUMBER := 0;
    Ln_NumMesesTotal              NUMBER := 0;
    Ln_NumMesesActivo             NUMBER := 0;
    Ln_NumTareasNetlifeAssintance NUMBER := 0;
    Ln_ValorInstOrig              NUMBER := 0;
    Lc_GetContrato                C_GET_CONTRATO%ROWTYPE;
    Ln_IdPuntoTrasladado          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                                   := NULL;  
    Ln_IdPtoOrigen                DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE                                   := NULL;
    Ln_IdServIntOrigen            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE                             := NULL;
    Lv_TipoOrigenPto              VARCHAR2(100)                                                           := NULL; 
    Lv_TipoOrigen                 VARCHAR2(100)                                                           := NULL; 
    Lr_Arreglo                    TypeArreglo;
    Ln_ValorDctoTraslado          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE   := 0;
    Lv_TipoDocFac                 DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'FAC';
    Lv_TipoDocProp                DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE := 'FACP'; 

  BEGIN

    Pn_ValorDcto         := 0;
    Pn_ValorInstalacion  := 0;
    Pn_NetlifeCloud      := 0;
    Pn_NetlifeAssistance := 0;
    Pn_ElCanalDelFutbol  := 0;
    --
--mhaz
    Pn_ValorDcto := NVL(FNCK_CANCELACION_VOL.F_GET_DCTO_FACTURADO_SERVICIO(Pn_IdPtoFacturacion,Pn_IdServicio,Lv_TipoDocFac),0);

    Ln_IdPuntoTrasladado :=  FNCK_CANCELACION_VOL.F_GET_ID_PTO_TRASLADADO(Pn_IdServicio);

    IF Ln_IdPuntoTrasladado IS NOT NULL THEN
      Ln_ValorDctoTraslado := NVL(FNCK_CANCELACION_VOL.F_GET_DCTO_FACTURADO_SERVICIO(Ln_IdPuntoTrasladado,Pn_IdServicio,Lv_TipoDocFac),0) ;
      IF Ln_ValorDctoTraslado IS NOT NULL  AND Ln_ValorDctoTraslado > 0 THEN
        Pn_ValorDcto := Pn_ValorDcto + Ln_ValorDctoTraslado;
      END IF;
    END IF;

    Lv_TipoOrigenPto := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_ORIGEN_TRASL_CRS(Pn_IdPtoFacturacion);

    P_SPLIT(Lv_TipoOrigenPto,'|',Lr_Arreglo);
    Lv_TipoOrigen             :=  Lr_Arreglo(0);
    Ln_IdPtoOrigen            :=  TO_NUMBER(Lr_Arreglo(1));     

    Lv_TipoMedio := F_GET_TIPOMEDIO(Pn_IdServicio,Lv_EstadoActivo,NULL);

    IF C_GET_PARAMETROS%ISOPEN THEN
      CLOSE C_GET_PARAMETROS;
    END IF;

    OPEN C_GET_PARAMETROS(Pv_EmpresaCod,Lv_ParametroInstalacion,Lv_ModuloFinanciero,Lv_EstadoActivo,Lv_TipoMedio);
     FETCH C_GET_PARAMETROS
       INTO Lc_ParametroInst;
    CLOSE C_GET_PARAMETROS;

    Ln_ValorParametroInst := NVL(Lc_ParametroInst.VALOR3,0);

    IF C_GET_PARAMETROS%ISOPEN THEN
      CLOSE C_GET_PARAMETROS;
    END IF;

    OPEN C_GET_PARAMETROS(Pv_EmpresaCod,Lv_ParamCancelVoluntaria,Lv_ModuloFinanciero,Lv_EstadoActivo,Lv_ParamNetlifeAssistance);
     FETCH C_GET_PARAMETROS
       INTO Lc_ParamNetlifeAssistance;
    CLOSE C_GET_PARAMETROS;

    Ln_ValorNetlifeAssistance := NVL(Lc_ParamNetlifeAssistance.VALOR2,0);

    -- Instalacion
    Ln_ValorFacturadoInst := NVL(F_GET_TOTAL_FACT_INST(Pn_IdPtoFacturacion),0);  

    IF C_GET_CONTRATO%ISOPEN THEN
      CLOSE C_GET_CONTRATO;
    END IF;

    OPEN C_GET_CONTRATO(Pn_IdPtoFacturacion);
      FETCH C_GET_CONTRATO INTO Lc_GetContrato;
    CLOSE C_GET_CONTRATO;

    IF Lc_GetContrato.ID_CONTRATO IS NOT NULL THEN     
    -- 
      Pn_ValorInstalacion:= NVL(DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_DESC_INST_PROMO(Pv_EmpresaCod, Pn_IdPtoFacturacion,
                                                                                         Pn_IdServicio, Pv_DescProducto, Lc_GetContrato.ID_CONTRATO),0); 
      IF Lv_TipoOrigen = 'CRS' OR  Lv_TipoOrigen = 'Traslado' THEN

        -- Se obtiene id del servicio de internet del punto origen.
        IF C_GET_ID_SERV_INT%ISOPEN THEN
          CLOSE C_GET_ID_SERV_INT;
        END IF;

        OPEN C_GET_ID_SERV_INT(Ln_IdPtoOrigen);
         FETCH C_GET_ID_SERV_INT
         INTO  Ln_IdServIntOrigen;
        CLOSE C_GET_ID_SERV_INT; 
        DBMS_OUTPUT.PUT_LINE('ID  SERVICIO ORIG ' || Ln_IdServIntOrigen);
        Ln_ValorInstOrig:= NVL(DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_DESC_INST_PROMO(Pv_EmpresaCod, Ln_IdPtoOrigen,
                                                                                        Ln_IdServIntOrigen, Pv_DescProducto, Lc_GetContrato.ID_CONTRATO),0); 

        IF Ln_ValorInstOrig > 0 THEN
          Pn_ValorInstalacion:=  Pn_ValorInstalacion + Ln_ValorInstOrig;
        END IF;

      END IF;    
    --  
    END IF;

     -- NetlifeAssistance

    Ln_ValorNetlifeAssistanceFact := NVL(FNCK_CANCELACION_VOL.F_GET_TOTAL_FACT_PRO('ASSI',Pn_IdServicio),0);

    -- NetlifeCloud

    IF C_GET_SERV_NETLF_FACTURAR%ISOPEN THEN
      CLOSE C_GET_SERV_NETLF_FACTURAR;
    END IF;

    OPEN C_GET_SERV_NETLF_FACTURAR(Pn_IdServicio,
                                   Pv_EmpresaCod,
                                   Lv_DescripcionProducto,
                                   Lv_EstadoActivo,
                                   Lv_AccionHistRenovacion,
                                   Lv_AccionHistActivacion);
    FETCH C_GET_SERV_NETLF_FACTURAR
      INTO Lc_ServicioNetlifeCloud;
    CLOSE C_GET_SERV_NETLF_FACTURAR;


    IF Lc_ServicioNetlifeCloud.ID_SERVICIO > 0 THEN


      IF C_GET_PARAM%ISOPEN THEN
        CLOSE C_GET_PARAM;
      END IF;

      OPEN C_GET_PARAM(Pv_EmpresaCod,Lv_ParametroPeriodoRenovacion,Lv_ModuloComercial,Lv_EstadoActivo);
       FETCH C_GET_PARAM
       INTO  Lc_ParametrosCm;
      CLOSE C_GET_PARAM;

      Ln_NumMesesTotal := NVL(Lc_ParametrosCm.VALOR1,0);

      SELECT ROUND(MONTHS_BETWEEN(SYSDATE,Lc_ServicioNetlifeCloud.FE_CREACION),1)
      INTO Ln_NumMesesActivo
      FROM DUAL;

      IF Ln_NumMesesActivo < Ln_NumMesesTotal THEN
      -- OBTENGO MESES RESTANTES A FACTURAR
        Ln_NumMesesRestantesFacturar := Ln_NumMesesTotal - Ln_NumMesesActivo;
        Ln_NumMesesRestantesFacturar := ROUND(Ln_NumMesesRestantesFacturar,0);

        Ln_ValorNetlifeCloudFact := F_GET_TOTAL_FACTURADO(Lv_DescripcionProducto,Lc_ServicioNetlifeCloud.ID_SERVICIO,Lc_ServicioNetlifeCloud.FE_CREACION);

        Pn_NetlifeCloud:= ROUND((NVL(Lc_ServicioNetlifeCloud.cantidad,0) * NVL(Lc_ServicioNetlifeCloud.precio_venta,0)*Ln_NumMesesTotal),2)-ROUND((NVL(Ln_ValorNetlifeCloudFact,0)),2);

      END IF;
    --
    ELSE 

     Pn_NetlifeCloud:= 0;

    END IF;
    --
    -- EL CANAL DEL FUTBOL

    IF C_GET_SERV_ECDF_FACT%ISOPEN THEN
      CLOSE C_GET_SERV_ECDF_FACT;
    END IF;

    OPEN C_GET_SERV_ECDF_FACT(Pn_IdServicio,
                              Pv_EmpresaCod,
                              Lv_NombreTecnicoProdECDF,
                              Lv_EstadoActivo,
                              Lv_DescripcionCaractECDF);
    FETCH C_GET_SERV_ECDF_FACT BULK COLLECT INTO Lc_ServicioElCanalDelFutbol LIMIT 20;
    Lv_CountRow := Lc_ServicioElCanalDelFutbol.FIRST;

    WHILE (Lv_CountRow IS NOT NULL)
    LOOP                          
        IF Lc_ServicioElCanalDelFutbol(Lv_CountRow).ID_SERVICIO > 0 THEN

          IF C_GET_VALOR_FACT_SERVICIO%ISOPEN THEN
            CLOSE C_GET_VALOR_FACT_SERVICIO;
          END IF;

          OPEN C_GET_VALOR_FACT_SERVICIO(TO_DATE(Lc_ServicioElCanalDelFutbol(Lv_CountRow).FECHA_ACTIVACION, 'YYYY-MM-DD HH24:MI:SS'),Lc_ServicioElCanalDelFutbol(Lv_CountRow).ID_SERVICIO,Lv_DescripcionProductoECDF);
           FETCH C_GET_VALOR_FACT_SERVICIO
           INTO  Lc_GetValorFactxServicio;
          CLOSE C_GET_VALOR_FACT_SERVICIO; 

          IF C_GET_PARAM_MESES_ECDF%ISOPEN THEN
            CLOSE C_GET_PARAM_MESES_ECDF;
          END IF;

          OPEN C_GET_PARAM_MESES_ECDF(Lv_EstadoActivo, Lv_ModuloTecnico,Pv_EmpresaCod,Lv_NombreParamFechaMinima,Lv_DescripcionDetMeses);
           FETCH C_GET_PARAM_MESES_ECDF
           INTO  Lc_ParamMesesSuscripcionECDF;
          CLOSE C_GET_PARAM_MESES_ECDF;

          Ln_NumMesesTotal := NVL(Lc_ParamMesesSuscripcionECDF.VALOR2,0);

          SELECT ROUND(MONTHS_BETWEEN(SYSDATE,TO_TIMESTAMP(Lc_ServicioElCanalDelFutbol(Lv_CountRow).FECHA_ACTIVACION,'YYYY-MM-DD HH24:MI:SS')),1)
          INTO Ln_NumMesesActivo
          FROM DUAL;

          IF Ln_NumMesesActivo < Ln_NumMesesTotal THEN
          -- OBTENGO MESES RESTANTES A FACTURAR
            Pn_ElCanalDelFutbol := ROUND((NVL(Lc_ServicioElCanalDelFutbol(Lv_CountRow).PRECIO_VENTA,0)*Ln_NumMesesTotal),2)-ROUND((NVL(Lc_GetValorFactxServicio.VALOR,0)),2);
            Pn_AcumuladorEcdfEnTiempo := Pn_ElCanalDelFutbol + Pn_AcumuladorEcdfEnTiempo;    
          END IF;
        END IF;

        Lv_CountRow := Lc_ServicioElCanalDelFutbol.NEXT(Lv_CountRow);

    END LOOP;

    CLOSE C_GET_SERV_ECDF_FACT;

    Pn_ElCanalDelFutbol := Pn_AcumuladorEcdfEnTiempo;

    -- Netlife Assistance

    IF C_GET_SERV_NETLASSI%ISOPEN THEN
      CLOSE C_GET_SERV_NETLASSI;
    END IF;

    OPEN C_GET_SERV_NETLASSI(Pn_IdServicio);
     FETCH C_GET_SERV_NETLASSI
        INTO Lc_ServicioNetlfAssistance;
    CLOSE C_GET_SERV_NETLASSI;


    IF Lc_ServicioNetlfAssistance.ID_SERVICIO > 0 THEN
      Ln_NumTareasNetlifeAssintance := NVL(FNCK_CANCELACION_VOL.F_GET_NUM_TAREAS(Pn_IdPtoFacturacion,Lv_TareaNetlAssistance,'MD'),0);
      Pn_NetlifeAssistance := ROUND(((Ln_NumTareasNetlifeAssintance)*(Ln_ValorNetlifeAssistance))-(NVL(Ln_ValorNetlifeAssistanceFact,0)),2); 
    ELSE
      Pn_NetlifeAssistance := 0;
    END IF;
  --
  EXCEPTION
    WHEN OTHERS THEN
      --
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR(
                                                  'FNCK_CANCELACION_VOL',
                                                  'FNCK_CANCELACION_VOL.P_GET_VALORES_FACT',
                                                  ' ERROR '||SQLERRM||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                  ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                 );
      --
  END P_GET_VALORES_FACT;

FUNCTION F_GET_MESES_ACTIVO(Fn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE DEFAULT NULL)
  RETURN NUMBER
IS
  -- Costo del query: 5
  CURSOR GetNumMesesActivo(Cn_IdServicio   IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  IS
    SELECT ROUND(MONTHS_BETWEEN(SYSDATE,MIN(ISH.FE_CREACION)))
    FROM   DB_COMERCIAL.INFO_SERVICIO SERV 
    JOIN   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON SERV.ID_SERVICIO = ISH.SERVICIO_ID
    WHERE  
    ISH.SERVICIO_ID   =  Cn_IdServicio
    AND (          
    ((UPPER (ISH.ACCION)     = 'FEORIGENCAMBIORAZONSOCIAL'
     OR  UPPER (ISH.ACCION)  = 'FEORIGSERVICIOTRASLADADO'
     OR  UPPER (ISH.ACCION)  = 'CONFIRMARSERVICIO'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'CAMBIO DE RAZON SOCIAL'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CONFIRMO EL SERVICIO'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CREO EL SERVICIO'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE ACTIVO EL SERVICIO TRASLADO'
    ) AND ISH.ESTADO        = 'Activo')
    OR
    (
     (UPPER (ISH.ACCION)  = 'FEORIGSERVICIONETLIFECAM'
     OR  UPPER (ISH.ACCION)  = 'FEORIGSERVICIOTRASLADADO'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'FECHA INICIAL DE SERVICIO NETLIFECAM.'
     OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'FECHA INICIAL DE SERVICIO TRASLADADO.'
    )
    AND ISH.ESTADO        = 'PrePlanificada')
    );
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
  --
  RETURN Ln_NumMesesActivo;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL', 'FNCK_CANCELACION_VOL.F_GET_MESES_ACTIVO', SQLERRM);
  --
END F_GET_MESES_ACTIVO;
---END FUNCTION

FUNCTION F_GET_TOTAL_FACTURADO(Fv_DescProducto   DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE,
                               Fn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                               Fd_FeCreacionHist DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
IS
  -- Costo query: 5
    CURSOR C_GET_TOTAL_FACT(Cv_DescProducto   DB_COMERCIAL.ADMI_PRODUCTO.DESCRIPCION_PRODUCTO%TYPE, 
                            Cn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, 
                            Cd_FeCreacionHist DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.FE_CREACION%TYPE) 
    IS
      SELECT  ROUND(SUM(NVL(IDFD.VALOR_FACPRO_DETALLE * IDFD.CANTIDAD,0)),2) AS VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET  IDFD  ON IDFC.ID_DOCUMENTO      = IDFD.DOCUMENTO_ID
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID 
      JOIN DB_COMERCIAL.ADMI_PRODUCTO  AP                    ON AP.ID_PRODUCTO         = IDFD.PRODUCTO_ID
      WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP') 
      AND   AP.DESCRIPCION_PRODUCTO    =  Cv_DescProducto
      AND   IDFC.FE_CREACION           >= Cd_FeCreacionHist
      AND   IDFC.ESTADO_IMPRESION_FACT IN (
                                            SELECT APD.DESCRIPCION
                                            FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                            ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
                                            WHERE APC.NOMBRE_PARAMETRO = 'ESTADOS_FACTURAS_VALIDAS'
                                            AND APC.ESTADO             = 'Activo'
                                            AND APD.ESTADO             = 'Activo'
                                         )      
      AND   IDFC.PUNTO_ID              =(
                                          SELECT ISER.PUNTO_FACTURACION_ID
                                          FROM   DB_COMERCIAL.INFO_SERVICIO ISER
                                          WHERE  ISER.ID_SERVICIO = Cn_IdServicio
                                        );
  --
  Lf_TotalFacturado DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;
  Lc_TotalFacturado  C_GET_TOTAL_FACT%ROWTYPE;
  --
BEGIN
  --
  --
  IF C_GET_TOTAL_FACT%ISOPEN THEN
    CLOSE C_GET_TOTAL_FACT;
  END IF;


  OPEN C_GET_TOTAL_FACT(Fv_DescProducto,Fn_IdServicio,Fd_FeCreacionHist);
   FETCH C_GET_TOTAL_FACT
     INTO Lc_TotalFacturado;
   CLOSE C_GET_TOTAL_FACT;
  --
  Lf_TotalFacturado := Lc_TotalFacturado.VALOR;

  RETURN Lf_TotalFacturado;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_TOTAL_FACTURADO', SQLERRM);
  --
END F_GET_TOTAL_FACTURADO;


FUNCTION F_GET_DCTO_FACTURADO(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Fv_TipoDoc     IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
IS
    -- Costo del Query: 30
    CURSOR C_GET_DCTO_FACT(Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                           Cv_TipoDoc DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE) IS
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
              AND   ATDF.CODIGO_TIPO_DOCUMENTO = Cv_TipoDoc 
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


  OPEN C_GET_DCTO_FACT(Fn_IdPunto,Fv_TipoDoc);
   FETCH C_GET_DCTO_FACT
     INTO Lc_TotalFacturado;
   CLOSE C_GET_DCTO_FACT;
   Lf_TotalFacturado :=  NVL(Lc_TotalFacturado.VALOR,0);
  --
  RETURN Lf_TotalFacturado;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_DCTO_FACTURADO', SQLERRM);
  --
END F_GET_DCTO_FACTURADO;

--
--
FUNCTION F_GET_DCTO_FACTURADO_SERVICIO(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                       Fn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Fv_TipoDoc     IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
IS
    -- Costo del Query: 30
    CURSOR C_GET_DCTO_FACT(Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                           Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                           Cv_TipoDoc DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE) IS
        SELECT  ROUND(NVL(SUM(A.DESCUENTO_FACPRO_DETALLE),0), 2) AS VALOR
        FROM(  
              SELECT IDFD.DESCUENTO_FACPRO_DETALLE,CAB.ID_DOCUMENTO, CAB.NUMERO_FACTURA_SRI 
              FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  CAB
              JOIN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA  CAR  ON  CAR.DOCUMENTO_ID         = CAB.ID_DOCUMENTO
              JOIN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON  ATDF.ID_TIPO_DOCUMENTO    = CAB.TIPO_DOCUMENTO_ID
              JOIN  DB_COMERCIAL.INFO_PUNTO IPT                       ON  IPT.ID_PUNTO              = CAB.PUNTO_ID
              JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET  IDFD  ON  IDFD.DOCUMENTO_ID         = CAB.ID_DOCUMENTO
              JOIN  DB_COMERCIAL.INFO_SERVICIO ISE                    ON  ISE.ID_SERVICIO            = IDFD.SERVICIO_ID
              JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER        ON  IPER.ID_PERSONA_ROL       = IPT.PERSONA_EMPRESA_ROL_ID
              JOIN  DB_COMERCIAL.INFO_PERSONA IPE                     ON  IPE.ID_PERSONA            = IPER.PERSONA_ID
              WHERE IPE.NUMERO_CONADIS IS NULL
              AND   ATDF.CODIGO_TIPO_DOCUMENTO = Cv_TipoDoc 
              AND   CAB.ES_AUTOMATICA          = 'S'
              AND   CAB.PUNTO_ID               = Cn_PuntoId
              AND   ISE.ID_SERVICIO            = Cn_IdServicio
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
            GROUP BY  CAB.ID_DOCUMENTO, CAB.NUMERO_FACTURA_SRI, IDFD.DESCUENTO_FACPRO_DETALLE) A;          
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


  OPEN C_GET_DCTO_FACT(Fn_IdPunto,Fn_IdServicio,Fv_TipoDoc);
   FETCH C_GET_DCTO_FACT
     INTO Lc_TotalFacturado;
   CLOSE C_GET_DCTO_FACT;
   Lf_TotalFacturado :=  NVL(Lc_TotalFacturado.VALOR,0);
  --
  RETURN Lf_TotalFacturado;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_DCTO_FACTURADO_SERVICIO', SQLERRM);
  --
END F_GET_DCTO_FACTURADO_SERVICIO;

FUNCTION F_GET_NUM_TAREAS(Fn_PuntoId        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                          Fv_NombreTarea    IN DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE,
                          Fv_PrefijoEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE)
  RETURN NUMBER
IS
    -- Costo Query: 90
    CURSOR C_GET_NUM_TAREAS(Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE, 
                            Cv_NombreTarea DB_SOPORTE.ADMI_TAREA.NOMBRE_TAREA%TYPE,
                            Cv_PrefijoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE) IS
      SELECT COUNT(IDET.ID_DETALLE) AS VALOR
      FROM DB_SOPORTE.INFO_DETALLE IDET
      JOIN DB_SOPORTE.ADMI_TAREA TAR           ON  TAR.ID_TAREA   = IDET.TAREA_ID
      JOIN DB_SOPORTE.INFO_PARTE_AFECTADA IPA  ON IDET.ID_DETALLE =  IPA.DETALLE_ID
      JOIN DB_COMERCIAL.INFO_PUNTO IPT         ON IPT.ID_PUNTO    = IPA.AFECTADO_ID 
      JOIN DB_SOPORTE.ADMI_PROCESO AP          ON AP.ID_PROCESO   = TAR.PROCESO_ID
      JOIN DB_SOPORTE.ADMI_PROCESO_EMPRESA APE ON APE.PROCESO_ID  = AP.ID_PROCESO
      JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA = APE.EMPRESA_COD
      WHERE TAR.NOMBRE_TAREA LIKE '%'||Cv_NombreTarea||'%'
      AND IPT.ID_PUNTO = Cn_PuntoId
      AND IEG.PREFIJO  = Cv_PrefijoEmpresa;
  --
  Ln_NumeroTareas    NUMBER := 0;
  Lc_NumeroTareas    C_GET_NUM_TAREAS%ROWTYPE;
  --
BEGIN
  --
  --
    IF C_GET_NUM_TAREAS%ISOPEN THEN
      CLOSE C_GET_NUM_TAREAS;
    END IF;


    OPEN C_GET_NUM_TAREAS(Fn_PuntoId,Fv_NombreTarea,Fv_PrefijoEmpresa);
      FETCH C_GET_NUM_TAREAS
        INTO Lc_NumeroTareas;
    CLOSE C_GET_NUM_TAREAS;

    Ln_NumeroTareas := NVL(Lc_NumeroTareas.VALOR,0);
  --
  RETURN Ln_NumeroTareas;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_NUM_TAREAS', SQLERRM);
  --
  END F_GET_NUM_TAREAS;

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
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_TIPOMEDIO', SQLERRM);
  --
  END F_GET_TIPOMEDIO;

FUNCTION F_GET_SERVICIOS_BY_PTO(Fn_PuntoId IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                  Fv_Codigo  IN DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE,
                                  Fv_Estado  IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE)
    RETURN SYS_REFCURSOR IS

    C_GetServicios SYS_REFCURSOR;
    -- Costo Query: 4
  BEGIN
    OPEN C_GetServicios FOR
      SELECT  ISE.ID_SERVICIO 
      FROM DB_COMERCIAL.INFO_SERVICIO ISE
      JOIN DB_COMERCIAL.ADMI_PRODUCTO AP   ON AP.ID_PRODUCTO  = ISE.PRODUCTO_ID
      WHERE AP.CODIGO_PRODUCTO = Fv_Codigo
      AND   ISE.PUNTO_ID       = Fn_PuntoId
      AND   ISE.ESTADO         = Fv_Estado
      AND   AP.ESTADO          = Fv_Estado;

    RETURN C_GetServicios; 
  --
  EXCEPTION
  WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_SERVICIOS_BY_PTO', SQLERRM);
  END F_GET_SERVICIOS_BY_PTO;

FUNCTION F_GET_TOTAL_FACT_INST(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
IS
    -- Costo Query: 
    CURSOR C_GET_FACT_INST(Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
      SELECT (ROUND(NVL(SUM(DET.PRECIO_VENTA_FACPRO_DETALLE), 0), 2) - ROUND(NVL(SUM(DET.DESCUENTO_FACPRO_DETALLE), 0), 2)) AS VALOR  
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  CAB
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO    = CAB.TIPO_DOCUMENTO_ID
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET  DET  ON DET.DOCUMENTO_ID          = CAB.ID_DOCUMENTO
      LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB IPC               ON IPC.ID_PLAN               = DET.PLAN_ID
      LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP                ON AP.ID_PRODUCTO            = DET.PRODUCTO_ID
      JOIN DB_COMERCIAL.INFO_PUNTO IPT                       ON IPT.ID_PUNTO              = CAB.PUNTO_ID
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER        ON IPER.ID_PERSONA_ROL       = IPT.PERSONA_EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_PERSONA IPE                     ON IPE.ID_PERSONA            = IPER.PERSONA_ID
      WHERE (IPC.CODIGO_PLAN IN ('INST','INS') OR   AP.CODIGO_PRODUCTO IN('INST','INST-MD'))
      AND   ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND   CAB.PUNTO_ID  = Cn_PuntoId
      AND   CAB.ESTADO_IMPRESION_FACT IN (
                                            SELECT APD.DESCRIPCION
                                            FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                            ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
                                            WHERE APC.NOMBRE_PARAMETRO = 'ESTADOS_FACTURAS_VALIDAS'
                                            AND APC.ESTADO             = 'Activo'
                                            AND APD.ESTADO             = 'Activo'
                                         );
  --
  Lf_TotalFacturado  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;
  Lc_TotalFacturado  C_GET_FACT_INST%ROWTYPE;
  --
BEGIN
  --
  IF C_GET_FACT_INST%ISOPEN THEN
    CLOSE C_GET_FACT_INST;
  END IF;


  OPEN C_GET_FACT_INST(Fn_IdPunto);
   FETCH C_GET_FACT_INST
     INTO Lc_TotalFacturado;
   CLOSE C_GET_FACT_INST;
  --
  RETURN Lc_TotalFacturado.VALOR;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_TOTAL_FACT_INST', SQLERRM);
  --
END F_GET_TOTAL_FACT_INST;

FUNCTION F_GET_TOTAL_NC_FACT_INST(Fn_IdPunto     IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
IS
    -- Costo Query: 
    CURSOR C_GET_FACT_INST(Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
      SELECT (ROUND(NVL(SUM(DET.PRECIO_VENTA_FACPRO_DETALLE), 0), 2) - ROUND(NVL(SUM(DET.DESCUENTO_FACPRO_DETALLE), 0), 2)) AS VALOR  
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  CAB
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO    = CAB.TIPO_DOCUMENTO_ID
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET  DET  ON DET.DOCUMENTO_ID          = CAB.ID_DOCUMENTO
      LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB IPC               ON IPC.ID_PLAN               = DET.PLAN_ID
      LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP                ON AP.ID_PRODUCTO            = DET.PRODUCTO_ID
      JOIN DB_COMERCIAL.INFO_PUNTO IPT                       ON IPT.ID_PUNTO              = CAB.PUNTO_ID
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER        ON IPER.ID_PERSONA_ROL       = IPT.PERSONA_EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_PERSONA IPE                     ON IPE.ID_PERSONA            = IPER.PERSONA_ID
      WHERE (IPC.CODIGO_PLAN IN ('INST','INS') OR   AP.CODIGO_PRODUCTO IN('INST','INST-MD'))
      AND   ATDF.CODIGO_TIPO_DOCUMENTO IN ('NC')
      AND   CAB.PUNTO_ID  = Cn_PuntoId
      AND   CAB.REFERENCIA_DOCUMENTO_ID IS NOT NULL
      AND   CAB.ESTADO_IMPRESION_FACT IN (
                                            SELECT APD.DESCRIPCION
                                            FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                            ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
                                            WHERE APC.NOMBRE_PARAMETRO = 'ESTADOS_FACTURAS_VALIDAS'
                                            AND APC.ESTADO             = 'Activo'
                                            AND APD.ESTADO             = 'Activo'
                                         );
  --
  Lf_TotalFacturado  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;
  Lc_TotalFacturado  C_GET_FACT_INST%ROWTYPE;
  --
BEGIN
  --
  IF C_GET_FACT_INST%ISOPEN THEN
    CLOSE C_GET_FACT_INST;
  END IF;


  OPEN C_GET_FACT_INST(Fn_IdPunto);
   FETCH C_GET_FACT_INST
     INTO Lc_TotalFacturado;
   CLOSE C_GET_FACT_INST;
  --
  RETURN Lc_TotalFacturado.VALOR;
  --
EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_TOTAL_NC_FACT_INST', SQLERRM);
  --
END F_GET_TOTAL_NC_FACT_INST;


FUNCTION F_GET_TOTAL_FACT_PRO(Fv_CodProducto    DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE,
                              Fn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
IS
  -- Costo query: 5
    CURSOR C_GET_TOTAL_FACT(Cv_CodProducto    DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE, 
                            Cn_IdServicio     DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE) 
    IS
      SELECT  ROUND(SUM(NVL(DET.VALOR_FACPRO_DETALLE*DET.CANTIDAD,0)),2) AS VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  CAB
      JOIN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO    = CAB.TIPO_DOCUMENTO_ID
      JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET  DET  ON DET.DOCUMENTO_ID          = CAB.ID_DOCUMENTO
      LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB IPC               ON IPC.ID_PLAN               = DET.PLAN_ID
      LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP                ON AP.ID_PRODUCTO            = DET.PRODUCTO_ID
      JOIN DB_COMERCIAL.INFO_PUNTO IPT                       ON IPT.ID_PUNTO              = CAB.PUNTO_ID
      JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER        ON IPER.ID_PERSONA_ROL       = IPT.PERSONA_EMPRESA_ROL_ID
      JOIN DB_COMERCIAL.INFO_PERSONA IPE                     ON IPE.ID_PERSONA            = IPER.PERSONA_ID
      WHERE AP.CODIGO_PRODUCTO = Cv_CodProducto
      AND   DET.SERVICIO_ID    = Cn_IdServicio
      AND   ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND   CAB.ESTADO_IMPRESION_FACT  IN (
                                            SELECT APD.DESCRIPCION
                                            FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                            ON APD.PARAMETRO_ID        = APC.ID_PARAMETRO
                                            WHERE APC.NOMBRE_PARAMETRO = 'ESTADOS_FACTURAS_VALIDAS'
                                            AND APC.ESTADO             = 'Activo'
                                            AND APD.ESTADO             = 'Activo'
                                          );
  --
  Lf_TotalFacturado DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE;
  Lc_TotalFacturado  C_GET_TOTAL_FACT%ROWTYPE;
  --
BEGIN
  --
  --
  IF C_GET_TOTAL_FACT%ISOPEN THEN
    CLOSE C_GET_TOTAL_FACT;
  END IF;


  OPEN C_GET_TOTAL_FACT(Fv_CodProducto,Fn_IdServicio);
   FETCH C_GET_TOTAL_FACT
     INTO Lc_TotalFacturado;
   CLOSE C_GET_TOTAL_FACT;
  --
  Lf_TotalFacturado := Lc_TotalFacturado.VALOR;

  RETURN Lf_TotalFacturado;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_TOTAL_FACT_PRO', SQLERRM);
  --
END F_GET_TOTAL_FACT_PRO;

FUNCTION F_GET_FE_ACT_INT(Fn_IdPunto   IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GET_FE_ACTIVACION_INT(Cn_IdPunto DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) IS
    SELECT TO_CHAR(MIN(ISH.FE_CREACION),'DD-MM-YYYY')
    FROM DB_COMERCIAL.INFO_SERVICIO ISER
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH ON ISH.SERVICIO_ID  = ISER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA ON IPDA.PUNTO_ID = ISER.PUNTO_FACTURACION_ID
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET IPD ON IPD.PLAN_ID                = ISER.PLAN_ID
    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO AP  ON AP.ID_PRODUCTO             = IPD.PRODUCTO_ID
    WHERE (UPPER (ISH.ACCION)      = 'FEORIGSERVICIOTRASLADADO'
           OR  UPPER (ISH.ACCION)  = 'FEORIGENCAMBIORAZONSOCIAL'
           OR  UPPER (ISH.ACCION)  = 'FEORIGSERVICIONETLIFECAM'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1))  = 'SE CONFIRMO EL SERVICIO'
           OR  UPPER (ISH.ACCION)  = 'CONFIRMARSERVICIO'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'FECHA INICIAL DE SERVICIO NETLIFECAM.'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE CREO EL SERVICIO'   
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'SE ACTIVO EL SERVICIO TRASLADO'
           OR  UPPER (DBMS_LOB.SUBSTR( ISH.OBSERVACION,4000,1)) = 'CAMBIO DE RAZON SOCIAL'
           )
    AND ISER.PUNTO_ID      = Cn_IdPunto
    AND AP.CODIGO_PRODUCTO = 'INTD'
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
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL', 'FNCK_CANCELACION_VOL.F_GET_FE_ACT_INT', SQLERRM);
  --
END F_GET_FE_ACT_INT;

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

Lv_ParamCancelVoluntaria      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE   := 'CANCELACION VOLUNTARIA'; 
Lv_ModuloFinanciero           DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE             := 'FINANCIERO';
Lv_EstadoActivo               DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';
Lv_fec_PermanenciaMinima24    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE             := 'PERMANENCIA MINIMA 24 MESES';
Lv_fec_PermanenciaMinima36    DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE             := 'PERMANENCIA MINIMA 36 MESES';

Lc_ParamPermanencia24         C_GET_PARAMETROS_PERMANENCIA%ROWTYPE;
Lc_ParamPermanencia36         C_GET_PARAMETROS_PERMANENCIA%ROWTYPE;

--
BEGIN
  Lv_FeActivacion := NVL(DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_FE_ACT_INT(Fn_IdPunto),'');   

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
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_PERMANENCIA_VIGENTE', SQLERRM);
  --
END F_GET_PERMANENCIA_VIGENTE;

FUNCTION F_GET_CANCEL_VOL_INST_AMORT (Fv_EmpresaCod   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Fn_IdPunto      IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Fn_IdServicio   IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
RETURN NUMBER
IS
  CURSOR C_GET_VAL_INSTALACION_ACT (Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                    Cv_Estado VARCHAR2)IS
  --Costo: 11
  SELECT TCTA.DESCRIPCION_CUENTA,
         CFP.CONTRATO_ID
  FROM   DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CFP
  JOIN   DB_GENERAL.ADMI_BANCO_TIPO_CUENTA BTC ON BTC.ID_BANCO_TIPO_CUENTA  = CFP.BANCO_TIPO_CUENTA_ID 
  JOIN   DB_GENERAL.ADMI_TIPO_CUENTA TCTA      ON TCTA.ID_TIPO_CUENTA       = BTC.TIPO_CUENTA_ID
  JOIN   DB_COMERCIAL.INFO_CONTRATO IC         ON CFP.CONTRATO_ID           = IC.ID_CONTRATO      
  JOIN   DB_COMERCIAL.INFO_PUNTO IP            ON IC.PERSONA_EMPRESA_ROL_ID = IP.PERSONA_EMPRESA_ROL_ID
  WHERE  IC.ESTADO                 = Cv_Estado
  AND    CFP.ESTADO                = Cv_Estado
  AND    IP.ID_PUNTO               = Cn_PuntoId;

--  
  Ln_ValorFacturadoInst         NUMBER := 0;
  Ln_ValorNcFactInst            NUMBER := 0;
  Ln_ValorFacturadoParam        NUMBER := 0;
  Ln_PermanenciaMinima          NUMBER := 0;
  Ln_Meses                      NUMBER := 0;
  Ln_ValorFacturado             NUMBER := 0;
  Ln_TotalFactInstalacion       NUMBER := 0;

  Lv_Descripcion_cuenta_hist    VARCHAR2 (20);
  Lv_TipoMedio                  VARCHAR2 (2) ; 

  Lrf_GetAdmiParamtrosDet       SYS_REFCURSOR ;                                       
  Lr_GetAdmiParamtrosDet        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE ;
  Lv_ParamPorcDescInsta         DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE   := 'PORCENTAJE_DESCUENTO_INSTALACION'; 
  Lv_NombreParameteroCab        DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE   := 'PROM_PRECIO_INSTALACION'; 
  Lv_ParamInstalacionHome       DB_GENERAL.ADMI_PARAMETRO_DET.VALOR2%TYPE             := 'INSTALACION HOME';
  Lv_EstadoActivo               DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';
  Lv_Descrip_Cuenta             VARCHAR2(25);
  Lc_valores_Inst_Act           C_GET_VAL_INSTALACION_ACT%ROWTYPE    ;

BEGIN
  Ln_ValorNcFactInst      :=  NVL(FNCK_CANCELACION_VOL.F_GET_TOTAL_NC_FACT_INST(Fn_IdPunto),0);
  Ln_ValorFacturadoInst   :=  NVL(FNCK_CANCELACION_VOL.F_GET_TOTAL_FACT_INST(Fn_IdPunto),0) - Ln_ValorNcFactInst;
  Ln_PermanenciaMinima    :=  NVL(FNCK_CANCELACION_VOL.F_GET_PERMANENCIA_VIGENTE(Fv_EmpresaCod,Fn_IdPunto),0);
  Lv_TipoMedio            :=  NVL(FNCK_CANCELACION_VOL.F_GET_TIPOMEDIO(Fn_IdServicio,Lv_EstadoActivo,NULL),'');
  Ln_Meses                :=  NVL(FNCK_CANCELACION_VOL.F_GET_MESES_ACTIVO(Fn_IdServicio),0);

  Lrf_GetAdmiParamtrosDet :=  FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_NombreParameteroCab, Lv_EstadoActivo, Lv_EstadoActivo, Lv_TipoMedio, Lv_ParamInstalacionHome, NULL, NULL);
      FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
      CLOSE Lrf_GetAdmiParamtrosDet;  

  Ln_ValorFacturadoParam := TO_NUMBER(NVL(Lr_GetAdmiParamtrosDet.VALOR3,0));

  Lv_Descripcion_cuenta_hist := NVL(FNCK_CANCELACION_VOL.F_GET_FORMA_PAGO_HIST (Fn_IdPunto),'');


  IF Ln_ValorFacturadoInst >= Ln_ValorFacturadoParam THEN
     RETURN Ln_TotalFactInstalacion;
  ELSE   
    IF Lv_Descripcion_cuenta_hist = 'AHORRO' THEN

    Lv_Descrip_Cuenta := Lv_Descripcion_cuenta_hist;

    ELSE
        IF C_GET_VAL_INSTALACION_ACT%ISOPEN THEN
            CLOSE C_GET_VAL_INSTALACION_ACT;
        END IF;

        OPEN C_GET_VAL_INSTALACION_ACT (Fn_IdPunto,Lv_EstadoActivo);
            FETCH C_GET_VAL_INSTALACION_ACT INTO Lc_valores_Inst_Act; 
        CLOSE C_GET_VAL_INSTALACION_ACT;

        Lv_Descrip_Cuenta := NVL(Lc_valores_Inst_Act.DESCRIPCION_CUENTA,'EFECTIVO'); 

    END IF;    
    Lrf_GetAdmiParamtrosDet :=  FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamPorcDescInsta, Lv_EstadoActivo, Lv_EstadoActivo, Lv_TipoMedio, Lv_Descrip_Cuenta, NULL, NULL);
        FETCH Lrf_GetAdmiParamtrosDet INTO Lr_GetAdmiParamtrosDet;
        CLOSE Lrf_GetAdmiParamtrosDet;  

    Ln_ValorFacturado := TO_NUMBER(NVL(Lr_GetAdmiParamtrosDet.VALOR4,0));
    Ln_TotalFactInstalacion := ROUND(NVL(Ln_ValorFacturado - (Ln_ValorFacturado/Ln_PermanenciaMinima) * (Ln_Meses - 1),0),2);

    IF Ln_TotalFactInstalacion < 0 THEN 
       Ln_TotalFactInstalacion := 0;       
    END IF;

  END IF;

RETURN Ln_TotalFactInstalacion;

EXCEPTION
WHEN OTHERS THEN
  --
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_CANCEL_VOL_INST_AMORT', SQLERRM);
  --
END F_GET_CANCEL_VOL_INST_AMORT;


FUNCTION F_GET_FECHA_CONTRATO(Fn_IdContrato   IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
  RETURN VARCHAR2
IS
  --
  CURSOR C_GET_FE_CREACION_CONTRATO(Cn_IdContrato DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                    Cv_Estado       VARCHAR2) IS
   -- Costo: 3
    SELECT TO_CHAR(MAX(IC.FE_CREACION),'DD-MM-YYYY')
    FROM DB_COMERCIAL.INFO_CONTRATO IC
    WHERE IC.ID_CONTRATO = Cn_IdContrato
    AND IC.ESTADO = Cv_Estado;
  --
  Lv_FeCreacionContrato VARCHAR2(10);
  Lv_EstadoActivo               DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';
  --
BEGIN
  --
  --
  IF C_GET_FE_CREACION_CONTRATO%ISOPEN THEN
    CLOSE C_GET_FE_CREACION_CONTRATO;
  END IF;
  --
  OPEN C_GET_FE_CREACION_CONTRATO(Fn_IdContrato,Lv_EstadoActivo);
  --
  FETCH C_GET_FE_CREACION_CONTRATO INTO Lv_FeCreacionContrato;
  --
  CLOSE C_GET_FE_CREACION_CONTRATO;
  --
  RETURN NVL(Lv_FeCreacionContrato,'');
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL', 'FNCK_CANCELACION_VOL.F_GET_FECHA_CONTRATO', SQLERRM);
  --
END F_GET_FECHA_CONTRATO;

FUNCTION F_GET_FORMA_PAGO_ACT(Fn_IdContrato   IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
RETURN VARCHAR2
IS
    CURSOR C_GET_FORMA_PAGO_ACT (Cn_IdContrato   IN DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                 Cv_Estado       IN VARCHAR2)
    IS
        --Costo: 0,018
        SELECT regexp_substr(ATC.DESCRIPCION_CUENTA,'(\S*)') AS FORMA_PAGO
        FROM   DB_COMERCIAL.INFO_CONTRATO IC
        INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP  ON AFP.ID_FORMA_PAGO = IC.FORMA_PAGO_ID
        INNER JOIN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP  ON ICFP.CONTRATO_ID = IC.ID_CONTRATO
        INNER JOIN DB_GENERAL.ADMI_TIPO_CUENTA ATC ON ATC.ID_TIPO_CUENTA = ICFP.TIPO_CUENTA_ID
        WHERE IC.ID_CONTRATO      = Cn_IdContrato 
        AND   AFP.TIPO_FORMA_PAGO = 'DEBITO' 
        AND   IC.ESTADO           = Cv_Estado
        AND   ICFP.ESTADO         = Cv_Estado;


Lc_TipoFormaPago               C_GET_FORMA_PAGO_ACT%ROWTYPE;
Lv_TipoFormaPagoActual         VARCHAR2(30);
Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';

    BEGIN 

    --Obtenemos el tipo de forma de pago Actual.
        IF C_GET_FORMA_PAGO_ACT%ISOPEN THEN
        CLOSE C_GET_FORMA_PAGO_ACT;
        END IF;

        OPEN C_GET_FORMA_PAGO_ACT(Fn_IdContrato,Lv_EstadoActivo);
        FETCH C_GET_FORMA_PAGO_ACT INTO Lc_TipoFormaPago;
        CLOSE C_GET_FORMA_PAGO_ACT;

        Lv_TipoFormaPagoActual := NVL(Lc_TipoFormaPago.FORMA_PAGO,'EFECTIVO');
    RETURN Lv_TipoFormaPagoActual;

EXCEPTION
WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL', 'FNCK_CANCELACION_VOL.F_GET_FORMA_PAGO_ACT', SQLERRM);
END F_GET_FORMA_PAGO_ACT;

  FUNCTION F_GET_FORMA_PAGO_HIST (Fn_IdPunto   IN   DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  RETURN VARCHAR2
  IS
  -- Costo: 0,011
  CURSOR C_GET_FORMA_PAGO_HIST(Cn_PuntoId DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,Cv_Estado VARCHAR2) IS
    SELECT regexp_substr(TCTA.DESCRIPCION_CUENTA,'(\S*)') AS FORMA_PAGO,
           CFPH.CONTRATO_ID,
           CFPH.FACTURA
    FROM   DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST CFPH
    JOIN   DB_GENERAL.ADMI_BANCO_TIPO_CUENTA BTC  ON     BTC.ID_BANCO_TIPO_CUENTA  = CFPH.BANCO_TIPO_CUENTA_ID 
    JOIN   DB_GENERAL.ADMI_TIPO_CUENTA TCTA       ON     TCTA.ID_TIPO_CUENTA       = BTC.TIPO_CUENTA_ID
    JOIN   DB_GENERAL.ADMI_BANCO BCO              ON     BCO.ID_BANCO              = BTC.BANCO_ID
    JOIN   DB_COMERCIAL.INFO_CONTRATO IC          ON     CFPH.CONTRATO_ID          = IC.ID_CONTRATO         
    JOIN   DB_COMERCIAL.INFO_PUNTO IP             ON     IC.PERSONA_EMPRESA_ROL_ID = IP.PERSONA_EMPRESA_ROL_ID
    WHERE  IC.ESTADO                 = Cv_Estado
    AND    CFPH.ESTADO               = Cv_Estado
    AND    IP.ID_PUNTO               = Cn_PuntoId ;

    Lc_ValFormaPagoHist C_GET_FORMA_PAGO_HIST%ROWTYPE;
    Lv_FormaPagoHist    VARCHAR2(30);
    Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';

    BEGIN

    IF C_GET_FORMA_PAGO_HIST %ISOPEN THEN
      CLOSE C_GET_FORMA_PAGO_HIST;
    END IF;

    OPEN C_GET_FORMA_PAGO_HIST(Fn_IdPunto,Lv_EstadoActivo);
      FETCH C_GET_FORMA_PAGO_HIST INTO Lc_ValFormaPagoHist;
    CLOSE C_GET_FORMA_PAGO_HIST;


 FOR Lc_ValFormaPagoHist IN C_GET_FORMA_PAGO_HIST(Fn_IdPunto,Lv_EstadoActivo)
 LOOP
    IF Lc_ValFormaPagoHist.FORMA_PAGO = 'AHORRO' AND Lc_ValFormaPagoHist.FACTURA = 'S'  THEN

      Lv_FormaPagoHist := NVL(Lc_ValFormaPagoHist.FORMA_PAGO,'');    

    END IF;

    IF Lc_ValFormaPagoHist.FORMA_PAGO <> 'AHORRO' THEN

        Lv_FormaPagoHist := NVL(Lc_ValFormaPagoHist.FORMA_PAGO,'');  

    END IF;

 END LOOP;    

RETURN Lv_FormaPagoHist;

EXCEPTION
WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL', 'FNCK_CANCELACION_VOL.F_GET_FORMA_PAGO_HIST', SQLERRM);

END F_GET_FORMA_PAGO_HIST;

FUNCTION F_GET_TIPO_CUENTA_SELEC(Fn_IdFormaPago          IN  DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,
                                 Fn_IdTipoCuenta         IN  DB_GENERAL.ADMI_TIPO_CUENTA.ID_TIPO_CUENTA%TYPE)
  RETURN VARCHAR2
 IS
    --Recibe el id_forma_pago seleccionado en el combo del formulario.

    CURSOR C_GET_TIPOFORMAPAGO(Cn_IdFormaPago DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE,Cv_Estado VARCHAR2) 
    IS
        -- Costo del Query: 1
        SELECT  AFP.TIPO_FORMA_PAGO 
        FROM    DB_GENERAL.ADMI_FORMA_PAGO AFP
        WHERE   AFP.ES_PAGO_PARA_CONTRATO = 'S'
        AND     AFP.TIPO_FORMA_PAGO = 'DEBITO'
        AND     AFP.ESTADO = Cv_Estado
        AND     AFP.ID_FORMA_PAGO = Cn_IdFormaPago ;

    --Recibe el id_tipo_cuenta seleccionado en el formulario.
    CURSOR C_GET_TIPOCUENTA (Cn_IdTipoCuenta DB_GENERAL.ADMI_TIPO_CUENTA.ID_TIPO_CUENTA%TYPE,Cv_Estado VARCHAR2)
    IS
        -- Costodel Query: 1
        SELECT regexp_substr(ATC.DESCRIPCION_CUENTA,'(\S*)') AS FORMA_PAGO 
        FROM   DB_GENERAL.ADMI_TIPO_CUENTA ATC
        WHERE  ATC.ID_TIPO_CUENTA = Cn_IdTipoCuenta 
        AND    ATC.ESTADO         = Cv_Estado;

    Lc_TipoFormaPago                C_GET_TIPOFORMAPAGO%ROWTYPE;
    Lc_TipoCuenta                   C_GET_TIPOCUENTA%ROWTYPE;
    Lv_TipoFormaPagoSeleccionada    VARCHAR2(20) ;       
    Lv_EstadoActivo                DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';

BEGIN
--Obtenemos el tipo de forma de pago seleccionado.
    IF C_GET_TIPOFORMAPAGO%ISOPEN THEN
    CLOSE C_GET_TIPOFORMAPAGO;
    END IF;

    OPEN C_GET_TIPOFORMAPAGO(Fn_IdFormaPago,Lv_EstadoActivo);
    FETCH C_GET_TIPOFORMAPAGO INTO Lc_TipoFormaPago;
    CLOSE C_GET_TIPOFORMAPAGO;        

    IF Lc_TipoFormaPago.TIPO_FORMA_PAGO = 'DEBITO' THEN
        --Obtenemos el tipo de cuenta. 
        IF C_GET_TIPOCUENTA%ISOPEN THEN
        CLOSE C_GET_TIPOCUENTA;
        END IF;

        OPEN C_GET_TIPOCUENTA(Fn_IdTipoCuenta,Lv_EstadoActivo);
        FETCH C_GET_TIPOCUENTA INTO Lc_TipoCuenta;
        CLOSE C_GET_TIPOCUENTA;

        Lv_TipoFormaPagoSeleccionada := NVL(Lc_TipoCuenta.FORMA_PAGO,'');                
    ELSE
        Lv_TipoFormaPagoSeleccionada := NVL(Lc_TipoFormaPago.TIPO_FORMA_PAGO,'EFECTIVO');
    END IF;

RETURN   Lv_TipoFormaPagoSeleccionada; 

EXCEPTION
WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL', 'FNCK_CANCELACION_VOL.F_GET_TIPO_CUENTA_SELEC', SQLERRM);
END F_GET_TIPO_CUENTA_SELEC;

FUNCTION F_GET_BASE_INSTALACION_FP(Fv_TipoFormaPagoSelec   IN  DB_GENERAL.ADMI_FORMA_PAGO.DESCRIPCION_FORMA_PAGO%TYPE,
                                   Fn_IdContrato           IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE,
                                   Fn_IdPunto              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
RETURN NUMBER
IS 
    --SI EL CURSOR TRAE DATA DEBE GENERAR LOS VALORES LA FACTURA  Y LA BASE ES 100 
    --DEBES VALIDAR SI NO TIENE UNA FORMA DE PAGO ANTERIOR DE AHORRO (QUE HAYA FACTURADO).
    CURSOR C_GET_SI_FACT(Cv_TipoFormaPagoActual   VARCHAR2, 
                         Cv_TipoFormaPagoSelec    VARCHAR2,
                         Cv_TipoMedio             VARCHAR2,
                         Cv_Estado                VARCHAR2)
    IS 
    -- Costo del Query : 5
      SELECT VALOR6 AS VALOR_BASE
      FROM   DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE  PARAMETRO_ID = (SELECT ID_PARAMETRO
                             FROM   DB_GENERAL.ADMI_PARAMETRO_CAB
                             WHERE  NOMBRE_PARAMETRO = 'EQUIVALENCIA_FORMAS_PAGO'
                             AND    MODULO           = 'FINANCIERO'
                             AND    PROCESO          = 'FACTURACION'
                             AND    ESTADO           = Cv_Estado)
      AND   VALOR2 = Cv_TipoFormaPagoActual
      AND   VALOR1 = Cv_TipoMedio
      AND   VALOR3 = Cv_TipoFormaPagoSelec 
      ORDER BY FE_CREACION DESC ;

    --SI EL CURSOR TRAE DATA NO DEBE GENERAR LOS VALORES DE LA FACTURA 
    CURSOR C_GET_NO_FACT(Cv_TipoFormaPagoActual   VARCHAR2, 
                         Cv_TipoFormaPagoSelec    VARCHAR2,
                         Cv_TipoMedio             VARCHAR2,
                         Cv_Estado                VARCHAR2)                            
    IS 
     -- Costo del Query : 5
      SELECT VALOR6 AS VALOR_BASE
      FROM   DB_GENERAL.ADMI_PARAMETRO_DET
      WHERE  PARAMETRO_ID = (SELECT ID_PARAMETRO
                             FROM   DB_GENERAL.ADMI_PARAMETRO_CAB
                             WHERE  NOMBRE_PARAMETRO = 'EQUIVALENCIA_FORMAS_PAGO'
                             AND    MODULO           = 'FINANCIERO'
                             AND    PROCESO          = 'FACTURACION'
                             AND    ESTADO           = Cv_Estado)
      AND   VALOR2 = Cv_TipoFormaPagoActual
      AND   VALOR1 = Cv_TipoMedio
      AND   VALOR4  LIKE '%'|| Cv_TipoFormaPagoSelec ||'%'         
      ORDER BY FE_CREACION DESC ;


    Ln_BaseAmort         NUMBER;
    Ln_BaseAmortSi       NUMBER;    
    Lc_BaseAmortSi       C_GET_SI_FACT%ROWTYPE;
    Lc_BaseAmortNo       C_GET_NO_FACT%ROWTYPE;    
    Lv_FormaPagoAct      VARCHAR2 (12);
    Lv_TipoMedio         VARCHAR2 (12);
    Lv_FormaPago         VARCHAR2 (12);
    Lv_FormaPagoHist     VARCHAR2 (12);    
    Lv_EstadoActivo      DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE    := 'Activo';    

BEGIN
    Lv_FormaPagoAct   :=  NVL(FNCK_CANCELACION_VOL.F_GET_FORMA_PAGO_ACT(Fn_IdContrato),0); 
    Lv_TipoMedio      :=  NVL(FNCK_CANCELACION_VOL.F_GET_TIPOMEDIO(NULL,Lv_EstadoActivo,Fn_IdPunto),0);
    Lv_FormaPagoHist  :=  NVL(FNCK_CANCELACION_VOL.F_GET_FORMA_PAGO_HIST(Fn_IdPunto),0); 

    IF Lv_FormaPagoHist = 'AHORRO' THEN 
        Lv_FormaPago:= Lv_FormaPagoHist;
    ELSE 
        Lv_FormaPago:= Lv_FormaPagoAct;
    END IF;

    IF C_GET_SI_FACT%ISOPEN THEN
    CLOSE C_GET_SI_FACT;
    END IF;

    OPEN C_GET_SI_FACT(Lv_FormaPago,Fv_TipoFormaPagoSelec,Lv_TipoMedio,Lv_EstadoActivo);
    FETCH C_GET_SI_FACT  INTO Lc_BaseAmortSi;
    CLOSE C_GET_SI_FACT;

  Ln_BaseAmortSi := Lc_BaseAmortSi.VALOR_BASE ; 

    IF Ln_BaseAmortSi IS NULL THEN
        IF C_GET_NO_FACT%ISOPEN THEN
        CLOSE C_GET_NO_FACT;
        END IF;

        OPEN C_GET_NO_FACT(Lv_FormaPago,Fv_TipoFormaPagoSelec,Lv_TipoMedio,Lv_EstadoActivo);
        FETCH C_GET_NO_FACT INTO Lc_BaseAmortNo;
        CLOSE C_GET_NO_FACT;

        Ln_BaseAmort := TO_NUMBER(NVL(Lc_BaseAmortNo.VALOR_BASE, 0));
    ELSE 
        Ln_BaseAmort := TO_NUMBER(NVL(Lc_BaseAmortSi.VALOR_BASE, 0));
    END IF;
    --SI DEVUELVE CERO ES EFECTIVO Y NO SE HACE NINGUNA FACTURA   
RETURN Ln_BaseAmort;

EXCEPTION
WHEN OTHERS THEN
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL', 'FNCK_CANCELACION_VOL.F_GET_BASE_INSTALACION_FP', SQLERRM);
END F_GET_BASE_INSTALACION_FP;




PROCEDURE P_GET_FACT_PROM_MENSUALES (Pn_IdPunto       IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                     Prf_Result       OUT Lrf_Result)                                     
 IS
 Lv_Query             VARCHAR2(3500) ;
 Lv_Usuario           VARCHAR2(6)   := 'telcos';
 Lv_Documento         VARCHAR2(3)   := 'FAC';
 Lv_Caracteristica    VARCHAR2(20)  := 'CAMBIO_FORMA_PAGO';
 Lv_Estado            VARCHAR2(6)   := 'Activo';
 Lv_AutoRecurrente     VARCHAR2(1)  := 'S';

BEGIN 
--Costo del Query: 35
  Lv_Query := 'SELECT  PTO.LOGIN,
                       DET.PUNTO_ID,
                       CAB.NUMERO_FACTURA_SRI,
                       DET.DESCUENTO_FACPRO_DETALLE,
                       ROUND(SUM(NVL(DET.DESCUENTO_FACPRO_DETALLE * DET.CANTIDAD,0)),2) AS DESCUENTO_FAC_MENSUAL
                FROM   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB CAB
                JOIN   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET DET   ON CAB.ID_DOCUMENTO       = DET.DOCUMENTO_ID
                JOIN   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA CAR   ON DET.DOCUMENTO_ID       = CAR.DOCUMENTO_ID
                JOIN   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON ATDF.ID_TIPO_DOCUMENTO = CAB.TIPO_DOCUMENTO_ID 
                JOIN   DB_COMERCIAL.INFO_PUNTO PTO                       ON PTO.ID_PUNTO           = CAB.PUNTO_ID
                WHERE  DET.PUNTO_ID      = :Pn_IdPunto
                AND    CAB.ES_AUTOMATICA = :Lv_AutoRecurrente
                AND    CAB.RECURRENTE    = :Lv_AutoRecurrente
                AND    DET.USR_CREACION  = :Lv_Usuario
                AND    ATDF.CODIGO_TIPO_DOCUMENTO      = :Lv_Documento
                AND    DET.PORCETANJE_DESCUENTO_FACPRO <> 0     
                AND    CAR.CARACTERISTICA_ID <> (SELECT ID_CARACTERISTICA
                                             FROM   DB_COMERCIAL.ADMI_CARACTERISTICA
                                             WHERE  DESCRIPCION_CARACTERISTICA = :Lv_Caracteristica
                                             AND     ESTADO = :Lv_Estado)
                GROUP BY PTO.LOGIN,DET.PUNTO_ID, CAB.NUMERO_FACTURA_SRI, DET.DESCUENTO_FACPRO_DETALLE' ;

 OPEN Prf_Result FOR Lv_Query USING Pn_IdPunto,Lv_AutoRecurrente,Lv_AutoRecurrente,Lv_Usuario,Lv_Documento,Lv_Caracteristica,Lv_Estado;

EXCEPTION
WHEN OTHERS THEN
  IF Prf_Result%ISOPEN THEN
    CLOSE Prf_Result;
  END IF;

DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR(
                                             'FNCK_CANCELACION_VOL',
                                             'FNCK_CANCELACION_VOL.P_GET_FACT_PROM_MENSUALES',
                                             ' ERROR '||SQLERRM||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                             ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                           );           

END  P_GET_FACT_PROM_MENSUALES;

PROCEDURE P_RPT_CANC_NOFACTURADAS(
  Pv_PrefijoEmpresa   IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE 
)
  IS
    -- Costo del qQuery: 3
    CURSOR C_GET_PARAMETROS(Cv_EmpresaCod VARCHAR2, Cv_NombreParametro VARCHAR2, Cv_Modulo VARCHAR2, Cv_Valor1 VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT DET.VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           =  Cv_Estado
      AND DET.ESTADO           =  Cv_Estado
      AND CAB.MODULO           =  Cv_Modulo
      AND DET.VALOR1           =  Cv_Valor1
      AND DET.EMPRESA_COD      =  Cv_EmpresaCod
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;

  CURSOR C_GET_SERV_CANC_NOFACT(Cv_PrefijoEmpresa   VARCHAR2, 
                                Cv_EstadoServicio   VARCHAR2,
                                Cv_AccionHist       VARCHAR2) IS
    SELECT ISE.ID_SERVICIO,
	   ISH.USR_CREACION AS USR_CREACION,
	   PTO.LOGIN AS LOGIN,
       CASE WHEN ISE.PRODUCTO_ID IS NOT NULL 
            THEN (SELECT NVL(AP.DESCRIPCION_PRODUCTO,'') FROM DB_COMERCIAL.ADMI_PRODUCTO AP WHERE AP.ID_PRODUCTO = ISE.PRODUCTO_ID)
            ELSE (SELECT NVL(IPC.NOMBRE_PLAN,'') FROM DB_COMERCIAL.INFO_PLAN_CAB IPC WHERE IPC.ID_PLAN = ISE.PLAN_ID)
       END AS SERVICIO,
       TO_CHAR(ISH.FE_CREACION, 'DD-MM-YYYY HH24:MI:SS') AS FE_CREACION,
	   AM.NOMBRE_MOTIVO AS MOTIVO,
       DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_FE_ACT_INT(PTO.ID_PUNTO) AS FE_ACTIVACION,
	   ISH.OBSERVACION  AS OBSERVACION
    FROM DB_COMERCIAL.INFO_SERVICIO            ISE
    JOIN DB_COMERCIAL.INFO_PUNTO               PTO  ON PTO.ID_PUNTO        = ISE.PUNTO_ID
    JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL = PTO.PERSONA_EMPRESA_ROL_ID
    JOIN DB_COMERCIAL.INFO_EMPRESA_ROL         IER  ON IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID 
    JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO       IEG  ON IEG.COD_EMPRESA     = IER.EMPRESA_COD
    JOIN DB_COMERCIAL.INFO_PERSONA             PERS ON PERS.ID_PERSONA     = IPER.PERSONA_ID 
    JOIN DB_COMERCIAL.INFO_SERVICIO_HISTORIAL  ISH  ON ISE.ID_SERVICIO     = ISH.SERVICIO_ID
    LEFT JOIN DB_GENERAL.ADMI_MOTIVO           AM   ON AM.ID_MOTIVO        = ISH.MOTIVO_ID
    WHERE ISE.ESTADO               = Cv_EstadoServicio
    AND ISH.ESTADO                 = Cv_EstadoServicio
    AND IEG.PREFIJO                = Cv_PrefijoEmpresa
    AND ISH.ID_SERVICIO_HISTORIAL  = (
                                        SELECT MAX(ISHS.ID_SERVICIO_HISTORIAL) 
                                        FROM   DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISHS 
                                        WHERE  ISHS.ACCION      = Cv_AccionHist 
                                        AND    ISHS.SERVICIO_ID = ISE.ID_SERVICIO
                                        AND    TRUNC(ISHS.FE_CREACION) >= TRUNC(SYSDATE)
                                        AND    TRUNC(ISHS.FE_CREACION) < TRUNC(SYSDATE+1)
                                      )
    ORDER BY ISH.FE_CREACION DESC;

  Lv_Query                  VARCHAR2(30000):= '';
  Lv_FechaActual            VARCHAR2(100)  :=  TO_CHAR(SYSDATE, 'DD-MM-YYYY');
  Lv_FechaHoraRpt           VARCHAR2(100)  :=  TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
  Lv_Directorio             VARCHAR2(50)   := 'DIR_REPGERENCIA';
  Lv_EmpresaCod             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
  Lv_NombreArchivo          VARCHAR2(200)  := 'rptServCanceladosNoFacturados_'||Pv_PrefijoEmpresa||'_'||Lv_FechaHoraRpt;
  Lv_Gzip                   VARCHAR2(500)  := '';
  Lv_Delimitador            VARCHAR2(1)    := '|';
  Lv_NombreArchivoCsv       VARCHAR2(200)  := Lv_NombreArchivo||'.csv';
  Lv_NombreArchivoZip       VARCHAR2(200)  := Lv_NombreArchivoCsv||'.gz';
  Lv_EstadoServicio         VARCHAR2(500)  := 'Cancel';
  Lv_AccionHistFact         VARCHAR2(500)  := 'noFacturable';
  Lv_Remitente              VARCHAR2(20)   := 'telcos@telconet.ec';
  Lv_Destinatario           VARCHAR2(100)  := '';
  Lv_Asunto                 VARCHAR2(300)  := 'Telcos+ : Reporte Cancelaciones no Facturadas '||Lv_FechaActual;
  Lv_Cuerpo                 VARCHAR2(9999) := 'Estimados, se adjunta reporte de cancelaciones no facturadas.';
  Lv_Modulo                 DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE             := 'FINANCIERO';
  Lv_ParametroCancelacion   DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE   := 'CANCELACION VOLUNTARIA';
  Lv_ValorParametroDet      DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE             := 'DESTINATARIOS RPT CANCELACION NO FACTURADA';
  Lv_EstadoActivo           DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE             := 'Activo';
  Lr_InfoReporteHistorial   DB_FINANCIERO.INFO_REPORTE_HISTORIAL%ROWTYPE;
  Lc_ParametrosDest         C_GET_PARAMETROS%ROWTYPE;
  Lfile_Archivo utl_file.file_type;
  Ln_ServicioIdCancel       NUMBER := 0;

  BEGIN


    Lv_EmpresaCod  := DB_COMERCIAL.COMEK_CONSULTAS.F_GET_COD_BY_PREFIJO_EMP(Pv_PrefijoEmpresa);

    IF C_GET_SERV_CANC_NOFACT%ISOPEN THEN
      CLOSE C_GET_SERV_CANC_NOFACT;
    END IF;

    IF C_GET_PARAMETROS%ISOPEN THEN
      CLOSE C_GET_PARAMETROS;
    END IF;

    OPEN C_GET_PARAMETROS(Lv_EmpresaCod,Lv_ParametroCancelacion,Lv_Modulo,Lv_ValorParametroDet,Lv_EstadoActivo);
     FETCH C_GET_PARAMETROS 
        INTO Lc_ParametrosDest;
    CLOSE C_GET_PARAMETROS;

    Lv_Destinatario      := NVL(Lc_ParametrosDest.VALOR2,'notificaciones_telcos@telconet.ec');

    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivoCsv;

    Lfile_Archivo        := UTL_FILE.fopen(Lv_Directorio,Lv_NombreArchivoCsv,'w',3000);


    Lr_InfoReporteHistorial.ID_REPORTE_HISTORIAL := DB_FINANCIERO.SEQ_INFO_REPORTE_HISTORIAL.NEXTVAL;
    Lr_InfoReporteHistorial.EMPRESA_COD          := Lv_EmpresaCod;
    Lr_InfoReporteHistorial.CODIGO_TIPO_REPORTE  := 'RPTCV';
    Lr_InfoReporteHistorial.USR_CREACION         := 'telcos_cancel';
    Lr_InfoReporteHistorial.FE_CREACION          := SYSDATE ;
    Lr_InfoReporteHistorial.EMAIL_USR_CREACION   := '';
    Lr_InfoReporteHistorial.APLICACION           := 'Telcos Job';
    Lr_InfoReporteHistorial.ESTADO               := 'Pendiente';
    Lr_InfoReporteHistorial.OBSERVACION          := 'Ejecucion de reporte de Cancelaciones no Facturadas, Inicio:'||Lr_InfoReporteHistorial.FE_CREACION;
    Lr_InfoReporteHistorial.FE_ULT_MOD           := SYSDATE;

   -- CABECERA DEL REPORTE
    utl_file.put_line(Lfile_Archivo, 'USUARIO'||Lv_Delimitador 
                                     ||'LOGIN'||Lv_Delimitador
                                     ||'SERVICIO'||Lv_Delimitador  
                                     ||'FECHA'||Lv_Delimitador 
                                     ||'MOTIVO'||Lv_Delimitador
                                     ||'VIGENCIA INTERNET'||Lv_Delimitador
                                     ||'OBSERVACION'||Lv_Delimitador );

     FOR ServiciosCancel IN C_GET_SERV_CANC_NOFACT (Pv_PrefijoEmpresa, Lv_EstadoServicio, Lv_AccionHistFact) 
     LOOP
       Ln_ServicioIdCancel := ServiciosCancel.ID_SERVICIO;
       IF Ln_ServicioIdCancel IS NOT NULL THEN
        utl_file.put_line(Lfile_Archivo,NVL(ServiciosCancel.USR_CREACION,'')||Lv_Delimitador
             ||NVL(ServiciosCancel.LOGIN,'')||Lv_Delimitador
             ||NVL(ServiciosCancel.SERVICIO,'')||Lv_Delimitador    
             ||NVL(ServiciosCancel.FE_CREACION,'')||Lv_Delimitador
             ||NVL(ServiciosCancel.MOTIVO,'')||Lv_Delimitador
             ||NVL(ServiciosCancel.FE_ACTIVACION,'')||Lv_Delimitador
             ||NVL(DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_GET_VARCHAR_CLEAN(TRIM(
                                                                                    REPLACE(
                                                                                    REPLACE(
                                                                                    REPLACE(
                                                                                      ServiciosCancel.OBSERVACION, Chr(9), ' '), Chr(10), ' '),
                                                                                      Chr(13), ' '))), '')||Lv_Delimitador  
             );
       END IF;
     END LOOP; 
  UTL_FILE.fclose(Lfile_Archivo);
  DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;  
  DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                            Lv_Destinatario,
                                            Lv_Asunto, 
                                            Lv_Cuerpo, 
                                            Lv_Directorio,
                                            Lv_NombreArchivoZip);
  UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);           

  END P_RPT_CANC_NOFACTURADAS;


  PROCEDURE P_GET_FACTURAS_BY_PTOCARACTID(
      Pn_PuntoId           IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
      Pn_CaracteristicaId  IN  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE,
      Prf_Facturas         OUT SYS_REFCURSOR)
  AS
  BEGIN
    OPEN Prf_Facturas FOR 
      SELECT DISTINCT(CAB.ID_DOCUMENTO) AS ID_DOCUMENTO
      FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  CAB
      JOIN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA  CAR  ON  CAR.DOCUMENTO_ID         = CAB.ID_DOCUMENTO
      JOIN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON  ATDF.ID_TIPO_DOCUMENTO    = CAB.TIPO_DOCUMENTO_ID
      JOIN  DB_COMERCIAL.INFO_PUNTO IPT                       ON  IPT.ID_PUNTO              = CAB.PUNTO_ID
      JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER        ON  IPER.ID_PERSONA_ROL       = IPT.PERSONA_EMPRESA_ROL_ID
      JOIN  DB_COMERCIAL.INFO_PERSONA IPE                     ON  IPE.ID_PERSONA            = IPER.PERSONA_ID
      WHERE IPE.NUMERO_CONADIS IS NULL
      AND   ATDF.CODIGO_TIPO_DOCUMENTO = 'FAC'
      AND   CAB.USR_CREACION           = 'telcos'
      AND   CAB.ES_AUTOMATICA          = 'S'
      AND   CAB.RECURRENTE             = 'S'
      AND   CAB.PUNTO_ID               = Pn_PuntoId            
      AND   CAB.ESTADO_IMPRESION_FACT IN (
                                            SELECT APD.DESCRIPCION
                                            FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
                                            JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                            ON     APD.PARAMETRO_ID       = APC.ID_PARAMETRO
                                            WHERE  APC.NOMBRE_PARAMETRO   = 'ESTADOS_FACTURAS_VALIDAS'
                                            AND    APC.ESTADO             = 'Activo'
                                            AND    APD.ESTADO             = 'Activo'
                                         )
             AND NOT EXISTS (SELECT IDC.* 
                             FROM   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC 
                             WHERE  IDC.CARACTERISTICA_ID = Pn_CaracteristicaId 
                             AND    IDC.DOCUMENTO_ID      = CAB.ID_DOCUMENTO);

    EXCEPTION
    WHEN OTHERS THEN
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR(
                                                     'FNCK_CANCELACION_VOL',
                                                     'FNCK_CANCELACION_VOL.P_GET_FACTURAS_BY_PTOCARACTID',
                                                     ' ERROR '||SQLERRM||'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                                     ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                   );  
  END P_GET_FACTURAS_BY_PTOCARACTID;

  --
  --
  FUNCTION F_GET_DESC_INST_PROMO (Fv_EmpresaCod         IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Fn_IdPunto            IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,                                  
                                  Fn_IdServicio         IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                  Fv_DescProducto       IN  VARCHAR2,
                                  Fn_IdContrato         IN  DB_COMERCIAL.INFO_CONTRATO.ID_CONTRATO%TYPE)
  RETURN NUMBER
  IS
    --Costo: 2
    CURSOR C_GET_MES_ACTUAL  IS
      SELECT TO_CHAR(SYSDATE,'MM') FROM DUAL;

    Ln_Indsx                          NUMBER;
    Ln_PermanenciaMinima              NUMBER := 0;
    Ln_ValorBaseInstalacion           NUMBER := 0;
    Ln_TotalFactInstalacion           NUMBER := 0;
    Ln_PorcentajeDescuentoInstalac    NUMBER := 0;
    Ln_DescuentoPromoIns              NUMBER := 0;
    Lv_TipoMedioActual                VARCHAR2(2); 
    Lv_MesServicioActivo              VARCHAR2(2);

    Lv_FormaPagoActual                VARCHAR2(250);
    Lrt_ArrayValorTotal               T_ValorTotal;
    Lr_ValorTotal                     DB_FINANCIERO.FNKG_TYPES.Lr_ValorTotal;

    Lrf_GetParamFormaPagoEfect        SYS_REFCURSOR ;
    Lr_GetParamFormaPagoEfect         DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE ;

    Lrf_GetParamFormaPagoActual       SYS_REFCURSOR ;
    Lr_GetParamFormaPagoActual        DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE ;

    Lrf_GetParamFormula               SYS_REFCURSOR ;
    Lr_GetParamFormula                DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE ;
    Lrf_Formula                       SYS_REFCURSOR ;   
    Lv_Formula                        VARCHAR2 (4000) ;
    Lv_SqlFormula                     VARCHAR2 (4000) ;
    Ln_IdServicioInst                 DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE;
    Lv_ParamPorcDescInsta             DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'PORCENTAJE_DESCUENTO_INSTALACION'; 
    Lv_EstadoActivo                   DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE                 := 'Activo';
    Lv_ParamCambioFormaPago           DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE       := 'CAMBIO FORMA PAGO';
    Lv_ParamDetFormula                DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE                 := 'FORMULA PROMOCIONAL INSTALACION';
    Lv_TipoPromocion                  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.TIPO_PROMOCION%TYPE := 'PROM_INS';
    Lv_FormaPagoBaseMap               VARCHAR2(8)                                               := 'EFECTIVO';
    Lv_TipoMedioBase                  VARCHAR2 (2)                                              := 'FO'; 

  BEGIN

    IF Fv_DescProducto ='INTERNET' THEN

        Ln_PermanenciaMinima :=  NVL(DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PERMANENCIA_VIGENTE(Fv_EmpresaCod,Fn_IdPunto),0);
        Lv_MesServicioActivo :=  NVL(DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_MESES_ACTIVO(Fn_IdServicio),0);
        Lv_FormaPagoActual   :=  NVL(DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_FORMA_PAGO_ACT(Fn_IdContrato),0);  
        Lv_TipoMedioActual   :=  NVL(DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_TIPOMEDIO(Fn_IdServicio,Lv_EstadoActivo,NULL),'');

        Lrf_GetParamFormaPagoEfect :=  DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamPorcDescInsta, Lv_EstadoActivo, Lv_EstadoActivo,
                                                                                             Lv_TipoMedioActual, Lv_FormaPagoBaseMap, NULL, NULL);
          FETCH Lrf_GetParamFormaPagoEfect INTO Lr_GetParamFormaPagoEfect;
        CLOSE Lrf_GetParamFormaPagoEfect;  

        Ln_ValorBaseInstalacion := TO_NUMBER(NVL(Lr_GetParamFormaPagoEfect.VALOR5,0));

        Ln_DescuentoPromoIns := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_MAPEO_PROMO(Lv_TipoPromocion,Fn_IdServicio);

        IF Ln_DescuentoPromoIns = 0  THEN

          Ln_IdServicioInst    := DB_FINANCIERO.FNCK_CANCELACION_VOL.F_GET_SERVICIO_ID_FACT_INST(Fn_IdPunto);

          IF Ln_IdServicioInst IS NOT NULL THEN

            Ln_DescuentoPromoIns := DB_FINANCIERO.FNCK_CAMBIO_FORMA_PAGO.F_GET_PORCENTAJE_MAPEO_PROMO(Lv_TipoPromocion,Ln_IdServicioInst);

          ELSE

            Ln_DescuentoPromoIns := 0; 

          END IF;

        END IF;

        IF Ln_DescuentoPromoIns = 0  THEN
          --
          Lrf_GetParamFormaPagoActual :=  DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamPorcDescInsta, Lv_EstadoActivo, Lv_EstadoActivo, 
                                                                                                Lv_TipoMedioBase, Lv_FormaPagoActual, NULL, NULL);
            FETCH Lrf_GetParamFormaPagoActual INTO Lr_GetParamFormaPagoActual;
          CLOSE Lrf_GetParamFormaPagoActual;

          Ln_DescuentoPromoIns := NVL(TO_NUMBER(Lr_GetParamFormaPagoActual.VALOR3),0);
          --
        END IF;

        IF Ln_DescuentoPromoIns IS NOT NULL  THEN
          Ln_PorcentajeDescuentoInstalac := NVL(Ln_DescuentoPromoIns/100,0);  
        ELSE
          Ln_PorcentajeDescuentoInstalac := 0;
        END IF;  

        IF Ln_PorcentajeDescuentoInstalac <= 0  THEN
          RETURN 0;
        ELSE
          Lrf_GetParamFormula :=  DB_FINANCIERO.FNCK_CONSULTS.F_GET_ADMI_PARAMETROS_DET(Lv_ParamCambioFormaPago, Lv_EstadoActivo, Lv_EstadoActivo, 
                                                                                        Lv_ParamDetFormula, NULL, 'NULL', 'NULL');
            FETCH Lrf_GetParamFormula INTO Lr_GetParamFormula;
          CLOSE Lrf_GetParamFormula;

          Lv_Formula := REPLACE(Lr_GetParamFormula.VALOR2, 'Ln_ValorInstalacion', Ln_ValorBaseInstalacion);
          Lv_Formula := REPLACE(Lv_Formula, 'Ln_DctoInstalacion', Ln_PorcentajeDescuentoInstalac);
          Lv_Formula := REPLACE(Lv_Formula, 'Ln_MesCambioFormaPago', TO_NUMBER(Lv_MesServicioActivo));
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
            EXIT WHEN Lrf_Formula%NOTFOUND;
        END LOOP;

        IF Ln_TotalFactInstalacion < 0 THEN 
          Ln_TotalFactInstalacion := 0;       
        END IF;
        --
        RETURN Ln_TotalFactInstalacion;

    ELSE

      RETURN Ln_TotalFactInstalacion;

    END IF;

    --
    EXCEPTION
    WHEN OTHERS THEN
      --
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_DESC_INST_PROMO', SQLERRM);
      --
      RETURN 0;
      --
  END F_GET_DESC_INST_PROMO;

FUNCTION F_GET_SERVICIO_ID_FACT_INST(Pn_PuntoId DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE)
  RETURN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  AS
      CURSOR C_FacturasInstXPunto (Cn_PuntoId         DB_COMERCIAL.INFO_SERVICIO.PUNTO_ID%TYPE,
                                   Cv_ContratoDigital DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_ContratoFisico  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_EstadoActivo    VARCHAR2,
                                   Cv_EstadoPendiente VARCHAR2,
                                   Cv_EstadoCerrado   VARCHAR2,
                                   Cv_ValorS          VARCHAR2,
                                   Cn_TipoDocumento   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE) IS
          SELECT
              DET.SERVICIO_ID
          FROM
              DB_COMERCIAL.INFO_SERVICIO ISER,
              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB CAB,
              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET DET,
              DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
              DB_COMERCIAL.ADMI_CARACTERISTICA AC
          WHERE
              CAB.ID_DOCUMENTO     = IDC.DOCUMENTO_ID
              AND CAB.ID_DOCUMENTO = DET.DOCUMENTO_ID
              AND DET.SERVICIO_ID  = ISER.ID_SERVICIO
              AND ISER.PUNTO_ID    = Cn_PuntoId
              AND IDC.CARACTERISTICA_ID = AC.ID_CARACTERISTICA
              AND AC.DESCRIPCION_CARACTERISTICA IN (Cv_ContratoDigital,Cv_ContratoFisico)
              AND AC.ESTADO  = Cv_EstadoActivo
              AND IDC.VALOR  = Cv_ValorS
              AND IDC.ESTADO = Cv_EstadoActivo
              AND CAB.ESTADO_IMPRESION_FACT in(Cv_EstadoPendiente,Cv_EstadoActivo,Cv_EstadoCerrado)
              AND CAB.TIPO_DOCUMENTO_ID = Cn_TipoDocumento;

      Ln_IdServicioFactInst DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE;

    BEGIN
        FOR Lr_FacturasInstXPunto IN C_FacturasInstXPunto (Cn_PuntoId         => Pn_PuntoId,
                                                           Cv_ContratoDigital => 'POR_CONTRATO_DIGITAL',
                                                           Cv_ContratoFisico  => 'POR_CONTRATO_FISICO',
                                                           Cv_EstadoActivo    => 'Activo',
                                                           Cv_EstadoPendiente => 'Pendiente',
                                                           Cv_EstadoCerrado   => 'Cerrado',
                                                           Cv_ValorS          => 'S',
                                                           Cn_TipoDocumento   => 1)
        LOOP
            IF Lr_FacturasInstXPunto.SERVICIO_ID IS NOT NULL THEN
                Ln_IdServicioFactInst:= Lr_FacturasInstXPunto.SERVICIO_ID;
            END IF;
        END LOOP;

        IF C_FacturasInstXPunto%ISOPEN THEN
            CLOSE C_FacturasInstXPunto;
        END IF;

        RETURN Ln_IdServicioFactInst;
    EXCEPTION
        WHEN OTHERS THEN
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('Facturas de instalaci�n',
                                          'FNCK_CANCELACION_VOL.F_GET_SERVICIO_ID_FACT_INST',
                                          'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ||
                                          ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END F_GET_SERVICIO_ID_FACT_INST;

FUNCTION F_GET_DCTO_BY_PRODUCTO(Fn_IdPunto           IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                Fn_IdServicio        IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                Fv_CodigoProducto    IN DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE,
                                Fv_TipoDoc           IN DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE)
  RETURN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.VALOR_FACPRO_DETALLE%TYPE
IS
    -- Costo del Query: 45
    CURSOR C_GET_DCTO_FACT(Cn_PuntoId         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                           Cn_IdServicio      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                           Cv_CodigoProducto  DB_COMERCIAL.ADMI_PRODUCTO.CODIGO_PRODUCTO%TYPE,
                           Cv_TipoDoc         DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE) IS
        SELECT  ROUND(NVL(SUM(A.DESCUENTO_FACPRO_DETALLE * A.CANTIDAD),0), 2) AS VALOR
        FROM(  
              SELECT DET.DESCUENTO_FACPRO_DETALLE , DET.CANTIDAD, DET.ID_DOC_DETALLE
              FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  CAB
              JOIN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET  DET  ON  DET.DOCUMENTO_ID          = CAB.ID_DOCUMENTO
              JOIN  DB_COMERCIAL.ADMI_PRODUCTO                   PRO  ON PRO.ID_PRODUCTO            = DET.PRODUCTO_ID
              JOIN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA  CAR  ON  CAR.DOCUMENTO_ID          = CAB.ID_DOCUMENTO
              JOIN  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ON  ATDF.ID_TIPO_DOCUMENTO    = CAB.TIPO_DOCUMENTO_ID
              JOIN  DB_COMERCIAL.INFO_PUNTO IPT                       ON  IPT.ID_PUNTO              = CAB.PUNTO_ID
              JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET  IDFD  ON  IDFD.DOCUMENTO_ID         = CAB.ID_DOCUMENTO
              JOIN  DB_COMERCIAL.INFO_SERVICIO ISE                    ON  ISE.ID_SERVICIO           = IDFD.SERVICIO_ID
              JOIN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER        ON  IPER.ID_PERSONA_ROL       = IPT.PERSONA_EMPRESA_ROL_ID
              JOIN  DB_COMERCIAL.INFO_PERSONA IPE                     ON  IPE.ID_PERSONA            = IPER.PERSONA_ID
              WHERE IPE.NUMERO_CONADIS IS NULL
              AND   ATDF.CODIGO_TIPO_DOCUMENTO = Fv_TipoDoc
              AND   CAB.ES_AUTOMATICA          = 'S'
              AND   PRO.CODIGO_PRODUCTO        = Cv_CodigoProducto
              AND   CAB.PUNTO_ID               = Cn_PuntoId
              AND   ISE.ID_SERVICIO            = Cn_IdServicio
              AND   CAB.SUBTOTAL_DESCUENTO    <> 0
              AND   DET.DESCUENTO_FACPRO_DETALLE>0
              AND   DET.PRODUCTO_ID            =  (SELECT PROD.ID_PRODUCTO 
                                                   FROM   DB_COMERCIAL.ADMI_PRODUCTO PROD 
                                                   WHERE PROD.CODIGO_PRODUCTO = Cv_CodigoProducto)           
              AND   CAB.ESTADO_IMPRESION_FACT IN (
                                                    SELECT APD.DESCRIPCION
                                                    FROM   DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                    JOIN   DB_GENERAL.ADMI_PARAMETRO_CAB APC
                                                    ON     APD.PARAMETRO_ID       = APC.ID_PARAMETRO
                                                    WHERE  APC.NOMBRE_PARAMETRO   = 'ESTADOS_FACTURAS_VALIDAS'
                                                    AND    APC.ESTADO             = ACTIVO
                                                    AND    APD.ESTADO             = ACTIVO
                                                 )
             AND NOT EXISTS ( SELECT IDC.* 
                              FROM   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                              JOIN   DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = IDC.CARACTERISTICA_ID
                              WHERE  IDC.DOCUMENTO_ID  = CAB.ID_DOCUMENTO
                              AND    AC.DESCRIPCION_CARACTERISTICA IN (SELECT APD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
                                                      JOIN DB_GENERAL.ADMI_PARAMETRO_CAB APC ON APC.ID_PARAMETRO = APD.PARAMETRO_ID
                                                      AND APC.NOMBRE_PARAMETRO = 'SOLICITUDES_DE_CONTRATO' AND APC.ESTADO = ACTIVO) 
                              AND    AC.ESTADO        = ACTIVO)
             AND NOT EXISTS (SELECT IDC.* 
                             FROM   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                             JOIN   DB_COMERCIAL.ADMI_CARACTERISTICA AC ON AC.ID_CARACTERISTICA = IDC.CARACTERISTICA_ID
                             WHERE  IDC.DOCUMENTO_ID              = CAB.ID_DOCUMENTO
                             AND    AC.DESCRIPCION_CARACTERISTICA = 'CAMBIO_FORMA_PAGO' 
                             AND    AC.ESTADO                     = ACTIVO)  
            GROUP BY  DET.DESCUENTO_FACPRO_DETALLE, DET.CANTIDAD, DET.ID_DOC_DETALLE) A;          
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


  OPEN C_GET_DCTO_FACT(Fn_IdPunto,Fn_IdServicio,Fv_CodigoProducto,Fv_TipoDoc);
   FETCH C_GET_DCTO_FACT
     INTO Lc_TotalFacturado;
   CLOSE C_GET_DCTO_FACT;
   Lf_TotalFacturado :=  NVL(Lc_TotalFacturado.VALOR,0);
  --
  RETURN Lf_TotalFacturado;
  --
EXCEPTION
WHEN OTHERS THEN
  DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_DCTO_BY_PRODUCTO', SQLERRM);
  --
END F_GET_DCTO_BY_PRODUCTO;

  FUNCTION F_GET_ID_PTO_TRASLADADO(
      Fn_ServicioId         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
  RETURN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE     
  IS    
    CURSOR C_GetIdServicioTrasladado(Cn_ServicioId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.SERVICIO_ID%TYPE)
    IS
      --
      SELECT  NVL(TO_NUMBER(ISPC.VALOR),0) 
      FROM    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT    ISPC
      JOIN    DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC ON APC.ID_PRODUCTO_CARACTERISITICA = ISPC.PRODUCTO_CARACTERISITICA_ID
      JOIN    DB_COMERCIAL.ADMI_CARACTERISTICA          AC  ON AC.ID_CARACTERISTICA            = APC.CARACTERISTICA_ID
      WHERE   AC.DESCRIPCION_CARACTERISTICA = 'TRASLADO'
      AND     ISPC.SERVICIO_ID              = Cn_ServicioId;

    CURSOR C_GetIdPuntoServicio(Cn_ServicioId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.SERVICIO_ID%TYPE)
    IS
      --
      SELECT IPT.ID_PUNTO
      FROM   DB_COMERCIAL.INFO_PUNTO IPT
      JOIN   DB_COMERCIAL.INFO_SERVICIO ISE ON IPT.ID_PUNTO = ISE.PUNTO_ID  
      WHERE  ISE.ID_SERVICIO = Cn_ServicioId;

    Ln_IdServicioTrasladado      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE:= NULL; 
    Ln_IdPuntoTrasladado         DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE      := NULL;           

    BEGIN

    IF Fn_ServicioId IS NOT NULL AND Fn_ServicioId > 0 THEN
      --
      IF C_GetIdServicioTrasladado%ISOPEN THEN
        CLOSE C_GetIdServicioTrasladado;
      END IF;
      --
      OPEN C_GetIdServicioTrasladado(Fn_ServicioId);
      --
      FETCH C_GetIdServicioTrasladado INTO Ln_IdServicioTrasladado;
      --
      IF Ln_IdServicioTrasladado IS NOT NULL AND Ln_IdServicioTrasladado > 0 THEN

	 IF C_GetIdPuntoServicio%ISOPEN THEN
           CLOSE C_GetIdPuntoServicio;
	 END IF;
         OPEN C_GetIdPuntoServicio(Ln_IdServicioTrasladado);
         FETCH C_GetIdPuntoServicio INTO Ln_IdPuntoTrasladado;
      END IF;
      --
    END IF;

    RETURN Ln_IdPuntoTrasladado;    
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNCK_CANCELACION_VOL','FNCK_CANCELACION_VOL.F_GET_ID_PTO_TRASLADADO', SQLERRM);
    --
    Ln_IdPuntoTrasladado := NULL;
    --
    RETURN Ln_IdPuntoTrasladado; 

  END F_GET_ID_PTO_TRASLADADO;

  PROCEDURE P_SPLIT(
    Pv_Cadena   IN VARCHAR2,
    Pv_Caracter IN VARCHAR2,
    Pr_Arreglo  OUT TypeArreglo
  )
  AS
    Ln_Idx number := 0;
  BEGIN
      FOR CURRENT_ROW IN (
        WITH TEST AS
        (SELECT Pv_Cadena FROM DUAL)
        SELECT regexp_substr(Pv_Cadena, '[^'||Pv_Caracter||']+', 1, ROWNUM) SPLIT
        FROM TEST
        CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_Cadena, '[^'||Pv_Caracter||']+'))  + 1
      )
      LOOP
        Ln_Idx := Ln_Idx + 1;
        Pr_Arreglo(Pr_Arreglo.COUNT) := CURRENT_ROW.SPLIT;
      END LOOP;
  END P_SPLIT;

END FNCK_CANCELACION_VOL;
/

