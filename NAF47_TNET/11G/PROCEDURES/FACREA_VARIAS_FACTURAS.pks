create or replace procedure            FACREA_VARIAS_FACTURAS (
  no_cia_p        IN varchar2,
  no_pedido_p     IN varchar2,
  ruta_p          IN varchar2,
  per_fact_p      IN varchar2,
  tipo_doc_p      IN varchar2,
  maximo_linea_p  IN number,
  tipo_cambio_p   IN number,
  msg_generado    OUT varchar2,
  mensaje_p       IN OUT varchar2
) IS
  --

/*** Este proceso crea varias facturas en base a un pedido
     Se ordena las facturas primero por las que tienen bonificaciones y despues las que no tienen bonificaciones
     ANR 03/08/2009 ***/

  CURSOR c_pedidos IS
    SELECT *
      FROM arfafec
     WHERE no_cia           = no_cia_p
       AND no_factu         = no_pedido_p
       AND rownum = 1;

  CURSOR c_linea_pedidos IS
    SELECT 'X'
      FROM arfaflc
     WHERE no_cia           = no_cia_p
       AND no_factu         = no_pedido_p
       AND nvl(cant_aprobada,0) > 0
       AND rownum = 1;

 --- Primero debo procesar las lineas de pedido que tienen promocion de escala,
 --- es decir la linea de pedido que genero la promocion escala y la promocion escala
 --- Se ordenan por orden del pedido
 --- Cualquier cambio en este query debe afectar el query de c_lineas_sin_escala
 --- ANR 03/08/2009

  CURSOR c_lineas_con_escala IS
SELECT no_cia,      centrod,     no_linea,    bodega,
           clase,       categoria,   no_arti, cant_aprobada,
           porc_desc_aprobado,
           precio_aprobado,
           tipo_precio, un_devol,
           arti_ofe,    cant_ofe,    prot_ofe,  tipo_oferta,
           costo2,
           linea_art_promocion, margen_minimo,
           margen_objetivo, secuencia_politica,
           linea_politica, division, subdivision, cantidad_adicional, descuento_adicional, pedido,
           nvl(cant_aprobada,0) * nvl(precio_aprobado,0) total_aprobado,
           round((nvl(cant_aprobada,0) * nvl(precio_aprobado,0)) * (nvl(porc_desc_aprobado,0)/100),2) descuento_aprobado,
           (nvl(cant_aprobada,0) * nvl(precio_aprobado,0)) * (nvl(porc_desc_aprobado,0)/100) descuento_aprobado_sr
      FROM arfaflc
     WHERE no_cia   = no_cia_p
       AND no_factu = no_pedido_p
       AND nvl(cant_aprobada,0) > 0
       AND (no_cia, no_factu, no_linea) IN
       (Select b.no_cia, b.no_pedido, b.no_linea
       From   Arfapromo_flc b
       Where  b.no_cia = no_cia_p
       And    b.no_pedido = no_pedido_p
       And    b.tipo_promocion = 'E') ---- considerar promociones que deben ir primero tipo escala ANR 05/03/2010
       Order by 3;

 --- Despues proceso todas las lineas del pedido que son diferentes a la promocion escala
 --- Se ordenan por orden del pedido
 --- Cualquier cambio en este query debe afectar el query de c_lineas_sin_escala
 --- ANR 03/08/2009

  CURSOR c_lineas_sin_escala IS
  SELECT no_cia,      centrod,     no_linea,    bodega,
           clase,       categoria,   no_arti, cant_aprobada,
           porc_desc_aprobado,
           precio_aprobado,
           tipo_precio, un_devol,
           arti_ofe,    cant_ofe,    prot_ofe,  tipo_oferta,
           costo2,
           linea_art_promocion, margen_minimo,
           margen_objetivo, secuencia_politica,
           linea_politica, division, subdivision, cantidad_adicional, descuento_adicional, pedido,
           nvl(cant_aprobada,0) * nvl(precio_aprobado,0) total_aprobado,
           round((nvl(cant_aprobada,0) * nvl(precio_aprobado,0)) * (nvl(porc_desc_aprobado,0)/100),2) descuento_aprobado,
           (nvl(cant_aprobada,0) * nvl(precio_aprobado,0)) * (nvl(porc_desc_aprobado,0)/100) descuento_aprobado_sr
      FROM arfaflc
     WHERE no_cia   = no_cia_p
       AND no_factu = no_pedido_p
       AND nvl(cant_aprobada,0) > 0
       AND (no_cia, no_factu, no_linea) NOT IN
       (Select b.no_cia, b.no_pedido, b.no_linea
       From   Arfapromo_flc b
       Where  b.no_cia = no_cia_p
       And    b.no_pedido = no_pedido_p
       And    b.tipo_promocion = 'E') ---- Va todo lo que no sea tipo escala ANR 05/03/2010
       Order by 3;

