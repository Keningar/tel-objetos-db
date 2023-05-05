create or replace function            inverifica_costos (Pv_cia IN Varchar2, Pv_arti IN Varchar2) return Varchar2 Is

/*** Funcion que me permite verificar que los costos de ARINMA de las bodegas en buen estado, sean
     igual a los costos de ARINDA
     Esta funcion es de importancia que se invoque antes de cualquier afectacion del costo del inventario,
     para asegurarse de que los costos de ARINDA y ARINMA esten iguales
     ANR 26/11/2009  ****/

Cursor C_Arinma Is
 select costo_uni costo_arinma,
        (sal_ant_un + comp_un - vent_un - cons_un + otrs_un) stock_arinma,
        (sal_ant_mo + comp_mon - vent_mon - cons_mon + otrs_mon) stock_valuado_arinma,
        costo2 costo2_arinma,
        monto2 monto2_arinma
 from   arinma
 where  no_cia  = Pv_cia
 and    no_arti = Pv_arti
 and    bodega in (select codigo
                  from   arinbo
                  where  no_cia = Pv_cia
                  and    nvl(mal_estado,'N') = 'N'
                  AND    nvl(reserva,'N') = 'N' );

Cursor C_Arinda Is
 select costo_unitario costo_arinda, costo2_unitario costo2_arinda
 from   arinda
 where  no_cia  = Pv_cia
 and    no_arti = pv_arti;

 Ln_monto_calculado  Arinma.Sal_Ant_Mo%type;
 Ln_monto2_calculado Arinma.monto2%type;

 Lv_mensaje          Varchar2(300) := null;

 Error_Proceso       Exception;

begin


For i in C_Arinma Loop

  Ln_monto_calculado := i.costo_arinma * i.stock_arinma;
  Ln_monto2_calculado := i.costo2_arinma * i.stock_arinma;


  ---- Verifico que los saldos valuados esten iguales
  --- Si puede darse que existan diferencias entre 0.01 a 0.03 en el inventario al comparar esto ANR 26/11/2009

  ---If Ln_monto_calculado != i.stock_valuado_arinma Then
  If Ln_monto_calculado - i.stock_valuado_arinma not between -0.03 and 0.03  then
   Lv_mensaje := 'Para el articulo: '||Pv_Arti||' el stock calculado por bodega: '||Ln_monto_calculado||' es diferente al stock valuado por bodega: '||i.stock_valuado_arinma;
   raise Error_proceso;
  ---elsif  Ln_monto2_calculado != i.monto2_arinma Then
  elsif  Ln_monto2_calculado - i.monto2_arinma not between -0.03 and 0.03 Then
   Lv_mensaje := 'Para el articulo: '||Pv_Arti||' el stock calculado por bodega: '||Ln_monto2_calculado||' es diferente al stock valuado por bodega: '||i.monto2_arinma;
   raise Error_proceso;
  end if;

 --- Por cada articulo en la bodega voy verificando que el costo de ARINDA y ARINMA esten iguales

 For j in C_Arinda Loop

  ---- Verifico que los costos esten iguales
  If i.costo_arinma != j.costo_arinda Then
   Lv_mensaje := 'Para el articulo: '||Pv_Arti||' el costo por bodega: '||i.costo_arinma||' es diferente al costo por articulo: '||j.costo_arinda;
   raise Error_proceso;
  ---- Verifico que los costos2 esten iguales
  elsif i.costo2_arinma != j.costo2_arinda Then
   Lv_mensaje := 'Para el articulo: '||Pv_Arti||' el costo2 por bodega: '||i.costo2_arinma||' es diferente al costo2 por articulo: '||j.costo2_arinda;
   raise Error_proceso;
  end if;
 end loop;
End Loop;

return (null); --- Si estan cuadrado los datos envio null

Exception
  When Error_Proceso Then
   return (Lv_mensaje);
  When Others Then
   return ('Error en verificacion de costos: '||sqlerrm);
end inverifica_costos;