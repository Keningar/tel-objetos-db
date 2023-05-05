CREATE OR REPLACE package            nomina_historico is



 procedure carga_empleados(pcia varchar2,pplanilla varchar2,ppuesto varchar2,
                           parea varchar2,pdepa varchar2, pdivi varchar2, 
                           pseccion varchar2,pano number,pmes1 number,pmes2 number);

procedure ETIQUETA_COLUMNA(pcolumna number, pemple varchar2, pmonto VARCHAR2);
procedure VALOR_COLUMNA(PCIA VARCHAR2,PPLA VARCHAR2,pcolumna number,
                         pemple varchar2, pmonto VARCHAR2,pano number,pmes number);



end nomina_historico;
/


CREATE OR REPLACE package body            nomina_historico is

 procedure carga_empleados(pcia varchar2,pplanilla varchar2,ppuesto varchar2,
                           parea varchar2,pdepa varchar2, pdivi varchar2,
                           pseccion varchar2,pano number,pmes1 number,pmes2 number) is

cursor c_emple is
select ano,mes,no_cia,cod_pla,no_emple
     from cg_nomina_historico a
     where no_cia like decode(pcia, 'T', '%',pcia)
     and cod_pla like decode(pplanilla, 'T', '%',pplanilla)
     and ano=pano
     and mes between pmes1 and pmes2
     and no_emple in
     (select no_emple from arplme
     where no_cia LIKE  decode(pcia, 'T', '%',pcia)
     and nvl(area,'N') like decode(parea, 'T', '%',parea)
     and nvl(depto,'N') like decode(pdepa, 'T', '%',pdepa)
     and nvl(division,'N') like decode(pdivi, 'T', '%',pdivi)
     and nvl(seccion,'N') like decode(pseccion, 'T', '%',pseccion)
     and nvl(puesto,'N') like decode (ppuesto,'T','%',ppuesto))
     group by ano,mes,no_cia,cod_pla,no_emple;



   cursor c_eti_ing_can is
         select distinct(no_ingre)
         from cg_nomina_historico
         where no_cia like decode(pcia, 'T', '%',pcia)
         and cod_pla like decode(pplanilla, 'T', '%',pplanilla)
         and indicador = 'I'
         and ano=pano
     and mes between pmes1 and pmes2
         and no_ingre in
        ( select no_ingre
             from arplmi
             where no_cia  like decode(pcia, 'T', '%',pcia)
             and (dep_sal_hora= 'SD'
             or dep_sal_hora='S'))
         order by no_ingre;

   cursor c_eti_ing is
         select distinct(no_ingre)
         from cg_nomina_historico
         where no_cia like decode(pcia, 'T', '%',pcia)
         and cod_pla like decode(pplanilla, 'T', '%',pplanilla)
         and indicador = 'I'
         and ano=pano
     and mes between pmes1 and pmes2
         and no_ingre NOT in
        ( select no_ingre
             from arplmi
             where no_cia  like decode(pcia, 'T', '%',pcia)
             and (dep_sal_hora= 'SD'
             or dep_sal_hora='S'))
         order by no_ingre;

   CURSOR c_eti_egreso_N is
    select distinct(no_ingre)
     from cg_nomina_historico
     where no_cia like decode(pcia, 'T', '%',pcia)
     and cod_pla like decode(pplanilla, 'T', '%',pplanilla)
     and indicador = 'D'
     and ano=pano
     and mes between pmes1 and pmes2
     and solo_cia = 'N'
     order by no_ingre;

   CURSOR c_eti_egreso_S is
    select distinct(no_ingre)
     from cg_nomina_historico
     where no_cia like decode(pcia, 'T', '%',pcia)
     and cod_pla like decode(pplanilla, 'T', '%',pplanilla)
     and indicador = 'D'
     and ano=pano
     and mes between pmes1 and pmes2
     and solo_cia = 'S'
     order by no_ingre;



cursor c_INGRESOS_C is
         select *
         from cg_nomina_historico
         where no_cia like decode(pcia, 'T', '%',pcia)
         and cod_pla like decode(pplanilla, 'T', '%',pplanilla)
         and indicador = 'I'
         and ano=pano
     and mes between pmes1 and pmes2
         and no_ingre  in
        ( select no_ingre
             from arplmi
             where no_cia = '01'
             and (dep_sal_hora= 'SD'
             or dep_sal_hora='S'))
         order by ano,mes,no_ingre;

