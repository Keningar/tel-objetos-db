create or replace PROCEDURE            FAanula_inve(
  pCia          IN      arfafe.no_cia%type,
  pTipo_Doc     IN      arfafe.tipo_doc%type,
  pNo_Factu     IN      arfafe.No_factu%type,
  pTipo_Anula   IN      arfafe.tipo_doc%type,
  pNo_Anula     IN      arfafe.no_factu%type,
  pNo_Fisico    IN      arfafe.no_fisico%type,      -- num. fisico, doc. anulacion
  pSerie_Fisico IN      arfafe.serie_Fisico%type,
  pNo_Refe      IN      arfafe.no_fisico%type,      -- num. fisico, factura original
  pSerie_Refe   IN      arfafe.serie_Fisico%type,
  pFec_Anula    IN      arfafe.Fecha%type,
  pAno_proce    IN      Arincd.ano_proce_fact%type,
  pMes_proce    IN      Arincd.ano_proce_fact%type,
  pSem_proce    IN      Arincd.ano_proce_fact%type,
  msg_error_p   IN OUT varchar2
) is
  --
  error_proceso    EXCEPTION;

  vdoc_anula_inve  arinme.tipo_doc%type;
  vdoc_inve        arinme.tipo_doc%type;
  --
  CURSOR c_docu_inv is
    select centro, periodo, ruta,
           estado, mov_tot, tipo_cambio,tipo_doc,
           rowid
    from arinme
    where no_cia    = pcia
      and no_docu   = pno_factu;


   CURSOR c_datos_tipo_doc (pdocto in varchar2) IS
    SELECT interface, movimi,ventas
      FROM arinvtm
     WHERE no_cia     = pcia
       AND tipo_m     = pdocto;
  --

  edi  c_docu_inv%rowtype;
  rtd c_datos_tipo_doc%rowtype;
  vExiste  Boolean;
BEGIN
  open c_docu_inv;
  fetch c_docu_inv into edi;
  if c_docu_inv%notfound then
     close c_docu_inv;
     msg_error_p := 'No existe la factura en inventario';
     raise error_proceso;
  end if;
  close c_docu_inv;
  --

  -- Obtiene el mov generado en inventarios
  vdoc_inve := INLIB.doc_inve(pcia,ptipo_doc);
  if vdoc_inve is null then
    msg_error_p:='No se encontro documento generado por la entrada de la factura, en inventarios';
    raise error_proceso;
  end if;

  -- Obtiene el documento que anulara el docto en inventarios
  vdoc_anula_inve :=INLIB.doc_inve(pcia,ptipo_anula);

  OPEN  c_datos_tipo_doc(vdoc_anula_inve);
  FETCH c_datos_tipo_doc INTO rtd;
  vExiste:=c_datos_tipo_doc%found;
  CLOSE c_datos_tipo_doc;

  IF not vExiste then
    msg_error_p := 'El tipo de movimiento a generar en la anulacion del mov de inventario no existe';
    RAISE error_proceso;
  ELSIF rtd.movimi != 'E' THEN
    msg_error_p := 'El tipo de movimiento de la anulacion del docto en inventario debe ser de entrada';
    RAISE error_proceso;
  ELSIF rtd.ventas !='S' THEN
    msg_error_p := 'El docto de anulacion en inventario debe ser de venta';
    RAISE error_proceso;
  ELSIF rtd.interface !='FA' THEN
    msg_error_p := 'El docto de anulacion en inventario debe tener interface con facturacion';
    RAISE error_proceso;
  END IF;

  if edi.estado = 'P' then
     -- --
     -- El producto no ha sido entregado, entonces simplemente borra el
     -- documento de despacho
     --
     -- borra las lineas de lotes
     delete arinmo
        where no_cia    = pcia
          and no_docu   = pno_factu;
     -- borra las lineas detalle
     delete arinml
        where no_cia    = pCia
          and no_docu   = pno_factu;
     -- borra el encabezado
     delete arinme
       where rowid = edi.rowid;
  else
     -- --
     -- El documento de despacho ya fue actualizado,
     -- asi que crea un documento para la recepcion de la mercaderia
     --
     Begin
     insert into arinme(no_cia,       centro,      tipo_doc,
                        periodo,      ruta,        no_docu,
                        estado,       fecha,       mov_tot,
                        no_fisico,    serie_fisico,
                        tipo_cambio,  tipo_refe,   no_refe,     serie_refe,
                        no_docu_refe, origen )
                 values(
                        pcia,            edi.centro,    vdoc_anula_inve,
                        pano_proce,      edi.ruta,      pno_anula,
                        'P',             pfec_anula,    edi.mov_tot,
                        pNo_Fisico,      pSerie_Fisico,
                        edi.tipo_cambio, vdoc_inve,     pNo_factu, pSerie_Fisico,
                        pno_factu,       'FA');
     Exception
     When Others Then
       msg_error_p := 'Error al crear registro inventario. Factura: '||pno_factu||' '||sqlerrm;
       raise Error_proceso;
     End;
     --
     Begin
     insert into arinml(no_cia,    centro,    tipo_doc,  periodo,
                        ruta,      no_docu,   linea,     linea_ext,
                        bodega,    clase,     categoria, no_arti,
                        ind_iv,    unidades,  monto,     tipo_cambio,
                        monto_dol, ind_oferta, time_stamp, monto2, monto2_dol)
                 select
                        no_cia,    centro,    vdoc_anula_inve, pano_proce,
                        edi.ruta,  pno_anula, linea,       linea_ext,
                        bodega,    clase,     categoria,   no_arti,
                        ind_iv,    unidades,  monto,       tipo_cambio,
                        monto_dol, ind_oferta, sysdate, monto2, monto2_dol --- se agrega monto2 ANR 12/04/2010
        from arinml
        where no_cia    = pcia
          and no_docu   = pno_factu;
       Exception
       When Others Then
         msg_error_p := 'Error al crear registro linea de inventario. Factura: '||pno_factu||' '||sqlerrm;
         raise Error_proceso;
       End;


      ---- Se debe crear la linea de lote ANR 12/04/2010
       Begin
       insert into arinmo (no_cia, centro, tipo_doc, periodo, ruta, no_docu, linea,
                           no_lote, unidades, monto, descuento_l, imp_ventas_l, ubicacion,
                           fecha_vence)
       select no_cia, centrod, vdoc_anula_inve, pano_proce, edi.ruta,  pno_anula, no_linea,
              no_lote, unidades, 0, 0, 0, ubicacion,
              fecha_vence
       from arfafl_lote
       where no_cia  = pcia
       and no_factu   = pno_factu;
       Exception
       When Others Then
         msg_error_p := 'Error al crear registro de lote (inventario). Factura: '||pno_factu||' '||sqlerrm;
         raise Error_proceso;
       End;

      --- Debe actualizar inmediatamente el inventario en la anulacion ANR 01/09/2009
      InActualiza(pcia, vdoc_anula_inve, pno_anula, msg_error_p);
      IF msg_error_p is not null THEN
        RAISE error_proceso;
      END IF;

      return;

  end if;
EXCEPTION
  when error_proceso then
      msg_error_p := ' FAANULA_INVE '||NVL(msg_error_p, 'FAANULA_INVE');
      return;
  when others then
      msg_error_p := ' FAANULA_INVE '||NVL(sqlerrm(sqlcode), 'FAANULA_INVE');
      return;
END;