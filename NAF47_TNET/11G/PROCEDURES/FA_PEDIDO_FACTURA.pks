create or replace procedure            FA_PEDIDO_FACTURA(Pv_Cia          IN  Varchar2,
                                              Pv_Docu_Picking IN  Varchar2,
                                              Pv_Msg_Generado OUT Varchar2, --- Informa documentos que se han generado
                                              Pv_Error        OUT Varchar2) is

/**** El siguiente proceso transforma un pedido que esta en picking aprobado en una factura pendiente de actualizar ****/
--- ANR 26/06/2009
  --
  vmsg_error      varchar2(400);
  vmsg            varchar2(120);
  --
  vtipo_doc_fact  arfafe.tipo_doc%type;
  vprocesa        boolean;
  vCant_Lineas    number;                 -- cantidad lineas del pedido
  vMax_lineas     arfact.max_linea%type;
  --
  error_proceso    exception;
  --

  --
  CURSOR c_tipo_doc_fact(pno_cia      arfact.no_cia%TYPE--, --- No es necesario crear un documento para
                         ---pafecta_cxc  arfact.afecta_saldo%TYPE
                         ) IS
    SELECT tipo tipo_doc, afecta_saldo, tipo_mov, max_linea, tipo_doc_cxc, tipo_doc_inve
      FROM arfact
     WHERE no_cia       = pno_cia
       AND anula_factu  = 'N'
       AND ind_fac_dev  = 'F'
       AND pedido       = 'S'
       AND nvl(ind_consignacion,'N') = 'N';
  --
 --- Se tomaran solamente los que esten de picking y que esten aprobados ya que el estado aprobado se actualizo, cuando se aprueba el picking ANR 26/06/2009

  -- pedidos
  CURSOR c_pedidos IS
    SELECT centrod, periodo,    no_factu no_pedido, ruta,
           grupo,   no_cliente, afecta_saldo,  moneda, nvl(tipo_cambio,1) tipo_cambio,
           ind_exportacion, imp_sino,
           tot_lin, sub_total, descuento, impuesto, total, rowid
      FROM arfafec
     WHERE no_cia           = Pv_Cia
       AND estado           = 'Z'
       AND aprobado         = 'S'
       AND no_docu_refe_picking  = Pv_Docu_Picking
       AND tipo_factura     = 'P';
  -- --
  --
  CURSOR c_lineas_ped(pcentrod VARCHAR2, pno_ped VARCHAR2) IS
    SELECT count(1)
      FROM arfaflc
     WHERE no_cia               = Pv_Cia
       AND centrod              = pcentrod
       AND no_factu             = pno_ped
       AND nvl(cant_aprobada,0) > 0;

 --- Verifico si el pedido viene con transporte incluido ANR 13/10/2009
  CURSOR c_lineas_ped_transp (pcentrod VARCHAR2, pno_ped VARCHAR2) IS
    SELECT count(1)
      FROM arfaflc
     WHERE no_cia               = Pv_Cia
       AND centrod              = pcentrod
       AND no_factu             = pno_ped
       AND bodega  = '0000';

 Ln_lineas_menos Number := 0;

  --
  -- --
  --
  rtdoc_cred    c_tipo_doc_fact%ROWTYPE;