cursor c_INGRESOS is
         select *
         from cg_nomina_historico
         where no_cia like decode(pcia, 'T', '%',pcia)
         and cod_pla like decode(pplanilla, 'T', '%',pplanilla)
         and indicador = 'I'
         and ano=pano
     and mes between pmes1 and pmes2
         and no_ingre not in
        ( select no_ingre
             from arplmi
             where no_cia = '01'
             and (dep_sal_hora= 'SD'
             or dep_sal_hora='S'))
         order by ano,mes,no_ingre;

CURSOR c_dedu_N is
    select *
     from cg_nomina_historico
     where no_cia like decode(pcia, 'T', '%',pcia)
     and cod_pla  like decode(pplanilla, 'T', '%',pplanilla)
     and indicador = 'D'
     and ano=pano
     and mes between pmes1 and pmes2
     and solo_cia = 'N'
     order by ano,mes,no_ingre;

 CURSOR c_dedu_S is
    select *
     from cg_nomina_historico
     where no_cia like decode(pcia, 'T', '%',pcia)
     and cod_pla like decode(pplanilla, 'T', '%',pplanilla)
     and indicador = 'D'
     and ano=pano
     and mes between pmes1 and pmes2
     and solo_cia = 'S'
     order by ano,mes,no_ingre;

cursor c_tot_ingresos(pcia varchar2, ppla varchar2,pemple varchar2, pano number,pmes number) is
       SELECT SUM(MONTO)
       FROM cg_nomina_historico
        WHERE NO_EMPLE = pemple
        AND INDICADOR = 'I'
        AND NO_CIA = pcia
        AND COD_PLA = ppla
        AND ANO =PANO
        AND MES = PMES;

cursor c_tot_egresos(pcia varchar2, ppla varchar2,pemple varchar2, pano number,pmes number) is
       SELECT SUM(MONTO)
       FROM cg_nomina_historico
        WHERE NO_EMPLE = pemple
        AND INDICADOR = 'D'
        and solo_cia = 'N'
        AND NO_CIA = pcia
        AND COD_PLA = ppla
         AND ANO =PANO
        AND MES = PMES;

cursor c_tot_provisiones(pcia varchar2, ppla varchar2,pemple varchar2, pano number,pmes number) is
       SELECT SUM(MONTO)
       FROM cg_nomina_historico
        WHERE NO_EMPLE = pemple
        AND INDICADOR = 'D'
        and solo_cia = 'S'
        AND NO_CIA = pcia
        AND COD_PLA = ppla
         AND ANO =PANO
        AND MES = PMES;



numero_campo number :=0;
ingreso varchar2(3);
bandera number :=1;

columna number:=0;

total_ingresoc number:=0;
total_ingreso number:=0;
total_egreso number:=0;
total_provision number:=0;
total_neto number:=0;
col_ingreso number:=0;
col_egreso number:=0;
col_provision number:=0;
col_neto number:=0;
 begin
  numero_campo:=1;
  columna:=1;

---------------------- EMPLEADOS
--- EMPLEADO PARA ETIQUETAS
    INSERT INTO NOMINA (ANIO,MES,EMPLEADO) VALUES (9999,99,'NULO');

    commit;
---- TODOS LOS EMPLEADOS
    for i in c_emple loop
       insert into nomina (anio,mes,no_cia,planilla,empleado) values(i.ano,i.mes,i.no_cia,i.cod_pla,i.no_emple);
--       insert into prueba (dato,dato1,dato2,dato3,dato4) values(i.ano,i.mes,i.no_cia,i.cod_pla,i.no_emple);
  --     commit;
    end loop;
