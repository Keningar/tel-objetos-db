CREATE OR REPLACE PACKAGE            Proveedor IS

   -- ---
   -- Este paquete contiene la logica para manejar informacion del proveedor y otros.
   --
   -- ---
   -- TIPO Registro para devuelver informacion general el proveedor
   -- una variable de este tipo es devuelta por la funcion trae_datos

   TYPE datos_r IS RECORD(
     no_cia               arcpmp.no_cia%type,
     no_prove             arcpmp.no_prove%type,
     clase                arcpmp.clase%type,
     corporacion          arcpmp.corporacion%type,
     nombre               arcpmp.nombre%type,
     nombre_largo         arcpmp.nombre_largo%type,
     direccion            arcpmp.direccion%type,
     direccion1           arcpmp.direccion%type,
     telefono             arcpmp.telefono%type,
     cedula               arcpmp.cedula%type,
     plazo_c              arcpmp.plazo_c%type,
     plazo_p              arcpmp.plazo_p%type,
     des_c                arcpmp.des_c%type,
     des_p                arcpmp.des_p%type,
     f_u_co               arcpmp.f_u_co%type,
     grupo                arcpmp.grupo%type,
     bloqueado            arcpmp.bloqueado%type,
     motivo               arcpmp.motivo%type,
     ind_nacional         arcpmp.ind_nacional%type,
     codigo_tercero       arcpmp.codigo_tercero%type,
     condicion_tributaria arcpmp.condicion_tributaria%type,
     moneda_limite        arcpmp.moneda_limite%type,
     cre_max        	    arcpmp.cre_max%type,
     ind_acepta_retencion arcpmp.ind_acepta_retencion%type,
     maneja_comprobante_electronico arcpmp.maneja_comprobante_electronico%type default null
   );

   -- ---
   --* INICIALIZA:
   --  Inicializa el paquete.
   --
   --* EXISTE
   --  Busca si el proveedor esta definido.
   --
   --* TRAE_DATOS
   --  Devuelve un registro con la informacion del proveedor indicado.
   --
   --* CREA_CUENTA
   --  Se encarga de la creacion de una cuenta por pagar en una moneda determinada
   --  para un cliente.
   --
   --* SALDO
   --  Obtiene el saldo de un proveedor en una moneda dada.
   --
   --* SALDO_CONSOLIDADO
   --  Calcula el saldo de un proveedor consolidado en
   --  una moneda dada
   --
   --* DISPONIBLE_CONSOLIDADO
   --  Calcula el disponible de un proveedor consolidado en
   --  una moneda dada.
   --
   --
   PROCEDURE inicializa(pCia varchar2);
   --
   FUNCTION existe(pCia       varchar2,
                   pProve     varchar2) RETURN BOOLEAN;
   --
   FUNCTION trae_datos(pCia      varchar2,
                       pProve    varchar2) RETURN datos_r;
   --
   PROCEDURE crea_cuenta(pCia    varchar2,  pProve varchar2,
                         pMoneda varchar2);
   --
   PROCEDURE recupera_saldo_doc (pCia        IN varchar2,
                                 pProve      IN varchar2,
                                 pNo_docu    IN varchar2,
                                 pTipo_refe  IN varchar2,
                                 pNo_refe    IN varchar2,
                                 pSaldo_doc  IN number,
                                 pSaldo_ref  IN OUT number,
                                 pMsg        IN OUT varchar2);

   --
   FUNCTION saldo(pCia  varchar2,  pProve  varchar2,   pMoneda   varchar2,
                  pAno  number  default null,
                  pMes  number  default null) RETURN number;
   --
   FUNCTION Saldo_Consolidado (pCia         VARCHAR2,
                               pProve       VARCHAR2,
                               pTipo_Cambio NUMBER,
                               pMoneda      VARCHAR2 DEFAULT NULL,
                               pAno         NUMBER   DEFAULT NULL,
                               pMes         NUMBER   DEFAULT NULL) RETURN NUMBER;
   --
   FUNCTION Disponible_Consolidado (pCia         VARCHAR2,
                                    pProve       VARCHAR2,
                                    pTipo_Cambio NUMBER,
                                    pMoneda      VARCHAR2 DEFAULT NULL) RETURN NUMBER;
   --
   FUNCTION  ultimo_error RETURN varchar2;
   FUNCTION  ultimo_mensaje RETURN varchar2;
   --
   error           exception;
   PRAGMA          exception_init(error, -20013);
   kNum_error      number := -20013;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
   PRAGMA RESTRICT_REFERENCES(inicializa, WNDS);
   PRAGMA RESTRICT_REFERENCES(existe, WNDS);

