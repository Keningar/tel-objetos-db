CREATE EDITIONABLE PACKAGE            INKG_TRANSACCIONES_PEDIDOS AS

  -- Author  : VMMORENO
  -- Created : 05/07/2021 10:20:02
  -- Purpose : Nuevo

  /**
  * Documentaci�n para PROCEDURE P_INSERT_INFO_PEDIDO
  * Paquete que inserta la cabecera de un pedido
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 05-07-2021
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 06/02/2022 - Se modifica para cambiar lista de parametros por un parametro tipo registro
  *
  * @param Pr_InfoPedido   IN DB_COMPRAS.INFO_PEDIDO%ROWTYPE recibe parametro tipo registro de tabla info_pedido
  * @param Pv_MensajeError IN OUT VARCHAR2                   retorna mensaje de error.
  *
  */

  PROCEDURE P_INSERT_INFO_PEDIDO( Pr_InfoPedido   IN DB_COMPRAS.INFO_PEDIDO%ROWTYPE,
                                  Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE P_INSERT_INFO_PEDIDO_DETALLE
  * Paquete que inserta el detalle de un pedido
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 05-07-2021
      
   @param Pn_IdPedidoDetalle             IN NUMBER secuencia id pedido detalle
   @param Pn_CantidadSolicitada          IN NUMBER cantidad solicitada
   @param Pv_DescripcionSolicitada       IN VARCHAR2 descripci�n solicitada
   @param Pv_UsrAsignadoId               IN VARCHAR2 usuario asigando id
   @param Pv_UsrAsignado                 IN VARCHAR2 usuario asignado
   @param Pn_CaracteristicaId            IN NUMBER caracter�sticas id
   @param Pv_ProductoEmpresaId           IN VARCHAR2 producto empresa id
   @param Pv_ProductoId                  IN VARCHAR2 producto id,
   @param Pv_Descripcion                 IN VARCHAR2 descripci�n
   @param Pn_Cantidad                    IN NUMBER cantidad
   @param Pn_CostoProducto               IN NUMBER costo producto
   @param Pn_Subtotal                    IN NUMBER subtotal
   @param Pn_ProductoEmpresaIdReasignado IN NUMBER producto empresa id reasignado
   @param Pv_ProductoIdReasignado        IN VARCHAR2 producto id reasignado
   @param Pv_Obervacion                  IN VARCHAR2 observaci�n
   @param Pv_EsCompra                    IN VARCHAR2 es compra
   @param Pv_ComprobanteEgreso           IN VARCHAR2 comprobante de egreso
   @param Pd_FeCreacion                  IN DATE fecha creaci�n
   @param Pv_Estado                      IN VARCHAR2 estado
   @param Pn_CantidadDespachada          IN NUMBER cantidad despachada
   @param Pv_Anular                      IN VARCHAR2 anular
   @param Pd_FeUltMod                    IN DATE fecha �ltima modificaci�n
   @param Pv_UsrCreacion                 IN VARCHAR2 usuario creaci�n
   @param Pv_UsrUltMod                   IN VARCHAR2 usuario �ltima modificaci�n
   @param Pv_IpCreacion                  IN VARCHAR2 ip creaci�n
   @param Pn_PedidoId                    IN NUMBER id pedido
   @param Pv_PedidoUsoId                 IN VARCHAR2 id pedido uso
   @param Pv_EsDescuentoRol              IN VARCHAR2 es descuento rol
   @param Pv_UsrAprobacionId             IN VARCHAR2 usuario aprobaci�n id
   @param Pv_UsrAprobacion               IN VARCHAR2 usuario aprobaci�n
   @param Pv_EsAprobacion                IN VARCHAR2 es aprobaci�n
   @param Pn_PedidoAprobacionId          IN NUMBER pedido aprobaci�n id
   @param Pn_PedidoPlantillaId           IN NUMBER pedido plantilla id
   @param Pv_EsRecurrente                IN VARCHAR2 es recurrente
   @param Pn_ServicioId                  IN NUMBER servicio id
   @param Pv_NoProveedor                 IN VARCHAR2 no proveedor
   @param Pv_CedulaProveedor             IN VARCHAR2 c�dula proveedor
   @param Pv_NombreProveedor             IN VARCHAR2 nombre proveedor
   @param Pv_GeneraImpuesto              IN VARCHAR2 genera impuesto
   @param Pv_Devolucion                  IN VARCHAR2 devoluci�n
   @param Pn_CantidadADevolver           IN NUMBER cantidad a devolver
   @param Pn_CantidadDevuelta            IN NUMBER cantidad devuelta
   @param Pv_Placa                       IN VARCHAR2 placa
   @param Pv_LugarDestino                IN VARCHAR2 lugar destino
   @param Pv_NombreDestino               IN VARCHAR2 nombre destino
   @param Pv_EsConsumible                IN VARCHAR2 es consumible
   @param Pb_Permitido                   OUT BOOLEAN retorna true o false
  */

  PROCEDURE P_INSERT_INFO_PEDIDO_DETALLE(Pn_IdPedidoDetalle             IN NUMBER,
                                         Pn_CantidadSolicitada          IN NUMBER,
                                         Pv_DescripcionSolicitada       IN VARCHAR2,
                                         Pv_UsrAsignadoId               IN VARCHAR2,
                                         Pv_UsrAsignado                 IN VARCHAR2,
                                         Pn_CaracteristicaId            IN NUMBER,
                                         Pv_ProductoEmpresaId           IN VARCHAR2,
                                         Pv_ProductoId                  IN VARCHAR2,
                                         Pv_Descripcion                 IN VARCHAR2,
                                         Pn_Cantidad                    IN NUMBER,
                                         Pn_CostoProducto               IN NUMBER,
                                         Pn_Subtotal                    IN NUMBER,
                                         Pn_ProductoEmpresaIdReasignado IN NUMBER,
                                         Pv_ProductoIdReasignado        IN VARCHAR2,
                                         Pv_Obervacion                  IN VARCHAR2,
                                         Pv_EsCompra                    IN VARCHAR2,
                                         Pv_ComprobanteEgreso           IN VARCHAR2,
                                         Pd_FeCreacion                  IN DATE,
                                         Pv_Estado                      IN VARCHAR2,
                                         Pn_CantidadDespachada          IN NUMBER,
                                         Pv_Anular                      IN VARCHAR2,
                                         Pd_FeUltMod                    IN DATE,
                                         Pv_UsrCreacion                 IN VARCHAR2,
                                         Pv_UsrUltMod                   IN VARCHAR2,
                                         Pv_IpCreacion                  IN VARCHAR2,
                                         Pn_PedidoId                    IN NUMBER,
                                         Pv_PedidoUsoId                 IN VARCHAR2,
                                         Pv_EsDescuentoRol              IN VARCHAR2,
                                         Pv_UsrAprobacionId             IN VARCHAR2,
                                         Pv_UsrAprobacion               IN VARCHAR2,
                                         Pv_EsAprobacion                IN VARCHAR2,
                                         Pn_PedidoAprobacionId          IN NUMBER,
                                         Pn_PedidoPlantillaId           IN NUMBER,
                                         Pv_EsRecurrente                IN VARCHAR2,
                                         Pn_ServicioId                  IN NUMBER,
                                         Pv_NoProveedor                 IN VARCHAR2,
                                         Pv_CedulaProveedor             IN VARCHAR2,
                                         Pv_NombreProveedor             IN VARCHAR2,
                                         Pv_GeneraImpuesto              IN VARCHAR2,
                                         Pv_Devolucion                  IN VARCHAR2,
                                         Pn_CantidadADevolver           IN NUMBER,
                                         Pn_CantidadDevuelta            IN NUMBER,
                                         Pv_Placa                       IN VARCHAR2,
                                         Pv_LugarDestino                IN VARCHAR2,
                                         Pv_NombreDestino               IN VARCHAR2,
                                         Pv_EsConsumible                IN VARCHAR2,
                                         Pb_Permitido                   OUT BOOLEAN);

  /* Documentaci�n para funci�n F_GET_ADMI_EMPRESA
  * Funci�n que retorna un registro, buscado por su c�digo y estado
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 05/07/2021
  
  @param Pv_Codigo   c�digo de empresa
  @param Pv_Estado   estado
  */

  FUNCTION F_GET_ADMI_EMPRESA(Pv_Codigo IN VARCHAR2, Pv_Estado IN VARCHAR2)
    RETURN DB_COMPRAS.ADMI_EMPRESA%ROWTYPE;

  /**
  * Documentaci�n para funci�n F_GET_ADMI_DEPARTAMENTO
  * Funcion que retorna un registro del c�difo del departamento, buscado por empresa, codigo y estado
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 05/07/2021
  
  @param Pv_NoCia compan�a
  @param Pv_Codigo c�digo de departamento
  @param Pv_Estado estado
  @param Pv_MensajeError mensaje de error
  */

  FUNCTION F_GET_ADMI_DEPARTAMENTO(Pv_NoCia        IN VARCHAR2,
                                   Pv_Codigo       IN VARCHAR2,
                                   Pv_Estado       IN VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2)
    RETURN DB_COMPRAS.ADMI_DEPARTAMENTO%ROWTYPE;

  /**
  * Documentaci�n para funci�n F_GET_USUARIO_NAF
  * Funcion que retorna  los datos de un usuario, buscado por empresa, codigo y estado
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 05/07/2021
  
    @param Pv_NoCia  compan�a
    @param Pv_NoEmple c�digo de empleado
    @param Pv_Estado estado
  */
  FUNCTION F_GET_USUARIO_NAF(Pv_NoCia        IN VARCHAR2,
                             Pv_NoEmple      IN VARCHAR2,
                             Pv_Estado       IN VARCHAR2,
                             Pv_MensajeError OUT VARCHAR2)
    RETURN NAF47_TNET.V_EMPLEADOS_EMPRESAS%ROWTYPE;

  /**
  * Documentaci�n para funci�n F_GET_ADMI_PARAMETRO
  * Funcion que retorna un registro de ADMI_PARAMETRO, buscado por empresa, c�digo y estado
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 05/07/2021
  
   @param Pv_EmpresaId  compan�a
   @param Pv_Codigo c�digo de par�metro
   @param Pv_Estado estado
  */

  FUNCTION F_GET_ADMI_PARAMETRO(Pv_EmpresaId    IN VARCHAR2,
                                Pv_Codigo       IN VARCHAR2,
                                Pv_Estado       IN VARCHAR2,
                                Pv_MensajeError OUT VARCHAR2)
    RETURN DB_COMPRAS.ADMI_PARAMETRO%ROWTYPE;

  /**
  * Documentaci�n para funci�n P_PEDIDO_MASIVO_INST
  * Procedimiento que realiza el insert masivo diario de pedidos y detalle de pedidos
  * de las tareas realizadas de instalaciones de �ltima milla de cada uno de los t�cnicos en Megadatos
  * buscado por empresa, tipo_ejecuci�n.
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 05/07/2021
  *
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.1 06/02/2022 - Se modifica proceso para mejorar busquedas de data Jefe Cuadrilla, T�nicos, Pedidos generados existentes
  *                           articulos asignados a t�nicos en control custodios. Tambien se mejora control de errores por registros tareas,
  *                           registros plantillas y por env�o de correo electr�nico. Tambi�n se corrige generaci�nmas detallada de los errores
  *                           en log-errores-pedidos-masivos.
  *                            Se agregan parametros de Fecha-Hora Inicio y Fecha-Hora Fin enviadas por proceso que lee configuraci�n 
  *                           para ejecuci�n de JOB
  *
  * @param Pd_FechaFin     IN DATE         Recibe fecha y hora inicio de tareas generadas
  * @param Pd_FechaFin     IN DATE         Recibe fecha y hora fin de tareas generadas
  * @param Pv_Empresa      IN VARCHAR2     recibe c�digo de compan�a
  * @param Pv_MensajeError IN OUT VARCHAR2 retorna mensaje error
  *
  */
  PROCEDURE P_PEDIDO_MASIVO_INST ( Pd_FechaInicio  IN DATE,
                                   Pd_FechaFin     IN DATE,
                                   Pv_Empresa      IN VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2);

  /**
  * Documentaci�n para PROCEDURE P_EJECUTAR_JOB
  * Procedimiento que ejecuta 2 tareas progamadas para la ejecuci�n masiva de creaci�n de pedidos.
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 04-08-2021
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 06/02/2022 - Se modifica para procesar JOB mediante condiguraci�n en tabla de parametros
  *                           se elimina parametros.
  */

  PROCEDURE P_EJECUTAR_JOB;

  /**
  * Documentaci�n para P_LOG_ERROR_PEDIDOS_AUT
  * Procedimiento que inserta los l�deres que no se encuentran configurado en NAF
  * @author Ver�nica Moreno <vmmoreno@telconet.ec>
  * @version 1.0 01-08-2021
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.2 06/02/2022 - Se modifica para agregar fecha de regitro en insert
  *
  * @param Pr_log_pedido NAF47_TNET.LOG_ERROR_PEDIDOS_AUT%ROWTYPE Variable registro que se va a insertar
  *
  */
  PROCEDURE P_LOG_ERROR_PEDIDOS_AUT(Pr_log_pedido NAF47_TNET.LOG_ERROR_PEDIDOS_AUT%ROWTYPE);

END INKG_TRANSACCIONES_PEDIDOS;
/


CREATE EDITIONABLE PACKAGE BODY            INKG_TRANSACCIONES_PEDIDOS AS
  --
  PARAMETROS_INVENTARIOS  CONSTANT VARCHAR2(22) := 'PARAMETROS-INVENTARIOS';
  --
  PROCEDURE P_INSERT_INFO_PEDIDO ( Pr_InfoPedido   IN DB_COMPRAS.INFO_PEDIDO%ROWTYPE,
                                   Pv_MensajeError IN OUT VARCHAR2) IS
  
    Lex_Exception EXCEPTION;
  
  BEGIN
  
    INSERT INTO DB_COMPRAS.INFO_PEDIDO
    
      (ID_PEDIDO,
       DEPARTAMENTO_ID,
       USR_CREACION,
       OBSERVACION,
       VALOR_TOTAL,
       MONTO_TOTAL_APROBACION,
       MONTO_INICIAL_APROBACION,
       SALDO_APROBACION,
       VALOR_DESCONTADO,
       USR_JEFE_ID,
       USR_JEFE,
       NOMBRES_JEFE,
       USR_ULT_MOD,
       ESTADO,
       FE_CREACION,
       FE_ULT_MOD,
       IP_CREACION,
       PEDIDO_TIPO,
       USR_AUTORIZA_ID,
       USR_AUTORIZA,
       USR_ASIGNADO_TIPO,
       USR_CREACION_ID,
       PROYECTO_ID,
       TIPO_SERVICIO,
       DESCONTAR_MONTO_APROBACION,
       MONTO_POR_APROBAR,
       USR_MONTO_APROBACION_ID,
       USR_MONTO_APROBACION,
       APLICATIVO_REFERENCIA,
       NUMERO_REFERENCIA,
       TIPO_PROCESO)
    
    VALUES
    
      (Pr_InfoPedido.id_pedido,
       Pr_InfoPedido.departamento_id,
       Pr_InfoPedido.usr_creacion,
       Pr_InfoPedido.observacion,
       Pr_InfoPedido.valor_total,
       Pr_InfoPedido.monto_total_aprobacion,
       Pr_InfoPedido.monto_inicial_aprobacion,
       Pr_InfoPedido.saldo_aprobacion,
       Pr_InfoPedido.valor_descontado,
       Pr_InfoPedido.usr_jefe_id,
       Pr_InfoPedido.usr_jefe,
       Pr_InfoPedido.nombres_jefe,
       Pr_InfoPedido.usr_ult_mod,
       Pr_InfoPedido.estado,
       Pr_InfoPedido.fe_creacion,
       Pr_InfoPedido.fe_ult_mod,
       Pr_InfoPedido.ip_creacion,
       Pr_InfoPedido.pedido_tipo,
       Pr_InfoPedido.usr_autoriza_id,
       Pr_InfoPedido.usr_autoriza,
       Pr_InfoPedido.usr_asignado_tipo,
       Pr_InfoPedido.usr_creacion_id,
       Pr_InfoPedido.proyecto_id,
       Pr_InfoPedido.tipo_servicio,
       Pr_InfoPedido.descontar_monto_aprobacion,
       Pr_InfoPedido.monto_por_aprobar,
       Pr_InfoPedido.usr_monto_aprobacion_id,
       Pr_InfoPedido.usr_monto_aprobacion,
       Pr_InfoPedido.aplicativo_referencia,
       Pr_InfoPedido.numero_referencia,
       Pr_InfoPedido.tipo_proceso);
  
  EXCEPTION  
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCIONES_PEDIDOS.P_INSERT_INFO_PEDIDO',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    
  END P_INSERT_INFO_PEDIDO;
  --
  PROCEDURE P_INSERT_INFO_PEDIDO_DETALLE(Pn_IdPedidoDetalle             IN NUMBER,
                                         Pn_CantidadSolicitada          IN NUMBER,
                                         Pv_DescripcionSolicitada       IN VARCHAR2,
                                         Pv_UsrAsignadoId               IN VARCHAR2,
                                         Pv_UsrAsignado                 IN VARCHAR2,
                                         Pn_CaracteristicaId            IN NUMBER,
                                         Pv_ProductoEmpresaId           IN VARCHAR2,
                                         Pv_ProductoId                  IN VARCHAR2,
                                         Pv_Descripcion                 IN VARCHAR2,
                                         Pn_Cantidad                    IN NUMBER,
                                         Pn_CostoProducto               IN NUMBER,
                                         Pn_Subtotal                    IN NUMBER,
                                         Pn_ProductoEmpresaIdReasignado IN NUMBER,
                                         Pv_ProductoIdReasignado        IN VARCHAR2,
                                         Pv_Obervacion                  IN VARCHAR2,
                                         Pv_EsCompra                    IN VARCHAR2,
                                         Pv_ComprobanteEgreso           IN VARCHAR2,
                                         Pd_FeCreacion                  IN DATE,
                                         Pv_Estado                      IN VARCHAR2,
                                         Pn_CantidadDespachada          IN NUMBER,
                                         Pv_Anular                      IN VARCHAR2,
                                         Pd_FeUltMod                    IN DATE,
                                         Pv_UsrCreacion                 IN VARCHAR2,
                                         Pv_UsrUltMod                   IN VARCHAR2,
                                         Pv_IpCreacion                  IN VARCHAR2,
                                         Pn_PedidoId                    IN NUMBER,
                                         Pv_PedidoUsoId                 IN VARCHAR2,
                                         Pv_EsDescuentoRol              IN VARCHAR2,
                                         Pv_UsrAprobacionId             IN VARCHAR2,
                                         Pv_UsrAprobacion               IN VARCHAR2,
                                         Pv_EsAprobacion                IN VARCHAR2,
                                         Pn_PedidoAprobacionId          IN NUMBER,
                                         Pn_PedidoPlantillaId           IN NUMBER,
                                         Pv_EsRecurrente                IN VARCHAR2,
                                         Pn_ServicioId                  IN NUMBER,
                                         Pv_NoProveedor                 IN VARCHAR2,
                                         Pv_CedulaProveedor             IN VARCHAR2,
                                         Pv_NombreProveedor             IN VARCHAR2,
                                         Pv_GeneraImpuesto              IN VARCHAR2,
                                         Pv_Devolucion                  IN VARCHAR2,
                                         Pn_CantidadADevolver           IN NUMBER,
                                         Pn_CantidadDevuelta            IN NUMBER,
                                         Pv_Placa                       IN VARCHAR2,
                                         Pv_LugarDestino                IN VARCHAR2,
                                         Pv_NombreDestino               IN VARCHAR2,
                                         Pv_EsConsumible                IN VARCHAR2,
                                         Pb_Permitido                   OUT BOOLEAN) IS
  
    Lex_Exception EXCEPTION;
  
  BEGIN
  
    INSERT INTO DB_COMPRAS.INFO_PEDIDO_DETALLE
    
      (ID_PEDIDO_DETALLE,
       CANTIDAD_SOLICITADA,
       DESCRIPCION_SOLICITADA,
       USR_ASIGNADO_ID,
       USR_ASIGNADO,
       CARACTERISTICA_ID,
       PRODUCTO_EMPRESA_ID,
       PRODUCTO_ID,
       DESCRIPCION,
       CANTIDAD,
       COSTO_PRODUCTO,
       SUBTOTAL,
       PRODUCTO_EMPRESA_ID_REASIGNADO,
       PRODUCTO_ID_REASIGNADO,
       OBSERVACION,
       ES_COMPRA,
       COMPROBANTE_EGRESO,
       FE_CREACION,
       ESTADO,
       CANTIDAD_DESPACHADA,
       ANULAR,
       FE_ULT_MOD,
       USR_CREACION,
       USR_ULT_MOD,
       IP_CREACION,
       PEDIDO_ID,
       PEDIDO_USO_ID,
       ES_DESCUENTO_ROL,
       USR_APROBACION_ID,
       USR_APROBACION,
       ES_APROBACION,
       PEDIDO_APROBACION_ID,
       PEDIDO_PLANTILLA_ID,
       ES_RECURRENTE,
       SERVICIO_ID,
       NO_PROVEEDOR,
       CEDULA_PROVEEDOR,
       NOMBRE_PROVEEDOR,
       GENERA_IMPUESTO,
       DEVOLUCION,
       CANTIDAD_A_DEVOLVER,
       CANTIDAD_DEVUELTA,
       PLACA,
       LUGAR_DESTINO,
       NOMBRE_DESTINO,
       ES_CONSUMIBLE)
    VALUES
      (Pn_IdPedidoDetalle,
       Pn_CantidadSolicitada,
       Pv_DescripcionSolicitada,
       Pv_UsrAsignadoId,
       Pv_UsrAsignado,
       Pn_CaracteristicaId,
       Pv_ProductoEmpresaId,
       Pv_ProductoId,
       Pv_Descripcion,
       Pn_Cantidad,
       Pn_CostoProducto,
       Pn_Subtotal,
       Pn_ProductoEmpresaIdReasignado,
       Pv_ProductoIdReasignado,
       Pv_Obervacion,
       Pv_EsCompra,
       Pv_ComprobanteEgreso,
       Pd_FeCreacion,
       Pv_Estado,
       Pn_CantidadDespachada,
       Pv_Anular,
       Pd_FeUltMod,
       Pv_UsrCreacion,
       Pv_UsrUltMod,
       Pv_IpCreacion,
       Pn_PedidoId,
       Pv_PedidoUsoId,
       Pv_EsDescuentoRol,
       Pv_UsrAprobacionId,
       Pv_UsrAprobacion,
       Pv_EsAprobacion,
       Pn_PedidoAprobacionId,
       Pn_PedidoPlantillaId,
       Pv_EsRecurrente,
       Pn_ServicioId,
       Pv_NoProveedor,
       Pv_CedulaProveedor,
       Pv_NombreProveedor,
       Pv_GeneraImpuesto,
       Pv_Devolucion,
       Pn_CantidadADevolver,
       Pn_CantidadDevuelta,
       Pv_Placa,
       Pv_LugarDestino,
       Pv_NombreDestino,
       Pv_EsConsumible);
  
    Pb_Permitido := TRUE;
  
  EXCEPTION
  
    WHEN Lex_Exception THEN
    
      --Cancela la transaccion y crea un codigo de error
      RAISE_APPLICATION_ERROR(-20001,
                              'Error en P_INSERT_INFO_PEDIDO_DETALLE , ' ||
                              SYS_CONTEXT('USERENV', 'HOST') || ' - ' ||
                              DBMS_UTILITY.FORMAT_ERROR_STACK ||
                              ' ERROR_BACKTRACE: ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      Pb_Permitido := FALSE;
    
    --
  
    WHEN OTHERS THEN
    
      --Cancela la transaccion y crea un codigo de error
      RAISE_APPLICATION_ERROR(-20001,
                              'Error en P_INSERT_INFO_PEDIDO_DETALLE , ' ||
                              SYS_CONTEXT('USERENV', 'HOST') || ' - ' ||
                              DBMS_UTILITY.FORMAT_ERROR_STACK ||
                              ' ERROR_BACKTRACE: ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      Pb_Permitido := FALSE;
    
  END P_INSERT_INFO_PEDIDO_DETALLE;
  --

  FUNCTION F_GET_ADMI_EMPRESA(Pv_Codigo IN VARCHAR2, Pv_Estado IN VARCHAR2)
  
   RETURN DB_COMPRAS.ADMI_EMPRESA%ROWTYPE IS
    --
    CURSOR C_GET_ADMI_EMPRESA(Pv_Codigo VARCHAR2, Pv_Estado VARCHAR2) IS
      SELECT *
        FROM DB_COMPRAS.ADMI_EMPRESA
       WHERE ESTADO = Pv_Estado
         AND CODIGO = Pv_Codigo;
    --
    Lr_Empresa C_GET_ADMI_EMPRESA%ROWTYPE := NULL;
    --
  
  BEGIN
  
    --
    IF C_GET_ADMI_EMPRESA%ISOPEN THEN
      CLOSE C_GET_ADMI_EMPRESA;
    END IF;
  
    OPEN C_GET_ADMI_EMPRESA(Pv_Codigo, Pv_Estado);
    FETCH C_GET_ADMI_EMPRESA
      INTO Lr_Empresa;
    CLOSE C_GET_ADMI_EMPRESA;
  
    RETURN Lr_Empresa;
    --
  EXCEPTION
    WHEN OTHERS THEN
      --Cancela la transaccion y crea un codigo de error
      RAISE_APPLICATION_ERROR(-20001,
                              'Error al buscar en C_GET_ADMI_EMPRESA' ||
                              DBMS_UTILITY.FORMAT_ERROR_STACK ||
                              ' ERROR_BACKTRACE: ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      --
  END F_GET_ADMI_EMPRESA;
  --

  FUNCTION F_GET_ADMI_DEPARTAMENTO(Pv_NoCia        IN VARCHAR2,
                                   Pv_Codigo       IN VARCHAR2,
                                   Pv_Estado       IN VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2)
  
   RETURN DB_COMPRAS.ADMI_DEPARTAMENTO%ROWTYPE IS
    --
  
    CURSOR C_GET_ADMI_DEPARTAMENTO(Pv_NoCia  VARCHAR2,
                                   Pv_Codigo VARCHAR2,
                                   Pv_Estado VARCHAR2) IS
    
      SELECT *
        FROM DB_COMPRAS.ADMI_DEPARTAMENTO
       WHERE EMPRESA_ID = Pv_NoCia
         AND DPTO_COD = Pv_Codigo
         AND ESTADO = Pv_Estado;
  
    --
    Lr_Departamento C_GET_ADMI_DEPARTAMENTO%ROWTYPE := NULL;
    --
  
  BEGIN
    --
    IF C_GET_ADMI_DEPARTAMENTO%ISOPEN THEN
      CLOSE C_GET_ADMI_DEPARTAMENTO;
    END IF;
    OPEN C_GET_ADMI_DEPARTAMENTO(Pv_NoCia, Pv_Codigo, Pv_Estado);
    FETCH C_GET_ADMI_DEPARTAMENTO
      INTO Lr_Departamento;
    CLOSE C_GET_ADMI_DEPARTAMENTO;
  
    RETURN Lr_Departamento;
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Registro no existe';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION.F_GET_ADMI_DEPARTAMENTO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    
      RAISE_APPLICATION_ERROR(-20001,
                              'Error al buscar en F_GET_ADMI_DEPARTAMENTO' ||
                              DBMS_UTILITY.FORMAT_ERROR_STACK ||
                              ' ERROR_BACKTRACE: ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      --
  END F_GET_ADMI_DEPARTAMENTO;
  --

  FUNCTION F_GET_USUARIO_NAF(Pv_NoCia        IN VARCHAR2,
                             Pv_NoEmple      IN VARCHAR2,
                             Pv_Estado       IN VARCHAR2,
                             Pv_MensajeError OUT VARCHAR2)
    RETURN NAF47_TNET.V_EMPLEADOS_EMPRESAS%ROWTYPE IS
  
    --
  
    CURSOR C_GET_EMPLEADO_NAF(Pv_NoCia   VARCHAR2,
                              Pv_NoEmple VARCHAR2,
                              Pv_Estado  VARCHAR2) IS
    
      SELECT *
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS
       WHERE NO_CIA = Pv_NoCia
         AND NO_EMPLE = Pv_NoEmple
         AND ESTADO = Pv_Estado;
  
    --
    Lr_EmpleadoNaf C_GET_EMPLEADO_NAF%ROWTYPE := NULL;
    --
  
  BEGIN
    --
    IF C_GET_EMPLEADO_NAF%ISOPEN THEN
      CLOSE C_GET_EMPLEADO_NAF;
    END IF;
    OPEN C_GET_EMPLEADO_NAF(Pv_NoCia, Pv_NoEmple, Pv_Estado);
    FETCH C_GET_EMPLEADO_NAF
      INTO Lr_EmpleadoNaf;
    --
    CLOSE C_GET_EMPLEADO_NAF;
    --
    RETURN Lr_EmpleadoNaf;
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Registro no existe';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION.F_GET_USUARIO_NAF',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    
  END F_GET_USUARIO_NAF;
  --

  FUNCTION F_GET_ADMI_PARAMETRO(Pv_EmpresaId    IN VARCHAR2,
                                Pv_Codigo       IN VARCHAR2,
                                Pv_Estado       IN VARCHAR2,
                                Pv_MensajeError OUT VARCHAR2)
    RETURN DB_COMPRAS.ADMI_PARAMETRO%ROWTYPE IS
    --
    CURSOR C_GET_ADMI_PARAMETRO(Pv_EmpresaId VARCHAR2,
                                Pv_Codigo    VARCHAR2,
                                Pv_Estado    VARCHAR2) IS
      SELECT *
        FROM DB_COMPRAS.ADMI_PARAMETRO
       WHERE EMPRESA_ID = Pv_EmpresaId
         AND CODIGO = Pv_Codigo
         AND ESTADO = Pv_Estado;
    --
    Lr_Parametro C_GET_ADMI_PARAMETRO%ROWTYPE := NULL;
    --
  BEGIN
    --
    IF C_GET_ADMI_PARAMETRO%ISOPEN THEN
      CLOSE C_GET_ADMI_PARAMETRO;
    END IF;
    OPEN C_GET_ADMI_PARAMETRO(Pv_EmpresaId, Pv_Codigo, Pv_Estado);
    FETCH C_GET_ADMI_PARAMETRO
      INTO Lr_Parametro;
  
    CLOSE C_GET_ADMI_PARAMETRO;
  
    RETURN Lr_Parametro;
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Registro no existe';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION.F_GET_ADMI_PARAMETRO',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
      --
  END F_GET_ADMI_PARAMETRO;
  --

  PROCEDURE P_PEDIDO_MASIVO_INST ( Pd_FechaInicio  IN DATE,
                                   Pd_FechaFin     IN DATE,
                                   Pv_Empresa      IN VARCHAR2,
                                   Pv_MensajeError OUT VARCHAR2) IS
  
    PED_AUT_USO                    CONSTANT VARCHAR2(11) := 'PED-AUT-USO';
    TAREA_PEDIDO_MASIVO            CONSTANT VARCHAR2(30) := 'TAREA_PEDIDO_MASIVO';
    TIPO_ASIGNADO_PEDIDO_MASIVO    CONSTANT VARCHAR2(30) := 'TIPO_ASIGNADO_PEDIDO_MASIVO';
    DEPARTAMENTO_PEDIDO_MASIVO     CONSTANT VARCHAR2(30) := 'DEPARTAMENTO_PEDIDO_MASIVO';
    UTILIZADO_EN_PEDIDO_MASIVO     CONSTANT VARCHAR2(30) := 'UTILIZADO_EN_PEDIDO_MASIVO';
    ESTADO_PEDIDO_MASIVO           CONSTANT VARCHAR2(30) := 'ESTADO_PEDIDO_MASIVO';
    REMITENTE_CORREO_PEDIDO_MASIVO CONSTANT VARCHAR2(30) := 'REMITENTE_CORREO_PEDIDO_MASIVO';
    BODEGA_SOLICITANTE             CONSTANT VARCHAR2(2) := 'BE';
    PEDIDO_AUTOMATICO              CONSTANT VARCHAR2(17) := 'Pedido Autom�tico';
    PLANTILLA_ARTICULO_DEPTO       CONSTANT VARCHAR2(24) := 'PLANTILLA-ARTICULO-DEPTO';
    --Consulta las tareas
    CURSOR C_CONSULTA_TAREA_TELCOS IS
      SELECT IER.EMPRESA_COD AS EMPLEADO_EMPRESA_ID,
             IDTA.PERSONA_EMPRESA_ROL_ID AS LIDER_PERSONA_ROL_ID,
             IPER.PERSONA_ID AS LIDER_PERSONA_ID,
             IDTA.REF_ASIGNADO_NOMBRE,
             ATR.DESCRIPCION_TIPO_ROL,
             IPJC.LOGIN AS LOGIN_LIDER,
             CT.PERSONA_ID TECNICO_PERSONA_ID,
             IPT.LOGIN AS LOGIN_TECNICO,
             IDT.TAREA_ID,
             IDT.TIPO_ZONA,
             CD.ID_CUADRILLA,
             CD.ZONA_ID,
             ADT.NOMBRE_TAREA,
             ICO.EMPRESA_COD
        FROM DB_GENERAL.ADMI_TIPO_ROL ATR,
             DB_GENERAL.ADMI_ROL AR,
             DB_COMERCIAL.INFO_EMPRESA_ROL IER,
             DB_COMERCIAL.INFO_PERSONA IPJC,
             DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,
             DB_SOPORTE.INFO_DETALLE IDT,
             DB_SOPORTE.INFO_DETALLE_ASIGNACION IDTA,
             DB_SOPORTE.ADMI_CUADRILLA CD,
             DB_COMERCIAL.INFO_PERSONA IPT,
             DB_SOPORTE.INFO_CUADRILLA_TAREA CT,
             DB_SOPORTE.ADMI_TAREA ADT,
             DB_COMUNICACION.INFO_COMUNICACION ICO,
             DB_GENERAL.ADMI_ZONA ZON
       WHERE ICO.EMPRESA_COD = Pv_Empresa
       AND IDTA.FE_CREACION >= Pd_FechaInicio
       AND IDTA.FE_CREACION <= Pd_FechaFin
       AND EXISTS( SELECT NULL
                   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                        DB_GENERAL.ADMI_PARAMETRO_CAB APC
                   WHERE APD.VALOR1 = TO_CHAR(IDT.TAREA_ID)
                   AND APD.DESCRIPCION = TAREA_PEDIDO_MASIVO
                   AND APD.EMPRESA_COD = ICO.EMPRESA_COD
                   AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
                   AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                   AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                   )
       AND EXISTS (SELECT NULL
                   FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                        DB_GENERAL.ADMI_PARAMETRO_CAB APC
                   WHERE APD.VALOR1 = IDTA.TIPO_ASIGNADO
                   AND APD.DESCRIPCION = TIPO_ASIGNADO_PEDIDO_MASIVO
                   AND APD.EMPRESA_COD = ICO.EMPRESA_COD
                   AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
                   AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                   AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
                   )
       AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
       AND IER.ROL_ID = AR.ID_ROL
       AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
       AND IPER.PERSONA_ID = IPJC.ID_PERSONA
       AND IDTA.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
       AND IDT.ID_DETALLE = IDTA.DETALLE_ID
       AND IDT.ID_DETALLE = CT.DETALLE_ID
       AND CT.PERSONA_ID = IPT.ID_PERSONA
       AND CD.ID_CUADRILLA = CT.CUADRILLA_ID
       AND IDT.TAREA_ID = ADT.ID_TAREA
       AND IDTA.DETALLE_ID = ICO.DETALLE_ID
       AND CD.ZONA_ID = ZON.ID_ZONA
       GROUP BY IER.EMPRESA_COD,
                IDTA.PERSONA_EMPRESA_ROL_ID,
                IPER.PERSONA_ID,
                ATR.DESCRIPCION_TIPO_ROL,
                IDTA.REF_ASIGNADO_NOMBRE,
                CT.PERSONA_ID,
                IPT.LOGIN,
                IPJC.LOGIN,
                IDT.TAREA_ID,
                IDT.TIPO_ZONA,
                CD.ID_CUADRILLA,
                CD.ZONA_ID,
                ADT.NOMBRE_TAREA,
                IDT.TAREA_ID,
                ICO.EMPRESA_COD
       ORDER BY IDTA.PERSONA_EMPRESA_ROL_ID DESC;
  
    --Verificar el id_persona del lider/tecnico IdPersonaRol
    CURSOR C_DATOS_CUSTODIO ( Cn_PersonaId NUMBER,
                              Cv_TipoRol   VARCHAR2,
                              Cv_Estado    VARCHAR2,
                              Cv_EmpresaId VARCHAR2) IS
      SELECT IPER.ID_PERSONA_ROL,
             IPER.DEPARTAMENTO_ID,
             IPER.EMPRESA_ROL_ID,
             IER.EMPRESA_COD,
             (SELECT APD.VALOR1
              FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                   DB_GENERAL.ADMI_PARAMETRO_CAB APC
              WHERE APD.VALOR1 = TO_CHAR(IPER.DEPARTAMENTO_ID)
              AND APD.DESCRIPCION = DEPARTAMENTO_PEDIDO_MASIVO
              AND APD.EMPRESA_COD = IER.EMPRESA_COD
              AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
              AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
              AND APD.ESTADO = GEK_VAR.Gr_Estado.ACTIVO) AS DEPTO_INSTALACION_ID
      FROM DB_GENERAL.ADMI_TIPO_ROL ATR,
           DB_GENERAL.ADMI_ROL AR,
           DB_COMERCIAL.INFO_PERSONA IP,
           DB_COMERCIAL.INFO_EMPRESA_ROL IER,
           DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
      WHERE IP.ID_PERSONA = Cn_PersonaId
      AND IER.EMPRESA_COD = Cv_EmpresaId
      AND IPER.ESTADO = Cv_Estado
      AND ATR.DESCRIPCION_TIPO_ROL = Cv_TipoRol
      AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL
      AND IER.ROL_ID = AR.ID_ROL
      AND IPER.EMPRESA_ROL_ID = IER.ID_EMPRESA_ROL
      AND IPER.PERSONA_ID = IP.ID_PERSONA;

    --Consulta login del Lider
    CURSOR C_DATOS_EMPLEADO_NAF(Cv_Login     VARCHAR2,
                                Cv_EmpresaId VARCHAR2) IS
      SELECT LE.NO_CIA,
             LE.NO_EMPLE,
             LE.LOGIN,
             ME.DEPTO,
             ME.ID_JEFE
      FROM NAF47_TNET.ARPLME ME,
           NAF47_TNET.LOGIN_EMPLEADO LE
      WHERE LE.LOGIN = Cv_Login
      AND LE.NO_CIA = Cv_EmpresaId
      AND LE.NO_EMPLE = ME.NO_EMPLE
      AND LE.NO_CIA = ME.NO_CIA;

    --Consulta si el lider se encuentra configurado en NAF
    CURSOR C_LEE_BODEGA_EMPLEADO ( Cv_IdEmpleado VARCHAR2,
                                   Cv_Empresa    VARCHAR2) IS
      SELECT APE.ID_PERFIL_EMPLEADO
        FROM NAF47_TNET.ARIN_PERFIL AP,
             NAF47_TNET.ARIN_PERFIL_EMPLEADO APE
       WHERE APE.ID_EMPLEADO = Cv_IdEmpleado
         AND APE.EMPRESA_EMPLEADO_ID = Cv_Empresa
         AND APE.ESTADO = NAF47_TNET.GEK_VAR.Gr_EstadoNAF.ACTIVO
         AND AP.CLASE = BODEGA_SOLICITANTE
         AND APE.PERFIL_ID = AP.ID_PERFIL;
  
    --Consulta datos de plantilla materiales, equipos y fibra
    CURSOR C_DatosPlantilla IS
      SELECT TM.MATERIAL_COD,
             AR.DESCRIPCION,
             TM.CANTIDAD_MATERIAL,
             AR.PACK AS CANTIDAD_EMPAQUE,
             TM.CANTIDAD_DIAS,
             TM.CANTIDAD_INSTALACIONES,
             TM.VALOR_MINIMO,
             AR.TIPO_ARTICULO,
             TM.EMPRESA_COD,
             AR.COSTO_UNITARIO,
             AR.ES_RECURRENTE,
             AR.IND_CONSUMIBLE,
             AR.IND_ACTIVO AS ESTADO,
             CASE AR.APLICA_IMPUESTO
               WHEN 'G' THEN 'S'
               WHEN 'E' THEN 'N'
               ELSE'N'
             END AS APLICA_IMPUESTO
        FROM DB_SOPORTE.ADMI_TAREA_MATERIAL TM, 
             NAF47_TNET.ARINDA AR
       WHERE TM.MATERIAL_COD = AR.NO_ARTI 
       AND TM.EMPRESA_COD = AR.NO_CIA
       AND TM.ESTADO = GEK_VAR.Gr_Estado.ACTIVO 
       AND EXISTS ( SELECT NULL
                    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                         DB_GENERAL.ADMI_PARAMETRO_CAB APC
                    WHERE APD.VALOR1 = TM.UTILIZADO_EN
                    AND APD.DESCRIPCION = UTILIZADO_EN_PEDIDO_MASIVO
                    AND APD.EMPRESA_COD = TM.EMPRESA_COD
                    AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
                    AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                    AND APD.ESTADO = GEK_VAR.Gr_Estado.ACTIVO) 
       AND EXISTS ( SELECT NULL
                    FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
                         DB_GENERAL.ADMI_PARAMETRO_CAB APC
                    WHERE APD.VALOR1 = TM.PEDIDO_MASIVO
                    AND APD.DESCRIPCION = ESTADO_PEDIDO_MASIVO
                    AND APD.EMPRESA_COD = TM.EMPRESA_COD
                    AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
                    AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
                    AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO);
  
    --Consulta Datos en ARAF_CONTROL_CUSTODIO 
    CURSOR C_DATOS_CONTROL_CUSTODIO( Cv_PersonaId VARCHAR2,
                                     Cv_ArticuloId       VARCHAR2) IS
      SELECT ACC.CUSTODIO_ID,
             ACC.NO_ARTICULO,
             SUM(ACC.CANTIDAD) AS CANTIDAD
      FROM NAF47_TNET.ARAF_CONTROL_CUSTODIO ACC
      WHERE ACC.CUSTODIO_ID = Cv_PersonaId
      AND ACC.NO_ARTICULO = Cv_ArticuloId
      AND ACC.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ASIGNADO
      AND ACC.CANTIDAD != 0
      GROUP BY ACC.CUSTODIO_ID,
               ACC.NO_ARTICULO; 
    
    --Consulta Par�metro de Estado          
    CURSOR C_PARAMETROS( Pv_CodEmpresa VARCHAR2,
                         Cv_PedAutEstadoInicial VARCHAR2,
                         Cv_PedAutTipoProceso   VARCHAR2,
                         Cv_PedAutNotificacion  VARCHAR2,
                         Cv_PedAutEstadoFinal   VARCHAR2) IS
      SELECT A.PEDIDO_USO,
             B.ESTADO_INICIAL_PEDIDO,
             C.TIPO_PROCESO,
             D.FLAG_NOTIFICACION,
             E.ESTADO_INICIAL_AUTOMATICO
        FROM (SELECT PAR.VALOR AS PEDIDO_USO, EMP.CODIGO
                FROM DB_COMPRAS.ADMI_PARAMETRO PAR
                LEFT JOIN DB_COMPRAS.ADMI_EMPRESA EMP
                  ON EMP.ID_EMPRESA = PAR.EMPRESA_ID
               WHERE PAR.CODIGO = PED_AUT_USO
                 AND EMP.CODIGO = Pv_CodEmpresa
                 AND PAR.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO) A
        LEFT JOIN (SELECT PAR.VALOR AS ESTADO_INICIAL_PEDIDO, EMP.CODIGO
                     FROM DB_COMPRAS.ADMI_PARAMETRO PAR
                     LEFT JOIN DB_COMPRAS.ADMI_EMPRESA EMP
                       ON EMP.ID_EMPRESA = PAR.EMPRESA_ID
                    WHERE PAR.CODIGO = Cv_PedAutEstadoInicial--'PED-AUT-ESTADO-INICIAL'
                      AND EMP.CODIGO = Pv_CodEmpresa
                      AND PAR.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO) B
          ON B.CODIGO = A.CODIGO
        LEFT JOIN (SELECT PAR.VALOR AS TIPO_PROCESO, EMP.CODIGO
                     FROM DB_COMPRAS.ADMI_PARAMETRO PAR
                     LEFT JOIN DB_COMPRAS.ADMI_EMPRESA EMP
                       ON EMP.ID_EMPRESA = PAR.EMPRESA_ID
                    WHERE PAR.CODIGO = Cv_PedAutTipoProceso--'PED-AUT-TIPO-PROCESO'
                      AND EMP.CODIGO = Pv_CodEmpresa
                      AND PAR.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO) C
          ON C.CODIGO = B.CODIGO
        LEFT JOIN (SELECT PAR.VALOR AS FLAG_NOTIFICACION, EMP.CODIGO
                     FROM DB_COMPRAS.ADMI_PARAMETRO PAR
                     LEFT JOIN DB_COMPRAS.ADMI_EMPRESA EMP
                       ON EMP.ID_EMPRESA = PAR.EMPRESA_ID
                    WHERE PAR.CODIGO = Cv_PedAutNotificacion--'PED-AUT-NOTIFICACION'
                      AND EMP.CODIGO = Pv_CodEmpresa
                      AND PAR.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO) D
          ON D.CODIGO = C.CODIGO
        LEFT JOIN (SELECT PAR.VALOR AS ESTADO_INICIAL_AUTOMATICO, EMP.CODIGO
                     FROM DB_COMPRAS.ADMI_PARAMETRO PAR
                     LEFT JOIN DB_COMPRAS.ADMI_EMPRESA EMP
                       ON EMP.ID_EMPRESA = PAR.EMPRESA_ID
                    WHERE PAR.CODIGO = Cv_PedAutEstadoFinal--'PED-AUT-ESTADO-FINAL'
                      AND EMP.CODIGO = Pv_CodEmpresa
                      AND PAR.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO) E
          ON D.CODIGO = C.CODIGO;
  
    --CONSULTA DE PEDIDOS AUTOMATICOS CREADOS CON ESTADO AUTORIZADO
    CURSOR C_VERIFICA_PEDIDO_MASIVO( Cv_ProductoId   VARCHAR2,
                                     Cv_LoginTecnico VARCHAR2) IS
      SELECT A.ID_PEDIDO, 
             B.USR_ASIGNADO
      FROM DB_COMPRAS.INFO_PEDIDO A, 
           DB_COMPRAS.INFO_PEDIDO_DETALLE B
      WHERE B.ESTADO IN ('Autorizado','Recomendado','DespachoParcial','PorComprar','PorBorrar') --= NAF47_TNET.GEK_VAR.Gr_Estado.AUTORIZADO-- 'Autorizado'
      AND A.TIPO_PROCESO = NAF47_TNET.GEK_VAR.Gr_Estado.AUTOMATICO -- 'Automatico'
      AND B.USR_ASIGNADO = Cv_LoginTecnico
      AND B.PRODUCTO_ID = Cv_ProductoId
      AND A.ID_PEDIDO = B.PEDIDO_ID;

    --Notificacion por Correo pedidos gener ados
    CURSOR C_CONSULTA_PEDIDO IS
      SELECT A.ID_PEDIDO,
             USR_CREACION,
             NOMBRE_USR_CREACION,
             OBSERVACION,
             B.MAIL_CIA
        FROM NAF47_TNET.V_PEDIDOS A, 
             DB_COMPRAS.V_EMPLEADOS_EMPRESAS B
       WHERE A.USR_CREACION = B.LOGIN_EMPLE
         AND A.ID_EMPRESA = B.NO_CIA
         AND A.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.AUTORIZADO
         AND A.OBSERVACION = PEDIDO_AUTOMATICO
         AND B.ESTADO = NAF47_TNET.GEK_VAR.Gr_EstadoNAF.ACTIVO
         AND FE_CREACION >= Pd_FechaFin;
  
    --Notificacion por Correo detalle de pedidos generados
    CURSOR C_ConsultaDetallePedido(Cn_Pedido NUMBER) IS
      SELECT NOMBRE_USR_ASIGNADO,
             PRODUCTO_ID,
             DESCRIPCION_AUTORIZADA,
             CANTIDAD_AUTORIZADA
        FROM NAF47_TNET.V_DETALLE_PEDIDOS A
       WHERE PEDIDO_ID = Cn_Pedido;
  
    --Correo remitente para el env�o de notificaci�n
    CURSOR C_RemitenteCorreo(Cn_Empresa VARCHAR2) IS
      SELECT APD.VALOR1
        FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
             DB_GENERAL.ADMI_PARAMETRO_CAB APC
       WHERE APD.DESCRIPCION = REMITENTE_CORREO_PEDIDO_MASIVO
         AND APD.EMPRESA_COD = Cn_Empresa
         AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
         AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
         AND APD.ESTADO = GEK_VAR.Gr_Estado.ACTIVO;
    --
    CURSOR C_DEPTO_PRODUCTO ( Cv_EmpresaProductoId VARCHAR2,
                              Cv_ProductoId        VARCHAR2) IS
      SELECT APD.ID_PARAMETRO_DET,
             TO_NUMBER(APD.VALOR2) AS DEPARTAMENTO_ID
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD,
           DB_GENERAL.ADMI_PARAMETRO_CAB APC
      WHERE APD.VALOR1 = Cv_ProductoId
      AND APD.DESCRIPCION = PLANTILLA_ARTICULO_DEPTO
      AND APD.EMPRESA_COD = Cv_EmpresaProductoId
      AND APD.PARAMETRO_ID = APC.ID_PARAMETRO
      AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS
      AND APD.ESTADO = GEK_VAR.Gr_Estado.ACTIVO;
    --
    Lr_ConsultaTarea       C_CONSULTA_TAREA_TELCOS%ROWTYPE;
    Lr_DatosCustodio       C_DATOS_CUSTODIO%ROWTYPE;
    Lr_DatosNafLider       C_DATOS_EMPLEADO_NAF%ROWTYPE;
    Lr_BodegaEmpleado      C_LEE_BODEGA_EMPLEADO%ROWTYPE;
    Lr_DatosNafTecnico     C_DATOS_EMPLEADO_NAF%ROWTYPE;
    Lr_ControlCustodio     C_DATOS_CONTROL_CUSTODIO%ROWTYPE;
    Lr_DatosPlantilla      C_DATOSPLANTILLA%ROWTYPE;
    Lr_DetallePedido       C_ConsultaDetallePedido%ROWTYPE;
    Lr_InfoPedido          DB_COMPRAS.INFO_PEDIDO%ROWTYPE;
    Lr_Empresa             DB_COMPRAS.ADMI_EMPRESA%ROWTYPE := NULL;
    Lr_DepartamentoCompras DB_COMPRAS.ADMI_DEPARTAMENTO%ROWTYPE := NULL;
    Lr_Parametros          C_PARAMETROS%rowtype := NULL;
    Lr_DataUsuarioJefe     NAF47_TNET.V_EMPLEADOS_EMPRESAS%ROWTYPE := NULL;
    Lr_DatosPedidoMasivo   C_VERIFICA_PEDIDO_MASIVO%ROWTYPE;
    Lr_DeptoProducto       C_DEPTO_PRODUCTO%ROWTYPE;
    --
    Ln_Cantidad_Material NUMBER := 0;
    Ln_Subtotal          NUMBER := 0;
    Lv_NombreArchivo     VARCHAR2(50) := NULL;
    Lv_Directorio        VARCHAR2(50) := 'NAF_DIR';
    Lv_Remitente         VARCHAR2(100);
    Lv_Destinatario      VARCHAR2(100) := NULL;
    Lv_Asunto            VARCHAR2(3000) := '';
    Lv_Cuerpo            CLOB := NULL;
    LvRuta               UTL_FILE.FILE_TYPE;
    LvLinea              VARCHAR2(2000);
    --
    Ln_Contador    Number;
    Lb_Flag        Boolean;
    Lb_DeptoValido BOOLEAN;
    LrLogPedido    NAF47_TNET.LOG_ERROR_PEDIDOS_AUT%ROWTYPE;
    --
    Le_Error          Exception;
    Le_ErrorTarea     Exception;
    Le_ErrorPlantilla Exception;
    --
  BEGIN
    -- inicializaci�n de variables
    Ln_Contador     := 0;
    Pv_MensajeError := null;
    --
    -- cursor que recupera tareas de instalaciones generadas a los t�cnicos 
    FOR Lr_ConsultaTarea IN C_CONSULTA_TAREA_TELCOS  LOOP
      --
      BEGIN
        --
        Lr_BodegaEmpleado := null;
        Lr_InfoPedido.Id_Pedido := 0;
        --
        -- se valida datos del jefe cuadrilla en NAF
        IF C_DATOS_EMPLEADO_NAF%ISOPEN THEN
          CLOSE C_DATOS_EMPLEADO_NAF;
        END IF;
        OPEN C_DATOS_EMPLEADO_NAF(Lr_ConsultaTarea.Login_Lider,
                                  Lr_ConsultaTarea.Empleado_Empresa_Id);
        FETCH C_DATOS_EMPLEADO_NAF INTO Lr_DatosNafLider;
        CLOSE C_DATOS_EMPLEADO_NAF;
        --
        IF Lr_DatosNafLider.No_Emple IS NULL THEN
          Pv_MensajeError := 'No se pudo recuperar datos de empleado en NAF para Jefe Cuadrilla '||Lr_ConsultaTarea.Login_Lider||' empresa '||Lr_ConsultaTarea.Empleado_Empresa_Id;
          Raise Le_ErrorTarea;
        END IF;
        --
        -- se verifica configuraci�n de jefe cuadrilla en pedidos de Instalaciones (Bodega-Solicitante)
        IF C_LEE_BODEGA_EMPLEADO%ISOPEN THEN
          CLOSE C_LEE_BODEGA_EMPLEADO;
        END IF;
        OPEN C_LEE_BODEGA_EMPLEADO( Lr_DatosNafLider.No_Emple,
                                    Lr_DatosNafLider.No_Cia);
        FETCH C_LEE_BODEGA_EMPLEADO INTO Lr_BodegaEmpleado;
        CLOSE C_LEE_BODEGA_EMPLEADO;
      
        IF Lr_BodegaEmpleado.Id_Perfil_Empleado IS NULL THEN
          Pv_MensajeError := 'Jefe cuadrilla '||Lr_ConsultaTarea.Login_Lider||' no se encuentra parametrizado como empleado asociado a bodega para solicitar pedidos, favor revisar!!!';
          raise Le_ErrorTarea;
        END IF;
        --
        -- se recupera datos de T�nicos en NAF
        IF C_DATOS_EMPLEADO_NAF%ISOPEN THEN
          CLOSE C_DATOS_EMPLEADO_NAF;
        END IF;
        OPEN C_DATOS_EMPLEADO_NAF(Lr_ConsultaTarea.Login_Tecnico,
                                  Lr_ConsultaTarea.Empleado_Empresa_Id);
        FETCH C_DATOS_EMPLEADO_NAF INTO Lr_DatosNafTecnico;
        CLOSE C_DATOS_EMPLEADO_NAF;
        --
        IF Lr_DatosNafTecnico.No_Emple IS NULL THEN
          Pv_MensajeError := 'No se pudo recuperar datos de empleado en NAF para T�cnico '||Lr_ConsultaTarea.Login_Tecnico||' empresa '||Lr_ConsultaTarea.Empleado_Empresa_Id;
          Raise Le_ErrorTarea;
        END IF;
        --
        -- Se obtiene persona empresa rol de tecnico para realizar busquedas en control custodio.
        IF C_DATOS_CUSTODIO%ISOPEN THEN
          CLOSE C_DATOS_CUSTODIO;
        END IF;
        --
        OPEN C_DATOS_CUSTODIO(Lr_ConsultaTarea.Tecnico_Persona_Id,
                              Lr_ConsultaTarea.Descripcion_Tipo_Rol,
                              'Activo',
                              Lr_ConsultaTarea.Empleado_Empresa_Id);
        FETCH C_DATOS_CUSTODIO INTO Lr_DatosCustodio;
        CLOSE C_DATOS_CUSTODIO;
        --
        IF Lr_DatosCustodio.Depto_Instalacion_Id IS NULL THEN
          Pv_MensajeError := 'T�cnico '||Lr_ConsultaTarea.Login_Tecnico||' se encuentra asignado al departamento '||Lr_DatosCustodio.Departamento_Id||', el cual no esta configurado como departamento de instalaci�n.';
          Raise Le_ErrorTarea;
        END IF;
        --
        -- se recuperan parametros para env�o de correo electr�nico
        IF NOT C_PARAMETROS%ISOPEN THEN
          OPEN C_PARAMETROS( Lr_ConsultaTarea.Empleado_Empresa_Id,
                             'PED-AUT-ESTADO-INICIAL',
                             'PED-AUT-TIPO-PROCESO',
                             'PED-AUT-NOTIFICACION',
                             'PED-AUT-ESTADO-FINAL');                             
          FETCH C_PARAMETROS INTO Lr_Parametros;
          CLOSE C_PARAMETROS;
        END IF;
      
        -- Buscamos datos del jefe del usuario asignado por departamento
        Lr_DataUsuarioJefe := INKG_TRANSACCIONES_PEDIDOS.F_GET_USUARIO_NAF(Lr_ConsultaTarea.Empleado_Empresa_Id,-- Lr_Empresa.Codigo,
                                                                           Lr_DatosNafLider.Id_Jefe,--Lr_DatosLider.Id_Jefe,
                                                                           NAF47_TNET.GEK_VAR.Gr_EstadoNAF.ACTIVO,-- Lv_estado,
                                                                           Pv_MensajeError);
        --
        -- cursor que recupera datos de las plantillas de art�culos
        FOR Lr_DatosPlantilla IN C_DatosPlantilla LOOP
          --
          BEGIN  
            --
            Lr_ControlCustodio.No_Articulo := NULL;
            Lr_DatosPedidoMasivo := NULL;
            --
            -- se valida que no exista configuracion departamento-producto
            Lb_DeptoValido := FALSE;
            Lr_DeptoProducto := NULL;
            IF C_DEPTO_PRODUCTO%ISOPEN THEN
              CLOSE C_DEPTO_PRODUCTO;
            END IF;
            OPEN C_DEPTO_PRODUCTO (Lr_DatosPlantilla.Empresa_Cod,
                                   Lr_DatosPlantilla.Material_Cod);
            FETCH C_DEPTO_PRODUCTO INTO Lr_DeptoProducto;
            -- si existe configuraci�n articulo-Depto se valida que este cofigurado el departamento al que pertenece el tecnico
            IF Lr_DeptoProducto.Id_Parametro_Det IS NOT NULL THEN
              LOOP
                --
                Lb_DeptoValido := (NVL(Lr_DeptoProducto.DEPARTAMENTO_ID,0) = Lr_DatosCustodio.Departamento_Id);
                -- 
                EXIT WHEN C_DEPTO_PRODUCTO%NOTFOUND OR Lb_DeptoValido;
                FETCH C_DEPTO_PRODUCTO INTO Lr_DeptoProducto;
              END LOOP;
              --
              -- producto configurado por depto si no cumple no se genera pedido
              IF NOT Lb_DeptoValido THEN
                CLOSE C_DEPTO_PRODUCTO;
                Pv_MensajeError := 'El producto '||Lr_DatosPlantilla.Material_Cod||' no se encuentra configurado para el departamento '||
                                   Lr_DatosCustodio.Departamento_Id||', no es posible generar pedido.';
                RAISE Le_ErrorPlantilla;
              END IF;
              --
            END IF;
            --
            CLOSE C_DEPTO_PRODUCTO;
            
            -- se valida que no exista un pedido automatico vigente para solicitante y articulo.
            IF C_VERIFICA_PEDIDO_MASIVO%ISOPEN THEN
              CLOSE C_VERIFICA_PEDIDO_MASIVO;
            END IF;
            OPEN C_VERIFICA_PEDIDO_MASIVO( Lr_DatosPlantilla.Material_Cod,--Lr_DatosNafLider.Login_Emple,
                                           Lr_ConsultaTarea.Login_Tecnico);-- LrLoginTecnico1.Login_Emple);
            FETCH C_VERIFICA_PEDIDO_MASIVO INTO Lr_DatosPedidoMasivo;
            CLOSE C_VERIFICA_PEDIDO_MASIVO;
            --      
            IF Lr_DatosPedidoMasivo.ID_PEDIDO IS NOT NULL THEN
              Pv_MensajeError := 'El T�cnico '|| Lr_ConsultaTarea.Login_Tecnico ||' tiene pedido en curso ' ||Lr_DatosPedidoMasivo.ID_PEDIDO||' para el art�culo '||Lr_DatosPlantilla.Material_Cod;
              Raise Le_ErrorPlantilla;
            END IF;
            --
            

            -- se recupera la cantidad de articulos asignados al t�cnico para validar las cantidades con plantilla
            OPEN C_DATOS_CONTROL_CUSTODIO(Lr_DatosCustodio.Id_Persona_Rol,
                                          Lr_DatosPlantilla.MATERIAL_COD);
            FETCH C_DATOS_CONTROL_CUSTODIO INTO Lr_ControlCustodio;
            CLOSE C_DATOS_CONTROL_CUSTODIO;
            --
            -- se realiza la conversi�n pues los pedidos se generan en base unidades de inventarios
            Ln_Cantidad_Material := (Lr_DatosPlantilla.CANTIDAD_MATERIAL/NVL(Lr_DatosPlantilla.Cantidad_Empaque,1));
          
            Ln_Subtotal := Ln_Cantidad_Material * Lr_DatosPlantilla.COSTO_UNITARIO;
            --
            ------------------------------------------------------------------------
            -- Si cabecera de pedido no ha sdo generado a�n, se procede a generar --
            ------------------------------------------------------------------------
            IF (Lr_ControlCustodio.No_Articulo IS NULL OR 
                Lr_ControlCustodio.CANTIDAD <= Lr_DatosPlantilla.VALOR_MINIMO) AND 
                Lr_InfoPedido.Id_Pedido = 0 THEN
              --
              Lr_Empresa := INKG_TRANSACCIONES_PEDIDOS.F_GET_ADMI_EMPRESA( Lr_ConsultaTarea.Empleado_Empresa_Id, --Lr_DatosLider.No_Cia,
                                                                           NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO);-- Lv_EstadoActivo);
              --
              Lr_DepartamentoCompras := INKG_TRANSACCIONES_PEDIDOS.F_GET_ADMI_DEPARTAMENTO( Lr_Empresa.Id_Empresa,
                                                                                            Lr_DatosNafLider.Depto,-- Lr_DatosLider.Depto,
                                                                                            NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO, --Lv_EstadoActivo,
                                                                                            Pv_MensajeError);
              --
              IF Pv_MensajeError IS NOT NULL THEN
                RAISE Le_ErrorTarea;
              END IF;
              --
              -- Insertamos la cabecera del pedido
              Lr_InfoPedido.Departamento_Id := Lr_DepartamentoCompras.Id_Departamento;
              Lr_InfoPedido.Usr_Creacion := Lr_ConsultaTarea.Login_Lider;
              Lr_InfoPedido.Observacion := 'Pedido Autom�tico';
              Lr_InfoPedido.valor_total := 0;
              Lr_InfoPedido.monto_total_aprobacion := 0;
              Lr_InfoPedido.monto_inicial_aprobacion := 0;
              Lr_InfoPedido.saldo_aprobacion := 0;
              Lr_InfoPedido.valor_descontado := 0;
              Lr_InfoPedido.usr_jefe_id := Lr_DataUsuarioJefe.no_emple;
              Lr_InfoPedido.usr_jefe := Lr_DataUsuarioJefe.LOGIN_EMPLE;
              Lr_InfoPedido.nombres_jefe := Lr_DataUsuarioJefe.Nombre;
              Lr_InfoPedido.estado := Lr_Parametros.ESTADO_INICIAL_AUTOMATICO;
              Lr_InfoPedido.fe_creacion := SYSDATE;
              Lr_InfoPedido.ip_creacion := '127.0.0.1';
              Lr_InfoPedido.pedido_tipo := 'Ins';
              Lr_InfoPedido.usr_autoriza_id := Lr_DatosNafLider.No_Emple;
              Lr_InfoPedido.usr_asignado_tipo := 'EMP';
              Lr_InfoPedido.usr_creacion_id := Lr_DatosNafLider.No_Emple;
              Lr_InfoPedido.tipo_servicio := 'BI';
              Lr_InfoPedido.descontar_monto_aprobacion := 'N';
              Lr_InfoPedido.monto_por_aprobar := 0;                                                
              Lr_InfoPedido.aplicativo_referencia := 'Telcos';
              Lr_InfoPedido.tipo_proceso := 'Automatico';
              --
              Lr_InfoPedido.Id_Pedido := DB_COMPRAS.SEQ_INFO_PEDIDO.NEXTVAL;
              Ln_Contador := Ln_Contador + 1;
              --
              INKG_TRANSACCIONES_PEDIDOS.P_INSERT_INFO_PEDIDO( Lr_InfoPedido,
                                                               Pv_MensajeError);
              IF Pv_MensajeError IS NOT NULL THEN
                RAISE Le_ErrorTarea;
              END IF;
              --
            END IF;
            --
            -- se recupera datos de empresa de producto
            Lr_Empresa := INKG_TRANSACCIONES_PEDIDOS.F_GET_ADMI_EMPRESA( Lr_DatosPlantilla.Empresa_Cod, --Lr_DatosLider.No_Cia,
                                                                         NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO);-- Lv_EstadoActivo);
            --
            --Si L�der de cuadrilla no tiene asignado el c�digo de material genera un pedido
            IF (Lr_ControlCustodio.No_Articulo IS NULL OR 
                Lr_ControlCustodio.CANTIDAD <= Lr_DatosPlantilla.VALOR_MINIMO) THEN
              --
              INKG_TRANSACCIONES_PEDIDOS.P_INSERT_INFO_PEDIDO_DETALLE(DB_COMPRAS.SEQ_INFO_PEDIDO_DETALLE.NEXTVAL,
                                                                      Ln_Cantidad_Material,
                                                                      Lr_DatosPlantilla.DESCRIPCION,
                                                                      Lr_DatosNafTecnico.No_Emple,
                                                                      Lr_DatosNafTecnico.Login,
                                                                      0,
                                                                      Lr_Empresa.Id_Empresa,
                                                                      Lr_DatosPlantilla.MATERIAL_COD,
                                                                      Lr_DatosPlantilla.DESCRIPCION,
                                                                      Ln_Cantidad_Material,
                                                                      Lr_DatosPlantilla.COSTO_UNITARIO,
                                                                      Ln_Subtotal,
                                                                      0,
                                                                      NULL,
                                                                      Lr_InfoPedido.Observacion,
                                                                      'N',
                                                                      NULL,
                                                                      SYSDATE,
                                                                      'Autorizado',
                                                                      0,
                                                                      NULL,
                                                                      NULL,
                                                                      Lr_DatosNafLider.Login,
                                                                      NULL,
                                                                      '127.0.0.1',
                                                                      Lr_InfoPedido.Id_Pedido,
                                                                      '12',
                                                                      'N',
                                                                      NULL,
                                                                      NULL,
                                                                      NULL,
                                                                      NULL,
                                                                      NULL,
                                                                      Lr_DatosPlantilla.ES_RECURRENTE,
                                                                      NULL,
                                                                      NULL,
                                                                      NULL,
                                                                      NULL,
                                                                      Lr_DatosPlantilla.APLICA_IMPUESTO,
                                                                      'N',
                                                                      0,
                                                                      0,
                                                                      NULL,
                                                                      'CLI',
                                                                      NULL,
                                                                      Lr_DatosPlantilla.IND_CONSUMIBLE,
                                                                      Lb_Flag);
            
            END IF;
            --
          EXCEPTION
            WHEN Le_ErrorPlantilla THEN
              LrLogPedido.ID_PEDIDO      := Lr_InfoPedido.Id_Pedido;
              LrLogPedido.LOGIN_LIDER    := Lr_DatosNafLider.Login;
              LrLogPedido.OBSERVACION    := Pv_MensajeError;
              LrLogPedido.Login_Tecnico  := Lr_ConsultaTarea.Login_Tecnico;
              LrLogPedido.ID_PERSONA_ROL := Lr_ConsultaTarea.Lider_Persona_Rol_Id;
              --
              INKG_TRANSACCIONES_PEDIDOS.P_LOG_ERROR_PEDIDOS_AUT(Pr_log_pedido => LrLogPedido);
              --
              Pv_MensajeError := null;
          END;
          --
        END LOOP;
      
      EXCEPTION
        WHEN Le_ErrorTarea THEN
          LrLogPedido.ID_PEDIDO      := Lr_InfoPedido.Id_Pedido;
          LrLogPedido.LOGIN_LIDER    := Lr_DatosNafLider.Login;
          LrLogPedido.OBSERVACION    := Pv_MensajeError;
          LrLogPedido.ID_PERSONA_ROL := Lr_ConsultaTarea.Lider_Persona_Rol_Id;
          --
          INKG_TRANSACCIONES_PEDIDOS.P_LOG_ERROR_PEDIDOS_AUT(Pr_log_pedido => LrLogPedido);
          --
          Pv_MensajeError := null;
          --
      END;
    END LOOP;
    --
    COMMIT;
    --
    -- si se gener� alg�n pedido se procede a enviar notificaciones de correo.  
    IF Ln_Contador >= 1 THEN
      FOR Lr_Pedido in C_CONSULTA_PEDIDO LOOP
      
        IF Lr_Pedido.Mail_Cia IS NOT NULL THEN
          Lv_Destinatario := Lr_Pedido.Mail_Cia || ',';
        END IF;
      
        Lv_Cuerpo := '<html>
              <head>
                <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
              </head>

              <body>
                <table align="center" width="100%" cellspacing="0" cellpadding="5">
                  <tr>
                    <td style="border:1px solid #6699CC;">
                      <table width="100%" cellspacing="0" cellpadding="5">
                        <tr>
                          <td colspan="2">
                            <p>
                              <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                              Estimado(a), <strong>' ||
                     InitCap('LIDER ' ||
                             Lr_Pedido.Nombre_Usr_Creacion) ||
                     '</strong>.</br></br>
                             Se ha generado el pedido No. <b> ' ||
                     Lr_Pedido.Id_Pedido || '</b>  correspondiente al reabastecimiento de Stock para instalaciones.</br></br>                          
                             </p>

                             <p>
                                
                                <span style="font-size:14px;">
                                  <span style="font-family:arial,helvetica,sans-serif;">
                                    Atentamente
                                  </span>
                                </span>
                             </p>
        
                            <p>
                              <span style="font-size:14px;">
                                <span style="font-family:arial,helvetica,sans-serif;">Sistema NAF
                                </span>
                              </span>
                            </p>
                          </td>
                        </tr>
                      </table>
                     </td>
                   </tr>
                 </table>
                </body>
               </html>';
      
        Lv_NombreArchivo := 'PEDIDO ' || sysdate || '.CSV';
        Lv_Asunto        := 'Reabastecimiento de Stock para instalaciones.';
        LvRuta           := UTL_FILE.FOPEN(Lv_Directorio,
                                           Lv_NombreArchivo,
                                           'w');
      
        LvLinea := 'USUARIO ASIGNADO|CODIGO MATERIAL|DESCRIPCION|CANTIDAD';
      
        utl_file.put_line(LvRuta, LvLinea);
      
        FOR Lr_DetallePedido in C_ConsultaDetallePedido(Lr_Pedido.Id_Pedido) LOOP
          LvLinea := Lr_DetallePedido.Nombre_Usr_Asignado || '|' ||
                     Lr_DetallePedido.Producto_Id || '|' ||
                     Lr_DetallePedido.Descripcion_Autorizada || '|' ||
                     Lr_DetallePedido.Cantidad_Autorizada;
        
          utl_file.put_line(LvRuta, LvLinea);
        
        END LOOP;
        UTL_FILE.FCLOSE(LvRuta);
      
        OPEN C_RemitenteCorreo(Lr_ConsultaTarea.Empleado_Empresa_Id);
        FETCH C_RemitenteCorreo INTO Lv_Remitente;
        CLOSE C_RemitenteCorreo;
        
        BEGIN
          DB_GENERAL.GNRLPCK_UTIL.send_email_attach(Lv_Remitente,
                                                    Lv_Destinatario,
                                                    Lv_Asunto,
                                                    Lv_Cuerpo,
                                                    Lv_Directorio,
                                                    Lv_NombreArchivo);
        EXCEPTION
          WHEN OTHERS THEN
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                                 'NAF47_TNET.INKG_TRANSACCION.P_PEDIDO_MASIVO_INST',
                                                 'Error en proceso envio correos notificaci�n. '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                 GEK_CONSULTA.F_RECUPERA_LOGIN,
                                                 SYSDATE,
                                                 GEK_CONSULTA.F_RECUPERA_IP);
            
            
        END;
      END LOOP;
    END IF;
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      Pv_MensajeError := 'INKG_TRANSACCIONES_PEDIDOS.P_PEDIDO_MASIVO_INST. ' ||Pv_MensajeError;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION.P_PEDIDO_MASIVO_INST',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION.P_PEDIDO_MASIVO_INST',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    
  END P_PEDIDO_MASIVO_INST;
  --

  PROCEDURE P_EJECUTAR_JOB IS
    --
    HORA_PROCESO_PEDIDO_MASIVO CONSTANT VARCHAR2(26) := 'HORA-PROCESO-PEDIDO-MASIVO';
    --
    CURSOR C_PEDIDO_MASIVO IS
      SELECT APD.EMPRESA_COD,
             APD.ID_PARAMETRO_DET,
             TO_DATE(APD.VALOR1,'DD/MM/YYYY') AS DIA_PROCESO,
             TO_DATE(APD.VALOR1||' '||APD.VALOR3, 'DD/MM/YYYY HH24:MI:SS') - (15/24/60) AS HORA_INI_EJECUCION,
             TO_DATE(APD.VALOR1||' '||APD.VALOR3, 'DD/MM/YYYY HH24:MI:SS') + (15/24/60) AS HORA_FIN_EJECUCION,
             TO_DATE(APD.VALOR1||' '||APD.VALOR2, 'DD/MM/YYYY HH24:MI:SS') AS FECHA_INI_PROCESAR,
             TO_DATE(APD.VALOR1||' '||APD.VALOR3, 'DD/MM/YYYY HH24:MI:SS') AS FECHA_FIN_PROCESAR,
             TO_DATE(NVL(APD.VALOR4,TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')),'DD/MM/YYYY HH24:MI:SS') AS HORA_ULT_EJECUCION
      FROM DB_GENERAL.ADMI_PARAMETRO_DET APD
      WHERE APD.DESCRIPCION = HORA_PROCESO_PEDIDO_MASIVO
      AND APD.ESTADO = NAF47_TNET.GEK_VAR.Gr_Estado.ACTIVO
      AND EXISTS (SELECT NULL
                  FROM DB_GENERAL.ADMI_PARAMETRO_CAB APC
                  WHERE APC.ID_PARAMETRO = APD.PARAMETRO_ID
                  AND APC.NOMBRE_PARAMETRO = PARAMETROS_INVENTARIOS);
    --
    Lv_FechaProceso DATE := SYSDATE;
    Pv_MensajeError VARCHAR2(3000);
    Le_Error EXCEPTION;
    --
  
  BEGIN
    --
    FOR Lr_Parametro IN C_PEDIDO_MASIVO LOOP
      --
      IF Lv_FechaProceso >= Lr_Parametro.Hora_Ini_Ejecucion AND 
        Lv_FechaProceso <= Lr_Parametro.Hora_Fin_Ejecucion THEN
        --
        INKG_TRANSACCIONES_PEDIDOS.P_PEDIDO_MASIVO_INST ( Lr_Parametro.Fecha_Ini_Procesar,
                                                          Lr_Parametro.Fecha_Fin_Procesar,
                                                          Lr_Parametro.Empresa_Cod,
                                                          Pv_MensajeError);
  
        IF Pv_MensajeError IS NOT NULL THEN
          Raise Le_Error;
        END IF;
        --
        UPDATE DB_GENERAL.ADMI_PARAMETRO_DET APD
        SET VALOR1 = TRIM(TO_CHAR((Lr_Parametro.Dia_Proceso+1),'DD/MM/YYYY')),
            VALOR4 = TRIM(TO_CHAR(Lv_FechaProceso,'DD/MM/YYYY HH24:MI:SS'))
        WHERE APD.ID_PARAMETRO_DET = Lr_Parametro.Id_Parametro_Det;
        --
      END IF;
      --
    END LOOP;
  
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      Pv_MensajeError := Pv_MensajeError;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION.P_EJECUTAR_JOB',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION.P_EJECUTAR_JOB',
                                           Pv_MensajeError,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    
  END P_EJECUTAR_JOB;
  --

  PROCEDURE P_LOG_ERROR_PEDIDOS_AUT(Pr_log_pedido NAF47_TNET.LOG_ERROR_PEDIDOS_AUT%ROWTYPE) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    Le_Error Exception;
    Lv_mensaje_error VARCHAR2(100);
    ----
  BEGIN
    INSERT INTO NAF47_TNET.LOG_ERROR_PEDIDOS_AUT
      (ID_LOG_PEDIDO,
       ID_PEDIDO,
       LOGIN_LIDER,
       LOGIN_TECNICO,
       OBSERVACION,
       FECHA_CREACION,
       ID_PERSONA_ROL)
    VALUES
      (NAF47_TNET.SEQ_LOG_PEDIDO_AUT.NEXTVAL,
       Pr_log_pedido.Id_Pedido,
       Pr_log_pedido.Login_Lider,
       Pr_log_pedido.Login_Tecnico,
       Pr_log_pedido.observacion,
       sysdate,
       Pr_log_pedido.id_persona_rol);
    COMMIT;
  EXCEPTION
    WHEN Le_Error THEN
      Lv_mensaje_error := 'Registro no insertado';
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.INKG_TRANSACCION.P_LOG_ERROR_PEDIDOS_AUT',
                                           Lv_mensaje_error,
                                           GEK_CONSULTA.F_RECUPERA_LOGIN,
                                           SYSDATE,
                                           GEK_CONSULTA.F_RECUPERA_IP);
    
  END P_LOG_ERROR_PEDIDOS_AUT;

END INKG_TRANSACCIONES_PEDIDOS;
/

