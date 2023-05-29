CREATE OR REPLACE PROCEDURE NAF47_TNET.CPACT_ANULACION (
  pCia            arcpmd.no_cia%type,
  pTipo_doc       arcpmd.tipo_doc%TYPE, -- tipo_doc anulacion
  pNo_Docu        arcpmd.no_docu%TYPE,  -- no_docu anulacion
  pNo_Docu_anular arcpmd.no_docu%TYPE,  -- no_docu a anular
  pFecha_anula    date,                 -- fecha del doc anulacion
  pUsa_Retenc_Inc boolean,              -- usa retenciones Guatemala?
  pUsuario_anula  arcpmd.usuario_anula%TYPE,
  pMotivo_anula   arcpmd.usuario_anula%TYPE,
  pAno_proc       number,
  pMes_proc       number,
  pError          IN OUT varchar2
) IS
  --

/**
 * Documentacion para CPAct_anulacion 
 * Se encarga de actualizar el saldo, el indicador de anulado, y el
 * libro de compras despues de aplicarse un documento de anulacion.
 * Ademas, si el documento a anular proviene de Cheques revierte
 * las referencias y las sustituye por una ref. del doc a anular hacia
 * el doc de anulacion.
 * Si la compa?ia maneja retenciones incluidas de Guatemala, actualiza
 * tambien el campo no_docu_pago de la tabla arcbbo. * 
 *
 * @author yoveri
 * @version 1.0 01/01/2007
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 17/12/2019 Se modifica para considerar los nuevos campos de anulación de comprobantes electronicos 
 *                         y anulación de retenciones electrónicas.
 * 
 * @param pCia            IN arcpmd.no_cia%TYPE recibe codigo de compania
 * @param pTipo_doc       IN arcpmd.tipo_doc%TYPE recibe tipo de documento
 * @param pNo_Docu        IN arcpmd.no_docu%TYPE recibe numero transaccion cxp
 * @param pNo_Docu_anular IN arcpmd.no_docu%TYPE recibe numero transaccion cxp a anular
 * @param pFecha_anula    IN Date  recibe fecha transaccion cxp
 * @param pUsa_Retenc_Inc IN Boolean recibe si documento incluye retenciones
 * @param pUsuario_anula  IN arcpmd.usuario_anula%TYPE recibe usuario anula documento
 * @param pMotivo_anula   IN arcpmd.usuario_anula%TYPE, recibe motivo anula documento
 * @param pAno_proc       IN number recibe anio de proceso
 * @param pMes_proc       IN number recibe mes de proceso
 * @param pError          IN OUT VARCHAR2 retorma mensaje de error
 *  
 */

 --
  -- Datos del doc a anular
  CURSOR c_datos_doc(docu_p arcpmd.no_docu%TYPE) IS
    SELECT a.no_cia,
           a.tipo_doc, 
           a.no_docu,
           a.monto,  
           a.moneda,
           a.no_prove, 
           a.origen,
           a.documento_id_comp_elect,
           a.rowid
      FROM arcpmd a
     WHERE a.no_cia  = pcia
       AND a.no_docu = docu_p;
  --
  CURSOR c_referencias(docu_p arcprd.no_docu%TYPE) IS
    SELECT r.no_refe, r.monto_refe, r.moneda_refe, r.rowid,
           d.fecha, t.tipo_mov, d.no_prove, r.id_forma_pago
      FROM arcprd r, arcpmd d, arcptd t
     WHERE r.no_cia        = pCia
       AND r.no_docu       = docu_p
       AND r.ind_procesado = 'S'
       AND d.no_cia        = r.no_cia
       AND d.no_docu       = r.no_refe
       AND t.no_cia        = r.no_cia
       AND t.tipo_doc      = r.tipo_refe;
  --
  rDocu       c_datos_doc%rowtype;
  vMes_anula  arcprd.mes%type;
  vAno_anula  arcprd.ano%type;
  vExiste     boolean;
