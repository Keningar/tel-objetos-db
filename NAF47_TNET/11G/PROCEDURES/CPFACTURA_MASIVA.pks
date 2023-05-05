create or replace PROCEDURE            CPFACTURA_MASIVA(Pv_no_cia     IN VARCHAR2,
                                             Pv_no_docu    IN VARCHAR2,
                                             Pn_cant_factu IN NUMBER,
                                             Pv_msg_error  IN OUT VARCHAR2,
                                             Pv_mensaje    IN OUT VARCHAR2) IS

  /*
  Autor  : Fernando Espín M. (Yoveri)
  Fecha  : JUNIO-2012
  Motivo : Procedimiento que permitirá generar el ingreso de Facturas masivas para un mismo proveedor.
  */
  CURSOR C_arcpmd IS
    SELECT *
      FROM arcpmd
     WHERE no_cia = Pv_no_cia
       AND no_docu = Pv_no_docu;

  CURSOR C_arcprd(Cv_no_docu  IN VARCHAR2,
                  Cv_tipo_doc IN VARCHAR2) IS
    SELECT *
      FROM arcprd
     WHERE no_cia = Pv_no_cia
       AND tipo_doc = Cv_tipo_doc
       AND no_docu = Cv_no_docu;

  CURSOR C_arcpti(cv_prove    IN VARCHAR2,
                  cv_tipo_doc IN VARCHAR2,
                  cv_no_docu  IN VARCHAR2) IS
    SELECT *
      FROM arcpti
     WHERE no_cia = Pv_no_cia
       AND no_prove = cv_prove
       AND tipo_doc = cv_tipo_doc
       AND no_docu = cv_no_docu;

  /* no se usa
  CURSOR C_arcpdc(cv_prove    IN VARCHAR2,
                  cv_tipo_doc IN VARCHAR2,
                  cv_no_docu  IN VARCHAR2) IS
    SELECT *
      FROM arcpdc
     WHERE no_cia = Pv_no_cia
       AND no_prove = cv_prove
       AND tipo_doc = cv_tipo_doc
       AND no_docu = cv_no_docu;*/

  Lv_Error VARCHAR2(2000) := NULL;
  Le_error EXCEPTION;
  Lv_sec_inicial VARCHAR2(15) := NULL;
  Lv_sec_final   VARCHAR2(15) := NULL;
  Lv_no_docu     VARCHAR2(15) := NULL;
  Lb_Not_Found   BOOLEAN;
  Lc_md          C_arcpmd%ROWTYPE;

