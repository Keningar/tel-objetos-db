CREATE OR REPLACE PROCEDURE NAF47_TNET.INACT_CONSUMO( cia_p        IN VARCHAR2,
                                          tipo_p       IN VARCHAR2,
                                          docu_p       IN VARCHAR2,
                                          movimi_p     IN VARCHAR2,
                                          interface_p  IN VARCHAR2,
                                          cta_docu_p   IN VARCHAR2,
                                          time_stamp_p IN DATE,
                                          msg_error_p  IN OUT VARCHAR2) IS
  --
  --  Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  --  tanto solo INactualiza deberia utilizarlo.
  --  La funcion es actualizar las requisciones que disminuyen el inventario

  -- Lee el documento de compra que esta pendiente de actualizar.
  CURSOR c_documento IS
    SELECT e.no_cia,
           e.centro,
           e.tipo_doc,
           e.no_docu,
           e.periodo,
           e.ruta,
           e.fecha,
           e.conduce,
           e.observ1,
           e.tipo_cambio,
           e.tipo_refe,
           e.no_refe,
           e.rowid rowid_me,
           e.c_costo_emplesol,
           e.tipo_consumo_interno
      FROM arinme e
     WHERE e.no_cia = cia_p
       AND e.no_docu = docu_p
       AND e.tipo_doc = tipo_p
       AND e.estado = 'P';
  --
  -- Lineas de compras
  CURSOR c_lineas_doc IS
    SELECT l.linea_ext,
           l.linea,
           l.bodega,
           l.no_arti,
           NVL(l.unidades, 0) unidades,
           NVL(l.monto, 0) monto,
           NVL(l.monto2, 0) monto2, --FEM
           NVL(l.monto_dol, 0) monto_dol,
           NVL(l.monto2_dol, 0) monto2_dol, --FEM
           l.centro_costo,
           l.precio_venta,
           d.grupo,
           d.costo_estandar,
           g.metodo_costo
      FROM arinda d,
           arinml l,
           grupos g
     WHERE l.no_cia = cia_p
       AND l.no_docu = docu_p
       AND l.tipo_doc = tipo_p
       AND l.no_cia = d.no_cia
       AND l.no_arti = d.no_arti
       AND g.no_cia = d.no_cia
       AND g.grupo = d.grupo;
  --
  CURSOR c_lotes(cia_c VARCHAR2,
                 tip_c VARCHAR2,
                 doc_c VARCHAR2,
                 lin_c NUMBER,
                 cost  NUMBER) IS
    SELECT no_lote,
           NVL(unidades, 0) unidades,
           NVL(unidades * cost, 0) monto,
           ubicacion,
           fecha_vence
      FROM arinmo
     WHERE no_cia = cia_c
       AND no_docu = doc_c
       AND tipo_doc = tip_c
       AND linea = lin_c;

  CURSOR c_cuenta(cia   VARCHAR2,
                  docu  VARCHAR2,
                  tCons VARCHAR2) IS 
    SELECT cuenta -- si es despacho pedido no retorna registro
      FROM arintipoconsumointer a
     WHERE a.no_cia = cia
       AND EXISTS (SELECT NULL
              FROM arinencconsumointer b,
                   arinme              c
             WHERE b.no_docu = c.no_docu_refe
               AND b.no_cia = c.no_cia
               AND b.tipo_ci = a.codigo
               AND b.no_cia = a.no_cia
               AND c.no_docu = docu)
     UNION
    SELECT cuenta -- si es despacho de pedido retorna registro
      FROM arintipoconsumointer a
     WHERE a.no_cia = cia
       AND a.codigo = tCons;
  --
  --
  rd        c_documento%ROWTYPE;
  Ln_costo2 arinma.costo_uni%TYPE := 0;
  error_proceso EXCEPTION;
  vtime_stamp    DATE;
  rper           inlib.periodo_proceso_r;
  vfound         BOOLEAN;
  vcta_inv       arindc.cuenta%TYPE;
  vcta_haber     arindc.cuenta%TYPE; -- cta del proveedor o del documento (si mov.no tiene prov)
  vtmov_ctaInv   arindc.tipo_mov%TYPE;
  vtmov_ctaHaber arindc.tipo_mov%TYPE;
  vsigno_consumo NUMBER(2);
  vsignoaux      NUMBER(2);
  vrctas         inlib.cuentas_contables_r;
  vcta_cpartida  arindc.cuenta%TYPE;
  vcosto_art     arinma.costo_uni%TYPE := 0;
  vcentro_costo  arincc.centro_costo%TYPE;
  vmov_tot       arinme.mov_tot%TYPE;
  vmov_tot2      arinme.mov_tot%TYPE;
  vmonto_lote    NUMBER;
  vtercero_dc    arindc.codigo_tercero%TYPE := NULL;
  ln_monto_cc    NUMBER := 0;
  Ctro_costo     arincc.centro_costo%TYPE;
