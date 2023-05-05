create or replace function            montos_cabecera_inv(tipo_d in varchar2,
                                                                   n_docu in varchar2) return number is
  Result number;

cursor monto_cab is
 select sum(nvl(l.cantidad,0)*nvl(l.precio_pvp,0)) monto
  from arintl l
  where  no_docu in (select NO_DOCU  from arinte where tipo_no_fisico =tipo_d)
   and no_docu = n_docu;
total number(18,2):=0;

begin
   open monto_cab;
   fetch monto_cab into total;
   if monto_cab%found then
      result := total;
   else
      result :=0;
   end if;
   close monto_cab;
  return(Result);
end montos_cabecera_inv;