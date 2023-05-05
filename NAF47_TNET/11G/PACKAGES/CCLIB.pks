CREATE OR REPLACE PACKAGE            CCLIB IS
    -- --
    --
     TYPE cuentas_contables_r IS RECORD(
        no_cia                arccctd.no_cia%type,
        grupo                 arccctd.grupo%type,
        tipo_doc              arccctd.tipo_doc%type,
        cta_cliente           arccctd.cta_cliente%type,
        cta_contrapartida     arccctd.cta_contrapartida%type,
        cta_dpp               arccctd.cta_dpp%type,
        cta_cliente_dol       arccctd.cta_cliente_dol%type,
        cta_contrapartida_dol arccctd.cta_contrapartida_dol%type,
        cta_dpp_dol           arccctd.cta_dpp_dol%type,
        cta_anticipo          arccctd.cta_anticipo%type
     );
    -- ---
    --
    FUNCTION existe_cuentas_conta(
       pCia        IN  arccgr.no_cia%type,
       pGrupo      IN  arccgr.grupo%type,
       pTipoDoc    IN  arcctd.tipo%type,
       pMoneda     IN  arccmd.moneda%type
    ) RETURN BOOLEAN;
    -- --
    --
    FUNCTION trae_cuentas_conta(
       pCia        IN     arccgr.no_cia%type,
       pGrupo      IN     arccgr.grupo%type,
       pTipoDoc    IN     arcctd.tipo%type,
       pMoneda     IN     arccmd.moneda%type,
       pCta        IN OUT cuentas_contables_r
    ) RETURN BOOLEAN;
    -- --
    --
    FUNCTION trae_cuenta_cliente(
       pCia         IN     arccgr.no_cia%type,
       pGrupo       IN     arccgr.grupo%type,
       pTipoDoc     IN     arcctd.tipo%type,
       pMoneda      IN     arccmd.moneda%type,
       pCta_cliente IN OUT arccctd.cta_cliente%type
    ) RETURN BOOLEAN;
    -- --
    --
    FUNCTION EsReversion (
      pNo_cia   varchar2,
      pTipo_doc varchar2
    ) RETURN boolean;
    -- --
    --
    FUNCTION EsReversionSN (
      pNo_cia   varchar2,
      pTipo_doc varchar2
    ) RETURN varchar2;
    --
    FUNCTION EsAnulacion (
       pNo_cia   varchar2,
       pTipo_doc varchar2
    ) RETURN boolean;
    --
    FUNCTION EsAnulacionSN (
      pNo_cia   varchar2,
      pTipo_doc varchar2
    ) RETURN varchar2;
    --
    FUNCTION comportamiento_imp (
      pCia      varchar2,
      pTipo_doc varchar2
    ) RETURN varchar2 ;
    -- --
    --
    -- Regresa TRUE si el cliente pertenece al centro pCentro, o si
    -- pertenece a un centro diferente pero ambos estan en el mismo periodo de proceso.
    -- En caso contrario regresa FALSE.
    FUNCTION Valida_Periodo_Cliente (
      pNo_cia     arccct.no_cia%TYPE,
      pCentro     arincd.centro%TYPE,
      pGrupo      arccmc.grupo%TYPE,
      pNo_cliente arccmc.no_cliente%TYPE
    ) RETURN BOOLEAN;
    -- --
    -- Devuelve laa descripcion del ultimo error ocurrido
    FUNCTION  ultimo_error RETURN VARCHAR2;
    --
    error           EXCEPTION;
    PRAGMA          EXCEPTION_INIT(error, -20018);
    kNum_error      NUMBER := -20018;
    --
    -- ---
    -- Define restricciones de procedimientos y funciones
    --    WNDS = Writes No Database State
    --    RNDS = Reads  No Database State
    --    WNPS = Writes No Package State
    --    RNPS = Reads  No Package State
    --
   PRAGMA RESTRICT_REFERENCES(EsReversion,   WNDS, WNPS);
   PRAGMA RESTRICT_REFERENCES(EsReversionSN, WNDS, WNPS);

   PRAGMA RESTRICT_REFERENCES(EsAnulacion,   WNDS, WNPS);
   PRAGMA RESTRICT_REFERENCES(EsAnulacionSN, WNDS, WNPS);

   PRAGMA RESTRICT_REFERENCES(comportamiento_imp,  WNDS);

