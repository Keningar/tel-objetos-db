CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_PROMOCIONES_INS AS 

 /**
  * Documentación para PROCESO 'P_PROCESO_MAPEO_PROM_INS'.
  *
  * Proceso encargado de evaluar reglas de configuración de una promoción, para ser otorgada a los cliente que su estado de 
  * servicio este factible.
  *
  * Costo del Query C_GetEmpresa: 0
  * Costo del Query C_GetErrorRepetido: 11
  * Costo del Query C_GetInfoServicio: 5
  * Costo del Query C_GetIdPromocion: 16
  *
  * PARAMETROS:
  * @Param Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE
  * @Param Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE
  * @Param Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE
  * @Param Pv_Mensaje              OUT VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-09-2019
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.1 03-09-2020 - Se realiza cambio para que se consuma el nuevo proceso que obtiene los tipos de promociones ordenados
  *                           por prioridad de sectorización.
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.2 10-11-2020 - Se realiza cambio en el proceso para considerar los servicios que tienen como característica activa un 
  *                           código promocional.
  *
  * @author Hector Lozano <hlozano@telconet.ec>
  * @version 1.3  31-05-2022
  * Se agregan logs para monitorear el proceso de mapeo de promociones de Instalacion.
  */ 
  PROCEDURE P_PROCESO_MAPEO_PROM_INS(Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pv_CodigoGrupoPromocion IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_EsCodigo             IN VARCHAR2 DEFAULT NULL,
                                     Pv_Mensaje              OUT VARCHAR2);

  /**
  * Documentación para TYPE 'Lr_ServClientesProcesar'.
  *  
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE Lr_ServClientesProcesar IS RECORD (
    ID_PERSONA_ROL         DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
    ID_PUNTO               DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
    COD_EMPRESA            DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
    SERVICIO_ID            DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
    ESTADO                 DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
    ID_PLAN                DB_COMERCIAL.INFO_SERVICIO.PLAN_ID%TYPE);

  /**
  * Documentación para TYPE 'T_ServClientesProcesar'.
  * Record para almacenar la data enviada al BULK.
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 05-06-2019
  */
  TYPE T_ServClientesProcesar IS TABLE OF Lr_ServClientesProcesar INDEX BY PLS_INTEGER;

  /**
  * Documentación para PROCEDURE 'P_MAPEO_PROMO_INS'.
  *
  * Proceso encargado de insertar todos los mapeos por la cantidad de periodos configurados en una promoción de instalación
  * generar los historiales del servicio, historial de mapeo y mapeo de servicio beneficiado.
  *
  * PARAMETROS:
  * @Param Pr_Punto                IN Lr_ServClientesProcesar
  * @Param Pa_ServiciosCumplePromo IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear
  * @Param Pr_TiposPromociones     IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar
  * @Param Pr_TipoPromoRegla       IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar
  * @Param Pv_TipoProceso          IN VARCHAR2
  * @Param Pv_Trama                IN VARCHAR2
  * @Param Pv_MsjResultado         OUT VARCHAR2
  *
  * @author José Candelario <jcandelario@telconet.ec>
  * @version 1.0 23-09-2019
  */
  PROCEDURE P_MAPEO_PROMO_INS (Pr_Punto                 IN Lr_ServClientesProcesar,
                               Pa_ServiciosCumplePromo  IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear,
                               Pr_TiposPromociones      IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar,
                               Pr_TipoPromoRegla        IN DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar,
                               Pv_TipoProceso           IN VARCHAR2,
                               Pv_Trama                 IN VARCHAR2,
                               Pv_MsjResultado          OUT VARCHAR2);
END CMKG_PROMOCIONES_INS;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_PROMOCIONES_BW AS
  
  PROCEDURE P_UPDATE_PROCESO_TRASLADO(Pn_IdGrupoPromocion   IN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.GRUPO_PROMOCION_ID%TYPE,
                                      Pn_IdTipoPromocion    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                      Pv_TipoPromocion      IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                      Pv_CodEmpresa         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pn_IdPunto            IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pn_IdServOrigen       IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE, 
                                      Pv_Trama              IN VARCHAR2,
                                      Pv_MsjResultado       OUT VARCHAR2) 
  IS
    --
    Lex_Exception           EXCEPTION;
    Lv_MsjResultado         VARCHAR2(4000);
    Lv_EstadoActivo         VARCHAR2(20):= 'Activo'; 
    Lv_UsuarioCreacion      VARCHAR2(15):= 'telcos_promo_bw';
    Lv_IpCreacion           VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
    Lr_InfoDetalleMapeoHisto  DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE;
    Lr_InfoDetMapSolicitud    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE; 
    Lr_InfoProcesoRDA         DB_COMERCIAL.CMKG_PROMOCIONES_BW.Gr_ProcesoPromo; 
    La_PromocionExterna       DB_EXTERNO.Gtl_Promociones;
    --
    --Costo C_ObtieneMapeosPromo: 2
    CURSOR C_ObtieneMapeosPromo(Cn_IdGrupoPromocion   DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.GRUPO_PROMOCION_ID%TYPE,
                                Cn_IdTipoPromocion    DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                Cv_TipoPromocion      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                Cv_CodEmpresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Cv_Estado             DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE,
                                Cn_IdServOrigen       DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS  
      SELECT IDMP.*
      FROM  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
      WHERE IDMP.ID_DETALLE_MAPEO   = IDMS.DETALLE_MAPEO_ID  
      AND IDMP.GRUPO_PROMOCION_ID   = Cn_IdGrupoPromocion
      AND IDMP.TIPO_PROMOCION_ID    = Cn_IdTipoPromocion
      AND IDMP.TIPO_PROMOCION       = Cv_TipoPromocion
      AND IDMP.EMPRESA_COD          = Cv_CodEmpresa
      AND IDMP.ESTADO               = Cv_Estado
      AND IDMS.SERVICIO_ID          = Cn_IdServOrigen;
    --
  BEGIN
    --
    IF C_ObtieneMapeosPromo%ISOPEN THEN
      CLOSE C_ObtieneMapeosPromo;
    END IF;
    --
    FOR Lc_DetalleMapeoPromo IN C_ObtieneMapeosPromo(Pn_IdGrupoPromocion,
                                                     Pn_IdTipoPromocion,
                                                     Pv_TipoPromocion,
                                                     Pv_CodEmpresa,
                                                     Lv_EstadoActivo,
                                                     Pn_IdServOrigen)
    LOOP   
      --
      Lr_InfoDetalleMapeoPromo                        := NULL;
      Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO       := Lc_DetalleMapeoPromo.ID_DETALLE_MAPEO;
      Lr_InfoDetalleMapeoPromo.PUNTO_ID               := Pn_IdPunto;
      Lr_InfoDetalleMapeoPromo.TRAMA                  := Pv_Trama;
      Lr_InfoDetalleMapeoPromo.FE_ULT_MOD             := SYSDATE;
      Lr_InfoDetalleMapeoPromo.USR_ULT_MOD            := Lv_UsuarioCreacion;
      Lr_InfoDetalleMapeoPromo.IP_ULT_MOD             := Lv_IpCreacion;

      DB_COMERCIAL.CMKG_PROMOCIONES.P_UPDATE_DETALLE_MAPEO_PROM(Lr_InfoDetalleMapeoPromo, Lv_MsjResultado);
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      END IF;  
      --
      Lr_InfoDetMapSolicitud                     := NULL;
      Lr_InfoDetMapSolicitud.DETALLE_MAPEO_ID    := Lc_DetalleMapeoPromo.ID_DETALLE_MAPEO;
      Lr_InfoDetMapSolicitud.SERVICIO_ID         := Pn_IdServicio;
      Lr_InfoDetMapSolicitud.FE_ULT_MOD          := SYSDATE;
      Lr_InfoDetMapSolicitud.USR_ULT_MOD         := Lv_UsuarioCreacion;
      Lr_InfoDetMapSolicitud.IP_ULT_MOD          := Lv_IpCreacion;

      DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_UPDATE_MAP_SOLIC_TRASLADO(Lr_InfoDetMapSolicitud,Lv_MsjResultado);
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      END IF;  
      --
      Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
      Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Lc_DetalleMapeoPromo.ID_DETALLE_MAPEO;
      Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
      Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_UsuarioCreacion;
      Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
      Lr_InfoDetalleMapeoHisto.OBSERVACION             := 'Se actualizó correctamente el mapeo de la Promoción: '
                                                          ||Lc_DetalleMapeoPromo.TIPO_PROMOCION
                                                          ||', Grupo-Promocional: '||Lc_DetalleMapeoPromo.GRUPO_PROMOCION_ID
                                                          ||', Fecha-Mapeo: '||TO_CHAR(Lc_DetalleMapeoPromo.FE_MAPEO)
                                                          ||', Punto-Traslado: '||Pn_IdPunto;
      Lr_InfoDetalleMapeoHisto.ESTADO                  := Lc_DetalleMapeoPromo.ESTADO;
      --
      DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto, Lv_MsjResultado);      
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      END IF;    
      --      
      La_PromocionExterna := DB_EXTERNO.Gtl_Promociones();
      La_PromocionExterna.EXTEND(1);      
      La_PromocionExterna(1) := DB_EXTERNO.Gr_Promocion(NULL,
                                                        Lc_DetalleMapeoPromo.ID_DETALLE_MAPEO,
                                                        'Baja',
                                                        'La promoción fué dada de baja, ID_DETALLE_MAPEO: '
                                                         ||Lc_DetalleMapeoPromo.ID_DETALLE_MAPEO,
                                                        'BAJA',
                                                        NULL);

      DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_UPDATE_PROMOCIONES(La_PromocionExterna,
                                                           Lv_UsuarioCreacion,
                                                           Lv_IpCreacion,
                                                           Lv_MsjResultado);
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      END IF;  
      --
      --
      Lr_InfoProcesoRDA                    := NULL;
      Lr_InfoProcesoRDA.EMPRESA_COD        := Pv_CodEmpresa;
      Lr_InfoProcesoRDA.SERVICIO_ID        := Pn_IdServicio;
      Lr_InfoProcesoRDA.DETALLE_MAPEO_ID   := Lc_DetalleMapeoPromo.ID_DETALLE_MAPEO;
      Lr_InfoProcesoRDA.FE_INI_MAPEO       := Lc_DetalleMapeoPromo.FE_MAPEO;
      Lr_InfoProcesoRDA.FE_FIN_MAPEO       := ADD_MONTHS(Lc_DetalleMapeoPromo.FE_MAPEO,1);
      Lr_InfoProcesoRDA.USR_CREACION       := Lv_UsuarioCreacion;
      Lr_InfoProcesoRDA.IP_CREACION        := Lv_IpCreacion;
      Lr_InfoProcesoRDA.TIPO_PROCESO       := 'AplicaPromo';
      Lr_InfoProcesoRDA.TIPO_PROMO         := 'PROM_BW';
      --
      DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PREPARA_DATA_PROCESO_PROMO(Lr_InfoProcesoRDA, Lv_MsjResultado);
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      END IF;  
      --
      Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
      Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Lc_DetalleMapeoPromo.ID_DETALLE_MAPEO;
      Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
      Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_UsuarioCreacion;
      Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
      Lr_InfoDetalleMapeoHisto.OBSERVACION             := 'Se ingresó correctamente la información para RDA, tipo de proceso AplicaPromo, con Id_Detalle_Mapeo: '
                                                          ||Lc_DetalleMapeoPromo.ID_DETALLE_MAPEO;
      Lr_InfoDetalleMapeoHisto.ESTADO                  := 'Activo';
      --
      DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto, Lv_MsjResultado);      
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      END IF;
      --
    END LOOP;  
  --
  EXCEPTION
    WHEN Lex_Exception THEN
    Pv_MsjResultado := 'Error en P_UPDATE_PROCESO_TRASLADO - ' || SQLERRM;

  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_UPDATE_PROCESO_TRASLADO - ' || SQLERRM;

  END P_UPDATE_PROCESO_TRASLADO;
  --
  --
  --
  PROCEDURE P_UPDATE_PROCESO_CAMBIO_PLAN(Pv_TipoPromocion   IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                         Pv_CodEmpresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                         Pn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                         Pn_IdPlan          IN DB_COMERCIAL.INFO_SERVICIO.PLAN_ID%TYPE,
                                         Pn_IdPlanSuperior  IN DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.PLAN_ID_SUPERIOR%TYPE,
                                         Pv_MsjResultado   OUT VARCHAR2) 
  IS
    --
    Lex_Exception             EXCEPTION;
    Lv_MsjResultado           VARCHAR2(4000);
    Lv_EstadoActivo           VARCHAR2(20):= 'Activo'; 
    Lv_UsuarioCreacion        VARCHAR2(15):= 'telcos_promo_bw';
    Lv_NombreParametro        VARCHAR2(50):= 'PROM_TIPO_PROMOCIONES';
    Lv_IpCreacion             VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
    Lr_InfoDetalleMapeoHisto  DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
    Lr_InfoDetMapSolicitud    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE; 
    --
    --Costo C_DetalleMapeoSolicitud: 81
    CURSOR C_DetalleMapeoSolicitud(Cv_TipoPromocion   DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                   Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                   Cn_IdServicio      DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Cv_NombreParametro DB_GENERAL.ADMI_PARAMETRO_CAB.NOMBRE_PARAMETRO%TYPE,
                                   Cv_EstadoActivo    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.ESTADO%TYPE)
    IS  
      SELECT  IDMS.*
      FROM 
        DB_COMERCIAL.ADMI_TIPO_PROMOCION TPROMO, 
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION GPROMO,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE
          CAB.NOMBRE_PARAMETRO          = Cv_NombreParametro   
      AND CAB.ESTADO                    = Cv_EstadoActivo
      AND DET.ESTADO                    = Cv_EstadoActivo
      AND DET.EMPRESA_COD               = Cv_CodEmpresa
      AND DET.VALOR3                    = Cv_TipoPromocion
      AND CAB.ID_PARAMETRO              = DET.PARAMETRO_ID
      AND TPROMO.CODIGO_TIPO_PROMOCION  = DET.VALOR2
      AND TPROMO.GRUPO_PROMOCION_ID     = GPROMO.ID_GRUPO_PROMOCION
      AND TPROMO.ID_TIPO_PROMOCION      = IDMP.TIPO_PROMOCION_ID
      AND IDMP.ID_DETALLE_MAPEO         = IDMS.DETALLE_MAPEO_ID  
      AND IDMP.ESTADO                   = Cv_EstadoActivo
      AND IDMS.ESTADO                   = Cv_EstadoActivo
      AND GPROMO.EMPRESA_COD            = Cv_CodEmpresa
      AND IDMS.SERVICIO_ID              = Cn_IdServicio;
  --
  BEGIN
  --
    IF C_DetalleMapeoSolicitud%ISOPEN THEN
      CLOSE C_DetalleMapeoSolicitud;
    END IF;
    --
    FOR Lc_DetalleMapeoSolicitud IN C_DetalleMapeoSolicitud(Pv_TipoPromocion,
                                                            Pv_CodEmpresa,
                                                            Pn_IdServicio,
                                                            Lv_NombreParametro,
                                                            Lv_EstadoActivo)
    LOOP   
      --
      Lr_InfoDetMapSolicitud                     := NULL;
      Lr_InfoDetMapSolicitud.ID_MAPEO_SOLICITUD  := Lc_DetalleMapeoSolicitud.ID_MAPEO_SOLICITUD;
      Lr_InfoDetMapSolicitud.PLAN_ID             := Pn_IdPlan;
      Lr_InfoDetMapSolicitud.PLAN_ID_SUPERIOR    := Pn_IdPlanSuperior;
      Lr_InfoDetMapSolicitud.FE_ULT_MOD          := SYSDATE;
      Lr_InfoDetMapSolicitud.USR_ULT_MOD         := Lv_UsuarioCreacion;
      Lr_InfoDetMapSolicitud.IP_ULT_MOD          := Lv_IpCreacion;
      --
      DB_COMERCIAL.CMKG_PROMOCIONES.P_UPDATE_DET_MAP_SOLIC(Lr_InfoDetMapSolicitud,Lv_MsjResultado);
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      END IF;  
      --
      Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
      Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Lc_DetalleMapeoSolicitud.DETALLE_MAPEO_ID;
      Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
      Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_UsuarioCreacion;
      Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
      Lr_InfoDetalleMapeoHisto.OBSERVACION             := 'Se actualizó correctamente el Detalle Mapeo Solicitud: '
                                                          ||Lc_DetalleMapeoSolicitud.DETALLE_MAPEO_ID
                                                          ||', SERVICIO_ID-Cambio_plan: '||TO_CHAR(Lc_DetalleMapeoSolicitud.SERVICIO_ID)
                                                          ||', PLAN_ID-Cambio_plan: '||Pn_IdPlan
                                                          ||', PLAN_ID_SUPERIOR-Cambio_plan: '||Pn_IdPlanSuperior;
      Lr_InfoDetalleMapeoHisto.ESTADO                  := Lc_DetalleMapeoSolicitud.ESTADO;
      --
      DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto, Lv_MsjResultado);      
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Lex_Exception;
      END IF;   
      --
    END LOOP;  
  --
  EXCEPTION
    WHEN Lex_Exception THEN
    Pv_MsjResultado := 'Error en P_UPDATE_PROCESO_CAMBIO_PLAN - ' || SQLERRM;

  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_UPDATE_PROCESO_CAMBIO_PLAN - ' || SQLERRM;
  --
  END P_UPDATE_PROCESO_CAMBIO_PLAN;
  --
  --
  --
  PROCEDURE P_UPDATE_MAP_SOLIC_TRASLADO(Pr_InfoDetMapSolicitud   IN DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE,
                                        Pv_MsjResultado         OUT VARCHAR2)
  IS
  BEGIN
    --
    UPDATE DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD
    SET 
      DETALLE_MAPEO_ID     = NVL(Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID,DETALLE_MAPEO_ID),
      SERVICIO_ID          = NVL(Pr_InfoDetMapSolicitud.SERVICIO_ID,SERVICIO_ID),
      PLAN_ID              = NVL(Pr_InfoDetMapSolicitud.PLAN_ID,PLAN_ID),
      PRODUCTO_ID          = NVL(Pr_InfoDetMapSolicitud.PRODUCTO_ID,PRODUCTO_ID),
      PLAN_ID_SUPERIOR     = NVL(Pr_InfoDetMapSolicitud.PLAN_ID_SUPERIOR,PLAN_ID_SUPERIOR),
      SOLICITUD_ID         = NVL(Pr_InfoDetMapSolicitud.SOLICITUD_ID,SOLICITUD_ID),
      FE_CREACION          = NVL(Pr_InfoDetMapSolicitud.FE_CREACION,FE_CREACION),
      USR_CREACION         = NVL(Pr_InfoDetMapSolicitud.USR_CREACION,USR_CREACION),
      IP_CREACION          = NVL(Pr_InfoDetMapSolicitud.IP_CREACION,IP_CREACION),
      FE_ULT_MOD           = NVL(Pr_InfoDetMapSolicitud.FE_ULT_MOD,FE_ULT_MOD),
      USR_ULT_MOD          = NVL(Pr_InfoDetMapSolicitud.USR_ULT_MOD,USR_ULT_MOD),
      IP_ULT_MOD           = NVL(Pr_InfoDetMapSolicitud.IP_ULT_MOD,IP_ULT_MOD),
      ESTADO               = NVL(Pr_InfoDetMapSolicitud.ESTADO,ESTADO)
    WHERE DETALLE_MAPEO_ID = NVL(Pr_InfoDetMapSolicitud.DETALLE_MAPEO_ID,DETALLE_MAPEO_ID);
  --
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MsjResultado := 'Error en P_UPDATE_MAP_SOLIC_TRASLADO - ' || SQLERRM;
  --
  END P_UPDATE_MAP_SOLIC_TRASLADO;
  --
  --
  --
  PROCEDURE P_VALIDA_CUMPLE_PLAN(Pv_CodigoTipoPromocion         IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                 Pa_TipoPromoPlanProdProcesar   IN DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar, 
                                 Pa_ServiciosProcesar           IN DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar,
                                 Pn_IdPlan                      IN DB_COMERCIAL.INFO_SERVICIO.PLAN_ID%TYPE,
                                 Pn_IdPlanSuperior             OUT DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.PLAN_ID_SUPERIOR%TYPE,
                                 Pb_CumplePlanPromo            OUT BOOLEAN,
                                 Pa_ServiciosCumplePromo       OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar)
  IS
    --
    Ln_Indx             NUMBER:=1;
    Ln_IndxTipoPromo    NUMBER;
    Ln_IndxServProc     NUMBER;   
    Lb_EncontroServ     BOOLEAN; 
    Lv_CompararPlanBw   VARCHAR2(5);
    Lv_MsjResultado     VARCHAR2(4000); 
    Lv_UsuarioCreacion  VARCHAR2(15):= 'telcos_promo_bw';
    Lv_IpCreacion       VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Ln_IdPlanSuperior   DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.PLAN_ID_SUPERIOR%TYPE;
    --
  BEGIN
    --
    Pa_ServiciosCumplePromo.DELETE();   
    Lb_EncontroServ  := FALSE;
    Ln_IdPlanSuperior:= 0;

    IF Pa_TipoPromoPlanProdProcesar.COUNT > 0 THEN   
      --
      Ln_IndxTipoPromo := Pa_TipoPromoPlanProdProcesar.FIRST;   
      --
      WHILE (Ln_IndxTipoPromo IS NOT NULL)   
      LOOP
        --
        Ln_IndxServProc := Pa_ServiciosProcesar.FIRST;   
        --
        WHILE (Ln_IndxServProc IS NOT NULL)   
        LOOP 
          --
          Lv_CompararPlanBw := 'NO';
          IF Pv_CodigoTipoPromocion = 'PROM_BW' AND Pa_TipoPromoPlanProdProcesar(Ln_IndxTipoPromo).ID_PLAN IS NOT NULL THEN
              Lv_CompararPlanBw := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_COMPARAR_PLAN_PROMO_BW(
                                      Pa_TipoPromoPlanProdProcesar(Ln_IndxTipoPromo).ID_PLAN,Pn_IdPlan);
          END IF;
          --
          IF ((NOT Lb_EncontroServ OR Pv_CodigoTipoPromocion = 'PROM_BW') 
            AND (Pa_TipoPromoPlanProdProcesar(Ln_IndxTipoPromo).ID_PLAN IS NOT NULL  
            AND (Pa_TipoPromoPlanProdProcesar(Ln_IndxTipoPromo).ID_PLAN = Pn_IdPlan OR Lv_CompararPlanBw = 'SI') )) THEN 
            --
            Pa_ServiciosCumplePromo(Ln_Indx).ID_SERVICIO      := Pa_ServiciosProcesar(Ln_IndxServProc).ID_SERVICIO;
            Pa_ServiciosCumplePromo(Ln_Indx).ID_PUNTO         := Pa_ServiciosProcesar(Ln_IndxServProc).ID_PUNTO;
            Pa_ServiciosCumplePromo(Ln_Indx).ID_PLAN          := Pn_IdPlan;
            Pa_ServiciosCumplePromo(Ln_Indx).ID_PRODUCTO      := NULL;
            Pa_ServiciosCumplePromo(Ln_Indx).PLAN_ID_SUPERIOR := Pa_TipoPromoPlanProdProcesar(Ln_IndxTipoPromo).PLAN_ID_SUPERIOR;
            Pa_ServiciosCumplePromo(Ln_Indx).ESTADO           := Pa_ServiciosProcesar(Ln_IndxServProc).ESTADO;
            Ln_Indx:=Ln_Indx + 1;   
            Lb_EncontroServ:=TRUE;
            Ln_IdPlanSuperior:= Pa_TipoPromoPlanProdProcesar(Ln_IndxTipoPromo).PLAN_ID_SUPERIOR;
          END IF;       
          --
          Ln_IndxServProc := Pa_ServiciosProcesar.NEXT(Ln_IndxServProc);
          --
        END LOOP; 
        --    
        Ln_IndxTipoPromo := Pa_TipoPromoPlanProdProcesar.NEXT(Ln_IndxTipoPromo);    
        --
      END LOOP;
    -- 
    END IF;
    --
    Pb_CumplePlanPromo:= Lb_EncontroServ;    
    Pn_IdPlanSuperior := Ln_IdPlanSuperior;
    --
  EXCEPTION
  WHEN OTHERS THEN 
    --
    Lv_MsjResultado := 'Ocurrió un error al verificar que el plan nuevo se encuentre en los Planes Promocionales para el Grupo de Promocional: PROM_BW';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_VALIDA_CUMPLE_PLAN', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000) , 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);

    Pb_CumplePlanPromo:= FALSE;    
    Pn_IdPlanSuperior := Ln_IdPlanSuperior;
    --
  END P_VALIDA_CUMPLE_PLAN;
  --
  --
  --
  PROCEDURE P_OBTIENE_PUNTO_PROMO_PROCESAR(Pn_IdServicio      IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                           Pr_Punto_Promo    OUT Lr_Punto_Promo_Procesar)
  IS    
    --
    --Costo del Query C_Obtiene_Punto_Promo: 8
    CURSOR C_Obtiene_Punto_Promo(Cn_IdServicio  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS  
      SELECT
        IPER.ID_PERSONA_ROL,
        IP.ID_PUNTO,
        IP.LOGIN, 
        IER.EMPRESA_COD 
      FROM 
        DB_COMERCIAL.INFO_SERVICIO ISE, 
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
        DB_COMERCIAL.INFO_PERSONA IPE,
        DB_COMERCIAL.INFO_EMPRESA_ROL IER,
        DB_GENERAL.ADMI_ROL AR
     WHERE ISE.ID_SERVICIO   = Cn_IdServicio
     AND IP.ID_PUNTO         = ISE.PUNTO_ID
     AND IPER.ID_PERSONA_ROL = IP.PERSONA_EMPRESA_ROL_ID
     AND IPE.ID_PERSONA      = IPER.PERSONA_ID
     AND IER.ID_EMPRESA_ROL  = IPER.EMPRESA_ROL_ID
     AND AR.ID_ROL           = IER.ROL_ID;
    --
    Lv_IpCreacion       VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_UsuarioCreacion  VARCHAR2(15):= 'telcos_promo_bw';
    Lv_MsjResultado     VARCHAR2(4000);   
    --
  BEGIN
  --
    IF C_Obtiene_Punto_Promo%ISOPEN THEN
      CLOSE C_Obtiene_Punto_Promo;
    END IF;
    --
    OPEN C_Obtiene_Punto_Promo(Pn_IdServicio);
    FETCH C_Obtiene_Punto_Promo INTO Pr_Punto_Promo;
    CLOSE C_Obtiene_Punto_Promo;
  --
  EXCEPTION
  WHEN OTHERS THEN
    --
    IF C_Obtiene_Punto_Promo%ISOPEN THEN
      CLOSE C_Obtiene_Punto_Promo;
    END IF;
    --
    Lv_MsjResultado := 'Ocurrió un error al obtener información del punto del servicio: '
                        ||Pn_IdServicio ||', para el Grupo de Promocional: PROM_BW' ; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_OBTIENE_PUNTO_PROMO', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);       
    Pr_Punto_Promo:= NULL;
    --
  END P_OBTIENE_PUNTO_PROMO_PROCESAR;
  --
  --
  --
  PROCEDURE P_OBTIENE_SERV_PROCESAR_BW(Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                       Pv_EstadoServicio       IN DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE,
                                       Pa_ServiciosProcesar   OUT DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar)
  IS    
    --
    Ln_Indx               NUMBER;
    Ln_Indice             NUMBER:= 1; 
    Lv_MsjResultado       VARCHAR2(4000); 
    Lv_Consulta           VARCHAR2(4000);
    Lv_CadenaQuery        VARCHAR2(2000);
    Lv_CadenaFrom         VARCHAR2(1000);
    Lv_CadenaWhere        VARCHAR2(4000);
    Lv_CadenaOrdena       VARCHAR2(1000); 
    Lv_IpCreacion         VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
    Lrf_ServiciosProcesar SYS_REFCURSOR; 
    Lr_Servicios          DB_COMERCIAL.CMKG_PROMOCIONES.Lr_ServiciosProcesar; 
    La_ServiciosProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear;  
    Lv_UsuarioCreacion    VARCHAR2(15) := 'telcos_promo_bw';

    --
  BEGIN
    --Costo query obtiene servicios : 8  
    Lv_CadenaQuery:='SELECT
      ISE.ID_SERVICIO,
      IP.ID_PUNTO,       
      ISE.PLAN_ID     AS ID_PLAN,
      ISE.PRODUCTO_ID AS ID_PRODUCTO,  
      NULL            AS PLAN_ID_SUPERIOR,
      ISE.ESTADO      AS ESTADO ';

    Lv_CadenaFrom:=' FROM DB_COMERCIAL.INFO_SERVICIO ISE, 
      DB_COMERCIAL.INFO_PUNTO IP,
      DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
      DB_COMERCIAL.INFO_PERSONA IPE,
      DB_COMERCIAL.INFO_EMPRESA_ROL IER,
      DB_GENERAL.ADMI_ROL AR ';

    Lv_CadenaWhere:=' WHERE 
          IP.ID_PUNTO            = ISE.PUNTO_ID
      AND IPER.ID_PERSONA_ROL    = IP.PERSONA_EMPRESA_ROL_ID
      AND IPE.ID_PERSONA         = IPER.PERSONA_ID
      AND IER.ID_EMPRESA_ROL     = IPER.EMPRESA_ROL_ID
      AND AR.ID_ROL              = IER.ROL_ID 
      AND ISE.ID_SERVICIO        = '||Pn_IdServicio||' ';

    Lv_CadenaOrdena:=' ORDER BY ISE.ID_SERVICIO ASC';

    Lv_Consulta:= Lv_CadenaQuery || Lv_CadenaFrom || Lv_CadenaWhere || Lv_CadenaOrdena;      

    Pa_ServiciosProcesar.DELETE();  
    IF Lrf_ServiciosProcesar%ISOPEN THEN
      CLOSE Lrf_ServiciosProcesar;
    END IF;

    La_ServiciosProcesar.DELETE();
    OPEN Lrf_ServiciosProcesar FOR Lv_Consulta;     
    LOOP
      FETCH Lrf_ServiciosProcesar BULK COLLECT INTO La_ServiciosProcesar LIMIT 100;       
      Ln_Indx:=La_ServiciosProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)       
      LOOP  
        Lr_Servicios := La_ServiciosProcesar(Ln_Indx);
        Ln_Indx      := La_ServiciosProcesar.NEXT(Ln_Indx);    
        --
        Pa_ServiciosProcesar(Ln_Indice).ID_SERVICIO      := Lr_Servicios.ID_SERVICIO;
        Pa_ServiciosProcesar(Ln_Indice).ID_PUNTO         := Lr_Servicios.ID_PUNTO;
        Pa_ServiciosProcesar(Ln_Indice).ID_PLAN          := Lr_Servicios.ID_PLAN;
        Pa_ServiciosProcesar(Ln_Indice).ID_PRODUCTO      := Lr_Servicios.ID_PRODUCTO;
        Pa_ServiciosProcesar(Ln_Indice).PLAN_ID_SUPERIOR := Lr_Servicios.PLAN_ID_SUPERIOR;
        Pa_ServiciosProcesar(Ln_Indice).ESTADO           := Lr_Servicios.ESTADO;
        --
        Ln_Indice:=Ln_Indice + 1;
      END LOOP;
      EXIT WHEN Lrf_ServiciosProcesar%NOTFOUND; 
    END LOOP;
    CLOSE Lrf_ServiciosProcesar;      

  EXCEPTION
  WHEN OTHERS THEN
    --
    Lv_MsjResultado := 'Ocurrió un error al obtener información del servicio: '
                       ||Pn_IdServicio ||', para el Grupo de Promocional: PROM_BW';
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_OBTIENE_SERV_PROCESAR_BW', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000) , 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion); 
    --
    Pa_ServiciosProcesar.DELETE();    
    --
  END P_OBTIENE_SERV_PROCESAR_BW;
  --
  --
  --
  PROCEDURE P_OBTIENE_PROMOCIONES_BW(Pv_TipoPromocion         IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoProceso           IN VARCHAR2,
                                     Pn_Valor                 IN NUMBER,
                                     Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Prf_TiposPromociones    OUT SYS_REFCURSOR)
  IS    
    --
    Le_Exception             EXCEPTION;
    Lv_MsjResultado          VARCHAR2(4000); 
    Lv_QuerySelect           VARCHAR2(2000);
    Lv_QueryFrom             VARCHAR2(2000); 
    Lv_QueryWhere            CLOB;
    Lv_QueryOrderBy          VARCHAR2(2000); 
    Lv_Consulta              CLOB;
    Lv_CaractLineProfile     VARCHAR2(40) := 'LINE-PROFILE-NAME';
    Lv_EstadoInactivo        VARCHAR2(20) := 'Inactivo';
    Lv_EstadoClonado         VARCHAR2(20) := 'Clonado';
    Lv_CodigoProducto        VARCHAR2(5)  := 'INTD';
    Lv_EstadoActivo          DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE:= 'Activo';
    Lv_EstadoEliminado       DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE:= 'Eliminado';
    Lv_EstadoEnVerificacion  DB_COMERCIAL.INFO_SERVICIO.ESTADO%TYPE:= 'EnVerificacion';
    Lv_NombreParametro       VARCHAR2(50):= 'PROM_TIPO_PROMOCIONES';
    Lv_TipoCliente           VARCHAR2(20):= 'PROM_TIPO_CLIENTE';
    Lv_IpCreacion            VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lv_UsuarioCreacion       VARCHAR2(15):= 'telcos_promo_bw';
    Lv_FechaProcesamiento    VARCHAR2(15):= TO_CHAR(SYSDATE,'RRRR/MM/DD');
    Ld_FechaEvalVigencia     DATE;
    --
  BEGIN
    --
    IF Pv_TipoProceso = 'ACTIVACION' THEN
      --
      Ld_FechaEvalVigencia:= CMKG_PROMOCIONES_UTIL.F_OBTIENE_FECHA_EVAL_VIGENCIA(Pn_Valor,
                                                                                 Lv_EstadoEnVerificacion,
                                                                                 Pv_TipoPromocion);
      --
      IF Ld_FechaEvalVigencia IS NOT NULL THEN
        Lv_FechaProcesamiento:= TO_CHAR(Ld_FechaEvalVigencia,'RRRR/MM/DD');
      ELSE
        RAISE Le_Exception;
      END IF;
    END IF;

    IF Prf_TiposPromociones%ISOPEN THEN
      CLOSE Prf_TiposPromociones;
    END IF;
    -- Costo query obtiene promociones : 14  
    Lv_QuerySelect:='SELECT         
      GPROMO.ID_GRUPO_PROMOCION,
      GPROMO.NOMBRE_GRUPO,
      GPROMO.FE_INICIO_VIGENCIA,
      GPROMO.FE_FIN_VIGENCIA,
      TPROMO.ID_TIPO_PROMOCION,
      TPROMO.TIPO,
      TPROMO.FE_CREACION,      
      DET.VALOR2            AS CODIGO_TIPO_PROMOCION, 
      DET.VALOR3            AS CODIGO_GRUPO_PROMOCION,
      TO_NUMBER(DET.VALOR4) AS PRIORIDAD,
      DET.EMPRESA_COD ';
    Lv_QueryFrom:='FROM
      DB_COMERCIAL.ADMI_TIPO_PROMOCION TPROMO, 
      DB_COMERCIAL.ADMI_GRUPO_PROMOCION GPROMO,
      DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION TPPPROMO,
      DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA TPRORE,
      DB_COMERCIAL.ADMI_CARACTERISTICA REG,
      DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
      DB_GENERAL.ADMI_PARAMETRO_DET DET ';
    Lv_QueryWhere:='WHERE
      CAB.NOMBRE_PARAMETRO                = '''||Lv_NombreParametro||'''     
      AND CAB.ESTADO                      = '''||Lv_EstadoActivo||'''     
      AND DET.ESTADO                      = '''||Lv_EstadoActivo||'''    
      AND DET.EMPRESA_COD                 = '''||Pv_CodEmpresa||'''
      AND DET.VALOR3                      = '''||Pv_TipoPromocion||'''
      AND CAB.ID_PARAMETRO                = DET.PARAMETRO_ID
      AND TPROMO.CODIGO_TIPO_PROMOCION    = DET.VALOR2  
      AND TPROMO.GRUPO_PROMOCION_ID       = GPROMO.ID_GRUPO_PROMOCION  
      AND TPPPROMO.TIPO_PROMOCION_ID      = TPROMO.ID_TIPO_PROMOCION
      AND TPROMO.ID_TIPO_PROMOCION        = TPRORE.TIPO_PROMOCION_ID
      AND TPRORE.CARACTERISTICA_ID        = REG.ID_CARACTERISTICA
      AND REG.DESCRIPCION_CARACTERISTICA  = '''||Lv_TipoCliente||''' 
      AND TPRORE.ESTADO                  != '''||Lv_EstadoEliminado||'''
      AND (
        ( TPROMO.CODIGO_TIPO_PROMOCION != ''PROM_BW'' AND GPROMO.ESTADO IN (''Activo'',''Inactivo'') )
        OR ( TPROMO.CODIGO_TIPO_PROMOCION = ''PROM_BW'' AND GPROMO.ESTADO IN (''Procesamiento'',''Activo'') )
      )
      AND TPROMO.ESTADO                   in (''Activo'',''Inactivo'')
      AND GPROMO.EMPRESA_COD              = '''||Pv_CodEmpresa||'''
      AND (TO_DATE('''||Lv_FechaProcesamiento||''',''RRRR/MM/DD'') 
      BETWEEN TO_DATE(TO_CHAR(GPROMO.FE_INICIO_VIGENCIA,''RRRR/MM/DD''),''RRRR/MM/DD'')
      AND TO_DATE(TO_CHAR(GPROMO.FE_FIN_VIGENCIA,''RRRR/MM/DD''),''RRRR/MM/DD'')) ';

    Lv_QueryOrderBy:='ORDER BY GPROMO.FE_INICIO_VIGENCIA ASC,
                               GPROMO.FE_FIN_VIGENCIA ASC,
                               TPROMO.FE_CREACION ASC';

    IF Pv_TipoProceso in ('ACTIVACION','TRASLADO','CAMBIO_RAZON_SOCIAL') THEN
      --
      Lv_QueryWhere:= Lv_QueryWhere || ' 
                      AND (
                        TPPPROMO.PLAN_ID = (SELECT PLAN_ID FROM DB_COMERCIAL.INFO_SERVICIO WHERE ID_SERVICIO='||Pn_IdServicio||')
                        OR
                        ( '''||Pv_TipoPromocion||''' = ''PROM_BW''
                          AND EXISTS (
                            SELECT 1 FROM (
                              SELECT PCA.ID_PLAN, CAR.VALOR AS LINE_PROFILE_NAME
                              FROM DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT CAR
                                INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PDE ON PDE.ID_ITEM = CAR.PLAN_DET_ID
                                INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PCA ON PCA.ID_PLAN = PDE.PLAN_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC ON PC.ID_PRODUCTO_CARACTERISITICA = CAR.PRODUCTO_CARACTERISITICA_ID
                                INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C ON C.ID_CARACTERISTICA = PC.CARACTERISTICA_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON PRO.ID_PRODUCTO = PDE.PRODUCTO_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO P ON P.ID_PRODUCTO = PC.PRODUCTO_ID
                              WHERE C.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractLineProfile||'''
                                AND P.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||'''
                                AND PRO.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||'''
                                AND PCA.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                                AND PDE.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                                AND CAR.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                            ) PLAN_PER
                            WHERE EXISTS (
                              SELECT 1
                              FROM DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT CAR2
                                INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PDE2 ON PDE2.ID_ITEM = CAR2.PLAN_DET_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC2 ON PC2.ID_PRODUCTO_CARACTERISITICA = CAR2.PRODUCTO_CARACTERISITICA_ID
                                INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C2 ON C2.ID_CARACTERISTICA = PC2.CARACTERISTICA_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO2 ON PRO2.ID_PRODUCTO = PDE2.PRODUCTO_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO P2 ON P2.ID_PRODUCTO = PC2.PRODUCTO_ID
                              WHERE C2.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractLineProfile||'''
                                AND P2.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||'''
                                AND PRO2.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||'''
                                AND PDE2.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                                AND CAR2.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                                AND PDE2.PLAN_ID = TPPPROMO.PLAN_ID
                                AND CAR2.VALOR = PLAN_PER.LINE_PROFILE_NAME
                            )
                            AND PLAN_PER.ID_PLAN = (SELECT PLAN_ID FROM DB_COMERCIAL.INFO_SERVICIO WHERE ID_SERVICIO='||Pn_IdServicio||')
                          )
                        )
                      )
                      AND REGEXP_LIKE(UPPER(TPRORE.VALOR),''NUEVO'') ';

    ELSIF Pv_TipoProceso = 'CAMBIO_PLAN' THEN
      --
      Lv_QueryWhere:= Lv_QueryWhere || ' 
                      AND (
                        TPPPROMO.PLAN_ID = '''||Pn_Valor||''' 
                        OR
                        ( '''||Pv_TipoPromocion||''' = ''PROM_BW''
                          AND EXISTS (
                            SELECT 1 FROM (
                              SELECT PCA.ID_PLAN, CAR.VALOR AS LINE_PROFILE_NAME
                              FROM DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT CAR
                                INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PDE ON PDE.ID_ITEM = CAR.PLAN_DET_ID
                                INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PCA ON PCA.ID_PLAN = PDE.PLAN_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC ON PC.ID_PRODUCTO_CARACTERISITICA = CAR.PRODUCTO_CARACTERISITICA_ID
                                INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C ON C.ID_CARACTERISTICA = PC.CARACTERISTICA_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON PRO.ID_PRODUCTO = PDE.PRODUCTO_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO P ON P.ID_PRODUCTO = PC.PRODUCTO_ID
                              WHERE C.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractLineProfile||'''
                                AND P.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||'''
                                AND PRO.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||'''
                                AND PCA.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                                AND PDE.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                                AND CAR.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                            ) PLAN_PER
                            WHERE EXISTS (
                              SELECT 1
                              FROM DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT CAR2
                                INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PDE2 ON PDE2.ID_ITEM = CAR2.PLAN_DET_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC2 ON PC2.ID_PRODUCTO_CARACTERISITICA = CAR2.PRODUCTO_CARACTERISITICA_ID
                                INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C2 ON C2.ID_CARACTERISTICA = PC2.CARACTERISTICA_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO2 ON PRO2.ID_PRODUCTO = PDE2.PRODUCTO_ID
                                INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO P2 ON P2.ID_PRODUCTO = PC2.PRODUCTO_ID
                              WHERE C2.DESCRIPCION_CARACTERISTICA = '''||Lv_CaractLineProfile||'''
                                AND P2.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||'''
                                AND PRO2.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||'''
                                AND PDE2.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                                AND CAR2.ESTADO IN ('''||Lv_EstadoActivo||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''')
                                AND PDE2.PLAN_ID = TPPPROMO.PLAN_ID
                                AND CAR2.VALOR = PLAN_PER.LINE_PROFILE_NAME
                            )
                            AND PLAN_PER.ID_PLAN = '''||Pn_Valor||''' 
                          )
                        )
                      )
                      AND ( REGEXP_LIKE(UPPER(TPRORE.VALOR),''EXISTENTE'') 
                        OR ( REGEXP_LIKE(UPPER(TPRORE.VALOR),''NUEVO'') AND '''||Pv_TipoPromocion||''' = ''PROM_BW'' ) ) ';
    ELSE
      --
      Lv_QueryWhere:= Lv_QueryWhere || ' 
                      AND TPPPROMO.PLAN_ID = (SELECT PLAN_ID FROM DB_COMERCIAL.INFO_SERVICIO WHERE ID_SERVICIO='||Pn_IdServicio||')
                      AND REGEXP_LIKE(UPPER(TPRORE.VALOR),''EXISTENTE'') ';
      --
    END IF;

    Lv_Consulta:=Lv_QuerySelect||Lv_QueryFrom||Lv_QueryWhere||Lv_QueryOrderBy; 
    IF Lv_Consulta IS NULL THEN
       RAISE Le_Exception;
    END IF;

    OPEN Prf_TiposPromociones FOR Lv_Consulta;

  EXCEPTION
  WHEN Le_Exception THEN   
    --
    IF Prf_TiposPromociones%ISOPEN THEN
      CLOSE Prf_TiposPromociones;
    END IF;
    --
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso para obtener las promociones para el Grupo Promocional: '
                       || Pv_TipoPromocion|| ', Tipo Proceso: '||Pv_TipoProceso;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_OBTIENE_PROMOCIONES_BW', 
                                         SUBSTR(Lv_MsjResultado,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);  
    Prf_TiposPromociones:= NULL; 

  WHEN OTHERS THEN
    --
    IF Prf_TiposPromociones%ISOPEN THEN
      CLOSE Prf_TiposPromociones;
    END IF;
    --
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso para obtener las promociones para el Grupo Promocional: '||
                        Pv_TipoPromocion || ', Tipo Proceso: '|| Pv_TipoProceso;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_OBTIENE_PROMOCIONES_BW', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);    
    Prf_TiposPromociones:= NULL;    

  END P_OBTIENE_PROMOCIONES_BW;
  --
  --
  --
  PROCEDURE P_OBTIENE_PROMO_APLICADA(Pv_TipoPromocion         IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                     Pv_CodEmpresa            IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                     Pv_TipoProceso           IN VARCHAR2,
                                     Pn_Valor                 IN NUMBER, 
                                     Pn_IdServicio            IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                     Pb_TienePromoAplicada   OUT BOOLEAN,
                                     Pn_IdGrupoPromocion     OUT DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                     Pn_IdTipoPromocion      OUT DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
  IS    
    --
    --Costo del Query C_TienePromoAplicada: 81
    CURSOR C_TienePromoAplicada(Cv_TipoPromocion   DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                Cv_CodEmpresa      DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                Cn_IdServicio      NUMBER,
                                Cv_NombreParametro VARCHAR2,
                                Cv_EstadoActivo    VARCHAR2)
    IS  
      SELECT         
        GPROMO.ID_GRUPO_PROMOCION,
        TPROMO.ID_TIPO_PROMOCION
      FROM 
        DB_COMERCIAL.ADMI_TIPO_PROMOCION TPROMO, 
        DB_COMERCIAL.ADMI_GRUPO_PROMOCION GPROMO,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
        DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
        DB_GENERAL.ADMI_PARAMETRO_DET DET
      WHERE
          CAB.NOMBRE_PARAMETRO          = Cv_NombreParametro   
      AND CAB.ESTADO                    = Cv_EstadoActivo
      AND DET.ESTADO                    = Cv_EstadoActivo
      AND DET.EMPRESA_COD               = Cv_CodEmpresa
      AND DET.VALOR3                    = Cv_TipoPromocion
      AND CAB.ID_PARAMETRO              = DET.PARAMETRO_ID
      AND TPROMO.CODIGO_TIPO_PROMOCION  = DET.VALOR2
      AND TPROMO.GRUPO_PROMOCION_ID     = GPROMO.ID_GRUPO_PROMOCION
      AND TPROMO.ID_TIPO_PROMOCION      = IDMP.TIPO_PROMOCION_ID
      AND IDMP.ID_DETALLE_MAPEO         = IDMS.DETALLE_MAPEO_ID  
      AND IDMP.ESTADO                   = Cv_EstadoActivo
      AND IDMS.ESTADO                   = Cv_EstadoActivo
      AND GPROMO.EMPRESA_COD            = Cv_CodEmpresa
      AND IDMS.SERVICIO_ID              = Cn_IdServicio
      AND ROWNUM                        = 1;
    --
    Ln_IdServicio         NUMBER;
    Lv_MsjResultado       VARCHAR2(4000);
    Lv_UsuarioCreacion    VARCHAR2(15):= 'telcos_promo_bw';
    Lv_EstadoActivo       VARCHAR2(15):= 'Activo';
    Lv_NombreParametro    VARCHAR2(50):= 'PROM_TIPO_PROMOCIONES';
    Lv_IpCreacion         VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));   
    Lc_PromocionAplicada  C_TienePromoAplicada%ROWTYPE;
    --
  BEGIN
    --    
    Pb_TienePromoAplicada := FALSE;
    --
    IF Pv_TipoProceso in ('TRASLADO','CAMBIO_RAZON_SOCIAL') THEN
      Ln_IdServicio:= Pn_Valor;
    ELSE
      Ln_IdServicio:= Pn_IdServicio;
    END IF;
    --
    IF C_TienePromoAplicada%ISOPEN THEN
      CLOSE C_TienePromoAplicada;
    END IF;
    --
    OPEN C_TienePromoAplicada(Pv_TipoPromocion,
                                Pv_CodEmpresa,
                                Ln_IdServicio,
                                Lv_NombreParametro,
                                Lv_EstadoActivo);
    FETCH C_TienePromoAplicada INTO Lc_PromocionAplicada;
    --
    IF C_TienePromoAplicada%FOUND THEN
      Pn_IdGrupoPromocion   := Lc_PromocionAplicada.ID_GRUPO_PROMOCION;
      Pn_IdTipoPromocion    := Lc_PromocionAplicada.ID_TIPO_PROMOCION;
      Pb_TienePromoAplicada := TRUE;      
    END IF;
    --
    CLOSE C_TienePromoAplicada;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --
    IF C_TienePromoAplicada%ISOPEN THEN
      CLOSE C_TienePromoAplicada;
    END IF;
    --
    Lv_MsjResultado := 'Ocurrió un error al ejecutar el proceso para obtener las promociones aplicadas para el Grupo de Promocional: '||
                        Pv_TipoPromocion || ', Tipo Proceso: '|| Pv_TipoProceso;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_OBTIENE_PROMO_APLICADA', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);    
    --    
    Pn_IdGrupoPromocion   := NULL;
    Pn_IdTipoPromocion    := NULL;
    Pb_TienePromoAplicada := FALSE;
    --
  END P_OBTIENE_PROMO_APLICADA;
  --
  --
  --
  PROCEDURE P_VALIDA_MAPEA_PROMOCIONES_BW(Pv_TipoPromocion        IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                          Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                          Pv_TipoProceso          IN VARCHAR2,
                                          Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                          Pn_Valor                IN VARCHAR2,
                                          Pv_MapeaPromo          OUT VARCHAR2,
                                          Pn_IdPlanSuperior      OUT DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.PLAN_ID_SUPERIOR%TYPE,
                                          Pv_ConfiguraBW         OUT VARCHAR2,
                                          Pv_EstadoProceso       OUT VARCHAR2,
                                          Pv_Mensaje             OUT VARCHAR2)
  IS 
    --
    PRAGMA autonomous_transaction;
    --
    Ln_IndTpro                    NUMBER;   
    Ln_Indx                       NUMBER; 
    Ln_IndxPlanSup                NUMBER;
    Ln_IndxServMap                NUMBER;
    --
    Lb_CumplePlanPromo            BOOLEAN;
    Lb_CumpleReglaSectorizacion   BOOLEAN;
    Lb_CumpleReglaFormaPago       BOOLEAN;
    Lb_CumpleReglaAntiguedad      BOOLEAN;
    Lb_CumpleReglaUltimaMilla     BOOLEAN;
    Lb_CumpleReglaTipoNegocio     BOOLEAN;    
    Lb_ExistePierdePromo          BOOLEAN;
    --
    Ld_FechaProcesamiento         DATE;
    Ld_FechaMapeo                 DATE;
    Ln_Contador                   NUMBER;
    Ln_IdPersonaRol               NUMBER;
    Ln_IdPunto                    NUMBER;
    Lex_Exception                 EXCEPTION;
    Lex_ExceptionGeneral          EXCEPTION;
    Lv_EstadoPromocion            VARCHAR2(25);
    Lv_FechaInicio                VARCHAR2(25);
    Lv_FechaFin                   VARCHAR2(25);
    Lv_HoraInicio                 VARCHAR2(25);
    Lv_HoraFin                    VARCHAR2(25);
    Lv_ValorProceso               VARCHAR2(500);
    Lv_DescuentoPeriodo           VARCHAR2(200);
    Lv_Periodo                    VARCHAR2(10);
    Lv_Descuento                  VARCHAR2(10); 
    Lv_NombrePlan                 VARCHAR2(100);
    Lv_LineProfilePromo           VARCHAR2(100);
    Lv_MsjHistorialServicio       VARCHAR2(4000);
    Lv_FechaMapeoTotal            VARCHAR2(5000);
    Lv_Trama                      VARCHAR2(5000);
    Lv_MsjResultado               VARCHAR2(4000);   
    Lv_UsuarioCreacion            VARCHAR2(15):= 'telcos_promo_bw';
    Lv_EstadoActivo               VARCHAR2(15):= 'Activo';
    Lv_TipoEvaluacion             VARCHAR2(15):= 'NUEVO';
    Lv_IpCreacion                 VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
    Lrf_TiposPromociones          SYS_REFCURSOR;
    Lr_Punto_Promo                Lr_Punto_Promo_procesar;
    Lr_Punto_PromoTraslado        Lr_Punto_Promo_procesar;
    La_TiposPromocionesProcesar   DB_COMERCIAL.CMKG_PROMOCIONES.T_TiposPromocionesProcesar;
    Lr_TiposPromociones           DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TiposPromocionesProcesar;
    Lr_TipoPromoRegla             DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
    La_TipoPromoPlanProdProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar;
    La_ServiciosProcesar          DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    La_ServiciosMapear            DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear;
    La_ServiciosCumplePromo       DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    Lr_InfoDetalleMapeoPromo      DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE; 
    La_SectorizacionProcesar      DB_COMERCIAL.CMKG_PROMOCIONES.T_SectorizacionProcesar;
    Lr_GrupoPromoRegla            DB_COMERCIAL.CMKG_PROMOCIONES.Lr_GrupoPromoReglaProcesar;
    Ln_IdPlanSuperior             DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.PLAN_ID_SUPERIOR%TYPE;
    Lr_InfoServicioHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_InfoProcesoRDA             DB_COMERCIAL.CMKG_PROMOCIONES_BW.Gr_ProcesoPromo;
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;
    --
  BEGIN
    --
    --Obtiene información del punto a procesar
    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_OBTIENE_PUNTO_PROMO_PROCESAR(Pn_IdServicio,Lr_Punto_Promo);
    --
    IF Pv_TipoProceso = 'ACTIVACION' THEN
      Lv_ValorProceso:= Lr_Punto_Promo.ID_PUNTO;
    ELSE
      Lv_ValorProceso:= Pn_Valor;
    END IF;

    --Obtiene las Promociones de Ancho de Banda a procesar.
    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_OBTIENE_PROMOCIONES_BW(Pv_TipoPromocion,
                                                              Pv_CodEmpresa,
                                                              Pv_TipoProceso,
                                                              Lv_ValorProceso,
                                                              Pn_IdServicio,
                                                              Lrf_TiposPromociones);
    --
    Ln_Contador      := 0;
    Pn_IdPlanSuperior:= 0;
    Pv_MapeaPromo    := 'NO';
    Pv_ConfiguraBW   := 'NO';
    Pv_EstadoProceso := 'OK';
    --
    IF NOT(Lrf_TiposPromociones%ISOPEN) THEN          
      Lv_MsjResultado:= 'Ocurrió un error al obtener los Tipos Promocionales del Grupo Promoción: PROM_BW' ;
      RAISE Lex_ExceptionGeneral;
    END IF; 
    --
    LOOP
    FETCH Lrf_TiposPromociones BULK COLLECT INTO La_TiposPromocionesProcesar LIMIT 5000;  
      Ln_IndTpro:= La_TiposPromocionesProcesar.FIRST;  
      --  
      WHILE (Ln_IndTpro IS NOT NULL AND Pv_MapeaPromo <> 'SI')       
      LOOP 
        BEGIN
          --
          Lr_TiposPromociones:= La_TiposPromocionesProcesar(Ln_IndTpro);

          --Limpiamos la Tabla de Sectores y Obtengo Sectorización como estructura de tabla por Tipo Promocional
          La_SectorizacionProcesar.DELETE();
          La_SectorizacionProcesar:= DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION(Lr_TiposPromociones.ID_GRUPO_PROMOCION);

          --Obtengo Reglas por Tipo Promocional.
          Lr_TipoPromoRegla:= DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Lr_TiposPromociones.ID_TIPO_PROMOCION); 

          IF Lr_TipoPromoRegla.ID_TIPO_PROMOCION IS NULL THEN                    
            Lv_MsjResultado:= 'Ocurrió un error al obtener las reglas del Tipo Promocional, ID_TIPO_PROMOCION: '||Lr_TiposPromociones.ID_TIPO_PROMOCION;
            RAISE Lex_Exception;            
          END IF; 

          --Obtengo los planes por Tipo de Promoción, en este caso: PROM_BW.
          La_TipoPromoPlanProdProcesar:= DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD(Lr_TiposPromociones.ID_TIPO_PROMOCION); 
          --
          IF (Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_BW') AND La_TipoPromoPlanProdProcesar.COUNT = 0) THEN  
            Lv_MsjResultado:= 'No se encontraron definidos Planes y/o Productos para el Tipo Promocional, ID_TIPO_PROMOCION: '||Lr_TiposPromociones.ID_TIPO_PROMOCION;         
            RAISE Lex_Exception;             
          END IF;

          --Obtiene servicio/s a procesar
          DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_OBTIENE_SERV_PROCESAR_BW(Pn_IdServicio,Lv_EstadoActivo, La_ServiciosProcesar);
          --
          IF La_ServiciosProcesar.COUNT = 0 THEN                    
            Lv_MsjResultado:= 'Ocurrió un error al obtener los servicios a procesar en el punto cliente ID_PUNTO: '||Lr_Punto_Promo.ID_PUNTO;
            RAISE Lex_Exception;            
          END IF; 
          --
          La_ServiciosCumplePromo.DELETE(); 
          --
          IF Pv_TipoProceso = 'CAMBIO_PLAN' THEN
            --Valida que el plan cumpla en la promoción.
            DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_CUMPLE_PLAN(Pv_TipoPromocion,
                                                                  La_TipoPromoPlanProdProcesar,
                                                                  La_ServiciosProcesar,
                                                                  Pn_Valor,
                                                                  Ln_IdPlanSuperior,
                                                                  Lb_CumplePlanPromo,
                                                                  La_ServiciosCumplePromo);
          ELSE
            --Validación para confirmar que los servicios consultados existan en la Promoción.
            DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD(La_ServiciosProcesar, 
                                                                     Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION,
                                                                     La_TipoPromoPlanProdProcesar, 
                                                                     Lb_CumplePlanPromo,
                                                                     La_ServiciosCumplePromo); 
          END IF; 

          IF Lb_CumplePlanPromo AND La_ServiciosCumplePromo.COUNT = 0 THEN
            Lv_MsjResultado:= 'No se encontraron servicios en el punto cliente ID_PUNTO: '||Lr_Punto_Promo.ID_PUNTO||
                              ' que cumplan o se encuentren definidos en el Tipo Promocional, ID_TIPO_PROMOCION: '|| Lr_TiposPromociones.ID_TIPO_PROMOCION;   
            RAISE Lex_Exception; 
          END IF;

          Ln_Indx := La_ServiciosCumplePromo.FIRST; 
          WHILE (Ln_Indx IS NOT NULL)  
          LOOP
            La_ServiciosMapear(Ln_Indx):= La_ServiciosCumplePromo(Ln_Indx);
            Ln_Indx:= La_ServiciosCumplePromo.NEXT(Ln_Indx); 
          END LOOP;
          --                                                                   
          IF(Lb_CumplePlanPromo) THEN
            --
            Lr_GrupoPromoRegla                        := NULL;
            Lr_GrupoPromoRegla.ID_GRUPO_PROMOCION     := Lr_TiposPromociones.ID_GRUPO_PROMOCION;

            --Validación de reglas de la promoción.
            --
            IF Pv_TipoProceso = 'CAMBIO_LINEA_PON' THEN
              Lb_CumpleReglaSectorizacion := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION_OLT(
                    Lr_TiposPromociones.ID_GRUPO_PROMOCION,Pn_Valor,Pv_CodEmpresa,Lr_Punto_Promo.ID_PUNTO);
            ELSE
              Lr_ParametrosValidarSec                    :=  NULL;
              Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION :=  Lr_TiposPromociones.ID_GRUPO_PROMOCION;
              Lr_ParametrosValidarSec.ID_SERVICIO        :=  La_ServiciosMapear(1).ID_SERVICIO;
              Lr_ParametrosValidarSec.TIPO_EVALUACION    :=  Lv_TipoEvaluacion;
              Lr_ParametrosValidarSec.TIPO_PROMOCION     := 'PROM_BW';--ANCHO DE BANDA
              Lr_ParametrosValidarSec.EMPRESA_COD        :=  Pv_CodEmpresa;

              Lb_CumpleReglaSectorizacion := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec);
            END IF;
            --
            IF Pv_TipoProceso in ('TRASLADO','CAMBIO_RAZON_SOCIAL') THEN
              DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_OBTIENE_PUNTO_PROMO_PROCESAR(Pn_Valor,Lr_Punto_PromoTraslado);
            END IF;
            --
            Lb_CumpleReglaFormaPago  := TRUE;
            Lb_CumpleReglaAntiguedad := TRUE;
            Lb_CumpleReglaUltimaMilla:= TRUE;
            Lb_CumpleReglaTipoNegocio:= TRUE;

            IF Lb_CumpleReglaSectorizacion AND Lb_CumpleReglaFormaPago
                AND Lb_CumpleReglaAntiguedad AND Lb_CumpleReglaUltimaMilla AND Lb_CumpleReglaTipoNegocio THEN               
              --Función que construye la Trama de la información del Cliente en base a las reglas Promocionales evaluadas.
              Lv_Trama:=DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TRAMA(Lr_Punto_Promo.ID_PUNTO,
                                                                  Lr_GrupoPromoRegla,
                                                                  Lr_TipoPromoRegla,
                                                                  La_ServiciosCumplePromo,
                                                                  La_SectorizacionProcesar,
                                                                  La_ServiciosMapear(1).ID_SERVICIO,
                                                                  Pv_CodEmpresa);
              Ld_FechaProcesamiento := SYSDATE;
              Lv_DescuentoPeriodo   := Lr_TipoPromoRegla.PROM_PERIODO;
              Ln_IdPersonaRol       := Lr_Punto_Promo.ID_PERSONA_ROL;
              Ln_IdPunto            := Lr_Punto_Promo.ID_PUNTO; 
              --
              Lr_InfoDetalleMapeoPromo                          := NULL;
              Lr_InfoDetalleMapeoPromo.GRUPO_PROMOCION_ID       := Lr_TiposPromociones.ID_GRUPO_PROMOCION;
              Lr_InfoDetalleMapeoPromo.TRAMA                    := Lv_Trama;
              Lr_InfoDetalleMapeoPromo.PERSONA_EMPRESA_ROL_ID   := Ln_IdPersonaRol;
              Lr_InfoDetalleMapeoPromo.PUNTO_ID                 := Ln_IdPunto;
              Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION_ID        := Lr_TiposPromociones.ID_TIPO_PROMOCION;
              Lr_InfoDetalleMapeoPromo.TIPO_PROMOCION           := Lr_TiposPromociones.CODIGO_TIPO_PROMOCION;
              Lr_InfoDetalleMapeoPromo.FE_SIGUIENTE_MAPEO       := NULL;
              Lr_InfoDetalleMapeoPromo.CANTIDAD_PERIODOS        := NULL;
              Lr_InfoDetalleMapeoPromo.MAPEOS_GENERADOS         := NULL;
              IF Pv_TipoProceso = 'ACTIVACION' THEN
                Lr_InfoDetalleMapeoPromo.TIPO_PROCESO           := 'NUEVO';
              ELSE
                Lr_InfoDetalleMapeoPromo.TIPO_PROCESO           := 'EXISTENTE';
              END IF;
              Lr_InfoDetalleMapeoPromo.INVALIDA                 := NULL;
              Lr_InfoDetalleMapeoPromo.INDEFINIDO               := NULL;
              Lr_InfoDetalleMapeoPromo.FE_CREACION              := SYSDATE;
              Lr_InfoDetalleMapeoPromo.USR_CREACION             := Lv_UsuarioCreacion;
              Lr_InfoDetalleMapeoPromo.IP_CREACION              := Lv_IpCreacion;
              Lr_InfoDetalleMapeoPromo.FE_ULT_MOD               := NULL;
              Lr_InfoDetalleMapeoPromo.USR_ULT_MOD              := NULL;
              Lr_InfoDetalleMapeoPromo.IP_ULT_MOD               := NULL;
              Lr_InfoDetalleMapeoPromo.EMPRESA_COD              := Pv_CodEmpresa;
              Lr_InfoDetalleMapeoPromo.ESTADO                   := Lv_EstadoActivo;
              --
              --Bucle que recorre los períodos para realizar el mapeo de la promoción.
              FOR DescuentoPeriodo IN (SELECT REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) SPLIT FROM DUAL
              CONNECT BY REGEXP_SUBSTR (Lv_DescuentoPeriodo,'[^,]+',1, LEVEL) IS NOT NULL)
              LOOP
                --
                Lv_Periodo   :=TO_NUMBER(regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 1));
                Lv_Descuento :=TO_NUMBER(regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 2));
                --
                Lr_InfoDetalleMapeoPromo.PORCENTAJE:= Lv_Descuento;
                Lr_InfoDetalleMapeoPromo.PERIODO   := Lv_Periodo;
                --  
                Ld_FechaMapeo                               := ADD_MONTHS(Ld_FechaProcesamiento, Lv_Periodo-1);
                Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO   := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
                Lr_InfoDetalleMapeoPromo.FE_MAPEO           := Ld_FechaMapeo;
                Lv_FechaMapeoTotal                          := Lv_FechaMapeoTotal||' | '||TO_CHAR(Ld_FechaMapeo);
                --
                DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_DETALLE(Lr_InfoDetalleMapeoPromo,La_ServiciosMapear,Lv_MsjResultado);  
                --      
                IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                  Lv_MsjResultado:= 'No se pudo generar el mapeo Promocional para el ID_PUNTO: '||Lr_Punto_Promo.ID_PUNTO||
                                    ' Grupo Promocional ID_GRUPO_PROMOCION: ' ||Lr_TiposPromociones.ID_GRUPO_PROMOCION||
                                    ' Tipo Promocional ID_TIPO_PROMOCION: ' ||Lr_TiposPromociones.ID_TIPO_PROMOCION||
                                    ' - ' || Lv_MsjResultado;                                               
                  RAISE Lex_Exception; 
                END IF;
                --
                IF Lv_Periodo = 1 THEN
                  --
                  DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_PIERDE_PROMO_EXT(La_ServiciosMapear(1).ID_SERVICIO,
                                                                            Lr_TiposPromociones.CODIGO_TIPO_PROMOCION,
                                                                            'INDIVIDUAL', 
                                                                            Pv_CodEmpresa,
                                                                            Lb_ExistePierdePromo);

                  Pv_ConfiguraBW:='SI';

                END IF;
                --
                IF Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_BW') THEN
                  Pv_ConfiguraBW:='NO';
                END IF;

                IF Lv_Periodo <> 1 OR Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_BW') THEN
                  --
                  Lr_InfoProcesoRDA                    := NULL;
                  Lr_InfoProcesoRDA.EMPRESA_COD        := Pv_CodEmpresa;
                  Lr_InfoProcesoRDA.SERVICIO_ID        := La_ServiciosMapear(1).ID_SERVICIO;
                  Lr_InfoProcesoRDA.DETALLE_MAPEO_ID   := Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO;
                  Lr_InfoProcesoRDA.FE_INI_MAPEO       := Lr_InfoDetalleMapeoPromo.FE_MAPEO;
                  Lr_InfoProcesoRDA.FE_FIN_MAPEO       := ADD_MONTHS(Lr_InfoDetalleMapeoPromo.FE_MAPEO,1);
                  Lr_InfoProcesoRDA.USR_CREACION       := Lv_UsuarioCreacion;
                  Lr_InfoProcesoRDA.IP_CREACION        := Lv_IpCreacion;
                  Lr_InfoProcesoRDA.TIPO_PROCESO       := 'AplicaPromo';
                  Lr_InfoProcesoRDA.TIPO_PROMO         := Lr_TiposPromociones.CODIGO_TIPO_PROMOCION;
                  IF Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_BW') THEN
                      SELECT ESTADO INTO Lv_EstadoPromocion FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION
                                WHERE ID_GRUPO_PROMOCION = Lr_TiposPromociones.ID_GRUPO_PROMOCION;
                      Lr_InfoProcesoRDA.ESTADO := Lv_EstadoPromocion;
                  END IF;
                  --
                  DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PREPARA_DATA_PROCESO_PROMO(Lr_InfoProcesoRDA, Lv_MsjResultado);
                  --
                  IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                    RAISE Lex_Exception;
                  END IF; 
                  --
                END IF;
                --
              END LOOP;
              --
              IF Lv_MsjResultado IS NULL THEN
                --
                Ln_IndxServMap := La_ServiciosCumplePromo.FIRST;
                WHILE (Ln_IndxServMap IS NOT NULL)  
                LOOP   
                  Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
                  Lr_InfoServicioHistorial.SERVICIO_ID            := La_ServiciosCumplePromo(Ln_IndxServMap).ID_SERVICIO;
                  Lr_InfoServicioHistorial.USR_CREACION           := Lv_UsuarioCreacion;
                  Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
                  Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
                  Lr_InfoServicioHistorial.ESTADO                 := La_ServiciosCumplePromo(Ln_IndxServMap).ESTADO;
                  Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
                  Lr_InfoServicioHistorial.OBSERVACION            := 'Se registró correctamente el mapeo de la Promoción: ' 
                                                                     || Lr_TiposPromociones.NOMBRE_GRUPO
                                                                     || ' para el tipo promocional: '
                                                                     || Lr_TiposPromociones.CODIGO_TIPO_PROMOCION
                                                                     || ', Fecha-Mapeo: '||Lv_FechaMapeoTotal;
                  Lr_InfoServicioHistorial.ACCION                 := NULL;
                  --
                  DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_MsjResultado);
                  --
                  IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                    RAISE Lex_Exception;
                  END IF;
                  --
                  IF Lr_TipoPromoRegla.CODIGO_TIPO_PROMOCION IN ('PROM_BW') THEN
                      --
                      SELECT ESTADO,
                          TO_CHAR(FE_INICIO_VIGENCIA,'RRRR-MM-DD') FE_INICIO,
                          TO_CHAR(FE_FIN_VIGENCIA,'RRRR-MM-DD') FE_FIN,
                          TO_CHAR(FE_INICIO_VIGENCIA, 'HH24:MI') HORA_INICIO,
                          TO_CHAR(FE_FIN_VIGENCIA, 'HH24:MI') HORA_FIN
                        INTO Lv_EstadoPromocion, Lv_FechaInicio, Lv_FechaFin, Lv_HoraInicio, Lv_HoraFin
                        FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION
                        WHERE ID_GRUPO_PROMOCION = Lr_TiposPromociones.ID_GRUPO_PROMOCION;
                      SELECT NOMBRE_PLAN INTO Lv_NombrePlan FROM DB_COMERCIAL.INFO_PLAN_CAB WHERE ID_PLAN = La_ServiciosCumplePromo(Ln_IndxServMap).ID_PLAN;
                      Lv_LineProfilePromo := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(La_ServiciosCumplePromo(Ln_IndxServMap).PLAN_ID_SUPERIOR);
                      --
                      IF Lv_EstadoPromocion = 'Procesamiento' OR Lv_EstadoPromocion = 'Activo' THEN
                          --verificar tecnologia
                          Lv_MsjHistorialServicio := 'Se aplica la promoción de ancho de banda. '
                                                  ||'<br>VIGENCIA: ' || Lv_FechaInicio || ' hasta ' || Lv_FechaFin
                                                  ||'<br>FRANJA HORARIA: ' || Lv_HoraInicio || ' a ' || Lv_HoraFin;
                          Lv_MsjHistorialServicio := Lv_MsjHistorialServicio || '<br>Nombre de plan contratado: <b>' || Lv_NombrePlan || '</b>';
                          Lv_MsjHistorialServicio := Lv_MsjHistorialServicio || '<br>Line profile de la promoción: <b>' || Lv_LineProfilePromo || '</b>';
                          --
                          Lr_InfoServicioHistorial                        := NULL;
                          Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
                          Lr_InfoServicioHistorial.SERVICIO_ID            := La_ServiciosCumplePromo(Ln_IndxServMap).ID_SERVICIO;
                          Lr_InfoServicioHistorial.USR_CREACION           := Lv_UsuarioCreacion;
                          Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
                          Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
                          Lr_InfoServicioHistorial.ESTADO                 := La_ServiciosCumplePromo(Ln_IndxServMap).ESTADO;
                          Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
                          Lr_InfoServicioHistorial.OBSERVACION            := Lv_MsjHistorialServicio;
                          Lr_InfoServicioHistorial.ACCION                 := NULL;
                          DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial, Lv_MsjResultado);
                      END IF;
                  END IF;
                  --
                  Ln_IndxServMap := La_ServiciosCumplePromo.NEXT (Ln_IndxServMap);
                  --
                END LOOP;
                --
                Pv_MapeaPromo:= 'SI'; 
                --
                Ln_IndxPlanSup := La_ServiciosCumplePromo.FIRST; 
                WHILE (Ln_IndxPlanSup IS NOT NULL)  
                LOOP
                  Pn_IdPlanSuperior:= La_ServiciosCumplePromo(Ln_IndxPlanSup).PLAN_ID_SUPERIOR;
                  Ln_IndxPlanSup   := La_ServiciosCumplePromo.NEXT(Ln_IndxPlanSup); 
                END LOOP;
              END IF;
              --   
            ELSE
              Pv_MapeaPromo    := 'NO';
              Pn_IdPlanSuperior:=  0;
            END IF;      
          --
          ELSE
            Pv_MapeaPromo    := 'NO';
            Pn_IdPlanSuperior:=  0; 
          END IF;
          --
        EXCEPTION
        WHEN Lex_Exception THEN
          --
          ROLLBACK;
          --
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                               'CMKG_PROMOCIONES_BW.P_VALIDA_MAPEA_PROMOCIONES_BW', 
                                               SUBSTR(Lv_MsjResultado,0,4000),
                                               Lv_UsuarioCreacion,
                                               SYSDATE,
                                               Lv_IpCreacion);
          --                                    
          Pv_MapeaPromo    := 'NO';
          Pn_IdPlanSuperior:=  0;
          Pv_ConfiguraBW   := 'NO';
          Pv_EstadoProceso := 'ERROR';
          --
        WHEN OTHERS THEN
          --
          ROLLBACK;
          --
          Lv_MsjResultado:= 'Ocurrió un error al procesar las promociones del Proceso Valida y Mapea de Promociones para el Grupo de Promocional: '||
                             Pv_TipoPromocion|| ', Tipo Proceso: '||Pv_TipoProceso ||', IdTipoPromocion:' || Lr_TiposPromociones.ID_TIPO_PROMOCION 
                             || ', Id Servcio:' || Pn_IdServicio;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                               'CMKG_PROMOCIONES_BW.P_VALIDA_MAPEA_PROMOCIONES_BW', 
                                               SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                               Lv_UsuarioCreacion,
                                               SYSDATE,
                                               Lv_IpCreacion);
          --  
          Pv_MapeaPromo    := 'NO';
          Pn_IdPlanSuperior:=  0;
          Pv_ConfiguraBW   := 'NO';
          Pv_EstadoProceso := 'ERROR';
          --
        END;
        --
        Ln_IndTpro := La_TiposPromocionesProcesar.NEXT(Ln_IndTpro); 
        --
      END LOOP;
      --
      EXIT WHEN Lrf_TiposPromociones%NOTFOUND OR Pv_MapeaPromo = 'SI';
      --   
    END LOOP;
    --
    COMMIT;
    -- 
  EXCEPTION
  WHEN Lex_ExceptionGeneral THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_VALIDA_MAPEA_PROMOCIONES_BW', 
                                         SUBSTR(Lv_MsjResultado,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
    --
    Pv_MapeaPromo    := 'NO';
    Pn_IdPlanSuperior:=  0;
    Pv_ConfiguraBW   := 'NO';
    Pv_EstadoProceso := 'ERROR';
    Pv_Mensaje       :=  Lv_MsjResultado;
    --  
  WHEN OTHERS THEN
    --
    Lv_MsjResultado:= 'Ocurrió un error al ejecutar el Proceso Valida y Mapea de Promociones para el Grupo de Promocional: '||
                      Pv_TipoPromocion || ' Tipo Proceso: ' || Pv_TipoProceso || ', Id Servcio:' || Pn_IdServicio;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_VALIDA_MAPEA_PROMOCIONES_BW', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
    --
    Pv_MapeaPromo    := 'NO';
    Pn_IdPlanSuperior:=  0;
    Pv_ConfiguraBW   := 'NO';
    Pv_EstadoProceso := 'ERROR';
    Pv_Mensaje       :=  Lv_MsjResultado;
    --    
  END P_VALIDA_MAPEA_PROMOCIONES_BW;
  --
  --
  --  
  PROCEDURE P_PROCESO_MAPEO_PROMOCIONES_BW(Pv_CodEmpresa           IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                           Pv_TipoProceso          IN VARCHAR2,
                                           Pn_Valor                IN NUMBER,
                                           Pn_IdServicio           IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                           Pv_AplicaPromo         OUT VARCHAR2,
                                           Pv_MapeaPromo          OUT VARCHAR2,
                                           Pv_TeniaPromo          OUT VARCHAR2,
                                           Pn_IdPlanSuperior      OUT DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.PLAN_ID_SUPERIOR%TYPE,
                                           Pv_ConfiguraBW         OUT VARCHAR2,
                                           Pv_EstadoProceso       OUT VARCHAR2)
  IS
    --
    Lv_Trama                      VARCHAR2(5000);
    Lv_MsjResultado               VARCHAR2(4000); 
    Lv_EstadoActivo               VARCHAR2(15):= 'Activo';
    Lv_TipoPromocion              VARCHAR2(20):= 'PROM_BW';
    Lv_UsuarioCreacion            VARCHAR2(15):= 'telcos_promo_bw';
    Lv_TipoEvaluacion             VARCHAR2(15):= 'NUEVO';
    Lv_IpCreacion                 VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
    Lb_TienePromoAplicada         BOOLEAN;
    Lb_CumplePlanPromo            BOOLEAN;
    Lb_CumpleReglaSectorizacion   BOOLEAN;
    Lb_CumpleReglaFormaPago       BOOLEAN;
    Lb_CumpleReglaAntiguedad      BOOLEAN;
    Lb_CumpleReglaUltimaMilla     BOOLEAN;
    Lb_CumpleReglaTipoNegocio     BOOLEAN;
    Lb_ExistePierdePromo          BOOLEAN;
    Le_ExceptionProceso           EXCEPTION;
    --
    Lr_GrupoPromoRegla            DB_COMERCIAL.CMKG_PROMOCIONES.Lr_GrupoPromoReglaProcesar;
    Lr_TipoPromoRegla             DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
    La_SectorizacionProcesar      DB_COMERCIAL.CMKG_PROMOCIONES.T_SectorizacionProcesar;
    La_ServiciosProcesar          DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    Ln_IdGrupoPromocion           DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE;
    Ln_IdTipoPromocion            DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE;
    La_TipoPromoPlanProdProcesar  DB_COMERCIAL.CMKG_PROMOCIONES.T_TipoPromoPlanProdProcesar;
    La_ServiciosCumplePromo       DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;
    Lr_Punto_Promo                Lr_Punto_Promo_Procesar; 
    --
    Lv_AplicaPromo                VARCHAR2(2);
    Lv_MapeaPromo                 VARCHAR2(2);   
    Lv_TeniaPromo                 VARCHAR2(2);
    Ln_IdServicio                 DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE:= Pn_IdServicio;
    Ln_IdServicioOrigen           DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE:= Pn_IdServicio;
    Ln_IdPlanSuperior             DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.PLAN_ID_SUPERIOR%TYPE;
    Lv_EstadoProcesoValida        VARCHAR2(10); 
    Lv_ConfiguraBW                VARCHAR2(2);
    Lv_EstadoProcesoMapeo         VARCHAR2(10); 
    Lv_TipoProcesoBaja            VARCHAR2(50);
    Lr_ParametrosValidarSec       DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;

  BEGIN
    --
    Ln_IdPlanSuperior     := 0;
    Lb_TienePromoAplicada := FALSE;
    Lv_EstadoProcesoMapeo := 'ERROR';
    Lv_ConfiguraBW        := 'NO';
    --
    -- Se obtiene la información del punto a procesar.
    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_OBTIENE_PUNTO_PROMO_PROCESAR(Ln_IdServicio,Lr_Punto_Promo);
    --
    --Se verifica si existe una promoción aplicada al servicio.
    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_OBTIENE_PROMO_APLICADA(Lv_TipoPromocion,
                                                              Pv_CodEmpresa,
                                                              Pv_TipoProceso,
                                                              Pn_Valor,
                                                              Ln_IdServicio,
                                                              Lb_TienePromoAplicada,
                                                              Ln_IdGrupoPromocion,
                                                              Ln_IdTipoPromocion);
    IF(Lb_TienePromoAplicada) THEN
      --
      --Se obtienen los planes de la Promoción
      La_TipoPromoPlanProdProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TIPO_PROMO_PLAN_PROD(Ln_IdTipoPromocion); 

      IF La_TipoPromoPlanProdProcesar.COUNT = 0 THEN  
        Lv_MsjResultado:= 'No se encontraron definidos planes para el Tipo Promocional, ID_TIPO_PROMOCION: '||Ln_IdTipoPromocion;         
        RAISE Le_ExceptionProceso;             
      END IF;

      --Se obtiene servicio/s para procesar
      DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_OBTIENE_SERV_PROCESAR_BW(Ln_IdServicio,Lv_EstadoActivo, La_ServiciosProcesar);

      IF La_ServiciosProcesar.COUNT = 0 THEN                    
        Lv_MsjResultado:= 'Ocurrió un error al obtener los servicios a procesar en el Punto Cliente ID_PUNTO: '||Lr_Punto_Promo.ID_PUNTO;
        RAISE Le_ExceptionProceso;            
      END IF; 

      IF Pv_TipoProceso = 'CAMBIO_PLAN' THEN
        --Validación para confirmar que el plan consultado exista en la Promoción.
        DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_CUMPLE_PLAN(Lv_TipoPromocion,
                                                              La_TipoPromoPlanProdProcesar,
                                                              La_ServiciosProcesar,
                                                              Pn_Valor,
                                                              Ln_IdPlanSuperior,
                                                              Lb_CumplePlanPromo,
                                                              La_ServiciosCumplePromo);

        IF Lb_CumplePlanPromo AND La_ServiciosCumplePromo.COUNT = 0 THEN
          Lv_MsjResultado:= 'No se encontraron servicios en el Punto Cliente ID_PUNTO: '||Lr_Punto_Promo.ID_PUNTO||
                            ' que cumplan o se encuentren definidos en el Tipo Promocional, ID_TIPO_PROMOCION: '||Ln_IdTipoPromocion;   
          RAISE Le_ExceptionProceso; 
        END IF;
        --
      ELSE
        --Validación para confirmar que los servicios consultados existan en la Promoción.
        La_ServiciosCumplePromo.DELETE(); 
        DB_COMERCIAL.CMKG_PROMOCIONES.P_GET_SERV_PROMO_PLAN_PROD(La_ServiciosProcesar, 
                                                                 Lv_TipoPromocion,
                                                                 La_TipoPromoPlanProdProcesar, 
                                                                 Lb_CumplePlanPromo,
                                                                 La_ServiciosCumplePromo); 

        IF Lb_CumplePlanPromo AND La_ServiciosCumplePromo.COUNT = 0 THEN
          Lv_MsjResultado:= 'No se encontraron servicios en el Punto Cliente ID_PUNTO: '||Lr_Punto_Promo.ID_PUNTO||
                            ' que cumplan o se encuentren definidos en el Tipo Promocional, ID_TIPO_PROMOCION: '||Ln_IdTipoPromocion;   
          RAISE Le_ExceptionProceso; 
        END IF;   

        IF La_ServiciosCumplePromo.COUNT > 0 THEN  
          Ln_IdPlanSuperior:= La_ServiciosCumplePromo(1).PLAN_ID_SUPERIOR;
        END IF;
        --
      END IF;
      --                                                           
      IF Lb_CumplePlanPromo THEN
        --Validación de reglas de la promoción.
        --
        IF Pv_TipoProceso = 'CAMBIO_LINEA_PON' THEN
          Lb_CumpleReglaSectorizacion:= DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION_OLT(
                Ln_IdGrupoPromocion,Pn_Valor,Pv_CodEmpresa,Lr_Punto_Promo.ID_PUNTO);
        ELSE

          Lr_ParametrosValidarSec                    :=  NULL;
          Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION :=  Ln_IdGrupoPromocion;
          Lr_ParametrosValidarSec.ID_SERVICIO        :=  Pn_IdServicio;
          Lr_ParametrosValidarSec.TIPO_EVALUACION    :=  Lv_TipoEvaluacion;
          Lr_ParametrosValidarSec.TIPO_PROMOCION     := 'PROM_BW';--ANCHO DE BANDA
          Lr_ParametrosValidarSec.EMPRESA_COD        :=  Pv_CodEmpresa;

          Lb_CumpleReglaSectorizacion:= DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec);

        END IF;
        --
        Lb_CumpleReglaFormaPago  := TRUE;
        Lb_CumpleReglaAntiguedad := TRUE;
        Lb_CumpleReglaUltimaMilla:= TRUE;
        Lb_CumpleReglaTipoNegocio:= TRUE;
        --     
        IF Pv_TipoProceso not in ('CAMBIO_PLAN','TRASLADO','CAMBIO_RAZON_SOCIAL') AND Lb_CumpleReglaSectorizacion AND Lb_CumpleReglaFormaPago
            AND Lb_CumpleReglaAntiguedad AND Lb_CumpleReglaUltimaMilla AND Lb_CumpleReglaTipoNegocio THEN
          --
          Lv_TeniaPromo         :='SI';
          Lv_AplicaPromo        :='SI';
          Lv_MapeaPromo         :='NO';
          Pn_IdPlanSuperior     := Ln_IdPlanSuperior;
          Lv_EstadoProcesoMapeo :='OK';

          --
          IF Pv_TipoProceso = 'MIGRACION_EQUIPO' THEN
            --
            --Proceso que da De Baja a registros de una promoción
            Lv_TipoProcesoBaja:='MIGRACION_EQUIPO_RDA';
            DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_BAJA_PROMO_BW(Ln_IdServicio,Pv_CodEmpresa,Lv_TipoPromocion,Lv_TipoProcesoBaja,Lv_MsjResultado);
            --
          END IF;
          --
          IF Pv_TipoProceso in ('TRASLADO','CAMBIO_RAZON_SOCIAL') THEN
            --            
            Lr_GrupoPromoRegla                        := NULL;
            Lr_GrupoPromoRegla.ID_GRUPO_PROMOCION     := Ln_IdGrupoPromocion;
            --
            Lr_TipoPromoRegla        := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Ln_IdTipoPromocion); 
            La_SectorizacionProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION(Ln_IdGrupoPromocion);
            Lv_Trama:= DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TRAMA(Lr_Punto_Promo.ID_PUNTO,
                                                                 Lr_GrupoPromoRegla,
                                                                 Lr_TipoPromoRegla,
                                                                 La_ServiciosCumplePromo,
                                                                 La_SectorizacionProcesar,
                                                                 Ln_IdServicio,
                                                                 Pv_CodEmpresa);
            --
            --Actualiza Información necesaria cuando se realiza el proceso de Traslado.
            DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_UPDATE_PROCESO_TRASLADO(Ln_IdGrupoPromocion,  
                                                                       Ln_IdTipoPromocion,    
                                                                       Lv_TipoPromocion,      
                                                                       Pv_CodEmpresa,      
                                                                       Lr_Punto_Promo.ID_PUNTO, 
                                                                       Pn_Valor,
                                                                       Ln_IdServicio, 
                                                                       Lv_Trama,
                                                                       Lv_MsjResultado);
            --
          END IF;
          --
          IF Lv_MsjResultado IS NOT NULL THEN  
            RAISE Le_ExceptionProceso;             
          END IF;
          --
          --Lv_ConfiguraBW: Variable que retorna el proceso para indicar si realiza las configuraciones técnicas.
          DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_PROMO_FINALIZADA(Ln_IdServicio,Lv_TipoPromocion,Pv_CodEmpresa,Lv_ConfiguraBW);
          --
        ELSE
          --
          --Proceso que da De Baja a registros de una promoción
          IF Pv_TipoProceso = 'CAMBIO_PLAN' THEN
            Lv_TipoProcesoBaja:='BAJA_PROMO_CAMBIO_PLAN';
          ELSE
            Lv_TipoProcesoBaja:='BAJA_PROMO';
          END IF;
          IF Pv_TipoProceso = 'TRASLADO' THEN
            Ln_IdServicioOrigen:= Pn_Valor;
            Lv_TipoProcesoBaja:='BAJA_PROMO_TRASLADO';
          END IF;
          --
          IF Pv_TipoProceso = 'CAMBIO_RAZON_SOCIAL' THEN
            Ln_IdServicioOrigen:= Pn_Valor;
            Lv_TipoProcesoBaja:='BAJA_PROMO_CAMBIO_RAZON_SOCIAL';
          END IF;

          DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_BAJA_PROMO_BW(Ln_IdServicioOrigen,Pv_CodEmpresa,Lv_TipoPromocion,Lv_TipoProcesoBaja,Lv_MsjResultado);

          IF Lv_MsjResultado IS NOT NULL THEN  
            RAISE Le_ExceptionProceso;             
          END IF;
          --
          Lv_TeniaPromo:= 'SI';
          --Proceso que realiza las validaciones necesarias para poder mapear una promoción.
          DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_MAPEA_PROMOCIONES_BW(Lv_TipoPromocion,
                                                                         Pv_CodEmpresa,
                                                                         Pv_TipoProceso,
                                                                         Ln_IdServicio,
                                                                         Pn_Valor,
                                                                         Lv_MapeaPromo,
                                                                         Ln_IdPlanSuperior,
                                                                         Lv_ConfiguraBW,
                                                                         Lv_EstadoProcesoValida,
                                                                         Lv_MsjResultado);
          --
          IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
            RAISE Le_ExceptionProceso;
          END IF;
          --
          IF Lv_MapeaPromo = 'SI' THEN
            Lv_AplicaPromo:= 'SI';
          ELSE
            Lv_AplicaPromo:= 'NO';
          END IF;
          --
          IF Lv_ConfiguraBW = 'NO' THEN
            --Verifica si tiene un registro de PierdePromo(Esquema Externo) del día y le da de Baja
            DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_PIERDE_PROMO_EXT(Ln_IdServicioOrigen,
                                                                       Lv_TipoPromocion,
                                                                       'INDIVIDUAL', 
                                                                       Pv_CodEmpresa,
                                                                       Lb_ExistePierdePromo);

          END IF;
          --
          --Elimina las características promocionales del servicio.
          DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_PROMO_BW(Ln_IdServicioOrigen, Lv_MsjResultado);
          --
          IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
            RAISE Le_ExceptionProceso;
          END IF;       
          --
          Lv_EstadoProcesoMapeo := Lv_EstadoProcesoValida;
          Pn_IdPlanSuperior     := Ln_IdPlanSuperior;
          --
        END IF;
      --
      ELSE
        --
        IF Pv_TipoProceso = 'TRASLADO' THEN
          Ln_IdServicioOrigen:= Pn_Valor;
        END IF;
        --
        --Proceso que da De Baja a registros de una promoción
        IF Pv_TipoProceso = 'CAMBIO_PLAN' THEN
          Lv_TipoProcesoBaja:='BAJA_PROMO_CAMBIO_PLAN';
        ELSE
          Lv_TipoProcesoBaja:='BAJA_PROMO';
        END IF;
        DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_BAJA_PROMO_BW(Ln_IdServicioOrigen,Pv_CodEmpresa,Lv_TipoPromocion,Lv_TipoProcesoBaja,Lv_MsjResultado);

        IF Lv_MsjResultado IS NOT NULL THEN  
          RAISE Le_ExceptionProceso;             
        END IF;
        --
        Lv_TeniaPromo:= 'SI';
        --Proceso que realiza las validaciones necesarias para poder mapear una promoción.
        DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_MAPEA_PROMOCIONES_BW(Lv_TipoPromocion,
                                                                       Pv_CodEmpresa,
                                                                       Pv_TipoProceso,
                                                                       Ln_IdServicio,
                                                                       Pn_Valor,
                                                                       Lv_MapeaPromo,
                                                                       Ln_IdPlanSuperior,
                                                                       Lv_ConfiguraBW,
                                                                       Lv_EstadoProcesoValida,
                                                                       Lv_MsjResultado);
        --                              
        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
          RAISE Le_ExceptionProceso;
        END IF;
        --
        IF Lv_MapeaPromo = 'SI' THEN
          Lv_AplicaPromo:= 'SI';
        ELSE
          Lv_AplicaPromo:= 'NO';
        END IF;
        --
        IF Lv_ConfiguraBW = 'NO' THEN
          --Verifica si tiene un registro de PierdePromo(Esquema Externo) del día y le da de Baja
          DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_PIERDE_PROMO_EXT(Ln_IdServicioOrigen,
                                                                     Lv_TipoPromocion,
                                                                     'INDIVIDUAL', 
                                                                     Pv_CodEmpresa,
                                                                     Lb_ExistePierdePromo);
          --
        END IF;
        --
        --Elimina las características promocionales del servicio.
        DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_PROMO_BW(Ln_IdServicioOrigen, Lv_MsjResultado);
        --
        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
          RAISE Le_ExceptionProceso;
        END IF;
        --
        Lv_EstadoProcesoMapeo := Lv_EstadoProcesoValida;
        Pn_IdPlanSuperior     := Ln_IdPlanSuperior;
        --
      END IF; 
    --
    ELSE
      --
      Lv_TeniaPromo:= 'NO';
      --Proceso que realiza las validaciones necesarias para poder mapear una promoción.
      DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_MAPEA_PROMOCIONES_BW(Lv_TipoPromocion,
                                                                     Pv_CodEmpresa,
                                                                     Pv_TipoProceso,
                                                                     Ln_IdServicio,
                                                                     Pn_Valor,
                                                                     Lv_MapeaPromo,
                                                                     Ln_IdPlanSuperior,
                                                                     Lv_ConfiguraBW,
                                                                     Lv_EstadoProcesoValida,
                                                                     Lv_MsjResultado);
      --
      IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
        RAISE Le_ExceptionProceso;
      END IF;
      --    
      IF Lv_MapeaPromo = 'SI' THEN
        Lv_AplicaPromo:= 'SI';
      ELSE
        Lv_AplicaPromo:= 'NO';
      END IF;
      --
      Lv_EstadoProcesoMapeo := Lv_EstadoProcesoValida;   
      Pn_IdPlanSuperior     := Ln_IdPlanSuperior;
      --
    END IF;
    --
    COMMIT;
    --
    Pv_TeniaPromo   := Lv_TeniaPromo;
    Pv_AplicaPromo  := Lv_AplicaPromo;
    Pv_MapeaPromo   := Lv_MapeaPromo;
    Pv_EstadoProceso:= Lv_EstadoProcesoMapeo;
    Pv_ConfiguraBW  := Lv_ConfiguraBW;
    --
  EXCEPTION
  WHEN Le_ExceptionProceso THEN
    --
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_PROCESO_MAPEO_PROMOCIONES_BW', 
                                         SUBSTR(Lv_MsjResultado,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion); 
    --
    Pv_TeniaPromo     := 'NO';
    Pv_AplicaPromo    := 'NO';
    Pv_MapeaPromo     := 'NO';
    Pn_IdPlanSuperior :=  0;
    Pv_EstadoProceso  := 'ERROR';
    Pv_ConfiguraBW    := 'NO';
    --
  WHEN OTHERS THEN
    --
    ROLLBACK;
    Lv_MsjResultado:= 'Ocurrió un error al ejecutar el Proceso de Mapeo de Promociones para el Grupo de Promocional: '||
                      Lv_TipoPromocion||', Tipo Proceso: '||Pv_TipoProceso||', IdServicio: '||Pn_IdServicio||', Valor: '||Pn_Valor;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_PROCESO_MAPEO_PROMOCIONES_BW', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);
     --
     Pv_TeniaPromo     := 'NO';
     Pv_AplicaPromo    := 'NO';
     Pv_MapeaPromo     := 'NO';
     Pn_IdPlanSuperior :=  0;
     Pv_EstadoProceso  := 'ERROR';
     Pv_ConfiguraBW    := 'NO';   
     --
  END P_PROCESO_MAPEO_PROMOCIONES_BW;                                          
  --
  --
  --
  PROCEDURE P_BAJA_PROMO_BW (Pn_IdServicio   IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                             Pv_Empresa      IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                             Pv_TipoPromo    IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                             Pv_TipoProceso  IN  VARCHAR2,
                             Pv_Mensaje     OUT VARCHAR2)
  IS

    --Costo: 6
    CURSOR C_RegistrosMapeados(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                               Cv_TipoPromo  DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                               Cv_Empresa    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Cv_Estado     DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE)
    IS
      SELECT IDMP.ID_DETALLE_MAPEO, 
        IDMP.FE_MAPEO,
        IDMS.ID_MAPEO_SOLICITUD,
        IDMS.PLAN_ID,
        IDMS.PLAN_ID_SUPERIOR
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
      WHERE IDMP.TIPO_PROMOCION IN (SELECT DET.VALOR2 
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                      DB_GENERAL.ADMI_PARAMETRO_DET DET
                                    WHERE CAB.NOMBRE_PARAMETRO = 'PROM_TIPO_PROMOCIONES'
                                    AND CAB.ESTADO             = Cv_Estado
                                    AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                    AND DET.VALOR3             = Cv_TipoPromo
                                    AND DET.ESTADO             = Cv_Estado)
      AND IDMP.EMPRESA_COD      = Cv_Empresa
      AND IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID
      AND IDMS.ESTADO           = Cv_estado
      AND IDMS.SERVICIO_ID      = Cn_IdServicio;

    --Costo: 3
    CURSOR C_EstadoServio(Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT ISH.ESTADO 
      FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
      WHERE ISH.ID_SERVICIO_HISTORIAL IN (SELECT MAX(DBISH.ID_SERVICIO_HISTORIAL) AS ID_SERVICIO_HISTORIAL 
                                          FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH 
                                          WHERE DBISH.SERVICIO_ID = Cn_IdServicio);

    Lv_IpCreacion             VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1')); 
    Lv_UsuarioCreacion        VARCHAR2(15):= 'telcos_promo_bw';
    Lv_msj                    VARCHAR2(4000);
    Ln_IdProcesoPromo         NUMBER;
    Lv_NombrePlan             VARCHAR2(100);
    Lv_LineProfilePromo       VARCHAR2(100);
    lv_tipo_proceso           VARCHAR2(100);
    Ln_ObsBajaPromo           DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE;
    Ln_ObsServicio            DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE;
    Lv_EstadoServio           DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.ESTADO%TYPE;
    Lv_estado                 DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE := 'Activo';
    Lr_InfoDetalleMapeoPromo  DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE;
    Lr_InfoDetMapSolicitud    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD%ROWTYPE;
    Lr_InfoDetalleMapeoHisto  DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
    Lr_InfoServicioHistorial  DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lr_InfoProcesoRDA         DB_COMERCIAL.CMKG_PROMOCIONES_BW.Gr_ProcesoPromo; 
    Lr_InfoProcesoPromoHist  DB_EXTERNO.INFO_PROCESO_PROMO_HIST%ROWTYPE;
    La_PromocionExterna       DB_EXTERNO.Gtl_Promociones;
    Le_Exception              EXCEPTION;

  BEGIN
  --
    FOR Lc_RegistrosMapeados IN C_RegistrosMapeados (Pn_IdServicio,
                                                     Pv_tipoPromo,
                                                     Pv_Empresa,
                                                     Lv_estado) 
    LOOP
      IF Pv_TipoProceso IN ('BAJA_PROMO','BAJA_PROMO_CAMBIO_PLAN','BAJA_PROMO_TRASLADO','BAJA_PROMO_CAMBIO_RAZON_SOCIAL') THEN
        --
        Lr_InfoDetalleMapeoPromo                        := NULL;
        Lr_InfoDetalleMapeoPromo.ID_DETALLE_MAPEO       := Lc_RegistrosMapeados.ID_DETALLE_MAPEO;
        Lr_InfoDetalleMapeoPromo.FE_ULT_MOD             := SYSDATE;
        Lr_InfoDetalleMapeoPromo.USR_ULT_MOD            := Lv_UsuarioCreacion;
        Lr_InfoDetalleMapeoPromo.IP_ULT_MOD             := Lv_IpCreacion;
        Lr_InfoDetalleMapeoPromo.ESTADO                 := 'Baja';
        --
        DB_COMERCIAL.CMKG_PROMOCIONES.P_UPDATE_DETALLE_MAPEO_PROM(Lr_InfoDetalleMapeoPromo,Lv_msj);

        IF TRIM(Lv_msj) IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;

        Lr_InfoDetMapSolicitud                     := NULL;
        Lr_InfoDetMapSolicitud.ID_MAPEO_SOLICITUD  := Lc_RegistrosMapeados.ID_MAPEO_SOLICITUD;
        Lr_InfoDetMapSolicitud.FE_ULT_MOD          := SYSDATE;
        Lr_InfoDetMapSolicitud.USR_ULT_MOD         := Lv_UsuarioCreacion;
        Lr_InfoDetMapSolicitud.IP_ULT_MOD          := Lv_IpCreacion;
        Lr_InfoDetMapSolicitud.ESTADO              := 'Baja';
        --
        DB_COMERCIAL.CMKG_PROMOCIONES.P_UPDATE_DET_MAP_SOLIC(Lr_InfoDetMapSolicitud,Lv_msj);

        IF TRIM(Lv_msj) IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;

        Lr_InfoDetalleMapeoHisto                         := NULL;
        Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
        Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Lc_RegistrosMapeados.ID_DETALLE_MAPEO;
        Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
        Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_UsuarioCreacion;
        Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
        Lr_InfoDetalleMapeoHisto.OBSERVACION             := 'El servicio pierde promoción indefinidamente para el tipo : '||Pv_tipoPromo;
        Lr_InfoDetalleMapeoHisto.ESTADO                  := 'Baja';
        --
        DB_COMERCIAL.CMKG_PROMOCIONES.P_UPDATE_DET_MAP_SOLIC(Lr_InfoDetMapSolicitud,Lv_msj);
        DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto,Lv_msj);

        IF TRIM(Lv_msj) IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;
        --
        --observacion del servicio
        IF Pv_TipoProceso in ('BAJA_PROMO_CAMBIO_PLAN','BAJA_PROMO_TRASLADO','BAJA_PROMO_CAMBIO_RAZON_SOCIAL') THEN
           lv_tipo_proceso := SUBSTRB(Pv_TipoProceso,12);
           --
            SELECT ID_PROCESO_PROMO INTO Ln_IdProcesoPromo FROM DB_EXTERNO.INFO_PROCESO_PROMO
            WHERE DETALLE_MAPEO_ID = Lc_RegistrosMapeados.ID_DETALLE_MAPEO;
            --actualizar estado
            UPDATE DB_EXTERNO.INFO_PROCESO_PROMO SET ESTADO = 'Baja' WHERE ID_PROCESO_PROMO = Ln_IdProcesoPromo;
            --ingresar historial proceso promo
            Lr_InfoProcesoPromoHist                       :=  NULL;
            Lr_InfoProcesoPromoHist.ID_PROCESO_PROMO_HIST :=  DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_HIST.NEXTVAL;
            Lr_InfoProcesoPromoHist.PROCESO_PROMO_ID      :=  Ln_IdProcesoPromo;
            Lr_InfoProcesoPromoHist.ESTADO                :=  'Baja';
            Lr_InfoProcesoPromoHist.OBSERVACION           :=  'La promoción fué dada de baja, ID_DETALLE_MAPEO: '
                                                              ||Lc_RegistrosMapeados.ID_DETALLE_MAPEO;
            Lr_InfoProcesoPromoHist.FE_CREACION           :=  SYSDATE;
            Lr_InfoProcesoPromoHist.USR_CREACION          :=  Lv_UsuarioCreacion;
            Lr_InfoProcesoPromoHist.IP_CREACION           :=  Lv_IpCreacion;
            DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_INSERT_PROCESO_PROMO_HIST(Lr_InfoProcesoPromoHist,Lv_msj);
            --
            SELECT NOMBRE_PLAN INTO Lv_NombrePlan FROM DB_COMERCIAL.INFO_PLAN_CAB WHERE ID_PLAN = Lc_RegistrosMapeados.PLAN_ID;
            Lv_LineProfilePromo := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(Lc_RegistrosMapeados.PLAN_ID_SUPERIOR);
            --
            Ln_ObsServicio := 'Se anula promoción de ancho de banda en el punto del cliente por '|| lv_tipo_proceso ||'.';
            Ln_ObsServicio := Ln_ObsServicio || '<br>Nombre de plan contratado: <b>' || Lv_NombrePlan || '</b>';
            Ln_ObsServicio := Ln_ObsServicio || '<br>Line profile de la promoción: <b>' || Lv_LineProfilePromo || '</b>';
        END IF;
      END IF;
      --      
      IF Pv_TipoProceso not in ('BAJA_PROMO_CAMBIO_PLAN','BAJA_PROMO_TRASLADO','BAJA_PROMO_CAMBIO_RAZON_SOCIAL') THEN
          La_PromocionExterna := DB_EXTERNO.Gtl_Promociones();
          La_PromocionExterna.EXTEND(1);      
          La_PromocionExterna(1) := DB_EXTERNO.Gr_Promocion(NULL,
                                                            Lc_RegistrosMapeados.ID_DETALLE_MAPEO,
                                                            'Baja',
                                                            'La promoción fué dada de baja, ID_DETALLE_MAPEO: '
                                                            ||Lc_RegistrosMapeados.ID_DETALLE_MAPEO,
                                                            'BAJA',
                                                            NULL);

          DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_UPDATE_PROMOCIONES(La_PromocionExterna,
                                                              Lv_UsuarioCreacion,
                                                              Lv_IpCreacion,
                                                              Lv_msj);
          IF TRIM(Lv_msj) IS NOT NULL THEN
            RAISE Le_Exception;
          END IF;  
      END IF;
      --
      --
      IF Pv_TipoProceso = 'CAMBIO_PLAN_RDA' OR Pv_TipoProceso = 'MIGRACION_EQUIPO_RDA' THEN
        --
        --Elimina las características promocionales del servicio.
        DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_PROMO_BW(Pn_IdServicio, Lv_msj);
        --
        IF TRIM(Lv_msj) IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;
        --
        Lr_InfoProcesoRDA                    := NULL;
        Lr_InfoProcesoRDA.EMPRESA_COD        := Pv_Empresa;
        Lr_InfoProcesoRDA.SERVICIO_ID        := Pn_IdServicio;
        Lr_InfoProcesoRDA.DETALLE_MAPEO_ID   := Lc_RegistrosMapeados.ID_DETALLE_MAPEO;
        Lr_InfoProcesoRDA.FE_INI_MAPEO       := Lc_RegistrosMapeados.FE_MAPEO;
        Lr_InfoProcesoRDA.FE_FIN_MAPEO       := ADD_MONTHS(Lc_RegistrosMapeados.FE_MAPEO,1);
        Lr_InfoProcesoRDA.USR_CREACION       := Lv_UsuarioCreacion;
        Lr_InfoProcesoRDA.IP_CREACION        := Lv_IpCreacion;
        Lr_InfoProcesoRDA.TIPO_PROCESO       := 'AplicaPromo';
        Lr_InfoProcesoRDA.TIPO_PROMO         := 'PROM_BW';
        --
        DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PREPARA_DATA_PROCESO_PROMO(Lr_InfoProcesoRDA, Lv_msj);
        --
        IF TRIM(Lv_msj) IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;  
        --
        Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
        Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Lc_RegistrosMapeados.ID_DETALLE_MAPEO;
        Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
        Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_UsuarioCreacion;
        Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_IpCreacion;
        Lr_InfoDetalleMapeoHisto.OBSERVACION             := 'Se ingresó correctamente la información para RDA, tipo de proceso AplicaPromo, con Id_Detalle_Mapeo: '
                                                            ||Lc_RegistrosMapeados.ID_DETALLE_MAPEO;
        Lr_InfoDetalleMapeoHisto.ESTADO                  := 'Activo';
        --
        DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto, Lv_msj);      
        --
        IF TRIM(Lv_msj) IS NOT NULL THEN
          RAISE Le_Exception;
        END IF;  
        --
      END IF; 
      --
    END LOOP;
    --

    IF Pv_TipoProceso = 'BAJA_PROMO' THEN
      Ln_ObsBajaPromo:= 'El servicio pierde promoción indefinidamente para el tipo : ';          
    END IF;

    IF Pv_TipoProceso = 'CAMBIO_PLAN_RDA' OR Pv_TipoProceso = 'MIGRACION_EQUIPO_RDA' THEN
      Ln_ObsBajaPromo:= 'Se actualizaron las capaciadades de Ancho de Banda del Servicio para el tipo: ';
    END IF;

    IF Pv_TipoProceso not in ('BAJA_PROMO_CAMBIO_PLAN','BAJA_PROMO_TRASLADO','BAJA_PROMO_CAMBIO_RAZON_SOCIAL') THEN
      Ln_ObsServicio := Ln_ObsBajaPromo || Pv_tipoPromo;          
    END IF;

    IF C_EstadoServio%ISOPEN THEN
      CLOSE C_EstadoServio;
    END IF;

    OPEN C_EstadoServio(Pn_IdServicio);
    FETCH C_EstadoServio INTO Lv_EstadoServio;
    CLOSE C_EstadoServio;

    Lr_InfoServicioHistorial                        := NULL;
    Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
    Lr_InfoServicioHistorial.SERVICIO_ID            := Pn_IdServicio;
    Lr_InfoServicioHistorial.USR_CREACION           := Lv_UsuarioCreacion;
    Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
    Lr_InfoServicioHistorial.IP_CREACION            := Lv_IpCreacion;
    Lr_InfoServicioHistorial.ESTADO                 := Lv_EstadoServio;
    Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
    Lr_InfoServicioHistorial.OBSERVACION            := Ln_ObsServicio;
    Lr_InfoServicioHistorial.ACCION                 := NULL;
    --
    DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial,Lv_msj); 
    --
    IF TRIM(Lv_msj) IS NOT NULL THEN
      RAISE Le_Exception;
    END IF;
  --
  EXCEPTION
  WHEN Le_Exception THEN
  --
    Lv_msj     := 'Ocurrió un error al actualizar la información para el servico : ' || Pn_IdServicio || ' - ' || Lv_msj;
    Pv_Mensaje := Lv_msj;

    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_BW.P_BAJA_PROMO_BW', 
                                         SUBSTR(Lv_msj,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion); 
  WHEN OTHERS THEN
  --
    Lv_msj     := 'Ocurrió un error al actualizar la información para el servico : ' || Pn_IdServicio;
    Pv_Mensaje := Lv_msj;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES_BW.P_BAJA_PROMO_BW', 
                                         SUBSTR(Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);    
  END P_BAJA_PROMO_BW;
  --
  --
  --
  PROCEDURE P_PIERDE_PROMO_BW (Pv_Empresa      IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                               Pv_TipoPromo    IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE) 
  IS

    --Cosot: 1306
    CURSOR C_ClientesMapeo (Cv_Empresa   DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                            Cv_TipoPromo DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE)
    IS  
      SELECT IDMP.ID_DETALLE_MAPEO,
        IDMS.SERVICIO_ID,
        IDMP.GRUPO_PROMOCION_ID,
        IDMP.TIPO_PROMOCION_ID,
        IDMP.PERSONA_EMPRESA_ROL_ID,
        IDMP.PUNTO_ID,
        IDMP.TIPO_PROMOCION,
        IDMP.INDEFINIDO,
        IDMP.FE_MAPEO,
        IDMS.ESTADO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
        DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISH
      WHERE IDMP.EMPRESA_COD                 = Cv_Empresa
        AND IDMP.ESTADO                      in ('Activo','Finalizado')
        AND IDMP.TIPO_PROMOCION              = Cv_TipoPromo
        AND TO_CHAR(IDMP.FE_MAPEO,'MM/YYYY') = TO_CHAR(SYSDATE,'MM/YYYY')
        AND IDMS.DETALLE_MAPEO_ID            = IDMP.ID_DETALLE_MAPEO
        AND IDMS.ESTADO                      in ('Activo','Finalizado')
        AND ISH.ID_SERVICIO_HISTORIAL        = (SELECT MAX(DBISH.ID_SERVICIO_HISTORIAL) AS ID_SERVICIO_HISTORIAL 
                                                FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL DBISH 
                                                WHERE DBISH.SERVICIO_ID = IDMS.SERVICIO_ID)
        AND ISH.ESTADO                       = 'Activo'
        ORDER BY IDMP.ID_DETALLE_MAPEO ASC;


    --Costo: 1        
    CURSOR C_TipoPromocion (Cn_Id_Tipo_Promocion NUMBER)
    IS
      SELECT UPPER(TRIM(ATP.ESTADO)) AS ESTADO
      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP 
      WHERE ATP.ID_TIPO_PROMOCION = Cn_Id_Tipo_Promocion;

    --Costo: 14        
    CURSOR C_DatosServicio (Cn_IdServicio        DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                            Cn_Id_Promocion      DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                            Cn_Id_Persona_rol    DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL.ID_PERSONA_ROL%TYPE,
                            Cn_Id_Punto          DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                            Cn_Id_Tipo_Promocion DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE)
    IS
      SELECT IP.LOGIN,
        ISE.ESTADO,
        (SELECT DBIELEM.SERIE_FISICA 
         FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO DBIELEM
         WHERE DBIELEM.ID_ELEMENTO = IST.ELEMENTO_CLIENTE_ID) AS SERIE_FISICA,
        IELEM.NOMBRE_ELEMENTO,
        IPC.TIPO,
        DBIIE.NOMBRE_INTERFACE_ELEMENTO,
        (SELECT MIN(IDMP.FE_MAPEO)
         FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
         WHERE IDMP.GRUPO_PROMOCION_ID     = Cn_Id_Promocion
           AND IDMP.PERSONA_EMPRESA_ROL_ID = Cn_Id_Persona_rol
           AND IDMP.PUNTO_ID               = Cn_Id_Punto
           AND IDMP.TIPO_PROMOCION_ID      = Cn_Id_Tipo_Promocion) AS FE_MAPEO,
        AME.NOMBRE_MODELO_ELEMENTO
      FROM DB_COMERCIAL.INFO_SERVICIO ISE, 
        DB_COMERCIAL.INFO_PUNTO IP,
        DB_COMERCIAL.INFO_SERVICIO_TECNICO IST,
        DB_INFRAESTRUCTURA.INFO_ELEMENTO IELEM,
        DB_COMERCIAL.INFO_PLAN_CAB IPC,
        DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO DBIIE,
        DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AME
      WHERE IPC.ID_PLAN               = ISE.PLAN_ID
      AND DBIIE.ID_INTERFACE_ELEMENTO = IST.INTERFACE_ELEMENTO_ID
      AND AME.ID_MODELO_ELEMENTO      = IELEM.MODELO_ELEMENTO_ID
      AND IELEM.ID_ELEMENTO           = IST.ELEMENTO_ID
      AND IST.SERVICIO_ID             = ISE.ID_SERVICIO
      AND IP.ID_PUNTO                 = ISE.PUNTO_ID
      AND ISE.ID_SERVICIO             = Cn_IdServicio;

    Lc_Tipo_Promocion         C_TipoPromocion%ROWTYPE;
    La_ClientesProcesar       T_ClientesPromoBw;
    Lr_InfoProcesoRDA         DB_COMERCIAL.CMKG_PROMOCIONES_BW.Gr_ProcesoPromo; 
    Ln_IdDetalleMapeo         DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE;
    Ld_FechaPierdeMapeo       DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.FE_MAPEO%TYPE;
    --
    Ln_Indx                   NUMBER;      
    Le_Exception              EXCEPTION;  
    Lb_ValidaRegla            BOOLEAN;
    Lb_TieneSgteMapeo         BOOLEAN;
    Lb_ExistePierdePromoExt   BOOLEAN;
    Lb_EliminaCaract          BOOLEAN;
    Lv_msj                    VARCHAR2(4000);
    Lv_TipoProcesoBaja        VARCHAR2(50); 
    Lv_TipoEvaluacion         VARCHAR2(15):= 'EXISTENTE';
    Lv_TipoProcConsulta       VARCHAR2(50):= 'MASIVO_CONSULTA';
    Lv_TipoProcBaja           VARCHAR2(50):= 'MASIVO_BAJA';
    Lv_UsuarioCreacion        VARCHAR2(15):= 'telcos_promo_bw';
    Lv_IpCreacion             VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lr_ParametrosValidarSec   DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;   
    --
  BEGIN
  --
    IF C_TipoPromocion%ISOPEN THEN
      CLOSE C_TipoPromocion;
    END IF;
    --
    OPEN C_ClientesMapeo (Pv_Empresa,Pv_TipoPromo);
    --
    LOOP
    FETCH C_ClientesMapeo BULK COLLECT
    --
      INTO La_ClientesProcesar LIMIT 1000;
      EXIT WHEN La_ClientesProcesar.count = 0;
      Ln_Indx := La_ClientesProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)
      LOOP
       --
        BEGIN

          Lb_ValidaRegla  := TRUE;
          Lb_EliminaCaract:= FALSE;
          --
          IF La_ClientesProcesar(Ln_Indx).ESTADO = 'Activo' THEN
            --           
            OPEN C_TipoPromocion(La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID);
            FETCH C_TipoPromocion INTO Lc_Tipo_Promocion;
            CLOSE C_TipoPromocion;

            IF Lc_Tipo_Promocion.ESTADO = 'BAJA' THEN
              Lb_ValidaRegla := FALSE;
            END IF;

            Lr_ParametrosValidarSec                    :=  NULL;
            Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION :=  La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID;
            Lr_ParametrosValidarSec.ID_SERVICIO        :=  La_ClientesProcesar(Ln_Indx).ID_SERVICIO;
            Lr_ParametrosValidarSec.TIPO_EVALUACION    :=  Lv_TipoEvaluacion;
            Lr_ParametrosValidarSec.TIPO_PROMOCION     :=  La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION;--ANCHO DE BANDA
            Lr_ParametrosValidarSec.EMPRESA_COD        :=  Pv_Empresa;

            IF Lb_ValidaRegla AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec)) THEN
              Lb_ValidaRegla := FALSE;
            END IF;

            IF Lb_ValidaRegla AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(
                    La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,La_ClientesProcesar(Ln_Indx).PUNTO_ID)) THEN
              Lb_ValidaRegla := FALSE;
            END IF;

            IF Lb_ValidaRegla AND NOT (DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ULTIMA_MILLA(
                    La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,La_ClientesProcesar(Ln_Indx).ID_SERVICIO)) THEN
              Lb_ValidaRegla := FALSE;
            END IF;

            IF Lb_ValidaRegla AND NOT ( DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TIPO_NEGOCIO(
                                        Fn_IntIdPromocion => La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                        Fn_IdServicio     => La_ClientesProcesar(Ln_Indx).ID_SERVICIO,
                                        Fv_CodEmpresa     => Pv_Empresa)) THEN
              Lb_ValidaRegla := FALSE;
            END IF;
            --
          END IF;
          --

          DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_OBTIENE_SIGUIENTE_MAPEO(La_ClientesProcesar(Ln_Indx).GRUPO_PROMOCION_ID,
                                                                     La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION_ID,
                                                                     La_ClientesProcesar(Ln_Indx).PUNTO_ID,
                                                                     La_ClientesProcesar(Ln_Indx).ID_SERVICIO,
                                                                     Pv_Empresa,
                                                                     Lb_TieneSgteMapeo);
          --
          DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_PIERDE_PROMO_EXT(La_ClientesProcesar(Ln_Indx).ID_SERVICIO,
                                                                     La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                                                     Lv_TipoProcConsulta, 
                                                                     Pv_Empresa,
                                                                     Lb_ExistePierdePromoExt);

          IF NOT Lb_ValidaRegla OR ((NOT Lb_TieneSgteMapeo) AND (NOT Lb_ExistePierdePromoExt)) THEN 
            --              
            Ln_IdDetalleMapeo  := NULL;
            Ld_FechaPierdeMapeo:= ADD_MONTHS((La_ClientesProcesar(Ln_Indx).FE_MAPEO)+1,1);

            IF NOT Lb_ValidaRegla THEN
              --
              Lv_TipoProcesoBaja := 'BAJA_PROMO';
              Lb_EliminaCaract   := TRUE;             

              DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_BAJA_PROMO_BW(La_ClientesProcesar(Ln_Indx).ID_SERVICIO,
                                                               Pv_Empresa,
                                                               Pv_TipoPromo,
                                                               Lv_TipoProcesoBaja,
                                                               Lv_msj);

              IF TRIM(Lv_msj) IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              --
              DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_PIERDE_PROMO_EXT(La_ClientesProcesar(Ln_Indx).ID_SERVICIO,
                                                                         La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION,
                                                                         Lv_TipoProcBaja, 
                                                                         Pv_Empresa,
                                                                         Lb_ExistePierdePromoExt);

              IF TRIM(Lv_msj) IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              --
              Ln_IdDetalleMapeo  := La_ClientesProcesar(Ln_Indx).ID_DETALLE_MAPEO;
              Ld_FechaPierdeMapeo:= SYSDATE;
              --
            END IF;
            --
            Lr_InfoProcesoRDA                    := NULL;
            Lr_InfoProcesoRDA.EMPRESA_COD        := Pv_Empresa;
            Lr_InfoProcesoRDA.SERVICIO_ID        := La_ClientesProcesar(Ln_Indx).ID_SERVICIO;
            Lr_InfoProcesoRDA.DETALLE_MAPEO_ID   := Ln_IdDetalleMapeo;
            Lr_InfoProcesoRDA.FE_INI_MAPEO       := Ld_FechaPierdeMapeo;
            Lr_InfoProcesoRDA.FE_FIN_MAPEO       := Ld_FechaPierdeMapeo;
            Lr_InfoProcesoRDA.USR_CREACION       := Lv_UsuarioCreacion;
            Lr_InfoProcesoRDA.IP_CREACION        := Lv_IpCreacion;
            Lr_InfoProcesoRDA.TIPO_PROCESO       := 'PierdePromo';
            Lr_InfoProcesoRDA.TIPO_PROMO         := La_ClientesProcesar(Ln_Indx).TIPO_PROMOCION;
            --
            DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PREPARA_DATA_PROCESO_PROMO(Lr_InfoProcesoRDA, Lv_msj);   
            --
            IF TRIM(Lv_msj) IS NOT NULL THEN
              RAISE Le_Exception;
            END IF;
            --  
            IF Lb_EliminaCaract THEN
              --Elimina las características promocionales del servicio.
              DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_PROMO_BW(La_ClientesProcesar(Ln_Indx).ID_SERVICIO, Lv_msj);
              --
              IF TRIM(Lv_msj) IS NOT NULL THEN
                RAISE Le_Exception;
              END IF;
              --
            END IF;
            --
          END IF;
        --
        COMMIT;

        EXCEPTION                   
        WHEN Le_Exception THEN
          --
          ROLLBACK;
          Lv_msj := 'Ocurrió un error al evaluar el servcio: ' || La_ClientesProcesar(Ln_Indx).ID_SERVICIO 
                    || ' para el script de perdida de promoción.'|| 'Error: '||Lv_msj; 
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                               'CMKG_PROMOCIONES.P_PIERDE_PROMO_BW', 
                                               SUBSTR(Lv_msj,0,4000),
                                               Lv_UsuarioCreacion,
                                               SYSDATE,
                                               Lv_IpCreacion); 

        WHEN OTHERS THEN
          --
          ROLLBACK;
          Lv_msj := 'Ocurrió un error al evaluar el servcio: ' || La_ClientesProcesar(Ln_Indx).ID_SERVICIO 
                    || ' para el script de perdida de promoción.'; 
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                               'CMKG_PROMOCIONES.P_PIERDE_PROMO_BW', 
                                               SUBSTR(Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                               Lv_UsuarioCreacion,
                                               SYSDATE,
                                               Lv_IpCreacion); 
        END;
        Ln_Indx := La_ClientesProcesar.NEXT (Ln_Indx);
      --
      END LOOP;
    --
    END LOOP;

  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    Lv_msj := 'Ocurrió un error al ejecutar el script de perdida de promociones.'; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES.P_PIERDE_PROMO_BW', 
                                         Lv_msj || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);    
  END P_PIERDE_PROMO_BW;
  --
  --
  --
  FUNCTION F_NUMERO_IPS_FIJAS(Fn_IdPunto    IN DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                              Fn_IdServicio IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                              Fv_Empresa    IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    RETURN NUMBER
  IS

    --Costo: 11
    CURSOR C_ServiciosPunto(Cn_IdPunto    DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                            Cn_IdServicio DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE)
    IS
      SELECT ISERV.PRODUCTO_ID,
        ISERV.PLAN_ID
      FROM DB_COMERCIAL.INFO_SERVICIO ISERV,
        (SELECT DBISERV.ID_SERVICIO,
           DBISERV.ESTADO 
         FROM DB_COMERCIAL.INFO_SERVICIO DBISERV 
         WHERE DBISERV.ID_SERVICIO = Cn_IdServicio)T
      WHERE ISERV.PUNTO_ID  = Cn_IdPunto
      AND ISERV.ID_SERVICIO != T.ID_SERVICIO
      AND ISERV.ESTADO      = T.ESTADO;

    --Costo: 11
    CURSOR C_IpsPorProductos(Cn_ProductoId DB_COMERCIAL.ADMI_PRODUCTO.ID_PRODUCTO%TYPE,
                             Cv_Empresa    DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT DBAP.ID_PRODUCTO 
      FROM DB_COMERCIAL.ADMI_PRODUCTO DBAP
      WHERE DBAP.ID_PRODUCTO  = Cn_ProductoId
      AND DBAP.ESTADO         = 'Activo' 
      AND DBAP.EMPRESA_COD    = Cv_Empresa 
      AND DBAP.NOMBRE_TECNICO = 'IP';

    --Costo: 11
    CURSOR C_IpsPorPlan(Cn_PlanId  DB_COMERCIAL.INFO_PLAN_CAB.ID_PLAN%TYPE,
                        Cv_Empresa DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS
      SELECT DBAP.ID_PRODUCTO 
      FROM DB_COMERCIAL.INFO_PLAN_DET IPD,
        DB_COMERCIAL.ADMI_PRODUCTO DBAP
      WHERE IPD.PLAN_ID       = Cn_PlanId 
      AND DBAP.ESTADO         = 'Activo' 
      AND DBAP.EMPRESA_COD    = Cv_Empresa 
      AND DBAP.NOMBRE_TECNICO = 'IP'
      AND DBAP.ID_PRODUCTO    = IPD.PRODUCTO_ID;

    Ln_IpsFijas         NUMBER := 0;
    Lv_MsjResultado     VARCHAR2(4000);
    Lc_IpsPorProductos  C_IpsPorProductos%ROWTYPE;
    Lc_IpsPorPlan       C_IpsPorPlan%ROWTYPE;
    Lv_UsuarioCreacion  VARCHAR2(15) := 'telcos_promo_bw';

  BEGIN
  --
    IF C_IpsPorPlan%ISOPEN THEN
    --
      CLOSE C_IpsPorPlan;
    --
    END IF;

    IF C_IpsPorProductos%ISOPEN THEN
    --
      CLOSE C_IpsPorProductos;
    --
    END IF;   

    FOR Lr_ServiciosPunto IN C_ServiciosPunto(Fn_IdPunto,
                                              Fn_IdServicio)
    LOOP
    --
      IF Lr_ServiciosPunto.PLAN_ID IS NOT NULL THEN
        OPEN C_IpsPorPlan (Lr_ServiciosPunto.PLAN_ID,
                           Fv_Empresa);
        FETCH C_IpsPorPlan INTO Lc_IpsPorPlan;
        CLOSE C_IpsPorPlan;

        IF Lc_IpsPorPlan.ID_PRODUCTO IS NOT NULL THEN
          Ln_IpsFijas := Ln_IpsFijas + 1;
        END IF;
      END IF;
      --
      --
      IF Lr_ServiciosPunto.PRODUCTO_ID IS NOT NULL THEN
        OPEN C_IpsPorProductos (Lr_ServiciosPunto.PRODUCTO_ID,
                                Fv_Empresa);
        FETCH C_IpsPorProductos INTO Lc_IpsPorProductos;
        CLOSE C_IpsPorProductos;

        IF Lc_IpsPorProductos.ID_PRODUCTO IS NOT NULL THEN
          Ln_IpsFijas := Ln_IpsFijas + 1;
        END IF;
      END IF;
    --
    END LOOP; 
    --
    RETURN Ln_IpsFijas;
  EXCEPTION
  WHEN OTHERS THEN
  --
    Lv_MsjResultado := 'Ocurrió un error al obtener el número de ip fijas para el ID_PUNTO: ' || Fn_IdPunto; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos +', 
                                         'CMKG_PROMOCIONES.F_NUMERO_IPS_FIJAS', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    RETURN 0;
  END F_NUMERO_IPS_FIJAS;
  --
  --
  --
  PROCEDURE P_OBTIENE_SIGUIENTE_MAPEO(Pn_IdGrupoPromocion    IN  DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                      Pn_IdTipoPromocion     IN  DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                      Pn_IdPunto             IN  DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                      Pn_IdServicio          IN  DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_Empresa             IN  DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pb_SiguienteMapeoBw    OUT BOOLEAN)
  IS    
    --
    --Costo del Query C_ObtieneSiguienteMapeo: 4
    CURSOR C_ObtieneSiguienteMapeo(Cn_IdGrupoPromocion    DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
                                   Cn_IdTipoPromocion     DB_COMERCIAL.ADMI_TIPO_PROMOCION.ID_TIPO_PROMOCION%TYPE,
                                   Cn_IdPunto             DB_COMERCIAL.INFO_PUNTO.ID_PUNTO%TYPE,
                                   Cn_IdServicio          DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                   Cv_Empresa             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE)
    IS  
      SELECT IDMP.ID_DETALLE_MAPEO,
        IDMP.FE_MAPEO
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
        DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS
      WHERE IDMP.EMPRESA_COD                 = Cv_Empresa
        AND IDMP.TIPO_PROMOCION_ID           = Cn_IdTipoPromocion
        AND IDMP.GRUPO_PROMOCION_ID          = Cn_IdGrupoPromocion
        AND IDMP.PUNTO_ID                    = Cn_IdPunto
        AND TO_CHAR(IDMP.FE_MAPEO,'MM/YYYY') = TO_CHAR(ADD_MONTHS(SYSDATE, 1),'MM/YYYY')
        AND IDMS.DETALLE_MAPEO_ID            = IDMP.ID_DETALLE_MAPEO
        AND IDMS.ESTADO                      in ('Activo','Finalizado')
        AND IDMS.SERVICIO_ID                 = Cn_IdServicio
        AND ROWNUM                           = 1;
    -- 
    Lc_SiguienteMapeoBw  C_ObtieneSiguienteMapeo%ROWTYPE;
    Lb_TieneSgteMapeoBw  BOOLEAN:= FALSE;
    Lv_MsjResultado      VARCHAR2(4000);   
    Lv_UsuarioCreacion   VARCHAR2(15):= 'telcos_promo_bw';
    Lv_IpCreacion        VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
  BEGIN
  --
    IF C_ObtieneSiguienteMapeo%ISOPEN THEN
      CLOSE C_ObtieneSiguienteMapeo;
    END IF;
    --
    OPEN C_ObtieneSiguienteMapeo(Pn_IdGrupoPromocion,
                                 Pn_IdTipoPromocion,      
                                 Pn_IdPunto,
                                 Pn_IdServicio,
                                 Pv_Empresa);
    FETCH C_ObtieneSiguienteMapeo INTO Lc_SiguienteMapeoBw;
    --
    IF C_ObtieneSiguienteMapeo%FOUND THEN
      Lb_TieneSgteMapeoBw:=TRUE;
    END IF;

    CLOSE C_ObtieneSiguienteMapeo;
    --
    Pb_SiguienteMapeoBw:= Lb_TieneSgteMapeoBw;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --    
    IF C_ObtieneSiguienteMapeo%ISOPEN THEN
      CLOSE C_ObtieneSiguienteMapeo;
    END IF;
    --
    Lv_MsjResultado := 'Ocurrió un error al obtener información del Siguiente Mapeo para el Grupo de Promocional: PROM_BW'
                       ||', Id Grupo Pormoción: '|| Pn_IdGrupoPromocion||', Id Servicio: ' || Pn_IdServicio; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_OBTIENE_SIGUIENTE_MAPEO', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);       
    --
    Pb_SiguienteMapeoBw:=FALSE;
    --
  END P_OBTIENE_SIGUIENTE_MAPEO;
  --
  --
  --
  PROCEDURE P_VALIDA_PIERDE_PROMO_EXT(Pn_IdServicio         IN  DB_EXTERNO.INFO_PROCESO_PROMO.SERVICIO_ID%TYPE,
                                      Pv_TipoPromocion      IN  DB_EXTERNO.INFO_PROCESO_PROMO.TIPO_PROMO%TYPE,
                                      Pv_TipoProceso        IN  DB_EXTERNO.INFO_PROCESO_PROMO.TIPO_PROCESO%TYPE, 
                                      Pv_CodEmpresa         IN  DB_EXTERNO.INFO_PROCESO_PROMO.EMPRESA_COD%TYPE,
                                      Pb_ExistePierdePromo  OUT BOOLEAN)
  IS    
    --  
    Ln_Indx                 NUMBER;
    Ln_ContReg              NUMBER:= 0; 
    Lb_TieneRegPierdePromo  BOOLEAN:= FALSE;
    Lex_Exception           EXCEPTION;
    Lv_Consulta             VARCHAR2(4000);
    Lv_CadenaQuery          VARCHAR2(2000);
    Lv_CadenaFrom           VARCHAR2(1000);
    Lv_CadenaWhere          VARCHAR2(4000);
    Lv_MsjResultado         VARCHAR2(4000); 
    Lv_UsuarioCreacion      VARCHAR2(15):= 'telcos_promo_bw';
    Lv_ProcesoExterno       VARCHAR2(50):= 'PierdePromo';
    Lv_EstadoPendiente      VARCHAR2(50):= 'Pendiente';
    Lv_IpCreacion           VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    Lrf_MapeoPierdePromoExt SYS_REFCURSOR;
    La_RegPromoExtProcesar  DB_COMERCIAL.CMKG_PROMOCIONES_BW.T_RegPromoExterno;
    La_PromocionExterna     DB_EXTERNO.Gtl_Promociones;
    --
  BEGIN
  --    
    Lv_CadenaQuery:='SELECT IPP.* ';

    Lv_CadenaFrom:=' FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP ';

    Lv_CadenaWhere:=' WHERE 
          IPP.EMPRESA_COD      = '''||Pv_CodEmpresa||'''
      AND IPP.TIPO_PROMO       = '''||Pv_TipoPromocion||'''
      AND IPP.TIPO_PROCESO     = '''||Lv_ProcesoExterno||'''
      AND IPP.SERVICIO_ID      = '||Pn_IdServicio||' 
      AND IPP.ESTADO           = '''||Lv_EstadoPendiente||''' ';

    IF Pv_TipoProceso = 'INDIVIDUAL' THEN
      --
      Lv_CadenaWhere:= Lv_CadenaWhere || ' 
                       AND TO_CHAR(IPP.FE_CREACION,''RRRR/MM/DD'') = TO_CHAR(SYSDATE,''RRRR/MM/DD'') ';
      --                
    END IF;

    Lv_Consulta:= Lv_CadenaQuery ||Lv_CadenaFrom || Lv_CadenaWhere;

    IF Lrf_MapeoPierdePromoExt%ISOPEN THEN
      CLOSE Lrf_MapeoPierdePromoExt;
    END IF;
    --    
    La_RegPromoExtProcesar.DELETE();
    OPEN Lrf_MapeoPierdePromoExt FOR Lv_Consulta; 
    LOOP
      FETCH Lrf_MapeoPierdePromoExt BULK COLLECT INTO La_RegPromoExtProcesar LIMIT 100;       
      Ln_Indx:= La_RegPromoExtProcesar.FIRST;
      WHILE (Ln_Indx IS NOT NULL)       
      LOOP  
        --
        IF Pv_TipoProceso = 'INDIVIDUAL' OR Pv_TipoProceso = 'MASIVO_BAJA' THEN
        --          
          La_PromocionExterna := DB_EXTERNO.Gtl_Promociones();
          La_PromocionExterna.EXTEND(1);      
          La_PromocionExterna(1) := DB_EXTERNO.Gr_Promocion(La_RegPromoExtProcesar(Ln_Indx).ID_PROCESO_PROMO,
                                                            NULL,
                                                            'Baja',
                                                            'La promoción fué dada de baja, ID_PROCESO_PROMO: '
                                                             ||La_RegPromoExtProcesar(Ln_Indx).ID_PROCESO_PROMO,
                                                            'BAJA',
                                                            NULL);

          DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_UPDATE_PROMOCIONES(La_PromocionExterna,
                                                               Lv_UsuarioCreacion,
                                                               Lv_IpCreacion,
                                                               Lv_MsjResultado);
          IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
            RAISE Lex_Exception;
          END IF;
        --
        END IF;  
        --
        Ln_Indx   := La_RegPromoExtProcesar.NEXT(Ln_Indx); 
        Ln_ContReg:= Ln_ContReg + 1;
        --
      END LOOP;
      --
      EXIT WHEN Lrf_MapeoPierdePromoExt%NOTFOUND; 
      --
    END LOOP;
    CLOSE Lrf_MapeoPierdePromoExt;   

    --
    IF Ln_ContReg > 0 THEN
      Lb_TieneRegPierdePromo :=TRUE;
    END IF;
    --
    Pb_ExistePierdePromo   := Lb_TieneRegPierdePromo;
    --
  EXCEPTION
  WHEN Lex_Exception THEN
    --
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_VALIDA_PIERDE_PROMO_EXT', 
                                         Lv_MsjResultado,
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion); 
    --
    Pb_ExistePierdePromo:= FALSE;
    --
  WHEN OTHERS THEN
    --
    Lv_MsjResultado := 'Ocurrió un error al verificar si existe un registro de Pierde Promo para RDA, del tipo promocional: PROM_BW' ; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_VALIDA_PIERDE_PROMO_EXT', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);       
    --
    Pb_ExistePierdePromo:= FALSE;
    --
  END P_VALIDA_PIERDE_PROMO_EXT;
  --
  --
  --
  PROCEDURE P_VALIDA_PROMO_FINALIZADA(Pn_IdServicio         IN DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                      Pv_TipoPromocion      IN DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                      Pv_CodEmpresa         IN DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                      Pv_TienePromoFin     OUT VARCHAR2)
  IS    
    --
    --Costo del Query C_ObtienePromoFinalizada: 8
    CURSOR C_ObtienePromoFinalizada(Cn_IdServicio         DB_COMERCIAL.INFO_SERVICIO.ID_SERVICIO%TYPE,
                                    Cv_TipoPromocion      DB_COMERCIAL.ADMI_TIPO_PROMOCION.CODIGO_TIPO_PROMOCION%TYPE,
                                    Cv_CodEmpresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
                                    Cv_EstadoMapeo        DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ESTADO%TYPE)
    IS  
      SELECT IDMS.ID_MAPEO_SOLICITUD
      FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS,
           DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP
      WHERE IDMP.ID_DETALLE_MAPEO                  = IDMS.DETALLE_MAPEO_ID
      AND IDMS.ESTADO                              = Cv_EstadoMapeo
      AND IDMP.ESTADO                              = Cv_EstadoMapeo
      AND IDMP.EMPRESA_COD                         = Cv_CodEmpresa
      AND IDMS.SERVICIO_ID                         = NVL(Cn_IdServicio,IDMS.SERVICIO_ID)
      AND IDMP.TIPO_PROMOCION                      IN (SELECT DET.VALOR2 
                                                       FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB,
                                                         DB_GENERAL.ADMI_PARAMETRO_DET DET
                                                       WHERE CAB.NOMBRE_PARAMETRO = 'PROM_TIPO_PROMOCIONES'
                                                       AND CAB.ESTADO             = 'Activo'
                                                       AND DET.PARAMETRO_ID       = CAB.ID_PARAMETRO
                                                       AND DET.VALOR3             = Cv_TipoPromocion
                                                       AND DET.ESTADO             = 'Activo') 
      AND TO_CHAR(IDMP.FE_MAPEO,'MM/YYYY') = TO_CHAR(SYSDATE,'MM/YYYY')
      AND ROWNUM                           = 1;
    --
    Lc_TienePromoFin        C_ObtienePromoFinalizada%ROWTYPE;
    Lv_MsjResultado         VARCHAR2(4000);   
    Lv_TienePromoFin        VARCHAR2(2);
    Lv_EstadoFinalizado     VARCHAR2(15):= 'Finalizado';
    Lv_UsuarioCreacion      VARCHAR2(15):= 'telcos_promo_bw';
    Lv_IpCreacion           VARCHAR2(16):= (NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), '127.0.0.1'));
    --
  BEGIN
  --
    Lv_TienePromoFin:='NO';
    --
    IF C_ObtienePromoFinalizada%ISOPEN THEN
      CLOSE C_ObtienePromoFinalizada;
    END IF;
    --
    OPEN C_ObtienePromoFinalizada(Pn_IdServicio,
                                 Pv_TipoPromocion,      
                                 Pv_CodEmpresa,
                                 Lv_EstadoFinalizado);
    FETCH C_ObtienePromoFinalizada INTO Lc_TienePromoFin;
    --
    IF C_ObtienePromoFinalizada%FOUND THEN
      Lv_TienePromoFin:='SI';
    END IF;

    CLOSE C_ObtienePromoFinalizada;
    --
    Pv_TienePromoFin:= Lv_TienePromoFin;
    --
  EXCEPTION
  WHEN OTHERS THEN
    --   
    IF C_ObtienePromoFinalizada%ISOPEN THEN
      CLOSE C_ObtienePromoFinalizada;
    END IF;
    --
    Lv_MsjResultado := 'Ocurrió un error al verificar si existe una promoción finalizada del servicio: '|| Pn_IdServicio 
                       || 'del tipo promocional: PROM_BW' ; 
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 
                                         'CMKG_PROMOCIONES_BW.P_VALIDA_PIERDE_PROMO_EXT', 
                                         SUBSTR(Lv_MsjResultado || ' - ' || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000), 
                                         Lv_UsuarioCreacion,
                                         SYSDATE,
                                         Lv_IpCreacion);       
    --
    Pv_TienePromoFin:='NO';
    --
  END P_VALIDA_PROMO_FINALIZADA;

----
----
----PARTE 2 BODY (PROCESO MASIVO DE APLICA ANCHO DE BANDA)
----
----

  PROCEDURE P_PROCESO_MASIVO_BW(Pv_TipoProceso IN  VARCHAR2,
                                Pn_IdPromocion IN  NUMBER DEFAULT NULL,
                                Pv_EstadoPromo IN  VARCHAR2 DEFAULT 'Activo',
                                Pv_Mensaje     OUT VARCHAR2) IS

    --
    Lv_NombreParametro       VARCHAR2(60) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
    Lv_TipoParametroRegistro VARCHAR2(40) := 'MAXIMO_REGISTROS_CLIENTES';
    Lv_CaractLineProfile     VARCHAR2(40) := 'LINE-PROFILE-NAME';
    Lv_CaractJurisdiccion    VARCHAR2(40) := 'PROM_JURISDICCION';
    Lv_CaractCanton          VARCHAR2(40) := 'PROM_CANTON';
    Lv_CaractParroquia       VARCHAR2(40) := 'PROM_PARROQUIA';
    Lv_CaractSector          VARCHAR2(40) := 'PROM_SECTOR';
    Lv_CaractElemento        VARCHAR2(40) := 'PROM_ELEMENTO';
    Lv_CaractEdificio        VARCHAR2(40) := 'PROM_EDIFICIO';
    Lv_Estado                VARCHAR2(20) := 'Activo';
    Lv_EstadoInactivo        VARCHAR2(20) := 'Inactivo';
    Lv_EstadoEliminado       VARCHAR2(20) := 'Eliminado';
    Lv_EstadoClonado         VARCHAR2(20) := 'Clonado';
    Lv_CodigoProducto        VARCHAR2(5)  := 'INTD';
    Ln_RegistroMaximo        NUMBER;
    Ln_MaximoBullCollect     NUMBER;
    --
    --Cursor para obtener todas las promociones vigentes.
    CURSOR C_Promociones(Cv_TipoPromocion VARCHAR2,
                         Cv_Estado        VARCHAR2,
                         Cn_idPlan        NUMBER,
                         Cv_TipoProceso   VARCHAR2,
                         Cv_FechaActual   VARCHAR2) IS

      SELECT ADGP.NOMBRE_GRUPO,
             ADGP.ID_GRUPO_PROMOCION,
             ATP.ID_TIPO_PROMOCION,
             ATP.CODIGO_TIPO_PROMOCION,
             ATPP.PLAN_ID,
             ATPP.PLAN_ID_SUPERIOR
          FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION          ADGP,
               DB_COMERCIAL.ADMI_TIPO_PROMOCION           ATP,
               DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION ATPP
      WHERE ADGP.ID_GRUPO_PROMOCION   = ATP.GRUPO_PROMOCION_ID
        AND ATP.ID_TIPO_PROMOCION     = ATPP.TIPO_PROMOCION_ID
        AND EXISTS (
            SELECT 1 FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR
            WHERE ATPR.TIPO_PROMOCION_ID = ATP.ID_TIPO_PROMOCION
            AND ATPR.ESTADO              = Cv_Estado
            AND REGEXP_LIKE(UPPER(ATPR.VALOR),UPPER(Cv_TipoProceso))
        )
        AND ( Pn_IdPromocion IS NULL OR Pn_IdPromocion = ADGP.ID_GRUPO_PROMOCION )
        AND (
          ( Pn_IdPromocion IS NULL AND ATPP.PLAN_ID = Cn_idPlan )
          OR
          ( Pn_IdPromocion IS NOT NULL 
            AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_COMPARAR_PLAN_PROMO_BW(Cn_idPlan,ATPP.PLAN_ID) = 'SI'
          )
        )
        AND ATP.CODIGO_TIPO_PROMOCION = Cv_TipoPromocion
        AND ADGP.ESTADO               = Pv_EstadoPromo
        AND ATP.ESTADO                = Cv_Estado
        AND ATPP.ESTADO               = Cv_Estado
        AND Cv_FechaActual <= TO_CHAR(ADGP.FE_FIN_VIGENCIA   ,'RRRR-MM-DD')
      ORDER BY ADGP.FE_INICIO_VIGENCIA ASC,
               ADGP.FE_FIN_VIGENCIA ASC;
    --
    CURSOR C_ObtenerRegistrosMaximo IS
        SELECT VALOR1, VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET
        WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
            WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
        AND DESCRIPCION = Lv_TipoParametroRegistro AND ROWNUM = 1;

    --Cursor para devolver la lista de periodos.
    CURSOR C_ListaPeriodos (Cv_Periodos VARCHAR2) IS
      SELECT REGEXP_SUBSTR(Cv_Periodos,'[^,]+',1, LEVEL) SPLIT
          FROM DUAL
      CONNECT BY REGEXP_SUBSTR(Cv_Periodos,'[^,]+',1, LEVEL) IS NOT NULL;

    Lv_Rol                   VARCHAR2(20) := 'CLIENTE';
    Lv_Producto              VARCHAR2(20) := 'INTERNET';
    Lv_TipoPromocion         VARCHAR2(20) := 'PROM_BW';
    Lv_CodEmpresa            VARCHAR2(5)  := '18';
    Lv_TipoEvaluacion        VARCHAR2(8)  := 'NUEVO';
    Lv_ParametroCabBw        VARCHAR2(60) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
    Lv_ParametroMarcas       VARCHAR2(60) := 'MARCAS_PERMITIDAS';

    Lv_FechaActual           VARCHAR2(13) :=  TO_CHAR(SYSDATE,'RRRR-MM-DD'); --SYSDATE - 1
    Lv_IpCreacion            VARCHAR2(20) :=  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1');
    Lv_UsuarioCreacion       VARCHAR2(15) := 'telcos_promo_bw';

    La_SectoresProcesar      DB_COMERCIAL.CMKG_PROMOCIONES.T_SectorizacionProcesar;
    Lr_TipoPromoRegla        DB_COMERCIAL.CMKG_PROMOCIONES.Lr_TipoPromoReglaProcesar;
    Lr_GrupoPromoRegla       DB_COMERCIAL.CMKG_PROMOCIONES.Lr_GrupoPromoReglaProcesar;
    Lt_Servicios             DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosProcesar;  --Lr_ServiciosProcesar
    Lt_ServiciosMapear       DB_COMERCIAL.CMKG_PROMOCIONES.T_ServiciosMapear;    --Lr_ServiciosProcesar
    Lr_InfoDetMapeoPromo     DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO%ROWTYPE;
    Lr_InfoServHist          DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
    Lv_Trama                 VARCHAR2(4000);
    Lv_MsjResultado          VARCHAR2(4000);
    Lv_FechaMapeoTotal       VARCHAR2(5000);
    Lv_Periodo               VARCHAR2(20);
    Lv_Descuento             VARCHAR2(20);
    Le_MyException           EXCEPTION;
    Lb_ReglaSector           BOOLEAN;
    Lb_ReglaFormaPago        BOOLEAN;
    Lb_ReglaAntiguedad       BOOLEAN;
    Lb_ReglaUltimaMilla      BOOLEAN;
    Lb_ReglaTipoNegocio      BOOLEAN;
    Lb_CumplePromocion       BOOLEAN;
    Ld_FechaMapeo            DATE;
    Ln_Indx                  NUMBER;
    Lcl_QueryCLientes        CLOB;
    Lv_QuerySelect           VARCHAR2(1000);
    Lv_QueryFrom             VARCHAR2(2000);
    Lv_QueryWhere            VARCHAR2(3800);
    Lv_QueryWherePlan        VARCHAR2(3800);
    Lv_QueryHistorial        VARCHAR2(2000);
    Lv_QueryAnd              VARCHAR2(5000);
    Lrf_ClientesPromo        SYS_REFCURSOR;
    Lr_ClientesPromo         Gr_ClientesPromo;
    Ltl_ClientesPromo        Gtl_ClientesPromo;
    Lr_ProcesoPromo          Gr_ProcesoPromo;
    TYPE Ltl_Promo IS TABLE OF C_Promociones%ROWTYPE INDEX BY PLS_INTEGER;
    Ltl_Promociones          Ltl_Promo;
    Lc_Promociones           C_Promociones%ROWTYPE;
    Ln_IndxPromociones       NUMBER;
    Lr_ParametrosCreaCaract  Gr_ParametrosCreaCaract;
    Lv_MensajeHistorial      DB_COMERCIAL.INFO_SERVICIO_HISTORIAL.OBSERVACION%TYPE;
    Lr_ParametrosValidarSec  DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.Tr_ParametrosValidarSec;

  BEGIN

    IF C_Promociones%ISOPEN THEN
      CLOSE C_Promociones;
    END IF;

    IF C_ListaPeriodos%ISOPEN THEN
      CLOSE C_ListaPeriodos;
    END IF;

    IF Lrf_ClientesPromo%ISOPEN THEN
      CLOSE Lrf_ClientesPromo;
    END IF;

    IF C_ObtenerRegistrosMaximo%ISOPEN THEN
      CLOSE C_ObtenerRegistrosMaximo;
    END IF;

    --Query encargado de obtener los posibles clientes que aplican a una promoción vigente.
    Lv_QuerySelect :=
        'SELECT IPEROL.ID_PERSONA_ROL, '||
               'IPUNTO.ID_PUNTO, '      ||
               'ISERVICIO.ID_SERVICIO, '||
               'ISERVICIO.PLAN_ID, '    ||
               'ISERVICIO.ESTADO ';

    Lv_QueryFrom := 'FROM DB_COMERCIAL.INFO_SERVICIO ISERVICIO ' ||
                    'INNER JOIN DB_COMERCIAL.INFO_PUNTO IPUNTO ON IPUNTO.ID_PUNTO = ISERVICIO.PUNTO_ID ' ||
                    'INNER JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPEROL ON IPEROL.ID_PERSONA_ROL = IPUNTO.PERSONA_EMPRESA_ROL_ID ';

    Lv_QueryWhere  := 'WHERE ISERVICIO.ESTADO = '''||Lv_Estado||''' ' ||
                      'AND EXISTS ( ' ||
                          'SELECT 1 FROM DB_COMERCIAL.INFO_EMPRESA_ROL IEROL ' ||
                          'INNER JOIN DB_GENERAL.ADMI_ROL ADROL ON ADROL.ID_ROL = IEROL.ROL_ID ' ||
                          'WHERE IEROL.ID_EMPRESA_ROL       = IPEROL.EMPRESA_ROL_ID ' ||
                          'AND UPPER(ADROL.DESCRIPCION_ROL) = '''||Lv_Rol||''' ' ||
                          'AND IEROL.EMPRESA_COD            = '''||Lv_CodEmpresa||''' ' ||
                      ') ' ||
                      'AND EXISTS ( ' ||
                          'SELECT 1 FROM DB_COMERCIAL.INFO_PLAN_DET IPLANDET ' ||
                          'INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO ADPRODUCTO ON ADPRODUCTO.ID_PRODUCTO = IPLANDET.PRODUCTO_ID ' ||
                          'WHERE IPLANDET.PLAN_ID               = ISERVICIO.PLAN_ID ' ||
                          'AND UPPER(ADPRODUCTO.NOMBRE_TECNICO) = '''||Lv_Producto||''' ' ||
                          'AND ADPRODUCTO.EMPRESA_COD           = '''||Lv_CodEmpresa||''' ' ||
                      ') ';

    Lv_QueryWherePlan :=
          ' AND EXISTS ( '||
            'SELECT ATPP.PLAN_ID '||
                'FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION          ADGP, '||
                     'DB_COMERCIAL.ADMI_TIPO_PROMOCION           ATP, ' ||
                     'DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION ATPP, '||
                     'DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA     ATPR ' ||
            'WHERE ADGP.ID_GRUPO_PROMOCION        = ATP.GRUPO_PROMOCION_ID '    ||
              'AND ATP.ID_TIPO_PROMOCION          = ATPP.TIPO_PROMOCION_ID '    ||
              'AND ATP.ID_TIPO_PROMOCION          = ATPR.TIPO_PROMOCION_ID '    ||
              'AND ATPP.PLAN_ID                   = ISERVICIO.PLAN_ID '         ||
              'AND ATP.CODIGO_TIPO_PROMOCION      = '''||Lv_TipoPromocion||''' '||
              'AND ADGP.ESTADO                    = '''||Pv_EstadoPromo||''' '  ||
              'AND ATP.ESTADO                     = '''||Lv_Estado||''' '       ||
              'AND ATPP.ESTADO                    = '''||Lv_Estado||''' '       ||
              'AND ATPR.ESTADO                    = '''||Lv_Estado||''' '       ||
              'AND REGEXP_LIKE(UPPER(ATPR.VALOR),UPPER('''||Pv_TipoProceso||''')) '    ||
              'AND '''||Lv_FechaActual||''' <= TO_CHAR(ADGP.FE_FIN_VIGENCIA   ,''RRRR-MM-DD'') '||
          ') ';

    Lv_QueryHistorial := 'SELECT 1 '||
                          'FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISHISTORIAL '||
                          'WHERE ISHISTORIAL.ID_SERVICIO_HISTORIAL = ( '||
                            'SELECT MIN(ISHMIN.ID_SERVICIO_HISTORIAL) '||
                            'FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL ISHMIN '||
                            'WHERE ISHMIN.SERVICIO_ID = ISERVICIO.ID_SERVICIO '||
                            'AND ISHMIN.ESTADO        = '''||Lv_Estado||''' '||
                            'AND ROWNUM <= 1 '||
                          ') ';
    --Clientes Existentes, (Menor a la fecha de procesamiento).
    Lv_QueryAnd := 'AND EXISTS ( '||
                    Lv_QueryHistorial ||
                    'AND TO_CHAR(ISHISTORIAL.FE_CREACION,''RRRR-MM-DD'') < '''||Lv_FechaActual||''' '||
                   ') ';

    --Clientes Nuevos, (Igual a la fecha de procesamiento).
    IF UPPER(Pv_TipoProceso) = 'NUEVO' THEN
      Lv_QueryAnd := 'AND EXISTS ( '||
                      Lv_QueryHistorial ||
                      'AND TO_CHAR(ISHISTORIAL.FE_CREACION,''RRRR-MM-DD'') = '''||Lv_FechaActual||''' '||
                    ') ';
    END IF;

    --Clientes Nuevo Proceso, (Menor o igual a la fecha de procesamiento).
    IF Pn_IdPromocion IS NOT NULL THEN
      Lv_QueryWhere     := Lv_QueryWhere ||
                          'AND NOT EXISTS ( ' ||
                              'SELECT IDMS.SERVICIO_ID ' ||
                              'FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP, DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS ' ||
                              'WHERE IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID ' ||
                              'AND IDMS.SERVICIO_ID    = ISERVICIO.ID_SERVICIO ' ||
                              'AND IDMP.TIPO_PROMOCION != '''||Lv_TipoPromocion||''' ' ||
                              'AND IDMP.ESTADO         = '''||Lv_Estado||''' ' ||
                              'AND IDMS.ESTADO         = '''||Lv_Estado||''' ' ||
                          ') ' ||
                          'AND NOT EXISTS ( ' ||
                              'SELECT IDMS.SERVICIO_ID ' ||
                              'FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP, DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS ' ||
                              'WHERE IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID ' ||
                              'AND IDMS.SERVICIO_ID        = ISERVICIO.ID_SERVICIO ' ||
                              'AND IDMP.GRUPO_PROMOCION_ID = '''||Pn_IdPromocion||''' ' ||
                          ') ';
      Lv_QueryWherePlan :=
                      ' AND EXISTS ( ' ||
                          'SELECT 1 FROM ( ' ||
                            'SELECT PCA.ID_PLAN, CAR.VALOR AS LINE_PROFILE_NAME FROM DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT CAR ' ||
                            'INNER JOIN DB_COMERCIAL.INFO_PLAN_DET PDE ON PDE.ID_ITEM = CAR.PLAN_DET_ID ' ||
                            'INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PCA ON PCA.ID_PLAN = PDE.PLAN_ID ' ||
                            'INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA PC ON PC.ID_PRODUCTO_CARACTERISITICA = CAR.PRODUCTO_CARACTERISITICA_ID ' ||
                            'INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA C ON C.ID_CARACTERISTICA = PC.CARACTERISTICA_ID ' ||
                            'INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO ON PRO.ID_PRODUCTO = PDE.PRODUCTO_ID ' ||
                            'INNER JOIN DB_COMERCIAL.ADMI_PRODUCTO P ON P.ID_PRODUCTO = PC.PRODUCTO_ID ' ||
                            'WHERE C.DESCRIPCION_CARACTERISTICA ='''||Lv_CaractLineProfile||''' ' ||
                            'AND P.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||''' ' ||
                            'AND PRO.CODIGO_PRODUCTO = '''||Lv_CodigoProducto||''' ' ||
                            'AND PCA.ESTADO IN ('''||Lv_Estado||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''') ' ||
                            'AND PDE.ESTADO IN ('''||Lv_Estado||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''') ' ||
                            'AND CAR.ESTADO IN ('''||Lv_Estado||''','''||Lv_EstadoInactivo||''','''||Lv_EstadoClonado||''') ) PLAN_PER ' ||
                          'WHERE EXISTS ( ' ||
                            'SELECT 1 FROM ( ' ||
                              'SELECT PLAN.PLAN_ID, ' ||
                                  'DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(PLAN.PLAN_ID) AS LINE_PROFILE_NAME ' ||
                              'FROM DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION PLAN ' ||
                                'INNER JOIN DB_COMERCIAL.ADMI_TIPO_PROMOCION TIP ON TIP.ID_TIPO_PROMOCION = PLAN.TIPO_PROMOCION_ID ' ||
                              'WHERE TIP.GRUPO_PROMOCION_ID = '''||Pn_IdPromocion||''' ' ||
                              'AND TIP.ESTADO = '''||Lv_Estado||''' ' ||
                              'AND PLAN.ESTADO = '''||Lv_Estado||''' ' ||
                            ') PLAN_PROMO ' ||
                            'WHERE PLAN_PROMO.LINE_PROFILE_NAME = PLAN_PER.LINE_PROFILE_NAME ' ||
                          ') ' ||
                          'AND PLAN_PER.ID_PLAN = ISERVICIO.PLAN_ID ' ||
                      ') ' ||
                      'AND EXISTS ( ' ||
                          'SELECT 1 FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO STEC ' ||
                          'INNER JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO SELE ON SELE.ID_ELEMENTO = STEC.ELEMENTO_ID ' ||
                          'INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO SMOD ON SMOD.ID_MODELO_ELEMENTO = SELE.MODELO_ELEMENTO_ID ' ||
                          'INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO SMAR ON SMAR.ID_MARCA_ELEMENTO = SMOD.MARCA_ELEMENTO_ID ' ||
                          'WHERE STEC.SERVICIO_ID = ISERVICIO.ID_SERVICIO ' ||
                          'AND EXISTS ( ' ||
                              'SELECT 1 FROM DB_GENERAL.ADMI_PARAMETRO_DET SDET ' ||
                              'INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB SCAB ON SCAB.ID_PARAMETRO = SDET.PARAMETRO_ID ' ||
                              'WHERE SCAB.NOMBRE_PARAMETRO = '''||Lv_ParametroCabBw||''' ' ||
                              'AND SDET.DESCRIPCION        = '''||Lv_ParametroMarcas||''' ' ||
                              'AND SDET.VALOR1             = SMAR.NOMBRE_MARCA_ELEMENTO ' ||
                              'AND SDET.ESTADO             = '''||Lv_Estado||''' ' ||
                              'AND SCAB.ESTADO             = '''||Lv_Estado||''' ' ||
                          ') ' ||
                      ') ';
      Lv_QueryAnd :=  'AND ( ' ||
                        'NOT EXISTS ( ' ||
                          'SELECT 1 FROM ( ' ||
                            'SELECT SECTORIZACION.ID_SECTORIZACION, ' ||
                              'SECTORIZACION.ID_JURISDICCION, ' ||
                              'NVL(SECTORIZACION.ID_CANTON   ,''0'') AS ID_CANTON, ' ||
                              'NVL(SECTORIZACION.ID_PARROQUIA,''0'') AS ID_PARROQUIA, ' ||
                              'NVL(SECTORIZACION.ID_SECTOR   ,''0'') AS ID_SECTOR, ' ||
                              'NVL(SECTORIZACION.ID_ELEMENTO ,''0'') AS ID_ELEMENTO, ' ||
                              'NVL(SECTORIZACION.ID_EDIFICIO ,''0'') AS ID_EDIFICIO ' ||
                            'FROM (SELECT * ' ||
                              'FROM (SELECT AC.DESCRIPCION_CARACTERISTICA, ' ||
                                          'ATPR.VALOR, ' ||
                                          'ATPR.SECUENCIA AS ID_SECTORIZACION ' ||
                                    'FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION      ATP, ' ||
                                        'DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR, ' ||
                                        'DB_COMERCIAL.ADMI_CARACTERISTICA       AC ' ||
                                    'WHERE ATP.GRUPO_PROMOCION_ID = '''||Pn_IdPromocion||''' ' ||
                                      'AND ATP.ID_TIPO_PROMOCION  = ATPR.TIPO_PROMOCION_ID ' ||
                                      'AND AC.ID_CARACTERISTICA   = ATPR.CARACTERISTICA_ID ' ||
                                      'AND AC.DESCRIPCION_CARACTERISTICA IN ('''||Lv_CaractJurisdiccion||''', ' ||
                                              ''''||Lv_CaractCanton||''', ' ||
                                              ''''||Lv_CaractParroquia||''', ' ||
                                              ''''||Lv_CaractSector||''', ' ||
                                              ''''||Lv_CaractElemento||''', ' ||
                                              ''''||Lv_CaractEdificio||''') ' ||
                                    'AND ATPR.SECUENCIA IS NOT NULL ' ||
                                    'AND ATPR.ESTADO != '''||Lv_EstadoEliminado||''') ' ||
                              'PIVOT (MAX(VALOR) FOR DESCRIPCION_CARACTERISTICA ' ||
                                  'IN (''PROM_JURISDICCION'' AS ID_JURISDICCION, ' ||
                                      '''PROM_CANTON''       AS ID_CANTON, ' ||
                                      '''PROM_PARROQUIA''    AS ID_PARROQUIA, ' ||
                                      '''PROM_SECTOR''       AS ID_SECTOR, ' ||
                                      '''PROM_ELEMENTO''     AS ID_ELEMENTO, ' ||
                                      '''PROM_EDIFICIO''     AS ID_EDIFICIO ))) SECTORIZACION ' ||
                          ') SECTOR ' ||
                        ') ' ||
                        'OR EXISTS ( ' ||
                          'SELECT 1 ' ||
                          'FROM DB_GENERAL.ADMI_SECTOR ASE, DB_COMERCIAL.INFO_SERVICIO_TECNICO IST, ' ||
                          'DB_GENERAL.ADMI_PARROQUIA APA, DB_INFRAESTRUCTURA.INFO_ELEMENTO IE ' ||
                          'WHERE ASE.ID_SECTOR = IPUNTO.SECTOR_ID ' ||
                          'AND IST.SERVICIO_ID = ISERVICIO.ID_SERVICIO ' ||
                          'AND APA.ID_PARROQUIA = ASE.PARROQUIA_ID ' ||
                          'AND IE.ID_ELEMENTO = IST.ELEMENTO_ID ' ||
                          'AND EXISTS ( ' ||
                              'SELECT 1 FROM ( ' ||
                                'SELECT SECTORIZACION.ID_SECTORIZACION, ' ||
                                  'SECTORIZACION.ID_JURISDICCION, ' ||
                                  'NVL(SECTORIZACION.ID_CANTON   ,''0'') AS ID_CANTON, ' ||
                                  'NVL(SECTORIZACION.ID_PARROQUIA,''0'') AS ID_PARROQUIA, ' ||
                                  'NVL(SECTORIZACION.ID_SECTOR   ,''0'') AS ID_SECTOR, ' ||
                                  'NVL(SECTORIZACION.ID_ELEMENTO ,''0'') AS ID_ELEMENTO, ' ||
                                  'NVL(SECTORIZACION.ID_EDIFICIO ,''0'') AS ID_EDIFICIO ' ||
                                'FROM (SELECT * ' ||
                                  'FROM (SELECT AC.DESCRIPCION_CARACTERISTICA, ' ||
                                              'ATPR.VALOR, ' ||
                                              'ATPR.SECUENCIA AS ID_SECTORIZACION ' ||
                                        'FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION      ATP, ' ||
                                            'DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR, ' ||
                                            'DB_COMERCIAL.ADMI_CARACTERISTICA       AC ' ||
                                        'WHERE ATP.GRUPO_PROMOCION_ID = '''||Pn_IdPromocion||''' ' ||
                                          'AND ATP.ID_TIPO_PROMOCION  = ATPR.TIPO_PROMOCION_ID ' ||
                                          'AND AC.ID_CARACTERISTICA   = ATPR.CARACTERISTICA_ID ' ||
                                          'AND AC.DESCRIPCION_CARACTERISTICA IN ('''||Lv_CaractJurisdiccion||''', ' ||
                                                  ''''||Lv_CaractCanton||''', ' ||
                                                  ''''||Lv_CaractParroquia||''', ' ||
                                                  ''''||Lv_CaractSector||''', ' ||
                                                  ''''||Lv_CaractElemento||''', ' ||
                                                  ''''||Lv_CaractEdificio||''') ' ||
                                        'AND ATPR.SECUENCIA IS NOT NULL ' ||
                                        'AND ATPR.ESTADO != '''||Lv_EstadoEliminado||''') ' ||
                                  'PIVOT (MAX(VALOR) FOR DESCRIPCION_CARACTERISTICA ' ||
                                      'IN (''PROM_JURISDICCION'' AS ID_JURISDICCION, ' ||
                                          '''PROM_CANTON''       AS ID_CANTON, ' ||
                                          '''PROM_PARROQUIA''    AS ID_PARROQUIA, ' ||
                                          '''PROM_SECTOR''       AS ID_SECTOR, ' ||
                                          '''PROM_ELEMENTO''     AS ID_ELEMENTO, ' ||
                                          '''PROM_EDIFICIO''     AS ID_EDIFICIO ))) SECTORIZACION ' ||
                              ') SECTOR ' ||
                              'WHERE SECTOR.ID_JURISDICCION = IPUNTO.PUNTO_COBERTURA_ID ' ||
                              'AND ( SECTOR.ID_CANTON = 0    OR SECTOR.ID_CANTON  = APA.CANTON_ID ) ' ||
                              'AND ( SECTOR.ID_PARROQUIA = 0 OR SECTOR.ID_PARROQUIA = APA.ID_PARROQUIA ) ' ||
                              'AND ( SECTOR.ID_SECTOR = 0    OR SECTOR.ID_SECTOR = ASE.ID_SECTOR ) ' ||
                              'AND ( SECTOR.ID_ELEMENTO = 0  OR SECTOR.ID_ELEMENTO = IE.ID_ELEMENTO ) ' ||
                              'AND ( SECTOR.ID_EDIFICIO = 0  OR SECTOR.ID_EDIFICIO = NVL((SELECT DISTINCT IPDA.ELEMENTO_ID ' ||
                                      'FROM DB_COMERCIAL.INFO_PUNTO_DATO_ADICIONAL IPDA, ' ||
                                        'DB_COMERCIAL.INFO_SERVICIO                DBIS, ' ||
                                        'DB_INFRAESTRUCTURA.INFO_ELEMENTO          DBIE, ' ||
                                        'DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   DBAME, ' ||
                                        'DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO     DBATE ' ||
                                      'WHERE DBIS.ID_SERVICIO           =  ISERVICIO.ID_SERVICIO ' ||
                                        'AND IPDA.PUNTO_ID              =  DBIS.PUNTO_ID ' ||
                                        'AND IPDA.DEPENDE_DE_EDIFICIO   = ''S'' ' ||
                                        'AND DBIE.ID_ELEMENTO           = IPDA.ELEMENTO_ID ' ||
                                        'AND DBAME.ID_MODELO_ELEMENTO   = DBIE.MODELO_ELEMENTO_ID ' ||
                                        'AND DBATE.ID_TIPO_ELEMENTO     = DBAME.TIPO_ELEMENTO_ID ' ||
                                        'AND DBATE.NOMBRE_TIPO_ELEMENTO = ''EDIFICACION''),0) ) ' ||
                          ') ' ||
                        ') ' ||
                      ') ';
    ELSE
      Lv_QueryWhere     := Lv_QueryWhere ||
                          'AND NOT EXISTS ( ' ||
                              'SELECT IDMS.SERVICIO_ID ' ||
                              'FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP, DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDMS ' ||
                              'WHERE IDMP.ID_DETALLE_MAPEO = IDMS.DETALLE_MAPEO_ID ' ||
                              'AND IDMS.SERVICIO_ID    = ISERVICIO.ID_SERVICIO ' ||
                              'AND IDMP.TIPO_PROMOCION = '''||Lv_TipoPromocion||''' ' ||
                              'AND IDMP.ESTADO         = '''||Lv_Estado||''' ' ||
                              'AND IDMS.ESTADO         = '''||Lv_Estado||''' ' ||
                          ') ';
    END IF;

    --
    --obtengo registro maximo
    OPEN C_ObtenerRegistrosMaximo;
    FETCH C_ObtenerRegistrosMaximo INTO Ln_MaximoBullCollect, Ln_RegistroMaximo;
    CLOSE C_ObtenerRegistrosMaximo;
    --
    --
    IF Ln_MaximoBullCollect IS NULL THEN
      Ln_MaximoBullCollect := 1000;
    END IF;
    --
    --
    Lcl_QueryCLientes := Lv_QuerySelect||Lv_QueryFrom||Lv_QueryWhere||Lv_QueryWherePlan||Lv_QueryAnd;
    IF Pn_IdPromocion IS NOT NULL THEN
      --
      IF Ln_RegistroMaximo IS NULL THEN
        Ln_RegistroMaximo := 30000;
      END IF;
      --
      Lcl_QueryCLientes := Lcl_QueryCLientes || ' AND ROWNUM <= ' || Ln_RegistroMaximo;
    END IF;

    --Loop para obtener los posibles clientes que aplican a una promoción.
    OPEN Lrf_ClientesPromo FOR Lcl_QueryCLientes;

      LOOP

        FETCH Lrf_ClientesPromo BULK COLLECT INTO Ltl_ClientesPromo LIMIT Ln_MaximoBullCollect;

        EXIT WHEN Ltl_ClientesPromo.COUNT() < 1;

        Ln_Indx := Ltl_ClientesPromo.FIRST;

        WHILE (Ln_Indx IS NOT NULL) LOOP

          Lr_ClientesPromo := Ltl_ClientesPromo(Ln_Indx);
          Ln_Indx          := Ltl_ClientesPromo.NEXT(Ln_Indx);

          --se encontraron registros
          Pv_Mensaje := 'OK';

          --Variable que identifica cuando un servicio aplicó a una promoción.
          Lb_CumplePromocion := FALSE;

          --Loop para obtener todas las promociones vigentes de acuerdo al plan del servicio del cliente.
          OPEN C_Promociones (Lv_TipoPromocion,Lv_Estado,Lr_ClientesPromo.PLAN_ID,Pv_TipoProceso,Lv_FechaActual);

            LOOP

              FETCH C_Promociones BULK COLLECT INTO Ltl_Promociones LIMIT 500;

              EXIT WHEN Ltl_Promociones.COUNT() < 1 OR Lb_CumplePromocion;

              Ln_IndxPromociones := Ltl_Promociones.FIRST;

              WHILE (Ln_IndxPromociones IS NOT NULL AND NOT Lb_CumplePromocion) LOOP

                BEGIN

                  Lc_Promociones     := Ltl_Promociones(Ln_IndxPromociones);
                  Ln_IndxPromociones := Ltl_Promociones.NEXT(Ln_IndxPromociones);

                  IF Pn_IdPromocion IS NULL THEN
                    --Record para validar la sectorización del punto cliente.
                    Lr_ParametrosValidarSec                    := NULL;
                    Lr_ParametrosValidarSec.ID_GRUPO_PROMOCION := Lc_Promociones.ID_GRUPO_PROMOCION;
                    Lr_ParametrosValidarSec.ID_SERVICIO        := Lr_ClientesPromo.ID_SERVICIO;
                    Lr_ParametrosValidarSec.TIPO_EVALUACION    := Lv_TipoEvaluacion;
                    Lr_ParametrosValidarSec.TIPO_PROMOCION     := Lv_TipoPromocion;--ANCHO DE BANDA
                    Lr_ParametrosValidarSec.EMPRESA_COD        := Lv_CodEmpresa;
                    --Validación para identificar si el servicio cumple con la regla de sectorización.
                    Lb_ReglaSector := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_SECTORIZACION(Lr_ParametrosValidarSec);

                    CONTINUE WHEN NOT Lb_ReglaSector OR Lb_ReglaSector IS NULL;

                    --Validación para identificar si el servicio cumple con la regla de forma de pago.
                    Lb_ReglaFormaPago  := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_FORMA_PAGO(Lc_Promociones.ID_GRUPO_PROMOCION,
                                                                                                 Lr_ClientesPromo.ID_PUNTO);

                    CONTINUE WHEN NOT Lb_ReglaFormaPago OR Lb_ReglaFormaPago IS NULL;

                    --Validación para identificar si el servicio cumple con la regla de ultima milla.
                    Lb_ReglaUltimaMilla := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ULTIMA_MILLA(Lc_Promociones.ID_GRUPO_PROMOCION,
                                                                                                    Lr_ClientesPromo.ID_SERVICIO);

                    CONTINUE WHEN NOT Lb_ReglaUltimaMilla OR Lb_ReglaUltimaMilla IS NULL;

                    --Validación para identificar si el servicio cumple con la regla de tipo de negocio.
                    Lb_ReglaTipoNegocio := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_TIPO_NEGOCIO(Fn_IntIdPromocion => Lc_Promociones.ID_GRUPO_PROMOCION,
                                                                                                    Fn_IdServicio     => Lr_ClientesPromo.ID_SERVICIO,
                                                                                                    Fv_CodEmpresa     => Lv_CodEmpresa);

                    CONTINUE WHEN NOT Lb_ReglaTipoNegocio OR Lb_ReglaTipoNegocio IS NULL;

                    --Validación para identificar si el servicio cumple con la regla de antiguedad.
                    Lb_ReglaAntiguedad  := DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_VALIDA_ANTIGUEDAD(Lc_Promociones.ID_GRUPO_PROMOCION,
                                                                                                  Lr_ClientesPromo.ID_PUNTO);

                    CONTINUE WHEN NOT Lb_ReglaAntiguedad OR Lb_ReglaAntiguedad IS NULL;

                    --
                    -- A este punto el servicio cumple con todas las reglas promocionales
                    --
                    La_SectoresProcesar.DELETE();
                    La_SectoresProcesar := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_SECTORIZACION(Lc_Promociones.ID_GRUPO_PROMOCION);

                    Lr_GrupoPromoRegla := NULL;
                    Lr_GrupoPromoRegla.ID_GRUPO_PROMOCION := Lc_Promociones.ID_GRUPO_PROMOCION;

                  END IF;

                  Lr_TipoPromoRegla := NULL;
                  Lr_TipoPromoRegla := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_PROMO_TIPO_REGLA(Lc_Promociones.ID_TIPO_PROMOCION);

                  Lt_Servicios.DELETE();
                  Lt_ServiciosMapear.DELETE();
                  Lt_Servicios(1).ID_PUNTO         := Lr_ClientesPromo.ID_PUNTO;
                  Lt_Servicios(1).ID_SERVICIO      := Lr_ClientesPromo.ID_SERVICIO;
                  Lt_Servicios(1).ESTADO           := Lr_ClientesPromo.ESTADO;
                  IF Pn_IdPromocion IS NOT NULL THEN
                    Lt_Servicios(1).ID_PLAN        := Lr_ClientesPromo.PLAN_ID;
                  ELSE
                    Lt_Servicios(1).ID_PLAN        := Lc_Promociones.PLAN_ID;
                  END IF;
                  Lt_Servicios(1).PLAN_ID_SUPERIOR := Lc_Promociones.PLAN_ID_SUPERIOR;

                  Lv_Trama := '{}';
                  IF Pn_IdPromocion IS NULL THEN
                    --Llamada a la función que construye la trama de la información del
                    --cliente, en base a las reglas promocionales evaluadas.
                    Lv_Trama := DB_COMERCIAL.CMKG_PROMOCIONES.F_GET_TRAMA(Fn_IdPunto               => Lr_ClientesPromo.ID_PUNTO,
                                                                          Fr_GrupoPromoRegla       => Lr_GrupoPromoRegla,
                                                                          Fr_TipoPromoRegla        => Lr_TipoPromoRegla,
                                                                          Fa_ServiciosCumplePromo  => Lt_Servicios,
                                                                          Fa_SectorizacionProcesar => La_SectoresProcesar,
                                                                          Pv_CodEmpresa            => Lv_CodEmpresa);

                    --Llamada al método encargado de eliminar y crear las características promocionales.
                    Lr_ParametrosCreaCaract               := NULL;
                    Lr_ParametrosCreaCaract.ID_PLAN_PROMO := Lc_Promociones.PLAN_ID_SUPERIOR;
                    Lr_ParametrosCreaCaract.ID_SERVICIO   := Lr_ClientesPromo.ID_SERVICIO;
                    Lr_ParametrosCreaCaract.COD_EMPRESA   := Lv_CodEmpresa;
                    Lr_ParametrosCreaCaract.USUARIO       := Lv_UsuarioCreacion;

                    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_CARACTERISTICAS_PROMO(Lr_ParametrosCreaCaract,Lv_MsjResultado);

                    IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                      Lv_MsjResultado:= 'Error al generar el mapeo Promocional'
                          ||' Servicio : '        ||Lr_ClientesPromo.ID_SERVICIO
                          ||' Grupo Promocional: '||Lc_Promociones.ID_GRUPO_PROMOCION
                          ||' Tipo Promocional : '||Lc_Promociones.ID_TIPO_PROMOCION
                          ||' Plan Promocional : '||Lc_Promociones.PLAN_ID_SUPERIOR
                          ||' Mensaje: '          ||Lv_MsjResultado;
                      RAISE Le_MyException;
                    END IF;
                  END IF;

                  Lr_InfoDetMapeoPromo                        := NULL;
                  Lr_InfoDetMapeoPromo.GRUPO_PROMOCION_ID     := Lc_Promociones.ID_GRUPO_PROMOCION;
                  Lr_InfoDetMapeoPromo.TRAMA                  := Lv_Trama;
                  Lr_InfoDetMapeoPromo.PERSONA_EMPRESA_ROL_ID := Lr_ClientesPromo.ID_PERSONA_ROL;
                  Lr_InfoDetMapeoPromo.PUNTO_ID               := Lr_ClientesPromo.ID_PUNTO;
                  Lr_InfoDetMapeoPromo.TIPO_PROMOCION_ID      := Lc_Promociones.ID_TIPO_PROMOCION;
                  Lr_InfoDetMapeoPromo.TIPO_PROMOCION         := Lc_Promociones.CODIGO_TIPO_PROMOCION;
                  Lr_InfoDetMapeoPromo.EMPRESA_COD            := Lv_CodEmpresa;
                  Lr_InfoDetMapeoPromo.ESTADO                 := Lv_Estado;
                  Lr_InfoDetMapeoPromo.TIPO_PROCESO           := UPPER(Pv_TipoProceso);
                  Lr_InfoDetMapeoPromo.FE_CREACION            := SYSDATE;
                  Lr_InfoDetMapeoPromo.USR_CREACION           := Lv_UsuarioCreacion;
                  Lr_InfoDetMapeoPromo.IP_CREACION            := Lv_IpCreacion;

                  Lv_FechaMapeoTotal := NULL;
                  --Loop que recorre los períodos para realizar el mapeo de la promoción.
                  FOR DescuentoPeriodo IN C_ListaPeriodos(Lr_TipoPromoRegla.PROM_PERIODO) LOOP

                    Lv_Periodo         := TO_NUMBER(regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 1));
                    Lv_Descuento       := TO_NUMBER(regexp_substr(DescuentoPeriodo.SPLIT,'[^|]+', 1, 2));
                    Ld_FechaMapeo      := ADD_MONTHS(SYSDATE,Lv_Periodo-1);
                    Lv_FechaMapeoTotal := Lv_FechaMapeoTotal||' | '||TO_CHAR(Ld_FechaMapeo);

                    Lr_InfoDetMapeoPromo.ID_DETALLE_MAPEO := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL;
                    Lr_InfoDetMapeoPromo.PERIODO          := Lv_Periodo;
                    Lr_InfoDetMapeoPromo.PORCENTAJE       := Lv_Descuento;
                    Lr_InfoDetMapeoPromo.FE_MAPEO         := Ld_FechaMapeo;

                    Lt_ServiciosMapear(1) := Lt_Servicios(1);

                    --Ingresamos el detalle de mapeo de las promociones.
                    DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_DETALLE(Lr_InfoDetMapeoPromo,Lt_ServiciosMapear,Lv_MsjResultado);

                    IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                      Lv_MsjResultado:= 'Error al generar el mapeo Promocional'
                          ||' Servicio         : '||Lr_ClientesPromo.ID_SERVICIO
                          ||' Grupo Promocional: '||Lc_Promociones.ID_GRUPO_PROMOCION
                          ||' Tipo Promocional : '||Lc_Promociones.ID_TIPO_PROMOCION
                          ||' Mensaje: '          ||Lv_MsjResultado;
                      RAISE Le_MyException;
                    END IF;

                    --Insertamos el proceso de la promoción en la 'INFO_PROCESO_PROMO' de 'DB_EXTERNO'.
                    Lr_ProcesoPromo                  :=  NULL;
                    Lr_ProcesoPromo.TIPO_PROCESO     := 'AplicaPromo';
                    Lr_ProcesoPromo.EMPRESA_COD      :=  Lv_CodEmpresa;
                    Lr_ProcesoPromo.SERVICIO_ID      :=  Lr_ClientesPromo.ID_SERVICIO;
                    Lr_ProcesoPromo.DETALLE_MAPEO_ID :=  Lr_InfoDetMapeoPromo.ID_DETALLE_MAPEO;
                    Lr_ProcesoPromo.FE_INI_MAPEO     :=  Lr_InfoDetMapeoPromo.FE_MAPEO;
                    Lr_ProcesoPromo.FE_FIN_MAPEO     :=  ADD_MONTHS(Lr_InfoDetMapeoPromo.FE_MAPEO,1);
                    Lr_ProcesoPromo.USR_CREACION     :=  Lr_InfoDetMapeoPromo.USR_CREACION;
                    Lr_ProcesoPromo.IP_CREACION      :=  Lr_InfoDetMapeoPromo.IP_CREACION;
                    Lr_ProcesoPromo.TIPO_PROMO       :=  Lv_TipoPromocion;

                    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PREPARA_DATA_PROCESO_PROMO(Lr_ProcesoPromo,Lv_MsjResultado);

                    IF Lv_MsjResultado IS NOT NULL THEN
                      RAISE Le_MyException;
                    END IF;

                  END LOOP;

                  Lv_MensajeHistorial := 'Se registró correctamente el mapeo de la Promoción: '
                          ||Lc_Promociones.NOMBRE_GRUPO||' para el tipo promocional: '
                          ||Lc_Promociones.CODIGO_TIPO_PROMOCION||', Fecha-Mapeo: '||Lv_FechaMapeoTotal;

                  Lr_InfoServHist                       := NULL;
                  Lr_InfoServHist.ID_SERVICIO_HISTORIAL := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL;
                  Lr_InfoServHist.SERVICIO_ID           := Lr_ClientesPromo.ID_SERVICIO;
                  Lr_InfoServHist.ESTADO                := Lr_ClientesPromo.ESTADO;
                  Lr_InfoServHist.OBSERVACION           := Lv_MensajeHistorial;
                  Lr_InfoServHist.USR_CREACION          := Lv_UsuarioCreacion;
                  Lr_InfoServHist.IP_CREACION           := Lv_IpCreacion;
                  Lr_InfoServHist.FE_CREACION           := SYSDATE;

                  --Ingresamos el historial del servicio.
                  DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServHist,Lv_MsjResultado);

                  IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                    Lv_MsjResultado:= 'Error al ingresar el historial del servicio'
                        ||' Servicio : '||Lr_ClientesPromo.ID_SERVICIO
                        ||' Mensaje: '  ||Lv_MsjResultado;
                    RAISE Le_MyException;
                  END IF;

                  --A este punto, el servicio ya cuenta con una promoción.
                  COMMIT;
                  Lb_CumplePromocion := TRUE;

                EXCEPTION
                  WHEN Le_MyException THEN
                    ROLLBACK;
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW', 
                                                         'P_PROCESO_MASIVO_BW', 
                                                          SUBSTR(Lv_MsjResultado,0,4000),
                                                         'telcos_promo_bw',
                                                          SYSDATE,
                                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                                            '127.0.0.1'));

                END;

              END LOOP; -- END BULK COLLECT C_Promociones

            END LOOP; --END C_Promociones

          CLOSE C_Promociones;

        END LOOP; -- END BULK COLLECT Lrf_ClientesPromo

      END LOOP; --END Lrf_ClientesPromo

    CLOSE Lrf_ClientesPromo;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Pv_Mensaje := 'Error al ejecutar el proceso masivo de aplica promoción de BW';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW',
                                           'P_PROCESO_MASIVO_BW',
                                            SQLCODE||' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_PROCESO_MASIVO_BW;
----
----
  PROCEDURE P_PREPARA_DATA_PROCESO_PROMO(Pr_ProcesoPromo IN  Gr_ProcesoPromo,
                                         Pv_Mensaje      OUT VARCHAR2) IS

    --Cursores Locales
    CURSOR C_DatosServicio(Cn_IdServicio NUMBER) IS

      SELECT
          IP.ID_PUNTO                     AS ID_PUNTO,
          IP.LOGIN                        AS LOGIN_PUNTO,
          ISE.ID_SERVICIO                 AS ID_SERVICIO,
          ISE.ESTADO                      AS ESTADO_SERVICIO,
          IPC.TIPO                        AS TIPO_NEGOCIO,
          AME.NOMBRE_MODELO_ELEMENTO      AS MODELO_ELEMENTO,
          AMARCAE.NOMBRE_MARCA_ELEMENTO   AS MARCA_ELEMENTO,
          IELEM.NOMBRE_ELEMENTO           AS NOMBRE_OLT,
          DBIIE.NOMBRE_INTERFACE_ELEMENTO AS PUERTO,
          IELEM2.SERIE_FISICA             AS SERIE
      FROM DB_COMERCIAL.INFO_PUNTO                    IP,
           DB_COMERCIAL.INFO_SERVICIO                 ISE,
           DB_COMERCIAL.INFO_PLAN_CAB                 IPC,
           DB_COMERCIAL.INFO_SERVICIO_TECNICO         IST,
           DB_INFRAESTRUCTURA.INFO_ELEMENTO           IELEM,
           DB_INFRAESTRUCTURA.INFO_ELEMENTO           IELEM2,
           DB_INFRAESTRUCTURA.INFO_INTERFACE_ELEMENTO DBIIE,
           DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO    AME,
           DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO     AMARCAE
      WHERE IP.ID_PUNTO                 = ISE.PUNTO_ID
        AND ISE.PLAN_ID                 = IPC.ID_PLAN
        AND ISE.ID_SERVICIO             = IST.SERVICIO_ID
        AND IST.ELEMENTO_ID             = IELEM.ID_ELEMENTO
        AND IST.ELEMENTO_CLIENTE_ID     = IELEM2.ID_ELEMENTO
        AND IST.INTERFACE_ELEMENTO_ID   = DBIIE.ID_INTERFACE_ELEMENTO
        AND IELEM.MODELO_ELEMENTO_ID    = AME.ID_MODELO_ELEMENTO
        AND AME.MARCA_ELEMENTO_ID       = AMARCAE.ID_MARCA_ELEMENTO
        AND ISE.ID_SERVICIO             = Cn_IdServicio;

    --Variables Locales
    Lc_DatosServicio        C_DatosServicio%ROWTYPE;
    Lr_InfoProcesoPromo     DB_EXTERNO.INFO_PROCESO_PROMO%ROWTYPE;
    Lr_InfoProcesoPromoHist DB_EXTERNO.INFO_PROCESO_PROMO_HIST%ROWTYPE;
    Lv_Perfil               VARCHAR2(4000);
    Lv_Mensaje              VARCHAR2(4000);
    Ln_IpFijas              NUMBER;
    Lb_TieneDatos           BOOLEAN;
    Le_MyException          EXCEPTION;

  BEGIN

    IF C_DatosServicio%ISOPEN THEN
      CLOSE C_DatosServicio;
    END IF;

    OPEN C_DatosServicio(Pr_ProcesoPromo.SERVICIO_ID);
    FETCH C_DatosServicio INTO Lc_DatosServicio;
      Lb_TieneDatos := C_DatosServicio%NOTFOUND;
    CLOSE C_DatosServicio;

    --Verificamos si el cursor retorno datos.
    IF Lb_TieneDatos THEN
      Lv_Mensaje := 'Método: P_PREPARA_DATA_PROCESO_PROMO, Mensaje: La consulta no retorno datos';
      RAISE Le_MyException;
    END IF;

    --Validación para obtener el número de ips fijas.
    IF Lc_DatosServicio.MARCA_ELEMENTO = 'TELLION' THEN --TELLION

      Lv_Perfil  := DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(Lc_DatosServicio.ID_SERVICIO,'PERFIL');
      Lv_Perfil  := regexp_substr(Lv_Perfil,'[^_]+', 1, 3);
      Ln_IpFijas := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lv_Perfil,'^\d+')),0);

      IF Ln_IpFijas = 1 THEN
           Ln_IpFijas := 0;
      END IF;

    ELSIF Lc_DatosServicio.MARCA_ELEMENTO IN ('HUAWEI','ZTE') THEN --HUAWEI/ZTE
      Ln_IpFijas := DB_COMERCIAL.CMKG_PROMOCIONES_BW.F_NUMERO_IPS_FIJAS(Lc_DatosServicio.ID_PUNTO,
                                                                        Lc_DatosServicio.ID_SERVICIO,
                                                                        Pr_ProcesoPromo.EMPRESA_COD);
    ELSE
      Ln_IpFijas := 0;
    END IF;

    --Se arma el objeto de tipo 'DB_EXTERNO.INFO_PROCESO_PROMO'.
    Lr_InfoProcesoPromo                   :=  NULL;
    Lr_InfoProcesoPromo.ID_PROCESO_PROMO  :=  DB_EXTERNO.SEQ_INFO_PROCESO_PROMO.NEXTVAL;
    Lr_InfoProcesoPromo.FE_CREACION       :=  SYSDATE;
    IF Pr_ProcesoPromo.ESTADO IS NOT NULL THEN
      Lr_InfoProcesoPromo.ESTADO          := Pr_ProcesoPromo.ESTADO;
    ELSE
      Lr_InfoProcesoPromo.ESTADO          := 'Pendiente';
    END IF;
    Lr_InfoProcesoPromo.NUM_IPS_FIJAS     :=  Ln_IpFijas;
    Lr_InfoProcesoPromo.TIPO_NEGOCIO      :=  Lc_DatosServicio.TIPO_NEGOCIO;
    Lr_InfoProcesoPromo.MODELO_ELEMENTO   :=  Lc_DatosServicio.MODELO_ELEMENTO;
    Lr_InfoProcesoPromo.NOMBRE_OLT        :=  Lc_DatosServicio.NOMBRE_OLT;
    Lr_InfoProcesoPromo.PUERTO            :=  Lc_DatosServicio.PUERTO;
    Lr_InfoProcesoPromo.SERIE             :=  Lc_DatosServicio.SERIE;
    Lr_InfoProcesoPromo.LOGIN_PUNTO       :=  Lc_DatosServicio.LOGIN_PUNTO;
    Lr_InfoProcesoPromo.SERVICIO_ID       :=  Lc_DatosServicio.ID_SERVICIO;
    Lr_InfoProcesoPromo.ESTADO_SERVICIO   :=  Lc_DatosServicio.ESTADO_SERVICIO;
    Lr_InfoProcesoPromo.EMPRESA_COD       :=  Pr_ProcesoPromo.EMPRESA_COD;

    Lr_InfoProcesoPromo.MAC                   :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'MAC ONT');

    Lr_InfoProcesoPromo.SERVICE_PORT          :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'SPID');

    Lr_InfoProcesoPromo.ONT_ID                :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'INDICE CLIENTE');

    Lr_InfoProcesoPromo.TRAFFIC_PROMO         :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'TRAFFIC-TABLE-PROMO');

    Lr_InfoProcesoPromo.GEMPORT_PROMO         :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'GEM-PORT-PROMO');

    Lr_InfoProcesoPromo.LINE_PROFILE_PROMO    :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'LINE-PROFILE-NAME-PROMO');

    IF Lr_InfoProcesoPromo.LINE_PROFILE_PROMO IS NULL THEN
      Lr_InfoProcesoPromo.LINE_PROFILE_PROMO :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                       Lc_DatosServicio.ID_SERVICIO,'PERFIL-PROMO');
    END IF;

    Lr_InfoProcesoPromo.CAPACIDAD_UP_PROMO    :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'CAPACIDAD1-PROMO');

    Lr_InfoProcesoPromo.CAPACIDAD_DOWN_PROMO  :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'CAPACIDAD2-PROMO');

    Lr_InfoProcesoPromo.TRAFFIC_ORIGIN        :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'TRAFFIC-TABLE');

    Lr_InfoProcesoPromo.GEMPORT_ORIGIN        :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'GEM-PORT');

    Lr_InfoProcesoPromo.LINE_PROFILE_ORIGIN   :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'LINE-PROFILE-NAME');

    IF Lr_InfoProcesoPromo.LINE_PROFILE_ORIGIN IS NULL THEN
        Lr_InfoProcesoPromo.LINE_PROFILE_ORIGIN :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'PERFIL');
    END IF;

    Lr_InfoProcesoPromo.VLAN_ORIGIN           :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'VLAN');

    Lr_InfoProcesoPromo.SERVICE_PROFILE       :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'SERVICE-PROFILE');

    Lr_InfoProcesoPromo.CAPACIDAD_UP_ORIGIN   :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'CAPACIDAD1');

    Lr_InfoProcesoPromo.CAPACIDAD_DOWN_ORIGIN :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                        Lc_DatosServicio.ID_SERVICIO,'CAPACIDAD2');

    Lr_InfoProcesoPromo.TIPO_PROCESO     :=  Pr_ProcesoPromo.TIPO_PROCESO;
    Lr_InfoProcesoPromo.TIPO_PROMO       :=  Pr_ProcesoPromo.TIPO_PROMO;
    Lr_InfoProcesoPromo.DETALLE_MAPEO_ID :=  Pr_ProcesoPromo.DETALLE_MAPEO_ID;
    Lr_InfoProcesoPromo.FE_INI_MAPEO     :=  TRUNC(Pr_ProcesoPromo.FE_INI_MAPEO);
    Lr_InfoProcesoPromo.FE_FIN_MAPEO     :=  TRUNC(Pr_ProcesoPromo.FE_FIN_MAPEO);
    Lr_InfoProcesoPromo.USR_CREACION     :=  Pr_ProcesoPromo.USR_CREACION;
    Lr_InfoProcesoPromo.IP_CREACION      :=  Pr_ProcesoPromo.IP_CREACION;

    --Llamada al procedimiento encargado de registrar el proceso de la promoción.
    DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_INSERT_PROCESO_PROMO(Lr_InfoProcesoPromo,Lv_Mensaje);

    IF Lv_Mensaje IS NOT NULL THEN
      Lv_Mensaje := 'Servicio: '        ||Lr_InfoProcesoPromo.SERVICIO_ID ||','||
                    'Tipo Proceso: '    ||Lr_InfoProcesoPromo.TIPO_PROCESO||','||
                    'Tipo Promocional: '||Lr_InfoProcesoPromo.TIPO_PROMO  ||','||
                    'Mensaje: '         ||Lv_Mensaje;
      RAISE Le_MyException;
    END IF;

    --Se arma el objeto de tipo 'DB_EXTERNO.INFO_PROCESO_PROMO_HIST'.
    Lr_InfoProcesoPromoHist                       :=  NULL;
    Lr_InfoProcesoPromoHist.ID_PROCESO_PROMO_HIST :=  DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_HIST.NEXTVAL;
    Lr_InfoProcesoPromoHist.PROCESO_PROMO_ID      :=  Lr_InfoProcesoPromo.ID_PROCESO_PROMO;
    Lr_InfoProcesoPromoHist.ESTADO                :=  Lr_InfoProcesoPromo.ESTADO;
    Lr_InfoProcesoPromoHist.OBSERVACION           := 'Creación del proceso de promoción';
    Lr_InfoProcesoPromoHist.FE_CREACION           :=  SYSDATE;
    Lr_InfoProcesoPromoHist.USR_CREACION          :=  Lr_InfoProcesoPromo.USR_CREACION;
    Lr_InfoProcesoPromoHist.IP_CREACION           :=  Lr_InfoProcesoPromo.IP_CREACION;

    --Llamada al procedimiento encargado de registrar el historial del proceso de la promoción.
    DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_INSERT_PROCESO_PROMO_HIST(Lr_InfoProcesoPromoHist,Lv_Mensaje);

    IF Lv_Mensaje IS NOT NULL THEN
      Lv_Mensaje := 'Servicio: '        ||Lr_InfoProcesoPromo.SERVICIO_ID ||','||
                    'Tipo Proceso: '    ||Lr_InfoProcesoPromo.TIPO_PROCESO||','||
                    'Tipo Promocional: '||Lr_InfoProcesoPromo.TIPO_PROMO  ||','||
                    'Mensaje: '         ||Lv_Mensaje;
      RAISE Le_MyException;
    END IF;

  EXCEPTION
    WHEN Le_MyException THEN
      Pv_Mensaje := Lv_Mensaje;
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_PREPARA_DATA_PROCESO_PROMO, Error: '||SUBSTR(SQLERRM,0,2000);

  END P_PREPARA_DATA_PROCESO_PROMO;
----
----
  PROCEDURE P_UPDATE_RDA_PROMOCION(Pcl_Json   IN  CLOB,
                                   Pv_Mensaje OUT VARCHAR2) IS

    CURSOR C_InforProcesoPromo(Cn_IdServicio    NUMBER,
                               Cv_TipoProceso   VARCHAR2,
                               Cv_TipoPromocion VARCHAR2,
                               Cv_Estado        VARCHAR2)
    IS
      SELECT IPP.*
          FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
      WHERE IPP.SERVICIO_ID         = Cn_IdServicio
        AND UPPER(IPP.TIPO_PROCESO) = UPPER(Cv_TipoProceso)
        AND UPPER(IPP.TIPO_PROMO)   = UPPER(Cv_TipoPromocion)
        AND UPPER(IPP.ESTADO)       = UPPER(Cv_Estado);

    Lr_InfoProcesoPromo     DB_EXTERNO.INFO_PROCESO_PROMO%ROWTYPE;
    Lr_InfoProcesoPromoHist DB_EXTERNO.INFO_PROCESO_PROMO_HIST%ROWTYPE;
    Lv_Codigo               VARCHAR2(30) := ROUND(DBMS_RANDOM.VALUE(1000,9999))||TO_CHAR(SYSDATE,'DDMMRRRRHH24MISS');
    Lv_Mensaje              VARCHAR2(4000);
    Le_MyException          EXCEPTION;
    Lv_Usuario              VARCHAR2(20);
    Lv_Ip                   VARCHAR2(15);
    Lv_Estado               VARCHAR2(10) := 'Pendiente';

  BEGIN

    IF C_InforProcesoPromo%ISOPEN THEN
      CLOSE C_InforProcesoPromo;
    END IF;

    --Record del proceso de promoción.
    APEX_JSON.PARSE(Pcl_Json);

    Lv_Usuario := NVL(SUBSTR(TRIM(APEX_JSON.GET_VARCHAR2('strUsrCreacion')),0,20),'telcos_promo_bw');
    Lv_Ip      := NVL(SUBSTR(TRIM(APEX_JSON.GET_VARCHAR2('strIpCreacion')),0,15),'127.0.0.1');

    Lr_InfoProcesoPromo                      := NULL;
    Lr_InfoProcesoPromo.TRAFFIC_PROMO        := APEX_JSON.GET_VARCHAR2('strTrafficPromo');
    Lr_InfoProcesoPromo.GEMPORT_PROMO        := APEX_JSON.GET_VARCHAR2('strGemPortPromo');
    Lr_InfoProcesoPromo.LINE_PROFILE_PROMO   := APEX_JSON.GET_VARCHAR2('strLineProfilePromo');
    Lr_InfoProcesoPromo.CAPACIDAD_UP_PROMO   := APEX_JSON.GET_VARCHAR2('strCapacidadUpPromo');
    Lr_InfoProcesoPromo.CAPACIDAD_DOWN_PROMO := APEX_JSON.GET_VARCHAR2('strCapacidadDownPromo');
    Lr_InfoProcesoPromo.USR_MODIFICACION     := Lv_Usuario;
    Lr_InfoProcesoPromo.IP_MODIFICACION      := Lv_Ip;

    --Record del historial del proceso de promoción.
    Lr_InfoProcesoPromoHist              := NULL;
    Lr_InfoProcesoPromoHist.OBSERVACION  := APEX_JSON.GET_VARCHAR2('strObservacion');
    Lr_InfoProcesoPromoHist.USR_CREACION := Lr_InfoProcesoPromo.USR_MODIFICACION;
    Lr_InfoProcesoPromoHist.IP_CREACION  := Lr_InfoProcesoPromo.IP_MODIFICACION;

    --Loop para obtener los procesos en estado 'Pendiente'.
    FOR InfoProcesoPromo IN C_InforProcesoPromo(APEX_JSON.GET_VARCHAR2('intIdServicio'),
                                                APEX_JSON.GET_VARCHAR2('strTipoProceso'),
                                                APEX_JSON.GET_VARCHAR2('strTipoPromocion'),
                                                Lv_Estado) LOOP

      BEGIN

        Lr_InfoProcesoPromo.ID_PROCESO_PROMO := InfoProcesoPromo.ID_PROCESO_PROMO;

        --Actualizamos la promoción
        DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_UPDATE_PROMOCION(Lr_InfoProcesoPromo,Lv_Mensaje);

        IF Lv_Mensaje IS NOT NULL THEN
            Lv_Mensaje := 'ID_PROCESO_PROMO: '||InfoProcesoPromo.ID_PROCESO_PROMO||', Mensaje: '||Lv_Mensaje;
            RAISE Le_MyException;
        END IF;

        --Se arma el record para insertar el historial de la actualización de la promoción.
        Lr_InfoProcesoPromoHist.ID_PROCESO_PROMO_HIST := DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_HIST.NEXTVAL;
        Lr_InfoProcesoPromoHist.PROCESO_PROMO_ID      := InfoProcesoPromo.ID_PROCESO_PROMO;
        Lr_InfoProcesoPromoHist.ESTADO                := InfoProcesoPromo.ESTADO;
        Lr_InfoProcesoPromoHist.FE_CREACION           := SYSDATE;

        --Llamada al procedimiento encargado de registrar el historial.
        DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_INSERT_PROCESO_PROMO_HIST(Lr_InfoProcesoPromoHist,Lv_Mensaje);

        IF Lv_Mensaje IS NOT NULL THEN
            RAISE Le_MyException;
        END IF;

      EXCEPTION
        WHEN Le_MyException THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW',
                                               'P_UPDATE_RDA_PROMOCION',
                                                Lv_Mensaje,
                                                NVL(Lv_Usuario,'telcos_promo_bw'),
                                                SYSDATE,
                                                NVL(NVL(Lv_Ip,SYS_CONTEXT('USERENV','IP_ADDRESS')),'127.0.0.1'));
      END;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_UPDATE_RDA_PROMOCION, Error: '||SUBSTR(SQLERRM,0,2000);

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW',
                                           'P_UPDATE_RDA_PROMOCION',
                                            SUBSTR(Lv_Codigo||'|'||
                                              SQLCODE||' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,0,4000),
                                            NVL(Lv_Usuario,'telcos_promo_bw'),
                                            SYSDATE,
                                            NVL(NVL(Lv_Ip,SYS_CONTEXT('USERENV','IP_ADDRESS')),'127.0.0.1'));

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW',
                                           'P_UPDATE_RDA_PROMOCION',
                                            SUBSTR(Lv_Codigo||'|'||Pcl_Json,0,4000),
                                            NVL(Lv_Usuario,'telcos_promo_bw'),
                                            SYSDATE,
                                            NVL(NVL(Lv_Ip,SYS_CONTEXT('USERENV','IP_ADDRESS')),'127.0.0.1'));

  END P_UPDATE_RDA_PROMOCION;
----
----
  PROCEDURE P_VALIDA_CARACTERISTICAS_PROMO(Pr_ParametrosCreaCaract IN  Gr_ParametrosCreaCaract,
                                           Pv_Mensaje              OUT VARCHAR2) IS

    CURSOR C_Caracteristica(Cv_CodEmpresa        VARCHAR2,
                            Cn_IdPlan            NUMBER,
                            Cv_NombreTecnico     VARCHAR2,
                            Cv_DescripcionCaract VARCHAR2) IS

        SELECT i0_.VALOR AS VALOR,
               I1_.TIPO  AS TIPO
            FROM DB_COMERCIAL.INFO_PLAN_CAB                i1_,
                 DB_COMERCIAL.INFO_PLAN_DET                i2_,
                 DB_COMERCIAL.ADMI_PRODUCTO                a3_,
                 DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA a4_,
                 DB_COMERCIAL.ADMI_CARACTERISTICA          a5_,
                 DB_COMERCIAL.INFO_PLAN_PRODUCTO_CARACT    i0_
        WHERE i2_.PLAN_ID                     = i1_.ID_PLAN
          AND a3_.ID_PRODUCTO                 = i2_.PRODUCTO_ID
          AND a4_.PRODUCTO_ID                 = a3_.ID_PRODUCTO
          AND a5_.ID_CARACTERISTICA           = a4_.CARACTERISTICA_ID
          AND i0_.PRODUCTO_CARACTERISITICA_ID = a4_.ID_PRODUCTO_CARACTERISITICA
          AND i1_.EMPRESA_COD                 = Cv_CodEmpresa
          AND i1_.ID_PLAN                     = Cn_IdPlan
          AND i2_.ID_ITEM                     = i0_.PLAN_DET_ID
          AND UPPER(A3_.NOMBRE_TECNICO)       = UPPER(Cv_NombreTecnico)
          AND UPPER(a5_.DESCRIPCION_CARACTERISTICA) = UPPER(Cv_DescripcionCaract);

    --Cursor para obtener información necesaria del elemento
    CURSOR C_ElementoCliente(Cn_IdServicio NUMBER) IS
        SELECT IEL.ID_ELEMENTO             AS ID_OLT,
               AMOE.NOMBRE_MODELO_ELEMENTO AS NOMBRE_MODELO_ELEMENTO,
               AMAE.NOMBRE_MARCA_ELEMENTO  AS NOMBRE_MARCA_ELEMENTO
            FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO      IST,
                 DB_INFRAESTRUCTURA.INFO_ELEMENTO        IEL,
                 DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO AMOE,
                 DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO  AMAE
        WHERE IST.ELEMENTO_ID        = IEL.ID_ELEMENTO
          AND IEL.MODELO_ELEMENTO_ID = AMOE.ID_MODELO_ELEMENTO
          AND AMOE.MARCA_ELEMENTO_ID = AMAE.ID_MARCA_ELEMENTO
          AND IST.SERVICIO_ID        = Cn_IdServicio;

    --Cursor para obtener la característica de Ultra Velocidad
    CURSOR C_PlanCaracUltraV(Cn_IdPlan         NUMBER,
                             Cv_Caracteristica VARCHAR2,  --'ULTRA VELOCIDAD'
                             Cv_Estado         VARCHAR2)  --'Activo'
    IS
        SELECT IPC.VALOR
            FROM DB_COMERCIAL.ADMI_CARACTERISTICA      CA,
                 DB_COMERCIAL.INFO_PLAN_CARACTERISTICA IPC
        WHERE CA.ID_CARACTERISTICA          = IPC.CARACTERISTICA_ID
          AND CA.DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
          AND IPC.PLAN_ID                   = Cn_IdPlan
          AND CA.ESTADO                     = Cv_Estado
          AND IPC.ESTADO                    = Cv_Estado;

    --Cursor para obtener las características de HUAWEI
    CURSOR C_CaractHuawei(Cv_NombreTecnico      VARCHAR2,   --'INTERNET'
                          Cv_CodEmpresa         VARCHAR2,
                          Cv_CaractTrafficTable VARCHAR2,   --'TRAFFIC-TABLE'
                          Cv_CaractGemPort      VARCHAR2,   --'GEM-PORT'
                          Cv_CaractLineProfile  VARCHAR2,   --'LINE-PROFILE-NAME'
                          Cn_IdElementoOlt      NUMBER,
                          Cv_PerfilEquivalente  VARCHAR2,
                          Cv_CaractUltraV       VARCHAR2,
                          Cv_CnrParametro       VARCHAR2)   --'CNR_PERFIL_CLIENT_PCK'
    IS

        SELECT
            AAA.DESCRIPCION_CARACTERISTICA AS CARACTERISTICA,
            BBB.DETALLE_VALOR              AS VALOR
        FROM
            (
                --AQUI VA EL TRAFFIC-TABLE
                SELECT APC.ID_PRODUCTO_CARACTERISITICA,
                       DESCRIPCION_CARACTERISTICA
                    FROM DB_COMERCIAL.ADMI_PRODUCTO                AP,
                         DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
                         DB_COMERCIAL.ADMI_CARACTERISTICA          AC
                WHERE AP.ID_PRODUCTO = APC.PRODUCTO_ID
                  AND APC.CARACTERISTICA_ID      = AC.ID_CARACTERISTICA
                  AND AP.NOMBRE_TECNICO          = Cv_NombreTecnico
                  AND EMPRESA_COD                = Cv_CodEmpresa
                  AND DESCRIPCION_CARACTERISTICA = Cv_CaractTrafficTable
                UNION
                --AQUI VA EL GEM-PORT
                SELECT APC.ID_PRODUCTO_CARACTERISITICA,
                       DESCRIPCION_CARACTERISTICA
                    FROM DB_COMERCIAL.ADMI_PRODUCTO                AP,
                         DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
                         DB_COMERCIAL.ADMI_CARACTERISTICA          AC
                WHERE AP.ID_PRODUCTO = APC.PRODUCTO_ID
                  AND APC.CARACTERISTICA_ID      = AC.ID_CARACTERISTICA
                  AND AP.NOMBRE_TECNICO          = Cv_NombreTecnico
                  AND EMPRESA_COD                = Cv_CodEmpresa
                  AND DESCRIPCION_CARACTERISTICA = Cv_CaractGemPort
                UNION
                -- AQUI VA EL LINE PROFLE NAME
                SELECT APC.ID_PRODUCTO_CARACTERISITICA,
                       DESCRIPCION_CARACTERISTICA
                    FROM DB_COMERCIAL.ADMI_PRODUCTO                AP,
                         DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC,
                         DB_COMERCIAL.ADMI_CARACTERISTICA          AC
                WHERE AP.ID_PRODUCTO = APC.PRODUCTO_ID
                  AND APC.CARACTERISTICA_ID      = AC.ID_CARACTERISTICA
                  AND AP.NOMBRE_TECNICO          = Cv_NombreTecnico
                  AND EMPRESA_COD                = Cv_CodEmpresa
                  AND DESCRIPCION_CARACTERISTICA = Cv_CaractLineProfile

            ) AAA,
            (
                --TRAFFIC-TABLE
                SELECT DETALLE_NOMBRE,
                       DETALLE_VALOR
                    FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO BBB
                WHERE BBB.REF_DETALLE_ELEMENTO_ID IN (
                        SELECT ID_DETALLE_ELEMENTO
                            FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                        WHERE DETALLE_NOMBRE = Cv_CaractLineProfile
                          AND ELEMENTO_ID    = Cn_IdElementoOlt
                          AND DETALLE_VALOR  = (
                                SELECT PARD.VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARC,
                                         DB_GENERAL.ADMI_PARAMETRO_DET PARD
                                WHERE PARC.ID_PARAMETRO     = PARD.PARAMETRO_ID
                                  AND PARC.NOMBRE_PARAMETRO = Cv_CnrParametro
                                  AND PARD.VALOR2           = Cv_PerfilEquivalente
                                  AND PARD.VALOR5           = Cv_CaractUltraV
                                  AND ROWNUM               <= 1
                            )
                )
                UNION
                --LINE-PROFILE-NAME / GEM-PORT
                SELECT DETALLE_NOMBRE,
                       DETALLE_VALOR
                    FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO BBB
                WHERE BBB.REF_DETALLE_ELEMENTO_ID IN (
                        SELECT REF_DETALLE_ELEMENTO_ID
                            FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                        WHERE DETALLE_NOMBRE = Cv_CaractLineProfile
                          AND ELEMENTO_ID    = Cn_IdElementoOlt
                          AND DETALLE_VALOR  = (
                                SELECT PARD.VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARC,
                                         DB_GENERAL.ADMI_PARAMETRO_DET PARD
                                WHERE PARC.ID_PARAMETRO     = PARD.PARAMETRO_ID
                                  AND PARC.NOMBRE_PARAMETRO = Cv_CnrParametro
                                  AND PARD.VALOR2           = Cv_PerfilEquivalente
                                  AND PARD.VALOR5           = Cv_CaractUltraV
                                  AND ROWNUM               <= 1
                            )
                )
                UNION
                --LINE-PROFILE-ID
                SELECT DETALLE_NOMBRE,
                       DETALLE_VALOR
                    FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO BBB
                WHERE BBB.ID_DETALLE_ELEMENTO IN (
                        SELECT REF_DETALLE_ELEMENTO_ID
                            FROM DB_INFRAESTRUCTURA.INFO_DETALLE_ELEMENTO
                        WHERE DETALLE_NOMBRE = Cv_CaractLineProfile
                          AND ELEMENTO_ID    = Cn_IdElementoOlt
                          AND DETALLE_VALOR  = (
                                SELECT PARD.VALOR1
                                    FROM DB_GENERAL.ADMI_PARAMETRO_CAB PARC,
                                         DB_GENERAL.ADMI_PARAMETRO_DET PARD
                                WHERE PARC.ID_PARAMETRO     = PARD.PARAMETRO_ID
                                  AND PARC.NOMBRE_PARAMETRO = Cv_CnrParametro
                                  AND PARD.VALOR2           = Cv_PerfilEquivalente
                                  AND PARD.VALOR5           = Cv_CaractUltraV
                                  AND ROWNUM               <= 1
                            )
                )

            ) BBB
        WHERE AAA.DESCRIPCION_CARACTERISTICA = BBB.DETALLE_NOMBRE;

    --Cursor que obtiene el producto característica.
    CURSOR C_AdmiProdCaract(Cv_NombreTecnico  VARCHAR2,
                            Cv_CodEmpresa     VARCHAR2,
                            Cv_Caracteristica VARCHAR2,
                            Cv_Estado         VARCHAR2)
    IS

        SELECT APCAR.*
            FROM DB_COMERCIAL.ADMI_PRODUCTO                ADPRO,
                 DB_COMERCIAL.ADMI_CARACTERISTICA          ADCARCT,
                 DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APCAR
        WHERE APCAR.PRODUCTO_ID           = ADPRO.ID_PRODUCTO
          AND APCAR.CARACTERISTICA_ID     = ADCARCT.ID_CARACTERISTICA
          AND UPPER(ADPRO.NOMBRE_TECNICO) = UPPER(Cv_NombreTecnico)
          AND ADPRO.EMPRESA_COD           = Cv_CodEmpresa
          AND UPPER(ADCARCT.ESTADO)       = UPPER(Cv_Estado)
          AND UPPER(APCAR.ESTADO)         = UPPER(Cv_Estado)
          AND UPPER(ADCARCT.DESCRIPCION_CARACTERISTICA) = UPPER(Cv_Caracteristica);

    --Variables
    Lc_PerfilPlan            C_Caracteristica%ROWTYPE;
    Lc_ElementoCliente       C_ElementoCliente%ROWTYPE;
    Lc_AdmiProdCaract        C_AdmiProdCaract%ROWTYPE;
    Lr_InfoServProdCaract    DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT%ROWTYPE;
    Lv_Mensaje               VARCHAR2(4000);
    Le_MyException           EXCEPTION;
    Lb_TieneDatos            BOOLEAN;
    Lv_PerfilEqui            VARCHAR2(4000);
    Lv_PlanCaracUltraV       VARCHAR2(4);
    Lv_PerfilPromo           VARCHAR2(1000); --TELLION
    Lv_CapacidadUpPromo      VARCHAR2(1000); --ZTE
    Lv_CapacidadDownPromo    VARCHAR2(1000); --ZTE
    Lv_ValorTrafficTable     VARCHAR2(1000); --HUAWEI
    Lv_ValorGemPort          VARCHAR2(1000); --HUAWEI
    Lv_LineProfileName       VARCHAR2(1000); --HUAWEI
    Ltl_Caracteristicas      Gtl_Caracteristicas;
    Lr_Caracteristica        Gr_Caracteristica;
    Ln_Index                 NUMBER := 0;

  BEGIN

    IF C_Caracteristica%ISOPEN THEN
      CLOSE C_Caracteristica;
    END IF;

    IF C_ElementoCliente%ISOPEN THEN
      CLOSE C_ElementoCliente;
    END IF;

    IF C_PlanCaracUltraV%ISOPEN THEN
      CLOSE C_PlanCaracUltraV;
    END IF;

    IF C_CaractHuawei%ISOPEN THEN
      CLOSE C_CaractHuawei;
    END IF;

    IF C_AdmiProdCaract%ISOPEN THEN
      CLOSE C_AdmiProdCaract;
    END IF;

    --Obtenemos la información necesaria del servicio.
    OPEN C_ElementoCliente(Pr_ParametrosCreaCaract.ID_SERVICIO);
      FETCH C_ElementoCliente INTO Lc_ElementoCliente;
        Lb_TieneDatos := C_ElementoCliente%NOTFOUND;
    CLOSE C_ElementoCliente;

    IF Lb_TieneDatos THEN
      Lv_Mensaje := 'No se pudo obtener los datos adicionales del elemento.';
      RAISE Le_MyException;
    END IF;

    --Proceso para obtener el perfil equivalente del plan promocional.
    IF Lc_ElementoCliente.NOMBRE_MARCA_ELEMENTO IN ('TELLION','HUAWEI') THEN --TELLION / HUAWEI

      --Obtenemos el perfil del plan promocional.
      OPEN C_Caracteristica(Pr_ParametrosCreaCaract.COD_EMPRESA,Pr_ParametrosCreaCaract.ID_PLAN_PROMO,'INTERNET','PERFIL');
        FETCH C_Caracteristica INTO Lc_PerfilPlan;
          Lb_TieneDatos := C_Caracteristica%NOTFOUND;
      CLOSE C_Caracteristica;

      IF Lb_TieneDatos THEN
        Lv_Mensaje := 'No se pudo obtener el perfil del plan promocional.';
        RAISE Le_MyException;
      END IF;

      --Perfil Equivalente del plan promocional.
      DB_INFRAESTRUCTURA.INFRK_TRANSACCIONES.INFRP_PERFIL_EQUIVALENTE(
              Pn_IdPlan              =>  Pr_ParametrosCreaCaract.ID_PLAN_PROMO,
              Pn_IdOlt               =>  Lc_ElementoCliente.ID_OLT,
              Pv_Perfil              =>  Lc_PerfilPlan.VALOR,
              Pv_Marca               =>  Lc_ElementoCliente.NOMBRE_MARCA_ELEMENTO,
              Pv_TipoNegocio         =>  Lc_PerfilPlan.TIPO,
              Pv_AprovisionamientoIp => 'CNR',
              Pv_TipoEjecucion       => 'FLUJO',
              Pv_EmpresaCod          =>  Pr_ParametrosCreaCaract.COD_EMPRESA,
              Lv_PerfilEqui          =>  Lv_PerfilEqui);

      IF Lv_PerfilEqui IS NULL THEN
        Lv_Mensaje := 'No se pudo obtener el perfil equivalente.';
        RAISE Le_MyException;
      END IF;

    END IF;

    Ltl_Caracteristicas.DELETE();

    --Validación
    IF Lc_ElementoCliente.NOMBRE_MARCA_ELEMENTO = 'TELLION' THEN --TELLION

      Lv_PerfilPromo := substr(Lv_PerfilEqui,-(LENGTH(Lv_PerfilEqui)),(INSTR(Lv_PerfilEqui,'_',-1))-1);
      Ltl_Caracteristicas(0).CARACTERISTICA := 'PERFIL-PROMO';
      Ltl_Caracteristicas(0).VALOR          := Lv_PerfilPromo;

    ELSIF Lc_ElementoCliente.NOMBRE_MARCA_ELEMENTO = 'ZTE' THEN --ZTE

      Lc_PerfilPlan := NULL;
      OPEN C_Caracteristica(Pr_ParametrosCreaCaract.COD_EMPRESA,Pr_ParametrosCreaCaract.ID_PLAN_PROMO,'INTERNET','CAPACIDAD1');
          FETCH C_Caracteristica INTO Lc_PerfilPlan;
      CLOSE C_Caracteristica;

      Lv_CapacidadUpPromo := Lc_PerfilPlan.VALOR;

      Lc_PerfilPlan := NULL;
      OPEN C_Caracteristica(Pr_ParametrosCreaCaract.COD_EMPRESA,Pr_ParametrosCreaCaract.ID_PLAN_PROMO,'INTERNET','CAPACIDAD2');
        FETCH C_Caracteristica INTO Lc_PerfilPlan;
      CLOSE C_Caracteristica;

      Lv_CapacidadDownPromo := Lc_PerfilPlan.VALOR;

      IF Lv_CapacidadUpPromo IS NULL OR Lv_CapacidadDownPromo IS NULL THEN
        Lv_Mensaje := 'No se pudo obtener las capacidades del plan promocional.';
        RAISE Le_MyException;
      END IF;

      Ltl_Caracteristicas(0).CARACTERISTICA := 'CAPACIDAD1-PROMO';
      Ltl_Caracteristicas(0).VALOR          :=  Lv_CapacidadUpPromo;
      Ltl_Caracteristicas(1).CARACTERISTICA := 'CAPACIDAD2-PROMO';
      Ltl_Caracteristicas(1).VALOR          :=  Lv_CapacidadDownPromo;

    ELSIF Lc_ElementoCliente.NOMBRE_MARCA_ELEMENTO = 'HUAWEI' THEN --HUAWEI

      OPEN C_PlanCaracUltraV(Pr_ParametrosCreaCaract.ID_PLAN_PROMO,'ULTRA VELOCIDAD','Activo');
        FETCH C_PlanCaracUltraV INTO Lv_PlanCaracUltraV;
      CLOSE C_PlanCaracUltraV;

      IF Lv_PlanCaracUltraV IS NULL THEN
        Lv_PlanCaracUltraV := 'NO';
      END IF;

      --Obtenemos las características.
      FOR HUAWEI IN C_CaractHuawei('INTERNET',Pr_ParametrosCreaCaract.COD_EMPRESA,
                                   'TRAFFIC-TABLE','GEM-PORT','LINE-PROFILE-NAME',
                                    Lc_ElementoCliente.ID_OLT,Lv_PerfilEqui,
                                    Lv_PlanCaracUltraV,'CNR_PERFIL_CLIENT_PCK') LOOP

        IF HUAWEI.CARACTERISTICA = 'TRAFFIC-TABLE' THEN
          Lv_ValorTrafficTable := HUAWEI.VALOR;
        ELSIF HUAWEI.CARACTERISTICA = 'GEM-PORT' THEN
          Lv_ValorGemPort := HUAWEI.VALOR;
        ELSIF HUAWEI.CARACTERISTICA = 'LINE-PROFILE-NAME' THEN
          Lv_LineProfileName := HUAWEI.VALOR;
        ELSE
          CONTINUE;
        END IF;

      END LOOP;

      IF Lv_ValorTrafficTable IS NULL OR Lv_ValorGemPort IS NULL OR Lv_LineProfileName IS NULL THEN
        Lv_Mensaje := 'No se pudo obtener las características promocionales del plan.';
        RAISE Le_MyException;
      END IF;

      Ltl_Caracteristicas(0).CARACTERISTICA := 'TRAFFIC-TABLE-PROMO';
      Ltl_Caracteristicas(0).VALOR          :=  Lv_ValorTrafficTable;
      Ltl_Caracteristicas(1).CARACTERISTICA := 'GEM-PORT-PROMO';
      Ltl_Caracteristicas(1).VALOR          :=  Lv_ValorGemPort;
      Ltl_Caracteristicas(2).CARACTERISTICA := 'LINE-PROFILE-NAME-PROMO';
      Ltl_Caracteristicas(2).VALOR          :=  Lv_LineProfileName;

    ELSE
      Lv_Mensaje := 'Modelo no considerado: '||Lc_ElementoCliente.NOMBRE_MODELO_ELEMENTO;
      RAISE Le_MyException;
    END IF;

    --Eliminación de las características promocionales.
    DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_ELIMINA_CARACT_PROMO_BW(Pr_ParametrosCreaCaract.ID_SERVICIO,Lv_Mensaje);

    IF Lv_Mensaje IS NOT NULL THEN
      RAISE Le_MyException;
    END IF;

    --Creación de las características promocionales.
    Ln_Index := Ltl_Caracteristicas.FIRST;
    WHILE (Ln_Index IS NOT NULL) LOOP

      Lr_Caracteristica := Ltl_Caracteristicas(Ln_Index);
      Ln_Index          := Ltl_Caracteristicas.NEXT(Ln_Index);

      OPEN C_AdmiProdCaract('INTERNET',Pr_ParametrosCreaCaract.COD_EMPRESA,Lr_Caracteristica.CARACTERISTICA,'Activo');
        FETCH C_AdmiProdCaract INTO Lc_AdmiProdCaract;
          Lb_TieneDatos := C_AdmiProdCaract%NOTFOUND;
      CLOSE C_AdmiProdCaract;

      IF Lb_TieneDatos THEN
        Lv_Mensaje := 'La característica: '||Lr_Caracteristica.CARACTERISTICA||' no se encuentra configurada.';
        RAISE Le_MyException;
      END IF;

      Lr_InfoServProdCaract                             :=  NULL;
      Lr_InfoServProdCaract.ESTADO                      := 'Activo';
      Lr_InfoServProdCaract.ID_SERVICIO_PROD_CARACT     :=  DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL;
      Lr_InfoServProdCaract.SERVICIO_ID                 :=  Pr_ParametrosCreaCaract.ID_SERVICIO;
      Lr_InfoServProdCaract.PRODUCTO_CARACTERISITICA_ID :=  Lc_AdmiProdCaract.ID_PRODUCTO_CARACTERISITICA;
      Lr_InfoServProdCaract.VALOR                       :=  Lr_Caracteristica.VALOR;
      Lr_InfoServProdCaract.FE_CREACION                 :=  SYSDATE;
      Lr_InfoServProdCaract.USR_CREACION                :=  Pr_ParametrosCreaCaract.USUARIO;

      DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.P_INSERT_ISERVICIO_PROD_CARACT(Lr_InfoServProdCaract,Lv_Mensaje);

      IF Lv_Mensaje IS NOT NULL THEN
        RAISE Le_MyException;
      END IF;

    END LOOP;

  EXCEPTION
    WHEN Le_MyException THEN
      Pv_Mensaje := 'Método: P_VALIDA_CARACTERISTICAS_PROMO, Error: '||Lv_Mensaje;
    WHEN OTHERS THEN
      Pv_Mensaje := 'Método: P_VALIDA_CARACTERISTICAS_PROMO, Error: '||SUBSTR(SQLERRM,0,2000);

  END P_VALIDA_CARACTERISTICAS_PROMO;
----
----
  PROCEDURE P_NOTIFICA_ERROR_PROCESO_PROMO IS

    CURSOR C_CLientesPromocion(Cv_Estado VARCHAR2)IS
      SELECT CLIENTES.* FROM
        (
          SELECT
               IPERS.IDENTIFICACION_CLIENTE AS IDENTIFICACION,
               NVL(IPERS.RAZON_SOCIAL,IPERS.NOMBRES
                    ||' '||IPERS.APELLIDOS) AS CLIENTE,
               IPUN.LOGIN       AS PUNTO_LOGIN,
               ISER.ESTADO      AS ESTADO_SERVICIO,
               IPP.TIPO_PROMO   AS TIPO_PROMOCION,
               NVL((
                SELECT AGP.NOMBRE_GRUPO
                    FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDMP,
                         DB_COMERCIAL.ADMI_GRUPO_PROMOCION     AGP
                WHERE IDMP.GRUPO_PROMOCION_ID = AGP.ID_GRUPO_PROMOCION
                  AND IDMP.ID_DETALLE_MAPEO   = IPP.DETALLE_MAPEO_ID
               ),'SIN NOMBRE')  AS NOMBRE_PROMOCION,
               IPP.TIPO_PROCESO AS TIPO_PROCESO,
               TO_CHAR(IPP.FE_INI_MAPEO,'RRRR-MM-DD') AS FECHA_INICIO_MAPEO,
               TO_CHAR(IPP.FE_FIN_MAPEO,'RRRR-MM-DD') AS FECHA_FIN_MAPEO,
               IPP.ESTADO       AS ESTADO_PROCESO,
               IPPH.OBSERVACION AS OBSERVACION
            FROM DB_COMERCIAL.INFO_SERVICIO            ISER,
                 DB_COMERCIAL.INFO_PUNTO               IPUN,
                 DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
                 DB_COMERCIAL.INFO_PERSONA             IPERS,
                 DB_EXTERNO.INFO_PROCESO_PROMO         IPP,
                 DB_EXTERNO.INFO_PROCESO_PROMO_HIST    IPPH
          WHERE ISER.PUNTO_ID        = IPUN.ID_PUNTO
            AND IPUN.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
            AND IPER.PERSONA_ID      = IPERS.ID_PERSONA
            AND ISER.ID_SERVICIO     = IPP.SERVICIO_ID
            AND IPP.ID_PROCESO_PROMO = IPPH.PROCESO_PROMO_ID
            AND UPPER(IPP.ESTADO)    = UPPER(Cv_Estado)
            AND IPPH.ID_PROCESO_PROMO_HIST = (
              SELECT MAX(IPPHMAX.ID_PROCESO_PROMO_HIST)
                  FROM DB_EXTERNO.INFO_PROCESO_PROMO_HIST IPPHMAX
              WHERE IPPHMAX.PROCESO_PROMO_ID = IPP.ID_PROCESO_PROMO
            )
        ) CLIENTES
      ORDER BY TRIM(CLIENTES.CLIENTE)      ASC,
               CLIENTES.FECHA_INICIO_MAPEO ASC,
               CLIENTES.FECHA_FIN_MAPEO    ASC;

    Lc_GetAliasPlantilla  DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
    Lc_CLientesPromocion  C_CLientesPromocion%ROWTYPE;
    Lv_Estado             DB_EXTERNO.INFO_PROCESO_PROMO.ESTADO%TYPE := 'ErrorRda';
    Le_Exception          EXCEPTION;
    Lv_Error              VARCHAR2(4000);
    Lb_TieneDatos         BOOLEAN;

    Lf_Archivo            UTL_FILE.FILE_TYPE;
    Lv_NombreArchivo      VARCHAR2(50)  := 'ReportePromociones_'||to_char(SYSDATE,'RRRRMMDDHH24MISS')||'.csv';
    Lv_NombreDirectorio   VARCHAR2(20)  := 'DIR_REPGERENCIA';
    Lv_RutaDirectorio     VARCHAR2(25)  := '/backup/repgerencia/';
    Lv_Delimitador        VARCHAR2(2)   := ';';
    Lv_Extension          VARCHAR2(4)   := '.gz';
    Lv_ComandoReporte     VARCHAR2(5)   := 'gzip';
    Lv_Remitente          VARCHAR2(30)  := 'sistemas-qa@telconet.ec';
    Lv_Asunto             VARCHAR2(200) := 'NOTIFICACION: REPORTE DE PROCESOS DE PROMOCION (ANCHO DE BANDA)';

  BEGIN

    IF C_CLientesPromocion%ISOPEN THEN
      CLOSE C_CLientesPromocion;
    END IF;

    OPEN C_CLientesPromocion(Lv_Estado);
      FETCH C_CLientesPromocion INTO Lc_CLientesPromocion;
        Lb_TieneDatos := C_CLientesPromocion%FOUND;
    CLOSE C_CLientesPromocion;

    IF Lb_TieneDatos THEN

      Lf_Archivo := UTL_FILE.FOPEN(Lv_NombreDirectorio,Lv_NombreArchivo,'w',32767);

      -- Detalle del Reporte
      UTL_FILE.PUT_LINE(Lf_Archivo,
                       'IDENTIFICACION'     ||Lv_Delimitador
                     ||'CLIENTE'            ||Lv_Delimitador
                     ||'LOGIN'              ||Lv_Delimitador
                     ||'ESTADO SERVICIO'    ||Lv_Delimitador
                     ||'TIPO PROMOCION'     ||Lv_Delimitador
                     ||'NOMBRE PROMOCION'   ||Lv_Delimitador
                     ||'TIPO PROCESO'       ||Lv_Delimitador
                     ||'FECHA INICIO MAPEO' ||Lv_Delimitador
                     ||'FECHA FIN MAPEO'    ||Lv_Delimitador
                     ||'ESTADO PROCESO'     ||Lv_Delimitador
                     ||'OBSERVACION'        ||Lv_Delimitador);

      Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA('NEPPRDA');

      FOR CLIENTES IN C_CLientesPromocion(Lv_Estado) LOOP

        UTL_FILE.PUT_LINE(Lf_Archivo,
                    ''''||CLIENTES.IDENTIFICACION||''''||Lv_Delimitador||
                          CLIENTES.CLIENTE             ||Lv_Delimitador||
                          CLIENTES.PUNTO_LOGIN         ||Lv_Delimitador||
                          CLIENTES.ESTADO_SERVICIO     ||Lv_Delimitador||
                          CLIENTES.TIPO_PROMOCION      ||Lv_Delimitador||
                          DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN(CLIENTES.NOMBRE_PROMOCION)||Lv_Delimitador||
                          CLIENTES.TIPO_PROCESO        ||Lv_Delimitador||
                          CLIENTES.FECHA_INICIO_MAPEO  ||Lv_Delimitador||
                          CLIENTES.FECHA_FIN_MAPEO     ||Lv_Delimitador||
                          CLIENTES.ESTADO_PROCESO      ||Lv_Delimitador||
                          DB_SOPORTE.SPKG_REPORTES.F_GET_VARCHAR_CLEAN(CLIENTES.OBSERVACION)||Lv_Delimitador);

      END LOOP;

      --Cierre del Archivo.
      UTL_FILE.FCLOSE(Lf_Archivo);

      --Ejecución del comando para crear el archivo comprimido.
      DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lv_ComandoReporte||' '||Lv_RutaDirectorio||Lv_NombreArchivo));

      --Envio del archivo por correo
      DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lv_Remitente,
                                                REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',')||',',
                                                Lv_Asunto,
                                                Lc_GetAliasPlantilla.PLANTILLA,
                                                Lv_NombreDirectorio,
                                                Lv_NombreArchivo||Lv_Extension);

      --Eliminación del archivo.
      BEGIN
        UTL_FILE.FREMOVE(Lv_NombreDirectorio,Lv_NombreArchivo||Lv_Extension);
      EXCEPTION
        WHEN OTHERS THEN
          Lv_Error := 'Error al eliminar el archivo: '||Lv_NombreArchivo||' - '||SUBSTR(SQLERRM,0,3000);
          RAISE Le_Exception;
      END;

    END IF;

  EXCEPTION

    WHEN Le_Exception THEN

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW',
                                           'P_NOTIFICA_ERROR_PROCESO_PROMO',
                                            Lv_Error,
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));

    WHEN OTHERS THEN

      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW',
                                           'P_NOTIFICA_ERROR_PROCESO_PROMO',
                                            SQLCODE||' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));

  END P_NOTIFICA_ERROR_PROCESO_PROMO;
----
----
  PROCEDURE P_PM_REACTIVACION_BW IS
    --Costo: 4
    CURSOR C_GetProcesosMasivosCab ( Cv_EstadoProcesoMasivoCab DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE, 
                                     Cv_TipoProceso            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE, 
                                     Cv_EmpresaId              DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.EMPRESA_ID%TYPE )
    IS
      SELECT INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB,
        INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
      WHERE TIPO_PROCESO = Cv_TipoProceso
      AND ESTADO         = Cv_EstadoProcesoMasivoCab
      AND EMPRESA_ID     = Cv_EmpresaId;

    --Costo: 4 
    CURSOR C_GetProcesosMasivosDet ( Cn_IdProcesoMasivoCab     DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB%TYPE, 
                                     Cv_EstadoProcesoMasivoDet DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE )
    IS
      SELECT INFO_PROCESO_MASIVO_DET.ID_PROCESO_MASIVO_DET,
        INFO_PROCESO_MASIVO_DET.PUNTO_ID
      FROM DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET
      WHERE PROCESO_MASIVO_CAB_ID = Cn_IdProcesoMasivoCab
      AND ESTADO                  = Cv_EstadoProcesoMasivoDet;

    Lv_MsjError                     VARCHAR2(500);
    Ln_Valor                        NUMBER;
    Lv_EmpresaId                    DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.EMPRESA_ID%TYPE := '18';
    Lv_TipoPromocion                VARCHAR2(50) := 'PROM_BW';
    Lv_MapeoPromo                   VARCHAR2(50) := 'NO';
    Lv_TeniaPromo                   VARCHAR2(50) := 'NO';
    Lv_AplicaPromo                  VARCHAR2(50) := 'NO';  
    Lv_TipoProceso                  VARCHAR2(50) := 'ReactivacionMasiva';
    Lv_ConfiguraBw                  VARCHAR2(50) := 'NO';
    Lv_MsjResultado                 VARCHAR2(4000);
    Lv_EstadoProceso                VARCHAR2(50) := 'ERROR';
    Lv_UsuarioCreacion              VARCHAR2(15) := 'telcos_promo_bw';
    Lv_TrafficPromo                 VARCHAR2(100);
    Lv_GemportPromo                 VARCHAR2(100);
    Lv_JsonUpdate                   CLOB;
    Lv_LineProfilePromo             VARCHAR2(100);
    Lv_CapacidadUpPromo             VARCHAR2(100);
    Lv_CapacidadDownPromo           VARCHAR2(100);
    Lv_IpCreacion                   VARCHAR2(20) :=  NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1');
    Le_ExcepcionDet                 EXCEPTION;
    Le_ExcepcionCab                 EXCEPTION;
    Ln_IdPlanSuperior               DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.PLAN_ID_SUPERIOR%TYPE := 0;
    Lv_TipoProcesoMasivo            DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.TIPO_PROCESO%TYPE    := 'ReconectarCliente';
    Lv_IdServicioInternet           VARCHAR2(1000);
    Lv_EstadoProcesoMasivoDet       DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_DET.ESTADO%TYPE := 'Pendiente';
    Lv_EstadoPromoProcesoMasivoCab  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB.ESTADO%TYPE := 'PendientePromo';
    Lr_InfoProcesoMasivoCab         DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE;
    Lr_InfoProcesoRDA               DB_COMERCIAL.CMKG_PROMOCIONES_BW.Gr_ProcesoPromo;
    Lr_ParametrosCreaCaract         DB_COMERCIAL.CMKG_PROMOCIONES_BW.Gr_ParametrosCreaCaract;
    --
  BEGIN

    FOR R_GetProcesoMasivoCab IN C_GetProcesosMasivosCab (Lv_EstadoPromoProcesoMasivoCab, Lv_TipoProcesoMasivo, Lv_EmpresaId)

    LOOP

      BEGIN
        --Recuperar información de detalle de procesos masivos
        FOR R_GetProcesoMasivoDet IN C_GetProcesosMasivosDet(R_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB,
                                                             Lv_EstadoProcesoMasivoDet)
        LOOP

          BEGIN

            --Recuperar información del servicio de internet del proceso masivo
            Lv_IdServicioInternet := DB_COMERCIAL.GET_ID_SERVICIO_PREF(R_GetProcesoMasivoDet.PUNTO_ID);

            --Ejecutar proceso de promociones BW
            IF Lv_IdServicioInternet IS NOT NULL THEN

              Ln_Valor          := Lv_IdServicioInternet;
              Lv_MapeoPromo     := 'NO';
              Lv_TeniaPromo     := 'NO';
              Lv_AplicaPromo    := 'NO';
              Lv_ConfiguraBw    := 'NO';
              Lv_EstadoProceso  := 'ERROR';
              Ln_IdPlanSuperior := 0;
              Lv_MsjResultado   := NULL;

              DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PROCESO_MAPEO_PROMOCIONES_BW(  Lv_EmpresaId,
                                                                                Lv_TipoProceso,
                                                                                Ln_Valor,
                                                                                Ln_Valor, 
                                                                                Lv_AplicaPromo,
                                                                                Lv_MapeoPromo,
                                                                                Lv_TeniaPromo,
                                                                                Ln_IdPlanSuperior,
                                                                                Lv_ConfiguraBw,
                                                                                Lv_EstadoProceso );

              IF Lv_EstadoProceso = 'OK' THEN

                IF( 
                    (Lv_AplicaPromo = 'SI' AND Lv_MapeoPromo = 'SI' AND Lv_TeniaPromo = 'SI') OR
                    (Lv_AplicaPromo = 'SI' AND Lv_MapeoPromo = 'SI' AND Lv_TeniaPromo = 'NO') OR
                    (Lv_AplicaPromo = 'SI' AND Lv_MapeoPromo = 'NO' AND Lv_TeniaPromo = 'SI') 
                  ) THEN

                  Lr_ParametrosCreaCaract               := NULL;
                  Lr_ParametrosCreaCaract.ID_PLAN_PROMO := Ln_IdPlanSuperior;
                  Lr_ParametrosCreaCaract.ID_SERVICIO   := Ln_Valor;
                  Lr_ParametrosCreaCaract.COD_EMPRESA   := Lv_EmpresaId;
                  Lr_ParametrosCreaCaract.USUARIO       := Lv_UsuarioCreacion;
                  Lv_MsjResultado                       := NULL;

                  DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_VALIDA_CARACTERISTICAS_PROMO(Lr_ParametrosCreaCaract,
                                                                                  Lv_MsjResultado);

                  IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                    Lv_MsjResultado:= 'Error al crear las caracteristicas promocionales del servicio'
                                      ||' Servicio : '        ||Lv_IdServicioInternet
                                      ||' Tipo Promocional : '||Lv_TipoPromocion
                                      ||' Mensaje: '          ||Lv_MsjResultado;
                    RAISE Le_ExcepcionDet;
                  END IF;

                  COMMIT;

                  IF Lv_ConfiguraBw = 'SI' THEN

                    Lr_InfoProcesoRDA                    := NULL;
                    Lr_InfoProcesoRDA.EMPRESA_COD        := Lv_EmpresaId;
                    Lr_InfoProcesoRDA.SERVICIO_ID        := Lv_IdServicioInternet;
                    Lr_InfoProcesoRDA.DETALLE_MAPEO_ID   := NULL;
                    Lr_InfoProcesoRDA.FE_INI_MAPEO       := SYSDATE;
                    Lr_InfoProcesoRDA.FE_FIN_MAPEO       := ADD_MONTHS(SYSDATE,1);
                    Lr_InfoProcesoRDA.USR_CREACION       := Lv_UsuarioCreacion;
                    Lr_InfoProcesoRDA.IP_CREACION        := Lv_IpCreacion;
                    Lr_InfoProcesoRDA.TIPO_PROCESO       := 'ReactivaPromo';
                    Lr_InfoProcesoRDA.TIPO_PROMO         := Lv_TipoPromocion;
                    Lv_MsjResultado                      := NULL;

                    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PREPARA_DATA_PROCESO_PROMO(Lr_InfoProcesoRDA, Lv_MsjResultado);
                    --
                    IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                      Lv_MsjResultado:= 'Error al procesar el registro de tabla masiva de servicio'
                                        ||' Servicio : '        ||Lv_IdServicioInternet
                                        ||' Tipo Promocional : '||Lv_TipoPromocion
                                        ||' Mensaje: '          ||Lv_MsjResultado;
                      RAISE Le_ExcepcionDet;
                    END IF;

                    COMMIT;

                    Lv_TrafficPromo         :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                Lv_IdServicioInternet,'TRAFFIC-TABLE-PROMO');
                    Lv_GemportPromo         :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                                Lv_IdServicioInternet,'GEM-PORT-PROMO');
                    Lv_LineProfilePromo     :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                               Lv_IdServicioInternet,'LINE-PROFILE-NAME-PROMO');
                    IF Lv_LineProfilePromo IS NULL THEN
                      Lv_LineProfilePromo  :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                              Lv_IdServicioInternet,'PERFIL-PROMO');
                    END IF;
                    Lv_CapacidadUpPromo    :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                               Lv_IdServicioInternet,'CAPACIDAD1-PROMO');
                    Lv_CapacidadDownPromo  :=  DB_COMERCIAL.TECNK_SERVICIOS.GET_VALOR_SERVICIO_PROD_CARACT(
                                               Lv_IdServicioInternet,'CAPACIDAD2-PROMO');
                    Lv_MsjResultado        := NULL;

                    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
                    APEX_JSON.OPEN_OBJECT;
                    APEX_JSON.WRITE('strIpCreacion',    Lv_IpCreacion);
                    APEX_JSON.WRITE('intIdServicio' ,   Lv_IdServicioInternet);
                    APEX_JSON.WRITE('strUsrCreacion',   Lv_UsuarioCreacion);
                    APEX_JSON.WRITE('strTipoProceso',  'AplicaPromo');
                    APEX_JSON.WRITE('strObservacion',  'Actualización de campos promocionales');
                    APEX_JSON.WRITE('strTrafficPromo',  Lv_TrafficPromo);
                    APEX_JSON.WRITE('strGemPortPromo',  Lv_GemportPromo);
                    APEX_JSON.WRITE('strTipoPromocion', Lv_TipoPromocion);
                    APEX_JSON.WRITE('strLineProfilePromo',   Lv_LineProfilePromo);
                    APEX_JSON.WRITE('strCapacidadUpPromo',   Lv_CapacidadUpPromo);
                    APEX_JSON.WRITE('strCapacidadDownPromo', Lv_CapacidadDownPromo);
                    APEX_JSON.CLOSE_OBJECT;
                    Lv_JsonUpdate := APEX_JSON.GET_CLOB_OUTPUT;
                    APEX_JSON.FREE_OUTPUT;
                    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_UPDATE_RDA_PROMOCION( Lv_JsonUpdate,
                                                                             Lv_MsjResultado);
                    IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
                      Lv_MsjResultado:= 'Error al procesar actualización de registros de tabla masiva RDA de servicio'
                                        ||' Servicio : '        ||Lv_IdServicioInternet
                                        ||' Tipo Promocional : '||Lv_TipoPromocion
                                        ||' Mensaje: '          ||Lv_MsjResultado;
                      RAISE Le_ExcepcionDet;
                    END IF;
                    COMMIT;
                  END IF;
                END IF;
              ELSE
                Lv_MsjResultado:= 'Error al procesar el mapeo de promociones de servicio'
                                  ||' Servicio : '        ||Lv_IdServicioInternet
                                  ||' Tipo Promocional : '||Lv_TipoPromocion;
                RAISE Le_ExcepcionDet;
              END IF;
            END IF;

          EXCEPTION
            WHEN Le_ExcepcionDet THEN
              ROLLBACK;
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW', 
                                                   'P_PM_REACTIVACION_BW', 
                                                    SUBSTR(Lv_MsjResultado,0,4000),
                                                   'telcos_promo_bw',
                                                    SYSDATE,
                                                    NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
          END;

        END LOOP;

        Lr_InfoProcesoMasivoCab                       := NULL;
        Lv_MsjResultado                               := NULL;
        Lr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB := R_GetProcesoMasivoCab.ID_PROCESO_MASIVO_CAB;
        Lr_InfoProcesoMasivoCab.ESTADO                := 'Pendiente';

        DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_UPDATE_PM_CABECERA(Lr_InfoProcesoMasivoCab, Lv_MsjResultado);

        IF TRIM(Lv_MsjResultado) IS NOT NULL THEN
          RAISE Le_ExcepcionCab;
        END IF; 

        COMMIT;

      EXCEPTION
        WHEN Le_ExcepcionCab THEN
          ROLLBACK;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW', 
                                               'P_PM_REACTIVACION_BW', 
                                                SUBSTR(Lv_MsjResultado,0,4000),
                                               'telcos_promo_bw',
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
      END;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      Lv_MsjError := SQLCODE || ' -ERROR- ' || SQLERRM ;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PROMOCIONES_BW', 
                                           'P_PM_REACTIVACION_BW', 
                                           'Ocurrio un error general en el proceso, '||SUBSTR(Lv_MsjError,0,3950),
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_PM_REACTIVACION_BW;
----
----
  PROCEDURE P_UPDATE_PM_CABECERA(Pr_InfoProcesoMasivoCab IN  DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB%ROWTYPE,
                                 Pv_MsjResultado         OUT VARCHAR2)
  IS
  BEGIN
    --
    UPDATE DB_INFRAESTRUCTURA.INFO_PROCESO_MASIVO_CAB
      SET INFO_PROCESO_MASIVO_CAB.ESTADO = Pr_InfoProcesoMasivoCab.ESTADO
    WHERE INFO_PROCESO_MASIVO_CAB.ID_PROCESO_MASIVO_CAB = Pr_InfoProcesoMasivoCab.ID_PROCESO_MASIVO_CAB;
  --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MsjResultado := 'Error en P_UPDATE_MAP_SOLIC_TRASLADO - ' || SQLERRM;
  --
  END P_UPDATE_PM_CABECERA;
    ----
    PROCEDURE P_EJECUTAR_PROMOCIONES_BW(Pv_Tipo IN VARCHAR2)
    IS
        --
        Lv_NombreParametro       VARCHAR2(40) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
        Lv_TipoParametrosDatos   VARCHAR2(20) := 'DATOS';
        Lv_TipoParametrosWs      VARCHAR2(20) := 'DATOS WS';
        Lv_ValorDatos            VARCHAR2(20) := 'DATOS';
        Lv_ValorEstados          VARCHAR2(20) := 'ESTADOS';
        Lv_ValorEstadoRegistro   VARCHAR2(20) := 'ESTADO_REGISTRO';
        Lv_ValorRango            VARCHAR2(20) := 'RANGO_MINUTOS';
        Lv_TipoParametroJob      VARCHAR2(40) := 'TIEMPO_MINUTO_INICIO_JOB';
        Lv_ValorFormatoHistorial VARCHAR2(40) := 'FORMATO_HISTORIAL_SERVICIO';
        Lv_TipoPromocion         VARCHAR2(30);
        Lv_TipoClientes          VARCHAR2(30);
        Lv_Url                   VARCHAR2(100);
        Lv_PromoDiaria           VARCHAR2(10);
        Lv_EjecutaComando        VARCHAR2(5);
        Lv_EjecutaConfiguracion  VARCHAR2(5);
        Lv_Opcion                VARCHAR2(40);
        Lv_MensajeOperacion      VARCHAR2(100);
        Ln_RangoMinutoMinimo     NUMBER;
        Ln_RangoMinutoMaximo     NUMBER;
        Lv_EstadoPromocion       VARCHAR2(20);
        Lv_EstadoMapeo           VARCHAR2(20);
        Lv_EstadoProceso         VARCHAR2(20);
        Lv_EstadoRegistradaPromo VARCHAR2(20);
        Lv_EstadoFinalPromocion  VARCHAR2(20);
        Lv_EstadoFinalMapeo      VARCHAR2(20);
        Lv_EstadoFinalProceso    VARCHAR2(20);
        Lv_EstadoServicio        VARCHAR2(20);
        Lv_JobMinuto             VARCHAR2(10);
        Lv_FormatoHistoServicio  VARCHAR2(1000);
        Lv_Tecnologia            VARCHAR2(60);
        Ln_TotalTecnoRegistrada  NUMBER;
        Lv_EjecutoTecnologia     VARCHAR2(5);
        Lv_NombreJobHisto        VARCHAR2(100);
        Lv_FormatoJobHisto       VARCHAR2(60) := 'JOB_HIST_PROM_BW';
        Lv_HistorialTecnologia   VARCHAR2(60) := 'Registro de la tecnología ';
        Lv_MarcaZte              VARCHAR2(30) := 'ZTE';
        Lv_PrefijoEmpresa        VARCHAR2(5)  := 'MD';
        Lv_CodEmpresa            VARCHAR2(5)  := '18';
        Lv_Estado                VARCHAR2(20) := 'Activo';
        Ln_IndxReg               NUMBER;
        Lv_IpElemento            VARCHAR2(20);
        Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
        Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
        Lv_MsjResultado          VARCHAR2(4000);
        Lv_ObservacionPlanes     CLOB;
        Lcl_Mensaje              CLOB;
        Le_MyException           EXCEPTION;
        --
        Lv_GenJson               VARCHAR2(500);
        Ln_CodeRequest           NUMBER;
        Lv_StatusResult          VARCHAR2(10);
        Lv_MsgResult             VARCHAR2(500);
        Lcl_Headers              CLOB;
        Lcl_Planes               CLOB;
        Lcl_Olt                  CLOB;
        Lcl_Request              CLOB;
        Lcl_Response             CLOB;
        Lv_Aplicacion            VARCHAR2(50) := 'application/json';
        --
        CURSOR C_ObtenerParametrosDatos IS
            SELECT VALOR1, VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Lv_TipoParametrosDatos AND ROWNUM = 1;
        --
        CURSOR C_ObtenerParametrosWs IS
            SELECT VALOR1, VALOR2, VALOR3, VALOR4 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Lv_TipoParametrosWs AND ROWNUM = 1;
        --
        CURSOR C_ObtenerParametrosRango IS
            SELECT VALOR2, VALOR3 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Pv_Tipo AND VALOR1 = Lv_ValorRango AND ROWNUM = 1;
        --
        CURSOR C_ObtenerParametros IS
            SELECT VALOR2, OBSERVACION FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Pv_Tipo AND VALOR1 = Lv_ValorDatos AND ROWNUM = 1;
        --
        CURSOR C_ObtenerParametrosEstados IS
            SELECT VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Pv_Tipo AND VALOR1 = Lv_ValorEstados AND ROWNUM = 1;
        --
        CURSOR C_ObtenerParEstadosRegistro IS
            SELECT VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Pv_Tipo AND VALOR1 = Lv_ValorEstadoRegistro AND ROWNUM = 1;
        --
        CURSOR C_GetValidarHistoTecno(Cn_IdPromocion NUMBER, Cv_Tecnologia VARCHAR2) IS
          SELECT 'SI' FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO WHERE GRUPO_PROMOCION_ID = Cn_IdPromocion
            AND OBSERVACION = Lv_HistorialTecnologia||Cv_Tecnologia AND ROWNUM = 1;
        --
        CURSOR C_ObtenerMinutoJob IS
            SELECT VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND VALOR1 = Lv_TipoParametroJob AND ROWNUM = 1;
        --
        CURSOR C_ObtenerFormatoHisto IS
            SELECT VALOR2 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Pv_Tipo AND VALOR1 = Lv_ValorFormatoHistorial AND ROWNUM = 1;
        --
        --
        TYPE R_RegistrosGrupo IS RECORD (
            ID_GRUPO_PROMOCION    DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
            NOMBRE_GRUPO          DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE,
            ESTADO                DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE,
            FE_INICIO             VARCHAR2(20),
            FE_FIN                VARCHAR2(20),
            HORA_INICIO           VARCHAR2(10),
            HORA_FIN              VARCHAR2(10)
        );
        Lr_RegistrosGrupo        R_RegistrosGrupo;
        CURSOR C_ListaGrupoPromo IS
            SELECT AGP.ID_GRUPO_PROMOCION, AGP.NOMBRE_GRUPO, AGP.ESTADO,
                   TO_CHAR(AGP.FE_INICIO_VIGENCIA,'RRRR-MM-DD') FE_INICIO, TO_CHAR(AGP.FE_FIN_VIGENCIA,'RRRR-MM-DD') FE_FIN,
                   TO_CHAR(AGP.FE_INICIO_VIGENCIA, 'HH24:MI') HORA_INICIO, TO_CHAR(AGP.FE_FIN_VIGENCIA, 'HH24:MI') HORA_FIN
            FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION   AGP,
                   DB_COMERCIAL.ADMI_TIPO_PROMOCION  ATP
            WHERE AGP.ID_GRUPO_PROMOCION = ATP.GRUPO_PROMOCION_ID
                  AND (
                     ( Pv_Tipo = 'APLICAR'
                        AND (AGP.FE_INICIO_VIGENCIA - Ln_RangoMinutoMaximo/(60*24)) <= SYSDATE
                        AND (AGP.FE_INICIO_VIGENCIA - Ln_RangoMinutoMinimo/(60*24)) >= SYSDATE )
                     OR
                     ( Pv_Tipo = 'QUITAR'
                        AND (AGP.FE_FIN_VIGENCIA - Ln_RangoMinutoMaximo/(60*24)) <= SYSDATE
                        AND (AGP.FE_FIN_VIGENCIA + Ln_RangoMinutoMinimo/(60*24)) >= SYSDATE )
                  )
                  AND ATP.CODIGO_TIPO_PROMOCION = Lv_TipoPromocion
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa
                  AND AGP.ESTADO IN (Lv_EstadoPromocion,Lv_EstadoRegistradaPromo)
                  AND ATP.ESTADO = Lv_Estado
            GROUP BY AGP.ID_GRUPO_PROMOCION,AGP.NOMBRE_GRUPO,AGP.ESTADO,AGP.FE_INICIO_VIGENCIA,AGP.FE_FIN_VIGENCIA;
        --
        --
        TYPE R_RegistrosGrupoTecnologia IS RECORD (
            TECNOLOGIA DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO.NOMBRE_MARCA_ELEMENTO%TYPE
        );
        Lr_RegistrosGrupoTecnologia  R_RegistrosGrupoTecnologia;
        CURSOR C_ListaGrupoPromoTecnologia(Cn_IdGrupoPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE) IS
            SELECT MAR.NOMBRE_MARCA_ELEMENTO TECNOLOGIA
            FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION           AGP,
                   DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDM,
                   DB_EXTERNO.INFO_PROCESO_PROMO             IPP,
                   DB_INFRAESTRUCTURA.INFO_ELEMENTO          ELE,
                   DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   MOD,
                   DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO    MAR
            WHERE AGP.ID_GRUPO_PROMOCION     = IDM.GRUPO_PROMOCION_ID
                  AND IDM.ID_DETALLE_MAPEO   = IPP.DETALLE_MAPEO_ID
                  AND IPP.NOMBRE_OLT         = ELE.NOMBRE_ELEMENTO
                  AND ELE.MODELO_ELEMENTO_ID = MOD.ID_MODELO_ELEMENTO
                  AND MOD.MARCA_ELEMENTO_ID  = MAR.ID_MARCA_ELEMENTO
                  AND AGP.ID_GRUPO_PROMOCION = Cn_IdGrupoPromocion
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa
                  AND IDM.EMPRESA_COD = Lv_CodEmpresa
                  AND IPP.EMPRESA_COD = Lv_CodEmpresa
                  AND ELE.ESTADO = Lv_Estado
                  AND IDM.ESTADO = Lv_EstadoMapeo
                  AND IPP.ESTADO = Lv_EstadoProceso
            GROUP BY MAR.NOMBRE_MARCA_ELEMENTO;
        --
        --
        TYPE R_RegistrosPlanes IS RECORD (
            PLAN_ACTUAL           VARCHAR2(20),
            PLAN_PROMO            VARCHAR2(20)
        );
        Lr_RegistrosPlanes       R_RegistrosPlanes;
        CURSOR C_ListaPlanesPromo(Cn_IdGrupoPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE) IS
            SELECT DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(PLN.PLAN_ID) AS PLAN_ACTUAL,
                DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(PLN.PLAN_ID_SUPERIOR) AS PLAN_PROMO
            FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION         AGP,
                DB_COMERCIAL.ADMI_TIPO_PROMOCION           TIP,
                DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION PLN
            WHERE AGP.ID_GRUPO_PROMOCION   = TIP.GRUPO_PROMOCION_ID
                AND TIP.ID_TIPO_PROMOCION  = PLN.TIPO_PROMOCION_ID
                AND AGP.ID_GRUPO_PROMOCION = Cn_IdGrupoPromocion
                AND TIP.ESTADO             = Lv_Estado
                AND PLN.ESTADO             = Lv_Estado;
        --
        --
        TYPE R_RegistrosElementos IS RECORD (
            ID_ELEMENTO           DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
            NOMBRE_ELEMENTO       DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
            NOMBRE_MODELO         DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE,
            IP                    DB_INFRAESTRUCTURA.INFO_IP.IP%TYPE
        );
        Lr_RegistrosElementos     R_RegistrosElementos;
        CURSOR C_ListaElementosPromo(Cn_IdGrupoPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE, Cv_Tecnologia VARCHAR2) IS
            SELECT ELE.ID_ELEMENTO, ELE.NOMBRE_ELEMENTO, ELE.NOMBRE_MODELO, IP.IP FROM (
                SELECT ELE.ID_ELEMENTO,ELE.NOMBRE_ELEMENTO,MOD.NOMBRE_MODELO_ELEMENTO AS NOMBRE_MODELO
                FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION           AGP,
                       DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDM,
                       DB_EXTERNO.INFO_PROCESO_PROMO             IPP,
                       DB_INFRAESTRUCTURA.INFO_ELEMENTO          ELE,
                       DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO   MOD,
                       DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO    MAR
                WHERE AGP.ID_GRUPO_PROMOCION = IDM.GRUPO_PROMOCION_ID
                      AND IDM.ID_DETALLE_MAPEO      = IPP.DETALLE_MAPEO_ID
                      AND IPP.NOMBRE_OLT            = ELE.NOMBRE_ELEMENTO
                      AND ELE.MODELO_ELEMENTO_ID    = MOD.ID_MODELO_ELEMENTO
                      AND MOD.MARCA_ELEMENTO_ID     = MAR.ID_MARCA_ELEMENTO
                      AND AGP.ID_GRUPO_PROMOCION    = Cn_IdGrupoPromocion
                      AND MAR.NOMBRE_MARCA_ELEMENTO = Cv_Tecnologia
                      AND AGP.EMPRESA_COD = Lv_CodEmpresa
                      AND IDM.EMPRESA_COD = Lv_CodEmpresa
                      AND IPP.EMPRESA_COD = Lv_CodEmpresa
                      AND ELE.ESTADO = Lv_Estado
                      AND IDM.ESTADO = Lv_EstadoMapeo
                      AND IPP.ESTADO = Lv_EstadoProceso
                GROUP BY ELE.ID_ELEMENTO,ELE.NOMBRE_ELEMENTO,MOD.NOMBRE_MODELO_ELEMENTO
            ) ELE
            INNER JOIN DB_INFRAESTRUCTURA.INFO_IP IP ON IP.ELEMENTO_ID = ELE.ID_ELEMENTO
            WHERE IP.ESTADO = Lv_Estado;
        --
        --
        TYPE T_DataTecnologia IS TABLE OF BOOLEAN INDEX BY VARCHAR2(60);
        Lr_DataTecnologia         T_DataTecnologia;
        --
    BEGIN
        --
        IF C_ObtenerParametrosDatos%ISOPEN THEN
          CLOSE C_ObtenerParametrosDatos;
        END IF;
        --
        --obtengo los datos de parametros
        OPEN C_ObtenerParametrosDatos;
        FETCH C_ObtenerParametrosDatos INTO Lv_TipoPromocion, Lv_TipoClientes;
        CLOSE C_ObtenerParametrosDatos;
        --
        IF Lv_TipoPromocion IS NULL OR Lv_TipoClientes IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        IF C_ObtenerParametrosWs%ISOPEN THEN
          CLOSE C_ObtenerParametrosWs;
        END IF;
        --
        --obtengo los datos de parametros
        OPEN C_ObtenerParametrosWs;
        FETCH C_ObtenerParametrosWs INTO Lv_Url, Lv_PromoDiaria, Lv_EjecutaComando, Lv_EjecutaConfiguracion;
        CLOSE C_ObtenerParametrosWs;
        --
        IF Lv_Url IS NULL OR Lv_PromoDiaria IS NULL OR Lv_EjecutaComando IS NULL OR Lv_EjecutaConfiguracion IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos del ws en los parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF C_ObtenerParametrosRango%ISOPEN THEN
          CLOSE C_ObtenerParametrosRango;
        END IF;
        --
        --obtengo los datos de parametros
        OPEN C_ObtenerParametrosRango;
        FETCH C_ObtenerParametrosRango INTO Ln_RangoMinutoMinimo, Ln_RangoMinutoMaximo;
        CLOSE C_ObtenerParametrosRango;
        --
        IF Ln_RangoMinutoMinimo IS NULL OR Ln_RangoMinutoMaximo IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Pv_Tipo||') de parámetros para los rangos minutos de las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF C_ObtenerParametros%ISOPEN THEN
          CLOSE C_ObtenerParametros;
        END IF;
        --
        --obtengo los datos de parametros
        OPEN C_ObtenerParametros;
        FETCH C_ObtenerParametros INTO Lv_Opcion, Lv_MensajeOperacion;
        CLOSE C_ObtenerParametros;
        --
        IF Lv_Opcion IS NULL OR Lv_MensajeOperacion IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Pv_Tipo||') de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF C_ObtenerParametrosEstados%ISOPEN THEN
          CLOSE C_ObtenerParametrosEstados;
        END IF;
        --
        --obtengo los datos de parametros
        OPEN C_ObtenerParametrosEstados;
        FETCH C_ObtenerParametrosEstados INTO Lv_EstadoPromocion, Lv_EstadoMapeo, Lv_EstadoProceso, Lv_EstadoFinalPromocion, Lv_EstadoFinalMapeo, Lv_EstadoFinalProceso;
        CLOSE C_ObtenerParametrosEstados;
        --
        IF Lv_EstadoPromocion IS NULL OR Lv_EstadoMapeo IS NULL OR Lv_EstadoProceso IS NULL
          OR Lv_EstadoFinalPromocion IS NULL OR Lv_EstadoFinalMapeo IS NULL OR Lv_EstadoFinalProceso IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Pv_Tipo||') de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF C_ObtenerParEstadosRegistro%ISOPEN THEN
          CLOSE C_ObtenerParEstadosRegistro;
        END IF;
        --
        --obtengo los estados de parametros
        OPEN C_ObtenerParEstadosRegistro;
        FETCH C_ObtenerParEstadosRegistro INTO Lv_EstadoRegistradaPromo;
        CLOSE C_ObtenerParEstadosRegistro;
        --
        IF Pv_Tipo = 'APLICAR' AND Lv_EstadoRegistradaPromo IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Pv_Tipo||') de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF C_ObtenerMinutoJob%ISOPEN THEN
          CLOSE C_ObtenerMinutoJob;
        END IF;
        --
        --obtengo los estados de parametros
        OPEN C_ObtenerMinutoJob;
        FETCH C_ObtenerMinutoJob INTO Lv_JobMinuto;
        CLOSE C_ObtenerMinutoJob;
        --
        IF Lv_JobMinuto IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos para el tiempo de inicio del job para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF C_ObtenerFormatoHisto%ISOPEN THEN
          CLOSE C_ObtenerFormatoHisto;
        END IF;
        --
        --obtengo los estados de parametros
        OPEN C_ObtenerFormatoHisto;
        FETCH C_ObtenerFormatoHisto INTO Lv_FormatoHistoServicio;
        CLOSE C_ObtenerFormatoHisto;
        --
        IF Lv_FormatoHistoServicio IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Pv_Tipo||') de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        -- CREO EL JSON HEADERS
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('headers');
        APEX_JSON.WRITE('Content-Type', Lv_Aplicacion);
        APEX_JSON.WRITE('Accept', Lv_Aplicacion);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
        --
        FOR Lr_RegistrosGrupo IN C_ListaGrupoPromo
        LOOP
            --
            IF Pv_Tipo = 'APLICAR' AND Lr_RegistrosGrupo.ESTADO = Lv_EstadoPromocion THEN
                --se generan los detalles y los procesos de la promoción
                Lcl_Mensaje := 'OK';
                WHILE Lcl_Mensaje = 'OK' LOOP
                    DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PROCESO_MASIVO_BW(Lv_TipoClientes,Lr_RegistrosGrupo.ID_GRUPO_PROMOCION,Lv_EstadoPromocion,Lcl_Mensaje);
                END LOOP;
                --gerarar los detalles para los olt sin servicios
                DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PREPARE_OLT_PROMOCION_BW(Lr_RegistrosGrupo.ID_GRUPO_PROMOCION);
                --
                --actualizar estado
                Lr_RegistrosGrupo.ESTADO := Lv_EstadoRegistradaPromo;
                UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION SET ESTADO = Lv_EstadoRegistradaPromo WHERE ID_GRUPO_PROMOCION = Lr_RegistrosGrupo.ID_GRUPO_PROMOCION;
                --se guarda los cambios
                COMMIT;
            END IF;
            --
            IF Pv_Tipo = 'APLICAR' AND Lr_RegistrosGrupo.ESTADO = Lv_EstadoRegistradaPromo THEN
                --
                Lcl_Planes := NULL;
                --
                IF C_ListaPlanesPromo%ISOPEN THEN
                  CLOSE C_ListaPlanesPromo;
                END IF;
                --
                FOR Lr_RegistrosPlanes IN C_ListaPlanesPromo(Lr_RegistrosGrupo.ID_GRUPO_PROMOCION)
                LOOP
                    --
                    Lv_GenJson := '{"plan":"'||Lr_RegistrosPlanes.PLAN_ACTUAL||'","plan_promo":"'||Lr_RegistrosPlanes.PLAN_PROMO||'"}';
                    IF Lcl_Planes IS NULL THEN
                        Lcl_Planes := Lv_GenJson;
                    ELSE
                        Lcl_Planes := Lcl_Planes || ',' || Lv_GenJson;
                    END IF;
                    --
                END LOOP;
                --
                IF C_ListaPlanesPromo%ISOPEN THEN
                  CLOSE C_ListaPlanesPromo;
                END IF;
                --
                IF C_ListaGrupoPromoTecnologia%ISOPEN THEN
                  CLOSE C_ListaGrupoPromoTecnologia;
                END IF;
                --
                FOR Lr_RegistrosGrupoTecnologia IN C_ListaGrupoPromoTecnologia(Lr_RegistrosGrupo.ID_GRUPO_PROMOCION)
                LOOP
                    --
                    Lv_EjecutoTecnologia := NULL;
                    OPEN C_GetValidarHistoTecno(Lr_RegistrosGrupo.ID_GRUPO_PROMOCION,Lr_RegistrosGrupoTecnologia.TECNOLOGIA);
                    FETCH C_GetValidarHistoTecno INTO Lv_EjecutoTecnologia;
                    CLOSE C_GetValidarHistoTecno;
                    --
                    IF Lv_EjecutoTecnologia IS NULL THEN
                        --
                        Lcl_Olt := NULL;
                        --
                        IF C_ListaElementosPromo%ISOPEN THEN
                          CLOSE C_ListaElementosPromo;
                        END IF;
                        --
                        FOR Lr_RegistrosElementos IN C_ListaElementosPromo(Lr_RegistrosGrupo.ID_GRUPO_PROMOCION,Lr_RegistrosGrupoTecnologia.TECNOLOGIA)
                        LOOP
                            --
                            IF Lr_RegistrosGrupoTecnologia.TECNOLOGIA = Lv_MarcaZte THEN
                                Lv_GenJson := '{"nombre_olt":"'||Lr_RegistrosElementos.NOMBRE_ELEMENTO||'","modelo_olt":"'||Lr_RegistrosElementos.NOMBRE_MODELO
                                              ||'","ip_olt":"'||Lr_RegistrosElementos.IP||'"}';
                            ELSE
                                Lv_GenJson := '{"nombre_olt":"'||Lr_RegistrosElementos.NOMBRE_ELEMENTO||'","ip_olt":"'||Lr_RegistrosElementos.IP||'"}';
                            END IF;
                            --
                            IF Lcl_Olt IS NULL THEN
                                Lcl_Olt := Lv_GenJson;
                            ELSE
                                Lcl_Olt := Lcl_Olt || ',' || Lv_GenJson;
                            END IF;
                        END LOOP;
                        --
                        IF C_ListaElementosPromo%ISOPEN THEN
                          CLOSE C_ListaElementosPromo;
                        END IF;
                        --
                        Lcl_Request   := '{
                                                "id_promo": "' || Lr_RegistrosGrupo.ID_GRUPO_PROMOCION || '",
                                                "nombre_promo": "' || Lr_RegistrosGrupo.NOMBRE_GRUPO || '",
                                                "fecha_inicio": "' || Lr_RegistrosGrupo.FE_INICIO || '",
                                                "fecha_fin": "' || Lr_RegistrosGrupo.FE_FIN || '",
                                                "hora_inicio": "' || Lr_RegistrosGrupo.HORA_INICIO || '",
                                                "hora_fin": "' || Lr_RegistrosGrupo.HORA_FIN || '",
                                                "promo_diaria": "' || Lv_PromoDiaria || '",
                                                "tecnologia": "' || Lr_RegistrosGrupoTecnologia.TECNOLOGIA || '",
                                                "datos": {
                                                  "plan":[' || Lcl_Planes || '],
                                                  "olt":[' || Lcl_Olt || ']
                                                },
                                                "opcion": "' || Lv_Opcion || '",
                                                "ejecutaComando": "' || Lv_EjecutaComando || '",
                                                "usrCreacion": "' || Lv_User || '",
                                                "ipCreacion": "' || Lv_Ip || '",
                                                "comandoConfiguracion": "' || Lv_EjecutaConfiguracion || '",
                                                "empresa": "' || Lv_PrefijoEmpresa || '"
                                          }';
                        Lcl_Request := REPLACE(Lcl_Request, chr(13)||chr(10), '');
                        Lcl_Request := REPLACE(Lcl_Request, chr(9), '');
                        --ejecuto el request
                        Lv_StatusResult := 'ERROR';
                        Lv_MsgResult    := 'Problemas al ejecutar el Ws de Rda para ejecutar las promociones de ancho de banda.';
                        DB_GENERAL.GNKG_WEB_SERVICE.P_POST(Lv_Url,Lcl_Headers,Lcl_Request,Ln_CodeRequest,Lv_MsgResult,Lcl_Response);
                        IF Ln_CodeRequest = 0 AND INSTR(Lcl_Response, 'status') != 0 AND INSTR(Lcl_Response, 'mensaje') != 0 THEN
                            APEX_JSON.PARSE(Lcl_Response);
                            Lv_StatusResult := APEX_JSON.GET_VARCHAR2(p_path => 'status');
                            Lv_MsgResult    := APEX_JSON.GET_VARCHAR2(p_path => 'mensaje');
                        END IF;
                        --
                        IF Lv_StatusResult = 'OK' THEN
                            --
                            Lr_DataTecnologia(Lr_RegistrosGrupoTecnologia.TECNOLOGIA) := TRUE;
                            --ingresar historial
                            INSERT INTO DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
                            ( ID_GRUPO_PROMOCION_HISTO,GRUPO_PROMOCION_ID,MOTIVO_ID,ESTADO,OBSERVACION,USR_CREACION,FE_CREACION,IP_CREACION )
                            VALUES
                            ( DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL,Lr_RegistrosGrupo.ID_GRUPO_PROMOCION,NULL,Lr_RegistrosGrupo.ESTADO,
                              Lv_HistorialTecnologia||Lr_RegistrosGrupoTecnologia.TECNOLOGIA,Lv_User,SYSDATE,Lv_Ip );
                            --
                            --se guarda los cambios
                            COMMIT;
                        ELSE
                            --
                            Lr_DataTecnologia(Lr_RegistrosGrupoTecnologia.TECNOLOGIA) := FALSE;
                            --ingresar historial
                            INSERT INTO DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
                            ( ID_GRUPO_PROMOCION_HISTO,GRUPO_PROMOCION_ID,MOTIVO_ID,ESTADO,OBSERVACION,USR_CREACION,FE_CREACION,IP_CREACION )
                            VALUES
                            ( DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL,Lr_RegistrosGrupo.ID_GRUPO_PROMOCION,NULL,Lr_RegistrosGrupo.ESTADO,
                              'Error en la petición de la tecnología '||Lr_RegistrosGrupoTecnologia.TECNOLOGIA||': '||
                              Lv_MsgResult,Lv_User,SYSDATE,Lv_Ip );
                            --
                            --se guardan los cambios
                            COMMIT;
                        END IF;
                    END IF;
                END LOOP;
                --
                IF C_ListaGrupoPromoTecnologia%ISOPEN THEN
                  CLOSE C_ListaGrupoPromoTecnologia;
                END IF;
                --
                --se recorre la data de los elementos
                Ln_TotalTecnoRegistrada := 0;
                Lv_Tecnologia := Lr_DataTecnologia.FIRST;
                WHILE Lv_Tecnologia IS NOT NULL LOOP
                    IF Lr_DataTecnologia(Lv_Tecnologia) THEN
                        Ln_TotalTecnoRegistrada := Ln_TotalTecnoRegistrada + 1;
                        --actualizar estado proceso
                        UPDATE DB_EXTERNO.INFO_PROCESO_PROMO
                        SET ESTADO = Lv_EstadoFinalProceso
                        WHERE ID_PROCESO_PROMO IN (
                            SELECT IPP.ID_PROCESO_PROMO FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
                            WHERE IPP.DETALLE_MAPEO_ID IN (
                                SELECT ID_DETALLE_MAPEO FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO
                                WHERE GRUPO_PROMOCION_ID = Lr_RegistrosGrupo.ID_GRUPO_PROMOCION)
                            AND EXISTS (
                                SELECT 1
                                FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO       ELE,
                                    DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD,
                                    DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO  MAR
                                WHERE IPP.NOMBRE_OLT              = ELE.NOMBRE_ELEMENTO
                                    AND ELE.MODELO_ELEMENTO_ID    = MOD.ID_MODELO_ELEMENTO
                                    AND MOD.MARCA_ELEMENTO_ID     = MAR.ID_MARCA_ELEMENTO
                                    AND MAR.NOMBRE_MARCA_ELEMENTO = Lv_Tecnologia
                                    AND ELE.ESTADO = Lv_Estado)
                            AND IPP.ESTADO = Lv_EstadoProceso
                        );
                        --se guardan los cambios
                        COMMIT;
                        --
                        --inicio de tarea programada
                        Lv_NombreJobHisto := Lv_FormatoJobHisto||'_'||SUBSTR(Pv_Tipo, 0, 3)||'_'||Lr_RegistrosGrupo.ID_GRUPO_PROMOCION||'_'||
                                             SUBSTR(Lv_Tecnologia, 0, 1);
                        DBMS_SCHEDULER.CREATE_JOB (
                            job_name => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                            job_type => 'STORED_PROCEDURE',
                            job_action => 'DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_HISTO_CLIENTE_PROMO_BW',
                            number_of_arguments => 6,
                            start_date => systimestamp + NUMTODSINTERVAL(Lv_JobMinuto,'MINUTE'),
                            end_date => NULL,
                            enabled => FALSE,
                            auto_drop => TRUE,
                            comments => 'Tarea que se ejecuta para generar los historiales de los servicios con promociones.');
                        DBMS_SCHEDULER.SET_ATTRIBUTE(
                            name => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                            attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
                        --setear id de la promocion
                        DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                           job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                           argument_position       => 1,
                           argument_value          => Lr_RegistrosGrupo.ID_GRUPO_PROMOCION);
                        --setear tipo
                        DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                           job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                           argument_position       => 2,
                           argument_value          => Pv_Tipo);
                        --setear formato historial servicio
                        DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                           job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                           argument_position       => 3,
                           argument_value          => Lv_FormatoHistoServicio);
                        --setear historial del proceso
                        DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                           job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                           argument_position       => 4,
                           argument_value          => Lv_MensajeOperacion);
                        --setear estado del proceso
                        DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                           job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                           argument_position       => 5,
                           argument_value          => Lv_EstadoFinalProceso);
                        --setear tecnologia
                        DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                           job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                           argument_position       => 6,
                           argument_value          => Lv_Tecnologia);
                        --habilitar job
                        DBMS_SCHEDULER.ENABLE('"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"');
                        --
                    END IF;
                    --obtengo la siguiente llave
                    Lv_Tecnologia := Lr_DataTecnologia.NEXT(Lv_Tecnologia);
                END LOOP;
                --
                --verificar registros totales
                IF Ln_TotalTecnoRegistrada > 0 AND Ln_TotalTecnoRegistrada = Lr_DataTecnologia.count THEN
                    --actualizar estado
                    UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION SET ESTADO = Lv_EstadoFinalPromocion
                    WHERE ID_GRUPO_PROMOCION = Lr_RegistrosGrupo.ID_GRUPO_PROMOCION;
                    --se guardan los cambios
                    COMMIT;
                END IF;
            ELSIF Pv_Tipo = 'QUITAR' THEN
                --actualizar estado
                UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION SET ESTADO = Lv_EstadoFinalPromocion
                WHERE ID_GRUPO_PROMOCION = Lr_RegistrosGrupo.ID_GRUPO_PROMOCION;
                --actualizar estado proceso
                UPDATE DB_EXTERNO.INFO_PROCESO_PROMO
                SET ESTADO = Lv_EstadoFinalProceso
                WHERE DETALLE_MAPEO_ID IN (SELECT ID_DETALLE_MAPEO FROM DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO
                    WHERE GRUPO_PROMOCION_ID = Lr_RegistrosGrupo.ID_GRUPO_PROMOCION)
                AND ESTADO = Lv_EstadoProceso;
                --se guardan los cambios
                COMMIT;
                --
                --inicio de tarea programada
                Lv_NombreJobHisto := Lv_FormatoJobHisto||'_'||Pv_Tipo||'_'||Lr_RegistrosGrupo.ID_GRUPO_PROMOCION;
                DBMS_SCHEDULER.CREATE_JOB (
                    job_name => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                    job_type => 'STORED_PROCEDURE',
                    job_action => 'DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_HISTO_CLIENTE_PROMO_BW',
                    number_of_arguments => 6,
                    start_date => systimestamp + NUMTODSINTERVAL(Lv_JobMinuto,'MINUTE'),
                    end_date => NULL,
                    enabled => FALSE,
                    auto_drop => TRUE,
                    comments => 'Tarea que se ejecuta para generar los historiales de los servicios con promociones.');
                DBMS_SCHEDULER.SET_ATTRIBUTE(
                    name => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                    attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
                --setear id de la promocion
                DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                   job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                   argument_position       => 1,
                   argument_value          => Lr_RegistrosGrupo.ID_GRUPO_PROMOCION);
                --setear tipo
                DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                   job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                   argument_position       => 2,
                   argument_value          => Pv_Tipo);
                --setear formato historial servicio
                DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                   job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                   argument_position       => 3,
                   argument_value          => Lv_FormatoHistoServicio);
                --setear historial del proceso
                DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                   job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                   argument_position       => 4,
                   argument_value          => Lv_MensajeOperacion);
                --setear estado del proceso
                DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                   job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                   argument_position       => 5,
                   argument_value          => Lv_EstadoFinalProceso);
                --setear tecnologia
                DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
                    job_name                => '"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"',
                    argument_position       => 6,
                    argument_value          => NULL);
                --habilitar job
                DBMS_SCHEDULER.ENABLE('"DB_COMERCIAL"."'||Lv_NombreJobHisto||'"');
            END IF;
        END LOOP;
        --
        IF C_ListaGrupoPromo%ISOPEN THEN
          CLOSE C_ListaGrupoPromo;
        END IF;
        --
        --
        EXCEPTION
        WHEN Le_MyException THEN
            --
            --se reservan los cambios
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_EJECUTAR_PROMOCIONES_BW',
                                                 SUBSTR(Lv_MsjResultado,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
        WHEN OTHERS THEN
            --
            --se reservan los cambios
            ROLLBACK;
            Lv_MsjResultado := 'Ocurrió un error al ejecutar las promociones de ancho de banda: ';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_EJECUTAR_PROMOCIONES_BW',
                                                 SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
    END P_EJECUTAR_PROMOCIONES_BW;
    ----
    ----
    PROCEDURE P_PROCESAR_PROMOCIONES_BW(Pcl_JsonRespuesta IN CLOB, 
                                        Pv_Status         OUT VARCHAR2, 
                                        Pv_Mensaje        OUT VARCHAR2)
    IS
        --
        Lv_Tipo                  VARCHAR2(30);
        Lv_IdPromocion           VARCHAR2(30);
        Ln_CountElementos        NUMBER;
        Ln_VerificarPromocion    NUMBER;
        Ln_IdSolicitud           NUMBER;
        Ln_IdDocumento           NUMBER;
        Lv_EstadoPromo           VARCHAR2(60);
        Lv_NombreJob             VARCHAR2(100);
        Lv_Tecnologia            VARCHAR2(60);
        Lv_HistorialPromo        VARCHAR2(100) := 'Se agrego un documento a la promoción:';
        Lv_FormatoJob            VARCHAR2(30) := 'JOB_PROCESAR_PROMO_BW';
        Lv_JobMinuto             VARCHAR2(5)  := '3';
        Lv_TipoSolicitud         VARCHAR2(100) := 'SOLICITUD PROCESAR PROMOCIONES BW MASIVO';
        Lv_CaractPromocion       VARCHAR2(60) := 'ID_GRUPO_PROMOCION';
        Lv_CaractDocumento       VARCHAR2(60) := 'ID_DOCUMENTO';
        Lv_EstadoActivo          VARCHAR2(20) := 'Activo';
        Lv_EstadoPendiente       VARCHAR2(20) := 'Pendiente';
        Lv_CodEmpresa            VARCHAR2(5)  := '18';
        Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
        Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
        Lv_MsjResultado          VARCHAR2(4000);
        Lv_MsgResult             VARCHAR2(500);
        Le_MyException           EXCEPTION;
        --
        CURSOR C_VerificarPromocion IS
            SELECT 1 FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP
            WHERE AGP.ID_GRUPO_PROMOCION = Lv_IdPromocion
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa;
        --
        CURSOR C_ObtenerDatos IS
            SELECT ESTADO FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP
            WHERE AGP.ID_GRUPO_PROMOCION = Lv_IdPromocion
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa;
        --
    BEGIN
        --
        IF INSTR(Pcl_JsonRespuesta, 'opcion') = 0 OR INSTR(Pcl_JsonRespuesta, 'id_promo') = 0 OR INSTR(Pcl_JsonRespuesta, 'elemento') = 0 THEN
            Lv_MsjResultado := 'Error en el json de respuesta del rda middleware.';
            RAISE Le_MyException;
        END IF;
        APEX_JSON.PARSE(Pcl_JsonRespuesta);
        Lv_Tipo           := APEX_JSON.GET_VARCHAR2(p_path => 'opcion');
        Lv_IdPromocion    := APEX_JSON.GET_VARCHAR2(p_path => 'id_promo');
        Ln_CountElementos := APEX_JSON.GET_COUNT(P_PATH => 'elemento');
        Lv_Tecnologia     := APEX_JSON.GET_VARCHAR2(p_path => 'tecnologia');
        --
        --verificar la opción de ejecución
        IF Lv_Tipo IS NULL THEN
            Lv_MsjResultado := 'Error no se pudo obtener la opción de la promoción de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --verificar el id de la promoción
        IF Lv_IdPromocion IS NULL THEN
            Lv_MsjResultado := 'Error no se pudo obtener el id de la promoción de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --verificar la cantidad de elementos de la promoción
        IF Ln_CountElementos <= 0 THEN
            Lv_MsjResultado := 'Error la cantidad de elementos a procesar es de 0 en la promoción de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        IF C_VerificarPromocion%ISOPEN THEN
          CLOSE C_VerificarPromocion;
        END IF;
        --verfico la promocion
        OPEN C_VerificarPromocion;
        FETCH C_VerificarPromocion INTO Ln_VerificarPromocion;
        CLOSE C_VerificarPromocion;
        IF Ln_VerificarPromocion IS NULL THEN
            Lv_MsjResultado := 'Error no se pudo obtener la promoción de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --obtener datos
        OPEN C_ObtenerDatos;
        FETCH C_ObtenerDatos INTO Lv_EstadoPromo;
        CLOSE C_ObtenerDatos;
        IF Lv_EstadoPromo IS NULL THEN
            Lv_MsjResultado := 'Error no se pudo obtener los datos de la promoción de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --ingresar json en la info documento
        INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO (ID_DOCUMENTO,MENSAJE,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION) 
        VALUES (DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL,Pcl_JsonRespuesta,Lv_EstadoActivo,Lv_User,SYSDATE,Lv_Ip)
        RETURNING ID_DOCUMENTO INTO Ln_IdDocumento;
        --ingreso la solicitud para el proceso masivo
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD
        ( ID_DETALLE_SOLICITUD,TIPO_SOLICITUD_ID,ESTADO,USR_CREACION,FE_CREACION )
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.NEXTVAL,
            ( SELECT ID_TIPO_SOLICITUD FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD
              WHERE DESCRIPCION_SOLICITUD = Lv_TipoSolicitud AND ESTADO = Lv_EstadoActivo AND ROWNUM = 1 ),
            Lv_EstadoPendiente,
            Lv_User,
            SYSDATE
        ) RETURNING ID_DETALLE_SOLICITUD INTO Ln_IdSolicitud;
        --ingreso el historial de la solicitud
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
        ( ID_SOLICITUD_HISTORIAL,DETALLE_SOLICITUD_ID,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION )
        VALUES
        ( DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,Ln_IdSolicitud,Lv_EstadoPendiente,Lv_User,SYSDATE,Lv_Ip );
        --ingreso la caracteristica del id de la promocion
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
        ( ID_SOLICITUD_CARACTERISTICA,DETALLE_SOLICITUD_ID,CARACTERISTICA_ID,VALOR,ESTADO,USR_CREACION,FE_CREACION )
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL,
            Ln_IdSolicitud,
            ( SELECT ID_CARACTERISTICA FROM DB_COMERCIAL.ADMI_CARACTERISTICA
              WHERE DESCRIPCION_CARACTERISTICA = Lv_CaractPromocion AND ESTADO = Lv_EstadoActivo AND ROWNUM = 1 ),
            Lv_IdPromocion,
            Lv_EstadoPendiente,
            Lv_User,
            SYSDATE
        );
        --ingreso la caracteristica del id del documento
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
        ( ID_SOLICITUD_CARACTERISTICA,DETALLE_SOLICITUD_ID,CARACTERISTICA_ID,VALOR,ESTADO,USR_CREACION,FE_CREACION )
        VALUES
        (
            DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.NEXTVAL,
            Ln_IdSolicitud,
            ( SELECT ID_CARACTERISTICA FROM DB_COMERCIAL.ADMI_CARACTERISTICA
              WHERE DESCRIPCION_CARACTERISTICA = Lv_CaractDocumento AND ESTADO = Lv_EstadoActivo AND ROWNUM = 1 ),
            Ln_IdDocumento,
            Lv_EstadoPendiente,
            Lv_User,
            SYSDATE
        );
        --ingresar historial de la promocion
        INSERT INTO DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
        ( ID_GRUPO_PROMOCION_HISTO,GRUPO_PROMOCION_ID,MOTIVO_ID,ESTADO,OBSERVACION,USR_CREACION,FE_CREACION,IP_CREACION )
        VALUES
        ( DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL,Lv_IdPromocion,NULL,Lv_EstadoPromo,
          Lv_HistorialPromo||'<br>TIPO PROCESO: '||Lv_Tipo||'<br>ID DOCUMENTO: '||Ln_IdDocumento,Lv_User,SYSDATE,Lv_Ip );
        --inicio de tarea programada
        Lv_NombreJob := Lv_FormatoJob||'_'||SUBSTR(Lv_Tecnologia, 0, 1)||'_'||Lv_IdPromocion;
        DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"DB_COMERCIAL"."'||Lv_NombreJob||'"',
            job_type => 'STORED_PROCEDURE',
            job_action => 'DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PROCESAR_REG_PROMO_BW',
            number_of_arguments => 1,
            start_date => systimestamp + NUMTODSINTERVAL(Lv_JobMinuto,'MINUTE'),
            end_date => NULL,
            enabled => FALSE,
            auto_drop => TRUE,
            comments => 'Tarea que se ejecuta para procesar las promociones de ancho de banda.');
        DBMS_SCHEDULER.SET_ATTRIBUTE(
            name => '"DB_COMERCIAL"."'||Lv_NombreJob||'"',
            attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
        --setear id de la promocion
        DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE(
            job_name                => '"DB_COMERCIAL"."'||Lv_NombreJob||'"',
            argument_position       => 1,
            argument_value          => Ln_IdSolicitud);
        --habilitar job
        DBMS_SCHEDULER.ENABLE('"DB_COMERCIAL"."'||Lv_NombreJob||'"');
        --
        --guardar cambios
        COMMIT;
        --
        Pv_Status  := 'OK';
        Pv_Mensaje := 'Se está realizando el procesamiento de las promociones.';
        --
      EXCEPTION
        WHEN Le_MyException THEN
            --
            --se reservan los cambios
            ROLLBACK;
            Pv_Status  := 'ERROR';
            Pv_Mensaje := Lv_MsjResultado;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_PROCESAR_PROMOCIONES_BW',
                                                 SUBSTR(Lv_MsjResultado,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
        WHEN OTHERS THEN
            --
            --se reservan los cambios
            ROLLBACK;
            Pv_Status  := 'ERROR';
            Pv_Mensaje := 'Error en el proceso de ejecución de la promoción de ancho de banda.';
            Lv_MsjResultado := 'Ocurrió un error al ejecutar las promociones de ancho de banda: ';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_PROCESAR_PROMOCIONES_BW',
                                                 SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
    END P_PROCESAR_PROMOCIONES_BW;
----
    PROCEDURE P_NOTIFICA_PROMOCIONES_BW(Pv_Tipo IN VARCHAR2) IS
        --
        Lv_NombreParametro       VARCHAR2(40) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
        Lv_TipoParametro         VARCHAR2(20) := 'REPORTE_BW';
        Lv_TipoDatos             VARCHAR2(20) := 'DATOS';
        Lv_Estado                VARCHAR2(20) := 'Activo';
        Lv_EstadoBaja            VARCHAR2(20) := 'Baja';
        Lv_TipoPromocion         VARCHAR2(30);
        Lv_EstadoPromocion       VARCHAR2(50);
        Lv_EstadoPromocionFinal  VARCHAR2(50);
        Lv_EstadoProceso         VARCHAR2(50);
        Lv_EstadoError           VARCHAR2(50);
        Lv_TipoPlantilla         VARCHAR2(50);
        Lv_Remitente             VARCHAR2(50);
        Lv_Asunto                VARCHAR2(200);
        Lv_HistoPromocion        VARCHAR2(200);
        Ln_RangoMinutoMinimo     NUMBER;
        Ln_RangoMinutoMaximo     NUMBER;
        Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
        Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
        Lv_CodEmpresa            VARCHAR2(10) := '18';
        --
        CURSOR C_ObtenerParametrosDatos IS
            SELECT VALOR2, VALOR3, VALOR4, VALOR5 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Lv_TipoParametro AND VALOR1 = Lv_TipoDatos AND ROWNUM = 1;
        --
        CURSOR C_ObtenerParametros IS
            SELECT VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7, OBSERVACION FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Lv_TipoParametro AND VALOR1 = Pv_Tipo AND ROWNUM = 1;
        --
        TYPE R_RegistrosPromocion IS RECORD (
            ID_GRUPO_PROMOCION  DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE,
            NOMBRE_GRUPO        DB_COMERCIAL.ADMI_GRUPO_PROMOCION.NOMBRE_GRUPO%TYPE,
            ESTADO              DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ESTADO%TYPE
        );
        Lr_RegistrosPromocion    R_RegistrosPromocion;
        CURSOR C_Promocion IS
            SELECT AGP.ID_GRUPO_PROMOCION, AGP.NOMBRE_GRUPO, AGP.ESTADO
            FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION   AGP,
                   DB_COMERCIAL.ADMI_TIPO_PROMOCION  ATP
            WHERE AGP.ID_GRUPO_PROMOCION        = ATP.GRUPO_PROMOCION_ID
                  AND ATP.CODIGO_TIPO_PROMOCION = Lv_TipoPromocion
                  AND ( AGP.ESTADO = Lv_EstadoPromocion OR AGP.ESTADO = Lv_EstadoPromocionFinal )
                  AND (
                        ( Pv_Tipo = 'APLICAR' 
                            AND (AGP.FE_INICIO_VIGENCIA + Ln_RangoMinutoMaximo/(60*24)) >= SYSDATE
                            AND (AGP.FE_INICIO_VIGENCIA + Ln_RangoMinutoMinimo/(60*24)) <= SYSDATE
                        ) OR ( Pv_Tipo = 'QUITAR' 
                            AND (AGP.FE_FIN_VIGENCIA + Ln_RangoMinutoMaximo/(60*24)) >= SYSDATE
                            AND (AGP.FE_FIN_VIGENCIA + Ln_RangoMinutoMinimo/(60*24)) <= SYSDATE
                        )
                    )
                  AND NOT EXISTS (
                    SELECT ID_GRUPO_PROMOCION_HISTO
                    FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
                    WHERE USR_CREACION = Lv_User
                    AND GRUPO_PROMOCION_ID = AGP.ID_GRUPO_PROMOCION
                    AND DBMS_LOB.INSTR( OBSERVACION, Lv_HistoPromocion ) > 0
                  )
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa
            GROUP BY AGP.ID_GRUPO_PROMOCION, AGP.NOMBRE_GRUPO;
        --
        TYPE R_RegistrosElementos IS RECORD (
            NOMBRE_OLT      VARCHAR2(100),
            PLAN_ACTUAL     VARCHAR2(50),
            PLAN_PROMO      VARCHAR2(50),
            ESTADO          VARCHAR2(50),
            OBSERVACION     VARCHAR2(1000)
        );
        Lr_RegistrosElementos    R_RegistrosElementos;
        CURSOR C_ElementosPromocion(Cn_IdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE) IS
            SELECT NOMBRE_OLT, PLAN_ACTUAL, PLAN_PROMO, ESTADO, OBSERVACION FROM (
                SELECT IPP.NOMBRE_OLT, PLA.NOMBRE_PLAN PLAN_ACTUAL, PLN.NOMBRE_PLAN PLAN_PROMO,
                      ( CASE WHEN IPP.ESTADO = Lv_EstadoProceso OR ( Pv_Tipo = 'APLICAR' AND IPP.ESTADO = Lv_EstadoBaja ) 
                          THEN 'CONFIRMADO' ELSE 'NO CONFIRMADO' END) AS ESTADO,
                      ( CASE WHEN IPP.ESTADO = Lv_EstadoError THEN HIST.OBSERVACION ELSE ' ' END) AS OBSERVACION
                FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION           AGP,
                      DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDM,
                      DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDS,
                      DB_COMERCIAL.INFO_PLAN_CAB                PLA,
                      DB_COMERCIAL.INFO_PLAN_CAB                PLN,
                      DB_EXTERNO.INFO_PROCESO_PROMO             IPP,
                      DB_EXTERNO.INFO_PROCESO_PROMO_HIST        HIST
                WHERE AGP.ID_GRUPO_PROMOCION     = IDM.GRUPO_PROMOCION_ID
                      AND IDM.ID_DETALLE_MAPEO   = IDS.DETALLE_MAPEO_ID
                      AND IDM.ID_DETALLE_MAPEO   = IPP.DETALLE_MAPEO_ID
                      AND IDS.PLAN_ID            = PLA.ID_PLAN
                      AND IDS.PLAN_ID_SUPERIOR   = PLN.ID_PLAN
                      AND AGP.ID_GRUPO_PROMOCION = Cn_IdPromocion
                      AND IDM.EMPRESA_COD = Lv_CodEmpresa
                      AND IPP.EMPRESA_COD = Lv_CodEmpresa
                      AND HIST.ID_PROCESO_PROMO_HIST = ( SELECT MAX(HIST2.ID_PROCESO_PROMO_HIST)
                          FROM DB_EXTERNO.INFO_PROCESO_PROMO_HIST HIST2
                          WHERE IPP.ID_PROCESO_PROMO = HIST2.PROCESO_PROMO_ID )
                GROUP BY IPP.NOMBRE_OLT, PLA.NOMBRE_PLAN, PLN.NOMBRE_PLAN, IPP.ESTADO, HIST.OBSERVACION
            );
        --
        CURSOR C_TotalElementosPromocion(Cn_IdPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE, Cv_TipoTotal VARCHAR2) IS
            SELECT COUNT(*) FROM (
                SELECT IPP.NOMBRE_OLT, PLA.NOMBRE_PLAN PLAN_ACTUAL, PLN.NOMBRE_PLAN PLAN_PROMO
                FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION           AGP,
                       DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDM,
                       DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDS,
                       DB_COMERCIAL.INFO_PLAN_CAB                PLA,
                       DB_COMERCIAL.INFO_PLAN_CAB                PLN,
                       DB_EXTERNO.INFO_PROCESO_PROMO             IPP
                WHERE AGP.ID_GRUPO_PROMOCION     = IDM.GRUPO_PROMOCION_ID
                      AND IDM.ID_DETALLE_MAPEO   = IDS.DETALLE_MAPEO_ID
                      AND IDM.ID_DETALLE_MAPEO   = IPP.DETALLE_MAPEO_ID
                      AND IDS.PLAN_ID            = PLA.ID_PLAN
                      AND IDS.PLAN_ID_SUPERIOR   = PLN.ID_PLAN
                      AND AGP.ID_GRUPO_PROMOCION = Cn_IdPromocion
                      AND (
                            ( Cv_TipoTotal = 'SI' AND ( IPP.ESTADO = Lv_EstadoProceso OR ( Pv_Tipo = 'APLICAR' AND IPP.ESTADO = Lv_EstadoBaja ) ) )
                            OR ( Cv_TipoTotal = 'NO' AND IPP.ESTADO != Lv_EstadoProceso )
                        )
                      AND IDM.EMPRESA_COD = Lv_CodEmpresa
                      AND IPP.EMPRESA_COD = Lv_CodEmpresa
                GROUP BY IPP.NOMBRE_OLT, PLA.NOMBRE_PLAN, PLN.NOMBRE_PLAN
            );

        Ln_TotalConfirmado    NUMBER;
        Ln_TotalNoConfirmado  NUMBER;
        Lc_GetAliasPlantilla  DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
        Le_MyException        EXCEPTION;
        Lv_MsjResultado       VARCHAR2(4000);
        Lb_TieneDatos         BOOLEAN;
        Lv_Delimitador        VARCHAR2(2)  := ';';

        Lf_Archivo            UTL_FILE.FILE_TYPE;
        Lv_NombreArchivo      VARCHAR2(100);
        Lv_NombreDirectorio   VARCHAR2(20)  := 'DIR_REPGERENCIA';
        Lv_RutaDirectorio     VARCHAR2(25)  := '/backup/repgerencia/';
        Lv_Extension          VARCHAR2(4)   := '.gz';
        Lv_ComandoReporte     VARCHAR2(5)   := 'gzip';
      BEGIN
        --
        --
        IF C_ObtenerParametrosDatos%ISOPEN THEN
          CLOSE C_ObtenerParametrosDatos;
        END IF;
        --
        --obtengo los datos de parametros datos
        OPEN C_ObtenerParametrosDatos;
        FETCH C_ObtenerParametrosDatos INTO Lv_TipoPromocion, Lv_Remitente, Lv_TipoPlantilla, Lv_EstadoError;
        CLOSE C_ObtenerParametrosDatos;
        --
        IF Lv_TipoPromocion IS NULL OR Lv_Remitente IS NULL OR Lv_TipoPlantilla IS NULL OR Lv_EstadoError IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos del reporte de correo para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF C_ObtenerParametros%ISOPEN THEN
          CLOSE C_ObtenerParametros;
        END IF;
        --
        --obtengo los datos de parametros
        OPEN C_ObtenerParametros;
        FETCH C_ObtenerParametros INTO Lv_EstadoPromocion, Lv_EstadoPromocionFinal, Lv_EstadoProceso,
                                       Lv_Asunto, Ln_RangoMinutoMinimo, Ln_RangoMinutoMaximo, Lv_HistoPromocion;
        CLOSE C_ObtenerParametros;
        --
        IF Lv_EstadoPromocion IS NULL OR Lv_EstadoPromocionFinal IS NULL OR Lv_EstadoProceso IS NULL OR
           Lv_Asunto IS NULL OR Ln_RangoMinutoMinimo IS NULL OR Ln_RangoMinutoMaximo IS NULL OR Lv_HistoPromocion IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos del reporte de correo para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF C_Promocion%ISOPEN THEN
          CLOSE C_Promocion;
        END IF;
        --
        FOR Lr_RegistrosPromocion IN C_Promocion
        LOOP
            --
            Lb_TieneDatos := false;
            --
            --
            IF C_TotalElementosPromocion%ISOPEN THEN
              CLOSE C_TotalElementosPromocion;
            END IF;
            --
            --obtengo el total confirmados
            OPEN C_TotalElementosPromocion(Lr_RegistrosPromocion.ID_GRUPO_PROMOCION,'SI');
            FETCH C_TotalElementosPromocion INTO Ln_TotalConfirmado;
            CLOSE C_TotalElementosPromocion;
            --
            --obtengo el total no confirmados
            OPEN C_TotalElementosPromocion(Lr_RegistrosPromocion.ID_GRUPO_PROMOCION,'NO');
            FETCH C_TotalElementosPromocion INTO Ln_TotalNoConfirmado;
            CLOSE C_TotalElementosPromocion;
            --
            IF Ln_TotalConfirmado > 0 OR Ln_TotalNoConfirmado > 0 THEN
                Lb_TieneDatos := true;
            END IF;
            --
            --verificar si tiene datos
            IF Lb_TieneDatos THEN
                --
                --ingresar historial
                INSERT INTO DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
                ( ID_GRUPO_PROMOCION_HISTO,GRUPO_PROMOCION_ID,MOTIVO_ID,ESTADO,OBSERVACION,USR_CREACION,FE_CREACION,IP_CREACION )
                VALUES
                ( DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL,Lr_RegistrosPromocion.ID_GRUPO_PROMOCION,NULL,
                  Lr_RegistrosPromocion.ESTADO,Lv_HistoPromocion,Lv_User,SYSDATE,Lv_Ip );
                --se guardan los cambios
                COMMIT;
                --
                --setear nombre del archivo
                Lv_NombreArchivo := 'ReportePromocionesBw_'||to_char(SYSDATE,'RRRRMMDDHH24MISS')||'.csv';
                --crear archivo
                Lf_Archivo := UTL_FILE.FOPEN(Lv_NombreDirectorio,Lv_NombreArchivo,'w',32767);
                --detalle del reporte
                UTL_FILE.PUT_LINE(Lf_Archivo,
                                 'OLT'             ||Lv_Delimitador
                               ||'PLAN ACTUAL'     ||Lv_Delimitador
                               ||'PLAN PROMO'      ||Lv_Delimitador
                               ||'CONFIRMACION'    ||Lv_Delimitador
                               ||'OBSERVACION'     ||Lv_Delimitador);
                --
                IF C_ElementosPromocion%ISOPEN THEN
                  CLOSE C_ElementosPromocion;
                END IF;
                --
                --
                FOR Lr_RegistrosElementos IN C_ElementosPromocion(Lr_RegistrosPromocion.ID_GRUPO_PROMOCION)
                LOOP
                    UTL_FILE.PUT_LINE(Lf_Archivo,
                                  Lr_RegistrosElementos.NOMBRE_OLT   ||Lv_Delimitador||
                                  Lr_RegistrosElementos.PLAN_ACTUAL  ||Lv_Delimitador||
                                  Lr_RegistrosElementos.PLAN_PROMO   ||Lv_Delimitador||
                                  Lr_RegistrosElementos.ESTADO       ||Lv_Delimitador||
                                  Lr_RegistrosElementos.OBSERVACION  ||Lv_Delimitador);
                END LOOP;
                --
                IF C_ElementosPromocion%ISOPEN THEN
                  CLOSE C_ElementosPromocion;
                END IF;
                --
                --cierre del archivo
                UTL_FILE.FCLOSE(Lf_Archivo);
                --ejecución del comando para crear el archivo comprimido
                DBMS_OUTPUT.PUT_LINE(NAF47_TNET.JAVARUNCOMMAND(Lv_ComandoReporte||' '||Lv_RutaDirectorio||Lv_NombreArchivo));
                --
                --enviar correo
                Lv_Asunto := REPLACE(Lv_Asunto, ':ID_PROMOCION', Lr_RegistrosPromocion.ID_GRUPO_PROMOCION);
                Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_TipoPlantilla);
                Lc_GetAliasPlantilla.PLANTILLA := REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{ID_PROMOCION}}', Lr_RegistrosPromocion.ID_GRUPO_PROMOCION);
                Lc_GetAliasPlantilla.PLANTILLA := REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{NOMBRE_GRUPO}}', Lr_RegistrosPromocion.NOMBRE_GRUPO);
                Lc_GetAliasPlantilla.PLANTILLA := REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{TOTAL_CONFIRMADO}}', Ln_TotalConfirmado);
                Lc_GetAliasPlantilla.PLANTILLA := REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{TOTAL_NO_CONFIRMADO}}', Ln_TotalNoConfirmado);
                DB_GENERAL.GNRLPCK_UTIL.SEND_EMAIL_ATTACH(Lv_Remitente,
                                                          REPLACE(Lc_GetAliasPlantilla.ALIAS_CORREOS,';',',')||',',
                                                          Lv_Asunto,
                                                          Lc_GetAliasPlantilla.PLANTILLA,
                                                          Lv_NombreDirectorio,
                                                          Lv_NombreArchivo||Lv_Extension);
                --
                --eliminación del archivo
                BEGIN
                    UTL_FILE.FREMOVE(Lv_NombreDirectorio,Lv_NombreArchivo||Lv_Extension);
                EXCEPTION
                  WHEN OTHERS THEN
                    Lv_MsjResultado := 'Error al eliminar el archivo: '||Lv_NombreArchivo||' - '||SUBSTR(SQLERRM,0,3000);
                    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                         'CMKG_PROMOCIONES_BW.P_NOTIFICA_PROMOCIONES_BW',
                                                         SUBSTR(Lv_MsjResultado,0,4000),
                                                         Lv_User,
                                                         SYSDATE,
                                                         Lv_Ip);
                END;
            END IF;
        END LOOP;
        --
        IF C_Promocion%ISOPEN THEN
          CLOSE C_Promocion;
        END IF;
        --
        --
        EXCEPTION
        WHEN Le_MyException THEN
            --
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_NOTIFICA_PROMOCIONES_BW',
                                                 SUBSTR(Lv_MsjResultado,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
        WHEN OTHERS THEN
            --
            Lv_MsjResultado := 'Ocurrió un error en el reporte de las promociones de ancho de banda: ';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_NOTIFICA_PROMOCIONES_BW',
                                                 SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
    END P_NOTIFICA_PROMOCIONES_BW;
    ----
    ----
    PROCEDURE P_PREPARE_FIN_PROMOCION_BW(Pn_IdPromocion IN  NUMBER,
                                         Pv_Status      OUT VARCHAR2,
                                         Pv_Mensaje     OUT VARCHAR2)
    IS
        --
        Lv_NombreParametro       VARCHAR2(40) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
        Lv_Tipo                  VARCHAR2(20) := 'ENVIAR DETENER';
        Lv_ValorEstados          VARCHAR2(20) := 'ESTADOS';
        Lv_CodEmpresa            VARCHAR2(5)  := '18';
        Lv_Estado                VARCHAR2(20) := 'Activo';
        Lv_EstadoPromocion       VARCHAR2(20);
        Lv_EstadoMapeo           VARCHAR2(20);
        Lv_EstadoProceso         VARCHAR2(20);
        Lv_EstadoFinalPromocion  VARCHAR2(20);
        Lv_EstadoFinalMapeo      VARCHAR2(20);
        Lv_EstadoFinalProceso    VARCHAR2(20);
        Ln_VerificarPromocion    NUMBER;
        Lv_EstadoServicio        VARCHAR2(20);
        Lv_ObservacionPlanes     VARCHAR2(4000);
        Lv_MsjResultado          VARCHAR2(4000);
        Lr_InfoProcesoPromoHist  DB_EXTERNO.INFO_PROCESO_PROMO_HIST%ROWTYPE;
        Lr_InfoDetalleMapeoHisto DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
        Lr_InfoServicioHistorial DB_COMERCIAL.INFO_SERVICIO_HISTORIAL%ROWTYPE;
        TYPE T_DataServicios IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        Lr_DataServicios         T_DataServicios;
        Le_MyException           EXCEPTION;
        Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
        Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
        Ln_index                 NUMBER;
        --
        CURSOR C_ObtenerParametrosEstados IS
            SELECT VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Lv_Tipo AND VALOR1 = Lv_ValorEstados AND ROWNUM = 1;
        --
        CURSOR C_VerificarPromocion IS
            SELECT 1 FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP
            WHERE AGP.ID_GRUPO_PROMOCION = Pn_IdPromocion
                  AND AGP.ESTADO      = Lv_EstadoPromocion
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa;
        -- Definimos la estructura del cursor de datos
        TYPE R_RegistrosDetalles IS RECORD (
            ID_DETALLE_MAPEO      DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO.ID_DETALLE_MAPEO%TYPE,
            ID_MAPEO_SOLICITUD    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD.ID_MAPEO_SOLICITUD%TYPE,
            ID_PROCESO_PROMO      DB_EXTERNO.INFO_PROCESO_PROMO.ID_PROCESO_PROMO%TYPE,
            SERVICIO_ID           DB_EXTERNO.INFO_PROCESO_PROMO.SERVICIO_ID%TYPE,
            PLAN_ACTUAL           VARCHAR2(200),
            PLAN_PROMO            VARCHAR2(200),
            PLAN_ID_ACTUAL        NUMBER,
            PLAN_ID_PROMO         NUMBER
        );
        
        -- Definimos el tipo coleccion
        TYPE Lr_ArrayRegistrosDetalles IS TABLE OF R_RegistrosDetalles INDEX BY PLS_INTEGER;
        
        -- Definimos la variable coleccion
        Lr_RegistrosDetalles  Lr_ArrayRegistrosDetalles;

        --
        --CURSOR C_ListaDetallesPromoAll(Cn_IdGrupoPromocion DB_COMERCIAL.ADMI_GRUPO_PROMOCION.ID_GRUPO_PROMOCION%TYPE) IS
        CURSOR C_ListaDetallesPromoAll IS
            SELECT IDM.ID_DETALLE_MAPEO ID_DETALLE_MAPEO, IDS.ID_MAPEO_SOLICITUD ID_MAPEO_SOLICITUD,
                   IPP.ID_PROCESO_PROMO ID_PROCESO_PROMO, IPP.SERVICIO_ID SERVICIO_ID,
                   PLA.NOMBRE_PLAN PLAN_ACTUAL, PLN.NOMBRE_PLAN PLAN_PROMO, PLA.ID_PLAN PLAN_ID_ACTUAL, PLN.ID_PLAN PLAN_ID_PROMO
            FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION           AGP,
                   DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDM,
                   DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDS,
                   DB_EXTERNO.INFO_PROCESO_PROMO             IPP,
                   DB_COMERCIAL.INFO_PLAN_CAB                PLA,
                   DB_COMERCIAL.INFO_PLAN_CAB                PLN
            WHERE AGP.ID_GRUPO_PROMOCION     = IDM.GRUPO_PROMOCION_ID
                  AND IDM.ID_DETALLE_MAPEO   = IDS.DETALLE_MAPEO_ID
                  AND IDM.ID_DETALLE_MAPEO   = IPP.DETALLE_MAPEO_ID
                  AND IDS.PLAN_ID            = PLA.ID_PLAN
                  AND IDS.PLAN_ID_SUPERIOR   = PLN.ID_PLAN
                  --AND AGP.ID_GRUPO_PROMOCION = Cn_IdGrupoPromocion
                  AND AGP.ID_GRUPO_PROMOCION = Pn_IdPromocion
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa
                  AND IDM.EMPRESA_COD = Lv_CodEmpresa
                  AND IPP.EMPRESA_COD = Lv_CodEmpresa
                  AND IDM.ESTADO = Lv_EstadoMapeo
                  AND IPP.ESTADO = Lv_EstadoProceso
            GROUP BY IDM.ID_DETALLE_MAPEO, IDS.ID_MAPEO_SOLICITUD, IPP.ID_PROCESO_PROMO,
                 IPP.SERVICIO_ID, PLA.NOMBRE_PLAN, PLN.NOMBRE_PLAN, PLA.ID_PLAN, PLN.ID_PLAN;
        --
    BEGIN
        --obtengo los datos de parametros
        OPEN C_ObtenerParametrosEstados;
        FETCH C_ObtenerParametrosEstados INTO Lv_EstadoPromocion, Lv_EstadoMapeo, Lv_EstadoProceso, Lv_EstadoFinalPromocion, Lv_EstadoFinalMapeo, Lv_EstadoFinalProceso;
        CLOSE C_ObtenerParametrosEstados;
        --
        IF Lv_EstadoPromocion IS NULL OR Lv_EstadoFinalPromocion IS NULL
          OR Lv_EstadoMapeo IS NULL OR Lv_EstadoProceso IS NULL
          OR Lv_EstadoFinalMapeo IS NULL OR Lv_EstadoFinalProceso IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Lv_Tipo||') de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        IF C_VerificarPromocion%ISOPEN THEN
          CLOSE C_VerificarPromocion;
        END IF;
        --verfico la promocion
        OPEN C_VerificarPromocion;
        FETCH C_VerificarPromocion INTO Ln_VerificarPromocion;
        CLOSE C_VerificarPromocion;
        IF Ln_VerificarPromocion IS NULL THEN
            Lv_MsjResultado := 'Error no se pudo verificar la promoción de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        -- Preparamos los datos que se van a detener
        IF C_ListaDetallesPromoAll%ISOPEN THEN
          CLOSE C_ListaDetallesPromoAll;
        END IF;
        --
        OPEN C_ListaDetallesPromoAll;
          LOOP
            Ln_index := 1;
            FETCH C_ListaDetallesPromoAll BULK COLLECT INTO Lr_RegistrosDetalles LIMIT 30000;
            WHILE Ln_index <= Lr_RegistrosDetalles.COUNT LOOP
              UPDATE DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO SET ESTADO = Lv_EstadoFinalMapeo WHERE ID_DETALLE_MAPEO = Lr_RegistrosDetalles(Ln_index).ID_DETALLE_MAPEO;
              UPDATE DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD SET ESTADO = Lv_EstadoFinalMapeo WHERE ID_MAPEO_SOLICITUD = Lr_RegistrosDetalles(Ln_index).ID_MAPEO_SOLICITUD;
              UPDATE DB_EXTERNO.INFO_PROCESO_PROMO SET ESTADO = Lv_EstadoFinalProceso WHERE ID_PROCESO_PROMO = Lr_RegistrosDetalles(Ln_index).ID_PROCESO_PROMO;
              --ingresar historial detalle mapeo promo
              Lr_InfoDetalleMapeoHisto                         := NULL;
              Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
              Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Lr_RegistrosDetalles(Ln_index).ID_DETALLE_MAPEO;
              Lr_InfoDetalleMapeoHisto.ESTADO                  := Lv_EstadoFinalMapeo;
              Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
              Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_User;
              Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_Ip;
              Lr_InfoDetalleMapeoHisto.OBSERVACION             := 'Se ejecuta la finalización de la promoción de ancho de banda.';
              DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto,Lv_MsjResultado);
              --ingresar historial proceso promo
              Lr_InfoProcesoPromoHist                       :=  NULL;
              Lr_InfoProcesoPromoHist.ID_PROCESO_PROMO_HIST :=  DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_HIST.NEXTVAL;
              Lr_InfoProcesoPromoHist.PROCESO_PROMO_ID      :=  Lr_RegistrosDetalles(Ln_index).ID_PROCESO_PROMO;
              Lr_InfoProcesoPromoHist.ESTADO                :=  Lv_EstadoFinalProceso;
              Lr_InfoProcesoPromoHist.OBSERVACION           :=  'Se ejecuta la finalización de la promoción de ancho de banda.';
              Lr_InfoProcesoPromoHist.FE_CREACION           :=  SYSDATE;
              Lr_InfoProcesoPromoHist.USR_CREACION          :=  Lv_User;
              Lr_InfoProcesoPromoHist.IP_CREACION           :=  Lv_Ip;
              DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_INSERT_PROCESO_PROMO_HIST(Lr_InfoProcesoPromoHist,Lv_MsjResultado);
              --setear historial servicio
              IF Lr_RegistrosDetalles(Ln_index).SERVICIO_ID IS NOT NULL AND NOT Lr_DataServicios.EXISTS(Lr_RegistrosDetalles(Ln_index).SERVICIO_ID) THEN
                  Lr_DataServicios(Lr_RegistrosDetalles(Ln_index).SERVICIO_ID) := 1;
                  Lv_ObservacionPlanes := 'Se ejecuta la finalización de la promoción de ancho de banda por concepto de DETENER_PROMOCIONES.';
                  Lv_ObservacionPlanes := Lv_ObservacionPlanes || '<br>Nombre de plan contratado: <b>' || Lr_RegistrosDetalles(Ln_index).PLAN_ACTUAL || '</b>';
                  Lv_ObservacionPlanes := Lv_ObservacionPlanes || '<br>Line profile de la promoción: <b>'
                                          || DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(Lr_RegistrosDetalles(Ln_index).PLAN_ID_PROMO) || '</b>';
                  SELECT ESTADO INTO Lv_EstadoServicio FROM DB_COMERCIAL.INFO_SERVICIO
                  WHERE ID_SERVICIO = Lr_RegistrosDetalles(Ln_index).SERVICIO_ID;
                  Lr_InfoServicioHistorial                        := NULL;
                  Lr_InfoServicioHistorial.ID_SERVICIO_HISTORIAL  := DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL ;
                  Lr_InfoServicioHistorial.SERVICIO_ID            := Lr_RegistrosDetalles(Ln_index).SERVICIO_ID;
                  Lr_InfoServicioHistorial.ESTADO                 := Lv_EstadoServicio;
                  Lr_InfoServicioHistorial.FE_CREACION            := SYSDATE;
                  Lr_InfoServicioHistorial.USR_CREACION           := Lv_User;
                  Lr_InfoServicioHistorial.IP_CREACION            := Lv_Ip;
                  Lr_InfoServicioHistorial.MOTIVO_ID              := NULL;
                  Lr_InfoServicioHistorial.OBSERVACION            := Lv_ObservacionPlanes;
                  Lr_InfoServicioHistorial.ACCION                 := NULL;
                  DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_SERVICIO_HISTO(Lr_InfoServicioHistorial,Lv_MsjResultado);
              END IF;
              --se guardan los cambios
              COMMIT;
              Ln_index := Ln_index + 1;
            END LOOP;
            EXIT WHEN C_ListaDetallesPromoAll%NOTFOUND;
          END LOOP;
        CLOSE C_ListaDetallesPromoAll;

        --actualizar estado
        UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION SET ESTADO = Lv_EstadoFinalPromocion WHERE ID_GRUPO_PROMOCION = Pn_IdPromocion;
        --se guardan los cambios
        COMMIT;
        --
        Pv_Status  := 'OK';
        Pv_Mensaje := 'Se finalizo la actualización los procesos de las promociones de ancho de banda.';
        --
      EXCEPTION
        WHEN Le_MyException THEN
            --se reservan los cambios
            ROLLBACK;
            Pv_Status  := 'ERROR';
            Pv_Mensaje := Lv_MsjResultado;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_PREPARE_FIN_PROMOCION_BW',
                                                 SUBSTR(Lv_MsjResultado,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
        WHEN OTHERS THEN
            --se reservan los cambios
            ROLLBACK;
            Pv_Status  := 'ERROR';
            Pv_Mensaje := 'Error al actualizar los procesos de las promociones de ancho de banda.';
            Lv_MsjResultado := 'Ocurrió un error al actualizar los procesos de las promociones de ancho de banda: ';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_PREPARE_FIN_PROMOCION_BW',
                                                 SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
    END P_PREPARE_FIN_PROMOCION_BW;
----
    FUNCTION F_CONTADOR_PROCESOS_PROMO_BW(Fn_IdPromocion IN NUMBER,
                                          Fv_Tipo        IN VARCHAR2,
                                          Fb_Confirmado  IN BOOLEAN)
    RETURN NUMBER
    IS
        --
        Lv_NombreParametro       VARCHAR2(40) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
        Lv_EstadoPromocion       VARCHAR2(20);
        Lv_EstadoMapeo           VARCHAR2(20);
        Lv_EstadoProceso         VARCHAR2(20);
        Lv_EstadoFinalPromocion  VARCHAR2(20);
        Lv_EstadoFinalMapeo      VARCHAR2(20);
        Lv_EstadoFinalProceso    VARCHAR2(20);
        Lv_EstadoProcesoError    VARCHAR2(20);
        Ln_Total                 NUMBER;
        Lv_MsjResultado          VARCHAR2(4000);
        Le_MyException           EXCEPTION;
        Lv_Estado                VARCHAR2(20) := 'Activo';
        Lv_CodEmpresa            VARCHAR2(5)  := '18';
        Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
        Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
        --
        --
        CURSOR C_ObtenerParametros IS
            SELECT VALOR1, VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Fv_Tipo AND ROWNUM = 1;
        --
        --
        CURSOR C_TotalNoConfirmado
        IS
          SELECT COUNT(IPP.ID_PROCESO_PROMO) AS TOTAL
          FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
              INNER JOIN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDM ON IDM.ID_DETALLE_MAPEO   = IPP.DETALLE_MAPEO_ID
              INNER JOIN DB_COMERCIAL.ADMI_GRUPO_PROMOCION     AGP ON AGP.ID_GRUPO_PROMOCION = IDM.GRUPO_PROMOCION_ID
          WHERE AGP.ID_GRUPO_PROMOCION = Fn_IdPromocion
              AND AGP.EMPRESA_COD = Lv_CodEmpresa
              AND IDM.EMPRESA_COD = Lv_CodEmpresa
              AND IPP.EMPRESA_COD = Lv_CodEmpresa
              AND AGP.ESTADO = Lv_EstadoPromocion
              AND IDM.ESTADO = Lv_EstadoMapeo
              AND IPP.ESTADO IN (Lv_EstadoProceso,Lv_EstadoProcesoError);
        --
        CURSOR C_TotalConfirmado
        IS
          SELECT COUNT(IPP.ID_PROCESO_PROMO) AS TOTAL
          FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
              INNER JOIN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDM ON IDM.ID_DETALLE_MAPEO   = IPP.DETALLE_MAPEO_ID
              INNER JOIN DB_COMERCIAL.ADMI_GRUPO_PROMOCION     AGP ON AGP.ID_GRUPO_PROMOCION = IDM.GRUPO_PROMOCION_ID
          WHERE AGP.ID_GRUPO_PROMOCION = Fn_IdPromocion
              AND AGP.EMPRESA_COD = Lv_CodEmpresa
              AND IDM.EMPRESA_COD = Lv_CodEmpresa
              AND IPP.EMPRESA_COD = Lv_CodEmpresa
              AND AGP.ESTADO = Lv_EstadoPromocion
              AND IDM.ESTADO = Lv_EstadoFinalMapeo
              AND IPP.ESTADO = Lv_EstadoFinalProceso;
        --
    BEGIN
        --
        --
        IF C_ObtenerParametros%ISOPEN THEN
          CLOSE C_ObtenerParametros;
        END IF;
        --
        --obtengo los datos de parametros
        OPEN C_ObtenerParametros;
        FETCH C_ObtenerParametros INTO Lv_EstadoPromocion, Lv_EstadoMapeo, Lv_EstadoProceso, Lv_EstadoFinalPromocion,
                                    Lv_EstadoFinalMapeo, Lv_EstadoFinalProceso, Lv_EstadoProcesoError;
        CLOSE C_ObtenerParametros;
        --
        IF Lv_EstadoPromocion IS NULL OR Lv_EstadoMapeo IS NULL OR Lv_EstadoProceso IS NULL OR Lv_EstadoProcesoError IS NULL
          OR Lv_EstadoFinalPromocion IS NULL OR Lv_EstadoFinalMapeo IS NULL OR Lv_EstadoFinalProceso IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Fv_Tipo||') de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --
        IF Fb_Confirmado THEN
            --
            IF C_TotalConfirmado%ISOPEN THEN
              CLOSE C_TotalConfirmado;
            END IF;
            --
            --obtengo los datos de parametros
            OPEN C_TotalConfirmado;
            FETCH C_TotalConfirmado INTO Ln_Total;
            CLOSE C_TotalConfirmado;
        ELSE
            --
            IF C_TotalNoConfirmado%ISOPEN THEN
              CLOSE C_TotalNoConfirmado;
            END IF;
            --
            --obtengo los datos de parametros
            OPEN C_TotalNoConfirmado;
            FETCH C_TotalNoConfirmado INTO Ln_Total;
            CLOSE C_TotalNoConfirmado;
        END IF;
        --
        RETURN Ln_Total;
    EXCEPTION
      WHEN Le_MyException THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                              'CMKG_PROMOCIONES_BW.F_CONTADOR_PROCESOS_PROMO_BW',
                                              SUBSTR(Lv_MsjResultado,0,4000),
                                              Lv_User,
                                              SYSDATE,
                                              Lv_Ip);
          RETURN 0;
      WHEN OTHERS THEN
          Lv_MsjResultado := 'Ocurrió un error al obtener el total de los procesos de las promociones de ancho de banda.';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                              'CMKG_PROMOCIONES_BW.F_CONTADOR_PROCESOS_PROMO_BW',
                                              SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                              Lv_User,
                                              SYSDATE,
                                              Lv_Ip);
          RETURN 0;
    END F_CONTADOR_PROCESOS_PROMO_BW;
----
    PROCEDURE P_PREPARE_OLT_PROMOCION_BW(Pn_IdPromocion IN NUMBER)
    IS
      --
      Lv_Tipo                   VARCHAR2(20) := 'APLICAR';
      Lv_NombreParametro        VARCHAR2(60) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
      Lv_ValorEstados           VARCHAR2(20) := 'ESTADOS';
      Lv_ParametroMarca         VARCHAR2(40) := 'MARCAS_PERMITIDAS';
      Lv_ParametroTipos         VARCHAR2(40) := 'TIPOS_ELEMENTOS_PERMITIDOS';
      Lv_CaractJurisdiccion     VARCHAR2(40) := 'PROM_JURISDICCION';
      Lv_CaractCanton           VARCHAR2(40) := 'PROM_CANTON';
      Lv_CaractParroquia        VARCHAR2(40) := 'PROM_PARROQUIA';
      Lv_CaractElemento         VARCHAR2(40) := 'PROM_ELEMENTO';
      Lv_CaractLineProfile      VARCHAR2(40) := 'LINE-PROFILE-NAME';
      Lv_Estado                 VARCHAR2(20) := 'Activo';
      Lv_EstadoInactivo         VARCHAR2(20) := 'Inactivo';
      Lv_EstadoClonado          VARCHAR2(20) := 'Clonado';
      Lv_EstadoEliminado        VARCHAR2(20) := 'Eliminado';
      Lv_CodigoProducto         VARCHAR2(5)  := 'INTD';
      Lv_PrefijoEmpresa         VARCHAR2(5)  := 'MD';
      Lv_CodEmpresa             VARCHAR2(5)  := '18';
      Ln_IdElementoOlt          NUMBER;
      Ln_IdDetalleMapeo         NUMBER;
      Ln_IdProcesoPromo         NUMBER;
      Lv_VerificarOlt           VARCHAR2(20);
      Lv_EstadoMapeo            VARCHAR2(20);
      Lv_EstadoProceso          VARCHAR2(20);
      Lv_FechaInicio            VARCHAR2(20);
      Lv_FechaFin               VARCHAR2(20);
      Ln_IdTipoPromocion        NUMBER;
      Lv_TipoPromocion          VARCHAR2(20);
      Lv_Observacion            VARCHAR2(200);
      Lv_TipoNegocio            VARCHAR2(20);
      Lv_Trama                  VARCHAR2(200) := '{}';
      Ln_Periodo                NUMBER       := 1;
      Ln_Porcentaje             NUMBER       := 0;
      Lv_TipoProcesoMapeo       VARCHAR2(60) := 'NUEVO';
      Lv_TipoProcesoPromo       VARCHAR2(60) := 'AplicaPromo';
      --
      Lr_InfoProcesoPromoHist  DB_EXTERNO.INFO_PROCESO_PROMO_HIST%ROWTYPE;
      Lr_InfoDetalleMapeoHisto DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO%ROWTYPE;
      --
      Le_MyException            EXCEPTION;
      Lv_MsjResultado           VARCHAR2(4000);
      Lv_User                   VARCHAR2(20) := 'telcos_promo_bw';
      Lv_Ip                     VARCHAR2(20) := '127.0.0.1';
      --
      --
      CURSOR C_ObtenerDatosPromocion IS
          SELECT TRUNC(G.FE_INICIO_VIGENCIA) FE_INICIO_VIGENCIA, TRUNC(G.FE_FIN_VIGENCIA) FE_FIN_VIGENCIA,
            T.ID_TIPO_PROMOCION, T.CODIGO_TIPO_PROMOCION TIPO_PROMOCION FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION G
          INNER JOIN DB_COMERCIAL.ADMI_TIPO_PROMOCION T ON T.GRUPO_PROMOCION_ID = G.ID_GRUPO_PROMOCION
          WHERE G.ID_GRUPO_PROMOCION = Pn_IdPromocion;
      --
      CURSOR C_ObtenerParametrosEstados IS
          SELECT VALOR3, VALOR4 FROM DB_GENERAL.ADMI_PARAMETRO_DET
          WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
              WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
          AND DESCRIPCION = Lv_Tipo AND VALOR1 = Lv_ValorEstados AND ROWNUM = 1;
      --
      TYPE R_RegistrosElementos IS RECORD (
          ID_ELEMENTO       DB_INFRAESTRUCTURA.INFO_ELEMENTO.ID_ELEMENTO%TYPE,
          NOMBRE_ELEMENTO   DB_INFRAESTRUCTURA.INFO_ELEMENTO.NOMBRE_ELEMENTO%TYPE,
          MODELO            DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO.NOMBRE_MODELO_ELEMENTO%TYPE
      );
      Lr_RegistrosElementos   R_RegistrosElementos;
      CURSOR C_ObtenerElementos IS
        SELECT ID_ELEMENTO, NOMBRE_ELEMENTO, MODELO FROM (
            SELECT ELE.ID_ELEMENTO, ELE.NOMBRE_ELEMENTO, MOD.NOMBRE_MODELO_ELEMENTO MODELO
            FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE
              INNER JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD ON MOD.ID_MODELO_ELEMENTO = ELE.MODELO_ELEMENTO_ID
              INNER JOIN DB_INFRAESTRUCTURA.ADMI_TIPO_ELEMENTO TIP ON TIP.ID_TIPO_ELEMENTO = MOD.TIPO_ELEMENTO_ID
              INNER JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR ON MAR.ID_MARCA_ELEMENTO = MOD.MARCA_ELEMENTO_ID
              INNER JOIN DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO EMP ON EMP.ELEMENTO_ID = ELE.ID_ELEMENTO
              INNER JOIN DB_INFRAESTRUCTURA.INFO_EMPRESA_ELEMENTO_UBICA EUB ON EUB.ELEMENTO_ID = ELE.ID_ELEMENTO
              INNER JOIN DB_INFRAESTRUCTURA.INFO_UBICACION UBI ON UBI.ID_UBICACION = EUB.UBICACION_ID
              INNER JOIN DB_GENERAL.ADMI_PARROQUIA PAR ON PAR.ID_PARROQUIA = UBI.PARROQUIA_ID
              INNER JOIN DB_INFRAESTRUCTURA.ADMI_CANTON_JURISDICCION CJU ON CJU.CANTON_ID = PAR.CANTON_ID
            WHERE ELE.ESTADO = Lv_Estado
              AND EMP.ESTADO = Lv_Estado
              AND CJU.ESTADO = Lv_Estado
              AND EMP.EMPRESA_COD = Lv_CodEmpresa
              AND EUB.EMPRESA_COD = Lv_CodEmpresa
              AND EXISTS (
                  SELECT 1 FROM DB_GENERAL.ADMI_PARAMETRO_DET DETT
                  INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CABT ON CABT.ID_PARAMETRO = DETT.PARAMETRO_ID
                  WHERE CABT.NOMBRE_PARAMETRO = Lv_NombreParametro
                  AND DETT.DESCRIPCION        = Lv_ParametroTipos
                  AND DETT.VALOR1             = TIP.NOMBRE_TIPO_ELEMENTO
                  AND DETT.ESTADO             = Lv_Estado
                  AND CABT.ESTADO             = Lv_Estado
              )
              AND EXISTS (
                  SELECT 1 FROM DB_GENERAL.ADMI_PARAMETRO_DET DETM
                  INNER JOIN DB_GENERAL.ADMI_PARAMETRO_CAB CABM ON CABM.ID_PARAMETRO = DETM.PARAMETRO_ID
                  WHERE CABM.NOMBRE_PARAMETRO = Lv_NombreParametro
                  AND DETM.DESCRIPCION        = Lv_ParametroMarca
                  AND DETM.VALOR1             = MAR.NOMBRE_MARCA_ELEMENTO
                  AND DETM.ESTADO             = Lv_Estado
                  AND CABM.ESTADO             = Lv_Estado
              )
              AND (
                  NOT EXISTS (
                    SELECT 1 FROM (
                      SELECT SECTORIZACION.ID_SECTORIZACION,
                        SECTORIZACION.ID_JURISDICCION,
                        NVL(SECTORIZACION.ID_CANTON   ,'0') AS ID_CANTON,
                        NVL(SECTORIZACION.ID_PARROQUIA,'0') AS ID_PARROQUIA,
                        NVL(SECTORIZACION.ID_ELEMENTO ,'0') AS ID_ELEMENTO
                      FROM (SELECT *
                        FROM (SELECT AC.DESCRIPCION_CARACTERISTICA,
                                    ATPR.VALOR,
                                    ATPR.SECUENCIA AS ID_SECTORIZACION
                              FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION      ATP,
                                  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
                                  DB_COMERCIAL.ADMI_CARACTERISTICA       AC
                              WHERE ATP.GRUPO_PROMOCION_ID = Pn_IdPromocion
                                AND ATP.ID_TIPO_PROMOCION  = ATPR.TIPO_PROMOCION_ID
                                AND AC.ID_CARACTERISTICA   = ATPR.CARACTERISTICA_ID
                                AND AC.DESCRIPCION_CARACTERISTICA IN (Lv_CaractJurisdiccion,Lv_CaractCanton,Lv_CaractParroquia,Lv_CaractElemento)
                              AND ATPR.SECUENCIA IS NOT NULL
                              AND ATPR.ESTADO != Lv_EstadoEliminado)
                        PIVOT (MAX(VALOR) FOR DESCRIPCION_CARACTERISTICA
                          IN ('PROM_JURISDICCION' AS ID_JURISDICCION, 
                              'PROM_CANTON'       AS ID_CANTON, 
                              'PROM_PARROQUIA'    AS ID_PARROQUIA, 
                              'PROM_ELEMENTO'     AS ID_ELEMENTO))) SECTORIZACION
                    ) SECTOR
                  )
                  OR EXISTS (
                    SELECT 1 FROM (
                      SELECT SECTORIZACION.ID_SECTORIZACION,
                        SECTORIZACION.ID_JURISDICCION,
                        NVL(SECTORIZACION.ID_CANTON   ,'0') AS ID_CANTON,
                        NVL(SECTORIZACION.ID_PARROQUIA,'0') AS ID_PARROQUIA,
                        NVL(SECTORIZACION.ID_ELEMENTO ,'0') AS ID_ELEMENTO
                      FROM (SELECT *
                        FROM (SELECT AC.DESCRIPCION_CARACTERISTICA,
                                    ATPR.VALOR,
                                    ATPR.SECUENCIA AS ID_SECTORIZACION
                              FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION      ATP,
                                  DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR,
                                  DB_COMERCIAL.ADMI_CARACTERISTICA       AC
                              WHERE ATP.GRUPO_PROMOCION_ID = Pn_IdPromocion
                                AND ATP.ID_TIPO_PROMOCION  = ATPR.TIPO_PROMOCION_ID
                                AND AC.ID_CARACTERISTICA   = ATPR.CARACTERISTICA_ID
                                AND AC.DESCRIPCION_CARACTERISTICA IN (Lv_CaractJurisdiccion,Lv_CaractCanton,Lv_CaractParroquia,Lv_CaractElemento)
                              AND ATPR.SECUENCIA IS NOT NULL
                              AND ATPR.ESTADO != Lv_EstadoEliminado)
                        PIVOT (MAX(VALOR) FOR DESCRIPCION_CARACTERISTICA
                          IN ('PROM_JURISDICCION' AS ID_JURISDICCION, 
                              'PROM_CANTON'       AS ID_CANTON, 
                              'PROM_PARROQUIA'    AS ID_PARROQUIA, 
                              'PROM_ELEMENTO'     AS ID_ELEMENTO))) SECTORIZACION
                    ) SECTOR
                    WHERE SECTOR.ID_JURISDICCION = CJU.JURISDICCION_ID
                    AND ( SECTOR.ID_CANTON = 0 OR SECTOR.ID_CANTON = PAR.CANTON_ID )
                    AND ( SECTOR.ID_PARROQUIA = 0 OR SECTOR.ID_PARROQUIA = PAR.ID_PARROQUIA )
                    AND ( SECTOR.ID_ELEMENTO = 0 OR SECTOR.ID_ELEMENTO = ELE.ID_ELEMENTO )
                  )
              )
            GROUP BY ELE.ID_ELEMENTO, ELE.NOMBRE_ELEMENTO, MOD.NOMBRE_MODELO_ELEMENTO
        );
      --
      TYPE R_RegistrosPlanes IS RECORD (
          PLAN_ID               DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION.PLAN_ID%TYPE,
          LINE_PROFILE_ACTUAL   VARCHAR2(60),
          PLAN_ID_SUPERIOR      DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION.PLAN_ID_SUPERIOR%TYPE,
          LINE_PROFILE_PROMO    VARCHAR2(60)
      );
      Lr_RegistrosPlanes   R_RegistrosPlanes;
      CURSOR C_ObtenerPlanes IS
        SELECT PLAN_ID, LINE_PROFILE_ACTUAL, PLAN_ID_SUPERIOR, LINE_PROFILE_PROMO FROM (
            SELECT PLN.PLAN_ID, DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(PLN.PLAN_ID) AS LINE_PROFILE_ACTUAL,
                PLN.PLAN_ID_SUPERIOR, DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(PLN.PLAN_ID_SUPERIOR) AS LINE_PROFILE_PROMO
            FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION         AGP,
                DB_COMERCIAL.ADMI_TIPO_PROMOCION           TIP,
                DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION PLN
            WHERE AGP.ID_GRUPO_PROMOCION   = TIP.GRUPO_PROMOCION_ID
                AND TIP.ID_TIPO_PROMOCION  = PLN.TIPO_PROMOCION_ID
                AND AGP.ID_GRUPO_PROMOCION = Pn_IdPromocion
                AND TIP.ESTADO             = Lv_Estado
                AND PLN.ESTADO             = Lv_Estado
        );
      --
      CURSOR C_VerificarOltPlan(Cv_NombreOlt VARCHAR2, Cv_LineProfile VARCHAR2, Cv_LineProfilePromo VARCHAR2) IS
        SELECT 'SI' FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
        INNER JOIN DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO DMP ON DMP.ID_DETALLE_MAPEO = IPP.DETALLE_MAPEO_ID
        WHERE DMP.GRUPO_PROMOCION_ID  = Pn_IdPromocion
          AND IPP.NOMBRE_OLT          = Cv_NombreOlt
          AND IPP.LINE_PROFILE_ORIGIN = Cv_LineProfile
          AND IPP.LINE_PROFILE_PROMO  = Cv_LineProfilePromo
          AND IPP.ESTADO              = Lv_EstadoProceso
          AND DMP.ESTADO              = Lv_EstadoMapeo
          AND ROWNUM                  <= 1;
      --
    --
    --
    BEGIN
      --
      IF C_ObtenerElementos%ISOPEN THEN
        CLOSE C_ObtenerElementos;
      END IF;
      --
      IF C_ObtenerPlanes%ISOPEN THEN
        CLOSE C_ObtenerPlanes;
      END IF;
      --
      IF C_VerificarOltPlan%ISOPEN THEN
        CLOSE C_VerificarOltPlan;
      END IF;
      --
      IF C_ObtenerParametrosEstados%ISOPEN THEN
        CLOSE C_ObtenerParametrosEstados;
      END IF;
      --
      --obtengo los datos de parametros
      OPEN C_ObtenerParametrosEstados;
      FETCH C_ObtenerParametrosEstados INTO Lv_EstadoMapeo, Lv_EstadoProceso;
      CLOSE C_ObtenerParametrosEstados;
      --
      IF Lv_EstadoMapeo IS NULL OR Lv_EstadoProceso IS NULL THEN
          Lv_MsjResultado := 'No se encontrarón los datos('||Lv_Tipo||') de parámetros para las promociones de ancho de banda.';
          RAISE Le_MyException;
      END IF;
      --
      --
      --obtengo los datos de la promoción
      OPEN C_ObtenerDatosPromocion;
      FETCH C_ObtenerDatosPromocion INTO Lv_FechaInicio, Lv_FechaFin, Ln_IdTipoPromocion, Lv_TipoPromocion;
      CLOSE C_ObtenerDatosPromocion;
      --
      Lv_Observacion := 'Se registró correctamente el mapeo de la Promoción: '||Lv_TipoPromocion
                        ||', Grupo-Promocional: '||Pn_IdPromocion||', Fecha-Mapeo: '||Lv_FechaInicio;
      --
      FOR Lr_RegistrosElementos IN C_ObtenerElementos
      LOOP
            --
            FOR Lr_RegistrosPlanes IN C_ObtenerPlanes
            LOOP
                --verificar olt
                Lv_VerificarOlt := NULL;
                OPEN C_VerificarOltPlan(Lr_RegistrosElementos.NOMBRE_ELEMENTO,Lr_RegistrosPlanes.LINE_PROFILE_ACTUAL,
                                        Lr_RegistrosPlanes.LINE_PROFILE_PROMO);
                FETCH C_VerificarOltPlan INTO Lv_VerificarOlt;
                CLOSE C_VerificarOltPlan;
                --
                IF Lv_VerificarOlt IS NULL THEN
                    --
                    INSERT INTO DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO
                      (ID_DETALLE_MAPEO, GRUPO_PROMOCION_ID, TRAMA, TIPO_PROMOCION_ID, TIPO_PROMOCION, FE_MAPEO,
                      PERIODO, PORCENTAJE, TIPO_PROCESO, USR_CREACION, FE_CREACION, IP_CREACION, EMPRESA_COD, ESTADO)
                    VALUES
                      (DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_PROMO.NEXTVAL, Pn_IdPromocion, Lv_Trama, Ln_IdTipoPromocion, Lv_TipoPromocion, Lv_FechaInicio,
                      Ln_Periodo, Ln_Porcentaje, Lv_TipoProcesoMapeo, Lv_User, SYSDATE, Lv_Ip, Lv_CodEmpresa, Lv_EstadoMapeo)
                    RETURNING ID_DETALLE_MAPEO INTO Ln_IdDetalleMapeo;
                    --
                    INSERT INTO DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD
                      (ID_MAPEO_SOLICITUD, DETALLE_MAPEO_ID, PLAN_ID, PLAN_ID_SUPERIOR, USR_CREACION, FE_CREACION, IP_CREACION, ESTADO) 
                    VALUES
                      (DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_SOLICI.NEXTVAL, Ln_IdDetalleMapeo, Lr_RegistrosPlanes.PLAN_ID,
                       Lr_RegistrosPlanes.PLAN_ID_SUPERIOR, Lv_User, SYSDATE, Lv_Ip, Lv_EstadoMapeo);
                    --
                    SELECT TIPO INTO Lv_TipoNegocio FROM DB_COMERCIAL.INFO_PLAN_CAB WHERE ID_PLAN = Lr_RegistrosPlanes.PLAN_ID;
                    --
                    INSERT INTO DB_EXTERNO.INFO_PROCESO_PROMO
                      (ID_PROCESO_PROMO, DETALLE_MAPEO_ID, MODELO_ELEMENTO, FE_INI_MAPEO, FE_FIN_MAPEO, NOMBRE_OLT, LINE_PROFILE_ORIGIN, LINE_PROFILE_PROMO,
                      TIPO_NEGOCIO, TIPO_PROCESO, TIPO_PROMO, USR_CREACION, FE_CREACION, IP_CREACION, EMPRESA_COD, ESTADO) 
                    VALUES
                      (DB_EXTERNO.SEQ_INFO_PROCESO_PROMO.NEXTVAL, Ln_IdDetalleMapeo, Lr_RegistrosElementos.MODELO, Lv_FechaInicio, Lv_FechaFin,
                      Lr_RegistrosElementos.NOMBRE_ELEMENTO, Lr_RegistrosPlanes.LINE_PROFILE_ACTUAL, Lr_RegistrosPlanes.LINE_PROFILE_PROMO,
                      Lv_TipoNegocio, Lv_TipoProcesoPromo, Lv_TipoPromocion, Lv_User, SYSDATE, Lv_Ip, Lv_CodEmpresa, Lv_EstadoProceso)
                    RETURNING ID_PROCESO_PROMO INTO Ln_IdProcesoPromo;
                    --
                    --ingresar historial detalle mapeo promo
                    Lr_InfoDetalleMapeoHisto                         := NULL;
                    Lr_InfoDetalleMapeoHisto.ID_DETALLE_MAPEO_HISTO  := DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL ;
                    Lr_InfoDetalleMapeoHisto.DETALLE_MAPEO_ID        := Ln_IdDetalleMapeo;
                    Lr_InfoDetalleMapeoHisto.ESTADO                  := Lv_EstadoMapeo;
                    Lr_InfoDetalleMapeoHisto.OBSERVACION             := Lv_Observacion;
                    Lr_InfoDetalleMapeoHisto.FE_CREACION             := SYSDATE;
                    Lr_InfoDetalleMapeoHisto.USR_CREACION            := Lv_User;
                    Lr_InfoDetalleMapeoHisto.IP_CREACION             := Lv_Ip;
                    DB_COMERCIAL.CMKG_PROMOCIONES.P_INSERT_INFO_DET_MAPEO_HISTO(Lr_InfoDetalleMapeoHisto,Lv_MsjResultado);
                    --ingresar historial proceso promo
                    Lr_InfoProcesoPromoHist                       :=  NULL;
                    Lr_InfoProcesoPromoHist.ID_PROCESO_PROMO_HIST :=  DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_HIST.NEXTVAL;
                    Lr_InfoProcesoPromoHist.PROCESO_PROMO_ID      :=  Ln_IdProcesoPromo;
                    Lr_InfoProcesoPromoHist.ESTADO                :=  Lv_EstadoProceso;
                    Lr_InfoProcesoPromoHist.OBSERVACION           :=  'Creación del proceso de promoción';
                    Lr_InfoProcesoPromoHist.FE_CREACION           :=  SYSDATE;
                    Lr_InfoProcesoPromoHist.USR_CREACION          :=  Lv_User;
                    Lr_InfoProcesoPromoHist.IP_CREACION           :=  Lv_Ip;
                    DB_EXTERNO.EXKG_MD_TRANSACTIONS.P_INSERT_PROCESO_PROMO_HIST(Lr_InfoProcesoPromoHist,Lv_MsjResultado);
                    --
                    --se guardan los cambios
                    COMMIT;
                END IF;
            END LOOP;
            --
            IF C_ObtenerPlanes%ISOPEN THEN
              CLOSE C_ObtenerPlanes;
            END IF;
      END LOOP;
      --
      IF C_ObtenerElementos%ISOPEN THEN
        CLOSE C_ObtenerElementos;
      END IF;
      --
    EXCEPTION
        WHEN Le_MyException THEN
            --se reservan los cambios
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_PREPARE_OLT_PROMOCION_BW',
                                                 SUBSTR(Lv_MsjResultado,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
        WHEN OTHERS THEN
            --se reservan los cambios
            ROLLBACK;
            Lv_MsjResultado := 'Ocurrió un error al generar los procesos de las promociones de ancho de banda en los olt: ';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_PREPARE_OLT_PROMOCION_BW',
                                                 SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
    END P_PREPARE_OLT_PROMOCION_BW;
----
    PROCEDURE P_VERIFICAR_PLAN_PROMO_BW(Pn_IdPromocion   IN NUMBER,
                                       Pv_FechaInicio    IN VARCHAR2,
                                       Pv_FechaFin       IN VARCHAR2,
                                       Pv_Jurisdicciones IN VARCHAR2,
                                       Pn_IdPlan         IN NUMBER,
                                       Pv_Resultado      OUT VARCHAR2)
    IS
        --
        Lv_Resultado             VARCHAR2(20);
        Lv_MsjResultado          VARCHAR2(4000);
        Le_MyException           EXCEPTION;
        Lv_TipoPromocion         VARCHAR2(20) := 'PROM_BW';
        Lv_ValorSI               VARCHAR2(20) := 'SI';
        Lv_Estado                VARCHAR2(20) := 'Activo';
        Lv_EstadoProgramado      VARCHAR2(20) := 'Programado';
        Lv_EstadoProcesamiento   VARCHAR2(20) := 'Procesamiento';
        Lv_EstadoEliminado       VARCHAR2(20) := 'Eliminado';
        Lv_CodEmpresa            VARCHAR2(5)  := '18';
        Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
        Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
        --
        --
        CURSOR C_CompararPlan IS
            SELECT 'SI'
            FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP
              INNER JOIN DB_COMERCIAL.ADMI_TIPO_PROMOCION ATP ON ATP.GRUPO_PROMOCION_ID = AGP.ID_GRUPO_PROMOCION
            WHERE ATP.CODIGO_TIPO_PROMOCION = Lv_TipoPromocion
              AND AGP.ID_GRUPO_PROMOCION != Pn_IdPromocion
              AND ( AGP.ESTADO = Lv_Estado OR AGP.ESTADO = Lv_EstadoProgramado OR AGP.ESTADO = Lv_EstadoProcesamiento )
              AND AGP.EMPRESA_COD = Lv_CodEmpresa
              AND ATP.ESTADO = Lv_Estado
              AND (
                ( TO_DATE(Pv_FechaInicio,'RRRR-MM-DD HH24:MI')
                  BETWEEN TO_DATE(TO_CHAR(AGP.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                  AND TO_DATE(TO_CHAR(AGP.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI') )
                OR ( TO_DATE(Pv_FechaFin,'RRRR-MM-DD HH24:MI')
                  BETWEEN TO_DATE(TO_CHAR(AGP.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                  AND TO_DATE(TO_CHAR(AGP.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI') )
                OR (
                  TO_DATE(Pv_FechaInicio,'RRRR-MM-DD HH24:MI') <= TO_DATE(TO_CHAR(AGP.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                  AND TO_DATE(Pv_FechaFin,'RRRR-MM-DD HH24:MI') >= TO_DATE(TO_CHAR(AGP.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                )
              )
              AND EXISTS (
                  SELECT 1 FROM DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION TPL
                  WHERE TPL.TIPO_PROMOCION_ID = ATP.ID_TIPO_PROMOCION
                  AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_COMPARAR_PLAN_PROMO_BW(TPL.PLAN_ID,Pn_IdPlan) = Lv_ValorSI
                  AND TPL.ESTADO = Lv_Estado
              )
              AND (
                  NOT EXISTS (
                      SELECT 1 FROM (
                          SELECT SECTORIZACION.ID_GRUPO_PROMOCION,
                          SECTORIZACION.ID_SECTORIZACION,
                          SECTORIZACION.ID_JURISDICCION,
                          NVL(SECTORIZACION.ID_CANTON   ,'0') AS ID_CANTON,
                          NVL(SECTORIZACION.ID_PARROQUIA,'0') AS ID_PARROQUIA
                          FROM (SELECT *
                          FROM (SELECT AC2.DESCRIPCION_CARACTERISTICA,ATPR2.VALOR,
                                      ATPR2.SECUENCIA AS ID_SECTORIZACION,
                                      AGP2.ID_GRUPO_PROMOCION
                                  FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION      ATP2,
                                      DB_COMERCIAL.ADMI_GRUPO_PROMOCION      AGP2,
                                      DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR2,
                                      DB_COMERCIAL.ADMI_CARACTERISTICA       AC2
                                  WHERE ATP2.CODIGO_TIPO_PROMOCION = Lv_TipoPromocion
                                  AND AGP2.ID_GRUPO_PROMOCION != Pn_IdPromocion
                                  AND ( AGP2.ESTADO = Lv_Estado OR AGP2.ESTADO = Lv_EstadoProgramado OR AGP2.ESTADO = Lv_EstadoProcesamiento )
                                  AND AGP2.EMPRESA_COD = Lv_CodEmpresa
                                  AND ATP2.ESTADO = Lv_Estado
                                  AND (
                                    ( TO_DATE(Pv_FechaInicio,'RRRR-MM-DD HH24:MI')
                                      BETWEEN TO_DATE(TO_CHAR(AGP2.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                                      AND TO_DATE(TO_CHAR(AGP2.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI') )
                                    OR ( TO_DATE(Pv_FechaFin,'RRRR-MM-DD HH24:MI')
                                      BETWEEN TO_DATE(TO_CHAR(AGP2.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                                      AND TO_DATE(TO_CHAR(AGP2.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI') )
                                    OR (
                                      TO_DATE(Pv_FechaInicio,'RRRR-MM-DD HH24:MI') <= TO_DATE(TO_CHAR(AGP2.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                                      AND TO_DATE(Pv_FechaFin,'RRRR-MM-DD HH24:MI') >= TO_DATE(TO_CHAR(AGP2.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                                    )
                                  )
                                  AND EXISTS (
                                      SELECT 1 FROM DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION TPL2
                                      WHERE TPL2.TIPO_PROMOCION_ID = ATP2.ID_TIPO_PROMOCION
                                      AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_COMPARAR_PLAN_PROMO_BW(TPL2.PLAN_ID,Pn_IdPlan) = Lv_ValorSI
                                      AND TPL2.ESTADO = Lv_Estado
                                  )
                                  AND ATP2.GRUPO_PROMOCION_ID    = AGP2.ID_GRUPO_PROMOCION
                                  AND ATP2.ID_TIPO_PROMOCION     = ATPR2.TIPO_PROMOCION_ID
                                  AND AC2.ID_CARACTERISTICA      = ATPR2.CARACTERISTICA_ID
                                  AND AC2.DESCRIPCION_CARACTERISTICA IN ('PROM_JURISDICCION',
                                                                          'PROM_CANTON',
                                                                          'PROM_PARROQUIA')
                                  AND ATPR2.SECUENCIA IS NOT NULL
                                  AND ATPR2.ESTADO != Lv_EstadoEliminado
                          )
                          PIVOT (MAX(VALOR) FOR DESCRIPCION_CARACTERISTICA
                              IN ('PROM_JURISDICCION' AS ID_JURISDICCION, 
                                  'PROM_CANTON'       AS ID_CANTON, 
                                  'PROM_PARROQUIA'    AS ID_PARROQUIA))) SECTORIZACION
                      ) SECTOR
                      WHERE SECTOR.ID_GRUPO_PROMOCION = AGP.ID_GRUPO_PROMOCION
                  )
                  OR (
                      Pv_Jurisdicciones IS NULL
                      OR EXISTS (
                          SELECT 1 FROM (
                              SELECT SECTORIZACION.ID_GRUPO_PROMOCION,
                              SECTORIZACION.ID_SECTORIZACION,
                              SECTORIZACION.ID_JURISDICCION,
                              NVL(SECTORIZACION.ID_CANTON   ,'0') AS ID_CANTON,
                              NVL(SECTORIZACION.ID_PARROQUIA,'0') AS ID_PARROQUIA
                              FROM (SELECT *
                              FROM (SELECT AC2.DESCRIPCION_CARACTERISTICA,ATPR2.VALOR,
                                          ATPR2.SECUENCIA AS ID_SECTORIZACION,
                                          AGP2.ID_GRUPO_PROMOCION
                                      FROM DB_COMERCIAL.ADMI_TIPO_PROMOCION      ATP2,
                                          DB_COMERCIAL.ADMI_GRUPO_PROMOCION      AGP2,
                                          DB_COMERCIAL.ADMI_TIPO_PROMOCION_REGLA ATPR2,
                                          DB_COMERCIAL.ADMI_CARACTERISTICA       AC2
                                      WHERE ATP2.CODIGO_TIPO_PROMOCION = Lv_TipoPromocion
                                      AND AGP2.ID_GRUPO_PROMOCION != Pn_IdPromocion
                                      AND ( AGP2.ESTADO = Lv_Estado OR AGP2.ESTADO = Lv_EstadoProgramado OR AGP2.ESTADO = Lv_EstadoProcesamiento )
                                      AND AGP2.EMPRESA_COD = Lv_CodEmpresa
                                      AND ATP2.ESTADO = Lv_Estado
                                      AND (
                                        ( TO_DATE(Pv_FechaInicio,'RRRR-MM-DD HH24:MI')
                                          BETWEEN TO_DATE(TO_CHAR(AGP2.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                                          AND TO_DATE(TO_CHAR(AGP2.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI') )
                                        OR ( TO_DATE(Pv_FechaFin,'RRRR-MM-DD HH24:MI')
                                          BETWEEN TO_DATE(TO_CHAR(AGP2.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                                          AND TO_DATE(TO_CHAR(AGP2.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI') )
                                        OR (
                                          TO_DATE(Pv_FechaInicio,'RRRR-MM-DD HH24:MI') <= TO_DATE(TO_CHAR(AGP2.FE_INICIO_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                                          AND TO_DATE(Pv_FechaFin,'RRRR-MM-DD HH24:MI') >= TO_DATE(TO_CHAR(AGP2.FE_FIN_VIGENCIA,'RRRR-MM-DD HH24:MI'),'RRRR-MM-DD HH24:MI')
                                        )
                                      )
                                      AND EXISTS (
                                          SELECT 1 FROM DB_COMERCIAL.ADMI_TIPO_PLAN_PROD_PROMOCION TPL2
                                          WHERE TPL2.TIPO_PROMOCION_ID = ATP2.ID_TIPO_PROMOCION
                                          AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_COMPARAR_PLAN_PROMO_BW(TPL2.PLAN_ID,Pn_IdPlan) = Lv_ValorSI
                                          AND TPL2.ESTADO = Lv_Estado
                                      )
                                      AND ATP2.GRUPO_PROMOCION_ID    = AGP2.ID_GRUPO_PROMOCION
                                      AND ATP2.ID_TIPO_PROMOCION     = ATPR2.TIPO_PROMOCION_ID
                                      AND AC2.ID_CARACTERISTICA      = ATPR2.CARACTERISTICA_ID
                                      AND AC2.DESCRIPCION_CARACTERISTICA IN ('PROM_JURISDICCION',
                                                                              'PROM_CANTON',
                                                                              'PROM_PARROQUIA')
                                      AND ATPR2.SECUENCIA IS NOT NULL
                                      AND ATPR2.ESTADO != Lv_EstadoEliminado
                              )
                              PIVOT (MAX(VALOR) FOR DESCRIPCION_CARACTERISTICA
                                  IN ('PROM_JURISDICCION' AS ID_JURISDICCION, 
                                      'PROM_CANTON'       AS ID_CANTON, 
                                      'PROM_PARROQUIA'    AS ID_PARROQUIA))) SECTORIZACION
                          ) SECTOR
                          WHERE SECTOR.ID_GRUPO_PROMOCION = AGP.ID_GRUPO_PROMOCION
                          AND EXISTS
                          (
                              SELECT 1 FROM (
                                SELECT REGEXP_SUBSTR(registros ,'[^,]+', 1, 1) ID_JURISDICCION,
                                       REGEXP_SUBSTR(registros ,'[^,]+', 1, 2) ID_CANTON,
                                       REGEXP_SUBSTR(registros,'[^,]+', 1, 3) ID_PARROQUIA
                                FROM (
                                    SELECT
                                        REGEXP_SUBSTR(Pv_Jurisdicciones,'[^;]+', 1, LEVEL) registros 
                                    FROM DUAL
                                    CONNECT BY LEVEL <= REGEXP_COUNT(Pv_Jurisdicciones, ';') + 1
                                )
                              ) SEC
                              WHERE SECTOR.ID_JURISDICCION = SEC.ID_JURISDICCION
                              AND SECTOR.ID_CANTON    = SEC.ID_CANTON
                              AND SECTOR.ID_PARROQUIA = SEC.ID_PARROQUIA
                          )
                      )
                  )
              );
        --
    BEGIN
        --
        --
        IF C_CompararPlan%ISOPEN THEN
          CLOSE C_CompararPlan;
        END IF;
        --
        --obtengo los datos de parametros
        OPEN C_CompararPlan;
        FETCH C_CompararPlan INTO Lv_Resultado;
        CLOSE C_CompararPlan;
        --
        IF Lv_Resultado IS NULL THEN
            Lv_Resultado := 'NO';
        END IF;
        --
        Pv_Resultado := Lv_Resultado;
        --
    EXCEPTION
      WHEN OTHERS THEN
          Lv_MsjResultado := 'Ocurrió un error al comparar el plan con otras promociones en el proceso de ancho de banda.';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                               'CMKG_PROMOCIONES_BW.P_VERIFICAR_PLAN_PROMO_BW',
                                               SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                               Lv_User,
                                               SYSDATE,
                                               Lv_Ip);
          Pv_Resultado := 'NO';
    END P_VERIFICAR_PLAN_PROMO_BW;
----
    PROCEDURE P_ENVIA_DETENER_PROMOCION_BW(Pn_IdPromocion IN  NUMBER,
                                           Pv_Status      OUT VARCHAR2,
                                           Pv_Mensaje     OUT VARCHAR2)
    IS
      --
      Lv_NombreParametro       VARCHAR2(40) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
      Lv_Tipo                  VARCHAR2(20) := 'QUITAR';
      Lv_ValorEstados          VARCHAR2(20) := 'ESTADOS';
      Lv_CodEmpresa            VARCHAR2(5)  := '18';
      Lv_Estado                VARCHAR2(20) := 'Activo';
      Lv_EstadoPromocion       VARCHAR2(20);
      Lv_EstadoMapeo           VARCHAR2(20);
      Lv_EstadoProceso         VARCHAR2(20);
      Lv_EstadoFinalPromocion  VARCHAR2(20);
      Lv_EstadoFinalMapeo      VARCHAR2(20);
      Lv_EstadoFinalProceso    VARCHAR2(20);
      Ln_VerificarPromocion    NUMBER;
      Lv_EstadoServicio        VARCHAR2(20);
      Lv_ObservacionPlanes     VARCHAR2(4000);
      Lv_MsjResultado          VARCHAR2(4000);
      Le_MyException           EXCEPTION;
      Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
      Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
      --
      CURSOR C_ObtenerParametrosEstados IS
          SELECT VALOR5 FROM DB_GENERAL.ADMI_PARAMETRO_DET
          WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
              WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
          AND DESCRIPCION = Lv_Tipo AND VALOR1 = Lv_ValorEstados AND ROWNUM = 1;
      --
    BEGIN
      --obtengo los datos de parametros
      OPEN C_ObtenerParametrosEstados;
      FETCH C_ObtenerParametrosEstados INTO Lv_EstadoFinalPromocion;
      CLOSE C_ObtenerParametrosEstados;
      --
      IF Lv_EstadoFinalPromocion IS NULL THEN
          Lv_MsjResultado := 'No se encontrarón los datos('||Lv_Tipo||') de parámetros para las promociones de ancho de banda.';
          RAISE Le_MyException;
      END IF;
      --actualizar estado
      UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION SET ESTADO = Lv_EstadoFinalPromocion WHERE ID_GRUPO_PROMOCION = Pn_IdPromocion;
      COMMIT;
      --
      SYS.DBMS_SCHEDULER.CREATE_JOB(
            job_name   => '"DB_COMERCIAL"."JOB_DETENER_PROMO_BW_'||Pn_IdPromocion||'"',
            job_type   => 'PLSQL_BLOCK',                        
            job_action => 'DECLARE
                                ln_id_promocion NUMBER;
                                lv_status       VARCHAR2(50);
                                lv_mensaje      VARCHAR2(1000);
                           BEGIN
                                ln_id_promocion:='''||Pn_IdPromocion||''';
                                DB_COMERCIAL.CMKG_PROMOCIONES_BW.P_PREPARE_FIN_PROMOCION_BW(Pn_IdPromocion => ln_id_promocion,
                                                                                            Pv_Status      => lv_status,
                                                                                            Pv_Mensaje     => lv_mensaje);
                           END;',
            number_of_arguments => 0,
            start_date         => NULL,
            repeat_interval    => NULL,
            end_date           => NULL,
            enabled            => FALSE,
            auto_drop          => TRUE,
            comments           => 'Job para ejecutar el proceso masivo de detener promociones ');
      SYS.DBMS_SCHEDULER.SET_ATTRIBUTE( 
            name      => '"DB_COMERCIAL"."JOB_DETENER_PROMO_BW_'||Pn_IdPromocion||'"', 
            attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF );
      SYS.DBMS_SCHEDULER.enable(
            name => '"DB_COMERCIAL"."JOB_DETENER_PROMO_BW_'||Pn_IdPromocion||'"');
      Pv_Status  := 'OK';
      Pv_Mensaje := 'Se finalizo la actualización los procesos de las promociones de ancho de banda.';
      --
    EXCEPTION
      WHEN Le_MyException THEN
          --se reservan los cambios
          ROLLBACK;
          Pv_Status  := 'ERROR';
          Pv_Mensaje := Lv_MsjResultado;
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                               'CMKG_PROMOCIONES_BW.P_ENVIA_DETENER_PROMOCION_BW',
                                               SUBSTR(Lv_MsjResultado,0,4000),
                                               Lv_User,
                                               SYSDATE,
                                               Lv_Ip);
      WHEN OTHERS THEN
          --se reservan los cambios
          ROLLBACK;
          Pv_Status  := 'ERROR';
          Pv_Mensaje := 'Error al intentar detener los procesos de las promociones de ancho de banda.';
          Lv_MsjResultado := 'Ocurrió un error al actualizar los procesos de las promociones de ancho de banda: ';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                               'CMKG_PROMOCIONES_BW.P_ENVIA_DETENER_PROMOCION_BW',
                                               SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                               Lv_User,
                                               SYSDATE,
                                               Lv_Ip);
    END P_ENVIA_DETENER_PROMOCION_BW;
----
    PROCEDURE P_HISTO_CLIENTE_PROMO_BW(Pn_IdPromocion   IN NUMBER,
                                       Pv_Tipo          IN VARCHAR2,
                                       Pv_ForHistorial  IN VARCHAR2,
                                       Pv_HistoProceso  IN VARCHAR2,
                                       Pv_EstadoProceso IN VARCHAR2,
                                       Pv_Tecnologia    IN VARCHAR2 DEFAULT NULL)
    IS
        --
        Lcl_SqlSelect               CLOB;
        Lcl_SqlFrom                 CLOB;
        Lcl_SqlWhere                CLOB;
        Lcl_SqlCliente              CLOB;
        Lcl_SqlRegistros            CLOB;
        Lv_CodEmpresa               VARCHAR2(5)  := '18';
        Lv_Estado                   VARCHAR2(30) := 'Activo';
        Ln_Index                    NUMBER;
        Lv_ObservacionPlanes        VARCHAR2(4000);
        Lv_MsjResultado             VARCHAR2(4000);
        Lv_User                     VARCHAR2(20) := 'telcos_promo_bw';
        Lv_Ip                       VARCHAR2(20) := '127.0.0.1';
        --
        C_ListaServiciosPromoAll  SYS_REFCURSOR;
        C_ListaDetallesPromoAll   SYS_REFCURSOR;
        TYPE R_Servicios IS RECORD (
            SERVICIO_ID     NUMBER,
            ESTADO          VARCHAR2(60),
            PLAN_ACTUAL     VARCHAR2(100),
            PLAN_PROMO      VARCHAR2(100),
            PLAN_ID_ACTUAL  NUMBER,
            PLAN_ID_PROMO   NUMBER,
            FE_INICIO       VARCHAR2(20),
            FE_FIN          VARCHAR2(20),
            HORA_INICIO     VARCHAR2(10),
            HORA_FIN        VARCHAR2(10),
            DATA_LINE_PROFILE VARCHAR2(100)
        );
        TYPE Ltl_PromoServicio IS TABLE OF R_Servicios INDEX BY PLS_INTEGER;
        Lr_ServicioPromo        Ltl_PromoServicio;
        TYPE R_Detalles IS RECORD (
            ID_DETALLE_MAPEO    NUMBER,
            ID_PROCESO_PROMO    NUMBER,
            ESTADO_MAPEO        VARCHAR2(60),
            ESTADO_PROMO        VARCHAR2(60)
        );
        TYPE Ltl_PromoDetalles IS TABLE OF R_Detalles  INDEX BY PLS_INTEGER;
        Lr_DetallesPromo        Ltl_PromoDetalles;
    BEGIN
        --
        IF C_ListaServiciosPromoAll%ISOPEN THEN
          CLOSE C_ListaServiciosPromoAll;
        END IF;
        --
        Lcl_SqlSelect := 'SELECT IPP.SERVICIO_ID,
                    SERVICIO.ESTADO,
                    PLA.NOMBRE_PLAN PLAN_ACTUAL,
                    PLN.NOMBRE_PLAN PLAN_PROMO,
                    PLA.ID_PLAN PLAN_ID_ACTUAL,
                    PLN.ID_PLAN PLAN_ID_PROMO,
                    TO_CHAR(AGP.FE_INICIO_VIGENCIA,''RRRR-MM-DD'') FE_INICIO, TO_CHAR(AGP.FE_FIN_VIGENCIA,''RRRR-MM-DD'') FE_FIN,
                    TO_CHAR(AGP.FE_INICIO_VIGENCIA, ''HH24:MI'') HORA_INICIO, TO_CHAR(AGP.FE_FIN_VIGENCIA, ''HH24:MI'') HORA_FIN';
        IF Pv_Tecnologia IS NULL THEN
            Lcl_SqlFrom := ' FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
                    DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDM,
                    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDS,
                    DB_EXTERNO.INFO_PROCESO_PROMO IPP,
                    DB_COMERCIAL.INFO_PLAN_CAB PLA,
                    DB_COMERCIAL.INFO_PLAN_CAB PLN,
                    DB_COMERCIAL.INFO_SERVICIO SERVICIO';
            Lcl_SqlWhere := ' WHERE AGP.ID_GRUPO_PROMOCION = IDM.GRUPO_PROMOCION_ID
                    AND IDM.ID_DETALLE_MAPEO     = IDS.DETALLE_MAPEO_ID
                    AND IDM.ID_DETALLE_MAPEO     = IPP.DETALLE_MAPEO_ID
                    AND IDS.PLAN_ID              = PLA.ID_PLAN
                    AND IDS.PLAN_ID_SUPERIOR     = PLN.ID_PLAN
                    AND AGP.ID_GRUPO_PROMOCION   = '''||Pn_IdPromocion||'''
                    AND AGP.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                    AND IDM.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                    AND IPP.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                    AND IPP.ESTADO               = '''||Pv_EstadoProceso||'''
                    AND IPP.SERVICIO_ID          IS NOT NULL
                    AND SERVICIO.ID_SERVICIO     = IPP.SERVICIO_ID';
            Lcl_SqlRegistros := 'SELECT ID_DETALLE_MAPEO, ID_PROCESO_PROMO, ESTADO_MAPEO, ESTADO_PROMO
                                  FROM
                                      (SELECT IDM.ID_DETALLE_MAPEO, IPP.ID_PROCESO_PROMO, IDM.ESTADO ESTADO_MAPEO, IPP.ESTADO ESTADO_PROMO
                                      FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
                                          DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDM,
                                          DB_EXTERNO.INFO_PROCESO_PROMO IPP
                                      WHERE AGP.ID_GRUPO_PROMOCION     = IDM.GRUPO_PROMOCION_ID
                                          AND IDM.ID_DETALLE_MAPEO     = IPP.DETALLE_MAPEO_ID
                                          AND AGP.ID_GRUPO_PROMOCION   = '''||Pn_IdPromocion||'''
                                          AND AGP.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                                          AND IDM.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                                          AND IPP.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                                          AND IPP.ESTADO               = '''||Pv_EstadoProceso||'''
                                      GROUP BY IDM.ID_DETALLE_MAPEO, IPP.ID_PROCESO_PROMO, IDM.ESTADO, IPP.ESTADO
                                      )';
        ELSE
            Lcl_SqlFrom := ' FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
                    DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDM,
                    DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDS,
                    DB_EXTERNO.INFO_PROCESO_PROMO IPP,
                    DB_COMERCIAL.INFO_PLAN_CAB PLA,
                    DB_COMERCIAL.INFO_PLAN_CAB PLN,
                    DB_COMERCIAL.INFO_SERVICIO SERVICIO,
                    DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE,
                    DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD,
                    DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR';
            Lcl_SqlWhere := ' WHERE AGP.ID_GRUPO_PROMOCION = IDM.GRUPO_PROMOCION_ID
                    AND IDM.ID_DETALLE_MAPEO     = IDS.DETALLE_MAPEO_ID
                    AND IDM.ID_DETALLE_MAPEO     = IPP.DETALLE_MAPEO_ID
                    AND IDS.PLAN_ID              = PLA.ID_PLAN
                    AND IDS.PLAN_ID_SUPERIOR     = PLN.ID_PLAN
                    AND IPP.NOMBRE_OLT           = ELE.NOMBRE_ELEMENTO
                    AND ELE.MODELO_ELEMENTO_ID   = MOD.ID_MODELO_ELEMENTO
                    AND MOD.MARCA_ELEMENTO_ID    = MAR.ID_MARCA_ELEMENTO
                    AND AGP.ID_GRUPO_PROMOCION   = '''||Pn_IdPromocion||'''
                    AND AGP.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                    AND IDM.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                    AND IPP.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                    AND IPP.ESTADO               = '''||Pv_EstadoProceso||'''
                    AND MAR.NOMBRE_MARCA_ELEMENTO = '''||Pv_Tecnologia||'''
                    AND ELE.ESTADO               = '''||Lv_Estado||'''
                    AND IPP.SERVICIO_ID          IS NOT NULL
                    AND SERVICIO.ID_SERVICIO     = IPP.SERVICIO_ID';
              Lcl_SqlRegistros := 'SELECT ID_DETALLE_MAPEO, ID_PROCESO_PROMO, ESTADO_MAPEO, ESTADO_PROMO
                                    FROM
                                        (SELECT IDM.ID_DETALLE_MAPEO, IPP.ID_PROCESO_PROMO, IDM.ESTADO ESTADO_MAPEO, IPP.ESTADO ESTADO_PROMO
                                        FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP,
                                            DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO IDM,
                                            DB_EXTERNO.INFO_PROCESO_PROMO IPP,
                                            DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE,
                                            DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MOD,
                                            DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MAR
                                        WHERE AGP.ID_GRUPO_PROMOCION     = IDM.GRUPO_PROMOCION_ID
                                            AND IDM.ID_DETALLE_MAPEO     = IPP.DETALLE_MAPEO_ID
                                            AND IPP.NOMBRE_OLT           = ELE.NOMBRE_ELEMENTO
                                            AND ELE.MODELO_ELEMENTO_ID   = MOD.ID_MODELO_ELEMENTO
                                            AND MOD.MARCA_ELEMENTO_ID    = MAR.ID_MARCA_ELEMENTO
                                            AND AGP.ID_GRUPO_PROMOCION   = '''||Pn_IdPromocion||'''
                                            AND MAR.NOMBRE_MARCA_ELEMENTO = '''||Pv_Tecnologia||'''
                                            AND AGP.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                                            AND IDM.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                                            AND IPP.EMPRESA_COD          = '''||Lv_CodEmpresa||'''
                                            AND IPP.ESTADO               = '''||Pv_EstadoProceso||'''
                                            AND ELE.ESTADO               = '''||Lv_Estado||'''
                                        GROUP BY IDM.ID_DETALLE_MAPEO, IPP.ID_PROCESO_PROMO, IDM.ESTADO, IPP.ESTADO
                                        )';
        END IF;
        Lcl_SqlCliente := 'SELECT SERVICIO_ID, ESTADO, PLAN_ACTUAL, PLAN_PROMO, PLAN_ID_ACTUAL, PLAN_ID_PROMO,
                FE_INICIO, FE_FIN, HORA_INICIO, HORA_FIN,
                DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_GET_LINE_PROFILE_PROMO_BW(PLAN_ID_PROMO) AS DATA_LINE_PROFILE
            FROM
                ( ' || Lcl_SqlSelect || Lcl_SqlFrom || Lcl_SqlWhere || ' 
                GROUP BY IPP.SERVICIO_ID,
                    SERVICIO.ESTADO,
                    PLA.NOMBRE_PLAN,
                    PLN.NOMBRE_PLAN,
                    PLA.ID_PLAN,
                    PLN.ID_PLAN,
                    AGP.FE_INICIO_VIGENCIA,
                    AGP.FE_FIN_VIGENCIA
                )';
        --
        OPEN C_ListaServiciosPromoAll FOR Lcl_SqlCliente;
        LOOP
            FETCH C_ListaServiciosPromoAll BULK COLLECT INTO Lr_ServicioPromo LIMIT 30000;
            EXIT WHEN Lr_ServicioPromo.COUNT() < 1;
            Ln_Index := Lr_ServicioPromo.FIRST;
            WHILE (Ln_Index IS NOT NULL) LOOP
                Lv_ObservacionPlanes := REPLACE(Pv_ForHistorial, '{{FE_INICIO}}', Lr_ServicioPromo(Ln_Index).FE_INICIO);
                Lv_ObservacionPlanes := REPLACE(Lv_ObservacionPlanes, '{{FE_FIN}}', Lr_ServicioPromo(Ln_Index).FE_FIN);
                Lv_ObservacionPlanes := REPLACE(Lv_ObservacionPlanes, '{{HORA_INICIO}}', Lr_ServicioPromo(Ln_Index).HORA_INICIO);
                Lv_ObservacionPlanes := REPLACE(Lv_ObservacionPlanes, '{{HORA_FIN}}', Lr_ServicioPromo(Ln_Index).HORA_FIN);
                Lv_ObservacionPlanes := REPLACE(Lv_ObservacionPlanes, '{{PLAN_ACTUAL}}', Lr_ServicioPromo(Ln_Index).PLAN_ACTUAL);
                Lv_ObservacionPlanes := REPLACE(Lv_ObservacionPlanes, '{{LINE_PROFILE_PROMO}}', Lr_ServicioPromo(Ln_Index).DATA_LINE_PROFILE);
                INSERT
                INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                (
                    ID_SERVICIO_HISTORIAL,
                    SERVICIO_ID,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    ESTADO,
                    MOTIVO_ID,
                    OBSERVACION,
                    ACCION
                )
                VALUES
                (
                    DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                    Lr_ServicioPromo(Ln_Index).SERVICIO_ID,
                    Lv_User,
                    SYSDATE,
                    Lv_Ip,
                    Lr_ServicioPromo(Ln_Index).ESTADO,
                    NULL,
                    Lv_ObservacionPlanes,
                    NULL
                );
                --se guardan los cambios
                COMMIT;
                Ln_Index := Lr_ServicioPromo.NEXT(Ln_Index);
            END LOOP;
        END LOOP;
        CLOSE C_ListaServiciosPromoAll;
        --
        IF Pv_Tipo = 'APLICAR' OR Pv_Tipo = 'QUITAR' THEN
            --
            IF C_ListaDetallesPromoAll%ISOPEN THEN
              CLOSE C_ListaDetallesPromoAll;
            END IF;
            --
            OPEN C_ListaDetallesPromoAll FOR Lcl_SqlRegistros;
            LOOP
                FETCH C_ListaDetallesPromoAll BULK COLLECT INTO Lr_DetallesPromo LIMIT 30000;
                EXIT WHEN Lr_DetallesPromo.COUNT() < 1;
                Ln_Index := Lr_DetallesPromo.FIRST;
                WHILE (Ln_Index IS NOT NULL) LOOP
                    INSERT INTO DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO
                    (
                        ID_DETALLE_MAPEO_HISTO,
                        DETALLE_MAPEO_ID,
                        ESTADO,
                        OBSERVACION,
                        FE_CREACION,
                        USR_CREACION,
                        IP_CREACION
                    )
                    VALUES
                    (
                        DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL,
                        Lr_DetallesPromo(Ln_Index).ID_DETALLE_MAPEO,
                        Lr_DetallesPromo(Ln_Index).ESTADO_MAPEO,
                        Pv_HistoProceso,
                        SYSDATE,
                        Lv_User,
                        Lv_Ip
                    );
                    INSERT INTO DB_EXTERNO.INFO_PROCESO_PROMO_HIST
                    (
                        ID_PROCESO_PROMO_HIST,
                        PROCESO_PROMO_ID,
                        ESTADO,
                        OBSERVACION,
                        FE_CREACION,
                        USR_CREACION,
                        IP_CREACION
                    )
                    VALUES
                    (
                        DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_HIST.NEXTVAL,
                        Lr_DetallesPromo(Ln_Index).ID_PROCESO_PROMO,
                        Lr_DetallesPromo(Ln_Index).ESTADO_PROMO,
                        Pv_HistoProceso,
                        SYSDATE,
                        Lv_User,
                        Lv_Ip
                    );
                    --se guardan los cambios
                    COMMIT;
                    Ln_Index := Lr_DetallesPromo.NEXT(Ln_Index);
                END LOOP;
            END LOOP;
            CLOSE C_ListaDetallesPromoAll;
        END IF;
    EXCEPTION
      WHEN OTHERS THEN
          --se reservan los cambios
          ROLLBACK;
          Lv_MsjResultado := 'Ocurrió un error al ingresar los historiales de promociones de ancho de banda: ';
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                               'CMKG_PROMOCIONES_BW.P_HISTO_CLIENTE_PROMO_BW',
                                               SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                               Lv_User,
                                               SYSDATE,
                                               Lv_Ip);
    END P_HISTO_CLIENTE_PROMO_BW;
----

    PROCEDURE P_PROCESAR_REG_PROMO_BW(Pn_IdSolicitud IN NUMBER)
    IS
        --
        Lv_NombreParametro       VARCHAR2(40) := 'PARAMETROS_PROMOCIONES_MASIVAS_BW';
        Lv_TipoAplicar           VARCHAR2(50) := 'APLICAR_PROMOCIONES';
        Lv_ParTipoCorreo         VARCHAR2(20) := 'CORREO';
        Lv_TipoSolicitud         VARCHAR2(100) := 'SOLICITUD PROCESAR PROMOCIONES BW MASIVO';
        Lv_CaractPromocion       VARCHAR2(60) := 'ID_GRUPO_PROMOCION';
        Lv_CaractDocumento       VARCHAR2(60) := 'ID_DOCUMENTO';
        Ln_IdDocumento           NUMBER;
        Lcl_JsonRespuesta        CLOB;
        Lv_Tipo                  VARCHAR2(30);
        Lv_IdPromocion           VARCHAR2(30);
        Ln_CountElementos        NUMBER;
        Lv_NombreOlt             VARCHAR2(100);
        Ln_CountPlanes           NUMBER;
        Ln_Index                 NUMBER;
        Lv_PlanActual            VARCHAR2(30);
        Lv_PlanPromo             VARCHAR2(30);
        Lv_ObservacionTipo       VARCHAR2(30);
        Lv_NombreGrupo           VARCHAR2(100);
        Ln_IdOlt                 NUMBER;
        Lv_EstadoOlt             VARCHAR2(30);
        Lv_MensajeOperacion      VARCHAR2(100);
        Lv_EstadoPromocion       VARCHAR2(20);
        Lv_EstadoMapeo           VARCHAR2(20);
        Lv_EstadoProceso         VARCHAR2(20);
        Lv_EstadoFinalPromocion  VARCHAR2(20);
        Lv_EstadoFinalMapeo      VARCHAR2(20);
        Lv_EstadoFinalProceso    VARCHAR2(20);
        Lv_EstadoProcesoError    VARCHAR2(20);
        Lv_EstadoSaveProceso     VARCHAR2(20);
        Lv_EstadoSaveMapeo       VARCHAR2(20);
        Lv_EstadoServicio        VARCHAR2(20);
        Ln_TotalPendientes       NUMBER;
        Ln_TotalCompletados      NUMBER;
        Lv_Remitente             VARCHAR2(50);
        Lv_TipoPlantilla         VARCHAR2(50);
        Lv_Asunto                VARCHAR2(200);
        Lv_PrefijoEmpresa        VARCHAR2(5)  := 'MD';
        Lv_CodEmpresa            VARCHAR2(5)  := '18';
        Lv_EstadoPendiente       VARCHAR2(20) := 'Pendiente';
        Lv_EstadoFinalizada      VARCHAR2(20) := 'Finalizada';
        Lv_Estado                VARCHAR2(20) := 'Activo';
        Lv_User                  VARCHAR2(20) := 'telcos_promo_bw';
        Lv_Ip                    VARCHAR2(20) := '127.0.0.1';
        Lv_MsjResultado          VARCHAR2(4000);
        Lv_ObservacionPlanes     VARCHAR2(500);
        Lv_Observacion           VARCHAR2(500);
        Lv_StatusResult          VARCHAR2(10);
        Lv_MsgResult             VARCHAR2(500);
        Le_RegException          EXCEPTION;
        Le_MyException           EXCEPTION;
        --
        Lc_GetAliasPlantilla     DB_FINANCIERO.FNKG_TYPES.Lr_AliasPlantilla;
        --
        CURSOR C_ObtenerDatos IS
          SELECT DOC.ID_DOCUMENTO
          FROM DB_COMUNICACION.INFO_DOCUMENTO DOC,
            DB_COMERCIAL.INFO_DETALLE_SOLICITUD SOL,
            DB_COMERCIAL.INFO_DETALLE_SOL_CARACT CDOC,
            DB_COMERCIAL.INFO_DETALLE_SOL_CARACT CPRO
          WHERE EXISTS (
              SELECT 1 FROM DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIP
              WHERE TIP.DESCRIPCION_SOLICITUD = Lv_TipoSolicitud
              AND TIP.ID_TIPO_SOLICITUD = SOL.TIPO_SOLICITUD_ID
              AND TIP.ESTADO = Lv_Estado
          )
          AND CDOC.DETALLE_SOLICITUD_ID = SOL.ID_DETALLE_SOLICITUD
          AND CPRO.DETALLE_SOLICITUD_ID = SOL.ID_DETALLE_SOLICITUD
          AND EXISTS (
              SELECT 1 FROM DB_COMERCIAL.ADMI_CARACTERISTICA C
              WHERE C.DESCRIPCION_CARACTERISTICA = Lv_CaractDocumento
              AND C.ID_CARACTERISTICA = CDOC.CARACTERISTICA_ID
              AND C.ESTADO = Lv_Estado
          )
          AND EXISTS (
              SELECT 1 FROM DB_COMERCIAL.ADMI_CARACTERISTICA C
              WHERE C.DESCRIPCION_CARACTERISTICA = Lv_CaractPromocion
              AND C.ID_CARACTERISTICA = CPRO.CARACTERISTICA_ID
              AND C.ESTADO = Lv_Estado
          )
          AND SOL.ID_DETALLE_SOLICITUD = Pn_IdSolicitud
          AND DOC.ID_DOCUMENTO         = CDOC.VALOR
          AND SOL.ESTADO  = Lv_EstadoPendiente
          AND CDOC.ESTADO = Lv_EstadoPendiente
          AND CPRO.ESTADO = Lv_EstadoPendiente
          AND DOC.ESTADO  = Lv_Estado
          AND ROWNUM = 1;
        --
        CURSOR C_ObtenerJson IS
          SELECT MENSAJE FROM DB_COMUNICACION.INFO_DOCUMENTO WHERE ID_DOCUMENTO = Ln_IdDocumento;
        --
        CURSOR C_DatosPromo IS
            SELECT AGP.NOMBRE_GRUPO FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION AGP
            WHERE AGP.ID_GRUPO_PROMOCION = Lv_IdPromocion
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa;
        --
        CURSOR C_ObtenerDatosOlt(Cv_NombreOlt VARCHAR2) IS
            SELECT ELE.ID_ELEMENTO, ELE.ESTADO 
            FROM DB_INFRAESTRUCTURA.INFO_ELEMENTO ELE
            WHERE ELE.NOMBRE_ELEMENTO = Cv_NombreOlt
            AND ELE.ESTADO = Lv_Estado
            AND EXISTS (
                SELECT 1
                FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION          AGP,
                      DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDM,
                      DB_EXTERNO.INFO_PROCESO_PROMO             IPP
                WHERE AGP.ID_GRUPO_PROMOCION = IDM.GRUPO_PROMOCION_ID
                  AND IDM.ID_DETALLE_MAPEO   = IPP.DETALLE_MAPEO_ID
                  AND IPP.NOMBRE_OLT         = ELE.NOMBRE_ELEMENTO
                  AND AGP.ID_GRUPO_PROMOCION = Lv_IdPromocion
                  AND AGP.EMPRESA_COD = Lv_CodEmpresa
                  AND IDM.EMPRESA_COD = Lv_CodEmpresa
                  AND IPP.EMPRESA_COD = Lv_CodEmpresa
                  AND IDM.ESTADO = Lv_EstadoMapeo
                  AND IPP.ESTADO IN (Lv_EstadoProceso,Lv_EstadoProcesoError)
            );
        --
        CURSOR C_ObtenerParametros IS
            SELECT VALOR1, VALOR2, VALOR3, VALOR4, VALOR5, VALOR6, VALOR7, OBSERVACION FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Lv_Tipo AND ROWNUM = 1;
        --
        CURSOR C_ObtenerParametrosCorreo IS
            SELECT VALOR2, VALOR3, VALOR4 FROM DB_GENERAL.ADMI_PARAMETRO_DET
            WHERE ESTADO = Lv_Estado AND PARAMETRO_ID = ( SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB
                WHERE NOMBRE_PARAMETRO = Lv_NombreParametro AND ESTADO = Lv_Estado AND ROWNUM = 1)
            AND DESCRIPCION = Lv_ParTipoCorreo AND VALOR1 = Lv_Tipo AND ROWNUM = 1;
        --
        CURSOR C_ListaDetallesPromo(Cv_NombreOlt VARCHAR2,Cv_LineProfileOrigin VARCHAR2,Cv_LineProfilePromo VARCHAR2) IS
            SELECT ID_DETALLE_MAPEO, ID_MAPEO_SOLICITUD, ID_PROCESO_PROMO, SERVICIO_ID FROM (
                SELECT IDM.ID_DETALLE_MAPEO, IDS.ID_MAPEO_SOLICITUD, IPP.ID_PROCESO_PROMO, IPP.SERVICIO_ID
                FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION          AGP,
                      DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDM,
                      DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDS,
                      DB_EXTERNO.INFO_PROCESO_PROMO             IPP
                WHERE AGP.ID_GRUPO_PROMOCION = IDM.GRUPO_PROMOCION_ID
                      AND IDM.ID_DETALLE_MAPEO     = IDS.DETALLE_MAPEO_ID
                      AND IDM.ID_DETALLE_MAPEO     = IPP.DETALLE_MAPEO_ID
                      AND AGP.ID_GRUPO_PROMOCION   = Lv_IdPromocion
                      AND IPP.NOMBRE_OLT           = Cv_NombreOlt
                      AND EXISTS(
                          SELECT 1
                          FROM DB_COMERCIAL.ADMI_GRUPO_PROMOCION           AGP1,
                                DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO     IDM1,
                                DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD IDS1,
                                DB_EXTERNO.INFO_PROCESO_PROMO             IPP1
                          WHERE AGP1.ID_GRUPO_PROMOCION = IDM1.GRUPO_PROMOCION_ID
                                AND IDM1.ID_DETALLE_MAPEO     = IDS1.DETALLE_MAPEO_ID
                                AND IDM1.ID_DETALLE_MAPEO     = IPP1.DETALLE_MAPEO_ID
                                AND DB_COMERCIAL.CMKG_PROMOCIONES_UTIL.F_COMPARAR_PLAN_PROMO_BW(IDS.PLAN_ID,IDS1.PLAN_ID) = 'SI'
                                AND IDS.PLAN_ID_SUPERIOR      = IDS1.PLAN_ID_SUPERIOR
                                AND UPPER(IPP1.LINE_PROFILE_ORIGIN) = UPPER(Cv_LineProfileOrigin)
                                AND UPPER(IPP1.LINE_PROFILE_PROMO)  = UPPER(Cv_LineProfilePromo)
                                AND AGP1.ID_GRUPO_PROMOCION   = Lv_IdPromocion
                                AND AGP1.EMPRESA_COD = Lv_CodEmpresa
                                AND IDM1.EMPRESA_COD = Lv_CodEmpresa
                                AND IPP1.EMPRESA_COD = Lv_CodEmpresa
                                AND ROWNUM = 1
                      )
                      AND AGP.EMPRESA_COD = Lv_CodEmpresa
                      AND IDM.EMPRESA_COD = Lv_CodEmpresa
                      AND IPP.EMPRESA_COD = Lv_CodEmpresa
                      AND IDM.ESTADO = Lv_EstadoMapeo
                      AND IPP.ESTADO IN (Lv_EstadoProceso,Lv_EstadoProcesoError)
                GROUP BY IDM.ID_DETALLE_MAPEO, IDS.ID_MAPEO_SOLICITUD, IPP.ID_PROCESO_PROMO, IPP.SERVICIO_ID
            );
        TYPE Ltl_PromoDetalles IS TABLE OF C_ListaDetallesPromo%ROWTYPE;
        Lr_RegistrosDetalles      Ltl_PromoDetalles;
        --
        TYPE T_DataServicios IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        Lr_DataServicios          T_DataServicios;
        --
    BEGIN
        --
        --obtengo datos
        IF C_ObtenerDatos%ISOPEN THEN
          CLOSE C_ObtenerDatos;
        END IF;
        OPEN C_ObtenerDatos;
        FETCH C_ObtenerDatos INTO Ln_IdDocumento;
        CLOSE C_ObtenerDatos;
        --
        --obtengo json
        IF C_ObtenerJson%ISOPEN THEN
          CLOSE C_ObtenerJson;
        END IF;
        OPEN C_ObtenerJson;
        FETCH C_ObtenerJson INTO Lcl_JsonRespuesta;
        CLOSE C_ObtenerJson;
        --
        --Pn_IdPromocion
        APEX_JSON.PARSE(Lcl_JsonRespuesta);
        Lv_Tipo        := APEX_JSON.GET_VARCHAR2(p_path => 'opcion');
        Lv_IdPromocion := APEX_JSON.GET_VARCHAR2(p_path => 'id_promo');
        Ln_CountElementos := APEX_JSON.GET_COUNT(P_PATH => 'elemento');
        --
        --obtengo datos de la promocion
        IF C_DatosPromo%ISOPEN THEN
          CLOSE C_DatosPromo;
        END IF;
        OPEN C_DatosPromo;
        FETCH C_DatosPromo INTO Lv_NombreGrupo;
        CLOSE C_DatosPromo;
        IF Lv_NombreGrupo IS NULL THEN
            Lv_MsjResultado := 'Error no se pudo obtener los datos de la promoción de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --obtengo los datos de parametros
        IF C_ObtenerParametros%ISOPEN THEN
          CLOSE C_ObtenerParametros;
        END IF;
        OPEN C_ObtenerParametros;
        FETCH C_ObtenerParametros INTO Lv_EstadoPromocion, Lv_EstadoMapeo, Lv_EstadoProceso, Lv_EstadoFinalPromocion,
                                    Lv_EstadoFinalMapeo, Lv_EstadoFinalProceso, Lv_EstadoProcesoError, Lv_MensajeOperacion;
        CLOSE C_ObtenerParametros;
        --
        IF Lv_MensajeOperacion IS NULL
          OR Lv_EstadoPromocion IS NULL OR Lv_EstadoMapeo IS NULL OR Lv_EstadoProceso IS NULL OR Lv_EstadoProcesoError IS NULL
          OR Lv_EstadoFinalPromocion IS NULL OR Lv_EstadoFinalMapeo IS NULL OR Lv_EstadoFinalProceso IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Lv_Tipo||') de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        --obtengo los datos de parametros
        IF C_ObtenerParametrosCorreo%ISOPEN THEN
          CLOSE C_ObtenerParametrosCorreo;
        END IF;
        OPEN C_ObtenerParametrosCorreo;
        FETCH C_ObtenerParametrosCorreo INTO Lv_Remitente, Lv_TipoPlantilla, Lv_Asunto;
        CLOSE C_ObtenerParametrosCorreo;
        --
        IF Lv_Remitente IS NULL OR Lv_TipoPlantilla IS NULL OR Lv_Asunto IS NULL THEN
            Lv_MsjResultado := 'No se encontrarón los datos('||Lv_Tipo||') de parámetros para las promociones de ancho de banda.';
            RAISE Le_MyException;
        END IF;
        --
        IF C_ObtenerDatosOlt%ISOPEN THEN
          CLOSE C_ObtenerDatosOlt;
        END IF;
        --
        IF Ln_CountElementos > 0 THEN
            FOR Ln_ContadorElemento IN 1 .. Ln_CountElementos LOOP
                Lv_NombreOlt   := APEX_JSON.GET_VARCHAR2(P_PATH => 'elemento[%d].nombre_olt', p0 => Ln_ContadorElemento);
                BEGIN
                    --obtener datos olt
                    OPEN C_ObtenerDatosOlt(Lv_NombreOlt);
                    FETCH C_ObtenerDatosOlt INTO Ln_IdOlt, Lv_EstadoOlt;
                    CLOSE C_ObtenerDatosOlt;
                    IF Ln_IdOlt IS NULL OR Lv_EstadoOlt IS NULL THEN
                        Lv_MsjResultado := 'Error no se pudo obtener los datos del elemento('||Lv_NombreOlt||') de la promoción de ancho de banda.';
                        RAISE Le_RegException;
                    END IF;
                    --
                    Ln_CountPlanes := APEX_JSON.GET_COUNT(P_PATH => 'elemento[%d].planes', p0 => Ln_ContadorElemento);
                    IF Ln_CountPlanes > 0 THEN
                        FOR I IN 1 .. Ln_CountPlanes LOOP
                            Lv_StatusResult := APEX_JSON.GET_VARCHAR2(p_path => 'elemento[%d].planes[%d].status_plan', p0 => Ln_ContadorElemento, p1 => I);
                            Lv_MsgResult    := APEX_JSON.GET_VARCHAR2(p_path => 'elemento[%d].planes[%d].mensaje', p0 => Ln_ContadorElemento, p1 => I);
                            Lv_PlanActual   := APEX_JSON.GET_VARCHAR2(p_path => 'elemento[%d].planes[%d].plan', p0 => Ln_ContadorElemento, p1 => I);
                            Lv_PlanPromo    := APEX_JSON.GET_VARCHAR2(p_path => 'elemento[%d].planes[%d].plan_promo', p0 => Ln_ContadorElemento, p1 => I);
                            --observacion
                            Lv_ObservacionPlanes := '<br><b>PLAN:</b>';
                            Lv_ObservacionPlanes := Lv_ObservacionPlanes || '<br><b>PLAN ACTUAL:</b> ' || Lv_PlanActual;
                            Lv_ObservacionPlanes := Lv_ObservacionPlanes || '<br><b>PLAN PROMO:</b> ' || Lv_PlanPromo;
                            --
                            IF Lv_StatusResult != 'OK' THEN
                                --seteo historial
                                IF Lv_Tipo = Lv_TipoAplicar THEN
                                    Lv_ObservacionTipo := 'el cambio de plan';
                                ELSE
                                    Lv_ObservacionTipo := 'la finalización';
                                END IF;
                                --ingresar historial elemento
                                Lv_MsjResultado := 'Error en '||Lv_ObservacionTipo||' de la promoción de ancho de banda.'
                                                  ||'<br><b>Grupo Promoción:</b> '||Lv_IdPromocion
                                                  ||'<br><b>Mensaje:</b> '||Lv_MsgResult
                                                  ||Lv_ObservacionPlanes;
                                INSERT INTO DB_INFRAESTRUCTURA.INFO_HISTORIAL_ELEMENTO
                                ( ID_HISTORIAL,ELEMENTO_ID,ESTADO_ELEMENTO,OBSERVACION,USR_CREACION,FE_CREACION,IP_CREACION )
                                VALUES
                                ( DB_INFRAESTRUCTURA.SEQ_INFO_HISTORIAL_ELEMENTO.NEXTVAL,Ln_IdOlt,Lv_EstadoOlt,
                                  Lv_MsjResultado,Lv_User,SYSDATE,Lv_Ip );
                                --ingresar historial
                                Lv_MsjResultado := 'Error en '||Lv_ObservacionTipo||' de la promoción de ancho de banda del elemento '||Lv_NombreOlt||'.'
                                                    ||'<br><b>Mensaje:</b> '||Lv_MsgResult
                                                    ||Lv_ObservacionPlanes;
                                INSERT INTO DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
                                ( ID_GRUPO_PROMOCION_HISTO,GRUPO_PROMOCION_ID,MOTIVO_ID,ESTADO,OBSERVACION,USR_CREACION,FE_CREACION,IP_CREACION )
                                VALUES
                                ( DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL,Lv_IdPromocion,NULL,Lv_EstadoPromocion,
                                  Lv_MsjResultado,Lv_User,SYSDATE,Lv_Ip );
                                --se guardan los cambios
                                COMMIT;
                            END IF;
                            --
                            OPEN C_ListaDetallesPromo(Lv_NombreOlt,Lv_PlanActual,Lv_PlanPromo);
                            LOOP
                                FETCH C_ListaDetallesPromo BULK COLLECT INTO Lr_RegistrosDetalles LIMIT 30000;
                                EXIT WHEN Lr_RegistrosDetalles.COUNT() < 1;
                                Ln_Index := Lr_RegistrosDetalles.FIRST;
                                WHILE (Ln_Index IS NOT NULL) LOOP
                                    --setear mensaje
                                    IF Lv_StatusResult = 'OK' THEN
                                        Lv_EstadoSaveMapeo   := Lv_EstadoFinalMapeo;
                                        Lv_EstadoSaveProceso := Lv_EstadoFinalProceso;
                                        Lv_Observacion       := Lv_MensajeOperacion;
                                    ELSE
                                        Lv_EstadoSaveMapeo   := Lv_EstadoMapeo;
                                        Lv_EstadoSaveProceso := Lv_EstadoProcesoError;
                                        Lv_Observacion       := Lv_MsgResult;
                                    END IF;
                                    --actualizar estado
                                    UPDATE DB_EXTERNO.INFO_PROCESO_PROMO SET ESTADO = Lv_EstadoSaveProceso
                                      WHERE ID_PROCESO_PROMO = Lr_RegistrosDetalles(Ln_Index).ID_PROCESO_PROMO;
                                    UPDATE DB_COMERCIAL.INFO_DETALLE_MAPEO_PROMO SET ESTADO = Lv_EstadoSaveMapeo
                                      WHERE ID_DETALLE_MAPEO = Lr_RegistrosDetalles(Ln_Index).ID_DETALLE_MAPEO;
                                    UPDATE DB_COMERCIAL.INFO_DETALLE_MAPEO_SOLICITUD SET ESTADO = Lv_EstadoSaveMapeo
                                      WHERE ID_MAPEO_SOLICITUD = Lr_RegistrosDetalles(Ln_Index).ID_MAPEO_SOLICITUD;
                                    --
                                    INSERT INTO DB_COMERCIAL.INFO_DETALLE_MAPEO_HISTO
                                    (
                                        ID_DETALLE_MAPEO_HISTO,
                                        DETALLE_MAPEO_ID,
                                        ESTADO,
                                        OBSERVACION,
                                        FE_CREACION,
                                        USR_CREACION,
                                        IP_CREACION
                                    )
                                    VALUES
                                    (
                                        DB_COMERCIAL.SEQ_INFO_DETALLE_MAPEO_HISTO.NEXTVAL,
                                        Lr_RegistrosDetalles(Ln_Index).ID_DETALLE_MAPEO,
                                        Lv_EstadoMapeo,
                                        Lv_Observacion,
                                        SYSDATE,
                                        Lv_User,
                                        Lv_Ip
                                    );
                                    --
                                    INSERT INTO DB_EXTERNO.INFO_PROCESO_PROMO_HIST
                                    (
                                        ID_PROCESO_PROMO_HIST,
                                        PROCESO_PROMO_ID,
                                        ESTADO,
                                        OBSERVACION,
                                        FE_CREACION,
                                        USR_CREACION,
                                        IP_CREACION
                                    )
                                    VALUES
                                    (
                                        DB_EXTERNO.SEQ_INFO_PROCESO_PROMO_HIST.NEXTVAL,
                                        Lr_RegistrosDetalles(Ln_Index).ID_PROCESO_PROMO,
                                        Lv_EstadoSaveProceso,
                                        Lv_Observacion,
                                        SYSDATE,
                                        Lv_User,
                                        Lv_Ip
                                    );
                                    --
                                    IF Lv_StatusResult = 'OK' AND Lr_RegistrosDetalles(Ln_Index).SERVICIO_ID IS NOT NULL
                                      AND NOT Lr_DataServicios.EXISTS(Lr_RegistrosDetalles(Ln_Index).SERVICIO_ID) THEN
                                        Lr_DataServicios(Lr_RegistrosDetalles(Ln_Index).SERVICIO_ID) := 1;
                                        SELECT ESTADO INTO Lv_EstadoServicio FROM DB_COMERCIAL.INFO_SERVICIO
                                        WHERE ID_SERVICIO = Lr_RegistrosDetalles(Ln_Index).SERVICIO_ID;
                                        INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                                        (
                                            ID_SERVICIO_HISTORIAL,
                                            SERVICIO_ID,
                                            USR_CREACION,
                                            FE_CREACION,
                                            IP_CREACION,
                                            ESTADO,
                                            MOTIVO_ID,
                                            OBSERVACION,
                                            ACCION
                                        )
                                        VALUES
                                        (
                                            DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL,
                                            Lr_RegistrosDetalles(Ln_Index).SERVICIO_ID,
                                            Lv_User,
                                            SYSDATE,
                                            Lv_Ip,
                                            Lv_EstadoServicio,
                                            NULL,
                                            Lv_Observacion,
                                            NULL
                                        );
                                    END IF;
                                    --se guardan los cambios
                                    COMMIT;
                                    Ln_Index := Lr_RegistrosDetalles.NEXT(Ln_Index);
                                END LOOP;
                            END LOOP;
                            CLOSE C_ListaDetallesPromo;
                        END LOOP;
                    END IF;
                EXCEPTION
                  WHEN Le_RegException THEN
                      --se reservan los cambios
                      ROLLBACK;
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                          'CMKG_PROMOCIONES_BW.P_PROCESAR_REG_PROMO_BW',
                                                          SUBSTR(Lv_MsjResultado,0,4000),
                                                          Lv_User,
                                                          SYSDATE,
                                                          Lv_Ip);
                  WHEN OTHERS THEN
                      --se reservan los cambios
                      ROLLBACK;
                      Lv_MsjResultado := 'Ocurrió un error al ejecutar las promociones de ancho de banda: ';
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                          'CMKG_PROMOCIONES_BW.P_PROCESAR_REG_PROMO_BW',
                                                          SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                          Lv_User,
                                                          SYSDATE,
                                                          Lv_Ip);
                END;
            END LOOP;
            --
            --obtengo el total de pendientes
            Ln_TotalPendientes  := DB_COMERCIAL.CMKG_PROMOCIONES_BW.F_CONTADOR_PROCESOS_PROMO_BW(Lv_IdPromocion,
                                                                                                 Lv_Tipo,
                                                                                                 false);
            --obtengo el total confirmados
            Ln_TotalCompletados := DB_COMERCIAL.CMKG_PROMOCIONES_BW.F_CONTADOR_PROCESOS_PROMO_BW(Lv_IdPromocion,
                                                                                                 Lv_Tipo,
                                                                                                 true);
            --
            --verificar
            IF Ln_TotalPendientes = 0 AND Ln_TotalCompletados > 0 THEN
                --actualizar estado
                UPDATE DB_COMERCIAL.ADMI_GRUPO_PROMOCION SET ESTADO = Lv_EstadoFinalPromocion WHERE ID_GRUPO_PROMOCION = Lv_IdPromocion;
                --ingresar historial
                INSERT INTO DB_COMERCIAL.ADMI_GRUPO_PROMOCION_HISTO
                ( ID_GRUPO_PROMOCION_HISTO,GRUPO_PROMOCION_ID,MOTIVO_ID,ESTADO,OBSERVACION,USR_CREACION,FE_CREACION,IP_CREACION )
                VALUES
                ( DB_COMERCIAL.SEQ_ADMI_GRUPO_PROMOCION_HISTO.NEXTVAL,Lv_IdPromocion,NULL,Lv_EstadoFinalPromocion,
                  Lv_MensajeOperacion,Lv_User,SYSDATE,Lv_Ip );
                --guardar cambios
                COMMIT;
                --
                --enviar correo
                BEGIN
                    Lv_Asunto := REPLACE(Lv_Asunto, ':ID_PROMOCION', Lv_IdPromocion);
                    Lc_GetAliasPlantilla := DB_FINANCIERO.FNCK_CONSULTS.F_GET_ALIAS_PLANTILLA(Lv_TipoPlantilla);
                    Lc_GetAliasPlantilla.PLANTILLA := REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{ID_PROMOCION}}', Lv_IdPromocion);
                    Lc_GetAliasPlantilla.PLANTILLA := REPLACE(Lc_GetAliasPlantilla.PLANTILLA, '{{NOMBRE_GRUPO}}', Lv_NombreGrupo);
                    DB_GENERAL.GNRLPCK_UTIL.P_SEND_MAIL_SMTP(Lv_Remitente,
                                                            Lc_GetAliasPlantilla.ALIAS_CORREOS,
                                                            ';',
                                                            Lv_Asunto,
                                                            Lc_GetAliasPlantilla.PLANTILLA,
                                                            'text/html; charset=iso-8859-1',
                                                            NULL,
                                                            NULL);
                  EXCEPTION
                    WHEN OTHERS THEN
                      Lv_MsjResultado := 'Ocurrió un error al enviar el correo del procesamiento de las promociones de ancho de banda: ';
                      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                          'CMKG_PROMOCIONES_BW.P_PROCESAR_REG_PROMO_BW',
                                                          SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                          Lv_User,
                                                          SYSDATE,
                                                          Lv_Ip);
                END;
            END IF;
        END IF;
        --
        --finalizar solicitud
        UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD SET ESTADO = Lv_EstadoFinalizada WHERE ID_DETALLE_SOLICITUD = Pn_IdSolicitud;
        --finalizar caracteristica de la solicitud
        UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_CARACT SET ESTADO = Lv_EstadoFinalizada WHERE DETALLE_SOLICITUD_ID = Pn_IdSolicitud;
        --ingreso el historial de la solicitud
        INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
        ( ID_SOLICITUD_HISTORIAL,DETALLE_SOLICITUD_ID,OBSERVACION,ESTADO,USR_CREACION,FE_CREACION,IP_CREACION )
        VALUES
        ( DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL,Pn_IdSolicitud,
          'Se finalizó la solicitud del procesamiento de la promoción.',Lv_EstadoFinalizada,Lv_User,SYSDATE,Lv_Ip );
        --guardar cambios
        COMMIT;
        --
      EXCEPTION
        WHEN Le_MyException THEN
            --se reservan los cambios
            ROLLBACK;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                'CMKG_PROMOCIONES_BW.P_PROCESAR_REG_PROMO_BW',
                                                SUBSTR(Lv_MsjResultado,0,4000),
                                                Lv_User,
                                                SYSDATE,
                                                Lv_Ip);
        WHEN OTHERS THEN
            --se reservan los cambios
            ROLLBACK;
            Lv_MsjResultado := 'Ocurrió un error al ejecutar las promociones de ancho de banda: ';
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+',
                                                 'CMKG_PROMOCIONES_BW.P_PROCESAR_REG_PROMO_BW',
                                                 SUBSTR(Lv_MsjResultado || SQLCODE || ' -ERROR- ' || SQLERRM,0,4000),
                                                 Lv_User,
                                                 SYSDATE,
                                                 Lv_Ip);
    END P_PROCESAR_REG_PROMO_BW;
----
END CMKG_PROMOCIONES_BW;
/
