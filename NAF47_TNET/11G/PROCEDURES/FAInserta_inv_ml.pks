create or replace PROCEDURE            FAInserta_inv_ml (no_cia_p     in     varchar2,
                                              centrod_p    in     varchar2,
                                              tipo_doc_p   in     varchar2,
                                              periodo_p    in     varchar2,
                                              ruta_p       in     varchar2,
                                              no_factu_p   in     varchar2,
                                              linea_p      in     number,
                                              bodega_p     in     varchar2,
                                              clase_p      in     varchar2,
                                              categoria_p  in     varchar2,
                                              no_arti_p    in     varchar2,
                                              ind_lote_p   in     varchar2,
                                              ind_oferta_p in     varchar2,	-- S y N
                                              unidades_p   in     number,
                                              costo_p      in     number,       -- costo  unitario
                                              monto_p      in     number,       -- costo  total
                                              costo2_p     in     number,       -- costo2 unitario
                                              tc_p         in     number,
                                              fecha_p      in     date,
                                              msg_error    in out varchar2) IS
  -- --
  -- Crea las lineas del documento en inventario
  --
  -- ** NOTAS IMPORTANTES:
  --    1. El que llame a este procedimiento debe haber inicializado el PAQUETE MONEDA,
  --       pues se utiliza la funcion redondeo
  --
  vcant_x_dist	number;
  error_proceso	exception;
  --
  -- Lotes para devolucion al por mayor

  CURSOR c_lotes IS
    SELECT l.no_arti, l.no_linea, l.no_lote, l.unidades, l.fecha_vence, l.ubicacion
    FROM   arfalote_solicdevolucion l
    WHERE  l.no_cia = no_cia_p AND CENTRO = centrod_p
    and    l.no_factu = no_factu_p
    and    l.no_linea = linea_p;

/**** Para el proceso de punto de ventas se debe crear el registro del lote en forma automatica
      La devolucion se hace al primer lote que encuentre, ordenado por la fecha vencimiento
      ANR 14/02/2011
****/

 --- Devuelve a cualquier lote sin importar saldo de lote
  CURSOR c_lotes_pv IS
    SELECT no_lote, fecha_vence, ubicacion
      FROM arinlo
     WHERE no_cia                = no_cia_p
       AND bodega                = bodega_p
       AND no_arti               = no_arti_p
     ORDER BY fecha_vence;

  --- Verifica que el movimiento sea una devolucion de POS

  CURSOR c_devuelve_pos Is
   select 'X'
   from   arfafe a, arfact b
   where  a.no_cia = no_cia_p
   and    a.no_factu = no_factu_p
   and    a.origen = 'PV' --- origen POS
   and    b.ind_fac_dev = 'D' -- tipo devolucion
   and    a.no_cia = b.no_cia
   and    a.tipo_doc = b.tipo;

  --
  vMonto_Dol    arinml.monto_dol%type;
  vMonto2_Dol   arinml.monto_dol%type;

  Lot_pv        C_lotes_pv%rowtype;

  lv_dummy      varchar2(1);

BEGIN

  msg_error   := NULL;
  vMonto_Dol  := moneda.redondeo(monto_p/tc_p, 'D');
  vMonto2_Dol := moneda.redondeo((nvl(unidades_p,0)*nvl(costo2_p,0))/tc_p, 'D');

  -- linea del documento
  INSERT INTO arinml (no_cia, centro, tipo_doc, periodo, ruta,
                      no_docu, linea, linea_ext, bodega, clase,
                      categoria, no_arti, ind_iv, unidades,
                      monto, tipo_cambio, monto_dol,
                      ind_oferta, time_stamp,
                      monto2, monto2_dol)

       VALUES(no_cia_p, centrod_p, tipo_doc_p, periodo_p, ruta_p,
              no_factu_p, linea_p, linea_p, bodega_p, clase_p,
              categoria_p, no_arti_p, 'N', unidades_p,
              monto_p, tc_p, vMonto_Dol,
              ind_oferta_p, sysdate,
              nvl(unidades_p,0)*nvl(costo2_p,0), vMonto2_Dol);
  --
  -- Determina las lineas de lotes para el inventario
  if ind_lote_p = 'L' then

     vcant_x_dist  := unidades_p;

     --- Creacion de lotes para devolucion al por mayor

     for lo in c_lotes loop
        if vcant_x_dist <= 0 then
           EXIT;
        end if;

        if lo.unidades > 0 then
           insert into arinmo (no_cia, centro, tipo_doc, periodo, ruta,
                               no_docu, linea, no_lote, unidades, monto,
                               ubicacion, fecha_vence)

                values(no_cia_p,     centrod_p,     tipo_doc_p,  periodo_p,  ruta_p,
                       no_factu_p,   linea_p,       lo.no_lote,  lo.unidades, 0,
                       lo.ubicacion, lo.fecha_vence);
        end if;
     end loop;

     --- Creacion de lotes para devolucion desde el punto de ventas
     -- Determina las lineas de lotes para el inventario

     Open c_devuelve_pos;
     Fetch c_devuelve_pos into Lv_dummy;
     If c_devuelve_pos%notfound Then
        Close c_devuelve_pos;
     else
        Close c_devuelve_pos;

           Open c_lotes_pv;
           Fetch c_lotes_pv into Lot_pv;
           If c_lotes_pv%notfound Then
              Close c_lotes_pv;
               msg_error := 'No existe registro de lote para bodega: '||bodega_p||' Articulo: '||no_arti_p||' '||sqlerrm;
               RAISE error_proceso;
           else
              Close c_lotes_pv;
           end if;

             Begin
               insert into arfafl_lote (no_cia, centrod, no_factu, bodega, no_arti, no_linea,
                                        no_lote, unidades, fecha_vence, ubicacion)
                                 values (no_cia_p, centrod_p, no_factu_p, bodega_p, no_arti_p, linea_p,
                                         lot_pv.no_lote, unidades_p, lot_pv.fecha_vence, lot_pv.ubicacion);
              Exception
              When Others Then
               msg_error := 'Error al crear detalle de lote en devoluciones: '||no_factu_p||' '||linea_p||' '||lot_pv.no_lote||' '||sqlerrm;
               RAISE error_proceso;
              End;

              Begin

                 insert into arinmo(no_cia, centro, tipo_doc, periodo, ruta,
                             no_docu, linea, no_lote, unidades, monto,
                             ubicacion, fecha_vence)
                      values(
                             no_cia_p, centrod_p, tipo_doc_p, periodo_p, ruta_p,
                             no_factu_p, linea_p, lot_pv.no_lote, unidades_p, 0,
                             lot_pv.ubicacion, lot_pv.fecha_vence);

              Exception
              When Others Then
               msg_error := 'Error al crear detalle de lote en inventarios: '||no_factu_p||' '||linea_p||' '||lot_pv.no_lote||' '||sqlerrm;
               RAISE error_proceso;
              End;


       end if;

  end if;

EXCEPTION
  WHEN error_proceso then
       msg_error := nvl(msg_error, 'ERROR EN INSERT_INV_ML');
       return;
  WHEN others then
       msg_error := 'ERROR EN INSERTA_INV_ML'||sqlerrm(sqlcode);
       return;
END;