END;   -- CCLIB
/


CREATE OR REPLACE PACKAGE BODY            CCLIB AS
    /*******[ PARTE: PRIVADA ]
    * Declaracion de Procedimientos o funciones PRIVADOS
    *
    */
    -- ---
    -- TIPOS
    --
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
      vMensaje_error := substr(msj_error,1,160);
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
    END;
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
       pCia        IN     arccgr.no_cia%type,
       pGrupo      IN     arccgr.grupo%type,
       pTipoDoc    IN     arcctd.tipo%type,
       pMoneda     IN     arccmd.moneda%type,
       pCta        IN OUT cuentas_contables_r
    ) RETURN boolean IS
      --
      CURSOR c_ctas IS
        SELECT no_cia, grupo, tipo_doc,
               cta_cliente, cta_dpp, cta_contrapartida,
               cta_cliente_dol, cta_dpp_dol, cta_contrapartida_dol, cta_anticipo
          FROM arccctd
         WHERE no_cia   = pCia
           AND grupo    = pGrupo
           AND tipo_doc = pTipoDoc;
      --
      CURSOR c_ctas_default IS
        SELECT g.no_cia, g.grupo, t.tipo tipo_doc,
               g.cta_cliente, g.cta_dpp, t.cta_contrapartida,
               g.cta_cliente_dol, g.cta_dpp_dol, t.cta_contrapartida
          FROM arccgr g, arcctd t
         WHERE g.no_cia   = pCia
           AND g.grupo    = pGrupo
           AND g.no_cia   = t.no_cia
           AND t.tipo     = pTipoDoc;
       --
       vExiste  BOOLEAN;
       vtstamp   NUMBER;
    BEGIN
      limpia_error;

      IF nvl(pMoneda,'X') not in ('P','D') THEN
        genera_error('Parametro moneda NO valido en CCLIB.TRAE_CUENTAS_CONTA');
      END IF;

  	  vtstamp := TO_CHAR(sysdate, 'SSSSS');
      vExiste := TRUE;
      if (gTstamp is null OR ABS(vtstamp - gTstamp) > 2) OR
         vrCta.grupo    is null   OR vrcta.tipo_doc is null OR
         vrcta.no_cia   != pCia   OR
         vrcta.grupo    != pGrupo OR vrcta.tipo_doc != pTipoDoc then
         --
         vrcta.no_cia                := NULL;
         vrcta.grupo                 := NULL;
         vrcta.tipo_doc              := NULL;
         vrcta.cta_cliente           := NULL;
         vrcta.cta_dpp               := NULL;
         vrcta.cta_contrapartida     := NULL;
         vrcta.cta_cliente_dol       := NULL;
         vrcta.cta_dpp_dol           := NULL;
         vrcta.cta_contrapartida_dol := NULL;
         vrcta.cta_anticipo          := NULL;
         --
         OPEN  c_ctas;
         FETCH c_ctas INTO vrcta.no_cia, vrcta.grupo, vrcta.tipo_doc,
                           vrcta.cta_cliente, vrcta.cta_dpp, vrcta.cta_contrapartida,
                           vrcta.cta_cliente_dol, vrcta.cta_dpp_dol, vrcta.cta_contrapartida_dol, vrcta.cta_anticipo;
         vExiste := c_ctas%FOUND;
         CLOSE c_ctas;
         if not vExiste then
            OPEN c_ctas_default;
            FETCH c_ctas_default INTO vrcta.no_cia, vrcta.grupo, vrcta.tipo_doc,
                                      vrcta.cta_cliente, vrcta.cta_dpp, vrcta.cta_contrapartida,
                                      vrcta.cta_cliente_dol, vrcta.cta_dpp_dol, vrcta.cta_contrapartida_dol;
            vExiste := c_ctas_default%FOUND;
            CLOSE c_ctas_default;
         end if;
         gTstamp := TO_CHAR(sysdate, 'SSSSS');
      end if;

      IF pMoneda = 'P' THEN
      	IF vrcta.cta_cliente is null THEN
      		vexiste := FALSE;
        END IF;
      ELSE -- pMoneda = 'D'
        IF vrcta.cta_cliente_dol is null THEN
      		vexiste := FALSE;
        END IF;
      END IF;

      pcta  := vrcta;
      RETURN (vExiste);
    END;
    --
    --
    FUNCTION existe_cuentas_conta(
       pCia        IN  arccgr.no_cia%type,
       pGrupo      IN  arccgr.grupo%type,
       pTipoDoc    IN  arcctd.tipo%type,
       pMoneda     IN  arccmd.moneda%type
    ) RETURN boolean IS
      --
      vExiste   boolean;
    BEGIN
      vExiste := trae_cuentas_conta(pCia, pGrupo, pTipoDoc, pMoneda, vrcta);
      return (vExiste);
    END;
    --
    --
    FUNCTION trae_cuenta_cliente(
       pCia         IN     arccgr.no_cia%type,
       pGrupo       IN     arccgr.grupo%type,
       pTipoDoc     IN     arcctd.tipo%type,
       pMoneda      IN     arccmd.moneda%type,
       pCta_cliente IN OUT arccctd.cta_cliente%type
    ) RETURN boolean IS
      --
      vExiste   boolean;
    BEGIN
      vExiste      := trae_cuentas_conta(pCia, pGrupo, pTipoDoc, pMoneda, vrcta);

      IF pMoneda = 'P' THEN
        pCta_cliente := vrCta.cta_cliente;
      ELSE -- pMoneda = 'D'
        pCta_cliente := vrCta.cta_cliente_dol;
      END IF;

      return (vExiste);
    END;
    -- ---
    --
    FUNCTION EsReversion (
      pNo_cia   varchar2,
      pTipo_doc varchar2
    ) RETURN boolean IS
      --
      -- Devuelve TRUE si el tipo de documento esta marcado como de reversion
      -- y un FALSE si se comporta normalmente.
      CURSOR c_tipo_doc IS
        SELECT tipo_mov, ind_reversion
          FROM arcctd
         WHERE no_cia  = pNo_cia
           AND tipo    = pTipo_doc;
      --
      vtipo_mov       arcctd.tipo_mov%type;
      vind_reversion  arcctd.ind_reversion%type;
      vreversion      boolean := false;
    BEGIN

      OPEN  c_tipo_doc;
      FETCH c_tipo_doc INTO vtipo_mov, vind_reversion;
      CLOSE c_tipo_doc;

      IF vind_reversion = 'S' THEN
      	vreversion := true;
      ELSE
      	vreversion := false;
      END IF;
      return(vreversion);
   END;
   --
   FUNCTION EsReversionSN (
     pNo_cia   varchar2,
     pTipo_doc varchar2
   ) RETURN varchar2 IS
   --
   -- devuelve S si el documento es de reversion y N sino lo es.
   BEGIN
   	 IF EsReversion(pNo_cia, pTipo_doc) THEN
   	 	 return('S');
   	 ELSE
   	 	 return('N');
   	 END IF;
   END ;
    --
    FUNCTION EsAnulacion (
      pNo_cia   varchar2,
      pTipo_doc varchar2
    ) RETURN boolean IS
      --
      -- Devuelve TRUE si el tipo de documento es de anulacion
      -- y FALSE en caso contrario
      CURSOR c_tipo_doc IS
        SELECT nvl(ind_anulacion,'N')
          FROM arcctd
         WHERE no_cia   = pNo_cia
           AND tipo     = pTipo_doc;
      --
      vind_anulacion  arcctd.ind_anulacion%type;
      vanulacion      boolean := false;
    BEGIN

      OPEN  c_tipo_doc;
      FETCH c_tipo_doc INTO vind_anulacion;
      CLOSE c_tipo_doc;

      IF vind_anulacion = 'S' THEN
        vanulacion := true;
      ELSE
        vanulacion := false;
      END IF;

      return(vanulacion);
    END;
    --
    FUNCTION EsAnulacionSN (
      pNo_cia   varchar2,
      pTipo_doc varchar2
    ) RETURN varchar2 IS
    --
    -- devuelve S si el documento es de anulacion y N sino lo es.
    BEGIN
    	 IF EsAnulacion(pNo_cia, pTipo_doc) THEN
    	 	 return('S');
    	 ELSE
    	 	 return('N');
    	 END IF;
    END ;
    --
    --
    FUNCTION Valida_Periodo_Cliente (
      pNo_cia     arccct.no_cia%TYPE,
      pCentro     arincd.centro%TYPE,
      pGrupo      arccmc.grupo%TYPE,
      pNo_cliente arccmc.no_cliente%TYPE
    ) RETURN BOOLEAN IS
    --
    -- Regresa TRUE si el cliente pertenece al centro pCentro, o si
    -- pertenece a un centro diferente pero ambos estan en el mismo periodo de proceso.
    -- En caso contrario regresa FALSE.
    --
      CURSOR c_periodo_centro(pCia    arincd.no_cia%TYPE,
                              pCentro arincd.centro%TYPE) IS
        SELECT ano_proce_cxc, mes_proce_cxc
          FROM arincd
         WHERE no_cia = pcia
           AND centro = pcentro;
      --
      -- Periodo del centro al cual pertenece el cliente
      CURSOR c_periodo_cliente(pCia        arccmc.no_cia%TYPE,
                               pGrupo      arccmc.grupo%TYPE,
                               pNo_cliente arccmc.no_cliente%TYPE) IS
        SELECT a.centro, b.mes_proce_cxc, b.ano_proce_cxc
          FROM arccmc a, arincd b
         WHERE a.no_cia     = pCia
           AND a.grupo      = pGrupo
           AND a.no_cliente = pNo_cliente
           AND b.no_cia     = a.no_cia
           AND b.centro     = a.centro;
      --
      rCentro  c_periodo_centro%ROWTYPE;
      rCliente c_periodo_cliente%ROWTYPE;
    BEGIN
      -- Periodo del centro
      OPEN  c_periodo_centro(pNo_cia, pCentro);
      FETCH c_periodo_centro INTO rCentro;
      CLOSE c_periodo_centro;

      -- Obtener el periodo del centro al cual pertenece el cliente
      OPEN  c_periodo_cliente(pNo_cia, pGrupo, pNo_cliente);
      FETCH c_periodo_cliente INTO rCliente;
      CLOSE c_periodo_cliente;

      -- Si el cliente es de otro centro, debe estar en el mismo periodo
      IF (rCliente.centro <> pCentro) AND
      	 ( (rCliente.ano_proce_cxc <> rCentro.ano_proce_cxc) OR
      	   (rCliente.mes_proce_cxc <> rCentro.mes_proce_cxc) ) THEN
        RETURN(FALSE);
      ELSE
        RETURN(TRUE);
      END IF;

    END;
    --
    --
    FUNCTION comportamiento_imp (
      pCia      varchar2,
      pTipo_doc varchar2
    ) RETURN varchar2 IS
      --
      -- Devuelve el comportamiento de los impuestos (Suma o Resta) segun el tipo
      -- de documento. Los valores retornados son S o R respectivamente
      --
      CURSOR c_datos_tipo IS
        SELECT *
          FROM arcctd
         WHERE no_cia = pCia
           AND tipo   = pTipo_doc;
      --
      vencontro       boolean;
      vRegTipo        c_datos_tipo%rowtype;
      vcomportamiento varchar2(1);
    BEGIN
    	OPEN  c_datos_tipo;
    	FETCH c_datos_tipo INTO vRegTipo;
    	vencontro := c_datos_tipo%found;
    	CLOSE c_datos_tipo;

    	IF not vencontro THEN
    		genera_error('El Tipo de Documento '||pTipo_doc||' no esta definido');
      END IF;

    	--
    	-- los documentos de debito hacen que los impuestos sumen al monto y los
    	-- creditos hacen que los impuestos resten.
    	IF vRegTipo.tipo_mov = 'D' THEN
    		vcomportamiento := 'S';
    	ELSIF vRegTipo.tipo_mov = 'C' THEN
    		vcomportamiento := 'R';
    	END IF;

    	--
    	-- indiferentemente del tipo de movimiento, el indicador de anulacion o
    	-- reversion en el tipo de documento, invierte el comportamtieno de los
    	-- impuestos.
    	IF vRegTipo.ind_anulacion = 'S' or vRegTipo.ind_reversion = 'S' THEN
    		IF vcomportamiento = 'S' THEN
    		  vcomportamiento := 'R';
    		ELSE -- vcomportamiento = R
    			vcomportamiento := 'S';
    	  END IF;
    	END IF;

      return(vcomportamiento);
    END;
    --
    --
END; --CCLIB
/
