CREATE OR REPLACE package            INPENDIENTE is

  -- Author  : Antonio Navarrete Ricaurte
  -- Created : 6/19/2009 8:55:33 AM
  -- Purpose : Administrar las cantidades pendientes de ARINMA, ARINLO

--- Para encerar pendientes (debe ejecutarse en job o al final del dia)

Function Ped_pend_articulo     (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2) return Number;

Function Fact_pend_articulo    (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number;

Function Ent_pend_articulo     (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number;

Function Ent_pend_Tr_articulo  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number;

Function Sal_pend_articulo     (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number;

Function Sal_pend_Tr_articulo  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number;

Function Ped_pend_lote         (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2, Pv_lote IN Varchar2)return Number;

Function Fact_pend_lote        (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2, Pv_lote IN Varchar2)return Number;

Function Sal_pend_lote         (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2, Pv_lote IN Varchar2)return Number;

Function Sal_pend_tr_lote      (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2, Pv_lote IN Varchar2)return Number;

end INPENDIENTE;
/


CREATE OR REPLACE package body            INPENDIENTE is

Function Ped_pend_articulo  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2) return Number IS

--- Pedidos pendientes (facturacion)

Cursor C_Arti Is
   select nvl(sum(nvl(b.pedido,0)+nvl(b.cantidad_adicional,0)
                     -decode(a.estado,'T',nvl(b.cant_transferencia,0),0)),0) unidades
   from   arfafec a, arfaflc b
   where  a.no_cia = Pv_Cia
   and    b.bodega  = DECODE(Pv_Bodega,'',b.bodega,Pv_Bodega)
   and    b.no_arti = Pv_Arti
   and    a.estado IN ('P','A','Z','T','M')
   and    a.no_cia = b.no_cia
   and    a.no_factu = b.no_factu;

   Ln_Pend Arinma.pedidos_pend%type := 0;

   Begin
   Open C_Arti;
   Fetch C_Arti into Ln_Pend;
   If C_Arti%notfound Then
     Close C_Arti;
     return (Ln_Pend);
   else
     Close C_Arti;
     return (Ln_Pend);
   end if;
   End;

Function Fact_pend_articulo  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2) return Number IS

--- Facturas pendientes (facturacion)

Cursor C_Arti Is
	 select nvl(sum(nvl(b.pedido,0)),0) unidades
	 from   arfafe a, arfafl b
	 where  a.no_cia   = Pv_Cia
   and    b.bodega   = DECODE(Pv_Bodega,'',b.bodega,Pv_Bodega)
   and    b.no_arti  = Pv_Arti
	 and    a.estado   = 'P'
	 and    a.no_cia   = b.no_cia
	 and    a.no_factu = b.no_factu;

   Ln_Pend Arinma.pedidos_pend%type := 0;

   Begin
   Open C_Arti;
   Fetch C_Arti into Ln_Pend;
   If C_Arti%notfound Then
     Close C_Arti;
     return (Ln_Pend);
   else
     Close C_Arti;
     return (Ln_Pend);
   end if;
   End;

Function Ent_pend_articulo  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number IS

--- Entradas pendientes (Inventarios)

Cursor C_Arti Is
 select nvl(sum(nvl(c.unidades,0)),0) unidades
 from arinme a, arinvtm b, arinml c
 where a.no_cia  = Pv_cia
 and   c.bodega  = DECODE(Pv_Bodega,'',c.bodega,Pv_Bodega)
 and   c.no_arti = Pv_arti
 and   b.movimi  = 'E'
 and   a.estado  = 'P'
 and   a.no_cia  = b.no_cia
 and   a.tipo_doc = b.tipo_m
 and   a.no_cia  = c.no_cia
 and   a.no_docu = c.no_docu;

   Ln_Pend Arinma.ent_pend_un%type := 0;

   Begin
   Open C_Arti;
   Fetch C_Arti into Ln_Pend;
   If C_Arti%notfound Then
     Close C_Arti;
     return (Ln_Pend);
   else
     Close C_Arti;
     return (Ln_Pend);
   end if;
   End;

Function Ent_pend_Tr_articulo  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number IS

--- Entradas pendientes (Inventarios - transferencias)

Cursor C_Arti Is
 --- bod dest es para entrada de articulos
  select nvl(sum(nvl(b.cantidad,0)),0) unidades
  from arinte a, arintl b
  where a.no_cia   = Pv_cia
  and   b.bod_dest = DECODE(Pv_Bodega,'',b.bod_dest,Pv_Bodega)
  and   b.no_arti  = Pv_arti
  and a.estado = 'P'
  and nvl(b.cantidad,0) > 0
  and a.no_cia  = b.no_cia
  and a.no_docu = b.no_docu;

   Ln_Pend Arinma.ent_pend_un%type := 0;

   Begin
   Open C_Arti;
   Fetch C_Arti into Ln_Pend;
   If C_Arti%notfound Then
     Close C_Arti;
     return (Ln_Pend);
   else
     Close C_Arti;
     return (Ln_Pend);
   end if;
   End;

Function Sal_pend_articulo  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number IS

--- Salidas pendientes (Inventarios)

Cursor C_Arti Is
 select nvl(sum(nvl(c.unidades,0)),0) unidades
 from arinme a, arinvtm b, arinml c
 where a.no_cia = Pv_cia
 and   c.bodega = DECODE(Pv_Bodega,'',c.bodega,Pv_Bodega)
 and   c.no_arti = Pv_arti
 and   b.movimi = 'S'
 and   a.estado = 'P'
 and   a.no_cia = b.no_cia
 and   a.tipo_doc = b.tipo_m
 and   a.no_cia = c.no_cia
 and   a.no_docu = c.no_docu;

   Ln_Pend Arinma.sal_pend_un%type := 0;

   Begin
   Open C_Arti;
   Fetch C_Arti into Ln_Pend;
   If C_Arti%notfound Then
     Close C_Arti;
     return (Ln_Pend);
   else
     Close C_Arti;
     return (Ln_Pend);
   end if;
   End;

Function Sal_pend_Tr_articulo  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2)return Number IS

