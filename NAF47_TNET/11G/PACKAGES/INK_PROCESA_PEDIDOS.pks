CREATE OR REPLACE package            INK_PROCESA_PEDIDOS is

/**
* Documentacion para NAF47_TNET.INK_PROCESA_PEDIDOS
* Paquete que contiene procesos y funciones para generar procesar los despachos del sistema de pedidos
* @author llindao <llindao@telconet.ec>
* @version 1.0 20/07/2016
*
* @author llindao <llindao@telconet.ec>
* @version 1.1 12/06/2017 Se modifica para eliminar funcion F_RECUPERA_IP porque fue implemenetado en GEK_CONSULTA
*                         Se modifica para agregar procedimiento P_REGISTRA_ESTADO_PEDIDO que registra los estados de pedidos
*
* @author llindao <llindao@telconet.ec>
* @version 1.2 22/09/2017 Se modifica agregar procedimiento P_DESPACHO_PEDIDO que tendra la programacion que se encontraba en la forma PINV233
*                         (Despacho Pedidos) y asi mejorar tiempo de respuesta de proceso despacho pues todo se ejecutara en la base de Datos.
*/

/**
* Documentacion para NAF47_TNET.INK_PROCESA_PEDIDOS.Gr_ArticuloPedido
* Variable Registro que permite pasar por parametro los datos necesarios para procesar despachos de pedidos
* @author llindao <llindao@telconet.ec>
* @version 1.0 22/09/2016
*/
  TYPE Gr_ArticuloPedido is RECORD
     ( ID_PEDIDO_DETALLE       DB_COMPRAS.INFO_PEDIDO_DETALLE.ID_PEDIDO_DETALLE%TYPE,
       PEDIDO_ID               DB_COMPRAS.INFO_PEDIDO_DETALLE.PEDIDO_ID%TYPE,
       PRODUCTO_ID             NAF47_TNET.ARINDA.NO_ARTI%TYPE,
       MANEJA_SERIE            NAF47_TNET.ARINDA.IND_REQUIERE_SERIE%TYPE,
       CANTIDAD                DB_COMPRAS.INFO_PEDIDO_DETALLE.CANTIDAD%TYPE,
       CANTIDAD_DESPACHADA     DB_COMPRAS.INFO_PEDIDO_DETALLE.CANTIDAD_DESPACHADA%TYPE,
       ESTADO_PEDIDO           DB_COMPRAS.INFO_PEDIDO.ESTADO%TYPE,
       TIPO_CONSUMO            NAF47_TNET.ARINTIPOCONSUMOINTER.CODIGO%TYPE,
       TIPO_DOCUMENTO          NAF47_TNET.ARINVTM.TIPO_M%TYPE,
       ID_BODEGA               NAF47_TNET.ARINBO.CODIGO%TYPE,
       OBSERVACION             NAF47_TNET.ARINME.OBSERV1%TYPE,
       ID_CENTRO               NAF47_TNET.ARINCD.CENTRO%TYPE,
       ID_EMPRESA              NAF47_TNET.ARINCD.NO_CIA%TYPE,
       ACCION                  VARCHAR2(100),
       DETALLE_ERROR           VARCHAR2(3000),
       ID_PEDIDO_COMPRA        DB_COMPRAS.INFO_SOLICITUD.ID_SOLICITUD%TYPE,
       USR_ASIGNADO_ID         DB_COMPRAS.INFO_PEDIDO_DETALLE.USR_ASIGNADO_ID%TYPE,
       USR_ASIGNADO            DB_COMPRAS.INFO_PEDIDO_DETALLE.USR_ASIGNADO%TYPE
       );

/**
* Documentacion para NAF47_TNET.INK_PROCESA_PEDIDOS.Gt_Procesa_Pedido
* Variable Tipo Tabla que permite pasar por parametro detalle de articulos para procesar despachos de pedidos
* @author llindao <llindao@telconet.ec>
* @version 1.0 22/09/2016
*/
  TYPE Gt_Procesa_Pedido IS TABLE of Gr_ArticuloPedido;


    /**
  * Documentacion para P_INSERTA_ARINME
  * Procedure que inserta registro en ARINME
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 20/07/2016
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 22/10/2016  Se publica y modifica procedure para que pueda ser usado en el proceso de Ingreso a Bodega por Devoluciones
  *
  * @param Pr_Arinme       IN ARINME%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINME ( Pr_Arinme       IN     NAF47_TNET.ARINME%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_INSERTA_ARINML
  * Procedure que inserta registro en ARINML
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 20/07/2016
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 22/10/2016  Se publica y modifica procedure para que pueda ser usado en el proceso de Ingreso a Bodega por Devoluciones
  *
  * @param Pr_Arinml       IN ARINML%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINML ( Pr_Arinml       IN     NAF47_TNET.ARINML%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2);
  --

  /**
  * Documentacion para P_ACTUALIZA_DOCUMENTOS
  * Procedure que actualiza los documentos despachos bodegas relacionados a un pedido
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 20/07/2016
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 10/01/2017 Se modifica para validar la fecha de proceso antes de actualizar los despachos.
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 22/05/2017 Se modifica agregar proceso que genera informacion de activos fijos en repositorio.
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 12/06/2017 Se modifica quitar actualizacion de estado de pedido porque ahora lo realiza el procedimiento 
  *                         P_REGISTRA_ESTADO_PEDIDO invocado desde la pantalla despacho de pedidos.
  *
  * @param Pv_IdPedido     IN VARCHAR2 Recibe numero de pedido
  * @param Pv_Centro       IN VARCHAR2 Recibe codigo centro distribucion
  * @param Pv_NoCia        IN VARCHAR2 Recibe codigo de compania
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_ACTUALIZA_DOCUMENTOS ( Pv_IdPedido     IN     VARCHAR2,
                                     Pv_Centro       IN     VARCHAR2,
                                     Pv_NoCia        IN     VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_PROCESA_DESPACHO
  * Procedure que genera los despachos a bodegas del pedido que se procesa
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 20/07/2016
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 23/07/2018 - Se modifica para considerar nuevo campo cantidad numero serie para validar el total de series ingresadas
  *
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.2 14/06/2019 - Se modifica para devolver la Orden de Egreso
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.3 17/06/2019 - Se modifica busqueda de Centro de costo cuando se despacha a contratistas de otras empresas.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.4 17/08/2020 - Se corrige cierre de cursor C_CCOSTO_RESP_EXT pues emite error Cursor Invalido.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.5 30/07/2021 - Se modifica para considerar nuevos campos de numeros de series (cantidad_segmento, serie_original)
  *
  * @param Pn_IdDetPedido  IN NUMBER Recibe numero de detalle de pedido
  * @param Pn_Cantidad     IN NUMBER recibe cantidad a despachar
  * @param Pv_TipoConsumo  IN VARCHAR2 recibe tipo de gasto cuando se realiza despacho consumo
  * @param Pv_TipoDoc      IN VARCHAR2 recibe tipo de dcumento despacho a generar
  * @param Pv_Bodega       IN VARCHAR2 recibe codigo de bodega donde se va a descargar los articulos
  * @param Pv_Observacion  IN VARCHAR2  recibe las observaciones para registrar en documento despacho bodega
  * @param Pv_Centro       IN VARCHAR2 Recibe codigo centro distribucion
  * @param Pv_NoCia        IN VARCHAR2 Recibe codigo de compania
  * @param Pv_OrdenEgreso  IN OUT VARCHAR2 Orden Egreso.
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_PROCESA_DESPACHO ( Pn_IdDetPedido  IN     NUMBER,
                                 Pn_Cantidad     IN     NUMBER,
                                 Pv_TipoConsumo  IN     VARCHAR2,
                                 Pv_TipoDoc      IN     VARCHAR2,
                                 Pv_Bodega       IN     VARCHAR2,
                                 Pv_Observacion  IN     VARCHAR2,
                                 Pv_Centro       IN     VARCHAR2,
                                 Pv_NoCia        IN     VARCHAR2,
                                 Pv_OrdenEgreso  IN OUT VARCHAR2,
                                 Pv_MensajeError IN OUT VARCHAR2);

  /**
  * Documentacion para P_REASIGNAR_PRODUCTO
  * Procedure que cambia registro detalle de pedido para ser reasignado (Recomendado)
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 20/07/2016
  *
  * @param Pn_IdDetPedido  IN NUMBER Recibe numero de detalle de pedido
  * @param Pv_NoCia        IN VARCHAR2 Recibe codigo de compania
  * @param Pv_Observacion  IN VARCHAR2  recibe las observaciones para registrar en documento despacho bodega
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_REASIGNAR_PRODUCTO ( Pn_IdDetPedido  IN     NUMBER,
                                   Pv_NoCia        IN     VARCHAR2,
                                   Pv_Observacion  IN     VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2);



  /**
  * Documentacion para P_REGISTRA_ESTADO_PEDIDO
  * Procedure que registra los cambios de estados del pedido desde inventarios
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 19/04/2017
  *
  * @param Pv_Estado       IN VARCHAR2 Recibe estado de Pedido
  * @param Pn_IdPedido     IN VARCHAR2 Recibe numero de Pedido
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_REGISTRA_ESTADO_PEDIDO ( Pv_Estado       IN     VARCHAR2, 
                                       Pn_IdPedido     IN     NUMBER,
                                       Pv_MensajeError IN OUT VARCHAR2);


  /**
  * Documentacion para P_DESPACHO_PEDIDO
  * Procedure procesa despacho de pedidos, recomendaciones de articulos y solicita la eliminacion de articulos.
  *   Este proceso antes era ejecutado desde la forma PINV233.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 22/09/2017
  * 
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 23/07/2018 - Se modifica para considerar nuevo campo cantidad numero serie para validar el total de series ingresadas
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 23/07/2018 - Se modifica considerar articulos que manejen mas de una unidad por numero de serie NO contemplen estado DespachoParcial
  *
  * @author llindao <banton@telconet.ec>
  * @version 1.3 25/05/2021 - Se agrega bandera para inactivar llamado de procedimiento COK_ORDEN_COMPRA_PEDIDO.P_GENERA_PEDIDO_COMPRA_BIENES
  *
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.4 27/06/2021 - Se procede a agrgar los cursores que leen el login y de reserva en el procedimiento 
  *
  * @author banton <banton@telconet.ec>
  * @version 1.5 07/07/2022 - Se valida si se cambia de usuario asignado para pedidos por login 
  *
  * @param Pr_ProcesarPedido IN OUT ARRAY    Recibe registros de articulos a procesar
  * @param Pv_MensajeError   IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_DESPACHO_PEDIDO ( Pr_ProcesarPedido IN OUT NAF47_TNET.INK_PROCESA_PEDIDOS.Gt_Procesa_Pedido,
                              Pv_MensajeError   IN OUT VARCHAR2,
                              Pn_IdLog          IN OUT NUMBER);

  /**
  * Documentacion para P_REGISTRA_TIEMPOS_PEDIDO
  * Procedure que registra los tiempos que demora un pedido en la tabla log_pedidos
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 13/06/2019
  * 
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.1 15/07/2019 - Se agrega validacion para tiempos excedentes a 99 horas, registrar nuevo estado ExcedeTiempoDespacho
  *
  * @param Pn_IdPedido              IN NUMBER   Recibe numero de Pedido
  * @param Pv_ComprobanteEgreso     IN VARCHAR2 Recibe  Comprobante
  * @param Pv_Proceso               IN VARCHAR2 Recibe tipo  de Proceso
  * @param Pv_Estado                IN VARCHAR2 Recibe Estado
  * @param Pv_IpCreacion            IN VARCHAR2 Recibe IP del usuario
  * @param Pv_UsuarioDespacho      IN VARCHAR2 Recibe usuario
  * @param Pv_IdDetalles            IN VARCHAR2 Recibe los IDs de los detalles del pedido.
  * @param Pv_MensajeError          IN OUT VARCHAR2 Retorna mensaje error.
  * @param Pn_IdLog                 IN OUT NUMBER Retorna Id de la tabla Log pedidos.
  */

  PROCEDURE P_REGISTRA_TIEMPOS_PEDIDO(Pn_IdPedido          IN NUMBER,
                                      Pv_ComprobanteEgreso IN VARCHAR2,
                                      Pv_Proceso           IN VARCHAR2,
                                      Pv_Estado            IN VARCHAR2,
                                      Pv_IpCreacion        IN VARCHAR2,
                                      Pv_UsuarioDespacho   IN VARCHAR2,
                                      Pv_IdDetalles        IN VARCHAR2,
                                      Pv_MensajeError      IN OUT VARCHAR2,
                                      Pn_IdLog             IN OUT NUMBER);

  /**
  * Documentacion para P_ACTALIZA_TIEMPOS_PEDIDO
  * Procedure que actualiza los tiempos de un pedido en la tabla tiempos_pedidos
  * @author Katherine Yager <kyager@telconet.ec>
  * @version 1.0 25/06/2019
  *
  * @param Pn_IdLog                 IN OUT NUMBER Retorna Id de la tabla Log pedidos.
  */

  PROCEDURE P_ACTUALIZA_TIEMPOS_PEDIDO(Pn_IdLog        IN NUMBER,
                                      Pv_MensajeError      IN OUT VARCHAR2);
  
  --

  --

