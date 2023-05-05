create or replace PROCEDURE            FAANULA(pCia        IN arfafe.no_cia%TYPE,
                                    pTipo_Doc   IN arfafe.tipo_doc%TYPE,
                                    pNo_Factu   IN arfafe.No_factu%TYPE,
                                    pTipo_Anula IN arfafe.tipo_doc%TYPE,
                                    pFec_Anula  IN arfafe.Fecha%TYPE,
                                    pRazon      IN arfafe.razon%TYPE,
                                    mot_anula_p IN arfafe.motivo_anula%TYPE,
                                    doc_anula_p IN OUT arfafe.no_factu%TYPE,
                                    msg_error_p IN OUT VARCHAR2) IS
  --
  vtipo_doc_anula arccmd.tipo_doc%TYPE := pTipo_anula;
  vno_docu_anula  arccmd.no_docu%TYPE;
  vf_anula        DATE := TRUNC(pfec_anula);
  vano_proce      arincd.ano_proce_fact%TYPE;
  vmes_proce      arincd.mes_proce_fact%TYPE;
  vsem_proce      arincd.semana_proce_fact%TYPE;
  vInd_sem_proce  arincd.indicador_sem_fact%TYPE;
  --
  --
  error_proceso EXCEPTION;
  --
  CURSOR c_per_proceso(pcentro arincd.centro%TYPE) IS
    SELECT ano_proce_fact,
           mes_proce_fact,
           semana_proce_fact,
           Indicador_Sem_fact
      FROM arincd
     WHERE no_cia = pCia
       AND centro = pcentro;
  --
  -- Encabezado de la factura
  CURSOR c_factura IS
    SELECT centrod,
           afecta_saldo,
           grupo,
           no_cliente,
           no_fisico,
           serie_fisico,
           ruta,
           no_vendedor,
           moneda,
           tipo_cambio,
           no_docu_refe_consigna,
           ROWID
      FROM arfafe
     WHERE no_cia = pcia
       AND no_factu = pno_factu
       AND tipo_doc = ptipo_doc
       AND estado != 'P'
       AND ind_anu_dev IS NULL;
  --
  -- Lineas de la factura
  CURSOR c_lineas_factura IS
    SELECT l.no_cia,
           l.centrod,
           l.clase,
           l.categoria,
           l.no_arti,
           l.ruta,
           l.periodo,
           l.costo,
           l.pedido,
           l.total,
           l.descuento,
           l.i_ven_n,
           l.arti_ofe,
           l.cant_ofe,
           l.costo_ofe,
           l.precio_ofe,
           l.imp_incluido,
           l.costo2,
           l.linea_art_promocion
      FROM arfafl l
     WHERE l.no_cia = pcia
       AND l.tipo_doc = ptipo_doc
       AND l.no_factu = pno_factu;
  --

  CURSOR C_Arfact IS
    SELECT NVL(ind_autoconsumo, 'N') autoconsumo,
           tipo_doc_cxc
      FROM arfact
     WHERE no_cia = pcia
       AND tipo = ptipo_doc;

  CURSOR C_Formulario(Lv_centrod  VARCHAR2,
                      Lv_centrof  VARCHAR2,
                      Lv_tipo_doc VARCHAR2) IS
    SELECT formulario
      FROM arfaft
     WHERE no_cia = pcia
       AND centrod = Lv_centrod
       AND centrof = Lv_centrof
       AND tipo_doc = Lv_tipo_doc;

  CURSOR C_CxC IS
    SELECT 'X'
      FROM arccmd
     WHERE no_cia = pcia
       AND no_docu = pNo_factu;

  --
  ef c_factura%ROWTYPE;
  lf c_lineas_factura%ROWTYPE;
  --
  vNo_fisico         arfafe.no_fisico%TYPE;
  vSerie_Fisico      arfafe.serie_fisico%TYPE;
  vNo_Control        arfafe.numero_ctrl%TYPE;
  vAfecta_Inventario BOOLEAN;

  Lv_autoconsumo arfact.ind_autoconsumo%TYPE;

  Lv_formulario arfaft.formulario%TYPE;

  Lv_tdoc_cxc Arfact.Tipo_Doc_Cxc%TYPE;

  Lv_dummy VARCHAR2(1);

