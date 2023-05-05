create or replace PROCEDURE            CCACTUALIZA_OR(PNO_CIA     IN ARCCMD.NO_CIA%TYPE,
                                        PTIPO_DOC   IN ARCCMD.TIPO_DOC%TYPE,
                                        PNO_DOCU    IN ARCCMD.NO_DOCU%TYPE,
                                        PERROR      IN OUT VARCHAR2) IS
-- PL/SQL Specification
/*
  * Actualiza un documento por cobrar, aumentando o disminuyendo
  * la cuenta por cobrar del cliente al que pertenece el documento.
  *
  * Si el a?o y mes del documento es superior al periodo en proceso
  * del modulo de CxC, entonces lo deja en estado pendiente.
  *
  *
  */

/****************************

1) Cuando es un documento de debito con dividendos, se deben bajar los dividendos, para eso utiliza el proceso CCACTUALIZA_DIVIDENDOS
2) Si la forma de pago es un cheque postfechado se debe crear un nuevo documento en arccmd.
3) Si la forma de pago es deposito se genera el deposito en el modulo de bancos.

******************************/
  --
  cursor c_periodo_cxc(pcia     arincd.no_cia%type,
                       pcentro  arincd.centro%type)  is
     select ano_proce_cxc, mes_proce_cxc, semana_proce_cxc, dia_proceso_cxc
     from arincd
     where no_cia  = pcia
       and centro  = pcentro;
  --
  cursor c_documento is
     select m.centro,
            m.tipo_doc, m.no_docu, m.grupo, m.no_cliente,
            m.saldo, m.total_ref, m.fecha,
            m.m_original, m.no_docu_refe,
            m.ano ano_doc, m.mes mes_doc,
            td.formulario_ctrl, m.tot_imp,
            m.rowid rowid_md, m.tot_ret, m.moneda, m.tipo_cambio,
            m.sub_cliente, m.no_agente, m.ruta, m.ind_cobro, nvl(td.cks_dev,'N') cks_dev, m.fecha_vence, m.cobrador,
            m.origen, td.formulario, m.serie_fisico, m.no_fisico, m.fecha_documento, td.codigo_tipo_comprobante, td.factura
     from   Arccmd_Otros_Rec m, arcctd td
     where  m.no_cia    = pno_cia
       and  m.no_docu   = pno_docu
       and  m.estado    = 'P'
       and  m.no_cia    = td.no_cia
       and  m.tipo_doc  = td.tipo;
  --
  cursor c_referencias(pno_cia  varchar2,
                       pNo_docu  varchar2) is
    select r.tipo_refe, r.no_refe, r.monto, r.ano, r.mes, r.no_docu, r.tipo_doc
    from  arccrd r
    where r.no_cia  = pno_cia
      and r.no_docu = pno_docu;

  --- Verifica los dividendos aplicados manualmente en la pantalla de ingreso de cobros ANR 04/11/2009
  cursor C_div_manual (Lv_no_refe Varchar2) Is
   select nvl(sum(nvl(monto_refe,0)),0) monto_refe
   from   arccrd_dividendos_manual
   where  no_cia  = pno_cia
   and    no_docu = pno_docu
   and    no_refe = Lv_no_refe;

    --- Verifica las papeletas de deposito  ANR 22/07/2009
    Cursor C_Papeletas_Deposito Is
     select b.ref_fecha, b.valor, b.cod_bco_cia,
            b.campo_deposito, c.cuenta_contable, b.autorizacion,
            b.linea, b.id_forma_pago
     from   Arccfpagos_Or b, arccforma_pago c
     where  b.no_cia   = Pno_cia
     and    b.no_docu  = Pno_docu
     and    (nvl(c.papeleta,'N') = 'S'
     or      nvl(c.transferencia,'N') = 'S') --- Se anaden transferencias para que se generen al modulo de bancos ANR 12/02/2010
     and    nvl(c.ind_transito,'N') = 'N'  --- Agregado ANR 09/02/2010
     and    b.no_cia   = c.no_cia
     and    b.id_forma_pago = c.forma_pago;
     --- Depositos en transito no debe generar transaccion en bancos ANR 09/02/2010

    --- Verifica pagos con cheques postfechados  ANR 22/07/2009
    Cursor C_Cheques_postfechados Is
     select b.ref_cheque, b.valor, b.ref_fecha, b.linea, b.id_forma_pago
     from   Arccfpagos_Or b, arccforma_pago c
     where  b.no_cia   = Pno_cia
     and    b.no_docu  = Pno_docu
     and    nvl(c.ind_ck_postf,'N') = 'S'
     and    b.no_cia   = c.no_cia
     and    b.id_forma_pago = c.forma_pago;

  --
  -- Datos del tipo de documento
  cursor c_tipo_doc(pCia varchar2, pTipo_doc varchar2) is
    select td.tipo_mov, td.cks_dev,
           nvl(td.afecta_libro,'X'),
           nvl(td.factura,'N')
    from   arcctd td
    where td.no_cia = pCia
      and td.tipo   = pTipo_doc;

