CREATE OR REPLACE PACKAGE COK_ORDENES_COMPRAS AS
  --Genera el flujo de aprobacion de la orden de compra para bienes o servicios
  PROCEDURE COP_GENERA_FLUJO_APROBACION(Pv_IdEmpresa    IN VARCHAR2,
                                        Pv_IdOrden      IN VARCHAR2,
                                        Pv_CodigoError  OUT VARCHAR2,
                                        Pv_MensajeError OUT VARCHAR2);
  --
  --Corrige Flujo de Aprobacion de Ordenes de Compras
  PROCEDURE COP_APRUEBA_ORDEN(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdOrden      IN VARCHAR2,
                              Pv_IdEstado     OUT VARCHAR2,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2);

  --Corrige en el Flujo de Aprobacion de Ordenes de Compras
  PROCEDURE COP_CORRIGE_ORDEN(Pv_IdEmpresa      IN VARCHAR2,
                              Pv_IdOrden        IN VARCHAR2,
                              Pv_MotivoCorregir IN VARCHAR2,
                              Pv_CodigoError    OUT VARCHAR2,
                              Pv_MensajeError   OUT VARCHAR2);
  --
  --Rechaza en el  Flujo de Aprobacion de Ordenes de Compras
  PROCEDURE COP_RECHAZA_ORDEN(Pv_IdEmpresa     IN VARCHAR2,
                              Pv_IdOrden       IN VARCHAR2,
                              Pv_MotivoRechazo IN VARCHAR2,
                              Pv_CodigoError   OUT VARCHAR2,
                              Pv_MensajeError  OUT VARCHAR2);
  --
  --Cambia de Estado a EL- ELIMINADO el flujo de aprobacion de la orden
  PROCEDURE COP_ELIMINA_FLUJO(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdOrden      IN VARCHAR2,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2);

  --Genera Flujo de Pago Estimado Segun la frecuencia registrada
  PROCEDURE COP_GENERA_FLUJO_PAGO_ESTIMADO(Pv_IdEmpresa            IN VARCHAR2,
                                           Pv_IdOrden              IN VARCHAR2,
                                           Pv_IdTipoFrecuenciaPago IN VARCHAR2,
                                           Pn_NumeroFrecuencia     IN NUMBER,
                                           Pv_CodigoError          OUT VARCHAR2,
                                           Pv_MensajeError         OUT VARCHAR2);

  --Procedimiento que Inserta la aprobacion del responsable de Bodegas
  PROCEDURE COP_EMPLEADO_REVISA_OC(Pv_IdEmpresa    IN VARCHAR2,
                                   Pv_IdOrden      IN VARCHAR2,
                                   Pv_CodigoError  OUT VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2);
  --Procedimiento que corrige una OC por un autorizador o aprobador
  PROCEDURE COP_REVERSA_ORDEN(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdOrden      IN VARCHAR2,
                              Pv_Comentario   IN VARCHAR2,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2);

END;

/


