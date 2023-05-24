CREATE OR REPLACE PACKAGE NAF47_TNET.cliente
IS
  -- ---
  -- Este paquete contiene la logica para manejar informacion del cliente y otros.
  --
  -- ---
  -- TIPO Registro para devuelver informacion general el cliente
  -- una variable de este tipo es devuelta por la funcion trae_datos
  TYPE datos_r IS RECORD(
      no_cia                 arccmc.no_cia%type,
      grupo                  arccmc.grupo%type,
      no_cliente             arccmc.no_cliente%type,
      corporacion            arccmc.corporacion%type,
      codigo_tercero         arccmc.codigo_tercero%type,
      tipo_cliente           arccmc.tipo_cliente%type,
      nombre                 arccmc.nombre%type,
      nombre_largo           arccmc.nombre_largo%type,
      ALIAS                  arccmc.alias%type,
      nombre_comercial       arccmc.nombre_comercial%type,
      direccion              arccmc.direccion%type,
      apartado               arccmc.apartado%type,
      fecha_ingre            arccmc.fecha_ingre%type,
      cobrador               arccmc.cobrador%type,
      moneda_limite          arccmc.moneda_limite%type,
      excento_imp            arccmc.excento_imp%type,
      limite_credi           arccmc.limite_credi%type,
      telefono               arccmc.telefono%type,
      telefono2              arccmc.telefono2%type,
      f_cierre               arccmc.f_cierre%type,
      motivo                 arccmc.motivo%type,
      plazo                  arccmc.plazo%type,
      desc_pronto_pago       arccmc.desc_pronto_pago%type,
      tipo_id_tributario     arccmc.tipo_id_tributario%type,
      cedula                 arccmc.cedula%type,
      tipoprecio             arccmc.tipoprecio%type,
      centro                 arccmc.centro%type,
      cliente_nacional       arccmc.cliente_nacional%type,
      condicion_tributaria   arccmc.condicion_tributaria%type,
      balancefactura         arccmc.balancefactura%type,
      ind_acepta_retencion   arccmc.ind_acepta_retencion%TYPE,
      --descuento1           arccmc.descuento1%TYPE,
      --descuento2           arccmc.descuento2%TYPE,
      --dividendo            arccmc.dividendo%type,
      fax                    arccmc.fax%type,
      email1                 arccmc.email1%type,
      nombre_enc             arccmc.nombre_enc%type,
      pais                   arccmc.pais%type,
      provincia              arccmc.provincia%type,
      canton                 arccmc.canton%type,
      vendedor               arccmc.vendedor%type,
      porc_desc              arccmc.porc_desc%type,
      razon_social           arccmc.razon_social%type,
      ind_cliente_ocasional  arccmc.ind_cliente_ocasional%type );
  -- ---
  --* INICIALIZA:
  --  Inicializa el paquete.
  --
  --* EXISTE
  --  Busca si el cliente esta definido.
  --
  --* TRAE_DATOS
  --  Devuelve un registro con la informacion del cliente indicado.
  --
  --* CREA_CUENTA
  --  Se encarga de la creacion de una cuenta por cobrar en una moneda determinada
  --  para un cliente.
  --
  --* EXISTE_CUENTA
  --  Indica si existe la cuenta por cobrar en una moneda determinada
  --  para un cliente.
  --
  --* SALDO
  --  Obtiene el saldo de un cliente en una moneda dada.
  --
  --* SALDO_CONSOLIDADO
  --  Calcula el saldo de un cliente consolidado en
  --  una moneda dada.
  --
  PROCEDURE inicializa(
      pCia VARCHAR2);
  --
  FUNCTION existe(pCia     VARCHAR2,
                  pGrupo   VARCHAR2,
                  pCliente VARCHAR2)RETURN BOOLEAN;
  --
  FUNCTION trae_datos(
      pCia     VARCHAR2,
      pGrupo   VARCHAR2,
      pCliente VARCHAR2)
    RETURN datos_r;
  --
  PROCEDURE crea_cuenta(
      pCia     VARCHAR2,
      pGrupo   VARCHAR2,
      pCliente VARCHAR2,
      pMoneda  VARCHAR2);
  --
  FUNCTION existe_cuenta(
      pCia     VARCHAR2,
      pGrupo   VARCHAR2,
      pCliente VARCHAR2,
      pMoneda  VARCHAR2)
    RETURN BOOLEAN;
  PROCEDURE genera_error(
      msj_error IN VARCHAR2,
      mensaje OUT VARCHAR2);
  --
  FUNCTION dias_entrega(
      pCia     VARCHAR2,
      pGrupo   VARCHAR2,
      pCliente VARCHAR2 )
    RETURN NUMBER;
  --
  FUNCTION limite_credito(
      pCia         VARCHAR2,
      pGrupo       VARCHAR2,
      pCliente     VARCHAR2,
      pMoneda      VARCHAR2,
      pTipo_cambio NUMBER)
    RETURN NUMBER;
  --
  FUNCTION saldo(
      pCia     VARCHAR2,
      pGrupo   VARCHAR2,
      pCliente VARCHAR2,
      pMoneda  VARCHAR2,
      pAno     NUMBER DEFAULT NULL,
      pMes     NUMBER DEFAULT NULL)
    RETURN NUMBER;
  --
  FUNCTION saldo_subcliente(
      pCia        VARCHAR2,
      pGrupo      VARCHAR2,
      pCliente    VARCHAR2,
      pSubCliente VARCHAR2,
      pMoneda     VARCHAR2,
      pAno        NUMBER DEFAULT NULL,
      pMes        NUMBER DEFAULT NULL )
    RETURN NUMBER;
  --
  FUNCTION Saldo_Consolidado(
      pCia         VARCHAR2,
      pGrupo       VARCHAR2,
      pCliente     VARCHAR2,
      pTipo_Cambio NUMBER,
      pMoneda      VARCHAR2 DEFAULT NULL,
      pAno         NUMBER DEFAULT NULL,
      pMes         NUMBER DEFAULT NULL)
    RETURN NUMBER;
  --
  FUNCTION cupo_consignado(
      pCia     VARCHAR2,
      pCentro  VARCHAR2,
      pCliente VARCHAR2 )
    RETURN NUMBER;
  --
  FUNCTION ultimo_error
    RETURN VARCHAR2;
  FUNCTION ultimo_mensaje
    RETURN VARCHAR2;
