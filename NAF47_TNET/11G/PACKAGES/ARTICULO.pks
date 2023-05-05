CREATE OR REPLACE PACKAGE            Articulo IS
   -- ---
   -- El paquete Articulo contiene una serie de procedimientos y
   -- funciones que facilitan el manejo de los articulos y servicios
   -- del Inventario.
   --
   -- Posee funciones que validan la existencia de un articulo y sus
   -- caracteristicas.
   --
   -- TIPO Registro para devuelver informacion general sobre un articulo;
   -- una variable de este tipo es devuelta por la funcion trae_datos
   --
   -- FEM 03-2009 Se modifica este paquete para que en la funcion Costo_uni y costo, tambien retorne
   -- el costo2 en donde se invoque a esa funcion.

   TYPE datos_r IS RECORD(descripcion          arinda.descripcion%type,
                          clase                arinda.clase%type,
                          categoria            arinda.categoria%type,
                          unidad               arinda.unidad%type,
                          peso                 arinda.peso%type,
                          tiempo_rep           arinda.tiempo_rep%type,
                          upc                  arinda.upc%type,
                          marca                arinda.marca%type,
                          grupo                arinda.grupo%type,
                          maximo               arinda.maximo%type,
                          minimo               arinda.minimo%type,
                          moneda_preciobase    arinda.moneda_preciobase%type,
                          preciobase           arinda.preciobase%type,
                          imp_ven              arinda.imp_ven%type,
                          ind_lote             arinda.ind_lote%type,
                          ind_activo           arinda.ind_activo%type,
                          aplica_impuesto      arinda.aplica_impuesto%type,
                          prod_serv            varchar2(1),
                          gracia_vencer        arinda.gracia_vencer%type,
                          disc_exc             arinda.disc_exc%type,
                          pack                 arinda.pack%type,
                          factor               arinda.factor%type,
                          aplica_garantia      arinda.aplica_garantia%type,
                          division             arinda.division%type,
                          subdivision          arinda.subdivision%type,
                          reorden              arinda.reorden%type,
                          es_combo             arinda.es_combo%type,
                          ind_requiere_serie   arinda.ind_requiere_serie%TYPE,
                                                    ind_requiere_mac     arinda.ind_mac%TYPE
                          );
   -- ---
   --* ACEPTA_Lote
   --  Devuelve verdadero si el producto se maneja por lotes
   --
   --* ACEPTA_Impuesto
   --  Devuelve verdadero si el producto es gravado
   --
   --* DESCRIPCION
   --  Devuelve el nombre de un producto del Inventario
   --
   --* EXISTE
   --  Busca el producto que recibe como parametro,
   --  validando primero si ya la tiene en memoria.
   --
   --* METODO COSTEO
   --  Devuelve el metodo de costeo de un articulo. Puede ser E estandar o P promedio.
   --
   --* INICIALIZA:
   --  Inicializa el paquete, cargando informacion sobre la cuenta contable
   --
   --* ACTIVO
   --  Devuelve verdadero si el producto esta Activo.
   --
   --* TRAE_DATOS
   --  Devuelve un registro con la informacion del producto indicado.
   --  valida primero si ya la cuenta esta en memoria
   --
   --* RELLENA_CODIGO_ALTERNO
   --
   --* EXISTE_CODIGO_ALTERNO
   --  Retorna TRUE si el codigo alterno dado como parametro corresponde a un articulo del
   --  inventario. En caso afirmativo, devuelve el codigo del articulo.
   --
   --* COSTO
   --  Devuelve el costo de un articulo en una bodega, dependiendo de su metodo de costeo utilizado
   --
   --* EXISTENCIA
   --  Devuelve la existencia (unidades) de un articulo en una bodega
   --
   --* SALDO_MONTO
   --  Devuelve el saldo (valuacion) de un articulo en una bodega dada.
   --
   --* DESGLOSE_EXISTENCIAS
   --  Retorna las existencias de un articulo en una bodega, desglosado en unidades de existencia y
   --  unidades pendientes.
   --
   --
   PROCEDURE inicializa(pCia varchar2);
   --
   FUNCTION existe(pCia     varchar2,
                   pArti    varchar2) Return Boolean;

   FUNCTION existe(pCia     varchar2,
                   pbodega  varchar2,
                   pArti    varchar2) Return Boolean;
   --
   FUNCTION acepta_lote(pCia     varchar2,
                        pArti    varchar2) Return Boolean;
   --
   FUNCTION acepta_impuesto(pCia     varchar2,
                            pArti    varchar2) Return Boolean;
   --
   FUNCTION activo(pCia     varchar2,
                   pArti    varchar2) Return Boolean;
   --
   FUNCTION costo_unitario(pCia     varchar2,
                           pBodega  varchar2,
                           pArti    varchar2,
                           pcosto_2 out number) Return Number;
   --
   FUNCTION trae_datos(pCia     varchar2,
                       pArti    varchar2) Return datos_r;
   --
   FUNCTION descripcion(pCia    varchar2,
                        pArti   varchar2) Return Varchar2;
   --
   FUNCTION rellena_codigo_alterno(pCia          varchar2,
                                   pcod_alterno  varchar2 ) Return Varchar2;
   --
   FUNCTION existe_codigo_alterno(pCia          varchar2,
                                  pcod_alterno  varchar2,
                                  pno_arti      in out varchar2 ) Return Boolean;
   --
   FUNCTION metodo_costeo(pCia        IN arinda.no_cia%type,
                          pArticulo   IN arinda.no_arti%type) Return Varchar2;
   --
   FUNCTION costo (pCia      in  arinda.no_cia%type,
                   pArticulo in  arinda.no_arti%type,
                   pBodega   in  arinma.bodega%type) Return Number;

   FUNCTION costo2(pCia      in  arinda.no_cia%type,
                   pArticulo in  arinda.no_arti%type,
                   pBodega   in  arinma.bodega%type) Return Number;
   --
   FUNCTION costo_mal_estado (pCia        IN arinda.no_cia%type,
                              pArticulo   IN arinda.no_arti%type,
                              pBodega     IN arinma.bodega%type,
                              pcosto      out number) Return Number;
   --
   FUNCTION existencia ( pCia        IN arinda.no_cia%type,
                         pArticulo   IN arinda.no_arti%type,
                         pBodega     IN arinma.bodega%type) Return Number;
   --
   PROCEDURE desglose_existencias ( pCia        IN arinda.no_cia%type,
                                    pArticulo   IN arinda.no_arti%type,
                                    pBodega     IN arinma.bodega%type,
                                    pExistencia IN OUT arinma.otrs_un%type,
                                    pPendientes IN OUT arinma.sal_pend_un%type);

   FUNCTION Cant_Picking (pCia        IN arinda.no_cia%type,
                          pArticulo   IN arinda.no_arti%type,
                          pBodega     IN arinma.bodega%type) Return Number;
   --
   FUNCTION saldo_monto ( pCia        IN arinda.no_cia%type,
                          pArticulo   IN arinda.no_arti%type,
                          pBodega     IN arinma.bodega%type ) Return Number;

   FUNCTION saldo2_monto ( pCia        IN arinda.no_cia%type,
                           pArticulo   IN arinda.no_arti%type,
                           pBodega     IN arinma.bodega%type ) Return Number;

   FUNCTION existencia_lote ( pCia        IN arinlo.no_cia%type,
                              pArticulo   IN arinlo.no_arti%type,
                              pBodega     IN arinlo.bodega%type,
                              pLote       IN arinlo.no_lote%type) Return Number;

   PROCEDURE desglose_exist_lote ( pCia        IN arinlo.no_cia%type,
                                  pArticulo   IN arinlo.no_arti%type,
                                  pBodega     IN arinlo.bodega%type,
                                  pLote       IN arinlo.no_lote%type,
                                  pExistencia IN OUT arinlo.saldo_unidad%type,
                                  pPend_Sal   IN OUT arinlo.salida_pend%type,
                                  pPend_Ped   IN OUT arinlo.pedidos_pend%type);
   --
   Function ultimo_error Return Varchar2;
   Function ultimo_mensaje Return Varchar2;
   --
   FUNCTION factor2 (pCia        IN arinda.no_cia%type,
                     pArticulo   IN arinda.no_arti%type,
                     ppedido     IN varchar2,
                     pEmbarque   IN Varchar2 default null
                    ) Return Number;
   --
   FUNCTION precioFob (pCia        IN arinda.no_cia%type,
                       pArticulo   IN arinda.no_arti%type,
                       ppedido     IN varchar2,
                       pEmbarque   IN Varchar2 default null
                      ) Return number;

    FUNCTION Es_Combo(
     pCia     varchar2,
     pArti    varchar2
   ) RETURN boolean;


   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error,-20033);
   kNum_error      NUMBER:= -20033;
   -- Define restricciones de procedimientos y funciones
   -- WNDS = Writes No Database State
   -- RNDS = Reads  No Database State
   -- WNPS = Writes No Package State
   -- RNPS = Reads  No Package State
   PRAGMA RESTRICT_REFERENCES(inicializa, WNDS);
   PRAGMA RESTRICT_REFERENCES(existe, WNDS);
   -- PRAGMA RESTRICT_REFERENCES(acepta_impuesto, WNDS);
   -- PRAGMA RESTRICT_REFERENCES(acepta_lote, WNDS);
   -- PRAGMA RESTRICT_REFERENCES(activo, WNDS);
   -- PRAGMA RESTRICT_REFERENCES(descripcion, WNDS);
   --
