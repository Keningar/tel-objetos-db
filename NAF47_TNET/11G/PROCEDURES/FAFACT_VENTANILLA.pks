create or replace procedure            FAFACT_VENTANILLA ( pno_cia      IN varchar2,
                                                pno_centro   IN varchar2,
                                                pno_transa   IN varchar2,   -- pedido
                                                pno_cliente  IN varchar2,
                                                psubcliente  IN varchar2,
                                                ptipo_despacho      IN varchar2,
                                                pfecha              IN varchar2,
                                                pmoneda             IN varchar2,
                                                ptot_lin            IN varchar2,
                                                pind_desp_completo  IN varchar2,
                                                pno_control         IN OUT varchar2,
                                                pno_docu            IN OUT varchar2,
                                                msg_error_p         IN OUT varchar2) IS

/*
  Este proceso creara el rastro de Picking pero de forma transparente al Usuario, solamenete se generara la
  inf. por un pedido (1 Pedido- 1 Picking) por tipo de despacho 'Ventanilla'
*/
---------------add mlopez 25/05/2010-------------------------------------------------------------
Cursor C_Distrib_grupo(cv_grupo varchar2) Is
	select tipo_cliente
	from   arfa_distrib_grupo
	where  no_cia          = pno_cia
  and   (grupo           = nvl(cv_grupo,'%') or grupo = '%')
  and   (no_cliente      = nvl(pno_cliente,'%') or no_cliente = '%')
  and   (no_sub_cliente  = nvl(psubcliente,'%') or no_sub_cliente = '%')
    and (division, subdivision) IN
	      (select distinct b.division, b.subdivision
				 from arfafec a, arfaflc b
				 where a.no_cia      = pno_cia
				 and   a.no_factu = pno_transa
				 and   b.linea_art_promocion is null
				 and   a.no_cia      = b.no_cia
				 and   a.no_factu   = b.no_factu) ---- para pedido
 UNION
	select tipo_cliente
	from   arfa_distrib_grupo
	where  no_cia          = pno_cia
  and   (grupo           = nvl(cv_grupo,'%') or grupo = '%')
  and   (no_cliente      = nvl(pno_cliente,'%') or no_cliente = '%')
  and   (no_sub_cliente  = nvl(psubcliente,'%') or no_sub_cliente = '%')
	and    subdivision     = '%'
  and   (division) IN
        (select distinct b.division
			   from arfafec a, arfaflc b
			   where a.no_cia      = pno_cia
			   and   a.no_factu = pno_transa
			   and   b.linea_art_promocion is null
			   and   a.no_cia      = b.no_cia
			   and   a.no_factu = b.no_factu);

 lc_distrib_grupo C_Distrib_grupo%rowtype;

cursor c_politica(cv_linea varchar2) is
 select x.division_art division
  from arfadet_politica_comercial x
 where x.no_cia=pno_cia
  and x.linea=cv_linea;

lc_politica c_politica%rowtype;

cursor c_articulo_pol(cv_arti varchar2) is
 select division,subdivision
  from arinda
 where no_arti=cv_arti;

 lc_articulo_pol c_articulo_pol%rowtype;

cursor c_cliente is
 select a.no_cliente,a.tipo_cliente,a.grupo,b.division_comercial
  from arccmc a,arfafec b
 where a.no_cia=pno_cia
  and a.no_cliente=pno_cliente
  and a.no_cia=b.no_cia
  and a.no_cliente=b.no_cliente;

  lc_cliente c_cliente%rowtype;

Cursor C_Detalle (lv_division varchar2,lv_tipo_cliente Varchar2,lv_grupo varchar2,lv_division_comercial varchar2,
                  ln_valor number) Is
