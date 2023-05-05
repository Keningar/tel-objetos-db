CREATE EDITIONABLE PROCEDURE            INACT_INGRESO_VARIO (cia_p         IN varchar2,
                                                 tipo_p        IN varchar2,
                                                 docu_p        IN varchar2,
                                                 movimi_p      IN varchar2,
                                                 interface_p   IN varchar2,
                                                 cta_docu_p    IN varchar2,
                                                 time_stamp_p  IN date,
                                                 msg_error_p   IN OUT varchar2) Is
/**
 * Documentacion para INACT_INGRESO_VARIO
 * Este procedimiento es un apoyo al procedimiento INactualiza, y por lo tanto solo INactualiza deberia utilizarlo.
 * 
 * @author yoveri
 * @version 1.0 23-01-2009
 *
 * @author llindao <llindao@telconet.ec>
 * @version 1.1 02/08/2018 Se modifica para considerar nuevo campo que guarda la cantidad que representa cada nmero de serie registrado.
 * 
 * @author llindao <llindao@telconet.ec>
 * @version 1.2 06/08/2018 Se modifica para corregir cursor que recupera los artculos con cantidad series distintas respecto a la cantidad ingresada
 * 
 * @param pCia         IN VARCHAR2 recibe codigo de compania
 * @param tipo_p       IN VARCHAR2 recibe tipo de documento
 * @param docu_p       IN VARCHAR2 recibe numero transaccion cxp
 * @param movimi_p     IN VARCHAR2 recibe tipo de movimiento
 * @param interface_p  IN VARCHAR2 recibe cdigo de interfaz
 * @param cta_docu_p   IN VARCHAR2 recibe cuenta contable 
 * @param time_stamp_p IN DATE     recibe fecha sistema,
 * @param msg_error_p  IN OUT VARCHAR2 retorma mensaje de error
 */


  CURSOR c_documento IS
    SELECT e.no_cia, e.centro, e.tipo_doc, e.no_docu,
           e.periodo, e.ruta,
           e.fecha, e.conduce,
           e.observ1, e.tipo_cambio,
           e.tipo_refe, e.no_refe,
           e.rowid rowid_me
      FROM arinme e
     WHERE e.no_cia     = cia_p
       AND e.no_docu    = docu_p
       AND e.tipo_doc   = tipo_p
       AND e.estado     = 'P';
  --
  -- Lineas de transaccion
  CURSOR c_lineas_doc IS
    SELECT l.linea_ext, l.linea, l.bodega,
           l.no_arti,
           nvl(l.unidades,0) unidades,
           nvl(l.monto,0) monto,
           nvl(l.monto2,0) monto2,
           (nvl(l.monto,0) - nvl(l.descuento_l,0) + nvl(l.impuesto_l,0)) neto,
           (nvl(l.monto2,0) - nvl(l.descuento_l,0) + nvl(l.impuesto_l,0)) neto2, --FEM
           nvl(l.monto_dol,0) monto_dol,
           nvl(l.monto2_dol,0) monto_dol2,
           d.grupo, d.costo_estandar, a.costo_uni,a.ult_costo,
           l.rowid rowid_ml,L.PRECIO_VENTA
      FROM arinda d, arinml l, arinma a
     WHERE l.no_cia     = cia_p
       AND l.no_docu    = docu_p
       AND l.tipo_doc   = tipo_p
       AND l.no_cia     = d.no_cia
       AND l.no_arti    = d.no_arti
       AND -- join con arinma
           a.no_cia     = l.no_cia
       AND a.bodega     = l.bodega
       AND a.no_arti    = l.no_arti;
  --
  --
  CURSOR c_lotes ( cia_c  varchar2,     tip_c  varchar2,    doc_c  varchar2,
                   lin_c  number) IS
    SELECT no_lote, nvl(unidades,0) unidades,
           0 monto,
           ubicacion, fecha_vence
      FROM arinmo
     WHERE no_cia   = cia_c
       AND no_docu  = doc_c
       AND tipo_doc = tip_c
       AND linea    = lin_c ;

  Cursor C_contrapartida (Cv_cia in varchar2,
                          Cv_int in varchar2,
                          Cv_tip in varchar2,
                          Cv_mov in varchar2) Is
  Select cta_contrapartida
    From arinvtm
   Where no_cia    = Cv_cia
     and interface = Cv_int
     and tipo_m    = Cv_tip
     and movimi    = Cv_mov;

  -- validacion de Numeros de Series.
  CURSOR C_PRODUCTO_SERIE IS
    SELECT NS.NO_CIA,
           NS.NO_DOCU,
           NS.LINEA,
           NS.NO_ARTI,
           NS.UNIDADES,
           SUM(NS.CANT_SERIE) CANTIDAD_SERIE
    FROM (SELECT ML.NO_CIA,
                 ML.NO_DOCU,
                 ML.LINEA,
                 ML.NO_ARTI,
                 ML.UNIDADES,
                 INS.SERIE,
                 INS.UNIDADES CANT_SERIE
            FROM ARINDA DA,
                 INV_NUMERO_SERIE INS,
                 ARINML ML,
                 INV_DOCUMENTO_SERIE IDS
          WHERE IDS.LINEA = ML.LINEA
          AND IDS.ID_DOCUMENTO = ML.NO_DOCU
          AND IDS.COMPANIA = ML.NO_CIA
          AND IDS.SERIE = INS.SERIE
          AND ML.NO_ARTI = INS.NO_ARTICULO
          AND IDS.COMPANIA = INS.COMPANIA
          AND ML.NO_ARTI = DA.NO_ARTI
          AND ML.NO_CIA = DA.NO_CIA
          AND IDS.ID_DOCUMENTO = docu_p
          AND IDS.COMPANIA  = cia_p
          AND DA.IND_REQUIERE_SERIE = 'S'
          UNION
          SELECT ML.NO_CIA,
                 ML.NO_DOCU,
                 ML.LINEA,
                 ML.NO_ARTI,
                 ML.UNIDADES,
                 NULL SERIE,
                 0 CANT_SERIE
          FROM ARINDA DA,
               ARINML ML
          WHERE ML.NO_ARTI = DA.NO_ARTI
          AND ML.NO_CIA = DA.NO_CIA
          AND ML.NO_DOCU = docu_p
          AND ML.NO_CIA  = cia_p
          AND DA.IND_REQUIERE_SERIE = 'S'
          AND NOT EXISTS (SELECT NULL
                          FROM INV_DOCUMENTO_SERIE IDS
                          WHERE IDS.LINEA = ML.LINEA
                          AND IDS.ID_DOCUMENTO = ML.NO_DOCU
                          AND IDS.COMPANIA = ML.NO_CIA)) NS
  GROUP BY NS.NO_CIA,
           NS.NO_DOCU,
           NS.LINEA,
           NS.NO_ARTI,
           NS.UNIDADES
  HAVING NS.UNIDADES != SUM(NS.CANT_SERIE);
  --
  Lr_ProductoSerie C_PRODUCTO_SERIE%ROWTYPE := NULL;
  --

  error_proceso      EXCEPTION;
  --
  vtime_stamp        Date;
  rper               inlib.periodo_proceso_r;
  vfound             Boolean;
  vcta_inv           arindc.cuenta%type;
  vcta_haber         arindc.cuenta%type;  -- cta del proveedor o del documento (si mov.no tiene prov)
  vtmov_ctaInv       arindc.tipo_mov%type;
  vtmov_ctaHaber     arindc.tipo_mov%type;
  vsigno             number(2);
  vmov_tot           arinme.mov_tot%type;
  vmov_tot2          arinme.mov_tot%type;   --FEM
  vmonto_lote        number;
  vrctas             inlib.cuentas_contables_r;
  vcta_cpartida      arindc.cuenta%type;
  vcentro_costo      arincc.centro_costo%type;
  vtercero_dc        arindc.codigo_tercero%type:=null;
  rd                 c_documento%ROWTYPE;
  Lv_contrapartida   arinvtm.cta_contrapartida%type;

