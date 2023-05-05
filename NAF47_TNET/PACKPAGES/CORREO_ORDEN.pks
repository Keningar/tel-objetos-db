CREATE OR REPLACE PACKAGE            CORREO_ORDEN AS
  /**
  * Documentacion para NAF47_TNET.CORREO_ORDEN
  * Paquete que contiene procesos y funciones para registro automático factura proveedor.
  * @author telconet <telconet@telconet.ec>
  * @version 1.0 11/10/2012
  */

  /**
  * Documentacion para NAF47_TNET.CPKG_TRANSACCION.Gr_DatosOrdenCompra
  * Variable Registro que permite pasar por parametro los datos necesarios para notificación de orden compra autorizada.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/11/2021
  *
  * @author banton <banton@telconet.ec>
  * @version 1.1 20/09/2022 Se agrega campo usuario
  *
  * @author jxzurita <jxzurita@telconet.ec>
  * @version 1.2 11/11/2022 Se realiza la validacion para usuarios genericos en la obtencion del correo con la tabla tagsusuario
  * @tags: JXZURITA email generico [FECHA] [INICIO/FIN]
  *
  * @author jxzurita <jxzurita@telconet.ec>
  * @version 1.2 06/12/2022 Se realiza la validacion para usuarios genericos se valida error reportado para el usuario 
  * @tags: JXZURITA email generico [FECHA] [INICIO/FIN]  
  */ 
  TYPE Gr_DatosOrdenCompra is RECORD
    (NO_CIA              NAF47_TNET.TAPORDEE.NO_CIA%TYPE,
     NO_ORDEN            NAF47_TNET.TAPORDEE.NO_ORDEN%TYPE,
     NO_PROVEEDOR        NAF47_TNET.TAPORDEE.NO_PROVE%TYPE,
     NO_SOLICITANTE      NAF47_TNET.TAPORDEE.ADJUDICADOR%TYPE,
     ID_TIPO_TRANSACCION NAF47_TNET.TAPORDEE.ID_TIPO_TRANSACCION%TYPE,
     FECHA               NAF47_TNET.TAPORDEE.FECHA%TYPE,
     TOTAL               NAF47_TNET.TAPORDEE.TOTAL%TYPE,
     FECHA_VENCE         NAF47_TNET.TAPORDEE.FECHA_VENCE%TYPE,
     OBSERVACION         NAF47_TNET.TAPORDEE.OBSERV%TYPE,
     USUARIO             NAF47_TNET.TAPORDEE.USUARIO%TYPE
     );
  -- 
  PROCEDURE SIGUIENTE_APROBADOR(Pv_IdEmpresa    IN VARCHAR2, --COP_AUTORIZA_ORDEN
                                Pv_IdOrden      IN VARCHAR2,
                                Pv_IdTipoOrden  IN VARCHAR2,
                                Pv_CodigoError  OUT VARCHAR2,
                                Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE CORRIGE_ANULA(Pv_IdEmpresa    IN VARCHAR2, --COP_CO_RZ_ORDEN
                          Pv_IdOrden      IN VARCHAR2,
                          Pv_IdTipoOrden  IN VARCHAR2,
                          Pv_Estado       IN VARCHAR2,
                          Pv_MotivoCORZ   IN VARCHAR2,
                          Pv_CodigoError  OUT VARCHAR2,
                          Pv_MensajeError OUT VARCHAR2);
  --
  PROCEDURE NOTIFICA_PENDIENTES; --COP_NOTIFICA_PENDIENTES
  --
  --
 /**
  * Documentacion para P_NOTIFICA_AUTORIZACION
  * Procedure que crea correo electrónico para notificar a usuarios las autorizaciones de ordenes de compra.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 12/11/2021
  *
  * @param Pr_DatosOC IN NAF47_TNET.CORREO_ORDEN.Gr_DatosOrdenCompra Recibe variable tipo registro para realizar proceso notificación
  */
  PROCEDURE P_NOTIFICA_AUTORIZACION ( Pr_DatosOC NAF47_TNET.CORREO_ORDEN.Gr_DatosOrdenCompra);
  --  
END CORREO_ORDEN;

/


CREATE OR REPLACE PACKAGE BODY            CORREO_ORDEN IS
  --
  -- declaracion de constantes
  TIPO_TRANSACCION CONSTANT VARCHAR2(16) := 'TIPO_TRANSACCION';
  --
  --
  -- Lee la empresa que permite enviar notificaciones
  -- costo query: 1
  CURSOR C_LeeNotifica(Cv_IdEmpresa IN VARCHAR2) IS
    SELECT NVL(E.NOTIFICA, 'N') AS NOTIFICA_CORREO
    FROM NAF47_TNET.TAPCIA E
    WHERE NO_CIA = Cv_IdEmpresa;
  --
  -- recupera descripcion del tipo de orden compra
  -- costo query: 3
  CURSOR C_LeeTiposOrdenes( Cv_IdEmpresa IN VARCHAR2,
                            Cv_TipoOrden IN VARCHAR2) IS
    SELECT P.DESCRIPCION
    FROM NAF47_TNET.GE_PARAMETROS P
    WHERE ID_EMPRESA = Cv_IdEmpresa
    AND ID_GRUPO_PARAMETRO = TIPO_TRANSACCION
    AND PARAMETRO = Cv_TipoOrden;
  --
  -- Lee el nombre de proveedor
  -- costo query: 2
  CURSOR C_LeeProveedor( Cv_IdEmpresa   IN VARCHAR2,
                         Cv_IdProveedor IN VARCHAR2) IS
    SELECT P.NOMBRE
    FROM NAF47_TNET.ARCPMP P
    WHERE NO_CIA = Cv_IdEmpresa
    AND NO_PROVE = Cv_IdProveedor;
  --
  -- Lee el detalle de la orden de compra
  -- costo query: 4
  CURSOR C_LeeDetalleOrden ( Cv_IdEmpresa IN VARCHAR2,
                             Cv_IdOrden   IN VARCHAR2) IS
    SELECT DC.NO_CIA,
           DC.NO_ARTI,
           DC.CODIGO_NI,
           DC.CANTIDAD,
           DC.COSTO_UNI,
           DC.IMPUESTOS
    FROM NAF47_TNET.TAPORDED DC
    WHERE DC.NO_CIA = Cv_IdEmpresa
    AND DC.NO_ORDEN = Cv_IdOrden;
  --
  --Lee la descripcion de servicios de la orden de compra
  --costo query: 1
  CURSOR C_LeeServicios(Cv_IdEmpresa  IN VARCHAR2,
                        Cv_IdServicio IN VARCHAR2) IS
    SELECT SE.DESCRIPCION
    FROM NAF47_TNET.TAPCPS SE
    WHERE NO_CIA = Cv_IdEmpresa
    AND SE.CODIGO = Cv_IdServicio;
  --
  --Lee la descripcion de bienes o productos de la orden de compra
  -- costo query: 2
  CURSOR C_LeeBienes(Cv_IdEmpresa  IN VARCHAR2,
                     Cv_IdArticulo IN VARCHAR2) IS
    SELECT DA.DESCRIPCION
      FROM NAF47_TNET.ARINDA DA
     WHERE NO_CIA = Cv_IdEmpresa
       AND DA.NO_ARTI = Cv_IdArticulo;
  --
  --Lee la hora del sistema para incluir en el saludos pesonalizado
  CURSOR C_LeeHora IS
    SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) HORA
    FROM DUAL;
  --
  PROCEDURE SIGUIENTE_APROBADOR(Pv_IdEmpresa    IN VARCHAR2,
                                Pv_IdOrden      IN VARCHAR2,
                                Pv_IdTipoOrden  IN VARCHAR2,
                                Pv_CodigoError  OUT VARCHAR2,
                                Pv_MensajeError OUT VARCHAR2) IS

    --Lee cierto campos de la orden que son usados en el correo
    CURSOR C_LeeOrden(Cv_IdEmpresa   IN VARCHAR2,
                      Cv_IdTipoOrden IN VARCHAR2,
                      Cv_IdOrden     IN VARCHAR2) IS
      SELECT OC.NO_CIA,
             OC.ID_TIPO_TRANSACCION,
             OC.NO_PROVE,
             OC.NO_ORDEN,
             OC.FECHA,
             OC.TOTAL,
             OC.FECHA_VENCE,
             OC.OBSERV
        FROM TAPORDEE OC
       WHERE OC.NO_ORDEN = Cv_IdOrden
         AND OC.ID_TIPO_TRANSACCION = Cv_IdTipoOrden
         AND OC.NO_CIA = Cv_IdEmpresa;
    --
    --Lee los autorizadores
    CURSOR C_LeeAutorizador(Cv_IdEmpresa IN VARCHAR2,
                            Cv_IdOrden   IN VARCHAR2) IS
      SELECT ID_EMPLEADO
        FROM CO_FLUJO_APROBACION FA
       WHERE ID_EMPRESA = Cv_IdEmpresa
         AND ID_ORDEN = Cv_IdOrden
         AND TIPO_FLUJO IN ('AU', 'AP')
         AND ESTADO IN ('PA', 'PU')
       ORDER BY FA.SECUENCIA ASC;

    --Lee la hora para el saludo personalizado
    CURSOR C_LeeHora IS
      SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) HORA
        FROM DUAL;

    --Lee o aprobadores que estan en el flujo de aprobacion
    CURSOR C_LeeAprobadores(Cv_IdEmpresa IN VARCHAR2,
                            Cv_IdOrden   IN VARCHAR2) IS
      SELECT FA.ID_EMPRESA,
             FA.SECUENCIA_FLUJO,
             FA.ID_EMPLEADO,
             FA.FECHA,
             DECODE(FA.ESTADO, 'PA', 'POR APROBAR', 'AP', 'APROBADO', 'AU', 'AUTORIZADO', 'CO', 'POR CORREGIR', 'RZ', 'RECHAZADO', 'PU', 'POR AUTORIZAR') ESTADO,
             FA.ID_EMPLEADO_REEMPLAZO
        FROM CO_FLUJO_APROBACION FA
       WHERE ID_EMPRESA = Cv_IdEmpresa
         AND ID_ORDEN = Cv_IdOrden
         AND ESTADO <> 'EL'
       ORDER BY FA.SECUENCIA_FLUJO ASC;
    --

    Lv_NombreEmpleado      ARPLME.NOMBRE%TYPE := NULL;
    Lv_NombreEmpleadoReemp ARPLME.NOMBRE%TYPE := NULL;
    Lv_Notifica            TAPCIA.NOTIFICA%TYPE := NULL;
    Lv_DescripcionBien     ARINDA.DESCRIPCION%TYPE;
    Lv_DescripcionServ     TAPCPS.DESCRIPCION%TYPE;
    Lv_DescripcionTipoOC   GE_PARAMETROS.DESCRIPCION%TYPE := NULL;
    Lv_NombreProveedor     ARCPMP.NOMBRE%TYPE := NULL;
    Lv_IdAutorizador       CO_FLUJO_APROBACION.ID_EMPLEADO%TYPE := NULL;
    Lr_EmpleadosAut        ARPLME%ROWTYPE := NULL;
    Lr_EmpleadosIngresa    ARPLME%ROWTYPE := NULL;
    Lr_EmpleadoReemplazo   ARPLME%ROWTYPE := NULL;
    Lr_Orden               C_LeeOrden%ROWTYPE;
    Lr_Reemplazo           TAPHISTORICO_REEMPLAZOS%ROWTYPE := NULL;
    Ln_TotalCantidad       NUMBER(17, 2) := 0;
    Ln_TotalDetalle        NUMBER(17, 2) := 0;
    Ln_Hora                NUMBER(10) := 0;
    Lv_Caracter            VARCHAR2(1) := '&';
    Lv_Saludo              VARCHAR2(100) := NULL;
    Lv_Destinos            VARCHAR2(4000) := NULL;
    Lv_Copias              VARCHAR2(4000) := NULL;

    Lv_Mensaje CLOB;
    Lv_Detalle CLOB;

    Le_Error EXCEPTION;
  BEGIN
    --
    Lv_Notifica := NULL;
    IF C_LeeNotifica%ISOPEN THEN
      CLOSE C_LeeNotifica;
    END IF;
    OPEN C_LeeNotifica(Pv_IdEmpresa);
    FETCH C_LeeNotifica
      INTO Lv_Notifica;
    CLOSE C_LeeNotifica;
    --
    IF Lv_Notifica = 'S' THEN
      IF Pv_IdEmpresa IS NULL THEN
        Pv_MensajeError := 'El Código de Empresa no puede Se Nulo.';
        RAISE Le_Error;
      END IF;
      --
      IF Pv_IdOrden IS NULL THEN
        Pv_MensajeError := 'El Código de Orden no puede Se Nulo.';
        RAISE Le_Error;
      END IF;
      --
      IF Pv_IdTipoOrden IS NULL THEN
        Pv_MensajeError := 'El Código del Tipo de Orden no puede Se Nulo.';
        RAISE Le_Error;
      END IF;
      --
      IF C_LeeOrden%ISOPEN THEN
        CLOSE C_LeeOrden;
      END IF;
      OPEN C_LeeOrden(Pv_IdEmpresa, Pv_IdTipoOrden, Pv_IdOrden);
      FETCH C_LeeOrden
        INTO Lr_Orden;
      CLOSE C_LeeOrden;
      --
      IF C_LeeTiposOrdenes%ISOPEN THEN
        CLOSE C_LeeTiposOrdenes;
      END IF;
      OPEN C_LeeTiposOrdenes(Pv_IdEmpresa, Lr_Orden.ID_TIPO_TRANSACCION);
      FETCH C_LeeTiposOrdenes
        INTO Lv_DescripcionTipoOC;
      CLOSE C_LeeTiposOrdenes;
      --
      IF C_LeeProveedor%ISOPEN THEN
        CLOSE C_LeeProveedor;
      END IF;
      OPEN C_LeeProveedor(Pv_IdEmpresa, Lr_Orden.NO_PROVE);
      FETCH C_LeeProveedor
        INTO Lv_NombreProveedor;
      CLOSE C_LeeProveedor;
      --
      IF C_LeeHora%ISOPEN THEN
        CLOSE C_LeeHora;
      END IF;
      OPEN C_LeeHora;
      FETCH C_LeeHora
        INTO Ln_Hora;
      CLOSE C_LeeHora;
      IF Ln_Hora >= 0 AND Ln_Hora < 12 THEN
        --DIAS
        Lv_Saludo := 'Buenos Días';
      END IF;
      IF Ln_Hora >= 12 AND Ln_Hora < 19 THEN
        --TARDES
        Lv_Saludo := 'Buenas Tardes';
      END IF;
      IF Ln_Hora >= 19 AND Ln_Hora < 23 THEN
        --NOCHES
        Lv_Saludo := 'Buenas Noches';
      END IF;

      Lv_Mensaje       := '<html>
  <head>
    <title>HTML Editor Sample Page</title>
  </head>
  <body>
    <p>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>' || Lv_Saludo || '</strong></span></span></p>
    <p>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Se comunica que se ha ingresado una orden de compra de <strong>' || Lv_DescripcionTipoOC || '</strong>  <strong>No. ' || Lr_Orden.NO_ORDEN || '</strong> con <strong>Fecha Orden:</strong> ' || TO_CHAR(Lr_Orden.FECHA, 'DD/MM/YYYY') || ' para su <strong>Aprobación/Autorización</strong> correspondiente al proveedor <strong>' || Lr_Orden.NO_PROVE || ' - ' || Lv_NombreProveedor ||
                          '</strong> por un monto total de <strong>' || TO_CHAR(Lr_Orden.TOTAL, '999,999,999.00') || '</strong> con <strong>Fecha de Vencimiento:</strong> ' || TO_CHAR(Lr_Orden.FECHA_VENCE, 'DD/MM/YYYY') || '</span></span></p>
      <br>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>Observación:</strong>' || UPPER(Lr_Orden.OBSERV) || ' </span></span></p>
      <br>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>Detalle Orden</strong></span></span></p>
      <table border="1" cellpadding="1" cellspacing="1" style="width: 75%;">
      <tbody><tr bgcolor="#030137" style="text-align: center;">
          <td><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>PRODUCTO</strong></span></span></td>
          <td><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>DESCRIPCION</strong></span></span></td>
          <td><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>CANTIDAD</strong></span></span></td>
          <td><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>TOTAL</strong></span></span></td>
        </tr>';
      Lv_Detalle       := NULL;
      Ln_TotalCantidad := 0;
      Ln_TotalDetalle  := 0;
      FOR A IN C_LeeDetalleOrden(Pv_IdEmpresa, Pv_IdOrden) LOOP
        Lv_DescripcionBien := NULL;
        Lv_DescripcionServ := NULL;
        IF Lr_Orden.Id_Tipo_Transaccion IN ('BI', 'AB') THEN
          IF C_LeeBienes%ISOPEN THEN
            CLOSE C_LeeBienes;
          END IF;
          OPEN C_LeeBienes(Pv_IdEmpresa, A.NO_ARTI);
          FETCH C_LeeBienes
            INTO Lv_DescripcionBien;
          CLOSE C_LeeBienes;
        ELSIF Lr_Orden.Id_Tipo_Transaccion IN ('SE', 'RE') THEN
          IF C_LeeServicios%ISOPEN THEN
            CLOSE C_LeeServicios;
          END IF;
          OPEN C_LeeServicios(Pv_IdEmpresa, A.CODIGO_NI);
          FETCH C_LeeServicios
            INTO Lv_DescripcionServ;
          CLOSE C_LeeServicios;
        END IF;

        Lv_Detalle       := Lv_Detalle || '<tr>
          <td>' || NVL(A.NO_ARTI, A.CODIGO_NI) || '
            </td>
          <td>' || NVL(Lv_DescripcionBien, Lv_DescripcionServ) || '
            </td>
          <td style="text-align: right;">' || TO_CHAR(A.CANTIDAD, '999,999,999.00') || '
            </td>
          <td style="text-align: right;">' || TO_CHAR(((A.CANTIDAD * A.COSTO_UNI) + A.IMPUESTOS), '999,999,999.00') || '
            </td>
        </tr>';
        Ln_TotalCantidad := Ln_TotalCantidad + A.CANTIDAD;
        Ln_TotalDetalle  := Ln_TotalDetalle + ((A.CANTIDAD * A.COSTO_UNI) + A.IMPUESTOS);
      END LOOP;
      Lv_Detalle := Lv_Detalle || '<tr>
          <td>' || Lv_Caracter || 'nbsp;
            </td>
          <td style="text-align: right;"><strong>Totales</strong>
            </td>
          <td style="text-align: right;">' || TO_CHAR(Ln_TotalCantidad, '999,999,999.00') || '
            </td>
          <td style="text-align: right;">' || TO_CHAR(Ln_TotalDetalle, '999,999,999.00') || '
            </td>
        </tr>
        <tr>';

      Lv_Mensaje := Lv_Mensaje || Lv_Detalle || '</tbody>
    </table><br><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>Aprobadores/Autorizadores</strong> </span></span></p><p>';
      --Lv_Detalle :=NULL;
      Lv_Detalle := '<table border="1" cellpadding="1" cellspacing="1" >
      <tbody><tr bgcolor="#030137" style="text-align: center;">
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>SECUENCIA</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>NOMBRE EMPLEADO</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>NOMBRE EMPLEADO REEMPLAZO</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>ESTADO</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>FECHA</strong></span></span></span></td>
        </tr>';
      FOR A IN C_LeeAprobadores(Pv_IdEmpresa, Pv_IdOrden) LOOP
        --Lv_NombreEmpleado :=NULL;
        Lv_NombreEmpleado := PLK_CONSULTAS.PLF_NOMBRE_EMPLEADO(Pv_IdEmpresa, A.ID_EMPLEADO);
        IF A.ID_EMPLEADO_REEMPLAZO IS NOT NULL THEN
          Lv_NombreEmpleadoReemp := PLK_CONSULTAS.PLF_NOMBRE_EMPLEADO(Pv_IdEmpresa, A.ID_EMPLEADO_REEMPLAZO);
        END IF;
        IF A.FECHA IS NOT NULL THEN
          Lv_Detalle := Lv_Detalle || '<tr>
          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.SECUENCIA_FLUJO || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreEmpleado || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreEmpleadoReemp || Lv_Caracter || 'nbsp;</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.ESTADO || '</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || TO_CHAR(A.FECHA, 'DD/MM/YYYY HH24:MI:SS') || '</span></span>
            </td>
        </tr>';
        ELSE
          Lv_Detalle := Lv_Detalle || '<tr>
          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.SECUENCIA_FLUJO || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreEmpleado || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreEmpleadoReemp || Lv_Caracter || 'nbsp;</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.ESTADO || '</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_Caracter || 'nbsp;' || '</span></span>
            </td>
        </tr>';
        END IF;
      END LOOP;
      Lv_Mensaje := Lv_Mensaje || Lv_Detalle || '</tbody>
    </table><p>
    <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Atentamente</span></span></p>
    <p>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Soporte NAF</span></span></p>
  </body>