BEGIN

  FOR ep IN c_pedidos LOOP

  -- carga el tipo de documento y sus propiedades
  OPEN  c_tipo_doc_fact(Pv_Cia);--, 'S');    -- datos tipo doc. de credito
  FETCH c_tipo_doc_fact INTO rtdoc_cred;
  CLOSE c_tipo_doc_fact;
  --
  --
  IF rtdoc_cred.tipo_doc IS NULL THEN --- Solamente es necesario un documento de credito ya que todo se va a CxC ANR 23/06/2009
    vmsg_error := 'Falta definir documentos para facturacion de pedidos';
    RAISE error_proceso;
  ELSIF rtdoc_cred.tipo_doc IS NULL THEN
    vmsg_error := 'No se procesaran pedidos a credito, '||
              'pues falta definir el tipo de documento para tal efecto';
    raise error_proceso;
  END IF;
    --
    -- Determina el tipo de documento, de acuerdo al tipo de venta
      vtipo_doc_fact := rtdoc_cred.tipo_doc;    -- venta de credito
      vmax_lineas    := rtdoc_cred.max_linea;--- Solamente es necesario un documento de credito ya que todo se va a CxC ANR 23/06/2009
    --
    vprocesa     := (vtipo_doc_fact IS NOT NULL);
    vCant_lineas := 0;

    -- se agrega condicion para que procese solo los pedidos
    -- bajo el mismo documento

       IF vprocesa THEN
        OPEN  c_lineas_ped (ep.centrod, ep.no_pedido);
         FETCH c_lineas_ped INTO vCant_Lineas;
         CLOSE c_lineas_ped;
      END IF;
      --

      If nvl(vCant_Lineas,0) = 0 Then
         vmsg_error := 'No hay lineas aprobadas en el pedido: '||ep.no_pedido||' para generar la factura ';
         raise error_proceso;
      end if;

      If nvl(vMax_Lineas,0) = 0 Then
         vmsg_error := 'Debe configurar el maximo numero de lineas para generar la factura ';
         raise error_proceso;
      end if;

       --- Si ya esta registrado servicios de transporte entonces no tengo que separar una linea para el transporte ANR 13/10/2009
       OPEN  c_lineas_ped_transp (ep.centrod, ep.no_pedido);
       FETCH c_lineas_ped_transp INTO Ln_lineas_menos;
       If c_lineas_ped_transp%notfound Then
        CLOSE c_lineas_ped_transp;
        Ln_lineas_menos := -1;
       else
        CLOSE c_lineas_ped_transp;
        Ln_lineas_menos := 0;
       end if;


      IF NOT vprocesa THEN
         NULL;

      ELSIF nvl(vCant_Lineas, 0) >= (vMax_Lineas - Ln_lineas_menos) THEN ---- Considerando dos lineas (Una linea menos para el registro del transporte)
          --- Por el pedido, debe crear una factura por el maximo numero de lineas
          --- Debe considerar ordenar primero las lineas que tienen promociones para que alcancen
          ---  todas las promociones en una misma factura (ESCALAS ESPECIALES).
          ---  Para el transporte dejar una linea para que pueda ser ingresado posteriormente ANR 03/08/2009

          vmsg_error := NULL;
          vmsg       := NULL;

          FACREA_VARIAS_FACTURAS(Pv_Cia,    ep.no_pedido,
                                 ep.ruta,   ep.periodo,    vtipo_doc_fact,
                                 vMax_Lineas - Ln_lineas_menos,
                                 ep.tipo_cambio, Pv_Msg_Generado,     vmsg);

          IF vmsg IS NOT NULL THEN
            vmsg_error := vmsg;
            raise error_proceso;
          END IF;

      ELSIF nvl(vCant_Lineas, 0) < (vMax_Lineas - Ln_lineas_menos) THEN  ----- Se genera de un pedido una factura

          vmsg_error := NULL;
          vmsg       := NULL;

          FACREA_FACTURA(Pv_Cia,    ep.no_pedido,
                         ep.ruta,   ep.periodo,    vtipo_doc_fact,
                         ep.tipo_cambio, Pv_Msg_Generado, vmsg);

          IF vmsg IS NOT NULL THEN
            vmsg_error := vmsg;
            raise error_proceso;
          END IF;

      END IF;

  END LOOP;      -- Pedidos a generar

EXCEPTION
  WHEN error_proceso THEN
       Pv_Error := vmsg_error;
  WHEN OTHERS THEN
       Pv_Error := 'Error en FA_PEDIDO_FACTURA '||SQLERRM;
END FA_PEDIDO_FACTURA;