BEGIN

  vAfecta_inventario := FALSE;
  msg_error_p        := NULL;
  --
  moneda.inicializa_datos_redondeo(pcia);
  --
  OPEN c_factura;
  FETCH c_factura
    INTO ef;
  IF c_factura%NOTFOUND THEN
    CLOSE c_factura;
    msg_error_p := 'NO pudo localizar la factura para anular';
    RAISE error_proceso;
  END IF;
  CLOSE c_factura;
  --
  OPEN c_per_proceso(ef.centrod);
  FETCH c_per_proceso
    INTO vAno_proce,
         vMes_Proce,
         vSem_Proce,
         vInd_Sem_Proce;
  CLOSE c_per_proceso;
  --
  -- --
  -- Obtiene un numero de transaccion
  vNo_Docu_Anula := Transa_Id.FA(pcia);
  --
  -- --
  -- Obtiene el numero de documento fisico
  vNo_Fisico    := Consecutivo.FA(pCia, vAno_Proce, vMes_Proce, ef.centrod, ef.ruta, vtipo_doc_anula, 'NUMERO');
  vSerie_Fisico := Consecutivo.FA(pCia, vAno_Proce, vMes_Proce, ef.centrod, ef.ruta, vtipo_doc_anula, 'SERIE');
  vNo_Control   := Consecutivo.FA(pCia, vAno_Proce, vMes_Proce, ef.centrod, ef.ruta, vtipo_doc_anula, 'SECUENCIA');
  --

  OPEN C_Arfact;
  FETCH C_Arfact
    INTO Lv_autoconsumo,
         Lv_tdoc_cxc;
  IF C_Arfact%NOTFOUND THEN
    CLOSE C_Arfact;
    msg_error_p := 'No existe tipo de documento: ' || pTipo_Doc;
    RAISE error_proceso;
  ELSE
    CLOSE C_Arfact;
  END IF;

  OPEN C_Formulario(ef.centrod, ef.ruta, vtipo_doc_anula);
  FETCH C_Formulario
    INTO Lv_formulario;
  IF C_Formulario%NOTFOUND THEN
    CLOSE C_Formulario;
    msg_error_p := 'No existe formulario configurado para centro dist: ' || ef.centrod || ' centro fact: ' || ef.ruta || ' tipo doc: ' || vtipo_doc_anula;
    RAISE error_proceso;
  ELSE
    CLOSE C_Formulario;
  END IF;

  -- --
  -- crea el registro de anulacion en facturacion
  --
  INSERT INTO arfafe
    (no_cia,
     centrod,
     tipo_doc,
     periodo,
     ruta,
     no_factu,
     afecta_saldo,
     grupo,
     no_cliente,
     tipo_cliente,
     nbr_cliente,
     direccion,
     fecha,
     no_vendedor,
     plazo,
     observ1,
     observ2,
     observ3,
     tot_lin,
     descuento,
     sub_total,
     impuesto,
     total,
     estado,
     monto_bienes,
     monto_serv,
     monto_exportac,
     ind_exportacion,
     imp_sino,
     ind_anu_dev,
     tipo_factura,
     peri_ped,
     no_pedido,
     peri_liq,
     no_liq,
     razon,
     tipo_cambio,
     tipo_doc_d,
     periodo_d,
     ruta_d,
     n_factu_d,
     no_fisico,
     serie_fisico, --- se toma en cuenta subcliente y codigo plazo ANR 23/07/2009
     porc_desc,
     moneda,
     Numero_Ctrl,
     subcliente,
     codigo_plazo,
     division_comercial,
     gravada,
     exento,
     descuento_gravado,
     descuento_exento,
     no_autorizacion,
     fecha_vigencia_autoriz,
     origen)
    SELECT no_cia,
           centrod,
           vtipo_doc_anula,
           vano_proce,
           ruta,
           vno_docu_anula,
           afecta_saldo,
           grupo,
           no_cliente,
           tipo_cliente,
           nbr_cliente,
           direccion,
           vf_anula,
           no_vendedor,
           plazo,
           observ1,
           observ2,
           observ3,
           -tot_lin,
           -descuento,
           -sub_total,
           -impuesto,
           -total,
           DECODE(estado, 'M', 'M', 'D', 'M', 'D'),
           -monto_bienes,
           -monto_serv,
           -monto_exportac,
           ind_exportacion,
           imp_sino,
           'A',
           'A',
           NULL,
           NULL,
           peri_liq,
           no_liq,
           pRazon,
           tipo_cambio,
           tipo_doc,
           periodo,
           ruta,
           no_factu,
           vNo_Fisico,
           vSerie_Fisico,
           porc_desc,
           moneda,
           vNo_Control,
           subcliente,
           codigo_plazo,
           division_comercial,
           -gravada,
           -exento,
           -descuento_gravado,
           -descuento_exento,
           NULL,
           NULL,
           origen
      FROM arfafe
     WHERE ROWID = ef.rowid;

  IF SQL%ROWCOUNT != 1 THEN
    msg_error_p := 'No se pudo crear un registro de anulacion en facturacion';
    RAISE error_proceso;
  END IF;
  --

  -- Crea las lineas de la anulacion
  BEGIN
    INSERT INTO arfafl
      (no_cia,
       centrod,
       tipo_doc,
       periodo,
       ruta,
       no_factu,
       no_linea,
       bodega,
       clase,
       categoria,
       no_arti,
       pedido,
       descuento,
       total,
       i_ven_n,
       i_ven,
       porc_desc,
       costo,
       costo2,
       precio,
       tipo_precio,
       un_devol,
       cant_ofe,
       arti_ofe,
       costo_ofe,
       prot_ofe,
       tipo_oferta,
       precio_ofe,
       no_linea_d,
       imp_incluido,
       imp_especial,
       linea_art_promocion,
       margen_valor_fl,
       margen_minimo, --- Agrego los demas campos que se han creado con promociones ANR 23/07/2009
       margen_objetivo,
       margen_porc_fl,
       secuencia_politica,
       linea_politica,
       division,
       subdivision)
      SELECT no_cia,
             centrod,
             vtipo_doc_anula,
             vano_proce,
             ruta,
             vno_docu_anula,
             no_linea,
             bodega,
             clase,
             categoria,
             no_arti,
             -pedido,
             -descuento,
             -total,
             -i_ven_n,
             i_ven,
             porc_desc,
             costo,
             costo2,
             precio,
             tipo_precio,
             0,
             -cant_ofe,
             arti_ofe,
             costo_ofe,
             prot_ofe,
             tipo_oferta,
             precio_ofe,
             no_linea,
             -imp_incluido,
             -imp_especial,
             linea_art_promocion,
             margen_valor_fl,
             margen_minimo,
             margen_objetivo,
             margen_porc_fl,
             secuencia_politica,
             linea_politica,
             division,
             subdivision
        FROM arfafl
       WHERE no_cia = pcia
         AND no_factu = pno_factu;
  
  EXCEPTION
    WHEN OTHERS THEN
      msg_error_p := 'Error al crear registro de linea. Factura: ' || pno_factu || ' ' || SQLERRM;
      RAISE Error_proceso;
  END;
  --
  -- Crea las lineas de la anulacion de los impuestos por lineas
  BEGIN
    INSERT INTO arfafli
      (no_cia,
       tipo_doc,
       no_factu,
       no_linea,
       clave,
       Porc_Imp,
       Monto_Imp,
       Columna,
       base,
       codigo_tercero,
       comportamiento,
       aplica_cred_fiscal,
       id_sec)
      SELECT no_cia,
             vtipo_doc_anula,
             vno_docu_anula,
             no_linea,
             clave,
             Porc_Imp,
             -Monto_Imp,
             Columna,
             -base,
             codigo_tercero,
             comportamiento,
             aplica_cred_fiscal,
             id_sec
        FROM arfafli
       WHERE no_cia = pcia
         AND no_factu = pno_factu;
  EXCEPTION
    WHEN OTHERS THEN
      msg_error_p := 'Error al crear registro de impuesto. Factura: ' || pno_factu || ' ' || SQLERRM;
      RAISE Error_proceso;
  END;

  --- Procede a anular las promociones ANR 23/07/2009
  BEGIN
    INSERT INTO Arfapromo_fl
      (no_cia,
       no_factu,
       no_linea,
       secuencia_politica,
       linea_politica,
       tipo_promocion,
       porc_descuento,
       precio,
       cant_minima,
       cant_maxima,
       unidades,
       arti_alterno)
      SELECT no_cia,
             vno_docu_anula,
             no_linea,
             secuencia_politica,
             linea_politica,
             tipo_promocion,
             porc_descuento,
             precio,
             cant_minima,
             cant_maxima,
             unidades,
             arti_alterno
        FROM Arfapromo_fl
       WHERE no_cia = pcia
         AND no_factu = pno_factu;
  EXCEPTION
    WHEN OTHERS THEN
      msg_error_p := 'Error al crear registro de promocion. Factura: ' || pno_factu || ' ' || SQLERRM;
      RAISE Error_proceso;
  END;
  -- --
  --- Crea registro de lote en la anulacion ANR 22/06/2010
  BEGIN
    INSERT INTO Arfafl_lote
      (no_cia,
       centrod,
       no_factu,
       bodega,
       no_arti,
       no_linea,
       no_lote,
       unidades,
       fecha_vence,
       ubicacion)
      SELECT no_cia,
             centrod,
             vno_docu_anula,
             bodega,
             no_arti,
             no_linea,
             no_lote,
             unidades,
             fecha_vence,
             ubicacion
        FROM Arfafl_lote
       WHERE no_cia = pcia
         AND no_factu = pno_factu;
  EXCEPTION
    WHEN OTHERS THEN
      msg_error_p := 'Error al crear registro de lote. Factura: ' || pno_factu || ' ' || SQLERRM;
      RAISE Error_proceso;
  END;
  -- --
  -- pone la factura original como anulada
  --
  UPDATE arfafe
     SET estado        = 'M',
         ind_anu_dev   = 'A',
         fecha_anula   = SYSDATE,
         usuario_anula = USER,
         motivo_anula  = mot_anula_p,
         tstamp        = SYSDATE
   WHERE ROWID = ef.rowid;
  --
  -- ---
  -- procesa las lineas (actualiza estadisticas)
  --

  FOR lf IN c_lineas_factura LOOP
    IF lf.clase != '000' AND NOT vAfecta_Inventario THEN
      vAfecta_Inventario := TRUE;
    END IF;
  
    --- Si la factura es de consignacion disminuye las cantidades consignadas ANR 31/08/2009
    IF ef.no_docu_refe_consigna IS NOT NULL THEN
      UPDATE arindetconsignacli
         SET uni_facturadas = NVL(uni_facturadas, 0) - NVL(lf.pedido, 0)
       WHERE no_cia = lf.no_cia
         AND no_docu = ef.no_docu_refe_consigna
         AND no_arti = lf.no_arti;
    END IF;
  
    --
    IF lf.linea_art_promocion IS NULL AND lf.clase != '000' THEN
      ---- diferente de promociones
      --- Facturas de autoconsumo no se guardan en estadisticas de venta ANR 06/10/2009
      IF lv_autoconsumo != 'S' THEN
        FAestadistica_venta(lf.no_cia, lf.centrod, lf.clase, lf.categoria, lf.no_arti, ef.grupo, ef.no_cliente, ef.no_vendedor, lf.ruta, vSem_proce, vind_sem_proce, vano_proce, vMes_proce, 'VEN', lf.costo, lf.costo2, -lf.pedido, - (abs(lf.total) - abs(NVL(lf.imp_incluido, 0))), -lf.descuento, -lf.i_ven_n, -lf.imp_incluido, ef.moneda, ef.tipo_cambio, NULL, msg_error_p);
        IF msg_error_p IS NOT NULL THEN
          RAISE error_proceso;
        END IF;
      END IF;
    END IF;
  
    -- No se utiliza lo de ofertas porque se esta utilizando otra tabla,
    -- las ofertas forman parte de la misma linea de la factura  ANR 23/07/2009
  
    -- si hubo ofertas, las actualiza tambien
    --
    IF lf.linea_art_promocion IS NOT NULL AND lf.clase != '000' THEN
      ---- es una bonificacion
      --
    
      --- Facturas de autoconsumo no se guardan en estadisticas de venta ANR 06/10/2009
      IF lv_autoconsumo != 'S' THEN
        FAestadistica_venta(lf.no_cia,
                            lf.centrod,
                            lf.clase,
                            lf.categoria, ---vclase_ofe,   vcate_ofe,
                            lf.no_arti, ---lf.arti_ofe,
                            ef.grupo,
                            ef.no_cliente,
                            ef.no_vendedor,
                            lf.ruta,
                            vSem_proce,
                            vInd_sem_proce,
                            vano_proce,
                            vMes_proce,
                            'OFE',
                            lf.costo,
                            lf.costo2, ---lf.costo_ofe,
                            ---- se agrega cantidad linea y cantidad adicional porque es bonificacion
                            lf.pedido, -----lf.cant_ofe,
                            0,
                            0,
                            0,
                            0,
                            ef.moneda,
                            ef.tipo_cambio,
                            NULL,
                            msg_error_p);
        IF msg_error_p IS NOT NULL THEN
          RAISE error_proceso;
        END IF;
      END IF;
    END IF;
  END LOOP;
  --
  --- Factura autoconsumo no debe generar movimientos a Inventarios ANR 14/10/2009
  IF vAfecta_Inventario AND lv_autoconsumo != 'S' THEN
    -- ---
    -- Anula el movimiento en inventario
  
    --
    FAanula_inve(pcia, ptipo_doc, pno_factu, pTipo_Anula, vNo_Docu_Anula, vNo_Fisico, vSerie_Fisico, ef.No_Fisico, ef.Serie_Fisico, pFec_Anula, vano_proce, vmes_proce, vsem_proce, msg_error_p);
    IF msg_error_p IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
    --
  END IF;
  -- ---
  --- Factura autoconsumo no debe generar a CxC ANR 14/10/2009
  IF lv_autoconsumo != 'S' THEN
    -- Si la factura afecto a CxC, debe reversarla
    ---- Se deben anular documentos de contado y de credito ANR 13/07/2009
  
    /*** Si la factura no existe en cxc no debe ingresar en este proceso
    ANR 21/02/2011 ***/
  
    OPEN C_CxC;
    FETCH C_CxC
      INTO Lv_dummy;
    IF C_CxC%NOTFOUND THEN
      CLOSE C_CxC;
    ELSE
      CLOSE C_CxC;
    
      FAanula_cxc(pcia, pTipo_Anula, vNo_Docu_Anula, vNo_Fisico, vSerie_Fisico, pFec_Anula, ef.tipo_cambio, vano_proce, vmes_proce, vsem_proce, ptipo_doc, pno_factu, mot_anula_p, NULL, NULL, msg_error_p);
      IF msg_error_p IS NOT NULL THEN
        RAISE error_proceso;
      END IF;
    
    END IF;
  
  END IF;

  --
  doc_anula_p := vNo_Docu_Anula;

EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := NVL('FAANULA ' || msg_error_p, 'FAANULA');
    RETURN;
  WHEN transa_id.error THEN
    msg_error_p := 'FAANULA :' || NVL(Transa_Id.Ultimo_Error, 'FAANULA : TRANSA_ID.FA');
    RETURN;
  WHEN consecutivo.error THEN
    msg_error_p := 'FAANULA :' || NVL(consecutivo.Ultimo_Error, 'FAANULA : CONSECUTIVO.FA');
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := 'FAANULA : ' || SQLERRM;
    RETURN;
END;