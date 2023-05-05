create or replace PROCEDURE            CPAnula_Notas_Retencion(
--
-- Retenciones Incluidas (Guatemala)
-- Anula la nota de retencion del documento pasado como parametro (credito o debito)
-- La anulacion se realiza insertando un documento con movimiento inverso.
-- Este procedimiento es llamado desde CPAnula.
--
-- NOTA: Este procedimiento *MODIFICA EL SALDO* de pDocu,
--       y sustituye la referencia de la nota de retencion.
--
-- Proceso:
-- 1. Inserta documento de reversion por el monto de la nota.
-- 2. Inserta la distribucion contable del doc de reversion
-- 3. Cambia la referencia existente de la nota a anular para que se cancele con el doc de reversion
-- 4. Marca la boleta del documento como Anulada (arcbbo.estado_boleta = 'X')
-- 5. Corrige el saldo del documento, sumandole o restandole el monto de la nota anulada
-- 6. Aplica el documento de reversion
--
-- Si el cliente es de retencion Cero, solo se marca la boleta como Anulada ('X')
--

  pCia         IN     VARCHAR2,
  pDocu        IN     VARCHAR2, -- Documento al cual se le anula la nota
  pFecha_anula IN     DATE,     -- Fecha de anulacion
  pMotivo      IN     VARCHAR2, -- Motivo de la anulacion
  msg_error_p  IN OUT VARCHAR2
) IS

  -- Datos de la factura
  CURSOR c_docu(pNo_docu arcpmd.no_docu%TYPE) IS
    SELECT nvl(a.tot_ret_especial,0) tot_ret_especial,
           a.saldo,  a.anulado,   a.ind_act,  a.bloqueado,
           a.moneda, a.no_prove,  a.tipo_doc, a.tipo_cambio,
           a.fecha,  a.no_fisico, a.serie_fisico,
           a.monto, b.tipo_mov, a.rowid
      FROM arcpmd a, arcptd b
     WHERE a.no_cia   = pCia
       AND a.no_docu  = pNo_docu
       AND b.no_cia   = a.no_cia
       AND b.tipo_doc = a.tipo_doc;

  -- Ver si la compania usa retenciones incluidas
  CURSOR c_usa_ret IS
    SELECT 'x'
      FROM arcppr
     WHERE no_cia = pCia;

  -- Tipo de documento de la nota de retencion
  --   pTipo_mov es el tipo de mov del doc al cual se le va a generar la nota
  CURSOR c_tipo_Nota(pTipo_mov arcptd.tipo_mov%TYPE) IS
    SELECT decode(pTipo_mov, 'C', pr.tipo_doc_nd_ret, pr.tipo_doc_nc_ret) tipo_doc,
           decode(pTipo_mov, 'C', td.tipo_mov,        tc.tipo_mov)        tipo_mov
      FROM arcppr pr, arcptd td, arcptd tc
     WHERE pr.no_cia       = pCia
       AND td.no_cia   (+) = pr.no_cia
       AND td.tipo_doc (+) = pr.tipo_doc_nd_ret
       AND tc.no_cia   (+) = pr.no_cia
       AND tc.tipo_doc (+) = pr.tipo_doc_nc_ret;


  -- Datos de la nota a anular
  CURSOR c_Nota (pTipo_nota arcprd.tipo_doc%TYPE,
                 pTipo_doc  arcprd.tipo_refe%TYPE,
                 pNo_docu   arcprd.no_refe%TYPE,
                 pTipo_mov  arcptd.tipo_mov%TYPE) IS
    SELECT b.tipo_doc, b.no_docu,  b.monto, b.ind_act,
           b.anulado,  b.no_prove, b.tipo_cambio,
           b.numero_ctrl, b.serie_fisico, b.fecha,
           b.tot_db, b.tot_cr, b.t_camb_c_v,
           b.monto_nominal, b.moneda,
           a.rowid rowid_Refe, b.rowid rowid_Nota
      FROM arcprd a, arcpmd b
     WHERE pTipo_mov   = 'D' -- cuando la nota es de tipo Debito
       AND a.no_cia    = pCia
       AND a.tipo_doc  = pTipo_nota
	     AND a.tipo_refe = pTipo_doc
	     AND a.no_refe   = pNo_docu
	     AND b.no_cia    = a.no_cia
	     AND b.no_docu   = a.no_docu
	  UNION ALL
    SELECT b.tipo_doc, b.no_docu,  b.monto, b.ind_act,
           b.anulado,  b.no_prove, b.tipo_cambio,
           b.numero_ctrl, b.serie_fisico, b.fecha,
           b.tot_db, b.tot_cr, b.t_camb_c_v,
           b.monto_nominal, b.moneda,
           a.rowid rowid_Refe, b.rowid rowid_Nota
      FROM arcprd a, arcpmd b
     WHERE pTipo_mov   = 'C' -- cuando la nota es de tipo Credito
       AND a.no_cia    = pCia
       AND a.tipo_doc  = pTipo_doc
	     AND a.no_docu   = pNo_docu
	     AND a.tipo_refe = pTipo_nota
	     AND b.no_cia    = a.no_cia
	     AND b.no_docu   = a.no_refe;

  -- Estado de la retencion (boleta en arcbbo)
  CURSOR c_estado_retenc(pNo_prove arcbbo.no_prove%TYPE,
                         pNo_docu  arcbbo.no_docu%TYPE) IS
    SELECT bo.cheque, bo.estatus_boleta, bo.no_fisico_boleta
      FROM arcbbo bo
     WHERE bo.no_cia   = pCia
       AND bo.no_prove = pNo_prove
       AND bo.no_docu  = pNo_docu;

  -- Obtener el documento de anulacion segun el tipo de mov.
	CURSOR c_tipo_anulacion (pTipo_mov arcptd.tipo_mov%TYPE) IS
    SELECT tipo_doc, cod_diario, tipo_mov
      FROM arcptd
     WHERE no_cia   = pCia
       AND tipo_mov = decode(pTipo_mov,'D','C','D')
       AND cplib.EsAnulacionSN(no_cia, tipo_doc) = 'S';

  -- A?o y mes de proceso de la compa?ia
  CURSOR c_per_proce IS
    SELECT ano_proc, mes_proc
      FROM arcpct
     WHERE no_cia = pCia;

  rDocu           c_docu%ROWTYPE;             -- Datos del documento al cual se le anula la nota
  rTipo_Nota      c_tipo_Nota%ROWTYPE;        -- Tipo de doc de nota de retencion
  rNota           c_Nota%ROWTYPE;             -- Datos de la Nota de retencion
  rEstado_Retenc  c_estado_retenc%ROWTYPE;    -- Estado de la retencion
  rRev            c_tipo_anulacion%ROWTYPE;   -- Datos del documento de anulacion
  --
  vNo_docu_rev    arcpmd.no_docu%TYPE;        -- Numero del doc de anulacion
  vSerie_fisico   arcpmd.serie_fisico%TYPE;   -- Serie fisico del doc de anulacion
  vEstatus_boleta arcbbo.estatus_boleta%TYPE; -- Resumen del estado de las boletas
  --
  vSaldo_doc      arcpmd.saldo%TYPE;
  vTotal_ref      arcpmd.tot_refer%TYPE;
  --
  vAno_proce      arcpct.ano_proc%TYPE;
  vMes_Proce      arcpct.mes_proc%TYPE;
  vFecha          DATE;
  vTemp           VARCHAR2(1);
  --
  error_proceso  EXCEPTION;
  vExiste        BOOLEAN;
