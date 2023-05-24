CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES AS 

  /**
  * Documentaci�n para PROCEDURE 'P_CREA_PM_PROMOCIONES'.
  *
  * Procedure que genera un Proceso Masivo que puede ser por Inactivaci�n, Dado de Baja o Clonaci�n de promociones, en base a par�metros enviados.
  * El m�todo incluir� en el PMA todas las promociones que hayan sido previamente escogidas o  marcadas en el proceso,
  * guardando el motivo y la observaci�n del proceso sea esta por Inactivaci�n, Clonaci�n o Dada de baja.
  *
  * Costo del Query C_GetIdGrupoPromocion: 7
  * Costo del Query C_GetIdVencePromocion: 5
  * Costo del Query C_ObtieneMotivoSolicitud: 2
  * PARAMETROS:
  * @Param Pv_IdsGrupoPromocion    IN  CLOB ( Ids de los grupos de Promociones ADMI_GRUPO_PROMOCION )
  * @Param Pn_IdMotivo             IN  DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE ( Id del Motivo del Proceso del PMA )
  * @Param Pv_Observacion          IN  VARCHAR2 ( Observaci�n del Proceso del PMA )
  * @Param Pv_UsrCreacion          IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE  (Usuario en sesi�n)
  * @Param Pv_CodEmpresa           IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE (C�digo de Empresa en sesi�n)
  * @Param Pv_IpCreacion           IN  VARCHAR2 (Ip de Creaci�n)
  * @Param Pv_TipoPma              IN  VARCHAR2 (Tipo de Proceso Masivo Inactivaci�n, Clonaci�n o Dada de baja.)      
  * @Param Pv_MsjResultado         OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 04-04-2019
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.1  25-10-2019
  * Se agrega validaci�n para que cuando se Inactive por fechas de vigencias se cree el respectivo proceso masivo.
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.2  13-04-2020
  * Se cambia la forma de la validaci�n de fechas en el query C_GetIdVencePromocion.
  */
  PROCEDURE P_CREA_PM_PROMOCIONES(
    Pv_IdsGrupoPromocion        IN OUT  CLOB,  
    Pn_IdMotivo                 IN OUT  DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE,    
    Pv_Observacion              IN  VARCHAR2,
    Pv_UsrCreacion              IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IpCreacion               IN  VARCHAR2,
    Pv_TipoPma                  IN  VARCHAR2,
    Pv_MsjResultado             OUT VARCHAR2  
  ); 
  /**
  * Documentaci�n para PROCEDURE 'P_INSERT_INFO_PROC_MASIVO_CAB'.
  *
  * Procedimiento que Inserta cabecera del Proceso Masivo
  *
  * PARAMETROS:
  * @Param Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE 
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-04-2019
  */
  PROCEDURE P_INSERT_INFO_PROC_MASIVO_CAB(Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
                                          Pv_MsjResultado          OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_PROC_MASIVO_CAB'.
  *
  * Procedimiento que Actualiza cabecera del Proceso Masivo
  *
  * PARAMETROS:
  * @Param Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE 
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 08-04-2019
  */
  PROCEDURE P_UPDATE_INFO_PROC_MASIVO_CAB(Prf_InfoProcesoMasivoCab IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
                                          Pv_MsjResultado          OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSERT_INFO_PROC_MASIVO_DET'.
  *
  * Procedimiento que Inserta detalle del Proceso Masivo
  *
  * PARAMETROS:
  * @Param Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-04-2019
  */
  PROCEDURE P_INSERT_INFO_PROC_MASIVO_DET(Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
                                          Pv_MsjResultado          OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_UPDATE_INFO_PROC_MASIVO_DET'.
  *
  * Procedimiento que Actualiza detalle del Proceso Masivo
  *
  * PARAMETROS:
  * @Param Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 08-04-2019
  */
  PROCEDURE P_UPDATE_INFO_PROC_MASIVO_DET(Prf_InfoProcesoMasivoDet IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE,
                                          Pv_MsjResultado          OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_EJECUTA_PM_PROMOCIONES'.
  *
  * Procedimiento que Ejecuta Proceso Masivo de Promociones
  *
  * Costo del Query C_GetProcesoMasivoCab: 6
  * Costo del Query C_Parametros: 3
  *
  * PARAMETROS:
  * @Param Pv_TipoPma       IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE (InactivarPromo, ClonarPromo)
  * @Param Pv_OrigenPma     IN VARCHAR2
  * @Param Pv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_Estado        IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 08-04-2019
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.1  25-10-2019
  * Se agrega par�metro de origen en P_EJECUTA_PM_PROMOCIONES para determinar que el proceso se realizar� por Anulaci�n desde la Web.
  * Se agrega validaci�n para que se realice el nuevo proceso de inactivaci�n por fechas de vigencias de la promoci�n. 
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.2  07-10-2020
  * Se agregan cambios para inactivaci�n de promociones en su fecha de vigencia y que estas actualicen su fecha de fin 
  * de vigencia al d�a anterior para no otorgar mas promociones.
  *
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.3 19-08-2021
  * Se modifica que al ejecutar los procesos masivos de Inactivaci�n de Promociones solo se realice el cambio de estado a "Inactivo" de las reglas 
  * promocionales que se encuentran en estado Activo.
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.4 28-02-2023
  * Se agrega cursor para obtner el nombre de plantilla parametrizado por empresa.
  */
  PROCEDURE P_EJECUTA_PM_PROMOCIONES (Pv_TipoPma     IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                       Pv_OrigenPma   IN VARCHAR2,
                                       Pv_CodEmpresa  IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                       Pv_Estado      IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE);

 /**
  * Documentaci�n para PROCEDURE 'P_EJECUTA_CLONAR_PROMOCIONES'.
  *
  * Procedimiento que Ejecuta Proceso Masivo de Promociones
  *
  * Costo del Query C_GetProcesoMasivoCab: 6
  * Costo del Query C_GetProcesoMasivoDet: 7
  * Costo del Query C_GetUsuario: 3
  * Costo del Query C_Parametros: 3
  *
  * PARAMETROS:
  * @Param Pv_TipoPma       IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE (InactivarPromo, ClonarPromo)
  * @Param Pv_CodEmpresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_Estado        IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 08-04-2019
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.1 28-02-2023
  * Se agrega cursor para obtner el nombre de plantilla parametrizado por empresa.
  */
  PROCEDURE P_EJECUTA_CLONAR_PROMOCIONES (Pv_TipoPma    IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                          Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                          Pv_Estado     IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE);

 /**
  * Documentaci�n para PROCEDURE 'P_CLONA_PROMOCIONES'.
  *
  * Procedimiento que Clona Promociones
  *
  * Costo del Query C_GetGrupoPromocion: 1
  * Costo del Query C_GetGrupoPromocionRegla: 2
  * Costo del Query C_GetTipoPromocion: 2
  * Costo del Query C_GetTipoPromocionRegla: 2
  * Costo del Query C_GetTipoPLanProdPromo: 2
  *
  * PARAMETROS:
  * @Param Pv_TipoPma             IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE (InactivarPromo, ClonarPromo)
  * @Param Pn_IdGrupoPromocion    IN  NUMBER,  
  * @Param Pv_Observacion         IN  VARCHAR2,
  * @Param Pv_UsrCreacion         IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
  * @Param Pv_CodEmpresa          IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
  * @Param Pv_IpCreacion          IN  VARCHAR2,
  * @Param Pv_TipoPma             IN  VARCHAR2,
  * @Param Pn_IdMotivo            IN  NUMBER,
  * @Param Pv_MsjResultado        OUT VARCHAR2  
  *
  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 08-04-2019
  */

  PROCEDURE P_CLONA_PROMOCIONES(Pn_IdGrupoPromocion         IN  NUMBER,  
                                Pv_Observacion              IN  VARCHAR2,
                                Pv_UsrCreacion              IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Pv_IpCreacion               IN  VARCHAR2,
                                Pv_TipoPma                  IN  VARCHAR2,
                                Pn_IdMotivo                 IN  NUMBER,
                                Pv_MsjResultado             OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSRT_ADMI_GRUPO_PROMOCION'.
  *
  * Procedimiento que Inserta datos generales de una promoci�n
  *
  * PARAMETROS:
  * @Param Prf_AdmiGrupoPromocion   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION%ROWTYPE
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-04-2019
  */
  PROCEDURE P_INSRT_ADMI_GRUPO_PROMOCION(Prf_AdmiGrupoPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION%ROWTYPE,
                                         Pv_MsjResultado        OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSRT_ADMI_GRUPO_PROMO_REGLA'.
  *
  * Procedimiento que Inserta los grupos de una regla de promoci�n
  *
  * PARAMETROS:
  * @Param Prf_AdmiGrupoPromocionRegla  IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA%ROWTYPE
  * @Param Pv_MsjResultado              OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-04-2019
  */
  PROCEDURE P_INSRT_ADMI_GRUPO_PROMO_REGLA(Prf_AdmiGrupoPromocionRegla  IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA%ROWTYPE,
                                           Pv_MsjResultado              OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSRT_ADMI_TIPO_PROMOCION'.
  *
  * Procedimiento que Inserta el o los tipos de promociones
  *
  * PARAMETROS:
  * @Param Prf_AdmiTipoPromocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION%ROWTYPE
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-04-2019
  */
  PROCEDURE P_INSRT_ADMI_TIPO_PROMOCION(Prf_AdmiTipoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION%ROWTYPE,
                                        Pv_MsjResultado       OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSRT_ADMI_TIPO_PROMO_REGLA'.
  *
  * Procedimiento que Inserta las reglas de una promoci�n
  *
  * PARAMETROS:
  * @Param Prf_AdmiTipoPromoRegla   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA%ROWTYPE
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-04-2019
  */
  PROCEDURE P_INSRT_ADMI_TIPO_PROMO_REGLA(Prf_AdmiTipoPromoRegla  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA%ROWTYPE,
                                          Pv_MsjResultado         OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSRT_ADMITIPOPLANPRODPROMO'.
  *
  * Procedimiento que Inserta los planes/productos de una promoci�n
  *
  * PARAMETROS:
  * @Param Prf_AdmiTipoPlanProndPromo   IN DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION%ROWTYPE
  * @Param Pv_MsjResultado              OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-04-2019
  */
  PROCEDURE P_INSRT_ADMITIPOPLANPRODPROMO(Prf_AdmiTipoPlanProndPromo  IN DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION%ROWTYPE,
                                          Pv_MsjResultado             OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE 'P_INSRT_ADMI_GRUPO_PROMO_HIST'.
  *
  * Procedimiento que Inserta el historial de una promoci�n
  *
  * PARAMETROS:
  * @Param Prf_AdmiGrupoPromoHist   IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO%ROWTYPE
  * @Param Pv_MsjResultado          OUT VARCHAR2 (Devuelve un mensaje del resultado de ejecuci�n)

  * @author Jos� Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-04-2019
  */
  PROCEDURE P_INSRT_ADMI_GRUPO_PROMO_HIST(Prf_AdmiGrupoPromoHist  IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO%ROWTYPE,
                                          Pv_MsjResultado         OUT VARCHAR2);
                                          
END CMKG_GRUPO_PROMOCIONES;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES AS  
  --
  PROCEDURE P_CREA_PM_PROMOCIONES(
    Pv_IdsGrupoPromocion        IN OUT CLOB,  
    Pn_IdMotivo                 IN OUT DB_GENERAL.ADMI_MOTIVO.ID_MOTIVO%TYPE,    
    Pv_Observacion              IN  VARCHAR2,
    Pv_UsrCreacion              IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
    Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    Pv_IpCreacion               IN  VARCHAR2,
    Pv_TipoPma                  IN  VARCHAR2,
    Pv_MsjResultado             OUT VARCHAR2  
  )
  IS  
    --Costo: 7
    CURSOR C_GetIdGrupoPromocion (Cn_IdGrupoPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                  Cv_CodEmpresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT ID_GRUPO_PROMOCION
      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION     
      WHERE 
      ID_GRUPO_PROMOCION = Cn_IdGrupoPromocion
      AND EMPRESA_COD    = Cv_CodEmpresa
      AND ESTADO         != 'Eliminado';
      
    --Costo: 5
    CURSOR C_GetIdVencePromocion 
    IS
       SELECT DISTINCT LISTAGG(ID_GRUPO_PROMOCION, ',') WITHIN 
                           GROUP (ORDER BY ID_GRUPO_PROMOCION) over (partition by grupo) LISTA_NOMBRES
                          from 
                           (SELECT gp.id_grupo_promocion, '1' as grupo
                           FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION GP
                           WHERE  trunc(FE_FIN_VIGENCIA)  < to_date(SYSDATE, 'DD/MM/RRRR')
                           AND estado='Activo')tabla;
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
    Ln_IdGrupoPromocion       DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    Ln_IdProcesoMasivoCab     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE;
    Ln_IdProcesoMasivoDet     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET%TYPE;     
    Lr_InfoProcesoMasivoCab   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet   DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;    
    Lv_EstadoActivo           VARCHAR2(15):='Activo';
    Lv_NombreMotivo           VARCHAR2(200):='Inactivaci�n autom�tica por fechas de vigencias';
    Lex_Exception EXCEPTION;

  BEGIN  
    --    
    IF C_GetIdGrupoPromocion%ISOPEN THEN
      --
      CLOSE C_GetIdGrupoPromocion;
      --
    END IF;
    --
    --
     IF Pv_TipoPma='InactivaJob' then
          --
          IF C_GetIdVencePromocion%ISOPEN THEN
            CLOSE C_GetIdVencePromocion;
          END IF; 
          --
          OPEN C_GetIdVencePromocion;
          FETCH C_GetIdVencePromocion INTO Pv_IdsGrupoPromocion;
          CLOSE C_GetIdVencePromocion;
          --
          IF C_ObtieneMotivoSolicitud%ISOPEN THEN
            CLOSE C_ObtieneMotivoSolicitud;
          END IF;
          --
          OPEN C_ObtieneMotivoSolicitud(Lv_EstadoActivo,Lv_NombreMotivo);
          FETCH C_ObtieneMotivoSolicitud INTO Pn_IdMotivo;
          CLOSE C_ObtieneMotivoSolicitud;
     END IF;    
          
    
    Ln_IdProcesoMasivoCab                             := DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_CAB.NEXTVAL;
    Lr_InfoProcesoMasivoCab                           := NULL;
    Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB     := Ln_IdProcesoMasivoCab;
    Lr_InfoProcesoMasivoCab.TIPO_PROCESO              := Pv_TipoPma;
    Lr_InfoProcesoMasivoCab.EMPRESA_ID                := TO_NUMBER(Pv_CodEmpresa);
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
    Lr_InfoProcesoMasivoCab.SOLICITUD_ID              := Pn_IdMotivo;

    BEGIN
        --
      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSERT_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Pv_MsjResultado);
      IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
       --
        RAISE Lex_Exception;
       --
      END IF;
        --
    EXCEPTION
    WHEN Lex_Exception THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_GRUPO_PROMOCIONES.P_CREA_PM_PROMOCIONES', 
                                         Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_pms_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    END;

    --  
    FOR CURRENT_ROW IN
    (
      WITH TEST AS
      (SELECT Pv_IdsGrupoPromocion FROM DUAL)
      SELECT regexp_substr(Pv_IdsGrupoPromocion, '[^,]+', 1, ROWNUM) SPLIT
      FROM TEST
      CONNECT BY LEVEL <= LENGTH (regexp_replace(Pv_IdsGrupoPromocion, '[^,]+'))  + 1
    )
    LOOP
      OPEN C_GetIdGrupoPromocion(TO_NUMBER(CURRENT_ROW.SPLIT), Pv_CodEmpresa);
        --
      FETCH C_GetIdGrupoPromocion INTO Ln_IdGrupoPromocion;
      IF(Ln_IdGrupoPromocion IS NOT NULL) THEN          
        --
        -- INSERTO DETALLE DE PROCESO MASIVO
        Ln_IdProcesoMasivoDet                            :=DB_INFRAESTRUCTURA.SEQ_INFO_PROCESO_MASIVO_DET.NEXTVAL;
        Lr_InfoProcesoMasivoDet                          :=NULL;
        Lr_InfoProcesoMasivoDet.ID_PROCESO_MASIVO_DET    :=Ln_IdProcesoMasivoDet;
        Lr_InfoProcesoMasivoDet.PROCESO_MASIVO_CAB_ID    :=Ln_IdProcesoMasivoCab;
        Lr_InfoProcesoMasivoDet.PUNTO_ID                 :=Ln_IdGrupoPromocion;
        Lr_InfoProcesoMasivoDet.ESTADO                   :='Pendiente';
        Lr_InfoProcesoMasivoDet.FE_CREACION              :=SYSDATE;
        Lr_InfoProcesoMasivoDet.FE_ULT_MOD               :=NULL;
        Lr_InfoProcesoMasivoDet.USR_CREACION             :=Pv_UsrCreacion;
        Lr_InfoProcesoMasivoDet.USR_ULT_MOD              :=NULL;
        Lr_InfoProcesoMasivoDet.IP_CREACION              :=Lv_IpCreacion;
        Lr_InfoProcesoMasivoDet.SERVICIO_ID              :=NULL;
        Lr_InfoProcesoMasivoDet.OBSERVACION              :=Pv_Observacion;
        Lr_InfoProcesoMasivoDet.SOLICITUD_ID             :=Ln_IdGrupoPromocion;
        Lr_InfoProcesoMasivoDet.PERSONA_EMPRESA_ROL_ID   :=null;             
        --
        BEGIN
          --
          DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSERT_INFO_PROC_MASIVO_DET(Lr_InfoProcesoMasivoDet, Pv_MsjResultado);
          IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
            --
            RAISE Lex_Exception;
            --
          END IF;
          --
          EXCEPTION
          WHEN Lex_Exception THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                                 'CMKG_GRUPO_PROMOCIONES.P_CREA_PM_PROMOCIONES', 
                                                  Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                 'telcos_pms_promo',
                                                 SYSDATE,
                                                 NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                                ); 
          END;
          --
      END IF;           
      --
      CLOSE C_GetIdGrupoPromocion;

    END LOOP;
    --
    --ACTUALIZO CABECERA DE PROCESO MASIVO A PENDIENTE  
    --
    Lr_InfoProcesoMasivoCab.FE_ULT_MOD        := SYSDATE;
    Lr_InfoProcesoMasivoCab.USR_ULT_MOD       := Pv_UsrCreacion;    
    Lr_InfoProcesoMasivoCab.ESTADO            := 'Pendiente';   
    BEGIN
      --
      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_UPDATE_INFO_PROC_MASIVO_CAB(Lr_InfoProcesoMasivoCab, Pv_MsjResultado);
      IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
        --
        RAISE Lex_Exception;
        --
      END IF;
      --
    EXCEPTION
    WHEN Lex_Exception THEN
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_GRUPO_PROMOCIONES.P_CREA_PM_PROMOCIONES', 
                                         Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         'telcos_pms_promo',
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                        ); 
    END;

    --
    COMMIT;
    Pv_MsjResultado      := 'Se procedi� a ejecutar el script de '|| Pv_TipoPma ||', por favor esperar el email de confirmaci�n!'; 

    EXCEPTION   
    WHEN OTHERS THEN
      --
      Pv_MsjResultado      := 'Ocurri� un error al guardar el Proceso Masivo '||Pv_TipoPma; 

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_GRUPO_PROMOCIONES.P_CREA_PM_PROMOCIONES', 
                                           Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_pms_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                          );            
  END P_CREA_PM_PROMOCIONES;
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
  PROCEDURE P_EJECUTA_PM_PROMOCIONES (Pv_TipoPma    IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                     Pv_OrigenPma  IN VARCHAR2,
                                     Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_Estado     IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE)
  IS
    --Costo: 6
    CURSOR C_GetProcesoMasivoCab (Cv_TipoPma    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                  Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Cv_Estado     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE)
    IS
      SELECT PMC.ID_PROCESO_MASIVO_CAB, 
        PMC.SOLICITUD_ID AS ID_MOTIVO,
        MO.NOMBRE_MOTIVO,
        EMPG.PREFIJO,
        PMC.ESTADO AS ESTADO_CAB   
      FROM 
        DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PMC,  
        DB_GENERAL.ADMI_MOTIVO  MO,
        DB_COMERCIAL.INFO_EMPRESA_GRUPO EMPG
      WHERE
      PMC.SOLICITUD_ID                = MO.ID_MOTIVO
      AND PMC.EMPRESA_ID              = EMPG.COD_EMPRESA
      AND EMPG.COD_EMPRESA            = Cv_CodEmpresa
      AND PMC.TIPO_PROCESO            = Cv_TipoPma 
      AND PMC.ESTADO                  = Cv_Estado
      ORDER BY PMC.FE_CREACION ASC;

    --Costo: 7
    CURSOR C_GetProcesoMasivoDet(Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                                 Cv_TipoPma            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                 Cv_Estado             DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE)
    IS
      SELECT PMC.ID_PROCESO_MASIVO_CAB, 
        PMC.SOLICITUD_ID AS ID_MOTIVO,
        MO.NOMBRE_MOTIVO,
        PMC.ESTADO AS ESTADO_CAB,
        PMD.ID_PROCESO_MASIVO_DET,
        PMD.SOLICITUD_ID AS ID_GRUPO_PROMOCION,
        PMD.OBSERVACION,
        PMD.ESTADO AS ESTADO_DET,
        GPRO.ID_GRUPO_PROMOCION AS ID_GRUPO_PROMO,
        GPRO.ESTADO  AS ESTADO_GRUPO_PROMO,
        GPRO.NOMBRE_GRUPO,
        GPRO.FE_INICIO_VIGENCIA, GPRO.FE_FIN_VIGENCIA
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB PMC,
        DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET PMD,
        DB_GENERAL.ADMI_MOTIVO  MO,
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION GPRO
      WHERE PMC.ID_PROCESO_MASIVO_CAB = PMD.PROCESO_MASIVO_CAB_ID
      AND PMC.SOLICITUD_ID            = MO.ID_MOTIVO
      AND PMC.TIPO_PROCESO            = Cv_TipoPma 
      AND PMC.ESTADO                  = Cv_Estado
      AND PMD.SOLICITUD_ID            = GPRO.ID_GRUPO_PROMOCION
      AND PMC.ID_PROCESO_MASIVO_CAB   = Cn_IdProcesoMasivoCab;

    --Costo: 2
    CURSOR C_GetTiposPorGrupoPromo(Cn_IdGrupoPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS
      SELECT GPRO.ID_GRUPO_PROMOCION,
        GPRO.NOMBRE_GRUPO,
        TPRO.TIPO,
        TPRO.ID_TIPO_PROMOCION
      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION GPRO,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION TPRO
      WHERE GPRO.ID_GRUPO_PROMOCION        = TPRO.GRUPO_PROMOCION_ID
      AND GPRO.ID_GRUPO_PROMOCION          = Cn_IdGrupoPromocion
      AND TPRO.ESTADO                      ='Activo'
      AND GPRO.ESTADO                      ='Activo';

    --Costo: 7
    CURSOR C_GetGrupoPromocionRegla(Cn_IdTipoPromocion    DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                    Cv_Regla              DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE)
    IS
      SELECT   
        TPRORE.VALOR
      FROM
        DB_COMERCIAL.ADMI_TIPO_PROMOCION TPRO,
        DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA TPRORE,
        DB_COMERCIAL.ADMI_CARACTERISTICA REGLA
      WHERE
      TPRO.ID_TIPO_PROMOCION               = Cn_IdTipoPromocion
      AND TPRO.ID_TIPO_PROMOCION           = TPRORE.TIPO_PROMOCION_ID
      AND TPRORE.CARACTERISTICA_ID         = REGLA.ID_CARACTERISTICA
      AND REGLA.DESCRIPCION_CARACTERISTICA = Cv_Regla
      AND TPRORE.ESTADO                    = 'Activo';
    Lr_GetGrupoPromocionRegla   C_GetGrupoPromocionRegla%ROWTYPE;

    --Costo: 3
    CURSOR C_GetUsuario(Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
    IS
      SELECT USR_CREACION
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
      WHERE ID_PROCESO_MASIVO_CAB=Cn_IdProcesoMasivoCab;

    --Costo: 3
    CURSOR C_Parametros(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                        Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                        Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                        Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT APD.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_Descripcion
      AND APC.ESTADO             = Cv_Estado
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro
      AND APD.EMPRESA_COD        = Cv_CodEmpresa;
    --
    Lv_IpCreacion                VARCHAR2(16) := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_IdGrupoPromocionHisto     DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO.ID_GRUPO_PROMOCION_HISTO%TYPE;
    Lr_InfoProcesoMasivoCab      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoMasivoDet      DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET%ROWTYPE;   
    Lex_Exception EXCEPTION;
    Lv_MsjResultado              VARCHAR2(2000);
    --
    Lv_Directorio                VARCHAR2(100)   := 'DIR_REPGERENCIA';
    Lv_NombreArchivo             VARCHAR2(200);
    Lv_Delimitador               VARCHAR2(1)    := ',';
    Lv_Gzip                      VARCHAR2(250);
    Lv_Remitente                 VARCHAR2(100)  := 'notificaciones_telcos@telconet.ec';
    Lv_Asunto                    VARCHAR2(300)  := 'Reporte de Inactivaci�n de Promociones';
    Lv_Cuerpo                    VARCHAR2(9999) := ''; 
    Lv_NombreArchivoZip          VARCHAR2(250);
    Lc_GetAliasPlantilla         DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo                UTL_FILE.FILE_TYPE;
    Lv_AliasCorreos              VARCHAR2(500);
    Lv_Destinatario              VARCHAR2(500);
    Ln_ContadorCursor            NUMBER := 0; 
    Lv_EstadoDetPma              DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE:='Finalizado';
    Lv_ObservacionPma            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.OBSERVACION%TYPE;
    Lb_ProcesoPma                BOOLEAN:=TRUE;
    Lv_User                      VARCHAR2(1000);
    Lv_Valor                     DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.VALOR%TYPE;
    Lv_EstadoTipo                DB_COMERCIAL.ADMI_TIPO_PROMOCION.ESTADO%TYPE;
    Lv_EstadoGrupo               DB_COMERCIAL.ADMI_TIPO_PROMOCION.ESTADO%TYPE;
    Lv_FechaReporte              VARCHAR2(50):=TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');  
    Lv_ObservHist                VARCHAR2(500);
    Ld_IniVigencia               DATE;
    Ld_FinVigencia               DATE;
    Lv_ActFeFin                  VARCHAR2(1000):='N';
    Lv_EstadoActivo              VARCHAR2(20):='Activo';
    Lv_NombreParametro           DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_PARAMETROS';
    Lv_Descripcion               DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PROM_REPORTE_INACTIVAR';
    Lv_parametro                 VARCHAR2(15);

 BEGIN
   IF C_GetUsuario%ISOPEN THEN
   --
     CLOSE C_GetUsuario;
   --
   END IF;
   --
   IF C_GetGrupoPromocionRegla%ISOPEN THEN
     --
     CLOSE C_GetGrupoPromocionRegla;
     --
   END IF;
   --
   IF C_Parametros%ISOPEN THEN
   --
     CLOSE C_Parametros;
   --
   END IF;
   --
   OPEN C_Parametros(Lv_NombreParametro,
                     Lv_Descripcion,
                     Lv_EstadoActivo,
                     Pv_CodEmpresa);
   FETCH C_Parametros INTO Lv_parametro;
   CLOSE C_Parametros;
   --
   Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_parametro);
   Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
   Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
   Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';
   --
   --Obtengo las Cabeceras de Procesos masivos
   FOR Lr_GetProcesoMasivoCab IN C_GetProcesoMasivoCab(Pv_TipoPma,Pv_CodEmpresa,Pv_Estado) LOOP

     OPEN C_GetUsuario(Lr_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB);
     FETCH C_GetUsuario into Lv_User;
     CLOSE C_GetUsuario;

     Lv_NombreArchivo     := 'ReporteInactivacionPromociones_'||Pv_TipoPma||'_'||Lv_User||'_'||Lv_FechaReporte||'.csv';
     Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
     Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
     Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

     utl_file.put_line(Lfile_Archivo,'REPORTE DE PROMOCIONES INACTIVADAS'||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          ||' '||Lv_Delimitador 
          );
     utl_file.put_line(Lfile_Archivo,'NOMBRE DE PROMOCION'||Lv_Delimitador 
          ||'MOTIVO DE PROCESO'||Lv_Delimitador  
          ||'FECHA DE PROCESO'||Lv_Delimitador 
          ||'USUARIO PROCESO'||Lv_Delimitador     
          ||'ESTADO PROCESO'||Lv_Delimitador 
          ||'OBSERVACION'||Lv_Delimitador          
          );
     Lb_ProcesoPma        := TRUE;
     Lv_EstadoDetPma      := 'Finalizado';
     Lv_ObservacionPma    := 'Se Ejecuto exitosamente el Proceso '||Pv_TipoPma;
     --
     --Obtengo los detalles de los Procesos masivos a ejecutarse
     FOR Lr_GetProcesoMasivoDet IN C_GetProcesoMasivoDet(Lr_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB,Pv_TipoPma,Pv_Estado) LOOP 
       --
       Ln_ContadorCursor    := Ln_ContadorCursor + 1;   
       --  
       --Si el estado del Grupo Promocion no es Activo el detalle del PMA debe ser Fallo
       IF (Lr_GetProcesoMasivoDet.ESTADO_GRUPO_PROMO!='Activo') THEN             
         Lv_EstadoDetPma   :='Fallo';
         Lv_ObservacionPma :='No se realizo el Proceso: '||Pv_TipoPma||' debido a que el Grupo Promoci�n: '||SUBSTR(Lr_GetProcesoMasivoDet.NOMBRE_GRUPO,1,100)||
                             ' Se encuentra en Estado: '||Lr_GetProcesoMasivoDet.ESTADO_GRUPO_PROMO;
         Lb_ProcesoPma     :=FALSE;
       END IF;
       Ld_IniVigencia:=Lr_GetProcesoMasivoDet.FE_INICIO_VIGENCIA;
       Ld_FinVigencia:=Lr_GetProcesoMasivoDet.FE_FIN_VIGENCIA;
       
       IF (Ld_IniVigencia > SYSDATE) THEN
          Lv_ActFeFin:='S';
       END IF;
       --
       --Obtengo los Tipos de Promociones asociadas a un grupo
       FOR Lr_GetTiposPorGrupoPromo IN C_GetTiposPorGrupoPromo(Lr_GetProcesoMasivoDet.ID_GRUPO_PROMOCION) LOOP
         --
         Lv_Valor:='';
         OPEN C_GetGrupoPromocionRegla(Lr_GetTiposPorGrupoPromo.ID_TIPO_PROMOCION, 'PROM_PROMOCION_INDEFINIDA');
         FETCH C_GetGrupoPromocionRegla into Lv_Valor;
         --Si es un Tipo de Promocion Indefinida , se debe Dar de baja en ADMI_TIPO_PROMOCION, ADMI_TIPO_PROMOCION_REGLA
         --caso contrario se debe Inactivar
         
         IF Pv_OrigenPma = 'AnulacionWeb' THEN 
           IF Lv_Valor IS NOT NULL AND Lv_Valor = 'SI' THEN
             Lv_EstadoTipo :='Baja';
           ELSE
             Lv_EstadoTipo :='Anulado';
           END IF;
         ELSIF Pv_OrigenPma = 'InactivacionJob' THEN 
             Lv_EstadoTipo :='Inactivo';
         END IF;
         CLOSE C_GetGrupoPromocionRegla;    
         --
         UPDATE DB_COMERCIAL.ADMI_TIPO_PROMOCION 
         SET
         FE_ULT_MOD  = SYSDATE,
         USR_ULT_MOD = Lv_User,
         IP_ULT_MOD  = Lv_IpCreacion,
         ESTADO      = Lv_EstadoTipo
         WHERE ID_TIPO_PROMOCION=Lr_GetTiposPorGrupoPromo.ID_TIPO_PROMOCION;
         --
         UPDATE DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA
         SET
         FE_ULT_MOD  = SYSDATE,
         USR_ULT_MOD = Lv_User,
         IP_ULT_MOD  = Lv_IpCreacion,
         ESTADO      = Lv_EstadoTipo
         WHERE TIPO_PROMOCION_ID=Lr_GetTiposPorGrupoPromo.ID_TIPO_PROMOCION AND ESTADO = Lv_EstadoActivo;
         --
         UPDATE DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION
         SET
         FE_ULT_MOD  = SYSDATE,
         USR_ULT_MOD = Lv_User,
         IP_ULT_MOD  = Lv_IpCreacion,
         ESTADO      = Lv_EstadoTipo
         WHERE TIPO_PROMOCION_ID=Lr_GetTiposPorGrupoPromo.ID_TIPO_PROMOCION AND ESTADO = Lv_EstadoActivo;
         --
         
         Lv_ObservHist:=  'Se cambia de estado el Tipo de Promoci�n: ' ||Lr_GetTiposPorGrupoPromo.Tipo|| ' - ' || Lr_GetProcesoMasivoDet.OBSERVACION;
         
         IF Pv_TipoPma = 'InactPromoVigente' OR  Pv_TipoPma = 'InactPromoUnico'  THEN
   
            Lv_ObservHist:= Lv_ObservHist || ' - la promoci�n se procedi� a inactivar el ' || SYSDATE ;
           
         END IF;
         
         --Guardo Historial por cada Tipo de Promocion
         Ln_IdGrupoPromocionHisto:= DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL;
         INSERT INTO 
         DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
         (ID_GRUPO_PROMOCION_HISTO,  
          GRUPO_PROMOCION_ID,      
          MOTIVO_ID,              
          FE_CREACION,              
          USR_CREACION,              
          IP_CREACION,               
          OBSERVACION,                  
          ESTADO                    
         )   
         VALUES
         (Ln_IdGrupoPromocionHisto,
          Lr_GetProcesoMasivoDet.ID_GRUPO_PROMOCION,
          Lr_GetProcesoMasivoDet.ID_MOTIVO,
          SYSDATE,
          Lv_User,
          Lv_IpCreacion,
          Lv_ObservHist,
          Lv_EstadoTipo
         );  
         -- 
       END LOOP;
       --
       IF(Lb_ProcesoPma = TRUE) THEN
       
        IF Pv_OrigenPma = 'AnulacionWeb' THEN 
              Lv_EstadoGrupo:='Anulado';
        ELSIF Pv_OrigenPma = 'InactivacionJob' THEN 
              Lv_EstadoGrupo :='Inactivo';
         END IF;
         --
         --Paso a Estado Inactivo el grupo de la Promoci�n
         
          IF Pv_TipoPma = 'InactPromoVigente' OR  Pv_TipoPma = 'InactPromoUnico'  THEN
             IF (Lv_ActFeFin='S') THEN
                 Ld_FinVigencia:=Ld_IniVigencia;
             else
                 Ld_FinVigencia:=SYSDATE;
             END IF;
           
             UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION 
             SET
             FE_ULT_MOD  = SYSDATE,
             FE_FIN_VIGENCIA  = Ld_FinVigencia,
             USR_ULT_MOD = Lv_User,
             IP_ULT_MOD  = Lv_IpCreacion,
             ESTADO      = Lv_EstadoGrupo 
             WHERE ID_GRUPO_PROMOCION=Lr_GetProcesoMasivoDet.ID_GRUPO_PROMOCION;
             
          ELSE
         
             UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION 
             SET
             FE_ULT_MOD  = SYSDATE,
             USR_ULT_MOD = Lv_User,
             IP_ULT_MOD  = Lv_IpCreacion,
             ESTADO      = Lv_EstadoGrupo 
             WHERE ID_GRUPO_PROMOCION=Lr_GetProcesoMasivoDet.ID_GRUPO_PROMOCION;
           
         END IF;

         --
         --Paso a estado Inactivo las reglas del grupo
         UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA 
         SET
         FE_ULT_MOD  = SYSDATE,
         USR_ULT_MOD = Lv_User,
         IP_ULT_MOD  = Lv_IpCreacion,
         ESTADO      = Lv_EstadoGrupo
         WHERE GRUPO_PROMOCION_ID=Lr_GetProcesoMasivoDet.ID_GRUPO_PROMOCION AND ESTADO = Lv_EstadoActivo;
         --
       END IF;      
       --
       --Actualizo estado del Detalle del PMA a Finalizado o Fall�
       --      
       UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
       SET ESTADO  = Lv_EstadoDetPma,
       USR_ULT_MOD = Lv_User,
       FE_ULT_MOD  = SYSDATE ,
       OBSERVACION = Lr_GetProcesoMasivoDet.OBSERVACION ||' - '||Lv_ObservacionPma
       WHERE ID_PROCESO_MASIVO_DET = Lr_GetProcesoMasivoDet.ID_PROCESO_MASIVO_DET;
       --
       --Construyo archivo
       UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(Lr_GetProcesoMasivoDet.NOMBRE_GRUPO, '')||Lv_Delimitador 
            ||NVL(Lr_GetProcesoMasivoDet.NOMBRE_MOTIVO, '')||Lv_Delimitador  
            ||NVL(SYSDATE, '')||Lv_Delimitador 
            ||NVL(Lv_User, '')||Lv_Delimitador    
            ||NVL(Lv_EstadoDetPma, '')||Lv_Delimitador  
            ||NVL(Lr_GetProcesoMasivoDet.OBSERVACION ||' - '||Lv_ObservacionPma, '')||Lv_Delimitador 
       ); 
       --
      END LOOP;
      --
      --Actualizo estado de la Cabecera del PMA a Finalizado 
      --    
      UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
      SET ESTADO  = 'Finalizado',
      USR_ULT_MOD = Lv_User,
      FE_ULT_MOD  = SYSDATE
      WHERE ID_PROCESO_MASIVO_CAB = Lr_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB;       
      --
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
      --
   END LOOP;

   COMMIT;

 EXCEPTION
 WHEN Lex_Exception THEN
 --
   Lv_MsjResultado      := 'Ocurrio un error al ejecutar el Proceso Masivo '||Pv_TipoPma; 

   DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                        'CMKG_GRUPO_PROMOCIONES.P_EJECUTA_PM_PROMOCIONES', 
                                        Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                        'telcos_pms_promo',
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                       ); 
 WHEN OTHERS THEN
 --
   Lv_MsjResultado      := 'Ocurrio un error al ejecutar el Proceso Masivo '||Pv_TipoPma; 
   DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                        'CMKG_GRUPO_PROMOCIONES.P_EJECUTA_PM_PROMOCIONES', 
                                        Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                        'telcos_pms_promo',
                                        SYSDATE,
                                        NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)
                                       );            
 END P_EJECUTA_PM_PROMOCIONES;
 --
 --
 PROCEDURE P_EJECUTA_CLONAR_PROMOCIONES (Pv_TipoPma    IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                         Pv_CodEmpresa IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pv_Estado     IN DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE)
  IS
    --Costo: 6
    CURSOR C_GetProcesoMasivoCab (Cv_TipoPma    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                  Cv_CodEmpresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                  Cv_Estado     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE)
    IS
      SELECT pmc.id_proceso_masivo_cab,
        pmc.solicitud_id   AS id_motivo,
        mo.nombre_motivo,
        empg.prefijo,
        pmc.estado         AS estado_cab
      FROM db_infraestructura.info_proceso_masivo_cab pmc,
        db_general.admi_motivo                        mo,
        db_comercial.info_empresa_grupo               empg
      WHERE pmc.solicitud_id    = mo.id_motivo
      AND pmc.empresa_id        = empg.cod_empresa
      AND empg.cod_empresa      = Cv_CodEmpresa
      AND pmc.tipo_proceso      = Cv_TipoPma
      AND pmc.estado            = Cv_Estado
      ORDER BY pmc.fe_creacion ASC;

    --Costo: 7
    CURSOR C_GetProcesoMasivoDet(Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE,
                                 Cv_TipoPma            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE,
                                 Cv_Estado             DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE)
    IS
      SELECT pmc.id_proceso_masivo_cab,
        pmc.solicitud_id          AS id_motivo,
        mo.nombre_motivo,
        pmc.estado                AS estado_cab,
        pmd.id_proceso_masivo_det,
        pmd.solicitud_id          AS id_grupo_promocion,
        pmd.observacion,
        pmd.estado                AS estado_det,
        gpro.id_grupo_promocion   AS id_grupo_promo,
        gpro.estado               AS estado_grupo_promo,
        gpro.nombre_grupo
      FROM db_infraestructura.info_proceso_masivo_cab pmc,
        db_infraestructura.info_proceso_masivo_det    pmd,
        db_general.admi_motivo                        mo,
        db_comercial.admi_grupo_promocion             gpro
      WHERE pmc.id_proceso_masivo_cab = pmd.proceso_masivo_cab_id
      AND pmc.solicitud_id            = mo.id_motivo
      AND pmc.tipo_proceso            = Cv_TipoPma
      AND pmc.estado                  = Cv_Estado
      AND pmd.estado                  = Cv_Estado
      AND pmd.solicitud_id            = gpro.id_grupo_promocion
      AND pmc.id_proceso_masivo_cab   = Cn_IdProcesoMasivoCab;

    --Costo: 3
    CURSOR C_GetUsuario(Cn_IdProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE)
    IS
      SELECT usr_creacion
      FROM db_infraestructura.info_proceso_masivo_cab
      WHERE id_proceso_masivo_cab = Cn_IdProcesoMasivoCab;
      
    --Costo: 3
    CURSOR C_Parametros(Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                        Cv_Descripcion     DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE,
                        Cv_Estado          DB_GENERAL.ADMI_PARAMETRO_CAB.ESTADO%TYPE,
                        Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT APD.VALOR1 
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC,
        DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION      = Cv_Descripcion
      AND APC.ESTADO             = Cv_Estado
      AND APD.PARAMETRO_ID       = APC.ID_PARAMETRO
      AND APD.ESTADO             = Cv_Estado
      AND APC.NOMBRE_PARAMETRO   = Cv_NombreParametro
      AND APD.EMPRESA_COD        = Cv_CodEmpresa;
    --
    Lv_IpCreacion             VARCHAR2(16)    := (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_Directorio             VARCHAR2(50)    := 'DIR_REPGERENCIA';
    Lv_Delimitador            VARCHAR2(1)     := ',';
    Lv_Remitente              VARCHAR2(100)   := 'notificaciones_telcos@telconet.ec';
    Lv_Asunto                 VARCHAR2(300)   := 'Reporte de Clonaci�n de Promociones';
    Lv_Cuerpo                 VARCHAR2(9999)  := ''; 
    Lv_FechaReporte           VARCHAR2(50)    := TO_CHAR(sysdate, 'YYYYMMDDHH24MISS');
    Lb_ProcesoPma             BOOLEAN         := TRUE;
    Lv_NombreArchivo          VARCHAR2(150);
    Lv_NombreArchivoZip       VARCHAR2(250);
    Lv_Gzip                   VARCHAR2(100);
    Lv_AliasCorreos           VARCHAR2(500);
    Lv_Destinatario           VARCHAR2(500);
    Lv_User                   VARCHAR2(1000);
    Lv_MsjResultado           VARCHAR2(2000);
    Lv_parametro              VARCHAR2(15);
    Lv_NombreParametro        DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE := 'PROM_PARAMETROS';
    Lv_Descripcion            DB_GENERAL.ADMI_PARAMETRO_DET.DESCRIPCION%TYPE := 'PROM_REPORTE_CLONAR';
    Lv_EstadoActivo           VARCHAR2(15):= 'Activo';
    Lc_GetAliasPlantilla      DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lfile_Archivo             UTL_FILE.FILE_TYPE;
    Lv_EstadoDetPma           DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE:='Finalizado';
    Lv_ObservacionPma         DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.OBSERVACION%TYPE;
    Lr_AdmiGrupoPromocionHist DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO%ROWTYPE;
    Ln_IdGrupoPromocionHisto  DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO.ID_GRUPO_PROMOCION_HISTO%TYPE;
    Lex_Exception             EXCEPTION;

  BEGIN
    IF C_GetUsuario%ISOPEN THEN
    --
      CLOSE C_GetUsuario;
    --
    END IF;
    --
    IF C_Parametros%ISOPEN THEN
    --
      CLOSE C_Parametros;
    --
    END IF;
    --
    OPEN C_Parametros(Lv_NombreParametro,
                      Lv_Descripcion,
                      Lv_EstadoActivo,
                      Pv_CodEmpresa);
    FETCH C_Parametros INTO Lv_parametro;
    CLOSE C_Parametros;
    --
    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_parametro);
    Lv_Cuerpo            := Lc_GetAliasPlantilla.PLANTILLA;
    Lv_AliasCorreos      := REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',');
    Lv_Destinatario      := NVL(Lv_AliasCorreos,'notificaciones_telcos@telconet.ec')||',';
    --
    --Obtengo las Cabeceras de Procesos masivos
    FOR Lr_GetProcesoMasivoCab IN C_GetProcesoMasivoCab(Pv_TipoPma,Pv_CodEmpresa,Pv_Estado) LOOP

      OPEN C_GetUsuario(Lr_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB);
      FETCH C_GetUsuario into Lv_User;
      CLOSE C_GetUsuario;

      Lv_NombreArchivo     := 'ReporteClonacionPromociones_'||Pv_TipoPma||'_'||Lv_User||'_'||Lv_FechaReporte||'.csv';
      Lv_Gzip              := 'gzip /backup/repgerencia/'||Lv_NombreArchivo;
      Lv_NombreArchivoZip  := Lv_NombreArchivo||'.gz';
      Lfile_Archivo        := UTL_FILE.FOPEN(Lv_Directorio,Lv_NombreArchivo,'w',3000);

      utl_file.put_line(Lfile_Archivo,'REPORTE DE PROMOCIONES CLONADAS'||Lv_Delimitador 
                        ||' '||Lv_Delimitador 
                        ||' '||Lv_Delimitador 
                        ||' '||Lv_Delimitador 
                        ||' '||Lv_Delimitador 
                        ||' '||Lv_Delimitador 
                        ||' '||Lv_Delimitador);
      utl_file.put_line(Lfile_Archivo,'NOMBRE DE PROMOCION'||Lv_Delimitador 
                        ||'MOTIVO DE PROCESO'||Lv_Delimitador  
                        ||'FECHA DE PROCESO'||Lv_Delimitador 
                        ||'USUARIO PROCESO'||Lv_Delimitador     
                        ||'ESTADO PROCESO'||Lv_Delimitador 
                        ||'OBSERVACION'||Lv_Delimitador);

      Lb_ProcesoPma        := TRUE;
      Lv_EstadoDetPma      := 'Finalizado';
      Lv_ObservacionPma    := 'Se Ejecuto exitosamente el Proceso '||Pv_TipoPma;
      --
      --Obtengo los detalles de los Procesos masivos a ejecutarse
      FOR Lr_GetProcesoMasivoDet IN C_GetProcesoMasivoDet(Lr_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB,Pv_TipoPma,Pv_Estado) LOOP 

        DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_CLONA_PROMOCIONES(Lr_GetProcesoMasivoDet.ID_GRUPO_PROMOCION,
                                                                Lr_GetProcesoMasivoDet.OBSERVACION,
                                                                Lv_User,
                                                                Pv_CodEmpresa,
                                                                Lv_IpCreacion,
                                                                Pv_TipoPma,
                                                                Lr_GetProcesoMasivoDet.id_motivo,
                                                                Lv_MsjResultado);

          --Si el estado del Grupo Promoci�n no es Activo el detalle del PMA debe ser Fall�
        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        --
          Lv_EstadoDetPma   := 'Fallo';
          Lv_ObservacionPma := 'No se realizo el Proceso: '|| Lv_MsjResultado;
          Lb_ProcesoPma     := FALSE;
        --
        ELSE

          BEGIN
          Ln_IdGrupoPromocionHisto                            := DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL;
          Lr_AdmiGrupoPromocionHist                           := NULL;
          Lr_AdmiGrupoPromocionHist.ID_GRUPO_PROMOCION_HISTO  := Ln_IdGrupoPromocionHisto;
          Lr_AdmiGrupoPromocionHist.GRUPO_PROMOCION_ID        := Lr_GetProcesoMasivoDet.ID_GRUPO_PROMOCION;
          Lr_AdmiGrupoPromocionHist.MOTIVO_ID                 := Lr_GetProcesoMasivoDet.ID_MOTIVO;
          Lr_AdmiGrupoPromocionHist.FE_CREACION               := SYSDATE;
          Lr_AdmiGrupoPromocionHist.USR_CREACION              := Lv_User;
          Lr_AdmiGrupoPromocionHist.IP_CREACION               := Lv_IpCreacion;
          Lr_AdmiGrupoPromocionHist.OBSERVACION               := 'Se clona Promoci�n: ' ||Lr_GetProcesoMasivoDet.NOMBRE_MOTIVO;
          Lr_AdmiGrupoPromocionHist.ESTADO                    := 'Activo';
          --
          DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSRT_ADMI_GRUPO_PROMO_HIST(Lr_AdmiGrupoPromocionHist, Lv_MsjResultado);
          --
          EXCEPTION
          WHEN OTHERS THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                                'CMKG_GRUPO_PROMOCIONES.P_CLONA_PROMOCIONES', 
                                                Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                                'telcos_pms_promo',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
          END;

        END IF;
        --
        --Actualiz� estado del Detalle del PMA a Finalizado o Fall�
        --      
        UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
        SET ESTADO    = Lv_EstadoDetPma,
          USR_ULT_MOD = Lv_User,
          FE_ULT_MOD  = SYSDATE ,
          OBSERVACION = Lr_GetProcesoMasivoDet.OBSERVACION ||' - '||Lv_ObservacionPma
        WHERE ID_PROCESO_MASIVO_DET = Lr_GetProcesoMasivoDet.ID_PROCESO_MASIVO_DET;
        --
        --Construy� archivo
        UTL_FILE.PUT_LINE(Lfile_Archivo,NVL(SUBSTR(Lr_GetProcesoMasivoDet.NOMBRE_GRUPO,1,100), '')||Lv_Delimitador 
                          ||NVL(Lr_GetProcesoMasivoDet.NOMBRE_MOTIVO, '')||Lv_Delimitador  
                          ||NVL(SYSDATE, '')||Lv_Delimitador 
                          ||NVL(Lv_User, '')||Lv_Delimitador    
                          ||NVL(Lv_EstadoDetPma, '')||Lv_Delimitador  
                          ||NVL(Lr_GetProcesoMasivoDet.OBSERVACION ||' - '||Lv_ObservacionPma, '')||Lv_Delimitador); 
      END LOOP;
    --
    --Actualiz� estado de la Cabecera del PMA a Finalizado 
    --    
    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
    SET ESTADO    = 'Finalizado',
      USR_ULT_MOD = Lv_User,
      FE_ULT_MOD  = SYSDATE
    WHERE ID_PROCESO_MASIVO_CAB = Lr_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB;       
    --
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
    --
    END LOOP;

    COMMIT;

  EXCEPTION
    WHEN Lex_Exception THEN
      --
      Lv_MsjResultado      := 'Ocurri� un error al ejecutar el Proceso Masivo '||Pv_TipoPma; 

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_GRUPO_PROMOCIONES.P_EJECUTA_CLONAR_PROMOCIONES', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_pms_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion)); 
    WHEN OTHERS THEN
      --
      Lv_MsjResultado      := 'Ocurri� un error al ejecutar el Proceso Masivo '||Pv_TipoPma; 
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                           'CMKG_GRUPO_PROMOCIONES.P_EJECUTA_CLONAR_PROMOCIONES', 
                                           Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM, 
                                           'telcos_pms_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));            
  END P_EJECUTA_CLONAR_PROMOCIONES;

  PROCEDURE P_CLONA_PROMOCIONES(Pn_IdGrupoPromocion         IN  NUMBER,  
                                Pv_Observacion              IN  VARCHAR2,
                                Pv_UsrCreacion              IN  DB_COMERCIAL.INFO_PERSONA.LOGIN%TYPE,
                                Pv_CodEmpresa               IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Pv_IpCreacion               IN  VARCHAR2,
                                Pv_TipoPma                  IN  VARCHAR2,
                                Pn_IdMotivo                 IN  NUMBER,
                                Pv_MsjResultado             OUT VARCHAR2)
  IS  
    --Costo: 1
    CURSOR C_GetGrupoPromocion (Cn_IdGrupoPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS
      SELECT agp.nombre_grupo,
        agp.fe_inicio_vigencia,
        agp.fe_fin_vigencia,
        agp.empresa_cod,
        agp.grupo_promocion_id
      FROM db_comercial.admi_grupo_promocion agp
      WHERE agp.id_grupo_promocion = Cn_IdGrupoPromocion
      and agp.estado               != 'Eliminado';

    --Costo: 2
    CURSOR C_GetGrupoPromocionRegla (Cn_IdGrupoPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS            
      SELECT agpr.caracteristica_id,
        agpr.valor,
        agpr.estado,
        agpr.secuencia,
        agrupa.cantidad
      FROM db_comercial.admi_grupo_promocion_regla agpr,
        (SELECT agpr.secuencia,
           COUNT(agpr.secuencia) AS cantidad
         FROM db_comercial.admi_grupo_promocion_regla agpr
         WHERE agpr.grupo_promocion_id = Cn_IdGrupoPromocion
         AND agpr.estado               != 'Eliminado'
         GROUP BY agpr.secuencia )    agrupa
      WHERE agpr.grupo_promocion_id = Cn_IdGrupoPromocion
      AND agpr.estado               != 'Eliminado'
      AND agpr.secuencia            = agrupa.secuencia (+)
      ORDER BY agpr.secuencia;

    --Costo: 2
    CURSOR C_GetTipoPromocion (Cn_IdGrupoPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE)
    IS 
      SELECT atp.id_tipo_promocion,
        atp.codigo_tipo_promocion,
        atp.tipo,
        atp.tipo_promocion_id,
        atp.estado
      FROM db_comercial.admi_tipo_promocion atp
      WHERE atp.grupo_promocion_id = Cn_IdGrupoPromocion
      and atp.estado               != 'Eliminado';

    --Costo: 2
    CURSOR C_GetTipoPromocionRegla (Cn_IdGrupoPromocion   DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                    Cn_IdTipoPromocion    DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
    IS
      SELECT atpr.caracteristica_id,
        atpr.valor,
        atpr.estado,
        atpr.secuencia,
        agrupa.cantidad
      FROM db_comercial.admi_tipo_promocion     atp,
        db_comercial.admi_tipo_promocion_regla  atpr,
        (SELECT atpr.secuencia,
           COUNT(atpr.secuencia) AS cantidad
         FROM db_comercial.admi_tipo_promocion    atp,
           db_comercial.admi_tipo_promocion_regla atpr
         WHERE atp.grupo_promocion_id  = Cn_IdGrupoPromocion
         AND atp.id_tipo_promocion     = Cn_IdTipoPromocion
         AND atp.id_tipo_promocion     = atpr.tipo_promocion_id
         AND atpr.estado               != 'Eliminado'
         GROUP BY atpr.secuencia)                agrupa
      WHERE atp.grupo_promocion_id  = Cn_IdGrupoPromocion
      AND atp.id_tipo_promocion     = Cn_IdTipoPromocion
      AND atp.id_tipo_promocion     = atpr.tipo_promocion_id
      AND atpr.secuencia            = agrupa.secuencia (+)
      AND atpr.estado               != 'Eliminado'
      ORDER BY atpr.secuencia;

    --Costo: 2
    CURSOR C_GetTipoPLanProdPromo (Cn_IdTipoPromocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
    IS         
      SELECT atpp.plan_id,
        atpp.producto_id,
        atpp.solucion_id,
        atpp.plan_id_superior,
        atpp.estado
      FROM db_comercial.admi_tipo_plan_prod_promocion atpp
      WHERE atpp.tipo_promocion_id  = Cn_IdTipoPromocion
      AND atpp.estado               != 'Eliminado';

    Lv_MsjResultado             VARCHAR2(3200);    
    Lv_IpCreacion               VARCHAR2(20) := (NVL(Pv_IpCreacion,'127.0.0.1'));
    Lc_GetGrupoPromocion        C_GetGrupoPromocion%ROWTYPE;
    Lr_AdmiGrupoPromocion       DB_COMERCIAL.ADMI_GRUPO_PROMOCION%ROWTYPE;
    Ln_IdGrupoPromocion         DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    --
    Lr_AdmiGrupoPromocionRegla  DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA%ROWTYPE;
    Ln_IdGrupoPromocionRegla    DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.ID_GRUPO_PROMOCION_REGLA%TYPE;
    Ln_IdSecuencia              DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA.SECUENCIA%TYPE;
    Ln_Cantidad                 number := 0;
    Ln_Contador                 number := 0;
    --
    Lr_AdmiTipoPromocion        DB_COMERCIAL.ADMI_TIPO_PROMOCION%ROWTYPE;
    Ln_IdTipoPromocion          DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE;
    Ln_IdTipoPromocionOld       DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE;
    --
    Lr_AdmiTipoPromocionRegla   DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA%ROWTYPE;
    Ln_IdTipoPromocionregla     DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA.ID_TIPO_PROMOCION_REGLA %TYPE;
    --
    Lr_AdmiTipoPlaProdPromo     DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION%ROWTYPE;
    Ln_IdTipoPlanProdPromo      DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION.ID_TIPO_PLAN_PROD_PROMOCION%TYPE;
    --
    Lr_AdmiGrupoPromocionHist   DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO%ROWTYPE;
    Ln_IdGrupoPromocionHisto    DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO.ID_GRUPO_PROMOCION_HISTO%TYPE;

    Lex_Exception EXCEPTION;

  BEGIN
    --    
    IF C_GetGrupoPromocion%ISOPEN THEN
      --
      CLOSE C_GetGrupoPromocion;
      --
    END IF;
    --
    OPEN C_GetGrupoPromocion(Pn_IdGrupoPromocion);
    --
    FETCH C_GetGrupoPromocion INTO Lc_GetGrupoPromocion;
    --
      Ln_IdGrupoPromocion                         := DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION.NEXTVAL;
      Lr_AdmiGrupoPromocion                       := NULL;
      Lr_AdmiGrupoPromocion.ID_GRUPO_PROMOCION    := Ln_IdGrupoPromocion;
      Lr_AdmiGrupoPromocion.NOMBRE_GRUPO          := SUBSTR('CL_'||Lc_GetGrupoPromocion.NOMBRE_GRUPO,1,4000);
      Lr_AdmiGrupoPromocion.FE_INICIO_VIGENCIA    := Lc_GetGrupoPromocion.FE_INICIO_VIGENCIA;
      Lr_AdmiGrupoPromocion.FE_FIN_VIGENCIA       := Lc_GetGrupoPromocion.FE_FIN_VIGENCIA;
      Lr_AdmiGrupoPromocion.FE_CREACION           := SYSDATE;
      Lr_AdmiGrupoPromocion.USR_CREACION          := Pv_UsrCreacion;
      Lr_AdmiGrupoPromocion.IP_CREACION           := Lv_IpCreacion;
      Lr_AdmiGrupoPromocion.FE_ULT_MOD            := NULL;
      Lr_AdmiGrupoPromocion.USR_ULT_MOD           := NULL;
      Lr_AdmiGrupoPromocion.IP_ULT_MOD            := NULL;
      Lr_AdmiGrupoPromocion.EMPRESA_COD           := Lc_GetGrupoPromocion.EMPRESA_COD;
      Lr_AdmiGrupoPromocion.GRUPO_PROMOCION_ID    := Pn_IdGrupoPromocion;
      Lr_AdmiGrupoPromocion.ESTADO                := 'Pendiente';
      --
      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSRT_ADMI_GRUPO_PROMOCION(Lr_AdmiGrupoPromocion, Pv_MsjResultado);
      IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
      --
        RAISE Lex_Exception;
      --
      END IF;          
    --
    CLOSE C_GetGrupoPromocion;
    --
    FOR lc_GetGrupoPromocionRegla IN C_GetGrupoPromocionRegla (Pn_IdGrupoPromocion) LOOP
      Ln_IdGrupoPromocionRegla                            := DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_REGLA.NEXTVAL;
      Lr_AdmiGrupoPromocionRegla                          := NULL;
      Ln_Cantidad                                         := lc_GetGrupoPromocionRegla.CANTIDAD;
      IF (Ln_Cantidad > 0)THEN
        Ln_Contador := Ln_Contador + 1;
        IF(Ln_Contador = 1)THEN
          Ln_IdSecuencia                                  := DB_COMERCIAL.SEQ_ADMI_REGLA_SECUENCIA.NEXTVAL; 
        END IF;
        IF(Ln_Contador <= Ln_Cantidad)THEN
          Lr_AdmiGrupoPromocionRegla.SECUENCIA            := Ln_IdSecuencia;
        END IF;
        IF(Ln_Contador = Ln_Cantidad)THEN
          Ln_Contador := 0;
        END IF;
      ELSE
        Lr_AdmiGrupoPromocionRegla.SECUENCIA              := NULL;
      END IF;
      Lr_AdmiGrupoPromocionRegla.ID_GRUPO_PROMOCION_REGLA := Ln_IdGrupoPromocionRegla;
      Lr_AdmiGrupoPromocionRegla.GRUPO_PROMOCION_ID       := Ln_IdGrupoPromocion;
      Lr_AdmiGrupoPromocionRegla.CARACTERISTICA_ID        := lc_GetGrupoPromocionRegla.CARACTERISTICA_ID;
      Lr_AdmiGrupoPromocionRegla.VALOR                    := lc_GetGrupoPromocionRegla.VALOR;
      Lr_AdmiGrupoPromocionRegla.FE_CREACION              := SYSDATE;
      Lr_AdmiGrupoPromocionRegla.USR_CREACION             := Pv_UsrCreacion;
      Lr_AdmiGrupoPromocionRegla.IP_CREACION              := Lv_IpCreacion;
      Lr_AdmiGrupoPromocionRegla.FE_ULT_MOD               := NULL;
      Lr_AdmiGrupoPromocionRegla.USR_ULT_MOD              := NULL;
      Lr_AdmiGrupoPromocionRegla.IP_ULT_MOD               := NULL;
      Lr_AdmiGrupoPromocionRegla.ESTADO                   := 'Activo';
      --
      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSRT_ADMI_GRUPO_PROMO_REGLA(Lr_AdmiGrupoPromocionRegla, Pv_MsjResultado);
      IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
      --
        RAISE Lex_Exception;
      --
      END IF;
      --
    END LOOP;
    --
    FOR lc_GetTipoPromociona IN C_GetTipoPromocion (Pn_IdGrupoPromocion) LOOP
      Ln_IdTipoPromocionOld                       := lc_GetTipoPromociona.ID_TIPO_PROMOCION;
      Ln_IdTipoPromocion                          := DB_COMERCIAL.SEQ_ADMI_TIPO_PROMOCION.NEXTVAL;
      Lr_AdmiTipoPromocion                        := NULL;
      Lr_AdmiTipoPromocion.ID_TIPO_PROMOCION      := Ln_IdTipoPromocion;
      Lr_AdmiTipoPromocion.GRUPO_PROMOCION_ID     := Ln_IdGrupoPromocion;
      Lr_AdmiTipoPromocion.CODIGO_TIPO_PROMOCION  := lc_GetTipoPromociona.CODIGO_TIPO_PROMOCION;
      Lr_AdmiTipoPromocion.TIPO                   := lc_GetTipoPromociona.TIPO;
      Lr_AdmiTipoPromocion.FE_CREACION            := SYSDATE;
      Lr_AdmiTipoPromocion.USR_CREACION           := Pv_UsrCreacion;
      Lr_AdmiTipoPromocion.IP_CREACION            := Lv_IpCreacion;
      Lr_AdmiTipoPromocion.FE_ULT_MOD             := NULL;
      Lr_AdmiTipoPromocion.USR_ULT_MOD            := NULL;
      Lr_AdmiTipoPromocion.IP_ULT_MOD             := NULL;
      Lr_AdmiTipoPromocion.TIPO_PROMOCION_ID      := lc_GetTipoPromociona.ID_TIPO_PROMOCION;
      Lr_AdmiTipoPromocion.ESTADO                 := 'Activo';
      --
      DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSRT_ADMI_TIPO_PROMOCION(Lr_AdmiTipoPromocion, Pv_MsjResultado);
      IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
      --
        RAISE Lex_Exception;
      --
      END IF;
      --
      FOR lc_GetTipoPromociona IN C_GetTipoPromocionRegla (Pn_IdGrupoPromocion, Ln_IdTipoPromocionOld) LOOP
        Ln_IdTipoPromocionregla                             := DB_COMERCIAL.SEQ_ADMI_TIPO_PROMOCION_REGLA.NEXTVAL;
        Lr_AdmiTipoPromocionRegla                           := NULL;
        Ln_Cantidad                                         := lc_GetTipoPromociona.CANTIDAD;
        IF (Ln_Cantidad > 0)THEN
          Ln_Contador := Ln_Contador + 1;
          IF(Ln_Contador = 1)THEN
            Ln_IdSecuencia                                  := DB_COMERCIAL.SEQ_ADMI_REGLA_SECUENCIA.NEXTVAL; 
          END IF;
          IF(Ln_Contador <= Ln_Cantidad)THEN
            Lr_AdmiTipoPromocionRegla.SECUENCIA             := Ln_IdSecuencia;
          END IF;
          IF(Ln_Contador = Ln_Cantidad)THEN
            Ln_Contador := 0;
          END IF;
        ELSE
          Lr_AdmiTipoPromocionRegla.SECUENCIA               := NULL;
        END IF;
        Lr_AdmiTipoPromocionRegla.ID_TIPO_PROMOCION_REGLA   := Ln_IdTipoPromocionregla;
        Lr_AdmiTipoPromocionRegla.TIPO_PROMOCION_ID         := Ln_IdTipoPromocion;
        Lr_AdmiTipoPromocionRegla.CARACTERISTICA_ID         := lc_GetTipoPromociona.CARACTERISTICA_ID;
        Lr_AdmiTipoPromocionRegla.VALOR                     := lc_GetTipoPromociona.VALOR;
        Lr_AdmiTipoPromocionRegla.FE_CREACION               := SYSDATE;
        Lr_AdmiTipoPromocionRegla.USR_CREACION              := Pv_UsrCreacion;
        Lr_AdmiTipoPromocionRegla.IP_CREACION               := Lv_IpCreacion;
        Lr_AdmiTipoPromocionRegla.FE_ULT_MOD                := NULL;
        Lr_AdmiTipoPromocionRegla.USR_ULT_MOD               := NULL;
        Lr_AdmiTipoPromocionRegla.IP_ULT_MOD                := NULL;
        Lr_AdmiTipoPromocionRegla.ESTADO                    := 'Activo';
        --
        DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSRT_ADMI_TIPO_PROMO_REGLA(Lr_AdmiTipoPromocionRegla, Pv_MsjResultado);
        IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
        --
          RAISE Lex_Exception;
        --
        END IF;
      --
      END LOOP;
      --
      FOR lc_GetTipoPLanProdPromo IN C_GetTipoPLanProdPromo (Ln_IdTipoPromocionOld) LOOP
        Ln_IdTipoPlanProdPromo                              := DB_COMERCIAL.SEQ_ADMI_TIPO_PLAN_PROD_PROMO.NEXTVAL;
        Lr_AdmiTipoPlaProdPromo                             := NULL;
        Lr_AdmiTipoPlaProdPromo.ID_TIPO_PLAN_PROD_PROMOCION := Ln_IdTipoPlanProdPromo;
        Lr_AdmiTipoPlaProdPromo.TIPO_PROMOCION_ID           := Ln_IdTipoPromocion;
        Lr_AdmiTipoPlaProdPromo.PLAN_ID                     := lc_GetTipoPLanProdPromo.PLAN_ID;
        Lr_AdmiTipoPlaProdPromo.PRODUCTO_ID                 := lc_GetTipoPLanProdPromo.PRODUCTO_ID;
        Lr_AdmiTipoPlaProdPromo.SOLUCION_ID                 := lc_GetTipoPLanProdPromo.SOLUCION_ID;
        Lr_AdmiTipoPlaProdPromo.PLAN_ID_SUPERIOR            := lc_GetTipoPLanProdPromo.PLAN_ID_SUPERIOR;
        Lr_AdmiTipoPlaProdPromo.FE_CREACION                 := SYSDATE;
        Lr_AdmiTipoPlaProdPromo.USR_CREACION                := Pv_UsrCreacion;
        Lr_AdmiTipoPlaProdPromo.IP_CREACION                 := Lv_IpCreacion;
        Lr_AdmiTipoPlaProdPromo.FE_ULT_MOD                  := NULL;
        Lr_AdmiTipoPlaProdPromo.USR_ULT_MOD                 := NULL;
        Lr_AdmiTipoPlaProdPromo.IP_ULT_MOD                  := NULL;
        Lr_AdmiTipoPlaProdPromo.ESTADO                      := 'Activo';
        --
        DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSRT_ADMITIPOPLANPRODPROMO(Lr_AdmiTipoPlaProdPromo, Pv_MsjResultado);
        IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
        --
          RAISE Lex_Exception;
        --
        END IF;
      --
      END LOOP;
    --
    END LOOP;

    Ln_IdGrupoPromocionHisto                            := DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL;
    Lr_AdmiGrupoPromocionHist                           := NULL;
    Lr_AdmiGrupoPromocionHist.ID_GRUPO_PROMOCION_HISTO  := Ln_IdGrupoPromocionHisto;
    Lr_AdmiGrupoPromocionHist.GRUPO_PROMOCION_ID        := Ln_IdGrupoPromocion;
    Lr_AdmiGrupoPromocionHist.MOTIVO_ID                 := Pn_IdMotivo;
    Lr_AdmiGrupoPromocionHist.FE_CREACION               := SYSDATE;
    Lr_AdmiGrupoPromocionHist.USR_CREACION              := Pv_UsrCreacion;
    Lr_AdmiGrupoPromocionHist.IP_CREACION               := Lv_IpCreacion;
    Lr_AdmiGrupoPromocionHist.OBSERVACION               := 'Se clona promoci�n de la promoci�n origen ' || Pn_IdGrupoPromocion;
    Lr_AdmiGrupoPromocionHist.ESTADO                    := 'Activo';
    --
    DB_COMERCIAL.CMKG_GRUPO_PROMOCIONES.P_INSRT_ADMI_GRUPO_PROMO_HIST(Lr_AdmiGrupoPromocionHist, Pv_MsjResultado);
    IF TRIM(Pv_MsjResultado) IS NOT NULL THEN
    --
      RAISE Lex_Exception;
    --
    END IF;
  --
  EXCEPTION
    WHEN Lex_Exception THEN
      --
      Lv_MsjResultado      := 'Ocurri� un error al guardar el Proceso Masivo '||Pv_TipoPma; 

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_GRUPO_PROMOCIONES.P_CLONA_PROMOCIONES', 
                                           Lv_MsjResultado || ' - ' || Pv_MsjResultado,
                                           'telcos_pms_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));
    WHEN OTHERS THEN
      --
      Pv_MsjResultado      := 'Ocurri� un error al guardar el Proceso Masivo '||Pv_TipoPma; 

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                           'CMKG_GRUPO_PROMOCIONES.P_CLONA_PROMOCIONES', 
                                           Pv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                           'telcos_pms_promo',
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), Lv_IpCreacion));        
  END P_CLONA_PROMOCIONES;

  PROCEDURE P_INSRT_ADMI_GRUPO_PROMOCION(Prf_AdmiGrupoPromocion IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION%ROWTYPE,
                                         Pv_MsjResultado        OUT VARCHAR2) AS
  BEGIN
    INSERT INTO 
    DB_COMERCIAL.ADMI_GRUPO_PROMOCION
    (ID_GRUPO_PROMOCION,
     NOMBRE_GRUPO,
     FE_INICIO_VIGENCIA,
     FE_FIN_VIGENCIA,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     FE_ULT_MOD,
     USR_ULT_MOD,
     IP_ULT_MOD,
     EMPRESA_COD,
     GRUPO_PROMOCION_ID,
     ESTADO) 
    VALUES
    (Prf_AdmiGrupoPromocion.ID_GRUPO_PROMOCION,
     Prf_AdmiGrupoPromocion.NOMBRE_GRUPO,
     Prf_AdmiGrupoPromocion.FE_INICIO_VIGENCIA,
     Prf_AdmiGrupoPromocion.FE_FIN_VIGENCIA,
     Prf_AdmiGrupoPromocion.FE_CREACION,
     Prf_AdmiGrupoPromocion.USR_CREACION,
     Prf_AdmiGrupoPromocion.IP_CREACION,
     Prf_AdmiGrupoPromocion.FE_ULT_MOD,
     Prf_AdmiGrupoPromocion.USR_ULT_MOD,
     Prf_AdmiGrupoPromocion.USR_ULT_MOD,
     Prf_AdmiGrupoPromocion.EMPRESA_COD,
     Prf_AdmiGrupoPromocion.GRUPO_PROMOCION_ID,
     Prf_AdmiGrupoPromocion.ESTADO);
    --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_INSERT_ADMI_GRUPO_PROMOCION - ' || SQLERRM;
  END P_INSRT_ADMI_GRUPO_PROMOCION;

  PROCEDURE P_INSRT_ADMI_GRUPO_PROMO_REGLA(Prf_AdmiGrupoPromocionRegla  IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA%ROWTYPE,
                                           Pv_MsjResultado              OUT VARCHAR2) AS
  BEGIN
    INSERT INTO 
    DB_COMERCIAL.ADMI_GRUPO_PROMOCION_REGLA
    (ID_GRUPO_PROMOCION_REGLA,
     GRUPO_PROMOCION_ID,
     CARACTERISTICA_ID,
     VALOR,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     FE_ULT_MOD,
     USR_ULT_MOD,
     IP_ULT_MOD,
     ESTADO,
     SECUENCIA) 
    VALUES
    (Prf_AdmiGrupoPromocionRegla.ID_GRUPO_PROMOCION_REGLA,
     Prf_AdmiGrupoPromocionRegla.GRUPO_PROMOCION_ID,
     Prf_AdmiGrupoPromocionRegla.CARACTERISTICA_ID,
     Prf_AdmiGrupoPromocionRegla.VALOR,
     Prf_AdmiGrupoPromocionRegla.FE_CREACION,
     Prf_AdmiGrupoPromocionRegla.USR_CREACION,
     Prf_AdmiGrupoPromocionRegla.IP_CREACION,
     Prf_AdmiGrupoPromocionRegla.FE_ULT_MOD,
     Prf_AdmiGrupoPromocionRegla.USR_ULT_MOD,
     Prf_AdmiGrupoPromocionRegla.IP_ULT_MOD,
     Prf_AdmiGrupoPromocionRegla.ESTADO,
     Prf_AdmiGrupoPromocionRegla.SECUENCIA);
    --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_INSERT_ADMI_GRUPO_PROMOCION_REGLA - ' || SQLERRM;
  END P_INSRT_ADMI_GRUPO_PROMO_REGLA;

  PROCEDURE P_INSRT_ADMI_TIPO_PROMOCION(Prf_AdmiTipoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION%ROWTYPE,
                                        Pv_MsjResultado       OUT VARCHAR2) AS
  BEGIN
    INSERT INTO 
    DB_COMERCIAL.ADMI_TIPO_PROMOCION
    (ID_TIPO_PROMOCION,
     GRUPO_PROMOCION_ID,
     CODIGO_TIPO_PROMOCION,
     TIPO,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     FE_ULT_MOD,
     USR_ULT_MOD,
     IP_ULT_MOD,
     TIPO_PROMOCION_ID,
     ESTADO) 
    VALUES
    (Prf_AdmiTipoPromocion.ID_TIPO_PROMOCION,
     Prf_AdmiTipoPromocion.GRUPO_PROMOCION_ID,
     Prf_AdmiTipoPromocion.CODIGO_TIPO_PROMOCION,
     Prf_AdmiTipoPromocion.TIPO,
     Prf_AdmiTipoPromocion.FE_CREACION,
     Prf_AdmiTipoPromocion.USR_CREACION,
     Prf_AdmiTipoPromocion.IP_CREACION,
     Prf_AdmiTipoPromocion.FE_ULT_MOD,
     Prf_AdmiTipoPromocion.USR_ULT_MOD,
     Prf_AdmiTipoPromocion.IP_ULT_MOD,
     Prf_AdmiTipoPromocion.TIPO_PROMOCION_ID,
     Prf_AdmiTipoPromocion.ESTADO);
    --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_INSERT_ADMI_TIPO_PROMOCION - ' || SQLERRM;
  END P_INSRT_ADMI_TIPO_PROMOCION;

  PROCEDURE P_INSRT_ADMI_TIPO_PROMO_REGLA(Prf_AdmiTipoPromoRegla  IN DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA%ROWTYPE,
                                          Pv_MsjResultado         OUT VARCHAR2) AS
  BEGIN
    INSERT INTO 
    DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA
    (ID_TIPO_PROMOCION_REGLA,
     TIPO_PROMOCION_ID,
     CARACTERISTICA_ID,
     VALOR,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     FE_ULT_MOD,
     USR_ULT_MOD,
     IP_ULT_MOD,
     ESTADO,
     SECUENCIA) 
    VALUES
    (Prf_AdmiTipoPromoRegla.ID_TIPO_PROMOCION_REGLA,
     Prf_AdmiTipoPromoRegla.TIPO_PROMOCION_ID,
     Prf_AdmiTipoPromoRegla.CARACTERISTICA_ID,
     Prf_AdmiTipoPromoRegla.VALOR,
     Prf_AdmiTipoPromoRegla.FE_CREACION,
     Prf_AdmiTipoPromoRegla.USR_CREACION,
     Prf_AdmiTipoPromoRegla.IP_CREACION,
     Prf_AdmiTipoPromoRegla.FE_ULT_MOD,
     Prf_AdmiTipoPromoRegla.USR_ULT_MOD,
     Prf_AdmiTipoPromoRegla.IP_ULT_MOD,
     Prf_AdmiTipoPromoRegla.ESTADO,
     Prf_AdmiTipoPromoRegla.SECUENCIA);
    --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_INSERT_ADMI_TIPO_PROMOCION_REGLA - ' || SQLERRM;
  END P_INSRT_ADMI_TIPO_PROMO_REGLA;

  PROCEDURE P_INSRT_ADMITIPOPLANPRODPROMO(Prf_AdmiTipoPlanProndPromo  IN DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION%ROWTYPE,
                                          Pv_MsjResultado             OUT VARCHAR2) AS
  BEGIN
    INSERT INTO 
    DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION
    (ID_TIPO_PLAN_PROD_PROMOCION,
     TIPO_PROMOCION_ID,
     PLAN_ID,
     PRODUCTO_ID,
     SOLUCION_ID,
     PLAN_ID_SUPERIOR,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     FE_ULT_MOD,
     USR_ULT_MOD,
     IP_ULT_MOD,
     ESTADO) 
    VALUES
    (Prf_AdmiTipoPlanProndPromo.ID_TIPO_PLAN_PROD_PROMOCION,
     Prf_AdmiTipoPlanProndPromo.TIPO_PROMOCION_ID,
     Prf_AdmiTipoPlanProndPromo.PLAN_ID,
     Prf_AdmiTipoPlanProndPromo.PRODUCTO_ID,
     Prf_AdmiTipoPlanProndPromo.SOLUCION_ID,
     Prf_AdmiTipoPlanProndPromo.PLAN_ID_SUPERIOR,
     Prf_AdmiTipoPlanProndPromo.FE_CREACION,
     Prf_AdmiTipoPlanProndPromo.USR_CREACION,
     Prf_AdmiTipoPlanProndPromo.IP_CREACION,
     Prf_AdmiTipoPlanProndPromo.FE_ULT_MOD,
     Prf_AdmiTipoPlanProndPromo.USR_ULT_MOD,
     Prf_AdmiTipoPlanProndPromo.IP_ULT_MOD,
     Prf_AdmiTipoPlanProndPromo.ESTADO);
    --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_INSERT_ADMITIPOPLANPRODPROMO - ' || SQLERRM;
  END P_INSRT_ADMITIPOPLANPRODPROMO;

  PROCEDURE P_INSRT_ADMI_GRUPO_PROMO_HIST(Prf_AdmiGrupoPromoHist  IN DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO%ROWTYPE,
                                          Pv_MsjResultado         OUT VARCHAR2) AS
  BEGIN
    INSERT INTO 
    DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
    (ID_GRUPO_PROMOCION_HISTO,
     GRUPO_PROMOCION_ID,
     MOTIVO_ID,
     FE_CREACION,
     USR_CREACION,
     IP_CREACION,
     OBSERVACION,
     ESTADO) 
    VALUES
    (Prf_AdmiGrupoPromoHist.ID_GRUPO_PROMOCION_HISTO,
     Prf_AdmiGrupoPromoHist.GRUPO_PROMOCION_ID,
     Prf_AdmiGrupoPromoHist.MOTIVO_ID,
     Prf_AdmiGrupoPromoHist.FE_CREACION,
     Prf_AdmiGrupoPromoHist.USR_CREACION,
     Prf_AdmiGrupoPromoHist.IP_CREACION,
     Prf_AdmiGrupoPromoHist.OBSERVACION,
     Prf_AdmiGrupoPromoHist.ESTADO);
    --
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Pv_MsjResultado := 'Error en P_INSERT_ADMI_GRUPO_PROMOHISTO - ' || SQLERRM;
  END P_INSRT_ADMI_GRUPO_PROMO_HIST;
  
END CMKG_GRUPO_PROMOCIONES;
/