CREATE OR REPLACE PACKAGE            INLIB IS
    -- --
    -- TIPOS
    --
    TYPE periodo_proceso_r IS RECORD(
      ano_proce      arincd.ano_proce%type,
      mes_proce      arincd.mes_proce%type,
      semana_proce   arincd.semana_proce%type,
      indicador_sem  arincd.indicador_sem%type
    );
    TYPE calendario_r IS RECORD(
      ano       calendario.ano%type,
      mes       calendario.mes%type,
      semana    calendario.semana%type,
      indicador calendario.indicador%type,
      fecha1    calendario.fecha1%type,
      fecha2    calendario.fecha2%type
    );
    TYPE cuentas_contables_r IS RECORD(
        no_cia                   arincc.no_cia%type,
        grupo                    arincc.grupo%type,
        bodega                   arincc.bodega%type,
        cta_inventario           arincc.cta_inventario%type,
        cta_ajuste               arincc.cta_ajuste%type,
        cta_ajuste_sal           arincc.cta_ajuste_sal%type,
        cta_costo_venta          arincc.cta_costo_venta%type,
        cta_costo_oferta         arincc.cta_costo_oferta%type,
        cta_venta                arincc.cta_venta%type,
        cta_venta_cre            arincc.cta_venta_cre%type,
        cta_venta_exp            arincc.cta_venta_exp%type,
        cta_descuento            arincc.cta_descuento%type,
        centro_costo             arincc.centro_costo%type,
        cta_costo_imp_oferta     arincc.cta_costo_imp_oferta%type,
        cta_devol_contado        arincc.cta_devol_contado%type,
        cta_devol_credito        arincc.cta_devol_credito%type,
        cta_devol_exp            arincc.cta_devol_exp%type,
        -- cuentas utilizadas por el POS
        cta_efectivo             arincc.cta_efectivo%type,
        cta_venta_gravada_con    arincc.cta_venta_gravada_con%type,
        cta_venta_gravada_cre    arincc.cta_venta_gravada_cre%type,
        cta_venta_exenta_con     arincc.cta_venta_exenta_con%type,
        cta_venta_exenta_cre     arincc.cta_venta_exenta_cre%type,
        cta_desc_gravada_con     arincc.cta_desc_gravada_con%type,
        cta_desc_gravada_cre     arincc.cta_desc_gravada_cre%type,
        cta_desc_exenta_con      arincc.cta_desc_exenta_con%type,
        cta_desc_exenta_cre      arincc.cta_desc_exenta_cre%type,
        cta_devol_gravada_con    arincc.cta_devol_gravada_con%type,
        cta_devol_gravada_cre    arincc.cta_devol_gravada_cre%type,
        cta_devol_exenta_con     arincc.cta_devol_exenta_con%type,
        cta_devol_exenta_cre     arincc.cta_devol_exenta_cre%type,
        cta_devol_iva            arincc.cta_devol_iva%type,
        cta_promo_iva            arincc.cta_promo_iva%type,
        cta_promo_oferta         arincc.cta_promo_oferta%type,
        -- Cuentas utilizadas por el modulo de Compras e Importaciones
        cta_transitoria_importac arincc.cta_transitoria_importac%type,
        cta_transitoria_compras  arincc.cta_transitoria_compras%type,
        -- Cuentas utilizadas por el modulo de Inventarios para requisiciones
        cta_contrapartida_requi arincc.cta_contrapartida_requi%type,
        cta_desc_compras_requi  arincc.cta_desc_compras_requi%type,
        cta_transitoria_AF      arincc.cta_transito_activo_fijo%type,
        cta_transitoria_costo   arincc.cta_transito_costo%type
    );
    -- ---
    --
    FUNCTION existe_cuentas_conta(
       pCia        IN   arincc.no_cia%type,
       pGrupo      IN   arincc.grupo%type,
       pBodega     IN   arincc.bodega%type
    ) RETURN BOOLEAN;
    -- --
    --
    FUNCTION trae_cuentas_conta(
       pCia        IN     arincc.no_cia%type,
       pGrupo      IN     arincc.grupo%type,
       pBodega     IN     arincc.bodega%type,
       pCta        IN OUT cuentas_contables_r
    ) RETURN BOOLEAN;
    -- --
    --
    FUNCTION trae_cuenta_inventario(
       pCia         IN     arincc.no_cia%type,
       pGrupo       IN     arincc.grupo%type,
       pBodega      IN     arincc.bodega%type,
       pCta_cuenta  IN OUT arincc.cta_inventario%type
    ) RETURN BOOLEAN;
    -- --
    --
    FUNCTION trae_centro_costo(
       pCia         IN     arincc.no_cia%type,
       pGrupo       IN     arincc.grupo%type,
       pBodega      IN     arincc.bodega%type,
       pCtro_costo  IN OUT arincc.centro_costo%type
    ) RETURN BOOLEAN;
    --
    FUNCTION trae_periodo_proceso(
       pCia           IN     arincd.no_cia%type,
       pCentroD       IN     arincd.centro%type,
       pperiodo       IN OUT periodo_proceso_r
    ) RETURN BOOLEAN;
    --
    FUNCTION trae_periodof(
       pCia           IN     arincd.no_cia%type,
       pFecha         IN     arincd.dia_proceso%type,
       pperiodo       IN OUT calendario_r
    ) RETURN BOOLEAN;
    --
    FUNCTION trae_periodo_antf(
       pCia           IN     arincd.no_cia%type,
       pFecha         IN     arincd.dia_proceso%type,
       pperiodo       IN OUT calendario_r
    ) RETURN BOOLEAN;
    --
    FUNCTION doc_inve (
       pCia           IN     arfact.no_cia%type,
       pTipo          IN     arfact.tipo%type
    )  RETURN varchar2;
    --
    FUNCTION doc_cxc (
       pCia           IN     arfact.no_cia%type,
       pTipo          IN     arfact.tipo%type
    )  RETURN varchar2;
    -- --
    -- Devuelve la descripcion del ultimo error ocurrido
    FUNCTION  ultimo_error RETURN VARCHAR2;
    --
    error           EXCEPTION;
    PRAGMA          EXCEPTION_INIT(error, -20034);
    kNum_error      NUMBER := -20034;
    --
    -- ---
    -- Define restricciones de procedimientos y funciones
    --    WNDS = Writes No Database State
    --    RNDS = Reads  No Database State
    --    WNPS = Writes No Package State
    --    RNPS = Reads  No Package State
    --