-----------------------------------------
--------------------   ETIQUETAS

    for k in c_eti_ing_can loop
       nomina_historico.etiqueta_columna(columna,'NULO',K.NO_INGRE);
       COLUMNA:=COLUMNA+1;
       nomina_historico.ETIQUETA_columna(columna,'NULO','CANTIDAD');
       COLUMNA:=COLUMNA+1;
    END LOOP;

     for L in c_eti_ing  loop
       nomina_historico.ETIQUETA_columna(columna,'NULO',L.NO_INGRE);
       COLUMNA:=COLUMNA+1;
    END LOOP;

    nomina_historico.ETIQUETA_columna(columna,'NULO','TOT_INGRESOS');
       COLUMNA:=COLUMNA+1;

    for e in c_eti_egreso_n  loop
       nomina_historico.ETIQUETA_columna(columna,'NULO',e.NO_INGRE);
       COLUMNA:=COLUMNA+1;
    END LOOP;

        nomina_historico.ETIQUETA_columna(columna,'NULO','TOT_EGRESOS');
         COLUMNA:=COLUMNA+1;
         nomina_historico.ETIQUETA_columna(columna,'NULO','NETO');
         COLUMNA:=COLUMNA+1;

    for d in c_eti_egreso_s  loop
       nomina_historico.ETIQUETA_columna(columna,'NULO',d.NO_INGRE);
       COLUMNA:=COLUMNA+1;
    END LOOP;

        nomina_historico.ETIQUETA_columna(columna,'NULO','TOT_PROVISIONES');
       COLUMNA:=COLUMNA+1;

------------------------------
       COLUMNA:=1;
-----------------------------
--------------- INGRESOS TIPO S o SD
    FOR I IN c_INGRESOS_C  LOOP
      if bandera =1 then
      ingreso:= i.no_ingre;
      bandera:=2;
     end if;
    if ingreso=i.no_ingre then
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.MONTO,i.ano,i.mes);
        total_ingresoc:=total_ingresoc+i.monto;

        COLUMNA:=COLUMNA+1;
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.CANTIDAD,i.ano,i.mes);
       columna:=columna-1;

    else

       COLUMNA:=COLUMNA+2;
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.MONTO,i.ano,i.mes);
        total_ingresoc:=total_ingresoc+i.monto;

        COLUMNA:=COLUMNA+1;
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.CANTIDAD,i.ano,i.mes);
        columna:=columna-1;
        ingreso:=i.no_ingre;
   end if;

  END LOOP;

----------------------  DEMAS INGRESOS
bandera:=1;
columna:=columna+2;
FOR I IN c_INGRESOS loop
      if bandera =1 then
      ingreso:= i.no_ingre;
      bandera:=2;
     end if;
    if ingreso=i.no_ingre then
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.MONTO,i.ano,i.mes);


    else
       COLUMNA:=COLUMNA+1;
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.MONTO,i.ano,i.mes);
        ingreso:=i.no_ingre;
   end if;


    END LOOP;
-------------------------------  DEDUCCIONES
   col_ingreso:=columna+1;
-----------------------------------------------------
    bandera:=1;
columna:=columna+2;
FOR I IN c_dedu_n loop
      if bandera =1 then
      ingreso:= i.no_ingre;
      bandera:=2;
     end if;
    if ingreso=i.no_ingre then
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.MONTO,i.ano,i.mes);
    else
       COLUMNA:=COLUMNA+1;
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.MONTO,i.ano,i.mes);
        ingreso:=i.no_ingre;
   end if;


    END LOOP;
 ------------------- PROVISIONES
   col_egreso:=columna+1;
   col_neto :=columna+2;
----------------------------------------------
  bandera:=1;
columna:=columna+3;
FOR I IN c_dedu_s loop
      if bandera =1 then
      ingreso:= i.no_ingre;
      bandera:=2;
     end if;
    if ingreso=i.no_ingre then
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.MONTO,i.ano,i.mes);
    else
       COLUMNA:=COLUMNA+1;
        nomina_historico.VALOR_columna(i.no_cia,i.cod_pla,columna,I.NO_EMPLE,I.MONTO,i.ano,i.mes);
        ingreso:=i.no_ingre;
   end if;


    END LOOP;
col_provision:=columna+1;



---------------------------------------
------------------ TOTALES
   for k in c_emple loop
     open c_tot_ingresos(k.no_cia,k.cod_pla,k.no_emple,k.ano,k.mes);
     fetch c_tot_ingresos into total_ingreso;
     close c_tot_ingresos;
     nomina_historico.valor_columna(k.no_cia,k.cod_pla,col_ingreso,k.NO_EMPLE,total_ingreso,k.ano,k.mes);

     open c_tot_egresos(k.no_cia,k.cod_pla,k.no_emple,k.ano,k.mes);
     fetch c_tot_egresos into total_egreso;
     close c_tot_egresos;
     nomina_historico.valor_columna(k.no_cia,k.cod_pla,col_egreso,k.NO_EMPLE,total_egreso,k.ano,k.mes);

     open c_tot_provisiones(k.no_cia,k.cod_pla,k.no_emple,k.ano,k.mes);
     fetch c_tot_provisiones into total_provision;
     close c_tot_provisiones;
     nomina_historico.valor_columna(k.no_cia,k.cod_pla,col_provision,k.NO_EMPLE,total_provision,k.ano,k.mes);

