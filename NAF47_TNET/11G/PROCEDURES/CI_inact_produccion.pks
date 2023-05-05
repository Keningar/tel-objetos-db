create or replace PROCEDURE            CI_inact_produccion ( cia_p        IN varchar2,
                                                  tipo_p       IN varchar2,
                                                  docu_p       IN varchar2,
                                                  movimi_p     IN varchar2,
                                                  cta_docu_p   IN varchar2,
                                                  time_stamp_p IN date,
                                                  msg_error_p  IN OUT varchar2) IS
  --
  --  Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  --  tanto solo INactualiza deberia utilizarlo.
  --  La funcion es actualizar documentos de produccion o
  --  devolucion de producciones
  --***************************************************************************************************
  --  El costo unitario, ultimo_costo  para costo1 y csto2  de arinda y arinma deben de venir cargadosinc
  --***************************************************************************************************
  error_proceso      EXCEPTION;
  --
  vtime_stamp     date;
  rper            inlib.periodo_proceso_r;
  vfound          boolean;
  vsigno          number(2);
  vmov_tot        arinme.mov_tot%type;
  vmov_tot2        arinme.mov_tot%type;
  --
  -- Lee el documento de compra que esta pendiente de actualizar.
  CURSOR c_documento IS
    SELECT e.no_cia, e.centro, e.tipo_doc, e.no_docu,
           e.periodo, e.ruta,
           e.fecha, e.conduce,
           e.observ1, e.tipo_cambio,
           e.tipo_refe, e.no_refe,
           e.rowid rowid_me
      FROM arinme e
     WHERE e.no_cia     = cia_p
       AND e.no_docu    = docu_p
       AND e.tipo_doc   = tipo_p
       AND e.estado     = 'P';
  --
  -- Lineas de compras
  CURSOR c_lineas_doc IS
    SELECT l.linea_ext, l.linea, l.bodega,
           l.no_arti,
           nvl(l.unidades,0) unidades,  nvl(l.monto,0) monto,
           (nvl(l.monto,0) - nvl(l.descuento_l,0) + nvl(l.impuesto_l,0)) neto,
           nvl(l.monto_dol,0) monto_dol,
           d.grupo, d.costo_estandar, a.costo_uni,a.ult_costo, l.monto2,
           l.rowid rowid_ml
      FROM arinda d, arinml l, arinma a
     WHERE l.no_cia     = cia_p
       AND l.no_docu    = docu_p
       AND l.tipo_doc   = tipo_p
       AND l.no_cia     = d.no_cia
       AND l.no_arti    = d.no_arti
       AND -- join con arinma
           a.no_cia     = l.no_cia
       AND a.bodega     = l.bodega
       AND a.no_arti    = l.no_arti;
  --
  --
  CURSOR c_lotes ( cia_c  varchar2,     tip_c  varchar2,    doc_c  varchar2,
                   lin_c  number) IS
    SELECT no_lote, nvl(unidades,0) unidades,
           0 monto,
           ubicacion, fecha_vence
      FROM arinmo
     WHERE no_cia   = cia_c
       AND no_docu  = doc_c
       AND tipo_doc = tip_c
       AND linea    = lin_c;
  --
  --
  rd  c_documento%ROWTYPE;

