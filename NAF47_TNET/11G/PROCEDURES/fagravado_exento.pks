create or replace procedure            fagravado_exento(pv_cia      IN  Varchar2,
                                             pv_factu    IN  Varchar2,
                                             pv_tipo_doc IN  Varchar2,
                                             pv_Error    OUT Varchar2) is

--- Actualiza los campos gravado, exento, descuento gravado y descuento exento de ARFAFE
--- ANR 08/09/2009

  Cursor C_Gravado Is
   select abs(nvl(sum(a.total),0)) - abs(nvl(sum(a.descuento),0)) base_gravada,
          abs(nvl(sum(a.descuento),0)) descuento_gravado
   from   arfafl a, arfafe b
   where  a.no_cia         = Pv_cia
   and    a.no_factu       = Pv_factu
   and    nvl(a.i_ven,'N') = 'S'
   and    a.no_cia         = b.no_cia
   and    a.no_factu       = b.no_factu;

  Cursor C_Exento Is
   select abs(nvl(sum(a.total),0)) - abs(nvl(sum(a.descuento),0)) base_exenta,
          abs(nvl(sum(a.descuento),0)) descuento_exento
   from   arfafl a, arfafe b
   where  a.no_cia         = Pv_cia
   and    a.no_factu       = Pv_factu
   and    nvl(a.i_ven,'N') = 'N'
   and    a.no_cia         = b.no_cia
   and    a.no_factu       = b.no_factu;

  Cursor C_Tipo_Doc Is
   select ind_fac_dev
   from   arfact
   where  no_cia = Pv_cia
   and    tipo   = Pv_tipo_doc;

  Cursor C_Factu Is
   Select abs(sub_total), abs(descuento)
   From   Arfafe
   Where  no_cia   = Pv_cia
   And    no_factu = Pv_factu;


  Ln_base_gravada      Arfafe.gravada%type;
  Ln_base_exenta       Arfafe.exento%type;
  Ln_descuento_gravado Arfafe.Descuento_Gravado%type;
  Ln_descuento_exento  Arfafe.Descuento_Exento%type;

  Ln_subtotal          Arfafe.sub_total%type;
  Ln_descuento         Arfafe.descuento%type;

  Lv_ind               Arfact.ind_fac_dev%type;

  Lv_Error             Varchar2(500);
  Error_proceso        Exception;

begin

 Open C_Gravado;
 Fetch C_Gravado into Ln_base_gravada, Ln_descuento_gravado;
  If C_Gravado%notfound Then
      Ln_base_gravada      := 0;
      Ln_descuento_gravado := 0;
     Close C_Gravado;
  else
    Close C_Gravado;
  end if;

 Open C_Exento;
 Fetch C_Exento into Ln_base_exenta, Ln_descuento_exento;
  If C_Exento%notfound Then
     Ln_base_exenta      := 0;
     Ln_descuento_exento := 0;
    Close C_Exento;
  else
    Close C_Exento;
  end if;

  Open C_Tipo_doc;
  Fetch C_Tipo_doc into Lv_ind;
   If C_Tipo_doc%notfound Then
     Close C_Tipo_doc;
     Lv_Error := 'No existe documento para guardar el valor gravado o exento';
     Raise Error_Proceso;
   else
     Close C_Tipo_doc;
   end if;

  Open C_Factu;
  Fetch C_Factu into Ln_subtotal, Ln_descuento;
   If C_Factu%notfound Then
    Close C_Factu;
    Lv_Error := 'No existe documento: '||Pv_factu;
    Raise Error_proceso;
   else
    Close C_Factu;
   end if;


  --- Verifico que la base gravada mas base exenta sea igual al subtotal

  If Ln_base_gravada + Ln_base_exenta != Ln_subtotal Then
   Lv_Error := 'El subtotal: '||Ln_subtotal||' no es igual a la base gravada: '||Ln_base_gravada||' mas la base exenta: '||Ln_base_exenta||' , para el documento: '||Pv_factu;
   Raise Error_proceso;
  end if;

  --- Verifico que el descuento gravado mas el descuento exento sea igual al descuento

  If Ln_descuento_gravado + Ln_descuento_exento != Ln_descuento Then
   Lv_Error := 'El descuento no es igual al descuento gravado mas el descuento exento, para el documento: '||Pv_factu;
   Raise Error_proceso;
  end if;


  If Lv_ind in ('D','A') Then
   Ln_base_gravada      := Ln_base_gravada * -1;
   Ln_base_exenta       := Ln_base_exenta * -1;
   Ln_descuento_gravado := Ln_descuento_gravado * -1;
   Ln_descuento_exento  := Ln_descuento_exento * -1;
  end if;

 --- Para devoluciones y anulaciones se debe guardar los datos en negativo (SOLO FACTURACION)
 --- Para otros documentos se guarda los datos en positivo (SOLO FACTURACION)

 Update Arfafe
   Set  Gravada = Ln_base_gravada,
        exento  = Ln_base_exenta,
        descuento_gravado = Ln_descuento_gravado,
        descuento_exento = Ln_descuento_exento
  Where no_cia  = Pv_cia
  And   no_factu = Pv_factu;

EXCEPTION
  WHEN error_proceso THEN
       pv_Error  := Lv_Error;
  WHEN OTHERS THEN
       pv_Error  := 'Error en FAGRAVADO_EXENTO '||sqlerrm;
end fagravado_exento;