create or replace procedure            FACREA_FACTURA (
  no_cia_p        IN varchar2,
  no_pedido_p     IN varchar2,
  ruta_p          IN varchar2,
  per_fact_p      IN varchar2,
  tipo_doc_p      IN varchar2,
  tipo_cambio_p   IN number,
  no_factu_p      IN OUT Varchar2,
  mensaje_p       IN OUT Varchar2
) IS
  --

  error_proceso    exception;

  --------------------add mlopez 25/05/2010------------------------
  Cursor C_Bodega(cv_cia varchar2,cv_factu varchar2) Is
     select b.centrod, a.bodega, b.fecha, b.tipo_doc, b.grupo, b.no_cliente, b.subcliente
     from   arfafl a, arfafe b
     where  a.no_cia    = cv_cia
     and    a.no_factu  = cv_factu
     and    a.no_cia    = b.no_cia
     and    a.no_factu  = b.no_factu;

  lc_bodega c_bodega%rowtype;
  --------fin add mlopez 25/05/2010-------------------------------------
  Cursor C_Pedido Is
   Select centrod
   From   Arfafec
   Where  no_cia   = no_cia_p
   And    no_factu = no_pedido_p;

  --
  CURSOR c_lineas IS
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
           (nvl(cant_aprobada,0) * nvl(precio_aprobado,0)) * (nvl(porc_desc_aprobado,0)/100) descuento_aprobado_sr --- descuento sin redondear para calculo de margen
      FROM arfaflc u
     WHERE no_cia   = no_cia_p
       AND no_factu = no_pedido_p
       AND cant_aprobada > 0
       ----add mlopez 17/05/2010
       and not exists
       (
        select no_cia
         from arfapromo_flc z
        where z.no_cia=u.no_cia and z.no_pedido=u.no_factu
         and z.no_linea=u.no_linea
         and z.tipo_promocion='E'
       )
        ----------fin add mlopez 17/05/2010
       Order by 3; --- Ordenado por numero de linea para que salga igual como el pedido ANR 05/03/2010

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

Cursor C_Arfafli Is
    SELECT b.grupo, b.no_cliente, a.no_linea,
           (nvl(a.cant_aprobada,0) * nvl(a.precio_aprobado,0)) -
           round((nvl(a.cant_aprobada,0) * nvl(a.precio_aprobado,0)) * (nvl(a.porc_desc_aprobado,0)/100),2) base_aprobada, a.no_arti
      FROM arfaflc a, arfafec b
     WHERE a.no_cia   = no_cia_p
       AND a.no_factu = no_pedido_p
       AND a.cant_aprobada > 0
       AND a.i_ven = 'S'
       AND a.no_cia = b.no_cia
       ANd a.no_factu = b.no_factu
       ----add mlopez 17/05/2010
       and not exists
       (
        select no_cia
         from arfapromo_flc z
        where z.no_cia=a.no_cia and z.no_pedido=a.no_factu
         and z.no_linea=a.no_linea
         and z.tipo_promocion='E'
       );
        ----------fin add mlopez 17/05/2010;

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

  Cursor C_Cant_Bonif_Pedido (Lv_Pedido Varchar2, Ln_linea Number) Is
     select nvl(cant_aprobada,0) cantidad_bonificacion
     from   arfaflc
     where  no_cia   = no_cia_p
     and    no_factu = Lv_pedido
     and    linea_art_promocion = Ln_linea;

   Cursor C_Actualiza_Arfafe (Lv_factu Varchar2) Is
   Select no_factu, sum(total) total, sum(descuento) descuento, sum(i_ven_n) impuesto
   From   Arfafl
   Where  no_cia = no_cia_p
   And    no_factu = Lv_factu
   group by no_factu;

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

  --

  vCosto          arinma.costo_uni%type;
  Ln_columna      Arcgimp.columna%type;
  Lv_clave        Arcgimp.clave%type;
  Ln_porcentaje   Arcgimp.porcentaje%type;

  Ln_total_pedido Number :=0;

  Lv_dummy        Varchar2(1);

  Ln_margen_valor Arfafl.Margen_Valor_Fl%type;
  Ln_margen_porc  Arfafl.Margen_Porc_Fl%type;
  Ln_cant_bonif   Arfafl.pedido%type;
  Ln_neto         Number; --- Solo se debe tomar para el calculo del margen ya que esta con todos los decimales ANR 09/12/2009

  Lv_imp_arti    Arinda.imp_ven%type;
  Lv_excento_cli Arccmc.Excento_Imp%type;

  Lv_centro_distribucion Arincd.centro%type;
  Ld_dia_proceso         Arincd.Dia_Proceso_Fact%type;
  lc_lineas c_lineas%rowtype;
  --
