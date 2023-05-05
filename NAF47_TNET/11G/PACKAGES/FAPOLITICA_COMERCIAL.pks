CREATE OR REPLACE package            FAPOLITICA_COMERCIAL is

   -- Author  : Antonio Navarrete
   -- Created : 02/06/2009 9:16:12
   -- Purpose : Manejo de politicas comerciales para la proforma y para el pedido

   -- Public function and procedure declarations

    --- Funcion que verifica si una proforma tiene o no promocion

    function Proforma_tiene_promocion (Pv_Cia IN Varchar2,
                                       Pn_proforma IN Number,
                                       Pn_linea_proforma IN Number) return Boolean;

   --- Crea registros en la tabla de promociones para la proforma

    procedure Crea_promocion_proforma  (Pv_Cia            IN Varchar2,
                                        Pn_proforma       IN Number,
                                        Pn_Linea_proforma IN Number,
                                        Pn_sec_politica   IN Number,
                                        Pn_linea_Politica  IN Number,
                                        Pv_Error          OUT Varchar2);

   --- Actualiza los descuentos de la proforma en base a la politica comercial elegida

    procedure Carga_Descuento_Proforma (Pv_Cia            IN Varchar2,
                                        Pn_proforma       IN Number,
                                        Pn_Linea_proforma IN Number,
                                        Pn_sec_politica   IN Number,
                                        Pn_linea_Politica  IN Number);

    --- Elimina descuento en la proforma

    procedure Elimina_Descuento_Proforma (Pv_Cia            IN Varchar2,
                                          Pn_proforma       IN Number,
                                          Pn_Linea_proforma IN Number,
                                          Pn_sec_politica   IN Number,
                                          Pn_linea_Politica  IN Number);

    --- Carga precio en la linea de la proforma

    procedure Carga_Precio_Proforma ( Pv_Cia            IN Varchar2,
                                      Pn_proforma       IN Number,
                                      Pn_Linea_proforma IN Number,
                                      Pn_sec_politica   IN Number,
                                      Pn_linea_Politica  IN Number);


    --- Elimina precio en la linea de la proforma

    procedure Elimina_Precio_Proforma (Pv_Cia            IN Varchar2,
                                       Pn_proforma       IN Number,
                                       Pn_Linea_proforma IN Number,
                                       Pn_sec_politica   IN Number,
                                       Pn_linea_Politica  IN Number);

   --- Verifica escalas de una promocion para una proforma

    function Verifica_escalas_proforma (Pv_Cia             IN  Varchar2,
                                        Pn_proforma        IN  Number,
                                        Pn_linea_proforma  IN  Number,
                                        Pn_sec_politica    IN  Number,
                                        Pn_linea_Politica  IN  Number,
                                        Pv_mensaje         OUT Varchar2) return Boolean;

    --- Carga escala en la linea de la proforma

    procedure Carga_Escala_Proforma ( Pv_Cia            IN Varchar2,
                                      Pn_proforma       IN Number,
                                      Pn_Linea_proforma IN Number,
                                      Pn_sec_politica   IN Number,
                                      Pn_linea_Politica  IN Number,
                                      Pv_Error          OUT Varchar2);

    --- Elimina precio en la linea de la proforma

    procedure Elimina_Escala_Proforma (Pv_Cia            IN Varchar2,
                                       Pn_proforma       IN Number);

    --- Verifica bonificacion de una promocion para una proforma

    function Verifica_bonificacion_proforma ( Pv_Cia             IN  Varchar2,
                                              Pn_proforma        IN  Number,
                                              Pn_linea_proforma  IN  Number,
                                              Pn_sec_politica    IN  Number,
                                              Pn_linea_Politica  IN  Number,
                                              Pv_mensaje         OUT Varchar2) Return Boolean;


    --- Carga bonificacion en la linea de la proforma

    procedure Carga_Bonificacion_Proforma ( Pv_Cia            IN Varchar2,
                                            Pn_proforma       IN Number,
                                            Pn_Linea_proforma IN Number,
                                            Pn_sec_politica   IN Number,
                                            Pn_linea_Politica  IN Number,
                                            Pv_Error          OUT Varchar2);

    --- Elimina bonificacion en la linea de la proforma

    procedure Elimina_bonificacion_Proforma (Pv_Cia             IN Varchar2,
                                             Pn_proforma        IN Number,
                                             Pn_Linea_proforma  IN Number,
                                             Pn_sec_politica    IN Number,
                                             Pn_linea_Politica  IN Number);


   --- Verifica si un tipo de promocion ya existe en una proforma

    function Verifica_promocion_proforma (Pv_Cia            IN Varchar2,
                                          Pn_proforma       IN Number,
                                          Pn_linea_proforma IN Number,
                                          Pv_tipo_promocion IN Varchar2) return Boolean;


    --- Recalcula detalle de la proforma una vez actualizadas las promociones

    procedure recalcula_linea_Proforma (Pv_Cia            IN Varchar2,
                                        Pn_proforma       IN Number,
                                        Pn_Linea_proforma IN Number);

    --- Recalcula cabecera de la proforma una vez actualizadas las promociones

    procedure recalcula_cabecera_Proforma (Pv_Cia            IN Varchar2,
                                           Pn_proforma       IN Number);


  /*********************/
  /**** PEDIDOS *****/
  /*********************/

    --- Funcion que verifica si un pedido tiene o no promocion

    function Pedido_tiene_promocion (Pv_Cia IN Varchar2,
                                     Pv_pedido IN Varchar2,
                                     Pn_linea_pedido IN Number) return Boolean;

    --- Crea registros en la promocion de pedidos

    procedure Crea_promocion_pedido  (Pv_Cia            IN Varchar2,
                                      Pv_pedido         IN Varchar2,
                                      Pn_Linea_pedido   IN Number,
                                      Pn_sec_politica   IN Number,
                                      Pn_linea_Politica IN Number,
                                      Pv_Error          OUT Varchar2);

    --- Carga descuento en la linea de la pedidos

    procedure Carga_Descuento_Pedido  (Pv_Cia            IN Varchar2,
                                       Pv_pedido         IN Varchar2,
                                       Pn_Linea_pedido   IN Number,
                                       Pn_sec_politica   IN Number,
                                       Pn_linea_Politica IN Number);

    --- Elimina descuento en la linea del pedido

    procedure Elimina_Descuento_Pedido (Pv_Cia            IN Varchar2,
                                        Pv_pedido         IN Varchar2,
                                        Pn_Linea_pedido   IN Number,
                                        Pn_sec_politica   IN Number,
                                        Pn_linea_Politica IN Number);

    --- Carga precio en la linea del pedido

    procedure Carga_Precio_Pedido( Pv_Cia            IN Varchar2,
                                   Pv_pedido         IN Varchar2,
                                   Pn_Linea_pedido   IN Number,
                                   Pn_sec_politica   IN Number,
                                   Pn_linea_Politica IN Number);

    --- Elimina precio en la linea del pedido

    procedure Elimina_Precio_Pedido (Pv_Cia            IN Varchar2,
                                     Pv_pedido         IN Varchar2,
                                     Pn_Linea_pedido   IN Number,
                                     Pn_sec_politica   IN Number,
                                     Pn_linea_Politica IN Number);

    --- Verifica escalas de una promocion para un pedido

    function Verifica_escalas_pedido (Pv_Cia            IN  Varchar2,
                                      Pv_pedido         IN  Varchar2,
                                      Pn_linea_pedido   IN  Number,
                                      Pn_sec_politica   IN  Number,
                                      Pn_linea_Politica IN  Number,
                                      Pv_mensaje        OUT Varchar2) Return Boolean;

    --- Carga escala en la linea del pedido

    procedure Carga_Escala_Pedido (Pv_Cia            IN  Varchar2,
                                   Pv_pedido         IN  Varchar2,
                                   Pn_linea_pedido   IN  Number,
                                   Pn_sec_politica   IN Number,
                                   Pn_linea_Politica IN Number,
                                   Pv_Error          OUT Varchar2);

    --- Elimina escala en la linea del pedido

    procedure Elimina_Escala_Pedido (Pv_Cia             IN  Varchar2,
                                     Pv_pedido          IN  Varchar2);

    --- Verifica bonificacion de una promocion para un pedido

    function Verifica_bonificacion_pedido ( Pv_Cia             IN  Varchar2,
                                            Pv_pedido          IN  Varchar2,
                                            Pn_linea_pedido    IN  Number,
                                            Pn_sec_politica    IN  Number,
                                            Pn_linea_Politica  IN  Number,
                                            Pv_mensaje         OUT Varchar2) Return Boolean;
    --- Carga bonificacion en la linea del pedido

    procedure Carga_Bonificacion_Pedido (Pv_Cia             IN  Varchar2,
                                         Pv_pedido          IN  Varchar2,
                                         Pn_linea_pedido    IN  Number,
                                         Pn_sec_politica    IN Number,
                                         Pn_linea_Politica  IN Number,
                                         Pv_Error           OUT Varchar2);

    --- Elimina bonificacion en la linea del pedido

    procedure Elimina_bonificacion_Pedido ( Pv_Cia             IN  Varchar2,
                                            Pv_pedido          IN  Varchar2,
                                            Pn_linea_pedido    IN  Number,
                                            Pn_sec_politica    IN Number,
                                            Pn_linea_Politica  IN Number);

    --- Verifica si un tipo de promocion ya existe en una pedido

    function Verifica_promocion_pedido (Pv_Cia            IN Varchar2,
                                          Pn_pedido       IN Number,
                                          Pn_linea_pedido IN Number,
                                          Pv_tipo_promocion IN Varchar2) Return Boolean;

    --- Recalcula detalle del pedido una vez actualizadas las promociones

    procedure recalcula_linea_Pedido (Pv_Cia            IN  Varchar2,
                                      Pv_pedido         IN  Varchar2,
                                      Pn_linea_pedido   IN  Number);

   --- Recalcula cabecera del pedido una vez actualizadas las promociones

    procedure recalcula_cabecera_Pedido   (Pv_Cia            IN Varchar2,
                                           Pv_pedido         IN Varchar2);


  /**********************/
  /**** FACTURAS *******/
  /*********************/

    --- Funcion que verifica si una factura tiene o no promocion

    function factura_tiene_promocion (Pv_Cia IN Varchar2,
                                      Pv_factura IN Varchar2,
                                      Pn_linea_factura IN Number) return Boolean;

    --- Crea registros en la promocion de facturas

    procedure Crea_promocion_factura  (Pv_Cia            IN Varchar2,
                                       Pv_factura        IN Varchar2,
                                       Pn_Linea_factura  IN Number,
                                       Pn_sec_politica   IN Number,
                                       Pn_linea_Politica IN Number,
                                       Pv_Error          OUT Varchar2);

    --- Carga descuento en la linea de la facturas

    procedure Carga_Descuento_factura  (Pv_Cia            IN Varchar2,
                                        Pv_factura         IN Varchar2,
                                        Pn_Linea_factura   IN Number,
                                        Pn_sec_politica   IN Number,
                                        Pn_linea_Politica IN Number);

    --- Elimina descuento en la linea del factura

    procedure Elimina_Descuento_factura (Pv_Cia            IN Varchar2,
                                         Pv_factura         IN Varchar2,
                                         Pn_Linea_factura   IN Number,
                                         Pn_sec_politica   IN Number,
                                         Pn_linea_Politica IN Number);

    --- Carga precio en la linea de la factura

    procedure Carga_Precio_factura(Pv_Cia            IN Varchar2,
                                   Pv_factura        IN Varchar2,
                                   Pn_Linea_factura  IN Number,
                                   Pn_sec_politica   IN Number,
                                   Pn_linea_Politica IN Number);

    --- Elimina precio en la linea de la factura

    procedure Elimina_Precio_factura (Pv_Cia            IN Varchar2,
                                      Pv_factura        IN Varchar2,
                                      Pn_Linea_factura  IN Number,
                                      Pn_sec_politica   IN Number,
                                      Pn_linea_Politica IN Number);

    --- Verifica escalas de una promocion para una factura

    function Verifica_escalas_factura (Pv_Cia             IN  Varchar2,
                                       Pv_factura         IN  Varchar2,
                                       Pn_linea_factura   IN  Number,
                                       Pn_sec_politica    IN  Number,
                                       Pn_linea_Politica  IN  Number,
                                       Pv_mensaje         OUT Varchar2) Return Boolean;

    --- Carga escala en la linea de la factura

    procedure Carga_Escala_factura (Pv_Cia            IN  Varchar2,
                                    Pv_factura         IN  Varchar2,
                                    Pn_linea_factura   IN  Number,
                                    Pn_sec_politica   IN Number,
                                    Pn_linea_Politica IN Number,
                                    Pv_Error          OUT Varchar2);

    --- Elimina escala en la linea de la factura

    procedure Elimina_Escala_factura (Pv_Cia             IN  Varchar2,
                                      Pv_factura         IN  Varchar2);

    --- Verifica bonificacion de una promocion para una factura

    function Verifica_bonificacion_factura (Pv_Cia             IN  Varchar2,
                                            Pv_factura         IN  Varchar2,
                                            Pn_linea_factura   IN  Number,
                                            Pn_sec_politica    IN  Number,
                                            Pn_linea_Politica  IN  Number,
                                            Pv_mensaje         OUT Varchar2) Return Boolean;

    --- Carga bonificacion en la linea de la factura

    procedure Carga_Bonificacion_factura (Pv_Cia             IN  Varchar2,
                                          Pv_factura         IN  Varchar2,
                                          Pn_linea_factura   IN  Number,
                                          Pn_sec_politica    IN Number,
                                          Pn_linea_Politica  IN Number,
                                          Pv_Error           OUT Varchar2);

    --- Elimina bonificacion en la linea de la factura

    procedure Elimina_bonificacion_factura (Pv_Cia             IN  Varchar2,
                                            Pv_factura         IN  Varchar2,
                                            Pn_linea_factura   IN  Number,
                                            Pn_sec_politica    IN Number,
                                            Pn_linea_Politica  IN Number);

    --- Verifica si un tipo de promocion ya existe en una factura

    function Verifica_promocion_factura (Pv_Cia            IN Varchar2,
                                         Pv_factura        IN Varchar2,
                                         Pn_linea_factura  IN Number,
                                         Pv_tipo_promocion IN Varchar2) Return Boolean;

    --- Recalcula detalle de la factura una vez actualizadas las promociones

    procedure recalcula_linea_factura (Pv_Cia             IN  Varchar2,
                                       Pv_factura         IN  Varchar2,
                                       Pn_linea_factura   IN  Number);

   --- Recalcula cabecera de la factura una vez actualizadas las promociones

    procedure recalcula_cabecera_factura   (Pv_Cia            IN Varchar2,
                                            Pv_factura        IN Varchar2);

   procedure crea_pedido_con_rechazado
             (
               Pv_Cia     IN Varchar2,
               Pv_factu  IN Varchar2,
               pb_creo_detalle in out boolean,
               pv_factu_generado in out varchar2,
               pv_fisico_generado in out varchar2,
               pv_bit_descuento in out varchar2,
               pv_bit_margen in out varchar2,
               pv_bit_promocion in out varchar2,
               pv_error   in out varchar2
             );

   PROCEDURE valida_porc_descuento
          (
           pv_cia varchar2,
           pv_div_comercial varchar2,
           pv_grupo varchar2,
           pv_cliente varchar2,
           pv_subcliente varchar2,
           pd_fecha date,
           pv_centro varchar2,
           pv_arti varchar2,
           pv_division varchar2,
           pv_subdivision varchar2,
           pn_porc_desc number,
           pn_tope_descuento in out number,
           pv_msj in out varchar2,
           pb_graba in out boolean
         );

 FUNCTION verifica_escalas_totales
          (
           Pv_Cia             IN  Varchar2,
           Pv_pedido          IN  Varchar2,
	         Pn_sec_politica    IN  Number,
	         Pn_linea_Politica  IN  Number,
	         Pv_division_art    IN  Varchar2
         ) Return Boolean;

PROCEDURE pedido_tiene_escala
          (
           pv_cia varchar2,
           pv_centro varchar2,
           pv_div_comercial varchar2,
           pv_grupo varchar2,
           pv_cliente varchar2,
           pv_subcliente varchar2,
           pv_factu varchar2,
           pd_fecha date,
           pv_division in out varchar2,
           pv_subdivision in out varchar2,
           pn_secuencia in out number,
           pn_linea in out number,
           pn_porc in out number,
           pb_tiene in out boolean
         );

end FAPOLITICA_COMERCIAL;
/


