create or replace PROCEDURE            INcosto_Uni (pNo_cia     in varchar2,
                                         pBodega     in varchar2,
                                         pNo_arti    in varchar2,
                                         pCantidad   in number,   --- Cantidad que ingresa en la importacion, reordenamiento o compra local
                                         PCosto1     in number,   --- Costo 1 de la transaccion (6 decimales)
                                         pCosto2     in number,   --- Costo 2 de la transaccion (6 decimales)
                                         msg_error_p in out varchar2) Is

  Cursor c_datos_arti_consolidado Is
    Select sum(sal_ant_un + comp_un - vent_un  - cons_un + otrs_un) stock
      From arinma
     Where no_cia  = pno_cia
       And no_arti = pno_arti
       and bodega  NOT in  (select codigo --- No debe considerar datos de bodega de productos en mal estado
                            from  arinbo
                            where no_cia = pno_cia
                            and   nvl(mal_estado,'N') = 'S');

  Cursor c_datos_arti Is
    Select rowid, no_cia, bodega, no_arti, costo_uni, costo2,
           sal_ant_un, comp_un, vent_un, cons_un, otrs_un
      From arinma
     Where no_cia  = pno_cia
       And bodega  = pbodega
       And no_arti = pno_arti;
  --
  Cursor c_grupo_contable(pno_cia  grupos.no_cia%type,
                          pArti    arinda.no_arti%type) Is
    Select g.metodo_costo, d.costo_estandar
      From arinda d, grupos g
     Where d.no_cia  = pNo_cia
       And d.no_arti = pArti
       And g.no_cia  = d.no_cia
       And g.grupo   = d.grupo;

  --- Si es una bodega en mal estado, hace el proceso normal, caso contrario hace el costo unificado 09/03/2009 FEM
  Cursor C_bodega Is
    select nvl(mal_estado,'N')
      from arinbo
     where no_cia = pno_cia
       and codigo = pBodega;

  Cursor C_bodega_control Is
    select nvl(reserva,'N')
      from arinbo
     where no_cia = pno_cia
       and codigo = pBodega;


  vregArti                c_datos_arti%rowtype;
  vunidades               arinma.sal_ant_un%type := 0;
  vencontro               Boolean;
  vcosto_uni              arinma.costo_uni%type;
  vcosto_uni2             arinma.costo2%type;
  vMet_cost               grupos.metodo_costo%type;
  vCost_est               arinda.costo_estandar%type;
  lv_mal_estado_bodega    arinbo.mal_estado%type := 'N';
  lv_control_bodega       arinbo.reserva%type := 'N';
  Error_Proceso           Exception;
  vmsg_error              Varchar2(500);

Begin
  --
  Open C_bodega;
  Fetch C_bodega into lv_mal_estado_bodega;
  If C_bodega%notfound then
   Close C_bodega;
    msg_error_p := 'No existe la bodega: '||pBodega||'';
    Return;
  else
   Close C_Bodega;
  end if;

  Open C_bodega_control;
  Fetch C_bodega_control into lv_control_bodega;
  If C_bodega_control%notfound then
   Close C_bodega_control;
    msg_error_p := 'No existe la bodega: '||pBodega||'';
    Return;
  else
   Close C_bodega_control;
  end if;

