CREATE OR REPLACE package            INPENDIENTES is

  -- Author  : Antonio Navarrete Ricaurte
  -- Created : 6/19/2009 8:55:33 AM
  -- Purpose : Administrar las cantidades pendientes de ARINMA, ARINLO


--- Para actualizar pendientes (debe ejecutarse en job o al final del dia)

Procedure Actualiza_Pedidos_Articulo  (Pv_Cia  IN Varchar2);

Procedure Actualiza_Entradas_Articulo (Pv_Cia  IN Varchar2);

Procedure Actualiza_Salidas_Articulo  (Pv_Cia  IN Varchar2);

Procedure Actualiza_Salidas_Lotes     (Pv_Cia  IN Varchar2);

Procedure Actualiza_Pedidos_Lotes     (Pv_Cia  IN Varchar2);

---- Procedimientos nuevos, filtrados por articulo

Procedure Actualiza_Pedidos_por_Articulo  (Pv_Cia  IN Varchar2, Pv_articulo IN Varchar2);

Procedure Actualiza_Pedidos_por_Lotes      (Pv_Cia  IN Varchar2, Pv_articulo IN Varchar2, Pv_lote IN Varchar2);


end INPENDIENTES;
/


CREATE OR REPLACE package body            INPENDIENTES is


Procedure Actualiza_Pedidos_Articulo (Pv_Cia IN Varchar2) Is
begin
null;
/*
--- Para pedidos pendientes de articulos, busco detalle de pedidos

  Cursor C_Articulos_Pedidos Is
   select b.bodega, b.no_arti, nvl(sum(nvl(b.pedido,0)+nvl(b.cantidad_adicional,0)),0) unidades
   from   arfafec a, arfaflc b
   where  a.no_cia = Pv_Cia
   and    b.bodega != '0000'
   and    a.estado IN ('P','A','Z','T','M')
   and    a.no_cia = b.no_cia
   and    a.no_factu = b.no_factu
   group by b.bodega, b.no_arti
   UNION
	 select b.bodega, b.no_arti, nvl(sum(nvl(b.pedido,0)),0) unidades
	 from   arfafe a, arfafl b
	 where  a.no_cia   = Pv_Cia
   and    b.bodega != '0000'
	 and    a.estado   = 'P'
	 and    a.no_cia   = b.no_cia
	 and    a.no_factu = b.no_factu
   group by b.bodega, b.no_arti;

Begin

--- Actualizo los pedidos pendientes, de acuerdo a lo pendiente en el detalle del pedido

For i in C_Articulos_Pedidos Loop

 Update Arinma
 set    pedidos_pend = pedidos_pend + i.unidades
 Where  no_cia  = Pv_Cia
 and    bodega  = i.bodega
 and    no_arti = i.no_arti;

End Loop;
*/
End;

Procedure Actualiza_Entradas_Articulo (Pv_Cia  IN Varchar2) Is
begin
null;
/*
--- Para entradas pendientes de articulos, busco en los movimientos pendientes tipo de documento entrada

Cursor C_Articulo_Entradas Is
 select c.bodega, c.no_arti, sum(nvl(c.unidades,0)) unidades
 from arinme a, arinvtm b, arinml c
 where a.no_cia = Pv_cia
 and   b.movimi = 'E'
 and   a.estado = 'P'
 and   a.no_cia = b.no_cia
 and   a.tipo_doc = b.tipo_m
 and   a.no_cia = c.no_cia
 and   a.no_docu = c.no_docu
 group by c.bodega, c.no_arti
 UNION --- bod dest es para entrada de articulos
  select b.bod_dest, b.no_arti, sum(nvl(b.cantidad,0)) unidades
  from arinte a, arintl b
  where a.no_cia = Pv_cia
  and a.estado = 'P'
  and nvl(b.cantidad,0) > 0
  and a.no_cia = b.no_cia
  and a.no_docu = b.no_docu
  group by b.bod_dest, b.no_arti;

Begin

--- Actualizo las entradas pendientes de articulos, de acuerdo al movimiento del documento

For i in C_Articulo_Entradas Loop
 Update Arinma
 set    ent_pend_un = ent_pend_un + i.unidades
 Where  no_cia  = Pv_Cia
 and    bodega  = i.bodega
 and    no_arti = i.no_arti;
End Loop;*/
End;