END;
/


CREATE OR REPLACE PACKAGE BODY            Articulo IS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   gno_cia           arcgmc.no_cia%type;
   gTstamp           number;
   --
   CURSOR c_datos_producto(pno_cia varchar2, pArti   varchar2) IS
     SELECT no_cia,       no_arti, descripcion, clase,           categoria,
            unidad,       peso,    disc_exc,
            tiempo_rep,   upc,     marca,       grupo,           maximo,
            minimo,       moneda_preciobase,    preciobase,      imp_ven,
            ind_lote,     ind_activo,           aplica_impuesto, gracia_vencer,
            decode(clase, '000', 'S', 'P')  prod_serv, -- Servicio o Producto
            pack, factor, aplica_garantia, division, subdivision, REORDEN,
            es_combo, ind_requiere_serie, ind_mac
       FROM arinda
      WHERE no_cia  = pno_cia
        AND no_Arti = pArti;
   --
   CURSOR c_datos_arti_bodega(pno_cia varchar2,
                              pBodega varchar2,
                              pArti   varchar2) IS
     SELECT no_cia, bodega, no_arti, costo_uni, costo2
       FROM arinma
      WHERE no_cia  = pno_cia
        AND bodega  = pBodega
        AND no_arti = pArti;
   --
   RegProd          c_datos_producto%ROWTYPE;
   RegProdBodega    c_datos_arti_bodega%ROWTYPE;
   vMensaje_error   varchar2(160);
   vMensaje         varchar2(160);
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := substr(msj_error, 1, 160);
      vMensaje       := vMensaje_Error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   PROCEDURE mensaje(msj IN VARCHAR2) IS
   BEGIN
      vMensaje  := msj;
   END;
   --
   -- --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN IS
   BEGIN
      RETURN ( nvl(gno_cia,'*NULO*') = pCia);
   END inicializado;
   --
   --
   /*******[ PARTE: PUBLICA ]
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje_error);
   END ultimo_error;
   --
   FUNCTION ultimo_mensaje RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje);
   END ultimo_mensaje;
   --
   PROCEDURE inicializa(pCia varchar2)
   IS
     CURSOR c_Cia IS
       SELECT no_cia
         FROM arcgmc
        WHERE No_cia = pCia;
   BEGIN
      OPEN  c_cia;
      FETCH c_cia INTO gNo_cia;
      IF c_Cia%NOTFOUND THEN
         CLOSE c_Cia;
         Genera_Error('La compa?ia no ha sido registrada');
      ELSE
         CLOSE c_Cia;
      END IF;
   END;
   --
   --
   FUNCTION existe(
     pCia   varchar2,
     pArti  varchar2
   ) RETURN boolean IS
     --
     vFound   boolean;
       vtstamp  number;
   BEGIN
     vFound := FALSE;
     vtstamp := TO_CHAR(sysdate, 'SSSSS');
     IF (gTstamp is null OR ABS(vtstamp - gTstamp) > 2) or
          (RegProd.no_cia is null OR RegProd.no_arti is null) or
        (RegProd.no_cia != pCia OR RegProd.no_arti != pArti) THEN
       RegProd.no_cia  := NULL;
       RegProd.no_arti := NULL;
       OPEN  c_datos_producto(pCia, pArti);
       FETCH c_datos_producto INTO RegProd;
       vFound := c_datos_producto%FOUND;
       CLOSE c_datos_producto;
       gTstamp := TO_CHAR(sysdate, 'SSSSS');
     ELSE
       vFound := (RegProd.no_cia = pCia AND RegProd.no_arti = pArti);
     END IF;
     return (vFound);
   END;
   --
   --
   FUNCTION existe(
     pCia     varchar2,
     pBodega  varchar2,
     pArti    varchar2
   ) RETURN boolean IS
     --
     vFound    boolean;
       vtstamp   number;
   BEGIN
     vFound := FALSE;
     vtstamp := to_char(sysdate, 'SSSSS');
     IF (gTstamp is null OR ABS(vtstamp - gTstamp) > 1) or
        (RegProdBodega.no_cia is null or RegProdBodega.bodega is null or
         RegProdBodega.no_arti is null) or (RegProdBodega.no_cia  != pCia
         or RegProdBodega.bodega != pBodega or RegProdBodega.no_arti != pArti) then
       RegProdBodega.no_cia  := NULL;
       RegProdBodega.bodega  := NULL;
       RegProdBodega.no_arti := NULL;
       OPEN  c_datos_arti_bodega(pCia, pBodega, pArti);
       FETCH c_datos_arti_bodega INTO RegProdBodega;
       vFound := c_datos_arti_bodega%FOUND;
       CLOSE c_datos_arti_bodega;
       gTstamp := TO_CHAR(sysdate, 'SSSSS');
     ELSE
       vFound := (RegProdBodega.no_cia = pCia AND
       RegProdBodega.bodega = pBodega AND
       RegProdBodega.no_arti = pArti);
     END IF;

     IF pBodega = '0000' THEN -- en caso de servicio siempre existe..
       return(true);
     ELSE
       return (vFound);
     END IF;
   END;
   --
   --
   FUNCTION costo_unitario(pCia     varchar2,
                           pBodega  varchar2,
                           pArti    varchar2,
                           pcosto_2 out number) /*FEM*/ return number Is
     --
     vcosto_uni arinma.costo_uni%type;
     --
   Begin
        If existe(pCia, pBodega, pArti) Then
            vcosto_uni := RegProdBodega.costo_uni;
       pcosto_2   := RegProdBodega.costo2;  --FEM 03-2009
        Else
             genera_error ('El articulo/servicio '|| pArti || ' no existe en la bodega ' || pBodega);
        End If;
     ---
        Return (vcosto_uni);
     ---
   END costo_unitario;
   --
   --
   FUNCTION trae_datos(
      pCia     varchar2,
      pArti    varchar2
   ) RETURN datos_r IS
      vreg_arti     datos_r;
   BEGIN
      IF existe(pCia, pArti) THEN
        vreg_arti.descripcion          := RegProd.descripcion;
        vreg_arti.clase                := RegProd.clase;
        vreg_arti.categoria            := RegProd.categoria;
        vreg_arti.unidad               := RegProd.unidad;
        vreg_arti.peso                 := RegProd.peso;
        vreg_arti.disc_exc             := RegProd.disc_exc;
        vreg_arti.tiempo_rep           := RegProd.tiempo_rep;
        vreg_arti.upc                  := RegProd.upc;
        vreg_arti.marca                := RegProd.marca;
        vreg_arti.grupo                := RegProd.grupo;
        vreg_arti.maximo               := RegProd.maximo;
        vreg_arti.minimo               := RegProd.minimo;
        vreg_arti.moneda_preciobase    := RegProd.moneda_preciobase;
        vreg_arti.preciobase           := RegProd.preciobase;
        vreg_arti.imp_ven              := RegProd.imp_ven;
        vreg_arti.ind_lote             := RegProd.ind_lote;
        vreg_arti.ind_activo           := RegProd.ind_activo;
        vreg_arti.aplica_impuesto      := RegProd.aplica_impuesto;
        vreg_arti.gracia_vencer        := RegProd.gracia_vencer;
        vreg_arti.pack                 := RegProd.pack;
        vreg_arti.factor               := RegProd.factor;
        vreg_arti.aplica_garantia      := RegProd.aplica_garantia;
        vreg_arti.division             := RegProd.division;
        vreg_arti.subdivision          := RegProd.subdivision;
        vreg_arti.REORDEN              := RegProd.REORDEN;
        vreg_arti.es_combo             := RegProd.es_combo;
        vreg_arti.ind_requiere_serie   := RegProd.ind_requiere_serie;
                vreg_arti.ind_requiere_mac     := RegProd.ind_mac;

        IF vreg_arti.grupo is null THEN
          genera_error('El articulo/servicio no tiene grupo contable definido');
        END IF;

        IF vreg_arti.ind_activo <> 'S' THEN
          genera_error('El articulo/servicio se encuentra inactivo');
        END IF;
      ELSE
        genera_error('El articulo/servicio '||pArti|| 'no esta definido');
      END IF;
      return (vreg_arti);
   END trae_datos;
   --
   --
   FUNCTION descripcion(pCia     varchar2,
                        pArti    varchar2) RETURN varchar2 IS
   BEGIN
     IF pArti is null THEN
       return(' ');
     ELSIF existe(pCia, pArti) THEN
       return( RegProd.descripcion );
     ELSE
       return( 'El articulo/servicio no esta definido' );
     END IF;
   END descripcion;
   --
   --
   FUNCTION acepta_lote(pCia     varchar2,
                        pArti    varchar2) RETURN boolean IS
     --
     vvalor varchar2(1);
   BEGIN
     IF pArti is null THEN
       return (FALSE);
     ELSIF existe(pCia, pArti) THEN
       IF RegProd.ind_lote = 'L' THEN
           vvalor := 'S';
       ELSE
           vvalor := 'N';
       END IF;
       return( vvalor = 'S' );
     ELSE
       genera_error('El articulo/servicio '||pArti||' no existe');
       return (FALSE);
     END IF;
   END acepta_lote;
   --
   --
   FUNCTION acepta_impuesto(pCia     varchar2,
                            pArti    varchar2) RETURN BOOLEAN IS
     vvalor varchar2(1);
   BEGIN
     IF pArti is null THEN
       return (FALSE);
     ELSIF existe(pCia, pArti) THEN
       IF RegProd.aplica_impuesto = 'G' THEN
           vvalor := 'S';
       ELSE
           vvalor := 'N';
       END IF;
       return( vvalor = 'S' );
     ELSE
       genera_error('El articulo/servicio '||pArti||' no existe');
       return (FALSE);
     END IF;
   END acepta_impuesto;
   --
   --
   FUNCTION activo(pCia     varchar2,
                   pArti    varchar2) RETURN boolean IS
   BEGIN
     IF pArti is null THEN
       return (FALSE);
     ELSIF existe(pCia, pArti) THEN
       return( RegProd.ind_activo = 'S' );
     ELSE
       genera_error('El articulo/servicio  : '||pArti||' no existe');
       return (FALSE);
     END IF;
   END activo;
   --
   FUNCTION rellena_codigo_alterno(pCia          varchar2,
                                   pcod_alterno  varchar2) RETURN VARCHAR2 IS
   BEGIN
        -- aplica una logica no implementada aun para
        -- rellenar el codigo alterno
     If pcia is null then
        Null;
     End if;

        RETURN (pcod_alterno);
   END;
   --
   --
   FUNCTION existe_codigo_alterno(pCia          varchar2,
                                  pcod_alterno  varchar2,
                                  pno_arti      in out varchar2) RETURN BOOLEAN IS
     vencontrado  boolean;
     CURSOR c_alterno(pcodigo_alt varchar2) IS
       SELECT no_arti
         FROM arincodalt
        WHERE no_cia       = pcia
          AND cod_alterno  = pcodigo_alt;
   BEGIN
         OPEN  c_alterno(pcod_alterno);
         FETCH c_alterno INTO pno_arti;
         vencontrado := c_alterno%FOUND;
         CLOSE c_alterno;
         RETURN (vencontrado);
   END;
   --
   --
   FUNCTION metodo_costeo( pCia        IN arinda.no_cia%type,
                           pArticulo   IN arinda.no_arti%type) RETURN VARCHAR2 IS

    CURSOR c_metodo IS
      SELECT  g.metodo_costo
        FROM arinda d, grupos g
       WHERE d.no_cia     = pCia
         AND d.no_arti    = pArticulo
         AND g.no_cia     = d.no_cia
         AND g.grupo      = d.grupo;

      vMetodo    grupos.metodo_costo%type;
      vEncontro  boolean;
   BEGIN
       OPEN  c_metodo;
       FETCH c_metodo INTO vMetodo;
       vEncontro := c_metodo%found;
       CLOSE c_metodo;
       IF NOT vEncontro THEN
      genera_error('El articulo '||pArticulo||' o su grupo contable no esta definido ');
       END IF;

       IF vMetodo is null THEN
      genera_error('El articulo '||pArticulo||' no tiene metodo de costeo definido ');
       END IF;


       RETURN(vMetodo);
   END;
   --

   FUNCTION costo (pCia        IN arinda.no_cia%type,
                   pArticulo   IN arinda.no_arti%type,
                   pBodega     IN arinma.bodega%type) Return number Is
    --
    -- Retorna el costo (promedio/estandar) del articulo, dependiendo del grupo
    -- y la bodega. En caso de error, retorna en pMsg el detalle del mismo.
    --
    vcosto_promedio    arinma.costo_uni%type;
    vcosto_estandar    number(17,2):=0;
    vcosto            arinma.costo_uni%type;
    vmetodo         grupos.metodo_costo%type;
    vtmp            varchar2(1):=null;
    vExiste         boolean;
    --
  Cursor c_articulo Is
  Select m.costo_uni,
         d.costo_estandar, g.metodo_costo
    From arinda d, arinma m, grupos g
   Where d.no_cia     = pCia
     And d.no_arti    = pArticulo
     And d.ind_activo = 'S'
     And m.no_cia     = d.no_cia
     And m.no_arti    = d.no_arti
     And m.bodega     = pBodega
     And g.no_cia     = d.no_cia
     And g.grupo      = d.grupo;
    --
  Cursor c_bodega Is
  Select 'X'
    From arinbo
   Where no_cia = pCia
     And codigo = pBodega;
    ---
  Begin
    ---
    If pCia is null or pArticulo is null or pBodega is null then
       vCosto:= 0;
       Return(vCosto);
    End If;

    Open c_bodega;
    Fetch c_bodega Into vtmp;
    vExiste := c_bodega%Found;
    Close c_bodega;
    ---
    If vtmp is null Then
      genera_error('La Bodega '||pBodega||' no Existe');
    End If;
    ---
    If pBodega != '0000' Then
      ---
      Open c_articulo;
      Fetch c_articulo into vcosto_promedio, vcosto_estandar, vmetodo;
      vExiste  := c_articulo%Found;
      Close c_articulo;
      ---
      If not vExiste Then
        genera_error('El articulo '||pArticulo||' no existe, no esta definido en la bodega '||pBodega||' o se encuentra inactivo');
      End If;
      ---
      If (vmetodo = 'P') Then
        vcosto := vcosto_promedio;
      Else
        vcosto := vcosto_estandar;
      End If;
      ---
    Else -- bodega de servicios
      vcosto := 0;
    End If;
    ---
    Return(vCosto);
    ---
  Exception
    When Others then
     genera_error(sqlerrm);
  End;


   -- FEM Funcion agregada para que retorne el costo2
   --
   FUNCTION costo2 (pCia        IN arinda.no_cia%type,
                    pArticulo   IN arinda.no_arti%type,
                    pBodega     IN arinma.bodega%type) Return number Is
    --
    -- Retorna el costo (promedio/estandar) del articulo, dependiendo del grupo
    -- y la bodega. En caso de error, retorna en pMsg el detalle del mismo.
    --
    vcosto_promedio    arinma.costo_uni%type;
    vcosto_estandar    number(17,2):=0;
    vcosto            arinma.costo_uni%type;
    vmetodo         grupos.metodo_costo%type;
    vtmp            varchar2(1):=null;
    vExiste         boolean;
    --
  Cursor c_articulo Is
  Select nvl(m.costo2,0),
         d.costo_estandar, g.metodo_costo
    From arinda d, arinma m, grupos g
   Where d.no_cia     = pCia
     And d.no_arti    = pArticulo
     And d.ind_activo = 'S'
     And m.no_cia     = d.no_cia
     And m.no_arti    = d.no_arti
     And m.bodega     = pBodega
     And g.no_cia     = d.no_cia
     And g.grupo      = d.grupo;
    --
  Cursor c_bodega Is
  Select 'X'
    From arinbo
   Where no_cia = pCia
     And codigo = pBodega;
    ---
  Begin
    ---
    If pCia is null or pArticulo is null or pBodega is null then
       vCosto:= 0;
       Return(vCosto);
    End If;
    ---
    Open c_bodega;
    Fetch c_bodega Into vtmp;
    vExiste := c_bodega%Found;
    Close c_bodega;
    ---
    If vtmp is null Then
      genera_error('La Bodega '||pBodega||' no Existe');
    End If;
    ---
    If pBodega != '0000' Then
      ---
      Open c_articulo;
      Fetch c_articulo into vcosto_promedio, vcosto_estandar, vmetodo;
      vExiste  := c_articulo%Found;
      Close c_articulo;
      ---
      If not vExiste Then
        genera_error('El articulo '||pArticulo||' no existe, no esta definido en la bodega '||pBodega||' o se encuentra inactivo');
      End If;
      ---
      If (vmetodo = 'P') Then
        vcosto := vcosto_promedio;
      Else
        vcosto := vcosto_estandar;
      End If;
      ---
    Else -- bodega de servicios
      vcosto := 0;
    End If;
    ---
    Return(vCosto);
    ---
  Exception
    When Others then
     genera_error(sqlerrm);
  End;
  ---

  Function costo_mal_estado (pCia        IN arinda.no_cia%type,
                             pArticulo   IN arinda.no_arti%type,
                             pBodega     IN arinma.bodega%type,
                             pcosto      OUT number) Return number IS
    --
    -- Retorna el costo (promedio/estandar) del articulo, dependiendo del grupo
    -- y la bodega. En caso de error, retorna en pMsg el detalle del mismo.
    --
    vcosto_promedio       arinma.costo_uni%type;
    vcosto_estandar       arinma.costo_uni%type;
    vcosto               arinma.costo_uni%type;
    vmetodo            grupos.metodo_costo%type;
    vtmp               Varchar2(1);
    vExiste            Boolean;
    --
    Cursor c_articulo Is
      Select m.costo_uni, d.costo_estandar, g.metodo_costo, m.costo2
        From arinda d, arinma m, grupos g
       Where d.no_cia     = pCia
         And d.no_arti    = pArticulo
         And d.ind_activo = 'S'
         And m.no_cia     = d.no_cia
         And m.no_arti    = d.no_arti
         And m.bodega     = pBodega
         And g.no_cia     = d.no_cia
         And g.grupo      = d.grupo;
    --
    Cursor c_bodega Is
    Select 'X'
      From arinbo
     Where no_cia = pCia
       And codigo = pBodega;
    --
  Begin
    ---
    Open c_bodega;
    Fetch c_bodega Into vtmp;
    vExiste  := c_bodega%Found;
    Close c_bodega;
    ---
    If not vExiste Then
      genera_error('La bodega '||pBodega||' no existe');
    End If;
    ---
    If pBodega != '0000' Then
      Open c_articulo;
      Fetch c_articulo into vcosto_promedio, vcosto_estandar, vmetodo, pcosto;
      vExiste := c_articulo%Found;
      Close c_articulo;
      ---
      If not vExiste Then
        genera_error('El articulo '||pArticulo||' no existe, no esta definido en la bodega '||pBodega||' o se encuentra inactivo');
      End If;
      ---
      If (vmetodo = 'P') Then
        vcosto := vcosto_promedio;
      Else
        vcosto := vcosto_estandar;
      End If;
      ---
    Else -- bodega de servicios
      vcosto := 0;
    End If;

    Return(vCosto);

  Exception
    When Others Then
     genera_error(sqlerrm);
  End;


  --
  FUNCTION existencia (
    pCia        IN arinda.no_cia%type,
    pArticulo   IN arinda.no_arti%type,
    pBodega     IN arinma.bodega%type
  ) RETURN number IS
    --
    vExistencias   arinma.sal_ant_un%type;
    vPendientes    arinma.sal_pend_un%type;
  BEGIN
    desglose_existencias ( pCia, pArticulo, pBodega, vExistencias, vPendientes );

    vExistencias := nvl(vExistencias,0) - nvl(vPendientes,0);

    If vExistencias < 0 Then
       vExistencias := 0;
    End if;

    return(vExistencias);
  END;
  --
  --
  PROCEDURE desglose_existencias (pCia        IN arinda.no_cia%type,
                                  pArticulo   IN arinda.no_arti%type,
                                  pBodega     IN arinma.bodega%type,
                                  pExistencia IN OUT arinma.otrs_un%type,
                                  pPendientes IN OUT arinma.sal_pend_un%type) IS

    CURSOR c_existencias_arti IS
      SELECT nvl(sal_ant_un,0) + nvl(comp_un,0) + nvl(otrs_un,0) - nvl(cons_un,0) -
             nvl(vent_un, 0) stock,
             nvl(manifiestopend,0) +
             ---nvl(pedidos_pend,0)  ---- se reemplaza por la consulta en la funcion ANR 10/02/2010
             (INPENDIENTE.Ped_pend_articulo(no_cia, bodega, no_arti) + INPENDIENTE.Fact_pend_articulo(no_cia, bodega, no_arti))
             ---+ nvl(sal_pend_un,0)
             + (INPENDIENTE.Sal_pend_articulo(no_cia, bodega, no_arti) + INPENDIENTE.Sal_pend_tr_articulo(no_cia, bodega, no_arti)) pendientes
        FROM arinma
       WHERE no_cia     = pCia
         AND bodega     = pBodega
         AND no_arti    = pArticulo ;
    --
    vencontro      boolean;

  BEGIN
      IF pBodega != '0000' THEN

        OPEN  c_existencias_arti;
        FETCH c_existencias_arti INTO pExistencia, pPendientes;
        vencontro := c_existencias_arti%found;
        CLOSE c_existencias_arti;

        IF not vencontro THEN
            genera_error('El articulo/servicio '||pArticulo||' no esta registrado en la bodega '||pBodega||' Asocie el Articulo a la bodega indicada');
      END IF;

      ELSE
        --
        -- si se trata de un servicio, se devuelve 0
        pExistencia := 0;
        pPendientes := 0;
      END IF;
  END;
  --
  ---- Devuelve la cantidad de picking

    FUNCTION Cant_Picking (pCia        IN arinda.no_cia%type,
                           pArticulo   IN arinda.no_arti%type,
                           pBodega     IN arinma.bodega%type) return Number IS

    CURSOR C_Cant_Picking IS
      Select sum(c.cant_sistema) cant_picking
      from   arfaenc_picking b, arfadet_picking c
      where  b.no_cia     = pCia
      and    c.no_arti    = pArticulo
      and    c.bodega     = pBodega
      and    b.estado     = 'P' --- Pedidos en picking
      and    b.no_cia     = c.no_cia
      and    b.centrod    = c.centrod
      and    b.no_docu    = c.no_docu
      and    b.no_picking = c.no_picking;
    --
    Ln_Picking     Arfadet_picking.cant_sistema%type;
    vencontro      boolean;

  BEGIN
      IF pBodega != '0000' THEN

        OPEN  C_Cant_Picking;
        FETCH C_Cant_Picking INTO Ln_Picking;
        vencontro := C_Cant_Picking%found;
        CLOSE C_Cant_Picking;

        IF not vencontro THEN
         return (0);
      ELSE
         return (Ln_Picking);
      END IF;

      ELSE
        --
        -- si se trata de un servicio, se devuelve 0
        return (0);
      END IF;
  END;

  --
  FUNCTION saldo_monto (pCia        IN arinda.no_cia%type,
                        pArticulo   IN arinda.no_arti%type,
                        pBodega     IN arinma.bodega%type) Return number Is
    --
    CURSOR c_arti IS
      SELECT nvl(sal_ant_mo,0) + nvl(comp_mon,0) + nvl(otrs_mon,0) - nvl(cons_mon,0) -
             nvl(vent_mon, 0)
        FROM arinma
       WHERE no_cia     = pCia
         AND bodega     = pBodega
         AND no_arti    = pArticulo ;
    --
    vSaldo     arinma.sal_ant_mo%type;
    vencontro  boolean;
  BEGIN

      IF pBodega != '0000' THEN
        OPEN  c_arti;
        FETCH c_arti INTO vSaldo;
        vencontro := c_arti%found;
        CLOSE c_arti;

        IF not vencontro THEN
            genera_error('El articulo/servicio '||pArticulo||' no esta registrado en la bodega '||pBodega);
      END IF;
      ELSE
        --
        -- si se trata de un servicio, se devuelve 0 en el saldo (valor)
        vSaldo := 0;
      END IF;

      return(nvl(vSaldo,0));
  END;

  --
  FUNCTION saldo2_monto (pCia        IN arinda.no_cia%type,
                        pArticulo   IN arinda.no_arti%type,
                        pBodega     IN arinma.bodega%type) Return number Is
    --
    CURSOR c_arti IS
      SELECT nvl(monto2,0)
        FROM arinma
       WHERE no_cia     = pCia
         AND bodega     = pBodega
         AND no_arti    = pArticulo ;
    --
    vSaldo     arinma.sal_ant_mo%type;
    vencontro  boolean;
  BEGIN

      IF pBodega != '0000' THEN
        OPEN  c_arti;
        FETCH c_arti INTO vSaldo;
        vencontro := c_arti%found;
        CLOSE c_arti;

        IF not vencontro THEN
            genera_error('El articulo/servicio '||pArticulo||' no esta registrado en la bodega '||pBodega);
      END IF;
      ELSE
        --
        -- si se trata de un servicio, se devuelve 0 en el saldo (valor)
        vSaldo := 0;
      END IF;

      return(nvl(vSaldo,0));
  END;
  --
  FUNCTION existencia_lote (
    pCia        IN arinlo.no_cia%type,
    pArticulo   IN arinlo.no_arti%type,
    pBodega     IN arinlo.bodega%type,
    pLote       IN arinlo.no_lote%type
  ) RETURN number IS
    --
    vExistencias   arinlo.saldo_unidad%type;
    vPend_Sal      arinlo.salida_pend%type;
    vPend_Ped      arinlo.pedidos_pend%type;

  BEGIN
    desglose_exist_lote ( pCia, pArticulo, pBodega, pLote, vExistencias, vPend_Sal, vPend_Ped );

    vExistencias := nvl(vExistencias,0) - nvl(vPend_Sal,0) - nvl(vPend_Ped,0);

    return(vExistencias);
  END;

  PROCEDURE desglose_exist_lote  (pCia        IN arinlo.no_cia%type,
                                  pArticulo   IN arinlo.no_arti%type,
                                  pBodega     IN arinlo.bodega%type,
                                  pLote       IN arinlo.no_lote%type,
                                  pExistencia IN OUT arinlo.saldo_unidad%type,
                                  pPend_Sal   IN OUT arinlo.salida_pend%type,
                                  pPend_Ped   IN OUT arinlo.pedidos_pend%type) IS

    CURSOR c_existencias_lote IS
      SELECT nvl(saldo_unidad,0),
             ----nvl(salida_pend,0), nvl(pedidos_pend,0)--- se reemplaza por la consulta en la funcion ANR 10/02/2010
             (INPENDIENTE.Sal_pend_lote(no_cia, bodega, no_arti, no_lote) + INPENDIENTE.Sal_pend_tr_lote(no_cia, bodega, no_arti,  no_lote)) sal_pend_lote,
             (INPENDIENTE.Ped_pend_lote(no_cia, bodega, no_arti, no_lote) + INPENDIENTE.Fact_pend_lote(no_cia, bodega, no_arti, no_lote)) ped_pend_lote
        FROM arinlo
       WHERE no_cia     = pCia
         AND bodega     = pBodega
         AND no_arti    = pArticulo
         AND no_lote    = pLote ;
    --
    vencontro      boolean;

  BEGIN
      IF pBodega != '0000' THEN

        OPEN  c_existencias_lote;
        FETCH c_existencias_lote INTO pExistencia, pPend_Sal, pPend_Ped;
        vencontro := c_existencias_lote%found;
        CLOSE c_existencias_lote;

        IF not vencontro THEN
            genera_error('El articulo: '||pArticulo||' con el lote: '||pLote||' no esta registrado en la bodega: '||pBodega);
      END IF;

      ELSE
        --
        -- si se trata de un servicio, se devuelve 0
        pExistencia := 0;
        pPend_Sal   := 0;
      pPend_Ped   := 0;
      END IF;
  END;

  --- Obtiene el factor 2 del articulo
  FUNCTION factor2 (pCia        IN arinda.no_cia%type,
                    pArticulo   IN arinda.no_arti%type,
                    ppedido     IN varchar2,
                    pembarque   IN varchar2 default null
                    ) Return number Is

  -- Declaraciones de cursores
 -- Declaraciones de cursores
    -- Declaraciones de cursores
  CURSOR factor_2(cv_nocia    varchar2,
                  cv_articulo varchar2,
                  cv_pedido   varchar2
                  ) IS
