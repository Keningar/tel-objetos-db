create or replace FUNCTION            IMgastosfacprod (
  pcia   in varchar2,
  pfac   in varchar2
) RETURN number
IS
  -- Devuelve el total de gastos para la factura de productos
Cursor C_Fac is
 SELECT sum(nvl(monto,0)) monto
 FROM ARIMFACGASTOS
 where no_cia = pcia
 and num_fac = pfac;

 ln_valor number := 0;

BEGIN
 Open C_Fac;
 Fetch C_Fac into ln_valor;
 Close C_Fac;

 Return (ln_valor);

END;