--- Salidas pendientes (Inventarios - transferencias)

 ---- bod orig son salidas
 Cursor C_Arti Is
 select nvl(sum(nvl(b.cantidad,0)),0) unidades
 from arinte a, arintl b
 where a.no_cia = Pv_cia
 and   b.bod_orig = DECODE(Pv_Bodega,'',b.bod_orig, Pv_Bodega)
 and   b.no_arti  = Pv_arti
 and a.estado = 'P'
 and nvl(b.cantidad,0) > 0
 and a.no_cia = b.no_cia
 and a.no_docu = b.no_docu;

   Ln_Pend Arinma.sal_pend_un%type := 0;

   Begin
   Open C_Arti;
   Fetch C_Arti into Ln_Pend;
   If C_Arti%notfound Then
     Close C_Arti;
     return (Ln_Pend);
   else
     Close C_Arti;
     return (Ln_Pend);
   end if;
   End;

Function Ped_pend_lote  (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2, Pv_lote IN Varchar2)return Number IS

--- Pedidos pendientes lotes (Facturacion)

 Cursor C_Lote Is
 select nvl(sum(nvl(c.unidades,0)),0) unidades
 from   arfafec a, arfaflc b, arfaflc_lote c
 where  a.no_cia = Pv_Cia
 and    b.bodega = DECODE(Pv_Bodega,'',b.bodega,Pv_Bodega)
 and    b.no_arti = Pv_arti
 And    c.no_lote = Pv_lote
 and    a.estado IN ('P','A','Z','T','M')
 and    a.no_cia = b.no_cia
 and    a.no_factu = b.no_factu
 and    b.no_cia = c.no_cia
 and    b.no_cia = c.no_cia
 and    b.no_factu = c.no_factu
 and    b.bodega = c.bodega
 and    b.no_arti = c.no_arti
 and    b.no_linea = c.no_linea;

   Ln_Pend Arinlo.pedidos_pend%type := 0;

   Begin
   Open C_Lote;
   Fetch C_Lote into Ln_Pend;
   If C_Lote%notfound Then
     Close C_Lote;
     return (Ln_Pend);
   else
     Close C_Lote;
     return (Ln_Pend);
   end if;
   End;