/*   select d.factor_2
    from arimencpedido a,
         arimencdoc b,
         arimdetdoc c,
         arimdetcosteo d
    where a.no_cia = cv_nocia
    and a.pedido_especial = cv_pedido -- Pedido Normal o especial
    and d.no_embarque = nvl(pembarque,d.no_embarque) -- el nvl es porque el pembarque en la pantalla de asignacion de precios es nulo
    and d.no_arti = cv_articulo
    and b.estado = 'A'
    and a.no_cia = b.no_cia
    and a.no_embarque = b.no_embarque
    and b.no_cia = c.no_cia
    and b.no_docu = c.no_docu
    and b.no_cia = d.no_cia
    and b.no_embarque = d.no_embarque
    and c.no_cia = d.no_cia
    and c.no_arti = d.no_arti
    order by b.fecha desc; */
    Select d.factor_2
      From  Arimencpedido a,
           Arimencdoc    b,
           Arimdetdoc    c,
           Arimdetcosteo d,
           Arimencosteo  e -- Emendoza
     Where a.No_Cia = b.No_Cia
       And b.No_Cia = c.No_Cia
       And b.No_Cia = d.No_Cia
       And c.No_Cia = d.No_Cia
       And d.No_Cia = e.No_Cia
       And e.No_Cia = cv_nocia
       And nvl(a.Pedido_Especial,'N') = cv_pedido -- Pedido Normal o especial
       And d.No_Arti = cv_articulo
       And b.Estado  = 'A'
       And a.No_Embarque = b.No_Embarque
       And b.No_Docu     = c.No_Docu
       And b.No_Embarque = d.No_Embarque
       And c.No_Arti     = d.No_Arti
       And d.No_Embarque = e.No_Embarque
       And e.No_Embarque = nvl(pembarque,d.no_embarque) -- el nvl es porque el pembarque en la pantalla de asignacion de precios es nulo
     Order By e.Fecha_Creacion Desc;

  CURSOR factor_2_aux(cv_nocia    varchar2,
                      cv_articulo varchar2,
                      cv_pedido   varchar2
                     )IS
