CREATE EDITIONABLE package            INK_DEVOLUCION_PEDIDO is

/**
* Documentacion para NAF47_TNET.INK_PROCESA_DEVOLUCION_PEDIDO
* Paquete que contiene procesos y funciones para generar procesar ingresos a bodegas por devouciones de pedidos
* @author llindao <llindao@telconet.ec>
* @version 1.0 23/10/2017
*/

/**
* Documentacion para NAF47_TNET.INK_PROCESA_DEVOLUCION_PEDIDO.Gr_ArticuloDevolucion
* Variable Registro que permite pasar por parametro los datos necesarios para procesar ingreso a bodega por devoluvi�n de pedidos
* @author llindao <llindao@telconet.ec>
* @version 1.0 23/10/2017
*/
  TYPE Gr_ArticuloDevolucion is RECORD
     ( ID_DEVOLUCIONES         DB_COMPRAS.INFO_DEVOLUCIONES.ID_DEVOLUCIONES%TYPE,
       ID_DEVOLUCIONES_DET     DB_COMPRAS.INFO_DEVOLUCIONES_DETALLE.ID_DEVOLUCIONES_DETALLE%TYPE,
       ID_PEDIDO_DETALLE       DB_COMPRAS.INFO_PEDIDO_DETALLE.ID_PEDIDO_DETALLE%TYPE,
       MOTIVO                  DB_COMPRAS.INFO_DEVOLUCIONES_DETALLE.MOTIVO%TYPE,
       PRODUCTO_ID             NAF47_TNET.ARINDA.NO_ARTI%TYPE,
       --PRODUCTO_USADO_ID       NAF47_TNET.ARINDA.NO_ARTI%TYPE,
       MANEJA_SERIE            NAF47_TNET.ARINDA.IND_REQUIERE_SERIE%TYPE,
       SERIE_AUTOMATICA        NAF47_TNET.ARINDA.GENERA_NUMERO_SERIE%TYPE,
       CANTIDAD                DB_COMPRAS.INFO_PEDIDO_DETALLE.CANTIDAD%TYPE,
       CANTIDAD_DESPACHADA     DB_COMPRAS.INFO_PEDIDO_DETALLE.CANTIDAD_DESPACHADA%TYPE,
       CANTIDAD_DEVUELTA       DB_COMPRAS.INFO_PEDIDO_DETALLE.CANTIDAD_DEVUELTA%TYPE,
       ESTADO_DEVOLUCION       DB_COMPRAS.INFO_PEDIDO.ESTADO%TYPE,
       TIPO_DOCUMENTO          NAF47_TNET.ARINVTM.TIPO_M%TYPE,
       ID_BODEGA               NAF47_TNET.ARINBO.CODIGO%TYPE,
       ID_EMPLEADO_ASIGNADO    NAF47_TNET.ARPLME.NO_EMPLE%TYPE,
       ID_EMPRESA_ASIGNADO     NAF47_TNET.ARPLME.NO_CIA%TYPE,
       OBSERVACION             NAF47_TNET.ARINME.OBSERV1%TYPE,
       ID_CENTRO               NAF47_TNET.ARINCD.CENTRO%TYPE,
       ID_EMPRESA              NAF47_TNET.ARINCD.NO_CIA%TYPE,
       ID_DOC_INVENTARIO       NAF47_TNET.ARINME.NO_DOCU%TYPE,
       ACCION                  VARCHAR2(100),
       DETALLE_ERROR           VARCHAR2(3000)
       );

