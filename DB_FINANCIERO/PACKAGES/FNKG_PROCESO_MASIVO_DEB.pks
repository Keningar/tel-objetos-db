CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB AS
  
  TYPE T_ArrayTrama IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
  
  TYPE Gr_FormatoTabla IS RECORD
   (
      Lr_CuentaContableId       DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.CUENTA_CONTABLE_ID%TYPE,
      Lr_CodigoDebito           DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.NUMERO_DOCUMENTO%TYPE,
      Lr_FechaDocumento         DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.FE_DOCUMENTO%TYPE,
      Lr_PorcentajeComisionBco  DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.PORCENTAJE_COMISION_BCO%TYPE,
      Lr_ValorComisionBco       DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.VALOR_COMISION_BCO%TYPE,
      Lr_ContieneRetencionF     DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.CONTIENE_RETENCION_FTE%TYPE,
      Lr_ContieneRetencionI     DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.CONTIENE_RETENCION_IVA%TYPE,
      Lr_ValorRetencionF        DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.VALOR_RETENCION_FUENTE%TYPE,
      Lr_ValorRetencionI        DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.VALOR_RETENCION_IVA%TYPE,
      Lr_ValorNeto              DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.VALOR_NETO%TYPE,
      Lv_PrefijoEmpresa         VARCHAR2(20)
  );
  
  TYPE T_FormatoTabla IS TABLE OF Gr_FormatoTabla INDEX BY BINARY_INTEGER;
  
  /* VARIABLES GLOBALES */
  Lt_FormatoTabla T_FormatoTabla;
  
  
  /**
  * Documentacion para el procedimiento P_PROCESAR_DEBITOS_P
  *
  * M�todo principal que procesa los debitos pendientes.
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 30-11-2017 - Se modifica la llamada a la funci�n F_INSERT_DEBITO_GENERAL_HIST.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.2 17-04-2020 - Se modifica cursor 'C_Facturas' y a�ade query que permita obtener las NDI con caracter�stica de  
  *                            diferido, y si corresponde a la misma fecha de creaci�n con las facturas, se presente en el listado 
  *                            como prioridad la NDI.
  * Costo query C_Facturas: 69
  *
  * @author H�ctor Lozano <hlozano@telconet.ec>
  * @version 1.3 02-05-2020 - Se modifica para obtener el Tipo de Escenario y Filtro correspondiente al proceso.
  *                           ESCENARIO_BASE: Escenario basado en la generaci�n de los d�bitos de los clientes con saldo pendiente 
  *                            de sus facturas activas.               
  *                           ESCENARIO_1: Escenario basado en la generaci�n de los d�bitos de los clientes que tengan un saldo pendiente 
  *                            de su factura recurrente mensual, emitida de acuerdo con cada ciclo.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.4 03-07-2020 - Se agrega sentencia CLOSE para cerrar el cursor de los documentos obtenidos para realizar los pagos.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.5 07-07-2020 - Se modifica validaci�n de escenario 1, para consultar facturas por cliente. Se elimina bucle For que
  *                            consultaba facturas por punto.
  *                         - Se modifica consulta de los puntos que van hacer reactivados considerando el valor permisible con
  *                            respecto al saldo.
  *                         - Se modifica para obtener el Tipo de Escenario y Filtro correspondiente al proceso.
  *                           ESCENARIO_3: Escenario basado en la generaci�n de los d�bitos de los clientes que tengan un saldo de las NDI Diferidas,
  *                                        que se encuentren pendiente de pago.
  *
  * Costo Query C_InfoPunto: 222
  * Costo Query C_ObtieneValorPermisible: 3
  *
  */
  PROCEDURE P_PROCESAR_DEBITOS_P;
  
  
  /**
  * Documentacion para la funci�n F_GET_NUMERACION
  *
  * M�todo encargado de obtener la numeraci�n respectiva del pago a realizar.
  *
  * @param Fn_IdEmpresa     IN  NUMBER Recibe el id de la empresa
  * @param Fn_IdOficina     IN  NUMBER Recibe el id de la oficina
  * @param Fv_Parametro     IN  VARCHAR2 Recibe el c�digo del parametro 
  * @param Fv_NombreProceso OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Fv_Error         OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @return VARCHAR2 Retorna la numeraci�n
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */
  FUNCTION F_GET_NUMERACION(
      Fn_IdEmpresa      IN  NUMBER,
      Fn_IdOficina      IN  NUMBER,
      Fv_Parametro      IN  VARCHAR2,
      Fv_NombreProceso  OUT VARCHAR2,
      Fv_Error          OUT VARCHAR2)
    RETURN VARCHAR2;
  
  
  /**
  * Documentacion para la funci�n F_GET_TIPO_DOCUMENTO
  *
  * M�todo encargado de obtener el tipo de documento
  *
  * @param Fv_TipoDocumento IN  VARCHAR2 Recibe el c�digo del tipo de documento
  * @param Fv_Estado        IN  VARCHAR2 Recibe el estado sea este Activo o Inactivo
  * @param Fv_NombreProceso OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Fv_Error         OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @return NUMBER Retorna el id del tipo de documento
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */  
  FUNCTION F_GET_TIPO_DOCUMENTO(
      Fv_TipoDocumento  IN  VARCHAR2,
      Fv_Estado         IN  VARCHAR2,
      Fv_NombreProceso  OUT VARCHAR2,
      Fv_Error          OUT VARCHAR2)
    RETURN NUMBER;
  
  
  /**
  * Documentacion para la funci�n F_INSERT_DEBITO_GENERAL_HIST
  *
  * M�todo encargado de crear el historial del debito general y retornar el id respectivo
  *
  * @param Fr_InfoDebitoGeneralHist IN  DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL%ROWTYPE.
  * @param Fv_NombreProceso         OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Fv_Error                 OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @return NUMBER Retorna el id del historial del debito general creado
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  *
  * @author Luis Cabrera <lcabrera@telconet.ec>
  * @version 1.1 29-11-2017 - Se cambia el nombre de la funci�n.
  *                         - Se cambian los par�metros de la funci�n.
  */ 
  FUNCTION F_INSERT_DEBITO_GENERAL_HIST(
      Fr_InfoDebitoGeneralHist  IN  DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL%ROWTYPE,
      Fv_NombreProceso          OUT VARCHAR2,
      Fv_Error                  OUT VARCHAR2)
    RETURN NUMBER;
  
  
  /**
  * Documentacion para la funci�n F_GET_TOTAL_PAG_NC
  *
  * M�todo encargado de obtener la sumatoria de los pagos realizados por el cliente y las notas de creditos creadas
  *
  * @param Fn_IdFactura     IN  NUMBER Recibe el id de la factura
  * @param Fv_NombreProceso OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Fv_Error         OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @return NUMBER Retorna la sumatoria de los pagos + las notas de credito
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */   
  FUNCTION F_GET_TOTAL_PAG_NC(
      Fn_IdFactura      IN  NUMBER,
      Fv_NombreProceso  OUT VARCHAR2,
      Fv_Error          OUT VARCHAR2)
    RETURN NUMBER;
  
  
  /**
  * Documentacion para el procedimiento P_SET_FACTURA_ESTADO
  *
  * M�todo encargado de actualizar el estado de la factura
  *
  * @param Pn_IdFactura     IN  NUMBER   Recibe el id de la factura
  * @param Pv_Estado        IN  VARCHAR2 Recibe el estado
  * @param Pv_NombreProceso OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error         OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */   
  PROCEDURE P_SET_FACTURA_ESTADO(
      Pn_IdFactura      IN  NUMBER,
      Pv_Estado         IN  VARCHAR2,
      Pv_NombreProceso  OUT VARCHAR2,
      Pv_Error          OUT VARCHAR2);
  
  
  /**
  * Documentacion para el procedimiento P_CREA_FACTURA_HISTORIAL
  *
  * M�todo encargado de crear el historial de la factura
  *
  * @param Pn_IdFactura       IN  NUMBER   Recibe el id de la factura
  * @param Pv_Estado          IN  VARCHAR2 Recibe el estado
  * @param Pv_UsuarioCreacion IN  VARCHAR2 Recibe el usuario que esta ejecutando el proceso masivo
  * @param Pv_NombreProceso   OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */     
  PROCEDURE P_CREA_FACTURA_HISTORIAL(
      Pn_IdFactura       IN  NUMBER,
      Pv_Estado          IN  VARCHAR2,
      Pv_UsuarioCreacion IN  VARCHAR2,
      Pv_NombreProceso   OUT VARCHAR2,
      Pv_Error           OUT VARCHAR2);
  
  
  /**
  * Documentacion para la funci�n F_CREA_PAGO
  *
  * M�todo encargado de crear el pago
  *
  * @param Fn_PuntoId           IN  NUMBER Recibe el punto id del cliente
  * @param Fn_OficinaId         IN  NUMBER Recibe la oficina
  * @param Fn_EmpresaId         IN  VARCHAR2 Recibe el id de la empresa
  * @param Fn_DebitoDetId       IN  NUMBER Recibe el id del detalle del debito
  * @param Fv_NumeroPago        IN  VARCHAR2 Recibe el numero del pago (Secuencia)
  * @param Fn_ValorTotal        IN  NUMBER Recibe el valor del pago realizado
  * @param Fv_EstadoPago        IN  VARCHAR2 Recibe el estado del pago
  * @param Fcl_ComentarioPago   IN  CLOB Recibe el comentario del pago
  * @param Fv_UsuarioCreacion   IN  VARCHAR2 Recibe el usuario que esta ejecutando el proceso masivo
  * @param Fn_TipoDocumentoId   IN  NUMBER Recibe el id del tipo de documento
  * @param Fn_DebitoGeneralHist IN  NUMBER Recibe el id del historial del debito general
  * @param Fv_NombreProceso     OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Fv_Error             OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @return NUMBER Retorna el id del pago realizado
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */    
  FUNCTION F_CREA_PAGO(
      Fn_PuntoId           IN  NUMBER,
      Fn_OficinaId         IN  NUMBER,
      Fn_EmpresaId         IN  VARCHAR2,
      Fn_DebitoDetId       IN  NUMBER,
      Fv_NumeroPago        IN  VARCHAR2,
      Fn_ValorTotal        IN  NUMBER,
      Fv_EstadoPago        IN  VARCHAR2,
      Fcl_ComentarioPago   IN  CLOB,
      Fv_UsuarioCreacion   IN  VARCHAR2,
      Fn_TipoDocumentoId   IN  NUMBER,
      Fn_DebitoGeneralHist IN  NUMBER,
      Fv_NombreProceso     OUT VARCHAR2,
      Fv_Error             OUT VARCHAR2)
    RETURN NUMBER;
  
  
  /**
  * Documentacion para el procedimiento P_CREA_DETALLE_PAGO
  *
  * M�todo encargado de crear el detalle del pago
  *
  * @param Pn_IdPago            IN  NUMBER Recibe el id del pago
  * @param Pv_FechaProceso      IN  DATE Recibe la fecha del proceso
  * @param Pv_UsuarioCreacion   IN  VARCHAR2 Recibe el usuario que esta ejecutando el proceso masivo
  * @param Pn_FormaPago         IN  NUMBER Recibe el id de la forma de pago
  * @param Pn_ValorPago         IN  NUMBER Recibe el valor del pago
  * @param Pn_BancoTipoCuenta   IN  NUMBER Recibe el id del tipo de cuenta del banco
  * @param Pv_NumerReferencia   IN  VARCHAR2 Recibe el codigo del proceso masivo
  * @param Pv_NumeroCuentaBanco IN  VARCHAR2 Recibe el numero de cuenta del banco
  * @param Pv_Comentario        IN  VARCHAR2 Recibe el comentadio
  * @param Pv_Estado            IN  VARCHAR2 Recibe el estado
  * @param Pn_ReferenciaId      IN  NUMBER Recibe el id de la factura
  * @param Pv_NombreProceso     OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error             OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */     
  PROCEDURE P_CREA_DETALLE_PAGO(
      Pn_IdPago            IN  NUMBER,
      Pv_FechaProceso      IN  DATE,
      Pv_UsuarioCreacion   IN  VARCHAR2,
      Pn_FormaPago         IN  NUMBER,
      Pn_ValorPago         IN  NUMBER,
      Pn_BancoTipoCuenta   IN  NUMBER,
      Pv_NumerReferencia   IN  VARCHAR2,
      Pv_NumeroCuentaBanco IN  VARCHAR2,
      Pv_Comentario        IN  VARCHAR2,
      Pv_Estado            IN  VARCHAR2,
      Pn_ReferenciaId      IN  NUMBER,
      Pv_NombreProceso     OUT VARCHAR2,
      Pv_Error             OUT VARCHAR2);
  
  
  /**
  * Documentacion para la funci�n F_GET_FORMA_PAGO
  *
  * M�todo encargado de obtener la forma de pago
  *
  * @param Fv_CodigoFormaPago IN  NUMBER Recibe el codigo de la forma de pago
  * @param Fv_Estado          IN  NUMBER Recibe el estado
  * @param Fv_NombreProceso   OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Fv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @return NUMBER Retorna el id de la forma de pago
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */     
  FUNCTION F_GET_FORMA_PAGO(
      Fv_CodigoFormaPago IN  VARCHAR2,
      Fv_Estado          IN  VARCHAR2,
      Fv_NombreProceso   OUT VARCHAR2,
      Fv_Error           OUT VARCHAR2)
    RETURN NUMBER;
  
  
  /**
  * Documentacion para el procedimiento P_SEPARA_TRAMA_OBSERVACION
  *
  * M�todo encargado de separar la observacion que viene separa por  | desde el telcos
  *
  * @param Pv_Trama_Obs     IN  VARCHAR2 Recibe la trama
  * @param Pv_NombreProceso OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error         OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */    
  PROCEDURE P_SEPARA_TRAMA_OBSERVACION(
    Pv_Trama_Obs     IN  VARCHAR2,
    Pv_NombreProceso OUT VARCHAR2,
    Pv_Error         OUT VARCHAR2);
  
  
  /**
  * Documentacion para el procedimiento P_CREA_HISTORIAL_PAGO
  *
  * M�todo encargado de crear el historial del pago
  *
  * @param Pn_IdPago          IN  VARCHAR2 Recibe el id del pago
  * @param Pv_Estado          IN  VARCHAR2 Recibe el estado
  * @param Pv_UsuarioCreacion IN  VARCHAR2 Recibe el usuario que esta ejecutando el proceso masivo
  * @param Pv_Motivo          IN  VARCHAR2 Recibe el motivo
  * @param Pv_Comentario      IN  VARCHAR2 Recibe el comentario
  * @param Pv_NombreProceso   OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */    
  PROCEDURE P_CREA_HISTORIAL_PAGO(
    Pn_IdPago          IN  NUMBER,
    Pv_Estado          IN  VARCHAR2,
    Pv_UsuarioCreacion IN  VARCHAR2,
    Pv_Motivo          IN  VARCHAR2,
    Pv_Comentario      IN  VARCHAR2,
    Pv_NombreProceso   OUT VARCHAR2,
    Pv_Error           OUT VARCHAR2);
  
  
  /**
  * Documentacion para el procedimiento P_SET_VALOR_TOTAL_PAGO
  *
  * M�todo encargado de actualizar el valor total del pago
  *
  * @param Pn_IdPago          IN  VARCHAR2 Recibe el id del pago
  * @param Pn_ValorTotal      IN  VARCHAR2 Recibe el valor total del pago que se debe actualizar
  * @param Pv_NombreProceso   OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */  
  PROCEDURE P_SET_VALOR_TOTAL_PAGO(
    Pn_IdPago        IN  NUMBER,
    Pn_ValorTotal    IN  NUMBER,
    Pv_NombreProceso OUT VARCHAR2,
    Pv_Error         OUT VARCHAR2);
  
  
  /**
  * Documentacion para la funci�n F_GET_PADRE_FACTURACION
  *
  * M�todo encargado de obtener el padre de facturacion del cliente
  *
  * @param Fn_PersonaEmpRolId IN  NUMBER Recibe el id de la persona empresa rol
  * @param Fv_NombreProceso   OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Fv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @return NUMBER Retorna el id del punto
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */   
  FUNCTION F_GET_PADRE_FACTURACION(
      Fn_PersonaEmpRolId IN  NUMBER,
      Fv_NombreProceso   OUT VARCHAR2,
      Fv_Error           OUT VARCHAR2)
    RETURN NUMBER;
  
  
  /**
  * Documentacion para el procedimiento P_SET_DEBITO_DET
  *
  * M�todo encargado de actualizar la informacion del detalle del debito
  *
  * @param Pn_IdDebitoDet     IN  NUMBER Recibe el id del detalle del debito
  * @param Pv_Estado          IN  VARCHAR2 Recibe el estado
  * @param Pv_UsuarioCreacion IN  VARCHAR2 Recibe el usuario que esta ejecutando el proceso masivo
  * @param Pn_ValorTotal      IN  NUMBER Recibe el valor debitado del cliente
  * @param Fv_NombreProceso   OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Fv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */
  PROCEDURE P_SET_DEBITO_DET(
      Pn_IdDebitoDet     IN  NUMBER,
      Pv_Estado          IN  VARCHAR2,
      Pv_UsuarioCreacion IN  VARCHAR2,
      Pn_ValorTotal      IN  NUMBER,
      Pv_NombreProceso   OUT VARCHAR2,
      Pv_Error           OUT VARCHAR2);
  
  
  /**
  * Documentacion para el procedimiento P_CONTABILIZA_DEB
  *
  * M�todo encargado de actualizar la informacion del detalle del debito
  *
  * @param Pv_PrefijoEmpresa    IN  NUMBER Recibe el prefijo de la empresa
  * @param Pn_DebitoGeneralHist IN  VARCHAR2 Recibe el id del historial del debito general
  * @param Pv_EmpresaId         IN  VARCHAR2 Recibe el id de la empresa
  * @param Pv_NombreProceso     OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error             OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */    
  PROCEDURE P_CONTABILIZA_DEB(
      Pv_PrefijoEmpresa    IN  VARCHAR2,
      Pn_DebitoGeneralHist IN  NUMBER,
      Pv_EmpresaId         IN  VARCHAR2,
      Pv_NombreProceso     OUT VARCHAR2,
      Pv_Error             OUT VARCHAR2);
  
  
  /**
  * Documentacion para el procedimiento P_SET_PROCESO_MASI_EST
  *
  * M�todo encargado de actualizar el estado del proceso masivo
  *
  * @param Pn_IdProcesoMasivo IN  NUMBER Recibe el id del proceso masivo
  * @param Pv_Estado          IN  VARCHAR2 Recibe el estado
  * @param Pv_NombreProceso   OUT VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Error           OUT VARCHAR2 Retorna un mensaje de error en caso de existir
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  */      
  PROCEDURE P_SET_PROCESO_MASI_EST(
      Pn_IdProcesoMasivo  IN NUMBER,
      Pv_Estado           IN VARCHAR2,
      Pv_NombreProceso   OUT VARCHAR2,
      Pv_Error           OUT VARCHAR2);
  
  
  /**
  * Documentacion para el procedimiento P_REACTIVAR_PUNTOS
  *
  * M�todo encargado de la reactivacion de los puntos por medio de un Web Service
  *
  * @param PT_PUNTO               IN T_ArrayTrama   Recibe el id de la factura
  * @param Pv_PrefijoEmpresa      IN VARCHAR2 Recibe el estado
  * @param Pv_EmpresaId           IN VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pn_OficinaId           IN VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_UsuarioCreacion     IN VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pv_Ip                  IN VARCHAR2 Retorna el nombre del proceso en caso de existir un error
  * @param Pn_DebitoCabId         IN VARCHAR2 Retorna un mensaje de error en caso de existir
  * @param Pn_ProcesoMasivoCabId  IN NUMBER Recibe el Id de Info_Proceso_Masivo_Cab
  *
  * @author Germ�n Valenzuela <gvalenzuela@telconet.ec>
  * @version 1.0 25-09-2017
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.1 22-10-2018 - Se agrea parametro Pn_ProcesoMasivoCabId y se guarda registro en la tabla INFO_PROCESO_MASIVO_DET.
  */      
  PROCEDURE P_REACTIVAR_PUNTOS(
      PT_PUNTO              IN T_ArrayTrama,
      Pv_PrefijoEmpresa     IN VARCHAR2,
      Pv_EmpresaId          IN VARCHAR2,
      Pn_OficinaId          IN NUMBER,
      Pv_UsuarioCreacion    IN VARCHAR2,
      Pv_Ip                 IN VARCHAR2,
      Pn_DebitoCabId        IN NUMBER,
      Pn_ProcesoMasivoCabId IN NUMBER);

  /**
  * Documentaci�n para la funci�n F_GET_FORMATO_CUENTA
  *
  * Funci�n encargada de realizar el formato definido en el reporte tributario Banco Guayaquil.
  *
  * @param Fv_CuentaEncriptada   IN NUMBER Recibe el n�mero de cuenta del cliente encriptada.
  * @param Fv_ClaveDescencriptar IN VARCHAR2 Recibe la clave secreta para desecriptar tarjetas.
  * @param Fn_idPersonaRol       IN NUMBER Recibe el id persona rol del cliente.
  *
  * Costo del query C_ParamConstante: 3
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 02-04-2020
  */      
  FUNCTION F_GET_FORMATO_CUENTA(
      Fv_CuentaEncriptada   IN VARCHAR2,
      Fv_ClaveDescencriptar IN VARCHAR2,
      Fn_idPersonaRol       IN NUMBER)
    RETURN VARCHAR2;   
    
  /**
  * Documentaci�n para el procedimiento P_REPORTE_TRIBUTARIO.
  *
  * Procedimiento que me permite generar el reporte tributario para banco Guayaquil seg�n  
  * par�metros enviados.
  *
  * @param Pv_FechaReporteDesde IN VARCHAR2 Recibe rango inicial para consulta por fecha de creaci�n.
  * @param Pv_FechaReporteHasta IN VARCHAR2 Recibe rango final para consulta por fecha de creaci�n.
  * @param Pv_EmpresaCod        IN VARCHAR2 Recibe empresa a generar el reporte.
  * @param Pv_UsuarioSesion     IN VARCHAR2 Recibe usuario en sesion.
  * @param Pv_ClaveSecret       IN VARCHAR2 Recibe la clave secreta para desencriptar tarjetas.
  *
  * Costo del query C_CorreoUsuario: 7
  * Costo del query C_GetImpuesto: 2
  * Costo del query C_PagosPorDebitos: 80
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 02-04-2020
  */     
  PROCEDURE P_REPORTE_TRIBUTARIO(
      Pv_FechaReporteDesde IN VARCHAR2,
      Pv_FechaReporteHasta IN VARCHAR2,
      Pv_EmpresaCod        IN VARCHAR2,
      Pv_UsuarioSesion     IN VARCHAR2,
      Pv_ClaveSecret       IN VARCHAR2);   

 /**
  * Documentaci�n para la funci�n P_GET_FACT_MENS_FILTRO_FECHA.
  *
  * Procedimiento encargado de retornar el listado de facturas abiertas mensuales autom�ticas por filtro 
  * de fecha para el escenario 1 para la subida de respuesta de d�bitos.
  *
  * @param Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE  (Recibe id_persona_rol del cliente).
  * @param Pv_FiltroFecha  IN  VARCHAR2     (Recibe el filtro de fecha para el escenario 1).
  * @param Pv_EmpresaId    IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE     (Recibe el id de la empresa).
  * @param Pr_Facturas     OUT SYS_REFCURSOR    (Retorna listado de facturas abiertas).
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 23-05-2020
  *
  * Costo Query: 7
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 07-07-2020 - Se modifica query principal para listar los documentos financieros por escenario 1.
  *
  * Costo Query: 11
  */     
  PROCEDURE P_GET_FACT_MENS_FILTRO_FECHA(Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                         Pv_FiltroFecha  IN  VARCHAR2,
                                         Pv_EmpresaId    IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                                         Pr_Facturas     OUT SYS_REFCURSOR); 