CREATE OR REPLACE package body            FAPOLITICA_COMERCIAL is

  -- Function and procedure implementations

  /*********************/
  /**** PROFORMAS *****/
  /*********************/

    --- Funcion que verifica si una proforma tiene o no promocion

    function Proforma_tiene_promocion (Pv_Cia IN Varchar2,
                                       Pn_proforma IN Number,
                                       Pn_linea_proforma IN Number) return Boolean IS

    Cursor C_Prof Is
     select 'X'
     from   arfapromo_prof
     where  no_cia      = Pv_Cia
     and    no_proforma = Pn_proforma
     and    no_linea    = Pn_linea_proforma;

     Lv_dummy Varchar2(1);

     Begin
       Open C_Prof;
       Fetch C_prof into Lv_dummy;
       If C_Prof%notfound Then
       Close C_Prof;
       return (FALSE);
       else
       Close C_prof;
       return (TRUE);
       end if;
     End;

    --- Crea registros en la promocion de la proforma

    procedure Crea_promocion_proforma (Pv_Cia            IN Varchar2,
                                       Pn_proforma       IN Number,
                                       Pn_Linea_proforma IN Number,
                                       Pn_sec_politica   IN Number,
                                       Pn_linea_Politica  IN Number,
                                       Pv_Error          OUT Varchar2) Is


    Cursor C_Det_Politica Is
      select *
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Promocion Is
     select 'X'
     from   arfapromo_prof
     where  no_cia      = Pv_Cia
     and    no_proforma = Pn_proforma
     and    no_linea    = Pn_linea_proforma
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_politica;

    Lv_dummy Varchar2(1);

    DetPol arfadet_politica_comercial%rowtype;

    Begin

    Open  C_Det_Politica;
    Fetch C_Det_Politica into DetPol;
    If C_Det_Politica%notfound Then
     Close C_Det_Politica;
    else
     Close C_Det_Politica;
    end if;

       --- si existe la promocion no la vuelve a crear ANR 23/07/2009
       --- Esto se da para promociones tipo escala

    Open C_Promocion;
    Fetch C_Promocion into Lv_dummy;
    If C_Promocion%notfound Then
     Close C_Promocion;

    Begin
    Insert into arfapromo_prof (no_cia, no_proforma, no_linea, secuencia_politica,
                                linea_politica, tipo_promocion, porc_descuento, precio,
                                cant_minima, cant_maxima, unidades, arti_alterno)
                        Values (Pv_cia, Pn_proforma, Pn_linea_proforma, Pn_sec_politica,
                                Pn_linea_politica, DetPol.tipo_promocion, DetPol.porc_descuento, DetPol.precio,
                                DetPol.cant_minima, DetPol.cant_maxima, DetPol.unidades, DetPol.no_arti_alterno);
    Exception
    When Others Then
     Pv_Error := 'Error al crear la promocion. Proforma: '||Pn_proforma||' Linea Prof.: '||Pn_linea_proforma||' Polit: '||Pn_sec_politica||' Linea Polit.: '||Pn_linea_politica||' Tipo pro.: '||DetPol.tipo_promocion;
    End;

    else
     Close C_Promocion;
    end if;


    End;

    --- Carga descuento en la linea de la proforma

    procedure Carga_Descuento_Proforma (Pv_Cia            IN Varchar2,
                                        Pn_proforma       IN Number,
                                        Pn_Linea_proforma IN Number,
                                        Pn_sec_politica   IN Number,
                                        Pn_linea_Politica  IN Number) Is


    Cursor C_Det_Descuento Is
     select nvl(porc_descuento,0)
     from   arfapromo_prof
     where  no_cia      = Pv_Cia
     and    no_proforma = Pn_proforma
     and    no_linea    = Pn_Linea_Proforma
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'D';

    Ln_porc_desc arfapromo_prof.porc_descuento%type;

    Begin

    Open  C_Det_Descuento;
    Fetch C_Det_Descuento into Ln_Porc_Desc;
    If C_Det_Descuento%notfound Then
     Close C_Det_Descuento;
    else
     Close C_Det_Descuento;

      Update arfadetproform
      set    porc_desc   = Ln_porc_desc,
             descuento   = total * ((nvl(Ln_porc_desc,0) + nvl(descuento_adicional,0))/100)
      Where  no_cia      = Pv_Cia
      and    no_proforma = Pn_proforma
      and    no_linea    = Pn_Linea_proforma;

    end if;

    End;

    --- Elimina descuento en la linea de la proforma

    procedure Elimina_Descuento_Proforma (Pv_Cia            IN Varchar2,
                                          Pn_proforma       IN Number,
                                          Pn_Linea_proforma IN Number,
                                          Pn_sec_politica   IN Number,
                                          Pn_linea_Politica  IN Number) Is


    Cursor C_Det_Descuento Is
     select nvl(porc_descuento,0)
     from   arfapromo_prof
     where  no_cia      = Pv_Cia
     and    no_proforma = Pn_proforma
     and    no_linea    = Pn_Linea_Proforma
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'D';

    Ln_porc_desc arfapromo_prof.porc_descuento%type;

    Begin

    Open  C_Det_Descuento;
    Fetch C_Det_Descuento into Ln_Porc_Desc;
    If C_Det_Descuento%notfound Then
     Close C_Det_Descuento;
    else
     Close C_Det_Descuento;

      Update arfadetproform
      set    porc_desc   = 0,
             descuento_adicional = 0,
             descuento   = 0
      Where  no_cia      = Pv_Cia
      and    no_proforma = Pn_proforma
      and    no_linea    = Pn_Linea_proforma;

    end if;

    End;

    --- Carga precio en la linea de la proforma

    procedure Carga_Precio_Proforma ( Pv_Cia            IN Varchar2,
                                      Pn_proforma       IN Number,
                                      Pn_Linea_proforma IN Number,
                                      Pn_sec_politica   IN Number,
                                      Pn_linea_Politica  IN Number) Is


    Cursor C_Det_Precio Is
     select nvl(precio,0)
     from   arfapromo_prof
     where  no_cia      = Pv_Cia
     and    no_proforma = Pn_proforma
     and    no_linea    = Pn_Linea_Proforma
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'P';

    Ln_precio arfapromo_prof.precio%type;

    Begin

    Open  C_Det_Precio;
    Fetch C_Det_Precio into Ln_precio;
    If C_Det_Precio%notfound Then
     Close C_Det_Precio;
    else
     Close C_Det_Precio;

      Update arfadetproform
      set    precio = Ln_precio,
             total  = cantidad * Ln_precio,
             descuento   = total * ((nvl(porc_desc,0) + nvl(descuento_adicional,0))/100)
      Where  no_cia      = Pv_Cia
      and    no_proforma = Pn_proforma
      and    no_linea    = Pn_Linea_proforma;

    end if;

    End;

    --- Elimina precio en la linea de la proforma

    procedure Elimina_Precio_Proforma (Pv_Cia             IN Varchar2,
                                       Pn_proforma        IN Number,
                                       Pn_Linea_proforma  IN Number,
                                       Pn_sec_politica    IN Number,
                                       Pn_linea_Politica  IN Number) Is


    Cursor C_Det_precio Is
     select nvl(precio,0)
     from   arfapromo_prof
     where  no_cia      = Pv_Cia
     and    no_proforma = Pn_proforma
     and    no_linea    = Pn_Linea_Proforma
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'P';

    Ln_precio arfapromo_prof.precio%type;

    Begin

    Open  C_Det_precio;
    Fetch C_Det_precio into Ln_Precio;
    If C_Det_precio%notfound Then
     Close C_Det_precio;
    else
     Close C_Det_precio;

      Update arfadetproform
      set    precio = 0,
             total  = 0,
             i_ven_n = 0
      Where  no_cia      = Pv_Cia
      and    no_proforma = Pn_proforma
      and    no_linea    = Pn_Linea_proforma;

    end if;

    End;

    --- Verifica escalas de una promocion para una proforma

    function Verifica_escalas_proforma (Pv_Cia             IN  Varchar2,
                                        Pn_proforma        IN  Number,
                                        Pn_linea_proforma  IN  Number,
                                        Pn_sec_politica    IN  Number,
                                        Pn_linea_Politica  IN  Number,
                                        Pv_mensaje         OUT Varchar2) Return Boolean IS


    Cursor C_Verif Is
      select nvl(cant_minima,1) cant_minima, nvl(cant_maxima,999999999) cant_maxima --- si no tiene datos se asume que es para todas las cantidades ANR 02/10/2009
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Det_Proforma Is
     select a.cantidad
     from   arfadetproform a
     where  a.no_cia      = Pv_cia
     and    a.no_proforma = Pn_proforma
     and    a.no_linea    = Pn_linea_proforma;

    Ln_cant_minima   arfadet_politica_comercial.cant_minima%type;
    Ln_cant_maxima   arfadet_politica_comercial.cant_maxima%type;

    Ln_cantidad      arfadetproform.cantidad%type;

    Begin

    Open  C_Verif;
    Fetch C_Verif into Ln_cant_minima, Ln_cant_maxima;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;

        Open  C_Det_Proforma;
        Fetch C_Det_Proforma into Ln_cantidad;
        If C_Det_Proforma%notfound Then
         Close C_Det_Proforma;
         return (FALSE);
        else
         Close C_Det_Proforma;

         If Ln_cantidad Between Ln_cant_minima and Ln_cant_maxima Then
          return (TRUE);
         else
         Pv_mensaje := 'La cantidad: ' ||Ln_cantidad||' de la linea de la proforma no esta entre: '||Ln_cant_minima||' hasta '||Ln_cant_maxima||' . No se le puede dar la promocion';
          return (FALSE);
         end if;

        end if;

    end if;

    End;

    --- Carga escala en la linea de la proforma

    procedure Carga_Escala_Proforma ( Pv_Cia            IN Varchar2,
                                      Pn_proforma       IN Number,
                                      Pn_Linea_proforma IN Number,
                                      Pn_sec_politica   IN Number,
                                      Pn_linea_Politica  IN Number,
                                      Pv_Error          OUT Varchar2) Is


    Cursor C_Det_Escala Is
     select cant_minima, cant_maxima, unidades, arti_alterno
     from   arfapromo_prof
     where  no_cia      = Pv_Cia
     and    no_proforma = Pn_proforma
     and    no_linea    = Pn_Linea_Proforma
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'E';

    Cursor C_Det_Proforma Is
     select *
     from   arfadetproform
     where  no_cia = Pv_cia
     and    no_proforma = Pn_proforma
     and    no_linea = Pn_linea_proforma;

    Cursor C_Max_Linea_Det_Prof Is
     select max(no_linea) + 1
     from   arfadetproform
     where  no_cia = Pv_cia
     and    no_proforma = Pn_proforma;

    Cursor C_Articulo (Lv_Arti Varchar2) Is
     select clase, categoria
     from arinda
     where no_cia = Pv_Cia
     and no_arti  = Lv_Arti;

    Ln_minima       Arfapromo_Prof.cant_minima%type;
    Ln_maxima       Arfapromo_Prof.cant_maxima%type;
    Ln_unidades     Arfapromo_Prof.unidades%type;
    Lv_alterno      Arfapromo_Prof.arti_alterno%type;
    Ln_Ultima_Linea Arfapromo_prof.no_linea%type;

    Lv_clase        Arinda.clase%type;
    Lv_categoria    Arinda.categoria%type;

    Lv_Error        Varchar2(500);

    DetProf         C_Det_Proforma%rowtype;

    Error_Proceso   Exception;

    Begin

    Open C_Det_proforma;
    Fetch C_Det_proforma into DetProf;
    If C_Det_proforma%notfound Then
    Close C_Det_proforma;
     Lv_Error := 'No existe linea de proforma. Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea;
     raise Error_Proceso;
    else
    Close C_Det_proforma;
    end if;

    Open  C_Det_Escala;
    Fetch C_Det_Escala into Ln_minima, Ln_maxima, Ln_unidades, Lv_alterno;
    If C_Det_Escala%notfound Then
     Close C_Det_Escala;

    else
     Close C_Det_Escala;

     Open C_Max_Linea_Det_Prof;
     Fetch C_Max_Linea_Det_Prof into Ln_Ultima_linea;
     Close C_Max_Linea_Det_Prof;

     If Lv_alterno is null Then
        Lv_alterno := DetProf.no_arti;
     end if;

     Open C_Articulo (Lv_alterno);
     Fetch C_Articulo into Lv_clase, Lv_categoria;
     If C_Articulo%notfound Then
      Close C_Articulo;
     Lv_Error := 'No existe articulo: '||Lv_alterno||' Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea;
     raise Error_Proceso;
     else
      Close C_Articulo;
     end if;


     If DetProf.cantidad between Ln_minima and Ln_maxima Then

      Begin
      Insert into arfadetproform (no_cia, centrod, no_proforma, no_linea,
                                  bodega, clase, categoria,
                                  no_arti, cantidad, precio, descuento, total, i_ven,
                                  i_ven_n, tipo_precio, tipo_oferta,
                                  arti_ofe, cant_ofe, prot_ofe, imp_incluido,
                                  imp_especial, porc_desc, costo2,
                                  linea_art_promocion, margen_valor_prof, margen_minimo,
                                  margen_objetivo, margen_porc_prof, secuencia_politica, linea_politica)
                          Values (DetProf.no_cia, DetProf.centrod, DetProf.no_proforma, Ln_Ultima_linea,
                                  DetProf.bodega, Lv_clase, Lv_categoria,
                                  Lv_alterno, Ln_unidades, 0, 0, 0, 'N',
                                  0, Detprof.tipo_precio, null,
                                  null, null, null, 0,
                                  0, 0, 0,
                                  Pn_Linea_proforma, 0, 0,
                                  0, 0, Pn_sec_politica, Pn_linea_politica);

    Exception
    When Others then
     Lv_Error := 'Error al crear registro para la promocion de escalas. Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;
     raise Error_Proceso;
    End;

    End if;

    end if;

      Exception
      When Error_proceso Then
      Pv_Error := Lv_Error;
      When Others Then
      Pv_Error := 'Error a crear linea de proforma para escala. Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;

   End;

    --- Elimina escala en la linea de la proforma

    procedure Elimina_Escala_Proforma (Pv_Cia             IN Varchar2,
                                       Pn_proforma        IN Number) Is


    Begin

      Delete arfapromo_prof    --- Elimina las lineas de la proforma por escala
      Where  no_cia                 = Pv_Cia
      and    no_proforma            = Pn_proforma
      and    tipo_promocion         = 'E';


    End;

    --- Verifica bonificacion de una promocion para una proforma

    function Verifica_bonificacion_proforma ( Pv_Cia             IN  Varchar2,
                                              Pn_proforma        IN  Number,
                                              Pn_linea_proforma  IN  Number,
                                              Pn_sec_politica    IN  Number,
                                              Pn_linea_Politica  IN  Number,
                                              Pv_mensaje         OUT Varchar2) Return Boolean IS


    Cursor C_Verif Is
      select cant_minima
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Det_Proforma Is
     select a.cantidad
     from   arfadetproform a
     where  a.no_cia      = Pv_cia
     and    a.no_proforma = Pn_proforma
     and    a.no_linea    = Pn_linea_proforma;

    Ln_cant_minima   arfadet_politica_comercial.cant_minima%type;
    Ln_cantidad      arfadetproform.cantidad%type;

    Begin

    Open  C_Verif;
    Fetch C_Verif into Ln_cant_minima;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;

        Open  C_Det_Proforma;
        Fetch C_Det_Proforma into Ln_cantidad;
        If C_Det_Proforma%notfound Then
         Close C_Det_Proforma;
         return (FALSE);
        else
         Close C_Det_Proforma;

         If Ln_cantidad >= Ln_cant_minima Then
          return (TRUE);
         else
         Pv_mensaje := 'La cantidad: ' ||Ln_cantidad||' de la linea de la proforma debe ser mayor o igual a: '||Ln_cant_minima||' . No se le puede dar la promocion';
          return (FALSE);
         end if;

        end if;

    end if;

    End;

    --- Carga bonificacion en la linea de la proforma

    procedure Carga_Bonificacion_Proforma ( Pv_Cia            IN Varchar2,
                                            Pn_proforma       IN Number,
                                            Pn_Linea_proforma IN Number,
                                            Pn_sec_politica   IN Number,
                                            Pn_linea_Politica  IN Number,
                                            Pv_Error          OUT Varchar2) Is

    Cursor C_Det_Bonificacion Is
     select cant_minima, unidades, arti_alterno
     from   arfapromo_prof
     where  no_cia      = Pv_Cia
     and    no_proforma = Pn_proforma
     and    no_linea    = Pn_Linea_Proforma
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'B';

    Cursor C_Det_Proforma Is
     select *
     from   arfadetproform
     where  no_cia = Pv_cia
     and    no_proforma = Pn_proforma
     and    no_linea = Pn_linea_proforma;

    Cursor C_Max_Linea_Det_Prof Is
     select max(no_linea) + 1
     from   arfadetproform
     where  no_cia = Pv_cia
     and    no_proforma = Pn_proforma;

    Cursor C_Articulo (Lv_Arti Varchar2) Is
     select *
     from arinda
     where no_cia = Pv_Cia
     and no_arti  = Lv_Arti;

    Cursor C_Arintp (Lv_Arti Varchar2, Lv_tipo Varchar2) Is
    select precio
    from   arintp
    where  no_cia = Pv_cia
    and    codigo = Lv_Arti
    and    tipo   = Lv_tipo;

    Cursor C_Verif_precio_promocional (Lv_Arti Varchar2) Is
     select a.precio
     from   arfapromo_prof a, arfadetproform b
     where  a.no_cia      = Pv_cia
     and    a.no_proforma = Pn_proforma
     and    a.no_linea    = Pn_linea_proforma
     and    b.no_arti     = Lv_Arti
     and    a.tipo_promocion = 'P'
     and    a.no_cia      = b.no_cia
     and    a.no_proforma = b.no_proforma
     and    a.no_linea    = b.no_linea; --- Verifica si tiene precio promocional para ese precio asignarlo a la bonificacion ANR 02/10/2009

    Ln_minima       Arfapromo_Prof.cant_minima%type;
    Ln_unidades     Arfapromo_Prof.unidades%type;
    Lv_alterno      Arfapromo_Prof.arti_alterno%type;
    Ln_Ultima_Linea Arfapromo_prof.no_linea%type;

    DetArinda       Arinda%rowtype;

    Ln_valor_aplica Number :=0;

    Ln_precio       Number;

    Lv_Error        Varchar2(500);

    DetProf         C_Det_Proforma%rowtype;

    Error_Proceso   Exception;

    Begin

    Open C_Det_proforma;
    Fetch C_Det_proforma into DetProf;
    If C_Det_proforma%notfound Then
    Close C_Det_proforma;
     Lv_Error := 'No existe linea de proforma. Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea;
     raise Error_Proceso;
    else
    Close C_Det_proforma;
    end if;

    Open  C_Det_Bonificacion;
    Fetch C_Det_Bonificacion into Ln_minima, Ln_unidades, Lv_alterno;
    If C_Det_Bonificacion%notfound Then
     Close C_Det_Bonificacion;

    else
     Close C_Det_Bonificacion;

     Open C_Max_Linea_Det_Prof;
     Fetch C_Max_Linea_Det_Prof into Ln_Ultima_linea;
     Close C_Max_Linea_Det_Prof;

     If Ln_minima <= 0 Then
         Lv_Error := 'La cantidad minimima no puede ser menor o igual a cero, para la promocion de bonificaciones. Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;
         raise Error_Proceso;
     end if;

     Ln_valor_aplica := floor(DetProf.cantidad / Ln_minima);

     Ln_valor_aplica := Ln_valor_aplica * Ln_unidades;

     If Lv_alterno is null Then
        Lv_alterno := DetProf.no_arti;
     end if;

     Open C_Articulo (Lv_alterno);
     Fetch C_Articulo into DetArinda;
     If C_Articulo%notfound Then
      Close C_Articulo;
     Lv_Error := 'No existe articulo: '||Lv_alterno||' Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea;
     raise Error_Proceso;
     else
      Close C_Articulo;
     end if;

   --- Verifica si tiene precio promocional, si no tiene, asigna el precio de lista
   Open C_Verif_precio_promocional (Lv_Alterno);
   Fetch C_Verif_precio_promocional into Ln_precio;
   If C_Verif_precio_promocional%notfound Then
    Close C_Verif_precio_promocional;

          Open C_Arintp (Lv_alterno, DetProf.tipo_precio);
          Fetch C_Arintp into Ln_precio;
          If C_Arintp%notfound Then
           Close C_Arintp;
          else
           Close C_Arintp;
          end if;

   else
    Close C_Verif_precio_promocional;
   end if;

    If Ln_valor_aplica > 0 Then

      Begin
      Insert into arfadetproform (no_cia, centrod, no_proforma, no_linea,
                                  bodega, clase, categoria,
                                  no_arti, cantidad, precio, descuento, total, i_ven,
                                  i_ven_n, tipo_precio, tipo_oferta,
                                  arti_ofe, cant_ofe, prot_ofe, imp_incluido,
                                  imp_especial, porc_desc, costo2,
                                  linea_art_promocion, margen_valor_prof, margen_minimo,
                                  margen_objetivo, margen_porc_prof, secuencia_politica, linea_politica)
                          Values (DetProf.no_cia, DetProf.centrod, DetProf.no_proforma, Ln_Ultima_linea,
                                  DetProf.bodega, DetArinda.clase, DetArinda.categoria,
                                  Lv_alterno, Ln_valor_aplica, Ln_precio, (Ln_valor_aplica * Ln_precio), (Ln_valor_aplica * Ln_precio), 'S',
                                  0, Detprof.tipo_precio, null,
                                  null, null, null, 0,
                                  0, 100, DetArinda.costo2_unitario,
                                  Pn_Linea_proforma, 0, 0,
                                  0,0, Pn_sec_politica, Pn_linea_politica); --- se aplica el 100%

    Exception
    When Others then
     Lv_Error := 'Error al crear registro para la promocion de bonificaciones. Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;
     raise Error_Proceso;
    End;

    End if;

    end if;

      Exception
      When Error_proceso Then
      Pv_Error := Lv_Error;
      When Others Then
      Pv_Error := 'Error a crear linea de proforma para bonificaciones. Proforma: '||DetProf.no_proforma||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;

   End;

    --- Elimina bonificacion en la linea de la proforma

    procedure Elimina_bonificacion_Proforma (Pv_Cia             IN Varchar2,
                                             Pn_proforma        IN Number,
                                             Pn_Linea_proforma  IN Number,
                                             Pn_sec_politica    IN Number,
                                             Pn_linea_Politica  IN Number) Is


    Cursor C_Det_Bonificacion Is
     select 'X'
     from   arfapromo_prof
     where  no_cia             = Pv_Cia
     and    no_proforma        = Pn_proforma
     and    no_linea           = Pn_Linea_Proforma
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica     = Pn_linea_Politica
     and    tipo_promocion     = 'B';

    Lv_dummy Varchar2(1);

    Begin

    Open  C_Det_Bonificacion;
    Fetch C_Det_Bonificacion into Lv_dummy;
    If C_Det_Bonificacion%notfound Then
     Close C_Det_Bonificacion;
    else
     Close C_Det_Bonificacion;

      Delete arfadetproform    --- Elimina la promocion en la linea de la factura
      Where  no_cia                 = Pv_Cia
      and    no_proforma            = Pn_proforma
      and    linea_art_promocion    = Pn_Linea_proforma
      and    secuencia_politica     = Pn_sec_politica
      and    linea_politica         = Pn_linea_politica;

    end if;

    End;

    --- Verifica si un tipo de promocion ya existe en una proforma

    function Verifica_promocion_proforma (Pv_Cia            IN Varchar2,
                                          Pn_proforma       IN Number,
                                          Pn_linea_proforma IN Number,
                                          Pv_tipo_promocion IN Varchar2) Return Boolean IS


    Cursor C_Verif Is
     select 'X'
     from   arfapromo_prof
     where  no_cia         = Pv_Cia
     and    no_proforma    = Pn_proforma
     and    no_linea       = Pn_Linea_Proforma
     and    tipo_promocion = Pv_tipo_promocion;

    Lv_Dummy Varchar2(1);

    Begin

    Open  C_Verif;
    Fetch C_Verif into Lv_dummy;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;
     return (TRUE);
    end if;

    End;

    --- Recalcula detalle de la proforma una vez actualizadas las promociones

    procedure recalcula_linea_Proforma (Pv_Cia            IN Varchar2,
                                        Pn_proforma       IN Number,
                                        Pn_Linea_proforma IN Number) Is

    Cursor C_Det_Proforma Is
     select a.no_proforma, b.fecha, nvl(a.total,0) total, nvl(a.descuento,0) descuento, a.no_arti,
            nvl(a.i_ven,'N') i_ven, b.grupo, b.no_cliente,
            a.no_linea, a.linea_art_promocion, a.costo2, a.cantidad
     from   arfadetproform a, arfaencproform b
     where  a.no_cia = Pv_cia
     and    a.no_proforma = Pn_proforma
     and    a.no_linea = Pn_linea_proforma
     and    a.no_cia = b.no_cia
     and    a.no_proforma = b.no_proforma;

   Cursor C_Imp_Arti (Lv_articulo Varchar2) Is
    select clave
    from   arinia
    where  no_cia = Pv_cia
    and    no_arti = Lv_articulo
    and    afecta_venta = 'S';

  --- Recupera si el articulo tiene marcado impuesto para ventas
   Cursor C_Arti (Lv_articulo Varchar2) Is
    select nvl(imp_ven,'N') imp_ven
    from   arinda
    where  no_cia = Pv_cia
    and    no_arti = Lv_articulo;

  --- Recupera si el cliente esta excento de impuestos
   Cursor C_Cliente (Lv_grupo Varchar2, Lv_cliente Varchar2) Is
    select nvl(excento_imp,'N') excento_imp
    from   arccmc
    where  no_cia = Pv_cia
    and    grupo  = Lv_grupo
    and    no_cliente = Lv_cliente;

    --- Se agrega para el recalculo del margen ANR 08/02/2010

    Cursor C_Cant_Bonif (Ln_proforma Number, Ln_linea Number) Is
     select nvl(cantidad,0) + nvl(cantidad_adicional,0) cantidad_bonificacion
     from   arfadetproform
     where  no_cia = Pv_cia
     and    no_proforma = Ln_proforma
     and    linea_art_promocion = Ln_linea;

    Ln_margen_valor_prof Arfadetproform.Margen_Valor_prof%type;
    Ln_cant_bonif Number := 0;

    Ln_base     Number := 0;
    Ln_Imp      Number := 0;
    Ln_Impuesto Number := 0;

    Lv_imp_arti    Arinda.imp_ven%type;
    Lv_excento_cli Arccmc.Excento_Imp%type;

    Begin

    For i in C_Det_Proforma Loop

      Ln_base := i.total - i.descuento;

      For imp in C_Imp_Arti (i.no_arti) Loop

        Open C_Arti (i.no_arti);
        Fetch C_Arti into Lv_imp_arti;
        If C_Arti%notfound Then
         Close C_Arti;
         Lv_imp_arti := 'N';
        else
         Close C_Arti;
        end if;

        If i.grupo is not null and i.no_cliente is not null Then
            Open C_Cliente(i.grupo, i.no_cliente);
            Fetch C_Cliente into Lv_excento_cli;
            If C_Cliente%notfound Then
             Close C_Cliente;
             Lv_excento_cli := 'N';
            else
             Close C_Cliente;
            end if;
        else
            Lv_excento_cli := 'N';
        end if;

        If Lv_imp_arti = 'S' and Lv_excento_cli = 'N' Then
            Ln_Imp := Impuesto.calcula(Pv_cia, imp.clave, Ln_base, null, 1, i.fecha);
            Ln_Impuesto := Ln_impuesto + nvl(Ln_imp,0);
        else
            Ln_Impuesto := 0;
        end if;

      End Loop;

    --- Se agrega para el recalculo del margen ANR 08/02/2010

     Open C_Cant_Bonif (i.no_proforma, i.no_linea);
     Fetch C_Cant_Bonif into Ln_Cant_bonif;
     If C_Cant_Bonif%notfound Then
       Close C_Cant_Bonif;
       Ln_Cant_bonif := 0;
       else
       Close C_Cant_Bonif;
     end if;

     If i.linea_art_promocion is null Then
      Ln_margen_valor_prof := (Ln_base)-(nvl(i.costo2,0) * (nvl(i.cantidad,0) + nvl(Ln_cant_bonif,0)));
     else
      Ln_margen_valor_prof := 0;
     end if;

      Update arfadetproform
      set    i_ven_n = decode(i.i_ven,'N',0,Ln_impuesto),
             margen_valor_prof = Ln_margen_valor_prof,
             margen_porc_prof = nvl(Ln_margen_valor_prof,0)/(decode(Ln_base,0,1,Ln_base))*100
      Where  no_cia      = Pv_Cia
      and    no_proforma = Pn_proforma
      and    no_linea    = Pn_Linea_proforma;

    End Loop;

    End;

   --- Recalcula cabecera de la proforma una vez actualizadas las promociones

    procedure recalcula_cabecera_Proforma (Pv_Cia            IN Varchar2,
                                           Pn_proforma       IN Number) Is

    Cursor C_Cab_Proforma Is
     select nvl(sum(a.total),0) total_bruto,
            nvl(sum(a.descuento),0) descuento,
            nvl(sum(a.i_ven_n),0) impuesto
     from   arfadetproform a
     where  a.no_cia      = Pv_cia
     and    a.no_proforma = Pn_proforma;

    Begin

    For i in C_Cab_Proforma Loop

      Update arfaencproform
      set    tot_lin = i.total_bruto,
             sub_total = i.total_bruto - i.descuento,
             descuento = i.descuento,
             impuesto  = i.impuesto,
             total     = i.total_bruto - i.descuento + i.impuesto
      Where  no_cia      = Pv_Cia
      and    no_proforma = Pn_proforma;

    End Loop;

    End;


  /*********************/
  /**** PEDIDOS *****/
  /*********************/

    --- Funcion que verifica si un pedido tiene o no promocion

    function Pedido_tiene_promocion (Pv_Cia IN Varchar2,
                                     Pv_pedido IN Varchar2,
                                     Pn_linea_pedido IN Number) return Boolean IS

    Cursor C_Ped Is
     select 'X'
     from   arfapromo_flc
     where  no_cia      = Pv_Cia
     and    no_pedido   = Pv_pedido
     and    no_linea    = Pn_linea_pedido;

     Lv_dummy Varchar2(1);

     Begin
       Open C_Ped;
       Fetch C_Ped into Lv_dummy;
       If C_Ped%notfound Then
       Close C_Ped;
       return (FALSE);
       else
       Close C_Ped;
       return (TRUE);
       end if;
     End;

    --- Crea registros en la promocion de pedidos

    procedure Crea_promocion_pedido  (Pv_Cia            IN Varchar2,
                                      Pv_pedido         IN Varchar2,
                                      Pn_Linea_pedido   IN Number,
                                      Pn_sec_politica   IN Number,
                                      Pn_linea_Politica IN Number,
                                      Pv_Error          OUT Varchar2) Is


    Cursor C_Det_Politica Is
      select *
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Promocion Is
     select 'X'
     from   arfapromo_flc
     where  no_cia      = Pv_Cia
     and    no_pedido   = Pv_pedido
     and    no_linea    = Pn_linea_pedido
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_politica;

    Lv_dummy Varchar2(1);
    DetPol   arfadet_politica_comercial%rowtype;

    Begin

    Open  C_Det_Politica;
    Fetch C_Det_Politica into DetPol;
    If C_Det_Politica%notfound Then
     Close C_Det_Politica;
    else
     Close C_Det_Politica;
    end if;

    --- si existe la promocion no la vuelve a crear ANR 23/07/2009
    --- Esto se da para promociones tipo escala

    Open C_Promocion;
    Fetch C_Promocion into Lv_dummy;
    If C_Promocion%notfound Then
     Close C_Promocion;


     Begin
        Insert into arfapromo_flc (no_cia, no_pedido, no_linea, secuencia_politica,
                                  linea_politica, tipo_promocion, porc_descuento, precio,
                                  cant_minima, cant_maxima, unidades, arti_alterno)
                          Values (Pv_cia, Pv_pedido, Pn_linea_pedido, Pn_sec_politica,
                                  Pn_linea_politica, DetPol.tipo_promocion, DetPol.porc_descuento, DetPol.precio,
                                  DetPol.cant_minima, DetPol.cant_maxima, DetPol.unidades, DetPol.no_arti_alterno);
      Exception
      When Others Then
       Pv_Error := 'Error al crear la promocion. pedido: '||Pv_pedido||' Linea Prof.: '||Pn_linea_pedido||' Polit: '||Pn_sec_politica||' Linea Polit.: '||Pn_linea_politica||' Tipo pro.: '||DetPol.tipo_promocion;
      End;

    else
     Close C_Promocion;
    end if;

    End;


    --- Carga descuento en la linea de la pedidos

    procedure Carga_Descuento_Pedido  (Pv_Cia            IN Varchar2,
                                       Pv_pedido         IN Varchar2,
                                       Pn_Linea_pedido   IN Number,
                                       Pn_sec_politica   IN Number,
                                       Pn_linea_Politica IN Number) Is


    Cursor C_Det_Descuento Is
     select nvl(porc_descuento,0)
     from   arfapromo_flc
     where  no_cia      = Pv_Cia
     and    no_pedido = Pv_pedido
     and    no_linea    = Pn_Linea_Pedido
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'D';

    Ln_porc_desc arfapromo_flc.porc_descuento%type;

    Begin

    Open  C_Det_Descuento;
    Fetch C_Det_Descuento into Ln_Porc_Desc;
    If C_Det_Descuento%notfound Then
     Close C_Det_Descuento;
    else
     Close C_Det_Descuento;

      Update arfaflc
      set    porc_desc   = Ln_porc_desc,
             descuento   = total * ((nvl(Ln_porc_desc,0) + nvl(descuento_adicional,0))/100)
      Where  no_cia      = Pv_Cia
      and    no_factu    = Pv_pedido
      and    no_linea    = Pn_Linea_pedido;

    end if;

    End;

    --- Elimina descuento en la linea del pedido

    procedure Elimina_Descuento_Pedido (Pv_Cia            IN Varchar2,
                                        Pv_pedido         IN Varchar2,
                                        Pn_Linea_pedido   IN Number,
                                        Pn_sec_politica   IN Number,
                                        Pn_linea_Politica IN Number) Is


    Cursor C_Det_Descuento Is
     select nvl(porc_descuento,0)
     from   arfapromo_flc
     where  no_cia      = Pv_Cia
     and    no_pedido   = Pv_pedido
     and    no_linea    = Pn_Linea_pedido
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'D';

    Ln_porc_desc arfapromo_flc.porc_descuento%type;

    Begin

    Open  C_Det_Descuento;
    Fetch C_Det_Descuento into Ln_Porc_Desc;
    If C_Det_Descuento%notfound Then
     Close C_Det_Descuento;
    else
     Close C_Det_Descuento;

      Update arfaflc
      set    porc_desc   = 0,
             descuento_adicional = 0,
             descuento   = 0
      Where  no_cia      = Pv_Cia
      and    no_factu    = Pv_pedido
      and    no_linea    = Pn_Linea_pedido;

    end if;

    End;

    --- Carga precio en la linea del pedido

    procedure Carga_Precio_Pedido( Pv_Cia            IN Varchar2,
                                   Pv_pedido         IN Varchar2,
                                   Pn_Linea_pedido   IN Number,
                                   Pn_sec_politica   IN Number,
                                   Pn_linea_Politica IN Number) Is


    Cursor C_Det_Precio Is
     select nvl(precio,0)
     from   arfapromo_flc
     where  no_cia      = Pv_Cia
     and    no_pedido   = Pv_pedido
     and    no_linea    = Pn_Linea_pedido
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'P';

    Ln_precio arfapromo_flc.precio%type;

    Begin

    Open  C_Det_Precio;
    Fetch C_Det_Precio into Ln_precio;
    If C_Det_Precio%notfound Then
     Close C_Det_Precio;
    else
     Close C_Det_Precio;

      Update arfaflc
      set    precio = Ln_precio,
             total  = pedido * Ln_precio,
             descuento   = total * ((nvl(porc_desc,0) + nvl(descuento_adicional,0))/100)
      Where  no_cia      = Pv_Cia
      and    no_factu   = Pv_pedido
      and    no_linea    = Pn_Linea_pedido;

    end if;

    End;

    --- Elimina precio en la linea del pedido

    procedure Elimina_Precio_Pedido (Pv_Cia            IN Varchar2,
                                     Pv_pedido         IN Varchar2,
                                     Pn_Linea_pedido   IN Number,
                                     Pn_sec_politica   IN Number,
                                     Pn_linea_Politica IN Number) Is


    Cursor C_Det_precio Is
     select nvl(precio,0)
     from   arfapromo_flc
     where  no_cia      = Pv_Cia
     and    no_pedido   = Pv_pedido
     and    no_linea    = Pn_Linea_pedido
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'P';

    Ln_precio arfapromo_flc.precio%type;

    Begin

    Open  C_Det_precio;
    Fetch C_Det_precio into Ln_Precio;
    If C_Det_precio%notfound Then
     Close C_Det_precio;
    else
     Close C_Det_precio;

      Update arfaflc
      set    precio = 0,
             total  = 0,
             i_ven_n = 0
      Where  no_cia      = Pv_Cia
      and    no_factu    = Pv_pedido
      and    no_linea    = Pn_Linea_pedido;

    end if;

    End;

    --- Verifica escalas de una promocion para un pedido

    function Verifica_escalas_pedido (Pv_Cia            IN  Varchar2,
                                      Pv_pedido         IN  Varchar2,
                                      Pn_linea_pedido   IN  Number,
                                      Pn_sec_politica   IN  Number,
                                      Pn_linea_Politica IN  Number,
                                      Pv_mensaje        OUT Varchar2) Return Boolean IS


    Cursor C_Verif Is
      select nvl(cant_minima,1) cant_minima, nvl(cant_maxima,999999999) cant_maxima --- si no tiene datos se asume que es para todas las cantidades ANR 02/10/2009
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Det_pedido Is
     select a.pedido
     from   arfaflc a
     where  a.no_cia      = Pv_cia
     and    a.no_factu    = Pv_pedido
     and    a.no_linea    = Pn_linea_pedido;

    Ln_cant_minima   arfadet_politica_comercial.cant_minima%type;
    Ln_cant_maxima   arfadet_politica_comercial.cant_maxima%type;

    Ln_cantidad      arfaflc.pedido%type;

    Begin

    Open  C_Verif;
    Fetch C_Verif into Ln_cant_minima, Ln_cant_maxima;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;

        Open  C_Det_pedido;
        Fetch C_Det_pedido into Ln_cantidad;
        If C_Det_pedido%notfound Then
         Close C_Det_pedido;
         return (FALSE);
        else
         Close C_Det_pedido;

         If Ln_cantidad Between Ln_cant_minima and Ln_cant_maxima Then
          return (TRUE);
         else
         Pv_mensaje := 'La cantidad: ' ||Ln_cantidad||' de la linea de la pedido no esta entre: '||Ln_cant_minima||' hasta '||Ln_cant_maxima||' . No se le puede dar la promocion';
          return (FALSE);
         end if;

        end if;

    end if;

    End;

    --- Carga escala en la linea del pedido

    procedure Carga_Escala_Pedido (Pv_Cia            IN  Varchar2,
                                   Pv_pedido         IN  Varchar2,
                                   Pn_linea_pedido   IN  Number,
                                   Pn_sec_politica   IN Number,
                                   Pn_linea_Politica IN Number,
                                   Pv_Error          OUT Varchar2) Is


    Cursor C_Det_Escala Is
     select cant_minima, cant_maxima, unidades, arti_alterno
     from   arfapromo_flc
     where  no_cia      = Pv_Cia
     and    no_pedido   = Pv_pedido
     and    no_linea    = Pn_Linea_pedido
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'E';

    Cursor C_Det_pedido Is
     select *
     from   arfaflc
     where  no_cia    = Pv_cia
     and    no_factu  = Pv_pedido
     and    no_linea  = Pn_linea_pedido;

    Cursor C_Max_Linea_Det_Prof Is
     select max(no_linea) + 1
     from   arfaflc
     where  no_cia    = Pv_cia
     and    no_factu = Pv_pedido;

    Cursor C_Articulo (Lv_Arti Varchar2) Is
     select clase, categoria
     from arinda
     where no_cia = Pv_Cia
     and no_arti  = Lv_Arti;

    Lv_clase        Arinda.clase%type;
    Lv_categoria    Arinda.categoria%type;

    Ln_minima       arfapromo_flc.cant_minima%type;
    Ln_maxima       arfapromo_flc.cant_maxima%type;
    Ln_unidades     arfapromo_flc.unidades%type;
    Lv_alterno      arfapromo_flc.arti_alterno%type;
    Ln_Ultima_Linea arfapromo_flc.no_linea%type;

    Lv_Error        Varchar2(500);

    DetProf         C_Det_pedido%rowtype;

    Error_Proceso   Exception;

    Begin

    Open C_Det_pedido;
    Fetch C_Det_pedido into DetProf;
    If C_Det_pedido%notfound Then
    Close C_Det_pedido;
     Lv_Error := 'No existe linea de pedido. pedido: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea;
     raise Error_Proceso;
    else
    Close C_Det_pedido;
    end if;

    Open  C_Det_Escala;
    Fetch C_Det_Escala into Ln_minima, Ln_maxima, Ln_unidades, Lv_alterno;
    If C_Det_Escala%notfound Then
     Close C_Det_Escala;

    else
     Close C_Det_Escala;

     Open C_Max_Linea_Det_Prof;
     Fetch C_Max_Linea_Det_Prof into Ln_Ultima_linea;
     Close C_Max_Linea_Det_Prof;

     If Lv_alterno is null Then
        Lv_alterno := DetProf.no_arti;
     end if;

     Open C_Articulo (Lv_alterno);
     Fetch C_Articulo into Lv_clase, Lv_categoria;
     If C_Articulo%notfound Then
      Close C_Articulo;
     Lv_Error := 'No existe articulo: '||Lv_alterno||' pedido: '||DetProf.no_factu||' Linea ped.: '||Ln_Ultima_linea;
     raise Error_Proceso;
     else
      Close C_Articulo;
     end if;

     If DetProf.pedido between Ln_minima and Ln_maxima Then

      Begin
      Insert into arfaflc (no_cia, centrod, no_factu, no_linea, periodo,
                          bodega, clase, categoria,
                          no_arti, pedido, precio, descuento, total, i_ven,
                          i_ven_n, tipo_precio, tipo_oferta,
                          arti_ofe, cant_ofe, prot_ofe, imp_incluido,
                          imp_especial, porc_desc, costo2,
                          linea_art_promocion, margen_valor_flc, margen_minimo,
                          margen_objetivo, margen_porc_flc, secuencia_politica, linea_politica)
                  Values (DetProf.no_cia, DetProf.centrod, DetProf.no_factu, Ln_Ultima_linea, Detprof.periodo,
                          DetProf.bodega, DetProf.clase, DetProf.categoria,
                          nvl(lv_alterno,DetProf.no_arti), Ln_unidades, 0, 0, 0, 'N',
                          0, Detprof.tipo_precio, null,
                          null, null, null, 0,
                          0, 0, 0,
                          Pn_Linea_pedido, 0, 0,
                          0, 0, Pn_sec_politica, Pn_linea_politica);

    Exception
    When Others then
     Lv_Error := 'Error al crear registro para la promocion de escalas. pedido: '||DetProf.no_factu||' Linea ped.: '||Ln_Ultima_linea||' '||sqlerrm;
     raise Error_Proceso;
    End;

    End if;

    end if;

      Exception
      When Error_proceso Then
      Pv_Error := Lv_Error;
      When Others Then
      Pv_Error := 'Error a crear linea de pedido para escala. pedido: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;

   End;

    --- Elimina escala en la linea del pedido

    procedure Elimina_Escala_Pedido (Pv_Cia             IN  Varchar2,
                                     Pv_pedido          IN  Varchar2) Is

    Begin

      Delete arfapromo_flc    --- Elimina la promocion de las lineas de pedido
      Where  no_cia                 = Pv_Cia
      and    no_pedido              = Pv_pedido
      and    tipo_promocion         = 'E';

    End;

    --- Verifica bonificacion de una promocion para un pedido

    function Verifica_bonificacion_pedido ( Pv_Cia             IN  Varchar2,
                                            Pv_pedido          IN  Varchar2,
                                            Pn_linea_pedido    IN  Number,
                                            Pn_sec_politica    IN  Number,
                                            Pn_linea_Politica  IN  Number,
                                            Pv_mensaje         OUT Varchar2) Return Boolean IS


    Cursor C_Verif Is
      select cant_minima
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Det_pedido Is
     select a.pedido
     from   arfaflc a
     where  a.no_cia      = Pv_cia
     and    a.no_factu    = Pv_pedido
     and    a.no_linea    = Pn_linea_pedido;

    Ln_cant_minima   arfadet_politica_comercial.cant_minima%type;
    Ln_cantidad      arfaflc.pedido%type;

    Begin

    Open  C_Verif;
    Fetch C_Verif into Ln_cant_minima;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;

        Open  C_Det_pedido;
        Fetch C_Det_pedido into Ln_cantidad;
        If C_Det_pedido%notfound Then
         Close C_Det_pedido;
         return (FALSE);
        else
         Close C_Det_pedido;

         If Ln_cantidad >= Ln_cant_minima Then
          return (TRUE);
         else
         Pv_mensaje := 'La cantidad: ' ||Ln_cantidad||' de la linea de la pedido debe ser mayor o igual a: '||Ln_cant_minima||' . No se le puede dar la promocion';
          return (FALSE);
         end if;

        end if;

    end if;

    End;

    --- Carga bonificacion en la linea del pedido

    procedure Carga_Bonificacion_Pedido (Pv_Cia             IN  Varchar2,
                                         Pv_pedido          IN  Varchar2,
                                         Pn_linea_pedido    IN  Number,
                                         Pn_sec_politica    IN Number,
                                         Pn_linea_Politica  IN Number,
                                         Pv_Error           OUT Varchar2) Is

    Cursor C_Det_Bonificacion Is
     select cant_minima, unidades, arti_alterno
     from   arfapromo_flc
     where  no_cia      = Pv_Cia
     and    no_pedido   = Pv_pedido
     and    no_linea    = Pn_Linea_pedido
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'B';

    Cursor C_Det_pedido Is
     select *
     from   arfaflc
     where  no_cia    = Pv_cia
     and    no_factu  = Pv_pedido
     and    no_linea  = Pn_linea_pedido;

    Cursor C_Max_Linea_Det_Prof Is
     select max(no_linea) + 1
     from   arfaflc
     where  no_cia    = Pv_cia
     and    no_factu  = Pv_pedido;

    Cursor C_Articulo (Lv_Arti Varchar2) Is
     select *
     from arinda
     where no_cia = Pv_Cia
     and no_arti  = Lv_Arti;

    Cursor C_Arintp (Lv_Arti Varchar2, Lv_tipo Varchar2) Is
    select precio
    from   arintp
    where  no_cia = Pv_cia
    and    codigo = Lv_Arti
    and    tipo   = Lv_tipo;

    Cursor C_Verif_precio_promocional (Lv_Arti Varchar2) Is
     select a.precio
     from   arfapromo_flc a, arfaflc b
     where  a.no_cia      = Pv_cia
     and    a.no_pedido = Pv_pedido
     and    a.no_linea    = Pn_linea_pedido
     and    b.no_arti     = Lv_Arti
     and    a.tipo_promocion = 'P'
     and    a.no_cia      = b.no_cia
     and    a.no_pedido   = b.no_factu
     and    a.no_linea    = b.no_linea; --- Verifica si tiene precio promocional para ese precio asignarlo a la bonificacion ANR 02/10/2009

    Ln_minima       arfapromo_flc.cant_minima%type;
    Ln_unidades     arfapromo_flc.unidades%type;
    Lv_alterno      arfapromo_flc.arti_alterno%type;
    Ln_Ultima_Linea arfapromo_flc.no_linea%type;

    Ln_valor_aplica Number :=0;

    DetArinda       Arinda%rowtype;
    Ln_precio       Number;

    Lv_Error        Varchar2(500);

    DetProf         C_Det_pedido%rowtype;

    Error_Proceso   Exception;

    Begin

    Open C_Det_pedido;
    Fetch C_Det_pedido into DetProf;
    If C_Det_pedido%notfound Then
    Close C_Det_pedido;
     Lv_Error := 'No existe linea de pedido. pedido: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea;
     raise Error_Proceso;
    else
    Close C_Det_pedido;
    end if;

    Open  C_Det_Bonificacion;
    Fetch C_Det_Bonificacion into Ln_minima, Ln_unidades, Lv_alterno;
    If C_Det_Bonificacion%notfound Then
     Close C_Det_Bonificacion;

    else
     Close C_Det_Bonificacion;

     Open C_Max_Linea_Det_Prof;
     Fetch C_Max_Linea_Det_Prof into Ln_Ultima_linea;
     Close C_Max_Linea_Det_Prof;

     If Ln_minima <= 0 Then
         Lv_Error := 'La cantidad minimima no puede ser menor o igual a cero, para la promocion de bonificaciones. pedido: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;
         raise Error_Proceso;
     end if;

     Ln_valor_aplica := floor(DetProf.pedido / Ln_minima);

     Ln_valor_aplica := Ln_valor_aplica * Ln_unidades;

     If Lv_alterno is null Then
        Lv_alterno := DetProf.no_arti;
     end if;

     Open C_Articulo (Lv_alterno);
     Fetch C_Articulo into DetArinda;
     If C_Articulo%notfound Then
      Close C_Articulo;
     Lv_Error := 'No existe articulo: '||Lv_alterno||' pedido: '||DetProf.no_factu||' Linea ped.: '||Ln_Ultima_linea;
     raise Error_Proceso;
     else
      Close C_Articulo;
     end if;

   --- Verifica si tiene precio promocional, si no tiene, asigna el precio de lista
   Open C_Verif_precio_promocional (Lv_Alterno);
   Fetch C_Verif_precio_promocional into Ln_precio;
   If C_Verif_precio_promocional%notfound Then
    Close C_Verif_precio_promocional;

          Open C_Arintp (Lv_alterno, DetProf.tipo_precio);
          Fetch C_Arintp into Ln_precio;
          If C_Arintp%notfound Then
           Close C_Arintp;
          else
           Close C_Arintp;
          end if;

   else
    Close C_Verif_precio_promocional;
   end if;

    If Ln_valor_aplica > 0 Then

      Begin
      Insert into arfaflc (no_cia, centrod, no_factu, no_linea, periodo,
                                  bodega, clase, categoria,
                                  no_arti, pedido, precio, descuento, total, i_ven,
                                  i_ven_n, tipo_precio, tipo_oferta,
                                  arti_ofe, cant_ofe, prot_ofe, imp_incluido,
                                  imp_especial, porc_desc, costo2,
                                  linea_art_promocion, margen_valor_flc, margen_minimo,
                                  margen_objetivo, margen_porc_flc, secuencia_politica, linea_politica)
                          Values (DetProf.no_cia, DetProf.centrod, DetProf.no_factu, Ln_Ultima_linea, Detprof.periodo,
                                  DetProf.bodega, DetArinda.clase, DetArinda.categoria,
                                  Lv_alterno, Ln_valor_aplica,  Ln_precio, (Ln_valor_aplica * Ln_precio), (Ln_valor_aplica * Ln_precio), 'S',
                                  0, Detprof.tipo_precio, null,
                                  null, null, null, 0,
                                  0, 100, DetArinda.costo2_unitario,
                                  Pn_Linea_pedido, 0, 0,
                                  0, 0, Pn_sec_politica, Pn_linea_politica);  --- se aplica el 100%

    Exception
    When Others then
     Lv_Error := 'Error al crear registro para la promocion de bonificaciones. pedido: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;
     raise Error_Proceso;
    End;

    End if;

    end if;

      Exception
      When Error_proceso Then
      Pv_Error := Lv_Error;
      When Others Then
      Pv_Error := 'Error a crear linea de pedido para bonificaciones. pedido: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;

   End;

    --- Elimina bonificacion en la linea del pedido

    procedure Elimina_bonificacion_Pedido ( Pv_Cia             IN  Varchar2,
                                            Pv_pedido          IN  Varchar2,
                                            Pn_linea_pedido    IN  Number,
                                            Pn_sec_politica    IN Number,
                                            Pn_linea_Politica  IN Number) Is


    Cursor C_Det_Bonificacion Is
     select 'X'
     from   arfapromo_flc
     where  no_cia             = Pv_Cia
     and    no_pedido          = Pv_pedido
     and    no_linea           = Pn_Linea_pedido
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica     = Pn_linea_Politica
     and    tipo_promocion     = 'B';

    Lv_dummy Varchar2(1);

    Begin

    Open  C_Det_Bonificacion;
    Fetch C_Det_Bonificacion into Lv_dummy;
    If C_Det_Bonificacion%notfound Then
     Close C_Det_Bonificacion;
    else
     Close C_Det_Bonificacion;

      Delete arfaflc    --- Elimina la promocion en la linea de la factura
      Where  no_cia                 = Pv_Cia
      and    no_factu               = Pv_pedido
      and    linea_art_promocion    = Pn_Linea_pedido
      and    secuencia_politica     = Pn_sec_politica
      and    linea_politica         = Pn_linea_politica;

    end if;

    End;

    --- Verifica si un tipo de promocion ya existe en una pedido

    function Verifica_promocion_pedido (Pv_Cia            IN Varchar2,
                                          Pn_pedido       IN Number,
                                          Pn_linea_pedido IN Number,
                                          Pv_tipo_promocion IN Varchar2) Return Boolean IS


    Cursor C_Verif Is
     select 'X'
     from   arfapromo_flc
     where  no_cia         = Pv_Cia
     and    no_pedido    = Pn_pedido
     and    no_linea       = Pn_Linea_pedido
     and    tipo_promocion = Pv_tipo_promocion;

    Lv_Dummy Varchar2(1);

    Begin

    Open  C_Verif;
    Fetch C_Verif into Lv_dummy;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;
     return (TRUE);
    end if;

    End;

    --- Recalcula detalle del pedido una vez actualizadas las promociones

    procedure recalcula_linea_Pedido (Pv_Cia            IN  Varchar2,
                                      Pv_pedido         IN  Varchar2,
                                      Pn_linea_pedido   IN  Number) Is

    Cursor C_Det_pedido Is
     select a.no_factu, b.fecha,
            nvl(a.total,0) total, nvl(a.descuento,0) descuento, a.no_arti,
            nvl(a.i_ven,'N') i_ven, b.grupo, b.no_cliente,
            a.no_linea, a.linea_art_promocion, a.costo2, a.pedido
     from   arfaflc a, arfafec b
     where  a.no_cia = Pv_cia
     and    a.no_factu = Pv_pedido
     and    a.no_linea = Pn_linea_pedido
     and    a.no_cia = b.no_cia
     and    a.no_factu = b.no_factu;

   Cursor C_Imp_Arti (Lv_articulo Varchar2) Is
    select clave
    from   arinia
    where  no_cia = Pv_cia
    and    no_arti = Lv_articulo
    and    afecta_venta = 'S';

  --- Recupera si el articulo tiene marcado impuesto para ventas
   Cursor C_Arti (Lv_articulo Varchar2) Is
    select nvl(imp_ven,'N') imp_ven
    from   arinda
    where  no_cia = Pv_cia
    and    no_arti = Lv_articulo;

  --- Recupera si el cliente esta excento de impuestos
   Cursor C_Cliente (Lv_grupo Varchar2, Lv_cliente Varchar2) Is
    select nvl(excento_imp,'N') excento_imp
    from   arccmc
    where  no_cia = Pv_cia
    and    grupo  = Lv_grupo
    and    no_cliente = Lv_cliente;

    --- Se agrega para el recalculo del margen ANR 08/02/2010

    Cursor C_Cant_Bonif (Lv_factu Varchar2, Ln_linea Number) Is
     select nvl(pedido,0) + nvl(cantidad_adicional,0) cantidad_bonificacion
     from   arfaflc
     where  no_cia = Pv_cia
     and    no_factu = Lv_factu
     and    linea_art_promocion = Ln_linea;

    Ln_margen_valor_flc Arfaflc.Margen_Valor_Flc%type;
    Ln_cant_bonif Number := 0;

    Ln_base     Number := 0;
    Ln_Imp      Number := 0;
    Ln_Impuesto Number := 0;

    Lv_imp_arti    Arinda.imp_ven%type;
    Lv_excento_cli Arccmc.Excento_Imp%type;

    Begin

    For i in C_Det_pedido Loop

      Ln_base := i.total - i.descuento;

     For imp in C_Imp_Arti (i.no_arti) Loop

        Open C_Arti (i.no_arti);
        Fetch C_Arti into Lv_imp_arti;
        If C_Arti%notfound Then
         Close C_Arti;
         Lv_imp_arti := 'N';
        else
         Close C_Arti;
        end if;

        Open C_Cliente(i.grupo, i.no_cliente);
        Fetch C_Cliente into Lv_excento_cli;
        If C_Cliente%notfound Then
         Close C_Cliente;
         Lv_excento_cli := 'N';
        else
         Close C_Cliente;
        end if;

        If Lv_imp_arti = 'S' and Lv_excento_cli = 'N' Then
            Ln_Imp := Impuesto.calcula(Pv_cia, imp.clave, Ln_base, null, 1, i.fecha);
            Ln_Impuesto := Ln_impuesto + nvl(Ln_imp,0);
        else
            Ln_Impuesto := 0;
        end if;

      End Loop;

    --- Se agrega para el recalculo del margen ANR 08/02/2010

     Open C_Cant_Bonif (i.no_factu, i.no_linea);
     Fetch C_Cant_Bonif into Ln_Cant_bonif;
     If C_Cant_Bonif%notfound Then
       Close C_Cant_Bonif;
       Ln_Cant_bonif := 0;
       else
       Close C_Cant_Bonif;
     end if;

     If i.linea_art_promocion is null Then
      Ln_margen_valor_flc := (Ln_base)-(nvl(i.costo2,0) * (nvl(i.pedido,0) + nvl(Ln_cant_bonif,0)));
     else
      Ln_margen_valor_flc := 0;
     end if;

      Update arfaflc
      set    i_ven_n = decode(i.i_ven,'N',0,Ln_impuesto),
             margen_valor_flc = Ln_margen_valor_flc,
             margen_porc_flc = nvl(Ln_margen_valor_flc,0)/(decode(Ln_base,0,1,Ln_base))*100
      Where  no_cia      = Pv_Cia
      and    no_factu    = Pv_pedido
      and    no_linea    = Pn_Linea_pedido;

    End Loop;

    End;

   --- Recalcula cabecera del pedido una vez actualizadas las promociones

    procedure recalcula_cabecera_Pedido   (Pv_Cia            IN Varchar2,
                                           Pv_pedido         IN Varchar2) Is

    Cursor C_Cab_pedido Is
      select nvl(sum(a.total),0) total_bruto,
            nvl(sum(a.descuento),0) descuento,
            nvl(sum(a.i_ven_n),0) impuesto
     from   arfaflc a
     where  a.no_cia      = Pv_cia
     and    a.no_factu    = Pv_pedido;

    Begin

    For i in C_Cab_pedido Loop

      Update arfafec
      set    tot_lin = i.total_bruto,
             sub_total = i.total_bruto - i.descuento,
             descuento = i.descuento,
             impuesto  = i.impuesto,
             total     = i.total_bruto - i.descuento + i.impuesto
      Where  no_cia    = Pv_Cia
      and    no_factu  = Pv_pedido;

    End Loop;

    End;

  /**********************/
  /**** FACTURAS *******/
  /*********************/

    --- Funcion que verifica si un factura tiene o no promocion

    function factura_tiene_promocion (Pv_Cia IN Varchar2,
                                      Pv_factura IN Varchar2,
                                      Pn_linea_factura IN Number) return Boolean IS

    Cursor C_Ped Is
     select 'X'
     from   arfapromo_fl
     where  no_cia      = Pv_Cia
     and    no_factu    = Pv_factura
     and    no_linea    = Pn_linea_factura;

     Lv_dummy Varchar2(1);

     Begin
       Open C_Ped;
       Fetch C_Ped into Lv_dummy;
       If C_Ped%notfound Then
       Close C_Ped;
        return (FALSE);
       else
       Close C_Ped;
        return (TRUE);
       end if;
     End;

    --- Crea registros en la promocion de las facturas

    procedure Crea_promocion_factura  (Pv_Cia            IN Varchar2,
                                       Pv_factura        IN Varchar2,
                                       Pn_Linea_factura  IN Number,
                                       Pn_sec_politica   IN Number,
                                       Pn_linea_Politica IN Number,
                                       Pv_Error          OUT Varchar2) Is


    Cursor C_Det_Politica Is
      select *
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Promocion Is
     select 'X'
     from   arfapromo_fl
     where  no_cia      = Pv_Cia
     and    no_factu    = Pv_factura
     and    no_linea    = Pn_linea_factura
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_politica;

    Lv_dummy Varchar2(1);
    DetPol   arfadet_politica_comercial%rowtype;

    Begin

    Open  C_Det_Politica;
    Fetch C_Det_Politica into DetPol;
    If C_Det_Politica%notfound Then
     Close C_Det_Politica;
    else
     Close C_Det_Politica;
    end if;

    --- si existe la promocion no la vuelve a crear ANR 23/07/2009
    --- Esto se da para promociones tipo escala

    Open C_Promocion;
    Fetch C_Promocion into Lv_dummy;
    If C_Promocion%notfound Then
     Close C_Promocion;

     Begin
        Insert into arfapromo_fl (no_cia, no_factu, no_linea, secuencia_politica,
                                  linea_politica, tipo_promocion, porc_descuento, precio,
                                  cant_minima, cant_maxima, unidades, arti_alterno)
                          Values (Pv_cia, Pv_factura, Pn_linea_factura, Pn_sec_politica,
                                  Pn_linea_politica, DetPol.tipo_promocion, DetPol.porc_descuento, DetPol.precio,
                                  DetPol.cant_minima, DetPol.cant_maxima, DetPol.unidades, DetPol.no_arti_alterno);
      Exception
      When Others Then
       Pv_Error := 'Error al crear la promocion. factura: '||Pv_factura||' Linea Prof.: '||Pn_linea_factura||' Polit: '||Pn_sec_politica||' Linea Polit.: '||Pn_linea_politica||' Tipo pro.: '||DetPol.tipo_promocion;
      End;

    else
     Close C_Promocion;
    end if;

    End;


    --- Carga descuento en la linea de las facturas

    procedure Carga_Descuento_factura  (Pv_Cia            IN Varchar2,
                                        Pv_factura        IN Varchar2,
                                        Pn_Linea_factura  IN Number,
                                        Pn_sec_politica   IN Number,
                                        Pn_linea_Politica IN Number) Is


    Cursor C_Det_Descuento Is
     select nvl(porc_descuento,0)
     from   arfapromo_fl
     where  no_cia      = Pv_Cia
     and    no_factu    = Pv_factura
     and    no_linea    = Pn_Linea_factura
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'D';

    Ln_porc_desc arfapromo_fl.porc_descuento%type;

    Begin

    Open  C_Det_Descuento;
    Fetch C_Det_Descuento into Ln_Porc_Desc;
    If C_Det_Descuento%notfound Then
     Close C_Det_Descuento;
    else
     Close C_Det_Descuento;

      Update arfafl
      set    porc_desc   = Ln_porc_desc,
             descuento   = total * nvl(Ln_porc_desc,0)/100
      Where  no_cia      = Pv_Cia
      and    no_factu    = Pv_factura
      and    no_linea    = Pn_Linea_factura;

    end if;

    End;

    --- Elimina descuento en la linea de la factura

    procedure Elimina_Descuento_factura (Pv_Cia            IN Varchar2,
                                         Pv_factura        IN Varchar2,
                                         Pn_Linea_factura  IN Number,
                                         Pn_sec_politica   IN Number,
                                         Pn_linea_Politica IN Number) Is


    Cursor C_Det_Descuento Is
     select nvl(porc_descuento,0)
     from   arfapromo_fl
     where  no_cia      = Pv_Cia
     and    no_factu    = Pv_factura
     and    no_linea    = Pn_Linea_factura
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'D';

    Ln_porc_desc arfapromo_fl.porc_descuento%type;

    Begin

    Open  C_Det_Descuento;
    Fetch C_Det_Descuento into Ln_Porc_Desc;
    If C_Det_Descuento%notfound Then
     Close C_Det_Descuento;
    else
     Close C_Det_Descuento;

      Update arfafl
      set    porc_desc   = 0,
             descuento   = 0
      Where  no_cia      = Pv_Cia
      and    no_factu    = Pv_factura
      and    no_linea    = Pn_Linea_factura;

    end if;

    End;

    --- Carga precio en la linea de la factura

    procedure Carga_Precio_factura(Pv_Cia            IN Varchar2,
                                   Pv_factura         IN Varchar2,
                                   Pn_Linea_factura   IN Number,
                                   Pn_sec_politica   IN Number,
                                   Pn_linea_Politica IN Number) Is


    Cursor C_Det_Precio Is
     select nvl(precio,0)
     from   arfapromo_fl
     where  no_cia      = Pv_Cia
     and    no_factu    = Pv_factura
     and    no_linea    = Pn_Linea_factura
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'P';

    Ln_precio arfapromo_fl.precio%type;

    Begin

    Open  C_Det_Precio;
    Fetch C_Det_Precio into Ln_precio;
    If C_Det_Precio%notfound Then
     Close C_Det_Precio;
    else
     Close C_Det_Precio;

      Update arfafl
      set    precio = Ln_precio,
             total  = pedido * Ln_precio,
             descuento   = (total * nvl(porc_desc,0))/100
      Where  no_cia      = Pv_Cia
      and    no_factu   = Pv_factura
      and    no_linea    = Pn_Linea_factura;

    end if;

    End;

    --- Elimina precio en la linea de la factura

    procedure Elimina_Precio_factura (Pv_Cia            IN Varchar2,
                                      Pv_factura         IN Varchar2,
                                      Pn_Linea_factura   IN Number,
                                      Pn_sec_politica   IN Number,
                                      Pn_linea_Politica IN Number) Is


    Cursor C_Det_precio Is
     select nvl(precio,0)
     from   arfapromo_fl
     where  no_cia      = Pv_Cia
     and    no_factu    = Pv_factura
     and    no_linea    = Pn_Linea_factura
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'P';

    Ln_precio arfapromo_fl.precio%type;

    Begin

    Open  C_Det_precio;
    Fetch C_Det_precio into Ln_Precio;
    If C_Det_precio%notfound Then
     Close C_Det_precio;
    else
     Close C_Det_precio;

      Update arfafl
      set    precio = 0,
             total  = 0,
             i_ven_n = 0
      Where  no_cia      = Pv_Cia
      and    no_factu    = Pv_factura
      and    no_linea    = Pn_Linea_factura;

    end if;

    End;

    --- Verifica escalas de una promocion para una factura

    function Verifica_escalas_factura (Pv_Cia            IN  Varchar2,
                                       Pv_factura         IN  Varchar2,
                                       Pn_linea_factura   IN  Number,
                                       Pn_sec_politica   IN  Number,
                                       Pn_linea_Politica IN  Number,
                                       Pv_mensaje        OUT Varchar2) Return Boolean IS


    Cursor C_Verif Is
      select nvl(cant_minima,1) cant_minima, nvl(cant_maxima,999999999) cant_maxima --- si no tiene datos se asume que es para todas las cantidades ANR 02/10/2009
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Det_factura Is
     select a.pedido
     from   arfafl a
     where  a.no_cia      = Pv_cia
     and    a.no_factu    = Pv_factura
     and    a.no_linea    = Pn_linea_factura;

    Ln_cant_minima   arfadet_politica_comercial.cant_minima%type;
    Ln_cant_maxima   arfadet_politica_comercial.cant_maxima%type;

    Ln_cantidad      arfafl.pedido%type;

    Begin

    Open  C_Verif;
    Fetch C_Verif into Ln_cant_minima, Ln_cant_maxima;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;

        Open  C_Det_factura;
        Fetch C_Det_factura into Ln_cantidad;
        If C_Det_factura%notfound Then
         Close C_Det_factura;
         return (FALSE);
        else
         Close C_Det_factura;

         If Ln_cantidad Between Ln_cant_minima and Ln_cant_maxima Then
          return (TRUE);
         else
         Pv_mensaje := 'La cantidad: ' ||Ln_cantidad||' de la linea de la factura no esta entre: '||Ln_cant_minima||' hasta '||Ln_cant_maxima||' . No se le puede dar la promocion';
          return (FALSE);
         end if;

        end if;

    end if;

    End;

    --- Carga escala en la linea de la factura

    procedure Carga_Escala_factura (Pv_Cia            IN  Varchar2,
                                    Pv_factura        IN  Varchar2,
                                    Pn_linea_factura  IN  Number,
                                    Pn_sec_politica   IN Number,
                                    Pn_linea_Politica IN Number,
                                    Pv_Error          OUT Varchar2) Is


    Cursor C_Det_Escala Is
     select cant_minima, cant_maxima, unidades, arti_alterno
     from   arfapromo_fl
     where  no_cia      = Pv_Cia
     and    no_factu    = Pv_factura
     and    no_linea    = Pn_Linea_factura
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'E';

    Cursor C_Det_factura Is
     select *
     from   arfafl
     where  no_cia    = Pv_cia
     and    no_factu  = Pv_factura
     and    no_linea  = Pn_linea_factura;

    Cursor C_Max_Linea_Det_Prof Is
     select max(no_linea) + 1
     from   arfafl
     where  no_cia    = Pv_cia
     and    no_factu = Pv_factura;

    Cursor C_Articulo (Lv_Arti Varchar2) Is
     select *
     from arinda
     where no_cia = Pv_Cia
     and no_arti  = Lv_Arti;

    Ln_minima       arfapromo_fl.cant_minima%type;
    Ln_maxima       arfapromo_fl.cant_maxima%type;
    Ln_unidades     arfapromo_fl.unidades%type;
    Lv_alterno      arfapromo_fl.arti_alterno%type;
    Ln_Ultima_Linea arfapromo_fl.no_linea%type;

    DetArinda       Arinda%rowtype;

    Lv_Error        Varchar2(500);

    DetProf         C_Det_factura%rowtype;

    Error_Proceso   Exception;

    Begin

    Open C_Det_factura;
    Fetch C_Det_factura into DetProf;
    If C_Det_factura%notfound Then
    Close C_Det_factura;
     Lv_Error := 'No existe linea de factura. factura: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea;
     raise Error_Proceso;
    else
    Close C_Det_factura;
    end if;

    Open  C_Det_Escala;
    Fetch C_Det_Escala into Ln_minima, Ln_maxima, Ln_unidades, Lv_alterno;
    If C_Det_Escala%notfound Then
     Close C_Det_Escala;

    else
     Close C_Det_Escala;

     Open C_Max_Linea_Det_Prof;
     Fetch C_Max_Linea_Det_Prof into Ln_Ultima_linea;
     Close C_Max_Linea_Det_Prof;

     If Lv_alterno is null Then
        Lv_alterno := DetProf.no_arti;
     end if;

     Open C_Articulo (Lv_alterno);
     Fetch C_Articulo into DetArinda;
     If C_Articulo%notfound Then
      Close C_Articulo;
     Lv_Error := 'No existe articulo: '||Lv_alterno||' factura: '||DetProf.no_factu||' Linea ped.: '||Ln_Ultima_linea;
     raise Error_Proceso;
     else
      Close C_Articulo;
     end if;

     If DetProf.pedido between Ln_minima and Ln_maxima Then

      Begin
      Insert into arfafl (no_cia, centrod, no_factu, no_linea, periodo, tipo_doc, ruta,
                          bodega, clase, categoria,
                          no_arti, pedido, precio, descuento, total, i_ven,
                          i_ven_n, tipo_precio, tipo_oferta,
                          arti_ofe, cant_ofe, prot_ofe, imp_incluido,
                          imp_especial, porc_desc, costo2, costo,
                          linea_art_promocion, margen_valor_fl, margen_minimo,
                          margen_objetivo, margen_porc_fl, secuencia_politica, linea_politica)
                  Values (DetProf.no_cia, DetProf.centrod, DetProf.no_factu, Ln_Ultima_linea, Detprof.periodo, Detprof.tipo_doc, Detprof.ruta,
                          DetProf.bodega, DetProf.clase, DetProf.categoria,
                          nvl(lv_alterno,DetProf.no_arti), Ln_unidades, 0, 0, 0, 'N',
                          0, Detprof.tipo_precio, null,
                          null, null, null, 0,
                          0, 0, DetArinda.costo2_unitario, DetArinda.costo_unitario,
                          Pn_Linea_factura, 0, 0,
                          0, 0, Pn_sec_politica, Pn_linea_politica);

    Exception
    When Others then
     Lv_Error := 'Error al crear registro para la promocion de escalas. factura: '||DetProf.no_factu||' Linea ped.: '||Ln_Ultima_linea||' '||sqlerrm;
     raise Error_Proceso;
    End;

    End if;

    end if;

      Exception
      When Error_proceso Then
      Pv_Error := Lv_Error;
      When Others Then
      Pv_Error := 'Error a crear linea de factura para escala. factura: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;

   End;

    --- Elimina escala en la linea de la factura

    procedure Elimina_Escala_factura (Pv_Cia             IN  Varchar2,
                                      Pv_factura         IN  Varchar2) Is


    Begin

      Delete arfapromo_fl    --- Elimina la promocion de las lineas de la factura
      Where  no_cia                 = Pv_Cia
      and    no_factu               = Pv_factura
      and    tipo_promocion         = 'E';

    End;


    --- Verifica bonificacion de una promocion para una factura

    function Verifica_bonificacion_factura (Pv_Cia             IN  Varchar2,
                                            Pv_factura          IN  Varchar2,
                                            Pn_linea_factura    IN  Number,
                                            Pn_sec_politica    IN  Number,
                                            Pn_linea_Politica  IN  Number,
                                            Pv_mensaje         OUT Varchar2) Return Boolean IS


    Cursor C_Verif Is
      select cant_minima
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

    Cursor C_Det_factura Is
     select a.pedido
     from   arfafl a
     where  a.no_cia      = Pv_cia
     and    a.no_factu    = Pv_factura
     and    a.no_linea    = Pn_linea_factura;

    Ln_cant_minima   arfadet_politica_comercial.cant_minima%type;
    Ln_cantidad      arfafl.pedido%type;

    Begin

    Open  C_Verif;
    Fetch C_Verif into Ln_cant_minima;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;

        Open  C_Det_factura;
        Fetch C_Det_factura into Ln_cantidad;
        If C_Det_factura%notfound Then
         Close C_Det_factura;
         return (FALSE);
        else
         Close C_Det_factura;

         If Ln_cantidad >= Ln_cant_minima Then
          return (TRUE);
         else
         Pv_mensaje := 'La cantidad: ' ||Ln_cantidad||' de la linea de la factura debe ser mayor o igual a: '||Ln_cant_minima||' . No se le puede dar la promocion';
          return (FALSE);
         end if;

        end if;

    end if;

    End;

    --- Carga bonificacion en la linea de la factura

    procedure Carga_Bonificacion_factura (Pv_Cia             IN  Varchar2,
                                          Pv_factura         IN  Varchar2,
                                          Pn_linea_factura   IN  Number,
                                          Pn_sec_politica    IN Number,
                                          Pn_linea_Politica  IN Number,
                                          Pv_Error           OUT Varchar2) Is

    Cursor C_Det_Bonificacion Is
     select cant_minima, unidades, arti_alterno
     from   arfapromo_fl
     where  no_cia      = Pv_Cia
     and    no_factu    = Pv_factura
     and    no_linea    = Pn_Linea_factura
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica = Pn_linea_Politica
     and    tipo_promocion = 'B';

    Cursor C_Det_factura Is
     select *
     from   arfafl
     where  no_cia    = Pv_cia
     and    no_factu  = Pv_factura
     and    no_linea  = Pn_linea_factura;

    Cursor C_Max_Linea_Det_Prof Is
     select max(no_linea) + 1
     from   arfafl
     where  no_cia    = Pv_cia
     and    no_factu  = Pv_factura;

    Cursor C_Articulo (Lv_Arti Varchar2) Is
     select *
     from arinda
     where no_cia = Pv_Cia
     and no_arti  = Lv_Arti;

    Cursor C_Arintp (Lv_Arti Varchar2, Lv_tipo Varchar2) Is
    select precio
    from   arintp
    where  no_cia = Pv_cia
    and    codigo = Lv_Arti
    and    tipo   = Lv_tipo;

    Cursor C_Verif_precio_promocional (Lv_Arti Varchar2) Is
     select a.precio
     from   arfapromo_fl a, arfafl b
     where  a.no_cia      = Pv_cia
     and    a.no_factu    = Pv_factura
     and    a.no_linea    = Pn_linea_factura
     and    b.no_arti     = Lv_Arti
     and    a.tipo_promocion = 'P'
     and    a.no_cia      = b.no_cia
     and    a.no_factu    = b.no_factu
     and    a.no_linea    = b.no_linea; --- Verifica si tiene precio promocional para ese precio asignarlo a la bonificacion ANR 02/10/2009


    Ln_minima       arfapromo_fl.cant_minima%type;
    Ln_unidades     arfapromo_fl.unidades%type;
    Lv_alterno      arfapromo_fl.arti_alterno%type;
    Ln_Ultima_Linea arfapromo_fl.no_linea%type;

    Ln_valor_aplica Number :=0;

    DetArinda       Arinda%rowtype;
    Ln_precio       Number;

    Lv_Error        Varchar2(500);

    DetProf         C_Det_factura%rowtype;

    Error_Proceso   Exception;

    Begin

    Open C_Det_factura;
    Fetch C_Det_factura into DetProf;
    If C_Det_factura%notfound Then
    Close C_Det_factura;
     Lv_Error := 'No existe linea de factura. factura: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea;
     raise Error_Proceso;
    else
    Close C_Det_factura;
    end if;

    Open  C_Det_Bonificacion;
    Fetch C_Det_Bonificacion into Ln_minima, Ln_unidades, Lv_alterno;
    If C_Det_Bonificacion%notfound Then
     Close C_Det_Bonificacion;

    else
     Close C_Det_Bonificacion;

     Open C_Max_Linea_Det_Prof;
     Fetch C_Max_Linea_Det_Prof into Ln_Ultima_linea;
     Close C_Max_Linea_Det_Prof;

     If Ln_minima <= 0 Then
         Lv_Error := 'La cantidad minimima no puede ser menor o igual a cero, para la promocion de bonificaciones. factura: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;
         raise Error_Proceso;
     end if;

     Ln_valor_aplica := floor(DetProf.pedido / Ln_minima);

     Ln_valor_aplica := Ln_valor_aplica * Ln_unidades;

     If Lv_alterno is null Then
        Lv_alterno := DetProf.no_arti;
     end if;

     Open C_Articulo (Lv_alterno);
     Fetch C_Articulo into DetArinda;
     If C_Articulo%notfound Then
      Close C_Articulo;
     Lv_Error := 'No existe articulo: '||Lv_alterno||' factura: '||DetProf.no_factu||' Linea ped.: '||Ln_Ultima_linea;
     raise Error_Proceso;
     else
      Close C_Articulo;
     end if;

   --- Verifica si tiene precio promocional, si no tiene, asigna el precio de lista
   Open C_Verif_precio_promocional (Lv_Alterno);
   Fetch C_Verif_precio_promocional into Ln_precio;
   If C_Verif_precio_promocional%notfound Then
    Close C_Verif_precio_promocional;

          Open C_Arintp (Lv_alterno, DetProf.tipo_precio);
          Fetch C_Arintp into Ln_precio;
          If C_Arintp%notfound Then
           Close C_Arintp;
          else
           Close C_Arintp;
          end if;

   else
    Close C_Verif_precio_promocional;
   end if;

    If Ln_valor_aplica > 0 Then

      Begin
      Insert into arfafl (no_cia, centrod, no_factu, no_linea, periodo, tipo_doc, ruta,
                                  bodega, clase, categoria,
                                  no_arti, pedido, precio, descuento, total, i_ven,
                                  i_ven_n, tipo_precio, tipo_oferta,
                                  arti_ofe, cant_ofe, prot_ofe, imp_incluido,
                                  imp_especial, porc_desc, costo2, costo,
                                  linea_art_promocion, margen_valor_fl, margen_minimo,
                                  margen_objetivo, margen_porc_fl, secuencia_politica, linea_politica)
                          Values (DetProf.no_cia, DetProf.centrod, DetProf.no_factu, Ln_Ultima_linea, Detprof.periodo, Detprof.tipo_doc, Detprof.ruta,
                                  DetProf.bodega, DetArinda.clase, DetArinda.categoria,
                                  Lv_alterno, Ln_valor_aplica,  Ln_precio, (Ln_valor_aplica * Ln_precio), (Ln_valor_aplica * Ln_precio), 'S',
                                  0, Detprof.tipo_precio, null,
                                  null, null, null, 0,
                                  0, 100, DetArinda.costo2_unitario, DetArinda.costo_unitario,
                                  Pn_Linea_factura, 0, 0,
                                  0, 0, Pn_sec_politica, Pn_linea_politica);  --- se aplica el 100%

    Exception
    When Others then
     Lv_Error := 'Error al crear registro para la promocion de bonificaciones. factura: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;
     raise Error_Proceso;
    End;

    End if;

    end if;

      Exception
      When Error_proceso Then
      Pv_Error := Lv_Error;
      When Others Then
      Pv_Error := 'Error a crear linea de factura para bonificaciones. factura: '||DetProf.no_factu||' Linea prof.: '||Ln_Ultima_linea||' '||sqlerrm;

   End;

    --- Elimina bonificacion en la linea de la factura

    procedure Elimina_bonificacion_factura (Pv_Cia             IN  Varchar2,
                                            Pv_factura          IN  Varchar2,
                                            Pn_linea_factura    IN  Number,
                                            Pn_sec_politica    IN Number,
                                            Pn_linea_Politica  IN Number) Is


    Cursor C_Det_Bonificacion Is
     select 'X'
     from   arfapromo_fl
     where  no_cia             = Pv_Cia
     and    no_factu           = Pv_factura
     and    no_linea           = Pn_Linea_factura
     and    secuencia_politica = Pn_sec_politica
     and    linea_politica     = Pn_linea_Politica
     and    tipo_promocion     = 'B';

    Lv_dummy Varchar2(1);

    Begin

    Open  C_Det_Bonificacion;
    Fetch C_Det_Bonificacion into Lv_dummy;
    If C_Det_Bonificacion%notfound Then
     Close C_Det_Bonificacion;
    else
     Close C_Det_Bonificacion;

      Delete arfafl    --- Elimina la promocion en la linea de la factura
      Where  no_cia                 = Pv_Cia
      and    no_factu               = Pv_factura
      and    linea_art_promocion    = Pn_Linea_factura
      and    secuencia_politica     = Pn_sec_politica
      and    linea_politica         = Pn_linea_politica;

    end if;

    End;

    --- Verifica si un tipo de promocion ya existe en una factura

    function Verifica_promocion_factura (Pv_Cia            IN Varchar2,
                                         Pv_factura        IN Varchar2,
                                         Pn_linea_factura  IN Number,
                                         Pv_tipo_promocion IN Varchar2) Return Boolean IS


    Cursor C_Verif Is
     select 'X'
     from   arfapromo_fl
     where  no_cia         = Pv_Cia
     and    no_factu       = Pv_factura
     and    no_linea       = Pn_Linea_factura
     and    tipo_promocion = Pv_tipo_promocion;

    Lv_Dummy Varchar2(1);

    Begin

    Open  C_Verif;
    Fetch C_Verif into Lv_dummy;
    If C_Verif%notfound Then
     Close C_Verif;
     return (FALSE);
    else
     Close C_Verif;
     return (TRUE);
    end if;

    End;

    --- Recalcula detalle de la factura una vez actualizadas las promociones

    procedure recalcula_linea_factura (Pv_Cia             IN  Varchar2,
                                       Pv_factura         IN  Varchar2,
                                       Pn_linea_factura   IN  Number) Is

    Cursor C_Det_factura Is
     select a.no_factu, b.fecha,
            nvl(a.total,0) total, nvl(a.descuento,0) descuento, a.no_arti,
            nvl(a.i_ven,'N') i_ven, b.grupo, b.no_cliente, b.tipo_doc,
            a.no_linea, a.linea_art_promocion, a.costo2, a.pedido
     from   arfafl a, arfafe b
     where  a.no_cia = Pv_cia
     and    a.no_factu = Pv_factura
     and    a.no_linea = Pn_linea_factura
     and    a.no_cia = b.no_cia
     and    a.no_factu = b.no_factu;

   Cursor C_Imp_Arti (Lv_articulo Varchar2) Is
    select clave
    from   arinia
    where  no_cia = Pv_cia
    and    no_arti = Lv_articulo
    and    afecta_venta = 'S';

  --- Recupera si el articulo tiene marcado impuesto para ventas
   Cursor C_Arti (Lv_articulo Varchar2) Is
    select nvl(imp_ven,'N') imp_ven
    from   arinda
    where  no_cia = Pv_cia
    and    no_arti = Lv_articulo;

  --- Recupera si el cliente esta excento de impuestos
   Cursor C_Cliente (Lv_grupo Varchar2, Lv_cliente Varchar2) Is
    select nvl(excento_imp,'N') excento_imp
    from   arccmc
    where  no_cia = Pv_cia
    and    grupo  = Lv_grupo
    and    no_cliente = Lv_cliente;

    --- Se agrega para el recalculo del margen ANR 08/02/2010

    Cursor C_Cant_Bonif (Lv_factu Varchar2, Ln_linea Number) Is
     select nvl(pedido,0) cantidad_bonificacion
     from   arfafl
     where  no_cia = Pv_cia
     and    no_factu = Lv_factu
     and    linea_art_promocion = Ln_linea;

    Ln_margen_valor_fl Arfafl.Margen_Valor_Fl%type;
    Ln_cant_bonif Number := 0;

    Ln_base     Number := 0;
    Ln_Imp      Number := 0;
    Ln_Impuesto Number := 0;

    Lv_imp_arti    Arinda.imp_ven%type;
    Lv_excento_cli Arccmc.Excento_Imp%type;

    Ln_porc_Imp    Arcgimp.porcentaje%type;

    Begin

    For i in C_Det_factura Loop

      Ln_base := i.total - i.descuento;

     For imp in C_Imp_Arti (i.no_arti) Loop

        Open C_Arti (i.no_arti);
        Fetch C_Arti into Lv_imp_arti;
        If C_Arti%notfound Then
         Close C_Arti;
         Lv_imp_arti := 'N';
        else
         Close C_Arti;
        end if;

        Open C_Cliente(i.grupo, i.no_cliente);
        Fetch C_Cliente into Lv_excento_cli;
        If C_Cliente%notfound Then
         Close C_Cliente;
         Lv_excento_cli := 'N';
        else
         Close C_Cliente;
        end if;

        If Lv_imp_arti = 'S' and Lv_excento_cli = 'N' Then

            Ln_Imp := Impuesto.calcula(Pv_cia, imp.clave, Ln_base, null, 1, i.fecha);
            Ln_Impuesto := Ln_impuesto + nvl(Ln_imp,0);

            Ln_porc_Imp := Impuesto.porcentaje (Pv_cia, imp.clave, null, null);

            --- Elimino y creo registros de impuestos al detalle

            Delete Arfafli
            where  no_cia = Pv_cia
            and    no_factu = Pv_factura
            and    no_linea = Pn_linea_factura
            and    clave = imp.clave;

            Insert into Arfafli (no_cia, tipo_doc, no_factu, no_linea, clave,
                                 porc_imp, monto_imp, columna, base, codigo_tercero,
                                 comportamiento, aplica_cred_fiscal, id_sec)
                         Values (Pv_cia, i.tipo_doc, Pv_factura, Pn_linea_factura, imp.clave,
                                 Ln_porc_imp, Ln_imp, 1, Ln_base, null,
                                 'E','S',null);

        else

            Ln_Impuesto := 0;

            --- Elimino si no hay impuestos

            Delete Arfafli
            where  no_cia = Pv_cia
            and    no_factu = Pv_factura
            and    no_linea = Pn_linea_factura
            and    clave    = imp.clave;

        end if;

      End Loop;

   --- Se agrega para el recalculo del margen ANR 08/02/2010

     Open C_Cant_Bonif (i.no_factu, i.no_linea);
     Fetch C_Cant_Bonif into Ln_Cant_bonif;
     If C_Cant_Bonif%notfound Then
       Close C_Cant_Bonif;
       Ln_Cant_bonif := 0;
       else
       Close C_Cant_Bonif;
     end if;

     If i.linea_art_promocion is null Then
      Ln_margen_valor_fl := (Ln_base)-(nvl(i.costo2,0) * (nvl(i.pedido,0) + nvl(Ln_cant_bonif,0)));
     else
      Ln_margen_valor_fl := 0;
     end if;

      --- Actualiza el valor del impuesto con el valor total

      Update arfafl
      set    i_ven_n = decode(i.i_ven,'N',0,Ln_impuesto),
             margen_valor_fl = Ln_margen_valor_fl,
             margen_porc_fl = nvl(Ln_margen_valor_fl,0)/(decode(Ln_base,0,1,Ln_base))*100
      Where  no_cia      = Pv_Cia
      and    no_factu    = Pv_factura
      and    no_linea    = Pn_Linea_factura;

    End Loop;

    End;

   --- Recalcula cabecera de la factura una vez actualizadas las promociones

    procedure recalcula_cabecera_factura   (Pv_Cia     IN Varchar2,
                                            Pv_factura IN Varchar2) Is

    Cursor C_Cab_factura Is
     select nvl(sum(a.total),0) total_bruto,
            nvl(sum(a.descuento),0) descuento,
            nvl(sum(a.i_ven_n),0) impuesto
     from   arfafl a
     where  a.no_cia      = Pv_cia
     and    a.no_factu    = Pv_factura;


    Begin

    For i in C_Cab_factura Loop

      Update arfafe
      set    tot_lin = i.total_bruto,
             sub_total = i.total_bruto - i.descuento,
             descuento = i.descuento,
             impuesto  = i.impuesto,
             total     = i.total_bruto - i.descuento + i.impuesto
      Where  no_cia    = Pv_Cia
      and    no_factu  = Pv_factura;


    End Loop;

    End;

