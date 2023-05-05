create or replace PROCEDURE            FAdevolucion_cxc(no_cia_p       IN arfafe.no_cia%TYPE,
                                             tipo_doc_p     IN arfafe.tipo_doc%TYPE, -- tipo doc (devolucion)
                                             no_factu_p     IN arfafe.no_factu%TYPE, -- no. transa (devolucion)
                                             no_fisico_p    IN arfafe.no_fisico%TYPE, -- num. fisico (devolucion)
                                             serie_fisico_p IN arfafe.serie_fisico%TYPE, -- serie (devolucion)
                                             fecha_p        IN DATE,
                                             monto_devol_p  IN arfafe.total%TYPE, -- monto de la devolucion
                                             monto_bien_p   IN arfafe.monto_bienes%TYPE,
                                             monto_serv_p   IN arfafe.monto_serv%TYPE,
                                             monto_exp_p    IN arfafe.monto_exportac%TYPE,
                                             tipo_cambio_p  IN arfafe.tipo_cambio%TYPE,
                                             ano_proce_p    IN Arincd.ano_proce_fact%TYPE,
                                             mes_proce_p    IN Arincd.ano_proce_fact%TYPE,
                                             sem_proce_p    IN Arincd.ano_proce_fact%TYPE,
                                             tipo_refe_p    IN arfafe.tipo_doc%TYPE, -- tipo doc (factura)
                                             no_refe_p      IN arfafe.No_factu%TYPE, -- no. transa (factura)
                                             autorizacion_p IN arfafe.no_autorizacion%TYPE,
                                             fautorizac_p   IN arfafe.fecha_vigencia_autoriz%TYPE,
                                             msg_error_p    IN OUT VARCHAR2) IS
  --***
  --* NOTA:
  --*   1.El campo saldo de un credito pendiente de actualizar en CxC,
  --*     aun cuando tiene referencias, queda positivo e igual al monto original
  vtipo_mov       arcctd.tipo_mov%TYPE;
  vsaldo_doc_ccmd arccmd.saldo%TYPE;
  vtotal_devol    arccmd.m_original%TYPE;
  vtotal_ref      arccmd.total_ref%TYPE;
  vdoc_devol_cxc  arcctd.tipo%TYPE;
  vExiste         BOOLEAN;
  --
  vCentro     arccmd.centro%TYPE;
  vRuta       arccmd.ruta%TYPE;
  vGrupo      arccmd.grupo%TYPE;
  vCliente    arccmd.no_cliente%TYPE;
  vMoneda     arccmd.moneda%TYPE;
  vAgente     arccmd.no_agente%TYPE;
  vSubCliente arcclocales_clientes.no_sub_cliente%TYPE;
  --
  vFisico_Refe arccmd.no_fisico_refe%TYPE;
  vSerie_Refe  arccmd.serie_fisico_refe%TYPE;
  error_proceso EXCEPTION;
  --
  CURSOR c_datos_tipo_doc IS
    SELECT factura,
           tipo_mov,
           cod_diario
      FROM arcctd
     WHERE no_cia = no_cia_p
       AND tipo = vdoc_devol_cxc;
  --
  CURSOR c_doc_cxc IS
    SELECT tipo_doc,
           centro,
           grupo,
           no_cliente,
           estado,
           NVL(m_original, 0) m_original,
           NVL(saldo, 0) saldo,
           moneda,
           ruta,
           no_agente,
           periodo,
           sub_cliente,
           ROWID
      FROM arccmd
     WHERE no_cia = no_cia_p
       AND no_docu = no_refe_p;
  --
  CURSOR c_doc_factu IS
    SELECT centrod,
           ruta,
           grupo,
           no_cliente,
           moneda,
           no_vendedor,
           no_fisico_refe,
           serie_fisico_refe
      FROM arfafe
     WHERE no_cia = no_cia_p
       AND no_factu = no_factu_p;
  --
  CURSOR c_sub_cliente IS
    SELECT subcliente
      FROM arfafe
     WHERE no_cia = no_cia_p
       AND no_factu = no_factu_p;

  --- recupera el total de impuesto de la devolucion ANR 28/04/2011
  CURSOR c_tot_imp IS
    SELECT abs(impuesto) --- en factu se guarda negativo en cxc se debe guardar positivo
      FROM arfafe
     WHERE no_cia = no_cia_p
       AND no_factu = no_factu_p;

  Ln_tot_imp arfafe.impuesto%TYPE;
  ed         c_doc_cxc%ROWTYPE;
  rtd        c_datos_tipo_doc%ROWTYPE;