select a.secuencia, a.fecha_desde, a.fecha_hasta, a.centro_distribucion ,
        b.fecha_inicio, b.fecha_fin, b.tipo_cliente, b.grupo, b.no_cliente, b.division_comercial,
				b.division_art, b.subdivision_art, b.no_arti, b.porc_descuento, b.precio, b.cant_minima,
				b.cant_maxima, b.unidades, b.no_arti_alterno,
				b.obligatorio, b.linea, b.tipo_promocion, b.subcliente
  from arfaenc_politica_comercial a, arfadet_politica_comercial b
	where a.no_cia = pno_cia
	and trunc(to_date(pfecha,'DD/MM/YYYY')) between trunc(b.fecha_inicio) and trunc(b.fecha_fin)
  and (centro_distribucion = pno_centro or centro_distribucion = '%')
  and b.division_art=lv_division
  and (tipo_cliente = Lv_tipo_cliente or tipo_cliente = '%')
  and (grupo = lv_grupo or grupo = '%')
  and (no_cliente = pno_cliente or no_cliente = '%')
  and (subcliente = psubcliente or subcliente = '%')
  and (division_comercial = lv_division_comercial or division_comercial = '%')
  and nvl(ln_valor,0) between nvl(b.cant_minima,1) and nvl(b.cant_maxima,99999999999999999999999)
	and a.ind_activo = 'S'
	and b.ind_activo = 'S'
	and b.tipo_promocion = 'E' ---- Las escalas son por el total de la proforma o el pedido
  and exists
     (
      select y.division, y.subdivision
			 from arfafec x, arfaflc y
			where x.no_cia   = pno_cia
			 and  x.no_factu = pno_transa
			 and  y.linea_art_promocion is null
			 and  x.no_cia   = y.no_cia
			 and  x.no_factu = y.no_factu
			 and  (y.division=b.division_art or b.division_art='%')
			  --si se detallaron subdivisiones, que las subdivisiones formen parte de la lista
			  --si no es asi TODAS las subdivisiones
  		  and ((exists
  		      (
  		        select u.no_cia from arfadet_politica_comercial_esc u
  		        where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		        and u.linea=b.linea and ind_activo='S'
  		      )and y.subdivision in
  		       (select u.subdivision_art from arfadet_politica_comercial_esc u
  		        where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		        and u.linea=b.linea and ind_activo='S')) or
  		       (not exists
  		        (
  		         select u.no_cia from arfadet_politica_comercial_esc u
  		         where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		         and u.linea=b.linea and ind_activo='S'
  		         ) and b.subdivision_art='%'))
		 ) --- PARA PEDIDOS
  and a.no_cia = b.no_cia
	and a.secuencia = b.secuencia
  order by 5;

 lc_detalle c_detalle%rowtype;
 ---------------fin add mlopez 25/05/2010-*-----------------------------------------------

	Cursor C_Cliente_Especial(pCtrl varchar2)  IS
		Select 'X'
		  from arfa_aux_cab_picking e, arfa_aux_cab_picking d, arcclocales_clientes l
		 Where e.no_cia   = pno_cia
		   and e.centrod  = pno_centro
		   and e.num_ctrl = pCtrl
		   and e.no_cia   = d.no_cia
		   and e.centrod  = d.centrod
		   and e.no_factu = d.no_factu
		   and e.no_cia     = l.no_cia
		   and e.no_cliente = l.no_cliente
		   and e.subcliente = l.no_sub_cliente
		   and l.categoria  = 'A'
		   and rownum = 1;

	Cursor C_Articulo_Distrib(pCtrl varchar2)  IS
		Select no_cia, centrod, bodega, no_arti
		  from arfaflc
		 Where no_cia = pno_cia
		   and centrod = pno_centro
		   and bodega != '0000' ---- no debe recuperar servicios para el picking ANR 13/10/2009
		   and no_factu in (Select no_factu
                          from arfa_aux_cab_picking
		                     Where no_cia   = pno_cia
		                       and centrod  = pno_centro
                           and num_ctrl = pCtrl)
		Group by no_cia, centrod, bodega, no_arti;


	Cursor C_Detalle_Aux (pNoFactu varchar2) IS
		Select p.no_linea ,    p.bodega, p.no_arti, p.pedido, p.cantidad_adicional,
           p.tipo_precio,  p.precio, p.Linea_Art_Promocion, p.solicita_transferencia,
           p.porc_desc + nvl(descuento_adicional,0) porc_desc,    p.descuento
		  from arfaflc p
		 Where p.no_cia   = pno_cia
		   and p.centrod  = pno_centro
		   and p.bodega != '0000' ---- no debe recuperar servicios para el picking ANR 13/10/2009
		   and p.no_factu = pNoFactu
		order by 1;

	-- Todos los articulos a los cuales voy a distribuir las unidades
	Cursor C_Articulo_Distribuye(pCtrl varchar2, pBodega varchar2, pArti varchar2) IS
		Select NO_CIA, CENTROD,     NUM_CTRL,    NO_FACTU,     LINEA_CAB,   LINEA_DET,
           BODEGA, NO_ARTICULO, CANT_PEDIDO, CANT_PICKING, TOTAL_LINEA, TIPO_PRECIO,
           LINEA_ART_PROMOCION
		  from arfa_aux_det_picking
		 Where no_cia   = pno_cia
			 and centrod  = pno_centro
			 and num_ctrl = pCtrl
		   and bodega   = pBodega
		   and no_articulo = pArti
		   and ind_procesa = 'S'
		 order by nvl(categoria,'Z'), NO_FACTU, linea_det;


	Cursor C_Total_Aux_Picking(pCtrl varchar2) IS
	  Select NO_CIA,  CENTROD,  NUM_CTRL,     NO_FACTU,     LINEA,         NO_CLIENTE,    SUBCLIENTE,  TIPO_DESPACHO,
	         FECHA,   MONEDA,   TOTAL_PEDIDO, MONTO_MINIMO, TOTAL_PICKING, TIPO_CAMBIO,   IND_DESP_COMPLETO
	    from arfa_aux_cab_picking
	   where no_cia   = pno_cia
	     and centrod  = pno_centro
	     and ind_procesa = 'S'
	     and num_ctrl = pCtrl;


  Cursor C_Detalle_promociones (pNoFactu varchar2) IS
		Select p.no_cia,         p.no_pedido,      p.no_linea,    p.secuencia_politica, p.linea_politica,
		       p.tipo_promocion, p.porc_descuento,
		       p.precio,         nvl(p.cant_minima,1) cant_minima, nvl(p.cant_maxima,999999999) cant_maxima,
		       p.unidades,           p.arti_alterno
		  from arfapromo_flc p
		 Where p.no_cia    = pno_cia
		   and p.no_pedido = pNoFactu
		   and p.tipo_promocion not in ('B','E');


	Cursor C_Compara_Promociones(pCtrl varchar2, pNoFactu varchar2, pLinea varchar2) IS
		Select a.no_articulo, a.cant_pedido,         a.cant_picking, a.tipo_precio,
		       a.precio,      a.linea_art_promocion, a.porc_desc,    a.descuento
		from arfa_aux_det_picking a
		where no_cia   = pno_cia
		 and centrod   = pno_centro
		 and ind_procesa = 'S'
		 and num_ctrl  = pCtrl
		 and no_factu  = pNoFactu
		 and linea_det = pLinea;


	Cursor C_Existe_solicitud (pCtrl varchar2) IS
	  Select 'x'
	    from arfa_aux_cab_picking
	   where no_cia   = pno_cia
	     and centrod  = pno_centro
	     and ind_procesa = 'S'
       and bodega_transferencia is not null
       and rownum = 1
	     and num_ctrl = pCtrl;


	Cursor C_bodegas_solicitud(pCtrl varchar2) IS
	  Select distinct(bodega_transferencia) bodega, b.centro
	    from arfa_aux_cab_picking c, arinbo b
	   where c.no_cia   = pno_cia
	     and c.centrod  = pno_centro
	     and c.ind_procesa = 'S'
       and c.bodega_transferencia is not null
	     and c.num_ctrl = pCtrl
       and c.no_cia = b.no_cia
       and c.bodega_transferencia = b.codigo;


	Cursor C_Existe_detalle_solicitud (pCtrl varchar2, pBodega varchar2) IS
    Select sum (nvl(cant_pedido,0) - nvl(cant_picking,0)) solicita
      from arfa_aux_det_picking
	   where no_cia   = pno_cia
	     and centrod  = pno_centro
       and no_factu in (Select NO_FACTU
                    	    from arfa_aux_cab_picking
                    	   where no_cia   = pno_cia
                    	     and centrod  = pno_centro
                    	     and ind_procesa = 'S'
                           and bodega_transferencia = pBodega
                    	     and num_ctrl = pCtrl)
       and solicita_transferencia = 'S'
       and ind_procesa = 'S'
       and (cant_pedido - cant_picking) > 0;

	Cursor C_detalle_solicitud_arti (pCtrl varchar2, pBodega varchar2) IS
    Select no_factu, linea_det, no_articulo, nvl(cant_pedido,0) - nvl(cant_picking,0) solicita
      from arfa_aux_det_picking
	   where no_cia   = pno_cia
	     and centrod  = pno_centro
       and no_factu in (Select NO_FACTU
                    	    from arfa_aux_cab_picking
                    	   where no_cia   = pno_cia
                    	     and centrod  = pno_centro
                    	     and ind_procesa = 'S'
                           and bodega_transferencia = pBodega
                    	     and num_ctrl = pCtrl)
       and solicita_transferencia = 'S'
       and ind_procesa = 'S'
       and (cant_pedido - cant_picking) > 0
     order by no_factu, linea_det, no_articulo;


	Cursor C_detalle_solicitud (pCtrl varchar2, pBodega varchar2) IS
    Select no_articulo, sum(nvl(cant_pedido,0)) - sum(nvl(cant_picking,0)) solicita
      from arfa_aux_det_picking
	   where no_cia   = pno_cia
	     and centrod  = pno_centro
       and no_factu in (Select NO_FACTU
                    	    from arfa_aux_cab_picking
                    	   where no_cia   = pno_cia
                    	     and centrod  = pno_centro
                    	     and ind_procesa = 'S'
                           and bodega_transferencia = pBodega
                    	     and num_ctrl = pCtrl)
       and solicita_transferencia = 'S'
       and ind_procesa = 'S'
       and (cant_pedido - cant_picking) > 0
       group by no_articulo;


	Cursor C_detalle_solicitud_FACTU (pCtrl varchar2, pBodega varchar2) IS
    Select no_cia, num_ctrl, no_factu
	    from arfa_aux_cab_picking
	   where no_cia   = pno_cia
	     and centrod  = pno_centro
	     and ind_procesa = 'S'
       and bodega_transferencia = pBodega
	     and num_ctrl = pCtrl;


	Cursor C_Total_Distribuye(pCtrl varchar2, pNoFactu varchar2) IS
		Select sum(total_linea)
		  from  arfa_aux_det_picking
		Where no_cia   = pno_cia
		  and centrod  = pno_centro
		  and num_ctrl = pCtrl
		  and ind_procesa = 'S'
		  and no_factu = pNoFactu;


  Cursor C_Porcentaje_Pedido  IS
		Select porc_acept_pedido
		  from arfamc
		 Where no_cia = pno_cia;


	Cursor C_Articulo_Lote (pArticulo varchar2) is
		Select ind_lote
		  From arinda
		 Where no_cia = pno_cia
		   and no_arti = pArticulo;


	Cursor C_Picking_Pedido_Cab (pCtrl varchar2, pNoFactu varchar2) IS
		Select k.no_factu,     k.linea_det,   k.bodega, k.no_articulo, k.cant_pedido,
		       k.cant_picking, k.total_linea, k.precio, k.porc_desc,   k.descuento
		  from arfa_aux_det_picking k
		 Where no_cia   = pno_cia
		   and centrod  = pno_centro
		   and num_ctrl = pCtrl
		   and ind_procesa = 'S'
		   and no_factu = pNoFactu;


	Cursor C_Picking_Detalle(pCtrl varchar2) IS
		Select no_cia, centrod, bodega, no_articulo, sum(cant_pedido) pedido, sum(cant_picking) picking
		 From arfa_aux_det_picking
		Where no_cia   = pno_cia
			and centrod  = pno_centro
			and num_ctrl = pCtrl
			and ind_procesa = 'S'
		Group by no_cia, centrod, bodega, no_articulo;


	Cursor C_Existe_Detalle_Picking(pCtrl varchar2) IS
		Select nvl(sum(cant_picking),0) cantidad
		 From arfa_aux_det_picking
		Where no_cia   = pno_cia
			and centrod  = pno_centro
			and num_ctrl = pCtrl
			and ind_procesa = 'S';


	Cursor C_articulo (pArticulo varchar2) IS
		Select d.division, d.subdivision
		  from arinda d
		 Where no_cia  = pno_cia
		   and no_arti = pArticulo;

	CURSOR C_siguiente  is
	  Select (NVL(MAX(NO_SOLICITUD),0)+1) siguiente
      From arinenc_solicitud
     Where no_cia = pno_cia;

  Cursor C_dia_proceso  is
    Select dia_proceso_fact
      from arincd
     where no_cia = pno_cia
       and centro = pno_centro;


  Cursor C_emple_division  is
     Select me.no_emple, me.division
       from arplme me
      where me.no_cia = pno_cia
        and me.usuario = user;

  ---- Se pone comentario a esta parte porque no esta bien.. no se puede comparar usuario con maestro de empleados
  ---- averiguar bien como hacer, se va a dejar nulo, ya que los campos son opcionales ANR 09/12/2009
  Cursor C_bodega_destino  is
     Select codigo
       from arinbo
      Where no_cia = pno_cia
        and centro =  pno_centro
        and tipobodega = 'A'
        and principal = 'S'
        and rownum = 1;

  --- No debo considerar en el picking lo que este a punto de facturar ANR 08/09/2009
	Cursor C_Fact_Pend (Lv_bodega Varchar2, Lv_arti Varchar2) Is
	 select nvl(sum(nvl(b.pedido,0)),0) unidades
	 from   arfafe a, arfafl b
	 where  a.no_cia   = pno_cia
	 and    a.estado   = 'P'
	 and    b.bodega   = Lv_bodega
	 and    b.no_arti  = Lv_arti
	 and    a.no_cia   = b.no_cia
	 and    a.no_factu = b.no_factu;

  Cursor C_pedido_pend (pCtrl varchar2, pBodega varchar2, pArticulo varchar2) IS
		Select NVL(SUM(NVL(PEDIDO,0)+NVL(CANTIDAD_ADICIONAL,0)),0) PEDIDO
		  from arfaflc
		 Where no_cia  = pno_cia
		   and centrod = pno_centro
		   and bodega != '0000' ---- no debe recuperar servicios para el picking ANR 13/10/2009
       and bodega  = pBodega
       and no_arti = pArticulo
		   and no_factu in (Select no_factu
                          from arfa_aux_cab_picking
		                     Where no_cia   = pno_cia
		                       and centrod  = pno_centro
		                       and ind_procesa = 'S'
                           and num_ctrl = pCtrl);


  Cursor C_Promocion_Escala (pNoFactu varchar2) IS
		Select  distinct(p.linea_politica) linea_politica, p.cant_minima, p.cant_maxima, p.unidades, p.arti_alterno
		  from arfapromo_flc p
		 Where no_cia    = pno_cia
		   and no_pedido = pNoFactu
       and tipo_promocion = 'E';


  Cursor C_Total_Escala (pNoFactu varchar2, pLineaPolitica varchar2) Is
		Select  sum(l.cant_picking)
		  from arfapromo_flc p, arfa_aux_det_picking l
		 Where p.no_cia    = pno_cia
       and p.tipo_promocion = 'E'
		   and p.no_pedido = pNoFactu
       and p.linea_politica = pLineaPolitica
       and p.no_cia = l.no_cia
       and p.no_pedido = l.no_factu
       and p.no_linea  = l.linea_det
       and l.ind_procesa = 'S';


  Cursor C_Lineas_Escala (pNoFactu varchar2, pLineaPolitica varchar2) Is
		Select  k.no_cia, k.num_ctrl, k.no_factu, k.linea_det
			from arfapromo_flc p, arfaflc l, arfa_aux_det_picking k
		 Where p.no_cia    = pno_cia
       and p.tipo_promocion = 'E'
		   and p.no_pedido = pNoFactu
       and p.linea_politica = pLineaPolitica
       and p.no_cia    = l.no_cia
       and l.centrod   = pno_centro
       and p.no_pedido = l.no_factu
       and p.no_linea  = l.no_linea
       and p.no_cia    = k.no_cia
       and l.no_factu  = k.no_factu
       and l.centrod   = k.centrod
       and l.no_linea  = k.linea_det
       and k.ind_procesa = 'S';


  Cursor C_Lotes_Picking (pNoFactu varchar2) Is
			select e.no_cia,  e.no_docu_refe_picking, d.bodega, d.no_arti, l.no_lote, sum(l.unidades)unidades,
			       ubicacion, fecha_vence
			from arfafec e, arfaflc d, arfaflc_lote l
			where e.no_cia = pno_cia
			and e.centrod  = pno_centro
			and e.no_docu_refe_picking = pNoFactu
			and e.no_cia   = d.no_cia
			and e.no_factu = d.no_factu
			and d.no_cia   = l.no_cia
			and d.no_factu = l.no_factu
			and d.no_linea = l.no_linea
			and d.no_arti  = l.no_arti
			group by e.no_cia, e.no_docu_refe_picking, d.bodega, d.no_arti, l.no_lote, ubicacion, fecha_vence;

  Cursor C_Busca_Bonificacion (pNo_Pedido varchar2, pNo_Linea varchar2) Is
			Select cant_minima, unidades
			  from arfapromo_flc
			 Where no_cia = pno_cia
			   and no_pedido = pNo_Pedido
			   and tipo_promocion = 'B'
			   and no_linea = pNo_Linea;

  Cursor C_Busca_Venta (pNo_Pedido varchar2, pNum_Ctrl varchar2, pNo_Linea varchar2) Is
			Select cant_picking from arfa_aux_det_picking
			 Where no_cia    = pno_cia
			   and centrod   = pno_centro
			   and no_factu  = pNo_Pedido
			   and num_ctrl  = pNum_Ctrl
			   and linea_det = pNo_Linea;


  Cursor  C_local_Categoria is
    Select nvl(l.categoria,'Z') categoria , p.bodega_transferencia
    		from arfafec p, arcclocales_clientes l
    		Where p.no_cia = pno_cia
        and p.centrod  = pno_centro
        AND p.no_factu = pno_transa
        and p.no_cia = l.no_cia
        and p.grupo  = l.grupo
        and p.no_cliente = l.no_cliente
        and p.subcliente = l.no_sub_cliente
    		Order by fecha, no_fisico;

  Cursor C_Unidades_Transfereridas (pBodega varchar2, pArticulo varchar2) IS
		Select sum(nvl(pedido,0)-nvl(cant_transferencia,0)) transferidas from arfaflc
		 Where no_cia  = pno_cia
		   and centrod = pno_centro
		   and no_factu in  (Select no_factu from arfafec
		                      Where no_cia = pno_cia and centrod = pno_centro and estado='T'
                          /* Comentado por Manuel Yuquilima 21/06/2010
                          --add mlopez 14/06/2010
                          and no_factu<>pno_transa
                          --fin add mlopez 14/06/2010
                          */
                          )
	     and bodega  = pBodega
	     and no_arti = pArticulo;


  Cursor C_Unidades_Sugeridas (pBodega varchar2, pArticulo varchar2) IS
		Select sum(pedido) sugeridas
      from arfaflc
		 Where no_cia  = pno_cia
		   and centrod = pno_centro
		   and no_factu in  (Select no_factu from arfafec
		                      Where no_cia = pno_cia
                            and centrod = pno_centro
		                        and estado = 'Z'
                            and nvl(no_docu_refe_picking,'0') = '0'
                            )
	     and bodega  = pBodega
	     and no_arti = pArticulo;

