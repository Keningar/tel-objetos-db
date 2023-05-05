CREATE EDITIONABLE PACKAGE            INK_PROCESA_PEDIDO_PRES is
  Gt_Arinte NAF47_TNET.ARINTE%ROWTYPE;
  Gt_Arintl NAF47_TNET.ARINTL%ROWTYPE;
  --20042021 Elvis Mu?oz Pruna
  --Paquete creado para gestioanr los pedidos que contienen prestamos de unidades en entre pedidos
  /*
  * Documentacion para P_INSERTA_ARINTE
  * Procedure que inserta registros en la tabla de cabecera de articulos a transferir
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.0 16/05/2021
  *
  * @param Pr_Arinte      IN NAF47_TNET.ARINTE%ROWTYPE Recibe todo el registro a insertar en la tabla NAF47_TNET.ARINTE
  * @param Pv_MensajeError OUT VARCHAR2 Retorna mensaje error.
  */

  PROCEDURE P_INSERTA_ARINTE(Pr_Arinte       IN NAF47_TNET.ARINTE%ROWTYPE,
                             Pv_MensajeError IN OUT VARCHAR2);

  /*
  * Documentacion para P_INSERTA_ARINTL
  * Procedure que inserta registros en la tabla de detalle de articulos a transferir
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.0 16/05/2021
  *
  * @param Pr_Arinte      IN NAF47_TNET.ARINTL%ROWTYPE Recibe todo el registro a insertar en la tabla detalle NAF47_TNET.ARINTL
  * @param Pv_MensajeError OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_ARINTL(Pr_Arintl       IN NAF47_TNET.ARINTL%ROWTYPE,
                             Pv_MensajeError IN OUT VARCHAR2);

  /*
  * Documentacion para P_INSERTA_PROD_RESERVA
  * Procedure que inserta registros en la tabla INFO_RESERVA_PRODUCTOS
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.0 16/05/2021
  *
  * @param Pr_RegReservaProductos      IN DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE Recibe todo el registro a insertar en la tabla detalle NAF47_TNET.INFO_RESERVA_PRODUCTOS
  * @param Pv_MensajeError OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_PROD_RESERVA(Pr_RegReservaProductos IN DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE,
                                   Pv_MensajeError        OUT VARCHAR2);
  --
  --
  /*
  * Documentacion para P_PROCESA_PRESTAMOS_PEDIDOS
  * Procedure que ejeucta la devolcion de unidades o crea las transferencis a oedidos que tienen unidds prestadas de la misma bodega u otra bodega
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.0 16/05/2021
  *
  * Se agrega invoca proceso de reserva
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.1 15/09/2022
  *
  * @param Pv_IdEmpresa      IN VARCHAR2 Recibe codigo de la empresa a procesar
  * @param Pv_TipoDocu      IN VARCHAR2 Recibe codigo del tipo de documento con el pedido que se relaciona a un pedido con prestamo
  * @param Pv_NoDocu      IN VARCHAR2 Recibe codigo del documento con el pedido que se relaciona a un pedido con prestamo
  * @param Pv_MensajeError  OUT VARCHAR2 Retorna mensaje error.
  */

  PROCEDURE P_PROCESA_PRESTAMOS_PEDIDOS(Pv_IdEmpresa    IN VARCHAR2,
                                        Pv_TipoDocu     IN VARCHAR2,
                                        Pv_NoDocu       IN VARCHAR2,
                                        Pv_MensajeError OUT VARCHAR2);
  --
  --
  /*
  * Documentacion para P_TRANSFRENCIA_PRESTAMOS
  * Procedure que procede a realizar la transferencia por pedidos
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.0 16/05/2021
  *
  * @param Pv_IdEmpresa      IN VARCHAR2 Recibe codigo de la empresa a procesar
  * @param Pn_IdPedido      IN NUMBER Recibe codigo del pedido de transferencia
  * @param Pn_IdDetPedido      IN NUMBER Recibe codigo del detalle de pedido de transferencia
  * @param Pv_NoArticulo      IN VARCHAR2 Recibe codigo del articulo de transferencia
  * @param Pv_NoDocuArinte     OUT NAF47_TNET.ARINTE.NO_DOCU%TYPE, Devuelve el codigo delducmento generado por la transferencia
  * @param Pv_MensajeError  OUT VARCHAR2 Retorna mensaje error.
  */

  --
  PROCEDURE P_TRANSFRENCIA_PRESTAMOS(Pv_IdEmpresa    IN VARCHAR2,
                                     Pn_IdPedido     IN NUMBER,
                                     Pn_IdDetPedido  IN NUMBER,
                                     Pv_NoArticulo   IN VARCHAR2,
                                     Pv_NoDocuArinte OUT NAF47_TNET.ARINTE.NO_DOCU%TYPE,
                                     Pv_MensajeError OUT VARCHAR2);

  /*
  * Documentacion para P_NOTIFICA_PRESTAMO_PEDIDO
  * Procedure Que notifica al usuario autorizador o jefe cuando existe una devolucion por prestamo
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.0 16/05/2021
  *
  * @param Pv_IdEmpresa      IN VARCHAR2 Recibe codigo de la empresa a procesar
  * @param Pn_IdPedido      IN NUMBER Recibe codigo del pedido al cual debe enviarse la notificacion para leer los datos del empleado
  * @param Pn_IdPedidoDet      IN NUMBER Recibe el codigo del detalle del pedido por el cual se procede con la notificacion
  * @param Pv_MensajeError  OUT VARCHAR2 Retorna mensaje error.
  */

  PROCEDURE P_NOTIFICA_PRESTAMO_PEDIDO(Pv_IdEmpresa    IN VARCHAR2,
                                       Pn_IdPedido     IN NUMBER,
                                       Pn_IdPedidoDet  IN NUMBER,
                                       Pv_MensajeError OUT VARCHAR2);
  --
  /*
  * Documentacion para P_INSERTA_PRESTAMO_TRANSFE
  * Procedure que inserta los pedidos a transferirse
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.0 16/05/2021
  *
  * @param Pv_IdEmpresa      IN VARCHAR2 Recibe codigo de la empresa a procesar
  * @param Pr_DevolPedTrans   IN NAF47_TNET.ARIN_PRESTAMO_TRANSFERENCIA%ROWTYPE, Recibe el registro para insertar en la tabla ARIN_PRESTAMO_TRANSFERENCIA
  * @param Pv_MensajeError  OUT VARCHAR2 Retorna mensaje error.
  */

  --
  PROCEDURE P_INSERTA_PRESTAMO_TRANSFE(Pv_IdEmpresa     IN VARCHAR2,
                                       Pr_DevolPedTrans IN NAF47_TNET.ARIN_PRESTAMO_TRANSFERENCIA%ROWTYPE,
                                       Pv_MensajeError  OUT VARCHAR2);
  --
  /*
  * Documentacion para P_RECIBE_PRESTAMOS_PRODUCTOS
  * Procedure que procede a actualizar las unidades en la tabla de info_detalles_pedidos para actualizar las unidades prestadas  y unidades reservadas
  * para tener una linea de devolucion en la tabla de reservas de unidades
  * @author emunoz <emunoz@telconet.ec>
  * @version 1.0 16/05/2021
  *
  * @param Pv_IdEmpresa      IN VARCHAR2 Recibe codigo de la empresa a procesar
  * @param Pv_IdDocTraslado  IN VARCHAR2 Recibe codigo del dpocumento de traslado
  * @param Pv_MensajeError  OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_RECIBE_PRESTAMOS_PRODUCTOS(Pv_IdEmpresa     IN VARCHAR2,
                                         Pv_IdDocTraslado IN VARCHAR2,
                                         Pv_MensajeError  OUT VARCHAR2);

  /**
  * Documentacion para P_PROCESA_RESERVA_PRODUCTO
  * Procedure que hace reserva de pedidos asociados a un proyecto
  * en base a un ingreso de art�culos por ordenes de compra
  * @author Byron Anton <banton@telconet.ec>
  * @version 1.0 25/05/2022
  *
  * @param Pv_NoDocu   IN VARCHAR Documento de ingreso a bodega.
  * @param Pv_Cia      IN VARCHAR Compania.
  * @param Pv_Error    OUT VARCHAR Salida de Error.
  */
  PROCEDURE P_PROCESA_RESERVA_PRODUCTO(Pv_NoDocu IN VARCHAR2,
                                     Pv_NoCia  IN VARCHAR2,
                                     Pv_Error OUT VARCHAR2);
  --

END INK_PROCESA_PEDIDO_PRES;
/


