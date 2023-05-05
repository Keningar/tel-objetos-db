create or replace procedure            CCPRORRATEA_FP_FACT(pv_no_cia    IN  Varchar2,
                                                pv_no_docu   IN  Varchar2,
                                                pv_tipo_doc  IN  Varchar2,
                                                Pv_Error     OUT Varchar2) is

cursor c_total_fac is
  Select nvl(sum(nvl(monto,0)),0)
  From   arccrd
  Where  no_cia   = pv_no_cia
  And    tipo_doc = pv_tipo_doc
  And    no_docu  = pv_no_docu;

cursor c_total_fac_div is
  Select nvl(sum(nvl(monto_refe,0)),0)
  From   arccrd_dividendos
  Where  no_cia   = pv_no_cia
  And    tipo_doc = pv_tipo_doc
  And    no_docu  = pv_no_docu;

cursor c_facturas_dividendos Is
  Select nvl(a.saldo_prorrateado,0) saldo_prorrateado, a.monto_refe, a.dividendo,
         a.no_refe, a.tipo_refe, a.fec_aplic
  From   arccrd_dividendos a, arccmd b
  Where  a.no_cia   = pv_no_cia
  And    a.tipo_doc = pv_tipo_doc
  And    a.no_docu  = pv_no_docu
  And    nvl(a.saldo_prorrateado,0) > 0
  And    a.no_cia = b.no_cia
  And    a.no_refe = b.no_docu
order by b.fecha_vence,b.no_docu , a.dividendo; --- ordena por fecha vence de factura ANR 09/04/2010 y por no factu y dividendo


cursor C_fact_retenciones Is
  Select sum(b.monto) monto_retenido, a.no_refe, a.tipo_refe, b.no_refe no_docu_refe, a.fecha_vence, a.fec_aplic
  From   arccrd a, arccti b
  Where  a.no_cia   = pv_no_cia
  And    a.tipo_doc = pv_tipo_doc
  And    a.no_docu  = pv_no_docu
  And    a.no_cia   = b.no_cia
  And    a.no_docu  = b.no_docu
  And    a.no_refe  = b.no_refe
  group by a.no_refe, a.tipo_refe, b.no_refe, a.fecha_vence, a.fec_aplic
  order by a.fecha_vence; --- ordena por fecha vence de factura ANR 09/04/2010


cursor c_pagos_ret (Ln_valor Number) is
    select b.linea, b.id_forma_pago
    from   arccfpagos b, arccforma_pago c
    where  b.no_cia   = pv_no_cia
    and    b.no_docu  = pv_no_docu
    and    b.no_cia   = c.no_cia
    and    b.id_forma_pago = c.forma_pago
    and    b.valor = Ln_valor
    and   nvl(b.valor_prorrateado,0) > 0
    and    nvl(c.retencion,'N') = 'S';

cursor c_pagos_ret_fp is
    select b.linea, b.id_forma_pago
    from   arccfpagos b, arccforma_pago c
    where  b.no_cia   = pv_no_cia
    and    b.no_docu  = pv_no_docu
    and    b.no_cia   = c.no_cia
    and    b.id_forma_pago = c.forma_pago
    and    nvl(c.retencion,'N') = 'S';

cursor c_total_ret is
    select count(*)
    from   arccfpagos b, arccforma_pago c
    where  b.no_cia   = pv_no_cia
    and    b.no_docu  = pv_no_docu
    and    b.no_cia   = c.no_cia
    and    b.id_forma_pago = c.forma_pago
    and    nvl(c.retencion,'N') = 'S';

cursor c_total_retenciones is
 select nvl(sum(nvl(valor_aplicado,0)),0)
 from   arccdetfpagos
 where  no_cia        = pv_no_cia
 and    no_docu       = pv_no_docu
 and    id_forma_pago in
                       (select forma_pago
                          from arccforma_pago
                         where no_cia = pv_no_cia
                           and nvl(retencion,'N') = 'S');


--- Devuelvo el dividendo al que aplica

