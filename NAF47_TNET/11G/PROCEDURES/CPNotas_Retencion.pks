create or replace PROCEDURE            CPNotas_Retencion(
  pCia          IN     VARCHAR2,
  pDocu         IN     VARCHAR2, -- Documento al cual se le genera la nota
  pFecha        IN     DATE,     -- Fecha de la nota a generar
  pNo_docu_pago IN     VARCHAR2, -- Numero del documento que paga totalmente pDocu
  pTipo_nota    IN OUT VARCHAR2, -- Tipo de nota generada
  pNo_nota      IN OUT VARCHAR2, -- Numero de nota generada
  msg_error_p   IN OUT VARCHAR2
) IS

  -- ---
  -- Retenciones Incluidas (Guatemala)
  -- Si es un doc de credito, inserta una nota de debito cancelando la retencion de la factura pDocu
  -- por el monto indicado en tot_ret_especial. Si es un documento de debito, inserta la nota de credito
  -- rebajando el saldo del doc. En los parametros pTipo_nota_deb y pNo_nota_deb devuelve el tipo
  -- y el numero de la nota de debito generada.
  --
  -- pNo_docu_pago recibe el numero del doc que cancela totalmente el documento pDocu. Solamente se usa
  -- cuando las retenciones se pagan al momento de la cancelacion del doc.  Si la retencion se genera
  -- al momento de la aplicacion o provision esta columna es NULL. El valor se graba en arcbbo.no_docu_pago.
  --
  -- NOTA: Este procedimiento *MODIFICA EL SALDO* de pDocu
  --
  -- pTipo_nota_deb y pNo_nota_deb pueden ser NULL bajo las siguientes condiciones:
  --   1. Si ocurre algun error.
  --   2. Si la compa?ia no maneja retenciones incluidas (Guatemala).
  --   3. Si la retencion es cero (ej: proveedores de retencion Cero).
  --   4. Si ya existe una ND para la factura.
  --

  -- Ver si la compania usa retenciones incluidas
  CURSOR c_usa_ret IS
    SELECT tipo_doc_ND_ret, tipo_doc_NC_ret
      FROM arcppr
     WHERE no_cia = pCia;


  -- Datos del doc al cual se le va a generar la nota
  CURSOR c_docu(pno_docu arcpmd.no_docu%TYPE) IS
    SELECT nvl(a.tot_ret_especial,0) tot_ret_especial,
           a.saldo, a.anulado, a.ind_act, a.bloqueado,
           a.moneda, a.no_prove, a.tipo_doc, a.tipo_cambio,
           a.fecha, a.no_fisico, a.serie_fisico, a.t_camb_c_v,
           b.tipo_mov, b.ind_anulacion, a.rowid
      FROM arcpmd a, arcptd b
     WHERE a.no_cia   = pCia
       AND a.no_docu  = pno_docu
       AND b.no_cia   = a.no_cia
       AND b.tipo_doc = a.tipo_doc;

  -- Tipo de documento de la nota de retencion
  --    pTipo_mov es el tipo de mov del doc al cual se le va a generar la nota
  CURSOR c_tipo_Nota(pTipo_mov arcptd.tipo_mov%TYPE) IS
    SELECT decode(pTipo_mov, 'C', pr.tipo_doc_nd_ret, pr.tipo_doc_nc_ret) tipo_doc,
           decode(pTipo_mov, 'C', td.tipo_mov,        tc.tipo_mov)        tipo_mov,
           decode(pTipo_mov, 'C', td.cod_diario,      tc.cod_diario)      cod_diario
      FROM arcppr pr, arcptd td, arcptd tc
     WHERE pr.no_cia       = pCia
       AND td.no_cia   (+) = pr.no_cia
       AND td.tipo_doc (+) = pr.tipo_doc_nd_ret
       AND tc.no_cia   (+) = pr.no_cia
       AND tc.tipo_doc (+) = pr.tipo_doc_nc_ret;

  -- Concepto de retencion usada en la factura
  -- Nota: el monto en arcbbo esta siempre en nominal
  CURSOR c_concepto_retenc(pNo_prove arcbbo.no_prove%TYPE,
                           pTipo_doc arcpti.tipo_doc%TYPE,
                           pNo_docu  arcbbo.no_docu%TYPE) IS
    SELECT ti.clave, ti.id_sec, ti.codigo_tercero, ti.monto
      FROM arcbbo bo, arcpti ti
     WHERE bo.no_cia         = pCia
       AND bo.no_prove       = pNo_prove
       AND bo.no_docu        = pNo_docu
       AND ti.no_cia         = bo.no_cia
       AND ti.no_prove       = bo.no_prove
       AND ti.tipo_doc       = pTipo_doc
       AND ti.no_docu        = bo.no_docu
       AND ti.clave          = bo.clave
       AND ti.comportamiento = 'I'
       AND ti.ind_imp_ret    = 'R';

  -- Codigo de tercero proveedor
  CURSOR c_prove(pNo_prove arcpmp.no_prove%TYPE) IS
    SELECT mp.codigo_tercero
      FROM arcpmp mp
     WHERE mp.no_cia   = pCia
       AND mp.no_prove = pNo_prove;

  -- Indica si ya existe una nota retencion (debito) para la factura
  CURSOR c_ND_existe(pTipo_ND   arcprd.tipo_doc%TYPE,
                     pTipo_refe arcprd.tipo_refe%TYPE,
                     pNo_refe   arcprd.no_refe%TYPE) IS
    SELECT 'x'
      FROM arcprd a, arcpmd b
     WHERE a.no_cia    = pCia
       AND a.tipo_doc  = pTipo_ND
	     AND a.tipo_refe = pTipo_refe
	     AND a.no_refe   = pNo_refe
	     AND b.anulado   = 'N'
	     AND b.no_cia    = a.no_cia
	     AND b.no_docu   = a.no_docu;

  -- A?o y mes de proceso de la compa?ia
  CURSOR c_per_proce IS
    SELECT ano_proc, mes_proc
      FROM arcpct
     WHERE no_cia = pCia;

  rDocu            c_docu%ROWTYPE;             -- Datos del doc afectado
  rTipo_Nota       c_tipo_Nota%ROWTYPE;        -- Datos del tipo de nota a generar
  rConcepto_Retenc c_Concepto_retenc%ROWTYPE;  -- Concepto de la retencion aplicada al doc
  rDocs_ret        c_usa_ret%ROWTYPE;          -- Tipo doc de la ND y NC de retencion
  --
  vNo_docu         arcpmd.no_docu%TYPE;        -- Numero de la nota
  vSerie_fisico    arcpmd.serie_fisico%TYPE;   -- Serie de la nota
  --
  vAno_proce       arcpct.ano_proc%TYPE;
  vMes_Proce       arcpct.mes_proc%TYPE;
  --
  vCta_Prove       arcpdc.codigo%TYPE;         -- Cuenta del proveedor
  vCta_Retenc      arcpdc.codigo%TYPE;         -- Cuenta de retencion
  vCod_tercero     arcpdc.codigo_tercero%TYPE; -- Codigo de tercero
  --
  vMonto_nom       arcpdc.monto%TYPE;
  vMonto_Dol       arcpdc.monto_dol%TYPE;
  --
  vSaldo_nota      arcpmd.monto%TYPE;          -- Saldo de la nota
  vTotal_ref_nota  arcpmd.tot_refer%TYPE;      -- Tot referencias de la nota
  --
  error_proceso    EXCEPTION;
  vExiste          BOOLEAN;
  vTemp            VARCHAR2(1);
