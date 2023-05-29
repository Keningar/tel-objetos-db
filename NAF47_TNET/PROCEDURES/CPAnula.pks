CREATE OR REPLACE PROCEDURE NAF47_TNET.CPAnula(
  pCia            IN     VARCHAR2,
  pTipo           IN     VARCHAR2, -- Tipo de doc a anular
  pDocu           IN     VARCHAR2, -- Doc a anular
  pFecha_anula    IN     DATE,     -- Fecha de anulacion
  pMotivo         IN     VARCHAR2,
  pmsg_error      IN OUT VARCHAR2
) IS
  --
  --
/**
 * Documentacion para CPANULA 
 *
 * Anula el documento pasado como parametro (credito o debito) insertando
 * un documento de tipo anulacion (arcptd.ind_anulacion = 'S') y
 * con tipo de movimiento inverso. El documento a anular NO debe tener
 * movimientos aplicados, excepto por retenciones incluidas (Guatemala).
 * Solamente se anulan documentos correspondientes al periodo en proceso.
 *
 * @author yoveri
 * @version 1.0 01/01/2007
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 17/12/2019 Se modifica anular retencion electronica asociadas al documento que se reversa
 * 
 * @param pCia         IN VARCHAR2     recibe codigo de compania
 * @param pTipo        IN VARCHAR2     recibe tipo de documento
 * @param pProve       IN VARCHAR2     recibe codigo de proveedor
 * @param pFecha_anula IN DATE         recibe fecha de anulacion
 * @param pMotivo      IN VARCHAR2     recibe texto del motivo de anulacion
 * @param pmsg_Error   IN OUT VARCHAR2 retorma mensaje de erro
 */

  -- periodo de proceso cxp
  CURSOR c_per_proce IS
    SELECT ano_proc, mes_proc
      FROM arcpct
     WHERE no_cia = pcia;
  --
  -- Datos del doc a anular
  CURSOR c_datos_doc(pNo_docu arcpmd.no_docu%TYPE) IS
    SELECT a.no_prove, a.monto, a.saldo, a.moneda,
           nvl(a.tot_ret_especial,0) tot_ret_especial,
           a.bloqueado, a.anulado, a.tipo_cambio,
           a.no_fisico, a.serie_fisico, a.fecha,
           a.excentos, a.gravado, a.tipo_doc, a.usuario_anula,
           a.tot_db, a.tot_cr, a.descuento, a.monto_nominal,
           a.monto_bienes, a.monto_serv, a.monto_importac,
           a.t_camb_c_v, a.ind_act, a.rowid, b.tipo_mov
      FROM arcpmd a, arcptd b
     WHERE a.no_cia   = pcia
       AND a.no_docu  = pNo_docu
       AND b.no_cia   = a.no_cia
       AND b.tipo_doc = a.tipo_doc;
  --
  -- Obtener el documento de anulacion segun el tipo de mov del doc a anular
  CURSOR c_tipo_anulacion (pTipo_mov arcptd.tipo_mov%TYPE) IS
    SELECT tipo_doc, cod_diario, tipo_mov
      FROM arcptd
     WHERE no_cia        = pCia
       AND tipo_mov      = decode(pTipo_mov,'D','C','D')
       AND ind_anulacion = 'S';
  --
  CURSOR c_detalle_pago (pCia varchar2, pDocu varchar2) IS
    SELECT 'x'
      FROM arcpdp
     WHERE no_cia  = pCia
       AND no_docu = pDocu;
  --
  CURSOR c_refe_cheque (pCia varchar2, pDocu varchar2) IS
    SELECT 'x'
      FROM arckrd rd, arckce ce
     WHERE rd.no_cia  = pCia
       AND rd.no_refe = pDocu
       AND ce.no_cia  = rd.no_cia
       AND ce.no_secuencia = rd.no_secuencia
       AND ce.anulado is null;   -- solo los considera si el cheque o transf. no ha sido anulado

  --
  --
  error_proceso  exception;
  --
  vExiste        boolean;
  --
  vtmp           varchar2(1);
  vFecha         date;
  vano_proce     arcpct.ano_proc%TYPE;
  vmes_proce     arcpct.mes_proc%TYPE;
  --
  rDocu          c_datos_doc%ROWTYPE;      -- Datos del doc a anular (pDocu)
  --
  rRev           c_tipo_anulacion%ROWTYPE; -- Datos del doc de anulacion
  --
  vNo_docu_rev   arcpmd.no_docu%TYPE;      -- Transaccion doc anulacion
  --
  vSaldo_doc     arcpmd.saldo%TYPE;        -- Saldo doc anulacion
  vTotal_ref     arcpmd.tot_refer%TYPE;    -- Total referencias doc anulacion
  --
  --
