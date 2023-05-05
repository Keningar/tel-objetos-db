create or replace function            FA_PRECIO_CIA_RELACIONADA(Pv_Cia           IN Varchar2,
                                                     Pv_grupo_cliente IN Varchar2,
                                                     Pn_costo2        IN Number) return
  Number IS

Cursor C_Margen Is
 select margen_cia_relacionado
 from   arccgr
 where  no_cia = Pv_cia
 and    grupo  = Pv_grupo_cliente;

 Ln_margen Arccgr.margen_cia_relacionado%type;
 Ln_pvp    Arintp.precio%type;

/**** Funcion creada para devolver el valor del precio de venta para un grupo de cliente
      de una compania relacionada. Realizado por ANR 21/12/2009 ****/

begin

 Open C_Margen;
 Fetch C_Margen into Ln_margen;
  If C_Margen%notfound Then
    Close C_Margen;
    Ln_margen := 0;
   else
    Close C_Margen;
 end if;

/**** Formula a utilizar: costo2 /(1-margen)/100). ****/

  If Ln_margen != 100 Then
   Ln_pvp := Pn_costo2 / (1-(Ln_margen/100));
  else
   Ln_pvp := 0;
  end if;

  return(Ln_pvp);

end FA_PRECIO_CIA_RELACIONADA;