--Recupera el saldo actual del documento a actualizar IRQS 2003-02-14
 cursor c_saldo_doc(CV_NoDocu varchar2) is
      select saldo
      from Arccmd_Otros_Rec
      where no_cia =pno_cia
      and   no_docu = Cv_NoDocu;

--- Recupera el documento para cheques postfechados ANR 23/07/2009
 Cursor C_Tipo_Cheque_Postfechado Is
 select tipo, cod_diario
 from   arcctd
 where  no_cia = pno_cia
 and    tipo_mov = 'D'
 and    nvl(tipo_cheque,'N') = 'S';

 Cursor C_Dividendos_CxC Is
  Select no_cia, centrod, tipo_doc, no_factu, dividendo, valor, fecha_vence
  From   Arfadividendos
  Where  no_cia = pno_cia
  And    no_factu = pno_docu;

--- Se agrega validaciones para la retencion ANR 19/10/2009

Cursor C_Forma_Pago_retencion Is
 select nvl(sum(b.valor),0) valor
 from   arccforma_pago a, Arccfpagos_Or b
 where  a.no_cia     = pno_cia
 and    b.no_docu    = pno_docu
 and    nvl(a.retencion,'N') = 'S'
 and    a.no_cia     = b.no_cia
 and    a.forma_pago = b.id_forma_pago;

Cursor C_Total_retenciones Is
  select nvl(sum(monto),0) monto
  from   arccti
  where  no_cia   = pno_cia
  and    tipo_doc = ptipo_doc
  and    no_docu  = pno_docu
  and    nvl(ind_imp_ret,'X') = 'R';

Cursor C_Total_impuesto Is
  select nvl(sum(monto),0) monto
  from   arccti
  where  no_cia   = pno_cia
  and    tipo_doc = ptipo_doc
  and    no_docu  = pno_docu
  and    nvl(ind_imp_ret,'X') = 'I';

Cursor C_Div_comercial (Lv_grupo Varchar2, Lv_cliente Varchar2, Lv_subcliente Varchar2) Is
 select div_comercial
 from   arcclocales_clientes
 where  no_cia     = pno_cia
 and    grupo      = Lv_grupo
 and    no_cliente = Lv_cliente
 and    no_sub_cliente = Lv_subcliente;

 --- Se agrega validacion de cuenta contable que cuadre debe y haber y que se genere el asiento contable ANR 10/12/2009

  Cursor C_Existe_conta Is
    select 'X'
    from   Arccdc_Or
    where  no_cia  = pno_cia
    and    no_docu = pno_docu;

  Cursor C_Valida_conta Is
    select nvl(sum(decode(tipo,'C',monto)),0)-
           nvl(sum(decode(tipo,'D',monto)),0) dif
    from   Arccdc_Or
    where  no_cia  = pno_cia
    and    no_docu = pno_docu;

  r                            c_documento%rowtype;
  vnumero_ctrl                 ARCCMD_OTROS_REC.numero_ctrl%type;
  Ln_saldo                     ARCCMD_OTROS_REC.saldo%type;
  Ln_docu                      arckmm.no_docu%type;
  vCta_cliente                 Arccdc_OR.codigo%type;
  Lv_Error                     Varchar2(500);
  vfound                       Boolean;
  vTipo_mov                    arcctd.tipo_mov%type;
  vcks_dev                     arcctd.cks_dev%type;
  vtot_ref                     number;
  vSaldo_doc                   ARCCMD_OTROS_REC.saldo%type;
  vano_proce_cxc               arincd.ano_proce_cxc%type;
  vmes_proce_cxc               arincd.mes_proce_cxc%type;
  vsemana_proce_cxc            arincd.mes_proce_cxc%type;
  vdia_proceso_cxc             arincd.dia_proceso_cxc%type;
  --
  vcod_Estado                  arccte.cod_estado%TYPE;
  vLibro                       arcctd.Afecta_Libro%Type;
  vFactura                     arcctd.factura%type;
  td_cxc                       arcctd.tipo%type;
  vDiario                      arcctd.cod_diario%type;
  no_cxc_p                     ARCCMD_OTROS_REC.no_docu%type;
  rcta                          arccctd%rowtype;

  Ln_total_fpago_retencion     Arccti.monto%type := 0;
  Ln_total_retenciones         Arccti.monto%type := 0;
  Ln_total_impuestos           Arccti.monto%type := 0;

  Lv_resultado                 Varchar2(1);

  Lv_division                  Arfa_div_comercial.division%type;

  Ln_monto_refe                Arccrd_Dividendos_Manual.Monto_Refe%type;

  error_proceso                EXCEPTION;

  Lv_dummy                     Varchar2(1);
  Ln_dif                       Number;

  Lv_cc                        Arcgceco.centro%type;
  Lv_centro_costo              Arcgceco.centro%type;
  lv_programa                  varchar2(15):='CCACTUALIZA_OR-';

