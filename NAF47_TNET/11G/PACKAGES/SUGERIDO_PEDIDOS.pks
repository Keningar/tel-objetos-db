CREATE OR REPLACE package            Sugerido_pedidos is

  -- Author  : Esteban Piedra
  -- Created : 10/19/2007 11:01:41 AM
  -- Purpose :

  -- Public function and procedure declarations
  function venta_total(f_fecha_ini varchar2, f_fecha_fin varchar2, f_no_cia varchar2, f_no_arti varchar2) return number;
  function venta_total_ante(f_fecha_ini varchar2, f_fecha_fin varchar2, f_no_cia varchar2, f_no_arti varchar2) return number;
  procedure tiempo_repo(ppno_cia in varchar2, ppno_arti in varchar2, pp_cunta out number, pptotal out number);
  function existencia(f_no_cia varchar2, f_no_arti varchar2) return number;
  function venta_no_cumplida(f_fecha_ini varchar2, f_fecha_fin varchar2, f_no_cia varchar2, f_no_arti varchar2) return number;
  function pendiente(f_no_cia varchar2, f_no_arti varchar2) return number;
  function transito(f_no_cia varchar2, f_no_arti varchar2) return number;
  procedure venta_temporada(f_tiempo in  number, f_no_cia in varchar2, f_no_arti in varchar2,
  f_venta out number, f_temp out varchar2);
  PROCEDURE SUGERIDO(f_fecha_ini in varchar2, f_fecha_fin in varchar2,
                     f_no_cia in varchar2, f_no_arti in varchar2,
                     numero_mes in number
                     ,p_valor out number, V_MAXIMO OUT NUMBER, V_MINIMO OUT NUMBER);
end Sugerido_pedidos;
/


CREATE OR REPLACE package body            Sugerido_pedidos is
---------------------
/*--VENTAS TOTALES   MISMA FORMULA PARA TODO EL A?O Y PARA TEMPORADAS, SOLO INDICAR EL RANGO DE FECHAS PARA EL CALCULO SOLO SACAR EL PROMEDIO*/
--------------------
  function venta_total(f_fecha_ini varchar2, f_fecha_fin varchar2, f_no_cia varchar2, f_no_arti varchar2)
  return number
  is
  v_valor number;
  begin
    SELECT  sum(nvl(venta_unidades,0)) VENTAS --- ventas y consumos
    into v_valor
    FROM    ARFAEV
    WHERE  NO_CIA    =f_no_cia    AND
           articulo   =f_no_arti      and
           ano||ltrim(to_char(mes,'00')) between f_fecha_ini and f_fecha_fin;
    return(nvl(v_valor,0));
  end;
 ---------------------
--VENTAS TOTALES ANTERIOR
--------------------
 function venta_total_ante(f_fecha_ini varchar2, f_fecha_fin varchar2, f_no_cia varchar2, f_no_arti varchar2)
  return number
  is
  v_valor number;
  begin
    SELECT  sum(nvl(venta_unidades,0)) VENTAS --- ventas y consumos
    into v_valor
    FROM    ARFAEV
    WHERE  NO_CIA    =f_no_cia    AND
           articulo   =f_no_arti      and
           ano||ltrim(to_char(mes,'00')) between f_fecha_ini and f_fecha_fin;
    return(nvl(v_valor,0));
  end;
