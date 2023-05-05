create or replace PROCEDURE            COP_GENERA_FLUJO_APROBACION(Pv_IdEmpresa    IN VARCHAR2,
                                        Pv_IdOrden      IN VARCHAR2,
                                        Pv_CodigoError  OUT VARCHAR2,
                                        Pv_MensajeError OUT VARCHAR2) IS
    --
    CURSOR C_LeeResponsable(Cv_IdEmpresa IN VARCHAR2,
                            Cv_IdOrden   IN VARCHAR2) IS
      SELECT OC.ADJUDICADOR,
             NVL(OC.TOTAL, 0) TOTAL_ORDEN,
             OC.MONTO,
             OC.FECHA,
             DECODE(OC.IND_NO_INV, 'S', 'SE', 'BI') ID_TIPO_TRANSACCION
        FROM TAPORDEE OC
       WHERE OC.NO_ORDEN = Cv_IdOrden
         AND OC.NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_LeeJefeEmpleado(Cv_IdEmpresa  IN VARCHAR2,
                             Cv_IdEmpleado IN VARCHAR2) IS
      SELECT ID_JEFE
        FROM ARPLME
       WHERE NO_EMPLE = Cv_IdEmpleado
         AND NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_LeeSecuencia(Cv_IdEmpresa IN VARCHAR2,
                          Cv_IdOrden   IN VARCHAR2) IS
      SELECT NVL(MAX(FA.SECUENCIA), 0)
        FROM CO_FLUJO_APROBACION FA
       WHERE ID_ORDEN = Cv_IdOrden
         AND ID_EMPRESA = Cv_IdEmpresa;
    --
    CURSOR C_LeeSecuenciaFlujo(Cv_IdEmpresa IN VARCHAR2,
                               Cv_IdOrden   IN VARCHAR2) IS
      SELECT NVL(MAX(FA.SECUENCIA_FLUJO), 0)
        FROM CO_FLUJO_APROBACION FA
       WHERE ID_ORDEN = Cv_IdOrden
         AND ESTADO <> 'EL'
         AND ID_EMPRESA = Cv_IdEmpresa;
    --
    CURSOR C_LeeUltimo(Cv_IdEmpresa IN VARCHAR2,
                       Cv_IdOrden   IN VARCHAR2) IS
      SELECT MAX(SECUENCIA) SECUENCIA
        FROM CO_FLUJO_APROBACION
       WHERE ID_ORDEN = Cv_IdOrden
         AND ID_EMPRESA = Cv_IdEmpresa;
    --
    CURSOR C_LeeGenerenteGer IS
      SELECT E.NO_EMPLE
        FROM ARPLME E
       WHERE E.PUESTO = 'GGRL'
         AND E.ESTADO = 'A'
         AND E.NO_CIA = Pv_IdEmpresa;
    --
    CURSOR C_LeeMontosAprobacion(Cv_IdEmpresa  IN VARCHAR2,
                                 Cv_IdEmpleado IN VARCHAR2, --Codigo Empleado
                                 Cv_IdTipoTrx  IN VARCHAR2) IS
      SELECT DISTINCT A.NO_EMPLE,
                      A.NO_CIA,
                      A.ID_JEFE,
                      NVL(B.MONTO_DESDE, 0) MONTO_DESDE,
                      NVL(B.MONTO_HASTA, 0) MONTO_HASTA,
                      A.NIVEL
        FROM (SELECT E.NO_CIA,
                     E.NO_EMPLE,
                     E.ID_JEFE,
                     LEVEL NIVEL
                FROM ARPLME E
               WHERE NO_CIA = Cv_IdEmpresa --'10'
                 AND E.ESTADO = 'A'
              CONNECT BY PRIOR ID_JEFE = NO_EMPLE
               START WITH NO_EMPLE = Cv_IdEmpleado --'1455'
               ORDER BY LEVEL) A,
             ARPLMA B
       WHERE A.NO_EMPLE = B.ID_EMPLEADO
         AND A.NO_CIA = B.NO_CIA
         AND B.ID_TIPO_TRANSACCION = Cv_IdTipoTrx
       ORDER BY A.NIVEL;
    --
    --
    CURSOR C_LeeMontosOrdenes(Cv_IdEmpresa        IN VARCHAR2,
                              Cv_IdOrden          IN VARCHAR2,
                              Cv_IdEmpleado       IN VARCHAR2,
                              Cd_FechaHasta       IN DATE,
                              Cv_IdTipoTransacion IN VARCHAR2) IS
      SELECT NVL(SUM(OC.TOTAL), 0)
        FROM TAPORDEE            OC,
             CO_FLUJO_APROBACION FA
       WHERE OC.NO_ORDEN = FA.ID_ORDEN
         AND OC.NO_CIA = FA.ID_EMPRESA
         AND OC.ESTADO NOT IN ('X', 'C', 'O')
         AND FA.ID_EMPLEADO = Cv_IdEmpleado --'557'
         AND FA.ESTADO IN ('PA', 'PU', 'AU')
         --AND OC.IND_NO_INV = DECODE(Cv_IdTipoTransacion, 'SE', 'S', 'N')
         AND OC.ID_TIPO_TRANSACCION=Cv_IdTipoTransacion
         AND OC.FECHA >= LAST_DAY(ADD_MONTHS(Cd_FechaHasta, -1)) + 1
         AND OC.FECHA <= Cd_FechaHasta
         AND OC.NO_CIA = Cv_IdEmpresa
         AND OC.NO_ORDEN <> Pv_IdOrden
       ORDER BY TO_NUMBER(OC.NO_ORDEN) DESC; --Cv_IdEmpresa;
    --
    CURSOR C_LeeOrden(Cv_IdEmpresa IN VARCHAR2,
                      Cv_IdOrden   IN VARCHAR2) IS
      SELECT OC.*
        FROM TAPORDEE OC
       WHERE OC.NO_ORDEN = Cv_IdOrden
         AND OC.NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_LeeAprobadores(Cv_IdEpresa          IN VARCHAR2,
                            Cv_IdEmpleado        IN VARCHAR2,
                            Cv_IdTipoTransaccion IN VARCHAR2) IS
      SELECT AP.*
        FROM ARPLMA AP
       WHERE AP.ID_TIPO_TRANSACCION = Cv_IdTipoTransaccion
         AND AP.ID_EMPLEADO = Cv_IdEmpleado
         AND AP.NO_CIA = Cv_IdEpresa;
    --
    CURSOR C_LeeFlujo(Cv_IdEmpresa IN VARCHAR2,
                      Cv_IdOrden   IN VARCHAR2) IS
      SELECT ID_EMPLEADO
        FROM CO_FLUJO_APROBACION
       WHERE ID_ORDEN = Cv_IdOrden
         AND ESTADO <> 'EL'
         AND ID_EMPRESA = Cv_IdEmpresa;
    --
    CURSOR C_LeeMontoSinFlujos(Cv_IdEmpresa          IN VARCHAR2,
                               Cv_IdEmpleado        IN VARCHAR2,
                               Cv_IdTipoTransaccion IN VARCHAR2) IS
      SELECT E.MONTO_DESDE,
             E.MONTO_HASTA
        FROM ARPLMA E
       WHERE NO_CIA = Cv_IdEmpresa --'10'
         AND E.ID_EMPLEADO = Cv_IdEmpleado
         AND E.ID_TIPO_TRANSACCION = Cv_IdTipoTransaccion
         AND E.ESTADO = 'A';
  
    Lr_DatosOrdenes    C_LeeResponsable%ROWTYPE := NULL;
    Lv_IdJefeEmpleado  ARPLME.ID_JEFE%TYPE := NULL;
    Ln_Secuencia       CO_FLUJO_APROBACION.SECUENCIA%TYPE := NULL;
    Ln_SecuenciaFlujo  CO_FLUJO_APROBACION.SECUENCIA_FLUJO%TYPE := NULL;
    Lr_FlujoAprobacion CO_FLUJO_APROBACION%ROWTYPE := NULL;
    Lr_UltimoRegApro   C_LeeUltimo%ROWTYPE := NULL;
    Lr_Ordenes         TAPORDEE%ROWTYPE := NULL;
    --Ln_MontoAcumulado  NUMBER(17, 2) := 0;
    Ln_MontoOrden        NUMBER(17, 2) := 0;
    Lb_ExisteMonto       BOOLEAN := FALSE;
    Lb_ValidaTipoTrx     BOOLEAN := FALSE;
    Lr_AprobadorOtrasOrd ARPLMA%ROWTYPE := NULL;
    Lv_IdEmpleado        CO_FLUJO_APROBACION.ID_EMPLEADO%TYPE := NULL;
    Lr_FlujosSinAprob    C_LeeMontoSinFlujos%ROWTYPE:=NULL;
  
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El Codigo de la Empresa No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdOrden IS NULL THEN
      Pv_MensajeError := 'El Codigo de la Orden No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    --Elimino el flujo anterior
    COK_ORDENES_COMPRAS.COP_ELIMINA_FLUJO(Pv_IdEmpresa, --
                                          Pv_IdOrden,
                                          Pv_CodigoError,
                                          Pv_MensajeError);
    IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    IF C_LeeOrden%ISOPEN THEN
      CLOSE C_LeeOrden;
    END IF;
    OPEN C_LeeOrden(Pv_IdEmpresa, Pv_IdOrden);
    FETCH C_LeeOrden
      INTO Lr_Ordenes;
    CLOSE C_LeeOrden;
    --Abastecimiento y Recurrentes
    IF Lr_Ordenes.ID_TIPO_TRANSACCION IN ('AB', 'RE') THEN
    
      --
      Lv_IdJefeEmpleado := NULL;
      IF C_LeeJefeEmpleado%ISOPEN THEN
        CLOSE C_LeeJefeEmpleado;
      END IF;
      OPEN C_LeeJefeEmpleado(Pv_IdEmpresa, --
                             Lr_Ordenes.ADJUDICADOR);
      FETCH C_LeeJefeEmpleado
        INTO Lv_IdJefeEmpleado;
      CLOSE C_LeeJefeEmpleado;
      --
      Lr_AprobadorOtrasOrd := NULL;
      IF C_LeeAprobadores%ISOPEN THEN
        CLOSE C_LeeAprobadores;
      END IF;
      OPEN C_LeeAprobadores(Pv_IdEmpresa, --
                            Lv_IdJefeEmpleado,
                            Lr_Ordenes.ID_TIPO_TRANSACCION);
      FETCH C_LeeAprobadores
        INTO Lr_AprobadorOtrasOrd;
      CLOSE C_LeeAprobadores;
      --Ingresa Solicitante y valida al jefe
      IF Lr_AprobadorOtrasOrd.ID_EMPLEADO IS NOT NULL THEN
        Lb_ValidaTipoTrx := TRUE;
      END IF;
      --
      IF Lr_AprobadorOtrasOrd.ID_EMPLEADO IS NULL THEN
        Lr_AprobadorOtrasOrd := NULL;
        IF C_LeeAprobadores%ISOPEN THEN
          CLOSE C_LeeAprobadores;
        END IF;
        OPEN C_LeeAprobadores(Pv_IdEmpresa, --
                              Lr_Ordenes.ADJUDICADOR,
                              Lr_Ordenes.ID_TIPO_TRANSACCION);
        FETCH C_LeeAprobadores
          INTO Lr_AprobadorOtrasOrd;
        CLOSE C_LeeAprobadores;
        --Ingresa el Jefe
        IF Lr_AprobadorOtrasOrd.ID_EMPLEADO IS NOT NULL THEN
          Lb_ValidaTipoTrx := TRUE;
        END IF;
      END IF;
      --
      --
      IF NOT Lb_ValidaTipoTrx THEN
        Pv_MensajeError := 'El Adjudicador no tiene Flujo Configurado para el Tipo de Orden';
        RAISE Le_Error;
      END IF;
      --Inserta por las transacciones de Abastecimiento y Recurrentes
      IF Lb_ValidaTipoTrx THEN
        Ln_Secuencia      := 0;
        Ln_SecuenciaFlujo := 0;
        IF C_LeeSecuencia%ISOPEN THEN
          CLOSE C_LeeSecuencia;
        END IF;
        OPEN C_LeeSecuencia(Pv_IdEmpresa, --
                            Pv_IdOrden);
        FETCH C_LeeSecuencia
          INTO Ln_Secuencia;
        CLOSE C_LeeSecuencia;
        --
        IF C_LeeSecuenciaFlujo%ISOPEN THEN
          CLOSE C_LeeSecuenciaFlujo;
        END IF;
        OPEN C_LeeSecuenciaFlujo(Pv_IdEmpresa, --
                                 Pv_IdOrden);
        FETCH C_LeeSecuenciaFlujo
          INTO Ln_SecuenciaFlujo;
        CLOSE C_LeeSecuenciaFlujo;
      
        Lr_FlujoAprobacion                 := NULL;
        Ln_Secuencia                       := Ln_Secuencia + 1;
        Ln_SecuenciaFlujo                  := Ln_SecuenciaFlujo + 1;
        Lr_FlujoAprobacion.ID_EMPRESA      := Pv_IdEmpresa;
        Lr_FlujoAprobacion.SECUENCIA       := Ln_Secuencia;
        Lr_FlujoAprobacion.SECUENCIA_FLUJO := Ln_SecuenciaFlujo;
        Lr_FlujoAprobacion.ID_ORDEN        := Pv_IdOrden;
        -- Primero en aprobar es Jefe inmediato no configurado no montos
        Lr_FlujoAprobacion.ID_EMPLEADO           := Lr_AprobadorOtrasOrd.ID_EMPLEADO;
        Lr_FlujoAprobacion.ID_EMPLEADO_REEMPLAZO := NULL;
        Lr_FlujoAprobacion.FECHA                 := NULL;
        Lr_FlujoAprobacion.COMENTARIO            := NULL;
        Lr_FlujoAprobacion.USUARIO_CREA          := USER;
        Lr_FlujoAprobacion.FECHA_CREA            := SYSDATE;
        Lr_FlujoAprobacion.TIPO_FLUJO            := 'AU';
        Lr_FlujoAprobacion.Estado                := 'PU';
        --
        INSERT INTO CO_FLUJO_APROBACION
          (ID_EMPRESA,
           SECUENCIA,
           SECUENCIA_FLUJO,
           ID_EMPLEADO,
           ID_ORDEN,
           FECHA,
           COMENTARIO,
           USUARIO_CREA,
           FECHA_CREA,
           TIPO_FLUJO)
        VALUES
          (Lr_FlujoAprobacion.ID_EMPRESA,
           Lr_FlujoAprobacion.SECUENCIA,
           Lr_FlujoAprobacion.SECUENCIA_FLUJO,
           Lr_FlujoAprobacion.ID_EMPLEADO,
           Lr_FlujoAprobacion.ID_ORDEN,
           Lr_FlujoAprobacion.FECHA,
           Lr_FlujoAprobacion.COMENTARIO,
           Lr_FlujoAprobacion.USUARIO_CREA,
           Lr_FlujoAprobacion.FECHA_CREA,
           Lr_FlujoAprobacion.TIPO_FLUJO);
        --

        --