/*Agregado por Manuel Yuquilima 21/06/2010*/
  Cursor C_Unidades_Pedido (pNum_Ctrl varchar2, pBodega varchar2, pArticulo varchar2) IS
		Select sum(nvl(cant_pedido,0))
		  from arfa_aux_det_picking
		 Where no_cia      = pno_cia
			 and centrod     = pno_centro
			 and num_ctrl    = pNum_Ctrl
			 and bodega      = pBodega
			 and no_articulo = pArticulo;
/*Fin de Agregado por Manuel Yuquilima 21/06/2010*/

	--
	  TYPE cant_distribuye IS RECORD (no_cia     arfafec.no_cia%type,
																    centrod    arfafec.centrod%type,
																    bodega     arinbo.codigo%type,
																    no_arti    arinda.no_arti%type,
                                    ind_lote   arinda.ind_lote%type,
																    cantidad   number);
	--
  TYPE arti_distrib IS TABLE OF cant_distribuye
    INDEX BY BINARY_INTEGER;
	--

	  vTabDistrib    arti_distrib;
		Lv_dummy       Varchar2(1);
		Ln_Stock       Arinma.sal_ant_un%type;
		Ln_pendientes  Arinma.pedidos_pend%type;
		--
		l              binary_integer;
	  j              number := 0;
	  i              number := 0;
	  m              number := 0;
	  n              number := 0;

	  vLineaPedido   number := 0;
	  vLineaPicking  number := 0;
	  vn_cantidad    number := 0;
	  --
	  vCant_distrib  number := 0;
	  vTotalDistrib  number := 0;
	 	vPorcentaje    number := 0;
	 	vInd_Lote      arinda.ind_lote%type := 'N';
	 	--
	 	vDivision      arinda.division%type;
	 	vSubdivision   arinda.subdivision%type;
	 	--
    vExiste_solic   varchar2(1) := '';
    vExiste_detalle number := 0;
    v_existe_transf varchar2(1) := 'N';
    --
    vError          VARCHAR2(300) := '';
    vn_total    	  number := 0;
    --
		Error_Proceso         EXCEPTION;
		Error_Proceso_Borra   EXCEPTION;
    --
    vn_docu         arinenc_solicitud.no_docu%type;
    vn_solicitud    arinenc_solicitud.no_solicitud%type;
    vd_dia_proceso  arincd.dia_proceso%type;
    vv_division     arplme.division%type;
    lv_emple        arplme.no_emple%type;
    vv_codigo       arinbo.codigo%type;
    vn_pedidos_pend arfafl.pedido%type;
    vn_precio       arfaflc.precio%type;

    Ln_cantidad       Arfafl.pedido%type := 0;
    Ln_fact_pend      Arfafl.pedido%type := 0;
    Ln_pendiente_real Arfafl.pedido%type := 0;

	  --*********************************************
	  dp_no_articulo  arfa_aux_det_picking.no_articulo%type;
	  dp_cant_pedido  arfa_aux_det_picking.cant_pedido%type;
	  dp_cant_picking arfa_aux_det_picking.cant_picking%type;
	  dp_tipo_precio  arfa_aux_det_picking.tipo_precio%type;
		dp_precio       arfa_aux_det_picking.precio%type;
		dp_porc_desc    arfa_aux_det_picking.porc_desc%type;
		dp_descuento    arfa_aux_det_picking.descuento%type;
		dp_linea_art_promocion arfa_aux_det_picking.linea_art_promocion%type;

    vn_cant_minima         arfapromo_flc.cant_minima%type;
    vn_unidades            arfapromo_flc.unidades%type;
    vn_unidad_promocion    arfaflc.pedido%type;
	  vn_unidades_total_pd   arfaflc.pedido%type;
	  vn_cant_venta          arfaflc.pedido%type;
	  vn_promocion           arfaflc.pedido%type;
	  vn_unidades_calculo    arfaflc.pedido%type;
	  vn_verifica_promocion  arfaflc.pedido%type;
	  vn_total_pedido        arfaflc.pedido%type;

    vno_control            arfa_aux_det_picking.num_ctrl%type;
    vno_docu               arfaenc_picking.no_docu%type;
    vLocal_Categoria       arcclocales_clientes.categoria%type;
    vbodega_transferencia  arinbo.codigo%type;
	  Ln_unid_transf         arfaflc.pedido%type;
    Ln_unid_sugeridas      arfaflc.pedido%type;

    Ln_unid_pedido         number;