--------------------------
--tiempo repocicion (meses)
-------------------------
/* tiempo de reposicion tener en cuenta promedio de fechas de ingreso*/
  procedure tiempo_repo(ppno_cia in varchar2, ppno_arti in varchar2,
                        pp_cunta out number, pptotal out number)
  is
    cursor c_tiempo(pno_cia varchar2, pno_arti varchar2) is
    select A.PERIODO ANO, SUBSTR(TO_CHAR(A.FECHA, 'MMDDYYYY'),1,2) MES , X.NUMERO_PED-1 TOTAL
    from arinme a, arinml b,
         (select COUNT (*) NUMERO_PED
         from arinme a, arinml b
         where a.tipo_doc in ('IM', 'IN')
         and a.no_docu = b.no_docu
         AND A.NO_CIA = pno_cia
         AND A.NO_CIA = B.NO_CIA
         and b.no_arti = pno_arti)X
    where a.tipo_doc in ('IM', 'IN')
    and a.no_docu = b.no_docu
    AND A.NO_CIA = pno_cia
    AND A.NO_CIA = B.NO_CIA
    and b.no_arti = pno_arti
    ORDER BY A.PERIODO, TO_CHAR(A.FECHA, 'MMDDYYYY');
    V_CURSOR1 C_TIEMPO%ROWTYPE;
    V_CURSOR2 C_TIEMPO%ROWTYPE;
    c_cuenta number := 0;
    v_mes number;
    v_ano number;
    v_div number;
    V_CU NUMBER := 0;
    begin

       OPEN C_TIEMPO(ppno_cia, ppno_arti) ;
       LOOP
        IF V_CU = 0 THEN
          FETCH C_TIEMPO INTO V_CURSOR1;
          FETCH C_TIEMPO INTO V_CURSOR2;
          V_CU := 1;
        ELSE
          V_CURSOR1 := V_CURSOR2;
          FETCH C_TIEMPO INTO V_CURSOR2;
        END IF;

        if c_tiempo%found then
          v_mes := v_cursor1.mes;
          v_ano := v_cursor1.ANO;
          v_div := v_cursor1.total;
          loop
                IF V_ANO <= v_cursor2.ANO THEN
                  loop
                        v_mes := v_mes + 1;
                        c_cuenta := c_cuenta+1;
                  exit when (v_mes >= 12);
                  end loop;
                ELSE
                   loop
                        v_mes := v_mes + 1;
                        c_cuenta := c_cuenta+1;
                  exit when (v_mes = v_cursor2.mes);
                  end loop;
                END IF;
          v_ano := v_ano+1;
          v_mes := 0;
          exit when (v_ANO > v_cursor2.ANO);
          end loop;
        end if;
      EXIT WHEN(C_TIEMPO%NOTFOUND);
      END LOOP;
      CLOSE C_TIEMPO;
    pp_cunta := c_cuenta;
    pptotal  := v_div;
end tiempo_repo;
-------------------------
--EXISTENCIA
-------------------------
  function existencia(f_no_cia varchar2, f_no_arti varchar2)
  return number
  is
  v_valor number;
  begin
    select sum((nvl(sal_ant_un,0) + nvl(comp_un,0) + nvl(otrs_un,0) -
           nvl(vent_un,0) - nvl(cons_un,0))) EXISTENCIA
    into v_valor
    from   arinma
    where  no_cia   =f_no_cia and
           no_arti   = f_no_arti;
    return (nvl(v_valor,0));
  end;
--------------------------
--ventas no satisfechas mensuales (promedio)
---------------------------
/*ventas no satisfechas = arfafe (cantidad pedida - cantidad facturada) promedio con respecto a la fecha de ingreso*/
function venta_no_cumplida(f_fecha_ini varchar2, f_fecha_fin varchar2, f_no_cia varchar2, f_no_arti varchar2)
  return number
  is
  v_valor number;
  begin
    SELECT round(sum((nvl(b.cant_aprobada,0) - nvl(b.cant_facturada,0))/x.contador),0)NO_CUMPLIDAS
    into v_valor
    FROM ARFAFEC A, ARFAFLC B,
    (SELECT count (distinct A.PERIODO||SUBSTR(TO_CHAR(A.FECHA, 'MMDDYYYY'),1,2)) contador
            FROM ARFAFEC A, ARFAFLC B
            WHERE B.NO_ARTI = f_no_arti
            and a.no_cia = f_no_cia
            AND A.NO_FACTU = B.NO_FACTU
            and A.PERIODO||SUBSTR(TO_CHAR(A.FECHA, 'MMDDYYYY'),1,2) between f_fecha_ini and  f_fecha_fin
            order by A.PERIODO||SUBSTR(TO_CHAR(A.FECHA, 'MMDDYYYY'),1,2) )x
    WHERE B.NO_ARTI = f_no_arti
    and a.no_cia = f_no_cia
    AND A.NO_FACTU = B.NO_FACTU
    and A.PERIODO||SUBSTR(TO_CHAR(A.FECHA, 'MMDDYYYY'),1,2) between f_fecha_ini and  f_fecha_fin;
    return(nvl(v_valor,0));
  end;