/**
* Documentacion para NAF47_TNET.INK_PROCESA_DEVOLUCION_PEDIDO.Gt_Procesa_Devolucion
* Variable Tipo Tabla que permite pasar por parametro detalle de articulos para procesar devoluciones de pedidos
* @author llindao <llindao@telconet.ec>
* @version 1.0 22/09/2016
*/
  TYPE Gt_Procesa_Devolucion IS TABLE of Gr_ArticuloDevolucion;


  /**
  * Documentacion para P_INSERTA_NUMERO_SERIE
  * Procedure que registra numeros de series en el catalogo de series.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 16/04/2019
  *
  * @param Pr_NumeroSerie  IN     INV_NUMERO_SERIE%ROWTYPE Recibe registros de numeros de series a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2                 Retorna mensaje error.
  */
  PROCEDURE P_INSERTA_NUMERO_SERIE ( Pr_NumeroSerie  IN     NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2 );


  /**
  * Documentacion para P_PROCESA_DEVOLUCION
  * Procedure que registra Ingresos a bodegas por devoluci�n de pedidos.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 23/10/2017
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 13/08/2018  Se modifica para cambiar validaci�n de n�meros de series para considerar unidades por serie
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.2 31/08/2018  Se modifica para asignar correctamente el cdigo de artculo a devolver cuando se presentan los siguiente casos
  *                          - Devolucin de artculo sin Usar (Nuevo)
  *                          - Devolucin de artculo Usado (Se despacho como usado)
  *
  * @author kyager <kyager@telconet.ec>
  * @version 1.3 18/06/2019  Se modifica para asignar ingresar en log INK_PROCESA_PEDIDOS.P_REGISTRA_TIEMPOS_PEDIDO
  * los estados y el tiempo de las devoluciones.
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.4 30/07/2021 - Se modifica para considerar nuevo proceso de generaci�n n�mero de series
  *
  * @author banton <banton@telconet.ec>
  * @version 1.5 27/05/2022 - Se cambia validaci�n de numero de serie
  *
  * @param Pr_ArtDevolver  IN OUT ARRAY    Recibe registros de articulos a devolver
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  * @param Pn_IdLog       IN OUT VARCHAR2    Recibe ID de los de devoluciones
  */
  PROCEDURE P_PROCESA_DEVOLUCION ( Pr_ArtDevolver  IN OUT INK_DEVOLUCION_PEDIDO.Gt_Procesa_Devolucion,
                                 Pv_MensajeError IN OUT VARCHAR2,
                                 Pn_IdLog        IN OUT NUMBER);

  /**
  * Documentacion para P_VALIDA_NUMERO_SERIE
  * Procedure que valida que numero de serie no se encuentre registrado en algun proceso(Bodega, Instalacion, Activo fijo)
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 07/03/2019
  *
  * @param Pv_NumeroSerie  IN     VARCHAR2 Recibe numero de serie a validar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_VALIDA_NUMERO_SERIE (Pv_NumeroSerie  IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2 );

END INK_DEVOLUCION_PEDIDO;
/

CREATE EDITIONABLE package body            INK_DEVOLUCION_PEDIDO is

  PROCEDURE P_INSERTA_NUMERO_SERIE ( Pr_NumeroSerie  IN     NAF47_TNET.INV_NUMERO_SERIE%ROWTYPE,
                                     Pv_MensajeError IN OUT VARCHAR2 ) IS
  BEGIN
    INSERT INTO INV_NUMERO_SERIE
         ( COMPANIA,
           SERIE,
           NO_ARTICULO,
           ID_BODEGA,
           MAC,
           ORIGEN,
           UBICACION,
           UNIDADES,
           SERIE_ANTERIOR,
           ESTADO,
           USUARIO_CREA,
           FECHA_CREA )
    VALUES ( 
           Pr_NumeroSerie.compania,
           Pr_NumeroSerie.serie,
           Pr_NumeroSerie.no_articulo,
           Pr_NumeroSerie.id_bodega,
           Pr_NumeroSerie.mac,
           Pr_NumeroSerie.origen,
           Pr_NumeroSerie.ubicacion,
           Pr_NumeroSerie.unidades,
           Pr_NumeroSerie.serie_anterior,
           Pr_NumeroSerie.estado,
           USER,
           SYSDATE);
      
    
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_DEVOLUCION_PEDIDO.P_INSERTA_NUMERO_SERIE: '||SQLERRM;
  END P_INSERTA_NUMERO_SERIE;

  /**
  * Documentacion para P_PROCESA_SERIE
  * Procedure que inserta registro en INV_PRE_INGRESO_NUMERO_SERIE
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 22/10/2016
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 30/07/2021 - Se modifica para considerar nuevos campos cantidad_segmento, serie original
  *
  * @param Pr_DocSerie     IN INV_DOCUMENTO_SERIE%ROWTYPE Recibe registro que se va a insertar
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error.
  */
  PROCEDURE P_PROCESA_SERIE ( Pr_DocSerie     IN     NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE,
                              Pv_MensajeError IN OUT VARCHAR2 ) IS
    --
    Le_Error EXCEPTION;
    --
  BEGIN
    INSERT INTO NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE
         ( ID_PRE_INGRESO_SERIE,
           COMPANIA,
           NO_DOCUMENTO,
           NO_ARTICULO,
           SERIE,
           UNIDADES,
           CANTIDAD_SEGMENTO,
           SERIE_ORIGINAL,
           ORIGEN,
           USUARIO_CREA,
           FECHA_CREA,
           MAC,
           LINEA)
   VALUES( NAF47_TNET.SEQ_INV_PRE_INGRESO_SERIE.NEXTVAL,
           Pr_DocSerie.compania,
           Pr_DocSerie.No_Documento,
           Pr_DocSerie.No_Articulo,
           Pr_DocSerie.serie,
           Pr_DocSerie.Unidades,
           Pr_DocSerie.Cantidad_Segmento,
           Pr_DocSerie.Serie_Original,
           Pr_DocSerie.Origen,
           USER,
           SYSDATE,
           Pr_DocSerie.Mac,
           Pr_DocSerie.linea);

  EXCEPTION
    --WHEN Le_Error THEN NULL;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_DEVOLUCION_PEDIDO.P_PROCESA_SERIE: '||SQLERRM;
  END P_PROCESA_SERIE;


  PROCEDURE P_PROCESA_DEVOLUCION ( Pr_ArtDevolver  IN OUT INK_DEVOLUCION_PEDIDO.Gt_Procesa_Devolucion,
                                 Pv_MensajeError IN OUT VARCHAR2,
                                 Pn_IdLog        IN OUT NUMBER) IS
    --
    CURSOR C_VALIDA_CANTIDAD_SERIE ( Cn_IdDevDetalle NUMBER,
                                     Cv_NoArti       VARCHAR2,
                                     Cn_IdDevolucion NUMBER,
                                     Cv_NoCia        VARCHAR2) IS
      SELECT SUM(NVL(A.UNIDADES,1)) UNIDADES,
             COUNT(A.SERIE) REGISTROS
      FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A
      WHERE A.ORIGEN = GEK_VAR.Gr_Prefijos.DEVOLUCIONES --'DE'
      AND A.ESTADO = GEK_VAR.Gr_Estado.PENDIENTE
      AND A.NO_DOCUMENTO = Cn_IdDevolucion
      AND A.NO_ARTICULO = Cv_NoArti
      AND A.LINEA = Cn_IdDevDetalle
      AND A.COMPANIA = Cv_NoCia;
    --
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
    --
    -- cursor que recupera secuencia de arinml --
    CURSOR C_SEC_ARINML (Cv_NoDocumento VARCHAR2,
                         Cv_NoCia       VARCHAR2) IS
      SELECT MAX(A.LINEA)
        FROM NAF47_TNET.ARINML A
       WHERE A.NO_DOCU = Cv_NoDocumento
         AND A.NO_CIA = Cv_NoCia;
    --
  -- cursor que recupera los numeros de series del articulo --
  CURSOR C_NUMEROS_SERIES ( Cv_NoArticulo   VARCHAR2,
                           Cn_IdDevDetalle NUMBER,
                           Cn_IdDevolucion NUMBER,
                           Cv_NoCia        VARCHAR2) IS
    SELECT A.SERIE, 
           A.MAC,
           A.UNIDADES,
           A.CANTIDAD_SEGMENTO,
           A.SERIE_ORIGINAL
      FROM NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE A
     WHERE A.NO_ARTICULO = Cv_NoArticulo
       AND A.LINEA = Cn_IdDevDetalle
       AND A.NO_DOCUMENTO = Cn_IdDevolucion
       AND A.COMPANIA = Cv_NoCia
       AND A.ORIGEN  = NAF47_TNET.GEK_VAR.Gr_Prefijos.DEVOLUCIONES
       AND A.ESTADO = GEK_VAR.Gr_Estado.PENDIENTE;
    --
    CURSOR C_ESTADO_DEVOLUCION (Cn_IdDevolucion NUMBER,
                                Cv_NoCia        VARCHAR2) IS
      SELECT A.ESTADO
      FROM DB_COMPRAS.INFO_DEVOLUCIONES_DETALLE A
      WHERE A.DEVOLUCIONES_ID = Cn_IdDevolucion
      AND EXISTS ( SELECT NULL
                   FROM NAF47_TNET.GE_GRUPOS_PARAMETROS GGP,
                        NAF47_TNET.GE_PARAMETROS GP
                   WHERE GP.DESCRIPCION = A.ESTADO
                   AND GP.ID_GRUPO_PARAMETRO = NAF47_TNET.GEK_VAR.Gv_ParamEstadoDevolProcesada
                   AND GP.ID_APLICACION = NAF47_TNET.GEK_VAR.Gr_Prefijos.INVENTARIO
                   AND GP.ID_EMPRESA = Cv_NoCia
                   AND GP.ESTADO = NAF47_TNET.GEK_VAR.Gr_EstadoNAF.ACTIVO
                   AND GGP.ESTADO = NAF47_TNET.GEK_VAR.Gr_EstadoNAF.ACTIVO
                   AND GP.ID_GRUPO_PARAMETRO = GGP.ID_GRUPO_PARAMETRO
                   AND GP.ID_APLICACION = GGP.ID_APLICACION
                   AND GP.ID_EMPRESA = GGP.ID_EMPRESA)
      GROUP BY A.ESTADO;
    --
    CURSOR C_CANTIDADES_DEVOLUCION (Cn_IdDetDevolcuion NUMBER) IS
      SELECT IDD.CANTIDAD_A_DEVOLVER,
             IDD.CANTIDAD_DEVUELTA
      FROM DB_COMPRAS.INFO_DEVOLUCIONES_DETALLE IDD
      WHERE IDD.ID_DEVOLUCIONES_DETALLE = Cn_IdDetDevolcuion;
    --
    CURSOR C_DATOS_ARTICULO (Cv_NoArticulo VARCHAR2,
                             Cv_NoCia      VARCHAR2) IS
      SELECT DA.PACK,
             DA.FORMATO_SERIE_ID 
      FROM NAF47_TNET.ARINDA DA
      WHERE DA.NO_ARTI = Cv_NoArticulo
      AND DA.NO_CIA = Cv_NoCia;
    --
    Lr_Arinme          NAF47_TNET.ARINME%ROWTYPE := NULL;
    Lr_Arinml          NAF47_TNET.ARINML%ROWTYPE := NULL;
    Lr_DocSerie        NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE%ROWTYPE := NULL;
    Lr_DatosPeriodo    C_DATOS_PERIODO%ROWTYPE := NULL;
    Lr_NumeroSerie     INV_NUMERO_SERIE%ROWTYPE := NULL;
    Lr_CantDetDevol    C_CANTIDADES_DEVOLUCION%ROWTYPE := NULL;
    Lr_ValidaCantSerie C_VALIDA_CANTIDAD_SERIE%ROWTYPE := NULL;
    Lr_DatosArticulo   C_DATOS_ARTICULO%ROWTYPE;
    --
    Ln_IdLog           NUMBER := 0;
    --
    Ld_FechaAux      DATE := NULL;
    Lv_SeriesDesp    VARCHAR2(4000) := NULL;
    Ln_CantidadSerie NUMBER := 0;
    Lv_EstDetalleDev DB_COMPRAS.INFO_DEVOLUCIONES_DETALLE.ESTADO%TYPE := NULL;
    Lv_EstDevolucion DB_COMPRAS.INFO_DEVOLUCIONES.ESTADO%TYPE := NULL;
    Lb_PorDevolver   BOOLEAN := FALSE;
    Lv_DevCompleta   VARCHAR2(1) := 'N';
    Lv_ArticuloNuevo  VARCHAR2(2) := 'NO';
    Ln_CostoArticulo  NUMBER;
    Ln_Costo2Articulo NUMBER;
    Lv_IdDetalles     VARCHAR2(400) := NULL;
    Lb_SerieValida    BOOLEAN := TRUE;
    --
    Le_Error         EXCEPTION;
  BEGIN
  
  

    -- se recupera los articulos a comprar
    FOR Li_Devolucion IN 1..Pr_ArtDevolver.LAST LOOP
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'RECIBE PARAMETROS DEVOLUCIONES',
                                           'pr_artdevolver('||Li_Devolucion||').ID_DEVOLUCIONES = '|| pr_artdevolver(Li_Devolucion).ID_DEVOLUCIONES||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ID_DEVOLUCIONES_DET = '|| pr_artdevolver(Li_Devolucion).ID_DEVOLUCIONES_DET||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ID_PEDIDO_DETALLE = '|| pr_artdevolver(Li_Devolucion).ID_PEDIDO_DETALLE||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').MOTIVO = '|| pr_artdevolver(Li_Devolucion).MOTIVO||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').PRODUCTO_ID = '|| pr_artdevolver(Li_Devolucion).PRODUCTO_ID||';'||CHR(10)||