/*   Select MAX(d.factor_2) factor2, MAX(b.fecha) fecha
    from arimencpedido a,
         arimencdoc b,
         arimdetdoc c,
         arimdetcosteo d
    where a.no_cia = cv_nocia
    and nvl(a.Pedido_Especial,'N') = cv_pedido -- Pedido Normal o especial
    and d.no_arti = cv_articulo
    and b.estado = 'A'
    and a.no_cia = b.no_cia
    and a.no_embarque = b.no_embarque
    and b.no_cia = c.no_cia
    and b.no_docu = c.no_docu
    and b.no_cia = d.no_cia
    and b.no_embarque = d.no_embarque
    and c.no_cia = d.no_cia
    and c.no_arti = d.no_arti;  */
    Select d.factor_2 factor2
    From Arimencpedido a,
         Arimencdoc    b,
         Arimdetdoc    c,
         Arimdetcosteo d,
         Arimencosteo  e -- Emendoza
     Where a.No_Cia = b.No_Cia
       And b.No_Cia = c.No_Cia
       And b.No_Cia = d.No_Cia
       And c.No_Cia = d.No_Cia
       And d.No_Cia = e.No_Cia
       And e.No_Cia = cv_nocia
       And nvl(a.Pedido_Especial,'N') = cv_pedido -- Pedido Normal o especial
       And d.No_Arti = cv_articulo
       And b.Estado  = 'A'
       And a.No_Embarque = b.No_Embarque
       And b.No_Docu     = c.No_Docu
       And b.No_Embarque = d.No_Embarque
       And c.No_Arti     = d.No_Arti
       And d.No_Embarque = e.No_Embarque
     Order By e.Fecha_Creacion Desc;

  -- Declaracion de variables
  ln_factor2    NUMBER;
  vEncontro     BOOLEAN;
  lc_valores    factor_2_aux%ROWTYPE;
  --
  BEGIN
   --
   ln_factor2 := 0;
   --
   OPEN factor_2(pCia,pArticulo,ppedido);
   FETCH factor_2 INTO ln_factor2;
     vEncontro := factor_2%notfound;
   CLOSE factor_2;
   --
   IF vEncontro THEN
    --
    OPEN factor_2_aux(pCia,pArticulo,ppedido);
    FETCH factor_2_aux INTO lc_valores;
    CLOSE factor_2_aux;
    --
    IF lc_valores.factor2 IS NULL THEN
      ln_factor2 := 0;
    ELSE
      ln_factor2 := lc_valores.factor2;
    END IF;
    --
   END IF;
   --
   RETURN(ln_factor2);
   --

   --
 END;   --


  --- Obtiene el Precio Fob del articulo
  FUNCTION precioFob (pCia        IN arinda.no_cia%type,
                      pArticulo   IN arinda.no_arti%type,
                      ppedido     IN varchar2,
                      pEmbarque   IN Varchar2 default null
                     ) Return number Is

   -- Declaraciones de cursores
  CURSOR precio_fob_pedido(cv_nocia    varchar2,
                  cv_articulo varchar2,
                  cv_pedido   varchar2
                  ) IS
   select d.fob
    from arimencpedido a,
         arimencdoc b,
         arimdetdoc c,
         arimdetcosteo d
    where a.no_cia = cv_nocia
    and a.pedido_especial = cv_pedido -- Pedido Normal o especial
    and d.no_embarque = nvl(pembarque,d.no_embarque)
    and d.no_arti = cv_articulo
    and b.estado = 'A'
    and a.no_cia = b.no_cia
    and a.no_embarque = b.no_embarque
    and b.no_cia = c.no_cia
    and b.no_docu = c.no_docu
    and b.no_cia = d.no_cia
    and b.no_embarque = d.no_embarque
    and c.no_cia = d.no_cia
    and c.no_arti = d.no_arti
    order by b.fecha desc;

   -- Declaracion de variables
   ln_precioFob  NUMBER;
   --
   BEGIN
    --
    ln_precioFob := 0;
    --
    OPEN precio_fob_pedido (pCia,pArticulo, pPedido);
    FETCH precio_fob_pedido INTO ln_precioFob;
    IF precio_fob_pedido%notfound Then
    CLOSE precio_fob_pedido;
      --
    ln_precioFob := 0;

    ELSE
    CLOSE precio_fob_pedido;
    END IF;
    --
    RETURN(ln_precioFob);
   --
  END;
  --

   FUNCTION Es_Combo(
     pCia     varchar2,
     pArti    varchar2
   ) RETURN boolean IS
     --
     vvalor varchar2(1);
   BEGIN
     IF pArti is null THEN
       return (FALSE);
     ELSIF existe(pCia, pArti) THEN
       IF RegProd.Es_Combo = 'S' THEN
           vvalor := 'S';
       ELSE
           vvalor := 'N';
       END IF;
       return( vvalor = 'S' );
     ELSE
       genera_error('El articulo/servicio '||pArti||' no existe');
       return (FALSE);
     END IF;
   END Es_Combo;

END;
/