Type TypRec_DetalleFact
IS
  record
  (
    no_arti arfafl.no_arti%type,
    pedido arfafl.pedido%type,
    bodega_det arfafl.bodega%type );
  /*Funcion que verifica la existencia de un cliente x cedula/ruc/pasapote*/
  /**
  * Documentaci�n para P_ValidaCliente
  * Se hace validacion para que no valide RUC Cedula de Security Data
  * 
  * @author Byron Ant�n <banton@telconet.ec>
  * @version 1.1 22/10/2020 
  */
  PROCEDURE P_ValidaCliente(
      Pv_NoCia                IN VARCHAR2,
      Pv_Centro               IN VARCHAR2,
      Pv_Cedula               IN VARCHAR2,
      Pv_TipoIdTributacio     IN VARCHAR2,
      Pv_Grupo                IN VARCHAR2,
      Pv_TipoCliente          IN VARCHAR2,
      Pv_Nombre               IN VARCHAR2,
      Pv_Direccion            IN VARCHAR2,
      Pv_Telefono             IN VARCHAR2,
      Pv_Email                IN VARCHAR2,
      Pv_Pais                 IN VARCHAR2,
      Pv_Provincia            IN VARCHAR2,
      Pv_Canton               IN VARCHAR2,
      Pv_ClienteNacional      IN VARCHAR2,
      Pv_CondicionTributaria  IN VARCHAR2,
      Pv_IndAcptaRetencion    IN VARCHAR2,
      Pv_Vendedor             IN VARCHAR2,
      Pv_Division             IN VARCHAR2,
      Pv_TipoDoc              IN VARCHAR2,
      Pv_Ruta                 IN VARCHAR2,
      Pv_AfectaSaldo          IN VARCHAR2,
      Pv_Observ1              IN VARCHAR2,
      Pv_porcDesc             IN VARCHAR2,
      Pv_CodigoPlazo          IN VARCHAR2,
      Pv_Usuario              IN VARCHAR2,
      Pv_BodegaCab            IN VARCHAR2,
      Pv_IndAprobacionCredito IN VARCHAR2,
      Pv_FormaPagoSri         IN VARCHAR2,
      Pclob_ListPedido        IN CLOB,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2,
      Pv_NumeroFactura OUT VARCHAR2,
      Pclob_XmlFactura OUT CLOB);
  PROCEDURE P_ActualizaCliente(
      Pv_NoCia            IN VARCHAR2,
      Pv_Cedula           IN VARCHAR2,
      Pv_TipoIdTributacio IN VARCHAR2,
      Pv_Nombre           IN VARCHAR2,
      Pv_Direccion        IN VARCHAR2,
      Pv_Telefono         IN VARCHAR2,
      Pv_Email            IN VARCHAR2,
      Pv_Pais             IN VARCHAR2,
      Pv_Provincia        IN VARCHAR2,
      Pv_Canton           IN VARCHAR2,
      Pv_NoCliente OUT VARCHAR2,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2);
  PROCEDURE P_CreaCliente(
      Pv_NoCia               IN VARCHAR2,
      Pv_Centro              IN VARCHAR2,
      Pv_Cedula              IN VARCHAR2,
      Pv_TipoIdTributacio    IN VARCHAR2,
      Pv_Grupo               IN VARCHAR2,
      Pv_TipoCliente         IN VARCHAR2,
      Pv_Nombre              IN VARCHAR2,
      Pv_Direccion           IN VARCHAR2,
      Pv_Telefono            IN VARCHAR2,
      Pv_Email               IN VARCHAR2,
      Pv_Pais                IN VARCHAR2,
      Pv_Provincia           IN VARCHAR2,
      Pv_Canton              IN VARCHAR2,
      Pv_ClienteNacional     IN VARCHAR2,
      Pv_CondicionTributaria IN VARCHAR2,
      Pv_IndAcptaRetencion   IN VARCHAR2,
      Pv_Vendedor            IN VARCHAR2,
      Pv_Division            IN VARCHAR2,
      Pv_NoCliente OUT VARCHAR2,
      Pv_Salida OUT VARCHAR2,
      Pv_Mensaje OUT VARCHAR2);
  --
  error EXCEPTION;
  PRAGMA exception_init(error, -20014);
  kNum_error NUMBER :=         -20014;
  -- Define restricciones de procedimientos y funciones
  --    WNDS = Writes No Database State
  --    RNDS = Reads  No Database State
  --    WNPS = Writes No Package State
  --    RNPS = Reads  No Package State
  PRAGMA RESTRICT_REFERENCES(inicializa, WNDS);
  PRAGMA RESTRICT_REFERENCES(existe, WNDS);
END;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.cliente
IS
  /*******[ PARTE: PRIVADA ]
  * Declaracion de Procedimientos o funciones PRIVADOS
  *
  */
  gno_cia arcgmc.no_cia%type;
  gTStamp NUMBER;
  --
  CURSOR c_datos_cliente(pNo_cia VARCHAR2, pGrupo VARCHAR2, pCliente VARCHAR2)
  IS
    SELECT no_cia,
      grupo,
      no_cliente,
      corporacion,
      codigo_tercero,
      tipo_cliente,
      nombre,
      nombre_largo,
      ALIAS,
      nombre_comercial,
      direccion,
      apartado,
      fecha_ingre,
      cobrador,
      moneda_limite,
      limite_credi,
      excento_imp,
      telefono,
      telefono2,
      fax,
      f_cierre,
      motivo,
      plazo,
      desc_pronto_pago,
      tipo_id_tributario,
      cedula,
      tipoprecio,
      centro,
      cliente_nacional,
      condicion_tributaria,
      balancefactura,
      ind_acepta_retencion,
      email1,
      nombre_enc,
      pais,
      provincia,
      canton,
      vendedor,
      porc_desc,
      razon_social,
      ind_cliente_ocasional
    FROM arccmc
    WHERE no_cia   = pNo_cia
    AND grupo      = pGrupo
    AND no_cliente = pCliente;
  --
  RegCliente c_datos_cliente%rowtype;
  vMensaje_error VARCHAR2(160);
  vMensaje       VARCHAR2(160);
  --
PROCEDURE genera_error(
    msj_error IN VARCHAR2,
    mensaje OUT VARCHAR2)
IS
BEGIN
  vMensaje_error := msj_error;
  vMensaje       := msj_error;
  mensaje        :='prueba';
  --RAISE_APPLICATION_ERROR(kNum_error, msj_error);