</html>';

      Lv_IdAutorizador := NULL;
      IF C_LeeAutorizador%ISOPEN THEN
        CLOSE C_LeeAutorizador;
      END IF;
      OPEN C_LeeAutorizador(Pv_IdEmpresa, Pv_IdOrden);
      FETCH C_LeeAutorizador
        INTO Lv_IdAutorizador;
      CLOSE C_LeeAutorizador;

      PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                     Lv_IdAutorizador,
                                     NULL,
                                     Lr_EmpleadosAut,
                                     Pv_CodigoError,
                                     Pv_MensajeError);

      IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      Pv_CodigoError  := NULL;
      Pv_MensajeError := NULL;
      --   Codigo Empleado Solicitante
      --Quien envia
      PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                     NULL,
                                     USER,
                                     Lr_EmpleadosIngresa,
                                     Pv_CodigoError,
                                     Pv_MensajeError);

      IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      --Consulto el reemplazo de la persona que va a autorizar
      PLK_CONSULTAS.CONSULTA_REEMPLAZO(Pv_IdEmpresa, --
                                       Lv_IdAutorizador,
                                       Lr_Reemplazo,
                                       Pv_CodigoError,
                                       Pv_MensajeError);

      --Pv_MensajeError := Lr_Reemplazo.NO_EMPLE_REEMP;
      IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      IF Lr_Reemplazo.NO_EMPLE_REEMP IS NOT NULL THEN
        --Lee el codigo del empleado si existe
        PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                       Lr_Reemplazo.NO_EMPLE_REEMP,
                                       NULL,
                                       Lr_EmpleadoReemplazo,
                                       Pv_CodigoError,
                                       Pv_MensajeError);

        IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END IF;
      Lv_Destinos := Lr_EmpleadosAut.Mail_Cia;
      Lv_Copias   := Lr_EmpleadosIngresa.Mail_Cia || ';' || Lr_EmpleadoReemplazo.Mail_Cia;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR('NAF',
            'CORREO_ORDEN.SIGUIENTE_APROBADOR',
            ' Lr_EmpleadosIngresa.Mail_Cia: '|| Lr_EmpleadosIngresa.Mail_Cia||
            ' Lv_Destinos: '||Lv_Destinos||
            ' Lv_Copias: '||Lv_Copias,
            GEK_CONSULTA.F_RECUPERA_LOGIN,
            SYSDATE,
            GEK_CONSULTA.F_RECUPERA_IP
                );

      --
      sys.utl_mail.send(sender     => Lr_EmpleadosIngresa.Mail_Cia,
                        recipients => Lv_Destinos, --Envia al autorizador o a su reemplazo
                        CC         => Lv_Copias,
                        subject    => 'SISTEMA NAF: APROBACION DE ORDEN DE COMPRA NO.' || Lr_Orden.NO_ORDEN,
                        mime_type  => 'text/html; charset=us-ascii',
                        MESSAGE    => Lv_Mensaje);

    END IF;

  EXCEPTION
    WHEN Le_Error THEN
        DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR('NAF',
                                            'CORREO_ORDEN.SIGUIENTE_APROBADOR',
                                            ' Le_Error ',
                                            GEK_CONSULTA.F_RECUPERA_LOGIN,
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP
                                            );
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en CORREO_ORDEN.SIGUIENTE_APROBADOR ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR('NAF',
                                            'CORREO_ORDEN.SIGUIENTE_APROBADOR',
                                            ' OTHERS '|| Pv_CodigoError ||' Pv_MensajeError: '||Pv_MensajeError,
                                            GEK_CONSULTA.F_RECUPERA_LOGIN,
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP
                                            );

  END SIGUIENTE_APROBADOR;
  --
  PROCEDURE CORRIGE_ANULA(Pv_IdEmpresa    IN VARCHAR2,
                          Pv_IdOrden      IN VARCHAR2,
                          Pv_IdTipoOrden  IN VARCHAR2,
                          Pv_Estado       IN VARCHAR2,
                          Pv_MotivoCORZ   IN VARCHAR2,
                          Pv_CodigoError  OUT VARCHAR2,
                          Pv_MensajeError OUT VARCHAR2) IS
    --Lee datos necesarios para presentar a orden de compra en el cuerpo del correo
    CURSOR C_LeeOrden(Cv_IdEmpresa IN VARCHAR2, --
                      Cv_IdOrden   IN VARCHAR2,
                      Cv_IdTipoTrx IN VARCHAR2) IS
      SELECT OC.NO_CIA,
             OC.ID_TIPO_TRANSACCION,
             OC.NO_PROVE,
             OC.NO_ORDEN,
             OC.ADJUDICADOR,
             OC.TOTAL,
             OC.OBSERV
        FROM TAPORDEE OC
       WHERE OC.NO_ORDEN = Cv_IdOrden
         AND OC.ID_TIPO_TRANSACCION = Cv_IdTipoTrx
         AND OC.NO_CIA = Cv_IdEmpresa;
    --Leo la hora del sistema para el saludo pesonalizado
    CURSOR C_LeeHora IS
      SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'HH24')) HORA
        FROM DUAL;
    --Lee nombre del proveedor
    CURSOR C_LeeProveedor(Cv_IdEmpresa   IN VARCHAR2,
                          Cv_IdProveedor IN VARCHAR2) IS
      SELECT P.NOMBRE
        FROM ARCPMP P
       WHERE NO_CIA = Cv_IdEmpresa
         AND NO_PROVE = Cv_IdProveedor;
    --
    -- Lee empleados aprobadores desde la tabla aprobadores-autorizadores que han procesado la orden de compra
    CURSOR C_LeeAprobadores(Cv_IdEmpresa IN VARCHAR2,
                            Cv_IdOrden   IN VARCHAR2) IS
      SELECT FA.ID_EMPRESA,
             FA.SECUENCIA_FLUJO,
             FA.ID_EMPLEADO,
             FA.FECHA,
             DECODE(FA.ESTADO, 'PA', 'POR APROBAR', 'AP', 'APROBADO', 'AU', 'AUTORIZADO', 'CO', 'POR CORREGIR', 'RZ', 'RECHAZADO', 'PU', 'POR AUTORIZAR') ESTADO,
             FA.ID_EMPLEADO_REEMPLAZO
        FROM CO_FLUJO_APROBACION FA
       WHERE ID_EMPRESA = Cv_IdEmpresa
         AND ID_ORDEN = Cv_IdOrden
         AND ESTADO IN ('AP', 'CO', 'RZ')
       ORDER BY FA.SECUENCIA_FLUJO ASC;

    --Se lee el detalle de la orden para presentar en el correo 
    CURSOR C_LeeDetalleOrden(Cv_IdEmpresa IN VARCHAR2,
                             Cv_IdOrden   IN VARCHAR2) IS
      SELECT DC.NO_CIA,
             DC.NO_ARTI,
             DC.CODIGO_NI,
             DC.CANTIDAD,
             DC.COSTO_UNI,
             DC.IMPUESTOS
        FROM TAPORDED DC
       WHERE DC.NO_CIA = Cv_IdEmpresa
         AND DC.NO_ORDEN = Cv_IdOrden;
    --Para recuperar la descripcion del servicio en el detalle d la orden
    --en el correo
    CURSOR C_LeeServicios(Cv_IdEmpresa  IN VARCHAR2,
                          Cv_IdServicio IN VARCHAR2) IS
      SELECT SE.DESCRIPCION
        FROM tapcps SE
       WHERE NO_CIA = Cv_IdEmpresa
         AND SE.CODIGO = Cv_IdServicio;
    --Para recuperar la descripcion del bien/producto en el detalle d la orden
    --en el correo
    CURSOR C_LeeBienes(Cv_IdEmpresa  IN VARCHAR2,
                       Cv_IdArticulo IN VARCHAR2) IS
      SELECT DA.DESCRIPCION
        FROM ARINDA DA
       WHERE NO_CIA = Cv_IdEmpresa
         AND DA.NO_ARTI = Cv_IdArticulo;

    Lv_NombreEmpleado      ARPLME.NOMBRE%TYPE := NULL;
    Lv_NombreEmpleadoReemp ARPLME.NOMBRE%TYPE := NULL;
    Lv_Notifica            TAPCIA.NOTIFICA%TYPE := NULL;
    Lv_NombreProveedor     ARCPMP.NOMBRE%TYPE := NULL;
    Lv_DescripcionBien     ARINDA.DESCRIPCION%TYPE;
    Lv_DescripcionServ     TAPCPS.DESCRIPCION%TYPE;
    Lr_Reemplazo           TAPHISTORICO_REEMPLAZOS%ROWTYPE := NULL;
    Lr_Orden               C_LeeOrden%ROWTYPE := NULL;
    Lr_EmpleadoReemplazo   ARPLME%ROWTYPE := NULL;
    Lr_EmpleadoActual      ARPLME%ROWTYPE := NULL;
    Lr_EmpleadoRecibe      ARPLME%ROWTYPE := NULL;
    Lr_EmpleadoEnvia       ARPLME%ROWTYPE := NULL;
    Lv_Asunto              VARCHAR2(200) := NULL;
    Lv_CorreosCopia        VARCHAR2(4000) := NULL;
    Lv_CorreosCopiaReemp   VARCHAR2(4000) := NULL;
    Lv_CorreoDestina       VARCHAR2(100) := NULL;
    Lv_Saludo              VARCHAR2(200) := NULL;
    Lv_DescripcionTipoOC   VARCHAR2(200) := NULL;
    Lv_TipoDestinoOrden    VARCHAR2(100) := NULL;
    Lv_Caracter            VARCHAR2(1) := '&';
    Ln_Hora                NUMBER(10) := 0;
    Ln_TotalCantidad       NUMBER(17, 2) := 0;
    Ln_TotalDetalle        NUMBER(17, 2) := 0;
    Lv_Mensaje             CLOB;
    Lv_Detalle             CLOB;

    Le_Error EXCEPTION;
  BEGIN
    IF C_LeeNotifica%ISOPEN THEN
      CLOSE C_LeeNotifica;
    END IF;
    Lv_Notifica := NULL;

    OPEN C_LeeNotifica(Pv_IdEmpresa);
    FETCH C_LeeNotifica
      INTO Lv_Notifica;
    CLOSE C_LeeNotifica;
    IF Lv_Notifica = 'S' THEN
      IF Pv_IdEmpresa IS NULL THEN
        Pv_MensajeError := 'El Código de Empresa no puede ser Nulo.';
        RAISE Le_Error;
      END IF;
      --
      IF Pv_IdOrden IS NULL THEN
        Pv_MensajeError := 'El Código de Orden no puede ser Nulo.';
        RAISE Le_Error;
      END IF;
      --
      IF Pv_IdTipoOrden IS NULL THEN
        Pv_MensajeError := 'El Código del Tipo de Orden no puede ser Nulo.';
        RAISE Le_Error;
      END IF;
      --
      IF C_LeeHora%ISOPEN THEN
        CLOSE C_LeeHora;
      END IF;
      OPEN C_LeeHora;
      FETCH C_LeeHora
        INTO Ln_Hora;
      CLOSE C_LeeHora;
      IF Ln_Hora >= 0 AND Ln_Hora < 12 THEN
        --DIAS
        Lv_Saludo := 'Buenos Días';
      END IF;
      IF Ln_Hora >= 12 AND Ln_Hora < 19 THEN
        --TARDES
        Lv_Saludo := 'Buenas Tardes';
      END IF;
      IF Ln_Hora >= 19 AND Ln_Hora < 23 THEN
        --NOCHES
        Lv_Saludo := 'Buenas Noches';
      END IF;
      --
      IF C_LeeOrden%ISOPEN THEN
        CLOSE C_LeeOrden;
      END IF;
      OPEN C_LeeOrden(Pv_IdEmpresa, Pv_IdOrden, Pv_IdTipoOrden);
      FETCH C_LeeOrden
        INTO Lr_Orden;
      CLOSE C_LeeOrden;
      IF C_LeeTiposOrdenes%ISOPEN THEN
        CLOSE C_LeeTiposOrdenes;
      END IF;
      --
      OPEN C_LeeTiposOrdenes(Pv_IdEmpresa, Lr_Orden.ID_TIPO_TRANSACCION);
      FETCH C_LeeTiposOrdenes
        INTO Lv_DescripcionTipoOC;
      CLOSE C_LeeTiposOrdenes;
      --
      IF C_LeeProveedor%ISOPEN THEN
        CLOSE C_LeeProveedor;
      END IF;
      OPEN C_LeeProveedor(Pv_IdEmpresa, Lr_Orden.NO_PROVE);
      FETCH C_LeeProveedor
        INTO Lv_NombreProveedor;
      CLOSE C_LeeProveedor;
      --
      IF Pv_Estado = 'O' THEN
        Lv_Asunto           := 'SISTEMA NAF: ORDEN No.' || Lr_Orden.No_Orden || ', Estado O(POR CORREGIR)';
        Lv_TipoDestinoOrden := 'CORRECION';
      ELSIF Pv_Estado = 'X' THEN
        Lv_Asunto           := 'SISTEMA NAF: ORDEN No.' || Lr_Orden.No_Orden || ', Estado X(ANULADA)';
        Lv_TipoDestinoOrden := 'ANULADA';
      END IF;
      --
      --
      Lv_Mensaje       := '<html>
        <head>
          <title>HTML Editor Sample Page</title>
        </head>
        <body>
          <p>
            <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>' || Lv_Saludo || '</strong></span></span></p>
          <p>
            <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Se comunica que la orden de compra de <strong>' || Lv_DescripcionTipoOC || '</strong>  <strong>No. ' || Lr_Orden.NO_ORDEN || '</strong> esta en estado <strong>' || Lv_TipoDestinoOrden || '</strong> correspondiente al proveedor <strong>' || Lr_Orden.NO_PROVE || ' - ' || Lv_NombreProveedor || '</strong> por un monto total de <strong>' ||
                          TO_CHAR(Lr_Orden.TOTAL, '999,999,999.00') || '</strong> </span></span></p>
            <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>MOTIVO ' || Lv_TipoDestinoOrden || ':</strong>' || Pv_MotivoCORZ || ' </span></span></p>
      <br>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>Observación:</strong>' || UPPER(Lr_Orden.OBSERV) || ' </span></span></p>
      <br>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>Detalle Orden</strong></span></span></p>
      <table border="1" cellpadding="1" cellspacing="1" style="width: 75%;">
      <tbody><tr bgcolor="#030137" style="text-align: center;">
          <td><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>PRODUCTO</strong></span></span></td>
          <td><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>DESCRIPCION</strong></span></span></td>
          <td><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>CANTIDAD</strong></span></span></td>
          <td><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>TOTAL</strong></span></span></td>
        </tr>';
      Lv_Detalle       := NULL;
      Ln_TotalCantidad := 0;
      Ln_TotalDetalle  := 0;
      FOR A IN C_LeeDetalleOrden(Pv_IdEmpresa, Pv_IdOrden) LOOP
        Lv_DescripcionBien := NULL;
        Lv_DescripcionServ := NULL;
        IF Lr_Orden.Id_Tipo_Transaccion IN ('BI', 'AB') THEN
          IF C_LeeBienes%ISOPEN THEN
            CLOSE C_LeeBienes;
          END IF;
          OPEN C_LeeBienes(Pv_IdEmpresa, A.NO_ARTI);
          FETCH C_LeeBienes
            INTO Lv_DescripcionBien;
          CLOSE C_LeeBienes;
        ELSIF Lr_Orden.Id_Tipo_Transaccion IN ('SE', 'RE') THEN
          IF C_LeeServicios%ISOPEN THEN
            CLOSE C_LeeServicios;
          END IF;
          OPEN C_LeeServicios(Pv_IdEmpresa, A.CODIGO_NI);
          FETCH C_LeeServicios
            INTO Lv_DescripcionServ;
          CLOSE C_LeeServicios;
        END IF;

        Lv_Detalle       := Lv_Detalle || '<tr>
          <td>' || NVL(A.NO_ARTI, A.CODIGO_NI) || '
            </td>
          <td>' || NVL(Lv_DescripcionBien, Lv_DescripcionServ) || '
            </td>
          <td style="text-align: right;">' || TO_CHAR(A.CANTIDAD, '999,999,999.00') || '
            </td>
          <td style="text-align: right;">' || TO_CHAR(((A.CANTIDAD * A.COSTO_UNI) + A.IMPUESTOS), '999,999,999.00') || '
            </td>
        </tr>';
        Ln_TotalCantidad := Ln_TotalCantidad + A.CANTIDAD;
        Ln_TotalDetalle  := Ln_TotalDetalle + ((A.CANTIDAD * A.COSTO_UNI) + A.IMPUESTOS);
      END LOOP;
      Lv_Detalle := Lv_Detalle || '<tr>
          <td>' || Lv_Caracter || 'nbsp;
            </td>
          <td style="text-align: right;"><strong>Totales</strong>
            </td>
          <td style="text-align: right;">' || TO_CHAR(Ln_TotalCantidad, '999,999,999.00') || '
            </td>
          <td style="text-align: right;">' || TO_CHAR(Ln_TotalDetalle, '999,999,999.00') || '
            </td>
        </tr>
        <tr>';

      Lv_Mensaje := Lv_Mensaje || Lv_Detalle || '</tbody>
    </table><br><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>Aprobadores/Autorizadores</strong> </span></span></p><p>';
      --Lv_Detalle :=NULL;
      Lv_Detalle := '<table border="1" cellpadding="1" cellspacing="1" >
      <tbody><tr bgcolor="#030137" style="text-align: center;">
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>SECUENCIA</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>NOMBRE EMPLEADO</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>NOMBRE EMPLEADO REEMPLAZO</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>ESTADO</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>FECHA</strong></span></span></span></td>
        </tr>';
      FOR A IN C_LeeAprobadores(Pv_IdEmpresa, Pv_IdOrden) LOOP
        --Lv_NombreEmpleado :=NULL;
        Lv_NombreEmpleado := PLK_CONSULTAS.PLF_NOMBRE_EMPLEADO(Pv_IdEmpresa, --
                                                               A.ID_EMPLEADO);
        IF A.ID_EMPLEADO_REEMPLAZO IS NOT NULL THEN
          Lv_NombreEmpleadoReemp := PLK_CONSULTAS.PLF_NOMBRE_EMPLEADO(Pv_IdEmpresa, --
                                                                      A.ID_EMPLEADO_REEMPLAZO);
        END IF;
        IF A.FECHA IS NOT NULL THEN
          Lv_Detalle := Lv_Detalle || '<tr>
          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.SECUENCIA_FLUJO || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreEmpleado || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreEmpleadoReemp || Lv_Caracter || 'nbsp;</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.ESTADO || '</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || TO_CHAR(A.FECHA, 'DD/MM/YYYY HH24:MI:SS') || '</span></span>
            </td>
        </tr>';
        ELSE
          Lv_Detalle := Lv_Detalle || '<tr>
          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.SECUENCIA_FLUJO || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreEmpleado || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreEmpleadoReemp || Lv_Caracter || 'nbsp;</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.ESTADO || '</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_Caracter || 'nbsp;' || '</span></span>
            </td>
        </tr>';
        END IF;
      END LOOP;
      Lv_Mensaje := Lv_Mensaje || Lv_Detalle || '</tbody>
    </table><p>
    <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Atentamente</span></span></p>
    <p>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Soporte NAF</span></span></p>
  </body>
