create or replace PROCEDURE            inact_estado_orden(pno_cia   arinml.no_cia%type,
                                                pno_orden arinml.no_orden%type,
                                                msg_error in out varchar2) IS

   ln_total      number(17,3);
   vfound        boolean;
   msg_error_p   varchar2(100);
   error_proceso exception;

   Cursor c_orden is
      Select sum(nvl(recibido,0) - nvl(cantidad,0)) total
        from taporded
       where no_cia   = pno_cia
         and no_orden = pno_orden;

Begin
    open c_orden;
    fetch c_orden into ln_total;
    vfound := c_orden%found;
    close c_orden;
    if NOT vfound then
       msg_error_p := 'La Orden de Compra '||pno_orden||' no existe';
       raise error_proceso;
    end if;

    if ln_total < 0 then
      update tapordee
         set estado = 'I'
       where no_cia = pno_cia
         and no_orden = pno_orden;
    else
       update tapordee
         set estado = 'F'
       where no_cia = pno_cia
         and no_orden = pno_orden;
    end if;

Exception
   when others then
        msg_error:='Error en inact_estado_compra';
End;