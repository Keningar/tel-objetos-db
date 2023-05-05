CREATE OR REPLACE PACKAGE            CPLIB IS
    -- --
    --
     TYPE cuentas_contables_r IS RECORD(
        no_cia            arcpmp.no_cia%type,
        no_prove          arcpmp.no_prove%type,
        grupo             arcpgr.grupo%type,
        tipo_doc          arcptd.tipo_doc%type,
        cta_prove         arcpgr.cta_prove%type,
        cta_dpp           arcpgr.cta_dpp%type,
        cta_prove_dol     arcpgr.cta_prove%type,
        cta_dpp_dol       arcpgr.cta_dpp%type,
        cta_contrapartida arcptd.cta_contrapartida%type
     );
    -- ---
     TYPE cuentas_contables_FF IS RECORD(
        no_cia            arcpmp.no_cia%type,
        no_prove          arcpmp.no_prove%type,
        grupo             arcpgr.grupo%type,
        tipo_doc          arcptd.tipo_doc%type,
        cta_prove         arcpgr.cta_prove%type,
        cta_dpp           arcpgr.cta_dpp%type,
        cta_anticipo      arcpgr.cta_anticipo%TYPE
     );


    --
    FUNCTION existe_cuentas_conta(
       pCia        IN  arcpmp.no_cia%type,
       pNo_prove   IN  arcpmp.no_prove%type,
       pTipoDoc    IN  arcptd.tipo_doc%type,
       pMoneda     IN  arcpmd.moneda%type
    ) RETURN BOOLEAN;
    -- --
    --
    --
    FUNCTION trae_cuentas_conta(
       pCia        IN     arcpmp.no_cia%type,
       pNo_prove   IN     arcpmp.no_prove%type,
       pTipoDoc    IN     arcptd.tipo_doc%type,
       pMoneda     IN     arcpmd.moneda%type,
       pCta        IN OUT cuentas_contables_r
    ) RETURN BOOLEAN;
    -- --
    --
    FUNCTION trae_cuentas_conta_FF(
       pCia        IN     arcpmp.no_cia%type,
       pNo_prove   IN     arcpmp.no_prove%type,
       pTipoDoc    IN     arcptd.tipo_doc%type,
       pCta        IN OUT cuentas_contables_r
    ) RETURN BOOLEAN;
    -- --    
    -- --
    FUNCTION existe_cuentas_conta(
       pCia        IN  arcpmp.no_cia%type,
       pNo_prove   IN  arcpmp.no_prove%type,
       pTipoDoc    IN  arcptd.tipo_doc%type
    ) RETURN BOOLEAN;    
    --
    FUNCTION trae_cuenta_proveedor(
       pCia         IN     arcpmp.no_cia%type,
       pNo_prove    IN     arcpmp.no_prove%type,
       pTipoDoc     IN     arcptd.tipo_doc%type,
       pMoneda      IN     arcpmd.moneda%type,
       pcta_prove   IN OUT arcpgr.cta_prove%type
    ) RETURN BOOLEAN;
    -- ---
  /*  FUNCTION trae_cuenta_proveedor(
       pCia         IN     arcpmp.no_cia%type,
       pNo_prove    IN     arcpmp.no_prove%type,
       pTipoDoc     IN     arcptd.tipo_doc%type,
       pcta_prove   IN OUT arcpgr.cta_prove%type
    ) RETURN BOOLEAN; */   
    --
    FUNCTION EsReversion (
       pNo_cia   varchar2,
       pTipo_doc varchar2
    ) RETURN boolean;
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
    ) RETURN varchar2;
    -- --    
    --

    -- --    
    -- Devuelve laa descripcion del ultimo error ocurrido
    FUNCTION  ultimo_error RETURN VARCHAR2;
    --
    error           EXCEPTION;
    PRAGMA          EXCEPTION_INIT(error, -20019);
    kNum_error      NUMBER := -20019;
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

END;   -- CPLIB
/