</html>';
      PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                     NULL,
                                     USER,
                                     Lr_EmpleadoEnvia,
                                     Pv_CodigoError,
                                     Pv_MensajeError);

      IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      ---
      FOR A IN C_LeeAprobadores(Pv_IdEmpresa, Lr_Orden.NO_ORDEN) LOOP
        Lr_EmpleadoRecibe := NULL;
        PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                       A.ID_EMPLEADO,
                                       NULL,
                                       Lr_EmpleadoRecibe,
                                       Pv_CodigoError,
                                       Pv_MensajeError);

        IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        Lr_EmpleadoActual := NULL; --Esta validacion  funciona para que el propio usuario no reciba el mismo mail dos veces
        PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                       NULL,
                                       USER,
                                       Lr_EmpleadoActual,
                                       Pv_CodigoError,
                                       Pv_MensajeError);

        IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        IF NVL(Lr_EmpleadoActual.Mail_Cia, 'X') <> NVL(Lr_EmpleadoRecibe.Mail_Cia, 'Z') THEN
          --Lv_CorreosCopia := Lv_CorreosCopia || ';' || Lr_EmpleadoRecibe.Mail; --Copia AutorizadorRes
          Lv_CorreosCopia := Lv_CorreosCopia || ';' || Lr_EmpleadoRecibe.Mail_Cia; --Copia AutorizadorRes
        END IF;
        --Verificar los remplazos de empleados
        --Consulto el reemplazo de los aprobadores
        Lr_Reemplazo := NULL;
        PLK_CONSULTAS.CONSULTA_REEMPLAZO(Pv_IdEmpresa, --
                                         A.ID_EMPLEADO,
                                         Lr_Reemplazo,
                                         Pv_CodigoError,
                                         Pv_MensajeError);
        --
        IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        IF Lr_Reemplazo.NO_EMPLE_REEMP IS NOT NULL THEN
          Lr_EmpleadoReemplazo := NULL;
          --Lee el codigo del empleado si existe
          PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                         Lr_Reemplazo.NO_EMPLE_REEMP,
                                         NULL,
                                         Lr_EmpleadoReemplazo,
                                         Pv_CodigoError,
                                         Pv_MensajeError);

          IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
          --Lv_CorreosCopiaReemp := Lv_CorreosCopiaReemp || ';' || Lr_EmpleadoReemplazo.MAIL;
          Lv_CorreosCopiaReemp := Lv_CorreosCopiaReemp || ';' || Lr_EmpleadoReemplazo.Mail_Cia;
          Lv_CorreosCopia := Lv_CorreosCopia || Lv_CorreosCopiaReemp;--21082014
        END IF;
        --
      --
      END LOOP;
      --
      --
      --Lv_CorreosCopia := Lv_CorreosCopia || Lv_CorreosCopiaReemp; 21082014
      --
      PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                     Lr_Orden.Adjudicador,
                                     NULL,
                                     Lr_EmpleadoRecibe,
                                     Pv_CodigoError,
                                     Pv_MensajeError);

      IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;

      --Lv_CorreoDestina := Lr_EmpleadoRecibe.Mail; --Copia Solicitante
      Lv_CorreoDestina := Lr_EmpleadoRecibe.Mail_Cia; --Copia Solicitante

      --
      Lr_Reemplazo := NULL;
      --Consulto el reemplazo de la persona solicitante
      PLK_CONSULTAS.CONSULTA_REEMPLAZO(Pv_IdEmpresa, --
                                       Lr_Orden.ADJUDICADOR,
                                       Lr_Reemplazo,
                                       Pv_CodigoError,
                                       Pv_MensajeError);

      IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      IF Lr_Reemplazo.NO_EMPLE_REEMP IS NOT NULL THEN
        Lr_EmpleadoReemplazo := NULL;
        --Lee el codigo del empleado si existe
        PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                       Lr_Reemplazo.NO_EMPLE_REEMP,
                                       NULL,
                                       Lr_EmpleadoReemplazo,
                                       Pv_CodigoError,
                                       Pv_MensajeError);

        IF Pv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        Lv_CorreoDestina := Lv_CorreoDestina || ';' || Lr_EmpleadoReemplazo.Mail_Cia;--21082014
      END IF;

      --Lv_CorreoDestina := Lv_CorreoDestina || ';' || Lr_EmpleadoReemplazo.MAIL; --Corre Solicitante o su reemplazo
      --Lv_CorreoDestina := Lv_CorreoDestina || ';' || Lr_EmpleadoReemplazo.Mail_Cia; --Corre Solicitante o su reemplazo 21082014

    DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR('NAF',
                                            'CORREO_ORDEN.CORRIGE_ANULA',
                                            ' Lr_EmpleadoEnvia.Mail_Cia: '|| Lr_EmpleadoEnvia.Mail_Cia||
                                            ' Lv_CorreoDestina: '||Lv_CorreoDestina||
                                            ' Lv_CorreosCopia: '||Lv_CorreosCopia,
                                            GEK_CONSULTA.F_RECUPERA_LOGIN,
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP
                                            );


      sys.utl_mail.send(sender     => Lr_EmpleadoEnvia.Mail_Cia,--Lr_EmpleadoEnvia.MAIL, --
                        recipients => Lv_CorreoDestina,
                        CC         => Lr_EmpleadoEnvia.Mail_Cia || Lv_CorreosCopia,--Lr_EmpleadoEnvia.MAIL || Lv_CorreosCopia,
                        subject    => Lv_Asunto,
                        mime_type  => 'text/html; charset=us-ascii',
                        MESSAGE    => Lv_Mensaje);
    END IF;
  EXCEPTION
    WHEN Le_Error THEN
    DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR('NAF',
                                            'CORREO_ORDEN.CORRIGE_ANULA',
                                            ' Le_Error ',
                                            GEK_CONSULTA.F_RECUPERA_LOGIN,
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP
                                            );
      RETURN;
    WHEN OTHERS THEN
      Pv_CodigoError  := SQLCODE;
      Pv_MensajeError := 'Error No Controlado en CORREO_ORDEN.CORRIGE_ANULA ' || SQLERRM;
      DB_GENERAL.GNRLPCK_UTIL .INSERT_ERROR('NAF',
                                            'CORREO_ORDEN.CORRIGE_ANULA',
                                            ' OTHERS '|| Pv_CodigoError ||' Pv_MensajeError: '||Pv_MensajeError,
                                            GEK_CONSULTA.F_RECUPERA_LOGIN,
                                            SYSDATE,
                                            GEK_CONSULTA.F_RECUPERA_IP
                                            );

  END CORRIGE_ANULA;
  --
  --
  PROCEDURE NOTIFICA_PENDIENTES IS
    --
    --Consulta los documentos pendienets por aprobador/autorizador
    CURSOR C_LeePendientesEmpleado(Cv_Idempresa IN VARCHAR) IS
      SELECT DISTINCT F.ID_EMPLEADO
        FROM TAPORDEE            A,
             CO_FLUJO_APROBACION F
       WHERE A.NO_ORDEN = F.ID_ORDEN
         AND A.NO_CIA = F.ID_EMPRESA
         AND A.ESTADO = 'P'
         AND F.ESTADO IN ('PA', 'PU')
         AND (TRUNC(SYSDATE) - TRUNC(A.FECHA)) >= 1
         AND A.NO_CIA = Cv_Idempresa;
    --Cursor que lee los documentos pendientes segun el usuario conectado
    CURSOR C_LeePendientes(Cv_IdEmpresa  IN VARCHAR2,
                           Cv_IdEmpleado IN VARCHAR) IS

      SELECT D.NO_ORDEN,
             D.ESTADO,
             D.ADJUDICADOR,
             E.ID_EMPLEADO,
             D.NO_CIA,
             D.FECHA,
             D.NO_PROVE
        FROM TAPORDEE D,
             (SELECT B.ID_EMPRESA,
                     B.ID_ORDEN,
                     B.ID_EMPLEADO
                FROM CO_FLUJO_APROBACION B,
                     (SELECT ID_EMPRESA,
                             SECUENCIA,
                             ID_EMPLEADO,
                             ESTADO,
                             SECUENCIA_FLUJO,
                             ID_ORDEN,
                             TIPO_FLUJO
                        FROM CO_FLUJO_APROBACION
                       WHERE ID_EMPLEADO IN (Cv_IdEmpleado)
                         AND ESTADO IN ('PU', 'PA')) A
               WHERE A.ID_ORDEN = B.ID_ORDEN
                 AND A.ID_EMPRESA = B.ID_EMPRESA
                 AND (A.SECUENCIA_FLUJO - 1 = B.SECUENCIA_FLUJO)
                 AND (B.ESTADO = 'AP')
                 AND B.ID_EMPRESA = Cv_IdEmpresa
                 AND B.ESTADO NOT IN ('EL')
              UNION
              SELECT C.ID_EMPRESA,
                     C.ID_ORDEN,
                     C.ID_EMPLEADO
                FROM CO_FLUJO_APROBACION C
               WHERE C.ID_EMPLEADO IN (Cv_IdEmpleado)
                 AND SECUENCIA_FLUJO = 1
                 AND C.ID_EMPRESA = Cv_IdEmpresa
                 AND C.ESTADO IN ('PA', 'PU')) E
       WHERE D.NO_ORDEN = E.ID_ORDEN
         AND D.NO_CIA = E.ID_EMPRESA
         AND D.ESTADO = 'P'
         AND (TRUNC(SYSDATE) - TRUNC(D.FECHA)) >= 1;  
    --Leeo el nombre del proveedor
    CURSOR C_LeeProveedor(Cv_IdEmpresa   IN VARCHAR2,
                          Cv_IdProveedor IN VARCHAR2) IS
      SELECT P.NOMBRE
        FROM ARCPMP P
       WHERE NO_CIA = Cv_IdEmpresa
         AND NO_PROVE = Cv_IdProveedor;
    --Lee ciertos datos de la orden para el cuerpo del correo
    CURSOR C_LeeOrden(Cv_IdEmpresa IN VARCHAR2,
                      Cv_IdOrden   IN VARCHAR2) IS
      SELECT OC.OBSERV,
             OC.FECHA,
             OC.TOTAL
        FROM TAPORDEE OC
       WHERE NO_CIA = Cv_IdEmpresa
         AND NO_ORDEN = Cv_IdOrden;
    --Lee la empresa que pueden notificar ordenes de compras
    CURSOR C_LeeNotifica IS
      SELECT E.NO_CIA
        FROM TAPCIA E
       WHERE NVL(E.NOTIFICA, 'N') = 'S';

    Lv_NombreProveedor   ARCPMP.NOMBRE%TYPE := NULL;
    Lr_Orden             C_LeeOrden%ROWTYPE := NULL;
    Lr_EmpleadosAut      ARPLME%ROWTYPE := NULL;
    Lr_EmpleadoReemplazo ARPLME%ROWTYPE := NULL;
    Lr_Reemplazo         TAPHISTORICO_REEMPLAZOS%ROWTYPE := NULL;
    Lv_CorreoSolicitante VARCHAR2(4000) := NULL;
    Lv_CodigoError       VARCHAR2(30) := NULL;
    Lv_MensajeError      VARCHAR2(4000) := NULL;
    Lv_Saludo            VARCHAR2(200) := NULL;
    Lv_Destinatarios     VARCHAR2(4000) := NULL;
    Lv_Caracter          VARCHAR2(1) := '&';
    Ln_Hora              NUMBER(10) := 0;
    Ln_DiasPendientes    NUMBER(10) := 0;
    Ln_TotalOrdenes      NUMBER(17, 2) := 0;
    Lv_Mensaje           CLOB;
    Lv_Detalle           CLOB;
    Le_Error EXCEPTION;

  BEGIN
    FOR C IN C_LeeNotifica LOOP
      FOR B IN C_LeePendientesEmpleado(C.NO_CIA) LOOP
        Lv_CorreoSolicitante := NULL;
        --\
        IF C_LeeHora%ISOPEN THEN
          CLOSE C_LeeHora;
        END IF;
        OPEN C_LeeHora;
        FETCH C_LeeHora
          INTO Ln_Hora;
        CLOSE C_LeeHora;
        IF Ln_Hora >= 0 AND Ln_Hora < 12 THEN
          --DIAS
          Lv_Saludo := 'Buenos Días';
        END IF;
        IF Ln_Hora >= 12 AND Ln_Hora < 19 THEN
          --TARDES
          Lv_Saludo := 'Buenas Tardes';
        END IF;
        IF Ln_Hora >= 19 AND Ln_Hora < 23 THEN
          --NOCHES
          Lv_Saludo := 'Buenas Noches';
        END IF;

        --No Aplica por solicitud de NNAVARRETE
        /*FOR A IN C_LeePendientes(Pv_IdEmpresa, B.ID_EMPLEADO) LOOP
          Lr_Empleados := NULL;
          PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                         A.ADJUDICADOR,
                                         NULL,
                                         Lr_Empleados, --CORREO SOLICITANTE
                                         Lv_CodigoError,
                                         Lv_MensajeError);
          --
          Lv_CorreoSolicitante := Lv_CorreoSolicitante || Lr_Empleados.MAIL || ';'; --CORREOS SOLICITANTES
        END LOOP;*/
        --
        Lv_Mensaje := '<html>
        <head>
          <title>HTML Editor Sample Page</title>
        </head>
        <body>
          <p>
            <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>' || Lv_Saludo || '</strong></span></span></p>
          <p>
            <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Se comunica que las Ordenes de Compras se que se detallan a continuaci' || Lv_Caracter || 'oacute;n estan pendientes con m' || Lv_Caracter || 'aacute;s de 1 dia de Aprobaci' || Lv_Caracter || 'oacute;n/Autorizaci' || Lv_Caracter || 'oacute;n' || '</span></span></p>';

        --
        Lv_Detalle := '<table border="1" cellpadding="1" cellspacing="1" style="width: 75%;">
      <tbody><tr bgcolor="#030137" style="text-align: center;">
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>NO. ORDEN</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>PROVEEDOR</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>NOMBRE PROVEEDOR</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>FECHA</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>DIAS PENDIENTES</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>OBSERVACION</strong></span></span></span></td>
          <td><span style="font-size:12px;"><span style="color:#ffffff;"><span style="font-family:arial,helvetica,sans-serif;"><strong>TOTAL ORDEN</strong></span></span></span></td>
        </tr>';

        FOR A IN C_LeePendientes(C.NO_CIA, B.ID_EMPLEADO) LOOP
          Lv_NombreProveedor := NULL;
          IF C_LeeProveedor%ISOPEN THEN
            CLOSE C_LeeProveedor;
          END IF;
          OPEN C_LeeProveedor(C.NO_CIA, A.NO_PROVE);
          FETCH C_LeeProveedor
            INTO Lv_NombreProveedor;
          CLOSE C_LeeProveedor;
          --
          IF C_LeeOrden%ISOPEN THEN
            CLOSE C_LeeOrden;
          END IF;
          OPEN C_LeeOrden(C.NO_CIA, A.NO_ORDEN);
          FETCH C_LeeOrden
            INTO Lr_Orden;
          CLOSE C_LeeOrden;
          --
          Ln_TotalOrdenes := Ln_TotalOrdenes + Lr_Orden.TOTAL;
          --
          Ln_DiasPendientes  := TRUNC(SYSDATE) - TRUNC(Lr_Orden.FECHA);
          Lv_Detalle         := Lv_Detalle || '<tr>
          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.NO_ORDEN || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || A.NO_PROVE || '</span></span>
            </td>