BEGIN
  --
  --
  vtime_stamp  := time_stamp_p;
  --
  -- llindao: se valida el numeros de serie
  IF C_PRODUCTO_SERIE%ISOPEN THEN CLOSE C_PRODUCTO_SERIE; END IF;
  OPEN C_PRODUCTO_SERIE;
  FETCH C_PRODUCTO_SERIE INTO Lr_ProductoSerie;
  IF C_PRODUCTO_SERIE%FOUND THEN
    msg_error_p := 'Existe productos con diferencias entre unidades ingresadas y Numeros de series, favor revisar...';
    Raise Error_proceso;
  END IF;
  CLOSE C_PRODUCTO_SERIE;
  --
  IF cta_docu_p is null THEN
    msg_error_p := 'El tipo de documento NO tiene definida cuenta contable...';
    RAISE error_proceso;
  END IF;
  -- Busca el documento a actualizar

  OPEN  c_documento;
  FETCH c_documento INTO rd;
  vfound := c_documento%FOUND;
  CLOSE c_documento;

  IF not vfound THEN
    msg_error_p := 'No fue posible localizar la transaccion: '||docu_p;
    RAISE error_proceso;
  END IF;

  -- trae el periodo en proceso
  vfound := inlib.trae_periodo_proceso(rd.no_cia, rd.centro, rper);
  -- define el vsigno de la actualizacion y la forma del detalle contable
  vcta_haber := cta_docu_p;

  If movimi_p = 'E' Then
    vsigno         :=  1;
    vtmov_ctaInv   := 'D';
    vtmov_ctaHaber := 'C';
  Else
    vsigno         := -1;
    vtmov_ctaInv   := 'C';
    vtmov_ctaHaber := 'D';
  End If;

  -- Crea el documento en el historico de encabezado de documento
  INcrea_encabezado_h(rd.rowid_me, rper.mes_proce, rper.semana_proce, rper.indicador_sem);
  --
  vmov_tot := 0;
  FOR i IN c_lineas_doc LOOP
    -- Trae la cuenta de inventario para el grupo contable y bodega
    -- que se esta procesando en esta linea.
    IF not INLIB.trae_cuenta_inventario(cia_p, i.grupo, i.bodega, vcta_inv) THEN
      msg_error_p := 'Falta definir la cuenta de inventario, '||
                     'para bodega: '||i.bodega||'  grupo: '||i.grupo;
      RAISE error_proceso;
    END IF;


    vmov_tot   := nvl(vmov_tot, 0)  + nvl(i.monto,0);
    vmov_tot2  := nvl(vmov_tot2, 0)  + nvl(i.monto2,0);

    --


    If cuenta_contable.acepta_tercero(cia_p, vcta_inv) THEN
      msg_error_p := 'La cuenta de Inventarios para los articulos en la bodega '||
                     i.bodega||' y grupo '||i.grupo||' no debe manejar terceros';
      Raise error_proceso;
    End If;

    If cuenta_contable.acepta_tercero(cia_p, vcta_haber) Then
      msg_error_p := 'La cuenta de contrapartida para el tipo de documento '||
                     rd.tipo_doc||' NO debe manejar terceros';
      Raise Error_proceso;
    End If;

     If Not INLIB.trae_cuentas_conta(cia_p, i.grupo, i.bodega, vrctas) Then
       msg_error_p := 'Falta definir las cuentas contables, '||
                      'para bodega: '||i.bodega||'  grupo: '||i.grupo;
       Raise error_proceso;
     End If;

     Open C_contrapartida(cia_p, interface_p, tipo_p, movimi_p);
     Fetch C_contrapartida into Lv_contrapartida;
     Close C_contrapartida;

     vcta_inv       := vrctas.cta_inventario;
     vcta_cpartida  := Lv_contrapartida;
     vcentro_costo  := vrctas.centro_costo;

    If vcta_cpartida is null then
      msg_error_p:= 'Falta definir la cuenta contrapartida';
      Raise Error_proceso;
    End If;

     -- movimiento contable a la cuenta de inventario
     INinserta_dc(rd.no_cia,      rd.centro,     rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaInv,  vcta_inv,
                  i.monto,        vcentro_costo, i.monto_dol,
                  rd.tipo_cambio, vtercero_dc);
     --
     -- movimiento contable a la cuenta contrapartida
     INinserta_dc(rd.no_cia,      rd.centro,       rd.tipo_doc,
                  rd.no_docu,     vtmov_ctaHaber,  vcta_cpartida,
                  i.monto,        vcentro_costo, i.monto_dol,
                  rd.tipo_cambio, vtercero_dc);
     --
     /**** NOTA IMPORTANTE: El orden de los procedimientos siempre va a ser:
           INCOSTO_UNI (SI ES ENTRADA DE COMPRAS, ENTRADA REORDENAMIENTO, ENTRADA IMPORTACION)
           INACTUALIZA_SALDOS_ARTICULOS (PARA TODOS LOS CASOS)
           INCOSTO_ACTUALIZA (PARA TODOS LOS CASOS)
           ANR 16/06/2010
     ****/

      IF movimi_p = 'E' THEN

      -- El costo unitario solamente se actualiza cuando se trata
      -- de movimientos de entrada

        INcosto_Uni(rd.no_cia,
                    i.bodega,
                    i.no_arti,
                    i.unidades, --- cantidad transaccion
                    i.monto/i.unidades, --- costo de la transaccion
                    i.monto2/i.unidades,   --- costo2 de la transaccion
                    msg_error_p);
        If msg_error_p is not null Then
          Raise error_proceso;
        End If;
      End If;

     ---- Actualiza los campos de stock en ARINMA

      INActualiza_saldos_articulo  (rd.no_cia, i.bodega, i.no_arti, 'PRODUCCION',
                                    (i.unidades * vsigno), (i.monto * vsigno),
                                    Null, msg_error_p);


     IF msg_error_p is not null THEN
       RAISE error_proceso;
     END IF;

    --- Este proceso se utiliza para actualizar los saldos valuados del costo y costo 2 del inventario ANR 27/04/2009

      INCOSTO_ACTUALIZA (rd.no_cia, i.no_arti);



    -- Inserta en ARINMN la linea que se esta procesando
    INinserta_mn(rd.no_cia,         rd.centro,          rd.tipo_doc,
                 rd.no_docu,        rd.periodo,         rper.mes_proce,
                 rper.semana_proce, rper.indicador_sem, rd.ruta,
                 i.linea_ext,       i.bodega,           i.no_arti,
                 rd.fecha,          i.unidades,         i.monto,
                 null,              rd.tipo_refe,       rd.no_refe,
                 null,              i.monto/i.unidades,            vtime_stamp,
                 '000000000',       'N',                i.precio_venta,
                 i.monto2,          i.monto2/i.unidades);


    -- se efectua las actualizaciones para el desglose de los lotes de articulos.
    FOR j IN c_lotes(rd.no_cia, rd.tipo_doc, rd.no_docu, i.linea) LOOP
      vmonto_lote := moneda.redondeo(j.monto, 'P');
      UPDATE arinlo
         SET saldo_unidad   = nvl(saldo_unidad, 0) + (j.unidades * vsigno),
             saldo_contable = 0,
             saldo_monto    = 0
       WHERE no_cia = rd.no_cia
         AND bodega = i.bodega
         AND no_arti = i.no_arti
         AND no_lote = j.no_lote;
      --
      IF (sql%rowcount = 0) THEN
        INSERT INTO arinlo(no_cia,         bodega,
                           no_arti,        no_lote,     ubicacion,   saldo_unidad,
                           saldo_contable, saldo_monto, salida_pend, costo_lote,
                           proceso_toma,   exist_prep,  costo_prep,
                           fecha_entrada,  fecha_vence, fecha_fin_cuarentena )
                    VALUES(rd.no_cia,  i.bodega,
                           i.no_arti,  j.no_lote,     j.ubicacion, j.unidades,
                           0,0,0,0,
                           'N',        null,      null,
                           rd.fecha,   j.fecha_vence, null);
      END IF;
      -- Inserta en ARINMT la linea que se esta procesando
      INSERT INTO arinmt(no_cia,   centro,    tipo_doc,  ano,
                         ruta,     no_docu,   no_linea,  bodega,
                         no_arti,   no_lote,
                         unidades, venta,     descuento)
                  VALUES(rd.no_cia,  rd.centro,   rd.tipo_doc, rd.periodo,
                          rd.ruta,    rd.no_docu,  i.linea_ext, i.bodega,
                         i.no_arti,   j.no_lote,
                         j.unidades, 0,           0);
    END LOOP;  -- lotes de articulos
  END LOOP; -- Lineas del documento

  --

--- Verifico que el asiento contable cuadre ANR 26/11/2010
    IF NOT (INKG_RETIRO_EQUIPO_VAR.GRX_ENTRE_EMPRESAS) then
        If inverifica_conta(cia_p, docu_p, msg_error_p) then
           raise Error_proceso;
        end if;
    end if;

  --
  -- Actualiza el estado del documento
  Update arinme
     Set estado  = 'D',
         mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2
   Where rowid = rd.rowid_me;

  Update arinmeh
     SET mov_tot = vmov_tot,
         mov_tot2 = vmov_tot2
   where no_cia = cia_p
   and   no_docu = docu_p;
  --

EXCEPTION
  WHEN cuenta_contable.error THEN
       msg_error_p := cuenta_contable.ultimo_error;
       return;
  WHEN error_proceso THEN
       msg_error_p := NVL(msg_error_p, 'Error_proceso en INACT_INGRESO_VARIO');
       return;
  WHEN others THEN
       msg_error_p := 'INACT_INGRESO_VARIO'|| SQLERRM;
       return;
END;
/