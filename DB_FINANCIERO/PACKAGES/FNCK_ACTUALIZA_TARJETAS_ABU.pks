CREATE OR REPLACE PACKAGE DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU AS 

 /**
  * Documentación para PROCEDURE 'P_CREA_PMA_ACTUALIZA_ABU'.
  *
  * Procedimiento que crea Proceso Masivo "ArchivoTarjetasAbu" para el procesamiento del archivo de tarjetas ABU 
  *
  * PARAMETROS:
  * @Param Pv_UrlFile              IN  CLOB ( Ruta donde se almacena el archivo de tarjetas Abu )
  * @Param Pn_IdMotivo             IN  DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE ( Id del Motivo del Proceso del PMA )
  * @Param Pv_Observacion          IN  VARCHAR2 ( Observación del Proceso del PMA )
  * @Param Pv_UsrCreacion          IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE  (Usuario en sesión)
  * @Param Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (Código de Empresa en sesión)
  * @Param Pv_IpCreacion           IN  VARCHAR2 (Ip de Creación)
  * @Param Pv_TipoPma              IN  VARCHAR2 (Tipo de Proceso Masivo: ArchivoTarjetasAbu)      
  * @Param Pv_Destinatario         IN  VARCHAR2 (Correo del usuario en sesion)      
  * @Param Pv_MsjResultado         OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 21-09-2022
  */
  PROCEDURE P_CREA_PMA_ACTUALIZA_ABU(
    Pv_UrlFile          	 IN  CLOB,  
    Pn_IdMotivo                 IN  DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE,    
    Pv_Observacion              IN  VARCHAR2,
    Pv_UsrCreacion              IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IpCreacion               IN  VARCHAR2,
    Pv_TipoPma                  IN  VARCHAR2,
    Pv_Destinatario             IN  VARCHAR2,
    Pv_MsjResultado             OUT VARCHAR2  
  ); 
  /**
  * Documentación para PROCEDURE 'P_INSERT_INFO_PROC_MASIVO_CAB'.
  *
  * Procedimiento que Inserta cabecera del Proceso Masivo
  *
  * PARAMETROS:
  * @Param Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE 
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 21-09-2022
  */
  PROCEDURE P_INSERT_INFO_PROC_MASIVO_CAB(Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
                                          Pv_MsjResultado          OUT VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_UPDATE_INFO_PROC_MASIVO_CAB'.
  *
  * Procedimiento que Actualiza cabecera del Proceso Masivo
  *
  * PARAMETROS:
  * @Param Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE 
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 21-09-2022
  */
  PROCEDURE P_UPDATE_INFO_PROC_MASIVO_CAB(Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
                                          Pv_MsjResultado          OUT VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_INSERT_INFO_PROC_MASIVO_DET'.
  *
  * Procedimiento que Inserta detalle del Proceso Masivo
  *
  * PARAMETROS:
  * @Param Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 21-09-2022
  */
  PROCEDURE P_INSERT_INFO_PROC_MASIVO_DET(Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
                                          Pv_MsjResultado          OUT VARCHAR2);

  /**
  * Documentación para PROCEDURE 'P_UPDATE_INFO_PROC_MASIVO_DET'.
  *
  * Procedimiento que Actualiza detalle del Proceso Masivo
  *
  * PARAMETROS:
  * @Param Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecución)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 21-09-2022
  */
  PROCEDURE P_UPDATE_INFO_PROC_MASIVO_DET(Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
                                          Pv_MsjResultado          OUT VARCHAR2);    

  /**
  * Documentación para FUNCTION 'F_VALIDA_CODIGO_COMERCIO'.
  * Función para validación Columna "Codigo Comercio": Validación de codigo de MD 10980461 según valor parametrizado.
  *
  * Costo del Query C_ParamCodigoComercio: 3  
  *
  * PARAMETROS:
  * @Param Fv_CodigoComercio IN VARCHAR2
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 26-09-2022
  */                                      
  FUNCTION F_VALIDA_CODIGO_COMERCIO(Fv_CodigoComercio IN VARCHAR2)
    RETURN BOOLEAN;



  /**
  * Documentación para FUNCTION 'F_VALIDAR_CLIENTE'.
  * Función para validación Columna "IDENTIF. CLIENTE PR": formato de la columna según valor parametrizado y si existe el cliente.
  *
  * Costo del Query F_VALIDAR_CLIENTE: 66  
  *
  * PARAMETROS:
  * @Param Fv_IdentificacionCliente IN VARCHAR2, 
  * @Param Fv_CodigoEmpresa         IN VARCHAR2 
  * @Return Clob
  * @author Leonela Burgos <mlburgos@telconet.ec>
  * @version 1.0 11-11-2022
  */   
  FUNCTION F_VALIDAR_CLIENTE(Fv_IdentificacionCliente IN VARCHAR2, 
                             Fn_CodigoEmpresa IN VARCHAR2 
                             ) 
  RETURN CLOB;

    /**
  * Documentación para FUNCTION 'F_VALIDAR_NUMERO_ANTIGUO'.
  * Función para validación Columna "ANTIGUO": formato de la columna según valor parametrizado y si existe el cliente, si es forma de pago DEBITO y Tarjeta.
  *
  * Costo del Query F_VALIDAR_NUMERO_ANTIGUO: 51  
  *
  * PARAMETROS:
  * @Param Fv_NumeroAntiguo       IN VARCHAR2
  * @Param Fn_CodigoContrato      IN VARCHAR2
  * @Param Fi_EmpresaCod          IN INTEGER

  *
  * @author Leonela Burgos <mlburgos@telconet.ec>
  * @version 1.0 11-11-2022
  */ 

 FUNCTION F_VALIDAR_NUMERO_ANTIGUO(  Fv_NumeroAntiguo IN VARCHAR2,
                                      Fn_CodigoContrato IN VARCHAR2,
                                      Fi_EmpresaCod     IN INTEGER)
 RETURN CLOB;

    /**
  * Documentación para FUNCTION 'F_VALIDAR_NUMERO_NUEVO'.
  * Función para validación Columna "ANTIGUO": formato de la columna según valor parametrizado y si existe el cliente, si es forma de pago DEBITO y Tarjeta.
  *
  * Costo del Query F_VALIDAR_NUMERO_NUEVO: 43  
  *
  * PARAMETROS:
  * @Param Fv_NumeroAntiguo           IN VARCHAR2
  * @Param Fn_CodigoContrato          IN VARCHAR2
  * @Param Fi_EmpresaCod              IN INTEGER
  *
  * @author Leonela Burgos <mlburgos@telconet.ec>
  * @version 1.0 11-11-2022
  */ 

    FUNCTION F_VALIDAR_NUMERO_NUEVO(  Fv_NumeroNuevo IN VARCHAR2,
                                    Fn_CodigoContrato IN VARCHAR2,
                                    Fi_EmpresaCod     IN INTEGER)
    RETURN CLOB;

     /**
  * Documentación para FUNCTION 'F_VALIDAR_FECHA_CADUCIDAD'.
  * Función para validación Columna "ANTIGUO": formato de la columna según valor parametrizado y si existe el cliente, si es forma de pago DEBITO y Tarjeta.
  *
  * Costo del Query F_VALIDAR_FECHA_CADUCIDAD: 21  
  *
  * PARAMETROS:
  * @Param Fv_FechaCaducidad    IN VARCHAR2
  * @Param Fi_EmpresaCod        IN INTEGER
  *
  * @author Leonela Burgos <mlburgos@telconet.ec>
  * @version 1.0 11-11-2022
  */ 

   FUNCTION F_VALIDAR_FECHA_CADUCIDAD( Fv_FechaCaducidad IN VARCHAR2,  
                                      Fi_EmpresaCod     IN INTEGER)
    RETURN CLOB;

  /**
  * Documentación para PROCEDURE 'P_CREA_PMA_ACTUALIZA_ABU'.
  *
  * Procedimiento que crea Proceso Masivo "ArchivoTarjetasAbu" para el procesamiento del archivo de tarjetas ABU, se
  * consume un web services para crear Tareas con Cierre Automatico
  *
  * Costo del Query P_INFO_CONTRATO_FORMA_PAGO: 90  
  *
  * PARAMETROS:
  *
  * @Param Pr_InfoContratoFormaPagoHist  IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST%ROWTYPE,
  * @Param Pr_InfoPersonaEmpresaRolHist  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE,
  * @Param Pc_ParametroFormPago          IN CLOB,
  * @Param Pn_PersonaEmpresaRolId        IN NUMBER,
  * @Param Pv_UsrSesion                  IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
  * @Param Pv_IpCreacion                 IN VARCHAR2,
  * @Param Pv_MsnError                   OUT VARCHAR2,
  * @Param Pv_Resultado                  OUT VARCHAR2
  *
  * @author Leonela Burgos <mlburgos@telconet.ec>
  * @version 1.0 11-11-2022
  */ 


 PROCEDURE P_INFO_CONTRATO_FORMA_PAGO(
    Pr_InfoContratoFormaPagoHist  IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST%ROWTYPE,
    Pr_InfoPersonaEmpresaRolHist  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE,
    Pc_ParametroFormPago          IN CLOB,
    Pn_PersonaEmpresaRolId        IN NUMBER,
    Pv_UsrSesion                  IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_IpCreacion                 IN VARCHAR2,
    Pv_MsnError                   OUT VARCHAR2,
    Pv_Resultado                  OUT VARCHAR2,
    Pv_EstadoFinalizacion		  OUT VARCHAR2);

  /**
   * DOCUMENTACION DE PROCEDURE P_PROCESA_ACTUALIZA_ABU
   * Procedimiento principal para el procesamiento, validacion, actualizacion de tarjeta de credito,
   * generacion de csv con respuesta de lo procesado, envio de e-mail, y creacion de tarea 
   * de cierre automatico.
   * 
   * @Param	Pv_UrlFile	  IN  VARCHAR2  Recibe la URL en donde esta guardado el archivo
   * @Param	Pv_EmpresaCod IN  INTEGER	Recibe el codigo de la empresa
   * @Param	Pv_UsrSesion  IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE  Recibe el codigo del usuario
   * @Param	Pv_IpCreacion IN  VARCHAR2	Recibe la  Ip desde donde se creo el usuario
   * @Param	Pv_Status     OUT VARCHAR2	Se obtiene como salida el estado del procedimiento
   * @Param	Pv_Mensaje    OUT VARCHAR2	Se obtiene el mensaje de salida
   * @Param	Lv_MsjResultado OUT VARCHAR2 Se obtiene el mensaje resultante del proceso
   * 
   * @author Christian Yunga <cyungat@telconet.ec>
   * version 1.0 11-11-2022
   */

 PROCEDURE P_PROCESA_ACTUALIZA_ABU(
							Pv_UrlFile	         IN  VARCHAR2,
              Pv_DocumentoId       IN INTEGER,
							Pv_EmpresaCod        IN  INTEGER,
							Pv_UsrSesion         IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
							Pv_IpCreacion        IN  VARCHAR2,
              Pv_CorreoElectronico IN VARCHAR2,
							Pv_Status       OUT VARCHAR2,
							Pv_Mensaje      OUT VARCHAR2,
							Lv_MsjResultado OUT VARCHAR2);
/**
   * DOCUMENTACION DE PROCEDURE P_PROCESA_ACTUALIZA_ABU
   * Procedimiento principal para el procesamiento, validacion, actualizacion de tarjeta de credito,
   * generacion de csv con respuesta de lo procesado, envio de e-mail, y creacion de tarea 
   * de cierre automatico.
   * 
   * @Param	Pn_TipoCuentaId	       IN  VARCHAR2  Id del tipo de cuenta
   * @Param	Pn_BancoTipoCuentaId   IN  INTEGER	 Id del banco tipo cuenta
   * @Param	Pv_NumeroCuentaTarj    IN  VARCHAR2  Numero de la cuenta tarjeta sin encriptar
   * @Param	Pv_CodigoVerificacion  IN  VARCHAR2	 codigo de verificacion puede ir nulo
   * @Param	Pv_IpCreacion          OUT VARCHAR2	 Ip del usuario que usar el procedimiento
   * @Param	Pv_MsjResultado        OUT VARCHAR2	 Respuesta será vacía si la tarjeta es correcta
   * 
   * @author Christian Yunga <cyungat@telconet.ec>
   * @version 1.0 16-02-2023
   */
PROCEDURE P_VALIDAR_TARJETA_ABU(
              Pn_TipoCuentaId        IN   INTEGER,
              Pn_BancoTipoCuentaId   IN   INTEGER,
              Pv_NumeroCuentaTarj    IN   VARCHAR2,
              Pv_CodigoVerificacion  IN   VARCHAR2,
              Pn_CodigoEmpresa       IN   INTEGER,
              Pv_IpCreacion          IN   VARCHAR2,
              Pv_MsjResultado 		   OUT  VARCHAR2); 

END FNCK_ACTUALIZA_TARJETAS_ABU;
/

CREATE OR REPLACE PACKAGE BODY DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU AS  

  PROCEDURE P_CREA_PMA_ACTUALIZA_ABU(
    Pv_UrlFile          	IN  CLOB,  
    Pn_IdMotivo                 IN  DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE,    
    Pv_Observacion              IN  VARCHAR2,
    Pv_UsrCreacion              IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IpCreacion               IN  VARCHAR2,
    Pv_TipoPma                  IN  VARCHAR2,
    Pv_Destinatario             IN  VARCHAR2,
    Pv_MsjResultado             OUT VARCHAR2  
  )
  IS     
    ---
    --Costo: 2
    CURSOR C_ObtieneMotivoSolicitud(Cv_EstadoMotivo   DB_GENERAL.ADMI_MOTIVO.ESTADO%TYPE,
                                    Cv_NombreMotivo   DB_GENERAL.ADMI_MOTIVO.NOMBRE_MOTIVO%TYPE)
    IS  
      SELECT ID_MOTIVO 
      FROM DB_GENERAL.ADMI_MOTIVO 
      WHERE NOMBRE_MOTIVO = Cv_NombreMotivo 
      AND ESTADO          = Cv_EstadoMotivo;

    Lv_IpCreacion             VARCHAR2(20) := (NVL(Pv_IpCreacion,'127.0.0.1'));    
    Ln_IdProcesoMasivoCab     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdProcesoMasivoDet     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;     
    Lr_InfoProcesoMasivoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;    
    Lv_EstadoActivo           VARCHAR2(15):='Activo';    
    Lex_Exception EXCEPTION;

  BEGIN    
    --
    --
    Ln_IdProcesoMasivoCab                             := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;
    Lr_InfoProcesoMasivoCab                           := NULL;
    Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB     := Ln_IdProcesoMasivoCab;
    Lr_InfoProcesoMasivoCab.TIPO_PROCESO              := Pv_TipoPma;
    Lr_InfoProcesoMasivoCab.EMPRESA_ID                := Pv_CodEmpresa;
    Lr_InfoProcesoMasivoCab.CANAL_PAGO_LINEA_ID       := NULL;
    Lr_InfoProcesoMasivoCab.CANTIDAD_PUNTOS           := 0;
    Lr_InfoProcesoMasivoCab.CANTIDAD_SERVICIOS        := 0;
    Lr_InfoProcesoMasivoCab.FACTURAS_RECURRENTES      := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_EMISION_FACTURA     := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_CORTE_DESDE         := NULL;
    Lr_InfoProcesoMasivoCab.FECHA_CORTE_HASTA         := NULL;
    Lr_InfoProcesoMasivoCab.VALOR_DEUDA               := NULL;
    Lr_InfoProcesoMasivoCab.FORMA_PAGO_ID             := NULL;
    Lr_InfoProcesoMasivoCab.IDS_BANCOS_TARJETAS       := Pv_UrlFile;
    Lr_InfoProcesoMasivoCab.IDS_OFICINAS              := Pv_Destinatario;
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

    BEGIN
        --
      DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_INSERT_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Pv_MsjResultado);
      IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
       --
        RAISE Lex_Exception;
       --
      END IF;
        --
    EXCEPTION
    WHEN Lex_Exception THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_CREA_PMA_ACTUALIZA_ABU', 
                                         Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    END;

    --  
    --
    -- INSERTO DETALLE DE PROCESO MASIVO
    Ln_IdProcesoMasivoDet                            :=DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
    Lr_InfoProcesoMasivoDet                          :=NULL;
    Lr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET    :=Ln_IdProcesoMasivoDet;
    Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID    :=Ln_IdProcesoMasivoCab;
    Lr_InfoProcesoMasivoDet.PUNTO_ID                 :=Pn_IdMotivo;
    Lr_InfoProcesoMasivoDet.ESTADO                   :='Pendiente';
    Lr_InfoProcesoMasivoDet.FE_CREACION              :=SYSDATE;
    Lr_InfoProcesoMasivoDet.FE_ULT_MOD               :=NULL;
    Lr_InfoProcesoMasivoDet.USR_CREACION             :=Pv_UsrCreacion;
    Lr_InfoProcesoMasivoDet.USR_ULT_MOD              :=NULL;
    Lr_InfoProcesoMasivoDet.IP_CREACION              :=Lv_IpCreacion;
    Lr_InfoProcesoMasivoDet.SERVICIO_ID              :=NULL;
    Lr_InfoProcesoMasivoDet.OBSERVACION              :=Pv_Observacion;
    Lr_InfoProcesoMasivoDet.SOLICITUD_ID             :=NULL;   
    Lr_InfoProcesoMasivoDet.PERSONA_EMPRESA_ROL_ID   :=NULL;             
    --
    BEGIN
    --
       DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_INSERT_INFO_PROC_MASIVO_DET(Lr_InfoProcesoMasivoDet, Pv_MsjResultado);
       IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
         --
          RAISE Lex_Exception;
         --
       END IF;
       --
    EXCEPTION
      WHEN Lex_Exception THEN
         DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                              'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_CREA_PMA_ACTUALIZA_ABU', 
                                               Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                              'telcos_abu',
                                               SYSDATE,
                                               NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                             ); 
    END;
    --ACTUALIZO CABECERA DE PROCESO MASIVO A PENDIENTE  
    --
    Lr_InfoProcesoMasivoCab.FE_ULT_MOD        := SYSDATE;
    Lr_InfoProcesoMasivoCab.USR_ULT_MOD       := Pv_UsrCreacion;    
    Lr_InfoProcesoMasivoCab.ESTADO            := 'Pendiente';   
    BEGIN
      --
      DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_UPDATE_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Pv_MsjResultado);
      IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
        --
        RAISE Lex_Exception;
        --
      END IF;
      --
    EXCEPTION
    WHEN Lex_Exception THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_CREA_PMA_ACTUALIZA_ABU', 
                                         Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    END;

    --
    COMMIT;
    Pv_MsjResultado      := 'Se procedió a ejecutar el script de '|| Pv_TipoPma ||', por favor esperar el email de confirmación!'; 

    EXCEPTION   
    WHEN OTHERS THEN
      --
      Pv_MsjResultado      := 'Ocurrió un error al guardar el Proceso Masivo '||Pv_TipoPma; 

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_CREA_PMA_ACTUALIZA_ABU', 
                                           Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_abu',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );            
  END P_CREA_PMA_ACTUALIZA_ABU;
   --
   --
  PROCEDURE P_UPDATE_INFO_PROC_MASIVO_CAB(  
    Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
    Pv_MsjResultado          OUT VARCHAR2)
  IS
  BEGIN
  --
    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB 
    SET
    TIPO_PROCESO           =  NVL(Prf_InfoProcesoMasivoCab.TIPO_PROCESO,TIPO_PROCESO),
    FE_ULT_MOD             =  NVL(Prf_InfoProcesoMasivoCab.FE_ULT_MOD,FE_ULT_MOD),
    USR_ULT_MOD            =  NVL(Prf_InfoProcesoMasivoCab.USR_ULT_MOD,USR_ULT_MOD),
    ESTADO                 =  NVL(Prf_InfoProcesoMasivoCab.ESTADO,ESTADO)
    WHERE ID_PROCESO_MASIVO_CAB = Prf_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB;

  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_UPDATE_INFO_PROC_MASIVO_CAB - ' || SQLERRM;
  --
  END P_UPDATE_INFO_PROC_MASIVO_CAB;
  --
  -- 
  PROCEDURE P_INSERT_INFO_PROC_MASIVO_CAB(
    Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
    Pv_MsjResultado          OUT VARCHAR2)
  IS
  BEGIN
    --
    INSERT INTO DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB 
    (ID_PROCESO_MASIVO_CAB,
    TIPO_PROCESO,
    EMPRESA_ID,
    CANAL_PAGO_LINEA_ID,
    CANTIDAD_PUNTOS,
    CANTIDAD_SERVICIOS,
    FACTURAS_RECURRENTES,
    FECHA_EMISION_FACTURA,
    FECHA_CORTE_DESDE,
    FECHA_CORTE_HASTA,
    VALOR_DEUDA,
    FORMA_PAGO_ID,
    IDS_BANCOS_TARJETAS,
    IDS_OFICINAS,
    ESTADO,
    FE_CREACION,
    FE_ULT_MOD,
    USR_CREACION,
    USR_ULT_MOD,
    IP_CREACION,
    PLAN_ID,
    PLAN_VALOR,
    PAGO_ID,
    PAGO_LINEA_ID,
    RECAUDACION_ID,
    DEBITO_ID,
    ELEMENTO_ID,
    SOLICITUD_ID)
    VALUES
    (Prf_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB,
     Prf_InfoProcesoMasivoCab.TIPO_PROCESO,
     Prf_InfoProcesoMasivoCab.EMPRESA_ID,
     Prf_InfoProcesoMasivoCab.CANAL_PAGO_LINEA_ID,
     Prf_InfoProcesoMasivoCab.CANTIDAD_PUNTOS,
     Prf_InfoProcesoMasivoCab.CANTIDAD_SERVICIOS,
     Prf_InfoProcesoMasivoCab.FACTURAS_RECURRENTES,
     Prf_InfoProcesoMasivoCab.FECHA_EMISION_FACTURA,
     Prf_InfoProcesoMasivoCab.FECHA_CORTE_DESDE,
     Prf_InfoProcesoMasivoCab.FECHA_CORTE_HASTA,
     Prf_InfoProcesoMasivoCab.VALOR_DEUDA,
     Prf_InfoProcesoMasivoCab.FORMA_PAGO_ID,
     Prf_InfoProcesoMasivoCab.IDS_BANCOS_TARJETAS,
     Prf_InfoProcesoMasivoCab.IDS_OFICINAS,
     Prf_InfoProcesoMasivoCab.ESTADO,
     Prf_InfoProcesoMasivoCab.FE_CREACION,
     Prf_InfoProcesoMasivoCab.FE_ULT_MOD,
     Prf_InfoProcesoMasivoCab.USR_CREACION,
     Prf_InfoProcesoMasivoCab.USR_ULT_MOD,
     Prf_InfoProcesoMasivoCab.IP_CREACION,
     Prf_InfoProcesoMasivoCab.PLAN_ID,
     Prf_InfoProcesoMasivoCab.PLAN_VALOR,
     Prf_InfoProcesoMasivoCab.PAGO_ID,
     Prf_InfoProcesoMasivoCab.PAGO_LINEA_ID,
     Prf_InfoProcesoMasivoCab.RECAUDACION_ID,
     Prf_InfoProcesoMasivoCab.DEBITO_ID,
     Prf_InfoProcesoMasivoCab.ELEMENTO_ID,
     Prf_InfoProcesoMasivoCab.SOLICITUD_ID
    );

  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_INSERT_INFO_PROC_MASIVO_CAB - ' || SQLERRM;
  --
  END P_INSERT_INFO_PROC_MASIVO_CAB;
  --
  --
  PROCEDURE P_UPDATE_INFO_PROC_MASIVO_DET(
    Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
    Pv_MsjResultado          OUT VARCHAR2)
  IS
  BEGIN
    --
    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET 
    SET
      FE_ULT_MOD                =  NVL(Prf_InfoProcesoMasivoDet.FE_ULT_MOD,FE_ULT_MOD),
      USR_ULT_MOD               =  NVL(Prf_InfoProcesoMasivoDet.USR_ULT_MOD,USR_ULT_MOD),
      OBSERVACION               =  NVL(Prf_InfoProcesoMasivoDet.OBSERVACION,OBSERVACION),
      ESTADO                    =  NVL(Prf_InfoProcesoMasivoDet.ESTADO,ESTADO)
    WHERE ID_PROCESO_MASIVO_DET = Prf_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET;

  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_UPDATE_INFO_PROC_MASIVO_DET - ' || SQLERRM;
  --
  END P_UPDATE_INFO_PROC_MASIVO_DET;
  --
  --
  PROCEDURE P_INSERT_INFO_PROC_MASIVO_DET(
    Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
    Pv_MsjResultado          OUT VARCHAR2)
  IS
  BEGIN
  --
    INSERT INTO 
    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET 
    (ID_PROCESO_MASIVO_DET,
     PROCESO_MASIVO_CAB_ID,
     PUNTO_ID,
     ESTADO,
     FE_CREACION,
     FE_ULT_MOD,
     USR_CREACION,
     USR_ULT_MOD,
     IP_CREACION,
     SERVICIO_ID,
     OBSERVACION,
     SOLICITUD_ID,     
     PERSONA_EMPRESA_ROL_ID) 
     VALUES
     (Prf_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET,
      Prf_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID,
      Prf_InfoProcesoMasivoDet.PUNTO_ID,
      Prf_InfoProcesoMasivoDet.ESTADO,
      Prf_InfoProcesoMasivoDet.FE_CREACION,
      Prf_InfoProcesoMasivoDet.FE_ULT_MOD,
      Prf_InfoProcesoMasivoDet.USR_CREACION,
      Prf_InfoProcesoMasivoDet.USR_ULT_MOD,
      Prf_InfoProcesoMasivoDet.IP_CREACION,
      Prf_InfoProcesoMasivoDet.SERVICIO_ID,
      Prf_InfoProcesoMasivoDet.OBSERVACION,
      Prf_InfoProcesoMasivoDet.SOLICITUD_ID,     
      Prf_InfoProcesoMasivoDet.PERSONA_EMPRESA_ROL_ID);
      --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_INSERT_INFO_PROC_MASIVO_DET - ' || SQLERRM;
    --
  END P_INSERT_INFO_PROC_MASIVO_DET;
  --
  --
  FUNCTION F_VALIDA_CODIGO_COMERCIO(Fv_CodigoComercio IN VARCHAR2)
    RETURN BOOLEAN
  IS

   --Costo: 3
   CURSOR C_ParamCodigoComercio (Cv_CodigoComercio VARCHAR2)
    IS
     SELECT APD.VALOR2 AS VALOR2
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.PARAMETRO_ID   = APC.ID_PARAMETRO
      AND APD.ESTADO           = 'Activo'
      AND APC.NOMBRE_PARAMETRO = 'PARAM_TARJETAS_ABU'
      AND APD.DESCRIPCION      = 'FORMATO_TARJETAS_ABU'
      AND APD.VALOR1           = 'CODIGO_COMERCIO'
      AND APD.VALOR2           = TRIM(Cv_CodigoComercio)
      AND APC.ESTADO           = 'Activo'
      ORDER BY APD.VALOR2 ASC;

    Lv_ExisteCodigoComercio VARCHAR2(50);
    Lb_ExisteCodigoComercio BOOLEAN:= FALSE;
    Lv_MsjResultado         VARCHAR2(2000);

  BEGIN  

    IF C_ParamCodigoComercio%ISOPEN THEN
    --
      CLOSE C_ParamCodigoComercio;
    --
    END IF;

    OPEN  C_ParamCodigoComercio(Fv_CodigoComercio);
    FETCH C_ParamCodigoComercio INTO Lv_ExisteCodigoComercio;
    --
    IF Lv_ExisteCodigoComercio IS NOT NULL THEN
       Lb_ExisteCodigoComercio := TRUE;
    END IF;
    --
    CLOSE C_ParamCodigoComercio;    

    RETURN Lb_ExisteCodigoComercio;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar el codigo de comercio CodigoComercio: ' || Fv_CodigoComercio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDA_CODIGO_COMERCIO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));

    Lb_ExisteCodigoComercio:=FALSE;
    RETURN Lb_ExisteCodigoComercio;

  END F_VALIDA_CODIGO_COMERCIO;


