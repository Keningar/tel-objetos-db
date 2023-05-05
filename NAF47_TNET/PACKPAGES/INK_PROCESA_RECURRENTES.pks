CREATE EDITIONABLE PACKAGE            INK_PROCESA_RECURRENTES is

  PROCEDURE P_INSERTA_PEDIDO(Pr_Pedidos      IN DB_COMPRAS.INFO_PEDIDO%ROWTYPE,
                             Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE P_INSERTA_PEDIDO_DET(Pr_PedidosDet   IN DB_COMPRAS.INFO_PEDIDO_DETALLE%ROWTYPE,
                                 Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE P_INSERTA_RESERVA_PRODUCTO(Pr_ReservaProductos IN DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE,
                                       Pv_MensajeError     OUT VARCHAR2);
  --
  PROCEDURE P_INSERT_PEDIDO_APROBACION(Lr_PedidoAprobacion IN DB_COMPRAS.INFO_PEDIDO_APROBACION%ROWTYPE,
                                       Pv_MensajeError     OUT VARCHAR2);
  --
  PROCEDURE P_INSERT_PEDIDO_ESTADO(Pr_PedidoEstado IN DB_COMPRAS.INFO_PEDIDO_ESTADO%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2);

  --
  PROCEDURE P_INSERT_PEDIDO_SOLICITUD(Pr_PedidoSolicitud IN DB_COMPRAS.INFO_SOLICITUD%ROWTYPE,
                                      Pv_MensajeError    OUT VARCHAR2);
  --
  PROCEDURE P_PROCESA_RECURRENTES(Pv_IdEmpresa      IN VARCHAR2,
                                  Pv_IdResponsable  IN VARCHAR2,
                                  Pv_Login          IN VARCHAR2,
                                  Pv_IdArticulo     IN VARCHAR2,
                                  Pn_IdPedidoMaster OUT NUMBER,
                                  Pv_MensajeError   OUT VARCHAR2);

END INK_PROCESA_RECURRENTES;
/

CREATE EDITIONABLE PACKAGE BODY            INK_PROCESA_RECURRENTES IS
  PROCEDURE P_INSERTA_PEDIDO(Pr_Pedidos      IN DB_COMPRAS.INFO_PEDIDO%ROWTYPE,
                             Pv_MensajeError OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN

    INSERT INTO DB_COMPRAS.INFO_PEDIDO
      (ID_PEDIDO,
       DEPARTAMENTO_ID,
       USR_CREACION,
       ESTADO,
       FE_CREACION,
       IP_CREACION,
       PEDIDO_TIPO,
       USR_ASIGNADO_TIPO,
       USR_CREACION_ID,
       TIPO_SERVICIO,
       DESCONTAR_MONTO_APROBACION,
       MONTO_POR_APROBAR,
       LOGIN,
       OBSERVACION,
       VALOR_TOTAL,
       MONTO_TOTAL_APROBACION,
       MONTO_INICIAL_APROBACION,
       SALDO_APROBACION,
       VALOR_DESCONTADO,
       USR_JEFE_ID,
       USR_JEFE,
       NOMBRES_JEFE,
       USR_AUTORIZA_ID,
       USR_AUTORIZA,
       USR_MONTO_APROBACION_ID,
       USR_MONTO_APROBACION,
       TIPO_PROCESO)
    VALUES
      (Pr_Pedidos.ID_PEDIDO,
       Pr_Pedidos.DEPARTAMENTO_ID,
       Pr_Pedidos.USR_CREACION,
       Pr_Pedidos.ESTADO,
       Pr_Pedidos.FE_CREACION,
       Pr_Pedidos.IP_CREACION,
       Pr_Pedidos.PEDIDO_TIPO,
       Pr_Pedidos.USR_ASIGNADO_TIPO,
       Pr_Pedidos.USR_CREACION_ID,
       Pr_Pedidos.TIPO_SERVICIO,
       Pr_Pedidos.DESCONTAR_MONTO_APROBACION,
       Pr_Pedidos.MONTO_POR_APROBAR,
       Pr_Pedidos.LOGIN,
       Pr_Pedidos.OBSERVACION,
       Pr_Pedidos.VALOR_TOTAL,
       Pr_Pedidos.MONTO_TOTAL_APROBACION,
       Pr_Pedidos.MONTO_INICIAL_APROBACION,
       Pr_Pedidos.SALDO_APROBACION,
       Pr_Pedidos.VALOR_DESCONTADO,
       Pr_Pedidos.USR_JEFE_ID,
       Pr_Pedidos.USR_JEFE,
       Pr_Pedidos.NOMBRES_JEFE,
       Pr_Pedidos.USR_AUTORIZA_ID,
       Pr_Pedidos.USR_AUTORIZA,
       Pr_Pedidos.USR_MONTO_APROBACION_ID,
       Pr_Pedidos.USR_MONTO_APROBACION,
       Pr_Pedidos.TIPO_PROCESO);
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_RECURRENTES.P_INSERTA_PEDIDO ' ||
                         Pv_MensajeError;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_RECURRENTES.P_INSERTA_PEDIDO ' ||
                         SQLCODE || ' ' || SQLERRM;
      RETURN;
  END P_INSERTA_PEDIDO;
  PROCEDURE P_INSERTA_PEDIDO_DET(Pr_PedidosDet   IN DB_COMPRAS.INFO_PEDIDO_DETALLE%ROWTYPE,
                                 Pv_MensajeError OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN

    INSERT INTO DB_COMPRAS.INFO_PEDIDO_DETALLE
      (ID_PEDIDO_DETALLE,
       CANTIDAD_SOLICITADA,
       DESCRIPCION_SOLICITADA,
       FE_CREACION,
       USR_CREACION,
       IP_CREACION,
       PEDIDO_ID,
       PEDIDO_USO_ID,
       COSTO_PRODUCTO,
       SUBTOTAL,
       ES_COMPRA,
       USR_ASIGNADO_ID,
       USR_ASIGNADO,
       CARACTERISTICA_ID,
       PRODUCTO_EMPRESA_ID,
       PRODUCTO_ID,
       DESCRIPCION,
       PRODUCTO_EMPRESA_ID_REASIGNADO,
       OBSERVACION,
       ESTADO,
       ES_DESCUENTO_ROL,
       DEVOLUCION,
       CANTIDAD_A_DEVOLVER,
       ES_CONSUMIBLE,
       CANTIDAD_DESPACHADA,
       CANTIDAD_RESERVADA)
    VALUES
      (Pr_PedidosDet.ID_PEDIDO_DETALLE,
       Pr_PedidosDet.CANTIDAD_SOLICITADA,
       Pr_PedidosDet.DESCRIPCION_SOLICITADA,
       Pr_PedidosDet.FE_CREACION,
       Pr_PedidosDet.USR_CREACION,
       Pr_PedidosDet.IP_CREACION,
       Pr_PedidosDet.PEDIDO_ID,
       Pr_PedidosDet.PEDIDO_USO_ID,
       Pr_PedidosDet.COSTO_PRODUCTO,
       Pr_PedidosDet.SUBTOTAL,
       Pr_PedidosDet.ES_COMPRA,
       Pr_PedidosDet.USR_ASIGNADO_ID,
       Pr_PedidosDet.USR_ASIGNADO,
       Pr_PedidosDet.CARACTERISTICA_ID,
       Pr_PedidosDet.PRODUCTO_EMPRESA_ID,
       Pr_PedidosDet.PRODUCTO_ID,
       Pr_PedidosDet.DESCRIPCION,
       Pr_PedidosDet.PRODUCTO_EMPRESA_ID_REASIGNADO,
       Pr_PedidosDet.OBSERVACION,
       Pr_PedidosDet.ESTADO,
       Pr_PedidosDet.ES_DESCUENTO_ROL,
       Pr_PedidosDet.DEVOLUCION,
       Pr_PedidosDet.CANTIDAD_A_DEVOLVER,
       Pr_PedidosDet.ES_CONSUMIBLE,
       Pr_PedidosDet.CANTIDAD_DESPACHADA,
       Pr_PedidosDet.CANTIDAD_RESERVADA);
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_RECURRENTES.P_INSERTA_PEDIDO ' ||
                         Pv_MensajeError;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_RECURRENTES.P_INSERTA_PEDIDO ' ||
                         SQLCODE || ' ' || SQLERRM;
      RETURN;
  END P_INSERTA_PEDIDO_DET;
  --
  PROCEDURE P_INSERTA_RESERVA_PRODUCTO(Pr_ReservaProductos IN DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE,
                                       Pv_MensajeError     OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN
    INSERT INTO DB_COMPRAS.INFO_RESERVA_PRODUCTOS
      (EMPRESA_ID,
       BODEGA,
       NO_ARTI,
       DESCRIPCION,
       CANTIDAD,
       TIPO_MOV,
       PEDIDO_DETALLE_ID,
       NO_CIA,
       FECHA_CREACION,
       USUARIO_CREACION,
       FECHA_ACTUALIZA,
       USUARIO_ACTUALIZA,
       ID_RESERVA_PRODUCTOS)
    VALUES
      (Pr_ReservaProductos.EMPRESA_ID,
       Pr_ReservaProductos.BODEGA,
       Pr_ReservaProductos.NO_ARTI,
       Pr_ReservaProductos.DESCRIPCION,
       Pr_ReservaProductos.CANTIDAD,
       Pr_ReservaProductos.TIPO_MOV,
       Pr_ReservaProductos.PEDIDO_DETALLE_ID,
       Pr_ReservaProductos.NO_CIA,
       Pr_ReservaProductos.FECHA_CREACION,
       Pr_ReservaProductos.USUARIO_CREACION,
       Pr_ReservaProductos.FECHA_ACTUALIZA,
       Pr_ReservaProductos.USUARIO_ACTUALIZA,
       Pr_ReservaProductos.ID_RESERVA_PRODUCTOS);
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_RECURRENTES.P_INSERTA_RESERVA_PRODUCTO ' ||
                         Pv_MensajeError;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_RECURRENTES.P_INSERTA_RESERVA_PRODUCTO ' ||
                         SQLCODE || ' ' || SQLERRM;
      RETURN;
  END P_INSERTA_RESERVA_PRODUCTO;

  --
  PROCEDURE P_INSERT_PEDIDO_APROBACION(Lr_PedidoAprobacion IN DB_COMPRAS.INFO_PEDIDO_APROBACION%ROWTYPE,
                                       Pv_MensajeError     OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN
    INSERT INTO DB_COMPRAS.INFO_PEDIDO_APROBACION
      (ID_PEDIDO_APROBACION,
       VALOR_PEDIDO,
       VALOR_UTILIZADO,
       VALOR_EXCEDIDO,
       VALOR_AUTORIZADO,
       OBSERVACION,
       FE_CREACION,
       ESTADO,
       USUARIO_AUTORIZA_ID,
       USUARIO_AUTORIZA,
       PEDIDO_ID,
       USR_CREACION,
       USUARIO_JEFE,
       USR_APROBACION_ID,
       USR_APROBACION,
       TIPO_AUTORIZACION,
       FE_ULT_MOD,
       USR_ULT_MOD,
       IP_CREACION,
       EMPRESA_ID)
    VALUES
      (Lr_PedidoAprobacion.ID_PEDIDO_APROBACION,
       Lr_PedidoAprobacion.VALOR_PEDIDO,
       Lr_PedidoAprobacion.VALOR_UTILIZADO,
       Lr_PedidoAprobacion.VALOR_EXCEDIDO,
       Lr_PedidoAprobacion.VALOR_AUTORIZADO,
       Lr_PedidoAprobacion.OBSERVACION,
       Lr_PedidoAprobacion.FE_CREACION,
       Lr_PedidoAprobacion.ESTADO,
       Lr_PedidoAprobacion.USUARIO_AUTORIZA_ID,
       Lr_PedidoAprobacion.USUARIO_AUTORIZA,
       Lr_PedidoAprobacion.PEDIDO_ID,
       Lr_PedidoAprobacion.USR_CREACION,
       Lr_PedidoAprobacion.USUARIO_JEFE,
       Lr_PedidoAprobacion.USR_APROBACION_ID,
       Lr_PedidoAprobacion.USR_APROBACION,
       Lr_PedidoAprobacion.TIPO_AUTORIZACION,
       Lr_PedidoAprobacion.FE_ULT_MOD,
       Lr_PedidoAprobacion.USR_ULT_MOD,
       Lr_PedidoAprobacion.IP_CREACION,
       Lr_PedidoAprobacion.EMPRESA_ID);
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_APROBACION ' ||
                         Pv_MensajeError;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_APROBACION ' ||
                         SQLCODE || ' ' || SQLERRM;
      RETURN;

  END P_INSERT_PEDIDO_APROBACION;
  --
  --
  PROCEDURE P_INSERT_PEDIDO_ESTADO(Pr_PedidoEstado IN DB_COMPRAS.INFO_PEDIDO_ESTADO%ROWTYPE,
                                   Pv_MensajeError OUT VARCHAR2) is
    Le_Error EXCEPTION;
  BEGIN
    INSERT INTO DB_COMPRAS.INFO_PEDIDO_ESTADO
      (ID_PEDIDO_ESTADO,
       USR_CREACION,
       ESTADO,
       FE_CREACION,
       PEDIDO_ID,
       IP_CREACION)
    VALUES
      (Pr_PedidoEstado.ID_PEDIDO_ESTADO,
       Pr_PedidoEstado.USR_CREACION,
       Pr_PedidoEstado.ESTADO,
       Pr_PedidoEstado.FE_CREACION,
       Pr_PedidoEstado.PEDIDO_ID,
       Pr_PedidoEstado.IP_CREACION);
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_ESTADO ' ||
                         Pv_MensajeError;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_ESTADO ' ||
                         SQLCODE || ' ' || SQLERRM;
      RETURN;

  END P_INSERT_PEDIDO_ESTADO;
  --
  PROCEDURE P_INSERT_PEDIDO_SOLICITUD(Pr_PedidoSolicitud IN DB_COMPRAS.INFO_SOLICITUD%ROWTYPE,
                                      Pv_MensajeError    OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN
    INSERT INTO DB_COMPRAS.INFO_SOLICITUD
      (ID_SOLICITUD,
       TIPO,
       VALOR_TOTAL,
       ESTADO,
       PEDIDO_ID,
       FE_CREACION,
       IP_CREACION,
       USR_CREACION,
       OBSERVACION,
       EMPRESA_ID,
       AREA_ID,
       DEPARTAMENTO_ID,
       TOTAL_DESCUENTO,
       TOTAL_IVA,
       SUBTOTAL,
       REGION,
       PROCESO_SOLICITUD_COMPRA,
       VALOR,
       TOTAL_SERVICIO,
       TOTAL_IMPUESTO)
    VALUES
      (Pr_PedidoSolicitud.ID_SOLICITUD,
       Pr_PedidoSolicitud.TIPO,
       Pr_PedidoSolicitud.VALOR_TOTAL,
       Pr_PedidoSolicitud.ESTADO,
       Pr_PedidoSolicitud.PEDIDO_ID,
       Pr_PedidoSolicitud.FE_CREACION,
       Pr_PedidoSolicitud.IP_CREACION,
       Pr_PedidoSolicitud.USR_CREACION,
       Pr_PedidoSolicitud.OBSERVACION,
       Pr_PedidoSolicitud.EMPRESA_ID,
       Pr_PedidoSolicitud.AREA_ID,
       Pr_PedidoSolicitud.DEPARTAMENTO_ID,
       Pr_PedidoSolicitud.TOTAL_DESCUENTO,
       Pr_PedidoSolicitud.TOTAL_IVA,
       Pr_PedidoSolicitud.SUBTOTAL,
       Pr_PedidoSolicitud.REGION,
       Pr_PedidoSolicitud.PROCESO_SOLICITUD_COMPRA,
       Pr_PedidoSolicitud.VALOR,
       Pr_PedidoSolicitud.TOTAL_SERVICIO,
       Pr_PedidoSolicitud.TOTAL_IMPUESTO);
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_SOLICITUD ' ||
                         Pv_MensajeError || '-->' ||
                         Pr_PedidoSolicitud.ID_SOLICITUD;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_SOLICITUD ' ||
                         '-->' || Pr_PedidoSolicitud.ID_SOLICITUD || ' ' ||
                         SQLCODE || ' ' || SQLERRM;
      RETURN;
  END P_INSERT_PEDIDO_SOLICITUD;
  PROCEDURE P_PROCESA_RECURRENTES(Pv_IdEmpresa      IN VARCHAR2,
                                  Pv_IdResponsable  IN VARCHAR2,
                                  Pv_Login          IN VARCHAR2,
                                  Pv_IdArticulo     IN VARCHAR2,
                                  Pn_IdPedidoMaster OUT NUMBER,
                                  Pv_MensajeError   OUT VARCHAR2) IS
    CURSOR C_LeeProdRecurrentes IS
      SELECT a.NO_ARTI NO_ARTI_ARINDA,
             (SELECT DA2.DESCRIPCION
                FROM ARINDA DA2
               WHERE DA2.NO_CIA = A.NO_CIA
                 AND DA2.NO_ARTI = A.NO_ARTI) DESCRIPCION
        FROM NAF47_TNET.ARINMA A
       WHERE NO_ARTI IN
             (SELECT DA.NO_ARTi
                FROM ARINDA DA
               WHERE DA.NO_CIA = Pv_IdEmpresa
                 AND DA.ES_RECURRENTE = 'S'
                 AND DA.IND_ACTIVO = 'S'
                 AND DA.NO_ARTI = NVL(Pv_IdArticulo, DA.NO_ARTI)
              UNION
              SELECT NO_ARTI_USADO
                FROM ARINDA DA1
               WHERE DA1.NO_CIA = Pv_IdEmpresa
                 AND DA1.ES_RECURRENTE = 'S'
                 AND DA1.IND_ACTIVO = 'S'
                 AND DA1.NO_ARTI_USADO =
                     NVL(Pv_IdArticulo, DA1.NO_ARTI_USADO))
         AND EXISTS (SELECT 'X'
                FROM V_ARTICULO_STOCK AST
               WHERE AST.NO_CIA = A.NO_CIA
                 AND AST.NO_ARTI = A.NO_ARTI
                 AND AST.STOCK > 0)
       group by no_arti, A.NO_CIA;

    CURSOR C_LeeEmpleado IS
      SELECT * FROM NAF47_TNET.V_EMPLEADOS WHERE CODIGO = Pv_IdResponsable;

    --
    CURSOR C_LeeIdDepa(Cv_IdDeptNAF IN VARCHAR2) IS
      SELECT ID_DEPARTAMENTO, AREA_ID
        FROM DB_COMPRAS.ADMI_DEPARTAMENTO
       WHERE DPTO_COD = Cv_IdDeptNAF
         AND EMPRESA_ID = Pv_IdEmpresa;
    --
    --
    CURSOR C_UsuarioAsig(Cv_IdEmpleado IN VARCHAR2) IS
      select SUBSTR(MAIL_CIA, 1, instr(MAIL_CIA, '@', 1, 1) - 1)
        from NAF47_TNET.arplme
       where no_cia = Pv_IdEmpresa
         and no_emple = Cv_IdEmpleado;
    --
    CURSOR C_LeeStockxBodegas(Cv_IdEmpresa IN VARCHAR2,

                              Cv_IdProducto IN VARCHAR2) IS
      SELECT BA.BODEGA,
             BA.NO_ARTI,
             DECODE(SUM((NVL(BA.SAL_ANT_UN, 0) + NVL(BA.COMP_UN, 0) -
                        NVL(BA.CONS_UN, 0) - NVL(BA.VENT_UN, 0) +
                        NVL(BA.OTRS_UN, 0))),
                    0,
                    0,
                    A.COSTO_UNITARIO) COSTO_UNI,
             ((NVL(BA.SAL_ANT_UN, 0) + NVL(BA.COMP_UN, 0) -
             NVL(BA.CONS_UN, 0) - NVL(BA.VENT_UN, 0) + NVL(BA.OTRS_UN, 0))) STOCK
        FROM NAF47_TNET.ARINMA BA, NAF47_TNET.ARINDA A
       WHERE BA.NO_ARTI = A.NO_ARTI
         AND BA.NO_CIA = A.NO_CIA
         AND A.NO_CIA = Cv_IdEmpresa
         AND A.NO_aRTI = Cv_IdProducto

         AND ((NVL(BA.SAL_ANT_UN, 0) + NVL(BA.COMP_UN, 0) -
             NVL(BA.CONS_UN, 0) - NVL(BA.VENT_UN, 0) + NVL(BA.OTRS_UN, 0))) > 0
       GROUP BY BA.BODEGA,
                BA.NO_ARTI,
                A.COSTO_UNITARIO,
                BA.SAL_ANT_UN,
                BA.COMP_UN,
                BA.CONS_UN,
                BA.VENT_UN,
                BA.OTRS_UN,
                BA.NO_CIA;
    --
    CURSOR C_LeeSubtotalPedidoDet(Cn_IdPedido IN NUMBER) IS
      SELECT SUM(SUBTOTAL)
        FROM DB_COMPRAS.INFO_PEDIDO_DETALLE
       WHERE PEDIDO_ID = Cn_IdPedido;

    Lv_UsuarioAsig    VARCHAR2(50) := NULL;
    Ln_IdDepartamento DB_COMPRAS.ADMI_DEPARTAMENTO.ID_DEPARTAMENTO%TYPE := NULL;
    Ln_IdArea         DB_COMPRAS.ADMI_DEPARTAMENTO.AREA_ID%TYPE := NULL;
    Ln_TotalMontoMaster   NUMBER(18, 2) := 0;
    Lr_Pedidos            DB_COMPRAS.INFO_PEDIDO%ROWTYPE := NULL;
    Lr_PedidosDet         DB_COMPRAS.INFO_PEDIDO_DETALLE%ROWTYPE := NULL;
    Lr_ReservasProductos  DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE := NULL;
    Lr_PedidosAprobacion  DB_COMPRAS.INFO_PEDIDO_APROBACION%ROWTYPE := NULL;
    Lr_PedidoPedidoEstado DB_COMPRAS.INFO_PEDIDO_ESTADO%ROWTYPE := NULL;
    Lr_PedidoSolicitud    DB_COMPRAS.INFO_SOLICITUD%ROWTYPE := NULL;
    Lr_Empleados          C_LeeEmpleado%ROWTYPE := NULL;
    --
    Ln_CANTIDAD_SOLICITADA NUMBER(18, 2) := 0;
    Ln_COSTO_PRODUCTO      NUMBER(18, 2) := 0;
    Ln_SUBTOTAL            NUMBER(18, 2) := 0;
    Ln_CANTIDAD_RESERVADA  NUMBER(18, 2) := 0;
    Ln_CANTIDAD            NUMBER(18, 2) := 0;
    Ln_LineaReserva        NUMBER(10) := 0;
    Ln_TotalSubtotal       NUMBER(18, 2) := 0;

    Lv_IpCreacion VARCHAR2(20) := '127.0.0.1';
    Le_Error EXCEPTION;

  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El Codigo de Empresa no Puede ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdResponsable IS NULL THEN
      Pv_MensajeError := 'El Codigo del Responsable no Puede ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_Login IS NULL THEN
      Pv_MensajeError := 'El Codigo de LOGIN no Puede ser Nulo.';
      RAISE Le_Error;
    END IF;
    --
    IF C_LeeEmpleado%ISOPEN THEN
      CLOSE C_LeeEmpleado;
    END IF;
    --
    Lr_Empleados := NULL;
    OPEN C_LeeEmpleado;
    FETCH C_LeeEmpleado
      INTO Lr_Empleados;
    CLOSE C_LeeEmpleado;
    --
    IF Lr_Empleados.Estado != 'A' THEN
      Pv_MensajeError := 'El Empleado No Puede Estar Inactivo o Pendiente de Liquidacion.';
      RAISE Le_Error;
    END IF;
    Ln_IdDepartamento := NULL;
    Ln_IdArea         := NULL;
    IF C_LeeIdDepa%ISOPEN THEN
      CLOSE C_LeeIdDepa;
    END IF;
    OPEN C_LeeIdDepa(Lr_Empleados.COD_DEPA);
    FETCH C_LeeIdDepa
      INTO Ln_IdDepartamento, Ln_IdArea;
    CLOSE C_LeeIdDepa;
    --
    --Para recueorar el usuario que procesa
    Lv_UsuarioAsig := NULL;
    IF C_UsuarioAsig%ISOPEN THEN
      CLOSE C_UsuarioAsig;
    END IF;
    OPEN C_UsuarioAsig(Lr_Empleados.CODIGO);
    FETCH C_UsuarioAsig
      INTO Lv_UsuarioAsig;
    CLOSE C_UsuarioAsig;

    Ln_TotalMontoMaster := 0;
    --

    --
    Lr_Pedidos                            := NULL;
    Lr_Pedidos.ID_PEDIDO                  := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_PEDIDO');
    Lr_Pedidos.DEPARTAMENTO_ID            := Ln_IdDepartamento;
    Lr_Pedidos.LOGIN                      := Pv_Login;
    Lr_Pedidos.ESTADO                     := 'Autorizado';
    Lr_Pedidos.USR_CREACION               := USER;
    Lr_Pedidos.FE_CREACION                := SYSDATE;
    Lr_Pedidos.PEDIDO_TIPO                := 'Ins'; --Confirmar este campo que deberia ser
    Lr_Pedidos.USR_ASIGNADO_TIPO          := 'EMP';
    Lr_Pedidos.TIPO_SERVICIO              := 'BI';
    Lr_Pedidos.DESCONTAR_MONTO_APROBACION := 'N'; --Confirmar este campo que deberia ser
    Lr_Pedidos.MONTO_POR_APROBAR          := 0; --Ln_TotalMontoMaster; --Confirmar este campo que deberia ser
    Lr_Pedidos.TIPO_PROCESO               := 'Manual';
    Lr_Pedidos.IP_CREACION                := Lv_IpCreacion;
    Lr_Pedidos.USR_CREACION_ID            := Lr_Empleados.CODIGO; --Codigo del Empleado
    --
    Lr_Pedidos.OBSERVACION              := 'PROCESO DE IDENTIFICACION RECURRENTES CON STOCK';
    Lr_Pedidos.VALOR_TOTAL              := 0; --Ln_TotalMontoMaster;
    Lr_Pedidos.MONTO_TOTAL_APROBACION   := 0; --Ln_TotalMontoMaster;
    Lr_Pedidos.MONTO_INICIAL_APROBACION := 0; --Ln_TotalMontoMaster;
    Lr_Pedidos.SALDO_APROBACION         := 0;
    Lr_Pedidos.VALOR_DESCONTADO         := 0;
    Lr_Pedidos.USR_JEFE_ID              := Lr_Empleados.CODIGO;
    Lr_Pedidos.USR_JEFE                 := Lv_UsuarioAsig;
    Lr_Pedidos.NOMBRES_JEFE             := Lr_Empleados.NOMBRES;
    Lr_Pedidos.USR_AUTORIZA_ID          := Lr_Empleados.CODIGO;
    Lr_Pedidos.USR_AUTORIZA             := Lv_UsuarioAsig;
    Lr_Pedidos.USR_MONTO_APROBACION_ID  := Lr_Empleados.CODIGO;
    Lr_Pedidos.USR_MONTO_APROBACION     := Lv_UsuarioAsig;
    Lr_Pedidos.TIPO_PROCESO             := 'Manual';

    --INSERTAMOS EL PEDIDO MASTER CON EL LOGIN MASTER
    NAF47_TNET.INK_PROCESA_RECURRENTES.P_INSERTA_PEDIDO(Lr_Pedidos, Pv_MensajeError);

    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --

    --
    --INSERTA PEDIDOS DE APROBACION DE PEDIDOS

    Lr_PedidosAprobacion                      := NULL;
    Lr_PedidosAprobacion.ID_PEDIDO_APROBACION := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_PEDIDO_APROBACION');
    Lr_PedidosAprobacion.VALOR_PEDIDO         := Ln_TotalMontoMaster;
    Lr_PedidosAprobacion.VALOR_UTILIZADO      := Ln_TotalMontoMaster;
    Lr_PedidosAprobacion.VALOR_EXCEDIDO       := Ln_TotalMontoMaster;
    Lr_PedidosAprobacion.VALOR_AUTORIZADO     := Ln_TotalMontoMaster;
    Lr_PedidosAprobacion.OBSERVACION          := 'AUTORIZACION DE PEDIDOS POR STOCK DE PEDIDOS RECURRENTES';
    Lr_PedidosAprobacion.FE_CREACION          := SYSDATE;
    Lr_PedidosAprobacion.ESTADO               := 'Autorizado';
    Lr_PedidosAprobacion.USUARIO_AUTORIZA_ID  := Lr_Empleados.CODIGO;
    Lr_PedidosAprobacion.USUARIO_AUTORIZA     := Lv_UsuarioAsig;
    Lr_PedidosAprobacion.PEDIDO_ID            := Lr_Pedidos.ID_PEDIDO;
    Lr_PedidosAprobacion.USR_CREACION         := user;
    Lr_PedidosAprobacion.USUARIO_JEFE         := Lv_UsuarioAsig;
    Lr_PedidosAprobacion.USR_APROBACION_ID    := Lr_Empleados.CODIGO;
    Lr_PedidosAprobacion.USR_APROBACION       := Lv_UsuarioAsig;
    Lr_PedidosAprobacion.TIPO_AUTORIZACION    := 'PED';
    Lr_PedidosAprobacion.IP_CREACION          := Lv_IpCreacion;
    Lr_PedidosAprobacion.EMPRESA_ID           := 1;

    NAF47_TNET.INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_APROBACION(Lr_PedidosAprobacion,
                                                       Pv_MensajeError);
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    --INSERTA PEDIDOS ESTADOS
    Lr_PedidoPedidoEstado.ID_PEDIDO_ESTADO := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_PEDIDO_ESTADO');
    Lr_PedidoPedidoEstado.USR_CREACION     := USER;
    Lr_PedidoPedidoEstado.ESTADO           := 'Autorizado';
    Lr_PedidoPedidoEstado.FE_CREACION      := SYSDATE;
    Lr_PedidoPedidoEstado.PEDIDO_ID        := Lr_Pedidos.ID_PEDIDO;
    Lr_PedidoPedidoEstado.IP_CREACION      := Lv_IpCreacion;

    NAF47_TNET.INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_ESTADO(Lr_PedidoPedidoEstado,
                                                   Pv_MensajeError);
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;

    --
    --
    Lr_PedidoSolicitud := NULL;

    Lr_PedidoSolicitud.ID_SOLICITUD := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_SOLICITUD');
    Lr_PedidoSolicitud.TIPO         := 'Bie';
    Lr_PedidoSolicitud.VALOR_TOTAL  := 0; ---***
    Lr_PedidoSolicitud.ESTADO       := 'Finalizada';
    Lr_PedidoSolicitud.PEDIDO_ID    := Lr_Pedidos.ID_PEDIDO;
    Lr_PedidoSolicitud.FE_CREACION  := sysdate;
    Lr_PedidoSolicitud.IP_CREACION  := Lv_IpCreacion;

    Lr_PedidoSolicitud.USR_CREACION             := USER;
    Lr_PedidoSolicitud.OBSERVACION              := 'PROCESO DE RESERVA DE STOCK PRODUCTOS RECURRENTES/PROYECTO LOGIN POR PEDIDOS';
    Lr_PedidoSolicitud.EMPRESA_ID               := 1;
    Lr_PedidoSolicitud.AREA_ID                  := Ln_IdArea;
    Lr_PedidoSolicitud.DEPARTAMENTO_ID          := Ln_IdDepartamento;
    Lr_PedidoSolicitud.TOTAL_DESCUENTO          := 0;
    Lr_PedidoSolicitud.TOTAL_IVA                := 0;
    Lr_PedidoSolicitud.SUBTOTAL                 := 0; 
    Lr_PedidoSolicitud.REGION                   := 'C';
    Lr_PedidoSolicitud.PROCESO_SOLICITUD_COMPRA := 'R';
    Lr_PedidoSolicitud.VALOR                    := 0; 

    Lr_PedidoSolicitud.TOTAL_SERVICIO := 0;
    Lr_PedidoSolicitud.TOTAL_IMPUESTO := 0;

    INK_PROCESA_RECURRENTES.P_INSERT_PEDIDO_SOLICITUD(Lr_PedidoSolicitud,
                                                      Pv_MensajeError);
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    FOR Recurrente IN C_LeeProdRecurrentes LOOP
      --

      --
      Lr_PedidosDet                                := NULL;
      Lr_PedidosDet.ID_PEDIDO_DETALLE              := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_PEDIDO_DETALLE');
      Lr_PedidosDet.CANTIDAD_SOLICITADA            := 0; 
      Lr_PedidosDet.COSTO_PRODUCTO                 := 0;
      Lr_PedidosDet.SUBTOTAL                       := 0; 
      Lr_PedidosDet.ES_COMPRA                      := 'N';
      Lr_PedidosDet.DESCRIPCION_SOLICITADA         := Recurrente.DESCRIPCION;
      Lr_PedidosDet.FE_CREACION                    := SYSDATE;
      Lr_PedidosDet.USR_CREACION                   := USER;
      Lr_PedidosDet.IP_CREACION                    := Lv_IpCreacion;
      Lr_PedidosDet.PEDIDO_ID                      := Lr_Pedidos.ID_PEDIDO;
      Lr_PedidosDet.PEDIDO_USO_ID                  := 12; --
      Lr_PedidosDet.USR_ASIGNADO_ID                := Lr_Empleados.CODIGO;
      Lr_PedidosDet.USR_ASIGNADO                   := Lv_UsuarioAsig;
      Lr_PedidosDet.CARACTERISTICA_ID              := 0;
      Lr_PedidosDet.PRODUCTO_EMPRESA_ID            := 1;
      Lr_PedidosDet.PRODUCTO_ID                    := Recurrente.NO_ARTI_ARINDA;
      Lr_PedidosDet.DESCRIPCION                    := Recurrente.DESCRIPCION;
      Lr_PedidosDet.PRODUCTO_EMPRESA_ID_REASIGNADO := 0;
      Lr_PedidosDet.OBSERVACION                    := 'PROCESO DE RESERVA DE STOCK PRODUCTOS RECURRENTES/PROYECTO LOGIN POR PEDIDOS';
      Lr_PedidosDet.ESTADO                         := 'Autorizado';
      Lr_PedidosDet.ES_DESCUENTO_ROL               := 'N';
      Lr_PedidosDet.DEVOLUCION                     := 'N';
      Lr_PedidosDet.CANTIDAD_A_DEVOLVER            := 0;
      Lr_PedidosDet.ES_CONSUMIBLE                  := 'N';
      Lr_PedidosDet.CANTIDAD_DESPACHADA            := 0;
      Lr_PedidosDet.CANTIDAD_RESERVADA             := 0; 
      Lr_PedidosDet.CANTIDAD                       := 0; 

      NAF47_TNET.INK_PROCESA_RECURRENTES.P_INSERTA_PEDIDO_DET(Lr_PedidosDet,
                                                   Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      ---
      --Inserta Reservas Prodcutos

      Ln_CANTIDAD_SOLICITADA := 0;
      Ln_COSTO_PRODUCTO      := 0;
      Ln_SUBTOTAL            := 0;
      Ln_CANTIDAD_RESERVADA  := 0;
      Ln_CANTIDAD            := 0;
      Ln_LineaReserva        := 0;
      FOR Lr_ReservaProd IN C_LeeStockxBodegas(Pv_IdEmpresa,
                                               Recurrente.NO_ARTI_ARINDA) LOOP
        Lr_ReservasProductos                      := NULL;
        Ln_LineaReserva                           := Ln_LineaReserva + 1;
        Lr_ReservasProductos.ID_RESERVA_PRODUCTOS := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_RESERVA_PRODUCTOS');
        Lr_ReservasProductos.EMPRESA_ID           := '1';
        Lr_ReservasProductos.BODEGA               := Lr_ReservaProd.BODEGA;
        Lr_ReservasProductos.NO_ARTI              := Recurrente.NO_ARTI_ARINDA;
        Lr_ReservasProductos.DESCRIPCION          := Recurrente.DESCRIPCION;
        Lr_ReservasProductos.CANTIDAD             := Lr_ReservaProd.STOCK;
        Lr_ReservasProductos.TIPO_MOV             := 'I';
        Lr_ReservasProductos.PEDIDO_DETALLE_ID    := Lr_PedidosDet.ID_PEDIDO_DETALLE;
        Lr_ReservasProductos.NO_CIA               := Pv_IdEmpresa;
        Lr_ReservasProductos.FECHA_CREACION       := SYSDATE;
        Lr_ReservasProductos.USUARIO_CREACION     := USER;
        --

        --
        Ln_CANTIDAD_SOLICITADA := Ln_CANTIDAD_SOLICITADA +
                                  NVL(Lr_ReservaProd.STOCK, 0);

        Ln_COSTO_PRODUCTO     := Ln_COSTO_PRODUCTO +
                                 round(NVL(Lr_ReservaProd.COSTO_UNI, 0), 2);
        Ln_SUBTOTAL           := Ln_SUBTOTAL +
                                 (Lr_ReservaProd.STOCK *
                                 round(NVL(Lr_ReservaProd.COSTO_UNI, 0), 2));
        Ln_CANTIDAD_RESERVADA := Ln_CANTIDAD_RESERVADA +
                                 NVL(Lr_ReservaProd.STOCK, 0);
        Ln_CANTIDAD           := Ln_CANTIDAD + NVL(Lr_ReservaProd.STOCK, 0);

        --
        NAF47_TNET.INK_PROCESA_RECURRENTES.P_INSERTA_RESERVA_PRODUCTO(Lr_ReservasProductos, --
                                                           Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --

      --
      END LOOP;
      --Despues que se ejecuta la reserva se procede a actualizar las cantidades y totales del pedido_detalle master
      UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE
         SET CANTIDAD_SOLICITADA = Ln_CANTIDAD_SOLICITADA,
             COSTO_PRODUCTO      = ROUND((Ln_COSTO_PRODUCTO /
                                         Ln_LineaReserva),
                                         2),
             SUBTOTAL            = Ln_SUBTOTAL,
             CANTIDAD_RESERVADA  = Ln_CANTIDAD_RESERVADA,
             CANTIDAD            = Ln_CANTIDAD
       WHERE ID_PEDIDO_DETALLE = Lr_PedidosDet.ID_PEDIDO_DETALLE
         AND PEDIDO_ID = Lr_Pedidos.ID_PEDIDO;

    END LOOP;
    --
    --
    Ln_TotalSubtotal := 0;
    IF C_LeeSubtotalPedidoDet%ISOPEN THEN
      CLOSE C_LeeSubtotalPedidoDet;
    END IF;
    OPEN C_LeeSubtotalPedidoDet(Lr_Pedidos.ID_PEDIDO);
    FETCH C_LeeSubtotalPedidoDet
      INTO Ln_TotalSubtotal;
    CLOSE C_LeeSubtotalPedidoDet;

    UPDATE DB_COMPRAS.INFO_PEDIDO
       SET MONTO_POR_APROBAR        = Ln_TotalSubtotal,
           VALOR_TOTAL              = Ln_TotalSubtotal,
           MONTO_TOTAL_APROBACION   = Ln_TotalSubtotal,
           MONTO_INICIAL_APROBACION = Ln_TotalSubtotal
     WHERE ID_PEDIDO = Lr_Pedidos.ID_PEDIDO;
    --
    --
    UPDATE DB_COMPRAS.INFO_PEDIDO_APROBACION
       SET VALOR_PEDIDO     = Ln_TotalSubtotal,
           VALOR_UTILIZADO  = Ln_TotalSubtotal,
           VALOR_EXCEDIDO   = 0,
           VALOR_AUTORIZADO = Ln_TotalSubtotal
     WHERE PEDIDO_ID = Lr_Pedidos.ID_PEDIDO;
    ---
    UPDATE DB_COMPRAS.INFO_SOLICITUD
       SET VALOR_TOTAL = Ln_TotalSubtotal, SUBTOTAL = Ln_TotalSubtotal
     WHERE ID_SOLICITUD = Lr_PedidoSolicitud.ID_SOLICITUD;
    --
    --Numero de Pedido Generado por el Proceso..
    Pn_IdPedidoMaster := Lr_Pedidos.ID_PEDIDO;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_RECURRENTES.P_PROCESA_RECURRENTES ' ||
                         Pv_MensajeError;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_RECURRENTES.P_PROCESA_RECURRENTES ' ||
                         SQLCODE || ' ' || SQLERRM;
      RETURN;

  END P_PROCESA_RECURRENTES;
END INK_PROCESA_RECURRENTES;
/