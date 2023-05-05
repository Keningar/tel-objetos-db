create or replace PROCEDURE            inact_produccion (cia_p         IN varchar2,
                                              tipo_p        IN varchar2,
                                              docu_p        IN varchar2,
                                              movimi_p      IN varchar2,
                                              interface_p   IN varchar2,
                                              cta_docu_p    IN varchar2,
                                              time_stamp_p  IN date,
                                              msg_error_p   IN OUT varchar2) Is
  --
  --  Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  --  tanto solo INactualiza deberia utilizarlo.
  --  La funcion es actualizar documentos de produccion o
  --  devolucion de producciones

  -- FEM 23-01-2009 Se modifica para que la cuenta contrapartida la tome de lo configurado en la cuenta ARINVTM.
  -- Lee el documento de compra que esta pendiente de actualizar.

  CURSOR c_documento IS
    SELECT e.no_cia, e.centro, e.tipo_doc, e.no_docu,
           e.periodo, e.ruta,
           e.fecha, e.conduce,
           e.observ1, e.tipo_cambio,
           e.tipo_refe, e.no_refe, e.c_costo_emplesol, e.no_docu_refe, --- sirve para relacionar con reordenamiento ANR 29-04-2010
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
           nvl(l.unidades,0) unidades,
           nvl(l.monto,0) monto,
           nvl(l.monto2,0) monto2,
           (nvl(l.monto,0) - nvl(l.descuento_l,0) + nvl(l.impuesto_l,0)) neto,
           (nvl(l.monto2,0) - nvl(l.descuento_l,0) + nvl(l.impuesto_l,0)) neto2, --FEM
           nvl(l.monto_dol,0) monto_dol,
           nvl(l.monto2_dol,0) monto_dol2,
           d.grupo, d.costo_estandar, a.costo_uni,a.ult_costo,
           l.rowid rowid_ml,L.PRECIO_VENTA
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
                   lin_c  number,       cost   number  ) IS
    SELECT no_lote, nvl(unidades,0) unidades,
           nvl(unidades*cost,0) monto,
           ubicacion, fecha_vence
      FROM arinmo
     WHERE no_cia   = cia_c
       AND no_docu  = doc_c
       AND tipo_doc = tip_c
       AND linea    = lin_c ;

  Cursor C_contrapartida (Cv_cia in varchar2,
                          Cv_int in varchar2,
                          Cv_tip in varchar2,
                          Cv_mov in varchar2) Is
  Select cta_contrapartida
    From arinvtm
   Where no_cia    = Cv_cia
     and interface = Cv_int
     and tipo_m    = Cv_tip
     and movimi    = Cv_mov;
  --
  --
  -- Recuperar en un cursor los datos de reordenamientos por articulos y por numeros de transaccion de reordenamiento ANR 29-04-2010

  Cursor C_Reordenamiento_salida (Lv_arti Varchar2, Lv_docu Varchar2) Is
    select nvl(costo_uni_sistema,0), nvl(costo2_uni_sistema,0)
    from ARINENCREORDENPRODUCCION
    where no_cia = cia_p
    and   no_arti = Lv_arti
    and   no_docu = Lv_docu
    UNION
    select nvl(costo_uni_sistema,0), nvl(costo2_uni_sistema,0)
    from ARINDETREORDENPRODUCCION
    where no_cia = cia_p
    and   no_arti = Lv_arti
    and   no_docu = Lv_docu
    UNION
    select nvl(costo_uni_sistema,0), nvl(costo2_uni_sistema,0)
    from ARINENCORDMUCHO
    where no_cia = cia_p
    and   no_arti = Lv_arti
    and   no_docu = Lv_docu;
  --
  Cursor C_Reordenamiento_entrada (Lv_arti Varchar2, Lv_docu Varchar2) Is
    select nvl(costo_uni_calculado,0), nvl(costo2_uni_calculado,0)
    from ARINENCREORDENPRODUCCION
    where no_cia = cia_p
    and   no_arti = Lv_arti
    and   no_docu = Lv_docu
    UNION
    select nvl(costo_manual,0), nvl(costo_manual2,0)
    from ARINDETREORDENPRODUCCION
    where no_cia = cia_p
    and   no_arti = Lv_arti
    and   no_docu = Lv_docu;

  --
  error_proceso      EXCEPTION;
  --
  vtime_stamp        Date;
  rper               inlib.periodo_proceso_r;
  vfound             Boolean;
  vcta_inv           arindc.cuenta%type;
  vcta_haber         arindc.cuenta%type;  -- cta del proveedor o del documento (si mov.no tiene prov)
  vtmov_ctaInv       arindc.tipo_mov%type;
  vtmov_ctaHaber     arindc.tipo_mov%type;
  vsigno             number(2);
  vcosto_art         arinma.costo_uni%type;
  vmov_tot           arinme.mov_tot%type;
  vmov_tot2          arinme.mov_tot%type;   --FEM
  vmonto_lote        number;
  vrctas             inlib.cuentas_contables_r;
  vcta_cpartida      arindc.cuenta%type;
  vcentro_costo      arincc.centro_costo%type;
  vtercero_dc        arindc.codigo_tercero%type:=null;
  rd                 c_documento%ROWTYPE;
  Lv_contrapartida   arinvtm.cta_contrapartida%type;
  ln_costo2          arinma.costo2%type;

  ln_costo_uni_sistema    arinma.costo_uni%type;
  ln_costo2_uni_sistema   arinma.costo2%type;

  ln_costo_uni_calculado   arinma.costo_uni%type;
  ln_costo2_uni_calculado  arinma.costo2%type;

  Lv_reordenamiento        Varchar2(1) := 'N';