BEGIN
  mensaje_p     := NULL;
  no_factu_p    := NULL;
  --
  -- obtiene un numero de transaccion
  no_factu_p    := transa_id.fa(no_cia_p);
  --

  Open C_Pedido;
  Fetch C_Pedido into Lv_centro_distribucion;
  If C_Pedido%notfound Then
   Close C_Pedido;
       mensaje_p := 'Pedido no existe: '||no_pedido_p;
       RAISE error_proceso;
  else
   Close C_Pedido;
  end if;

  Open C_Dia_proceso (Lv_centro_distribucion);
  Fetch C_Dia_proceso into Ld_dia_proceso;
  If C_Dia_proceso%notfound Then
   Close C_Dia_proceso;
       mensaje_p := 'No existe centro de distribucion: '||Lv_centro_distribucion;
       RAISE error_proceso;
  else
   Close C_Dia_proceso;
  end if;

  If Ld_dia_proceso is null Then
     mensaje_p := 'No existe dia de proceso de facturacion para el centro de distribucion: '||Lv_centro_distribucion;
     RAISE error_proceso;
  end if;

  open c_lineas;
  fetch c_lineas into lc_lineas;

  if c_lineas%found then
      Begin
      INSERT INTO arfafe(no_cia,     centrod,      tipo_doc,     periodo,
                         ruta,       no_factu,     afecta_saldo, grupo,
                         no_cliente, tipo_cliente, nbr_cliente,  direccion,
                         fecha,      no_vendedor,  n_factu_d,    plazo,
                         observ1,    observ2,      observ3,      tot_lin,
                         sub_total,  descuento,    impuesto,     total,
                         estado,     ind_anu_dev,  imp_sino,     tipo_factura,
                         peri_ped,   no_pedido,    tipo_cambio,  moneda,
                         no_fisico, serie_fisico,  ind_exportacion, numero_ctrl, codigo_plazo, subcliente, division_comercial, tipo_despacho,
                         no_docu_refe_picking, monto_bienes, codigo_transportista, ind_flete, usuario, tstamp, ind_aplica_escala, bodega, entregar,
                         valor_transporte, ruta_despacho,
                         Via_Pedido)
                  SELECT no_cia,            centrod,       tipo_doc_p,      per_fact_p,
                         ruta_p,            no_factu_p,    afecta_saldo,    grupo,
                         no_cliente,        tipo_cliente,  nbr_cliente,     direccion,
                         Ld_dia_proceso, no_vendedor,   n_factu_d,       plazo,
                         observ1,           observ2,       observ3,
                         0, 0, 0 , 0, 0,
                         'P',               ind_anu_dev,   imp_sino,        'P',
                         periodo,           no_factu,      tipo_cambio_p,    moneda,
                         NULL,              NULL,          ind_exportacion, NULL, codigo_plazo, subcliente, division_comercial, tipo_despacho,
                         no_docu_refe_picking, 0, codigo_transportista, ind_flete, user, sysdate, ind_aplica_escala, bodega, entregar,
                         valor_transporte, ruta_despacho,
                         via_pedido
                    FROM arfafec
                   WHERE no_cia    = no_cia_p
                     AND no_factu  = no_pedido_p;
      Exception
        When others Then
           mensaje_p := 'Error al crear cabecera de factura: '||no_factu_p||' '||sqlerrm;
           RAISE error_proceso;
      end;
  end if;

  close c_lineas;
  -- genera las lineas de la factura, pero solo por las cantidades aprobadas

  FOR l IN c_lineas LOOP

  ---- Siempre la cantidad aprobada debe ser igual a lo pedido mas la cantidad adicional,
  ---- caso contrario no puedo generar la factura y deberia quedar en estado N el pedido ANR 25/07/2009

  Ln_total_pedido := nvl(l.pedido,0) + nvl(l.cantidad_adicional,0);

  If nvl(l.cant_aprobada,0) > nvl(l.pedido,0) + nvl(l.cantidad_adicional,0) Then
       mensaje_p := 'Para el articulo: '||l.no_arti||' la cantidad aprobada: '||nvl(l.cant_aprobada,0)||' no puede ser mayor a la cantidad pedida: '||Ln_total_pedido;
       RAISE error_proceso;
  end if;  --- valida que la cantidad aprobada no pueda ser mayor a la cantidad pedida ANR 07/09/2009

    vCosto := articulo.costo(no_cia_p, l.no_arti, l.bodega);

    IF nvl(vCosto,0) = 0 AND l.bodega != '0000' THEN
       mensaje_p := 'El articulo/servicio '||l.no_arti||' no tiene costo definido en la bodega '||l.bodega;
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
                        precio,
                        descuento,
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
                        l.precio_aprobado,
                        l.descuento_aprobado,
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
           mensaje_p := 'Error al crear linea de factura: '||no_factu_p||' linea: '||l.no_linea||' bodega: '||l.bodega||' articulo: '||l.no_arti||' '||sqlerrm;
           RAISE error_proceso;
      end;

     --
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
         mensaje_p := 'Error al crear linea de promocion de factura: '||no_factu_p||' linea: '||i.no_linea||' '||sqlerrm;
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
         mensaje_p := 'Error al crear linea de lote de factura: '||no_factu_p||' linea: '||lot.no_linea||' '||sqlerrm;
         RAISE error_proceso;
    End;

   End Loop;

  END LOOP; --- De las Lineas

   --- graba linea de impuestos
  FOR ii IN C_Arfafli Loop

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


    For h in C_Actualiza_Arfafe (no_factu_p) Loop


        Update Arfafe
        Set  tot_lin      = h.total ,
             sub_total    = h.total - h.descuento,
             monto_bienes = h.total - h.descuento,
             descuento    = h.descuento,
             impuesto     = h.impuesto,
             total        = h.total - h.descuento + h.impuesto
        Where no_cia   = no_cia_p
        And   no_factu = h.no_factu;


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


   --- Crea guia de remision por cada factura ANR 29/01/2010
   --- Para la creacion de la guia es necesario que se haya creado todo el detalle
    ------------add mlopez 25/05/2010 -------------------------
    open c_bodega(no_cia_p, no_factu_p);
    fetch c_bodega into lc_bodega;

    if c_bodega%found then
       FACREA_GUIA_REMISION(no_cia_p, no_factu_p, mensaje_p);
    end if;

    close c_bodega;
    ---------------fin add mlopez 25/05/2010------------------
    If mensaje_p is not null Then
       mensaje_p:=mensaje_p||' al crear guia de remision.';
       raise error_proceso;
    else
       /*****************add mlopez 17/05/2010******************/
       FACREA_FACTURA_ESCALAS (
                                no_cia_p,
                                no_pedido_p,
                                ruta_p,
                                per_fact_p,
                                tipo_doc_p,
                                tipo_cambio_p,
                                no_factu_p,
                                mensaje_p
                              );
       /************************fin add mlopez 17/05/2010***************/
    end if;

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