-- PL/SQL Block
Begin
  --
  pError      := Null;
  --
  Open c_documento;
  Fetch c_documento into r;
  vFound := nvl(c_documento%found, false);
  Close c_documento;

  If not vFound Then
     pError := 'No se localiza en CxC, el documento para actualizar ('||pno_docu||')';
     Raise error_proceso;
  End If;
  --

  --- Para todos los documentos debe validar que se haya generado el asiento contable, a excepcion
  --- de los documentos que vienen de facturacion que la contabilidad se genera desde el mismo
  --- modulo de facturacion ANR 10/12/2009

  If nvl(r.factura,'N') = 'N' Then

    Open C_Existe_conta;
    Fetch C_Existe_conta into Lv_dummy;
    If C_Existe_conta%notfound Then
     Close C_Existe_conta;
       pError := 'Es obligatorio el asiento contable, revisar el documento: '||pno_docu;
       Raise error_proceso;
    else
     Close C_Existe_conta;
    end if;

    Open C_Valida_conta;
    Fetch C_Valida_conta into Ln_dif;
    If C_Valida_conta%notfound Then
     Close C_Valida_conta;
    else
     Close C_Valida_conta;
    end if;

    If Ln_dif != 0 Then
       pError := 'Asiento contble descuadrado con: '||ln_dif||' , revisar el documento: '||pno_docu;
       Raise error_proceso;
    end if;

  end if;

  --- Valida las retenciones registradas ANR 19/10/2009

   Open C_Forma_Pago_retencion;
   Fetch C_Forma_Pago_retencion into Ln_total_fpago_retencion;
   Close C_Forma_Pago_retencion;

   Open C_Total_retenciones;
   Fetch C_Total_retenciones into Ln_total_retenciones;
   Close C_Total_retenciones;

   --- Si tiene forma de pago de retencion, quiere decir que debe tener registros en ARCCTI y en ARCCMD (TOT_RET)
   If Ln_total_fpago_retencion > 0 Then

    If Ln_total_fpago_retencion != Ln_total_retenciones Then
     pError := 'El total de forma de pago de retenciones: '||Ln_total_fpago_retencion||' debe ser igual al total de retenciones ingresadas por factura: '||Ln_total_retenciones||' para el documento: '||pno_docu;
     Raise error_proceso;
    end if;

    If Ln_total_retenciones != r.tot_ret Then
     pError := 'El total de retenciones registradas por factura: '||Ln_total_retenciones||' debe ser igual al total de retencion: '||r.tot_ret ||' registrada en el documento: '||pno_docu;
     Raise error_proceso;
    end if;

   end if;

   Open C_Total_impuesto;
   Fetch C_Total_impuesto into Ln_total_impuestos;
   Close C_Total_impuesto;

   --- Valido los impuestos registrados que sean los correctos ANR 19/10/2009

   If Ln_total_impuestos > 0 and r.tot_imp = 0 Then
     pError := 'El documento: '||pno_docu||' tiene registrado impuestos por: '||Ln_total_impuestos||' debe tener el mismo valor de impuestos: '||r.tot_imp ||' en el documento.';
     Raise error_proceso;
   elsif  Ln_total_impuestos = 0 and r.tot_imp > 0 Then
     pError := 'El documento: '||pno_docu||' no tiene registrado el detalle de impuestos, verifique por favor';
     Raise error_proceso;
   end if;

  open c_periodo_cxc(pno_cia, r.centro);
  fetch c_periodo_cxc into vano_proce_cxc, vmes_proce_cxc, vsemana_proce_cxc, vdia_proceso_cxc;
  close c_periodo_cxc;
  --
  If vano_proce_cxc is null or vmes_proce_cxc is null Then
     pError := 'Falta periodo en proceso de CxC para el centro: '||r.centro;
     Raise error_proceso;
  End if;
  -- --
  -- Actualiza el documento si su periodo es menor o igual al de proceso
  --
  If ( nvl(r.ano_doc, vano_proce_cxc) <= vano_proce_cxc And
       nvl(r.mes_doc, vmes_proce_cxc) <= vmes_proce_cxc ) Then
    --
    -- busca el tipo de movimiento del documento (D o C)
    vTipo_mov := Null;
    vcks_dev  := Null;
    open c_tipo_doc(pNo_cia, r.tipo_doc);
    fetch c_tipo_doc into vTipo_mov, vcks_dev, vLibro, vFactura;
    close c_tipo_doc;
    --
    if vTipo_mov is null then
       pError := 'TIPO DE MOVIMIENTO DEL DOCUMENTO: '||r.tipo_doc||', ES INCORRECTO ';
       RAISE error_proceso;
    end if;
    --
    IF vLibro = 'V' and vFactura = 'N' THEN
       -- registra la factura en el libro de ventas, si no es factura ya que
       -- facturacion se encarga de ello
       ccLibro_Ventas (pno_Cia, ptipo_doc, pno_docu, pError) ;
    END IF;

    --
    vSaldo_doc  := NULL;

    if vTipo_mov = 'C' then
       -- Aumenta los creditos del clientes
       update arccmc
          set  creditos   = nvl(creditos,0) + nvl(r.m_original,0),
               f_ult_pago = greatest(r.fecha,nvl(f_ult_pago,r.fecha))
          where no_cia     = pno_cia
            and grupo      = r.grupo
            and no_cliente = r.no_cliente;
    elsif vTipo_mov = 'D' then
       null;
    end if;
    --
    -- procesa referencias
    vtot_ref  := 0;
    for j in c_referencias(pno_cia, r.no_docu) loop

       open c_saldo_doc (j.no_refe) ;
       fetch c_saldo_doc into Ln_saldo;
       close c_saldo_doc;
       --Verifica el saldo antes de actualizar para no dejarlo en negativo
        if round(Ln_saldo,2) < j.monto then
         perror := 'ERROR: El saldo actual del documento :'|| j.no_refe ||', ('||Ln_Saldo||' <> '||j.monto||') es menor que la referencia a aplicar y no puede quedar negativo ' ;
         raise error_proceso;
        end if;

       --- Solo para documentos de ind. cobro se valida esta parte de registros manuales de dividendos ANR 04/11/2009

       If nvl(r.ind_cobro,'N') = 'S' Then

         --- verifica si concuerda las referencias con el total de dividendos referenciados ANR 04/11/2009
         Open C_div_manual (j.no_refe);
         Fetch C_div_manual into Ln_monto_refe;
         If C_div_manual%notfound then
          Close C_div_manual;
          Ln_monto_refe := 0;
         else
          Close C_div_manual;
         end if;

          if Ln_monto_refe != j.monto then
           perror := 'Para el documento: '||j.tipo_refe||' '||j.no_refe||' el total referenciado por dividendos: '||Ln_monto_refe||' debe ser igual al valor referenciado por documento:  '||j.monto;
           raise error_proceso;
          end if;

        end if;

       -- actualiza saldo del documento referenciado solo si el
       update ARCCMD_OTROS_REC
          set  saldo  = nvl(saldo,0) - nvl(j.monto,0),   ------ nvl(Ln_ret,0)
               ind_estado_vencido = decode(nvl(saldo,0) - nvl(j.monto,0),0,decode(ind_estado_vencido,'S','X'),ind_Estado_vencido),
               tstamp = sysdate
          where no_cia  = pno_cia
            and no_docu = j.no_refe;
       --
       vtot_ref := nvl(vtot_ref,0) + nvl(j.monto,0);

      --- Debe marcar como procesado ya que esto sirve para que estas referencias no sean modificadas
      --- a aplicacion ANR 05/08/2009

        Update ARCCRD
        set    ind_procesado = 'S',
               tstamp = sysdate
        where  no_cia     = pno_cia
        And    tipo_doc   = j.tipo_doc
        And    no_docu    = j.no_docu
        And    tipo_refe  = j.tipo_refe
        And    no_refe    = j.no_refe
        And    Ano        = j.ano
        And    mes        = j.mes;

       --
       -- registra estado final
       ccregistra_estado(pno_cia, j.no_refe, j.tipo_refe, 'F', vcod_Estado);
    end loop;
    --
    if nvl(r.total_ref,0) != nvl(vtot_ref,0) then
       perror := 'ERROR: El total referencia del documento no iguala al detalle en RD '||nvl(R.TOTAL_REF,0)||' tot '||VTOT_REF||' Cliente '||r.no_cliente;
       raise error_proceso;
    end if;
    -- ---
    -- Calcula el saldo que debe quedar en el documento, que en el caso
    -- de creditos, es negativo si no se aplica todo el monto
    if vTipo_mov = 'C' then
       vSaldo_doc := -(nvl(r.m_original, 0) - nvl(vtot_ref, 0));
    elsif vTipo_mov = 'D' then
       vSaldo_doc := nvl(r.saldo, 0);
    end if;
    if r.formulario_ctrl is null then
       vnumero_ctrl := NULL;
    else
       vnumero_ctrl := consecutivo.cc(pno_cia,r.ano_doc, r.mes_doc, NULL, r.tipo_doc, 'SECUENCIA');
    end if;

   ---- Generacion de dividendos ANR 12/08/2009

   If vtipo_mov = 'D' Then --- debo generar un dividendo cuando sean documentos de debito ANR 07/08/2009
   ---- para documentos de anulacion como no tienen fecha de vencimiento se agrega la misma fecha ANR 26/10/2009

       If vfactura = 'N' Then ---- para movimientos que son realizados en CxC
          null;

       elsif vfactura = 'S' Then
           --- Genera dividendos a CxC que proviene de facturacion

           For j in C_Dividendos_CxC Loop
             Begin
             Insert into arcc_dividendos (no_cia, centro, tipo_doc, no_docu, dividendo, valor, saldo, fecha_vence, valor_aplica)
                                  Values (j.no_cia, j.centrod, ptipo_doc, pno_docu, j.dividendo, j.valor, j.valor, j.fecha_vence,0);
             Exception
             When Others Then
                  pError := 'Error al crear dividendos que provienen de FACTURACION '||pno_docu||' Dividendo: '||j.dividendo||' '||sqlerrm;
                  RAISE error_proceso;
             End;
           End Loop;

       End if;

   End if;


    --- Actualiza el valor de los dividendos ANR 24/06/2009

    If nvl(r.ind_cobro,'N') = 'S' then

    --- Este proceso se aumento lo de referencias manuales ANR 04/11/2009

      CCACTUALIZA_DIVIDENDOS_MANUAL(pno_cia, r.no_docu,r.tipo_doc,vdia_proceso_cxc, pError);
      IF pError IS NOT NULL THEN
       Raise Error_Proceso;
      END IF;


    else


      CCACTUALIZA_DIVIDENDOS(pno_cia, r.no_docu,r.tipo_doc, vdia_proceso_cxc, pError);
      IF pError IS NOT NULL THEN
       Raise Error_Proceso;
      END IF;

    end if;


  --- Cuando sean documentos de cobro ANR 12/08/2009
  --- Debe hacer lo siguiente:
  /*Verificar si el cliente esta suspendido por vencimiento de
  facturas y el cobro se registra en el plazo adicional considerado por la
  compa?ia (7 dias, mantenimiento de compa?ias) el cliente debe ser
  activado. */

  If nvl(r.ind_cobro,'N') = 'S' then
   CCACCIONES_CLIENTES.CC_PABONO(pno_cia, r.centro,
                                 r.no_cliente, r.sub_cliente,
                                 r.grupo,r.no_docu,
                                 'AFACT', --- Se envia el id del motivo por concepto de abono de facturas
                                 Lv_resultado, --- Indica si se ejecuto la accion
                                 pError);

    IF pError IS NOT NULL THEN
     Raise Error_Proceso;
    END IF;

  End if;


  For i in C_Papeletas_Deposito Loop