/*        IF C_LeeResponsable%ISOPEN THEN
          CLOSE C_LeeResponsable;
        END IF;
        OPEN C_LeeResponsable(Pv_IdEmpresa, Pv_IdOrden);
        FETCH C_LeeResponsable
          INTO Lr_DatosOrdenes;
        CLOSE C_LeeResponsable;*/
        --
        Ln_MontoOrden := 0;
        IF C_LeeMontosOrdenes%ISOPEN THEN
          CLOSE C_LeeMontosOrdenes;
        END IF;        
        --
        OPEN C_LeeMontosOrdenes(Pv_IdEmpresa, --
                                Pv_IdOrden,
                                Lr_AprobadorOtrasOrd.ID_EMPLEADO,
                                Lr_Ordenes.FECHA,
                                Lr_Ordenes.ID_TIPO_TRANSACCION);
        FETCH C_LeeMontosOrdenes
          INTO Ln_MontoOrden;
        CLOSE C_LeeMontosOrdenes;
        --
        IF C_LeeMontoSinFlujos%ISOPEN THEN CLOSE C_LeeMontoSinFlujos; END IF;
        OPEN C_LeeMontoSinFlujos(Pv_IdEmpresa,
                                 Lr_AprobadorOtrasOrd.ID_EMPLEADO,
                                 Lr_Ordenes.ID_TIPO_TRANSACCION);
        FETCH C_LeeMontoSinFlujos INTO Lr_FlujosSinAprob;
        CLOSE C_LeeMontoSinFlujos;
        --
        IF (Lr_Ordenes.Total + Ln_MontoOrden) >= Lr_FlujosSinAprob.MONTO_DESDE AND (Lr_Ordenes.Total + Ln_MontoOrden) <= Lr_FlujosSinAprob.MONTO_HASTA THEN
          NULL;
        ELSE
          --NO CUMPLE EL CUPO VA A LA GERENCIA GENERAL
          IF C_LeeGenerenteGer%ISOPEN THEN
            CLOSE C_LeeGenerenteGer;
          END IF;
          OPEN C_LeeGenerenteGer;
          FETCH C_LeeGenerenteGer
            INTO Lr_FlujoAprobacion.ID_EMPLEADO;
          CLOSE C_LeeGenerenteGer;
          --
          Ln_Secuencia      := 0;
          Ln_SecuenciaFlujo := 0;
          IF C_LeeSecuencia%ISOPEN THEN
            CLOSE C_LeeSecuencia;
          END IF;
          OPEN C_LeeSecuencia(Pv_IdEmpresa, --
                              Pv_IdOrden);
          FETCH C_LeeSecuencia
            INTO Ln_Secuencia;
          CLOSE C_LeeSecuencia;
          --
          IF C_LeeSecuenciaFlujo%ISOPEN THEN
            CLOSE C_LeeSecuenciaFlujo;
          END IF;
          OPEN C_LeeSecuenciaFlujo(Pv_IdEmpresa, --
                                   Pv_IdOrden);
          FETCH C_LeeSecuenciaFlujo
            INTO Ln_SecuenciaFlujo;
          CLOSE C_LeeSecuenciaFlujo;
          --
          Ln_Secuencia      := Ln_Secuencia + 1;
          Ln_SecuenciaFlujo := Ln_SecuenciaFlujo + 1;
          --
          INSERT INTO CO_FLUJO_APROBACION
            (ID_EMPRESA,
             SECUENCIA,
             SECUENCIA_FLUJO,
             ID_EMPLEADO,
             ID_ORDEN,
             FECHA,
             COMENTARIO,
             USUARIO_CREA,
             FECHA_CREA,
             TIPO_FLUJO)
          VALUES
            (Pv_IdEmpresa,
             Ln_Secuencia,
             Ln_SecuenciaFlujo,
             Lr_FlujoAprobacion.ID_EMPLEADO,
             Pv_IdOrden,
             NULL,
             NULL,
             USER,
             SYSDATE,
             'AU');
        END IF;
      END IF;
    END IF;
    /*    --Elimino el flujo anterior
    COK_ORDENES_COMPRAS.COP_ELIMINA_FLUJO(Pv_IdEmpresa, --
                                          Pv_IdOrden,
                                          Pv_CodigoError,
                                          Pv_MensajeError);
    IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;*/
    --
    IF NOT Lb_ValidaTipoTrx THEN
      --
      IF C_LeeResponsable%ISOPEN THEN
        CLOSE C_LeeResponsable;
      END IF;
      OPEN C_LeeResponsable(Pv_IdEmpresa, Pv_IdOrden);
      FETCH C_LeeResponsable
        INTO Lr_DatosOrdenes;
      CLOSE C_LeeResponsable;
      --Procedimiento que Inserta la aprobacion por bienes o servicios
      COK_ORDENES_COMPRAS.COP_EMPLEADO_REVISA_OC(Pv_IdEmpresa, --
                                                 Pv_IdOrden,
                                                 Pv_CodigoError,
                                                 Pv_MensajeError);
      IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    
      --
      IF C_LeeJefeEmpleado%ISOPEN THEN
        CLOSE C_LeeJefeEmpleado;
      END IF;
      OPEN C_LeeJefeEmpleado(Pv_IdEmpresa, --
                             Lr_DatosOrdenes.Adjudicador);
      FETCH C_LeeJefeEmpleado
        INTO Lv_IdJefeEmpleado;
      CLOSE C_LeeJefeEmpleado;
      --
      --
      Ln_Secuencia      := 0;
      Ln_SecuenciaFlujo := 0;
      IF C_LeeSecuencia%ISOPEN THEN
        CLOSE C_LeeSecuencia;
      END IF;
      OPEN C_LeeSecuencia(Pv_IdEmpresa, --
                          Pv_IdOrden);
      FETCH C_LeeSecuencia
        INTO Ln_Secuencia;
      CLOSE C_LeeSecuencia;
      --
      IF C_LeeSecuenciaFlujo%ISOPEN THEN
        CLOSE C_LeeSecuenciaFlujo;
      END IF;
      OPEN C_LeeSecuenciaFlujo(Pv_IdEmpresa, --
                               Pv_IdOrden);
      FETCH C_LeeSecuenciaFlujo
        INTO Ln_SecuenciaFlujo;
      CLOSE C_LeeSecuenciaFlujo;
      --
      --inserta el flujo de los GAN
      FOR A IN C_LeeMontosAprobacion(Pv_IdEmpresa, --
                                     Lr_DatosOrdenes.ADJUDICADOR,
                                     Lr_DatosOrdenes.ID_TIPO_TRANSACCION) LOOP
        IF A.NIVEL = 1 -- 1er nivel deberia ser Jefe Inmediato
           AND Lv_IdJefeEmpleado <> A.NO_EMPLE -- Si no es jefe inmediato de adjudicador
           AND A.NO_EMPLE != Lr_DatosOrdenes.ADJUDICADOR THEN
          -- y tampoco es el mismo adjudicador
          -- significa que jefe inmediato no se encuentra configurado con montos pero
          -- pero igual debe entrar en la aprobación
          Lr_FlujoAprobacion                 := NULL;
          Ln_Secuencia                       := Ln_Secuencia + 1;
          Ln_SecuenciaFlujo                  := Ln_SecuenciaFlujo + 1;
          Lr_FlujoAprobacion.ID_EMPRESA      := Pv_IdEmpresa;
          Lr_FlujoAprobacion.SECUENCIA       := Ln_Secuencia;
          Lr_FlujoAprobacion.SECUENCIA_FLUJO := Ln_SecuenciaFlujo;
          Lr_FlujoAprobacion.ID_ORDEN        := Pv_IdOrden;
          -- Primero en aprobar es Jefe inmediato no configurado no montos
          Lr_FlujoAprobacion.ID_EMPLEADO           := Lv_IdJefeEmpleado;
          Lr_FlujoAprobacion.ID_EMPLEADO_REEMPLAZO := NULL;
          Lr_FlujoAprobacion.FECHA                 := NULL;
          Lr_FlujoAprobacion.COMENTARIO            := NULL;
          Lr_FlujoAprobacion.USUARIO_CREA          := USER;
          Lr_FlujoAprobacion.FECHA_CREA            := SYSDATE;
          Lr_FlujoAprobacion.TIPO_FLUJO            := 'AP';
          --
          INSERT INTO CO_FLUJO_APROBACION
            (ID_EMPRESA,
             SECUENCIA,
             SECUENCIA_FLUJO,
             ID_EMPLEADO,
             ID_ORDEN,
             FECHA,
             COMENTARIO,
             USUARIO_CREA,
             FECHA_CREA,
             TIPO_FLUJO)
          VALUES
            (Lr_FlujoAprobacion.ID_EMPRESA,
             Lr_FlujoAprobacion.SECUENCIA,
             Lr_FlujoAprobacion.SECUENCIA_FLUJO,
             Lr_FlujoAprobacion.ID_EMPLEADO,
             Lr_FlujoAprobacion.ID_ORDEN,
             Lr_FlujoAprobacion.FECHA,
             Lr_FlujoAprobacion.COMENTARIO,
             Lr_FlujoAprobacion.USUARIO_CREA,
             Lr_FlujoAprobacion.FECHA_CREA,
             Lr_FlujoAprobacion.TIPO_FLUJO);
        END IF;
        --
        -- Se genera Flujo para primera persona del flujo de aprobación del adjudicador 
        -- configurado para aprobacion de montos.
        Lb_ExisteMonto                           := TRUE; --Si al menos existe un autorizador ya no tiene que insertar al gerente gerenal
        Lr_FlujoAprobacion                       := NULL;
        Ln_Secuencia                             := Ln_Secuencia + 1;
        Ln_SecuenciaFlujo                        := Ln_SecuenciaFlujo + 1;
        Lr_FlujoAprobacion.ID_EMPRESA            := Pv_IdEmpresa;
        Lr_FlujoAprobacion.SECUENCIA             := Ln_Secuencia;
        Lr_FlujoAprobacion.SECUENCIA_FLUJO       := Ln_SecuenciaFlujo;
        Lr_FlujoAprobacion.ID_ORDEN              := Pv_IdOrden;
        Lr_FlujoAprobacion.ID_EMPLEADO           := A.NO_EMPLE;
        Lr_FlujoAprobacion.ID_EMPLEADO_REEMPLAZO := NULL;
        Lr_FlujoAprobacion.FECHA                 := NULL;
        Lr_FlujoAprobacion.COMENTARIO            := NULL;
        Lr_FlujoAprobacion.USUARIO_CREA          := USER;
        Lr_FlujoAprobacion.FECHA_CREA            := SYSDATE;
        Lr_FlujoAprobacion.TIPO_FLUJO            := 'AP';
        --
        INSERT INTO CO_FLUJO_APROBACION
          (ID_EMPRESA,
           SECUENCIA,
           SECUENCIA_FLUJO,
           ID_EMPLEADO,
           ID_ORDEN,
           FECHA,
           COMENTARIO,
           USUARIO_CREA,
           FECHA_CREA,
           TIPO_FLUJO)
        VALUES
          (Lr_FlujoAprobacion.ID_EMPRESA,
           Lr_FlujoAprobacion.SECUENCIA,
           Lr_FlujoAprobacion.SECUENCIA_FLUJO,
           Lr_FlujoAprobacion.ID_EMPLEADO,
           Lr_FlujoAprobacion.ID_ORDEN,
           Lr_FlujoAprobacion.FECHA,
           Lr_FlujoAprobacion.COMENTARIO,
           Lr_FlujoAprobacion.USUARIO_CREA,
           Lr_FlujoAprobacion.FECHA_CREA,
           Lr_FlujoAprobacion.TIPO_FLUJO);
        --
        IF C_LeeMontosOrdenes%ISOPEN THEN
          CLOSE C_LeeMontosOrdenes;
        END IF;
        --
        OPEN C_LeeMontosOrdenes(Pv_IdEmpresa, --
                                Pv_IdOrden,
                                A.NO_EMPLE,
                                Lr_DatosOrdenes.FECHA,
                                Lr_DatosOrdenes.ID_TIPO_TRANSACCION);
        FETCH C_LeeMontosOrdenes
          INTO Ln_MontoOrden;
        CLOSE C_LeeMontosOrdenes;
        --
        IF (Lr_DatosOrdenes.TOTAL_ORDEN + Ln_MontoOrden) >= A.MONTO_DESDE AND (Lr_DatosOrdenes.TOTAL_ORDEN + Ln_MontoOrden) <= A.MONTO_HASTA THEN
          EXIT;
        END IF;
        --
      --
      
      END LOOP;
      IF C_LeeFlujo%ISOPEN THEN
        CLOSE C_LeeFlujo;
      END IF;
      OPEN C_LeeFlujo(Pv_IdEmpresa, Pv_IdOrden);
      FETCH C_LeeFlujo
        INTO Lv_IdEmpleado;
      CLOSE C_LeeFlujo;
    
      --IF NOT Lb_ExisteMonto THEN
      IF Lv_IdEmpleado IS NULL THEN
        --
        IF C_LeeGenerenteGer%ISOPEN THEN
          CLOSE C_LeeGenerenteGer;
        END IF;
        OPEN C_LeeGenerenteGer;
        FETCH C_LeeGenerenteGer
          INTO Lr_FlujoAprobacion.ID_EMPLEADO;
        CLOSE C_LeeGenerenteGer;
        --
        Ln_Secuencia      := Ln_Secuencia + 1;
        Ln_SecuenciaFlujo := Ln_SecuenciaFlujo + 1;
        --
        INSERT INTO CO_FLUJO_APROBACION
          (ID_EMPRESA,
           SECUENCIA,
           SECUENCIA_FLUJO,
           ID_EMPLEADO,
           ID_ORDEN,
           FECHA,
           COMENTARIO,
           USUARIO_CREA,
           FECHA_CREA,
           TIPO_FLUJO)
        VALUES
          (Pv_IdEmpresa,
           Ln_Secuencia,
           Ln_SecuenciaFlujo,
           Lr_FlujoAprobacion.ID_EMPLEADO,
           Pv_IdOrden,
           NULL,
           NULL,
           USER,
           SYSDATE,
           'AU');
        --
      END IF;
      --
      --
    END IF;
    IF C_LeeUltimo%ISOPEN THEN
      CLOSE C_LeeUltimo;
    END IF;
    OPEN C_LeeUltimo(Pv_IdEmpresa, Pv_IdOrden);
    FETCH C_LeeUltimo
      INTO Lr_UltimoRegApro;
    CLOSE C_LeeUltimo;
    --
    --
    UPDATE CO_FLUJO_APROBACION
       SET ESTADO     = 'PU',
           TIPO_FLUJO = 'AU'
     WHERE ID_ORDEN = Pv_IdOrden
       AND SECUENCIA = Lr_UltimoRegApro.SECUENCIA
       AND ID_EMPRESA = Pv_IdEmpresa;
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_GENERA_FLUJO_APROBACION ' || Pv_CodigoError || ' - ' || SQLERRM;
  END COP_GENERA_FLUJO_APROBACION;