/*add mlopez 11/06/2010*/
--PROCEDIMIENTO PARA LA CREACION DE UN PEDIDO
--A PARTIR DE UN PEDIDO RECHAZADO O DEPURADO POR CIERRE DIARIO
   procedure crea_pedido_con_rechazado
             (
               Pv_Cia     IN Varchar2,
               Pv_factu  IN Varchar2,
               pb_creo_detalle in out boolean,
               pv_factu_generado in out varchar2,
               pv_fisico_generado in out varchar2,
               pv_bit_descuento in out varchar2,
               pv_bit_margen in out varchar2,
               pv_bit_promocion in out varchar2,
               pv_error   in out varchar2
             ) Is
 	cursor c_cabecera is
	 select *
	  from arfafec
	 where no_cia=pv_cia
	  and no_factu=pv_factu;

	cursor c_detalle is
	 select a.*,b.no_cliente,b.division_comercial,b.subcliente,b.grupo
	  from arfaflc a, arfafec b
	 where a.no_cia=pv_cia
	  and a.no_factu=pv_factu
	  and a.no_cia=b.no_cia
	  and a.no_factu=b.no_factu;

  cursor c_valida_promocion(cn_secuencia number,cn_linea number) is
   select no_cia
    from arfadet_politica_comercial
   where ind_activo='S'
    and secuencia=cn_secuencia
    and linea=cn_linea;

  cursor c_promocion_art(cv_cia varchar2,cv_pedido varchar2,cn_linea number) is
   select secuencia_politica,linea_politica
    from arfapromo_flc
   where no_cia=cv_cia
    and no_pedido=cv_pedido
    and no_linea=cn_linea;

  cursor c_detalle_prom(cv_cia varchar2,cv_factu varchar2,cn_linea number) is
   select a.*,b.no_cliente,b.division_comercial,b.subcliente,b.grupo
    from arfaflc a,arfafec b
   where a.no_cia=cv_cia
     and a.no_factu=cv_factu
     and a.no_linea=cn_linea
	  and a.no_cia=b.no_cia
	  and a.no_factu=b.no_factu;

  lc_detalle_prom c_detalle_prom%rowtype;
  lc_valida_promocion c_valida_promocion%rowtype;
  lc_promocion_art c_promocion_art%rowtype;

	cursor c_promocion is
	 select *
	  from arfapromo_flc
	 where no_cia=pv_cia
	  and no_pedido=pv_factu;

  Cursor C_Tipo_cliente(cv_cia varchar2,cv_grupo varchar2,cv_cliente varchar2) is
	  Select tipo_cliente
	  From   Arccmc
	  Where  no_cia     = cv_cia
	  And    grupo      = cv_grupo
	  And    no_cliente = cv_cliente;

  Cursor C_Articulo(cv_cia varchar2,cv_arti varchar2) is
	  Select division, subdivision
	  From   Arinda
	  Where  no_cia     = cv_cia
	  And    no_arti    = cv_arti;

  cursor c_escala(cv_cia varchar2,cv_factu varchar2,cn_linea number) is
   select no_cia
    from arfapromo_flc
   where no_cia=cv_cia
    and no_pedido=cv_factu
    and no_linea=cn_linea
    and tipo_promocion='E';

 lc_escala c_escala%rowtype;

