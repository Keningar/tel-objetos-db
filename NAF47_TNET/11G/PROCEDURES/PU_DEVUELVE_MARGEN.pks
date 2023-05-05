create or replace procedure            PU_DEVUELVE_MARGEN(Pv_cia           in varchar2,
                                               Pv_centro        in varchar2,
                                               Pv_div_comer     in varchar2,
                                               Pv_tip_cli       in varchar2,
                                               Pv_grupo         in varchar2,
                                               Pv_cliente       in varchar2,
                                               Pv_subcliente    in varchar2,
                                               Pv_div_arti      in varchar2,
                                               Pv_sub_div_arti  in varchar2,
                                               Pv_articulo      in varchar2,
                                               Pn_margen1       out number,
                                               Pn_margen2       out number,
                                               Pn_descuento     out number,
                                               Pv_bandera        in varchar2,
                                               Pv_error         out varchar2) Is


Cursor C_Margen_menor Is
  select porc_minimo, porc_esperado
   from arfamargen_exc_divsub
   where no_cia          = Pv_cia
     and division        = Pv_div_arti
     and subdivision     = Pv_sub_div_arti
     and no_arti         = Pv_articulo
     and nvl(estado,'A') = 'A'
UNION
   select porc_minimo, porc_esperado
   From arfamargen_exc_cliente
   where no_cia       = Pv_cia
     and (division_comercial = Pv_div_comer or division_comercial = '%')
     and (tipo_cliente = Pv_tip_cli or tipo_cliente = '%')
     and (grupo        = Pv_grupo or grupo = '%')
     and (no_cliente   = Pv_cliente or no_cliente = '%')
     and (subcliente   = Pv_subcliente or subcliente = '%')
     and division_art = Pv_div_arti  ---  desde la forma siempre viene con datos diferente a %
     and (subdivision_art='%' or subdivision_art = Pv_sub_div_arti)
     and (no_arti='%' or no_arti      = Pv_articulo)
     and nvl(estado,'A') = 'A'
UNION
  select porc_minimo, porc_esperado---, descuento_maximo
       from arfamargen_div_subdiv
       where no_cia      =  Pv_cia
         and division    = Pv_div_arti ---  desde la forma siempre viene con datos diferente a %
         and (subdivision = Pv_sub_div_arti or subdivision = '%')
         and nvl(estado,'A') = 'A'
UNION
  select porc_minimo, porc_esperado---, descuento_maximo
       From arfamargen_cliente
       where no_cia       = Pv_cia
         and (division_comercial = Pv_div_comer or division_comercial = '%')
         and (tipo_cliente = Pv_tip_cli or tipo_cliente = '%')
         and (grupo        = Pv_grupo or grupo = '%')
         and (no_cliente   = Pv_cliente or no_cliente = '%')
         and (subcliente   = Pv_subcliente or subcliente = '%')
         and nvl(estado,'A') = 'A'
order by 1 asc;

Cursor C_Descuento_maximo Is
  select descuento_maximo
   from arfamargen_exc_divsub
   where no_cia          = Pv_cia
     and division        = Pv_div_arti
     and subdivision     = Pv_sub_div_arti
     and no_arti         = Pv_articulo
     and nvl(estado,'A') = 'A'
UNION
   select descuento_maximo
   From arfamargen_exc_cliente
   where no_cia       = Pv_cia
     and (division_comercial = Pv_div_comer or division_comercial = '%')
     and (tipo_cliente = Pv_tip_cli or tipo_cliente = '%')
     and (grupo        = Pv_grupo or grupo = '%')
     and (no_cliente   = Pv_cliente or no_cliente = '%')
     and (subcliente   = Pv_subcliente or subcliente = '%')
     and division_art = Pv_div_arti  ---  desde la forma siempre viene con datos diferente a %
     and (subdivision_art='%' or subdivision_art = Pv_sub_div_arti)
     and (no_arti='%' or no_arti      = Pv_articulo)
     and nvl(estado,'A') = 'A'
UNION
  select descuento_maximo
       from arfamargen_div_subdiv
       where no_cia      =  Pv_cia
         and division    = Pv_div_arti ---  desde la forma siempre viene con datos diferente a %
         and (subdivision = Pv_sub_div_arti or subdivision = '%')
         and nvl(estado,'A') = 'A'
UNION
  select descuento_maximo
       From arfamargen_cliente
       where no_cia       = Pv_cia
         and (division_comercial = Pv_div_comer or division_comercial = '%')
         and (tipo_cliente = Pv_tip_cli or tipo_cliente = '%')
         and (grupo        = Pv_grupo or grupo = '%')
         and (no_cliente   = Pv_cliente or no_cliente = '%')
         and (subcliente   = Pv_subcliente or subcliente = '%')
         and nvl(estado,'A') = 'A'
order by 1 desc;

  Le_error        exception;
  Lv_mensaje      varchar2(1000):=null;

Begin
    --Validacion de Parametros de entrada
    If Pv_cia is null then
     Lv_mensaje:= 'No esta ingresando la compa?ia, favor verifique el llamado del procedimiento';
     raise Le_error;
    End If;

    If Pv_div_comer is null then
     Lv_mensaje:= 'No esta la division comercial';
     raise Le_error;
    End If;

    If Pv_tip_cli is null then
     Lv_mensaje:= 'No esta ingresando el tipo de cliente';
     raise Le_error;
    End If;

    If Pv_grupo is null then
     Lv_mensaje:= 'No esta ingresando el grupo';
     raise Le_error;
    End If;

    If Pv_cliente is null then
     Lv_mensaje:= 'No esta ingresando el codigo del cliente';
     raise Le_error;
    End If;

    If Pv_subcliente is null then
     Lv_mensaje:= 'No esta ingresando el codigo del sub-cliente';
     raise Le_error;
    End If;

    --- Tengo que verificar el margen minimo disponible entre las 4 consultas ANR 19/02/2010

    Open C_Margen_menor;
    Fetch C_Margen_menor into Pn_margen1, Pn_margen2;---, Pn_descuento;
    If C_Margen_menor%notfound Then
     Close C_Margen_menor;

        --- En el caso de que no exista nada configurado se debe enviar
        --- nulo para que no se valide contra los margenes ANR 23/10/2009
        --- No puedo restringir a cero porque pueden existir margenes negativos ANR 23/10/2009
        Pn_margen1   := null;
        Pn_margen2   := null;

     else
     Close C_Margen_menor;
    end if;

    --- Tengo que verificar el maximo descuento disponible entre las 4 consultas ANR 22/02/2010

    Open C_Descuento_maximo;
    Fetch C_Descuento_maximo into Pn_descuento;
    If C_Descuento_maximo%notfound Then
     Close C_Descuento_maximo;
        --- El descuento si no existe configurado lo minimo debe ser cero ANR 23/10/2009
       Pn_descuento := 0;
     else
     Close C_Descuento_maximo;
    end if;

Exception
 When Le_error then
   Pv_error := Lv_mensaje;
 When Others Then
   Pv_error := sqlerrm;
End PU_DEVUELVE_MARGEN;