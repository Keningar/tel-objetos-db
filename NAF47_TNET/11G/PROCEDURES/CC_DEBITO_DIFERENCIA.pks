create or replace procedure            CC_DEBITO_DIFERENCIA (Pv_cia            In Varchar2,
                                                  Pv_centro         In Varchar2,
                                                  Pv_secuencia_lote In Varchar2,
                                                  Pv_secuencia      In Varchar2,
                                                  Pv_no_docu        In Varchar2,
                                                  Pv_error          In Out Varchar2) Is

--Creado por : Fernando Espin M.
--05-11-2009
--Para crear la nota de debito cuando exista la diferencia entre lo reportado y lo recaudado en confirmacion de moviles.

Cursor C_detalle Is
 Select no_cia, centro, secuencia_lote, no_secuencia, no_linea, forma_pago, valor_linea, valor_confirmado, no_fisico, no_banco, no_cuenta_corriente,
        fecha_cheque, porcentaje, clave, base, secuencia_deposito, no_autorizacion, fecha_vigencia
    From arccdet_confirmacion
    Where no_cia = Pv_cia
      And centro = Pv_centro
      And secuencia_lote = Pv_secuencia_lote
      And no_secuencia = Pv_secuencia;

Cursor C_tipo_doc Is
 Select *
    From arcctd
    Where no_cia = Pv_cia
      And tipo_mov = 'D'
      And ind_difer_movil = 'S';

Cursor c_documento Is
   Select m.centro, m.tipo_doc, m.no_docu, m.grupo, m.no_cliente, m.saldo, m.total_ref, m.fecha,
          m.m_original, m.no_docu_refe, m.ano ano_doc, m.mes mes_doc,td.formulario_ctrl, m.tot_imp,
          m.rowid rowid_md, m.tot_ret, m.moneda, m.tipo_cambio,
          m.sub_cliente, m.no_agente, m.ruta, m.ind_cobro, nvl(td.cks_dev,'N') cks_dev, m.fecha_vence, m.cobrador,
          m.origen, td.formulario, m.serie_fisico, m.no_fisico, m.fecha_documento, td.codigo_tipo_comprobante
      From arccmd m, arcctd td
      Where m.no_cia   = Pv_cia
        And m.no_docu  = Pv_no_docu
        And m.estado   = 'P'
        And m.no_cia   = td.no_cia
        And m.tipo_doc = td.tipo;

Cursor c_periodo_cxc(pcia     arincd.no_cia%type,
                     pcentro  arincd.centro%type) Is
 Select ano_proce_cxc, mes_proce_cxc, semana_proce_cxc, dia_proceso_cxc
    From arincd
    Where no_cia  = pcia
      And centro  = pcentro;

Lb_Notfound                  Boolean;
Le_error                     Exception;
Lc_tipo                      C_tipo_doc%Rowtype;
Lv_no_docu                   arccmd.no_docu%Type;
r                            c_documento%rowtype;
Ln_diferencia                Number:=0;
vano_proce_cxc               arincd.ano_proce_cxc%type;
vmes_proce_cxc               arincd.mes_proce_cxc%type;
vsemana_proce_cxc            arincd.mes_proce_cxc%type;
vdia_proceso_cxc             arincd.dia_proceso_cxc%type;
rcta       		               arccctd%rowtype;
vCta_cliente                 arccdc.codigo%type;
Lv_Error                     Varchar2(500):=Null;

