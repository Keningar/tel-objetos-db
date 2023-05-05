create or replace function            fa_decimales_pvp(Pv_cia IN Varchar2) return Number is

/*** Esta funcion devuelve la cantidad de decimales con la cual el precio de venta
     va a estar redondeado. Esto sirve para facturacion y para punto de ventas
     Si llega a existir el caso de que el usuario no configure la cantidad de decimales
     se asumen 2 decimales  ANR 26/04/2011 ****/

 Cursor C_decimales_pvp Is
  select nvl(digitos_pvp,2)
  from   arfamc
  where  no_cia = Pv_cia;

  Ln_decimales arfamc.digitos_pvp%type := 2;

begin

  Open C_decimales_pvp;
  Fetch C_decimales_pvp into Ln_decimales;
  If C_decimales_pvp%notfound Then
     Close C_decimales_pvp;
     return (Ln_decimales);
  else
      Close C_decimales_pvp;
      return (Ln_decimales);
  end if;

end fa_decimales_pvp;