<td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_NombreProveedor || '</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lr_Orden.FECHA || '</span></span>
            </td>
          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Ln_DiasPendientes || '</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lr_Orden.OBSERV || '</span></span>
            </td>
            <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || TO_CHAR(Lr_Orden.TOTAL, '999,999,999.00') || '</span></span>
            </td>
        </tr>';
          Ln_DiasPendientes  := 0;
          Lv_NombreProveedor := NULL;

        END LOOP;
        Lv_Detalle := Lv_Detalle || '<tr>
          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_Caracter || 'nbsp;' || '</span></span>
            </td>

          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_Caracter || 'nbsp;' || '</span></span>
            </td>
          <td><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_Caracter || 'nbsp;' || '</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_Caracter || 'nbsp;' || '</span></span>
            </td>
          <td style="text-align: center;"><span style="font-size:12px;"><span style="font-family:arial,helvetica,sans-serif;">' || Lv_Caracter || 'nbsp;' || '</span></span>
            </td>
          <td style="text-align: right;"><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>' || 'Total' || '</strong></span></span>
                      </td>
          <td style="text-align: right;"><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;"><strong>' || TO_CHAR(Ln_TotalOrdenes, '999,999,999.00') || '</strong></span></span>
            </td>

        </tr>';

        Lv_Mensaje := Lv_Mensaje || Lv_Detalle || '</tbody>
    </table><p>
    <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Atentamente</span></span></p>
    <p>
      <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">Soporte NAF</span></span></p>
  </body>