CREATE OR REPLACE PACKAGE BODY            CPLIB AS
    /*******[ PARTE: PRIVADA ]
    * Declaracion de Procedimientos o funciones PRIVADOS
    *
    */
    -- ---
    -- TIPOS
    --
    --
    vMensaje_error      varchar2(160);
    vrcta               cuentas_contables_r;
    vrcta_FF            cuentas_contables_FF; 
    gTstamp             number;
    --
    PROCEDURE limpia_error IS
    BEGIN
      vMensaje_error := NULL;
    END;
    --
    PROCEDURE genera_error(msj_error IN varchar2)IS
    BEGIN
      vMensaje_error := substr(msj_error,1,160);
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
    END;
    /*******[ PARTE: PUBLICA ]
    * Declaracion de Procedimientos o funciones PUBLICAS
    *
    */
    --
    FUNCTION ultimo_error RETURN varchar2 IS
    BEGIN
      RETURN(vMensaje_error);
    END ultimo_error;
    --
    --
    FUNCTION trae_cuentas_conta(
       pCia        IN     arcpmp.no_cia%type,
       pNo_prove   IN     arcpmp.no_prove%type,
       pTipoDoc    IN     arcptd.tipo_doc%type,
       pMoneda     IN     arcpmd.moneda%type,
       pCta        IN OUT cuentas_contables_r
    ) RETURN boolean IS
     --NOTA: Si el tipo de documento es NULO significa que se buscan directamente las
     --cuentas del proveedor y no del tipo de documento (Ej. Generacion de detalle
     --de pago en CxP)
      --
      CURSOR c_ctas IS
        SELECT mp.no_cia, mp.no_prove, mp.grupo,
               t.tipo_doc, t.cta_prove, t.cta_dpp,
               t.cta_prove_dol, t.cta_dpp_dol
         FROM arcpmp mp, arcpctd t
        WHERE mp.no_cia   = pCia
          AND mp.no_prove = pNo_prove
          AND mp.no_cia   = t.no_cia
          AND mp.grupo    = t.grupo
          AND t.tipo_doc  = pTipoDoc;
      --
      CURSOR c_ctas_default IS
        SELECT mp.no_cia, mp.no_prove, mp.grupo,
               pTipoDoc, g.cta_prove, g.cta_dpp,
               g.cta_prove_dol, g.cta_dpp_dol
          FROM arcpmp mp, arcpgr g
         WHERE mp.no_cia   = pCia
           AND mp.no_prove = pno_prove
           AND mp.no_cia   = g.no_cia
           AND mp.grupo    = g.grupo;
      --
      CURSOR c_cta_contrapartida IS
        SELECT cta_contrapartida
          FROM arcptd
         WHERE no_cia      = pCia
           AND tipo_doc    = pTipoDoc;
      --
      vExiste  boolean;
      vTstamp  number;
    BEGIN
      limpia_error;

      IF nvl(pMoneda,'X') not in ('P','D') THEN
        genera_error('Parametro moneda NO valido en CPLIB.TRAE_CUENTAS_CONTA');
      END IF;

      vExiste := TRUE;

      vtstamp := TO_CHAR(sysdate, 'SSSSS');

      IF (gTstamp is null OR ABS(vtstamp - gTstamp) > 2) or
      	vrCta.no_cia   is null  or vrCta.no_prove is null  or
        vrCta.tipo_doc is null   or vrCta.no_cia   != pCia  or
        vrCta.no_prove != pno_prove or vrCta.tipo_doc != pTipoDoc THEN
        --
        vrcta.no_cia      := NULL;
        vrcta.no_prove    := NULL;
        vrcta.grupo       := NULL;
        vrcta.tipo_doc    := NULL;
        vrcta.cta_prove   := NULL;
        vrcta.cta_dpp     := NULL;

        vrcta.cta_prove_dol   := NULL;
        vrcta.cta_dpp_dol     := NULL;
        gTstamp := TO_CHAR(sysdate, 'SSSSS');
        --
        OPEN  c_ctas;
        FETCH c_ctas INTO vrcta.no_cia, vrcta.no_prove, vrcta.grupo,
                          vrcta.tipo_doc, vrcta.cta_prove, vrcta.cta_dpp, vrcta.cta_prove_dol, vrcta.cta_dpp_dol ;
        vExiste := c_ctas%found;
        CLOSE c_ctas;

        IF not vExiste THEN
          OPEN  c_ctas_default;
          FETCH c_ctas_default INTO vrcta.no_cia, vrcta.no_prove, vrcta.grupo,
                                    vrcta.tipo_doc, vrcta.cta_prove, vrcta.cta_dpp, vrcta.cta_prove_dol, vrcta.cta_dpp_dol;
          vExiste := c_ctas_default%found;
          CLOSE c_ctas_default;
        END IF;

        --
        -- carga la cuenta de contrapartida del documento (en esta version aplica
        -- unicamente para documentos de ajuste)
        OPEN  c_cta_contrapartida;
        FETCH c_cta_contrapartida INTO vrcta.cta_contrapartida;
        CLOSE c_cta_contrapartida;
      END IF;

      --
      IF pMoneda = 'P' THEN
      	IF vrcta.cta_prove is null or vrcta.cta_dpp is null THEN
      		vexiste := FALSE;
        END IF;
      ELSE -- pMoneda = 'D'
        IF vrcta.cta_prove_dol is null or vrcta.cta_dpp_dol is null THEN
      		vexiste := FALSE;
        END IF;
      END IF;
      pcta  := vrcta;
      return (vExiste);
    END;
    --
    --
    --
    FUNCTION trae_cuentas_conta_FF(
       pCia        IN     arcpmp.no_cia%type,
       pNo_prove   IN     arcpmp.no_prove%type,
       pTipoDoc    IN     arcptd.tipo_doc%type,
       pCta        IN OUT cuentas_contables_r
    ) RETURN BOOLEAN IS
       CURSOR c_ctas IS
          SELECT mp.no_cia, mp.no_prove, mp.grupo,
                 t.tipo_doc, t.cta_prove, t.cta_dpp, t.cta_anticipo
          FROM arcpmp mp, arcpctd t
          WHERE mp.no_cia   = pCia
            AND mp.no_prove = pNo_prove
            AND mp.no_cia   = t.no_cia
            AND mp.grupo    = t.grupo
            AND t.tipo_doc  = pTipoDoc;
       --
       CURSOR c_ctas_default IS
          SELECT mp.no_cia, mp.no_prove, mp.grupo,
                 pTipoDoc, g.cta_prove, g.cta_dpp, g.cta_anticipo
          FROM arcpmp mp, arcpgr g
          WHERE mp.no_cia   = pCia
            AND mp.no_prove = pno_prove
            AND mp.no_cia   = g.no_cia
            AND mp.grupo    = g.grupo;
       --
       vExiste  BOOLEAN;
    BEGIN
      limpia_error;
      vExiste := TRUE;
      if vrCta.no_cia   is null   OR
         vrCta.no_prove is null   OR vrcta.tipo_doc is null OR
         vrcta.no_cia   != pCia   OR
         vrcta.no_prove != pNo_prove OR vrcta.tipo_doc != pTipoDoc then
         --
         vrcta_FF.no_cia      := NULL;
         vrcta_FF.no_prove    := NULL;
         vrcta_FF.grupo       := NULL;
         vrcta_FF.tipo_doc    := NULL;
         vrcta_FF.cta_prove   := NULL;
         vrcta_FF.cta_dpp     := NULL;
         vrcta_FF.cta_anticipo:= NULL;
         --
         OPEN c_ctas;
         FETCH c_ctas INTO vrcta_FF.no_cia, vrcta_FF.no_prove, vrcta_FF.grupo,
                           vrcta_FF.tipo_doc, vrcta_FF.cta_prove, vrcta_FF.cta_dpp, vrcta_FF.cta_anticipo;
         vExiste := c_ctas%FOUND;
         CLOSE c_ctas;
         if not vExiste then
            OPEN c_ctas_default;
            FETCH c_ctas_default INTO vrcta_FF.no_cia, vrcta_FF.no_prove, vrcta_FF.grupo,
                                      vrcta_FF.tipo_doc, vrcta_FF.cta_prove, vrcta_FF.cta_dpp, vrcta_FF.cta_anticipo;
            vExiste := c_ctas_default%FOUND;
            CLOSE c_ctas_default;
         end if;
      end if;
      pcta  := vrcta;
      RETURN (vExiste);
    END;
    --    
    
    FUNCTION existe_cuentas_conta(
       pCia        IN  arcpmp.no_cia%type,
       pNo_prove   IN  arcpmp.no_prove%type,
       pTipoDoc    IN  arcptd.tipo_doc%type,
       pMoneda     IN  arcpmd.moneda%type
    ) RETURN boolean IS
      --
      vExiste   boolean;
    BEGIN
      vExiste := trae_cuentas_conta(pCia, pNo_prove, pTipoDoc, pMoneda, vrcta); 

      return (vExiste);
    END;
    --
    --
    FUNCTION trae_cuenta_proveedor(
       pCia         IN     arcpmp.no_cia%type,
       pNo_prove    IN     arcpmp.no_prove%type,
       pTipoDoc     IN     arcptd.tipo_doc%type,
       pMoneda      IN     arcpmd.moneda%type,
       pcta_prove   IN OUT arcpgr.cta_prove%type
    ) RETURN boolean IS
      --
      vExiste   boolean;
    BEGIN
      vExiste    := trae_cuentas_conta(pCia, pNo_prove, pTipoDoc, pMoneda, vrcta);

      IF pMoneda = 'P' THEN
        pcta_prove := vrcta.cta_prove;
      ELSE -- pMoneda = 'D'
        pcta_prove := 'D'; --vrcta.cta_prove_dol;
      END IF;
      return (vExiste);
    END;
    --
    FUNCTION EsReversion (
      pNo_cia   varchar2,
      pTipo_doc varchar2
    ) RETURN boolean IS
      --
      -- Devuelve TRUE si el tipo de documento tiene el indicador de reversion
      -- y un FALSE si se comporta normalmente.
      CURSOR c_tipo_doc IS
        SELECT tipo_mov, ind_reversion
          FROM arcptd
         WHERE no_cia   = pNo_cia
           AND tipo_doc = pTipo_doc;
      --
      vtipo_mov            arcptd.tipo_mov%type;
      vind_reversion       arcptd.ind_reversion%type;
      vreversion           boolean := false;
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
          FROM arcptd
         WHERE no_cia   = pNo_cia
           AND tipo_doc = pTipo_doc;
      --
      vind_anulacion  arcptd.ind_anulacion%type;
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
          FROM arcptd
         WHERE no_cia   = pCia
           AND tipo_doc = pTipo_doc;
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
    	-- los documentos de credito hacen que los impuestos sumen al monto y los
    	-- debitos hacen que los impuestos resten.
    	IF vRegTipo.tipo_mov = 'C' THEN
    		vcomportamiento := 'S';
    	ELSIF vRegTipo.tipo_mov = 'D' THEN
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
    
    FUNCTION existe_cuentas_conta(
       pCia        IN  arcpmp.no_cia%type,
       pNo_prove   IN  arcpmp.no_prove%type,
       pTipoDoc    IN  arcptd.tipo_doc%type
    ) RETURN BOOLEAN IS
      vExiste   boolean;
    BEGIN
      vExiste := trae_cuentas_conta_FF(pCia, pNo_prove, pTipoDoc, vrcta);
      return (vExiste);
    END;
        
    --    
    FUNCTION trae_cuenta_proveedor(
       pCia         IN     arcpmp.no_cia%type,
       pNo_prove    IN     arcpmp.no_prove%type,
       pTipoDoc     IN     arcptd.tipo_doc%type,
       pcta_prove   IN OUT arcpgr.cta_prove%type
    ) RETURN BOOLEAN IS
      vExiste   boolean;
    BEGIN
      vExiste    := trae_cuentas_conta_FF(pCia, pNo_prove, pTipoDoc, vrcta);
      pcta_prove := vrcta.cta_prove;
      return (vExiste);
    END;
    --    
    
END;  --cplib
/