---------------------------
--salidas pendientes.
---------------------------
  function pendiente(f_no_cia varchar2, f_no_arti varchar2) return number
  is
   v_valor number;
  begin
    SELECT sum(nvl(manifiestopend,0) + nvl(pedidos_pend,0) + nvl(sal_pend_un,0)) PENDIENTES
    into v_valor
    FROM arinma
    WHERE no_cia = f_no_cia
    AND no_arti  = f_no_arti ;
  return (nvl(v_valor,0));
  end;

---------------------------
--mercaderia en trans.
---------------------------
function transito(f_no_cia varchar2, f_no_arti varchar2) return number
is
v_valor number;
begin
  select nvl(sum(b.cantidad_pedida),0) TRANSITO
  into v_valor
  from arimencfacturas a, arimdetfacturas b
  where a.entra_costeo = 'S'
  and a.terminado = 'N'
  AND A.NUM_FAC = B.NUM_FAC
  and a.no_cia = f_no_cia
  and b.no_arti like f_no_arti;
return (nvl(v_valor,0));
end;
---------------------
--VENTAS TEMPORADA
--------------------
  procedure venta_temporada(f_tiempo in  number, f_no_cia in varchar2, f_no_arti in varchar2,
  f_venta out number, f_temp out varchar2)

  is
  cursor c_temp is
  select TEMP_INICIO, TEMP_DURACION, TEMP_INICIO2, TEMP_DURACION2, TEMP_INICIO3, TEMP_DURACION3
  from arinda
  where no_arti =  f_no_arti;
  v_valor number;
  V_FECHA_INI VARCHAR2(6);
  V_FECHA_FIN VARCHAR2(6);
  V_FECHA_COMINI VARCHAR2(6);
  V_FECHA_COMFIN VARCHAR2(6);
  V_FECHA VARCHAR2(6);
  V_ANOACT VARCHAR2(4);
  v_mes NUMBER;
  v_mesCON VARCHAR2(2);
  V_ANO NUMBER;
  v_mesact varchar2(2);
  v_temp c_temp%rowtype;
  V_CONTA NUMBER := 0;
  V_DIV NUMBER;
  begin
    V_ANOACT := to_char(to_number(TO_CHAR(sysdate, 'YYYY'))-1);
    V_mesact := TO_CHAR(sysdate, 'MM');
    V_FECHA_COMINI := V_ANOACT||v_mesact;
    V_ANO := TO_NUMBER( V_ANOACT);
    v_mes := TO_NUMBER( v_mesact);
      LOOP
       IF V_MES < 12 THEN
               V_MES := V_MES + 1;

       ELSE
              V_ANO := V_ANO + 1;
              V_MES := 1;

       END IF;
       V_CONTA := V_CONTA +1;
      EXIT WHEN (V_CONTA >= f_tiempo ) ;
      END LOOP;
      IF V_MES < 10 THEN
      v_mesCON := '0'||V_MES;
      ELSE
      v_mesCON := V_MES;
      END IF;
    V_FECHA_COMFIN := V_ANO||V_MESCON;
   open c_temp;
    fetch c_temp into v_temp;
          f_temp := 'N';

  -- TEMPORADA 1
          IF V_TEMP.TEMP_INICIO IS NOT NULL THEN
             IF V_TEMP.TEMP_INICIO < 10 THEN
                v_mesCON := '0'||V_TEMP.TEMP_INICIO;
             ELSE
                v_mesCON := V_TEMP.TEMP_INICIO;
             END IF;
            V_FECHA := V_ANOACT||v_mesCON;
            IF V_FECHA BETWEEN V_FECHA_COMINI AND V_FECHA_COMFIN THEN
               f_temp := 'S';
               V_FECHA_INI := V_FECHA;
               V_CONTA := 0;
               V_ANO := V_ANOACT;
               V_MES := V_TEMP.TEMP_INICIO;
                 LOOP
                 IF V_MES < 12 THEN
                         V_MES := V_MES + 1;

                 ELSE
                        V_ANO := V_ANO + 1;
                        V_MES := 1;

                 END IF;
                 V_CONTA := V_CONTA +1;
                EXIT WHEN (V_CONTA >= V_TEMP.TEMP_DURACION ) ;
                END LOOP;
                IF V_MES < 10 THEN
                v_mesCON := '0'||V_MES;
                ELSE
                v_mesCON := V_MES;
                END IF;
               V_FECHA_FIN := V_ANO||v_mesCON;
               V_DIV := V_TEMP.TEMP_DURACION;
            END IF;
          END IF;

 -- TEMPORADA 2

 IF V_TEMP.TEMP_INICIO2 IS NOT NULL THEN
             IF V_TEMP.TEMP_INICIO2 < 10 THEN
                v_mesCON := '0'||V_TEMP.TEMP_INICIO2;
             ELSE
                v_mesCON := V_TEMP.TEMP_INICIO2;
             END IF;
            V_FECHA := V_ANOACT||v_mesCON;
            IF V_FECHA BETWEEN V_FECHA_COMINI AND V_FECHA_COMFIN THEN
               f_temp := 'S';
               V_FECHA_INI := V_FECHA;
               V_CONTA := 0;
               V_ANO := V_ANOACT;
               V_MES := V_TEMP.TEMP_INICIO2;
                 LOOP
                 IF V_MES < 12 THEN
                         V_MES := V_MES + 1;

                 ELSE
                        V_ANO := V_ANO + 1;
                        V_MES := 1;

                 END IF;
                 V_CONTA := V_CONTA +1;
                EXIT WHEN (V_CONTA >= V_TEMP.TEMP_DURACION2 ) ;
                END LOOP;
                IF V_MES < 10 THEN
                v_mesCON := '0'||V_MES;
                ELSE
                v_mesCON := V_MES;
                END IF;
               V_FECHA_FIN := V_ANO||v_mesCON;
               V_DIV := V_TEMP.TEMP_DURACION2;
            END IF;
          END IF;

 -- TEMPORADA 3
     IF V_TEMP.TEMP_INICIO3 IS NOT NULL THEN
             IF V_TEMP.TEMP_INICIO3 < 10 THEN
                v_mesCON := '0'||V_TEMP.TEMP_INICIO3;
             ELSE
                v_mesCON := V_TEMP.TEMP_INICIO3;
             END IF;
            V_FECHA := V_ANOACT||v_mesCON;
            IF V_FECHA BETWEEN V_FECHA_COMINI AND V_FECHA_COMFIN THEN
               f_temp := 'S';
               V_FECHA_INI := V_FECHA;
               V_CONTA := 0;
               V_ANO := V_ANOACT;
               V_MES := V_TEMP.TEMP_INICIO3;
                 LOOP
                 IF V_MES < 12 THEN
                         V_MES := V_MES + 1;

                 ELSE
                        V_ANO := V_ANO + 1;
                        V_MES := 1;

                 END IF;
                 V_CONTA := V_CONTA +1;
                EXIT WHEN (V_CONTA >= V_TEMP.TEMP_DURACION3 ) ;
                END LOOP;
                IF V_MES < 10 THEN
                v_mesCON := '0'||V_MES;
                ELSE
                v_mesCON := V_MES;
                END IF;
               V_FECHA_FIN := V_ANO||v_mesCON;
               V_DIV := V_TEMP.TEMP_DURACION3;
            END IF;
          END IF;
   close c_temp;
   SELECT  sum(nvl(venta_unidades,0)) VENTAS --- ventas y consumos
    into v_valor
    FROM    ARFAEV
    WHERE  NO_CIA    =f_no_cia    AND
           articulo   =f_no_arti      and
           ano||ltrim(to_char(mes,'00')) between V_FECHA_INI and V_FECHA_FIN;
    f_venta := ROUND ((nvl(v_valor,0)/NVL(V_DIV, 1)),0);


  end;

