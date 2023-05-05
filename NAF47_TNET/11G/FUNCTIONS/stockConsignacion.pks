create or replace function            stockConsignacion(pv_solicitud in varchar2, pv_articulo in varchar2,pv_bodega in varchar2,pv_no_cia in varchar2,pv_centro in varchar2,pv_no_docu in varchar2) return number is

cursor lc_bod_princ is
SELECT codigo
  FROM arinbo
 WHERE no_cia      = pv_no_cia
   AND centro      = pv_centro
   AND tipobodega  = 'A'
   AND codigo     != '0000'
   AND  principal = 'S'
   AND activa = 'S';



  ln_stock  number;
  lv_bodega_princ varchar2(4);
begin

open lc_bod_princ;
  fetch lc_bod_princ into lv_bodega_princ;
close lc_bod_princ;

 if pv_bodega = lv_bodega_princ then
   ln_stock := articulo.existencia(pCia => pv_no_cia,pArticulo => pv_articulo,pBodega => pv_bodega);
 else
    select nvl(d.uni_transferida,0) - nvl(d.uni_facturadas,0) - nvl(d.uni_devueltas,0) -nvl(d.uni_reordena,0)-nvl(d.uni_obsequio,0) stock into ln_stock
    from arinencconsignacli c, arindetconsignacli d
    where c.no_solicitud = pv_solicitud
    and d.no_arti = pv_articulo
    and d.no_docu = pv_no_docu
    and c.no_cia = d.no_cia
    and c.no_docu = d.no_docu;
 end if;

  return(ln_stock);
exception
when others then
    return(0);
end stockConsignacion;