END;
--
PROCEDURE mensaje(
    msj IN VARCHAR2)
IS
BEGIN
  vMensaje := msj;
END;
--
-- --
-- Valida si el paquete ya fue inicializado
FUNCTION inicializado(
    pCia VARCHAR2)
  RETURN BOOLEAN
IS
BEGIN
  RETURN ( NVL(gno_cia,'*NULO*') = pCia);
END inicializado;
--
--
/*******[ PARTE: PUBLICA ]
* Declaracion de Procedimientos o funciones PUBLICAS
*
*/
--
FUNCTION ultimo_error
  RETURN VARCHAR2
IS
BEGIN
  RETURN(vMensaje_error);
END ultimo_error;
--
FUNCTION ultimo_mensaje
  RETURN VARCHAR2
IS
BEGIN
  RETURN(vMensaje);
END ultimo_mensaje;
--
PROCEDURE inicializa(
    pCia VARCHAR2)
IS
BEGIN
  gno_cia := pCia;
END inicializa;
--
--
  FUNCTION existe(
      pCia     VARCHAR2,
      pGrupo   VARCHAR2,
      pCliente VARCHAR2
     )RETURN BOOLEAN IS
    --
      vFound  BOOLEAN;
      vtstamp NUMBER;
  BEGIN
      IF NOT inicializado(pCia) THEN
        inicializa(pCia);
      END IF;
      vFound                  := FALSE;
      vtstamp                 := TO_CHAR(sysdate, 'SSSSS');
      IF (gTstamp             IS NULL OR ABS(vtstamp - gTstamp) > 2) OR
         (regCliente.no_cia IS NULL OR regCliente.no_cliente IS NULL) OR
         (regCliente.no_cia != pCia OR regCliente.no_cliente != pCliente OR regCliente.grupo != pGrupo) THEN
        regCliente.no_cia     := NULL;
        regCliente.grupo      := NULL;
        regCliente.no_cliente := NULL;
        --
        OPEN c_datos_cliente(pCia, pGrupo, pCliente);
        FETCH c_datos_cliente INTO regCliente;
        vfound := c_datos_cliente%FOUND;
        CLOSE c_datos_cliente;
        gTstamp := TO_CHAR(sysdate, 'SSSSS');
      ELSE
        vFound := TRUE;
      END IF;
      RETURN ( vFound );
  END existe;
--
--
FUNCTION trae_datos(
    pCia     VARCHAR2,
    pGrupo   VARCHAR2,
    pCliente VARCHAR2 )
  RETURN datos_r
IS
  vReg_cliente datos_r;
BEGIN
  IF existe(pCia, pGrupo, pCliente) THEN
    vReg_cliente.no_cia                := regCliente.no_cia;
    vReg_cliente.grupo                 := regCliente.grupo;
    vReg_cliente.no_cliente            := regCliente.no_cliente;
    vReg_cliente.corporacion           := regCliente.corporacion;
    vReg_cliente.codigo_tercero        := regCliente.codigo_tercero;
    vReg_cliente.tipo_cliente          := regCliente.tipo_cliente;
    vReg_cliente.nombre                := regCliente.nombre;
    vReg_cliente.nombre_largo          := regCliente.nombre_largo;
    vReg_cliente.alias                 := regCliente.alias;
    vReg_cliente.nombre_comercial      := regCliente.nombre_comercial;
    vReg_cliente.direccion             := regCliente.direccion;
    vReg_cliente.apartado              := regCliente.apartado;
    vReg_cliente.fecha_ingre           := regCliente.fecha_ingre;
    vReg_cliente.cobrador              := regCliente.cobrador;
    vReg_cliente.moneda_limite         := regCliente.moneda_limite;
    vReg_cliente.limite_credi          := regCliente.limite_credi;
    vReg_cliente.excento_imp           := regCliente.excento_imp;
    vReg_cliente.telefono              := regCliente.telefono;
    vReg_cliente.telefono2             := regCliente.telefono2;
    vReg_cliente.f_cierre              := regCliente.f_cierre;
    vReg_cliente.motivo                := regCliente.motivo;
    vReg_cliente.plazo                 := regCliente.plazo;
    vReg_cliente.desc_pronto_pago      := regCliente.desc_pronto_pago;
    vReg_cliente.tipo_id_tributario    := regCliente.tipo_id_tributario;
    vReg_cliente.cedula                := regCliente.cedula;
    vReg_cliente.tipoprecio            := regCliente.tipoprecio;
    vReg_cliente.centro                := regCliente.centro;
    vReg_cliente.cliente_nacional      := regCliente.cliente_nacional;
    vReg_cliente.condicion_tributaria  := regCliente.condicion_tributaria;
    vReg_cliente.balancefactura        := regCliente.balancefactura;
    vReg_cliente.ind_acepta_retencion  := regCliente.ind_acepta_retencion;
    vReg_cliente.fax                   := RegCliente.Fax;
    vReg_cliente.email1                := RegCliente.email1;
    vReg_cliente.nombre_enc            := RegCliente.nombre_enc;
    vReg_cliente.pais                  := RegCliente.pais;
    vReg_cliente.provincia             := RegCliente.provincia;
    vReg_cliente.canton                := RegCliente.canton;
    vReg_cliente.vendedor              := RegCliente.vendedor;
    vReg_cliente.porc_desc             := RegCliente.porc_desc;
    vReg_cliente.razon_social          := RegCliente.razon_social;
    vReg_cliente.ind_cliente_ocasional := RegCliente.ind_cliente_ocasional;
  ELSE
    --genera_error('El Cliente '||pGrupo||'-'||pCliente||' no existe');
    NULL;
  END IF;
  RETURN (vReg_cliente);
END trae_datos;
--
--
PROCEDURE crea_cuenta(
    pCia     VARCHAR2,
    pGrupo   VARCHAR2,
    pCliente VARCHAR2,
    pMoneda  VARCHAR2 )
IS
  --
  -- Le crea una cuenta por cobrar al cliente en la moneda especificada.
  --
  CURSOR c_existe
  IS
    SELECT 'x'
    FROM arccms
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND moneda     = pMoneda;
  --
  vtmp      VARCHAR2(1);
  vencontro BOOLEAN;
  --
BEGIN
  OPEN c_existe;
  FETCH c_existe INTO vtmp;
  vencontro := c_existe%found;
  CLOSE c_existe;
  IF NOT vencontro THEN
    INSERT
    INTO arccms
      (
        NO_CIA,
        GRUPO,
        NO_CLIENTE,
        MONEDA,
        SALDO_ACTUAL
      )
      VALUES
      (
        pCia,
        pGrupo,
        pCliente,
        pMoneda,
        0
      );
  END IF;