/**
  * Documentaci�n para la funci�n P_CLIENTES_DEBITO_FACT_MENS.
  *
  * Procedimiento encargado de retornar el listado de clientes que tengan un saldo pendiente de su factura recurrente mensual 
  * emitida de acuerdo con cada ciclo, �sta fecha ser� recibida como par�metro de acuerdo al filtro correspondiente al escenario 1
  * para la generaci�n de los d�bitos.  
  *
  * @param Pv_IdEmpresa              IN  VARCHAR2       Recibe IdEmpresa.
  * @param Pn_IdBancoTipoCuenta      IN  NUMBER         Recibe IdBancoTipoCuenta, Id del Banco tipo cuenta del cu�l se va a crear el d�bito.
  * @param Pn_IdBancoTipoCuentaGrupo IN  NUMBER         Recibe IdBancoTipoCuentaGrupo,grupo al cu�l pertenece el banco con el que se crea el d�bito.
  * @param Pn_IdOficina              IN  NUMBER         Recibe IdOficina, a la cu�l pertenece el debito.
  * @param Pn_IdCiclo                IN  NUMBER         Recibe id del ciclo del cliente.
  * @param Pv_FiltroFecha            IN  VARCHAR2       Recibe filtro de fecha para el escenario 1.
  * @param Pr_Clientes               OUT SYS_REFCURSOR  Retorna listado de clientes para d�bito.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 27-05-2020
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.1 19-06-2020 - Se agrega estado �PorAutorizar� en el where del estado de Contrato del Cliente del query principal,
  *                           para excluir al cliente con ese estado de contrato al momento de generar los D�bitos.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.2 30-11-2020 - Se modifica y agrega subconsulta de los estados de contrato parametrizados en el where del query principal
  *                           para excluir al cliente con ese estado de contrato al momento de generar los D�bitos. 
  *
  * Costo del query C_CicloCaract: 2 
  * Costo del query C_GetImpuesto: 2 
  * Costo del query Principal: 49
  */     
  PROCEDURE P_CLIENTES_DEBITO_FACT_MENS(Pv_IdEmpresa              IN VARCHAR2,
                                        Pn_IdBancoTipoCuenta      IN NUMBER,
                                        Pn_IdBancoTipoCuentaGrupo IN NUMBER,
                                        Pn_IdOficina              IN NUMBER,
                                        Pn_IdCiclo                IN NUMBER,
                                        Pv_FiltroFecha            IN VARCHAR2,
                                        Pr_Clientes               OUT SYS_REFCURSOR );  

 /**
  * Documentaci�n para TYPE 'Lr_FacturasProcesar'.
  */
  TYPE Lr_FacturasProcesar IS RECORD (
    ID_DOCUMENTO            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    ESTADO_IMPRESION_FACT   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    NUMERO_FACTURA_SRI      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    VALOR_TOTAL             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    PUNTO_ID                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
    FE_CREACION             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.FE_CREACION%TYPE,
    TIPO_DOCUMENTO_ID       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.TIPO_DOCUMENTO_ID%TYPE 
  );


 /**
  * Documentaci�n para TYPE 'T_FacturasProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 02-05-2020
  */
  TYPE T_FacturasProcesar IS TABLE OF Lr_FacturasProcesar INDEX BY PLS_INTEGER;     

 /**
  * Documentaci�n para la funci�n F_PROCESA_DOC_VALOR_PAGADO.
  *
  * Funci�n encargada de procesar las facturas.
  *
  * @param Frf_Facturas           IN SYS_REFCURSOR Recibe las facturas a procesar.
  * @param Fn_ValorPagado         IN NUMBER        Recibe el valor de pago del d�bito.
  * @param Fv_EmpresaId           IN NUMBER        Recibe el id_empresa.
  * @param Fv_IdOficina           IN VARCHAR2      Recibe el id_oficina.
  * @param Fn_IdDebitoDet         IN NUMBER        Recibe el id_debito_det.
  * @param Fn_IdFormaPago         IN NUMBER        Recibe el id_forma_pago.
  * @param Fv_UsrCreacion         IN VARCHAR2      Recibe el usuario de creaci�n.
  * @param Fn_IdDebitoGeneralH    IN NUMBER        Recibe el id_debito_general_historial.
  * @param Fn_IdBancoTipoCuenta   IN NUMBER        Recibe el id_banco_tipo_cuenta.
  * @param Fv_NumeroTarjetaCuenta IN VARCHAR2      Recibe el n�mero de tarjeta del cliente.
  *
  * @author H�ctor Lozano <hlozano@telconet.ec>
  * @version 1.0 02-05-2020
  */                             
  FUNCTION F_PROCESA_DOC_VALOR_PAGADO(Frf_Facturas             IN SYS_REFCURSOR,
                                      Fn_ValorPagado           IN NUMBER,
                                      Fv_EmpresaId             IN NUMBER,
                                      Fv_IdOficina             IN VARCHAR2,
                                      Fn_IdDebitoDet           IN NUMBER,
                                      Fn_IdFormaPago           IN NUMBER,
                                      Fv_UsrCreacion           IN VARCHAR2,
                                      Fn_IdDebitoGeneralH      IN NUMBER,
                                      Fn_IdBancoTipoCuenta     IN NUMBER,
                                      Fv_NumeroTarjetaCuenta   IN VARCHAR2
                                      )
  RETURN NUMBER;        
  
 /**
  * Documentaci�n para PROCEDURE P_GET_FACTURAS_X_CLIENTE.
  *
  * Funci�n encargada de consultar las facturas del cliente.
  *
  * @param Fn_EmpresaId    IN NUMBER  Recibe el id de la empresa.
  * @param Fn_PersonaRolId IN NUMBER  Recibe el id_persona_rol del cliente.
  *
  * @author H�ctor Lozano <hlozano@telconet.ec>
  * @version 1.0 02-05-2020
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 25-06-2020 - Se agrega sentencia "UNION ALL" al query principal que obtiene las 
  *                            facturas/NDI diferidas por cliente.
  * 
  * Costo query: 471
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.2 04-07-2020 - Se modifica query principal para obtener las facturas/NDI diferidas por cliente. 
  *                         - Se elimina sentencia TRUNC del ordenamiento por fecha.
  * 
  * Costo query: 28
  *
  */
  PROCEDURE P_GET_FACTURAS_X_CLIENTE(Pn_EmpresaId    IN  NUMBER, 
                                     Pn_PersonaRolId IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                     Prf_FactCliente OUT SYS_REFCURSOR);

 /**
  * Documentaci�n para funci�n 'F_ULT_FACT_DIF_VALOR_CLIENTE'.
  * Funci�n que obtiene valor � id_documento � subtotal de la �ltima Factura diferida de un cliente.
  *
  * Costo del query dentro de funci�n.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 18-06-2020
  *
  * PAR�METROS:
  * @param Fn_IdPersona     IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE   (Recibe el id_persona)
  * @param Fv_CampoConsulta IN VARCHAR2 (Recibe campo que se desea consultar)
  * @param Fn_EmpresaCod    IN NUMBER   (Recibe c�digo de empresa)
  * @return NUMBER  Retorna el valor que dese� consultar.
  */
  FUNCTION F_ULT_FACT_DIF_VALOR_CLIENTE(Fn_IdPersona     IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE, 
                                        Fv_CampoConsulta IN VARCHAR2, 
                                        Fn_EmpresaCod    IN NUMBER)
  RETURN NUMBER;
  
 /**
  * Documentaci�n para funci�n 'F_ULT_FACT_DIF_CADENA_CLIENTE'.
  * Funci�n que obtiene n�mero de factura sri de la �ltima Factura diferida de un cliente.
  *
  * Costo del query dentro de funci�n.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 18-06-2020
  *
  * PAR�METROS:
  * @param Fn_IdPersona     IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE   (id_persona del cliente)
  * @param Fn_EmpresaCod    IN NUMBER   (c�digo de la empresa)
  * @param Fv_CampoConsulta IN VARCHAR2 (campo que se desea consultar)
  * @return VARCHAR2  Retorna el valor que dese� consultar.
  */
  FUNCTION F_ULT_FACT_DIF_CADENA_CLIENTE(Fn_IdPersona     IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                         Fn_EmpresaCod    IN NUMBER,
                                         Fv_CampoConsulta IN VARCHAR2)
  RETURN VARCHAR2;

 /**
  * Documentaci�n para funci�n 'F_ULT_FACT_DIF_FECHA_CLIENTE'.
  * Funci�n que obtiene fecha de emisi�n de la �ltima Factura diferida de un cliente.
  *
  * Costo del query dentro de funci�n.
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 18-06-2020
  *
  * PAR�METROS:
  * @param Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE   (id_persona del cliente)
  * @param Fn_EmpresaCod IN NUMBER   (c�digo de Empresa)
  * @return DATE  Retorna la fecha de la �ltima factura diferida.
  */
  FUNCTION F_ULT_FACT_DIF_FECHA_CLIENTE(Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                        Fn_EmpresaCod IN NUMBER)
  RETURN DATE;

 /**
  * Documentaci�n para FUNCION 'F_ULT_FACT_DIF_NUMAUT_CLIENTE'.
  * Funci�n que obtiene n�mero autorizaci�n de la �ltima Factura diferida de un cliente.
  *
  * Costo del query: 10
  * 
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 18-06-2020
  *
  * PAR�METROS:
  * @param Fn_IdPersona   IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE   (id_persona del cliente)
  * @param Fn_EmpresaCod  IN NUMBER   (c�digo de Empresa)
  * @return VARCHAR2  Retorna n�mero autorizaci�n de la �ltima factura diferida de un cliente.
  */
  FUNCTION F_ULT_FACT_DIF_NUMAUT_CLIENTE(Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                         Fn_EmpresaCod IN NUMBER)
  RETURN VARCHAR2;

 /**
  * Documentaci�n para FUNCION 'F_PORCENTAJE_IMP_PROC_DIF'.
  * Funci�n que obtiene el porcentaje de impuesto Iva.
  *
  * Costo del query C_GetPorcentajeImp: 8
  * 
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 23-06-2020
  *
  * PAR�METROS:
  * @param Fn_IdPersona IN NUMBER     (id_persona del cliente)
  * @param Fn_EmpresaCod  IN NUMBER   (c�digo de Empresa)
  * @return NUMBER  Retorna porcentaje de impuesto a calcular.
  */
  FUNCTION F_PORCENTAJE_IMP_PROC_DIF(Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                     Fn_EmpresaCod IN NUMBER)
  RETURN NUMBER;

 /**
  * Documentaci�n para la funci�n P_CLIENTES_DEBITO_NDI.
  *
  * Procedimiento encargado de retornar el listado de clientes que tengan saldo de las NDI Diferida que se encuentren pendiente de pago, 
  * se env�a como par�metro adicional el n�mero de cuotas NDI Diferida para debitar el saldo correspondiente.
  *
  * Costo del query C_CicloCaract: 2 
  * Costo del query C_GetImpuesto: 2 
  * Costo del query Principal: 254
  *
  * @param Pv_IdEmpresa              IN  VARCHAR2       Recibe IdEmpresa.
  * @param Pn_IdBancoTipoCuenta      IN  DB_FINANCIERO.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE  
  *                                      (Recibe IdBancoTipoCuenta, Id del Banco tipo cuenta del cu�l se va a crear el d�bito.)
  * @param Pn_IdBancoTipoCuentaGrupo IN  DB_FINANCIERO.ADMI_GRUPO_ARCHIVO_DEBITO_CAB.ID_GRUPO_DEBITO%TYPE
  *                                      (Recibe IdBancoTipoCuentaGrupo,grupo al cu�l pertenece el banco con el que se crea el d�bito.)
  * @param Pn_IdOficina              IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE
  *                                      (Recibe IdOficina, a la cu�l pertenece el d�bito.)
  * @param Pn_IdCiclo                IN  DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE       
  *                                      (Recibe id del ciclo del cliente.)
  * @param Pv_FiltroNumCuotas        IN  VARCHAR2       Recibe filtro de n�mero de cuotas NDI diferidas a procesar para el escenario 3.
  *
  * @param Pr_Clientes               OUT SYS_REFCURSOR  Retorna listado de clientes para d�bito.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.0 18-06-2020
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.1 30-11-2020 - Se modifica y agrega subconsulta de los estados de contrato parametrizados en el where del query principal 
  *                           para excluir al cliente con ese estado de contrato al momento de generar los D�bitos.
  */     
  PROCEDURE P_CLIENTES_DEBITO_NDI_DIF(Pv_IdEmpresa              IN VARCHAR2,
                                      Pn_IdBancoTipoCuenta      IN DB_FINANCIERO.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE,
                                      Pn_IdBancoTipoCuentaGrupo IN DB_FINANCIERO.ADMI_GRUPO_ARCHIVO_DEBITO_CAB.ID_GRUPO_DEBITO%TYPE,
                                      Pn_IdOficina              IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                      Pn_IdCiclo                IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,
                                      Pv_FiltroNumCuotas        IN VARCHAR2,
                                      Pr_Clientes               OUT SYS_REFCURSOR); 

 /**
  * Documentaci�n para PROCEDURE 'P_GET_NDI_DIF_FILTRO_CUOTAS'.
  * Procedimiento que obtiene listado por n�mero de cuotas de los documentos NDI diferidas.
  *
  * Costo query: 15
  * 
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 23-06-2020
  *
  * PAR�METROS:
  * @param Pn_IdPersonaRol    IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE (id del cliente a procesar)
  * @param Pv_FiltroNumCuotas IN VARCHAR2   (n�mero de cuotas de NDI diferidas)
  * @param Pv_EmpresaId       IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE  (id de la empresa)
  * @param Pr_DocNdiDiferidas OUT SYS_REFCURSOR (Retorna listado de NDI diferidas por n�mero de cuotas)
  */
  PROCEDURE P_GET_NDI_DIF_FILTRO_CUOTAS(Pn_IdPersonaRol    IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                        Pv_FiltroNumCuotas IN  VARCHAR2,
                                        Pv_EmpresaId       IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                                        Pr_DocNdiDiferidas OUT SYS_REFCURSOR);

 /**
  * Documentaci�n para PROCEDURE 'P_GET_NDI_DIFERIDAS'.
  * Procedimiento que obtiene listado de documentos NDI diferidas.
  *
  * Costo query: 15
  * 
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 23-06-2020
  *
  * PAR�METROS:
  * @param Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE  (id del cliente a procesar)
  * @param Pv_EmpresaId    IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (id de la empresa)
  * @param Pr_NdiDiferidas OUT SYS_REFCURSOR (listado de NDI diferidas)
  */
  PROCEDURE P_GET_NDI_DIFERIDAS(Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                Pv_EmpresaId    IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                                Pr_NdiDiferidas OUT SYS_REFCURSOR); 

 /**
  * Documentaci�n para PROCEDURE 'P_GET_PTO_CLIENTE_ACTIVO'.
  * Procedimiento que obtiene un punto en estado 'Activo' y sea padre de facturacion por id_persona_rol del cliente.
  *
  * Costo query: 7
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 23-06-2020
  *
  * PAR�METROS:
  * @param Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE    (id del cliente a procesar)
  * @param Pv_Estado       IN  DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE   (Recibe el estado del punto a consultar)
  * @param Pn_IdPunto      OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE (Retorna el punto)
  */
  PROCEDURE P_GET_PTO_CLIENTE_ACTIVO(Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                     Pv_Estado       IN  DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
                                     Pn_IdPunto      OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE); 

  --
  /**
  * Documentaci�n para PROCEDURE 'P_CRUCE_ANTICIPO_PUNTO_CLIENTE'.
  * Procedimiento encargado de realizar el cruce de anticipos entre puntos con Factura o NDI de diferido activa.
  * Se verifica que el cliente posea m�s de 1 punto y se verifica que el cliente tenga puntos padre de facturaci�n.
  * Se asigna el anticipo al punto de la factura y se crea el historial del pago.
  * Se crea logs en la info_error para seguimiento de los anticipos cruzados al login.
  *
  * Costo query C_GetAnticipos: 6186
  * Costo query C_ClientePorPunto: 3
  * Costo query C_ValidaCantPuntos: 3
  * Costo query C_GetPuntosCliente: 5
  * Costo query C_GetFacturasPorPunto: 10 
  * Costo query C_GetDatosPunto: 3
  *
  * PAR�METROS:
  * @param Pv_EstadoAnticipo  IN VARCHAR2  (Recibe el estado del anticipo)
  * @param Pv_PrefijoEmpresa  IN VARCHAR2  (Recibe el prefijo empresa )
  * @param Pv_TipoDocAnt      IN VARCHAR2  (Recibe el anticipo ANT)
  * @param Pv_TipoDocAnt      IN VARCHAR2  (Recibe el anticipo ANTS)
  * @param Pv_TipoDocAnt      IN VARCHAR2  (Recibe el anticipo ANTC)
  * @param Pv_Mensaje         OUT VARCHAR2 (Retorna el mensaje de salida)
  *
  * @author Alex Arreaga <atarreaga@telconet.ec>
  * @version 1.0 23-09-2021
  */
  PROCEDURE P_CRUCE_ANTICIPO_PUNTO_CLIENTE(Pv_EstadoAnticipo   IN VARCHAR2,
                                           Pv_PrefijoEmpresa   IN VARCHAR2,
                                           Pv_CodigoDocAnt     IN VARCHAR2,
                                           Pv_CodigoDocAnts    IN VARCHAR2,
                                           Pv_CodigoDocAntc    IN VARCHAR2,
                                           Pv_Mensaje          OUT VARCHAR2);    
      
  --