Procedure Actualiza_Salidas_Articulo (Pv_Cia  IN Varchar2) Is
begin
null;
/*
--- Para salidas pendientes de articulos, busco en los movimientos pendientes tipo de documento salida

Cursor C_Articulo_Salidas Is
 select c.bodega, c.no_arti, sum(nvl(c.unidades,0)) unidades
 from arinme a, arinvtm b, arinml c
 where a.no_cia = Pv_cia
 and   b.movimi = 'S'
 and   a.estado = 'P'
 and   a.no_cia = b.no_cia
 and   a.tipo_doc = b.tipo_m
 and   a.no_cia = c.no_cia
 and   a.no_docu = c.no_docu
 group by c.bodega, c.no_arti
 UNION ---- bod orig son salidas
 select b.bod_orig, b.no_arti, sum(nvl(b.cantidad,0)) unidades
 from arinte a, arintl b
 where a.no_cia = Pv_cia
 and a.estado = 'P'
 and nvl(b.cantidad,0) > 0
 and a.no_cia = b.no_cia
 and a.no_docu = b.no_docu
 group by b.bod_orig, b.no_arti;

Begin

--- Actualizo las salidas pendientes de articulos, de acuerdo al movimiento del documento

For i in C_Articulo_Salidas Loop
 Update Arinma
 set    sal_pend_un = sal_pend_un + i.unidades
 Where  no_cia  = Pv_Cia
 and    bodega  = i.bodega
 and    no_arti = i.no_arti;
End Loop;*/
End;

Procedure Actualiza_Salidas_Lotes (Pv_Cia  IN Varchar2) Is
begin
null;
/*
--- Para salidas pendientes de lotes, busco en los movimientos pendientes tipo de documento salida

Cursor C_Lotes_Salidas Is
 select c.bodega, c.no_arti, d.no_lote, sum(nvl(d.unidades,0)) unidades
 from arinme a, arinvtm b, arinml c, arinmo d
 where a.no_cia = Pv_cia
 and   b.movimi = 'S'
 and   a.estado = 'P'
 and   a.no_cia = b.no_cia
 and   a.tipo_doc = b.tipo_m
 and   a.no_cia = c.no_cia
 and   a.no_docu = c.no_docu
 and   c.no_cia = d.no_cia
 and   c.no_docu = d.no_docu
 and   c.linea = d.linea
 group by c.bodega, c.no_arti, d.no_lote
 UNION ---- bod orig son salidas
  select b.bod_orig, b.no_arti, c.no_lote, sum(nvl(c.unidades,0)) unidades
  from arinte a, arintl b, arinto c
  where a.no_cia = Pv_cia
  and a.estado = 'P'
  and nvl(c.unidades,0) > 0
  and a.no_cia = b.no_cia
  and a.no_docu = b.no_docu
  and b.no_cia = c.no_cia
  and b.no_docu = c.no_docu
  and b.no_arti = c.no_arti
  group by b.bod_orig, b.no_arti, c.no_lote;

Begin


--- Actualizo las salidas pendientes de lotes, de acuerdo al movimiento del documento

For i in C_Lotes_Salidas Loop
 Update Arinlo
 set    salida_pend = salida_pend + i.unidades
 Where  no_cia  = Pv_Cia
 and    bodega  = i.bodega
 and    no_arti = i.no_arti
 and    no_lote = i.no_lote;
End Loop;*/
End;

Procedure Actualiza_Pedidos_Lotes (Pv_Cia  IN Varchar2) Is
begin
null;
/*
--- Para pedidos pendientes de lotes, busco a nivel de pedidos

Cursor C_Lotes_Pedidos Is
 select b.bodega, b.no_arti, c.no_lote, nvl(sum(nvl(c.unidades,0)),0) unidades
 from   arfafec a, arfaflc b, arfaflc_lote c
 where  a.no_cia = Pv_Cia
 and    a.estado IN ('P','A','Z','T','M')
 and    b.bodega != '0000'
 and    a.no_cia = b.no_cia
 and    a.no_factu = b.no_factu
 and    b.no_cia = c.no_cia
 and    b.no_cia = c.no_cia
 and    b.no_factu = c.no_factu
 and    b.bodega = c.bodega
 and    b.no_arti = c.no_arti
 and    b.no_linea = c.no_linea
 group by b.bodega, b.no_arti, c.no_lote
UNION
	 select b.bodega, b.no_arti, c.no_lote, nvl(sum(nvl(c.unidades,0)),0) unidades
	 from   arfafe a, arfafl b, arfafl_lote c
	 where  a.no_cia   = Pv_Cia
   and    b.bodega != '0000'
	 and    a.estado   = 'P'
	 and    a.no_cia   = b.no_cia
	 and    a.no_factu = b.no_factu
   and    b.no_cia = c.no_cia
   and    b.no_cia = c.no_cia
   and    b.no_factu = c.no_factu
   and    b.bodega = c.bodega
   and    b.no_arti = c.no_arti
   and    b.no_linea = c.no_linea
   group by b.bodega, b.no_arti, c.no_lote;

Begin

--- Actualizo los pedidos pendientes, de acuerdo a lo pendiente en la tabla de pedidos por lotes

For i in C_Lotes_Pedidos Loop

 Update Arinlo
 set    pedidos_pend = pedidos_pend + i.unidades
 Where  no_cia  = Pv_Cia
 and    bodega  = i.bodega
 and    no_arti = i.no_arti
 and    no_lote = i.no_lote;

End Loop;
*/
End;