END;
--
--
FUNCTION existe_cuenta
  (
    pCia     VARCHAR2,
    pGrupo   VARCHAR2,
    pCliente VARCHAR2,
    pMoneda  VARCHAR2
  )
  RETURN BOOLEAN
IS
  --
  -- Indica si existe la cuenta por cobrar del cliente en la moneda especificada.
  --
  CURSOR c_existe
  IS
    SELECT 'x'
    FROM arccms
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND moneda     = pMoneda;
  --
  vtmp      VARCHAR2(1);
  vencontro BOOLEAN;
  --
BEGIN
  OPEN c_existe;
  FETCH c_existe INTO vtmp;
  vencontro := c_existe%FOUND;
  CLOSE c_existe;
  RETURN(vencontro);
END;
--
--
FUNCTION dias_entrega(
    pCia     VARCHAR2,
    pGrupo   VARCHAR2,
    pCliente VARCHAR2 )
  RETURN NUMBER
IS
  --
  -- retorna el numero de dias de entrega de mercaderia al cliente
  --- dependiendo del canton en donde este registrado
  --
  CURSOR c_existe
  IS
    SELECT NVL(b.dias_entrega,0)
    FROM arccmc a,
      argecan b
    WHERE a.no_cia   = pcia
    AND a.grupo      =pgrupo
    AND a.no_cliente =pcliente
    AND a.canton     =b.canton
    AND a.pais       = b.pais
    AND a.provincia  =b.provincia;
  --
  vdias     NUMBER(3);
  vencontro BOOLEAN;
  --
BEGIN
  OPEN c_existe;
  FETCH c_existe INTO vdias;
  vencontro := c_existe%FOUND;
  CLOSE c_existe;
  IF vencontro THEN
    RETURN(vdias);
  ELSE
    RETURN(0);
  END IF;
END;
----
----
FUNCTION limite_credito(
    pCia         VARCHAR2,
    pGrupo       VARCHAR2,
    pCliente     VARCHAR2,
    pMoneda      VARCHAR2,
    pTipo_cambio NUMBER )
  RETURN NUMBER
IS
  --
  -- Calcula el credito disponible del cliente en la moneda del
  -- documento que se esta validando (pmoneda).
  --
  CURSOR c_saldo (pMon VARCHAR2)
  IS
    SELECT saldo_actual
    FROM arccms
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND moneda     = pMon;
  --
  vsaldo_actual_nom arccms.saldo_actual%type;
  vsaldo_actual_dol arccms.saldo_actual%type;
  vsaldo_actual arccms.saldo_actual%type;
  --
  vmoneda_limite arccmc.moneda_limite%type;
  vlimite_cred arccmc.limite_credi%type;
  vdisponible arccmc.limite_credi%type;
  vcontrola_lim_cred arccmc.balancefactura%type;
  --
  --vencontro           boolean;
  vReg_cliente datos_r;
  kSin_limite CONSTANT NUMBER(17,2) := 999999999999999;
BEGIN
  vDisponible := 0;
  --
  -- obtiene datos del control de limite de credito.
  vReg_cliente   := trae_datos(pCia, pGrupo, pCliente);
  vMoneda_limite := vReg_cliente.moneda_limite;
  vLimite_cred   := NVL(vReg_cliente.limite_credi,0);
  --
  -- obtiene el saldo del cliente en moneda nominal
  OPEN c_saldo('P');
  FETCH c_saldo INTO vSaldo_actual_nom;
  CLOSE c_saldo;
  vSaldo_actual_nom := NVL(vSaldo_actual_nom, 0);
  --
  -- obtiene el saldo del cliente en moneda dolares
  OPEN c_saldo('D');
  FETCH c_saldo INTO vSaldo_actual_dol;
  CLOSE c_saldo;
  vSaldo_actual_dol := NVL(vSaldo_actual_dol, 0);
  --
  -- se construye saldo actual en la moneda en que se lleva el limite de
  -- credito.
  IF vMoneda_limite = 'P' THEN
    vSaldo_actual  := vSaldo_actual_nom + (vSaldo_actual_dol*pTipo_cambio);
  ELSE -- vMoneda_limite = 'D'
    vSaldo_actual := vSaldo_actual_dol + (vSaldo_actual_nom/pTipo_cambio);
  END IF;
  vcontrola_lim_cred   :='N';
  IF vcontrola_lim_cred = 'S' THEN
    --
    -- calcula el monto disponible en la moneda del limite de credito al tipo
    -- de cambio dado.
    vDisponible := NVL(vlimite_cred,0) - NVL(vsaldo_actual,0);
    --
    -- calcula disponible en la moneda del documento al tipo de cambio dado.
    IF vMoneda_limite <> pMoneda THEN
      IF pMoneda       = 'P' THEN
        vDisponible   := NVL(vDisponible,0) * pTipo_cambio;
      ELSE -- pMoneda = 'D'
        vDisponible := NVL(vDisponible,0) / pTipo_cambio;
      END IF;
    END IF;
  ELSE --Cuando no se valida el limite se retorna un monto muy alto
    --que simula un tope infinito de credito
    vDisponible := kSin_limite;
  END IF;
  RETURN (NVL(vDisponible,0));
END;
--
--
FUNCTION saldo(
    pCia     VARCHAR2,
    pGrupo   VARCHAR2,
    pCliente VARCHAR2,
    pMoneda  VARCHAR2,
    pAno     NUMBER DEFAULT NULL, -- si no pasa ano y mes, obtiene el saldo actual.
    pMes     NUMBER DEFAULT NULL )
  RETURN NUMBER
IS
  --
  -- Obtiene el saldo de un cliente en una moneda dada. En el caso de desear el
  -- saldo actual, debe dejar nulos los parametros ano y mes.
  --
  CURSOR c_saldo_ant
  IS
    SELECT saldo
    FROM arccsa
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND ano        = pAno
    AND mes        = pMes
    AND moneda     = pMoneda;
  --
  CURSOR c_saldo
  IS
    SELECT saldo_actual
    FROM arccms
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND moneda     = pMoneda;
  --
  vSaldo arcpms.saldo_actual%type;
