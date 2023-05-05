CREATE OR REPLACE PACKAGE            Oferta IS
   --
   -- El paquete Oferta contiene una serie de procedimientos y
   -- funciones que facilitan el manejo de las ofertas sobre articulos
   -- del Inventario.
   --
   -- El tipo de registro datos_r contiene toda la informacion relacionada con las ofertas,
   -- y es devuelta por la funcion trae_datos.
   --
   TYPE datos_r IS RECORD(
     codigo          	   arfaprom.codigo%TYPE,
     tipo_prom       	   arfaprom.tipo_prom%TYPE,   -- Por (C)liente, (T)ipo de cliente, (G)eneral
     tipo_cliente    	   arfaprom.tipo_cliente%TYPE,
     grupo           	   arfaprom.grupo%TYPE,
     no_cliente      	   arfaprom.no_cliente%TYPE,
     no_arti         	   arfaprom.no_arti%TYPE,
     producto_oferta 	   arfaprom.fix_plat%TYPE,    -- (1) Porcentaje, (2) Mismo articulo, (3) articulo Alterno
     min_unidades    	   arfaprom.min_qty%TYPE,
     max_unidades    	   arfaprom.max_qty%TYPE,
     porcentaje      	   arfaprom.centsoff%TYPE,
     cant_oferta           arfaprom.b_f_qty%TYPE,
     protegido             arfaprom.promo_prot%TYPE,
     no_arti_alterno       arfaprom.alt_pcode%TYPE,
     fecha_inicio          arfaprom.beg_date%TYPE,
     fecha_fin             arfaprom.end_date%TYPE,
     psi_item              arfaprom.psi_item%TYPE,
     promo                 arfaprom.promo%TYPE,
     ind_unidad_facturada  arfaprom.ind_unidad_facturada%TYPE
   );
   -- ---
   --* EXISTE
   --  Busca la oferta que recibe como parametro
   --  valida primero si ya esta en memoria
   --
   --* INICIALIZA:
   --  Inicializa el paquete
   --
   --* TRAE_DATOS
   --  Devuelve un registro con la informacion de la oferta indicada.
   --  valida primero si ya esta en memoria
   --
   --* BUSCA_OFERTA
   --  Busca una oferta aplicable segun los parametros dados.
   --  Primero se buscan las ofertas que aplican al Cliente especifico,
   --  seguidas por las que aplican al Tipo de cliente, y finalmente las
   --  de tipo General. Dentro de cada tipo de promocion, se revisan en orden
   --  descendente segun el codigo. Regresa TRUE si se encontro alguna oferta y
   --  FALSE en caso contrario. Los datos de la oferta quedan en pOferta.
   --
   --* ACTIVA
   --  La oferta esta activa si la fecha esta dentro del rango de la
   --  promocion o si esta no tiene limite de tiempo.
   --
   --* PORCENTAJE
   --  Regresa el porcentaje de descuento de la promocion.
   --
   --* PROTEGIDO
   --  Indica si la oferta es modificable.
   --
   --* TIPO_PROMOCION
   --  Regresa el tipo de oferta. Los valores pueden ser:
   --    Por (C)liente, (T)ipo de cliente, (G)eneral
   --
   --* PRODUCTO_OFERTA
   --  Regresa el tipo de producto que se da en la oferta.
   --  Los valores pueden ser
   --    (1) Porcentaje descuento, (2) Mismo articulo, (3) articulo Alterno
   --
   PROCEDURE inicializa(pCia arfaprom.no_cia%TYPE);
   --
   FUNCTION existe(pCia     arfaprom.no_cia%TYPE,
                   pCodigo  arfaprom.codigo%TYPE,
                   pArti    arfaprom.no_arti%TYPE) RETURN BOOLEAN;
   --
   FUNCTION trae_datos(pCia      arfaprom.no_cia%TYPE,
                       pCodigo   arfaprom.codigo%TYPE,
                       pArti     arfaprom.no_arti%TYPE,
                       pCantidad arfaprom.b_f_qty%TYPE) RETURN datos_r;
   --
   FUNCTION busca_oferta(
     pcia          arfaprom.no_cia%TYPE,
     ptipo_cliente arfaprom.tipo_cliente%TYPE,
     pgrupo	       arfaprom.grupo%TYPE,
     pcliente      arfaprom.no_cliente%TYPE,
     particulo     arfaprom.no_arti%TYPE,
     pcantidad     arfaprom.max_qty%TYPE,
     pfecha	       arfaprom.beg_date%TYPE,
     pOferta       IN OUT datos_r) RETURN BOOLEAN;
   --
   FUNCTION activa (pCia    arfaprom.no_cia%TYPE,
                    pCodigo arfaprom.codigo%TYPE,
                    pArti   arfaprom.no_arti%TYPE,
                    pFecha  arfaprom.beg_date%TYPE) RETURN BOOLEAN;
   --
   FUNCTION porcentaje (pCia    arfaprom.no_cia%TYPE,
                        pCodigo arfaprom.codigo%TYPE,
                        pArti   arfaprom.no_arti%TYPE) RETURN NUMBER;
   --
   FUNCTION protegido (pCia    arfaprom.no_cia%TYPE,
                       pCodigo arfaprom.codigo%TYPE,
                       pArti   arfaprom.no_arti%TYPE) RETURN VARCHAR2;
   --
   FUNCTION tipo_promocion (pCia    arfaprom.no_cia%TYPE,
                            pCodigo arfaprom.codigo%TYPE,
                            pArti   arfaprom.no_arti%TYPE) RETURN VARCHAR2;
   --
   FUNCTION producto_oferta (pCia    arfaprom.no_cia%TYPE,
                             pCodigo arfaprom.codigo%TYPE,
                             pArti   arfaprom.no_arti%TYPE) RETURN NUMBER;
   --
   FUNCTION  ultimo_error   RETURN VARCHAR2;
   FUNCTION  ultimo_mensaje RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20037);
   kNum_error      NUMBER := -20037;
   --
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   PRAGMA RESTRICT_REFERENCES(inicializa,  WNDS);
   PRAGMA RESTRICT_REFERENCES(existe,      WNDS);