FUNCTION F_VALIDAR_CLIENTE( Fv_IdentificacionCliente IN VARCHAR2, 
                            Fn_CodigoEmpresa IN VARCHAR2)
    RETURN CLOB 
  IS

    CURSOR C_ParamFormatoIdentificacion IS
    SELECT APD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
         DB_GENERAL.ADMI_PARAMETRO_DET APD 
    WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID AND APC.nombre_parametro='PARAM_TARJETAS_ABU' 
    AND VALOR1 ='IDENTIF_CLIENTE_PR';
    Lc_Json                       CLOB;
    Lv_ParamFormatoIdentificacion   VARCHAR2(50);
    Lv_ParamClienteExiste           VARCHAR2(50);

    Lv_MsjResultado                 VARCHAR2(2000):= NULL;
    Lv_LadoRellenoIdentificacion    VARCHAR2(2000);
    Lv_RellenoIdentificacion        VARCHAR2(2000);
    Lv_LongIdentificacion           VARCHAR2(50) := LENGTH(Fv_IdentificacionCliente);
    Lv_ConsultaEjecutar             VARCHAR2(2000); 
    Lv_NumeroIdentificacion         VARCHAR2(50);
    Ln_PersonaEmpresaRolId          NUMBER:=0;
    Lv_Estado                       VARCHAR2(50):='FALSE';
        CURSOR C_ExisteCliente(Lv_NumeroIdentificacion VARCHAR2) IS
        SELECT  IC.ID_CONTRATO,IC.PERSONA_EMPRESA_ROL_ID
        FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO  ICFP
        INNER JOIN DB_COMERCIAL.INFO_CONTRATO IC ON ICFP.CONTRATO_ID= IC.ID_CONTRATO
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IC.PERSONA_EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IPER.EMPRESA_ROL_ID=IER.ID_EMPRESA_ROL 
        INNER JOIN DB_COMERCIAL.INFO_PERSONA PER ON PER.ID_PERSONA = IPER.PERSONA_ID
        WHERE IC.ESTADO IN ('Activo', 'Cancelado') 
        AND  IER.EMPRESA_COD= Fn_CodigoEmpresa AND PER.IDENTIFICACION_CLIENTE =Lv_NumeroIdentificacion;   

    CURSOR C_FormaPagoCliente(Lv_NumeroIdentificacion VARCHAR2) IS
	    SELECT  IC.ID_CONTRATO, IC.PERSONA_EMPRESA_ROL_ID
	    FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO  ICFP
	    INNER JOIN DB_COMERCIAL.INFO_CONTRATO IC ON ICFP.CONTRATO_ID= IC.ID_CONTRATO
	    INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON IC.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO
	    INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IC.PERSONA_EMPRESA_ROL_ID
	    INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IPER.EMPRESA_ROL_ID=IER.ID_EMPRESA_ROL 
	    INNER JOIN DB_COMERCIAL.INFO_PERSONA PER ON PER.ID_PERSONA = IPER.PERSONA_ID
	    WHERE IC.ESTADO IN ('Activo', 'Cancelado')
	    AND ICFP.ESTADO='Activo' 
	    AND AFP.CODIGO_FORMA_PAGO IN ('TARC','DEB')  
	    AND  IER.EMPRESA_COD= Fn_CodigoEmpresa 
	    AND PER.IDENTIFICACION_CLIENTE =Lv_NumeroIdentificacion;

    CURSOR C_GetObservacion( Cv_EmpresaCod 	   IN INTEGER)
    IS
       SELECT REPLACE(APD.VALOR2, 'X', 'IDENTIF. CLIENTE PR') INTO Lv_MsjResultado from DB_GENERAL.ADMI_PARAMETRO_CAB APC
       INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO=PARAMETRO_ID
       WHERE APC.nombre_parametro='PARAM_TARJETAS_ABU' AND APD.VALOR1='COD_FORMATO' AND APD.ESTADO='Activo' AND APD.EMPRESA_COD=Cv_EmpresaCod;

     CURSOR C_GetParametroValor(  Cv_EmpresaCod 	   IN VARCHAR2,
                                  Cv_NombreParamCab IN VARCHAR2,
                                  Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.ESTADO           = 'Activo'
        AND APD.ESTADO           = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.VALOR1           = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod; 

    TYPE t_FormaPagoCliente IS TABLE OF C_FormaPagoCliente%ROWTYPE;
	  Lv_ParamFormaPago t_FormaPagoCliente;
    idx NUMBER;

  BEGIN  

    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT();
    APEX_JSON.OPEN_ARRAY('arrContratos');
    IF C_ParamFormatoIdentificacion%ISOPEN THEN
    --
      CLOSE C_ParamFormatoIdentificacion;
    --
    END IF;

    OPEN  C_ParamFormatoIdentificacion;
    FETCH C_ParamFormatoIdentificacion INTO Lv_ParamFormatoIdentificacion;
    --

      IF TRIM(Fv_IdentificacionCliente) IS NOT NULL AND Lv_LongIdentificacion=Lv_ParamFormatoIdentificacion THEN
        IF C_ExisteCliente%ISOPEN THEN
            --
          CLOSE C_ExisteCliente;
            --
        END IF;

        OPEN  C_GetParametroValor(Fn_CodigoEmpresa,'PARAM_TARJETAS_ABU','LADO_RELLENO_IDENTIFICACION'); 
        FETCH C_GetParametroValor INTO Lv_LadoRellenoIdentificacion;
        CLOSE C_GetParametroValor;

        OPEN  C_GetParametroValor(Fn_CodigoEmpresa,'PARAM_TARJETAS_ABU','RELLENO_IDENTIFICACION'); 
        FETCH C_GetParametroValor INTO Lv_RellenoIdentificacion;
        CLOSE C_GetParametroValor;


        IF TRIM(Lv_LadoRellenoIdentificacion) IS NOT NULL AND TRIM(Lv_RellenoIdentificacion) IS NOT NULL THEN 
        Lv_ConsultaEjecutar := 'SELECT '|| Lv_LadoRellenoIdentificacion || '(''' || Fv_IdentificacionCliente || ''',''' || Lv_RellenoIdentificacion || ''') FROM DUAL';
        EXECUTE IMMEDIATE Lv_ConsultaEjecutar INTO Lv_NumeroIdentificacion;
           IF TRIM(Lv_NumeroIdentificacion) IS NOT NULL THEN 
            IF TRIM(Lv_LadoRellenoIdentificacion) =TRIM('LTRIM') THEN 
              IF LENGTH(Lv_NumeroIdentificacion)<10 THEN
              Lv_NumeroIdentificacion := LPAD(Lv_NumeroIdentificacion,10,Lv_RellenoIdentificacion);
              END IF;
               IF LENGTH(Lv_NumeroIdentificacion)>10 THEN
              Lv_NumeroIdentificacion := LPAD(Lv_NumeroIdentificacion,13,Lv_RellenoIdentificacion);
              END IF;
            END IF;
            IF TRIM(Lv_LadoRellenoIdentificacion) =TRIM('RTRIM') THEN 
              IF LENGTH(Lv_NumeroIdentificacion)<10 THEN
                Lv_NumeroIdentificacion := RPAD(Lv_NumeroIdentificacion,10,Lv_RellenoIdentificacion);
              END IF;
               IF LENGTH(Lv_NumeroIdentificacion)> 10 THEN
                Lv_NumeroIdentificacion := RPAD(Lv_NumeroIdentificacion,13,Lv_RellenoIdentificacion);
              END IF;
            END IF;

              OPEN  C_ExisteCliente(Lv_NumeroIdentificacion);
                FETCH C_ExisteCliente INTO Lv_ParamClienteExiste,Ln_PersonaEmpresaRolId;

                  IF Lv_ParamClienteExiste IS NOT NULL THEN
                    IF C_FormaPagoCliente%ISOPEN THEN
                        --
                      CLOSE C_FormaPagoCliente;
                        --
                    END IF;


                     OPEN C_FormaPagoCliente(Lv_NumeroIdentificacion);
                      FETCH C_FormaPagoCliente BULK COLLECT INTO Lv_ParamFormaPago;
                     	idx := Lv_ParamFormaPago.FIRST();
                        WHILE (idx IS NOT NULL) LOOP

                          IF Lv_ParamFormaPago(idx).ID_CONTRATO IS NOT NULL THEN
                              APEX_JSON.OPEN_OBJECT();
                              Lv_Estado :='TRUE';
                              APEX_JSON.WRITE('strCodigoContrato', Lv_ParamFormaPago(idx).ID_CONTRATO);
                              APEX_JSON.WRITE('intPersonaEmpresaRolId', Lv_ParamFormaPago(idx).PERSONA_EMPRESA_ROL_ID);
                              APEX_JSON.CLOSE_OBJECT();
                          ELSE
                              OPEN  C_GetParametroValor(Fn_CodigoEmpresa,'PARAM_TARJETAS_ABU','COD_FORMA_PAGO'); 
                              FETCH C_GetParametroValor INTO Lv_MsjResultado;
                              CLOSE C_GetParametroValor;
                          END IF;
                          idx := Lv_ParamFormaPago.NEXT(idx);
	                      END LOOP;
                      CLOSE C_FormaPagoCliente;



                  ELSE
                    OPEN  C_GetParametroValor(Fn_CodigoEmpresa,'PARAM_TARJETAS_ABU','COD_CLIENTE'); 
                    FETCH C_GetParametroValor INTO Lv_MsjResultado;
                    CLOSE C_GetParametroValor;


                  END IF;
                CLOSE C_ExisteCliente;  
              ELSE

                OPEN  C_GetObservacion(Fn_CodigoEmpresa); 
                FETCH C_GetObservacion INTO Lv_MsjResultado;
                CLOSE C_GetObservacion;

              END IF;
          ELSE
                OPEN  C_GetObservacion(Fn_CodigoEmpresa); 
                FETCH C_GetObservacion INTO Lv_MsjResultado;
                CLOSE C_GetObservacion;
          END IF;
       ELSE
                OPEN  C_GetObservacion(Fn_CodigoEmpresa); 
                FETCH C_GetObservacion INTO Lv_MsjResultado;
                CLOSE C_GetObservacion;


        END IF;
      CLOSE C_ParamFormatoIdentificacion;
      APEX_JSON.CLOSE_ARRAY;
      APEX_JSON.WRITE('strEstado', Lv_Estado);
      APEX_JSON.WRITE('strMensaje', Lv_MsjResultado);
      APEX_JSON.CLOSE_OBJECT;
      Lc_Json := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
      RETURN Lc_Json; 
   EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la identidad del cliente: ' || Fv_IdentificacionCliente; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDAR_CLIENTE', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));


    RETURN NULL;
END F_VALIDAR_CLIENTE;

   FUNCTION F_VALIDAR_NUMERO_ANTIGUO(  Fv_NumeroAntiguo IN VARCHAR2,
                                      Fn_CodigoContrato IN VARCHAR2, 
                                      Fi_EmpresaCod IN INTEGER)
    RETURN CLOB 
  IS 
    CURSOR C_ParamFormatoNumeroAntiguo IS
    SELECT APD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
         DB_GENERAL.ADMI_PARAMETRO_DET APD 
    WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID AND APC.nombre_parametro='PARAM_TARJETAS_ABU' 
    AND trim(VALOR1) ='NUMERO_TARJETA_ANTIGUO' AND APD.ESTADO='Activo';

    CURSOR C_ParamSecretKey IS
          SELECT APD.VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC, 
          DB_GENERAL.ADMI_PARAMETRO_DET APD 
          WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID AND APC.nombre_parametro='PARAM_TARJETAS_ABU' 
          AND trim(VALOR1) ='SECRET_KEY_ENCRYPT_DECRYPT' AND APD.ESTADO='Activo';

    CURSOR C_GetParametroValor(  Cv_EmpresaCod 	   IN VARCHAR2,
                            Cv_NombreParamCab IN VARCHAR2,
                            Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
          DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.ESTADO           = 'Activo'
        AND APD.ESTADO           = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.VALOR1           = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod; 

    CURSOR C_NumCuenta(Cv_CodigoContrato IN VARCHAR2) 
    IS
        SELECT  ICFP.NUMERO_CTA_TARJETA, ABTC.TOTAL_CARACTERES, ICFP.ID_DATOS_PAGO 
        FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO  ICFP
        INNER JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC ON ABTC.ID_BANCO_TIPO_CUENTA=ICFP.BANCO_TIPO_CUENTA_ID
        INNER JOIN DB_COMERCIAL.INFO_CONTRATO IC ON ICFP.CONTRATO_ID= IC.ID_CONTRATO
        INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON IC.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO
        WHERE IC.ESTADO IN ('Activo', 'Cancelado')   AND ICFP.ESTADO='Activo' 
        AND AFP.CODIGO_FORMA_PAGO IN ('TARC','DEB')  AND ICFP.contrato_id= Cv_CodigoContrato ORDER BY ICFP.ID_DATOS_PAGO DESC;

     CURSOR C_GetObservacion( Cv_EmpresaCod 	   IN INTEGER)
      IS
         SELECT REPLACE(APD.VALOR2, 'X', 'NUMERO TARJETA ANTIGUO')  from DB_GENERAL.ADMI_PARAMETRO_CAB APC
         INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO=PARAMETRO_ID
         WHERE APC.nombre_parametro='PARAM_TARJETAS_ABU' AND APD.VALOR1='COD_FORMATO' AND APD.ESTADO='Activo' AND APD.EMPRESA_COD=Cv_EmpresaCod;  


    Lv_ParamNumeroAntiguo             VARCHAR2(50);
    Lv_LongNumeroAntiguo              VARCHAR2(50):= LENGTH(Fv_NumeroAntiguo);
    Lv_NumeroAntiguo                  VARCHAR2(50);
    Lv_NumeroAntiguoEncryptado        VARCHAR2(50);
    Lv_NumeroAntiguoDesencryptado     VARCHAR2(50);
    Lv_SecretKey                      VARCHAR2(50);
    Ln_TotalCaracteres                NUMBER;
    Ln_IdDatosPago                    NUMBER;
    Lv_ConsultaEjecutar               VARCHAR2(1000);
    Lv_RellenoNumeroTarjetaAntiguo    VARCHAR2(1000);
    Lv_LadoRellenoNumTarjAntiguo      VARCHAR2(1000);
    Lv_MsjResultado                   VARCHAR2(2000):=NULL ;
    Lv_Estado                         VARCHAR2(50):='FALSE';
    Lc_Json                           CLOB;
    BEGIN  
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT();
    IF C_ParamSecretKey%ISOPEN THEN
      --
       CLOSE C_ParamSecretKey;
      --
    END IF;
    OPEN C_ParamSecretKey;
    FETCH C_ParamSecretKey INTO Lv_SecretKey;
    --

    IF TRIM(Lv_SecretKey) IS NOT NULL THEN
    --      
      OPEN C_ParamFormatoNumeroAntiguo;
      FETCH C_ParamFormatoNumeroAntiguo INTO Lv_ParamNumeroAntiguo;
      CLOSE C_ParamFormatoNumeroAntiguo;
        --

          IF TRIM(Fv_NumeroAntiguo) IS NOT NULL AND Lv_LongNumeroAntiguo=Lv_ParamNumeroAntiguo THEN
            --
             IF C_NumCuenta%ISOPEN THEN
            --
                CLOSE C_NumCuenta;
            --
              END IF;
              OPEN C_NumCuenta(Fn_CodigoContrato);
              FETCH C_NumCuenta INTO Lv_NumeroAntiguoEncryptado,Ln_TotalCaracteres,Ln_IdDatosPago;
              --

                IF TRIM(Lv_NumeroAntiguoEncryptado) IS NOT NULL THEN
                  --

                  DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_DESCENCRIPTAR(Lv_NumeroAntiguoEncryptado,Lv_SecretKey, Lv_NumeroAntiguoDesencryptado);


                  OPEN  C_GetParametroValor(Fi_EmpresaCod,'PARAM_TARJETAS_ABU','LADO_RELLENO_NUMERO_TARJETA_ANTIGUO'); 
                  FETCH C_GetParametroValor INTO Lv_LadoRellenoNumTarjAntiguo;
                  CLOSE C_GetParametroValor;

                  OPEN  C_GetParametroValor(Fi_EmpresaCod,'PARAM_TARJETAS_ABU','RELLENO_NUMERO_TARJETA_ANTIGUO'); 
                  FETCH C_GetParametroValor INTO Lv_RellenoNumeroTarjetaAntiguo;
                  CLOSE C_GetParametroValor;

                  Lv_ConsultaEjecutar := 'SELECT '|| Lv_LadoRellenoNumTarjAntiguo || '(''' || Fv_NumeroAntiguo || ''',''' || Lv_RellenoNumeroTarjetaAntiguo || ''') FROM DUAL';

                  EXECUTE IMMEDIATE Lv_ConsultaEjecutar INTO Lv_NumeroAntiguo;


                  IF TRIM(Lv_LadoRellenoNumTarjAntiguo) =TRIM('LTRIM') AND LENGTH(Lv_NumeroAntiguo)=Ln_TotalCaracteres THEN 

                    --
                    Lv_NumeroAntiguo := LPAD(Lv_NumeroAntiguo,Ln_TotalCaracteres,Lv_RellenoNumeroTarjetaAntiguo);

                  --  
                  END IF;


                  IF TRIM(Lv_LadoRellenoNumTarjAntiguo) =TRIM('RTRIM') AND LENGTH(Lv_NumeroAntiguo)=Ln_TotalCaracteres THEN 
                  --

                    Lv_NumeroAntiguo := RPAD(Lv_NumeroAntiguo,Ln_TotalCaracteres,Lv_RellenoNumeroTarjetaAntiguo);

                  --  
                  END IF;

                  IF TRIM(Lv_NumeroAntiguo)= TRIM(Lv_NumeroAntiguoDesencryptado) THEN 
                  --
                    Lv_Estado := 'TRUE';
                    APEX_JSON.WRITE('intIdDatosPago', Ln_IdDatosPago);
                  --
                  ELSE
                  --
                    OPEN  C_GetParametroValor(Fi_EmpresaCod,'PARAM_TARJETAS_ABU','COD_NUM_TARJ_ANTERIOR'); 
                    FETCH C_GetParametroValor INTO Lv_MsjResultado;
                    CLOSE C_GetParametroValor;

                  -- 
                  END IF;
                --  
                ELSE 
                --
                  OPEN  C_GetObservacion(Fi_EmpresaCod); 
                  FETCH C_GetObservacion INTO Lv_MsjResultado;
                  CLOSE C_GetObservacion;
                --            
                END IF;
              --  
              CLOSE C_NumCuenta;
          ELSE
          --
            OPEN  C_GetObservacion(Fi_EmpresaCod); 
            FETCH C_GetObservacion INTO Lv_MsjResultado;
            CLOSE C_GetObservacion;


          --            
          END IF;
      --

    --  
    END IF;
    CLOSE C_ParamSecretKey;
      APEX_JSON.WRITE('strEstado', Lv_Estado);
      APEX_JSON.WRITE('strMensaje', Lv_MsjResultado);
      APEX_JSON.CLOSE_OBJECT;
      Lc_Json := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
      RETURN Lc_Json; 
    EXCEPTION
    WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la identidad del cliente: ' || Fv_NumeroAntiguo; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDAR_NUMERO_ANTIGUO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));


    RETURN NULL; 

  END F_VALIDAR_NUMERO_ANTIGUO;

  FUNCTION F_VALIDAR_NUMERO_NUEVO(  Fv_NumeroNuevo IN VARCHAR2,
                                    Fn_CodigoContrato IN VARCHAR2, 
                                    Fi_EmpresaCod IN INTEGER)
    RETURN CLOB
  IS 


    CURSOR C_LongitudNumCta(Fn_CodigoContrato IN VARCHAR2) IS
    SELECT ABTC.TOTAL_CARACTERES 
    FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO  ICFP
    INNER JOIN DB_GENERAL.ADMI_BANCO_TIPO_CUENTA ABTC ON ABTC.ID_BANCO_TIPO_CUENTA=ICFP.BANCO_TIPO_CUENTA_ID
    INNER JOIN DB_COMERCIAL.INFO_CONTRATO IC ON ICFP.CONTRATO_ID= IC.ID_CONTRATO
    INNER JOIN DB_GENERAL.ADMI_FORMA_PAGO AFP ON IC.FORMA_PAGO_ID = AFP.ID_FORMA_PAGO
    AND AFP.CODIGO_FORMA_PAGO IN ('TARC','DEB')  AND ICFP.contrato_id= Fn_CodigoContrato;

    Lv_ParamNumero                VARCHAR2(50);
    Lv_LongNumero                 VARCHAR2(50):= LENGTH(Fv_NumeroNuevo);
    Lv_NumeroNuevo                VARCHAR2(50);
    Ln_TotalCaracteres            NUMBER;
    Lv_ConsultaEjecutar           VARCHAR2(1000);
    Lv_RellenoNumeroTarjeta       VARCHAR2(1000);
    Lv_LadoRellenoNumTarj         VARCHAR2(1000);
    Lv_MsjResultado               VARCHAR2(2000):=NULL ;
    Lv_Estado                     VARCHAR2(50):='FALSE';
    Lc_Json                       CLOB;
    CURSOR C_GetParametroValor(  Cv_EmpresaCod 	   IN VARCHAR2,
                            Cv_NombreParamCab IN VARCHAR2,
                            Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.VALOR2
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
          DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.ESTADO           = 'Activo'
        AND APD.ESTADO           = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.VALOR1           = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod; 

    CURSOR C_GetObservacion( Cv_EmpresaCod 	   IN INTEGER)
      IS
         SELECT REPLACE(APD.VALOR2, 'X', 'NUMERO TARJETA NUEVO')  from DB_GENERAL.ADMI_PARAMETRO_CAB APC
         INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO=PARAMETRO_ID
         WHERE APC.nombre_parametro='PARAM_TARJETAS_ABU' AND APD.VALOR1='COD_FORMATO' AND APD.ESTADO='Activo' AND APD.EMPRESA_COD=Cv_EmpresaCod;   

    BEGIN   
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT();

      OPEN  C_GetParametroValor(Fi_EmpresaCod,'PARAM_TARJETAS_ABU','NUMERO_TARJETA_NUEVO'); 
      FETCH C_GetParametroValor INTO Lv_ParamNumero;
      CLOSE C_GetParametroValor;

       --   
          IF TRIM(Fv_NumeroNuevo) IS NOT NULL AND Lv_LongNumero=Lv_ParamNumero THEN
            -- 
             IF C_LongitudNumCta%ISOPEN THEN
            --
                CLOSE C_LongitudNumCta;
            --
              END IF;
              OPEN C_LongitudNumCta(Fn_CodigoContrato);
              FETCH C_LongitudNumCta INTO Ln_TotalCaracteres;
              --
                IF TRIM(Ln_TotalCaracteres) IS NOT NULL THEN
                  OPEN  C_GetParametroValor(Fi_EmpresaCod,'PARAM_TARJETAS_ABU','LADO_RELLENO_NUMERO_TARJETA_NUEVO'); 
                  FETCH C_GetParametroValor INTO Lv_LadoRellenoNumTarj;
                  CLOSE C_GetParametroValor;
                 -- 
                  OPEN  C_GetParametroValor(Fi_EmpresaCod,'PARAM_TARJETAS_ABU','RELLENO_NUMERO_TARJETA_NUEVO'); 
                  FETCH C_GetParametroValor INTO Lv_RellenoNumeroTarjeta;
                  CLOSE C_GetParametroValor;


                  IF TRIM(Lv_LadoRellenoNumTarj) IS NOT NULL AND TRIM(Lv_RellenoNumeroTarjeta) IS NOT NULL THEN 
                  --
                    Lv_ConsultaEjecutar := 'SELECT '|| Lv_LadoRellenoNumTarj || '(''' || Fv_NumeroNuevo || ''',''' || Lv_RellenoNumeroTarjeta || ''') FROM DUAL';
                    EXECUTE IMMEDIATE Lv_ConsultaEjecutar INTO Lv_NumeroNuevo;
                    IF TRIM(Lv_LadoRellenoNumTarj) =TRIM('LTRIM') AND LENGTH(Lv_NumeroNuevo)=Ln_TotalCaracteres  THEN 

                      --
                      Lv_NumeroNuevo := LPAD(Lv_NumeroNuevo,Ln_TotalCaracteres,Lv_RellenoNumeroTarjeta);

                    --  
                    END IF;
                    --
                    IF TRIM(Lv_LadoRellenoNumTarj) =TRIM('RTRIM') AND LENGTH(Lv_NumeroNuevo)=Ln_TotalCaracteres THEN 
                    --

                      Lv_NumeroNuevo := RPAD(Lv_NumeroNuevo,Ln_TotalCaracteres,Lv_RellenoNumeroTarjeta);

                    --
                    END IF; 
                    Lv_Estado :='TRUE';
                    APEX_JSON.WRITE('strNumeroNuevo', Lv_NumeroNuevo);
                  ELSE 
                  --
                    OPEN  C_GetObservacion(Fi_EmpresaCod); 
                    FETCH C_GetObservacion INTO Lv_MsjResultado;
                    CLOSE C_GetObservacion;

                     --
                  END IF;
                 -- 
                END IF;
              CLOSE C_LongitudNumCta;
          ELSE
          --
            OPEN  C_GetObservacion(Fi_EmpresaCod); 
            FETCH C_GetObservacion INTO Lv_MsjResultado;
            CLOSE C_GetObservacion;


          --  
          END IF;


      APEX_JSON.WRITE('strEstado', Lv_Estado);
      APEX_JSON.WRITE('strMensaje', Lv_MsjResultado);
      APEX_JSON.CLOSE_OBJECT;
      Lc_Json := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
      RETURN Lc_Json; 

    EXCEPTION
    WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al validar la identidad del cliente: ' || Fv_NumeroNuevo; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDAR_NUMERO_NUEVO', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));


    RETURN NULL;

  END F_VALIDAR_NUMERO_NUEVO;  


  FUNCTION F_VALIDAR_FECHA_CADUCIDAD( Fv_FechaCaducidad IN VARCHAR2, Fi_EmpresaCod  IN INTEGER)
    RETURN CLOB 
    IS  

      Lv_FechaFormato                   VARCHAR2(2000);
      Lv_FechaFormatoOrigin             VARCHAR2(2000);
      Lv_MsjResultado                   VARCHAR2(2000):=NULL ;
      Lv_Estado                         VARCHAR2(50)  :='FALSE';
      Lc_Json                           CLOB;
      Lv_ResultadoFecha                 VARCHAR2(2000);

      CURSOR C_GetObservacion( Cv_EmpresaCod 	   IN INTEGER)
      IS
         SELECT REPLACE(APD.VALOR2, 'X', 'FECHA CADUCIDAD NUEVA') from DB_GENERAL.ADMI_PARAMETRO_CAB APC
         INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO=PARAMETRO_ID
         WHERE APC.nombre_parametro='PARAM_TARJETAS_ABU' AND APD.VALOR1='COD_FORMATO' AND APD.ESTADO='Activo'AND APD.EMPRESA_COD=Cv_EmpresaCod;

      CURSOR C_GetRespMensaje( Cv_EmpresaCod 	   IN INTEGER)
      IS
         SELECT REPLACE(REPLACE(APD.VALOR2, 'X', 'FECHA CADUCIDAD NUEVA'), '(YYYYMM)', TO_CHAR(SYSDATE,Lv_FechaFormato))
         from DB_GENERAL.ADMI_PARAMETRO_CAB APC
         INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO=PARAMETRO_ID
         WHERE APC.nombre_parametro='PARAM_TARJETAS_ABU' AND APD.VALOR1='COD_FECHA_CAD_NUEVA' AND APD.ESTADO='Activo' AND APD.EMPRESA_COD=Cv_EmpresaCod;

      CURSOR C_GetParametros( Cv_EmpresaCod 	   IN INTEGER)
      IS
        SELECT APD.VALOR2 from DB_GENERAL.ADMI_PARAMETRO_CAB APC
        INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO=PARAMETRO_ID
        WHERE APC.nombre_parametro='PARAM_TARJETAS_ABU' AND APD.VALOR1='FECHA_CADUCIDAD_NUEVA' AND APD.ESTADO='Activo' AND APD.EMPRESA_COD=Cv_EmpresaCod;

      BEGIN 
      --
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT();

      OPEN  C_GetParametros(Fi_EmpresaCod); 
      FETCH C_GetParametros INTO Lv_FechaFormato;
      CLOSE C_GetParametros;

        IF Fv_FechaCaducidad IS NOT NULL THEN
        --
           IF REGEXP_LIKE(Fv_FechaCaducidad, '^[0-9]+$') AND LENGTH(Fv_FechaCaducidad)=6   THEN  
            --
             IF TO_DATE(Fv_FechaCaducidad, Lv_FechaFormato) BETWEEN TO_DATE('1900/01','YYYY/MM')AND TO_DATE('9999/12','YYYY/MM')  THEN
             --
                IF TO_CHAR( TO_DATE(Fv_FechaCaducidad, Lv_FechaFormato),Lv_FechaFormato) > TO_CHAR(SYSDATE,Lv_FechaFormato)THEN
                --
                   Lv_Estado := 'TRUE';
                   Lv_ResultadoFecha:= TO_CHAR( TO_DATE(Fv_FechaCaducidad, Lv_FechaFormato),Lv_FechaFormato);
                   APEX_JSON.WRITE('strFecha', Lv_ResultadoFecha); 
                --   
                ELSE
                --
                    OPEN  C_GetRespMensaje(Fi_EmpresaCod); 
                    FETCH C_GetRespMensaje INTO Lv_MsjResultado;
                    CLOSE C_GetRespMensaje;
                --  
                END IF;
              --  
              ELSE
              --
                OPEN  C_GetObservacion(Fi_EmpresaCod); 
                FETCH C_GetObservacion INTO Lv_MsjResultado;
                CLOSE C_GetObservacion;
              --  
              END IF;
          --    
          ELSE
          --
            OPEN  C_GetObservacion(Fi_EmpresaCod); 
            FETCH C_GetObservacion INTO Lv_MsjResultado;
            CLOSE C_GetObservacion;
          --  
          END IF;
        --  
        ELSE
        --
          OPEN  C_GetObservacion(Fi_EmpresaCod); 
          FETCH C_GetObservacion INTO Lv_MsjResultado;
          CLOSE C_GetObservacion;
        --
        END IF;

        APEX_JSON.WRITE('strEstado', Lv_Estado);
        APEX_JSON.WRITE('strMensaje', Lv_MsjResultado);
        APEX_JSON.CLOSE_OBJECT;
        Lc_Json := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        RETURN Lc_Json; 
    EXCEPTION
    WHEN OTHERS THEN

  --
    Lv_MsjResultado := 'Ocurrió un error al validar la fecha de caducidad nueva: ' || Fv_FechaCaducidad; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDAR_FECHA_CADUCIDAD', 
                                         Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));


    RETURN NULL;

  END F_VALIDAR_FECHA_CADUCIDAD;



  PROCEDURE P_INFO_CONTRATO_FORMA_PAGO(
    Pr_InfoContratoFormaPagoHist  IN DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST%ROWTYPE,
    Pr_InfoPersonaEmpresaRolHist  IN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE,
    Pc_ParametroFormPago          IN CLOB,
    Pn_PersonaEmpresaRolId        IN NUMBER,
    Pv_UsrSesion                  IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_IpCreacion                 IN VARCHAR2,
    Pv_MsnError                   OUT VARCHAR2,
    Pv_Resultado                  OUT VARCHAR2,
    Pv_EstadoFinalizacion		  OUT VARCHAR2)  
  IS 
    Lv_ResultadoContrato     VARCHAR2(1000);
    Lv_NombreArchivoOrigin   VARCHAR2(1000);    
    Ln_IdDatosPago           VARCHAR2(1000);
    Lv_NumNuevo              VARCHAR2(1000);
    Lv_FechaTarjeta          VARCHAR2(1000);
    Lv_IpCreacion            VARCHAR2(1000);
    Lv_EmpresaCod            VARCHAR2(1000);
    TYPE Lr_InfoPunto
    IS
      RECORD
      (
        PREFIJO              DB_COMERCIAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE, 
        ID_PUNTO             DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE
        );
    TYPE T_InfoPunto IS TABLE OF Lr_InfoPunto INDEX BY PLS_INTEGER;
    CURSOR C_InfoPunto 
    IS
        SELECT IEG.PREFIJO, IP.ID_PUNTO FROM DB_COMERCIAL.INFO_PUNTO IP
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IPER.ID_PERSONA_ROL=IP.PERSONA_EMPRESA_ROL_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IPER.EMPRESA_ROL_ID=IER.ID_EMPRESA_ROL 
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG ON IEG.COD_EMPRESA=  IER.EMPRESA_COD
        WHERE IP.PERSONA_EMPRESA_ROL_ID = Pn_PersonaEmpresaRolId;
        Le_InfoPunto              T_InfoPunto;
        Li_Limit                  CONSTANT PLS_INTEGER DEFAULT 10000;
        Li_Cont                   PLS_INTEGER;

    CURSOR C_GetParametroValor(Cv_EmpresaCod 	   IN VARCHAR2,
   						 Cv_NombreParamCab IN VARCHAR2,
   						 Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
          DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.ESTADO           = 'Activo'
        AND APD.ESTADO           = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.VALOR1           = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod;  
         Lr_Usuario		          C_GetParametroValor%ROWTYPE;
         Lr_FechaFormato			  C_GetParametroValor%ROWTYPE;
         Lr_NombreTarea			    C_GetParametroValor%ROWTYPE;
         Lr_OrgTareaPar			    C_GetParametroValor%ROWTYPE;
         Lr_NombreProceso			  C_GetParametroValor%ROWTYPE;
         Lr_ClaseTarea			    C_GetParametroValor%ROWTYPE;
         Lr_GeneraTarea         C_GetParametroValor%ROWTYPE;
         Lv_SecretKey           C_GetParametroValor%ROWTYPE;
         Lv_Resultado           C_GetParametroValor%ROWTYPE;

    CURSOR C_GetInfoPersonaEmp(Cv_EmpresaCod 	   IN VARCHAR2,
                               Cv_UsrSesion 	   IN DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE)
    IS
        SELECT ID_PERSONA_ROL, IPER.DEPARTAMENTO_ID  FROM DB_COMERCIAL.INFO_PERSONA IP
        INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER ON IP.ID_PERSONA= IPER.PERSONA_ID
        INNER JOIN DB_COMERCIAL.INFO_EMPRESA_ROL IER ON IPER.EMPRESA_ROL_ID=IER.ID_EMPRESA_ROL
        WHERE TRIM(IP.LOGIN)=TRIM(Cv_UsrSesion) AND IP.ESTADO='Activo' AND IPER.ESTADO ='Activo' AND IER.EMPRESA_COD=Cv_EmpresaCod; 

        Lr_InfoPersonaEmp		          C_GetInfoPersonaEmp%ROWTYPE;

    CURSOR C_GetFormaContacto(Cv_OrgTareaPar IN VARCHAR2)
    IS
          SELECT AFC.ID_FORMA_CONTACTO  FROM DB_SOPORTE.ADMI_FORMA_CONTACTO AFC WHERE TRIM(CODIGO)=Cv_OrgTareaPar; 

    CURSOR C_GetObservacion( Cv_EmpresaCod 	   IN VARCHAR2,
                             Cv_NombreParamCab IN VARCHAR2,
                             Cv_DescripcionDet IN VARCHAR2,
                             Cv_NombreArchivoOrigin IN VARCHAR2)
    IS
         SELECT REPLACE(APD.VALOR2, '(nombre_archivo_abu)', Cv_NombreArchivoOrigin) FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
         INNER JOIN DB_GENERAL.ADMI_PARAMETRO_DET APD ON APC.ID_PARAMETRO=PARAMETRO_ID
         WHERE APC.nombre_parametro=Cv_NombreParamCab AND APD.VALOR1=Cv_DescripcionDet AND APD.ESTADO='Activo' AND APD.EMPRESA_COD=Lv_EmpresaCod;   
         Lv_ObsTarea                   VARCHAR2(10000); 

    CURSOR C_GetParametroDescripcion(Cv_EmpresaCod  IN VARCHAR2,
                                     Cv_NombreParamCab IN VARCHAR2,
                                     Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.ESTADO           = 'Activo'
        AND APD.ESTADO           = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.DESCRIPCION      = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod;  

          Lr_Parametro           C_GetParametroDescripcion%ROWTYPE;
          Lr_ParametrosWs        C_GetParametroDescripcion%ROWTYPE;
          Lr_ValorEncriptado            RAW(30000);
          Lv_Estado                     VARCHAR2(10);
          Lc_Json                       CLOB;
          Lc_Respuesta                  CLOB;
          Le_Exception                  EXCEPTION;
          Ln_OrigenTarea                DB_SOPORTE.ADMI_FORMA_CONTACTO.ID_FORMA_CONTACTO%TYPE;
          Lv_Error                      VARCHAR2(32000);
          Lv_Valor                      VARCHAR2(10):= NULL;
          Le_MyException                EXCEPTION;


  BEGIN

    APEX_JSON.PARSE(Pc_ParametroFormPago);
    Lv_ResultadoContrato     :=  apex_json.get_varchar2('strResultadoContrato');
    Lv_NombreArchivoOrigin   :=  apex_json.get_varchar2('strNombreArchivoOrigin');
    Ln_IdDatosPago           :=  apex_json.get_varchar2('intIdDatosPago');
    Lv_NumNuevo              :=  apex_json.get_varchar2('strNumeroNuevo');
    Lv_FechaTarjeta          :=  apex_json.get_varchar2('strFechaTarjeta');
    Lv_EmpresaCod            :=  apex_json.get_varchar2('strEmpresaCod');

    OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','SECRET_KEY_ENCRYPT_DECRYPT');
    FETCH C_GetParametroValor INTO Lv_SecretKey;
    CLOSE C_GetParametroValor;
	
    -- 
    Pv_MsnError  := 'No se pudo actualizar';
     IF TRIM(Lv_SecretKey.VALOR2) IS NOT NULL THEN

          OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','USUARIO_ABU'); 
          FETCH C_GetParametroValor INTO Lr_Usuario;
          CLOSE C_GetParametroValor;

          OPEN  C_GetParametroDescripcion(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','MOTIVO_ACTUALIZACION_ABU'); 
          FETCH C_GetParametroDescripcion INTO Lr_Parametro;
          CLOSE C_GetParametroDescripcion;

          DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR(Lv_NumNuevo,Lv_SecretKey.VALOR2, Lr_ValorEncriptado);
          OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','FECHA_CADUCIDAD_NUEVA');
          FETCH C_GetParametroValor INTO Lr_FechaFormato;
          CLOSE C_GetParametroValor;


          IF Lr_ValorEncriptado IS NOT NULL AND Lr_FechaFormato.VALOR2 IS NOT NULL THEN  
              INSERT INTO DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST 
              (
                ID_DATOS_PAGO,  
                CONTRATO_ID,
                BANCO_TIPO_CUENTA_ID,
                NUMERO_CTA_TARJETA,          
                NUMERO_DEBITO_BANCO,         
                CODIGO_VERIFICACION,
                TITULAR_CUENTA,
                FE_CREACION,
                USR_CREACION,
                ESTADO,
                TIPO_CUENTA_ID,
                IP_CREACION,
                ANIO_VENCIMIENTO,
                MES_VENCIMIENTO,
                CEDULA_TITULAR,
                FORMA_PAGO,
                FORMA_PAGO_ACTUAL_ID,
                OBSERVACION,
                NOMBRE_ARCHIVO_ABU

              )
              VALUES 
              ( 
                Pr_InfoContratoFormaPagoHist.ID_DATOS_PAGO,
                Pr_InfoContratoFormaPagoHist.CONTRATO_ID,
                Pr_InfoContratoFormaPagoHist.BANCO_TIPO_CUENTA_ID,
                Pr_InfoContratoFormaPagoHist.NUMERO_CTA_TARJETA,
                Pr_InfoContratoFormaPagoHist.NUMERO_DEBITO_BANCO,
                Pr_InfoContratoFormaPagoHist.CODIGO_VERIFICACION,
                Pr_InfoContratoFormaPagoHist.TITULAR_CUENTA,
                Pr_InfoContratoFormaPagoHist.FE_CREACION,
                Lr_Usuario.VALOR2,
                'Activo',
                Pr_InfoContratoFormaPagoHist.TIPO_CUENTA_ID,
                Pv_IpCreacion,
                Pr_InfoContratoFormaPagoHist.ANIO_VENCIMIENTO,
                Pr_InfoContratoFormaPagoHist.MES_VENCIMIENTO,
                Pr_InfoContratoFormaPagoHist.CEDULA_TITULAR,
                (SELECT IC.FORMA_PAGO_ID 
                FROM DB_COMERCIAL.INFO_CONTRATO IC 
                WHERE IC.ID_CONTRATO=Lv_ResultadoContrato),
                (SELECT AFP.ID_FORMA_PAGO FROM DB_GENERAL.ADMI_FORMA_PAGO AFP 
                WHERE TRIM(AFP.CODIGO_FORMA_PAGO)= 'DEB'),
                Lr_Parametro.VALOR1,
                Lv_NombreArchivoOrigin
              );

                UPDATE DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO SET 
                NUMERO_CTA_TARJETA  = Lr_ValorEncriptado,  
                ANIO_VENCIMIENTO    = TO_CHAR( TO_DATE(Lv_FechaTarjeta,Lr_FechaFormato.VALOR2),'YYYY'),
                MES_VENCIMIENTO     = TO_CHAR( TO_DATE(Lv_FechaTarjeta,Lr_FechaFormato.VALOR2),'MM')
                WHERE 
                ID_DATOS_PAGO       = Ln_IdDatosPago;

                INSERT INTO DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO 
                  (
                    ID_PERSONA_EMPRESA_ROL_HISTO, 
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    ESTADO,
                    PERSONA_EMPRESA_ROL_ID,
                    OBSERVACION

                  )
                  VALUES 
                  ( 
                    Pr_InfoPersonaEmpresaRolHist.ID_PERSONA_EMPRESA_ROL_HISTO,
                    Pr_InfoPersonaEmpresaRolHist.USR_CREACION,
                    Pr_InfoPersonaEmpresaRolHist.FE_CREACION,
                    Pr_InfoPersonaEmpresaRolHist.IP_CREACION,
                    'Activo',
                    Pr_InfoPersonaEmpresaRolHist.PERSONA_EMPRESA_ROL_ID,
                    Lr_Parametro.VALOR1

                  );

                  OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','NOMBRE_TAREA'); 
                  FETCH C_GetParametroValor INTO Lr_NombreTarea;
                  CLOSE C_GetParametroValor;

                  OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','PROCESO'); 
                  FETCH C_GetParametroValor INTO Lr_NombreProceso;
                  CLOSE C_GetParametroValor;

                  OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','ORIGEN_TAREA'); 
                  FETCH C_GetParametroValor INTO Lr_OrgTareaPar;
                  CLOSE C_GetParametroValor;

                  OPEN  C_GetFormaContacto(Lr_OrgTareaPar.VALOR3); 
                  FETCH C_GetFormaContacto INTO Ln_OrigenTarea;
                  CLOSE C_GetFormaContacto;

                  OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','CLASE_TAREA'); 
                  FETCH C_GetParametroValor INTO Lr_ClaseTarea;
                  CLOSE C_GetParametroValor;

                  OPEN  C_GetInfoPersonaEmp(Lv_EmpresaCod,Pv_UsrSesion); 
                  FETCH C_GetInfoPersonaEmp INTO Lr_InfoPersonaEmp;
                  CLOSE C_GetInfoPersonaEmp;

                  OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','GENERA_TAREA'); 
                  FETCH C_GetParametroValor INTO Lr_GeneraTarea;
                  CLOSE C_GetParametroValor;

                  OPEN  C_GetObservacion(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','OBSERVACION_TAREA',Lv_NombreArchivoOrigin ); 
                  FETCH C_GetObservacion INTO Lv_ObsTarea;
                  CLOSE C_GetObservacion;

                  OPEN  C_GetParametroDescripcion(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','PARAMETROS_WEBSERVICES_TAREA'); 
                  FETCH C_GetParametroDescripcion INTO Lr_ParametrosWs;
                  CLOSE C_GetParametroDescripcion;

                  IF C_InfoPunto%ISOPEN THEN
                  --
                      CLOSE C_InfoPunto;
                  --
                    END IF; 
                 OPEN C_InfoPunto; 
                --

                  FETCH C_InfoPunto BULK COLLECT   INTO Le_InfoPunto LIMIT Li_Limit;
                  Li_Cont := Le_InfoPunto.FIRST;
                  WHILE (Li_Cont IS NOT NULL) 
                  --
                  LOOP
                  --
                  Lc_Json := '';
                  APEX_JSON.INITIALIZE_CLOB_OUTPUT;
                  APEX_JSON.OPEN_OBJECT();

                  APEX_JSON.WRITE('op', Lr_ParametrosWs.Valor2); 
                  APEX_JSON.OPEN_OBJECT('data');
                  APEX_JSON.WRITE('objInfoCaso', Lv_Valor); 
                  APEX_JSON.WRITE('objInfoDetalleHipotesis', Lv_Valor);
                  APEX_JSON.WRITE('intIdPersonaEmpresaRol', Lr_InfoPersonaEmp.ID_PERSONA_ROL);
                  APEX_JSON.WRITE('intIdCuadrilla', Lv_Valor);
                  APEX_JSON.WRITE('intIdEmpresa', Lv_EmpresaCod);
                  APEX_JSON.WRITE('strPrefijoEmpresa', Le_InfoPunto(Li_Cont).PREFIJO);
                  APEX_JSON.WRITE('strNombreTarea', Lr_NombreTarea.VALOR2);
                  APEX_JSON.WRITE('strNombreProceso', Lr_NombreProceso.VALOR2);
                  APEX_JSON.WRITE('strUserCreacion',Pv_UsrSesion );
                  APEX_JSON.WRITE('strAplicacion', Lv_Valor);
                  APEX_JSON.WRITE('strIpCreacion', Pv_IpCreacion);
                  APEX_JSON.WRITE('intFormaContacto', Ln_OrigenTarea);
                  APEX_JSON.WRITE('strMotivoTarea', Lv_Valor);
                  APEX_JSON.WRITE('strObservacionTarea', Lv_ObsTarea);
                  APEX_JSON.WRITE('strUsuarioAsigna', Pv_UsrSesion);
                  APEX_JSON.WRITE('strTipoAsignacion', 'empleado');
                  APEX_JSON.WRITE('arrayTo', Lv_Valor);
                  APEX_JSON.WRITE('strTipoTarea', 'T');
                  APEX_JSON.WRITE('strTareaRapida', Lr_GeneraTarea.VALOR3);
                  APEX_JSON.WRITE('strFechaHoraSolicitada', TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI'));
                  APEX_JSON.WRITE('intPuntoId',Le_InfoPunto(Li_Cont).ID_PUNTO); 
                  APEX_JSON.WRITE('strIniciarTarea', Lr_GeneraTarea.VALOR3); 
                  APEX_JSON.WRITE('strTipoReprograma', Lv_Valor);
                  APEX_JSON.WRITE('intTiempo', Lv_Valor);
                  APEX_JSON.WRITE('intIdDetalle', Lv_Valor);
                  APEX_JSON.WRITE('intIdComunicacion', Lv_Valor);
                  APEX_JSON.WRITE('intIdDocumento', Lv_Valor);
                  APEX_JSON.WRITE('strDescripcionClase', Lr_ClaseTarea.VALOR2);
                  APEX_JSON.WRITE('intIdDocuComunica', Lv_Valor);
                  APEX_JSON.WRITE('intIdDetalleAsig', Lv_Valor);
                  APEX_JSON.WRITE('intIdDetalleHisto',Lv_Valor);
                  APEX_JSON.WRITE('intIdTareaSeguimiento', Lv_Valor);
                  APEX_JSON.WRITE('intSolicitudId', Lv_Valor);
                  APEX_JSON.WRITE('intIdDepartamentoOrigen', Lr_InfoPersonaEmp.DEPARTAMENTO_ID);
                  APEX_JSON.WRITE('arrayDatosCaracteriticas', Lv_Valor); 
                  APEX_JSON.WRITE('arrayElementosAfectados', Lv_Valor);
                  APEX_JSON.CLOSE_OBJECT;
                  APEX_JSON.CLOSE_OBJECT;
                  Lc_Json := APEX_JSON.GET_CLOB_OUTPUT;
                  APEX_JSON.FREE_OUTPUT;

                 DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(Pv_Url             => Lr_ParametrosWs.Valor1,
                                                            Pcl_Mensaje        => Lc_Json,
                                                            Pv_Application     => Lr_ParametrosWs.Valor3,
                                                            Pv_Charset         => Lr_ParametrosWs.Valor4,
                                                            Pv_UrlFileDigital  => null,
                                                            Pv_PassFileDigital => null,
                                                            Pcl_Respuesta      => Lc_Respuesta,
                                                            Pv_Error           => Lv_Error);

                   IF Lv_Error IS NOT NULL THEN
                   --
                      ROLLBACK;
                     RAISE Le_MyException;
                   END IF;

                  COMMIT; 
                 
                 

                  OPEN  C_GetParametroValor(Lv_EmpresaCod,'PARAM_TARJETAS_ABU','COD_FP_ACTUALIZADA');
                  FETCH C_GetParametroValor INTO Lv_Resultado;
                  CLOSE C_GetParametroValor;
                   
                  
                  IF Lv_Resultado.VALOR2 IS NOT NULL THEN
                  	Pv_Resultado := Lv_Resultado.VALOR2;
                    Pv_EstadoFinalizacion := 'TRUE';
                  END IF;
                  

                  
                  Li_Cont:= Le_InfoPunto.NEXT(Li_Cont);
                  END LOOP;

                  CLOSE C_InfoPunto;


          END IF;
      END IF;

   --

  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsnError := SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_INFO_CONTRATO_FORMA_PAGO', 
                                         Pv_MsnError || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Pv_IpCreacion)
                                        ); 
    --
  END P_INFO_CONTRATO_FORMA_PAGO;  


  --
  --
  PROCEDURE P_PROCESA_ACTUALIZA_ABU(
                      Pv_UrlFile	    	   IN  VARCHAR2,
                      Pv_DocumentoId  	   IN  INTEGER,
                      Pv_EmpresaCod   	   IN  INTEGER,
                      Pv_UsrSesion    	   IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                      Pv_IpCreacion   	   IN  VARCHAR2,
                      Pv_CorreoElectronico IN  VARCHAR2,
                      Pv_Status       OUT VARCHAR2,
                      Pv_Mensaje      OUT VARCHAR2,
                      Lv_MsjResultado OUT VARCHAR2)AS

    Lv_Url                              VARCHAR2(800);
    Lv_NombreParametroCab               VARCHAR2(50) := 'PARAM_TARJETAS_ABU';
    LBL_EXCEL                           BLOB;
    LRW_raw 				                    RAW(32767);
    Luh_http_request                    UTL_HTTP.req;
    Luh_http_response                   UTL_HTTP.resp;
    Lfile_Archivo                       UTL_FILE.FILE_TYPE;
   	Lv_NumTarjetaAntiguoEncriptado      RAW(30000);
    Lv_NumTarjetaNuevoEncriptado        RAW(30000);
    Lv_NumTarjetaNuevo	      	        VARCHAR2(30);
   	Lv_NumTarjetaAntiguo	  	          VARCHAR2(30);
    Pv_DatosTarjeta 	  		            DB_COMERCIAL.DATOS_TARJETA_TYPE;
    Lv_Directorio                       VARCHAR2(50)   := 'DIR_REPGERENCIA';
    Lv_NombreArchivo                    VARCHAR2(150);
    Lv_Delimitador                      VARCHAR2(1)    := ';'; 
    LE_ERROR                 	          EXCEPTION;        
    Lv_DirectorioEnBase			            VARCHAR2(50) := '/backup/repgerencia/';
    Lv_Gzip                             VARCHAR2(10000); 
    Lc_GetAliasPlantilla     	          DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lv_CodigoPlantilla        	        DB_COMUNICACION.ADMI_PLANTILLA.CODIGO%TYPE:= 'ACT_TAR_ABU';
    Lv_Cuerpo                	          VARCHAR2(9999); 
    Lv_Destinatario          	          VARCHAR2(500);
    Lv_FechaReporte          	          VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lv_NombreArchivoZip      	          VARCHAR2(250);
    Lv_Asunto                	          VARCHAR2(300);
    Lv_Remitente             	          VARCHAR2(100);  
    Lv_IpCreacion            	          VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    LV_ParamDirectorioTarjetaABU        VARCHAR2(50) := 'TarjetasAbu';
   	Lv_CodigoAppTarjetaABU              VARCHAR2(10);
    Lv_CodigoPathTarjetaABU             VARCHAR2(10);
    Lv_RespuestaGuardarArchivo          VARCHAR2(4000);
    Lv_ResultadoValidacion 		          VARCHAR2(1000);
    Lv_Resultado           		          BOOLEAN;
    Lv_ResultadoContrato  	            VARCHAR2(1000);
    Lv_EstadoValidacion    		          VARCHAR2(1000);
    Lr_InfoContratoFormaPagoHist        DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO_HIST%ROWTYPE;
    Lr_InfoPersonaEmpresaRolHist        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_HISTO%ROWTYPE;
    Ln_IdDatosPago                      NUMBER;
    Lv_FechaFormato                     VARCHAR2(1000);
    Lv_RespValidacionNumNue             VARCHAR2(1000);
    Lv_MsnError                         VARCHAR2(2000);
    Lex_Exception                       EXCEPTION;
    Ln_PersonaEmpresaRolId              NUMBER;
    Lv_NombreArchivoOrigin              VARCHAR2(2000);
    Lv_NumNuevo    			                VARCHAR2(1000);
    Lv_FechaTarjeta                     VARCHAR2(1000);
    Lv_FechaColum                       VARCHAR2(1000) :='Fecha';
    Lv_CodigoComercioColum              VARCHAR2(1000) :='Codigo Comercio';
    Lv_IdenClienteColum                 VARCHAR2(1000) :='Identif. cliente PR';
    Lv_NumTarjetaAntColum               VARCHAR2(1000) :='Numero Tarjeta Antiguo';
    Lv_NumTarjetaNuevoColum             VARCHAR2(1000) :='Numero Tarjeta Nuevo';
    Lv_FechaProcesoColum                VARCHAR2(1000) :='Fecha Proceso';
    Lv_FechaCaduAntiguoColum            VARCHAR2(1000) :='Fecha Caducidad Antiguo';
    Lv_FechaCaduNuevaColum              VARCHAR2(1000) :='Fecha Caducidad Nueva';
    Lv_MotivoColum                      VARCHAR2(1000) :='Motivo';
    Lv_DescMotivoColum                  VARCHAR2(1000) :='Desc.Motivo'; 
    Lc_ResultadoValidacion              CLOB;
    Lc_ParametroFormPago                CLOB;
    Lv_EstadoFinalizacion				        VARCHAR2(100);
    Lv_EstadoAct						            VARCHAR2(100);

    l_count     					              PLS_INTEGER;
  	j 		  						                apex_json.t_values;


  CURSOR C_GetDatosTarjeta(Cv_NumeroCuentaTarj IN VARCHAR2)
   	IS 
   		SELECT ICFP.TIPO_CUENTA_ID, ICFP.BANCO_TIPO_CUENTA_ID, ICFP.NUMERO_CTA_TARJETA, ICFP.CODIGO_VERIFICACION 
		  FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP
      WHERE ICFP.NUMERO_CTA_TARJETA  = Cv_NumeroCuentaTarj; 

  CURSOR C_GetParametro(Cv_EmpresaCod 	   IN VARCHAR2,
   						 Cv_NombreParamCab IN VARCHAR2,
   						 Cv_DescripcionDet IN VARCHAR2)
    IS
        SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
          DB_GENERAL.ADMI_PARAMETRO_DET APD
        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
        AND APC.ESTADO           = 'Activo'
        AND APD.ESTADO           = 'Activo'
        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
        AND APD.VALOR1           = Cv_DescripcionDet
        AND APD.EMPRESA_COD      = Cv_EmpresaCod;  


  	CURSOR C_GetParametroNot(Cv_EmpresaCod 	   IN VARCHAR2,
                             Cv_NombreParamCab IN VARCHAR2,
                             Cv_DescripcionDet IN VARCHAR2)
    	IS
	        SELECT APD.ID_PARAMETRO_DET, APD.VALOR1, APD.VALOR2, APD.VALOR3, APD.VALOR4
	        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
	          DB_GENERAL.ADMI_PARAMETRO_DET APD
	        WHERE APC.ID_PARAMETRO   = APD.PARAMETRO_ID
	        AND APC.ESTADO           = 'Activo'
	        AND APD.ESTADO           = 'Activo'
	        AND APC.NOMBRE_PARAMETRO = Cv_NombreParamCab
	        AND APD.DESCRIPCION      = Cv_DescripcionDet
	        AND APD.EMPRESA_COD      = Cv_EmpresaCod;

	 CURSOR C_GetPlantilla(Cv_Plantilla IN VARCHAR2)
	 	IS 
	 	     SELECT ap.PLANTILLA
  			 FROM  DB_COMUNICACION.ADMI_PLANTILLA ap
  			 WHERE ap.CODIGO = Cv_Plantilla;



     Lr_EstadoArchivo       C_GetParametroNot%ROWTYPE;
     Lr_Parametro           C_GetParametro%ROWTYPE;
     Lr_Key		              C_GetParametro%ROWTYPE;
     Lr_Tarjeta			        C_GetDatosTarjeta%ROWTYPE;
     Lr_DatosCorreo         C_GetParametroNot%ROWTYPE;
     Lr_Plantilla			      C_GetPlantilla%ROWTYPE;

    CURSOR Lc_GetConfigNfsTarjetaABU
		IS 
			SELECT TO_CHAR(agd.CODIGO_APP) AS CODIGO_APP, TO_CHAR(agd.CODIGO_PATH) AS CODIGO_PATH, agd.PAIS, agd.EMPRESA,
				   agd.APLICACION, agd.MODULO, agd.SUBMODULO, apd.VALOR1
			FROM DB_GENERAL.ADMI_GESTION_DIRECTORIOS agd, DB_GENERAL.ADMI_PARAMETRO_DET apd
			WHERE agd.SUBMODULO = apd.VALOR3
			AND apd.VALOR1 = LV_ParamDirectorioTarjetaABU;

      Lr_RegGetConfigNfsTarjetaABU  Lc_GetConfigNfsTarjetaABU%ROWTYPE;

    BEGIN

	  OPEN  C_GetPlantilla(Lv_CodigoPlantilla);
	  FETCH C_GetPlantilla INTO Lr_Plantilla;
	  CLOSE C_GetPlantilla;

	  OPEN  C_GetParametroNot(Pv_EmpresaCod,Lv_NombreParametroCab,'ESTADO_ARCHIVO');
    FETCH C_GetParametroNot INTO Lr_EstadoArchivo;
    CLOSE C_GetParametroNot;


    OPEN  C_GetParametro(Pv_EmpresaCod,Lv_NombreParametroCab,'FILE-HTTP-HOST');
    FETCH C_GetParametro INTO Lr_Parametro;
    CLOSE C_GetParametro;
    --
   	OPEN  C_GetParametroNot(Pv_EmpresaCod,Lv_NombreParametroCab,Lv_CodigoPlantilla);
    FETCH C_GetParametroNot INTO Lr_DatosCorreo;
    CLOSE C_GetParametroNot;
    --
   	OPEN  C_GetParametro(Pv_EmpresaCod,Lv_NombreParametroCab,'SECRET_KEY_ENCRYPT_DECRYPT');
    FETCH C_GetParametro INTO Lr_Key;
    CLOSE C_GetParametro;

    Lv_Url:= REPLACE(Pv_UrlFile, 'https', 'http');
    DBMS_LOB.createtemporary(LBL_EXCEL, FALSE);

    Luh_http_request  := UTL_HTTP.begin_request(Lv_Url);
    Luh_http_response := UTL_HTTP.get_response(Luh_http_request, TRUE);

    BEGIN
      --
      LOOP
      --
        UTL_HTTP.read_raw(Luh_http_response, LRW_raw, 32767);
        DBMS_LOB.writeappend (LBL_EXCEL, UTL_RAW.length(LRW_raw), LRW_raw);
        --
      END LOOP;

    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        DBMS_OUTPUT.PUT_LINE(' -ERROR- ' || SQLERRM);
        UTL_HTTP.end_response(Luh_http_response);
    END;

    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB ipmc 
	  SET ipmc.ESTADO = Lr_EstadoArchivo.VALOR1
	  WHERE ipmc.ID_PROCESO_MASIVO_CAB = Pv_DocumentoId;

    DBMS_OUTPUT.PUT_LINE('Lectura P');
    Lv_Cuerpo            := REPLACE(Lr_Plantilla.PLANTILLA, 'strUsuario', Pv_UsrSesion);
    Lv_Destinatario      := NVL(Pv_CorreoElectronico,'notificaciones_telcos@telconet.ec')||',';
    Lv_Destinatario      := REPLACE(Lv_Destinatario,';',','); 
    Lv_NombreArchivo     := REPLACE(REGEXP_SUBSTR(Lv_Url, '([^/]+)(\Z)'), '.xlsx', '')||'_'||Lv_FechaReporte||'_procesado.csv';
    Lv_Gzip              := 'gzip '||Lv_DirectorioEnBase||Lv_NombreArchivo;
    Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
    Lv_Asunto            := NVL(Lr_DatosCorreo.VALOR1,'');
    Lv_Remitente         := NVL(Lr_DatosCorreo.VALOR2,'');
    Lfile_Archivo  := UTL_FILE.FOPEN(Lv_Directorio, Lv_NombreArchivo, 'w', 3000);

    UTL_FILE.PUT_LINE(Lfile_Archivo, 'FECHA'||Lv_Delimitador
   			||'CODIGO COMERCIO'||Lv_Delimitador
   			||'IDENTIF. CLIENTE PR'||Lv_Delimitador
   			||'ANTIGUO'||Lv_Delimitador 
   			||'NUEVO'||Lv_Delimitador 
   			||'FECHA PROCESO'||Lv_Delimitador 
   			||'ANTIGUO'||Lv_Delimitador
   			||'NUEVA'||Lv_Delimitador 
   			||'MOTIVO'||Lv_Delimitador 
   			||'DESC. MOTIVO'||Lv_Delimitador 
   			||'FECHA PROCESO'||Lv_Delimitador 
   			||'CODIGO ERROR'||Lv_Delimitador 
   			);

   		FOR info_PMA_Excel in ( SELECT Lv_FechaColum,
                                       Lv_CodigoComercioColum,
                                       Lv_IdenClienteColum,
                                       Lv_NumTarjetaAntColum,
                                       Lv_NumTarjetaNuevoColum,
                                       Lv_FechaProcesoColum,
                                       Lv_FechaCaduAntiguoColum,
                                       Lv_FechaCaduNuevaColum,
                                       Lv_MotivoColum,
                                       Lv_DescMotivoColum FROM  (SELECT row_nr, col_nr,
                                  CASE cell_type
                                    WHEN 'S'
                                    THEN string_val
                                    WHEN 'N'
                                    THEN to_char(number_val)
                                    WHEN 'D'
                                    THEN to_char(date_val,'DD-MM-YYYY')
                                    ELSE ''
                                  END cell_val 
                                FROM
                                  (
                                    SELECT
                                      *	
                                    FROM
                                      TABLE( DB_FINANCIERO.as_read_xlsx.read(LBL_EXCEL))
                                  )
                             ) pivot ( MAX(cell_val) 
                                       FOR col_nr IN (1 AS Lv_FechaColum,
                                                      2 AS Lv_CodigoComercioColum,
                                                      3 AS Lv_IdenClienteColum,
                                                      4 AS Lv_NumTarjetaAntColum,
                                                      5 AS Lv_NumTarjetaNuevoColum,
                                                      6 AS Lv_FechaProcesoColum,
                                                      7 AS Lv_FechaCaduAntiguoColum,
                                                      8 AS Lv_FechaCaduNuevaColum,
                                                      9 AS Lv_MotivoColum,
                                                      10 AS Lv_DescMotivoColum))WHERE row_nr >1)
    LOOP
    --
    BEGIN
    --
Lv_EstadoAct :='';
Lv_EstadoFinalizacion := '';
	  Lv_EstadoValidacion 	  :='FALSE';
      Lv_ResultadoValidacion  :='';
      Lv_RespValidacionNumNue :='';
      Lc_ResultadoValidacion  :='';
      Lv_NumTarjetaAntiguoEncriptado :='';
      Lv_NumTarjetaNuevoEncriptado :=''; 

      Lv_Resultado   := DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDA_CODIGO_COMERCIO(info_PMA_Excel.Lv_CodigoComercioColum);

	      IF Lv_Resultado=TRUE THEN
        --
	      Lc_ResultadoValidacion := DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDAR_CLIENTE(info_PMA_Excel.Lv_IdenClienteColum, Pv_EmpresaCod);
        APEX_JSON.PARSE(j, Lc_ResultadoValidacion);
        APEX_JSON.PARSE(Lc_ResultadoValidacion);
        Lv_EstadoValidacion    :=  apex_json.get_varchar2('strEstado');
        Lv_ResultadoValidacion :=  apex_json.get_varchar2('strMensaje');
        --
	      END IF;

        l_count := APEX_JSON.GET_COUNT(p_path => 'arrContratos', p_values=>j);

		Ln_PersonaEmpresaRolId := '';
	    
        FOR intColeccion IN 1 ..l_count LOOP
			

          Lv_ResultadoContrato   := APEX_JSON.get_number(p_path => 'arrContratos[%d].strCodigoContrato', 
                                          p0 => intColeccion, p_values=>j);
          Ln_PersonaEmpresaRolId := APEX_JSON.get_number(p_path => 'arrContratos[%d].intPersonaEmpresaRolId', 
                                          p0 => intColeccion, p_values=>j);


	      IF TRIM(Lv_EstadoValidacion)='TRUE' THEN
        --
          Lc_ResultadoValidacion := '';  
	        Lc_ResultadoValidacion :=  DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDAR_NUMERO_ANTIGUO(info_PMA_Excel.Lv_NumTarjetaAntColum,Lv_ResultadoContrato,Pv_EmpresaCod);
          APEX_JSON.PARSE(Lc_ResultadoValidacion);
          Lv_EstadoValidacion    :=  apex_json.get_varchar2('strEstado');
          Ln_IdDatosPago   :=  apex_json.get_varchar2('intIdDatosPago');
          Lv_ResultadoValidacion :=  apex_json.get_varchar2('strMensaje');
         -- 
        END IF;

	      IF TRIM(Lv_EstadoValidacion)='TRUE' THEN 
        --
        Lc_ResultadoValidacion := '';  
	      Lc_ResultadoValidacion :=  DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDAR_FECHA_CADUCIDAD(info_PMA_Excel.Lv_FechaCaduNuevaColum, Pv_EmpresaCod);
        APEX_JSON.PARSE(Lc_ResultadoValidacion);
        Lv_EstadoValidacion     :=  apex_json.get_varchar2('strEstado');
        Lv_FechaTarjeta         :=  apex_json.get_varchar2('strFecha');
        Lv_ResultadoValidacion  :=  apex_json.get_varchar2('strMensaje');
        --
        END IF;

	      IF TRIM(Lv_EstadoValidacion)='TRUE' THEN 
        --
        Lc_ResultadoValidacion := ''; 
	      Lc_ResultadoValidacion :=  DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.F_VALIDAR_NUMERO_NUEVO(info_PMA_Excel.Lv_NumTarjetaNuevoColum,Lv_ResultadoContrato,Pv_EmpresaCod);
        APEX_JSON.PARSE(Lc_ResultadoValidacion);
        Lv_EstadoValidacion     :=  apex_json.get_varchar2('strEstado');
        Lv_NumNuevo         :=  apex_json.get_varchar2('strNumeroNuevo');
	      Lv_ResultadoValidacion  :=  apex_json.get_varchar2('strMensaje');
        --
        END IF;
		
        IF TRIM(info_PMA_Excel.Lv_NumTarjetaAntColum) IS NOT NULL THEN 
          --
          Lv_NumTarjetaAntiguo := TRIM(LEADING '0' FROM info_PMA_Excel.Lv_NumTarjetaAntColum);
          Lv_NumTarjetaNuevo   := TRIM(LEADING '0' FROM info_PMA_Excel.Lv_NumTarjetaNuevoColum);
          DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR(Lv_NumTarjetaAntiguo, Lr_Key.VALOR2, Lv_NumTarjetaAntiguoEncriptado);
          IF  TRIM(info_PMA_Excel.Lv_NumTarjetaNuevoColum) IS NOT NULL  THEN
          --
              DB_SEGURIDAD.PAQ_ENCRIPCION.PROC_ENCRIPTAR(Lv_NumTarjetaNuevo, Lr_Key.VALOR2,   Lv_NumTarjetaNuevoEncriptado); 


              OPEN  C_GetDatosTarjeta(Lv_NumTarjetaAntiguoEncriptado);
              --
              FETCH C_GetDatosTarjeta INTO Lr_Tarjeta;
              --
              CLOSE C_GetDatosTarjeta;

              Pv_DatosTarjeta := DB_COMERCIAL.DATOS_TARJETA_TYPE(Lr_Tarjeta.TIPO_CUENTA_ID,
                                      Lr_Tarjeta.BANCO_TIPO_CUENTA_ID,
                                      Lv_NumTarjetaNuevo,
                                      Lr_Tarjeta.CODIGO_VERIFICACION, 
                                      Pv_EmpresaCod);		

              DB_COMERCIAL.CMKG_CONTRATO_TRANSACCION.P_VALIDAR_NUMERO_TARJETA(Pv_DatosTarjeta,
                                            Pv_Mensaje,
                                            Pv_Status,
                                            Lv_MsjResultado);

        --
          END IF;
         
        --
         END IF; 

	       IF TRIM(Lv_EstadoValidacion)='TRUE' AND Lv_Resultado=TRUE AND Lv_MsjResultado IS NULL THEN  
        --
          Lv_ResultadoValidacion := NULL;
          Lr_InfoContratoFormaPagoHist :=NULL;
          Lr_InfoPersonaEmpresaRolHist :=NULL;
          Lr_InfoPersonaEmpresaRolHist.ID_PERSONA_EMPRESA_ROL_HISTO := DB_COMERCIAL.SEQ_INFO_PERSONA_EMPRESA_ROL_H.NEXTVAL; 
          Lr_InfoPersonaEmpresaRolHist.USR_CREACION := Pv_UsrSesion;
          Lr_InfoPersonaEmpresaRolHist.FE_CREACION := TO_CHAR(TO_DATE(sysdate));
          Lr_InfoPersonaEmpresaRolHist.IP_CREACION := Lv_IpCreacion;
          Lr_InfoPersonaEmpresaRolHist.PERSONA_EMPRESA_ROL_ID := Ln_PersonaEmpresaRolId;
          Lr_InfoContratoFormaPagoHist.ID_DATOS_PAGO := DB_COMERCIAL.SEQ_INFO_CONTRATO_FORMA_PAGO_H.NEXTVAL; 
         
         

          SELECT 
          ICFP.CONTRATO_ID, 
          ICFP.BANCO_TIPO_CUENTA_ID,
          ICFP.NUMERO_CTA_TARJETA,
          ICFP.NUMERO_DEBITO_BANCO,
          ICFP.CODIGO_VERIFICACION,
          ICFP.TITULAR_CUENTA,
          TO_CHAR(TO_DATE(sysdate)),
          ICFP.TIPO_CUENTA_ID,
          ICFP.ANIO_VENCIMIENTO,
          ICFP.MES_VENCIMIENTO,
          ICFP.CEDULA_TITULAR 
          INTO
           Lr_InfoContratoFormaPagoHist.CONTRATO_ID,
           Lr_InfoContratoFormaPagoHist.BANCO_TIPO_CUENTA_ID,
           Lr_InfoContratoFormaPagoHist.NUMERO_CTA_TARJETA,
           Lr_InfoContratoFormaPagoHist.NUMERO_DEBITO_BANCO,
           Lr_InfoContratoFormaPagoHist.CODIGO_VERIFICACION,
           Lr_InfoContratoFormaPagoHist.TITULAR_CUENTA,
           Lr_InfoContratoFormaPagoHist.FE_CREACION,
           Lr_InfoContratoFormaPagoHist.TIPO_CUENTA_ID,
           Lr_InfoContratoFormaPagoHist.ANIO_VENCIMIENTO,
           Lr_InfoContratoFormaPagoHist.MES_VENCIMIENTO, 
           Lr_InfoContratoFormaPagoHist.CEDULA_TITULAR
           FROM DB_COMERCIAL.INFO_CONTRATO_FORMA_PAGO ICFP WHERE ICFP.ID_DATOS_PAGO =Ln_IdDatosPago;
       

            Lv_NombreArchivoOrigin     := REPLACE(REGEXP_SUBSTR(Lv_Url, '([^/]+)(\Z)'), '.xlsx', '');

            Lv_NombreArchivoOrigin     := CONCAT(Lv_NombreArchivoOrigin,'.xlsx');

           APEX_JSON.INITIALIZE_CLOB_OUTPUT;
           APEX_JSON.OPEN_OBJECT();
           APEX_JSON.WRITE('strResultadoContrato', Lv_ResultadoContrato);
           APEX_JSON.WRITE('strNombreArchivoOrigin', Lv_NombreArchivoOrigin);
           APEX_JSON.WRITE('intIdDatosPago', Ln_IdDatosPago);
           APEX_JSON.WRITE('strNumeroNuevo', Lv_NumNuevo);
           APEX_JSON.WRITE('strFechaTarjeta', Lv_FechaTarjeta);
           APEX_JSON.WRITE('strEmpresaCod', Pv_EmpresaCod);
           APEX_JSON.CLOSE_OBJECT;
           Lc_ParametroFormPago := APEX_JSON.GET_CLOB_OUTPUT;
           APEX_JSON.FREE_OUTPUT;
        

           DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_INFO_CONTRATO_FORMA_PAGO(
                                                      Lr_InfoContratoFormaPagoHist,
                                                      Lr_InfoPersonaEmpresaRolHist, 
                                                      Lc_ParametroFormPago,
                                                      Ln_PersonaEmpresaRolId,
                                                      Pv_UsrSesion,
                                                      Lv_IpCreacion,
                                                      Lv_MsnError,                                                      
                                                      Lv_EstadoAct,
                                                      Lv_EstadoFinalizacion);

       -- 
       END IF;

      
      IF  Lv_EstadoFinalizacion = 'TRUE' THEN
                	  Lv_ResultadoValidacion := Lv_EstadoAct;
            
                END IF; 
       END LOOP;
	  

        UTL_FILE.PUT_LINE(Lfile_Archivo, NVL(info_PMA_Excel.Lv_FechaColum, '')||Lv_Delimitador
            ||NVL(info_PMA_Excel.Lv_CodigoComercioColum, '')||Lv_Delimitador
            ||NVL(info_PMA_Excel.Lv_IdenClienteColum, '')||Lv_Delimitador
            ||NVL(Lv_NumTarjetaAntiguoEncriptado, '')||Lv_Delimitador
            ||NVL(Lv_NumTarjetaNuevoEncriptado, '')||Lv_Delimitador
            ||NVL(info_PMA_Excel.Lv_FechaProcesoColum, '')||Lv_Delimitador
            ||NVL(info_PMA_Excel.Lv_FechaCaduAntiguoColum, '')||Lv_Delimitador
            ||NVL(info_PMA_Excel.Lv_FechaCaduNuevaColum, '')||Lv_Delimitador
            ||NVL(info_PMA_Excel.Lv_MotivoColum, '')||Lv_Delimitador	
            ||NVL(info_PMA_Excel.Lv_DescMotivoColum, '')||Lv_Delimitador
            ||NVL(TO_CHAR(SYSDATE, 'dd-mm-yyyy'), '')||Lv_Delimitador
            ||NVL(Lv_ResultadoValidacion, Lv_MsjResultado)||Lv_Delimitador
            );
         


	 EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        DBMS_OUTPUT.PUT_LINE(' -ERROR- ' || SQLERRM);


    	END;
  	END LOOP;

   		DBMS_LOB.freetemporary(LBL_EXCEL);
   		UTL_FILE.FCLOSE(Lfile_Archivo);
   		DBMS_OUTPUT.PUT_LINE( NAF47_TNET.JAVARUNCOMMAND (Lv_Gzip) );

      DB_GENERAL.GNRLPCK_UTIL.send_email_attach(
   											Lv_Remitente, 
                                            Lv_Destinatario,       
                                            Lv_Asunto, 
                                            Lv_Cuerpo, 
                                            Lv_Directorio,
                                            Lv_NombreArchivoZip);


     OPEN Lc_GetConfigNfsTarjetaABU;
     FETCH Lc_GetConfigNfsTarjetaABU 
     --
     INTO Lr_RegGetConfigNfsTarjetaABU ;
     --
     CLOSE Lc_GetConfigNfsTarjetaABU;

     Lv_CodigoAppTarjetaABU     := Lr_RegGetConfigNfsTarjetaABU.CODIGO_APP;
     Lv_CodigoPathTarjetaABU    := Lr_RegGetConfigNfsTarjetaABU.CODIGO_PATH;

     Lv_RespuestaGuardarArchivo  := DB_GENERAL.GNRLPCK_UTIL.F_GUARDAR_ARCHIVO_NFS(  Lr_Parametro.VALOR2,                             
																					                                          Lv_DirectorioEnBase||Lv_NombreArchivoZip,
                                                                                    Lv_NombreArchivo||'.zip',
                                                                                    NULL,
                                                                                    Lv_CodigoAppTarjetaABU,
                                                                                    Lv_CodigoPathTarjetaABU);

      UTL_FILE.FREMOVE(Lv_Directorio, Lv_NombreArchivoZip);                                  



  	UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB ipmc 
	  SET ipmc.ESTADO = Lr_EstadoArchivo.VALOR3
	  WHERE ipmc.ID_PROCESO_MASIVO_CAB = Pv_DocumentoId;

    DBMS_OUTPUT.PUT_LINE('Finalizado');
	  Pv_Mensaje   := 'Finalizado ';
    Pv_Status    := 'OK';


EXCEPTION
    WHEN LE_ERROR THEN
      DBMS_LOB.freetemporary(LBL_EXCEL);
      Pv_Status  := 'Error';
      Pv_Mensaje := 'Error';        
      Lv_MsjResultado:= 'procedimiento principal .' ||
                        ' - ' || Lv_MsjResultado;
     DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'DB_FINANCIERO.P_PROCESA_ACTUALIZA_ABU', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'test_ABU',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    WHEN OTHERS THEN
      DBMS_LOB.freetemporary(LBL_EXCEL);
      Pv_Status  := 'Error';
      Pv_Mensaje := 'Error';  
      Lv_MsjResultado:= 'procedimiento principal' ||
                        ' - ' || Lv_MsjResultado;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'DB_FINANCIERO.P_PROCESA_ACTUALIZA_ABU', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'test_ABU',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));       

  END P_PROCESA_ACTUALIZA_ABU;
      PROCEDURE P_VALIDAR_TARJETA_ABU(
                                    Pn_TipoCuentaId        IN  INTEGER,
                                    Pn_BancoTipoCuentaId   IN  INTEGER,
                                    Pv_NumeroCuentaTarj    IN  VARCHAR2,
                                    Pv_CodigoVerificacion  IN VARCHAR2,
                                    Pn_CodigoEmpresa       IN INTEGER,
                                    Pv_IpCreacion		       IN VARCHAR2,
                                    Pv_MsjResultado 		   OUT  VARCHAR2
                                           
		   
  )
  AS 
  
  		   Pv_DatosTarjeta		DB_COMERCIAL.DATOS_TARJETA_TYPE;
  		   Pv_Mensaje 			  VARCHAR2(200);
		     Pv_Status 		      VARCHAR2(200);
  		   
        
  
  BEGIN
   	Pv_DatosTarjeta := DB_COMERCIAL.DATOS_TARJETA_TYPE(Pn_TipoCuentaId,
					                                   Pn_BancoTipoCuentaId,
					                                   Pv_NumeroCuentaTarj,
					                                   Pv_CodigoVerificacion, 
					                                   Pn_CodigoEmpresa);		

     DB_COMERCIAL.CMKG_CONTRATO_TRANSACCION.P_VALIDAR_NUMERO_TARJETA(Pv_DatosTarjeta,
						                                             Pv_Mensaje,
						                                             Pv_Status,
						                                             Pv_MsjResultado);
                                           
   
 
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'DB_FINANCIERO.FNCK_ACTUALIZA_TARJETAS_ABU.P_VALIDAR_TARJETA_ABU', 
                                        Pv_MsjResultado|| ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_abu',
                                         SYSDATE,
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Pv_IpCreacion)
                                        ); 
  
  END P_VALIDAR_TARJETA_ABU;
END FNCK_ACTUALIZA_TARJETAS_ABU;
/