BEGIN

  vtime_stamp := time_stamp_p;

  -- Busca el documento a actualizar
  OPEN c_documento;
  FETCH c_documento
    INTO rd;
  vfound := c_documento%FOUND;
  CLOSE c_documento;

  IF NOT vfound THEN
    msg_error_p := 'No fue posible localizar la transaccion: ' || docu_p;
    RAISE error_proceso;
  END IF;

  -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);
  --
  -- define el vsigno de la actualizacion y la forma del detalle contable
  OPEN c_cuenta(cia_p, docu_p, rd.tipo_consumo_interno);
  FETCH c_cuenta
    INTO vcta_haber;
  CLOSE c_cuenta;

  --  vcta_haber := cta_docu_p;
  IF movimi_p = 'E' THEN
    vsigno_consumo := -1;
    vtmov_ctaInv   := 'D';
    vtmov_ctaHaber := 'C';
  ELSE
    vsigno_consumo := 1;
    vtmov_ctaInv   := 'C';
    vtmov_ctaHaber := 'D';
  END IF;
  --
  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot := 0;
  FOR i IN c_lineas_doc LOOP
  
    -- determina el costo unitario del articulo
    vcosto_art := articulo.costo(cia_p, i.no_arti, i.bodega);
    Ln_costo2  := articulo.costo2(cia_p, i.no_arti, i.bodega); --FEM
  
    -- entrada
    /* llindao: se inhabilita porque trunca a 2 decimales el costo.
    IF i.metodo_costo != 'E' THEN
      -- calcula el costo unitario del articulo
      vcosto_art := NVL(i.monto, 0) / NVL(i.unidades, 0);
    END IF;
    */
  
    vcosto_art := NVL(vcosto_art, 0);
  
    -- calcula el costo de la salida
    i.monto  := NVL(moneda.redondeo(i.unidades * vcosto_art, 'P'), 0);
    i.monto2 := NVL(moneda.redondeo(i.unidades * Ln_costo2, 'P'), 0); --FEM
  
    IF rd.tipo_cambio > 0 THEN
      i.monto_dol  := NVL(moneda.redondeo(i.monto / rd.tipo_cambio, 'D'), 0);
      i.monto2_dol := NVL(moneda.redondeo(i.monto2 / rd.tipo_cambio, 'D'), 0);
    ELSE
      i.monto_dol  := 0;
      i.monto2_dol := 0;
    END IF;
    --
    -- calcula el costo del documento
    UPDATE arinml
       SET monto      = i.monto,
           monto_dol  = i.monto_dol,
           monto2     = i.monto2,
           monto2_dol = i.monto2_dol
     WHERE no_cia = rd.no_cia
       AND no_docu = rd.no_docu
       AND linea = i.linea;
  
    vmov_tot  := NVL(vmov_tot, 0) + NVL(i.monto, 0);
    vmov_tot2 := NVL(vmov_tot2, 0) + NVL(i.monto2, 0);
  
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    IF NOT INLIB.trae_cuenta_inventario(cia_p, i.grupo, i.bodega, vcta_inv) THEN
      msg_error_p := 'Falta definir la cuenta de inventario, ' || 'para bodega: ' || i.bodega || '  grupo: ' || i.grupo;
      RAISE error_proceso;
    END IF;
  
    IF NOT INLIB.trae_centro_costo(cia_p, i.grupo, i.bodega, Ctro_costo) THEN
      msg_error_p := 'Falta definir el centro costo del inventario, ' || 'para bodega: ' || i.bodega || '  grupo: ' || i.grupo;
      RAISE error_proceso;
    END IF;
  
    --FEM 01-2009 agregado por un requerimiento del centro de costo.
    IF NOT INLIB.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) THEN
      msg_error_p := 'Falta definir las cuentas contables, ' || 'para bodega: ' || i.bodega || '  grupo: ' || i.grupo;
      RAISE error_proceso;
    END IF;
  
    vcta_inv      := vrctas.cta_inventario;
    vcta_cpartida := vrctas.cta_contrapartida_requi;
    vcentro_costo := vrctas.centro_costo;
    --FIN FEM 01-2009
  
    --acumulo el monto total
    ln_monto_cc := ln_monto_cc + i.monto;
  
    -- movimiento contable a la cuenta de inventario
    INinserta_dc(rd.no_cia, rd.centro, rd.tipo_doc, rd.no_docu, vtmov_ctaInv, vcta_inv, i.monto, vcentro_costo, i.monto_dol, rd.tipo_cambio, vtercero_dc);
    --
  
    -- movimiento contable a la cuenta contrapartida
    INinserta_dc(rd.no_cia,
                 rd.centro,
                 rd.tipo_doc,
                 rd.no_docu,
                 vtmov_ctaHaber,
                 vcta_haber, --vcta_cpartida,
                 i.monto,
                 rd.c_costo_emplesol,
                 i.monto_dol,
                 rd.tipo_cambio,
                 vtercero_dc);
  
    -- Actualiza los campos de consumo del articulo en ARINMA (Maestro
    -- de articulos)
    INActualiza_saldos_articulo(rd.no_cia, i.bodega, i.no_arti, 'CONSUMO', (i.unidades * vsigno_consumo), (i.monto * vsigno_consumo), NULL, msg_error_p);
  
    IF msg_error_p IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
  
    --- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
    --- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas
  
    INCOSTO_ACTUALIZA(rd.no_cia, i.no_arti);
  
    -- Actualiza el Historico de Consumo.
    UPDATE arinhc
       SET unidades = NVL(unidades, 0) + (i.unidades * vsigno_consumo),
           monto    = NVL(monto, 0) + (i.monto * vsigno_consumo)
     WHERE no_cia = rd.no_cia
       AND centro = rd.centro
       AND ano = rd.periodo
       AND semana = rper.semana_proce
       AND ind_sem = rper.indicador_sem
       AND centro_costo = i.centro_costo
       AND no_arti = i.no_arti;
    --
    IF SQL%NOTFOUND THEN
      INSERT INTO arinhc
        (no_cia,
         centro,
         ano,
         semana,
         ind_sem,
         no_arti,
         centro_costo,
         unidades,
         monto)
      VALUES
        (rd.no_cia,
         rd.centro,
         rd.periodo,
         rper.semana_proce,
         rper.indicador_sem,
         i.no_arti,
         i.centro_costo,
         (i.unidades * vsigno_consumo),
         (i.monto * vsigno_consumo));
    END IF;
    --
    -- Inserta en ARINMN la linea que se esta procesando
    INinserta_mn(rd.no_cia,
                 rd.centro,
                 rd.tipo_doc,
                 rd.no_docu,
                 rd.periodo,
                 rper.mes_proce,
                 rper.semana_proce,
                 rper.indicador_sem,
                 rd.ruta,
                 i.linea_ext,
                 i.bodega,
                 i.no_arti,
                 rd.fecha,
                 i.unidades,
                 i.monto,
                 NULL,
                 rd.tipo_refe,
                 rd.no_refe,
                 NULL,
                 vcosto_art, --i.monto/i.unidades,
                 vtime_stamp,
                 i.centro_costo,
                 'N',
                 i.precio_venta,
                 i.monto2,
                 Ln_costo2);
    --
    -- el signo del movimiento de lotes es inverso al del arinma.cons_xx
    vsignoaux := vsigno_consumo * -1;
  
    FOR j IN c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea, vcosto_art) LOOP
      vmonto_lote := moneda.redondeo(j.monto, 'P');
      UPDATE arinlo
         SET saldo_unidad   = NVL(saldo_unidad, 0) + (j.unidades * vsignoaux),
             saldo_contable = 0, ---nvl(saldo_contable, 0) + (j.unidades * vsignoaux), valores en monto va en cero ANR 18/06/2009
             saldo_monto    = 0 ---nvl(saldo_monto, 0)    + (vmonto_lote * vsignoaux)
       WHERE no_cia = rd.no_cia
         AND bodega = i.bodega
         AND no_arti = i.no_arti
         AND no_lote = j.no_lote;
    
      IF (SQL%ROWCOUNT = 0) THEN
        IF movimi_p = 'E' THEN
          msg_error_p := 'No existe lote: ' || j.no_lote || ' articulo: ' || i.no_arti || ', devol. de requisicion :' || rd.no_docu;
          RAISE error_proceso;
        END IF;
      
        INSERT INTO arinlo
          (no_cia,
           bodega,
           no_arti,
           no_lote,
           ubicacion,
           saldo_unidad,
           saldo_contable,
           saldo_monto,
           salida_pend,
           costo_lote,
           proceso_toma,
           exist_prep,
           costo_prep,
           fecha_entrada,
           fecha_vence,
           fecha_fin_cuarentena)
        VALUES
          (rd.no_cia,
           i.bodega,
           i.no_arti,
           j.no_lote,
           j.ubicacion,
           (j.unidades * vsignoaux),
           0,
           0,
           0, ---(j.unidades*vsignoaux),      (vmonto_lote*vsignoaux), 0,
           0, --vmonto_lote / j.unidades,valores en monto va en cero ANR 18/06/2009
           'N',
           NULL,
           NULL,
           rd.fecha,
           j.fecha_vence,
           NULL);
      END IF;
    
      -- Inserta en ARINMT la linea que se esta procesando
      INSERT INTO arinmt
        (no_cia,
         centro,
         tipo_doc,
         ano,
         ruta,
         no_docu,
         no_linea,
         bodega,
         no_arti,
         no_lote,
         unidades,
         venta,
         descuento)
      VALUES
        (rd.no_cia,
         rd.centro,
         rd.tipo_doc,
         rd.periodo,
         rd.ruta,
         rd.no_docu,
         i.linea_ext,
         i.bodega,
         i.no_arti,
         j.no_lote,
         j.unidades,
         0,
         0);
    END LOOP; -- lotes por linea
  END LOOP; -- Lineas del documento

  --
  -- Actualiza el estado del documento
  UPDATE arinme
     SET estado   = 'D',
         mov_tot  = vmov_tot,
         mov_tot2 = vmov_tot2
   WHERE no_cia = rd.no_cia
     AND no_docu = rd.no_docu;

  UPDATE arinmeh
     SET mov_tot  = vmov_tot,
         mov_tot2 = vmov_tot2
   WHERE no_cia = rd.no_cia
     AND no_docu = rd.no_docu;
  ---
EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := NVL(msg_error_p, 'error_proceso en Actualiza requisiciones');
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := 'INACT_CONSUMO: ' || SQLERRM;
    RETURN;
END;
/