create or replace procedure            imact_precio(
  pv_Cia             arimdetfacturas.no_cia%type,
  pv_arti         arinda.no_arti%type,
  pn_precio       arimprodu.precio%type
)is
begin
   if NVL(pn_precio,0) > 0  THEN

      update arimprodu ar
         set ar.precio = NVL(pn_precio,0)
       where ar.no_cia = pv_cia
         and ar.no_arti = pv_arti;
    END IF;
end imact_precio;