Cursor C_Doc Is
 SELECT tipo
 FROM   ARFACT
 where  no_cia = pv_cia
 and    ind_fac_dev = 'E';

Cursor C_doc_Cfact (pv_cia varchar2,pv_centro varchar2,pv_ruta varchar2,pv_tipo Varchar2) Is
	select formulario
	from  arfaft
	where no_cia   = pv_cia
	and   centrod  = pv_centro
	and   centrof  = pv_ruta
	and   tipo_doc = pv_tipo;

  Lv_tipo        ARFACT.tipo%type;
  Lv_formulario  Arfaft.formulario%type;
  lc_articulo c_articulo%rowtype;
  lb_first  boolean:=true;
  lb_first_2 boolean:=true;
  lb_first_3 boolean :=true;
  lv_margen varchar2(5000);
  lv_descuento varchar2(5000);
  lv_promocion varchar2(5000);
	lc_cabecera c_cabecera%rowtype;
  lc_detalle c_detalle%rowtype;
  lc_promocion c_promocion%rowtype;
  lv_secuencia arfafec.no_factu%type;
  lv_fisico arfafec.no_fisico%type;
	lb_band boolean:=true;
	lb_graba boolean:=true;
  ln_margen_minimo number;
  ln_margen_objetivo	number;
  ln_porc_desc  number;
  ln_tope_descuento number;
  lv_error varchar2(500);
  lv_msj_descuento varchar2(5000);
  Lv_tipo_cliente          Arccmc.tipo_cliente%type;
	Lv_division_articulo     Arinda.division%type;
	Lv_subdivision_articulo  Arinda.subdivision%type;
  le_error exception;
  lb_creo_detalle boolean:=false;
  lb_msj_margen boolean:=false;
  lb_msj_descuento boolean:=false;
  lb_msj_promocion boolean:=false;
  lb_tiene boolean := false;
  ln_secuencia number;
  ln_linea number;
  ln_porc number;