Function Fact_pend_lote     (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2, Pv_lote IN Varchar2)return Number IS

--- Facturas pendientes lotes (Facturacion)

  Cursor C_Lote Is
	 select nvl(sum(nvl(c.unidades,0)),0) unidades
	 from   arfafe a, arfafl b, arfafl_lote c
	 where  a.no_cia   = Pv_Cia
   and    b.bodega =  DECODE(Pv_Bodega,'',b.bodega,Pv_Bodega)
   and    b.no_arti = Pv_arti
   and    c.no_lote = Pv_lote
	 and    a.estado   = 'P'
	 and    a.no_cia   = b.no_cia
	 and    a.no_factu = b.no_factu
   and    b.no_cia = c.no_cia
   and    b.no_cia = c.no_cia
   and    b.no_factu = c.no_factu
   and    b.bodega = c.bodega
   and    b.no_arti = c.no_arti
   and    b.no_linea = c.no_linea;

   Ln_Pend Arinlo.pedidos_pend%type := 0;

   Begin
   Open C_Lote;
   Fetch C_Lote into Ln_Pend;
   If C_Lote%notfound Then
     Close C_Lote;
     return (Ln_Pend);
   else
     Close C_Lote;
     return (Ln_Pend);
   end if;
   End;

Function Sal_pend_lote (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2, Pv_Lote IN Varchar2)return Number IS

--- Salidas pendientes lotes (Inventarios)

 Cursor C_Lote Is
 select nvl(sum(nvl(d.unidades,0)),0) unidades
 from arinme a, arinvtm b, arinml c, arinmo d
 where a.no_cia = Pv_cia
 and   c.bodega = DECODE(Pv_Bodega,'', c.bodega,Pv_Bodega)
 and   c.no_arti = Pv_arti
 and   d.no_lote = Pv_lote
 and   b.movimi = 'S'
 and   a.estado = 'P'
 and   a.no_cia = b.no_cia
 and   a.tipo_doc = b.tipo_m
 and   a.no_cia = c.no_cia
 and   a.no_docu = c.no_docu
 and   c.no_cia = d.no_cia
 and   c.no_docu = d.no_docu
 and   c.linea = d.linea;

   Ln_Pend Arinlo.salida_pend%type := 0;

   Begin
   Open C_Lote;
   Fetch C_Lote into Ln_Pend;
   If C_Lote%notfound Then
     Close C_Lote;
     return (Ln_Pend);
   else
     Close C_Lote;
     return (Ln_Pend);
   end if;
   End;

 Function Sal_pend_Tr_lote (Pv_Cia  IN Varchar2, Pv_Bodega IN Varchar2, Pv_Arti IN Varchar2, Pv_lote IN Varchar2)return Number IS

--- Salidas pendientes lotes (Inventarios - transferencias)

 ---- bod orig son salidas
  Cursor C_Lote Is
  select nvl(sum(nvl(c.unidades,0)),0) unidades
  from arinte a, arintl b, arinto c
  where a.no_cia = Pv_cia
  and   b.bod_orig = DECODE(Pv_Bodega,'',b.bod_orig ,Pv_Bodega)
  and   b.no_arti = Pv_Arti
  and   c.no_lote = Pv_Lote
  and a.estado = 'P'
  and nvl(c.unidades,0) > 0
  and a.no_cia = b.no_cia
  and a.no_docu = b.no_docu
  and b.no_cia = c.no_cia
  and b.no_docu = c.no_docu
  and b.no_arti = c.no_arti;

   Ln_Pend Arinlo.salida_pend%type := 0;

   Begin
   Open C_Lote;
   Fetch C_Lote into Ln_Pend;
   If C_Lote%notfound Then
     Close C_Lote;
     return (Ln_Pend);
   else
     Close C_Lote;
     return (Ln_Pend);
   end if;
   End;


end INPENDIENTE;
/
