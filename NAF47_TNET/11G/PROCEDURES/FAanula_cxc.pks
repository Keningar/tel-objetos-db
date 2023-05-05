create or replace PROCEDURE            FAanula_cxc(
  no_cia_p       IN      arfafe.no_cia%type,
  tipo_doc_p     IN      arfafe.tipo_doc%type,     -- tipo doc (anulacion)
  no_factu_p     IN      arfafe.no_factu%type,     -- no. transa (anulacion)
  no_fisico_p    IN      arfafe.no_fisico%type,    -- num. fisico (anulacion)
  serie_fisico_p IN      arfafe.serie_fisico%type, -- serie (anulacion)
  fecha_p        IN      arfafe.Fecha%type,
  tipo_cambio_p  IN      arfafe.tipo_cambio%type,
  ano_proce_p    IN      arincd.ano_proce_fact%type,
  mes_proce_p    IN      arincd.ano_proce_fact%type,
  sem_proce_p    IN      arincd.ano_proce_fact%type,
  tipo_refe_p    IN      arfafe.tipo_doc%type,     -- tipo doc (factura)
  no_refe_p      IN      arfafe.no_factu%type,     -- no. transa (factura)
  detalle_p      IN      arfafe.motivo_anula%type,
  autorizacion_p IN      arfafe.no_autorizacion%type,
  fautorizac_p   IN      arfafe.fecha_vigencia_autoriz%type,
  msg_error_p    IN OUT  varchar2
) is
  --***
  --* Anula el documento en CxC, pero si este esta en estado pendiente simplemente
  --* lo borra
  --* NOTA:
  --*   1.El campo saldo de un credito pendiente de actualizar en CxC,
  --*     aun cuando tiene referencias, queda positivo e igual al monto original
  --*
  vtipo_mov             arcctd.tipo_mov%type;
  vindfactura           arcctd.factura%type;
  vsaldo_doc_ccmd       arccmd.saldo%type;
  vtotal_anul           arccmd.m_original%type;
  vtotal_ref            arccmd.total_ref%type;
  vdoc_anula_cxc        arfact.tipo_doc_cxc%type;
  vExiste               Boolean;
  --
  error_proceso   EXCEPTION;
  --
  CURSOR c_datos_tipo_doc IS
    SELECT tipo_mov, factura, cod_diario, formulario
      FROM arcctd
     WHERE no_cia   = no_cia_p
       AND tipo     = vdoc_anula_cxc;
  --
  CURSOR c_doc_cxc IS
    SELECT centro,       no_cliente,   grupo,
           ruta,         estado,       nvl(m_original,0) m_original,
           nvl(saldo,0)  saldo,        no_agente,   periodo,   moneda,
           tipo_venta,   monto_bienes, monto_serv,  monto_exportac,tipo_doc, sub_cliente,
           rowid
      FROM arccmd
     WHERE no_cia       = no_cia_p
       AND no_docu      = no_refe_p;

   --
   ed           c_doc_cxc%rowtype;
   vcod_diario  arccmd.cod_diario%type;

   lv_formulario arcctd.formulario%type;

