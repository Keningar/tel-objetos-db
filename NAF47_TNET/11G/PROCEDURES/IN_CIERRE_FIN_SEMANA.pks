create or replace procedure            IN_CIERRE_FIN_SEMANA(Pv_cia     in varchar2,
                                                 Pv_centro  in varchar2,
                                                 Pd_fecha   in date,
                                                 Pv_error   in out varchar2) Is
-- -------------------------------------------------------------------------
-- creado por : FEM, 30-01-2009
-- Objetivo   : Se lo crea para usarlo en el procedimiento INCIERREDIARIOJOB,
--              para controlar que no existan documentos pendientes.
-- -------------------------------------------------------------------------
Cursor c_mov_pend Is
Select distinct tipo_doc
  From arinme
 Where no_cia = Pv_cia
   And centro = Pv_centro
   And trunc(fecha) <= Pd_fecha
   And estado = 'P'
   and rownum = 1;

Cursor act_pend_consignaciones(p_no_cia 		 Varchar2,
															 p_centro 		 Varchar2,
															 p_dia_proceso Date) Is
Select 'X'
  From arinencconsignacli
 Where no_cia = p_no_cia
   And centro = p_centro
   And trunc(fecha_registro) <= p_dia_proceso
   And estado = 'P';

Cursor act_pend_reordenproduccion(p_no_cia	 		Varchar2,
																	p_dia_proceso Date) Is
Select 'X'
  From arinencreordenproduccion
 where no_cia = p_no_cia
   and centro = Pv_centro
   and trunc(fecha) <= p_dia_proceso
   and estado = 'P';

Cursor act_pend_consumointer(p_no_cia 			varchar2,
													 	 p_centro 			varchar2,
													 	 p_dia_proceso 	date) Is
Select 'X'
  From arinencconsumointer g
 where g.no_cia = p_no_cia
   and g.centro = p_centro
   and trunc(g.fecha_registro) <= p_dia_proceso
   and g.estado = 'P';

Cursor C_act_pend_sol_req(p_no_cia 			varchar2,
													p_centro 			varchar2,
													p_dia_proceso date) Is
Select 'X'
  From inv_cab_solicitud_requisicion g
 Where g.no_cia = p_no_cia
   And g.centro = p_centro
   And trunc(g.fecha) <= p_dia_proceso
   And g.estado = 'P';

Cursor C_arinencobsdon (p_no_cia 			varchar2,
												p_centro 			varchar2,
												p_dia_proceso date) Is
Select 'X'
  From arinencobsdon g
 Where g.no_cia = p_no_cia
   And g.centro = p_centro
   And trunc(g.fecha_solic) <= p_dia_proceso
   And g.estado = 'P';

Cursor C_arinenc_solicitud (p_no_cia 			 varchar2,
								 						p_dia_proceso  date) Is
Select 'X'
  From arinenc_solicitud g
 Where g.no_cia 		  = p_no_cia
   and g.centro       = Pv_centro
   and trunc(g.fecha) <= p_dia_proceso
   and g.estado       = 'P';

Cursor pend_manif Is
Select 'X'
  From arinem
 Where no_cia = Pv_cia
   And centro = Pv_centro
   And trunc(fecha) <= Pd_fecha;

Cursor C_arinencreclamo (p_no_cia 			varchar2,
												 p_dia_proceso 	date) Is
Select 'X'
  From arinencreclamo g
 Where g.no_cia = p_no_cia
   And trunc(g.fecha) <= p_dia_proceso
   And g.estado = 'P';

Cursor C_arinencremision is
select 'X'
  from arinencremision
 where no_cia = Pv_cia
   and centro = Pv_centro
   and trunc(fecha_registro) <= Pd_fecha
   and estado = 'P';

	 Lv_Dato				varchar2(100):=null;
	 Lb_Found				Boolean:=false;
   Lv_error       varchar2(500):=null;
   Le_error       exception;