BEGIN
		 open c_cabecera;
		 fetch c_cabecera into lc_cabecera;

		 if c_cabecera%found then
		 		loop
		 			  Open C_Doc;
            Fetch C_Doc into Lv_tipo;

            If C_Doc%notfound then
            	 Close C_Doc;
               pv_error:='Debe configurar en tipos de documento, un documento para pedidos';
               raise le_error;
            else
            	 Close C_Doc;
            end if;

            Open C_doc_Cfact (lc_cabecera.no_cia,lc_cabecera.centrod,lc_cabecera.ruta,Lv_tipo);
            Fetch C_doc_Cfact into Lv_formulario;

            If C_doc_Cfact%notfound then
            	 Close C_doc_Cfact;
               pv_error:='No existe configurado un formulario de pedidos: '||Lv_tipo||' para el centro de facturacion: '||lc_cabecera.ruta||' centro de distribucion: '||lc_cabecera.centrod;
               raise le_error;
            else
            	 Close C_doc_Cfact;

               If Lv_formulario is null Then
                  pv_error:='No existe configurado el formulario de pedidos: '||Lv_tipo||' para el centro de facturacion: '||lc_cabecera.ruta||' centro de distribucion: '||lc_cabecera.centrod;
                  raise le_error;
               end if;
            end if;

            lv_secuencia   := Consecutivo.FA(lc_cabecera.no_cia,to_number(to_char(lc_cabecera.fecha,'YYYY')),
                                             to_number(to_char(lc_cabecera.fecha,'MM')),
                                             lc_cabecera.centrod,lc_cabecera.ruta,Lv_tipo,
                                            'SECUENCIA');  ---- Genera secuencial para la transaccion del pedido

            If lv_secuencia is null Then
               pv_error:='No genero numero de transaccion de pedido para, a?o: '||to_number(to_char(lc_cabecera.fecha,'YYYY'))||' mes: '||to_number(to_char(lc_cabecera.fecha,'MM'))||' centro: '||lc_cabecera.centrod||' ruta: '||lc_cabecera.ruta||' doc: '||Lv_tipo||' tipo: '||'SECUENCIA';
               raise le_error;
            end if;

            lv_fisico  := Consecutivo.FA(lc_cabecera.no_cia,to_number(to_char(lc_cabecera.fecha,'YYYY')), to_number(to_char(lc_cabecera.fecha,'MM')),
                          lc_cabecera.centrod,lc_cabecera.ruta,Lv_tipo,'NUMERO');  ---- Genera secuencial para el pedido

            If lv_fisico is null Then
               pv_error:='No genero numero de pedido para, a?o: '||to_number(to_char(lc_cabecera.fecha,'YYYY'))||' mes: '||to_number(to_char(lc_cabecera.fecha,'MM'))||' centro: '||lc_cabecera.centrod||' ruta: '||lc_cabecera.ruta||' doc: '||Lv_tipo||' tipo: '||'NUMERO';
               raise le_error;
            end if;

		 			  if lv_secuencia is not null and lv_fisico is not null then
				 			  insert into arfafec
				 			  (NO_CIA,CENTROD,PERIODO,NO_FACTU,RUTA,AFECTA_SALDO,GRUPO,NO_CLIENTE,TIPO_CLIENTE,NBR_CLIENTE,DIRECCION,FECHA,NO_VENDEDOR,N_FACTU_D,
								 PLAZO,ENTREGAR,OBSERV1,OBSERV2,OBSERV3,MONEDA,TOT_LIN,SUB_TOTAL,DESCUENTO,IMPUESTO,TOTAL,ESTADO,F_ULT_ESTADO,APROBADO,IND_ANU_DEV,
								IMP_SINO,TIPO_FACTURA,PERI_LIQ,NO_LIQ,RAZON,PORC_DESC,NOTA_PEDIDO,NUMERO_CTRL,IND_EXPORTACION,TIPO_CAMBIO,DESCUENTO1,DESCUENTO2,
								CODIGO_PLAZO,REFERENCIA,NO_LINEA,RESERVA_STANDBY,USUARIO,PAR_DESPACHO,TSTAMP,FECHA_APRUEBA,USUARIO_APRUEBA,MOTIVO,FECHA_RECHAZO,
								USUARIO_RECHAZO,VIA_PEDIDO,TIPO_DESPACHO,IND_MARGEN,SUBCLIENTE,DIVISION_COMERCIAL,PEDIDO_MODIFICABLE,NO_DOCU_REFE_PICKING,FECHA_ANULA,
								USUARIO_ANULA,BODEGA,USUARIO_APRUEBA_MARGEN,FECHA_APRUEBA_MARGEN,MOTIVO_ANULACION,IND_APLICA_ESCALA,BODEGA_TRANSFERENCIA,NO_DOCU_SOLICITUD,
								MOTIVO_NOFACT,EMPLE_MOTIVO_NOFACT,USUARIO_NO_FACTURA,FECHA_NO_FACTURA,CODIGO_TRANSPORTISTA,IND_FLETE,IND_APROBACION_CREDITO,FECHA_CREACION,
								NO_FISICO,FECHA_ENTREGA_REQUERIDA,VALOR_TRANSPORTE,RUTA_DESPACHO,IND_DESP_COMPLETO,TDV_CEDULA,TDV_NOMBRE,TDV_VARIOS,BODEGA_TRANSFIERE,
								FORMA_PAGO)
				 			   values
				 			  (
				 			   lc_cabecera.NO_CIA, lc_cabecera.CENTROD, lc_cabecera.PERIODO, lv_secuencia,
								 lc_cabecera.RUTA, lc_cabecera.AFECTA_SALDO, lc_cabecera.GRUPO, lc_cabecera.NO_CLIENTE,
								 lc_cabecera.TIPO_CLIENTE, lc_cabecera.NBR_CLIENTE, lc_cabecera.DIRECCION, trunc(sysdate),
								 lc_cabecera.NO_VENDEDOR, LC_CABECERA.NO_FACTU /*REFERENCIA AL PEDIDO RECHAZADO SOBRE EL CUAL SE GENERO*/,
								 lc_cabecera.PLAZO, lc_cabecera.ENTREGAR,
								 lc_cabecera.OBSERV1, lc_cabecera.OBSERV2, 'PEDIDO GENERADO EN BASE AL PEDIDO RECHAZADO #'||LC_CABECERA.NO_FACTU,
								 lc_cabecera.MONEDA,
								 lc_cabecera.TOT_LIN, lc_cabecera.SUB_TOTAL,lc_cabecera.DESCUENTO, lc_cabecera.IMPUESTO,
								 lc_cabecera.TOTAL, 'P', NULL, lc_cabecera.APROBADO,
								 lc_cabecera.IND_ANU_DEV, lc_cabecera.IMP_SINO, lc_cabecera.TIPO_FACTURA, lc_cabecera.PERI_LIQ,
								 lc_cabecera.NO_LIQ, lc_cabecera.RAZON, lc_cabecera.PORC_DESC, lc_cabecera.NOTA_PEDIDO,
							   lc_cabecera.NUMERO_CTRL, lc_cabecera.IND_EXPORTACION, lc_cabecera.TIPO_CAMBIO, lc_cabecera.DESCUENTO1,
								 lc_cabecera.DESCUENTO2, lc_cabecera.CODIGO_PLAZO, lc_cabecera.REFERENCIA, lc_cabecera.NO_LINEA,
								 lc_cabecera.RESERVA_STANDBY, user, lc_cabecera.PAR_DESPACHO, sysdate, lc_cabecera.FECHA_APRUEBA,
								 lc_cabecera.USUARIO_APRUEBA, lc_cabecera.MOTIVO, lc_cabecera.FECHA_RECHAZO, lc_cabecera.USUARIO_RECHAZO,
								 lc_cabecera.VIA_PEDIDO, lc_cabecera.TIPO_DESPACHO, lc_cabecera.IND_MARGEN, lc_cabecera.SUBCLIENTE,
								 lc_cabecera.DIVISION_COMERCIAL, lc_cabecera.PEDIDO_MODIFICABLE, lc_cabecera.no_docu_refe_picking,
								 NULL, NULL, lc_cabecera.BODEGA, lc_cabecera.USUARIO_APRUEBA_MARGEN,
								 lc_cabecera.FECHA_APRUEBA_MARGEN, NULL, lc_cabecera.IND_APLICA_ESCALA,
								 lc_cabecera.BODEGA_TRANSFERENCIA, lc_cabecera.NO_DOCU_SOLICITUD, NULL,
							   NULL, NULL, NULL,
								 lc_cabecera.CODIGO_TRANSPORTISTA, lc_cabecera.IND_FLETE, lc_cabecera.IND_APROBACION_CREDITO,
								 sysdate, lv_FISICO, NULL,
								 lc_cabecera.VALOR_TRANSPORTE, lc_cabecera.RUTA_DESPACHO, lc_cabecera.IND_DESP_COMPLETO,
								 lc_cabecera.TDV_CEDULA, lc_cabecera.TDV_NOMBRE, lc_cabecera.TDV_VARIOS, lc_cabecera.BODEGA_TRANSFIERE,
								 lc_cabecera.forma_pago
				 			  );
		 			  end if;

		 			  fetch c_cabecera into lc_cabecera;
		 			  exit when c_cabecera%notfound;
		 		end loop;
		 end if;

		 close c_cabecera;

		 if lv_secuencia is not null then
				 open c_detalle;
				 fetch c_detalle into lc_detalle;

				 if c_detalle%found then
				 		loop
				 			  if lc_detalle.linea_art_promocion is not null then
					 			   open c_promocion_art(lc_detalle.no_cia,lc_detalle.no_factu,lc_detalle.linea_art_promocion);
					 			   fetch c_promocion_art into lc_promocion_art;
									 close c_promocion_art;

					 			   open c_valida_promocion(lc_promocion_art.secuencia_politica,lc_promocion_art.linea_politica);
					 			   fetch c_valida_promocion into lc_valida_promocion;

					 			   if c_valida_promocion%notfound then
					 			  	  lb_band:=false;
					 			   else
					 			   	  lb_band:=true;
					 			   end if;

					 			   close c_valida_promocion;
			 			  	end if;

		 			  	  if lc_detalle.linea_art_promocion is not null then
		 			  	  	 if lb_band=false then
		 			  	  			lb_graba:=false;
		 			  	  	 else
		 			  	  	 	  lb_graba:=true;

                      open c_detalle_prom(lc_detalle.no_cia,lc_detalle.no_factu,lc_detalle.linea_art_promocion);
		 			  	  	    fetch c_detalle_prom into lc_detalle_prom;
		 			  	  	    close c_detalle_prom;

                      Open C_Tipo_cliente(lc_detalle.no_cia,lc_detalle.grupo,lc_detalle.no_cliente);
                      Fetch C_Tipo_cliente into Lv_tipo_cliente;

                      If C_tipo_cliente%notfound Then
                    		 Close C_Tipo_cliente;
                      else
                      	 Close C_Tipo_cliente;
                      end if;

                    	Open C_Articulo(lc_detalle.no_cia,lc_detalle.no_arti);
                    	Fetch C_Articulo into Lv_division_articulo, Lv_subdivision_articulo;

                    	If C_Articulo%notfound Then
                    		 Close C_Articulo;
                    	else
                    		 Close C_Articulo;
                    	end if;

                      Ln_margen_minimo:=0;
	                    Ln_margen_objetivo:=0;
	                    Ln_porc_desc:=0;

	                    PU_DEVUELVE_MARGEN
                      (
                       lc_detalle_prom.no_cia,
                       lc_detalle_prom.centrod,
	                     lc_detalle_prom.division_comercial,
	                     Lv_tipo_cliente,
	                     lc_detalle_prom.grupo,
	                     lc_detalle_prom.no_cliente,
	                     lc_detalle_prom.subcliente,
	                     lv_division_articulo,
	                     lv_subdivision_articulo,
	                     lc_detalle_prom.no_arti,
	                     Ln_margen_minimo,
	                     Ln_margen_objetivo,
	                     Ln_porc_desc,
	                     'S',
	                     Lv_error
                     ) ;

		                 If nvl(lc_detalle_prom.margen_porc_flc,0) < nvl(ln_margen_minimo,0)  Then
                        lb_msj_margen:=true;

                        if lb_first then
                           lv_margen:='Los articulos: '||lc_detalle.no_arti;
                           lb_first:=false;
                        else
											     if instr(lv_margen,lc_detalle.no_arti,1)=0 then
                              lv_margen:=lv_margen||lc_detalle.no_arti||',';
                           end if;
                        end if;

									      lb_graba:=false;
		                 else
		                    valida_porc_descuento
                        (
                         lc_detalle_prom.no_cia,
                         lc_detalle_prom.division_comercial,
                         lc_detalle_prom.grupo,
                         lc_detalle_prom.no_cliente,
                         lc_detalle_prom.subcliente,
                         trunc(sysdate),
                         lc_detalle_prom.centrod,
                         lc_detalle_prom.no_arti,
                         lc_detalle_prom.division,
                         lc_detalle_prom.subdivision,
                         lc_detalle_prom.porc_desc,
                         ln_tope_descuento,
                         lv_msj_descuento,
                         lb_graba
                        );

                        if lv_msj_descuento is not null then
                           lb_msj_descuento:=true;

                           if lb_first_2 then
                              lv_descuento:='Porcentaje de Descuento Incorrecto para el (los) articulo(s): '||lv_msj_descuento||' '||' descuento maximo: '||nvl(ln_tope_descuento,0)||' % , ';
                              lb_first_2:=false;
                           else
                              if instr(lv_descuento,lv_msj_descuento,1)=0 then
                                 lv_msj_descuento:=lv_msj_descuento||',';
                                 lv_descuento:=lv_descuento||lv_msj_descuento||' descuento maximo: '||nvl(ln_tope_descuento,0)||' % ,';
                              end if;
                           end if;
                        end if;
		     						 end if;
		 			  	  	 end if;
		 			  	  else
		 			  	     open c_promocion_art(lc_detalle.no_cia,lc_detalle.no_factu,lc_detalle.no_linea);
				 			     fetch c_promocion_art into lc_promocion_art;

                   if c_promocion_art%found then
    				 			     open c_valida_promocion(lc_promocion_art.secuencia_politica,lc_promocion_art.linea_politica);
    		 			  	     fetch c_valida_promocion into lc_valida_promocion;

    		 			  	     if c_valida_promocion%notfound then
                          if lb_first_3 then
                             lb_msj_promocion:=true;
                             lv_promocion:='Los articulos: '||lc_detalle.no_arti||',';
                             lb_first_3:=false;
                          else
                             if instr(lv_promocion,lc_detalle.no_arti,1)=0 then
                                lv_promocion:=lv_promocion||lc_detalle.no_arti||',';
                             end if;
                          end if;

    		 			  	  	    lb_graba:=false;
    		 			  	     else
    		 			  	  	    lb_graba:=true;
    		 			  	     end if;

    		 			  	     close c_valida_promocion;
                   else
                       lb_graba:=true;
                   end if;

                   close c_promocion_art;
		 			  	  end if;

								if lb_graba then
									 if lc_detalle.linea_art_promocion is null then
									    valida_porc_descuento
                      (
                           lc_detalle.no_cia,
                           lc_detalle.division_comercial,
                           lc_detalle.grupo,
                           lc_detalle.no_cliente,
                           lc_detalle.subcliente,
                           trunc(sysdate),
                           lc_detalle.centrod,
                           lc_detalle.no_arti,
                           lc_detalle.division,
                           lc_detalle.subdivision,
                           lc_detalle.porc_desc,
                           ln_tope_descuento,
                           lv_msj_descuento,
                           lb_graba
                      );

                      if lv_msj_descuento is not null then
                         lb_msj_descuento:=true;

                         if lb_first_2 then
                            lv_descuento:='Porcentaje de Descuento incorrecto para el (los) articulo(s): '||lv_msj_descuento||', '||' descuento maximo: '||nvl(ln_tope_descuento,0)||' % , ';
                            lb_first_2:=false;
                         else
                            if instr(lv_descuento,lv_msj_descuento,1)=0 then
                               lv_msj_descuento:=lv_msj_descuento||',';
                               lv_descuento:=lv_descuento||lv_msj_descuento||' descuento maximo: '||nvl(ln_tope_descuento,0)||' %';
                            end if;
                         end if;
                      end if;

                      if lb_graba then
                      	 Open C_Tipo_cliente(lc_detalle.no_cia,lc_detalle.grupo,lc_detalle.no_cliente);
                         Fetch C_Tipo_cliente into Lv_tipo_cliente;

                         If C_tipo_cliente%notfound Then
                        	  Close C_Tipo_cliente;
                         else
                         	  Close C_Tipo_cliente;
                         end if;

                         Open C_Articulo(lc_detalle.no_cia,lc_detalle.no_arti);
                         Fetch C_Articulo into Lv_division_articulo, Lv_subdivision_articulo;

                         If C_Articulo%notfound Then
                        		Close C_Articulo;
                         else
                        	  Close C_Articulo;
                         end if;

                         Ln_margen_minimo:=0;
    	                   Ln_margen_objetivo:=0;
  	                     Ln_porc_desc:=0;

  	                     PU_DEVUELVE_MARGEN
                         (
                           lc_detalle.no_cia,
                           lc_detalle.centrod,
    	                     lc_detalle.division_comercial,
    	                     Lv_tipo_cliente,
    	                     lc_detalle.grupo,
    	                     lc_detalle.no_cliente,
    	                     lc_detalle.subcliente,
    	                     lv_division_articulo,
    	                     lv_subdivision_articulo,
    	                     lc_detalle.no_arti,
    	                     Ln_margen_minimo,
    	                     Ln_margen_objetivo,
    	                     Ln_porc_desc,
    	                     'S',
    	                     Lv_error
                         );

				                 If  nvl(lc_detalle.margen_porc_flc,0) < nvl(ln_margen_minimo,0)  Then
                             lb_msj_margen:=true;

                             if lb_first then
                                lv_margen:='Los articulos: '||lc_detalle.no_arti||',';
                                lb_first:=false;
                             else
											          if instr(lv_margen,lc_detalle.no_arti,1)=0 then
                                   lv_margen:=lv_margen||lc_detalle.no_arti||',';
                                end if;
                             end if;

											       lb_graba:=false;
				                 else
				                 	   lb_graba:=true;
				                 end if;
				              else
				                 lc_detalle.porc_desc:=0;
				                 lc_detalle.descuento:=0;

                         if lv_msj_descuento is null and
                            instr(nvl(lv_margen,' '),lc_detalle.no_arti,1)=0 then
                            lb_graba:=true;
                         end if;
				              end if;
									 end if;

                   if lb_graba then
                      open c_articulo(lc_detalle.no_cia,lc_detalle.no_arti);
                      fetch c_articulo into lc_articulo;
                      close c_articulo;

                      ln_secuencia:=0;
                      ln_linea:=0;
                      ln_porc:=0;
                      lb_tiene:=false;

                      pedido_tiene_escala(lc_detalle.no_cia,lc_detalle.centrod,lc_detalle.division_comercial,
                                          lc_detalle.grupo,lc_detalle.no_cliente,lc_detalle.subcliente,lc_detalle.no_factu,
                                          trunc(sysdate),lc_articulo.division,lc_articulo.subdivision,
                                          ln_secuencia,ln_linea,ln_porc,lb_tiene);

                      open c_escala(lc_detalle.no_cia,lc_detalle.no_Factu,lc_detalle.no_linea);
                      fetch c_escala into lc_escala;

                      if c_escala%found then
                         if not lb_tiene then
                            lc_detalle.porc_desc:=0;
                            lc_detalle.descuento:=0;
                         end if;
                      end if;

                      close c_escala;

                      if lb_tiene then
                         lc_detalle.porc_desc:=nvl(ln_porc,0);
                         lc_detalle.descuento:=((nvl(lc_detalle.PRECIO,0)*nvl(lc_detalle.pedido,0))*(nvl(ln_porc,0)/100));
                      end if;

                      lb_creo_detalle:=true;

                      insert into arfaflc
								 			(
								 			   NO_CIA,CENTROD,PERIODO,NO_FACTU,NO_LINEA,BODEGA,CLASE,CATEGORIA,NO_ARTI,PEDIDO,PORC_DESC,PRECIO,DESCUENTO,TOTAL,I_VEN,
												 I_VEN_N,TIPO_PRECIO,UN_DEVOL,TIPO_OFERTA,ARTI_OFE,CANT_OFE,PROT_OFE,CANT_APROBADA,CANT_FACTURADA,OFE_ENTREGADA,IMP_INCLUIDO,
												 IMP_ESPECIAL,COSTO2,SOLICITA_TRANSFERENCIA,LINEA_ART_PROMOCION,MARGEN_VALOR_FLC,MARGEN_MINIMO,MARGEN_OBJETIVO,MARGEN_PORC_FLC,
												 SECUENCIA_POLITICA,LINEA_POLITICA,DIVISION,SUBDIVISION,DESCUENTO_ADICIONAL,CANTIDAD_ADICIONAL,IND_ADICIONAL,TSTAMP,
												 PORC_DESC_APROBADO,PRECIO_APROBADO
								 			)
								 			 values
								 			(
								 			   lc_detalle.NO_CIA, lc_detalle.CENTROD, lc_detalle.PERIODO, lv_secuencia, lc_detalle.NO_LINEA, lc_detalle.BODEGA,
												 lc_detalle.CLASE, lc_detalle.CATEGORIA, lc_detalle.NO_ARTI, lc_detalle.PEDIDO,
                         lc_detalle.porc_desc,
                         lc_detalle.PRECIO,
												 lc_detalle.descuento,
                         lc_detalle.TOTAL, lc_detalle.I_VEN, lc_detalle.I_VEN_N, lc_detalle.TIPO_PRECIO, lc_detalle.UN_DEVOL,
												 lc_detalle.TIPO_OFERTA, lc_detalle.ARTI_OFE, lc_detalle.CANT_OFE, lc_detalle.PROT_OFE, lc_detalle.CANT_APROBADA,
												 lc_detalle.CANT_FACTURADA, lc_detalle.OFE_ENTREGADA, lc_detalle.IMP_INCLUIDO, lc_detalle.IMP_ESPECIAL, lc_detalle.COSTO2,
												 lc_detalle.SOLICITA_TRANSFERENCIA, lc_detalle.LINEA_ART_PROMOCION, lc_detalle.MARGEN_VALOR_FLC, lc_detalle.MARGEN_MINIMO,
												 lc_detalle.MARGEN_OBJETIVO, lc_detalle.MARGEN_PORC_FLC, lc_detalle.SECUENCIA_POLITICA, lc_detalle.LINEA_POLITICA,
												 lc_detalle.DIVISION, lc_detalle.SUBDIVISION, lc_detalle.DESCUENTO_ADICIONAL, lc_detalle.CANTIDAD_ADICIONAL,
												 lc_detalle.IND_ADICIONAL, sysdate, lc_detalle.PORC_DESC_APROBADO, lc_detalle.PRECIO_APROBADO
								 			);
								 	  end if;
								end if;

								lb_band:=true;
								lb_graba:=true;
								ln_margen_minimo:=0;
				        ln_margen_objetivo:=0;
                ln_tope_descuento:=0;
                ln_porc_desc:=0;
                lv_msj_descuento:=null;

				 			  fetch c_detalle into lc_detalle;
				 			  exit when c_detalle%notfound;
				 		end loop;
				 end if;

				 close c_detalle;

				 lb_band:=true;
				 lb_graba:=true;

				 ln_margen_minimo:=0;
				 ln_margen_objetivo:=0;
         ln_porc_desc:=0;
         ln_tope_descuento:=0;
         lv_msj_descuento:=null;

				 open c_promocion;
				 fetch c_promocion into lc_promocion;

				 if c_promocion%found then
				 	  loop
                open c_detalle_prom(lc_promocion.no_cia,lc_promocion.no_pedido,lc_promocion.no_linea);
		 			  	  fetch c_detalle_prom into lc_detalle_prom;
		 			  	  close c_detalle_prom;

				 	  	  open c_valida_promocion(lc_promocion.secuencia_politica,lc_promocion.linea_politica);
		 			  	  fetch c_valida_promocion into lc_valida_promocion;

		 			  	  if c_valida_promocion%notfound then
                   if lb_first_3 then
                      lb_msj_promocion:=true;
                      lb_first_3:=false;
                   end if;

		 			  	  	 lb_band:=false;
		 			  	  else
		 			  	  	 lb_band:=true;
		 			  	  end if;

		 			  	  close c_valida_promocion;

		 			  	  if lb_band=false then
		 			  			 lb_graba:=false;
		 			  	  else
		 			  	 	   lb_graba:=true;
		 			  	  end if;

		 			  	  if lb_graba then
		 			  	  	 open c_detalle_prom(lc_promocion.no_cia,lc_promocion.no_pedido,lc_promocion.no_linea);
		 			  	  	 fetch c_detalle_prom into lc_detalle_prom;
		 			  	  	 close c_detalle_prom;

		 			  	  	 Open C_Tipo_cliente(lc_detalle_prom.no_cia,lc_detalle_prom.grupo,lc_detalle_prom.no_cliente);
                   Fetch C_Tipo_cliente into Lv_tipo_cliente;

                   If C_tipo_cliente%notfound Then
                   	  Close C_Tipo_cliente;
                   else
                    	Close C_Tipo_cliente;
                   end if;

                   Open C_Articulo(lc_detalle_prom.no_cia,lc_detalle_prom.no_arti);
                   Fetch C_Articulo into Lv_division_articulo, Lv_subdivision_articulo;

                   If C_Articulo%notfound Then
                   		Close C_Articulo;
                   else
                    	Close C_Articulo;
                   end if;

                   Ln_margen_minimo:=0;
                   Ln_margen_objetivo:=0;
                   Ln_porc_desc:=0;

	                 PU_DEVUELVE_MARGEN
                   (
                       lc_detalle_prom.no_cia,
                       lc_detalle_prom.centrod,
	                     lc_detalle_prom.division_comercial,
	                     Lv_tipo_cliente,
	                     lc_detalle_prom.grupo,
	                     lc_detalle_prom.no_cliente,
	                     lc_detalle_prom.subcliente,
	                     lv_division_articulo,
	                     lv_subdivision_articulo,
	                     lc_detalle_prom.no_arti,
	                     Ln_margen_minimo,
	                     Ln_margen_objetivo,
	                     Ln_porc_desc,
	                     'S',
	                     Lv_error
                   ) ;

                   If  nvl(lc_detalle_prom.margen_porc_flc,0) < nvl(ln_margen_minimo,0)  Then
                       lb_msj_margen:=true;
							         lb_graba:=false;
                   else
                   	   valida_porc_descuento
                      (
                           lc_detalle_prom.no_cia,
                           lc_detalle_prom.division_comercial,
                           lc_detalle_prom.grupo,
                           lc_detalle_prom.no_cliente,
                           lc_detalle_prom.subcliente,
                           trunc(sysdate),
                           lc_detalle_prom.centrod,
                           lc_detalle_prom.no_arti,
                           lc_detalle_prom.division,
                           lc_detalle_prom.subdivision,
                           lc_detalle_prom.porc_desc,
                           ln_tope_descuento,
                           lv_msj_descuento,
                           lb_graba
                      );

                      if lv_msj_descuento is not null then
                         lb_msj_descuento:=true;
                      end if;

                   end if;

                   if lb_graba then
                      open c_articulo(lc_detalle_prom.no_cia,lc_detalle_prom.no_arti);
                      fetch c_articulo into lc_articulo;
                      close c_articulo;

                      ln_secuencia:=0;
                      ln_linea:=0;
                      ln_porc:=0;
                      lb_tiene:=false;

                      pedido_tiene_escala(lc_detalle_prom.no_cia,lc_detalle_prom.centrod,lc_detalle_prom.division_comercial,
                                          lc_detalle_prom.grupo,lc_detalle_prom.no_cliente,lc_detalle_prom.subcliente,
                                          lc_detalle_prom.no_factu,trunc(sysdate),lc_articulo.division,lc_articulo.subdivision,
                                          ln_secuencia,ln_linea,ln_porc,lb_tiene);

                      open c_escala(lc_detalle_prom.no_cia,lc_detalle_prom.no_Factu,lc_detalle_prom.no_linea);
                      fetch c_escala into lc_escala;

                      if c_escala%found then
                         if not lb_tiene then
                            lb_graba:=false;
                         end if;
                      end if;

                      close c_escala;

                      if lb_graba then
                       	  insert into arfapromo_flc
    								 	  	(
    								 	  	  NO_CIA,NO_PEDIDO,NO_LINEA,SECUENCIA_POLITICA,LINEA_POLITICA,TIPO_PROMOCION,PORC_DESCUENTO,
    												PRECIO,CANT_MINIMA,CANT_MAXIMA,UNIDADES,ARTI_ALTERNO,TSTAMP
    								 	  	)
    								 	  	 values
    								 	  	(
    								 	  	   lc_promocion.NO_CIA, lv_secuencia, lc_promocion.NO_LINEA, lc_promocion.SECUENCIA_POLITICA,
    												 lc_promocion.LINEA_POLITICA, lc_promocion.TIPO_PROMOCION, lc_promocion.PORC_DESCUENTO,
    												 lc_promocion.PRECIO, lc_promocion.CANT_MINIMA, lc_promocion.CANT_MAXIMA, lc_promocion.UNIDADES,
    												 lc_promocion.ARTI_ALTERNO, sysdate
    								 	  	);
                     end if;
								 	 end if;
		 			  	  end if;

		 			  	  lb_band:=true;
		 			  	  lb_graba:=true;
		 			  	  ln_margen_minimo:=0;
                ln_margen_objetivo:=0;
                ln_porc_desc:=0;
                ln_tope_descuento:=0;
                lv_msj_descuento:=null;

				 	  	  fetch c_promocion into lc_promocion;
				 	  	  exit when c_promocion%notfound;
				 	  end loop;
				 end if;

				 close c_promocion;

		 else
		     rollback;
		     pv_error:='Proceso Fallo.No se generaron las secuencias...';
		 end if;

     pv_factu_generado:=lv_secuencia;
     pv_fisico_generado:=lv_fisico;

     pb_creo_detalle:=lb_creo_detalle;

     if lb_msj_margen then
        pv_bit_margen:=lv_margen||' tiene(n) problema(s) de margen, no se a?adira(n) al nuevo pedido.';
     end if;

     if lb_msj_descuento then
        pv_bit_descuento:=lv_descuento||' .Articulo(s) se creara(n) con porcentaje de descuento 0%';
     end if;

     if lb_msj_promocion then
        pv_bit_promocion:=lv_promocion||' no se crearan pues la promocion aplicada ya no esta vigente.';
     end if;