BEGIN

  -- Obtiene el docto de la devoluccion que hay que generar en CxC desde facturacion
  vdoc_devol_cxc := INLIB.doc_cxc(no_cia_p, tipo_doc_p);

  IF vdoc_devol_cxc IS NULL THEN
    msg_error_p := 'Docto de devolucion a generar en CxC originado por un ' || tipo_doc_p || ' no se especifico';
    RAISE error_proceso;
  END IF;

  -- Verifica el docto de la devolucion
  OPEN c_datos_tipo_doc;
  FETCH c_datos_tipo_doc
    INTO rtd;
  vExiste := c_datos_tipo_doc%FOUND;
  CLOSE c_datos_tipo_doc;

  IF NOT vExiste THEN
    msg_error_p := 'El tipo de movimiento de la devolucion en inventario no existe en Inventarios';
    RAISE error_proceso;
  ELSIF NVL(rtd.tipo_mov, 'X') != 'C' THEN
    msg_error_p := 'El tipo de movimiento de la devolucion en inventario deber ser de tipo CREDITO';
    RAISE error_proceso;
  ELSIF NVL(rtd.factura, 'N') != 'S' THEN
    msg_error_p := 'El documento de movimiento de la devolucion en inventario deber ser de tipo CREDITO';
    RAISE error_proceso;
  END IF;
  --
  vtotal_devol := abs(NVL(monto_devol_p, 0));
  -- --
  -- Si la devolucion es con referencia, recupera datos de la factura original
  IF no_refe_p IS NOT NULL THEN
    OPEN c_doc_cxc;
    FETCH c_doc_cxc
      INTO ed;
    IF c_doc_cxc%NOTFOUND THEN
      CLOSE c_doc_cxc;
      msg_error_p := 'No encontro la factura en Cuentas por Cobrar';
      RAISE error_proceso;
    END IF;
    CLOSE c_doc_cxc;
    --
    IF ed.saldo IS NULL OR ed.m_original IS NULL THEN
      msg_error_p := 'ERROR INTERNO: saldo o mto_original es nulo';
      RAISE error_proceso;
    END IF;
  
    vCentro  := ed.centro;
    vRuta    := ed.ruta;
    vGrupo   := ed.grupo;
    vCliente := ed.no_cliente;
    vMoneda  := ed.moneda;
    vAgente  := ed.no_agente;
    --
    -- verifica el estado del documento (factura) en CxC
    IF ed.estado = 'P' THEN
      -- La factura original esta pendiente en CxC, hay que registrar un credito con saldo a favor
      vtotal_ref := 0;
    ELSE
      -- La factura original en CxC esta actualizada, pero el total referencia no puede exceder el saldo del misma.
      vtotal_ref := vtotal_devol; -- LEAST(vtotal_devol, GREATEST(nvl(ed.saldo,0), 0)); 
    END IF;
  ELSE
    --
    -- si la devolucion es sin referencias
    vtotal_ref := 0;
    --
    -- como no tiene referencia anterior a CxC, obtiene los datos del documento de devolucion en Facturacion
    OPEN c_doc_factu;
    FETCH c_doc_factu
      INTO vCentro,
           vRuta,
           vGrupo,
           vCliente,
           vMoneda,
           vAgente,
           vFisico_Refe,
           VSerie_Refe;
    vExiste := c_doc_factu%FOUND;
    CLOSE c_doc_factu;
  
    IF NOT vExiste THEN
      msg_error_p := 'La transaccion de Devolucion ' || no_factu_p || ' no existe';
      RAISE error_proceso;
    END IF;
  END IF;
  --
  -- Inserta un documento de CREDITO en ARCCMD
  --
  vsaldo_doc_ccmd := vtotal_devol; -- positivo pues el credito queda pendiente

  OPEN c_sub_cliente;
  FETCH c_sub_cliente
    INTO vSubCliente;
  CLOSE c_sub_cliente;

  OPEN c_tot_imp;
  FETCH c_tot_imp
    INTO Ln_tot_imp;
  CLOSE c_tot_imp;

  INSERT INTO arccmd
    (no_cia,
     centro,
     tipo_doc,
     periodo,
     ruta,
     no_docu,
     grupo,
     no_cliente,
     fecha,
     fecha_documento,
     cod_diario,
     m_original,
     descuento,
     saldo,
     estado,
     moneda,
     tipo_cambio,
     no_agente,
     total_ref,
     origen,
     ano,
     mes,
     semana,
     no_fisico,
     serie_fisico,
     tipo_venta,
     monto_bienes,
     monto_serv,
     monto_exportac,
     no_docu_refe,
     sub_cliente,
     no_autorizacion,
     fecha_vigencia_autoriz,
     no_fisico_refe,
     serie_fisico_refe,
     tot_imp,
     gravado,
     subtotal,
     Total_Db,
     Total_Cr)
  
  VALUES
    (no_cia_p,
     vCentro,
     vdoc_devol_cxc,
     ano_proce_p,
     vRuta,
     no_factu_p,
     vGrupo,
     vCliente,
     fecha_p,
     fecha_p,
     rtd.cod_diario,
     vtotal_devol,
     0,
     vsaldo_doc_ccmd,
     'P',
     vMoneda,
     tipo_cambio_p,
     vAgente,
     vtotal_ref,
     'FA',
     ano_proce_p,
     mes_proce_p,
     sem_proce_p,
     no_fisico_p,
     serie_fisico_p,
     'V',
     monto_bien_p,
     monto_serv_p,
     monto_exp_p,
     no_refe_p,
     NVL(ed.sub_cliente, vSubCliente),
     autorizacion_p,
     fautorizac_p,
     vFisico_Refe,
     VSerie_Refe,
     Ln_tot_imp,
     abs(monto_bien_p),
     abs(monto_bien_p),
     vtotal_devol,
     vtotal_devol);
  --
  IF vtotal_ref > 0 THEN
    -- --
    -- Inserta un registro en la tabla de referencia a documentos 
    INSERT INTO arccrd
      (no_cia,
       tipo_doc,
       no_docu,
       tipo_refe,
       no_refe,
       monto,
       fecha_vence,
       monto_refe,
       moneda_refe,
       fec_aplic,
       ano,
       mes)
    VALUES
      (no_cia_p,
       vdoc_devol_cxc,
       no_factu_p,
       ed.tipo_doc,
       no_refe_p,
       vtotal_ref,
       fecha_p,
       vtotal_ref,
       ed.moneda,
       fecha_p,
       ano_proce_p,
       mes_proce_p);
  END IF;
  --- Se crea el registro del impuesto ANR 08/10/2009 se copia para tener un mismo sitio de donde
  -- tomar la informacion para el SRI LJA 25/05/2010.
  BEGIN
    INSERT INTO Arccti
      (no_cia,
       grupo,
       no_cliente,
       tipo_doc,
       no_docu,
       no_refe,
       clave,
       porcentaje,
       monto,
       codigo_tercero,
       base,
       comportamiento,
       aplica_cred_fiscal,
       ind_imp_ret,
       id_sec,
       usuario_registra,
       tstamp)
      SELECT b.no_cia,
             a.grupo,
             a.no_cliente,
             vdoc_devol_cxc,
             b.no_factu,
             b.no_factu,
             b.clave,
             b.porc_imp,
             SUM(b.monto_imp),
             b.codigo_tercero,
             SUM(base),
             b.comportamiento,
             b.aplica_cred_fiscal,
             'I',
             b.id_sec,
             USER,
             SYSDATE
        FROM arfafe  a,
             arfafli b
       WHERE b.no_cia = no_cia_p
         AND b.no_factu = no_factu_p
         AND a.no_cia = b.no_cia
         AND a.no_factu = b.no_factu
       GROUP BY b.no_cia,
                a.grupo,
                a.no_cliente,
                vdoc_devol_cxc,
                b.no_factu,
                b.no_factu,
                b.clave,
                b.porc_imp,
                b.codigo_tercero,
                b.comportamiento,
                b.aplica_cred_fiscal,
                'I',
                b.id_sec,
                USER,
                SYSDATE;
  
  EXCEPTION
    WHEN OTHERS THEN
      msg_error_p := 'Error al crear registro para el impuesto. Transaccion: ' || no_factu_p || ' ' || SQLERRM;
      RAISE error_proceso;
  END;
  --
  CCACTUALIZA_DEV(no_cia_p, --/*tipo_doc_p*/ 
                  vdoc_devol_cxc, --Tipo Documento NC
                  no_factu_p,
                  msg_error_p);

  IF msg_error_p IS NOT NULL THEN
    RAISE error_proceso;
  END IF;

EXCEPTION
  WHEN error_proceso THEN
    msg_error_p := NVL(msg_error_p, 'ERROR EN FADEVOLUCION_CXC');
    RETURN;
  WHEN OTHERS THEN
    msg_error_p := 'FAdevolucionCxC: ' || msg_error_p || ' ' || SQLERRM(SQLCODE);
    RETURN;
END;