create or replace procedure            facierre_facturacion
(
  pv_Cia       IN     arfafe.No_Cia%TYPE,
  pv_Centro    IN     arfafe.Centrod%TYPE,
  PD_FECHA_PROCESO IN DATE,
  pv_error     IN OUT VARCHAR2
) IS

  --
  --
  CURSOR c_centrod IS
    SELECT ano_proce_fact  ano_fact,
           mes_proce_fact  mes_fact,
           semana_proce_fact  sem_fact,
           indicador_sem_fact ind_sem_fact
      FROM arincd
     WHERE no_cia  = pv_cia
       AND centro  = pv_centro;
  --
  --
  CURSOR c_documentos IS
    SELECT f.tipo_doc,     f.periodo,     f.ruta,   f.no_factu,
           f.afecta_saldo, t.ind_fac_dev, f.grupo,  f.no_cliente,
           f.fecha,        f.tipo_cambio, f.moneda, t.tipo_doc_cxc,
           f.ind_exportacion, f.centrod, f.division_comercial,
           f.rowid
      FROM arfact t, arfafe f
     WHERE f.no_cia  = pv_Cia
       AND f.estado  = 'D'
       AND nvl(f.tipo_factura,'P') in ('P','C') --- solo se contabilizan facturas y consignacion, las anulaciones y devoluciones no se contabilizan ANR 20/11/2009 Pedido por IQUINDE
       AND nvl(f.ind_anu_dev,'N')  != 'A'  --- Anuladas no se generan
       AND nvl(t.ind_autoconsumo,'N')= 'N' ----- Solo documentos que no sean de autoconsumo ANR 16/10/2009
       AND f.centrod = pv_Centro
       AND t.no_cia  = f.no_cia
       AND t.tipo    = f.tipo_doc
       AND F.FECHA = PD_FECHA_PROCESO;

   ---- Documentos de autoconsumo se generan contablemente de forma diferente ANR 16/10/2009

  CURSOR c_documentos_autoconsumo IS
    SELECT f.tipo_doc,     f.periodo,     f.ruta,   f.no_factu,
           f.afecta_saldo, t.ind_fac_dev, f.grupo,  f.no_cliente,
           f.fecha,        f.tipo_cambio, f.moneda, t.tipo_doc_cxc,
           f.ind_exportacion, f.centrod, f.division_comercial,
           f.rowid
      FROM arfact t, arfafe f
     WHERE f.no_cia  = pv_Cia
       AND f.estado  = 'D'
       AND nvl(f.tipo_factura,'P') = 'P' --- solo se contabilizan facturas, las anulaciones y devoluciones no se contabilizan ANR 20/11/2009 Pedido por IQUINDE
       AND nvl(f.ind_anu_dev,'N')  != 'A'  --- Anuladas no se generan
       AND nvl(t.ind_autoconsumo,'N')= 'S' ----- Solo documentos que no sean de autoconsumo ANR 16/10/2009
       AND f.centrod = pv_Centro
       AND t.no_cia  = f.no_cia
       AND t.tipo    = f.tipo_doc
       AND F.FECHA = PD_FECHA_PROCESO;
  --

  --
  CURSOR c_act_estado IS
    SELECT f.no_factu
      FROM arfact t, arfafe f
     WHERE f.no_cia  = pv_Cia
       AND f.estado  = 'D'
       AND f.centrod = pv_Centro
       AND t.no_cia  = f.no_cia
       AND t.tipo    = f.tipo_doc;

  -- Lineas del documento
  CURSOR c_lineas( pTipo_doc varchar2, pNo_factu varchar2) IS
    SELECT l.bodega, d.grupo,
           round(sum(abs(nvl(l.total,0))),2)        total,
           round(sum(abs(nvl(l.descuento,0))),2)    descuento,
           round(sum(abs(nvl(l.i_ven_n,0))),2)      i_ven_n,
           round(sum(abs(nvl(l.imp_incluido,0))),2) imp_incluido,
           round(sum(abs(nvl(l.imp_especial,0))),2) imp_especial,
           round(sum(abs(nvl(l.i_ven_n,0)+nvl(l.imp_incluido,0)+nvl(l.imp_especial,0))),2) tot_imp
      FROM arinda d, arfafl l
     WHERE l.no_cia    = pv_cia
       AND l.no_factu  = pNo_factu
       AND l.tipo_doc  = pTipo_doc
       AND nvl(servicio_transporte,'N') = 'N'
       AND l.no_cia    = d.no_cia
       AND l.no_arti   = d.no_arti
     GROUP BY l.bodega, d.grupo;

