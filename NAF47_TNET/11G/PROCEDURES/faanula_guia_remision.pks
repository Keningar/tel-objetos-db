create or replace procedure            faanula_guia_remision(Pv_cia IN Varchar2, Pv_centro IN Varchar2,
                                                  Pv_bloque IN Varchar2, Pv_bodega IN Varchar2,
                                                  Pv_fisico_guia IN Varchar2, Pv_motivo_anula IN Varchar2,
                                                  Pv_transa IN Varchar2, Pv_Error OUT Varchar2,
                                                  Pv_nota OUT Varchar2) is

--- Este procedimiento se lo copio de la pantalla de anulacion de guia que esta en el modulo de
--- inventarios (PINV253)
--- Cualquier cambio que se realice en esa pantalla, deberia ser revisado y actualizado en este proceso
--- ANR 11/07/2009

Cursor lc_datos Is
Select r.no_fisico_guia,r.observacion, r.fecha_registro,r.nombre_destinatario,r.ced_destinatario
  From arinencremision r
 Where no_cia = Pv_cia
   And centro = Pv_centro
   And no_transa = Pv_transa
   and estado != 'A'
 order by 1;

Cursor c_fecha_proceso Is
select d.dia_proceso,d.mes_proce,d.ano_proce
  from arincd d
 where d.no_cia = Pv_cia
   and d.centro = Pv_centro;

Cursor C_fecha is
select sysdate
  from dual;

lv_no_docu        Varchar2(12);
lr_datos          lc_datos%rowtype;
lr_fecha_proc     c_fecha_proceso%rowtype;
lb_found          Boolean;
lv_observacion    Varchar2(200);
ln_secuencia      Number;
Ld_fecha          date;

Lv_Error          Varchar2(500);

Error_proceso     Exception;

Begin
  ---
  If Pv_bodega is null then
    Lv_Error := 'Debe ingresar la bodega origen, para anular guia de remision';
    Raise Error_Proceso;
  End if;
  ---
  If Pv_fisico_guia is null then
    Lv_Error := 'Debe ingresar el numero fisico de la guia, para anular guia de remision';
    Raise Error_Proceso;
  End if;
  ---
  If Pv_motivo_anula is null then
    Lv_Error := 'Debe ingresar el motivo de la anulacion, para anular guia de remision';
    Raise Error_Proceso;
  End if;
  ---
  Open C_fecha;
  Fetch C_fecha into Ld_fecha;
  Close C_fecha;
  ---
  Open lc_datos;
  Fetch lc_datos into lr_datos;
  Lb_found := lc_datos%found;
  Close lc_datos;
  ---
  If lb_found then
     update ARINENCREMISION r
        set r.estado        = 'A',
            r.usuario_anula = user,
            r.fecha_anula   = Ld_fecha,
            r.motivo_anula  = Substr(Pv_motivo_anula,1,60)
      where r.no_fisico_guia  = Pv_fisico_guia
        and r.no_transa       = Pv_transa
        and r.no_cia          = Pv_cia;
    ---
  else
      ---
      open c_fecha_proceso;
      fetch c_fecha_proceso into lr_fecha_proc;
      close c_fecha_proceso;
      ---
      lv_no_docu         := Transa_Id.Inv(Pv_cia);
      lv_observacion     := 'Guia anulada sin referencia de transaccion inicial';

      ---
      Select d.siguiente into ln_secuencia
        From control_formu d
       Where d.no_cia = Pv_cia
         And d.formulario = Pv_bloque
         And d.activo = 'S';
      ---
      If nvl(ln_secuencia,0) <> nvl(Pv_fisico_guia,0) then
         Lv_Error:= 'La guia # '||Pv_fisico_guia||' que desea borrar no es la siguiente en la secuencia del bloque que es '||ln_secuencia||' ,esas guias deben ser asignadas o anuladas';
         Raise Error_Proceso;
      End if;
      ---
      Begin
      Insert into arinencremision(no_cia,                CENTRO,            NO_TRANSA,
                                  FECHA_REGISTRO,        GUIA_FACTURA,      ESTADO,
                                  NO_DOCU_REFE,          IMPRESO,          BODEGA_ORIGEN,
                                  FECHA_LLEGADA,        TSTAMP,            observacion,
                                  motivo_anula,          usuario_anula,    fecha_anula,
                                  no_fisico_guia)
                          values( Pv_cia,      Pv_centro,    lv_no_docu,
                                  Ld_fecha,              'N',              'A',
                                  null,                  'S',              Pv_bodega,
                                  null,                  Ld_fecha,          lv_observacion,
                                  Pv_motivo_anula,    user,              Ld_fecha,
                                  Pv_fisico_guia);
     Exception
     When Others Then
       Lv_Error := 'Error al crear registro de guia de remision: '||Lv_no_docu;
       raise Error_Proceso;
     End;
      ---
  End If;
  ---
  Pv_nota := 'La anulacion de la guia # '||Pv_fisico_guia||' fue exitosa';
	---
Exception
  When Error_Proceso Then
  Pv_Error := Lv_Error;
  When Others Then
  Pv_Error := 'Error al anular guia de remision desde facturacion '||sqlerrm;
end faanula_guia_remision;