BEGIN
  --
  -- trae datos del documento a anular
  OPEN  c_datos_doc(pNo_docu_anular);
  FETCH c_datos_doc INTO rDocu;
  vExiste := c_datos_doc%found;
  CLOSE c_datos_doc;
  IF NOT vExiste THEN
    pError := 'El documento a anular '||pNo_Docu_anular||' no existe';
    return;
  END IF;
  vMes_anula := to_number(to_char(pFecha_anula, 'MM'));
  vAno_anula := to_number(to_char(pFecha_anula, 'YYYY'));
  -- Si se anula un documento del sistema de Cheques
  -- se reversan las referencias
  IF rDocu.origen = 'CK' THEN
    -- Reversa los abonos aplicados
    FOR r IN c_referencias(pNo_Docu_anular) LOOP
      UPDATE arcpmd
         SET saldo = nvl(saldo,0) + nvl(r.monto_refe,0)
       WHERE no_cia  = pCia
         AND no_docu = r.no_refe;
      
      -- la forma de pago se elimina si no existen otras formas de pago
      -- ingresados por otros documentos
      delete cp_forma_pago_doc a
       where a.id_documento = r.no_refe
         and a.id_compania = pCia
         and not exists ( select null from arcprd b
                           where b.id_forma_pago = a.id_forma_pago
                             and b.no_refe = a.id_documento
                             and b.no_cia = a.id_compania
                             and b.no_docu != pNo_Docu_anular
                             );
      
      --
      -- Borra las referencias que tiene asociado el documento
      -- que se esta anulando, para evitar confusiones en el
      -- historial de documentos
      DELETE arcprd
       WHERE rowid = r.rowid;

      --
      -- Por cada referencia desligada, debe refrescar el saldo del proveedor
      IF ((pAno_Proc * 100) + pMes_Proc) > ((vAno_anula * 100) + vMes_anula) THEN

        CPAct_Historico(pCia, rdocu.no_prove, r.fecha, r.Monto_refe,
                        r.tipo_Mov, pMes_proc, pAno_proc,r.moneda_refe);

