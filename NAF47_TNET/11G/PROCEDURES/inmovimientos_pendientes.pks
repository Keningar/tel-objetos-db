create or replace procedure            inmovimientos_pendientes(PCia IN varchar2) is

                   --- BOD ORIG    BOD DEST
---TRF (SALIDAS)        BOD2          X.AL  Solo este movimiento va a validar salidas pendientes
---SBY (SALIDAS)        BOD2          SBY   Solo este movimiento va a validar salidas pendientes
---TRA (ENTRADAS)       X.AL          BOD2  No se lo va a considerar para entradas pendientes
---NCS (ENTRADAS)       X.AL          BOD2  No se lo va a considerar para entradas pendientes
---RSB (ENTRADAS)       SBY           BOD2  No se lo va a considerar para entradas pendientes
---TRL (NO CONSIDERAR)

--- Solamente valido bodegas principales

--- Dependiendo los tipos de documento de Inventarios, hay que considerar salidas y entradas
--- Con el ind_borrado S, N valido transaccion pendiente o actualizada. Solamente valido Pendientes.

--- Movimientos de Inventarios y de Facturacion

Cursor C_Salidas_Pendientes Is---- Salidas pendientes de Inventarios y de Facturacion
 Select x.bodega, x.no_arti, sum(x.cantidad) cantidad
 from v_inv_fac_mov_pendientes x
 Where x.no_cia = PCia
 Group by x.bodega, x.no_arti;

Cursor C_Salidas_Actualizadas Is --- Salidas Actualizadas
 Select bodega, no_arti
 From arinma
 Where no_cia = PCia
 And Sal_Pend_un != 0
MINUS
 Select bodega, no_arti
 From v_inv_fac_mov_pendientes
 Where no_cia = PCia;


 --- Movimientos de Facturacion (Solo Pedidos)

Cursor C_Pedidos_Pendientes Is  --- Pedidos Pendientes de Facturacion
 Select x.bodega, x.no_arti, sum(x.cantidad) cantidad
 from v_fac_ped_pendientes x
 Where x.no_cia = PCia
 AND X.ANULADO <>'A'
 Group by x.no_cia, x.bodega, x.no_arti;

Cursor C_Pedidos_Actualizdos Is
 Select bodega, no_arti
 From arinma
 Where no_cia = PCia
 And Pedidos_Pend != 0
MINUS
 Select bodega, no_arti
 From v_fac_ped_pendientes
 Where no_cia = PCia;

begin

For i in C_Salidas_Pendientes Loop  --- Cargo Salidas Pendientes

 Update Arinma
 Set    Sal_Pend_Un = i.cantidad
 Where  no_cia = PCia
 And    no_arti = i.no_arti
 And    bodega = i.bodega;

End Loop;


For i in C_Salidas_Actualizadas Loop  --- Cargo Salidas Pendientes

 Update Arinma
 Set    Sal_Pend_Un = 0
 Where  no_cia = PCia
 And    no_arti = i.no_arti
 And    bodega = i.bodega;

End Loop;

For i in C_Pedidos_Pendientes Loop --- Cargo Pedidos Pendientes

 Update Arinma
 Set    Pedidos_Pend = i.cantidad
 Where  no_cia = PCia
 And    no_arti = i.no_arti
 And    bodega = i.bodega;

End Loop;

For i in C_Pedidos_Actualizdos Loop  --- Pedidos Actualizados

 Update Arinma
 Set    Pedidos_Pend = 0
 Where  no_cia = PCia
 And    no_arti = i.no_arti
 And    bodega = i.bodega;

End Loop;


end inmovimientos_pendientes;