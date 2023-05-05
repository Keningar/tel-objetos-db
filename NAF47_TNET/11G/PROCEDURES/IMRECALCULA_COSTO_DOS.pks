create or replace procedure            IMRECALCULA_COSTO_DOS(Pv_Cia         IN  Varchar2,
                                                  Pv_embarque    IN  Varchar2,
                                                  Pd_Fecha       IN  Date,
                                                  Pn_tipo_cambio IN  Number,
                                                  Pv_Error       OUT Varchar2) is

/****   Se procedera a buscar todas las transacciones de ingreso y egreso
        las cuales seran ordenadas por fecha y hora de ingreso, a dichas
        transacciones se les modificara el Costo2.

        Dejar sentado claramente que son TODAS las transacciones de ingreso
        y egreso sin excepcion de ninguna clase, bodega o centro de distribucion
        de la compania.

        DOCUMENTO AL QUE APLICA: DRC_IM025 REcosteo factor 2 (LH)          *****/

--- ANR 17/04/2009

  Cursor C_Ingreso_Importaciones_INV Is
  select c.no_arti articulo_ingresa_inventario, c.time_stamp fecha_ingreso_inventario,
         d.fob * d.factor_2 costo2, /*b.monto2 / b.unidades costo_inventario,*/
         sum(d.cant_rec) unidades,
         c.no_embarque,
         c.no_docu
    from (select doc.no_cia, doc.no_docu, doc.no_embarque, mn.no_arti, min(time_stamp) time_stamp
            from arimencdoc doc, arinmn mn
           where doc.no_cia  = mn.no_cia
             and doc.no_docu = mn.no_docu
             and doc.no_embarque = Pv_embarque
             and doc.no_cia = pv_cia
           group by doc.no_cia, doc.no_docu, doc.no_embarque, mn.no_arti
         ) c, arimdetcosteo d
   where d.no_cia      = Pv_Cia
     and d.no_embarque = Pv_Embarque
     --and d.no_arti     = 'FE82/63'
     and c.no_cia      = d.no_cia
     and c.no_arti     = d.no_arti
     and c.no_embarque = d.no_embarque
   group by c.no_arti, c.time_stamp,
         d.fob * d.factor_2,
         c.no_embarque,
         c.no_docu
  Order by c.no_arti;

  Cursor C_Ingreso_Importaciones Is
  select c.no_arti articulo_ingresa_inventario, c.time_stamp fecha_ingreso_inventario,
         sum(d.cant_rec * d.fob * d.factor_2) costo2, /*b.monto2 / b.unidades costo_inventario,*/
         sum(d.cant_rec) unidades,
         c.no_embarque,
         c.no_docu
    from (select doc.no_cia, doc.no_docu, doc.no_embarque, mn.no_arti, min(time_stamp) time_stamp
            from arimencdoc doc, arinmn mn
           where doc.no_cia  = mn.no_cia
             and doc.no_docu = mn.no_docu
             and doc.no_embarque = Pv_embarque
             and doc.no_cia = pv_cia
           group by doc.no_cia, doc.no_docu, doc.no_embarque, mn.no_arti
         ) c, arimdetcosteo d
   where d.no_cia      = Pv_Cia
     and d.no_embarque = Pv_Embarque
     --and d.no_arti     = 'FE82/63'
     and c.no_cia      = d.no_cia
     and c.no_arti     = d.no_arti
     and c.no_embarque = d.no_embarque
   group by c.no_arti, c.time_stamp,
         c.no_embarque,
         c.no_docu
  Order by c.no_arti;


  Cursor C_Transacciones_Inventarios (Lv_no_arti Varchar2, Ld_Fecha_Inicio Date, Ld_Fecha_Fin Date) Is
  select b.movimi, b.interface, b.compra,
         a.no_arti articulo_transaccion,
         a.no_docu, decode(b.movimi,'E',a.unidades,-a.unidades) unidades,
         a.costo2,
         a.fecha fecha_transaccion
    from arinmn a, arinvtm b, arinbo c
   where a.no_cia   = Pv_Cia
     and a.no_arti  = Lv_no_arti
     and a.no_cia   = b.no_cia
     and a.tipo_doc = b.tipo_m
     and a.no_cia   = c.no_cia
     and a.bodega   = c.codigo
     and nvl(c.mal_estado,'N') = 'N' --- Para articulos en bodega de productos en mal estado no se debe recalcular el costo 2
     --and a.fecha between Ld_Fecha_Inicio and Ld_Fecha_Fin
     and a.time_stamp >= Ld_Fecha_Inicio
     and trunc(a.time_stamp) <= Ld_Fecha_Fin
   Order by a.time_stamp; ---- El time stamp es el unico campo que tiene fecha y hora.

  Cursor C_Act_CabH_Inv (Lv_no_docu Varchar2) Is
  select sum(a.monto2) total
    from arinmn a
   where a.no_cia   = Pv_Cia
     and a.no_docu  = Lv_no_docu;

  Cursor C_Act_Cab_Inv (Lv_no_docu Varchar2) Is
  select sum(a.monto2) total
    from arinml a
   where a.no_cia   = Pv_Cia
     and a.no_docu  = Lv_no_docu;

  Cursor C_Fecha_Recosteo Is
  select max(fecha)
    from arim_audit_recosteo
   where no_cia       = Pv_Cia
     and no_embarque  = Pv_embarque
     and fecha        = Pd_Fecha;

  Cursor C_Compania Is
  select ind_calendario
    from arinmc
   where  no_cia = Pv_cia;

  Cursor C_Calendario (Ln_anio Number) Is
  select 'X'
    from calendario
   where no_cia    = Pv_cia
     and ano       = Ln_anio;

  Cursor C_saldo_ant (pv_arti varchar2, pd_fecha date) Is
                      select sum(decode(td.movimi,'E',mn.unidades,-mn.unidades)) unidades,
                              sum(decode(td.movimi,'E',mn.monto2,-mn.monto2)) monto2
                         from arinmn mn, arinvtm td, arinbo bo
                        where mn.no_cia = Pv_cia
                          and mn.time_stamp < pd_fecha
                          and mn.no_arti = pv_arti
                          and bo.mal_estado = 'N'
                          and mn.no_cia=td.no_cia
                          and mn.tipo_doc=td.tipo_m
                          and mn.no_cia=bo.no_cia
                          and mn.bodega=bo.codigo;


  Ld_Fecha_recosteo  Date;
  Lv_calendario      ARINMC.ind_calendario%type;
  Lv_dummy           Varchar2(1);
  Lv_desc_calendario Varchar2(50);
  Ln_costo2          Number;
  Ln_anio            Number;
  Ln_total_HINV      Number;
  Ln_total_INV       Number;

  Lb_actualiza       Boolean := FALSE;
  Lb_encontro        Boolean := FALSE;

  Ln_costo2_ant      Number;
  Ln_unid_ant        Number;
  Ln_costo2_prom     Number;

  Lv_Error           Varchar2(500);
  ERROR_PROCESO      EXCEPTION;