BEGIN

 Begin

	  OPEN  C_dia_proceso;
	  FETCH C_dia_proceso into vd_dia_proceso;
	  CLOSE C_dia_proceso;

    -- Secuencia para Picking
	  FANUMERO_PICKING (pno_cia, pno_centro, vno_control, vError);  -- Numero de control para la tabla auiliar

    If vError is not null Then
       raise Error_Proceso;
    End if;

    pno_control := vno_control;

	  -- Porcentaje minimo configurado para realizar el despacho
	  Open  C_Porcentaje_Pedido;
	  Fetch C_Porcentaje_Pedido into vPorcentaje;
	  Close C_Porcentaje_Pedido;

	  Open  C_local_Categoria;
	  Fetch C_local_Categoria into vLocal_Categoria, vbodega_transferencia;
	  Close C_local_Categoria;


    -- Solo tmo en cuenta los registros marcados como 'INGRESA'
    If nvl(pno_transa,'0') <> '0'  Then
        -- Secuencia de linea
        vLineaPedido := vLineaPedido + 1;

        -- Insero la cabecera con los datos de los pedidos (ARFAFEC)
        Begin
        Insert into arfa_aux_cab_picking(no_cia,       centrod,              num_ctrl,
                                         no_factu,     linea,                no_cliente,
                                         subcliente,   tipo_despacho,        fecha,
                                         moneda,       total_pedido,         monto_minimo,
                                         categoria,    bodega_transferencia, ind_desp_completo)

                                 Values (pno_cia,       pno_centro,       vno_control,
                                         pno_transa,    vLineaPedido,     pno_cliente,
                                         psubcliente,   ptipo_despacho,   pfecha,
                                         pmoneda,       ptot_lin,         (ptot_lin*vPorcentaje)/100,
                                         vLocal_Categoria,    vbodega_transferencia, nvl(pind_desp_completo,'N'));
        Exception                                         -- pendiente
        When Others Then
         vError := 'Error al crear cabecera aux. de picking. Trans.: '||pno_transa||' '||SQLERRM;
         RAISE Error_Proceso;
        End;

         For det in C_Detalle_Aux(pno_transa) Loop
         Begin
            -- Inserto el detalle de los articulos por pedido (ARFAFLC)
            Insert into arfa_aux_det_picking(no_cia,        centrod,      num_ctrl,
                                             no_factu,      linea_cab,    linea_det,
                                             bodega,        no_articulo,  cant_pedido,
                                             cant_picking,  total_linea,  tipo_precio,
                                             precio,        Linea_Art_Promocion,
                                             solicita_transferencia,
                                             porc_desc,     descuento,    categoria)

                                    Values (pno_cia,     pno_centro,    vno_control,
                                            pno_transa,  vLineaPedido,  det.no_linea,
                                            det.bodega,     det.no_arti,   (nvl(det.pedido,0) + nvl(det.cantidad_adicional,0)),
                                            0,              0,             det.tipo_precio,
                                            det.precio,     det.Linea_Art_Promocion,
                                            det.solicita_transferencia,
                                            det.porc_desc,  det.descuento,  vLocal_Categoria);
          Exception
          When Others Then
           vError := 'Error al crear detalle aux. de picking. Trans.: '||pno_transa||' Articulo: '||det.no_arti||' '||SQLERRM;
           RAISE Error_Proceso;
          End;
        End loop;

    End if;

	 END;
    --
    l := 0;
	  --
    For  n  in C_Articulo_Distrib(vno_control) Loop
    	l := l + 1;
	    vTabDistrib(l).no_cia   := n.no_cia;
	    vTabDistrib(l).centrod  := n.centrod;
	    vTabDistrib(l).bodega   := n.bodega;
	    vTabDistrib(l).no_arti  := n.no_arti;
      --------------------------------------------
 	    -- Identifica si un articulo maneja lote
 	  	Open  C_Articulo_Lote(vTabDistrib(l).no_arti);
			Fetch C_Articulo_Lote into vInd_Lote;
			Close C_Articulo_Lote;
      vTabDistrib(l).ind_lote := vInd_Lote;
	    vTabDistrib(l).cantidad := 0;
    End Loop;

	  --**************************************************************
	  -- Lleno el BLOQUE  'DOS' CON LOS DATOS DE MEMORIA
	  --**************************************************************
	  Open  C_Cliente_Especial(vno_control);
	  Fetch C_Cliente_Especial into Lv_dummy;
	  Close C_Cliente_Especial;

	  --
	  -- *************************************************************************************************
	  -- Obtengo las cantidades a distribuir, si existe un solo cliente especial se obtiene  todo el stock
	  -- de acuerdo a esta condicion,  caso contrario obtengo el stock normal. (EXISTENCIAS ACTUALES)
	  -- *************************************************************************************************
	  FOR j IN 1 .. vTabDistrib.Count LOOP

      vn_pedidos_pend := 0;

			--- Se modifica forma de como asignar la cantidad porque habian casos de que habian existencias y no generaba valores en el picking ANR 08/09/2009
			--- Esta parte no se puede asignar para el global de articulos, por eso se la puso mas abajo en el programa
			articulo.desglose_existencias(vTabDistrib(j).no_cia, vTabDistrib(j).no_arti, vTabDistrib(j).bodega, Ln_Stock, Ln_pendientes);

      --- Si no tiene stock, en la cantidad a asignar debe ir directamente cero.
      If Ln_stock <= 0 Then
         Ln_cantidad := 0;
      else
      	 Ln_cantidad := Ln_stock;

         --- Adicional debo verificar si tengo en picking o no para disminuir cantidades en caso de que ya este separado en picking
         --- Si existen unidades pendientes de facturar no las debo tomar en cuenta
         Open C_Fact_Pend (vTabDistrib(j).bodega, vTabDistrib(j).no_arti);
			   Fetch C_Fact_Pend into Ln_fact_pend;
			   If C_Fact_Pend%notfound Then
			      Ln_fact_pend := 0;
			      Close C_Fact_Pend;
  			 else
	  		    Close C_Fact_Pend;
		  	 end if;

         Open  C_Unidades_Transfereridas (vTabDistrib(j).bodega, vTabDistrib(j).no_arti);
         Fetch C_Unidades_Transfereridas into Ln_unid_transf;
         close C_Unidades_Transfereridas;

         Open  C_Unidades_Sugeridas (vTabDistrib(j).bodega, vTabDistrib(j).no_arti);
         Fetch C_Unidades_Sugeridas into Ln_unid_sugeridas;
         close C_Unidades_Sugeridas;

         /*Agregado por Manuel Yuquilima 21/06/2010*/
         Open  C_Unidades_Pedido (vno_control, vTabDistrib(j).bodega, vTabDistrib(j).no_arti);
         Fetch C_Unidades_Pedido into Ln_unid_pedido;
         close C_Unidades_Pedido;
         /*Fin de Agregado por Manuel Yuquilima 21/06/2010*/

         Ln_cantidad := Ln_cantidad  -
                        nvl(articulo.Cant_Picking (vTabDistrib(j).no_cia, vTabDistrib(j).no_arti, vTabDistrib(j).bodega),0) -
                        nvl(Ln_fact_pend,0)   -
                        nvl(Ln_unid_transf,0) -
                        nvl(Ln_unid_sugeridas,0) +
                        nvl(Ln_unid_pedido,0);
      End if;

      If Ln_cantidad < 0 Then --- si al restar las cantidades con el picking me da un valor menor a cero, entonces debo asignar cero
      	 Ln_cantidad := 0;
      end if;

      --- En esta parte para clientes especiales y para clientes normales se guarda la cantidad maxima que seria el stock,
      --- ya que en este bloque dos se guarda en forma consolidada por articulo y por bodega ANR 08/09/2009
      vTabDistrib(j).cantidad := Ln_cantidad;

	  END LOOP;

    --*******************************************************************************************************
	  -- Llamada a proceso que se encargue  de hacer la distibucion, si la cantidad a distribuir no
	  -- alcanza para asignar a un pedido hay que verificar contra el stock actual y realizar la asignacion.
	  -- ******************************************************************************************************
    BEGIN
	  	--
		  --WHILE (:dos.bodega is not null)  and  (:dos.no_arti is not null)  LOOP
   	  FOR j IN 1 .. vTabDistrib.Count LOOP
	      --
			  vCant_distrib := nvl(vTabDistrib(j).cantidad,0);  -- Cantidad del sistema a Distribuir

        -- Articulos del detalle del auxiliar
				FOR det in C_Articulo_Distribuye(vno_control, vTabDistrib(j).bodega, vTabDistrib(j).no_arti)  LOOP


					--	Encero variables utilizadas por detalle de articulo
					vn_cant_minima := 0;
					vn_unidades    := 0;
					vn_unidad_promocion   := 0;
					vn_unidades_total_pd  := 0;
					vn_verifica_promocion := 0;
	        vn_total_pedido       := 0;


					If (det.bodega = vTabDistrib(j).bodega) and (det.no_articulo = vTabDistrib(j).no_arti)  Then
					    --
					    --- Para distribuir inicio con la cantidad global por articulo ANR 09/09/2009
					    --- En base a esa cantidad global debo repartir cantidades dependiendo el tipo de cliente (ESPECIAL o NORMAL)

					    Open  C_pedido_pend (vno_control, vTabDistrib(j).bodega, vTabDistrib(j).no_arti);
				  	  Fetch C_pedido_pend into vn_pedidos_pend; -- Aqui la cantidad pedida que se encuentra marcada que va a entrar en el picking
				  	  If C_pedido_pend%notfound Then
				  	  	vn_pedidos_pend := 0;
				  	    Close C_pedido_pend; --- Puede ser que marque uno o varios pedidos de diferentes clientes especiales o normales
				  	  else
				  	  	Close C_pedido_pend;
				  	  end if;

				  	  --- Si tengo mezclado clientes especiales con clientes normales en los pedidos que marque, por
				  	  --- lo menos si tengo un cliente especial me va a dar cierta cantidad.
				  	  --- Si tengo un solo cliente me daria cierta cantidad dependiendo el pedido que marque
							articulo.desglose_existencias(vTabDistrib(j).no_cia, vTabDistrib(j).no_arti, vTabDistrib(j).bodega, Ln_Stock, Ln_pendientes);

							--- Ln_pendientes es todo lo pedido incluido los pedidos que estoy seleccionando
							--- vn_pedidos_pend corresponde a los pedidos que estoy marcando para el picking
							--- Ln_pendiente_real corresponde a lo neto que esta en otros pedidos
							--- Si me sale un valor menor a cero deberia asignarle cero
							Ln_pendiente_real := Ln_pendientes - vn_pedidos_pend;

							If Ln_pendiente_real < 0 Then

								Ln_pendiente_real := 0;
							end if;


              --*****************************************************************************************
              --  Distribucion de articulos
              --*****************************************************************************************
					    If nvl(vCant_distrib,0) > 0  Then

									 -- Verifico si el articulo tiene relacionado una promocion
									 Open C_Busca_Bonificacion (det.no_factu, det.linea_det);
									 Fetch C_Busca_Bonificacion into vn_cant_minima, vn_unidades;
							     Close C_Busca_Bonificacion;

                 --*****************************************************
                 -- COMPRA CON PROMOCION
                 --*****************************************************

							     -- Si estos valores son mayores s cero es porque existe una promocion por Bonificacion
                   If 	(nvl(vn_cant_minima,0) > 0)   and  (nvl(vn_unidades,0) > 0)  and (nvl(det.LINEA_ART_PROMOCION,0) = 0)  Then

									     -- Estas unidades son las que debo de sumar a det.cant_pedido para saber si lo que tengo
									     -- por distribuir me alcanza con lo solicitado  O  si debo de hacer una disminucion
										    	                 --  ((unidades del pedido / unidades minimas) * unidades_bonificacion)

													  vn_verifica_promocion := (trunc(det.cant_pedido/nvl(vn_cant_minima,1))*nvl(vn_unidades,1));
													  vn_total_pedido       := det.cant_pedido + nvl(vn_unidad_promocion,0);

										   If	vn_total_pedido <= vCant_distrib  Then
													  vn_unidad_promocion  := (trunc(det.cant_pedido/nvl(vn_cant_minima,1))*nvl(vn_unidades,1));
													  vn_unidades_total_pd := det.cant_pedido + nvl(vn_unidad_promocion,0);

											 	    -- La cantidad a distribuir es mayor a lo que solicita la linea
												 	  Update arfa_aux_det_picking
												 	     set cant_picking = det.cant_pedido,
												 	         descuento = Moneda.Redondeo(nvl((Moneda.Redondeo((nvl(det.cant_pedido, 0)) * nvl(precio, 0), 'P')), 0) * ((nvl(porc_desc, 0)) / 100), 'P'), -- descuento
												 	         total_linea = Moneda.Redondeo((nvl(det.cant_pedido, 0)) * nvl(precio, 0), 'P')
												 	   Where no_cia   = pno_cia
															 and centrod  = pno_centro
															 and num_ctrl = det.num_ctrl
														   and bodega   = det.bodega
														   and linea_cab = det.linea_cab
														   and linea_det = det.linea_det
														   and no_articulo = det.no_articulo;

												 	  vCant_distrib := vCant_distrib - det.cant_pedido; -- Actualizo valor a disminuir


										   elsif 	(vn_total_pedido > vCant_distrib)  and (nvl(vCant_distrib,0) > 0)  Then

													  vn_unidad_promocion  := (trunc(vCant_distrib/nvl(vn_cant_minima,1))*nvl(vn_unidades,1));
													  vn_unidades_total_pd := vCant_distrib + nvl(vn_unidad_promocion,0);

										   	    -- Debo de recalcular las unidades a vender ya que no me alcanza para vender y promocionar lo pedido
										   	    vn_unidades_calculo :=(trunc ((nvl(vCant_distrib,0) - nvl(vn_unidad_promocion,0))/nvl(vn_cant_minima,1)) ) * vn_cant_minima;

												 	  Update arfa_aux_det_picking
												 	     set cant_picking = vn_unidades_calculo,  --vCant_distrib,
		  										 	          descuento = ((vn_unidades_calculo * nvl(precio,0))*nvl(porc_desc,0))/100,
												 	         total_linea  = (nvl(precio,0) * nvl(vn_unidades_calculo,0))
												 	   Where no_cia   = pno_cia
															 and centrod  = pno_centro
															 and num_ctrl = det.num_ctrl
														   and bodega   = det.bodega
														   and linea_cab = det.linea_cab
														   and linea_det = det.linea_det
														   and no_articulo = det.no_articulo;

					                 	   vCant_distrib := vCant_distrib - NVL(vn_unidades_calculo,0);
										   End if;
                   End if;


                 --*****************************************************
                 --PROMOCION
                 --*****************************************************

                 If  (nvl(det.LINEA_ART_PROMOCION,0) <> 0)  Then
										vn_cant_minima := 0;
										vn_unidades    := 0;

                   -- Busco la linea que genero la promocion para saber cuando asigno para la promocion
									 -- Verifico si el articulo tiene relacionado una promocion
									 Open C_Busca_Bonificacion (det.no_factu, det.LINEA_ART_PROMOCION);
									 Fetch C_Busca_Bonificacion into vn_cant_minima, vn_unidades;
							     Close C_Busca_Bonificacion;

									 Open  C_Busca_Venta (det.no_factu, vno_control, det.LINEA_ART_PROMOCION);
									 Fetch C_Busca_Venta into vn_cant_venta;
							     Close C_Busca_Venta;

							     -- Martha Navarrete M.  10/05/2010
							     -- Si en el pedido por el item '18718' tengo promocion  24+3 y compro 48 unidades se deben de asignar
							     -- 48+6 pero el usuario cambia 48+4 y esta disminucion en las unidades se debe de mantener.

                   vn_promocion := floor( trunc((vn_cant_venta/nvl(vn_cant_minima,1))) * vn_unidades);

                   If  nvl(vn_promocion,0)  >  nvl(det.cant_pedido,0)  Then
                   	 vn_promocion := det.cant_pedido;
                   End if;

                   -- Asignacion
	                 If	vn_promocion <= vCant_distrib  Then
								 	    -- La cantidad a distribuir es mayor a lo que solicita la linea
									 	  Update arfa_aux_det_picking
									 	     set cant_picking = vn_promocion,
									 	         descuento = Moneda.Redondeo(nvl((Moneda.Redondeo((nvl(vn_promocion, 0)) * nvl(precio, 0), 'P')), 0) * ((nvl(porc_desc, 0)) / 100), 'P'), -- descuento
									 	         total_linea = Moneda.Redondeo((nvl(vn_promocion, 0)) * nvl(precio, 0), 'P')
									 	   Where no_cia   = pno_cia
												 and centrod  = pno_centro
												 and num_ctrl = det.num_ctrl
											   and bodega   = det.bodega
											   and linea_cab = det.linea_cab
											   and linea_det = det.linea_det
											   and no_articulo = det.no_articulo;

									 	   vCant_distrib := vCant_distrib - vn_promocion;

	                 elsif 	(vn_promocion > vCant_distrib)  and (nvl(vCant_distrib,0) > 0)  Then

												 	  Update arfa_aux_det_picking
												 	     set cant_picking = vn_promocion,
													 	          descuento = Moneda.Redondeo(nvl((Moneda.Redondeo((nvl(vn_promocion, 0)) * nvl(precio, 0), 'P')), 0) * ((nvl(porc_desc, 0)) / 100), 'P'), -- descuento
													 	        total_linea = Moneda.Redondeo((nvl(vn_promocion, 0)) * nvl(precio, 0), 'P')
												 	   Where no_cia   = pno_cia
															 and centrod  = pno_centro
															 and num_ctrl = det.num_ctrl
														   and bodega   = det.bodega
														   and linea_cab = det.linea_cab
														   and linea_det = det.linea_det
														   and no_articulo = det.no_articulo;

												 	  vCant_distrib := vCant_distrib - vn_promocion;
	                 End if;
                End if;

                 --*****************************************************
                 -- COMPRA SIN PROMOCION
                 --*****************************************************
                 If (nvl(vn_cant_minima,0) =  0) and (nvl(vn_unidades,0) = 0) and (nvl(det.LINEA_ART_PROMOCION,0) = 0)  Then

											 If	det.cant_pedido <= vCant_distrib  Then

											 	    -- La cantidad a distribuir es mayor a lo que solicita la linea, pero debo de verificar
											 	    -- si es que tiene asignada alguna 'Promocion de Bonificacion' para didminuir la promocion
												 	  Update arfa_aux_det_picking
												 	     set cant_picking = det.cant_pedido,
												 	         descuento = Moneda.Redondeo(nvl((Moneda.Redondeo((nvl(det.cant_pedido, 0)) * nvl(precio, 0), 'P')), 0) * ((nvl(porc_desc, 0)) / 100), 'P'), -- descuento
												 	         total_linea = Moneda.Redondeo((nvl(det.cant_pedido, 0)) * nvl(precio, 0), 'P')
												 	   Where no_cia   = pno_cia
															 and centrod  = pno_centro
															 and num_ctrl = det.num_ctrl
														   and bodega   = det.bodega
														   and linea_cab = det.linea_cab
														   and linea_det = det.linea_det
														   and no_articulo = det.no_articulo;

												 	  vCant_distrib := vCant_distrib - det.cant_pedido;

											 elsif 	(det.cant_pedido > vCant_distrib)  and (nvl(vCant_distrib,0) > 0)  Then

												 	  Update arfa_aux_det_picking
												 	     set cant_picking = vCant_distrib,
		  										 	          descuento = ((vCant_distrib * nvl(precio,0))*nvl(porc_desc,0))/100,
												 	         total_linea  = (nvl(precio,0) * nvl(vCant_distrib,0))
												 	   Where no_cia   = pno_cia
															 and centrod  = pno_centro
															 and num_ctrl = det.num_ctrl
														   and bodega   = det.bodega
														   and linea_cab = det.linea_cab
														   and linea_det = det.linea_det
														   and no_articulo = det.no_articulo;

												 	  vCant_distrib := 0;

											 End if;
                 End if;
                 --*****************************************************
							End if;	 -- If nvl(vCant_distrib,0) > 0  Then
					    --
					End if;
					--
				END LOOP;
		    --
		  END LOOP;
		  --
	  END;

		-----------------------------------------------------------------------
		-- Se graban en sesion las tablas auxiliares
	  --:system.message_level := 5;
		  --Post;
	--	:system.message_level := 0;

	  -- *********************************************************************************
	  -- Verificacion de que el pedido tiene asociado Solicitud de Transferencias
	  -- *********************************************************************************
	  -- Verifico que existe bodegas entre los pedidos de picking

	  Open  C_Existe_solicitud (vno_control);
	  Fetch C_Existe_solicitud into vExiste_solic;
	  Close C_Existe_solicitud;

	  If vExiste_solic is not null Then

			  -- Obtengo las bodegas relacionadas a la solicitud
		    For bod in  C_bodegas_solicitud (vno_control)  Loop
				    --
				    -- Por cada bodega verifico que exista un detalle
					  Open  C_Existe_detalle_solicitud (vno_control, bod.bodega);
					  Fetch C_Existe_detalle_solicitud into vExiste_detalle;
					  Close C_Existe_detalle_solicitud;

            If vExiste_detalle > 0   Then
            	  -- Creo la cabecera de la solicitud
						  	vn_docu := transa_id.inv(pno_cia );
						    --
								Open  C_siguiente;
								Fetch C_siguiente into vn_solicitud;
								Close C_siguiente;
                --
  			    	  OPEN  C_emple_division;
							  FETCH C_emple_division into lv_emple, vv_division;
							  If C_emple_division%notfound Then
							   CLOSE C_emple_division;
							  else
							   CLOSE C_emple_division;
							  end if;

							  --
							  OPEN  C_bodega_destino;
							  FETCH C_bodega_destino into vv_codigo;
							  CLOSE C_bodega_destino;
							  --

								-- Pedido por IQUINDE LH e-mail 10/12/2009
							  -- La solicitud de transferencia generada a partir del picking se esta generando con fecha en nulo y con el centro incorrecto, se genera con el
						    -- centro de donde se origina la solicitud y ni en  el centro a donde se esta solicitando para que pueda ser vista desde alli.

				        -- INSERCION DE LA CABECERA
				        BEGIN
						        INSERT  INTO arinenc_solicitud (NO_CIA,         NO_DOCU,          NO_SOLICITUD,
						                                        FECHA,          NO_DOCU_REFE,     NO_EMPLE,
						                                        NO_DIVISION,
						                                        BODEGA_ORIGEN,    BODEGA_DESTINO,
						                                        ESTADO,         OBSERV1,          CENTRO,
						                                        USUARIO,        TIME_STAMP,       ORIGEN)

						                               values  (pno_cia,  vn_docu,                 vn_solicitud,
						                                        vd_dia_proceso,    vno_control,      lv_emple,
						                                        vv_division,
						                                        bod.bodega,              vv_codigo,
						                                        'P',               'FA - Solicitud generada desde proceso de Picking ',  bod.centro,
						                                        user,              sysdate,                 'FA');
									Exception
				    	    When Others Then
				    	     vError := 'Error al crear cabecera de solicitud. Docu.: '||vn_docu||' Picking: '||vno_control||' '||SQLERRM;
				       	   RAISE Error_Proceso;
							  End;

							  /* Agregado por Manuel Yuquilima 16/06/2010 para control de unidades de transferencia */

							  For det_solic in  C_detalle_solicitud_arti(vno_control, bod.bodega) Loop
						        --
						        -- Genero las lineas por detalle de solicitud
							      Begin

							  	    update arfaflc
							  	       set cant_transferencia = det_solic.solicita
							  	     where no_cia   = pno_cia
							  	       and no_factu = det_solic.no_factu
							  	       and no_arti  = det_solic.no_articulo
							  	       and no_linea = det_solic.linea_det;

										  Exception
					    	      When Others Then
					    	        vError := 'Error al crear detalle de solicitud. Docu.: ' ||vn_docu||' Articulo: '||det_solic.no_articulo||' '||SQLERRM;
					       	      RAISE Error_Proceso;
									  End;
							  End Loop;

							  --
							  For det_solic in  C_detalle_solicitud(vno_control, bod.bodega) Loop
						        --
						        -- Genero las lineas por detalle de solicitud
						     Begin
                    INSERT  INTO arindet_solicitud (NO_CIA,            NO_DOCU,  NO_ARTI,                CANTIDAD)
                                            Values (pno_cia,  vn_docu,  det_solic.no_articulo,  det_solic.solicita);
										Exception
					    	    When Others Then
					    	     vError := 'Error al crear detalle de solicitud. Docu.: ' ||vn_docu||' Articulo: '||det_solic.no_articulo||' '||SQLERRM;
					       	   RAISE Error_Proceso;
									End;
							  End Loop;
							  --
							  --
							  For no_factu in  C_detalle_solicitud_factu (vno_control, bod.bodega) Loop
									  -- Cambio el estado a los pedidos que tienen relacionado una transferencia
                    Begin
						    		Update arfafec
						    		   set estado = 'T',
						    		       no_docu_solicitud = vn_docu
						    		 Where no_cia   = pno_cia
										   and centrod  = pno_centro
										   and no_factu = no_factu.no_factu;
										Exception
							      When Others Then
							       vError := 'Error al actualizar cabecera de pedido. Pedido: '||no_factu.no_factu||' '||SQLERRM;
							 	     RAISE Error_Proceso;
						        End;

										Update arfa_aux_det_picking
										   set ind_procesa = 'N'
						    		 Where no_cia   = pno_cia
										   and centrod  = pno_centro
										   and num_ctrl = vno_control
										   and no_factu = no_factu.no_factu;

										Update arfa_aux_cab_picking
										   set ind_procesa = 'N'
						    		 Where no_cia   = pno_cia
										   and centrod  = pno_centro
										   and num_ctrl = vno_control
										   and no_factu = no_factu.no_factu;
							      --
							      v_existe_transf := 'S';
							      --
							  End Loop;
            End if;
        End Loop;
		    --
    End if;


	  /* ****************************************************************************************************
	     REPROCESO DE ASIGNACION DE PROMOCIONES, LUEGO DE LA ASIGNACION DE PICKING
	     Cada linea de articulos asignados en el picking deben ser verificadas contra las
	     promociones asignadas :

	     Bonificacion -> De acuerdo a la ordenacion nunca se asignara primero las unidades de  promocion
	                     y luego las unidades que van a cobrarse, por lo cual no hay cambio que realizar.

	     Descuento    -> Si la cantidad asignada no esta entre el rango minimo y maximo entonces
	                     debo de alterar el % de descuento a 0% (Se aplica a articulo).

	     Precio       -> Si la cantidad asignada no esta entre el rango minimo y maximo entonces
	                     debo de poner el precio actual.

	     Escala       -> Si la cantidad asignada sumarizada por grupo y subgrupo no esta entre el rango minimo
	                     y maximo entonces debo de alterar el % de descuento a 0% (Se aplica a grupo y subgrupo de articulos) 	  */
	  -- ******************************************************************************************************

	  --Obtengo todos los pedidos relacionados en el auxiliar del Picking

	  For  pedido in C_Total_Aux_Picking(vno_control) Loop

	      --Por cada pedido debo de obtener las promociones aplicadas
	      For  detalle in C_Detalle_promociones (pedido.no_factu)  Loop

			       -- Obtener la linea que tiene esta promocion para hacer las validaciones de acuerdo a cantidades.
	        	 Open  C_Compara_Promociones (vno_control, pedido.no_factu, detalle.no_linea);
		         Fetch C_Compara_Promociones into dp_no_articulo,  dp_cant_pedido,  dp_cant_picking,
		                                          dp_tipo_precio,  dp_precio,       dp_linea_art_promocion,
		                                          dp_porc_desc,    dp_descuento;
	        	 Close C_Compara_Promociones;

			       -- PRECIO
			       If detalle.tipo_promocion = 'P'  Then
			       	  If nvl(dp_cant_picking,0) > 0  Then
		                If (dp_cant_picking <  detalle.cant_minima)  Then

					        	  -- Debo de obtener el precio normal del articulo
					        	  FaVentanilla_Trae_Precio (pno_cia, pedido.moneda , dp_tipo_precio , dp_no_articulo, pedido.tipo_cambio, vn_precio, vError);

                      IF vError IS NOT NULL THEN
					             	 RAISE Error_Proceso;
					            END IF;

					        	  --Cambio el precio
			        	      Update arfa_aux_det_picking
									       set precio = vn_precio,
									           total_linea = nvl(cant_picking,0) * nvl(vn_precio,0),
									            descuento = Moneda.Redondeo(nvl((Moneda.Redondeo((nvl(cant_picking, 0)) * nvl(vn_precio, 0), 'P')), 0) * ((nvl(porc_desc, 0)) / 100), 'P') -- descuento
											 where no_cia    = pno_cia
												 and centrod   = pno_centro
												 and num_ctrl  = vno_control
												 and no_factu  = pedido.no_factu
												 and linea_det = detalle.no_linea;
                    End if;
			        	End if;
			       End if;

			       -- DESCUENTO
			       If detalle.tipo_promocion = 'D'  Then
			       	  If nvl(dp_cant_picking,0) > 0  Then
		                If (dp_cant_picking <  detalle.cant_minima) Then -- or (dp_cant_picking > detalle.cant_maxima) Then

					        	  --Cambio el descuento
			        	      Update arfa_aux_det_picking
									       set porc_desc = 0,
									           descuento = 0,
									           total_linea = nvl(cant_picking,0) * nvl(precio,0)
											 where no_cia    = pno_cia
												 and centrod   = pno_centro
												 and num_ctrl  = vno_control
												 and no_factu  = pedido.no_factu
												 and linea_det = detalle.no_linea;
                    End if;
			        	End if;
			       End if;
	      End Loop;
	   End Loop;


	      -- ESCALA
	      For  pedido in C_Total_Aux_Picking(vno_control) Loop

		      For escala in C_Promocion_Escala(pedido.no_factu)  Loop
				     -- Obtengo la cantidad a comparar
				     vn_total := 0;

				     Open  C_Total_Escala(pedido.no_factu, escala.linea_politica);
				     Fetch C_Total_Escala into vn_total;
				     Close C_Total_Escala;

				     If (nvl(vn_total,0) < nvl(escala.cant_minima,0)) Then --Or nvl(vn_total,0) > nvl(escala.cant_maxima,999999999)  Then
				         -- Busco todas las lineas en donde se aplico la promocion escala para actualizar
                 -------------ADD MLOPEZ 25/05/2010------------------------------------------------
                 open c_cliente;
                 fetch c_cliente into lc_cliente;
                 close c_cliente;

                 open C_Distrib_grupo(lc_cliente.grupo);
                 fetch C_Distrib_grupo into lc_distrib_grupo;
                 close C_Distrib_grupo;

                 open c_politica(escala.linea_politica);
                 fetch c_politica into lc_politica;
                 close c_politica;

                 open c_articulo_pol(lc_politica.division);
                 fetch c_articulo_pol into lc_articulo_pol;
                 close c_articulo_pol;

                 open c_detalle (lc_articulo_pol.division,lc_distrib_grupo.tipo_cliente,
                                 lc_cliente.grupo,lc_cliente.division_comercial,nvl(vn_total,0));
                 fetch c_detalle into lc_detalle;

                 if c_detalle%notfound then
    				         For linea in C_Lineas_Escala(pedido.no_factu, escala.linea_politica) Loop
    				        	  --Cambio el descuentO
    		        	      Update arfa_aux_det_picking
    								       set porc_desc = 0,
    								           descuento = 0,
    								           total_linea = nvl(cant_picking,0) * nvl(precio,0)
    										 where no_cia    = pno_cia
    											 and centrod   = pno_centro
    											 and num_ctrl  = linea.num_ctrl
    											 and no_factu  = pedido.no_factu
    											 and linea_det = linea.linea_det;
    								 End Loop;
                 else
                     For linea in C_Lineas_Escala(pedido.no_factu, escala.linea_politica) Loop
    				        	  --Cambio el descuento
    		        	      Update arfa_aux_det_picking
    								       set porc_desc = lc_detalle.porc_descuento,
    								           descuento = (nvl(cant_picking,0)*nvl(precio,0))*(nvl(lc_detalle.porc_descuento,0)/100),
    								           total_linea = nvl(cant_picking,0) * nvl(precio,0)
    										 where no_cia    = pno_cia
    											 and centrod   = pno_centro
    											 and num_ctrl  = linea.num_ctrl
    											 and no_factu  = pedido.no_factu
    											 and linea_det = linea.linea_det;
    								 End Loop;
                 end if;

                 close c_detalle;
                 ------------------------ADD MLOPEZ 25/05/2010------------------------------
				     End if;
				  End Loop;
	      --
	      End Loop;


	  -- *************************************************************************
	  -- Se actualiza en Cabecera el total del Pedido de acuerdo a lo asignado.
	  -- *************************************************************************
	  For cab in C_Total_Aux_Picking(vno_control) Loop
	  	--
	    Open  C_Total_Distribuye(cab.num_ctrl, cab.no_factu);
	    Fetch C_Total_Distribuye into vTotalDistrib;
	    Close C_Total_Distribuye;
	    --
	    Update arfa_aux_cab_picking
	       set total_picking = vTotalDistrib
			 Where no_cia   = pno_cia
			   and centrod  = pno_centro
			   and num_ctrl = cab.num_ctrl
			   and no_factu = cab.no_factu;
	  End Loop;
    --

	  -- **************************************************************************************************
	  -- Barrido de verificacion de % minimo para despachar (montos de costos) para cambio de estado = 'N'
	  -- **************************************************************************************************
	  /*  Se incluira un Check List en la pantalla de pedidos para confirmar si el cliente desea que se
	      despache el pedido a pesar de estar incompleto.   Si el cliente indica que no recibira incompleto
	      el pedido no pasara al proceso de picking y quedara con estado No Facturado por Falta de Stock.
	      Si el pedido no cumple con el % minimo, pero el pedido tiene marcado el indicador de que se recibe
	      incompleto el pedido pasara al proceso de picking                                             	  */

	  For porc in  C_Total_Aux_Picking(vno_control) Loop

	    	If  ((nvl(porc.total_picking,0) <> nvl(porc.total_pedido,0))
	    		  and porc.ind_desp_completo = 'S')  OR

	    		  (nvl(porc.total_picking,0) <  nvl(porc.monto_minimo,0)
	    		  and  porc.ind_desp_completo = 'S') OR

	    		  (nvl(porc.total_picking,0) = 0)    THEN
              Begin
			    		Update arfafec
			    		   set estado = 'N',
			    		       no_docu_refe_picking = vno_control
			    		 Where no_cia   = pno_cia
							   and centrod  = pno_centro
							   and no_factu = porc.no_factu;
							Exception
				      When Others Then
				       vError := 'Error al actualizar la cabecera de pedido. Pedido: '||porc.no_factu||' '||SQLERRM;
				 	     RAISE Error_Proceso;
			        End;

							Update arfa_aux_det_picking
							   set ind_procesa = 'N'
			    		 Where no_cia   = pno_cia
							   and centrod  = pno_centro
							   and num_ctrl = porc.num_ctrl
							   and no_factu = porc.no_factu;

							Update arfa_aux_cab_picking
							   set ind_procesa = 'N'
			    		 Where no_cia   = pno_cia
							   and centrod  = pno_centro
							   and num_ctrl = porc.num_ctrl
							   and no_factu = porc.no_factu;

	    	End if;
	  End Loop;



	  -- Se graban en sesion los cambios en tablas auxiliares y estados a nivel de pedidos
	  --:system.message_level := 5;
		  --Post;
		--:system.message_level := 0;
    ---------------------------------------------------------------------------
    -- Luego de filtrar los pedidos y reprocesar se genera el Picking
	  ---------------------------------------------------------------------------
	  BEGIN

	  	Open  C_Existe_Detalle_Picking(vno_control);
	  	Fetch C_Existe_Detalle_Picking into vn_cantidad;
	  	Close C_Existe_Detalle_Picking;

			If nvl(vn_cantidad,0) > 0   Then
						  -- No_Docu para el Picking
						  vno_docu := transa_id.fa(pno_cia);
				      pno_docu := vno_docu;

				  		-- Insercion en arfaenc_picking
				  		Begin
				  		Insert into arfaenc_picking(no_cia,     centrod,       no_docu,
				  		                            no_picking, tipo_despacho, fecha,
				  		                            estado,     centro_fact,   tstamp,  usuario)

					                        values (pno_cia, pno_centro,      vno_docu,
					                                vno_control, ptipo_despacho, vd_dia_proceso,
					                                'P',              pno_centro,      sysdate,    user);

							Exception
		    	    When Others Then
		    	     vError := 'Error al crear cabecera de picking. Docu.: '||vno_docu||' Picking: '||vno_control||' '||SQLERRM;
		       	   RAISE Error_Proceso;
		          End;

				  		-- Insercion en arfadet_picking
				  	  For j in C_Picking_Detalle(vno_control)  Loop
					  		Open  C_articulo(j.no_articulo);
						    Fetch C_articulo into vDivision, vSubdivision;
						    Close C_articulo;
				        vLineaPicking := vLineaPicking + 1;
				        Begin
						 		Insert into arfadet_picking(no_cia,            centrod,            no_docu,
						 		                            no_picking,        bodega,             no_arti,
						 		                            no_linea,          tipo_distribucion,  Division,
						 		                            Subdivision,       cant_solicitada,    cant_sistema,
						 		                            cant_fisica)

							                      values (pno_cia,  pno_centro,   vno_docu,
							                              vno_control,  j.bodega,         j.no_articulo,
							                              vLineaPicking,     null,             vDivision,
							                              vSubdivision,      j.picking,        j.pedido,  --j.pedido,  j.picking,
							                              j.picking);  -- MNA 08/10/2009  decode(:ctrl.tipo_despacho,'R',0,j.picking));
								Exception
		    	      When Others Then
		    	       vError := 'Error al crear detalle de picking. Docu.: '||vno_docu||' Picking: '||vno_control||' Articulo: '||j.no_articulo||' '||SQLERRM;
		       	     RAISE Error_Proceso;
		            End;

				  	  End Loop;

					  -- ******************************************************************************************************************
					  -- Actualizacion de Pedidos(con % adecuado) que intervienen en el picking y asignacion  de articulos a despachar
					  -- ******************************************************************************************************************
					  For i in  C_Total_Aux_Picking(vno_control) Loop
				        -- Actualizacion de cabecera del pedido
				        Begin
				        Update arfafec
				           set no_docu_refe_picking = vno_docu  -- Se realaciona picking con pedido
				         Where no_cia   = pno_cia
								   and centrod  = pno_centro
								   and no_factu = i.no_factu;
								Exception
					      When Others Then
					       vError := 'Error al actualizar cabecera de pedido (Refe picking). Pedido: '||i.no_factu||' '||SQLERRM;
					 	     RAISE Error_Proceso;
				        End;



				        For m in C_Picking_Pedido_Cab (vno_control, i.no_factu)  Loop

						        -- Actualizacion detalle del pedido
						        Begin
						        Update arfaflc
						           set cant_aprobada      = m.cant_picking,
						               total              = Moneda.Redondeo((nvl(m.cant_picking, 0)) * nvl(m.precio,0), 'P'), -- total bruto
						               porc_desc_aprobado = m.porc_desc,
						               ---descuento          = m.descuento, --- ANR si tiene cant_picking sin existencia (cero), debe actualizar el descuento en base al cant_picking ANR 01/04/2010
						               descuento          = Moneda.Redondeo(((nvl(m.cant_picking, 0)) * nvl(m.precio,0))* m.porc_desc /100, 'P'),
						               precio_aprobado    = m.precio
						         Where no_cia   = pno_cia
										   and centrod  = pno_centro
										   and no_factu = m.no_factu
										   and bodega   = m.bodega
										   and bodega   != '0000' -- No debe recuperar servicios para el picking ANR 13/10/2009
										   and no_linea = m.linea_det
										   and no_arti  = m.no_articulo;
										Exception
							      When Others Then
							       vError := 'Error al actualizar detalle de pedido. Pedido: '||m.no_factu||' Articulo: '||m.no_articulo||' '||SQLERRM;
							 	     RAISE Error_Proceso;
						        End;

											 fapolitica_comercial.recalcula_linea_pedido (pno_cia, i.no_factu, m.linea_det);

 				               --------------------------------------------
				         	     -- Identifica si un articulo maneja lote
					       	  	 Open  C_Articulo_Lote (m.no_articulo);
											 Fetch C_Articulo_Lote into vInd_Lote;
											 Close C_Articulo_Lote;
									     --

											 If  vInd_Lote = 'L'   Then

												   FAVENTANILLA_PROCESAR_LOTE (pno_cia,         pno_centro,    m.no_factu,
					                                m.linea_det,     m.bodega,      m.no_articulo,
					                                m.cant_picking,  vError);

					                 -- Error por existncias en lotes
							             IF vError IS NOT NULL THEN
							             	 RAISE Error_Proceso;
							             END IF;
					                 --
											 End if;
											 --


											 fapolitica_comercial.recalcula_cabecera_pedido (pno_cia, i.no_factu);

				        End Loop;
				        --
					  End Loop;

				 elsif  (nvl(vn_cantidad,0) = 0)  and  (v_existe_transf = 'N')   Then
					 vError := 'Los pedidos relacionados no cumplieron con el porcentaje minimo para entrar al Picking. Cantidad: '||vn_cantidad||' Transf: '||v_existe_transf;
			 End if;
	  End;

		 -- Cargo los lotes en ARFALOTES_PICKING luego de haberse asignado a los pedidos en ARFAFLC_LOTES
	  For lote in C_Lotes_Picking (vno_docu) Loop
	  Begin

		 		Insert into arfalote_picking (no_cia,           no_docu,        bodega,        no_arti,
			 		                            no_lote,          ubicacion,      unidades,      fecha_vence,
			 		                            cant_solicitada,  disponibles)
			                        values (pno_cia, vno_docu,  lote.bodega,   lote.no_arti,
			                                lote.no_lote,     lote.ubicacion, lote.unidades, lote.fecha_vence,
			                                lote.unidades,    lote.unidades);
				Exception
	      When Others Then
	       vError := 'Error al crear lotes de picking. Docu.: '||vno_docu||' Articulo: '||lote.no_arti||' '||SQLERRM;
	 	     RAISE Error_Proceso;
      End;
	  End Loop;


EXCEPTION
   WHEN Error_Proceso THEN
       msg_error_p := vError;
       Rollback;

   WHEN OTHERS THEN
       msg_error_p := 'Error en FAFACT_VENTANILLA '||SQLERRM;
       Rollback;

End FAFACT_VENTANILLA;