end INK_PROCESA_PEDIDOS;
/


CREATE OR REPLACE package body            INK_PROCESA_PEDIDOS is

  -- Cursor que recupera los datos del registro a insertar en la tabla principal de inventarios.
  CURSOR C_PEDIDO (Cn_IdDetPedido NUMBER) IS
    SELECT A.PEDIDO_ID,
           A.ID_PEDIDO_DETALLE,
           B.USR_JEFE_ID,
           B.ID_EMPRESA,
           A.PRODUCTO_ID,
           A.DESCRIPCION_AUTORIZADA,
           A.CANTIDAD_AUTORIZADA,
           A.CANTIDAD_DESPACHADA,
           A.USR_ASIGNADO_ID
      FROM NAF47_TNET.V_DETALLE_PEDIDOS A,
           NAF47_TNET.V_PEDIDOS B
     WHERE A.PEDIDO_ID = B.ID_PEDIDO
       AND A.ID_PEDIDO_DETALLE = Cn_IdDetPedido;

  -- Verifica si ya existe despacho asociado al Pedido, solicitante y responsable
  CURSOR C_VERIFICA_PEDIDO (Cn_IdPedido      NUMBER,
                            Cv_IdResponsable VARCHAR2,
                            Cv_IdSolicitante VARCHAR2,
                            Cv_NoCia         VARCHAR2) IS
    SELECT A.NO_CIA,
           A.CENTRO,
           A.TIPO_DOC,
           A.PERIODO,
           A.RUTA,
           A.NO_DOCU,
           A.ID_BODEGA,
           A.TIPO_CAMBIO,
           A.C_COSTO_EMPLESOL
      FROM NAF47_TNET.ARINME A
     WHERE A.NO_PEDIDO = Cn_IdPedido
       AND A.EMPLE_SOLIC = Cv_IdResponsable
       AND A.EMPLEADO_SOLICITANTE = Cv_IdSolicitante
       AND A.ESTADO = 'P'
       AND A.NO_CIA = Cv_NoCia;

  -- recupera los datos del perioso para asignar al despacho --
  CURSOR C_DATOS_PERIODO ( Cv_Centro VARCHAR2,
                           Cv_NoCia  VARCHAR2) IS
    SELECT P.ANO_PROCE,
           P.DIA_PROCESO,
           P.MES_PROCE,
           C.CLASE_CAMBIO
      FROM NAF47_TNET.ARINCD P,
           NAF47_TNET.ARCGMC C
     WHERE P.NO_CIA = C.NO_CIA
       AND P.CENTRO = Cv_Centro
       AND P.NO_CIA = Cv_NoCia;

  -- se recupera centro de costo de responsable
  CURSOR C_CCOSTO_RESP ( Cv_IdResponsable VARCHAR2,
                         Cv_NoCia         VARCHAR2) IS
    SELECT A.CENTRO_COSTO
      FROM NAF47_TNET.ARPLME A
     WHERE A.NO_EMPLE = Cv_IdResponsable
       AND A.NO_CIA = Cv_NoCia
     UNION
    SELECT B.CENTRO_COSTO
      FROM NAF47_TNET.ARINMCNT B
     WHERE B.NO_CONTRATISTA = Cv_IdResponsable
       AND B.NO_CIA = Cv_NoCia;

  -- se recupera centro de costo de responsable externo
  CURSOR C_CCOSTO_RESP_EXT ( Cv_IdResponsable    VARCHAR2,
                             Cv_NoCiaResponsable VARCHAR2,
                             Cv_NoCia            VARCHAR2) IS
    SELECT CE.CENTRO_COSTO
      FROM NAF47_TNET.ARIN_EMPRESA_EXTERNA CE,
           NAF47_TNET.ARPLME E
     WHERE CE.DEPARTAMENTO = E.DEPTO
       AND CE.AREA = E.AREA
       AND CE.NO_CIA_EXTERNA = E.NO_CIA
       AND E.NO_EMPLE = Cv_IdResponsable
       AND E.NO_CIA = Cv_NoCiaResponsable
       AND CE.NO_CIA = Cv_NoCia
       AND CE.ESTADO = 'A'
       AND E.ESTADO = 'A'
     UNION
    SELECT CC.OBJETO_ID CENTRO_COSTO
      FROM NAF47_TNET.ARIN_PARAMETRO_DETALLE CC,
           NAF47_TNET.ARIN_PARAMETRO P,
           NAF47_TNET.ARIN_PARAMETRO_DETALLE CCE,
           NAF47_TNET.ARINMCNT B
     WHERE B.NO_CONTRATISTA = Cv_IdResponsable
       AND B.NO_CIA = Cv_NoCiaResponsable
       AND CCE.TIPO = 'CE'
       AND CCE.ESTADO = 'A'
       AND P.CLASE = 'CCosto-CCostoExterno'
       AND P.ESTADO = 'A'
       AND CC.TIPO = 'CA'
       AND CC.ESTADO = 'A'
       AND CC.EMPRESA_OBJETO_ID = Cv_NoCia
       AND P.ID_PARAMETRO = CC.PARAMETRO_ID
       AND CCE.PARAMETRO_ID = P.ID_PARAMETRO
       AND CCE.OBJETO_ID = B.CENTRO_COSTO
       AND CCE.EMPRESA_OBJETO_ID = B.NO_CIA;

  -- cursor que recupera secuencia de arinml --
  CURSOR C_SEC_ARINML (Cv_NoDocumento VARCHAR2,
                       Cv_NoCia       VARCHAR2) IS
    SELECT MAX(A.LINEA)
      FROM NAF47_TNET.ARINML A
     WHERE A.NO_DOCU = Cv_NoDocumento
       AND A.NO_CIA = Cv_NoCia;

  -- cursor que recupera los numeros de series del articulo --
  CURSOR C_NUMEROS_SERIES ( Cv_NoArticulo      VARCHAR2,
                           Cn_IdDetallePedido NUMBER,
                           Cn_IdPedido        NUMBER,
                           Cv_NoCia           VARCHAR2) IS
    SELECT A.SERIE, 
           A.MAC, 
           A.UNIDADES,
           A.CANTIDAD_SEGMENTO,
           A.SERIE_ORIGINAL
      FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A,
           NAF47_TNET.INV_NUMERO_SERIE B
     WHERE A.NO_ARTICULO = Cv_NoArticulo
       AND A.LINEA = Cn_IdDetallePedido
       AND A.NO_DOCUMENTO = Cn_IdPedido
       AND A.COMPANIA = Cv_NoCia
       AND A.ORIGEN  = 'PE'
       AND NOT EXISTS (SELECT NULL
                         FROM NAF47_TNET.ARINME B,
                              NAF47_TNET.ARINML C,
                              NAF47_TNET.INV_DOCUMENTO_SERIE D
                        WHERE B.NO_DOCU = C.NO_DOCU
                          AND B.NO_CIA  = C.NO_CIA
                          AND C.LINEA = D.LINEA
                          AND C.NO_DOCU = D.ID_DOCUMENTO
                          AND C.NO_CIA = D.COMPANIA
                          AND D.SERIE = A.SERIE
                          AND B.NO_PEDIDO = A.NO_DOCUMENTO
                          AND B.ESTADO != 'P')
      AND A.SERIE = B.SERIE (+)
      AND A.NO_ARTICULO = B.NO_ARTICULO (+)
      AND A.COMPANIA = B.COMPANIA (+);

  -- parametros de producto --
  CURSOR C_DATOS_ARTICULO ( Cv_IdArticulo VARCHAR2,
                            Cv_IdCompania VARCHAR2) IS
    SELECT NVL(A.IND_REQUIERE_SERIE,'N') Ind_Requiere_Serie, Descripcion
      FROM NAF47_TNET.ARINDA A
     WHERE A.NO_ARTI = Cv_IdArticulo
       AND A.NO_CIA = Cv_IdCompania;


  PROCEDURE P_INSERTA_ARINME ( Pr_Arinme       IN     NAF47_TNET.ARINME%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
    INSERT INTO NAF47_TNET.ARINME
         ( NO_CIA,             CENTRO,               TIPO_DOC,
           TIPO_CAMBIO,        PERIODO,              RUTA,
           NO_DOCU,            ESTADO,               FECHA,
           NO_FISICO,          SERIE_FISICO,         ORIGEN,
           USUARIO,            FECHA_APLICACION,     EMPLE_SOLIC,
           NO_CIA_RESPONSABLE, C_COSTO_EMPLESOL,     OBSERV1,
           ID_BODEGA,          EMPLEADO_SOLICITANTE, NO_CIA_SOLICITANTE,
           NO_PEDIDO,          TIPO_CONSUMO_INTERNO, NO_DEVOLUCIONES)
    VALUES
         ( Pr_Arinme.No_Cia,             Pr_Arinme.Centro,               Pr_Arinme.Tipo_Doc,
           Pr_Arinme.Tipo_Cambio,        Pr_Arinme.Periodo,              Pr_Arinme.Ruta,
           Pr_Arinme.No_Docu,            Pr_Arinme.Estado,               Pr_Arinme.Fecha,
           Pr_Arinme.No_Fisico,          Pr_Arinme.Serie_Fisico,         Pr_Arinme.Origen,
           USER,                         SYSDATE,                        Pr_Arinme.Emple_Solic,
           Pr_Arinme.No_Cia_Responsable, Pr_Arinme.c_Costo_Emplesol,     Pr_Arinme.Observ1,
           Pr_Arinme.Id_Bodega,          Pr_Arinme.Empleado_Solicitante, Pr_Arinme.No_Cia_Solicitante,
           Pr_Arinme.No_Pedido,          Pr_Arinme.Tipo_Consumo_Interno, Pr_Arinme.No_Devoluciones);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_INSERTA_ARINME: '||SQLERRM;
  END P_INSERTA_ARINME;

  PROCEDURE P_INSERTA_ARINML ( Pr_Arinml       IN     NAF47_TNET.ARINML%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2) IS

  BEGIN
     INSERT INTO NAF47_TNET.ARINML
          ( NO_CIA,     CENTRO,      TIPO_DOC,
            PERIODO,    RUTA,        NO_DOCU,
            LINEA,      LINEA_EXT,   BODEGA,
            NO_ARTI,    UNIDADES,    TIPO_CAMBIO,
            MONTO,      MONTO_DOL,   MONTO2,
            MONTO2_DOL, IND_OFERTA,  CENTRO_COSTO )
   VALUES ( Pr_Arinml.No_Cia,             Pr_Arinml.Centro,            Pr_Arinml.Tipo_Doc,
            Pr_Arinml.Periodo,            Pr_Arinml.Ruta,              Pr_Arinml.No_Docu,
            Pr_Arinml.Linea,              Pr_Arinml.Linea_Ext,         Pr_Arinml.Bodega,
            Pr_Arinml.No_Arti,            Pr_Arinml.Unidades,          Pr_Arinml.Tipo_Cambio,
            nvl(Pr_Arinml.Monto ,0),      nvl(Pr_Arinml.Monto_Dol ,0), nvl(Pr_Arinml.Monto2 ,0),
            nvl(Pr_Arinml.Monto2_Dol ,0), Pr_Arinml.Ind_Oferta,        Pr_Arinml.Centro_Costo);

  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_INSERTA_ARINML: '||SQLERRM;
  END P_INSERTA_ARINML;

  /**
  * Documentacion para P_PROCESA_SERIE
  * Procedure que inserta registro en INV_DOCUMENTO_SERIE
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 20/07/2016
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 30/07/2021 - Se modifica para considerar nuevos campos cantidad_segmento, serie_original
  *
  * @param Pr_DocSerie     IN INV_DOCUMENTO_SERIE%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_PROCESA_SERIE ( Pr_DocSerie     IN     NAF47_TNET.INV_DOCUMENTO_SERIE%ROWTYPE,
                              Pv_MensajeError IN OUT VARCHAR2 ) IS
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    INSERT INTO NAF47_TNET.INV_DOCUMENTO_SERIE
         ( COMPANIA,
           ID_DOCUMENTO,
           LINEA,
           SERIE,
           MAC,
           UNIDADES,
           CANTIDAD_SEGMENTO,
           SERIE_ORIGINAL,
           USUARIO_CREA,
           FECHA_CREA )
   VALUES( Pr_DocSerie.compania, 
           Pr_DocSerie.id_documento,
           Pr_DocSerie.linea,
           Pr_DocSerie.serie,
           Pr_DocSerie.Mac,
           Pr_DocSerie.Unidades,
           Pr_DocSerie.Cantidad_Segmento,
           Pr_DocSerie.Serie_Original,
           USER,
           SYSDATE );

    -- se libera numero de serie --
    UPDATE NAF47_TNET.INV_NUMERO_SERIE
       SET ESTADO = 'FB',
           ID_BODEGA = NULL,
           USUARIO_MODIFICA = USER,
           FECHA_MODIFICA = SYSDATE
     WHERE SERIE = Pr_DocSerie.serie
       AND COMPANIA = Pr_DocSerie.compania;

    IF SQL%ROWCOUNT = 0 THEN
      Pv_MensajeError := 'No se entro numero de serie: '||Pr_DocSerie.serie||' en bodega inventario.';
      RAISE Le_Error;
    END IF;

  EXCEPTION
    WHEN Le_Error THEN NULL;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_PROCESA_SERIE: '||SQLERRM;
  END P_PROCESA_SERIE;

  /**
  * Documentacion para P_PROCESA_DETALLE_SERIE
  * Procedure que inserta registro en INFO_PEDIDO_DETALLE_SERIE
  * @author Antonio Ayala <afayala@telconet.ec>
  * @version 1.0 21/05/2019
  *
  * @param Pr_DocSerie     IN INFO_PEDIDO_DETALLE_SERIE%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_PROCESA_DETALLE_SERIE ( Ln_PedidoDetalle  IN NUMBER,
                                      Lv_PedidoSerie    IN VARCHAR2,
                                      Lv_PedidoMac      IN VARCHAR2,
                                      Lv_PedidoEstado   IN VARCHAR2,
                                      Lv_ProductoId     IN VARCHAR2,  
                                      Lv_Descripcion    IN VARCHAR2,  
                                      Pv_MensajeError IN OUT VARCHAR2 ) IS
    --
    Le_Error EXCEPTION;
    --
    Ln_secuencia       number(19):= DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_PEDIDO_DETALLE_SERIE;
    --
  BEGIN
INSERT INTO DB_COMPRAS.INFO_PEDIDO_DETALLE_SERIE (ID_PEDIDO_DETALLE_SERIE,
                                                  PEDIDO_DETALLE_ID,
                                                  SERIE,
                                                  MAC,
                                                  PRODUCTO_ID,
                                                  DESCRIPCION_PRODUCTO,
                                                  ESTADO,
                                                  FE_CREACION,
                                                  USR_CREACION)
     VALUES (Ln_secuencia,
             Ln_PedidoDetalle,
             Lv_PedidoSerie,
             Lv_PedidoMac,
             Lv_ProductoId,
             Lv_Descripcion,
             Lv_PedidoEstado,
             SYSDATE,
             USER);
    IF SQL%ROWCOUNT = 0 THEN
      Pv_MensajeError := 'No se inserto numero de serie: '||Lv_PedidoSerie||' en bodega inventario.';
      RAISE Le_Error;
    END IF;

  EXCEPTION
    WHEN Le_Error THEN NULL;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_PROCESA_DETALLE_SERIE: '||SQLERRM;
  END P_PROCESA_DETALLE_SERIE;

  PROCEDURE P_ACTUALIZA_DOCUMENTOS ( Pv_IdPedido     IN     VARCHAR2,
                                     Pv_Centro       IN     VARCHAR2,
                                     Pv_NoCia        IN     VARCHAR2,
                                     Pv_MensajeError IN OUT VARCHAR2) IS

    -- cursor que recupera los despachos por pedidos a actualziar.
    CURSOR C_DOCUMENTOS_ACTUALIZAR IS
      SELECT A.NO_CIA, A.CENTRO, A.TIPO_DOC, A.NO_DOCU, A.FECHA, B.PEDIDO_TIPO TIPO_PEDIDO
      FROM NAF47_TNET.ARINME A,
        DB_COMPRAS.INFO_PEDIDO B
      WHERE A.NO_PEDIDO = B.ID_PEDIDO
      AND A.NO_PEDIDO = Pv_IdPedido
      AND A.CENTRO = Pv_Centro
      AND A.NO_CIA = Pv_NoCia
      --AND A.USUARIO = USER
      AND A.ESTADO = 'P'
      AND A.ORIGEN  = 'PE';
    --
    -- cursor que recupera el dia proceso del centro de distribucion.
    CURSOR C_DIA_PROCESO IS
      SELECT CD.DIA_PROCESO
      FROM NAF47_TNET.ARINCD CD
      WHERE CD.CENTRO = Pv_Centro
      AND CD.NO_CIA = Pv_NoCia;
    --
    Le_Error      Exception;
    Ld_DiaProceso DATE := NULL;
    --
  BEGIN
    --se recupera dia proceso
    IF C_DIA_PROCESO%ISOPEN THEN
      CLOSE C_DIA_PROCESO;
    END IF;
    --
    OPEN C_DIA_PROCESO;
    FETCH C_DIA_PROCESO INTO Ld_DiaProceso;
    IF C_DIA_PROCESO%NOTFOUND THEN
      Ld_DiaProceso := NULL;
    END IF;
    CLOSE C_DIA_PROCESO;
    --
    IF Ld_DiaProceso IS NULL THEN
      Pv_MensajeError := 'No se pudo determinar dia proceso para centro: '||Pv_Centro||', empresa: '||Pv_NoCia;
      RAISE Le_Error;
    END IF;
    --
    FOR Lr_Doc IN C_DOCUMENTOS_ACTUALIZAR LOOP
      -- se valida que documento despacho generado se enuentre en dia proceso
      -- con esto se evita inconsistencia por cierre diario ejecutado en el mismo momento que se despacha
      -- solicitud de pedidos.
      IF Lr_Doc.Fecha != Ld_DiaProceso THEN
        Pv_MensajeError := 'Fecha proceso ha cambiado a '||to_char(Ld_DiaProceso,'dd/mm/yyyy')||' y no concuerda con fecha documento '||
          to_char(Lr_Doc.Fecha,'dd/mm/yyyy')||', debe volver a intentar el despacho.';
        RAISE Le_Error;
      END IF;
      --
      IF Lr_Doc.Tipo_Pedido = 'Ins' THEN
        -- Carga informacion de equipos a instalar en Repositorio
        NAF47_TNET.AFK_PROCESOS.P_REPOSITORIO_ARTICULOS( Lr_Doc.No_Docu,
                                              Lr_Doc.No_Cia,
                                              'IN',
                                              Pv_MensajeError);

        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      /*ELSE
        -- Carga informacion de Activos Fijos a Repositorio si el tipo de documento despacho es AF
        AFK_PROCESOS.P_REPOSITORIO_ARTICULOS( Lr_Doc.No_Docu,
                                              Lr_Doc.No_Cia,
                                              'AF',
                                              Pv_MensajeError);

        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;*/
      END IF;
      --
      -- proceso que actualiza el movimiento de inventarios.
      NAF47_TNET.INACTUALIZA( Lr_Doc.NO_CIA ,
                   Lr_Doc.TIPO_DOC,
                   Lr_Doc.NO_DOCU,
                   Pv_MensajeError);

      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;

    END LOOP;

  EXCEPTION
    WHEN Le_Error THEN NULL;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_ACTUALIZA_DOCUMENTOS: '||SQLERRM;
  END P_ACTUALIZA_DOCUMENTOS;

  PROCEDURE P_PROCESA_DESPACHO ( Pn_IdDetPedido  IN     NUMBER,
                                 Pn_Cantidad     IN     NUMBER,
                                 Pv_TipoConsumo  IN     VARCHAR2,
                                 Pv_TipoDoc      IN     VARCHAR2,
                                 Pv_Bodega       IN     VARCHAR2,
                                 Pv_Observacion  IN     VARCHAR2,
                                 Pv_Centro       IN     VARCHAR2,
                                 Pv_NoCia        IN     VARCHAR2,
                               Pv_OrdenEgreso  IN OUT VARCHAR2,
                                 Pv_MensajeError IN OUT VARCHAR2) IS

    --
    Lr_Arinme        NAF47_TNET.ARINME%ROWTYPE := NULL;
    Lr_Arinml        NAF47_TNET.ARINML%ROWTYPE := NULL;
    Lr_DocSerie      NAF47_TNET.INV_DOCUMENTO_SERIE%ROWTYPE := NULL;
    Lr_Pedido        C_PEDIDO%ROWTYPE := NULL;
    Lr_PedidoDespach C_PEDIDO%ROWTYPE := NULL;
    Lr_DatosPeriodo  C_DATOS_PERIODO%ROWTYPE := NULL;
    Ld_FechaAux      DATE := NULL;
    Lv_EstDetPedido  DB_COMPRAS.INFO_PEDIDO_DETALLE.ESTADO%TYPE := NULL;
    Lr_DatosArticulo C_DATOS_ARTICULO%ROWTYPE := NULL;
    Ln_CantidadSerie NUMBER := 0;
    Lb_DespachoTotal BOOLEAN := FALSE;
    Ln_PedidoDetalle NUMBER;
    Lv_PedidoSerie   VARCHAR2(100);
    Lv_PedidoMac     VARCHAR2(20);
    Lv_PedidoEstado  VARCHAR2(20);
     --
     
     CURSOR C_LeeLogin(Cn_IdPedido IN NUMBER) IS
     SELECT LOGIN
       FROM DB_COMPRAS.INFO_PEDIDO
      WHERE ID_PEDIDO = Cn_IdPedido;
     Lv_Login        DB_COMPRAS.INFO_PEDIDO.LOGIN%TYPE:=NULL;
       --Consulto de que bodega hizo el prestamo
    CURSOR C_LeeReservaProd(Cv_IdEmpresa   IN VARCHAR2,
                            Cn_IdDetPedido IN NUMBER,
                            Cv_IdProducto  IN VARCHAR2) IS
      SELECT PD.PEDIDO_ID, RP.*
        FROM DB_COMPRAS.INFO_RESERVA_PRODUCTOS RP,
             DB_COMPRAS.INFO_PEDIDO_DETALLE    PD
       WHERE RP.PEDIDO_DETALLE_ID = PD.ID_PEDIDO_DETALLE
         AND RP.PEDIDO_DETALLE_ID = Cn_IdDetPedido
         AND RP.NO_ARTI = Cv_IdProducto
         AND RP.TIPO_MOV = 'I'
         AND RP.DESCRIPCION_MOTIVO = 'IngresoReserva'
         AND RP.NO_CIA = Cv_IdEmpresa;
         
    Lr_RegReservaProductos  DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE:=NULL;
    Lr_ReservaProd       C_LeeReservaProd%ROWTYPE := NULL;
    -- 
    Le_Error   EXCEPTION;
    --
  BEGIN
    
    NAF47_TNET.INK_PROCESA_PEDIDOS.P_PROCESA_DESPACHO@GPOETNET ( Pn_IdDetPedido,
                         Pn_Cantidad,
                         Pv_TipoConsumo,
                         Pv_TipoDoc,
                         Pv_Bodega,
                         Pv_Observacion,
                         Pv_Centro,
                         Pv_NoCia,
                         Pv_OrdenEgreso,
                         Pv_MensajeError);
     if(Pv_MensajeError is not null) then
       raise Le_Error;
     end if;             
     commit; 
     -- Se verifica linea pedido
     /*
    IF C_PEDIDO%ISOPEN THEN CLOSE C_PEDIDO; END IF;
    OPEN C_PEDIDO (Pn_IdDetPedido);
    FETCH C_PEDIDO INTO Lr_Pedido;
    IF C_PEDIDO%NOTFOUND THEN
      Pv_MensajeError := 'No existe Detalle Pedido, favor verifique!!!';
      Raise Le_Error;
    END IF;
    CLOSE C_PEDIDO;

    -- Se verifica si ya existe despacho de pedido
    IF C_VERIFICA_PEDIDO%ISOPEN THEN CLOSE C_VERIFICA_PEDIDO; END IF;
    OPEN C_VERIFICA_PEDIDO ( Lr_Pedido.Pedido_Id,
                             Lr_Pedido.Usr_Asignado_Id,
                             Lr_Pedido.Usr_Jefe_Id,
                             Lr_Pedido.Id_Empresa);
    FETCH C_VERIFICA_PEDIDO INTO Lr_Arinme.No_Cia,
                                 Lr_Arinme.Centro,
                                 Lr_Arinme.Tipo_Doc,
                                 Lr_Arinme.Periodo,
                                 Lr_Arinme.Ruta,
                                 Lr_Arinme.No_Docu,
                                 Lr_Arinme.Id_Bodega,
                                 Lr_Arinme.Tipo_Cambio,
                                 Lr_Arinme.c_Costo_Emplesol;
    IF C_VERIFICA_PEDIDO%NOTFOUND THEN
      Lr_Arinme := NULL;
    END IF;
    CLOSE C_VERIFICA_PEDIDO;

    -- no existe pedido generado, se recopila datos
    IF Lr_Arinme.No_Docu IS NULL THEN

      Lr_Arinme.No_Cia := Pv_NoCia;
      Lr_Arinme.Centro := Pv_Centro;
      Lr_Arinme.Tipo_Doc := Pv_TipoDoc;
      Lr_Arinme.Ruta := '0000';
      Lr_Arinme.Estado := 'P';
      Lr_Arinme.Origen := 'PE';
      Lr_Arinme.Id_Bodega := Pv_Bodega;
      Lr_Arinme.Observ1 := Pv_Observacion;
      Lr_Arinme.Tipo_Consumo_Interno := Pv_TipoConsumo;
      --
      -- se recuperan parametros para asignar a documentos inventarios.
      IF C_DATOS_PERIODO%ISOPEN THEN CLOSE C_DATOS_PERIODO; END IF;
      OPEN C_DATOS_PERIODO (Pv_Centro,
                            Pv_NoCia);
      FETCH C_DATOS_PERIODO INTO Lr_DatosPeriodo;
      IF C_DATOS_PERIODO%NOTFOUND THEN
        Pv_MensajeError := 'La definicion del calendario del inventario es incorrecta.';
        RAISE Le_Error;
      END IF;
      CLOSE C_DATOS_PERIODO;

      -- se busca centro de costo de empleado responsable
      IF C_CCOSTO_RESP%ISOPEN THEN CLOSE C_CCOSTO_RESP; END IF;
      OPEN C_CCOSTO_RESP (Lr_Pedido.Usr_Asignado_Id,
                          Lr_Pedido.Id_Empresa);
      FETCH C_CCOSTO_RESP INTO Lr_Arinme.c_Costo_Emplesol;
      IF C_CCOSTO_RESP%NOTFOUND THEN
        Pv_MensajeError := 'Empleado solicitante no tiene asignado centro de costo, favor verifique con RRHH';
        RAISE Le_Error;
      END IF;
      CLOSE C_CCOSTO_RESP;
      
      IF Lr_Pedido.Id_Empresa = Pv_NoCia THEN
        -- se busca centro de costo de empleado responsable
        IF C_CCOSTO_RESP%ISOPEN THEN CLOSE C_CCOSTO_RESP; END IF;
        OPEN C_CCOSTO_RESP (Lr_Pedido.Usr_Asignado_Id,
                            Lr_Pedido.Id_Empresa);
        FETCH C_CCOSTO_RESP INTO Lr_Arinme.c_Costo_Emplesol;
        IF C_CCOSTO_RESP%NOTFOUND THEN
          Pv_MensajeError := 'Solicitante no tiene asignado centro de costo, favor revisar con RRHH (Empleado) o Bodegas (Contratista)';
          RAISE Le_Error;
        END IF;
        CLOSE C_CCOSTO_RESP;
      ELSE
        -- se busca centro de costo de empleado responsable externo
        IF C_CCOSTO_RESP_EXT%ISOPEN THEN CLOSE C_CCOSTO_RESP_EXT; END IF;
        OPEN C_CCOSTO_RESP_EXT (Lr_Pedido.Usr_Asignado_Id,
                                Lr_Pedido.Id_Empresa,
                                Pv_NoCia);
        FETCH C_CCOSTO_RESP_EXT INTO Lr_Arinme.c_Costo_Emplesol;
        IF C_CCOSTO_RESP_EXT%NOTFOUND THEN
          Pv_MensajeError := 'Solicitante no tiene asignado centro de costo, favor revisar con RRHH (Empleado) o Bodegas (Contratista)';
          RAISE Le_Error;
        END IF;
        CLOSE C_CCOSTO_RESP_EXT;
      END IF;

      Lr_Arinme.Tipo_Cambio := Tipo_Cambio(Lr_DatosPeriodo.Clase_Cambio,
                                           Lr_DatosPeriodo.Dia_Proceso,
                                           Ld_FechaAux,
                                           'C');
      --
      Lr_Arinme.Periodo := Lr_DatosPeriodo.Ano_Proce;
      Lr_Arinme.Fecha := Lr_DatosPeriodo.Dia_Proceso;
      Lr_Arinme.Emple_Solic := Lr_Pedido.Usr_Asignado_Id;
      Lr_Arinme.No_Cia_Responsable := Lr_Pedido.Id_Empresa;
      Lr_Arinme.Empleado_Solicitante := Lr_Pedido.Usr_Jefe_Id;
      Lr_Arinme.No_Cia_Solicitante := Lr_Pedido.Id_Empresa;
      Lr_Arinme.No_Pedido := Lr_Pedido.Pedido_Id;

      Lr_Arinme.No_Docu := Transa_Id.Inv(Lr_Arinme.No_Cia);
      Lr_Arinme.No_Fisico := Consecutivo.INV(Lr_Arinme.No_Cia, Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'NUMERO');
      Lr_Arinme.Serie_Fisico := Consecutivo.INV(Lr_Arinme.No_Cia,  Lr_DatosPeriodo.Ano_Proce, Lr_DatosPeriodo.Mes_Proce, Lr_Arinme.Centro, Lr_Arinme.Tipo_Doc, 'SERIE');

      -- Se inserta registro en cabecera de documentos de inventarios
      NAF47_TNET.INK_PROCESA_PEDIDOS.P_INSERTA_ARINME( Lr_Arinme,
                        Pv_MensajeError);

      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;

    END IF; -- fin NO existe documento inventario generado

    -- se procede a ingresar detalle de inventario
    Lr_Arinml.No_Cia := Lr_Arinme.No_Cia;
    Lr_Arinml.Centro := Lr_Arinme.Centro;
    Lr_Arinml.Tipo_Doc := Lr_Arinme.Tipo_Doc;
    Lr_Arinml.Periodo := Lr_Arinme.Periodo;
    Lr_Arinml.Ruta := Lr_Arinme.Ruta;
    Lr_Arinml.No_Docu := Lr_Arinme.No_Docu;
    Lr_Arinml.Bodega := Lr_Arinme.Id_Bodega;
    Lr_Arinml.No_Arti := Lr_Pedido.Producto_Id;
    Lr_Arinml.Unidades := Pn_Cantidad;
    Lr_Arinml.Tipo_Cambio := Lr_Arinme.Tipo_Cambio;
    Lr_Arinml.Ind_Oferta := 'N';
    Lr_Arinml.Centro_Costo := Lr_Arinme.c_Costo_Emplesol;

    -- se recupera la secuencia correspondiente
    IF C_SEC_ARINML%ISOPEN THEN CLOSE C_SEC_ARINML; END IF;
    OPEN C_SEC_ARINML( Lr_Arinml.No_Docu,
                       Lr_Arinml.No_Cia);
    FETCH C_SEC_ARINML INTO Lr_Arinml.Linea;
    CLOSE C_SEC_ARINML;

    Lr_Arinml.Linea := nvl(Lr_Arinml.Linea,0) + 1;
    Lr_Arinml.Linea_Ext := Lr_Arinml.Linea;

    -- insertar detalle documento inventario --
    NAF47_TNET.INK_PROCESA_PEDIDOS.P_INSERTA_ARINML( Lr_Arinml,
                      Pv_MensajeError);

    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;

    -- Se procesan los numeros de series en caso de existir
    -- se verifica si articulo maneja series
    IF C_DATOS_ARTICULO%ISOPEN THEN CLOSE C_DATOS_ARTICULO; END IF;
    OPEN C_DATOS_ARTICULO(Lr_Arinml.No_Arti, Lr_Arinml.No_Cia);
    FETCH C_DATOS_ARTICULO INTO Lr_DatosArticulo.Ind_Requiere_Serie, Lr_DatosArticulo.Descripcion;
    IF C_DATOS_ARTICULO%NOTFOUND THEN
      Lr_DatosArticulo.Ind_Requiere_Serie := 'N';
    END IF;
    CLOSE C_DATOS_ARTICULO;

    IF Lr_DatosArticulo.Ind_Requiere_Serie = 'S' THEN
      Ln_CantidadSerie := 0;
      FOR Lr_PedSerie IN C_NUMEROS_SERIES ( Lr_Pedido.Producto_Id,
                                            Lr_Pedido.Id_Pedido_Detalle,
                                            Lr_Pedido.Pedido_Id,
                                            Lr_Arinml.No_Cia ) LOOP
        --
        Lr_DocSerie.Compania := Lr_Arinml.No_Cia;
        Lr_DocSerie.Id_Documento := Lr_Arinml.No_Docu;
        Lr_DocSerie.Linea := Lr_Arinml.Linea;
        Lr_DocSerie.Serie := Lr_PedSerie.Serie;
        Lr_DocSerie.Mac := Lr_PedSerie.Mac;
        Lr_DocSerie.Unidades := Lr_PedSerie.Unidades;
        Lr_DocSerie.Cantidad_Segmento := Lr_PedSerie.Cantidad_Segmento;
        Lr_DocSerie.Serie_Original := Lr_PedSerie.Serie_Original;

        -- inserta numeros de series --
        INK_PROCESA_PEDIDOS.P_PROCESA_SERIE ( Lr_DocSerie,
                          Pv_MensajeError);

        Ln_PedidoDetalle  := Lr_Pedido.Id_Pedido_Detalle;
        Lv_PedidoSerie    := Lr_PedSerie.Serie;
        Lv_PedidoMac      := Lr_PedSerie.Mac;
        Lv_PedidoEstado   := 'Despachado';
        
        -- inserta en tabla INFO_PEDIDO_DETALLE_SERIE
        INK_PROCESA_PEDIDOS.P_PROCESA_DETALLE_SERIE ( Ln_PedidoDetalle,
                                  Lv_PedidoSerie,
                                  Lv_PedidoMac,
                                  Lv_PedidoEstado,
                                  Lr_Pedido.Producto_Id,
                                  Lr_DatosArticulo.Descripcion,
                                  Pv_MensajeError);

        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        ELSE
          Ln_CantidadSerie := Ln_CantidadSerie + NVL(Lr_PedSerie.Unidades,1);
          --
          -- si se trata de unidades cntroladas en numero de serie se marca despachado con lo que se despacha
          IF NVL(Lr_PedSerie.Unidades,1) > 1 THEN
            Lb_DespachoTotal := TRUE;
          END IF;
          --
        END IF;
        --
      END LOOP;

      -- se valida que series se encuentren ingresadas
      IF Ln_CantidadSerie = 0 THEN
        Pv_MensajeError := 'No se encuentran ingresados los numeros de series para el articulo ['||Lr_Arinml.No_Arti||']';
        RAISE Le_Error;
      ELSIF nvl(Ln_CantidadSerie,0) != nvl(Lr_Arinml.Unidades,0) THEN
        Pv_MensajeError := 'Total unidades solicitadas ['||nvl(Lr_Arinml.Unidades,0)||'] no coincide con total de numero series ingresadas ['||nvl(Ln_CantidadSerie,0)||']';
        RAISE Le_Error;
      END IF;
      --
    END IF;

    -- se valida que total despachado no supere lo autorizado
    IF C_PEDIDO%ISOPEN THEN CLOSE C_PEDIDO; END IF;
    OPEN C_PEDIDO (Pn_IdDetPedido);
    FETCH C_PEDIDO INTO Lr_PedidoDespach;
    CLOSE C_PEDIDO;

    IF Lr_PedidoDespach.Cantidad_Autorizada < (Lr_PedidoDespach.Cantidad_Despachada + Lr_Arinml.Unidades) THEN
      Pv_MensajeError := 'Total unidades despachadas '||(Lr_PedidoDespach.Cantidad_Despachada + Lr_Arinml.Unidades)||
                         ' supera las unidades autorizadas '||Lr_PedidoDespach.Cantidad_Autorizada||
                         ' para el aerticulo '||Lr_PedidoDespach.Producto_Id||
                         ' del pedido '||Lr_PedidoDespach.Pedido_Id;
      RAISE Le_Error;
    ELSIF Lr_PedidoDespach.Cantidad_Autorizada = (Lr_PedidoDespach.Cantidad_Despachada + Lr_Arinml.Unidades) OR Lb_DespachoTotal THEN
      Lv_EstDetPedido := 'Despachado';
    ELSIF Lr_PedidoDespach.Cantidad_Autorizada > (Lr_PedidoDespach.Cantidad_Despachada + Lr_Arinml.Unidades) THEN
      Lv_EstDetPedido := 'DespachoParcial';
    END IF;

 
   
  
 
    Lv_Login :=NULL; --Para pedidos por login
    IF C_LeeLogin%ISOPEN THEN CLOSE C_LeeLogin; END IF;
    OPEN C_LeeLogin(Lr_PedidoDespach.PEDIDO_ID);
    FETCH C_LeeLogin INTO Lv_Login;
    CLOSE C_LeeLogin;
        
    IF Lv_Login IS NOT NULL THEN
     --
       Lr_ReservaProd := NULL;
          IF C_LeeReservaProd%ISOPEN THEN
            CLOSE C_LeeReservaProd;
          END IF;
          OPEN C_LeeReservaProd(PV_NOCIA,
                                Lr_PedidoDespach.ID_PEDIDO_DETALLE,
                                Lr_PedidoDespach.PRODUCTO_ID);
          FETCH C_LeeReservaProd
            INTO Lr_ReservaProd;
          CLOSE C_LeeReservaProd;
     --
     Lr_RegReservaProductos :=NULL;
     Lr_RegReservaProductos.ID_RESERVA_PRODUCTOS :=DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_RESERVA_PRODUCTOS');
     Lr_RegReservaProductos.EMPRESA_ID  := Lr_ReservaProd.EMPRESA_ID;
     Lr_RegReservaProductos.BODEGA      := Lr_ReservaProd.BODEGA;
     Lr_RegReservaProductos.NO_ARTI     := Lr_ReservaProd.NO_ARTI;
     Lr_RegReservaProductos.DESCRIPCION := Lr_ReservaProd.DESCRIPCION;
     
     Lr_RegReservaProductos.CANTIDAD          := Lr_Arinml.UNIDADES;
     Lr_RegReservaProductos.TIPO_MOV          := 'S';
     Lr_RegReservaProductos.PEDIDO_DETALLE_ID := Lr_ReservaProd.PEDIDO_DETALLE_ID;
     Lr_RegReservaProductos.NO_CIA            := Lr_ReservaProd.NO_CIA;
     Lr_RegReservaProductos.USUARIO_CREACION  := USER;
     Lr_RegReservaProductos.FECHA_CREACION := SYSDATE;
     Lr_RegReservaProductos.DESCRIPCION_MOTIVO :='SalidaDespacho';
     NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_PROD_RESERVA(Lr_RegReservaProductos,--
                                                    Pv_MensajeError);
     IF Pv_MensajeError IS NOT NULL THEN 
       RAISE Le_Error;
     END IF;
     --
    END IF;
    
      -- se procede a actualizar unidades despachadas en tablas pedido -- cuando biene por medido por login
    UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE A
       SET A.CANTIDAD_DESPACHADA = NVL(A.CANTIDAD_DESPACHADA,0) + Lr_Arinml.Unidades,
           A.COMPROBANTE_EGRESO = Lr_Arinme.No_Docu,
           A.ESTADO = Lv_EstDetPedido,
           A.ES_COMPRA = 'N',
           A.CANTIDAD_RESERVADA = NVL(A.CANTIDAD_RESERVADA,0) - NVL(Lr_RegReservaProductos.CANTIDAD,0) --Si es de Login se procede a rebajar las unidades despachadas
     WHERE A.ID_PEDIDO_DETALLE = Pn_IdDetPedido;                                                       --Si no es de Login pues se actualza en 0 para las resrvaas y como el 
                                                                                                       -- el campo nuevo de CANTIDAD es 0 (deberia pues se queda en 0
    --Guardar orden de compra para delvolver valor
    Pv_OrdenEgreso := Lr_Arinme.No_Docu;
  */
  
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_PROCESA_DESPACHO. '||SQLERRM;
      ROLLBACK;
  END P_PROCESA_DESPACHO;

  PROCEDURE P_REASIGNAR_PRODUCTO ( Pn_IdDetPedido  IN     NUMBER,
                                   Pv_NoCia        IN     VARCHAR2,
                                   Pv_Observacion  IN     VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2) IS

    CURSOR C_EMPRESA IS
      SELECT E.ID_EMPRESA
        FROM DB_COMPRAS.ADMI_EMPRESA E
       WHERE E.CODIGO = Pv_NoCia
         AND E.ESTADO = 'Activo';
    --
    Le_Error               EXCEPTION;
    Ln_IdEmpProdReasignado DB_COMPRAS.INFO_PEDIDO_DETALLE.PRODUCTO_ID_REASIGNADO%TYPE := NULL;
    --
  BEGIN

    OPEN C_EMPRESA;
    FETCH C_EMPRESA INTO Ln_IdEmpProdReasignado;
    CLOSE C_EMPRESA;

    IF Ln_IdEmpProdReasignado IS NULL THEN
      Pv_MensajeError := 'No se encuentra definido empresa '||Pv_NoCia||' en sistema Pedidos';
      RAISE Le_Error;
    END IF;

    UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE A
       SET A.ESTADO = 'Recomendado',
           A.OBSERVACION = Pv_Observacion
     WHERE A.ID_PEDIDO_DETALLE = Pn_IdDetPedido;

    IF SQL%ROWCOUNT = 0 THEN
      Pv_MensajeError := 'No se envio a reasignar detalle pedido '||Pn_IdDetPedido;
      RAISE Le_Error;
    END IF;


  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_REASIGNAR_PRODUCTO. '||Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_REASIGNAR_PRODUCTO. '||SQLERRM;
      ROLLBACK;
  END P_REASIGNAR_PRODUCTO;

  PROCEDURE P_REGISTRA_ESTADO_PEDIDO ( Pv_Estado       IN     VARCHAR2, 
                                       Pn_IdPedido     IN     NUMBER,
                                       Pv_MensajeError IN OUT VARCHAR2) IS

    Le_Error           EXCEPTION;
    --
    Ln_secuencia       number(19):=DB_COMPRAS.MIG_SECUENCIA.SEQ_INFO_PEDIDO_ESTADO;
    Lv_Ip              varchar2(15):=GEK_CONSULTA.F_RECUPERA_IP;
  BEGIN
    -- se actualiza el estado del pedido
    UPDATE DB_COMPRAS.INFO_PEDIDO A
       SET A.ESTADO = Pv_Estado
     WHERE A.ID_PEDIDO = Pn_IdPedido;
    --
    -- se registra en tabla de estados
    INSERT INTO DB_COMPRAS.INFO_PEDIDO_ESTADO ( 
      ID_PEDIDO_ESTADO,
      PEDIDO_ID,
      ESTADO,
      USR_CREACION,
      FE_CREACION,
      IP_CREACION )
    VALUES (
      Ln_secuencia,
      Pn_IdPedido,
      Pv_Estado,
      lower(USER), --GEK_CONSULTA.F_RECUPERA_LOGIN,         --emunoz 14012023 Recuepra Login
      SYSDATE,
      Lv_Ip
      );

  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO.P_REGISTRA_ESTADO_PEDIDO. '||Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO.P_REGISTRA_ESTADO_PEDIDO. '||SQLERRM;
      ROLLBACK;
  END P_REGISTRA_ESTADO_PEDIDO;


  PROCEDURE P_DESPACHO_PEDIDO ( Pr_ProcesarPedido  IN OUT NAF47_TNET.INK_PROCESA_PEDIDOS.Gt_Procesa_Pedido,
                              Pv_MensajeError   IN OUT VARCHAR2,
                              Pn_IdLog          IN OUT NUMBER) IS
    --Pn_IdLog
    --
  CURSOR C_VALIDA_CANTIDAD_SERIE ( Cn_IdPedidoDetalle NUMBER,
                                   Cv_NoArti          VARCHAR2,
                                   Cn_IdPedido        NUMBER,
                                   Cv_NoCia           VARCHAR2) IS
    SELECT SUM(NVL(B.UNIDADES,0)) CANTIDAD
    FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A,
         NAF47_TNET.INV_NUMERO_SERIE B
    WHERE A.ORIGEN = 'PE'
    AND A.NO_DOCUMENTO = Cn_IdPedido
    AND A.NO_ARTICULO = Cv_NoArti
    AND A.LINEA = Cn_IdPedidoDetalle
    AND A.COMPANIA = Cv_NoCia
    AND NOT EXISTS (SELECT NULL 
                    FROM NAF47_TNET.INV_DOCUMENTO_SERIE B,
                      NAF47_TNET.ARINML C,
                      NAF47_TNET.ARINME D
                    WHERE B.SERIE = A.SERIE
                    AND B.COMPANIA = A.COMPANIA
                    AND B.LINEA = C.LINEA
                    AND B.ID_DOCUMENTO = C.NO_DOCU
                    AND B.COMPANIA = C.NO_CIA
                    AND C.NO_DOCU = D.NO_DOCU
                    AND C.NO_CIA = D.NO_CIA
                    AND D.NO_PEDIDO = A.NO_DOCUMENTO)
     AND A.SERIE = B.SERIE (+)
     AND A.NO_ARTICULO = B.NO_ARTICULO (+)
     AND A.COMPANIA = B.COMPANIA (+); 
  --
  CURSOR C_VALIDA_SERIE_DESPACHADAS ( Cn_IdPedidoDetalle NUMBER,
                                      Cv_NoArti          VARCHAR2,
                                      Cn_IdPedido        NUMBER,
                                      Cv_NoCia           VARCHAR2) IS
    SELECT A.SERIE
    FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A
    WHERE A.ORIGEN = 'PE'
    AND A.NO_DOCUMENTO = Cn_IdPedido
    AND A.NO_ARTICULO = Cv_NoArti
    AND A.LINEA = Cn_IdPedidoDetalle
    AND A.COMPANIA = Cv_NoCia
    AND NOT EXISTS (SELECT NULL
                    FROM NAF47_TNET.INV_NUMERO_SERIE F
                    WHERE F.SERIE = A.SERIE
                    AND F.ESTADO = 'EB') -- si no existe en bodega significa que se encuentra despachada
    AND NOT EXISTS (SELECT NULL 
                    FROM NAF47_TNET.INV_DOCUMENTO_SERIE B,
                      NAF47_TNET.ARINML C,
                      NAF47_TNET.ARINME D
                    WHERE B.SERIE = A.SERIE
                    AND B.COMPANIA = A.COMPANIA
                    AND B.LINEA = C.LINEA
                    AND B.ID_DOCUMENTO = C.NO_DOCU
                    AND B.COMPANIA = C.NO_CIA
                    AND C.NO_DOCU = D.NO_DOCU
                    AND C.NO_CIA = D.NO_CIA
                    AND D.NO_PEDIDO = A.NO_DOCUMENTO);

    --
    CURSOR C_ESTADO_PEDIDO (Cn_IdPedido NUMBER) IS
      SELECT A.ESTADO
      FROM NAF47_TNET.V_DETALLE_PEDIDOS A
      WHERE A.PEDIDO_ID = Cn_IdPedido
      AND A.ESTADO NOT IN ('Anulado','Borrado','Rechazado')
      GROUP BY A.ESTADO;
    --
    CURSOR C_VERIFICA_RECURRENTE (Cv_NoArti VARCHAR2,
                                  Cv_Bodega VARCHAR2,
                                  Cv_NoCia  VARCHAR2) IS
      SELECT 'S'
      FROM NAF47_TNET.ARINMA BA,
        NAF47_TNET.ARINDA A,
        NAF47_TNET.ARINBO B
      WHERE BA.NO_ARTI = A.NO_ARTI
        AND BA.NO_CIA = A.NO_CIA
        AND BA.BODEGA = B.CODIGO
        AND BA.NO_CIA = B.NO_CIA
        AND A.ES_RECURRENTE = 'S'
        AND BA.NO_ARTI = Cv_NoArti
        AND BA.BODEGA = Cv_Bodega
        AND BA.NO_CIA = Cv_NoCia
        AND EXISTS (SELECT NULL
                    FROM NAF47_TNET.ARIN_PARAMETRO_DETALLE BR,
                      NAF47_TNET.ARIN_PARAMETRO P
                    WHERE BR.OBJETO_ID = B.CODIGO
                    AND BR.EMPRESA_OBJETO_ID = B.NO_CIA
                    AND BR.PARAMETRO_ID = P.ID_PARAMETRO
                    AND BR.TIPO = 'CA'
                    AND BR.ESTADO = 'A'
                    AND P.CLASE =  'BR'
                    AND P.ESTADO = 'A');
    /**/
    CURSOR C_BANDERA_RECURRENCIA IS
       SELECT PARAMETRO 
        FROM NAF47_TNET.GE_PARAMETROS x, NAF47_TNET.GE_GRUPOS_PARAMETROS y
        WHERE X.ID_GRUPO_PARAMETRO = Y.ID_GRUPO_PARAMETRO
          AND X.ID_APLICACION = Y.ID_APLICACION
          AND X.ID_EMPRESA = Y.ID_EMPRESA
          AND X.ID_GRUPO_PARAMETRO = 'ART_RECURRENTE'
          AND X.DESCRIPCION='VALIDA'
          AND X.ID_APLICACION = 'IN'
          AND X.ESTADO = 'A'
          AND Y.ESTADO = 'A';
       /**/
    Ln_CantDespachar NUMBER := 0;
    /**/
     Lv_ProcRecurrente VARCHAR2(2);
    /**/
    Lv_SeriesDesp    VARCHAR2(4000) := NULL;
    Le_Error         Exception;
    Lb_Despachando   BOOLEAN := FALSE;
    Lb_Habilitando   BOOLEAN := FALSE;
    Ln_Errores       NUMBER(5) := 0;
    Ln_IdLog        NUMBER := 0;
    Lv_EstadoPedido  VARCHAR2(30) := NULL;
    Lv_OrdenEgreso  VARCHAR2(100) := NULL;
    Lv_Recurrente    VARCHAR2(1) := 'N';
    Lv_IdDetalles   VARCHAR2(400) := NULL;
    --
    Lb_Despachado    BOOLEAN := FALSE;
    Lb_DespParcial   BOOLEAN := FALSE;
    Lb_Autorizado    BOOLEAN := FALSE;
    Lb_Recomendado   BOOLEAN := FALSE;
    Lb_PorBorrar     BOOLEAN := FALSE;
    --
  BEGIN
    -- se recupera los articulos a comprar
    FOR Li_Pedido IN 1..Pr_ProcesarPedido.LAST LOOP

      IF Pr_ProcesarPedido(Li_Pedido).ACCION = 'Despachar' THEN
        -- se recupera cantidad de series ingresada para validar con lo indicado en despachar
        IF C_VALIDA_CANTIDAD_SERIE%ISOPEN THEN CLOSE C_VALIDA_CANTIDAD_SERIE; END IF;
        OPEN C_VALIDA_CANTIDAD_SERIE (Pr_ProcesarPedido(Li_Pedido).ID_PEDIDO_DETALLE,
                                      Pr_ProcesarPedido(Li_Pedido).PRODUCTO_ID,
                                      Pr_ProcesarPedido(Li_Pedido).PEDIDO_ID,
                                      Pr_ProcesarPedido(Li_Pedido).ID_EMPRESA);
        FETCH C_VALIDA_CANTIDAD_SERIE INTO Ln_CantDespachar;
        IF C_VALIDA_CANTIDAD_SERIE%NOTFOUND THEN
          Ln_CantDespachar := 0;
        END IF;
        CLOSE C_VALIDA_CANTIDAD_SERIE;
        -------------------------------
        Lv_SeriesDesp := NULL;
        FOR I IN C_VALIDA_SERIE_DESPACHADAS (Pr_ProcesarPedido(Li_Pedido).ID_PEDIDO_DETALLE,
                                             Pr_ProcesarPedido(Li_Pedido).PRODUCTO_ID,
                                             Pr_ProcesarPedido(Li_Pedido).PEDIDO_ID,
                                             Pr_ProcesarPedido(Li_Pedido).ID_EMPRESA) LOOP
          IF Lv_SeriesDesp IS NULL THEN
            Lv_SeriesDesp := I.SERIE;
          ELSE
            Lv_SeriesDesp := Lv_SeriesDesp||', '||I.SERIE;
          END IF;
        END LOOP;
        --
        IF NVL(Pr_ProcesarPedido(Li_Pedido).MANEJA_SERIE,'N') = 'S' AND NVL(Ln_CantDespachar,0) != NVL(Pr_ProcesarPedido(Li_Pedido).CANTIDAD,0) THEN -- valida serie
          Pr_ProcesarPedido(Li_Pedido).DETALLE_ERROR := 'Para el articulo '||Pr_ProcesarPedido(Li_Pedido).PRODUCTO_ID||' cantidad de numero de series seleccionados '||Ln_CantDespachar||' no coincide con la cantidad a despachar '||NVL(Pr_ProcesarPedido(Li_Pedido).CANTIDAD,0)||'.';
          Ln_Errores := Ln_Errores + 1;
          GOTO SEGUIR_VALIDANDO;
        ELSIF NVL(Pr_ProcesarPedido(Li_Pedido).MANEJA_SERIE,'N') = 'S' AND Lv_SeriesDesp IS NOT NULL THEN
          Pr_ProcesarPedido(Li_Pedido).DETALLE_ERROR := 'Los siguiente numero de series ya fueron procesados, debe cambiar por otros equipos: '||CHR(13)||Lv_SeriesDesp;
          Ln_Errores := Ln_Errores + 1;
          GOTO SEGUIR_VALIDANDO;
        END IF;
        --
        --
        --Si envian usuario asignado se cambia para despacho
        IF Pr_ProcesarPedido(Li_Pedido).USR_ASIGNADO_ID IS NOT NULL AND  Pr_ProcesarPedido(Li_Pedido).USR_ASIGNADO IS NOT NULL THEN
          UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE A
          SET A.USR_ASIGNADO_ID = Pr_ProcesarPedido(Li_Pedido).USR_ASIGNADO_ID,
          A.USR_ASIGNADO = Pr_ProcesarPedido(Li_Pedido).USR_ASIGNADO
          WHERE A.ID_PEDIDO_DETALLE = Pr_ProcesarPedido(Li_Pedido).ID_PEDIDO_DETALLE;   
        END IF;
        --
        -- se procede a despachar
        NAF47_TNET.INK_PROCESA_PEDIDOS.P_PROCESA_DESPACHO(Pr_ProcesarPedido(Li_Pedido)
                                               .ID_PEDIDO_DETALLE,
                                               Pr_ProcesarPedido(Li_Pedido)
                                               .CANTIDAD,
                                               Pr_ProcesarPedido(Li_Pedido)
                                               .TIPO_CONSUMO,
                                               Pr_ProcesarPedido(Li_Pedido)
                                               .TIPO_DOCUMENTO,
                                               Pr_ProcesarPedido(Li_Pedido)
                                               .ID_BODEGA,
                                               Pr_ProcesarPedido(Li_Pedido)
                                               .OBSERVACION,
                                               Pr_ProcesarPedido(Li_Pedido)
                                               .ID_CENTRO,
                                               Pr_ProcesarPedido(Li_Pedido)
                                               .ID_EMPRESA,
                                               Lv_OrdenEgreso,
                                                 Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          Pr_ProcesarPedido(Li_Pedido).DETALLE_ERROR := Pv_MensajeError;
          Ln_Errores := Ln_Errores + 1;
          GOTO SEGUIR_VALIDANDO;
        ELSE
          Lv_IdDetalles := Pr_ProcesarPedido(Li_Pedido)
                           .ID_PEDIDO_DETALLE || ',' || Lv_IdDetalles;
        END IF;
        --
        -- identifica el despacho
        IF NOT Lb_Despachando THEN
          Lb_Despachando := TRUE;
        END IF;
        --
        -- Solo se verifica si es que no se ha encontrado un recurrente
        IF Lv_Recurrente = 'N' THEN
          -- se valida recurrente
          IF C_VERIFICA_RECURRENTE%ISOPEN THEN
            CLOSE C_VERIFICA_RECURRENTE;
          END IF;
          OPEN C_VERIFICA_RECURRENTE(Pr_ProcesarPedido(Li_Pedido).PRODUCTO_ID,
                                     Pr_ProcesarPedido(Li_Pedido).ID_BODEGA,
                                     Pr_ProcesarPedido(Li_Pedido).ID_EMPRESA);
          FETCH C_VERIFICA_RECURRENTE INTO Lv_Recurrente;
          IF C_VERIFICA_RECURRENTE%NOTFOUND THEN
            Lv_Recurrente := 'N';
          END IF;
          CLOSE C_VERIFICA_RECURRENTE;
        END IF;



      ELSIF Pr_ProcesarPedido(Li_Pedido).ACCION = 'ReAsignar' THEN

        NAF47_TNET.INK_PROCESA_PEDIDOS.P_REASIGNAR_PRODUCTO ( Pr_ProcesarPedido(Li_Pedido).ID_PEDIDO_DETALLE,
                                                   Pr_ProcesarPedido(Li_Pedido).ID_EMPRESA,
                                                   Pr_ProcesarPedido(Li_Pedido).OBSERVACION,
                                                   Pv_MensajeError);
        IF Pv_MensajeError IS NOT NULL THEN
          Pr_ProcesarPedido(Li_Pedido).DETALLE_ERROR := Pv_MensajeError;
          Ln_Errores := Ln_Errores + 1;
          GOTO SEGUIR_VALIDANDO;
        END IF;

      ELSIF Pr_ProcesarPedido(Li_Pedido).ACCION IN ('Borrar','Habilitar') THEN

        -- Se cambia estado
        UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE
           SET ESTADO = DECODE(Pr_ProcesarPedido(Li_Pedido).ACCION, 'Borrar', 'PorBorrar', 'Habilitar', 'Autorizado')
         WHERE ID_PEDIDO_DETALLE = Pr_ProcesarPedido(Li_Pedido).ID_PEDIDO_DETALLE;
        --
        IF Pr_ProcesarPedido(Li_Pedido).ACCION = 'Habilitar' THEN
          IF NOT Lb_Habilitando THEN
            Lb_Habilitando := TRUE;
          END IF;
        END IF;
        --
      END IF;


      <<SEGUIR_VALIDANDO>>
      NULL;
    END LOOP;

    -- se verifica si se presentaron errores
    IF Ln_Errores > 0 THEN
      Pv_MensajeError := 'Se han presentado '||Ln_Errores||' novedades, favor revisar!!!';
      RAISE Le_Error;
    END IF;
    --
    -- si se genero por lo menos un despacho se procede a actulizar
    IF Lb_Despachando THEN
      -- Se procesan los documentos pendientes que haya generado el pedido y usuario 
      NAF47_TNET.INK_PROCESA_PEDIDOS.P_ACTUALIZA_DOCUMENTOS ( Pr_ProcesarPedido(1).PEDIDO_ID,
                                                   Pr_ProcesarPedido(1).ID_CENTRO,
                                                   Pr_ProcesarPedido(1).ID_EMPRESA,
                                                   Pv_MensajeError );

      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;
    --
    -- Se recuperan los estados del detalle para asignar estado de pedido--
    FOR Lr_DetPedido IN C_ESTADO_PEDIDO (Pr_ProcesarPedido(1).PEDIDO_ID) LOOP
      --
      IF Lr_DetPedido.ESTADO = 'Despachado' THEN
        Lb_Despachado := (Lr_DetPedido.ESTADO = 'Despachado');
      ELSIF Lr_DetPedido.ESTADO = 'DespachoParcial' THEN
        Lb_DespParcial := (Lr_DetPedido.ESTADO = 'DespachoParcial');
      ELSIF Lr_DetPedido.ESTADO = 'Autorizado' THEN
        Lb_Autorizado := (Lr_DetPedido.ESTADO = 'Autorizado');
      ELSIF Lr_DetPedido.ESTADO = 'Recomendado' THEN
        Lb_Recomendado := (Lr_DetPedido.ESTADO = 'Recomendado');
      ELSIF Lr_DetPedido.ESTADO = 'PorBorrar' THEN
        Lb_PorBorrar := (Lr_DetPedido.ESTADO = 'PorBorrar');
      END IF;
      --
    END LOOP;
    --
    -- Se validan los estado del detalle para asignar esatdos de pedido
    IF Lb_Despachado THEN
      --
      IF Lb_Recomendado THEN
        Lv_EstadoPedido := 'DespachoParcial/Recomendado';
      ELSIF Lb_Autorizado OR Lb_DespParcial OR Lb_PorBorrar THEN
        Lv_EstadoPedido := 'DespachoParcial';
      ELSE
        Lv_EstadoPedido := 'Despachado';
      END IF;
      --
    ELSIF NOT Lb_Despachado THEN
      --
      IF Lb_Recomendado AND Lb_DespParcial THEN
        Lv_EstadoPedido := 'DespachoParcial/Recomendado';
      ELSIF Lb_Recomendado THEN
        Lv_EstadoPedido := 'Recomendado';
      ELSIF Lb_DespParcial THEN
        Lv_EstadoPedido := 'DespachoParcial';
      ELSIF Lb_PorBorrar AND NOT Lb_Autorizado THEN
        Lv_EstadoPedido := 'PorBorrar';
      ELSIF Lb_Habilitando THEN -- De todo el pedido solo se modifico el refgistro que fue habiliado
        Lv_EstadoPedido := 'Autorizado';
      END IF;
      --
    END IF;

    -- una vez validao se asigna y se registra en historial de estados
    IF Lv_EstadoPedido IS NOT NULL THEN
      -- se invoka procedure que actualiza estado y lo registra en pedidos    
      NAF47_TNET.INK_PROCESA_PEDIDOS.P_REGISTRA_ESTADO_PEDIDO(Lv_EstadoPedido, 
                                                   Pr_ProcesarPedido(1).PEDIDO_ID, 
                                                   Pv_MensajeError);   
      --
      Pr_ProcesarPedido(1).ESTADO_PEDIDO := Lv_EstadoPedido;
      --
      --Regsiro log_pedidos
      Lv_IdDetalles := rtrim(Lv_IdDetalles, ',');
    
      NAF47_TNET.INK_PROCESA_PEDIDOS.P_REGISTRA_TIEMPOS_PEDIDO(Pr_ProcesarPedido(1)
                                                    .PEDIDO_ID,
                                                    Lv_OrdenEgreso,
                                                    'DESPACHO',
                                                    Lv_EstadoPedido,
                                                    GEK_CONSULTA.F_RECUPERA_IP,
                                                    LOWER(USER), --GEK_CONSULTA.F_RECUPERA_LOGIN,     14012023 Se procedde con el cambio GEK_CONSULTA.F_RECUPERA_LOGIN por  Login
                                                    Lv_IdDetalles,
                                                    Pv_MensajeError,
                                                    Ln_IdLog);
      Pn_IdLog := Ln_IdLog;
      --
      IF Pv_MensajeError IS NOT NULL THEN   
        RAISE Le_Error;   
      END IF;
    END IF;
    --
    --
    OPEN C_BANDERA_RECURRENCIA;
    FETCH C_BANDERA_RECURRENCIA INTO Lv_ProcRecurrente;
    CLOSE C_BANDERA_RECURRENCIA;
    -----
    IF Lv_Recurrente = 'S' AND NVL(Lv_ProcRecurrente,'N')='S'THEN
      --
      NAF47_TNET.COK_ORDEN_COMPRA_PEDIDO.P_GENERA_PEDIDO_COMPRA_BIENES( Pr_ProcesarPedido(1).PEDIDO_ID,
                                                             Pr_ProcesarPedido(1).ID_EMPRESA,
                                                             Pr_ProcesarPedido(1).ID_PEDIDO_COMPRA);
    END IF;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO.P_DESPACHO_PEDIDO. '||Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO.P_DESPACHO_PEDIDO. '||SQLERRM;
      ROLLBACK;
  END P_DESPACHO_PEDIDO;

  PROCEDURE P_REGISTRA_TIEMPOS_PEDIDO(Pn_IdPedido          IN NUMBER,
                                      Pv_ComprobanteEgreso IN VARCHAR2,
                                      Pv_Proceso           IN VARCHAR2,
                                      Pv_Estado            IN VARCHAR2,
                                      Pv_IpCreacion        IN VARCHAR2,
                                      Pv_UsuarioDespacho   IN VARCHAR2,
                                      Pv_IdDetalles        IN VARCHAR2,
                                      Pv_MensajeError      IN OUT VARCHAR2,
                                      Pn_IdLog             IN OUT NUMBER) IS
  
    CURSOR C_INICIO_PEDIDO IS
      SELECT count(PEDIDO_ID)
        FROM NAF47_TNET.LOG_PEDIDOS
       WHERE PEDIDO_ID = Pn_IdPedido
         AND ESTADO = 'Inicio';
  
    CURSOR C_OTROS_ESTADOS IS
      SELECT count(PEDIDO_ID)
        FROM NAF47_TNET.LOG_PEDIDOS
       WHERE PEDIDO_ID = Pn_IdPedido
         AND ESTADO != 'Inicio'
         and ESTADO != 'Sin Stock';
  
    CURSOR C_FECHA_INICIO_PEDIDO IS
      SELECT FE_PROCESO
        FROM NAF47_TNET.LOG_PEDIDOS
       WHERE PEDIDO_ID = Pn_IdPedido
         AND ESTADO = 'Inicio'
       ORDER BY FE_PROCESO DESC;
  
    Ln_CantidadInicio       number;
    Ln_CantidadOtrosEstados number;
    Ld_FechaInicioPedido    TIMESTAMP := NULL;
    Lv_restaFechas          varchar2(500);
    Lv_restaFechasExcedente varchar2(500);
    Pv_EstadoExcede         varchar2(500);
    --
    Lv_horas_dias number;
    Lv_horas      number;
    Lv_minutos    number;
    Lv_segundos   number;
    --
    Ln_idLog                number(19);
    Le_Error Exception;
    Ln_secuencia    number(19):=0;
  BEGIN
    -- inicio proceso
    --SE RECUPERA CANTIDAD DE ESTADO EN INICIO DE PEDIDO PARA EL DESPACHO
    IF C_INICIO_PEDIDO%ISOPEN THEN
      CLOSE C_INICIO_PEDIDO;
    END IF;
    Ln_idLog:= 0;
    --
    OPEN C_INICIO_PEDIDO;
    FETCH C_INICIO_PEDIDO
      INTO Ln_CantidadInicio;
    IF C_INICIO_PEDIDO%NOTFOUND THEN
      Ln_CantidadInicio := NULL;
    END IF;
    CLOSE C_INICIO_PEDIDO;
    --
    Ln_idLog:= 1;
    --SE RECUPERA CANTIDAD DE ESTADO EN INICIO DE PEDIDO PARA EL DESPACHO
    IF C_OTROS_ESTADOS%ISOPEN THEN
      CLOSE C_OTROS_ESTADOS;
    END IF;
    --
    Ln_idLog:= 2;
    OPEN C_OTROS_ESTADOS;
    FETCH C_OTROS_ESTADOS
      INTO Ln_CantidadOtrosEstados;
    IF C_OTROS_ESTADOS%NOTFOUND THEN
      Ln_CantidadOtrosEstados := NULL;
    END IF;
    CLOSE C_OTROS_ESTADOS;
    --
    Ln_idLog:= 3;
    --
    IF C_FECHA_INICIO_PEDIDO%ISOPEN THEN
      CLOSE C_FECHA_INICIO_PEDIDO;
    END IF;
    --
    Ln_idLog:= 4;
    OPEN C_FECHA_INICIO_PEDIDO;
    FETCH C_FECHA_INICIO_PEDIDO
      INTO Ld_FechaInicioPedido;
    IF C_FECHA_INICIO_PEDIDO%NOTFOUND THEN
      Ld_FechaInicioPedido := NULL;
    END IF;
    CLOSE C_FECHA_INICIO_PEDIDO;
    Ln_idLog:= 5;
    --
    Lv_horas_dias := (SUBSTR((sysdate - Ld_FechaInicioPedido), 1, 10) * 24);
    Lv_horas      := SUBSTR((sysdate - Ld_FechaInicioPedido), 12, 2);
    Lv_minutos    := SUBSTR((sysdate - Ld_FechaInicioPedido), 15, 2);
    Lv_segundos   := SUBSTR((sysdate - Ld_FechaInicioPedido), 18, 2);
    --
    if Pv_Estado = 'Inicio' AND
       (Ln_CantidadInicio > Ln_CantidadOtrosEstados) then
    
      --
      Lv_restaFechasExcedente := (Lv_horas_dias + Lv_horas);
    
      if Lv_restaFechasExcedente > 99 then
        Pv_EstadoExcede := 'ExcedeTiempoDespacho';
        Lv_restaFechas  := '99:59:59';
      end if;
      Ln_idLog:= 6;
      if Pv_EstadoExcede = 'ExcedeTiempoDespacho' then
      Ln_secuencia:=NAF47_TNET.MIG_SECUENCIA.SEQ_LOG_PEDIDOS;
      INSERT INTO NAF47_TNET.LOG_PEDIDOS
        (ID_LOG_PEDIDOS,
         PEDIDO_ID,
         COMPROBANTE_EGRESO,
         PROCESO,
         ESTADO,
         IP_CREACION,
         USUARIO_DESPACHO,
         FE_CREACION,
         FE_PROCESO,
         TIEMPO_DESPACHO)
      VALUES
        (Ln_secuencia,
         Pn_IdPedido,
         Pv_ComprobanteEgreso,
         Pv_Proceso,
         Pv_EstadoExcede,
         Pv_IpCreacion,
         Pv_UsuarioDespacho,
         Ld_FechaInicioPedido,
         SYSDATE,
         Lv_restaFechas);
         Pn_IdLog :=Ln_secuencia;

      COMMIT;
      Ln_idLog:= 7;
    END IF;
  
    end if;
  
    IF (Pv_Estado != 'Inicio' and Pv_Estado != 'Sin Stock') AND
       (Ln_CantidadInicio > Ln_CantidadOtrosEstados) THEN
    
      --
      Lv_horas_dias := (SUBSTR((sysdate - Ld_FechaInicioPedido), 1, 10) * 24);
      Lv_horas      := SUBSTR((sysdate - Ld_FechaInicioPedido), 12, 2);
      Lv_minutos    := SUBSTR((sysdate - Ld_FechaInicioPedido), 15, 2);
      Lv_segundos   := SUBSTR((sysdate - Ld_FechaInicioPedido), 18, 2);
      --
      Lv_restaFechas := (Lv_horas_dias + Lv_horas) || ':' || Lv_minutos || ':' ||
                        Lv_segundos;
      Ln_idLog:= 8;                        
      Ln_secuencia:=NAF47_TNET.MIG_SECUENCIA.SEQ_LOG_PEDIDOS;
      INSERT INTO NAF47_TNET.LOG_PEDIDOS
        (ID_LOG_PEDIDOS,
         PEDIDO_ID,
         DETALLES_ID,
         COMPROBANTE_EGRESO,
         PROCESO,
         ESTADO,
         IP_CREACION,
         USUARIO_DESPACHO,
         FE_CREACION,
         FE_PROCESO,
         TIEMPO_DESPACHO)
      VALUES
        (Ln_secuencia,
         Pn_IdPedido,
         Pv_IdDetalles,
         Pv_ComprobanteEgreso,
         Pv_Proceso,
         Pv_Estado,
         Pv_IpCreacion,
         Pv_UsuarioDespacho,
         Ld_FechaInicioPedido,
         SYSDATE,
         Lv_restaFechas);
      --RETURNING ID_LOG_PEDIDOS INTO Ln_idLog;
      COMMIT;
      Pn_IdLog :=Ln_idLog;
      Ln_idLog:= 9;
    END IF;
    -- 
    IF (Pv_Estado = 'Inicio' AND
       (Ln_CantidadInicio = Ln_CantidadOtrosEstados)) or
       Pv_Estado = 'Sin Stock' or Pv_EstadoExcede = 'ExcedeTiempoDespacho' THEN
      Ln_secuencia:=NAF47_TNET.MIG_SECUENCIA.SEQ_LOG_PEDIDOS;
      Ln_idLog:= 10;
      INSERT INTO NAF47_TNET.LOG_PEDIDOS
        (ID_LOG_PEDIDOS,
         PEDIDO_ID,
         COMPROBANTE_EGRESO,
         PROCESO,
         ESTADO,
         IP_CREACION,
         USUARIO_DESPACHO,
         FE_CREACION,
         FE_PROCESO,
         TIEMPO_DESPACHO)
      VALUES
        (Ln_secuencia,
         Pn_IdPedido,
         Pv_ComprobanteEgreso,
         Pv_Proceso,
         Pv_Estado,
         Pv_IpCreacion,
         Pv_UsuarioDespacho,
         SYSDATE,
         SYSDATE,
         '0');
      --RETURNING ID_LOG_PEDIDOS INTO Ln_idLog;
      Pn_IdLog :=Ln_idLog;
      COMMIT;
      Ln_idLog:= 11;
    END IF;
  
    Pn_IdLog := Ln_idLog;
  EXCEPTION
    WHEN Le_Error THEN
      Pn_IdLog := Ln_idLog;
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO.P_REGISTRA_TIEMPOS_PEDIDO. ' ||
                         Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pn_IdLog := Ln_idLog;
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_REGISTRA_TIEMPOS_PEDIDO: ' ||
                         SQLERRM;
  END P_REGISTRA_TIEMPOS_PEDIDO;

  ----

  PROCEDURE P_ACTUALIZA_TIEMPOS_PEDIDO(Pn_IdLog        IN NUMBER,
                                       Pv_MensajeError IN OUT VARCHAR2) IS
  
    CURSOR C_FECHA_PEDIDO IS
      SELECT FE_CREACION
        FROM NAF47_TNET.LOG_PEDIDOS
       WHERE ID_LOG_PEDIDOS = Pn_IdLog
       ORDER BY FE_CREACION DESC;
  
    Ld_FechaInicioPedido TIMESTAMP := NULL;
    Lv_restaFechas       varchar2(50);
    --
    Lv_horas_dias number;
    Lv_horas      number;
    Lv_minutos    number;
    Lv_segundos   number;
    --
    Le_Error Exception;
  BEGIN
  
    --
    IF C_FECHA_PEDIDO%ISOPEN THEN
      CLOSE C_FECHA_PEDIDO;
    END IF;
    --
    OPEN C_FECHA_PEDIDO;
    FETCH C_FECHA_PEDIDO
      INTO Ld_FechaInicioPedido;
    IF C_FECHA_PEDIDO%NOTFOUND THEN
      Ld_FechaInicioPedido := NULL;
    END IF;
    CLOSE C_FECHA_PEDIDO;
    --
  
    --
    Lv_horas_dias := (SUBSTR((sysdate - Ld_FechaInicioPedido), 1, 10) * 24);
    Lv_horas      := SUBSTR((sysdate - Ld_FechaInicioPedido), 12, 2);
    Lv_minutos    := SUBSTR((sysdate - Ld_FechaInicioPedido), 15, 2);
    Lv_segundos   := SUBSTR((sysdate - Ld_FechaInicioPedido), 18, 2);
    --
    Lv_restaFechas := (Lv_horas_dias + Lv_horas) || ':' || Lv_minutos || ':' ||
                      Lv_segundos;
  
    UPDATE NAF47_TNET.LOG_PEDIDOS
       SET FE_PROCESO = sysdate, TIEMPO_DESPACHO = Lv_restaFechas
     WHERE ID_LOG_PEDIDOS = Pn_IdLog;
    COMMIT;
    --
  
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO.P_ACTUALIZA_TIEMPOS_PEDIDO. ' ||
                         Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDOS.P_ACTUALIZA_TIEMPOS_PEDIDO: ' ||
                         SQLERRM;
  END P_ACTUALIZA_TIEMPOS_PEDIDO;
  
  
            
end INK_PROCESA_PEDIDOS;
/
