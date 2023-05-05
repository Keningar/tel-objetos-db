create or replace PROCEDURE            FaAnula_nota_credito(no_cia_p       IN     varchar2,
                                                 no_factu_p     IN     varchar2,
                                                 motivo_anula_p IN     varchar2,
                                                 fecha_anula_p  IN     date,
                                                 razon_p        IN     varchar2,
                                                 msg_error      IN OUT varchar2) IS
  --
  --- Encabezado de la devolucion
  CURSOR C_Devolucion IS
   select *
   from   arfafe
   where  no_cia   = no_cia_p
   and    no_factu = no_factu_p;

  CURSOR C_dev_cxc IS
   select *
   from   arccmd
   where  no_cia   = no_cia_p
   and    no_docu = no_factu_p;

  --- Detalle de devolucion
  CURSOR C_Detalle_Devolucion IS
   select *
   from   arfafl
   where  no_cia   = no_cia_p
   and    no_factu = no_factu_p;

  --- Busco la cabecera de devoluciones de inventarios
  CURSOR C_Arinme_devolucion IS
   select *
   from   arinme
   where  no_cia   = no_cia_p
   and    no_docu  = no_factu_p;

  --- Busco el detalle de devoluciones de inventarios
  CURSOR C_Arinml_dev IS
   select *
   from   arinml
   where  no_cia   = no_cia_p
   and    no_docu  = no_factu_p;

  --- Busco el detalle de lotes de devolucion de inventarios
  CURSOR C_Arinmo_Dev IS
   select *
   from   arinmo
   where  no_cia = no_cia_p
   and    no_docu = no_factu_p;

  CURSOR c_periodo (pCentro ArInCD.centro%type) IS
    SELECT mes_proce_fact, semana_proce_fact, indicador_sem_fact
      FROM arincd
     WHERE no_cia = no_cia_p
       AND centro = pCentro;
  --
  Cursor C_tdoc_inv Is
   select tipo_m
   from   arinvtm
   where  no_cia = no_cia_p
   and    movimi = 'S'
   and    interface = 'FA'
   and    ventas = 'S'
   and    anula_nc = 'S';

  Dev             C_Devolucion%rowtype;
  Arinme_Dev      C_Arinme_Devolucion%rowtype;
  Devcxc          C_dev_cxc%rowtype;

 --
  error_proceso   exception;
  vmes_fact       arincd.mes_proce_fact%type;           -- mes en proceso
  vsem_fact       arincd.semana_proce_fact%type;        -- semana en proceso
  vind_sem_fact   arincd.indicador_sem_fact%type;       -- indicador de semana
  td_inve         arinvtm.tipo_m%TYPE;                   -- docto a generar en inve

  Lv_docu         Arinme.no_docu%type;
  Lv_periodo      Arinme.periodo%type;

BEGIN

 Open C_Devolucion;
 Fetch C_Devolucion into Dev;
 If C_Devolucion%notfound Then
    Close C_Devolucion;
    msg_error := 'Documento de devolucion no existe en el modulo de facturacion: '||no_factu_p;
    RAISE error_proceso;
 else
    Close C_Devolucion;
 end if;

 If Dev.estado = 'P' Then
    msg_error := 'Documento de devolucion esta pendiente de actualizar en el modulo de facturacion: '||no_factu_p||' no se lo puede anular';
    RAISE error_proceso;
 end if;

 If Dev.fecha_anula is not null Then
    msg_error := 'Documento de devolucion ya esta anulado en el modulo de facturacion: '||no_factu_p||' no se lo puede anular';
    RAISE error_proceso;
 end if;

  -- obtiene el periodo en proceso
  OPEN  c_periodo(Dev.centrod);
  FETCH c_periodo INTO vmes_fact, vsem_fact, vind_sem_fact;
  IF c_periodo%notfound THEN
    CLOSE c_periodo;
    msg_error := 'El periodo en proceso no se encuentra definido para el centro';
    RAISE error_proceso;
  END IF;
  CLOSE c_periodo;

/*** Para la factura que hace referencia a la devolucion
     1. Resto las unidades marcadas como devueltas en la factura ***/

 For Det_Dev in C_Detalle_Devolucion Loop

  /* En facturacion este campo no se usa, ya que las devoluciones busca por su transaccion de devolucion
     Update arfafl
     set    un_devol =  un_devol - abs(Det_dev.pedido) --- se pone valor absoluto porque se guarda como negativo la devolucion
     Where  no_cia   = no_cia_p
     And    no_factu = Dev.n_factu_d
     And    no_arti  = Det_dev.no_arti; --- Con el dato que esta en la devolucion n_factu_d busco la factura
   */

