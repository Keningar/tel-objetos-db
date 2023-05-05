CREATE OR REPLACE package            FAPROFORMA is

  -- Author  : Antonio Navarrete
  -- Created : 20/05/2009 9:16:12
  -- Purpose : Manejo de proformas para la facturacion

  -- Public function and procedure declarations

   --- Devuelve datos relacionados al segmento de mercado default para la proforma
    procedure Segmento_Mercado(Pv_Cia      IN Varchar2,
                               Pv_Segmento OUT Varchar2,
                               Pv_Mensaje  OUT Varchar2);

    --- Devuelve datos relacionados a la division comercial
    procedure Division_Comercial(Pv_Cia           IN Varchar2,
                                 Pv_Centro        IN Varchar2,
                                 Pv_Div_Comercial OUT Varchar2,
                                 Pv_Mensaje       OUT Varchar2);

   --- Devuelve los dias proforma que se configuran por default

    function  Dias_proforma (Pv_cia  IN Varchar2) Return Number;


  --- Actualiza el estado de una proforma pendiente en proforma aprobada

     procedure Aprueba_Proforma (Pv_cia           IN  Varchar2,
                                 Pv_centro        IN  Varchar2,
                                 Pn_proforma      IN  Number,
                                 Pv_emple_aprueba IN  Varchar2,
                                 Pv_pedido        OUT Varchar2,
                                 Pv_Error         OUT Varchar2);


  --- Actualiza el estado de una proforma pendiente en proforma anulada

     procedure Anula_Proforma (Pv_cia           IN  Varchar2,
                               Pv_centro        IN  Varchar2,
                               Pn_proforma      IN  Number,
                               Pv_Error         OUT Varchar2);


end FAPROFORMA;
/