END FNKG_PROCESO_MASIVO_DEB;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB AS

  PROCEDURE P_PROCESAR_DEBITOS_P AS

    /* Cursos para obtener los codigos de los debitos general a procesar */
    CURSOR C_InfoProcesoMasivos IS
      SELECT b.*,
             a.IDS_OFICINAS,
             a.EMPRESA_ID
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB a,
           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET b,
           DB_GENERAL.ADMI_PARAMETRO_CAB              CAB,
           DB_GENERAL.ADMI_PARAMETRO_DET              DET
      WHERE b.PROCESO_MASIVO_CAB_ID  = a.ID_PROCESO_MASIVO_CAB
       AND DET.PARAMETRO_ID          = CAB.ID_PARAMETRO
       AND DET.VALOR2                = a.EMPRESA_ID
       AND a.TIPO_PROCESO            = 'ProcesarDebito'
       AND a.ESTADO                  = 'Pendiente'
       AND b.ESTADO                  = 'Pendiente'
       AND CAB.ESTADO                = 'Activo'
       AND DET.ESTADO                = 'Activo'
       AND CAB.NOMBRE_PARAMETRO      = 'EMPRESAS_DEBITOS_AUTOMATICOS'
      ORDER BY a.FE_CREACION;
  
    /* Cursor para obtener los debitos pendientes a procesar */
    CURSOR C_DebitosPendientes(Cv_estados       VARCHAR2, 
                               Cn_DebitoGeneral NUMBER) IS
      SELECT b.id_debito_det,
        c.id_debito_cab,
        btc.id_banco_tipo_cuenta,
        bco.DESCripcion_banco,
        tc.DESCripcion_cuenta,
        p.razon_social,
        p.nombres,
        p.apellidos,
        p.identificacion_cliente,
        ROUND(NVL(b.valor_total,0),2) valor_total,
        b.estado,
        NVL(b.valor_debitado,0) valor_debitado,
        b.NUMERO_TARJETA_CUENTA,
        b.persona_empresa_rol_id
      FROM info_debito_det          b,
           info_debito_cab          c,
           info_debito_general      d,
           info_persona_empresa_rol per,
           info_persona             p,
           admi_banco_tipo_cuenta   btc,
           admi_banco               bco,
           admi_tipo_cuenta         tc
      WHERE b.debito_cab_id        = c.id_debito_cab
      AND c.debito_general_id      = d.id_debito_general
      AND b.persona_empresa_rol_id = per.id_persona_rol
      AND per.persona_id           = p.id_persona
      AND c.banco_tipo_cuenta_id   = btc.id_banco_tipo_cuenta
      AND btc.banco_id             = bco.id_banco
      AND btc.tipo_cuenta_id       = tc.id_tipo_cuenta
      AND b.estado                 = Cv_estados
      AND d.id_debito_general      = Cn_DebitoGeneral
      ORDER BY b.fe_creacion DESC;

    /* Cursor para obtener los puntos con saldo del cliente */
    CURSOR C_InfoPunto(Cn_IdDebitoDet     NUMBER,
                       Cv_ValorPermisible VARCHAR2) 
    IS
      SELECT VISTA.PUNTO_ID
      FROM DB_FINANCIERO.INFO_DEBITO_CAB IDC,
        DB_FINANCIERO.INFO_DEBITO_DET IDD,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_FINANCIERO.VISTA_ESTADO_CUENTA_RESUMIDO VISTA,
        DB_COMERCIAL.INFO_SERVICIO ISRV
      WHERE IDD.DEBITO_CAB_ID          = IDC.ID_DEBITO_CAB
        AND IDD.PERSONA_EMPRESA_ROL_ID = IP.PERSONA_EMPRESA_ROL_ID 
        AND IP.ID_PUNTO                = VISTA.PUNTO_ID     
        AND IP.ID_PUNTO                = ISRV.PUNTO_ID
        AND ISRV.ESTADO                = 'In-Corte'       
        AND IDD.ESTADO                 = 'Procesado'
        AND IDD.ID_DEBITO_DET          = Cn_IdDebitoDet
        AND VISTA.SALDO                <= Cv_ValorPermisible
      GROUP BY VISTA.PUNTO_ID;

    /* Cursor para obtener el valor permisble para reactivaci�n del punto */
    CURSOR C_ObtieneValorPermisible(Cv_NombreParametro   VARCHAR2,
                                    Cv_ValorParametroDet VARCHAR2,
                                    Cv_EmpresaId         VARCHAR2) 
    IS
      SELECT VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD, 
        DB_GENERAL.ADMI_PARAMETRO_CAB APC 
      WHERE APC.ID_PARAMETRO     = APD.PARAMETRO_ID
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APD.ESTADO           = 'Activo'
        AND APD.VALOR1           = Cv_ValorParametroDet 
        AND APD.EMPRESA_COD      = Cv_EmpresaId 
        AND APC.ESTADO           = 'Activo';

    /* Cursor para obtener tipo y filtro de escenario */
    CURSOR C_ObtieneEscenarioFiltro(Cn_DebitoGeneralId   NUMBER,
                                    Cn_EmpresaId         VARCHAR2) 
    IS
      SELECT DEBITO_GENERAL_ID, TIPO_ESCENARIO, FILTRO_ESCENARIO
        FROM DB_FINANCIERO.INFO_DEBITO_CAB 
      WHERE DEBITO_GENERAL_ID  = Cn_DebitoGeneralId
      AND EMPRESA_ID           = Cn_EmpresaId
      GROUP BY DEBITO_GENERAL_ID, TIPO_ESCENARIO, FILTRO_ESCENARIO;
      
    /* Variables Locales */
    Lr_NumeroPago            DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE;
    Lr_IdDebitoGeneralH      DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.ID_DEBITO_GENERAL_HISTORIAL%TYPE;
    Lr_IdTipoDocumento       DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Lr_IdPago                DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;
    Lr_FormaPago             DB_GENERAL.ADMI_FORMA_PAGO.ID_FORMA_PAGO%TYPE;
    Lr_PuntoId               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Lr_InfoDebitoGeneralHist DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL%ROWTYPE;
    Lv_Error                 VARCHAR2(500);
    Lv_ComentarioAnticipo    VARCHAR2(100) := 'Anticipo generado por debito - ';
    Lv_ComentarioPago        VARCHAR2(100) := 'Pago generado por debito - ';
    Lv_EstadoFactura         VARCHAR2(200);
    Lv_TipoDocumento         VARCHAR2(10);
    Ln_SaldoFactura          NUMBER;
    Ln_TotalPagNc            NUMBER;
    Ln_ValorPago             NUMBER;
    Ln_ValorPagado           NUMBER;
    Lb_CierraFactura         BOOLEAN;
    Le_ExceptionProceso      EXCEPTION;
    Le_ExceptionDebito       EXCEPTION;
    Ln_TotalProcesados       NUMBER := 0;
    Ln_TotalNoProcesados     NUMBER := 0;
    Lv_NombreProceso         VARCHAR2(3000);
    Lv_MensajeNotificacion   CLOB;
    Le_Exception             EXCEPTION;
    Lt_ArrayPunto            T_ArrayTrama;
    Ln_ContadorPuntos        NUMBER := 0;
    --
    Ln_IdDebitoGeneral       NUMBER;
    Lv_TipoEscenario         VARCHAR2(100);
    Lv_FiltroEscenario       VARCHAR2(100);
    Lrf_Facturas             SYS_REFCURSOR;
    La_FacturasProcesar      T_FacturasProcesar;
    Ln_Indx                  NUMBER;
    Lr_Factura               Lr_FacturasProcesar;
    Lrf_FactEscenarioBase    SYS_REFCURSOR;
    Lrf_DocNdiDiferidas      SYS_REFCURSOR;
    Lrf_NdiDiferidas         SYS_REFCURSOR;
    Ln_IdPuntoActivo         NUMBER;
    Lv_NombreParametro       VARCHAR2(100) := 'LIMITE_SALDO_REACTIVACION';
    Lv_ValorParametroDet     VARCHAR2(100) := 'VALOR_PERMISIBLE';
    Lv_ValorPermisible       VARCHAR2(100);

  BEGIN
  
    IF C_InfoProcesoMasivos%ISOPEN THEN
      CLOSE C_InfoProcesoMasivos;
    END IF;
    
    IF C_DebitosPendientes%ISOPEN THEN
      CLOSE C_DebitosPendientes;
    END IF;
    
    IF C_InfoPunto%ISOPEN THEN
      CLOSE C_InfoPunto;
    END IF;

    IF C_ObtieneValorPermisible%ISOPEN THEN
      CLOSE C_ObtieneValorPermisible;
    END IF;

    IF C_ObtieneEscenarioFiltro%ISOPEN THEN
      CLOSE C_ObtieneEscenarioFiltro;
    END IF;

    /* For para obtener los debitos general a procesar */
    FOR Proceso IN C_InfoProcesoMasivos LOOP  
       
      BEGIN
      
        DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SET_PROCESO_MASI_EST(Proceso.PROCESO_MASIVO_CAB_ID,
                                                                     'Procesando',
                                                                     Lv_NombreProceso,
                                                                     Lv_Error);
                               
        IF Lv_Error IS NOT NULL THEN
          RAISE Le_ExceptionProceso;
        END IF; 

        /* Procedimiento para desglosar la informacion almacenada en el campo observacion */
        DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SEPARA_TRAMA_OBSERVACION(Proceso.OBSERVACION,
                                                                         Lv_NombreProceso,
                                                                         Lv_Error);
        
        IF Lv_Error IS NOT NULL THEN
          RAISE Le_ExceptionProceso;
        END IF;
  
        /* Funcion para crear y obtener el id del historial del debito general */
        Lr_InfoDebitoGeneralHist.DEBITO_GENERAL_ID       := Proceso.PUNTO_ID;
        Lr_InfoDebitoGeneralHist.CUENTA_CONTABLE_ID      := Lt_FormatoTabla(0).Lr_CuentaContableId;
        Lr_InfoDebitoGeneralHist.NUMERO_DOCUMENTO        := Lt_FormatoTabla(0).Lr_CodigoDebito;
        Lr_InfoDebitoGeneralHist.FE_DOCUMENTO            := Lt_FormatoTabla(0).Lr_FechaDocumento;
        Lr_InfoDebitoGeneralHist.PORCENTAJE_COMISION_BCO := Lt_FormatoTabla(0).Lr_PorcentajeComisionBco;
        Lr_InfoDebitoGeneralHist.VALOR_COMISION_BCO      := Lt_FormatoTabla(0).Lr_ValorComisionBco;
        Lr_InfoDebitoGeneralHist.CONTIENE_RETENCION_FTE  := Lt_FormatoTabla(0).Lr_ContieneRetencionF;
        Lr_InfoDebitoGeneralHist.CONTIENE_RETENCION_IVA  := Lt_FormatoTabla(0).Lr_ContieneRetencionI;
        Lr_InfoDebitoGeneralHist.VALOR_RETENCION_FUENTE  := Lt_FormatoTabla(0).Lr_ValorRetencionF;
        Lr_InfoDebitoGeneralHist.VALOR_RETENCION_IVA     := Lt_FormatoTabla(0).Lr_ValorRetencionI;
        Lr_InfoDebitoGeneralHist.VALOR_NETO              := Lt_FormatoTabla(0).Lr_ValorNeto;
        Lr_InfoDebitoGeneralHist.OBSERVACION             := 'Se procesa debitos por debitos pendientes';
        Lr_InfoDebitoGeneralHist.FE_CREACION             := SYSDATE;
        Lr_InfoDebitoGeneralHist.USR_CREACION            := Proceso.USR_CREACION;
        Lr_InfoDebitoGeneralHist.IP_CREACION             := Proceso.IP_CREACION;
        Lr_InfoDebitoGeneralHist.ESTADO                  := 'Activo';
        Lr_IdDebitoGeneralH                              := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.
                                                            F_INSERT_DEBITO_GENERAL_HIST(Lr_InfoDebitoGeneralHist,
                                                                                         Lv_NombreProceso,
                                                                                         Lv_Error);
        
        IF Lv_Error IS NOT NULL OR Lr_IdDebitoGeneralH IS NULL THEN
          RAISE Le_ExceptionProceso;
        END IF;
        
        COMMIT;
        --
        /*Se obtiene el valor permisible para reactivacion de un cliente*/
        OPEN C_ObtieneValorPermisible(Lv_NombreParametro,Lv_ValorParametroDet,TO_CHAR(Proceso.EMPRESA_ID));
            FETCH C_ObtieneValorPermisible INTO Lv_ValorPermisible;
        CLOSE C_ObtieneValorPermisible;
        --

       /* For para obtener los debitos pendientes a procesar. Punto_id = Codigo debito general */
        FOR Debito IN C_DebitosPendientes('Pendiente',Proceso.PUNTO_ID) LOOP
          
          BEGIN
          
            /* Actualizamos la informacion del detalle del debito */
            DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SET_DEBITO_DET(Debito.id_debito_det,
                                                                   'Procesado',
                                                                   Proceso.USR_CREACION,
                                                                   Debito.valor_total,
                                                                   Lv_NombreProceso,
                                                                   Lv_Error);
          
            IF Lv_Error IS NOT NULL THEN
              RAISE Le_ExceptionDebito;
            END IF;

            /* Funcion para obtener la forma de pago */
            Lr_FormaPago := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_FORMA_PAGO('DEB',
                                                                                   'Activo',
                                                                                   Lv_NombreProceso,
                                                                                   Lv_Error);
            
            IF Lv_Error IS NOT NULL OR Lr_FormaPago IS NULL THEN
              RAISE Le_ExceptionDebito;
            END IF;
            
            IF Debito.valor_total > 0 THEN 
              Ln_ValorPagado := Debito.valor_total;
            ELSE
              Ln_ValorPagado := 0;
            END IF;
            
            Ln_ValorPagado := ROUND(Ln_ValorPagado,2);
            --
            OPEN C_ObtieneEscenarioFiltro(Proceso.PUNTO_ID, Proceso.EMPRESA_ID);
                FETCH C_ObtieneEscenarioFiltro INTO Ln_IdDebitoGeneral, Lv_TipoEscenario, Lv_FiltroEscenario;
            CLOSE C_ObtieneEscenarioFiltro;
            --
            --Procesa Pagos de facturas por Tipo de Escenarios
            IF Lv_TipoEscenario = 'ESCENARIO_BASE' OR Lv_TipoEscenario = 'ESCENARIO_2'  THEN

                DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_FACTURAS_X_CLIENTE(Proceso.EMPRESA_ID, 
                                                                               Debito.persona_empresa_rol_id,
                                                                               Lrf_FactEscenarioBase                                         
                                                                              );
        
                Ln_ValorPagado := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO(Lrf_FactEscenarioBase,
                                                                                                   Ln_ValorPagado,
                                                                                                   Proceso.EMPRESA_ID,
                                                                                                   Proceso.IDS_OFICINAS,
                                                                                                   Debito.id_debito_det,
                                                                                                   Lr_FormaPago,
                                                                                                   Proceso.USR_CREACION,
                                                                                                   Lr_IdDebitoGeneralH,
                                                                                                   Debito.id_banco_tipo_cuenta,
                                                                                                   Debito.NUMERO_TARJETA_CUENTA
                                                                                                  );

                CLOSE Lrf_FactEscenarioBase;                                                                                    
                --   
                IF Ln_ValorPagado IS NULL THEN
                  RAISE Le_ExceptionDebito;
                END IF;                                             
                --
                FOR Puntos IN C_InfoPunto(Debito.id_debito_det, Lv_ValorPermisible) 
                LOOP
                    Lt_ArrayPunto(Ln_ContadorPuntos) := Puntos.PUNTO_ID;
                    Ln_ContadorPuntos := Ln_ContadorPuntos + 1;
                END LOOP;
            --
            END IF;
            --
            IF Lv_TipoEscenario = 'ESCENARIO_1' THEN
                                
                DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_FACT_MENS_FILTRO_FECHA(Debito.persona_empresa_rol_id,
                                                                                   Lv_FiltroEscenario,
                                                                                   Proceso.EMPRESA_ID, 
                                                                                   Lrf_Facturas
                                                                                   ); 

                --Procesar facturas
                Ln_ValorPagado:= DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO(Lrf_Facturas,
                                                                                                  Ln_ValorPagado,
                                                                                                  Proceso.EMPRESA_ID,
                                                                                                  Proceso.IDS_OFICINAS,
                                                                                                  Debito.id_debito_det,
                                                                                                  Lr_FormaPago,
                                                                                                  Proceso.USR_CREACION,
                                                                                                  Lr_IdDebitoGeneralH,
                                                                                                  Debito.id_banco_tipo_cuenta,
                                                                                                  Debito.NUMERO_TARJETA_CUENTA
                                                                                                 ); 
                                                                                                     
                CLOSE Lrf_Facturas;                                                                                  
                --                         
                IF Ln_ValorPagado IS NULL THEN
                    RAISE Le_ExceptionDebito;
                END IF;    
                --                        
                   
                IF ROUND(NVL(Ln_ValorPagado,0),2) > 0 THEN
                    --Se llama al proceso de escenario base
                    DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_FACTURAS_X_CLIENTE(Proceso.EMPRESA_ID,
                                                                                   Debito.persona_empresa_rol_id,
                                                                                   Lrf_FactEscenarioBase                         
                                                                                  );
                    
                    Ln_ValorPagado:= DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO(Lrf_FactEscenarioBase,
                                                                                                      Ln_ValorPagado,
                                                                                                      Proceso.EMPRESA_ID,
                                                                                                      Proceso.IDS_OFICINAS,
                                                                                                      Debito.id_debito_det,
                                                                                                      Lr_FormaPago,
                                                                                                      Proceso.USR_CREACION,
                                                                                                      Lr_IdDebitoGeneralH,
                                                                                                      Debito.id_banco_tipo_cuenta,
                                                                                                      Debito.NUMERO_TARJETA_CUENTA
                                                                                                     );

                    CLOSE Lrf_FactEscenarioBase;                                                                                   
                    --                                            
                    IF Ln_ValorPagado IS NULL THEN
                        RAISE Le_ExceptionDebito;
                    END IF;                                      
                  
                END IF;
                --
                FOR Puntos IN C_InfoPunto(Debito.id_debito_det, Lv_ValorPermisible) 
                LOOP
                    Lt_ArrayPunto(Ln_ContadorPuntos) := Puntos.PUNTO_ID;
                    Ln_ContadorPuntos := Ln_ContadorPuntos + 1;
                END LOOP;
                --
            END IF;
            --     
            IF Lv_TipoEscenario = 'ESCENARIO_3'  THEN

                DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_NDI_DIF_FILTRO_CUOTAS(Debito.persona_empresa_rol_id,
                                                                                  Lv_FiltroEscenario,
                                                                                  Proceso.EMPRESA_ID,
                                                                                  Lrf_DocNdiDiferidas
                                                                                  );
                
                Ln_ValorPagado := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO(Lrf_DocNdiDiferidas,
                                                                                                   Ln_ValorPagado,
                                                                                                   Proceso.EMPRESA_ID,
                                                                                                   Proceso.IDS_OFICINAS,
                                                                                                   Debito.id_debito_det,
                                                                                                   Lr_FormaPago,
                                                                                                   Proceso.USR_CREACION,
                                                                                                   Lr_IdDebitoGeneralH,
                                                                                                   Debito.id_banco_tipo_cuenta,
                                                                                                   Debito.NUMERO_TARJETA_CUENTA
                                                                                                   );
                                                               
                CLOSE Lrf_DocNdiDiferidas;    
                --
                IF Ln_ValorPagado IS NULL THEN
                    RAISE Le_ExceptionDebito;
                END IF;
                --
                IF ROUND(NVL(Ln_ValorPagado,0),2) > 0 THEN
                    DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_NDI_DIFERIDAS(Debito.persona_empresa_rol_id,
                                                                              Proceso.EMPRESA_ID,
                                                                              Lrf_NdiDiferidas
                                                                              );
                
                    Ln_ValorPagado := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO(Lrf_NdiDiferidas,
                                                                                                       Ln_ValorPagado,
                                                                                                       Proceso.EMPRESA_ID,
                                                                                                       Proceso.IDS_OFICINAS,
                                                                                                       Debito.id_debito_det,
                                                                                                       Lr_FormaPago,
                                                                                                       Proceso.USR_CREACION,
                                                                                                       Lr_IdDebitoGeneralH,
                                                                                                       Debito.id_banco_tipo_cuenta,
                                                                                                       Debito.NUMERO_TARJETA_CUENTA
                                                                                                       );
                                                               
                    CLOSE Lrf_NdiDiferidas;
                    --
                    IF Ln_ValorPagado IS NULL THEN
                        RAISE Le_ExceptionDebito;
                    END IF;
                       
                END IF;                                     
                --
                IF ROUND(NVL(Ln_ValorPagado,0),2) > 0 THEN
                    DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_FACTURAS_X_CLIENTE(Proceso.EMPRESA_ID, 
                                                                                   Debito.persona_empresa_rol_id,
                                                                                   Lrf_FactEscenarioBase                                         
                                                                                  );
        
                    Ln_ValorPagado := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO(Lrf_FactEscenarioBase,
                                                                                                       Ln_ValorPagado,
                                                                                                       Proceso.EMPRESA_ID,
                                                                                                       Proceso.IDS_OFICINAS,
                                                                                                       Debito.id_debito_det,
                                                                                                       Lr_FormaPago,
                                                                                                       Proceso.USR_CREACION,
                                                                                                       Lr_IdDebitoGeneralH,
                                                                                                       Debito.id_banco_tipo_cuenta,
                                                                                                       Debito.NUMERO_TARJETA_CUENTA
                                                                                                       );

                    CLOSE Lrf_FactEscenarioBase;
                    --
                    IF Ln_ValorPagado IS NULL THEN
                        RAISE Le_ExceptionDebito;
                    END IF;                                                                                    
                
                END IF;
                --    
                FOR Puntos IN C_InfoPunto(Debito.id_debito_det, Lv_ValorPermisible) 
                LOOP
                    Lt_ArrayPunto(Ln_ContadorPuntos) := Puntos.PUNTO_ID;
                    Ln_ContadorPuntos := Ln_ContadorPuntos + 1;
                END LOOP;
                --
            END IF;
            --                   
            /* Crea el anticipo si es necesario */
            IF ROUND(NVL(Ln_ValorPagado,0),2) > 0 THEN
    
                Lv_TipoDocumento := 'ANTS';
                
                DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_PTO_CLIENTE_ACTIVO(Debito.persona_empresa_rol_id,
                                                                              'Activo',
                                                                               Lr_PuntoId);
                
                IF Lr_PuntoId = 0 THEN

                    Lr_PuntoId := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_PADRE_FACTURACION(Debito.persona_empresa_rol_id,
                                                                                                Lv_NombreProceso,
                                                                                                Lv_Error);
                END IF;
                
                IF Lv_Error IS NOT NULL THEN
                  RAISE Le_ExceptionDebito;
                END IF;
                
                IF Lr_PuntoId IS NOT NULL THEN
                  Lv_TipoDocumento := 'ANT';
                END IF;
                
                /* Funcion para obtener la numeracion del anticipo */
                Lr_NumeroPago := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_NUMERACION(Proceso.EMPRESA_ID, 
                                                                                        Proceso.IDS_OFICINAS,
                                                                                        'ADEB',
                                                                                        Lv_NombreProceso,
                                                                                        Lv_Error);
                                                  
                IF Lr_NumeroPago IS NULL OR Lv_Error IS NOT NULL THEN
                  RAISE Le_ExceptionDebito;
                END IF;
                
                /* Funcion para obtener el tipo de documento */
                Lr_IdTipoDocumento := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_TIPO_DOCUMENTO(Lv_TipoDocumento,
                                                                                                 'Activo',
                                                                                                 Lv_NombreProceso,
                                                                                                 Lv_Error);
                
                IF Lr_IdTipoDocumento IS NULL OR Lv_Error IS NOT NULL THEN
                  RAISE Le_ExceptionDebito;
                END IF;
                
                /* Creamos el anticipo */
                Lr_IdPago := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_CREA_PAGO(Lr_PuntoId,
                                                                               Proceso.IDS_OFICINAS,
                                                                               Proceso.EMPRESA_ID,
                                                                               Debito.id_debito_det,
                                                                               Lr_NumeroPago,
                                                                               Ln_ValorPagado,
                                                                               'Pendiente',
                                                                               Lv_ComentarioAnticipo || Lt_FormatoTabla(0).Lr_CodigoDebito,
                                                                               Proceso.USR_CREACION,
                                                                               Lr_IdTipoDocumento,
                                                                               Lr_IdDebitoGeneralH,
                                                                               Lv_NombreProceso,
                                                                               Lv_Error);
                                         
                IF Lv_Error IS NOT NULL OR Lr_IdPago IS NULL THEN
                  RAISE Le_ExceptionDebito;
                END IF;
                                         
                /* Creamos el detalle del anticipo */
                DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_DETALLE_PAGO(Lr_IdPago,
                                                                          Lt_FormatoTabla(0).Lr_FechaDocumento,
                                                                          Proceso.USR_CREACION,
                                                                          Lr_FormaPago,
                                                                          Ln_ValorPagado,
                                                                          Debito.id_banco_tipo_cuenta,
                                                                          Lt_FormatoTabla(0).Lr_CodigoDebito,
                                                                          Debito.NUMERO_TARJETA_CUENTA,
                                                                          Lv_ComentarioAnticipo || Lt_FormatoTabla(0).Lr_CodigoDebito,
                                                                          'Pendiente',
                                                                          NULL,
                                                                          Lv_NombreProceso,
                                                                          Lv_Error);
                                    
                IF Lv_Error IS NOT NULL THEN
                   RAISE Le_ExceptionDebito;
                END IF;
                               
                /* Crea el historial del pago */
                DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_HISTORIAL_PAGO(Lr_IdPago,
                                                                            'Pendiente',
                                                                            Proceso.USR_CREACION,
                                                                            NULL,
                                                                            Lv_ComentarioAnticipo || Lt_FormatoTabla(0).Lr_CodigoDebito,
                                                                            Lv_NombreProceso,
                                                                            Lv_Error);
                                        
                IF Lv_Error IS NOT NULL THEN
                   RAISE Le_ExceptionDebito;
                END IF; 

              END IF;

            /* Se realiza un commit por cada debito, para controlar el error */
            COMMIT;
            
            Ln_TotalProcesados := Ln_TotalProcesados + 1;
            
            IF Lt_ArrayPunto.COUNT() > 0 THEN
            
              DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_REACTIVAR_PUNTOS(Lt_ArrayPunto,
                                                                       Lt_FormatoTabla(0).Lv_PrefijoEmpresa,
                                                                       Proceso.EMPRESA_ID, 
                                                                       Proceso.IDS_OFICINAS,
                                                                       Proceso.USR_CREACION, 
                                                                       Proceso.IP_CREACION,
                                                                       Debito.id_debito_cab,
                                                                       Proceso.PROCESO_MASIVO_CAB_ID);
            END IF;
            
            Lt_ArrayPunto.DELETE();
          
          EXCEPTION
          
            WHEN Le_ExceptionDebito THEN
            
              ROLLBACK;

              Ln_TotalNoProcesados := Ln_TotalNoProcesados + 1;

              DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                                          Lv_NombreProceso,
                                                          Lv_Error || ' - IdDetalle: ' || Debito.id_debito_det);
                                            
              Lv_NombreProceso := NULL;
              Lv_Error := NULL;

          END;

        END LOOP;

        /* Actualizamos el estado del las estructuras del proceso masivo */
        DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SET_PROCESO_MASI_EST(Proceso.PROCESO_MASIVO_CAB_ID,
                                                                     'Procesado',
                                                                     Lv_NombreProceso,
                                                                     Lv_Error);
        
        IF Lv_Error IS NOT NULL THEN
          RAISE Le_ExceptionProceso;
        END IF;
        
        COMMIT; --Confirmamos la actualizacion del estado
        
        DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CONTABILIZA_DEB(Lt_FormatoTabla(0).Lv_PrefijoEmpresa,
                                                                Lr_IdDebitoGeneralH,
                                                                Proceso.EMPRESA_ID,
                                                                Lv_NombreProceso,
                                                                Lv_Error);
                          
        IF Lv_Error IS NOT NULL THEN
          RAISE Le_ExceptionProceso;
        END IF; 

      EXCEPTION
        
        WHEN Le_ExceptionProceso THEN
        
          ROLLBACK;

          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                                      Lv_NombreProceso,
                                                      Lv_Error||' - IdProcesoMasivo: ' || Proceso.PROCESO_MASIVO_CAB_ID);

          /* Actualizamos el estado del las estructuras del proceso masivo */
          DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SET_PROCESO_MASI_EST(Proceso.PROCESO_MASIVO_CAB_ID,
                                                                       'Error',
                                                                       Lv_NombreProceso,
                                                                       Lv_Error);
          
          COMMIT;                     
                               
          Lv_NombreProceso := NULL;
          Lv_Error         := NULL;
          
      END;
      
      Lt_FormatoTabla.DELETE(); --Limpiamos la tabla
      
    END LOOP;

    --Proceso para el envio de la notificacion
    Lv_MensajeNotificacion := '<th>'||Ln_TotalProcesados||'</th><th>'||Ln_TotalNoProcesados||'</th>';
    DB_FINANCIERO.FNKG_NOTIFICACIONES.P_NOTIF_PROCESO_MASIVO_DEBITOS(Lv_MensajeNotificacion,
                                                                     'PMDEB',
                                                                     'facturacion@telconet.ec',
                                                                     'PROCESO MASIVO DE DEBITOS PENDIENTES',
                                                                     '{{ informacionDebitosProcesados }}',
                                                                     'text/html; charset=UTF-8',
                                                                      Lv_Error);

    IF Lv_Error IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;
    
  EXCEPTION
  
    WHEN Le_Exception THEN
    
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                                  'FNKG_PROCESO_MASIVO_DEB.P_PROCESAR_DEBITOS_P', 
                                                   Lv_Error);

    WHEN OTHERS THEN

      ROLLBACK;
      
      DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                                  'FNKG_PROCESO_MASIVO_DEB.P_PROCESAR_DEBITOS_P',
                                                   SQLERRM);
      
  END P_PROCESAR_DEBITOS_P;


  /*
    FUNCION QUE DEVUELVE LA NUMERACION
  */
  FUNCTION F_GET_NUMERACION(Fn_IdEmpresa     IN  NUMBER, 
                            Fn_IdOficina     IN  NUMBER, 
                            Fv_Parametro     IN  VARCHAR2,
                            Fv_NombreProceso OUT VARCHAR2,
                            Fv_Error         OUT VARCHAR2)
  RETURN VARCHAR2 IS
    
    CURSOR C_Numeracion (Cn_IdEmpresa NUMBER,
                         Cn_IdOficina NUMBER,
                         Cv_Parametro VARCHAR2) IS
      SELECT A.*
        FROM DB_COMERCIAL.ADMI_NUMERACION A
       WHERE A.CODIGO     = Cv_Parametro
        AND A.EMPRESA_ID  = Cn_IdEmpresa
        AND A.OFICINA_ID  = Cn_IdOficina
        AND A.ESTADO      = 'Activo' ;
        
    Lc_Numeracion C_Numeracion%ROWTYPE;
    Lb_Vacio      BOOLEAN;
    Lv_Secuencia  VARCHAR2(20);
    Lv_NumeroPago VARCHAR2(100);
    
  BEGIN
    
      IF C_Numeracion%ISOPEN THEN
        CLOSE C_Numeracion;
      END IF;
      
      OPEN C_Numeracion(Fn_IdEmpresa,Fn_IdOficina,Fv_Parametro);
      FETCH C_Numeracion 
        INTO Lc_Numeracion;
        --
          Lb_Vacio := C_Numeracion%NOTFOUND;
        --
      CLOSE C_Numeracion;
      
      IF Lb_Vacio THEN
        RETURN NULL;
      END IF;
      
      SELECT LPAD(Lc_Numeracion.SECUENCIA,7,'0') INTO Lv_Secuencia FROM DUAL;
      
      Lv_NumeroPago := Lc_Numeracion.NUMERACION_UNO ||'-'|| Lc_Numeracion.NUMERACION_DOS ||'-'|| Lv_Secuencia;
      
      UPDATE DB_COMERCIAL.ADMI_NUMERACION a
        SET a.SECUENCIA     = (Lv_Secuencia + 1)
      WHERE a.ID_NUMERACION = Lc_Numeracion.ID_NUMERACION;
      
      RETURN Lv_NumeroPago;
    
  EXCEPTION

      WHEN OTHERS THEN
        
        Fv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.F_GET_NUMERACION';
        Fv_Error         := SQLERRM;
        RETURN NULL;
          
  END F_GET_NUMERACION;


  /*
    FUNCION QUE DEVUELVE EL TIPO DE DOCUMENTO
  */
  FUNCTION F_GET_TIPO_DOCUMENTO(Fv_TipoDocumento  IN  VARCHAR2,
                                Fv_Estado         IN  VARCHAR2,
                                Fv_NombreProceso  OUT VARCHAR2,
                                Fv_Error          OUT VARCHAR2)
    RETURN NUMBER IS
  
    CURSOR C_TipoDocumento(Cv_TipoDocumento VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT a.* 
        FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO a
      WHERE a.CODIGO_TIPO_DOCUMENTO = Cv_TipoDocumento
       AND  a.ESTADO = Cv_Estado;
  
    Lc_TipoDocumento  C_TipoDocumento%ROWTYPE;
    Lb_Vacio          BOOLEAN;
  
  BEGIN
  
    IF C_TipoDocumento%ISOPEN THEN
      CLOSE C_TipoDocumento;
    END IF;
    
    OPEN C_TipoDocumento(Fv_TipoDocumento,Fv_Estado);
    FETCH C_TipoDocumento 
      INTO Lc_TipoDocumento;
      --
      Lb_Vacio := C_TipoDocumento%NOTFOUND;
      --
    CLOSE C_TipoDocumento;
    
    IF Lb_Vacio THEN
      RETURN NULL;
    END IF;
  
    RETURN Lc_TipoDocumento.ID_TIPO_DOCUMENTO;
    
  EXCEPTION

    WHEN OTHERS THEN
      
      Fv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.F_GET_TIPO_DOCUMENTO';
      Fv_Error         := SQLERRM;
      RETURN NULL;
    
  END F_GET_TIPO_DOCUMENTO;


  /*
    FUNCION ENCARGADA DE CREAR EL HISTORIAL DEL DEBITO GENERAL.
  */    
  FUNCTION F_INSERT_DEBITO_GENERAL_HIST(
      Fr_InfoDebitoGeneralHist  IN  DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL%ROWTYPE,
      Fv_NombreProceso          OUT VARCHAR2,
      Fv_Error                  OUT VARCHAR2)
    RETURN NUMBER IS

    Lr_IdDebitoGeneralH   DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL.ID_DEBITO_GENERAL_HISTORIAL%TYPE;

  BEGIN
    
     Lr_IdDebitoGeneralH   :=  DB_FINANCIERO.SEQ_INFO_DEBITO_GENERAL_HISTO.NEXTVAL;      

     INSERT
      INTO DB_FINANCIERO.INFO_DEBITO_GENERAL_HISTORIAL
        (
          ID_DEBITO_GENERAL_HISTORIAL,
          DEBITO_GENERAL_ID,
          CUENTA_CONTABLE_ID,
          NUMERO_DOCUMENTO,
          FE_DOCUMENTO,
          PORCENTAJE_COMISION_BCO,
          VALOR_COMISION_BCO,
          CONTIENE_RETENCION_FTE,
          CONTIENE_RETENCION_IVA,
          VALOR_RETENCION_FUENTE,
          VALOR_RETENCION_IVA,
          VALOR_NETO,
          OBSERVACION,
          FE_CREACION,
          USR_CREACION,
          IP_CREACION,
          ESTADO
        )
        VALUES
        (
          Lr_IdDebitoGeneralH,
          Fr_InfoDebitoGeneralHist.DEBITO_GENERAL_ID,
          Fr_InfoDebitoGeneralHist.CUENTA_CONTABLE_ID,
          Fr_InfoDebitoGeneralHist.NUMERO_DOCUMENTO,
          Fr_InfoDebitoGeneralHist.FE_DOCUMENTO,
          Fr_InfoDebitoGeneralHist.PORCENTAJE_COMISION_BCO,
          Fr_InfoDebitoGeneralHist.VALOR_COMISION_BCO,
          Fr_InfoDebitoGeneralHist.CONTIENE_RETENCION_FTE,
          Fr_InfoDebitoGeneralHist.CONTIENE_RETENCION_IVA,
          Fr_InfoDebitoGeneralHist.VALOR_RETENCION_FUENTE,
          Fr_InfoDebitoGeneralHist.VALOR_RETENCION_IVA,
          Fr_InfoDebitoGeneralHist.VALOR_NETO,
          Fr_InfoDebitoGeneralHist.OBSERVACION,
          Fr_InfoDebitoGeneralHist.FE_CREACION,
          Fr_InfoDebitoGeneralHist.USR_CREACION,
          NVL(Fr_InfoDebitoGeneralHist.IP_CREACION, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1')),
          Fr_InfoDebitoGeneralHist.ESTADO
        );

     RETURN Lr_IdDebitoGeneralH;

  EXCEPTION

    WHEN OTHERS THEN
      
      Fv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.F_INSERT_DEBITO_GENERAL_HIST';
      Fv_Error         := SQLERRM;
      RETURN NULL;
     
  END F_INSERT_DEBITO_GENERAL_HIST;
  

  /*
    Retorna el valor total de pagos + el valor total de notas de credito de una factura
  */
  FUNCTION F_GET_TOTAL_PAG_NC(Fn_IdFactura      IN  NUMBER,
                              Fv_NombreProceso  OUT VARCHAR2,
                              Fv_Error          OUT VARCHAR2) 
    RETURN NUMBER IS

    CURSOR C_TotalPagos(Cn_IdFactura NUMBER) IS
      SELECT NVL(SUM(pd.VALOR_PAGO),0) AS total_pagos
      FROM DB_FINANCIERO.INFO_PAGO_DET pd
      WHERE pd.REFERENCIA_ID = Cn_IdFactura
      AND pd.ESTADO          = 'Cerrado';

    CURSOR C_TotalNotaCredito(Cn_IdFactura NUMBER) IS
      SELECT NVL(SUM(nc.VALOR_TOTAL),0) AS total_nc
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB fac,
           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB nc
      WHERE fac.ID_DOCUMENTO       = nc.REFERENCIA_DOCUMENTO_ID
      AND fac.ID_DOCUMENTO         = Cn_IdFactura
      AND nc.ESTADO_IMPRESION_FACT = 'Activo';

    Ln_TotalPagos       NUMBER;
    Ln_TotalNotaCredito NUMBER;

  BEGIN

    IF C_TotalPagos%ISOPEN THEN
      CLOSE C_TotalPagos;
    END IF;
    
    IF C_TotalNotaCredito%ISOPEN THEN
      CLOSE C_TotalNotaCredito;
    END IF;
    
   OPEN C_TotalPagos(Fn_IdFactura) ;
    FETCH C_TotalPagos 
     INTO Ln_TotalPagos;
   CLOSE C_TotalPagos;
   
   OPEN C_TotalNotaCredito(Fn_IdFactura) ;
    FETCH C_TotalNotaCredito 
     INTO Ln_TotalNotaCredito;
   CLOSE C_TotalNotaCredito;

   RETURN Ln_TotalPagos + Ln_TotalNotaCredito;

  EXCEPTION

    WHEN OTHERS THEN

      Fv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.F_GET_TOTAL_PAG_NC';
      Fv_Error         := SQLERRM;
      RETURN NULL;

  END F_GET_TOTAL_PAG_NC;
  
  
  /*
    PROCESO QUE ACTUALIZA LA FACTURA
  */
  PROCEDURE P_SET_FACTURA_ESTADO(Pn_IdFactura     IN  NUMBER,
                                 Pv_Estado        IN  VARCHAR2,
                                 Pv_NombreProceso OUT VARCHAR2,
                                 Pv_Error         OUT VARCHAR2) IS
  BEGIN
  
    UPDATE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB
     SET ESTADO_IMPRESION_FACT = Pv_Estado
    WHERE ID_DOCUMENTO         = Pn_IdFactura;
    
  EXCEPTION

    WHEN OTHERS THEN

      Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_SET_FACTURA_ESTADO';
      Pv_Error         := SQLERRM;
    
  END P_SET_FACTURA_ESTADO;
  
  
  /*
    PROCESO PARA GUARDAR EL HISTORIAL
  */
  PROCEDURE P_CREA_FACTURA_HISTORIAL(Pn_IdFactura       IN  NUMBER,
                                     Pv_Estado          IN  VARCHAR2,
                                     Pv_UsuarioCreacion IN  VARCHAR2,
                                     Pv_NombreProceso   OUT VARCHAR2,
                                     Pv_Error           OUT VARCHAR2) IS
  BEGIN
  
    INSERT
    INTO DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL
      (
        ID_DOCUMENTO_HISTORIAL,
        DOCUMENTO_ID,
        FE_CREACION,
        USR_CREACION,
        ESTADO
      )
      VALUES
      (
        DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL,
        Pn_IdFactura,
        SYSDATE,
        Pv_UsuarioCreacion,
        Pv_Estado
      );
      
  EXCEPTION

    WHEN OTHERS THEN

      Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_CREA_FACTURA_HISTORIAL';
      Pv_Error         := SQLERRM;
    
  END P_CREA_FACTURA_HISTORIAL;

   
  /*
    PROCESO QUE CREA EL HISTORIAL DEL PAGO
  */
  FUNCTION F_CREA_PAGO(Fn_PuntoId           IN  NUMBER,
                       Fn_OficinaId         IN  NUMBER,
                       Fn_EmpresaId         IN  VARCHAR2,
                       Fn_DebitoDetId       IN  NUMBER,
                       Fv_NumeroPago        IN  VARCHAR2,
                       Fn_ValorTotal        IN  NUMBER,
                       Fv_EstadoPago        IN  VARCHAR2,
                       Fcl_ComentarioPago   IN  CLOB,
                       Fv_UsuarioCreacion   IN  VARCHAR2,
                       Fn_TipoDocumentoId   IN  NUMBER,
                       Fn_DebitoGeneralHist IN  NUMBER,
                       Fv_NombreProceso     OUT VARCHAR2,
                       Fv_Error             OUT VARCHAR2)
    RETURN NUMBER IS
      
      Lr_IdPago   DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;  
        
    BEGIN
      
      Lr_IdPago := DB_FINANCIERO.SEQ_INFO_PAGO_CAB.NEXTVAL;
      
      INSERT
      INTO DB_FINANCIERO.INFO_PAGO_CAB
        (
          ID_PAGO,
          PUNTO_ID,
          OFICINA_ID,
          EMPRESA_ID,
          DEBITO_DET_ID,
          NUMERO_PAGO,
          VALOR_TOTAL,
          ESTADO_PAGO,
          COMENTARIO_PAGO,
          FE_CREACION,
          USR_CREACION,
          TIPO_DOCUMENTO_ID,
          DEBITO_GENERAL_HISTORIAL_ID
        )
        VALUES
        (
          Lr_IdPago,
          Fn_PuntoId,
          Fn_OficinaId,
          Fn_EmpresaId,
          Fn_DebitoDetId,
          Fv_NumeroPago,
          Fn_ValorTotal,
          Fv_EstadoPago,
          Fcl_ComentarioPago,
          SYSDATE,
          Fv_UsuarioCreacion,
          Fn_TipoDocumentoId,
          Fn_DebitoGeneralHist
        );
        
        RETURN Lr_IdPago;
        
  EXCEPTION
  
    WHEN OTHERS THEN
      
      Fv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.F_CREA_PAGO';
      Fv_Error         := SQLERRM;
      RETURN NULL;
                  
  END F_CREA_PAGO;
   
   
  /*
    PROCESO QUE CREA EL HISTORIAL DEL PAGO
  */
  PROCEDURE P_CREA_DETALLE_PAGO(Pn_IdPago            IN  NUMBER,
                                Pv_FechaProceso      IN  DATE,
                                Pv_UsuarioCreacion   IN  VARCHAR2,
                                Pn_FormaPago         IN  NUMBER,
                                Pn_ValorPago         IN  NUMBER,
                                Pn_BancoTipoCuenta   IN  NUMBER,
                                Pv_NumerReferencia   IN  VARCHAR2,
                                Pv_NumeroCuentaBanco IN  VARCHAR2,
                                Pv_Comentario        IN  VARCHAR2,
                                Pv_Estado            IN  VARCHAR2,
                                Pn_ReferenciaId      IN  NUMBER,
                                Pv_NombreProceso     OUT VARCHAR2,
                                Pv_Error             OUT VARCHAR2) IS
  BEGIN

    INSERT
    INTO DB_FINANCIERO.INFO_PAGO_DET
      (
        ID_PAGO_DET,
        PAGO_ID,
        DEPOSITADO,
        FE_CREACION,
        FE_DEPOSITO,
        USR_CREACION,
        FORMA_PAGO_ID,
        VALOR_PAGO,
        BANCO_TIPO_CUENTA_ID,
        NUMERO_REFERENCIA,
        NUMERO_CUENTA_BANCO,
        COMENTARIO,
        ESTADO,
        REFERENCIA_ID
      )
      VALUES
      (
        DB_FINANCIERO.SEQ_INFO_PAGO_DET.NEXTVAL,
        Pn_IdPago,
        'N',
        SYSDATE,
        Pv_FechaProceso,
        Pv_UsuarioCreacion,
        Pn_FormaPago,
        Pn_ValorPago,
        Pn_BancoTipoCuenta,
        Pv_NumerReferencia,
        Pv_NumeroCuentaBanco,
        Pv_Comentario,
        Pv_Estado,
        Pn_ReferenciaId
      );
      
  EXCEPTION
    
    WHEN OTHERS THEN
        
      Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_CREA_DETALLE_PAGO';  
      Pv_Error         := SQLERRM;

  END P_CREA_DETALLE_PAGO;


  /*
    FUNCION QUE DEVUELVE LA FORMA DE PAGO
  */
  FUNCTION F_GET_FORMA_PAGO(Fv_CodigoFormaPago IN  VARCHAR2,
                            Fv_Estado          IN  VARCHAR2,
                            Fv_NombreProceso   OUT VARCHAR2,
                            Fv_Error           OUT VARCHAR2)
    RETURN NUMBER IS
    
     /*CURSOR QUE DEVUELVE LA FORMA DE PAGO*/
     CURSOR C_FormaPago(Cv_CodigoFormaPago VARCHAR2, Cv_Estado VARCHAR2) IS
      SELECT * 
        FROM DB_GENERAL.ADMI_FORMA_PAGO 
        WHERE CODIGO_FORMA_PAGO = Cv_CodigoFormaPago 
        AND ESTADO = Cv_Estado
        AND ROWNUM = 1;
    
    Lc_FormaPago  C_FormaPago%ROWTYPE;
    Lb_Vacio      BOOLEAN;
    
  BEGIN
  
    IF C_FormaPago%ISOPEN THEN
      CLOSE C_FormaPago;
    END IF;
    
    OPEN C_FormaPago(Fv_CodigoFormaPago,Fv_Estado);
    FETCH C_FormaPago 
      INTO Lc_FormaPago;
        --
        Lb_Vacio := C_FormaPago%NOTFOUND;
        --
    CLOSE C_FormaPago;
    
    IF Lb_Vacio THEN
      RETURN NULL;
    END IF;
    
    RETURN Lc_FormaPago.ID_FORMA_PAGO;
    
  EXCEPTION
    
    WHEN OTHERS THEN
        
      Fv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.F_GET_FORMA_PAGO';
      Fv_Error         := SQLERRM;
      RETURN NULL;
    
  END F_GET_FORMA_PAGO;


  /*
    PROCESO PARA DESGLOSAR LA OBSERVACION
  */
  PROCEDURE P_SEPARA_TRAMA_OBSERVACION(Pv_Trama_Obs     IN  VARCHAR2,
                                       Pv_NombreProceso OUT VARCHAR2,
                                       Pv_Error         OUT VARCHAR2) IS

    Lt_ArrayTrama   T_ArrayTrama;
    Lv_Trama_Obs    VARCHAR2(4000);
    Ln_Contador     NUMBER := 0;
    Ln_Posicion     NUMBER;
    
  BEGIN
  
    Lv_Trama_Obs := Pv_Trama_Obs;
    
    WHILE NVL(LENGTH(Lv_Trama_Obs),0) > 0 LOOP
    
           Ln_Posicion := inStr(Lv_Trama_Obs, '|' );
           
           IF Ln_Posicion > 0 THEN
           
              Lt_ArrayTrama(Ln_Contador) := substr(Lv_Trama_Obs,1, Ln_Posicion-1);
              Lv_Trama_Obs := substr(Lv_Trama_Obs,Ln_Posicion+1,LENGTH(Lv_Trama_Obs));
              
           ELSE
           
              Lt_ArrayTrama(Ln_Contador) := Lv_Trama_Obs;
              Lv_Trama_Obs := NULL;
              
           END IF;
                          
           Ln_Contador := Ln_Contador + 1;
           
     END LOOP;

      Lt_FormatoTabla(0).Lr_CuentaContableId      :=  Lt_ArrayTrama(1);
      Lt_FormatoTabla(0).Lr_CodigoDebito          :=  Lt_ArrayTrama(2);
      Lt_FormatoTabla(0).Lr_FechaDocumento        :=  TO_DATE(Lt_ArrayTrama(3),'RRRR/MM/DD');
      Lt_FormatoTabla(0).Lr_PorcentajeComisionBco :=  Lt_ArrayTrama(4);
      Lt_FormatoTabla(0).Lr_ValorComisionBco      :=  Lt_ArrayTrama(5);
      Lt_FormatoTabla(0).Lr_ContieneRetencionF    :=  Lt_ArrayTrama(6);
      Lt_FormatoTabla(0).Lr_ContieneRetencionI    :=  Lt_ArrayTrama(7);
      Lt_FormatoTabla(0).Lr_ValorRetencionF       :=  Lt_ArrayTrama(8);
      Lt_FormatoTabla(0).Lr_ValorRetencionI       :=  Lt_ArrayTrama(9);
      Lt_FormatoTabla(0).Lr_ValorNeto             :=  Lt_ArrayTrama(10);
      Lt_FormatoTabla(0).Lv_PrefijoEmpresa        :=  Lt_ArrayTrama(11);
      
      Lt_ArrayTrama.DELETE();
      
  EXCEPTION
    
    WHEN OTHERS THEN
    
      Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_SEPARA_TRAMA_OBSERVACION';
      Pv_Error         := SQLERRM;

  END P_SEPARA_TRAMA_OBSERVACION;
  
  
  /*
    PROCEDIMIENTO QUE GRABA EL HISTORIAL DEL PAGO
  */
  PROCEDURE P_CREA_HISTORIAL_PAGO(Pn_IdPago          IN  NUMBER,
                                  Pv_Estado          IN  VARCHAR2,
                                  Pv_UsuarioCreacion IN  VARCHAR2,
                                  Pv_Motivo          IN  VARCHAR2,
                                  Pv_Comentario      IN  VARCHAR2,
                                  Pv_NombreProceso   OUT VARCHAR2,
                                  Pv_Error           OUT VARCHAR2) IS  
  BEGIN
  
    INSERT
    INTO DB_FINANCIERO.INFO_PAGO_HISTORIAL
      (
        ID_PAGO_HISTORIAL,
        PAGO_ID,
        MOTIVO_ID,
        FE_CREACION,
        USR_CREACION,
        ESTADO,
        OBSERVACION
      )
      VALUES
      (
        DB_FINANCIERO.SEQ_INFO_PAGO_HISTORIAL.NEXTVAL,
        Pn_IdPago,
        Pv_Motivo,
        SYSDATE,
        Pv_UsuarioCreacion,
        Pv_Estado,
        Pv_Comentario
      );
      
  EXCEPTION
    
      WHEN OTHERS THEN
       
        Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_CREA_HISTORIAL_PAGO';
        Pv_Error         := SQLERRM;
  
  END P_CREA_HISTORIAL_PAGO;
  
   
  /*
    Proceso encargado de actualizar el valor total del pago
  */ 
  PROCEDURE P_SET_VALOR_TOTAL_PAGO(Pn_IdPago        IN  NUMBER,
                                   Pn_ValorTotal    IN  NUMBER,
                                   Pv_NombreProceso OUT VARCHAR2,
                                   Pv_Error         OUT VARCHAR2) IS
  BEGIN
    
    UPDATE DB_FINANCIERO.INFO_PAGO_CAB
       SET VALOR_TOTAL = Pn_ValorTotal
    WHERE ID_PAGO = Pn_IdPago;
  
  EXCEPTION
    
    WHEN OTHERS THEN
      
      Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_SET_VALOR_TOTAL_PAGO';
      Pv_Error         := SQLERRM;
    
  END P_SET_VALOR_TOTAL_PAGO;


  /*
    FUNCION PARA OBTENER EL PADRE DE FACTURACION
  */
  FUNCTION F_GET_PADRE_FACTURACION(Fn_PersonaEmpRolId IN  NUMBER,
                                   Fv_NombreProceso   OUT VARCHAR2,
                                   Fv_Error           OUT VARCHAR2)
  RETURN NUMBER IS
  
    /* Cursor que retorna el padre de facturacion */
    CURSOR C_PadreFacturacion(Cn_PersonaEmpRolId NUMBER) IS
        SELECT a.*
        FROM DB_COMERCIAL.INFO_PUNTO a,
          DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL b
        WHERE a.ID_PUNTO             = b.PUNTO_ID
        AND a.PERSONA_EMPRESA_ROL_ID = Cn_PersonaEmpRolId
        AND b.ES_PADRE_FACTURACION   = 'S'
        ORDER BY a.ID_PUNTO ASC;
        
     Lc_PadreFacturacion  C_PadreFacturacion%ROWTYPE;
     Lb_Vacio             BOOLEAN;   
  
  BEGIN
  
    IF C_PadreFacturacion%ISOPEN THEN
      CLOSE C_PadreFacturacion;
    END IF;
    
    OPEN C_PadreFacturacion(Fn_PersonaEmpRolId);
    FETCH C_PadreFacturacion 
      INTO Lc_PadreFacturacion;
        --
        Lb_Vacio := C_PadreFacturacion%NOTFOUND;
        --
    CLOSE C_PadreFacturacion;
    
    IF Lb_Vacio THEN
      RETURN NULL;
    END IF;
    
    RETURN Lc_PadreFacturacion.ID_PUNTO;
    
  EXCEPTION
    
    WHEN OTHERS THEN
      
      Fv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.F_GET_PADRE_FACTURACION';
      Fv_Error         := SQLERRM;
      RETURN NULL;
  
  END F_GET_PADRE_FACTURACION;
  
  
  /*
    Procedimiento para actualizar la informacion del debito detalle
  */
  PROCEDURE P_SET_DEBITO_DET(Pn_IdDebitoDet     IN  NUMBER,
                             Pv_Estado          IN  VARCHAR2,
                             Pv_UsuarioCreacion IN  VARCHAR2,
                             Pn_ValorTotal      IN  NUMBER,
                             Pv_NombreProceso   OUT VARCHAR2,
                             Pv_Error           OUT VARCHAR2) IS
  BEGIN
  
    UPDATE DB_FINANCIERO.Info_Debito_Det det
     SET det.ESTADO         = Pv_Estado,
         det.FE_ULT_MOD     = SYSDATE,
         det.USR_ULT_MOD    = Pv_UsuarioCreacion,
         det.VALOR_DEBITADO = Pn_ValorTotal
    WHERE det.ID_DEBITO_DET = Pn_IdDebitoDet;
  
  EXCEPTION
    
    WHEN OTHERS THEN
      
      Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_SET_DEBITO_DET' ;
      Pv_Error         := SQLERRM;
    
  END P_SET_DEBITO_DET;
  
  
  /*
    PROCESO QUE CONTABILIZA EL DEBITO
  */
  PROCEDURE P_CONTABILIZA_DEB(Pv_PrefijoEmpresa    IN  VARCHAR2,
                              Pn_DebitoGeneralHist IN  NUMBER,
                              Pv_EmpresaId         IN  VARCHAR2,
                              Pv_NombreProceso     OUT VARCHAR2,
                              Pv_Error             OUT VARCHAR2) IS
     
     CURSOR C_ParametroDet(Cv_PrefijoEmpresa VARCHAR2) IS
        SELECT b.*
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB a,
          DB_GENERAL.ADMI_PARAMETRO_DET b
        WHERE a.ID_PARAMETRO   = b.PARAMETRO_ID
        AND a.NOMBRE_PARAMETRO = 'PROCESO CONTABILIZACION EMPRESA'
        AND a.MODULO           = 'FINANCIERO'
        AND b.VALOR1           = Cv_PrefijoEmpresa
        AND a.ESTADO           = 'Activo'
        AND b.ESTADO           = 'Activo';
        
     Lc_ParametroDet  C_ParametroDet%ROWTYPE;
     Lb_Vacio         BOOLEAN;
     Lv_Error         VARCHAR2(4000);
     
  BEGIN
  
    IF C_ParametroDet%ISOPEN THEN
      CLOSE C_ParametroDet;
    END IF;
    
    OPEN C_ParametroDet(Pv_PrefijoEmpresa);
    FETCH C_ParametroDet 
      INTO Lc_ParametroDet;
        --
        Lb_Vacio := C_ParametroDet%NOTFOUND;
        --
    CLOSE C_ParametroDet;
    
    IF Lb_Vacio THEN
      RETURN;
    END IF;
    
    IF NOT Lc_ParametroDet.VALOR2 = 'S' THEN
      RETURN;
    END IF;
    
    --Crea asientos contables
    DB_FINANCIERO.FNKG_CONTABILIZAR_DEBITOS.PROCESAR_DEBITOS(Pv_EmpresaId,
                                                             Pn_DebitoGeneralHist,
                                                             'MANUAL',
                                                             Lv_Error);

    IF Lv_Error != 'Proceso OK' THEN
      Pv_Error := Lv_Error;
    END IF;

  EXCEPTION
  
    WHEN OTHERS THEN
      
      Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_CONTABILIZA_DEB';
      Pv_Error         := SQLERRM;
      
  END P_CONTABILIZA_DEB;
  
  
  /*
    Proceso que actualiza el estado de las estructuras del proceso masivo
  */
  PROCEDURE P_SET_PROCESO_MASI_EST(Pn_IdProcesoMasivo IN  NUMBER,
                                   Pv_Estado          IN  VARCHAR2,
                                   Pv_NombreProceso   OUT VARCHAR2,
                                   Pv_Error           OUT VARCHAR2) IS
  BEGIN
  
    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
      SET ESTADO  = Pv_Estado, FE_ULT_MOD = SYSDATE
    WHERE PROCESO_MASIVO_CAB_ID = Pn_IdProcesoMasivo;
    
    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
      SET ESTADO  = Pv_Estado, FE_ULT_MOD = SYSDATE
    WHERE ID_PROCESO_MASIVO_CAB = Pn_IdProcesoMasivo;
  
  EXCEPTION
  
    WHEN OTHERS THEN
    
      Pv_NombreProceso := 'FNKG_PROCESO_MASIVO_DEB.P_SET_PROCESO_MASI_EST';
      Pv_Error         := SQLERRM;
    
  END P_SET_PROCESO_MASI_EST;


  /*
    METODO QUE REALIZA LA REACTIVACION DE LOS PUNTOS
  */
  PROCEDURE P_REACTIVAR_PUNTOS(PT_PUNTO              IN T_ArrayTrama,
                               Pv_PrefijoEmpresa     IN VARCHAR2,
                               Pv_EmpresaId          IN VARCHAR2,
                               Pn_OficinaId          IN NUMBER,
                               Pv_UsuarioCreacion    IN VARCHAR2,
                               Pv_Ip                 IN VARCHAR2,
                               Pn_DebitoCabId        IN NUMBER,
                               Pn_ProcesoMasivoCabId IN NUMBER) IS
    
    /* Cursos para obtener los parametros del webservice */
    CURSOR C_PARAMETROS_WS(Cv_EmpresaId VARCHAR2, Cv_NombreParametro VARCHAR2) IS
      SELECT DET.VALOR1,
             DET.VALOR2,
             DET.VALOR3,
             DET.VALOR4
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.ID_PARAMETRO   =  DET.PARAMETRO_ID
      AND CAB.ESTADO           = 'Activo'
      AND DET.ESTADO           = 'Activo'
      AND CAB.MODULO           = 'FINANCIERO'
      AND DET.EMPRESA_COD      =  Cv_EmpresaId
      AND CAB.NOMBRE_PARAMETRO =  Cv_NombreParametro;
    
    /* Variables locales */
    Lcl_Json          CLOB;
    Lcl_Putos         CLOB;
    Lcl_Respuesta     CLOB;
    Lv_Error          VARCHAR2(4000);
    Ln_Contador       NUMBER;
    Lc_ParametrosWs   C_PARAMETROS_WS%ROWTYPE;
    Lc_ParametrosCd   C_PARAMETROS_WS%ROWTYPE;
    Le_MyException    EXCEPTION;
    Ln_ControlError   NUMBER := 0;
    Lb_ControlError   BOOLEAN;

  BEGIN
    
    IF C_PARAMETROS_WS%ISOPEN THEN
      CLOSE C_PARAMETROS_WS;
    END IF;
    
    OPEN C_PARAMETROS_WS(Pv_EmpresaId,'PROCESO_REACTIVAR_SERVICIOS');
     FETCH C_PARAMETROS_WS 
        INTO Lc_ParametrosWs;
    CLOSE C_PARAMETROS_WS;

    OPEN C_PARAMETROS_WS(Pv_EmpresaId,'CERTIFICADO_DIGITAL_TELCOS');
     FETCH C_PARAMETROS_WS
        INTO Lc_ParametrosCd;
    CLOSE C_PARAMETROS_WS;
            
      IF PT_PUNTO.COUNT() > 0 THEN
      
        Ln_Contador := PT_PUNTO.FIRST;
        Lcl_Putos   := PT_PUNTO(Ln_Contador);
        
        LOOP

          EXIT WHEN Ln_Contador = PT_PUNTO.LAST();
          
          Ln_Contador := PT_PUNTO.NEXT(Ln_Contador);
          
          Lcl_Putos := Lcl_Putos ||','|| PT_PUNTO(Ln_Contador);
          
        END LOOP;
        
      END IF;

      /* Se Arma el json que sera enviaro al ws */
      Lcl_Json := '{ "data":{"prefijoEmpresa":"prefijoWS","empresaId":"empresaWS","oficinaId":"oficinaWS",';
      Lcl_Json := Lcl_Json ||'"usuarioCreacion":"userWS","ip":"ipWS","debitoId":"debitoWS","puntos":[arrayPuntos]},';
      Lcl_Json := Lcl_Json ||'"op":"opWS"}';
      
      /* se reemplaza los valores respectivos */
      Lcl_Json := REPLACE(Lcl_Json,'prefijoWS'  ,Pv_PrefijoEmpresa);
      Lcl_Json := REPLACE(Lcl_Json,'empresaWS'  ,Pv_EmpresaId);
      Lcl_Json := REPLACE(Lcl_Json,'oficinaWS'  ,Pn_OficinaId);
      Lcl_Json := REPLACE(Lcl_Json,'userWS'     ,Pv_UsuarioCreacion);
      Lcl_Json := REPLACE(Lcl_Json,'ipWS'       ,Pv_Ip);
      Lcl_Json := REPLACE(Lcl_Json,'debitoWS'   ,Pn_DebitoCabId);
      Lcl_Json := REPLACE(Lcl_Json,'arrayPuntos',Lcl_Putos);
      Lcl_Json := REPLACE(Lcl_Json,'opWS'       ,Lc_ParametrosWs.VALOR2);

      Lb_ControlError := TRUE;
      
      WHILE Lb_ControlError LOOP
      
        DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(Pv_Url             => Lc_ParametrosWs.VALOR1,
                                                  Pcl_Mensaje        => Lcl_Json,
                                                  Pv_Application     => Lc_ParametrosWs.VALOR3,
                                                  Pv_Charset         => Lc_ParametrosWs.VALOR4,
                                                  Pv_UrlFileDigital  => Lc_ParametrosCd.VALOR1,
                                                  Pv_PassFileDigital => Lc_ParametrosCd.VALOR2,
                                                  Pcl_Respuesta      => Lcl_Respuesta,
                                                  Pv_Error           => Lv_Error);
                                                  
        IF Lv_Error IS NOT NULL THEN
          Ln_ControlError := Ln_ControlError + 1;
        ElSE
          Lb_ControlError := FALSE;
        END IF;
        
        IF Ln_ControlError = 4 THEN
          RAISE Le_MyException;
        END IF;
      
      END LOOP;

      /* Inserta en la tabla INFO_PROCESO_MASIVO_DET*/
      INSERT
        INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
          (
            ID_PROCESO_MASIVO_DET,
            PROCESO_MASIVO_CAB_ID,
            PUNTO_ID,
            ESTADO,
            FE_CREACION,
            FE_ULT_MOD,
            USR_CREACION,
            USR_ULT_MOD,
            IP_CREACION,
            OBSERVACION         
          )
          VALUES
          (
            DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL,
            Pn_ProcesoMasivoCabId,
            Pn_DebitoCabId,
            'WsProcesado',
            SYSDATE,
            SYSDATE,
            Pv_UsuarioCreacion,
            Pv_UsuarioCreacion,
            Pv_Ip,
            Lcl_Json
          );
      COMMIT;  

  EXCEPTION
    
    WHEN Le_MyException THEN
    
      FNCK_TRANSACTION.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                    'FNKG_PROCESO_MASIVO_DEB.P_REACTIVAR_PUNTOS',
                                     Lv_Error || Lcl_Json);
    
    WHEN OTHERS THEN
      
      FNCK_TRANSACTION.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                    'FNKG_PROCESO_MASIVO_DEB.P_REACTIVAR_PUNTOS',
                                     SQLERRM || Lcl_Json);
      
  END P_REACTIVAR_PUNTOS;

  --
  FUNCTION F_GET_FORMATO_CUENTA(Fv_CuentaEncriptada   IN VARCHAR2,
                                Fv_ClaveDescencriptar IN VARCHAR2,
                                Fn_idPersonaRol       IN NUMBER)
  RETURN VARCHAR2 IS
   
    Lv_IpCreacion           VARCHAR2(15) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));  
    Lv_Paid                 VARCHAR2(10) := '|';
    Lv_Constante            VARCHAR2(50) ;
    Lv_CuentaDesencriptada  VARCHAR2(150);
    Lv_Pais                 VARCHAR2(50) ;
    Lv_CuentaFomateada      VARCHAR2(150);
    Lv_TipoCuenta           VARCHAR2(50) ;
    Lv_Formato              VARCHAR2(150);
    Lb_NoEncontrado         BOOLEAN;

    Cursor C_ParamConstante
    IS
      SELECT APD.VALOR1
      FROM 
        DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE 
        APC.ID_PARAMETRO = APD.PARAMETRO_ID AND
        APC.NOMBRE_PARAMETRO = 'CONSTANTE_FORMATO_CUENTA' AND
        APC.ESTADO = 'Activo' AND 
        APC.MODULO = 'FINANCIERO' AND
        APD.ESTADO = 'Activo';
  
  BEGIN

    IF C_ParamConstante%ISOPEN THEN
      CLOSE C_ParamConstante;
    END IF;

    OPEN C_ParamConstante ;
      FETCH C_ParamConstante INTO Lv_Constante;
        Lb_NoEncontrado := C_ParamConstante%NOTFOUND;
    CLOSE C_ParamConstante;
    
    IF Lb_NoEncontrado THEN
        RETURN NULL;
    END IF;
   
    DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_DESCENCRIPTAR(Fv_CuentaEncriptada,
                                                   Fv_ClaveDescencriptar,
                                                   Lv_CuentaDesencriptada);
    
    Lv_TipoCuenta := DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO('DESCRIPCION_TIPO_CUENTA',Fn_idPersonaRol);
    IF Lv_TipoCuenta    = 'AHORRO' THEN
        Lv_TipoCuenta := 'AH';
    ELSIF Lv_TipoCuenta = 'CORRIENTE' THEN
        Lv_TipoCuenta := 'CC';
    END IF;
    
    Lv_CuentaDesencriptada := LPAD(Lv_CuentaDesencriptada,11,'0');
    
    Lv_Pais            := DB_FINANCIERO.FNCK_CONSULTS.F_SET_ATTR_PAIS(Fn_idPersonaRol);
    Lv_Formato         := SUBSTR(Lv_Pais,1,2)||Lv_Paid||Lv_Constante||Lv_Paid||Lv_TipoCuenta||Lv_Paid;
    Lv_CuentaFomateada := Lv_Formato||Lv_CuentaDesencriptada;
                                          
    RETURN Lv_CuentaFomateada;

  EXCEPTION
    WHEN OTHERS THEN 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNKG_PROCESO_MASIVO_DEB.F_GET_FORMATO_CUENTA', 
                                           'Error al obtener informaci�n de CuentaFomateada del cliente
                                           (IdPersonaRol: '||Fn_IdPersonaRol||', Cuenta: ' ||Lv_CuentaFomateada|| ') - '
                                           || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'), 
                                           SYSDATE, 
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion) );
  --
  RETURN NULL;

  END F_GET_FORMATO_CUENTA;
  --
  
  PROCEDURE P_REPORTE_TRIBUTARIO(
      Pv_FechaReporteDesde IN VARCHAR2,
      Pv_FechaReporteHasta IN VARCHAR2,
      Pv_EmpresaCod        IN VARCHAR2,
      Pv_UsuarioSesion     IN VARCHAR2,
      Pv_ClaveSecret       IN VARCHAR2)
  IS
    
    Cursor C_CorreoUsuario(Cv_UsuarioSesion IN VARCHAR2)
    IS
      SELECT IPFC.VALOR FROM 
        DB_COMERCIAL.INFO_PERSONA IP 
        LEFT JOIN DB_COMERCIAL.INFO_PERSONA_FORMA_CONTACTO IPFC ON IP.ID_PERSONA = IPFC.PERSONA_ID
        LEFT JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC ON IPFC.FORMA_CONTACTO_ID = AFC.ID_FORMA_CONTACTO
      WHERE IP.LOGIN        = Cv_UsuarioSesion
            AND AFC.CODIGO  = 'MAIL' 
            AND IPFC.ESTADO = 'Activo';
            
    CURSOR C_GetImpuesto(Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE,
                         Cv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE)
    IS
      SELECT PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
        AND ESTADO        = Cv_EstadoActivo;          
     
    Cursor C_PagosPorDebitos (Cv_fechaCreacionDesde IN VARCHAR2,
                              Cv_fechaCreacionHasta IN VARCHAR2,
                              Cv_EmpresaCod         IN VARCHAR2)
    IS
    SELECT                             
      IPS.IDENTIFICACION_CLIENTE,
      IPER.ID_PERSONA_ROL,
      IPD.NUMERO_CUENTA_BANCO,
      IDD.VALOR_DEBITADO,
      IPC.USR_CREACION,
      DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_INFO_CLIENTE_CICLOFAC('CICLO_FACTURACION',IPER.ID_PERSONA_ROL) AS CICLO_FACTURACION
    FROM 
      DB_FINANCIERO.INFO_DEBITO_DET IDD,
      DB_FINANCIERO.INFO_PAGO_CAB IPC,
      DB_FINANCIERO.INFO_PAGO_DET IPD,
      DB_COMERCIAL.INFO_PUNTO IP,          
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PERSONA IPS,
      DB_GENERAL.ADMI_FORMA_PAGO AFP,
      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
    WHERE IPS.ID_PERSONA          = IPER.PERSONA_ID          
    AND IPER.ID_PERSONA_ROL       = IDD.PERSONA_EMPRESA_ROL_ID 
    AND IPER.ID_PERSONA_ROL       = IP.PERSONA_EMPRESA_ROL_ID
    AND IP.PERSONA_EMPRESA_ROL_ID = IDD.PERSONA_EMPRESA_ROL_ID    
    AND IPD.PAGO_ID               = IPC.ID_PAGO                
    AND IPC.DEBITO_DET_ID         = IDD.ID_DEBITO_DET          
    AND IPD.ESTADO                NOT IN ('Anulado','Asignado')   
    AND IPC.ESTADO_PAGO           NOT IN ('Anulado','Asignado')   
    AND AFP.ID_FORMA_PAGO         = IPD.FORMA_PAGO_ID 
    AND AFP.ID_FORMA_PAGO         = (SELECT ID_FORMA_PAGO FROM 
                                      DB_FINANCIERO.ADMI_FORMA_PAGO WHERE CODIGO_FORMA_PAGO = 'DEB')
    AND ATDF.ID_TIPO_DOCUMENTO = IPC.TIPO_DOCUMENTO_ID
    AND ATDF.ID_TIPO_DOCUMENTO IN (SELECT ATDF.ID_TIPO_DOCUMENTO 
                                    FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF 
                                    WHERE ATDF.CODIGO_TIPO_DOCUMENTO IN ('PAG','PAGC','ANT','ANTS','ANTC'))
                
    AND IPD.BANCO_TIPO_CUENTA_ID IN (SELECT ABTC.ID_BANCO_TIPO_CUENTA FROM 
                                        DB_GENERAL.ADMI_BANCO AB, 
                                        DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC, 
                                        DB_GENERAL.ADMI_TIPO_CUENTA ATC 
                                      WHERE 
                                        ABTC.BANCO_ID       = AB.ID_BANCO AND
                                        ABTC.TIPO_CUENTA_ID = ATC.ID_TIPO_CUENTA AND
                                        ATC.DESCRIPCION_CUENTA IN ('AHORRO', 'CORRIENTE')
                                        AND AB.DESCRIPCION_BANCO = 'BANCO GUAYAQUIL'
                                    ) 
    AND IPC.EMPRESA_ID  = Cv_EmpresaCod               
    AND IPC.FE_CREACION >= TO_DATE(Cv_fechaCreacionDesde,'DD/MM/YY') 
    AND IPC.FE_CREACION < TO_DATE(Cv_fechaCreacionHasta,'DD/MM/YY')+1 
    GROUP BY 
      IPS.IDENTIFICACION_CLIENTE, 
      IDD.VALOR_DEBITADO, 
      IPER.ID_PERSONA_ROL, 
      IPD.NUMERO_CUENTA_BANCO,
      IPC.USR_CREACION,
      DB_FINANCIERO.FNKG_REPORTE_FINANCIERO.F_INFO_CLIENTE_CICLOFAC('CICLO_FACTURACION',IPER.ID_PERSONA_ROL);
                          
  -- 
    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100)   := 'telcos@telconet.ec'; 
    Lv_Asunto                VARCHAR2(300)   := 'Reporte Tributario Banco Guayaquil';
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;
    
    Lv_NumeroCuenta          VARCHAR2(100);
    Lv_correoUsuario         VARCHAR2(100);
    Lb_NoEncontrado          BOOLEAN;
    Ln_Contador              NUMBER := 1;   
    Ln_AcumMontoDeb          NUMBER := 0;
    Ln_AcumBaseImpBien       NUMBER := 0;
    Ln_AcumBaseImpServ       NUMBER := 0;
    Ln_AcumBaseIvaBien       NUMBER := 0;
    Ln_AcumBaseIvaServ       NUMBER := 0;
    
    Lv_TipoImpuesto          DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := 'IVA';
    Lv_EstadoActivo          DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE        := 'Activo';
    Ln_ValorIva              NUMBER := 0;
    Ln_PorcentajeIva         NUMBER := 0;
    Lv_MensajeError          VARCHAR2(400);
    Le_Exception             EXCEPTION;
    
    Ln_SubtotalServicio      NUMBER;
    Ln_SubtotalBienes        NUMBER;
    Ln_IvaServicio           NUMBER;
    Ln_IvaBienes             NUMBER;
    Ln_SubtValor             NUMBER;
    
  BEGIN
    
    IF C_PagosPorDebitos%ISOPEN THEN
      CLOSE C_PagosPorDebitos;
    END IF;
    
    IF C_GetImpuesto%ISOPEN THEN
      CLOSE C_GetImpuesto;
    END IF;
    
    IF C_CorreoUsuario%ISOPEN THEN
      CLOSE C_CorreoUsuario;
    END IF;
    
    OPEN C_CorreoUsuario (Pv_UsuarioSesion);
      FETCH C_CorreoUsuario INTO Lv_correoUsuario;
        Lb_NoEncontrado := C_CorreoUsuario%NOTFOUND;
    CLOSE C_CorreoUsuario;
    
    OPEN C_GetImpuesto( Lv_TipoImpuesto, Lv_EstadoActivo );
        FETCH C_GetImpuesto INTO Ln_porcentajeIva;
    CLOSE C_GetImpuesto;
    
    
    IF Ln_PorcentajeIva > 0 THEN
        Ln_ValorIva := (Ln_PorcentajeIva/100) + 1;
    ELSE
      Lv_MensajeError := 'No se ha encontrado impuesto de IVA en estado Activo';
      RAISE Le_Exception;
    END IF;
    
    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_TRIB_GYE');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Lv_correoUsuario,'notificaciones_telcos@telconet.ec')||','; 
    
    Lv_NombreArchivo     := 'ReporteTributarioBancoGye_'||Lv_FechaReporte||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
    --
    utl_file.put_line(Lfile_Archivo,'No.'         ||Lv_Delimitador
                      ||'CTA BSCS'                ||Lv_Delimitador
                      ||'CTA BANCARIA'            ||Lv_Delimitador
                      ||'MONTO DEBITADO'          ||Lv_Delimitador
                      ||'BASE_IMPONIBLE_BIEN'     ||Lv_Delimitador
                      ||'BASE_IMPONIBLE_SERV'     ||Lv_Delimitador
                      ||'BASE_IMPONIBLE_IVA_BIEN' ||Lv_Delimitador
                      ||'BASE_IMPONIBLE_IVA_SERV' ||Lv_Delimitador
                      ||'CREADO POR'              ||Lv_Delimitador
                      ||'CICLO FACTURACION'       ||Lv_Delimitador); 
    --
    FOR Lr_GetPagosPorDebitos IN C_PagosPorDebitos(Pv_FechaReporteDesde,
                                                   Pv_FechaReporteHasta,
                                                   Pv_EmpresaCod) 
        LOOP
        IF Lr_GetPagosPorDebitos.VALOR_DEBITADO > 0 THEN
            Lv_NumeroCuenta := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_FORMATO_CUENTA(Lr_GetPagosPorDebitos.NUMERO_CUENTA_BANCO,
                                                                                          Pv_ClaveSecret,
                                                                                          Lr_GetPagosPorDebitos.ID_PERSONA_ROL);
            
            Ln_SubtotalServicio :=0;
            Ln_SubtotalBienes   :=0;
            Ln_IvaServicio      :=0;
            Ln_IvaBienes        :=0;
           
            Ln_SubtotalServicio := ROUND(((Lr_GetPagosPorDebitos.VALOR_DEBITADO)/Ln_ValorIva),2);
            Ln_IvaServicio      := ROUND((Lr_GetPagosPorDebitos.VALOR_DEBITADO-Ln_SubtotalServicio),2);
                                                                                                                               
            Ln_AcumMontoDeb    := Lr_GetPagosPorDebitos.VALOR_DEBITADO+Ln_AcumMontoDeb;
            Ln_AcumBaseImpBien := Ln_SubtotalBienes+Ln_AcumBaseImpBien;
            Ln_AcumBaseImpServ := Ln_SubtotalServicio+Ln_AcumBaseImpServ;
            Ln_AcumBaseIvaBien := Ln_IvaBienes+Ln_AcumBaseIvaBien;
            Ln_AcumBaseIvaServ := Ln_IvaServicio+Ln_AcumBaseIvaServ;
            
            UTL_FILE.PUT_LINE(Lfile_Archivo,
                                NVL(Ln_Contador, 0)                                   ||Lv_Delimitador
                              ||NVL(Lr_GetPagosPorDebitos.IDENTIFICACION_CLIENTE, '') ||Lv_Delimitador
                              ||NVL(Lv_NumeroCuenta, '')                              ||Lv_Delimitador
                              ||NVL(Lr_GetPagosPorDebitos.VALOR_DEBITADO, 0)          ||Lv_Delimitador   
                              ||NVL(Ln_SubtotalBienes, 0)                             ||Lv_Delimitador
                              ||NVL(Ln_SubtotalServicio, 0)                           ||Lv_Delimitador
                              ||NVL(Ln_IvaBienes, 0)                                  ||Lv_Delimitador
                              ||NVL(Ln_IvaServicio, 0)                                ||Lv_Delimitador
                              ||NVL(Lr_GetPagosPorDebitos.USR_CREACION, '')           ||Lv_Delimitador
                              ||NVL(Lr_GetPagosPorDebitos.CICLO_FACTURACION, '')      ||Lv_Delimitador
                             );
            
            Ln_Contador := Ln_Contador + 1;
            
        END IF;
    END LOOP;
    
    UTL_FILE.PUT_LINE(Lfile_Archivo,
                        NVL('', '')||Lv_Delimitador
                      ||NVL('', '')||Lv_Delimitador
                      ||NVL('', '')||Lv_Delimitador
                      ||NVL(Ln_acumMontoDeb,    0)||Lv_Delimitador   
                      ||NVL(Ln_acumBaseImpBien, 0)||Lv_Delimitador
                      ||NVL(Ln_acumBaseImpServ, 0)||Lv_Delimitador   
                      ||NVL(Ln_acumBaseIvaBien, 0)||Lv_Delimitador
                      ||NVL(Ln_acumBaseIvaServ, 0)||Lv_Delimitador
                      ||NVL('', '')||Lv_Delimitador
                      ||NVL('', '')||Lv_Delimitador
                     );
    --
    UTL_FILE.fclose(Lfile_Archivo);
    dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 
    
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip);

    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);
    
  EXCEPTION
    WHEN Le_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'FNKG_PROCESO_MASIVO_DEB.P_REPORTE_TRIBUTARIO', 
                                          Lv_MensajeError,
                                          'telcos_reporte',
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    --                                      
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurri� un error al generar el reporte tributario banco GYE.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNKG_PROCESO_MASIVO_DEB.P_REPORTE_TRIBUTARIO', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_reporte',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      
  END P_REPORTE_TRIBUTARIO;
  --
  --
  PROCEDURE P_GET_FACT_MENS_FILTRO_FECHA(Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                         Pv_FiltroFecha  IN  VARCHAR2,
                                         Pv_EmpresaId    IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.EMPRESA_ID%TYPE,
                                         Pr_Facturas     OUT SYS_REFCURSOR)
  IS
    --
    Lv_MessageError VARCHAR2(1000) := '';
    --
  BEGIN
    --
    OPEN Pr_Facturas 
        FOR 
            SELECT IDFC.ID_DOCUMENTO, IDFC.ESTADO_IMPRESION_FACT, 
              IDFC.NUMERO_FACTURA_SRI, IDFC.VALOR_TOTAL,
              IDFC.PUNTO_ID,IDFC.FE_CREACION, IDFC.TIPO_DOCUMENTO_ID 
            FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC, 
              DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
              DB_COMERCIAL.INFO_PUNTO IP,
              DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
              DB_COMERCIAL.INFO_OFICINA_GRUPO IOG 
            WHERE IPER.ID_PERSONA_ROL        = IP.PERSONA_EMPRESA_ROL_ID
              AND IDFC.PUNTO_ID              = IP.ID_PUNTO
              AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO  
              AND IDFC.OFICINA_ID            = IOG.ID_OFICINA 
              AND IOG.EMPRESA_ID             = Pv_EmpresaId 
              AND IPER.ID_PERSONA_ROL        = Pn_IdPersonaRol 
              AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC')      
              AND IDFC.ESTADO_IMPRESION_FACT IN ('Courier','Activo','Activa') 
              AND IDFC.RECURRENTE            = 'S'           
              AND IDFC.ES_AUTOMATICA         = 'S'           
              AND IDFC.USR_CREACION          = 'telcos'      
              AND IDFC.FE_EMISION            = TO_DATE(Pv_FiltroFecha,'DD/MM/RRRR')
            ORDER BY IDFC.FE_EMISION ASC;
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MessageError := 'Error en DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_FACT_MENS_FILTRO_FECHA - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB',
                                                'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_FACT_MENS_FILTRO_FECHA', 
                                                Lv_MessageError);
    --
  END P_GET_FACT_MENS_FILTRO_FECHA;
  --
  --
  PROCEDURE P_CLIENTES_DEBITO_FACT_MENS(Pv_IdEmpresa              IN VARCHAR2,
                                        Pn_IdBancoTipoCuenta      IN NUMBER,
                                        Pn_IdBancoTipoCuentaGrupo IN NUMBER,
                                        Pn_IdOficina              IN NUMBER,
                                        Pn_IdCiclo                IN NUMBER,
                                        Pv_FiltroFecha            IN VARCHAR2,
                                        Pr_Clientes               OUT SYS_REFCURSOR )
  AS
    --CONSTANTES
    Lv_FnUltContrato    CONSTANT VARCHAR2(100) := q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMO_CONTRATO_CLIENTE(IPE.ID_PERSONA,]';
    Lv_FnNumUltContrato CONSTANT VARCHAR2(100) := q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMO_NUMERO_CONTRATO_CLIENTE(IPE.ID_PERSONA,]';

    CURSOR C_CicloCaract 
    IS
      SELECT ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = 'CICLO_FACTURACION'
        AND ESTADO = 'Activo';

    Ln_IdCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;

    -- SE OBTIENE EL IMPUESTO DEL IVA EN ESTADO 'Activo'
    CURSOR C_GetImpuesto(Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE,
                         Cv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE)
    IS
      SELECT PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
        AND ESTADO = Cv_EstadoActivo;

    --
    Lv_CamposCriterio      VARCHAR2(100)  := '';
    Lv_CamposConsultarPor  VARCHAR2(100)  := '';
    Lv_GroupByConsultarPor VARCHAR2(100)  := '';
    Lv_ConsultarPor        VARCHAR2(100)  := '';
    Lv_Consulta            VARCHAR2(8600) := '';
    Ln_ValorIva            NUMBER         := 0;
    Ln_PorcentajeIva       NUMBER         := 0;

    Lv_MensajeError VARCHAR2(4000);
    Le_Exception    EXCEPTION;
    Lv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := 'IVA';
    Lv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE        := 'Activo';
    Lv_TablasQuery  VARCHAR2(400)                               := '';
    Lv_WhereQuery   VARCHAR2(400)                               := '';
    Lv_CicloConcat  VARCHAR2(20)                                := '';
    --
  BEGIN

    IF (Pn_IdCiclo IS NOT NULL AND Pn_IdCiclo > 0) THEN
        OPEN C_CicloCaract;
            FETCH C_CicloCaract INTO Ln_IdCaracteristica;
        CLOSE C_CicloCaract;

        Lv_TablasQuery := ' DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, ';
        Lv_WhereQuery  := ' AND IPERC.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL AND IPERC.CARACTERISTICA_ID = ' || Ln_IdCaracteristica
                          || ' AND IPERC.VALOR = ''' || Pn_IdCiclo || ''' AND IPERC.ESTADO = ''Activo'' ';
    END IF;
    --
    --SE OBTIENE EL IMPUESTO DEL IVA ACTIVO
    IF C_GetImpuesto%ISOPEN THEN
      CLOSE C_GetImpuesto;
    END IF;
    --
    OPEN C_GetImpuesto( Lv_TipoImpuesto, Lv_EstadoActivo );
        FETCH C_GetImpuesto INTO Ln_PorcentajeIva;
    CLOSE C_GetImpuesto;
    --
    --SE OBTIENE EL SEPARADOR DE COLUMNA Y LA AGRUPACION DEL QUERY PRINCIPAL
    --Costo query 3
    SELECT ANAE.CONSULTAR_POR 
      INTO Lv_ConsultarPor 
    FROM  
      DB_FINANCIERO.ADMI_NOMBRE_ARCHIVO_EMPRESA ANAE
    WHERE 
      ANAE.BANCO_TIPO_CUENTA_ID = Pn_IdBancoTipoCuentaGrupo
      AND ANAE.EMPRESA_COD = Pv_IdEmpresa;
    --
    --     
    IF Ln_PorcentajeIva > 0 THEN
      Ln_ValorIva := (Ln_PorcentajeIva/100) + 1;

    ELSE
      Lv_MensajeError := 'No se ha encontrado impuesto de IVA ACTIVO';
      --
      RAISE Le_Exception;
      --
    END IF;

    --CONSULTA EL AGRUPAMIENTO DEL QUERY PRINCIPAL
    IF (UPPER(Lv_ConsultarPor) = 'FACTURA') THEN
        Lv_CamposConsultarPor  := 'IP.LOGIN,IP.ID_PUNTO as puntoId,';
        Lv_GroupbyConsultarPor := 'IP.LOGIN,IP.ID_PUNTO,';

    ELSIF (UPPER(Lv_ConsultarPor) = 'CLIENTE') THEN
        Lv_CamposConsultarPor  := q'[ '' as login,'' as puntoId,]';
        Lv_GroupbyConsultarPor := '';

    END IF;

    --CONSULTA LA OFICINA DEL CLIENTE
    IF (UPPER(Pn_IdOficina) > 0) THEN
        Lv_CamposCriterio:=' AND IPER.OFICINA_ID = '||Pn_IdOficina ;

    ELSIF (UPPER(Lv_ConsultarPor) = 'CLIENTE') THEN
        Lv_CamposCriterio:='';

    END IF;

    --SE CONSTRUYE QUERY
    Lv_CicloConcat := NVL(Pn_IdCiclo,0) || ')';
    Lv_Consulta:= '
    SELECT '
    || Lv_CamposConsultarPor ||'
    IPE.ID_PERSONA, IOG.ID_OFICINA as oficinaId,
    IPE.NOMBRES, IPE.APELLIDOS, IPE.IDENTIFICACION_CLIENTE,
    ATC.ID_TIPO_CUENTA as tipo_Cuenta_Id, IPE.TIPO_IDENTIFICACION, ' ||'
    ABS(SUM(round(IDFC.SUBTOTAL_BIENES,     2))) as TOTAL_BIENES, 
    ABS(SUM(round(IDFC.SUBTOTAL_SERVICIOS,  2))) as TOTAL_SERVICIOS,
    ABS(SUM(round(IDFC.IMPUESTOS_SERVICIOS, 2))) as TOTAL_IVA_SERVICIOS, 
    ABS(SUM(round(IDFC.IMPUESTOS_BIENES,    2))) as TOTAL_IVA_BIENES, '
    ||q'[ IPE.RAZON_SOCIAL,]' 
    ||q'[ SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO,NULL,'saldo'),2)) as saldo, ]'
    ||q'[ SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO,NULL,'saldo'),2))]'||q'[/]'
    ||Ln_ValorIva||q'[ as baseImponible, AB.ID_BANCO as banco_id, ]'
    || Lv_FnUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'personaEmpresaRolId', ]'
    || Lv_CicloConcat
    ||' as personaEmpresaRolId, '
    || Lv_FnUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'contratoId', ]'
    || Lv_CicloConcat
    ||' as contratoId, '
    || Lv_FnUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'formaPagoId', ]'
    || Lv_CicloConcat
    ||' as contrato_Forma_Pago_Id, '
    || Lv_FnNumUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'numeroContrato',]'
    || Lv_CicloConcat
    ||' as numero_Contrato, '
    || Lv_FnNumUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'titularCuenta', ]'
    || Lv_CicloConcat
    ||' as titular_Cuenta, '
    || Lv_FnNumUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta
    ||q'[,'numeroCuentaTarjeta',]' || Lv_CicloConcat || ' as numero_Cta_Tarjeta, '
    ||q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMA_FACTURA_VALOR_CLIENTE(IPE.ID_PERSONA,'valor_total') as valorTotal, ]'
    ||q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMA_FACTURA_VALOR_CLIENTE(IPE.ID_PERSONA,'subtotal') as subtotal, ]'
    ||q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMA_FACTURA_VALOR_CLIENTE(IPE.ID_PERSONA,'id_documento') as idDocumento, ]'
    ||q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMA_FACTURA_CADENA_CLIENTE(IPE.ID_PERSONA,]'||Pv_IdEmpresa
    ||q'[,'numero_factura_sri') as numeroFacturaSri, ]'
    ||q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMA_FACTURA_FECHA_CLIENTE(IPE.ID_PERSONA) as feEmision, ]'
    ||q'[ 
    CASE 
      WHEN 
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMA_FACTURA_CADENA_CLIENTE(IPE.ID_PERSONA,]'||Pv_IdEmpresa||q'[,'numero_autorizacion') IS NULL 
      THEN
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMA_FACTURA_NUMAUT_CLIENTE(IPE.ID_PERSONA) 
      ELSE
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMA_FACTURA_CADENA_CLIENTE(IPE.ID_PERSONA,]'||Pv_IdEmpresa||q'[,'numero_autorizacion')
    END as numeroAutorizacion, 
        ]'
        ||q'[(SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO,NULL,'saldo'),2))
         - (SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO,NULL,'saldo'),2))/]'||Ln_ValorIva||q'[)) as valorIva, ]' 
        ||q'[
    CASE
      WHEN 
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_NUMERO_TELEFONO_CLI(IPE.ID_PERSONA) IS NULL 
      THEN 
        '0000000000'
      ELSE
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_NUMERO_TELEFONO_CLI(IPE.ID_PERSONA)
    END as numeroTelefono, ]'
    ||q'[
    CASE 
      WHEN 
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_NUMERO_TELEFONO_OP_CLI(IPE.ID_PERSONA) IS NULL 
      THEN 
        'P0000000000'
      ELSE
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_NUMERO_TELEFONO_OP_CLI(IPE.ID_PERSONA)
    END as numeroTelefonoOperador, ]'
    ||q'[
    CASE 
      WHEN 
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_EMAIL_CLI(IPE.ID_PERSONA) IS NULL 
      THEN 
        'noEmail'
      ELSE
        DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_EMAIL_CLI(IPE.ID_PERSONA)
    END as email]'
    ||'
    FROM 
      DB_COMERCIAL.INFO_PERSONA IPE, 
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER, 
      DB_COMERCIAL.INFO_EMPRESA_ROL IER, 
      DB_COMERCIAL.INFO_CONTRATO IC,
      DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP, '
      || Lv_TablasQuery ||
      ' 
      DB_COMERCIAL.INFO_OFICINA_GRUPO IOG, 
      DB_GENERAL.ADMI_FORMA_PAGO AFP, 
      DB_COMERCIAL.INFO_PUNTO IP, 
      DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC, 
      DB_GENERAL.ADMI_BANCO AB, 
      DB_GENERAL.ADMI_TIPO_CUENTA ATC, 
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC, 
      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF ' ||'
    WHERE 
      IPE.ID_PERSONA = IPER.PERSONA_ID '
      ||' AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL 
      AND IER.EMPRESA_COD = '||Pv_IdEmpresa || Lv_CamposCriterio 
      ||' AND IPER.ID_PERSONA_ROL = IC.PERSONA_EMPRESA_ROL_ID '
      || Lv_WhereQuery ||
       ' AND IPER.OFICINA_ID = IOG.ID_OFICINA 
      AND IC.ID_CONTRATO = ICFP.CONTRATO_ID 
      AND IC.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO '
      ||q'[AND (AFP.CODIGO_FORMA_PAGO = 'TARC' OR AFP.CODIGO_FORMA_PAGO = 'DEB') ]'
      ||' AND ICFP.BANCO_TIPO_CUENTA_ID = ABTC.ID_BANCO_TIPO_CUENTA 
      AND ABTC.BANCO_ID = AB.ID_BANCO 
      AND ABTC.TIPO_CUENTA_ID = ATC.ID_TIPO_CUENTA 
      AND ABTC.ID_BANCO_TIPO_CUENTA = '||Pn_IdBancoTipoCuenta
      ||' AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL '
      ||q'[AND IC.ESTADO NOT IN (SELECT APD.VALOR1 
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                  DB_GENERAL.ADMI_PARAMETRO_DET APD
                                WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                AND APC.ESTADO           = 'Activo'
                                AND APD.ESTADO           = 'Activo'
                                AND APC.NOMBRE_PARAMETRO = 'DEBITOS_ESTADOS_CONTRATO') ]'
      ||'
      AND IDFC.PUNTO_ID              = IP.ID_PUNTO
      AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO 
      AND ATDF.CODIGO_TIPO_DOCUMENTO =''FAC'' 
      AND IDFC.RECURRENTE            = ''S''
      AND IDFC.ES_AUTOMATICA         = ''S''
      AND IDFC.USR_CREACION          = ''telcos''
      AND IDFC.FE_EMISION            = '''||TO_DATE(Pv_FiltroFecha,'DD/MM/RRRR')||''' ' ||'  
    HAVING '
      ||q'[ SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO,NULL,'saldo'),2)) > 0.01]'
      ||q'[ AND (round(SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO,NULL,'saldo'),2))
       - (SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO,NULL,'saldo'),2)) /]'
      ||Ln_ValorIva||q'[), 2 ) )>0.00]' 
    ||' GROUP BY '
      || Lv_GroupByConsultarPor 
      || 'IPE.ID_PERSONA, IOG.ID_OFICINA, 
      IPE.NOMBRES, IPE.APELLIDOS, 
      IPE.IDENTIFICACION_CLIENTE, 
      ATC.ID_TIPO_CUENTA, 
      IPE.TIPO_IDENTIFICACION,
      IPE.RAZON_SOCIAL,
      AB.ID_BANCO ' ||'
      ORDER BY 
      IPE.ID_PERSONA';

    dbms_output.put_line(Lv_Consulta);

    --SE EJECTUA QUERY Y SE LO GUARDA EN CURSOR Pr_Clientes
    OPEN Pr_Clientes FOR Lv_Consulta;
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    Pr_Clientes := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB', 
                                         'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CLIENTES_DEBITO_FACT_MENS', 
                                         Lv_MensajeError,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    Pr_Clientes := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB', 
                                         'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CLIENTES_DEBITO_FACT_MENS', 
                                         'Error al obtener los clientes a debitar - ' || SQLCODE || ' - ERROR_STACK: ' 
                                         || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_CLIENTES_DEBITO_FACT_MENS;
  --
  --
  FUNCTION F_PROCESA_DOC_VALOR_PAGADO(Frf_Facturas             IN SYS_REFCURSOR,
                                      Fn_ValorPagado           IN NUMBER,
                                      Fv_EmpresaId             IN NUMBER,
                                      Fv_IdOficina             IN VARCHAR2,
                                      Fn_IdDebitoDet           IN NUMBER,
                                      Fn_IdFormaPago           IN NUMBER,
                                      Fv_UsrCreacion           IN VARCHAR2,
                                      Fn_IdDebitoGeneralH      IN NUMBER,
                                      Fn_IdBancoTipoCuenta     IN NUMBER,
                                      Fv_NumeroTarjetaCuenta   IN VARCHAR2
                                     )
  RETURN NUMBER
  IS
    
    Lr_NumeroPago       DB_FINANCIERO.INFO_PAGO_CAB.NUMERO_PAGO%TYPE;
    Lr_IdTipoDocumento  DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Lr_IdPago           DB_FINANCIERO.INFO_PAGO_CAB.ID_PAGO%TYPE;
    Lv_Error            VARCHAR2(500);
    Lv_ComentarioPago   VARCHAR2(100)  := 'Pago generado por debito - ';
    Lv_EstadoFactura    VARCHAR2(200);
    Ln_SaldoFactura     NUMBER;
    Ln_TotalPagNc       NUMBER;
    Ln_ValorPago        NUMBER;
    Ln_Indx             NUMBER;
    Lb_CierraFactura    BOOLEAN;
    Le_ExceptionFactura EXCEPTION;
    Lv_NombreProceso    VARCHAR2(3000);
    Lv_MessageError     VARCHAR2(1000) := '';
    La_FacturasProcesar T_FacturasProcesar;
    Lr_Factura          Lr_FacturasProcesar;
    
    Ln_ValorPagado      NUMBER := Fn_ValorPagado;
    --
  BEGIN
     /* Obtener las facturas del punto */
     LOOP
          FETCH Frf_Facturas BULK COLLECT INTO La_FacturasProcesar LIMIT 1000;
          Ln_Indx := La_FacturasProcesar.FIRST; 

            WHILE (Ln_Indx IS NOT NULL)       
              LOOP                  
                  Lr_Factura := La_FacturasProcesar(Ln_Indx);
                  --        
                   Lb_CierraFactura := FALSE;

                    IF Ln_ValorPagado > 0 THEN

                      /* Funcion para obtener la numeracion del pago */
                      Lr_NumeroPago := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_NUMERACION(Fv_EmpresaId, 
                                                                                              Fv_IdOficina,
                                                                                              'PDEB',
                                                                                              Lv_NombreProceso,
                                                                                              Lv_Error);

                      IF Lr_NumeroPago IS NULL OR Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionFactura;
                      END IF;

                      /* Funcion para obtener el tipo de documento */
                      Lr_IdTipoDocumento := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_TIPO_DOCUMENTO('PAG',
                                                                                                       'Activo',
                                                                                                       Lv_NombreProceso,
                                                                                                       Lv_Error);

                      IF Lr_IdTipoDocumento IS NULL OR Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionFactura;
                      END IF;

                      /* Funcion para crear y obtener el id del pago */
                      Lr_IdPago := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_CREA_PAGO(Lr_Factura.PUNTO_ID,
                                                                                     Fv_IdOficina,
                                                                                     Fv_EmpresaId,
                                                                                     Fn_IdDebitoDet,
                                                                                     Lr_NumeroPago,
                                                                                     Ln_ValorPagado,
                                                                                     'Cerrado',
                                                                                     Lv_ComentarioPago || Lt_FormatoTabla(0).Lr_CodigoDebito,
                                                                                     Fv_UsrCreacion,
                                                                                     Lr_IdTipoDocumento,
                                                                                     Fn_IdDebitoGeneralH,
                                                                                     Lv_NombreProceso,
                                                                                     Lv_Error);

                      IF Lr_IdPago IS NULL OR Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionFactura;
                      END IF;

                      /* Funcion que obtiene el total de los pagos mas las notas de creditos */
                      Ln_TotalPagNc := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_GET_TOTAL_PAG_NC(Lr_Factura.ID_DOCUMENTO, 
                                                                                                Lv_NombreProceso,
                                                                                                Lv_Error);

                      IF Ln_TotalPagNc IS NULL OR Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionFactura;
                      END IF;

                      Ln_SaldoFactura := ROUND(NVL(Lr_Factura.VALOR_TOTAL,0) - Ln_TotalPagNc,2);

                      IF Ln_SaldoFactura = Ln_ValorPagado THEN
                        Lb_CierraFactura := TRUE;
                        Ln_ValorPago     := Ln_ValorPagado;
                        Ln_ValorPagado   := Ln_ValorPagado - Ln_SaldoFactura;
                      ELSIF Ln_SaldoFactura < Ln_ValorPagado THEN
                        Lb_CierraFactura := TRUE;
                        Ln_ValorPago     := Ln_SaldoFactura;
                        Ln_ValorPagado   := Ln_ValorPagado - Ln_SaldoFactura;
                      ELSE
                        Ln_ValorPago     := Ln_ValorPagado;
                        Ln_ValorPagado   := Ln_ValorPago - Ln_ValorPago;
                      END IF;

                      /*Actualiza Factura*/
                      IF Lb_CierraFactura THEN

                        Lv_EstadoFactura := 'Cerrado';

                        DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SET_FACTURA_ESTADO(Lr_Factura.ID_DOCUMENTO, 
                                                                                   Lv_EstadoFactura,
                                                                                   Lv_NombreProceso,
                                                                                   Lv_Error);

                        IF Lv_Error IS NOT NULL THEN
                          RAISE Le_ExceptionFactura;
                        END IF;

                      ELSE

                        Lv_EstadoFactura := Lr_Factura.ESTADO_IMPRESION_FACT;

                      END IF;

                      /* Proceso para crear el historial de la factura*/
                      DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_FACTURA_HISTORIAL(Lr_Factura.ID_DOCUMENTO,
                                                                                     Lv_EstadoFactura,
                                                                                     Fv_UsrCreacion,
                                                                                     Lv_NombreProceso,
                                                                                     Lv_Error);

                      IF Lv_Error IS NOT NULL THEN
                       RAISE Le_ExceptionFactura;
                      END IF;

                      /* Crea el detalle del pago */
                      DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_DETALLE_PAGO(Lr_IdPago,
                                                                                Lt_FormatoTabla(0).Lr_FechaDocumento,
                                                                                Fv_UsrCreacion,
                                                                                Fn_IdFormaPago,
                                                                                Ln_ValorPago,
                                                                                Fn_IdBancoTipoCuenta,
                                                                                Lt_FormatoTabla(0).Lr_CodigoDebito,
                                                                                Fv_NumeroTarjetaCuenta,
                                                                                Lv_ComentarioPago || Lt_FormatoTabla(0).Lr_CodigoDebito,
                                                                                'Cerrado',
                                                                                Lr_Factura.ID_DOCUMENTO,
                                                                                Lv_NombreProceso,
                                                                                Lv_Error);

                      IF Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionFactura;
                      END IF;

                      /* Actualizamos el valor total del pago */
                      DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_SET_VALOR_TOTAL_PAGO(Lr_IdPago,
                                                                                   Ln_ValorPago,
                                                                                   Lv_NombreProceso,
                                                                                   Lv_Error);

                      IF Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionFactura;
                      END IF; 

                      /* Crea el historial del pago */
                      DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_HISTORIAL_PAGO(Lr_IdPago,
                                                                                  'Cerrado',
                                                                                  Fv_UsrCreacion,
                                                                                  NULL,
                                                                                  Lv_ComentarioPago || Lt_FormatoTabla(0).Lr_CodigoDebito,
                                                                                  Lv_NombreProceso,
                                                                                  Lv_Error);

                      IF Lv_Error IS NOT NULL THEN
                        RAISE Le_ExceptionFactura;
                      END IF;

                    END IF;

              Ln_Indx    := La_FacturasProcesar.NEXT(Ln_Indx);
              
              END LOOP;--Fin de WHILE (Ln_IndGpro IS NOT NULL)      
            EXIT WHEN Frf_Facturas%NOTFOUND;       

     END LOOP; 
     --        
     RETURN Ln_ValorPagado;       
  --
  EXCEPTION 
  WHEN Le_ExceptionFactura THEN
    --
    Lv_MessageError := 'Error en DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||'Fn_IdDebitoDet: '||Fn_IdDebitoDet||' Id_Factura: '||Lr_Factura.ID_DOCUMENTO;
                                   
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB',
                                                'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO', 
                                                Lv_MessageError);                                     
    RETURN NULL; 
  
  WHEN OTHERS THEN
    Lv_MessageError := 'Error en DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_ERROR('DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB',
                                                'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PROCESA_DOC_VALOR_PAGADO', 
                                                Lv_MessageError);                                                                                            
    RETURN NULL;                                     
    --
  END F_PROCESA_DOC_VALOR_PAGADO; 
  --
  --
  PROCEDURE P_GET_FACTURAS_X_CLIENTE(Pn_EmpresaId    IN  NUMBER, 
                                     Pn_PersonaRolId IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE, 
                                     Prf_FactCliente OUT SYS_REFCURSOR)
  AS

    BEGIN

    OPEN Prf_FactCliente FOR 
        SELECT TBL_TEMP_IDFC.ID_DOCUMENTO, TBL_TEMP_IDFC.ESTADO_IMPRESION_FACT, 
               TBL_TEMP_IDFC.NUMERO_FACTURA_SRI, TBL_TEMP_IDFC.VALOR_TOTAL, 
               TBL_TEMP_IDFC.PUNTO_ID, TBL_TEMP_IDFC.FE_CREACION, TBL_TEMP_IDFC.TIPO_DOCUMENTO_ID 
        FROM (
          SELECT IDFC.ID_DOCUMENTO, IDFC.ESTADO_IMPRESION_FACT, 
               IDFC.NUMERO_FACTURA_SRI, IDFC.VALOR_TOTAL, IDFC.PUNTO_ID, 
               IDFC.FE_CREACION, IDFC.TIPO_DOCUMENTO_ID
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
               DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
               DB_COMERCIAL.INFO_PUNTO IP,
               DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
               DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
          WHERE IPER.ID_PERSONA_ROL      = IP.PERSONA_EMPRESA_ROL_ID
          AND IDFC.PUNTO_ID              = IP.ID_PUNTO
          AND IDFC.NUMERO_FACTURA_SRI    IS NOT NULL
          AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
          AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
          AND IOG.EMPRESA_ID             = Pn_EmpresaId
          AND IPER.ID_PERSONA_ROL        = Pn_PersonaRolId
          AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
          AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier')
        UNION ALL
          SELECT IDFC_NDI.ID_DOCUMENTO, IDFC_NDI.ESTADO_IMPRESION_FACT, 
               IDFC_NDI.NUMERO_FACTURA_SRI, IDFC_NDI.VALOR_TOTAL, IDFC_NDI.PUNTO_ID, 
               IDFC_NDI.FE_CREACION, IDFC_NDI.TIPO_DOCUMENTO_ID
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_NDI,
               DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER_NDI,
               DB_COMERCIAL.INFO_PUNTO IP_NDI,
               DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_NDI,
               DB_COMERCIAL.INFO_OFICINA_GRUPO IOG_NDI,
               DB_COMERCIAL.ADMI_CARACTERISTICA AC_NDI, 
               DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_NDI 
          WHERE IPER_NDI.ID_PERSONA_ROL         = IP_NDI.PERSONA_EMPRESA_ROL_ID
          AND IDFC_NDI.PUNTO_ID                 = IP_NDI.ID_PUNTO
          AND IDFC_NDI.NUMERO_FACTURA_SRI       IS NOT NULL
          AND IDFC_NDI.TIPO_DOCUMENTO_ID        = ATDF_NDI.ID_TIPO_DOCUMENTO
          AND IDFC_NDI.OFICINA_ID               = IOG_NDI.ID_OFICINA
          AND IOG_NDI.EMPRESA_ID                = Pn_EmpresaId
          AND IPER_NDI.ID_PERSONA_ROL           = Pn_PersonaRolId
          AND IDFC_NDI.ID_DOCUMENTO             = IDC_NDI.DOCUMENTO_ID   
          AND AC_NDI.ID_CARACTERISTICA          = IDC_NDI.CARACTERISTICA_ID 
          AND ATDF_NDI.CODIGO_TIPO_DOCUMENTO    IN ('NDI') 
          AND IDFC_NDI.ESTADO_IMPRESION_FACT    IN ('Activo')
          AND AC_NDI.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO' 
          AND IDC_NDI.VALOR                     = 'S'            
      ) TBL_TEMP_IDFC ORDER BY TBL_TEMP_IDFC.FE_CREACION ASC, TBL_TEMP_IDFC.TIPO_DOCUMENTO_ID DESC;

  END P_GET_FACTURAS_X_CLIENTE;
  --
  --
  FUNCTION F_ULT_FACT_DIF_VALOR_CLIENTE(Fn_IdPersona     IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE, 
                                        Fv_CampoConsulta IN VARCHAR2, 
                                        Fn_EmpresaCod    IN NUMBER) 
  RETURN NUMBER 
  IS
    Fn_CampoRetorna    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
    Fn_CampoRetornaAux DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;
  BEGIN
        -- Costo del query: 66
    SELECT NVL(
               (
                 SELECT MAX(IDFC.ID_DOCUMENTO)
                    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                      DB_COMERCIAL.INFO_PUNTO IP,
                      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                      DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                      DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                    WHERE IDFC.PUNTO_ID                 = IP.ID_PUNTO 
                      AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL 
                      AND IPER.PERSONA_ID               = Fn_IdPersona 
                      AND IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL
                      AND IER.EMPRESA_COD               = Fn_EmpresaCod
                      AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO 
                      AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP')                      
                      AND IDFC.ESTADO_IMPRESION_FACT    IN ('Activo','Cerrado')                      
                      AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID        
                      AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID   
                      AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'         
                      AND IDC.VALOR                     = 'S' 
                      AND IDC.USR_CREACION              = 'telcos_diferido'
               ), '0'
              ) INTO Fn_CampoRetorna FROM DUAL;
      --  
      CASE 
        WHEN Fv_CampoConsulta = 'valor_total' THEN
          --
          -- Costo del query: 3
          SELECT VALOR_TOTAL INTO Fn_CampoRetorna 
          FROM ( 
                SELECT IDFC.VALOR_TOTAL 
                FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                WHERE IDFC.ID_DOCUMENTO = Fn_CampoRetorna 
               );
        --
        WHEN Fv_CampoConsulta = 'subtotal' THEN
          --
          -- Costo del query: 3
          SELECT SUBTOTAL INTO Fn_CampoRetorna 
          FROM ( 
                SELECT IDFC.SUBTOTAL 
                FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                WHERE IDFC.ID_DOCUMENTO = Fn_CampoRetorna 
               );
        --
        WHEN Fv_CampoConsulta = 'id_documento' THEN
          
          Fn_CampoRetornaAux := Fn_CampoRetorna;
          Fn_CampoRetorna := Fn_CampoRetornaAux;
      --
      END CASE;
    
    RETURN Fn_CampoRetorna;  
    
  END;
  --
  --
  FUNCTION F_ULT_FACT_DIF_CADENA_CLIENTE(Fn_IdPersona     IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                         Fn_EmpresaCod    IN NUMBER,
                                         Fv_CampoConsulta IN VARCHAR2) 
  RETURN VARCHAR2 
  IS
    Fv_CampoRetorna VARCHAR2(100) := '0';
  BEGIN
      -- Costo del query: 66
      SELECT NVL(
                 (
                   SELECT MAX(IDFC.ID_DOCUMENTO)
                    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                      DB_COMERCIAL.INFO_PUNTO IP,
                      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                      DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                      DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                    WHERE IDFC.PUNTO_ID                 = IP.ID_PUNTO 
                      AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL 
                      AND IPER.PERSONA_ID               = Fn_IdPersona 
                      AND IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL
                      AND IER.EMPRESA_COD               = Fn_EmpresaCod
                      AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO 
                      AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP')                      
                      AND IDFC.ESTADO_IMPRESION_FACT    IN ('Activo','Cerrado')                        
                      AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID        
                      AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID   
                      AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'         
                      AND IDC.VALOR                     = 'S' 
                      AND IDC.USR_CREACION              = 'telcos_diferido'
                 ), '0'
                ) INTO Fv_CampoRetorna FROM DUAL;
      --
      CASE 
      WHEN Fv_CampoConsulta = 'numero_factura_sri' THEN
        --
        -- Costo del query: 3
        SELECT NVL(
                   (
                     SELECT NUMERO_FACTURA_SRI 
                     FROM ( 
                           SELECT IDFC.NUMERO_FACTURA_SRI 
                           FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
                           WHERE IDFC.ID_DOCUMENTO = Fv_CampoRetorna 
                          )  
                   ), '0'
                  ) INTO Fv_CampoRetorna FROM DUAL;
      --
      WHEN Fv_CampoConsulta='numero_autorizacion' THEN
      --
      -- Costo del query: 2
        SELECT NUMERO_AUTORIZACION INTO Fv_CampoRetorna
        FROM ( 
              SELECT ICE.NUMERO_AUTORIZACION 
              FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC, 
                DB_FINANCIERO.INFO_COMPROBANTE_ELECTRONICO ICE
              WHERE IDFC.ID_DOCUMENTO = ICE.DOCUMENTO_ID 
              AND IDFC.ID_DOCUMENTO   = Fv_CampoRetorna 
             );
      --
      END CASE;
  
    RETURN Fv_CampoRetorna;
    
  END;
  --
  --
  FUNCTION F_ULT_FACT_DIF_FECHA_CLIENTE(Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                        Fn_EmpresaCod IN NUMBER)
    RETURN DATE
  IS
    Ld_CampoRetorna    DATE;
    Ln_IdDocEncontrado NUMBER;
  BEGIN
      -- Costo del query: 66
      SELECT NVL(
                 (
                    SELECT MAX(IDFC.ID_DOCUMENTO)
                      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                        DB_COMERCIAL.INFO_PUNTO IP,
                        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                        DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                     WHERE IDFC.PUNTO_ID                  = IP.ID_PUNTO 
                        AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL 
                        AND IPER.PERSONA_ID               = Fn_IdPersona 
                        AND IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL
                        AND IER.EMPRESA_COD               = Fn_EmpresaCod
                        AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO 
                        AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP')                      
                        AND IDFC.ESTADO_IMPRESION_FACT    IN ('Activo','Cerrado')                       
                        AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID        
                        AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID   
                        AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'         
                        AND IDC.VALOR                     = 'S' 
                        AND IDC.USR_CREACION              = 'telcos_diferido'
                 ), 0
                ) INTO Ln_IdDocEncontrado FROM DUAL;
      --
      -- Costo del query: 3
      SELECT FE_EMISION INTO Ld_CampoRetorna 
      FROM 
         (SELECT IDFC.FE_EMISION 
          FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
          WHERE IDFC.ID_DOCUMENTO = Ln_IdDocEncontrado 
         );
    --
    RETURN Ld_CampoRetorna;

  END;
  --
  --
  FUNCTION F_ULT_FACT_DIF_NUMAUT_CLIENTE(Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                         Fn_EmpresaCod IN NUMBER)
  RETURN VARCHAR2
  IS
    Lv_CampoRetorna VARCHAR2(100) := '0';
    Lv_NumeroUno    VARCHAR2(100);
    Lv_NumeroDos    VARCHAR2(100);
    Ln_IdDocumento  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
  
  BEGIN
  
    Ln_IdDocumento := DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_VALOR_CLIENTE(Fn_IdPersona, 'id_documento', Fn_EmpresaCod);
    
    SELECT num1, num2
    INTO Lv_NumeroUno,
      Lv_NumeroDos
    FROM
      (SELECT SUBSTR(IDFC.NUMERO_FACTURA_SRI,1, INSTR(IDFC.NUMERO_FACTURA_SRI, '-',1 ) -1) num1,
         SUBSTR(IDFC.NUMERO_FACTURA_SRI,5, INSTR(IDFC.NUMERO_FACTURA_SRI, '-',1 )      -1) num2
       FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
       WHERE IDFC.ID_DOCUMENTO = Ln_IdDocumento
      )
    WHERE ROWNUM = 1;
    
    SELECT NUMERO_AUTORIZACION
    INTO Lv_CampoRetorna
    FROM
       (SELECT NUMH.NUMERO_AUTORIZACION
        FROM DB_COMERCIAL.ADMI_NUMERACION NUM,
          DB_COMERCIAL.ADMI_NUMERACION_HISTO NUMH
        WHERE NUM.ID_NUMERACION = NUMH.NUMERACION_ID
        AND NUM.CODIGO          IN ('FACE','FAC','FACR')
        AND NUM.NUMERACION_UNO  = Lv_NumeroUno
        AND NUM.NUMERACION_DOS  = Lv_NumeroDos
        ORDER BY NUMH.ID_NUMERACION_HISTO DESC
       )
    WHERE ROWNUM = 1;
    
    RETURN Lv_CampoRetorna;
    
  END;
  --
  --
  FUNCTION F_PORCENTAJE_IMP_PROC_DIF(Fn_IdPersona  IN DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                     Fn_EmpresaCod IN NUMBER) 
  RETURN NUMBER 
  IS
     Cursor C_GetPorcentajeImp(Cn_IdPersona   NUMBER)
     IS
        SELECT AI.PORCENTAJE_IMPUESTO
        FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC
        JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET IDFD
        ON IDFD.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
        JOIN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP IDFI
        ON IDFI.DETALLE_DOC_ID = idfd.ID_DOC_DETALLE
        JOIN DB_GENERAL.ADMI_IMPUESTO AI
        ON AI.ID_IMPUESTO = IDFI.IMPUESTO_ID
        WHERE AI.TIPO_IMPUESTO = 'IVA'
        AND IDFC.ID_DOCUMENTO IN (
                                    SELECT MAX(IDFC.ID_DOCUMENTO)
                                      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
                                        DB_COMERCIAL.INFO_PUNTO IP,
                                        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                                        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
                                        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
                                        DB_COMERCIAL.ADMI_CARACTERISTICA AC,
                                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                                     WHERE IDFC.PUNTO_ID                  = IP.ID_PUNTO 
                                        AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL 
                                        AND IPER.PERSONA_ID               = Fn_IdPersona 
                                        AND IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL
                                        AND IER.EMPRESA_COD               = Fn_EmpresaCod
                                        AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO 
                                        AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('FAC','FACP')                      
                                        AND IDFC.ESTADO_IMPRESION_FACT    IN ('Activo','Cerrado')                       
                                        AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID        
                                        AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID   
                                        AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'         
                                        AND IDC.VALOR                     = 'S' 
                                        AND IDC.USR_CREACION              = 'telcos_diferido' 
                             )
        AND IDFC.USR_CREACION = 'telcos'                      
        AND ROWNUM = 1;
        
    Lv_MensajeError  VARCHAR2(100);    
    Ln_PorcentajeImp NUMBER := 0 ;
        
  BEGIN
    --
    IF C_GetPorcentajeImp%ISOPEN THEN
      CLOSE C_GetPorcentajeImp;
    END IF;
    
    OPEN C_GetPorcentajeImp(Fn_IdPersona);
        FETCH C_GetPorcentajeImp INTO Ln_PorcentajeImp;
    CLOSE C_GetPorcentajeImp;
    --
    RETURN Ln_PorcentajeImp;  
    
    EXCEPTION
      WHEN OTHERS THEN
    --
      Lv_MensajeError  := 'No se ha encontrado impuesto de IVA';
      Ln_PorcentajeImp := 0;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB', 
                                           'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PORCENTAJE_IMP', 
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                           SYSDATE, 
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );

      RETURN Ln_PorcentajeImp;
  END;
  --
  --
  PROCEDURE P_CLIENTES_DEBITO_NDI_DIF(Pv_IdEmpresa              IN VARCHAR2,
                                      Pn_IdBancoTipoCuenta      IN DB_FINANCIERO.ADMI_BANCO_TIPO_CUENTA.ID_BANCO_TIPO_CUENTA%TYPE,
                                      Pn_IdBancoTipoCuentaGrupo IN DB_FINANCIERO.ADMI_GRUPO_ARCHIVO_DEBITO_CAB.ID_GRUPO_DEBITO%TYPE,
                                      Pn_IdOficina              IN DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                      Pn_IdCiclo                IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,
                                      Pv_FiltroNumCuotas        IN VARCHAR2,
                                      Pr_Clientes               OUT SYS_REFCURSOR)
  AS
    --CONSTANTES
    Lv_FnUltContrato    CONSTANT VARCHAR2(100) := q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMO_CONTRATO_CLIENTE(IPE.ID_PERSONA,]';
    Lv_FnNumUltContrato CONSTANT VARCHAR2(100) := q'[ DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.ULTIMO_NUMERO_CONTRATO_CLIENTE(IPE.ID_PERSONA,]';

    CURSOR C_CicloCaract 
    IS
      SELECT ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = 'CICLO_FACTURACION'
        AND ESTADO = 'Activo';

    Ln_IdCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;

    -- SE OBTIENE EL IMPUESTO DEL IVA EN ESTADO 'Activo'
    CURSOR C_GetImpuesto(Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE,
                         Cv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE)
    IS
      SELECT PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE TIPO_IMPUESTO = Cv_TipoImpuesto
        AND ESTADO = Cv_EstadoActivo;

    --
    Lv_CodTipoDoc        VARCHAR2(100)    := 'NDI';
    Lv_EstadoNdi         VARCHAR2(100)    := 'Activo';
    Lv_UsrCracionNdi     VARCHAR2(100)    := 'telcos_diferido';
    Lv_DescCaractNdi     VARCHAR2(100)    := 'PROCESO_DIFERIDO';
    Lv_ValorDescNdi      VARCHAR2(100)    := 'S';

    Lv_CamposCriterio      VARCHAR2(100);
    Lv_CamposConsultarPor  VARCHAR2(100);
    Lv_GroupByConsultarPor VARCHAR2(100);
    Lv_ConsultarPor        VARCHAR2(100);
    Lv_Consulta            VARCHAR2(13000);
    Ln_ValorIva            NUMBER := 0;
    Ln_PorcentajeIva       NUMBER := 0;
    
    Lv_MensajeError VARCHAR2(4000);
    Le_Exception    EXCEPTION;
    Lv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE := 'IVA';
    Lv_EstadoActivo DB_GENERAL.ADMI_IMPUESTO.ESTADO%TYPE        := 'Activo';
    Lv_TablasQuery  VARCHAR2(400);
    Lv_WhereQuery   VARCHAR2(400);
    Lv_CicloConcat  VARCHAR2(20);
    
    --
  BEGIN

    IF (Pn_IdCiclo IS NOT NULL AND Pn_IdCiclo > 0) THEN
        OPEN C_CicloCaract;
            FETCH C_CicloCaract INTO Ln_IdCaracteristica;
        CLOSE C_CicloCaract;

        Lv_TablasQuery := ' DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, ';
        Lv_WhereQuery  := ' AND IPERC.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL AND IPERC.CARACTERISTICA_ID = ' || Ln_IdCaracteristica
                          || ' AND IPERC.VALOR = ''' || Pn_IdCiclo || ''' AND IPERC.ESTADO = ''Activo'' ';
    END IF;
    --
    --SE OBTIENE EL IMPUESTO DEL IVA ACTIVO
    IF C_GetImpuesto%ISOPEN THEN
      CLOSE C_GetImpuesto;
    END IF;
    --
    OPEN C_GetImpuesto( Lv_TipoImpuesto, Lv_EstadoActivo );
        FETCH C_GetImpuesto INTO Ln_PorcentajeIva;
    CLOSE C_GetImpuesto;
    --
    --SE OBTIENE EL SEPARADOR DE COLUMNA Y LA AGRUPACION DEL QUERY PRINCIPAL
    --Costo query 3
    SELECT ANAE.CONSULTAR_POR 
      INTO Lv_ConsultarPor 
    FROM  
      DB_FINANCIERO.ADMI_NOMBRE_ARCHIVO_EMPRESA ANAE
    WHERE 
      ANAE.BANCO_TIPO_CUENTA_ID = Pn_IdBancoTipoCuentaGrupo
      AND ANAE.EMPRESA_COD = Pv_IdEmpresa;
    --
    --     
    IF Ln_PorcentajeIva > 0 THEN
      Ln_ValorIva := (Ln_PorcentajeIva/100) + 1;

    ELSE
      Lv_MensajeError := 'No se ha encontrado impuesto de IVA ACTIVO';
      --
      RAISE Le_Exception;
      --
    END IF;

    --CONSULTA EL AGRUPAMIENTO DEL QUERY PRINCIPAL
    IF (UPPER(Lv_ConsultarPor) = 'FACTURA') THEN
        Lv_CamposConsultarPor  := 'IP.LOGIN,IP.ID_PUNTO as puntoId,';
        Lv_GroupbyConsultarPor := 'IP.LOGIN,IP.ID_PUNTO,';

    ELSIF (UPPER(Lv_ConsultarPor) = 'CLIENTE') THEN
        Lv_CamposConsultarPor  := q'[ '' as login,'' as puntoId,]';
        Lv_GroupbyConsultarPor := '';

    END IF;

    --CONSULTA LA OFICINA DEL CLIENTE
    IF (UPPER(Pn_IdOficina) > 0) THEN
        Lv_CamposCriterio:=' AND IPER.OFICINA_ID = '||Pn_IdOficina ;

    ELSIF (UPPER(Lv_ConsultarPor) = 'CLIENTE') THEN
        Lv_CamposCriterio:='';

    END IF;

    --SE CONSTRUYE QUERY
    Lv_CicloConcat := NVL(Pn_IdCiclo,0) || ')';
    Lv_Consulta := 
       'With TBL_INFO_DOC_NDI
         As( 
            SELECT 
              IDFC_NDI.*
            FROM 
              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_NDI,
              DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF_NDI,
              DB_COMERCIAL.ADMI_CARACTERISTICA AC_NDI,
              DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_NDI
            WHERE
                  IDFC_NDI.TIPO_DOCUMENTO_ID        = ATDF_NDI.ID_TIPO_DOCUMENTO 
              AND ATDF_NDI.CODIGO_TIPO_DOCUMENTO    = '''||Lv_CodTipoDoc||'''                 
              AND IDFC_NDI.ESTADO_IMPRESION_FACT    = '''||Lv_EstadoNdi||'''                   
              AND IDFC_NDI.USR_CREACION             = '''||Lv_UsrCracionNdi||'''          
              AND IDFC_NDI.ID_DOCUMENTO             = IDC_NDI.DOCUMENTO_ID        
              AND AC_NDI.ID_CARACTERISTICA          = IDC_NDI.CARACTERISTICA_ID   
              AND AC_NDI.DESCRIPCION_CARACTERISTICA = '''||Lv_DescCaractNdi||'''        
              AND IDC_NDI.VALOR                     = '''||Lv_ValorDescNdi||'''    
         ), 
        ' 
       ||'TBL_CLIENTES_DOC_NDI
        As( 
           SELECT IPE.ID_PERSONA, INFO_DOC_NDI.* '
        ||'
         FROM 
           DB_COMERCIAL.INFO_PERSONA IPE, 
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER, 
           DB_COMERCIAL.INFO_EMPRESA_ROL IER, 
           DB_COMERCIAL.INFO_CONTRATO IC,
           DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP, '
           || Lv_TablasQuery ||
           ' 
           DB_COMERCIAL.INFO_OFICINA_GRUPO IOG, 
           DB_GENERAL.ADMI_FORMA_PAGO AFP, 
           DB_COMERCIAL.INFO_PUNTO IP, 
           DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC, 
           DB_GENERAL.ADMI_BANCO AB, 
           DB_GENERAL.ADMI_TIPO_CUENTA ATC, 
           TBL_INFO_DOC_NDI INFO_DOC_NDI
         WHERE 
           IPE.ID_PERSONA = IPER.PERSONA_ID '
           ||' AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL 
           AND IER.EMPRESA_COD = '||Pv_IdEmpresa || Lv_CamposCriterio 
           ||' AND IPER.ID_PERSONA_ROL = IC.PERSONA_EMPRESA_ROL_ID '
           || Lv_WhereQuery ||
           ' AND IPER.OFICINA_ID = IOG.ID_OFICINA 
           AND IC.ID_CONTRATO = ICFP.CONTRATO_ID 
           AND IC.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO '
           ||q'[AND (AFP.CODIGO_FORMA_PAGO = 'TARC' OR AFP.CODIGO_FORMA_PAGO = 'DEB') ]'
           ||' AND ICFP.BANCO_TIPO_CUENTA_ID = ABTC.ID_BANCO_TIPO_CUENTA 
           AND ABTC.BANCO_ID = AB.ID_BANCO 
           AND ABTC.TIPO_CUENTA_ID = ATC.ID_TIPO_CUENTA 
           AND ABTC.ID_BANCO_TIPO_CUENTA = '||Pn_IdBancoTipoCuenta
           ||' AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL '
           ||q'[AND IC.ESTADO NOT IN (SELECT APD.VALOR1 
                                      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                        DB_GENERAL.ADMI_PARAMETRO_DET APD
                                      WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                      AND APC.ESTADO           = 'Activo'
                                      AND APD.ESTADO           = 'Activo'
                                      AND APC.NOMBRE_PARAMETRO = 'DEBITOS_ESTADOS_CONTRATO') ]'
           ||'
           AND INFO_DOC_NDI.PUNTO_ID        = IP.ID_PUNTO 
           AND INFO_DOC_NDI.ID_DOCUMENTO IN ( SELECT INFO_DOC_NDI_2.ID_DOCUMENTO 
                                              FROM TBL_INFO_DOC_NDI INFO_DOC_NDI_2
                                              WHERE            
                                                INFO_DOC_NDI_2.PUNTO_ID = IP.ID_PUNTO 
                                             )  
           ORDER BY IPE.ID_PERSONA, INFO_DOC_NDI.FE_CREACION ASC, INFO_DOC_NDI.ID_DOCUMENTO                           
        ) 
        '
    
       ||'SELECT '
            || Lv_CamposConsultarPor ||'
            IPE.ID_PERSONA AS ID_PERSONA, 
            IOG.ID_OFICINA as oficinaId, 
            IPE.NOMBRES AS NOMBRES, 
            IPE.APELLIDOS AS APELLIDOS, 
            IPE.IDENTIFICACION_CLIENTE AS IDENTIFICACION_CLIENTE, 
            ATC.ID_TIPO_CUENTA as tipo_Cuenta_Id, 
            IPE.TIPO_IDENTIFICACION AS TIPO_IDENTIFICACION, ' ||'
            0 as TOTAL_BIENES, 
            NVL(ABS(SUM(round(CLIENTES_DOC_NDI.SUBTOTAL,  2))),0) as TOTAL_SERVICIOS, 
            NVL(ABS(SUM(round((CLIENTES_DOC_NDI.SUBTOTAL) * 
            DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_PORCENTAJE_IMP_PROC_DIF(IPE.ID_PERSONA, '||Pv_IdEmpresa||') / 100, 2))),0) as TOTAL_IVA_SERVICIOS,  
            0 as TOTAL_IVA_BIENES, '
            ||q'[ IPE.RAZON_SOCIAL AS RAZON_SOCIAL, ]' 
            ||q'[ SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(CLIENTES_DOC_NDI.ID_DOCUMENTO,NULL,'saldo'),2)) as saldo, ]'
            ||q'[ SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(CLIENTES_DOC_NDI.ID_DOCUMENTO,NULL,'saldo'),2))/ ]'
            ||Ln_ValorIva||q'[ as baseImponible, AB.ID_BANCO as banco_id, ]'
            || Lv_FnUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'personaEmpresaRolId', ]'
            || Lv_CicloConcat
            ||' as personaEmpresaRolId, '
            || Lv_FnUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'contratoId', ]'
            || Lv_CicloConcat
            ||' as contratoId, '
            || Lv_FnUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'formaPagoId', ]'
            || Lv_CicloConcat
            ||' as contrato_Forma_Pago_Id, '
            || Lv_FnNumUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'numeroContrato',]'
            || Lv_CicloConcat
            ||' as numero_Contrato, '
            || Lv_FnNumUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta||q'[,'titularCuenta', ]'
            || Lv_CicloConcat
            ||' as titular_Cuenta, '
            || Lv_FnNumUltContrato ||Pv_IdEmpresa||','||Pn_IdBancoTipoCuenta
            ||q'[,'numeroCuentaTarjeta',]' || Lv_CicloConcat || ' as numero_Cta_Tarjeta, '
            ||q'[ DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_VALOR_CLIENTE(IPE.ID_PERSONA,'valor_total',]'||Pv_IdEmpresa
            ||q'[ ) as valorTotal, ]'
            ||q'[ DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_VALOR_CLIENTE(IPE.ID_PERSONA,'subtotal',]'||Pv_IdEmpresa
            ||q'[) as subtotal, ]'
            ||q'[ DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_VALOR_CLIENTE(IPE.ID_PERSONA,'id_documento',]'||Pv_IdEmpresa
            ||q'[) as idDocumento, ]'
            ||q'[ DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_CADENA_CLIENTE(IPE.ID_PERSONA,]'||Pv_IdEmpresa
            ||q'[,'numero_factura_sri') as numeroFacturaSri, ]'
            ||q'[ DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_FECHA_CLIENTE(IPE.ID_PERSONA,]'||Pv_IdEmpresa||') as feEmision, '
            ||q'[ 
            CASE 
             WHEN 
              DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_CADENA_CLIENTE(IPE.ID_PERSONA,]'||Pv_IdEmpresa||q'[,'numero_autorizacion') IS NULL 
             THEN
                DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_NUMAUT_CLIENTE(IPE.ID_PERSONA,]'||Pv_IdEmpresa||') 
             ELSE
                DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.F_ULT_FACT_DIF_CADENA_CLIENTE(IPE.ID_PERSONA,'||Pv_IdEmpresa||q'[,'numero_autorizacion')
            END as numeroAutorizacion, 
            ]'
            ||q'[(SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(CLIENTES_DOC_NDI.ID_DOCUMENTO,NULL,'saldo'),2))
             - (SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(CLIENTES_DOC_NDI.ID_DOCUMENTO,NULL,'saldo'),2))/]'||Ln_ValorIva
            ||q'[)) as valorIva, ]' 
            ||q'[
            CASE
              WHEN 
                DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_NUMERO_TELEFONO_CLI(IPE.ID_PERSONA) IS NULL 
              THEN 
                '0000000000'
              ELSE
                DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_NUMERO_TELEFONO_CLI(IPE.ID_PERSONA)
            END as numeroTelefono, ]'
            ||q'[
            CASE 
              WHEN 
                DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_NUMERO_TELEFONO_OP_CLI(IPE.ID_PERSONA) IS NULL 
              THEN 
                'P0000000000'
              ELSE
                DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_NUMERO_TELEFONO_OP_CLI(IPE.ID_PERSONA)
            END as numeroTelefonoOperador, ]'
            ||q'[
            CASE 
              WHEN 
                DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_EMAIL_CLI(IPE.ID_PERSONA) IS NULL 
              THEN 
                'noEmail'
              ELSE
                DB_FINANCIERO.CLIENTES_BANCO_DEBITO_PKG.OBTIENE_EMAIL_CLI(IPE.ID_PERSONA)
            END as email]'
        ||'
        FROM 
          DB_COMERCIAL.INFO_PERSONA IPE, 
          DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER, 
          DB_COMERCIAL.INFO_EMPRESA_ROL IER, 
          DB_COMERCIAL.INFO_CONTRATO IC,
          DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP, '
          || Lv_TablasQuery ||
          ' 
          DB_COMERCIAL.INFO_OFICINA_GRUPO IOG, 
          DB_GENERAL.ADMI_FORMA_PAGO AFP, 
          DB_COMERCIAL.INFO_PUNTO IP, 
          DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC, 
          DB_GENERAL.ADMI_BANCO AB, 
          DB_GENERAL.ADMI_TIPO_CUENTA ATC, 
          TBL_CLIENTES_DOC_NDI CLIENTES_DOC_NDI ' ||'
        WHERE 
          IPE.ID_PERSONA = IPER.PERSONA_ID '
          ||' AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL 
          AND IER.EMPRESA_COD = '||Pv_IdEmpresa || Lv_CamposCriterio 
          ||' AND IPER.ID_PERSONA_ROL = IC.PERSONA_EMPRESA_ROL_ID '
          || Lv_WhereQuery ||
           ' AND IPER.OFICINA_ID = IOG.ID_OFICINA 
          AND IC.ID_CONTRATO = ICFP.CONTRATO_ID 
          AND IC.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO '
          ||q'[AND (AFP.CODIGO_FORMA_PAGO = 'TARC' OR AFP.CODIGO_FORMA_PAGO = 'DEB') ]'
          ||' AND ICFP.BANCO_TIPO_CUENTA_ID = ABTC.ID_BANCO_TIPO_CUENTA 
          AND ABTC.BANCO_ID = AB.ID_BANCO 
          AND ABTC.TIPO_CUENTA_ID = ATC.ID_TIPO_CUENTA 
          AND ABTC.ID_BANCO_TIPO_CUENTA = '||Pn_IdBancoTipoCuenta
          ||' AND IP.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL '
          ||q'[AND IC.ESTADO NOT IN (SELECT APD.VALOR1 
                                     FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
                                       DB_GENERAL.ADMI_PARAMETRO_DET APD
                                     WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
                                     AND APC.ESTADO           = 'Activo'
                                     AND APD.ESTADO           = 'Activo'
                                     AND APC.NOMBRE_PARAMETRO = 'DEBITOS_ESTADOS_CONTRATO') ]'
          ||'
          AND IPE.ID_PERSONA                = CLIENTES_DOC_NDI.ID_PERSONA 
          AND IP.ID_PUNTO                   = CLIENTES_DOC_NDI.PUNTO_ID     
          AND CLIENTES_DOC_NDI.ID_DOCUMENTO IN ( SELECT CLIENTES_DOC_NDI_2.ID_DOCUMENTO 
                                                 FROM TBL_CLIENTES_DOC_NDI CLIENTES_DOC_NDI_2
                                                WHERE 
                                                  CLIENTES_DOC_NDI_2.ID_PERSONA = IPE.ID_PERSONA AND   
                                                  ROWNUM <= '||Pv_FiltroNumCuotas||'
                                               ) ' ||'  
        HAVING '
          ||q'[ SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(CLIENTES_DOC_NDI.ID_DOCUMENTO,NULL,'saldo'),2)) > 0.01]'
          ||q'[ AND (round(SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(CLIENTES_DOC_NDI.ID_DOCUMENTO,NULL,'saldo'),2))
           - (SUM(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(CLIENTES_DOC_NDI.ID_DOCUMENTO,NULL,'saldo'),2)) /]'
          ||Ln_ValorIva||q'[), 2 ) )>0.00]' 
        ||' GROUP BY '
          || Lv_GroupByConsultarPor 
          || 'IPE.ID_PERSONA, IOG.ID_OFICINA, 
          IPE.NOMBRES, IPE.APELLIDOS, 
          IPE.IDENTIFICACION_CLIENTE, 
          ATC.ID_TIPO_CUENTA, 
          IPE.TIPO_IDENTIFICACION,
          IPE.RAZON_SOCIAL,
          AB.ID_BANCO ' ||'
          ORDER BY 
          IPE.ID_PERSONA';

    dbms_output.put_line(Lv_Consulta);

    --SE EJECTUA QUERY Y SE LO GUARDA EN CURSOR Pr_Clientes
    OPEN Pr_Clientes FOR Lv_Consulta;
    --
  EXCEPTION
  WHEN Le_Exception THEN
    --
    Pr_Clientes := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB', 
                                         'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CLIENTES_DEBITO_NDI_DIF', 
                                         Lv_MensajeError,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  WHEN OTHERS THEN
    --
    Pr_Clientes := NULL;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB', 
                                         'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CLIENTES_DEBITO_NDI_DIF', 
                                         'Error al obtener los clientes a debitar - ' || SQLCODE || ' - ERROR_STACK: ' 
                                         || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                         NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_CLIENTES_DEBITO_NDI_DIF;
  --
  --
  PROCEDURE P_GET_NDI_DIF_FILTRO_CUOTAS(Pn_IdPersonaRol    IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                        Pv_FiltroNumCuotas IN  VARCHAR2,
                                        Pv_EmpresaId       IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                                        Pr_DocNdiDiferidas OUT SYS_REFCURSOR)
  IS
    --
    Lv_MessageError VARCHAR2(1000);
    --
  BEGIN
    --
   OPEN Pr_DocNdiDiferidas 
        FOR 
            SELECT TABLA_NDI.ID_DOCUMENTO, TABLA_NDI.ESTADO_IMPRESION_FACT, 
                   TABLA_NDI.NUMERO_FACTURA_SRI, TABLA_NDI.VALOR_TOTAL,
                   TABLA_NDI.PUNTO_ID,TABLA_NDI.FE_CREACION, TABLA_NDI.TIPO_DOCUMENTO_ID
            FROM
            (
             SELECT IDFC.ID_DOCUMENTO, IDFC.ESTADO_IMPRESION_FACT, 
               IDFC.NUMERO_FACTURA_SRI, IDFC.VALOR_TOTAL,
               IDFC.PUNTO_ID,IDFC.FE_CREACION, IDFC.TIPO_DOCUMENTO_ID
             FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
               DB_COMERCIAL.INFO_PUNTO IP,
               DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
               DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
               DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
               DB_COMERCIAL.ADMI_CARACTERISTICA AC,
               DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
             WHERE IDFC.PUNTO_ID = IP.ID_PUNTO 
               AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL 
               AND IPER.ID_PERSONA_ROL           = Pn_IdPersonaRol
               AND IDFC.OFICINA_ID               = IOG.ID_OFICINA  
               AND IOG.EMPRESA_ID                = Pv_EmpresaId 
               AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO 
               AND ATDF.CODIGO_TIPO_DOCUMENTO    = 'NDI'                      
               AND IDFC.ESTADO_IMPRESION_FACT    = 'Activo'                   
               AND IDFC.USR_CREACION             = 'telcos_diferido'          
               AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID        
               AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID   
               AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'         
               AND IDC.VALOR                     = 'S' 
               ORDER BY IDFC.FE_CREACION ASC, IDFC.ID_DOCUMENTO ASC
           ) TABLA_NDI
               WHERE ROWNUM <= Pv_FiltroNumCuotas ;
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MessageError := 'Error en DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_NDI_DIF_FILTRO_CUOTAS - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                         'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_NDI_DIF_FILTRO_CUOTAS',
                                         Lv_MessageError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_GET_NDI_DIF_FILTRO_CUOTAS;
  --
  --
  PROCEDURE P_GET_NDI_DIFERIDAS(Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                Pv_EmpresaId    IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE, 
                                Pr_NdiDiferidas OUT SYS_REFCURSOR)
  IS
    --
    Lv_MessageError VARCHAR2(1000);
    --
  BEGIN
    --
   OPEN Pr_NdiDiferidas 
        FOR 
             SELECT IDFC.ID_DOCUMENTO, IDFC.ESTADO_IMPRESION_FACT, 
               IDFC.NUMERO_FACTURA_SRI, IDFC.VALOR_TOTAL,
               IDFC.PUNTO_ID,IDFC.FE_CREACION, IDFC.TIPO_DOCUMENTO_ID 
             FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
               DB_COMERCIAL.INFO_PUNTO IP,
               DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
               DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,
               DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
               DB_COMERCIAL.ADMI_CARACTERISTICA AC,
               DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
             WHERE IDFC.PUNTO_ID                 = IP.ID_PUNTO 
               AND IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL 
               AND IPER.ID_PERSONA_ROL           = Pn_IdPersonaRol
               AND IDFC.OFICINA_ID               = IOG.ID_OFICINA  
               AND IOG.EMPRESA_ID                = Pv_EmpresaId 
               AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO 
               AND ATDF.CODIGO_TIPO_DOCUMENTO    = 'NDI'                      
               AND IDFC.ESTADO_IMPRESION_FACT    = 'Activo'                   
               AND IDFC.USR_CREACION             = 'telcos_diferido'          
               AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID        
               AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID   
               AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'         
               AND IDC.VALOR                     = 'S' 
               ORDER BY IDFC.FE_CREACION ASC, IDFC.ID_DOCUMENTO ASC;
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MessageError := 'Error en DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_NDI_DIFERIDAS - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                         'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_NDI_DIFERIDAS',
                                         Lv_MessageError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
    --
  END P_GET_NDI_DIFERIDAS;
  --
  --
  PROCEDURE P_GET_PTO_CLIENTE_ACTIVO(Pn_IdPersonaRol IN  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                     Pv_Estado       IN  DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE,
                                     Pn_IdPunto      OUT DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
  IS
    --
    Lv_MessageError VARCHAR2(1000);
    CURSOR C_GetPuntoClienteActivo(Cn_IdPersonaRol IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                                   Cv_Estado       IN DB_COMERCIAL.INFO_PUNTO.ESTADO%TYPE)
    IS
      SELECT IP.ID_PUNTO
         FROM     
         DB_COMERCIAL.INFO_PUNTO IP, 
         DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA 
         WHERE IP.ID_PUNTO             = IPDA.PUNTO_ID 
         AND IPDA.ES_PADRE_FACTURACION = 'S'             
         AND IP.ESTADO                 = Pv_Estado                         
         AND IP.PERSONA_EMPRESA_ROL_ID = Pn_IdPersonaRol             
         AND ROWNUM <= 1;
    --
  BEGIN
    --
    IF C_GetPuntoClienteActivo%ISOPEN THEN
      CLOSE C_GetPuntoClienteActivo;
    END IF;
    
    OPEN C_GetPuntoClienteActivo(Pn_IdPersonaRol, Pv_Estado);
        
        FETCH C_GetPuntoClienteActivo INTO Pn_IdPunto;
        
              IF C_GetPuntoClienteActivo%NOTFOUND THEN
                Pn_IdPunto := 0;
              END IF;
              
    CLOSE C_GetPuntoClienteActivo;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MessageError := 'Error en DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_PTO_CLIENTE_ACTIVO - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                         'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_GET_PTO_CLIENTE_ACTIVO',
                                         Lv_MessageError, NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_FINANCIERO'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
     Pn_IdPunto := 0;                                    
    --
  END P_GET_PTO_CLIENTE_ACTIVO;
  --

  --
  PROCEDURE P_CRUCE_ANTICIPO_PUNTO_CLIENTE(Pv_EstadoAnticipo  IN VARCHAR2,
                                           Pv_PrefijoEmpresa  IN VARCHAR2,
                                           Pv_CodigoDocAnt    IN VARCHAR2,
                                           Pv_CodigoDocAnts   IN VARCHAR2,
                                           Pv_CodigoDocAntc   IN VARCHAR2,
                                           Pv_Mensaje         OUT VARCHAR2)
  IS
    --
    CURSOR C_GetAnticipos(Cv_EstadoAnticipo  IN VARCHAR2,
                          Cv_PrefijoEmpresa  IN VARCHAR2,
                          Cv_CodigoDocAnt    IN VARCHAR2,
                          Cv_CodigoDocAnts   IN VARCHAR2,
                          Cv_CodigoDocAntc   IN VARCHAR2)
    IS
        SELECT PCAB.PUNTO_ID, PCAB.ID_PAGO, PCAB.VALOR_TOTAL, PCAB.ESTADO_PAGO, PCAB.NUMERO_PAGO
        FROM  
        DB_FINANCIERO.INFO_PAGO_CAB PCAB,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDFP, 
        DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPP  
        WHERE  
        PCAB.TIPO_DOCUMENTO_ID      = ATDFP.ID_TIPO_DOCUMENTO 
        AND PCAB.EMPRESA_ID         = EMPP.COD_EMPRESA 
        AND UPPER(EMPP.PREFIJO)     = Cv_PrefijoEmpresa 
        AND ATDFP.CODIGO_TIPO_DOCUMENTO IN (Cv_CodigoDocAnt,Cv_CodigoDocAnts,Cv_CodigoDocAntc) 
        AND PCAB.ESTADO_PAGO        = Cv_EstadoAnticipo 
        AND PCAB.VALOR_TOTAL        > 0 
        and PCAB.FE_CREACION        >= TO_DATE('2021/09/01', 'RRRR/MM/DD');  
        
    CURSOR C_ClientePorPunto(Cv_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) 
    IS
        SELECT IP.PERSONA_EMPRESA_ROL_ID
        FROM DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
        WHERE IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID   
        AND IP.ID_PUNTO     = Cv_IdPunto; 
        
    CURSOR C_ValidaCantPuntos(Cv_IdPersonaRol IN DB_COMERCIAL.INFO_PUNTO.PERSONA_EMPRESA_ROL_ID%TYPE)  
    IS
        SELECT IP.PERSONA_EMPRESA_ROL_ID 
        FROM DB_COMERCIAL.INFO_PUNTO IP, DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
        WHERE 
        IP.PERSONA_EMPRESA_ROL_ID     = IPER.ID_PERSONA_ROL 
        AND IP.PERSONA_EMPRESA_ROL_ID = Cv_IdPersonaRol
        HAVING COUNT(IP.ID_PUNTO)     > 1
        GROUP BY IP.PERSONA_EMPRESA_ROL_ID; 
      
    CURSOR C_GetPuntosCliente(Cv_IdPersonaRol  IN NUMBER)  
    IS
        SELECT IP.ID_PUNTO 
        FROM DB_COMERCIAL.INFO_PUNTO IP, DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA
        WHERE IP.ID_PUNTO             = IPDA.PUNTO_ID
        AND IPDA.ES_PADRE_FACTURACION = 'S'
        AND IP.PERSONA_EMPRESA_ROL_ID = Cv_IdPersonaRol; 
      
    CURSOR C_GetFacturasPorPunto(Cv_IdPunto        IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                 Cv_PrefijoEmpresa IN VARCHAR2)  
    IS
        SELECT TABLA.PUNTO_ID 
        FROM
        (
            SELECT IDFC.PUNTO_ID 
            FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC, 
            DB_COMERCIAL.INFO_OFICINA_GRUPO OFI,  
            DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP,
            DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF  
            WHERE IDFC.OFICINA_ID           = OFI.ID_OFICINA
            AND OFI.EMPRESA_ID              = EMP.COD_EMPRESA 
            AND ATDF.ID_TIPO_DOCUMENTO      = IDFC.TIPO_DOCUMENTO_ID
            AND UPPER(EMP.PREFIJO)          = Cv_PrefijoEmpresa 
            AND IDFC.ESTADO_IMPRESION_FACT  IN ('Activo','Courier') 
            AND IDFC.NUM_FACT_MIGRACION     IS NULL 
            AND ATDF.CODIGO_TIPO_DOCUMENTO  IN ('FAC','FACP') 
            AND IDFC.PUNTO_ID               = Cv_IdPunto
            AND ROWNUM < 2
            UNION
            SELECT IDFC.PUNTO_ID  
            FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC, 
            DB_COMERCIAL.INFO_OFICINA_GRUPO OFI,  
            DB_COMERCIAL.INFO_EMPRESA_GRUPO EMP, 
            DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF, 
            DB_COMERCIAL.ADMI_CARACTERISTICA DBAC, 
            DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DBIDC  
            WHERE 
            IDFC.OFICINA_ID=OFI.ID_OFICINA 
            AND  OFI.EMPRESA_ID=EMP.COD_EMPRESA 
            AND  ATDF.ID_TIPO_DOCUMENTO=IDFC.TIPO_DOCUMENTO_ID 
            AND  UPPER(EMP.PREFIJO)              = Cv_PrefijoEmpresa 
            AND  IDFC.ESTADO_IMPRESION_FACT      IN ('Activo') 
            AND  IDFC.NUM_FACT_MIGRACION         IS NULL
            AND  ATDF.CODIGO_TIPO_DOCUMENTO      IN ('NDI')
            AND  DBIDC.DOCUMENTO_ID              = IDFC.ID_DOCUMENTO 
            AND  DBIDC.VALOR                     = 'S'
            AND  DBAC.ID_CARACTERISTICA          = DBIDC.CARACTERISTICA_ID
            AND  DBAC.DESCRIPCION_CARACTERISTICA = ('PROCESO_DIFERIDO')
            AND  IDFC.PUNTO_ID                   = Cv_IdPunto
            AND ROWNUM < 2
        ) TABLA   
        WHERE
        ROWNUM < 2;
        
    CURSOR C_GetDatosPunto(Cv_IdPunto IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE) 
    IS
        SELECT IP.ID_PUNTO, IP.LOGIN
        FROM DB_COMERCIAL.INFO_PUNTO IP
        WHERE IP.ID_PUNTO = Cv_IdPunto; 
        
    Le_Exception                EXCEPTION;
    Lv_MessageError             VARCHAR2(1000);
    Lv_Error                    VARCHAR2(1000);
    Lv_MensajeHist              VARCHAR2(1000);
    Lc_IdPersonaRol             C_ClientePorPunto%ROWTYPE;
    Lc_PuntoPersonaEmpresaRol   C_ValidaCantPuntos%ROWTYPE;
    Lc_PuntoFactura             C_GetFacturasPorPunto%ROWTYPE;
    Lc_PuntoAnticipo            C_GetDatosPunto%ROWTYPE;
    Lc_PuntoAnticipoCruce       C_GetDatosPunto%ROWTYPE;
    Lv_ComentarioPagoAnt        VARCHAR2(1000);
    Lv_NombreProceso            VARCHAR2(3000);
    Ln_IdPersonaRol             NUMBER;
    Ln_PuntoAnticipoCruce       NUMBER;
    Ln_ContCantidadAnticipo     NUMBER := 0;
    --
  BEGIN
    --
    IF C_GetAnticipos%ISOPEN THEN
      CLOSE C_GetAnticipos;
    END IF;
    
    IF C_ClientePorPunto%ISOPEN THEN
      CLOSE C_ClientePorPunto;
    END IF;
    
    IF C_ValidaCantPuntos%ISOPEN THEN
      CLOSE C_ValidaCantPuntos;
    END IF;
    
    IF C_GetPuntosCliente%ISOPEN THEN
      CLOSE C_GetPuntosCliente;
    END IF;
    
    IF C_GetFacturasPorPunto%ISOPEN THEN
      CLOSE C_GetFacturasPorPunto;
    END IF; 
    
    IF C_GetDatosPunto%ISOPEN THEN
      CLOSE C_GetDatosPunto;
    END IF; 
    
     /* For para obtener los anticipos pendientes */
        FOR Anticipos IN C_GetAnticipos(Pv_EstadoAnticipo, Pv_PrefijoEmpresa, Pv_CodigoDocAnt, Pv_CodigoDocAnts, Pv_CodigoDocAntc) LOOP
          
          BEGIN
            Ln_PuntoAnticipoCruce     := NULL;
            Lc_IdPersonaRol           := NULL;
            Lc_PuntoPersonaEmpresaRol := NULL;
            
            OPEN C_ClientePorPunto(Anticipos.PUNTO_ID);
            FETCH C_ClientePorPunto INTO Lc_IdPersonaRol;
            CLOSE C_ClientePorPunto;  
            
            OPEN C_ValidaCantPuntos(Lc_IdPersonaRol.persona_empresa_rol_id);
            FETCH C_ValidaCantPuntos INTO Lc_PuntoPersonaEmpresaRol;
            CLOSE C_ValidaCantPuntos; 
            
            --Valido que el cliente tenga m�s de 1 punto
            IF Lc_PuntoPersonaEmpresaRol.persona_empresa_rol_id IS NOT NULL THEN
                Lc_PuntoFactura := NULL;
                
                OPEN C_GetFacturasPorPunto(Anticipos.PUNTO_ID, Pv_PrefijoEmpresa);
                FETCH C_GetFacturasPorPunto INTO Lc_PuntoFactura;
                CLOSE C_GetFacturasPorPunto; 
                
                IF Lc_PuntoFactura.PUNTO_ID IS NULL THEN
                    FOR PuntoPersonaEmpresaRol IN C_GetPuntosCliente(Lc_PuntoPersonaEmpresaRol.persona_empresa_rol_id) 
                    LOOP
                        OPEN C_GetFacturasPorPunto(PuntoPersonaEmpresaRol.ID_PUNTO, Pv_PrefijoEmpresa);
                        FETCH C_GetFacturasPorPunto INTO Lc_PuntoFactura;
                        CLOSE C_GetFacturasPorPunto; 
       
                        IF Lc_PuntoFactura.PUNTO_ID IS NOT NULL THEN 
                            Ln_PuntoAnticipoCruce := NULL;
                            Ln_PuntoAnticipoCruce := Lc_PuntoFactura.PUNTO_ID;
                            EXIT;
                        END IF; 
                    
                    END LOOP;
                ELSE
                    --Contin�a siguiente registro en caso de no existir facturas abiertas en el punto
                    CONTINUE;
                
                END IF; 
                
                 --Procedemos a actualizar y guardar historial.
                 IF Ln_PuntoAnticipoCruce IS NOT NULL THEN 
                    Lc_PuntoAnticipo      := NULL;
                    Lc_PuntoAnticipoCruce := NULL;
                    --Actualizamos el punto de la cabecera del anticipo
                    UPDATE DB_FINANCIERO.INFO_PAGO_CAB
                    SET PUNTO_ID  = Ln_PuntoAnticipoCruce
                    WHERE ID_PAGO = Anticipos.ID_PAGO;
                    
                    OPEN C_GetDatosPunto(Anticipos.PUNTO_ID);
                    FETCH C_GetDatosPunto INTO Lc_PuntoAnticipo;
                    CLOSE C_GetDatosPunto;  
                    
                    OPEN C_GetDatosPunto(Ln_PuntoAnticipoCruce);
                    FETCH C_GetDatosPunto INTO Lc_PuntoAnticipoCruce;
                    CLOSE C_GetDatosPunto;  
                    
                    --Se crea historial del pago.
                    Lv_ComentarioPagoAnt := NULL;
                    Lv_ComentarioPagoAnt := 'Se realiza el cambio del punto '||Lc_PuntoAnticipo.LOGIN||' al punto ' ||Lc_PuntoAnticipoCruce.LOGIN;

                    DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CREA_HISTORIAL_PAGO(Anticipos.ID_PAGO,
                                                                                Anticipos.ESTADO_PAGO,
                                                                                'telcos_cruce',
                                                                                NULL,
                                                                                Lv_ComentarioPagoAnt,
                                                                                Lv_NombreProceso,
                                                                                Lv_Error);
                                                                                 
                   --Se realiza commit por cada anticipo realizado
                   COMMIT; 
                   
                   --Se guarda log de historial del anticipo cruzado
                   Lv_MensajeHist := NULL;
                   Lv_MensajeHist := 'IdPago: '||Anticipos.ID_PAGO|| ' N�meroPago: '||Anticipos.NUMERO_PAGO|| ' Valor: '||Anticipos.VALOR_TOTAL||
                                     ' Estado: '||Anticipos.ESTADO_PAGO||' Observaci�n: ' ||Lv_ComentarioPagoAnt;
                   
                   DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                                        'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CRUCE_ANTICIPO_PUNTO_CLIENTE',
                                                        Lv_MensajeHist, 'telcos_cruce',
                                                        SYSDATE,
                                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                   
                   Ln_ContCantidadAnticipo := Ln_ContCantidadAnticipo+1;
                   Ln_PuntoAnticipoCruce   := NULL;
                   
                 END IF;

            END IF;
            
          EXCEPTION
            WHEN Le_Exception THEN
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'FNKG_PROCESO_MASIVO_DEB',
                                                    'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CRUCE_ANTICIPO_PUNTO_CLIENTE',
                                                    Lv_Error, 'telcos_cruce',
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') ); 
              Lv_Error := NULL;
          END;
        
        END LOOP;
    
       Pv_Mensaje := 'Se realiz� el proceso de actualizaci�n de anticipo por cruce entre puntos del cliente. Cantidad de anticipos cruzados: '||Ln_ContCantidadAnticipo;

    --
  EXCEPTION
  WHEN OTHERS THEN
    Lv_MessageError := 'Error en DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CRUCE_ANTICIPO_PUNTO_CLIENTE - ERROR_STACK: ' 
                       || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                       || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('FNKG_PROCESO_MASIVO_DEB',
                                         'DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CRUCE_ANTICIPO_PUNTO_CLIENTE',
                                         Lv_MessageError, 'telcos_cruce',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1') );
                                         
     Pv_Mensaje := 'Error en el proceso DB_FINANCIERO.FNKG_PROCESO_MASIVO_DEB.P_CRUCE_ANTICIPO_PUNTO_CLIENTE.';
    
  END P_CRUCE_ANTICIPO_PUNTO_CLIENTE;
  --

  --
END FNKG_PROCESO_MASIVO_DEB;
/