BEGIN
  --
  -- Ver si la compania maneja retenciones incluidas
  --
  OPEN  c_usa_ret;
  FETCH c_usa_ret INTO vTemp;
  vExiste := c_usa_ret%FOUND;
  CLOSE c_usa_ret;

  --
  -- Si la compa?ia no existe en ARCPPR
  -- se supone que NO maneja las retenciones de Guatemala
  --
  IF NOT vExiste THEN
    RETURN;
  END IF;

  IF pDocu IS NULL THEN
    msg_error_p := 'El numero de factura es nulo';
    RAISE error_proceso;
  END IF;

  --
  -- Datos del doc al cual se le va a anular la nota de retencion
  --
  OPEN  c_docu(pDocu);
  FETCH c_docu INTO rDocu;
  vExiste := c_docu%FOUND;
  CLOSE c_docu;

  IF NOT vExiste THEN
    msg_error_p := 'No se encontro el documento con transaccion '||pDocu;
    RAISE error_proceso;
  END IF;

  -- Si la factura esta Pendiente, aun no se ha generado la ND
  IF rDocu.ind_act = 'P' THEN
    msg_error_p := 'El documento '||
                   rDocu.tipo_doc||' '||rDocu.no_fisico||'-'||
                   rDocu.serie_fisico||' esta pendiente de actualizar';
    RAISE error_proceso;
  END IF;

  -- Revisar el estado de las boletas.
  -- vEstatus_boleta debe quedar = 'C' si existe al menos alguna boleta Cancelada
  vExiste         := FALSE;
  vEstatus_boleta := NULL;
  FOR rEstado IN c_estado_retenc(rDocu.no_prove, pDocu) LOOP
    vExiste := TRUE;
    IF (vEstatus_boleta IS NULL) OR (vEstatus_boleta <> 'C') THEN
    	vEstatus_boleta := rEstado.estatus_boleta;
    END IF;
  END LOOP;

  -- La boleta no existe ??? o
  -- la nota no ha sido generada (ej: modalidad retencion al pago)
  IF (NOT vExiste) OR (vEstatus_boleta IS NULL) THEN
  	RETURN;
  END IF;

  -- El proveedor puede ser de retencion Cero, o el doc no tiene retencion
  -- solo se marca la boleta como anulada (si existe), no existe nota de retencion
  IF (rDocu.tot_ret_especial =   0 ) AND
  	 (vEstatus_boleta        <> 'C') THEN
    UPDATE arcbbo
       SET estatus_boleta = 'X'
     WHERE no_cia   = pCia
       AND no_prove = rDocu.no_prove
       AND no_docu  = pDocu;

    RETURN;

  END IF;

  --
  -- Leer el tipo doc de la nota a anular
  --
  OPEN  c_tipo_Nota(rDocu.tipo_mov);
  FETCH c_tipo_Nota INTO rTipo_Nota;
  vExiste := c_tipo_Nota%FOUND;
  CLOSE c_tipo_Nota;

  IF rTipo_Nota.tipo_doc IS NULL THEN
    msg_error_p := 'La compa?ia no tiene definido el tipo de documento de Nota de Retencion';
    RAISE error_proceso;
  END IF;

  IF rTipo_Nota.tipo_mov = rDocu.tipo_mov THEN
    msg_error_p := 'La Nota de Retencion y el documento que afecta no pueden tener el mismo tipo de movimiento';
    RAISE error_proceso;
  END IF;

  -- El documento esta anulado
  IF rDocu.anulado = 'S' THEN
    msg_error_p := 'El documento '||rDocu.tipo_doc||' '||
                   rDocu.no_fisico||'-'||rDocu.serie_fisico||' ya fue anulado.';
    RAISE error_proceso;
  END IF;

  -- Si la retencion ya fue cancelada, no puede ser anulada
  IF vEstatus_boleta = 'C' THEN
    msg_error_p := 'La retencion del documento '||rDocu.tipo_doc||' '||
                   rDocu.no_fisico||'-'||rDocu.serie_fisico||' ya fue cancelada con el cheque '||
                   rEstado_Retenc.cheque||'. No puede ser anulada';
    RAISE error_proceso;
  END IF;

  -- Traer los datos de la nota
  -- Se supone que deberia existir puesto que tot_ret_especial <> 0
  -- y se sabe que estado_boleta NO es nulo
  OPEN  c_Nota(rTipo_Nota.tipo_doc, rDocu.tipo_doc, pDocu,
               rTipo_Nota.tipo_mov);
  FETCH c_Nota INTO rNota;
  vExiste := c_Nota%FOUND;
  CLOSE c_Nota;

  IF NOT vExiste THEN
    msg_error_p := 'No se encontro la nota de retencion para el documento '||
                   rDocu.tipo_doc||' '||rDocu.no_fisico||'-'||rDocu.serie_fisico;
    RAISE error_proceso;
  END IF;

  -- La nota esta pendiente
  IF rNota.ind_act = 'P' THEN
    msg_error_p := 'La nota de retencion para el documento '||
                   rDocu.tipo_doc||' '||rDocu.no_fisico||'-'||rDocu.serie_fisico||
                   ' esta pendiente de actualizar.';
    RAISE error_proceso;
  END IF;

  -- La nota ya fue anulada
  IF rNota.anulado = 'S' THEN
    msg_error_p := 'La nota de retencion para el documento '||
                   rDocu.tipo_doc||' '||rDocu.no_fisico||'-'||rDocu.serie_fisico||
                   ' ya fue anulada.';
    RAISE error_proceso;
  END IF;

  --
  -- El documento no debe tener referencias, excepto la nota de retencion
  IF rDocu.monto <> (abs(rDocu.saldo) + rDocu.tot_ret_especial) THEN
    msg_error_p := 'El documento '||
                   rDocu.tipo_doc||' '||rDocu.no_fisico||'-'||rDocu.serie_fisico||
                   ' tiene movimientos aplicados. No puede ser anulado.';
    RAISE error_proceso;
  END IF;

  -- Traer el tipo doc de anulacion
  OPEN  c_tipo_anulacion(rTipo_Nota.tipo_mov);
  FETCH c_tipo_anulacion INTO rRev;
  vExiste := c_tipo_anulacion%FOUND;
  CLOSE c_tipo_anulacion;

  IF NOT vExiste THEN
    msg_error_p := 'No se encontro el tipo de documento de anulacion';
    RAISE error_proceso;
  END IF;

  -- A?o y mes de proceso
  OPEN  c_per_proce;
  FETCH c_per_proce INTO vAno_proce, vMes_proce;
  CLOSE c_per_proce;

  IF rRev.tipo_mov = 'C' THEN
	  -- la anulacion es un Credito
    vSaldo_doc := rNota.monto;
    vTotal_ref := 0;
  ELSE -- rRev.tipo_mov = 'D'
  	-- la anulacion es un Debito
    vSaldo_doc := 0;
    vTotal_ref := rNota.monto;
  END IF;

  --
  -- Registra la anulacion en CxP.
  -- El numero de control se asigna cuando se aplica.
  --
  vNo_docu_rev  := Transa_Id.CP  (pCia);
  vSerie_fisico := Consecutivo.CP(pCia, vAno_proce, vMes_proce,
                                  rRev.tipo_doc, 'SERIE');
  vFecha        := pFecha_anula;
  --
  -- crea el documento de anulacion pendiente de actualizar
  -- N_DOCU_A debe referenciar la nota que se esta anulando
  INSERT INTO arcpmd(no_cia, no_prove, tipo_doc,
                     no_docu, ind_act, fecha, subtotal,
                     monto, saldo, saldo_nominal,
                     tot_refer, tot_db, tot_cr,
                     monto_nominal, tipo_cambio, moneda,
                     t_camb_c_v, cod_diario, fecha_documento, origen,
                     detalle,
                     excentos, gravado, serie_fisico,
                     usuario_anula, motivo_anula, n_docu_a)
              VALUES(pCia, rNota.no_prove, rRev.tipo_doc,
                     vNo_docu_rev, 'P', vFecha, rNota.monto,
                     rNota.monto, vSaldo_doc, vSaldo_doc,
                     vTotal_ref, rNota.tot_db, rNota.tot_cr,
                     rNota.monto_nominal, rNota.tipo_cambio, rNota.moneda,
                     rNota.t_camb_c_v, rRev.cod_diario, vFecha, 'CP',
                     'Anulacion de '||rNota.tipo_doc||' '||rNota.numero_ctrl||
                         '  Serie : '||rNota.serie_fisico||'  Transaccion : '||rNota.no_docu,
                     rNota.monto, 0, vSerie_fisico,
                     USER, pMotivo, rNota.no_docu);

  --
  -- Inserta la distribucion contable
  INSERT INTO arcpdc(no_cia, no_prove, tipo_doc, no_docu,
                     codigo, tipo, monto,
                     mes, ano, ind_con, monto_dol, moneda, tipo_cambio,
                     no_asiento, centro_costo, modificable, codigo_tercero,
                     monto_dc)
              SELECT no_cia, no_prove, rRev.tipo_doc, vNo_docu_rev,
                     codigo, decode(tipo,'D','C','D'), monto,
                     mes, ano, 'P', monto_dol, moneda, tipo_cambio,
                     NULL, centro_costo, modificable, codigo_tercero,
                     monto_dc
                FROM arcpdc
               WHERE no_cia  = pCia
                 AND no_docu = rNota.no_docu;

  --
  -- Modifica la referencia de la nota para que apunte al doc de anulacion y
  -- Corrige el saldo del doc sumandole el monto de la retencion
  IF rRev.tipo_mov = 'C' THEN
  	-- La anulacion es un Credito. La nota a anular referencia la anulacion
    UPDATE arcprd
       SET tipo_refe = rRev.tipo_doc,
           no_refe   = vNo_docu_rev
    WHERE rowid = rNota.rowid_refe;

    -- Corrige el saldo del doc (de credito)
    UPDATE arcpmd
       SET saldo = saldo + rNota.monto
     WHERE rowid = rDocu.rowid;

  ELSE -- rRev.tipo_mov = 'D'
  	-- La anulacion es un Debito. La anulacion referencia la nota a anular
    UPDATE arcprd
       SET tipo_doc = rRev.tipo_doc,
           no_docu  = vNo_docu_rev
    WHERE rowid = rNota.rowid_refe;

    -- Corrige el saldo del doc (de debito, el saldo es negativo)
    UPDATE arcpmd
       SET saldo = saldo - rNota.monto
     WHERE rowid = rDocu.rowid;
  END IF;

  --
  -- Actualiza el estado de la boleta a Anulado ('X')
  UPDATE arcbbo
     SET estatus_boleta = 'X'
   WHERE no_cia   = pCia
     AND no_prove = rDocu.no_prove
     AND no_docu  = pDocu;

  --
  -- Si existen otros documentos que comparten el mismo numero de boleta
  -- con el doc anulado, es necesario invalidar totalmente la boleta emitida.
  -- Se limpia el numero fisico, y se devuelve el estado a 'A' para que
  -- el proceso de emision de boletas les asigne un nuevo numero fisico.
  -- Este caso se da cuando la retencion se genera al momento del pago total,
  -- porque se emite una sola boleta fisica para todas las retenciones
  -- pagadas por un mismo cheque.
  IF rEstado_retenc.no_fisico_boleta IS NOT NULL THEN
    UPDATE arcbbo
       SET estatus_boleta   = 'A', -- Estado de boleta Aplicada
           no_fisico_boleta = NULL
     WHERE no_cia           = pCia
       AND no_prove         = rDocu.no_prove
       AND no_fisico_boleta = rEstado_retenc.no_fisico_boleta
       AND estatus_boleta   IS NOT NULL -- que la retencion ya ha sido generada
       AND estatus_boleta   <> 'X'      -- y el doc que la genero no haya sido anulado
       AND estatus_boleta   <> 'C';     -- y que la boleta no haya sido pagada
  END IF;

  --
  -- Aplica el documento de anulacion.
  -- CPActualiza se encarga de corregir el monto y el estado de
  -- los documentos afectados.
  CPActualiza(pCia, rNota.no_prove, rRev.tipo_doc, vNo_docu_rev, msg_error_p);
  IF msg_error_p IS NOT NULL THEN
    RAISE Error_Proceso;
  END IF;

EXCEPTION
   WHEN consecutivo.error THEN
        msg_error_p := 'CPAnula_Notas_Retencion: '||nvl(consecutivo.ultimo_error, 'EN Consecutivo');
        return;
   WHEN transa_id.error THEN
        msg_error_p := 'CPAnula_Notas_Retencion: '||nvl(transa_id.ultimo_error, 'EN Transa_id');
        return;
   WHEN error_proceso THEN
        msg_error_p := 'CPAnula_Notas_Retencion: '||msg_error_p;
        return;
   WHEN others THEN
        msg_error_p := 'CPAnula_Notas_Retencion: '||sqlerrm;
        return;
END;