CURSOR C_Lineas_Pomociones (Ln_linea Number) Is
    select no_cia, no_pedido, no_linea, secuencia_politica,
           linea_politica, tipo_promocion, porc_descuento,
           precio, cant_minima, cant_maxima, unidades,
           arti_alterno
    from   arfapromo_flc
    where  no_cia    = no_cia_p
    and    no_pedido = no_pedido_p
    and    no_linea  = Ln_linea;

Cursor C_Lineas_lotes (Ln_linea Number) Is
  select no_cia, centrod, no_factu, bodega, no_arti,
         no_linea, no_lote ,unidades, fecha_vence, ubicacion
  from   ARFAFLC_LOTE
  where  no_cia   = no_cia_p
  and    no_factu = no_pedido_p
  and    nvl(unidades,0) > 0
  and    no_linea = Ln_linea;

Cursor C_Arfafli (Ln_linea Number) Is
    SELECT a.no_linea, b.grupo, b.no_cliente,
           (nvl(a.cant_aprobada,0) * nvl(a.precio_aprobado,0)) -
           round((nvl(a.cant_aprobada,0) * nvl(a.precio_aprobado,0)) * (nvl(a.porc_desc_aprobado,0)/100),2) base_aprobada, a.no_arti
      FROM arfaflc a, arfafec b
     WHERE a.no_cia   = no_cia_p
       AND a.no_factu = no_pedido_p
       AND a.cant_aprobada > 0
       AND a.i_ven = 'S'
       AND a.no_linea = Ln_linea
       AND a.no_cia = b.no_cia
       AND a.no_factu = b.no_factu;
  --
  -- Obtengo los impuestos asociados al articulo
  CURSOR c_Impuestos (pno_cia   arinia.no_cia%type,
                      pArticulo Arinia.No_Arti%type ) IS
    SELECT b.columna, a.clave, b.porcentaje
      FROM arinia a, arcgimp b
     WHERE a.no_cia       = pno_cia
       AND a.No_Arti      = pArticulo
       AND a.Afecta_Venta = 'S'
       AND a.no_cia       = b.no_cia
       AND a.clave        = b.clave;

  Cursor C_Detalle (Lv_factu Varchar2) Is --- Verifica que se haya generado por lo menos una linea de factura ANR 12/08/2009
   Select 'X'
   From   Arfafl
   Where  no_cia = no_cia_p
   And    no_factu = Lv_factu;

   Cursor C_Actualiza_Arfafe Is
   Select no_factu, sum(total) total, sum(descuento) descuento, sum(i_ven_n) impuesto
   From   Arfafl
   Where  no_cia = no_cia_p
   And    no_factu IN
     (Select no_factu
       From  Arfafe
      Where  no_cia = no_cia_p
      And    no_pedido = no_pedido_p)
   group by no_factu;

  Cursor C_Cant_Bonif_Pedido (Lv_Pedido Varchar2, Ln_linea Number) Is
     select nvl(cant_aprobada,0) cantidad_bonificacion
     from   arfaflc
     where  no_cia   = no_cia_p
     and    no_factu = Lv_pedido
     and    linea_art_promocion = Ln_linea;

   Cursor C_Dia_proceso (Lv_centro Varchar2) Is
    Select dia_proceso_fact
    From   Arincd
    Where  no_cia = no_cia_p
    And    centro = Lv_centro;

  --- Recupera si el articulo tiene marcado impuesto para ventas
   Cursor C_Arti (Lv_articulo Varchar2) Is
    select nvl(imp_ven,'N') imp_ven
    from   arinda
    where  no_cia = no_cia_p
    and    no_arti = Lv_articulo;

  --- Recupera si el cliente esta excento de impuestos
   Cursor C_Cliente (Lv_grupo Varchar2, Lv_cliente Varchar2) Is
    select nvl(excento_imp,'N') excento_imp
    from   arccmc
    where  no_cia = no_cia_p
    and    grupo  = Lv_grupo
    and    no_cliente = Lv_cliente;

  --- Verifica si es linea con promocion de bonificacion ANR 23/04/2010
  Cursor C_Tiene_Bonificacion (Ln_linea Number) Is
   select 'S'
   from   arfaflc
   where  no_cia = no_cia_p
   and    no_factu = no_pedido_p
   and    linea_art_promocion = Ln_linea;

  vCosto                arinma.costo_uni%type;
  Ln_columna            Arcgimp.columna%type;
  Lv_clave              Arcgimp.clave%type;
  Ln_porcentaje         Arcgimp.porcentaje%type;
  no_factu_p            Arfafe.no_factu%type;
  Ln_total_pedido       Number :=0;
  Lv_dummy              Varchar2(1);
  Ln_contador           Number := 0;

  Ln_margen_valor       Arfafl.Margen_Valor_Fl%type;
  Ln_margen_porc        Arfafl.Margen_Porc_Fl%type;
  Ln_cant_bonif         Arfafl.pedido%type;
  Ln_neto               Number; --- campo solo se debe usar para el calculo del margen ya que esta con todos los decimales ANR 09/12/2009

  Ld_dia_proceso        Arincd.dia_proceso_fact%type;

  Lv_imp_arti           Arinda.imp_ven%type;
  Lv_excento_cli        Arccmc.Excento_Imp%type;

  Lv_tiene_bonificacion Varchar2(1):= 'N';

  Ped                   C_Pedidos%rowtype;

  error_proceso         exception;

  --
