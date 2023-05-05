create or replace PROCEDURE            CCAnula  (
  pCia        IN     VARCHAR2,
  pCentro     IN     VARCHAR2,
  pTipo       IN     VARCHAR2,
  pDocu       IN     VARCHAR2,
  pMotivo     IN     VARCHAR2,
  pmsg_error  IN OUT VARCHAR2,
  porigen     IN     VARCHAR2 default 'CC' --- este origen sirve para trans generadas de POS ANR 23/11/2010
) IS
  -- --
  --
  CURSOR c_per_proce IS
    SELECT ano_proce_cxc, mes_proce_cxc, semana_proce_cxc,
           indicador_sem_cxc, dia_proceso_cxc
      FROM arincd
     WHERE no_cia = pCia
       AND centro = pCentro;
  --
  CURSOR c_datos_doc(pNo_Docu arccmd.no_docu%TYPE) IS
    SELECT no_cia, centro, grupo, no_cliente,sub_cliente, tipo_doc, no_docu,
           m_original monto, saldo, moneda, estado, tipo_cambio,
           ruta, no_agente, cod_diario, tipo_venta, ano, mes,
           monto_bienes, monto_serv, monto_exportac,
           no_fisico, serie_fisico, tot_imp, rowid
      FROM arccmd
     WHERE no_cia  = pCia
       AND no_docu = pNo_Docu;
  --
  CURSOR c_Tipo (pCia VARCHAR2, pTipo VARCHAR2) IS
    SELECT a.tipo_mov
      FROM arcctd a
     WHERE a.no_cia = pCia
       AND a.tipo   = pTipo;

  --
  CURSOR c_tipo_doc_anula (pCia VARCHAR2, pTipo_mov VARCHAR2, pUsuario VARCHAR2) IS
    SELECT a.tipo, b.usuario
      FROM arcctd a, arccud b
     WHERE a.no_cia      = pCia
       AND a.tipo_mov    = pTipo_mov
       AND cclib.EsAnulacionSN(pCia, a.tipo) = 'S'
       AND b.no_cia  (+) = a.no_cia
       AND b.tipo    (+) = a.tipo
       AND b.usuario (+) = pUsuario;
  --
  CURSOR c_referencias_deb(pDocu arccrd.no_docu%type) IS
    SELECT rd.no_docu
      FROM arccrd rd, arcctd td
     WHERE rd.no_cia   = pCia
       AND rd.no_docu  = pDocu
       AND td.tipo_mov = 'D'
       AND td.no_cia   = rd.no_cia
       AND td.tipo     = rd.tipo_refe;

  --
  md               c_datos_doc%ROWTYPE;
  vmoneda          arccmd.moneda%TYPE;
  --
  error_proceso    EXCEPTION;
  --
  vfound           BOOLEAN;
  vTipo_mov        arcctd.tipo_mov%TYPE;
  vTipo_mov_anul   arcctd.tipo_mov%TYPE;
  vUsuario_anula   arccud.usuario%TYPE;
  vano_proce       arincd.ano_proce_cxc%TYPE;
  vmes_proce       arincd.mes_proce_cxc%TYPE;
  vsem_proce       arincd.semana_proce_cxc%TYPE;
  vind_sem_proce   arincd.indicador_sem_cxc%TYPE;
  vdia_proce       arincd.dia_proceso_cxc%TYPE;
  vdoc_anula       arccmd.tipo_doc%TYPE;
  vno_docu_anula   arccmd.no_docu%TYPE;
  vsaldo_doc       arccmd.saldo%TYPE;
  vtotal_ref       arccmd.total_ref%TYPE;
  vDocu            arccrd.no_docu%type;
  vExiste          boolean;
  --

  PROCEDURE Actualiza_Libro_Ventas IS
  -- Actualiza el libro de ventas si el documento a anular
  -- y el documento de anulacion lo afectan en forma diferente.
  -- Si el documento a anular afecta el libro, y el de anulacion no,
  -- se eliminar el doc a anular del libro de ventas.
  -- En caso contrario, se elimina se elimina el doc de anulacion del libro.

    CURSOR c_afecta_libro(pTipo_doc arcctd.tipo%TYPE) IS
      SELECT nvl(afecta_libro,'N') afecta_libro
        FROM arcctd
       WHERE no_cia = pCia
         AND tipo   = pTipo_doc;

    vDoc_afecta_libro arcctd.afecta_libro%TYPE;
    vRev_afecta_libro arcctd.afecta_libro%TYPE;
  BEGIN
    -- Documento a anular
    OPEN  c_afecta_libro(pTipo);
    FETCH c_afecta_libro INTO vDoc_afecta_libro;
    CLOSE c_afecta_libro;

    -- Documento de anulacion
    OPEN  c_afecta_libro(vdoc_anula);
    FETCH c_afecta_libro INTO vRev_afecta_libro;
    CLOSE c_afecta_libro;

    IF vDoc_afecta_libro <> vRev_afecta_libro THEN

    	IF vDoc_afecta_libro = 'V' THEN
    	  -- El documento	a anular afecta el libro de ventas,
    	  -- no asi el de anulacion.
    	  -- Eliminar el doc a anular del libro de ventas
    	  DELETE FROM arcglve
    	  WHERE no_cia   = pCia
    	    AND tipo_doc = pTipo
    	    AND no_docu  = pDocu;

    	ELSE -- vDoc_afecta_libro <> 'V'
    	  -- El documento	a anular no afecta el libro de ventas,
    	  -- pero el de anulacion si.
    	  -- Elimina el doc de anulacion del libro de ventas
    	  DELETE FROM arcglve
    	  WHERE no_cia   = pCia
    	    AND tipo_doc = vdoc_anula
    	    AND no_docu  = vno_docu_anula;
    	END IF;

    END IF;
  END Actualiza_Libro_Ventas;