-------------------------
--INSERTA PROYECCION
-----------------------
  PROCEDURE SUGERIDO(f_fecha_ini in varchar2, f_fecha_fin in varchar2,
                     f_no_cia in varchar2, f_no_arti in varchar2,
                     numero_mes in number
                     ,p_valor out number, V_MAXIMO OUT NUMBER, V_MINIMO OUT NUMBER)
  IS
  v_venta_total NUMBER;
  v_venta_temporada NUMBER;
  v_venta_total_ante NUMBER;
  v_tiempo_repo NUMBER;
  v_tiempo number;
  v_numero number;
  V_existencia NUMBER;
  v_venta_no_cumplida NUMBER;
  v_pendiente NUMBER;
  v_transito NUMBER;
  v_ano varchar2(4);
  v_ano2 varchar2(4);
  v_mes varchar2(2);
  v_mes2 varchar2(2);
  v_fecha_ini varchar2(6);
  v_fecha_fin varchar2(6);
--  V_MAXIMO number;
--  V_MINIMO number;
  V_PORCENTA number;
  V_SUGERIDO number;
  V_SUG_TEMP number;
  V_EXISTENCIA_REAL number;
  indicador_s varchar2(1);
  BEGIN
  v_VENTA_TOTAL := venta_total(f_fecha_ini, f_fecha_fin, f_no_cia, f_no_arti);
  v_ano := SUBSTR(f_fecha_ini,1,4);
  v_mes := SUBSTR(f_fecha_ini,5,2);
  v_ano2 := SUBSTR(f_fecha_fin,1,4);
  v_mes2 := SUBSTR(f_fecha_fin,5,2);
  v_fecha_ini := to_char((to_number(v_ano)-1))||v_mes;
  v_fecha_fin := to_char((to_number(v_ano2)-1))||v_mes2;
  v_venta_total_ante := venta_total_ante(v_fecha_ini, v_fecha_fin, f_no_cia, f_no_arti);
  tiempo_repo(f_no_cia, f_no_arti, v_numero, v_tiempo);
  v_tiempo_repo  := ROUND(nvl(v_numero,0) / nvl(v_tiempo,1),0);
  venta_temporada(v_tiempo_repo,f_no_cia, f_no_arti, v_venta_temporada,indicador_s);
  V_existencia := existencia(f_no_cia , f_no_arti );
  v_venta_no_cumplida := venta_no_cumplida(f_fecha_ini , f_fecha_fin , f_no_cia , f_no_arti ) ;
  v_pendiente := pendiente(f_no_cia , f_no_arti );
  v_transito := transito(f_no_cia , f_no_arti );
