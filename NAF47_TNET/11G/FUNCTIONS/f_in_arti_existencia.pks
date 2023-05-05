create or replace function            f_in_arti_existencia (
          L_no_cia    varchar2,
          L_no_arti   varchar2,
          L_bodega    varchar2 )
return number is
  Result number;
begin
select nvl(a.sal_ant_un,0) + nvl(a.comp_un,0)
      - nvl(a.vent_un,0) - nvl(a.cons_un,0)
      + nvl(a.otrs_un,0)
  into result
  from arinma a
  where a.no_cia = L_NO_CIA
  and a.no_arti = L_NO_ARTI
  and a.bodega =  L_BODEGA   ;
  return(Result);
exception
 when others then
  return(0);
end f_in_arti_existencia;