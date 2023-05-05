create or replace procedure            CCACTUALIZA_DIVIDENDOS_MANUAL(pv_no_cia   IN Varchar2,
                                                          pv_no_docu  IN Varchar2,
                                                          pv_tipo_doc IN Varchar2,
                                                          Pd_fecha    IN Date,
                                                          Pv_Error    OUT Varchar2) is

--- El proceso baja los dividendos de Cuentas por Cobrar ANR 24/06/2009

cursor c_referencias is
   Select tipo_refe, no_refe, monto
   from   arccrd
   where  no_cia    = pv_no_cia
   and    no_docu   = pv_no_docu
   and    tipo_doc  = pv_tipo_doc;

cursor c_referencias_dividendos (Lv_tipo_refe Varchar2, Lv_no_refe Varchar2) is
    select s.saldo, s.dividendo, r.tipo_refe, r.no_refe, s.valor, s.valor_aplica,
           nvl(r.monto_refe,0) monto_refe
    from  arccrd_dividendos_manual r, arcc_dividendos s
    where r.no_cia    = pv_no_cia
      and r.tipo_doc  = pv_tipo_doc
      and r.no_docu   = pv_no_docu
      and r.tipo_refe = Lv_tipo_refe
      and r.no_refe   = Lv_no_refe
      and nvl(r.monto_refe,0) > 0
      and r.no_cia    = s.no_cia
      and r.tipo_refe = s.tipo_doc
      and r.no_refe   = s.no_docu
      and r.dividendo = s.dividendo;

    Ln_total_referencias Arccrd_dividendos_manual.monto_refe%type;
    Ln_valor_aplica      Arccrd.monto%type;

    Error_Proceso Exception;

begin

   --- Puede darse el caso de que el valor asignado a las facturas sea menor al valor de las formas de pago
   --- en este caso siempre debo bajarme el valor de las facturas ANR 24/06/2009


   for h in C_referencias Loop

     If h.monto = 0 Then
       Pv_Error := 'Para el documento: '||pv_tipo_doc||' '||pv_no_docu||' el total de referencias no puede ser igual a cero';
       raise Error_Proceso;
     End if;

  Ln_total_referencias := 0;

   For i in C_referencias_dividendos (h.tipo_refe, h.no_refe) Loop

   If i.monto_refe is null Then
      Pv_Error := ' Documento: '||pv_tipo_doc||' '||pv_no_docu||' Referencias: '||i.tipo_refe||' '||i.no_refe||' '||i.dividendo||' no puede tener un valor de cero';
      raise Error_Proceso;
   end if;


     Update Arcc_dividendos
     Set    saldo = saldo - i.monto_refe,
            valor_aplica = valor_aplica + i.monto_refe,
            tstamp = sysdate
     Where  no_cia    = pv_no_cia
     And    tipo_doc  = i.tipo_refe
     And    no_docu   = i.no_refe
     And    dividendo = i.dividendo;

   --- Guardo la referencia de como bajo los dividendos
   Begin
   Insert into Arccrd_dividendos (no_cia, tipo_doc, no_docu, tipo_refe, no_refe, monto_refe, dividendo, fec_aplic) --- Se agrega fecha de aplicacion en base a la fecha de aplicacion de ARCCRD ANR 31/05/2010
                          Values (pv_no_cia, pv_tipo_doc, pv_no_docu, i.tipo_refe, i.no_refe, i.monto_refe, i.dividendo, Pd_fecha);
   Exception
   When Others Then
     Pv_Error := 'Error al crear referencia para dividendos (MANUAL). Documento: '||pv_tipo_doc||' '||pv_no_docu||' Referencias: '||i.tipo_refe||' '||i.no_refe||' '||i.dividendo||' Valor: '||i.monto_refe||' fecha aplic: '||to_char(Pd_fecha,'dd/mm/yyyy')||' '||sqlerrm;
     raise Error_Proceso;
   End;

    --- Verifico que el monto sea siempre igual al saldo mas el valor aplicado ANR 24/06/2009

    Ln_valor_aplica := i.saldo + i.valor_aplica;

    If i.valor != i.saldo + i.valor_aplica Then
     Pv_Error := 'Para el documento: '||i.tipo_refe||' '||i.no_refe||' Dividendo: '||i.dividendo||' el valor: '||i.valor||' debe ser igual al valor aplicado: '||Ln_valor_aplica;
    raise error_proceso;
    End if;

   Ln_total_referencias := Ln_total_referencias + i.monto_refe;

   End Loop;

     If Ln_total_referencias != h.monto Then
       Pv_Error := 'Para el documento: '||Pv_tipo_doc||' '||Pv_no_docu||' '||h.tipo_refe||' '||h.no_refe||'  el total de referencias por dividendo: '||Ln_total_referencias||' debe ser igual al total referenciado: '||h.monto;
       raise error_proceso;
     end if;

   End Loop;

EXCEPTION
  WHEN error_proceso THEN
     Pv_Error := nvl(Pv_Error, 'CCACTUALIZA_DIVIDENDOS_MANUAL');
  WHEN others THEN
     Pv_Error := nvl(sqlerrm, 'Exception en CCACTUALIZA_DIVIDENDOS_MANUAL');
end CCACTUALIZA_DIVIDENDOS_MANUAL;