BEGIN
  --
  --
  vtime_stamp  := time_stamp_p;
  --
  IF cta_docu_p is null THEN
    msg_error_p := 'El tipo de documento NO tiene definida cuenta contable...';
    RAISE error_proceso;
  END IF;
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
  -- define el vsigno de la actualizacion y la forma del detalle contable
  vcta_haber := cta_docu_p;

  If movimi_p = 'E' Then
    vsigno         :=  1;
    vtmov_ctaInv   := 'D';
    vtmov_ctaHaber := 'C';
  Else
    vsigno         := -1;
    vtmov_ctaInv   := 'C';
    vtmov_ctaHaber := 'D';
  End If;

  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot := 0;
  FOR i IN c_lineas_doc LOOP
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    IF not INLIB.trae_cuenta_inventario(cia_p, i.grupo, i.bodega, vcta_inv) THEN
      msg_error_p := 'Falta definir la cuenta de inventario, '||
                     'para bodega: '||i.bodega||'  grupo: '||i.grupo;
      RAISE error_proceso;
    END IF;

    -- determina el costo unitario del articulo

    -- En esta parte se debe verificar que si la transaccion existe en reordenamiento, debe ingresar al nuevo proceso para crear el ARINMN, caso contrario debe ingresar directamente al ARINMN como estaba antes ANR 29-04-2010
    -- por no_docu_refe se relaciona tablas de reordenamientos con arinmeh ANR 29-04-2010

   IF movimi_p = 'S' THEN

     --- Si es movimiento de salida y si es reordenamiento debe recuperar el costo registrado en el reordenamiento

            Open C_Reordenamiento_salida (i.no_arti, rd.no_docu_refe);
            Fetch C_Reordenamiento_salida into ln_costo_uni_sistema, ln_costo2_uni_sistema;
            IF C_Reordenamiento_salida%notfound Then
               ln_costo_uni_sistema  := 0;
               ln_costo2_uni_sistema := 0;

              Close C_Reordenamiento_salida;

              Lv_reordenamiento := 'N'; --- Marca si no es reordenamiento

            Else
              Close C_Reordenamiento_salida;

              Lv_reordenamiento := 'S'; --- Marca si es reordenamiento

              If Ln_costo_uni_sistema = 0 Then
                msg_error_p := 'El costo unitario para la salida de reordenamiento, para el documento: '||rd.no_docu||' articulo: '||i.no_arti||' no puede ser cero';
                raise Error_proceso;
              end if;

              If Ln_costo2_uni_sistema = 0 Then
                msg_error_p := 'El costo2 unitario para la salida de reordenamiento, para el documento: '||rd.no_docu||' articulo: '||i.no_arti||' no puede ser cero';
                raise Error_proceso;
              end if;

            End if;

    else

   --- Si es movimiento de entrada y si es reordenamiento debe recuperar el costo calculado en el reordenamiento

            Open C_Reordenamiento_entrada (i.no_arti, rd.no_docu_refe);
            Fetch C_Reordenamiento_entrada into ln_costo_uni_calculado, ln_costo2_uni_calculado;
            IF C_Reordenamiento_entrada%notfound Then
               ln_costo_uni_calculado  := 0;
               ln_costo2_uni_calculado := 0;

              Close C_Reordenamiento_entrada;

              Lv_reordenamiento := 'N'; --- Marca si no es reordenamiento

            Else
              Close C_Reordenamiento_entrada;

              Lv_reordenamiento := 'S'; --- Marca si es reordenamiento

              If Ln_costo_uni_calculado = 0 Then
                msg_error_p := 'El costo unitario calculado para la entrada de reordenamiento, para el documento: '||rd.no_docu||' articulo: '||i.no_arti||' no puede ser cero';
                raise Error_proceso;
              end if;

              If Ln_costo2_uni_calculado = 0 Then
                msg_error_p := 'El costo2 unitario calculado para la entrada de reordenamiento, para el documento: '||rd.no_docu||' articulo: '||i.no_arti||' no puede ser cero';
                raise Error_proceso;
              end if;

            End if;

    end if;

    If Lv_reordenamiento = 'N' Then ---- recupera el costo tal cual lo ha venido recuperando

          -- determina el costo unitario del articulo
          vcosto_art := nvl(articulo.costo(cia_p, i.no_arti, i.bodega),0);
          ln_costo2  := nvl(articulo.costo2(cia_p, i.no_arti, i.bodega),0); --FEM

    else

          vcosto_art := 0;
          -- determina el costo unitario del articulo
          If movimi_p = 'S' Then
            vcosto_art := Ln_costo_uni_sistema;
            ln_costo2  := Ln_costo2_uni_sistema;
          else
            vcosto_art := Ln_costo_uni_calculado;
            ln_costo2  := Ln_costo2_uni_calculado;
          end if;

    end if;


    --- Solo debe actualizar ARINML, ajustando el costo, cuando es>
    --- Movimiento de salida, debe buscar de ARINMA costo uni
    --- Movimiento de entrada y reordenamiento, debe buscar en las tablas de reordenamiento

    If movimi_p = 'S' or (movimi_p = 'E' and Lv_reordenamiento = 'S') Then --- solo para la salida hace esta actualizacion ANR 26/11/2009
      -- calcula el costo de la salida
      i.monto  := nvl(moneda.redondeo( i.unidades * vcosto_art, 'P'), 0);
      i.monto2 := nvl(moneda.redondeo( i.unidades * Ln_costo2, 'P'), 0);  --FEM

      If rd.tipo_cambio > 0 Then
        i.monto_dol  := nvl(moneda.redondeo(i.monto  / rd.tipo_cambio, 'D'), 0);
        i.monto_dol2 := nvl(moneda.redondeo(i.monto2 / rd.tipo_cambio, 'D'), 0);  --FEM
      Else
        i.monto_dol  := 0;
        i.monto_dol2 := 0; --FEM
      End If;
      --
      -- calcula el costo del documento
      Update arinml
         Set monto      = i.monto,  --- Ajusto los valores a lo que viene en el reordenamiento o al costo uni de arinma
             monto_dol  = i.monto_dol,
             monto2     = i.monto2,   --FEM
             monto2_dol = i.monto_dol2  --FEM
       Where Rowid = i.rowid_ml;
    End If;

    vmov_tot   := nvl(vmov_tot, 0)  + nvl(i.monto,0);
    vmov_tot2  := nvl(vmov_tot2, 0)  + nvl(i.monto2,0);

    --

    -- segun la legislacion colombiana, las cuentas contables usadas para contabilizar los movimientos
    -- de produccion, NO deben manejar tercero.
    If cuenta_contable.acepta_tercero(cia_p, vcta_inv) THEN
      msg_error_p := 'La cuenta de Inventarios para los articulos en la bodega '||
                     i.bodega||' y grupo '||i.grupo||' no debe manejar terceros';
      Raise error_proceso;
    End If;

    If cuenta_contable.acepta_tercero(cia_p, vcta_haber) Then
      msg_error_p := 'La cuenta de contrapartida para el tipo de documento '||
                     rd.tipo_doc||' NO debe manejar terceros';
      Raise Error_proceso;
    End If;

     If Not INLIB.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) Then
       msg_error_p := 'Falta definir las cuentas contables, '||
                      'para bodega: '||i.bodega||'  grupo: '||i.grupo;
       Raise error_proceso;
     End If;

     Open C_contrapartida(cia_p, interface_p, tipo_p, movimi_p);
     Fetch C_contrapartida into Lv_contrapartida;
     Close C_contrapartida;

     vcta_inv       := vrctas.cta_inventario;
  -- vcta_cpartida  := vrctas.cta_contrapartida_requi;   FEM no aplica
     vcta_cpartida  := Lv_contrapartida;
     vcentro_costo  := vrctas.centro_costo;

    If vcta_cpartida is null then
      msg_error_p:= 'Falta definir la cuenta contrapartida';
      Raise Error_proceso;
    End If;

     -- movimiento contable a la cuenta de inventario
     INinserta_dc(rd.no_cia,      rd.centro,     rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaInv,  vcta_inv,
                  i.monto,        vcentro_costo, i.monto_dol,
                  rd.tipo_cambio, vtercero_dc);
     --
     -- movimiento contable a la cuenta contrapartida
     INinserta_dc(rd.no_cia,      rd.centro,       rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaHaber,  vcta_cpartida,
                  i.monto,        rd.c_costo_emplesol, i.monto_dol,
                  rd.tipo_cambio, vtercero_dc);
     --

     /**** NOTA IMPORTANTE: El orden de los procedimientos siempre va a ser:
           INCOSTO_UNI (SI ES ENTRADA DE COMPRAS, ENTRADA REORDENAMIENTO, ENTRADA IMPORTACION)
           INACTUALIZA_SALDOS_ARTICULOS (PARA TODOS LOS CASOS)
           INCOSTO_ACTUALIZA (PARA TODOS LOS CASOS)
           ANR 16/06/2010
     ****/

      IF movimi_p = 'E' THEN

      -- El costo unitario solamente se actualiza cuando se trata
      -- de movimientos de entrada

        INcosto_Uni(rd.no_cia,
                    i.bodega,
                    i.no_arti,
                    i.unidades, --- cantidad transaccion
                    vcosto_art, --- costo de la transaccion
                    ln_costo2,   --- costo2 de la transaccion
                    msg_error_p);
        If msg_error_p is not null Then
          Raise error_proceso;
        End If;
      End If;

     ---- Actualiza los campos de stock en ARINMA

      INActualiza_saldos_articulo  (rd.no_cia, i.bodega, i.no_arti, 'PRODUCCION',
                                    (i.unidades * vsigno), (i.monto * vsigno),
                                    Null, msg_error_p);


     IF msg_error_p is not null THEN
       RAISE error_proceso;
     END IF;

    --- Este proceso se utiliza para actualizar los saldos valuados del costo y costo 2 del inventario ANR 27/04/2009

      INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);

    -- Actualiza el Historico de produccion
    UPDATE arinhp
       SET unidades = nvl(unidades,0) + (i.unidades * vsigno),
           monto    = nvl(monto,0)    + (i.monto * vsigno)
     WHERE no_cia    = rd.no_cia
       AND centro    = rd.centro
       AND periodo   = rd.periodo
       AND no_arti   = i.no_arti;
    --
    IF SQL%NotFound THEN
      INSERT INTO arinhp(no_cia, centro, periodo,  no_arti, unidades, monto)
                  VALUES(rd.no_cia,   rd.centro, rd.periodo,        i.no_arti, (i.unidades * vsigno), (i.monto * vsigno));
    END IF;

    -- En esta parte se debe verificar que si la transaccion existe en reordenamiento, debe ingresar al nuevo proceso para crear el ARINMN, caso contrario debe ingresar directamente al ARINMN como estaba antes ANR 29-04-2010
    -- por no_docu_refe se relaciona tablas de reordenamientos con arinmeh ANR 29-04-2010

   IF movimi_p = 'S' THEN

     If Lv_reordenamiento = 'N' then

            -- Inserta en ARINMN la linea que se esta procesando
            INinserta_mn(rd.no_cia,         rd.centro,          rd.tipo_doc,
                         rd.no_docu,        rd.periodo,         rper.mes_proce,
                         rper.semana_proce, rper.indicador_sem, rd.ruta,
                         i.linea_ext,       i.bodega,           i.no_arti,
                         rd.fecha,          i.unidades,         i.monto,
                         null,              rd.tipo_refe,       rd.no_refe,
                         null,              i.monto/i.unidades,            vtime_stamp,
                         '000000000',       'N',                i.precio_venta,
                         i.monto2,          ln_costo2);
            Else

            -- Inserta en ARINMN la linea que se esta procesando para el reordenamiento
            INinserta_mn_reord (rd.no_cia,         rd.centro,          rd.tipo_doc,
                         rd.no_docu,        rd.periodo,         rper.mes_proce,
                         rper.semana_proce, rper.indicador_sem, rd.ruta,
                         i.linea_ext,       i.bodega,           i.no_arti,
                         rd.fecha,          i.unidades,
                         null,              rd.tipo_refe,       rd.no_refe,
                         null,              ln_costo_uni_sistema,            vtime_stamp,
                         '000000000',       'N',                i.precio_venta,
                         ln_costo2_uni_sistema);
            End if;

    else

    If Lv_reordenamiento = 'N' Then

            -- Inserta en ARINMN la linea que se esta procesando
            INinserta_mn(rd.no_cia,         rd.centro,          rd.tipo_doc,
                         rd.no_docu,        rd.periodo,         rper.mes_proce,
                         rper.semana_proce, rper.indicador_sem, rd.ruta,
                         i.linea_ext,       i.bodega,           i.no_arti,
                         rd.fecha,          i.unidades,         i.monto,
                         null,              rd.tipo_refe,       rd.no_refe,
                         null,              i.monto/i.unidades,            vtime_stamp,
                         '000000000',       'N',                i.precio_venta,
                         i.monto2,          ln_costo2);
            Else

            -- Inserta en ARINMN la linea que se esta procesando para el reordenamiento
            INinserta_mn_reord (rd.no_cia,         rd.centro,          rd.tipo_doc,
                         rd.no_docu,        rd.periodo,         rper.mes_proce,
                         rper.semana_proce, rper.indicador_sem, rd.ruta,
                         i.linea_ext,       i.bodega,           i.no_arti,
                         rd.fecha,          i.unidades,
                         null,              rd.tipo_refe,       rd.no_refe,
                         null,              ln_costo_uni_calculado,            vtime_stamp,
                         '000000000',       'N',                i.precio_venta,
                         ln_costo2_uni_calculado);
            End if;

    end if;


    -- se efectua las actualizaciones para el desglose de los lotes de articulos.
    FOR j IN c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea, vcosto_art) LOOP
      vmonto_lote := moneda.redondeo(j.monto, 'P');
      UPDATE arinlo
         SET saldo_unidad   = nvl(saldo_unidad, 0) + (j.unidades * vsigno),
             saldo_contable = 0,
             saldo_monto    = 0
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
  END LOOP; -- Lineas del documento
  --
  --
  -- Actualiza el estado del documento
  Update arinme
     Set estado  = 'D',
         mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2
   Where rowid = rd.rowid_me;

  Update arinmeh
     SET mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2
   where no_cia = cia_p
   and   no_docu = docu_p;
  --

EXCEPTION
  WHEN cuenta_contable.error THEN
       msg_error_p := cuenta_contable.ultimo_error;
       return;
  WHEN error_proceso THEN
       msg_error_p := NVL(msg_error_p, 'Error_proceso en Actualiza_produccion');
       return;
  WHEN others THEN
       msg_error_p := 'INACT_PRODUCCION '|| SQLERRM;
       return;
END;