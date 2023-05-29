CREATE OR REPLACE PROCEDURE NAF47_TNET.CPACTUALIZA (pCia   IN arcpmd.no_cia%TYPE, --  varchar2,
                                         pProve IN arcpmd.no_prove%TYPE,--varchar2,
                                         pTipo  IN arcpmd.tipo_doc%TYPE,--varchar2,
                                         pDocu  IN arcpmd.no_docu%TYPE,--  varchar2,
                                         pError IN OUT VARCHAR2) IS
   --
   TIPO_ORDEN_COMPRA CONSTANT VARCHAR2(2) := 'CO';
/**
 * Documentacion para CPACTUALIZA
 * Procedimiento que actualizacion de los documentos de cuentas por pagar
 * 
 * @author yoveri
 * @version 1.0 01/01/2007
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 09/06/2017 Se modifica actualizar los estado de la tabla DB_COMPRAS.INFO_ORDEN_COMPRA
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.2 05/07/2020 Se modifica invocar nuevo proceso PRKG_CONTROL_PRESUPUESTO para dsitribucion de costos
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.3 27/08/2020 Se modifica invocar nuevo proceso PRKG_CONTROL_PRESUPUESTO.P_DISTRIBUCION_COSTO_FACTURA para dsitribucion de costos
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.3 10/11/2021 Se modifica para actualizar el valor factutado de ingreso a bodega
 *
 * @param pCia   IN arcpmd.no_cia%TYPE recibe codigo de compania
 * @param pProve IN arcpmd.no_prove%TYPE recibe codigo de proveedor
 * @param pTipo  IN arcpmd.tipo_doc%TYPE recibe tipo de documento
 * @param pDocu  IN arcpmd.no_docu%TYPE recibe numero transaccion cxp
 * @param pError IN OUT VARCHAR2 retorma mensaje de error
 */
  CURSOR c_docu(pProve arcpmd.no_prove%TYPE,
                pTipo  arcpmd.tipo_doc%TYPE,
                pDocu  arcpmd.no_docu%TYPE) IS
    SELECT md.no_prove,
           md.tipo_doc,
           md.no_docu,
           md.monto,
           md.fecha,
           td.tipo_mov,
           td.documento,
           md.saldo,
           md.rowid ROWID_MD,
           md.tipo_cambio,
           md.moneda,
           TO_NUMBER(TO_CHAR(md.fecha, 'YYYY')) ano_doc,
           TO_NUMBER(TO_CHAR(md.fecha, 'MM')) mes_doc,
           td.formulario_ctrl,
           td.ind_anulacion,
           NVL(md.tot_ret_especial, 0) tot_ret_especial,
           md.ind_act,
           md.usuario_anula,
           md.motivo_anula,
           md.n_docu_a,
           MD.TOT_RET,
           md.tipo_ret, -- SE A?ADIO CAMPO TOT_RET POR NACIONALIZACION
           md.comp_ret,
           md.no_autorizacion_comp,
           md.fecha_validez_comp,
           md.numero_ctrl,
           nvl(md.gravado,0)+nvl(md.excentos,0) subtotal
      FROM arcptd td,
           arcpmd md
     WHERE md.no_cia = pCia
       AND md.no_prove = pProve
       AND md.tipo_doc = pTipo
       AND md.no_docu = pDocu
       AND td.no_cia = md.no_cia
       AND td.tipo_doc = md.tipo_doc;
  --
  CURSOR c_refer(pTipo_doc VARCHAR2,
                 pNo_docu  VARCHAR2) IS
    SELECT b.no_prove,
           a.tipo_refe,
           a.no_refe,
           a.moneda_refe,
           a.monto_refe,
           a.monto,
           a.tipo_doc,
           a.no_docu,
           b.Saldo,
           NVL(b.tot_ret_especial, 0) tot_ret_especial,
           c.tipo_mov tipo_mov_refe,
           b.no_fisico,
           b.serie_fisico,
           b.rowid registro_md,
           a.rowid registro_rd,
           C.COD_DIARIO,
           a.id_forma_pago
      FROM arcprd a,
           arcpmd b,
           arcptd c
     WHERE a.no_cia = pCia
       AND a.tipo_doc = pTipo_doc
       AND a.no_docu = pNo_docu
       AND a.ind_procesado = 'N'
       AND b.no_cia = a.no_cia
       AND b.tipo_doc = a.tipo_refe
       AND b.no_docu = a.no_refe
       AND c.no_cia = b.no_cia
       AND c.tipo_doc = b.tipo_doc;
  --
  CURSOR c_proceso IS
    SELECT ano_proc,
           mes_proc
      FROM arcpct
     WHERE no_cia = pCia;
  --
  CURSOR c_ordenes(vrefe IN VARCHAR2) IS
    SELECT no_orden,
           no_arti,
           cantidad_pedida
      FROM arimdetfacturas a
     WHERE no_cia = pCia
       AND num_fac = vrefe
       AND ((a.no_cia, a.num_fac) IN (SELECT b.no_cia,
                                             b.num_fac
                                        FROM arimencfacturas b
                                       WHERE estado = 'A'
                                         AND no_embarque !='000000000000'));
  --
  CURSOR c_libro(pTipo_doc arcptd.tipo_doc%TYPE) IS
    SELECT afecta_libro
      FROM arcptd
     WHERE no_cia = pCia
       AND tipo_doc = pTipo_doc;
  --
  -- Forma de pago de la retencion (Guatemala):
  --   'F' = momento de la actualizacion
  --   'P' = momento del pago total
  CURSOR c_forma_retencion IS
    SELECT ind_forma_ret,
           tipo_doc_ND_ret,
           tipo_doc_NC_ret
      FROM arcppr
     WHERE no_cia = pCia;

  -- Nacionalizacion agrega informacion de retenciones
  -- 02/10/2006
  CURSOR c_inf_ret_ECU(c_TIPO_doc_ret VARCHAR2) IS
    SELECT serie,
           fec_autorizacion,
           no_autorizacion
      FROM control_formu
     WHERE no_cia = pcia
       AND formulario = (SELECT formulario_ctrl
                           FROM arcptd
                          WHERE no_cia = pcia
                            AND documento = 'R'
                            AND tipo_doc = c_TIPO_doc_ret);
  --
  CURSOR C_SALDO_OC_LOCAL(Cv_NoOrdenCompra VARCHAR2,
                          Cv_NoCia         VARCHAR2) IS
    SELECT A.NO_CIA,
           A.NO_ORDEN,
           (A.TOTAL - A.VALOR_FACTURADO) VALOR_X_FACTURAR
      FROM TAPORDEE A
     WHERE A.NO_ORDEN = Cv_NoOrdenCompra
       AND A.NO_CIA = Cv_NoCia;
  --
  -- se identifica que se seleccione registro de tipo OrdenCompra
  -- costo query: 4
  CURSOR C_ORDEN_COMPRA_LOCAL(Cv_NoDocumento   VARCHAR2,
                              Cv_TipoDocumento VARCHAR2,
                              Cv_NoCia         VARCHAR2) IS
    SELECT A.COMPANIA,
           A.NO_DOCUMENTO_ORIGEN,
           A.NO_DOCUMENTO,
           SUM(A.MONTO) MONTO
      FROM CP_DOCUMENTO_ORIGEN A
     WHERE A.NO_DOCUMENTO = Cv_NoDocumento
       AND A.TIPO_DOCUMENTO = Cv_TipoDocumento
       AND A.COMPANIA = Cv_NoCia
     GROUP BY A.COMPANIA,
              A.NO_DOCUMENTO_ORIGEN,
              A.NO_DOCUMENTO;
  -- LLINDAO  16/07/2013
  -- verifica si factura ya tiene asociado forma pago
  CURSOR C_VERIFICA_FP ( Cv_IdFormaPago varchar2,
                         Cv_IdDocumento varchar2,
                         Cv_IdCompania  varchar2) is
    SELECT A.ID_FORMA_PAGO
      FROM CP_FORMA_PAGO_DOC A
     WHERE A.ID_FORMA_PAGO = Cv_IdFormaPago
       AND A.ID_DOCUMENTO = Cv_IdDocumento
       AND A.ID_COMPANIA = Cv_IdCompania;

  -- verifica si factura ya tiene asociado forma pago
  CURSOR C_PEDID_ORD (Cv_IdCompania  varchar2,
                      Cv_No_Orden    varchar2) is
    SELECT IOC.ID_ORDEN_COMPRA,
      IOC.VALOR_TOTAL,
      IOC.ESTADO,
      IOC.PEDIDO_ID 
    FROM DB_COMPRAS.INFO_ORDEN_COMPRA IOC,
      DB_COMPRAS.INFO_PEDIDO       IP,
      DB_COMPRAS.ADMI_DEPARTAMENTO AD,
      DB_COMPRAS.ADMI_EMPRESA      AE
    WHERE IOC.SECUENCIA = Cv_No_Orden
    AND IOC.PEDIDO_ID = IP.ID_PEDIDO
    AND IP.DEPARTAMENTO_ID = AD.ID_DEPARTAMENTO
    AND AD.EMPRESA_ID = AE.ID_EMPRESA
    AND AE.CODIGO = Cv_IdCompania;

  -- verifica si factura ya tiene asociado forma pago
  CURSOR C_ORD_VALOR_FACTURADO (Cv_IdCompania  varchar2,
                                Cv_No_Orden    varchar2) is
    SELECT A.VALOR_FACTURADO 
    FROM TAPORDEE A            
    WHERE A.NO_ORDEN = Cv_No_Orden
    AND A.NO_CIA   = Cv_IdCompania;
  --    
  -- cursor que recupera numeros de ingresos a bodegas para actualizar valor facturado.
  -- costo query: 7
  CURSOR C_INGRESO_BODEGA (Cv_NoDocumento   VARCHAR2,
                           Cv_TipoDocumento VARCHAR2,
                           Cv_NoCia         VARCHAR2) IS
    SELECT A.COMPANIA,
           A.NO_DOCUMENTO_ORIGEN,
           A.NO_DOCUMENTO,
           (ME.MOV_TOT - ME.MONTO_FACTURADO) AS SALDO_IB,
           SUM(A.MONTO) MONTO
      FROM NAF47_TNET.ARINME ME,
           NAF47_TNET.CP_DOCUMENTO_ORIGEN A
     WHERE A.NO_DOCUMENTO = Cv_NoDocumento
       AND A.TIPO_DOCUMENTO = Cv_TipoDocumento
       AND A.COMPANIA = Cv_NoCia
       AND A.TIPO_DOCUMENTO_ORIGEN = ME.TIPO_DOC
       AND A.NO_DOCUMENTO_ORIGEN = ME.NO_DOCU
       AND A.COMPANIA = ME.NO_CIA
     GROUP BY A.COMPANIA,
              A.NO_DOCUMENTO_ORIGEN,
              A.NO_DOCUMENTO,
              ME.MOV_TOT,
              ME.MONTO_FACTURADO;

  Lv_IdFormaPago cp_forma_pago_doc.id_forma_pago%type :=  null;
  Lv_TipoProceso VARCHAR2(30);
  --
  vFound         BOOLEAN;
  Reg_Doc        c_docu%ROWTYPE;
  lc_inf_ret_ECU c_inf_ret_ECU%ROWTYPE;
  vLibro         arcptd.Afecta_Libro%TYPE;
  vCod_Estado    arcpte.Cod_Estado%TYPE;
  vMes_Proc      arcpct.mes_proc%TYPE;
  vAno_Proc      arcpct.ano_proc%TYPE;
  vNumero_ctrl   arcpmd.numero_ctrl%TYPE;
  Lr_Saldo       C_SALDO_OC_LOCAL%ROWTYPE := NULL;
  Lr_Pedid_Ord   c_pedid_ord%ROWTYPE;
  Ln_valor_facturado tapordee.valor_facturado%TYPE;
  --
  error_proceso EXCEPTION;
  --
  vInd_forma_ret   arcppr.ind_forma_ret%TYPE;
  vtipo_doc_ND_ret arcppr.tipo_doc_nd_ret%TYPE;
  vtipo_doc_NC_ret arcppr.tipo_doc_nc_ret%TYPE;
  --
  --
  -- POR NACIONALIZACION
  --lv_doc    arcpmd.tipo_doc%TYPE;
  vComp_ret arcpmd.comp_ret%TYPE;
  Lv_NoAutorizacionRet arcpmd.no_autorizacion_comp%type := null;
  Ld_FechaAutCompRet arcpmd.fecha_validez_comp%type := null;
  --
  --
  --

  PROCEDURE Notas_Retencion(pNo_Prove     arcpmd.no_prove%TYPE,
                            pTipo_Doc     arcpmd.tipo_doc%TYPE,
                            pNo_Docu      arcpmd.no_docu%TYPE,
                            pFecha        arcpmd.fecha%TYPE,
                            pNo_docu_pago arcbbo.no_docu_pago%TYPE) IS
    --
    -- Retenciones incluidas - Guatemala.
    -- Genera y aplica la nota de retencion.
    -- Actualiza el estado de las boletas en arcpti.
    -- Este procedimiento tambien se encuentra en el form fcp20_04.
    --

    -- Estado de la nota insertada
    CURSOR c_estado_nota(pNo_Docu arcpmd.no_prove%TYPE) IS
      SELECT ind_act
        FROM arcpmd
       WHERE no_cia = pCia
         AND no_docu = pNo_Docu;

    vTipo_nota   arcpmd.tipo_doc%TYPE;
    vNo_nota     arcpmd.no_docu%TYPE;
    vEstado_nota arcpmd.ind_act%TYPE;
  BEGIN
    --
    -- Genera una nota para cancelar el monto de la retencion
    -- del documento pNo_Docu. En vTipo_Nota y vNo_Nota devuelve
    -- el tipo y el numero de la nota generada
    --
    CPNotas_Retencion(pCia, pNo_Docu, pFecha, pNo_docu_pago,vTipo_nota, vNo_nota, pError);
    IF pError IS NOT NULL THEN
      RAISE Error_Proceso;
    END IF;

    IF (vTipo_nota IS NOT NULL) AND (vNo_nota IS NOT NULL) THEN
      CPActualiza(pCia, pNo_Prove, vTipo_nota, vNo_nota, pError);
      IF pError IS NOT NULL THEN
        RAISE Error_Proceso;
      END IF;

      --
      -- Si se aplico la nota de retencion, se actualiza el
      -- estado de la boleta. El estado queda en 'A' = Actualizada
      -- La fecha es la fecha de la factura si las retenciones son en la
      -- provision y la fecha del doc de pago si es en la cancelacion.
      --
      OPEN c_estado_nota(vNo_nota);
      FETCH c_estado_nota
        INTO vEstado_nota;
      CLOSE c_estado_nota;

      IF vEstado_nota = 'D' THEN
        UPDATE arcbbo
           SET estatus_boleta = 'A',
               fecha_boleta   = pFecha,
               no_docu_pago   = pNo_docu_pago
         WHERE no_cia = pCia
           AND no_prove = pNo_Prove
           AND no_docu = pNo_Docu
           AND estatus_boleta IS NULL;

      END IF;

    END IF;

  END Notas_Retencion;
  --
  --
