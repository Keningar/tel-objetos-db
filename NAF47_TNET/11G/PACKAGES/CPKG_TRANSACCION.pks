CREATE OR REPLACE package NAF47_TNET.CPKG_TRANSACCION is
  /**
  * Documentacion para NAF47_TNET.CPKG_TRANSACCION
  * Paquete que contiene procesos y funciones para registro automatico factura proveedor.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 11/10/2021
  */
  
  /*
  * Mejora para aumento del campo glosa parametrizado el maximo de la glosa
  * @tag  JXZURITA-AUMENTO CAMPO GLOSA
  * @author jxzurita <jxzurita@telconet.ec>
  * @version 2.0 06/10/2021
  */

  /**
  * Documentacion para NAF47_TNET.CPKG_TRANSACCION.Gr_DatosFactura
  * Variable Registro que permite pasar por parametro los datos necesarios para el registro autom�tico de factura proveedor
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 11/10/2021
  */
  TYPE Gr_DatosFactura is RECORD
     ( NO_CIA                  NAF47_TNET.ARCPMD.NO_CIA%TYPE,
       TIPO_DOCUMENTO_ID       NAF47_TNET.ARCPMD.TIPO_DOC%TYPE,
       NO_PROVEEDOR            NAF47_TNET.ARCPMD.NO_PROVE%TYPE,
       TIPO_FACTURA            VARCHAR2(30),
       ES_DOC_ELECTRONICO      NAF47_TNET.ARCPMD.IND_DOC_ELECTRONICO%TYPE,
       FECHA_DOCUMENTO         NAF47_TNET.ARCPMD.FECHA_DOCUMENTO%TYPE,
       FECHA_REGISTRO          NAF47_TNET.ARCPMD.FECHA%TYPE,
       NO_FISICO               NAF47_TNET.ARCPMD.NO_FISICO%TYPE,
       SERIE_FISICO            NAF47_TNET.ARCPMD.SERIE_FISICO%TYPE,
       NO_AUTORIZACION         NAF47_TNET.ARCPMD.NO_AUTORIZACION%TYPE,
       FECHA_CADUCIDAD         NAF47_TNET.ARCPMD.FECHA_CADUCIDAD%TYPE,
       DETALLE                 NAF47_TNET.ARCPMD.DETALLE%TYPE,
       GRAVA_IMPUESTO_BIENES   NAF47_TNET.ARCPMD.MONTO_BIENES%TYPE,
       GRAVA_IMPUESTO_SERVICIO NAF47_TNET.ARCPMD.MONTO_SERV%TYPE,
       BASE_CERO_BIENES        NAF47_TNET.ARCPMD.EXCENTO_BIENES%TYPE,
       BASE_CERO_SERVICIOS     NAF47_TNET.ARCPMD.EXCENTO_SERV%TYPE,
       NO_ORDEN                NAF47_TNET.TAPORDEE.NO_ORDEN%TYPE,
       TIPO_INGRESO_BODEGA     NAF47_TNET.ARINME.TIPO_DOC%TYPE,
       NO_INGRESO_BODEGA       NAF47_TNET.ARINME.NO_DOCU%TYPE,
       MONTO                   NAF47_TNET.TAPORDEE.TOTAL%TYPE
       );

  --
  TYPE Gt_DatosFactura IS TABLE of Gr_DatosFactura;
  --
  --
 /**
  * Documentacion para P_INSERTA_ARCPMD
  * Procedure que inserta registro en la tabla NAF47_TNET.ARCPMD
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 11/10/2021
  *
  * @author llindao <llindao@telconet.ec>
  * @version 1.1 04/04/2022 - Se modifica para no referenciar al campo LOB en el insert de la estructura.
  *
  * @param Pr_Arcpmd       IN NAF47_TNET.ARCPMD%ROWTYPE Recibe variable tipo registro para realizar insert
  * @param Pv_MensajeError IN OUT VARCHAR2              Retorna mensaje error
  */
  PROCEDURE P_INSERTA_ARCPMD (Pr_Arcpmd       IN NAF47_TNET.ARCPMD%ROWTYPE,
                              Pv_MensajeError IN OUT VARCHAR2);
  --
  --
 /**
  * Documentacion para P_INSERTA_ARCPTI
  * Procedure que inserta registro en la tabla NAF47_TNET.ARCPTI
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 11/10/2021
  *
  * @param Pr_Arcpti       IN NAF47_TNET.ARCPTI%ROWTYPE Recibe variable tipo registro para realizar insert
  * @param Pv_MensajeError IN OUT VARCHAR2              Retorna mensaje error
  */
  PROCEDURE P_INSERTA_ARCPTI ( Pr_Arcpti       IN NAF47_TNET.ARCPTI%ROWTYPE,
                               Pv_mensajeError IN OUT VARCHAR2);
  --
  --
 /**
  * Documentacion para P_INSERTA_ARCPDC
  * Procedure que inserta registro en la tabla NAF47_TNET.ARCPDC
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 11/10/2021
  *
  * @param Pr_Arcpdc       IN NAF47_TNET.ARCPDC%ROWTYPE Recibe variable tipo registro para realizar insert
  * @param Pv_MensajeError IN OUT VARCHAR2              Retorna mensaje error
  */
  PROCEDURE P_INSERTA_ARCPDC ( Pr_Arcpdc       IN NAF47_TNET.ARCPDC%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2 );
  --
  --
 /**
  * Documentacion para P_INSERTA_DOCUMENTO_ORIGEN
  * Procedure que inserta registro en la tabla NAF47_TNET.CP_DOCUMENTO_ORIGEN
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 11/10/2021
  *
  * @param Pr_cpDocOrigen  IN NAF47_TNET.CP_DOCUMENTO_ORIGEN%ROWTYPE Recibe variable tipo registro para realizar insert
  * @param Pv_MensajeError IN OUT VARCHAR2                           Retorna mensaje error
  */
  PROCEDURE P_INSERTA_DOCUMENTO_ORIGEN ( Pr_cpDocOrigen  IN NAF47_TNET.CP_DOCUMENTO_ORIGEN%ROWTYPE,
                                         Pv_MensajeError IN OUT VARCHAR2);
  --
  --
 /**
  * Documentacion para P_REGISTRO_FACTURA
  * Procedure que genera registro de factura proveedor en tabla de documentos cuentas por pagar.
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 11/10/2021
  *
  * @param Pt_DatosFactura IN     VARCHAR2 Recibe registro datos de factura
  * @param Pv_noDocumento  IN     VARCHAR2 Retorna numero transaccion cuentas por pagar.
  * @param Pv_MensajeError IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE P_REGISTRO_FACTURA ( Pt_DatosFactura IN NAF47_TNET.CPKG_TRANSACCION.Gt_DatosFactura,
                                 Pv_noDocumento  IN OUT VARCHAR2,
                                 Pv_MensajeError IN OUT VARCHAR2);

end CPKG_TRANSACCION;
/


CREATE OR REPLACE package body NAF47_TNET.CPKG_TRANSACCION is
  --
  --
  PROCEDURE P_INSERTA_ARCPMD (Pr_Arcpmd       IN NAF47_TNET.ARCPMD%ROWTYPE,
                              Pv_MensajeError IN OUT VARCHAR2) IS
  
  BEGIN
    --
    INSERT INTO NAF47_TNET.ARCPMD
         (  NO_CIA, 
            NO_PROVE, 
            TIPO_DOC, 
            NO_DOCU, 
            IND_ACT, 
            NO_FISICO, 
            SERIE_FISICO, 
            IND_OTROMOV, 
            FECHA, 
            SUBTOTAL, 
            MONTO, 
            SALDO, 
            GRAVADO, 
            EXCENTOS, 
            DESCUENTO, 
            TOT_REFER, 
            TOT_DB, 
            TOT_CR, 
            FECHA_VENCE, 
            DESC_C, 
            NO_ORDEN, 
            DESC_P, 
            PLAZO_C, 
            PLAZO_P, 
            BLOQUEADO, 
            MOTIVO, 
            MONEDA, 
            TIPO_CAMBIO, 
            MONTO_NOMINAL, 
            SALDO_NOMINAL, 
            TIPO_COMPRA, 
            MONTO_BIENES, 
            MONTO_SERV, 
            MONTO_IMPORTAC, 
            NO_CTA, 
            NO_SECUENCIA, 
            T_CAMB_C_V, 
            DETALLE, 
            FECHA_DOCUMENTO, 
            FECHA_VENCE_ORIGINAL, 
            CANT_PRORROGAS, 
            ORIGEN, 
            NUMERO_CTRL, 
            ANULADO, 
            USUARIO_ANULA, 
            MOTIVO_ANULA, 
            COD_ESTADO, 
            IND_ESTADO_VENCIDO, 
            ANO_ANULADO, 
            MES_ANULADO, 
            TOT_DPP, 
            TOT_IMP, 
            TOT_RET, 
            TOT_IMP_ESPECIAL, 
            COD_DIARIO, 
            TOT_RET_ESPECIAL, 
            N_DOCU_A, 
            CONCEPTO, 
            CODIGO_SUSTENTO, 
            NO_AUTORIZACION, 
            DERECHO_DEVOLUCION_IVA, 
            FECHA_CADUCIDAD, 
            FECHA_ACTUALIZACION, 
            COMP_RET, 
            IND_IMPRESION_RET, 
            IND_REIMPRESION_RET, 
            USUARIO, 
            MONTO_FISICO, 
            PEDIDO, 
            NO_AUTORIZACION_COMP, 
            FECHA_VALIDEZ, 
            FECHA_VALIDEZ_COMP, 
            TIPO_FACTURA, 
            TIPO_HIST, 
            FECHA_ANULA, 
            USUARIO_ACTUALIZA, 
            FACTURA_GASTO, 
            COMPRA_ACTIVO, 
            NO_RETENC_IVA, 
            NO_RETENC_FUENTE, 
            COMP_RET_SERIE, 
            COMP_RET_ANULADA, 
            EXCENTO_BIENES, 
            EXCENTO_SERV, 
            FACTURA_EVENTUAL, 
            TIPO_RET, 
            COD_VENDEDOR, 
            TARJETA_CORP, 
            PLAZO_C1, 
            FECHA_VENCE1, 
            DIRIGIDO, 
            NUMERO_PAGOS, 
            TIPO_COMPROBANTE, 
            CODIGO_DESTINO, 
            NO_AUTORIZACION_IMPRENTA, 
            CENTRO, 
            REFERENCIA, 
            TOTAL_BRUTO_INVENTARIOS, 
            DESCUENTO_INVENTARIO, 
            SRI_RETIMP_RENTA, 
            NO_EMBARQUE, 
            VERIFICADOR, 
            CORRELATIVO, 
            CODIGO_REGIMEN, 
            CODIGO_DISTRITO, 
            ID_PRESUPUESTO, 
            CLAVE_ACCESO, 
            DETALLE_RECHAZO, 
            NOMBRE_ARCHIVO, 
            FECHA_RETENCION, 
            ESTADO_SRI, 
            TIME_STAMP, 
            IND_DOC_ELECTRONICO, 
            DOCUMENTO_ID, 
            TIPO_DOC_ID, 
            EMPRESA_ID, 
            MENSAJE_AUTORIZACION_SRI, 
            SERVICIO_ID, 
            FORMA_PAGO_ID, 
            DOCUMENTO_ID_COMP_ELECT, 
            TIPO_DOC_COMP_ELECT, 
            CLAVE_ACCESO_COMP_ELECT, 
            DET_RECHAZO_COMP_ELECT, 
            ARCHIVO_COMP_ELECT, 
            EST_SRI_COMP_ELECT, 
            NUM_ENVIO_COMP_ELECT, 
            MENS_AUT_SRI_COMP_ELECT, 
            EMPRESA_ID_COMP_ELECT, 
            FECHA_COMP_ELECT)
    VALUES (Pr_Arcpmd.no_cia, 
            Pr_Arcpmd.no_prove, 
            Pr_Arcpmd.tipo_doc, 
            Pr_Arcpmd.no_docu, 
            Pr_Arcpmd.ind_act, 
            Pr_Arcpmd.no_fisico, 
            Pr_Arcpmd.serie_fisico, 
            Pr_Arcpmd.ind_otromov, 
            Pr_Arcpmd.fecha, 
            Pr_Arcpmd.subtotal, 
            Pr_Arcpmd.monto, 
            Pr_Arcpmd.saldo, 
            Pr_Arcpmd.gravado, 
            Pr_Arcpmd.excentos, 
            Pr_Arcpmd.descuento, 
            Pr_Arcpmd.tot_refer, 
            Pr_Arcpmd.tot_db, 
            Pr_Arcpmd.tot_cr, 
            Pr_Arcpmd.fecha_vence, 
            Pr_Arcpmd.desc_c, 
            Pr_Arcpmd.no_orden, 
            Pr_Arcpmd.desc_p, 
            Pr_Arcpmd.plazo_c, 
            Pr_Arcpmd.plazo_p, 
            Pr_Arcpmd.bloqueado, 
            Pr_Arcpmd.motivo, 
            Pr_Arcpmd.moneda, 
            Pr_Arcpmd.tipo_cambio, 
            Pr_Arcpmd.monto_nominal, 
            Pr_Arcpmd.saldo_nominal, 
            Pr_Arcpmd.tipo_compra, 
            Pr_Arcpmd.monto_bienes, 
            Pr_Arcpmd.monto_serv, 
            Pr_Arcpmd.monto_importac, 
            Pr_Arcpmd.no_cta, 
            Pr_Arcpmd.no_secuencia, 
            Pr_Arcpmd.t_camb_c_v, 
            Pr_Arcpmd.detalle, 
            Pr_Arcpmd.fecha_documento, 
            Pr_Arcpmd.fecha_vence_original, 
            Pr_Arcpmd.cant_prorrogas, 
            Pr_Arcpmd.origen, 
            Pr_Arcpmd.numero_ctrl, 
            Pr_Arcpmd.anulado, 
            Pr_Arcpmd.usuario_anula, 
            Pr_Arcpmd.motivo_anula, 
            Pr_Arcpmd.cod_estado, 
            Pr_Arcpmd.ind_estado_vencido, 
            Pr_Arcpmd.ano_anulado, 
            Pr_Arcpmd.mes_anulado, 
            Pr_Arcpmd.tot_dpp, 
            Pr_Arcpmd.tot_imp, 
            Pr_Arcpmd.tot_ret, 
            Pr_Arcpmd.tot_imp_especial, 
            Pr_Arcpmd.cod_diario, 
            Pr_Arcpmd.tot_ret_especial, 
            Pr_Arcpmd.n_docu_a, 
            Pr_Arcpmd.concepto, 
            Pr_Arcpmd.codigo_sustento, 
            Pr_Arcpmd.no_autorizacion, 
            Pr_Arcpmd.derecho_devolucion_iva, 
            Pr_Arcpmd.fecha_caducidad, 
            Pr_Arcpmd.fecha_actualizacion, 
            Pr_Arcpmd.comp_ret, 
            Pr_Arcpmd.ind_impresion_ret, 
            Pr_Arcpmd.ind_reimpresion_ret, 
            Pr_Arcpmd.usuario, 
            Pr_Arcpmd.monto_fisico, 
            Pr_Arcpmd.pedido, 
            Pr_Arcpmd.no_autorizacion_comp, 
            Pr_Arcpmd.fecha_validez, 
            Pr_Arcpmd.fecha_validez_comp, 
            Pr_Arcpmd.tipo_factura, 
            Pr_Arcpmd.tipo_hist, 
            Pr_Arcpmd.fecha_anula, 
            Pr_Arcpmd.usuario_actualiza, 
            Pr_Arcpmd.factura_gasto, 
            Pr_Arcpmd.compra_activo, 
            Pr_Arcpmd.no_retenc_iva, 
            Pr_Arcpmd.no_retenc_fuente, 
            Pr_Arcpmd.comp_ret_serie, 
            Pr_Arcpmd.comp_ret_anulada, 
            Pr_Arcpmd.excento_bienes, 
            Pr_Arcpmd.excento_serv, 
            Pr_Arcpmd.factura_eventual, 
            Pr_Arcpmd.tipo_ret, 
            Pr_Arcpmd.cod_vendedor, 
            Pr_Arcpmd.tarjeta_corp, 
            Pr_Arcpmd.plazo_c1, 
            Pr_Arcpmd.fecha_vence1, 
            Pr_Arcpmd.dirigido, 
            Pr_Arcpmd.numero_pagos, 
            Pr_Arcpmd.tipo_comprobante, 
            Pr_Arcpmd.codigo_destino, 
            Pr_Arcpmd.no_autorizacion_imprenta, 
            Pr_Arcpmd.centro, 
            Pr_Arcpmd.referencia, 
            Pr_Arcpmd.total_bruto_inventarios, 
            Pr_Arcpmd.descuento_inventario, 
            Pr_Arcpmd.sri_retimp_renta, 
            Pr_Arcpmd.no_embarque, 
            Pr_Arcpmd.verificador, 
            Pr_Arcpmd.correlativo, 
            Pr_Arcpmd.codigo_regimen, 
            Pr_Arcpmd.codigo_distrito, 
            Pr_Arcpmd.id_presupuesto, 
            Pr_Arcpmd.clave_acceso, 
            Pr_Arcpmd.detalle_rechazo, 
            Pr_Arcpmd.nombre_archivo, 
            Pr_Arcpmd.fecha_retencion, 
            Pr_Arcpmd.estado_sri, 
            sysdate, 
            Pr_Arcpmd.ind_doc_electronico, 
            Pr_Arcpmd.documento_id, 
            Pr_Arcpmd.tipo_doc_id, 
            Pr_Arcpmd.empresa_id, 
            Pr_Arcpmd.mensaje_autorizacion_sri, 
            Pr_Arcpmd.servicio_id, 
            Pr_Arcpmd.forma_pago_id, 
            Pr_Arcpmd.documento_id_comp_elect, 
            Pr_Arcpmd.tipo_doc_comp_elect, 
            Pr_Arcpmd.clave_acceso_comp_elect, 
            Pr_Arcpmd.det_rechazo_comp_elect, 
            Pr_Arcpmd.archivo_comp_elect, 
            Pr_Arcpmd.est_sri_comp_elect, 
            Pr_Arcpmd.num_envio_comp_elect, 
            Pr_Arcpmd.mens_aut_sri_comp_elect, 
            Pr_Arcpmd.empresa_id_comp_elect, 
            Pr_Arcpmd.fecha_comp_elect);

    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'CPKG_TRANSACCION.P_INSERTA_ARCPMD',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

  END P_INSERTA_ARCPMD;
  --
  --
  PROCEDURE P_INSERTA_ARCPTI ( Pr_Arcpti       IN NAF47_TNET.ARCPTI%ROWTYPE,
                                 Pv_mensajeError IN OUT VARCHAR2) IS
  
  BEGIN
    INSERT INTO NAF47_TNET.ARCPTI
         (NO_CIA, 
          NO_PROVE, 
          TIPO_DOC, 
          NO_DOCU, 
          CLAVE, 
          PORCENTAJE, 
          MONTO, 
          IND_IMP_RET, 
          APLICA_CRED_FISCAL, 
          BASE, 
          CODIGO_TERCERO, 
          COMPORTAMIENTO, 
          ID_SEC, 
          NO_REFE, 
          SECUENCIA_RET, 
          --ANULADA, 
          FECHA_IMPRIME, 
          SRI_RETIMP_RENTA, 
          SERVICIO_BIENES, 
          AUTORIZACION, 
          FECHA_ANULA, 
          BASE_GRAVADA, 
          BASE_EXCENTA
         )
    VALUES
         (Pr_Arcpti.no_cia, 
          Pr_Arcpti.no_prove, 
          Pr_Arcpti.tipo_doc, 
          Pr_Arcpti.no_docu, 
          Pr_Arcpti.clave, 
          Pr_Arcpti.porcentaje, 
          Pr_Arcpti.monto, 
          Pr_Arcpti.ind_imp_ret, 
          Pr_Arcpti.aplica_cred_fiscal, 
          Pr_Arcpti.base, 
          Pr_Arcpti.codigo_tercero, 
          Pr_Arcpti.comportamiento, 
          Pr_Arcpti.id_sec, 
          Pr_Arcpti.no_refe, 
          Pr_Arcpti.secuencia_ret, 
          --Pr_Arcpti.anulada, 
          Pr_Arcpti.fecha_imprime, 
          Pr_Arcpti.sri_retimp_renta, 
          Pr_Arcpti.servicio_bienes, 
          Pr_Arcpti.autorizacion, 
          Pr_Arcpti.fecha_anula, 
          Pr_Arcpti.base_gravada, 
          Pr_Arcpti.base_excenta
         );
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'CPKG_TRANSACCION.P_INSERTA_ARCPTI',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

  END P_INSERTA_ARCPTI;
  --
  --
  PROCEDURE P_INSERTA_ARCPDC ( Pr_Arcpdc       IN NAF47_TNET.ARCPDC%ROWTYPE,
                               Pv_MensajeError IN OUT VARCHAR2 ) IS
  BEGIN
    --
    UPDATE NAF47_TNET.ARCPDC A
    SET MONTO_DC = MONTO_DC + Pr_Arcpdc.Monto_Dc,
        MONTO = MONTO + Pr_Arcpdc.Monto,
        MONTO_DOL = MONTO_DOL + Pr_Arcpdc.Monto_Dol
    WHERE CODIGO = Pr_Arcpdc.Codigo
    AND CENTRO_COSTO = Pr_Arcpdc.Centro_Costo
    AND TIPO = Pr_Arcpdc.Tipo
    AND NO_DOCU = Pr_Arcpdc.No_Docu
    AND TIPO_DOC = Pr_Arcpdc.Tipo_Doc
    AND NO_PROVE = Pr_Arcpdc.No_Prove
    AND NO_CIA = Pr_Arcpdc.No_Cia;
    --
    IF SQL%ROWCOUNT > 0 THEN
      RETURN;
    END IF;
    --
    INSERT INTO NAF47_TNET.ARCPDC
           (NO_CIA, 
            NO_PROVE, 
            TIPO_DOC, 
          NO_DOCU, 
          CODIGO, 
          TIPO, 
          MONTO, 
          MES, 
          ANO, 
          IND_CON, 
          MONTO_DOL, 
          MONEDA, 
          TIPO_CAMBIO, 
          NO_ASIENTO, 
          CENTRO_COSTO, 
          MODIFICABLE, 
          CODIGO_TERCERO, 
          MONTO_DC, 
          GLOSA, 
          EXCEDE_PRESUPUESTO, 
          NO_DISTRIBUCION)
    VALUES
         (Pr_Arcpdc.no_cia, 
          Pr_Arcpdc.no_prove, 
          Pr_Arcpdc.tipo_doc, 
          Pr_Arcpdc.no_docu, 
          Pr_Arcpdc.codigo, 
          Pr_Arcpdc.tipo, 
          Pr_Arcpdc.monto, 
          Pr_Arcpdc.mes, 
          Pr_Arcpdc.ano, 
          Pr_Arcpdc.ind_con, 
          Pr_Arcpdc.monto_dol, 
          Pr_Arcpdc.moneda, 
          Pr_Arcpdc.tipo_cambio, 
          Pr_Arcpdc.no_asiento, 
          Pr_Arcpdc.centro_costo, 
          Pr_Arcpdc.modificable, 
          Pr_Arcpdc.codigo_tercero, 
          Pr_Arcpdc.monto_dc, 
          Pr_Arcpdc.glosa, 
          Pr_Arcpdc.excede_presupuesto, 
          Pr_Arcpdc.no_distribucion);
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'CPKG_TRANSACCION.P_INSERTA_ARCPDC',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

  END P_INSERTA_ARCPDC;
  --
  --
  PROCEDURE P_INSERTA_DOCUMENTO_ORIGEN ( Pr_cpDocOrigen  IN NAF47_TNET.CP_DOCUMENTO_ORIGEN%ROWTYPE,
                                         Pv_MensajeError IN OUT VARCHAR2) IS
  
  BEGIN
    --
    INSERT INTO NAF47_TNET.CP_DOCUMENTO_ORIGEN
         (COMPANIA, 
          TIPO_DOCUMENTO, 
          NO_DOCUMENTO, 
          TIPO_DOCUMENTO_ORIGEN, 
          NO_DOCUMENTO_ORIGEN, 
          MONTO, 
          USUARIO_CREACION, 
          FECHA_CREACION, 
          ID_DOCUMENTO_INV, 
          TIPO_DOCUMENTO_INV
          )
    VALUES
         (Pr_cpDocOrigen.compania, 
          Pr_cpDocOrigen.tipo_documento, 
          Pr_cpDocOrigen.no_documento, 
          Pr_cpDocOrigen.tipo_documento_origen, 
          Pr_cpDocOrigen.no_documento_origen, 
          Pr_cpDocOrigen.monto, 
          Pr_cpDocOrigen.usuario_creacion, 
          Pr_cpDocOrigen.fecha_creacion, 
          Pr_cpDocOrigen.id_documento_inv, 
          Pr_cpDocOrigen.tipo_documento_inv
          );
    --
  EXCEPTION
    WHEN OTHERS THEN
      Pv_MensajeError := SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'CPKG_TRANSACCION.P_INSERTA_DOCUMENTO_ORIGEN',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));

  END P_INSERTA_DOCUMENTO_ORIGEN;
  --
  --
  PROCEDURE P_REGISTRO_FACTURA ( Pt_DatosFactura IN NAF47_TNET.CPKG_TRANSACCION.Gt_DatosFactura,
                                 Pv_noDocumento  IN OUT VARCHAR2,
                                 Pv_MensajeError IN OUT VARCHAR2) IS
    --
    CURSOR C_DATOS_COMPANIA (Cv_NoCia VARCHAR2) IS
      SELECT A.CLASE_CAMBIO--, A.ANO_PROC,A.MES_PROC,ACEPTA_TERCERO,A.GENERA_DOC_ELECTRONICO,A.TIPO_GENERACION
      FROM NAF47_TNET.ARCPCT A--, NAF47_TNET.ARCGMC B
      WHERE A.NO_CIA = Cv_NoCia
         --AND A.NO_CIA = B.NO_CIA
         ;
    --
    CURSOR C_DATOS_TIPO_DOCUMENTO ( Cv_tipoDocumento VARCHAR2,
                                    Cv_noCia         VARCHAR2) IS
      SELECT COD_DIARIO
      FROM NAF47_TNET.ARCPTD TD
      WHERE TD.NO_CIA = Cv_noCia
      AND TD.TIPO_DOC = Cv_tipoDocumento;
    --
    CURSOR C_DATOS_PROVEEDOR ( Cv_noProveedor VARCHAR2,
                               Cv_noCia       VARCHAR2) IS
      SELECT MP.NO_PROVE,
             NVL(MP.PLAZO_C, 0) AS PLAZO_C,
             NVL(MP.PLAZO_P, 0) AS PLAZO_P,
             NVL(MP.DES_C, 0) AS DES_C,
             NVL(MP.DES_P, 0) AS DES_P,
             MP.CODIGO_TERCERO,
             MP.SUSTENTO_TRIBUTARIO_ID,
             (SELECT SSC.APLICA_C_TRIBUTARIO
	            FROM SRI_SUSTENTO_COMPROBANTE  SSC
	            WHERE SSC.CODIGO = MP.SUSTENTO_TRIBUTARIO_ID ) AS APLICA_C_TRIBUTARIO,
             GR.CUENTA_INVENTARIO
      FROM NAF47_TNET.ARCPGR GR,
           NAF47_TNET.ARCPMP MP
      WHERE MP.NO_CIA = Cv_noCia
      AND MP.NO_PROVE = Cv_noProveedor
      AND MP.GRUPO = GR.GRUPO
      AND MP.NO_CIA = GR.NO_CIA;
    --
    CURSOR C_TIPO_RETENCION (Cv_noCia VARCHAR2) IS
      SELECT A.TIPO_DOC
        FROM NAF47_TNET.ARCPTD A,
             NAF47_TNET.CONTROL_FORMU B
       WHERE A.FORMULARIO_CTRL = B.FORMULARIO
         AND A.NO_CIA = B.NO_CIA
         AND A.IND_ESTIMADO = NAF47_TNET.GEK_VAR.Gr_IndSimple.NO
         AND A.DOCUMENTO = 'R'
         AND B.ACTIVO = NAF47_TNET.GEK_VAR.Gr_IndSimple.SI
         AND NAF47_TNET.CPLIB.ESANULACIONSN(A.NO_CIA, A.TIPO_DOC) <> 'S'
         AND A.COMPROBANTE_ELECTRONICO = NAF47_TNET.GEK_VAR.Gr_IndSimple.SI
         AND A.NO_CIA = Cv_noCia;
    --
    CURSOR C_IVA_BIENES (Cv_noCia VARCHAR2) IS
      SELECT CLAVE,
             PORCENTAJE
      FROM NAF47_TNET.ARCGIMP
      WHERE NO_CIA = Cv_noCia
      AND IND_APLICA_COMPRAS = 'S' 
      AND IND_RETENCION = 'N'
      AND AFECTA != 'V' 
      AND NVL(PRINCIPAL,'N') = 'S';
    --
    CURSOR C_IVA_SERVICIOS (Cv_noCia VARCHAR2) IS
      SELECT CLAVE,
             PORCENTAJE
      FROM NAF47_TNET.ARCGIMP
      WHERE NO_CIA = Cv_noCia
      AND IND_APLICA_SERVICIOS = 'S'
      AND IND_RETENCION = 'N'
      AND AFECTA != 'V' 
      AND NVL(PRINCIPAL,'N') = 'S';
    --
    CURSOR C_RETENCIONES ( Cv_noProveedor VARCHAR2,
                           Cv_noCia       VARCHAR2) IS
      SELECT APR.TIPO_FACTURA,
             APR.RETENCION_ID,
             IMP.PORCENTAJE,
             IMP.RETENCION_IVA,
             IMP.RETENCION_FUENTE,
             IMP.SRI_COD_RETIVA_BIEN,
             IMP.SRI_COD_RETIVA_SERV,
             IMP.SRI_RETIMP_RENTA
      FROM NAF47_TNET.ARCGIMP IMP,
           NAF47_TNET.ARCP_PROVEEDOR_RETENCION APR
      WHERE APR.NO_CIA = Cv_noCia
      AND APR.PROVEEDOR_ID = Cv_noProveedor
      AND APR.ESTADO = Gek_Var.Gr_Estado.ACTIVO
      AND APR.RETENCION_ID = IMP.CLAVE
      AND APR.NO_CIA = IMP.NO_CIA;
    --
    CURSOR C_IMPUESTOS_CONTABILIZA ( Cv_noDocu VARCHAR2,
                                     Cv_noCia  VARCHAR2 ) IS
      SELECT TI.NO_CIA,
             TI.CLAVE,
             TI.MONTO,
             TD.TIPO_MOV,
             TI.APLICA_CRED_FISCAL,
             TI.IND_IMP_RET,
             TI.ID_SEC,
             IMP.CUENTA,
             IMP.CUENTA_ALTERNA,
             IMP.SECTORIZABLE
      FROM NAF47_TNET.ARCGIMP IMP,
           NAF47_TNET.ARCPTD TD,
           NAF47_TNET.ARCPTI TI
      WHERE TI.NO_CIA = Cv_noCia
      AND TI.NO_DOCU = Cv_noDocu
      AND TI.CLAVE = IMP.CLAVE
      AND TI.NO_CIA = IMP.NO_CIA
      AND TI.TIPO_DOC = TD.TIPO_DOC
      AND TI.NO_CIA = TD.NO_CIA;
    --
    CURSOR C_IMPUESTO_SECTORIAL ( Pv_idSec VARCHAR2,
                                  Pv_Clave VARCHAR2,
                                  Pv_noCia VARCHAR2 ) IS
      SELECT CUENTA_CONTABLE
      FROM NAF47_TNET.ARCGDISEC
      WHERE NO_CIA = Pv_noCia
      AND CLAVE  = Pv_Clave
      AND ID_SEC = Pv_idSec;
    --
    CURSOR C_DATOS_ORDEN_COMPRA ( Cv_noDocumento VARCHAR2,
                                  Cv_noCia       VARCHAR2) IS
      SELECT MD.NO_CIA,
             MD.NO_DOCU,
             EE.NO_ORDEN,
             EE.TIPO_DISTRIBUCION_COSTO,
             EE.ID_DOCUMENTO_DISTRIBUCION,
             DO.MONTO
      FROM NAF47_TNET.TAPORDEE EE,
           NAF47_TNET.ARCPMD MD,
           NAF47_TNET.CP_DOCUMENTO_ORIGEN DO
      WHERE DO.COMPANIA = Cv_noCia
      AND DO.NO_DOCUMENTO = Cv_noDocumento
      AND DO.NO_DOCUMENTO_ORIGEN = EE.NO_ORDEN
      AND DO.COMPANIA = EE.NO_CIA
      AND DO.NO_DOCUMENTO = MD.NO_DOCU
      AND DO.COMPANIA = MD.NO_CIA;
    --
    CURSOR C_ORDEN_COMPRA_DETALLE (Cv_NoOrden VARCHAR2,
                                   Cv_noCia   VARCHAR2) IS
      SELECT ED.NO_ORDEN,
             ED.NO_CIA,
             ED.NO_LINEA,
             PS.ID_CUENTA_CONTABLE,
             ((ED.CANTIDAD * ED.COSTO_UNI) - ROUND(((ED.CANTIDAD * ED.COSTO_UNI) * (NVL(ED.DESCUENTO,0) / 100)),2)) / (EE.MONTO - NVL(EE.DESCUENTO,0)) AS PORCENTAJE_BASE_IMPONIBLE
      FROM NAF47_TNET.TAPCPS PS,
           NAF47_TNET.TAPORDEE EE,
           NAF47_TNET.TAPORDED ED
      WHERE ED.NO_CIA = Cv_noCia
      AND ED.NO_ORDEN = Cv_NoOrden
      AND ED.CODIGO_NI = PS.CODIGO
      AND ED.NO_CIA = PS.NO_CIA
      AND ED.NO_ORDEN = EE.NO_ORDEN
      AND ED.NO_CIA = EE.NO_CIA;
    --
    CURSOR C_ORDEN_COMPRA_PROYECTO ( Cv_NoOrden VARCHAR2,
                                     Cv_noCia   VARCHAR2) IS
      SELECT D.TIPO_CCOSTO_ID,
             D.TIPO_CCOSTO_DESCRIPCION,
             D.REFERENCIA_ID,
             D.NO_CIA,
             OC.TOTAL,
             D.MONTO DISTRIBUCION_OC,
             D.MONTO/OC.TOTAL AS PORCENTAJE,
             (OC.TOTAL-NVL(OC.IMP_VENTAS,0))/OC.TOTAL AS PORCENTAJE_BASE
      FROM NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION D,
           NAF47_TNET.TAPORDEE OC
      WHERE OC.TIPO_DISTRIBUCION_COSTO = 'Proyecto'
      AND OC.NO_ORDEN = Cv_NoOrden
      AND OC.NO_CIA = Cv_noCia
      AND OC.ID_DOCUMENTO_DISTRIBUCION = D.NO_DOCU
      AND OC.NO_CIA = D.NO_CIA;
    --
    CURSOR C_DATOS_INGRESO_BODEGA ( Cv_noDocumento VARCHAR2,
                                    Cv_noCia       VARCHAR2) IS
      SELECT SUM(DO.MONTO) AS MONTO
      FROM NAF47_TNET.ARINME ME,
           NAF47_TNET.ARCPMD MD,
           NAF47_TNET.CP_DOCUMENTO_ORIGEN DO
      WHERE DO.COMPANIA = Cv_noCia
      AND DO.NO_DOCUMENTO = Cv_noDocumento
      AND DO.NO_DOCUMENTO_ORIGEN = ME.NO_DOCU
      AND DO.COMPANIA = ME.NO_CIA
      AND DO.NO_DOCUMENTO = MD.NO_DOCU
      AND DO.COMPANIA = MD.NO_CIA
      HAVING SUM(DO.MONTO) > 0;
    --
    Lr_datosCia                C_DATOS_COMPANIA%ROWTYPE;
    Lr_datosTipoDoc            C_DATOS_TIPO_DOCUMENTO%ROWTYPE;
    Lr_tipoRetencion           C_TIPO_RETENCION%ROWTYPE;
    Lr_datosProveedor          C_DATOS_PROVEEDOR%ROWTYPE;
    Lr_DatosImpuesto           C_IVA_BIENES%ROWTYPE;
    Lr_Retencion               C_RETENCIONES%ROWTYPE;
    Lr_CtaCtbleProv            NAF47_TNET.CPLIB.CUENTAS_CONTABLES_R;
    Lr_Arcpmd                  NAF47_TNET.ARCPMD%ROWTYPE;
    Lr_Arcpti                  NAF47_TNET.ARCPTI%ROWTYPE;
    Lr_Arcpdc                  NAF47_TNET.ARCPDC%ROWTYPE;
    Lr_cpDocOrigen             NAF47_TNET.CP_DOCUMENTO_ORIGEN%ROWTYPE;
    Ld_fechaTipoCambio         DATE;
    Ln_IvaBienes               NAF47_TNET.ARCGIMP.PORCENTAJE%TYPE;
    Ln_IvaServicios            NAF47_TNET.ARCGIMP.PORCENTAJE%TYPE;
    Ln_factorP                 NAF47_TNET.ARCPDC.TIPO_CAMBIO%TYPE;
    Ln_factorD                 NAF47_TNET.ARCPDC.TIPO_CAMBIO%TYPE;
    Ln_CantidadDistribuir      NUMBER(9) := 0;
    Ln_SaldoDistribuir         NUMBER(12,2) := 0;
    Ln_MontoIndividual         NUMBER := 0;
    Ln_Porcentaje_Orden_Compra NUMBER := 0;
    Ln_DetalleDistribId        NAF47_TNET.PR_DOCUMENTO_DISTRIBUCION.DETALLE_DISTRIBUCION_ID%TYPE; 
    Lt_DetCentroCostos         NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DistribContable := NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.Gt_DistribContable();
    --
    Le_Error                   EXCEPTION;
    --
  BEGIN  
    --
    FOR Li_Idx IN Pt_DatosFactura.FIRST .. Pt_DatosFactura.LAST LOOP
      --
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'SEGUIMIENTO GENERA FACTURA',
                                           'Pt_DatosFactura('||Li_Idx||').NO_CIA: '||Pt_DatosFactura(Li_Idx).NO_CIA||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').TIPO_DOCUMENTO_ID: '||Pt_DatosFactura(Li_Idx).TIPO_DOCUMENTO_ID||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').NO_PROVEEDOR: '||Pt_DatosFactura(Li_Idx).NO_PROVEEDOR||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').TIPO_FACTURA: '||Pt_DatosFactura(Li_Idx).TIPO_FACTURA||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').ES_DOC_ELECTRONICO: '||Pt_DatosFactura(Li_Idx).ES_DOC_ELECTRONICO||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').FECHA_DOCUMENTO: '||Pt_DatosFactura(Li_Idx).FECHA_DOCUMENTO||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').FECHA_REGISTRO: '||Pt_DatosFactura(Li_Idx).FECHA_REGISTRO||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').NO_FISICO: '||Pt_DatosFactura(Li_Idx).NO_FISICO||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').SERIE_FISICO: '||Pt_DatosFactura(Li_Idx).SERIE_FISICO||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').NO_AUTORIZACION: '||Pt_DatosFactura(Li_Idx).NO_AUTORIZACION||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').FECHA_CADUCIDAD: '||Pt_DatosFactura(Li_Idx).FECHA_CADUCIDAD||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').DETALLE: '||Pt_DatosFactura(Li_Idx).DETALLE||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').GRAVA_IMPUESTO_BIENES: '||Pt_DatosFactura(Li_Idx).GRAVA_IMPUESTO_BIENES||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').GRAVA_IMPUESTO_SERVICIO: '||Pt_DatosFactura(Li_Idx).GRAVA_IMPUESTO_SERVICIO||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').BASE_CERO_BIENES: '||Pt_DatosFactura(Li_Idx).BASE_CERO_BIENES||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').BASE_CERO_SERVICIOS: '||Pt_DatosFactura(Li_Idx).BASE_CERO_SERVICIOS||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').NO_ORDEN: '||Pt_DatosFactura(Li_Idx).NO_ORDEN||CHR(10)||
                                           'Pt_DatosFactura('||Li_Idx||').MONTO: '||Pt_DatosFactura(Li_Idx).MONTO
                                           ,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));      
      --
      -- primera interacci�n se genera registro en arcpmd
      IF Lr_Arcpmd.No_Docu IS NULL THEN
        --
        IF C_DATOS_COMPANIA%ISOPEN THEN
          CLOSE C_DATOS_COMPANIA;
        END IF;
        OPEN C_DATOS_COMPANIA(Pt_DatosFactura(Li_Idx).NO_CIA);
        FETCH C_DATOS_COMPANIA INTO Lr_DatosCia;
        CLOSE C_DATOS_COMPANIA;
        --
        Lr_Arcpmd.No_Cia := Pt_DatosFactura(Li_Idx).NO_CIA;
        Lr_Arcpmd.No_Prove := Pt_DatosFactura(Li_Idx).NO_PROVEEDOR;
        Lr_Arcpmd.Tipo_Doc := Pt_DatosFactura(Li_Idx).TIPO_DOCUMENTO_ID;
        Lr_Arcpmd.No_Fisico := Pt_DatosFactura(Li_Idx).NO_FISICO;
        Lr_Arcpmd.Serie_Fisico := Pt_DatosFactura(Li_Idx).SERIE_FISICO;
        Lr_Arcpmd.Fecha := Pt_DatosFactura(Li_Idx).FECHA_REGISTRO;
        Lr_Arcpmd.Fecha_Documento := Pt_DatosFactura(Li_Idx).FECHA_DOCUMENTO;
        Lr_Arcpmd.No_Autorizacion := Pt_DatosFactura(Li_Idx).NO_AUTORIZACION;
        Lr_Arcpmd.Detalle := Pt_DatosFactura(Li_Idx).DETALLE;
        Lr_Arcpmd.Monto_Bienes := Pt_DatosFactura(Li_Idx).GRAVA_IMPUESTO_BIENES;
        Lr_Arcpmd.Monto_Serv := Pt_DatosFactura(Li_Idx).GRAVA_IMPUESTO_SERVICIO;
        Lr_Arcpmd.Gravado := Lr_Arcpmd.Monto_Bienes + Lr_Arcpmd.Monto_Serv;
        Lr_Arcpmd.Excento_Bienes := Pt_DatosFactura(Li_Idx).BASE_CERO_BIENES;
        Lr_Arcpmd.Excento_Serv := Pt_DatosFactura(Li_Idx).BASE_CERO_SERVICIOS;
        Lr_Arcpmd.Excentos := Lr_Arcpmd.Excento_Bienes + Lr_Arcpmd.Excento_Serv;
        Lr_Arcpmd.Subtotal := Lr_Arcpmd.Gravado + Lr_Arcpmd.Excentos;
        Lr_Arcpmd.Ind_Doc_Electronico := Pt_DatosFactura(Li_Idx).ES_DOC_ELECTRONICO;
        Lr_Arcpmd.Fecha_Caducidad := Pt_DatosFactura(Li_Idx).FECHA_CADUCIDAD;
        Lr_Arcpmd.Tot_Imp := 0;
        Lr_Arcpmd.Tot_Ret := 0;
        Lr_Arcpmd.Monto := 0;
        Lr_Arcpmd.Saldo := 0;
        Lr_Arcpmd.Monto_Nominal := 0;
        Lr_Arcpmd.Saldo_Nominal := 0;
        Lr_Arcpmd.Tot_Db := 0;
        Lr_Arcpmd.Tot_Cr := 0;
        Lr_Arcpmd.Ind_Act := 'P';
        Lr_Arcpmd.Estado_Sri := 'P';
        Lr_Arcpmd.Moneda := 'P';
        Lr_Arcpmd.t_Camb_c_v := 'V';
        Lr_Arcpmd.Origen := 'CP';
        Lr_Arcpmd.Bloqueado := 'N';
        Lr_Arcpmd.Ind_Otromov := 'N';
        Lr_Arcpmd.Tot_Imp_Especial := 0;
        Lr_Arcpmd.Tot_Ret_Especial := 0;
        Lr_Arcpmd.Usuario := USER;
        Lr_Arcpmd.Factura_Eventual := 'N';
        Lr_Arcpmd.Anulado := 'N';
        Lr_Arcpmd.Tipo_Cambio := NAF47_TNET.TIPO_CAMBIO (Lr_DatosCia.Clase_Cambio,
                                                         Lr_Arcpmd.Fecha_Documento,
                                                         Ld_fechaTipoCambio,
                                                         Lr_Arcpmd.t_Camb_c_v);
        --
        CASE Pt_DatosFactura(Li_Idx).TIPO_FACTURA
          WHEN 'BIENES' THEN
            Lr_Arcpmd.Tipo_Compra := 'B';
          WHEN 'SERVICIOS' THEN
            Lr_Arcpmd.Tipo_Compra := 'S';
          ELSE
            Lr_Arcpmd.Tipo_Compra := 'V';
        END CASE;
        --
        IF C_DATOS_TIPO_DOCUMENTO%ISOPEN THEN
          CLOSE C_DATOS_TIPO_DOCUMENTO;
        END IF;
        OPEN C_DATOS_TIPO_DOCUMENTO(Lr_Arcpmd.Tipo_Doc, Lr_Arcpmd.No_Cia);
        FETCH C_DATOS_TIPO_DOCUMENTO INTO Lr_datosTipoDoc;
        CLOSE C_DATOS_TIPO_DOCUMENTO;
        --
        IF Lr_datosTipoDoc.Cod_Diario IS NULL THEN
          Pv_MensajeError := 'No se ha definido c�digo de diario para el tipo documento: '||Lr_Arcpmd.Tipo_Doc;
          RAISE Le_Error;
        END IF;
        --
        Lr_Arcpmd.Cod_Diario := Lr_datosTipoDoc.Cod_Diario;
        --
        IF C_DATOS_PROVEEDOR%ISOPEN THEN
          CLOSE C_DATOS_PROVEEDOR;
        END IF;
        OPEN C_DATOS_PROVEEDOR(Lr_Arcpmd.No_Prove, Lr_Arcpmd.No_Cia);
        FETCH C_DATOS_PROVEEDOR INTO Lr_datosProveedor;
        CLOSE C_DATOS_PROVEEDOR;
        --
        IF Lr_datosProveedor.No_Prove IS NULL THEN
          Pv_MensajeError := 'No se encontr� c�digo de proveedor: '||Lr_Arcpmd.No_Prove;
          RAISE Le_Error;
        END IF;
        --
        Lr_Arcpmd.Desc_c := Lr_datosProveedor.Des_c;
        Lr_Arcpmd.Desc_p := Lr_datosProveedor.Des_p;
        Lr_Arcpmd.Plazo_c := Lr_datosProveedor.Plazo_c;
        Lr_Arcpmd.Plazo_p := Lr_datosProveedor.Plazo_p;
        Lr_Arcpmd.Fecha_Vence := Lr_Arcpmd.Fecha_Documento + Lr_Arcpmd.Plazo_c;
        Lr_Arcpmd.Fecha_Vence_Original := Lr_Arcpmd.Fecha_Vence;
        Lr_Arcpmd.Codigo_Sustento := Lr_datosProveedor.Sustento_Tributario_Id;
        --
        IF C_TIPO_RETENCION%ISOPEN THEN
          CLOSE C_TIPO_RETENCION;
        END IF;
        OPEN C_TIPO_RETENCION(Lr_Arcpmd.No_Cia);
        FETCH C_TIPO_RETENCION INTO Lr_tipoRetencion;
        CLOSE C_TIPO_RETENCION;
        --
        IF Lr_tipoRetencion.Tipo_Doc IS NULL THEN
          Pv_MensajeError := 'No se ha definido tipo retenci�n electr�nica para empresa: '||Lr_Arcpmd.No_Cia;
          RAISE Le_Error;
        END IF;
        --
        Lr_Arcpmd.Tipo_Ret := Lr_tipoRetencion.Tipo_Doc;
        --
        Lr_Arcpmd.No_Docu := NAF47_TNET.TRANSA_ID.CP(Lr_Arcpmd.No_Cia);
        --
        P_INSERTA_ARCPMD (Lr_Arcpmd, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      END IF;
      -----------------------------------
      -- Registro de documentos origen --
      -----------------------------------
      Lr_cpDocOrigen := NULL;
      --
      Lr_cpDocOrigen.compania := Lr_Arcpmd.No_Cia;
      Lr_cpDocOrigen.tipo_documento := Lr_Arcpmd.Tipo_Doc;
      Lr_cpDocOrigen.no_documento := Lr_Arcpmd.No_Docu;
      Lr_cpDocOrigen.monto := Pt_DatosFactura(Li_Idx).MONTO;
      Lr_cpDocOrigen.usuario_creacion := USER;
      Lr_cpDocOrigen.fecha_creacion := SYSDATE;
      --
      IF Pt_DatosFactura(Li_Idx).NO_ORDEN IS NOT NULL THEN
        Lr_cpDocOrigen.no_documento_origen := Pt_DatosFactura(Li_Idx).NO_ORDEN;
        Lr_cpDocOrigen.tipo_documento_origen := 'CO';
      ELSE
        Lr_cpDocOrigen.no_documento_origen := Pt_DatosFactura(Li_Idx).NO_INGRESO_BODEGA;
        Lr_cpDocOrigen.tipo_documento_origen := Pt_DatosFactura(Li_Idx).TIPO_INGRESO_BODEGA;
      END IF;
      --
      P_INSERTA_DOCUMENTO_ORIGEN (Lr_cpDocOrigen, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;
    --------------------------------------
    -- Generaci�n de registro impuestos --
    --------------------------------------
    Lr_Arcpti.no_cia := Lr_Arcpmd.No_Cia;
    Lr_Arcpti.no_prove := Lr_Arcpmd.No_Prove;
    Lr_Arcpti.tipo_doc := Lr_Arcpmd.Tipo_Doc;
    Lr_Arcpti.no_docu := Lr_Arcpmd.No_Docu;
    Lr_Arcpti.ind_imp_ret := 'I';
    Lr_Arcpti.aplica_cred_fiscal := Lr_datosProveedor.Aplica_c_Tributario; 
    Lr_Arcpti.no_refe := Lr_Arcpmd.No_Docu;
    Lr_Arcpti.Codigo_Tercero := Lr_datosProveedor.Codigo_Tercero;
    --
    IF Lr_Arcpmd.Monto_Bienes > 0 THEN
      --
      IF C_IVA_BIENES%ISOPEN THEN
        CLOSE C_IVA_BIENES;
      END IF;
      OPEN C_IVA_BIENES(Lr_Arcpti.no_cia);
      FETCH C_IVA_BIENES INTO Lr_DatosImpuesto;
      CLOSE C_IVA_BIENES;
      --
      IF Lr_DatosImpuesto.Clave IS NOT NULL THEN
        Lr_Arcpti.clave := Lr_DatosImpuesto.Clave;
        Lr_Arcpti.base := Lr_Arcpmd.Monto_Bienes;
        Lr_Arcpti.porcentaje := Lr_DatosImpuesto.Porcentaje;
        Lr_Arcpti.monto := ROUND((Lr_Arcpti.base * (Lr_Arcpti.porcentaje/100)),2);
        Lr_Arcpti.Comportamiento := Impuesto.Comportamiento(Lr_Arcpti.no_cia, Lr_Arcpti.clave);
        Ln_IvaBienes := Lr_DatosImpuesto.Porcentaje;
        Lr_Arcpmd.Tot_Imp := NVL(Lr_Arcpmd.Tot_Imp,0) + Lr_Arcpti.monto;
        --
        P_INSERTA_ARCPTI(Lr_Arcpti, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END IF;
      --
    END IF;
    --
    IF Lr_Arcpmd.Monto_Serv > 0 THEN
      --
      Lr_DatosImpuesto := NULL;
      --
      IF C_IVA_SERVICIOS%ISOPEN THEN
        CLOSE C_IVA_SERVICIOS;
      END IF;
      OPEN C_IVA_SERVICIOS(Lr_Arcpti.no_cia);
      FETCH C_IVA_SERVICIOS INTO Lr_DatosImpuesto;
      CLOSE C_IVA_SERVICIOS;
      --
      IF Lr_DatosImpuesto.Clave IS NOT NULL THEN
        Lr_Arcpti.clave := Lr_DatosImpuesto.Clave;
        Lr_Arcpti.base := Lr_Arcpmd.Monto_Serv;
        Lr_Arcpti.porcentaje := Lr_DatosImpuesto.Porcentaje;
        Lr_Arcpti.monto := ROUND((Lr_Arcpti.base * (Lr_Arcpti.porcentaje/100)),2);
        Lr_Arcpti.Comportamiento := Impuesto.Comportamiento(Lr_Arcpti.no_cia, Lr_Arcpti.clave);
        Ln_IvaServicios := Lr_DatosImpuesto.Porcentaje;
        Lr_Arcpmd.Tot_Imp := NVL(Lr_Arcpmd.Tot_Imp,0) + Lr_Arcpti.monto;
        --
        P_INSERTA_ARCPTI(Lr_Arcpti, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
      END IF;
      --
    END IF;
    -------------------------------
    -- Generaci�n de Retenciones --
    -------------------------------
    Lr_Arcpti.ind_imp_ret := 'R';
    Lr_Arcpti.aplica_cred_fiscal := 'N';
    --
    FOR Lr_Retencion IN C_RETENCIONES (Lr_Arcpti.No_Prove, Lr_Arcpti.No_Cia) LOOP
      --
      Lr_Arcpti.Clave := Lr_Retencion.Retencion_Id;
      Lr_Arcpti.Porcentaje := Lr_Retencion.Porcentaje;
      Lr_Arcpti.Base := 0;
      Lr_Arcpti.Monto := 0;
      --
      CASE
        WHEN Lr_Retencion.TIPO_FACTURA = 'SERVICIOS' AND 
             Lr_Retencion.Retencion_Iva = 'S' AND 
             Lr_Arcpmd.Monto_Serv > 0 THEN
          --
          Lr_Arcpti.Sri_Retimp_Renta := Lr_Retencion.Sri_Cod_Retiva_Serv;
          Lr_Arcpti.Base := ROUND((Lr_Arcpmd.Monto_Serv * (Ln_IvaServicios/100)),2);
          --
        WHEN Lr_Retencion.TIPO_FACTURA = 'BIENES' AND 
             Lr_Retencion.Retencion_Iva = 'S' AND 
             Lr_Arcpmd.Monto_Bienes > 0 THEN
          --
          Lr_Arcpti.Sri_Retimp_Renta := Lr_Retencion.Sri_Cod_Retiva_Bien;
          Lr_Arcpti.Base := ROUND((Lr_Arcpmd.Monto_Bienes * (Ln_IvaBienes/100)),2);
          --
        WHEN Lr_Retencion.TIPO_FACTURA = 'SERVICIOS' AND 
             Lr_Retencion.Retencion_Fuente = 'S' AND 
             ( Lr_Arcpmd.Excento_Serv > 0 OR Lr_Arcpmd.Monto_Serv > 0) THEN
          --
          Lr_Arcpti.Sri_Retimp_Renta := Lr_Retencion.Sri_Retimp_Renta;
          Lr_Arcpti.Base := Lr_Arcpmd.Excento_Serv + Lr_Arcpmd.Monto_Serv;
          Lr_Arcpti.Servicio_Bienes := 'S';
          --
        WHEN Lr_Retencion.TIPO_FACTURA = 'BIENES' AND 
             Lr_Retencion.Retencion_Fuente = 'S' AND 
             (Lr_Arcpmd.Excento_Bienes > 0 OR Lr_Arcpmd.Monto_Bienes > 0) THEN
          --
          Lr_Arcpti.Sri_Retimp_Renta := Lr_Retencion.Sri_Retimp_Renta;
          Lr_Arcpti.Base := Lr_Arcpmd.Excento_Bienes + Lr_Arcpmd.Monto_Bienes;
          Lr_Arcpti.Servicio_Bienes := 'B';
          --
        ELSE
          /*
          Pv_MensajeError := 'Lr_Retencion.TIPO_FACTURA: '||Lr_Retencion.TIPO_FACTURA||
                             ', Lr_Retencion.Retencion_Iva: '||Lr_Retencion.Retencion_Iva||
                             ', Lr_Arcpmd.Monto_Serv: '||Lr_Arcpmd.Monto_Serv||
                             ', Lr_Arcpmd.Monto_Bienes: '||Lr_Arcpmd.Monto_Bienes||
                             ', Lr_Retencion.Retencion_Fuente: '||Lr_Retencion.Retencion_Fuente||
                             ', Lr_Arcpmd.Excento_Serv: '||Lr_Arcpmd.Excento_Serv||
                             ', Lr_Arcpmd.Excento_Bienes: '||Lr_Arcpmd.Excento_Bienes||
                             ' Tipo de retenci�n y montos no definidos, favor revisar!!!';
          RAISE Le_Error;
          */
          Lr_Arcpti.Base := 0;
      END CASE;
      --
      Lr_Arcpti.monto := ROUND((Lr_Arcpti.base * (Lr_Arcpti.porcentaje/100)),2);
      Lr_Arcpti.Comportamiento := naf47_tnet.Impuesto.Comportamiento(Lr_Arcpti.no_cia, 
                                                                     Lr_Arcpti.clave);
      Lr_Arcpti.Id_Sec := naf47_tnet.cpsector_impuesto(Lr_Arcpti.no_cia, 
                                                       Lr_Arcpti.no_prove,
                                                       Lr_Arcpti.clave,
                                                       Pv_MensajeError); 
      IF Pv_MensajeError IS NOT NULL THEN
        Raise Le_Error;
      END IF;
      --
      Lr_Arcpmd.Tot_Ret := NVL(Lr_Arcpmd.Tot_Ret,0) + Lr_Arcpti.monto;
      -- si existe valor calculado, se inserta.
      IF Lr_Arcpti.Monto > 0 THEN
        --
        P_INSERTA_ARCPTI(Lr_Arcpti, Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
      END IF;
      --
    END LOOP;
    --
    -- Actualizaci�n de montos
    Lr_Arcpmd.Monto := Lr_Arcpmd.Subtotal + Lr_Arcpmd.Tot_Imp - Lr_Arcpmd.Tot_Ret;
    Lr_Arcpmd.Saldo := Lr_Arcpmd.Monto;
    Lr_Arcpmd.Monto_Nominal := Lr_Arcpmd.Subtotal + Lr_Arcpmd.Tot_Imp - Lr_Arcpmd.Tot_Ret;
    Lr_Arcpmd.Saldo_Nominal := Lr_Arcpmd.Monto_Nominal;
    --
    ---------------------------
    -- DISTRIBUCION CONTABLE --
    ---------------------------
    --
    Lr_Arcpdc.no_cia := Lr_Arcpmd.no_cia;
    Lr_Arcpdc.no_prove := Lr_Arcpmd.no_prove;
    Lr_Arcpdc.tipo_doc := Lr_Arcpmd.tipo_doc;
    Lr_Arcpdc.no_docu := Lr_Arcpmd.no_docu;
    Lr_Arcpdc.tipo := 'C';
    Lr_Arcpdc.mes := TO_NUMBER(TO_CHAR(Lr_Arcpmd.fecha,'MM'));
    Lr_Arcpdc.ano := TO_NUMBER(TO_CHAR(Lr_Arcpmd.fecha,'YYYY'));
    Lr_Arcpdc.ind_con := 'P';
    Lr_Arcpdc.moneda := Lr_Arcpmd.Moneda;
    --JXZURITA-AUMENTO CAMPO GLOSA INICIO
    --Lr_Arcpdc.glosa := SUBSTR(Lr_Arcpmd.detalle,1,100);
    Lr_Arcpdc.glosa := SUBSTR(Lr_Arcpmd.detalle,1,F_TAM_GLOSA_CONT(Lr_Arcpmd.no_cia,'AG_CPKGTRANSACION',100));
    --JXZURITA-AUMENTO CAMPO GLOSA FIN
    ---------------------------------------
    -- Detalle contable Cuenta proveedor --
    ---------------------------------------
    IF NOT NAF47_TNET.CPLIB.TRAE_CUENTAS_CONTA(Lr_Arcpmd.no_cia, 
                                               Lr_Arcpmd.no_prove, 
                                               Lr_Arcpmd.tipo_doc, 
                                               Lr_Arcpmd.moneda, 
                                               Lr_CtaCtbleProv ) THEN
       Pv_MensajeError := 'No existe la cuenta de proveedor, documento tipo: '||Lr_Arcpmd.tipo_doc||
                          ' para movimientos en moneda '||NAF47_TNET.MONEDA.NOMBRE(Lr_Arcpmd.no_cia, Lr_Arcpmd.moneda);  
       RAISE Le_Error;
    END IF;
    --
    IF Lr_Arcpmd.moneda = 'P' THEN
      Lr_Arcpdc.codigo := Lr_CtaCtbleProv.cta_prove;
      Ln_factorP := Lr_Arcpmd.tipo_cambio;
      Ln_factorD := 1;
    ELSE
      Lr_Arcpdc.codigo := Lr_CtaCtbleProv.cta_prove_dol;
      Ln_factorD := Lr_Arcpmd.tipo_cambio;
      Ln_factorP := 1;
    END IF;
    --
    Lr_Arcpdc.centro_costo := NAF47_TNET.CENTRO_COSTO.RELLENAD(Lr_Arcpdc.no_cia, '0');
    Lr_Arcpdc.modificable := 'N';
    --
    IF NAF47_TNET.CUENTA_CONTABLE.ACEPTA_TERCERO (Lr_Arcpdc.no_cia, Lr_Arcpdc.codigo) THEN
      Lr_Arcpdc.codigo_tercero := Lr_DatosProveedor.codigo_tercero;
    ELSE
      Lr_Arcpdc.codigo_tercero := NULL;
    END IF; 
    --
    Lr_Arcpdc.monto_dc := Lr_Arcpmd.monto;
    Lr_Arcpdc.tipo_cambio := Lr_Arcpmd.tipo_cambio;
    --
    Lr_Arcpdc.monto := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc * Ln_factorP), 'P');
    Lr_Arcpdc.monto_dol := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc / Ln_factorD), 'D');
    --
    P_INSERTA_ARCPDC (Lr_Arcpdc, Pv_MensajeError);
    --
    IF Pv_MensajeError IS NOT NULL THEN
      RAISE Le_Error;
    END IF;
    --
    --
    -----------------------------------------------------------------
    -- Detalle contable por c�digo de Bienes en Ingresos a Bodegas --
    -----------------------------------------------------------------
    Lr_Arcpdc.tipo := 'D';
    --
    FOR Lr_DatosIngresoBodega IN C_DATOS_INGRESO_BODEGA (Lr_Arcpmd.No_Docu, Lr_Arcpmd.No_Cia) LOOP
      --
      Lr_Arcpdc.codigo := Lr_DatosProveedor.Cuenta_Inventario;
      --
      IF NAF47_TNET.CUENTA_CONTABLE.ACEPTA_TERCERO (Lr_Arcpdc.no_cia, Lr_Arcpdc.codigo) THEN
        Lr_Arcpdc.codigo_tercero := Lr_DatosProveedor.codigo_tercero;
      ELSE
        Lr_Arcpdc.codigo_tercero := NULL;
      END IF; 
      --
      Lr_Arcpdc.monto_dc := Lr_DatosIngresoBodega.monto;
      Lr_Arcpdc.tipo_cambio := Lr_Arcpmd.tipo_cambio;
      --
      Lr_Arcpdc.monto := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc * Ln_factorP), 'P');
      Lr_Arcpdc.monto_dol := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc / Ln_factorD), 'D');
      --
      P_INSERTA_ARCPDC (Lr_Arcpdc, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;

    -----------------------------
    -- retenciones e impuestos --
    -----------------------------
    FOR Lr_Impuesto IN C_IMPUESTOS_CONTABILIZA (Lr_Arcpmd.No_Docu, Lr_Arcpmd.No_Cia) LOOP
      --
      -- la cuenta contable para impuestos IVA se asigna de acuerdo al credito fiscal, impuesto sectorial
      IF Lr_Impuesto.Ind_Imp_Ret = 'I' THEN 
        
        IF NVL(Lr_Impuesto.Aplica_Cred_Fiscal,'N') = 'N' THEN
          Lr_Arcpdc.Codigo := Lr_Impuesto.Cuenta_Alterna;
        ELSIF NVL(Lr_Impuesto.Sectorizable,'N') = 'N' THEN
          Lr_Arcpdc.Codigo := Lr_Impuesto.Cuenta;
        ELSIF NVL(Lr_Impuesto.Sectorizable,'N') = 'S' AND Lr_Impuesto.Id_Sec IS NOT NULL THEN
          --
          IF C_IMPUESTO_SECTORIAL%ISOPEN THEN
            CLOSE C_IMPUESTO_SECTORIAL;
          END IF;
          OPEN C_IMPUESTO_SECTORIAL(Lr_Impuesto.Id_Sec, Lr_Impuesto.Clave, Lr_Impuesto.No_Cia);
          FETCH C_IMPUESTO_SECTORIAL INTO Lr_Arcpdc.Codigo;
          CLOSE C_IMPUESTO_SECTORIAL;
          --
        ELSE
          Pv_MensajeError := 'No se han registrado datos para la sectorizacion: '||Lr_Impuesto.Id_Sec;
          RAISE Le_Error;
        END IF;
        --
        -- proceso genera factura por defecto los impuestos se asignan al d�bito
        Lr_Arcpdc.Tipo := 'D';
        --
      ELSIF Lr_Impuesto.Ind_Imp_Ret = 'R' THEN 
        --
        --proceso genera factura por defecto las retenciones se asignan al cr�dito
        Lr_Arcpdc.Codigo := Lr_Impuesto.Cuenta;
        Lr_Arcpdc.Tipo := 'C';
        --
      END IF;
      --
      -- se valida que recupere cuenta contable
      IF Lr_Arcpdc.Codigo IS NULL THEN
        Pv_MensajeError := 'No se encontr� cuenta contable para impuesto: '||Lr_Impuesto.Clave;
        RAISE Le_Error;
      END IF;
      --
      -- se asigna centro de costo 000-000-000
      Lr_Arcpdc.Centro_Costo := NAF47_TNET.CENTRO_COSTO.RELLENAD(Lr_Arcpdc.no_cia, '0');
      -- si la cuenta contable maneja tercero se asigna de acuerdo al codigo registrado en el proveedor.
      IF NAF47_TNET.CUENTA_CONTABLE.ACEPTA_TERCERO (Lr_Arcpdc.no_cia, Lr_Arcpdc.codigo) THEN
        Lr_Arcpdc.codigo_tercero := Lr_DatosProveedor.codigo_tercero;
      ELSE
        Lr_Arcpdc.codigo_tercero := NULL;
      END IF; 
      --
      -- se asigna el monto del impuesto
      Lr_Arcpdc.monto_dc := Lr_Impuesto.Monto;
      Lr_Arcpdc.monto := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc * Ln_factorP), 'P');
      Lr_Arcpdc.monto_dol := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc / Ln_factorD), 'D');
      --
      -- se insertan los datos detalle contable
      --
      P_INSERTA_ARCPDC (Lr_Arcpdc, Pv_MensajeError);
      --
      IF Pv_MensajeError IS NOT NULL THEN
        RAISE Le_Error;
      END IF;
      --
    END LOOP;
    -------------------------------------------------------------------
    -- Detalle contable por c�digo de servicio en ordenes de compras --
    -------------------------------------------------------------------
    FOR Lr_OrdenCompra IN C_DATOS_ORDEN_COMPRA (Lr_Arcpmd.No_Docu, Lr_Arcpmd.No_Cia) LOOP
      --
      Ln_Porcentaje_Orden_Compra := Lr_OrdenCompra.Monto / (Nvl(Lr_Arcpmd.Subtotal,0)+Nvl(Lr_Arcpmd.Tot_Imp,0));
      Lr_Arcpdc.tipo := 'D';
  	  Lr_Arcpdc.modificable  := 'N';
      --
      IF Lr_OrdenCompra.Tipo_Distribucion_Costo IN ('Administrativo','Pedido') THEN
        --
        Ln_DetalleDistribId := 0;
        --
  	    NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.P_REPLICA_DISTRIBUCION_CXP ( Lr_OrdenCompra.No_Orden,
                                                                         Lr_OrdenCompra.No_Docu,
                                                                         Lr_OrdenCompra.No_Cia,
                                                                         Ln_DetalleDistribId,
                                                                         Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        -- Se recupera distribucion
        NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.P_DETALLE_CENTRO_COSTO ( Ln_DetalleDistribId,
                                                                     Lr_OrdenCompra.No_Docu,
                                                                     'CuentasPorPagar',
                                                                     Lr_OrdenCompra.No_Cia,
                                                                     Ln_CantidadDistribuir,
                                                                     Lt_DetCentroCostos,
                                                                     Pv_MensajeError);
        --
        IF Pv_MensajeError IS NOT NULL THEN
          RAISE Le_Error;
        END IF;
        --
        IF Ln_CantidadDistribuir <= 0 THEN
          Pv_MensajeError := 'No se ha encontrado distribuci�n de costos, revisar sentencia de consulta para DISTRIBUCION_CONTABLE.';
          Raise Le_Error;
        END IF;
        --
        --
        FOR Lr_OrdenCompraDet IN C_ORDEN_COMPRA_DETALLE ( Lr_OrdenCompra.No_Orden,
                                                          Lr_OrdenCompra.No_Cia) LOOP
          --
          Ln_SaldoDistribuir := ROUND((NVL(Lr_Arcpmd.Subtotal,0) * Ln_Porcentaje_Orden_Compra * Lr_OrdenCompraDet.Porcentaje_Base_Imponible),2);
          Ln_MontoIndividual := (Ln_SaldoDistribuir / Ln_CantidadDistribuir);
          --
          FOR Li_Datos IN 1..Lt_DetCentroCostos.LAST LOOP
            --
            Lr_Arcpdc.Codigo := Lr_OrdenCompraDet.Id_Cuenta_Contable;
            Lr_Arcpdc.No_Distribucion := Ln_DetalleDistribId;
            Lr_Arcpdc.Centro_Costo := Lt_DetCentroCostos(Li_Datos).CENTRO_COSTO_ID;
            IF NAF47_TNET.CUENTA_CONTABLE.ACEPTA_TERCERO (Lr_Arcpdc.no_cia, Lr_Arcpdc.codigo) THEN
              Lr_Arcpdc.codigo_tercero := Lr_DatosProveedor.codigo_tercero;
            ELSE
              Lr_Arcpdc.codigo_tercero := NULL;
            END IF; 
            --
            Lr_Arcpdc.Monto_Dc := ROUND((Ln_MontoIndividual * Lt_DetCentroCostos(Li_Datos).CANTIDAD),2);
            Lr_Arcpdc.monto := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc * Ln_factorP), 'P');
            Lr_Arcpdc.monto_dol := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc / Ln_factorD), 'D');
            --
            -- se insertan los datos detalle contable
            --
            P_INSERTA_ARCPDC (Lr_Arcpdc, Pv_MensajeError);
            --
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            --
            Ln_SaldoDistribuir := Ln_SaldoDistribuir - (ROUND((Ln_MontoIndividual * Lt_DetCentroCostos(Li_Datos).CANTIDAD),2));
            --
          END LOOP;
          --
          IF Ln_SaldoDistribuir != 0 THEN
            --
            Lr_Arcpdc.Monto_Dc := Ln_SaldoDistribuir;
            Lr_Arcpdc.monto := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc * Ln_factorP), 'P');
            Lr_Arcpdc.monto_dol := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc / Ln_factorD), 'D');
            --
            P_INSERTA_ARCPDC (Lr_Arcpdc, Pv_MensajeError);
            --
            IF Pv_MensajeError IS NOT NULL THEN
              RAISE Le_Error;
            END IF;
            --
            Ln_SaldoDistribuir := 0;
            --
          END IF;
          --
        END LOOP;
      -- detalle contable por proyecto
      ELSIF Lr_OrdenCompra.Tipo_Distribucion_Costo = 'Proyecto' THEN
        --
        FOR Lr_OrdenCompraProyecto IN C_ORDEN_COMPRA_PROYECTO (Lr_Arcpmd.No_Docu, Lr_Arcpmd.No_Cia) LOOP
          --
          Lr_Arcpdc.Codigo := NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.F_RECUPERA_CUENTA_CONTABLE( Lr_OrdenCompraProyecto.TIPO_CCOSTO_ID, 
                                                                                              Lr_OrdenCompraProyecto.REFERENCIA_ID,
                                                                                              Lr_OrdenCompraProyecto.NO_CIA);
          --
          Lr_Arcpdc.centro_costo := naf47_tnet.centro_costo.rellenad(Lr_Arcpdc.no_cia, '0');       
          --
          IF NAF47_TNET.CUENTA_CONTABLE.ACEPTA_TERCERO (Lr_Arcpdc.no_cia, Lr_Arcpdc.codigo) THEN
            Lr_Arcpdc.codigo_tercero := Lr_DatosProveedor.codigo_tercero;
          ELSE
            Lr_Arcpdc.codigo_tercero := NULL;
          END IF; 
          --
          Lr_Arcpdc.monto_dc := ROUND(((Lr_OrdenCompra.Monto * Lr_OrdenCompraProyecto.PORCENTAJE_BASE) * Lr_OrdenCompraProyecto.PORCENTAJE),2);
          Lr_Arcpdc.monto := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc * Ln_factorP), 'P');
          Lr_Arcpdc.monto_dol := NAF47_TNET.MONEDA.REDONDEO((Lr_Arcpdc.monto_dc / Ln_factorD), 'D');
          --
          P_INSERTA_ARCPDC (Lr_Arcpdc, Pv_MensajeError);
          --
          IF Pv_MensajeError IS NOT NULL THEN
            RAISE Le_Error;
          END IF;
          --  
        END LOOP; -- fin recorrido distribuion de oc          
        --
      END IF;
      --
    END LOOP;
    --
    --  
    UPDATE NAF47_TNET.ARCPMD MD
    SET TOT_DB = (SELECT SUM(MONTO_DC) 
                  FROM NAF47_TNET.ARCPDC DC 
                  WHERE DC.TIPO = 'D'
                  AND DC.NO_DOCU = MD.NO_DOCU 
                  AND DC.NO_CIA = MD.NO_CIA),
        TOT_CR = (SELECT SUM(MONTO_DC) 
                  FROM NAF47_TNET.ARCPDC DC 
                  WHERE DC.TIPO = 'C'
                  AND DC.NO_DOCU = MD.NO_DOCU 
                  AND DC.NO_CIA = MD.NO_CIA),
        TOT_IMP = Lr_Arcpmd.Tot_Imp,
        TOT_RET = Lr_Arcpmd.Tot_Ret,
        MONTO = Lr_Arcpmd.Monto,
        SALDO = Lr_Arcpmd.Saldo,
        MONTO_NOMINAL = Lr_Arcpmd.Monto_Nominal,
        SALDO_NOMINAL = Lr_Arcpmd.Saldo_Nominal
    WHERE NO_CIA = Lr_Arcpmd.No_Cia
    AND NO_DOCU = Lr_Arcpmd.No_Docu;
    --
    Pv_noDocumento := Lr_Arcpmd.No_Docu;
    --
  EXCEPTION
    WHEN Le_Error THEN
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'CPKG_TRANSACCION.P_REGISTRO_FACTURA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_MensajeError := Lr_Arcpmd.fecha||'. '||SQLERRM || ' - ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      ROLLBACK;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'CPKG_TRANSACCION.P_REGISTRO_FACTURA',
                                           Pv_MensajeError,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.HOST),user), 
                                           SYSDATE,
                                           NVL(SYS_CONTEXT(GEK_VAR.Gr_Sesion.USERENV,GEK_VAR.Gr_Sesion.IP_ADRESS),'127.0.0.1'));
  END P_REGISTRO_FACTURA;
end CPKG_TRANSACCION;
/