BEGIN
  ptipo_nota := NULL;
  pno_nota   := NULL;

  --
  -- Revisar si la compania maneja retenciones incluidas
  --
  OPEN  c_usa_ret;
  FETCH c_usa_ret INTO rDocs_ret;
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
    msg_error_p  := 'El numero de documento esta nulo';
    RAISE error_proceso;
  END IF;

  --
  -- Datos del documento al que se le genera la nota
  --
  OPEN  c_docu(pDocu);
  FETCH c_docu INTO rDocu;
  vExiste := c_docu%FOUND;
  CLOSE c_docu;

  IF NOT vExiste THEN
    msg_error_p := 'No se encontro el documento con transaccion '||pDocu;
    RAISE error_proceso;
  END IF;

  -- Los doc de anulacion no generan notas de retencion,
  -- tampoco las NC y ND de retencion.
  IF (rDocu.ind_anulacion = 'S')                       OR
  	 (rDocu.tipo_doc      = rDocs_ret.tipo_doc_ND_ret) OR
  	 (rDocu.tipo_doc      = rDocs_ret.tipo_doc_NC_ret) THEN
  	RETURN;
  END IF;

  -- El proveedor puede ser de retencion Cero
  -- en este caso solo se marca la boleta como generada
  -- Si no tiene lineas de retenciones no hace nada
  IF rDocu.tot_ret_especial = 0 THEN
   	UPDATE arcbbo
       SET estatus_boleta = 'A',
           fecha_boleta   = pFecha,
           no_docu_pago   = pNo_docu_pago
     WHERE no_cia   = pCia
       AND no_prove = rDocu.No_Prove
       AND no_docu  = pDocu
       AND estatus_boleta IS NULL;

    RETURN;

  END IF;

  --
  -- Leer el tipo de doc de la nota de retencion
  --
  OPEN  c_tipo_Nota(rDocu.tipo_mov);
  FETCH c_tipo_Nota INTO rTipo_Nota;
  vExiste := c_tipo_Nota%FOUND;
  CLOSE c_tipo_Nota;

  IF rTipo_Nota.tipo_doc IS NULL THEN
    msg_error_p  := 'La compa?ia no tiene definido el tipo de Nota Retencion para el movimiento de tipo '||rDocu.tipo_mov;
    RAISE error_proceso;
  END IF;

  -- Revisar si ya existe alguna nota generada para la factura (tipo_mov = 'C')
  -- Ej: si el pago es al momento de la cancelacion de la factura
  --     y se genera el cheque de pago, y luego se anula.
  --     Al aplicarse el cheque se genera la ND; pero al anularse
  --     el cheque, la ND queda vigente, y no deberia generarse
  --     otra vez, la proxima vez que se cancele la factura
  IF rDocu.tipo_mov = 'C' THEN
    OPEN  c_ND_existe(rTipo_Nota.tipo_doc, rDocu.tipo_doc, pDocu);
    FETCH c_ND_existe INTO vTemp;
    vExiste := c_ND_existe%FOUND;
    CLOSE c_ND_existe;

    IF vExiste THEN
    	-- Se resetea el estado de la boleta a Actualizada ('A') y se limpia el numero de boleta,
    	-- Tambien se actualiza el numero del doc pago.
    	-- Si la boleta ya fue pagada ('C') solo se actualiza el num del doc de pago.
     	UPDATE arcbbo
         SET estatus_boleta   = decode(estatus_boleta, 'C', 'C', 'A'),
             no_fisico_boleta = decode(estatus_boleta, 'C', no_fisico_boleta, NULL),
             fecha_boleta     = decode(estatus_boleta, 'C', fecha_boleta,     pFecha),
             no_docu_pago     = pNo_docu_pago
       WHERE no_cia         = pCia
         AND no_prove       = rDocu.No_Prove
         AND no_docu        = pDocu
         AND estatus_boleta <> 'X';

    	RETURN;

    END IF;

  END IF;

  -- La nota de retencion no puede tener el mismo tipo de mov que el doc afectado
  IF rTipo_Nota.tipo_mov = rDocu.tipo_mov THEN
    msg_error_p  := 'El tipo de movimiento de la Nota de Retencion no puede ser igual al del documento afectado';
    RAISE error_proceso;
  END IF;

  -- Documento Pendiente ????
  IF rDocu.ind_act = 'P' THEN
    msg_error_p := 'El documento '||rDocu.tipo_doc||' '||
                   rDocu.no_fisico||'-'||rDocu.serie_fisico||' esta Pendiente de actualizar.';
    RAISE error_proceso;
  END IF;

  -- Documento Anulado
  IF rDocu.anulado = 'S' THEN
    msg_error_p := 'El documento '||rDocu.tipo_doc||' '||
                   rDocu.no_fisico||'-'||rDocu.serie_fisico||' esta anulado.';
    RAISE error_proceso;
  END IF;

  -- Documento bloqueado
  IF rDocu.bloqueado = 'S' THEN
    msg_error_p := 'El documento '||rDocu.tipo_doc||' '||
                   rDocu.no_fisico||'-'||rDocu.serie_fisico||' esta bloqueado.';
    RAISE error_proceso;
  END IF;

  -- El saldo debe ser al menos = tot_ret_especial
  IF abs(rDocu.saldo) < rDocu.tot_ret_especial THEN
    msg_error_p := 'El saldo del documento '||rDocu.tipo_doc||' '||
                   rDocu.no_fisico||'-'||rDocu.serie_fisico||' (saldo = '||to_char(rDocu.saldo)||
                   ') no es suficiente para generar la nota de retencion.';
    RAISE error_proceso;
  END IF;

  -- A?o y mes de proceso
  OPEN  c_per_proce;
  FETCH c_per_proce INTO vAno_proce, vMes_proce;
  CLOSE c_per_proce;

  IF rtipo_Nota.tipo_mov = 'D' THEN
  	-- la nota es un Debito.
    vSaldo_nota     := 0;
    vTotal_ref_nota := rDocu.tot_ret_especial;
  ELSE -- tipo_mov = 'C'
	  -- la nota es un Credito.
    vSaldo_nota     := rDocu.tot_ret_especial;
    vTotal_ref_nota := 0;
  END IF;

  --
  -- Registra el documento en CxP.
  -- El numero de control se asigna cuando se aplica la nota.
  --
  vNo_docu      := Transa_Id.CP  (pCia);
  vSerie_fisico := Consecutivo.CP(pCia, vAno_proce, vMes_proce,
                                  rtipo_Nota.tipo_doc, 'SERIE');
  --
  -- crea un documento en CxP pendiente de actualizar
  INSERT INTO arcpmd(no_cia, no_prove, tipo_doc,
                     no_docu, ind_act, fecha,
                     subtotal, monto, saldo,
                     tot_refer, tot_db, tot_cr,
                     tipo_cambio, moneda, cod_diario,
                     fecha_documento, origen, t_camb_c_v,
                     detalle,
                     excentos, gravado, serie_fisico)
              VALUES(pCia, rDocu.no_prove, rtipo_Nota.tipo_doc,
                     vno_docu, 'P', pFecha,
                     rDocu.tot_ret_especial, rDocu.tot_ret_especial, vSaldo_nota,
                     vTotal_ref_nota, rDocu.tot_ret_especial, rDocu.tot_ret_especial,
                     rDocu.tipo_cambio, rDocu.moneda, rTipo_Nota.cod_diario,
                     pFecha, 'CP', rDocu.t_camb_c_v,
                     'Retencion de '||rDocu.tipo_doc||' '||rDocu.no_fisico||'-'||rDocu.serie_fisico,
                     rDocu.tot_ret_especial, 0, vSerie_fisico);

  IF rtipo_Nota.tipo_mov = 'D' THEN
    -- La nota es un Debito, hacer la referencia a la factura
    INSERT INTO arcprd(no_cia, tipo_doc, no_docu, tipo_refe, no_refe,
                       monto, descuento_pp, monto_refe, moneda_refe,
                       fec_aplic, mes, ano)
                VALUES(pCia, rTipo_Nota.tipo_doc, vNo_docu, rDocu.tipo_doc, pDocu,
                       rDocu.tot_ret_especial, 0, rDocu.tot_ret_especial, rDocu.moneda,
                       pFecha, to_char(pFecha, 'MM'), to_char(pFecha, 'YYYY'));

  ELSE -- rtipo_Nota.tipo_mov = 'C'
    -- La nota es un Credito, hacer la referencia desde el doc hacia la nota
    INSERT INTO arcprd(no_cia, tipo_doc, no_docu, tipo_refe, no_refe,
                       monto, descuento_pp, monto_refe, moneda_refe,
                       fec_aplic, mes, ano)
                VALUES(pCia, rDocu.tipo_doc, pDocu, rTipo_Nota.tipo_doc, vNo_docu,
                       rDocu.tot_ret_especial, 0, rDocu.tot_ret_especial, rDocu.moneda,
                       pFecha, to_char(pFecha, 'MM'), to_char(pFecha, 'YYYY'));

    -- Rebajar el monto de la referencia del Saldo del documento
    -- El doc es un debito -> arcpmd.saldo es negativo
    UPDATE arcpmd
       SET saldo = saldo + rDocu.tot_ret_especial
     WHERE rowid = rDocu.rowid;

  END IF;

  --
  --
  -- Genera la DC de la nota
  --
  IF rDocu.moneda = 'P' THEN -- Doc. en Nominal
  	vMonto_nom := rDocu.tot_ret_especial;
  	vMonto_Dol := moneda.redondeo(rDocu.tot_ret_especial / rDocu.tipo_cambio, 'D');
  ELSE -- Doc. en Dolares
  	vMonto_nom := moneda.redondeo(rDocu.tot_ret_especial * rDocu.tipo_cambio, 'P');
  	vMonto_Dol := rDocu.tot_ret_especial;
  END IF;

  -- Cuenta contable del proveedor.
  -- Si la nota es un Debito  : >>> Debito
  -- Si la nota es un Credito : >>> Credito
