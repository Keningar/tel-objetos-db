CREATE OR REPLACE package            INRECALCULA_ARINHA is

  -- Author  : Antonio Navarrete
  -- Created : 6/4/2010 9:39:50 AM
  -- Purpose : Recalcular la tabla ARINHA

 procedure REPROCESA(Pv_cia   IN Varchar2,
                     Pv_Error OUT Varchar2);


 --- Crea o actualizar ARINHA_REPROCESO

 procedure ACT_ARINHA_REPROCESO (Pv_cia      IN Varchar2, Pv_arti   IN Varchar2,
                                 Pv_bodega   IN Varchar2, Pv_centro IN Varchar2,
                                 Pn_ano      IN Number,   Pn_semana IN Number,   Pv_ind_sem IN Varchar2,
                                 Pn_unidades IN Number,
                                 Pn_costo1   IN Number,   Pn_costo2 IN Number,
                                 Pn_monto1   IN Number,   Pn_monto2 IN Number,
                                 Pv_Error    OUT Varchar2);

 --- Crea o actualizar ARINMA_REPROCESO

 procedure ACT_ARINMA_REPROCESO (Pv_cia      IN Varchar2, Pv_arti   IN Varchar2,
                                 Pv_bodega   IN Varchar2,
                                 Pn_unidades IN Number,
                                 Pn_costo1   IN Number,   Pn_costo2 IN Number,
                                 Pn_monto1   IN Number,   Pn_monto2 IN Number,
                                 Pv_Error    OUT Varchar2);

end INRECALCULA_ARINHA;
/