begin

  Open  C_Compania;
  Fetch C_Compania into Lv_calendario;
  If C_Compania%notfound Then
   Close C_Compania;
     Lv_Error := 'No existe compania: '||Pv_Cia;
     raise error_proceso;
  else
   Close C_Compania;
  end if;

  If Lv_calendario is null Then
     Lv_Error := 'No existe configurado un calendario en la compania: '||Pv_Cia;
     raise error_proceso;
  end if;

  If Lv_calendario = 'S' then
   Lv_desc_calendario := 'SEMANAL';
  Elsif Lv_calendario = 'M' then
   Lv_desc_calendario := 'MENSUAL';
  end if;

  Ln_anio := to_number(to_char(Pd_fecha,'YYYY'));

  Open  C_Calendario (Ln_anio);
  Fetch C_Calendario into Lv_dummy;
  If C_Calendario%notfound Then
   Close C_Calendario;
     Lv_Error := 'No existe calendario: '||Lv_desc_calendario||' para la compania: '||Pv_Cia||' para el anio: '||Ln_anio;
     raise error_proceso;
  else
   Close C_Calendario;
  end if;
  /*
  Open  C_Fecha_Recosteo;
  Fetch C_Fecha_Recosteo into Ld_Fecha_Recosteo;
  If C_Fecha_Recosteo%notfound Then
   Close C_Fecha_Recosteo;
  else
   Close C_Fecha_Recosteo;
  end if;

  If Ld_Fecha_Recosteo is null Then
     Lv_Error := 'No existe fecha de recosteo';
     raise error_proceso;
  end if;
  */

  For i in C_Ingreso_Importaciones_INV Loop

      Update arinmn
         set costo2  = i.costo2,
             monto2  = i.costo2 * unidades
       Where no_cia  = Pv_cia
         and no_docu = i.no_docu
         and no_arti = i.articulo_ingresa_inventario
         and unidades = i.unidades
         and bodega  in
            (Select codigo
               From arinbo
              Where no_cia = Pv_cia
                and nvl(mal_estado,'N') = 'N');

      Open  C_Act_CabH_Inv (i.no_docu);
      Fetch C_Act_CabH_Inv into Ln_total_HINV;
      Close C_Act_CabH_Inv;

      Update arinmeh
         set mov_tot2 = Ln_total_HINV
       where no_cia  = Pv_cia
         and no_docu = i.no_docu;

      Update arinml
         set monto2     = Ln_costo2 * unidades,
             monto2_dol = (Ln_costo2 * unidades) * Pn_tipo_cambio
       Where no_cia     = Pv_cia
         and no_docu    = i.no_docu
         and no_arti    = i.articulo_ingresa_inventario
         and unidades   = i.unidades
         and bodega  in
            (Select codigo
               From arinbo
              Where no_cia = Pv_cia
                and nvl(mal_estado,'N') = 'N');

      Open  C_Act_Cab_Inv (i.no_docu);
      Fetch C_Act_Cab_Inv into Ln_total_INV;
      Close C_Act_Cab_Inv;

      Update arinme
         set mov_tot2 = Ln_total_INV
       where no_cia = Pv_cia
         and no_docu = i.no_docu;

  End Loop;


  Ld_Fecha_Recosteo := trunc(sysdate);

  For i in C_Ingreso_Importaciones Loop

      --- Cuando es otro articulo reinicio las variables por articulo

      Lb_actualiza := FALSE;
      Lb_encontro  := FALSE;

      Ln_unid_ant   :=0;
      Ln_costo2_ant :=0;
      Open  C_saldo_ant(i.articulo_ingresa_inventario, i.fecha_ingreso_inventario);
      fetch C_saldo_ant into Ln_unid_ant, Ln_costo2_ant;
      close C_saldo_ant;

      Ln_unid_ant   := nvl(Ln_unid_ant,0);
      if Ln_unid_ant = 0 then
         Ln_costo2_ant := 0;
      else
         Ln_costo2_ant := nvl(Ln_costo2_ant,0);
      end if;

      ln_costo2_prom := (Ln_costo2_ant+(i.costo2))/(Ln_unid_ant+i.unidades);
      Ln_unid_ant    := Ln_unid_ant + i.unidades;
      Ln_costo2      := ln_costo2_prom;

      For j in C_Transacciones_Inventarios (i.articulo_ingresa_inventario, i.fecha_ingreso_inventario, Ld_Fecha_Recosteo) Loop

          Lb_actualiza := FALSE;

          --- Para articulos en bodega de productos en mal estado no se debe recalcular el costo 2 ANR 20/04/2009
         If (nvl(j.interface,'XX') in ('IM','CO') and j.compra = 'S' and j.movimi = 'E') and
            (i.no_docu != j.no_docu) Then
            --(i.no_embarque != Pv_embarque) Then

               Lb_actualiza := FALSE;

         /*** Para el caso que sea ingreso por importaciones, debe promediar el costo 2
              se promedia el costo que ingresa en el recosteo con el costo del ingreso al inventario
              y no se actualiza la transaccion de ingreso al inventario, siempre y cuando el embarque
              sea diferente al que se recalcula ***/

              --Ln_costo2 := ((i.costo2 + i.costo_inventario) / 2 );

              Lb_encontro := TRUE;

              ln_costo2_prom := ((Ln_costo2*ln_unid_ant)+(j.costo2*j.unidades))/(Ln_unid_ant+j.unidades);
              ln_costo2 := ln_costo2_prom;

              ln_unid_ant := ln_unid_ant + j.unidades;

         elsif (nvl(j.interface,'XX') in ('IM','CO') and j.compra = 'S' and j.movimi = 'E') and
                (i.no_docu = j.no_docu) Then
                --(i.no_embarque = Pv_embarque) Then

                Lb_actualiza := FALSE;

          /*** Para el caso que sea ingreso por importaciones y sea del mismo embarque, entonces
               solamente se actualiza el valor del recalculo del costo 2 ***/
               /*
               If Lb_encontro = FALSE Then

                  Ln_costo2 := i.costo2;

                end if;
               */
         else

                Lb_actualiza := TRUE;

         /*** Para el caso de que no sea ingreso por importaciones, debe actualizar el costo 2 ***/

               --If Lb_encontro = FALSE Then

                  --Ln_costo2 := i.costo2;
                  Ln_costo2 := ln_costo2_prom;
               --end if;

               ln_unid_ant := ln_unid_ant + j.unidades;
         end if;

        /**** Actualiza las tablas de Inventarios donde se registra el costo 2 ****/
        /**** Actualiza en todas las bodegas de productos en buen estado       ***/

        If Lb_actualiza = TRUE Then

           Update arinmn
              set costo2  = Ln_costo2,
                  monto2  = Ln_costo2 * unidades
            Where no_cia  = Pv_cia
              and no_docu = j.no_docu
              and no_arti = j.articulo_transaccion
              and bodega  in
                  (Select codigo
                     From arinbo
                    Where no_cia = Pv_cia
                      and nvl(mal_estado,'N') = 'N');
           Open  C_Act_CabH_Inv (j.no_docu);
           Fetch C_Act_CabH_Inv into Ln_total_HINV;
           Close C_Act_CabH_Inv;

           Update arinmeh
              set mov_tot2 = Ln_total_HINV
            where no_cia = Pv_cia
              and no_docu = j.no_docu;

           Update arinml
              set monto2     = Ln_costo2 * unidades,
                  monto2_dol = (Ln_costo2 * unidades) * Pn_tipo_cambio
            Where no_cia     = Pv_cia
              and no_docu    = j.no_docu
              and no_arti    = j.articulo_transaccion
              and bodega  in
                 (Select codigo
                    From arinbo
                   Where no_cia = Pv_cia
                     and nvl(mal_estado,'N') = 'N');

           Open  C_Act_Cab_Inv (j.no_docu);
           Fetch  C_Act_Cab_Inv into Ln_total_INV;
           Close  C_Act_Cab_Inv;

           Update arinme
              set mov_tot2 = Ln_total_INV
            where no_cia = Pv_cia
              and no_docu = j.no_docu;

           Update arinha
              set ult_costo2 = costo_uni2,
                  costo_uni2 = Ln_costo2,
                  saldo_mo2  = Ln_costo2 * nvl(saldo_un,0)
            Where no_cia     = Pv_cia
              and no_arti    = j.articulo_transaccion
              and bodega  in
                   (Select codigo
                      From   arinbo
                     Where  no_cia = Pv_cia
                       and    nvl(mal_estado,'N') = 'N')
              and (ano, semana, ind_sem) in
                   (select ano, semana , indicador
                    from  calendario
                    where no_cia = Pv_Cia
                    and j.fecha_transaccion between fecha1 and fecha2);

       end if;


 End Loop;

