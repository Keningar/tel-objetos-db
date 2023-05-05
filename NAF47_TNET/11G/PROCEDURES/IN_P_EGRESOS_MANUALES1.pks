create or replace PROCEDURE            IN_P_EGRESOS_MANUALES1(Pv_NoCia          IN VARCHAR2,
                                                  Pv_TipoDocumento  IN VARCHAR2,
                                                  Pv_NoDocumento    IN VARCHAR2,
                                                  Pv_TipoMovimiento IN VARCHAR2,
                                                  Pv_CtaDocumento   IN VARCHAR2,
                                                  Pd_FechaProceso   IN DATE,
                                                  Pv_MensajeError   IN OUT VARCHAR2) IS
  -- Este procedimiento es un apoyo al procedimiento INactualiza, y por lo
  -- tanto solo INactualiza deberia utilizarlo.
  -- La funcion es actualizar las requisciones que disminuyen el inventario

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
           e.c_costo_emplesol,
           e.rowid rowid_me,
           e.id_presupuesto --FEM 
      FROM arinme e
     WHERE e.no_cia = Pv_NoCia
       AND e.no_docu = Pv_NoDocumento
       AND e.tipo_doc = Pv_TipoDocumento
       AND e.estado = 'P';

  -- Lineas de requisiciones
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
           g.metodo_costo,
           l.rowid rowid_ml,
           nvl(d.usado_instalacion,'N') usado_instalacion,
           nvl(ind_control_activo_fijo,'N') ind_control_activo_fijo
      FROM arinda d,
           arinml l,
           grupos g
     WHERE l.no_cia = Pv_NoCia
       AND l.no_docu = Pv_NoDocumento
       AND l.tipo_doc = Pv_TipoDocumento
       AND l.no_cia = d.no_cia
       AND l.no_arti = d.no_arti
       AND g.no_cia = d.no_cia
       AND g.grupo = d.grupo;

  CURSOR C_cuenta_partida(Cn_presupuesto IN NUMBER) IS
    SELECT a.cuenta_contable,
           a.centro_costo
      FROM arprem a
     WHERE no_cia = Pv_NoCia
       AND id_presupuesto = Cn_presupuesto;
  ---
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
  --
  cursor c_es_flujo_anterior is
    select descripcion
      from ge_grupos_parametros a
     where a.id_empresa = Pv_NoCia
       and a.id_grupo_parametro = 'FLUJO_ANTERIOR'
       and a.id_aplicacion = 'IN'
       and a.estado = 'A';
  --
  Lr_es_flujo_anterior c_es_flujo_anterior%rowtype := null;
  --
  error_proceso EXCEPTION;
  vtime_stamp    DATE;
  rper           inlib.periodo_proceso_r;
  vfound         BOOLEAN;
  vtmov_ctaInv   arindc.tipo_mov%TYPE;
  vtmov_ctaHaber arindc.tipo_mov%TYPE;
  vcta_inv       arindc.cuenta%TYPE; -- cuenta de inventario
  vcta_cpartida  arindc.cuenta%TYPE; -- cuenta de costo de ventas
  vrctas         inlib.cuentas_contables_r;
  vcentro_costo  arincc.centro_costo%TYPE; -- centro de costo de inventarios
  vsigno_consumo NUMBER(2);
  vsignoaux      NUMBER(2);
  vcosto_art     arinma.costo_uni%TYPE := 0;
  vcosto2_art    arinma.costo_uni%TYPE := 0;
  vmov_tot       arinme.mov_tot%TYPE;
  vmov2_tot      arinme.mov_tot%TYPE;
  vmonto_lote    NUMBER;
  --  vcentro_cero    arindc.centro_costo%type;
  vtercero_dc      arindc.codigo_tercero%TYPE := NULL;
  rd               c_documento%ROWTYPE;
  Ln_costo2        Arinda.costo2_unitario%TYPE := 0;
  Lv_centro_costo  arprem.centro_costo%TYPE := NULL;
  Lv_cuenta_conta  arprem.cuenta_contable%TYPE := NULL;
  Lv_centro_contra arprem.centro_costo%TYPE := NULL;

  --- Ln_costo_activo Arinda.costo_unitario%type;