BEGIN

     mensaje_p   := NULL;

  --- creo la primera cabecera de factura

      no_factu_p  := NULL;

      Ln_contador := 0;
      --
      --
      Open c_pedidos;
      Fetch c_pedidos into Ped;
       If c_pedidos%notfound Then
        Close c_pedidos;
           mensaje_p := 'No hay un pedido para generar facturas';
           RAISE error_proceso;
       else
        Close c_pedidos;
       end if;

      Open C_Dia_proceso (Ped.centrod);
      Fetch C_Dia_proceso into Ld_dia_proceso;
      If C_Dia_proceso%notfound Then
       Close C_Dia_proceso;
           mensaje_p := 'No existe centro de distribucion: '||Ped.centrod;
           RAISE error_proceso;
      else
       Close C_Dia_proceso;
      end if;

      If Ld_dia_proceso is null Then
         mensaje_p := 'No existe dia de proceso de facturacion para el centro de distribucion: '||Ped.centrod;
         RAISE error_proceso;
      end if;

      Open c_linea_pedidos;
      Fetch c_linea_pedidos into lv_dummy;
       If c_linea_pedidos%notfound Then
        Close c_linea_pedidos;
           mensaje_p := 'No existe ninguna linea aprobada del pedido';
           RAISE error_proceso;
       else
        Close c_linea_pedidos;
       end if;

      -- obtiene un numero de transaccion
      no_factu_p    := transa_id.fa(no_cia_p);

      msg_generado := msg_generado||' '||no_factu_p;

      INSERT INTO arfafe(no_cia,     centrod,      tipo_doc,     periodo,
                         ruta,       no_factu,     afecta_saldo, grupo,
                         no_cliente, tipo_cliente, nbr_cliente,  direccion,
                         fecha,      no_vendedor,  n_factu_d,    plazo,
                         observ1,    observ2,      observ3,      tot_lin,
                         sub_total,  descuento,    impuesto,     total,
                         estado,     ind_anu_dev,  imp_sino,     tipo_factura,
                         peri_ped,   no_pedido,    tipo_cambio,  moneda,
                         no_fisico, serie_fisico,  ind_exportacion, numero_ctrl, codigo_plazo, subcliente, division_comercial, tipo_despacho,
                         no_docu_refe_picking, monto_bienes, codigo_transportista, ind_flete, usuario, tstamp,ind_aplica_escala,
                         bodega, entregar, via_pedido)
                Values (Ped.no_cia, Ped.centrod,       tipo_doc_p,      per_fact_p,
                        ruta_p, no_factu_p, Ped.afecta_saldo, Ped.grupo,
                        Ped.no_cliente, Ped.tipo_cliente,  Ped.nbr_cliente, Ped.direccion,
                        Ld_dia_proceso, Ped.no_vendedor, Ped.n_factu_d, Ped.plazo,
                        Ped.observ1, Ped.observ2, Ped.observ3,
                        0, 0 , 0 , 0, 0,
                        'P', Ped.ind_anu_dev, Ped.imp_sino, 'P',
                        Ped.periodo, Ped.no_factu, tipo_cambio_p, Ped.moneda,
                        NULL, NULL, Ped.ind_exportacion, NULL, Ped.codigo_plazo, Ped.subcliente, Ped.division_comercial, Ped.tipo_despacho,
                        Ped.no_docu_refe_picking, 0, Ped.codigo_transportista, Ped.ind_flete, user, sysdate, Ped.ind_aplica_escala,
                        Ped.bodega, Ped.entregar, Ped.via_pedido);

