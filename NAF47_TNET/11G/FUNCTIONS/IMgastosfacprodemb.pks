create or replace FUNCTION            IMgastosfacprodemb (
  pcia   in varchar2,
  pEmbar  in varchar2
) RETURN number
IS
  -- Devuelve el total de gastos para la factura de productos
Cursor C_Fac is
 SELECT sum(nvl(a.monto,0)) monto
 FROM ARIMFACGASTOS a
 where a.no_cia=pCia  and
((a.no_cia,a.num_fac) in
(select b.no_cia,b.num_fac from arimencfacturas b
where no_cia=pCia
           and    no_embarque=pEmbar
));

 ln_valor number := 0;

BEGIN
 Open C_Fac;
 Fetch C_Fac into ln_valor;
 Close C_Fac;

 Return (ln_valor);

END;