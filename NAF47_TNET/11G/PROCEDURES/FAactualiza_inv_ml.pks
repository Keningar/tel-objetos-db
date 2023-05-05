create or replace PROCEDURE            FAactualiza_inv_ml(
  no_cia_p     in     varchar2,
  centrod_p    in     varchar2,
  tipo_doc_p   in     varchar2,
  periodo_p    in     varchar2,
  ruta_p       in     varchar2,
  no_factu_p   in     varchar2,
  linea_p      in     number,
  linea_fac_p  in     number, --- linea de la factura
  consig_p     in     varchar2, --- consignacion S o N
  bodega_p     in     varchar2,
  clase_p      in     varchar2,
  categoria_p  in     varchar2,
  no_arti_p    in     varchar2,
  ind_lote_p   in     varchar2,
  ind_oferta_p in     varchar2,	-- S y N
  unidades_p   in     number,
  costo_p      in     number,       -- costo unitario
  monto_p      in     number,       -- costo total
  monto2_p     in     number,
  tc_p         in     number,
  fecha_p      in     date,
  msg_error    in out varchar2
) IS
  -- --
  -- Crea las lineas del documento en inventario
  --
  -- ** NOTAS IMPORTANTES:
  --    1. El que llame a este procedimiento debe haber inicializado el PAQUETE MONEDA,
  --       pues se utiliza la funcion redondeo
  --
  vcant_x_dist	number;
  vmonto_x_dist	number;
  vcant_lote   	number;
  vmonto_lote	  number;
  error_proceso	exception;
  --
  Cursor C_Factura Is
   Select no_pedido
   From   Arfafe
   Where  no_cia   = no_cia_p
   and    no_factu = no_factu_p;

  --
  CURSOR c_lotes IS
    SELECT no_lote, fecha_vence, ubicacion,
           (nvl(saldo_unidad, 0) - nvl(salida_pend,0)) saldo_disponible
      FROM arinlo
     WHERE no_cia                = no_cia_p
       AND bodega                = bodega_p
       AND no_arti               = no_arti_p
       AND nvl(saldo_unidad, 0)  > 0
     ORDER BY fecha_vence;
  --
  vMonto_Dol    arinml.monto_dol%type;
  vMonto2_Dol   arinml.monto2_dol%type;

  --

  Lv_pedido Arfafe.no_pedido%type;

BEGIN
  msg_error := NULL;
  vMonto_Dol := moneda.redondeo(monto_p/tc_p, 'D');
  vMonto2_Dol := moneda.redondeo(monto2_p/tc_p, 'D');

  -- linea del documento
  Begin
  INSERT INTO arinml(no_cia, centro, tipo_doc, periodo, ruta,
              no_docu, linea, linea_ext, bodega, clase,
              categoria, no_arti, ind_iv, unidades,
              monto, tipo_cambio, monto_dol,
              ind_oferta, time_stamp, monto2, monto2_dol)
       VALUES(
              no_cia_p, centrod_p, tipo_doc_p, periodo_p, ruta_p,
              no_factu_p, linea_p, linea_p, bodega_p, clase_p,
              categoria_p, no_arti_p, 'N', unidades_p,
              monto_p, tc_p, vMonto_Dol,
              ind_oferta_p, sysdate, monto2_p, vMonto2_Dol );
  Exception
  When Others Then
   msg_error := 'Error al crear detalle de inventarios: '||tipo_doc_p||' '||no_factu_p||' '||linea_p||' '||sqlerrm;
   RAISE error_proceso;
  End;
  --
  -- Determina las lineas de lotes para el inventario
  if ind_lote_p = 'L' then
     vcant_x_dist  := unidades_p;
     vmonto_x_dist := monto_p;
     for lo in c_lotes loop
        if vcant_x_dist <= 0 then
           EXIT;
        end if;
        vcant_lote   := least(lo.saldo_disponible, vcant_x_dist);
        if vcant_lote > 0 then
           vmonto_lote   := least(vmonto_x_dist,
                                  Moneda.Redondeo(vcant_lote * costo_p,'P'));
           vcant_x_dist  := vcant_x_dist - vcant_lote;
           vmonto_x_dist := vmonto_x_dist - vmonto_lote;

       Open C_Factura;
       Fetch C_Factura into Lv_pedido;
       If C_Factura%notfound Then
        Close C_Factura;
       else
        Close C_Factura;
       end if;

   --- Para factura directa tambien se debe generar lotes ANR 12/11/2009

      If consig_p = 'S' or Lv_pedido is null Then

   --- Debe crear el registro del lote en la factura de consignacion,
   --- para los otros tipos, ya se crea en el picking ANR 13/08/2009

       Begin
         insert into arfafl_lote (no_cia, centrod, no_factu, bodega, no_arti, no_linea,
                                  no_lote, unidades, fecha_vence, ubicacion)
                           values (no_cia_p, centrod_p, no_factu_p, bodega_p, no_arti_p, linea_fac_p,
                                   lo.no_lote, vcant_lote, lo.fecha_vence, lo.ubicacion);
        Exception
        When Others Then
         msg_error := 'Error al crear detalle de lote en factura: '||no_factu_p||' '||linea_fac_p||' '||lo.no_lote||' '||sqlerrm;
         RAISE error_proceso;
        End;
       -- end if;

        Begin

           insert into arinmo(no_cia, centro, tipo_doc, periodo, ruta,
                       no_docu, linea, no_lote, unidades, monto,
                       ubicacion, fecha_vence)
                values(
                       no_cia_p, centrod_p, tipo_doc_p, periodo_p, ruta_p,
                       no_factu_p, linea_p, lo.no_lote, vcant_lote, vmonto_lote,
                       lo.ubicacion, lo.fecha_vence);

        Exception
        When Others Then
         msg_error := 'Error al crear detalle de lote en inventarios: '||no_factu_p||' '||linea_p||' '||lo.no_lote||' '||sqlerrm;
         RAISE error_proceso;
        End;

     END IF;

        end if;
     end loop;
     if vcant_x_dist > 0 then
        msg_error := 'No existen lotes suficientes para satisfacer la cantidad aprobada '||
                     'del articulo: '||no_arti_p;
        raise error_proceso;
     end if;
  end if;
EXCEPTION
  WHEN error_proceso then
       msg_error := nvl(msg_error, 'ERROR EN ACTUALIZA_INV_ML');
       return;
  WHEN others then
       msg_error := 'ERROR EN ACTUALIZA_INV_ML'||sqlerrm(sqlcode);
       return;
END;