</html>';

        IF Ln_TotalOrdenes > 0 THEN
          --
          Lr_Reemplazo := NULL;
          --Consulto el reemplazo de la persona solicitante
          PLK_CONSULTAS.CONSULTA_REEMPLAZO(C.NO_CIA, --
                                           B.ID_EMPLEADO,
                                           Lr_Reemplazo,
                                           Lv_CodigoError,
                                           Lv_MensajeError);

          IF Lv_CodigoError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
          --
          IF Lr_Reemplazo.NO_EMPLE_REEMP IS NOT NULL THEN
            Lr_EmpleadoReemplazo := NULL;
            --Lee el codigo del empleado si existe
            PLK_CONSULTAS.PLP_REG_EMPLEADO(C.NO_CIA, --
                                           Lr_Reemplazo.NO_EMPLE_REEMP,
                                           NULL,
                                           Lr_EmpleadoReemplazo,
                                           Lv_CodigoError,
                                           Lv_MensajeError);

            IF Lv_CodigoError IS NOT NULL OR Lv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
          END IF;
          --
          PLK_CONSULTAS.PLP_REG_EMPLEADO(C.NO_CIA, --
                                         B.ID_EMPLEADO,
                                         NULL,
                                         Lr_EmpleadosAut, --CORREO AUTORIZADOR
                                         Lv_CodigoError,
                                         Lv_MensajeError);
          --Lv_Destinatarios := Lr_EmpleadosAut.MAIL || ';' || Lr_EmpleadoReemplazo.MAIL;
          Lv_Destinatarios := Lr_EmpleadosAut.Mail_Cia || ';' || Lr_EmpleadoReemplazo.Mail_Cia;
          --

          sys.utl_mail.send(sender     => 'naf@telconet.ec', --
                            recipients => Lv_Destinatarios, --'emunoz@telconet.ec',
                            CC         => Lv_CorreoSolicitante, --'esmupru@gmail.com',
                            subject    => 'SISTEMA NAF: ORDEN(ES) COMPRA(S) PENDIENTES DE APROBAR/AUTORIZAR.' || Lr_EmpleadosAut.Nombre,
                            mime_type  => 'text/html; charset=us-ascii',
                            MESSAGE    => Lv_Mensaje);
        END IF;
        Lv_CorreoSolicitante := NULL;
        Lr_EmpleadosAut      := NULL;
        Ln_TotalOrdenes      := 0;
      END LOOP;
    END LOOP;
  EXCEPTION
    WHEN Le_Error THEN
      sys.utl_mail.send(sender     => 'naf@telconet.ec', --
                        recipients => 'sfernandez@telconet.ec',
                        CC         => 'banton@telconet.ec',
                        subject    => 'SOPORTE NAF: ERROR EN CORREO_ORDEN.NOTIFICA_PENDIENTES',
                        mime_type  => 'text/html; charset=us-ascii',
                        MESSAGE    => Lv_CodigoError || ' - ' || Lv_MensajeError);
    WHEN OTHERS THEN
      Lv_CodigoError  := SQLCODE;
      Lv_MensajeError := 'Error No Controlado en CORREO_ORDEN.NOTIFICA_PENDIENTES ' || SQLERRM;
      sys.utl_mail.send(sender     => 'naf@telconet.ec', --
                        recipients => 'sfernandez@telconet.ec',
                        CC         => 'banton@telconet.ec',
                        subject    => 'SOPORTE NAF: ERROR EN NO CONTROLADO CORREO_ORDEN.NOTIFICA_PENDIENTES',
                        mime_type  => 'text/html; charset=us-ascii',
                        MESSAGE    => Lv_CodigoError || ' - ' || Lv_MensajeError);
  END NOTIFICA_PENDIENTES;
  --
  --
  PROCEDURE P_NOTIFICA_AUTORIZACION ( Pr_DatosOC NAF47_TNET.CORREO_ORDEN.Gr_DatosOrdenCompra) IS
    --
    -- cursor que recupera el correo del solicitante
    -- costo query: 2
    CURSOR C_DATOS_SOLICITANTE IS
      SELECT MAIL_CIA
      FROM NAF47_TNET.ARPLME
      WHERE NO_EMPLE = Pr_DatosOC.NO_SOLICITANTE
      AND NO_CIA = Pr_DatosOC.NO_CIA;

    CURSOR C_DATOS_CREA IS
      SELECT MAIL_CIA
      FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS
      WHERE LOGIN_EMPLE = LOWER(Pr_DatosOC.USUARIO)
      AND NO_CIA = Pr_DatosOC.NO_CIA;

    --JXZURITA email generico [11/11/2022] [INICIO]
    CURSOR C_DATOS_SOLICITANTE_DAT(CN_NO_EMPLE NAF47_TNET.ARPLME.NO_EMPLE%TYPE,
                            CV_NO_CIA      NAF47_TNET.ARPLME.no_cia%type) IS
     SELECT MAIL_CIA
      FROM NAF47_TNET.ARPLME
      WHERE NO_EMPLE = CN_NO_EMPLE
      AND NO_CIA = CV_NO_CIA;

    CURSOR C_DATOS_CREA_DAT(CN_NO_EMPLE NAF47_TNET.ARPLME.NO_EMPLE%TYPE,
                            CV_NO_CIA      NAF47_TNET.ARPLME.no_cia%type) IS
      SELECT MAIL_CIA
      FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS
      --JXZURITA email generico [06/12/2022] [INICIO]
      WHERE no_emple = CN_NO_EMPLE
      --JXZURITA email generico [06/12/2022] [FIN]
      AND NO_CIA = Pr_DatosOC.NO_CIA;

    ln_no_empleado       number;
    --JXZURITA email generico [11/11/2022] [FIN]
    --
    Lr_DatosEmpresa      C_LeeNotifica%ROWTYPE;
    Lr_Solicitante       C_DATOS_SOLICITANTE%ROWTYPE;
    Lr_DatosCrea         C_DATOS_CREA%ROWTYPE;
    --
    Lv_Saludo            VARCHAR2(200);
    Lv_DescripcionTipoOC NAF47_TNET.GE_PARAMETROS.DESCRIPCION%TYPE := NULL;
    Lv_NombreProveedor   NAF47_TNET.ARCPMP.NOMBRE%TYPE := NULL;
    Lv_TextoCorreo       VARCHAR2(3000);
    Lv_MensajeCorreo     CLOB;
    Lv_DescripcionBien   NAF47_TNET.ARINDA.DESCRIPCION%TYPE;
    Lv_DescripcionServ   NAF47_TNET.TAPCPS.DESCRIPCION%TYPE;
    Lv_Caracter          VARCHAR2(1) := '&';
    Lv_MensajeError      VARCHAR2(3000);
    --
    Ln_Hora              NUMBER(2) := 0;
    Ln_TotalCantidad     NUMBER := 0;
    Ln_TotalDetalle      NUMBER := 0;
    --
    Le_Error             EXCEPTION;
    Ln_Error             NUMBER := 10;
    --
  BEGIN
    --
    IF C_LeeNotifica%ISOPEN THEN
      CLOSE C_LeeNotifica;
    END IF;
    OPEN C_LeeNotifica(Pr_DatosOC.NO_CIA);
    FETCH C_LeeNotifica INTO Lr_DatosEmpresa;
    CLOSE C_LeeNotifica;
    --
    IF Lr_DatosEmpresa.Notifica_Correo = 'N' THEN
      RETURN;
    END IF;
    --
    Ln_Error := 20;
    -- se recupera descripcion tipo orden de compra
    IF C_LeeTiposOrdenes%ISOPEN THEN
      CLOSE C_LeeTiposOrdenes;
    END IF;
    OPEN C_LeeTiposOrdenes(Pr_DatosOC.NO_CIA, Pr_DatosOC.ID_TIPO_TRANSACCION);
    FETCH C_LeeTiposOrdenes INTO Lv_DescripcionTipoOC;
    CLOSE C_LeeTiposOrdenes;
    --
    Ln_Error := 30;
    -- Se recupera razon social de proveedor
    IF C_LeeProveedor%ISOPEN THEN
      CLOSE C_LeeProveedor;
    END IF;
    OPEN C_LeeProveedor(Pr_DatosOC.NO_CIA, Pr_DatosOC.NO_PROVEEDOR);
    FETCH C_LeeProveedor INTO Lv_NombreProveedor;
    CLOSE C_LeeProveedor;
    --
    Ln_Error := 40;
    -- determinar saludo inicial de correo
    IF C_LeeHora%ISOPEN THEN
      CLOSE C_LeeHora;
    END IF;
    OPEN C_LeeHora;
    FETCH C_LeeHora INTO Ln_Hora;
    CLOSE C_LeeHora;
    --
    Ln_Error := 50;
    --
    CASE 
      WHEN Ln_Hora >= 0 AND Ln_Hora < 12 THEN  --DIAS
        Lv_Saludo := 'Buenos Días';
      WHEN Ln_Hora >= 12 AND Ln_Hora < 19 THEN --TARDES
        Lv_Saludo := 'Buenas Tardes';
      ELSE                                      --NOCHES
        Lv_Saludo := 'Buenas Noches';
    END CASE;
    --
    Ln_Error := 60;
    --
    Lv_TextoCorreo := 'Se comunica que ha sido autorizada la orden de compra de <strong>' || Lv_DescripcionTipoOC || '</strong>';
    Lv_TextoCorreo := Lv_TextoCorreo ||'<strong>No. ' || Pr_DatosOC.NO_ORDEN || '</strong> ';
    Lv_TextoCorreo := Lv_TextoCorreo ||'con <strong> Fecha Orden:</strong> ' ||TO_CHAR(Pr_DatosOC.FECHA, 'DD/MM/YYYY')||' ';
    Lv_TextoCorreo := Lv_TextoCorreo ||'correspondiente al proveedor <strong>' || Pr_DatosOC.NO_PROVEEDOR || ' - ' || Lv_NombreProveedor||'</strong> ';
    Lv_TextoCorreo := Lv_TextoCorreo ||'por un monto total de <strong>' || TRIM(TO_CHAR(Pr_DatosOC.TOTAL, '999,999,999.00'))||'</strong> ';
    Lv_TextoCorreo := Lv_TextoCorreo ||'con <strong>Fecha de Vencimiento:</strong> ' || TO_CHAR(Pr_DatosOC.FECHA_VENCE, 'DD/MM/YYYY');
    --
    Ln_Error := 70;
    --
    Lv_MensajeCorreo :=                    '<html>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||  '<head>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<title>HTML Editor Sample Page</title>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||  '</head>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<body>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '<p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||        '<span style="font-size:14px;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||          '<span style="font-family:arial,helvetica,sans-serif;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||            '<strong>'||Lv_Saludo||'</strong>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||          '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||        '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '</p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '<p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||        '<span style="font-size:14px;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||          '<span style="font-family:arial,helvetica,sans-serif;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||            Lv_TextoCorreo;
    Lv_MensajeCorreo := Lv_MensajeCorreo ||          '</span>';   
    Lv_MensajeCorreo := Lv_MensajeCorreo ||        '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '</p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||     '<br>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||     '<span style="font-size:14px;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '<span style="font-family:arial,helvetica,sans-serif;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||        '<strong>Observación:</strong> '|| UPPER(Pr_DatosOC.OBSERVACION);
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '</span>';
    --Lv_MensajeCorreo := Lv_MensajeCorreo ||     '</p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<br><br>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<span style="font-size:14px;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '<span style="font-family:arial,helvetica,sans-serif;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||        '<strong>Detalle Orden</strong>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '</span>';
    --Lv_MensajeCorreo := Lv_MensajeCorreo ||    '</p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<table border="1" cellpadding="1" cellspacing="1" style="width: 75%;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||     '<tbody>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||       '<tr bgcolor="#030137" style="text-align: center;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||         '<td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||           '<span style="color:#ffffff;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||             '<span style="font-family:arial,helvetica,sans-serif;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||               '<strong>PRODUCTO</strong>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||             '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||           '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||         '</td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||         '<td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||           '<span style="color:#ffffff;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||             '<span style="font-family:arial,helvetica,sans-serif;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||               '<strong>DESCRIPCION</strong>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||             '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||           '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||         '</td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||         '<td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||           '<span style="color:#ffffff;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||             '<span style="font-family:arial,helvetica,sans-serif;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||               '<strong>CANTIDAD</strong>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||             '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||           '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||         '</td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||         '<td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||           '<span style="color:#ffffff;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||             '<span style="font-family:arial,helvetica,sans-serif;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||               '<strong>TOTAL</strong>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||             '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||           '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||         '</td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||       '</tr>';
    --
    --
    Ln_TotalCantidad := 0;
    Ln_TotalDetalle  := 0;
    --
    Ln_Error := 80;
    --
    FOR Lr_DetalleOrden IN C_LeeDetalleOrden (Pr_DatosOC.NO_CIA, Pr_DatosOC.NO_ORDEN) LOOP
      --
      Lv_DescripcionBien := NULL;
      Lv_DescripcionServ := NULL;
      --
      IF Pr_DatosOC.ID_TIPO_TRANSACCION IN ('BI', 'AB') THEN
        --
        Ln_Error := 90;
        --
        IF C_LeeBienes%ISOPEN THEN
          CLOSE C_LeeBienes;
        END IF;
        OPEN C_LeeBienes(Pr_DatosOC.NO_CIA, Lr_DetalleOrden.NO_ARTI);
        FETCH C_LeeBienes INTO Lv_DescripcionBien;
        CLOSE C_LeeBienes;
        --
      ELSIF Pr_DatosOC.ID_TIPO_TRANSACCION IN ('SE', 'RE') THEN
        --
        Ln_Error := 100;
        IF C_LeeServicios%ISOPEN THEN
          CLOSE C_LeeServicios;
        END IF;
        OPEN C_LeeServicios(Pr_DatosOC.NO_CIA, Lr_DetalleOrden.CODIGO_NI);
        FETCH C_LeeServicios INTO Lv_DescripcionServ;
        CLOSE C_LeeServicios;
        --
      END IF;
      --
      Ln_Error := 110;
      --
      Lv_MensajeCorreo := Lv_MensajeCorreo ||'<tr>';
      Lv_MensajeCorreo := Lv_MensajeCorreo ||'<td>'|| NVL(Lr_DetalleOrden.NO_ARTI, Lr_DetalleOrden.CODIGO_NI)||'</td>';
      Lv_MensajeCorreo := Lv_MensajeCorreo ||'<td>'|| NVL(Lv_DescripcionBien, Lv_DescripcionServ)||'</td>';
      Lv_MensajeCorreo := Lv_MensajeCorreo ||'<td style="text-align: right;">'||TRIM(TO_CHAR(Lr_DetalleOrden.CANTIDAD, '999,999,990.90'))|| '</td>';
      Lv_MensajeCorreo := Lv_MensajeCorreo ||'<td style="text-align: right;">'||TRIM(TO_CHAR(((Lr_DetalleOrden.CANTIDAD * Lr_DetalleOrden.COSTO_UNI)+Lr_DetalleOrden.IMPUESTOS), '999,999,990.90'))||'</td>';
      Lv_MensajeCorreo := Lv_MensajeCorreo ||'</tr>';
      --
      Ln_TotalCantidad := Ln_TotalCantidad + Lr_DetalleOrden.CANTIDAD;
      Ln_TotalDetalle  := Ln_TotalDetalle + ((Lr_DetalleOrden.CANTIDAD * Lr_DetalleOrden.COSTO_UNI) + Lr_DetalleOrden.IMPUESTOS);
      --
    END LOOP;
    --
    Ln_Error := 120;
    --
    Lv_MensajeCorreo := Lv_MensajeCorreo ||  '<tr>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<td>' || Lv_Caracter || 'nbsp; </td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<td style="text-align: right;"> <strong>Totales</strong> </td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<td style="text-align: right;">'||TRIM(TO_CHAR(Ln_TotalCantidad, '999,999,990.90'))||'</td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<td style="text-align: right;">'||TRIM(TO_CHAR(Ln_TotalDetalle, '999,999,990.90'))||'</td>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||  '</tr>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||'<tr>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||'</tbody>';
    --
    --
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '</table>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '<span style="font-size:14px;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||        '<span style="font-family:arial,helvetica,sans-serif;">Atentamente</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '</p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '<p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '<span style="font-size:14px;">';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||        '<span style="font-family:arial,helvetica,sans-serif;">Soporte NAF</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||      '</span>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||    '</p>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||  '</body>';
    Lv_MensajeCorreo := Lv_MensajeCorreo ||'</html>';
    --
    Ln_Error := 130;
    --  Codigo Empleado Solicitante, Quien envia
    IF C_DATOS_SOLICITANTE%ISOPEN THEN
      CLOSE C_DATOS_SOLICITANTE;
    END IF;
    OPEN C_DATOS_SOLICITANTE;
    FETCH C_DATOS_SOLICITANTE INTO Lr_Solicitante;
    CLOSE C_DATOS_SOLICITANTE;
    --
     --JXZURITA email generico [11/11/2022] [INICIO]
    IF Lr_Solicitante.Mail_Cia IS NULL THEN
      --Validacion para obtener correos de usuarios genericos
       begin  
          SELECT ID_EMPLEADO into ln_no_empleado
          FROM SEG47_TNET.TASGUSUARIO WHERE UPPER(USUARIO) = UPPER(Pr_DatosOC.USUARIO) AND NO_CIA = Pr_DatosOC.NO_CIA and rownum<=1;
       exception
         when no_data_found then
              Lv_MensajeError := 'No se encuentra definido solicitante TASGUSUARIO codigo de usuario generico '||Pr_DatosOC.NO_SOLICITANTE||' para empresa '||Pr_DatosOC.NO_CIA;
              RAISE Le_Error;
         when too_many_rows then
              Lv_MensajeError := 'Se encuentra muchas veces definido solicitante TASGUSUARIO codigo de usuario generico '||Pr_DatosOC.NO_SOLICITANTE||' para empresa '||Pr_DatosOC.NO_CIA;
              RAISE Le_Error;
         when others then
              Lv_MensajeError := 'Error en busqueda solicitante TASGUSUARIO de codigo de usuario generico '||Pr_DatosOC.NO_SOLICITANTE||' para empresa '||Pr_DatosOC.NO_CIA||'::'||substr(sqlerrm,1,50);
              RAISE Le_Error;
       end;

       IF C_DATOS_SOLICITANTE_DAT%ISOPEN THEN
          CLOSE C_DATOS_SOLICITANTE_DAT;
       END IF;

       OPEN C_DATOS_SOLICITANTE_DAT(ln_no_empleado, Pr_DatosOC.NO_CIA);
       FETCH C_DATOS_SOLICITANTE_DAT INTO Lr_Solicitante;
       CLOSE C_DATOS_SOLICITANTE_DAT;
      --JXZURITA email generico [11/11/2022] [FIN]
      IF Lr_Solicitante.Mail_Cia IS NULL THEN
      Lv_MensajeError := 'No se encuentra definido código de solicitante '||Pr_DatosOC.NO_SOLICITANTE||' para empresa '||Pr_DatosOC.NO_CIA;
        RAISE Le_Error;
      END IF;
    --JXZURITA email generico [11/11/2022] [INICIO]
    END IF;
    --JXZURITA email generico [11/11/2022] [FIN]
    --
    Ln_Error := 140;

    IF C_DATOS_CREA%ISOPEN THEN
      CLOSE C_DATOS_CREA;
    END IF;
    OPEN C_DATOS_CREA;
    FETCH C_DATOS_CREA INTO Lr_DatosCrea;
    CLOSE C_DATOS_CREA;

    --
    --JXZURITA email generico [11/11/2022] [INICIO]
    IF Lr_DatosCrea.Mail_Cia IS NULL THEN
       begin  
          SELECT ID_EMPLEADO into ln_no_empleado
          FROM SEG47_TNET.TASGUSUARIO WHERE UPPER(USUARIO) = UPPER(Pr_DatosOC.USUARIO) AND NO_CIA = Pr_DatosOC.NO_CIA and rownum<=1;
       exception
         when no_data_found then
              Lv_MensajeError := 'No se encuentra definido creador TASGUSUARIO codigo de usuario generico '||Pr_DatosOC.NO_SOLICITANTE||' para empresa '||Pr_DatosOC.NO_CIA;
              RAISE Le_Error;
         when too_many_rows then
              Lv_MensajeError := 'Se encuentra muchas veces definido creador TASGUSUARIO codigo de usuario generico '||Pr_DatosOC.NO_SOLICITANTE||' para empresa '||Pr_DatosOC.NO_CIA;
              RAISE Le_Error;
         when others then
              Lv_MensajeError := 'Error en busqueda creador TASGUSUARIO de codigo de usuario generico '||Pr_DatosOC.NO_SOLICITANTE||' para empresa '||Pr_DatosOC.NO_CIA||'::'||substr(sqlerrm,1,50);
              RAISE Le_Error;
       end;

       IF C_DATOS_CREA_DAT%ISOPEN THEN
          CLOSE C_DATOS_CREA_DAT;
       END IF;

       OPEN C_DATOS_CREA_DAT(ln_no_empleado, Pr_DatosOC.NO_CIA);
       --JXZURITA email generico [06/12/2022] [INICIO]
       FETCH C_DATOS_CREA_DAT INTO Lr_DatosCrea;
       --JXZURITA email generico [06/12/2022] [FIN]
       CLOSE C_DATOS_CREA_DAT;  
    --JXZURITA email generico [11/11/2022] [FIN]
      IF Lr_DatosCrea.Mail_Cia IS NULL THEN
      Lv_MensajeError := 'No se encuentra definido código de usuario '||Pr_DatosOC.USUARIO||' para empresa '||Pr_DatosOC.NO_CIA;
        RAISE Le_Error;
      END IF;
    --JXZURITA email generico [11/11/2022] [INICIO]
    END IF;
    --JXZURITA email generico [11/11/2022] [FIN]
    --
    Ln_Error := 150;
    --
    SYS.UTL_MAIL.SEND(sender     => 'naf@telconet.ec',
                      recipients => Lr_Solicitante.Mail_Cia, --Envia al autorizador o a su reemplazo
                      CC         => Lr_DatosCrea.Mail_Cia,
                      subject    => 'SISTEMA NAF: AUTORIZACIÓN COMPLETA DE ORDEN COMPRA NO.' || Pr_DatosOC.NO_ORDEN,
                      mime_type  => 'text/html; charset=us-ascii',
                      MESSAGE    => Lv_MensajeCorreo);

    --
    Ln_Error := 150;
    --
  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'CORREO_ORDEN.P_NOTIFICA_AUTORIZACION',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Lv_MensajeError := Ln_Error||'. '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'CORREO_ORDEN.P_NOTIFICA_AUTORIZACION',
                                           Lv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

  END P_NOTIFICA_AUTORIZACION;
  --
END CORREO_ORDEN;
/