BEGIN
  --
  -- trae datos del documento
  OPEN  c_datos_doc(pDocu);
  FETCH c_datos_doc INTO md;
  vfound := c_datos_doc%FOUND;
  CLOSE c_datos_doc;

  IF NOT vfound THEN
    pmsg_error := 'El documento '||pdocu||' no existe';
    RAISE error_proceso;
  END IF;

  --
  --No permite anular documentos de tipo debito que tienen asociados como referencia
  --a otros documentos de tipo debito. Ejemplo las letras de cambio
  OPEN  c_referencias_deb(pDocu);
  FETCH c_referencias_deb INTO vDocu;
  vExiste := c_referencias_deb%found;
  CLOSE c_referencias_deb;
  IF vExiste THEN
    pmsg_error := 'No se pude anular el documento transaccion # '||vDocu ||' porque tiene referencias a otros debitos';
    RAISE error_proceso;
  END IF;

  --
  -- trae el periodo en proceso de CxC
  OPEN  c_per_proce;
  FETCH c_per_proce INTO vano_proce, vmes_proce, vsem_proce,
                         vind_sem_proce, vdia_proce;
  CLOSE c_per_proce;
  --
  -- Solamente se anulan documentos del periodo en proceso
  IF to_char(md.mes, 'FM00')||to_char(md.ano, 'FM0000') <> to_char(vMes_proce, 'FM00')||to_char(vAno_proce, 'FM0000') THEN
    pmsg_error := 'El documento '||pdocu||' no se puede anular porque no corresponde al periodo en proceso';
    RAISE error_proceso;
  END IF;
  --
	IF md.estado = 'P' THEN
    pmsg_error := 'El documento '||pdocu||' esta pendiente de actualizar';
    RAISE error_proceso;
	END IF;

  --
  -- validar que el tipo de documento no haya recibido referencias.
  IF md.monto <> abs(md.saldo) THEN
    pmsg_error := 'El documento '||pdocu||' no se puede anular debido a que ya tiene referencias. Monto: '||md.monto||' saldo: '||abs(md.saldo);
    RAISE error_proceso;
  END IF;

  OPEN  c_tipo (pCia, pTipo);
  FETCH c_tipo INTO vtipo_mov;
  vfound := c_tipo%found;
  CLOSE c_tipo;

  IF NOT vfound THEN
    pmsg_error := 'El Tipo de documento '||pTipo||' no existe';
    RAISE error_proceso;
  END IF;

  --
  -- determina la naturaleza que tendra el documento de anulacion
  IF vtipo_mov = 'C' THEN
  	vtipo_mov_anul := 'D';
  ELSE
  	vtipo_mov_anul := 'C';
  END IF;

  --
  -- busca un documento de anulacion de naturaleza inversa (deb/cred)
  OPEN  c_tipo_doc_anula (pCia, vtipo_mov_anul, USER);
  FETCH c_tipo_doc_anula INTO vdoc_anula, vUsuario_anula;
  vfound := c_tipo_doc_anula%found;
  CLOSE c_tipo_doc_anula;

  IF NOT vfound THEN
    pmsg_error := 'No se ha definido el Tipo de Documento por Anulacion de naturaleza '||vtipo_mov_anul;
    RAISE error_proceso;
  END IF;

  -- Revisa que el usuario tenga derechos sobre el tipo doc anulacion en arccud
  IF vUsuario_anula IS NULL THEN
    pmsg_error := 'El usuario no tiene acceso al tipo de documento de anulacion '||vdoc_anula;
    RAISE error_proceso;
  END IF;

  -- --
  -- Obtiene un numero de transaccion
  vNo_docu_anula := Transa_Id.cc(pcia);
  --
  --
  -- si el saldo del documento original es positivo (doc.de debito), el de la anulacion
  -- debe ser negativo (doc. de credito) y viceversa.
  IF vtipo_mov_anul = 'C' THEN
  	-- la anulacion es un credito.
    vsaldo_doc := 0;
    vtotal_ref := md.saldo;
  ELSE -- vtipo_anul = 'D'
  	-- la anulacion es un debito.
    vsaldo_doc := abs(md.saldo);
    vtotal_ref := 0;
  END IF;

  -- Inserta el docto de anulacion
  INSERT INTO arccmd(no_cia,     centro,     tipo_doc,
                     periodo,    ruta,       no_docu,
                     grupo,      no_cliente, sub_cliente,fecha,
                     fecha_documento,        moneda,  cod_diario,
                     m_original, descuento,  saldo,
                     estado,     tipo_cambio,
                     no_agente,  total_ref,
                     origen,     ano,        mes,
                     semana,     no_fisico,  serie_fisico,
                     tipo_venta, monto_bienes, monto_serv,
                     monto_exportac,no_docu_refe,tot_imp )
              VALUES(md.no_cia,      md.centro,       vdoc_anula,
                     vano_proce,     md.ruta,         vNo_docu_anula,
                     md.grupo,       md.no_cliente,   md.sub_cliente,vdia_proce,
                     vdia_proce,     md.moneda,       md.cod_diario,
                     md.monto,       0,               vsaldo_doc,
                     'P',            md.tipo_cambio,
                     md.no_agente,   vtotal_ref,
                     porigen,           vano_proce,      vmes_proce,
                     vsem_proce,     md.no_fisico,    md.serie_fisico,
                     md.tipo_venta,  md.monto_bienes, md.monto_serv,
                     md.monto_exportac, pDocu, md.tot_imp );
  --
  -- genera detalle de impuestos para reversar detalle original
  INSERT INTO arccti (no_cia,  grupo,   no_cliente,  tipo_doc,
                      no_docu, no_refe, clave,       porcentaje,
                      monto,   codigo_tercero,       base,
                      comportamiento,   aplica_cred_fiscal,
                      ind_imp_ret,      id_sec)
               SELECT no_cia,  grupo,   no_cliente,  vdoc_anula,
                      vNo_docu_anula,   no_refe,     clave,  porcentaje,
                      monto,   codigo_tercero,       base,
                      comportamiento,   aplica_cred_fiscal,
                      ind_imp_ret,      id_sec
                 FROM arccti
                WHERE no_cia  = pCia
                  AND no_docu = pDocu;

  --
  -- genera dist.contable del documento de reversion
  INSERT INTO arccdc (no_cia, centro, tipo_doc, periodo, ruta, no_docu,
                      grupo, no_cliente, codigo, tipo, monto, monto_dol,
                      tipo_cambio, moneda, ind_con, ano, mes,
                      centro_costo, codigo_tercero, monto_dc)
               SELECT no_cia, centro, vdoc_anula, vAno_proce, ruta, vNo_docu_anula,
                      grupo, no_cliente, codigo, decode(tipo, 'D', 'C', 'D'), monto, monto_dol,
                      tipo_cambio, moneda, 'P', vAno_proce, vMes_proce,
                      centro_costo, codigo_tercero, monto_dc
                 FROM arccdc
                WHERE no_cia  = pCia
                  AND no_docu = pDocu;

  --
  -- genera referencias de anulacion (varia segun el doc sea de debito o credito)
  IF vtipo_mov_anul = 'C' THEN
    --
    -- si la anulacion es un credito, se inserta el documento referenciando al que
    -- esta anulando.
    INSERT INTO arccrd (no_cia,      tipo_doc,   no_docu,
                        tipo_refe,   no_refe,    monto,
                        fecha_vence, monto_refe, moneda_refe,
                        fec_aplic,   ano,        mes)
                VALUES (md.no_cia,   vdoc_anula,  vno_docu_anula,
                        md.tipo_doc, md.no_docu,  md.monto,
                        vdia_proce,  md.monto,    md.moneda,
                        vdia_proce,  vano_proce,  vmes_proce);
  ELSE -- vtipo_mov_anul = 'D'
  	--
  	-- si la anulacion es un debito, se inserta dicho documento como una referencia del
  	-- que se esta anulando.
    INSERT INTO arccrd (no_cia,      tipo_doc,   no_docu,
                        tipo_refe,   no_refe,    monto,
                        fecha_vence, monto_refe, moneda_refe,
                        fec_aplic,   ano,        mes,
                        ind_procesado)
                VALUES (md.no_cia,   md.tipo_doc,    md.no_docu,
                        vdoc_anula,  vno_docu_anula, md.monto,
                        vdia_proce,  md.monto,       md.moneda,
                        vdia_proce,  vano_proce,     vmes_proce,
                        'S');

  END IF;

  --
  -- actualiza el documento de anulacion y por consiguiente el saldo del cliente.
  CCActualiza(md.no_cia, vdoc_anula, vNo_docu_anula, pmsg_error);
  IF pmsg_error IS NOT NULL THEN
    RAISE error_proceso;
  END IF;

  Actualiza_Libro_Ventas;

  --
  -- Le pone al documento original el indicador de anulado
  UPDATE arccmd
     SET anulado        = 'S',
         saldo          = 0,
         usuario_anula  = user,
         motivo_anula   = pMotivo,
         tstamp = sysdate
   WHERE rowid = md.rowid;

  --
  -- Le pone al documento de anulacion el indicador de anulado
  UPDATE arccmd
     SET anulado        = 'S',
         saldo          = 0,
         usuario_anula  = user,
         motivo_anula   = pMotivo,
         n_docu_a       = pDocu, -- Documento que esta anulando
         tstamp = sysdate
   WHERE no_cia  = md.no_cia
     AND no_docu = vNo_docu_anula;
  --
EXCEPTION
  WHEN error_proceso THEN
       pmsg_error := 'CCANULA : '||pmsg_error;
       return;
  WHEN others then
       pmsg_error := 'CCANULA : '||sqlerrm;
       return;

END;