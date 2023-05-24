CREATE OR REPLACE package NAF47_TNET.COK_ORDEN_COMPRA_PEDIDO is
  /**
  * Documentacion para NAF47_TNET.COK_ORDEN_COMPRA_PEDIDO
  * Paquete que contiene procesos y funciones para generar solicitudes de compras desde modulo inventarios y pedidos de servicios
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/06/2017
  *
  */

  /**
  * @author     TN Jimmy Gilces
  * @proposito  Modificacion de Procesos para acoplarlo a las revisiones de articulos pre/post algorimto
  */


  /**
  * Documentacion para P_REPLICA_ORDEN
  * Procedure que generar replica orden de compra generda en Pedidos de Compras hacia Naf-Compras
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/06/2017
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 16/02/2018 - Se modifica para corregir asignacion de los campos SUBTOTAL y DESCUENTO
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 27/07/2020 - Se modifica para agregar nueva funcionalida de Pedidos de Servicios.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 17/11/2020 - Se modifica reemplazar el tipo de pedido 'SER' por 'SE'.
  *
  * @author banton <banton@telconet.ec>
  * @version 1.4 20/05/2021 - Se modifica para que traiga registro de compras sin pedido relacionado
  *
  * @author banton <banton@telconet.ec>
  * @version 1.5 19/08/2021 - Se modifica para asignar como solicitante al jefe de bodega por region
  *
  * @author banton <banton@telconet.ec>
  * @version 1.6 20/09/2022 - Se agrega dias de entrega y fecha de vencimiento ingresados
  *
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.7 15/01/2023 - Se procede con el cambio la funcion GEK_CONSULTA.F_RECUPERA_LOGIN por la senetencia LOWER(USER)
  *
  * @param Pn_IdOrdenCompra IN VARCHAR2 Recibe numero de orden de compra
  * @param Pv_Login         IN VARCHAR2 Recibe login
  * @param Pv_MensajeError  IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_REPLICA_ORDEN(Pn_IdOrdenCompra IN NUMBER,
                            Pv_Login         IN VARCHAR2,
                            Pv_MensajeError  IN OUT VARCHAR2);

  /**
  * Documentacion para P_GENERA_PEDIDO_COMPRA_BIENES
  * Procedure que generar solicitud de orden de compra de productos recurrentes
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/06/2017
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 22/09/2017 Se modifica para agregar puntero que permitira hacer rollback solo en este procedimiento sin afectar los cambios
  *                         realizados por el procedimiento que lo invoca.
  *                         Se agrega filtro que identifica los articulos recurrentes en query principal
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 16/02/2018 - Se modifica que generacion de solicitud compra pueda ejecutarse desde transferencias Interbodegas
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 28/02/2018 - Se modifica actualizar estado de solicitud de compra
  *
  * @param Pn_NoPedido    IN VARCHAR2 Recibe numero de pedido
  * @param Pv_NoCia       IN VARCHAR2 Recibe codigo de compania
  * @param Pn_NoSolicitud IN OUT VARCHAR2 Retorna numero solicitud de compra generada.
  */
  PROCEDURE P_GENERA_PEDIDO_COMPRA_BIENES(Pn_NoPedido    IN NUMBER,
                                          Pv_NoCia       IN VARCHAR2,
                                          Pn_NoSolicitud IN OUT NUMBER,
                                          Pv_NoTransf    IN VARCHAR2 DEFAULT NULL);

  /**
  * Documentacion para P_ACTUALIZA_VALORES_PEDIDO
  * Procedure que actualiza los montos del pedido en base a la orden de compra asociada.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 09/04/2021
  *
  * @param Pv_NoOrden      IN VARCHAR2 Recibe numero de orden de compra NAF
  * @param Pv_NoCia        IN VARCHAR2 Recibe codigo de compania
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_ACTUALIZA_VALORES_PEDIDO(Pv_NoOrden      IN VARCHAR2,
                                       Pv_NoCia        IN VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_SOLICITUD_COMPRA_BIENES
  * Procedimiento que genera solicitudes de compra en base a algoritmo
  * que registra los articulo por region en una tabla temporal para generarlas.
  * @author banton <banton@telconet.ec>
  * @version 1.0 20/05/2021
  *
  * @author jgilces <jgilces@telconet.ec>
  * @version 1.1 08/08/2022 - Se a?ade actualizacion de estado para la tabla de modificacion de articulos fijos/recurrentes bodega.
  *
  * @param Pv_Error IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_SOLICITUD_COMPRA_BIENES(Pv_Error OUT VARCHAR2);

  /**
  * Documentacion para Lr_ArticulosType
  * arreglo que contiene elementos para genera solcitudes de compra
  * @author banton <banton@telconet.ec>
  * @version 1.0 20/04/2022
  *
  */
  TYPE Lr_ArticulosType IS RECORD 
      (No_Arti NAF47_TNET.ARINDA.NO_ARTI%TYPE,
       Cantidad NUMBER,
       Id_PedidoDetalle DB_COMPRAS.INFO_PEDIDO_DETALLE.ID_PEDIDO_DETALLE%TYPE);

  TYPE Lt_ArticulosType IS TABLE OF Lr_ArticulosType INDEX by BINARY_INTEGER;
  
  /**
  * Documentacion para P_GENERA_SOL_ARTICULOS
  * Procedimiento que genera solicitudes de compra desde la opcion de despachos de pedidos
  * @author banton <banton@telconet.ec>
  * @version 1.0 20/04/2022
  *
  * Se agrega observacion en cabecera de solicitud
  * @author banton <banton@telconet.ec>
  * @version 1.1 21/05/2022
  */
  
  PROCEDURE P_GENERA_SOL_ARTICULOS (Pn_Pedido    DB_COMPRAS.INFO_PEDIDO.ID_PEDIDO%TYPE,
                                    Pt_Articulos Lt_ArticulosType,
                                    Pv_Error OUT VARCHAR2);
                                    
  /**
  * Documentacion para P_INSERTA_CAT_ART_KATUK_CAB
  * Procedimiento que inserta registro en tabla principal de catalogos en NAF
  * @author banton <banton@telconet.ec>
  * @version 1.0 20/04/2022
  *
  */                               
   
   PROCEDURE P_INSERTA_CAT_ART_KATUK_CAB (Pr_CatArtKatuk  IN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2);                                   
                                  
  /**
  * Documentacion para P_INSERTA_CAT_ART_KATUK_DET
  * Procedimiento que inserta registro en tabla detalle de catalogos en NAF
  * @author banton <banton@telconet.ec>
  * @version 1.0 20/04/2022
  *
  */ 
   PROCEDURE P_INSERTA_CAT_ART_KATUK_DET (Pr_CatArtKatuk  IN NAF47_TNET.ARIN_CATALOGO_KATUK_DET%ROWTYPE,
                                          Pv_MensajeError IN OUT VARCHAR2);
                                          
  /**
  * Documentacion para P_INSERT_CAT_ART_KATUK
  * Funcion que recibe un parametro de formato Json con informacion para crear catalogos
  * @author banton <banton@telconet.ec>
  * @version 1.0 20/04/2022
  *
  */  
   
  PROCEDURE P_INSERT_CAT_ART_KATUK(PC_JSON IN CLOB,
                                   PV_STATUS    OUT VARCHAR2,
                                   PV_MENSAJE   OUT VARCHAR2);                                          
                                                                                                           


