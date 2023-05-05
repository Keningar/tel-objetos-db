create or replace PROCEDURE            CCACTUALIZA_DEV(PNO_CIA   IN ARCCMD.NO_CIA%TYPE,
                                            PTIPO_DOC IN ARCCMD.TIPO_DOC%TYPE,
                                            PNO_DOCU  IN ARCCMD.NO_DOCU%TYPE,
                                            PERROR    IN OUT VARCHAR2) IS
  -- PL/SQL Specification
  /*
  * Actualiza un documento por cobrar, aumentando o disminuyendo
  * la cuenta por cobrar del cliente al que pertenece el documento.
  *
  * Si el a?o y mes del documento es superior al periodo en proceso
  * del modulo de CxC, entonces lo deja en estado pendiente.
  *
  *
  */

  /****************************
  
  1) Cuando es un documento de debito con dividendos, se deben bajar los dividendos, para eso utiliza el proceso CCACTUALIZA_DIVIDENDOS
  2) Si la forma de pago es un cheque postfechado se debe crear un nuevo documento en arccmd.
  3) Si la forma de pago es deposito se genera el deposito en el modulo de bancos.
  
  ******************************/
  --
  CURSOR c_periodo_cxc(pcia    arincd.no_cia%TYPE,
                       pcentro arincd.centro%TYPE) IS
    SELECT ano_proce_cxc,
           mes_proce_cxc,
           semana_proce_cxc,
           dia_proceso_cxc
      FROM arincd
     WHERE no_cia = pcia
       AND centro = pcentro;
  --
  CURSOR c_documento IS
    SELECT m.centro,
           m.tipo_doc,
           m.no_docu,
           m.grupo,
           m.no_cliente,
           m.saldo,
           m.total_ref,
           m.fecha,
           m.m_original,
           m.no_docu_refe,
           m.ano ano_doc,
           m.mes mes_doc,
           td.formulario_ctrl,
           m.tot_imp,
           m.rowid rowid_md,
           m.tot_ret,
           m.moneda,
           m.tipo_cambio,
           m.serie_fisico_refe,
           m.sub_cliente,
           m.no_agente,
           m.ruta,
           m.ind_cobro,
           NVL(td.cks_dev, 'N') cks_dev,
           m.fecha_vence,
           m.cobrador,
           TD.TIPO_MOV,
           m.origen,
           td.formulario,
           m.serie_fisico,
           m.no_fisico,
           m.fecha_documento,
           td.codigo_tipo_comprobante,
           td.factura
      FROM arccmd m,
           arcctd td
     WHERE m.no_cia = pno_cia
       AND m.no_docu = pno_docu
       AND m.estado = 'P'
       AND m.no_cia = td.no_cia
       AND m.tipo_doc = td.tipo;
  --
  CURSOR c_referencias(pno_cia  VARCHAR2,
                       pNo_docu VARCHAR2) IS
    SELECT r.tipo_refe,
           r.no_refe,
           r.monto,
           r.ano,
           r.mes,
           r.no_docu,
           r.tipo_doc
      FROM arccrd r
     WHERE r.no_cia = pno_cia
       AND r.no_docu = pno_docu;

  --- Verifica los dividendos aplicados manualmente en la pantalla de ingreso de cobros ANR 04/11/2009
  CURSOR C_div_manual(Lv_no_refe VARCHAR2) IS
    SELECT NVL(SUM(NVL(monto_refe, 0)), 0) monto_refe
      FROM arccrd_dividendos_manual
     WHERE no_cia = pno_cia
       AND no_docu = pno_docu
       AND no_refe = Lv_no_refe;

  --- Verifica las papeletas de deposito  ANR 22/07/2009
  CURSOR C_Papeletas_Deposito IS
    SELECT b.ref_fecha,
           b.valor,
           b.cod_bco_cia,
           b.campo_deposito,
           c.cuenta_contable,
           b.autorizacion,
           b.linea,
           b.id_forma_pago
      FROM arccfpagos     b,
           arccforma_pago c
     WHERE b.no_cia = Pno_cia
       AND b.no_docu = Pno_docu
       AND (NVL(c.papeleta, 'N') = 'S' OR NVL(c.transferencia, 'N') = 'S') --- Se anaden transferencias para que se generen al modulo de bancos ANR 12/02/2010
       AND NVL(c.ind_transito, 'N') = 'N' --- Agregado ANR 09/02/2010
       AND b.no_cia = c.no_cia
       AND b.id_forma_pago = c.forma_pago;
  --- Depositos en transito no debe generar transaccion en bancos ANR 09/02/2010

  --- Verifica pagos con cheques postfechados  ANR 22/07/2009
  CURSOR C_Cheques_postfechados IS
    SELECT b.ref_cheque,
           b.valor,
           b.ref_fecha,
           b.linea,
           b.id_forma_pago
      FROM arccfpagos     b,
           arccforma_pago c
     WHERE b.no_cia = Pno_cia
       AND b.no_docu = Pno_docu
       AND NVL(c.ind_ck_postf, 'N') = 'S'
       AND b.no_cia = c.no_cia
       AND b.id_forma_pago = c.forma_pago;

  --
  -- Datos del tipo de documento
  CURSOR c_tipo_doc(pCia      VARCHAR2,
                    pTipo_doc VARCHAR2) IS
    SELECT td.tipo_mov,
           td.cks_dev,
           NVL(td.afecta_libro, 'X'),
           NVL(td.factura, 'N')
      FROM arcctd td
     WHERE td.no_cia = pCia
       AND td.tipo = pTipo_doc;

  --Recupera el saldo actual del documento a actualizar IRQS 2003-02-14
  CURSOR c_saldo_doc(CV_NoDocu VARCHAR2) IS
    SELECT saldo
      FROM arccmd
     WHERE no_cia = pno_cia
       AND no_docu = Cv_NoDocu;

  --- Recupera el documento para cheques postfechados ANR 23/07/2009
  CURSOR C_Tipo_Cheque_Postfechado IS
    SELECT tipo,
           cod_diario
      FROM arcctd
     WHERE no_cia = pno_cia
       AND tipo_mov = 'D'
       AND NVL(tipo_cheque, 'N') = 'S';

  CURSOR C_Dividendos_CxC IS
    SELECT no_cia,
           centrod,
           tipo_doc,
           no_factu,
           dividendo,
           valor,
           fecha_vence
      FROM Arfadividendos
     WHERE no_cia = pno_cia
       AND no_factu = pno_docu;

  --- Se agrega validaciones para la retencion ANR 19/10/2009

  CURSOR C_Forma_Pago_retencion IS
    SELECT NVL(SUM(b.valor), 0) valor
      FROM arccforma_pago a,
           arccfpagos     b
     WHERE a.no_cia = pno_cia
       AND b.no_docu = pno_docu
       AND NVL(a.retencion, 'N') = 'S'
       AND a.no_cia = b.no_cia
       AND a.forma_pago = b.id_forma_pago;

  CURSOR C_Total_retenciones IS
    SELECT NVL(SUM(monto), 0) monto
      FROM arccti
     WHERE no_cia = pno_cia
       AND tipo_doc = ptipo_doc
       AND no_docu = pno_docu
       AND NVL(ind_imp_ret, 'X') = 'R';

  CURSOR C_Total_impuesto IS
    SELECT NVL(SUM(monto), 0) monto
      FROM arccti
     WHERE no_cia = pno_cia
       AND tipo_doc = ptipo_doc
       AND no_docu = pno_docu
       AND NVL(ind_imp_ret, 'X') = 'I';

  CURSOR C_Div_comercial(Lv_Grupo      VARCHAR2,
                         Lv_cliente    VARCHAR2,
                         Lv_subcliente VARCHAR2) IS
    SELECT div_comercial
      FROM arcclocales_clientes
     WHERE no_cia = pno_cia
       AND grupo = Lv_Grupo
       AND no_cliente = Lv_cliente
       AND no_sub_cliente = Lv_subcliente;

  --- Se agrega validacion de cuenta contable que cuadre debe y haber y que se genere el asiento contable ANR 10/12/2009

  CURSOR C_Existe_conta IS
    SELECT 'X'
      FROM arccdc
     WHERE no_cia = pno_cia
       AND no_docu = pno_docu;

  CURSOR C_Valida_conta IS
    SELECT NVL(SUM(DECODE(tipo, 'C', monto)), 0) - NVL(SUM(DECODE(tipo, 'D', monto)), 0) dif
      FROM arccdc
     WHERE no_cia = pno_cia
       AND no_docu = pno_docu;
  --add mlopez 28/05/2010
  --para verificar si el documento es una devolucion
  CURSOR c_es_dev(cv_tipo VARCHAR2) IS
    SELECT x.ind_fac_dev
      FROM arfact x
     WHERE x.no_cia = pno_cia
       AND x.tipo = cv_tipo;

  lc_es_dev c_es_dev%ROWTYPE;

  CURSOR c_ctas_default(cv_grupo VARCHAR2,
                        cv_tipo  VARCHAR2) IS
    SELECT g.no_cia,
           g.grupo,
           t.tipo tipo_doc,
           g.cta_cliente,
           g.cta_dpp,
           t.cta_contrapartida,
           g.cta_diferencia
      FROM arccgr g,
           arcctd t
     WHERE g.no_cia = pno_cia
       AND g.grupo = cv_grupo
       AND g.no_cia = t.no_cia
       AND t.tipo = cv_tipo;

  lc_ctas_default c_ctas_default%ROWTYPE;
  --fin add mlopez 28/05/2010
  r                 c_documento%ROWTYPE;
  vnumero_ctrl      arccmd.numero_ctrl%TYPE;
  Ln_saldo          arccmd.saldo%TYPE;
  Ln_docu           arckmm.no_docu%TYPE;
  vCta_cliente      arccdc.codigo%TYPE;
  Lv_Error          VARCHAR2(500);
  vfound            BOOLEAN;
  vTipo_mov         arcctd.tipo_mov%TYPE;
  vcks_dev          arcctd.cks_dev%TYPE;
  vtot_ref          NUMBER;
  vSaldo_doc        arccmd.saldo%TYPE;
  vano_proce_cxc    arincd.ano_proce_cxc%TYPE;
  vmes_proce_cxc    arincd.mes_proce_cxc%TYPE;
  vsemana_proce_cxc arincd.mes_proce_cxc%TYPE;
  vdia_proceso_cxc  arincd.dia_proceso_cxc%TYPE;
  --
  vcod_Estado arccte.cod_estado%TYPE;
  vLibro      arcctd.Afecta_Libro%TYPE;
  vFactura    arcctd.factura%TYPE;
  td_cxc      arcctd.tipo%TYPE;
  vDiario     arcctd.cod_diario%TYPE;
  no_cxc_p    arccmd.no_docu%TYPE;
  rcta        arccctd%ROWTYPE;

  Ln_total_fpago_retencion Arccti.monto%TYPE := 0;
  Ln_total_retenciones     Arccti.monto%TYPE := 0;
  Ln_total_impuestos       Arccti.monto%TYPE := 0;

  Lv_resultado VARCHAR2(1);

  Lv_division Arfa_div_comercial.division%TYPE;

  Ln_monto_refe Arccrd_Dividendos_Manual.Monto_Refe%TYPE;

  error_proceso EXCEPTION;

  Lv_dummy VARCHAR2(1);
  Ln_dif   NUMBER;

  Lv_cc           Arcgceco.centro%TYPE;
  Lv_centro_costo Arcgceco.centro%TYPE;

  -- PL/SQL Block