exception
	 when others then
	   rollback;
	   pv_error:='FAPOLITICA_COMERCIAL.crea_pedido_con_rechazado: '||sqlcode||'-'||sqlerrm||'.No se ejecuto el proceso.';
END crea_pedido_con_rechazado;

PROCEDURE valida_porc_descuento
          (
           pv_cia varchar2,
           pv_div_comercial varchar2,
           pv_grupo varchar2,
           pv_cliente varchar2,
           pv_subcliente varchar2,
           pd_fecha date,
           pv_centro varchar2,
           pv_arti varchar2,
           pv_division varchar2,
           pv_subdivision varchar2,
           pn_porc_desc number,
           pn_tope_descuento in out number,
           pv_msj in out varchar2,
           pb_graba in out boolean
         ) IS
Cursor C_Distrib_grupo Is
	select tipo_cliente
	from   arfa_distrib_grupo
	where  no_cia          = pv_cia
	and   (division        = pv_division or division = '%')
	and   (subdivision     = pv_subdivision or subdivision = '%')
  and   (grupo           = nvl(pv_grupo,'%') or grupo = '%')
  and   (no_cliente      = nvl(pv_cliente,'%') or no_cliente = '%')
  and   (no_sub_cliente  = nvl(pv_subcliente,'%') or no_sub_cliente = '%');

   Cursor C_Tipo_Cliente Is
		select nvl(tipo_cliente,'%')
		from   arccmc
		where  no_cia     = pv_cia
		and    grupo      = pv_grupo
		and    no_cliente = pv_cliente;

 cursor c_descuentos(cv_tipo_cliente varchar2) is
  select max(b.porc_descuento)hasta
   from arfaenc_politica_comercial a, arfadet_politica_comercial b
	where a.no_cia = pv_cia
		and   b.tipo_promocion = 'D'
		and trunc(pd_fecha) between trunc(fecha_inicio) and trunc(fecha_fin)
		and (division_art = pv_division or division_art = '%')
		and (subdivision_art = pv_subdivision or subdivision_art = '%')
	  and (centro_distribucion = pv_centro or centro_distribucion = '%')
	  and (tipo_cliente = cv_tipo_cliente or tipo_cliente = '%')
	  and (grupo = pv_grupo or grupo = '%')
	  and (no_cliente = pv_cliente or no_cliente = '%')
	  and (division_comercial = pv_div_comercial or division_comercial = '%')
		and (no_arti = pv_arti or no_arti = '%')
		and a.ind_activo = 'S'
		and b.ind_activo = 'S'
		and a.no_cia = b.no_cia
		and a.secuencia = b.secuencia;

 lv_tipo_cliente_dist varchar2(10);
 lv_tipo_cli varchar2(10);
 lc_descuentos c_descuentos%rowtype;