end COK_ORDEN_COMPRA_PEDIDO;
/
CREATE OR REPLACE package body NAF47_TNET.COK_ORDEN_COMPRA_PEDIDO is
  /**
  * Documentacion para P_INSERTA_CABECERA_ORDEN
  * Procedure que inserta registro de orden de compra
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/06/2017
  *
  * @param Pr_OrdenCompra  IN     VARCHAR2 Recibe registro de orden de compra.
  * @param Pv_MensajeError IN OUT VARCHAR2 retorna mensaje de error
  */
  PROCEDURE P_INSERTA_CABECERA_ORDEN(Pr_OrdenCompra  IN TAPORDEE%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
    INSERT INTO TAPORDEE
      (NO_CIA,
       NO_ORDEN,
       ESTADO,
       NO_PROVE,
       IND_NO_INV,
       FECHA,
       FECHA_VENCE,
       DIAS_ENTREGA,
       FORMA_PAGO,
       TERMINO_PAGO,
       MONTO,
       IMP_VENTAS,
       DESCUENTO,
       TOTAL,
       OBSERV,
       ADJUDICADOR,
       TIPO_CAMBIO,
       MONEDA,
       USUARIO,
       MANEJA_ANTICIPO,
       ID_TIPO_TRANSACCION,
       TIPO_DISTRIBUCION_COSTO)
    VALUES
      (Pr_OrdenCompra.No_Cia,
       Pr_OrdenCompra.no_orden,
       Pr_OrdenCompra.estado,
       Pr_OrdenCompra.no_prove,
       Pr_OrdenCompra.ind_no_inv,
       Pr_OrdenCompra.fecha,
       Pr_OrdenCompra.Fecha_Vence,
       Pr_OrdenCompra.dias_entrega,
       Pr_OrdenCompra.forma_pago,
       Pr_OrdenCompra.Termino_Pago,
       Pr_OrdenCompra.monto,
       Pr_OrdenCompra.imp_ventas,
       Pr_OrdenCompra.descuento,
       Pr_OrdenCompra.total,
       Pr_OrdenCompra.observ,
       Pr_OrdenCompra.adjudicador,
       Pr_OrdenCompra.tipo_cambio,
       Pr_OrdenCompra.moneda,
       Pr_OrdenCompra.usuario,
       Pr_OrdenCompra.maneja_anticipo,
       Pr_OrdenCompra.id_tipo_transaccion,
       Pr_OrdenCompra.Tipo_Distribucion_Costo);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error NAF47_TNET.COK_ORDEN_COMPRA_PEDIDO.P_INSERTA_CABECERA_ORDEN. ' ||
                         SQLERRM;
      ROLLBACK;
  END P_INSERTA_CABECERA_ORDEN;

  /**
  * Documentacion para P_INSERTA_DETALLE_ORDEN
  * Procedure que inserta registro detalle orden de compra
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/06/2017
  *
  * @param Pr_DetOrdenCompra  IN     VARCHAR2 Recibe registro de detalle orden de compra.
  * @param Pv_MensajeError    IN OUT VARCHAR2 retorna mensaje de error
  */
  PROCEDURE P_INSERTA_DETALLE_ORDEN(Pr_DetOrdenCompra IN TAPORDED%ROWTYPE,
                                    Pv_MensajeError   IN OUT VARCHAR2) IS
  BEGIN
    INSERT INTO TAPORDED
      (NO_CIA,
       NO_ORDEN,
       NO_LINEA,
       CODIGO_NI,
       NO_ARTI,
       DESCRIPCION,
       CANTIDAD,
       COSTO_UNI,
       DESCUENTO,
       IMPUESTOS,
       ID_PEDIDO_DETALLE)
    VALUES
      (Pr_DetOrdenCompra.No_Cia,
       Pr_DetOrdenCompra.No_Orden,
       Pr_DetOrdenCompra.No_Linea,
       Pr_DetOrdenCompra.Codigo_Ni,
       Pr_DetOrdenCompra.No_Arti,
       Pr_DetOrdenCompra.Descripcion,
       Pr_DetOrdenCompra.Cantidad,
       Pr_DetOrdenCompra.Costo_Uni,
       Pr_DetOrdenCompra.Descuento,
       Pr_DetOrdenCompra.Impuestos,
       Pr_DetOrdenCompra.Id_Pedido_Detalle);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error NAF47_TNET.COK_ORDEN_COMPRA_PEDIDO.P_INSERTA_DETALLE_ORDEN. ' ||
                         SQLERRM;
      ROLLBACK;
  END P_INSERTA_DETALLE_ORDEN;

  /**
  * Documentacion para P_INSERTA_FLUJO_APROBACION
  * Procedure que que genera flujo de aprobacion
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/06/2017
  *
  * @param Pr_FlujoAprobacion IN     VARCHAR2 Recibe registro de flujo de aprobacion.
  * @param Pv_MensajeError    IN OUT VARCHAR2 retorna mensaje de error
  */
  PROCEDURE P_INSERTA_FLUJO_APROBACION(Pr_FlujoAprobacion IN CO_FLUJO_APROBACION%ROWTYPE,
                                       Pv_MensajeError    IN OUT VARCHAR2) IS
  BEGIN
    --
    INSERT INTO CO_FLUJO_APROBACION
      (ID_EMPRESA,
       SECUENCIA,
       SECUENCIA_FLUJO,
       TIPO_FLUJO,
       ID_ORDEN,
       ID_EMPLEADO,
       FECHA,
       ESTADO,
       USUARIO_CREA,
       FECHA_CREA)
    VALUES
      (Pr_FlujoAprobacion.id_empresa,
       Pr_FlujoAprobacion.secuencia,
       Pr_FlujoAprobacion.secuencia_flujo,
       Pr_FlujoAprobacion.tipo_flujo,
       Pr_FlujoAprobacion.id_orden,
       Pr_FlujoAprobacion.id_empleado,
       Pr_FlujoAprobacion.fecha,
       Pr_FlujoAprobacion.estado,
       Pr_FlujoAprobacion.usuario_crea,
       Pr_FlujoAprobacion.fecha_crea);
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error NAF47_TNET.COK_ORDEN_COMPRA_PEDIDO.P_INSERTA_FLUJO_APROBACION. ' ||
                         SQLERRM;
      ROLLBACK;
  END P_INSERTA_FLUJO_APROBACION;

  /**
  * Documentacion para P_INSERTA_INFO_SOLICITUD
  * Procedure que inserta registro en DB_COMPRAS.INFO_SOLICITUD
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/06/2017
  *
  * @param Pr_InfoSolicitud IN DB_COMPRAS.INFO_SOLICITUD%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError  IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_INFO_SOLICITUD(Pr_InfoSolicitud IN DB_COMPRAS.INFO_SOLICITUD%ROWTYPE,
                                     Pv_MensajeError  IN OUT VARCHAR2) IS
  BEGIN
    INSERT INTO DB_COMPRAS.INFO_SOLICITUD
      (ID_SOLICITUD,
       TIPO,
       VALOR_TOTAL,
       ESTADO,
       PEDIDO_ID,
       FE_CREACION,
       IP_CREACION,
       USR_ULT_MOD,
       FE_ULT_MOD,
       USR_CREACION,
       OBSERVACION,
       EMPRESA_ID,
       AREA_ID,
       DEPARTAMENTO_ID,
       TOTAL_DESCUENTO,
       TOTAL_IVA,
       SUBTOTAL,
       REGION,
       PROCESO_SOLICITUD_COMPRA)
    VALUES
      (Pr_InfoSolicitud.id_solicitud,
       Pr_InfoSolicitud.tipo,
       Pr_InfoSolicitud.valor_total,
       Pr_InfoSolicitud.estado,
       Pr_InfoSolicitud.pedido_id,
       Pr_InfoSolicitud.fe_creacion,
       Pr_InfoSolicitud.ip_creacion,
       Pr_InfoSolicitud.usr_ult_mod,
       Pr_InfoSolicitud.fe_ult_mod,
       Pr_InfoSolicitud.usr_creacion,
       Pr_InfoSolicitud.observacion,
       Pr_InfoSolicitud.empresa_id,
       Pr_InfoSolicitud.area_id,
       Pr_InfoSolicitud.departamento_id,
       Pr_InfoSolicitud.total_descuento,
       Pr_InfoSolicitud.total_iva,
       Pr_InfoSolicitud.subtotal,
       Pr_InfoSolicitud.region,
       Pr_InfoSolicitud.Proceso_Solicitud_Compra);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en COK_ORDEN_COMPRA_PEDIDO.P_INSERTA_INFO_SOLICITUD: ' ||
                         SQLERRM;
  END P_INSERTA_INFO_SOLICITUD;

  /**
  * Documentacion para P_INSERTA_INFO_SOLICITUD_DET
  * Procedure que inserta registro en DB_COMPRAS.INFO_SOLICITUD_DETALLE
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/06/2017
  *
  * @param Pr_InfoSolicitudDet IN DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError     IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_INFO_SOLICITUD_DET(Pr_InfoSolicitudDet IN DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE,
                                         Pv_MensajeError     IN OUT VARCHAR2) IS
  BEGIN
    INSERT INTO DB_COMPRAS.INFO_SOLICITUD_DETALLE
      (ID_SOLICITUD_DETALLE,
       CODIGO,
       DESCRIPCION,
       CANTIDAD,
       VALOR,
       SUBTOTAL,
       ESTADO,
       NO_PROVEEDOR,
       CEDULA_PROVEEDOR,
       NOMBRE_PROVEEDOR,
       PROVINCIA_PROVEEDOR,
       EMAIL_PROVEEDOR,
       SOLICITUD_ID,
       USR_CREACION,
       FE_CREACION,
       IP_CREACION,
       USR_ULT_MOD,
       FE_ULT_MOD,
       OBSERVACION,
       ORDEN_COMPRA_ID,
       PEDIDO_DETALLE_ID,
       PORCENTAJE_DESCUENTO,
       VALOR_DESCUENTO,
       IVA,
       VALOR_IVA,
       SERVICIO_ID,
       TOTAL,
       RUTA_ARCHIVO,
       NOMBRE_ARCHIVO,
       FORMATO_ARCHIVO,
       ARCHIVO_COTIZACION,
       CODIGO_GENERA_IMPUESTO,
       VALOR_SERVICIO,
       PORCENTAJE_IMPUESTO,
       VALOR_IMPUESTO)
    VALUES
      (Pr_InfoSolicitudDet.id_solicitud_detalle,
       Pr_InfoSolicitudDet.codigo,
       Pr_InfoSolicitudDet.descripcion,
       Pr_InfoSolicitudDet.cantidad,
       Pr_InfoSolicitudDet.valor,
       Pr_InfoSolicitudDet.subtotal,
       Pr_InfoSolicitudDet.estado,
       Pr_InfoSolicitudDet.no_proveedor,
       Pr_InfoSolicitudDet.cedula_proveedor,
       Pr_InfoSolicitudDet.nombre_proveedor,
       Pr_InfoSolicitudDet.provincia_proveedor,
       Pr_InfoSolicitudDet.email_proveedor,
       Pr_InfoSolicitudDet.solicitud_id,
       Pr_InfoSolicitudDet.usr_creacion,
       Pr_InfoSolicitudDet.fe_creacion,
       Pr_InfoSolicitudDet.ip_creacion,
       Pr_InfoSolicitudDet.usr_ult_mod,
       Pr_InfoSolicitudDet.fe_ult_mod,
       Pr_InfoSolicitudDet.observacion,
       Pr_InfoSolicitudDet.orden_compra_id,
       Pr_InfoSolicitudDet.pedido_detalle_id,
       Pr_InfoSolicitudDet.porcentaje_descuento,
       Pr_InfoSolicitudDet.valor_descuento,
       Pr_InfoSolicitudDet.iva,
       Pr_InfoSolicitudDet.valor_iva,
       Pr_InfoSolicitudDet.servicio_id,
       Pr_InfoSolicitudDet.total,
       Pr_InfoSolicitudDet.ruta_archivo,
       Pr_InfoSolicitudDet.nombre_archivo,
       Pr_InfoSolicitudDet.formato_archivo,
       Pr_InfoSolicitudDet.archivo_cotizacion,
       Pr_InfoSolicitudDet.Codigo_Genera_Impuesto,
       0,
       0,
       0);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en COK_ORDEN_COMPRA_PEDIDO.P_INSERTA_INFO_SOLICITUD_DET: ' ||
                         SQLERRM;
  END P_INSERTA_INFO_SOLICITUD_DET;

  PROCEDURE P_REPLICA_ORDEN(Pn_IdOrdenCompra IN NUMBER,
                            Pv_Login         IN VARCHAR2,
                            Pv_MensajeError  IN OUT VARCHAR2) IS
    --
    Lc_EstSolCompra CONSTANT VARCHAR2(30) := 'Finalizada';
    --
    CURSOR C_ORDEN_COMPRA_PENDIENTE IS
      SELECT E.CODIGO NO_CIA,
             'E' ESTADO,
             OC.NO_PROVEEDOR,
             DECODE(P.TIPO_SERVICIO, 'SE', 'S', 'N') IND_NO_INV,
             TRUNC(OC.FE_CREACION) FECHA,
             OC.DIAS_ENTREGA,
             OC.FECHA_VENCIMIENTO,
             DECODE(OC.FORMA_PAGO, 'Credito', 'C', 'E') FORMA_PAGO,
             UPPER(OC.FORMA_PAGO) TERMINO_PAGO,
             (OC.SUBTOTAL + NVL(OC.DESCUENTO, 0)) AS MONTO,
             OC.VALOR_IVA IMP_VENTAS,
             NVL(OC.DESCUENTO, 0) AS DESCUENTO,
             OC.VALOR_TOTAL TOTAL,
             OC.OBSERVACION OBSERV,
             P.USR_CREACION_ID ADJUDICADOR,
             1 TIPO_CAMBIO,
             'P' MODEDA,
             UPPER(OC.USR_ULT_MOD) USUARIO,
             'N' MANEJA_ANTICIPO,
             P.TIPO_SERVICIO AS ID_TIPO_TRANSACCION,
             OC.ID_ORDEN_COMPRA,
             P.USR_JEFE_ID,
             P.USR_JEFE,
             OC.ESTADO ESTADO_ORDEN,
             OC.SECUENCIA,
             'Manual' AS TIPO_DISTRIBUCION_COSTO
        FROM DB_COMPRAS.INFO_ORDEN_COMPRA OC,
             DB_COMPRAS.INFO_PEDIDO       P,
             DB_COMPRAS.ADMI_DEPARTAMENTO D,
             DB_COMPRAS.ADMI_EMPRESA      E
       WHERE P.TIPO_SERVICIO != 'SE'
         AND OC.PEDIDO_ID = P.ID_PEDIDO
         AND P.DEPARTAMENTO_ID = D.ID_DEPARTAMENTO
         AND D.EMPRESA_ID = E.ID_EMPRESA
         AND OC.ID_ORDEN_COMPRA = NVL(Pn_IdOrdenCompra, OC.ID_ORDEN_COMPRA)
      UNION
      SELECT E.CODIGO NO_CIA,
             'E' ESTADO,
             OC.NO_PROVEEDOR,
             (SELECT DECODE(IP.TIPO_SERVICIO, 'SE', 'S', 'N')
                FROM DB_COMPRAS.INFO_PEDIDO            IP,
                     DB_COMPRAS.INFO_PEDIDO_DETALLE    IPD,
                     DB_COMPRAS.INFO_SOLICITUD_DETALLE ISD
               WHERE IPD.PEDIDO_ID = IP.ID_PEDIDO
                 AND ISD.PEDIDO_DETALLE_ID = IPD.ID_PEDIDO_DETALLE
                 AND ISD.ORDEN_COMPRA_ID = OC.ID_ORDEN_COMPRA
                 AND ROWNUM = 1) IND_NO_INV,
             TRUNC(OC.FE_CREACION) FECHA,
             OC.DIAS_ENTREGA,
             OC.FECHA_VENCIMIENTO,
             DECODE(OC.FORMA_PAGO, 'Credito', 'C', 'E') FORMA_PAGO,
             UPPER(OC.FORMA_PAGO) TERMINO_PAGO,
             (OC.SUBTOTAL + NVL(OC.DESCUENTO, 0)) AS MONTO,
             OC.VALOR_IVA IMP_VENTAS,
             NVL(OC.DESCUENTO, 0) AS DESCUENTO,
             OC.VALOR_TOTAL TOTAL,
             OC.OBSERVACION OBSERV,
             (SELECT VE.NO_EMPLE
                FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
               WHERE VE.LOGIN_EMPLE = OC.USR_CREACION
                 AND VE.NO_CIA = E.CODIGO) ADJUDICADOR,
             1 TIPO_CAMBIO,
             'P' MODEDA,
             UPPER(OC.USR_ULT_MOD) USUARIO,
             'N' MANEJA_ANTICIPO,
             (SELECT IP.TIPO_SERVICIO
                FROM DB_COMPRAS.INFO_PEDIDO            IP,
                     DB_COMPRAS.INFO_PEDIDO_DETALLE    IPD,
                     DB_COMPRAS.INFO_SOLICITUD_DETALLE ISD
               WHERE IPD.PEDIDO_ID = IP.ID_PEDIDO
                 AND ISD.PEDIDO_DETALLE_ID = IPD.ID_PEDIDO_DETALLE
                 AND ISD.ORDEN_COMPRA_ID = OC.ID_ORDEN_COMPRA
                 AND ROWNUM = 1) ID_TIPO_TRANSACCION,
             OC.ID_ORDEN_COMPRA,
             (SELECT VE.ID_JEFE
                FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
               WHERE VE.LOGIN_EMPLE = OC.USR_CREACION
                 AND VE.NO_CIA = E.CODIGO) USR_JEFE_ID,
             (SELECT VJ.LOGIN_EMPLE
                FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS VJ,
                     NAF47_TNET.V_EMPLEADOS_EMPRESAS VE
               WHERE VE.LOGIN_EMPLE = OC.USR_CREACION
                 AND VE.NO_CIA = E.CODIGO
                 AND VE.ID_JEFE = VJ.NO_EMPLE
                 AND VE.NO_CIA_JEFE = VJ.NO_CIA) USR_JEFE,
             OC.ESTADO ESTADO_ORDEN,
             OC.SECUENCIA,
             'Pedido' AS TIPO_DISTRIBUCION_COSTO
      --
        FROM DB_COMPRAS.ADMI_EMPRESA E, DB_COMPRAS.INFO_ORDEN_COMPRA OC
       WHERE OC.ID_ORDEN_COMPRA = NVL(Pn_IdOrdenCompra, OC.ID_ORDEN_COMPRA)
         AND OC.EMPRESA_ID = E.ID_EMPRESA
         AND EXISTS
       (SELECT NULL
                FROM DB_COMPRAS.INFO_PEDIDO            IP,
                     DB_COMPRAS.INFO_PEDIDO_DETALLE    IPD,
                     DB_COMPRAS.INFO_SOLICITUD_DETALLE ISD
               WHERE IP.TIPO_SERVICIO = 'SE'
                 AND IPD.PEDIDO_ID = IP.ID_PEDIDO
                 AND ISD.PEDIDO_DETALLE_ID = IPD.ID_PEDIDO_DETALLE
                 AND ISD.ORDEN_COMPRA_ID = OC.ID_ORDEN_COMPRA)
      UNION
      SELECT E.CODIGO NO_CIA,
             'E' ESTADO,
             OC.NO_PROVEEDOR,
             'N' IND_NO_INV,
             TRUNC(OC.FE_CREACION) FECHA,
             OC.DIAS_ENTREGA,
             OC.FECHA_VENCIMIENTO,
             DECODE(OC.FORMA_PAGO, 'Credito', 'C', 'E') FORMA_PAGO,
             UPPER(OC.FORMA_PAGO) TERMINO_PAGO,
             (OC.SUBTOTAL + NVL(OC.DESCUENTO, 0)) AS MONTO,
             OC.VALOR_IVA IMP_VENTAS,
             NVL(OC.DESCUENTO, 0) AS DESCUENTO,
             OC.VALOR_TOTAL TOTAL,
             OC.OBSERVACION OBSERV,
             (SELECT LE.NO_EMPLE
                FROM DB_COMPRAS.ADMI_DEPARTAMENTO D,
                     DB_COMPRAS.ADMI_AREA         A,
                     DB_COMPRAS.ADMI_EMPRESA      E,
                     NAF47_TNET.ARPLME            ME,
                     NAF47_TNET.LOGIN_EMPLEADO    LE
               WHERE E.ID_EMPRESA = OC.EMPRESA_ID
                 AND EXISTS (SELECT NULL
                        FROM DB_GENERAL.ADMI_PROVINCIA       P,
                             DB_GENERAL.ADMI_CANTON          C,
                             DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
                       WHERE IOG.ID_OFICINA = ME.OFICINA
                         AND P.REGION_ID =
                             DECODE(OC.REGION, 'C', 1, 'S', 2, 0)
                         AND C.PROVINCIA_ID = P.ID_PROVINCIA
                         AND IOG.CANTON_ID = C.ID_CANTON)
                 AND EXISTS
               (SELECT NULL
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET ER
                       WHERE ER.DESCRIPCION = 'ENCARGADO-REGION'
                         AND ER.VALOR3 = LE.LOGIN
                         AND ER.EMPRESA_COD = LE.NO_CIA
                         AND EXISTS
                       (SELECT NULL
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APD
                               WHERE NOMBRE_PARAMETRO =
                                     'PARAMETROS-INVENTARIOS'
                                 AND APD.ID_PARAMETRO = ER.PARAMETRO_ID))
                 AND ME.DEPTO = D.DPTO_COD
                 AND A.ID_AREA = D.AREA_ID
                 AND A.EMPRESA_ID = D.EMPRESA_ID
                 AND ME.AREA = A.COD_AREA
                 AND E.ID_EMPRESA = A.EMPRESA_ID
                 AND LE.NO_CIA = E.CODIGO
                 AND LE.NO_EMPLE = ME.NO_EMPLE
                 AND LE.NO_CIA = ME.NO_CIA) ADJUDICADOR,
             1 TIPO_CAMBIO,
             'P' MODEDA,
             UPPER(OC.USR_ULT_MOD) USUARIO,
             'N' MANEJA_ANTICIPO,
             'BI' AS ID_TIPO_TRANSACCION,
             OC.ID_ORDEN_COMPRA,
             (SELECT LE.NO_EMPLE
                FROM DB_COMPRAS.ADMI_DEPARTAMENTO D,
                     DB_COMPRAS.ADMI_AREA         A,
                     DB_COMPRAS.ADMI_EMPRESA      E,
                     NAF47_TNET.ARPLME            ME,
                     NAF47_TNET.LOGIN_EMPLEADO    LE
               WHERE E.ID_EMPRESA = OC.EMPRESA_ID
                 AND EXISTS (SELECT NULL
                        FROM DB_GENERAL.ADMI_PROVINCIA       P,
                             DB_GENERAL.ADMI_CANTON          C,
                             DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
                       WHERE IOG.ID_OFICINA = ME.OFICINA
                         AND P.REGION_ID =
                             DECODE(OC.REGION, 'C', 1, 'S', 2, 0)
                         AND C.PROVINCIA_ID = P.ID_PROVINCIA
                         AND IOG.CANTON_ID = C.ID_CANTON)
                 AND EXISTS
               (SELECT NULL
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET ER
                       WHERE ER.DESCRIPCION = 'ENCARGADO-REGION'
                         AND ER.VALOR3 = LE.LOGIN
                         AND ER.EMPRESA_COD = LE.NO_CIA
                         AND EXISTS
                       (SELECT NULL
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APD
                               WHERE NOMBRE_PARAMETRO =
                                     'PARAMETROS-INVENTARIOS'
                                 AND APD.ID_PARAMETRO = ER.PARAMETRO_ID))
                 AND ME.DEPTO = D.DPTO_COD
                 AND A.ID_AREA = D.AREA_ID
                 AND A.EMPRESA_ID = D.EMPRESA_ID
                 AND ME.AREA = A.COD_AREA
                 AND E.ID_EMPRESA = A.EMPRESA_ID
                 AND LE.NO_CIA = E.CODIGO
                 AND LE.NO_EMPLE = ME.NO_EMPLE
                 AND LE.NO_CIA = ME.NO_CIA) USR_JEFE_ID,

             (SELECT LE.LOGIN
                FROM DB_COMPRAS.ADMI_DEPARTAMENTO D,
                     DB_COMPRAS.ADMI_AREA         A,
                     DB_COMPRAS.ADMI_EMPRESA      E,
                     NAF47_TNET.ARPLME            ME,
                     NAF47_TNET.LOGIN_EMPLEADO    LE
               WHERE E.ID_EMPRESA = OC.EMPRESA_ID
                 AND EXISTS (SELECT NULL
                        FROM DB_GENERAL.ADMI_PROVINCIA       P,
                             DB_GENERAL.ADMI_CANTON          C,
                             DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
                       WHERE IOG.ID_OFICINA = ME.OFICINA
                         AND P.REGION_ID =
                             DECODE(OC.REGION, 'C', 1, 'S', 2, 0)
                         AND C.PROVINCIA_ID = P.ID_PROVINCIA
                         AND IOG.CANTON_ID = C.ID_CANTON)
                 AND EXISTS
               (SELECT NULL
                        FROM DB_GENERAL.ADMI_PARAMETRO_DET ER
                       WHERE ER.DESCRIPCION = 'ENCARGADO-REGION'
                         AND ER.VALOR3 = LE.LOGIN
                         AND ER.EMPRESA_COD = LE.NO_CIA
                         AND EXISTS
                       (SELECT NULL
                                FROM DB_GENERAL.ADMI_PARAMETRO_CAB APD
                               WHERE NOMBRE_PARAMETRO =
                                     'PARAMETROS-INVENTARIOS'
                                 AND APD.ID_PARAMETRO = ER.PARAMETRO_ID))
                 AND ME.DEPTO = D.DPTO_COD
                 AND A.ID_AREA = D.AREA_ID
                 AND A.EMPRESA_ID = D.EMPRESA_ID
                 AND ME.AREA = A.COD_AREA
                 AND E.ID_EMPRESA = A.EMPRESA_ID
                 AND LE.NO_CIA = E.CODIGO
                 AND LE.NO_EMPLE = ME.NO_EMPLE
                 AND LE.NO_CIA = ME.NO_CIA) USR_JEFE,
             OC.ESTADO ESTADO_ORDEN,
             OC.SECUENCIA,
             'Manual' AS TIPO_DISTRIBUCION_COSTO
        FROM DB_COMPRAS.INFO_ORDEN_COMPRA OC, DB_COMPRAS.ADMI_EMPRESA E
       WHERE OC.EMPRESA_ID = E.ID_EMPRESA
         AND OC.ID_ORDEN_COMPRA = NVL(Pn_IdOrdenCompra, OC.ID_ORDEN_COMPRA)
         AND OC.PEDIDO_ID IS NULL;

    --
    CURSOR C_DETALLE_ORDEN(Cn_IdOrden NUMBER, Cv_TipoOrden VARCHAR2) IS
      SELECT ROWNUM NO_LINEA,
             DECODE(Cv_TipoOrden, 'S', DO.CODIGO, NULL) CODIGO_INI,
             DECODE(Cv_TipoOrden, 'N', DO.CODIGO, NULL) NO_ARTI,
             DO.DESCRIPCION,
             DO.CANTIDAD,
             DO.COSTO COSTO_UNI,
             (DO.PORCENTAJE_DESCUENTO * 100) DESCUENTO,
             DO.VALOR_IVA IMPUESTO
        FROM DB_COMPRAS.INFO_ORDEN_COMPRA_DETALLE DO
       WHERE ORDEN_COMPRA_ID = Cn_IdOrden;
    --
    CURSOR C_SECUENCIA_ORDEN_NAF(Pv_NoCia VARCHAR2) IS
      SELECT NVL(MAX(TO_NUMBER(NO_ORDEN)), 0) + 1
        FROM TAPORDEE
       WHERE NO_CIA = Pv_NoCia;
    --
    CURSOR C_SOLICITUD_NO_FINALIZADA IS
      SELECT ISD.ESTADO
        FROM DB_COMPRAS.INFO_SOLICITUD_DETALLE ISD
       WHERE ISD.ESTADO != Lc_EstSolCompra
         AND EXISTS
       (SELECT NULL
                FROM DB_COMPRAS.INFO_SOLICITUD_DETALLE ISD2
                JOIN DB_COMPRAS.INFO_ORDEN_COMPRA IOC
                  ON IOC.ID_ORDEN_COMPRA = ISD2.ORDEN_COMPRA_ID
               WHERE ISD2.SOLICITUD_ID = ISD.SOLICITUD_ID
                 AND IOC.ID_ORDEN_COMPRA = Pn_IdOrdenCompra);
    --
    Lr_OrdenCompraNaf     NAF47_TNET.TAPORDEE%ROWTYPE := NULL;
    Lr_DetOrdenCompraNaf  NAF47_TNET.TAPORDED%ROWTYPE := NULL;
    Lr_flujoAprobacion    CO_FLUJO_APROBACION%ROWTYPE := NULL;
    Lv_Clave              VARCHAR2(100) := NULL;
    Lv_DetSolSinFinalizar DB_COMPRAS.INFO_SOLICITUD.ESTADO%TYPE := NULL;
    Le_Error EXCEPTION;
    --
  BEGIN
    --
    FOR Lc_OcPendiente IN C_ORDEN_COMPRA_PENDIENTE LOOP
      --inicializacion de Variables
      Lr_OrdenCompraNaf := NULL;
      Lv_Clave          := 'OC Pedidos: ' || Lc_OcPendiente.ID_ORDEN_COMPRA;
      --
      IF Lc_OcPendiente.ESTADO_ORDEN != 'Procesada' THEN
        Pv_MensajeError := 'Orden de compra no se encuentra en estado PROCESADO, FAVOR VERIFIQUE!!!';
        Raise Le_Error;
      END IF;

      --
      Lr_OrdenCompraNaf.No_Prove     := Lc_OcPendiente.No_Proveedor;
      Lr_OrdenCompraNaf.No_Cia       := Lc_OcPendiente.NO_CIA;
      Lr_OrdenCompraNaf.Estado       := Lc_OcPendiente.ESTADO;
      Lr_OrdenCompraNaf.Ind_No_Inv   := Lc_OcPendiente.IND_NO_INV;
      Lr_OrdenCompraNaf.Fecha        := Lc_OcPendiente.FECHA;
      Lr_OrdenCompraNaf.Dias_Entrega := Lc_OcPendiente.DIAS_ENTREGA;
      Lr_OrdenCompraNaf.Forma_Pago   := Lc_OcPendiente.FORMA_PAGO;
      Lr_OrdenCompraNaf.Termino_Pago := Lc_OcPendiente.TERMINO_PAGO;
      Lr_OrdenCompraNaf.Fecha_Vence := Lc_OcPendiente.FECHA_VENCIMIENTO;
      -- se valida para asignar fecha de vencimiento

      IF Lc_OcPendiente.Dias_Entrega IS NULL THEN
        Lr_OrdenCompraNaf.Fecha_Vence := Lc_OcPendiente.FECHA + 1;
      END IF;

      /*IF Lc_OcPendiente.FORMA_PAGO = 'C' THEN
        IF MOD(Lc_OcPendiente.DIAS_ENTREGA, 30) = 0 THEN
          Lr_OrdenCompraNaf.Fecha_Vence := ADD_MONTHS(Lc_OcPendiente.FECHA,
                                                      (Lc_OcPendiente.DIAS_ENTREGA / 30));
        ELSE
          Lr_OrdenCompraNaf.Fecha_Vence := Lc_OcPendiente.FECHA +
                                           Lc_OcPendiente.DIAS_ENTREGA;
        END IF;
      ELSE
        Lr_OrdenCompraNaf.Fecha_Vence := Lc_OcPendiente.FECHA + 1;
      END IF;*/
      --
      Lr_OrdenCompraNaf.Monto                   := Lc_OcPendiente.MONTO;
      Lr_OrdenCompraNaf.Imp_Ventas              := Lc_OcPendiente.IMP_VENTAS;
      Lr_OrdenCompraNaf.Descuento               := Lc_OcPendiente.DESCUENTO;
      Lr_OrdenCompraNaf.Total                   := Lc_OcPendiente.TOTAL;
      Lr_OrdenCompraNaf.Observ                  := Lc_OcPendiente.OBSERV;
      Lr_OrdenCompraNaf.Adjudicador             := Lc_OcPendiente.ADJUDICADOR;
      Lr_OrdenCompraNaf.Tipo_Cambio             := Lc_OcPendiente.TIPO_CAMBIO;
      Lr_OrdenCompraNaf.Moneda                  := Lc_OcPendiente.MODEDA;
      Lr_OrdenCompraNaf.Usuario                 := Lc_OcPendiente.USUARIO;
      Lr_OrdenCompraNaf.Maneja_Anticipo         := Lc_OcPendiente.MANEJA_ANTICIPO;
      Lr_OrdenCompraNaf.Id_Tipo_Transaccion     := Lc_OcPendiente.ID_TIPO_TRANSACCION;
      Lr_OrdenCompraNaf.Tipo_Distribucion_Costo := Lc_OcPendiente.Tipo_Distribucion_Costo;

      IF Lc_OcPendiente.SECUENCIA IS NULL THEN
        -- se recupera secuencia Orden compra naf
        IF C_SECUENCIA_ORDEN_NAF%ISOPEN THEN
          CLOSE C_SECUENCIA_ORDEN_NAF;
        END IF;
        --
        OPEN C_SECUENCIA_ORDEN_NAF(Lr_OrdenCompraNaf.No_Cia);
        FETCH C_SECUENCIA_ORDEN_NAF
          INTO Lr_OrdenCompraNaf.No_Orden;
        IF C_SECUENCIA_ORDEN_NAF%NOTFOUND THEN
          Lr_OrdenCompraNaf.No_Orden := 0;
        END IF;
        CLOSE C_SECUENCIA_ORDEN_NAF;
        --
        IF Lr_OrdenCompraNaf.No_Orden = 0 THEN
          Pv_MensajeError := 'No se pudo deterninar secuencia de orden de compra para NAF.';
          Raise Le_Error;
        END IF;
        --
        P_INSERTA_CABECERA_ORDEN(Lr_OrdenCompraNaf, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          Raise Le_Error;
        END IF;
        --
      ELSE
        Lr_OrdenCompraNaf.No_Orden := Lc_OcPendiente.SECUENCIA;

        UPDATE NAF47_TNET.TAPORDEE
           SET MONTO      = Lr_OrdenCompraNaf.Monto,
               IMP_VENTAS = Lr_OrdenCompraNaf.Imp_Ventas,
               DESCUENTO  = Lr_OrdenCompraNaf.Descuento,
               TOTAL      = Lr_OrdenCompraNaf.Total
         WHERE NO_ORDEN = Lr_OrdenCompraNaf.No_Orden
           AND NO_CIA = Lr_OrdenCompraNaf.No_Cia;
        --
        -- Se procede a eliminar detalle para reprocesarlo
        DELETE NAF47_TNET.TAPORDED
         WHERE NO_ORDEN = Lc_OcPendiente.SECUENCIA
           AND NO_CIA = Lc_OcPendiente.NO_CIA;
        --
      END IF;
      --
      --
      FOR Lc_DetOrden IN C_DETALLE_ORDEN(Lc_OcPendiente.ID_ORDEN_COMPRA,
                                         Lc_OcPendiente.IND_NO_INV) LOOP
        --
        Lr_DetOrdenCompraNaf := NULL;
        --
        Lr_DetOrdenCompraNaf.No_Cia      := Lr_OrdenCompraNaf.No_Cia;
        Lr_DetOrdenCompraNaf.No_Orden    := Lr_OrdenCompraNaf.No_Orden;
        Lr_DetOrdenCompraNaf.No_Linea    := Lc_DetOrden.NO_LINEA;
        Lr_DetOrdenCompraNaf.Descripcion := Lc_DetOrden.DESCRIPCION;
        Lr_DetOrdenCompraNaf.Cantidad    := Lc_DetOrden.CANTIDAD;
        Lr_DetOrdenCompraNaf.Costo_Uni   := Lc_DetOrden.COSTO_UNI;
        Lr_DetOrdenCompraNaf.Descuento   := Lc_DetOrden.DESCUENTO;
        Lr_DetOrdenCompraNaf.Impuestos   := Lc_DetOrden.IMPUESTO;
        --
        Lr_DetOrdenCompraNaf.Codigo_Ni := Lc_DetOrden.CODIGO_INI;
        Lr_DetOrdenCompraNaf.No_Arti   := Lc_DetOrden.NO_ARTI;
        --
        P_INSERTA_DETALLE_ORDEN(Lr_DetOrdenCompraNaf, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      END LOOP;
      --
      IF Lc_OcPendiente.SECUENCIA IS NULL THEN
        -- se inicializa la variable
        Lr_flujoAprobacion := null;
        --
        Lr_flujoAprobacion.Id_Empresa      := Lr_OrdenCompraNaf.No_Cia;
        Lr_flujoAprobacion.Secuencia       := 1;
        Lr_flujoAprobacion.Secuencia_Flujo := 1;
        Lr_flujoAprobacion.Tipo_Flujo      := 'AU';
        Lr_flujoAprobacion.Id_Orden        := Lr_OrdenCompraNaf.No_Orden;
        Lr_flujoAprobacion.Id_Empleado     := Lc_OcPendiente.Usr_Jefe_Id;
        Lr_flujoAprobacion.Fecha           := SYSDATE;
        Lr_flujoAprobacion.Estado          := 'AU';
        Lr_flujoAprobacion.Usuario_Crea    := Lc_OcPendiente.Usr_Jefe;
        Lr_flujoAprobacion.Fecha_Crea      := sysdate;
        --
        P_INSERTA_FLUJO_APROBACION(Lr_flujoAprobacion, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END IF;
      --
      -- se asigna orden de compra naf en orden de compra pedido
      UPDATE DB_COMPRAS.INFO_ORDEN_COMPRA
         SET SECUENCIA = Lr_OrdenCompraNaf.No_Orden
       WHERE ID_ORDEN_COMPRA = Lc_OcPendiente.ID_ORDEN_COMPRA;
      --
      -- se asigna estado Finalizada a detalle solicitud de Compra
      UPDATE DB_COMPRAS.INFO_SOLICITUD_DETALLE
         SET ESTADO = 'Finalizada'
       WHERE ORDEN_COMPRA_ID = Lc_OcPendiente.ID_ORDEN_COMPRA;
      --
    END LOOP;
    --
    -- Se cerifica si existe aun detalle de solicitudes sin finalizar
    IF C_SOLICITUD_NO_FINALIZADA%ISOPEN THEN
      CLOSE C_SOLICITUD_NO_FINALIZADA;
    END IF;
    OPEN C_SOLICITUD_NO_FINALIZADA;
    FETCH C_SOLICITUD_NO_FINALIZADA
      INTO Lv_DetSolSinFinalizar;
    CLOSE C_SOLICITUD_NO_FINALIZADA;
    --
    -- Si no retorna data entonces todos los detalles se encuentra finalizados
    IF Lv_DetSolSinFinalizar IS NULL THEN
      -- Se procede a cambiar el estado de la solcitud
      UPDATE DB_COMPRAS.INFO_SOLICITUD S
         SET ESTADO = 'Finalizada'
       WHERE EXISTS (SELECT NULL
                FROM DB_COMPRAS.INFO_SOLICITUD_DETALLE ISD
                JOIN DB_COMPRAS.INFO_ORDEN_COMPRA IOC
                  ON IOC.ID_ORDEN_COMPRA = ISD.ORDEN_COMPRA_ID
               WHERE ISD.SOLICITUD_ID = S.ID_SOLICITUD
                 AND IOC.ID_ORDEN_COMPRA = Pn_IdOrdenCompra);

    END IF;

  EXCEPTION
    WHEN LE_ERROR THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'COK_ORDEN_COMPRA_PEDIDO.P_REPLICA_ORDEN',
                                           Pv_MensajeError,
                                           Pv_Login,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en NAF47_TNET.COK_ORDEN_COMPRA_PEDIDO.P_REPLICA_ORDEN. ' ||
                         SQLERRM;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'COK_ORDEN_COMPRA_PEDIDO.P_REPLICA_ORDEN',
                                           Pv_MensajeError,
                                           Pv_Login,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
  END P_REPLICA_ORDEN;

  PROCEDURE P_GENERA_PEDIDO_COMPRA_BIENES(Pn_NoPedido    IN NUMBER,
                                          Pv_NoCia       IN VARCHAR2,
                                          Pn_NoSolicitud IN OUT NUMBER,
                                          Pv_NoTransf    IN VARCHAR2 DEFAULT NULL) IS
    --
    Lv_EstActParametro VARCHAR2(1) := 'A';
    Lv_TipoContieneA   VARCHAR2(2) := 'CA';
    Lv_TipoContenidoEn VARCHAR2(2) := 'CE';
    Lv_ClaseBodegaReg  VARCHAR2(2) := 'BR';
    Lv_EstPendienteInv VARCHAR2(1) := 'P';
    Lv_EstNoImpreso    VARCHAR2(1) := 'N';
    Lv_AplicaionNAF    VARCHAR2(2) := 'IN';
    Lv_TipoSolicitud   VARCHAR2(3) := 'Bie';
    Lv_ArtRecurrente   VARCHAR2(1) := 'S';
    Lv_EstadoSolCompra VARCHAR2(30) := 'EST_SOL_COMPRA_BIE';
    Lv_EstadoOrdCompra VARCHAR2(30) := 'EST_ORD_COMPRA_BIE';
    --

    -- Cursor que recupera los articulos que tiene stock minimo y no se encuentran en solicitud
    CURSOR C_PRODUCTOS_X_COMPRAR IS
      SELECT BA.BODEGA,
             BA.NO_CIA EMPRESA_ID,
             B.CENTRO CENTRO_ID,
             BA.NO_ARTI PRODUCTO_ID,
             A.DESCRIPCION DESC_ARTICULO,
             DECODE(A.APLICA_IMPUESTO, 'G', 'S', 'N') APLICA_IMPUESTO,
             NVL(A.COSTO_UNITARIO, 0) COSTO_UNITARIO,
             NVL(BA.SAL_ANT_UN, 0) + NVL(BA.COMP_UN, 0) +
             NVL(BA.OTRS_UN, 0) - NVL(BA.VENT_UN, 0) - NVL(BA.CONS_UN, 0) AS STOCK,
             (SELECT MAX(DP.PEDIDO_ID)
                FROM DB_COMPRAS.INFO_PEDIDO_DETALLE DP
                JOIN DB_COMPRAS.ADMI_EMPRESA E
                  ON E.ID_EMPRESA = DP.PRODUCTO_EMPRESA_ID
               WHERE E.CODIGO = BA.NO_CIA
                 AND DP.PRODUCTO_ID = BA.NO_ARTI) AS PEDIDO_ID

        FROM ARINMA BA, ARINDA A, ARINBO B
       WHERE BA.NO_ARTI = A.NO_ARTI
         AND BA.NO_CIA = A.NO_CIA
         AND BA.BODEGA = B.CODIGO
         AND BA.NO_CIA = B.NO_CIA
         AND A.ES_RECURRENTE = Lv_ArtRecurrente
         AND BA.NO_CIA = Pv_NoCia
         AND EXISTS (SELECT NULL -- valida que la bodega este configurada como recurrente
                FROM ARIN_PARAMETRO_DETALLE BR
                JOIN ARIN_PARAMETRO P
                  ON BR.PARAMETRO_ID = P.ID_PARAMETRO
               WHERE BR.OBJETO_ID = B.CODIGO
                 AND BR.EMPRESA_OBJETO_ID = B.NO_CIA
                 AND BR.TIPO = Lv_TipoContieneA
                 AND BR.ESTADO = Lv_EstActParametro
                 AND P.CLASE = Lv_ClaseBodegaReg
                 AND P.ESTADO = Lv_EstActParametro)
         AND EXISTS
       (SELECT NULL
                FROM ARINML ML -- valida transaccion es despacho de pedido
                JOIN ARINME ME
                  ON ME.NO_DOCU = ML.NO_DOCU
                 AND ME.NO_CIA = ML.NO_CIA
               WHERE ML.NO_ARTI = BA.NO_ARTI
                 AND ML.BODEGA = BA.BODEGA
                 AND ML.NO_CIA = BA.NO_CIA
                 AND ME.NO_PEDIDO = Pn_NoPedido
                 AND ME.ESTADO != Lv_EstPendienteInv
                 AND NVL(ME.IND_PEDIDO_IMPRESO, 'N') = Lv_EstNoImpreso
              UNION
              SELECT NULL
                FROM ARINML ML -- valida que transaccion es transferencia interbodega
                JOIN ARINME ME
                  ON ME.NO_DOCU = ML.NO_DOCU
                 AND ME.NO_CIA = ML.NO_CIA
               WHERE ML.NO_ARTI = BA.NO_ARTI
                 AND ML.BODEGA = BA.BODEGA
                 AND ML.NO_CIA = BA.NO_CIA
                 AND ME.NO_DOCU = Pv_NoTransf
                 AND ME.ESTADO != Lv_EstPendienteInv
                 AND NVL(ME.IND_PEDIDO_IMPRESO, 'N') = Lv_EstNoImpreso)
         AND NOT EXISTS
       (SELECT NULL -- que no existan detalle solicitud pendiente
                FROM DB_COMPRAS.INFO_SOLICITUD S
                JOIN DB_COMPRAS.INFO_SOLICITUD_DETALLE DS
                  ON DS.SOLICITUD_ID = S.ID_SOLICITUD
                JOIN DB_COMPRAS.ADMI_EMPRESA E
                  ON E.ID_EMPRESA = S.EMPRESA_ID
               WHERE DS.CODIGO = BA.NO_ARTI
                 AND E.CODIGO = BA.NO_CIA
                 AND S.TIPO = Lv_TipoSolicitud
                 AND EXISTS
               (SELECT NULL
                        FROM GE_PARAMETROS PR
                        JOIN GE_GRUPOS_PARAMETROS GP
                          ON GP.ID_GRUPO_PARAMETRO = PR.ID_GRUPO_PARAMETRO
                         AND GP.ID_APLICACION = PR.ID_APLICACION
                         AND GP.ID_EMPRESA = PR.ID_EMPRESA
                       WHERE PR.DESCRIPCION = DS.ESTADO
                         AND PR.ID_APLICACION = Lv_AplicaionNAF
                         AND PR.ID_GRUPO_PARAMETRO = Lv_EstadoSolCompra
                         AND PR.ESTADO = Lv_EstActParametro
                         AND GP.ESTADO = Lv_EstActParametro))
         AND NOT EXISTS
       (SELECT NULL -- que no existan ordenes de compras pendiente
                FROM DB_COMPRAS.INFO_SOLICITUD S
                JOIN DB_COMPRAS.INFO_SOLICITUD_DETALLE DS
                  ON DS.SOLICITUD_ID = S.ID_SOLICITUD
                JOIN DB_COMPRAS.INFO_ORDEN_COMPRA IOC
                  ON IOC.ID_ORDEN_COMPRA = DS.ORDEN_COMPRA_ID
                JOIN DB_COMPRAS.ADMI_EMPRESA E
                  ON E.ID_EMPRESA = IOC.EMPRESA_ID
               WHERE DS.CODIGO = BA.NO_ARTI
                 AND E.CODIGO = BA.NO_CIA
                 AND S.TIPO = Lv_TipoSolicitud
                 AND EXISTS
               (SELECT NULL
                        FROM GE_PARAMETROS PR
                        JOIN GE_GRUPOS_PARAMETROS GP
                          ON GP.ID_GRUPO_PARAMETRO = PR.ID_GRUPO_PARAMETRO
                         AND GP.ID_APLICACION = PR.ID_APLICACION
                         AND GP.ID_EMPRESA = PR.ID_EMPRESA
                       WHERE PR.DESCRIPCION = IOC.ESTADO
                         AND PR.ID_APLICACION = Lv_AplicaionNAF
                         AND PR.ID_GRUPO_PARAMETRO = Lv_EstadoOrdCompra
                         AND PR.ESTADO = Lv_EstActParametro
                         AND GP.ESTADO = Lv_EstActParametro))
       ORDER BY PEDIDO_ID ASC;
    --
    CURSOR C_DETALLE_PEDIDO(Cv_ProductoId VARCHAR2,
                            Cn_PedidoId   NUMBER,
                            Cv_EmpleadoId VARCHAR2,
                            Cv_EmpresaId  VARCHAR2) IS
      SELECT DP.ID_PEDIDO_DETALLE
        FROM DB_COMPRAS.INFO_PEDIDO_DETALLE DP,
             DB_COMPRAS.INFO_PEDIDO         P,
             DB_COMPRAS.ADMI_DEPARTAMENTO   D,
             DB_COMPRAS.ADMI_EMPRESA        E
       WHERE DP.PEDIDO_ID = P.ID_PEDIDO
         AND P.DEPARTAMENTO_ID = D.ID_DEPARTAMENTO
         AND D.EMPRESA_ID = E.ID_EMPRESA
         AND DP.PRODUCTO_ID = Cv_ProductoId
         AND DP.PEDIDO_ID = Cn_PedidoId
         AND DP.USR_ASIGNADO_ID = Cv_EmpleadoId
         AND E.CODIGO = Cv_EmpresaId
      UNION
      -- cuando es trasnferencia no se valida el empleado porque el pedido de compra lo tramita el bodeguero
      SELECT DP.ID_PEDIDO_DETALLE
        FROM DB_COMPRAS.INFO_PEDIDO_DETALLE DP
        JOIN DB_COMPRAS.INFO_PEDIDO P
          ON P.ID_PEDIDO = DP.PEDIDO_ID
        JOIN DB_COMPRAS.ADMI_DEPARTAMENTO D
          ON D.ID_DEPARTAMENTO = P.DEPARTAMENTO_ID
        JOIN DB_COMPRAS.ADMI_EMPRESA E
          ON E.ID_EMPRESA = D.EMPRESA_ID
       WHERE DP.PRODUCTO_ID = Cv_ProductoId
         AND DP.PEDIDO_ID = Cn_PedidoId
         AND E.CODIGO = Cv_EmpresaId
         AND Pv_NoTransf IS NOT NULL;
    --
    CURSOR C_PARAMETROS_RECURRENTES(Cv_ProductoId VARCHAR2,
                                    Cv_IdBodega   VARCHAR2,
                                    Cv_EmpresaId  VARCHAR2) IS
      SELECT PR.CANTIDAD_MINIMA, PR.CANTIDAD_MAXIMA
        FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE PR,
             NAF47_TNET.ARIN_PARAMETRO_DETALLE   R,
             NAF47_TNET.ARIN_PARAMETRO           P,
             NAF47_TNET.ARIN_PARAMETRO_DETALLE   BR
       WHERE PR.ID_REGION = R.OBJETO_ID
         AND R.PARAMETRO_ID = P.ID_PARAMETRO
         AND P.ID_PARAMETRO = BR.PARAMETRO_ID
         AND BR.EMPRESA_OBJETO_ID = PR.ID_EMPRESA_ARTICULO
         AND P.EMPRESA_ID = PR.ID_EMPRESA_ARTICULO
         AND PR.ID_ARTICULO = Cv_ProductoId
         AND PR.ID_EMPRESA_ARTICULO = Cv_EmpresaId
         AND BR.OBJETO_ID = Cv_IdBodega
         AND BR.TIPO = Lv_TipoContieneA
         AND BR.ESTADO = Lv_EstActParametro
         AND P.ESTADO = Lv_EstActParametro
         AND P.CLASE = Lv_ClaseBodegaReg
         AND R.ESTADO = Lv_EstActParametro
         AND R.TIPO = Lv_TipoContenidoEn;
    --
    CURSOR C_DATOS_EMPLEADO IS
      SELECT DISTINCT ME.EMPLE_SOLIC EMPLEADO_ASIGNADO_ID,
                      EN.LOGIN_EMPLE USUARIO,
                      EC.ID_EMPRESA,
                      DC.ID_DEPARTAMENTO,
                      DC.AREA_ID,
                      EN.IND_REGION REGION,
                      'Bie' TIPO_SOLICITUD,
                      'Pendiente' ESTADO
        FROM ARINML ML
        JOIN ARINME ME
          ON ME.NO_DOCU = ML.NO_DOCU
         AND ME.NO_CIA = ML.NO_CIA
        JOIN V_EMPLEADOS_EMPRESAS EN
          ON EN.NO_EMPLE = ME.EMPLE_SOLIC
         AND EN.NO_CIA = ME.NO_CIA_RESPONSABLE
        JOIN DB_COMPRAS.ADMI_EMPRESA EC
          ON EC.CODIGO = EN.NO_CIA
        JOIN DB_COMPRAS.ADMI_DEPARTAMENTO DC
          ON DC.EMPRESA_ID = EC.ID_EMPRESA
         AND DC.DPTO_COD = EN.DEPTO
       WHERE ME.NO_PEDIDO = Pn_NoPedido
         AND ME.NO_CIA = Pv_NoCia
         AND NVL(ME.IND_PEDIDO_IMPRESO, 'N') = Lv_EstNoImpreso
         AND ME.ESTADO != Lv_EstPendienteInv
      UNION
      SELECT EN.NO_EMPLE AS EMPLEADO_ASIGNADO_ID,
             EN.LOGIN_EMPLE AS USUARIO,
             EC.ID_EMPRESA,
             DC.ID_DEPARTAMENTO,
             DC.AREA_ID,
             EN.IND_REGION AS REGION,
             'Bie' AS TIPO_SOLICITUD,
             'Pendiente' AS ESTADO
        FROM V_EMPLEADOS_EMPRESAS EN
        JOIN DB_COMPRAS.ADMI_EMPRESA EC
          ON EC.CODIGO = EN.NO_CIA
        JOIN DB_COMPRAS.ADMI_DEPARTAMENTO DC
          ON DC.EMPRESA_ID = EC.ID_EMPRESA
         AND DC.DPTO_COD = EN.DEPTO
       --WHERE EN.LOGIN_EMPLE = GEK_CONSULTA.F_RECUPERA_LOGIN   emunoz 11012023
       WHERE LOWER(EN.LOGIN_EMPLE) = LOWER(USER) --emunoz 11012023
         AND Pv_NoTransf IS NOT NULL;
    --
    CURSOR C_PARAMETRO(Cv_IdGrupoParam VARCHAR2) IS
      SELECT COUNT(*)
        FROM GE_PARAMETROS PR, GE_GRUPOS_PARAMETROS GP
       WHERE PR.ID_GRUPO_PARAMETRO = GP.ID_GRUPO_PARAMETRO
         AND PR.ID_APLICACION = GP.ID_APLICACION
         AND PR.ID_EMPRESA = GP.ID_EMPRESA
         AND PR.ID_APLICACION = Lv_AplicaionNAF
         AND PR.ID_GRUPO_PARAMETRO = Cv_IdGrupoParam
         AND PR.ESTADO = Lv_EstActParametro
         AND GP.ESTADO = Lv_EstActParametro;
    --
    Lr_InfoSolicitud    DB_COMPRAS.INFO_SOLICITUD%ROWTYPE := NULL;
    Lr_InfoSolicitudDet DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE := NULL;
    Lr_ParamRecurrente  C_PARAMETROS_RECURRENTES%ROWTYPE := NULL;
    Lv_NoSolicitante    ARPLME.NO_EMPLE%TYPE := NULL;
    Lv_MensajeError     VARCHAR2(32676) := NULL;
    --Lv_PedidoGenerado   VARCHAR2(1) := 'N';
    Ln_ExisteParametro NUMBER(2) := 0;
    Ln_AuxPedidoId     DB_COMPRAS.INFO_PEDIDO_DETALLE.PEDIDO_ID%TYPE := 1.1;
    Ln_TotalSolicitud  NUMBER(17, 2) := 0;
    Le_Error EXCEPTION;
  BEGIN

    -- se define punto de commit/rollback para hecerlo independiente del procedure que lo llame.
    SAVEPOINT SOLICITUD_COMPRA;

    -- se valida que se encuentren configurados los estados a de las solicitudes de pedidos de compras
    IF C_PARAMETRO%ISOPEN THEN
      CLOSE C_PARAMETRO;
    END IF;
    --
    OPEN C_PARAMETRO(Lv_EstadoSolCompra);
    FETCH C_PARAMETRO
      INTO Ln_ExisteParametro;
    IF C_PARAMETRO%NOTFOUND THEN
      Ln_ExisteParametro := 0;
    END IF;
    CLOSE C_PARAMETRO;
    --
    IF NVL(Ln_ExisteParametro, 0) = 0 THEN
      Lv_MensajeError := 'No se ha parametrizado los estado de solicitudes de pedidos en NAF: ' ||
                         Lv_EstadoSolCompra;
      RAISE Le_Error;
    END IF;
    --
    -- se valida que se encuentren configurados de los estados de ordenes de compras
    IF C_PARAMETRO%ISOPEN THEN
      CLOSE C_PARAMETRO;
    END IF;
    --
    OPEN C_PARAMETRO(Lv_EstadoOrdCompra);
    FETCH C_PARAMETRO
      INTO Ln_ExisteParametro;
    IF C_PARAMETRO%NOTFOUND THEN
      Ln_ExisteParametro := 0;
    END IF;
    CLOSE C_PARAMETRO;
    --
    IF NVL(Ln_ExisteParametro, 0) = 0 THEN
      Lv_MensajeError := 'No se ha parametrizado los estado de Ordenes de Compras en NAF: ' ||
                         Lv_EstadoOrdCompra;
      RAISE Le_Error;
    END IF;
    --
    -- se lee cursor que recupera los productos despachados para validar el stock
    FOR Lc_Articulo IN C_PRODUCTOS_X_COMPRAR LOOP
      --
      -- se recuperan los valores minimos y maximos del articulo recurrente
      IF C_PARAMETROS_RECURRENTES%ISOPEN THEN
        CLOSE C_PARAMETROS_RECURRENTES;
      END IF;
      --
      OPEN C_PARAMETROS_RECURRENTES(Lc_Articulo.Producto_id,
                                    Lc_Articulo.Bodega,
                                    Lc_Articulo.Empresa_Id);
      FETCH C_PARAMETROS_RECURRENTES
        INTO Lr_ParamRecurrente;
      IF C_PARAMETROS_RECURRENTES%NOTFOUND THEN
        Lr_ParamRecurrente := NULL;
      END IF;
      CLOSE C_PARAMETROS_RECURRENTES;
      --
      -- no tiene configurados parametros recurrentes se presenta error
      IF NVL(Lr_ParamRecurrente.Cantidad_Minima, 0) = 0 THEN
        Lv_MensajeError := 'Articulo marcado como Recurrente no tiene asignados unidades minimas o maximas: ' ||
                           Lc_Articulo.Producto_id;
        RAISE Le_Error;
        -- se verifica si stock llega a minimo
      ELSIF Lr_ParamRecurrente.Cantidad_Minima > NVL(Lc_Articulo.Stock, 0) THEN
        --
        -- si no se ha generado pedido se procede a generar.
        IF Ln_AuxPedidoId != NVL(Lc_Articulo.Pedido_Id, 0) THEN
          --
          IF C_DATOS_EMPLEADO%ISOPEN THEN
            CLOSE C_DATOS_EMPLEADO;
          END IF;
          --
          -- se recuperan los datos del bodeguero que es quien generara la solicitud de compra
          OPEN C_DATOS_EMPLEADO;
          FETCH C_DATOS_EMPLEADO
            INTO Lv_NoSolicitante,
                 Lr_InfoSolicitud.Usr_Creacion,
                 Lr_InfoSolicitud.Empresa_Id,
                 Lr_InfoSolicitud.Departamento_Id,
                 Lr_InfoSolicitud.Area_Id,
                 Lr_InfoSolicitud.Region,
                 Lr_InfoSolicitud.Tipo,
                 Lr_InfoSolicitud.Estado;
          IF C_DATOS_EMPLEADO%NOTFOUND THEN
            Lr_InfoSolicitud := NULL;
          END IF;
          CLOSE C_DATOS_EMPLEADO;
          --
          IF Lr_InfoSolicitud.Usr_Creacion IS NULL THEN
            Lv_MensajeError := 'Usuario no se encuentra registrado en sistema TELCOS ' || user;
            RAISE Le_Error;
          END IF;
          --
          -- Se asignan valores a los otros campos
          Lr_InfoSolicitud.Valor_Total              := 0;
          Lr_InfoSolicitud.Total_Descuento          := 0;
          Lr_InfoSolicitud.Total_Iva                := 0;
          Lr_InfoSolicitud.Subtotal                 := 0;
          Lr_InfoSolicitud.Pedido_Id                := NVL(Pn_NoPedido,
                                                           Lc_Articulo.Pedido_Id);
          Lr_InfoSolicitud.Fe_Creacion              := SYSDATE;
          Lr_InfoSolicitud.Ip_Creacion              := GEK_CONSULTA.F_RECUPERA_IP;
          Lr_InfoSolicitud.Proceso_Solicitud_Compra := 'R';
          Lr_InfoSolicitud.Id_Solicitud             := DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_SOLICITUD;
          --
          -- se inserta cabecera de solicitud
          P_INSERTA_INFO_SOLICITUD(Lr_InfoSolicitud, Lv_MensajeError);
          --
          IF Lv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
          --
          --Lv_PedidoGenerado := 'S';
          Ln_AuxPedidoId := NVL(Lc_Articulo.Pedido_Id, 0);
          --
        END IF;
        --
        -- Se prcoede a llenar el registro de detalle
        Lr_InfoSolicitudDet.Codigo                 := Lc_Articulo.Producto_id;
        Lr_InfoSolicitudDet.Descripcion            := Lc_Articulo.Desc_Articulo;
        Lr_InfoSolicitudDet.Cantidad               := Lr_ParamRecurrente.Cantidad_Maxima;
        Lr_InfoSolicitudDet.Estado                 := Lr_InfoSolicitud.Estado;
        Lr_InfoSolicitudDet.Solicitud_Id           := Lr_InfoSolicitud.Id_Solicitud;
        Lr_InfoSolicitudDet.Usr_Creacion           := Lr_InfoSolicitud.Usr_Creacion;
        Lr_InfoSolicitudDet.Fe_Creacion            := SYSDATE;
        Lr_InfoSolicitudDet.Ip_Creacion            := Lr_InfoSolicitud.Ip_Creacion;
        Lr_InfoSolicitudDet.Codigo_Genera_Impuesto := Lc_Articulo.Aplica_Impuesto;
        --
        --se recupera detalle de pedido
        IF C_DETALLE_PEDIDO%ISOPEN THEN
          CLOSE C_DETALLE_PEDIDO;
        END IF;
        --
        OPEN C_DETALLE_PEDIDO(Lc_Articulo.Producto_Id,
                              NVL(Pn_NoPedido, Lc_Articulo.Pedido_Id),
                              Lv_NoSolicitante,
                              Lc_Articulo.Empresa_Id);
        FETCH C_DETALLE_PEDIDO
          INTO Lr_InfoSolicitudDet.Pedido_Detalle_Id;
        IF C_DETALLE_PEDIDO%NOTFOUND THEN
          Lr_InfoSolicitudDet.Pedido_Detalle_Id := NULL;
        END IF;
        CLOSE C_DETALLE_PEDIDO;
        --
        Lr_InfoSolicitudDet.Valor := Lc_Articulo.COSTO_UNITARIO;
        Ln_TotalSolicitud         := Ln_TotalSolicitud +
                                     Lc_Articulo.COSTO_UNITARIO;
        --
        Lr_InfoSolicitudDet.Subtotal             := 0;
        Lr_InfoSolicitudDet.Porcentaje_Descuento := 0;
        Lr_InfoSolicitudDet.Valor_Descuento      := 0;
        Lr_InfoSolicitudDet.Iva                  := 0;
        Lr_InfoSolicitudDet.Valor_Iva            := 0;
        Lr_InfoSolicitudDet.Total                := 0;
        --
        Lr_InfoSolicitudDet.Fe_Ult_Mod  := SYSDATE;
        Lr_InfoSolicitudDet.Usr_Ult_Mod := Lr_InfoSolicitud.Usr_Creacion;
        --
        Lr_InfoSolicitudDet.Id_Solicitud_Detalle := DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_SOLICITUD_DETALLE;
        -- se inserta cabecera de solicitud
        P_INSERTA_INFO_SOLICITUD_DET(Lr_InfoSolicitudDet, Lv_MensajeError);
        --
        IF Lv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      END IF;
    END LOOP;
    --
    -- si genero solicitud de compra se debe actualizar total pedido
    IF Lr_InfoSolicitud.Id_Solicitud IS NOT NULL THEN
      --
      UPDATE DB_COMPRAS.INFO_SOLICITUD
         SET VALOR_TOTAL = Ln_TotalSolicitud
       WHERE ID_SOLICITUD = Lr_InfoSolicitud.Id_Solicitud;
      --
    END IF;
    --
    -- se asigna numero de solicitud para prsentar alerta en despacho.
    Pn_NoSolicitud := Lr_InfoSolicitud.Id_Solicitud;
    --
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK TO SOLICITUD_COMPRA;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'COK_ORDEN_COMPRA_PEDIDO.P_GENERA_PEDIDO_COMPRA_BIENES',
                                           Lv_MensajeError,
                                           --GEK_CONSULTA.F_RECUPERA_LOGIN,  emunoz 1101203
                                           LOWER(USER),                             --emunoz 1101203
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);

    WHEN OTHERS THEN
      Lv_MensajeError := SQLERRM;
      ROLLBACK TO SOLICITUD_COMPRA;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR('NAF',
                                            'COK_ORDEN_COMPRA_PEDIDO.P_GENERA_PEDIDO_COMPRA_BIENES',
                                            Lv_MensajeError,
                                            --GEK_CONSULTA.F_RECUPERA_LOGIN,  emunoz 11012023
                                            LOWER(USER),                             --emunoz 1101203
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP);
  END P_GENERA_PEDIDO_COMPRA_BIENES;

  PROCEDURE P_ACTUALIZA_VALORES_PEDIDO(Pv_NoOrden      IN VARCHAR2,
                                       Pv_NoCia        IN VARCHAR2,
                                       Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CON_ORDEN_COMPRA    CONSTANT VARCHAR2(14) := 'ConOrdenCompra';
    AUTORIZADO          CONSTANT VARCHAR2(10) := 'Autorizado';
    ACTIVO              CONSTANT VARCHAR2(06) := 'Activo';
    EMPLEADOS           CONSTANT VARCHAR2(09) := 'EMPLEADOS';
    CONTROL_PRESUPUESTO CONSTANT VARCHAR2(19) := 'CONTROL_PRESUPUESTO';
    --
    CURSOR C_ORDEN_COMPRA IS
      SELECT IPD.*,
             OCD.NO_LINEA,
             OCD.CANTIDAD CANTIDAD_OC,
             OCD.COSTO_UNI,
             OC.PEDIDO_DETALLE_ID,
             (OCD.CANTIDAD * OCD.COSTO_UNI) AS MONTO_OC,
             ((OCD.CANTIDAD * OCD.COSTO_UNI) * (OCD.DESCUENTO / 100)) DESCUENTO_OC,
             ((OCD.CANTIDAD * OCD.COSTO_UNI) -
             ((OCD.CANTIDAD * OCD.COSTO_UNI) * (OCD.DESCUENTO / 100))) AS SUBTOTAL_OC,
             NVL(OCD.IMPUESTOS, 0) IMPUESTOS_OC,
             (((OCD.CANTIDAD * OCD.COSTO_UNI) -
             ((OCD.CANTIDAD * OCD.COSTO_UNI) * (OCD.DESCUENTO / 100))) +
             NVL(OCD.IMPUESTOS, 0)) AS TOTAL_OC
        FROM DB_COMPRAS.INFO_PEDIDO_DETALLE IPD,
             NAF47_TNET.TAPORDEE            OC,
             NAF47_TNET.TAPORDED            OCD
       WHERE OC.NO_ORDEN = Pv_NoOrden
         AND OC.NO_CIA = Pv_NoCia
         AND OC.PEDIDO_DETALLE_ID = IPD.ID_PEDIDO_DETALLE
         AND OCD.NO_ORDEN = OC.NO_ORDEN
         AND OCD.NO_CIA = OC.NO_CIA
       ORDER BY IPD.PEDIDO_ID DESC;
    --
    CURSOR C_DATOS_PEDIDO(Cn_PedidoId NUMBER) IS
      SELECT P.USR_AUTORIZA_ID, P.USR_AUTORIZA
        FROM DB_COMPRAS.INFO_PEDIDO P
       WHERE ID_PEDIDO = Cn_PedidoId;
    --
    CURSOR C_DETALLE_ORDEN IS
      SELECT E.CODIGO AS NO_CIA,
             IPD.USR_ASIGNADO_ID REFERENCIA_ID,
             (SELECT ME.NOMBRE
                FROM NAF47_TNET.ARPLME ME
               WHERE ME.NO_CIA = E.CODIGO
                 AND ME.NO_EMPLE = IPD.USR_ASIGNADO_ID) AS REFERENCIA_DESCRIPCION,
             'OrdenCompra' AS ORIGEN,
             (SELECT APD.ID_PARAMETRO_DET
                FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
               WHERE APD.VALOR2 = EMPLEADOS
                 AND APD.ESTADO = ACTIVO
                 AND EXISTS
               (SELECT NULL
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                       WHERE APC.NOMBRE_PARAMETRO = CONTROL_PRESUPUESTO
                         AND APC.ID_PARAMETRO = APD.PARAMETRO_ID)) AS TIPO_CCOSTO_ID,
             SUM((OCD.CANTIDAD * OCD.COSTO_UNI) - NVL(OCD.DESCUENTO, 0)) AS MONTO

        FROM DB_COMPRAS.ADMI_EMPRESA        E,
             DB_COMPRAS.ADMI_DEPARTAMENTO   D,
             DB_COMPRAS.INFO_PEDIDO         P,
             DB_COMPRAS.INFO_PEDIDO_DETALLE IPD,
             NAF47_TNET.TAPORDED            OCD
       WHERE OCD.NO_ORDEN = Pv_NoOrden
         AND OCD.NO_CIA = Pv_NoCia
         AND D.EMPRESA_ID = E.ID_EMPRESA
         AND P.DEPARTAMENTO_ID = D.ID_DEPARTAMENTO
         AND IPD.PEDIDO_ID = P.ID_PEDIDO
         AND OCD.ID_PEDIDO_DETALLE = IPD.ID_PEDIDO_DETALLE
       GROUP BY E.CODIGO, IPD.USR_ASIGNADO_ID;
    --
    CURSOR C_SEC_DOCUMENTO_DISTRIB IS
      SELECT MAX(TO_NUMBER(NVL(OC.ID_DOCUMENTO_DISTRIBUCION, '0')))
        FROM NAF47_TNET.TAPORDEE OC
       WHERE OC.NO_CIA = Pv_NoCia;

    --
    Lr_flujoAprobacion NAF47_TNET.CO_FLUJO_APROBACION%ROWTYPE;
    Lr_DatosPedido     C_DATOS_PEDIDO%ROWTYPE;
    Lr_DocDistribucion NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION%ROWTYPE;
    --
    Ln_Registros NUMBER(3) := 0;
    Ln_PedidoId  NUMBER(12);
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    --

    COK_ORDEN_COMPRA_PEDIDO.P_ACTUALIZA_VALORES_PEDIDO@GPOETNET (Pv_NoOrden,
                                                                 Pv_NoCia,
                                                                 Pv_MensajeError);

    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;


    /*
    FOR Lr_OrdenCompra IN C_ORDEN_COMPRA LOOP
      --
      Ln_PedidoId  := Lr_OrdenCompra.Pedido_Id;
      Ln_Registros := Ln_Registros + 1;
      --
      --
      IF Ln_Registros = 1 THEN
        --
        Lr_OrdenCompra.Id_Pedido_Detalle := Lr_OrdenCompra.Pedido_Detalle_Id;
        --
        UPDATE DB_COMPRAS.INFO_PEDIDO
           SET VALOR_TOTAL      = VALOR_TOTAL - Lr_OrdenCompra.Subtotal,
               VALOR_DESCONTADO = VALOR_DESCONTADO - Lr_OrdenCompra.Subtotal,
               SALDO_APROBACION = SALDO_APROBACION + Lr_OrdenCompra.Subtotal
         WHERE ID_PEDIDO = Lr_OrdenCompra.PEDIDO_ID;
        --
        UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE IPD
           SET IPD.CANTIDAD_SOLICITADA = Lr_OrdenCompra.Cantidad_Oc,
               IPD.CANTIDAD            = Lr_OrdenCompra.Cantidad_Oc,
               IPD.CANTIDAD_DESPACHADA = Lr_OrdenCompra.Cantidad_Oc,
               IPD.COSTO_PRODUCTO      = Lr_OrdenCompra.Costo_Uni,
               IPD.SUBTOTAL            = Lr_OrdenCompra.Total_Oc
         WHERE IPD.ID_PEDIDO_DETALLE = Lr_OrdenCompra.Id_Pedido_Detalle;
        --
        UPDATE DB_COMPRAS.INFO_PEDIDO
           SET VALOR_TOTAL      = VALOR_TOTAL + Lr_OrdenCompra.Total_Oc,
               VALOR_DESCONTADO = VALOR_DESCONTADO + Lr_OrdenCompra.Total_Oc,
               SALDO_APROBACION = SALDO_APROBACION - Lr_OrdenCompra.Total_Oc
         WHERE ID_PEDIDO = Lr_OrdenCompra.PEDIDO_ID;
        --
      ELSE
        --
        Lr_OrdenCompra.Id_Pedido_Detalle := DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_PEDIDO_DETALLE;
        --
        insert into DB_COMPRAS.INFO_PEDIDO_DETALLE
          (id_pedido_detalle,
           cantidad_solicitada,
           descripcion_solicitada,
           usr_asignado_id,
           usr_asignado,
           caracteristica_id,
           producto_empresa_id,
           producto_id,
           descripcion,
           cantidad,
           costo_producto,
           subtotal,
           producto_empresa_id_reasignado,
           es_compra,
           fe_creacion,
           estado,
           cantidad_despachada,
           fe_ult_mod,
           usr_creacion,
           usr_ult_mod,
           ip_creacion,
           pedido_id,
           pedido_uso_id,
           servicio_id,
           genera_impuesto,
           devolucion,
           cantidad_a_devolver,
           cantidad_devuelta,
           lugar_destino,
           es_consumible,
           pais_origen,
           pais_destino,
           provincia_destino_id,
           nombre_provincia_destino,
           nombre_canton_origen,
           canton_destino_id,
           nombre_canton_destino,
           fecha_salida,
           fecha_retorno,
           canton_origen_id,
           canton_gestion_id)
        values
          (Lr_OrdenCompra.Id_Pedido_Detalle,
           Lr_OrdenCompra.Cantidad_Oc,
           Lr_OrdenCompra.descripcion_solicitada,
           Lr_OrdenCompra.usr_asignado_id,
           Lr_OrdenCompra.usr_asignado,
           Lr_OrdenCompra.caracteristica_id,
           Lr_OrdenCompra.producto_empresa_id,
           Lr_OrdenCompra.producto_id,
           Lr_OrdenCompra.descripcion,
           Lr_OrdenCompra.Cantidad_Oc,
           0,
           0,
           Lr_OrdenCompra.producto_empresa_id_reasignado,
           Lr_OrdenCompra.es_compra,
           Lr_OrdenCompra.fe_creacion,
           Lr_OrdenCompra.estado,
           Lr_OrdenCompra.cantidad_despachada,
           Lr_OrdenCompra.fe_ult_mod,
           Lr_OrdenCompra.usr_creacion,
           Lr_OrdenCompra.usr_ult_mod,
           Lr_OrdenCompra.ip_creacion,
           Lr_OrdenCompra.pedido_id,
           Lr_OrdenCompra.pedido_uso_id,
           Lr_OrdenCompra.servicio_id,
           Lr_OrdenCompra.genera_impuesto,
           Lr_OrdenCompra.devolucion,
           Lr_OrdenCompra.cantidad_a_devolver,
           Lr_OrdenCompra.cantidad_devuelta,
           Lr_OrdenCompra.lugar_destino,
           Lr_OrdenCompra.es_consumible,
           Lr_OrdenCompra.pais_origen,
           Lr_OrdenCompra.pais_destino,
           Lr_OrdenCompra.provincia_destino_id,
           Lr_OrdenCompra.nombre_provincia_destino,
           Lr_OrdenCompra.nombre_canton_origen,
           Lr_OrdenCompra.canton_destino_id,
           Lr_OrdenCompra.nombre_canton_destino,
           Lr_OrdenCompra.fecha_salida,
           Lr_OrdenCompra.fecha_retorno,
           Lr_OrdenCompra.canton_origen_id,
           Lr_OrdenCompra.canton_gestion_id);
        --
        -- triger asignara valores en base a la configuracion, se debe actualizar a los valores que se registra en la OC
        UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE IPD
           SET IPD.CANTIDAD_SOLICITADA = Lr_OrdenCompra.Cantidad_Oc,
               IPD.CANTIDAD            = Lr_OrdenCompra.Cantidad_Oc,
               IPD.CANTIDAD_DESPACHADA = Lr_OrdenCompra.Cantidad_Oc,
               IPD.COSTO_PRODUCTO      = Lr_OrdenCompra.Costo_Uni,
               IPD.SUBTOTAL            = Lr_OrdenCompra.Total_Oc
         WHERE IPD.ID_PEDIDO_DETALLE = Lr_OrdenCompra.Id_Pedido_Detalle;
        --
        UPDATE DB_COMPRAS.INFO_PEDIDO
           SET VALOR_TOTAL      = VALOR_TOTAL + Lr_OrdenCompra.Total_Oc,
               VALOR_DESCONTADO = VALOR_DESCONTADO + Lr_OrdenCompra.Total_Oc,
               SALDO_APROBACION = SALDO_APROBACION - Lr_OrdenCompra.Total_Oc
         WHERE ID_PEDIDO = Lr_OrdenCompra.PEDIDO_ID;
        --
      END IF;
      --
      UPDATE NAF47_TNET.TAPORDED a
         SET A.ID_PEDIDO_DETALLE = Lr_OrdenCompra.Id_Pedido_Detalle
       WHERE A.NO_LINEA = Lr_OrdenCompra.No_Linea
         AND A.NO_ORDEN = Pv_NoOrden
         AND A.NO_CIA = Pv_NoCia;
      --
      UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE A
         SET A.ESTADO = CON_ORDEN_COMPRA
       WHERE A.ID_PEDIDO_DETALLE = Lr_OrdenCompra.Id_Pedido_Detalle;
      --
    END LOOP;
    --
    IF C_DATOS_PEDIDO%ISOPEN THEN
      CLOSE C_DATOS_PEDIDO;
    END IF;
    OPEN C_DATOS_PEDIDO(Ln_PedidoId);
    FETCH C_DATOS_PEDIDO
      INTO Lr_DatosPedido;
    IF C_DATOS_PEDIDO%NOTFOUND THEN
      Lr_DatosPedido := NULL;
    END IF;
    CLOSE C_DATOS_PEDIDO;
    --
    IF Lr_DatosPedido.Usr_Autoriza_Id IS NULL THEN
      Pv_MensajeError := 'Pedido ' || Ln_PedidoId ||
                         ' no tiene asignado usuario autorizador.';
      RAISE Le_Error;
    END IF;
    --
    Lr_flujoAprobacion := null;
    --
    Lr_flujoAprobacion.Id_Empresa      := Pv_NoCia;
    Lr_flujoAprobacion.Secuencia       := 1;
    Lr_flujoAprobacion.Secuencia_Flujo := 1;
    Lr_flujoAprobacion.Tipo_Flujo      := 'AU';
    Lr_flujoAprobacion.Id_Orden        := Pv_NoOrden;
    Lr_flujoAprobacion.Id_Empleado     := Lr_DatosPedido.Usr_Autoriza_Id;
    Lr_flujoAprobacion.Fecha           := SYSDATE;
    Lr_flujoAprobacion.Estado          := 'AU';
    Lr_flujoAprobacion.Usuario_Crea    := Lr_DatosPedido.Usr_Autoriza;
    Lr_flujoAprobacion.Fecha_Crea      := sysdate;
    --
    P_INSERTA_FLUJO_APROBACION(Lr_flujoAprobacion, Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    -- se actualiza el estado del pedido solo si no hay detalles pendientes.
    UPDATE DB_COMPRAS.INFO_PEDIDO P
       SET P.ESTADO = CON_ORDEN_COMPRA
     WHERE P.ID_PEDIDO = Ln_PedidoId
       AND NOT EXISTS (SELECT NULL
              FROM DB_COMPRAS.INFO_PEDIDO_DETALLE IPD
             WHERE IPD.PEDIDO_ID = P.ID_PEDIDO
               AND IPD.ESTADO = AUTORIZADO);
    --
    IF SQL%ROWCOUNT > 0 THEN
      -- se registra en tabla de estados
      INSERT INTO DB_COMPRAS.INFO_PEDIDO_ESTADO
        (ID_PEDIDO_ESTADO,
         PEDIDO_ID,
         ESTADO,
         USR_CREACION,
         FE_CREACION,
         IP_CREACION)
      VALUES
        (DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_PEDIDO_ESTADO,
         Ln_PedidoId,
         CON_ORDEN_COMPRA,
         --GEK_CONSULTA.F_RECUPERA_LOGIN,  emunoz 1101203
         LOWER(USER),                              --emunoz 1101203
         SYSDATE,
         GEK_CONSULTA.F_RECUPERA_IP);
    END IF;
    --
    -- Asigna distribucion de costos en base al pedido.
    --
    IF C_SEC_DOCUMENTO_DISTRIB%ISOPEN THEN
      CLOSE C_SEC_DOCUMENTO_DISTRIB;
    END IF;
    OPEN C_SEC_DOCUMENTO_DISTRIB;
    FETCH C_SEC_DOCUMENTO_DISTRIB
      INTO Lr_DocDistribucion.No_Docu;
    IF C_SEC_DOCUMENTO_DISTRIB%NOTFOUND THEN
      Lr_DocDistribucion.No_Docu := 0;
    END IF;
    CLOSE C_SEC_DOCUMENTO_DISTRIB;
    --
    Lr_DocDistribucion.No_Docu := Lr_DocDistribucion.No_Docu + 1;
    --
    FOR Lr_DetOrden IN C_DETALLE_ORDEN LOOP
      --
      Lr_DocDistribucion.No_Cia                  := Lr_DetOrden.No_Cia;
      Lr_DocDistribucion.Tipo_Ccosto_Id          := Lr_DetOrden.Tipo_Ccosto_Id;
      Lr_DocDistribucion.Tipo_Ccosto_Descripcion := EMPLEADOS;
      Lr_DocDistribucion.Referencia_Id           := Lr_DetOrden.Referencia_Id;
      Lr_DocDistribucion.Referencia_Descripcion  := Lr_DetOrden.Referencia_Descripcion;
      Lr_DocDistribucion.Origen                  := Lr_DetOrden.Origen;
      Lr_DocDistribucion.Estado                  := ACTIVO;
      --
      NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.P_INSERTA_DOC_DISTRIBUCION(Lr_DocDistribucion,
                                                                     Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;
    --
    UPDATE NAF47_TNET.TAPORDEE
       SET ID_DOCUMENTO_DISTRIBUCION = Lr_DocDistribucion.No_Docu
     WHERE NO_CIA = Pv_NoCia
       AND NO_ORDEN = Pv_NoOrden;
       */

    --
  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'COK_ORDEN_COMPRA_PEDIDO.P_ACTUALIZA_VALORES_PEDIDO',
                                           Pv_MensajeError,
                                           --GEK_CONSULTA.F_RECUPERA_LOGIN,   emunoz 1101203
                                           LOWER(USER),                              --emunoz 1101203
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      --
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR('NAF',
                                            'COK_ORDEN_COMPRA_PEDIDO.P_ACTUALIZA_VALORES_PEDIDO',
                                            Pv_MensajeError,
                                            --GEK_CONSULTA.F_RECUPERA_LOGIN,   emunoz 1101203
                                            LOWER(USER),                              --emunoz 11012023
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP);
  END P_ACTUALIZA_VALORES_PEDIDO;

  PROCEDURE P_SOLICITUD_COMPRA_BIENES(Pv_Error OUT VARCHAR2) IS
    --
    ESTADO_ACTIVO_NAF      CONSTANT VARCHAR2(1) := 'A';
    CONTIENE_A             CONSTANT VARCHAR2(2) := 'CA';
    CONTENIDO_EN           CONSTANT VARCHAR2(2) := 'CE';
    BODEGA_REGION          CONSTANT VARCHAR2(2) := 'BR';
    ENCARGADO_REGION       CONSTANT VARCHAR2(50) := 'ENCARGADO-REGION';
    PARAMETROS_INVENTARIOS CONSTANT VARCHAR2(50) := 'PARAMETROS-INVENTARIOS';

    CURSOR C_REGIONES IS
      SELECT T.ID_REGION
        FROM NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP T,
             DB_GENERAL.ADMI_REGION                   R
       WHERE R.ID_REGION = T.ID_REGION
         AND T.ESTADO = 'P'
       GROUP BY T.ID_REGION
       ORDER BY T.ID_REGION;
    --
    -- Cursor que recupera los articulos que tiene stock minimo y no se encuentran en solicitud
    CURSOR C_PRODUCTOS_X_COMPRAR IS
      SELECT AR.ID_REGION,
             AR.ID_EMPRESA AS EMPRESA_ID,
             (SELECT BR.OBJETO_ID
                FROM NAF47_TNET.ARIN_PARAMETRO         P,
                     NAF47_TNET.ARIN_PARAMETRO_DETALLE BR
               WHERE BR.EMPRESA_OBJETO_ID = AR.ID_EMPRESA
                 AND BR.TIPO = CONTIENE_A
                 AND BR.ESTADO = ESTADO_ACTIVO_NAF
                 AND P.CLASE = BODEGA_REGION
                 AND P.ESTADO = ESTADO_ACTIVO_NAF
                 AND EXISTS (SELECT NULL
                        FROM NAF47_TNET.ARIN_PARAMETRO_DETALLE R
                       WHERE R.OBJETO_ID = TO_CHAR(AR.ID_REGION)
                         AND R.TIPO = CONTENIDO_EN
                         AND R.ESTADO = ESTADO_ACTIVO_NAF
                         AND R.PARAMETRO_ID = P.ID_PARAMETRO)
                 AND BR.PARAMETRO_ID = P.ID_PARAMETRO
                 AND BR.EMPRESA_OBJETO_ID = P.EMPRESA_ID) AS BODEGA,
             AR.ID_ARTICULO,
             DA.DESCRIPCION AS DESC_ARTICULO,
             DECODE(DA.APLICA_IMPUESTO, 'G', 'S', 'N') AS APLICA_IMPUESTO,
             NVL(DA.COSTO_UNITARIO, 0) COSTO_UNITARIO,
             AR.CANTIDAD_MINIMA,
             AR.CANTIDAD_MAXIMA,
             AR.ANIO,
             AR.MES
        FROM NAF47_TNET.ARINDA                        DA,
             NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP AR
       WHERE AR.ESTADO = 'R'
         AND AR.ID_ARTICULO = DA.NO_ARTI
         AND AR.ID_EMPRESA = DA.NO_CIA
       ORDER BY AR.ID_EMPRESA, AR.ID_REGION;

    CURSOR C_DATOS_EMPLEADO(Cn_IdRegion NUMBER, Cv_NoCia VARCHAR2) IS
      SELECT LE.LOGIN,
             E.ID_EMPRESA,
             D.ID_DEPARTAMENTO,
             A.ID_AREA,
             ME.IND_REGION AS REGION
        FROM DB_COMPRAS.ADMI_DEPARTAMENTO D,
             DB_COMPRAS.ADMI_AREA         A,
             DB_COMPRAS.ADMI_EMPRESA      E,
             NAF47_TNET.ARPLME            ME,
             NAF47_TNET.LOGIN_EMPLEADO    LE
       WHERE LE.NO_CIA = Cv_NoCia
         AND EXISTS (SELECT NULL
                FROM DB_GENERAL.ADMI_PROVINCIA       P,
                     DB_GENERAL.ADMI_CANTON          C,
                     DB_COMERCIAL.INFO_OFICINA_GRUPO IOG
               WHERE IOG.ID_OFICINA = ME.OFICINA
                 AND P.REGION_ID = Cn_IdRegion
                 AND C.PROVINCIA_ID = P.ID_PROVINCIA
                 AND IOG.CANTON_ID = C.ID_CANTON)
         AND EXISTS
       (SELECT NULL
                FROM DB_GENERAL.ADMI_PARAMETRO_DET ER
               WHERE ER.DESCRIPCION = ENCARGADO_REGION
                 AND ER.VALOR3 = LE.LOGIN
                 AND ER.EMPRESA_COD = LE.NO_CIA
                 AND EXISTS
               (SELECT NULL
                        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APD
                       WHERE NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                         AND APD.ID_PARAMETRO = ER.PARAMETRO_ID))
         AND ME.DEPTO = D.DPTO_COD
         AND A.ID_AREA = D.AREA_ID
         AND A.EMPRESA_ID = D.EMPRESA_ID
         AND ME.AREA = A.COD_AREA
         AND E.ID_EMPRESA = A.EMPRESA_ID
         AND LE.NO_CIA = E.CODIGO
         AND LE.NO_EMPLE = ME.NO_EMPLE
         AND LE.NO_CIA = ME.NO_CIA;
    --
    Ln_RegionAux DB_GENERAL.ADMI_REGION.ID_REGION%TYPE := 0;
    --
    Lr_InfoSolicitud    DB_COMPRAS.INFO_SOLICITUD%ROWTYPE := NULL;
    Lr_InfoSolicitudDet DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE := NULL;
    Ln_idSolicitud      DB_COMPRAS.INFO_SOLICITUD.ID_SOLICITUD%TYPE := NULL;
    Ln_TotalSolicitud   NUMBER(17, 2) := 0;
    Ln_Aux              NUMBER := 0;
    Le_Error EXCEPTION;
    --
  BEGIN
    -- se define punto de commit/rollback para hecerlo independiente del procedure que lo llame.
    SAVEPOINT SOLICITUD_COMPRA;
    --
    -- se lee cursor que recupera los productos despachados para validar el stock
    FOR Lr_Articulo IN C_PRODUCTOS_X_COMPRAR LOOP

      BEGIN

        Lr_InfoSolicitud    := NULL;
        Lr_InfoSolicitudDet := NULL;
        Ln_idSolicitud      := NULL;
        -- se recuperan los datos del bodeguero que es quien generara la solicitud de compra
        IF C_DATOS_EMPLEADO%ISOPEN THEN
          CLOSE C_DATOS_EMPLEADO;
        END IF;
        OPEN C_DATOS_EMPLEADO(Lr_Articulo.ID_REGION,
                              Lr_Articulo.EMPRESA_ID);
        FETCH C_DATOS_EMPLEADO
          INTO Lr_InfoSolicitud.Usr_Creacion,
               Lr_InfoSolicitud.Empresa_Id,
               Lr_InfoSolicitud.Departamento_Id,
               Lr_InfoSolicitud.Area_Id,
               Lr_InfoSolicitud.Region;

        IF C_DATOS_EMPLEADO%NOTFOUND THEN
          Pv_Error := 'Usuario ' || user ||
                      ' no se encuentra registrado en portal de Pedidos ';
          RAISE Le_Error;
        END IF;
        CLOSE C_DATOS_EMPLEADO;

        -- Se asignan valores a los otros campos
        Lr_InfoSolicitud.Tipo                     := 'Bie';
        Lr_InfoSolicitud.Estado                   := 'Pendiente';
        Lr_InfoSolicitud.Valor_Total              := 0;
        Lr_InfoSolicitud.Total_Descuento          := 0;
        Lr_InfoSolicitud.Total_Iva                := 0;
        Lr_InfoSolicitud.Subtotal                 := 0;
        Lr_InfoSolicitud.Fe_Creacion              := SYSDATE;
        Lr_InfoSolicitud.Ip_Creacion              := GEK_CONSULTA.F_RECUPERA_IP;
        Lr_InfoSolicitud.Proceso_Solicitud_Compra := 'R';
        Lr_InfoSolicitud.Id_Solicitud             := DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_SOLICITUD;

        -- se inserta cabecera de solicitud
        P_INSERTA_INFO_SOLICITUD(Lr_InfoSolicitud, Pv_Error);

        IF Pv_Error IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        -- se asigna nueva region para validar cambios
        Ln_TotalSolicitud := 0;
        Ln_idSolicitud    := Lr_InfoSolicitud.Id_Solicitud;

        -- Se procede a llenar el registro de detalle
        Lr_InfoSolicitudDet.Codigo                 := Lr_Articulo.Id_Articulo;
        Lr_InfoSolicitudDet.Descripcion            := Lr_Articulo.Desc_Articulo;
        Lr_InfoSolicitudDet.Cantidad               := Lr_Articulo.Cantidad_Maxima;
        Lr_InfoSolicitudDet.Estado                 := Lr_InfoSolicitud.Estado;
        Lr_InfoSolicitudDet.Solicitud_Id           := Lr_InfoSolicitud.Id_Solicitud;
        Lr_InfoSolicitudDet.Usr_Creacion           := Lr_InfoSolicitud.Usr_Creacion;
        Lr_InfoSolicitudDet.Fe_Creacion            := SYSDATE;
        Lr_InfoSolicitudDet.Ip_Creacion            := Lr_InfoSolicitud.Ip_Creacion;
        Lr_InfoSolicitudDet.Codigo_Genera_Impuesto := Lr_Articulo.Aplica_Impuesto;
        Lr_InfoSolicitudDet.Valor                  := Lr_Articulo.COSTO_UNITARIO;
        Ln_TotalSolicitud                          := Ln_TotalSolicitud +
                                                      Lr_Articulo.COSTO_UNITARIO;
        Lr_InfoSolicitudDet.Subtotal               := 0;
        Lr_InfoSolicitudDet.Porcentaje_Descuento   := 0;
        Lr_InfoSolicitudDet.Valor_Descuento        := 0;
        Lr_InfoSolicitudDet.Iva                    := 0;
        Lr_InfoSolicitudDet.Valor_Iva              := 0;
        Lr_InfoSolicitudDet.Total                  := 0;
        Lr_InfoSolicitudDet.Fe_Ult_Mod             := SYSDATE;
        Lr_InfoSolicitudDet.Usr_Ult_Mod            := Lr_InfoSolicitud.Usr_Creacion;
        --
        Lr_InfoSolicitudDet.Id_Solicitud_Detalle := DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_SOLICITUD_DETALLE;
        -- se inserta cabecera de solicitud
        P_INSERTA_INFO_SOLICITUD_DET(Lr_InfoSolicitudDet, Pv_Error);
        IF Pv_Error IS NOT NULL THEN
          RAISE Le_Error;
        END IF;

        IF Ln_TotalSolicitud > 0 THEN
          -- si genero solicitud de compra se debe actualizar total de la solicitud
          UPDATE DB_COMPRAS.INFO_SOLICITUD
             SET VALOR_TOTAL = Ln_TotalSolicitud
           WHERE ID_SOLICITUD = Lr_InfoSolicitud.Id_Solicitud;

        END IF;
        UPDATE NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
           SET ESTADO        = 'P',
               OBSERVACION   = 'Procesado',
               USR_ULT_MOD   = USER,
               FECHA_ULT_MOD = SYSDATE
         WHERE ID_EMPRESA = Lr_Articulo.EMPRESA_ID
           AND ID_ARTICULO = Lr_Articulo.ID_ARTICULO
           AND ID_REGION = Lr_Articulo.ID_REGION
           AND ANIO = Lr_Articulo.ANIO
           AND MES = Lr_Articulo.MES
           AND ESTADO = 'R';

      EXCEPTION
        WHEN Le_Error THEN
          UPDATE NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
             SET ESTADO        = 'E',
                 OBSERVACION   = Pv_Error,
                 USR_ULT_MOD   = USER,
                 FECHA_ULT_MOD = SYSDATE
           WHERE ID_EMPRESA = Lr_Articulo.EMPRESA_ID
             AND ID_ARTICULO = Lr_Articulo.ID_ARTICULO
             AND ID_REGION = Lr_Articulo.ID_REGION
             AND ANIO = Lr_Articulo.ANIO
             AND MES = Lr_Articulo.MES
             AND ESTADO = 'R';
          Pv_Error := NULL;

        WHEN OTHERS THEN
          UPDATE NAF47_TNET.ARIN_ARTICULO_RECURRENTE_TEMP
             SET ESTADO        = 'E',
                 OBSERVACION   = 'Error en procesar articulo',
                 USR_ULT_MOD   = USER,
                 FECHA_ULT_MOD = SYSDATE
           WHERE ID_EMPRESA = Lr_Articulo.EMPRESA_ID
             AND ID_ARTICULO = Lr_Articulo.ID_ARTICULO
             AND ID_REGION = Lr_Articulo.ID_REGION
             AND ANIO = Lr_Articulo.ANIO
             AND MES = Lr_Articulo.MES
             AND ESTADO = 'R';
          Pv_Error := NULL;

      END;

    END LOOP;

    --actualiza la tabla de articulos fijos/recurrentes de bodega
    UPDATE NAF47_TNET.INV_ARTI_RECU_MASTER A
       SET A.ESTADO = 'I'
     WHERE A.ESTADO = 'A';
    COMMIT;
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK TO SOLICITUD_COMPRA;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'COK_ORDEN_COMPRA_PEDIDO.P_SOLICITUD_COMPRA_BIENES',
                                           Pv_Error,
                                           --GEK_CONSULTA.F_RECUPERA_LOGIN,  emunoz 11012023
                                           LOWER(USER),                             --emunoz 1101203
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);

  END P_SOLICITUD_COMPRA_BIENES;


   PROCEDURE P_GENERA_SOL_ARTICULOS (Pn_Pedido    DB_COMPRAS.INFO_PEDIDO.ID_PEDIDO%TYPE,
                                    Pt_Articulos Lt_ArticulosType,
                                    Pv_Error OUT VARCHAR2)IS


  CURSOR C_DATOS_EMPLEADO IS
  SELECT DISTINCT P.USR_JEFE EMPLEADO_ASIGNADO_ID,
        EN.LOGIN_EMPLE USUARIO,
        EC.ID_EMPRESA,
        EC.CODIGO NO_CIA,
        DC.ID_DEPARTAMENTO,
        DC.AREA_ID,
        EN.IND_REGION REGION,
        'Bie' TIPO_SOLICITUD,
        'Pendiente' ESTADO,
        P.LOGIN
  FROM DB_COMPRAS.INFO_PEDIDO P
  JOIN V_EMPLEADOS_EMPRESAS EN ON EN.LOGIN_EMPLE = p.usr_jefe
  JOIN DB_COMPRAS.ADMI_EMPRESA EC ON EC.CODIGO = EN.NO_CIA 
  JOIN DB_COMPRAS.ADMI_DEPARTAMENTO DC ON DC.EMPRESA_ID = EC.ID_EMPRESA AND DC.DPTO_COD = EN.DEPTO
  AND ID_PEDIDO=Pn_Pedido;

  CURSOR C_PRODUCTO(Cv_NoCia    NAF47_TNET.ARINDA.NO_CIA%TYPE,
                    Cv_Articulo NAF47_TNET.ARINDA.NO_ARTI%TYPE) IS
  SELECT DA.NO_ARTI,
       DA.DESCRIPCION,
       DECODE(DA.APLICA_IMPUESTO, 'G', 'S', 'N') AS APLICA_IMPUESTO,
       DA.COSTO_UNITARIO
  FROM NAF47_TNET.ARINDA DA
  WHERE DA.NO_CIA= Cv_NoCia
  AND DA.NO_ARTI=Cv_Articulo;

  CURSOR C_IMPUESTO (Cn_IdEmpresa DB_COMPRAS.ADMI_EMPRESA.ID_EMPRESA%TYPE, Cod_Imp varchar) IS
     SELECT TO_NUMBER(VALOR, '999.999') VALOR FROM DB_COMPRAS.ADMI_PARAMETRO 
      WHERE EMPRESA_ID=Cn_IdEmpresa AND CODIGO=Cod_Imp;       

  Lr_InfoSolicitud    DB_COMPRAS.INFO_SOLICITUD%ROWTYPE := NULL;
  Lr_InfoSolicitudDet DB_COMPRAS.INFO_SOLICITUD_DETALLE%ROWTYPE := NULL;
  Lc_DatosEmpleado    C_DATOS_EMPLEADO%ROWTYPE;
  Lr_Articulo         C_PRODUCTO%ROWTYPE;
  Codigo_Impuesto_Iva VARCHAR(20);
  Ln_TotalSolicitud   NUMBER(17,2) := 0;
  Ln_Impuesto         NUMBER;
  Le_Error            EXCEPTION;
  BEGIN

    Lr_InfoSolicitud := NULL;
    Lr_InfoSolicitudDet := NULL;

    IF C_DATOS_EMPLEADO%ISOPEN THEN
      CLOSE C_DATOS_EMPLEADO;
    END IF;
    OPEN C_DATOS_EMPLEADO;
    FETCH C_DATOS_EMPLEADO INTO Lc_DatosEmpleado;
      IF C_DATOS_EMPLEADO%NOTFOUND THEN
        Pv_Error := 'Usuario usr_jefe no se encuentra registrado';
        RAISE Le_Error;
      END IF;
    CLOSE C_DATOS_EMPLEADO;

    IF Lc_DatosEmpleado.LOGIN IS NOT NULL THEN
      Pv_Error := 'Pedidos por proyecto no pueden generar Solicitud de Compras';
    END IF;

    Lr_InfoSolicitud.Pedido_id := Pn_Pedido;
    Lr_InfoSolicitud.Usr_Creacion := Lc_DatosEmpleado.EMPLEADO_ASIGNADO_ID;
    Lr_InfoSolicitud.Empresa_Id := Lc_DatosEmpleado.ID_EMPRESA;
    Lr_InfoSolicitud.Departamento_Id := Lc_DatosEmpleado.ID_DEPARTAMENTO;
    Lr_InfoSolicitud.Area_Id := Lc_DatosEmpleado.AREA_ID;
    Lr_InfoSolicitud.Region := Lc_DatosEmpleado.REGION;
    -- Se asignan valores a los otros campos
    Lr_InfoSolicitud.Tipo := 'Bie';
    Lr_InfoSolicitud.Estado := 'Pendiente';
    Lr_InfoSolicitud.Valor_Total := 0;
    Lr_InfoSolicitud.Total_Descuento := 0;
    Lr_InfoSolicitud.Total_Iva := 0;
    Lr_InfoSolicitud.Subtotal := 0;
    Lr_InfoSolicitud.Fe_Creacion := SYSDATE;
    Lr_InfoSolicitud.Ip_Creacion := GEK_CONSULTA.F_RECUPERA_IP;
    Lr_InfoSolicitud.Proceso_Solicitud_Compra := 'NR';
    Lr_InfoSolicitud.Id_Solicitud := DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_SOLICITUD;
    Lr_InfoSolicitud.Observacion := 'SolicitudBodega';

     -- se inserta cabecera de solicitud
    P_INSERTA_INFO_SOLICITUD( Lr_InfoSolicitud,
                              Pv_Error );
    IF Pv_Error IS NOT NULL THEN
        RAISE Le_Error;
    END IF;  

      IF Lr_InfoSolicitud.Empresa_Id = 4 THEN
     Codigo_Impuesto_Iva := 'IVA-12-MD';
     ELSE
     Codigo_Impuesto_Iva := 'IVA-12';
     END IF;

    OPEN C_IMPUESTO(Lr_InfoSolicitud.Empresa_Id,Codigo_Impuesto_Iva);
    FETCH C_IMPUESTO INTO Ln_Impuesto;
    CLOSE C_IMPUESTO;

    FOR I IN 1..Pt_Articulos.COUNT LOOP

      OPEN C_PRODUCTO(Lc_DatosEmpleado.NO_CIA,Pt_Articulos(i).NO_ARTI);
      FETCH C_PRODUCTO INTO Lr_Articulo;
        IF C_PRODUCTO%NOTFOUND THEN
        Pv_Error := 'No existe articulo: '||Pt_Articulos(i).NO_ARTI;
        RAISE Le_Error;
      END IF;
      CLOSE C_PRODUCTO;

      -- Se procede a llenar el registro de detalle
      Lr_InfoSolicitudDet.Pedido_Detalle_id := Pt_Articulos(i).Id_PedidoDetalle;
      Lr_InfoSolicitudDet.Codigo := Pt_Articulos(i).NO_ARTI;
      Lr_InfoSolicitudDet.Descripcion := Lr_Articulo.Descripcion;
      Lr_InfoSolicitudDet.Cantidad := Pt_Articulos(i).CANTIDAD;
      Lr_InfoSolicitudDet.Estado := 'CotizacionSeleccionada';
      Lr_InfoSolicitudDet.Solicitud_Id := Lr_InfoSolicitud.Id_Solicitud;
      Lr_InfoSolicitudDet.Usr_Creacion := Lr_InfoSolicitud.Usr_Creacion;
      Lr_InfoSolicitudDet.Fe_Creacion := SYSDATE;
      Lr_InfoSolicitudDet.Ip_Creacion := Lr_InfoSolicitud.Ip_Creacion;
      Lr_InfoSolicitudDet.Codigo_Genera_Impuesto := Lr_Articulo.Aplica_Impuesto;
      Lr_InfoSolicitudDet.Valor := Lr_Articulo.COSTO_UNITARIO;
      Lr_InfoSolicitudDet.IVA := Ln_Impuesto;
      DBMS_OUTPUT.PUT_LINE(Lr_InfoSolicitudDet.IVA);
      Lr_InfoSolicitudDet.VALOR_IVA := Lr_InfoSolicitudDet.Cantidad* (Lr_Articulo.COSTO_UNITARIO*Ln_Impuesto);
      DBMS_OUTPUT.PUT_LINE(Lr_InfoSolicitudDet.VALOR_IVA);
      Lr_InfoSolicitudDet.SUBTOTAL := Lr_InfoSolicitudDet.Cantidad* Lr_Articulo.COSTO_UNITARIO;
      DBMS_OUTPUT.PUT_LINE(Lr_InfoSolicitudDet.SUBTOTAL);
      Lr_InfoSolicitudDet.TOTAL := Lr_InfoSolicitudDet.SUBTOTAL+Lr_InfoSolicitudDet.VALOR_IVA;
      DBMS_OUTPUT.PUT_LINE(Lr_InfoSolicitudDet.TOTAL);
      Ln_TotalSolicitud := Ln_TotalSolicitud + Lr_InfoSolicitudDet.TOTAL;
      Lr_InfoSolicitudDet.Porcentaje_Descuento := 0;
      Lr_InfoSolicitudDet.Valor_Descuento := 0;

      --
      Lr_InfoSolicitudDet.Id_Solicitud_Detalle := DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_SOLICITUD_DETALLE;
      -- se inserta detalle de solicitud
      P_INSERTA_INFO_SOLICITUD_DET ( Lr_InfoSolicitudDet,
                                     Pv_Error );
      IF Pv_Error IS NOT NULL THEN
        RAISE Le_Error;
      END IF;

    END LOOP;

    IF Ln_TotalSolicitud > 0 THEN
    -- si genero solicitud de compra se debe actualizar total de la solicitud
      UPDATE DB_COMPRAS.INFO_SOLICITUD
      SET VALOR_TOTAL = Ln_TotalSolicitud
      WHERE ID_SOLICITUD =Lr_InfoSolicitud.Id_Solicitud;
    END IF;
    COMMIT;                                 
  EXCEPTION
  WHEN Le_Error THEN
    Pv_Error := 'Error en: P_GENERA_SOL_ARTICULOS '||Pv_Error;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'NAF',
        'COK_ORDEN_COMPRA_PEDIDO.P_GENERA_SOL_ARTICULOS',
        Pv_Error,
        --GEK_CONSULTA.F_RECUPERA_LOGIN,   emunoz 11012023
        LOWER(USER),                              --emunoz 11012023
        SYSDATE,
        GEK_CONSULTA.F_RECUPERA_IP
        );
  WHEN OTHERS THEN
    Pv_Error := 'Error en: P_GENERA_SOL_ARTICULOS '||SQLERRM;
    ROLLBACK;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR(
        'NAF',
        'COK_ORDEN_COMPRA_PEDIDO.P_GENERA_SOL_ARTICULOS',
        Pv_Error,
        --GEK_CONSULTA.F_RECUPERA_LOGIN,      emunoz 11012023
        LOWER(USER),                                 --emunoz 11012023
        SYSDATE,
        GEK_CONSULTA.F_RECUPERA_IP
        );
  END P_GENERA_SOL_ARTICULOS;   



  PROCEDURE P_INSERTA_CAT_ART_KATUK_CAB (Pr_CatArtKatuk  IN NAF47_TNET.ARIN_CATALOGO_KATUK_CAB%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2)IS
  CURSOR C_EXISTE_CATALOGO IS
  SELECT ID_CATALOGO
  FROM   NAF47_TNET.ARIN_CATALOGO_KATUK_CAB
  WHERE CODIGO= Pr_CatArtKatuk.CODIGO; 

  Ln_ExisteCatalogo NUMBER :=0;                               

  BEGIN
    OPEN C_EXISTE_CATALOGO;
    FETCH C_EXISTE_CATALOGO INTO Ln_ExisteCatalogo;
    CLOSE C_EXISTE_CATALOGO;

    IF Ln_ExisteCatalogo > 0 THEN
      Pv_MensajeError := 'Ya existe catalogo con codigo: '||Pr_CatArtKatuk.CODIGO;
    ELSE

      INSERT INTO NAF47_TNET.ARIN_CATALOGO_KATUK_CAB
        (
         ID_CATALOGO,
         NOMBRE,
         NIVEL,
         TIPO,
         CODIGO,
         USUARIO_CREACION)
      VALUES
        (
         Pr_CatArtKatuk.ID_CATALOGO,
         Pr_CatArtKatuk.NOMBRE,
         Pr_CatArtKatuk.NIVEL,
         Pr_CatArtKatuk.TIPO,
         Pr_CatArtKatuk.CODIGO,
         Pr_CatArtKatuk.USUARIO_CREACION);
       COMMIT;
       END IF;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MensajeError := 'Error en P_INSERTA_CAT_ART_KATUK: '||SQLERRM;

  END P_INSERTA_CAT_ART_KATUK_CAB;

  PROCEDURE P_INSERTA_CAT_ART_KATUK_DET (Pr_CatArtKatuk  IN NAF47_TNET.ARIN_CATALOGO_KATUK_DET%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2)IS
  CURSOR C_EXISTE_CATALOGO IS
  SELECT CATALOGO_ID
  FROM   NAF47_TNET.ARIN_CATALOGO_KATUK_DET
  WHERE CODIGO= Pr_CatArtKatuk.CODIGO; 

  Ln_ExisteCatalogo NUMBER :=0;                               

  BEGIN
    OPEN C_EXISTE_CATALOGO;
    FETCH C_EXISTE_CATALOGO INTO Ln_ExisteCatalogo;
    CLOSE C_EXISTE_CATALOGO;

    IF Ln_ExisteCatalogo > 0 THEN
      Pv_MensajeError := 'Ya existe catalogo con codigo: '||Pr_CatArtKatuk.CODIGO;
    ELSE

      INSERT INTO NAF47_TNET.ARIN_CATALOGO_KATUK_DET
        (
         ID_CATALOGO_DET,
         NOMBRE,
         NIVEL,
         TIPO,
         CODIGO,
         CATALOGO_ID,
         USUARIO_CREACION)
      VALUES
        (
         Pr_CatArtKatuk.ID_CATALOGO_DET,
         Pr_CatArtKatuk.NOMBRE,
         Pr_CatArtKatuk.NIVEL,
         Pr_CatArtKatuk.TIPO,
         Pr_CatArtKatuk.CODIGO,
         Pr_CatArtKatuk.CATALOGO_ID,
         Pr_CatArtKatuk.USUARIO_CREACION);
       COMMIT;
       END IF;
  EXCEPTION
  WHEN OTHERS THEN
    Pv_MensajeError := 'Error en P_INSERTA_CAT_ART_KATUK: '||SQLERRM;

  END P_INSERTA_CAT_ART_KATUK_DET;

  PROCEDURE P_INSERT_CAT_ART_KATUK(PC_JSON IN CLOB,
                                   PV_STATUS    OUT VARCHAR2,
                                   PV_MENSAJE   OUT VARCHAR2)
  AS
  CURSOR C_EXISTE_CATALOGO(Cv_Codigo NAF47_TNET.ARIN_CATALOGO_KATUK_CAB.CODIGO%TYPE) IS
  SELECT ID_CATALOGO CATALOGO,NOMBRE,NIVEL
  FROM   NAF47_TNET.ARIN_CATALOGO_KATUK_CAB
  WHERE CODIGO= Cv_Codigo
  UNION
  SELECT ID_CATALOGO_DET CATALOGO ,NOMBRE,NIVEL
  FROM   NAF47_TNET.ARIN_CATALOGO_KATUK_DET
  WHERE CODIGO= Cv_Codigo;

  CURSOR C_EXISTE_CATALOGO_CAB(Cv_Codigo NAF47_TNET.ARIN_CATALOGO_KATUK_CAB.CODIGO%TYPE) IS
  SELECT ID_CATALOGO,NOMBRE,NIVEL
  FROM   NAF47_TNET.ARIN_CATALOGO_KATUK_CAB
  WHERE CODIGO= Cv_Codigo;

  Lex_Exception             EXCEPTION;
  Lc_Json                   CLOB;
  Lc_Resultado              CLOB;
  Lc_Data                   CLOB;
  Lc_Catalogo               C_EXISTE_CATALOGO%ROWTYPE;
  Lc_CatalogoCab            C_EXISTE_CATALOGO_CAB%ROWTYPE;
  Lv_NoCia                  NAF47_TNET.ARINDA.NO_CIA%TYPE;
  Lv_NoArti                 NAF47_TNET.ARINDA.NO_ARTI%TYPE;
  Lt_ArinCatArtKatuk        NAF47_TNET.ARIN_CATALOGO_KATUK_CAB%ROWTYPE;
  Lt_ArinCatArtKatukDet     NAF47_TNET.ARIN_CATALOGO_KATUK_DET%ROWTYPE;
  Lv_MensajeUsuario         VARCHAR2(500);
  Lv_MensajeTecnico         VARCHAR2(500);
  Lv_CodigoResponse         VARCHAR2(10);
  Lv_CodigoRef              VARCHAR2(100);
  Lv_Error                  VARCHAR2(1000);
  Ln_IdCatalogo             NUMBER;
  Lb_ExisteCatalogo         BOOLEAN;
  Le_Errors              EXCEPTION;

  BEGIN
    Lc_Json  := Pc_Json;
    apex_json.parse(Lc_Json);
    -- RETORNO LAS VARIABLES DEL REQUEST
    Lt_ArinCatArtKatuk.nombre     := apex_json.get_varchar2(p_path => 'nombre');
    Lt_ArinCatArtKatuk.nivel      := apex_json.get_varchar2(p_path => 'nivel');
    Lt_ArinCatArtKatuk.tipo       := apex_json.get_varchar2(p_path => 'tipo');
    Lt_ArinCatArtKatuk.codigo     := apex_json.get_varchar2(p_path => 'codigo');
    Lt_ArinCatArtKatuk.usuario_creacion := apex_json.get_varchar2(p_path => 'usrCreacion');

    OPEN C_EXISTE_CATALOGO(Lt_ArinCatArtKatuk.codigo);
    FETCH C_EXISTE_CATALOGO INTO Lc_Catalogo;
    IF C_EXISTE_CATALOGO%FOUND THEN
      Lb_ExisteCatalogo := TRUE;
      Ln_IdCatalogo:= Lc_Catalogo.CATALOGO;
    ELSE
      Lb_ExisteCatalogo := FALSE;
    END IF;
    CLOSE C_EXISTE_CATALOGO;
    --Si el catalogo no existe se registra
    IF NOT Lb_ExisteCatalogo THEN

    IF Lt_ArinCatArtKatuk.nombre IS NULL THEN
      Pv_Mensaje := 'Parametro nombre es requerido';
      RAISE Le_Errors;
    ELSIF Lt_ArinCatArtKatuk.nivel IS NULL THEN
      Pv_Mensaje := 'Parametro nivel es requerido';
      RAISE Le_Errors;
    ELSIF  Lt_ArinCatArtKatuk.tipo IS NULL THEN
      Pv_Mensaje := 'Parametro tipo es requerido';
      RAISE Le_Errors;
    ELSIF Lt_ArinCatArtKatuk.codigo IS NULL THEN
      Pv_Mensaje := 'Parametro codigo es requerido';
      RAISE Le_Errors;
    ELSE
      IF Lt_ArinCatArtKatuk.nivel = '1' THEN
        -- Creamos Catalogos nivel 1 Cabecera
        Lt_ArinCatArtKatuk.id_catalogo := NAF47_TNET.MIG_SECUENCIA.SEQ_ARIN_CATALOGO_KATUK_CAB;
        P_INSERTA_CAT_ART_KATUK_CAB(Lt_ArinCatArtKatuk,
                                Lv_Error);
        Ln_IdCatalogo := Lt_ArinCatArtKatuk.id_catalogo;
      ELSIF Lt_ArinCatArtKatuk.nivel = '2' THEN
        -- Creamos Catalogos nivel 2 Detalle
        Lt_ArinCatArtKatukDet.Nombre := Lt_ArinCatArtKatuk.Nombre;
        Lt_ArinCatArtKatukDet.Nivel  := Lt_ArinCatArtKatuk.Nivel;
        Lt_ArinCatArtKatukDet.Tipo   := Lt_ArinCatArtKatuk.Tipo;
        Lt_ArinCatArtKatukDet.Codigo := Lt_ArinCatArtKatuk.Codigo;
        Lv_CodigoRef                 := apex_json.get_varchar2(p_path => 'codigoRef');

        OPEN  C_EXISTE_CATALOGO_CAB(Lv_CodigoRef);
        FETCH C_EXISTE_CATALOGO_CAB INTO Lc_CatalogoCab;
        IF C_EXISTE_CATALOGO_CAB%FOUND THEN
          Lt_ArinCatArtKatukDet.Catalogo_Id := Lc_CatalogoCab.Id_Catalogo;
        END IF;
        CLOSE C_EXISTE_CATALOGO_CAB;

        IF Lt_ArinCatArtKatukDet.Catalogo_Id IS NOT NULL THEN
          Lt_ArinCatArtKatukDet.Id_Catalogo_Det := NAF47_TNET.MIG_SECUENCIA.SEQ_ARIN_CATALOGO_KATUK_DET;

          P_INSERTA_CAT_ART_KATUK_DET(Lt_ArinCatArtKatukDet,
                                Lv_Error);
          Ln_IdCatalogo := Lt_ArinCatArtKatukDet.id_catalogo_Det;
        ELSE
          Lv_Error := 'No existe catalogo: '||Lv_CodigoRef||' enviado como cat?logo referencia';
        END IF;
      END IF;
      IF Lv_Error IS NOT NULL THEN
        Pv_Mensaje := Lv_Error;
        RAISE Le_Errors;
      END IF;
    END IF;
    ELSE
        IF  Lt_ArinCatArtKatuk.nombre IS NOT NULL AND Lt_ArinCatArtKatuk.nombre!=Lc_Catalogo.NOMBRE THEN
          IF Lc_Catalogo.Nivel ='1' THEN
            UPDATE NAF47_TNET.ARIN_CATALOGO_KATUK_CAB
              SET NOMBRE = Lt_ArinCatArtKatuk.nombre
            WHERE ID_CATALOGO =   Lc_Catalogo.CATALOGO;
          ELSIF Lc_Catalogo.Nivel ='2' THEN
            UPDATE NAF47_TNET.ARIN_CATALOGO_KATUK_DET
              SET NOMBRE = Lt_ArinCatArtKatuk.nombre
            WHERE ID_CATALOGO_DET =   Lc_Catalogo.CATALOGO;
          END IF;
        END IF;
    END IF;
    --Si no hubo error se verifica datos de articulos
    Lv_NoCia  := apex_json.get_varchar2(p_path => 'noCia');
    Lv_NoArti := apex_json.get_varchar2(p_path => 'noArti');
    --Se verifica que envien el codigo de articulo en NAF
    IF Lv_NoCia IS NOT NULL AND Lv_NoArti IS NOT NULL AND Ln_IdCatalogo IS NOT NULL THEN
      UPDATE NAF47_TNET.ARINDA
      SET CATALOGO_ID_DET= Ln_IdCatalogo
      WHERE NO_CIA=Lv_NoCia
      AND NO_ARTI= Lv_NoArti;
    END IF;

    COMMIT;
    Pv_Status  := 'OK';
    Pv_Mensaje := 'Transaccion exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;
  END P_INSERT_CAT_ART_KATUK;

end COK_ORDEN_COMPRA_PEDIDO;
/
