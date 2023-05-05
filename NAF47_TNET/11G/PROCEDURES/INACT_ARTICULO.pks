create or replace procedure            INACT_ARTICULO(PCIA VARCHAR2,PARTICULO VARCHAR2,PORDEN

VARCHAR2,PFDOCUMENTO DATE)  is
Cursor c_dias is
  Select tiempo_rep
  from arinda
  where no_cia = pcia
  and no_arti = particulo;

Cursor c_fecha_orden is
  Select fecha
  from tapordee
  where no_cia = pcia
  and  no_orden = porden;

vdias      arinda.tiempo_rep%Type;
vpromedio  number;
ventrega   number;
vf_orden   date;
begin

open c_dias;
fetch c_dias into vdias;
close c_dias;

open c_fecha_orden;
fetch c_fecha_orden into vf_orden;
close c_fecha_orden;

ventrega:= pfdocumento-vf_orden;

 if NVL(vdias,0) > 0 then
      vpromedio:=(NVL(vdias,0)+NVL(ventrega,0))/2;
 else
      vpromedio:=NVL(ventrega,0);
 end if;

 update arinda
 set  tiempo_rep= ROUND(NVL(vpromedio,0),0)
 where no_cia = pcia
 and no_arti=particulo;


end INACT_ARTICULO;