--                                           'pr_artdevolver('||Li_Devolucion||').PRODUCTO_USADO_ID = '|| pr_artdevolver(Li_Devolucion).PRODUCTO_USADO_ID||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').MANEJA_SERIE = '|| pr_artdevolver(Li_Devolucion).MANEJA_SERIE||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').SERIE_AUTOMATICA = '|| pr_artdevolver(Li_Devolucion).SERIE_AUTOMATICA||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').CANTIDAD = '|| pr_artdevolver(Li_Devolucion).CANTIDAD||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').CANTIDAD_DESPACHADA = '|| pr_artdevolver(Li_Devolucion).CANTIDAD_DESPACHADA||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').CANTIDAD_DEVUELTA = '|| pr_artdevolver(Li_Devolucion).CANTIDAD_DEVUELTA||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ESTADO_DEVOLUCION = '|| pr_artdevolver(Li_Devolucion).ESTADO_DEVOLUCION||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').TIPO_DOCUMENTO = '|| pr_artdevolver(Li_Devolucion).TIPO_DOCUMENTO||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ID_BODEGA = '|| pr_artdevolver(Li_Devolucion).ID_BODEGA||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ID_EMPLEADO_ASIGNADO = '|| pr_artdevolver(Li_Devolucion).ID_EMPLEADO_ASIGNADO||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ID_EMPRESA_ASIGNADO = '|| pr_artdevolver(Li_Devolucion).ID_EMPRESA_ASIGNADO||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').OBSERVACION = '|| pr_artdevolver(Li_Devolucion).OBSERVACION||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ID_CENTRO = '|| pr_artdevolver(Li_Devolucion).ID_CENTRO||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ID_EMPRESA = '|| pr_artdevolver(Li_Devolucion).ID_EMPRESA||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ID_DOC_INVENTARIO = '|| pr_artdevolver(Li_Devolucion).ID_DOC_INVENTARIO||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').ACCION = '|| pr_artdevolver(Li_Devolucion).ACCION||';'||CHR(10)||
                                           'pr_artdevolver('||Li_Devolucion||').DETALLE_ERROR = '|| pr_artdevolver(Li_Devolucion).DETALLE_ERROR||';',
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
        
      IF Pr_ArtDevolver(Li_Devolucion).ACCION != 'Devolver' THEN
        Pr_ArtDevolver(Li_Devolucion).DETALLE_ERROR := 'Tipo de acci�n no valido '||Pr_ArtDevolver(Li_Devolucion).ACCION;
        Pv_MensajeError := 'Tipo de acci�n no valido '||Pr_ArtDevolver(Li_Devolucion).ACCION;
        Raise Le_Error;
      END IF;
      --
      Lv_ArticuloNuevo  := 'NO';
      Ln_CostoArticulo  := 0.01;
      Ln_Costo2Articulo := 0.01;
      --
      --
      IF Pr_ArtDevolver(Li_Devolucion).MANEJA_SERIE = 'S' THEN
        -- se recupera cantidad de series ingresada para validar con lo indicado en despachar
        IF C_VALIDA_CANTIDAD_SERIE%ISOPEN THEN CLOSE C_VALIDA_CANTIDAD_SERIE; END IF;
        OPEN C_VALIDA_CANTIDAD_SERIE (Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES_DET,
                                      Pr_ArtDevolver(Li_Devolucion).PRODUCTO_ID,
                                      Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES,
                                      Pr_ArtDevolver(Li_Devolucion).ID_EMPRESA);
        FETCH C_VALIDA_CANTIDAD_SERIE INTO Lr_ValidaCantSerie;
        IF C_VALIDA_CANTIDAD_SERIE%NOTFOUND THEN
          Lr_ValidaCantSerie := NULL;
        END IF;
        CLOSE C_VALIDA_CANTIDAD_SERIE;
        --
        Lv_SeriesDesp := NULL;
        --
        IF NVL(Lr_ValidaCantSerie.Unidades ,0) != NVL(Pr_ArtDevolver(Li_Devolucion).CANTIDAD,0) THEN -- valida serie
          Pr_ArtDevolver(Li_Devolucion).DETALLE_ERROR := 'Para el articulo '||Pr_ArtDevolver(Li_Devolucion).PRODUCTO_ID||' cantidad de n�mero de series seleccionados '||Lr_ValidaCantSerie.Unidades||' no coincide con la cantidad a devolver '||NVL(Pr_ArtDevolver(Li_Devolucion).CANTIDAD,0)||'.';
          Pv_MensajeError := 'Para el articulo '||Lr_Arinml.No_Arti||' cantidad de n�mero de series seleccionados '||Lr_ValidaCantSerie.Unidades||' no coincide con la cantidad a devolver '||NVL(Pr_ArtDevolver(Li_Devolucion).CANTIDAD,0)||'.';
          Raise Le_Error;
        END IF;
      END IF;
      --
      ---------------------------
      --<<E01_GENERA_DOCUMENTO>> --
      ---------------------------
      --
      IF Lr_Arinme.No_Docu IS NULL THEN
        --
        Lr_Arinme.No_Cia := Pr_ArtDevolver(Li_Devolucion).ID_EMPRESA;
        Lr_Arinme.Centro := Pr_ArtDevolver(Li_Devolucion).ID_CENTRO;
        Lr_Arinme.Tipo_Doc := Pr_ArtDevolver(Li_Devolucion).TIPO_DOCUMENTO;
        Lr_Arinme.Ruta := '0000';
        Lr_Arinme.Estado := 'P';
        Lr_Arinme.Origen := GEK_VAR.Gr_Prefijos.DEVOLUCIONES;
        Lr_Arinme.Id_Bodega := Pr_ArtDevolver(Li_Devolucion).ID_BODEGA;
        Lr_Arinme.Observ1 := Pr_ArtDevolver(Li_Devolucion).OBSERVACION;
        --
        -- se recuperan parametros para asignar a documentos inventarios.
        IF C_DATOS_PERIODO%ISOPEN THEN CLOSE C_DATOS_PERIODO; END IF;
        OPEN C_DATOS_PERIODO (Pr_ArtDevolver(Li_Devolucion).ID_CENTRO,
                              Pr_ArtDevolver(Li_Devolucion).ID_EMPRESA);
        FETCH C_DATOS_PERIODO INTO Lr_DatosPeriodo;
        IF C_DATOS_PERIODO%NOTFOUND THEN
          Pv_MensajeError := 'La definici�n del calendario del inventario es incorrecta.';
          RAISE Le_Error;
        END IF;
        CLOSE C_DATOS_PERIODO;
        --
        Lr_Arinme.Tipo_Cambio := Tipo_Cambio(Lr_DatosPeriodo.Clase_Cambio,
                                             Lr_DatosPeriodo.Dia_Proceso,
                                             Ld_FechaAux,
                                             'C');
        --
        Lr_Arinme.Periodo := Lr_DatosPeriodo.Ano_Proce;
        Lr_Arinme.Fecha := Lr_DatosPeriodo.Dia_Proceso;
        Lr_Arinme.Emple_Solic := Pr_ArtDevolver(Li_Devolucion).ID_EMPLEADO_ASIGNADO;
        Lr_Arinme.No_Cia_Responsable := Pr_ArtDevolver(Li_Devolucion).ID_EMPRESA_ASIGNADO;
        Lr_Arinme.No_Devoluciones := Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES;

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
      --
      Pr_ArtDevolver(Li_Devolucion).ID_DOC_INVENTARIO := Lr_Arinme.No_Docu;
      --
      -------------------------------------------------
      -- se procede a ingresar detalle de inventario --
      -------------------------------------------------
      Lr_Arinml.No_Cia := Lr_Arinme.No_Cia;
      Lr_Arinml.Centro := Lr_Arinme.Centro;
      Lr_Arinml.Tipo_Doc := Lr_Arinme.Tipo_Doc;
      Lr_Arinml.Periodo := Lr_Arinme.Periodo;
      Lr_Arinml.Ruta := Lr_Arinme.Ruta;
      Lr_Arinml.No_Docu := Lr_Arinme.No_Docu;
      Lr_Arinml.Bodega := Lr_Arinme.Id_Bodega;
      Lr_Arinml.No_Arti := Pr_ArtDevolver(Li_Devolucion).PRODUCTO_ID;
      Lr_Arinml.Unidades := Pr_ArtDevolver(Li_Devolucion).CANTIDAD;
      Lr_Arinml.Tipo_Cambio := Lr_Arinme.Tipo_Cambio;
      Lr_Arinml.Ind_Oferta := 'N';
      --
      Ln_CostoArticulo  := naf47_tnet.articulo.costo(Lr_Arinml.No_Cia, Lr_Arinml.No_Arti, Lr_Arinml.Bodega);
      -- si articulo usado no ha generado movimientos el costo es cero por lo que se procede a asignar 1 ctvo
      IF NVL(Ln_CostoArticulo,0) = 0 THEN
        Ln_CostoArticulo  := 0.01;
      End If;
      --
      Ln_Costo2Articulo := naf47_tnet.articulo.costo2(Lr_Arinml.No_Cia, Lr_Arinml.No_Arti, Lr_Arinml.Bodega);
      -- si articulo usado no ha generado movimientos el costo es cero por lo que se procede a asignar 1 ctvo
      IF NVL(Ln_Costo2Articulo,0) = 0 THEN
        Ln_Costo2Articulo := 0.01;
      End If;
      --
      Lr_Arinml.Monto  := NVL(naf47_tnet.moneda.redondeo(Lr_Arinml.Unidades * Ln_CostoArticulo, 'P'), 0);
      Lr_Arinml.Monto2 := NVL(naf47_tnet.moneda.redondeo(Lr_Arinml.Unidades * Ln_Costo2Articulo, 'P'), 0);
      --
      IF Lr_Arinml.Tipo_Cambio > 0 then
        Lr_Arinml.monto_dol  := NVL(naf47_tnet.moneda.redondeo(Lr_Arinml.monto / Lr_Arinml.Tipo_Cambio, 'D'), 0);
        Lr_Arinml.monto2_dol := NVL(naf47_tnet.moneda.redondeo(Lr_Arinml.monto2 / Lr_Arinml.Tipo_Cambio, 'D'), 0);
      ELSE
        Lr_Arinml.Monto_Dol := 0;
        Lr_Arinml.Monto2_Dol := 0;
      END IF;
      --
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
      --
      --
      IF Pr_ArtDevolver(Li_Devolucion).MANEJA_SERIE = 'S' THEN
        -- Recupera datos articulos
        IF C_DATOS_ARTICULO%ISOPEN THEN
          CLOSE C_DATOS_ARTICULO;
        END IF;
        OPEN C_DATOS_ARTICULO( Pr_ArtDevolver(Li_Devolucion).PRODUCTO_ID,
                               Pr_ArtDevolver(Li_Devolucion).ID_EMPRESA);
        FETCH C_DATOS_ARTICULO INTO Lr_DatosArticulo;
        CLOSE C_DATOS_ARTICULO;
        --
        Ln_CantidadSerie := 0;
        --
        FOR Lr_PedSerie IN C_NUMEROS_SERIES ( Pr_ArtDevolver(Li_Devolucion).PRODUCTO_ID,
                                              Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES_DET,
                                              Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES,
                                              Pr_ArtDevolver(Li_Devolucion).ID_EMPRESA ) LOOP
          --
          Lr_DocSerie.Compania := Lr_Arinml.No_Cia;
          Lr_DocSerie.No_Documento := Lr_Arinml.No_Docu;
          Lr_DocSerie.No_Articulo := Lr_Arinml.No_Arti;--Pr_ArtDevolver(Li_Devolucion).PRODUCTO_ID;
          Lr_DocSerie.Origen := NAF47_TNET.GEK_VAR.Gr_Prefijos.DEVOLUCIONES; --'DE'
          Lr_DocSerie.Linea := Lr_Arinml.Linea;
          Lr_DocSerie.Mac := Lr_PedSerie.Mac;
          Lr_DocSerie.Unidades := Lr_PedSerie.Unidades;
          Lr_DocSerie.Cantidad_Segmento := Lr_PedSerie.Cantidad_Segmento;
          Lr_DocSerie.Serie_Original := Lr_PedSerie.Serie_Original;
          --
          -- Se genera serie automatica si esta habilitado el paracmetro y no se ha asignado serie original.
          IF Pr_ArtDevolver(Li_Devolucion).SERIE_AUTOMATICA = 'S' AND  Lr_PedSerie.Serie_Original IS NULL THEN
            --
            NAF47_TNET.GEK_VAR.P_SET_COMPANIA_ID(Lr_DocSerie.Compania);
            NAF47_TNET.GEK_VAR.P_SET_ARTICULO_ID(Lr_DocSerie.No_Articulo);
            NAF47_TNET.GEK_VAR.P_SET_NUMERO_SERIE(Lr_PedSerie.Serie);
            --
            NAF47_TNET.INKG_GENERACION_SERIE.P_FORMATO( Pn_FormatoId => Lr_DatosArticulo.Formato_Serie_Id,
                                                        Pn_Cantidad => Lr_DocSerie.Unidades,
                                                        Pb_InsertaSerie => FALSE,
                                                        Pv_NumeroSerie => Lr_NumeroSerie.Serie,
                                                        Pv_MensajeError => Pv_MensajeError);
            --
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            --
            Lr_NumeroSerie.Compania := Lr_DocSerie.Compania;
            Lr_NumeroSerie.No_Articulo := Lr_DocSerie.No_Articulo;
            Lr_NumeroSerie.Estado := 'FB';
            Lr_NumeroSerie.Mac := Lr_PedSerie.Mac;
            Lr_NumeroSerie.Unidades := Lr_DocSerie.Unidades;
            Lr_NumeroSerie.Cantidad_Segmento := Lr_DatosArticulo.Pack;
            Lr_NumeroSerie.Serie_Anterior := Lr_PedSerie.Serie;
            
            --
            P_INSERTA_NUMERO_SERIE (Lr_NumeroSerie, 
                                    Pv_MensajeError);
            --
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            --
            Lr_DocSerie.Serie := Lr_NumeroSerie.Serie;
            --
          ELSE
            --
            Lr_DocSerie.Serie := Lr_PedSerie.Serie;
            --
          END IF;          
          
          -- se valida nuevamente la serie porque en pantalla se puede consultar datos de dias anteriores
           Lb_SerieValida := NAF47_TNET.INKG_CONSULTA.F_VALIDA_NUMERO_SERIE( Lr_DocSerie.Serie,
                                                 Lr_DocSerie.Compania,
                                                 Pv_MensajeError,
                                                 FALSE);
          --
          IF NOT Lb_SerieValida THEN
            IF Pv_MensajeError IS NULL THEN
              Pv_MensajeError :='Error en: NAF47_TNET.INKG_CONSULTA.F_VALIDA_NUMERO_SERIE';
            END IF;
            RAISE Le_Error;
          END IF;
          --         
          -- inserta numeros de series --
          P_PROCESA_SERIE ( Lr_DocSerie,
                            Pv_MensajeError);

          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          ELSE
            Ln_CantidadSerie := Ln_CantidadSerie + nvl(Lr_DocSerie.Unidades,1);
          END IF;
          --
          -- se cambia el estado del numero serie a procesado
          UPDATE NAF47_TNET.INV_PRE_INGRESO_NUMERO_SERIE
          SET ESTADO = GEK_VAR.Gr_Estado.PROCESADO
          WHERE SERIE = Lr_PedSerie.Serie
          AND NO_ARTICULO = Pr_ArtDevolver(Li_Devolucion).PRODUCTO_ID
          AND LINEA = Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES_DET
          AND NO_DOCUMENTO = Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES
          AND COMPANIA = Pr_ArtDevolver(Li_Devolucion).ID_EMPRESA
          AND ORIGEN  = NAF47_TNET.GEK_VAR.Gr_Prefijos.DEVOLUCIONES
          AND ESTADO = GEK_VAR.Gr_Estado.PENDIENTE;
          --
        END LOOP;
        --
        -- se valida que series se encuentren ingresadas
        IF Ln_CantidadSerie = 0 THEN
          Pv_MensajeError := 'No se encuentran ingresados los numeros de series para el art�culo ['||Lr_Arinml.No_Arti||']';
          RAISE Le_Error;
        ELSIF nvl(Ln_CantidadSerie,0) != nvl(Lr_Arinml.Unidades,0) THEN
          Pv_MensajeError := 'Total unidades solicitadas ['||nvl(Lr_Arinml.Unidades,0)||'] no coincide con total de n�mero series ingresadas ['||nvl(Ln_CantidadSerie,0)||']';
          RAISE Le_Error;
        END IF;
      --
      END IF;
      --
      -- se recuperan las cantidades del detalle de la devoluci�n para validarlas
      IF C_CANTIDADES_DEVOLUCION%ISOPEN THEN
        CLOSE C_CANTIDADES_DEVOLUCION;
      END IF;
      OPEN C_CANTIDADES_DEVOLUCION(Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES_DET);
      FETCH C_CANTIDADES_DEVOLUCION INTO Lr_CantDetDevol;
      IF C_CANTIDADES_DEVOLUCION%NOTFOUND THEN
        Pv_MensajeError := 'No se encontro cantidades a devolver para validar. Id Det Devoluci�n '||Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES_DET;
        RAISE Le_Error;
      END IF;
      CLOSE C_CANTIDADES_DEVOLUCION;
      -------------------------------
      -- Validaciones Devoluciones --
      -------------------------------
      -- Se valida que los montos del detalle devoluci�n no fueron superados
      IF (Lr_CantDetDevol.Cantidad_Devuelta + Lr_Arinml.Unidades) > Lr_CantDetDevol.Cantidad_a_Devolver THEN
        Pv_MensajeError := 'Total unidades devueltas '||(Lr_CantDetDevol.Cantidad_Devuelta + Lr_Arinml.Unidades)||
                           ' supera las unidades a devolver '||Lr_CantDetDevol.Cantidad_a_Devolver||
                           ' para el detalle devoluci�n '||Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES_DET;
        RAISE Le_Error;
        
      ELSIF  (Lr_CantDetDevol.Cantidad_Devuelta + Lr_Arinml.Unidades) = Lr_CantDetDevol.Cantidad_a_Devolver THEN
        Lv_EstDetalleDev := 'Devuelto';
      ELSE
        Lv_EstDetalleDev := 'PorDevolver';
      END IF;
      --
      -- se procede a actualizar unidades devueltas en tablas Devoluciones --
      UPDATE DB_COMPRAS.INFO_DEVOLUCIONES_DETALLE A
         SET A.ESTADO = Lv_EstDetalleDev,
           A.CANTIDAD_DEVUELTA = NVL(A.CANTIDAD_DEVUELTA,0) + Lr_Arinml.Unidades,
           A.USR_ULT_MOD = NAF47_TNET.GEK_CONSULTA.F_RECUPERA_LOGIN,
           A.FE_ULT_MOD = SYSDATE,
           A.COMPROBANTE_INGRESO = Pr_ArtDevolver(1).ID_DOC_INVENTARIO
       WHERE A.ID_DEVOLUCIONES_DETALLE = Pr_ArtDevolver(Li_Devolucion)
            .ID_DEVOLUCIONES_DET;
      --
      Lv_IdDetalles := Pr_ArtDevolver(Li_Devolucion)
                       .ID_DEVOLUCIONES_DET || ',' || Lv_IdDetalles;
      --
      Lv_EstDetalleDev := NULL;
      -----------------------------------------------
      -- se valida unidades devueltas en el pedido --
      -----------------------------------------------
      --unidades devueltas no supere a las unidades despachadas en el pedido
      IF Pr_ArtDevolver(Li_Devolucion).CANTIDAD_DESPACHADA < (Pr_ArtDevolver(Li_Devolucion).CANTIDAD_DEVUELTA + Lr_Arinml.Unidades) THEN
        Pv_MensajeError := 'Total unidades devueltas '||(Pr_ArtDevolver(Li_Devolucion).CANTIDAD_DEVUELTA + Lr_Arinml.Unidades)||
                           ' supera las unidades despachadas '||Pr_ArtDevolver(Li_Devolucion).CANTIDAD_DESPACHADA||
                           ' para el articulo '||Lr_Arinml.No_Arti|| --Pr_ArtDevolver(Li_Devolucion).PRODUCTO_ID||
                           ' de la devoluci�n '||Pr_ArtDevolver(Li_Devolucion).ID_DEVOLUCIONES;
        RAISE Le_Error;
      ELSIF Pr_ArtDevolver(Li_Devolucion).CANTIDAD_DESPACHADA = (Pr_ArtDevolver(Li_Devolucion).CANTIDAD_DEVUELTA + Lr_Arinml.Unidades) THEN
        Lv_DevCompleta := 'S';
        Lv_EstDetalleDev := 'Devuelto';
      ELSE
        Lv_EstDetalleDev := 'PorDevolver';
      END IF;

      -- se procede a actualizar unidades despachadas en tablas pedido --
      UPDATE DB_COMPRAS.INFO_PEDIDO_DETALLE A
         SET A.CANTIDAD_DEVUELTA = NVL(A.CANTIDAD_DEVUELTA,0) + Lr_Arinml.Unidades,
           A.DEVOLUCION = Lv_DevCompleta,
           A.FE_ULT_MOD = SYSDATE,
           A.USR_ULT_MOD = NAF47_TNET.GEK_CONSULTA.F_RECUPERA_LOGIN
       WHERE A.ID_PEDIDO_DETALLE = Pr_ArtDevolver(Li_Devolucion).ID_PEDIDO_DETALLE;
      --
    END LOOP;
    --
    -- proceso que actualiza el movimiento de inventarios.
    NAF47_TNET.INACTUALIZA( Lr_Arinme.NO_CIA ,
                            Lr_Arinme.TIPO_DOC,
                            Lr_Arinme.NO_DOCU,
                            Pv_MensajeError);

    IF Pv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := Lr_Arinme.NO_DOCU||' '||Pv_MensajeError;
      RAISE Le_Error;
    END IF;
    --
    -- Se recuperan los estados del detalle para asignar estado de pedido--
    FOR Lr_DetDevolucion IN C_ESTADO_DEVOLUCION ( Pr_ArtDevolver(1).ID_DEVOLUCIONES,
                                                  Lr_Arinme.No_Cia ) LOOP
      --
      IF Lr_DetDevolucion.ESTADO = 'PorDevolver'  AND NOT Lb_PorDevolver THEN
        Lb_PorDevolver := (Lr_DetDevolucion.ESTADO = 'PorDevolver');
      END IF;
      --
    END LOOP;
    --
    IF Lb_PorDevolver THEN
      Lv_EstDevolucion := 'PorDevolver';
    ELSE
      Lv_EstDevolucion := 'Devuelto';
    END IF;

    -- se actualiza el estado del pedido
    UPDATE DB_COMPRAS.INFO_DEVOLUCIONES A
       SET A.ESTADO = Lv_EstDevolucion,
         A.USR_ULT_MOD = NAF47_TNET.GEK_CONSULTA.F_RECUPERA_LOGIN,
         A.FE_ULT_MOD = SYSDATE
     WHERE A.ID_DEVOLUCIONES = Pr_ArtDevolver(1).ID_DEVOLUCIONES;
  
    --Registro log_pedidos
    Lv_IdDetalles := rtrim(Lv_IdDetalles, ',');
    INK_PROCESA_PEDIDOS.P_REGISTRA_TIEMPOS_PEDIDO(Pr_ArtDevolver(1)
                                                  .ID_DEVOLUCIONES,
                                                  '',
                                                  'DEVOLUCION',
                                                  Lv_EstDevolucion,
                                                  GEK_CONSULTA.F_RECUPERA_IP,
                                                  GEK_CONSULTA.F_RECUPERA_LOGIN,
                                                  Lv_IdDetalles,
                                                  Pv_MensajeError,
                                                  Ln_IdLog);
    Pn_IdLog := Ln_IdLog;
    --
  EXCEPTION
    WHEN Le_Error THEN
      Pv_MensajeError := 'Error en INK_DEVOLUCION_PEDIDO.P_PROCESA_DEVOLUCION. '||Pv_MensajeError;
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_MensajeError := 'Error en INK_DEVOLUCION_PEDIDO.P_PROCESA_DEVOLUCION. '||SQLERRM;
      ROLLBACK;
  END P_PROCESA_DEVOLUCION;
  --
  --
  PROCEDURE P_VALIDA_NUMERO_SERIE (Pv_NumeroSerie  IN VARCHAR2,
                                   Pv_MensajeError IN OUT VARCHAR2 ) IS
    CURSOR C_NUMERO_SERIE IS
      SELECT COMPANIA,
             NO_ARTICULO, 
             ID_BODEGA,
             ESTADO
        FROM INV_NUMERO_SERIE
       WHERE SERIE  = Pv_NumeroSerie
         AND ESTADO = GEK_VAR.Gr_EstadoNAF.EN_BODEGA;
         --se valida si articulo no genera serie autom�tica.
    --
    CURSOR C_VERIFICA_REPOSITORIO IS
      SELECT A.ESTADO,
             DECODE(A.ESTADO, 'IN','INSTALADO','PI','PENDIENTE INSTALAR') AS DESC_ESTADO,
             A.FE_CREACION, 
             A.FE_ULT_MOD
      FROM IN_ARTICULOS_INSTALACION A
      WHERE A.NUMERO_SERIE = Pv_NumeroSerie
      AND A.ESTADO = GEK_VAR.Gr_EstadoNAF.INSTALADO--IN ('IN','PI')
      UNION ALL
      SELECT A.ESTADO,
             DECODE(A.ESTADO, 'IN','INSTALADO','PI','PENDIENTE INSTALAR') AS DESC_ESTADO,
             A.FE_CREACION, 
             A.FE_ULT_MOD
      FROM IN_ARTICULOS_INSTALACION A
      WHERE A.NUMERO_SERIE = Pv_NumeroSerie
      AND A.ESTADO = GEK_VAR.Gr_EstadoNAF.PENDIENTE_INSTALAR--IN ('IN','PI')
      ;
    --
    CURSOR C_ACTIVO_FIJO IS
      SELECT NO_CIA,
             NO_ACTI
      FROM ARAFMA
      WHERE SERIE = Pv_NumeroSerie
      AND EXISTS (SELECT NULL
                  FROM ARAFMM
                  WHERE ARAFMM.NO_ACTI = ARAFMA.NO_ACTI
                  AND ARAFMM.NO_CIA = ARAFMA.NO_CIA
                  AND ARAFMM.TIPO_M = GEK_VAR.Gr_PrefijoNAF.SALIDA --'S'
                  AND ARAFMA.ESTADO != GEK_VAR.Gr_EstadoNAF.PENDIENTE --'P'
                  );
    --
    Lr_numeroSerie  C_NUMERO_SERIE%ROWTYPE := NULL;
    Lr_DatosActivo  C_ACTIVO_FIJO%ROWTYPE := NULL;
    Le_Error        EXCEPTION;
    --
  BEGIN
    
    --Si existe se valida que este fuera de bodega para reingresarse.
    IF C_NUMERO_SERIE%ISOPEN THEN CLOSE C_NUMERO_SERIE; END IF;
    OPEN C_NUMERO_SERIE;
    FETCH C_NUMERO_SERIE INTO Lr_numeroSerie;
    IF C_NUMERO_SERIE%FOUND THEN
      Pv_MensajeError := 'Numero serie '||Pv_NumeroSerie||' se encuentra en bodega '||Lr_numeroSerie.id_bodega||
                         ' asociado a producto '||Lr_numeroSerie.no_articulo||
                         ' de la Empresa '||Lr_numeroSerie.compania||', no puede ser ingresado.';
      RAISE Le_Error;
    END IF;
    CLOSE C_NUMERO_SERIE;
    --
    -- se valida que activo fijo no se ecnuentre dado de baja
    IF C_ACTIVO_FIJO%ISOPEN THEN
      CLOSE C_ACTIVO_FIJO;
    END IF;
    OPEN C_ACTIVO_FIJO;
    FETCH C_ACTIVO_FIJO INTO Lr_DatosActivo;
    IF C_ACTIVO_FIJO%NOTFOUND THEN
      Lr_DatosActivo := NULL;
    END IF;
    CLOSE C_ACTIVO_FIJO;
    --
    IF Lr_DatosActivo.No_Acti IS NOT NULL THEN
      Pv_MensajeError := 'N�mero de serie '||Pv_NumeroSerie||' pertenece a activo fijo '||Lr_DatosActivo.No_Acti||' dado de Baja en la empresa '||Lr_DatosActivo.No_Cia;
      RAISE Le_Error;
    END IF;
    --
    -- Se verifica si numero dew serie existe en el repositorio --
    FOR VR IN C_VERIFICA_REPOSITORIO LOOP
      IF VR.ESTADO = 'IN' THEN
        IF Pv_MensajeError IS NULL THEN
          Pv_MensajeError := VR.DESC_ESTADO||' desde '||TO_CHAR(VR.FE_ULT_MOD,'DD/MM/YYYY');
        ELSE
          Pv_MensajeError := Pv_MensajeError||CHR(13)||VR.DESC_ESTADO||' desde '||TO_CHAR(VR.FE_ULT_MOD,'DD/MM/YYYY');
        END IF;
      ELSIF VR.ESTADO = 'PI' THEN
        IF Pv_MensajeError IS NULL THEN
          Pv_MensajeError := VR.DESC_ESTADO||' desde '||TO_CHAR(VR.FE_CREACION,'DD/MM/YYYY');
        ELSE
          Pv_MensajeError := Pv_MensajeError||CHR(13)||VR.DESC_ESTADO||' desde '||TO_CHAR(VR.FE_CREACION,'DD/MM/YYYY');
        END IF;
      END IF;
    END LOOP;
    
    IF Pv_MensajeError IS NOT NULL THEN
      Pv_MensajeError := 'No. Serie '||Pv_NumeroSerie||' se encuentra en Repositorio '||chr(13)||Pv_MensajeError||', Favor regule repositorio instalaci�n';
      RAISE Le_Error;
    END IF;
    
    
  EXCEPTION
    WHEN Le_Error THEN
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INK_DEVOLUCION_PEDIDO.P_VALIDA_NUMERO_SERIE',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := sqlerrm;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'INK_DEVOLUCION_PEDIDO.P_VALIDA_NUMERO_SERIE',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_VALIDA_NUMERO_SERIE;
  --
END INK_DEVOLUCION_PEDIDO;
/