--   If Lb_actualiza = TRUE Then

       Update arinlo
       set    costo2  = Ln_costo2
       Where  no_cia  = Pv_Cia
       and    no_arti = i.articulo_ingresa_inventario
        and   bodega  in
                       (Select codigo
                        From   arinbo
                        Where  no_cia = Pv_cia
                        and    nvl(mal_estado,'N') = 'N');

        Update arinma
        set    ult_costo2 = costo2,
               costo2     = Ln_costo2,
               monto2     = Ln_costo2 * (sal_ant_un + comp_un - vent_un + otrs_un - cons_un)
        Where  no_cia     = Pv_cia
        and    no_arti    = i.articulo_ingresa_inventario
        and    bodega  in
                       (Select codigo
                        From   arinbo
                        Where  no_cia = Pv_cia
                        and    nvl(mal_estado,'N') = 'N');

        Update arinda
        set    ultimo_costo2   = costo2_unitario,
               costo2_unitario = Ln_costo2
        Where  no_cia          = Pv_cia
        and    no_arti         = i.articulo_ingresa_inventario;

 --end if;

End loop;


EXCEPTION
 WHEN ERROR_PROCESO THEN
 Pv_error := Lv_Error;
 WHEN OTHERS THEN
 Pv_error := 'Error al ejecutar proceso IMRECALCULA_COSTO_DOS '||SQLERRM;
end IMRECALCULA_COSTO_DOS;