END;
/


CREATE OR REPLACE PACKAGE BODY            Oferta IS
  /*******[ PARTE: PRIVADA ]
  * Declaracion de Procedimientos o funciones PRIVADOS
  *
  */
  --
  CURSOR c_datos_oferta(pNo_cia arfaprom.no_cia%TYPE,
                        pCodigo arfaprom.codigo%TYPE,
                        pArti   arfaprom.no_arti%TYPE) IS
    SELECT no_cia, codigo, tipo_prom, tipo_cliente, grupo, no_cliente, no_arti,
           fix_plat producto_oferta, min_qty min_unidades, max_qty max_unidades,
           centsoff porcentaje, b_f_qty cant_oferta, promo_prot protegido,
           alt_pcode no_arti_alterno, beg_date fecha_inicio, end_date fecha_fin,
           psi_item, promo,ind_unidad_facturada
      FROM arfaprom
     WHERE no_cia  = pNo_cia
       AND codigo  = pCodigo
       AND no_Arti = pArti;
  --
  gno_cia         arfaprom.no_cia%TYPE;
  gTstamp         NUMBER;
  --
  RegOferta       c_datos_oferta%ROWTYPE;
  vMensaje_error  VARCHAR2(160);
  vMensaje        VARCHAR2(160);
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
    vMensaje := msj;
  END;
  --
  -- --
  -- Valida si el paquete ya fue inicializado
  FUNCTION inicializado(pCia arfaprom.no_cia%TYPE) RETURN BOOLEAN
  IS
  BEGIN
    RETURN (nvl(gno_cia,'*NULO*') = pCia);
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
  PROCEDURE inicializa(pCia arfaprom.no_cia%TYPE) IS
    CURSOR c_cia IS
      SELECT no_cia
        FROM arfamc
       WHERE no_cia = pCia;
  BEGIN
    OPEN  c_cia;
    FETCH c_cia INTO gNo_cia;
    IF c_Cia%NOTFOUND THEN
      CLOSE c_cia;
      Genera_Error('La compa?ia no ha sido registrada');
    ELSE
      CLOSE c_cia;
    END IF;
  END;
  --
  --
  FUNCTION existe(
    pCia    arfaprom.no_cia%TYPE,
    pCodigo arfaprom.codigo%TYPE,
    pArti   arfaprom.no_arti%TYPE
  ) RETURN BOOLEAN IS
    --
    vFound   BOOLEAN;
    vtstamp  NUMBER;
  BEGIN
    vFound  := FALSE;
    vtstamp := to_char(sysdate, 'SSSSS');

    IF (gTstamp IS NULL OR abs(vtstamp - gTstamp) > 2) OR
       (RegOferta.no_cia IS NULL OR RegOferta.codigo IS NULL    OR RegOferta.no_arti IS NULL) OR
       (RegOferta.no_cia != pCia OR RegOferta.codigo != pCodigo OR RegOferta.no_arti != pArti) THEN

      RegOferta.no_cia  := NULL;
      RegOferta.codigo  := NULL;
      RegOferta.no_arti := NULL;

      OPEN  c_datos_oferta(pCia, pCodigo, pArti);
      FETCH c_datos_oferta INTO RegOferta;
      vFound := c_datos_oferta%FOUND;
      CLOSE c_datos_oferta;

      gTstamp := to_char(sysdate, 'SSSSS');

    ELSE
      vFound  := (RegOferta.no_cia = pCia AND RegOferta.codigo = pCodigo AND RegOferta.no_arti = pArti);
    END IF;

    RETURN (vFound);
  END;
  --
  FUNCTION trae_datos(
    pCia      arfaprom.no_cia%TYPE,
    pCodigo   arfaprom.codigo%TYPE,
    pArti     arfaprom.no_arti%TYPE,
    pCantidad arfaprom.b_f_qty%TYPE
  ) RETURN datos_r IS
     vreg_ofer datos_r;
  BEGIN
    IF existe(pCia, pCodigo, pArti) THEN
      vreg_ofer.codigo          := RegOferta.codigo;
      vreg_ofer.tipo_prom       := RegOferta.tipo_prom;
      vreg_ofer.tipo_cliente    := RegOferta.tipo_cliente;
      vreg_ofer.grupo           := RegOferta.grupo;
      vreg_ofer.no_cliente      := RegOferta.no_cliente;
      vreg_ofer.no_arti         := RegOferta.no_arti;
      vreg_ofer.producto_oferta := RegOferta.producto_oferta;
      vreg_ofer.min_unidades    := RegOferta.min_unidades;
      vreg_ofer.max_unidades    := RegOferta.max_unidades;
      vreg_ofer.porcentaje      := RegOferta.porcentaje;
      vreg_ofer.protegido       := RegOferta.protegido;
      vreg_ofer.no_arti_alterno := RegOferta.no_arti_alterno;
      vreg_ofer.fecha_inicio    := RegOferta.fecha_inicio;
      vreg_ofer.fecha_fin       := RegOferta.fecha_fin;
      vreg_ofer.psi_item        := RegOferta.psi_item;
      vreg_ofer.promo           := RegOferta.promo;

      --Verifa si la oferta es la cantidad de oferta neta o
      --la cantidad de oferta por la cantiad facturada
      IF RegOferta.ind_unidad_facturada = 'N' THEN
         vreg_ofer.cant_oferta     := RegOferta.cant_oferta;
      ELSE
      	 vreg_ofer.cant_oferta     := RegOferta.cant_oferta * pCantidad ;
      END IF;
    ELSE
      genera_error('La oferta '||pCodigo||' no esta definida para el articulo '||pArti);
    END IF;

    RETURN (vreg_ofer);
  END trae_datos;
  --
  FUNCTION busca_oferta (
    pcia                 arfaprom.no_cia%TYPE,
    ptipo_cliente        arfaprom.tipo_cliente%TYPE,
    pgrupo	             arfaprom.grupo%TYPE,
    pcliente             arfaprom.no_cliente%TYPE,
    particulo            arfaprom.no_arti%TYPE,
    pcantidad            arfaprom.max_qty%TYPE,
    pfecha	             arfaprom.beg_date%TYPE,
    pOferta       IN OUT datos_r
  ) RETURN BOOLEAN IS

  -- Busca una oferta aplicable segun los parametros dados.
  -- Primero se buscan las ofertas que aplican al Cliente especifico,
  -- seguidas por las que aplican al Tipo de cliente, y finalmente las
  -- de tipo General. Dentro de cada tipo de promocion, se revisan en orden
  -- descendente segun el codigo.

    -- oferta por cliente especifico
    CURSOR c_promociones1(pArticulo arfaprom.no_arti%TYPE,
                          pGrupo    arfaprom.grupo%TYPE,
                          pCliente  arfaprom.no_cliente%TYPE,
                          pCantidad arfaprom.max_qty%TYPE,
                          pFecha    arfaprom.beg_date%TYPE) IS
      SELECT codigo
        FROM arfaprom
       WHERE no_cia     = pCia
         AND no_arti    = pArticulo
         AND tipo_prom  = 'C'
         AND grupo      = pGrupo
         AND no_cliente = pCliente
         AND (pCantidad BETWEEN min_qty AND max_qty)
         AND ((beg_date IS NULL) OR (pFecha >= beg_date))
         AND ((end_date IS NULL) OR (pFecha <= end_date))
    ORDER BY codigo DESC;

    -- oferta por tipo de cliente
    CURSOR c_promociones2(pArticulo     arfaprom.no_arti%TYPE,
                          pTipo_Cliente arfaprom.no_cliente%TYPE,
                          pCantidad     arfaprom.max_qty%TYPE,
                          pFecha        arfaprom.beg_date%TYPE) IS
      SELECT codigo
        FROM arfaprom
       WHERE no_cia       = pCia
         AND no_arti      = pArticulo
         AND tipo_prom    = 'T'
         AND tipo_cliente = pTipo_Cliente
         AND (pCantidad BETWEEN min_qty AND max_qty)
         AND ((beg_date IS NULL) OR (pFecha >= beg_date))
         AND ((end_date IS NULL) OR (pFecha <= end_date))
    ORDER BY codigo DESC;

    -- promocion general
    CURSOR c_promociones3(pArticulo arfaprom.no_arti%TYPE,
                          pCantidad arfaprom.max_qty%TYPE,
                          pFecha    arfaprom.beg_date%TYPE) IS
      SELECT codigo
        FROM arfaprom
       WHERE no_cia     = pCia
         AND no_arti    = pArticulo
         AND tipo_prom  = 'G'
         AND (pCantidad BETWEEN min_qty AND max_qty)
         AND ((beg_date IS NULL) OR (pFecha >= beg_date))
         AND ((end_date IS NULL) OR (pFecha <= end_date))
    ORDER BY codigo DESC;
    --
    vExiste BOOLEAN;
    rPromo  c_promociones1%ROWTYPE;
  BEGIN
    -- ---
    -- Se determina si existe una promocion especifica
    -- para el cliente
    OPEN  c_promociones1(pArticulo, pGrupo, pCliente, pCantidad, pFecha);
    FETCH c_promociones1 INTO rPromo;
    vExiste := c_promociones1%FOUND;
    CLOSE c_promociones1;
    -- ---
    -- Si no encontro alguna se verifica si hay para el
    -- tipo de negocio
    IF NOT vExiste THEN
      OPEN  c_promociones2(pArticulo, pTipo_Cliente, pCantidad, pFecha);
      FETCH c_promociones2 INTO rPromo;
      vExiste := c_promociones2%FOUND;
      CLOSE c_promociones2;
    END IF;
    --
    -- Si no encontro revisa la promocion generica.
    IF NOT vExiste THEN
      OPEN  c_promociones3(pArticulo, pCantidad, pFecha);
      FETCH c_promociones3 INTO rPromo;
      vExiste := c_promociones3%FOUND;
      CLOSE c_promociones3;
    END IF;

    IF vExiste THEN
	pOferta := trae_datos(pCia, rPromo.codigo, pArticulo, pCantidad);
    END IF;

    RETURN(vExiste);
  END busca_oferta;
  --
  FUNCTION activa (
    pCia    arfaprom.no_cia%TYPE,
    pCodigo arfaprom.codigo%TYPE,
    pArti   arfaprom.no_arti%TYPE,
    pFecha  arfaprom.beg_date%TYPE
  ) RETURN BOOLEAN IS
  BEGIN
  	-- La promocion esta activa si la fecha esta dentro del rango de la
  	-- promocion o si esta no tiene limite de tiempo.
    IF NOT existe(pCia, pCodigo, pArti) THEN
      genera_error('No existe la oferta : '||pCodigo||' para el articulo '||pArti);
    ELSE
      RETURN( ((RegOferta.fecha_inicio IS NULL) OR (pFecha >= RegOferta.fecha_inicio)) AND
              ((RegOferta.fecha_fin    IS NULL) OR (pFecha <= RegOferta.fecha_fin)) );
    END IF;
  END activa;
  --
  FUNCTION porcentaje (
    pCia    arfaprom.no_cia%TYPE,
    pCodigo arfaprom.codigo%TYPE,
    pArti   arfaprom.no_arti%TYPE
  ) RETURN NUMBER IS
  BEGIN
    IF NOT existe(pCia, pCodigo, pArti) THEN
      genera_error('No existe la oferta : '||pCodigo||' para el articulo '||pArti);
    ELSE
      RETURN(RegOferta.porcentaje);
    END IF;
  END porcentaje;
  --
  FUNCTION protegido (
    pCia    arfaprom.no_cia%TYPE,
    pCodigo arfaprom.codigo%TYPE,
    pArti   arfaprom.no_arti%TYPE
  ) RETURN VARCHAR2 IS
  BEGIN
    IF NOT existe(pCia, pCodigo, pArti) THEN
      genera_error('No existe la oferta : '||pCodigo||' para el articulo '||pArti);
    ELSE
      RETURN(RegOferta.protegido);
    END IF;
  END protegido;
  --
  FUNCTION tipo_promocion (
    pCia    arfaprom.no_cia%TYPE,
    pCodigo arfaprom.codigo%TYPE,
    pArti   arfaprom.no_arti%TYPE
  ) RETURN VARCHAR2 IS
  BEGIN
  	-- Por (C)liente, (T)ipo de cliente, (G)eneral
    IF NOT existe(pCia, pCodigo, pArti) THEN
      genera_error('No existe la oferta : '||pCodigo||' para el articulo '||pArti);
    ELSE
      RETURN(RegOferta.tipo_prom);
    END IF;
  END tipo_promocion;
  --
  FUNCTION producto_oferta (
    pCia    arfaprom.no_cia%TYPE,
    pCodigo arfaprom.codigo%TYPE,
    pArti   arfaprom.no_arti%TYPE
  ) RETURN NUMBER IS
  BEGIN
    -- Tipo de producto que se da en la oferta:
    -- (1) Porcentaje descuento, (2) Mismo articulo, (3) articulo Alterno
    IF NOT existe(pCia, pCodigo, pArti) THEN
      genera_error('No existe la oferta : '||pCodigo||' para el articulo '||pArti);
    ELSE
      RETURN(RegOferta.producto_oferta);
    END IF;
  END producto_oferta;
  --
END;
/