BEGIN
  IF pAno IS NULL OR pMes IS NULL THEN
    -- obtiene saldo actual
    OPEN c_saldo;
    FETCH c_saldo INTO vSaldo;
    CLOSE c_saldo;
  ELSE
    -- obtiene saldo historico
    OPEN c_saldo_ant;
    FETCH c_saldo_ant INTO vSaldo;
    CLOSE c_saldo_ant;
  END IF;
  vSaldo := NVL(vSaldo,0);
  RETURN(vsaldo);
END;
-- Creado por MGU por obtener los saldos de los subclientes
FUNCTION saldo_subcliente(
    pCia        VARCHAR2,
    pGrupo      VARCHAR2,
    pCliente    VARCHAR2,
    pSubCliente VARCHAR2,
    pMoneda     VARCHAR2,
    pAno        NUMBER DEFAULT NULL, -- si no pasa ano y mes, obtiene el saldo actual.
    pMes        NUMBER DEFAULT NULL )
  RETURN NUMBER
IS
  --
  -- Obtiene el saldo de un Subcliente en una moneda dada. En el caso de desear el
  -- saldo actual, debe dejar nulos los parametros ano y mes.
  --
  CURSOR c_saldo_ant
  IS
    SELECT saldo
    FROM arccsa_subcliente
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND subcliente = pSubCliente
    AND ano        = pAno
    AND mes        = pMes
    AND moneda     = pMoneda;
  --
  CURSOR c_saldo
  IS
    SELECT saldo_actual
    FROM arccms_subcliente
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND subcliente = pSubCliente
    AND moneda     = pMoneda;
  --
  vSaldo arcpms.saldo_actual%type;
BEGIN
  IF pAno IS NULL OR pMes IS NULL THEN
    -- obtiene saldo actual
    OPEN c_saldo;
    FETCH c_saldo INTO vSaldo;
    CLOSE c_saldo;
  ELSE
    -- obtiene saldo historico
    OPEN c_saldo_ant;
    FETCH c_saldo_ant INTO vSaldo;
    CLOSE c_saldo_ant;
  END IF;
  vSaldo := NVL(vSaldo,0);
  RETURN(vsaldo);
END;
--
FUNCTION Saldo_Consolidado(
    pCia         VARCHAR2,
    pGrupo       VARCHAR2,
    pCliente     VARCHAR2,
    pTipo_Cambio NUMBER,
    pMoneda      VARCHAR2 DEFAULT NULL, -- Si no pasa la moneda usa arccmc.moneda_limite
    pAno         NUMBER DEFAULT NULL,   -- si no pasa ano y mes, obtiene el saldo actual.
    pMes         NUMBER DEFAULT NULL)
  /* Calcula el saldo del cliente pgrupo,pCliente consolidado en
  la moneda indicada en pMoneda. Si se deja pMoneda en NULL
  se toma la moneda del limite de credito.
  */
  RETURN NUMBER
IS
  --
  -- Obtiene el saldo de un cliente en una moneda dada. En el caso de desear el
  -- saldo actual, debe dejar nulos los parametros ano y mes.
  --
  CURSOR c_saldo_ant(pGrupo arccsa.grupo%TYPE,
                     pCliente arccsa.no_cliente%TYPE,
                     pMoneda arccsa.moneda%TYPE,
                     pAno arccsa.ano%TYPE,
                     pMes arccsa.ano%TYPE)
  IS
    SELECT saldo
    FROM arccsa
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND ano        = pAno
    AND mes        = pMes
    AND moneda     = pMoneda;
  CURSOR c_saldo(pGrupo arccms.grupo%TYPE, pCliente arccms.no_cliente%TYPE, pMoneda arccms.moneda%TYPE)
  IS
    SELECT saldo_actual
    FROM arccms
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente
    AND moneda     = pMoneda;
  CURSOR c_mon_limite(pGrupo arccms.grupo%TYPE, pCliente arccms.no_cliente%TYPE)
  IS
    SELECT moneda_limite
    FROM arccmc
    WHERE no_cia   = pCia
    AND grupo      = pGrupo
    AND no_cliente = pCliente;
  vEncontrado BOOLEAN;
  vSaldo arccms.saldo_actual%TYPE;
  vSaldo_Col arccms.saldo_actual%TYPE;
  vSaldo_Dol arccms.saldo_actual%TYPE;
  vMoneda_saldo arccmc.moneda_limite%TYPE;
BEGIN
  IF NVL(pTipo_Cambio, 0) = 0 THEN
    --genera_error('El tipo de cambio no puede ser 0');
    NULL;
  END IF;
  vMoneda_saldo    := pMoneda;
  IF vMoneda_saldo IS NULL THEN -- Leer la moneda de arccmc.moneda_limite
    OPEN c_mon_limite(pGrupo, pCliente);
    FETCH c_mon_limite INTO vMoneda_saldo;
    vEncontrado := c_mon_limite%FOUND;
    CLOSE c_mon_limite;
    IF NOT vEncontrado THEN
      --genera_error('El Cliente '||pGrupo||'-'||pCliente||' no existe');
      NULL;
    END IF;
  END IF;
  --
  -- Supone que solamente existen dos monedas: Nominal y Dolar (P, D)
  --
  IF pAno IS NULL OR pMes IS NULL THEN
    -- saldo actual
    -- saldo en nominal
    OPEN c_saldo(pGrupo, pCliente, 'P');
    FETCH c_saldo INTO vSaldo_Col;
    CLOSE c_saldo;
    -- saldo en dolares
    OPEN c_saldo(pGrupo, pCliente, 'D');
    FETCH c_saldo INTO vSaldo_Dol;
    CLOSE c_saldo;
  ELSE
    -- saldo historico
    -- saldo en nominal
    OPEN c_saldo_ant(pGrupo, pCliente, 'P', pAno, pMes);
    FETCH c_saldo_ant INTO vSaldo_Col;
    CLOSE c_saldo_ant;
    -- saldo en dolares
    OPEN c_saldo_ant(pGrupo, pCliente, 'D', pAno, pMes);
    FETCH c_saldo_ant INTO vSaldo_Dol;
    CLOSE c_saldo_ant;
  END IF;
  vSaldo_Col      := NVL(vSaldo_Col, 0);
  vSaldo_Dol      := NVL(vSaldo_Dol, 0);
  IF vMoneda_saldo = 'P' THEN
    vSaldo        := vSaldo_Col + (vSaldo_Dol * pTipo_Cambio);
  ELSE
    vSaldo := (vSaldo_Col / pTipo_Cambio) + vSaldo_Dol;
  END IF;
  RETURN(vSaldo);