CREATE EDITIONABLE PACKAGE BODY            INK_PROCESA_PEDIDO_PRES IS
  PROCEDURE P_INSERTA_ARINTE(Pr_Arinte       IN NAF47_TNET.ARINTE%ROWTYPE,
                             Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
    INSERT INTO NAF47_TNET.ARINTE
      (NO_CIA,
       CENTRO,
       BOD_ORIG,
       BOD_DEST,
       PERIODO,
       NO_DOCU,
       FECHA,
       OBSERV1,
       IND_BORRADO,
       ESTADO,
       NO_DOCU_REF,
       USUARIO,
       TSTAMP,
       TIPO_FLUJO,
       TOTAL_LINEAS)
    VALUES
      (Pr_Arinte.NO_CIA,
       Pr_Arinte.CENTRO,
       Pr_Arinte.BOD_ORIG,
       Pr_Arinte.BOD_DEST,
       Pr_Arinte.PERIODO,
       Pr_Arinte.NO_DOCU,
       Pr_Arinte.FECHA,
       Pr_Arinte.OBSERV1,
       Pr_Arinte.IND_BORRADO,
       Pr_Arinte.ESTADO,
       Pr_Arinte.NO_DOCU_REF,
       Pr_Arinte.USUARIO,
       Pr_Arinte.TSTAMP,
       Pr_Arinte.TIPO_FLUJO,
       Pr_Arinte.TOTAL_LINEAS);
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Conmtrolado en INK_PROCESA_PEDIDO_PRES.P_INSERTA_ARINTE ' ||
                         SQLCODE || ' - ' || SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      RETURN;
  END P_INSERTA_ARINTE;

  PROCEDURE P_INSERTA_ARINTL(Pr_Arintl       IN NAF47_TNET.ARINTL%ROWTYPE,
                             Pv_MensajeError IN OUT VARCHAR2) IS
  BEGIN
    INSERT INTO NAF47_TNET.ARINTL
      (NO_CIA,
       CENTRO,
       BOD_ORIG,
       BOD_DEST,
       PERIODO,
       NO_DOCU,
       NO_ARTI,
       CLASE,
       CATEGORIA,
       CANTIDAD,
       SALDO,
       TSTAMP)
    VALUES
      (Pr_Arintl.NO_CIA,
       Pr_Arintl.CENTRO,
       Pr_Arintl.BOD_ORIG,
       Pr_Arintl.BOD_DEST,
       Pr_Arintl.PERIODO,
       Pr_Arintl.NO_DOCU,
       Pr_Arintl.NO_ARTI,
       Pr_Arintl.CLASE,
       Pr_Arintl.CATEGORIA,
       Pr_Arintl.CANTIDAD,
       Pr_Arintl.SALDO,
       Pr_Arintl.TSTAMP);
  
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_INSERTA_ARINTL: ' ||
                         SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_INSERTA_ARINTL;
  ---
  PROCEDURE P_INSERTA_PROD_RESERVA(Pr_RegReservaProductos IN DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE,
                                   Pv_MensajeError        OUT VARCHAR2) IS
    Le_Error EXCEPTION;
  BEGIN
    IF Pr_RegReservaProductos.EMPRESA_ID IS NULL THEN
      Pv_MensajeError := 'El Codigo de la Empresa Id no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    IF Pr_RegReservaProductos.BODEGA IS NULL THEN
      Pv_MensajeError := 'El Codigo de Bodega no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    IF Pr_RegReservaProductos.NO_ARTI IS NULL THEN
      Pv_MensajeError := 'El Codigo de Articulo Id no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    IF Pr_RegReservaProductos.TIPO_MOV IS NULL THEN
      Pv_MensajeError := 'El Codigo de Tipo Movimiento Id no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    IF Pr_RegReservaProductos.PEDIDO_DETALLE_ID IS NULL THEN
      Pv_MensajeError := 'El Codigo del Pedido DEtalle Id no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    IF Pr_RegReservaProductos.NO_CIA IS NULL THEN
      Pv_MensajeError := 'El Codigo de la Empresa Id no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    INSERT INTO DB_COMPRAS.INFO_RESERVA_PRODUCTOS
      (ID_RESERVA_PRODUCTOS,
       EMPRESA_ID,
       BODEGA,
       NO_ARTI,
       DESCRIPCION,
       CANTIDAD,
       TIPO_MOV,
       PEDIDO_DETALLE_ID,
       NO_CIA,
       FECHA_CREACION,
       USUARIO_CREACION,
       DESCRIPCION_MOTIVO)
    VALUES
      (Pr_RegReservaProductos.ID_RESERVA_PRODUCTOS,
       Pr_RegReservaProductos.EMPRESA_ID,
       Pr_RegReservaProductos.BODEGA,
       Pr_RegReservaProductos.NO_ARTI,
       Pr_RegReservaProductos.DESCRIPCION,
       Pr_RegReservaProductos.CANTIDAD,
       Pr_RegReservaProductos.TIPO_MOV,
       Pr_RegReservaProductos.PEDIDO_DETALLE_ID,
       Pr_RegReservaProductos.NO_CIA,
       Pr_RegReservaProductos.FECHA_CREACION,
       Pr_RegReservaProductos.USUARIO_CREACION,
       Pr_RegReservaProductos.DESCRIPCION_MOTIVO);
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_INSERTA_PROD_RESERVA. ' ||
                         Pv_MensajeError;
      ROLLBACK;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_PEDIDO_PRES.P_INSERTA_PROD_RESERVA: ' ||
                         SQLCODE || ' - ' || SQLERRM;
      RETURN;
  END P_INSERTA_PROD_RESERVA;
  --
  --
  PROCEDURE P_PROCESA_PRESTAMOS_PEDIDOS(Pv_IdEmpresa    IN VARCHAR2,
                                        Pv_TipoDocu     IN VARCHAR2,
                                        Pv_NoDocu       IN VARCHAR2,
                                        Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_LeePediOC IS
      SELECT A.NO_DOCU,
             OC.NO_ORDEN SECUENCIA,
             OC.ID_PEDIDO,
             PD.ID_PEDIDO_DETALLE,
             PD.PRODUCTO_ID,
             PD.CANTIDAD_SOLICITADA,
             PD.CANTIDAD_RESERVADA,
             PD.CANTIDAD_PRESTADA
        FROM NAF47_TNET.ARINME              A,
             NAF47_TNET.ARINML              B,
             NAF47_TNET.TAPORDEE            OC,
             DB_COMPRAS.INFO_PEDIDO_DETALLE PD
       WHERE A.ORDEN_COMPRA = OC.NO_ORDEN
         AND OC.ID_PEDIDO = PD.PEDIDO_ID
            --
         AND A.NO_CIA = B.NO_CIA
         AND A.TIPO_DOC = B.TIPO_DOC
         AND A.NO_DOCU = B.NO_DOCU
         AND B.NO_ARTI = PD.PRODUCTO_ID
            --
         AND EXISTS (SELECT 'X'
                FROM DB_COMPRAS.INFO_PEDIDO P
               WHERE P.ID_PEDIDO = OC.ID_PEDIDO
                 AND P.LOGIN IS NOT NULL) --Solo los pedidos que tengan logines
         AND A.TIPO_DOC = Pv_TipoDocu
         AND A.NO_DOCU = Pv_NoDocu
         AND A.NO_CIA = Pv_IdEmpresa;

    --Confirmo si ese pedido tiene unidades prestadas ademas del codigo de pedido de donde salieron
    CURSOR C_LeeUnidPrestamos(Cn_IdDetPedido IN NUMBER,
                              Cv_IdProducto  IN VARCHAR2) IS
      SELECT PP.*
        FROM DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS PP
       WHERE PP.PEDIDO_DET_ID_SOL = Cn_IdDetPedido
         AND PP.PRODUCTO_ID = Cv_IdProducto;
    --
    CURSOR C_LeeIngreOC(Cv_IdProducto IN VARCHAR2) is
      SELECT ML.UNIDADES, ML.BODEGA
        FROM NAF47_TNET.ARINML ML
       WHERE NO_cIA = Pv_IdEmpresa
         AND TIPO_DOC = Pv_TipoDocu
         AND NO_ARTI = Cv_IdProducto
         AND NO_DOCU = Pv_NoDocu;

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
    --
    CURSOR C_LeeEmpleAutoza(Cn_IdDetPedido IN NUMBER) IS
      SELECT NVL(IP.USR_AUTORIZA_ID, IP.USR_JEFE_ID) --Quien autoriza el pedido o en su defecto el jefe
        FROM DB_COMPRAS.INFO_PEDIDO_DETALLE     PD,
             DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS PP,
             DB_COMPRAS.INFO_PEDIDO             IP
       WHERE PP.PEDIDO_DET_ID_ORI = PD.ID_PEDIDO_DETALLE
         AND PD.PEDIDO_ID = IP.ID_PEDIDO
         AND PD.ID_PEDIDO_DETALLE = Cn_IdDetPedido;
    --
    CURSOR C_LOGIN IS
    SELECT LOGIN FROM NAF47_TNET.ARINME ME, NAF47_TNET.TAPORDEE OC
    WHERE ME.NO_CIA=OC.NO_CIA
    AND ME.ORDEN_COMPRA= OC.NO_ORDEN
    AND ME.NO_CIA=Pv_IdEmpresa
    AND ME.NO_DOCU=Pv_NoDocu
    AND ME.TIPO_DOC=Pv_TipoDocu;

    Lv_IdEmpleadoAuto DB_COMPRAS.INFO_PEDIDO.USR_AUTORIZA_ID%TYPE := NULL;

    Lv_BodegaIngreso     NAF47_TNET.ARINML.BODEGA%TYPE := NULL;
    Lr_ReservaProd       C_LeeReservaProd%ROWTYPE := NULL;
    Ln_CantiIngreOC      NAF47_TNET.ARINML.UNIDADES%TYPE := 0;
    Lr_PrestamosPed      C_LeeUnidPrestamos%ROWTYPE := NULL;
    Lr_InsertReservaProd DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE := NULL;
    Lr_PrestamoTrans     NAF47_TNET.ARIN_PRESTAMO_TRANSFERENCIA%ROWTYPE := NULL;
    Lv_NoDocuArinte      NAF47_TNET.ARINTE.NO_DOCU%TYPE := NULL;
    --
    Ln_CantidadProcesar NUMBER(18, 2) := 0;
    Lc_Login C_LOGIN%ROWTYPE;
    --
    Le_Error EXCEPTION;
  BEGIN

    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El Codigo de Empresa no Puede ser Nulo';
      RAISE Le_Error;
    END IF;

    --
    IF Pv_TipoDocu IS NULL THEN
      Pv_MensajeError := 'El Tipo de Documento no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_NoDocu IS NULL THEN
      Pv_MensajeError := 'El Codigo del Documento no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    
    
    --Se comenta para que no se vaya por proceso que ya no aplica
    /*OPEN C_LOGIN;
    FETCH C_LOGIN INTO Lc_Login;
    CLOSE C_LOGIN;*/
    
    IF Lc_Login.Login IS NOT NULL THEN
      --cuando la oc la asocian a un pedido con reserva
      FOR A IN C_LeePediOC LOOP
        --
        Lr_PrestamosPed := NULL;
        IF C_LeeUnidPrestamos%ISOPEN THEN
          CLOSE C_LeeUnidPrestamos;
        END IF;
        OPEN C_LeeUnidPrestamos(A.ID_PEDIDO_DETALLE, A.PRODUCTO_ID);
        FETCH C_LeeUnidPrestamos
          INTO Lr_PrestamosPed;
        CLOSE C_LeeUnidPrestamos;
        --
        IF Lr_PrestamosPed.ID_PRESTAMO_PRODUCTOS IS NOT NULL THEN
          --Tiene productos prestados entramos a devolver lo prestado

          Ln_CantiIngreOC  := 0;
          Lv_BodegaIngreso := NULL;

          IF C_LeeIngreOC%ISOPEN THEN
            CLOSE C_LeeIngreOC;
          END IF;
          OPEN C_LeeIngreOC(A.PRODUCTO_ID);
          FETCH C_LeeIngreOC
            INTO Ln_CantiIngreOC, Lv_BodegaIngreso;
          CLOSE C_LeeIngreOC;
          --
          IF Ln_CantiIngreOC >= Lr_PrestamosPed.CANTIDAD_SOLICITADA THEN
            Ln_CantidadProcesar := Lr_PrestamosPed.CANTIDAD_SOLICITADA;
          ELSIF Ln_CantiIngreOC < Lr_PrestamosPed.CANTIDAD_SOLICITADA THEN
            Ln_CantidadProcesar := Ln_CantiIngreOC;
          END IF;

          --
          --Procedo con la devolucion de las unidades prestadas segun la bodega que presta y de donde se la ingresa

          Lr_ReservaProd := NULL;
          IF C_LeeReservaProd%ISOPEN THEN
            CLOSE C_LeeReservaProd;
          END IF;
          OPEN C_LeeReservaProd(Pv_IdEmpresa,
                                Lr_PrestamosPed.PEDIDO_DET_ID_ORI,
                                Lr_PrestamosPed.PRODUCTO_ID);
          FETCH C_LeeReservaProd
            INTO Lr_ReservaProd;
          CLOSE C_LeeReservaProd;

          IF Lr_ReservaProd.BODEGA = Lv_BodegaIngreso THEN
            -- -- Rebajan las unidades prestadas
            UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE PD
               SET PD.CANTIDAD_PRESTADA  = NVL(PD.CANTIDAD_PRESTADA, 0) -
                                           Ln_CantidadProcesar, --Lr_PrestamosPed.CANTIDAD_SOLICITADA, --Pn_UnidDespacho,
                   PD.CANTIDAD_RESERVADA = NVL(PD.CANTIDAD_RESERVADA, 0) +
                                           Ln_CantidadProcesar, --Lr_PrestamosPed.CANTIDAD_SOLICITADA, --Pn_UnidDespacho,
                   PD.USR_ULT_MOD        = USER,
                   PD.FE_ULT_MOD         = SYSDATE
             WHERE PD.ID_PEDIDO_DETALLE = Lr_ReservaProd.PEDIDO_DETALLE_ID
               AND PD.PRODUCTO_ID = Lr_ReservaProd.NO_ARTI;
            --
            Lr_InsertReservaProd := NULL;
            --Se procede a registrar la devolucion por prestamo
            Lr_InsertReservaProd.ID_RESERVA_PRODUCTOS := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_RESERVA_PRODUCTOS');
            Lr_InsertReservaProd.EMPRESA_ID           := Lr_ReservaProd.EMPRESA_ID;
            Lr_InsertReservaProd.BODEGA               := Lr_ReservaProd.BODEGA;
            Lr_InsertReservaProd.NO_ARTI              := Lr_ReservaProd.NO_ARTI;
            Lr_InsertReservaProd.DESCRIPCION          := Lr_ReservaProd.DESCRIPCION;

            Lr_InsertReservaProd.CANTIDAD           := Ln_CantidadProcesar; --Lr_PrestamosPed.CANTIDAD_SOLICITADA; --Pn_UnidDespacho;
            Lr_InsertReservaProd.TIPO_MOV           := 'I';
            Lr_InsertReservaProd.PEDIDO_DETALLE_ID  := Lr_ReservaProd.PEDIDO_DETALLE_ID;
            Lr_InsertReservaProd.NO_CIA             := Lr_ReservaProd.NO_CIA;
            Lr_InsertReservaProd.DESCRIPCION_MOTIVO := 'IngresoPrestamo';
            Lr_InsertReservaProd.USUARIO_CREACION   := USER;
            Lr_InsertReservaProd.FECHA_CREACION     := SYSDATE;
            --
            --
            --   dbms_output.put_line(Lr_ReservaProd.EMPRESA_ID||','|| Lr_ReservaProd.BODEGA||','||Lr_ReservaProd.NO_ARTI||','||Lr_InsertReservaProd.TIPO_MOV||','||Lr_ReservaProd.PEDIDO_DETALLE_ID);
            NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_PROD_RESERVA(Lr_InsertReservaProd, --
                                                                      Pv_MensajeError);
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            --
            --Se Procede a Notificar al Usuario que autoriza o en su defecto al jefe de pedido que tienes las unidades de donde se prest?
            NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_NOTIFICA_PRESTAMO_PEDIDO(Pv_IdEmpresa,
                                                                          A.ID_PEDIDO, --Pn_IdPedido     IN NUMBER,
                                                                          A.ID_PEDIDO_DETALLE, --Pn_IdPedidoDet  IN NUMBER,
                                                                          Pv_MensajeError); -- OUT VARCHAR2)
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            --
          ELSIF Lr_ReservaProd.BODEGA != Lv_BodegaIngreso THEN
            NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_TRANSFRENCIA_PRESTAMOS(Pv_IdEmpresa,
                                                                        A.ID_PEDIDO,
                                                                        A.ID_PEDIDO_DETALLE,
                                                                        A.PRODUCTO_ID,
                                                                        Lv_NoDocuArinte,
                                                                        Pv_MensajeError);
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;

            --
            Lv_IdEmpleadoAuto := NULL;
            IF C_LeeEmpleAutoza%ISOPEN THEN
              CLOSE C_LeeEmpleAutoza;
            END IF;
            OPEN C_LeeEmpleAutoza(Lr_PrestamosPed.PEDIDO_DET_ID_ORI);
            FETCH C_LeeEmpleAutoza
              INTO Lv_IdEmpleadoAuto;
            CLOSE C_LeeEmpleAutoza;
            --
            Lr_PrestamoTrans                   := NULL;
            Lr_PrestamoTrans.NO_CIA            := Pv_IdEmpresa;
            Lr_PrestamoTrans.ID_PEDIDO         := Lr_ReservaProd.PEDIDO_ID;
            Lr_PrestamoTrans.ID_PEDIDO_DETALLE := Lr_ReservaProd.PEDIDO_DETALLE_ID; --Id. del Detalle del Pedido de Donde fue prestado el articulo--A.ID_PEDIDO_DETALLE;
            Lr_PrestamoTrans.NO_ARTI           := A.PRODUCTO_ID;
            Lr_PrestamoTrans.CANTIDAD_PRESTADA := Ln_CantidadProcesar; --
            Lr_PrestamoTrans.TIPO_DOC          := Pv_TipoDocu;
            Lr_PrestamoTrans.NO_DOCU           := Pv_NoDocu;
            Lr_PrestamoTrans.ID_RESPONSABLE    := Lv_IdEmpleadoAuto;
            Lr_PrestamoTrans.ID_TIPO_TRASLADO  := 'TS'; -- Traslado de Salida, TE Traslado de Entreda
            Lr_PrestamoTrans.ID_TRASLADO       := Lv_NoDocuArinte;
            Lr_PrestamoTrans.ESTADO            := 'P';
            Lr_PrestamoTrans.USUARIO_CREA      := USER;
            Lr_PrestamoTrans.FECHA_CREA        := SYSDATE;
            NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_PRESTAMO_TRANSFE(Pv_IdEmpresa, --
                                                                          Lr_PrestamoTrans,
                                                                          Pv_MensajeError);
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;

          END IF;

        END IF;
      END LOOP;
    ELSE
      --para pedidos con login que no reservaron al momento que se generaron
      P_PROCESA_RESERVA_PRODUCTO(Pv_NoDocu,
                                 Pv_IdEmpresa,
                                 Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
    END IF;
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_PROCESA_PRESTAMOS_PEDIDOS. ' ||
                         Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_PEDIDOS_PRES.P_PROCESA_PRESTAMOS_PEDIDOS: ' ||
                         SQLCODE || ' - ' || SQLERRM;
  END P_PROCESA_PRESTAMOS_PEDIDOS;
  --
  --
  --
  --
  PROCEDURE P_TRANSFRENCIA_PRESTAMOS(Pv_IdEmpresa    IN VARCHAR2,
                                     Pn_IdPedido     IN NUMBER,
                                     Pn_IdDetPedido  IN NUMBER,
                                     Pv_NoArticulo   IN VARCHAR2,
                                     Pv_NoDocuArinte OUT NAF47_TNET.ARINTE.NO_DOCU%TYPE,
                                     Pv_MensajeError OUT VARCHAR2) IS
    CURSOR C_DETALLE IS
      SELECT D.ID_PEDIDO_DETALLE,
             D.CANTIDAD_RESERVADA,
             D.USR_ASIGNADO,
             D.PRODUCTO_ID,
             D.DESCRIPCION,
             D.PRODUCTO_EMPRESA_ID
        FROM DB_COMPRAS.INFO_PEDIDO P, DB_COMPRAS.INFO_PEDIDO_DETALLE D
       WHERE P.ID_PEDIDO = D.PEDIDO_ID
         AND P.ID_PEDIDO = Pn_IdPedido
         AND D.ID_PEDIDO_DETALLE = Pn_IdDetPedido
         AND P.LOGIN IS NOT NULL
         AND D.CANTIDAD_RESERVADA > 0;
    --
    --Lr_DetallePedido C_DETALLE%ROWTYPE;
  
    CURSOR C_OFICNA(CV_LOGIN IN NAF47_TNET.V_EMPLEADOS_EMPRESAS.LOGIN_EMPLE%TYPE) IS
      SELECT E.OFICINA,
             E.NO_CIA,
             E.NO_EMPLE,
             E.ID_PROVINCIA,
             O.CANTON_ID,
             A.ID_EMPRESA
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS E,
             DB_COMERCIAL.INFO_OFICINA_GRUPO O,
             DB_COMPRAS.ADMI_EMPRESA         A
       WHERE E.OFICINA = O.ID_OFICINA
         AND E.NO_CIA = O.EMPRESA_ID
         AND E.NO_CIA = A.CODIGO
         AND E.LOGIN_EMPLE = CV_LOGIN
         AND E.ESTADO = 'A';
    --
    --
    CURSOR C_LeeDetIngreso(Cv_TipoDocu IN VARCHAR2, Cv_NoDocu IN VARCHAR) IS
      SELECT B.BODEGA, C.CENTRO, B.UNIDADES
        FROM NAF47_TNET.ARINME A, NAF47_TNET.ARINML B, NAF47_TNET.ARINBO C
       WHERE A.NO_CIA = B.NO_CIA
         AND A.TIPO_DOC = B.TIPO_DOC
         AND A.NO_DOCU = B.NO_DOCU
         AND C.NO_CIA = B.NO_CIA
         AND C.CODIGO = B.BODEGA
         AND B.NO_ARTI = Pv_NoArticulo
         AND B.TIPO_DOC = Cv_TipoDocu
         AND B.NO_DOCU = Cv_NoDocu
         AND B.NO_CIA = Pv_IdEmpresa;
    --
    --
    CURSOR C_LeeBodegaOrigenPrestamo IS
      SELECT RP.BODEGA, PP.CANTIDAD_SOLICITADA CANTIDAD_PRESTAMO
        FROM DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS PP,
             DB_COMPRAS.INFO_RESERVA_PRODUCTOS  RP
       WHERE PP.PEDIDO_DET_ID_ORI = RP.PEDIDO_DETALLE_ID
         AND PP.PRODUCTO_ID = RP.NO_ARTI
         AND PP.PEDIDO_DET_ID_SOL = Pn_IdDetPedido --2394500
         AND PP.PRODUCTO_ID = Pv_NoArticulo --'10-01-07-019'
         AND PP.ESTADO = 'A';
    --
    CURSOR C_LeeDetArticulo IS
      SELECT A.*
        FROM NAF47_TNET.ARINDA A
       WHERE A.NO_CIA = Pv_IdEmpresa
         AND A.NO_ARTI = Pv_NoArticulo;
    --
    CURSOR C_LeeOCPedidos IS
      SELECT A.TIPO_DOC, A.NO_DOCU --, OC.PEDIDO_ID
        FROM NAF47_TNET.TAPORDEE OC, NAF47_TNET.ARINME A
       WHERE OC.NO_ORDEN = A.ORDEN_COMPRA
         AND OC.ID_PEDIDO = Pn_IdPedido;
    --
    CURSOR C_LeeCostoProducto(Cv_IdBodega   IN VARCHAR2,
                              Cv_IdProducto IN VARCHAR2) IS
      SELECT NVL(CONS_UN, 0)
        FROM NAF47_TNET.ARINMA
       WHERE NO_CIA = Pv_IdEmpresa
         AND BODEGA = Cv_IdBodega
         AND NO_ARTI = Cv_IdProducto;
    Ln_CostoProducto NUMBER(18, 2) := NULL;
  
    --
    CURSOR C_LeePedido IS
      SELECT A.PEDIDO_ID, B.LOGIN
        FROM DB_COMPRAS.INFO_PEDIDO_DETALLE A, DB_COMPRAS.INFO_PEDIDO B
       WHERE A.PEDIDO_ID = B.ID_PEDIDO
         AND A.ID_PEDIDO_DETALLE = Pn_IdDetPedido;
  
    Ln_IdPedido DB_COMPRAS.INFO_PEDIDO_DETALLE.PEDIDO_ID%TYPE := NULL;
    Lv_Login    DB_COMPRAS.INFO_PEDIDO.LOGIN%TYPE := NULL;
    Lr_Arinda   C_LeeDetArticulo%ROWTYPE := NULL;
  
    Lv_BodOrigenPrestamo DB_COMPRAS.INFO_RESERVA_PRODUCTOS.BODEGA%TYPE := NULL;
    Lr_Arimbo            C_LeeDetIngreso%ROWTYPE := NULL;
    Ln_CantidadPrestamo  NUMBER(18, 2) := 0;
    Lt_Arinte            NAF47_TNET.INK_PROCESA_PEDIDO_PRES.Gt_Arinte%ROWTYPE;
    Lt_Arintl            NAF47_TNET.INK_PROCESA_PEDIDO_PRES.Gt_Arintl%ROWTYPE;
    Lr_Oficina           C_OFICNA%ROWTYPE;
    Lr_Detalle           C_DETALLE%ROWTYPE;
  
    Lv_TipoDocu NAF47_TNET.ARINME.TIPO_DOC%TYPE := NULL;
    Lv_NoDocu   NAF47_TNET.ARINME.NO_DOCU%TYPE := NULL;
  
    Le_Error EXCEPTION;
  BEGIN
    IF Pn_IdPedido IS NULL THEN
      Pv_MensajeError := 'El Codigo del Pedido no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    --
    IF Pn_IdDetPedido IS NULL THEN
      Pv_MensajeError := 'El Codigo del Detalle de Pedido no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    --
    --
    Lr_Detalle := NULL;
    IF C_DETALLE%ISOPEN THEN
      CLOSE C_DETALLE;
    END IF;
    OPEN C_DETALLE;
    FETCH C_DETALLE
      INTO Lr_Detalle;
    CLOSE C_DETALLE;
    --
    --Por medio del pedido recupero el tipo de documento y codigo de documento del pedido que se esta procesando
    Lv_TipoDocu := NULL;
    Lv_NoDocu   := NULL;
    IF C_LeeOCPedidos%ISOPEN THEN
      CLOSE C_LeeOCPedidos;
    END IF;
    OPEN C_LeeOCPedidos;
    FETCH C_LeeOCPedidos
      INTO Lv_TipoDocu, Lv_NoDocu;
    CLOSE C_LeeOCPedidos;
    --
    --Por este cursor recupero el centro de costo y bodega del pedido que seesta procesando y el cual tiene unidades a devolver
    Lr_Arimbo := NULL;
    IF C_LeeDetIngreso%ISOPEN THEN
      CLOSE C_LeeDetIngreso;
    END IF;
    OPEN C_LeeDetIngreso(Lv_TipoDocu, Lv_NoDocu);
    FETCH C_LeeDetIngreso
      INTO Lr_Arimbo;
    CLOSE C_LeeDetIngreso;
    --
    --
    IF Lr_Arimbo.Bodega IS NULL THEN
      Pv_MensajeError := 'El Articulo/Servicio ' || Pv_NoArticulo ||
                         ' no Esta REgistrado en la Bodega Asocie este Articulo al Bodega Indicada';
      RAISE Le_Error;
    END IF;
    --
    Lr_Oficina := NULL;
    IF C_OFICNA%ISOPEN THEN
      CLOSE C_OFICNA;
    END IF;
    OPEN C_OFICNA(Lr_Detalle.USR_ASIGNADO);
    FETCH C_OFICNA
      INTO Lr_Oficina;
    CLOSE C_OFICNA;
  
    --
    --Por medio de este cursor recupero la bodega del detalle pedido donde se obtuvo el prestamo del pedido que se esta procesando.
    Lv_BodOrigenPrestamo := NULL;
    Ln_CantidadPrestamo  := NULL;
    IF C_LeeBodegaOrigenPrestamo%ISOPEN THEN
      CLOSE C_LeeBodegaOrigenPrestamo;
    END IF;
    OPEN C_LeeBodegaOrigenPrestamo;
    FETCH C_LeeBodegaOrigenPrestamo
      INTO Lv_BodOrigenPrestamo, Ln_CantidadPrestamo;
    CLOSE C_LeeBodegaOrigenPrestamo;
    --
    --Por medio de este cursor lee la clase y categoria del producto que se esta procesando a devolver
    Lr_Arinda := NULL;
    IF C_LeeDetArticulo%ISOPEN THEN
      CLOSE C_LeeDetArticulo;
    END IF;
    OPEN C_LeeDetArticulo;
    FETCH C_LeeDetArticulo
      INTO Lr_Arinda;
    CLOSE C_LeeDetArticulo;
    --
    Ln_CostoProducto := NULL;
    IF C_LeeCostoProducto%ISOPEN THEN
      CLOSE C_LeeCostoProducto;
    END IF;
    OPEN C_LeeCostoProducto(Lv_BodOrigenPrestamo, Pv_NoArticulo);
    FETCH C_LeeCostoProducto
      INTO Ln_CostoProducto;
    CLOSE C_LeeCostoProducto;
    --
    IF NVL(Ln_CostoProducto, 0) = 0 THEN
      Pv_MensajeError := 'No Existe Costo para el Producto ' ||
                         Pv_NoArticulo || ' con Bodega ' ||
                         Lv_BodOrigenPrestamo;
      RAISE Le_Error;
    END IF;
    --
    --
    Ln_IdPedido := 0;
    Lv_Login    := NULL;
    IF C_LeePedido%ISOPEN THEN
      CLOSE C_LeePedido;
    END IF;
    OPEN C_LeePedido;
    FETCH C_LeePedido
      INTO Ln_IdPedido, Lv_Login;
    CLOSE C_LeePedido;
  
    Lt_Arinte.NO_CIA       := Lr_Oficina.NO_CIA;
    Lt_Arinte.CENTRO       := Lr_Arimbo.CENTRO;
    Lt_Arinte.BOD_ORIG     := Lr_Arimbo.BODEGA;
    Lt_Arinte.BOD_DEST     := Lv_BodOrigenPrestamo;
    Lt_Arinte.OBSERV1      := 'Transferencia por Devolucion de Prestamos /Pedido No.: ' ||
                              Ln_IdPedido || ' con Login: ' || Lv_Login;
    Lt_Arinte.TIPO_FLUJO   := 'BodegaEnTransito';
    Lt_Arinte.USUARIO      := USER;
    Lt_Arinte.ESTADO       := 'P';
    Lt_Arinte.PERIODO      := TO_CHAR(SYSDATE, 'YYYY');
    Lt_Arinte.TSTAMP       := SYSDATE;
    Lt_Arinte.FECHA        := SYSDATE;
    Lt_Arinte.IND_BORRADO  := 'N';
    Lt_Arinte.TOTAL_LINEAS := ROUND(Ln_CostoProducto * Lr_Arimbo.Unidades,
                                    2);
    --Detalle de transferencia
    Lt_Arintl.NO_CIA    := Lr_Oficina.NO_CIA;
    Lt_Arintl.CENTRO    := Lr_Arimbo.CENTRO;
    Lt_Arintl.BOD_ORIG  := Lr_Arimbo.BODEGA;
    Lt_Arintl.BOD_DEST  := Lv_BodOrigenPrestamo;
    Lt_Arintl.NO_ARTI   := Lr_Detalle.PRODUCTO_ID;
    Lt_Arintl.CLASE     := Lr_Arinda.CLASE;
    Lt_Arintl.CATEGORIA := Lr_Arinda.CATEGORIA;
    Lt_Arintl.CANTIDAD  := Lr_Arimbo.UNIDADES;
    Lt_Arintl.SALDO     := Lr_Arimbo.UNIDADES;
    --
    Lt_ArintL.TSTAMP  := SYSDATE;
    Lt_Arintl.PERIODO := TO_CHAR(SYSDATE, 'YYYY');
    --
    --
    Lt_Arinte.NO_DOCU := NAF47_TNET.TRANSA_ID.INV(Lt_Arinte.NO_CIA);
    Lt_Arintl.NO_DOCU := Lt_Arinte.NO_DOCU;
  
    NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_ARINTE(Lt_Arinte,
                                                        Pv_MensajeError);
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
  
    NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_ARINTL(Lt_Arintl,
                                                        Pv_MensajeError);
  
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    Pv_NoDocuArinte := Lt_Arinte.NO_DOCU;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_PROCESA_PRESTAMOS_PEDIDOS. ' ||
                         Pv_MensajeError;
      ROLLBACK;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_PEDIDOS_PRES.P_PROCESA_PRESTAMOS_PEDIDOS: ' ||
                         SQLCODE || ' - ' || SQLERRM;
      RETURN;
  END P_TRANSFRENCIA_PRESTAMOS;
  --
  PROCEDURE P_NOTIFICA_PRESTAMO_PEDIDO(Pv_IdEmpresa    IN VARCHAR2,
                                       Pn_IdPedido     IN NUMBER,
                                       Pn_IdPedidoDet  IN NUMBER,
                                       Pv_MensajeError OUT VARCHAR2)
  
   IS
  
    Lv_Asunto VARCHAR2(300) := 'NOTIFICACION DEVOLUCION UNIDADES PRESTADAS PEDIDO # ';
    Lv_Cuerpo CLOB := NULL;
  
    Lr_Usuario NAF47_TNET.V_EMPLEADOS_EMPRESAS%ROWTYPE := NULL;
  
    CURSOR C_LeeDatosAutoriza(Cn_IdDetallePedido IN NUMBER) IS
      SELECT NVL(IP.USR_AUTORIZA_ID, IP.USR_JEFE_ID) ID_RESPONSABLE, --Quien autoriza el pedido o en su defecto el jefe
             IP.OBSERVACION,
             IP.ID_PEDIDO,
             PD.PRODUCTO_ID,
             PP.DESCRIPCION,
             PP.CANTIDAD_SOLICITADA,
             PD.ID_PEDIDO_DETALLE
        FROM DB_COMPRAS.INFO_PEDIDO_DETALLE     PD,
             DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS PP,
             DB_COMPRAS.INFO_PEDIDO             IP
       WHERE PP.PEDIDO_DET_ID_ORI = PD.ID_PEDIDO_DETALLE
         AND PD.PEDIDO_ID = IP.ID_PEDIDO
         AND PD.ID_PEDIDO_DETALLE = Cn_IdDetallePedido;
  
    Lr_DatosPedidosOrigen C_LeeDatosAutoriza%ROWTYPE := NULL;
  
    CURSOR C_LeePrestamoPedido IS
      SELECT PD.PEDIDO_ID, --PEDIDO ORIGEN
             PP.PEDIDO_DET_ID_ORI --PEDIDO DET ORIGEN
        FROM DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS PP,
             DB_COMPRAS.INFO_PEDIDO_DETALLE     PD
       WHERE PP.PEDIDO_DET_ID_SOL = PD.ID_PEDIDO_DETALLE
         AND PD.ID_PEDIDO_DETALLE = Pn_IdPedidoDet
         AND PD.PEDIDO_ID = Pn_IdPedido;
  
    Lr_PrestamoPedido C_LeePrestamoPedido%ROWTYPE := NULL;
  
    CURSOR C_LeeDatosEmpleados(Cv_IdEmpresa IN VARCHAR2,
                               Cv_NoEmple   IN VARCHAR2) IS
      select *
        FROM NAF47_TNET.V_EMPLEADOS_EMPRESAS
       WHERE NO_CIA = Cv_IdEmpresa
         AND NO_EMPLE = Cv_NoEmple;
    --
    CURSOR C_LeeUnidad(Cv_IdEmpresa IN VARCHAR2, Cv_IdArticulo IN VARCHAR2) IS
      SELECT UNIDAD
        FROM NAF47_TNET.ARINDA
       WHERE NO_CIA = Cv_IdEmpresa
         AND NO_ARTI = Cv_IdArticulo;
    --
    CURSOR C_LeeDatosMail IS
      SELECT PARAMETRO_ALTERNO CORREO_REMITE
        FROM GE_PARAMETROS x, GE_GRUPOS_PARAMETROS y
       WHERE X.ID_GRUPO_PARAMETRO = Y.ID_GRUPO_PARAMETRO
         AND X.ID_APLICACION = Y.ID_APLICACION
         AND X.ID_EMPRESA = Y.ID_EMPRESA
         AND X.ID_GRUPO_PARAMETRO = 'MAIL_SOL_PRES'
         AND X.DESCRIPCION = 'MAIL'
         AND X.ID_APLICACION = 'CO'
         AND X.ESTADO = 'A'
         AND Y.ESTADO = 'A';
    Lv_MailRemite    VARCHAR2(100);
    Lv_Unidad        ARINDA.Unidad%TYPE := NULL;
    Lv_Destinatario  CLOB := NULL;
    Lr_EmpleadoEnvia NAF47_TNET.ARPLME%ROWTYPE := NULL;
    Lv_CodigoError   VARCHAR2(2000) := NULL;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El Codigo de Empresa No Puede Ser Nulo';
      RAISE Le_Error;
    END IF;
    --
    Lr_PrestamoPedido := NULL;
    IF C_LeePrestamoPedido%ISOPEN THEN
      CLOSE C_LeePrestamoPedido;
    END IF;
    OPEN C_LeePrestamoPedido;
    FETCH C_LeePrestamoPedido
      INTO Lr_PrestamoPedido;
    CLOSE C_LeePrestamoPedido;
    --
    Lr_DatosPedidosOrigen := NULL;
    IF C_LeeDatosAutoriza%ISOPEN THEN
      CLOSE C_LeeDatosAutoriza;
    END IF;
    OPEN C_LeeDatosAutoriza(Lr_PrestamoPedido.PEDIDO_DET_ID_ORI);
    FETCH C_LeeDatosAutoriza
      INTO Lr_DatosPedidosOrigen;
    CLOSE C_LeeDatosAutoriza;
    Lv_Asunto := Lv_Asunto || Lr_DatosPedidosOrigen.ID_PEDIDO;
    --
    IF Lr_DatosPedidosOrigen.ID_RESPONSABLE IS NULL THEN
      Pv_MensajeError := 'No Existe Responsable del Pedido Origen # ' ||
                         Lr_DatosPedidosOrigen.ID_PEDIDO;
      RAISE Le_Error;
    END IF;
    --
    Lr_Usuario := NULL;
    IF C_LeeDatosEmpleados%ISOPEN THEN
      CLOSE C_LeeDatosEmpleados;
    END IF;
    OPEN C_LeeDatosEmpleados(Pv_IdEmpresa,
                             Lr_DatosPedidosOrigen.ID_RESPONSABLE);
    FETCH C_LeeDatosEmpleados
      INTO Lr_Usuario;
    CLOSE C_LeeDatosEmpleados;
  
    IF Lr_Usuario.MAIL_CIA IS NOT NULL THEN
      Lv_Destinatario := Lr_Usuario.MAIL_CIA || ',';
    END IF;
    --
    Lv_Unidad := NULL;
    IF C_LeeUnidad%ISOPEN THEN
      CLOSE C_LeeUnidad;
    END IF;
    OPEN C_LeeUnidad(Pv_IdEmpresa, Lr_DatosPedidosOrigen.PRODUCTO_ID);
    FETCH C_LeeUnidad
      INTO Lv_Unidad;
    CLOSE C_LeeUnidad;
  
    Lv_Cuerpo := '<html>
                                        <head>
                                          <meta http-equiv=Content-Type content="text/html; charset=UTF-8">
                                            <style type="text/css">
                                                table.cssTable {
                                                    font-family: verdana, arial, sans-serif;
                                                    font-size: 10px;
                                                    color: #333333;
                                                    border-width: 1px;
                                                    border-color: #999999;
                                                    border-collapse: collapse;
                                                }

                                                table.cssTable th {
                                                    background-color: #c3dde0;
                                                    border-width: 1px;
                                                    padding: 8px;
                                                    border-style: solid;
                                                    border-color: #a9c6c9;
                                                }

                                                table.cssTable tr {
                                                    background-color: #d4e3e5;
                                                }

                                                table.cssTable td {
                                                    border-width: 1px;
                                                    padding: 8px;
                                                    border-style: solid;
                                                    border-color: #a9c6c9;
                                                }

                                                table.cssTblPrincipal {
                                                    font-family: verdana, arial, sans-serif;
                                                    font-size: 11px;
                                                }
                                          </style>
                                        </head>
                                        <body>
                                          <table align="center" width="100%" cellspacing="0" cellpadding="5">
                                            <tr>
                                              <td align="center" style="border:1px solid #6699CC;background-color:#E5F2FF;">
                                                <img alt=""  src="http://images.telconet.net/logo_telconet.png"/>
                                              </td>
                                            </tr>
                                            <tr>
                                              <td style="border:1px solid #6699CC;">
                                                <table width="100%" cellspacing="0" cellpadding="5">
                                                  <tr>
                                                    <td colspan="2"><p>
                                                        <span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                                                        Estimada(o), <strong>' ||
                 Lr_Usuario.NOMBRE ||
                 '</strong> ,</br></br>
                                                        Se ha generado la devoluci?n por prestamo de Unidades  para el producto : <strong>' ||
                 Lr_DatosPedidosOrigen.PRODUCTO_ID || ' - ' ||
                 Lr_DatosPedidosOrigen.DESCRIPCION ||
                 '</strong>, por una cantidad de ' ||
                 Lr_DatosPedidosOrigen.CANTIDAD_SOLICITADA || ' ' ||
                 Lv_Unidad || '
                                                         </br>
                                                    </td>
                                                  </tr>
                                               </table>
                                                <p><span style="font-size:14px;"><span style="font-family:arial,helvetica,sans-serif;">
                                                Saludos,</br>
                                                <strong>Dpto Sistemas.</strong></span></span></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </body>
                                    </html>';
  
    -- Enviamos la notificacion
  
    BEGIN
      --
      NAF47_TNET.PLK_CONSULTAS.PLP_REG_EMPLEADO(Pv_IdEmpresa, --
                                                NULL,
                                                USER,
                                                Lr_EmpleadoEnvia,
                                                Lv_CodigoError,
                                                Pv_MensajeError);
    
      IF Lv_CodigoError IS NOT NULL OR Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
      Lv_MailRemite := null;
      IF C_LeeDatosMail%ISOPEN THEN
        CLOSE C_LeeDatosMail;
      END IF;
      OPEN C_LeeDatosMail;
      FETCH C_LeeDatosMail
        INTO Lv_MailRemite;
      CLOSE C_LeeDatosMail;
      sys.utl_mail.send(sender     => Lv_MailRemite,
                        recipients => Lv_Destinatario,
                        CC         => null, --Lr_EmpleadoEnvia.Mail_Cia,
                        subject    => Lv_Asunto,
                        mime_type  => 'text/html; charset=us-ascii',
                        MESSAGE    => Lv_Cuerpo);
    
    EXCEPTION
      WHEN Le_Error THEN
        Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_NOTIFICA_PRESTAMO_PEDIDO ' ||
                           Pv_MensajeError;
        RETURN;
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,
                                'INK_PROCESA_PEDIDO_PRES.P_NOTIFICA_PRESTAMO_PEDIDO , ' ||
                                SQLERRM || ' - ' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        --Pc_Resultado := 'ERROR';
    END; -- END BEGIN
  
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_NOTIFICA_PRESTAMO_PEDIDO ' ||
                         Pv_MensajeError;
      RETURN;
    WHEN OTHERS THEN
      --Cancela la transaccion y crea un codigo de error
      RAISE_APPLICATION_ERROR(-20001,
                              'Error en INK_PROCESA_PEDIDO_PRES.P_NOTIFICA_PRESTAMO_PEDIDO , ' ||
                              SQLERRM || ' - ' ||
                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    
  END P_NOTIFICA_PRESTAMO_PEDIDO;
  --
  PROCEDURE P_INSERTA_PRESTAMO_TRANSFE(Pv_IdEmpresa     IN VARCHAR2,
                                       Pr_DevolPedTrans IN NAF47_TNET.ARIN_PRESTAMO_TRANSFERENCIA%ROWTYPE,
                                       Pv_MensajeError  OUT VARCHAR2) IS
  
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El Codigo de Empresa No Puede Ser Nulo';
      RAISE Le_Error;
    END IF;
    --
    INSERT INTO NAF47_TNET.ARIN_PRESTAMO_TRANSFERENCIA
      (NO_CIA,
       ID_PEDIDO,
       ID_PEDIDO_DETALLE,
       NO_ARTI,
       TIPO_DOC,
       NO_DOCU,
       ESTADO,
       CANTIDAD_PRESTADA,
       ID_RESPONSABLE,
       USUARIO_CREA,
       FECHA_CREA,
       ID_TIPO_TRASLADO,
       ID_TRASLADO)
    VALUES
      (Pr_DevolPedTrans.NO_CIA,
       Pr_DevolPedTrans.ID_PEDIDO,
       Pr_DevolPedTrans.ID_PEDIDO_DETALLE,
       Pr_DevolPedTrans.NO_ARTI,
       Pr_DevolPedTrans.TIPO_DOC,
       Pr_DevolPedTrans.NO_DOCU,
       Pr_DevolPedTrans.ESTADO,
       Pr_DevolPedTrans.CANTIDAD_PRESTADA,
       Pr_DevolPedTrans.ID_RESPONSABLE,
       Pr_DevolPedTrans.USUARIO_CREA,
       Pr_DevolPedTrans.FECHA_CREA,
       Pr_DevolPedTrans.ID_TIPO_TRASLADO,
       Pr_DevolPedTrans.ID_TRASLADO);
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_INSERTA_PEDIDO_TRANSFERENCIA ' ||
                         Pv_MensajeError;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_INSERTA_ARINTL: ' ||
                         SQLERRM || ' - ' ||
                         DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END P_INSERTA_PRESTAMO_TRANSFE;
  ---

  --
  --
  PROCEDURE P_RECIBE_PRESTAMOS_PRODUCTOS(Pv_IdEmpresa     IN VARCHAR2,
                                         Pv_IdDocTraslado IN VARCHAR2,
                                         Pv_MensajeError  OUT VARCHAR2) IS
  
    CURSOR C_LeePrestamoTrans IS
      SELECT *
        FROM NAF47_TNET.ARIN_PRESTAMO_TRANSFERENCIA
       WHERE NO_CIA = Pv_IdEmpresa
         AND ID_TRASLADO = Pv_IdDocTraslado
         AND ID_TIPO_TRASLADO = 'TS'
         AND ESTADO = 'P';
    --
    --Consulto de que bodega hizo el prestamo
    CURSOR C_LeeReservaProd(Cv_IdEmpresa   IN VARCHAR2,
                            Cn_IdPedido    IN NUMBER,
                            Cn_IdDetPedido IN NUMBER,
                            Cv_IdProducto  IN VARCHAR2) IS
      SELECT PD.PEDIDO_ID, RP.*
        FROM DB_COMPRAS.INFO_RESERVA_PRODUCTOS RP,
             DB_COMPRAS.INFO_PEDIDO_DETALLE    PD
       WHERE RP.PEDIDO_DETALLE_ID = PD.ID_PEDIDO_DETALLE
         AND PD.PEDIDO_ID = Cn_IdPedido
         AND RP.PEDIDO_DETALLE_ID = Cn_IdDetPedido
         AND RP.NO_ARTI = Cv_IdProducto
         AND RP.TIPO_MOV = 'I'
         AND RP.NO_CIA = Cv_IdEmpresa;
  
    CURSOR C_LeeTipoDocTradlado IS
      SELECT TIPO_DOC
        FROM NAF47_TNET.ARINME
       WHERE NO_CIA = Pv_IdEmpresa
         AND NO_dOCU = Pv_IdDocTraslado;
    --
    CURSOR C_LeePrestamosPedidos(Cn_IdPedidoDetOrigen IN NUMBER) IS
      SELECT PD.ID_PEDIDO_DETALLE, PD.PEDIDO_ID
        FROM DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS PP,
             DB_COMPRAS.INFO_PEDIDO_DETALLE     PD
       WHERE PP.PEDIDO_DET_ID_SOL = PD.ID_PEDIDO_DETALLE
         AND PP.PEDIDO_DET_ID_ORI = Cn_IdPedidoDetOrigen;
    --
    Lr_PedidosPrestamo C_LeePrestamosPedidos%ROWTYPE := NULL;
    --
    CURSOR C_LeeDetIngresoBOD(Cv_IdTipoDoc IN VARCHAR2,
                              Cv_NoDocu    IN VARCHAR2,
                              Cv_NoArti    IN VARCHAR2) IS
      SELECT UNIDADES
        FROM NAF47_TNET.ARINML
       WHERE NO_CIA = Pv_IdEmpresa
         AND TIPO_DOC = Cv_IdTipoDoc
         AND NO_DOCU = Cv_NoDocu
         AND NO_ARTI = Cv_NoArti;
    Ln_UnIngDocumento  NAF47_TNET.ARINML.UNIDADES%TYPE := NULL;
    Lv_TipoDocTraslado ARINME.TIPO_DOC%TYPE := NULL;
  
    Lr_InsertReservaProd DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE := NULL;
    Lr_ReservaProd       C_LeeReservaProd%ROWTYPE := NULL;
    Le_Error EXCEPTION;
  BEGIN
    IF Pv_IdEmpresa IS NULL THEN
      Pv_MensajeError := 'El Codigo de la Empresa Id no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    --
    IF Pv_IdDocTraslado IS NULL THEN
      Pv_MensajeError := 'El Codigo de Traslado no Puede ser Nulo';
      RAISE Le_Error;
    END IF;
    --
    --
    Lv_TipoDocTraslado := NULL;
    IF C_LeeTipoDocTradlado%ISOPEN THEN
      CLOSE C_LeeTipoDocTradlado;
    END IF;
    OPEN C_LeeTipoDocTradlado;
    FETCH C_LeeTipoDocTradlado
      INTO Lv_TipoDocTraslado;
    CLOSE C_LeeTipoDocTradlado;
  
    FOR A IN C_LeePrestamoTrans LOOP
      Lr_ReservaProd := NULL;
      IF C_LeeReservaProd%ISOPEN THEN
        CLOSE C_LeeReservaProd;
      END IF;
      OPEN C_LeeReservaProd(A.NO_CIA,
                            A.ID_PEDIDO,
                            A.ID_PEDIDO_DETALLE,
                            A.NO_ARTI);
      FETCH C_LeeReservaProd
        INTO Lr_ReservaProd;
      CLOSE C_LeeReservaProd;
      --
      IF C_LeeDetIngresoBOD%ISOPEN THEN
        CLOSE C_LeeDetIngresoBOD;
      END IF;
      OPEN C_LeeDetIngresoBOD(A.TIPO_DOC, A.NO_DOCU, A.NO_ARTI);
      FETCH C_LeeDetIngresoBOD
        INTO Ln_UnIngDocumento;
      CLOSE C_LeeDetIngresoBOD;
      --
      UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE PD
         SET PD.CANTIDAD_PRESTADA  = NVL(PD.CANTIDAD_PRESTADA, 0) -
                                     Ln_UnIngDocumento,
             PD.CANTIDAD_RESERVADA = NVL(PD.CANTIDAD_RESERVADA, 0) +
                                     Ln_UnIngDocumento,
             PD.USR_ULT_MOD        = USER,
             PD.FE_ULT_MOD         = SYSDATE
       WHERE PD.ID_PEDIDO_DETALLE = Lr_ReservaProd.PEDIDO_DETALLE_ID
         AND PD.PEDIDO_ID = Lr_ReservaProd.PEDIDO_ID
         AND PD.PRODUCTO_ID = Lr_ReservaProd.NO_ARTI;
      --
      Lr_InsertReservaProd := NULL;
      --Se procede a registrar la devolucion por prestamo
      Lr_InsertReservaProd.ID_RESERVA_PRODUCTOS := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_RESERVA_PRODUCTOS');
      Lr_InsertReservaProd.EMPRESA_ID           := Lr_ReservaProd.EMPRESA_ID;
      Lr_InsertReservaProd.BODEGA               := Lr_ReservaProd.BODEGA;
      Lr_InsertReservaProd.NO_ARTI              := Lr_ReservaProd.NO_ARTI;
      Lr_InsertReservaProd.DESCRIPCION          := Lr_ReservaProd.DESCRIPCION;
    
      Lr_InsertReservaProd.CANTIDAD           := Ln_UnIngDocumento;
      Lr_InsertReservaProd.TIPO_MOV           := 'I'; --Se procede registrar el tipo I por devolcion de unidades al momento que se recibe la transferencia
      Lr_InsertReservaProd.PEDIDO_DETALLE_ID  := Lr_ReservaProd.PEDIDO_DETALLE_ID;
      Lr_InsertReservaProd.NO_CIA             := Lr_ReservaProd.NO_CIA;
      Lr_InsertReservaProd.DESCRIPCION_MOTIVO := 'IngresoPrestamo';
      Lr_InsertReservaProd.USUARIO_CREACION   := USER;
      Lr_InsertReservaProd.FECHA_CREACION     := SYSDATE;
      --
      --
    
      NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_PROD_RESERVA(Lr_InsertReservaProd, --
                                                                Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --Unva vez que se realiza el proceso de devolucion por prestamo se procede a marcar la transferencia por el producto a T - TRANSFERIDA
      UPDATE NAF47_TNET.ARIN_PRESTAMO_TRANSFERENCIA
         SET ESTADO            = 'T',
             USUARIO_ACTUALIZA = USER,
             FECHA_ACTUALIZA   = SYSDATE
       WHERE NO_CIA = A.NO_CIA
         AND NO_DOCU = A.NO_DOCU
         AND TIPO_DOC = A.TIPO_DOC
         AND NO_ARTI = A.NO_ARTI
         AND ID_PEDIDO = A.ID_PEDIDO;
      --
      Lr_PedidosPrestamo := NULL;
      IF C_LeePrestamosPedidos%ISOPEN THEN
        CLOSE C_LeePrestamosPedidos;
      END IF;
      OPEN C_LeePrestamosPedidos(A.ID_PEDIDO_DETALLE);
      FETCH C_LeePrestamosPedidos
        INTO Lr_PedidosPrestamo;
      CLOSE C_LeePrestamosPedidos;
      --
      NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_NOTIFICA_PRESTAMO_PEDIDO(Pv_IdEmpresa,
                                                                    Lr_PedidosPrestamo.PEDIDO_ID,
                                                                    Lr_PedidosPrestamo.ID_PEDIDO_DETALLE,
                                                                    Pv_MensajeError);
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_PROCESA_PEDIDO_PRES.P_PROCESA_PRESTAMOS_PEDIDOS. ' ||
                         Pv_MensajeError;
      ROLLBACK;
      RETURN;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error No Controlado en INK_PROCESA_PEDIDOS_PRES.P_PROCESA_PRESTAMOS_PEDIDOS: ' ||
                         SQLCODE || ' - ' || SQLERRM;
      RETURN;
  END P_RECIBE_PRESTAMOS_PRODUCTOS;

  PROCEDURE P_PROCESA_RESERVA_PRODUCTO(Pv_NoDocu IN VARCHAR2,
                                     Pv_NoCia  IN VARCHAR2,
                                     Pv_Error OUT VARCHAR2) IS
                                                       
  CURSOR C_RESERVA IS
  SELECT P.ID_PEDIDO,P.LOGIN,ML.BODEGA,ML.NO_ARTI,
         ML.UNIDADES,ML.CENTRO,ML.CLASE,ML.CATEGORIA,
         PD.PRODUCTO_ID PRO_PEDIDO,PD.DESCRIPCION,PD.CANTIDAD CANT_PEDIDO,
         NVL(PD.CANTIDAD_RESERVADA,0)CANTIDAD_RESERVADA ,
         NVL(PD.CANTIDAD_PRESTADA,0)CANTIDAD_PRESTADA,
         NVL(PD.CANTIDAD_DESPACHADA,0)CANTIDAD_DESPACHADA,
         PD.ID_PEDIDO_DETALLE,PD.USR_ASIGNADO,
         PD.ESTADO
  FROM NAF47_TNET.ARINME ME,
       NAF47_TNET.ARINML ML,
       NAF47_TNET.TAPORDEE DEE,
       DB_COMPRAS.INFO_ORDEN_COMPRA OC,
       DB_COMPRAS.INFO_PEDIDO P,
       DB_COMPRAS.INFO_PEDIDO_DETALLE PD
  WHERE ME.NO_CIA = ML.NO_CIA
  AND ME.NO_DOCU = ML.NO_DOCU
  AND ME.ORDEN_COMPRA=DEE.NO_ORDEN
  AND ME.NO_CIA=DEE.NO_CIA
  AND DEE.NO_ORDEN= OC.SECUENCIA
  AND OC.PEDIDO_ID= P.ID_PEDIDO
  AND P.ID_PEDIDO =PD.PEDIDO_ID
  AND PD.PRODUCTO_ID=ML.NO_ARTI
  AND ME.NO_CIA=Pv_NoCia
  AND ME.NO_DOCU=Pv_NoDocu
  AND P.LOGIN IS NOT NULL
  AND PD.CANTIDAD >  NVL(PD.CANTIDAD_RESERVADA,0)+NVL(PD.CANTIDAD_PRESTADA,0)+NVL(PD.CANTIDAD_DESPACHADA,0)
  AND P.ESTADO NOT IN('Despachado','Rechazado','Borrado');

   
  CURSOR C_OFICNA (CV_LOGIN  VARCHAR2 ) IS
  SELECT ACO.ID_CANTON AS CANTON_ID, ACO.PROVINCIA_ID AS ID_PROVINCIA, A.ID_EMPRESA, IOG.EMPRESA_ID AS NO_CIA
  FROM DB_COMERCIAL.INFO_PUNTO IPU,DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER,DB_COMERCIAL.INFO_OFICINA_GRUPO IOG,DB_COMERCIAL.ADMI_CANTON ACO,DB_COMPRAS.ADMI_EMPRESA A
  WHERE IPER.ID_PERSONA_ROL = IPU.PERSONA_EMPRESA_ROL_ID
  AND IPER.OFICINA_ID = IOG.ID_OFICINA
  AND IOG.CANTON_ID = ACO.ID_CANTON
  AND A.CODIGO = IOG.EMPRESA_ID
  AND IPU.LOGIN = CV_LOGIN
  AND ROWNUM < 2 ;

  CURSOR C_PROD_PRESTADO (Cn_PedDetalleId DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS.PEDIDO_DET_ID_SOL%TYPE,
                          Cv_ProductoId   DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS.PRODUCTO_ID%TYPE) IS
  SELECT PRE.ID_PRESTAMO_PRODUCTOS, PRE.PEDIDO_DET_ID_ORI,PRE.PRODUCTO_ID,
         NVL(PRE.CANTIDAD_SOLICITADA,0)- NVL(PRE.CANTIDAD_DEVUELTA,0) CANTIDAD,
         PD.USR_ASIGNADO 
  FROM DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS PRE,
       DB_COMPRAS.INFO_PEDIDO_DETALLE PD
  WHERE PRE.PEDIDO_DET_ID_ORI=PD.ID_PEDIDO_DETALLE
  AND PRE.PEDIDO_DET_ID_SOL=Cn_PedDetalleId
  AND PRE.ESTADO='A'
  AND PRE.PRODUCTO_ID=Cv_ProductoId
  AND NVL(PRE.CANTIDAD_SOLICITADA,0)- NVL(PRE.CANTIDAD_DEVUELTA,0)>0 ;

  Lt_ReservaProd   DB_COMPRAS.INFO_RESERVA_PRODUCTOS%ROWTYPE := NULL;
  Lc_Oficina       C_OFICNA%ROWTYPE;
  Lc_ProdPrestado  C_PROD_PRESTADO%ROWTYPE;
  Ln_Unidades      NUMBER;
  Le_Error         EXCEPTION;

  BEGIN
    --Se obtiene articulos a reservar
    FOR LC_RESERVA IN C_RESERVA LOOP
      Lc_ProdPrestado := NULL;
      Ln_Unidades := LC_RESERVA.UNIDADES;    
      
      --Si tiene prestamo por devolver
      
        OPEN C_OFICNA(LC_RESERVA.Login);
        FETCH C_OFICNA INTO Lc_Oficina;
        CLOSE C_OFICNA;

                
       FOR Lc_ProdPrestado IN C_PROD_PRESTADO (LC_RESERVA.ID_PEDIDO_DETALLE,
                            LC_RESERVA.NO_ARTI) LOOP        
         Lt_ReservaProd := NULL;
         --Se procede a registrar la reserva
         Lt_ReservaProd.ID_RESERVA_PRODUCTOS := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_RESERVA_PRODUCTOS');
         Lt_ReservaProd.EMPRESA_ID           := Lc_Oficina.ID_EMPRESA;
         Lt_ReservaProd.BODEGA               := LC_RESERVA.BODEGA;
         Lt_ReservaProd.NO_ARTI              := LC_RESERVA.PRO_PEDIDO;
         Lt_ReservaProd.DESCRIPCION          := LC_RESERVA.DESCRIPCION;
         Lt_ReservaProd.CANTIDAD             := Lc_ProdPrestado.Cantidad; --unidades ingresadas
         Lt_ReservaProd.TIPO_MOV             := 'I';
         Lt_ReservaProd.PEDIDO_DETALLE_ID    :=Lc_ProdPrestado.Pedido_Det_Id_Ori;
         Lt_ReservaProd.NO_CIA               := Pv_NoCia;
         Lt_ReservaProd.DESCRIPCION_MOTIVO   := 'IngresoPrestamo';
         Lt_ReservaProd.USUARIO_CREACION     := USER;
         Lt_ReservaProd.FECHA_CREACION       := SYSDATE;
         --
         NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_PROD_RESERVA(Lt_ReservaProd,
                                                                   Pv_Error);
         IF Pv_Error IS NOT NULL THEN
           RAISE Le_Error;
         END IF;
       
         UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE PD
         SET PD.CANTIDAD_PRESTADA  = NVL(PD.CANTIDAD_PRESTADA, 0) - Lc_ProdPrestado.Cantidad, 
           PD.CANTIDAD_RESERVADA = NVL(PD.CANTIDAD_RESERVADA, 0) + Lc_ProdPrestado.Cantidad, 
           PD.USR_ULT_MOD        = USER,
           PD.FE_ULT_MOD         = SYSDATE
         WHERE PD.ID_PEDIDO_DETALLE = Lc_ProdPrestado.Pedido_Det_Id_Ori;
       
         --se actualiza la cantidad devuelta
         UPDATE DB_COMPRAS.INFO_PRESTAMO_PRODUCTOS
         SET CANTIDAD_DEVUELTA= CANTIDAD_DEVUELTA+Lc_ProdPrestado.Cantidad
         WHERE ID_PRESTAMO_PRODUCTOS = Lc_ProdPrestado.Id_Prestamo_Productos;
         
         Ln_Unidades := Ln_Unidades-Lc_ProdPrestado.Cantidad;
                
      END LOOP;
      
      IF Ln_Unidades > 0 THEN
                             
       Lt_ReservaProd := NULL;
       --Se procede a registrar la reserva
       Lt_ReservaProd.ID_RESERVA_PRODUCTOS := DB_COMPRAS.F_SECUENCIAS_PEDIDOS('INFO_RESERVA_PRODUCTOS');
       Lt_ReservaProd.EMPRESA_ID           := Lc_Oficina.ID_EMPRESA;
       Lt_ReservaProd.BODEGA               := LC_RESERVA.BODEGA;
       Lt_ReservaProd.NO_ARTI              := LC_RESERVA.PRO_PEDIDO;
       Lt_ReservaProd.DESCRIPCION          := LC_RESERVA.DESCRIPCION;
       Lt_ReservaProd.CANTIDAD             := Ln_Unidades; --unidades ingresadas
       Lt_ReservaProd.TIPO_MOV             := 'I';
       Lt_ReservaProd.PEDIDO_DETALLE_ID    :=LC_RESERVA.ID_PEDIDO_DETALLE;
       Lt_ReservaProd.NO_CIA               := Pv_NoCia;
       Lt_ReservaProd.DESCRIPCION_MOTIVO   := 'IngresoReserva';
       Lt_ReservaProd.USUARIO_CREACION     := USER;
       Lt_ReservaProd.FECHA_CREACION       := SYSDATE;
       --
       NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_INSERTA_PROD_RESERVA(Lt_ReservaProd,
                                                                 Pv_Error);
       IF Pv_Error IS NOT NULL THEN
         RAISE Le_Error;
       END IF;
       
       UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE PD
       SET PD.CANTIDAD_RESERVADA = NVL(PD.CANTIDAD_RESERVADA, 0) + Ln_Unidades, 
           PD.USR_ULT_MOD        = USER,
           PD.FE_ULT_MOD         = SYSDATE
       WHERE PD.ID_PEDIDO_DETALLE = LC_RESERVA.ID_PEDIDO_DETALLE;

      END IF;
    END LOOP;

  EXCEPTION
    WHEN Le_Error THEN
      Pv_Error := 'Error en: P_PROCESA_RESERVA_PRODUCTO: '|| Pv_Error;
    WHEN OTHERS THEN
      Pv_Error := 'Error en: P_PORCESA_RESERVA_PRODUCTO: '|| SQLERRM;  
  END P_PROCESA_RESERVA_PRODUCTO;
END INK_PROCESA_PEDIDO_PRES;
/