/*CREATE OR REPLACE PROCEDURE CPACT_HISTORICO
 (PCIA IN VARCHAR2
 ,PPROVE IN VARCHAR2
 ,PFECHA IN DATE
 ,PMONTO IN NUMBER
 ,PTIPO IN VARCHAR2
 ,PMES_PROC IN NUMBER
 ,PANO_PROC IN NUMBER
 )
 IS

        CPAct_Historico(pCia, rdocu.no_prove, r.fecha,
                        r.Monto_refe, r.moneda_refe, r.tipo_Mov,
                        pMes_proc, pAno_proc, pError);
  */


      ELSE
        --
        -- Actualiza el estado de cuenta del proveedor
        CPActualiza_saldo_prove(pCia, rdocu.no_prove, r.tipo_mov, r.moneda_refe,
                                r.monto_refe, null, null, r.fecha, pError);
      END IF;

    END LOOP;
    --
    -- La anulacion es de tipo Credito
    -- Inserta una referencia desde el cheque hacia el doc de anulacion.
    INSERT INTO arcprd(no_cia, tipo_doc, no_docu, tipo_refe, no_refe,
                       monto, descuento_pp, monto_refe, moneda_refe,
                       fec_aplic, mes, ano, ind_procesado, no_prove)
                VALUES(pCia, rDocu.tipo_doc, pNo_docu_anular, pTipo_doc, pNo_docu,
                       rDocu.monto, 0, rDocu.monto, rDocu.moneda,
                       pFecha_anula, vMes_anula, vAno_anula, 'S', rdocu.no_prove);
  END IF;
  -- En el libro de compras deben quedar registrados
  -- ambos documentos (doc a anular + anulacion), o ninguno
  CPAnula_Libro_Compras(pCia, pTipo_Doc, pNo_Docu, rDocu.tipo_doc, pNo_Docu_anular);
  --
  -- Marcar como Anulado el doc de anulacion
  UPDATE arcpmd
     SET anulado        = 'S',
         saldo          = 0,
         saldo_nominal  = 0,
         ano_anulado    = vAno_anula,
         mes_anulado    = vMes_anula
   WHERE no_cia  = pCia
     AND no_docu = pNo_docu;
  --
  -- Marcar como Anulado el doc a anular
  UPDATE arcpmd
     SET anulado        = 'S',
         saldo          = 0,
         saldo_nominal  = 0,
         ano_anulado    = vAno_anula,
         mes_anulado    = vMes_anula,
         usuario_anula  = pUsuario_anula,
         motivo_anula   = pMotivo_anula,
         estado_sri     = decode(Documento_Id, null, estado_sri, 8),
         comp_ret_anulada = decode(Documento_Id, null, comp_ret_anulada, comp_ret),
         comp_ret       = decode(Documento_Id, null, comp_ret, null),
         nombre_archivo = decode(Documento_Id, null, nombre_archivo, null),
         numero_envio_sri = decode(Documento_Id, null, numero_envio_sri, 0),
         est_sri_comp_elect = decode(documento_id_comp_elect, null, estado_sri, 8),
         num_envio_comp_elect = decode(documento_id_comp_elect, null, num_envio_comp_elect, 0),
         archivo_comp_elect = decode(documento_id_comp_elect, null, archivo_comp_elect, null)
   WHERE rowid = rDocu.rowid;
  --
  -- si documento anular tiene retención electronica, se debe anular en comprobantes
  UPDATE DB_COMPROBANTES.INFO_DOCUMENTO IDC
  SET IDC.ESTADO_DOC_ID = 8
  WHERE EXISTS (SELECT NULL
                FROM NAF47_TNET.ARCPMD MD
                WHERE MD.DOCUMENTO_ID = IDC.ID_DOCUMENTO
                AND MD.NO_CIA = rDocu.No_Cia
                AND MD.NO_DOCU = rDocu.No_Docu);
  --
  -- si documento a anular es un comprobante electronico, se anula en modulo comprobantes.
  UPDATE DB_COMPROBANTES.INFO_DOCUMENTO IDC
  SET IDC.ESTADO_DOC_ID = 8
  WHERE EXISTS (SELECT NULL
                FROM NAF47_TNET.ARCPMD MD
                WHERE MD.DOCUMENTO_ID_COMP_ELECT = IDC.ID_DOCUMENTO
                AND MD.NO_CIA = rDocu.No_Cia
                AND MD.NO_DOCU = rDocu.No_Docu);

  --
  
  IF pUsa_Retenc_Inc THEN
    --
    -- arcbbo.no_docu_pago guarda el numero de transaccion del documento que
    -- termino de cancelar una factura determinada, pero solamente en el caso de
    -- que la retencion se pague al momento del pago (arcppr.ind_forma_ret = 'P').
    -- Si la retencion se genera al momento de la aplicacion (provision) esta columna es NULL.
    --
    -- Si se anula este documento de pago se regresa el estado de la boleta a Actualizada ('A'),
    -- y limpia el numero del doc que cancelo la factura, y los datos de la boleta generada.
    -- Pero si la boleta ya fue pagada ('C') solo se actualiza el numero del doc pago.
    --
    UPDATE arcbbo
       SET estatus_boleta   = decode(estatus_boleta, 'C', 'C', 'A'),
           no_fisico_boleta = decode(estatus_boleta, 'C', no_fisico_boleta, NULL),
           no_docu_pago     = NULL
     WHERE no_cia         = pCia
       AND no_prove       = rDocu.no_prove
       AND no_docu_pago   IS NOT NULL
       AND no_docu_pago   = pNo_docu_anular
       AND estatus_boleta IS NOT NULL -- que la retencion ya ha sido generada
       AND estatus_boleta <> 'X';     -- y que el doc que la genero no haya sido anulado
  END IF;
END CPAct_anulacion;
/