END; -- Proveedor
/


CREATE OR REPLACE PACKAGE BODY            Proveedor IS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   gno_cia              arcgmc.no_cia%type;
   gTStamp              Number;
   --
   CURSOR c_datos_prove(pNo_cia varchar2, pProve varchar2) IS
      SELECT no_cia,    no_prove,      clase,        corporacion,
             nombre,    nombre_largo,  direccion,    direccion1,
             telefono,  cedula,        plazo_c,      plazo_p,
             des_c,     des_p,         f_u_co,       grupo,
             bloqueado, motivo,        ind_nacional, codigo_tercero,
             condicion_tributaria,     moneda_limite,cre_max, ind_acepta_retencion,
             maneja_comprobante_electronico
        FROM arcpmp
       WHERE no_cia    = pNo_cia
         AND no_prove  = pProve;
   --
   RegProv          c_datos_prove%rowtype;
   vMensaje_error   varchar2(160);
   vMensaje         varchar2(160);
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := msj_error;
      vMensaje       := msj_error;
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
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN
   IS
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
   PROCEDURE inicializa(pCia varchar2) IS
   BEGIN
      gno_cia       := pCia;
   END inicializa;
   --
   --
   FUNCTION existe (
     pCia    varchar2,
     pProve  varchar2
   ) RETURN boolean IS
     --
     vFound    boolean;
  	 vtstamp   number;
   BEGIN
      if not inicializado(pCia) then
         inicializa(pCia);
      end if;
      vFound  := FALSE;
      vtstamp := TO_CHAR(sysdate, 'SSSSS');
      IF (gTstamp is null or ABS(vtstamp - gTstamp) > 1)  or
      	 (RegProv.no_cia is null or RegProv.no_prove is null) or
         (RegProv.no_cia != pCia or RegProv.no_prove != pProve) THEN
         RegProv.no_cia    := Null;
         RegProv.no_prove  := Null;
         --
         OPEN  c_datos_prove(pCia, pProve);
         FETCH c_datos_prove INTO RegProv;
         vfound := c_datos_prove%FOUND;
         CLOSE c_datos_prove;
         gTstamp := TO_CHAR(sysdate, 'SSSSS');
      else
         vFound := TRUE;
      end if;
      return ( vFound );
   END existe;
   --
   --
   FUNCTION trae_datos(
      pCia     varchar2,
      pProve   varchar2
   ) RETURN datos_r
   IS
      vreg_prov     datos_r;
   BEGIN
      if existe(pCia, pProve) then

      	 vreg_prov.no_cia         		  := RegProv.no_cia;
      	 vreg_prov.no_prove       		  := RegProv.no_prove;
      	 vreg_prov.clase          		  := RegProv.clase;
      	 vreg_prov.corporacion    		  := RegProv.corporacion;
      	 vreg_prov.nombre         		  := RegProv.nombre;
      	 vreg_prov.nombre_largo   		  := RegProv.nombre_largo;
      	 vreg_prov.direccion      		  := RegProv.direccion;
      	 vreg_prov.cedula         		  := RegProv.cedula;
      	 vreg_prov.plazo_c        		  := RegProv.plazo_c;
      	 vreg_prov.plazo_p        		  := RegProv.plazo_p;
      	 vreg_prov.des_c          		  := RegProv.des_c;
      	 vreg_prov.des_p          		  := RegProv.des_p;
      	 vreg_prov.f_u_co         		  := RegProv.f_u_co;
      	 vreg_prov.grupo          		  := RegProv.grupo;
      	 vreg_prov.bloqueado      		  := RegProv.bloqueado;
      	 vreg_prov.motivo         		  := RegProv.motivo;
      	 vreg_prov.ind_nacional   		  := RegProv.ind_nacional;
      	 vreg_prov.codigo_tercero 		  := RegProv.codigo_tercero;
         vreg_prov.condicion_tributaria := RegProv.condicion_tributaria;
         vreg_prov.moneda_limite  			:= RegProv.moneda_limite;
         vreg_prov.cre_max              := RegProv.cre_max;
         vreg_prov.ind_acepta_retencion := RegProv.ind_acepta_retencion;
         vreg_prov.maneja_comprobante_electronico := RegProv.Maneja_Comprobante_Electronico;
      else
         genera_error('El proveedor '||pProve||' no existe');
      end if;
      RETURN (vreg_prov);
   END trae_datos;
   --
   --
   PROCEDURE crea_cuenta (
     pCia     varchar2,
     pProve   varchar2,
     pMoneda  varchar2
   ) IS
     --
     -- Le crea una cuenta por pagar al proveedor en la moneda especificada.
     --
     CURSOR c_existe IS
       SELECT 'x'
         FROM arcpms
        WHERE no_cia    = pCia
          AND no_prove  = pProve
          AND moneda    = pMoneda;
     --
     vtmp        varchar2(1);
     vencontro   boolean;
     --
   BEGIN

   	 OPEN  c_existe;
   	 FETCH c_existe INTO vtmp;
   	 vencontro := c_existe%found;
   	 CLOSE c_existe;

   	 IF not vencontro THEN
   	   INSERT INTO arcpms (NO_CIA,     NO_PROVE,    MONEDA,     SALDO_ACTUAL)
   	        VALUES (pCia,  pProve,  pMoneda,   0);
   	 END IF;
   END;
   --
   --
   PROCEDURE recupera_saldo_doc (
     pCia        IN varchar2,
     pProve      IN varchar2,
     pNo_docu    IN varchar2,    -- documento actual (para no considerarlo en la consulta)
     pTipo_refe  IN varchar2,    -- tipo de doc a consultar
     pNo_refe    IN varchar2,    -- numero de doc cuyo saldo se va a consultar
     pSaldo_doc  IN number,      -- saldo actual del doc (arcpmd.saldo)
     pSaldo_ref  IN OUT number,  -- saldo pendiente (referenciable)
     pMsg        IN OUT varchar2
   ) IS

     --
     -- Devuelve en psaldo_ref el saldo real del documento de un proveedor y en pmsg el mensaje respectivo
     -- desglozando los montos por concepto de referencias de cheques, referencias de otros documentos, etc.
     --

     --
     -- obtiene monto referenciado por cheques.
     CURSOR c_tot_ref(pTipo_refe arckrd.tipo_refe%TYPE,
                      pNo_refe   arckrd.no_refe%TYPE) IS
       SELECT nvl(sum(monto_refe),0)
         FROM arckrd
        WHERE no_cia       = pCia
          AND tipo_refe    = pTipo_refe
          AND no_refe      = pNo_refe
          AND no_secuencia <> nvl(pNo_docu,0)
          AND EXISTS (SELECT 'x'
                        FROM arckce
                       WHERE arckce.no_cia           = pCia
                         AND arckce.tipo_docu        = arckrd.tipo_docu
                         AND arckce.no_secuencia     = arckrd.no_secuencia
                         AND nvl(arckce.anulado,'N') = 'N'
                         AND arckce.ind_act          = 'P');
    --
    -- obtiene monto referenciado por otros documentos en CxP
    CURSOR c_mov_pend_cxp (pProve     arcpmd.no_prove%TYPE,
                           pTipo_refe arcprd.tipo_refe%TYPE,
                           pNo_refe   arcprd.no_refe%TYPE,
                           pNo_docu   arcpmd.no_docu%TYPE) IS
      SELECT nvl(sum(rd.monto_refe),0)
        FROM arcprd rd, arcpmd md
       WHERE md.no_cia        = pCia
         AND md.no_prove      = pProve
         AND rd.tipo_refe     = pTipo_refe
         AND md.no_docu      <> nvl(pNo_docu,'**')
         AND rd.no_refe       = pNo_refe
         AND md.tipo_doc      IN ( SELECT tipo_doc
                                     FROM arcptd
                                    WHERE no_Cia    = pCia
                                      AND tipo_mov  = 'D'
                                      AND documento IN ('O', 'A'))
         AND md.no_cia        = rd.no_cia    (+)
         AND md.tipo_doc      = rd.tipo_doc  (+)
         AND md.no_docu       = rd.no_docu   (+)
         AND md.ind_act       = 'P';
    --
    -- verifica monto pendiente en detalle de pago.
    CURSOR c_mov_pend_det_pag (pProve   arcpmd.no_prove%TYPE,
                               pNo_refe arcprd.no_refe%TYPE) IS
     SELECT nvl(monto,0)
       FROM arcpdp
      WHERE no_cia   = pCia
        AND no_prove = pProve
        AND no_docu  = pNo_refe;
    --
    -- Forma de pago de las retenciones y el monto retenido.
    -- Si las retenciones se pagan al momento de la cancelacion total
    -- de la factura (ind_forma_ret = 'P'), es necesario rebajar
    -- del saldo el monto de la retencion. Si se pagan en la aplicacion,
    -- el monto ya fue rebajado del saldo cuando se aplico la
    -- nota de debito por retencion.
    -- * Solo Guatemala *
    CURSOR c_ret_especial(pDocu arcpmd.no_docu%TYPE) IS
      SELECT pr.tipo_doc_nd_ret, md.tot_ret_especial
        FROM arcppr pr, arcpmd md
       WHERE pr.no_cia     = pCia
         AND ind_forma_ret = 'P' -- solamente si las retenc. se paga cuando se cancela
         AND md.no_cia     = pr.no_cia
         AND md.no_docu    = pDocu;

    -- Indica si ya existe una ND retencion para la factura
    CURSOR c_ND_existe(ptipo_nd   arcprd.tipo_doc%TYPE,
                       ptipo_refe arcprd.tipo_refe%TYPE,
                       pno_refe   arcprd.no_refe%TYPE) IS
      SELECT 'x'
        FROM arcprd a, arcpmd b
       WHERE a.no_cia    = pCia
         AND a.tipo_doc  = ptipo_nd
	       AND a.tipo_refe = ptipo_refe
	       AND a.no_refe   = pno_refe
	       AND b.anulado   = 'N'
	       AND b.no_cia    = a.no_cia
	       AND b.no_docu   = a.no_docu;


    -- Movimientos pendientes de inventario (devoluciones a proveedor)
    CURSOR c_mov_pend_inv (pProve    arcpmd.no_prove%TYPE,
                           pNo_refe  arcpmd.no_docu%TYPE,
                           pNo_docu  arcpmd.no_docu%TYPE) IS
      SELECT nvl(sum(decode(dc.moneda_refe_cxp, 'P', dc.mov_tot, moneda.redondeo(dc.mov_tot/dc.tipo_cambio, 'D'))
                            - nvl(dc.descuento,0) + nvl(dc.imp_ventas,0) ), 0) monto
        FROM arinme dc, arinme ec, arcpmd fa
       WHERE dc.no_cia    = pCia
         AND dc.no_prove  = pProve
         AND dc.no_docu   <> pNo_docu
         AND dc.estado    = 'P'
         AND dc.n_docu_d  IS NOT NULL
         AND fa.no_docu   = pNo_refe    -- dc.n_docu_d = ec.no_docu = fa.no_docu = pNo_refe
         AND ec.no_cia    = dc.no_cia
         AND ec.no_docu   = dc.n_docu_d
         AND fa.no_cia    = ec.no_cia
         AND fa.no_docu   = ec.no_docu
         AND EXISTS (SELECT *           -- solo docs de debito
                       FROM arcptd td
                      WHERE td.no_cia        = dc.no_cia
                        AND td.tipo_doc      = dc.tipo_refe
                        AND td.tipo_mov      = 'D'
                        AND td.ind_anulacion = 'N');
    --
    vmov_pend_ck  arckrd.monto%TYPE;
    vmov_pend_cp  arckrd.monto%TYPE;
    vmov_pend_dp  arckrd.monto%TYPE;
    vmov_pend_inv arinme.mov_tot%TYPE;
    --
    rRet_especial c_ret_especial%ROWTYPE;
    --
    vExiste       BOOLEAN;
    vExiste_ND    BOOLEAN;
    vTemp         VARCHAR2(1);
  BEGIN
    --
    -- Movimiento Pendiente de Cheques
    OPEN  c_tot_ref(pTipo_refe, pNo_Refe);
    FETCH c_tot_ref INTO vmov_pend_ck;
    CLOSE c_tot_ref;

    --
    -- Movimiento Pendiente de CxP (notas debito)
    OPEN  c_mov_pend_cxp(pProve, pTipo_refe, pNo_refe, pNo_docu);
    FETCH c_mov_pend_cxp INTO vmov_pend_cp;
    CLOSE c_mov_pend_cxp;

    --
    -- Movimiento Pendiente de Inventario (devoluciones a proveedor)
    OPEN  c_mov_pend_inv(pProve, pNo_refe, pNo_docu);
    FETCH c_mov_pend_inv INTO vmov_pend_inv;
    CLOSE c_mov_pend_inv;

    --
    -- Movimientos pendientes de detalle de pago
    OPEN  c_mov_pend_det_pag(pProve, pNo_refe);
    FETCH c_mov_pend_det_pag INTO vmov_pend_dp;
    CLOSE c_mov_pend_det_pag;

    --
    -- Retenciones incluidas. (Guatemala)
    --
    OPEN  c_ret_especial(pNo_Refe);
    FETCH c_ret_especial INTO rRet_especial;
    vExiste := c_ret_especial%FOUND;
    CLOSE c_ret_especial;

  	--
  	-- Caso especial: cuando la retencion se paga al calcelarse totalmente el doc.
  	-- Si se paga la factura pero luego se anula el cheque, la ND de la retencion
   	-- no es anulada, y el saldo del doc. ya tiene rebajado el monto
   	-- de la retencion, por lo que no debe volver a rebajarse.
    --
    IF vExiste THEN
      OPEN  c_ND_existe(rRet_especial.tipo_doc_nd_ret, pTipo_Refe, pNo_Refe);
      FETCH c_ND_existe INTO vTemp;
      vExiste_ND := c_ND_existe%FOUND;
      CLOSE c_ND_existe;

      IF vExiste_ND THEN
      	rRet_especial.tot_ret_especial := 0;
      END IF;

    END IF;

    --
    -- Obtiene saldo referenciable del documento
    pSaldo_ref  := nvl(psaldo_doc,    0) - nvl(vmov_pend_ck, 0) -
                   nvl(vmov_pend_cp,  0) - nvl(vmov_pend_dp, 0) -
                   nvl(vmov_pend_inv, 0) -
                   nvl(rRet_especial.tot_ret_especial, 0);

    pMsg := 'SALDO '||to_char(psaldo_doc,'99,999,999.00')||'  '||
            '- CK PEND.'||to_char(vmov_pend_ck,'99,999,999.00')||'  '||
            '- DOC. DEB. PEND. '||to_char(vmov_pend_cp,'99,999,999.00')||'  '||
            '- DEVOL. PROVE.'||to_char(vmov_pend_inv,'99,999,999.00')||'  '||
            '- DETALLE PAGO '||to_char(vmov_pend_dp,'999,999,999.00');

    --
    -- Mensaje Monto retenido. Solo Guatemala.
    IF vExiste AND (nvl(rRet_especial.tot_ret_especial,0) > 0) THEN
      pMsg := pMsg||'- RETENC. PEND. '||to_char(rRet_especial.tot_ret_especial,'99,999,999.99');
    END IF;

  END recupera_saldo_doc;
  --
  --
  FUNCTION saldo(
    pCia      varchar2,
    pProve    varchar2,
    pMoneda   varchar2,
    pAno      number  default null,    -- si no pasa ano y mes, obtiene el saldo actual.
    pMes      number  default null
  ) RETURN number IS
    --
    -- Obtiene el saldo de un proveedor en una moneda dada. En el caso de desear el
    -- saldo actual, debe dejar nulos los parametros ano y mes.
    --
    CURSOR c_saldo_ant IS
      SELECT saldo
        FROM arcpsa
       WHERE no_cia   = pCia
         AND no_prove = pProve
         AND ano      = pAno
         AND mes      = pMes
         AND moneda   = pMoneda;
    --
    CURSOR c_saldo IS
      SELECT saldo_actual
        FROM arcpms
       WHERE no_cia   = pCia
         AND no_prove = pProve
         AND moneda   = pMoneda;
    --
    vSaldo   arcpms.saldo_actual%type;
  BEGIN
  	IF pAno is null or pMes is null THEN
  		-- obtiene saldo actual
  		OPEN  c_saldo;
  		FETCH c_saldo INTO vSaldo;
  		CLOSE c_saldo;
  	ELSE
  		-- obtiene saldo historico
  		OPEN  c_saldo_ant;
  		FETCH c_saldo_ant INTO vSaldo;
  		CLOSE c_saldo_ant;
    END IF;
		vSaldo := nvl(vSaldo,0);
    return(vsaldo);
  END;
  --
  FUNCTION Disponible_Consolidado (
    pCia         VARCHAR2,
    pProve       VARCHAR2,
    pTipo_Cambio NUMBER,
    pMoneda      VARCHAR2 DEFAULT NULL)

    /* Calcula el disponible del proveedor pProve consolidado en
       la moneda indicada en pMoneda. Si se deja pMoneda en NULL
       se toma la moneda del limite de credito.
       El tipo de cambio no debe ser 0.
    */

  RETURN NUMBER IS
    CURSOR c_saldo(pProve  arcpms.no_prove%TYPE,
                   pMoneda arcpms.moneda%TYPE) IS
      SELECT saldo_actual
        FROM arcpms
       WHERE no_cia   = pCia
         AND no_prove = pProve
         AND moneda   = pMoneda;

    CURSOR c_cre_max(pProve arcpms.no_prove%TYPE) IS
      SELECT nvl(cre_max, 0) cre_max, moneda_limite
        FROM arcpmp
       WHERE no_cia   = pCia
         AND no_prove = pProve;

    vEncontrado  BOOLEAN;
    rCredito     c_cre_max%ROWTYPE;
    vCre_Max     arcpmp.cre_max%TYPE;
    vDisponible  arcpms.saldo_actual%TYPE;
    vSaldo_Col   arcpms.saldo_actual%TYPE;
    vSaldo_Dol   arcpms.saldo_actual%TYPE;
    vMoneda_disp arcpmp.moneda_limite%TYPE;

  BEGIN
    IF nvl(pTipo_Cambio, 0) = 0 THEN
      genera_error('El tipo de cambio no puede ser 0');
	END IF;

    OPEN  c_cre_max(pProve);
    FETCH c_cre_max INTO rCredito;
    vEncontrado := c_cre_max%FOUND;
    CLOSE c_cre_max;

    IF NOT vEncontrado THEN
      genera_error('El proveedor '||pProve||' no existe');
	END IF;

	--
	-- Supone que solamente existen dos monedas: Nominal y Dolar (P, D)
	--

    -- saldo en nominal
    OPEN  c_saldo(pProve, 'P');
    FETCH c_saldo INTO vSaldo_Col;
    CLOSE c_saldo;
    vSaldo_Col := nvl(vSaldo_Col, 0);

    -- saldo en dolares
    OPEN  c_saldo(pProve, 'D');
    FETCH c_saldo INTO vSaldo_Dol;
    CLOSE c_saldo;
    vSaldo_Dol := nvl(vSaldo_Dol, 0);

    -- Por default se toma la moneda del limite de credito
    IF pMoneda IS NULL THEN
      vMoneda_disp := rCredito.moneda_limite;
    ELSE
  	  vMoneda_disp := pMoneda;
    END IF;

    -- Convertir el limite de credito a la moneda solicitada
    vCre_Max := rCredito.cre_max;
    IF rCredito.moneda_limite <> vMoneda_disp THEN
      IF vMoneda_disp = 'P' THEN
        vCre_Max := vCre_Max * pTipo_Cambio;
      ELSE
        vCre_Max := vCre_Max / pTipo_Cambio;
      END IF;
    END IF;

    IF vMoneda_disp = 'P' THEN
      vDisponible := vCre_Max - vSaldo_Col - (vSaldo_Dol * pTipo_Cambio);
    ELSE
      vDisponible := vCre_Max - (vSaldo_Col / pTipo_Cambio)- vSaldo_Dol;
    END IF;

    RETURN(vDisponible);

  END; -- Disponible_Consolidado
  --
  --
  FUNCTION Saldo_Consolidado (
    pCia         VARCHAR2,
    pProve       VARCHAR2,
    pTipo_Cambio NUMBER,
    pMoneda      VARCHAR2 DEFAULT NULL, -- Si no pasa la moneda usa arccmc.moneda_limite
    pAno         NUMBER   DEFAULT NULL, -- si no pasa ano y mes, obtiene el saldo actual.
    pMes         NUMBER   DEFAULT NULL)

    /* Calcula el saldo del proveedor pProve consolidado en
       la moneda indicada en pMoneda. Si se deja pMoneda en NULL
       se toma la moneda del limite de credito.
    */

  RETURN NUMBER IS

    --
    -- Obtiene el saldo del proveedor en una moneda dada. En el caso de desear el
    -- saldo actual, debe dejar nulos los parametros ano y mes.
    --
    CURSOR c_saldo_ant(pProve   arcpsa.no_prove%TYPE,
                       pMoneda  arcpsa.moneda%TYPE,
					   pAno     arcpsa.ano%TYPE,
					   pMes     arcpsa.ano%TYPE) IS
      SELECT saldo
        FROM arcpsa
       WHERE no_cia     = pCia
         AND no_prove   = pProve
         AND ano        = pAno
         AND mes        = pMes
         AND moneda     = pMoneda;

    CURSOR c_saldo(pProve   arcpms.no_prove%TYPE,
                   pMoneda  arcpms.moneda%TYPE) IS
      SELECT saldo_actual
        FROM arcpms
       WHERE no_cia     = pCia
         AND no_prove   = pProve
         AND moneda     = pMoneda;

    CURSOR c_mon_limite(pProve arcpms.no_prove%TYPE) IS
      SELECT moneda_limite
        FROM arcpmp
       WHERE no_cia     = pCia
         AND no_prove   = pProve;

    vEncontrado   BOOLEAN;
    vSaldo        arcpms.saldo_actual%TYPE;
    vSaldo_Col    arcpms.saldo_actual%TYPE;
    vSaldo_Dol    arcpms.saldo_actual%TYPE;
    vMoneda_saldo arcpmp.moneda_limite%TYPE;

  BEGIN
    IF nvl(pTipo_Cambio, 0) = 0 THEN
      genera_error('El tipo de cambio no puede ser 0');
	END IF;

    vMoneda_saldo := pMoneda;
    IF vMoneda_saldo IS NULL THEN -- Leer la moneda de arccmc.moneda_limite
      OPEN  c_mon_limite(pProve);
      FETCH c_mon_limite INTO vMoneda_saldo;
      vEncontrado := c_mon_limite%FOUND;
      CLOSE c_mon_limite;

      IF NOT vEncontrado THEN
        genera_error('El proveedor '||pProve||' no existe');
	  END IF;

	END IF;

	--
	-- Supone que solamente existen dos monedas: Nominal y Dolar (P, D)
	--

  	IF pAno IS NULL OR pMes IS NULL THEN
      -- saldo actual
      -- saldo en nominal
      OPEN  c_saldo(pProve, 'P');
      FETCH c_saldo INTO vSaldo_Col;
      CLOSE c_saldo;

      -- saldo en dolares
      OPEN  c_saldo(pProve, 'D');
      FETCH c_saldo INTO vSaldo_Dol;
      CLOSE c_saldo;

    ELSE
      -- saldo historico
      -- saldo en nominal
      OPEN  c_saldo_ant(pProve, 'P', pAno, pMes);
      FETCH c_saldo_ant INTO vSaldo_Col;
      CLOSE c_saldo_ant;

      -- saldo en dolares
      OPEN  c_saldo_ant(pProve, 'D', pAno, pMes);
      FETCH c_saldo_ant INTO vSaldo_Dol;
      CLOSE c_saldo_ant;

	END IF;

    vSaldo_Col := nvl(vSaldo_Col, 0);
    vSaldo_Dol := nvl(vSaldo_Dol, 0);

    IF vMoneda_saldo = 'P' THEN
      vSaldo := vSaldo_Col + (vSaldo_Dol * pTipo_Cambio);
    ELSE
      vSaldo := (vSaldo_Col / pTipo_Cambio) + vSaldo_Dol;
    END IF;

    RETURN(vSaldo);

  END; -- Saldo_Consolidado


END; -- BODY proveedor
/