CREATE OR REPLACE package body            INRECALCULA_ARINHA is

      procedure REPROCESA(Pv_cia IN Varchar2, Pv_Error OUT Varchar2) is

      /**** EN BASE AL CALENDARIO DE INVENTARIOS *****/

      Cursor C_Arti Is
       select distinct no_arti from arinmn where no_cia = Pv_cia;--- Procesa articulos con movimientos en Inventarios

      Cursor C_Calendario Is
        select b.ano, b.semana, b.indicador ind_sem, b.mes, b.fecha2
        from   calendario b
        where  b.no_cia  = Pv_cia
        and    b.fecha2 between '31/05/2009' and '21/05/2010'
        --- desde esta fecha hay transacciones y empiezo a crear ARINHA_TEMPORAL
        --- Poner las fechas en que terminan las semanas
        order by b.ano * 100 + b.semana, to_number(b.indicador) asc;

      Cursor C_Movimiento (Ld_fecha Date, Lv_arti Varchar2) Is
        select a.bodega, a.centro,
               nvl(sum(decode(b.movimi,'E',a.unidades,a.unidades * -1)),0) unidades,
               nvl(sum(decode(b.movimi,'E',a.monto,a.monto * -1)),0) monto1,
               nvl(sum(decode(b.movimi,'E',a.monto2,a.monto2 * -1)),0) monto2
        from   arinmn a, arinvtm b, arinmeh c
        where  a.no_cia   = Pv_cia
        and    a.no_arti  = Lv_arti
        and    trunc(a.fecha) <= Ld_fecha
        and    a.no_cia   = b.no_cia
        and    a.tipo_doc = b.tipo_m
        and    a.no_cia   = c.no_cia
        and    a.no_docu  = c.no_docu
        group by a.bodega, a.centro;

        Cursor C_Arinma_reproceso (Lv_arti Varchar2) Is
          select a.bodega, b.centro, a.stock, a.costo_uni, a.costo2, a.monto, a.monto2
          from  arinma_reproceso a, arinbo b
          where a.no_cia  = Pv_cia
          and   a.no_arti = Lv_arti
          and   a.no_cia  = b.no_cia
          and   a.bodega  = b.codigo;

         Ln_costo_unitario  Arinma.costo_uni%type;
         Ln_costo2_unitario Arinma.costo2%type;
         Ln_monto1          Arinmn.monto%type;
         Ln_monto2          Arinmn.monto2%type;
         Ln_unidades        Arinmn.unidades%type;

         Lv_Error           Varchar2(500);
         Error_proceso      Exception;

      begin

        delete ARINHA_reproceso;
        delete ARINMA_reproceso;
        commit;

         /*** PROCESO PARA PRODUCTOS EN BUEN ESTADO ***/

         Ln_costo_unitario  := 0;
         Ln_costo2_unitario := 0;
         Ln_monto1          := 0;
         Ln_monto2          := 0;
         Ln_unidades        := 0;

        For b in C_Arti Loop

            For i in C_Calendario Loop

             For j in C_Movimiento (i.fecha2, b.no_arti) Loop

                      Ln_monto1   := j.monto1;
                      Ln_monto2   := j.monto2;
                      Ln_unidades := j.unidades;


                      --- Se pone valor absoluto al monto porque puede darse el caso de montos en negativo con diferencias pequenas y
                      --- que tengan unidades mayor a cero
                      --- Monto 2 no puede ser menor a cero Anio: 2010 semana: 9 Ind. sem.: 1 Arti: 30527 Centro: 01 Bodega: LHGP

                      --- Si unidades es cero, el costo es el anterior

                      If Ln_unidades != 0 Then
                         Ln_costo_unitario  := Ln_monto1/Ln_unidades;
                         Ln_costo_unitario  := abs(Ln_costo_unitario);
                      end if;

                      If Ln_unidades != 0 Then
                          Ln_costo2_unitario := Ln_monto2/Ln_unidades;
                          Ln_costo2_unitario  := abs(Ln_costo2_unitario);
                      end if;

                      /*** Puede darse el caso de que si sumo ARINMN los montos de una
                           diferencia en negativo. Ejemplo>
                      El monto1 es menor a cero. Anio: 2009 semana: 36 Ind. sem.: 1 Arti: H16065 Centro: 01 Bodega: LHGP

                      BODEGA CENTRO STOCK MONTO1 MONTO2
                      LHGP	   01	   0	  0	       -0.02
                      LHQP	   02	   0	  -0.01   	0
                      LHQT	   02	   0	  0	        0

                      para este caso actualizo el monto en cero
                      porque despues me de error en ARINHA. ***/

                      --- Se van a desactivar los checks del monto porque si se puede dar este caso

                      --- Guardo en una tabla temporal, parecida a la de ARINMA los costos y stock por bodega y articulo

                      ACT_ARINMA_REPROCESO (Pv_cia, b.no_arti,
                                            j.bodega,
                                            Ln_unidades,
                                            Ln_costo_unitario, Ln_costo2_unitario,
                                            Ln_monto1, Ln_monto2, Lv_Error);

                           If Lv_Error is not null Then
                              raise Error_proceso;
                           end if;

                      --- Como si tiene movimientos en inventarios en esa semana, entonces inserta o actualiza en ARINHA_REPROCESO

                      ACT_ARINHA_REPROCESO (Pv_cia, b.no_arti,
                                            j.bodega, j.centro,
                                            i.ano, i.semana, i.ind_sem,
                                            Ln_unidades,
                                            Ln_costo_unitario, Ln_costo2_unitario,
                                            Ln_monto1, Ln_monto2, Lv_Error);

                           If Lv_Error is not null Then
                              raise Error_proceso;
                           end if;

             End Loop;

              --- En base a una tabla temporal parecida a la de ARINMA voy registrando los costos para semanas que no tienen movimientos

               For m in C_Arinma_reproceso (b.no_arti) Loop

                  --- Como no tiene movimientos en inventarios en esa semana, entonces inserta o actualiza en ARINHA_REPROCESO

                  ACT_ARINHA_REPROCESO (Pv_cia, b.no_arti,
                                        m.bodega, m.centro,
                                        i.ano, i.semana, i.ind_sem,
                                        m.stock,
                                        m.costo_uni, m.costo2,
                                        m.monto, m.monto2, Lv_Error);

                           If Lv_Error is not null Then
                              raise Error_proceso;
                           end if;

               End Loop;

            End Loop;

         commit; ---- Graba por cada uno de los articulos procesados

        End Loop;

      Exception
       When Error_proceso Then
        Pv_Error := Lv_Error;
        Rollback;
       When Others Then
        Pv_Error := 'Error en REPROCESO ARINHA '||SQLERRM;
        Rollback;
      end REPROCESA;

     Procedure ACT_ARINHA_REPROCESO (Pv_cia      IN Varchar2, Pv_arti   IN Varchar2,
                                     Pv_bodega   IN Varchar2, Pv_centro IN Varchar2,
                                     Pn_ano      IN Number,   Pn_semana IN Number,   Pv_ind_sem IN Varchar2,
                                     Pn_unidades IN Number,
                                     Pn_costo1   IN Number,   Pn_costo2 IN Number,
                                     Pn_monto1   IN Number,   Pn_monto2 IN Number,
                                     Pv_Error    OUT Varchar2) is


        Cursor C_Existe_Arinha Is
          select 'X'
          from  arinha_reproceso
          where no_cia  = Pv_cia
          and   no_arti = Pv_arti
          and   bodega  = Pv_bodega
          and   centro  = Pv_centro
          and   ano     = Pn_ano
          and   semana  = Pn_semana
          and   ind_sem = Pv_ind_sem;

         Lv_dummy           Varchar2(1);

         Lv_Error           Varchar2(500);
         Error_proceso      Exception;

        Begin

           Open C_Existe_Arinha;
           Fetch C_Existe_Arinha into Lv_dummy;
           If C_Existe_Arinha%notfound Then
           Close C_Existe_Arinha;

            Begin
            Insert into ARINHA_REPROCESO (no_cia, centro, ano, semana, ind_sem, bodega, no_arti,
                                          ult_costo, saldo_un, saldo_mo, costo_uni, aju_ini_reproceso,
                                          ult_costo2, saldo_mo2, costo_uni2)
                                  Values (Pv_cia, Pv_centro, Pn_ano, Pn_semana, Pv_ind_sem, Pv_bodega, Pv_arti,
                                          0, Pn_unidades, Pn_monto1, Pn_costo1, 0,
                                          0, Pn_monto2, Pn_costo2);
             Exception
             When Others Then
              Lv_Error := 'Error al crear ARINHA_REPROCESO. Anio: '||Pn_ano||' semana: '||Pn_semana||' Ind. sem.: '||Pv_ind_sem||' Arti: '||Pv_Arti||' Centro: '||Pv_centro||' Bodega: '||Pv_bodega||' '||SQLERRM;
              raise Error_proceso;
             end;

           else
           Close C_Existe_Arinha;

              Begin
               Update ARINHA_REPROCESO
                    Set    saldo_mo    = Pn_monto1,
                           saldo_mo2   = Pn_monto2,
                           saldo_un    = Pn_unidades,
                           costo_uni   = Pn_costo1,
                           costo_uni2  = Pn_costo2
                    where  no_cia      = Pv_cia
                    and    ano         = Pn_ano
                    and    semana      = Pn_semana
                    and    ind_sem     = Pv_ind_sem
                    and    no_arti     = Pv_arti
                    and    centro      = Pv_centro
                    and    bodega      = Pv_bodega;
             Exception
             When Others Then
              Lv_Error := 'Error al actualizar ARINHA_REPROCESO. Anio: '||Pn_ano||' semana: '||Pn_semana||' Ind. sem.: '||Pv_ind_sem||' Arti: '||Pv_Arti||' Centro: '||Pv_centro||' Bodega: '||Pv_bodega||' '||SQLERRM;
              raise Error_proceso;
             end;

           end if;

      Exception
       When Error_proceso Then
        Pv_Error := Lv_Error;
       When Others Then
        Pv_Error := 'Error en ACT_ARINHA_REPROCESO '||SQLERRM;
      end ACT_ARINHA_REPROCESO;

      Procedure ACT_ARINMA_REPROCESO (Pv_cia      IN Varchar2,  Pv_arti   IN Varchar2,
                                      Pv_bodega   IN Varchar2,
                                      Pn_unidades IN Number,
                                      Pn_costo1   IN Number,    Pn_costo2 IN Number,
                                      Pn_monto1   IN Number,    Pn_monto2 IN Number,
                                      Pv_Error    OUT Varchar2) is


        Cursor C_Existe_Arinma Is
          select 'X'
          from  arinma_reproceso
          where no_cia  = Pv_cia
          and   no_arti = Pv_arti
          and   bodega  = Pv_bodega;

         Lv_dummy           Varchar2(1);

         Lv_Error           Varchar2(500);
         Error_proceso      Exception;

        Begin


           Open C_Existe_Arinma;
           Fetch C_Existe_Arinma into Lv_dummy;
           If C_Existe_Arinma%notfound Then
           Close C_Existe_Arinma;

             Begin
             Insert into arinma_reproceso (no_cia, bodega, no_arti, stock, monto, costo_uni, costo2, monto2)
                                   Values (Pv_cia, Pv_bodega, Pv_arti, Pn_unidades, Pn_monto1, Pn_costo1, Pn_costo2, Pn_monto2);

             Exception
             When Others Then
              Lv_Error := 'Error al crear ARINMA_REPROCESO. Arti: '||Pv_Arti||' Bodega: '||Pv_bodega||' '||SQLERRM;
              raise Error_proceso;
             end;

           else
           Close C_Existe_Arinma;

             Begin

               Update arinma_reproceso
               Set    stock     = Pn_unidades,
                      monto     = Pn_monto1,
                      costo_uni = Pn_costo1,
                      monto2    = Pn_monto2,
                      costo2    = Pn_costo2
               Where  no_cia    = Pv_cia
               and    bodega    = Pv_bodega
               and    no_arti   = Pv_arti;

             Exception
             When Others Then
              Lv_Error := 'Error al actualizar ARINMA_REPROCESO. Arti: '||Pv_Arti||' Bodega: '||Pv_bodega||' '||SQLERRM;
              raise Error_proceso;
             end;

           end if;
      Exception
       When Error_proceso Then
        Pv_Error := Lv_Error;
       When Others Then
        Pv_Error := 'Error en ACT_ARINMA_REPROCESO '||SQLERRM;
      end ACT_ARINMA_REPROCESO;


end INRECALCULA_ARINHA;
/
