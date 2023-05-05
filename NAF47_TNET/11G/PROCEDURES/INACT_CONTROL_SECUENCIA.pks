create or replace procedure            INACT_CONTROL_SECUENCIA(PCIA VARCHAR2,porden varchar2,parti varchar2) is
  cursor c_actualiza is
    Select secuencia_inicial,secuencia_final,fecha_caducidad
    from taporded
    where no_cia = pcia
    and no_orden = porden;

   vencontro boolean;
   vs_inicial number(10);
   vs_final number(10);
   vf_caducidad date;


begin
  Open c_actualiza;
  fetch c_actualiza  into vs_inicial,vs_final,vf_caducidad;
  vencontro:=c_actualiza%found;
  close c_actualiza;
  if vencontro then
     update arinda
     set secuencia_inicial = vs_inicial,
         secuencia_final = vs_final,
         fecha_caducidad = vf_caducidad
     where no_cia  = pcia
     and no_arti = parti;

  end if;
end INACT_CONTROL_SECUENCIA;