--- Generar el deposito en el modulo de bancos por las papeletas de deposito registradas en el cobro ANR 21/07/2009

  Open C_Div_comercial (r.grupo, r.no_cliente, r.sub_cliente);
  Fetch C_Div_comercial into Lv_division;
   IF C_Div_comercial%notfound Then
    Close C_Div_comercial;
          perror := 'No existe division comercial para cliente: '||r.grupo||' '||r.no_cliente||' subcliente: '||r.sub_cliente;
          raise error_proceso;
   else
    Close C_Div_comercial;

    If Lv_division is null Then
          perror := 'Es obligatorio que tenga una division comercial configurada por cliente: '||r.grupo||' '||r.no_cliente||' subcliente: '||r.sub_cliente||' para poder procesar el deposito' ;
          raise error_proceso;
    end if;

   end if;

  GENERA_DEPOSITO_CC(pno_cia,
                     r.centro,
                     i.campo_deposito,
                     i.valor,
                     r.moneda,
                     i.cuenta_contable, --- Las cuentas contables de la forma de pago
                     i.autorizacion,
                     vdia_proceso_cxc, --- Se envia el dia de proceso de CxC ANR 23/07/2009
                     i.ref_fecha,
                     pno_docu, --- Numero de transaccion de CxC para agregarlo a la glosa
                     Lv_division,
                     user,
                     i.id_forma_pago,
                     Ln_docu,
                     Lv_Error);

       If Lv_Error is not null Then
        pError := Lv_Error;
        RAISE error_proceso;
       else
        update Arccfpagos_Or  ---- actualiza el detalle de forma de pago con el numero de transaccion de bancos
        set    no_docu_deposito = Ln_docu
        where  no_cia  = pno_cia
        and    no_docu = pno_docu
        and    linea   = i.linea
        and    id_forma_pago = i.id_forma_pago;
       end if;

  End Loop;