BEGIN
  --
  -- trae datos del documento a anular
  OPEN  c_datos_doc(pdocu);
  FETCH c_datos_doc INTO rDocu;
  vExiste := c_datos_doc%FOUND;
  CLOSE c_datos_doc;

  IF NOT vExiste THEN
    pmsg_error := 'El documento '||rDocu.tipo_doc||' '||
                  rDocu.no_fisico||'-'||rDocu.serie_fisico||
                  ' no existe';
    RAISE error_proceso;
  END IF;

  -- Los docs pendientes se borran, no se anulan.
  IF rDocu.ind_act = 'P' THEN
    pmsg_error := 'El documento '||rDocu.tipo_doc||' '||
                  rDocu.no_fisico||'-'||rDocu.serie_fisico||
                  ' esta Pendiente de actualizar';
    RAISE error_proceso;
  END IF;

  IF rDocu.anulado = 'S' THEN
    pmsg_error := 'El documento '||rDocu.tipo_doc||' '||
                  rDocu.no_fisico||'-'||rDocu.serie_fisico||
                  ' ya fue anulado por '||rDocu.usuario_anula;
    RAISE error_proceso;
  END IF;
  --
  -- trae el periodo en proceso de CxP
  OPEN  c_per_proce;
  FETCH c_per_proce INTO vAno_proce, vMes_proce;
  CLOSE c_per_proce;
  --
  -- Solamente se anulan documentos del periodo en proceso
  IF to_char(rDocu.fecha, 'MMYYYY') <> to_char(vMes_proce, 'FM00')||to_char(vAno_proce, 'FM0000') THEN
    pmsg_error := 'El documento '||rDocu.tipo_doc||' '||
                  rDocu.no_fisico||'-'||rDocu.serie_fisico||
                  ' no puede ser anulado porque no corresponde al periodo en proceso';
    RAISE error_proceso;
  END IF;

  --
  -- verifica que el documento a anular, no este en Seleccion de Pago en CxP
  OPEN  c_detalle_pago (pCia, pDocu);
  FETCH c_detalle_pago INTO vtmp;
  vExiste := c_detalle_pago%found;
  CLOSE c_detalle_pago;

  IF vExiste THEN
    pmsg_error := 'El documento se encuentra en Seleccion de Detalle de Pago';
    RAISE error_proceso;
  END IF;

  --
  -- Verifica que el documento a anular, no se encuentre referenciado por un Cheque o Transferencia
  OPEN  c_refe_cheque (pCia, pDocu);
  FETCH c_refe_cheque INTO vtmp;
  vExiste := c_refe_cheque%found;
  CLOSE c_refe_cheque;

  IF vExiste THEN
    pmsg_error := 'El documento se encuentra referenciado por un Cheque o Transferencia';
    RAISE error_proceso;
  END IF;

  --
  -- Traer datos del documento de anulacion
  OPEN  c_tipo_anulacion(rDocu.tipo_mov);
  FETCH c_tipo_anulacion INTO rRev;
  vExiste := c_tipo_anulacion%FOUND;
  CLOSE c_tipo_anulacion;

  IF NOT vExiste THEN
    pmsg_error := 'No se encontro el tipo de documento de anulacion';
    RAISE error_proceso;
  END IF;
  --
  -- Anula la nota de retencion incluida (Guatemala)
  CPAnula_Notas_Retencion(pCia, pDocu, pFecha_anula, pMotivo, pmsg_error);
  IF pmsg_error IS NOT NULL THEN
    RAISE error_proceso;
  END IF;

  -- Refresca datos del documento a anular.
  -- El saldo puede haber sido modificado por CPAnula_Notas_Retencion.
  OPEN  c_datos_doc(pdocu);
  FETCH c_datos_doc INTO rDocu;
  CLOSE c_datos_doc;

  -- El documento no debe tener movimientos aplicados
  IF rDocu.monto <> abs(rDocu.saldo) THEN
    pmsg_error := 'El documento '||rDocu.tipo_doc||' '||
                  rDocu.no_fisico||'-'||rDocu.serie_fisico||
                  ' tiene movimientos aplicados. No puede ser anulado.';
    RAISE error_proceso;
  END IF;

  IF rRev.tipo_mov = 'C' THEN
	  -- la anulacion es un Credito.
    vSaldo_doc := rDocu.monto;
    vTotal_ref := 0;
  ELSE -- vtipo_anul = 'D'
  	-- la anulacion es un Debito.
    vSaldo_doc := 0;
    vTotal_ref := rDocu.monto;
  END IF;

  --
  -- Registra el documento de anulacion en CxP
  -- El numero de control y serie fisico se asignan cuando se aplica la anulacion
  --
  vNo_docu_rev := Transa_Id.CP(pCia);
  vFecha       := pFecha_anula;

  INSERT INTO arcpmd(no_cia, no_prove, tipo_doc,
                     no_docu, ind_act, fecha, subtotal,
                     monto, saldo, saldo_nominal,
                     tot_refer, tot_db, tot_cr,
                     tipo_cambio, moneda,
                     cod_diario, fecha_documento, origen,
                     detalle,
                     excentos, gravado, descuento,
                     monto_nominal,t_camb_c_v, monto_bienes,
                     monto_serv, monto_importac,
                     n_docu_a, usuario_anula,FECHA_ANULA, motivo_anula)
              VALUES(pcia, rDocu.no_prove, rRev.tipo_doc,
                     vNo_docu_rev, 'P', vFecha, rDocu.monto,
                     rDocu.monto, vSaldo_doc, vSaldo_doc,
                     vTotal_ref, rDocu.tot_db, rDocu.tot_cr,
                     rDocu.tipo_cambio, rDocu.moneda,
                     rRev.cod_diario, vFecha, 'CP',
                     'Anulacion de '||rDocu.tipo_doc||' '||rDocu.no_fisico||
                         '  Serie : '||rDocu.serie_fisico||'  Transaccion : '||pDocu,
                     rDocu.excentos, rDocu.gravado, rDocu.descuento,
                     rDocu.monto_nominal, rDocu.t_camb_c_v, rDocu.monto_bienes,
                     rDocu.monto_serv, rDocu.monto_importac,
                     pDocu, USER, TRUNC(SYSDATE),pMotivo);

  --
  -- Inserta la referencia al doc a anular
  --
  IF rRev.tipo_mov = 'D' THEN
  	-- Anula un credito.
  	-- Inserta la referencia a la factura.
    INSERT INTO arcprd(no_cia, tipo_doc, no_docu, tipo_refe, no_refe,
                       monto, descuento_pp, monto_refe, moneda_refe,
                       fec_aplic, mes, ano,no_prove)
                VALUES(pCia, rRev.tipo_doc, vNo_docu_rev, rDocu.tipo_doc, pdocu,
                       rDocu.monto, 0, rDocu.monto, rDocu.moneda,
                       vFecha, to_char(vFecha, 'MM'), to_char(vFecha, 'YYYY'), rDocu.no_prove);

  ELSE -- rRev.tipo_mov = 'C'
    -- Anula un debito.
    -- Inserta una referencia del doc de debito al doc de anulacion.
    INSERT INTO arcprd(no_cia, tipo_doc, no_docu, tipo_refe, no_refe,
                       monto, descuento_pp, monto_refe, moneda_refe,
                       fec_aplic, mes, ano, ind_procesado,no_prove)
                VALUES(pCia, rDocu.tipo_doc, pdocu, rRev.tipo_doc, vNo_docu_rev,
                       rDocu.monto, 0, rDocu.monto, rDocu.moneda,
                       vFecha, to_char(vFecha, 'MM'), to_char(vFecha, 'YYYY'), 'S', rDocu.no_prove);

  END IF;

  --
  -- Revierte el detalle contable
  --
  INSERT INTO arcpdc(no_cia, no_prove, tipo_doc, no_docu,
                     codigo, tipo,
                     monto, ind_con, ano, mes,
                     monto_dol, moneda, monto_dc,
                     tipo_cambio, centro_costo,
                     modificable, codigo_tercero)
              SELECT no_cia, no_prove, rRev.tipo_doc, vNo_docu_rev,
                     codigo, decode(tipo,'D','C','D'),
                     monto, 'P', vAno_proce, vMes_proce,
                     monto_dol, moneda, monto_dc,
                     tipo_cambio, centro_costo,
                     modificable, codigo_tercero
                FROM arcpdc
               WHERE no_cia  = pCia
                 AND no_docu = pDocu;

  --
  -- Inserta el detalle de impuestos
  INSERT INTO arcpti (no_cia, no_prove, tipo_doc, no_docu,
                      clave, porcentaje, monto, ind_imp_ret,
                      aplica_cred_fiscal, base, codigo_tercero,
                      comportamiento, id_sec, no_refe)
               SELECT no_cia, no_prove, rRev.tipo_doc, vNo_docu_rev,
                      clave, porcentaje, monto, ind_imp_ret,
                      aplica_cred_fiscal, base, codigo_tercero,
                      comportamiento, id_sec, no_refe
                 FROM arcpti
                WHERE no_cia  = pCia
                  AND no_docu = pDocu;
  --
  --  MNA (23/01/2007) 
  --  Cambia estado de Anulado a documento
      Update arcpti  Set anulada = 'S', SECUENCIA_RET = '', AUTORIZACION = ''
      Where no_cia  = pCia  AND no_docu = pDocu;
  --
  --
  -- Aplica el documento de anulacion. CPActualiza tambien se encarga de
  -- modificar el saldo y el estado de los documentos, asi como el libro de compras.
  CPActualiza(pCia, rDocu.no_prove, rRev.tipo_doc, vNo_docu_rev, pmsg_error);

  IF pmsg_error IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  --
  --
  IF rDocu.Tipo_Mov = 'C' THEN
    --
    NAF47_TNET.PRKG_CONTROL_PRESUPUESTO.P_DISTRIBUCION_COSTO_FACTURA ( pDocu,
                                                                       pCia,
                                                                       'Reversar',
                                                                       pmsg_error);
    --
    IF pmsg_error IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
    --
  END IF;


EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := 'CPANULA: '||pmsg_error;
     return;
  WHEN consecutivo.error THEN
     pmsg_error := 'CPANULA: '||nvl(consecutivo.ultimo_error, 'EN Consecutivo');
     return;
  WHEN transa_id.error THEN
     pmsg_error := 'CPANULA: '||nvl(transa_id.ultimo_error, 'EN Transa_id');
     return;
  WHEN others THEN
     pmsg_error := 'CPANULA: '||sqlerrm;
     return;
END;
/