CREATE EDITIONABLE PROCEDURE            INACTUALIZA (
  pno_cia      IN naf47_tnet.arinme.no_cia%type,
  ptipo_doc    IN naf47_tnet.arinme.tipo_doc%type,
  pno_docu     IN naf47_tnet.arinme.no_docu%type,
  msg_error_p  IN OUT varchar2
) IS
  --
  error_proceso      exception;
  vtime_stamp        date;
   Lr_Transaccion     NAF47_TNET.ARINME%ROWTYPE;
  --
  CURSOR c_tipo_doc  IS
     SELECT m.movimi, m.consum,     m.produccion,
            m.compra, m.ventas,     m.interface,
            m.cta_contrapartida,    m.cta_contrapartida_dol,
            m.consig_cliente,       m.consig_vendedor,
            consum_facturado ,devol_facturado
       FROM naf47_tnet.arinvtm m
      WHERE m.no_cia   = pno_cia
        AND m.tipo_m   = ptipo_doc;
  --
  --
  rtd     c_tipo_doc%ROWTYPE;
  --
BEGIN
  moneda.inicializa(pno_cia);
  vtime_stamp := SYSDATE;
  --
  OPEN  c_tipo_doc;
  FETCH c_tipo_doc INTO rtd;
  CLOSE c_tipo_doc;
  -- Proceso que se llamaba desde la pantalla de Actualizacion.
  -- llindao: Habilitar numeros de series por numero de documento.
  naf47_tnet.INACT_NUMEROS_SERIES (pno_cia, 
                        pno_docu, 
                        NULL,
                        NULL,
                        msg_error_p);

  IF msg_error_p IS NOT NULL THEN
    RAISE error_proceso;
  END IF;


  IF rtd.compra = 'S' THEN
    naf47_tnet.INprorratea_montos(pno_cia, ptipo_doc, pno_docu, msg_error_p);
    naf47_tnet.INact_compra( pno_cia, ptipo_doc, pno_docu,
                  rtd.movimi, rtd.interface,
                  rtd.cta_contrapartida, rtd.cta_contrapartida_dol,
                  vtime_stamp, msg_error_p);

  ELSIF rtd.produccion = 'S' THEN
    naf47_tnet.INact_produccion( pno_cia, ptipo_doc, pno_docu,
                      rtd.movimi, rtd.interface, rtd.cta_contrapartida,
                      vtime_stamp, msg_error_p);

  ELSIF rtd.consum = 'S' THEN
    naf47_tnet.INact_requisicion( pno_cia, ptipo_doc, pno_docu,
                       rtd.movimi, rtd.interface, rtd.cta_contrapartida,
                       vtime_stamp, msg_error_p);

  ELSIF (rtd.movimi = 'S') and (rtd.ventas = 'S') and (rtd.interface = 'FA') THEN
    naf47_tnet.INact_despacho( pno_cia, ptipo_doc, pno_docu,
                    rtd.movimi, rtd.interface,
                    vtime_stamp, msg_error_p);

  ELSIF (rtd.movimi = 'E') and (rtd.ventas = 'S') and (rtd.interface = 'FA') THEN
    naf47_tnet.INact_recepcion( pno_cia, ptipo_doc, pno_docu,
                     rtd.movimi, rtd.interface,
                     vtime_stamp, msg_error_p);

  ELSIF (rtd.movimi = 'S') and (rtd.interface = 'OD') THEN
    naf47_tnet.INACT_OBSEQUIO_DONACION( pno_cia, ptipo_doc, pno_docu,
                             rtd.movimi, rtd.interface,
                             vtime_stamp, msg_error_p);

  --Modificado por Jorge Heredia 27-10-2008
  ELSIF (rtd.movimi = 'S') and (rtd.interface = 'ME') THEN
    naf47_tnet.INACT_BAJA_MAL_ESTADO( pno_cia, ptipo_doc, pno_docu,
                           rtd.movimi, rtd.interface,  rtd.cta_contrapartida,
                           vtime_stamp, msg_error_p);

  --Modificado por Marcos Toscano 06-11-2007
  ELSIF rtd.consum_facturado = 'S' THEN
    naf47_tnet.INact_consumo( pno_cia, ptipo_doc, pno_docu,
                   rtd.movimi, rtd.interface,  rtd.cta_contrapartida,
                   vtime_stamp, msg_error_p);
  --Modificado por Marcos Toscano 06-11-2007
  ELSIF rtd.devol_facturado = 'S' THEN
    naf47_tnet.inact_devconsumo( pno_cia, ptipo_doc, pno_docu,
                      rtd.movimi, rtd.interface,  rtd.cta_contrapartida,
                      vtime_stamp, msg_error_p);

   --Modificado por Jorge Heredia 03-12-2008
  ELSIF (rtd.movimi = 'E') and (rtd.interface = 'CJ') THEN
    naf47_tnet.INACT_INGRESO_CANJE( pno_cia, ptipo_doc, pno_docu,
                           rtd.movimi, rtd.interface,  rtd.cta_contrapartida,
                           vtime_stamp, msg_error_p);
  ELSIF (rtd.movimi = 'S') and (rtd.interface = 'CJ') THEN
    naf47_tnet.INACT_EGRESO_CANJE( pno_cia, ptipo_doc, pno_docu,
                           rtd.movimi, rtd.interface,  rtd.cta_contrapartida,
                           vtime_stamp, msg_error_p);

  -- Modificado por Miguel Guaranda 10-01-2009 -- Reverso del canje
  ELSIF (rtd.movimi = 'S') AND (rtd.interface = 'RC') THEN  -- (er)
    naf47_tnet.INACT_REVINGRESO_CANJE(pno_cia, ptipo_doc, pno_docu,
                           rtd.movimi, rtd.interface,  rtd.cta_contrapartida,
                           vtime_stamp, msg_error_p);
  ELSIF (rtd.movimi = 'E') AND (rtd.interface = 'RC') THEN -- (ir)
    naf47_tnet.INACT_REVEGRESO_CANJE(pno_cia, ptipo_doc, pno_docu,
                          rtd.movimi, rtd.interface,rtd.cta_contrapartida,
                          vtime_stamp, msg_error_p);
  ELSIF (rtd.movimi = 'E') AND (rtd.interface = 'VA') THEN -- (ingreso vario al inventario) anr 29/11/2010
    naf47_tnet.INACT_INGRESO_VARIO  (pno_cia, ptipo_doc, pno_docu,
                          rtd.movimi, rtd.interface,rtd.cta_contrapartida,
                          vtime_stamp, msg_error_p);
  -- llindao: egresos manuales
  ELSIF (rtd.movimi = 'S') AND (rtd.interface = 'VA') THEN -- (ingreso vario al inventario) anr 29/11/2010
    naf47_tnet.IN_P_EGRESOS_MANUALES ( pno_cia, 
                            ptipo_doc, 
                            pno_docu,
                            rtd.movimi, 
                            rtd.cta_contrapartida,
                            vtime_stamp, 
                            msg_error_p);

  -- MNAVARRETE: 06/08/2013 -- Ingreso de Equipo por retiro al Cliente
  ELSIF (rtd.movimi = 'E') AND (rtd.interface = 'CT') THEN 
    naf47_tnet.INACT_CONTROL_OTRA_EMPRESA (pno_cia, ptipo_doc, pno_docu,
                                rtd.movimi, rtd.interface,  rtd.cta_contrapartida,
                                vtime_stamp, msg_error_p);                              

  ELSE
    msg_error_p := 'Falta la logica para actualizar el tipo de documento: '||ptipo_doc;
    RAISE error_proceso;
  END IF;
  --
  IF msg_error_p is not null THEN
    RAISE error_proceso;
  END IF;  
  --
  naf47_tnet.PRKG_CONTROL_PRESUPUESTO.P_COSTEO_PEDIDO_BIENES (pno_docu, 
                                                              pno_cia, 
                                                              msg_error_p);
  --
  IF msg_error_p is not null THEN
    RAISE error_proceso;
  END IF;
  -- 
    --EMunoz Habiliata las devoluciones por prestamos y/o transferencias 27032021
  --Proceso que crea las devoluciones por prestamos de item a pedidos o
  --Proceso que crea el inicio de transferencias hasta que las reciban cuando son de diferente bodega
  NAF47_TNET.INK_PROCESA_PEDIDO_PRES.P_PROCESA_PRESTAMOS_PEDIDOS(pno_cia,--
                                                      ptipo_doc,--
                                                      pno_docu,--
                                                      msg_error_p );
  IF msg_error_p IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  --
  --
  --
  Lr_Transaccion.No_Cia   := pno_cia ;
  Lr_Transaccion.Tipo_Doc := ptipo_doc;
  Lr_Transaccion.No_Docu  := pno_docu;


  NAF47_TNET.INKG_TRANSACCION.P_AUDITORIA_ELEMENTOS(Lr_Transaccion,msg_error_p);

  IF msg_error_p is not null THEN
    RAISE error_proceso;
  END IF;

EXCEPTION
  WHEN error_proceso THEN
       msg_error_p := nvl(msg_error_p, 'ERROR: En procedimiento IN_actualiza');
       return;
  WHEN others THEN
       msg_error_p := sqlerrm;
       return;
END;
/