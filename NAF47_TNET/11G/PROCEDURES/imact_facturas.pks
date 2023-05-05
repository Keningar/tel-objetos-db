create or replace procedure            imact_facturas(
  pno_fisico       arimencfacturas.no_fisico%type,
  pno_prove        arimencfacturas.cod_proveedor%type,
  pCia             arimdetfacturas.no_cia%type
)is
cursor c_codigos is
select b.num_fac, b.no_arti, b.precio, a.total_general, a.monto_desc, a.impuesto
from arimencfacturas a, arimdetfacturas b
where a.num_fac = b.num_fac
and a.no_cia = pcia
and a.no_fisico = pno_fisico
and a.cod_proveedor = pno_prove;

cursor c_gastos is
select a.monto, a.num_fac
from arimfACgastos a
where a.no_cia = pcia
order by a.num_fac;


vtotal_general   arimencfacturas.total_general%type;
vtotal_formula   arimencfacturas.total_general%type;
begin
for codigos in c_codigos loop
   vtotal_general := codigos.total_general;
   vtotal_formula := ((NVL(codigos.total_general,0))+(NVL(codigos.impuesto,0))-(NVL(codigos.monto_desc,0)));
   for gastos in c_gastos loop
         if gastos.num_fac = codigos.num_fac then
         vtotal_formula := vtotal_formula + gastos.monto;
         end if;
   end loop;
   if vtotal_general = 0 OR vtotal_formula = 0 THEN

    update arimdetfacturas ar
    set ar.precio_2 = NVL(codigos.PRECIO,0)
    where ar.no_cia = pcia
    and ar.num_fac = codigos.num_fac
    and ar.no_arti = codigos.no_arti;

  	ELSE

  	update arimdetfacturas ar
    set ar.precio_2 = (NVL(codigos.PRECIO,0)*(NVL(vtotal_formula,0)/NVL(vtotal_general,1)))
    where ar.no_cia = pcia
    and ar.num_fac = codigos.num_fac
    and ar.no_arti = codigos.no_arti;

    END IF;
end loop;
COMMIT;
end imact_facturas;