/**** TRANSACCIONES QUE SE DEBEN COSTEAR SON: ENTRADA DE IMPORTACION, ENTRADA DE COMPRAS LOCALES, ENTRADA POR REORDENAMIENTO ****/

  If ( nvl(lv_mal_estado_bodega,'N') = 'S'   OR   nvl(lv_control_bodega,'N') = 'S' )  then

    /** CUANDO ES DE BODEGA EN MAL ESTADO o control SOLO SE CONSIDERA EL STOCK DE ESA BODEGA **/
    Open c_grupo_contable(pNo_cia, pNo_arti);
    Fetch c_grupo_contable Into vmet_cost, vcost_est;
    vencontro := c_grupo_contable%Found;
    Close c_grupo_contable;
    --
    If Not vencontro or (vmet_cost = 'E' and vcost_est is null) Then
       msg_error_p := 'El articulo '|| pNo_arti ||' no tiene definido Costo Estandar';
       Return;
    End If;
    --
    Open c_datos_arti;
    Fetch c_datos_arti Into vregArti;
    vencontro := c_datos_arti%Found;
    Close c_datos_arti;
    --
    If Not vencontro Then
       msg_error_p := 'El articulo '|| pNo_arti ||' no esta definido';
       Return;
    End If;
    --

    /**** FORMULA PARA EL CALCULO DEL COSTO PROMEDIO EN BODEGA DE PRODUCTOS DE MAL ESTADO
    ((COSTO UNITARIO PROMEDIO ARINMA * STOCK BODEGA MAL ESTADO) + (COSTO UNITARIO TRANSACCION * CANTIDAD TRANSACCION)) /  (STOCK BODEGA MAL ESTADO + CANTIDAD TRANSACCION)
    ANR 16/06/2010
    ****/

    --- Obtengo el STOCK BODEGA MAL ESTADO
    vunidades := nvl(vregArti.sal_ant_un,0) + nvl(vregArti.comp_un,0) -
                 nvl(vregArti.vent_un,0) - nvl(vregArti.cons_un,0) +
                 nvl(vregArti.otrs_un,0);
    --

   If vunidades + Pcantidad = 0 Then

    vcosto_uni  :=  vregArti.costo_uni;
    vcosto_uni2 :=  vregArti.costo2;

   else

    vcosto_uni  := ((vregArti.costo_uni * vunidades) + (PCosto1 * Pcantidad))/(vunidades + Pcantidad);
    vcosto_uni2 := ((vregArti.costo2    * vunidades) + (PCosto2 * Pcantidad))/(vunidades + Pcantidad);

    end if;

    --
    Update arinma
       Set ult_costo  = costo_uni,
           costo_uni  = decode(vMet_cost, 'P',vcosto_uni, vcost_est),
           ult_costo2 = costo2,
           costo2     = vcosto_uni2
     Where rowid      = vregArti.rowid;
    --
    --- No es necesario actualizar arinda porque no corresponde a costeo global
    --- Se agregan validaciones para el costo promedio de que no puedan ser cero ANR 20/02/2010

    If vMet_cost = 'P' and vcosto_uni = 0 Then
      vmsg_error := 'El nuevo costo promedio no puede ser cero, para el articulo: '||vregArti.no_arti||' Bodega: '||vregArti.bodega;
      raise Error_proceso;
    end if;

    If vMet_cost != 'P' and vcost_est = 0 Then
      vmsg_error := 'El nuevo costo promedio estandar no puede ser cero, para el articulo: '||vregArti.no_arti||' Bodega: '||vregArti.bodega;
      raise Error_proceso;
    end if;

    If vcosto_uni2 = 0 Then
      vmsg_error := 'El nuevo costo promedio2 no puede ser cero, para el articulo: '||vregArti.no_arti||' Bodega: '||vregArti.bodega;
      raise Error_proceso;
    end if;

    If vMet_cost = 'P' and vcosto_uni > vcosto_uni2 Then
      vmsg_error := 'El nuevo costo promedio: '||vcosto_uni ||' no puede ser mayor al nuevo costo promedio 2: '||pcosto2||' , para el articulo: '||vregArti.no_arti||' Bodega: '||vregArti.bodega;
      raise Error_proceso;
    end if;

    If vMet_cost != 'P' and vcost_est > vcosto_uni2 Then
      vmsg_error := 'El nuevo costo promedio estandar: '||vcost_est||' no puede ser mayor al nuevo costo promedio 2: '||pcosto2||' , para el articulo: '||vregArti.no_arti||' Bodega: '||vregArti.bodega;
      raise Error_proceso;
    end if;


 Else

    /*** CUANDO ES DE BODEGA DE PRODUCTOS EN BUEN ESTADO SE CONSIDERAN TODAS LAS BODEGAS MENOS LAS DE MAL ESTADO ***/

    --
    Open c_grupo_contable(pNo_cia,  pNo_arti);
    Fetch c_grupo_contable Into vmet_cost, vcost_est;
    vencontro := c_grupo_contable%Found;
    Close c_grupo_contable;

    --
    If Not vencontro or (vmet_cost = 'E' and vcost_est is null) Then
      msg_error_p := 'El articulo '|| pNo_arti ||' no tiene definido Costo Estandar';
      Return;
    End If;

    --
    Open c_datos_arti_consolidado;
    Fetch c_datos_arti_consolidado Into vUnidades;
    Close c_datos_arti_consolidado;

    Open c_datos_arti;
    Fetch c_datos_arti Into vregArti;
    vencontro := c_datos_arti%Found;
    Close c_datos_arti;
    --
    If Not vencontro Then
       msg_error_p := 'El articulo '|| pNo_arti ||' no esta definido';
       Return;
    End If;

    /**** FORMULA PARA EL CALCULO DEL COSTO PROMEDIO EN BODEGA DE PRODUCTOS DE BUEN ESTADO
    ((COSTO UNITARIO PROMEDIO ARINMA * STOCK TODAS BODEGAS MENOS MAL ESTADO) + (COSTO UNITARIO TRANSACCION * CANTIDAD TRANSACCION)) /  (STOCK TODAS BODEGAS MENOS MAL ESTADO + CANTIDAD TRANSACCION)
    ANR 16/06/2010
    ****/

   If vunidades + Pcantidad = 0 Then

    vcosto_uni  :=  vregArti.costo_uni;
    vcosto_uni2 :=  vregArti.costo2;

   else

    vcosto_uni  := ((vregArti.costo_uni * vunidades) + (PCosto1 * Pcantidad))/(vunidades + Pcantidad);
    vcosto_uni2 := ((vregArti.costo2    * vunidades) + (PCosto2 * Pcantidad))/(vunidades + Pcantidad);

    end if;

    --
    Update arinma
       Set ult_costo = costo_uni,
           costo_uni = decode(vMet_cost, 'P', vcosto_uni, vcost_est),
           ult_costo2 = costo2,
           costo2     = vcosto_uni2
     Where no_cia     = pno_cia
       and no_arti    = pno_arti
       and bodega  NOT IN  (select codigo --- No debe considerar datos de bodega de productos en mal estado
                            from  arinbo
                            where no_cia = pno_cia
                            and   nvl(mal_estado,'N') = 'S'
                            AND   nvl(reserva,'N') = 'S' );  -- Bodega de Control
    --
    --- ANR 20-04-2009 Para que de una vez actualice ARINDA
    --- Solo aqui actualiza arinda porque es costeo global

    Update arinda
       Set ultimo_costo    = costo_unitario,
           costo_unitario  = decode(vMet_cost, 'P',vcosto_uni,vcost_est),
           ultimo_costo2   = costo2_unitario,
           costo2_unitario = vcosto_uni2
     Where no_cia          = pno_cia
       and no_arti         = pno_arti;


    --- Se agregan validaciones para el costo promedio de que no puedan ser cero ANR 20/02/2010

    If vMet_cost = 'P' and vcosto_uni = 0 Then
      vmsg_error := 'El nuevo costo promedio global no puede ser cero, para el articulo: '||pno_arti;
      raise Error_proceso;
    end if;

    If vMet_cost != 'P' and vcost_est = 0 Then
      vmsg_error := 'El nuevo costo promedio global estandar no puede ser cero, para el articulo: '||pno_arti;
      raise Error_proceso;
    end if;

    If vcosto_uni2 = 0 Then
      vmsg_error := 'El nuevo costo promedio2 global no puede ser cero, para el articulo: '||pno_arti;
      raise Error_proceso;
    end if;

   If vMet_cost = 'P' and vcosto_uni > vcosto_uni2 Then
      --cOMENTADOTO POR MANUEL YUQUILIMA 2010-03-12
      --vmsg_error := 'El nuevo costo promedio: '||vcosto_uni||' no puede ser mayor al nuevo costo promedio 2 global: '||vcosto_uni2||' , para el articulo: '||pno_arti;
      --raise Error_proceso;
      NULL;
    end if;

    If vMet_cost != 'P' and vcost_est > vcosto_uni2 Then
      vmsg_error := 'El nuevo costo promedio estandar: '||vcost_est||' no puede ser mayor al nuevo costo promedio 2 global: '||vcosto_uni2||' , para el articulo: '||pno_arti;
      raise Error_proceso;
    end if; --

End If;

Exception
When Error_Proceso Then
 msg_error_p := vmsg_error;
When Others Then
 msg_error_p := 'Error al calcular costo promedio '||sqlerrm;
End;