cursor C_Verif_Div_fact_retenciones (Lv_tipo_refe Varchar2, Lv_no_refe Varchar2) Is
  Select a.dividendo
  From   arccrd_dividendos a, arccti b, arccmd c
  Where  a.no_cia   = pv_no_cia
  And    a.tipo_doc = pv_tipo_doc
  And    a.no_docu  = pv_no_docu
  And    a.tipo_refe = Lv_tipo_refe
  And    a.no_refe   = Lv_no_refe
  And    nvl(a.saldo_prorrateado,0) > 0
  And    a.no_cia   = b.no_cia
  And    a.no_docu  = b.no_docu
  And    a.no_refe  = b.no_refe
  And    a.no_cia = c.no_cia
  And    a.no_refe = c.no_docu
  order by c.fecha_vence,c.no_docu, a.dividendo; --- ordena por fecha vence de factura ANR 09/04/2010, IRQS 09/04/2010


cursor c_pagos is  ---- Prorratea en orden de prioridad todas las formas de pago excepto las retenciones
    select b.linea, b.id_forma_pago
    from   arccfpagos b, arccforma_pago c
    where  b.no_cia   = pv_no_cia
    and    b.no_docu  = pv_no_docu
    and    b.no_cia   = c.no_cia
    and    b.id_forma_pago = c.forma_pago
    and    nvl(c.retencion,'N') = 'N'
    and   nvl(b.valor_prorrateado,0) > 0
    order by c.prioridad, b.ref_fecha; -- forma de pago se ordena por prioridad y fecha de cheque ANR 09/04/2010

Cursor C_Pagos_Valor (Lv_forma_pago Varchar2, Ln_linea Number) Is
    select nvl(b.valor_prorrateado,0) valor_prorrateado
    from   arccfpagos b, arccforma_pago c
    where  b.no_cia   = pv_no_cia
    and    b.no_docu  = pv_no_docu
    and    b.no_cia   = c.no_cia
    and    b.id_forma_pago = c.forma_pago
    and    b.id_forma_pago = lv_forma_pago
    and    b.linea = ln_linea
    and    nvl(c.retencion,'N') = 'N'
    and   nvl(b.valor_prorrateado,0) > 0;