BEGIN
 Open  C_Tipo_Cliente;
 Fetch C_Tipo_Cliente into Lv_tipo_cli;

 If C_Tipo_Cliente%notfound Then
  	Close C_Tipo_Cliente;
  	Lv_tipo_cli := '%';
 else
  	Close C_Tipo_Cliente;
 end if;

 Open C_Distrib_grupo;
 Fetch C_Distrib_grupo into Lv_tipo_cliente_dist;

 If C_Distrib_grupo%notfound Then
	 	Close C_Distrib_grupo;
	 	Lv_tipo_cliente_dist := Lv_tipo_cli;
 else
 	  Close C_Distrib_grupo;

		If Lv_tipo_cliente_dist is null Then
		 	 Lv_tipo_cliente_dist := Lv_tipo_cli;
		end if;
 end if;

 open c_descuentos(lv_tipo_cliente_dist);
 fetch c_descuentos into lc_descuentos;
 close c_descuentos;

 pn_tope_descuento:=nvl(lc_descuentos.hasta,0);

 if nvl(pn_porc_desc,0) > nvl(lc_descuentos.hasta,0) then
    pv_msj:=pv_arti;
 	  pb_graba:=false;
 else
 	  pv_msj:=null;
    pb_graba:=true;
 end if;
END valida_porc_descuento;