END; -- Saldo_Consolidado
---**************************************************************************************--
-- Funcion que permite obtener el valor total de todas las consignaciones transferidas de un
-- cliente con el objetivo de obtener el cupo disponible que tiene dicho cliente.
---**************************************************************************************--
FUNCTION cupo_consignado(
    pCia     VARCHAR2,
    pCentro  VARCHAR2,
    pCliente VARCHAR2 )
  RETURN NUMBER
IS
  -- Definicion de cursores
  CURSOR C_DETCONSIG (CV_CIA VARCHAR2, CV_CENTRO VARCHAR2, CV_CLIENTE VARCHAR2 )
  IS
    SELECT CL.NO_DOCU,
      CL.ESTADO,
      CL.NO_CLIENTE_VEND,
      CALCONSIGCLI.ART,
      CALCONSIGCLI.REQ,
      CALCONSIGCLI.APRO,
      CALCONSIGCLI.FAC,
      CALCONSIGCLI.DEV,
      CALCONSIGCLI.PVP,
      CALCONSIGCLI.TRANSF,
      CALCONSIGCLI.REORD,
      CALCONSIGCLI.VALOR
    FROM ARINENCCONSIGNACLI CL,
      (SELECT (NVL(DC.UNI_TRANSFERIDA,0)-NVL(DC.UNI_FACTURADAS,0)-NVL(DC.UNI_DEVUELTAS,0)-NVL(DC.UNI_REORDENA,0)) VALOR,
        DC.NO_CIA CIA,
        DC.NO_DOCU DOCU,
        DC.NO_ARTI ART,
        DC.UNI_REQUERIDAS REQ,
        DC.UNI_APROBADAS APRO,
        DC.UNI_FACTURADAS FAC,
        DC.UNI_DEVUELTAS DEV,
        DC.PRECIO_PVP PVP,
        DC.UNI_TRANSFERIDA TRANSF,
        DC.UNI_REORDENA REORD
      FROM ARINDETCONSIGNACLI DC
      ) CALCONSIGCLI
  WHERE CALCONSIGCLI.DOCU    = CL.NO_DOCU
  AND CALCONSIGCLI.CIA       = CL.NO_CIA
  AND CL.TIPO_CONSIGNCLIENTE = 'C'
  AND CALCONSIGCLI.VALOR     > 0
  AND CL.NO_CIA              = CV_CIA
  AND CL.CENTRO              = CV_CENTRO
  AND CL.ESTADO              = 'T'
  AND CL.NO_CLIENTE_VEND     = CV_CLIENTE;
  -- Definicion de Variables.
  ln_valor     NUMBER;
  ln_aDevolver NUMBER;
  ln_pvp       NUMBER;
  ln_subtotal  NUMBER;
  --
BEGIN
  -- Seteo de Variables
  ln_valor :=0;
  --
  FOR reg IN C_DETCONSIG(pCia,pCentro,pCliente)
  LOOP
    --
    ln_aDevolver := reg.valor;
    ln_pvp       := reg.pvp;
    ln_subtotal  := ln_aDevolver * ln_pvp;
    --
    ln_valor := ln_valor + ln_subtotal;
    --
  END LOOP;
  --
  RETURN(ln_valor);
  --
EXCEPTION
WHEN OTHERS THEN
  ln_valor := 0;
  RETURN(ln_valor);
END;
/**
* Documentacion para el procedimiento P_ValidaCliente
* Procedimiento que verifica la existencia del cliente para el llamando al procedimiento respectivo de insercion o actualiziacion
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
*/
PROCEDURE P_ValidaCliente(
    Pv_NoCia                IN VARCHAR2,
    Pv_Centro               IN VARCHAR2,
    Pv_Cedula               IN VARCHAR2,
    Pv_TipoIdTributacio     IN VARCHAR2,
    Pv_Grupo                IN VARCHAR2,
    Pv_TipoCliente          IN VARCHAR2,
    Pv_Nombre               IN VARCHAR2,
    Pv_Direccion            IN VARCHAR2,
    Pv_Telefono             IN VARCHAR2,
    Pv_Email                IN VARCHAR2,
    Pv_Pais                 IN VARCHAR2,
    Pv_Provincia            IN VARCHAR2,
    Pv_Canton               IN VARCHAR2,
    Pv_ClienteNacional      IN VARCHAR2,
    Pv_CondicionTributaria  IN VARCHAR2,
    Pv_IndAcptaRetencion    IN VARCHAR2,
    Pv_Vendedor             IN VARCHAR2,
    Pv_Division             IN VARCHAR2,
    Pv_TipoDoc              IN VARCHAR2,
    Pv_Ruta                 IN VARCHAR2,
    Pv_AfectaSaldo          IN VARCHAR2,
    Pv_Observ1              IN VARCHAR2,
    Pv_porcDesc             IN VARCHAR2,
    Pv_CodigoPlazo          IN VARCHAR2,
    Pv_Usuario              IN VARCHAR2,
    Pv_BodegaCab            IN VARCHAR2,
    Pv_IndAprobacionCredito IN VARCHAR2,
    Pv_FormaPagoSri         IN VARCHAR2,
    Pclob_ListPedido        IN CLOB,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2,
    Pv_NumeroFactura OUT VARCHAR2,
    Pclob_XmlFactura OUT CLOB)
IS
  CURSOR C_ValidaCliente
  IS
    SELECT COUNT(*), NO_CLIENTE
    FROM ARCCMC
    WHERE NO_CIA           = Pv_NoCia
    AND CEDULA             = Pv_Cedula
    AND TIPO_ID_TRIBUTARIO = Pv_TipoIdTributacio
    GROUP BY NO_CLIENTE;

  CURSOR C_PARAMETRO IS
  SELECT PR.PARAMETRO
      FROM GE_PARAMETROS PR,
        GE_GRUPOS_PARAMETROS GP
      WHERE PR.ID_GRUPO_PARAMETRO = GP.ID_GRUPO_PARAMETRO
      AND PR.ID_APLICACION = GP.ID_APLICACION
      AND PR.ID_EMPRESA = GP.ID_EMPRESA
      AND PR.ID_APLICACION = 'CC'
      AND PR.ID_GRUPO_PARAMETRO = 'NO-VALIDA-RUC'
      AND PR.ESTADO = 'A'
      AND GP.ESTADO = 'A'
      AND PR.ID_EMPRESA=Pv_NoCia;

  Lv_parametro VARCHAR2(2); 
  Lv_NoCliente ARCCMC.No_Cliente%TYPE:= NULL;
  Ln_Existe      NUMBER                   :=0;
  Lv_error       VARCHAR2(500)            := NULL;
  Le_ErrorCedula EXCEPTION;