END;   -- INLIB
/


CREATE OR REPLACE PACKAGE BODY            INLIB AS
    /*******[ PARTE: PRIVADA ]
    * Declaracion de Procedimientos o funciones PRIVADOS
    *
    */
    -- ---
    -- CURSORES
    --
    CURSOR c_tipos_doc (pCia  varchar2, pTipo varchar2) IS
      SELECT tipo_doc_cxc, tipo_doc_inve
        FROM arfact
       WHERE no_cia = pCia
         AND tipo   = pTipo;
    -- ---
    -- TIPOS
    --
    vMensaje_error      VARCHAR2(160);
    vrcta               cuentas_contables_r;
    gTstamp             number;
    --
    PROCEDURE limpia_error IS
    BEGIN
      vMensaje_error := NULL;
    END;
    --
    PROCEDURE genera_error(msj_error IN VARCHAR2)IS
    BEGIN
      vMensaje_error := msj_error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
    END;
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
    --
    FUNCTION trae_cuentas_conta(
       pCia        IN     arincc.no_cia%type,
       pGrupo      IN     arincc.grupo%type,
       pBodega     IN     arincc.bodega%type,
       pCta        IN OUT cuentas_contables_r
    ) RETURN BOOLEAN IS
      --
      CURSOR c_ctas IS
        SELECT no_cia, grupo, bodega,
               cta_inventario,         cta_ajuste,             cta_ajuste_sal,
               cta_costo_venta,        cta_costo_oferta,       cta_venta,
               cta_venta_cre,          cta_venta_exp,          cta_descuento,
               cta_costo_imp_oferta,   cta_devol_contado,      cta_devol_credito,
               cta_devol_exp,          centro_costo,           cta_efectivo,
               cta_venta_gravada_con,  cta_venta_gravada_cre,  cta_venta_exenta_con,
               cta_venta_exenta_cre,   cta_desc_gravada_con,   cta_desc_gravada_cre,
               cta_desc_exenta_con,    cta_desc_exenta_cre,    cta_devol_gravada_con,
               cta_devol_gravada_cre,  cta_devol_exenta_con,   cta_devol_exenta_cre,
               cta_devol_iva,          cta_promo_iva,          cta_promo_oferta,
               cta_transitoria_importac,cta_transitoria_compras,cta_contrapartida_requi,
               cta_desc_compras_requi, cta_transito_activo_fijo, cta_transito_costo
          FROM arincc
         WHERE no_cia   = pCia
           AND grupo    = pGrupo
           AND bodega   = pBodega;
      --
      vExiste  boolean;
      vTstamp  number;
    BEGIN
      limpia_error;
      vExiste := TRUE;
      vtstamp := to_char(sysdate, 'SSSSS');
      IF (gTstamp is null OR abs(vtstamp - gTstamp) > 2) OR
         vrCta.no_cia   is null   OR
         vrCta.grupo    is null   OR vrcta.bodega is null OR
         vrcta.no_cia   != pCia   OR
         vrcta.grupo    != pGrupo OR vrcta.bodega != pBodega then
         --
         vrcta.no_cia                   := null;
         vrcta.grupo                    := null;
         vrcta.bodega                   := null;
         vrcta.cta_inventario           := null;
         vrcta.cta_ajuste               := null;
         vrcta.cta_ajuste_sal           := null;
         vrcta.cta_costo_venta          := null;
         vrcta.cta_costo_oferta         := null;
         vrcta.cta_venta                := null;
         vrcta.cta_venta_cre            := null;
         vrcta.cta_venta_exp            := null;
         vrcta.cta_descuento            := null;
         vrcta.centro_costo             := null;
         vrcta.cta_costo_imp_oferta     := null;
         vrcta.cta_devol_contado        := null;
         vrcta.cta_devol_credito        := null;
         vrcta.cta_devol_exp            := null;
         --
         vrcta.cta_efectivo             := null;
         vrcta.cta_venta_gravada_con    := null;
         vrcta.cta_venta_gravada_cre    := null;
         vrcta.cta_venta_exenta_con     := null;
         vrcta.cta_venta_exenta_cre     := null;
         vrcta.cta_desc_gravada_con     := null;
         vrcta.cta_desc_gravada_cre     := null;
         vrcta.cta_desc_exenta_con      := null;
         vrcta.cta_desc_exenta_cre      := null;
         vrcta.cta_devol_gravada_con    := null;
         vrcta.cta_devol_gravada_cre    := null;
         vrcta.cta_devol_exenta_con     := null;
         vrcta.cta_devol_exenta_cre     := null;
         vrcta.cta_devol_iva            := null;
         vrcta.cta_promo_iva            := null;
         vrcta.cta_promo_oferta         := null;
         --
         vrcta.cta_transitoria_importac := null;
         vrcta.cta_transitoria_compras  := null;
         --
         vrcta.cta_contrapartida_requi  := null;
         vrcta.cta_desc_compras_requi   := null;
         --
         gTstamp := to_char(sysdate, 'SSSSS');
         --
         OPEN c_ctas;
         FETCH c_ctas INTO vrcta.no_cia,                 vrcta.grupo,                 vrcta.bodega,
                           vrcta.cta_inventario,         vrcta.cta_ajuste,            vrcta.cta_ajuste_sal,
                           vrcta.cta_costo_venta,        vrcta.cta_costo_oferta,      vrcta.cta_venta,
                           vrcta.cta_venta_cre,          vrcta.cta_venta_exp,         vrcta.cta_descuento,
                           vrcta.cta_costo_imp_oferta,   vrcta.cta_devol_contado,     vrcta.cta_devol_credito,
                           vrcta.cta_devol_exp,          vrcta.centro_costo,          vrcta.cta_efectivo,
                           vrcta.cta_venta_gravada_con,  vrcta.cta_venta_gravada_cre, vrcta.cta_venta_exenta_con,
                           vrcta.cta_venta_exenta_cre,   vrcta.cta_desc_gravada_con,  vrcta.cta_desc_gravada_cre,
                           vrcta.cta_desc_exenta_con,    vrcta.cta_desc_exenta_cre,   vrcta.cta_devol_gravada_con,
                           vrcta.cta_devol_gravada_cre,  vrcta.cta_devol_exenta_con,  vrcta.cta_devol_exenta_cre,
                           vrcta.cta_devol_iva,          vrcta.cta_promo_iva,         vrcta.cta_promo_oferta,
                           vrcta.cta_transitoria_importac, vrcta.cta_transitoria_compras,vrcta.cta_contrapartida_requi,
                           vrcta.cta_desc_compras_requi, vrcta.cta_transitoria_AF, vrcta.cta_transitoria_costo ;
         vExiste := c_ctas%FOUND;
         CLOSE c_ctas;
      end if;
      pcta  := vrcta;
      RETURN (vExiste);
    END;
    --
    --
    FUNCTION existe_cuentas_conta(
       pCia        IN  arincc.no_cia%type,
       pGrupo      IN  arincc.grupo%type,
       pBodega     IN  arincc.bodega%type
    ) RETURN BOOLEAN IS
      vExiste   boolean;
    BEGIN
      vExiste := trae_cuentas_conta(pCia, pGrupo, pBodega, vrcta);
      return (vExiste);
    END;
    --
    --
    FUNCTION trae_cuenta_inventario(
       pCia         IN     arincc.no_cia%type,
       pGrupo       IN     arincc.grupo%type,
       pBodega      IN     arincc.bodega%type,
       pCta_cuenta  IN OUT arincc.cta_inventario%type
    ) RETURN BOOLEAN IS
      vExiste   boolean;
    BEGIN
      vExiste      := trae_cuentas_conta(pCia, pGrupo, pBodega, vrcta);
      pCta_cuenta  := vrcta.cta_inventario;
      return (vExiste);
    END;
    --
    --
    FUNCTION trae_centro_costo(
       pCia         IN     arincc.no_cia%type,
       pGrupo       IN     arincc.grupo%type,
       pBodega      IN     arincc.bodega%type,
       pCtro_costo  IN OUT arincc.centro_costo%type
    ) RETURN BOOLEAN IS
      vExiste   boolean;
    BEGIN
      vExiste     := trae_cuentas_conta(pCia, pGrupo, pBodega, vrcta);
      pCtro_costo := vrcta.centro_costo;
      return (vExiste);
    END;
    --
    --
    FUNCTION trae_periodo_proceso(
        pCia           IN     arincd.no_cia%type,
        pCentroD       IN     arincd.centro%type,
        pperiodo       IN OUT periodo_proceso_r
    ) RETURN BOOLEAN
    IS
       vExiste   BOOLEAN;
       vregPer   periodo_proceso_r;
       CURSOR c_centro IS
         SELECT ano_proce, mes_proce, semana_proce, indicador_sem
         FROM   arincd
         WHERE no_cia = pCia
           AND centro = pCentroD;
    BEGIN
       OPEN c_centro;
       FETCH c_centro INTO vRegPer;
       vExiste := c_centro%FOUND;
       CLOSE c_centro;
       pperiodo := vRegPer;
       RETURN (vexiste);
    END;
    --
    --
    FUNCTION trae_periodof(
      pCia           IN     arincd.no_cia%type,
      pFecha         IN     arincd.dia_proceso%type,
      pperiodo       IN OUT calendario_r
    ) RETURN BOOLEAN IS
      --
      -- Devuelve el periodo al que pertenece la fecha dada como parametro
      --
      CURSOR c_calendario IS
        SELECT ano, mes, semana, indicador, fecha1, fecha2
          FROM calendario
         WHERE no_cia = pCia
           AND (pFecha between fecha1 and fecha2);
      --
      vExiste   boolean;
      vregPer   calendario_r;
    BEGIN
      OPEN c_calendario;
      FETCH c_calendario INTO vRegPer;
      vExiste := c_calendario%FOUND;
      CLOSE c_calendario;
      pperiodo := vRegPer;
      RETURN (vexiste);
    END;
    --
    --
    FUNCTION trae_periodo_antf(
      pCia           IN     arincd.no_cia%type,
      pFecha         IN     arincd.dia_proceso%type,
      pperiodo       IN OUT calendario_r
    ) RETURN BOOLEAN IS
      --
      -- Devuelve el periodo anterior al que pertenece la fecha dada como parametro
      --
      CURSOR c_calendario IS
        SELECT ano, mes, semana, indicador, fecha1, fecha2
          FROM calendario
         WHERE no_cia = pCia
           AND fecha2 < pFecha
         ORDER BY fecha2 desc ;
      --
      vExiste   boolean;
      vregPer   calendario_r;
    BEGIN
      OPEN c_calendario;
      FETCH c_calendario INTO vRegPer;
      vExiste := c_calendario%FOUND;
      CLOSE c_calendario;
      pperiodo := vRegPer;
      RETURN (vexiste);
    END;
    --
    FUNCTION doc_inve (
       pCia            IN     arfact.no_cia%type,
       pTipo           IN     arfact.tipo%type
    )  RETURN varchar2 IS
       --
       -- Devuelve el tipo de documento a generar a inventario, con base en el tipo de
       -- documento de Facturacion.
       vtipo_cxc   arcctd.tipo%type;
       vtipo_inve  arinvtm.tipo_m%type;
       vencontro   boolean;
    BEGIN
    	OPEN  c_tipos_doc (pCia, pTipo);
    	FETCH c_tipos_doc INTO vTipo_cxc, vTipo_inve;
    	vencontro := c_tipos_doc%found;
    	CLOSE c_tipos_doc;
    	IF not vencontro THEN
    		genera_error('El tipo de documento '||ptipo||' no ha sido definido');
    	END IF;
    	return(vTipo_inve);
    END ;
    --
    FUNCTION doc_cxc (
       pCia            IN     arfact.no_cia%type,
       pTipo           IN     arfact.tipo%type
    )  RETURN varchar2 IS
       --
       -- Devuelve el tipo de documento a generar a cxc, con base en el tipo de
       -- documento de Facturacion.
       vtipo_cxc   arcctd.tipo%type;
       vtipo_inve  arinvtm.tipo_m%type;
       vencontro   boolean;
    BEGIN
    	OPEN  c_tipos_doc (pCia, pTipo);
    	FETCH c_tipos_doc INTO vTipo_cxc, vTipo_inve;
    	vencontro := c_tipos_doc%found;
    	CLOSE c_tipos_doc;
    	IF not vencontro THEN
    		genera_error('El tipo de documento '||ptipo||' no ha sido definido');
    	END IF;
    	return(vTipo_cxc);
    END;
END;  --inlib
/