PROCEDURE pedido_tiene_escala(pv_cia varchar2,pv_centro varchar2,pv_div_comercial varchar2,
                              pv_grupo varchar2,pv_cliente varchar2,pv_subcliente varchar2,pv_factu varchar2,
                              pd_fecha date,pv_division in out varchar2, pv_subdivision in out varchar2,
                              pn_secuencia in out number,pn_linea in out number,pn_porc in out number,
                              pb_tiene in out boolean) IS
--- Si la division es TODOS, subdivision es TODOS y articulo es TODOS para este tipo de promocion no puede aplicar este caso
Cursor C_Distrib_grupo Is
	select tipo_cliente
	from   arfa_distrib_grupo
	where  no_cia          = pv_cia
  and   (grupo           = nvl(pv_grupo,'%') or grupo = '%')
  and   (no_cliente      = nvl(pv_cliente,'%') or no_cliente = '%')
  and   (no_sub_cliente  = nvl(pv_subcliente,'%') or no_sub_cliente = '%')
    and (division, subdivision) IN
	      (select distinct b.division, b.subdivision
				 from arfafec a, arfaflc b
				 where a.no_cia      = pv_cia
				 and   a.no_factu = pv_factu
				 and b.linea_art_promocion is null
				 and   a.no_cia      = b.no_cia
				 and   a.no_factu   = b.no_factu) ---- para pedido
 UNION
	select tipo_cliente
	from   arfa_distrib_grupo
	where  no_cia          = pv_cia
  and   (grupo           = nvl(pv_grupo,'%') or grupo = '%')
  and   (no_cliente      = nvl(pv_cliente,'%') or no_cliente = '%')
  and   (no_sub_cliente  = nvl(pv_subcliente,'%') or no_sub_cliente = '%')
	and    subdivision     = '%'
  and   (division) IN
        (select distinct b.division
			   from arfafec a, arfaflc b
			   where a.no_cia      = pv_cia
			   and   a.no_factu = pv_factu
			   and   b.linea_art_promocion is null
			   and   a.no_cia      = b.no_cia
			   and   a.no_factu = b.no_factu); ---- para pedido

Cursor C_Detalle_div (lv_tipo_cliente Varchar2) Is
select distinct(b.division_art)division
  from arfaenc_politica_comercial a, arfadet_politica_comercial b
	where a.no_cia = pv_cia
	and trunc(pd_fecha) between trunc(b.fecha_inicio) and trunc(b.fecha_fin)
  and (centro_distribucion = pv_centro or centro_distribucion = '%')
  and (tipo_cliente = Lv_tipo_cliente or tipo_cliente = '%')
  and (grupo = pv_grupo or grupo = '%')
  and (no_cliente = pv_cliente or no_cliente = '%')
  and (subcliente = pv_subcliente or subcliente = '%')
  and (division_comercial = pv_div_comercial or division_comercial = '%')
	and a.ind_activo = 'S'
	and b.ind_activo = 'S'
	and b.tipo_promocion = 'E' ---- Las escalas son por el total de la proforma o el pedido
  and exists
     (
      select y.division, y.subdivision
			 from arfafec x, arfaflc y
			where x.no_cia   = pv_cia
			 and  x.no_factu = pv_factu
			 and  y.linea_art_promocion is null
			 and  x.no_cia   = y.no_cia
			 and  x.no_factu = y.no_factu
			 and  (y.division=b.division_art or b.division_art='%')
			  --si se detallaron subdivisiones, que las subdivisiones formen parte de la lista
			  --si no es asi TODAS las subdivisiones
  		  and ((exists
  		      (
  		        select u.no_cia from arfadet_politica_comercial_esc u
  		        where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		        and u.linea=b.linea and ind_activo='S'
  		      )and y.subdivision in
  		       (select u.subdivision_art from arfadet_politica_comercial_esc u
  		        where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		        and u.linea=b.linea and ind_activo='S')) or
  		       (not exists
  		        (
  		         select u.no_cia from arfadet_politica_comercial_esc u
  		         where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		         and u.linea=b.linea and ind_activo='S'
  		         ) and b.subdivision_art='%'))
		 ) --- PARA PEDIDOS
  and a.no_cia = b.no_cia
	and a.secuencia = b.secuencia;


Cursor C_Detalle (lv_division varchar2,lv_tipo_cliente Varchar2) Is
select a.secuencia, a.fecha_desde, a.fecha_hasta, a.centro_distribucion ,
        b.fecha_inicio, b.fecha_fin, b.tipo_cliente, b.grupo, b.no_cliente, b.division_comercial,
				b.division_art, b.subdivision_art, b.no_arti, b.porc_descuento, b.precio, b.cant_minima,
				b.cant_maxima, b.unidades, b.no_arti_alterno,
				b.obligatorio, b.linea, b.tipo_promocion, b.subcliente
  from arfaenc_politica_comercial a, arfadet_politica_comercial b
	where a.no_cia = pv_cia
	and trunc(pd_fecha) between trunc(b.fecha_inicio) and trunc(b.fecha_fin)
  and (centro_distribucion = pv_centro or centro_distribucion = '%')
  and b.division_art=lv_division
  and (tipo_cliente = Lv_tipo_cliente or tipo_cliente = '%')
  and (grupo = pv_grupo or grupo = '%')
  and (no_cliente = pv_cliente or no_cliente = '%')
  and (subcliente = pv_subcliente or subcliente = '%')
  and (division_comercial = pv_div_comercial or division_comercial = '%')
	and a.ind_activo = 'S'
	and b.ind_activo = 'S'
	and b.tipo_promocion = 'E' ---- Las escalas son por el total de la proforma o el pedido
  and exists
     (
      select y.division, y.subdivision
			 from arfafec x, arfaflc y
			where x.no_cia   = pv_cia
			 and  x.no_factu = pv_factu
			 and  y.linea_art_promocion is null
			 and  x.no_cia   = y.no_cia
			 and  x.no_factu = y.no_factu
			 and  (y.division=b.division_art or b.division_art='%')
			  --si se detallaron subdivisiones, que las subdivisiones formen parte de la lista
			  --si no es asi TODAS las subdivisiones
  		  and ((exists
  		      (
  		        select u.no_cia from arfadet_politica_comercial_esc u
  		        where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		        and u.linea=b.linea and ind_activo='S'
  		      )and y.subdivision in
  		       (select u.subdivision_art from arfadet_politica_comercial_esc u
  		        where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		        and u.linea=b.linea and ind_activo='S')) or
  		       (not exists
  		        (
  		         select u.no_cia from arfadet_politica_comercial_esc u
  		         where u.no_cia=b.no_cia and u.secuencia=b.secuencia
  		         and u.linea=b.linea and ind_activo='S'
  		         ) and b.subdivision_art='%'))
		 ) --- PARA PEDIDOS
  and a.no_cia = b.no_cia
	and a.secuencia = b.secuencia
  order by 5;

  Cursor C_Tipo_Cliente Is
		select nvl(tipo_cliente,'%')
		from   arccmc
		where  no_cia     = pv_cia
		and    grupo      = pv_grupo
		and    no_cliente = pv_cliente;

    Lv_tipo_cliente      arccmc.tipo_cliente%type;
    Lv_tipo_cliente_dist arccmc.tipo_cliente%type;


BEGIN
	 Open  C_Tipo_Cliente;
   Fetch C_Tipo_Cliente into Lv_tipo_cliente;

   If C_Tipo_Cliente%notfound Then
  	  Close C_Tipo_Cliente;
  	  Lv_tipo_cliente := '%';
   else
  	  Close C_Tipo_Cliente;
   end if;

	 Open C_Distrib_grupo;  --- Se recupera el tipo de cliente de la tabla distribucion por grupo ANR 03/09/2009
	 Fetch C_Distrib_grupo into Lv_tipo_cliente_dist;

	 If C_Distrib_grupo%notfound Then
		  Close C_Distrib_grupo;
		 	Lv_tipo_cliente_dist := Lv_tipo_cliente;
	 else
		  Close C_Distrib_grupo;

		  If Lv_tipo_cliente_dist is null Then
			 	 Lv_tipo_cliente_dist := Lv_tipo_cliente;
		  end if;
	 end if;

for j in c_detalle_div(Lv_tipo_cliente_dist) loop
	 For i in C_Detalle (j.division,Lv_tipo_cliente_dist) Loop
       --- Verifico descuentos para escalas totales
       If verifica_escalas_totales (pv_cia,  --- Para escalas valida que cumpla la escala
    	                                 pv_factu,
                                       i.secuencia,
                                       i.linea,
                                       i.division_art) = TRUE
          and i.tipo_promocion in ('E') and i.cant_minima is not null Then

          pv_division:=i.division_art;
          pv_subdivision:=i.subdivision_art;
          pn_secuencia:= i.secuencia;
          pn_linea:= i.linea;
          pn_porc:=i.porc_descuento;
          pb_tiene:=true;

		      exit; --- si ya aplico a una escala no debe seguir verificando ANR 07/12/2009
       else
          pb_tiene:=false;
			 end if;
   End Loop;
end loop;

END pedido_tiene_escala;

FUNCTION verifica_escalas_totales   ( Pv_Cia             IN  Varchar2,
                                      Pv_pedido          IN  Varchar2,
	                                    Pn_sec_politica    IN  Number,
	                                    Pn_linea_Politica  IN  Number,
	                                    Pv_division_art    IN  Varchar2
	                                  ) Return Boolean IS


    Cursor C_Verif Is
      select nvl(cant_minima,1), nvl(cant_maxima,999999999) cant_maxima
      from   arfadet_politica_comercial
      where  no_cia    = Pv_Cia
      And    secuencia = Pn_sec_politica
      And    linea     = Pn_linea_politica;

		Cursor C_Detalle_Pedido_DivSubdiv Is
		 select nvl(sum(nvl(b.pedido,0)),0) cantidad
			from arfafec a, arfaflc b
			where a.no_cia      =  pv_cia
			and  a.no_factu    =  Pv_pedido
		  and (b.division    = Pv_division_art or Pv_division_art='%')
		  and ((exists
  		      (
  		        select u.no_cia from arfadet_politica_comercial_esc u
  		        where u.no_cia=b.no_cia and u.secuencia=pn_sec_politica
  		        and u.linea=pn_linea_politica and ind_activo='S'
  		      ) and b.subdivision in
  		        (select u.subdivision_art from arfadet_politica_comercial_esc u
  		         where u.no_cia=b.no_cia and u.secuencia=pn_sec_politica
  		          and u.linea=pn_linea_politica and ind_activo='S')) or
  		        (not exists
  		         (
  		          select u.no_cia from arfadet_politica_comercial_esc u
  		          where u.no_cia=b.no_cia and u.secuencia=pn_sec_politica
  		           and u.linea=pn_linea_politica and ind_activo='S'
  		         )
  		    ))
  	  and b.linea_art_promocion is null
			and a.no_cia      = b.no_cia
			and a.no_factu    = b.no_factu;

    Ln_cant_minima   arfadet_politica_comercial.cant_minima%type;
    Ln_cant_maxima   arfadet_politica_comercial.cant_maxima%type;
    Ln_cantidad      arfaflc.pedido%type;

 Begin
   Open C_Detalle_Pedido_DivSubdiv;
	 Fetch C_Detalle_Pedido_DivSubdiv into Ln_cantidad;
	 Close C_Detalle_Pedido_DivSubdiv;

   Open  C_Verif;
   Fetch C_Verif into Ln_cant_minima, Ln_cant_maxima;

   If C_Verif%notfound Then
      Close C_Verif;
      return (FALSE);
   else
      Close C_Verif;

		  If Ln_cantidad Between Ln_cant_minima and Ln_cant_maxima Then
         return (TRUE);
      else
     	   return (FALSE);
      end if;
   end if;
 End verifica_escalas_totales;
--fin add mlopez 15/06/2010
end FAPOLITICA_COMERCIAL;
/