--EXISTENCIA REAL existencia - pendientes;
  V_EXISTENCIA_REAL := V_existencia - v_pendiente;
/*-- PORCENTAJE DE INCREMENTO Porcentaje de ingremento en relacion a a?os anteriores(solo si se tiene ventas en meses iguales en a?os anteriores) = (venta actual * 100)/venta anterior)-100*/
  if v_venta_total_ante is null or v_venta_total_ante = 0 then
     V_PORCENTA := 0;
  else
     V_PORCENTA := ROUND((((((v_VENTA_TOTAL/numero_mes)*100)/(((v_venta_total_ante)/numero_mes)))-100)*ROUND((v_VENTA_TOTAL/numero_mes),0)/100),0);
  end if;
/*-- MINIMO  (ventas mensuales(promedio) * tiempo repo)+ventas no satisfechas + porcentaje de incremento*/
  V_MINIMO := ((ROUND((v_VENTA_TOTAL/numero_mes),0) * v_tiempo_repo)) + v_venta_no_cumplida + V_PORCENTA;
/*-- MAXIMO minimo+ventas mensuales (promedio)*/
  V_MAXIMO := V_MINIMO + ROUND((v_VENTA_TOTAL/numero_mes),0);
/*-- SUGERIDO maximo - existencia - mercaderia en trans.*/
  V_SUGERIDO := V_MAXIMO - V_EXISTENCIA_REAL - v_transito;
/*-- SUGERIDO TEMPORADA minimo + ventas temporada-mercaderia en trans- existencia*/
  V_SUG_TEMP := V_MINIMO + v_venta_temporada - v_transito - V_EXISTENCIA_REAL;

  if indicador_s = 'S' then
      p_valor := V_SUG_TEMP;
  else
     p_valor := V_SUGERIDO;
  end if;
  END;

end Sugerido_pedidos;
/