----

  -- Lineas del documento para transporte ANR 19/11/2009
  CURSOR c_lineas_transporte( pTipo_doc varchar2, pNo_factu varchar2) IS
    SELECT l.bodega, d.grupo,
           sum(abs(nvl(l.total,0)))        total,
           sum(abs(nvl(l.descuento,0)))    descuento,
           sum(abs(nvl(l.i_ven_n,0)))      i_ven_n,
           sum(abs(nvl(l.imp_incluido,0))) imp_incluido,
           sum(abs(nvl(l.imp_especial,0))) imp_especial,
           sum(abs(nvl(l.i_ven_n,0)+nvl(l.imp_incluido,0)+nvl(l.imp_especial,0))) tot_imp
      FROM arinda d, arfafl l
     WHERE l.no_cia    = pv_cia
       AND l.no_factu  = pNo_factu
       AND l.tipo_doc  = pTipo_doc
       AND nvl(servicio_transporte,'N') = 'S'
       AND l.no_cia    = d.no_cia
       AND l.no_arti   = d.no_arti
     GROUP BY l.bodega, d.grupo;

  --
  --- Base gravada del documento
  CURSOR c_total_bruto ( pTipo_doc varchar2, pNo_factu varchar2, pBodega varchar2, pGrupo varchar2) IS
    SELECT nvl(sum(abs(nvl(l.total,0))),0) base
      FROM arinda d, arfafl l
     WHERE l.no_cia    = pv_cia
       AND l.no_factu  = pNo_factu
       AND l.tipo_doc  = pTipo_doc
       AND l.bodega    = pBodega
       AND d.grupo     = pGrupo
       AND nvl(servicio_transporte,'N') = 'N'
       AND l.no_cia    = d.no_cia
       AND l.no_arti   = d.no_arti;

  --- Descuento gravado o descuento excento

   Cursor C_Descuento ( pTipo_doc varchar2, pNo_factu varchar2, pBodega varchar2, pGrupo varchar2)  Is
    SELECT nvl(sum(abs(nvl(l.descuento,0))),0) descuento
      FROM arinda d, arfafl l
     WHERE l.no_cia    = pv_cia
       AND l.no_factu  = pNo_factu
       AND l.tipo_doc  = pTipo_doc
       AND l.bodega    = pBodega
       AND d.grupo     = pGrupo
       AND l.no_cia    = d.no_cia
       AND l.no_arti   = d.no_arti;

  --
  CURSOR c_impuestos( pTipo_doc arfafli.tipo_doc%type,
                      pNo_factu arfafli.no_factu%type) IS
    SELECT i.clave, i.codigo_tercero,
           round(sum(abs(nvl(i.monto_imp,0))),2) monto_imp --- Se redondea a dos decimales el impuesto al final ANR 10/03/2010
      FROM arfafli i
     WHERE i.no_cia            = pv_cia
       AND i.no_factu          = pNo_factu
       AND i.tipo_doc          = pTipo_doc
       AND nvl(i.monto_imp,0) != 0
     GROUP BY i.clave, i.codigo_tercero;
  --
  --
  CURSOR c_tercero (p_cia        varchar2, p_grupo    varchar2,
                    p_no_cliente varchar2  )IS
    SELECT codigo_Tercero
      FROM arccmc
     WHERE no_cia     = p_cia
       AND grupo      = p_grupo
       AND no_cliente = p_no_cliente;
  --

  Cursor C_Div_Comercial (Lv_Centrod Varchar2, Lv_Div_Comercial Varchar2) Is
	  select centro_costo
	  from   arfa_div_comercial
	  where  no_cia   = pv_Cia
	  and    centro   = Lv_Centrod
	  and    division = Lv_Div_Comercial;

  Cursor C_Ctas_Autoconsumo Is
   select cta_autoconsumo_iva, cta_autoconsumo_iva_cxp, cc_autoconsumo
   from   arfamc
   where  no_cia = pv_cia;

  Cursor C_Ctas_Transporte Is
   select cta_transporte
   from   arfamc
   where  no_cia = pv_cia;


  Cursor C_Asiento Is
   select no_docu, sum(nvl(decode(tipo_mov,'D',monto),0)) - sum(nvl(decode(tipo_mov,'C',monto),0)) dif,
          sum(nvl(decode(tipo_mov,'D',monto),0)) debitos, sum(nvl(decode(tipo_mov,'C',monto),0)) creditos
	 from   arfadc
	 where  no_cia = pv_cia
	 and no_asiento is null
	 group by no_docu;

  CURSOR c_Tercero_sn IS
   SELECT acepta_tercero, clase_cambio
     FROM arcgmc
   WHERE no_cia = pv_Cia;

 lc_tercero_sn c_tercero_sn%rowtype;

  --
  error_proceso      exception;
  --
  vFound             boolean;
  vBodega  	         arincc.bodega%type;
  vGrupo_contable	   arincc.grupo%type;
  --
  vImp_detalle       arfafl.i_ven_n%type; -- suma imp del detalle imp (arfafli)
  vImp_lineas        arfafl.i_ven_n%type; -- suma imp por lineas (arfafl)
  -- Tipos de movimientos contables
  vtmov_cxc_caja	   arfadc.tipo_mov%type;	-- efectivo o CxC
  vtmov_descuento    arfadc.tipo_mov%type;
  vtmov_ventas	     arfadc.tipo_mov%type;
  vtmov_imp		       arfadc.tipo_mov%type;
  vtmov_imp_oferta   arfadc.tipo_mov%type;
  -- cuentas
  vcta_cxc_caja      arcgms.cuenta%type;          -- cuenta de efectivo o por cobrar

  vcta_venta_gravada     arcgms.cuenta%type;
  vcta_venta_excenta     arcgms.cuenta%type;
  vcta_descuento_gravado arcgms.cuenta%type;
  vcta_descuento_excento arcgms.cuenta%type;

  vcentro_costo      arincc.centro_costo%type;
  --
  vrctas             inlib.cuentas_contables_r;
  --
  --
  rCentro            c_centrod%rowtype;
  vid_sec            arcgdisec.id_sec%type;
  vCuentaImp         arfadc.codigo%type;
  vtercero_cte       arccmc.codigo_tercero%type;
  vtercero_dc        arccmc.codigo_tercero%type;

  Ln_base_gravada    Arfadc.monto%type;

  Lv_cta_autoconsumo_iva     Arfadc.codigo%type;
  Lv_cta_autoconsumo_iva_cxp Arfadc.codigo%type;
  Lv_cc_autoconsumo          Arfadc.centro_costo%type;


  Lv_cta_transporte          Arfadc.codigo%type;

  Ln_total_sin_transporte    Number(17,2):= 0;
  Ln_total_con_transporte    Number(17,2):= 0;

  --
  vError             varchar2(250);
  ln_descuento       number:=0;