/**** Procedo a anular la estadistica de venta por concepto de anulacion de devoluciones
      para esto vuelvo a cargar la venta ***/

    FAestadistica_venta(Dev.no_cia, Dev.centrod, Det_dev.clase, Det_dev.categoria,
                        Det_dev.no_arti, Dev.grupo, Dev.no_cliente, Dev.no_vendedor,
                        Dev.ruta, vsem_fact, vind_sem_fact, Dev.periodo, vmes_fact,
                        'VEN', abs(Det_dev.costo), abs(Det_dev.costo2), abs(Det_dev.pedido), (abs(Det_dev.total) - nvl(abs(Det_dev.imp_incluido),0)),
                        abs(Det_dev.descuento), abs(Det_dev.i_ven_n), abs(Det_dev.imp_incluido),
                        Dev.moneda, Dev.tipo_cambio,
                        Dev.cod_doctor, --- POS
                        msg_error  );
        IF msg_error is not null THEN
          RAISE error_proceso;
        END IF;

 End Loop;

/*** Para la devolucion
     1. Quito las referencias con la factura
     2. Registro los datos de anulacion ****/

Update arfafe
set    tipo_doc_d    = null,
       periodo_d     = null,
       ruta_d        = null,
       n_factu_d     = null,
       fecha_anula   = to_date(to_char(fecha_anula_p,'dd/mm/yyyy')||' '||to_char(sysdate,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),
       usuario_anula = user,
       motivo_anula  = motivo_anula_p
Where  no_cia        = no_cia_p
And    no_factu      = no_factu_p;


  --
  -- Crea documento para despachar en inventario
  -- se crea con el numero de trnsaccion de facturacion

 Open C_Arinme_Devolucion;
 Fetch C_Arinme_Devolucion into Arinme_Dev;
 If C_Arinme_Devolucion%notfound Then
    Close C_Arinme_Devolucion;
    msg_error := 'No se encuentra registro de devolucion en inventarios: '||no_factu_p;
    RAISE error_proceso;
 else
    Close C_Arinme_Devolucion;
 end if;

 If Arinme_Dev.estado = 'P' Then
    msg_error := 'Documento de devolucion esta pendiente de actualizar en el modulo de inventarios: '||no_factu_p||' no se lo puede anular';
    RAISE error_proceso;
 end if;

 Lv_docu := TRANSA_ID.inv(no_cia_p);

 If Lv_docu is null Then
    msg_error := 'Error al crear transaid de inventarios, no se puede anular la devolucion';
    RAISE error_proceso;
 end if;

 Open C_tdoc_inv;
 Fetch C_tdoc_inv into td_inve;
 If C_tdoc_inv%notfound Then
 Close C_tdoc_inv;
    msg_error := 'No existe configurado el tipo de documento de inventarios (Interfaz: Facturacion (salida), anula N/C)';
    RAISE error_proceso;
 else
 Close C_tdoc_inv;
 end if;

 Lv_periodo := to_char(fecha_anula_p,'YYYY');

 Begin
  INSERT INTO arinme(no_cia, centro, tipo_doc, periodo, ruta, no_docu, estado, fecha,
                     no_fisico, serie_fisico, imp_ventas, imp_incluido, imp_especial,
                     tipo_refe, no_refe, serie_refe, descuento, mov_tot, tot_art_iv,
                     moneda_refe_cxp, tipo_cambio, monto_digitado_compra,
                     monto_bienes, monto_importac, monto_serv, origen, ind_completa,
                     nota_credito, valor_ncredito, impuesto, descuento_c, aplica_guia_rem,
                     reclamo_proveedor, mov_tot2, observ1)
             VALUES (Arinme_dev.no_cia, Arinme_dev.centro, td_inve, Lv_periodo, Arinme_dev.ruta, Lv_docu, 'P', fecha_anula_p,
                     Arinme_dev.no_fisico, Arinme_dev.serie_fisico, Arinme_dev.imp_ventas, Arinme_dev.imp_incluido, Arinme_dev.imp_especial,
                     Arinme_dev.tipo_refe, Arinme_dev.no_refe, Arinme_dev.serie_refe, Arinme_dev.descuento, Arinme_dev.mov_tot, Arinme_dev.tot_art_iv,
                     Arinme_dev.moneda_refe_cxp, Arinme_dev.tipo_cambio, Arinme_dev.monto_digitado_compra,
                     Arinme_dev.monto_bienes, Arinme_dev.monto_importac, Arinme_dev.monto_serv, Arinme_dev.origen, Arinme_dev.ind_completa,
                     Arinme_dev.nota_credito, Arinme_dev.valor_ncredito, Arinme_dev.impuesto, Arinme_dev.descuento_c, Arinme_dev.aplica_guia_rem,
                     Arinme_dev.reclamo_proveedor, Arinme_dev.mov_tot2,substr('ANULACION DE NOTA DE CREDITO: '||no_factu_p||' Fisico: '||Arinme_dev.no_fisico||' Serie: '||Arinme_dev.serie_fisico||' '||motivo_anula_p,1,400));
   Exception
    When Others Then
     msg_error := 'Error al crear cabecera de inventarios: '||td_inve||' '||no_factu_p||' '||sqlerrm;
     RAISE error_proceso;
    End;

 For i in C_Arinml_dev Loop

 Begin
  INSERT INTO arinml(no_cia, centro, tipo_doc, periodo, ruta, no_docu, linea, linea_ext, bodega, clase, categoria,
                     no_arti, ind_iv, unidades, monto, descuento_l, tipo_cambio, monto_dol, ind_oferta,
                     impuesto_l_incluido, danados, precio_venta, confirma_reclamoprov, time_stamp, monto2, monto2_dol)
             Values (i.no_cia, i.centro, td_inve, lv_periodo, i.ruta, Lv_docu, i.linea, i.linea_ext, i.bodega, i.clase, i.categoria,
                     i.no_arti, i.ind_iv, i.unidades, i.monto, i.descuento_l, i.tipo_cambio, i.monto_dol, i.ind_oferta,
                     i.impuesto_l_incluido, i.danados, i.precio_venta, i.confirma_reclamoprov, sysdate, i.monto2, i.monto2_dol);
   Exception
    When Others Then
     msg_error := 'Error al crear detalle de inventarios: '||td_inve||' '||no_factu_p||' '||sqlerrm;
     RAISE error_proceso;
    End;

 End Loop;

For lot in C_Arinmo_Dev Loop

 Begin
  INSERT INTO arinmo(no_cia, centro, tipo_doc, periodo, ruta,
                     no_docu, linea, no_lote, unidades, monto,
                     descuento_l, imp_ventas_l, ubicacion, fecha_vence)
             Values (lot.no_cia, lot.centro, td_inve, lv_periodo, lot.ruta,
                     Lv_docu, lot.linea, lot.no_lote, lot.unidades, lot.monto,
                     lot.descuento_l, lot.imp_ventas_l, lot.ubicacion, lot.fecha_vence);
   Exception
    When Others Then
     msg_error := 'Error al crear detalle de lote inventarios: '||td_inve||' '||no_factu_p||' '||sqlerrm;
     RAISE error_proceso;
    End;

end Loop;


  /*** Ingresa a procesar la transaccion de inventarios ***/

      InActualiza( Arinme_dev.no_cia, td_inve, Lv_docu, msg_error);
      IF msg_error is not null THEN
        RAISE error_proceso;
      END IF;
  --

  /*** Si el documento es de credito procede a anular en cuentas por cobrar ***/

      Open C_dev_cxc;
      Fetch C_dev_cxc into Devcxc;
      If C_dev_cxc%notfound then
       Close C_dev_cxc;
      else
       Close C_dev_cxc;

          CCAnula  (Devcxc.no_cia, Devcxc.centro,
                    Devcxc.tipo_doc, Devcxc.no_docu,
                    razon_p, msg_error, Devcxc.origen);

          IF msg_error is not null THEN
            RAISE error_proceso;
          END IF;

      end if;

  --
EXCEPTION
  WHEN error_proceso THEN
     msg_error := 'FaAnula_nota_credito : '||msg_error;
     return;
  WHEN OTHERS THEN
     msg_error := 'FaAnula_nota_credito : '||sqlerrm;
     return;
END;