cursor c_total_pagos is
    select count(*)
    from   arccfpagos b, arccforma_pago c
    where  b.no_cia   = pv_no_cia
    and    b.no_docu  = pv_no_docu
    and    b.no_cia   = c.no_cia
    and    b.id_forma_pago = c.forma_pago
    and    nvl(b.prorrateado,'N') = 'N'
    and    nvl(c.retencion,'N') = 'N';

  Ln_valor         Number      := 0;
  Ln_total_fac     Number      := 0;
  Ln_total_fac_div Number      := 0;

  Ln_total_pagos       Number := 0;
  Ln_valor_ret         Number := 0;

  Ln_total_retenciones Number := 0;

  Lv_forma_pago        Arccdetfpagos.id_forma_pago%type;

  Ln_linea             Arccfpagos.linea%type;
  Lv_id_forma_pago     Arccfpagos.id_forma_pago%type;

  Ln_total_pago_ret    Number;

  Ln_valor_prorrateado Arccdetfpagos.valor_aplicado%type;

  Ln_dividendo         Arccrd_dividendos.dividendo%type;

  Error_proceso        Exception;

  --- Proceso para prorratear las formas de pago con los dividendos de las facturas que se encuentran en un cobro ANR 30/07/2009
  --- Hay que tomar en cuenta lo siguiente:
  --- Si hay retenciones con facturas que se cancelan en el mismo cobro debo guardar el valor retenido con esa factura y dividendo.
  --- si hay retenciones y la factura que se cancela es otra, debo guardar un dividendo con saldo, para tener una referencia
  --- Debo prorratear todas las formas de pago en orden de prioridad sin tomar en cuenta las retenciones, ya que las retenciones se
  --- asignan para cada factura en especifico

  Begin

  Open c_total_fac;   --- total de referencias (facturas)
  Fetch c_total_fac into Ln_total_fac;
  Close c_total_fac;

  Open c_total_fac_div; ---- total de referencias con dividendos (facturas con dividendos)
  Fetch c_total_fac_div into Ln_total_fac_div;
  Close c_total_fac_div;

  If Ln_total_fac != Ln_total_fac_div Then --- esto debe estar cuadrado, si no es problema de cc_actualiza_dividendos
     Pv_Error := 'El total de facturas referenciadas: '||Ln_total_fac||' es diferente al total referenciado de facturas con sus dividendos: '||Ln_total_fac_div;
     raise Error_Proceso;
  End if;

            --- Inicializo valores

            Update Arccrd_dividendos
            Set    saldo_prorrateado = monto_refe
            Where  no_cia = pv_no_cia
            and    no_docu = pv_no_docu;

            Update Arccfpagos
            Set    valor_prorrateado = valor
            Where  no_cia = pv_no_cia
            and    no_docu = pv_no_docu;


  ---- Las retenciones no se prorratean, se asignan a la factura y al dividendo que se este cancelando.

      For i in C_fact_retenciones loop
        --- cuantos dividendos asignados a esa factura
       Open C_Verif_Div_fact_retenciones (i.tipo_refe, i.no_refe);
       Fetch C_Verif_Div_fact_retenciones into Ln_dividendo;
       If C_Verif_Div_fact_retenciones%notfound Then
       Close C_Verif_Div_fact_retenciones;
       else
       Close C_Verif_Div_fact_retenciones;
       end if;

          --- Aplico el valor de retencion a un solo dividendo
          Ln_valor_ret := i.monto_retenido;


        If NVL(Ln_valor_ret,0) > 0 Then ---- solo valores mayores o igual a cero graba en la tabla de prorrateo

           Open c_total_ret;
           Fetch c_total_ret into Ln_total_pago_ret;
           Close c_total_ret;

           If Ln_total_pago_ret > 1 Then

               ---  una forma de pago de retencion con un ingreso igual en arccti

               Open C_pagos_ret (i.monto_retenido);
               Fetch C_Pagos_ret into Ln_linea, Lv_id_forma_pago;
               Close C_Pagos_ret;

           elsif Ln_total_pago_ret = 1 Then

               --- un registro de retencion de forma de pago contra varias arccti
               Open C_pagos_ret_fp;
               Fetch C_Pagos_ret_fp into Ln_linea, Lv_id_forma_pago;
               Close C_Pagos_ret_fp;

           end if;


          Begin
            Insert into ARCCDETFPAGOS (no_cia, no_docu, id_forma_pago, linea_refe, no_refe, no_div, valor_aplicado, USUARIO_CREA, TSTAMP)
                               Values (Pv_no_cia, pv_no_docu, Lv_id_forma_pago, Ln_linea, i.no_refe, Ln_dividendo, Ln_valor_ret, user, sysdate);

            Exception
            When Dup_val_on_index Then
              Update arccdetfpagos
              set    valor_aplicado = valor_aplicado + Ln_valor_ret,
                     tstamp         = sysdate
              where  no_cia         = Pv_no_cia
              and    no_docu        = Pv_no_docu
              and    id_forma_pago  = Lv_id_forma_pago
              and    linea_refe     = Ln_linea
              and    no_refe        = i.no_refe
              and    no_div         = Ln_dividendo;
            When Others Then
              Pv_Error := 'Error al prorratear facturas y dividendos con retenciones: Cobro:'||pv_no_docu||' F. Pago: '||Lv_id_forma_pago||' Linea F. Pago: '||Ln_linea||' Refe: '||i.no_refe||' Div: '||Ln_dividendo||' '||sqlerrm;
              raise Error_Proceso;
          End;

            Update Arccrd_dividendos
            Set    saldo_prorrateado = nvl(saldo_prorrateado,0) - Ln_valor_ret
            Where  no_cia = pv_no_cia
            and    no_docu = pv_no_docu
            and    no_refe = i.no_refe
            and    dividendo = Ln_dividendo
            and    fec_aplic = i.fec_aplic; --- Es parte de la clave primaria ANR 31/05/2010

            Update Arccfpagos
            Set    valor_prorrateado = nvl(valor_prorrateado,0) - Ln_valor_ret
            Where  no_cia = pv_no_cia
            and    no_docu = pv_no_docu
            and    id_forma_pago = Lv_id_forma_pago
            and    linea = Ln_linea;

         End if;

    End Loop;

    --- NO va a existir el caso de que se ingresen retenciones para otras facturas en el mismo cobro, por eso se pone comentario ANR 07/08/2009
    ---- Puede darse el caso de retenciones que no esten atadas a facturas en el mismo cobro, para este caso le asigno a un
    ---- dividendo que tenga saldo


  Open c_total_pagos;
  Fetch c_total_pagos into Ln_total_pagos;
  Close c_total_pagos;

  Open c_total_retenciones;
  Fetch c_total_retenciones into Ln_total_retenciones;
  Close c_total_retenciones;

   --- el total de referencias con dividendos menos el total de retenciones, para no considerar las retenciones en el total


 For i in C_Pagos Loop

  Open C_Pagos_Valor (i.id_forma_pago,i.linea);
  Fetch C_Pagos_Valor into Ln_valor_prorrateado;
  If C_Pagos_Valor%notfound Then
  Ln_valor_prorrateado := 0;
    close C_Pagos_Valor;
  else
    close C_Pagos_Valor;
  end if;

     If Ln_valor_prorrateado = 0  Then
       Exit;
     End if;

     for j in c_facturas_dividendos Loop

            Open C_Pagos_Valor (i.id_forma_pago,i.linea);
            Fetch C_Pagos_Valor into Ln_valor_prorrateado;
            If C_Pagos_Valor%notfound Then
            Ln_valor_prorrateado := 0;
              close C_Pagos_Valor;
            else
              close C_Pagos_Valor;
            end if;

                If Ln_valor_prorrateado = 0  Then
                  Exit;
                End if;

                      If Ln_valor_prorrateado <= j.saldo_prorrateado Then
                         Ln_valor := Ln_valor_prorrateado;
                      else
                         Ln_valor := j.saldo_prorrateado;
                      end if;

                      If Ln_valor > 0 Then

                      Begin
                        Insert into ARCCDETFPAGOS (no_cia, no_docu, id_forma_pago, linea_refe, no_refe, no_div, valor_aplicado, USUARIO_CREA, TSTAMP)
                                           Values (Pv_no_cia, pv_no_docu, i.id_forma_pago, i.linea, j.no_refe, j.dividendo, Ln_valor, user, sysdate);

                        Exception
                        When Dup_val_on_index Then
                          Update arccdetfpagos
                          set    valor_aplicado = valor_aplicado + Ln_valor,
                                 tstamp         = sysdate
                          where  no_cia         = Pv_no_cia
                          and    no_docu        = Pv_no_docu
                          and    id_forma_pago  = i.id_forma_pago
                          and    linea_refe     = i.linea
                          and    no_refe        = j.no_refe
                          and    no_div         = j.dividendo;
                        When Others Then
                          Pv_Error := 'Error al prorratear facturas y dividendos con retenciones: Cobro:'||pv_no_docu||' F. Pago: '||Lv_id_forma_pago||' Linea F. Pago: '||Ln_linea||' Refe: '||j.no_refe||' Div: '||j.dividendo||' '||sqlerrm;
                          raise Error_Proceso;
                      End;


                      Update Arccrd_dividendos
                      Set    saldo_prorrateado = nvl(saldo_prorrateado,0) - Ln_valor
                      Where  no_cia = pv_no_cia
                      and    no_docu = pv_no_docu
                      and    no_refe = j.no_refe
                      and    dividendo = j.dividendo
                      and    fec_aplic = j.fec_aplic; --- Es parte de la clave primaria ANR 31/05/2010

                      Update Arccfpagos
                      Set    valor_prorrateado = nvl(valor_prorrateado,0) - Ln_valor
                      Where  no_cia = pv_no_cia
                      and    no_docu = pv_no_docu
                      and    id_forma_pago = i.id_forma_pago
                      and    linea = i.linea;


                      End if;

       End Loop;

 End Loop;

EXCEPTION
  WHEN error_proceso THEN
     Pv_Error := nvl(Pv_Error, 'CCPRORRATEA_FP_FACT');
  WHEN others THEN
     Pv_Error := nvl(sqlerrm, 'Exception en CCPRORRATEA_FP_FACT');
end CCPRORRATEA_FP_FACT;