BEGIN
  --
  pError := NULL;
  --
  OPEN c_documento;
  FETCH c_documento
    INTO r;
  vFound := NVL(c_documento%FOUND, FALSE);
  CLOSE c_documento;

  IF NOT vFound THEN
    pError := 'No se localiza en CxC, el documento para actualizar (' || pno_docu || ')';
    RAISE error_proceso;
  END IF;
  --

  --- Para todos los documentos debe validar que se haya generado el asiento contable, a excepcion
  --- de los documentos que vienen de facturacion que la contabilidad se genera desde el mismo
  --- modulo de facturacion ANR 10/12/2009
  --- Para el caso del POS, tambien hay que considerar que la contabilizacion se genera en el POS ANR 27-09-2010

  IF NVL(r.factura, 'N') = 'N' AND r.origen NOT IN ('FA', 'PV') THEN
  
    OPEN C_Existe_conta;
    FETCH C_Existe_conta
      INTO Lv_dummy;
    IF C_Existe_conta%NOTFOUND THEN
      CLOSE C_Existe_conta;
      pError := 'Es obligatorio el asiento contable, revisar el documento: ' || pno_docu;
      RAISE error_proceso;
    ELSE
      CLOSE C_Existe_conta;
    END IF;
  
    OPEN C_Valida_conta;
    FETCH C_Valida_conta
      INTO Ln_dif;
    IF C_Valida_conta%NOTFOUND THEN
      CLOSE C_Valida_conta;
    ELSE
      CLOSE C_Valida_conta;
    END IF;
  
    IF Ln_dif != 0 THEN
      pError := 'Asiento contble descuadrado con: ' || ln_dif || ' , revisar el documento: ' || pno_docu;
      RAISE error_proceso;
    END IF;
  
  END IF;

  --- Valida las retenciones registradas ANR 19/10/2009

  OPEN C_Forma_Pago_retencion;
  FETCH C_Forma_Pago_retencion
    INTO Ln_total_fpago_retencion;
  CLOSE C_Forma_Pago_retencion;

  OPEN C_Total_retenciones;
  FETCH C_Total_retenciones
    INTO Ln_total_retenciones;
  CLOSE C_Total_retenciones;

  --- Si tiene forma de pago de retencion, quiere decir que debe tener registros en ARCCTI y en ARCCMD (TOT_RET)
  IF Ln_total_fpago_retencion > 0 THEN
  
    IF Ln_total_fpago_retencion != Ln_total_retenciones THEN
      pError := 'El total de forma de pago de retenciones: ' || Ln_total_fpago_retencion || ' debe ser igual al total de retenciones ingresadas por factura: ' || Ln_total_retenciones || ' para el documento: ' || pno_docu;
      RAISE error_proceso;
    END IF;
  
    IF Ln_total_retenciones != r.tot_ret THEN
      pError := 'El total de retenciones registradas por factura: ' || Ln_total_retenciones || ' debe ser igual al total de retencion: ' || r.tot_ret || ' registrada en el documento: ' || pno_docu;
      RAISE error_proceso;
    END IF;
  
  END IF;

  OPEN C_Total_impuesto;
  FETCH C_Total_impuesto
    INTO Ln_total_impuestos;
  CLOSE C_Total_impuesto;

  --- Valido los impuestos registrados que sean los correctos ANR 19/10/2009

  IF Ln_total_impuestos > 0 AND r.tot_imp = 0 THEN
    pError := 'El documento: ' || pno_docu || ' tiene registrado impuestos por: ' || Ln_total_impuestos || ' debe tener el mismo valor de impuestos: ' || r.tot_imp || ' en el documento.';
    RAISE error_proceso;
  ELSIF Ln_total_impuestos = 0 AND r.tot_imp > 0 THEN
    pError := 'El documento: ' || pno_docu || ' no tiene registrado el detalle de impuestos, verifique por favor';
    RAISE error_proceso;
  END IF;

  OPEN c_periodo_cxc(pno_cia, r.centro);
  FETCH c_periodo_cxc
    INTO vano_proce_cxc,
         vmes_proce_cxc,
         vsemana_proce_cxc,
         vdia_proceso_cxc;
  CLOSE c_periodo_cxc;
  --
  IF vano_proce_cxc IS NULL OR vmes_proce_cxc IS NULL THEN
    pError := 'Falta periodo en proceso de CxC para el centro: ' || r.centro;
    RAISE error_proceso;
  END IF;
  -- --
  -- Actualiza el documento si su periodo es menor o igual al de proceso
  --
  IF (NVL(r.ano_doc, vano_proce_cxc) <= vano_proce_cxc AND NVL(r.mes_doc, vmes_proce_cxc) <= vmes_proce_cxc) THEN
    --
    -- busca el tipo de movimiento del documento (D o C)
    vTipo_mov := NULL;
    vcks_dev  := NULL;
    OPEN c_tipo_doc(pNo_cia, r.tipo_doc);
    FETCH c_tipo_doc
      INTO vTipo_mov,
           vcks_dev,
           vLibro,
           vFactura;
    CLOSE c_tipo_doc;
    --
    IF vTipo_mov IS NULL THEN
      pError := 'TIPO DE MOVIMIENTO DEL DOCUMENTO: ' || r.tipo_doc || ', ES INCORRECTO ';
      RAISE error_proceso;
    END IF;
    --
    IF vLibro = 'V' AND vFactura = 'N' THEN
      -- registra la factura en el libro de ventas, si no es factura ya que
      -- facturacion se encarga de ello
      ccLibro_Ventas(pno_Cia, ptipo_doc, pno_docu, pError);
    END IF;
  
    --
    vSaldo_doc := NULL;
    vtot_ref   := 0;
  
    IF vTipo_mov = 'C' THEN
      -- Aumenta los creditos del clientes
      UPDATE arccmc
         SET creditos   = NVL(creditos, 0) + NVL(r.m_original, 0),
             f_ult_pago = greatest(r.fecha, NVL(f_ult_pago, r.fecha))
       WHERE no_cia = pno_cia
         AND grupo = r.grupo
         AND no_cliente = r.no_cliente;
    ELSIF vTipo_mov = 'D' THEN
      -- Aumenta los debitos del cliente
      IF r.no_docu_refe IS NOT NULL THEN
        -- es un documento de pago (debito cancelando otro debito)
        vtot_ref := r.total_ref;
      ELSE
        vtot_ref := 0;
      END IF;
      UPDATE arccmc
         SET creditos  = NVL(creditos, 0) + NVL(vtot_ref, 0),
             debitos   = NVL(debitos, 0) + NVL(r.m_original, 0),
             fecha_max = DECODE(sign(NVL(saldo_max, 0) - (NVL(saldo_ante, 0) + NVL(debitos, 0) - NVL(creditos, 0) + NVL(r.m_original, 0))), -1, r.fecha, fecha_max),
             saldo_max = greatest(NVL(saldo_max, 0), NVL(saldo_ante, 0) + NVL(debitos, 0) - NVL(creditos, 0) + NVL(r.m_original, 0)),
             cks_dev   = DECODE(vcks_dev, 'S', NVL(cks_dev, 0) + 1, cks_dev),
             f_ult_com = greatest(r.fecha, NVL(f_ult_com, r.fecha))
       WHERE no_cia = pno_cia
         AND grupo = r.grupo
         AND no_cliente = r.no_cliente;
    END IF;
    --
    -- procesa referencias
    vtot_ref := 0;
    FOR j IN c_referencias(pno_cia, r.no_docu) LOOP
    
      --- Solo para documentos de ind. cobro se valida esta parte de registros manuales de dividendos ANR 04/11/2009
    
      IF NVL(r.ind_cobro, 'N') = 'S' THEN
        --
        OPEN c_saldo_doc(j.no_refe);
        FETCH c_saldo_doc
          INTO Ln_saldo;
        CLOSE c_saldo_doc;
        --Verifica el saldo antes de actualizar para no dejarlo en negativo
        IF round(Ln_saldo, 2) < j.monto THEN
          perror := 'ERROR: El saldo actual del documento :' || j.no_refe || ', (' || Ln_Saldo || ' <> ' || j.monto || ') es menor que la referencia a aplicar y no puede quedar negativo ';
          RAISE error_proceso;
        END IF;
        --
      
        --- verifica si concuerda las referencias con el total de dividendos referenciados ANR 04/11/2009
        OPEN C_div_manual(j.no_refe);
        FETCH C_div_manual
          INTO Ln_monto_refe;
        IF C_div_manual%NOTFOUND THEN
          CLOSE C_div_manual;
          Ln_monto_refe := 0;
        ELSE
          CLOSE C_div_manual;
        END IF;
      
        IF Ln_monto_refe != j.monto THEN
          perror := 'Para el documento: ' || j.tipo_refe || ' ' || j.no_refe || ' el total referenciado por dividendos: ' || Ln_monto_refe || ' debe ser igual al valor referenciado por documento:  ' || j.monto;
          RAISE error_proceso;
        END IF;
      
      END IF;
    
      -- actualiza saldo del documento referenciado solo si el
      UPDATE arccmd
         SET saldo              = NVL(saldo, 0) - NVL(j.monto, 0),
             ind_estado_vencido = DECODE(NVL(saldo, 0) - NVL(j.monto, 0), 0, DECODE(ind_estado_vencido, 'S', 'X'), ind_Estado_vencido),
             tstamp             = SYSDATE
       WHERE no_cia = pno_cia
         AND no_docu = j.no_refe;
      --
      vtot_ref := NVL(vtot_ref, 0) + NVL(j.monto, 0);
    
      --- Debe marcar como procesado ya que esto sirve para que estas referencias no sean modificadas
      --- a aplicacion ANR 05/08/2009
    
      UPDATE ARCCRD
         SET ind_procesado = 'S',
             tstamp        = SYSDATE
       WHERE no_cia = pno_cia
         AND tipo_doc = j.tipo_doc
         AND no_docu = j.no_docu
         AND tipo_refe = j.tipo_refe
         AND no_refe = j.no_refe
         AND Ano = j.ano
         AND mes = j.mes;
    
      --
      -- registra estado final
      ccregistra_estado(pno_cia, j.no_refe, j.tipo_refe, 'F', vcod_Estado);
    END LOOP;
    --
    IF NVL(r.total_ref, 0) != NVL(vtot_ref, 0) THEN
      perror := 'ERROR: El total referencia del documento no iguala al detalle en RD ' || NVL(R.TOTAL_REF, 0) || ' tot ' || VTOT_REF || ' Cliente ' || r.no_cliente;
      RAISE error_proceso;
    END IF;
    -- ---
    -- Calcula el saldo que debe quedar en el documento, que en el caso
    -- de creditos, es negativo si no se aplica todo el monto
    IF vTipo_mov = 'C' THEN
      vSaldo_doc := - (NVL(r.m_original, 0) - NVL(vtot_ref, 0));
    ELSIF vTipo_mov = 'D' THEN
      vSaldo_doc := NVL(r.saldo, 0);
    END IF;
    IF r.formulario_ctrl IS NULL THEN
      vnumero_ctrl := NULL;
    ELSE
      vnumero_ctrl := consecutivo.cc(pno_cia, r.ano_doc, r.mes_doc, NULL, r.tipo_doc, 'SECUENCIA');
    END IF;
  
    ---- Generacion de dividendos ANR 12/08/2009
  
    IF vtipo_mov = 'D' THEN
      --- debo generar un dividendo cuando sean documentos de debito ANR 07/08/2009
      ---- para documentos de anulacion como no tienen fecha de vencimiento se agrega la misma fecha ANR 26/10/2009
    
      IF vfactura = 'N' THEN
        ---- para movimientos que son realizados en CxC
        BEGIN
          INSERT INTO arcc_dividendos
            (no_cia,
             centro,
             tipo_doc,
             no_docu,
             dividendo,
             valor,
             saldo,
             fecha_vence,
             valor_aplica)
          VALUES
            (pno_cia,
             r.centro,
             ptipo_doc,
             pno_docu,
             1,
             r.m_original,
             r.m_original,
             NVL(r.fecha_vence, r.fecha),
             0);
        EXCEPTION
          WHEN OTHERS THEN
            pError := 'Error al crear dividendos que provienen de CxC ' || pno_docu || ' Dividendo: ' || 1 || ' ' || SQLERRM;
            RAISE error_proceso;
        END;
      
      ELSIF vfactura = 'S' THEN
        --- Genera dividendos a CxC que proviene de facturacion
      
        FOR j IN C_Dividendos_CxC LOOP
          BEGIN
            INSERT INTO arcc_dividendos
              (no_cia,
               centro,
               tipo_doc,
               no_docu,
               dividendo,
               valor,
               saldo,
               fecha_vence,
               valor_aplica)
            VALUES
              (j.no_cia,
               j.centrod,
               ptipo_doc,
               pno_docu,
               j.dividendo,
               j.valor,
               j.valor,
               j.fecha_vence,
               0);
          EXCEPTION
            WHEN OTHERS THEN
              pError := 'Error al crear dividendos que provienen de FACTURACION ' || pno_docu || ' Dividendo: ' || j.dividendo || ' ' || SQLERRM;
              RAISE error_proceso;
          END;
        END LOOP;
      
      END IF;
    
    END IF;
  
    --- Actualiza el valor de los dividendos ANR 24/06/2009
  
    IF NVL(r.ind_cobro, 'N') = 'S' THEN
    
      --- Este proceso se aumento lo de referencias manuales ANR 04/11/2009
    
      CCACTUALIZA_DIVIDENDOS_MANUAL(pno_cia, r.no_docu, r.tipo_doc, vdia_proceso_cxc, pError);
      IF pError IS NOT NULL THEN
        RAISE Error_Proceso;
      END IF;
    
    ELSE
    
      CCACTUALIZA_DIVIDENDOS(pno_cia, r.no_docu, r.tipo_doc, vdia_proceso_cxc, pError);
      IF pError IS NOT NULL THEN
        RAISE Error_Proceso;
      END IF;
    
    END IF;
  
    --- Cuando sean documentos de cobro ANR 12/08/2009
    --- Debe hacer lo siguiente:
    /*Verificar si el cliente esta suspendido por vencimiento de
    facturas y el cobro se registra en el plazo adicional considerado por la
    compa?ia (7 dias, mantenimiento de compa?ias) el cliente debe ser
    activado. */
  
    IF NVL(r.ind_cobro, 'N') = 'S' THEN
      CCACCIONES_CLIENTES.CC_PABONO(pno_cia,
                                    r.centro,
                                    r.no_cliente,
                                    r.sub_cliente,
                                    r.grupo,
                                    R.NO_DOCU,
                                    'AFACT', --- Se envia el id del motivo por concepto de abono de facturas
                                    Lv_resultado, --- Indica si se ejecuto la accion
                                    pError);
    
      IF pError IS NOT NULL THEN
        RAISE Error_Proceso;
      END IF;
    
    END IF;
  
    FOR i IN C_Papeletas_Deposito LOOP
    
      --- Generar el deposito en el modulo de bancos por las papeletas de deposito registradas en el cobro ANR 21/07/2009
    
      OPEN C_Div_comercial(r.grupo, r.no_cliente, r.sub_cliente);
      FETCH C_Div_comercial
        INTO Lv_division;
      IF C_Div_comercial%NOTFOUND THEN
        CLOSE C_Div_comercial;
        perror := 'No existe division comercial para cliente: ' || r.grupo || ' ' || r.no_cliente || ' subcliente: ' || r.sub_cliente;
        RAISE error_proceso;
      ELSE
        CLOSE C_Div_comercial;
      
        IF Lv_division IS NULL THEN
          perror := 'Es obligatorio que tenga una division comercial configurada por cliente: ' || r.grupo || ' ' || r.no_cliente || ' subcliente: ' || r.sub_cliente || ' para poder procesar el deposito';
          RAISE error_proceso;
        END IF;
      
      END IF;
    
      GENERA_DEPOSITO_CC(pno_cia,
                         r.centro,
                         i.campo_deposito,
                         i.valor,
                         r.moneda,
                         i.cuenta_contable, --- Las cuentas contables de la forma de pago
                         i.autorizacion,
                         vdia_proceso_cxc, --- Se envia el dia de proceso de CxC ANR 23/07/2009
                         i.ref_fecha,
                         pno_docu, --- Numero de transaccion de CxC para agregarlo a la glosa
                         Lv_division,
                         USER,
                         i.id_forma_pago,
                         Ln_docu,
                         Lv_Error);
    
      IF Lv_Error IS NOT NULL THEN
        pError := Lv_Error;
        RAISE error_proceso;
      ELSE
        UPDATE arccfpagos ---- actualiza el detalle de forma de pago con el numero de transaccion de bancos
           SET no_docu_deposito = Ln_docu
         WHERE no_cia = pno_cia
           AND no_docu = pno_docu
           AND linea = i.linea
           AND id_forma_pago = i.id_forma_pago;
      END IF;
    
    END LOOP;
  
    --- Generar el cheque a fecha como otra deuda ANR 23/07/2009
  
    -- Genera el documento en Cuentas x Cobrar con el mismo de no de factura
  
    FOR i IN C_Cheques_Postfechados LOOP
    
      OPEN C_Tipo_Cheque_Postfechado;
      FETCH C_Tipo_Cheque_Postfechado
        INTO td_cxc,
             vDiario;
      IF C_Tipo_Cheque_Postfechado%NOTFOUND THEN
        CLOSE C_Tipo_Cheque_Postfechado;
        perror := 'No existe documento configurado en CxC para los cheques postfechados';
        RAISE error_proceso;
      ELSE
        CLOSE C_Tipo_Cheque_Postfechado;
      END IF;
    
      no_cxc_p := transa_id.cc(pno_cia);
    
      IF NVL(r.tipo_cambio, 0) = 0 THEN
        r.tipo_cambio := 1;
      END IF;
    
      BEGIN
        INSERT INTO arccmd
          (no_cia,
           centro,
           tipo_doc,
           periodo,
           ruta,
           no_docu,
           grupo,
           no_cliente,
           moneda,
           fecha,
           fecha_vence,
           fecha_documento,
           m_original,
           descuento,
           saldo,
           tipo_venta,
           gravado,
           exento,
           monto_bienes,
           monto_serv,
           monto_exportac,
           no_agente,
           estado,
           tipo_cambio,
           total_ref,
           total_db,
           total_cr,
           origen,
           ano,
           mes,
           semana,
           no_fisico,
           serie_fisico,
           cod_diario,
           no_docu_refe,
           usuario,
           sub_cliente,
           tstamp,
           detalle,
           fecha_vence_original,
           estado_cheque,
           cobrador,
           linea_forma_pago,
           id_forma_pago)
        VALUES
          (pno_cia,
           r.centro,
           td_cxc,
           vano_proce_cxc,
           r.ruta,
           no_cxc_p,
           r.grupo,
           r.no_cliente,
           r.moneda,
           vdia_proceso_cxc,
           i.ref_fecha,
           i.ref_fecha,
           i.valor,
           0,
           i.valor,
           'V',
           0,
           i.valor,
           0,
           0,
           0,
           r.no_agente,
           'P',
           r.tipo_cambio,
           0,
           i.valor,
           i.valor,
           'CC',
           vano_proce_cxc,
           vmes_proce_cxc,
           vsemana_proce_cxc,
           i.ref_cheque,
           '0',
           vDiario,
           pno_docu,
           USER,
           r.sub_cliente,
           SYSDATE,
           'CHEQUE POSTFECHADO GENERADO EN PROCESO DE COBRO. TRANS. COBRO: ' || pno_docu,
           i.ref_fecha,
           'D',
           r.cobrador,
           i.linea,
           i.id_forma_pago);
      
      EXCEPTION
        WHEN OTHERS THEN
          perror := 'Error al crear deuda para cheque postfechado';
          RAISE error_proceso;
      END;
    
      IF NOT cclib.trae_cuentas_conta(pno_cia, r.grupo, td_cxc, r.moneda, rCta) THEN
        perror := 'No existe la cuenta de clientes para el documento: ' || td_cxc || ' moneda ' || r.moneda;
        RAISE Error_proceso;
      END IF;
    
      vCta_Cliente := rCta.cta_cliente;
    
      IF cuenta_contable.acepta_cc(pno_cia, vCta_Cliente) THEN
        Lv_cc := CC_CCOSTO_SUBCLIENTE(pno_cia, r.grupo, r.no_cliente, r.sub_cliente);
        IF Lv_cc IS NULL THEN
          perror := 'El cliente: ' || r.grupo || ' ' || r.no_cliente || ' subcliente: ' || r.sub_cliente || ' no tiene configurado centro de costos';
          RAISE error_proceso;
        ELSE
          Lv_centro_costo := Lv_cc;
        END IF;
      ELSE
        Lv_centro_costo := centro_costo.rellenad(pno_cia, '0');
      END IF;
    
      --- El asiento contable del cheque postfechado es cliente contra cliente
      --- ANR 24/07/2009
      --- Crea la contabilizacion del documento cheque postfechado
      BEGIN
        INSERT INTO ARCCDC
          (no_cia,
           centro,
           tipo_doc,
           periodo,
           ruta,
           no_docu,
           grupo,
           no_cliente,
           codigo,
           tipo,
           monto,
           monto_dol,
           tipo_cambio,
           moneda,
           ind_con,
           centro_costo,
           modificable,
           monto_dc,
           glosa)
        VALUES
          (pno_cia,
           r.centro,
           td_cxc,
           vano_proce_cxc,
           r.ruta,
           no_cxc_p,
           r.grupo,
           r.no_cliente,
           vCta_cliente,
           'D',
           i.valor,
           i.valor / r.tipo_cambio,
           r.tipo_cambio,
           r.moneda,
           'P',
           Lv_centro_costo,
           'N',
           i.valor,
           r.no_cliente || ' - ' || td_cxc || ' - ' || i.ref_cheque || ' TRANS. COBRO: ' || pno_docu);
      
      EXCEPTION
        WHEN OTHERS THEN
          perror := 'Error al crear asiento contable del cliente para el cheque postfechado';
          RAISE error_proceso;
      END;
    
      --- Crea la contabilizacion del documento cheque postfechado
      BEGIN
        INSERT INTO ARCCDC
          (no_cia,
           centro,
           tipo_doc,
           periodo,
           ruta,
           no_docu,
           grupo,
           no_cliente,
           codigo,
           tipo,
           monto,
           monto_dol,
           tipo_cambio,
           moneda,
           ind_con,
           centro_costo,
           modificable,
           monto_dc,
           glosa)
        VALUES
          (pno_cia,
           r.centro,
           td_cxc,
           vano_proce_cxc,
           r.ruta,
           no_cxc_p,
           r.grupo,
           r.no_cliente,
           vCta_cliente, ---i.cuenta_contable,
           'C',
           i.valor,
           i.valor / r.tipo_cambio,
           r.tipo_cambio,
           r.moneda,
           'P',
           Lv_centro_costo,
           'N',
           i.valor,
           r.no_cliente || ' - ' || td_cxc || ' - ' || i.ref_cheque || ' TRANS. COBRO: ' || pno_docu);
      
      EXCEPTION
        WHEN OTHERS THEN
          perror := 'Error al crear asiento contable para el cheque postfechado';
          RAISE error_proceso;
      END;
    
      ccActualiza_dev(pno_cia, td_cxc, no_cxc_p, Lv_Error);
    
      IF Lv_Error IS NOT NULL THEN
        pError := Lv_Error;
        RAISE error_proceso;
      END IF;
    
    END LOOP;
  
    -- Coloca como actualizado  el documento
    UPDATE arccmd
       SET saldo                = NVL(vSaldo_doc, saldo),
           estado               = 'D',
           fecha_vence_original = fecha_vence,
           numero_ctrl          = vnumero_ctrl,
           tstamp               = SYSDATE
     WHERE no_cia = pno_cia
       AND no_docu = pno_docu;
  
    -- --
    -- Determina si el tipo de documento posee un Estado inicial
    vcod_estado := NULL;
    ccregistra_estado(pno_cia, r.no_docu, r.tipo_doc, 'I', vcod_Estado);
  
    IF vSaldo_doc = 0 THEN
      ccregistra_estado(pno_cia, r.no_docu, r.tipo_doc, 'F', vcod_Estado);
    END IF;
    -- --
    --  Traslada los impuestos al modulo de contabilidad para emision de
    --  libro de impuestos
    --
    pError := NULL;
    CCTraslada_Impuestos(pNo_Cia, pno_docu, pError);
    IF pError IS NOT NULL THEN
      RAISE Error_Proceso;
    END IF;
    --
    --add mlopez 28/05/2010
    --cuando queda pendiente un saldo por aplicar de la devolucion
    --se crea asiento por la diferencia pendiente
    OPEN c_es_dev(r.tipo_doc);
    FETCH c_es_dev
      INTO lc_es_dev;
    CLOSE c_es_dev;
  
    IF NVL(vSaldo_doc, 0) < 0 AND NVL(r.factura, 'N') = 'S' AND r.tipo_mov = 'C' AND NVL(lc_es_dev.ind_fac_dev, '') = 'D' THEN
      --creo asientos
      IF NOT cclib.trae_cuentas_conta(pno_cia, r.grupo, r.tipo_doc, r.moneda, rCta) THEN
        perror := 'No existe la cuenta de clientes para el documento: ' || r.tipo_doc || ' moneda ' || r.moneda;
        RAISE Error_proceso;
      END IF;
    
      vCta_Cliente := rCta.cta_cliente;
    
      IF cuenta_contable.acepta_cc(pno_cia, vCta_Cliente) THEN
        Lv_cc := CC_CCOSTO_SUBCLIENTE(pno_cia, r.grupo, r.no_cliente, r.sub_cliente);
      
        IF Lv_cc IS NULL THEN
          perror := 'El cliente: ' || r.grupo || ' ' || r.no_cliente || ' subcliente: ' || r.sub_cliente || ' no tiene configurado centro de costos';
          RAISE error_proceso;
        ELSE
          Lv_centro_costo := LPAD(r.centro, 3, '0') || SUBSTR(Lv_cc, 4, 6);
        END IF;
      ELSE
        Lv_centro_costo := centro_costo.rellenad(pno_cia, '0');
      END IF;
    
      OPEN c_ctas_default(r.grupo, r.tipo_doc);
      FETCH c_ctas_default
        INTO lc_ctas_default;
      CLOSE c_ctas_default;
    
      BEGIN
        INSERT INTO ARCCDC
          (no_cia,
           centro,
           tipo_doc,
           periodo,
           ruta,
           no_docu,
           grupo,
           no_cliente,
           codigo,
           tipo,
           monto,
           monto_dol,
           tipo_cambio,
           moneda,
           ind_con,
           centro_costo,
           modificable,
           monto_dc,
           glosa)
        VALUES
          (pno_cia,
           r.centro,
           r.tipo_doc,
           vano_proce_cxc,
           r.ruta,
           r.no_docu,
           r.grupo,
           r.no_cliente,
           vCta_cliente,
           'D',
           abs(NVL(vSaldo_doc, 0)),
           abs(NVL(vSaldo_doc, 0)) / r.tipo_cambio,
           r.tipo_cambio,
           r.moneda,
           'P',
           Lv_centro_costo,
           'N',
           abs(NVL(vSaldo_doc, 0)),
           r.no_cliente || ' - ' || r.tipo_doc || ': ' || r.no_docu || ' no aplicado a: ' || NVL(r.no_docu_refe, r.serie_fisico_refe));
      EXCEPTION
        WHEN OTHERS THEN
          perror := 'Error al crear asiento contable del cliente para la devolucion';
          RAISE error_proceso;
      END;
    
      BEGIN
        INSERT INTO ARCCDC
          (no_cia,
           centro,
           tipo_doc,
           periodo,
           ruta,
           no_docu,
           grupo,
           no_cliente,
           codigo,
           tipo,
           monto,
           monto_dol,
           tipo_cambio,
           moneda,
           ind_con,
           centro_costo,
           modificable,
           monto_dc,
           glosa)
        VALUES
          (pno_cia,
           r.centro,
           r.tipo_doc,
           vano_proce_cxc,
           r.ruta,
           r.no_docu,
           r.grupo,
           r.no_cliente,
           lc_ctas_default.cta_diferencia,
           'C',
           abs(NVL(vSaldo_doc, 0)),
           abs(NVL(vSaldo_doc, 0)) / r.tipo_cambio,
           r.tipo_cambio,
           r.moneda,
           'P',
           Lv_centro_costo,
           'N',
           abs(NVL(vSaldo_doc, 0)),
           r.no_cliente || ' - ' || r.tipo_doc || ': ' || r.no_docu || ' no aplicado a: ' || NVL(r.no_docu_refe, r.serie_fisico_refe));
      
      EXCEPTION
        WHEN OTHERS THEN
          perror := 'Error al crear asiento contable del cliente para la devolucion';
          RAISE error_proceso;
      END;
    END IF;
    --fin add mlopez 28/05/2010
  
    -- Actualiza saldo actual del cliente en la moneda dada 03/08/2009
    --
  
    CCActualiza_saldo_cliente(pno_cia, r.grupo, r.no_cliente, r.sub_cliente, NULL, r.moneda, NULL, NULL, NULL, NULL, NULL, perror);
  
    IF perror IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
  
  END IF;
EXCEPTION
  WHEN error_proceso THEN
    pError := NVL(pError, 'CC_ACTUALIZA: Error no descrito');
  WHEN consecutivo.error THEN
    pError := NVL(consecutivo.ultimo_error, 'CC_ACTUALIZA: Generando consecutivo');
  WHEN OTHERS THEN
    pError := NVL(SQLERRM, 'Exception en CC_ACTUALIZA');
END CCACTUALIZA_DEV;