---------------  TOTAL NETO
   total_neto:=total_ingreso-total_egreso;
    nomina_historico.valor_columna(k.no_cia,k.cod_pla,col_neto,k.NO_EMPLE,total_neto,k.ano,k.mes);



   end loop;



 end;




------------------------------------------


procedure ETIQUETA_COLUMNA(pcolumna number, pemple varchar2, pmonto VARCHAR2) is
  begin
     if pcolumna=1 then
        UPDATE NOMINA
        SET VALOR1 = PMONTO
        WHERE EMPLEADO = PEMPLE;

     elsif  pcolumna=2 then
        UPDATE NOMINA
        SET VALOR2 = PMONTO
        WHERE EMPLEADO = PEMPLE;
     elsif  pcolumna=3 then
        UPDATE NOMINA
        SET VALOR3 = PMONTO
        WHERE EMPLEADO = PEMPLE;
      elsif  pcolumna=4 then
        UPDATE NOMINA
        SET VALOR4 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=5 then
        UPDATE NOMINA
        SET VALOR5 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=6 then
        UPDATE NOMINA
        SET VALOR6 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=7 then
        UPDATE NOMINA
        SET VALOR7 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=8 then
        UPDATE NOMINA
        SET VALOR8 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=9 then
        UPDATE NOMINA
        SET VALOR9 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=10 then
        UPDATE NOMINA
        SET VALOR10 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=11 then
        UPDATE NOMINA
        SET VALOR11 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=12 then
        UPDATE NOMINA
        SET VALOR12 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=13 then
        UPDATE NOMINA
        SET VALOR13 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=14 then
        UPDATE NOMINA
        SET VALOR14 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=15 then
        UPDATE NOMINA
        SET VALOR15 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=16 then
        UPDATE NOMINA
        SET VALOR16 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=17 then
        UPDATE NOMINA
        SET VALOR17 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=18 then
        UPDATE NOMINA
        SET VALOR18 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=19 then
        UPDATE NOMINA
        SET VALOR19 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=20 then
        UPDATE NOMINA
        SET VALOR20 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=21 then
        UPDATE NOMINA
        SET VALOR21 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=22 then
        UPDATE NOMINA
        SET VALOR22 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=23 then
        UPDATE NOMINA
        SET VALOR23 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=24 then
        UPDATE NOMINA
        SET VALOR24 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=25 then
        UPDATE NOMINA
        SET VALOR25 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=26 then
        UPDATE NOMINA
        SET VALOR26 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=27 then
        UPDATE NOMINA
        SET VALOR27 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=28 then
        UPDATE NOMINA
        SET VALOR28 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=29 then
        UPDATE NOMINA
        SET VALOR29 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=30 then
        UPDATE NOMINA
        SET VALOR30 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=31 then
        UPDATE NOMINA
        SET VALOR31 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=32 then
        UPDATE NOMINA
        SET VALOR32 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=33 then
        UPDATE NOMINA
        SET VALOR33 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=34 then
        UPDATE NOMINA
        SET VALOR34 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=35 then
        UPDATE NOMINA
        SET VALOR35 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=36 then
        UPDATE NOMINA
        SET VALOR36 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=37 then
        UPDATE NOMINA
        SET VALOR37 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=38 then
        UPDATE NOMINA
        SET VALOR38 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=39 then
        UPDATE NOMINA
        SET VALOR39 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=40 then
        UPDATE NOMINA
        SET VALOR40 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=41 then
        UPDATE NOMINA
        SET VALOR41 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=42 then
        UPDATE NOMINA
        SET VALOR42 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=43 then
        UPDATE NOMINA
        SET VALOR43 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=44 then
        UPDATE NOMINA
        SET VALOR44 = PMONTO
        WHERE EMPLEADO = PEMPLE;
         elsif  pcolumna=45 then
        UPDATE NOMINA
        SET VALOR45 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=46 then
        UPDATE NOMINA
        SET VALOR46 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=47 then
        UPDATE NOMINA
        SET VALOR47 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=48 then
        UPDATE NOMINA
        SET VALOR48 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=49 then
        UPDATE NOMINA
        SET VALOR49 = PMONTO
        WHERE EMPLEADO = PEMPLE;
        elsif  pcolumna=50 then
        UPDATE NOMINA
        SET VALOR50 = PMONTO
        WHERE EMPLEADO = PEMPLE;

     end if;
  end;