BEGIN
  --
  vtime_stamp  := time_stamp_p;
  --
  -- Busca el documento a actualizar
  OPEN  c_documento;
  FETCH c_documento INTO rd;
  vfound := c_documento%FOUND;
  CLOSE c_documento;
  IF not vfound THEN
    msg_error_p := 'No fue posible localizar la transaccion: '||docu_p;
    RAISE error_proceso;
  END IF;
  -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);
  IF movimi_p = 'E' THEN
    vsigno         := 1;
  ELSE
    vsigno         := -1;
  END IF;

  --
  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot := 0;
  vmov_tot2:= 0;

  FOR i IN c_lineas_doc LOOP

    vmov_tot   := nvl(vmov_tot, 0)  + nvl(i.monto,0);
    vmov_tot2  := nvl(vmov_tot2, 0)  + nvl(i.monto2,0);

      IF movimi_p = 'E' THEN

      -- El costo unitario solamente se actualiza cuando se trata
      -- de movimientos de entrada

      If i.unidades > 0 Then


        INcosto_Uni(rd.no_cia,
                    i.bodega,
                    i.no_arti,
                    i.unidades, --- cantidad transaccion
                    round(i.monto/i.unidades,6), --- costo de la transaccion
                    round(i.monto2/i.unidades,6),   --- costo2 de la transaccion
                    msg_error_p);
        If msg_error_p is not null Then
          Raise error_proceso;
        End If;
      End If;

   /*   --- si las cantidades que se cargan son cero actualiza el costo directamente en arinda y arinma
      elsif i.unidades = 0  Then

          update arinma
          set    costo_uni = i.monto,
                 costo2    = i.monto2
          where  no_cia    = cia_p
          and    no_arti   = i.no_arti;

          update arinda
          set    costo_unitario = i.monto,
                 costo2_unitario = i.monto2
          where  no_cia  = cia_p
          and    no_arti = i.no_arti;
*/

      end if;

    --
    -- Actualiza el monto de las compra en ARINMA (Maestro de articulos),
    -- el costo unitario del articulo y el ultimo costo.
    INActualiza_saldos_articulo (rd.no_cia, i.bodega, i.no_arti, 'PRODUCCION',
                                 (i.unidades * vsigno), (i.monto * vsigno),
                                 Null, msg_error_p);

    IF msg_error_p is not null THEN
      msg_error_p := msg_error_p||' '||i.no_arti;
      RAISE error_proceso;
    END IF;

    --- Este proceso se utiliza para actualizar los saldos valuados del costo y costo 2 del inventario ANR 27/04/2009

    INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);

    If i.unidades > 0 Then
      -- Inserta en ARINMN la linea que se esta procesando
      INinserta_mn(rd.no_cia,   rd.centro,      rd.tipo_doc,       rd.no_docu,
                   rd.periodo,  rper.mes_proce, rper.semana_proce, rper.indicador_sem,
                   rd.ruta,     i.linea_ext,    i.bodega,          i.no_arti,      rd.fecha,          i.unidades,
                   i.monto,     null,           rd.tipo_refe,      rd.no_refe,
                   null,        round(i.monto/i.unidades,6),        vtime_stamp,      '000000000',       'N', 0,
                   i.monto2, round(i.monto2/i.unidades,6));


    -- se efectua las actualizaciones para el desglose de los lotes de articulos.
    FOR j IN c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea) LOOP

      UPDATE arinlo
         SET saldo_unidad   = nvl(saldo_unidad, 0) + (j.unidades * vsigno),
             saldo_contable = 0,

             ---nvl(saldo_contable, 0) + (j.unidades * vsigno),  VALORES EN MONTO DEBE IR EN CERO ANR 18/06/2009
             saldo_monto    = 0---nvl(saldo_monto, 0) + (vmonto_lote * vsigno)
       WHERE no_cia = rd.no_cia
         AND bodega = i.bodega
         AND no_arti = i.no_arti
         AND no_lote = j.no_lote;
      --
      IF (sql%rowcount = 0) THEN
        INSERT INTO arinlo(no_cia,         bodega,
                           no_arti,        no_lote,     ubicacion,   saldo_unidad,
                           saldo_contable, saldo_monto, salida_pend, costo_lote,
                           proceso_toma,   exist_prep,  costo_prep,
                           fecha_entrada,  fecha_vence, fecha_fin_cuarentena )
                    VALUES(rd.no_cia,  i.bodega,
                           i.no_arti,  j.no_lote,     j.ubicacion, j.unidades,
                           0,0,0,0,

                           ---j.unidades, vmonto_lote,   0,           vmonto_lote / j.unidades, VALORES EN MONTO DEBE IR EN CERO ANR 18/06/2009
                           'N',        null,      null,
                           rd.fecha,   j.fecha_vence, null);
      END IF;
      -- Inserta en ARINMT la linea que se esta procesando
      INSERT INTO arinmt(no_cia,   centro,    tipo_doc,  ano,
                         ruta,     no_docu,   no_linea,  bodega,
                         no_arti,   no_lote,
                         unidades, venta,     descuento)
                  VALUES(rd.no_cia,  rd.centro,   rd.tipo_doc, rd.periodo,
                          rd.ruta,    rd.no_docu,  i.linea_ext, i.bodega,
                         i.no_arti,   j.no_lote,
                         j.unidades, 0,           0);
    END LOOP;  -- lotes de articulos

  end if;

  END LOOP; -- Lineas del documento
  --
  --
  -- Actualiza el estado del documento
  UPDATE arinme
     SET estado  = 'D',
         mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2
   WHERE no_cia = cia_p
     and no_docu = docu_p; -- rowid = rd.rowid_me;

  UPDATE arinmeh
     SET mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2
   WHERE no_cia = cia_p
     and no_docu = docu_p;
  --



EXCEPTION
  WHEN cuenta_contable.error THEN
       msg_error_p := cuenta_contable.ultimo_error;
       rollback;
       return;
  WHEN error_proceso THEN
       msg_error_p := NVL(msg_error_p, 'Error_proceso en CI_INACT_PRODUCCION');
       rollback;
       return;
  WHEN others THEN
       msg_error_p := 'CI_INACT_PRODUCCION '|| SQLERRM;
       rollback;
       return;
END;