BEGIN
  --  lo primero que se hace es recuperar si pertenece la 
  -- empresa pertenece a flujo anterior
  if c_es_flujo_anterior%isopen then close c_es_flujo_anterior; end if;
  open c_es_flujo_anterior;
  fetch c_es_flujo_anterior into Lr_es_flujo_anterior;
  if c_es_flujo_anterior%notfound then
    Lr_es_flujo_anterior := null;
  end if;
  close c_es_flujo_anterior;

  --
  vtime_stamp := Pd_FechaProceso;

  -- Busca el documento a actualizar
  OPEN c_documento;
  FETCH c_documento
    INTO rd;
  vfound := c_documento%FOUND;
  CLOSE c_documento;

  IF NOT vfound THEN
    Pv_MensajeError := 'No fue posible localizar la transaccion: ' || Pv_NoDocumento;
    RAISE error_proceso;
  END IF;

  -- trae y valida el periodo en proceso
  IF NOT inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper) THEN
    Pv_MensajeError := 'No fue posible determinar el periodo proceso para cia: ' || rd.no_cia || ' centro:' || rd.centro;
    RAISE error_proceso;
  END IF;

  -- define el vsigno de la actualizacion y la forma del detalle contable
  -- vcta_haber := Pv_CtaDocumento;
  IF Pv_TipoMovimiento = 'E' THEN
    vsigno_consumo := -1;
    vtmov_ctaInv   := 'D';
    vtmov_ctaHaber := 'C';
  ELSE
    vsigno_consumo := 1;
    vtmov_ctaInv   := 'C';
    vtmov_ctaHaber := 'D';
  END IF;

  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot  := 0;
  vmov2_tot := 0;
  --
  FOR Lr_Detalle IN c_lineas_doc LOOP
  
    -- determina el costo unitario del articulo
    vcosto_art  := articulo.costo(Pv_NoCia, Lr_Detalle.no_arti, Lr_Detalle.bodega);
    Ln_costo2   := articulo.costo2(Pv_NoCia, Lr_Detalle.no_arti, Lr_Detalle.bodega);
    vcosto2_art := Ln_costo2;
  
    vcosto_art  := NVL(vcosto_art, 0);
    vcosto2_art := NVL(vcosto2_art, 0);
  
    -- calcula el costo de la salida
    Lr_Detalle.monto  := NVL(moneda.redondeo(Lr_Detalle.unidades * vcosto_art, 'P'), 0);
    Lr_Detalle.monto2 := NVL(moneda.redondeo(Lr_Detalle.unidades * vcosto2_art, 'P'), 0);
  
    IF rd.tipo_cambio > 0 THEN
      Lr_Detalle.monto_dol  := NVL(moneda.redondeo(Lr_Detalle.monto / rd.tipo_cambio, 'D'), 0);
      Lr_Detalle.monto2_dol := NVL(moneda.redondeo(Lr_Detalle.monto2 / rd.tipo_cambio, 'D'), 0);
    ELSE
      Lr_Detalle.monto_dol  := 0;
      Lr_Detalle.monto2_dol := 0;
    END IF;
    --
    -- calcula el costo del documento
    UPDATE arinml
       SET monto      = Lr_Detalle.monto,
           monto_dol  = Lr_Detalle.monto_dol,
           monto2     = Lr_Detalle.monto2,
           monto2_dol = Lr_Detalle.monto2_dol
     WHERE ROWID = Lr_Detalle.rowid_ml;
  
    vmov_tot  := NVL(vmov_tot, 0) + NVL(Lr_Detalle.monto, 0);
    vmov2_tot := NVL(vmov2_tot, 0) + NVL(Lr_Detalle.monto2, 0);
  
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    IF NOT INLIB.trae_cuentas_conta(Pv_NoCia, Lr_Detalle.grupo, Lr_Detalle.bodega, vrctas) THEN
      Pv_MensajeError := 'Falta definir las cuentas contables, para bodega: ' || Lr_Detalle.bodega || '  grupo: ' || Lr_Detalle.grupo;
      RAISE error_proceso;
    END IF;
  
    --FEM 04-2012 Codigo Partida Presupuestaria
    --Se agrega para que en caso de tener partida presupuestaria
    --el cuadre contable sea Inv x Partida Presupuestaria.
  
    IF rd.id_presupuesto IS NOT NULL THEN
      ---
      OPEN C_cuenta_partida(rd.id_presupuesto);
      FETCH C_cuenta_partida
        INTO Lv_cuenta_conta,
             Lv_centro_costo;
      CLOSE C_cuenta_partida;
      ---
      vcta_cpartida    := Lv_cuenta_conta;
      Lv_centro_contra := Lv_centro_costo;
    ELSE
      --- llindao: debe leer la cuenta contrapartida del documento
      -- llindao parche 25/03/2013: si es flujo anterior por defecto va como contrapartida
      -- la cuenta configurada en el tipo de documento
      if Lr_es_flujo_anterior.Descripcion is not null or  -- flujo anterior
        nvl(Lr_Detalle.Usado_Instalacion,'N') = 'N' then -- no se instala
        vcta_cpartida    := Pv_CtaDocumento; -- vrctas.cta_contrapartida_requi;
        Lv_centro_contra := rd.c_costo_emplesol;
      else
        if Lr_Detalle.ind_control_activo_fijo = 'N' then -- es material
          vcta_cpartida    := vrctas.cta_transitoria_costo; 
          Lv_centro_contra := rd.c_costo_emplesol;
        elsif Lr_Detalle.ind_control_activo_fijo = 'S' then -- es activo fijo
          vcta_cpartida    := vrctas.cta_transitoria_AF;
          Lv_centro_contra := rd.c_costo_emplesol;
        end if;
      end if;
      ---
    END IF;
    --FIN FEM
    --
    vcta_inv      := vrctas.cta_inventario;
    vcentro_costo := vrctas.centro_costo;
  
    IF vcta_inv IS NULL THEN
      Pv_MensajeError := 'Debe configurar la cuenta de inventario para el grupo: ' || Lr_Detalle.grupo || ' bodega: ' || Lr_Detalle.bodega;
      RAISE error_proceso;
    ELSIF vcta_cpartida IS NULL THEN
      Pv_MensajeError := 'Debe configurar la cuenta contrapartida de requisiciones, para el grupo: ' || Lr_Detalle.grupo || ' bodega: ' || Lr_Detalle.bodega;
      RAISE error_proceso;
    ELSIF vcentro_costo IS NULL THEN
      Pv_MensajeError := 'Debe configurar el centro de costos para la cuenta de inventarios, para el grupo: ' || Lr_Detalle.grupo || ' bodega: ' || Lr_Detalle.bodega;
      RAISE error_proceso;
    END IF;
  
    --- Solo debe contabilizar las cuentas contables pertenecientes a inventarios
    --- No considerar lo de activos fijos ANR 26/11/2010
  
    -- movimiento contable a la cuenta de inventario
    INinserta_dc(rd.no_cia, rd.centro, rd.tipo_doc, rd.no_docu, vtmov_ctaInv, vcta_inv, Lr_Detalle.monto, vcentro_costo, Lr_Detalle.monto_dol, rd.tipo_cambio, vtercero_dc);
  
    -- movimiento contable a la cuenta contrapartida
    INinserta_dc(rd.no_cia, rd.centro, rd.tipo_doc, rd.no_docu, vtmov_ctaHaber, vcta_cpartida, Lr_Detalle.monto, Lv_centro_contra, Lr_Detalle.monto_dol, rd.tipo_cambio, vtercero_dc);
  
    -- Actualiza los campos de consumo del articulo en ARINMA (Maestro
    -- de articulos)
    INActualiza_saldos_articulo(rd.no_cia, Lr_Detalle.bodega, Lr_Detalle.no_arti, 'CONSUMO', (Lr_Detalle.unidades * vsigno_consumo), (Lr_Detalle.monto * vsigno_consumo), NULL, Pv_MensajeError);
  
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
  
    --- No debe actualizarse el costo unitario del articulo ANR 27/04/2009
    --- pero si debe actualizar el monto 2 y el saldo valuado para todas las bodegas
    INCOSTO_ACTUALIZA(rd.no_cia, Lr_Detalle.no_arti);
    --
    BEGIN
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
         Lr_Detalle.no_arti,
         vcentro_costo,
         (Lr_Detalle.unidades * vsigno_consumo),
         (Lr_Detalle.monto * vsigno_consumo));
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        -- Actualiza el Historico de Consumo.
        UPDATE arinhc
           SET unidades = NVL(unidades, 0) + (Lr_Detalle.unidades * vsigno_consumo),
               monto    = NVL(monto, 0) + (Lr_Detalle.monto * vsigno_consumo)
         WHERE no_cia = rd.no_cia
           AND centro = rd.centro
           AND ano = rd.periodo
           AND semana = rper.semana_proce
           AND ind_sem = rper.indicador_sem
           AND centro_costo = Lr_Detalle.centro_costo
           AND no_arti = Lr_Detalle.no_arti;
      
      WHEN OTHERS THEN
        Pv_MensajeError := 'Error al crear registro de requisicion para articulo: ' || Lr_Detalle.no_arti || ' ' || SQLERRM;
        RAISE error_proceso;
    END;
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
                 Lr_Detalle.linea_ext,
                 Lr_Detalle.bodega,
                 Lr_Detalle.no_arti,
                 rd.fecha,
                 Lr_Detalle.unidades,
                 Lr_Detalle.monto,
                 NULL,
                 rd.tipo_refe,
                 rd.no_refe,
                 NULL,
                 vcosto_art, --Lr_Detalle.monto/Lr_Detalle.unidades,
                 vtime_stamp,
                 Lr_Detalle.centro_costo,
                 'N',
                 Lr_Detalle.precio_venta,
                 Lr_Detalle.monto2,
                 Ln_costo2); --Lr_Detalle.monto2);  --FEM
    --
    -- el signo del movimiento de lotes es inverso al del arinma.cons_xx
    vsignoaux := vsigno_consumo * -1;
  
    FOR j IN c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, Lr_Detalle.linea, vcosto_art) LOOP
      vmonto_lote := moneda.redondeo(j.monto, 'P');
      UPDATE arinlo
         SET saldo_unidad   = NVL(saldo_unidad, 0) + (j.unidades * vsignoaux),
             saldo_contable = 0, ---nvl(saldo_contable, 0) + (j.unidades * vsignoaux),  VALORES EN MONTO VA EN CERO ANR 18/06/2009
             saldo_monto    = 0 ---nvl(saldo_monto, 0)    + (vmonto_lote * vsignoaux)
       WHERE no_cia = rd.no_cia
         AND bodega = Lr_Detalle.bodega
         AND no_arti = Lr_Detalle.no_arti
         AND no_lote = j.no_lote;
    
      IF (SQL%ROWCOUNT = 0) THEN
        ---
        IF Pv_TipoMovimiento = 'E' THEN
          Pv_MensajeError := 'No existe lote: ' || j.no_lote || ' articulo: ' || Lr_Detalle.no_arti || ', devol. de requisicion :' || rd.no_docu;
          RAISE error_proceso;
        END IF;
        ---
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
           Lr_Detalle.bodega,
           Lr_Detalle.no_arti,
           j.no_lote,
           j.ubicacion,
           (j.unidades * vsignoaux),
           0,
           0,
           0,
           0,
           'N',
           NULL,
           NULL,
           rd.fecha,
           j.fecha_vence,
           NULL);
        ---
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
         Lr_Detalle.linea_ext,
         Lr_Detalle.bodega,
         Lr_Detalle.no_arti,
         j.no_lote,
         j.unidades,
         0,
         0);
    END LOOP; -- lotes por linea
  END LOOP; -- Lineas del documento

  --- Verifico que el asiento contable cuadre ANR 26/11/2010

  IF inverifica_conta(Pv_NoCia, Pv_NoDocumento, Pv_MensajeError) THEN
    RAISE Error_proceso;
  END IF;

  -- Actualiza el estado del documento
  UPDATE arinme
     SET estado   = 'D',
         mov_tot  = vmov_tot,
         mov_tot2 = vmov2_tot --FEM
   WHERE no_cia = rd.no_cia
     AND no_docu = rd.no_docu;

  UPDATE arinmeh
     SET mov_tot  = vmov_tot,
         mov_tot2 = vmov2_tot --FEM
   WHERE no_cia = rd.no_cia
     AND no_docu = rd.no_docu;

EXCEPTION
  WHEN error_proceso THEN
    Pv_MensajeError := NVL(Pv_MensajeError, 'error_proceso en Actualiza requisiciones');
    RETURN;
  WHEN OTHERS THEN
    Pv_MensajeError := 'IN_P_EGRESOS_MANUALES: ' || SQLERRM;
    RETURN;
END IN_P_EGRESOS_MANUALES1;