BEGIN
  --Etapa de validaciones
  IF Pv_no_cia IS NULL THEN
    Lv_Error := 'La compañía es obligatoria, Favor seleccionarla.';
    RAISE le_error;
  END IF;

  IF Pv_no_docu IS NULL THEN
    Lv_Error := 'Debe de indicar el nro. de documento a procesar, Favor revisar.';
    RAISE le_error;
  END IF;

  IF Pn_cant_factu IS NULL THEN
    Lv_Error := 'Debe de indicar el número de facturas que se deben generar, Favor revisar.';
    RAISE le_error;
  END IF;

  --Recupero en variables tipo cursor el dato ya creado previamente
  OPEN C_arcpmd;
  FETCH C_arcpmd
    INTO Lc_md;
  Lb_Not_Found := C_arcpmd%NOTFOUND;
  CLOSE C_arcpmd;

  --Solo para el caso en que no exista información para el documento creado lo advierto.
  IF Lb_Not_Found THEN
    Lv_Error := 'El número de documento no existe, Favor revisar';
    RAISE le_error;
  END IF;

  -- Barro la cantidad de Facturas que indica el usuario
  FOR i IN 1 .. Pn_cant_factu LOOP
    ---
    Lv_no_docu := transa_id.cp(Pv_no_cia);
  
    --Guardo la primera secuencia que se genera
    IF Lv_sec_inicial IS NULL THEN
      Lv_sec_inicial := Lv_no_docu;
    END IF;
  
    INSERT INTO arcpmd
      (no_cia,
       no_prove,
       tipo_doc,
       no_docu,
       ind_act,
       no_fisico,
       serie_fisico,
       ind_otromov,
       fecha,
       subtotal,
       monto,
       saldo,
       gravado,
       excentos,
       descuento,
       tot_refer,
       tot_db,
       tot_cr,
       fecha_vence,
       desc_c,
       no_orden,
       desc_p,
       plazo_c,
       plazo_p,
       bloqueado,
       motivo,
       moneda,
       tipo_cambio,
       monto_nominal,
       saldo_nominal,
       tipo_compra,
       monto_bienes,
       monto_serv,
       monto_importac,
       no_cta,
       no_secuencia,
       t_camb_c_v,
       detalle,
       ind_otros_meses,
       fecha_documento,
       fecha_vence_original,
       cant_prorrogas,
       origen,
       numero_ctrl,
       anulado,
       usuario_anula,
       motivo_anula,
       cod_estado,
       ind_estado_vencido,
       ano_anulado,
       mes_anulado,
       tot_dpp,
       tot_imp,
       tot_ret,
       tot_imp_especial,
       cod_diario,
       tot_ret_especial,
       n_docu_a,
       concepto,
       codigo_sustento,
       no_autorizacion,
       derecho_devolucion_iva,
       fecha_caducidad,
       fecha_actualizacion,
       comp_ret,
       ind_impresion_ret,
       ind_reimpresion_ret,
       usuario,
       monto_fisico,
       pedido,
       no_autorizacion_comp,
       fecha_validez,
       fecha_validez_comp,
       tipo_factura,
       tipo_hist,
       fecha_anula,
       usuario_actualiza,
       factura_gasto,
       compra_activo,
       no_retenc_iva,
       no_retenc_fuente,
       comp_ret_serie,
       comp_ret_anulada,
       excento_bienes,
       excento_serv,
       factura_eventual,
       tipo_ret,
       cod_vendedor,
       tarjeta_corp,
       plazo_c1,
       fecha_vence1,
       dirigido,
       numero_pagos,
       tipo_comprobante,
       codigo_destino,
       no_autorizacion_imprenta,
       centro,
       referencia,
       total_bruto_inventarios,
       descuento_inventario,
       sri_retimp_renta,
       no_embarque,
       verificador,
       correlativo,
       codigo_regimen,
       codigo_distrito,
       id_presupuesto)
    VALUES
      (Lc_md.no_cia,
       Lc_md.no_prove,
       Lc_md.tipo_doc,
       Lv_no_docu, --
       Lc_md.ind_act,
       Lc_md.no_fisico,
       Lc_md.serie_fisico,
       Lc_md.ind_otromov,
       Lc_md.fecha,
       Lc_md.subtotal,
       Lc_md.monto,
       Lc_md.saldo,
       Lc_md.gravado,
       Lc_md.excentos,
       Lc_md.descuento,
       Lc_md.tot_refer,
       Lc_md.tot_db,
       Lc_md.tot_cr,
       Lc_md.fecha_vence,
       Lc_md.desc_c,
       Lc_md.no_orden,
       Lc_md.desc_p,
       Lc_md.plazo_c,
       Lc_md.plazo_p,
       Lc_md.bloqueado,
       Lc_md.motivo,
       Lc_md.moneda,
       Lc_md.tipo_cambio,
       Lc_md.monto_nominal,
       Lc_md.saldo_nominal,
       Lc_md.tipo_compra,
       Lc_md.monto_bienes,
       Lc_md.monto_serv,
       Lc_md.monto_importac,
       Lc_md.no_cta,
       Lc_md.no_secuencia,
       Lc_md.t_camb_c_v,
       Lc_md.detalle,
       Lc_md.ind_otros_meses,
       Lc_md.fecha_documento,
       Lc_md.fecha_vence_original,
       Lc_md.cant_prorrogas,
       Lc_md.origen,
       Lc_md.numero_ctrl,
       Lc_md.anulado,
       Lc_md.usuario_anula,
       Lc_md.motivo_anula,
       Lc_md.cod_estado,
       Lc_md.ind_estado_vencido,
       Lc_md.ano_anulado,
       Lc_md.mes_anulado,
       Lc_md.tot_dpp,
       Lc_md.tot_imp,
       Lc_md.tot_ret,
       Lc_md.tot_imp_especial,
       Lc_md.cod_diario,
       Lc_md.tot_ret_especial,
       Lc_md.n_docu_a,
       Lc_md.concepto,
       Lc_md.codigo_sustento,
       Lc_md.no_autorizacion,
       Lc_md.derecho_devolucion_iva,
       Lc_md.fecha_caducidad,
       Lc_md.fecha_actualizacion,
       Lc_md.comp_ret,
       Lc_md.ind_impresion_ret,
       Lc_md.ind_reimpresion_ret,
       Lc_md.usuario,
       Lc_md.monto_fisico,
       Lc_md.pedido,
       Lc_md.no_autorizacion_comp,
       Lc_md.fecha_validez,
       Lc_md.fecha_validez_comp,
       Lc_md.tipo_factura,
       Lc_md.tipo_hist,
       Lc_md.fecha_anula,
       Lc_md.usuario_actualiza,
       Lc_md.factura_gasto,
       Lc_md.compra_activo,
       Lc_md.no_retenc_iva,
       Lc_md.no_retenc_fuente,
       Lc_md.comp_ret_serie,
       Lc_md.comp_ret_anulada,
       Lc_md.excento_bienes,
       Lc_md.excento_serv,
       Lc_md.factura_eventual,
       Lc_md.tipo_ret,
       Lc_md.cod_vendedor,
       Lc_md.tarjeta_corp,
       Lc_md.plazo_c1,
       Lc_md.fecha_vence1,
       Lc_md.dirigido,
       Lc_md.numero_pagos,
       Lc_md.tipo_comprobante,
       Lc_md.codigo_destino,
       Lc_md.no_autorizacion_imprenta,
       Lc_md.centro,
       Lc_md.referencia,
       Lc_md.total_bruto_inventarios,
       Lc_md.descuento_inventario,
       Lc_md.sri_retimp_renta,
       Lc_md.no_embarque,
       Lc_md.verificador,
       Lc_md.correlativo,
       Lc_md.codigo_regimen,
       Lc_md.codigo_distrito,
       Lc_md.id_presupuesto);
  
    --Registro los datos que voy a mostrar para que mi Blanquita los llene.
    INSERT INTO arcpmd_masiva
      (no_cia,
       no_prove,
       tipo_doc,
       no_docu,
       no_docu_refe,
       estado,
       tstamp,
       user_crea)
    VALUES
      (Lc_md.no_cia,
       Lc_md.no_prove,
       Lc_md.Tipo_Doc,
       Lv_no_docu,
       Pv_no_docu,
       'A',
       SYSDATE,
       USER);
  
    --Esta registra las varas de la relación de los documentos.
    FOR j IN C_arcprd(Lc_md.No_Docu, Lc_md.Tipo_Doc) LOOP
      INSERT INTO arcprd
        (no_cia,
         tipo_doc,
         no_docu,
         tipo_refe,
         no_refe,
         monto,
         monto_refe,
         moneda_refe,
         descuento_pp,
         fec_aplic,
         ano,
         mes,
         ind_procesado,
         no_prove,
         dif_cambiario,
         procedencia)
      VALUES
        (j.no_cia,
         j.tipo_doc,
         Lv_no_docu,
         j.tipo_refe,
         j.no_refe,
         j.monto,
         j.monto_refe,
         j.moneda_refe,
         j.descuento_pp,
         j.fec_aplic,
         j.ano,
         j.mes,
         j.ind_procesado,
         j.no_prove,
         j.dif_cambiario,
         j.procedencia);
    END LOOP;
  
    --Esta vara registra el tema de los impuestos.
    FOR ti IN C_arcpti(Lc_md.No_Prove, Lc_md.Tipo_Doc, Lc_md.No_Docu) LOOP
      INSERT INTO arcpti
        (no_cia,
         no_prove,
         tipo_doc,
         no_docu,
         clave,
         porcentaje,
         monto,
         ind_imp_ret,
         aplica_cred_fiscal,
         base,
         codigo_tercero,
         comportamiento,
         id_sec,
         no_refe,
         secuencia_ret,
         anulada,
         fecha_imprime,
         sri_retimp_renta,
         servicio_bienes,
         autorizacion,
         fecha_anula,
         base_gravada,
         base_excenta)
      VALUES
        (ti.no_cia,
         ti.no_prove,
         ti.tipo_doc,
         Lv_no_docu,
         ti.clave,
         ti.porcentaje,
         ti.monto,
         ti.ind_imp_ret,
         ti.aplica_cred_fiscal,
         ti.base,
         ti.codigo_tercero,
         ti.comportamiento,
         ti.id_sec,
         Lv_no_docu,
         ti.secuencia_ret,
         ti.anulada,
         ti.fecha_imprime,
         ti.sri_retimp_renta,
         ti.servicio_bienes,
         ti.autorizacion,
         ti.fecha_anula,
         ti.base_gravada,
         ti.base_excenta);
    END LOOP;
  
  -- Genero la distribución contable (con la misma cuenta)
  /*For dc in C_arcpdc (Lc_md.No_Prove, Lc_md.Tipo_Doc, Lc_md.No_Docu) loop
             insert into arcpdc (no_cia,
                                 no_prove,
                                 tipo_doc,
                                 no_docu,
                                 codigo,
                                 tipo,
                                 monto,
                                 mes,
                                 ano,
                                 ind_con,
                                 monto_dol,
                                 moneda,
                                 tipo_cambio,
                                 no_asiento,
                                 centro_costo,
                                 modificable,
                                 codigo_tercero,
                                 monto_dc,
                                 glosa,
                                 excede_presupuesto)
                         values (dc.no_cia,
                                 dc.no_prove,
                                 dc.tipo_doc,
                                 Lv_no_docu,
                                 dc.codigo,
                                 dc.tipo,
                                 dc.monto,
                                 dc.mes,
                                 dc.ano,
                                 dc.ind_con,
                                 dc.monto_dol,
                                 dc.moneda,
                                 dc.tipo_cambio,
                                 dc.no_asiento,
                                 dc.centro_costo,
                                 dc.modificable,
                                 dc.codigo_tercero,
                                 dc.monto_dc,
                                 dc.glosa,
                                 dc.excede_presupuesto);
         End loop;*/
  END LOOP;

  Lv_sec_final := Lv_no_docu;

  Pv_mensaje := 'Se generaron ' || Pn_cant_factu || ' Documentos, desde el : ' || Lv_sec_inicial || ' hasta el : ' || Lv_sec_final;
  --
  --
EXCEPTION
  WHEN Le_error THEN
    Pv_msg_error := Lv_Error;
END CPFACTURA_MASIVA;