BEGIN
  -- Procedimiento principal
  --  fvi_p('prove '||pProve||' tipo'||ptipo||' pdocu '||pdocu, pcia);
  -- Recupera el documento a aplicar
  OPEN c_docu(pProve, pTipo, pDocu);
  FETCH c_docu
    INTO reg_Doc;
  vfound := c_docu%FOUND;

  IF NOT vfound THEN
    pError := 'No existe la transaccion numero: ' || pDocu;
    RAISE error_proceso;
  END IF;

  CLOSE c_docu;
  --
  -- Se elimino esta condicion del cursor C_DOCU porque cuando se
  -- generan Retenciones incluidas para docs de DEBITO, es necesario
  -- volver a ejecutar el cursor. Pero para ese momento IND_ACT
  -- ya fue actualizado a 'D', y la variable reg_doc no se actualiza
  -- correctamente.
  IF reg_doc.ind_act <> 'P' THEN
    pError := 'La transaccion numero ' || pDocu || ' ya fue actualizada.';
    RAISE error_proceso;
  END IF;
  --
  -- Recupera el periodo en proceso
  OPEN c_Proceso;
  FETCH c_Proceso
    INTO vAno_proc,
         vMes_proc;
  CLOSE c_Proceso;
  --
  IF ((vano_proc * 100) + vmes_proc) < ((reg_doc.ano_doc * 100) +reg_doc.mes_doc) THEN
    -- el periodo del documento es superior al periodo en proceso, de ahi que
    -- se deja pendiente para actualizar cuando CxP alcance al periodo del documento
    RETURN;
  END IF;
  --
  -- Actualizar el libro de compras
  OPEN c_libro(pTipo);
  FETCH c_libro
    INTO vLibro;
  CLOSE c_libro;
  --
  IF (vLibro IS NOT NULL) AND (vLibro = 'C') THEN
    cpLibro_Compras(pCia, pprove, ptipo, pdocu, pError);
  END IF;
  --
  IF pError IS NOT NULL THEN
    RAISE error_proceso;
  END IF;

  IF (vLibro IS NOT NULL) AND (vLibro = 'R') THEN
    cpLibro_honorarios(pCia, pProve, pTipo, pDocu, reg_doc.moneda, pError);
  END IF;
  IF pError IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  --
  vCod_Estado := NULL;
  CPRegistra_Estado(pCia, pProve, pDocu, pTipo, 'I', vCod_Estado);
  IF Reg_Doc.Saldo = 0 THEN
    vCod_Estado := NULL;
    CPRegistra_Estado(pCia, pProve, pDocu, pTipo, 'F', vCod_Estado);
  END IF;

  --
  -- Actualiza el estado del documento
  --
  IF reg_doc.formulario_ctrl IS NULL THEN
    vnumero_ctrl := NULL;
  ELSE
    IF reg_doc.numero_ctrl IS NOT NULL THEN
      vNumero_ctrl := reg_doc.numero_ctrl;
    ELSE
      vnumero_ctrl := consecutivo.cp(pCia, reg_doc.ano_doc,reg_doc.mes_doc, reg_doc.tipo_doc, 'SECUENCIA');
    END IF;
  END IF;
  --*********************************************************************
  -- Motivo :  Modificacion por Nacionalizacion
  -- Fecha :  29/08/2006
  --*********************************************************************
  -- Actualiza el estado de cuenta del proveedor  ARCPMP
  --
  -- Se va a generar el no. de Retencion y actualizarlo en ARCPMD
  BEGIN

    --- Genera el secuencial solo para las de documento = FACTURA

    IF reg_doc.tot_ret > 0 AND reg_doc.documento = 'F' THEN

      OPEN c_inf_ret_ECU(reg_doc.tipo_ret);
      FETCH c_inf_ret_ECU
        INTO lc_inf_ret_ECU;
      CLOSE c_inf_ret_ECU;
      IF reg_doc.comp_ret IS NOT NULL THEN
        vcomp_ret := reg_doc.comp_ret;
        Lv_NoAutorizacionRet := reg_doc.no_autorizacion_comp;
        Ld_FechaAutCompRet := reg_doc.fecha_validez_comp;
      ELSE
        -- se modifica para que seleccione el tipo de retencion en funcion del documento arcpmd. tipo_ret
        vcomp_ret := Consecutivo.CP(PCIA,
                                    reg_doc.ano_doc,
                                    reg_doc.mes_doc,     ---     to_number(to_char(REG_DOC.ANO_DOC, 'RRRR')), 
                                                                                             ---   to_number(to_char(REG_DOC.MES_DOC, 'MM')),
                                    reg_doc.tipo_ret,
                                    'SECUENCIA');

       Lv_NoAutorizacionRet := lc_inf_ret_ECU.No_Autorizacion;
       Ld_FechaAutCompRet := lc_inf_ret_ECU.fec_autorizacion;
      END IF;

      UPDATE ARCPMD
         SET IND_ACT              = 'D',
             NUMERO_CTRL          = VNUMERO_CTRL,
             COMP_RET             = Vcomp_ret,
             COMP_RET_SERIE       = lc_inf_ret_ECU.Serie, --
             FECHA_VALIDEZ_COMP   = Ld_FechaAutCompRet,--lc_inf_ret_ECU.fec_autorizacion, --
             NO_AUTORIZACION_COMP = Lv_NoAutorizacionRet,--lc_inf_ret_ECU.No_Autorizacion), --
             FECHA_ACTUALIZACION  = SYSDATE,
             USUARIO_ACTUALIZA    = UPPER(USER)
       WHERE ROWID = reg_doc.rowid_md; --serie, fec_autorizacion, no_autorizacion

      UPDATE ARCPTI
         SET SECUENCIA_RET = lc_inf_ret_ECU.SERIE || Vcomp_ret,
             AUTORIZACION  =Lv_NoAutorizacionRet--lc_inf_ret_ECU.No_Autorizacion
      --  FECHA_RET = lc_inf_ret_ECU.fec_autorizacion,
       WHERE no_cia = PCIA
         AND no_docu = PDOCU
         AND ind_imp_ret = 'R'
         AND anulada = 'N';

    ELSE
      --
      UPDATE arcpmd
         SET ind_act     = 'D',
             numero_ctrl = vnumero_ctrl
       WHERE ROWID = reg_doc.rowid_md;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      pError := 'No se ha definido un tipo de documento para retencion';
      RAISE error_proceso;
  END;

  --
  -- Obtener la forma de pago de las retenciones incluidas. Guatemala
  OPEN c_forma_retencion;
  FETCH c_forma_retencion
    INTO vInd_forma_ret,
         vtipo_doc_ND_ret,
         vtipo_doc_NC_ret;
  vfound := c_forma_retencion%FOUND;
  CLOSE c_forma_retencion;

  IF NOT vfound THEN
    vInd_forma_ret := NULL;
  END IF;

  IF vfound AND (NVL(reg_doc.ind_anulacion, 'N') = 'N') THEN
    -- Copiar las retenciones del doc de arcpti a arcbbo
    -- excepto si es una anulacion
    CPTraslada_Retenciones(pCia, pProve, pTipo, pDocu, reg_Doc.tipo_cambio);
  END IF;

  --
  -- Retenciones incluidas - Guatemala.
  -- Cuando se procesan ajustes de credito (tipo_mov = 'D') con retenciones
  -- la nota se genera antes de procesar las referencias para que el ciclo
  -- tome en cuenta la referencia que va a generar la nota (de tipo credito).
  -- Para estos documentos (debito) la nota siempre se genera
  -- al actualizarse el doc, sin importar el valor de arcppr.ind_forma_ret
  -- Documentos de DEBITO.
  IF (vInd_forma_ret IS NOT NULL) AND (reg_doc.tipo_mov = 'D') THEN
    -- Aun no tiene doc de pago (=NULL)
    Notas_Retencion(pProve, pTipo, pDocu, reg_doc.fecha, NULL);

    -- Refresca los datos del documento.
    -- El saldo pudo haber sido modificado al generarse la nota de retencion.
    OPEN c_docu(pProve, pTipo, pDocu);
    FETCH c_docu
      INTO reg_Doc;
    CLOSE c_docu;
  END IF;

  --
  -- Actualiza los saldos de los documentos referenciados
  FOR rd IN c_refer(reg_doc.tipo_doc, reg_doc.no_docu) LOOP

    --Valida que el saldo de la referencia sea mayor al monto del documento
    IF NVL(rd.monto_refe, 0) > NVL(rd.saldo, 0) THEN
      pError := 'El pago del documento tipo ' || rd.tipo_doc || 'transaccion #' || rd.no_docu || ' excede el saldo de la referencia ' ||rd.tipo_refe || 'transaccion # ' || rd.no_refe || '---' ||reg_doc.tipo_doc || '-' || reg_doc.no_docu;
      RAISE error_proceso;
    END IF;

    IF reg_doc.tipo_mov = 'C' THEN
      IF RD.COD_DIARIO <> 'PROVI' THEN
        --emunoz 20122012
        UPDATE arcpmd
           SET saldo = NVL(saldo, 0) + NVL(rd.monto_refe, 0)
         WHERE ROWID = rd.registro_md;
      ELSE
        --emunoz 20122012
        UPDATE arcpmd
           SET saldo = NVL(saldo, 0) - NVL(rd.monto_refe, 0)
         WHERE ROWID = rd.registro_md;
      END IF; --emunoz 20122012

    ELSE
      -- Debito

      IF NVL(rd.saldo, 0) < NVL(rd.monto_refe, 0) THEN
        pError := 'El saldo del doc. ' || rd.tipo_refe || '' ||rd.no_fisico || '-' || rd.serie_fisico || ' (' || TO_CHAR(rd.saldo) ||') es menor que el monto de lareferencia (' || TO_CHAR(rd.monto_refe) ||')';
        RAISE error_proceso;
      END IF;

      UPDATE arcpmd
         SET saldo = NVL(saldo, 0) - NVL(rd.monto_refe, 0)
       WHERE ROWID = rd.registro_md;

      -- Retenciones incluidas - Guatemala.
      -- Si el pago de las retenciones se da al Cancelarse
      -- totalmente la factura, revisar el saldo de la factura.
      -- Documentos de CREDITO.
      IF ((NVL(rd.saldo, 0) - NVL(rd.monto_refe, 0) -NVL(rd.tot_ret_especial, 0)) <= 0) AND (vInd_forma_ret = 'P') AND (rd.tipo_mov_refe = 'C') AND (rd.tipo_refe <> vtipo_doc_NC_ret) AND --si afecta a una NC retencion no hay que generar otra
         (rd.tipo_doc <> vtipo_doc_ND_ret) AND -- si se aplica una ND retencion no hay que generar otra
         (NVL(reg_doc.ind_anulacion, 'N') = 'N') THEN
        -- si se aplica una anulacion no se genera nota retencion
        Notas_Retencion(rd.no_prove, rd.tipo_refe, rd.no_refe,reg_doc.fecha, reg_doc.no_docu);
      END IF;

    END IF;

    --
    -- Actualiza Historicos si el movimiento es de otros meses
    IF ((vAno_Proc * 100) + vMes_Proc) > ((reg_doc.ano_doc * 100) + reg_doc.mes_doc) THEN
      CPAct_Historico(pCia, rd.no_prove, reg_doc.fecha, rd.Monto_refe,reg_doc.tipo_Mov, vmes_proc, vano_proc, rd.moneda_refe);
    ELSE
      --
      -- Actualiza el estado de cuenta del proveedor
      CPActualiza_saldo_prove(pCia, rd.no_prove, reg_doc.tipo_mov,rd.moneda_refe, rd.monto_refe, reg_doc.tipo_cambio, reg_doc.documento,reg_doc.fecha, pError);
    END IF;
    --
    -- valida que no se haya producido ningun error en la actualizacion de saldos.
    IF pError IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
    --
    --
    IF (cplib.esAnulacion(pCia, reg_doc.tipo_doc) OR cplib.esReversion(pCia, reg_doc.tipo_doc)) AND (reg_doc.tipo_mov = 'D') THEN
      --
      -- Si la factura que se esta anulando o reversando esta asociada a alguna o
      -- algunas ordenes de compra en el modulo de Compras e Importaciones,
      -- disminuye la cantidad de articulos a facturar en la orden.
      FOR i IN c_ordenes(rd.no_refe) LOOP
        UPDATE arimdetorden
           SET cantidad_factura = NVL(cantidad_factura, 0) - i.cantidad_pedida
         WHERE no_cia = pCia
           AND no_orden = i.no_orden
           AND no_arti = i.no_arti;
      END LOOP;

      -- llindao: se devuelve valor facturado de orden de compra
      FOR Lr_Origen IN C_ORDEN_COMPRA_LOCAL(rd.no_refe, rd.tipo_refe, pCia) LOOP
        UPDATE TAPORDEE A
           SET A.VALOR_FACTURADO = A.VALOR_FACTURADO - Lr_Origen.Monto
         WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
           AND A.NO_CIA = Lr_Origen.Compania;

        -- mnavarrete: el actualiza el estado de la Orden relacionada al Pedido
        ---------------------------------------------- 
        -- Cursor para traer informacion del Pedido
        ---------------------------------------------- 
        IF C_PEDID_ORD%ISOPEN THEN
          CLOSE C_PEDID_ORD;
        END IF;
        OPEN  C_PEDID_ORD (pCia, Lr_Origen.No_Documento_Origen);
        FETCH C_PEDID_ORD INTO Lr_Pedid_Ord;
        CLOSE C_PEDID_ORD;
        --         
        -- Obtener el VALOR_FACTURADO luego disminucion de VALOR_FACTURADO
        IF C_ORD_VALOR_FACTURADO%ISOPEN THEN
          CLOSE C_ORD_VALOR_FACTURADO;
        END IF;
        OPEN  C_ORD_VALOR_FACTURADO(Lr_Origen.No_Documento_Origen, pCia);
        FETCH C_ORD_VALOR_FACTURADO INTO Ln_valor_facturado;
        CLOSE C_ORD_VALOR_FACTURADO;

        IF nvl(Ln_valor_facturado,0) = 0  THEN
          UPDATE DB_COMPRAS.INFO_ORDEN_COMPRA
             SET ESTADO = 'Procesada'
           WHERE ID_ORDEN_COMPRA = Lr_Pedid_Ord.ID_ORDEN_COMPRA;
        END IF;

        IF nvl(Ln_valor_facturado,0) > 0  THEN
          UPDATE DB_COMPRAS.INFO_ORDEN_COMPRA
             SET ESTADO = 'PagoParcial'
           WHERE ID_ORDEN_COMPRA = Lr_Pedid_Ord.ID_ORDEN_COMPRA;
        END IF;  
        --              
      END LOOP;
      --
      --
      -- documentos orige ingresos a bodegas
      FOR Lr_Origen IN C_INGRESO_BODEGA (rd.no_refe, rd.tipo_refe, pCia) LOOP
        --
        UPDATE NAF47_TNET.ARINME ME
        SET ME.MONTO_FACTURADO = ME.MONTO_FACTURADO - Lr_Origen.Monto
        WHERE ME.NO_DOCU = Lr_Origen.No_Documento_Origen
        AND ME.NO_CIA = Lr_Origen.Compania;
        --
      END LOOP;
      --
    END IF;
    -----------------------------------------------------------------
    -- Si forma de pago esta asignada se debe ingresar a la factura --
    -----------------------------------------------------------------
    IF rd.id_forma_pago is not null then
      -- se verifica si forma de pago no esta asociado a factura
      if c_verifica_fp%isopen then close c_verifica_fp; end if;
      open c_verifica_fp(rd.id_forma_pago, rd.no_refe, pCia);
      fetch c_verifica_fp into Lv_IdFormaPago;

      -- si no existe se relaciona la forma de pago con la factura
      if c_verifica_fp%notfound then

        insert into cp_forma_pago_doc ( id_compania, id_documento, id_forma_pago, tipo_documento, usr_creacion, fe_creacion)
           values ( pCia, rd.no_refe, rd.id_forma_pago, rd.tipo_refe, user, sysdate);

      end if;
      close c_verifica_fp;
    END IF;
    --
    -- marca que la referencia ha sido procesada.
    UPDATE arcprd
       SET ind_procesado = 'S'
     WHERE ROWID = rd.registro_rd;

    vcod_estado := NULL;

    -- registra estado final
    CPRegistra_Estado(pCia, rd.no_prove, rd.no_refe, rd.tipo_refe, 'F', vcod_estado);
  END LOOP;

  IF NVL(abs(reg_doc.saldo), 0) > 0 THEN
    --
    -- Actualiza Historicos si el movimiento es de otros meses
    IF ((vAno_Proc * 100) + vMes_Proc) > ((reg_doc.ano_doc * 100) + reg_doc.mes_doc) THEN

      CPAct_Historico(pCia, pProve, reg_doc.fecha, abs(reg_doc.saldo), reg_doc.tipo_mov, vmes_proc, vano_proc, reg_doc.moneda);

    ELSE
      --
      -- Actualiza el estado de cuenta del proveedor
      CPActualiza_saldo_prove(pCia, pProve, reg_doc.tipo_mov,reg_doc.moneda, abs(reg_doc.saldo), reg_doc.tipo_cambio, reg_doc.documento, reg_doc.fecha, pError);

    END IF;

    --
    -- valida que no se haya producido ningun error en la actualizacion de saldos.
    IF pError IS NOT NULL THEN
      RAISE error_proceso;
    END IF;

  END IF;

  -- --
  --  Traslada los impuestos al modulo de contabilidad para emision de
  --  libro de impuestos
  --
  pError := NULL;
  CPTraslada_Impuestos(pCia, pDocu, pError);
  IF pError IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  --
  -- Retenciones incluidas - Guatemala.
  -- Si el pago de las retenciones se da al *aplicar* la factura se
  -- genera una nota de debito para cancelar el monto de la retencion
  -- Documentos de CREDITO.
  IF (vInd_forma_ret = 'F') AND (reg_doc.tipo_mov = 'C') THEN
    -- Aun no tiene doc final de pago (pNo_docu_pago = NULL)
    Notas_Retencion(pProve, pTipo, pDocu, reg_doc.fecha, NULL);
  END IF;

  -- llindao: 03/09/2012
  -- Actualziacion de Ordenes de Compras Locales
  IF (reg_doc.tipo_mov = 'C') THEN
    --
    FOR Lr_Origen IN C_ORDEN_COMPRA_LOCAL(pDocu, pTipo, pCia) LOOP
      -- se verifica saldo de Orden de compra.
      IF C_SALDO_OC_LOCAL%ISOPEN THEN
        CLOSE C_SALDO_OC_LOCAL;
      END IF;
      OPEN C_SALDO_OC_LOCAL(Lr_Origen.No_Documento_Origen,Lr_Origen.Compania);
      FETCH C_SALDO_OC_LOCAL
        INTO Lr_Saldo;
      IF C_SALDO_OC_LOCAL%NOTFOUND THEN
        Lr_Saldo.Valor_x_Facturar := 0;
      END IF;
      CLOSE C_SALDO_OC_LOCAL;

      IF Lr_Saldo.Valor_x_Facturar < Lr_Origen.Monto THEN
        pError := 'Saldo de la Orden Compra: '||Lr_Origen.No_Documento_Origen||' Con Valor: '||Lr_Saldo.Valor_x_Facturar || ' no cubre valor para la Factura:'||Lr_Origen.No_Documento;
        RAISE error_proceso;
      END IF;

      UPDATE TAPORDEE A
         SET A.VALOR_FACTURADO = A.VALOR_FACTURADO + Lr_Origen.Monto
       WHERE A.NO_ORDEN = Lr_Origen.No_Documento_Origen
         AND A.NO_CIA = Lr_Origen.Compania;


      -- mnavarrete: el actualiza el estado de la Orden relacionada al Pedido
      ---------------------------------------------- 
      -- Cursor para traer informacion del Pedido
      ---------------------------------------------- 
      Open  C_PEDID_ORD (pCia, Lr_Origen.No_Documento_Origen);
      Fetch C_PEDID_ORD INTO Lr_Pedid_Ord;
      Close C_PEDID_ORD;

      -- Si (A.TOTAL - A.VALOR_FACTURADO) VALOR_X_FACTURAR  menos el valor del documento de registro es 0, 
      -- cambiar el estado del pedido a "Pagada"       
      IF (Lr_Saldo.Valor_x_Facturar - Lr_Origen.Monto) = 0  THEN
        UPDATE DB_COMPRAS.INFO_ORDEN_COMPRA
           SET ESTADO = 'Pagada'
         WHERE ID_ORDEN_COMPRA = Lr_Pedid_Ord.ID_ORDEN_COMPRA;
      END IF;

      -- Si (A.TOTAL - A.VALOR_FACTURADO) VALOR_X_FACTURAR  menos el valor del documento de registro es mayor a 0, 
      -- cambiar estado del pedido a "PagoParcial"
      IF (Lr_Saldo.Valor_x_Facturar - Lr_Origen.Monto) > 0  THEN
        --
        UPDATE DB_COMPRAS.INFO_ORDEN_COMPRA
           SET ESTADO = 'PagoParcial'
         WHERE ID_ORDEN_COMPRA = Lr_Pedid_Ord.ID_ORDEN_COMPRA;
      END IF;  
      --     
    END LOOP;
    --
    --
    -- Actualizacon de ingresos a bodegas
    -- documentos orige ingresos a bodegas
    FOR Lr_Origen IN C_INGRESO_BODEGA (pDocu, pTipo, pCia) LOOP
      --
      IF Lr_Origen.Saldo_Ib < Lr_Origen.Monto THEN
        pError := 'Saldo de Ingreso Bodega: '||Lr_Origen.No_Documento_Origen||' Con Valor: '||Lr_Origen.Saldo_Ib || ' no cubre valor para la Factura:'||Lr_Origen.Monto;
        RAISE error_proceso;
      END IF;
      --
      UPDATE NAF47_TNET.ARINME ME
      SET ME.MONTO_FACTURADO = ME.MONTO_FACTURADO + Lr_Origen.Monto
      WHERE ME.NO_DOCU = Lr_Origen.No_Documento_Origen
      AND ME.NO_CIA = Lr_Origen.Compania;
      --
    END LOOP;
    --

  END IF;

  --
  IF reg_doc.tipo_mov = 'C' THEN
    Lv_TipoProceso := 'Procesar';
  ELSE
    Lv_TipoProceso := 'Reversar';
  END IF;
  --
  NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.P_DISTRIBUCION_COSTO_FACTURA ( pDocu,
                                                                     pCia,
                                                                     Lv_TipoProceso,
                                                                     pError);
    --
    IF pError IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
    --

  --
  -- Completar el proceso de anulacion (Iniciado en CPAnula y CPAnula_CK).
  -- Se marcan los documentos como anulados y se deja el saldo en 0.
  -- El campo N_DOCU_A de Arcpmd indica si es una anulacion.
  IF reg_doc.n_docu_a IS NOT NULL THEN

    CPAct_anulacion(pCia, reg_doc.tipo_doc, reg_doc.no_docu,reg_doc.n_docu_a, reg_doc.fecha, (vInd_forma_ret IS NOT NULL), reg_doc.usuario_anula, reg_doc.motivo_anula, vAno_proc, vMes_proc, pError);

    IF pError IS NOT NULL THEN
      RAISE error_proceso;
    END IF;

  END IF;

EXCEPTION
   WHEN error_proceso THEN
     pError := NVL(pError, 'EN CPActualiza');
     RETURN;
   WHEN consecutivo.error THEN
     pError := 'CPActualiza : ' || NVL(pError, 'EN Consecutivo');
     RETURN;
   WHEN OTHERS THEN
     pError := 'CPActualiza : ' || SQLERRM;
     RETURN;
END CPActualiza;
/