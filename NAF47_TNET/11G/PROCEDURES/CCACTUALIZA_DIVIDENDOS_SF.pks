create or replace procedure            CCACTUALIZA_DIVIDENDOS_SF(pv_no_cia    IN  Varchar2,
                                                      pv_no_docu   IN  Varchar2,
                                                      pv_tipo_doc  IN  Varchar2,
                                                      pv_tipo_refe IN  Varchar2,
                                                      pv_no_refe   IN  Varchar2,
                                                      pn_valor     IN  Number,
                                                      Pd_fecha     IN  Date,
                                                      Pv_Error     OUT Varchar2) is

--- El proceso baja los dividendos de Cuentas por Cobrar
--- Este proceso se debe utilizar para rebajar los saldos a favor de los dividendos
--- ANR 24/06/2009

cursor c_referencias is
   Select tipo_refe, no_refe
   from   arccrd
   where  no_cia    = pv_no_cia
   and    no_docu   = pv_no_docu
   and    tipo_doc  = pv_tipo_doc
   and    tipo_refe = Pv_tipo_refe
   and    no_refe   = Pv_no_refe
   and    ind_procesado = 'N'; --- solo los que no estan procesados ANR 31/05/2010

cursor c_referencias_dividendos is
    select s.saldo, s.dividendo, r.tipo_refe, r.no_refe, s.valor, s.valor_aplica
    from  arccrd r, arcc_dividendos s
    where r.no_cia    = pv_no_cia
      and r.tipo_doc  = pv_tipo_doc
      and r.no_docu   = pv_no_docu
      and r.tipo_refe = Pv_tipo_refe
      and r.no_refe   = Pv_no_refe
      and r.no_cia    = s.no_cia
      and r.tipo_refe = s.tipo_doc
      and r.no_refe   = s.no_docu
      and s.saldo > 0
      and r.ind_procesado = 'N' --- solo los que no estan procesados ANR 31/05/2010
      Order by r.no_refe, s.dividendo;

    Ln_residuo    number := 0;
    Ln_valor      number := 0;

    Error_Proceso Exception;


begin

   --- Puede darse el caso de que el valor asignado a las facturas sea menor al valor de las formas de pago
   --- en este caso siempre debo bajarme el valor de las facturas ANR 24/06/2009

   for h in C_referencias Loop

     If Pn_valor = 0 Then
       Pv_Error := 'Para el documento: '||pv_tipo_doc||' '||pv_no_docu||' el total de referencias no puede ser igual a cero';
       raise Error_Proceso;
     End if;

       Ln_residuo := Pn_valor;

        For i in C_referencias_dividendos Loop

           If Ln_residuo > 0 Then --- Se actualiza el saldo solamente cuando exista un valor para bajarse del saldo

           If Ln_residuo <= i.saldo Then
              Ln_valor := Ln_residuo;
           else
              Ln_valor := i.saldo;
           end if;

         Update Arcc_dividendos
         Set    saldo = saldo - Ln_valor,
                valor_aplica = valor_aplica + Ln_valor,
                tstamp = sysdate
         Where  no_cia    = pv_no_cia
         And    tipo_doc  = i.tipo_refe
         And    no_docu   = i.no_refe
         And    dividendo = i.dividendo; --- Me bajo el valor del dividendo en orden de antiguedad

       --- Guardo la referencia de como bajo los dividendos
       Begin
       Insert into Arccrd_dividendos (no_cia, tipo_doc, no_docu, tipo_refe, no_refe, monto_refe, dividendo, fec_aplic) --- Se agrega fecha de aplicacion en base a la fecha de aplicacion de ARCCRD ANR 31/05/2010
                              Values (pv_no_cia, pv_tipo_doc, pv_no_docu, i.tipo_refe, i.no_refe, Ln_valor, i.dividendo, Pd_fecha);
       Exception
       When Others Then
         Pv_Error := 'Error al crear referencia para dividendos (SF). Cia: '||pv_no_cia||' Documento: '||pv_tipo_doc||' '||pv_no_docu||' Referencias: '||i.tipo_refe||' '||i.no_refe||' '||i.dividendo||' Valor: '||Ln_valor||' fecha aplic: '||to_char(Pd_fecha,'dd/mm/yyyy')||' '||sqlerrm;
           raise Error_Proceso;
       End;


        --- Verifico que el monto sea siempre igual al saldo mas el valor aplicado ANR 24/06/2009

        If i.valor != i.saldo + i.valor_aplica Then
         Pv_Error := 'Para el documento: '||i.tipo_refe||' '||i.no_refe||' Dividendo: '||i.dividendo||' el valor: '||i.valor||' debe ser igual al valor aplicado: '||i.saldo + i.valor_aplica;
        raise error_proceso;
        End if;

       Ln_residuo := Ln_residuo - Ln_valor;

       If Ln_residuo = 0 Then
          exit;
       end if;

       End if;

       End Loop;

   End Loop;

EXCEPTION
  WHEN error_proceso THEN
     Pv_Error := nvl(Pv_Error, 'CCACTUALIZA_DIVIDENDOS_SF');
  WHEN others THEN
     Pv_Error := nvl(sqlerrm, 'Exception en CCACTUALIZA_DIVIDENDOS_SF');
end CCACTUALIZA_DIVIDENDOS_SF;