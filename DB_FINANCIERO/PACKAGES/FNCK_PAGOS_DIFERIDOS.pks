CREATE EDITIONABLE PACKAGE               FNCK_PAGOS_DIFERIDOS AS 

  /**
  * Documentaci�n para TYPE 'Lr_SolicDiferidos'.
  *  
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 16-04-2020
  */
  TYPE Lr_SolicDiferidos IS RECORD (
    ID_DETALLE_SOLICITUD   DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    ID_PERSONA_ROL         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    ID_PUNTO               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    ID_SERVICIO            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  );

  /**
  * Documentaci�n para TYPE 'T_SolicDiferidos'.
  * Record para almacenar la data enviada al BULK.
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 16-04-2020
  */
  TYPE T_SolicDiferidos IS TABLE OF Lr_SolicDiferidos INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para TYPE 'Lr_NciProcesoDiferidos'.
  *  
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-04-2020
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 23-05-2020 Se Modifica estructura principal debido a que se realiza Proceso de Generaci�n de NDI agrupadas
  */
  TYPE Lr_NciProcesoDiferidos IS RECORD (
    ID_PROCESO_MASIVO       DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
    ID_DETALLE_SOLICITUD    DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
    ID_PUNTO                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,  
    ES_CONT_DIFERIDO        NUMBER,
    ES_MESES_DIFERIDO       NUMBER,
    CANTIDAD_NCI            NUMBER
  );
  /**
  * Documentaci�n para TYPE 'T_NciProcesoDiferidos'.
  * Record para almacenar la data enviada al BULK.
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-04-2020
  */
  TYPE T_NciProcesoDiferidos IS TABLE OF Lr_NciProcesoDiferidos INDEX BY PLS_INTEGER;

  /**
  * Documentaci�n para PROCEDURE 'P_OBTIENE_GRUPOS_PROC_DIFERIDO'.
  *
  * El Procedimiento P_OBTIENE_GRUPOS_PROC_DIFERIDO obtiene los grupos parametrizados por banco_tipo_cuenta_id y por ciclo de facturaci�n 
  * para filtrar las solicitudes de tipo: 'SOLICITUD DIFERIDO DE FACTURA POR EMERGENCIA SANITARIA'
  * que procesar�n los diferidos para Facturas con saldo pendiente.
  *
  * Costo Query C_GruposEjecucion:6
  *
  * PARAMETROS:
  * @Param Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_UsrCreacion IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 16-04-2020
  *
  */
  PROCEDURE P_OBTIENE_GRUPOS_PROC_DIFERIDO(Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pv_UsrCreacion IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE);

  /**
  * Documentaci�n para PROCEDURE 'P_OBTIENE_GRUPOS_NDI_DIFERIDO'.
  *
  * El Procedimiento P_OBTIENE_GRUPOS_NDI_DIFERIDO obtiene los grupos parametrizados por banco_tipo_cuenta_id y por ciclo de facturaci�n 
  * para filtrar las Notas de Cr�dito Interna generadas por el proceso de diferido de Facturas por emergencia sanitaria, se generar�n las
  * NDI en base a las cuotas diferidas.
  * El proceso se ejecutar� el dia de inicio de Ciclo de Facturaci�n.
  * 
  * Costo Query C_GruposEjecucion:5
  * Costo Query C_GetCiclosDiaProceso: 2
  *
  * PARAMETROS:
  * @Param Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_UsrCreacion IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 23-04-2020
  *
  */
  PROCEDURE P_OBTIENE_GRUPOS_NDI_DIFERIDO(Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                          Pv_UsrCreacion IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE);

  /**
  * Documentaci�n para PROCEDURE 'P_EJECUTA_SOL_DIFERIDO'.
  *
  * Procedimiento P_EJECUTA_SOL_DIFERIDO Proceso de ejecuci�n masiva que lee las solicitudes de tipo: 
  * 'SOLICITUD DIFERIDO DE FACTURA POR EMERGENCIA SANITARIA' y procesa los diferidos para Facturas con saldo pendiente en base a 
  * los grupos parametrizados por banco_tipo_cuenta_id y por ciclo de facturaci�n, se encarga de generar NCI a las facturas registradas en la
  * Solicitud registrando los periodos a diferir que posteriormente generar�n NDI por cada cuota diferida seg�n el ciclo de Facturaci�n de cliente
  * en los procesos que se ejecutaran mensualmente.
  *
  * Costo Query C_GetSolCarac: 5
  * Costo Query C_GetMotivoNc: 2
  * Costo Query C_GetTipoDocumento: 2
  * Costo Query C_GetCaracterist: 2
  * Costo Query C_GetCantidadSolCarac: 5
  * Costo Query C_Parametros: 3
  * Costo Query C_GetCantidadFactSol: 6
  *
  * @Param Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_UsrCreacion           IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE
  * @Param Pv_DescripcionSolicitud  IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE
  * @Param Pv_FormaPago             IN VARCHAR2 DEFAULT NULL Descripcion de la forma de pago
  * @Param Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL Id del ciclo de Facturaci�n
  * @Param Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL Contiene Ids de Formas de Pagos o de emisores (Banco_tipo_cuenta_id) separados por coma.
  * @Param Pn_IdPunto               IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE (Id de Punto Cliente) DEFAULT NULL
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 16-04-2020
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 28-06-2020  - Se agrega par�metro intIdPunto para crear proceso individual de Diferido de Facturas por Punto en sesi�n
  *                            y se agrega par�metro de salida Pv_MsjResultado
  */
  PROCEDURE P_EJECUTA_SOL_DIFERIDO(Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_UsrCreacion           IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                   Pv_DescripcionSolicitud  IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                   Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                   Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                   Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                   Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                   Pv_MsjResultado          OUT VARCHAR2);

 /**
  * Documentaci�n para PROCEDURE 'P_EJECUTA_NDI_DIFERIDO'.
  *
  * Procedimiento P_EJECUTA_NDI_DIFERIDO Proceso de ejecuci�n masiva que lee las NCI generadas por el Proceso de Diferido de Facturas por emergencia 
  * Sanitaria, procesa en base a los grupos parametrizados por banco_tipo_cuenta_id y por ciclo de facturaci�n, se encarga de generar las NDI 
  * (Notas de d�bito interna) por las cuotas diferidas que se encuentran definidas en las NCI.
  * Proceso se ejecutar� seg�n el ciclo de Facturaci�n de cliente el d�a que le corresponde al inicio de ciclo.
  * 
  * Costo Query C_GetMotivoNc: 2
  * Costo Query C_GetCaracterist: 2
  * Costo Query C_GetDocumentoCaract: 5
  * Costo Query C_GetNciDiferidos: 11
  *
  * @Param Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_UsrCreacion           IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE
  * @Param Pv_FormaPago             IN VARCHAR2 DEFAULT NULL Descripcion de la forma de pago
  * @Param Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL Id del ciclo de Facturaci�n
  * @Param Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL Contiene Ids de Formas de Pagos o de emisores (Banco_tipo_cuenta_id) separados por coma.
  * @Param Pn_IdPunto               IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE (Id de Punto Cliente) DEFAULT NULL
  * @Param Pn_IdProcesoMasivoCab    IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE DEFAULT NULL
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 23-04-2020
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 23-05-2020 Se Modifica estructura principal debido a que se realiza Proceso de Generaci�n de NDI agrupadas.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.2 19-06-2020 Se modifica para que se guarde el campo de subtotal de la NDI.
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.3 28-06-2020  - Se agrega par�metro intIdPunto para crear proceso individual de Diferido de Facturas por Punto en sesi�n
  *                            y se agrega par�metro de salida Pv_MsjResultado y Pn_IdProcesoMasivoCab
  */
  PROCEDURE P_EJECUTA_NDI_DIFERIDO(Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_UsrCreacion           IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                   Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                   Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                   Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                   Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                   Pn_IdProcesoMasivoCab    IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE DEFAULT NULL,
                                   Pv_MsjResultado          OUT VARCHAR2);

  /**
  * Documentaci�n para el procedimiento P_CREA_NOTA_CREDITO_INTERNA
  * El procedimiento P_CREA_NOTA_CREDITO_INTERNA crea una nota de cr�dito interna por proceso de diferido 
  *
  *
  * @param  Pn_IdDocumento            IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Recibe el ID_DOCUMENTO
  * @param  Pn_ValorFactura           IN  NUMBER Valor minimo de Saldo que debe tener la Factura para poder diferirse.
  * @param  Pv_Observacion            IN  INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE  Recibe la OBSERVACI�N
  * @param  Pn_IdMotivo               IN  ADMI_MOTIVO.ID_MOTIVO%TYPE                      Recibe el ID_MOTIVO
  * @param  Pv_UsrCreacion            IN  INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE Recibe el USR_CREACION
  * @param  Pv_IdEmpresa              IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Recibe el COD_EMPRESA
  * @param  Pn_IdDocumentoNC          OUT INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Retorna el ID de la nota de cr�dito interna
  * @param  Pv_ObservacionCreacion    OUT VARCHAR2 Retorna la observaci�n del proceso de creaci�n de la NCI
  * @param  Pbool_Done                OUT BOOLEAN Retorna TRUE si se hizo la NCI, FALSE en caso de no hacerse la NCI
  * @param  Pv_MessageError           OUT VARCHAR2 Recibe un mensaje de error en caso de existir
  *  
  * Costo Query C_GetNombreTecnico: 2
  * Costo Query C_GetImpuestoPlan: 2
  * Costo Query C_GetPlan: 2
  * Costo Query C_Getimpuesto: 1
  * Costo Query C_GetNotaCreditoNoActiva: 7
  * Costo Query C_GetImpuestoDetalle: 4
  * Costo Query C_GetDocumentoHistorial: 11
  * Costo Query C_GetInfoDocFinancieroDet: 4
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 07-04-2020
  */
  PROCEDURE P_CREA_NOTA_CREDITO_INTERNA(Pn_IdDocumento            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                        Pn_ValorFactura           IN  NUMBER,
                                        Pv_Observacion            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
                                        Pn_IdMotivo               IN DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE,
                                        Pv_UsrCreacion            IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                        Pv_IdEmpresa              IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pn_IdDocumentoNC          OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                        Pv_ObservacionCreacion    OUT VARCHAR2,
                                        Pbool_Done                OUT BOOLEAN,
                                        Pv_MessageError           OUT VARCHAR2);
  /**
  * Documentaci�n para el procedimiento P_CREA_NOTA_DEBITO_INTERNA
  * El procedimiento P_CREA_NOTA_DEBITO_INTERNA crea una nota de debito interna por proceso de diferido 
  *
  *
  * @param  Pn_IdPunto                IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE. 
  * @param  Pn_ValorTotal             IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE.   
  * @param  Pv_IdEmpresa              IN  INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE Recibe el COD_EMPRESA.
  * @param  Pv_Observacion            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE.
  * @param  Pn_IdMotivo               IN  ADMI_MOTIVO.ID_MOTIVO%TYPE Recibe el ID_MOTIVO.
  * @param  Pv_UsrCreacion            IN  INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE Recibe el USR_CREACION
  * @param  Pn_IdDocumentoNdi         OUT INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Retorna el ID de la nota de debito interna.
  * @param  Pbool_Done                OUT BOOLEAN Retorna TRUE si se hizo la NDI, FALSE en caso de no hacerse la NDI.
  * @param  Pv_MessageError           OUT VARCHAR2 Recibe un mensaje de error en caso de existir.
  *   
  * Costo Query C_GetNumeracion: 2
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 23-04-2020
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.1 25-05-2020 Se Modifica estructura principal debido a que se realiza Proceso de Generaci�n de NDI agrupadas
  */
  PROCEDURE P_CREA_NOTA_DEBITO_INTERNA(Pn_IdPunto                IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE, 
                                       Pn_ValorTotal             IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE, 
                                       Pv_IdEmpresa              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_Observacion            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
                                       Pn_IdMotivo               IN  ADMI_MOTIVO.ID_MOTIVO%TYPE,
                                       Pv_UsrCreacion            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                       Pn_IdDocumentoNdi         OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                       Pbool_Done                OUT BOOLEAN,
                                       Pv_MessageError           OUT VARCHAR2);

  /**
  * Documentaci�n para la funci�n F_GET_VALOR_CUOTA_DIFERIDA
  * la funci�n F_GET_VALOR_CUOTA_DIFERIDA Obtiene el valor de la cuota Diferida en base a la NCI y el numero de meses del diferido, 
  * realiza el ajuste a la ultima cuota y devuelve el valor total de cuota diferida ajustada de ser el caso.
  *
  * @param Fn_IdDocumentoNci    IN  INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Obtiene el id factura
  * @param Fn_NumCuotaDiferida  IN  NUMBER,
  * @param Fn_MesesDiferido     IN  NUMBER
  * @return NUMBER Retorna el valor de la NCI simulada seg�n los par�metros de entrada.
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 07-04-2020
  */
  FUNCTION F_GET_VALOR_CUOTA_DIFERIDA(Fn_IdDocumentoNci    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                      Fn_NumCuotaDiferida  IN  NUMBER,
                                      Fn_MesesDiferido     IN  NUMBER)
  RETURN NUMBER;

  /**
  * Documentaci�n para la funci�n F_GET_VALOR_SIMULADO_NCI
  * la funci�n F_GET_VALOR_SIMULADO_NCI Simula la creaci�n de una nota de cr�dito interna por el porcentaje del saldo pendiente de la Factura
  * y devuelve el valor total.
  *
  * @param Fn_IdDocumento         IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Obtiene el id factura
  * @param Fn_Porcentaje          IN NUMBER   Obtiene el porcentaje a aplicarse
  * @return NUMBER Retorna el valor de la NCI simulada seg�n los par�metros de entrada.
  *
  * Costo Query C_GetInfoDocFinancieroDet: 4
  * Costo Query C_GetInfoPlanCab: 2
  * Costo Query C_GetInfoProductoImpuesto: 2
  * Costo Query C_GetAdmiImpuesto: 4    
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 07-04-2020
  */
  FUNCTION F_GET_VALOR_SIMULADO_NCI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                    Fn_Porcentaje   IN NUMBER)
  RETURN NUMBER;

  /**
  * Documentaci�n para la funci�n F_GET_PORCENTAJE_SALDO
  * la funci�n F_GET_PORCENTAJE_SALDO Obtiene el porcentaje que representa el saldo de la Factura sobre el cual se calcular� la NCI.
  *
  * @param Fn_IdDocumento         IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Obtiene el id factura  
  * @return NUMBER  Retorna Porcentaje a calcularse para NCI.
  *
  * Costo Query C_GetInfoDocFinancieroDet: 4
  * Costo Query C_GetAdmiProducto: 2
  * Costo Query C_GetImpuestoDetalle: 3
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 13-04-2020
  */
  FUNCTION F_GET_PORCENTAJE_SALDO(Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER;

  /**
  * Documentaci�n para la funci�n F_GET_SUM_DETALLES_NCI
  * la funci�n F_GET_SUM_DETALLES_NCI obtiene la sumatoria de detalles de NC o NCI generadas por detalle de Factura.
  *
  * @param Fn_IdDocumento         IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE  Obtiene el id factura  
  * @param Fn_IdDocDetalle        IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE Obtiene id detalle de Factura
  * @return NUMBER  
  *
  * Costo Query C_GetSumDetalleNcServ: 193
  * Costo Query C_GetSumDetalleNcPlan: 31
  * Costo Query C_GetSumDetalleNcProd: 31
  * Costo Query C_GetInfoDocFinancieroDet: 3
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 14-04-2020
  */
  FUNCTION F_GET_SUM_DETALLES_NCI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                  Fn_IdDocDetalle IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  RETURN NUMBER;

  /**
  * Documentaci�n para el procedimiento P_NUMERA_NOTA_CREDITO_INTERNA
  * El procedimiento P_NUMERA_NOTA_CREDITO_INTERNA Se encarga de numerar y activar una NCI.
  *
  *
  * @param  Pn_IdDocumento            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE 
  * @param  Pv_CodEmpresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @param  Pn_IdOficina              IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE
  * @param  Pv_ObsHistorial           IN  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE
  * @param  Pv_UsrCreacion            IN  VARCHAR2
  * @param  Pv_Numeracion             OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE
  * @param  Pv_Mensaje                OUT VARCHAR2
  * 
  * Costo Query C_GetParamNumeraNci: 4
  * Costo Query C_GetNumeracionNci: 2 
  *
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 14-04-2020
  */ 
  PROCEDURE P_NUMERA_NOTA_CREDITO_INTERNA (Pn_IdDocumento    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                           Pv_CodEmpresa     IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pn_IdOficina      IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                           Pv_ObsHistorial   IN  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE,
                                           Pv_UsrCreacion    IN  VARCHAR2,
                                           Pv_Numeracion     OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
                                           Pv_Mensaje        OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSERT_INFO_DOCUMENTO_CARACT'.
  *
  * Procedimiento que inserta registro de caracteristica para el Documento en INFO_DOCUMENTO_CARACTERISTICA
  *
  * @Param Pr_InfoDocumentoCaract  IN   DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE Recibe un registro con la informaci�n necesaria.
  * @Param Pv_MsnError             OUT  VARCHAR2  Devuelve un mensaje del resultado de ejecuci�n
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-04-2020
  */
  PROCEDURE P_INSERT_INFO_DOCUMENTO_CARACT(Pr_InfoDocumentoCaract IN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE,
                                           Pv_MsnError            OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_DOCUMENTO_CARACT'.
  *
  * Procedimiento que actualiza registro de caracteristica para el Documento en INFO_DOCUMENTO_CARACTERISTICA
  *
  * @Param Pr_InfoDocumentoCaract  IN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE Recibe un registro con la informaci�n
  * @Param Pv_MsnError             OUT  VARCHAR2  Devuelve un mensaje del resultado de ejecuci�n
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-04-2020
  */
  PROCEDURE P_UPDATE_INFO_DOCUMENTO_CARACT(Pr_InfoDocumentoCaract IN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE,
                                           Pv_MsnError            OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSERT_INFO_DETALLE_SOL_HIST'.
  *
  * Procedimiento que inserta registro de historial en la solicitud en INFO_DETALLE_SOL_HIST
  *
  * @Param Pr_InfoDetalleSolHist  IN   DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE Recibe un registro con la informaci�n necesaria para ingresar
  * @Param Pv_MsnError            OUT  VARCHAR2  Devuelve un mensaje del resultado de ejecuci�n
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-04-2020
  */
  PROCEDURE P_INSERT_INFO_DETALLE_SOL_HIST(Pr_InfoDetalleSolHist   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,
                                           Pv_MsnError             OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_DETALLE_SOLIC'.
  *
  * Procedimiento que actualiza registro de la solicitud en INFO_DETALLE_SOLICITUD
  *
  * @Param Pr_InfoDetalleSolicitud  IN   DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE Recibe un registro con la informaci�n
  * @Param Pv_MsnError              OUT  VARCHAR2  Devuelve un mensaje del resultado de ejecuci�n
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-04-2020
  */
  PROCEDURE P_UPDATE_INFO_DETALLE_SOLIC(Pr_InfoDetalleSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                            Pv_MsnError             OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_DETALLE_SOL_CARA'.
  *
  * Procedimiento que actualiza registro de la caracteristica asociada a la solicitud en INFO_DETALLE_SOL_CARACT
  *
  * @Param Pr_InfoDetalleSolCaract  IN   DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE Recibe un registro con la informaci�n
  * @Param Pv_MsnError              OUT  VARCHAR2  Devuelve un mensaje del resultado de ejecuci�n
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-04-2020
  */
  PROCEDURE P_UPDATE_INFO_DETALLE_SOL_CARA(Pr_InfoDetalleSolCaract IN  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE,
                                           Pv_MsnError             OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'UPDATE_INFO_DOC_FINANCIERO_DET'.
  *
  * Procedimiento que actualiza registro detalle de documento, actualiza precio y observaci�n.
  *
  * @Param Pn_IdDocumento                IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
  * @Param Pr_InfoDocumentoFinancieroDet IN INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE,
  * @Param Pv_MsnError                   OUT  VARCHAR2  Devuelve un mensaje del resultado de ejecuci�n
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-04-2020
  */
  PROCEDURE UPDATE_INFO_DOC_FINANCIERO_DET( Pn_IdDocumento                IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                            Pr_InfoDocumentoFinancieroDet IN INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE,
                                            Pv_MsnError                   OUT VARCHAR2);
  /**
  * Documentaci�n para F_GET_CARACT_DOCUMENTO
  * Retorna el valor de la Caracteristica del Documento.
  * 
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 26-04-2020
  *
  * @param   Fn_IdDocumento   IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE Id Documento
  * @param   Fv_DesCaract     IN VARCHAR2 Descripci�n de Caracteristica
  * @return VARCHAR2   Retorna Valor de la Caracteristica.
  */
  FUNCTION F_GET_CARACT_DOCUMENTO(
      Fn_IdDocumento   IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
      Fv_DesCaract     IN VARCHAR2)
    RETURN VARCHAR2;

 /**
  * Documentaci�n para la funci�n F_GET_TOTAL_DIFERIDO
  * La funci�n F_GET_TOTAL_DIFERIDO Obtiene valor Total Diferido = Total de la Deuda(Los valores diferidos en cada proceso).  
  *
  * Costo Query C_GetTotalDiferido: 9
  *
  * @param Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @return NUMBER Retorna el valor total de la Deuda Diferida por Punto.
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 16-06-2020
  */
  FUNCTION F_GET_TOTAL_DIFERIDO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)

  RETURN NUMBER;

 /**
  * Documentaci�n para la funci�n F_GET_DIFERIDO_PAGADO
  * La funci�n F_GET_DIFERIDO_PAGADO Obtiene el Total de Diferido Pagado = Pagos de las NDI que se generaron por la Opci�n de Emergencia. 
  *
  * Costo Query C_GetDiferidoPagado: 39
  *
  * @param Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @return NUMBER Retorna el valor Total de Diferido Pagado
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 17-06-2020
  */
  FUNCTION F_GET_DIFERIDO_PAGADO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)

  RETURN NUMBER;

 /**
  * Documentaci�n para la funci�n F_GET_DIFERIDO_POR_VENCER
  * La funci�n F_GET_DIFERIDO_POR_VENCER Obtiene el valor diferido por vencer, corresponde al valor total de  diferido 
  * pendientes de generarse.
  * 
  * Costo Query C_GetDiferidoPorVencer: 11
  *
  * @param Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @return NUMBER Retorna el valor Total de Diferido por vencer
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 18-06-2020
  */
  FUNCTION F_GET_DIFERIDO_POR_VENCER(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)

  RETURN NUMBER;

  /**
  * Documentaci�n para la funci�n F_GET_DIFERIDO_VENCIDO
  * La funci�n F_GET_DIFERIDO_VENCIDO Obtiene el valor total de NDI impagas a la fecha. 
  * 
  * Costo Query C_GetDiferidoVencido: 13
  *
  * @param Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @return NUMBER Retorna el valor total de NDI impagas a la fecha. 
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 19-06-2020
  *
  * @author Gustavo Narea <gnarea@telconet.ec>
  * @version 1.1 01-12-2020
  * Se cambia la forma de sumar los valores en el query C_GetDiferidoVencido
  */
  FUNCTION F_GET_DIFERIDO_VENCIDO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)

  RETURN NUMBER;

  /**
  * Documentaci�n para la funci�n F_GET_TOTAL_SALDO_FACTPTO
  * La funci�n F_GET_TOTAL_SALDO_FACTPTO Obtiene el total de saldo de Facturas por Punto.
  * 
  * Costo Query C_TotalSaldoFactPorPto: 13
  *
  * @param Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @return NUMBER Retorna el valor el total de saldo de Facturas por Punto.
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 24-06-2020
  */
  FUNCTION F_GET_TOTAL_SALDO_FACTPTO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)

  RETURN NUMBER;

  /**
  * Documentaci�n para la funci�n F_GET_CANTIDAD_NC_PORPUNTO
  * La funci�n F_GET_CANTIDAD_NC_PORPUNTO Obtiene la Cantidad de Notas de Cr�dito o de Notas de Cr�dito internas
  * que existen en proceso o Flujo de Activaci�n asociadas a las Facturas del Punto en sesi�n y que entran al Proceso de Diferido.
  * 
  * Costo Query C_CantidadNcPorPunto 34
  *
  * @param Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @return NUMBER Retorna la cantidad de Facturas por Punto que entraran al Proceso de Diferido y que poseen NC o NCI
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 26-06-2020
  */
  FUNCTION F_GET_CANTIDAD_NC_PORPUNTO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)

  RETURN NUMBER;

 /**
  * Documentaci�n para la funci�n F_GET_CANTPROC_DIFERIDO_PORPTO
  * La funci�n F_GET_CANTPROC_DIFERIDO_PORPTO Obtiene la cantidad de Procesos de Diferidos de Facturas que se han generado por punto, se 
  * considera en estado Pendiente y Finalizado
  * 
  * Costo Query C_CantProcDiferidoPorPto 23
  *
  * @param Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
  * @return NUMBER Retorna la cantidad de Procesos de Diferidos de Facturas por Punto 
  * 
  * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
  * @version 1.0 26-06-2020
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.1 18-08-2020 - Se procedi� a modificar el query del cursor C_CantProcDiferidoPorPto, para excluir los procesos masivos 
  *                           que tienen en la NDI el valor carater�stica 'PRECANCELACION_DEUDA_DIFERIDA'.
  * 
  * Costo Query C_CantProcDiferidoPorPto: 31
  */
  FUNCTION F_GET_CANTPROC_DIFERIDO_PORPTO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)

  RETURN NUMBER;



  /**
   * Documentaci�n para TYPE 'Lr_RegistrosPersonas'.
   *  
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-04-2020
   */
  TYPE Lr_RegistrosPersonas IS RECORD (ID_PERSONA  DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                                       CLIENTE     VARCHAR2(32000),
                                       SALDO       NUMBER);

  /**
   * Documentaci�n para TYPE 'T_RegistrosPersonas'.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-04-2020
   */                     
  TYPE T_RegistrosPersonas IS TABLE OF Lr_RegistrosPersonas INDEX BY PLS_INTEGER;

  /**
   * Documentaci�n para PROCEDURE 'P_CREA_PM_EMER_SANIT'.
   *
   * Procedure que genera un Proceso Masivo que puede ser por reporte previo, o ejecuci�n de NCI por emergencia sanitaria, 
   * en base a par�metros enviados.
   *
   * PARAMETROS:
   * @Param Pv_Observacion          IN  VARCHAR2 ( Par�metros para evaluaci�n de diferido por emergencia sanitaria )
   * @Param Pv_UsrCreacion          IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE  (Usuario en sesi�n)
   * @Param Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (C�digo de Empresa en sesi�n)
   * @Param Pv_IpCreacion           IN  VARCHAR2 (Ip de Creaci�n)
   * @Param Pv_TipoPma              IN  VARCHAR2 (Tipo de Proceso Masivo Reporte previo � Ejecuci�n de NCI.)    
   * @Param Pn_IdPunto              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE (Id de Punto Cliente) DEFAULT NULL,
   * @Param Pv_MsjResultado         OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-04-2020
   *
   * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
   * @version 1.1 26-06-2020  - Se agrega par�metro intIdPunto para crear proceso individual de Diferido de Facturas por Punto en sesi�n.
   */
  PROCEDURE P_CREA_PM_EMER_SANIT(Pv_Observacion              IN  VARCHAR2,
                                 Pv_UsrCreacion              IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                 Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                 Pv_IpCreacion               IN  VARCHAR2,
                                 Pv_TipoPma                  IN  VARCHAR2,
                                 Pn_IdPunto                  IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                 Pv_MsjResultado             OUT VARCHAR2); 

  /**
   * Documentaci�n para PROCEDURE 'P_REPORTE_EMERGENCIA_SANIT'.
   *
   * Procedure que genera un reporte previo de una futura ejecuci�n de NCI por emergencia sanitaria en base a par�metros enviados, 
   * el reporte ser� enviado a los correos configurados en la plantilla "RPT_EMER_SANIT".
   *
   * Costo Query C_GetProcesoMasivo: 6
   * Costo Query C_GetPersonaSaldo:25411876
   * Costo Query C_DatosCliente:35
   * Costo Query C_TotalSaldoFactPorPto:15
   * Costo Query C_Parametros:3
   * Costo Query C_Ciclos:6
   *
   * PARAMETROS:
   * @Param Pv_TipoPma              IN  VARCHAR2 (Tipo de Proceso Masivo Inactivaci�n, Clonaci�n o Dada de baja.)
   * @Param Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (C�digo de Empresa en sesi�n)
   * @Param Pv_Estado               IN  VARCHAR2 (Estado del Proceso)
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-04-2020
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 04-07-2020 - Se elimina el cursor C_SaldoPunto para evitar lentitud en la ejecuci�n del proceso.
   *
   */
  PROCEDURE P_REPORTE_EMERGENCIA_SANIT (Pv_TipoPma    IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                        Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_Estado     IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
                                        Pv_Error      OUT VARCHAR2);

  /**
   * Documentaci�n para PROCEDURE 'P_CREA_SOLICITUDES_NCI'.
   *
   * Procedure que genera las solicitudes "SOLICITUD DIFERIDO DE FACTURA POR EMERGENCIA SANITARIA", para la creaci�n de NCI
   * de las facturas diferidas.
   *
   * Costo Query C_GetProcesoMasivo: 6
   * Costo Query C_GetPersonaSaldo:25411876
   * Costo Query C_DatosCliente:30
   * Costo Query C_Facturas:15
   * Costo Query C_Parametros:3
   * Costo Query C_ObtieneMotivoSolicitud:2
   * Costo Query C_ObtieneTipoSolicitud:2
   * Costo Query C_ObtieneIdCarac:2
   * Costo Query C_TotalSaldoFactPorPto:15
   *
   * PARAMETROS:
   * @Param Pv_TipoPma              IN  VARCHAR2 (Tipo de Proceso Masivo Inactivaci�n, Clonaci�n o Dada de baja.)
   * @Param Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (C�digo de Empresa en sesi�n)
   * @Param Pv_Estado               IN  VARCHAR2 (Estado del Proceso)
   * @Param Pn_IdPunto              IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE (Id de Punto Cliente) DEFAULT NULL
   * @Param Pv_MsjResultado         OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)
   * @Param Pn_IdProcesoMasivoCab   OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-04-2020
   *
   * @author Anabelle Pe�aherrera <apenaherrera@telconet.ec>
   * @version 1.1 26-06-2020  - Se agrega par�metro intIdPunto para crear proceso individual de Diferido de Facturas por Punto en sesi�n
   *                            y se agrega par�metro de salida Pv_MsjResultado y Pn_IdProcesoMasivoCab
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 04-07-2020 - Se elimina el cursor C_SaldoPunto para evitar lentitud en la ejecuci�n del proceso.
   */
PROCEDURE P_CREA_SOLICITUDES_NCI (Pv_TipoPma            IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                  Pv_CodEmpresa         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Pv_Estado             IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
                                  Pn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                  Pv_MsjResultado       OUT VARCHAR2,
                                  Pn_IdProcesoMasivoCab OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE);

  /**
   * Documentaci�n para TYPE 'Lr_RegistrosDocumentos'.
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 23-04-2020
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 19-05-2020 Se agregan columnas Proceso y Solicitud.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 28-06-2020 Se agrega columna Proceso_Ejecucion.
   */   
  TYPE Lr_RegistrosDocumentos
  IS
    RECORD
    (
      CLIENTE                   VARCHAR2(1000),
      IDENTIFICACION            VARCHAR2(1000),
      LOGIN                     VARCHAR2(1000),
      FECHA_FACTURA             VARCHAR2(1000),
      NUMERO_FACTURA_SRI_FACT   VARCHAR2(1000),
      MONTO_DIFERIDO            NUMBER,
      FORMA_PAGO                VARCHAR2(1000),
      BANCO                     VARCHAR2(1000),
      TIPO_CUENTA               VARCHAR2(1000),
      MES_DIFERIDO              VARCHAR2(1000),
      FECHA                     VARCHAR2(1000),
      NUMERO_FACTURA_SRI        VARCHAR2(1000),
      VALOR                     NUMBER,
      MAIL_CLIENTE              VARCHAR2(1000),
      ESTADO_IMPRESION_FACT     VARCHAR2(1000),
      PROCESO_EJECUCION         VARCHAR2(3200),
      PROCESO                   VARCHAR2(3200),
      SOLICITUD                 VARCHAR2(3200)
    );    

  /**
   * Documentaci�n para TYPE 'T_RegistrosDocumentos'.
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 23-04-2020
   */  
  TYPE T_RegistrosDocumentos IS TABLE OF Lr_RegistrosDocumentos INDEX BY PLS_INTEGER; 

  /**
   * Documentaci�n para PROCEDURE 'P_REPORTE_NCI_DIFERIDOS'.
   * 
   * Procedimiento encargado de generar el reporte de los documentos NCI por Emergencia Sanitaria.
   *
   * @param Pv_FechaReporteDesde    IN VARCHAR2 Recibe la fecha de creaci�n Desde del reporte a generar.
   * @param Pv_FechaReporteHasta    IN VARCHAR2 Recibe la fecha de creaci�n Hasta del reporte a generar.
   * @param Pv_EmpresaCod           IN VARCHAR2 Recibe el id de la empresa.
   * @param Pv_Usuario              IN VARCHAR2 Recibe el usuario que genera el reporte.
   * @param Pv_PrefijoEmpresa       IN VARCHAR2 Recibe el prefijo empresa.
   * @param Pv_EmailUsuario         IN VARCHAR2 Recibe email para env�o de reporte.
   *
   * Costo query C_documentosNci: 25
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 23-04-2020
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 19-05-2020 Se agregar filtro y columnas de proceso y solicitud atada a la NCI
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 28-06-2020 Se agrega columna Proceso_Ejecucion.
   */      
  PROCEDURE P_REPORTE_NCI_DIFERIDOS(
      Pv_FechaReporteDesde IN VARCHAR2,
      Pv_FechaReporteHasta IN VARCHAR2,
      Pv_EmpresaCod        IN VARCHAR2,
      Pv_Usuario           IN VARCHAR2,
      Pv_PrefijoEmpresa    IN VARCHAR2,
      Pv_EmailUsuario      IN VARCHAR2
      );

  /**
   * Documentaci�n para PROCEDURE 'P_REPORTE_NDI_DIFERIDOS'.
   * 
   * Procedimiento encargado de generar el reporte de los documentos NDI por Emergencia Sanitaria.
   *
   * @param Pv_FechaReporteDesde    IN VARCHAR2 Recibe la fecha de creaci�n Desde del reporte a generar.
   * @param Pv_FechaReporteHasta    IN VARCHAR2 Recibe la fecha de creaci�n Hasta del reporte a generar.
   * @param Pv_EmpresaCod           IN VARCHAR2 Recibe el id de la empresa.
   * @param Pv_Usuario              IN VARCHAR2 Recibe el usuario que genera el reporte.
   * @param Pv_PrefijoEmpresa       IN VARCHAR2 Recibe el prefijo empresa.
   * @param Pv_EmailUsuario         IN VARCHAR2 Recibe email para env�o de reporte.
   *
   * Costo query C_documentosNdi: 29
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 23-04-2020
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 19-05-2020 Se agregar filtro y columnas de proceso y solicitud atada a la NDI
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 30-05-2020 Se realizan cambios en el query principal por agrupaci�n de NDI, el costo del query C_documentosNdi: 85
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.3 28-06-2020 Se agrega columna Proceso_Ejecucion.
   */      
  PROCEDURE P_REPORTE_NDI_DIFERIDOS(
      Pv_FechaReporteDesde IN VARCHAR2,
      Pv_FechaReporteHasta IN VARCHAR2,
      Pv_EmpresaCod        IN VARCHAR2,
      Pv_Usuario           IN VARCHAR2,
      Pv_PrefijoEmpresa    IN VARCHAR2,
      Pv_EmailUsuario      IN VARCHAR2
      );

  /**
   * Documentaci�n para TYPE 'Lr_RegistrosDocPagosNdi'.
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 23-04-2020
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 19-05-2020 Se agregan columnas Proceso y Solicitud
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 28-06-2020 Se agrega columna Proceso_Ejecucion.
   */   
  TYPE Lr_RegistrosDocPagosNdi
  IS 
    RECORD
    (
      CLIENTE                   VARCHAR2(1000),
      IDENTIFICACION            VARCHAR2(1000),
      LOGIN                     VARCHAR2(1000),
      FORMA_PAGO                VARCHAR2(1000),
      BANCO                     VARCHAR2(1000),
      TIPO_CUENTA               VARCHAR2(1000),
      TOTAL_CUOTA_DIF_NDI       NUMBER,
      FECHA_PAGO                VARCHAR2(1000),
      NUMERO_PAGO               VARCHAR2(1000),
      VALOR_PAGO                NUMBER,
      MAIL_CLIENTE              VARCHAR2(1000),
      NDI_APLICA                VARCHAR2(1000),
      ESTADO_PAGO               VARCHAR2(1000),
      PROCESO_EJECUCION         VARCHAR2(1000),
      PROCESO                   VARCHAR2(3200),
      SOLICITUD                 VARCHAR2(3200)
    );    

  /**
   * Documentaci�n para TYPE 'T_RegistrosDocPagosNdi'.
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 23-04-2020
   */  
  TYPE T_RegistrosDocPagosNdi IS TABLE OF Lr_RegistrosDocPagosNdi INDEX BY PLS_INTEGER;

  /**
   * Documentaci�n para PROCEDURE 'P_REPORTE_NDI_PAG_DIFERIDOS'.
   * 
   * Procedimiento encargado de generar el reporte de pagos de los documentos NDI, por Emergencia Sanitaria.
   *
   * @param Pv_FechaReporteDesde    IN VARCHAR2 Recibe la fecha de creaci�n Desde del reporte a generar.
   * @param Pv_FechaReporteHasta    IN VARCHAR2 Recibe la fecha de creaci�n Hasta del reporte a generar.
   * @param Pv_EmpresaCod           IN VARCHAR2 Recibe el id de la empresa.
   * @param Pv_Usuario              IN VARCHAR2 Recibe el usuario que genera el reporte.
   * @param Pv_PrefijoEmpresa       IN VARCHAR2 Recibe el prefijo empresa.
   * @param Pv_EmailUsuario         IN VARCHAR2 Recibe email para env�o de reporte.
   *
   * Costo query C_documentosPagosNdi: 192
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 23-04-2020
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 19-05-2020 Se agregar filtro y columnas de proceso y solicitud atada a la NDI
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.2 30-05-2020 Se realizan cambios en el query principal por agrupaci�n de NDI
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.3 28-06-2020 Se agrega columna Proceso_Ejecucion.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.4 05-10-2020 Se realiza mejora de respuesta en el query principal.
   */      
  PROCEDURE P_REPORTE_NDI_PAG_DIFERIDOS(
      Pv_FechaReporteDesde IN VARCHAR2,
      Pv_FechaReporteHasta IN VARCHAR2,
      Pv_EmpresaCod        IN VARCHAR2,
      Pv_Usuario           IN VARCHAR2,
      Pv_PrefijoEmpresa    IN VARCHAR2,
      Pv_EmailUsuario      IN VARCHAR2
      );            

  /**
   * Documentaci�n para FUNCI�N 'F_CANTIDAD_FACTURA'.
   *
   * Funci�n que devuelde la cantidad total de facturas por punto que cumplan con un valor m�nimo de costo de factura.
   *
   * Costo Query C_TotalFacturas:15
   *
   * PARAMETROS:
   * @Param Fn_IdPunto          IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE (id punto)
   * @Param Fv_CodEmpresa       IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (c�digo de empresa)
   * @Param Fv_Caracteristica   IN  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE (caracter�stica que marca 
   *                                un documento por el proyecto diferidos por emergencia sanitaria)
   * @Param Fn_CostoMininoFact  IN  NUMBER (costo m�nimo por factura)
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-05-2020
   *
   */
  FUNCTION F_CANTIDAD_FACTURA(Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Fv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Fv_Caracteristica  IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                              Fn_CostoMininoFact IN NUMBER)
    RETURN NUMBER;
  /**
   * Documentaci�n para PROCEDURE 'P_REPORTE_CREACION_SOL'.
   *
   * Proceso que genera un reporte final de las creaciones de solicitudes por cada proceso masivo.
   *
   * Costo Query C_GetDatosReporte:13076
   *
   * PARAMETROS:
   * @Param Pn_IdProceso  IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE (id proceso masivo)
   * @Param Pv_Ciclos     IN  VARCHAR2 (ciclos de facturaci�n de MD)
   * @Param Pv_Meses      IN  VARCHAR2 (meses a diferir una factura)
   * @Param Pv_Estados    IN  VARCHAR2 (estados de un servicio mandatorio)
   * @Param Pv_SaldoDesde IN  VARCHAR2 (saldo desde de un Cliente)
   * @Param Pv_SaldoHasta IN  VARCHAR2 (saldo hasta de un Cliente)
   * @Param Pv_Usuario    IN  VARCHAR2 (Usuario de la persona que ejecut� el proceso.)
   * @Param Pv_Error      OUT VARCHAR2 (mensaje de error)
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-05-2020
   *
   */    
  PROCEDURE P_REPORTE_CREACION_SOL (Pn_IdProceso   IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                                    Pv_Ciclos      IN VARCHAR2,
                                    Pv_Meses       IN VARCHAR2,
                                    Pv_Estados     IN VARCHAR2,
                                    Pv_SaldoDesde  IN VARCHAR2,
                                    Pv_SaldoHasta  IN VARCHAR2,
                                    Pv_Usuario     IN VARCHAR2,
                                    Pv_Error       OUT VARCHAR2);

  /**
   * Documentaci�n para TYPE 'Lr_RegistrosDatosRpt'.
   *  
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 18-05-2020
   */
  TYPE Lr_RegistrosDatosRpt IS RECORD (CLIENTE         VARCHAR2(3200),
                                       IDENTIFICACION  DB_COMERCIAL.INFO_PERSONA.IDENTIFICACION_CLIENTE%TYPE,
                                       LOGIN           DB_COMERCIAL.INFO_PUNTO.LOGIN%TYPE,
                                       ESTADO          DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                       JURISDICCION    DB_INFRAESTRUCTURA.ADMI_JURISDICCION.NOMBRE_JURISDICCION%TYPE,
                                       FORMA_PAGO      VARCHAR2(3200),
                                       BANCO           VARCHAR2(3200),
                                       TIPO_CUENTA     VARCHAR2(3200),
                                       SALDO           NUMBER);

  /**
   * Documentaci�n para TYPE 'T_RegistrosDatosRpt'.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 18-05-2020
   */                     
  TYPE T_RegistrosDatosRpt IS TABLE OF Lr_RegistrosDatosRpt INDEX BY PLS_INTEGER;

  /**
   * Documentaci�n para FUNCI�N 'F_CANTIDAD_NC_FACT'.
   *
   * Funci�n que devuelde la cantidad de NC que tiene la factura en estado pendiente o aprobada.
   *
   * Costo Query C_GetNotaCreditoNoActiva:5
   *
   * PARAMETROS:
   * @Param Fn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE (id documento)
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-05-2020
   *
   */  
  FUNCTION F_CANTIDAD_NC_FACT(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER;

  /**
   * Documentaci�n para FUNCI�N 'F_OBSERVACION_NDI'.
   *
   * Funci�n que devuelde la observaci�n de la NDI que sera utilizada para guardar en las estructuras 
   * DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET y DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.
   *
   * Costo Query C_GetNotasDeCredito:9
   *
   * PARAMETROS:
   * @Param Fn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE (id documento)
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 30-05-2020
   *
   */
  FUNCTION F_OBSERVACION_NDI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN CLOB;

  /**
   * Documentaci�n para TYPE 'Lr_RegistrosDocumentosNDI'.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 04-06-2020
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.1 28-06-2020 Se agrega columna Proceso_Ejecucion.
   */   
  TYPE Lr_RegistrosDocumentosNDI
  IS
    RECORD
    (
      CLIENTE                   VARCHAR2(3200),
      IDENTIFICACION            VARCHAR2(3200),
      LOGIN                     VARCHAR2(3200),
      FECHA_FACTURA             VARCHAR2(3200),
      NUMERO_FACTURA_SRI_FACT   VARCHAR2(3200),
      MONTO_DIFERIDO            VARCHAR2(3200),
      FORMA_PAGO                VARCHAR2(3200),
      BANCO                     VARCHAR2(3200),
      TIPO_CUENTA               VARCHAR2(3200),
      MES_DIFERIDO              VARCHAR2(3200),
      FECHA                     VARCHAR2(3200),
      NUMERO_FACTURA_SRI        VARCHAR2(3200),
      VALOR                     VARCHAR2(3200),
      MAIL_CLIENTE              VARCHAR2(3200),
      ESTADO_IMPRESION_FACT     VARCHAR2(3200),
      PROCESO_EJECUCION         VARCHAR2(3200),
      PROCESO                   VARCHAR2(3200),
      SOLICITUD                 VARCHAR2(3200)
    );    

  /**
   * Documentaci�n para TYPE 'T_RegistrosDocumentosNDI'.
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 04-06-2020
   */  
  TYPE T_RegistrosDocumentosNDI IS TABLE OF Lr_RegistrosDocumentosNDI INDEX BY PLS_INTEGER;

  /**
   *  Documentaci�n para TYPE 'Lr_DatosNCI'.
   *  
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 17-06-2020
  */      
  TYPE Lr_DatosNCI IS RECORD (
    ID_DOCUMENTO           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
    NUMERO_FACTURA_SRI     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
    ESTADO_IMPRESION_FACT  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
    ES_MESES_DIFERIDO      NUMBER,
    SALDO                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE,
    PROCESO                NUMBER,
    SOLICITUD              NUMBER,
    PUNTO_ID               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
  ); 

  /**
   * Documentaci�n para TYPE 'T_DatosNCI'.  
   * 
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 17-06-2020
  */
  TYPE T_DatosNCI IS TABLE OF Lr_DatosNCI INDEX BY PLS_INTEGER;

  /**
   * Documentaci�n para FUNCI�N 'F_CUOTA_X_VENCER_NDI', retorna la cuota por vencer de la siguiente NDI a diferir.
   *
   * PARAMETROS:
   * @Param Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
   *
   * Costo Query C_CuotasXVencerDoc:8
   * Costo Query C_NDIDiferido:8
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 17-06-2020
   *
   */
  FUNCTION F_CUOTA_X_VENCER_NDI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER;

  /**
   * Documentaci�n para FUNCI�N 'F_SALDO_X_DIFERIR_NDI', retorna el saldo total de las NDI pendientes de diferir.
   *
   * PARAMETROS:
   * @Param Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
   *
   * Costo Query C_CuotasXVencerDoc:8
   * Costo Query C_NDIDiferido:8
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 17-06-2020
   *
   */    
  FUNCTION F_SALDO_X_DIFERIR_NDI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER; 

  /**
   * Documentaci�n para FUNCI�N 'F_SALDO_X_DIFERIR_PTO', retorna el saldo pendiente de las NDI a diferir por punto.
   *
   * PARAMETROS:
   * @Param Fn_IdPunto  IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   *
   * Costo Query C_CuotasXVencerDoc:33
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 17-06-2020
   *
   */    
  FUNCTION F_SALDO_X_DIFERIR_PTO(Fn_IdPunto  IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN NUMBER;

  /**
   * Documentaci�n para FUNCI�N 'F_TABLA_NCI_X_PTO', retorna una tabla de las NCI pendientes a diferir por punto.
   *
   * PARAMETROS:
   * @Param Fn_IdPunto  IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   *
   * Costo Query C_CuotasXVencerDoc:33
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 17-06-2020
   *
   */    
  FUNCTION F_TABLA_NCI_X_PTO(Fn_IdPunto      IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                             Fn_IdProcesoMsv IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
    RETURN T_DatosNCI;

  /**
   * Documentaci�n para PROCEDURE 'P_GENERAR_NDI_CANCELACION'.
   *
   * Proceso que se encarga de generar las NDI agrupadas por punto y proceso masivo, desde el evento de cancelaci�n voluntaria.
   *
   * Costo Query C_PuntoServicio:3
   * Costo Query C_NCIPorPunto:18
   * Costo Query C_GetCaracterist:2
   * Costo Query C_GetMotivo:2
   * Costo Query C_GetDocumentoCaract:5
   *
   * PARAMETROS:
   * @Param Pn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE (id del servicio mandatorio)
   * @Param Pv_CodEmpresa  IN VARCHAR2 (c�digo de la empresa)
   * @Param Pv_TipoProceso IN VARCHAR2  (tipo de proceso)
   * @Param Pv_Error       OUT VARCHAR2 (mensaje de error)
   *
   * @author Jos� Candelario <jcandelario@telconet.ec>
   * @version 1.0 08-05-2020
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.1 17-08-2020 - Se agrega par�metro de tipo de proceso donde se realiza las validaciones correspondiente
   *                           para permitir generar las NDI agrupadas por punto y procesos desde el evento de 
   *                           PreCancelaci�n de deuda diferida.
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.2 25-11-2020 - Se parametriza valores para agrupar las NDI diferidas, utilizados por diferentes procesos.
   *                         - Se crea cursor 'C_GetParamAgrupaNdiDif' para obtener los valores parametrizados.
   * Costo Query C_GetParamAgrupaNdiDif: 3
   *
   */ 
  PROCEDURE P_GENERAR_NDI_CANCELACION(Pn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_CodEmpresa  IN VARCHAR2,
                                      Pv_TipoProceso IN VARCHAR2,
                                      Pv_Error       OUT VARCHAR2);

  /**
   * Documentaci�n para la funci�n F_GET_VALOR_VENCER_PRECAN_DIF
   * La funci�n F_GET_VALOR_VENCER_PRECAN_DIF Obtiene el valor diferido por vencer, corresponde al valor total de diferido 
   * pendientes de generarse por proceso masivo (masivo � individual).
   * 
   * Costo Query C_GetDifPorVencerMasivo: 15
   *
   * @param Fn_IdPunto         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE
   * @param Fn_IdProcesoMasivo IN VARCHAR2
   * @return NUMBER Retorna el valor Total de Diferido por vencer
   * 
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 18-08-2020
   */
  FUNCTION F_GET_VALOR_VENCER_PRECAN_DIF(Fn_IdPunto         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                                         Fn_IdProcesoMasivo IN VARCHAR2)

  RETURN NUMBER;     

  /**
   * Documentaci�n para FUNCI�N 'F_SALDO_DIF_X_PTO_PROC_MASIVO', retorna el saldo pendiente de las NDI a diferir 
   * por punto y proceso masivo (masivo � individual).
   *
   * PARAMETROS:
   * @Param Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
   * @Param Fn_IdProcesoMasivo IN VARCHAR2
   *
   * Costo Query C_CuotasXVencerDocProcMasivo:38
   *
   * @author Alex Arreaga <atarreaga@telconet.ec>
   * @version 1.0 18-08-2020
   */    
  FUNCTION F_SALDO_DIF_X_PTO_PROC_MASIVO(Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Fn_IdProcesoMasivo IN VARCHAR2)
  RETURN NUMBER;

END FNCK_PAGOS_DIFERIDOS;
/

CREATE EDITIONABLE PACKAGE BODY               FNCK_PAGOS_DIFERIDOS AS

  PROCEDURE P_OBTIENE_GRUPOS_PROC_DIFERIDO(Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_UsrCreacion IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE)
  IS
    Lv_DescripcionSolicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE:='SOLICITUD DIFERIDO DE FACTURA POR EMERGENCIA SANITARIA';
    Lv_NombreParametro      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PROCESO DE DIFERIDO DE FACTURAS';
    Lv_Estado               DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE:='Activo';   
    Lv_MsjResultado         VARCHAR2(2000);
    Lv_IpCreacion           VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    CURSOR C_GruposEjecucion(Cv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                             Cv_Estado DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE )
    IS
    SELECT DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1) AS GRUPO,
      REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR5), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR5),'([^,]*)(,\1)+($|,)', '\1\3') AS CICLO,
      REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR1), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR1),'([^,]*)(,\1)+($|,)', '\1\3') AS FORMA_PAGO,
      LISTAGG (TRIM(PAMD.VALOR2), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR2) AS IDS_FORMASPAGO_EMISORES
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAMC,
      DB_GENERAL.ADMI_PARAMETRO_DET PAMD,
      DB_FINANCIERO.ADMI_CICLO CICLO
    WHERE NOMBRE_PARAMETRO                                         = Cv_NombreParametro
    AND PAMC.ESTADO                                                = Cv_Estado
    AND PAMD.ESTADO                                                = Cv_Estado
    AND PAMC.ID_PARAMETRO                                          = PAMD.PARAMETRO_ID
    AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(PAMD.VALOR5,'^\d+')),0)   = CICLO.ID_CICLO
    GROUP BY DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1);

  BEGIN
    FOR Lr_GruposEjecucion IN C_GruposEjecucion(Lv_NombreParametro, Lv_Estado)
    LOOP        
      FNCK_PAGOS_DIFERIDOS.P_EJECUTA_SOL_DIFERIDO(
                                 Pv_Empresa               => Pv_Empresa,
                                 Pv_UsrCreacion           => Pv_UsrCreacion,
                                 Pv_DescripcionSolicitud  => Lv_DescripcionSolicitud,
                                 Pv_FormaPago             => Lr_GruposEjecucion.FORMA_PAGO,
                                 Pn_IdCiclo               => COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_GruposEjecucion.CICLO,'^\d+')),0),
                                 Pv_IdsFormasPagoEmisores => Lr_GruposEjecucion.IDS_FORMASPAGO_EMISORES,
                                 Pn_IdPunto               => NULL,
                                 Pv_MsjResultado          => Lv_MsjResultado 
                                );                                                            
    END LOOP;

  EXCEPTION 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al obtener los Grupos parametrizados para ejecutar el Proceso de Solicitudes de Diferido '||
                      'de Facturas por Emergencia Sanitaria';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.P_OBTIENE_GRUPOS_PROC_DIFERIDO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_diferido',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );            
  END P_OBTIENE_GRUPOS_PROC_DIFERIDO;
  --
  --
  --
  PROCEDURE P_OBTIENE_GRUPOS_NDI_DIFERIDO(Pv_Empresa     IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                          Pv_UsrCreacion IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE)
  IS
    Lv_NombreParametro      DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:='PROCESO DE DIFERIDO DE FACTURAS';
    Lv_Estado               DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE:='Activo';   
    Lv_MsjResultado         VARCHAR2(2000);
    Lv_IpCreacion           VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_DiaActual            NUMBER:= TO_NUMBER(TO_CHAR(SYSDATE, 'DD'), '99');

    CURSOR C_GetCiclosDiaProceso(Cv_CodigoEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT ID_CICLO,
      NOMBRE_CICLO,
      TO_NUMBER(TO_CHAR(FE_INICIO, 'DD'), '99') AS DIA_PROCESO
      FROM DB_FINANCIERO.ADMI_CICLO
      WHERE EMPRESA_COD = Cv_CodigoEmpresa;

    CURSOR C_GruposEjecucion(Cv_IdCiclo          DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE,
                             Cv_NombreParametro  DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE, 
                             Cv_Estado           DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE )
    IS
    SELECT DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1) AS GRUPO,
      REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR5), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR5),'([^,]*)(,\1)+($|,)', '\1\3') AS CICLO,
      REGEXP_REPLACE(LISTAGG (TRIM(PAMD.VALOR1), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR1),'([^,]*)(,\1)+($|,)', '\1\3') AS FORMA_PAGO,
      LISTAGG (TRIM(PAMD.VALOR2), ',') WITHIN GROUP (
    ORDER BY PAMD.VALOR2) AS IDS_FORMASPAGO_EMISORES
    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PAMC,
      DB_GENERAL.ADMI_PARAMETRO_DET PAMD,
      DB_FINANCIERO.ADMI_CICLO CICLO
    WHERE NOMBRE_PARAMETRO                                         = Cv_NombreParametro
    AND PAMC.ESTADO                                                = Cv_Estado
    AND PAMD.ESTADO                                                = Cv_Estado
    AND PAMC.ID_PARAMETRO                                          = PAMD.PARAMETRO_ID
    AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(PAMD.VALOR5,'^\d+')),0)   = CICLO.ID_CICLO
    AND CICLO.ID_CICLO                                             = Cv_IdCiclo
    GROUP BY DBMS_LOB.SUBSTR(PAMD.DESCRIPCION, LENGTH(PAMD.DESCRIPCION), 1);   

  BEGIN
    FOR Lr_GetCiclosDiaProceso IN C_GetCiclosDiaProceso(Pv_Empresa)
    LOOP
      IF Ln_DiaActual=Lr_GetCiclosDiaProceso.DIA_PROCESO THEN
        FOR Lr_GruposEjecucion IN C_GruposEjecucion(Lr_GetCiclosDiaProceso.ID_CICLO,Lv_NombreParametro, Lv_Estado)
        LOOP        
          FNCK_PAGOS_DIFERIDOS.P_EJECUTA_NDI_DIFERIDO(
                                 Pv_Empresa               => Pv_Empresa,
                                 Pv_UsrCreacion           => Pv_UsrCreacion,
                                 Pv_FormaPago             => Lr_GruposEjecucion.FORMA_PAGO,
                                 Pn_IdCiclo               => COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lr_GruposEjecucion.CICLO,'^\d+')),0),
                                 Pv_IdsFormasPagoEmisores => Lr_GruposEjecucion.IDS_FORMASPAGO_EMISORES,
                                 Pn_IdPunto               => NULL,
                                 Pn_IdProcesoMasivoCab    => NULL,
                                 Pv_MsjResultado          => Lv_MsjResultado
                                ); 
        END LOOP;
      END IF;                                                          
    END LOOP;

  EXCEPTION 
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrio un error al obtener los Grupos parametrizados para ejecutar el Proceso de Generaci�n de Notas de D�bito Internas  '||
                      'por Diferido de Facturas por Emergencia Sanitaria';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.P_OBTIENE_GRUPOS_NDI_DIFERIDO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         'telcos_diferido',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        );            
  END P_OBTIENE_GRUPOS_NDI_DIFERIDO;
  --
  --
  --
  PROCEDURE P_EJECUTA_NDI_DIFERIDO(Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_UsrCreacion           IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                   Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                   Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                   Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                   Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                   Pn_IdProcesoMasivoCab    IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE DEFAULT NULL,
                                   Pv_MsjResultado          OUT VARCHAR2)
  IS
    CURSOR C_GetMotivo(Cv_NombreMotivo DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE)
    IS
      SELECT AM.ID_MOTIVO,
      AM.NOMBRE_MOTIVO
      FROM DB_GENERAL.ADMI_MOTIVO  AM 
      WHERE AM.NOMBRE_MOTIVO = Cv_NombreMotivo    
      AND AM.ESTADO          = 'Activo';   

    CURSOR C_GetCaracterist (Cv_DescCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      SELECT ID_CARACTERISTICA,
      DESCRIPCION_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = Cv_DescCarac;

    CURSOR C_GetDocumentoCaract(Cn_IdDocumento  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.DOCUMENTO_ID%TYPE,
                                Cv_DescCarac    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Cv_Estado       DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE)
    IS
      SELECT DCA.ID_DOCUMENTO_CARACTERISTICA,
      DCA.DOCUMENTO_ID,
      DCA.CARACTERISTICA_ID,
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(DCA.VALOR,'^\d+')),0) AS VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
      DB_COMERCIAL.ADMI_CARACTERISTICA CA
      WHERE 
      DCA.CARACTERISTICA_ID             = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA = Cv_DescCarac
      AND DCA.ESTADO                    = Cv_Estado
      AND DCA.DOCUMENTO_ID              = Cn_IdDocumento;

    CURSOR C_GetNciDiferidos(Cn_IdProcesoMasivo         DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                             Cn_IdPunto                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                             Cv_CodigoTipoDocumento     DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                             Cv_UsrCreacion             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                             Cv_EstadoActivo            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE,
                             Cv_CaractProcesoDiferido   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,                             
                             Cv_CaractContDiferido      DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                             Cv_CaractMesesDiferido     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                             Cv_CaractProcesoMasivo     DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE) 
    IS
      SELECT DISTINCT NCI.ID_DOCUMENTO, 
      NCI.PUNTO_ID,
      NCI.NUMERO_FACTURA_SRI,
      NCI.FE_CREACION, 
      NCI.VALOR_TOTAL,
      NCI.SUBTOTAL,
      NCI.SUBTOTAL_CON_IMPUESTO,
      NCI.SUBTOTAL_DESCUENTO,
      NCI.ESTADO_IMPRESION_FACT,      
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0) 
      AS ES_CONT_DIFERIDO,
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0)
      AS ES_MESES_DIFERIDO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
      DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
      DB_COMERCIAL.ADMI_CARACTERISTICA CA,
      DB_COMERCIAL.INFO_PUNTO IP
      WHERE NCI.TIPO_DOCUMENTO_ID           = TDOC.ID_TIPO_DOCUMENTO
      AND TDOC.CODIGO_TIPO_DOCUMENTO        = Cv_CodigoTipoDocumento
      AND NCI.USR_CREACION                  = Cv_UsrCreacion
      AND NCI.ESTADO_IMPRESION_FACT         = Cv_EstadoActivo 
      AND NCI.ID_DOCUMENTO                  = DCA.DOCUMENTO_ID
      AND DCA.CARACTERISTICA_ID             = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA     = Cv_CaractProcesoDiferido
      AND DCA.ESTADO                        = Cv_EstadoActivo
      AND NCI.PUNTO_ID                      = IP.ID_PUNTO
      AND NCI.PUNTO_ID                      = Cn_IdPunto
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractProcesoMasivo),'^\d+')),0)
      = Cn_IdProcesoMasivo
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0)
      < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0)    
      --
      GROUP BY NCI.ID_DOCUMENTO, 
      NCI.PUNTO_ID,
      NCI.NUMERO_FACTURA_SRI,
      NCI.FE_CREACION, 
      NCI.VALOR_TOTAL,
      NCI.SUBTOTAL,
      NCI.SUBTOTAL_CON_IMPUESTO,
      NCI.SUBTOTAL_DESCUENTO,
      NCI.ESTADO_IMPRESION_FACT,
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0),
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0)
      ORDER BY NCI.PUNTO_ID ASC;

    Lv_IpCreacion                   VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Le_Exception                    EXCEPTION;    
    Le_ExceptionAgrupoNci           EXCEPTION; 
    Le_ExceptionNci                 EXCEPTION; 
    Lv_MsjResultado                 VARCHAR2(500);
    Lv_MsnError                     VARCHAR2(500);
    Lv_CadenaQuery                  VARCHAR2(4000);
    Lv_CadenaFrom                   VARCHAR2(3000);
    Lv_CadenaWhere                  VARCHAR2(3000);  
    Lv_CadenaAgrupa                 VARCHAR2(2000); 
    Lv_CadenaOrdena                 VARCHAR2(1000);       
    Lv_Consulta                     VARCHAR2(4000);         
    Lrf_NciProcesoDiferidos         SYS_REFCURSOR;
    Lr_AgrupcionNciDiferidos        Lr_NciProcesoDiferidos;
    La_NciProcesoDiferidos          T_NciProcesoDiferidos;     
    Ln_Limit                        CONSTANT PLS_INTEGER DEFAULT 1000;  
    Ln_Indx                         NUMBER;  
    Lc_GetMotivo                    C_GetMotivo%ROWTYPE; 
    Lc_GetCaracterist               C_GetCaracterist%ROWTYPE;
    Lc_GetDocumentoCaract           C_GetDocumentoCaract%ROWTYPE;
    Ln_IdDocumentoNci               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;    
    Lv_CodigoTipoDocumento          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE:='NCI';
    Ln_IdTipoDocumento              DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Lv_ObservacionNdi               VARCHAR2(200):='Se creo la nota de debito interna por proceso de Pagos Diferidos.';
    Lv_ObservacionNdiCuota          VARCHAR2(200);
    Ln_IdMotivo                     DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE;
    Lv_NombreMotivo                 DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE:='Saldo a Diferir en cuotas';
    Ln_IdDocumentoNdi               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Lv_ObservacionNdiAgrupada       CLOB;
    Lbool_Done                      BOOLEAN;
    Lv_EstadoActivo                 VARCHAR2(20) :='Activo';
    Lv_CaractProcesoDiferido        VARCHAR2(20) :='PROCESO_DIFERIDO';
    Lv_CaractNumCuotaDiferida       VARCHAR2(20) :='NUM_CUOTA_DIFERIDA';
    Lv_CaractReferenciaNci          VARCHAR2(20) :='ID_REFERENCIA_NCI';
    Lv_CaractMesesDiferido          VARCHAR2(20) :='ES_MESES_DIFERIDO';
    Lv_CaractContDiferido           VARCHAR2(20) :='ES_CONT_DIFERIDO';
    Lv_CaractCicloFact              VARCHAR2(20) :='CICLO_FACTURACION';
    Lv_CaractIdSolicitud            VARCHAR2(20) :='ES_ID_SOLICITUD';
    Lv_CaractProcesoMasivo          VARCHAR2(20) :='ES_PROCESO_MASIVO';
    Lv_CaractValorCuotaDiferida     VARCHAR2(20) :='VALOR_CUOTA_DIFERIDA';
    Lv_CaractProcesoEjecucion       VARCHAR2(20) :='PROCESO_DE_EJECUCION';
    Ln_IdCaractProcesoDiferido      DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractNumCuotaDiferida     DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractReferenciaNci        DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractIdSolicitud          DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractProcesoMasivo        DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;    
    Ln_IdCaractValorCuotaDiferida   DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE; 
    Ln_IdCaractProcesoEjecucion     DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;   
    Lr_InfoDocumentoCaract          DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;    
    Lr_InfoDocumentoFinanHst        DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE; 
    Lv_EstadoRechazado              DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE:='Rechazado';
    Ln_NumCuotaDiferida             NUMBER:=0;
    Ln_MesesDiferido                NUMBER:=0;
    Ln_IdDocCaracContDiferido       NUMBER;
    Ln_IdDocCaracIdReferenciaNci    NUMBER;
    Ln_IdProcesoMasivo              NUMBER;
    Ln_IdDetalleSolicitud           NUMBER;
    Ln_ValorTotalNdi                NUMBER:=0;
    Ln_ValorCuotaDiferida           NUMBER:=0;
    Lr_InfoDocumentoFinanCabNdi     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocumentoFinanDetNdi     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;

  BEGIN
    --Costo Query: 22
    --
    Lv_CadenaQuery := ' SELECT '||
    ' COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ' ,'''||Lv_CaractProcesoMasivo||'''),''^\d+'')),0) AS ID_PROCESO_MASIVO, '|| 
    ' COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ','''||Lv_CaractIdSolicitud||'''),''^\d+'')),0) AS ID_DETALLE_SOLICITUD, '||
    ' NCI.PUNTO_ID AS ID_PUNTO, '||
    ' MIN(COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ' ,'''||Lv_CaractContDiferido||'''),''^\d+'')),0)) AS ES_CONT_DIFERIDO, '||
    ' MAX(COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ' ,'''||Lv_CaractMesesDiferido||'''),''^\d+'')),0)) AS ES_MESES_DIFERIDO, '||
    ' COUNT(*) AS CANTIDAD_NCI ';

    Lv_CadenaFrom  := ' FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,'||
                      ' DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,'||
                      ' DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,'||
                      ' DB_COMERCIAL.ADMI_CARACTERISTICA CA,'||                      
                      ' DB_COMERCIAL.INFO_PUNTO IP,'||
                      ' DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,'||
                      ' DB_COMERCIAL.INFO_PERSONA IPE,'||
                      ' DB_COMERCIAL.INFO_EMPRESA_ROL IER,'||
                      ' DB_GENERAL.ADMI_ROL AR';

    Lv_CadenaWhere:=  ' WHERE NCI.TIPO_DOCUMENTO_ID = TDOC.ID_TIPO_DOCUMENTO
    AND TDOC.CODIGO_TIPO_DOCUMENTO    = '''||Lv_CodigoTipoDocumento||'''
    AND NCI.USR_CREACION              = '''||Pv_UsrCreacion||'''
    AND NCI.ESTADO_IMPRESION_FACT     = '''||Lv_EstadoActivo||'''
    AND NCI.ID_DOCUMENTO              = DCA.DOCUMENTO_ID
    AND DCA.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
    AND CA.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractProcesoDiferido||'''
    AND DCA.ESTADO                    = '''||Lv_EstadoActivo||'''
    AND NCI.PUNTO_ID                  = IP.ID_PUNTO
    AND IPER.ID_PERSONA_ROL           = IP.PERSONA_EMPRESA_ROL_ID
    AND IPER.PERSONA_ID               = IPE.ID_PERSONA
    AND IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL
    AND IER.ROL_ID                    = AR.ID_ROL
    AND IER.EMPRESA_COD               = '''||Pv_Empresa||''' 
    AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,'''||Lv_CaractContDiferido||'''),''^\d+'')),0)
    < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,'''||Lv_CaractMesesDiferido||'''),''^\d+'')),0)
    ';

    Lv_CadenaAgrupa:= ' GROUP BY '||
    ' COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ' ,'''||Lv_CaractProcesoMasivo||'''),''^\d+'')),0), '||
    ' COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ','''||Lv_CaractIdSolicitud||'''),''^\d+'')),0) ,'||
    ' NCI.PUNTO_ID, '||
    ' COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ' ,'''||Lv_CaractContDiferido||'''),''^\d+'')),0), '||
    ' COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ' ,'''||Lv_CaractMesesDiferido||'''),''^\d+'')),0) ';

    Lv_CadenaOrdena:= ' ORDER BY '||
    ' COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ' ,'''||Lv_CaractProcesoMasivo||'''),''^\d+'')),0) ASC ';

    IF Pv_FormaPago IS NOT NULL AND Pn_IdCiclo IS NOT NULL AND Pv_IdsFormasPagoEmisores IS NOT NULL THEN
      --
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO, DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ';
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_FINANCIERO.ADMI_CICLO ADMCICLO';
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_CONTRATO CONT, DB_GENERAL.ADMI_FORMA_PAGO FP ';    
      --
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IPER.ID_PERSONA_ROL              = CICLO.PERSONA_EMPRESA_ROL_ID ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CICLO.ESTADO                     = '''||Lv_EstadoActivo||'''  ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CICLO.CARACTERISTICA_ID          = CARAC.ID_CARACTERISTICA ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CARAC.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractCicloFact||'''  ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,''^\d+'')),0) = ADMCICLO.ID_CICLO ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND ADMCICLO.ID_CICLO                = COALESCE(TO_NUMBER(REGEXP_SUBSTR('||Pn_IdCiclo||',''^\d+'')),0) ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IPER.ID_PERSONA_ROL              = CONT.PERSONA_EMPRESA_ROL_ID ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CONT.ESTADO                      NOT IN ('''||Lv_EstadoRechazado||''') ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CONT.FORMA_PAGO_ID               = FP.ID_FORMA_PAGO ';
      --
      IF Pv_FormaPago='DEBITO BANCARIO' THEN
        Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONFP';

        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND FP.DESCRIPCION_FORMA_PAGO = '''||Pv_FormaPago||''' 
        AND CONT.ID_CONTRATO            = CONFP.CONTRATO_ID
        AND CONFP.BANCO_TIPO_CUENTA_ID  IN ('|| Pv_IdsFormasPagoEmisores ||') 
        AND CONFP.ESTADO                NOT IN ('''||Lv_EstadoRechazado||''') ';    

      ELSIF Pv_FormaPago='EFECTIVO' THEN
        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND FP.ID_FORMA_PAGO IN ('|| Pv_IdsFormasPagoEmisores ||') ';
      END IF;
      --    
    END IF;
    --   
    IF Pn_IdPunto IS NOT NULL AND Pn_IdProcesoMasivoCab IS NOT NULL THEN
       Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IP.ID_PUNTO = '|| Pn_IdPunto ||' ';
       Lv_CadenaWhere:= Lv_CadenaWhere || ' AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO '||
    ' ,'''||Lv_CaractProcesoMasivo||'''),''^\d+'')),0) = '|| Pn_IdProcesoMasivoCab ||' ';
    END IF;
    --
    Lv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaAgrupa || Lv_CadenaOrdena;
    --         
    IF C_GetMotivo%ISOPEN THEN    
      CLOSE C_GetMotivo;    
    END IF;    
    IF C_GetCaracterist%ISOPEN THEN    
      CLOSE C_GetCaracterist;    
    END IF;
    IF C_GetDocumentoCaract%ISOPEN THEN    
      CLOSE C_GetDocumentoCaract;    
    END IF; 
    --     
    OPEN C_GetMotivo(Lv_NombreMotivo);
    --
    FETCH C_GetMotivo INTO Lc_GetMotivo;
    IF C_GetMotivo%NOTFOUND THEN
      Lv_MsnError := 'No existe motivo configurado para la creaci�n de Documentos NDI';
      RAISE Le_Exception;       
    END IF;
    Ln_IdMotivo:=Lc_GetMotivo.ID_MOTIVO;
    CLOSE C_GetMotivo;   
    --
    OPEN C_GetCaracterist(Lv_CaractProcesoDiferido);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoDiferido:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractNumCuotaDiferida);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractNumCuotaDiferida:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist;  
    --
    OPEN C_GetCaracterist(Lv_CaractReferenciaNci);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractReferenciaNci:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
     --
    OPEN C_GetCaracterist(Lv_CaractIdSolicitud);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractIdSolicitud:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractProcesoMasivo);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoMasivo:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractValorCuotaDiferida);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractValorCuotaDiferida:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist;      
    -- 
    OPEN C_GetCaracterist(Lv_CaractProcesoEjecucion);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoEjecucion:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    IF Ln_IdCaractProcesoDiferido IS NULL OR Ln_IdCaractNumCuotaDiferida IS NULL OR Ln_IdCaractReferenciaNci IS NULL 
        OR Ln_IdCaractIdSolicitud IS NULL OR Ln_IdCaractProcesoMasivo IS NULL OR Ln_IdCaractValorCuotaDiferida IS NULL 
        OR Ln_IdCaractProcesoEjecucion IS NULL THEN
      Lv_MsnError := 'Error al recuperar caracteristicas necesarias para el proceso ' || Lv_CaractProcesoDiferido || ' - ' ||
                     Lv_CaractNumCuotaDiferida || ' - ' || Lv_CaractReferenciaNci || ' - ' ||
                     Lv_CaractIdSolicitud || ' - ' || Lv_CaractProcesoMasivo || '-' || Lv_CaractValorCuotaDiferida || ' - ' || 
                     Lv_CaractProcesoEjecucion;
      RAISE Le_Exception;  
    END IF;
    --
    La_NciProcesoDiferidos.DELETE();
    --
    -- Obtengo las NCI Agrupadas por Proceso masivo y Punto que se originaron por el Proceso de Diferido de Facturas por Emergencia Sanitaria.
    --y que poseen cuotas o NDI pendientes de generarse.
    OPEN Lrf_NciProcesoDiferidos FOR Lv_Consulta;
    LOOP
      FETCH Lrf_NciProcesoDiferidos BULK COLLECT INTO La_NciProcesoDiferidos LIMIT Ln_Limit;
      Ln_Indx := La_NciProcesoDiferidos.FIRST;
      WHILE (Ln_Indx IS NOT NULL)
      LOOP
        BEGIN
          --
          Ln_IdDocumentoNdi         := NULL; 
          --
          --Almacena Observacion de las Nci Agrupadas con los NumerosCuotas y ValorCuota. 
          Lv_ObservacionNdiAgrupada := NULL;
          Lbool_Done                := FALSE; 
          Lv_MsnError               := NULL;  

          Ln_IdProcesoMasivo        := NULL;
          Ln_IdDetalleSolicitud     := NULL;
          Ln_ValorTotalNdi          := 0;
          --
          Lr_AgrupcionNciDiferidos  := La_NciProcesoDiferidos(Ln_Indx);
          Ln_Indx := La_NciProcesoDiferidos.NEXT(Ln_Indx);            
          --
          --Obtengo el Id de proceso masivo ingresado como caracteristica ES_PROCESO_MASIVO en la nci.
          --          
          Ln_IdProcesoMasivo := Lr_AgrupcionNciDiferidos.ID_PROCESO_MASIVO;  
          --
          IF Lr_AgrupcionNciDiferidos.ID_PROCESO_MASIVO = 0 THEN
            Lv_MsnError := 'Error al recuperar caracteristica necesaria para el proceso '|| Lv_CaractProcesoMasivo ||
                           ' para el Punto#'|| Lr_AgrupcionNciDiferidos.ID_PUNTO;
            RAISE Le_ExceptionAgrupoNci;       
          END IF;
          --
          --
          --Obtengo el id_detalle_solicitud ingresado como caracteristica ES_ID_SOLICITUD en la nci.
          --
          Ln_IdDetalleSolicitud := Lr_AgrupcionNciDiferidos.ID_DETALLE_SOLICITUD;
          --
          IF Lr_AgrupcionNciDiferidos.ID_DETALLE_SOLICITUD = 0 THEN
            Lv_MsnError := 'Error al recuperar caracteristica necesaria para el proceso '|| Lv_CaractIdSolicitud ||
                           ' para el Punto#'|| Lr_AgrupcionNciDiferidos.ID_PUNTO;
            RAISE Le_ExceptionAgrupoNci;       
          END IF;               
          --          
          FNCK_PAGOS_DIFERIDOS.P_CREA_NOTA_DEBITO_INTERNA (Lr_AgrupcionNciDiferidos.ID_PUNTO,
                                                           Ln_ValorTotalNdi,                                                           
                                                           Pv_Empresa,
                                                           Lv_ObservacionNdi,
                                                           Ln_IdMotivo,
                                                           Pv_UsrCreacion,
                                                           Ln_IdDocumentoNdi,
                                                           Lbool_Done,
                                                           Lv_MsnError);  

          IF TRIM(Lv_MsnError) IS NOT NULL THEN
            RAISE Le_ExceptionAgrupoNci;
          END IF; 
          --
          Lr_InfoDocumentoFinanCabNdi := DB_FINANCIERO.FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Ln_IdDocumentoNdi, NULL);
          --
          IF Lbool_Done THEN      
            --
            --Se insertan caracteristicas por NDI Agrupada:
            --PROCESO_DIFERIDO (en S), 
            --ES_PROCESO_MASIVO (id_proceso_masivo PMA de diferido), 
            --ES_ID_SOLICITUD (id_detalle_solicitud de diferido),
            Lr_InfoDocumentoCaract := NULL;
            Lr_InfoDocumentoCaract.DOCUMENTO_ID                := Ln_IdDocumentoNdi;
            Lr_InfoDocumentoCaract.FE_CREACION                 := SYSDATE;
            Lr_InfoDocumentoCaract.USR_CREACION                := Pv_UsrCreacion;
            Lr_InfoDocumentoCaract.IP_CREACION                 := Lv_IpCreacion;
            Lr_InfoDocumentoCaract.ESTADO                      := Lv_EstadoActivo;            
            --
            --Se agrega caracteristica PROCESO_DE_EJECUCION
            IF Pn_IdPunto IS NOT NULL THEN
              Lr_InfoDocumentoCaract.VALOR := 'INDIVIDUAL';             
            ELSE
              Lr_InfoDocumentoCaract.VALOR := 'MASIVO';             
            END IF;
            --
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoEjecucion;     
            Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;                    
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionNci;
            END IF;
            --
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoDiferido;
            Lr_InfoDocumentoCaract.VALOR                       := 'S';    
            Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;         
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionNci;
            END IF;
            --                         
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoMasivo;
            Lr_InfoDocumentoCaract.VALOR                       := Ln_IdProcesoMasivo;
            Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionNci;
            END IF;
            --
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractIdSolicitud;
            Lr_InfoDocumentoCaract.VALOR                       := Ln_IdDetalleSolicitud;
            Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionNci;
            END IF;
            --
          END IF;      
          --      
          --
          FOR Lr_NciDiferidos IN C_GetNciDiferidos(Lr_AgrupcionNciDiferidos.ID_PROCESO_MASIVO,        
                                                   Lr_AgrupcionNciDiferidos.ID_PUNTO,        
                                                   Lv_CodigoTipoDocumento,
                                                   Pv_UsrCreacion,   
                                                   Lv_EstadoActivo,           
                                                   Lv_CaractProcesoDiferido,                                                   
                                                   Lv_CaractContDiferido, 
                                                   Lv_CaractMesesDiferido,    
                                                   Lv_CaractProcesoMasivo)    
          LOOP 
            --
            BEGIN        
              --
              Ln_IdDocumentoNci         := Lr_NciDiferidos.ID_DOCUMENTO;
              Ln_NumCuotaDiferida       := 0;
              Ln_MesesDiferido          := 0;
              Ln_IdDocCaracContDiferido := NULL;
              Lv_ObservacionNdiCuota    := '';
              Ln_ValorCuotaDiferida     := 0;
              Lv_MsnError               := NULL;
              --
              IF C_GetDocumentoCaract%ISOPEN THEN    
                CLOSE C_GetDocumentoCaract;    
              END IF;  
              --
              --Obtengo caracter�stica ES_CONT_DIFERIDO del id_documento NCI para actualizaci�n de la cuota generada por ndi.
              --
              OPEN C_GetDocumentoCaract(Ln_IdDocumentoNci,Lv_CaractContDiferido,Lv_EstadoActivo);
              FETCH C_GetDocumentoCaract INTO Lc_GetDocumentoCaract;          
              IF C_GetDocumentoCaract%NOTFOUND THEN
                Lv_MsnError := 'Error al recuperar caracteristica necesaria para el proceso '|| Lv_CaractContDiferido ||
                               ' para la NCI #'|| Ln_IdDocumentoNci;
                RAISE Le_ExceptionNci;       
              END IF;
              Ln_IdDocCaracContDiferido := Lc_GetDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA;
              CLOSE C_GetDocumentoCaract;                                         
              --
              --
              IF Lr_NciDiferidos.ES_MESES_DIFERIDO = 0 THEN
                Lv_MsnError := 'Error al recuperar caracteristica necesaria para el proceso '|| Lv_CaractMesesDiferido ||
                               ' para la NCI #'|| Ln_IdDocumentoNci;
                RAISE Le_ExceptionNci;       
              END IF;                    
              --
              Ln_NumCuotaDiferida    := Lr_NciDiferidos.ES_CONT_DIFERIDO;
              Ln_NumCuotaDiferida    := Ln_NumCuotaDiferida + 1;
              Ln_MesesDiferido       := Lr_NciDiferidos.ES_MESES_DIFERIDO;              
              Lv_ObservacionNdiCuota := Lv_ObservacionNdi || ' #Cuota Generada: ' || Ln_NumCuotaDiferida || ' de ' || Ln_MesesDiferido || 
                                        '. NDI Agrupada # '|| Lr_InfoDocumentoFinanCabNdi.NUMERO_FACTURA_SRI || '.';
              --  
              Ln_ValorCuotaDiferida  := FNCK_PAGOS_DIFERIDOS.F_GET_VALOR_CUOTA_DIFERIDA(Ln_IdDocumentoNci,Ln_NumCuotaDiferida,Ln_MesesDiferido);
              IF Ln_ValorCuotaDiferida IS NULL OR Ln_ValorCuotaDiferida = 0 THEN
                Lv_MsnError := 'Error al obtener el valor de la cuota diferida para la NCI #'|| Ln_IdDocumentoNci;
                RAISE Le_ExceptionNci;
              END IF;
              --
              Ln_ValorTotalNdi := Ln_ValorTotalNdi + Ln_ValorCuotaDiferida;
              --
              --Se guardan las siguientes caracter�sticas por cada NCI que se agrupe en la NDI:
              --ID_REFERENCIA_NCI(id_documento NCI que origino la NDI Agrupada),
              --NUM_CUOTA_DIFERIDA (#cuota por NCI correspondiente a la NDI Agrupada)                
              --VALOR_CUOTA_DIFERIDA (Valor de la Cuota correspondiente a la NCI)                                        
              --
              Lr_InfoDocumentoCaract := NULL;
              Lr_InfoDocumentoCaract.DOCUMENTO_ID                := Ln_IdDocumentoNdi;
              Lr_InfoDocumentoCaract.FE_CREACION                 := SYSDATE;
              Lr_InfoDocumentoCaract.USR_CREACION                := Pv_UsrCreacion;
              Lr_InfoDocumentoCaract.IP_CREACION                 := Lv_IpCreacion;
              Lr_InfoDocumentoCaract.ESTADO                      := Lv_EstadoActivo;
              --
              Ln_IdDocCaracIdReferenciaNci                       := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
              Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := Ln_IdDocCaracIdReferenciaNci;
              Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractReferenciaNci;
              Lr_InfoDocumentoCaract.VALOR                       := Ln_IdDocumentoNci;
              Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;
              FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
              IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_ExceptionNci;
              END IF;
              --            
              Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
              Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractNumCuotaDiferida;
              Lr_InfoDocumentoCaract.VALOR                       := Ln_NumCuotaDiferida;
              Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := Ln_IdDocCaracIdReferenciaNci;
              FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
              IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_ExceptionNci;
              END IF;         
              --
              Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
              Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractValorCuotaDiferida;
              Lr_InfoDocumentoCaract.VALOR                       := Ln_ValorCuotaDiferida;
              Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := Ln_IdDocCaracIdReferenciaNci;
              FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
              IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_ExceptionNci;
              END IF;                 
              --      
              --
              --Actualizo el valor de la caracteristica ES_CONT_DIFERIDO en la NCI en INFO_DOCUMENTO_CARACTERISTICA para registrar el #cuota
              -- o NDI generada por el proceso.            
              Lr_InfoDocumentoCaract := NULL;
              Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA  := Ln_IdDocCaracContDiferido;
              Lr_InfoDocumentoCaract.FE_ULT_MOD    := SYSDATE;
              Lr_InfoDocumentoCaract.USR_ULT_MOD   := Pv_UsrCreacion;
              Lr_InfoDocumentoCaract.IP_ULT_MOD    := Lv_IpCreacion;
              Lr_InfoDocumentoCaract.VALOR         := Ln_NumCuotaDiferida;

              FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
              IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_ExceptionNci;
              END IF;             
              -- 
              --Inserto Historial en la NCI indicando que se proces� con exito la NDI por Diferido indicando numero de cuota y # NDI generada.
              --            
              Lr_InfoDocumentoFinanHst := NULL;
              Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
              Lr_InfoDocumentoFinanHst.DOCUMENTO_ID           := Ln_IdDocumentoNci;
              Lr_InfoDocumentoFinanHst.MOTIVO_ID              := Ln_IdMotivo;
              Lr_InfoDocumentoFinanHst.FE_CREACION            := SYSDATE;
              Lr_InfoDocumentoFinanHst.USR_CREACION           := Pv_UsrCreacion;
              Lr_InfoDocumentoFinanHst.ESTADO                 := Lr_NciDiferidos.ESTADO_IMPRESION_FACT;
              Lr_InfoDocumentoFinanHst.OBSERVACION            := Lv_ObservacionNdiCuota;
              --
              DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinanHst, Lv_MsnError);
              --
              IF Lv_MsnError IS NOT NULL THEN              
                RAISE Le_ExceptionNci;              
              END IF;                      
              --
              --
            EXCEPTION
              WHEN Le_ExceptionNci THEN
                --
                Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de generaci�n de NDI por Diferido de Facturas por Emergencia Sanitaria' ||
                                  ' - ' || Lv_MsnError;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                     'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_NDI_DIFERIDO', 
                                                     Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                     'telcos_diferido',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
              WHEN OTHERS THEN
                --
                Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de generaci�n de NDI por Diferido de Facturas por Emergencia Sanitaria.' ||
                                  ' - ' || Lv_MsnError;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                     'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_NDI_DIFERIDO', 
                                                     Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                     'telcos_diferido',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
            --
            END;        
            --
            --  
          END LOOP;
          --
          --
          Lr_InfoDocumentoFinanCabNdi.VALOR_TOTAL := ROUND(Ln_ValorTotalNdi, 2);
          Lr_InfoDocumentoFinanCabNdi.SUBTOTAL    := ROUND(Ln_ValorTotalNdi, 2);
          --
          --Actualiza el los valores totales de la cabecera
          DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinanCabNdi.ID_DOCUMENTO,
                                                                        Lr_InfoDocumentoFinanCabNdi,
                                                                        Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN            
            RAISE Le_ExceptionAgrupoNci;           
          END IF;
          --
          Lv_ObservacionNdiAgrupada := FNCK_PAGOS_DIFERIDOS.F_OBSERVACION_NDI(Ln_IdDocumentoNdi);
          Lr_InfoDocumentoFinanDetNdi.PRECIO_VENTA_FACPRO_DETALLE   := ROUND(Ln_ValorTotalNdi, 2);
          Lr_InfoDocumentoFinanDetNdi.OBSERVACIONES_FACTURA_DETALLE := Lv_ObservacionNdiAgrupada;
          --
          FNCK_PAGOS_DIFERIDOS.UPDATE_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinanCabNdi.ID_DOCUMENTO,
                                                              Lr_InfoDocumentoFinanDetNdi,
                                                              Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN            
            RAISE Le_ExceptionAgrupoNci;           
          END IF;
          --
          --
          --Historial de la NDI generada.
          --
          Lr_InfoDocumentoFinanHst := NULL;
          Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
          Lr_InfoDocumentoFinanHst.DOCUMENTO_ID           := Lr_InfoDocumentoFinanCabNdi.ID_DOCUMENTO;
          Lr_InfoDocumentoFinanHst.MOTIVO_ID              := Ln_IdMotivo;
          Lr_InfoDocumentoFinanHst.FE_CREACION            := SYSDATE;
          Lr_InfoDocumentoFinanHst.USR_CREACION           := Pv_UsrCreacion;
          Lr_InfoDocumentoFinanHst.ESTADO                 := Lr_InfoDocumentoFinanCabNdi.ESTADO_IMPRESION_FACT;
          Lr_InfoDocumentoFinanHst.OBSERVACION            := SUBSTR(Lv_ObservacionNdiAgrupada,0,1000);
          --
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinanHst, Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN
            --
            RAISE Le_ExceptionAgrupoNci;
            --
          END IF;       
          --
        EXCEPTION
          WHEN Le_ExceptionAgrupoNci THEN
            --
            Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de generaci�n de NDI por Diferido de Facturas por Emergencia Sanitaria' ||
                              ' - ' || Lv_MsnError;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_NDI_DIFERIDO', 
                                                 Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_diferido',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
          WHEN OTHERS THEN
            --
            Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de generaci�n de NDI por Diferido de Facturas por Emergencia Sanitaria.' ||
                              ' - ' || Lv_MsnError;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_NDI_DIFERIDO', 
                                                 Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_diferido',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
        --
        END;        
        --
        --      
      END LOOP;-- FIN Ln_Indx IS NOT NULL
      --
      COMMIT;
      --
      EXIT WHEN Lrf_NciProcesoDiferidos%NOTFOUND;
      --
    END LOOP;
    --
    CLOSE Lrf_NciProcesoDiferidos; 
    --
    Pv_MsjResultado := 'OK';
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      ROLLBACK;
      Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de generaci�n de NDI por Diferido de Facturas por Emergencia Sanitaria' ||
                        ' - ' || Lv_MsnError;
      Pv_MsjResultado := Lv_MsjResultado; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_NDI_DIFERIDO', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          ); 
    WHEN OTHERS THEN
      --
      ROLLBACK;
      Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de generaci�n de NDI por Diferido de Facturas por Emergencia Sanitaria.' ||
                        ' - ' || Lv_MsnError;
      Pv_MsjResultado := Lv_MsjResultado;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_NDI_DIFERIDO', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );                     
  END  P_EJECUTA_NDI_DIFERIDO;
  --
  --
  --
  PROCEDURE P_EJECUTA_SOL_DIFERIDO(Pv_Empresa               IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Pv_UsrCreacion           IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                   Pv_DescripcionSolicitud  IN DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE,
                                   Pv_FormaPago             IN VARCHAR2 DEFAULT NULL,
                                   Pn_IdCiclo               IN DB_FINANCIERO.ADMI_CICLO.ID_CICLO%TYPE DEFAULT NULL,
                                   Pv_IdsFormasPagoEmisores IN VARCHAR2 DEFAULT NULL,
                                   Pn_IdPunto               IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                   Pv_MsjResultado          OUT VARCHAR2)
  IS
    CURSOR C_GetSolCarac(Cn_IdDetalleSolicitud  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                         Cv_DescripCarac        DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                         Cv_Estado              DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE) 
    IS
      SELECT DSC.ID_SOLICITUD_CARACTERISTICA,
      DSC.DETALLE_SOLICITUD_ID,
      CA.DESCRIPCION_CARACTERISTICA,
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(DSC.VALOR,'^\d+')),0) AS VALOR
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC, 
      DB_COMERCIAL.ADMI_CARACTERISTICA CA
      WHERE DETALLE_SOLICITUD_ID        = Cn_IdDetalleSolicitud
      AND DSC.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA = Cv_DescripCarac
      AND DSC.ESTADO                    = Cv_Estado;

    --
    CURSOR C_GetMotivoNc(Cv_NombreMotivo DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE)
    IS
      SELECT AM.ID_MOTIVO,
      AM.NOMBRE_MOTIVO
      FROM DB_GENERAL.ADMI_MOTIVO  AM 
      WHERE AM.NOMBRE_MOTIVO = Cv_NombreMotivo    
      AND AM.ESTADO          = 'Activo';

    CURSOR C_GetCaracterist (Cv_DescCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      SELECT ID_CARACTERISTICA,
      DESCRIPCION_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = Cv_DescCarac;

    CURSOR C_GetCantidadSolCarac(Cn_IdDetalleSolicitud  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                 Cv_DescripCarac        DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                 Cv_Estado              DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE) 
    IS
      SELECT COUNT(*) AS CANTIDAD
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC, 
      DB_COMERCIAL.ADMI_CARACTERISTICA CA
      WHERE DETALLE_SOLICITUD_ID        = Cn_IdDetalleSolicitud
      AND DSC.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA = Cv_DescripCarac
      AND DSC.ESTADO                    = Cv_Estado;

    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion VARCHAR2,
                        Cv_EstadoActivo VARCHAR2)
    IS      
      SELECT DET.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO             = Cv_EstadoActivo
      AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
      AND DET.DESCRIPCION        = Cv_Descripcion
      AND DET.ESTADO             = Cv_EstadoActivo;

    CURSOR C_GetCantidadFactSol (Cn_IdDetalleSolicitud  DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ID_DETALLE_SOLICITUD%TYPE,
                                 Cv_DescripCarac        DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                 Cv_EstadoPendiente     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE,
                                 Cv_EstadoFinalizada    DB_COMERCIAL.INFO_DETALLE_SOL_CARACT.ESTADO%TYPE,
                                 Cn_ValorFactura        NUMBER)
    IS
      SELECT COUNT(*) AS CANTIDAD_FAC
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC, 
      DB_COMERCIAL.ADMI_CARACTERISTICA CA,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB FAC
      WHERE DETALLE_SOLICITUD_ID        = Cn_IdDetalleSolicitud
      AND DSC.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA = Cv_DescripCarac    
      AND FAC.ID_DOCUMENTO              = COALESCE(TO_NUMBER(REGEXP_SUBSTR(DSC.VALOR,'^\d+')),0)      
      AND (
           DSC.ESTADO                    = Cv_EstadoFinalizada
           OR ( DSC.ESTADO               = Cv_EstadoPendiente
                AND NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(FAC.ID_DOCUMENTO,
                                                                                    TO_CHAR(SYSDATE,'DD-MM-RRRR'), 'saldo'),2),0 )>Cn_ValorFactura
              )
          );

    Lv_IpCreacion               VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Le_Exception                EXCEPTION;
    Le_ExceptionSol             EXCEPTION;
    Le_ExceptionSolFact         EXCEPTION;
    Lv_MsjResultado             VARCHAR2(200);
    Lv_MsnError                 VARCHAR2(400);
    Lv_CaractCicloFact          VARCHAR2(20) :='CICLO_FACTURACION';
    Lv_CaractProcesoDiferido    VARCHAR2(20) :='PROCESO_DIFERIDO';
    Lv_CaractSolFactura         VARCHAR2(20) :='ES_SOL_FACTURA';
    Lv_CaractMesesDiferido      VARCHAR2(20) :='ES_MESES_DIFERIDO';
    Lv_CaractContDiferido       VARCHAR2(20) :='ES_CONT_DIFERIDO';
    Lv_CaractIdSolicitud        VARCHAR2(20) :='ES_ID_SOLICITUD';
    Lv_CaractProcesoMasivo      VARCHAR2(20) :='ES_PROCESO_MASIVO';
    Lv_CaractProcesoEjecucion   VARCHAR2(20) :='PROCESO_DE_EJECUCION';
    Ln_IdCaractProcesoDiferido  DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractSolFactura       DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractMesesDiferido    DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractContDiferido     DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractIdSolicitud      DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractProcesoMasivo    DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractProcesoEjecucion DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Lv_EstadoPendiente          DB_COMERCIAL.INFO_DETALLE_SOLICITUD.ESTADO%TYPE:='Pendiente'; 
    Lv_EstadoRechazado          DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE:='Rechazado';
    Lv_CadenaQuery              VARCHAR2(4000);
    Lv_CadenaFrom               VARCHAR2(3000);
    Lv_CadenaWhere              VARCHAR2(3000);  
    Lv_CadenaAgrupa             VARCHAR2(1000); 
    Lv_CadenaOrdena             VARCHAR2(1000);       
    Lv_Consulta                 VARCHAR2(4000);   
    Lrf_SolicDiferidos          SYS_REFCURSOR;
    Lr_DetalleSolicDiferido     Lr_SolicDiferidos;
    La_SolicDiferidos           T_SolicDiferidos; 
    Ln_Limit                    CONSTANT PLS_INTEGER DEFAULT 1;  
    Ln_Indx                     NUMBER;
    Lc_GetSolCarac              C_GetSolCarac%ROWTYPE;
    Lc_GetMotivoNc              C_GetMotivoNc%ROWTYPE;
    Lc_GetCaracterist           C_GetCaracterist%ROWTYPE;
    Ln_CantidadSolCarac         NUMBER:=0;
    Ln_MesesDiferido            NUMBER:=0;
    Ln_IdSolCaracMesesDiferido  NUMBER;
    Ln_IdProcesoMasivo          NUMBER;
    Ln_IdSolCaracIdProcMasivo   NUMBER;
    Ln_IdDocumentoFac           NUMBER:=0;
    Ln_IdTipoDocumento          DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.ID_TIPO_DOCUMENTO%TYPE;
    Lv_ObservacionNc            VARCHAR2(200):='Se cre� la nota de cr�dito interna por proceso de Pagos Diferidos.';
    Ln_IdMotivo                 DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE;
    Lv_NombreMotivo             DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE:='Saldo a Diferir en cuotas';
    Ln_IdDocumentoNC            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Lv_ObservacionCreacion      VARCHAR2(200);
    Lbool_Done                  BOOLEAN;
    Lv_EstadoFallo              VARCHAR2(20):='Fallo';
    Lv_EstadoFinalizada         VARCHAR2(20):='Finalizada';
    Lv_EstadoSolicitud          VARCHAR2(20);
    Lv_ObservacionSolicitud     VARCHAR2(250);
    Lv_EstadoActivo             VARCHAR2(20):='Activo';
    Lr_InfoDetalleSolHist       DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lr_InfoDetalleSolicitud     DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleSolCaract     DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE;
    Lr_InfoDocumentoCaract      DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;
    Lv_NombreParametro          DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROCESO_EMER_SANITARIA';
    Lv_DescValorFactura         DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'VALOR_FACT_MIN';
    Lv_DescCantidadFacturas     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'FACTURAS_MINIMA';
    Ln_ValorFactura             NUMBER;
    Ln_CantidadFacturas         NUMBER;
    Ln_CantidadFacturasSol      NUMBER;
    Lb_EstadoFallo              BOOLEAN;
    --
  BEGIN

    --Costo Query: 32
    --
    Lv_CadenaQuery := 'SELECT DISTINCT DS.ID_DETALLE_SOLICITUD,IPER.ID_PERSONA_ROL,IP.ID_PUNTO,ISE.ID_SERVICIO';    

    Lv_CadenaFrom  := ' FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS,'||
                      ' DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS,'||
                      ' DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC,'||
                      ' DB_COMERCIAL.ADMI_CARACTERISTICA CA,'||                      
                      ' DB_COMERCIAL.INFO_SERVICIO ISE,'||
                      ' DB_COMERCIAL.INFO_PUNTO IP,'||
                      ' DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,'||
                      ' DB_COMERCIAL.INFO_PERSONA IPE,'||
                      ' DB_COMERCIAL.INFO_EMPRESA_ROL IER,'||
                      ' DB_GENERAL.ADMI_ROL AR';

    Lv_CadenaWhere:=  ' WHERE DS.TIPO_SOLICITUD_ID = TS.ID_TIPO_SOLICITUD
    AND TS.DESCRIPCION_SOLICITUD      = '''||Pv_DescripcionSolicitud||'''
    AND DS.ID_DETALLE_SOLICITUD       = DSC.DETALLE_SOLICITUD_ID
    AND DSC.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
    AND CA.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractSolFactura||'''
    AND DS.ESTADO                     = '''||Lv_EstadoPendiente||'''
    AND DSC.ESTADO                    = '''||Lv_EstadoPendiente||'''
    AND DS.SERVICIO_ID                = ISE.ID_SERVICIO                        
    AND ISE.PUNTO_ID                  = IP.ID_PUNTO
    AND IPER.ID_PERSONA_ROL           = IP.PERSONA_EMPRESA_ROL_ID
    AND IPER.PERSONA_ID               = IPE.ID_PERSONA
    AND IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL
    AND IER.ROL_ID                    = AR.ID_ROL
    AND IER.EMPRESA_COD               = '''||Pv_Empresa||''' ';

    Lv_CadenaAgrupa:= ' GROUP BY DS.ID_DETALLE_SOLICITUD,IPER.ID_PERSONA_ROL,IP.ID_PUNTO,ISE.ID_SERVICIO ';
    Lv_CadenaOrdena:= ' ORDER BY DS.ID_DETALLE_SOLICITUD ASC';

    IF Pv_FormaPago IS NOT NULL AND Pn_IdCiclo IS NOT NULL AND Pv_IdsFormasPagoEmisores IS NOT NULL THEN
      --
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO, DB_COMERCIAL.ADMI_CARACTERISTICA CARAC ';
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_FINANCIERO.ADMI_CICLO ADMCICLO';
      Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_CONTRATO CONT, DB_GENERAL.ADMI_FORMA_PAGO FP ';    
      --
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IPER.ID_PERSONA_ROL              = CICLO.PERSONA_EMPRESA_ROL_ID ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CICLO.ESTADO                     = '''||Lv_EstadoActivo||'''  ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CICLO.CARACTERISTICA_ID          = CARAC.ID_CARACTERISTICA ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CARAC.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractCicloFact||'''  ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,''^\d+'')),0) = ADMCICLO.ID_CICLO ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND ADMCICLO.ID_CICLO                = COALESCE(TO_NUMBER(REGEXP_SUBSTR('||Pn_IdCiclo||',''^\d+'')),0) ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IPER.ID_PERSONA_ROL              = CONT.PERSONA_EMPRESA_ROL_ID ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CONT.ESTADO                      NOT IN ('''||Lv_EstadoRechazado||''') ';
      Lv_CadenaWhere:= Lv_CadenaWhere || ' AND CONT.FORMA_PAGO_ID               = FP.ID_FORMA_PAGO ';
      --
      IF Pv_FormaPago='DEBITO BANCARIO' THEN
        Lv_CadenaFrom := Lv_CadenaFrom || ', DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO CONFP';

        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND FP.DESCRIPCION_FORMA_PAGO = '''||Pv_FormaPago||''' 
        AND CONT.ID_CONTRATO            = CONFP.CONTRATO_ID
        AND CONFP.BANCO_TIPO_CUENTA_ID  IN ('|| Pv_IdsFormasPagoEmisores ||') 
        AND CONFP.ESTADO                NOT IN ('''||Lv_EstadoRechazado||''') ';    

      ELSIF Pv_FormaPago='EFECTIVO' THEN
        Lv_CadenaWhere:= Lv_CadenaWhere || ' AND FP.ID_FORMA_PAGO IN ('|| Pv_IdsFormasPagoEmisores ||') ';
      END IF;
      --    
    END IF;
    --
    IF Pn_IdPunto IS NOT NULL THEN
       Lv_CadenaWhere:= Lv_CadenaWhere || ' AND IP.ID_PUNTO = '|| Pn_IdPunto ||' ';
    END IF;
    --
    Lv_Consulta := Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaAgrupa || Lv_CadenaOrdena;
    --  
    IF C_Parametros%ISOPEN THEN
      CLOSE C_Parametros;
    END IF;  
    IF Lrf_SolicDiferidos%ISOPEN THEN    
      CLOSE Lrf_SolicDiferidos;    
    END IF;
    IF C_GetSolCarac%ISOPEN THEN    
      CLOSE C_GetSolCarac;    
    END IF;
    IF C_GetMotivoNc%ISOPEN THEN    
      CLOSE C_GetMotivoNc;    
    END IF;
    IF C_GetCaracterist%ISOPEN THEN    
      CLOSE C_GetCaracterist;    
    END IF;
    IF C_GetCantidadSolCarac%ISOPEN THEN    
      CLOSE C_GetCantidadSolCarac;    
    END IF;
    IF C_GetCantidadFactSol%ISOPEN THEN    
      CLOSE C_GetCantidadFactSol;    
    END IF;
    --
    OPEN C_GetMotivoNc(Lv_NombreMotivo);
    --
    FETCH C_GetMotivoNc INTO Lc_GetMotivoNc;
    IF C_GetMotivoNc%NOTFOUND THEN
      Lv_MsnError := 'No existe motivo configurado para la creaci�n de Documentos NCI';
      RAISE Le_Exception;       
    END IF;
    Ln_IdMotivo:=Lc_GetMotivoNc.ID_MOTIVO;
    CLOSE C_GetMotivoNc; 
    --
    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescValorFactura,
                      Lv_EstadoActivo);
    FETCH C_Parametros INTO Ln_ValorFactura;
    IF C_Parametros%NOTFOUND THEN
      Lv_MsnError := 'Error al recuperar el par�metro para evaluaci�n de facturas con un valor m�nimo de saldo.';
      RAISE Le_Exception;  
    END IF;
    CLOSE C_Parametros;   
    --
    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescCantidadFacturas,
                      Lv_EstadoActivo);
    FETCH C_Parametros INTO Ln_CantidadFacturas;
    IF C_Parametros%NOTFOUND THEN
      Lv_MsnError := 'Error al recuperar el par�metro para evaluaci�n de minimo de facturas permitidas para el proceso';
      RAISE Le_Exception;  
    END IF;
    CLOSE C_Parametros;   
    --
    OPEN C_GetCaracterist(Lv_CaractProcesoDiferido);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoDiferido:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractSolFactura);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractSolFactura:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist;
    --
    OPEN C_GetCaracterist(Lv_CaractMesesDiferido);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractMesesDiferido:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractContDiferido);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractContDiferido:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractIdSolicitud);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractIdSolicitud:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractProcesoMasivo);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoMasivo:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractProcesoEjecucion);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoEjecucion:=Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    IF Ln_IdCaractProcesoDiferido IS NULL OR Ln_IdCaractSolFactura IS NULL
      OR Ln_IdCaractMesesDiferido IS NULL OR Ln_IdCaractContDiferido IS NULL 
      OR Ln_IdCaractIdSolicitud IS NULL OR Ln_IdCaractProcesoMasivo IS NULL
      OR Ln_IdCaractProcesoEjecucion IS NULL THEN
      Lv_MsnError := 'Error al recuperar caracteristicas necesarias para el proceso ' || Lv_CaractProcesoDiferido || ' - ' ||
                     Lv_CaractSolFactura || ' - ' || Lv_CaractMesesDiferido || ' - ' || Lv_CaractContDiferido || ' - ' ||
                     Lv_CaractIdSolicitud || ' - ' || Lv_CaractProcesoMasivo || ' - ' || Lv_CaractProcesoEjecucion;
      RAISE Le_Exception;  
    END IF;
    --
    La_SolicDiferidos.DELETE();
    --
    -- Obtengo las Solicitudes Pendientes de ejecuci�n para el Proceso de Diferido de Facturas por Emergencia Sanitaria.
    -- Se realiza commit por cada registro debido a que debe actualizarse de forma imnediata el saldo del Documento.
    OPEN Lrf_SolicDiferidos FOR Lv_Consulta;
    LOOP
      FETCH Lrf_SolicDiferidos BULK COLLECT INTO La_SolicDiferidos LIMIT Ln_Limit;
      Ln_Indx := La_SolicDiferidos.FIRST;
      WHILE (Ln_Indx IS NOT NULL)
      LOOP
        BEGIN
          --
          Lr_InfoDetalleSolicitud    := NULL;
          Lr_InfoDetalleSolHist      := NULL;
          Lr_InfoDetalleSolCaract    := NULL;
          Lr_InfoDocumentoCaract     := NULL;
          Lv_MsnError                := NULL;
          Ln_MesesDiferido           := NULL;
          Ln_IdSolCaracMesesDiferido := NULL;
          Ln_IdProcesoMasivo         := NULL;
          Ln_IdSolCaracIdProcMasivo  := NULL;
          Ln_CantidadSolCarac        := 0;
          Lb_EstadoFallo             := FALSE;
          --
          Lr_DetalleSolicDiferido := La_SolicDiferidos(Ln_Indx);
          Ln_Indx  := La_SolicDiferidos.NEXT(Ln_Indx);  
          --
          -- Obtengo la cantidad de Facturas registradas por Solicitud que poseen saldo mayor al valor minimo parametrizado 'VALOR_FACT_MIN'
          -- o que hayan sido Finalizadas.
          --
          OPEN C_GetCantidadFactSol(Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD,Lv_CaractSolFactura,Lv_EstadoPendiente,Lv_EstadoFinalizada,Ln_ValorFactura);
          FETCH C_GetCantidadFactSol INTO Ln_CantidadFacturasSol;
          CLOSE C_GetCantidadFactSol;                    
          --
          -- Si la Cantidad de Facturas registradas en la solicitud es menor al minimo de Facturas Parametrizado 'FACTURAS_MINIMA'
          -- no se procesa las Facturas registradas en la solicitud de diferidos y se las pasa a 'Fallo'.
          --
          IF Ln_CantidadFacturasSol < Ln_CantidadFacturas AND Pn_IdPunto IS NULL THEN
            --           
            --Verifico que la solicitud no posea registros Finalizados para poder pasar a estado 'Fallo'.
            OPEN C_GetCantidadSolCarac(Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD,Lv_CaractSolFactura,Lv_EstadoFinalizada);
            FETCH C_GetCantidadSolCarac INTO Ln_CantidadSolCarac;
            CLOSE C_GetCantidadSolCarac;
            --
            IF Ln_CantidadSolCarac = 0 THEN
               Lb_EstadoFallo:=TRUE;
               Lv_ObservacionSolicitud:='No se procesa Solicitud por no poseer el minimo de Facturas con saldo requerido por el proceso';
            END IF;
          END IF;
          --
          --Obtengo los meses a Diferir ingresados en la Solicitud.
          --
          OPEN C_GetSolCarac(Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD,Lv_CaractMesesDiferido,Lv_EstadoPendiente);          
          FETCH C_GetSolCarac INTO Lc_GetSolCarac;  
          --Se procede a pasar la Solicitud a estado 'Fallo' ya que no contiene los meses a diferir.
          IF C_GetSolCarac%NOTFOUND THEN  
             Lb_EstadoFallo:=TRUE;
             Lv_ObservacionSolicitud := 'No se procesa Solicitud ya que no contiene registro de meses a diferir.';
          END IF;
          CLOSE C_GetSolCarac;  
          --
          Ln_MesesDiferido           := Lc_GetSolCarac.VALOR;
          Ln_IdSolCaracMesesDiferido := Lc_GetSolCarac.ID_SOLICITUD_CARACTERISTICA;         
          --    
          --
          --Obtengo el Id de proceso masivo ingresado como caracteristica en la Solicitud.
          --
          OPEN C_GetSolCarac(Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD,Lv_CaractProcesoMasivo,Lv_EstadoPendiente);          
          FETCH C_GetSolCarac INTO Lc_GetSolCarac;  
          --Se procede a pasar la Solicitud a estado 'Fallo' ya que no contiene el id de proceso masivo.
          IF C_GetSolCarac%NOTFOUND THEN  
             Lb_EstadoFallo:=TRUE;
             Lv_ObservacionSolicitud := 'No se procesa Solicitud ya que no contiene registro de id_proceso_masivo.';
          END IF;
          CLOSE C_GetSolCarac;  
          --
          Ln_IdProcesoMasivo        := Lc_GetSolCarac.VALOR;
          Ln_IdSolCaracIdProcMasivo := Lc_GetSolCarac.ID_SOLICITUD_CARACTERISTICA;         
          --
          IF Lb_EstadoFallo THEN
            --
            --Se procede a pasar la Solicitud a estado 'Fallo'.
            Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD := Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolicitud.ESTADO               := Lv_EstadoFallo; 
            Lr_InfoDetalleSolicitud.OBSERVACION          := Lv_ObservacionSolicitud;
            --
            FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOLIC(Lr_InfoDetalleSolicitud, Lv_MsnError);
            --          
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionSol;
            END IF;  
            -- 
            --Se procede a pasar a estado 'Fallo' las caracter�sticas asociadas a la solicitud
            --
            Lr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID   := Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolCaract.ESTADO                 := Lv_EstadoFallo;
            Lr_InfoDetalleSolCaract.USR_ULT_MOD            := Pv_UsrCreacion;
            Lr_InfoDetalleSolCaract.FE_ULT_MOD             := SYSDATE;

            FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOL_CARA(Lr_InfoDetalleSolCaract,Lv_MsnError);
            --
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionSol;
            END IF;  
            --
            --Se guarda Historial en la Solicitud por estado 'Fallo'.
            Lr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID   := Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolHist.ESTADO                 := Lv_EstadoFallo;
            Lr_InfoDetalleSolHist.FE_INI_PLAN            := NULL;
            Lr_InfoDetalleSolHist.FE_FIN_PLAN            := NULL;
            Lr_InfoDetalleSolHist.OBSERVACION            := Lv_ObservacionSolicitud;
            Lr_InfoDetalleSolHist.USR_CREACION           := Pv_UsrCreacion;
            Lr_InfoDetalleSolHist.FE_CREACION            := SYSDATE;
            Lr_InfoDetalleSolHist.IP_CREACION            := Lv_IpCreacion;
            Lr_InfoDetalleSolHist.MOTIVO_ID              := Ln_IdMotivo;
            --
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHist, Lv_MsnError);
            --
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionSol;
            END IF;  
            --          
            CONTINUE;
            --    
          END IF;-- Fin Lb_EstadoFallo
          --     
          --
          --Obtengo las Facturas registradas en la Solicitud de Diferido de Facturas.           
          FOR Lr_GetSolCarac IN C_GetSolCarac(Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD,Lv_CaractSolFactura,Lv_EstadoPendiente)
          LOOP 
            --
            BEGIN
              --
              Ln_IdDocumentoNC       := NULL;  
              Lv_ObservacionCreacion := NULL;  
              Lbool_Done             := FALSE; 
              Lv_MsnError            := NULL;  
              Ln_IdDocumentoFac      := Lr_GetSolCarac.VALOR;
              FNCK_PAGOS_DIFERIDOS.P_CREA_NOTA_CREDITO_INTERNA (Ln_IdDocumentoFac,
                                                                Ln_ValorFactura,
                                                                Lv_ObservacionNc || ' Tiempo a diferir Deuda : ' || Ln_MesesDiferido || ' meses. ',
                                                                Ln_IdMotivo,
                                                                Pv_UsrCreacion,
                                                                Pv_Empresa,
                                                                Ln_IdDocumentoNC,
                                                                Lv_ObservacionCreacion,
                                                                Lbool_Done,
                                                                Lv_MsnError);   
              IF TRIM(Lv_MsnError) IS NOT NULL THEN
                RAISE Le_ExceptionSolFact;
              END IF; 
              --
              --Si se genero con exito la NCI.
              IF Lbool_Done THEN
                -- 
                --Se insertan caracteristicas PROCESO_DIFERIDO, ES_SOL_FACTURA, ES_MESES_DIFERIDO, ES_CONT_DIFERIDO, ES_PROCESO_MASIVO, ES_ID_SOLICITUD a la NCI generada
                --en INFO_DOCUMENTO_CARACTERISTICA.
                --
                Lr_InfoDocumentoCaract := NULL;
                Lr_InfoDocumentoCaract.DOCUMENTO_ID                := Ln_IdDocumentoNC;
                Lr_InfoDocumentoCaract.FE_CREACION                 := SYSDATE;
                Lr_InfoDocumentoCaract.USR_CREACION                := Pv_UsrCreacion;
                Lr_InfoDocumentoCaract.IP_CREACION                 := Lv_IpCreacion;
                Lr_InfoDocumentoCaract.ESTADO                      := Lv_EstadoActivo;
                --
                --Se agrega caracteristica PROCESO_DE_EJECUCION
                IF Pn_IdPunto IS NOT NULL THEN
                  Lr_InfoDocumentoCaract.VALOR := 'INDIVIDUAL';             
                ELSE
                  Lr_InfoDocumentoCaract.VALOR := 'MASIVO';             
                END IF;
                --
                Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoEjecucion;                
                FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;
                --
                Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoDiferido;
                Lr_InfoDocumentoCaract.VALOR                       := 'S';             
                FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;
                --
                Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractSolFactura;
                Lr_InfoDocumentoCaract.VALOR                       := Ln_IdDocumentoFac;
                FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;
                --
                Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractMesesDiferido;
                Lr_InfoDocumentoCaract.VALOR                       := Ln_MesesDiferido;
                FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF; 
                --
                Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractContDiferido;
                Lr_InfoDocumentoCaract.VALOR                       := 0;
                FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;
                --
                Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoMasivo;
                Lr_InfoDocumentoCaract.VALOR                       := Ln_IdProcesoMasivo;
                FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;
                --
                Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractIdSolicitud;
                Lr_InfoDocumentoCaract.VALOR                       := Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD;
                FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;
                --
                --Se inserta caracteristica PROCESO_DIFERIDO a la Factura a la cual se le proceso la NCI en INFO_DOCUMENTO_CARACTERISTICA.
                --   
                Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
                Lr_InfoDocumentoCaract.DOCUMENTO_ID                := Ln_IdDocumentoFac;
                Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoDiferido;
                Lr_InfoDocumentoCaract.VALOR                       := 'S';              
                FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;
                --
                --Se actualiza a estado 'Finalizada' la caracteristica ES_SOL_FACTURA en INFO_DETALLE_SOL_CARACT que contenia el ID de la Factura a 
                --la cual se aplic� la NCI por diferido.
                --  
                Lr_InfoDetalleSolCaract := NULL;
                Lr_InfoDetalleSolCaract.ID_SOLICITUD_CARACTERISTICA := Lr_GetSolCarac.ID_SOLICITUD_CARACTERISTICA;
                Lr_InfoDetalleSolCaract.ESTADO                      := Lv_EstadoFinalizada;
                Lr_InfoDetalleSolCaract.USR_ULT_MOD                 := Pv_UsrCreacion;
                Lr_InfoDetalleSolCaract.FE_ULT_MOD                  := SYSDATE;
                FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOL_CARA(Lr_InfoDetalleSolCaract,Lv_MsnError);              
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;             
                --
              ELSIF (NOT Lbool_Done AND Lv_ObservacionCreacion IS NOT NULL) THEN                
                --
                --Se actualiza a estado 'Fallo' la caracteristica ES_SOL_FACTURA en INFO_DETALLE_SOL_CARACT que contenia el ID de la Factura a 
                --la cual no se podr� aplicar NCI por diferido por no constar con saldo la Factura.
                --  
                Lr_InfoDetalleSolCaract := NULL;
                Lr_InfoDetalleSolCaract.ID_SOLICITUD_CARACTERISTICA := Lr_GetSolCarac.ID_SOLICITUD_CARACTERISTICA;
                Lr_InfoDetalleSolCaract.ESTADO                      := Lv_EstadoFallo;
                Lr_InfoDetalleSolCaract.USR_ULT_MOD                 := Pv_UsrCreacion;
                Lr_InfoDetalleSolCaract.FE_ULT_MOD                  := SYSDATE;
                FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOL_CARA(Lr_InfoDetalleSolCaract,Lv_MsnError);              
                IF TRIM(Lv_MsnError) IS NOT NULL THEN
                  RAISE Le_ExceptionSolFact;
                END IF;       
                --             
              END IF;-- FIN Lbool_Done  
              --
            EXCEPTION
              WHEN Le_ExceptionSolFact THEN
                --
                Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Solicitudes de Diferido de Facturas por Emergencia Sanitaria' ||
                                  ' - ' || Lv_MsnError;
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                                     'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_SOL_DIFERIDO', 
                                                     Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                     'telcos_diferido',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
              WHEN OTHERS THEN
                --
                Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Solicitudes de Diferido de Facturas por Emergencia Sanitaria.';
                DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                                     'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_SOL_DIFERIDO', 
                                                     Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                     'telcos_diferido',
                                                     SYSDATE,
                                                     NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
              --
            END;
            --
          END LOOP;-- FIN Lr_GetSolCarac   
          --
          --
          --Verifico si todas las Facturas asociadas a la solicitud han sido Procesadas para Finalizar la Solicitud o para pasarla a estado Fallo.
          --
          OPEN C_GetCantidadSolCarac(Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD,Lv_CaractSolFactura,Lv_EstadoPendiente);
          FETCH C_GetCantidadSolCarac INTO Ln_CantidadSolCarac;
          CLOSE C_GetCantidadSolCarac;
          --
          --Si no hay Facturas Pendientes de procesar en la Solicitud, verifico si al menos 1 se Finaliz�.
          IF Ln_CantidadSolCarac = 0 THEN
            --
            OPEN C_GetCantidadSolCarac(Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD,Lv_CaractSolFactura,Lv_EstadoFinalizada);
            FETCH C_GetCantidadSolCarac INTO Ln_CantidadSolCarac;
            CLOSE C_GetCantidadSolCarac;
            IF Ln_CantidadSolCarac > 0 THEN
              Lv_EstadoSolicitud      := Lv_EstadoFinalizada;
              Lv_ObservacionSolicitud := 'Se proceso la Solicitud de Diferido de Facturas por Emergencia Sanitaria.';
            ELSE
              Lv_EstadoSolicitud      := Lv_EstadoFallo;
              Lv_ObservacionSolicitud := 'No se pudo procesar la Solicitud de Diferido de Facturas por Emergencia Sanitaria.';
            END IF;                 
            --
            --Se actualiza la Solicitud a estado 'Finalizada' o 'Fallo'.
            --
            Lr_InfoDetalleSolicitud := NULL;
            Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD := Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolicitud.ESTADO               := Lv_EstadoSolicitud; 
            Lr_InfoDetalleSolicitud.OBSERVACION          := Lv_ObservacionSolicitud;
            --
            FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOLIC(Lr_InfoDetalleSolicitud, Lv_MsnError);
            --          
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionSol;
            END IF;  
            --
            --Se inserta Historial a la Solicitud con estado 'Finalizada' o 'Fallo'.  
            --       
            Lr_InfoDetalleSolHist := NULL;             
            Lr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
            Lr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID   := Lr_DetalleSolicDiferido.ID_DETALLE_SOLICITUD;
            Lr_InfoDetalleSolHist.ESTADO                 := Lv_EstadoSolicitud;
            Lr_InfoDetalleSolHist.FE_INI_PLAN            := NULL;
            Lr_InfoDetalleSolHist.FE_FIN_PLAN            := NULL;
            Lr_InfoDetalleSolHist.OBSERVACION            := Lv_ObservacionSolicitud;
            Lr_InfoDetalleSolHist.USR_CREACION           := Pv_UsrCreacion;
            Lr_InfoDetalleSolHist.FE_CREACION            := SYSDATE;
            Lr_InfoDetalleSolHist.IP_CREACION            := Lv_IpCreacion;
            Lr_InfoDetalleSolHist.MOTIVO_ID              := Ln_IdMotivo;
            --
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHist, Lv_MsnError);
            --
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionSol;
            END IF;  
            --        
            --Se actualiza a estado 'Finalizada' o 'Fallo 'la caracteristica ES_MESES_DIFERIDO en INFO_DETALLE_SOL_CARACT.
            --  
            Lr_InfoDetalleSolCaract := NULL;
            Lr_InfoDetalleSolCaract.ID_SOLICITUD_CARACTERISTICA := Ln_IdSolCaracMesesDiferido;
            Lr_InfoDetalleSolCaract.ESTADO                      := Lv_EstadoSolicitud;
            Lr_InfoDetalleSolCaract.USR_ULT_MOD                 := Pv_UsrCreacion;
            Lr_InfoDetalleSolCaract.FE_ULT_MOD                  := SYSDATE;
            FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOL_CARA(Lr_InfoDetalleSolCaract,Lv_MsnError);              
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionSol;
            END IF;  
              --        
            --Se actualiza a estado 'Finalizada' o 'Fallo 'la caracteristica ES_PROCESO_MASIVO en INFO_DETALLE_SOL_CARACT.
            --  
            Lr_InfoDetalleSolCaract := NULL;
            Lr_InfoDetalleSolCaract.ID_SOLICITUD_CARACTERISTICA := Ln_IdSolCaracIdProcMasivo;
            Lr_InfoDetalleSolCaract.ESTADO                      := Lv_EstadoSolicitud;
            Lr_InfoDetalleSolCaract.USR_ULT_MOD                 := Pv_UsrCreacion;
            Lr_InfoDetalleSolCaract.FE_ULT_MOD                  := SYSDATE;
            FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOL_CARA(Lr_InfoDetalleSolCaract,Lv_MsnError);              
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionSol;
            END IF;              
            --  
          END IF;-- FIN Ln_CantidadSolCarac              
          --
        EXCEPTION
          WHEN Le_ExceptionSol THEN
            --
            Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Solicitudes de Diferido de Facturas por Emergencia Sanitaria' ||
                              ' - ' || Lv_MsnError;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                                 'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_SOL_DIFERIDO', 
                                                 Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_diferido',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
          WHEN OTHERS THEN
            --
            Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Solicitudes de Diferido de Facturas por Emergencia Sanitaria.';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                                 'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_SOL_DIFERIDO', 
                                                 Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_diferido',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
        --
        END;
        --
      END LOOP;-- FIN Ln_Indx
      --
      COMMIT;
      --
      EXIT WHEN Lrf_SolicDiferidos%NOTFOUND;
      --
    END LOOP;
    --
    CLOSE Lrf_SolicDiferidos; 
    --
    Pv_MsjResultado := 'OK';
    --
  EXCEPTION
    WHEN Le_Exception THEN
      --
      ROLLBACK;
      Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Solicitudes de Diferido de Facturas por Emergencia Sanitaria' ||
                        ' - ' || Lv_MsnError;
      Pv_MsjResultado := Lv_MsjResultado;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_SOL_DIFERIDO', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          ); 
    WHEN OTHERS THEN
      --
      ROLLBACK;
      Lv_MsjResultado:= 'Ocurrio un error al ejecutar el Proceso de Solicitudes de Diferido de Facturas por Emergencia Sanitaria.';
      Pv_MsjResultado := Lv_MsjResultado;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_EJECUTA_SOL_DIFERIDO', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );                     
  END  P_EJECUTA_SOL_DIFERIDO; 
  --
  --
  --
  PROCEDURE P_CREA_NOTA_CREDITO_INTERNA(Pn_IdDocumento            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                        Pn_ValorFactura           IN  NUMBER,
                                        Pv_Observacion            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
                                        Pn_IdMotivo               IN  DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE,
                                        Pv_UsrCreacion            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                        Pv_IdEmpresa              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pn_IdDocumentoNC          OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                        Pv_ObservacionCreacion    OUT VARCHAR2,
                                        Pbool_Done                OUT BOOLEAN,
                                        Pv_MessageError           OUT VARCHAR2)
  IS   
    CURSOR C_GetNombreTecnico(Cn_IdProducto DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE)
    IS
      SELECT NOMBRE_TECNICO
      FROM DB_COMERCIAL.ADMI_PRODUCTO
      WHERE NOMBRE_TECNICO = 'OTROS'
      AND ID_PRODUCTO      = Cn_IdProducto;

    CURSOR C_GetImpuestoPlan(Cv_TipoImpuesto DB_COMERCIAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    IS
      SELECT ID_IMPUESTO, 
      PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE TIPO_IMPUESTO = Cv_TipoImpuesto;

    CURSOR C_GetPlan(Cn_IdPlan DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
      IS
      SELECT ID_PLAN,
      IVA 
      FROM DB_COMERCIAL.INFO_PLAN_CAB
      WHERE ID_PLAN = Cn_IdPlan;

    CURSOR C_Getimpuesto (Cn_IdImpuesto DB_COMERCIAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE )
    IS
      SELECT ID_IMPUESTO,
      PORCENTAJE_IMPUESTO
      FROM DB_COMERCIAL.ADMI_IMPUESTO
      WHERE ID_IMPUESTO = Cn_IdImpuesto;

    CURSOR C_GetNotaCreditoNoActiva(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT 'TRUE' TIENE_NC_PENDIENTE_APROBADA, ESTADO_IMPRESION_FACT
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      WHERE
      IDFC.TIPO_DOCUMENTO_ID           = ATDF.ID_TIPO_DOCUMENTO
      AND ATDF.ESTADO                  = 'Activo'
      AND ATDF.CODIGO_TIPO_DOCUMENTO   IN ('NC','NCI')
      AND IDFC.ESTADO_IMPRESION_FACT   IN ('Pendiente', 'Aprobada')
      AND IDFC.REFERENCIA_DOCUMENTO_ID = Cn_IdDocumento;

    CURSOR C_GetImpuestoDetalle (Cn_DetalleDocId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.DETALLE_DOC_ID%TYPE)
    IS
      SELECT ID_DOC_IMP,
      DETALLE_DOC_ID,
      IMPUESTO_ID,
      VALOR_IMPUESTO,
      PORCENTAJE,
      FE_CREACION,
      FE_ULT_MOD,
      USR_CREACION,
      USR_ULT_MOD
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP
      WHERE DETALLE_DOC_ID = Cn_DetalleDocId;

    CURSOR C_GetDocumentoHistorial (Cv_Observacion DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE,
                                    Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE
                                   ) 
    IS
    SELECT ID_DOCUMENTO_HISTORIAL
    FROM DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL 
    WHERE DOCUMENTO_ID = Cn_IdDocumento
    AND OBSERVACION    LIKE Cv_Observacion;

    CURSOR C_GetInfoDocFinancieroDet(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT 
      ID_DOC_DETALLE, DOCUMENTO_ID, PLAN_ID,
      PUNTO_ID, CANTIDAD, PRECIO_VENTA_FACPRO_DETALLE,
      PORCETANJE_DESCUENTO_FACPRO, DESCUENTO_FACPRO_DETALLE, VALOR_FACPRO_DETALLE,
      COSTO_FACPRO_DETALLE, OBSERVACIONES_FACTURA_DETALLE, FE_CREACION,
      FE_ULT_MOD, USR_CREACION, USR_ULT_MOD,
      EMPRESA_ID, OFICINA_ID, PRODUCTO_ID, MOTIVO_ID,
      PAGO_DET_ID, SERVICIO_ID, FRECUENCIA_PRODUCTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET
      WHERE DOCUMENTO_ID = Cn_IdDocumento;

    CURSOR C_GetAdmiImpuesto(Cn_IdImpuesto DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE, 
                             Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    IS 
      SELECT ID_IMPUESTO,
      PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE ID_IMPUESTO     = NVL(Cn_IdImpuesto, ID_IMPUESTO)
      AND TIPO_IMPUESTO     = NVL(Cv_TipoImpuesto, TIPO_IMPUESTO);

    Lb_TieneNcPendAprob             BOOLEAN:=FALSE;
    Ln_SumaSubtotal                 NUMBER := 0;
    Ln_SumaDescuento                NUMBER := 0;
    Ln_SumaImpuesto                 NUMBER := 0;    
    Ln_ValorProrrateo               NUMBER := 0;
    Ln_ValorNcSimulado              NUMBER := 0;
    Ln_IdDocumento                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Lv_NumeroFacturaSri             DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
    Lv_NumeroFacturaSriNci          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
    Ln_IdDocDetalle                 DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE;
    Ln_IdDocImp                     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.ID_DOC_IMP%TYPE;
    Lr_InfoDocumentoFinanCab        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocumentoFinancieroCab   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocumentoFinanDet        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
    Lr_InfoDocumentoFinanImp        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP%ROWTYPE;
    Lr_InfoDocumentoFinanHst        DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;    
    Lc_Plan                         C_GetPlan%ROWTYPE;
    Lc_ImpuestoPlan                 C_GetImpuestoPlan%ROWTYPE;    
    Lc_Impuesto                     C_Getimpuesto%ROWTYPE;
    Lc_GetNotaCreditoNoActiva       C_GetNotaCreditoNoActiva%ROWTYPE;
    Lc_NombreTecnico                C_GetNombreTecnico%ROWTYPE;    
    Lv_EstadoDocumento              VARCHAR2(100);
    Ln_SaldoPorFactura              NUMBER:=0;   
    Ln_Porcentaje                   NUMBER:=0;  
    Ln_SubtotalDetConImpuestoNc     NUMBER:=0;  
    Ln_SubtotalDetConImpuestoFac    NUMBER:=0;  
    Ln_SumDetalleSaldoNc            NUMBER:=0; 
    Ln_ValorDetalleImpuestoFac      NUMBER:=0;   
    Ln_IdOficina                    DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE:=59;
    Lv_EstadoImpresionFact          DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE;
    --
    Lex_Exception                   EXCEPTION;
    Lv_MsnError                     VARCHAR2 (2000);
    Lv_IpCreacion                   VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lr_AdmiTipoDocFinanciero        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
    Lc_GetAdmiImpuesto              C_GetAdmiImpuesto%ROWTYPE;
    Ln_SubTotalFac                  NUMBER:=0;
    Ln_SubTotal                     NUMBER := 0;
    Ln_Descuento                    NUMBER := 0;
    --
  BEGIN
    --
    --
    IF C_GetNombreTecnico%ISOPEN THEN 
      CLOSE C_GetNombreTecnico;     
    END IF;
    IF C_Getimpuesto%ISOPEN THEN
      CLOSE C_Getimpuesto;
    END IF;
    IF C_GetPlan%ISOPEN THEN
      CLOSE C_GetPlan;
    END IF;
    IF C_GetImpuestoPlan%ISOPEN THEN
      CLOSE C_GetImpuestoPlan;
    END IF;
    IF C_GetImpuestoDetalle%ISOPEN THEN          
      CLOSE C_GetImpuestoDetalle;          
    END IF; 
    IF C_GetAdmiImpuesto%ISOPEN THEN            
      CLOSE C_GetAdmiImpuesto;            
    END IF;
    --
    --
    IF Pn_IdDocumento IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --
    Pbool_Done    := FALSE;
    --   
    --Busca la cabecera de la factura
    Lr_InfoDocumentoFinanCab := DB_FINANCIERO.FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Pn_IdDocumento, NULL);
    --Seteo datos de la Factura.
    Ln_IdDocumento                                   := Lr_InfoDocumentoFinanCab.ID_DOCUMENTO;
    Lv_NumeroFacturaSri                              := Lr_InfoDocumentoFinanCab.NUMERO_FACTURA_SRI;
    Lv_EstadoImpresionFact                           := Lr_InfoDocumentoFinanCab.ESTADO_IMPRESION_FACT; 
    --
    --Obtengo el saldo pendiente de la Factura
      Ln_SaldoPorFactura := NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(Pn_IdDocumento, 
                                                                                            TO_CHAR(SYSDATE,'DD-MM-RRRR'), 'saldo'),2),0 );
    --
    --Genero NCI por Pago Diferido si la Factura posee saldo pendiente mayor al m�nimo permitido parametrizado para el proceso.
    IF Ln_SaldoPorFactura>Pn_ValorFactura THEN
      --
      IF C_GetNotaCreditoNoActiva%ISOPEN THEN        
        CLOSE C_GetNotaCreditoNoActiva;        
      END IF;

      --Obtiene NC o NCI en estado Pendiente o Aprobada
      OPEN C_GetNotaCreditoNoActiva(Pn_IdDocumento);
      --
      FETCH C_GetNotaCreditoNoActiva INTO Lc_GetNotaCreditoNoActiva;
      --
      CLOSE C_GetNotaCreditoNoActiva;
      --Si no tiene NC O NCI en estado Pendiente o Aprobada puede generar la NCI por Proceso de Diferido.
      IF Lc_GetNotaCreditoNoActiva.TIENE_NC_PENDIENTE_APROBADA IS NULL THEN        
        --
        --Obtengo el % del saldo pendiente de la Factura sobre el cual se generar� la NCI
        Ln_Porcentaje := FNCK_PAGOS_DIFERIDOS.F_GET_PORCENTAJE_SALDO(Pn_IdDocumento);
        --
        --Obtengo Valor total simulado de la NCI.
        Ln_ValorNcSimulado := FNCK_PAGOS_DIFERIDOS.F_GET_VALOR_SIMULADO_NCI(Pn_IdDocumento,
                                                                            Ln_Porcentaje);
        -- 
        IF (ROUND(Ln_ValorNcSimulado,2) = Ln_SaldoPorFactura) THEN
          --
          --Permite realizar NC por % del saldo disponible de la Factura
          Ln_ValorProrrateo := (NVL(Ln_Porcentaje, 0) / 100); 
          --
          Lr_AdmiTipoDocFinanciero:= NULL;
          --Obtiene le tipo de documento NCI
          Lr_AdmiTipoDocFinanciero := DB_FINANCIERO.FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(NULL, 'NCI');
          --
          --
          --Genero Cabecera de NCI
          Lr_InfoDocumentoFinanCab.ID_DOCUMENTO            := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
          Pn_IdDocumentoNC                                 := Lr_InfoDocumentoFinanCab.ID_DOCUMENTO;
          Lr_InfoDocumentoFinanCab.TIPO_DOCUMENTO_ID       := Lr_AdmiTipoDocFinanciero.ID_TIPO_DOCUMENTO;
          Lr_InfoDocumentoFinanCab.REFERENCIA_DOCUMENTO_ID := Ln_IdDocumento;
          Lr_InfoDocumentoFinanCab.FE_CREACION             := SYSDATE;
          Lr_InfoDocumentoFinanCab.USR_CREACION            := Pv_UsrCreacion;
          Lr_InfoDocumentoFinanCab.FE_EMISION              := SYSDATE;
          Lr_InfoDocumentoFinanCab.FE_AUTORIZACION         := NULL;
          Lr_InfoDocumentoFinanCab.NUMERO_FACTURA_SRI      := NULL;
          Lr_InfoDocumentoFinanCab.NUMERO_AUTORIZACION     := NULL;
          Lr_InfoDocumentoFinanCab.MES_CONSUMO             := NULL;
          Lr_InfoDocumentoFinanCab.ANIO_CONSUMO            := NULL;
          Lr_InfoDocumentoFinanCab.ESTADO_IMPRESION_FACT   := 'Pendiente';
          Lr_InfoDocumentoFinanCab.OBSERVACION             := Pv_Observacion || ' Aplicada a la factura # '|| Lv_NumeroFacturaSri;
          Lr_InfoDocumentoFinanCab.SUBTOTAL_CERO_IMPUESTO  := 0;
          Lr_InfoDocumentoFinanCab.ENTREGO_RETENCION_FTE   := NULL;
          Lr_InfoDocumentoFinanCab.ES_AUTOMATICA           := 'S';
          Lr_InfoDocumentoFinanCab.PRORRATEO               := 'N';
          Lr_InfoDocumentoFinanCab.REACTIVACION            := 'N';
          Lr_InfoDocumentoFinanCab.RECURRENTE              := 'N';
          Lr_InfoDocumentoFinanCab.COMISIONA               := 'N';
          Lr_InfoDocumentoFinanCab.SUBTOTAL_ICE            := 0;
          Lr_InfoDocumentoFinanCab.NUM_FACT_MIGRACION      := NULL;
          Lr_InfoDocumentoFinanCab.ES_ELECTRONICA          := 'N';
          Lr_InfoDocumentoFinanCab.NUMERO_AUTORIZACION     := NULL;
          Lr_InfoDocumentoFinanCab.FE_AUTORIZACION         := NULL;
          Lr_InfoDocumentoFinanCab.CONTABILIZADO           := NULL;
          --Inserta la cabecera de la NC
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinanCab, Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN            
            RAISE Lex_Exception;            
          END IF;

          --Busca los detalles de la factura, para crear los detalles de la NC
          --
          FOR Lr_InfoDocumentoFinanDet IN C_GetInfoDocFinancieroDet(Ln_IdDocumento)
          LOOP
            Ln_SubtotalDetConImpuestoNc  := 0;
            Ln_SubtotalDetConImpuestoFac := 0;
            Ln_SumDetalleSaldoNc         := 0;
            Ln_ValorDetalleImpuestoFac   := 0;
            Ln_SubTotalFac               := 0;  
            Ln_SubTotal                  := 0;
            Ln_Descuento                 := 0;     
            --
            Ln_SubTotalFac  := ROUND(((NVL(Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(Lr_InfoDocumentoFinanDet.CANTIDAD, 0)) - NVL(Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE, 0)),2);
            --

            IF Lr_InfoDocumentoFinanDet.PLAN_ID IS NOT NULL AND Lr_InfoDocumentoFinanDet.PLAN_ID  <> 0 THEN
              --
              IF C_GetPlan%ISOPEN THEN        
                CLOSE C_GetPlan;       
              END IF;
              --
              OPEN C_GetPlan(Lr_InfoDocumentoFinanDet.PLAN_ID);
              --
              FETCH C_GetPlan INTO Lc_Plan;
              --
              CLOSE C_GetPlan;
              --
              IF Lc_Plan.IVA = 'S' THEN
                --                
                OPEN C_GetAdmiImpuesto(NULL, 'IVA');
                --
                FETCH C_GetAdmiImpuesto INTO Lc_GetAdmiImpuesto;
                --
                CLOSE C_GetAdmiImpuesto;
                --            
                Ln_ValorDetalleImpuestoFac := ROUND(((Ln_SubTotalFac * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100),4);
                --
              END IF; 
              --
            END IF;
            --
            --Pregunta que sea producto
            IF Lr_InfoDocumentoFinanDet.PRODUCTO_ID IS NOT NULL AND Lr_InfoDocumentoFinanDet.PRODUCTO_ID  <> 0 THEN
              --Si es un producto itera los impuestos relacionados a este producto
              FOR Lr_GetImpuestoDetalle IN C_GetImpuestoDetalle(Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE)
                LOOP
                --
                IF C_GetAdmiImpuesto%ISOPEN THEN            
                  CLOSE C_GetAdmiImpuesto;            
                END IF;
                --
                OPEN C_GetAdmiImpuesto(Lr_GetImpuestoDetalle.IMPUESTO_ID, NULL);
                --
                FETCH C_GetAdmiImpuesto INTO Lc_GetAdmiImpuesto;
                --
                CLOSE C_GetAdmiImpuesto;
                --            
                Ln_ValorDetalleImpuestoFac := Ln_ValorDetalleImpuestoFac +ROUND(((Ln_SubTotalFac * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100),4);
                --
              END LOOP; 
              --
            END IF;           
            --
            --
            --Obtengo el Saldo por detalle de Factura al cual puede aplicarse NCI
             Ln_SubtotalDetConImpuestoFac := (Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE*Lr_InfoDocumentoFinanDet.CANTIDAD)-Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE+Ln_ValorDetalleImpuestoFac;
            --   
            Ln_SubtotalDetConImpuestoNc:= FNCK_PAGOS_DIFERIDOS.F_GET_SUM_DETALLES_NCI(Pn_IdDocumento,Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE); 
            --
            Ln_SumDetalleSaldoNc :=Ln_SubtotalDetConImpuestoFac-Ln_SubtotalDetConImpuestoNc;     
            --
            IF Ln_SumDetalleSaldoNc <=0 THEN
              CONTINUE;
            END IF;  
            --
            Ln_IdDocDetalle                                        := Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE;
            Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE                := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
            Lr_InfoDocumentoFinanDet.DOCUMENTO_ID                  := Lr_InfoDocumentoFinanCab.ID_DOCUMENTO;
            Lr_InfoDocumentoFinanDet.PORCETANJE_DESCUENTO_FACPRO   := 0;
            Lr_InfoDocumentoFinanDet.VALOR_FACPRO_DETALLE          := 0;
            Lr_InfoDocumentoFinanDet.COSTO_FACPRO_DETALLE          := 0;
            Lr_InfoDocumentoFinanDet.OBSERVACIONES_FACTURA_DETALLE := NULL;
            Lr_InfoDocumentoFinanDet.FE_CREACION                   := SYSDATE;
            Lr_InfoDocumentoFinanDet.FE_ULT_MOD                    := NULL;
            Lr_InfoDocumentoFinanDet.USR_ULT_MOD                   := NULL;
            Lr_InfoDocumentoFinanDet.MOTIVO_ID                     := Pn_IdMotivo;
            Lr_InfoDocumentoFinanDet.PAGO_DET_ID                   := NULL;
            Lr_InfoDocumentoFinanDet.USR_CREACION                  := Pv_UsrCreacion;
            Lr_InfoDocumentoFinanDet.OFICINA_ID                    := Ln_IdOficina;
            Lr_InfoDocumentoFinanDet.EMPRESA_ID                    := Pv_IdEmpresa;
            --             
            Ln_SubTotal      := ROUND((NVL(Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE, 0) * Ln_ValorProrrateo), 4);
            Ln_SumaSubtotal  := Ln_SumaSubtotal + (Ln_SubTotal * Lr_InfoDocumentoFinanDet.CANTIDAD);
            Ln_Descuento     := ROUND((NVL(Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE, 0) * Ln_ValorProrrateo), 4); 
            Ln_SubTotal      := ROUND(((Ln_SubTotal * NVL(Lr_InfoDocumentoFinanDet.CANTIDAD, 0)) - Ln_Descuento),4);
            Ln_SumaDescuento := Ln_SumaDescuento + Ln_Descuento;                                      
            --
            Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE:=ROUND((Lr_InfoDocumentoFinanDet.PRECIO_VENTA_FACPRO_DETALLE*Ln_ValorProrrateo), 2);
            Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE:=ROUND((Lr_InfoDocumentoFinanDet.DESCUENTO_FACPRO_DETALLE*Ln_ValorProrrateo) , 2);
            --
            --Inserta un registro al detalle de la NC
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinanDet, Lv_MsnError);

            IF Lv_MsnError IS NOT NULL THEN              
              RAISE Lex_Exception;              
            END IF;

            --Pregunta si el registro es un producto
            IF Lr_InfoDocumentoFinanDet.PRODUCTO_ID IS NOT NULL AND Lr_InfoDocumentoFinanDet.PRODUCTO_ID  <> 0 THEN
              --             
              FOR Lr_InfoDocumentoFinanImp IN C_GetImpuestoDetalle(Ln_IdDocDetalle)
              LOOP                 
                --
                OPEN C_Getimpuesto (Lr_InfoDocumentoFinanImp.IMPUESTO_ID);
                --
                FETCH C_Getimpuesto INTO Lc_Impuesto;
                --
                CLOSE C_Getimpuesto;
                --
                Ln_IdDocImp                               := Lr_InfoDocumentoFinanImp.ID_DOC_IMP;
                Lr_InfoDocumentoFinanImp.ID_DOC_IMP       := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
                Lr_InfoDocumentoFinanImp.DETALLE_DOC_ID   := Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE;
                Lr_InfoDocumentoFinanImp.IMPUESTO_ID      := Lc_Impuesto.ID_IMPUESTO ;
                Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO   := ROUND(((Ln_SubTotal * Lc_Impuesto.PORCENTAJE_IMPUESTO) / 100), 4);
                Lr_InfoDocumentoFinanImp.PORCENTAJE       := Lc_Impuesto.PORCENTAJE_IMPUESTO;
                Lr_InfoDocumentoFinanImp.FE_CREACION      := SYSDATE;
                Lr_InfoDocumentoFinanImp.FE_ULT_MOD       := NULL;
                Lr_InfoDocumentoFinanImp.USR_CREACION     := Pv_UsrCreacion;
                Lr_InfoDocumentoFinanImp.USR_ULT_MOD      := NULL;
                Ln_SumaImpuesto                           := Ln_SumaImpuesto + Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO;
                --
                DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinanImp, Lv_MsnError);
                --
                IF Lv_MsnError IS NOT NULL THEN                  
                  RAISE Lex_Exception;                
                END IF;

              END LOOP; --Fin Lr_InfoDocumentoFinanImp
              --
            ELSE -- IF PLAN
              --Entra cuando el registro del detalle sea un Plan
              --              
              --
              OPEN C_GetPlan(Lr_InfoDocumentoFinanDet.PLAN_ID);
              --
              FETCH C_GetPlan INTO Lc_Plan;
              --
              CLOSE C_GetPlan;
              --              
              IF Lc_Plan.IVA = 'S' THEN                               
                --
                OPEN C_GetImpuestoPlan('IVA');
                --
                FETCH C_GetImpuestoPlan INTO Lc_ImpuestoPlan;
                --
                CLOSE C_GetImpuestoPlan;
                --
                Lr_InfoDocumentoFinanImp.ID_DOC_IMP       := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_IMP.NEXTVAL;
                Lr_InfoDocumentoFinanImp.DETALLE_DOC_ID   := Lr_InfoDocumentoFinanDet.ID_DOC_DETALLE;
                Lr_InfoDocumentoFinanImp.IMPUESTO_ID      := Lc_ImpuestoPlan.ID_IMPUESTO ;
                Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO   := ROUND(((Ln_SubTotal * Lc_ImpuestoPlan.PORCENTAJE_IMPUESTO) / 100), 4);
                Lr_InfoDocumentoFinanImp.PORCENTAJE       := Lc_ImpuestoPlan.PORCENTAJE_IMPUESTO;
                Lr_InfoDocumentoFinanImp.FE_CREACION      := SYSDATE;
                Lr_InfoDocumentoFinanImp.FE_ULT_MOD       := NULL;
                Lr_InfoDocumentoFinanImp.USR_CREACION     := Pv_UsrCreacion;
                Lr_InfoDocumentoFinanImp.USR_ULT_MOD      := NULL;
                Ln_SumaImpuesto                           := Ln_SumaImpuesto + Lr_InfoDocumentoFinanImp.VALOR_IMPUESTO;
                --
                DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_IMP(Lr_InfoDocumentoFinanImp, Lv_MsnError);
                --                
                --
              END IF; --Lc_Plan.IVA
              --
              IF Lv_MsnError IS NOT NULL THEN                    
                RAISE Lex_Exception;                  
              END IF;

            END IF; --Lr_InfoDocumentoFinanDet.PRODUCTO_ID IS NOT NULL AND Lr_InfoDocumentoFinanDet.PRODUCTO_ID  <> 0
            --
          END LOOP; --Lr_InfoDocumentoFinanDet 
          --
          --
          Lr_InfoDocumentoFinanCab.SUBTOTAL              := ROUND(Ln_SumaSubtotal, 2);
          Lr_InfoDocumentoFinanCab.SUBTOTAL_CON_IMPUESTO := ROUND(Ln_SumaImpuesto, 2);
          Lr_InfoDocumentoFinanCab.SUBTOTAL_DESCUENTO    := ROUND(Ln_SumaDescuento, 2);
          Lr_InfoDocumentoFinanCab.VALOR_TOTAL           := ROUND(((Ln_SumaSubtotal - Ln_SumaDescuento) + Ln_SumaImpuesto), 2);
          --
          --Actualiza el los valores totales de la cabecera
          DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinanCab.ID_DOCUMENTO, Lr_InfoDocumentoFinanCab, Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
          --Historial de la NCI generada.
          --
          Pv_ObservacionCreacion := Pv_Observacion || 'Aplicada a la factura # '|| Lv_NumeroFacturaSri;
          Pbool_Done             := TRUE;  
          Lr_InfoDocumentoFinanHst:=NULL;
          Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
          Lr_InfoDocumentoFinanHst.DOCUMENTO_ID           := Pn_IdDocumentoNC;
          Lr_InfoDocumentoFinanHst.MOTIVO_ID              := Pn_IdMotivo;
          Lr_InfoDocumentoFinanHst.FE_CREACION            := SYSDATE;
          Lr_InfoDocumentoFinanHst.USR_CREACION           := Pv_UsrCreacion;
          Lr_InfoDocumentoFinanHst.ESTADO                 := 'Pendiente';
          Lr_InfoDocumentoFinanHst.OBSERVACION            := Pv_ObservacionCreacion;
          --
          DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinanHst, Lv_MsnError);
          --
          IF Lv_MsnError IS NOT NULL THEN
            --
            RAISE Lex_Exception;
            --
          END IF;                                   
          --        
        ELSE --ELSE Ln_ValorNcSimulado <= Ln_SaldoPorFactura
          --
          Pv_ObservacionCreacion := 'No se pudo crear la NCI por proceso de Pagos Diferidos, el valor total para la nueva nota de credito interna ($'
                                    || Ln_ValorNcSimulado || ') no corresponde al saldo disponible ($' || Ln_SaldoPorFactura || ')';

        END IF; --Ln_ValorNcSimulado <= Ln_SaldoPorFactura
        --
      ELSE --Lc_GetNotaCreditoNoActiva
        --
        --Setea el comentario en Lv_EstadoDocumento segun el estado de la NC O NCI
        IF Lc_GetNotaCreditoNoActiva.ESTADO_IMPRESION_FACT = 'Pendiente' THEN
          --
          Lv_EstadoDocumento := 'solicite la aprobacion';
          --
        END IF;
        --
        IF Lc_GetNotaCreditoNoActiva.ESTADO_IMPRESION_FACT = 'Aprobada' THEN
          --
          Lv_EstadoDocumento := 'espere la autorizacion por parte del SRI';
          --
        END IF;
        --
        Lb_TieneNcPendAprob    := TRUE;
        Pv_ObservacionCreacion := 'Esta factura tiene una nota de credito en estado ' || Lc_GetNotaCreditoNoActiva.ESTADO_IMPRESION_FACT
                                 || ', por favor ' || Lv_EstadoDocumento || ' para proceder a la creaci�n de una nueva Nota de Credito Interna'||
                                 ' por proceso de Pagos Diferidos';

      END IF; --Lc_GetNotaCreditoNoActiva
      --
    ELSE --ELSE Ln_SaldoPorFactura>=Pn_ValorFactura
      --
      Pv_ObservacionCreacion := 'No se pudo crear la NCI por proceso de Pagos Diferidos, la Factura no posee saldo pendiente o su saldo es menor '||
                                 'al minimo de ($'|| Pn_ValorFactura ||') permitidos';
      --     
    END IF; -- FIN Ln_SaldoPorFactura>=Pn_ValorFactura
    --
    --Si se gener� con exito la NCI procedo a Numerar y Activar el documento.
    IF ( Pbool_Done ) THEN 
      --
      FNCK_PAGOS_DIFERIDOS.P_NUMERA_NOTA_CREDITO_INTERNA (Pn_IdDocumentoNC,
                                                          Pv_IdEmpresa,
                                                          Ln_IdOficina,
                                                          'Se activa la nota de cr�dito interna generada.',
                                                          Pv_UsrCreacion,
                                                          Lv_NumeroFacturaSriNci,    
                                                          Lv_MsnError);    
      --
      IF Lv_MsnError IS NOT NULL THEN
        --
        RAISE Lex_Exception;
        --
      END IF;
      --
      -- Verifico Saldo de la Factura luego de generar NCI para proceder a cerrarla por Saldo cero.
      --
      Ln_SaldoPorFactura := NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(Pn_IdDocumento, 
                                                                                            TO_CHAR(SYSDATE,'DD-MM-RRRR'), 'saldo'),2),0 );  
      IF Ln_SaldoPorFactura = 0 THEN
        --
        Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO         := Pn_IdDocumento;
        Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:= 'Cerrado';

        --Se cierra Factura
        DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,
                                                                      Lr_InfoDocumentoFinancieroCab,
                                                                      Lv_MsnError);
        IF Lv_MsnError IS NOT NULL THEN
          RAISE Lex_Exception;
        END IF;
        --Se guarda Historial en la Factura por cierre.
        Lr_InfoDocumentoFinanHst:=NULL;
        Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoFinanHst.DOCUMENTO_ID           := Pn_IdDocumento;
        Lr_InfoDocumentoFinanHst.MOTIVO_ID              := Pn_IdMotivo;
        Lr_InfoDocumentoFinanHst.FE_CREACION            := SYSDATE;
        Lr_InfoDocumentoFinanHst.USR_CREACION           := Pv_UsrCreacion;
        Lr_InfoDocumentoFinanHst.ESTADO                 := 'Cerrado';
        Lr_InfoDocumentoFinanHst.OBSERVACION            := 'La factura se cerr� por la nota de cr�dito interna #'||Lv_NumeroFacturaSriNci ||
                                                           ' generada por Proceso de Pagos Diferidos';
        --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinanHst, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;    
        --
      END IF; --FIN Ln_SaldoPorFactura = 0
      --
    ELSIF (NOT Pbool_Done AND Pv_ObservacionCreacion IS NOT NULL) THEN
      --
      -- Si no se gener� NCI y tengo mensaje de observaci�n registro Historial en la Factura indicando que no se gener� NCI.
      --
      Lr_InfoDocumentoFinanHst  := NULL;
      OPEN  C_GetDocumentoHistorial(Cv_Observacion => Pv_ObservacionCreacion,
                                    Cn_IdDocumento => Pn_IdDocumento);
      FETCH C_GetDocumentoHistorial INTO Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL;
      CLOSE C_GetDocumentoHistorial;
      --
      IF NVL(Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL, 0) = 0 THEN
        --
        Lr_InfoDocumentoFinanHst:=NULL;
        Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL := SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoFinanHst.DOCUMENTO_ID           := Pn_IdDocumento;
        Lr_InfoDocumentoFinanHst.MOTIVO_ID              := Pn_IdMotivo;
        Lr_InfoDocumentoFinanHst.FE_CREACION            := SYSDATE;
        Lr_InfoDocumentoFinanHst.USR_CREACION           := Pv_UsrCreacion;
        Lr_InfoDocumentoFinanHst.ESTADO                 := Lv_EstadoImpresionFact;
        Lr_InfoDocumentoFinanHst.OBSERVACION            := Pv_ObservacionCreacion;
        --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinanHst, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Lex_Exception;
          --
        END IF;  
        --           
      END IF; --Fin Lr_InfoDocumentoFinanHst

      -- Pbool_Done = FALSE AND Pv_ObservacionCreacion IS NOT NULL no se genera NCI y la solicitud pasa a estado Fallo.
      -- Si la Factura tiene NC o NCI Pendiente de Aprobaci�n o de Autorizaci�n del SRI no se procesa la Solicitud de Pagos Diferidos
      -- la Solicitud se mantiene Pendiente hasta que se Activen las NC que est�n en flujo.
      IF Lb_TieneNcPendAprob THEN
        --
        Pv_ObservacionCreacion := NULL;
        --
      END IF;
      --                        
    END IF;--Fin Pbool_Done       
    --
  EXCEPTION
    WHEN Lex_Exception THEN
      --
      Pv_MessageError := Lv_MsnError || ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                         || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_CREA_NOTA_CREDITO_INTERNA', 
                                           'Error al crear NCI - #Factura: ' || Pn_IdDocumento || ' - ' || Lv_MsnError || ' - ' 
                                           || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );            
      --
    WHEN OTHERS THEN
      --
      Pv_MessageError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_CREA_NOTA_CREDITO_INTERNA', 
                                           'Error al crear NCI  - #Factura: ' || Pn_IdDocumento || ' -  ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );         
      --
  END P_CREA_NOTA_CREDITO_INTERNA;
  --
  --
  --
  PROCEDURE P_CREA_NOTA_DEBITO_INTERNA(Pn_IdPunto                IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE, 
                                       Pn_ValorTotal             IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE, 
                                       Pv_IdEmpresa              IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_Observacion            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.OBSERVACION%TYPE,
                                       Pn_IdMotivo               IN  ADMI_MOTIVO.ID_MOTIVO%TYPE,
                                       Pv_UsrCreacion            IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                       Pn_IdDocumentoNdi         OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                       Pbool_Done                OUT BOOLEAN,
                                       Pv_MessageError           OUT VARCHAR2)
  IS  
    CURSOR C_GetNumeracion (Cv_Codigo          DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE,
                            Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                            Cn_IdOficina       DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                            Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT ID_NUMERACION,EMPRESA_ID, OFICINA_ID,
      DESCRIPCION, CODIGO, NUMERACION_UNO,
      NUMERACION_DOS, SECUENCIA, FE_CREACION, USR_CREACION,
      FE_ULT_MOD, USR_ULT_MOD, TABLA,
      ESTADO, NUMERO_AUTORIZACION, PROCESOS_AUTOMATICOS,TIPO_ID 
      FROM DB_COMERCIAL.ADMI_NUMERACION
      WHERE CODIGO     = Cv_Codigo
      AND EMPRESA_ID   = Cv_CodEmpresa
      AND ESTADO       = Cv_Estado
      AND OFICINA_ID   = Cn_IdOficina;

    --
    Lr_AdmiTipoDocFinanciero      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO%ROWTYPE;
    Lr_InfoDocumentoFinCabNdi     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocumentoFinDetNdi     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;
    Lr_InfoDocumentoFinanHst      DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;      
    Lc_GetNumeracion              C_GetNumeracion%ROWTYPE;    
    Lv_Secuencia                  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;  
    Lv_NumeroFacturaSriNdi        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;    
    --
    Lex_Exception                 EXCEPTION;
    Lv_MsnError                   VARCHAR2 (2000);
    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo               VARCHAR2(20):='Activo';  
    Ln_IdOficina                  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE:=59;
    -- 
  BEGIN
    IF C_GetNumeracion%ISOPEN THEN          
      CLOSE C_GetNumeracion;          
    END IF;
    --
    IF Pn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --
    Pbool_Done    := FALSE;
    --       
    --Obtiene la numeracion para la NDI
    OPEN C_GetNumeracion('NDI', Lv_EstadoActivo, Ln_IdOficina, Pv_IdEmpresa);
    --
    FETCH C_GetNumeracion INTO Lc_GetNumeracion;
    IF C_GetNumeracion%NOTFOUND THEN
      Lv_MsnError := 'No existe numeraci�n para la Nota de D�bito Interna, oficina #'||Ln_IdOficina;
      RAISE Lex_Exception;
    END IF;    
    --
    Lv_Secuencia := LPAD(Lc_GetNumeracion.SECUENCIA,9,'0');
    Lv_NumeroFacturaSriNdi:= Lc_GetNumeracion.NUMERACION_UNO || '-'||Lc_GetNumeracion.NUMERACION_DOS||'-'||Lv_Secuencia;
    --
    CLOSE C_GetNumeracion;
    --    
    --Se incrementa la numeraci�n
    Lc_GetNumeracion.SECUENCIA:=Lc_GetNumeracion.SECUENCIA+1;
    DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lc_GetNumeracion.ID_NUMERACION,Lc_GetNumeracion,Lv_MsnError);
    IF Lv_MsnError IS NOT NULL THEN
      RAISE Lex_Exception;
    END IF;
    --
    Lr_AdmiTipoDocFinanciero:= NULL;
    --Obtiene le tipo de documento NDI
    Lr_AdmiTipoDocFinanciero := DB_FINANCIERO.FNCK_CONSULTS.F_GET_TIPO_DOC_FINANCIERO(NULL, 'NDI');
    --
    Lr_InfoDocumentoFinCabNdi                          := NULL;
    Lr_InfoDocumentoFinCabNdi.ID_DOCUMENTO             := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_CAB.NEXTVAL;
    Pn_IdDocumentoNdi                                  := Lr_InfoDocumentoFinCabNdi.ID_DOCUMENTO;
    Lr_InfoDocumentoFinCabNdi.OFICINA_ID               := Ln_IdOficina;
    Lr_InfoDocumentoFinCabNdi.PUNTO_ID                 := Pn_IdPunto ;
    Lr_InfoDocumentoFinCabNdi.TIPO_DOCUMENTO_ID        := Lr_AdmiTipoDocFinanciero.ID_TIPO_DOCUMENTO ;
    Lr_InfoDocumentoFinCabNdi.NUMERO_FACTURA_SRI       := TRIM(Lv_NumeroFacturaSriNdi);
    Lr_InfoDocumentoFinCabNdi.SUBTOTAL                 := Pn_ValorTotal;
    Lr_InfoDocumentoFinCabNdi.SUBTOTAL_CERO_IMPUESTO   := 0;
    Lr_InfoDocumentoFinCabNdi.SUBTOTAL_CON_IMPUESTO    := 0;
    Lr_InfoDocumentoFinCabNdi.SUBTOTAL_DESCUENTO       := 0;
    Lr_InfoDocumentoFinCabNdi.VALOR_TOTAL              := Pn_ValorTotal;
    Lr_InfoDocumentoFinCabNdi.ENTREGO_RETENCION_FTE    := NULL ;
    Lr_InfoDocumentoFinCabNdi.ESTADO_IMPRESION_FACT    := Lv_EstadoActivo;
    Lr_InfoDocumentoFinCabNdi.ES_AUTOMATICA            := 'S';
    Lr_InfoDocumentoFinCabNdi.PRORRATEO                := 'N';
    Lr_InfoDocumentoFinCabNdi.REACTIVACION             := 'N';
    Lr_InfoDocumentoFinCabNdi.RECURRENTE               := 'N';
    Lr_InfoDocumentoFinCabNdi.COMISIONA                := 'N';
    Lr_InfoDocumentoFinCabNdi.FE_CREACION              := SYSDATE;
    Lr_InfoDocumentoFinCabNdi.FE_EMISION               := SYSDATE;
    Lr_InfoDocumentoFinCabNdi.USR_CREACION             := Pv_UsrCreacion;
    Lr_InfoDocumentoFinCabNdi.SUBTOTAL_ICE             := 0;
    Lr_InfoDocumentoFinCabNdi.NUM_FACT_MIGRACION       := NULL;
    Lr_InfoDocumentoFinCabNdi.OBSERVACION              := Pv_Observacion;
    Lr_InfoDocumentoFinCabNdi.REFERENCIA_DOCUMENTO_ID  := NULL;
    Lr_InfoDocumentoFinCabNdi.LOGIN_MD                 := NULL;
    Lr_InfoDocumentoFinCabNdi.ES_ELECTRONICA           := 'N';
    Lr_InfoDocumentoFinCabNdi.NUMERO_AUTORIZACION      := NULL;
    Lr_InfoDocumentoFinCabNdi.FE_AUTORIZACION          := NULL;
    Lr_InfoDocumentoFinCabNdi.CONTABILIZADO            := NULL;
    --Crea la cabecera de la nota de Debito
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_CAB( Lr_InfoDocumentoFinCabNdi, Lv_MsnError);
    --
    IF Lv_MsnError IS NOT NULL THEN
      --
      RAISE Lex_Exception;
      --
    END IF;
    --
    Lr_InfoDocumentoFinDetNdi.ID_DOC_DETALLE                := DB_FINANCIERO.SEQ_INFO_DOC_FINANCIERO_DET.NEXTVAL;
    Lr_InfoDocumentoFinDetNdi.DOCUMENTO_ID                  := Lr_InfoDocumentoFinCabNdi.ID_DOCUMENTO;
    Lr_InfoDocumentoFinDetNdi.PLAN_ID                       := NULL;
    Lr_InfoDocumentoFinDetNdi.PUNTO_ID                      := Lr_InfoDocumentoFinCabNdi.PUNTO_ID;
    Lr_InfoDocumentoFinDetNdi.CANTIDAD                      := 1;
    Lr_InfoDocumentoFinDetNdi.PRECIO_VENTA_FACPRO_DETALLE   := Pn_ValorTotal;
    Lr_InfoDocumentoFinDetNdi.PORCETANJE_DESCUENTO_FACPRO   := 0;
    Lr_InfoDocumentoFinDetNdi.DESCUENTO_FACPRO_DETALLE      := 0;
    Lr_InfoDocumentoFinDetNdi.VALOR_FACPRO_DETALLE          := 0;
    Lr_InfoDocumentoFinDetNdi.COSTO_FACPRO_DETALLE          := 0;
    Lr_InfoDocumentoFinDetNdi.OBSERVACIONES_FACTURA_DETALLE := Lr_InfoDocumentoFinCabNdi.OBSERVACION;
    Lr_InfoDocumentoFinDetNdi.FE_CREACION                   := SYSDATE;
    Lr_InfoDocumentoFinDetNdi.FE_ULT_MOD                    := NULL;
    Lr_InfoDocumentoFinDetNdi.USR_CREACION                  := Pv_UsrCreacion;
    Lr_InfoDocumentoFinDetNdi.USR_ULT_MOD                   := NULL;
    Lr_InfoDocumentoFinDetNdi.EMPRESA_ID                    := Pv_IdEmpresa;
    Lr_InfoDocumentoFinDetNdi.OFICINA_ID                    := Lr_InfoDocumentoFinCabNdi.OFICINA_ID;
    Lr_InfoDocumentoFinDetNdi.PRODUCTO_ID                   := NULL;
    Lr_InfoDocumentoFinDetNdi.MOTIVO_ID                     := Pn_IdMotivo;
    Lr_InfoDocumentoFinDetNdi.PAGO_DET_ID                   := NULL;
    --Crea el detalle de la nota de D�bito Interna
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinDetNdi, Lv_MsnError);
    --
    IF Lv_MsnError IS NOT NULL THEN
      --
      RAISE Lex_Exception;
      --
    END IF;
    Pbool_Done := TRUE;    
    -- 
  EXCEPTION
    WHEN Lex_Exception THEN
      --
      Pv_MessageError := Lv_MsnError || ' ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: '
                         || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_CREA_NOTA_DEBITO_INTERNA', 
                                           'Error al crear NDI por Proceso de Diferidos - #IDPUNTO: ' || Pn_IdPunto || ' - ' || Lv_MsnError || ' - '
                                           || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );            
      --
    WHEN OTHERS THEN
      --
      Pv_MessageError := 'ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_CREA_NOTA_DEBITO_INTERNA', 
                                           'Error al crear NDI por Proceso de Diferidos - #IDPUNTO: ' || Pn_IdPunto || ' -  '
                                           || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );         
      --
  END P_CREA_NOTA_DEBITO_INTERNA;
  --
  --
  --  
  FUNCTION F_GET_VALOR_CUOTA_DIFERIDA(Fn_IdDocumentoNci    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                      Fn_NumCuotaDiferida  IN  NUMBER,
                                      Fn_MesesDiferido     IN  NUMBER)
  RETURN NUMBER
  IS
    Lr_InfoDocumentoFinanCab      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Ln_ValorTotalNci              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;  
    Ln_ValorCuotaDiferida         NUMBER:=0; 
    --
    Lex_Exception                 EXCEPTION;
    Lv_MsnError                   VARCHAR2 (2000);
    Lv_IpCreacion                 VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo               VARCHAR2(20):='Activo';
    Ln_ValorAjuste                NUMBER:=0;
  BEGIN
    IF Fn_IdDocumentoNci IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    --Busca la cabecera de la NCI por Proceso de Diferidos
    Lr_InfoDocumentoFinanCab := DB_FINANCIERO.FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Fn_IdDocumentoNci, NULL);
    --
    Ln_ValorTotalNci       := Lr_InfoDocumentoFinanCab.VALOR_TOTAL;
    Ln_ValorCuotaDiferida  := ROUND((Ln_ValorTotalNci / Fn_MesesDiferido),2);
    --
    --Si es la �ltima cuota diferida verifico si es necesario hacer ajuste por cuadre.
    IF Fn_NumCuotaDiferida = Fn_MesesDiferido THEN
      --
      Ln_ValorAjuste := Ln_ValorTotalNci - (Ln_ValorCuotaDiferida * Fn_MesesDiferido);
      IF Ln_ValorAjuste <> 0 THEN
        Ln_ValorCuotaDiferida := Ln_ValorCuotaDiferida + (Ln_ValorAjuste);
      END IF;
    END IF;
    --
    --
    RETURN Ln_ValorCuotaDiferida;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener el valor de la cuota diferida #IdDocumentoNci ' ||  Fn_IdDocumentoNci ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_VALOR_CUOTA_DIFERIDA',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN NULL;
      --
  END F_GET_VALOR_CUOTA_DIFERIDA;  
  --
  --
  --
  PROCEDURE P_NUMERA_NOTA_CREDITO_INTERNA (Pn_IdDocumento    IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                           Pv_CodEmpresa     IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pn_IdOficina      IN  DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                                           Pv_ObsHistorial   IN  DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL.OBSERVACION%TYPE,
                                           Pv_UsrCreacion    IN  VARCHAR2,
                                           Pv_Numeracion     OUT DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE,
                                           Pv_Mensaje        OUT VARCHAR2)
  IS
    CURSOR C_GetParamNumeraNci(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                               Cv_Modulo          DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE,
                               Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                               Cn_IdOficina       DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                               Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT PD.* FROM DB_GENERAL.ADMI_PARAMETRO_CAB PC,
      DB_GENERAL.ADMI_PARAMETRO_DET PD
      WHERE PC.ID_PARAMETRO = PD.PARAMETRO_ID
      AND PC.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND PC.MODULO           = Cv_Modulo
      AND PC.ESTADO           = Cv_Estado
      AND PD.ESTADO           = Cv_Estado
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(PD.VALOR1,'^\d+')),0) = Cn_IdOficina
      AND PD.EMPRESA_COD      = Cv_CodEmpresa;

    CURSOR C_GetNumeracionNci (Cv_Codigo          DB_COMERCIAL.ADMI_NUMERACION.CODIGO%TYPE,
                               Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                               Cn_IdOficina       DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE,
                               Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT ID_NUMERACION,EMPRESA_ID, OFICINA_ID,
      DESCRIPCION, CODIGO, NUMERACION_UNO,
      NUMERACION_DOS, SECUENCIA, FE_CREACION, USR_CREACION,
      FE_ULT_MOD, USR_ULT_MOD, TABLA,
      ESTADO, NUMERO_AUTORIZACION, PROCESOS_AUTOMATICOS,TIPO_ID 
      FROM DB_COMERCIAL.ADMI_NUMERACION
      WHERE CODIGO     = Cv_Codigo
      AND EMPRESA_ID   = Cv_CodEmpresa
      AND ESTADO       = Cv_Estado
      AND OFICINA_ID   = Cn_IdOficina;

    Lv_NombreParametro              DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE:= 'NUMERACION_NOTA_CREDITO_INTERNA_MD';
    Lv_Modulo                       DB_GENERAL.ADMI_PARAMETRO_CAB.MODULO%TYPE:= 'FINANCIERO';
    Lv_EstadoActivo                 VARCHAR2(20):= 'Activo';
    Lc_GetParamNumeraNci            C_GetParamNumeraNci%ROWTYPE;
    Lc_GetNumeracionNci             C_GetNumeracionNci%ROWTYPE;       
    Ln_IdOficinaParam               DB_COMERCIAL.INFO_OFICINA_GRUPO.ID_OFICINA%TYPE;    
    Lv_MsnError                     VARCHAR2(1000);
    Lr_InfoDocumentoFinancieroHis   DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE;
    Lr_InfoDocumentoFinancieroCab   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lv_Numeracion                   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
    Lv_Secuencia                    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.NUMERO_FACTURA_SRI%TYPE;
    Lv_EstadoAprobada               VARCHAR2(15) := 'Aprobada';
    Le_Error                        EXCEPTION;
    Lv_IpCreacion                   VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  BEGIN

    IF C_GetParamNumeraNci%ISOPEN THEN          
      CLOSE C_GetParamNumeraNci;          
    END IF;
    IF C_GetNumeracionNci%ISOPEN THEN          
      CLOSE C_GetNumeracionNci;          
    END IF;
    --Consulto en la Tabla de PARAMETROS la numeracion de la NCI.
    OPEN C_GetParamNumeraNci(Lv_NombreParametro, Lv_Modulo, Lv_EstadoActivo, Pn_IdOficina, Pv_CodEmpresa);
    --
    FETCH C_GetParamNumeraNci INTO Lc_GetParamNumeraNci;
    IF C_GetParamNumeraNci%FOUND THEN
      Ln_IdOficinaParam := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_GetParamNumeraNci.VALOR2,'^\d+')),0);
    END IF;
    --
    CLOSE C_GetParamNumeraNci;

    IF Ln_IdOficinaParam IS NULL OR Ln_IdOficinaParam = 0 THEN
      Lv_MsnError := 'No se encontr� par�metro ' || Lv_NombreParametro || ' para definir la numeraci�n de las NCI para la Oficina: ' || Pn_IdOficina;
      RAISE Le_Error;
    END IF;

    --Verifico si se obtiene datos para generar la Numeracion
    OPEN C_GetNumeracionNci('NCI', Lv_EstadoActivo, Ln_IdOficinaParam, Pv_CodEmpresa);
    --
    FETCH C_GetNumeracionNci INTO Lc_GetNumeracionNci;
    IF C_GetNumeracionNci%NOTFOUND THEN
      Lv_MsnError := 'No existe numeraci�n para la Nota de Cr�dito Interna';
      RAISE Le_Error;
    END IF;
    Lv_Secuencia := LPAD(Lc_GetNumeracionNci.SECUENCIA,9,'0');
    Lv_Numeracion:= Lc_GetNumeracionNci.NUMERACION_UNO || '-'||Lc_GetNumeracionNci.NUMERACION_DOS||'-'||Lv_Secuencia;
    --
    CLOSE C_GetNumeracionNci;
    --    
    Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO         := Pn_IdDocumento;
    Lr_InfoDocumentoFinancieroCab.NUMERO_FACTURA_SRI   := Lv_Numeracion;
    Lr_InfoDocumentoFinancieroCab.ESTADO_IMPRESION_FACT:= Lv_EstadoActivo;
    Lr_InfoDocumentoFinancieroCab.FE_EMISION           := TRUNC(SYSDATE);

    --Se actualiza los valores de la cabecera
    DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO,
                                                                  Lr_InfoDocumentoFinancieroCab,
                                                                  Lv_MsnError);
    IF Lv_MsnError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;

    --Se incrementa la numeraci�n
    Lc_GetNumeracionNci.SECUENCIA:=Lc_GetNumeracionNci.SECUENCIA+1;
    DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_ADMI_NUMERACION(Lc_GetNumeracionNci.ID_NUMERACION,Lc_GetNumeracionNci,Lv_MsnError);
    IF Lv_MsnError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    Pv_Numeracion:=Lv_Numeracion; 
    --
    --Se ingresa historial de Aprobaci�n de NCI
    Lr_InfoDocumentoFinancieroHis                       := NULL;
    Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:= DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
    Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
    Lr_InfoDocumentoFinancieroHis.FE_CREACION           := SYSDATE;
    Lr_InfoDocumentoFinancieroHis.USR_CREACION          := Pv_UsrCreacion;
    Lr_InfoDocumentoFinancieroHis.ESTADO                := Lv_EstadoAprobada;
    Lr_InfoDocumentoFinancieroHis.OBSERVACION           := Pv_ObsHistorial;
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Lv_MsnError);
    IF Lv_MsnError IS NOT NULL THEN
        RAISE Le_Error;
    END IF;
    --   
    --Se ingresa historial de Activaci�n de NCI
    Lr_InfoDocumentoFinancieroHis                       := NULL;
    Lr_InfoDocumentoFinancieroHis.ID_DOCUMENTO_HISTORIAL:= DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
    Lr_InfoDocumentoFinancieroHis.DOCUMENTO_ID          := Lr_InfoDocumentoFinancieroCab.ID_DOCUMENTO;
    Lr_InfoDocumentoFinancieroHis.FE_CREACION           := SYSDATE;
    Lr_InfoDocumentoFinancieroHis.USR_CREACION          := Pv_UsrCreacion;
    Lr_InfoDocumentoFinancieroHis.ESTADO                := Lv_EstadoActivo;
    Lr_InfoDocumentoFinancieroHis.OBSERVACION           := Pv_ObsHistorial;
    DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinancieroHis,Lv_MsnError);
    IF Lv_MsnError IS NOT NULL THEN
        RAISE Le_Error;
    END IF;
    --
  EXCEPTION    
    WHEN Le_Error THEN       
      Pv_Mensaje := Lv_MsnError;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_NUMERA_NOTA_CREDITO_INTERNA', 
                                           'Error al numerar la NCI - ' || Lv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );                 
    WHEN OTHERS THEN        
      Pv_Mensaje := 'Error al numerar la NCI - ' || SQLCODE || ' - ERROR_STACK: ' ||
                    DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' ||
                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_NUMERA_NOTA_CREDITO_INTERNA', 
                                           'Error al numerar la NCI - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );  
    --
  END P_NUMERA_NOTA_CREDITO_INTERNA;
  --
  --
  -- 
  FUNCTION F_GET_PORCENTAJE_SALDO(Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_GetInfoDocFinancieroDet(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT ID_DOC_DETALLE,
      PUNTO_ID,
      SERVICIO_ID,
      PLAN_ID,
      PRODUCTO_ID,
      PRECIO_VENTA_FACPRO_DETALLE,
      CANTIDAD,
      DESCUENTO_FACPRO_DETALLE
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET
      WHERE DOCUMENTO_ID = Cn_IdDocumento;

    CURSOR C_GetAdmiProducto(Cn_IdProducto DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE)
    IS
      SELECT ID_PRODUCTO,
      NOMBRE_TECNICO
      FROM DB_COMERCIAL.ADMI_PRODUCTO
      WHERE ID_PRODUCTO = Cn_IdProducto;

    CURSOR C_GetInfoPlanCab(Cn_IdPlan DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    IS
      SELECT ID_PLAN,
      IVA
      FROM DB_COMERCIAL.INFO_PLAN_CAB
      WHERE ID_PLAN = Cn_IdPlan;

    CURSOR C_GetImpuestoDetalle (Cn_DetalleDocId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.DETALLE_DOC_ID%TYPE)
    IS
      SELECT DETALLE_DOC_ID,
      IMPUESTO_ID,
      VALOR_IMPUESTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP
      WHERE DETALLE_DOC_ID = Cn_DetalleDocId;

    CURSOR C_GetAdmiImpuesto(Cn_IdImpuesto DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE, 
                             Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    IS 
      SELECT ID_IMPUESTO,
      PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE ID_IMPUESTO     = NVL(Cn_IdImpuesto, ID_IMPUESTO)
      AND TIPO_IMPUESTO     = NVL(Cv_TipoImpuesto, TIPO_IMPUESTO);

    Lc_GetAdmiProducto             C_GetAdmiProducto%ROWTYPE;
    Lc_GetAdmiImpuesto             C_GetAdmiImpuesto%ROWTYPE;
    Lc_GetInfoPlanCab              C_GetInfoPlanCab%ROWTYPE;
    Ln_SaldoPorFactura             NUMBER:=0;
    Ln_ValorDetalleImpuestoFac     NUMBER:=0;
    Ln_SubtotalDetConImpuestoFac   NUMBER:=0;
    Ln_SubtotalDetConImpuestoNc    NUMBER:=0;
    Ln_SumDetalleSaldoNc           NUMBER:=0;
    Ln_ValorDetalleAplicarNC       NUMBER:=0;
    Ln_Porcentaje                  NUMBER:=0;
    Ln_SubTotalFac                 NUMBER;

  BEGIN
    IF C_GetAdmiProducto%ISOPEN THEN          
      CLOSE C_GetAdmiProducto;          
    END IF;
    IF C_GetImpuestoDetalle%ISOPEN THEN          
      CLOSE C_GetImpuestoDetalle;          
    END IF;  
    --
    --
    Ln_SaldoPorFactura:= NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA( 
                             Fn_IdDocumento, 
                             TO_CHAR(SYSDATE,'DD-MM-RRRR'), 'saldo'),2),0 );
    --
    IF Ln_SaldoPorFactura > 0 THEN   
      --
      --Saco los detalles de la Factura
      FOR I_GetInfoDocFinancieroDet IN C_GetInfoDocFinancieroDet(Fn_IdDocumento)
      LOOP
        Ln_ValorDetalleImpuestoFac   := 0;  
        Ln_SubtotalDetConImpuestoFac := 0;
        Ln_SubtotalDetConImpuestoNc  := 0;
        Ln_SumDetalleSaldoNc         := 0;
        Ln_SubTotalFac               := 0;       
        --
        Ln_SubTotalFac  := ROUND(((NVL(I_GetInfoDocFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(I_GetInfoDocFinancieroDet.CANTIDAD, 0)) - NVL(I_GetInfoDocFinancieroDet.DESCUENTO_FACPRO_DETALLE, 0)),2);
        --
        IF I_GetInfoDocFinancieroDet.PLAN_ID IS NOT NULL AND I_GetInfoDocFinancieroDet.PLAN_ID  <> 0 THEN
          --
          IF C_GetInfoPlanCab%ISOPEN THEN        
            CLOSE C_GetInfoPlanCab;       
          END IF;
          --
          OPEN C_GetInfoPlanCab(I_GetInfoDocFinancieroDet.PLAN_ID);
          --
          FETCH C_GetInfoPlanCab INTO Lc_GetInfoPlanCab;
          --
          CLOSE C_GetInfoPlanCab;
          --
          IF Lc_GetInfoPlanCab.IVA = 'S' THEN
            --
            IF C_GetAdmiImpuesto%ISOPEN THEN            
              CLOSE C_GetAdmiImpuesto;            
            END IF;
            --
            OPEN C_GetAdmiImpuesto(NULL, 'IVA');
            --
            FETCH C_GetAdmiImpuesto INTO Lc_GetAdmiImpuesto;
            --
            CLOSE C_GetAdmiImpuesto;
            --            
            Ln_ValorDetalleImpuestoFac := ROUND(((Ln_SubTotalFac * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100),4);
            --
          END IF; 
          --
        END IF;
        --
        --Pregunta que sea producto
        IF I_GetInfoDocFinancieroDet.PRODUCTO_ID IS NOT NULL AND I_GetInfoDocFinancieroDet.PRODUCTO_ID  <> 0 THEN
          --Si es un producto itera los impuestos relacionados a este producto
          FOR Lr_GetImpuestoDetalle IN C_GetImpuestoDetalle(I_GetInfoDocFinancieroDet.ID_DOC_DETALLE)
          LOOP
            --
            IF C_GetAdmiImpuesto%ISOPEN THEN            
              CLOSE C_GetAdmiImpuesto;            
            END IF;
            --
            OPEN C_GetAdmiImpuesto(Lr_GetImpuestoDetalle.IMPUESTO_ID, NULL);
            --
            FETCH C_GetAdmiImpuesto INTO Lc_GetAdmiImpuesto;
            --
            CLOSE C_GetAdmiImpuesto;
            --            
            Ln_ValorDetalleImpuestoFac := ROUND(((Ln_SubTotalFac * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100),4);
            --
          END LOOP; 
          --
        END IF;           
        --
        --Obtengo Subtotal detalle de la Factura con impuesto sobre el cual se aplicaria la NCI
        Ln_SubtotalDetConImpuestoFac := (I_GetInfoDocFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE*I_GetInfoDocFinancieroDet.CANTIDAD)-I_GetInfoDocFinancieroDet.DESCUENTO_FACPRO_DETALLE+Ln_ValorDetalleImpuestoFac;        
        --
        --Verifico si existen NC o NCI para el ID_DOCUMENTO Factura para lo cual obtengo la sumatoria de detalles de NC y NCI (Activas)
        --generados para el Detalle de la Factura para lo cual sumarizo los subtotales mas impuestos y
        --busco los detalles de NC y NCI por (ServicioId, PuntoId-PlanId, PuntoId-ProductoId)
        --Obtengo el Saldo por detalle de Factura al cual puede aplicarse NCI restando el Ln_SubtotalDetConImpuestoFac - Ln_SubtotalDetConImpuestoNc
        --
        Ln_SubtotalDetConImpuestoNc:= FNCK_PAGOS_DIFERIDOS.F_GET_SUM_DETALLES_NCI(Fn_IdDocumento,I_GetInfoDocFinancieroDet.ID_DOC_DETALLE);
        --
        --Obtengo el Saldo por detalle de Factura al cual puede aplicarse NCI restando el Ln_SubtotalDetConImpuestoFac - Ln_SubtotalDetConImpuestoNc
        --        
        Ln_SubtotalDetConImpuestoFac:=ROUND(Ln_SubtotalDetConImpuestoFac,4);
        Ln_SubtotalDetConImpuestoNc :=ROUND(Ln_SubtotalDetConImpuestoNc,4);

        Ln_SumDetalleSaldoNc :=Ln_SubtotalDetConImpuestoFac-Ln_SubtotalDetConImpuestoNc;             
        --
        IF Ln_SumDetalleSaldoNc >0 THEN
            Ln_ValorDetalleAplicarNC := Ln_ValorDetalleAplicarNC + Ln_SubtotalDetConImpuestoFac;
        END IF;   
        --
      END LOOP;
      --
      IF Ln_ValorDetalleAplicarNC = 0 THEN
        Ln_ValorDetalleAplicarNC := Ln_SaldoPorFactura + NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA( 
                                                  Fn_IdDocumento,
                                                  TO_CHAR(SYSDATE,'DD-MM-RRRR'), 'PAG'),2),0 
                                                  );

      END IF;
      --      
      -- Calculo el Porcentaje que representa el saldo para el calculo de la NCI
      Ln_Porcentaje := NVL(((Ln_SaldoPorFactura * 100)/Ln_ValorDetalleAplicarNC),0); 
      --
    END IF; --Ln_SaldoPorFactura > 0    
    --
    RETURN Ln_Porcentaje;
    --
  END F_GET_PORCENTAJE_SALDO;    
  --
  --
  --
  FUNCTION F_GET_SUM_DETALLES_NCI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                  Fn_IdDocDetalle IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_GetSumDetalleNcServ(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                 Cn_ServicioId  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.SERVICIO_ID%TYPE,
                                 Cv_Estado      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE)
    IS 
      SELECT NCD.SERVICIO_ID,
      SUM((NCD.PRECIO_VENTA_FACPRO_DETALLE*NCD.CANTIDAD)-NCD.DESCUENTO_FACPRO_DETALLE)+SUM(NCDI.VALOR_IMPUESTO) AS SUM_DETALLE_NC
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCC,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET NCD,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP NCDI
      WHERE NCC.REFERENCIA_DOCUMENTO_ID  = Cn_IdDocumento 
      AND NCD.SERVICIO_ID                = Cn_ServicioId
      AND NCC.ESTADO_IMPRESION_FACT      = Cv_Estado
      AND NCC.ID_DOCUMENTO               = NCD.DOCUMENTO_ID
      AND NCD.ID_DOC_DETALLE             = NCDI.DETALLE_DOC_ID 
      AND NCD.SERVICIO_ID                IS NOT NULL
      GROUP BY NCD.SERVICIO_ID;

    CURSOR C_GetSumDetalleNcPlan(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                 Cn_PuntoId     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
                                 Cn_PlanId      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PLAN_ID%TYPE,
                                 Cv_Estado      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE)
    IS
      SELECT NCD.PUNTO_ID, 
      NCD.PLAN_ID,
      SUM((NCD.PRECIO_VENTA_FACPRO_DETALLE*NCD.CANTIDAD)-NCD.DESCUENTO_FACPRO_DETALLE)+SUM(NCDI.VALOR_IMPUESTO) AS SUM_DETALLE_NC
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCC,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET NCD,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP NCDI
      WHERE NCC.REFERENCIA_DOCUMENTO_ID  = Cn_IdDocumento 
      AND NCD.PUNTO_ID                   = Cn_PuntoId
      AND NCD.PLAN_ID                    = Cn_PlanId
      AND NCC.ESTADO_IMPRESION_FACT      = Cv_Estado
      AND NCC.ID_DOCUMENTO               = NCD.DOCUMENTO_ID
      AND NCD.ID_DOC_DETALLE             = NCDI.DETALLE_DOC_ID 
      AND NCD.PLAN_ID                    IS NOT NULL AND NCD.PLAN_ID !=0
      GROUP BY NCD.PUNTO_ID, NCD.PLAN_ID;

    CURSOR C_GetSumDetalleNcProd(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                 Cn_PuntoId     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PUNTO_ID%TYPE,
                                 Cn_ProductoId  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.PRODUCTO_ID%TYPE,
                                 Cv_Estado      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ESTADO_IMPRESION_FACT%TYPE)
    IS
      SELECT NCD.PUNTO_ID,
      NCD.PRODUCTO_ID,
      SUM((NCD.PRECIO_VENTA_FACPRO_DETALLE*NCD.CANTIDAD)-NCD.DESCUENTO_FACPRO_DETALLE)+SUM(NCDI.VALOR_IMPUESTO) AS SUM_DETALLE_NC
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCC,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET NCD,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP NCDI
      WHERE NCC.REFERENCIA_DOCUMENTO_ID  = Cn_IdDocumento 
      AND NCD.PUNTO_ID                   = Cn_PuntoId
      AND NCD.PRODUCTO_ID                = Cn_ProductoId
      AND NCC.ESTADO_IMPRESION_FACT      = Cv_Estado
      AND NCC.ID_DOCUMENTO               = NCD.DOCUMENTO_ID
      AND NCD.ID_DOC_DETALLE             = NCDI.DETALLE_DOC_ID 
      AND NCD.PRODUCTO_ID                IS NOT NULL
      GROUP BY NCD.PUNTO_ID, NCD.PRODUCTO_ID;

    CURSOR C_GetInfoDocFinancieroDet(Cn_IdDocDetalle DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET.ID_DOC_DETALLE%TYPE)
    IS
      SELECT ID_DOC_DETALLE,
      PUNTO_ID,
      SERVICIO_ID,
      PLAN_ID,
      PRODUCTO_ID,
      PRECIO_VENTA_FACPRO_DETALLE,
      CANTIDAD,
      DESCUENTO_FACPRO_DETALLE
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET
      WHERE ID_DOC_DETALLE = Cn_IdDocDetalle;

     Ln_SubtotalDetConImpuestoNc   NUMBER := 0;
     Lc_GetSumDetalleNcServ        C_GetSumDetalleNcServ%ROWTYPE;
     Lc_GetSumDetalleNcPlan        C_GetSumDetalleNcPlan%ROWTYPE;
     Lc_GetSumDetalleNcProd        C_GetSumDetalleNcProd%ROWTYPE;
     Lc_GetInfoDocFinancieroDet    C_GetInfoDocFinancieroDet%ROWTYPE;

  BEGIN
    IF C_GetSumDetalleNcServ%ISOPEN THEN          
      CLOSE C_GetSumDetalleNcServ;          
    END IF; 
    IF C_GetSumDetalleNcPlan%ISOPEN THEN          
      CLOSE C_GetSumDetalleNcPlan;          
    END IF; 
    IF C_GetSumDetalleNcProd%ISOPEN THEN          
      CLOSE C_GetSumDetalleNcProd;          
    END IF; 
    IF C_GetInfoDocFinancieroDet%ISOPEN THEN          
      CLOSE C_GetInfoDocFinancieroDet;          
    END IF; 

    --
    --Verifico si existen NC o NCI para el ID_DOCUMENTO Factura para lo cual obtengo la sumatoria de detalles de NC y NCI (Activas)
    --generados para el Detalle de la Factura para lo cual sumarizo los subtotales mas impuestos y
    --busco los detalles de NC y NCI por (ServicioId, PuntoId-PlanId, PuntoId-ProductoId)    
    --
    OPEN C_GetInfoDocFinancieroDet(Fn_IdDocDetalle);
    --
    FETCH C_GetInfoDocFinancieroDet INTO Lc_GetInfoDocFinancieroDet;
    --
    CLOSE C_GetInfoDocFinancieroDet;  

    IF Lc_GetInfoDocFinancieroDet.SERVICIO_ID IS NOT NULL AND Lc_GetInfoDocFinancieroDet.SERVICIO_ID  <> 0 THEN
      --
      OPEN C_GetSumDetalleNcServ(Fn_IdDocumento,Lc_GetInfoDocFinancieroDet.SERVICIO_ID,'Activo');
      --
      FETCH C_GetSumDetalleNcServ INTO Lc_GetSumDetalleNcServ;
      --
      CLOSE C_GetSumDetalleNcServ;         
      --
      IF Lc_GetSumDetalleNcServ.SUM_DETALLE_NC>0 THEN
        Ln_SubtotalDetConImpuestoNc := Lc_GetSumDetalleNcServ.SUM_DETALLE_NC;
      END IF;
      --
    ELSIF Lc_GetInfoDocFinancieroDet.PLAN_ID IS NOT NULL AND Lc_GetInfoDocFinancieroDet.PLAN_ID  <> 0 THEN
      --
      OPEN C_GetSumDetalleNcPlan(Fn_IdDocumento,Lc_GetInfoDocFinancieroDet.PUNTO_ID,Lc_GetInfoDocFinancieroDet.PLAN_ID,'Activo');
      --
      FETCH C_GetSumDetalleNcPlan INTO Lc_GetSumDetalleNcPlan;
      --
      CLOSE C_GetSumDetalleNcPlan; 
      --
      IF Lc_GetSumDetalleNcPlan.SUM_DETALLE_NC>0 THEN
        Ln_SubtotalDetConImpuestoNc := Lc_GetSumDetalleNcPlan.SUM_DETALLE_NC;
      END IF;
      --
    ELSIF Lc_GetInfoDocFinancieroDet.PRODUCTO_ID IS NOT NULL AND Lc_GetInfoDocFinancieroDet.PRODUCTO_ID  <> 0 THEN        
      --
      OPEN C_GetSumDetalleNcProd(Fn_IdDocumento,Lc_GetInfoDocFinancieroDet.PUNTO_ID,Lc_GetInfoDocFinancieroDet.PRODUCTO_ID,'Activo');
      --
      FETCH C_GetSumDetalleNcProd INTO Lc_GetSumDetalleNcProd;
      --
      CLOSE C_GetSumDetalleNcProd; 
      --
      IF Lc_GetSumDetalleNcProd.SUM_DETALLE_NC>0 THEN
        Ln_SubtotalDetConImpuestoNc := Lc_GetSumDetalleNcProd.SUM_DETALLE_NC;
      END IF;
      --
    END IF;  
    --
    RETURN Ln_SubtotalDetConImpuestoNc;
    --
  END F_GET_SUM_DETALLES_NCI;
  --
  --
  --
FUNCTION F_GET_VALOR_SIMULADO_NCI(Fn_IdDocumento IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                    Fn_Porcentaje  IN NUMBER)
  RETURN NUMBER
  IS      
    CURSOR C_GetInfoDocFinancieroDet(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT ID_DOC_DETALLE,
      PUNTO_ID,
      SERVICIO_ID,
      PLAN_ID,
      PRODUCTO_ID,
      PRECIO_VENTA_FACPRO_DETALLE,
      CANTIDAD,
      DESCUENTO_FACPRO_DETALLE
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET
      WHERE DOCUMENTO_ID = Cn_IdDocumento;     

    CURSOR C_GetInfoPlanCab(Cn_IdPlan DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE)
    IS
      SELECT ID_PLAN,
      IVA
      FROM DB_COMERCIAL.INFO_PLAN_CAB
      WHERE ID_PLAN = Cn_IdPlan;

    CURSOR C_GetInfoProductoImpuesto(Cn_IdProducto DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE, 
                                     Cv_Estado DB_COMERCIAL.ADMI_PRODUCTO.ESTADO%TYPE)
    IS
      SELECT ID_PRODUCTO_IMPUESTO,
      PRODUCTO_ID,
      IMPUESTO_ID
      FROM DB_COMERCIAL.INFO_PRODUCTO_IMPUESTO
      WHERE PRODUCTO_ID = Cn_IdProducto
      AND ESTADO        = Cv_Estado;

    CURSOR C_GetAdmiImpuesto(Cn_IdImpuesto DB_GENERAL.ADMI_IMPUESTO.ID_IMPUESTO%TYPE, 
                             Cv_TipoImpuesto DB_GENERAL.ADMI_IMPUESTO.TIPO_IMPUESTO%TYPE)
    IS 
      SELECT ID_IMPUESTO,
      PORCENTAJE_IMPUESTO
      FROM DB_GENERAL.ADMI_IMPUESTO
      WHERE ID_IMPUESTO     = NVL(Cn_IdImpuesto, ID_IMPUESTO)
      AND TIPO_IMPUESTO     = NVL(Cv_TipoImpuesto, TIPO_IMPUESTO);

    CURSOR C_GetImpuestoDetalle (Cn_DetalleDocId DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP.DETALLE_DOC_ID%TYPE)
    IS
      SELECT DETALLE_DOC_ID,
      IMPUESTO_ID,
      VALOR_IMPUESTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_IMP
      WHERE DETALLE_DOC_ID = Cn_DetalleDocId;

    --
    Lc_GetInfoProductoImpuesto    C_GetInfoProductoImpuesto%ROWTYPE;
    Lc_GetAdmiImpuesto            C_GetAdmiImpuesto%ROWTYPE;
    Lc_GetInfoPlanCab             C_GetInfoPlanCab%ROWTYPE;
    Ln_Impuesto                   NUMBER := 0;
    Ln_ImpuestoFac                NUMBER := 0;
    Ln_SubTotal                   NUMBER := 0;
    Ln_SubTotalFac                NUMBER := 0;
    Ln_ValorProrrateo             NUMBER := 0;
    Ln_Descuento                  NUMBER := 0;
    Ln_SumSubTotal                NUMBER := 0;
    Ln_SubtotalDetConImpuestoFac  NUMBER := 0;
    Ln_SubtotalDetConImpuestoNc   NUMBER := 0;
    Ln_SumDetalleSaldoNc          NUMBER := 0;
    --
  BEGIN
    --
    --Se prorratea sobre % del saldo pendiente de la Factura sobre el cual se generar� la NCI
    Ln_ValorProrrateo := (NVL(Fn_Porcentaje, 0) / 100); 
    --
    --Itera el detalle de la factura
    FOR I_GetInfoDocFinancieroDet IN C_GetInfoDocFinancieroDet(Fn_IdDocumento)
    LOOP     
      --
      Ln_SubTotalFac := 0;
      Ln_SubTotal    := 0;
      Ln_Descuento   := 0;
      Ln_SubtotalDetConImpuestoFac:=0;
      Ln_SubtotalDetConImpuestoNc :=0;
      Ln_SumDetalleSaldoNc        :=0;
      --
      Ln_SubTotal   := ROUND((NVL(I_GetInfoDocFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE, 0) * Ln_ValorProrrateo), 4);
      Ln_Descuento  := ROUND((NVL(I_GetInfoDocFinancieroDet.DESCUENTO_FACPRO_DETALLE, 0) * Ln_ValorProrrateo), 4);
      --
      Ln_Impuesto := 0;
      Ln_ImpuestoFac := 0;
      --
      Ln_SubTotalFac  := ROUND(((NVL(I_GetInfoDocFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE, 0) * NVL(I_GetInfoDocFinancieroDet.CANTIDAD, 0)) - NVL(I_GetInfoDocFinancieroDet.DESCUENTO_FACPRO_DETALLE, 0)),2);

      Ln_SubTotal     := ROUND(((Ln_SubTotal * NVL(I_GetInfoDocFinancieroDet.CANTIDAD, 0)) - Ln_Descuento),4);

      --Pregunta que sea producto
      IF I_GetInfoDocFinancieroDet.PRODUCTO_ID IS NOT NULL AND I_GetInfoDocFinancieroDet.PRODUCTO_ID  <> 0 THEN
        --Si es un producto itera los impuestos relacionados a este producto
        FOR Lr_GetImpuestoDetalle IN C_GetImpuestoDetalle(I_GetInfoDocFinancieroDet.ID_DOC_DETALLE)
        LOOP
          --
          IF C_GetAdmiImpuesto%ISOPEN THEN            
            CLOSE C_GetAdmiImpuesto;            
          END IF;
          --
          OPEN C_GetAdmiImpuesto(Lr_GetImpuestoDetalle.IMPUESTO_ID, NULL);
          --
          FETCH C_GetAdmiImpuesto INTO Lc_GetAdmiImpuesto;
          --
          CLOSE C_GetAdmiImpuesto;
          --
          Ln_Impuesto    := ROUND(((Ln_SubTotal * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100),4);
          Ln_ImpuestoFac := ROUND(((Ln_SubTotalFac * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100),4);
          --
        END LOOP; 
        --
      END IF; 
      --
      IF I_GetInfoDocFinancieroDet.PLAN_ID IS NOT NULL AND I_GetInfoDocFinancieroDet.PLAN_ID  <> 0 THEN
        --
        IF C_GetInfoPlanCab%ISOPEN THEN        
          CLOSE C_GetInfoPlanCab;       
        END IF;
        --
        OPEN C_GetInfoPlanCab(I_GetInfoDocFinancieroDet.PLAN_ID);
        --
        FETCH C_GetInfoPlanCab INTO Lc_GetInfoPlanCab;
        --
        CLOSE C_GetInfoPlanCab;
        --
        IF Lc_GetInfoPlanCab.IVA = 'S' THEN
          --
          IF C_GetAdmiImpuesto%ISOPEN THEN            
            CLOSE C_GetAdmiImpuesto;            
          END IF;
          --
          OPEN C_GetAdmiImpuesto(NULL, 'IVA');
          --
          FETCH C_GetAdmiImpuesto INTO Lc_GetAdmiImpuesto;
          --
          CLOSE C_GetAdmiImpuesto;
          --
          Ln_Impuesto    := ROUND(((Ln_SubTotal * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100),4);
          Ln_ImpuestoFac := ROUND(((Ln_SubTotalFac * NVL(Lc_GetAdmiImpuesto.PORCENTAJE_IMPUESTO, 0)) / 100),4);
          --
        END IF; 
        --
      END IF;
      --
      --
      --Obtengo el Saldo por detalle de Factura al cual puede aplicarse NCI restando el Ln_SubtotalDetConImpuestoFac - Ln_SubtotalDetConImpuestoNc
      --
      Ln_SubtotalDetConImpuestoFac :=  ROUND((NVL(Ln_SubTotalFac, 0) + NVL(Ln_ImpuestoFac, 0)),4);      
      --
      Ln_SubtotalDetConImpuestoNc:= FNCK_PAGOS_DIFERIDOS.F_GET_SUM_DETALLES_NCI(Fn_IdDocumento,I_GetInfoDocFinancieroDet.ID_DOC_DETALLE);
      --
      Ln_SumDetalleSaldoNc :=Ln_SubtotalDetConImpuestoFac - Ln_SubtotalDetConImpuestoNc;           
      --
      IF Ln_SumDetalleSaldoNc>0 THEN
        Ln_SumSubTotal := Ln_SumSubTotal + NVL(Ln_SubTotal, 0) + NVL(Ln_Impuesto, 0);
      END IF;
      --
    END LOOP;
    --
    RETURN Ln_SumSubTotal;
    --
  END F_GET_VALOR_SIMULADO_NCI; 
  --
  --
  --
  PROCEDURE P_INSERT_INFO_DOCUMENTO_CARACT(Pr_InfoDocumentoCaract IN DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE,
                                           Pv_MsnError            OUT VARCHAR2)
  IS
    Lv_IpCreacion  VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    BEGIN
      --
      INSERT
      INTO DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA
      (
       ID_DOCUMENTO_CARACTERISTICA,
       DOCUMENTO_ID,
       CARACTERISTICA_ID,
       VALOR,
       FE_CREACION,
       USR_CREACION,
       IP_CREACION,
       ESTADO,
       DOCUMENTO_CARACTERISTICA_ID
      )
      VALUES
      (
       Pr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA,
       Pr_InfoDocumentoCaract.DOCUMENTO_ID,
       Pr_InfoDocumentoCaract.CARACTERISTICA_ID,
       Pr_InfoDocumentoCaract.VALOR,
       Pr_InfoDocumentoCaract.FE_CREACION,
       Pr_InfoDocumentoCaract.USR_CREACION,
       Pr_InfoDocumentoCaract.IP_CREACION,
       Pr_InfoDocumentoCaract.ESTADO,
       Pr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID
      );
      --
  EXCEPTION
    WHEN OTHERS THEN
      --            
      Pv_MsnError := 'Error al insertar la caracter�stica - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT', 
                                           Pv_MsnError, 
                                           'telcos_diferido',
                                           SYSDATE, 
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));      
  --
  END P_INSERT_INFO_DOCUMENTO_CARACT;
  --
  --
  -- 
  PROCEDURE P_UPDATE_INFO_DOCUMENTO_CARACT(Pr_InfoDocumentoCaract IN  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE,
                                           Pv_MsnError            OUT VARCHAR2)
  IS
    Le_Exception     EXCEPTION;
    Lv_IpCreacion    VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  BEGIN
    --
    IF (NVL(Pr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA, 0) = 0) THEN
      Pv_MsnError := 'Error al actualizar la caracter�stica. Par�metro Pr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA vac�o.';
      RAISE Le_Exception;
    END IF;

    UPDATE DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA
    SET DOCUMENTO_ID  = NVL(Pr_InfoDocumentoCaract.DOCUMENTO_ID, DOCUMENTO_ID),
    CARACTERISTICA_ID = NVL(Pr_InfoDocumentoCaract.CARACTERISTICA_ID, CARACTERISTICA_ID),
    VALOR             = NVL(Pr_InfoDocumentoCaract.VALOR, VALOR),
    FE_ULT_MOD        = NVL(Pr_InfoDocumentoCaract.FE_ULT_MOD, FE_ULT_MOD),
    USR_ULT_MOD       = NVL(Pr_InfoDocumentoCaract.USR_ULT_MOD, USR_ULT_MOD),
    IP_ULT_MOD        = NVL(Pr_InfoDocumentoCaract.IP_ULT_MOD, IP_ULT_MOD),
    ESTADO            = NVL(Pr_InfoDocumentoCaract.ESTADO, ESTADO),
    DOCUMENTO_CARACTERISTICA_ID = NVL(Pr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID, DOCUMENTO_CARACTERISTICA_ID)
    WHERE  ID_DOCUMENTO_CARACTERISTICA = Pr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DOCUMENTO_CARAC',
                                           Pv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    WHEN OTHERS THEN         
      Pv_MsnError := 'Error al actualizar la caracter�stica - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DOCUMENTO_CARAC',
                                           Pv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  --  
  END P_UPDATE_INFO_DOCUMENTO_CARACT;
  --
  --
  --
  PROCEDURE P_INSERT_INFO_DETALLE_SOL_HIST(Pr_InfoDetalleSolHist   IN DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE,
                                           Pv_MsnError             OUT VARCHAR2)
  IS
    Lv_IpCreacion    VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  BEGIN 
    --   
    INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
    (ID_SOLICITUD_HISTORIAL,
     DETALLE_SOLICITUD_ID,
     ESTADO,
     FE_INI_PLAN,
     FE_FIN_PLAN,
     OBSERVACION,
     USR_CREACION,
     FE_CREACION,
     IP_CREACION,
     MOTIVO_ID)
    VALUES
    (Pr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL,
     Pr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID,
     Pr_InfoDetalleSolHist.ESTADO,
     Pr_InfoDetalleSolHist.FE_INI_PLAN,
     Pr_InfoDetalleSolHist.FE_FIN_PLAN,
     Pr_InfoDetalleSolHist.OBSERVACION,
     Pr_InfoDetalleSolHist.USR_CREACION,
     Pr_InfoDetalleSolHist.FE_CREACION,
     Pr_InfoDetalleSolHist.IP_CREACION,
     Pr_InfoDetalleSolHist.MOTIVO_ID
    );
    --
  EXCEPTION
    WHEN OTHERS THEN
      --            
      Pv_MsnError := 'Error al insertar historial de la Solicitud - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DETALLE_SOL_HIST', 
                                           Pv_MsnError, 
                                           'telcos_diferido',
                                           SYSDATE, 
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));    
  --
  END P_INSERT_INFO_DETALLE_SOL_HIST;
  --
  --
  --
  PROCEDURE P_UPDATE_INFO_DETALLE_SOL_CARA(Pr_InfoDetalleSolCaract IN  DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE,
                                           Pv_MsnError             OUT VARCHAR2)
  IS
    Le_Exception     EXCEPTION;
    Lv_IpCreacion    VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  BEGIN
    --
    IF Pr_InfoDetalleSolCaract.ID_SOLICITUD_CARACTERISTICA IS NOT NULL THEN
      --
      UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
      SET CARACTERISTICA_ID     = NVL(Pr_InfoDetalleSolCaract.CARACTERISTICA_ID, CARACTERISTICA_ID),
      VALOR                     = NVL(Pr_InfoDetalleSolCaract.VALOR, VALOR),
      FE_ULT_MOD                = NVL(Pr_InfoDetalleSolCaract.FE_ULT_MOD, FE_ULT_MOD),
      USR_ULT_MOD               = NVL(Pr_InfoDetalleSolCaract.USR_ULT_MOD, USR_ULT_MOD),    
      ESTADO                    = NVL(Pr_InfoDetalleSolCaract.ESTADO, ESTADO),
      DETALLE_SOL_CARACT_ID     = NVL(Pr_InfoDetalleSolCaract.DETALLE_SOL_CARACT_ID, DETALLE_SOL_CARACT_ID)
      WHERE ID_SOLICITUD_CARACTERISTICA  = Pr_InfoDetalleSolCaract.ID_SOLICITUD_CARACTERISTICA;
      --
    ELSIF Pr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID IS NOT NULL THEN
      --
      UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
      SET CARACTERISTICA_ID     = NVL(Pr_InfoDetalleSolCaract.CARACTERISTICA_ID, CARACTERISTICA_ID),
      VALOR                     = NVL(Pr_InfoDetalleSolCaract.VALOR, VALOR),
      FE_ULT_MOD                = NVL(Pr_InfoDetalleSolCaract.FE_ULT_MOD, FE_ULT_MOD),
      USR_ULT_MOD               = NVL(Pr_InfoDetalleSolCaract.USR_ULT_MOD, USR_ULT_MOD),    
      ESTADO                    = NVL(Pr_InfoDetalleSolCaract.ESTADO, ESTADO),
      DETALLE_SOL_CARACT_ID     = NVL(Pr_InfoDetalleSolCaract.DETALLE_SOL_CARACT_ID, DETALLE_SOL_CARACT_ID)
      WHERE DETALLE_SOLICITUD_ID = Pr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID;
      --
    END IF;   
    --
  EXCEPTION    
    WHEN OTHERS THEN         
      Pv_MsnError := 'Error al actualizar la caracter�stica - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOL_CARA',
                                           Pv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  --   
  END P_UPDATE_INFO_DETALLE_SOL_CARA;
  -- 
  --
  --
  PROCEDURE P_UPDATE_INFO_DETALLE_SOLIC(Pr_InfoDetalleSolicitud IN  DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE,
                                        Pv_MsnError             OUT VARCHAR2)
  IS
    Le_Exception     EXCEPTION;
    Lv_IpCreacion    VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
  BEGIN
    --
    IF (NVL(Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD, 0) = 0) THEN
      Pv_MsnError := 'Error al actualizar Solicitud. Par�metro Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD vac�o.';
      RAISE Le_Exception;
    END IF;
    UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    SET  OBSERVACION               = NVL(OBSERVACION || ' ' || Pr_InfoDetalleSolicitud.OBSERVACION, OBSERVACION),    
    ESTADO                         = NVL(Pr_InfoDetalleSolicitud.ESTADO, ESTADO) 
    WHERE ID_DETALLE_SOLICITUD = Pr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD;
    --
  EXCEPTION
    WHEN Le_Exception THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOLIC',
                                           Pv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    WHEN OTHERS THEN         
      Pv_MsnError := 'Error al actualizar la caracter�stica - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DETALLE_SOLIC',
                                           Pv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  --   
  END P_UPDATE_INFO_DETALLE_SOLIC;
  --
  --
  --
  PROCEDURE UPDATE_INFO_DOC_FINANCIERO_DET( Pn_IdDocumento                IN INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                            Pr_InfoDocumentoFinancieroDet IN INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE,
                                            Pv_MsnError                   OUT VARCHAR2)
  IS
    Le_Exception     EXCEPTION;
    Lv_IpCreacion    VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
  BEGIN
    --
    UPDATE DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET
    SET
    PRECIO_VENTA_FACPRO_DETALLE   = NVL(Pr_InfoDocumentoFinancieroDet.PRECIO_VENTA_FACPRO_DETALLE, PRECIO_VENTA_FACPRO_DETALLE),
    OBSERVACIONES_FACTURA_DETALLE = NVL(Pr_InfoDocumentoFinancieroDet.OBSERVACIONES_FACTURA_DETALLE, OBSERVACIONES_FACTURA_DETALLE)
    WHERE DOCUMENTO_ID = Pn_IdDocumento;
    --
  EXCEPTION
    WHEN OTHERS THEN         
      Pv_MsnError := 'Error al actualizar documento #IdDocumento: '|| Pn_IdDocumento ||' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.UPDATE_INFO_DOC_FINANCIERO_DET',
                                           Pv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  END UPDATE_INFO_DOC_FINANCIERO_DET;
  --
  --
  --
  FUNCTION F_GET_CARACT_DOCUMENTO(Fn_IdDocumento   IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                  Fv_DesCaract     IN VARCHAR2)
    RETURN VARCHAR2
  IS
    CURSOR C_GetCaractDocumento(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                                Cv_Estado      DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,
                                Cv_DesCaract   VARCHAR2)
    IS
      SELECT DCA.VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
      DB_COMERCIAL.ADMI_CARACTERISTICA CA
      WHERE  DCA.CARACTERISTICA_ID          = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA     = Cv_DesCaract
      AND DCA.ESTADO                        = Cv_Estado
      AND DCA.DOCUMENTO_ID                  = Cn_IdDocumento
      ;

    Lv_Valor               VARCHAR2(250);
    Lv_MsnError            VARCHAR2(200);
    Lv_IpCreacion          VARCHAR2(10) := '127.0.0.1';
    --
  BEGIN
    IF C_GetCaractDocumento%ISOPEN THEN      
      CLOSE C_GetCaractDocumento;      
    END IF;
    --
    OPEN C_GetCaractDocumento(Fn_IdDocumento,'Activo',Fv_DesCaract);    
    FETCH C_GetCaractDocumento INTO Lv_Valor;    

    CLOSE C_GetCaractDocumento;    
    RETURN Lv_Valor;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener la caracter�stica: ' || Fv_DesCaract || ' IdDocumento: '|| Fn_IdDocumento ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN NULL;
      --
  END F_GET_CARACT_DOCUMENTO;  
  --
  --
  --
  FUNCTION F_GET_TOTAL_DIFERIDO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_GetTotalDiferido(Cn_IdPunto               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                              Cv_CodigoTipoDocumento   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                              Cv_UsrCreacion           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                              Cv_Estado                DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,
                              Cv_DesCaract             DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
    SELECT 
    SUM(NCI.VALOR_TOTAL) AS TOTAL_DIFERIDO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
    DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
    DB_COMERCIAL.ADMI_CARACTERISTICA CA,
    DB_COMERCIAL.INFO_PUNTO IP
    WHERE NCI.TIPO_DOCUMENTO_ID       = TDOC.ID_TIPO_DOCUMENTO
    AND TDOC.CODIGO_TIPO_DOCUMENTO    = Cv_CodigoTipoDocumento
    AND NCI.USR_CREACION              = Cv_UsrCreacion
    AND NCI.ESTADO_IMPRESION_FACT     = Cv_Estado
    AND NCI.ID_DOCUMENTO              = DCA.DOCUMENTO_ID
    AND DCA.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
    AND CA.DESCRIPCION_CARACTERISTICA = Cv_DesCaract
    AND DCA.ESTADO                    = Cv_Estado
    AND NCI.PUNTO_ID                  = IP.ID_PUNTO  
    AND NCI.PUNTO_ID                  = Cn_IdPunto  
    GROUP BY NCI.PUNTO_ID
    ORDER BY NCI.PUNTO_ID ASC ;

    Ln_TotalDiferido      NUMBER:=0; 
    --
    Lex_Exception         EXCEPTION;
    Lv_MsnError           VARCHAR2 (2000);
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo       VARCHAR2(20):='Activo';

  BEGIN
    IF Fn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    IF C_GetTotalDiferido%ISOPEN THEN      
      CLOSE C_GetTotalDiferido;      
    END IF;
    --
    OPEN C_GetTotalDiferido(Fn_IdPunto, 'NCI', 'telcos_diferido', Lv_EstadoActivo,'PROCESO_DIFERIDO');    
    FETCH C_GetTotalDiferido INTO Ln_TotalDiferido;    

    CLOSE C_GetTotalDiferido;    
    RETURN Ln_TotalDiferido;
    --   
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener el valor total de la Deuda Diferida por Punto #IdPunto ' ||  Fn_IdPunto ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_TOTAL_DIFERIDO',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN Ln_TotalDiferido;
      --
  END F_GET_TOTAL_DIFERIDO;  
  --
  --
  --
  FUNCTION F_GET_DIFERIDO_PAGADO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_GetDiferidoPagado(Cn_IdPunto               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                               Cv_CodigoTipoDocumento   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                               Cv_UsrCreacion           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                               Cv_EstadoActivo          DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,                               
                               Cv_EstadoCerrado         DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,
                               Cv_DesCaract             DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
    SELECT     
    SUM(PCAB.VALOR_TOTAL) AS DIFERIDO_PAGADO
    FROM
    DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NDI,
    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
    DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
    DB_COMERCIAL.ADMI_CARACTERISTICA CA,
    DB_COMERCIAL.INFO_PUNTO IP,
    DB_FINANCIERO.INFO_PAGO_CAB PCAB,
    DB_FINANCIERO.INFO_PAGO_DET PDET
    WHERE PCAB.ID_PAGO                = PDET.PAGO_ID
    AND PDET.REFERENCIA_ID            = NDI.ID_DOCUMENTO
    AND PCAB.ESTADO_PAGO              = Cv_EstadoCerrado
    AND NDI.TIPO_DOCUMENTO_ID         = TDOC.ID_TIPO_DOCUMENTO
    AND TDOC.CODIGO_TIPO_DOCUMENTO    = Cv_CodigoTipoDocumento
    AND NDI.USR_CREACION              = Cv_UsrCreacion
    AND NDI.ESTADO_IMPRESION_FACT     IN (Cv_EstadoActivo,Cv_EstadoCerrado)
    AND NDI.ID_DOCUMENTO              = DCA.DOCUMENTO_ID
    AND DCA.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
    AND CA.DESCRIPCION_CARACTERISTICA = Cv_DesCaract
    AND DCA.ESTADO                    = Cv_EstadoActivo
    AND NDI.PUNTO_ID                  = IP.ID_PUNTO  
    AND NDI.PUNTO_ID                  = Cn_IdPunto
    GROUP BY PCAB.PUNTO_ID; 

    Ln_DiferidoPagado     NUMBER:=0; 
    --
    Lex_Exception         EXCEPTION;
    Lv_MsnError           VARCHAR2 (2000);
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo       VARCHAR2(20):='Activo';
    Lv_EstadoCerrado      VARCHAR2(20):='Cerrado';

  BEGIN
    IF Fn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    IF C_GetDiferidoPagado%ISOPEN THEN      
      CLOSE C_GetDiferidoPagado;      
    END IF;
    --
    OPEN C_GetDiferidoPagado(Fn_IdPunto, 'NDI', 'telcos_diferido', Lv_EstadoActivo, Lv_EstadoCerrado, 'PROCESO_DIFERIDO');    
    FETCH C_GetDiferidoPagado INTO Ln_DiferidoPagado;    

    CLOSE C_GetDiferidoPagado;    
    RETURN Ln_DiferidoPagado;
    --   
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener el valor Total de Diferido Pagado por Punto #IdPunto ' ||  Fn_IdPunto ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_DIFERIDO_PAGADO',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN Ln_DiferidoPagado;
      --
  END F_GET_DIFERIDO_PAGADO;  
  --
  --
  --
  FUNCTION F_GET_DIFERIDO_POR_VENCER(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_GetDiferidoPorVencer(Cn_IdPunto                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                                  Cv_CodigoTipoDocumento    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                  Cv_UsrCreacion            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                  Cv_EstadoActivo           DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,                                                                 
                                  Cv_CaractProcesoDiferido  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                  Cv_CaractEsMesesDiferido  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                  Cv_CaractEsContDiferido   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                  Cv_CaractEsProcesoMasivo  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
    SELECT DISTINCT NCI.ID_DOCUMENTO,
    NCI.PUNTO_ID,
    NCI.NUMERO_FACTURA_SRI,
    NCI.FE_CREACION,
    NCI.VALOR_TOTAL,
    -- 
    CASE
      WHEN COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO, Cv_CaractEsMesesDiferido),'^\d+')),0) <> 0
      THEN ROUND((NCI.VALOR_TOTAL/COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,
                                                                   Cv_CaractEsMesesDiferido),'^\d+')),0)),2)
      ELSE 0
    END AS DIFERIDO_POR_VENCER,
    --
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsProcesoMasivo),'^\d+')),0) 
    AS ID_PROCESO_MASIVO,
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsContDiferido),'^\d+')),0)  
    AS ES_CONT_DIFERIDO,
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsMesesDiferido),'^\d+')),0) 
    AS ES_MESES_DIFERIDO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
    DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
    DB_COMERCIAL.ADMI_CARACTERISTICA CA,
    DB_COMERCIAL.INFO_PUNTO IP
    WHERE NCI.TIPO_DOCUMENTO_ID       = TDOC.ID_TIPO_DOCUMENTO
    AND TDOC.CODIGO_TIPO_DOCUMENTO    = Cv_CodigoTipoDocumento
    AND NCI.USR_CREACION              = Cv_UsrCreacion
    AND NCI.ESTADO_IMPRESION_FACT     = Cv_EstadoActivo
    AND NCI.ID_DOCUMENTO              = DCA.DOCUMENTO_ID
    AND DCA.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
    AND CA.DESCRIPCION_CARACTERISTICA = Cv_CaractProcesoDiferido
    AND DCA.ESTADO                    = Cv_EstadoActivo
    AND NCI.PUNTO_ID                  = IP.ID_PUNTO  
    AND NCI.PUNTO_ID                  = Cn_IdPunto
    AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsContDiferido),'^\d+')),0)
    < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsMesesDiferido),'^\d+')),0)    
    --
    GROUP BY NCI.ID_DOCUMENTO,
    NCI.PUNTO_ID,
    NCI.NUMERO_FACTURA_SRI,
    NCI.FE_CREACION,
    NCI.VALOR_TOTAL,
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsProcesoMasivo),'^\d+')),0),
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsContDiferido),'^\d+')),0),
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsMesesDiferido),'^\d+')),0)
    ;

    Ln_DiferidoPorVencer  NUMBER:=0; 
    --
    Lex_Exception          EXCEPTION;
    Lv_MsnError            VARCHAR2 (2000);
    Lv_IpCreacion          VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo        VARCHAR2(20):='Activo';  
    Ln_ValorTotalNci       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;  
    Ln_ValorCuotaDiferida  NUMBER:=0; 
    Ln_ValorAjuste         NUMBER:=0;

  BEGIN
    IF Fn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    FOR Lr_GetDiferidoPorVencer IN C_GetDiferidoPorVencer(Fn_IdPunto, 'NCI', 'telcos_diferido', Lv_EstadoActivo,
                                                         'PROCESO_DIFERIDO','ES_MESES_DIFERIDO','ES_CONT_DIFERIDO','ES_PROCESO_MASIVO') 
    LOOP
      --
      Ln_ValorAjuste         := 0;
      Ln_ValorTotalNci       := Lr_GetDiferidoPorVencer.VALOR_TOTAL;
      Ln_ValorCuotaDiferida  := Lr_GetDiferidoPorVencer.DIFERIDO_POR_VENCER;      

      IF (Lr_GetDiferidoPorVencer.ES_CONT_DIFERIDO +1) = Lr_GetDiferidoPorVencer.ES_MESES_DIFERIDO THEN
        --
        Ln_ValorAjuste := Ln_ValorTotalNci - (Ln_ValorCuotaDiferida * Lr_GetDiferidoPorVencer.ES_MESES_DIFERIDO);
        IF Ln_ValorAjuste <> 0 THEN
          Ln_ValorCuotaDiferida := Ln_ValorCuotaDiferida + (Ln_ValorAjuste);
        END IF;
        --
      END IF;
      --
      Ln_DiferidoPorVencer := Ln_DiferidoPorVencer + Ln_ValorCuotaDiferida;
      -- 
    END LOOP;

    RETURN Ln_DiferidoPorVencer;
    --   
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener el valor Total de Diferido por Vencer por Punto #IdPunto ' ||  Fn_IdPunto ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_DIFERIDO_POR_VENCER',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN Ln_DiferidoPorVencer;
      --
  END F_GET_DIFERIDO_POR_VENCER;
  --
  --
  --
  FUNCTION F_GET_DIFERIDO_VENCIDO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_GetDiferidoVencido(Cn_IdPunto               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                                Cv_CodigoTipoDocumento   DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                Cv_UsrCreacion           DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                Cv_EstadoActivo          DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,                               
                                Cv_EstadoCerrado         DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,
                                Cv_DesCaract             DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
    SELECT 
      COALESCE (SUM( NDIP.VALOR - 
        COALESCE(
          ( SELECT SUM(NVL(PDET.VALOR_PAGO,0)) 
            FROM DB_FINANCIERO.INFO_PAGO_CAB PCAB,
            DB_FINANCIERO.INFO_PAGO_DET PDET
            WHERE  PCAB.ID_PAGO  = PDET.PAGO_ID 
            AND PCAB.ESTADO_PAGO = Cv_EstadoCerrado
            AND PDET.referencia_id = NDIP.id_documento), 0)
          ) ,0) AS VALOR_IMPAGO
    FROM ( 
      SELECT NDI.ID_DOCUMENTO, SUM(NDI.VALOR_TOTAL) AS VALOR
      FROM  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NDI, 
            DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,  
            DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,   
            DB_COMERCIAL.ADMI_CARACTERISTICA CA
      WHERE NDI.TIPO_DOCUMENTO_ID         = TDOC.ID_TIPO_DOCUMENTO
      AND TDOC.CODIGO_TIPO_DOCUMENTO    = Cv_CodigoTipoDocumento
      AND NDI.USR_CREACION              = Cv_UsrCreacion
      AND NDI.ESTADO_IMPRESION_FACT     IN (Cv_EstadoActivo, Cv_EstadoCerrado)
      AND NDI.ID_DOCUMENTO              = DCA.DOCUMENTO_ID
      AND DCA.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA = Cv_DesCaract
      AND DCA.ESTADO                    = Cv_EstadoActivo
      AND NDI.PUNTO_ID                  = Cn_IdPunto
      GROUP BY NDI.ID_DOCUMENTO    
    ) NDIP;

    Ln_DiferidoVencido    NUMBER:=0; 
    --
    Lex_Exception         EXCEPTION;
    Lv_MsnError           VARCHAR2 (2000);
    Lv_IpCreacion         VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo       VARCHAR2(20):='Activo';
    Lv_EstadoCerrado      VARCHAR2(20):='Cerrado';

  BEGIN
    IF Fn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    IF C_GetDiferidoVencido%ISOPEN THEN      
      CLOSE C_GetDiferidoVencido;      
    END IF;
    --
    OPEN C_GetDiferidoVencido(Fn_IdPunto, 'NDI', 'telcos_diferido', Lv_EstadoActivo, Lv_EstadoCerrado, 'PROCESO_DIFERIDO');    
    FETCH C_GetDiferidoVencido INTO Ln_DiferidoVencido;    

    CLOSE C_GetDiferidoVencido;    
    RETURN Ln_DiferidoVencido;
    --   
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener el valor total de NDI impagas a la fecha por Punto #IdPunto ' ||  Fn_IdPunto ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_DIFERIDO_VENCIDO',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN Ln_DiferidoVencido;
      --
  END F_GET_DIFERIDO_VENCIDO;  
  --
  --
  --
  FUNCTION F_GET_TOTAL_SALDO_FACTPTO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_TotalSaldoFactPorPto(Cn_PuntoId        NUMBER,
                                  Cv_EmpresaId      VARCHAR2,
                                  Cv_Caracteristica VARCHAR2,
                                  Cn_ValorFactura   NUMBER)
    IS
      SELECT SUM(NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, 
                                                                                 TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                                 'saldo'),2),0 )) AS TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      WHERE IDFC.NUMERO_FACTURA_SRI  IS NOT NULL
      AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
      AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(Cv_EmpresaId,'^\d+')),0)
      AND IDFC.PUNTO_ID              = Cn_PuntoId
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier')
      AND NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, 
                                                                          TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                          'saldo'),2),0 ) > Cn_ValorFactura      
      AND NOT EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
                      AND IDC.DOCUMENTO_ID                  = IDFC.ID_DOCUMENTO
                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA);

    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion VARCHAR2,
                        Cv_EstadoActivo VARCHAR2)
    IS      
      SELECT DET.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO             = Cv_EstadoActivo
      AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
      AND DET.DESCRIPCION        = Cv_Descripcion
      AND DET.ESTADO             = Cv_EstadoActivo; 

    Ln_TotalSaldoFactPorPto  NUMBER:=0;     
    Lex_Exception            EXCEPTION;
    Lv_MsnError              VARCHAR2 (2000);
    Lv_IpCreacion            VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo          VARCHAR2(20):='Activo';    
    Lv_NombreParametro       DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROCESO_EMER_SANITARIA';
    Lv_DescValorFactura      DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'VALOR_FACT_MIN';
    Ln_ValorFactura          NUMBER;

  BEGIN
    IF Fn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    IF C_TotalSaldoFactPorPto%ISOPEN THEN      
      CLOSE C_TotalSaldoFactPorPto;      
    END IF;
    --
    IF C_Parametros%ISOPEN THEN
      CLOSE C_Parametros;
    END IF;
    --
    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescValorFactura,
                      Lv_EstadoActivo);

    FETCH C_Parametros INTO Ln_ValorFactura;

    IF C_Parametros%NOTFOUND THEN
      Lv_MsnError := 'Error al recuperar el par�metro para evaluaci�n de facturas con un valor m�nimo de saldo.';
      RAISE Lex_Exception;  
    END IF;
    CLOSE C_Parametros;
    --    
    OPEN C_TotalSaldoFactPorPto(Fn_IdPunto,
                                '18',
                                'PROCESO_DIFERIDO',
                                Ln_ValorFactura);
    FETCH C_TotalSaldoFactPorPto INTO Ln_TotalSaldoFactPorPto;
    CLOSE C_TotalSaldoFactPorPto;

    RETURN Ln_TotalSaldoFactPorPto;
    --   
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener el total de saldo de Facturas por Punto #IdPunto ' ||  Fn_IdPunto ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_TOTAL_SALDO_FACTPTO',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN Ln_TotalSaldoFactPorPto;
      --
  END F_GET_TOTAL_SALDO_FACTPTO; 
  --
  --
  --  
  FUNCTION F_GET_CANTIDAD_NC_PORPUNTO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_CantidadNcPorPunto(Cn_PuntoId        NUMBER,
                                Cv_EmpresaId      VARCHAR2,
                                Cv_Caracteristica VARCHAR2)
    IS
      SELECT COUNT(*) AS CANTIDAD_FACT_CON_NC
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      WHERE IDFC.NUMERO_FACTURA_SRI  IS NOT NULL
      AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
      AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(Cv_EmpresaId,'^\d+')),0)
      AND IDFC.PUNTO_ID              = Cn_PuntoId
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier','Cerrado')           
      AND DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_NC_FACT(IDFC.ID_DOCUMENTO) > 0         
      AND NOT EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
                      AND IDC.DOCUMENTO_ID                  = IDFC.ID_DOCUMENTO
                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA);

    Ln_CantidadNcPorPunto    NUMBER:=0;     
    Lex_Exception            EXCEPTION;
    Lv_MsnError              VARCHAR2 (2000);
    Lv_IpCreacion            VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo          VARCHAR2(20):='Activo';    

  BEGIN
    IF Fn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    IF C_CantidadNcPorPunto%ISOPEN THEN      
      CLOSE C_CantidadNcPorPunto;      
    END IF;
    --    
    OPEN C_CantidadNcPorPunto(Fn_IdPunto,
                              '18',
                              'PROCESO_DIFERIDO');
    FETCH C_CantidadNcPorPunto INTO Ln_CantidadNcPorPunto;
    CLOSE C_CantidadNcPorPunto;

    RETURN Ln_CantidadNcPorPunto;
    --   
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener la cantidad de Facturas por Punto que entraran al Proceso de Diferido y que poseen NC o NCI #IdPunto '
                     ||  Fn_IdPunto ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_CANTIDAD_NC_PORPUNTO',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN Ln_CantidadNcPorPunto;
      --
  END F_GET_CANTIDAD_NC_PORPUNTO; 
  --
  --
  --
  FUNCTION F_GET_CANTPROC_DIFERIDO_PORPTO(Fn_IdPunto IN  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE)
  RETURN NUMBER
  IS
    CURSOR C_CantProcDiferidoPorPto(Cn_PuntoId              NUMBER,
                                    Cv_EmpresaId            VARCHAR2,
                                    Cv_CaractProcMasivo     VARCHAR2,
                                    Cv_CaractEsSolFact      VARCHAR2,
                                    Cv_EstadoPendiente      VARCHAR2,
                                    Cv_EstadoFinalizada     VARCHAR2,
                                    Cv_DescripcionSolicitud VARCHAR2)
    IS
      SELECT IP.ID_PUNTO,      
      COUNT(*) AS CANTIDAD_PROCESOS
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD DS,
      DB_COMERCIAL.ADMI_TIPO_SOLICITUD TS, 
      DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSC,
      DB_COMERCIAL.ADMI_CARACTERISTICA CA,
      --
      DB_COMERCIAL.INFO_SERVICIO ISE, 
      DB_COMERCIAL.INFO_PUNTO IP,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PERSONA IPE,
      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
      DB_GENERAL.ADMI_ROL AR
      --
      WHERE DS.TIPO_SOLICITUD_ID        = TS.ID_TIPO_SOLICITUD
      AND TS.DESCRIPCION_SOLICITUD      = Cv_DescripcionSolicitud
      AND DS.ID_DETALLE_SOLICITUD       = DSC.DETALLE_SOLICITUD_ID
      AND DSC.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA = Cv_CaractProcMasivo
      AND DS.ESTADO                     IN (Cv_EstadoPendiente,Cv_EstadoFinalizada)
      AND DSC.ESTADO                    IN (Cv_EstadoPendiente,Cv_EstadoFinalizada)
      AND DS.SERVICIO_ID                = ISE.ID_SERVICIO      
      AND ISE.PUNTO_ID                  = IP.ID_PUNTO
      AND IP.ID_PUNTO                   = Cn_PuntoId
      AND IPER.ID_PERSONA_ROL           = IP.PERSONA_EMPRESA_ROL_ID
      AND IPER.PERSONA_ID               = IPE.ID_PERSONA
      AND IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL
      AND IER.ROL_ID                    = AR.ID_ROL
      AND IER.EMPRESA_COD               = Cv_EmpresaId
      AND EXISTS (SELECT DSCARA.ID_SOLICITUD_CARACTERISTICA           
                  FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DSCARA,
                  DB_COMERCIAL.ADMI_CARACTERISTICA CARAC
                  WHERE DSCARA.DETALLE_SOLICITUD_ID     = DS.ID_DETALLE_SOLICITUD 
                  AND DSCARA.CARACTERISTICA_ID          = CARAC.ID_CARACTERISTICA
                  AND CARAC.DESCRIPCION_CARACTERISTICA  = Cv_CaractEsSolFact
                  AND DSCARA.ESTADO                     IN (Cv_EstadoPendiente,Cv_EstadoFinalizada)
                  )
      AND DSC.VALOR NOT IN (SELECT DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(IDFC_CANC.ID_DOCUMENTO, Cv_CaractProcMasivo) 
                            FROM 
                              DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_CANC,
                              DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_CANC,
                              DB_COMERCIAL.ADMI_CARACTERISTICA AC_CANC
                            WHERE IDFC_CANC.ID_DOCUMENTO           = IDC_CANC.DOCUMENTO_ID
                            AND IDFC_CANC.PUNTO_ID                 = IP.ID_PUNTO 
                            AND AC_CANC.ID_CARACTERISTICA          = IDC_CANC.CARACTERISTICA_ID
                            AND IDC_CANC.VALOR                     = 'PRECANCELACION_DEUDA_DIFERIDA'
                            AND AC_CANC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DE_EJECUCION'
      )
      GROUP BY IP.ID_PUNTO;

    Lc_CantProcDiferidoPorPto  C_CantProcDiferidoPorPto%ROWTYPE;
    Lv_DescripcionSolicitud    DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE:='SOLICITUD DIFERIDO DE FACTURA POR EMERGENCIA SANITARIA';
    Ln_CantProcDiferidoPorPto  NUMBER:=0;     
    Lex_Exception              EXCEPTION;
    Lv_MsnError                VARCHAR2 (2000);
    Lv_IpCreacion              VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo            VARCHAR2(20):='Activo';    

  BEGIN
    IF Fn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    IF C_CantProcDiferidoPorPto%ISOPEN THEN      
      CLOSE C_CantProcDiferidoPorPto;      
    END IF;    
    --    
    OPEN C_CantProcDiferidoPorPto(Fn_IdPunto,
                                  '18',
                                  'ES_PROCESO_MASIVO',
                                  'ES_SOL_FACTURA',
                                  'Pendiente',
                                  'Finalizada',
                                  Lv_DescripcionSolicitud);

    FETCH C_CantProcDiferidoPorPto INTO Lc_CantProcDiferidoPorPto;
    CLOSE C_CantProcDiferidoPorPto;
    Ln_CantProcDiferidoPorPto := Lc_CantProcDiferidoPorPto.CANTIDAD_PROCESOS;

    RETURN Ln_CantProcDiferidoPorPto;
    --   
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener la cantidad de Procesos de Diferidos de Facturas por Punto  #IdPunto '||  Fn_IdPunto ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_CANTPROC_DIFERIDO_PORPTO',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN Ln_CantProcDiferidoPorPto;
      --
  END F_GET_CANTPROC_DIFERIDO_PORPTO; 
  --
  --
  --
  PROCEDURE P_CREA_PM_EMER_SANIT(Pv_Observacion              IN  VARCHAR2,
                                 Pv_UsrCreacion              IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                 Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                 Pv_IpCreacion               IN  VARCHAR2,
                                 Pv_TipoPma                  IN  VARCHAR2,
                                 Pn_IdPunto                  IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                 Pv_MsjResultado             OUT VARCHAR2)
  IS  

    Lv_IpCreacion             VARCHAR2(20) := (NVL(Pv_IpCreacion,'127.0.0.1'));
    Ln_IdProcesoMasivoCab     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdProcesoMasivoDet     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;     
    Lr_InfoProcesoMasivoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;    
    Lex_Exception             EXCEPTION;

  BEGIN  
    --    
    Ln_IdProcesoMasivoCab                             := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;
    Lr_InfoProcesoMasivoCab                           := NULL;
    Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB     := Ln_IdProcesoMasivoCab;
    Lr_InfoProcesoMasivoCab.TIPO_PROCESO              := Pv_TipoPma;
    Lr_InfoProcesoMasivoCab.EMPRESA_ID                := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Pv_CodEmpresa,'^\d+')),0);
    Lr_InfoProcesoMasivoCab.CANAL_PAGO_LINEA_ID       := NULL;
    Lr_InfoProcesoMasivoCab.CANTIDAD_PUNTOS           := 0;
    Lr_InfoProcesoMasivoCab.CANTIDAD_SERVICIOS        := 0;
    Lr_InfoProcesoMasivoCab.FACTURAS_RECURRENTES      := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_EMISION_FACTURA     := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_CORTE_DESDE         := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_CORTE_HASTA         := NULL;
    Lr_InfoProcesoMasivoCab.VALOR_DEUDA               := NULL;
    Lr_InfoProcesoMasivoCab.FORMA_PAGO_ID             := NULL;
    Lr_InfoProcesoMasivoCab.IDS_BANCOS_TARJETAS       := NULL;
    Lr_InfoProcesoMasivoCab.IDS_OFICINAS              := NULL;
    Lr_InfoProcesoMasivoCab.ESTADO                    := 'Creado';
    Lr_InfoProcesoMasivoCab.FE_CREACION               := SYSDATE;
    Lr_InfoProcesoMasivoCab.FE_ULT_MOD                := NULL;
    Lr_InfoProcesoMasivoCab.USR_CREACION              := Pv_UsrCreacion;
    Lr_InfoProcesoMasivoCab.USR_ULT_MOD               := NULL;
    Lr_InfoProcesoMasivoCab.IP_CREACION               := Lv_IpCreacion;
    Lr_InfoProcesoMasivoCab.PLAN_ID                   := NULL;
    Lr_InfoProcesoMasivoCab.PLAN_VALOR                := NULL;
    Lr_InfoProcesoMasivoCab.PAGO_ID                   := NULL;
    Lr_InfoProcesoMasivoCab.PAGO_LINEA_ID             := NULL;
    Lr_InfoProcesoMasivoCab.RECAUDACION_ID            := NULL;
    Lr_InfoProcesoMasivoCab.DEBITO_ID                 := NULL;
    Lr_InfoProcesoMasivoCab.ELEMENTO_ID               := NULL;
    Lr_InfoProcesoMasivoCab.SOLICITUD_ID              := NULL;
    --
    DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSERT_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Pv_MsjResultado);
    IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
    --
      RAISE Lex_Exception;
    --
    END IF;
    -- INSERTO DETALLE DE PROCESO MASIVO
    Ln_IdProcesoMasivoDet                            :=DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
    Lr_InfoProcesoMasivoDet                          :=NULL;
    Lr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET    :=Ln_IdProcesoMasivoDet;
    Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID    :=Ln_IdProcesoMasivoCab;

    IF Pn_IdPunto IS NOT NULL THEN
      Ln_IdProcesoMasivoCab := Pn_IdPunto;
    END IF;

    Lr_InfoProcesoMasivoDet.PUNTO_ID                 :=Ln_IdProcesoMasivoCab;
    Lr_InfoProcesoMasivoDet.ESTADO                   :='Pendiente';
    Lr_InfoProcesoMasivoDet.FE_CREACION              :=SYSDATE;
    Lr_InfoProcesoMasivoDet.FE_ULT_MOD               :=NULL;
    Lr_InfoProcesoMasivoDet.USR_CREACION             :=Pv_UsrCreacion;
    Lr_InfoProcesoMasivoDet.USR_ULT_MOD              :=NULL;
    Lr_InfoProcesoMasivoDet.IP_CREACION              :=Lv_IpCreacion;
    Lr_InfoProcesoMasivoDet.SERVICIO_ID              :=NULL;
    Lr_InfoProcesoMasivoDet.OBSERVACION              :=Pv_Observacion;
    Lr_InfoProcesoMasivoDet.SOLICITUD_ID             :=NULL;
    Lr_InfoProcesoMasivoDet.PERSONA_EMPRESA_ROL_ID   :=null;             
    --
    DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSERT_INFO_PROC_MASIVO_DET(Lr_InfoProcesoMasivoDet, Pv_MsjResultado);
    IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
    --
      RAISE Lex_Exception;
    --
    END IF;
    --ACTUALIZO CABECERA DE PROCESO MASIVO A PENDIENTE  
    --
    Lr_InfoProcesoMasivoCab.FE_ULT_MOD        := SYSDATE;
    Lr_InfoProcesoMasivoCab.USR_ULT_MOD       := Pv_UsrCreacion;    
    Lr_InfoProcesoMasivoCab.ESTADO            := 'Pendiente';   

    --
    DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_UPDATE_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Pv_MsjResultado);
    IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
    --
      RAISE Lex_Exception;
    --
    END IF;
    --
    COMMIT;
    Pv_MsjResultado := 'OK';
    EXCEPTION
      WHEN Lex_Exception THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'P_CREA_PM_EMER_SANIT.P_CREA_PM_EMER_SANIT', 
                                             Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                             'telcos_diferido',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
      WHEN OTHERS THEN
      --
        Pv_MsjResultado      := 'Ocurri� un error al guardar el Proceso Masivo '||Pv_TipoPma; 

        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                             'P_CREA_PM_EMER_SANIT.P_CREA_PM_PROMOCIONES', 
                                             Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                             'telcos_diferido',
                                             SYSDATE,
                                             NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
  END P_CREA_PM_EMER_SANIT;


  PROCEDURE P_REPORTE_EMERGENCIA_SANIT (Pv_TipoPma    IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                        Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                        Pv_Estado     IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
                                        Pv_Error      OUT VARCHAR2)
  IS
    --Costo: 6
    CURSOR C_GetProcesoMasivo (Cv_TipoPma    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                               Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Cv_Estado     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE)
    IS
      SELECT IPMC.ID_PROCESO_MASIVO_CAB,
        IPMD.ID_PROCESO_MASIVO_DET,
        IPMD.OBSERVACION,
        IPMC.USR_CREACION
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB IPMC,
        DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET IPMD,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPG
      WHERE IPMC.TIPO_PROCESO        = Cv_TipoPma
      AND IPMC.ESTADO                = Cv_Estado
      AND IPMD.PROCESO_MASIVO_CAB_ID = IPMC.ID_PROCESO_MASIVO_CAB
      AND IPMD.ESTADO                = Cv_Estado
      AND IPMC.EMPRESA_ID            = EMPG.COD_EMPRESA
      AND EMPG.COD_EMPRESA           = Cv_CodEmpresa
      ORDER BY IPMC.FE_CREACION ASC;

    --Costo: 25411876
    CURSOR C_GetPersonaSaldo (Cv_DescRol      VARCHAR2,
                              Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Cv_CodProducto  VARCHAR2,
                              Cv_Estados      VARCHAR2,
                              Cv_Ciclos       VARCHAR2,
                              Cn_SaldoDesde   NUMBER,
                              Cn_SaldoHasta   NUMBER,
                              Cv_FormasPagos  VARCHAR2)
    IS
      SELECT TABLA.ID_PERSONA,
        TABLA.CLIENTE,
        SUM(TRUNC(SALDO.SALDO)) AS SALDO
      FROM DB_FINANCIERO.VISTA_ESTADO_CTA_RESUMIDO_ES SALDO,
        (SELECT DISTINCT
          CASE
          WHEN IPE.RAZON_SOCIAL IS NULL
          THEN IPE.NOMBRES
            ||' '
            || IPE.APELLIDOS
          ELSE IPE.RAZON_SOCIAL
          END AS CLIENTE,
          IPE.ID_PERSONA,
          IP.ID_PUNTO
         FROM DB_COMERCIAL.INFO_SERVICIO ISE,
           DB_COMERCIAL.INFO_PUNTO IP,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_COMERCIAL.INFO_PERSONA IPE,
           DB_COMERCIAL.INFO_EMPRESA_ROL IER,
           DB_GENERAL.ADMI_ROL AR, 
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO, 
           DB_COMERCIAL.ADMI_CARACTERISTICA CARAC, 
           DB_FINANCIERO.ADMI_CICLO ADMCICLO,
           DB_COMERCIAL.ADMI_PRODUCTO AP,
           DB_COMERCIAL.INFO_PLAN_DET IPD,
           DB_COMERCIAL.INFO_CONTRATO CONT
         WHERE AR.DESCRIPCION_ROL              = Cv_DescRol
         AND IER.ROL_ID                        = AR.ID_ROL 
         AND IER.EMPRESA_COD                   = Cv_CodEmpresa
         AND IPER.EMPRESA_ROL_ID               = IER.ID_EMPRESA_ROL
         AND IPE.ID_PERSONA                    = IPER.PERSONA_ID
         AND NOT EXISTS (SELECT IPERC.ID_PERSONA_EMPRESA_ROL_CARACT 
                         FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
                           DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                         WHERE IPERC.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
                         AND DBAC.ID_CARACTERISTICA           = IPERC.CARACTERISTICA_ID
                         AND DBAC.DESCRIPCION_CARACTERISTICA  = 'PROCESO_DIFERIDO'
                         AND IPERC.ESTADO                     = 'Activo')
         AND CICLO.PERSONA_EMPRESA_ROL_ID      = IPER.ID_PERSONA_ROL
         AND CICLO.ESTADO                      = 'Activo'
         AND CARAC.ID_CARACTERISTICA           = CICLO.CARACTERISTICA_ID
         AND CARAC.DESCRIPCION_CARACTERISTICA  = 'CICLO_FACTURACION'
         AND ADMCICLO.ID_CICLO                 = COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,'^\d+')),0) 
         AND ADMCICLO.ID_CICLO                 IN (SELECT REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                   CONNECT BY REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) IS NOT NULL)
         AND CONT.PERSONA_EMPRESA_ROL_ID       = IPER.ID_PERSONA_ROL
         AND CONT.FORMA_PAGO_ID                IN (SELECT REGEXP_SUBSTR (Cv_FormasPagos,'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                   CONNECT BY REGEXP_SUBSTR (Cv_FormasPagos,'[^,]+',1, LEVEL) IS NOT NULL)
         AND CONT.ESTADO                       = 'Activo'
         AND IP.PERSONA_EMPRESA_ROL_ID         = IPER.ID_PERSONA_ROL
         AND ISE.PUNTO_ID                      = IP.ID_PUNTO
         AND ISE.ESTADO                        IN (SELECT REGEXP_SUBSTR (Cv_Estados,'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                   CONNECT BY REGEXP_SUBSTR (Cv_Estados,'[^,]+',1, LEVEL) IS NOT NULL)   
        AND IPD.PLAN_ID                        = ISE.PLAN_ID 
        AND AP.ID_PRODUCTO                     = IPD.PRODUCTO_ID
        AND AP.CODIGO_PRODUCTO                 = Cv_CodProducto)TABLA
      WHERE SALDO.PUNTO_ID = TABLA.ID_PUNTO
      AND SALDO.SALDO      > 0
      GROUP BY TABLA.ID_PERSONA,
               TABLA.CLIENTE
      HAVING SUM(TRUNC(SALDO.SALDO)) BETWEEN Cn_SaldoDesde AND Cn_SaldoHasta
      ORDER BY TABLA.CLIENTE;

    --Costo: 35
    CURSOR C_DatosCliente (Cn_IdPersona    DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                           Cv_DescRol      VARCHAR2,
                           Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                           Cv_CodProducto  VARCHAR2,
                           Cv_Estados      VARCHAR2,
                           Cv_Ciclos       VARCHAR2)
    IS
      SELECT DISTINCT
        CASE
        WHEN IPE.RAZON_SOCIAL IS NULL
        THEN IPE.NOMBRES
          ||' '
          || IPE.APELLIDOS
        ELSE IPE.RAZON_SOCIAL
        END AS CLIENTE,
        IPE.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
        IP.LOGIN,
        ISE.ESTADO AS ESTADO_SERVICIO,
        (SELECT DBAJ.NOMBRE_JURISDICCION 
         FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION DBAJ 
         WHERE ID_JURISDICCION = IP.PUNTO_COBERTURA_ID) AS JURISDICCION,
        DB_FINANCIERO.FNCK_CONSULTS.F_GET_FORMA_PAGO_CONTRATO(IPER.ID_PERSONA_ROL) AS FORMA_PAGO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_BANCO', IPER.ID_PERSONA_ROL) AS BANCO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_TIPO_CUENTA', IPER.ID_PERSONA_ROL) AS TIPO_CUENTA,
        IP.ID_PUNTO
      FROM
        DB_COMERCIAL.INFO_SERVICIO ISE,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR, 
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO, 
        DB_COMERCIAL.ADMI_CARACTERISTICA CARAC, 
        DB_FINANCIERO.ADMI_CICLO ADMCICLO,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.INFO_PLAN_DET IPD
      WHERE AR.DESCRIPCION_ROL              = Cv_DescRol
      AND IER.ROL_ID                        = AR.ID_ROL 
      AND IER.EMPRESA_COD                   = Cv_CodEmpresa
      AND IPER.EMPRESA_ROL_ID               = IER.ID_EMPRESA_ROL
      AND IPE.ID_PERSONA                    = IPER.PERSONA_ID
      AND CICLO.PERSONA_EMPRESA_ROL_ID      = IPER.ID_PERSONA_ROL
      AND CICLO.ESTADO                      = 'Activo'
      AND CARAC.ID_CARACTERISTICA           = CICLO.CARACTERISTICA_ID
      AND CARAC.DESCRIPCION_CARACTERISTICA  = 'CICLO_FACTURACION'
      AND ADMCICLO.ID_CICLO                 = COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,'^\d+')),0) 
      AND ADMCICLO.ID_CICLO                 IN (SELECT REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                CONNECT BY REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) IS NOT NULL)
      AND IP.PERSONA_EMPRESA_ROL_ID         = IPER.ID_PERSONA_ROL
      AND ISE.PUNTO_ID                      = IP.ID_PUNTO
      AND ISE.ESTADO                        IN (SELECT REGEXP_SUBSTR (Cv_Estados,'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                CONNECT BY REGEXP_SUBSTR (Cv_Estados,'[^,]+',1, LEVEL) IS NOT NULL)
      AND IPD.PLAN_ID                        = ISE.PLAN_ID 
      AND AP.ID_PRODUCTO                     = IPD.PRODUCTO_ID
      AND AP.CODIGO_PRODUCTO                 = Cv_CodProducto
      AND IPE.ID_PERSONA                     = Cn_IdPersona;

    --Costo: 3      
    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion VARCHAR2,
                        Cv_EstadoActivo VARCHAR2)
    IS      
      SELECT DET.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO             = Cv_EstadoActivo
      AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
      AND DET.DESCRIPCION        = Cv_Descripcion
      AND DET.ESTADO             = Cv_EstadoActivo;

    --Costo: 6
    CURSOR C_Ciclos (Cv_Ciclos VARCHAR2)
    IS
      SELECT DISTINCT LISTAGG(CODIGO, ',') 
      WITHIN GROUP (ORDER BY CODIGO) OVER (PARTITION BY GRUPO) CICLOS
      FROM 
      (SELECT DBAC.CODIGO, '1' AS GRUPO
      FROM DB_FINANCIERO.ADMI_CICLO DBAC
      WHERE DBAC.ID_CICLO IN (SELECT REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) VALOR FROM DUAL
                              CONNECT BY REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) IS NOT NULL))TABLA;

    --Costo: 15
    CURSOR C_TotalSaldoFactPorPto(Cn_PuntoId        NUMBER,
                                  Cv_EmpresaId      VARCHAR2,
                                  Cv_Caracteristica VARCHAR2,
                                  Cn_ValorFactura   NUMBER)
    IS
      SELECT SUM(NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, 
                                                                                 TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                                 'saldo'),2),0 )) AS TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      WHERE IDFC.NUMERO_FACTURA_SRI  IS NOT NULL
      AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
      AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(Cv_EmpresaId,'^\d+')),0)
      AND IDFC.PUNTO_ID              = Cn_PuntoId
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier')
      AND NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, 
                                                                          TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                          'saldo'),2),0 ) > Cn_ValorFactura
      AND DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_NC_FACT(IDFC.ID_DOCUMENTO) = 0
      AND NOT EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
                      AND IDC.DOCUMENTO_ID                  = IDFC.ID_DOCUMENTO
                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA);
    --
    Lv_IpCreacion             VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio             VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador            VARCHAR2(1)     := ',';
    Lv_Remitente              VARCHAR2(100)   := 'notificaciones_telcos@telconet.ec';
    Lv_NombrePlantilla        VARCHAR2(3200);
    Lv_Asunto                 VARCHAR2(300);
    Lv_Cuerpo                 VARCHAR2(9999); 
    Lv_FechaReporte           VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo          VARCHAR2(150);
    Lv_NombreArchivoZip       VARCHAR2(250);
    Lv_Gzip                   VARCHAR2(100);
    Lv_AliasCorreos           VARCHAR2(500);
    Lv_Destinatario           VARCHAR2(500);
    Lv_User                   VARCHAR2(1000) := 'telcos_diferido';
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_Trama                  VARCHAR2(3200);
    Lv_Valor                  VARCHAR2(3200);
    Lv_SaldoDesde             VARCHAR2(3200);
    Lv_SaldoHasta             VARCHAR2(3200);
    Lv_MesDiferido            VARCHAR2(3200);
    Lv_Ciclos                 VARCHAR2(3200);
    Lv_DescCiclos             VARCHAR2(3200);
    Lv_Estados                VARCHAR2(3200);
    Lv_ValorFormaPago         VARCHAR2(3200);
    Lv_NombreReporte          VARCHAR2(3200);
    Lv_DescReporte            VARCHAR2(3200);
    Lv_EstadoActivo           DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro        DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROCESO_EMER_SANITARIA';
    Lv_DescFormaPago          DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'VALOR_FORMAS_DE_PAGO';    
    Lv_DescCantidadFacturas   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'FACTURAS_MINIMA';
    Lv_DescValorFactura       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'VALOR_FACT_MIN';
    Lv_CodProducto            VARCHAR2(4) := 'INTD';
    Ln_Posicion               NUMBER;
    Ln_Indx                   NUMBER;
    Ln_SaldoDiferir           NUMBER;
    Ln_CantidadFacturas       NUMBER;
    Ln_ValorFactura           NUMBER;
    Lc_GetAliasPlantilla      DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo             UTL_FILE.FILE_TYPE;
    La_RegistrosPersonas      T_RegistrosPersonas;
    Ln_Limit                  CONSTANT PLS_INTEGER DEFAULT 5000;
    Lc_GetProcesoMasivo       C_GetProcesoMasivo%ROWTYPE;
    Lv_DescripcionRol         DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE := 'Cliente';
    Lex_Exception             EXCEPTION;
    Le_Exception              EXCEPTION;

  BEGIN

    IF C_GetProcesoMasivo%ISOPEN THEN
      CLOSE C_GetProcesoMasivo;
    END IF;

    IF C_TotalSaldoFactPorPto%ISOPEN THEN
      CLOSE C_TotalSaldoFactPorPto;
    END IF;

    IF C_Ciclos%ISOPEN THEN
      CLOSE C_Ciclos;
    END IF;

    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescFormaPago,
                      Lv_EstadoActivo);
    FETCH C_Parametros 
      INTO Lv_ValorFormaPago;

      IF C_Parametros%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar el par�metro para evaluaci�n de formas de pagos.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescCantidadFacturas,
                      Lv_EstadoActivo);
    FETCH C_Parametros 
      INTO Ln_CantidadFacturas;

      IF C_Parametros%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar el par�metro para evaluaci�n de la cantidad m�nima de facturas por punto.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescValorFactura,
                      Lv_EstadoActivo);
    FETCH C_Parametros 
      INTO Ln_ValorFactura;

      IF C_Parametros%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar el par�metro para evaluaci�n de facturas con un valor m�nimo de saldo.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;
    --

    IF Pv_TipoPma = 'ReporteEmerSanit' THEN
      Lv_NombrePlantilla := 'RPT_EMER_SANIT';
    ELSE
      Lv_NombrePlantilla := 'RPT_PREV_SOL_ES';
    END IF;

    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_NombrePlantilla);
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
    Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';
    --

    OPEN C_GetProcesoMasivo(Pv_TipoPma,
                            Pv_CodEmpresa,
                            Pv_Estado);
    FETCH C_GetProcesoMasivo 
      INTO Lc_GetProcesoMasivo;

      IF C_GetProcesoMasivo%NOTFOUND THEN
        RAISE Le_Exception;
      END IF;

      Lv_Trama := Lc_GetProcesoMasivo.observacion;

      WHILE NVL(LENGTH(Lv_Trama),0) > 0 LOOP

        Ln_Posicion := INSTR(Lv_Trama, '|' );

        IF Ln_Posicion > 0 THEN

          Lv_Valor := SUBSTR(Lv_Trama,1, Ln_Posicion-1);

        IF INSTR(Lv_Valor,'SALDO_DESDE',1) > 0 THEN
          Lv_SaldoDesde := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        IF INSTR(Lv_Valor,'SALDO_HASTA',1) > 0 THEN
          Lv_SaldoHasta := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        IF INSTR(Lv_Valor,'MES_DIFERIDO',1) > 0 THEN
          Lv_MesDiferido := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        IF INSTR(Lv_Valor,'CICLO',1) > 0 THEN
          Lv_Ciclos := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        IF INSTR(Lv_Valor,'ESTADO_SERVICIO',1) > 0 THEN
          Lv_Estados := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        Lv_Trama := SUBSTR(Lv_Trama,Ln_Posicion+1);

       ELSE

         Lv_Trama := NULL;

       END IF;

      END LOOP;

      IF Lv_SaldoDesde IS NULL OR Lv_SaldoHasta IS NULL OR Lv_MesDiferido IS NULL
         OR Lv_Ciclos IS NULL OR Lv_Estados IS NULL THEN
        Lv_MsjResultado := 'Error al recuperar los par�metros para evaluaci�n de diferido por emergencia sanitaria. '
                           || 'Lv_SaldoDesde: '|| Lv_SaldoDesde || ',Lv_SaldoHasta: '|| Lv_SaldoHasta
                           || ',Lv_MesDiferido: '|| Lv_MesDiferido || ',Lv_Ciclos: '|| Lv_Ciclos
                           || ',Lv_Estados: '|| Lv_Estados;
        RAISE Lex_Exception;   
      END IF;

      OPEN C_Ciclos(Lv_Ciclos);
      FETCH C_Ciclos 
        INTO Lv_DescCiclos;
      CLOSE C_Ciclos;

      IF Pv_TipoPma = 'ReporteEmerSanit' THEN
        Lv_NombreReporte := 'RptPrevioEmerSanit_';
        Lv_DescReporte   := 'REPORTE PREVIO DE DIFERIDOS POR EMERGENCIA SANITARIA';
        Lv_Asunto        := 'Reporte Previo de Diferidos por Emergencia Sanitaria';

      ELSE
        Lv_NombreReporte := 'RptPrevioCreacionSol_'||Lc_GetProcesoMasivo.ID_PROCESO_MASIVO_CAB||'_';
        Lv_DescReporte   := 'REPORTE PREVIO DE CREACI�N DE SOLICITUDES POR EMERGENCIA SANITARIA';
        Lv_Asunto        := 'Reporte Previo de Creaci�n de Solicitudes por Emergencia Sanitaria';
      END IF;

      Lv_NombreArchivo     := Lv_NombreReporte||Lc_GetProcesoMasivo.USR_CREACION||'_'||Lv_FechaReporte||'.csv';
      Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
      Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

      utl_file.put_line(Lfile_Archivo,''||Lv_Delimitador||
                        ''||Lv_Delimitador||
                        ''||Lv_Delimitador||
                        Lv_DescReporte||Lv_Delimitador);
      utl_file.put_line(Lfile_Archivo,''||Lv_Delimitador);
      utl_file.put_line(Lfile_Archivo,'SALDO DESDE: '||Lv_SaldoDesde||Lv_Delimitador
                        ||''||Lv_Delimitador
                        ||'SALDO HASTA: '||Lv_SaldoHasta);
      utl_file.put_line(Lfile_Archivo,'CICLO FACTURACI�N: '||REPLACE(Lv_DescCiclos,',',' ')||Lv_Delimitador
                         ||''||Lv_Delimitador
                        ||'MESES A DIFERIR: '||Lv_MesDiferido);
      utl_file.put_line(Lfile_Archivo,'ESTADO SERVICIO: '||REPLACE(Lv_Estados,',',' '));
      utl_file.put_line(Lfile_Archivo,''||Lv_Delimitador);

      IF Pv_TipoPma = 'ReporteEmerSanit' THEN
        utl_file.put_line(Lfile_Archivo,'IDENTIFICACI�N'||Lv_Delimitador 
                        ||'LOGIN'||Lv_Delimitador  
                        ||'NOMBRE'||Lv_Delimitador 
                        ||'ESTADO SERVICIO'||Lv_Delimitador     
                        ||'JURISDICCI�N'||Lv_Delimitador 
                        ||'FORMA DE PAGO'||Lv_Delimitador
                        ||'BANCO'||Lv_Delimitador
                        ||'TIPO CUENTA'||Lv_Delimitador                   
                        ||'SALDO A DIFERIR'||Lv_Delimitador
                        ||'N�MERO DIFERIDO'||Lv_Delimitador);
      ELSE
        utl_file.put_line(Lfile_Archivo,'IDENTIFICACI�N'||Lv_Delimitador 
                        ||'LOGIN'||Lv_Delimitador  
                        ||'NOMBRE'||Lv_Delimitador 
                        ||'ESTADO SERVICIO'||Lv_Delimitador     
                        ||'JURISDICCI�N'||Lv_Delimitador 
                        ||'FORMA DE PAGO'||Lv_Delimitador
                        ||'BANCO'||Lv_Delimitador
                        ||'TIPO CUENTA'||Lv_Delimitador                   
                        ||'SALDO A DIFERIR'||Lv_Delimitador
                        ||'N�MERO DIFERIDO'||Lv_Delimitador
                        ||'PROCESO MASIVO'||Lv_Delimitador);
      END IF;     

      OPEN C_GetPersonaSaldo(Lv_DescripcionRol,
                             Pv_CodEmpresa,
                             Lv_CodProducto,
                             Lv_Estados,
                             Lv_Ciclos,
                             Lv_SaldoDesde,
                             Lv_SaldoHasta,
                             Lv_ValorFormaPago);
      LOOP
        FETCH C_GetPersonaSaldo BULK COLLECT INTO La_RegistrosPersonas LIMIT Ln_Limit;
        -- 
        Ln_Indx := La_RegistrosPersonas.FIRST;
        --
        EXIT WHEN La_RegistrosPersonas.COUNT = 0;
        --
        WHILE (Ln_Indx IS NOT NULL)  
        LOOP

          FOR Lr_DatosCliente IN C_DatosCliente (La_RegistrosPersonas(Ln_Indx).ID_PERSONA,
                                                 Lv_DescripcionRol,
                                                 Pv_CodEmpresa,
                                                 Lv_CodProducto,
                                                 Lv_Estados,
                                                 Lv_Ciclos) LOOP

            OPEN C_TotalSaldoFactPorPto(Lr_DatosCliente.ID_PUNTO,
                                        Pv_CodEmpresa,
                                        'PROCESO_DIFERIDO',
                                        Ln_ValorFactura);
            FETCH C_TotalSaldoFactPorPto 
              INTO Ln_SaldoDiferir;
            CLOSE C_TotalSaldoFactPorPto;

            IF (Ln_SaldoDiferir > 0 AND
                DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_FACTURA (Fn_IdPunto         => Lr_DatosCliente.ID_PUNTO,
                                                                       Fv_CodEmpresa      => Pv_CodEmpresa,
                                                                       Fv_Caracteristica  => 'PROCESO_DIFERIDO',
                                                                       Fn_CostoMininoFact => Ln_ValorFactura) >= Ln_CantidadFacturas) THEN
              IF Pv_TipoPma = 'ReporteEmerSanit' THEN
                UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_DatosCliente.IDENTIFICACION, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.LOGIN, '')||Lv_Delimitador
                                ||NVL(REPLACE(REPLACE(Lr_DatosCliente.CLIENTE,',',''),'"',''), '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.ESTADO_SERVICIO, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.JURISDICCION, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.FORMA_PAGO, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.BANCO, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.TIPO_CUENTA, '')||Lv_Delimitador
                                ||NVL(REPLACE(Ln_SaldoDiferir,',','.'), '')||Lv_Delimitador
                                ||NVL(Lv_MesDiferido, '')||Lv_Delimitador);
              ELSE
                UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_DatosCliente.IDENTIFICACION, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.LOGIN, '')||Lv_Delimitador
                                ||NVL(REPLACE(REPLACE(Lr_DatosCliente.CLIENTE,',',''),'"',''), '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.ESTADO_SERVICIO, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.JURISDICCION, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.FORMA_PAGO, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.BANCO, '')||Lv_Delimitador
                                ||NVL(Lr_DatosCliente.TIPO_CUENTA, '')||Lv_Delimitador
                                ||NVL(REPLACE(Ln_SaldoDiferir,',','.'), '')||Lv_Delimitador
                                ||NVL(Lv_MesDiferido, '')||Lv_Delimitador
                                ||'PM_'||NVL(Lc_GetProcesoMasivo.ID_PROCESO_MASIVO_CAB, '')||Lv_Delimitador);
              END IF;
            END IF;

          END LOOP;

          Ln_Indx := La_RegistrosPersonas.NEXT(Ln_Indx);
        END LOOP;
        --
      END LOOP;
      --
      CLOSE C_GetPersonaSaldo;

      UTL_FILE.fclose(Lfile_Archivo);
      DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;
      DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                                Lv_Destinatario,
                                                Lv_Asunto, 
                                                Lv_Cuerpo, 
                                                Lv_Directorio,
                                                Lv_NombreArchivoZip,
                                                'text/html; charset=UTF-8');

      UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);

      IF Pv_TipoPma = 'ReporteEmerSanit' THEN
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
        SET ESTADO    = 'Finalizado',
          USR_ULT_MOD = Lv_User,
          FE_ULT_MOD  = SYSDATE
        WHERE ID_PROCESO_MASIVO_DET = Lc_GetProcesoMasivo.ID_PROCESO_MASIVO_DET;

        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
        SET ESTADO    = 'Finalizado',
          USR_ULT_MOD = Lv_User,
          FE_ULT_MOD  = SYSDATE
        WHERE ID_PROCESO_MASIVO_CAB = Lc_GetProcesoMasivo.ID_PROCESO_MASIVO_CAB; 
      END IF;
    CLOSE C_GetProcesoMasivo;

    COMMIT;

  EXCEPTION
    WHEN Le_Exception THEN
      --
      Lv_MsjResultado := 'No hay data para procesar.';
      Pv_Error        := Lv_MsjResultado;

    WHEN Lex_Exception THEN
      --
      Pv_Error        := Lv_MsjResultado;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_REPORTE_EMERGENCIA_SANIT', 
                                           Lv_MsjResultado,
                                           Lv_User,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    WHEN OTHERS THEN
      --
      Lv_MsjResultado := 'Ocurri� un error al ejecutar el Proceso Masivo '||Pv_TipoPma;
      Pv_Error        := Lv_MsjResultado;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_REPORTE_EMERGENCIA_SANIT', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           Lv_User,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));            
  END P_REPORTE_EMERGENCIA_SANIT;

  PROCEDURE P_CREA_SOLICITUDES_NCI (Pv_TipoPma            IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                    Pv_CodEmpresa         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Pv_Estado             IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
                                    Pn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE DEFAULT NULL,
                                    Pv_MsjResultado       OUT VARCHAR2,
                                    Pn_IdProcesoMasivoCab OUT DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
  IS
    --Costo: 6
    CURSOR C_GetProcesoMasivo (Cv_TipoPma    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                               Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Cv_Estado     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE,
                               Cn_IdPunto    DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    IS
      SELECT IPMC.ID_PROCESO_MASIVO_CAB,
        IPMD.ID_PROCESO_MASIVO_DET,
        IPMD.OBSERVACION,
        IPMC.USR_CREACION
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB IPMC,
        DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET IPMD,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPG
      WHERE IPMC.TIPO_PROCESO        = Cv_TipoPma
      AND IPMC.ESTADO                = Cv_Estado
      AND IPMD.PROCESO_MASIVO_CAB_ID = IPMC.ID_PROCESO_MASIVO_CAB
      AND IPMD.ESTADO                = Cv_Estado
      AND IPMC.EMPRESA_ID            = EMPG.COD_EMPRESA
      AND EMPG.COD_EMPRESA           = Cv_CodEmpresa
      AND IPMD.PUNTO_ID              = NVL(Cn_IdPunto,IPMD.PUNTO_ID)
      ORDER BY IPMC.FE_CREACION ASC;

    --Costo: 25411876
    CURSOR C_GetPersonaSaldo (Cv_DescRol      VARCHAR2,
                              Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Cv_CodProducto  VARCHAR2,
                              Cv_Estados      VARCHAR2,
                              Cv_Ciclos       VARCHAR2,
                              Cn_SaldoDesde   NUMBER,
                              Cn_SaldoHasta   NUMBER,
                              Cv_FormasPagos  VARCHAR2)
    IS
      SELECT TABLA.ID_PERSONA,
        TABLA.CLIENTE,
        SUM(TRUNC(SALDO.SALDO)) AS SALDO
      FROM DB_FINANCIERO.VISTA_ESTADO_CTA_RESUMIDO_ES SALDO,
        (SELECT DISTINCT
          CASE
          WHEN IPE.RAZON_SOCIAL IS NULL
          THEN IPE.NOMBRES
            ||' '
            || IPE.APELLIDOS
          ELSE IPE.RAZON_SOCIAL
          END AS CLIENTE,
          IPE.ID_PERSONA,
          IP.ID_PUNTO
         FROM DB_COMERCIAL.INFO_SERVICIO ISE,
           DB_COMERCIAL.INFO_PUNTO IP,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
           DB_COMERCIAL.INFO_PERSONA IPE,
           DB_COMERCIAL.INFO_EMPRESA_ROL IER,
           DB_GENERAL.ADMI_ROL AR, 
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO, 
           DB_COMERCIAL.ADMI_CARACTERISTICA CARAC, 
           DB_FINANCIERO.ADMI_CICLO ADMCICLO,
           DB_COMERCIAL.ADMI_PRODUCTO AP,
           DB_COMERCIAL.INFO_PLAN_DET IPD,
           DB_COMERCIAL.INFO_CONTRATO CONT
         WHERE AR.DESCRIPCION_ROL              = Cv_DescRol
         AND IER.ROL_ID                        = AR.ID_ROL 
         AND IER.EMPRESA_COD                   = Cv_CodEmpresa
         AND IPER.EMPRESA_ROL_ID               = IER.ID_EMPRESA_ROL
         AND IPE.ID_PERSONA                    = IPER.PERSONA_ID
         AND NOT EXISTS (SELECT IPERC.ID_PERSONA_EMPRESA_ROL_CARACT 
                         FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC,
                           DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                         WHERE IPERC.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
                         AND DBAC.ID_CARACTERISTICA           = IPERC.CARACTERISTICA_ID
                         AND DBAC.DESCRIPCION_CARACTERISTICA  = 'PROCESO_DIFERIDO'
                         AND IPERC.ESTADO                     = 'Activo')
         AND CICLO.PERSONA_EMPRESA_ROL_ID      = IPER.ID_PERSONA_ROL
         AND CICLO.ESTADO                      = 'Activo'
         AND CARAC.ID_CARACTERISTICA           = CICLO.CARACTERISTICA_ID
         AND CARAC.DESCRIPCION_CARACTERISTICA  = 'CICLO_FACTURACION'
         AND ADMCICLO.ID_CICLO                 = COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,'^\d+')),0) 
         AND ADMCICLO.ID_CICLO                 IN (SELECT REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                   CONNECT BY REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) IS NOT NULL)
         AND CONT.PERSONA_EMPRESA_ROL_ID       = IPER.ID_PERSONA_ROL
         AND CONT.FORMA_PAGO_ID                IN (SELECT REGEXP_SUBSTR (Cv_FormasPagos,'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                   CONNECT BY REGEXP_SUBSTR (Cv_FormasPagos,'[^,]+',1, LEVEL) IS NOT NULL)
         AND CONT.ESTADO                       = 'Activo'
         AND IP.PERSONA_EMPRESA_ROL_ID         = IPER.ID_PERSONA_ROL
         AND ISE.PUNTO_ID                      = IP.ID_PUNTO
         AND ISE.ESTADO                        IN (SELECT REGEXP_SUBSTR (Cv_Estados,'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                   CONNECT BY REGEXP_SUBSTR (Cv_Estados,'[^,]+',1, LEVEL) IS NOT NULL)   
        AND IPD.PLAN_ID                        = ISE.PLAN_ID 
        AND AP.ID_PRODUCTO                     = IPD.PRODUCTO_ID
        AND AP.CODIGO_PRODUCTO                 = Cv_CodProducto)TABLA
      WHERE SALDO.PUNTO_ID = TABLA.ID_PUNTO
      AND SALDO.SALDO      > 0
      GROUP BY TABLA.ID_PERSONA,
               TABLA.CLIENTE
      HAVING SUM(TRUNC(SALDO.SALDO)) BETWEEN Cn_SaldoDesde AND Cn_SaldoHasta
      ORDER BY TABLA.CLIENTE;

    --Costo: 30
    CURSOR C_DatosCliente (Cn_IdPersona    DB_COMERCIAL.INFO_PERSONA.ID_PERSONA%TYPE,
                           Cv_DescRol      VARCHAR2,
                           Cv_CodEmpresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                           Cv_CodProducto  VARCHAR2,
                           Cv_Estados      VARCHAR2,
                           Cv_Ciclos       VARCHAR2,
                           Cn_IdPunto      NUMBER)
    IS
      SELECT DISTINCT IP.ID_PUNTO,
        ISE.ID_SERVICIO,
        IPER.ID_PERSONA_ROL,
        IPER.ESTADO AS ESTADO_CLIENTE
      FROM
        DB_COMERCIAL.INFO_SERVICIO ISE,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR, 
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO, 
        DB_COMERCIAL.ADMI_CARACTERISTICA CARAC, 
        DB_FINANCIERO.ADMI_CICLO ADMCICLO,
        DB_COMERCIAL.ADMI_PRODUCTO AP,
        DB_COMERCIAL.INFO_PLAN_DET IPD
      WHERE AR.DESCRIPCION_ROL              = Cv_DescRol
      AND IER.ROL_ID                        = AR.ID_ROL 
      AND IER.EMPRESA_COD                   = Cv_CodEmpresa
      AND IPER.EMPRESA_ROL_ID               = IER.ID_EMPRESA_ROL
      AND IPE.ID_PERSONA                    = IPER.PERSONA_ID
      AND CICLO.PERSONA_EMPRESA_ROL_ID      = IPER.ID_PERSONA_ROL
      AND CICLO.ESTADO                      = 'Activo'
      AND CARAC.ID_CARACTERISTICA           = CICLO.CARACTERISTICA_ID
      AND CARAC.DESCRIPCION_CARACTERISTICA  = 'CICLO_FACTURACION'
      AND ADMCICLO.ID_CICLO                 = COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,'^\d+')),0) 
      AND ADMCICLO.ID_CICLO                 IN (SELECT REGEXP_SUBSTR (NVL(Cv_Ciclos,CICLO.VALOR),'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                CONNECT BY REGEXP_SUBSTR (NVL(Cv_Ciclos,CICLO.VALOR),'[^,]+',1, LEVEL) IS NOT NULL)
      AND IP.PERSONA_EMPRESA_ROL_ID         = IPER.ID_PERSONA_ROL
      AND ISE.PUNTO_ID                      = IP.ID_PUNTO
      AND IP.ID_PUNTO                       = NVL(Cn_IdPunto,IP.ID_PUNTO)
      AND ISE.ESTADO                        IN (SELECT REGEXP_SUBSTR (NVL(Cv_Estados, ISE.ESTADO ),'[^,]+',1, LEVEL) VALOR FROM DUAL
                                                CONNECT BY REGEXP_SUBSTR (NVL(Cv_Estados, ISE.ESTADO ),'[^,]+',1, LEVEL) IS NOT NULL)
      AND IPD.PLAN_ID                        = ISE.PLAN_ID 
      AND AP.ID_PRODUCTO                     = IPD.PRODUCTO_ID
      AND AP.CODIGO_PRODUCTO                 = Cv_CodProducto
      AND IPE.ID_PERSONA                     = Cn_IdPersona;

    --Costo: 15
    CURSOR C_Facturas(Cn_EmpresaId      NUMBER,
                      Cn_PuntoId        NUMBER,
                      Cv_Caracteristica VARCHAR2,
                      Cn_ValorFactura   NUMBER)
    IS
      SELECT IDFC.ID_DOCUMENTO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      WHERE IDFC.NUMERO_FACTURA_SRI  IS NOT NULL
      AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
      AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(Cn_EmpresaId,'^\d+')),0)
      AND IDFC.PUNTO_ID              = Cn_PuntoId
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier')
      AND NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, 
                                                                          TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                          'saldo'),2),0 ) > Cn_ValorFactura
      AND DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_NC_FACT(IDFC.ID_DOCUMENTO) = 0
      AND NOT EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
                      AND IDC.DOCUMENTO_ID                  = IDFC.ID_DOCUMENTO
                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA)
      ORDER BY IDFC.FE_CREACION ASC;

    --Costo: 3
    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Descripcion VARCHAR2,
                        Cv_EstadoActivo VARCHAR2)
    IS      
      SELECT DET.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE CAB.NOMBRE_PARAMETRO = Cv_NombreParametro
      AND CAB.ESTADO             = Cv_EstadoActivo
      AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
      AND DET.DESCRIPCION        = Cv_Descripcion
      AND DET.ESTADO             = Cv_EstadoActivo;

    --Costo: 2
    CURSOR C_ObtieneMotivoSolicitud(Cv_EstadoMotivo   DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE,
                                    Cv_NombreMotivo   DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE)
    IS  
      SELECT ID_MOTIVO 
      FROM DB_GENERAL.ADMI_MOTIVO 
      WHERE NOMBRE_MOTIVO = Cv_NombreMotivo 
      AND ESTADO          = Cv_EstadoMotivo;

    --Costo: 2
    CURSOR C_ObtieneTipoSolicitud(Cv_Estado          DB_COMERCIAL.ADMI_TIPO_SOLICITUD.ESTADO%TYPE,
                                  Cv_NombreSilicitud DB_COMERCIAL.ADMI_TIPO_SOLICITUD.DESCRIPCION_SOLICITUD%TYPE)
    IS       
      SELECT ATS.ID_TIPO_SOLICITUD
      FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
      WHERE ATS.DESCRIPCION_SOLICITUD = Cv_NombreSilicitud
      AND ATS.ESTADO                  = Cv_Estado;

    --Costo: 2
    CURSOR C_ObtieneIdCarac(Cv_Estado      DB_COMERCIAL.ADMI_CARACTERISTICA.ESTADO%TYPE,
                            Cv_NombreCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS 
      SELECT DBAC.ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
      WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_NombreCarac
      AND DBAC.ESTADO                       = Cv_Estado;

    --Costo: 6
    CURSOR C_Ciclos (Cv_Ciclos VARCHAR2)
    IS
      SELECT DISTINCT LISTAGG(CODIGO, ',') 
      WITHIN GROUP (ORDER BY CODIGO) OVER (PARTITION BY GRUPO) CICLOS
      FROM 
      (SELECT DBAC.CODIGO, '1' AS GRUPO
      FROM DB_FINANCIERO.ADMI_CICLO DBAC
      WHERE DBAC.ID_CICLO IN (SELECT REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) VALOR FROM DUAL
                              CONNECT BY REGEXP_SUBSTR (Cv_Ciclos,'[^,]+',1, LEVEL) IS NOT NULL))TABLA;

    --Costo: 15
    CURSOR C_TotalSaldoFactPorPto(Cn_PuntoId        NUMBER,
                                  Cv_EmpresaId      VARCHAR2,
                                  Cv_Caracteristica VARCHAR2,
                                  Cn_ValorFactura   NUMBER)
    IS
      SELECT SUM(NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, 
                                                                                 TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                                 'saldo'),2),0 )) AS TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      WHERE IDFC.NUMERO_FACTURA_SRI  IS NOT NULL
      AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
      AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(Cv_EmpresaId,'^\d+')),0)
      AND IDFC.PUNTO_ID              = Cn_PuntoId
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier')
      AND NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, 
                                                                          TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                          'saldo'),2),0 ) > Cn_ValorFactura
      AND DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_NC_FACT(IDFC.ID_DOCUMENTO) = 0
      AND NOT EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
                      AND IDC.DOCUMENTO_ID                  = IDFC.ID_DOCUMENTO
                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA);
    --
    Lv_IpCreacion             VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User                   VARCHAR2(1000) := 'telcos_diferido';
    Lv_EstadoActivo           DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE := 'Activo';
    Lv_NombreParametro        DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROCESO_EMER_SANITARIA';
    Lv_DescValorFactura       DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'VALOR_FACT_MIN';
    Lv_DescFormaPago          DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'VALOR_FORMAS_DE_PAGO';
    Lv_DescCantidadFacturas   DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'FACTURAS_MINIMA';
    Lv_DescSolicitud          VARCHAR2(2000) := 'SOLICITUD DIFERIDO DE FACTURA POR EMERGENCIA SANITARIA';
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_Trama                  VARCHAR2(3200);
    Lv_Valor                  VARCHAR2(3200);
    Lv_SaldoDesde             VARCHAR2(3200);
    Lv_SaldoHasta             VARCHAR2(3200);
    Lv_MesDiferido            VARCHAR2(3200);
    Lv_Ciclos                 VARCHAR2(3200);
    Lv_DescCiclos             VARCHAR2(3200);
    Lv_Estados                VARCHAR2(3200);
    Lv_MensajeError           VARCHAR2(3200);
    Lv_ObsPersonaRol          VARCHAR2(3200);
    Lv_ValorFormaPago         VARCHAR2(3200);
    Lv_UsuarioCreacion        VARCHAR2(3200);
    Lv_CodProducto            VARCHAR2(4) := 'INTD';
    Ln_Posicion               NUMBER;
    Ln_Indx                   NUMBER;
    Ln_IdDeTalleSolicitud     NUMBER;
    Ln_IdPersonaRol           NUMBER;
    Ln_ValorFactura           NUMBER;
    Ln_IdMotivo               NUMBER;
    Ln_IdSolicitud            NUMBER;
    Ln_IdCaracFactura         NUMBER;
    Ln_IdCaracCuota           NUMBER;
    Ln_IdCaracPM              NUMBER;
    Ln_CantidadFacturas       NUMBER;
    Ln_SaldoDiferir           NUMBER;
    Ln_SaldoTotal             NUMBER;
    Ln_IdProcesoMasivo        DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Lv_EstadoPersonaRol       DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO.ESTADO%TYPE;
    La_RegistrosPersonas      T_RegistrosPersonas;
    Ln_Limit                  CONSTANT PLS_INTEGER DEFAULT 5000;
    Lc_GetProcesoMasivo       C_GetProcesoMasivo%ROWTYPE;
    Lr_InfoDetalleSolicitud   DB_COMERCIAL.INFO_DETALLE_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleSolCaract   DB_COMERCIAL.INFO_DETALLE_SOL_CARACT%ROWTYPE;
    Lr_InfoDetalleSolHist     DB_COMERCIAL.INFO_DETALLE_SOL_HIST%ROWTYPE;
    Lr_PersonaRolHistorial    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE;
    Lv_DescripcionRol         DB_GENERAL.ADMI_ROL.DESCRIPCION_ROL%TYPE := 'Cliente';
    Lb_Cabecera               BOOLEAN;
    Le_Error                  EXCEPTION;
    Le_Exception              EXCEPTION;
    Lex_Exception             EXCEPTION;
    Lef_Exception             EXCEPTION;
    Lrf_GetPersonaSaldo       SYS_REFCURSOR;  
    Lv_Consulta               VARCHAR2(4000);
    Lv_CadenaQuery1           VARCHAR2(4000);
    Lv_CadenaQuery2           VARCHAR2(4000);
    Lv_CadenaFrom2            VARCHAR2(3000);
    Lv_CadenaWhere1           VARCHAR2(3000);        
    Lv_CadenaWhere2           VARCHAR2(3000); 
    Lv_CadenaWhere3           VARCHAR2(3000);       
    Lv_CadenaGroupBy          VARCHAR2(3000);
    Lv_Having                 VARCHAR2(3000);
    Lv_CadenaOrderBy          VARCHAR2(3000);

  BEGIN

    IF C_Parametros%ISOPEN THEN
      CLOSE C_Parametros;
    END IF;

    IF C_ObtieneMotivoSolicitud%ISOPEN THEN
      CLOSE C_ObtieneMotivoSolicitud;
    END IF;

    IF C_ObtieneTipoSolicitud%ISOPEN THEN
      CLOSE C_ObtieneTipoSolicitud;
    END IF;

    IF C_ObtieneIdCarac%ISOPEN THEN
      CLOSE C_ObtieneIdCarac;
    END IF;

    IF C_GetProcesoMasivo%ISOPEN THEN
      CLOSE C_GetProcesoMasivo;
    END IF;

    IF C_TotalSaldoFactPorPto%ISOPEN THEN
      CLOSE C_TotalSaldoFactPorPto;
    END IF;

    IF C_Ciclos%ISOPEN THEN
      CLOSE C_Ciclos;
    END IF;

    IF Lrf_GetPersonaSaldo%ISOPEN THEN    
      CLOSE Lrf_GetPersonaSaldo;    
    END IF;
    --

    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescValorFactura,
                      Lv_EstadoActivo);
    FETCH C_Parametros 
      INTO Ln_ValorFactura;

      IF C_Parametros%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar el par�metro para evaluaci�n de facturas con un valor m�nimo de saldo.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescFormaPago,
                      Lv_EstadoActivo);
    FETCH C_Parametros 
      INTO Lv_ValorFormaPago;

      IF C_Parametros%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar el par�metro para evaluaci�n de formas de pagos.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_DescCantidadFacturas,
                      Lv_EstadoActivo);
    FETCH C_Parametros 
      INTO Ln_CantidadFacturas;

      IF C_Parametros%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar el par�metro para evaluaci�n de la cantidad m�nima de facturas por punto.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_Parametros;

    OPEN C_ObtieneMotivoSolicitud(Lv_EstadoActivo,
                                  'Saldo a Diferir en cuotas');
    FETCH C_ObtieneMotivoSolicitud 
      INTO Ln_IdMotivo;

      IF C_ObtieneMotivoSolicitud%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar el id del motivo de la solicitud para el proceso de diferidos.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_ObtieneMotivoSolicitud;

    OPEN C_ObtieneTipoSolicitud(Lv_EstadoActivo,
                                Lv_DescSolicitud);
    FETCH C_ObtieneTipoSolicitud 
      INTO Ln_IdSolicitud;

      IF C_ObtieneTipoSolicitud%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar el id del tipo de solicitud para el proceso de diferidos.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_ObtieneTipoSolicitud;

    OPEN C_ObtieneIdCarac(Lv_EstadoActivo,
                          'ES_SOL_FACTURA');
    FETCH C_ObtieneIdCarac 
      INTO Ln_IdCaracFactura;

      IF C_ObtieneIdCarac%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar la caracter�stica de facturas a diferir por solicitud.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_ObtieneIdCarac;

    OPEN C_ObtieneIdCarac(Lv_EstadoActivo,
                          'ES_MESES_DIFERIDO');
    FETCH C_ObtieneIdCarac 
      INTO Ln_IdCaracCuota;

      IF C_ObtieneIdCarac%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar la caracter�stica de cuotas a diferir por solicitud.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_ObtieneIdCarac;

    OPEN C_ObtieneIdCarac(Lv_EstadoActivo,
                          'ES_PROCESO_MASIVO');    
    FETCH C_ObtieneIdCarac 
      INTO Ln_IdCaracPM;

      IF C_ObtieneIdCarac%NOTFOUND THEN
        Lv_MsjResultado := 'Error al recuperar la caracter�stica de proceso masivo por solicitud.';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_ObtieneIdCarac;

    OPEN C_GetProcesoMasivo(Pv_TipoPma,
                            Pv_CodEmpresa,
                            Pv_Estado,
                            Pn_IdPunto);
    FETCH C_GetProcesoMasivo 
      INTO Lc_GetProcesoMasivo;

      IF C_GetProcesoMasivo%NOTFOUND THEN
        RAISE Le_Error;
      END IF;

      Lv_UsuarioCreacion  := Lc_GetProcesoMasivo.USR_CREACION;
      Ln_IdProcesoMasivo  := Lc_GetProcesoMasivo.ID_PROCESO_MASIVO_CAB;
      Lv_Trama            := Lc_GetProcesoMasivo.observacion;

      WHILE NVL(LENGTH(Lv_Trama),0) > 0 LOOP

        Ln_Posicion := INSTR(Lv_Trama, '|' );

        IF Ln_Posicion > 0 THEN

          Lv_Valor := SUBSTR(Lv_Trama,1, Ln_Posicion-1);

        IF INSTR(Lv_Valor,'SALDO_DESDE',1) > 0 THEN
          Lv_SaldoDesde := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        IF INSTR(Lv_Valor,'SALDO_HASTA',1) > 0 THEN
          Lv_SaldoHasta := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        IF INSTR(Lv_Valor,'MES_DIFERIDO',1) > 0 THEN
          Lv_MesDiferido := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        IF INSTR(Lv_Valor,'CICLO',1) > 0 THEN
          Lv_Ciclos := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        IF INSTR(Lv_Valor,'ESTADO_SERVICIO',1) > 0 THEN
          Lv_Estados := SUBSTR(Lv_Valor,INSTR(Lv_Valor,':',1)+1);
        END IF;

        Lv_Trama := SUBSTR(Lv_Trama,Ln_Posicion+1);

       ELSE

         Lv_Trama := NULL;

       END IF;

      END LOOP;

      IF Pn_IdPunto IS NOT NULL THEN
        IF Lv_MesDiferido IS NULL THEN
          Lv_MsjResultado := 'Error al recuperar los par�metros para evaluaci�n de diferido por emergencia sanitaria. '                             
                             || 'Lv_MesDiferido: '|| Lv_MesDiferido;                             
          RAISE Lex_Exception;   
        END IF;
      ELSE
        IF Lv_SaldoDesde IS NULL OR Lv_SaldoHasta IS NULL OR Lv_MesDiferido IS NULL
          OR Lv_Ciclos IS NULL OR Lv_Estados IS NULL THEN
          Lv_MsjResultado := 'Error al recuperar los par�metros para evaluaci�n de diferido por emergencia sanitaria. '
                             || 'Lv_SaldoDesde: '|| Lv_SaldoDesde || ',Lv_SaldoHasta: '|| Lv_SaldoHasta
                             || ',Lv_MesDiferido: '|| Lv_MesDiferido || ',Lv_Ciclos: '|| Lv_Ciclos
                             || ',Lv_Estados: '|| Lv_Estados;
          RAISE Lex_Exception;   
        END IF;   
      END IF;

      OPEN C_Ciclos(Lv_Ciclos);
      FETCH C_Ciclos 
        INTO Lv_DescCiclos;
      CLOSE C_Ciclos;

      Lv_CadenaQuery1 := ' SELECT TABLA.ID_PERSONA,TABLA.CLIENTE, SUM(TRUNC(SALDO.SALDO)) AS SALDO '||
                         ' FROM DB_FINANCIERO.VISTA_ESTADO_CTA_RESUMIDO_ES SALDO, ';

      Lv_CadenaQuery2 := ' (SELECT DISTINCT '||
          ' CASE '||
          ' WHEN IPE.RAZON_SOCIAL IS NULL '||
          ' THEN IPE.NOMBRES ||'' ''|| IPE.APELLIDOS '||
          ' ELSE IPE.RAZON_SOCIAL '||
          ' END AS CLIENTE, '||
          ' IPE.ID_PERSONA, '||
          ' IP.ID_PUNTO ';

      Lv_CadenaFrom2 := ' FROM DB_COMERCIAL.INFO_SERVICIO ISE, '||
          ' DB_COMERCIAL.INFO_PUNTO IP, '||
          ' DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER, '||
          ' DB_COMERCIAL.INFO_PERSONA IPE, '||
          ' DB_COMERCIAL.INFO_EMPRESA_ROL IER, '||
          ' DB_GENERAL.ADMI_ROL AR, '||     
          ' DB_COMERCIAL.ADMI_PRODUCTO AP, '||
          ' DB_COMERCIAL.INFO_PLAN_DET IPD ';

      Lv_CadenaWhere2 := ' WHERE AR.DESCRIPCION_ROL              = '''||Lv_DescripcionRol||''' '||
        ' AND IER.ROL_ID                        = AR.ID_ROL '||
        ' AND IER.EMPRESA_COD                   = '''||Pv_CodEmpresa||'''  '||
        ' AND IPER.EMPRESA_ROL_ID               = IER.ID_EMPRESA_ROL '||
        ' AND IPE.ID_PERSONA                    = IPER.PERSONA_ID '||
        ' AND NOT EXISTS (SELECT IPERC.ID_PERSONA_EMPRESA_ROL_CARACT  '||
        '                 FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC IPERC, '||
        '                   DB_COMERCIAL.ADMI_CARACTERISTICA DBAC '||
        '                 WHERE IPERC.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL  '||
        '                 AND DBAC.ID_CARACTERISTICA           = IPERC.CARACTERISTICA_ID  '||
        '                 AND DBAC.DESCRIPCION_CARACTERISTICA  = ''PROCESO_DIFERIDO''   '||
        '                 AND IPERC.ESTADO                     = ''Activo'')   ';     

      Lv_CadenaWhere3 := ' AND IP.PERSONA_EMPRESA_ROL_ID          = IPER.ID_PERSONA_ROL  '||
        ' AND ISE.PUNTO_ID                       = IP.ID_PUNTO  '||
        ' AND IPD.PLAN_ID                        = ISE.PLAN_ID '||
        ' AND AP.ID_PRODUCTO                     = IPD.PRODUCTO_ID '||
        ' AND AP.CODIGO_PRODUCTO                 = '''||Lv_CodProducto||''') TABLA ';

     Lv_CadenaWhere1 := ' WHERE SALDO.PUNTO_ID = TABLA.ID_PUNTO '||
      ' AND SALDO.SALDO      > 0 ';

     Lv_CadenaGroupBy := ' GROUP BY TABLA.ID_PERSONA, '||
              ' TABLA.CLIENTE ';

     Lv_CadenaOrderBy := ' ORDER BY TABLA.CLIENTE ';


     IF Pn_IdPunto IS NOT NULL THEN
       Lv_CadenaWhere1 := Lv_CadenaWhere1 || ' AND SALDO.PUNTO_ID = '||Pn_IdPunto||'  ';
       Lv_Having := '';
     ELSE     
       Lv_CadenaFrom2 := Lv_CadenaFrom2 || ', DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC CICLO, '||
           ' DB_COMERCIAL.ADMI_CARACTERISTICA CARAC,  '||
           ' DB_FINANCIERO.ADMI_CICLO ADMCICLO,    '||
           ' DB_COMERCIAL.INFO_CONTRATO CONT ';
       Lv_CadenaWhere2 := Lv_CadenaWhere2 ||  ' AND CICLO.PERSONA_EMPRESA_ROL_ID      = IPER.ID_PERSONA_ROL '||
        ' AND CICLO.ESTADO                      = ''Activo''  '||
        ' AND CARAC.ID_CARACTERISTICA           = CICLO.CARACTERISTICA_ID  '||
        ' AND CARAC.DESCRIPCION_CARACTERISTICA  = ''CICLO_FACTURACION''  '||
        ' AND ADMCICLO.ID_CICLO                 = COALESCE(TO_NUMBER(REGEXP_SUBSTR(CICLO.VALOR,''^\d+'')),0)   '||
        ' AND ADMCICLO.ID_CICLO                 IN (SELECT REGEXP_SUBSTR ('''||Lv_Ciclos||''',''[^,]+'',1, LEVEL) VALOR FROM DUAL   '||
                                                 '  CONNECT BY REGEXP_SUBSTR ('''||Lv_Ciclos||''',''[^,]+'',1, LEVEL) IS NOT NULL)  '||                                                     
        ' AND CONT.PERSONA_EMPRESA_ROL_ID       = IPER.ID_PERSONA_ROL  '||
        ' AND CONT.FORMA_PAGO_ID                IN (SELECT REGEXP_SUBSTR ('''||Lv_ValorFormaPago||''',''[^,]+'',1, LEVEL) VALOR FROM DUAL '||
                                                '  CONNECT BY REGEXP_SUBSTR ('''||Lv_ValorFormaPago||''',''[^,]+'',1, LEVEL) IS NOT NULL) '||
        ' AND CONT.ESTADO                       = ''Activo''    '||
        ' AND ISE.ESTADO                        IN (SELECT REGEXP_SUBSTR ('''||Lv_Estados||''',''[^,]+'',1, LEVEL) VALOR FROM DUAL '||
                                                '   CONNECT BY REGEXP_SUBSTR ('''||Lv_Estados||''',''[^,]+'',1, LEVEL) IS NOT NULL)  ';

       Lv_Having := ' HAVING SUM(TRUNC(SALDO.SALDO)) BETWEEN  COALESCE(TO_NUMBER(REGEXP_SUBSTR('''||Lv_SaldoDesde||''',''^\d+'')),0) '||
        ' AND  COALESCE(TO_NUMBER(REGEXP_SUBSTR('''||Lv_SaldoHasta||''',''^\d+'')),0) ';


     END IF;
     --
     Lv_Consulta := Lv_CadenaQuery1 || Lv_CadenaQuery2 || Lv_CadenaFrom2 || Lv_CadenaWhere2 || Lv_CadenaWhere3 || Lv_CadenaWhere1 
                      ||  Lv_CadenaGroupBy || Lv_Having || Lv_CadenaOrderBy;    
     dbms_output.put_line( 'Lv_Consulta: ' || Lv_Consulta); 

      OPEN Lrf_GetPersonaSaldo FOR Lv_Consulta;
      LOOP       
        FETCH Lrf_GetPersonaSaldo BULK COLLECT INTO La_RegistrosPersonas LIMIT Ln_Limit;
        --
        Ln_Indx := La_RegistrosPersonas.FIRST;
        --
        EXIT WHEN La_RegistrosPersonas.COUNT = 0;
        --
        WHILE (Ln_Indx IS NOT NULL)  
        LOOP
          BEGIN

            Ln_IdPersonaRol     := NULL;
            Lv_EstadoPersonaRol := NULL;
            Lv_ObsPersonaRol    := NULL;
            Lb_Cabecera         := FALSE;

            FOR Lr_DatosCliente IN C_DatosCliente (La_RegistrosPersonas(Ln_Indx).ID_PERSONA,
                                                   Lv_DescripcionRol,
                                                   Pv_CodEmpresa,
                                                   Lv_CodProducto,
                                                   Lv_Estados,
                                                   Lv_Ciclos,
                                                   Pn_IdPunto) LOOP

              BEGIN

                Ln_IdPersonaRol     := Lr_DatosCliente.ID_PERSONA_ROL;
                Lv_EstadoPersonaRol := Lr_DatosCliente.ESTADO_CLIENTE;
                Ln_SaldoTotal       := 0;

                OPEN C_TotalSaldoFactPorPto(Lr_DatosCliente.ID_PUNTO,
                                            Pv_CodEmpresa,
                                            'PROCESO_DIFERIDO',
                                            Ln_ValorFactura);
                FETCH C_TotalSaldoFactPorPto 
                  INTO Ln_SaldoDiferir;
                CLOSE C_TotalSaldoFactPorPto;

                --Si se realiza Proceso de Diferido Individual por Punto en sesion la Cantidad de Facturas minimas debe ser 1
                IF Pn_IdPunto IS NOT NULL THEN 
                  Ln_CantidadFacturas := 1;
                END IF;

                IF (Ln_SaldoDiferir > 0 
                    AND DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_FACTURA (Fn_IdPunto         => Lr_DatosCliente.ID_PUNTO,
                                                                               Fv_CodEmpresa      => Pv_CodEmpresa,
                                                                               Fv_Caracteristica  => 'PROCESO_DIFERIDO',
                                                                               Fn_CostoMininoFact => Ln_ValorFactura) >= Ln_CantidadFacturas)THEN

                  Ln_SaldoTotal                                 := Ln_SaldoTotal + Ln_SaldoDiferir;
                  Lr_InfoDetalleSolicitud                       := NULL;
                  Ln_IdDeTalleSolicitud                         := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL;
                  Lr_InfoDetalleSolicitud.ID_DETALLE_SOLICITUD  := Ln_IdDeTalleSolicitud;
                  Lr_InfoDetalleSolicitud.SERVICIO_ID           := Lr_DatosCliente.ID_SERVICIO;
                  Lr_InfoDetalleSolicitud.TIPO_SOLICITUD_ID     := Ln_IdSolicitud;
                  Lr_InfoDetalleSolicitud.MOTIVO_ID             := Ln_IdMotivo;
                  Lr_InfoDetalleSolicitud.USR_CREACION          := Lv_User;
                  Lr_InfoDetalleSolicitud.FE_CREACION           := SYSDATE;
                  Lr_InfoDetalleSolicitud.PRECIO_DESCUENTO      := null;
                  Lr_InfoDetalleSolicitud.PORCENTAJE_DESCUENTO  := null;
                  Lr_InfoDetalleSolicitud.TIPO_DOCUMENTO        := null;
                  Lr_InfoDetalleSolicitud.OBSERVACION           := 'Se aplica diferido por emergencia sanitaria.';
                  Lr_InfoDetalleSolicitud.ESTADO                := 'Pendiente';
                  Lr_InfoDetalleSolicitud.USR_RECHAZO           := null;
                  Lr_InfoDetalleSolicitud.FE_RECHAZO            := null;
                  Lr_InfoDetalleSolicitud.DETALLE_PROCESO_ID    := null;
                  Lr_InfoDetalleSolicitud.FE_EJECUCION          := null;
                  Lr_InfoDetalleSolicitud.ELEMENTO_ID           := null;

                  DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DET_SOLICITUD(Lr_InfoDetalleSolicitud, Lv_MensajeError); 

                  IF TRIM(Lv_MensajeError) IS NOT NULL THEN
                    Lv_MsjResultado := 'Ocurri� un error al insertar la solicitud para el Id_Punto: ' 
                                       || Lr_DatosCliente.ID_PUNTO || ' - ' ||Lv_MensajeError;
                    RAISE Le_Exception;
                  END IF;

                  IF Ln_IdDeTalleSolicitud IS NOT NULL THEN
                  --
                    Lr_InfoDetalleSolHist                        := NULL;
                    Lr_InfoDetalleSolHist.ID_SOLICITUD_HISTORIAL := DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL;
                    Lr_InfoDetalleSolHist.DETALLE_SOLICITUD_ID   := Ln_IdDeTalleSolicitud;
                    Lr_InfoDetalleSolHist.ESTADO                 := 'Pendiente';
                    Lr_InfoDetalleSolHist.FE_INI_PLAN            := NULL;
                    Lr_InfoDetalleSolHist.FE_FIN_PLAN            := NULL;
                    Lr_InfoDetalleSolHist.OBSERVACION            := 'Se aplica diferido por emergencia sanitaria.';
                    Lr_InfoDetalleSolHist.USR_CREACION           := Lv_User;
                    Lr_InfoDetalleSolHist.FE_CREACION            := SYSDATE;
                    Lr_InfoDetalleSolHist.IP_CREACION            := Lv_IpCreacion;
                    Lr_InfoDetalleSolHist.MOTIVO_ID              := Ln_IdMotivo;
                    --
                    DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DETALLE_SOL_HIST(Lr_InfoDetalleSolHist, Lv_MensajeError);
                    --
                    IF TRIM(Lv_MensajeError) IS NOT NULL THEN
                      Lv_MsjResultado := 'Ocurri� un error al insertar el historial de la solicitud : ' 
                                         || Ln_IdDeTalleSolicitud || ' - ' ||Lv_MensajeError;
                      RAISE Le_Exception;
                    END IF;

                END IF;

                BEGIN                
                  FOR Lr_Facturas IN C_Facturas (Pv_CodEmpresa,
                                                 Lr_DatosCliente.ID_PUNTO,
                                                 'PROCESO_DIFERIDO',
                                                 Ln_ValorFactura) LOOP

                    Lr_InfoDetalleSolCaract                             := NULL;
                    Lr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID        := Ln_IdDeTalleSolicitud;
                    Lr_InfoDetalleSolCaract.CARACTERISTICA_ID           := Ln_IdCaracFactura;
                    Lr_InfoDetalleSolCaract.VALOR                       := Lr_Facturas.ID_DOCUMENTO;
                    Lr_InfoDetalleSolCaract.FE_CREACION                 := SYSDATE;
                    Lr_InfoDetalleSolCaract.USR_CREACION                := Lv_User;
                    Lr_InfoDetalleSolCaract.ESTADO                      := 'Pendiente';
                    DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC( Lr_InfoDetalleSolCaract, Lv_MensajeError );

                    IF TRIM(Lv_MensajeError) IS NULL THEN
                      Lb_Cabecera := TRUE;
                    ELSE
                     Lv_MsjResultado := 'No se gener� correctamente la caracter�stica de factura para el id_documento: '
                                         ||Lr_Facturas.ID_DOCUMENTO;
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                           'FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI', 
                                                           Lv_MsjResultado,
                                                           Lv_User,
                                                           SYSDATE,
                                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
                    END IF;

                  END LOOP;

                  IF Lb_Cabecera THEN

                    Lr_InfoDetalleSolCaract                             := NULL;
                    Lr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID        := Ln_IdDeTalleSolicitud;
                    Lr_InfoDetalleSolCaract.CARACTERISTICA_ID           := Ln_IdCaracPM;
                    Lr_InfoDetalleSolCaract.VALOR                       := Lc_GetProcesoMasivo.ID_PROCESO_MASIVO_CAB;
                    Lr_InfoDetalleSolCaract.FE_CREACION                 := SYSDATE;
                    Lr_InfoDetalleSolCaract.USR_CREACION                := Lv_User;
                    Lr_InfoDetalleSolCaract.ESTADO                      := 'Pendiente';
                    DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC( Lr_InfoDetalleSolCaract, Lv_MensajeError );

                    IF TRIM(Lv_MensajeError) IS NOT NULL THEN
                      Lv_MsjResultado := 'No se gener� correctamente la caracter�stica de proceso masivo para el id_solicitud: '
                                          ||Ln_IdDeTalleSolicitud;
                      RAISE Lef_Exception;
                    END IF;

                    Lr_InfoDetalleSolCaract                             := NULL;
                    Lr_InfoDetalleSolCaract.DETALLE_SOLICITUD_ID        := Ln_IdDeTalleSolicitud;
                    Lr_InfoDetalleSolCaract.CARACTERISTICA_ID           := Ln_IdCaracCuota;
                    Lr_InfoDetalleSolCaract.VALOR                       := Lv_MesDiferido;
                    Lr_InfoDetalleSolCaract.FE_CREACION                 := SYSDATE;
                    Lr_InfoDetalleSolCaract.USR_CREACION                := Lv_User;
                    Lr_InfoDetalleSolCaract.ESTADO                      := 'Pendiente';
                    DB_COMERCIAL.COMEK_MODELO.COMEP_INSERT_DETALLE_SOL_CARAC( Lr_InfoDetalleSolCaract, Lv_MensajeError );

                    IF TRIM(Lv_MensajeError) IS NOT NULL THEN
                      Lv_MsjResultado := 'No se gener� correctamente la caracter�stica de meses diferido para el id_solicitud: '
                                         ||Ln_IdDeTalleSolicitud;
                      RAISE Lef_Exception;
                    END IF;

                  END IF;

                EXCEPTION
                  WHEN Lef_Exception THEN
                    --
                    Pv_MsjResultado := Lv_MsjResultado;
                    Pn_IdProcesoMasivoCab := NULL;
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                         'FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI', 
                                                         Lv_MsjResultado,
                                                         Lv_User,
                                                         SYSDATE,
                                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
                  WHEN OTHERS THEN
                  --
                  Lv_MsjResultado      := 'Ocurri� un error al procesar las caracter�ticas atadas a la solicitud: '
                                          || Ln_IdDeTalleSolicitud; 
                  Pv_MsjResultado      := Lv_MsjResultado;
                  Pn_IdProcesoMasivoCab := NULL;
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                       'FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI', 
                                                       Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                       Lv_User,
                                                       SYSDATE,
                                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
                END;

              END IF;

              EXCEPTION
                WHEN Le_Exception THEN
                --
                  Pv_MsjResultado := Lv_MsjResultado;
                  Pn_IdProcesoMasivoCab := NULL;
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                       'FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI', 
                                                       Lv_MsjResultado,
                                                       Lv_User,
                                                       SYSDATE,
                                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
                WHEN OTHERS THEN
                --
                  Lv_MsjResultado      := 'Ocurri� un error al procesar las caracter�ticas atadas a la solicitud: '
                                          || Ln_IdDeTalleSolicitud; 
                  Pv_MsjResultado      := Lv_MsjResultado;
                  Pn_IdProcesoMasivoCab := NULL;
                  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                       'FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI', 
                                                       Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                       Lv_User,
                                                       SYSDATE,
                                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
              END;

            END LOOP;

            Ln_Indx := La_RegistrosPersonas.NEXT(Ln_Indx);
          EXCEPTION
            WHEN OTHERS THEN
            --
            Lv_MsjResultado      := 'Ocurri� un error al procesar el Id_Persona: '||La_RegistrosPersonas(Ln_Indx).ID_PERSONA; 
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                 'FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI', 
                                                 Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                                 Lv_User,
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            Pv_MsjResultado := Lv_MsjResultado;
            Pn_IdProcesoMasivoCab := NULL;
          END;

          IF Lb_Cabecera THEN

            Lv_ObsPersonaRol    := 'El Cliente entr� en el proceso de diferido por emergencia sanitaria, saldo: '
                                   ||Ln_SaldoTotal || ' a: ' || Lv_MesDiferido || ' diferido.';

            Lr_PersonaRolHistorial                              := NULL;
            Lr_PersonaRolHistorial.ID_PERSONA_EMPRESA_ROL_HISTO := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL;
            Lr_PersonaRolHistorial.PERSONA_EMPRESA_ROL_ID       := Ln_IdPersonaRol;
            Lr_PersonaRolHistorial.OBSERVACION                  := Lv_ObsPersonaRol;
            Lr_PersonaRolHistorial.FE_CREACION                  := SYSDATE;
            Lr_PersonaRolHistorial.USR_CREACION                 := Lv_User;
            Lr_PersonaRolHistorial.ESTADO                       := Lv_EstadoPersonaRol;
            Lr_PersonaRolHistorial.IP_CREACION                  := Lv_IpCreacion;

            DB_COMERCIAL.COMEK_TRANSACTION.COMEP_INSERT_PERSONA_ROL_HISTO(Lr_PersonaRolHistorial, Lv_MensajeError);

          END IF;
        END LOOP;
        --
      END LOOP;
      --      
      CLOSE Lrf_GetPersonaSaldo;

      IF Pn_IdPunto IS NULL THEN
        --
        FNCK_PAGOS_DIFERIDOS.P_REPORTE_EMERGENCIA_SANIT(Pv_TipoPma    => Pv_TipoPma,
                                                        Pv_CodEmpresa => Pv_CodEmpresa,
                                                        Pv_Estado     => Pv_Estado,
                                                        Pv_Error      => Lv_MensajeError);

        IF Lv_MensajeError IS NOT NULL THEN
          Lv_MsjResultado := Lv_MensajeError;
          RAISE Lex_Exception;
        END IF;

        FNCK_PAGOS_DIFERIDOS.P_REPORTE_CREACION_SOL(Pn_IdProceso   => Ln_IdProcesoMasivo,
                                                    Pv_Ciclos      => Lv_DescCiclos,
                                                    Pv_Meses       => Lv_MesDiferido,
                                                    Pv_Estados     => Lv_Estados,
                                                    Pv_SaldoDesde  => Lv_SaldoDesde,
                                                    Pv_SaldoHasta  => Lv_SaldoHasta,
                                                    Pv_Usuario     => Lv_UsuarioCreacion,
                                                    Pv_Error       => Lv_MensajeError);

        IF Lv_MensajeError IS NOT NULL THEN
          Lv_MsjResultado := Lv_MensajeError;
          RAISE Lex_Exception;
        END IF;
        --
      END IF;
      --
      UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
      SET ESTADO    = 'Finalizado',
        USR_ULT_MOD = Lv_User,
        FE_ULT_MOD  = SYSDATE
      WHERE ID_PROCESO_MASIVO_DET = Lc_GetProcesoMasivo.ID_PROCESO_MASIVO_DET;

      UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
      SET ESTADO    = 'Finalizado',
        USR_ULT_MOD = Lv_User,
        FE_ULT_MOD  = SYSDATE
      WHERE ID_PROCESO_MASIVO_CAB = Lc_GetProcesoMasivo.ID_PROCESO_MASIVO_CAB; 

    CLOSE C_GetProcesoMasivo;

    COMMIT;
    Pv_MsjResultado := 'OK';
    Pn_IdProcesoMasivoCab := Ln_IdProcesoMasivo;
    --
  EXCEPTION
    WHEN Le_Error THEN
      --
      ROLLBACK;
      Lv_MsjResultado := 'No hay data para procesar.'; 
      Pv_MsjResultado := Lv_MsjResultado;
      Pn_IdProcesoMasivoCab := NULL;
    WHEN Lex_Exception THEN
      --
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI', 
                                           Lv_MsjResultado,
                                           Lv_User,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
      Pv_MsjResultado := Lv_MsjResultado;
      Pn_IdProcesoMasivoCab := NULL;
    WHEN OTHERS THEN
      --
      ROLLBACK;
      Lv_MsjResultado      := 'Ocurri� un error al ejecutar el Proceso Masivo '||Pv_TipoPma; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_CREA_SOLICITUDES_NCI', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           Lv_User,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));   
      Pv_MsjResultado := Lv_MsjResultado;
      Pn_IdProcesoMasivoCab := NULL;
  END P_CREA_SOLICITUDES_NCI;

  PROCEDURE P_REPORTE_NCI_DIFERIDOS(
      Pv_FechaReporteDesde IN VARCHAR2,
      Pv_FechaReporteHasta IN VARCHAR2,
      Pv_EmpresaCod        IN VARCHAR2,
      Pv_Usuario           IN VARCHAR2,
      Pv_PrefijoEmpresa    IN VARCHAR2,
      Pv_EmailUsuario      IN VARCHAR2)
  IS

    Cursor C_documentosNci (Cv_fechaCreacionDesde IN VARCHAR2,
                            Cv_fechaCreacionHasta IN VARCHAR2,
                            Cv_EmpresaCod         IN VARCHAR2)
    IS
    SELECT
        CASE
        WHEN IP.RAZON_SOCIAL IS NULL
        THEN IP.NOMBRES ||' '|| IP.APELLIDOS
        ELSE IP.RAZON_SOCIAL
        END AS CLIENTE,
        IP.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
        IPTO.LOGIN,
        TRUNC(IDFC_FACT.FE_CREACION) AS FECHA_FACTURA,
        IDFC_FACT.NUMERO_FACTURA_SRI AS NUMERO_FACTURA_SRI_FACT,
        ROUND(IDFC.VALOR_TOTAL,2) AS MONTO_DIFERIDO,
        DB_FINANCIERO.FNCK_CONSULTS.F_GET_FORMA_PAGO_CONTRATO(IPER.ID_PERSONA_ROL) AS FORMA_PAGO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_BANCO', IPER.ID_PERSONA_ROL) AS BANCO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_TIPO_CUENTA', IPER.ID_PERSONA_ROL) AS TIPO_CUENTA,
        IDC_NCI2.VALOR AS MES_DIFERIDO,
        TRUNC(IDFC.FE_CREACION) AS FECHA,
        IDFC.NUMERO_FACTURA_SRI AS NUMERO_FACTURA_SRI,
        ROUND(IDFC.VALOR_TOTAL,2) AS VALOR,
        DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'MAIL') AS MAIL_CLIENTE,
        IDFC.ESTADO_IMPRESION_FACT,
        NULL AS PROCESO_EJECUCION,
        (SELECT 'NCI_PROC_'||BDIDC.VALOR 
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO'
        AND ROWNUM = 1) AS PROCESO,
        (SELECT 'NCI_SOL_'||BDIDC.VALOR 
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_ID_SOLICITUD'
        AND ROWNUM = 1) AS SOLICITUD
    FROM  
        DB_COMERCIAL.INFO_PERSONA IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PUNTO IPTO,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO  IOG,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC, 
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC_FACT,
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_NCI2,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC_NCI2 
    WHERE 
        IP.ID_PERSONA                 = IPER.PERSONA_ID            AND
        IPTO.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL        AND
        IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL         AND
        IDFC.PUNTO_ID                 = IPTO.ID_PUNTO              AND
        IDFC.NUMERO_FACTURA_SRI       IS NOT NULL                  AND
        IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO     AND
        IDFC.OFICINA_ID               = IOG.ID_OFICINA             AND
        IOG.EMPRESA_ID                = Cv_EmpresaCod              AND
        IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID           AND
        AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID      AND
        ATDF.CODIGO_TIPO_DOCUMENTO    IN ('NCI')                   AND
        AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'         AND
        IDFC.ESTADO_IMPRESION_FACT  NOT IN ('Anulado','Eliminado') AND
        IDC.VALOR                     = 'S'                        AND
        IDFC.USR_CREACION             = 'telcos_diferido'          AND
        --  
        IDFC.REFERENCIA_DOCUMENTO_ID  = IDFC_FACT.ID_DOCUMENTO     AND
        IDFC_FACT.TIPO_DOCUMENTO_ID   IN (SELECT ID_TIPO_DOCUMENTO 
                                          FROM DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO
                                          WHERE CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')) AND
        --
        EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO') AND
        EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_ID_SOLICITUD')   AND
        --
        IDC_NCI2.DOCUMENTO_ID         = IDFC.ID_DOCUMENTO          AND
        AC_NCI2.ID_CARACTERISTICA     = IDC_NCI2.CARACTERISTICA_ID AND
        AC_NCI2.DESCRIPCION_CARACTERISTICA = 'ES_MESES_DIFERIDO'   AND
        IDFC.FE_CREACION              >= TO_DATE(Cv_fechaCreacionDesde,'DD/MM/YY')  AND
        IDFC.FE_CREACION              <  TO_DATE(Cv_fechaCreacionHasta,'DD/MM/YY')+1 
    ORDER BY CLIENTE;

  -- 
    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100)   := 'telcos@telconet.ec'; 
    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

    La_RegistrosDocumentos   T_RegistrosDocumentos;
    Ln_Limit                 CONSTANT PLS_INTEGER DEFAULT 5000;
    Ln_Indx                  NUMBER;
    Ln_Indr                  NUMBER := 0;

  BEGIN

    IF C_documentosNci%ISOPEN THEN
      CLOSE C_documentosNci;
    END IF;
    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DIFERIDOS');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Pv_EmailUsuario,'notificaciones_telcos@telconet.ec')||','; 

   IF Pv_Usuario = 'JOB_MENSUAL' THEN
      Lv_NombreArchivo    := 'ReporteNciDiferidos'||Pv_PrefijoEmpresa||'_'||'MENSUAL'||'_'||Lv_FechaReporte||'.csv';
      Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
      Lv_Asunto           := 'Notificacion REPORTE MENSUAL DE NCI DIFERIDAS';
    END IF;
    IF Pv_Usuario = 'JOB_DIARIO' THEN
      Lv_NombreArchivo    := 'ReporteNciDiferidos'||Pv_PrefijoEmpresa||'_'||'DIARIO'||'_'||Lv_FechaReporte||'.csv';
      Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
      Lv_Asunto           := 'Notificacion REPORTE DIARIO DE NCI DIFERIDAS';
    END IF;

    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
    --
    utl_file.put_line(Lfile_Archivo,'CLIENTE'           ||Lv_Delimitador
                      ||'IDENTIFICACION'                ||Lv_Delimitador
                      ||'LOGIN'                         ||Lv_Delimitador
                      ||'FECHA FACTURA'                 ||Lv_Delimitador
                      ||'NUMERO FACTURA'                ||Lv_Delimitador
                      ||'MONTO DIFERIDO'                ||Lv_Delimitador
                      ||'FORMA DE PAGO'                 ||Lv_Delimitador
                      ||'BANCO'                         ||Lv_Delimitador
                      ||'TIPO CUENTA'                   ||Lv_Delimitador
                      ||'NUMERO MESES DIFERIDO'         ||Lv_Delimitador
                      ||'FECHA SOLICITUD DIFERIDO'      ||Lv_Delimitador
                      ||'FECHA EMITIDA NCI DIFERIDO'    ||Lv_Delimitador
                      ||'NUMERO EMITIDA NCI DIFERIDO'   ||Lv_Delimitador
                      ||'VALOR EMITIDA NCI DIFERIDO'    ||Lv_Delimitador
                      ||'MAIL CLIENTE'                  ||Lv_Delimitador
                      ||'ESTADO DOC'                    ||Lv_Delimitador
                      ||'PROCESO MASIVO'                ||Lv_Delimitador
                      ||'SOLICITUD'                     ||Lv_Delimitador); 

    OPEN C_documentosNci (Pv_FechaReporteDesde,Pv_FechaReporteHasta,Pv_EmpresaCod) ;

    LOOP
        FETCH C_documentosNci BULK COLLECT INTO La_RegistrosDocumentos LIMIT Ln_Limit;
        -- 
        Ln_Indx := La_RegistrosDocumentos.FIRST;
        --
        EXIT WHEN La_RegistrosDocumentos.COUNT = 0;
        --
        WHILE (Ln_Indx IS NOT NULL)  
        LOOP
            Ln_Indr := Ln_Indr + 1;
            UTL_FILE.PUT_LINE(Lfile_Archivo,
                    NVL(REPLACE(La_RegistrosDocumentos(Ln_Indx).CLIENTE,'"',''), '') ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).IDENTIFICACION, '')          ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).LOGIN, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).FECHA_FACTURA, '')           ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).NUMERO_FACTURA_SRI_FACT, '') ||Lv_Delimitador
                  ||NVL(REPLACE(La_RegistrosDocumentos(Ln_Indx).MONTO_DIFERIDO,',','.'), '') ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).FORMA_PAGO, '')              ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).BANCO, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).TIPO_CUENTA, '')             ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).MES_DIFERIDO, '')            ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).FECHA, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).FECHA, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).NUMERO_FACTURA_SRI, '')      ||Lv_Delimitador
                  ||NVL(REPLACE(La_RegistrosDocumentos(Ln_Indx).VALOR,',','.'), '')       ||Lv_Delimitador
                  ||NVL(REPLACE(La_RegistrosDocumentos(Ln_Indx).MAIL_CLIENTE,';',','),'') ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).ESTADO_IMPRESION_FACT, '')   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).PROCESO, '')                 ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).SOLICITUD, '')               ||Lv_Delimitador
             );

            Ln_Indx := La_RegistrosDocumentos.NEXT(Ln_Indx);
        END LOOP;
        --
    END LOOP;
      --
    CLOSE C_documentosNci;    
    --
    UTL_FILE.fclose(Lfile_Archivo);
    dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 
    IF Ln_Indr > 0 THEN 
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip);
    END IF;
    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);

  EXCEPTION
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurri� un error al generar el reporte NCI diferidos.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_REPORTE_NCI_DIFERIDOS', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_reporte',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

  END P_REPORTE_NCI_DIFERIDOS;

  PROCEDURE P_REPORTE_NDI_DIFERIDOS(
      Pv_FechaReporteDesde IN VARCHAR2,
      Pv_FechaReporteHasta IN VARCHAR2,
      Pv_EmpresaCod        IN VARCHAR2,
      Pv_Usuario           IN VARCHAR2,
      Pv_PrefijoEmpresa    IN VARCHAR2,
      Pv_EmailUsuario      IN VARCHAR2)
  IS

    Cursor C_documentosNdi (Cv_fechaCreacionDesde IN VARCHAR2,
                            Cv_fechaCreacionHasta IN VARCHAR2,
                            Cv_EmpresaCod         IN VARCHAR2)
    IS
    SELECT
      CASE
      WHEN IP.RAZON_SOCIAL IS NULL
        THEN IP.NOMBRES ||' '|| IP.APELLIDOS
        ELSE IP.RAZON_SOCIAL
      END AS CLIENTE,
      IP.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
      IPTO.LOGIN,
      TRUNC(IDFC_FACTURA.FE_CREACION) AS FECHA_FACTURA,
      IDFC_FACTURA.NUMERO_FACTURA_SRI AS NUMERO_FACTURA_SRI_FACT,
      NVL((SELECT DBIDC.VALOR 
           FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DBIDC,
             DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
           WHERE DBIDC.DOCUMENTO_ID              = IDFC.ID_DOCUMENTO
           AND DBIDC.USR_CREACION                = 'telcos_diferido'
           AND DBAC.ID_CARACTERISTICA            = DBIDC.CARACTERISTICA_ID
           AND DBAC.DESCRIPCION_CARACTERISTICA   = 'VALOR_CUOTA_DIFERIDA'
           AND DBIDC.DOCUMENTO_CARACTERISTICA_ID = IDC.ID_DOCUMENTO_CARACTERISTICA
           AND ROWNUM                            = 1),ROUND(IDFC.VALOR_TOTAL,2)) AS MONTO_DIFERIDO,
      DB_FINANCIERO.FNCK_CONSULTS.F_GET_FORMA_PAGO_CONTRATO(IPER.ID_PERSONA_ROL) AS FORMA_PAGO,
      DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_BANCO', IPER.ID_PERSONA_ROL) AS BANCO,
      DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_TIPO_CUENTA', IPER.ID_PERSONA_ROL)  AS TIPO_CUENTA,
      (SELECT IDC_NCI.VALOR
       FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_NCI,
         DB_COMERCIAL.ADMI_CARACTERISTICA AC_NCI
       WHERE IDC_NCI.DOCUMENTO_ID            = IDFC_NCI_FACT.ID_DOCUMENTO
       AND IDC_NCI.CARACTERISTICA_ID         = AC_NCI.ID_CARACTERISTICA 
       AND AC_NCI.DESCRIPCION_CARACTERISTICA = 'ES_MESES_DIFERIDO'
       AND ROWNUM                            = 1) AS MES_DIFERIDO,
      TRUNC(IDFC.FE_CREACION) AS FECHA, 
      IDFC.NUMERO_FACTURA_SRI AS NUMERO_FACTURA_SRI,
      NVL((SELECT DBIDC.VALOR 
           FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DBIDC,
             DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
           WHERE DBIDC.DOCUMENTO_ID              = IDFC.ID_DOCUMENTO
           AND DBIDC.USR_CREACION                = 'telcos_diferido'
           AND DBAC.ID_CARACTERISTICA            = DBIDC.CARACTERISTICA_ID
           AND DBAC.DESCRIPCION_CARACTERISTICA   = 'VALOR_CUOTA_DIFERIDA'
           AND DBIDC.DOCUMENTO_CARACTERISTICA_ID = IDC.ID_DOCUMENTO_CARACTERISTICA
           AND ROWNUM                            = 1),ROUND(IDFC.VALOR_TOTAL,2)) AS VALOR,
      DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'MAIL') AS MAIL_CLIENTE,
      IDFC.ESTADO_IMPRESION_FACT,
      NVL((SELECT BDIDC.VALOR 
           FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
             DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
           WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
           AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
           AND DBAC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DE_EJECUCION'
           AND ROWNUM = 1),'PROCESO_MASIVO') AS PROCESO_EJECUCION,
      (SELECT 'NDI_PROC_'||BDIDC.VALOR 
       FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
         DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
       WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
       AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
       AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO'
       AND ROWNUM = 1) AS PROCESO,
      (SELECT 'NDI_SOL_'||BDIDC.VALOR 
       FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
         DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
       WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
       AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
       AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_ID_SOLICITUD'
       AND ROWNUM = 1) AS SOLICITUD
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC_NCI_FACT,
      DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
      DB_COMERCIAL.INFO_OFICINA_GRUPO  IOG,
      DB_COMERCIAL.ADMI_CARACTERISTICA AC, 
      DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
      DB_COMERCIAL.INFO_PERSONA IP,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PUNTO IPTO,
      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
      DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC_FACTURA
    WHERE IP.ID_PERSONA               = IPER.PERSONA_ID
    AND IPTO.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL
    AND IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL
    AND IDFC.PUNTO_ID                 = IPTO.ID_PUNTO
    AND IDFC.NUMERO_FACTURA_SRI       IS NOT NULL
    AND IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO
    AND IDFC.OFICINA_ID               = IOG.ID_OFICINA
    AND IOG.EMPRESA_ID                = Cv_EmpresaCod
    AND IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID
    AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID
    AND ATDF.CODIGO_TIPO_DOCUMENTO    IN ('NDI')
    AND AC.DESCRIPCION_CARACTERISTICA = 'ID_REFERENCIA_NCI'
    AND IDFC.ESTADO_IMPRESION_FACT    NOT IN ('Anulado','Eliminado')
    AND IDFC.USR_CREACION             = 'telcos_diferido'
    AND IDFC_NCI_FACT.ID_DOCUMENTO    =  COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0)
    --
    AND EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
                FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
                DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
                AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
                AND DBAC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'
                AND BDIDC.VALOR                     = 'S')
    --
    AND EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
                FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
                DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
                AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
                AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO')
    --
    AND EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
                FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
                DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
                AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
                AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_ID_SOLICITUD')
    --
    AND IDFC_NCI_FACT.REFERENCIA_DOCUMENTO_ID = IDFC_FACTURA.ID_DOCUMENTO
    AND IDFC.FE_CREACION                      >= TO_DATE(Cv_fechaCreacionDesde,'DD/MM/YY')
    AND IDFC.FE_CREACION                      < TO_DATE(Cv_fechaCreacionHasta,'DD/MM/YY')+1
    ORDER BY CLIENTE;

  -- 
    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100)   := 'telcos@telconet.ec'; 
    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

    La_RegistrosDocumentos   T_RegistrosDocumentosNDI;
    Ln_Limit                 CONSTANT PLS_INTEGER DEFAULT 5000;
    Ln_Indx                  NUMBER;
    Ln_Indr                  NUMBER := 0;

  BEGIN

    IF C_documentosNdi%ISOPEN THEN
      CLOSE C_documentosNdi;
    END IF;
    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DIFERIDOS');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Pv_EmailUsuario,'notificaciones_telcos@telconet.ec')||','; 

   IF Pv_Usuario = 'JOB_MENSUAL' THEN
      Lv_NombreArchivo    := 'ReporteNdiDiferidos'||Pv_PrefijoEmpresa||'_'||'MENSUAL'||'_'||Lv_FechaReporte||'.csv';
      Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
      Lv_Asunto           := 'Notificacion REPORTE MENSUAL DE NDI DIFERIDAS';
    END IF;
    IF Pv_Usuario = 'JOB_DIARIO' THEN
      Lv_NombreArchivo    := 'ReporteNdiDiferidos'||Pv_PrefijoEmpresa||'_'||'DIARIO'||'_'||Lv_FechaReporte||'.csv';
      Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
      Lv_Asunto           := 'Notificacion REPORTE DIARIO DE NDI DIFERIDAS';
    END IF;

    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
    --
    utl_file.put_line(Lfile_Archivo,'CLIENTE'           ||Lv_Delimitador
                      ||'IDENTIFICACION'                ||Lv_Delimitador
                      ||'LOGIN'                         ||Lv_Delimitador
                      ||'FECHA FACTURA'                 ||Lv_Delimitador
                      ||'NUMERO FACTURA'                ||Lv_Delimitador
                      ||'MONTO DIFERIDO'                ||Lv_Delimitador
                      ||'FORMA DE PAGO'                 ||Lv_Delimitador
                      ||'BANCO'                         ||Lv_Delimitador
                      ||'TIPO CUENTA'                   ||Lv_Delimitador
                      ||'NUMERO MESES DIFERIDO'         ||Lv_Delimitador
                      ||'FECHA SOLICITUD DIFERIDO'      ||Lv_Delimitador
                      ||'FECHA EMITIDA NDI DIFERIDO'    ||Lv_Delimitador
                      ||'NUMERO EMITIDA NDI DIFERIDO'   ||Lv_Delimitador
                      ||'VALOR EMITIDA NDI DIFERIDO'    ||Lv_Delimitador
                      ||'MAIL CLIENTE'                  ||Lv_Delimitador
                      ||'ESTADO DOC'                    ||Lv_Delimitador
                      ||'PROCESO EJECUCION'             ||Lv_Delimitador
                      ||'PROCESO MASIVO'                ||Lv_Delimitador
                      ||'SOLICITUD'                     ||Lv_Delimitador); 
    --
    OPEN C_documentosNdi (Pv_FechaReporteDesde,Pv_FechaReporteHasta,Pv_EmpresaCod);

    LOOP
        FETCH C_documentosNdi BULK COLLECT INTO La_RegistrosDocumentos LIMIT Ln_Limit;
        -- 
        Ln_Indx := La_RegistrosDocumentos.FIRST;
        --
        EXIT WHEN La_RegistrosDocumentos.COUNT = 0;
        --
        WHILE (Ln_Indx IS NOT NULL)  
        LOOP
            Ln_Indr := Ln_Indr + 1;
            UTL_FILE.PUT_LINE(Lfile_Archivo,
                    NVL(REPLACE(La_RegistrosDocumentos(Ln_Indx).CLIENTE,'"',''), '') ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).IDENTIFICACION, '')          ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).LOGIN, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).FECHA_FACTURA, '')           ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).NUMERO_FACTURA_SRI_FACT, '') ||Lv_Delimitador
                  ||NVL(REPLACE(La_RegistrosDocumentos(Ln_Indx).MONTO_DIFERIDO,',','.'), '') ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).FORMA_PAGO, '')              ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).BANCO, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).TIPO_CUENTA, '')             ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).MES_DIFERIDO, '')            ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).FECHA, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).FECHA, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).NUMERO_FACTURA_SRI, '')      ||Lv_Delimitador
                  ||NVL(REPLACE(La_RegistrosDocumentos(Ln_Indx).VALOR,',','.'), '')       ||Lv_Delimitador
                  ||NVL(REPLACE(La_RegistrosDocumentos(Ln_Indx).MAIL_CLIENTE,';',','),'') ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).ESTADO_IMPRESION_FACT, '')   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).PROCESO_EJECUCION, '')       ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).PROCESO, '')                 ||Lv_Delimitador
                  ||NVL(La_RegistrosDocumentos(Ln_Indx).SOLICITUD, '')               ||Lv_Delimitador
             );

        Ln_Indx := La_RegistrosDocumentos.NEXT(Ln_Indx);
        END LOOP;
        --
    END LOOP;
      --
    CLOSE C_documentosNdi;  
    --
    UTL_FILE.fclose(Lfile_Archivo);
    dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 
    IF Ln_Indr > 0 THEN 
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip);
    END IF;
    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);

  EXCEPTION
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurri� un error al generar el reporte NDI diferidos.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_REPORTE_NDI_DIFERIDOS', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_reporte',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

  END P_REPORTE_NDI_DIFERIDOS;

  PROCEDURE P_REPORTE_NDI_PAG_DIFERIDOS(
      Pv_FechaReporteDesde IN VARCHAR2,
      Pv_FechaReporteHasta IN VARCHAR2,
      Pv_EmpresaCod        IN VARCHAR2,
      Pv_Usuario           IN VARCHAR2,
      Pv_PrefijoEmpresa    IN VARCHAR2,
      Pv_EmailUsuario      IN VARCHAR2)
  IS

    Cursor C_documentosPagosNdi (Cv_fechaCreacionDesde IN VARCHAR2,
                                 Cv_fechaCreacionHasta IN VARCHAR2,
                                 Cv_EmpresaCod         IN VARCHAR2)
    IS
    SELECT
        CASE
        WHEN IP.RAZON_SOCIAL IS NULL
        THEN IP.NOMBRES ||' '|| IP.APELLIDOS
        ELSE IP.RAZON_SOCIAL
        END AS CLIENTE,
        IP.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
        IPTO.LOGIN,
        DB_FINANCIERO.FNCK_CONSULTS.F_GET_FORMA_PAGO_CONTRATO(IPER.ID_PERSONA_ROL) AS FORMA_PAGO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_BANCO', IPER.ID_PERSONA_ROL) AS BANCO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_TIPO_CUENTA', IPER.ID_PERSONA_ROL) AS TIPO_CUENTA,
        (SELECT IDC_NCI.VALOR
         FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC_NCI,
           DB_COMERCIAL.ADMI_CARACTERISTICA AC_NCI
         WHERE IDC_NCI.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
         AND IDC_NCI.CARACTERISTICA_ID         = AC_NCI.ID_CARACTERISTICA 
         AND AC_NCI.DESCRIPCION_CARACTERISTICA = 'NUM_CUOTA_DIFERIDA'
         AND ROWNUM                            = 1) AS TOTAL_CUOTA_DIF_NDI,
        TRUNC(IPC.FE_CREACION) AS FECHA, 
        IPC.NUMERO_PAGO AS NUMERO_PAGO,
        ROUND(IPD.VALOR_PAGO,2) AS VALOR_PAGO,
        DB_FINANCIERO.FNCK_COM_ELECTRONICO.GET_ADITIONAL_DATA_BYPUNTO(IDFC.PUNTO_ID, 'MAIL') AS MAIL_CLIENTE,
        IDFC.NUMERO_FACTURA_SRI AS NDI_APLICA,
        IPC.ESTADO_PAGO,
        NVL((SELECT BDIDC.VALOR 
             FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
               DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
             WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
             AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
             AND DBAC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DE_EJECUCION'
             AND ROWNUM = 1),'PROCESO_MASIVO') AS PROCESO_EJECUCION,
        (SELECT 'NDI_PROC_'||BDIDC.VALOR 
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO'
        AND ROWNUM = 1) AS PROCESO,
        (SELECT 'NDI_SOL_'||BDIDC.VALOR 
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_ID_SOLICITUD'
        AND ROWNUM = 1) AS SOLICITUD
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB  IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO  IOG,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC, 
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_COMERCIAL.INFO_PERSONA IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PUNTO IPTO,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_FINANCIERO.INFO_PAGO_CAB IPC,
        DB_FINANCIERO.INFO_PAGO_DET IPD,
        DB_GENERAL.ADMI_FORMA_PAGO FP,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDFF  
    WHERE 
        IP.ID_PERSONA                 = IPER.PERSONA_ID                   AND
        IPTO.PERSONA_EMPRESA_ROL_ID   = IPER.ID_PERSONA_ROL               AND
        IPER.EMPRESA_ROL_ID           = IER.ID_EMPRESA_ROL                AND
        IDFC.PUNTO_ID                 = IPTO.ID_PUNTO                     AND
        IDFC.NUMERO_FACTURA_SRI       IS NOT NULL                         AND
        IDFC.TIPO_DOCUMENTO_ID        = ATDF.ID_TIPO_DOCUMENTO            AND
        IDFC.OFICINA_ID               = IOG.ID_OFICINA                    AND
        IOG.EMPRESA_ID                = Cv_EmpresaCod                     AND
        IDFC.ID_DOCUMENTO             = IDC.DOCUMENTO_ID                  AND
        AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID             AND
        ATDF.CODIGO_TIPO_DOCUMENTO    IN ('NDI')                          AND
        AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO'                AND
        IDC.VALOR                     = 'S'                               AND
        IDFC.USR_CREACION             = 'telcos_diferido'                 AND
        --
        EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO')        AND
        EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = IDFC.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_ID_SOLICITUD')          AND
        --
        IPC.ID_PAGO                 = IPD.PAGO_ID                         AND
        IPD.REFERENCIA_ID           = IDFC.ID_DOCUMENTO                   AND
        IPD.FORMA_PAGO_ID           = FP.ID_FORMA_PAGO                    AND 
        IPC.TIPO_DOCUMENTO_ID       = ATDFF.ID_TIPO_DOCUMENTO             AND
        IPC.ESTADO_PAGO             NOT IN ('Anulado','Asignado')         AND
        ATDFF.CODIGO_TIPO_DOCUMENTO IN ('PAG','PAGC','ANT','ANTC','ANTS') AND 
        IPC.FE_CREACION             >= TO_DATE(Cv_fechaCreacionDesde,'DD/MM/YY')  AND
        IPC.FE_CREACION             < TO_DATE (Cv_fechaCreacionHasta,'DD/MM/YY')+1
    ORDER BY CLIENTE;
  -- 
    Lv_IpCreacion            VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio            VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador           VARCHAR2(1)     := ';';
    Lv_Remitente             VARCHAR2(100)   := 'telcos@telconet.ec'; 
    Lv_Asunto                VARCHAR2(300);
    Lv_Cuerpo                VARCHAR2(9999); 
    Lv_FechaReporte          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo         VARCHAR2(150);
    Lv_NombreArchivoZip      VARCHAR2(250);
    Lv_Gzip                  VARCHAR2(100);
    Lv_Destinatario          VARCHAR2(500);
    Lv_MsjResultado          VARCHAR2(2000);
    Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo            UTL_FILE.FILE_TYPE;

    La_RegistrosDocPagosNdi  T_RegistrosDocPagosNdi;
    Ln_Limit                 CONSTANT PLS_INTEGER DEFAULT 5000;
    Ln_Indx                  NUMBER;
    Ln_Indr                  NUMBER := 0;

  BEGIN

    IF C_documentosPagosNdi%ISOPEN THEN
      CLOSE C_documentosPagosNdi;
    END IF;
    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_DIFERIDOS');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;    
    Lv_Destinatario      := NVL(Pv_EmailUsuario,'notificaciones_telcos@telconet.ec')||','; 

   IF Pv_Usuario = 'JOB_MENSUAL' THEN
      Lv_NombreArchivo    := 'ReportePagosNdiDiferidos'||Pv_PrefijoEmpresa||'_'||'MENSUAL'||Lv_FechaReporte||'.csv';
      Lv_Gzip             := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip := Lv_NombreArchivo||'.gz';
      Lv_Asunto           := 'Notificacion REPORTE PAGOS MENSUAL DE NDI DIFERIDAS';
    END IF;

    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);
    --
    utl_file.put_line(Lfile_Archivo,'CLIENTE'           ||Lv_Delimitador
                      ||'IDENTIFICACION'                ||Lv_Delimitador
                      ||'LOGIN'                         ||Lv_Delimitador
                      ||'FORMA DE PAGO'                 ||Lv_Delimitador
                      ||'BANCO'                         ||Lv_Delimitador
                      ||'TIPO CUENTA'                   ||Lv_Delimitador
                      ||'TOTAL CUOTA DIF_NDI'           ||Lv_Delimitador
                      ||'FECHA PAGO'                    ||Lv_Delimitador
                      ||'NUMERO PAGO'                   ||Lv_Delimitador
                      ||'VALOR PAGO'                    ||Lv_Delimitador
                      ||'MAIL CLIENTE'                  ||Lv_Delimitador
                      ||'NDI APLICA'                    ||Lv_Delimitador
                      ||'ESTADO PAGO'                   ||Lv_Delimitador
                      ||'PROCESO EJECUCION'             ||Lv_Delimitador
                      ||'PROCESO MASIVO'                ||Lv_Delimitador
                      ||'SOLICITUD'                     ||Lv_Delimitador); 
    --
    OPEN C_documentosPagosNdi (Pv_FechaReporteDesde,Pv_FechaReporteHasta,Pv_EmpresaCod);

    LOOP
        FETCH C_documentosPagosNdi BULK COLLECT INTO La_RegistrosDocPagosNdi LIMIT Ln_Limit;
        -- 
        Ln_Indx := La_RegistrosDocPagosNdi.FIRST;
        --
        EXIT WHEN La_RegistrosDocPagosNdi.COUNT = 0;
        --
        WHILE (Ln_Indx IS NOT NULL)  
        LOOP
            Ln_Indr := Ln_Indr + 1;
            UTL_FILE.PUT_LINE(Lfile_Archivo,
                    NVL(REPLACE(La_RegistrosDocPagosNdi(Ln_Indx).CLIENTE,'"',''), '') ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).IDENTIFICACION, '')          ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).LOGIN, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).FORMA_PAGO, '')              ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).BANCO, '')                   ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).TIPO_CUENTA, '')             ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).TOTAL_CUOTA_DIF_NDI, '')     ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).FECHA_PAGO, '')              ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).NUMERO_PAGO, '')             ||Lv_Delimitador
                  ||NVL(REPLACE(La_RegistrosDocPagosNdi(Ln_Indx).VALOR_PAGO,',','.'), '')   ||Lv_Delimitador
                  ||NVL(REPLACE(La_RegistrosDocPagosNdi(Ln_Indx).MAIL_CLIENTE,';',','), '') ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).NDI_APLICA, '')              ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).ESTADO_PAGO, '')             ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).PROCESO_EJECUCION, '')       ||Lv_Delimitador                  
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).PROCESO, '')                 ||Lv_Delimitador
                  ||NVL(La_RegistrosDocPagosNdi(Ln_Indx).SOLICITUD, '')               ||Lv_Delimitador
             );

        Ln_Indx := La_RegistrosDocPagosNdi.NEXT(Ln_Indx);
        END LOOP;
        --
    END LOOP;
      --
    CLOSE C_documentosPagosNdi;  
    --
    UTL_FILE.fclose(Lfile_Archivo);
    dbms_output.put_line( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ; 
    IF Ln_Indr > 0 THEN 
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip);
    END IF;
    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);

  EXCEPTION
    WHEN OTHERS THEN
      Lv_MsjResultado := 'Ocurri� un error al generar el reporte de pagos NDI diferidos.';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_REPORTE_NDI_PAG_DIFERIDOS', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_reporte',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

  END P_REPORTE_NDI_PAG_DIFERIDOS;  

  FUNCTION F_CANTIDAD_FACTURA(Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Fv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                              Fv_Caracteristica  IN DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                              Fn_CostoMininoFact IN NUMBER)
    RETURN NUMBER 
  IS

    --Costo: 15
    CURSOR C_TotalFacturas(Cn_PuntoId        NUMBER,
                           Cv_EmpresaId      VARCHAR2,
                           Cv_Caracteristica VARCHAR2,
                           Cn_ValorFactura   NUMBER)
    IS
      SELECT COUNT(IDFC.ID_DOCUMENTO) AS TOTAL
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
      WHERE IDFC.NUMERO_FACTURA_SRI  IS NOT NULL
      AND IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
      AND IDFC.OFICINA_ID            = IOG.ID_OFICINA
      AND IOG.EMPRESA_ID             = COALESCE(TO_NUMBER(REGEXP_SUBSTR(Cv_EmpresaId,'^\d+')),0)
      AND IDFC.PUNTO_ID              = Cn_PuntoId
      AND ATDF.CODIGO_TIPO_DOCUMENTO IN ('FAC','FACP')
      AND IDFC.ESTADO_IMPRESION_FACT IN ('Activo','Activa','Courier')
      AND NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(IDFC.ID_DOCUMENTO, 
                                                                          TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                          'saldo'),2),0 ) > Cn_ValorFactura
      AND DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_NC_FACT(IDFC.ID_DOCUMENTO) = 0
      AND NOT EXISTS (SELECT  IDC.CARACTERISTICA_ID 
                      FROM DB_COMERCIAL.ADMI_CARACTERISTICA DBAC,
                        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC
                      WHERE DBAC.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
                      AND IDC.DOCUMENTO_ID                  = IDFC.ID_DOCUMENTO
                      AND IDC.CARACTERISTICA_ID             = DBAC.ID_CARACTERISTICA);

    Ln_TotalFacturas  NUMBER;
    Lv_IpCreacion     VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User           VARCHAR2(1000) := 'telcos_diferido';
    Lv_MsjResultado   VARCHAR2(2000); 
    Lex_Exception     EXCEPTION;

  BEGIN
  --
    IF C_TotalFacturas%ISOPEN THEN
    --
      CLOSE C_TotalFacturas;
    --
    END IF;

    OPEN C_TotalFacturas(Fn_IdPunto,
                         Fv_CodEmpresa,
                         Fv_Caracteristica,
                         Fn_CostoMininoFact);
    FETCH C_TotalFacturas 
      INTO Ln_TotalFacturas;

      IF C_TotalFacturas%NOTFOUND THEN
        Lv_MsjResultado := 'Error al Obtener el total de facturas por punto, punto_id: '|| Fn_IdPunto ||' .';
        RAISE Lex_Exception;  
      END IF;
    CLOSE C_TotalFacturas;

    RETURN Ln_TotalFacturas;

  EXCEPTION
  WHEN Lex_Exception THEN
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_FACTURA', 
                                           Lv_MsjResultado,
                                           Lv_User,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    Ln_TotalFacturas := 0;
    RETURN Ln_TotalFacturas;
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Error al Obtener el total de facturas por punto, punto_id: '|| Fn_IdPunto ||' .'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_FACTURA', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_User,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    Ln_TotalFacturas := 0;
    RETURN Ln_TotalFacturas;
  END F_CANTIDAD_FACTURA;

  PROCEDURE P_REPORTE_CREACION_SOL (Pn_IdProceso   IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                                    Pv_Ciclos      IN VARCHAR2,
                                    Pv_Meses       IN VARCHAR2,
                                    Pv_Estados     IN VARCHAR2,
                                    Pv_SaldoDesde  IN VARCHAR2,
                                    Pv_SaldoHasta  IN VARCHAR2,
                                    Pv_Usuario     IN VARCHAR2,
                                    Pv_Error       OUT VARCHAR2)
  IS
    --Costo: 13076
    CURSOR C_GetDatosReporte (Cn_IdProceso DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
    IS
      SELECT DISTINCT
        CASE
        WHEN IPE.RAZON_SOCIAL IS NULL
        THEN IPE.NOMBRES
          ||' '
          || IPE.APELLIDOS
        ELSE IPE.RAZON_SOCIAL
        END AS CLIENTE,
        IPE.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
        IP.LOGIN,
        ISE.ESTADO AS ESTADO_SERVICIO,
        (SELECT DBAJ.NOMBRE_JURISDICCION 
         FROM DB_INFRAESTRUCTURA.ADMI_JURISDICCION DBAJ 
         WHERE ID_JURISDICCION = IP.PUNTO_COBERTURA_ID) AS JURISDICCION,
        DB_FINANCIERO.FNCK_CONSULTS.F_GET_FORMA_PAGO_CONTRATO(IPER.ID_PERSONA_ROL) AS FORMA_PAGO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_BANCO', IPER.ID_PERSONA_ROL) AS BANCO,
        DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_INFORMACION_CONTRATO ('DESCRIPCION_TIPO_CUENTA', IPER.ID_PERSONA_ROL) AS TIPO_CUENTA,
        (SELECT SUM(NVL(ROUND(DB_FINANCIERO.FNKG_CARTERA_CLIENTES.F_SALDO_X_FACTURA(DBIDSL.VALOR, 
                                                                                    TO_CHAR(SYSDATE,'DD-MM-RRRR'),
                                                                                    'saldo'),2),0 )) AS SALDO 
         FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT DBIDSL,
           DB_COMERCIAL.ADMI_CARACTERISTICA DBCAR
         WHERE DBIDSL.DETALLE_SOLICITUD_ID    = IDS.ID_DETALLE_SOLICITUD
         AND DBIDSL.CARACTERISTICA_ID         = DBCAR.ID_CARACTERISTICA
         AND DBCAR.DESCRIPCION_CARACTERISTICA = 'ES_SOL_FACTURA') AS SALDO
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDSC,
        DB_COMERCIAL.ADMI_CARACTERISTICA CARC,
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
        DB_COMERCIAL.INFO_SERVICIO ISE,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE
      WHERE CARC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO'
      AND IDSC.CARACTERISTICA_ID            = CARC.ID_CARACTERISTICA
      AND IDSC.USR_CREACION                 = 'telcos_diferido'
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDSC.VALOR,'^\d+')),0) = Cn_IdProceso
      AND IDS.ID_DETALLE_SOLICITUD          = IDSC.DETALLE_SOLICITUD_ID
      AND ISE.ID_SERVICIO                   = IDS.SERVICIO_ID
      AND IP.ID_PUNTO                       = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL               = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA                    = IPER.PERSONA_ID
      ORDER BY CLIENTE;
    --
    Lv_IpCreacion             VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio             VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador            VARCHAR2(1)     := ',';
    Lv_Remitente              VARCHAR2(100)   := 'notificaciones_telcos@telconet.ec';
    Lv_Asunto                 VARCHAR2(300)   := 'Reporte Final de Creaci�n de NCI por Emergencia Sanitaria';
    Lv_Cuerpo                 VARCHAR2(9999); 
    Lv_FechaReporte           VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivo          VARCHAR2(150);
    Lv_NombreArchivoZip       VARCHAR2(250);
    Lv_Gzip                   VARCHAR2(100);
    Lv_AliasCorreos           VARCHAR2(500);
    Lv_Destinatario           VARCHAR2(500);
    Lv_User                   VARCHAR2(1000) := 'telcos_diferido';
    Lv_MsjResultado           VARCHAR2(2000);
    Ln_Indx                   NUMBER;
    Lc_GetAliasPlantilla      DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo             UTL_FILE.FILE_TYPE;
    La_RegistrosDatosRpt      T_RegistrosDatosRpt;
    Ln_Limit                  CONSTANT PLS_INTEGER DEFAULT 5000;

  BEGIN

    IF C_GetDatosReporte%ISOPEN THEN
      CLOSE C_GetDatosReporte;
    END IF;

    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('RPT_FIN_SOL_ES');
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
    Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';
    --
    Lv_NombreArchivo     := 'Rpt_Final_Creacion_Sol_'||Pn_IdProceso||'_'||Pv_Usuario||'_'||Lv_FechaReporte||'.csv';
    Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

    utl_file.put_line(Lfile_Archivo,''||Lv_Delimitador||
                      ''||Lv_Delimitador||
                      ''||Lv_Delimitador||
                      'REPORTE FINAL DE CREACI�N DE NCI POR EMERGENCIA SANITARIA'||Lv_Delimitador);
    utl_file.put_line(Lfile_Archivo,''||Lv_Delimitador);
    utl_file.put_line(Lfile_Archivo,'SALDO DESDE: '||Pv_SaldoDesde||Lv_Delimitador
                      ||''||Lv_Delimitador
                      ||'SALDO HASTA: '||Pv_SaldoHasta);
    utl_file.put_line(Lfile_Archivo,'CICLO FACTURACI�N: '||REPLACE(Pv_Ciclos,',',' ')||Lv_Delimitador
                      ||''||Lv_Delimitador
                      ||'MESES A DIFERIR: '||Pv_Meses);
    utl_file.put_line(Lfile_Archivo,'ESTADO SERVICIO: '||REPLACE(Pv_Estados,',',' '));
    utl_file.put_line(Lfile_Archivo,''||Lv_Delimitador);
    utl_file.put_line(Lfile_Archivo,'IDENTIFICACI�N'||Lv_Delimitador 
                      ||'LOGIN'||Lv_Delimitador  
                      ||'NOMBRE'||Lv_Delimitador 
                      ||'ESTADO SERVICIO'||Lv_Delimitador     
                      ||'JURISDICCI�N'||Lv_Delimitador 
                      ||'FORMA DE PAGO'||Lv_Delimitador
                      ||'BANCO'||Lv_Delimitador
                      ||'TIPO CUENTA'||Lv_Delimitador
                      ||'SALDO A DIFERIR'||Lv_Delimitador
                      ||'N�MERO DIFERIDO'||Lv_Delimitador
                      ||'PROCESO MASIVO'||Lv_Delimitador);  

    OPEN C_GetDatosReporte(Pn_IdProceso);
    LOOP
      FETCH C_GetDatosReporte BULK COLLECT INTO La_RegistrosDatosRpt LIMIT Ln_Limit;
      -- 
        Ln_Indx := La_RegistrosDatosRpt.FIRST;
        --
        EXIT WHEN La_RegistrosDatosRpt.COUNT = 0;
        --
        WHILE (Ln_Indx IS NOT NULL)  
        LOOP


          UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(La_RegistrosDatosRpt(Ln_Indx).IDENTIFICACION, '')||Lv_Delimitador
                            ||NVL(La_RegistrosDatosRpt(Ln_Indx).LOGIN, '')||Lv_Delimitador
                            ||NVL(REPLACE(REPLACE(La_RegistrosDatosRpt(Ln_Indx).CLIENTE,',',''),'"',''), '')||Lv_Delimitador
                            ||NVL(La_RegistrosDatosRpt(Ln_Indx).ESTADO, '')||Lv_Delimitador
                            ||NVL(La_RegistrosDatosRpt(Ln_Indx).JURISDICCION, '')||Lv_Delimitador
                            ||NVL(La_RegistrosDatosRpt(Ln_Indx).FORMA_PAGO, '')||Lv_Delimitador
                            ||NVL(La_RegistrosDatosRpt(Ln_Indx).BANCO, '')||Lv_Delimitador
                            ||NVL(La_RegistrosDatosRpt(Ln_Indx).TIPO_CUENTA, '')||Lv_Delimitador
                            ||NVL(REPLACE(La_RegistrosDatosRpt(Ln_Indx).SALDO,',','.'), '')||Lv_Delimitador
                            ||NVL(Pv_Meses, '')||Lv_Delimitador
                            ||'PM_'||NVL(Pn_IdProceso, '')||Lv_Delimitador);


          Ln_Indx := La_RegistrosDatosRpt.NEXT(Ln_Indx);
        END LOOP;
        --
    END LOOP;
    --
    CLOSE C_GetDatosReporte;

    UTL_FILE.fclose(Lfile_Archivo);
    DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) ) ;
    DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente, 
                                              Lv_Destinatario,
                                              Lv_Asunto, 
                                              Lv_Cuerpo, 
                                              Lv_Directorio,
                                              Lv_NombreArchivoZip,
                                              'text/html; charset=UTF-8');

    UTL_FILE.FREMOVE (Lv_Directorio,Lv_NombreArchivoZip);

  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsjResultado := 'Ocurri� un error al ejecutar el reporte final de creaci�n de solicitudes para el id_Proceso: '
                         ||Pn_IdProceso;
      Pv_Error        := Lv_MsjResultado;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_REPORTE_CREACION_SOL', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           Lv_User,
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));            
  END P_REPORTE_CREACION_SOL;

  FUNCTION F_CANTIDAD_NC_FACT(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER 
  IS

    --Costo: 5                              
    CURSOR C_GetNotaCreditoNoActiva(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT COUNT(IDFC.ID_DOCUMENTO) AS VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF
      WHERE IDFC.TIPO_DOCUMENTO_ID     = ATDF.ID_TIPO_DOCUMENTO
      AND ATDF.ESTADO                  = 'Activo'
      AND ATDF.CODIGO_TIPO_DOCUMENTO   IN ('NC','NCI')
      AND IDFC.ESTADO_IMPRESION_FACT   IN ('Pendiente', 'Aprobada')
      AND IDFC.REFERENCIA_DOCUMENTO_ID = Cn_IdDocumento;

    Ln_CantNcFat      NUMBER;
    Lv_IpCreacion     VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User           VARCHAR2(1000) := 'telcos_diferido';
    Lv_MsjResultado   VARCHAR2(2000); 

  BEGIN
  --
    IF C_GetNotaCreditoNoActiva%ISOPEN THEN        
      CLOSE C_GetNotaCreditoNoActiva;        
    END IF;

    --Obtiene NC o NCI en estado Pendiente o Aprobada
    OPEN C_GetNotaCreditoNoActiva(Fn_IdDocumento);
    --
    FETCH C_GetNotaCreditoNoActiva INTO Ln_CantNcFat;
    --
    CLOSE C_GetNotaCreditoNoActiva;

    RETURN Ln_CantNcFat;

  EXCEPTION
  WHEN OTHERS THEN
  --
    Ln_CantNcFat    := 0;
    Lv_MsjResultado := 'Error al Obtener el total de NC por facturas para el id_documenti: '|| Fn_IdDocumento ||' .'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.F_CANTIDAD_FACTURA', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_User,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN Ln_CantNcFat;
  END F_CANTIDAD_NC_FACT;

  FUNCTION F_OBSERVACION_NDI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN CLOB 
  IS

    --Costo: 9                              
    CURSOR C_GetNotasDeCredito(Cn_IdDocumento DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                               Cv_Usuario     VARCHAR2)
    IS
      SELECT NCIDFC.NUMERO_FACTURA_SRI,
        (SELECT DBIDC.VALOR 
         FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB DBIDFC,
           DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO DBATDF,
           DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DBIDC,
           DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
         WHERE DBIDFC.TIPO_DOCUMENTO_ID      = DBATDF.ID_TIPO_DOCUMENTO
         AND DBIDFC.USR_CREACION             = Cv_Usuario
         AND DBATDF.CODIGO_TIPO_DOCUMENTO    = 'NCI'
         AND DBIDC.DOCUMENTO_ID              = DBIDFC.ID_DOCUMENTO
         AND DBIDC.USR_CREACION              = Cv_Usuario
         AND DBAC.ID_CARACTERISTICA          = DBIDC.CARACTERISTICA_ID
         AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_CONT_DIFERIDO'
         AND DBIDFC.ID_DOCUMENTO             = NCIDFC.ID_DOCUMENTO
         AND ROWNUM                          = 1) AS CUOTA,
        (SELECT DBIDC.VALOR 
         FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB DBIDFC,
           DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO DBATDF,
           DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DBIDC,
           DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
         WHERE DBIDFC.TIPO_DOCUMENTO_ID      = DBATDF.ID_TIPO_DOCUMENTO
         AND DBIDFC.USR_CREACION             = Cv_Usuario
         AND DBATDF.CODIGO_TIPO_DOCUMENTO    = 'NCI'
         AND DBIDC.DOCUMENTO_ID              = DBIDFC.ID_DOCUMENTO
         AND DBIDC.USR_CREACION              = Cv_Usuario
         AND DBAC.ID_CARACTERISTICA          = DBIDC.CARACTERISTICA_ID
         AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_MESES_DIFERIDO'
         AND DBIDFC.ID_DOCUMENTO             = NCIDFC.ID_DOCUMENTO
         AND ROWNUM                          = 1) AS TOTALCUOTA,
        (SELECT DBIDC.VALOR 
         FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DBIDC,
           DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
         WHERE DBIDC.DOCUMENTO_ID              = IDFC.ID_DOCUMENTO
         AND DBIDC.USR_CREACION                = Cv_Usuario
         AND DBAC.ID_CARACTERISTICA            = DBIDC.CARACTERISTICA_ID
         AND DBAC.DESCRIPCION_CARACTERISTICA   = 'VALOR_CUOTA_DIFERIDA'
         AND DBIDC.DOCUMENTO_CARACTERISTICA_ID = IDC.ID_DOCUMENTO_CARACTERISTICA
         AND ROWNUM                            = 1) AS VALORCUOTA
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCIDFC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE IDFC.ID_DOCUMENTO           = Cn_IdDocumento
      AND IDFC.USR_CREACION             = Cv_Usuario
      AND ATDF.ID_TIPO_DOCUMENTO        = IDFC.TIPO_DOCUMENTO_ID
      AND ATDF.CODIGO_TIPO_DOCUMENTO    = 'NDI'
      AND IDC.DOCUMENTO_ID              = IDFC.ID_DOCUMENTO
      AND IDC.USR_CREACION              = Cv_Usuario
      AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA = 'ID_REFERENCIA_NCI'
      AND NCIDFC.ID_DOCUMENTO           = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0);

    Lc_Observacion    CLOB;
    Lc_Cuerpo         CLOB;
    Lv_IpCreacion     VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User           VARCHAR2(1000) := 'telcos_diferido';
    Lv_MsjResultado   VARCHAR2(2000); 
    Lex_Exception     EXCEPTION;

  BEGIN
  --
    IF C_GetNotasDeCredito%ISOPEN THEN        
      CLOSE C_GetNotasDeCredito;        
    END IF;

    FOR Lc_GetNotasDeCredito IN C_GetNotasDeCredito(Fn_IdDocumento,Lv_User) LOOP
    --
      IF Lc_GetNotasDeCredito.CUOTA IS NOT NULL AND Lc_GetNotasDeCredito.TOTALCUOTA IS NOT NULL AND 
         Lc_GetNotasDeCredito.NUMERO_FACTURA_SRI IS NOT NULL AND Lc_GetNotasDeCredito.VALORCUOTA IS NOT NULL THEN
         Lc_Cuerpo := Lc_Cuerpo || ' cuota ' || Lc_GetNotasDeCredito.CUOTA || '/' || Lc_GetNotasDeCredito.TOTALCUOTA || 
                      ' generada por NCI  ' || Lc_GetNotasDeCredito.NUMERO_FACTURA_SRI || ' $' || 
                      Lc_GetNotasDeCredito.VALORCUOTA || ',';
      END IF;
    --
    END LOOP;

    IF Lc_Cuerpo IS NULL THEN
      RAISE Lex_Exception;
    END IF;

    Lc_Observacion := 'Nota de debito interna por saldo diferido,' || SUBSTR (Lc_Cuerpo, 1, Length(Lc_Cuerpo) - 1 );

    RETURN Lc_Observacion;

  EXCEPTION
  WHEN Lex_Exception THEN
  --
    Lc_Observacion  := NULL;
    Lv_MsjResultado := 'No existe data para el id_documento: '|| Fn_IdDocumento ||' .';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                        'FNCK_PAGOS_DIFERIDOS.F_OBSERVACION_NDI', 
                                        Lv_MsjResultado,
                                        Lv_User,
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    RETURN Lc_Observacion;
  WHEN OTHERS THEN
  --
    Lc_Observacion  := NULL;
    Lv_MsjResultado := 'Error al Obtener la observaci�n del id_documento: '|| Fn_IdDocumento ||' .'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.F_OBSERVACION_NDI', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_User,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN Lc_Observacion;
  END F_OBSERVACION_NDI;

  FUNCTION F_CUOTA_X_VENCER_NDI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER 
  IS

    --Costo: 8
    CURSOR C_CuotaXVencerDoc(Cn_IdDocumento         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                             Cv_CaractReferenciaNci VARCHAR2,
                             Cv_CaractMesesDiferido VARCHAR2,
                             Cv_CaractContDiferido  VARCHAR2,
                             Cv_EstadoActivo        VARCHAR2,
                             Cv_Usuario             VARCHAR2)
    IS
      SELECT 
        ROUND(SUM(FNCK_PAGOS_DIFERIDOS.F_GET_VALOR_CUOTA_DIFERIDA(NCI.ID_DOCUMENTO,
                  COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,
                                                                                               Cv_CaractContDiferido),'^\d+')),0) +1, 
                  COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,
                                                                                               Cv_CaractMesesDiferido),'^\d+')),0))
              ),2)AS SALDO
      FROM INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC 
      WHERE DOCUMENTO_ID                = Cn_IdDocumento
      AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_CaractReferenciaNci
      AND NCI.ID_DOCUMENTO              = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0)
      AND NCI.USR_CREACION              = Cv_Usuario
      AND NCI.ESTADO_IMPRESION_FACT     = Cv_EstadoActivo
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0)
      < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0);

    --Costo: 8
    CURSOR C_NDIDiferido(Cn_IdDocumento  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT COUNT('X') AS VALOR 
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE IDFC.ID_DOCUMENTO = Cn_IdDocumento
      AND ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
      AND ATDF.CODIGO_TIPO_DOCUMENTO = 'NDI'
      AND IDC.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
      AND AC.ID_CARACTERISTICA = IDC.CARACTERISTICA_ID
      AND IDC.VALOR = 'S'
      AND IDC.USR_CREACION = 'telcos_diferido'
      AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO';

    Ln_Saldo               NUMBER;
    Ln_Existe              NUMBER;
    Lv_IpCreacion          VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User                VARCHAR2(1000):= 'telcos_diferido';
    Lv_MsjResultado        VARCHAR2(2000); 
    Lv_CaractReferenciaNci VARCHAR2(20):= 'ID_REFERENCIA_NCI';
    Lv_CaractMesesDiferido VARCHAR2(20):= 'ES_MESES_DIFERIDO';
    Lv_CaractContDiferido  VARCHAR2(20):= 'ES_CONT_DIFERIDO';
    Lv_EstadoActivo        VARCHAR2(6):= 'Activo';

  BEGIN
  --
    IF C_CuotaXVencerDoc%ISOPEN THEN        
      CLOSE C_CuotaXVencerDoc;        
    END IF;

    IF C_NDIDiferido%ISOPEN THEN        
      CLOSE C_NDIDiferido;        
    END IF;

    OPEN C_NDIDiferido(Fn_IdDocumento);
    --
    FETCH C_NDIDiferido INTO Ln_Existe;
    --
    CLOSE C_NDIDiferido;

    IF Ln_Existe = 0 THEN
      Ln_Saldo := NULL;
      RETURN Ln_Saldo;
    END IF;

    OPEN C_CuotaXVencerDoc(Fn_IdDocumento,
                           Lv_CaractReferenciaNci,
                           Lv_CaractMesesDiferido,
                           Lv_CaractContDiferido,
                           Lv_EstadoActivo,
                           Lv_User);
    --
    FETCH C_CuotaXVencerDoc INTO Ln_Saldo;
    --
    CLOSE C_CuotaXVencerDoc;

    RETURN NVL(Ln_Saldo,0);

  EXCEPTION
  WHEN OTHERS THEN
  --
    Ln_Saldo        := NULL;
    Lv_MsjResultado := 'Error al obtener el saldo total de la NDI: '|| Fn_IdDocumento ||' .'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.F_CUOTA_X_VENCER_NDI', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_User,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN Ln_Saldo;
  END F_CUOTA_X_VENCER_NDI;

  FUNCTION F_SALDO_X_DIFERIR_NDI(Fn_IdDocumento  IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    RETURN NUMBER 
  IS

    --Costo: 8
    CURSOR C_CuotasXVencerDoc(Cn_IdDocumento         DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
                              Cv_CaractReferenciaNci VARCHAR2,
                              Cv_CaractMesesDiferido VARCHAR2,
                              Cv_CaractContDiferido  VARCHAR2,
                              Cv_EstadoActivo        VARCHAR2,
                              Cv_Usuario             VARCHAR2)
    IS
      SELECT DISTINCT
        NCI.ID_DOCUMENTO,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0) 
        + 1 AS ES_CONT_DIFERIDO,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0)
        AS ES_MESES_DIFERIDO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC 
      WHERE DOCUMENTO_ID                = Cn_IdDocumento
      AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_CaractReferenciaNci
      AND NCI.ID_DOCUMENTO              = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0)
      AND NCI.USR_CREACION              = Cv_Usuario
      AND NCI.ESTADO_IMPRESION_FACT     = Cv_EstadoActivo
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0)
      < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0);

    --Costo: 8
    CURSOR C_NDIDiferido(Cn_IdDocumento  DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE)
    IS
      SELECT COUNT('X') AS VALOR 
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB IDFC,
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO ATDF,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE IDFC.ID_DOCUMENTO = Cn_IdDocumento
      AND ATDF.ID_TIPO_DOCUMENTO = IDFC.TIPO_DOCUMENTO_ID
      AND ATDF.CODIGO_TIPO_DOCUMENTO = 'NDI'
      AND IDC.DOCUMENTO_ID = IDFC.ID_DOCUMENTO
      AND AC.ID_CARACTERISTICA = IDC.CARACTERISTICA_ID
      AND IDC.VALOR = 'S'
      AND IDC.USR_CREACION = 'telcos_diferido'
      AND AC.DESCRIPCION_CARACTERISTICA = 'PROCESO_DIFERIDO';

    Ln_Saldo               NUMBER;
    Ln_Desde               NUMBER;
    Ln_Hasta               NUMBER;
    Ln_Existe              NUMBER;
    Lv_IpCreacion          VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User                VARCHAR2(1000):= 'telcos_diferido';
    Lv_MsjResultado        VARCHAR2(2000); 
    Lv_CaractReferenciaNci VARCHAR2(20):= 'ID_REFERENCIA_NCI';
    Lv_CaractMesesDiferido VARCHAR2(20):= 'ES_MESES_DIFERIDO';
    Lv_CaractContDiferido  VARCHAR2(20):= 'ES_CONT_DIFERIDO';
    Lv_EstadoActivo        VARCHAR2(6):= 'Activo';

  BEGIN
  --
    IF C_CuotasXVencerDoc%ISOPEN THEN        
      CLOSE C_CuotasXVencerDoc;        
    END IF;

    IF C_NDIDiferido%ISOPEN THEN        
      CLOSE C_NDIDiferido;        
    END IF;

    OPEN C_NDIDiferido(Fn_IdDocumento);
    --
    FETCH C_NDIDiferido INTO Ln_Existe;
    --
    CLOSE C_NDIDiferido;

    IF Ln_Existe = 0 THEN
      Ln_Saldo := NULL;
      RETURN Ln_Saldo;
    END IF;

    Ln_Saldo := 0;

    FOR Lr_CuotasXVencerDoc IN C_CuotasXVencerDoc(Fn_IdDocumento,
                                                  Lv_CaractReferenciaNci,
                                                  Lv_CaractMesesDiferido,
                                                  Lv_CaractContDiferido,
                                                  Lv_EstadoActivo,
                                                  Lv_User)  LOOP

      Ln_Desde := Lr_CuotasXVencerDoc.ES_CONT_DIFERIDO;
      Ln_Hasta := Lr_CuotasXVencerDoc.ES_MESES_DIFERIDO;

      WHILE Ln_Desde <= Ln_Hasta
      LOOP
        Ln_Saldo := Ln_Saldo + ROUND(F_GET_VALOR_CUOTA_DIFERIDA(Lr_CuotasXVencerDoc.ID_DOCUMENTO,
                                                                Ln_Desde,
                                                                Ln_Hasta),2);
        Ln_Desde := Ln_Desde + 1; 
      END LOOP;

    END LOOP;

    RETURN NVL(Ln_Saldo,0);

  EXCEPTION
  WHEN OTHERS THEN
  --
    Ln_Saldo        := NULL;
    Lv_MsjResultado := 'Error al obtener el saldo total por generarse de la NDI: '|| Fn_IdDocumento ||' .'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.F_SALDO_X_DIFERIR_NDI', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_User,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN Ln_Saldo;
  END F_SALDO_X_DIFERIR_NDI;

  FUNCTION F_SALDO_X_DIFERIR_PTO(Fn_IdPunto  IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE)
    RETURN NUMBER 
  IS

    --Costo: 33
    CURSOR C_CuotasXVencerDoc(Cn_IdPunto             DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Cv_CaractReferenciaNci VARCHAR2,
                              Cv_CaractMesesDiferido VARCHAR2,
                              Cv_CaractContDiferido  VARCHAR2,
                              Cv_EstadoActivo        VARCHAR2,
                              Cv_Usuario             VARCHAR2)
    IS
      SELECT DISTINCT
        NCI.ID_DOCUMENTO,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0) 
        + 1 AS ES_CONT_DIFERIDO,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0)
        AS ES_MESES_DIFERIDO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NDI,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC 
      WHERE NDI.PUNTO_ID                = Cn_IdPunto
      AND NDI.USR_CREACION              = Cv_Usuario
      AND TDOC.ID_TIPO_DOCUMENTO        = NDI.TIPO_DOCUMENTO_ID
      AND TDOC.CODIGO_TIPO_DOCUMENTO    = 'NDI'
      AND IDC.DOCUMENTO_ID              = NDI.ID_DOCUMENTO
      AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_CaractReferenciaNci
      AND NCI.ID_DOCUMENTO              = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0)
      AND NCI.USR_CREACION              = Cv_Usuario
      AND NCI.ESTADO_IMPRESION_FACT     = Cv_EstadoActivo
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0)
      < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0);

    Ln_Saldo               NUMBER;
    Ln_Desde               NUMBER;
    Ln_Hasta               NUMBER;
    Lv_IpCreacion          VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User                VARCHAR2(1000):= 'telcos_diferido';
    Lv_MsjResultado        VARCHAR2(2000); 
    Lv_CaractReferenciaNci VARCHAR2(20):= 'ID_REFERENCIA_NCI';
    Lv_CaractMesesDiferido VARCHAR2(20):= 'ES_MESES_DIFERIDO';
    Lv_CaractContDiferido  VARCHAR2(20):= 'ES_CONT_DIFERIDO';
    Lv_EstadoActivo        VARCHAR2(6):= 'Activo';

  BEGIN
  --
    IF C_CuotasXVencerDoc%ISOPEN THEN        
      CLOSE C_CuotasXVencerDoc;        
    END IF;

    Ln_Saldo := 0;

    FOR Lr_CuotasXVencerDoc IN C_CuotasXVencerDoc(Fn_IdPunto,
                                                  Lv_CaractReferenciaNci,
                                                  Lv_CaractMesesDiferido,
                                                  Lv_CaractContDiferido,
                                                  Lv_EstadoActivo,
                                                  Lv_User)  LOOP

      Ln_Desde := Lr_CuotasXVencerDoc.ES_CONT_DIFERIDO;
      Ln_Hasta := Lr_CuotasXVencerDoc.ES_MESES_DIFERIDO;

      WHILE Ln_Desde <= Ln_Hasta
      LOOP
        Ln_Saldo := Ln_Saldo + ROUND(F_GET_VALOR_CUOTA_DIFERIDA(Lr_CuotasXVencerDoc.ID_DOCUMENTO,
                                                                Ln_Desde,
                                                                Ln_Hasta),2);
        Ln_Desde := Ln_Desde + 1; 
      END LOOP;

    END LOOP;

    RETURN NVL(Ln_Saldo,0);

  EXCEPTION
  WHEN OTHERS THEN
  --
    Ln_Saldo        := 0;
    Lv_MsjResultado := 'Error al obtener el saldo total de NDI por generarse del id_punto: '|| Fn_IdPunto ||' .'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.F_SALDO_X_DIFERIR_PTO', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_User,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN Ln_Saldo;
  END F_SALDO_X_DIFERIR_PTO;

  FUNCTION F_TABLA_NCI_X_PTO(Fn_IdPunto      IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                             Fn_IdProcesoMsv IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
    RETURN T_DatosNCI 
  IS

    --Costo: 33
    CURSOR C_CuotasXVencerDoc(Cn_IdPunto             DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Cn_idProceso           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                              Cv_CaractReferenciaNci VARCHAR2,
                              Cv_CaractMesesDiferido VARCHAR2,
                              Cv_CaractContDiferido  VARCHAR2,
                              Cv_EstadoActivo        VARCHAR2,
                              Cv_Usuario             VARCHAR2)
    IS
      SELECT DISTINCT
        NCI.ID_DOCUMENTO,
        NCI.NUMERO_FACTURA_SRI,
        NCI.ESTADO_IMPRESION_FACT,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0) 
        + 1 AS ES_CONT_DIFERIDO,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0)
        AS ES_MESES_DIFERIDO,
        (SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(BDIDC.VALOR,'^\d+')),0)
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = NCI.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO'
        AND ROWNUM = 1) AS PROCESO,
        (SELECT COALESCE(TO_NUMBER(REGEXP_SUBSTR(BDIDC.VALOR,'^\d+')),0) 
        FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
        DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
        WHERE BDIDC.DOCUMENTO_ID            = NCI.ID_DOCUMENTO
        AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
        AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_ID_SOLICITUD'
        AND ROWNUM = 1) AS SOLICITUD,
        NDI.PUNTO_ID
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NDI,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC 
      WHERE NDI.PUNTO_ID                = Cn_IdPunto
      AND NDI.USR_CREACION              = Cv_Usuario
      AND TDOC.ID_TIPO_DOCUMENTO        = NDI.TIPO_DOCUMENTO_ID
      AND TDOC.CODIGO_TIPO_DOCUMENTO    = 'NDI'
      AND IDC.DOCUMENTO_ID              = NDI.ID_DOCUMENTO
      AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_CaractReferenciaNci
      AND NCI.ID_DOCUMENTO              = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0)
      AND NCI.USR_CREACION              = Cv_Usuario
      AND NCI.ESTADO_IMPRESION_FACT     = Cv_EstadoActivo
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0)
      < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0)
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,'ES_PROCESO_MASIVO'),'^\d+')),0) = Cn_idProceso;

    Ln_Saldo               NUMBER;
    Ln_Desde               NUMBER;
    Ln_Hasta               NUMBER;
    Ln_Ind                 NUMBER := 1;
    Lv_IpCreacion          VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User                VARCHAR2(1000):= 'telcos_diferido';
    Lv_MsjResultado        VARCHAR2(2000); 
    Lv_CaractReferenciaNci VARCHAR2(20):= 'ID_REFERENCIA_NCI';
    Lv_CaractMesesDiferido VARCHAR2(20):= 'ES_MESES_DIFERIDO';
    Lv_CaractContDiferido  VARCHAR2(20):= 'ES_CONT_DIFERIDO';
    Lv_EstadoActivo        VARCHAR2(6):= 'Activo';
    La_DatosNCI            T_DatosNCI;

  BEGIN
  --
    IF C_CuotasXVencerDoc%ISOPEN THEN        
      CLOSE C_CuotasXVencerDoc;        
    END IF;   

    La_DatosNCI.DELETE();

    FOR Lr_CuotasXVencerDoc IN C_CuotasXVencerDoc(Fn_IdPunto,
                                                  Fn_IdProcesoMsv,
                                                  Lv_CaractReferenciaNci,
                                                  Lv_CaractMesesDiferido,
                                                  Lv_CaractContDiferido,
                                                  Lv_EstadoActivo,
                                                  Lv_User)  LOOP
      Ln_Saldo := 0;
      Ln_Desde := Lr_CuotasXVencerDoc.ES_CONT_DIFERIDO;
      Ln_Hasta := Lr_CuotasXVencerDoc.ES_MESES_DIFERIDO;

      WHILE Ln_Desde <= Ln_Hasta
      LOOP

        Ln_Saldo := Ln_Saldo + ROUND(F_GET_VALOR_CUOTA_DIFERIDA(Lr_CuotasXVencerDoc.ID_DOCUMENTO,
                                                                Ln_Desde,
                                                                Ln_Hasta),2);
        Ln_Desde := Ln_Desde + 1; 
      END LOOP;
      La_DatosNCI(Ln_Ind).ID_DOCUMENTO          := Lr_CuotasXVencerDoc.ID_DOCUMENTO;
      La_DatosNCI(Ln_Ind).NUMERO_FACTURA_SRI    := Lr_CuotasXVencerDoc.NUMERO_FACTURA_SRI;
      La_DatosNCI(Ln_Ind).ESTADO_IMPRESION_FACT := Lr_CuotasXVencerDoc.ESTADO_IMPRESION_FACT;
      La_DatosNCI(Ln_Ind).ES_MESES_DIFERIDO     := Lr_CuotasXVencerDoc.ES_MESES_DIFERIDO;
      La_DatosNCI(Ln_Ind).SALDO                 := Ln_Saldo;
      La_DatosNCI(Ln_Ind).PROCESO               := Lr_CuotasXVencerDoc.PROCESO;
      La_DatosNCI(Ln_Ind).SOLICITUD             := Lr_CuotasXVencerDoc.SOLICITUD;
      La_DatosNCI(Ln_Ind).PUNTO_ID              := Lr_CuotasXVencerDoc.PUNTO_ID;
      Ln_Ind                                    := Ln_Ind + 1;

    END LOOP;

    RETURN La_DatosNCI;

  EXCEPTION
  WHEN OTHERS THEN
  --
    La_DatosNCI.DELETE();
    Lv_MsjResultado := 'Error al obtener el saldo total de NDI por generarse del id_punto: '|| Fn_IdPunto ||' .'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.F_TABLA_NCI_X_PTO', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_User,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN La_DatosNCI;
  END F_TABLA_NCI_X_PTO;

  PROCEDURE P_GENERAR_NDI_CANCELACION(Pn_IdServicio  IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_CodEmpresa  IN VARCHAR2,
                                      Pv_TipoProceso IN VARCHAR2,
                                      Pv_Error       OUT VARCHAR2)
  IS
    --Costo: 3
    CURSOR C_PuntoServicio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT DBIS.PUNTO_ID 
      FROM DB_COMERCIAL.INFO_SERVICIO DBIS
      WHERE DBIS.ID_SERVICIO = Cn_IdServicio;

    --Costo: 18
    CURSOR C_NCIPorPunto(Cn_IdPunto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                         Cv_CodEmpresa       VARCHAR2,
                         Cv_ProcesoDiferido  VARCHAR2,
                         Cv_ProcesoMasivo    VARCHAR2,
                         Cv_Solicitud        VARCHAR2,
                         Cv_ContadorDiferido VARCHAR2,
                         Cv_MesesDiferido    VARCHAR2,
                         Cv_EstadoActivo     VARCHAR2,
                         Cv_EstadoRechazado  VARCHAR2,
                         Cv_Usuario          VARCHAR2)
    IS
      SELECT  
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,
                                                                                     Cv_ProcesoMasivo),'^\d+')),0) AS ID_PROCESO_MASIVO,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,
                                                                                     Cv_Solicitud),'^\d+')),0) AS ID_DETALLE_SOLICITUD,
        NCI.PUNTO_ID AS ID_PUNTO,
        MIN(COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,
                                                                                         Cv_ContadorDiferido),'^\d+')),0)) AS ES_CONT_DIFERIDO,
        MAX(COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,
                                                                                         Cv_MesesDiferido),'^\d+')),0)) AS ES_MESES_DIFERIDO,
        COUNT(*) AS CANTIDAD_NCI
      FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
        DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
        DB_COMERCIAL.ADMI_CARACTERISTICA CA,
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR,
        DB_COMERCIAL.INFO_CONTRATO CONT,
        DB_GENERAL.ADMI_FORMA_PAGO FP
      WHERE NCI.TIPO_DOCUMENTO_ID           = TDOC.ID_TIPO_DOCUMENTO
      AND TDOC.CODIGO_TIPO_DOCUMENTO        = 'NCI'
      AND NCI.USR_CREACION                  = Cv_Usuario
      AND NCI.ESTADO_IMPRESION_FACT         = Cv_EstadoActivo
      AND NCI.ID_DOCUMENTO                  = DCA.DOCUMENTO_ID
      AND DCA.CARACTERISTICA_ID             = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA     = Cv_ProcesoDiferido
      AND DCA.ESTADO                        = Cv_EstadoActivo
      AND IP.ID_PUNTO                       = Cn_IdPunto
      AND NCI.PUNTO_ID                      = IP.ID_PUNTO
      AND IPER.ID_PERSONA_ROL               = IP.PERSONA_EMPRESA_ROL_ID
      AND IPER.PERSONA_ID                   = IPE.ID_PERSONA
      AND IPER.EMPRESA_ROL_ID               = IER.ID_EMPRESA_ROL
      AND IER.ROL_ID                        = AR.ID_ROL
      AND IER.EMPRESA_COD                   = Cv_CodEmpresa
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_ContadorDiferido),'^\d+')),0)
      < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_MesesDiferido),'^\d+')),0)
      AND IPER.ID_PERSONA_ROL                                        = CONT.PERSONA_EMPRESA_ROL_ID
      AND CONT.ESTADO                                                NOT IN (Cv_EstadoRechazado)
      AND CONT.FORMA_PAGO_ID                                         = FP.ID_FORMA_PAGO
      GROUP BY
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_ProcesoMasivo),'^\d+')),0) ,
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_Solicitud),'^\d+')),0) ,
      NCI.PUNTO_ID,
      (COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_ContadorDiferido),'^\d+')),0)),
      (COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_MesesDiferido),'^\d+')),0))
      ORDER BY
      COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_ProcesoMasivo),'^\d+')),0)
      ASC;

    --Costo: 2
    CURSOR C_GetCaracterist (Cv_DescCarac DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      SELECT ID_CARACTERISTICA,
        DESCRIPCION_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = Cv_DescCarac;

    --Costo: 2
    CURSOR C_GetMotivo(Cv_NombreMotivo DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE)
    IS
      SELECT AM.ID_MOTIVO,
        AM.NOMBRE_MOTIVO
      FROM DB_GENERAL.ADMI_MOTIVO  AM 
      WHERE AM.NOMBRE_MOTIVO = Cv_NombreMotivo    
      AND AM.ESTADO          = 'Activo';  

    --Costo: 5
    CURSOR C_GetDocumentoCaract(Cn_IdDocumento  DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.DOCUMENTO_ID%TYPE,
                                Cv_DescCarac    DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                Cv_Estado       DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE)
    IS
      SELECT DCA.ID_DOCUMENTO_CARACTERISTICA,
        DCA.DOCUMENTO_ID,
        DCA.CARACTERISTICA_ID,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(DCA.VALOR,'^\d+')),0) AS VALOR
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
        DB_COMERCIAL.ADMI_CARACTERISTICA CA
      WHERE DCA.CARACTERISTICA_ID       = CA.ID_CARACTERISTICA
      AND CA.DESCRIPCION_CARACTERISTICA = Cv_DescCarac
      AND DCA.ESTADO                    = Cv_Estado
      AND DCA.DOCUMENTO_ID              = Cn_IdDocumento;

    CURSOR C_GetParamAgrupaNdiDif(Cv_NombreParametroCab DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                  Cv_Estado             DB_GENERAL.ADMI_PARAMETRO_DET.ESTADO%TYPE,
                                  Cv_EmpresaCod         DB_GENERAL.ADMI_PARAMETRO_DET.EMPRESA_COD%TYPE,
                                  Cv_TipoProceso        DB_GENERAL.ADMI_PARAMETRO_DET.VALOR1%TYPE)
    IS 
      SELECT APD.VALOR1, APD.VALOR2, APD.VALOR3, 
        APD.VALOR4, APD.VALOR5, APD.VALOR6
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
      AND APC.NOMBRE_PARAMETRO = Cv_NombreParametroCab
      AND APC.ESTADO           = Cv_Estado
      AND APD.ESTADO           = Cv_Estado
      AND APD.EMPRESA_COD      = Cv_EmpresaCod
      AND APD.VALOR1           = Cv_TipoProceso;

    Lv_User                         VARCHAR2(1000);
    Lv_EstadoActivo                 VARCHAR2(20) := 'Activo';
    Lv_CaractProcesoDiferido        VARCHAR2(20) := 'PROCESO_DIFERIDO';
    Lv_CaractNumCuotaDiferida       VARCHAR2(20) := 'NUM_CUOTA_DIFERIDA';
    Lv_CaractReferenciaNci          VARCHAR2(20) := 'ID_REFERENCIA_NCI';
    Lv_CaractMesesDiferido          VARCHAR2(20) := 'ES_MESES_DIFERIDO';
    Lv_CaractContDiferido           VARCHAR2(20) := 'ES_CONT_DIFERIDO';
    Lv_CaractIdSolicitud            VARCHAR2(20) := 'ES_ID_SOLICITUD';
    Lv_CaractProcesoMasivo          VARCHAR2(20) := 'ES_PROCESO_MASIVO';
    Lv_CaractValorCuotaDiferida     VARCHAR2(20) := 'VALOR_CUOTA_DIFERIDA';
    Lv_CaractProcesoDeEjecucion     VARCHAR2(20) := 'PROCESO_DE_EJECUCION';
    Lv_ObservacionNdiCuota          VARCHAR2(200);
    Lv_ObservacionNdi               VARCHAR2(200);
    Lv_MsjResultado                 VARCHAR2(2000);
    Lv_MsnError                     VARCHAR2(2000);
    Lv_IpCreacion                   VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoRechazado              DB_COMERCIAL.INFO_CONTRATO.ESTADO%TYPE:='Rechazado';
    Lv_NombreMotivo                 DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE:='Saldo a Diferir en cuotas';
    Ln_Indice                       NUMBER;
    Ln_SaldoPorDiferir              NUMBER;
    Ln_IdDocCaracContDiferido       NUMBER; 
    Ln_ValorTotalNdi                NUMBER := 0;
    Ln_IdDocCaracIdReferenciaNci    NUMBER;
    Ln_IdCaractProcesoDiferido      DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractNumCuotaDiferida     DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractReferenciaNci        DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractIdSolicitud          DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractProcesoMasivo        DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;    
    Ln_IdCaractValorCuotaDiferida   DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE;
    Ln_IdCaractProcesoDeEjecucion   DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE; 
    Ln_IdMotivo                     DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE;
    Ln_IdDocumentoNdi               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;
    Ln_IdPunto                      DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE;
    Ln_IdDocumentoNci               DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE;        
    Lc_GetDocumentoCaract           C_GetDocumentoCaract%ROWTYPE;
    Lc_GetCaracterist               C_GetCaracterist%ROWTYPE;
    Lc_GetMotivo                    C_GetMotivo%ROWTYPE;
    Lr_NCIPendientes                T_DatosNCI;      
    Lr_InfoDocumentoCaract          DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA%ROWTYPE;    
    Lr_InfoDocumentoFinanHst        DB_FINANCIERO.INFO_DOCUMENTO_HISTORIAL%ROWTYPE; 
    Lr_InfoDocumentoFinanCabNdi     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB%ROWTYPE;
    Lr_InfoDocumentoFinanDetNdi     DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_DET%ROWTYPE;  
    Lv_ObservacionNdiAgrupada       CLOB;
    Lbool_Done                      BOOLEAN;
    Lex_Exception                   EXCEPTION;
    Le_Exception                    EXCEPTION;
    Le_ExceptionAgrupoNci           EXCEPTION;
    Le_ExceptionNci                 EXCEPTION;
    Lv_MsgResultadoProceso          VARCHAR2(100);
    Lv_NombreParametroCab           VARCHAR2(100) := 'PROCESO_AGRUPA_NDI_DIFERIDA';
    Lv_TipoProceso                  VARCHAR2(100);
    Lc_ParamAgrupaNdiDif            C_GetParamAgrupaNdiDif%ROWTYPE;

  BEGIN

    IF C_GetParamAgrupaNdiDif%ISOPEN THEN    
      CLOSE C_GetParamAgrupaNdiDif;    
    END IF; 

    --Se obtiene par�metros por el tipo de proceso para agrupar las NDI diferidas.
    OPEN C_GetParamAgrupaNdiDif(Lv_NombreParametroCab, Lv_EstadoActivo, Pv_CodEmpresa, Pv_TipoProceso);
    FETCH C_GetParamAgrupaNdiDif INTO Lc_ParamAgrupaNdiDif;
        IF C_GetParamAgrupaNdiDif%NOTFOUND THEN
            Lv_MsnError := 'No existe par�metro configurado para la creaci�n de NDI agrupada';
            RAISE Le_Exception;       
        END IF;
    CLOSE C_GetParamAgrupaNdiDif;

    --Se obtiene par�metro de: tipo de proceso, usuario de creaci�n, mensaje resultado del proceso y observaci�n de la Ndi
    Lv_TipoProceso         := Lc_ParamAgrupaNdiDif.VALOR1;
    Lv_User                := Lc_ParamAgrupaNdiDif.VALOR2;
    Lv_MsgResultadoProceso := Lc_ParamAgrupaNdiDif.VALOR3;
    Lv_ObservacionNdi      := Lc_ParamAgrupaNdiDif.VALOR4;


    IF C_PuntoServicio%ISOPEN THEN        
      CLOSE C_PuntoServicio;        
    END IF;

    IF C_GetMotivo%ISOPEN THEN    
      CLOSE C_GetMotivo;    
    END IF;  

    IF C_GetCaracterist%ISOPEN THEN    
      CLOSE C_GetCaracterist;    
    END IF;

    OPEN C_PuntoServicio(Pn_IdServicio);
    --
    FETCH C_PuntoServicio INTO Ln_IdPunto;
    --
    CLOSE C_PuntoServicio;

    Ln_SaldoPorDiferir := DB_FINANCIERO.FNCK_PAGOS_DIFERIDOS.F_SALDO_X_DIFERIR_PTO(Ln_IdPunto);

    IF Ln_SaldoPorDiferir = 0 OR Ln_SaldoPorDiferir IS NULL THEN
      RAISE Lex_Exception;
    END IF;

    OPEN C_GetMotivo(Lv_NombreMotivo);
    --
    FETCH C_GetMotivo INTO Lc_GetMotivo;
    IF C_GetMotivo%NOTFOUND THEN
      Lv_MsnError := 'No existe motivo configurado para la creaci�n de Documentos NDI';
      RAISE Le_Exception;       
    END IF;
    Ln_IdMotivo := Lc_GetMotivo.ID_MOTIVO;
    CLOSE C_GetMotivo;

    OPEN C_GetCaracterist(Lv_CaractProcesoDiferido);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoDiferido := Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractNumCuotaDiferida);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractNumCuotaDiferida := Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist;  
    --
    OPEN C_GetCaracterist(Lv_CaractReferenciaNci);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractReferenciaNci := Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
     --
    OPEN C_GetCaracterist(Lv_CaractIdSolicitud);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractIdSolicitud := Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractProcesoMasivo);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoMasivo := Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist; 
    --
    OPEN C_GetCaracterist(Lv_CaractValorCuotaDiferida);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractValorCuotaDiferida := Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist;
    --
    OPEN C_GetCaracterist(Lv_CaractProcesoDeEjecucion);    
    FETCH C_GetCaracterist INTO Lc_GetCaracterist;    
    Ln_IdCaractProcesoDeEjecucion := Lc_GetCaracterist.ID_CARACTERISTICA;
    CLOSE C_GetCaracterist;      
    --
    IF Ln_IdCaractProcesoDiferido IS NULL OR Ln_IdCaractNumCuotaDiferida IS NULL OR Ln_IdCaractReferenciaNci IS NULL 
        OR Ln_IdCaractIdSolicitud IS NULL OR Ln_IdCaractProcesoMasivo IS NULL OR Ln_IdCaractValorCuotaDiferida IS NULL 
        OR Ln_IdCaractProcesoDeEjecucion IS NULL THEN
      Lv_MsjResultado := 'Error al recuperar caracter�sticas necesarias para el proceso ' || Lv_CaractProcesoDiferido || ' - ' ||
                     Lv_CaractNumCuotaDiferida || ' - ' || Lv_CaractReferenciaNci || ' - ' ||
                     Lv_CaractIdSolicitud || ' - ' || Lv_CaractProcesoMasivo || '-' || Lv_CaractValorCuotaDiferida || ' - ' ||
                     Lv_CaractProcesoDeEjecucion;
      RAISE Le_Exception;  
    END IF;

    -- Obtengo las NCI Agrupadas por Proceso masivo y Punto que se originaron por el Proceso de Diferido de Facturas por Emergencia Sanitaria.
    -- y que poseen cuotas o NDI pendientes de generarse.    
    FOR Lr_NCIPorPunto IN C_NCIPorPunto(Ln_IdPunto,
                                        Pv_CodEmpresa,
                                        Lv_CaractProcesoDiferido,
                                        Lv_CaractProcesoMasivo,
                                        Lv_CaractIdSolicitud,
                                        Lv_CaractContDiferido,
                                        Lv_CaractMesesDiferido,
                                        Lv_EstadoActivo,
                                        Lv_EstadoRechazado,
                                        Lv_User)
    LOOP
    --
      BEGIN
      --
        Ln_ValorTotalNdi          := 0;
        Ln_IdDocumentoNdi         := NULL;
        Lbool_Done                := FALSE;
        Lv_MsnError               := NULL;

        IF Lr_NCIPorPunto.ID_PROCESO_MASIVO = 0 OR Lr_NCIPorPunto.ID_PROCESO_MASIVO IS NULL THEN
          Lv_MsnError := 'Error al recuperar caracter�stica necesaria para el proceso '|| Lv_CaractProcesoMasivo ||
                         ' para el Punto#'|| Ln_IdPunto;
          RAISE Le_ExceptionAgrupoNci;       
        END IF;      

        IF Lr_NCIPorPunto.ID_DETALLE_SOLICITUD = 0 OR Lr_NCIPorPunto.ID_DETALLE_SOLICITUD IS NULL THEN
          Lv_MsnError := 'Error al recuperar caracter�stica necesaria para el proceso '|| Lv_CaractIdSolicitud ||
                         ' para el Punto#'|| Ln_IdPunto;
          RAISE Le_ExceptionAgrupoNci;       
        END IF;

        --Se obtiene par�metro observaci�n Ndi Agrupada
        IF Lv_TipoProceso = 'CancelacionVoluntaria' THEN
            Lv_ObservacionNdiAgrupada := Lc_ParamAgrupaNdiDif.VALOR5; 
        ELSE
            Lv_ObservacionNdiAgrupada := Lc_ParamAgrupaNdiDif.VALOR5||Lr_NCIPorPunto.ID_PROCESO_MASIVO; 
        END IF;

        FNCK_PAGOS_DIFERIDOS.P_CREA_NOTA_DEBITO_INTERNA (Ln_IdPunto,
                                                         Ln_ValorTotalNdi,                                                           
                                                         Pv_CodEmpresa,
                                                         Lv_ObservacionNdi,
                                                         Ln_IdMotivo,
                                                         Lv_User,
                                                         Ln_IdDocumentoNdi,
                                                         Lbool_Done,
                                                         Lv_MsnError);  

        IF TRIM(Lv_MsnError) IS NOT NULL THEN
          RAISE Le_ExceptionAgrupoNci;
        END IF; 

        Lr_InfoDocumentoFinanCabNdi := DB_FINANCIERO.FNCK_CONSULTS.F_GET_INFO_DOC_FINANCIERO_CAB(Ln_IdDocumentoNdi, NULL);    

        IF Lbool_Done THEN      
        --
          --Se insertan caracter�sticas por NDI Agrupada:
          --PROCESO_DIFERIDO (en S), 
          --ES_PROCESO_MASIVO (id_proceso_masivo PMA de diferido del origen), 
          --ES_ID_SOLICITUD (id_detalle_solicitud de diferido del origen),
          --PROCESO_DE_EJECUCION (aplicaci�n que origin� la NDI)
          Lr_InfoDocumentoCaract := NULL;
          Lr_InfoDocumentoCaract.DOCUMENTO_ID                := Ln_IdDocumentoNdi;
          Lr_InfoDocumentoCaract.FE_CREACION                 := SYSDATE;
          Lr_InfoDocumentoCaract.USR_CREACION                := Lv_User;
          Lr_InfoDocumentoCaract.IP_CREACION                 := Lv_IpCreacion;
          Lr_InfoDocumentoCaract.ESTADO                      := Lv_EstadoActivo;
          --
          Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
          Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoDiferido;
          Lr_InfoDocumentoCaract.VALOR                       := 'S';    
          Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;         
          FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
          IF TRIM(Lv_MsnError) IS NOT NULL THEN
            RAISE Le_ExceptionAgrupoNci;
          END IF;
          --                         
          Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
          Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoMasivo;
          Lr_InfoDocumentoCaract.VALOR                       := Lr_NCIPorPunto.ID_PROCESO_MASIVO;
          Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;
          FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
          IF TRIM(Lv_MsnError) IS NOT NULL THEN
            RAISE Le_ExceptionAgrupoNci;
          END IF;
          --
          Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
          Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractIdSolicitud;
          Lr_InfoDocumentoCaract.VALOR                       := Lr_NCIPorPunto.ID_DETALLE_SOLICITUD;
          Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;
          FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
          IF TRIM(Lv_MsnError) IS NOT NULL THEN
            RAISE Le_ExceptionAgrupoNci;
          END IF;
          --
          Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
          Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractProcesoDeEjecucion;

          --Se obtiene par�metro valor caracter�stica para los diferentes procesos
          Lr_InfoDocumentoCaract.VALOR := Lc_ParamAgrupaNdiDif.VALOR6;

          Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;
          FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
          IF TRIM(Lv_MsnError) IS NOT NULL THEN
            RAISE Le_ExceptionAgrupoNci;
          END IF;
          --
        END IF;  

        Lr_NCIPendientes.DELETE();
        Ln_Indice        := 0;
        Lr_NCIPendientes := F_TABLA_NCI_X_PTO(Ln_IdPunto,Lr_NCIPorPunto.ID_PROCESO_MASIVO);
        Ln_Indice        := Lr_NCIPendientes.FIRST;
        --
        WHILE (Ln_Indice IS NOT NULL)  
        LOOP          
        --
          BEGIN      
          --
            Ln_IdDocumentoNci         := Lr_NCIPendientes(Ln_Indice).ID_DOCUMENTO;
            Ln_IdDocCaracContDiferido := NULL;
            Lv_ObservacionNdiCuota    := '';
            Lv_MsnError               := NULL;
            --
            IF C_GetDocumentoCaract%ISOPEN THEN    
              CLOSE C_GetDocumentoCaract;    
            END IF;       
            --
            --Obtengo caracter�stica ES_CONT_DIFERIDO del id_documento NCI para actualizaci�n de la cuota generada por ndi.
            --
            OPEN C_GetDocumentoCaract(Ln_IdDocumentoNci,Lv_CaractContDiferido,Lv_EstadoActivo);
            FETCH C_GetDocumentoCaract INTO Lc_GetDocumentoCaract;          
            IF C_GetDocumentoCaract%NOTFOUND THEN
              Lv_MsnError := 'Error al recuperar caracter�stica necesaria para el proceso '|| Lv_CaractContDiferido ||
                             ' para la NCI #'|| Ln_IdDocumentoNci;
              RAISE Le_ExceptionNci;       
            END IF;
            Ln_IdDocCaracContDiferido := Lc_GetDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA;
            CLOSE C_GetDocumentoCaract; 

            Lv_ObservacionNdiCuota := Lv_ObservacionNdi || ' #Cuota Generada: ' || Lr_NCIPendientes(Ln_Indice).ES_MESES_DIFERIDO || 
                                      ' de ' || Lr_NCIPendientes(Ln_Indice).ES_MESES_DIFERIDO ||
                                      '. NDI Agrupada # '|| Lr_InfoDocumentoFinanCabNdi.NUMERO_FACTURA_SRI || '.';

            IF Lr_NCIPendientes(Ln_Indice).SALDO IS NULL OR Lr_NCIPendientes(Ln_Indice).SALDO = 0 THEN
              Lv_MsnError := 'Error al obtener el valor de la cuota diferida para la NCI #'|| Ln_IdDocumentoNci;
              RAISE Le_ExceptionNci;
            END IF;

            Ln_ValorTotalNdi := Ln_ValorTotalNdi + Lr_NCIPendientes(Ln_Indice).SALDO;          
            --
            --Se guardan las siguientes caracter�sticas por cada NCI que se agrupe en la NDI:
            --ID_REFERENCIA_NCI(id_documento NCI que origino la NDI Agrupada),
            --NUM_CUOTA_DIFERIDA (#cuota por NCI correspondiente a la NDI Agrupada)                
            --VALOR_CUOTA_DIFERIDA (Valor de la Cuota correspondiente a la NCI)                                        
            --
            Lr_InfoDocumentoCaract := NULL;
            Lr_InfoDocumentoCaract.DOCUMENTO_ID                := Ln_IdDocumentoNdi;
            Lr_InfoDocumentoCaract.FE_CREACION                 := SYSDATE;
            Lr_InfoDocumentoCaract.USR_CREACION                := Lv_User;
            Lr_InfoDocumentoCaract.IP_CREACION                 := Lv_IpCreacion;
            Lr_InfoDocumentoCaract.ESTADO                      := Lv_EstadoActivo;
            --
            Ln_IdDocCaracIdReferenciaNci                       := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := Ln_IdDocCaracIdReferenciaNci;
            Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractReferenciaNci;
            Lr_InfoDocumentoCaract.VALOR                       := Ln_IdDocumentoNci;
            Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := NULL;
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError);
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionNci;
            END IF;
            --            
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractNumCuotaDiferida;
            Lr_InfoDocumentoCaract.VALOR                       := Lr_NCIPendientes(Ln_Indice).ES_MESES_DIFERIDO;
            Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := Ln_IdDocCaracIdReferenciaNci;
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionNci;
            END IF;         
            --
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_CARACT.NEXTVAL;
            Lr_InfoDocumentoCaract.CARACTERISTICA_ID           := Ln_IdCaractValorCuotaDiferida;
            Lr_InfoDocumentoCaract.VALOR                       := Lr_NCIPendientes(Ln_Indice).SALDO;
            Lr_InfoDocumentoCaract.DOCUMENTO_CARACTERISTICA_ID := Ln_IdDocCaracIdReferenciaNci;
            FNCK_PAGOS_DIFERIDOS.P_INSERT_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionNci;
            END IF;
            --
            --Actualizo el valor de la caracter�stica ES_CONT_DIFERIDO en la NCI en INFO_DOCUMENTO_CARACTERISTICA para registrar el #cuota
            -- o NDI generada por el proceso.            
            Lr_InfoDocumentoCaract                              := NULL;
            Lr_InfoDocumentoCaract.ID_DOCUMENTO_CARACTERISTICA  := Ln_IdDocCaracContDiferido;
            Lr_InfoDocumentoCaract.FE_ULT_MOD                   := SYSDATE;
            Lr_InfoDocumentoCaract.USR_ULT_MOD                  := Lv_User;
            Lr_InfoDocumentoCaract.IP_ULT_MOD                   := Lv_IpCreacion;
            Lr_InfoDocumentoCaract.VALOR                        := Lr_NCIPendientes(Ln_Indice).ES_MESES_DIFERIDO;

            FNCK_PAGOS_DIFERIDOS.P_UPDATE_INFO_DOCUMENTO_CARACT(Lr_InfoDocumentoCaract, Lv_MsnError); 
            IF TRIM(Lv_MsnError) IS NOT NULL THEN
              RAISE Le_ExceptionNci;
            END IF; 
            -- 
            --Inserto Historial en la NCI indicando que se proces� con exito la NDI por Diferido indicando n�mero de cuota y # NDI generada.
            --            
            Lr_InfoDocumentoFinanHst                        := NULL;
            Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
            Lr_InfoDocumentoFinanHst.DOCUMENTO_ID           := Ln_IdDocumentoNci;
            Lr_InfoDocumentoFinanHst.MOTIVO_ID              := Ln_IdMotivo;
            Lr_InfoDocumentoFinanHst.FE_CREACION            := SYSDATE;
            Lr_InfoDocumentoFinanHst.USR_CREACION           := Lv_User;
            Lr_InfoDocumentoFinanHst.ESTADO                 := Lr_NCIPendientes(Ln_Indice).ESTADO_IMPRESION_FACT;
            Lr_InfoDocumentoFinanHst.OBSERVACION            := Lv_ObservacionNdiCuota;
            --
            DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinanHst, Lv_MsnError);
            --
            IF Lv_MsnError IS NOT NULL THEN              
              RAISE Le_ExceptionNci;              
            END IF;

          EXCEPTION
            WHEN Le_ExceptionNci THEN
              --
              Lv_MsjResultado:= 'Ocurri� un error al ejecutar el Proceso de generaci�n de NDI por Diferido de Facturas por Emergencia Sanitaria' ||
                                ' - ' || Lv_MsnError;
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                   'FNCK_PAGOS_DIFERIDOS.P_GENERAR_NDI_CANCELACION', 
                                                   Lv_MsjResultado,
                                                   NVL(Lv_User, 'telcos_diferido'),
                                                   SYSDATE,
                                                   NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
            WHEN OTHERS THEN
              --
              Lv_MsjResultado:= 'Ocurri� un error al ejecutar el Proceso de generaci�n de NDI por '||NVL(Lv_MsgResultadoProceso, Pv_TipoProceso) ||
                                ' - ' || Lv_MsnError;
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                                   'FNCK_PAGOS_DIFERIDOS.P_GENERAR_NDI_CANCELACION', 
                                                   Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                   NVL(Lv_User, 'telcos_diferido'),
                                                   SYSDATE,
                                                   NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
          --
          END;
          Ln_Indice := Lr_NCIPendientes.NEXT (Ln_Indice);
        --
        END LOOP;--FIN DE WHILE

        Lv_ObservacionNdiAgrupada               := REPLACE(Lv_ObservacionNdiAgrupada,
                                                           '#CUOTA',
                                                           (Lr_NCIPorPunto.ES_MESES_DIFERIDO - Lr_NCIPorPunto.ES_CONT_DIFERIDO));

        Lr_InfoDocumentoFinanCabNdi.VALOR_TOTAL := ROUND(Ln_ValorTotalNdi, 2);
        Lr_InfoDocumentoFinanCabNdi.SUBTOTAL    := ROUND(Ln_ValorTotalNdi, 2);
        Lr_InfoDocumentoFinanCabNdi.OBSERVACION := Lv_ObservacionNdiAgrupada;
        --
        --Actualiza el los valores totales de la cabecera
        DB_FINANCIERO.FNCK_TRANSACTION.UPDATE_INFO_DOC_FINANCIERO_CAB(Lr_InfoDocumentoFinanCabNdi.ID_DOCUMENTO,
                                                                      Lr_InfoDocumentoFinanCabNdi,
                                                                      Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN            
          RAISE Le_ExceptionAgrupoNci;           
        END IF;
        --
        Lr_InfoDocumentoFinanDetNdi.PRECIO_VENTA_FACPRO_DETALLE   := ROUND(Ln_ValorTotalNdi, 2);
        Lr_InfoDocumentoFinanDetNdi.OBSERVACIONES_FACTURA_DETALLE := Lv_ObservacionNdiAgrupada;
        --
        FNCK_PAGOS_DIFERIDOS.UPDATE_INFO_DOC_FINANCIERO_DET(Lr_InfoDocumentoFinanCabNdi.ID_DOCUMENTO,
                                                            Lr_InfoDocumentoFinanDetNdi,
                                                            Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN            
          RAISE Le_ExceptionAgrupoNci;           
        END IF;
        --
        --Historial de la NDI generada.
        --
        Lr_InfoDocumentoFinanHst := NULL;
        Lr_InfoDocumentoFinanHst.ID_DOCUMENTO_HISTORIAL := DB_FINANCIERO.SEQ_INFO_DOCUMENTO_HISTORIAL.NEXTVAL;
        Lr_InfoDocumentoFinanHst.DOCUMENTO_ID           := Lr_InfoDocumentoFinanCabNdi.ID_DOCUMENTO;
        Lr_InfoDocumentoFinanHst.MOTIVO_ID              := Ln_IdMotivo;
        Lr_InfoDocumentoFinanHst.FE_CREACION            := SYSDATE;
        Lr_InfoDocumentoFinanHst.USR_CREACION           := Lv_User;
        Lr_InfoDocumentoFinanHst.ESTADO                 := Lr_InfoDocumentoFinanCabNdi.ESTADO_IMPRESION_FACT;
        Lr_InfoDocumentoFinanHst.OBSERVACION            := SUBSTR(Lv_ObservacionNdiAgrupada,0,1000);
        --
        DB_FINANCIERO.FNCK_TRANSACTION.INSERT_INFO_DOC_FINANCIERO_HST(Lr_InfoDocumentoFinanHst, Lv_MsnError);
        --
        IF Lv_MsnError IS NOT NULL THEN
          --
          RAISE Le_ExceptionAgrupoNci;
          --
        END IF;
      --  
      EXCEPTION
        WHEN Le_ExceptionAgrupoNci THEN
          --
          Lv_MsjResultado:= 'Ocurri� un error al ejecutar el Proceso de generaci�n de NDI por ' ||NVL(Lv_MsgResultadoProceso, Pv_TipoProceso) ||
                            ' - ' || Lv_MsnError;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'FNCK_PAGOS_DIFERIDOS.P_GENERAR_NDI_CANCELACION', 
                                               Lv_MsjResultado,
                                               NVL(Lv_User, 'telcos_diferido'),
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
        WHEN OTHERS THEN
          --
          Lv_MsjResultado:= 'Ocurri� un error al ejecutar el Proceso de generaci�n de NDI por ' ||NVL(Lv_MsgResultadoProceso, Pv_TipoProceso) ||
                            ' - ' || Lv_MsnError;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'FNCK_PAGOS_DIFERIDOS.P_GENERAR_NDI_CANCELACION', 
                                               Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                               NVL(Lv_User, 'telcos_diferido'),
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
      --
      END;       
    END LOOP;
    --
    COMMIT;
    Pv_Error := 'OK';
    --
  EXCEPTION
  WHEN Lex_Exception THEN

    --Se valida si el tipo de proceso es CancelacionVoluntaria para devolver mensaje ok, de lo contrario se devuelve error.
    IF Lv_TipoProceso = 'CancelacionVoluntaria' THEN
        Pv_Error := 'OK';
    ELSE
        Pv_Error := 'ERROR';
    END IF;

    WHEN Le_Exception THEN
      --
      ROLLBACK;
      Lv_MsjResultado:= 'Ocurri� un error al ejecutar el Proceso de generaci�n de NDI por ' ||NVL(Lv_MsgResultadoProceso, Pv_TipoProceso) ||
                        ' - ' || Lv_MsnError;

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'FNCK_PAGOS_DIFERIDOS.P_GENERAR_NDI_CANCELACION', 
                                           Lv_MsjResultado,
                                           NVL(Lv_User, 'telcos_diferido'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));

      --Se valida si el tipo de proceso es diferente a CancelacionVoluntaria para devolver mensaje de error.
      IF Lv_TipoProceso != 'CancelacionVoluntaria' OR Lv_TipoProceso IS NULL THEN
        Pv_Error := 'ERROR';
      END IF;

  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurri� un error al ejecutar el Proceso de generaci�n de NDI por '||NVL(Lv_MsgResultadoProceso, Pv_TipoProceso);
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.P_GENERAR_NDI_CANCELACION', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                         NVL(Lv_User, 'telcos_diferido'),
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));    

    --Se valida si el tipo de proceso es diferente a CancelacionVoluntaria para devolver mensaje de error.
    IF Lv_TipoProceso != 'CancelacionVoluntaria' OR Lv_TipoProceso IS NULL THEN
       Pv_Error := 'ERROR';
    END IF;   

  END P_GENERAR_NDI_CANCELACION;
  --
  --
  FUNCTION F_GET_VALOR_VENCER_PRECAN_DIF(Fn_IdPunto         IN DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                                         Fn_IdProcesoMasivo IN VARCHAR2)
  RETURN NUMBER
  IS
    CURSOR C_GetDifPorVencerMasivo(Cn_IdPunto                DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.PUNTO_ID%TYPE,
                                   Cv_CodigoTipoDocumento    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
                                   Cv_UsrCreacion            DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.USR_CREACION%TYPE,
                                   Cv_EstadoActivo           DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA.ESTADO%TYPE,                                                                 
                                   Cv_CaractProcesoDiferido  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_CaractEsMesesDiferido  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_CaractEsContDiferido   DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_CaractEsProcesoMasivo  DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE,
                                   Cv_IdProcesoMasivo        VARCHAR2)
    IS
    SELECT DISTINCT NCI.ID_DOCUMENTO,
    NCI.PUNTO_ID,
    NCI.NUMERO_FACTURA_SRI,
    NCI.FE_CREACION,
    NCI.VALOR_TOTAL,
    -- 
    CASE
      WHEN COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO, Cv_CaractEsMesesDiferido),'^\d+')),0) <> 0
      THEN ROUND((NCI.VALOR_TOTAL/COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,
                                                                   Cv_CaractEsMesesDiferido),'^\d+')),0)),2)
      ELSE 0
    END AS DIFERIDO_POR_VENCER,
    --
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsProcesoMasivo),'^\d+')),0) 
    AS ID_PROCESO_MASIVO,
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsContDiferido),'^\d+')),0)  
    AS ES_CONT_DIFERIDO,
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsMesesDiferido),'^\d+')),0) 
    AS ES_MESES_DIFERIDO
    FROM DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
    DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
    DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA DCA,
    DB_COMERCIAL.ADMI_CARACTERISTICA CA,
    DB_COMERCIAL.INFO_PUNTO IP
    WHERE NCI.TIPO_DOCUMENTO_ID       = TDOC.ID_TIPO_DOCUMENTO
    AND TDOC.CODIGO_TIPO_DOCUMENTO    = Cv_CodigoTipoDocumento
    AND NCI.USR_CREACION              = Cv_UsrCreacion
    AND NCI.ESTADO_IMPRESION_FACT     = Cv_EstadoActivo
    AND NCI.ID_DOCUMENTO              = DCA.DOCUMENTO_ID
    AND DCA.CARACTERISTICA_ID         = CA.ID_CARACTERISTICA
    AND CA.DESCRIPCION_CARACTERISTICA = Cv_CaractProcesoDiferido
    AND DCA.ESTADO                    = Cv_EstadoActivo
    AND NCI.PUNTO_ID                  = IP.ID_PUNTO  
    AND NCI.PUNTO_ID                  = Cn_IdPunto
    AND EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
                FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
                  DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                WHERE BDIDC.DOCUMENTO_ID            = NCI.ID_DOCUMENTO
                AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
                AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO'
                AND BDIDC.VALOR                     = Cv_IdProcesoMasivo)
    AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsContDiferido),'^\d+')),0)
    < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsMesesDiferido),'^\d+')),0)    
    --
    GROUP BY NCI.ID_DOCUMENTO,
    NCI.PUNTO_ID,
    NCI.NUMERO_FACTURA_SRI,
    NCI.FE_CREACION,
    NCI.VALOR_TOTAL,
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsProcesoMasivo),'^\d+')),0),
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsContDiferido),'^\d+')),0),
    COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractEsMesesDiferido),'^\d+')),0);

    Ln_DiferidoPorVencer   NUMBER :=0; 
    --
    Lex_Exception          EXCEPTION;
    Lv_MsnError            VARCHAR2(2000);
    Lv_IpCreacion          VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_EstadoActivo        VARCHAR2(20) :='Activo';  
    Ln_ValorTotalNci       DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.VALOR_TOTAL%TYPE;  
    Ln_ValorCuotaDiferida  NUMBER :=0; 
    Ln_ValorAjuste         NUMBER :=0;

  BEGIN
    IF Fn_IdPunto IS NULL THEN            
      RAISE Lex_Exception;            
    END IF;
    --  
    FOR Lr_GetDiferidoPorVencerMasivo IN C_GetDifPorVencerMasivo(Fn_IdPunto, 'NCI', 'telcos_diferido', Lv_EstadoActivo,
                                                                 'PROCESO_DIFERIDO','ES_MESES_DIFERIDO','ES_CONT_DIFERIDO',
                                                                 'ES_PROCESO_MASIVO', Fn_IdProcesoMasivo ) 
    LOOP
      --
      Ln_ValorAjuste         := 0;
      Ln_ValorTotalNci       := Lr_GetDiferidoPorVencerMasivo.VALOR_TOTAL;
      Ln_ValorCuotaDiferida  := Lr_GetDiferidoPorVencerMasivo.DIFERIDO_POR_VENCER;      

      IF (Lr_GetDiferidoPorVencerMasivo.ES_CONT_DIFERIDO +1) = Lr_GetDiferidoPorVencerMasivo.ES_MESES_DIFERIDO THEN
        --
        Ln_ValorAjuste := Ln_ValorTotalNci - (Ln_ValorCuotaDiferida * Lr_GetDiferidoPorVencerMasivo.ES_MESES_DIFERIDO);
        IF Ln_ValorAjuste <> 0 THEN
          Ln_ValorCuotaDiferida := Ln_ValorCuotaDiferida + (Ln_ValorAjuste);
        END IF;
        --
      END IF;
      --
      Ln_DiferidoPorVencer := Ln_DiferidoPorVencer + Ln_ValorCuotaDiferida;
      -- 
    END LOOP;

    RETURN Ln_DiferidoPorVencer;
    --   
  EXCEPTION
    WHEN OTHERS THEN
      --
      Lv_MsnError := 'Error al obtener el valor Total de Diferido por Vencer por Punto #IdPunto ' ||  Fn_IdPunto ||
                     ' - ' || SQLCODE || ' - ERROR_STACK: '
                     || DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                           'FNCK_PAGOS_DIFERIDOS.F_GET_VALOR_VENCER_PRECAN_DIF',
                                           Lv_MsnError,
                                           'telcos_diferido',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
      RETURN Ln_DiferidoPorVencer;
      --
  END F_GET_VALOR_VENCER_PRECAN_DIF;
  --
  --
  FUNCTION F_SALDO_DIF_X_PTO_PROC_MASIVO(Fn_IdPunto         IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                         Fn_IdProcesoMasivo IN VARCHAR2)
  RETURN NUMBER 
  IS
    CURSOR C_CuotasXVencerDocProcMasivo(Cn_IdPunto             DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                        Cv_CaractReferenciaNci VARCHAR2,
                                        Cv_CaractMesesDiferido VARCHAR2,
                                        Cv_CaractContDiferido  VARCHAR2,
                                        Cv_EstadoActivo        VARCHAR2,
                                        Cv_Usuario             VARCHAR2,
                                        Cv_IdProcesoMasivo     VARCHAR2)
    IS
      SELECT DISTINCT
        NCI.ID_DOCUMENTO,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0) 
        + 1 AS ES_CONT_DIFERIDO,
        COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0)
        AS ES_MESES_DIFERIDO
      FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA IDC,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NDI,
        DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB NCI,
        DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO TDOC,
        DB_COMERCIAL.ADMI_CARACTERISTICA AC 
      WHERE NDI.PUNTO_ID                = Cn_IdPunto
      AND NDI.USR_CREACION              = Cv_Usuario
      AND TDOC.ID_TIPO_DOCUMENTO        = NDI.TIPO_DOCUMENTO_ID
      AND TDOC.CODIGO_TIPO_DOCUMENTO    = 'NDI'
      AND IDC.DOCUMENTO_ID              = NDI.ID_DOCUMENTO
      AND AC.ID_CARACTERISTICA          = IDC.CARACTERISTICA_ID
      AND AC.DESCRIPCION_CARACTERISTICA = Cv_CaractReferenciaNci
      AND NCI.ID_DOCUMENTO              = COALESCE(TO_NUMBER(REGEXP_SUBSTR(IDC.VALOR,'^\d+')),0)
      AND NCI.USR_CREACION              = Cv_Usuario
      AND NCI.ESTADO_IMPRESION_FACT     = Cv_EstadoActivo
      AND EXISTS (SELECT BDIDC.ID_DOCUMENTO_CARACTERISTICA
                  FROM DB_FINANCIERO.INFO_DOCUMENTO_CARACTERISTICA BDIDC,
                    DB_COMERCIAL.ADMI_CARACTERISTICA DBAC
                  WHERE BDIDC.DOCUMENTO_ID            = NCI.ID_DOCUMENTO
                  AND DBAC.ID_CARACTERISTICA          = BDIDC.CARACTERISTICA_ID
                  AND DBAC.DESCRIPCION_CARACTERISTICA = 'ES_PROCESO_MASIVO'
                  AND BDIDC.VALOR                     = Cv_IdProcesoMasivo)
      AND COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractContDiferido),'^\d+')),0)
      < COALESCE(TO_NUMBER(REGEXP_SUBSTR(FNCK_PAGOS_DIFERIDOS.F_GET_CARACT_DOCUMENTO(NCI.ID_DOCUMENTO,Cv_CaractMesesDiferido),'^\d+')),0);

    Ln_Saldo               NUMBER;
    Ln_Desde               NUMBER;
    Ln_Hasta               NUMBER;
    Lv_IpCreacion          VARCHAR2(16)  := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_User                VARCHAR2(1000):= 'telcos_diferido';
    Lv_MsjResultado        VARCHAR2(2000); 
    Lv_CaractReferenciaNci VARCHAR2(20)  := 'ID_REFERENCIA_NCI';
    Lv_CaractMesesDiferido VARCHAR2(20)  := 'ES_MESES_DIFERIDO';
    Lv_CaractContDiferido  VARCHAR2(20)  := 'ES_CONT_DIFERIDO';
    Lv_EstadoActivo        VARCHAR2(6)   := 'Activo';

  BEGIN
  --
    IF C_CuotasXVencerDocProcMasivo%ISOPEN THEN        
      CLOSE C_CuotasXVencerDocProcMasivo;        
    END IF;

    Ln_Saldo := 0;

    FOR Lr_CuotasXVencerDocProcMasivo IN C_CuotasXVencerDocProcMasivo(Fn_IdPunto,
                                                  Lv_CaractReferenciaNci,
                                                  Lv_CaractMesesDiferido,
                                                  Lv_CaractContDiferido,
                                                  Lv_EstadoActivo,
                                                  Lv_User,
                                                  Fn_IdProcesoMasivo)  LOOP

      Ln_Desde := Lr_CuotasXVencerDocProcMasivo.ES_CONT_DIFERIDO;
      Ln_Hasta := Lr_CuotasXVencerDocProcMasivo.ES_MESES_DIFERIDO;

      WHILE Ln_Desde <= Ln_Hasta
      LOOP
        Ln_Saldo := Ln_Saldo + ROUND(F_GET_VALOR_CUOTA_DIFERIDA(Lr_CuotasXVencerDocProcMasivo.ID_DOCUMENTO,
                                                                Ln_Desde,
                                                                Ln_Hasta),2);
        Ln_Desde := Ln_Desde + 1; 
      END LOOP;

    END LOOP;

    RETURN NVL(Ln_Saldo,0);

  EXCEPTION
  WHEN OTHERS THEN
  --
    Ln_Saldo        := 0;
    Lv_MsjResultado := 'Error al obtener el saldo total de NDI por generarse del id_punto: '|| Fn_IdPunto ||' .'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'FNCK_PAGOS_DIFERIDOS.F_SALDO_DIF_X_PTO_PROC_MASIVO', 
                                         Lv_MsjResultado ||  ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_User,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    RETURN Ln_Saldo;
  END F_SALDO_DIF_X_PTO_PROC_MASIVO;

END FNCK_PAGOS_DIFERIDOS;
/