BEGIN
  IF C_ValidaCliente%ISOPEN THEN
    CLOSE C_ValidaCliente;
  END IF;
  OPEN C_ValidaCliente;
  FETCH C_ValidaCliente INTO Ln_Existe,Lv_NoCliente;
  CLOSE C_ValidaCliente;
  
  IF C_PARAMETRO%ISOPEN THEN
    CLOSE C_PARAMETRO;
  END IF;
  --obtengo bandera de compania que no se valida cedula o RUC
  OPEN C_PARAMETRO;
  FETCH C_PARAMETRO INTO Lv_parametro;
  CLOSE C_PARAMETRO;
  IF Pv_TipoIdTributacio = 'C' AND NVL(Lv_parametro,'N')='N' THEN
    VALIDA_IDENTIFICACION.VALIDA('C', Pv_Cedula, Lv_error);
  ELSIF Pv_TipoIdTributacio = 'R' AND NVL(Lv_parametro,'N')='N' THEN
    VALIDA_IDENTIFICACION.VALIDA('R', Pv_Cedula, Lv_error);
  END IF;
  IF Lv_error   IS NULL THEN
    IF Ln_Existe > 0 THEN
      P_ActualizaCliente (Pv_NoCia,
                          Pv_Cedula,
                          Pv_TipoIdTributacio,
                          Pv_Nombre,
                          Pv_Direccion,
                          Pv_Telefono,
                          Pv_Email,
                          Pv_Pais,
                          Pv_Provincia,
                          Pv_Canton,
                          Lv_NoCliente,
                          Pv_Salida,
                          Pv_Mensaje);
    ELSE
      P_CreaCliente (Pv_NoCia,
                     Pv_Centro,
                     Pv_Cedula,
                     Pv_TipoIdTributacio,
                     Pv_Grupo,
                     Pv_TipoCliente,
                     Pv_Nombre,
                     Pv_Direccion,
                     Pv_Telefono,
                     Pv_Email,
                     Pv_Pais,
                     Pv_Provincia,
                     Pv_Canton,
                     Pv_ClienteNacional,
                     Pv_CondicionTributaria,
                     Pv_IndAcptaRetencion,
                     Pv_Vendedor,
                     Pv_Division,
                     Lv_NoCliente,
                     Pv_Salida,
                     Pv_Mensaje);
    END IF;
  ELSE
    RAISE Le_ErrorCedula;
  END IF;
  FAK_PROCESOS.P_CREA_FACTURA(Pv_NoCia,
                              Pv_Centro,
                              Pv_Cedula,
                              Pv_TipoIdTributacio,
                              Pv_Grupo,
                              Pv_TipoCliente,
                              Pv_Vendedor,
                              Pv_Division,
                              Pv_TipoDoc,
                              Pv_Ruta,
                              Pv_AfectaSaldo,
                              Pv_Observ1,
                              Pv_porcDesc,
                              Pv_BodegaCab,
                              Pv_FormaPagoSri,
                              Pv_Usuario,
                              Pclob_ListPedido,
                              Pv_Salida,
                              Pv_Mensaje,
                              Pv_NumeroFactura,
                              Pclob_XmlFactura);
EXCEPTION
WHEN Le_ErrorCedula THEN
  Pv_Salida := '403';
  Pv_Mensaje:= 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF',
                                       'CLIENTE.P_VALIDACLIENTE',
                                       'Le_ErrorCedula - ValidaCliente: '||SQLERRM,
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER),
                                       SYSDATE,
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                       '127.0.0.1'));
  ROLLBACK;
WHEN OTHERS THEN
  Pv_Salida := '403';
  Pv_Mensaje:= 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF',
                                       'CLIENTE.P_VALIDACLIENTE',
                                       'Error en Otros - ValidaCliente: '||SQLERRM,
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER),
                                       SYSDATE,
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                       '127.0.0.1'));
  ROLLBACK;
END P_ValidaCliente;
/**
* Documentacion para el procedimiento P_ActualizaCliente
* Procedimiento que actualiza la informacion del cliente
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.1 24-01-2017 La actualizacion del cliente debe de ser por numero de identificacion, mas no por centro
*/
PROCEDURE P_ActualizaCliente(
    Pv_NoCia            IN VARCHAR2,
    Pv_Cedula           IN VARCHAR2,
    Pv_TipoIdTributacio IN VARCHAR2,
    Pv_Nombre           IN VARCHAR2,
    Pv_Direccion        IN VARCHAR2,
    Pv_Telefono         IN VARCHAR2,
    Pv_Email            IN VARCHAR2,
    Pv_Pais             IN VARCHAR2,
    Pv_Provincia        IN VARCHAR2,
    Pv_Canton           IN VARCHAR2,
    Pv_NoCliente OUT VARCHAR2,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2)
IS
  CURSOR C_CLIENTES
  IS
    SELECT NO_CLIENTE
    FROM ARCCMC
    WHERE NO_CIA                      = Pv_NoCia
    AND CEDULA                        = Pv_Cedula
    AND TIPO_ID_TRIBUTARIO            = Pv_TipoIdTributacio;
  Lv_NoCliente ARCCMC.No_Cliente%TYPE:= NULL;
  Le_Error EXCEPTION;
BEGIN
  IF C_CLIENTES%ISOPEN THEN
    CLOSE C_CLIENTES;
  END IF;
  OPEN C_CLIENTES;
  FETCH C_CLIENTES INTO Lv_NoCliente;
  CLOSE C_CLIENTES;
  -- Actualizacion de Cliente
  UPDATE ARCCMC
  SET NOMBRE             = UPPER(Pv_Nombre),
    NOMBRE_COMERCIAL     = UPPER(Pv_Nombre),
    NOMBRE_LARGO         = UPPER(Pv_Nombre),
    RAZON_SOCIAL         = UPPER(Pv_Nombre),
    DIRECCION            = UPPER(Pv_Direccion),
    TELEFONO             = Pv_Telefono,
    PAIS                 = Pv_Pais,
    PROVINCIA            = Pv_Provincia,
    CANTON               = Pv_Canton,
    EMAIL1               = Pv_Email
  WHERE NO_CIA           = Pv_NoCia
  AND CEDULA             = Pv_Cedula
  AND TIPO_ID_TRIBUTARIO = Pv_TipoIdTributacio;
  -- Actualizacion de LocalesCliente
  UPDATE ARCCLOCALES_CLIENTES
  SET DESCRIPCION = UPPER(Pv_Nombre),
    DIRECCION     = UPPER(Pv_Direccion),
    TELEFONO      =Pv_Telefono,
    PAIS          = Pv_Pais,
    PROVINCIA     =Pv_Provincia,
    CANTON        = Pv_Canton
  WHERE NO_CIA    = Pv_NoCia
  AND NO_CLIENTE  = Lv_NoCliente;