procedure VALOR_COLUMNA(PCIA VARCHAR2,PPLA VARCHAR2,pcolumna number,
                         pemple varchar2, pmonto VARCHAR2,pano number,pmes number) is
  begin
     if pcolumna=1 then
        UPDATE NOMINA
        SET VALOR1 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;

     elsif  pcolumna=2 then
        UPDATE NOMINA
        SET VALOR2 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
     elsif  pcolumna=3 then
        UPDATE NOMINA
        SET VALOR3 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=4 then
        UPDATE NOMINA
        SET VALOR4 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=5 then
        UPDATE NOMINA
        SET VALOR5 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=6 then
        UPDATE NOMINA
        SET VALOR6 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=7 then
        UPDATE NOMINA
        SET VALOR7 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=8 then
        UPDATE NOMINA
        SET VALOR8 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=9 then
        UPDATE NOMINA
        SET VALOR9 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=10 then
        UPDATE NOMINA
        SET VALOR10 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=11 then
        UPDATE NOMINA
        SET VALOR11 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=12 then
        UPDATE NOMINA
        SET VALOR12 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=13 then
        UPDATE NOMINA
        SET VALOR13 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=14 then
        UPDATE NOMINA
        SET VALOR14 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=15 then
        UPDATE NOMINA
        SET VALOR15 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=16 then
        UPDATE NOMINA
        SET VALOR16 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=17 then
        UPDATE NOMINA
        SET VALOR17 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=18 then
        UPDATE NOMINA
        SET VALOR18 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=19 then
        UPDATE NOMINA
        SET VALOR19 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=20 then
        UPDATE NOMINA
        SET VALOR20 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=21 then
        UPDATE NOMINA
        SET VALOR21 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=22 then
        UPDATE NOMINA
        SET VALOR22 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=23 then
        UPDATE NOMINA
        SET VALOR23 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=24 then
        UPDATE NOMINA
        SET VALOR24 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=25 then
        UPDATE NOMINA
        SET VALOR25 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=26 then
        UPDATE NOMINA
        SET VALOR26 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=27 then
        UPDATE NOMINA
        SET VALOR27 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=28 then
        UPDATE NOMINA
        SET VALOR28 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=29 then
        UPDATE NOMINA
        SET VALOR29 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=30 then
        UPDATE NOMINA
        SET VALOR30 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;

      elsif  pcolumna=31 then
        UPDATE NOMINA
        SET VALOR31 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=32 then
        UPDATE NOMINA
        SET VALOR32 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=33 then
        UPDATE NOMINA
        SET VALOR33 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=34 then
        UPDATE NOMINA
        SET VALOR34 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=35 then
        UPDATE NOMINA
        SET VALOR35 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=36 then
        UPDATE NOMINA
        SET VALOR36 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=37 then
        UPDATE NOMINA
        SET VALOR37 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=38 then
        UPDATE NOMINA
        SET VALOR38 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=39 then
        UPDATE NOMINA
        SET VALOR39 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=40 then
        UPDATE NOMINA
        SET VALOR40 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=41 then
        UPDATE NOMINA
        SET VALOR41 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=42 then
        UPDATE NOMINA
        SET VALOR42 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=43 then
        UPDATE NOMINA
        SET VALOR43 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=44 then
        UPDATE NOMINA
        SET VALOR44 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=45 then
        UPDATE NOMINA
        SET VALOR45 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=46 then
        UPDATE NOMINA
        SET VALOR46 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=47 then
        UPDATE NOMINA
        SET VALOR47 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=48 then
        UPDATE NOMINA
        SET VALOR48 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=49 then
        UPDATE NOMINA
        SET VALOR49 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;
      elsif  pcolumna=50 then
        UPDATE NOMINA
        SET VALOR50 = PMONTO
        WHERE NO_CIA = PCIA
        AND PLANILLA = PPLA
        AND EMPLEADO = PEMPLE
        AND ANIO     = PANO
        AND MES      = PMES;

     end if;
  end;


end nomina_historico;
/