--- Generar el cheque a fecha como otra deuda ANR 23/07/2009

     -- Genera el documento en Cuentas x Cobrar con el mismo de no de factura

  For i in C_Cheques_Postfechados Loop

   Open C_Tipo_Cheque_Postfechado;
   Fetch C_Tipo_Cheque_Postfechado into td_cxc, vDiario;
    If C_Tipo_Cheque_Postfechado%notfound Then
    Close C_Tipo_Cheque_Postfechado;
       perror := 'No existe documento configurado en CxC para los cheques postfechados';
       raise error_proceso;
    else
    Close C_Tipo_Cheque_Postfechado;
    end if;

   no_cxc_p    := transa_id.cc(pno_cia);

     If nvl(r.tipo_cambio,0) = 0 Then
        r.tipo_cambio := 1;
     end if;

    Begin
     INSERT INTO ARCCMD_OTROS_REC(no_cia, centro, tipo_doc, periodo, ruta, no_docu,
                         grupo, no_cliente, moneda, fecha, fecha_vence,
                         fecha_documento,
                         m_original, descuento, saldo, tipo_venta,
                         gravado, exento, monto_bienes, monto_serv, monto_exportac,
                         no_agente, estado, tipo_cambio,
                         total_ref, total_db, total_cr, origen, ano, mes, semana,
                         no_fisico, serie_fisico, cod_diario, no_docu_refe, usuario, sub_cliente, tstamp,
                         detalle, fecha_vence_original, estado_cheque, cobrador, linea_forma_pago, id_forma_pago)
                 VALUES (pno_cia, r.centro, td_cxc, vano_proce_cxc, r.ruta, no_cxc_p,
                         r.grupo, r.no_cliente, r.moneda, vdia_proceso_cxc, i.ref_fecha,
                         i.ref_fecha,
                         i.valor, 0, i.valor, 'V',
                         0, i.valor, 0, 0, 0,
                         r.no_agente, 'P',  r.tipo_cambio,
                         0, i.valor, i.valor, 'CC', vano_proce_cxc, vmes_proce_cxc, vsemana_proce_cxc,
                         i.ref_cheque, '0', vDiario,pno_docu, user, r.sub_cliente, sysdate,
                         'CHEQUE POSTFECHADO GENERADO EN PROCESO DE COBRO. TRANS. COBRO: '||pno_docu, i.ref_fecha, 'D', r.cobrador, i.linea, i.id_forma_pago);

     Exception
     When Others Then
        perror := 'Error al crear deuda para cheque postfechado';
        raise error_proceso;
     end;

     IF not cclib.trae_cuentas_conta(pno_cia, r.grupo, td_cxc, r.moneda, rCta) then
      perror := 'No existe la cuenta de clientes para el documento: '|| td_cxc||
                 ' moneda '||r.moneda;
      Raise Error_proceso;
    End If;

     vCta_Cliente := rCta.cta_cliente;


          If cuenta_contable.acepta_cc (pno_cia, vCta_Cliente) THEN
            Lv_cc := CC_CCOSTO_SUBCLIENTE(pno_cia, r.grupo ,r.no_cliente, r.sub_cliente);
            If Lv_cc is null Then
              perror := 'El cliente: '||r.grupo||' '||r.no_cliente||' subcliente: '||r.sub_cliente||' no tiene configurado centro de costos';
              raise error_proceso;
            else
              Lv_centro_costo := Lv_cc;
             end if;
          else
             Lv_centro_costo := centro_costo.rellenad(pno_cia, '0');
          End if;

     --- El asiento contable del cheque postfechado es cliente contra cliente
     --- ANR 24/07/2009
     --- Crea la contabilizacion del documento cheque postfechado
     Begin
     Insert into Arccdc_OR (no_cia, centro, tipo_doc, periodo, ruta, no_docu,
                         grupo, no_cliente, codigo,
                         tipo, monto, monto_dol, tipo_cambio, moneda, ind_con,
                         centro_costo, modificable, monto_dc, glosa)
                  Values (pno_cia, r.centro, td_cxc, vano_proce_cxc, r.ruta, no_cxc_p,
                          r.grupo, r.no_cliente,   vCta_cliente,
                          'D',i.valor, i.valor/r.tipo_cambio,r.tipo_cambio, r.moneda, 'P',
                          Lv_centro_costo,'N',i.valor, r.no_cliente||' - '||td_cxc||' - '||i.ref_cheque||' TRANS. COBRO: '||pno_docu);

     Exception
     When Others Then
        perror := 'Error al crear asiento contable del cliente para el cheque postfechado';
        raise error_proceso;
     end;


     --- Crea la contabilizacion del documento cheque postfechado
     Begin
     Insert into Arccdc_OR (no_cia, centro, tipo_doc, periodo, ruta, no_docu,
                         grupo, no_cliente, codigo,
                         tipo, monto, monto_dol, tipo_cambio, moneda, ind_con,
                         centro_costo, modificable, monto_dc, glosa)
                  Values (pno_cia, r.centro, td_cxc, vano_proce_cxc, r.ruta, no_cxc_p,
                          r.grupo, r.no_cliente,   vCta_cliente,---i.cuenta_contable,
                          'C',i.valor, i.valor/r.tipo_cambio,r.tipo_cambio, r.moneda, 'P',
                          Lv_centro_costo,'N',i.valor,  r.no_cliente||' - '||td_cxc||' - '||i.ref_cheque||' TRANS. COBRO: '||pno_docu);

     Exception
     When Others Then
        perror := 'Error al crear asiento contable para el cheque postfechado';
        raise error_proceso;
     end;

     ccActualiza(pno_cia, td_cxc, no_cxc_p, Lv_Error);

     IF Lv_Error IS NOT NULL THEN
        pError := Lv_Error;
        RAISE error_proceso;
     END IF;

     end loop;

    -- Coloca como actualizado  el documento
      update ARCCMD_OTROS_REC
         set saldo        = nvl(vSaldo_doc, saldo),
             estado       = 'D',
             fecha_vence_original = fecha_vence,
             numero_ctrl  = vnumero_ctrl,
             tstamp = sysdate
       where no_cia  = pno_cia
         and no_docu = pno_docu;

    -- --
  -- --
  --  Traslada los impuestos al modulo de contabilidad para emision de
  --  libro de impuestos
  --
    pError := NULL;
-- sar CCTraslada_Impuestos(pNo_Cia, pno_docu, pError);
  IF pError IS NOT NULL THEN
     Raise Error_Proceso;
  END IF;
    --

  IF perror is not null  THEN
    RAISE error_proceso;
  END IF;

  end if;
EXCEPTION
  WHEN error_proceso THEN
     pError := lv_programa||nvl(pError, ': Error no descrito');
  WHEN consecutivo.error THEN
     pError := lv_programa||nvl( consecutivo.ultimo_error, ': Generando consecutivo');
  WHEN others THEN
     pError := lv_programa||nvl(sqlerrm, 'Exception en CC_ACTUALIZA_OR');
END ccactualiza_OR;