EXCEPTION
WHEN OTHERS THEN
  Pv_Salida := '403';
  Pv_Mensaje:= 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF',
                                       'CLIENTE.ActualizaCliente',
                                       'Error en Otros - ActualizaCliente: '||SQLERRM,
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER),
                                       SYSDATE, NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                       '127.0.0.1'));
  ROLLBACK;
END P_ActualizaCliente;
/**
* Documentacion para el procedimiento P_CreaCliente
* Procedimiento que crea cliente
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.0 19-09-2016
*/
PROCEDURE P_CreaCliente(
    Pv_NoCia               IN VARCHAR2,
    Pv_Centro              IN VARCHAR2,
    Pv_Cedula              IN VARCHAR2,
    Pv_TipoIdTributacio    IN VARCHAR2,
    Pv_Grupo               IN VARCHAR2,
    Pv_TipoCliente         IN VARCHAR2,
    Pv_Nombre              IN VARCHAR2,
    Pv_Direccion           IN VARCHAR2,
    Pv_Telefono            IN VARCHAR2,
    Pv_Email               IN VARCHAR2,
    Pv_Pais                IN VARCHAR2,
    Pv_Provincia           IN VARCHAR2,
    Pv_Canton              IN VARCHAR2,
    Pv_ClienteNacional     IN VARCHAR2,
    Pv_CondicionTributaria IN VARCHAR2,
    Pv_IndAcptaRetencion   IN VARCHAR2,
    Pv_Vendedor            IN VARCHAR2,
    Pv_Division            IN VARCHAR2,
    Pv_NoCliente OUT VARCHAR2,
    Pv_Salida OUT VARCHAR2,
    Pv_Mensaje OUT VARCHAR2)
IS
  CURSOR C_CLIENTES
  IS
    SELECT NO_CLIENTE
    FROM ARCCMC
    WHERE NO_CIA                      = Pv_NoCia
    AND CENTRO                        = Pv_Centro
    AND CEDULA                        = Pv_Cedula
    AND TIPO_ID_TRIBUTARIO            = Pv_TipoIdTributacio;
  Lv_NoCliente ARCCMC.NO_CLIENTE%TYPE:= NULL;
BEGIN
  INSERT
  INTO ARCCMC
    (
      NO_CIA,
      CENTRO,
      CEDULA,
      TIPO_ID_TRIBUTARIO,
      GRUPO,
      TIPO_CLIENTE,
      NOMBRE,
      NOMBRE_COMERCIAL,
      DIRECCION,
      TELEFONO,
      EMAIL1,
      PAIS,
      PROVINCIA,
      CANTON,
      CLIENTE_NACIONAL,
      CONDICION_TRIBUTARIA,
      IND_ACEPTA_RETENCION,
      VENDEDOR,
      NO_CLIENTE,
      MONEDA_LIMITE,
      TIPOPRECIO,
      SALDO_ANTE,
      DEBITOS,
      CREDITOS,
      PARTE_RELACIONADA,
      RAZON_SOCIAL
    )
    VALUES
    (
      Pv_NoCia,
      Pv_Centro,
      Pv_Cedula,
      Pv_TipoIdTributacio,
      Pv_Grupo,
      Pv_TipoCliente,
      Pv_Nombre,
      Pv_Nombre,
      Pv_Direccion,
      Pv_Telefono,
      Pv_Email,
      Pv_Pais,
      Pv_Provincia,
      Pv_Canton,
      Pv_ClienteNacional,
      Pv_CondicionTributaria,
      Pv_IndAcptaRetencion,
      Pv_Vendedor,
      (SELECT MAX(TO_NUMBER(NO_CLIENTE)+1)
      FROM ARCCMC
      WHERE NO_CIA = Pv_NoCia
      AND GRUPO    = Pv_Grupo
      ),
      'P',
      '01',
      0,0,
      0,
      'N',
      Pv_Nombre
    );
  IF C_CLIENTES%ISOPEN THEN
    CLOSE C_CLIENTES;
  END IF;
  OPEN C_CLIENTES;
  FETCH C_CLIENTES INTO Lv_NoCliente;
  CLOSE C_CLIENTES;
  INSERT
  INTO ARCCLOCALES_CLIENTES
    (
      NO_CIA,
      GRUPO,
      NO_CLIENTE,
      NO_SUB_CLIENTE,
      DESCRIPCION,
      CENTRO,
      VENDEDOR,
      ESTADO,
      DIV_COMERCIAL,
      IND_PRINCIPAL,
      IND_DISTRIBUCION,
      USUARIO,
      T_STAMP,
      PAIS,
      PROVINCIA,
      CANTON,
      DIRECCION,
      TELEFONO
    )
    VALUES
    (
      Pv_NoCia,
      Pv_Grupo,
      Lv_NoCliente,
      Lv_NoCliente,
      Pv_Nombre,
      Pv_Centro,
      Pv_Vendedor,
      'A',
      Pv_Division,
      'S',
      'P',
      USER,
      SYSDATE,
      Pv_Pais,
      Pv_Provincia,
      Pv_Canton,
      Pv_Direccion,
      Pv_Telefono
    );
EXCEPTION
WHEN OTHERS THEN
  Pv_Salida := '403';
  Pv_Mensaje:= 'Error';
  DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('API-NAF',
                                       'CLIENTE.P_CreaCliente',
                                       'Error en Otros - P_CreaCliente: '||SQLERRM,
                                       NVL(SYS_CONTEXT('USERENV','HOST'), USER),
                                       SYSDATE,
                                       NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),
                                       '127.0.0.1'));
  ROLLBACK;
END P_CreaCliente;
END; -- package body cliente
/