/***** Estos procedimientos se utilizan de forma individual (articulo, lote) ANR 09/02/2010  ***/

Procedure Actualiza_Pedidos_por_Articulo (Pv_Cia      IN Varchar2,
                                          Pv_articulo IN Varchar2) Is
begin
null;
/*
--- Para pedidos pendientes de articulos, busco detalle de pedidos

  Cursor C_Articulos_Pedidos Is
   select b.bodega, b.no_arti, nvl(sum(nvl(b.pedido,0)+nvl(b.cantidad_adicional,0)),0) unidades
   from   arfafec a, arfaflc b
   where  a.no_cia  = Pv_Cia
   and    b.no_arti = Pv_articulo
   and    b.bodega != '0000'
   and    a.estado IN ('P','A','Z','T','M')
   and    a.no_cia = b.no_cia
   and    a.no_factu = b.no_factu
   group by b.bodega, b.no_arti
   UNION
	 select b.bodega, b.no_arti, nvl(sum(nvl(b.pedido,0)),0) unidades
	 from   arfafe a, arfafl b
   where  a.no_cia  = Pv_Cia
   and    b.no_arti = Pv_articulo
   and    b.bodega != '0000'
	 and    a.estado   = 'P'
	 and    a.no_cia   = b.no_cia
	 and    a.no_factu = b.no_factu
   group by b.bodega, b.no_arti;

Begin

--- Actualizo los pedidos pendientes, de acuerdo a lo pendiente en el detalle del pedido

For i in C_Articulos_Pedidos Loop

 Update Arinma
 set    pedidos_pend = pedidos_pend + i.unidades
 Where  no_cia  = Pv_Cia
 and    bodega  = i.bodega
 and    no_arti = i.no_arti;

End Loop;
*/
End;


Procedure Actualiza_Pedidos_por_Lotes (Pv_Cia  IN Varchar2, Pv_Articulo IN Varchar2, Pv_lote IN Varchar2) Is
begin
null;
/*
--- Para pedidos pendientes de lotes, busco a nivel de pedidos

Cursor C_Lotes_Pedidos Is
 select b.bodega, b.no_arti, c.no_lote, nvl(sum(nvl(c.unidades,0)),0) unidades
 from   arfafec a, arfaflc b, arfaflc_lote c
 where  a.no_cia = Pv_Cia
 and    b.no_arti = Pv_articulo
 and    c.no_lote = Pv_lote
 and    a.estado IN ('P','A','Z','T','M')
 and    b.bodega != '0000'
 and    a.no_cia = b.no_cia
 and    a.no_factu = b.no_factu
 and    b.no_cia = c.no_cia
 and    b.no_cia = c.no_cia
 and    b.no_factu = c.no_factu
 and    b.bodega = c.bodega
 and    b.no_arti = c.no_arti
 and    b.no_linea = c.no_linea
 group by b.bodega, b.no_arti, c.no_lote
UNION
	 select b.bodega, b.no_arti, c.no_lote, nvl(sum(nvl(c.unidades,0)),0) unidades
	 from   arfafe a, arfafl b, arfafl_lote c
	 where  a.no_cia   = Pv_Cia
   and    b.no_arti  = Pv_articulo
   and    c.no_lote  = Pv_lote
   and    b.bodega != '0000'
	 and    a.estado   = 'P'
	 and    a.no_cia   = b.no_cia
	 and    a.no_factu = b.no_factu
   and    b.no_cia = c.no_cia
   and    b.no_cia = c.no_cia
   and    b.no_factu = c.no_factu
   and    b.bodega = c.bodega
   and    b.no_arti = c.no_arti
   and    b.no_linea = c.no_linea
   group by b.bodega, b.no_arti, c.no_lote;

Begin

--- Actualizo los pedidos pendientes, de acuerdo a lo pendiente en la tabla de pedidos por lotes

For i in C_Lotes_Pedidos Loop

 Update Arinlo
 set    pedidos_pend = i.unidades
 Where  no_cia  = Pv_Cia
 and    bodega  = i.bodega
 and    no_arti = i.no_arti
 and    no_lote = i.no_lote;

End Loop;
*/
End;


end INPENDIENTES;
/
