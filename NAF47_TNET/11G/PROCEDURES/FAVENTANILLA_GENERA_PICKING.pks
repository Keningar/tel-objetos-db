create or replace procedure            FAVENTANILLA_GENERA_PICKING ( pno_cia      IN varchar2,
                                                          pno_centro   IN varchar2,
                                                          pno_docu     IN varchar2,
                                                          pno_control  IN varchar2,
                                                          pdocu_generado IN OUT varchar2,
                                                          msg_error_p    IN OUT varchar2) IS

	Cursor C_Pedidos_Picking (pNo_Docu_Picking varchar2)  IS
		Select p.no_cia, p.no_factu, p.sub_total
			from arfafec p
		 Where p.no_cia   =  pno_cia
	     and p.centrod  =  pno_centro
		   and nvl(p.no_docu_refe_picking,0) = pNo_Docu_Picking;


  Cursor C_Porcentaje_Pedido  IS
		Select porc_acept_pedido from arfamc
		 Where no_cia = pno_cia;

  Cursor C_Total_Pedido (pNo_Docu_Picking varchar2, pNo_Factu varchar2)  IS
		Select  sum(d.cant_aprobada * d.precio)
		from  arfafec p, arfaflc d
		Where p.no_cia   =  pno_cia
      and p.centrod  =  pno_centro
      and d.bodega != '0000' --- No se deben considerar servicios ANR 13/10/2009
		  and nvl(p.no_docu_refe_picking,0) = pNo_Docu_Picking
      and p.no_cia   = d.no_cia
      and p.centrod  = d.centrod
      and p.no_factu = pNo_Factu
      and p.no_factu = d.no_factu;

	  vPorcentaje    number := 0;
	  vTotal_Pedido  number(17,2)  := 0;
	  verror         varchar2(500) := '';
    error_proceso  exception;
   	vmsg_Generado Varchar2(500);

Begin

    --************************************************
    --  NO se genera solicitud por Reclasificacion
    --************************************************

		--********************************************************************
	  -- Verificacion de % de aceptacion para todos los pedidos del Picking
	  --*********************************************************************
	  Open  C_Porcentaje_Pedido;
	  Fetch C_Porcentaje_Pedido into vPorcentaje;
	  Close C_Porcentaje_Pedido;

    For i in C_Pedidos_Picking(pno_docu)  Loop
       	--
       	Open  C_Total_Pedido (pno_docu, i.no_Factu);
			  Fetch C_Total_Pedido into vTotal_Pedido;
			  Close C_Total_Pedido;

        If vTotal_Pedido <  (i.sub_total*vPorcentaje)/100  Then
	        Update arfafec
	    		   set estado = 'N'
	    		 Where no_cia   = pno_cia
					   and centrod  = pno_centro
					   and no_factu = i.no_factu;
				End if;
    End Loop;

		--********************************************************************
	  -- Verifico si el Picking tiene pedidos relacionados, si no los tiene
	  -- pasa a estado 'N',  si tiene relacionado pedidos entonces estos son
	  -- son marcados como generados
	  --*********************************************************************

    -- *********************************************
    -- Luego de reprocesar
    --**********************************************
		 For i in C_Pedidos_Picking(pno_docu) Loop
		  	Update arfafec p
		  	   set aprobado = 'S'
				 Where p.no_cia   =  i.no_cia
			     and p.centrod  =  pno_centro
			     and p.no_factu = i.no_factu;
		  End Loop;

	  	-- Actualiza el estado del Picking
	  	Update ARFAENC_PICKING
	  	   set estado = 'D'
		   Where no_cia  = pno_cia
	       and centrod = pno_centro
	       and no_docu = pno_docu
	       and no_picking = pno_control;

	    -- Genera las facturas en estado Pendiente
	    FA_PEDIDO_FACTURA(pno_cia, pno_docu, vmsg_Generado, vError);

	    If vError is not null  Then
	       msg_error_p := vError;
           raise error_proceso;
	    Else
          pdocu_generado := vmsg_Generado;
	    End if;

  --
	EXCEPTION
	  WHEN error_proceso THEN
	       msg_error_p := vError;
	       Rollback;

	  WHEN OTHERS THEN
	       msg_error_p := 'Error en FAVENTANILLA_GENERA_PICKING: '||SQLERRM;
	       Rollback;

end FAVENTANILLA_GENERA_PICKING;