CREATE OR REPLACE PACKAGE BODY COK_ORDENES_COMPRAS IS

  PROCEDURE COP_GENERA_FLUJO_APROBACION(Pv_IdEmpresa    IN VARCHAR2,
                                        Pv_IdOrden      IN VARCHAR2,
                                        Pv_CodigoError  OUT VARCHAR2,
                                        Pv_MensajeError OUT VARCHAR2) IS
    --
    --Lee el reemplazo del empleado
    
   CURSOR C_LeeReemplazo   (Cv_IdEmpresa  IN VARCHAR2,
                            Cv_IdEmpleado IN VARCHAR2) IS
      SELECT R.NO_EMPLE_REEMP
        FROM TAPHISTORICO_REEMPLAZOS R
       WHERE R.NO_CIA = Cv_IdEmpresa
         AND R.ACTIVO = 'A'
         AND TRUNC(SYSDATE) >= R.FECHA_DESDE
         AND TRUNC(SYSDATE) <= R.FECHA_HASTA
         AND R.NO_EMPLE = Cv_IdEmpleado;
    
    
    
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
  
    --Lee el jefe del solicitante
    CURSOR C_LeeJefeEmpleado(Cv_IdEmpresa  IN VARCHAR2,
                             Cv_IdEmpleado IN VARCHAR2) IS
      SELECT ID_JEFE
        FROM ARPLME
       WHERE NO_EMPLE = Cv_IdEmpleado
         AND NO_CIA = Cv_IdEmpresa;
  
    --Lee la secuencia maxima dl flujo de apobacion
    --para la generacion de un nuevo flujo de aprobacion
    CURSOR C_LeeSecuencia(Cv_IdEmpresa IN VARCHAR2,
                          Cv_IdOrden   IN VARCHAR2) IS
      SELECT NVL(MAX(FA.SECUENCIA), 0)
        FROM CO_FLUJO_APROBACION FA
       WHERE ID_ORDEN = Cv_IdOrden
         AND ID_EMPRESA = Cv_IdEmpresa;
    --Lee la secuencia maxima del flujo de aprobacion
    --para la generacion de un nuevo flujo de aprobacion    
    CURSOR C_LeeSecuenciaFlujo(Cv_IdEmpresa IN VARCHAR2,
                               Cv_IdOrden   IN VARCHAR2) IS
      SELECT NVL(MAX(FA.SECUENCIA_FLUJO), 0)
        FROM CO_FLUJO_APROBACION FA
       WHERE ID_ORDEN = Cv_IdOrden
         AND ESTADO <> 'EL'
         AND ID_EMPRESA = Cv_IdEmpresa;
  
    --Lee la ultima secuencia aprobacion
    CURSOR C_LeeUltimo(Cv_IdEmpresa IN VARCHAR2,
                       Cv_IdOrden   IN VARCHAR2) IS
      SELECT MAX(SECUENCIA) SECUENCIA
        FROM CO_FLUJO_APROBACION
       WHERE ID_ORDEN = Cv_IdOrden
         AND ID_EMPRESA = Cv_IdEmpresa;
  
    --Lee el generante general configurado
    CURSOR C_LeeGenerenteGer IS
      SELECT E.NO_EMPLE
        FROM ARPLME E
       WHERE E.PUESTO = 'GGRL'
         AND E.ESTADO = 'A'
         AND E.NO_CIA = Pv_IdEmpresa;
  
    --Lee el flujo de aprabacion por emresa TN
    CURSOR C_LeeMontosAprobacionTN(Cv_IdEmpresa  IN VARCHAR2,
                                   Cv_IdEmpleado IN VARCHAR2, --Codigo Empleado
                                   Cv_IdTipoTrx  IN VARCHAR2) IS
      SELECT A.NO_EMPLE,
             A.NO_CIA,
             A.ID_JEFE,
             NVL(B.MONTO_DESDE, 0) MONTO_DESDE,
             NVL(B.MONTO_HASTA, 0) MONTO_HASTA,
             NIVEL
        FROM (SELECT NO_CIA,
                     NO_EMPLE,
                     ID_JEFE,
                     LEVEL NIVEL
                FROM ARPLME
               WHERE NO_CIA = Cv_IdEmpresa
               START WITH NO_EMPLE = Cv_IdEmpleado
                      AND NO_CIA = Cv_IdEmpresa
              CONNECT BY PRIOR ID_JEFE = NO_EMPLE
                     AND NO_CIA = Cv_IdEmpresa) A,
             ARPLMA B
       WHERE A.NO_EMPLE = B.ID_EMPLEADO
         AND A.NO_CIA = B.NO_CIA
         AND B.ID_TIPO_TRANSACCION = Cv_IdTipoTrx
       ORDER BY NIVEL ASC;
  
    --Flujo de empleados para otras empresas
    CURSOR C_LeeMontosAprobacion(Cv_IdEmpresa  IN VARCHAR2,
                                 Cv_IdEmpleado IN VARCHAR2, --Codigo Empleado
                                 Cv_IdTipoTrx  IN VARCHAR2) IS
      SELECT A.NO_EMPLE,
             A.NO_CIA,
             A.ID_JEFE,
             NVL(B.MONTO_DESDE, 0) MONTO_DESDE,
             NVL(B.MONTO_HASTA, 0) MONTO_HASTA,
             NIVEL
        FROM (SELECT NO_CIA,
                     NO_EMPLE,
                     ID_JEFE,
                     LEVEL NIVEL
                FROM ARPLME
               WHERE NO_CIA = Cv_IdEmpresa
               START WITH NO_EMPLE = Cv_IdEmpleado
                      AND NO_CIA = Cv_IdEmpresa
              CONNECT BY PRIOR ID_JEFE = NO_EMPLE
                     AND NO_CIA = Cv_IdEmpresa
              UNION
              SELECT GE.ID_EMPRESA        NO_CIA,
                     GE.PARAMETRO_ALTERNO NO_EMPLE,
                     NULL                 ID_JEFE,
                     NULL                 NIVEL
                FROM GE_PARAMETROS GE
               WHERE GE.ID_EMPRESA = Cv_IdEmpresa
                 AND GE.ID_GRUPO_PARAMETRO = 'USUARIO_APRUEBA'
                 AND GE.ID_APLICACION = 'CO'
                 AND GE.ESTADO = 'A') A,
             ARPLMA B
       WHERE A.NO_EMPLE = B.ID_EMPLEADO
         AND A.NO_CIA = B.NO_CIA
         AND B.ID_TIPO_TRANSACCION = Cv_IdTipoTrx
       ORDER BY B.MONTO_HASTA ASC, NIVEL ASC;--06102014
  
    --Lee los montos de ordenes por perido
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
         AND OC.IND_NO_INV = DECODE(Cv_IdTipoTransacion, 'SE', 'S', 'N')
         AND OC.FECHA >= LAST_DAY(ADD_MONTHS(Cd_FechaHasta, -1)) + 1
         AND OC.FECHA <= Cd_FechaHasta
         AND OC.NO_CIA = Cv_IdEmpresa
         AND OC.NO_ORDEN <> Pv_IdOrden
       ORDER BY TO_NUMBER(OC.NO_ORDEN) DESC; --Cv_IdEmpresa;
    --Lee datos de ordenes
    CURSOR C_LeeOrden(Cv_IdEmpresa IN VARCHAR2,
                      Cv_IdOrden   IN VARCHAR2) IS
      SELECT OC.NO_CIA,
             OC.ID_TIPO_TRANSACCION,
             OC.ADJUDICADOR
        FROM TAPORDEE OC
       WHERE OC.NO_ORDEN = Cv_IdOrden
         AND OC.NO_CIA = Cv_IdEmpresa;
    --Lee aprobadores de la orden
    CURSOR C_LeeAprobadores(Cv_IdEpresa          IN VARCHAR2,
                            Cv_IdEmpleado        IN VARCHAR2,
                            Cv_IdTipoTransaccion IN VARCHAR2) IS
      SELECT AP.NO_CIA,
             AP.ID_EMPLEADO
        FROM ARPLMA AP
       WHERE AP.ID_TIPO_TRANSACCION = Cv_IdTipoTransaccion
         AND AP.ID_EMPLEADO = Cv_IdEmpleado
         AND AP.NO_CIA = Cv_IdEpresa;
  
    --Lee el flujo de emleado
    CURSOR C_LeeFlujo(Cv_IdEmpresa IN VARCHAR2,
                      Cv_IdOrden   IN VARCHAR2) IS
      SELECT ID_EMPLEADO
        FROM CO_FLUJO_APROBACION
       WHERE ID_ORDEN = Cv_IdOrden
         AND ESTADO <> 'EL'
         AND ID_EMPRESA = Cv_IdEmpresa;
  
    --Lee la configuracion del monto de aprobacion configurado
    CURSOR C_LeeAprobadorMonto(Cv_IdEmpresa IN VARCHAR2) IS
      SELECT GE.ID_EMPRESA,
             GE.ID_APLICACION
        FROM GE_GRUPOS_PARAMETROS GE
       WHERE GE.ID_APLICACION = 'CO'
         AND GE.ID_GRUPO_PARAMETRO = 'MONTO_APRUEBA'
         AND GE.ESTADO = 'A'
         AND GE.ID_EMPRESA = Cv_IdEmpresa;
  
    --Lee la emresa que peuede enviar notificaciones d la orden
    CURSOR C_LeeTipoFlujo IS
      SELECT CIA.NO_CIA,
             CIA.TIPO_FLUJO
        FROM TAPCIA CIA
       WHERE CIA.NO_CIA = Pv_IdEmpresa;
  
    Lr_Tapcia          C_LeeTipoFlujo%ROWTYPE := NULL;
    Lr_DatosOrdenes    C_LeeResponsable%ROWTYPE := NULL;
    Lv_IdJefeEmpleado  ARPLME.ID_JEFE%TYPE := NULL;
    Ln_Secuencia       CO_FLUJO_APROBACION.SECUENCIA%TYPE := NULL;
    Ln_SecuenciaFlujo  CO_FLUJO_APROBACION.SECUENCIA_FLUJO%TYPE := NULL;
    Lr_FlujoAprobacion CO_FLUJO_APROBACION%ROWTYPE := NULL;
    Lr_UltimoRegApro   C_LeeUltimo%ROWTYPE := NULL;
    Lr_Ordenes         C_LeeOrden%ROWTYPE := NULL;
    --Ln_MontoAcumulado  NUMBER(17, 2) := 0;
    Ln_MontoOrden        NUMBER(17, 2) := 0;
    Lb_ExisteMonto       BOOLEAN := FALSE;
    Lb_ValidaTipoTrx     BOOLEAN := FALSE;
    Lr_AprobadorOtrasOrd C_LeeAprobadores%ROWTYPE := NULL;
    Lv_IdEmpleado        CO_FLUJO_APROBACION.ID_EMPLEADO%TYPE := NULL;
    Lr_GrupoParametros   C_LeeAprobadorMonto%ROWTYPE := NULL;
    Lv_IdReemplazo       CO_FLUJO_APROBACION.ID_EMPLEADO_REEMPLAZO%TYPE := NULL;
    Lv_IdEmp             CO_FLUJO_APROBACION.ID_EMPLEADO%TYPE := NULL;
    
    
    Le_Error EXCEPTION;
    
  BEGIN
    COK_ORDENES_COMPRAS.COP_GENERA_FLUJO_APROBACION@GPOETNET(Pv_IdEmpresa,
                                        Pv_IdOrden,
                                        Pv_CodigoError,
                                        Pv_MensajeError);

    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_GENERA_FLUJO_APROBACION ' || Pv_CodigoError || ' - ' || SQLERRM;
  END COP_GENERA_FLUJO_APROBACION;

  --
  --Corrige Flujo de Aprobacion de Ordenes de Compras
  PROCEDURE COP_APRUEBA_ORDEN(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdOrden      IN VARCHAR2,
                              Pv_IdEstado     OUT VARCHAR2,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2) IS
    --Le el usuario conectado
    CURSOR C_LeeEmpleado(Cv_IdEmpresa IN VARCHAR2, --
                         Cv_IdUsuario IN VARCHAR2) IS
      SELECT ID_EMPLEADO
        FROM SEG47_TNET.TASGUSUARIO
       WHERE USUARIO = Cv_IdUsuario
         AND NO_CIA = Cv_IdEmpresa;
    --
    -- GRANT SELECT ON TASGUSUARIO TO NAF47_TNET;
    ---Lee el flujo de empleado
    CURSOR C_LeeFlujo(Cv_IdEmpresa   IN VARCHAR2, --
                      Cv_IdEmpleado  IN VARCHAR2,
                      Cv_IdEmplReemp IN VARCHAR2) IS
      SELECT B.ID_EMPRESA,
             B.ID_ORDEN,
             B.TIPO_FLUJO,
             A.SECUENCIA,
             B.SECUENCIA_FLUJO
        FROM CO_FLUJO_APROBACION B,
             (SELECT ID_EMPRESA,
                     SECUENCIA,
                     ID_EMPLEADO,
                     ESTADO,
                     SECUENCIA_FLUJO,
                     ID_ORDEN,
                     TIPO_FLUJO
                FROM CO_FLUJO_APROBACION
               WHERE ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmplReemp)
                 AND ID_EMPRESA = Pv_IdEmpresa
                 AND ESTADO IN ('PU', 'PA')) A
       WHERE A.ID_ORDEN = B.ID_ORDEN
         AND A.ID_EMPRESA = B.ID_EMPRESA
         AND B.ID_ORDEN = Pv_IdOrden
         AND (B.SECUENCIA_FLUJO = A.SECUENCIA_FLUJO - 1)
         AND (B.ESTADO = 'AP' OR A.TIPO_FLUJO != B.TIPO_FLUJO)
         AND B.ID_EMPRESA = Pv_IdEmpresa
         AND B.ESTADO NOT IN ('EL');
  
    --Lee el siguiente aprobador de la orden
    CURSOR C_LeeSiguienteflujo(Cv_IdEmpleado IN VARCHAR2,
                               Cn_Secuencia  IN NUMBER) IS
      SELECT SECUENCIA
        FROM CO_FLUJO_APROBACION
       WHERE ID_ORDEN = Pv_IdOrden
         AND SECUENCIA = Cn_Secuencia + 1
         AND ID_EMPRESA = Pv_IdEmpresa;
  
    --Lee el primer aprobador de la orden de compra
    CURSOR C_LeePrimerAprobador(Cv_IdEmpleado      IN VARCHAR2,
                                Cv_IdEmpleadoReemp IN VARCHAR2) IS
      SELECT SECUENCIA_FLUJO,
             SECUENCIA
        FROM CO_FLUJO_APROBACION
       WHERE ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmpleadoReemp)
         AND ESTADO IN ('PA', 'PU')
         AND ID_ORDEN = Pv_IdOrden
         AND ID_EMPRESA = Pv_IdEmpresa;
  
    --Lee el empleado de la orden
    CURSOR C_LeeEmpleadosOrden(Cv_IdEmpresa   IN VARCHAR2, ---
                               Cv_IdOrden     IN VARCHAR2,
                               Cv_IdEmpleado  IN VARCHAR2, ---
                               Cv_IdEmplReemp IN VARCHAR2) IS
      SELECT FA.ID_EMPRESA,
             FA.SECUENCIA_FLUJO,
             FA.SECUENCIA
        FROM CO_FLUJO_APROBACION FA
       WHERE FA.ID_ORDEN = Cv_IdOrden
         AND FA.ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmplReemp)
         AND FA.ESTADO IN ('PA', 'PU')
         AND FA.ID_EMPRESA = Cv_IdEmpresa
       ORDER BY FA.SECUENCIA ASC;
  
    Ln_SigFlujo        CO_FLUJO_APROBACION.SECUENCIA%TYPE := NULL;
    Lr_FlujoAprobacion C_LeeFlujo%ROWTYPE := NULL;
    Lr_Reemplazo       TAPHISTORICO_REEMPLAZOS%ROWTYPE := NULL;
    Lv_IdEmpleado      SEG47_TNET.TASGUSUARIO.ID_EMPLEADO%TYPE := NULL;
    --    Lv_IdEmpleadoReemp   TASGUSUARIO.ID_EMPLEADO%TYPE := NULL;
    Lv_EstadoFlujo       CO_FLUJO_APROBACION.ESTADO%TYPE := NULL;
    Lr_PrimerAutorizador C_LeePrimerAprobador%ROWTYPE := NULL;
    Ln_Contador          NUMBER(10) := 0;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El codigo de la Empresa No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdOrden IS NULL THEN
      Pv_MensajeError := 'El codigo de la Orden No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
  
    --
    IF C_LeeEmpleado%ISOPEN THEN
      CLOSE C_LeeEmpleado;
    END IF;
    OPEN C_LeeEmpleado(Pv_IdEmpresa, USER);
    FETCH C_LeeEmpleado
      INTO Lv_IdEmpleado;
    CLOSE C_LeeEmpleado;
    --
    PLK_CONSULTAS.CONSULTA_EMPLEADO(Pv_IdEmpresa, ---
                                    Lv_IdEmpleado,
                                    Lr_Reemplazo,
                                    Pv_CodigoError,
                                    Pv_MensajeError);
    --
    IF C_LeePrimerAprobador%ISOPEN THEN
      CLOSE C_LeePrimerAprobador;
    END IF;
    OPEN C_LeePrimerAprobador(Lv_IdEmpleado, Lr_Reemplazo.No_Emple_Reemp);
    FETCH C_LeePrimerAprobador
      INTO Lr_PrimerAutorizador;
    CLOSE C_LeePrimerAprobador;
  
    IF Lr_PrimerAutorizador.SECUENCIA_FLUJO = 1 THEN
      Lr_FlujoAprobacion.SECUENCIA := Lr_PrimerAutorizador.SECUENCIA;
    ELSE
      IF C_LeeFlujo%ISOPEN THEN
        CLOSE C_LeeFlujo;
      END IF;
      OPEN C_LeeFlujo(Pv_IdEmpresa, --
                      Lv_IdEmpleado,
                      Lr_Reemplazo.NO_EMPLE_REEMP);
      FETCH C_LeeFlujo
        INTO Lr_FlujoAprobacion;
      CLOSE C_LeeFlujo;
    END IF;
    --
    IF C_LeeSiguienteflujo%ISOPEN THEN
      CLOSE C_LeeSiguienteflujo;
    END IF;
    OPEN C_LeeSiguienteflujo(Lv_IdEmpleado, --
                             Lr_FlujoAprobacion.SECUENCIA);
    FETCH C_LeeSiguienteflujo
      INTO Ln_SigFlujo;
    IF C_LeeSiguienteflujo%FOUND THEN
      Pv_IdEstado    := 'P';
      Lv_EstadoFlujo := 'AP';
    ELSE
      Pv_IdEstado    := 'E';
      Lv_EstadoFlujo := 'AU';
      --
    END IF;
    CLOSE C_LeeSiguienteflujo;
    --
    IF Lr_Reemplazo.NO_EMPLE IS NULL THEN
      UPDATE CO_FLUJO_APROBACION FA
         SET FA.ESTADO            = Lv_EstadoFlujo,
             FA.USUARIO_ACTUALIZA = USER,
             FA.FECHA_ACTUALIZA   = SYSDATE,
             FA.FECHA             = SYSDATE
       WHERE FA.ID_ORDEN = Pv_IdOrden
         AND FA.SECUENCIA = Lr_FlujoAprobacion.SECUENCIA
         AND FA.ESTADO <> 'EL'
         AND FA.ID_EMPRESA = Pv_IdEmpresa;
    ELSE
      FOR A IN C_LeeEmpleadosOrden(Pv_IdEmpresa, ---
                                   Pv_IdOrden,
                                   Lv_IdEmpleado, ---
                                   Lr_Reemplazo.NO_EMPLE) LOOP
        IF Ln_Contador = 0 THEN
          IF Ln_Contador <> A.SECUENCIA_FLUJO THEN
            Ln_Contador := A.SECUENCIA_FLUJO; -- Ln_Contador + 1;
          END IF;
        END IF;
        --
        --
        /*IF Ln_Contador <> A.SECUENCIA_FLUJO THEN
          EXIT;
        END IF;*/
        --
        --
        Lv_EstadoFlujo := NULL;
        Pv_IdEstado    := NULL;
        IF C_LeeSiguienteflujo%ISOPEN THEN
          CLOSE C_LeeSiguienteflujo;
        END IF;
        OPEN C_LeeSiguienteflujo(Lv_IdEmpleado, --
                                 A.SECUENCIA);
        FETCH C_LeeSiguienteflujo
          INTO Ln_SigFlujo;
        IF C_LeeSiguienteflujo%FOUND THEN
          Pv_IdEstado    := 'P';
          Lv_EstadoFlujo := 'AP';
        ELSE
          Pv_IdEstado    := 'E';
          Lv_EstadoFlujo := 'AU';
        END IF;
        --
        --
        UPDATE CO_FLUJO_APROBACION FA
           SET FA.ESTADO                = Lv_EstadoFlujo,
               FA.USUARIO_ACTUALIZA     = USER,
               FA.FECHA_ACTUALIZA       = SYSDATE,
               FA.FECHA                 = SYSDATE/*,
               FA.ID_EMPLEADO_REEMPLAZO = DECODE(FA.ID_EMPLEADO, Lv_IdEmpleado, NULL, Lr_Reemplazo.NO_EMPLE_REEMP) --Lv_IdEmpleadoReempl*/
         WHERE FA.ID_ORDEN = Pv_IdOrden
           AND FA.SECUENCIA = A.SECUENCIA
           AND FA.ESTADO <> 'EL'
           AND FA.ID_EMPRESA = Pv_IdEmpresa;
        Ln_Contador := Ln_Contador + 1;
      END LOOP;
    END IF;
  
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_APRUEBA_ORDEN ' || Pv_CodigoError || ' - ' || SQLERRM;
  END COP_APRUEBA_ORDEN;
  --Corrige Flujo de Aprobacion de Ordenes de Compras
  PROCEDURE COP_CORRIGE_ORDEN(Pv_IdEmpresa      IN VARCHAR2,
                              Pv_IdOrden        IN VARCHAR2,
                              Pv_MotivoCorregir IN VARCHAR2,
                              Pv_CodigoError    OUT VARCHAR2,
                              Pv_MensajeError   OUT VARCHAR2) IS
    --Lee el empleado conectado segun el usuario
    CURSOR C_LeeEmpleado(Cv_IdEmpresa IN VARCHAR2, --
                         Cv_IdUsuario IN VARCHAR2) IS
      SELECT ID_EMPLEADO
        FROM SEG47_TNET.TASGUSUARIO
       WHERE USUARIO = Cv_IdUsuario
         AND NO_CIA = Cv_IdEmpresa;
    --Lee el flujo de la orden de comora generado
    CURSOR C_LeeFlujo(Cv_IdEmpresa       IN VARCHAR2, --
                      Cv_IdEmpleado      IN VARCHAR2,
                      Cv_IdEmpleadoReemp IN VARCHAR2) IS
      SELECT B.ID_EMPRESA,
             B.ID_ORDEN,
             B.TIPO_FLUJO,
             A.SECUENCIA,
             B.SECUENCIA_FLUJO
        FROM CO_FLUJO_APROBACION B,
             (SELECT ID_EMPRESA,
                     SECUENCIA,
                     ID_EMPLEADO,
                     ESTADO,
                     SECUENCIA_FLUJO,
                     ID_ORDEN,
                     TIPO_FLUJO
                FROM CO_FLUJO_APROBACION
               WHERE ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmpleadoReemp)
                 AND ESTADO IN ('PU', 'PA')) A
       WHERE A.ID_ORDEN = B.ID_ORDEN
         AND A.ID_EMPRESA = B.ID_EMPRESA
         AND B.ID_ORDEN = Pv_IdOrden
         AND (B.SECUENCIA_FLUJO = A.SECUENCIA_FLUJO - 1)
         AND (B.ESTADO = 'AP' /*'PA'*/ /*'PA'*/
             OR A.TIPO_FLUJO != B.TIPO_FLUJO)
         AND B.ID_EMPRESA = Pv_IdEmpresa
         AND B.ESTADO NOT IN ('EL');
    --Lee el prime aprobador-autorizador
    CURSOR C_LeePrimerAprobador(Cv_IdEmpleado      IN VARCHAR2,
                                Cv_IdEmpleadoReemp IN VARCHAR2) IS
      SELECT SECUENCIA_FLUJO,
             SECUENCIA
        FROM CO_FLUJO_APROBACION
       WHERE ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmpleadoReemp) --:UNO.ID_ORDEN_COMPRA
         AND ESTADO IN ('PA', 'PU')
         AND ID_ORDEN = Pv_IdOrden
         AND ID_EMPRESA = Pv_IdEmpresa;
  
    --Lee el empleado de la orden
    CURSOR C_LeeEmpleadosOrden(Cv_IdEmpresa   IN VARCHAR2, ---
                               Cv_IdOrden     IN VARCHAR2,
                               Cv_IdEmpleado  IN VARCHAR2, ---
                               Cv_IdEmplReemp IN VARCHAR2) IS
      SELECT FA.ID_EMPRESA,
             FA.SECUENCIA_FLUJO,
             FA.SECUENCIA
        FROM CO_FLUJO_APROBACION FA
       WHERE FA.ID_ORDEN = Cv_IdOrden
         AND FA.ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmplReemp)
         AND FA.ESTADO IN ('PA', 'PU')
         AND FA.ID_EMPRESA = Cv_IdEmpresa
       ORDER BY FA.SECUENCIA ASC;
  
    Lv_IdEmpleado        SEG47_TNET.TASGUSUARIO.ID_EMPLEADO%TYPE := NULL;
    Lr_PrimerAutorizador C_LeePrimerAprobador%ROWTYPE := NULL;
    Lr_Reemplazo         TAPHISTORICO_REEMPLAZOS%ROWTYPE := NULL;
    Lr_FlujoAprobacion   C_LeeFlujo%ROWTYPE := NULL;
    Ln_Contador          NUMBER(10) := 0;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El codigo de la Empresa No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdOrden IS NULL THEN
      Pv_MensajeError := 'El codigo de la Orden No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF C_LeeEmpleado%ISOPEN THEN
      CLOSE C_LeeEmpleado;
    END IF;
    OPEN C_LeeEmpleado(Pv_IdEmpresa, USER);
    FETCH C_LeeEmpleado
      INTO Lv_IdEmpleado;
    CLOSE C_LeeEmpleado;
    --Lee el reemplazo del empleado
    PLK_CONSULTAS.CONSULTA_EMPLEADO(Pv_IdEmpresa, ---
                                    Lv_IdEmpleado,
                                    Lr_Reemplazo,
                                    Pv_CodigoError,
                                    Pv_MensajeError);
    --
    IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    IF C_LeePrimerAprobador%ISOPEN THEN
      CLOSE C_LeePrimerAprobador;
    END IF;
    OPEN C_LeePrimerAprobador(Lv_IdEmpleado, Lr_Reemplazo.No_Emple_Reemp);
    FETCH C_LeePrimerAprobador
      INTO Lr_PrimerAutorizador;
    CLOSE C_LeePrimerAprobador;
  
    IF Lr_PrimerAutorizador.SECUENCIA_FLUJO = 1 THEN
      Lr_FlujoAprobacion.SECUENCIA := Lr_PrimerAutorizador.SECUENCIA;
    ELSE
      IF C_LeeFlujo%ISOPEN THEN
        CLOSE C_LeeFlujo;
      END IF;
      OPEN C_LeeFlujo(Pv_IdEmpresa, --
                      Lv_IdEmpleado,
                      Lr_Reemplazo.No_Emple_Reemp);
      FETCH C_LeeFlujo
        INTO Lr_FlujoAprobacion;
      CLOSE C_LeeFlujo;
    END IF;
  
    --Se procede al cambio a CO-POR CORREGIR del Flujo de Aprobacion
    IF Lr_Reemplazo.NO_EMPLE IS NULL THEN
      UPDATE CO_FLUJO_APROBACION FA
         SET FA.ESTADO            = 'CO',
             FA.COMENTARIO        = Pv_MotivoCorregir,
             FA.FECHA_ACTUALIZA   = SYSDATE,
             FA.USUARIO_ACTUALIZA = USER,
             FA.FECHA             = SYSDATE
       WHERE FA.ID_ORDEN = Pv_IdOrden
         AND FA.SECUENCIA = Lr_FlujoAprobacion.SECUENCIA
         AND FA.ID_EMPRESA = Pv_IdEmpresa;
    ELSE
      FOR A IN C_LeeEmpleadosOrden(Pv_IdEmpresa, ---
                                   Pv_IdOrden,
                                   Lv_IdEmpleado, ---
                                   Lr_Reemplazo.NO_EMPLE) LOOP
        IF Ln_Contador = 0 THEN
          IF Ln_Contador <> A.SECUENCIA_FLUJO THEN
            Ln_Contador := A.SECUENCIA_FLUJO; -- Ln_Contador + 1;
          END IF;
        END IF;
        IF Ln_Contador <> A.SECUENCIA_FLUJO THEN
          EXIT;
        END IF;
        UPDATE CO_FLUJO_APROBACION FA
           SET FA.ESTADO                = 'CO',
               FA.COMENTARIO            = Pv_MotivoCorregir,
               FA.USUARIO_ACTUALIZA     = USER,
               FA.FECHA_ACTUALIZA       = SYSDATE,
               FA.FECHA                 = SYSDATE,
               FA.ID_EMPLEADO_REEMPLAZO = DECODE(FA.ID_EMPLEADO, Lv_IdEmpleado, NULL, Lr_Reemplazo.NO_EMPLE_REEMP) --Lv_IdEmpleadoReempl
         WHERE FA.ID_ORDEN = Pv_IdOrden
           AND FA.SECUENCIA = A.SECUENCIA
           AND FA.ESTADO <> 'EL'
           AND FA.ID_EMPRESA = Pv_IdEmpresa;
      
      END LOOP;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_CORRIGE_ORDEN ' || Pv_CodigoError || ' - ' || SQLERRM;
  END COP_CORRIGE_ORDEN;

  PROCEDURE COP_RECHAZA_ORDEN(Pv_IdEmpresa     IN VARCHAR2,
                              Pv_IdOrden       IN VARCHAR2,
                              Pv_MotivoRechazo IN VARCHAR2,
                              Pv_CodigoError   OUT VARCHAR2,
                              Pv_MensajeError  OUT VARCHAR2) IS
    --Lee el empleado conectado
    CURSOR C_LeeEmpleado(Cv_IdEmpresa IN VARCHAR2, --
                         Cv_IdUsuario IN VARCHAR2) IS
      SELECT ID_EMPLEADO
        FROM SEG47_TNET.TASGUSUARIO
       WHERE USUARIO = Cv_IdUsuario
         AND NO_CIA = Cv_IdEmpresa;
  
    --lee el flujo de la orden de compra generado
    CURSOR C_LeeFlujo(Cv_IdEmpresa       IN VARCHAR2, --
                      Cv_IdEmpleado      IN VARCHAR2,
                      Cv_IdEmpleadoReemp IN VARCHAR2) IS
      SELECT B.ID_EMPRESA,
             B.ID_ORDEN,
             B.TIPO_FLUJO,
             A.SECUENCIA,
             B.SECUENCIA_FLUJO
        FROM CO_FLUJO_APROBACION B,
             (SELECT ID_EMPRESA,
                     SECUENCIA,
                     ID_EMPLEADO,
                     ESTADO,
                     SECUENCIA_FLUJO,
                     ID_ORDEN,
                     TIPO_FLUJO
                FROM CO_FLUJO_APROBACION
               WHERE ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmpleadoReemp)
                 AND ESTADO IN ('PU', 'PA')) A
       WHERE A.ID_ORDEN = B.ID_ORDEN
         AND A.ID_EMPRESA = B.ID_EMPRESA
         AND B.ID_ORDEN = Pv_IdOrden
         AND (B.SECUENCIA_FLUJO = A.SECUENCIA_FLUJO - 1)
         AND (B.ESTADO = 'AP' /*'PA'*/ /*'PA'*/
             OR A.TIPO_FLUJO != B.TIPO_FLUJO)
         AND B.ID_EMPRESA = Pv_IdEmpresa
         AND B.ESTADO NOT IN ('EL');
    --Lee el primer aprobador-autorizador de la oden de compra
    CURSOR C_LeePrimerAprobador(Cv_IdEmpleado      IN VARCHAR2,
                                Cv_IdEmpleadoReemp IN VARCHAR2) IS
      SELECT SECUENCIA_FLUJO,
             SECUENCIA
        FROM CO_FLUJO_APROBACION
       WHERE ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmpleadoReemp) --:UNO.ID_ORDEN_COMPRA
         AND ESTADO IN ('PA', 'PU')
         AND ID_ORDEN = Pv_IdOrden
         AND ID_EMPRESA = Pv_IdEmpresa;
  
    --Lee el emepleado del flujo de aprobacion de la orden de compra
    CURSOR C_LeeEmpleadosOrden(Cv_IdEmpresa   IN VARCHAR2, ---
                               Cv_IdOrden     IN VARCHAR2,
                               Cv_IdEmpleado  IN VARCHAR2, ---
                               Cv_IdEmplReemp IN VARCHAR2) IS
      SELECT FA.ID_EMPRESA,
             FA.SECUENCIA_FLUJO,
             FA.SECUENCIA
        FROM CO_FLUJO_APROBACION FA
       WHERE FA.ID_ORDEN = Cv_IdOrden
         AND FA.ID_EMPLEADO IN (Cv_IdEmpleado, Cv_IdEmplReemp)
         AND FA.ESTADO IN ('PA', 'PU')
         AND FA.ID_EMPRESA = Cv_IdEmpresa
       ORDER BY FA.SECUENCIA ASC;
  
    Lv_IdEmpleado        SEG47_TNET.TASGUSUARIO.ID_EMPLEADO%TYPE := NULL;
    Lr_PrimerAutorizador C_LeePrimerAprobador%ROWTYPE := NULL;
    Lr_Reemplazo         TAPHISTORICO_REEMPLAZOS%ROWTYPE := NULL;
    Lr_FlujoAprobacion   C_LeeFlujo%ROWTYPE := NULL;
    Ln_Contador          NUMBER(10) := 0;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El codigo de la Empresa No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdOrden IS NULL THEN
      Pv_MensajeError := 'El codigo de la Orden No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF C_LeeEmpleado%ISOPEN THEN
      CLOSE C_LeeEmpleado;
    END IF;
    OPEN C_LeeEmpleado(Pv_IdEmpresa, USER);
    FETCH C_LeeEmpleado
      INTO Lv_IdEmpleado;
    CLOSE C_LeeEmpleado;
    --Lee el reemplazo del empleado
    PLK_CONSULTAS.CONSULTA_EMPLEADO(Pv_IdEmpresa, ---
                                    Lv_IdEmpleado,
                                    Lr_Reemplazo,
                                    Pv_CodigoError,
                                    Pv_MensajeError);
    --
    IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    IF C_LeePrimerAprobador%ISOPEN THEN
      CLOSE C_LeePrimerAprobador;
    END IF;
    OPEN C_LeePrimerAprobador(Lv_IdEmpleado, Lr_Reemplazo.No_Emple_Reemp);
    FETCH C_LeePrimerAprobador
      INTO Lr_PrimerAutorizador;
    CLOSE C_LeePrimerAprobador;
  
    IF Lr_PrimerAutorizador.SECUENCIA_FLUJO = 1 THEN
      Lr_FlujoAprobacion.SECUENCIA := Lr_PrimerAutorizador.SECUENCIA;
    ELSE
      IF C_LeeFlujo%ISOPEN THEN
        CLOSE C_LeeFlujo;
      END IF;
      OPEN C_LeeFlujo(Pv_IdEmpresa, --
                      Lv_IdEmpleado,
                      Lr_Reemplazo.No_Emple_Reemp);
      FETCH C_LeeFlujo
        INTO Lr_FlujoAprobacion;
      CLOSE C_LeeFlujo;
    END IF;
  
    --Se procede al cambio a CO-POR CORREGIR del Flujo de Aprobacion
    IF Lr_Reemplazo.NO_EMPLE IS NULL THEN
      UPDATE CO_FLUJO_APROBACION FA
         SET FA.ESTADO            = 'RZ',
             FA.COMENTARIO        = Pv_MotivoRechazo,
             FA.FECHA_ACTUALIZA   = SYSDATE,
             FA.USUARIO_ACTUALIZA = USER,
             FA.FECHA             = SYSDATE
       WHERE FA.ID_ORDEN = Pv_IdOrden
         AND FA.SECUENCIA = Lr_FlujoAprobacion.SECUENCIA
         AND FA.ID_EMPRESA = Pv_IdEmpresa;
    ELSE
      FOR A IN C_LeeEmpleadosOrden(Pv_IdEmpresa, ---
                                   Pv_IdOrden,
                                   Lv_IdEmpleado, ---
                                   Lr_Reemplazo.NO_EMPLE) LOOP
        IF Ln_Contador = 0 THEN
          IF Ln_Contador <> A.SECUENCIA_FLUJO THEN
            Ln_Contador := A.SECUENCIA_FLUJO; -- Ln_Contador + 1;
          END IF;
        END IF;
        IF Ln_Contador <> A.SECUENCIA_FLUJO THEN
          EXIT;
        END IF;
        UPDATE CO_FLUJO_APROBACION FA
           SET FA.ESTADO                = 'RZ',
               FA.COMENTARIO            = Pv_MotivoRechazo,
               FA.USUARIO_ACTUALIZA     = USER,
               FA.FECHA_ACTUALIZA       = SYSDATE,
               FA.FECHA                 = SYSDATE,
               FA.ID_EMPLEADO_REEMPLAZO = DECODE(FA.ID_EMPLEADO, Lv_IdEmpleado, NULL, Lr_Reemplazo.NO_EMPLE_REEMP) --Lv_IdEmpleadoReempl
         WHERE FA.ID_ORDEN = Pv_IdOrden
           AND FA.SECUENCIA = A.SECUENCIA
           AND FA.ESTADO <> 'EL'
           AND FA.ID_EMPRESA = Pv_IdEmpresa;
      
      END LOOP;
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_CORRIGE_ORDEN ' || Pv_CodigoError || ' - ' || SQLERRM;
  END COP_RECHAZA_ORDEN;

  PROCEDURE COP_ELIMINA_FLUJO(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdOrden      IN VARCHAR2,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN
          NAF47_TNET.COK_ORDENES_COMPRAS.COP_ELIMINA_FLUJO@GPOETNET(Pv_IdEmpresa,
                               Pv_IdOrden,
                               Pv_CodigoError,
                               Pv_MensajeError);
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_ELIMINA_FLUJO ' || Pv_CodigoError || ' - ' || SQLERRM;
  END COP_ELIMINA_FLUJO;
  ---
  --Genera Flujo de Pago Estimado Segun la frecuencia registrada
  PROCEDURE COP_GENERA_FLUJO_PAGO_ESTIMADO(Pv_IdEmpresa            IN VARCHAR2,
                                           Pv_IdOrden              IN VARCHAR2,
                                           Pv_IdTipoFrecuenciaPago IN VARCHAR2,
                                           Pn_NumeroFrecuencia     IN NUMBER,
                                           Pv_CodigoError          OUT VARCHAR2,
                                           Pv_MensajeError         OUT VARCHAR2) IS
    CURSOR C_LeeOrdenCompra IS
      SELECT OC.NO_CIA,
             OC.FECHA,
             OC.MONTO,
             OC.IMP_VENTAS,
             OC.TOTAL
        FROM TAPORDEE OC
       WHERE NO_ORDEN = Pv_IdOrden
         AND NO_CIA = Pv_IdEmpresa;
    --
    CURSOR C_LeeDiasFrecuenciasPagos IS
      SELECT FP.NUMEROS_DIAS
        FROM CO_TIPOS_FRECUENCIAS_PAGOS FP
       WHERE FP.ID_TIPO_FRECUENCIA = Pv_IdTipoFrecuenciaPago
         AND FP.ID_EMPRESA = Pv_IdEmpresa;
    --
    CURSOR C_LeeFechaEstPago IS
      SELECT MAX(FP.FECHA_PAGO_ESTIMADO)
        FROM CO_FLUJOS_PAGOS_ESTIMADOS FP
       WHERE FP.ID_ORDEN = Pv_IdOrden
         AND FP.ID_EMPRESA = Pv_IdEmpresa;
    --
    CURSOR C_LeeUltimoFlujoPago IS
      SELECT SUM(FP.PORCENTAJE) PORCENTAJE,
             SUM(FP.MONTO) MONTO,
             SUM(FP.MONTO_IVA) MONTO_IVA,
             SUM(FP.MONTO_TOTAL) MONTO_TOTAL,
             MAX(FP.ID_FLUJO_PAGO_ESTIMADO) ID_FLUJO_PAGO_ESTIMADO
        FROM CO_FLUJOS_PAGOS_ESTIMADOS FP
       WHERE FP.ID_ORDEN = Pv_IdOrden
         AND FP.ID_EMPRESA = Pv_IdEmpresa;
    --
    CURSOR C_LeeFlujosEstimados IS
      SELECT FP.ID_EMPRESA,
             FP.ID_FLUJO_PAGO_ESTIMADO
        FROM CO_FLUJOS_PAGOS_ESTIMADOS FP
       WHERE FP.ID_ORDEN = Pv_IdOrden
         AND FP.ID_EMPRESA = Pv_IdEmpresa;
  
    Lr_OrdenCompra      C_LeeOrdenCompra%ROWTYPE := NULL;
    Ln_NumerosDias      CO_TIPOS_FRECUENCIAS_PAGOS.NUMEROS_DIAS%TYPE := 0;
    Lr_FlujoEstimado    CO_FLUJOS_PAGOS_ESTIMADOS%ROWTYPE := NULL;
    Lr_FlujoEstUltimo   C_LeeUltimoFlujoPago%ROWTYPE := NULL;
    Ld_FechaInicialPago DATE;
    Ld_FechaUltimaPago  DATE;
    Ln_Secuencia        CO_FLUJOS_PAGOS_ESTIMADOS.ID_FLUJO_PAGO_ESTIMADO%TYPE := 1;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El codigo de la Empresa No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdOrden IS NULL THEN
      Pv_MensajeError := 'El codigo de la Orden No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdTipoFrecuenciaPago IS NULL THEN
      Pv_MensajeError := 'El Tipo de Frecuencia No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF Pn_NumeroFrecuencia IS NULL THEN
      Pv_MensajeError := 'El Numero de Frecuencia No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    DELETE FROM CO_FLUJOS_PAGOS_ESTIMADOS
     WHERE ID_ORDEN = Pv_IdOrden
       AND ID_EMPRESA = Pv_IdEmpresa;
    --
    IF C_LeeOrdenCompra%ISOPEN THEN
      CLOSE C_LeeOrdenCompra;
    END IF;
    OPEN C_LeeOrdenCompra;
    FETCH C_LeeOrdenCompra
      INTO Lr_OrdenCompra;
    CLOSE C_LeeOrdenCompra;
    --
    IF C_LeeDiasFrecuenciasPagos%ISOPEN THEN
      CLOSE C_LeeDiasFrecuenciasPagos;
    END IF;
    OPEN C_LeeDiasFrecuenciasPagos;
    FETCH C_LeeDiasFrecuenciasPagos
      INTO Ln_NumerosDias;
    CLOSE C_LeeDiasFrecuenciasPagos;
    Ld_FechaInicialPago := TRUNC(Lr_OrdenCompra.FECHA); ---+ Ln_NumerosDias;
    FOR A IN 1 .. Pn_NumeroFrecuencia LOOP
      Lr_FlujoEstimado                     := NULL;
      Lr_FlujoEstimado.MONTO               := ROUND(Lr_OrdenCompra.MONTO / Pn_NumeroFrecuencia, 2);
      Lr_FlujoEstimado.MONTO_IVA           := ROUND(Lr_OrdenCompra.IMP_VENTAS / Pn_NumeroFrecuencia, 2);
      Lr_FlujoEstimado.MONTO_TOTAL         := ROUND(Lr_OrdenCompra.TOTAL / Pn_NumeroFrecuencia, 2);
      Lr_FlujoEstimado.PORCENTAJE          := ROUND((100 * Lr_FlujoEstimado.MONTO_TOTAL) / Lr_OrdenCompra.TOTAL, 2);
      Lr_FlujoEstimado.FECHA_PAGO_ESTIMADO := Ld_FechaInicialPago;
      INSERT INTO CO_FLUJOS_PAGOS_ESTIMADOS
        (ID_EMPRESA,
         ID_ORDEN,
         ID_FLUJO_PAGO_ESTIMADO,
         MONTO,
         MONTO_IVA,
         MONTO_TOTAL,
         PORCENTAJE,
         FECHA_PAGO_ESTIMADO,
         OBSERVACION,
         USUARIO_CREA,
         FECHA_CREA,
         FECHA)
      VALUES
        (Pv_IdEmpresa,
         Pv_IdOrden,
         Ln_Secuencia,
         Lr_FlujoEstimado.MONTO,
         Lr_FlujoEstimado.MONTO_IVA,
         Lr_FlujoEstimado.MONTO_TOTAL,
         Lr_FlujoEstimado.PORCENTAJE,
         Lr_FlujoEstimado.FECHA_PAGO_ESTIMADO,
         NULL,
         USER,
         SYSDATE,
         NULL);
      Ln_Secuencia := Ln_Secuencia + 1;
    
      IF C_LeeFechaEstPago%ISOPEN THEN
        CLOSE C_LeeFechaEstPago;
      END IF;
      OPEN C_LeeFechaEstPago;
      FETCH C_LeeFechaEstPago
        INTO Ld_FechaUltimaPago;
      CLOSE C_LeeFechaEstPago;
      Ld_FechaInicialPago := Ld_FechaUltimaPago + Ln_NumerosDias;
    END LOOP;
    --
    IF C_LeeUltimoFlujoPago%ISOPEN THEN
      CLOSE C_LeeUltimoFlujoPago;
    END IF;
    OPEN C_LeeUltimoFlujoPago;
    FETCH C_LeeUltimoFlujoPago
      INTO Lr_FlujoEstUltimo;
    CLOSE C_LeeUltimoFlujoPago;
    --
    IF Lr_OrdenCompra.MONTO <> Lr_FlujoEstUltimo.MONTO OR Lr_OrdenCompra.IMP_VENTAS <> Lr_FlujoEstUltimo.MONTO_IVA OR Lr_OrdenCompra.TOTAL <> Lr_FlujoEstUltimo.MONTO_TOTAL THEN
      UPDATE CO_FLUJOS_PAGOS_ESTIMADOS FP
         SET FP.PORCENTAJE  = FP.PORCENTAJE + (100 - Lr_FlujoEstUltimo.PORCENTAJE),
             FP.MONTO       = FP.MONTO + (Lr_OrdenCompra.MONTO - Lr_FlujoEstUltimo.MONTO),
             FP.MONTO_IVA   = FP.MONTO_IVA + (Lr_OrdenCompra.IMP_VENTAS - Lr_FlujoEstUltimo.MONTO_IVA),
             FP.MONTO_TOTAL = FP.MONTO_TOTAL + (Lr_OrdenCompra.TOTAL - Lr_FlujoEstUltimo.MONTO_TOTAL)
       WHERE FP.ID_ORDEN = Pv_IdOrden
         AND FP.ID_FLUJO_PAGO_ESTIMADO = Lr_FlujoEstUltimo.ID_FLUJO_PAGO_ESTIMADO
         AND FP.ID_EMPRESA = Pv_IdEmpresa;
    END IF;
    --
    FOR A IN C_LeeFlujosEstimados LOOP
      UPDATE CO_FLUJOS_PAGOS_ESTIMADOS FP
         SET FP.FECHA = LAST_DAY(TRUNC(FP.FECHA_PAGO_ESTIMADO))
       WHERE FP.ID_ORDEN = Pv_IdOrden
         AND FP.ID_FLUJO_PAGO_ESTIMADO = A.ID_FLUJO_PAGO_ESTIMADO
         AND FP.ID_EMPRESA = Pv_IdEmpresa;
    END LOOP;
    --last_day(to_date('2003/03/15', 'yyyy/mm/dd'))
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_ELIMINA_FLUJO_ESTIMADO ' || Pv_CodigoError || ' - ' || SQLERRM;
  END COP_GENERA_FLUJO_PAGO_ESTIMADO;

  --Procedimiento que Inserta la aprobacion del responsable de Bodegas
  PROCEDURE COP_EMPLEADO_REVISA_OC(Pv_IdEmpresa    IN VARCHAR2,
                                   Pv_IdOrden      IN VARCHAR2,
                                   Pv_CodigoError  OUT VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_LeeOrdenCompras(Cv_IdEmpresa IN VARCHAR2,
                             Cv_IdOrden   IN VARCHAR2) IS
      SELECT OC.NO_CIA,
             OC.IND_NO_INV
        FROM TAPORDEE OC
       WHERE OC.NO_ORDEN = Cv_IdOrden
         AND OC.NO_CIA = Cv_IdEmpresa;
    --
    CURSOR C_LeeDetalleOrden(Cv_IdEmpresa IN VARCHAR2,
                             Cv_IdOrden   IN VARCHAR2) IS
      SELECT DISTINCT ER.ID_EMPLEADO,
                      ER.ORDEN
        FROM TAPORDED              DOC,
             CO_PRODUCTOS_REVISION PR,
             CO_EMPLEADOS_REVISION ER
       WHERE PR.ID_PRODUCTO_REVISION = ER.ID_PRODUCTO_REVISION
         AND PR.ID_EMPRESA = ER.ID_EMPRESA
         AND (DOC.NO_ARTI = PR.ID_PRODUCTO OR DOC.CODIGO_NI = PR.ID_PRODUCTO)
         AND DOC.NO_ORDEN = Cv_IdOrden
         AND PR.ESTADO = 'A'
         AND ER.ESTADO = 'A'
         AND DOC.NO_CIA = Cv_IdEmpresa
       ORDER BY ER.ORDEN ASC;
    --
    CURSOR C_LeeEmpleadoRevisa(Cv_IdEmpresa     IN VARCHAR2,
                               Cv_IdTransaccion IN VARCHAR2) IS
      SELECT PA.ID_EMPRESA,
             PA.PARAMETRO
        FROM GE_PARAMETROS        PA,
             GE_GRUPOS_PARAMETROS GPA
       WHERE PA.ID_GRUPO_PARAMETRO = GPA.ID_GRUPO_PARAMETRO
         AND PA.ID_APLICACION = GPA.ID_APLICACION
         AND PA.ID_EMPRESA = PA.ID_EMPRESA
         AND PA.ID_APLICACION = 'CO'
         AND PA.ID_GRUPO_PARAMETRO = 'EMPLEADO_REVISA_OC'
         AND PA.ESTADO = 'A'
         AND GPA.ESTADO = 'A'
         AND PA.PARAMETRO_ALTERNO = DECODE(Cv_IdTransaccion, 'N', 'B', 'S')
         AND PA.ID_EMPRESA = Cv_IdEmpresa;
    --
    CURSOR C_LeeSecuencia(Cv_IdEmpresa IN VARCHAR2,
                          Cv_IdOrden   IN VARCHAR2) IS
      SELECT NVL(MAX(FA.SECUENCIA), 0) + 1
        FROM CO_FLUJO_APROBACION FA
       WHERE FA.ID_ORDEN = Cv_IdOrden
         AND FA.ID_EMPRESA = Cv_IdEmpresa;
  
    --
    Lr_Orden          C_LeeOrdenCompras%ROWTYPE := NULL;
    Lr_Parametros     C_LeeEmpleadoRevisa%ROWTYPE := NULL;
    Ln_Secuencia      CO_FLUJO_APROBACION.SECUENCIA%TYPE := 0;
    Ln_SecuenciaFlujo CO_FLUJO_APROBACION.SECUENCIA_FLUJO%TYPE := 0;
    Lr_DetalleOrden   C_LeeDetalleOrden%ROWTYPE := NULL;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El codigo de la Empresa No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    IF Pv_IdOrden IS NULL THEN
      Pv_MensajeError := 'El codigo de la Orden No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF C_LeeOrdenCompras%ISOPEN THEN
      CLOSE C_LeeOrdenCompras;
    END IF;
    OPEN C_LeeOrdenCompras(Pv_IdEmpresa, --
                           Pv_IdOrden);
    FETCH C_LeeOrdenCompras
      INTO Lr_Orden;
    CLOSE C_LeeOrdenCompras;
    --
    Ln_Secuencia := 0;
    IF C_LeeSecuencia%ISOPEN THEN
      CLOSE C_LeeSecuencia;
    END IF;
    OPEN C_LeeSecuencia(Pv_IdEmpresa, --
                        Pv_IdOrden);
    FETCH C_LeeSecuencia
      INTO Ln_Secuencia;
    CLOSE C_LeeSecuencia;
  
    --
    IF NVL(Lr_Orden.IND_NO_INV, 'S') = 'N' THEN
      --Ordenes de Bienes
      IF C_LeeEmpleadoRevisa%ISOPEN THEN
        CLOSE C_LeeEmpleadoRevisa;
      END IF;
      OPEN C_LeeEmpleadoRevisa(Pv_IdEmpresa, --
                               Lr_Orden.IND_NO_INV);
      FETCH C_LeeEmpleadoRevisa
        INTO Lr_Parametros;
      CLOSE C_LeeEmpleadoRevisa;
      --
      --
      IF Lr_Parametros.PARAMETRO IS NOT NULL THEN
        INSERT INTO CO_FLUJO_APROBACION --Inserto la primea linea de autorizacion
          (ID_EMPRESA,
           SECUENCIA,
           SECUENCIA_FLUJO,
           TIPO_FLUJO,
           ID_ORDEN,
           ID_EMPLEADO,
           ID_EMPLEADO_REEMPLAZO,
           FECHA,
           COMENTARIO,
           USUARIO_CREA,
           FECHA_CREA,
           ESTADO)
        VALUES
          (Pv_IdEmpresa,
           Ln_Secuencia, --1,
           1,
           'AP',
           Pv_IdOrden,
           Lr_Parametros.PARAMETRO,
           NULL,
           NULL,
           NULL,
           USER,
           SYSDATE,
           'PA');
        --
      END IF;
    ELSE
      --Ordenes de Servicios
    
      FOR Lr_DetalleOrden IN C_LeeDetalleOrden(Pv_IdEmpresa, Pv_IdOrden) LOOP
        Ln_SecuenciaFlujo := Ln_SecuenciaFlujo + 1;
        BEGIN
        
          INSERT INTO CO_FLUJO_APROBACION --Inserto la primea linea de autorizacion
            (ID_EMPRESA,
             SECUENCIA,
             SECUENCIA_FLUJO,
             TIPO_FLUJO,
             ID_ORDEN,
             ID_EMPLEADO,
             ID_EMPLEADO_REEMPLAZO,
             FECHA,
             COMENTARIO,
             USUARIO_CREA,
             FECHA_CREA,
             ESTADO)
          VALUES
            (Pv_IdEmpresa,
             Ln_Secuencia, --1,
             Ln_SecuenciaFlujo, --1,
             'AP',
             Pv_IdOrden,
             Lr_DetalleOrden.ID_EMPLEADO,
             NULL,
             NULL,
             NULL,
             USER,
             SYSDATE,
             'PA');
          --
          Ln_Secuencia := Ln_Secuencia + 1;
          --
        EXCEPTION
          WHEN OTHERS THEN
            Pv_CodigoError  := SQLCODE;
            Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_EMPLEADO_REVISA_OC ' || Pv_CodigoError || ' - ' || SQLERRM;
        END;
      
      END LOOP;
    END IF;
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_EMPLEADO_REVISA_OC ' || Pv_CodigoError || ' - ' || SQLERRM;
  END COP_EMPLEADO_REVISA_OC;
  -----------
  --Procedimiento que corrige una OC por un autorizador o aprobador
  PROCEDURE COP_REVERSA_ORDEN(Pv_IdEmpresa    IN VARCHAR2,
                              Pv_IdOrden      IN VARCHAR2,
                              Pv_Comentario   IN VARCHAR2,
                              Pv_CodigoError  OUT VARCHAR2,
                              Pv_MensajeError OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El codigo de la Empresa No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdOrden IS NULL THEN
      Pv_MensajeError := 'El codigo de la Orden No Puede Ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    UPDATE CO_FLUJO_APROBACION FA
       SET FA.ESTADO            = 'EL',
           FA.COMENTARIO        = Pv_Comentario,
           FA.USUARIO_ACTUALIZA = USER,
           FA.FECHA_ACTUALIZA   = SYSDATE
     WHERE ID_ORDEN = Pv_IdOrden
       AND ID_EMPRESA = Pv_IdEmpresa;
    --
  EXCEPTION
    WHEN Le_Error THEN
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en COK_ORDENES_COMPRAS.COP_REVERSA_ORDEN ' || Pv_CodigoError || ' - ' || SQLERRM;
    
  END COP_REVERSA_ORDEN;
  -----------
END COK_ORDENES_COMPRAS;

/