BEGIN

/*

   La contabilizacion de la facturacion  sera de la siguiente manera:
- El centro de costo se asignara a traves de la parametrizacion
que tenga asociada el vendedor asignado a la factura, pues este estara
asociado a una division, la cual tendra definido un centro de costo.


Cuenta                      Descripcion                          Centro de Costo                                                                      Debe       Haber
10-10-20-10-10-001      Cuentas por Cobrar Clientes Factura     Centro de costo relacionado a  la division a la que pertenece el vendedor
                                                                asignado a la factura y al centro de distribucion donde se emitira la factura, (1)    9999,00
40-05-10-10-10-001      Ventas Brutas Locales con Tarifa 12%                                                                                                    999,00
40-10-10-10-10-001      Ventas Brutas Locales con Tarifa 0%                                                                                                     999,00
20-10-40-20-10-001      IVA por Pagar Factura                                                                                                                   999,00
40-05-10-10-30-001      Descuento en ventas bienes tarifa 12%                                                                                         999,00
40-10-10-10-30-001      Descuento en ventas bienes tarifa 0%                                                                                          999,00
Cuenta de Otros Ingresos por Transporte Otros Ingresos                                                                                                          999.00

*/


  -- Carga el a?o, mes y periodo en proceso
  OPEN  c_CentroD;
  FETCH c_CentroD INTO rCentro;
  CLOSE c_CentroD;
  --
  --
  open c_tercero_sn;
  fetch c_tercero_sn into lc_tercero_sn;
  close c_tercero_sn;

  FOR doc IN c_documentos LOOP
      Ln_total_con_transporte := 0;
      Ln_total_sin_transporte := 0;

      IF lc_tercero_sn.acepta_tercero = 'S' THEN
    	   OPEN  c_tercero(pv_Cia, doc.grupo, doc.no_cliente);
    	   FETCH c_tercero INTO vTercero_cte;
    	   CLOSE c_tercero;
      ELSE
    	   vTercero_Cte := NULL;
      END IF;
      -- Busca cuenta contable de efectivo o por cobrar
      vcta_cxc_caja := NULL;
      ---- para contado o credito igual va a las cuentas por cobrar ANR 25/11/2009
      -- venta a credito, asi que trae la cuenta contable de clientes
      IF not cclib.trae_cuenta_cliente(pv_cia,   doc.grupo,
                                       doc.tipo_doc_cxc, doc.moneda, vcta_cxc_caja) THEN
         pv_error := 'No se obtuvo la cuenta contable del cliente, grupo: '||doc.grupo||
                       ', moneda '||moneda.nombre(pv_cia, doc.moneda);
         RAISE error_proceso;
      END IF;

      IF vcta_cxc_caja is null THEN
         pv_error := 'La cuenta de cliente es null, en el grupo : '||doc.grupo;
         RAISE error_proceso;
      END IF;
      -- Define la forma contable que tendra el asiento
      IF doc.ind_fac_dev = 'F' THEN
         -- asiento de factura
         vtmov_cxc_caja     := 'D';   -- Debito a Caja o Cxc
         vtmov_ventas       := 'C';   -- Credito ventas
         vtmov_descuento    := 'D';
         vtmov_imp          := 'C';
         vtmov_imp_oferta   := 'D';
      ELSE
         -- asiento de devolucion o anulacion
         vtmov_cxc_caja     := 'C';   -- Credito a Caja o CxC
         vtmov_descuento    := 'C';   -- Debito a ventas
         vtmov_ventas       := 'D';
         vtmov_imp          := 'D';
         vtmov_imp_oferta   := 'C';
      END IF;
      --- El centro de costo que recupera es el que esta configurado pora cada division comercial ANR 25/08/2009

      Open C_Div_Comercial (doc.centrod, doc.division_comercial);
      Fetch C_Div_Comercial into vcentro_costo;

      If C_Div_Comercial%notfound Then
       	 Close C_Div_Comercial;
         pv_error := 'No existe division comercial definido para el centro: '||doc.centrod||' Division: '||doc.division_comercial;
         RAISE error_proceso;
      else
       	 Close C_Div_Comercial;
      end if;
      -- ---
      -- procesa el detalle del documento agrupado por bodega y grupo contable
      --
      vImp_lineas := 0;

      FOR ld IN c_lineas(doc.tipo_doc, doc.no_factu) LOOP
          vBodega         := ld.bodega;
          vGrupo_contable := ld.grupo;
          vImp_lineas     := vImp_lineas + nvl(ld.tot_imp, 0);
          --
          -- Busca los codigos contable para cada articulo traido en el cursor
          IF NOT inlib.trae_cuentas_conta(pv_cia, vGrupo_contable, vBodega, vrctas) THEN
             pv_error := 'No se pudo obtener las cuentas contables para el '||
                           'grupo '||vGrupo_contable||', bodega: '||vBodega;
             RAISE error_proceso;
          END IF;

          IF doc.afecta_saldo = 'S' THEN
             --
             -- la venta o devolucion fue de credito local
             ---vcta_venta         := iifc(doc.ind_fac_dev = 'D',  vrctas.cta_devol_credito, vrctas.cta_venta_cre);
             if doc.ind_fac_dev = 'D' then
                vcta_venta_gravada := vrctas.cta_devol_gravada_cre;
                vcta_venta_excenta := vrctas.cta_devol_exenta_cre;
             else
                vcta_venta_gravada := vrctas.cta_venta_gravada_cre;
                vcta_venta_excenta := vrctas.cta_venta_exenta_cre;
             end if;

             vcta_descuento_gravado := vrctas.cta_desc_gravada_cre;
             vcta_descuento_excento := vrctas.cta_desc_exenta_cre;
          ELSE
             --
             -- la venta o devolucion fue de contado local
             ---vcta_venta         := iifc(doc.ind_fac_dev = 'D', vrctas.cta_devol_contado, vrctas.cta_venta);
             if doc.ind_fac_dev = 'D' then
                vcta_venta_gravada := vrctas.cta_devol_gravada_con;
                vcta_venta_excenta := vrctas.cta_devol_exenta_con;
             else
                vcta_venta_gravada := vrctas.cta_venta_gravada_con;
                vcta_venta_excenta := vrctas.cta_venta_exenta_con;
             end if;

             vcta_descuento_gravado := vrctas.cta_desc_gravada_con;
             vcta_descuento_excento := vrctas.cta_desc_exenta_con;

          END IF;
          --
          -- --
          -- Verifica que las cuentas existan para la bodega y el grupo contable
          --
          IF (vcta_venta_gravada is null) THEN
             IF doc.ind_fac_dev = 'D' THEN  -- se procesa una factura
	              pv_error := 'Falta definir la cuenta de Devoluciones gravada (contado/credito), para la bodega '||
	                        vBodega ||' y el grupo ' || vGrupo_contable;
                RAISE error_proceso;
             ELSE -- se procesa una devolucion
	              pv_error := 'Falta definir la cuenta de Ventas gravada (contado/credito), para la bodega '||
	                        vBodega ||' y el grupo ' || vGrupo_contable;
        	      RAISE error_proceso;
             END IF;
          ELSIF (vcta_venta_excenta is null) THEN
             IF doc.ind_fac_dev = 'D' THEN  -- se procesa una factura
	              pv_error := 'Falta definir la cuenta de Devoluciones excenta (contado/credito), para la bodega '||
	                        vBodega ||' y el grupo ' || vGrupo_contable;
                RAISE error_proceso;
             ELSE -- se procesa una devolucion
	              pv_Error := 'Falta definir la cuenta de Ventas excenta(contado/credito), para la bodega '||
	                        vBodega ||' y el grupo ' || vGrupo_contable;
        	      RAISE error_proceso;
             END IF;
          ELSIF (vcta_descuento_gravado is null) THEN
             pv_error := 'Falta definir la cuenta de Descuentos gravado, para la bodega '
                        || vBodega ||' y el grupo ' || vGrupo_contable;
             RAISE error_proceso;
          ELSIF (vcta_descuento_excento is null) THEN
             pv_error := 'Falta definir la cuenta de Descuentos excento, para la bodega '
                        || vBodega ||' y el grupo ' || vGrupo_contable;
             RAISE error_proceso;
          END IF;

          Ln_total_sin_transporte := Ln_total_sin_transporte + nvl(nvl(ld.total,0) - nvl(ld.descuento, 0) + nvl(ld.i_ven_n, 0),0);
          -- ******************************
          -- Graba Descuento sobre ventas
          -- ******************************

          Open c_Descuento(doc.tipo_doc, doc.no_factu, ld.bodega, ld.grupo);
          Fetch c_Descuento into ln_descuento;--comment mlopez Ln_descuento_excento, Ln_descuento_gravado;

          If c_Descuento%notfound Then
      	     Close c_Descuento;
             ln_descuento:=0;

          else
      	     Close c_Descuento;
          end if;

          IF nvl(abs(Ln_descuento),0) > 0 THEN
             vTercero_Dc := NULL;
             inserta_arfadc(pv_cia,         pv_centro,             TO_CHAR(PD_FECHA_PROCESO,'YYYY'),
                            TO_CHAR(PD_FECHA_PROCESO,'MM'),doc.tipo_doc,        doc.periodo,
                            doc.ruta,        doc.no_factu,         doc.moneda,
                            vcta_descuento_gravado,  Ln_descuento, doc.tipo_cambio,
                            vcentro_costo,   '5',                  vtmov_descuento,
                            vtercero_dc);
          END IF;

          Open c_total_bruto(doc.tipo_doc, doc.no_factu, ld.bodega, ld.grupo);
          Fetch c_total_bruto into Ln_base_gravada;--comment mlopez Ln_base_excenta, Ln_base_gravada;

          If c_total_bruto%notfound Then
      	     Close c_total_bruto;
             Ln_base_gravada:=0;

          else
      	     Close c_total_bruto;
          end if;

          ---- Genera la cuenta de ingreso de ventas para la parte gravada

          If nvl(Ln_base_gravada,0) > 0 Then
             vTercero_dc := NULL;

             inserta_arfadc(pv_cia,         pv_centro,         TO_CHAR(PD_FECHA_PROCESO,'YYYY'),
                     TO_CHAR(PD_FECHA_PROCESO,'MM'),doc.tipo_doc,     doc.periodo,
                     doc.ruta,        doc.no_factu,     doc.moneda,
                     vcta_venta_gravada,
                     Ln_base_gravada,
                     doc.tipo_cambio, vcentro_costo, '7',vtmov_ventas,
                     vtercero_dc);
          end if;

    END LOOP;	-- lineas del documento

    FOR ld IN c_lineas_transporte(doc.tipo_doc, doc.no_factu) LOOP
  		  ---- Crea la cuenta contable para el transporte ANR 19/11/2009
		    Open C_Ctas_transporte;
		    Fetch C_Ctas_transporte into Lv_cta_transporte;

        If C_Ctas_transporte%notfound Then
		   	   Close C_Ctas_transporte;
		       pv_error := 'No existe la compa?ia configurada en el modulo de facturacion';
  		     RAISE error_proceso;
		    else
		   	   Close C_Ctas_transporte;

    		   If Lv_cta_transporte is null Then
    		   		pv_error := 'No existe configurado la cuenta contable para el transporte';
    		      RAISE error_proceso;
    		   end if;

    		   inserta_arfadc(pv_cia,         pv_centro,               TO_CHAR(PD_FECHA_PROCESO,'YYYY'),
		                   TO_CHAR(PD_FECHA_PROCESO,'MM'),doc.tipo_doc,           doc.periodo,
		                   doc.ruta,        doc.no_factu,           doc.moneda,
		                   Lv_cta_transporte, nvl(nvl(ld.total,0) - nvl(ld.descuento, 0) + nvl(ld.i_ven_n, 0),0),      doc.tipo_cambio,
		                   vcentro_costo,   '8',                    'C',  --- (8) Le pongo a este movimiento de transporte  ANR 19/11/2009
		                   vtercero_dc);

     		   Ln_total_con_transporte := Ln_total_con_transporte + nvl(nvl(ld.total,0) - nvl(ld.descuento, 0) + nvl(ld.i_ven_n, 0),0);
		   end if;
    END LOOP;	-- lineas del documento para transporte
    -- **************************************
    -- Genera detalle contable por Impuestos
    -- **************************************
    vImp_detalle := 0;

    FOR rImp IN c_Impuestos (doc.tipo_doc, doc.no_factu) LOOP

        vImp_detalle := vImp_detalle + nvl(rImp.Monto_Imp, 0);

	      pv_error := NULL;
	      vid_sec := CCSector_impuesto(pv_cia, doc.grupo, doc.no_cliente, rImp.clave, pv_error );

	      IF pv_error IS NOT NULL THEN
	         RAISE error_proceso;
	      END IF;

	      vCuentaImp := Impuesto.Cta_Contable(pv_cia, rImp.clave, vid_sec  );

	      IF cuenta_Contable.acepta_tercero(pv_Cia, vCuentaImp) AND
	      	 lc_tercero_sn.acepta_tercero = 'S'                     THEN
	       	 vTercero_Dc := rImp.Codigo_tercero;
	      ELSE
	       	 vTercero_Dc := NULL;
	      END IF;

	      inserta_arfadc(pv_cia,         pv_centro,               TO_CHAR(PD_FECHA_PROCESO,'YYYY'),
	                     TO_CHAR(PD_FECHA_PROCESO,'MM'),doc.tipo_doc,           doc.periodo,
	                     doc.ruta,        doc.no_factu,           doc.moneda,
	                     vCuentaImp,      nvl(rImp.Monto_Imp, 0), doc.tipo_cambio,
	                     vcentro_costo,   '6',                    vtmov_imp,
	                     vtercero_dc);

    END LOOP;  -- detalle de impuestos
    --
    ---- ANR 10/03/2010 se aumenta comparacion con redondeo por el impuesto a todos los decimales
    IF round(vImp_detalle,2) != vImp_lineas THEN
       pv_error := 'La transaccion '||doc.tipo_doc||'-'||doc.no_factu ||
                     ' presenta inconsistencias entre el total de impuestos: '||round(vImp_detalle,2)||' y la suma de las lineas de impuesto: '||vImp_lineas;
       RAISE error_proceso;
    END IF;
    --
    -- ---
    -- cambia el estado del documento
    --

    --- Al final crea la cuenta por cobrar sumando la parte sin transporte y con transporte ANR 19/11/2009

      -- ********************************************
      -- Construye el detalle contable en ARFADC
      -- ********************************************
      -- ************************
      -- Cuenta de CxC o Caja
      -- ************************
      IF cuenta_Contable.acepta_tercero(pv_Cia, vcta_cxc_caja) THEN
      	 vTercero_Dc := vTercero_Cte;
      ELSE
      	 vTercero_Dc := NULL;
      END IF;
      --
      inserta_arfadc(pv_cia,         pv_centro,          TO_CHAR(PD_FECHA_PROCESO,'YYYY'),
                     TO_CHAR(PD_FECHA_PROCESO,'MM'),doc.tipo_doc,      doc.periodo,
                     doc.ruta,        doc.no_factu,      doc.moneda,
                     vcta_cxc_caja,   nvl(Ln_total_con_transporte,0) + nvl(Ln_total_sin_transporte,0),
                     doc.tipo_cambio, vcentro_costo,     '4',
                     vtmov_cxc_caja,  vtercero_dc);


  END LOOP; --- fin de lazo para el documento


  FOR doc IN c_documentos_autoconsumo LOOP
      Open C_Ctas_Autoconsumo;
      Fetch C_Ctas_Autoconsumo into Lv_cta_autoconsumo_iva, Lv_cta_autoconsumo_iva_cxp, Lv_cc_autoconsumo;

      If C_Ctas_Autoconsumo%notfound Then
   	     Close C_Ctas_Autoconsumo;
         pv_error := 'No existe la compa?ia configurada en el modulo de facturacion';
         RAISE error_proceso;
      else
   	     Close C_Ctas_Autoconsumo;

         	If Lv_cta_autoconsumo_iva is null Then
         		 pv_error := 'No existe configurado la cuenta contable autoconsumo IVA';
             RAISE error_proceso;
         	elsif Lv_cta_autoconsumo_iva_cxp is null Then
         		 pv_error := 'No existe configurado la cuenta contable autoconsumo IVA CxP';
             RAISE error_proceso;
         	elsif Lv_cc_autoconsumo is null Then
         		 pv_Error := 'No existe configurado el centro de costos autoconsumo';
             RAISE error_proceso;
         	end if;
      end if;

      FOR ld IN c_lineas(doc.tipo_doc, doc.no_factu) LOOP
           inserta_arfadc(pv_cia,         pv_centro,               TO_CHAR(PD_FECHA_PROCESO,'YYYY'),
	                     TO_CHAR(PD_FECHA_PROCESO,'MM'),doc.tipo_doc,           doc.periodo,
	                     doc.ruta,        doc.no_factu,           doc.moneda,
	                     Lv_cta_autoconsumo_iva,                  ld.total, doc.tipo_cambio,
	                     Lv_cc_autoconsumo,   '9',                    'D',  --- (9) Le pongo a este movimiento de autoconsumo  ANR 16/10/2009
	                     vtercero_dc);

  	      inserta_arfadc(pv_cia,         pv_centro,              TO_CHAR(PD_FECHA_PROCESO,'YYYY'),
	                     TO_CHAR(PD_FECHA_PROCESO,'MM'),doc.tipo_doc,           doc.periodo,
	                     doc.ruta,        doc.no_factu,           doc.moneda,
	                     Lv_cta_autoconsumo_iva_cxp,              ld.total, doc.tipo_cambio,
	                     Lv_cc_autoconsumo,   '9',                    'C',  --- (9) Le pongo a este movimiento de autoconsumo  ANR 16/10/2009
	                     vtercero_dc);

      END LOOP;
      -- ---

  End Loop;

  For h in C_Act_Estado Loop
  	-- cambia el estado del documento
    UPDATE arfafe
       SET estado  = 'M'
     WHERE no_cia = pv_cia
     AND   no_factu = h.no_factu;
  End Loop;



  For i in C_Asiento Loop --- Al final verifico inconsistencias en el asiento contable generado ANR 19/11/2009
     	If i.dif != 0 Then
     	   pv_error := 'El numero de transaccion: '||i.no_docu||' esta descuadrado entre el debe y el haber con: '||i.dif;
         RAISE error_proceso;
     	elsif i.debitos = 0 Then
     	   pv_Error := 'El numero de transaccion: '||i.no_docu||' tiene cero en la sumatoria de los debitos';
         RAISE error_proceso;
     	elsif i.creditos = 0 Then
     	   pv_Error := 'El numero de transaccion: '||i.no_docu||' tiene cero en la sumatoria de los creditos';
         RAISE error_proceso;
     	end if;
  End Loop;


EXCEPTION
  WHEN impuesto.error THEN
       pv_error := impuesto.ultimo_error;
       return;
  WHEN error_proceso THEN
       pv_error := 'REALIZA_CIERRE (EP): '||nvl(pv_error,vError);
       return;
  WHEN others then
       pv_error := 'REALIZA_CIERRE: '||sqlerrm;
       return;

end facierre_facturacion;