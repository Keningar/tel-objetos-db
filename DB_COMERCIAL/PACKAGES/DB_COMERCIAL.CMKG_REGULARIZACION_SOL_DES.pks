CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_REGULARIZACION_SOL_DES
AS
  /**
  * Documentación para PROCEDURE 'P_REGULARIZACION_SOL_DESC_T'.
  *
  * Proceso de ejecución diaria a travez de un JOB para la regularizacion
  * de solicitudes de descuento
  *
  *
  * PARAMETROS:
  * No aplica
  *
  * @author Jose Cruz <jfcruzc@telconet.ec>
  * @version 1.0 07-09-2022
  */
  PROCEDURE P_REGULARIZACION_SOL_DESC_T;
END CMKG_REGULARIZACION_SOL_DES;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_REGULARIZACION_SOL_DES
AS
  PROCEDURE P_REGULARIZACION_SOL_DESC_T
  IS
    Ln_IdDetalleSol     NUMBER;
    Ln_IdMotivo         NUMBER;
    Ln_ValorDesc        NUMBER;
    Ln_ValorDescAntes   NUMBER;
    Ln_IdCaracteristica NUMBER;
    Ln_ValorPlan        NUMBER;
    LCv_UsrCreacion     VARCHAR2(16) := 'regSolDescuentoT';
    Lcl_ObservHistorialServ CLOB;
    Ln_PorcentajeDescAntes  NUMBER;
    Ln_PorcentajeDescuento  NUMBER;
    LCn_CantidadServicio    NUMBER := 1;
    Lv_MsjError             VARCHAR2(260);
    LCv_MensajePaquete      VARCHAR2(8000);
    LCv_MensajeErrorPaquete VARCHAR2(8000);
    Ln_PlnNoSolDescuento    NUMBER := 0;
    Ln_DetSolCar            NUMBER := 0;
    Ln_DetSolHis            NUMBER := 0;
    CURSOR Lc_GetPlnNoSolDescuento
    IS
      SELECT ISER.PLAN_ID,
        PUNTO.LOGIN,
        ISER.ID_SERVICIO,
        PLAN.ID_PLAN,
        PLAN.NOMBRE_PLAN ,
        ISER.VALOR_DESCUENTO,
        ISER.PORCENTAJE_DESCUENTO,
        ISER.PRECIO_VENTA
      FROM DB_COMERCIAL.INFO_SERVICIO ISER
      INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
      ON PUNTO.ID_PUNTO = ISER.PUNTO_ID
      INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN
      ON PLAN.ID_PLAN           = ISER.PLAN_ID
      WHERE ISER.ESTADO        IN ('Activo','In-Corte')
      AND PUNTO.ESTADO         IN ('Activo','In-Corte')
      AND ISER.VALOR_DESCUENTO  >0
      AND ISER.PRODUCTO_ID     IS NULL
      AND ISER.TIPO_ORDEN       = 'T'
      AND ISER.ID_SERVICIO      = DB_COMERCIAL.GET_ID_SERVICIO_PREF(PUNTO.ID_PUNTO)
      AND ISER.ID_SERVICIO NOT IN
        (SELECT IDS.SERVICIO_ID
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
        WHERE IDS.TIPO_SOLICITUD_ID=2
        );
    CURSOR Lc_GetServicioPrevio(Cn_ServicioId IN NUMBER)
    IS
      SELECT *
      FROM
        (SELECT ISER.PLAN_ID,
          PUNTO.LOGIN,
          ISER.ID_SERVICIO,
          PLAN.ID_PLAN,
          PLAN.NOMBRE_PLAN ,
          ISER.VALOR_DESCUENTO,
          ISER.PORCENTAJE_DESCUENTO,
          ISER.PRECIO_VENTA
        FROM DB_COMERCIAL.INFO_SERVICIO ISER
        INNER JOIN DB_COMERCIAL.INFO_PUNTO PUNTO
        ON PUNTO.ID_PUNTO = ISER.PUNTO_ID
        INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PLAN
        ON PLAN.ID_PLAN        = ISER.PLAN_ID
        WHERE ISER.ID_SERVICIO = Cn_ServicioId
        )
    WHERE ROWNUM = 1;
    CURSOR Lc_GetSolServiPrevio(Cn_ServicioId IN NUMBER)
    IS
      SELECT *
      FROM
        (SELECT CARACT.DESCRIPCION_CARACTERISTICA,
          CARACT.TIPO,
          SPC.VALOR,
          SPC.ESTADO AS ESTADO_SPC
        FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA APC
        INNER JOIN DB_COMERCIAL.ADMI_CARACTERISTICA CARACT
        ON CARACT.ID_CARACTERISTICA = APC.CARACTERISTICA_ID
        INNER JOIN DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT SPC
        ON SPC.PRODUCTO_CARACTERISITICA_ID    = APC.ID_PRODUCTO_CARACTERISITICA
        WHERE SPC.SERVICIO_ID                 = Cn_ServicioId
        AND CARACT.DESCRIPCION_CARACTERISTICA = 'TRASLADO'
        AND SPC.ESTADO                        = 'Eliminado'
        ORDER BY SPC.FE_CREACION DESC
        )
    WHERE ROWNUM = 1;
    CURSOR Lc_GetIdCaracteristica
    IS
      SELECT AC.ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA AC
      WHERE AC.DESCRIPCION_CARACTERISTICA = 'DESCUENTO TOTALIZADO FACT'
      AND AC.ESTADO                       = 'Activo';
    CURSOR Lc_GetValorPlan(Cv_PlanId IN NUMBER)
    IS
      SELECT SUM(PD.PRECIO_ITEM)
      FROM DB_COMERCIAL.INFO_PLAN_DET PD
      INNER JOIN DB_COMERCIAL.INFO_PLAN_CAB PB
      ON PD.PLAN_ID    = PB.ID_PLAN
      WHERE PD.PLAN_ID = Cv_PlanId
      AND PB.ESTADO    = PD.ESTADO;
    CURSOR Lc_GetSolicitud(Cn_ServicioId IN NUMBER)
    IS
      SELECT *
      FROM
        (SELECT IDT.*
        FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDT
        INNER JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD TIPO_SOL
        ON TIPO_SOL.ID_TIPO_SOLICITUD      = IDT.TIPO_SOLICITUD_ID
        WHERE IDT.SERVICIO_ID              = Cn_ServicioId
        AND TIPO_SOL.DESCRIPCION_SOLICITUD = 'SOLICITUD DESCUENTO'
        AND IDT.ESTADO                    IN ('Aprobado', 'Finalizada')
        ORDER BY IDT.ID_DETALLE_SOLICITUD DESC
        )
    WHERE ROWNUM = 1;
    CURSOR Lc_GetDetSolCar(Cn_DetalleId IN NUMBER)
    IS
      SELECT IDST.*
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT IDST
      WHERE IDST.DETALLE_SOLICITUD_ID = Cn_DetalleId;
    CURSOR Lc_GetDetSolHis(Cn_DetalleId IN NUMBER)
    IS
      SELECT IDST.*
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST IDST
      WHERE IDST.DETALLE_SOLICITUD_ID = Cn_DetalleId;
    CURSOR Lc_GetEmpresaDt(Cv_PlanId IN NUMBER)
    IS
      SELECT IEG.PREFIJO,
        IEG.COD_EMPRESA
      FROM DB_COMERCIAL.INFO_PLAN_CAB IFPC
      INNER JOIN DB_COMERCIAL.INFO_EMPRESA_GRUPO IEG
      ON IFPC.EMPRESA_COD = IEG.COD_EMPRESA
      WHERE IFPC.ID_PLAN  = Cv_PlanId;
    Lr_PlnNoSolDescuento Lc_GetPlnNoSolDescuento%ROWTYPE;
    Lr_SolServiPrevio Lc_GetSolServiPrevio%ROWTYPE;
    Lr_ServicioPrevio Lc_GetServicioPrevio%ROWTYPE;
    Lr_SolicitudDes Lc_GetSolicitud%ROWTYPE;
    Lr_DetSolCar Lc_GetDetSolCar%ROWTYPE;
    Lr_DetSolHis Lc_GetDetSolHis%ROWTYPE;
    Lr_EmpresaDt Lc_GetEmpresaDt%ROWTYPE;
    TYPE t_PlnNoSolDescuento IS
    TABLE OF Lc_GetPlnNoSolDescuento%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE t_DetSolCar IS TABLE OF Lc_GetDetSolCar%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE t_DetSolHis IS TABLE OF Lc_GetDetSolHis%ROWTYPE INDEX BY PLS_INTEGER;
    Lt_PlnNoSolDescuento t_PlnNoSolDescuento;
    Lt_DetSolCar t_DetSolCar;
    Lt_DetSolHis t_DetSolHis;
  BEGIN
    OPEN Lc_GetIdCaracteristica;
    FETCH Lc_GetIdCaracteristica INTO Ln_IdCaracteristica;
    CLOSE Lc_GetIdCaracteristica;
    OPEN Lc_GetPlnNoSolDescuento;
    LOOP
      FETCH Lc_GetPlnNoSolDescuento BULK COLLECT
      INTO Lt_PlnNoSolDescuento LIMIT 1000;
      Ln_PlnNoSolDescuento        := Lt_PlnNoSolDescuento.FIRST;
      WHILE (Ln_PlnNoSolDescuento IS NOT NULL)
      LOOP
        Lr_PlnNoSolDescuento   := Lt_PlnNoSolDescuento(Ln_PlnNoSolDescuento);
        Lr_SolServiPrevio      := NULL;
        Lr_ServicioPrevio      := NULL;
        Ln_ValorDescAntes      := Lr_PlnNoSolDescuento.VALOR_DESCUENTO;
        Ln_ValorDesc           := Lr_PlnNoSolDescuento.VALOR_DESCUENTO;
        Ln_PorcentajeDescAntes := Lr_PlnNoSolDescuento.PORCENTAJE_DESCUENTO;
        Ln_PorcentajeDescuento := Lr_PlnNoSolDescuento.PORCENTAJE_DESCUENTO;
        OPEN Lc_GetSolServiPrevio(Lr_PlnNoSolDescuento.ID_SERVICIO);
        FETCH Lc_GetSolServiPrevio INTO Lr_SolServiPrevio;
        CLOSE Lc_GetSolServiPrevio;
        IF Lr_SolServiPrevio.VALOR IS NOT NULL THEN
          OPEN Lc_GetServicioPrevio(Lr_SolServiPrevio.VALOR);
          FETCH Lc_GetServicioPrevio INTO Lr_ServicioPrevio;
          CLOSE Lc_GetServicioPrevio;
        END IF;
        IF Lr_ServicioPrevio.ID_SERVICIO IS NOT NULL THEN
          Lr_SolicitudDes                := NULL;
          OPEN Lc_GetSolicitud(Lr_SolServiPrevio.VALOR);
          FETCH Lc_GetSolicitud INTO Lr_SolicitudDes;
          CLOSE Lc_GetSolicitud;
          Ln_ValorPlan                            := NULL;
          IF Lr_SolicitudDes.ID_DETALLE_SOLICITUD IS NOT NULL THEN
            Lcl_ObservHistorialServ	          := NULL;
            Ln_ValorDesc                          := Lr_SolicitudDes.PRECIO_DESCUENTO;
            Ln_PorcentajeDescuento                := Lr_SolicitudDes.PORCENTAJE_DESCUENTO;
            OPEN Lc_GetValorPlan(Lr_PlnNoSolDescuento.PLAN_ID);
            FETCH Lc_GetValorPlan INTO Ln_ValorPlan;
            CLOSE Lc_GetValorPlan;
            IF Lr_SolicitudDes.PORCENTAJE_DESCUENTO IS NOT NULL THEN
              Ln_ValorDesc                          := ROUND((LCn_CantidadServicio * Ln_ValorPlan * Lr_SolicitudDes.PORCENTAJE_DESCUENTO/100),2);
            END IF;
            Ln_IdDetalleSol := DB_COMERCIAL.SEQ_INFO_DETALLE_SOLICITUD.nextval;
            INSERT
            INTO DB_COMERCIAL.INFO_DETALLE_SOLICITUD
              (
                ID_DETALLE_SOLICITUD,
                SERVICIO_ID,
                TIPO_SOLICITUD_ID,
                MOTIVO_ID,
                USR_CREACION,
                FE_CREACION,
                PRECIO_DESCUENTO,
                PORCENTAJE_DESCUENTO,
                TIPO_DOCUMENTO,
                OBSERVACION,
                ESTADO,
                USR_RECHAZO,
                FE_RECHAZO,
                DETALLE_PROCESO_ID,
                FE_EJECUCION,
                ELEMENTO_ID
              )
              VALUES
              (
                Ln_IdDetalleSol,
                Lr_PlnNoSolDescuento.ID_SERVICIO,
                Lr_SolicitudDes.TIPO_SOLICITUD_ID,
                Lr_SolicitudDes.MOTIVO_ID,
                LCv_UsrCreacion,
                SYSDATE,
                Lr_SolicitudDes.PRECIO_DESCUENTO,
                Lr_SolicitudDes.PORCENTAJE_DESCUENTO,
                Lr_SolicitudDes.TIPO_DOCUMENTO,
                Lr_SolicitudDes.OBSERVACION,
                Lr_SolicitudDes.ESTADO,
                NULL,
                NULL,
                Lr_SolicitudDes.DETALLE_PROCESO_ID,
                Lr_SolicitudDes.FE_EJECUCION,
                Lr_SolicitudDes.ELEMENTO_ID
              );
            OPEN Lc_GetDetSolCar(Lr_SolicitudDes.ID_DETALLE_SOLICITUD);
            LOOP
              FETCH Lc_GetDetSolCar BULK COLLECT INTO Lt_DetSolCar LIMIT 1000;
              Ln_DetSolCar        := Lt_DetSolCar.FIRST;
              WHILE (Ln_DetSolCar IS NOT NULL)
              LOOP
                Lr_DetSolCar := Lt_DetSolCar(Ln_DetSolCar);
                INSERT
                INTO DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
                  (
                    ID_SOLICITUD_CARACTERISTICA,
                    CARACTERISTICA_ID,
                    VALOR,
                    DETALLE_SOLICITUD_ID,
                    ESTADO,
                    USR_CREACION,
                    USR_ULT_MOD,
                    FE_CREACION,
                    FE_ULT_MOD,
                    DETALLE_SOL_CARACT_ID
                  )
                  VALUES
                  (
                    DB_COMERCIAL.SEQ_INFO_DET_SOL_CARACT.nextval,
                    Ln_IdCaracteristica,
                    Lr_DetSolCar.VALOR,
                    Ln_IdDetalleSol,
                    Lr_DetSolCar.ESTADO,
                    Lr_DetSolCar.USR_CREACION,
                    Lr_DetSolCar.USR_ULT_MOD,
                    Lr_DetSolCar.FE_CREACION,
                    Lr_DetSolCar.FE_ULT_MOD,
                    Lr_DetSolCar.DETALLE_SOL_CARACT_ID
                  );
                Ln_DetSolCar := Lt_DetSolCar.NEXT(Ln_DetSolCar);
              END LOOP;
              EXIT
            WHEN Lc_GetDetSolCar%NOTFOUND;
            END LOOP;
            CLOSE Lc_GetDetSolCar;
            OPEN Lc_GetDetSolHis(Lr_SolicitudDes.ID_DETALLE_SOLICITUD);
            LOOP
              FETCH Lc_GetDetSolHis BULK COLLECT INTO Lt_DetSolHis LIMIT 1000;
              Ln_DetSolHis        := Lt_DetSolHis.FIRST;
              WHILE (Ln_DetSolHis IS NOT NULL)
              LOOP
                Lr_DetSolHis := Lt_DetSolHis(Ln_DetSolHis);
                INSERT
                INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST
                  (
                    ID_SOLICITUD_HISTORIAL,
                    DETALLE_SOLICITUD_ID,
                    ESTADO,
                    FE_INI_PLAN,
                    FE_FIN_PLAN,
                    OBSERVACION,
                    USR_CREACION,
                    FE_CREACION,
                    IP_CREACION,
                    MOTIVO_ID
                  )
                  VALUES
                  (
                    DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.nextval,
                    Ln_IdDetalleSol,
                    Lr_DetSolHis.ESTADO,
                    Lr_DetSolHis.FE_INI_PLAN,
                    Lr_DetSolHis.FE_FIN_PLAN,
                    Lr_DetSolHis.OBSERVACION,
                    Lr_DetSolHis.USR_CREACION,
                    Lr_DetSolHis.FE_CREACION,
                    Lr_DetSolHis.IP_CREACION,
                    Lr_DetSolHis.MOTIVO_ID
                  );
                Ln_DetSolHis := Lt_DetSolHis.NEXT(Ln_DetSolHis);
              END LOOP;
              EXIT
            WHEN Lc_GetDetSolHis%NOTFOUND;
            END LOOP;
            CLOSE Lc_GetDetSolHis;
            UPDATE DB_COMERCIAL.INFO_SERVICIO SER
            SET SER.PORCENTAJE_DESCUENTO = Ln_PorcentajeDescuento,
              SER.VALOR_DESCUENTO        = Ln_ValorDesc,
              SER.DESCUENTO_UNITARIO     = Ln_ValorDesc
            WHERE SER.ID_SERVICIO        = Lr_PlnNoSolDescuento.ID_SERVICIO;
            IF Ln_PorcentajeDescuento    > 0 THEN
              Lcl_ObservHistorialServ :=  'Se crea la solicitud de descuento de forma automática por traslado: ' || ' <br> ' || 
                                          'Precio venta: <b>' || Lr_PlnNoSolDescuento.PRECIO_VENTA || '</b>,<br> ' || 
                                          'Descuento: <b>' || Ln_PorcentajeDescuento || '%</b>,<br> ' || 
                                          'Valor descuento: <b>' || Ln_ValorDesc || '</b>';
            ELSE
              Lcl_ObservHistorialServ :=  'Se crea la solicitud de descuento de forma automática por traslado: ' || ' <br> ' || 
                                          'Precio venta: <b>' || Lr_PlnNoSolDescuento.PRECIO_VENTA || '</b>,<br> ' || 
                                          'Valor descuento: <b>' || Ln_ValorDesc || '</b>';
            END IF;
            
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
                DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.nextval,
                Lr_PlnNoSolDescuento.ID_SERVICIO,
                LCv_UsrCreacion,
                SYSDATE,
                '127.0.0.1',
                'Activo',
                NULL,
                Lcl_ObservHistorialServ,
                NULL
              );
            
            OPEN Lc_GetEmpresaDt(Lr_PlnNoSolDescuento.PLAN_ID);
            FETCH Lc_GetEmpresaDt INTO Lr_EmpresaDt;
            CLOSE Lc_GetEmpresaDt;
            IF Lr_EmpresaDt.PREFIJO IS NOT NULL THEN
              DB_COMERCIAL.CMKG_BENEFICIOS.P_RECALCULO( Lr_EmpresaDt.COD_EMPRESA, 
                                                        Lr_EmpresaDt.PREFIJO, 
                                                        'regSolDescuentoT',
                                                        NULL, 
                                                        Lr_PlnNoSolDescuento.ID_SERVICIO, 
                                                        'INDIVIDUAL', 
                                                        LCv_MensajePaquete, 
                                                        LCv_MensajeErrorPaquete);
            END IF;
            COMMIT;
          END IF;
        END IF;
        Ln_PlnNoSolDescuento := Lt_PlnNoSolDescuento.NEXT(Ln_PlnNoSolDescuento);
      END LOOP;
      EXIT
    WHEN Lc_GetPlnNoSolDescuento%NOTFOUND;
    END LOOP;
  CLOSE Lc_GetPlnNoSolDescuento;
  EXCEPTION
  WHEN OTHERS THEN
    Lv_MsjError := 'Error en la ejecución del PROCESO DE REGULARIZACION DIARIA de servicios con descuento sin solicitudes de descuento ' 
                    || SQLCODE || ' - ERROR_STACK: ' || DBMS_UTILITY.FORMAT_ERROR_STACK 
                    || ' - ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( 'Telcos+', 
                                          'CMKG_REGULARIZACION_SOL_DES.P_REGULARIZACION_SOL_DESC_T', 
                                          Lv_MsjError, 
                                          NVL(SYS_CONTEXT('USERENV','HOST'), 'DB_COMERCIAL'), 
                                          SYSDATE, 
                                          NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                          '127.0.0.1') );
  END P_REGULARIZACION_SOL_DESC_T;
END CMKG_REGULARIZACION_SOL_DES;
/
