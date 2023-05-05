create or replace procedure            fageneradc(pv_cia varchar2,pd_fecha_proceso date,pv_centro varchar2,pv_error in out varchar2) is

  vmsg_error          varchar2(240);

  Error_proceso       Exception;
  Error_documentos    Exception;
  ln_count_docus		  number:=0;

BEGIN
  DELETE FROM ARFADC z
  WHERE EXISTS
  (
        SELECT f.tipo_doc,     f.periodo,     f.ruta,   f.no_factu,
           f.afecta_saldo, t.ind_fac_dev, f.grupo,  f.no_cliente,
           f.fecha,        f.tipo_cambio, f.moneda, t.tipo_doc_cxc,
           f.ind_exportacion, f.centrod, f.division_comercial,
           f.rowid
      FROM arfact t, arfafe f
     WHERE f.no_cia  = pv_Cia
       AND f.estado  = 'M'
       AND nvl(f.tipo_factura,'P') in ('P','C','D') --- solo se contabilizan facturas y consignacion, las anulaciones y devoluciones no se contabilizan ANR 20/11/2009 Pedido por IQUINDE
       AND nvl(f.ind_anu_dev,'N')  != 'A'  --- Anuladas no se generan
       AND f.centrod = pv_Centro
       AND t.no_cia  = f.no_cia
       AND t.tipo    = f.tipo_doc
       and f.no_cia=z.no_cia
       and f.no_factu=z.no_docu
       and f.fecha=pd_fecha_proceso
  );

   if sql%rowcount>0 then
      dbms_output.put_line('Eliminados: '||sql%rowcount);
  end if;

  update arfafe m
   set estado='D'
  WHERE EXISTS
  (
        SELECT f.tipo_doc,     f.periodo,     f.ruta,   f.no_factu,
           f.afecta_saldo, t.ind_fac_dev, f.grupo,  f.no_cliente,
           f.fecha,        f.tipo_cambio, f.moneda, t.tipo_doc_cxc,
           f.ind_exportacion, f.centrod, f.division_comercial,
           f.rowid
      FROM arfact t, arfafe f
     WHERE f.no_cia  = pv_Cia
       AND f.estado  = 'M'
       AND nvl(f.tipo_factura,'P') in ('P','C','D') --- solo se contabilizan facturas y consignacion, las anulaciones y devoluciones no se contabilizan ANR 20/11/2009 Pedido por IQUINDE
       AND nvl(f.ind_anu_dev,'N')  != 'A'  --- Anuladas no se generan
       AND f.centrod = pv_Centro
       AND t.no_cia  = f.no_cia
       AND t.tipo    = f.tipo_doc
       and f.no_cia=m.no_cia
       and f.no_factu=m.no_factu
       and f.fecha=pd_fecha_proceso
  );

  if sql%rowcount>0 then
     dbms_output.put_line('Actualizados: '||sql%rowcount);
  end if;

  vmsg_error := NULL;

	fageneraDC_DEVOLUCION (pv_cia, pv_centro,pd_fecha_proceso,vmsg_error);

  IF vmsg_error is not null THEN
     pv_error:=vmsg_error;
     RAISE error_proceso;
  END IF;


 FACierre_facturacion(pv_cia, pv_centro,pd_fecha_proceso, vmsg_error);

  IF vmsg_error is not null THEN
     pv_error:=vmsg_error;
     RAISE error_proceso;
  END IF;


	     	  -- actualiza a nuevo estado en la arfafec
	  UPDATE arfafec
    SET estado       = 'S'
    WHERE no_cia       = pv_cia
      AND centrod      = pv_centro
      AND estado       = 'P'
      AND fecha        <= pd_fecha_proceso;

  commit;


EXCEPTION
  WHEN Error_documentos THEN
      pv_error:='No se pudo procesar el Cierre Diario'||chr(13)||'Existen '||ln_count_docus||' documentos que no estan emitidos';
  WHEN error_proceso THEN
       Rollback;
  WHEN others THEN
       Rollback;

end fageneradc;