---- Debo generar varias facturas por el pedido ANR 03/08/2009

  -- genera las lineas de la factura, pero solo por las cantidades aprobadas para lineas de pedido con escala

  FOR l IN c_lineas_con_escala LOOP

    /**** Si la ultima linea tiene un articulo de bonificacion, debe pasar
          esa ultima linea a otra factura ANR 23/04/2010 ****/

     Open C_Tiene_Bonificacion (l.no_linea);
     Fetch C_Tiene_Bonificacion into Lv_tiene_bonificacion;
     If C_Tiene_Bonificacion%notfound Then
      Close C_Tiene_Bonificacion;
      Lv_tiene_bonificacion := 'N';
     else
      Close C_Tiene_Bonificacion;
     end if;

     --- Crea una nueva factura

     If maximo_linea_p = Ln_contador
     or (((maximo_linea_p - 1) = Ln_contador) and  Lv_tiene_bonificacion = 'S') Then

     --- Fin de modificacion de ultima linea tiene articulo de bonificacion ANR 23/04/2010

      no_factu_p  := NULL;

      Ln_contador := 0;
      --
      -- obtiene un numero de transaccion
      no_factu_p    := transa_id.fa(no_cia_p);
      msg_generado := msg_generado||' '||no_factu_p;
      --
      Open c_pedidos;
      Fetch c_pedidos into Ped;
       If c_pedidos%notfound Then
        Close c_pedidos;
           mensaje_p := 'No hay un pedido para generar facturas';
           RAISE error_proceso;
       else
        Close c_pedidos;
       end if;

      INSERT INTO arfafe(no_cia,     centrod,      tipo_doc,     periodo,
                         ruta,       no_factu,     afecta_saldo, grupo,
                         no_cliente, tipo_cliente, nbr_cliente,  direccion,
                         fecha,      no_vendedor,  n_factu_d,    plazo,
                         observ1,    observ2,      observ3,      tot_lin,
                         sub_total,  descuento,    impuesto,     total,
                         estado,     ind_anu_dev,  imp_sino,     tipo_factura,
                         peri_ped,   no_pedido,    tipo_cambio,  moneda,
                         no_fisico, serie_fisico,  ind_exportacion, numero_ctrl, codigo_plazo, subcliente, division_comercial, tipo_despacho,
                         no_docu_refe_picking, monto_bienes, codigo_transportista, ind_flete, usuario, tstamp, ind_aplica_escala,
                         bodega, entregar, via_pedido)
                Values (Ped.no_cia, Ped.centrod,       tipo_doc_p,      per_fact_p,
                        ruta_p, no_factu_p, Ped.afecta_saldo, Ped.grupo,
                        Ped.no_cliente, Ped.tipo_cliente,  Ped.nbr_cliente, Ped.direccion,
                        Ld_dia_proceso, Ped.no_vendedor, Ped.n_factu_d, Ped.plazo,
                        Ped.observ1, Ped.observ2, Ped.observ3,
                        0, 0 , 0 , 0, 0,
                        'P', Ped.ind_anu_dev, Ped.imp_sino, 'P',
                        Ped.periodo, Ped.no_factu, tipo_cambio_p, Ped.moneda,
                        NULL, NULL, Ped.ind_exportacion, NULL, Ped.codigo_plazo, Ped.subcliente, Ped.division_comercial, Ped.tipo_despacho,
                        Ped.no_docu_refe_picking, 0, Ped.codigo_transportista, Ped.ind_flete, user, sysdate, Ped.ind_aplica_escala,
                        Ped.bodega, Ped.entregar, Ped.Via_Pedido);

   end if;


  ---- Siempre la cantidad aprobada debe ser igual a lo pedido mas la cantidad adicional,
  ---- caso contrario no puedo generar la factura y deberia quedar en estado N el pedido ANR 25/07/2009

  Ln_total_pedido := nvl(l.pedido,0) + nvl(l.cantidad_adicional,0);

  If nvl(l.cant_aprobada,0) > nvl(l.pedido,0) + nvl(l.cantidad_adicional,0) Then
       mensaje_p := 'VF. Para el articulo: '||l.no_arti||' la cantidad aprobada: '||nvl(l.cant_aprobada,0)||' no puede ser mayor a la cantidad pedida: '||Ln_total_pedido;
       RAISE error_proceso;
  end if;  --- valida que la cantidad aprobada no pueda ser mayor a la cantidad pedida ANR 07/09/2009

    vCosto := articulo.costo(no_cia_p, l.no_arti, l.bodega);

    IF nvl(vCosto,0) = 0 AND l.bodega != '0000' THEN
       mensaje_p := 'CE. El articulo/servicio: '||l.no_arti||' no tiene costo definido en la bodega: '||l.bodega;
       RAISE error_proceso;
     END IF;

     ---- Margen en base a la cantidad aprobada ANR 07/09/2009

     Open C_Cant_Bonif_Pedido (no_pedido_p, l.no_linea);
     Fetch C_Cant_Bonif_Pedido into Ln_cant_bonif;
      If C_Cant_Bonif_Pedido%notfound then
        Ln_cant_bonif := 0;
        Close C_Cant_Bonif_Pedido;
      else
        Close C_Cant_Bonif_Pedido;
      end if;

     Ln_neto := nvl(l.total_aprobado,0) - nvl(l.descuento_aprobado_sr,0);

     If l.linea_art_promocion is null Then
      Ln_margen_valor := Ln_neto -(nvl(l.costo2,0) * (nvl(l.cant_aprobada,0) + nvl(Ln_cant_bonif,0)));
     else
      Ln_margen_valor := 0;
     end if;

     If Ln_neto = 0 Then
      Ln_margen_porc := Ln_margen_valor * 100;
     else
      Ln_margen_porc := (Ln_margen_valor / Ln_neto) * 100;
     end if;

     --
     -- linea de la factura

     Begin
     INSERT INTO arfafl(no_cia,     centrod,   tipo_doc,    periodo,
                        ruta,       no_factu,  no_linea,    bodega,
                        clase,      categoria, no_arti,     pedido,
                        porc_desc,
                        costo,
                        precio,      descuento,
                        total,      i_ven,     tipo_precio, un_devol,
                        i_ven_n, imp_especial, imp_incluido,
                        arti_ofe,   cant_ofe,  costo_ofe,   prot_ofe,
                        precio_ofe, tipo_oferta, costo2,linea_art_promocion,
                        margen_valor_fl, margen_minimo,
                        margen_objetivo, margen_porc_fl, secuencia_politica,
                        linea_politica, division, subdivision)
                 VALUES(l.no_cia,       l.centrod,      tipo_doc_p,     per_fact_p,
                        ruta_p,         no_factu_p,     l.no_linea,     l.bodega,
                        l.clase,        l.categoria,    l.no_arti,      l.cant_aprobada,
                        l.porc_desc_aprobado,
                        vcosto,
                        l.precio_aprobado,       l.descuento_aprobado,
                        l.total_aprobado,
                        'N',        l.tipo_precio,  l.un_devol,
                        0, 0, 0,
                        null,     null,     null,     l.prot_ofe,
                        null,    null, l.costo2,
                        l.linea_art_promocion, Ln_margen_valor, l.margen_minimo,
                        l.margen_objetivo, Ln_margen_porc, l.secuencia_politica,
                        l.linea_politica, l.division, l.subdivision);

      Exception
        When others Then
           mensaje_p := 'CE. Error al crear linea de factura: '||no_factu_p||' linea: '||l.no_linea||' bodega: '||l.bodega||' articulo: '||l.no_arti||' '||sqlerrm;
           RAISE error_proceso;
      end;

    ---- Procedo a cargar las promociones registradas en el pedido ANR 23/07/2009

   For i in C_Lineas_Pomociones (l.no_linea) Loop

   Begin
   Insert into Arfapromo_fl (no_cia, no_factu, no_linea, secuencia_politica,
                             linea_politica, tipo_promocion, porc_descuento,
                             precio, cant_minima, cant_maxima, unidades,
                             arti_alterno)
                     Values (i.no_cia, no_factu_p, i.no_linea, i.secuencia_politica,
                             i.linea_politica, i.tipo_promocion, i.porc_descuento,
                             i.precio, i.cant_minima, i.cant_maxima, i.unidades,
                             i.arti_alterno);
    Exception
      When others Then
         mensaje_p := 'CE. Error al crear linea de promocion de factura: '||no_factu_p||' linea: '||i.no_linea||' '||sqlerrm;
         RAISE error_proceso;
    End;

   End Loop;

   For lot in C_Lineas_Lotes (l.no_linea) Loop

  ---- Carga lotes en la tabla de temporal de lotes de la factura
    Begin
    Insert into ARFAFL_LOTE(no_cia, centrod, no_factu, bodega, no_arti,
                            no_linea, no_lote ,unidades, fecha_vence, ubicacion)
                     Values (lot.no_cia, lot.centrod, no_factu_p, lot.bodega, lot.no_arti,
                             lot.no_linea, lot.no_lote, lot.unidades, lot.fecha_vence, lot.ubicacion);
    Exception
      When others Then
         mensaje_p := 'CE. Error al crear linea de lote de factura: '||no_factu_p||' linea: '||lot.no_linea||' '||sqlerrm;
         RAISE error_proceso;
    End;

   End Loop;

   --- graba linea de impuestos
     FOR ii IN C_Arfafli (l.no_linea) Loop

      Open C_Arti (ii.no_arti);
      Fetch C_Arti into Lv_imp_arti;
      If C_Arti%notfound Then
       Close C_Arti;
       Lv_imp_arti := 'N';
      else
       Close C_Arti;
      end if;

      Open C_Cliente(ii.grupo, ii.no_cliente);
      Fetch C_Cliente into Lv_excento_cli;
      If C_Cliente%notfound Then
       Close C_Cliente;
       Lv_excento_cli := 'N';
      else
       Close C_Cliente;
      end if;


      Open C_Impuestos (no_cia_p, ii.no_arti);
      Fetch C_Impuestos into Ln_columna, Lv_clave, Ln_porcentaje;
       If C_Impuestos%notfound Then
        Close C_Impuestos;
        mensaje_p := 'El articulo/servicio '||ii.no_arti||' no tiene configurados impuestos ';
        RAISE error_proceso;
       else
        Close C_impuestos;
       end if;

       If Lv_imp_arti = 'S' and Lv_excento_cli = 'N' Then

         Begin
         INSERT INTO arfafli(no_cia,         no_factu,
                             tipo_doc,       No_Linea,
                             clave,          porc_imp,
                             base,           monto_imp,      columna,
                             comportamiento, aplica_cred_fiscal,
                             codigo_tercero, id_Sec)
                      VALUES(no_cia_p,
                             no_factu_p,
                             tipo_doc_p,
                             ii.no_linea,
                             Lv_clave,
                             Ln_porcentaje,
                             ii.base_aprobada,
                             (ii.base_aprobada * Ln_porcentaje)/100,
                             Ln_columna,
                             'E',
                             'S',
                             null,
                             null);
        Exception
          When others Then
             mensaje_p := 'Error al crear linea de factura (impuesto): '||no_factu_p||' linea: '||ii.no_linea||' '||sqlerrm;
             RAISE error_proceso;
        end;

            --- Mientras genero ARFAFLI actualizo ARFAFL
       Update Arfafl
        Set    i_ven_n  =  (ii.base_aprobada * Ln_porcentaje)/100,
               i_ven    = 'S'
        Where  no_cia   = no_cia_p
        And    no_factu = no_factu_p
        And    no_linea = ii.no_linea;

     end if;

     END LOOP;

    Ln_contador := Ln_contador + 1;

  END LOOP; --- De las lineas con escala

  -- genera las lineas de la factura, pero solo por las cantidades aprobadas para lineas de pedido sin escala

  ---- si tiene transporte... el valor del transporte va en lineas sin escala ANR 02/10/2009

  FOR m IN c_lineas_sin_escala LOOP

    /**** Si la ultima linea tiene un articulo de bonificacion, debe pasar
          esa ultima linea a otra factura ANR 23/04/2010 ****/

     Open C_Tiene_Bonificacion (m.no_linea);
     Fetch C_Tiene_Bonificacion into Lv_tiene_bonificacion;
     If C_Tiene_Bonificacion%notfound Then
      Close C_Tiene_Bonificacion;
      Lv_tiene_bonificacion := 'N';
     else
      Close C_Tiene_Bonificacion;
     end if;

     --- Crea una nueva factura
     --- If maximo_linea_p = Ln_contador Then

     If maximo_linea_p = Ln_contador
     or (((maximo_linea_p - 1) = Ln_contador) and  Lv_tiene_bonificacion = 'S') Then

     --- Fin de modificacion de ultima linea tiene articulo de bonificacion ANR 23/04/2010

      no_factu_p  := NULL;

      Ln_contador := 0;

      --
      -- obtiene un numero de transaccion
      no_factu_p    := transa_id.fa(no_cia_p);
      msg_generado := msg_generado||' '||no_factu_p;
      --
      Open c_pedidos;
      Fetch c_pedidos into Ped;
       If c_pedidos%notfound Then
        Close c_pedidos;
           mensaje_p := 'No hay un pedido para generar facturas';
           RAISE error_proceso;
       else
        Close c_pedidos;
       end if;

      INSERT INTO arfafe(no_cia,     centrod,      tipo_doc,     periodo,
                         ruta,       no_factu,     afecta_saldo, grupo,
                         no_cliente, tipo_cliente, nbr_cliente,  direccion,
                         fecha,      no_vendedor,  n_factu_d,    plazo,
                         observ1,    observ2,      observ3,      tot_lin,
                         sub_total,  descuento,    impuesto,     total,
                         estado,     ind_anu_dev,  imp_sino,     tipo_factura,
                         peri_ped,   no_pedido,    tipo_cambio,  moneda,
                         no_fisico, serie_fisico,  ind_exportacion, numero_ctrl, codigo_plazo, subcliente, division_comercial, tipo_despacho,
                         no_docu_refe_picking, monto_bienes, codigo_transportista, ind_flete, usuario, tstamp, ind_aplica_escala,
                         bodega, entregar,
                         via_pedido)
                Values (Ped.no_cia, Ped.centrod,       tipo_doc_p,      per_fact_p,
                        ruta_p, no_factu_p, Ped.afecta_saldo, Ped.grupo,
                        Ped.no_cliente, Ped.tipo_cliente,  Ped.nbr_cliente, Ped.direccion,
                        Ld_dia_proceso, Ped.no_vendedor, Ped.n_factu_d, Ped.plazo,
                        Ped.observ1, Ped.observ2, Ped.observ3,
                        0, 0 , 0 , 0, 0,
                        'P', Ped.ind_anu_dev, Ped.imp_sino, 'P',
                        Ped.periodo, Ped.no_factu, tipo_cambio_p, Ped.moneda,
                        NULL, NULL, Ped.ind_exportacion, NULL, Ped.codigo_plazo, Ped.subcliente, Ped.division_comercial, Ped.tipo_despacho,
                        Ped.no_docu_refe_picking, 0, Ped.codigo_transportista, Ped.ind_flete, user, sysdate, Ped.ind_aplica_escala,
                        Ped.bodega, Ped.entregar, Ped.Via_Pedido);

   end if;

  ---- Siempre la cantidad aprobada debe ser igual a lo pedido mas la cantidad adicional,
  ---- caso contrario no puedo generar la factura y deberia quedar en estado N el pedido ANR 25/07/2009

  Ln_total_pedido := nvl(m.pedido,0) + nvl(m.cantidad_adicional,0);

  If nvl(m.cant_aprobada,0) > nvl(m.pedido,0) + nvl(m.cantidad_adicional,0) Then
       mensaje_p := 'VF. Para el articulo: '||m.no_arti||' la cantidad aprobada: '||nvl(m.cant_aprobada,0)||' no puede ser mayor a la cantidad pedida: '||Ln_total_pedido;
       RAISE error_proceso;
  end if;  --- valida que la cantidad aprobada no pueda ser mayor a la cantidad pedida ANR 07/09/2009


    vCosto := articulo.costo(no_cia_p, m.no_arti, m.bodega);

    IF nvl(vCosto,0) = 0 AND m.bodega != '0000' THEN
       mensaje_p := 'SE. El articulo/servicio: '||m.no_arti||' no tiene costo definido en la bodega: '||m.bodega;
       RAISE error_proceso;
     END IF;

     ---- Margen en base a la cantidad aprobada ANR 07/09/2009

     Open C_Cant_Bonif_Pedido (no_pedido_p, m.no_linea);
     Fetch C_Cant_Bonif_Pedido into Ln_cant_bonif;
      If C_Cant_Bonif_Pedido%notfound then
        Ln_cant_bonif := 0;
        Close C_Cant_Bonif_Pedido;
      else
        Close C_Cant_Bonif_Pedido;
      end if;

     Ln_neto := nvl(m.total_aprobado,0) - nvl(m.descuento_aprobado_sr,0);

     If m.linea_art_promocion is null Then
      Ln_margen_valor := Ln_neto -(nvl(m.costo2,0) * (nvl(m.cant_aprobada,0) + nvl(Ln_cant_bonif,0)));
     else
      Ln_margen_valor := 0;
     end if;

     If Ln_neto = 0 Then
      Ln_margen_porc := Ln_margen_valor * 100;
     else
      Ln_margen_porc := (Ln_margen_valor / Ln_neto) * 100;
     end if;

     --
     -- linea de la factura

     Begin
     INSERT INTO arfafl(no_cia,     centrod,   tipo_doc,    periodo,
                        ruta,       no_factu,  no_linea,    bodega,
                        clase,      categoria, no_arti,     pedido,
                        porc_desc,
                        costo,
                        precio,
                        descuento,
                        total,      i_ven,     tipo_precio, un_devol,
                        i_ven_n, imp_especial, imp_incluido,
                        arti_ofe,   cant_ofe,  costo_ofe,   prot_ofe,
                        precio_ofe, tipo_oferta, costo2,linea_art_promocion,
                        margen_valor_fl, margen_minimo,
                        margen_objetivo, margen_porc_fl, secuencia_politica,
                        linea_politica, division, subdivision)
                 VALUES(m.no_cia,       m.centrod,      tipo_doc_p,     per_fact_p,
                        ruta_p,         no_factu_p,     m.no_linea,     m.bodega,
                        m.clase,        m.categoria,    m.no_arti,      m.cant_aprobada,
                        m.porc_desc_aprobado,
                        vcosto,
                        m.precio_aprobado,
                        m.descuento_aprobado,
                        m.total_aprobado,
                        'N',        m.tipo_precio,  m.un_devol,
                        0, 0, 0,
                        null,     null,     null,  m.prot_ofe,
                        null,    null, m.costo2,
                        m.linea_art_promocion, Ln_margen_valor, m.margen_minimo,
                        m.margen_objetivo, Ln_margen_porc, m.secuencia_politica,
                        m.linea_politica, m.division, m.subdivision);

      Exception
        When others Then
           mensaje_p := 'SE. Error al crear linea de factura: '||no_factu_p||' linea: '||m.no_linea||' bodega: '||m.bodega||' articulo: '||m.no_arti||' '||sqlerrm;
           RAISE error_proceso;
      end;

     ---- Si tiene configurado servicio de transporte actualiza cabecera ANR 05/10/2009
     If m.bodega  = '0000' Then

     Update Arfafe
        Set  valor_transporte = Ped.valor_transporte,
             ruta_despacho    = Ped.ruta_despacho
        Where no_cia   = no_cia_p
        And   no_factu = no_factu_p;

     end if;


    ---- Procedo a cargar las promociones registradas en el pedido ANR 23/07/2009

   For h in C_Lineas_Pomociones (m.no_linea) Loop

   Begin
   Insert into Arfapromo_fl (no_cia, no_factu, no_linea, secuencia_politica,
                             linea_politica, tipo_promocion, porc_descuento,
                             precio, cant_minima, cant_maxima, unidades,
                             arti_alterno)
                     Values (h.no_cia, no_factu_p, h.no_linea, h.secuencia_politica,
                             h.linea_politica, h.tipo_promocion, h.porc_descuento,
                             h.precio, h.cant_minima, h.cant_maxima, h.unidades,
                             h.arti_alterno);
    Exception
      When others Then
         mensaje_p := 'SE. Error al crear linea de promocion de factura: '||no_factu_p||' linea: '||h.no_linea||' '||sqlerrm;
         RAISE error_proceso;
    End;

   End Loop;

   For lot in C_Lineas_Lotes (m.no_linea) Loop

  ---- Carga lotes en la tabla de temporal de lotes de la factura
    Begin
    Insert into ARFAFL_LOTE(no_cia, centrod, no_factu, bodega, no_arti,
                            no_linea, no_lote ,unidades, fecha_vence, ubicacion)
                     Values (lot.no_cia, lot.centrod, no_factu_p, lot.bodega, lot.no_arti,
                             lot.no_linea, lot.no_lote, lot.unidades, lot.fecha_vence, lot.ubicacion);
    Exception
      When others Then
         mensaje_p := 'SE. Error al crear linea de lote de factura: '||no_factu_p||' linea: '||lot.no_linea||' '||sqlerrm;
         RAISE error_proceso;
    End;

   End Loop;

   --- graba linea de impuestos
     FOR ii IN C_Arfafli (m.no_linea) Loop

      Open C_Arti (ii.no_arti);
      Fetch C_Arti into Lv_imp_arti;
      If C_Arti%notfound Then
       Close C_Arti;
       Lv_imp_arti := 'N';
      else
       Close C_Arti;
      end if;

      Open C_Cliente(ii.grupo, ii.no_cliente);
      Fetch C_Cliente into Lv_excento_cli;
      If C_Cliente%notfound Then
       Close C_Cliente;
       Lv_excento_cli := 'N';
      else
       Close C_Cliente;
      end if;

      Open C_Impuestos (no_cia_p, ii.no_arti);
      Fetch C_Impuestos into Ln_columna, Lv_clave, Ln_porcentaje;
       If C_Impuestos%notfound Then
        Close C_Impuestos;
        mensaje_p := 'El articulo/servicio '||ii.no_arti||' no tiene configurados impuestos ';
        RAISE error_proceso;
       else
        Close C_impuestos;
       end if;

       If Lv_imp_arti = 'S' and Lv_excento_cli = 'N' Then

       Begin
       INSERT INTO arfafli(no_cia,         no_factu,
                           tipo_doc,       No_Linea,
                           clave,          porc_imp,
                           base,           monto_imp,      columna,
                           comportamiento, aplica_cred_fiscal,
                           codigo_tercero, id_Sec)
                    VALUES(no_cia_p,
                           no_factu_p,
                           tipo_doc_p,
                           ii.no_linea,
                           Lv_clave,
                           Ln_porcentaje,
                           ii.base_aprobada,
                           (ii.base_aprobada * Ln_porcentaje)/100,
                           Ln_columna,
                           'E',
                           'S',
                           null,
                           null);
      Exception
        When others Then
           mensaje_p := 'Error al crear linea de factura (impuesto): '||no_factu_p||' linea: '||ii.no_linea||' '||sqlerrm;
           RAISE error_proceso;
      end;

          --- Mientras genero ARFAFLI actualizo ARFAFL
     Update Arfafl
      Set    i_ven_n  =  (ii.base_aprobada * Ln_porcentaje)/100,
             i_ven    = 'S'
      Where  no_cia   = no_cia_p
      And    no_factu = no_factu_p
      And    no_linea = ii.no_linea;

      end if;

     END LOOP;

   Ln_contador := Ln_contador + 1;

  END LOOP; --- De las lineas sin escala

  --
  -- Suma las lineas y graba el total de la factura en el encabezado

    For h in C_Actualiza_Arfafe Loop


        Update Arfafe
        Set  tot_lin      = h.total ,
             sub_total    = h.total - h.descuento,
             monto_bienes = h.total - h.descuento,
             descuento    = h.descuento,
             impuesto     = h.impuesto,
             total        = h.total - h.descuento + h.impuesto
        Where no_cia   = no_cia_p
        And   no_factu = h.no_factu;


   --- Como esta parte es un resumen y ya se tienen creadas las lineas se hace la creacion de la guia
   --- Crea guia de remision por cada factura ANR 29/01/2010
   --- Al final se crea la guia de remision porque debe haberse generado el detalle de lineas

    FACREA_GUIA_REMISION(no_cia_p, h.no_factu, mensaje_p);
    If mensaje_p is not null Then
     raise error_proceso;
    end if;

   --- Verifico que se haya creado el detalle

        Open C_Detalle (h.no_factu);
        Fetch C_Detalle into Lv_dummy;
        If C_Detalle%notfound Then
         Close C_Detalle;
           mensaje_p := 'Documento :'||h.no_factu||' sin detalle, no se puede procesar';
           RAISE error_proceso;
        else
         Close C_Detalle;
        end if;

      End Loop;

      Update Arfafec
      Set    estado = 'C' --- completo se convierte en factura
      Where  no_cia   = no_cia_p
      And    no_factu = no_pedido_p;


EXCEPTION
  WHEN articulo.error THEN
       mensaje_p := articulo.ultimo_error;
  WHEN error_proceso THEN
       mensaje_p := mensaje_p;
  WHEN transa_id.error THEN
       mensaje_p := transa_id.ultimo_error;
  WHEN consecutivo.error THEN
       mensaje_p :=Consecutivo.ultimo_error;
  WHEN OTHERS THEN
       mensaje_p := sqlerrm;
END;