Begin
  ---
	Open C_arinencremision;
	Fetch C_arinencremision into Lv_Dato;
	Lb_Found:= C_arinencremision%Found;
	Close C_arinencremision;

	If Lb_Found then
		Lv_error:= 'Existen guias pendientes de procesar para este dia, Favor revisar';
		Raise Le_error;
	End If;

	---
	Open c_mov_pend;
	Fetch c_mov_pend into Lv_Dato;
	Lb_Found:= c_mov_pend%Found;
	Close c_mov_pend;

	If Lb_Found then
		Lv_error:= 'Existe el documento(s) :'||Lv_Dato||' pendiente de Actualizar, favor revisar';
 		Raise Le_error;
	End If;

	---
	Open act_pend_consignaciones(Pv_cia, Pv_centro, Pd_fecha);
	Fetch act_pend_consignaciones into Lv_Dato;
	Lb_Found:= act_pend_consignaciones%Found;
	Close act_pend_consignaciones;

	If Lb_Found then
		Lv_error:= 'Existe Solicitudes de Consignaciones pendiente de actualizar, favor revisar';
 		Raise Le_error;
	End If;

	---
	Open act_pend_reordenproduccion(Pv_cia, Pd_fecha);
	Fetch act_pend_reordenproduccion into Lv_Dato;
	Lb_Found:= act_pend_reordenproduccion%Found;
	Close act_pend_reordenproduccion;

	If Lb_Found then
		Lv_error:=  'Existe Solicitudes de Reordenamiento pendiente de actualizar, favor revisar';
 		Raise Le_error;
	End If;

	---
	Open act_pend_consumointer(Pv_cia, Pv_centro, Pd_fecha);
	Fetch act_pend_consumointer into Lv_Dato;
	Lb_Found:= act_pend_consumointer%Found;
	Close act_pend_consumointer;

	If Lb_Found then
		Lv_error:=  'Existe(n) Solicitudes de Consumo Interno pendiente(s) de Actualizar, favor revisar';
    Raise Le_error;
  End If;

	---
	Open C_act_pend_sol_req(Pv_cia, Pv_centro, Pd_fecha);
	Fetch C_act_pend_sol_req into Lv_Dato;
	Lb_Found:= C_act_pend_sol_req%Found;
	Close C_act_pend_sol_req;

	If Lb_Found then
		Lv_error:= 'Existe Requisiciones pendientes de Actualizar, favor revisar';
    Raise Le_error;
	End If;

	---
	Open C_arinencobsdon(Pv_cia, Pv_centro, Pd_fecha);
	Fetch C_arinencobsdon into Lv_Dato;
	Lb_Found:= C_arinencobsdon%Found;
	Close C_arinencobsdon;

	If Lb_Found then
		Lv_error:=  'Existe(n) Obsequios y/o Donaciones pendiente(s) de Actualizar, Favor revisar';
    Raise Le_error;
	End If;

	---
	Open C_arinenc_solicitud(Pv_cia, Pd_fecha);
	Fetch C_arinenc_solicitud into Lv_Dato;
	Lb_Found:= C_arinenc_solicitud%Found;
	Close C_arinenc_solicitud;

	If Lb_Found then
		Lv_error:= 'Existe(n) Solicitudes de Transferencias pendiente(s) de Actualizar, favor revisar';
    Raise Le_error;
	End If;

	---
	Open C_arinencreclamo(Pv_cia, Pd_fecha);
	Fetch C_arinencreclamo into Lv_Dato;
	Lb_Found:= C_arinencreclamo%Found;
	Close C_arinencreclamo;

	If Lb_Found then
		Lv_error:= 'Existe(n) Solicitudes de reclamo a proveedor pendiente(s) de Actualizar, favor revisar';
    Raise Le_error;
	End If;

  ---
	Open pend_manif;
	Fetch pend_manif into Lv_Dato;
	Lb_Found:= pend_manif%Found;
	Close pend_manif;

	If Lb_Found then
		Lv_error:= 'Existe(n) Manifiesto(s) pendiente(s) de Actualizar, favor revisar';
    Raise Le_error;
	End If;

  ---
Exception
  When Le_error then
    Pv_error:= Lv_error;
End in_cierre_fin_semana;