--  IF NOT cplib.trae_cuenta_proveedor(pCia, rDocu.No_prove, rTipo_Nota.tipo_doc, rDocu.moneda, vCta_Prove) THEN
  IF NOT cplib.trae_cuenta_proveedor(pCia, rDocu.No_prove, rTipo_Nota.tipo_doc,rDocu.moneda, vCta_Prove) THEN
    msg_error_p := 'No fue posible encontrar la cuenta contable del proveedor '||rDocu.no_prove;
    RAISE error_proceso;
  END IF;

  -- Codigo de tercero
  IF cuenta_contable.acepta_Tercero(pCia, vCta_prove) THEN
    OPEN  c_prove(rDocu.no_prove);
    FETCH c_prove INTO vCod_tercero;
    CLOSE c_prove;
  ELSE
    vCod_tercero := NULL;
  END IF;

  INSERT INTO arcpdc(no_cia, no_prove, tipo_doc, no_docu,
                     codigo, tipo,
                     monto, mes, ano,
                     ind_con, monto_dol, moneda, tipo_cambio,
                     no_asiento, centro_costo, modificable, codigo_tercero,
                     monto_dc)
              VALUES(pCia, rDocu.no_prove, rTipo_Nota.tipo_doc, vNo_docu,
                     vCta_prove, decode(rTipo_Nota.tipo_mov,'D','D','C'),
                     vMonto_nom, to_char(pFecha, 'MM'), to_char(pFecha, 'YYYY'),
                     'P', vMonto_Dol, rDocu.moneda, rDocu.tipo_cambio,
                     NULL, centro_costo.rellenad(pCia, '0'), 'S', vCod_tercero,
                     decode(rDocu.moneda, 'P', vMonto_nom, vMonto_Dol));

  --
  -- Inserta la cuenta de las retenciones
  FOR rConcepto_Retenc IN c_concepto_retenc(rDocu.no_prove, rDocu.tipo_doc, pDocu) LOOP

    -- Cuenta contable de la retencion
    -- Si la nota es un Debito  : >>> Credito
    -- Si la nota es un Credito : >>> Debito
    vCta_retenc := Impuesto.cta_contable(pCia, rConcepto_Retenc.clave, rConcepto_Retenc.id_sec);

    IF cuenta_contable.acepta_Tercero(pCia, vCta_retenc) THEN
    	vCod_tercero := rConcepto_Retenc.codigo_tercero;
    ELSE
      vCod_tercero := NULL;
    END IF;

    IF rDocu.moneda = 'P' THEN -- Doc. en Nominal
    	vMonto_nom := rConcepto_retenc.monto;
    	vMonto_Dol := moneda.redondeo(rConcepto_retenc.monto / rDocu.tipo_cambio, 'D');
    ELSE -- Doc. en Dolares
  	  vMonto_nom := moneda.redondeo(rConcepto_retenc.monto * rDocu.tipo_cambio, 'P');
  	  vMonto_Dol := rConcepto_retenc.monto;
    END IF;

    UPDATE arcpdc
       SET monto     = monto     + vMonto_nom,
           monto_dol = monto_dol + vMonto_Dol,
           monto_dc  = monto_dc  + decode(rDocu.moneda, 'P', vMonto_nom, vMonto_Dol)
     WHERE no_cia       = pCia
       AND no_docu      = vNo_docu
       AND codigo       = vCta_retenc
       AND tipo         = decode(rTipo_Nota.tipo_mov,'D','C','D')
       AND centro_costo = centro_costo.rellenad(pCia, '0');

    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO arcpdc(no_cia, no_prove, tipo_doc, no_docu,
                         codigo, tipo,
                         monto, mes, ano,
                         ind_con, monto_dol, moneda, tipo_cambio,
                         no_asiento, centro_costo, modificable, codigo_tercero,
                         monto_dc)
                  VALUES(pCia, rDocu.no_prove, rTipo_Nota.tipo_doc, vNo_docu,
                         vCta_retenc, decode(rTipo_Nota.tipo_mov,'D','C','D'),
                         vMonto_nom, to_char(pFecha, 'MM'), to_char(pFecha, 'YYYY'),
                         'P', vMonto_Dol, rDocu.moneda, rDocu.tipo_cambio,
                         NULL, centro_costo.rellenad(pCia, '0'), 'S', vCod_tercero,
                         decode(rDocu.moneda, 'P', vMonto_nom, vMonto_Dol));
    END IF;

  END LOOP; -- de retenciones.

  -- Devuelve el tipo y el numero de la nota generada
  ptipo_nota := rTipo_Nota.tipo_doc;
  pno_nota   := vNo_docu;

EXCEPTION
   WHEN cuenta_contable.error THEN
        msg_error_p := 'CPNotas_Retencion :'||nvl(cuenta_contable.ultimo_error, 'EN Cuenta_contable');
        return;
   WHEN impuesto.error THEN
        msg_error_p := 'CPNotas_Retencion :'||nvl(impuesto.ultimo_error, 'EN Impuesto');
        return;
   WHEN consecutivo.error THEN
        msg_error_p := 'CPNotas_Retencion :'||nvl(consecutivo.ultimo_error, 'EN Consecutivo');
        return;
   WHEN transa_id.error THEN
        msg_error_p := 'CPNotas_Retencion :'||nvl(transa_id.ultimo_error, 'EN Transa_id');
        return;
   WHEN error_proceso THEN
        msg_error_p := 'CPNotas_Retencion: '||msg_error_p;
        return;
   WHEN centro_costo.error THEN
        msg_error_p := 'CPNotas_Retencion :'||nvl(centro_costo.ultimo_error, 'EN Centro_costo');
        return;
   WHEN others THEN
        msg_error_p := 'CPNotas_Retencion :'||sqlerrm;
        return;
END;