Begin
    For i in C_detalle Loop
    ---
       If nvl(i.valor_confirmado,0) > 0 Then
       ---
         If nvl(i.valor_confirmado,0) != nvl(i.valor_linea,0) Then
           ---
           If nvl(i.valor_confirmado,0) > nvl(i.valor_linea,0) Then
             Ln_diferencia := nvl(i.valor_confirmado,0) - nvl(i.valor_linea,0);
           Else
             Ln_diferencia := nvl(i.valor_linea,0) - nvl(i.valor_confirmado,0);
           End If;
           ---
           Open c_documento;
           Fetch c_documento into r;
           Close c_documento;
           ---
           open c_periodo_cxc(Pv_cia, r.centro);
           fetch c_periodo_cxc into vano_proce_cxc, vmes_proce_cxc, vsemana_proce_cxc, vdia_proceso_cxc;
           close c_periodo_cxc;
           ---
           Open C_tipo_doc;
           Fetch C_tipo_doc Into Lc_tipo;
           Lb_Notfound := C_tipo_doc%Notfound;
           Close C_tipo_doc;
           ---
           If Lb_Notfound Then
             Pv_error := 'No existe documento configurado en CxC para la diferencia de valores en confirmacion de moviles, Favor revisar';
             Raise Le_error;
           End If;
           ---
           Lv_no_docu  := transa_id.cc(Pv_cia);
           ---
           If nvl(r.tipo_cambio,0) = 0 Then
              r.tipo_cambio := 1;
           End if;

           Begin
             INSERT INTO arccmd(no_cia,            centro,        tipo_doc,        periodo,              ruta,              no_docu,
                                grupo,             no_cliente,    moneda,          fecha,                fecha_vence,       fecha_documento,
                                m_original,        descuento,     saldo,           tipo_venta,           gravado,           exento,
                                monto_bienes,      monto_serv,    monto_exportac,  no_agente,            estado,            tipo_cambio,
                                total_ref,         total_db,      total_cr,        origen,               ano,               mes,
                                semana,            no_fisico,     serie_fisico,    cod_diario,           no_docu_refe,      usuario,
                                sub_cliente,       tstamp,        detalle,         fecha_vence_original, estado_cheque,     cobrador,
                                linea_forma_pago,  id_forma_pago)
                        VALUES (Pv_cia,            r.centro,      Lc_tipo.tipo,    vano_proce_cxc,       r.ruta,            Lv_no_docu,
                                r.grupo,           r.no_cliente,  r.moneda,        vdia_proceso_cxc,     i.fecha_vigencia,  i.fecha_vigencia,
                                i.valor_linea,     0,             Ln_diferencia,   'V',                  0,                 Ln_diferencia,
                                0,                 0,             0,               r.no_agente,          'P',               r.tipo_cambio,
                                0,                 Ln_diferencia, Ln_diferencia,   'CC',                 vano_proce_cxc,    vmes_proce_cxc,
                                vsemana_proce_cxc, i.fecha_cheque,  '0',             Lc_tipo.Cod_Diario, Pv_no_docu,        user,
                                r.sub_cliente,     sysdate,       'NOTA DE DEBITO GENERADA POR LA DIFERENCIA DE VALORES DEL COBRO: '||Pv_no_docu,
                                i.fecha_vigencia,    'D',           r.cobrador,      i.no_linea,              i.forma_pago);

           Exception
               When Others Then
                  Pv_error := 'Error al crear deuda para cheque postfechado';
                  raise Le_error;
           End;

           If not cclib.trae_cuentas_conta(Pv_cia, r.grupo, Lc_tipo.tipo, r.moneda, rCta) then
             Pv_error := 'No existe la cuenta de clientes para el documento: '|| Lc_tipo.tipo||' moneda '||r.moneda;
             Raise Le_error;
           End If;

           vCta_Cliente := rCta.cta_cliente;

          Begin
            Insert into ARCCDC (no_cia,        centro,          tipo_doc,         periodo,        ruta,          no_docu,
                                grupo,         no_cliente,      codigo,           tipo,           monto,         monto_dol,
                                tipo_cambio,   moneda,          ind_con,          centro_costo,   modificable,   monto_dc,
                                glosa)
                        Values (Pv_cia,        r.centro,        Lc_tipo.tipo,     vano_proce_cxc, r.ruta,        Lv_no_docu,
                                r.grupo,       r.no_cliente,    vCta_cliente,     'D',            Ln_diferencia, Ln_diferencia/r.tipo_cambio,
                                r.tipo_cambio, r.moneda,        'P',              '000000000',    'N',           Ln_diferencia,
                                r.no_cliente||' - '||Lc_tipo.tipo||' -  DOC: '||Pv_no_docu);
          Exception
            When Others Then
              Pv_error := 'Error al crear asiento contable del cliente para la nota de debito';
              Raise Le_error;
          End;

          Begin
            Insert into ARCCDC (no_cia,        centro,          tipo_doc,          periodo,        ruta,          no_docu,
                               grupo,          no_cliente,      codigo,            tipo,           monto,         monto_dol,
                               tipo_cambio,    moneda,          ind_con,           centro_costo,   modificable,   monto_dc,
                               glosa)
                       Values (Pv_cia,         r.centro,        Lc_tipo.tipo,      vano_proce_cxc, r.ruta,        Lv_no_docu,
                               r.grupo,        r.no_cliente,    vCta_cliente,      'C',            Ln_diferencia, Ln_diferencia/r.tipo_cambio,
                               r.tipo_cambio,  r.moneda,        'P',               '000000000',    'N',           Ln_diferencia,
                               r.no_cliente||' - '||Lc_tipo.tipo||' -  DOC: '||Pv_no_docu);
          Exception
            When Others Then
              Pv_error := 'Error al crear asiento contable del cliente para la nota de debito';
              Raise Le_error;
          End;

          ccActualiza(Pv_cia, Lc_tipo.tipo, Lv_no_docu, Lv_Error);

          If Lv_Error Is Not Null Then
             Pv_error := Lv_Error;
             Raise Le_error;
          End If;
          ---
        End If;
        ---
    End If;
    ---
    End Loop;
Exception
  When Le_error Then
    Pv_error := Pv_error;
End CC_DEBITO_DIFERENCIA;