BEGIN

  -- Recupera datos del documento generado en CxC
  OPEN  c_doc_cxc;
  FETCH c_doc_cxc INTO ed;
  IF c_doc_cxc%notfound THEN
  	close c_doc_cxc;
    msg_error_p := 'No encontro la factura en Cuentas por Cobrar';
    RAISE error_proceso;
  END IF;
  close c_doc_cxc;
  --
  -- Obtiene el documento que anulara el docto en cxc
  vdoc_anula_cxc := INLIB.doc_cxc(no_cia_p,tipo_doc_p);

  OPEN  c_datos_tipo_doc;
  FETCH c_datos_tipo_doc INTO vtipo_mov, vindfactura, vcod_diario, lv_formulario;
  vExiste := c_datos_tipo_doc%found;
  CLOSE c_datos_tipo_doc;

  IF not vExiste then
  	msg_error_p := 'El tipo de movimiento a generar en la anulacion del mov de CxC no existe';
    RAISE error_proceso;
  ELSIF nvl(vtipo_mov,'X') != 'C' THEN
    msg_error_p := 'El tipo de movimiento de la anulacion: '||vdoc_anula_cxc||' deber ser de tipo CREDITO';
    RAISE error_proceso;
  ELSIF vindfactura !='S' THEN
  	msg_error_p := 'El docto de anulacion en CxC:  '||vdoc_anula_cxc||' no esta asociado una factura';
    RAISE error_proceso;
  END IF;

  --
  IF ed.saldo IS NULL OR ed.m_original IS NULL THEN
    msg_error_p := 'FAANULA_CXC : Saldo o mto_original es nulo';
    RAISE error_proceso;
  END IF;
  --
  vtotal_anul := ed.m_original;
  --
  -- verifica el estado de la factura en CxC
  IF ed.estado = 'P' then
    -- La factura original esta pendiente en CxC
    DELETE arccmd
     WHERE rowid = ed.rowid;
  ELSE
    -- La factura original en CxC esta actualizada, pero el total referencia
    -- no puede exceder el saldo del misma.
    vtotal_ref := LEAST(vtotal_anul, GREATEST(nvl(ed.saldo,0), 0));
    --
    vsaldo_doc_ccmd := ed.m_original;

    -- Inserta el docto que anula el docto generado en CxC desde facturacion
    INSERT INTO arccmd(no_cia,     centro,      tipo_doc,
                       periodo,    ruta,        no_docu,
                       grupo,      no_cliente,  fecha,
                       fecha_documento,         moneda,
                       m_original, descuento,   saldo,
                       estado,     tipo_cambio, cod_diario,
                       no_agente,  total_ref,
                       origen,     ano,         mes,
                       semana,     no_fisico,   serie_fisico,
                       tipo_venta, monto_bienes, monto_serv,
                       monto_exportac,no_docu_refe, sub_cliente, detalle, no_autorizacion, fecha_vigencia_autoriz, anulado ) --- marca el registro como anulado
                VALUES(no_cia_p,       ed.centro,      vdoc_anula_cxc,
                       ano_proce_p,    ed.ruta,        No_factu_p,
                       ed.grupo,       ed.no_cliente,  fecha_p,
                       fecha_p,        ed.moneda,
                       vtotal_anul,    0,              vsaldo_doc_ccmd,
                       'P',            tipo_cambio_p,  vcod_diario,
                       ed.no_agente,   vtotal_ref,
                       'FA',           ano_proce_p,   mes_proce_p,
                       sem_proce_p,    no_fisico_p,   serie_fisico_p,
                       ed.tipo_venta,  ed.monto_bienes, ed.monto_serv,
                       ed.monto_exportac, no_refe_p, ed.sub_cliente, detalle_p, autorizacion_p, fautorizac_p,'S');
    --
    IF vtotal_ref > 0 THEN
      -- --
      -- Inserta un registro en la tabla de referencia a documentos *
      --
      INSERT INTO arccrd (no_cia,    tipo_doc,   no_docu,
                          tipo_refe, no_refe,    monto,
                          fecha_vence,
                          monto_refe, moneda_refe, fec_aplic,
                          ano, mes)
                  VALUES (no_cia_p,   vdoc_anula_cxc,  no_factu_p,
                          ed.tipo_doc,no_refe_p,       vtotal_ref,
                          fecha_p,    vtotal_ref,      ed.moneda,
                          fecha_p,    ano_proce_p,     mes_proce_p );
    END IF;
    --
    ccActualiza(no_cia_p, tipo_doc_p, no_factu_p, msg_error_p);
    IF msg_error_p IS NOT NULL THEN
       RAISE error_proceso;
    END IF;
  END IF;  -- ed.estado = 'P'
EXCEPTION
  WHEN error_proceso THEN
       msg_error_p := NVL(msg_error_p, 'FAANULA_CXC');
       return;
  WHEN others THEN
       msg_error_p := 'FAANULA_CXC : '||sqlerrm;
       return;
END;