CREATE OR REPLACE package body            FAPROFORMA is

  -- Function and procedure implementations
    procedure Segmento_Mercado(Pv_Cia      IN Varchar2,
                               Pv_Segmento OUT Varchar2,
                               Pv_Mensaje  OUT Varchar2) Is

    --- Devuelve datos relacionados al segmento de mercado default para la proforma
    Cursor C_Seg_Mercado Is
     select seg_mercado_proforma
     from   arfamc
     where  no_cia = Pv_Cia;

     Lv_segmento Arfamc.seg_mercado_proforma%type;

    Begin

    Open C_Seg_Mercado;
    Fetch C_Seg_Mercado into Lv_Segmento;
    If C_Seg_Mercado%notfound Then
     Close C_Seg_Mercado;
     Pv_Mensaje := 'No existe configurado la compa?ia en Facturacion';
    else
     Close C_Seg_Mercado;
     If Lv_Segmento is null Then
      Pv_Mensaje := 'Debe configurar un segmento de mercado para la proforma, en la pantalla de maestro de compa?ias de facturacion';
     else
      Pv_segmento := Lv_Segmento;
     end if;

    end if;

    end;

    procedure Division_Comercial(Pv_Cia           IN Varchar2,
                                 Pv_Centro        IN Varchar2,
                                 Pv_Div_Comercial OUT Varchar2,
                                 Pv_Mensaje       OUT Varchar2) Is

    --- Devuelve datos relacionados a la division comercial
    Cursor C_Division_Comercial Is
     select div_comercial_proforma
     from   arincd
     where  no_cia = Pv_Cia
     and    centro = Pv_centro;

     Lv_Div_Comercial Arincd.div_comercial_proforma%type;

    Begin

    Open C_Division_Comercial;
    Fetch C_Division_Comercial into Lv_Div_Comercial;
    If C_Division_Comercial%notfound Then
     Close C_Division_Comercial;
     Pv_Mensaje := 'No existe configurado el centro de distribucion en Facturacion';
    else
     Close C_Division_Comercial;
     If Lv_Div_Comercial is null Then
      Pv_Mensaje := 'Debe configurar la division comercial para la proforma, en la pantalla de centros de distribucion de facturacion';
     else
      Pv_Div_Comercial := Lv_Div_Comercial;
     end if;

    end if;

    end;

   --- Devuelve los dias proforma que se configuran por default

   function  Dias_proforma (Pv_cia  IN Varchar2) Return Number Is
    Cursor C_Dias_Proforma Is
     select nvl(dias_proforma,0)
     from   arfamc
     where  no_cia = Pv_Cia;

     Ln_dias_proforma arfamc.dias_proforma%type;

   Begin
     Open C_Dias_Proforma;
     Fetch C_Dias_Proforma into Ln_dias_proforma;
      If C_Dias_Proforma%notfound then
       Close C_Dias_Proforma;
       return (0);
      else
       Close C_Dias_Proforma;
       return (Ln_dias_proforma);
      end if;
   end;


  --- Actualiza el estado de una proforma pendiente en proforma aprobada

     procedure Aprueba_Proforma (Pv_cia           IN  Varchar2,
                                 Pv_centro        IN  Varchar2,
                                 Pn_proforma      IN  Number,
                                 Pv_emple_aprueba IN  Varchar2,
                                 Pv_pedido        OUT Varchar2,
                                 Pv_Error         OUT Varchar2) Is

    Cursor C_Datos_Proforma Is
     Select grupo, no_cliente, subcliente, tipo_venta, ruta
     From   ARFAENCPROFORM
     Where  no_cia      = Pv_cia
     And    centrod     = Pv_centro
     And    no_proforma = Pn_Proforma;

    --- Obtiene datos del cliente

    Cursor C_Datos_Cliente (Lv_Grupo Varchar2, Lv_cliente Varchar2) Is
     Select tipo_cliente, plazo
     From   Arccmc
     Where  no_cia     = Pv_cia
     And    grupo      = Lv_grupo
     And    no_cliente = Lv_cliente;

    --- Verifica el formulario en la proforma

    Cursor C_Doc Is
     SELECT count(*)
     FROM   ARFACT
     where  no_cia = Pv_cia
     and    ind_fac_dev = 'E';

    Cursor C_Form_pedido Is
     SELECT tipo
     FROM   ARFACT
     where  no_cia = Pv_Cia
     and    ind_fac_dev = 'E';

    Cursor C_Codigo_Plazo is
     select codigo
     from   arccplazos
     where  no_cia = Pv_cia
     and    plazo  = 0
     and    estado = 'A';

    Cursor C_Dia_proceso_Fact Is
     Select dia_proceso_fact
     From   Arincd
     Where  no_cia = Pv_cia
     And    centro = Pv_centro;

     --- Se agrega por default una via de pedido cuando proviene de proforma ANR 21/10/2009
     Cursor C_Via_Pedido Is
      select codigo
      from   Arfa_via_pedido
      where  no_cia = Pv_Cia
      and    viene_proforma = 'S';

     Ln_total   Number;
     Lv_tipo    ARFACT.tipo%type;

     Lv_tipo_cliente Arccmc.tipo_cliente%type := null;
     Lv_codigo_plazo ARCCPLAZOS.codigo%type;
     Ln_plazo        Arccmc.plazo%type;
     Lv_pedido       ARFAFEC.no_factu%type;
     Lv_fisico       ARFAFEC.no_fisico%type;

     Ld_Fecha_Fact   Arincd.dia_proceso_fact%type;

     Lv_via_pedido   Arfa_via_pedido.codigo%type;

     Lv_error        Varchar2(500);
     Error_Proceso   Exception;

     Begin

    For i in C_Datos_Proforma Loop

          Open C_Doc;
          Fetch C_Doc into Ln_total;
          If C_Doc%notfound then
            Close C_Doc;
            lv_error := 'Debe configurar en tipos de documento, un documento para pedidos';
            raise error_proceso;
          else
            Close C_Doc;
            If Ln_total > 1 Then
             lv_error := 'Debe configurar un solo documento para pedidos, en la pantalla de tipos de documento';
             raise error_proceso;
            end if;
          end if;


          Open C_Form_pedido;
          Fetch C_Form_pedido into Lv_tipo;
          If C_Form_pedido%notfound then
            Close C_Form_pedido;
            Lv_error := 'Debe configurar en tipos de documento, un documento para pedidos';
            raise error_proceso;
          else
            Close C_Form_pedido;
          end if;

          Lv_fisico  := Consecutivo.FA(Pv_Cia,   to_number(to_char(sysdate,'YYYY')), to_number(to_char(sysdate,'MM')),
                                       Pv_Centro,  i.ruta,     Lv_tipo,
                                       'NUMERO');  ---- Genera secuencial para el pedido ANR 22/09/2009

          If Lv_fisico is null Then
           lv_error := 'No genero numero de pedido para, a?o: '||to_number(to_char(Sysdate,'YYYY'))||' mes: '||to_number(to_char(Sysdate,'MM'))||' centro: '||Pv_Centro||' ruta: '||i.ruta||' doc: '||Lv_tipo||' tipo: '||'NUMERO';
           raise error_proceso;
          end if;


          Lv_pedido  := Consecutivo.FA(Pv_Cia,   to_number(to_char(sysdate,'YYYY')), to_number(to_char(sysdate,'MM')),
                                       Pv_Centro,  i.ruta,     Lv_tipo,
                                       'SECUENCIA');  ---- Genera secuencial para el pedido ANR 15/06/2009

          If Lv_pedido is null Then
           lv_error := 'No genero numero transaccion de pedido para, a?o: '||to_number(to_char(Sysdate,'YYYY'))||' mes: '||to_number(to_char(Sysdate,'MM'))||' centro: '||Pv_Centro||' ruta: '||i.ruta||' doc: '||Lv_tipo||' tipo: '||'SECUENCIA';
           raise error_proceso;
          else

           --- Crea los registros de pedido


           --- Fecha de pedido (dia actual o sysdate)

            If i.grupo is null and i.no_cliente is null then
             Lv_Error := 'No existe codigo del cliente: '||i.grupo||' - '||i.no_cliente||' para la proforma: '||Pn_proforma;
             raise Error_Proceso;
            end if;

           Open C_Datos_Cliente (i.grupo, i.no_cliente);
           Fetch C_Datos_Cliente into Lv_tipo_cliente, Ln_plazo;
           If C_Datos_Cliente%notfound Then
            Close C_Datos_Cliente;
            Lv_Error := 'No existe el codigo del cliente: '||i.grupo||' - '||i.no_cliente||' para la proforma: '||Pn_proforma;
            raise Error_Proceso;
           else
            Close C_Datos_Cliente;

            If Lv_tipo_cliente is null then
             Lv_Error := 'El tipo de cliente no existe, para el codigo del cliente: '||i.grupo||' - '||i.no_cliente||' para la proforma: '||Pn_proforma;
             raise Error_Proceso;
            end if;
           end if;

          If i.subcliente is null Then
            Lv_Error := 'El subcliente no existe, para el centro: '||Pv_centro||' codigo del cliente: '||i.grupo||' - '||i.no_cliente||' para la proforma: '||Pn_proforma;
            raise Error_Proceso;
          end if;

          If i.tipo_venta = 'C' Then --- contado, el plazo es 0 dias

            Open C_Codigo_plazo;
            Fetch C_Codigo_plazo into Lv_codigo_plazo;
            If C_Codigo_plazo%notfound Then
             Close C_Codigo_plazo;
              Lv_Error := 'No existe configurado un plazo para la forma de pago contado';
              raise Error_Proceso;
            else
             Close C_Codigo_plazo;
            end if;

           Ln_plazo := 0;

          end if;

          Open  C_Dia_proceso_Fact;
          Fetch C_Dia_proceso_Fact into Ld_Fecha_Fact;
          If C_Dia_proceso_Fact%notfound Then
            Close C_Dia_proceso_Fact;
              Lv_Error := 'No hay centro de distribucion configurado';
              raise Error_Proceso;
          else
            Close C_Dia_proceso_Fact;
          end if;

          --- Devuelve una sola via de pedido para proforma, la primera  que encuentre,
          --- si no existe guarda nulo ANR 21/10/2009

          Open C_Via_Pedido;
          Fetch C_Via_Pedido into Lv_via_pedido;
          Close C_Via_Pedido;


           --- En referencia va al numero de proforma
           Begin
             Insert into ARFAFEC (no_cia, centrod, periodo, no_factu, ruta, afecta_saldo, grupo, no_cliente,
                                  tipo_cliente, nbr_cliente, direccion, fecha, no_vendedor, n_factu_d, plazo,
                                  entregar, observ1, observ2, observ3, moneda, tot_lin, sub_total, descuento,
                                  impuesto, total, estado, f_ult_estado, aprobado, ind_anu_dev, imp_sino,
                                  tipo_factura, peri_liq, no_liq, razon, porc_desc, nota_pedido,
                                  numero_ctrl, ind_exportacion, tipo_cambio,  descuento1, descuento2,
                                  codigo_plazo, referencia, no_linea, reserva_standby, usuario,
                                  par_despacho, tstamp, ind_margen, subcliente, division_comercial,
                                  pedido_modificable, bodega, ind_aplica_escala, no_fisico, valor_transporte, ruta_despacho, ind_flete, codigo_transportista, via_pedido)
             Select no_cia, centrod, to_char(Ld_Fecha_Fact,'YYYY'), Lv_pedido, ruta, decode(tipo_venta,'C','N','R','S'), grupo, no_cliente,
                    Lv_tipo_cliente, substr(nombres||' '||apellidos,1,80), direccion, Ld_Fecha_Fact, vendedor, null, Ln_plazo,
                    null, 'Pedido generado de Proforma No. '||Pn_proforma, null, null, moneda, tot_lin, sub_total, descuento,
                    impuesto, total, 'P', null, 'N', null , imp_sino,
                    'P', null, null, null, porc_desc, null,
                    null, 'N', tipo_cambio, 0, 0,
                    lv_codigo_plazo, no_proforma, null, null, usuario, --- para que el pedido se genere con el mismo usuario que hizo la proforma
                    'N', sysdate,'N', subcliente, division,
                    'S', bodega, ind_aplica_escala, Lv_fisico, valor_transporte, ruta_despacho, ind_flete, codigo_transportista, Lv_via_pedido
             From   ARFAENCPROFORM
             Where  no_cia      = Pv_cia
             And    no_proforma = Pn_Proforma;

           Exception
           When Others Then
            Lv_Error := 'Error al crear cabecera de pedido, para la proforma: '||Pn_proforma||' '||SQLERRM;
            raise Error_Proceso;
           End;

           Pv_pedido := Lv_fisico; --- Devuelvo el pedido que me genera


       Begin

         Insert into ARFAFLC (no_cia, centrod, periodo, no_factu, no_linea, bodega, clase, categoria, no_arti, pedido, porc_desc, precio,
                              descuento, total, i_ven, i_ven_n, tipo_precio, un_devol, tipo_oferta, arti_ofe, cant_ofe, prot_ofe,
                              cant_aprobada, cant_facturada, ofe_entregada, imp_incluido, imp_especial, costo2, solicita_transferencia, division, subdivision,
                              linea_art_promocion, secuencia_politica, linea_politica,
                              cantidad_adicional, Descuento_Adicional, ind_adicional,
                              margen_valor_flc, margen_minimo, margen_objetivo, margen_porc_flc)
         Select no_cia, centrod, to_char(Ld_Fecha_Fact,'YYYY'), Lv_pedido, no_linea, bodega, clase, categoria, no_arti, cantidad, porc_desc, precio,
                descuento, total, i_ven, i_ven_n, tipo_precio, 0, tipo_oferta, arti_ofe, cant_ofe, prot_ofe,
                null, 0, null, imp_incluido, imp_especial, costo2, 'N', division, subdivision,
                linea_art_promocion, secuencia_politica, linea_politica,
                cantidad_adicional, Descuento_Adicional, ind_adicional ,
                margen_valor_prof, margen_minimo, margen_objetivo, margen_porc_prof
         from   ARFADETPROFORM
         Where  no_cia      = Pv_cia
         And    no_proforma = Pn_Proforma;

       Exception
       When Others Then
        Lv_Error := 'Error al crear el detalle del pedido, para la proforma: '||Pn_proforma||' '||SQLERRM;
        raise Error_Proceso;
       End;

       --- Crea las promociones en el pedido, en base a lo registrado en la proforma

       Begin

         Insert into ARFAPROMO_FLC (no_cia, no_pedido, no_linea, secuencia_politica,
                                    linea_politica, tipo_promocion, porc_descuento,
                                    precio, cant_minima, cant_maxima, unidades, arti_alterno)
         Select no_cia, Lv_pedido, no_linea, secuencia_politica,
                                    linea_politica, tipo_promocion, porc_descuento,
                                    precio, cant_minima, cant_maxima, unidades, arti_alterno
         from   ARFAPROMO_PROF
         Where  no_cia      = Pv_cia
         And    no_proforma = Pn_Proforma;

       Exception
       When Others Then
        Lv_Error := 'Error al crear el detalle de promociones del pedido, para la proforma: '||Pn_proforma||' '||SQLERRM;
        raise Error_Proceso;
       End;

       --- Actualiza el estado de la proforma

       Update Arfaencproform
       Set    estado          = 'D',
              usuario_aprueba = user,
              fecha_aprueba   = sysdate,
              emple_aprueba   = Pv_Emple_aprueba
       Where  no_cia      = Pv_cia
       And    centrod     = Pv_centro
       And    no_proforma = Pn_proforma
       And    estado = 'P';

     End if;

     End Loop;

     Exception
     When Error_Proceso Then
     Pv_Error := Lv_Error;
     When Others Then
     Pv_Error := 'Error al aprobar proforma: '||Pn_Proforma||' '||sqlerrm;

     End;

  --- Actualiza el estado de una proforma pendiente en proforma anulada

     procedure Anula_Proforma (Pv_cia           IN  Varchar2,
                               Pv_centro        IN  Varchar2,
                               Pn_proforma      IN  Number,
                               Pv_Error         OUT Varchar2) Is

     Begin

       --- Actualiza el estado de la proforma

       Update Arfaencproform
       Set    estado        = 'A',
              fecha_anula   = sysdate,
              usuario_anula = user
       Where  no_cia      = Pv_cia
       And    centrod     = Pv_centro
       And    no_proforma = Pn_proforma
       And    estado = 'P';

     Exception
       When Others Then
       Pv_Error := 'Error al anular la proforma: '||Pn_Proforma||' '||sqlerrm;
     End;

end FAPROFORMA;
/
