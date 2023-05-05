CREATE OR REPLACE PACKAGE            PLdeducciones_ley_cr AS
   -- ---
   --  Este paquete contiene un conjunto de procedimientos y funciones que
   -- que implementan el calculo de deducciones definidos por la ley del pais
   --  Los calculos no realizan redondeos a menos que, las caracteristicas
   -- de la deduccion asi lo exijan.
   --
   -- ***
   --
   --
   SUBTYPE calculo_r IS PLlib.PLdeducciones_calc_r;
   --
   -- ---
   -- Inicializa el paquete, cargando informacion requerida en muchos calculos
   -- como datos de la compa?ia, Tipo de cambio del UF, del UTM, etc
   --
   PROCEDURE inicializa(pCia varchar2);
   --
   -- ---
   -- Realiza el calculo del ingreso indicado por "formula_id"
   FUNCTION calcula(
               pno_cia        in arplme.no_cia%type
               ,pcod_pla      in arplppd.cod_pla%type
               ,pno_emple     in arplppd.no_emple%type
               ,pno_dedu      in arplppd.no_dedu%type
               ,pformula_id   in arplmd.formula_id%type
               ) RETURN calculo_r;
   -- --
   -- Devuelve laa descripcion del ultimo error ocurrido
   FUNCTION  ultimo_error RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20016);
   kNum_error      NUMBER := -20016;
END;  -- deducciones_ley_cr;
/


CREATE OR REPLACE PACKAGE BODY            PLdeducciones_ley_cr AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   --
   -- ---
   -- TIPOS
   --
   TYPE param_cia_r IS RECORD(
       no_cia                arplmc.no_cia%type
      ,cod_h_ord             arplpar.cod_h_ord%type
      ,cod_impsal            arplpar.cod_impsal%type
      ,cod_provi_vac         arplpar.cod_provi_vac%type
      ,cod_ade_impsal        arplpar.cod_ade_impsal%type
      ,cod_devol_adeimpsal   arplpar.cod_devol_adeimpsal%type
      ,creditoxc             arplpar.creditoxc%type
      ,creditoxh             arplpar.creditoxh%type
   );
   TYPE datos_pla_r IS RECORD(
       no_cia          arplcp.no_cia%type
      ,cod_pla         arplcp.codpla%type
      ,tipla           arplcp.tipla%type
      ,redondeo        arplcp.redondeo%type
      ,ano_proce       arplcp.ano_proce%type
      ,mes_proce	     arplcp.mes_proce%type
      ,diasxmes        arplte.dias_trab%type
      ,horasxmes       arplte.horxmes%type
      ,horasxpla       arplte.n_horas%type
      ,f_desde		     arplcp.f_desde%type
      ,f_hasta         arplcp.f_hasta%type
      ,ultima_pla      arplcp.ultima_planilla%type
      ,jornada         arplte.jornada%type
      ,planillasxmes	 number
      ,horasxdia       number
      ,diasxpla        number
   );
   --
   TYPE datos_emp_r IS RECORD(
       no_cia          arplme.no_cia%type
      ,no_emple        arplme.no_emple%type
      ,estado          arplme.estado%type
      ,f_ingreso	     arplme.f_ingreso%type
      ,tipo_emp		     arplme.tipo_emp%type
      ,sal_bas 		     number
      ,sal_bas_sem     number
      ,sal_min_ref_ded_sem number
      ,sal_hora		     number
      ,dias_reposo     number
	    ,imponible_ccss  number
   );
   --
   TYPE datos_ded_r IS RECORD(
      no_cia            arplmd.no_cia%type
      ,no_dedu          arplmd.no_dedu%type
      ,tipo             arplmd.tipo%type
      ,indivi           arplmd.indivi%type
      ,monto            arplmd.monto%type
      ,grupo_ing        arplmd.grupo_ing%type
      ,aplica_a         arplmd.aplica_a%type
      ,solo_cia         arplmd.solo_cia%type
   );
   --
   -- ---
   -- CURSORES:
   CURSOR c_datos_pla(pno_cia     arplcp.no_cia%type
                      ,pcod_pla   arplcp.codpla%type
                      ) IS
         SELECT p.no_cia,                 p.codpla cod_pla,
                p.tipla,                  p.redondeo,
                p.ano_proce,              p.mes_proce,
                t.dias_trab   diasxmes,   t.horxmes     horasxmes,
                t.n_horas     horasxpla,  p.f_desde     f_desde,
                p.f_hasta     f_hasta,
                p.ultima_planilla  ultima_pla,
                t.jornada,
                DECODE(p.tipla, 'S',  4.3,
                                'B',  2.1,
                                'Q',  2,
                                'M',  1,
                                '2M', (1/2),
                                '3M', (1/3),
                                '6M', (1/6),
                                'A',  (1/12)) PlanillasxMes
         FROM arplcp p, arplte t
          WHERE p.no_cia   = pno_cia
            AND p.codpla   = pcod_pla
            AND p.no_cia   = t.no_cia
            AND p.tipo_emp = t.tipo_emp;
   --
   CURSOR c_datos_ded(
                        pno_cia     arplmd.no_cia%type
                        ,pno_dedu   arplmd.no_dedu%type
                        ,pcod_pla   arplcp.codpla%type
                        ) IS
      SELECT no_cia, no_dedu, tipo, indivi, monto, grupo_ing,aplica_a,
	         solo_cia
      FROM arplmd
      WHERE no_cia   = pno_cia
        AND no_dedu  = pno_dedu;
   --
   CURSOR c_datos_emp(
                        pno_cia     arplme.no_cia%type
                        ,pno_emple  arplme.no_emple%type
                        ,phorasxpla number
                        ) IS
      SELECT e.no_cia,   e.no_emple,
             e.estado,   e.f_ingreso,
             e.tipo_emp, e.sal_bas,
             decode(nvl(phorasxpla,0), 0, 0, e.sal_bas / phorasxpla) sal_hora
         FROM arplme e
        WHERE e.no_cia     = pno_cia
          AND e.no_emple   = pno_emple;
   --
   --
   -- ---
   -- VARIABLES GLOBALES
   gNueva_instancia  boolean;
   gimponible        boolean;
   rCalc             calculo_r;
   rCia              param_cia_r;
   rDed              datos_ded_r;
   rEmp              datos_emp_r;
   rPla              datos_pla_r;
   --
   vMensaje_error    VARCHAR2(160);
   --
   -- --
   --
   PROCEDURE limpia_error IS
   BEGIN
      vMensaje_error := NULL;
   END;
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := 'LEY: '|| msj_error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   --
   PROCEDURE carga_datos_pla(
      pno_cia     arplcp.no_cia%type
      ,pcod_pla    arplcp.codpla%type
   ) IS
   BEGIN
      if gNueva_instancia OR
         rPla.cod_pla is null OR
         (pno_cia != rPla.no_cia OR pcod_pla != rPla.cod_pla) then
         OPEN c_datos_pla(pno_cia, pcod_pla);
         FETCH c_datos_pla INTO rPla.no_cia,
                                rPla.cod_pla,
                                rPla.tipla,
                                rPla.redondeo,
                                rPla.ano_proce,
                                rPla.mes_proce,
                                rPla.diasxmes,
                                rPla.horasxmes,
                                rPla.horasxpla,
                                rPla.f_desde,
                                rPla.f_hasta,
                                rPla.ultima_pla,
                                rPla.jornada,
                                rPla.planillasxmes;
         CLOSE c_datos_pla;
         --
         if rPla.diasxMes > 0 then
            rPla.horasxdia := rPla.horasxmes / rPla.diasxMes;
         end if;
         if rPla.horasxdia > 0 then
            rPla.diasxpla  := ROUND(rPla.horasxpla / rPla.horasxdia,0);
         end if;
      end if;
   END;
   --
   --
   PROCEDURE carga_datos_ded(
      pno_cia        arplmd.no_cia%type
     ,pcod_pla    arplcp.codpla%type
     ,pno_dedu       arplmd.no_dedu%type
   ) IS
   BEGIN
      if gNueva_instancia OR
         rDed.no_dedu is null OR
         (pno_cia != rDed.no_cia OR pno_dedu != rDed.no_dedu) then
         OPEN c_datos_ded(pno_cia, pno_dedu, pcod_pla);
         FETCH c_datos_ded INTO rDed.no_cia,rDed.no_dedu,rDed.tipo,rDed.indivi,
                                rDed.monto,rDed.grupo_ing,rDed.aplica_a,rDed.solo_cia;
         CLOSE c_datos_ded;
      end if;
   END;
   --
   --
   PROCEDURE carga_datos_emp(
      pno_cia        arplme.no_cia%type
     ,pno_emple      arplme.no_emple%type
     ,phorasxpla     number
   )
   IS
     --
     v_clase_var   arplpgd.dato_caracter%type;
     v_clase_fijo  arplpgd.dato_caracter%type;
     r_emp_limpio  datos_emp_r;
     msg           varchar2(250);
     --
     CURSOR c_resum_tiempo(pcod_pla varchar2) IS
        SELECT dias_reposo
        FROM arplppo
        WHERE no_cia   = pno_cia
          AND cod_pla  = pcod_pla
          AND no_emple = pno_emple;
   BEGIN
      if gNueva_instancia OR
         rEmp.no_emple is null OR
        (pno_cia != rEmp.no_cia OR pno_emple != rEmp.no_emple) then
         gimponible := FALSE;
         rEmp := r_emp_limpio;
         open c_datos_emp(pno_cia, pno_emple, phorasxpla);
         fetch c_datos_emp into rEmp.no_cia,
                                rEmp.no_emple,
			        rEmp.estado,
			        rEmp.f_ingreso,
			        rEmp.tipo_emp,
                                rEmp.sal_bas,
			        rEmp.sal_hora;
         close c_datos_emp;
         -- calcula el salario base semanal
         if rpla.jornada = 'S' then
            rEmp.sal_bas_sem := rEmp.sal_bas;
         elsif rpla.jornada = 'B' then
            rEmp.sal_bas_sem := rEmp.sal_bas / 2;
         elsif rpla.jornada = 'Q' then
            rEmp.sal_bas_sem := (rEmp.sal_bas * 2 * 12) / 52;
         elsif rpla.jornada = 'M' then
            rEmp.sal_bas_sem := (rEmp.sal_bas * 12) / 52;
         end if;
         --
         rEmp.dias_reposo := 0;

         OPEN c_resum_tiempo(rPla.cod_pla);
         FETCH c_resum_tiempo INTO rEmp.dias_reposo;
         CLOSE c_resum_tiempo;
      end if;
   END;
   --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN IS
   BEGIN
      RETURN ( nvl(rCia.no_cia,'*NULO*') = pCia);
   END inicializado;
   /***********************************[ PARTE: FORMULAS ]***********************************
   * En esta secci?n se encuenta la implementaci?n de las formulas predefinidas
   *
   */
   --
   --
   PROCEDURE calc_imp_sal(
      pno_cia        in arplme.no_cia%type
      ,pcod_pla      in arplcp.codpla%type
      ,pno_emple     in arplme.no_emple%type
      ,pno_dedu      in arplmd.no_dedu%type
   ) IS
     --
     -- Calcula el monto de deduccion correspondiente Impuesto al salario para el empleado dado.
     --
     vfr	      number := rPla.redondeo;
     vgrupo_ing	      arplmd.grupo_ing%type;
     vsal_min_grab    number;
     vtot_ing	      number;
     vtot_ing_o	      number;
     vtot_ded	      number;
     vtot_ded_o	      number;
     --
     vexceso	    arplppi.monto%type;
     vcreditos	    arplppi.monto%type;
     vt_adelantos   arplppd.monto%type;
     v_e_civil      arplme.e_civil%type;
     v_cant_hijos   number(2);

     -- Selecciona el total de ingresos a los que se aplica el impuesto
     CURSOR c_ting_esta_pla(pno_emple VARCHAR2,pgrupo_ing VARCHAR2) IS
       SELECT SUM( NVL(i.monto,0) )
       FROM arplppi i, arplgid gi
       WHERE i.no_cia   = pno_cia
         AND i.cod_pla  = pcod_pla
         AND i.no_emple = pno_emple
         AND i.no_cia   = gi.no_cia
         AND i.no_ingre = gi.no_ingre
         AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de ingresos a los que se aplica el impuesto
     CURSOR c_ting_otras_pla(pno_emple VARCHAR2,pgrupo_ing VARCHAR2) IS
        SELECT SUM(h.monto)
        FROM arplhs h, arplgid gi
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      = rPla.mes_proce
          AND h.tipo_m   = 'I'
          AND h.no_cia   = gi.no_cia
          AND h.codigo   = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de deducciones de la planilla actual
     -- que reducen el monto imponible de renta
     CURSOR c_tded_esta_pla(pno_emple VARCHAR2) IS
       SELECT SUM( NVL(d.monto,0) )
       FROM arplppd d, arplmd md
       WHERE d.no_cia   = pno_cia
         AND d.cod_pla  = pcod_pla
         AND d.no_emple = pno_emple
         AND d.no_dedu  != pno_dedu
         AND d.no_cia   = md.no_cia
         AND d.no_dedu  = md.no_dedu
         AND md.solo_cia = 'N'
         AND md.aplica_renta = 'S';

     -- Selecciona el total de deducciones de otras planilla
     -- que reducen el monto imponible de renta
     CURSOR c_tded_otras_pla(pno_emple VARCHAR2) IS
        SELECT SUM(h.monto)
        FROM arplhs h, arplmd md
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      = rPla.mes_proce
          AND h.tipo_m   = 'D'
          AND h.codigo  != pno_dedu
          AND h.no_cia   = md.no_cia
          AND h.codigo   = md.no_dedu
          AND md.solo_cia = 'N'
          AND md.aplica_renta = 'S';

     -- El siguiente cursor extrae los rangos y porcentajes utilizados
     -- en el calculo del impuesto al salario
     CURSOR c_rangos_sal IS
       SELECT limiteinf, limitesup, porcentaje
       FROM arplis
       WHERE no_cia = pno_cia
       ORDER BY limiteinf;
   BEGIN
     -- Saca el salario minimo grabable
     BEGIN
       SELECT MIN(limiteinf) INTO vsal_min_grab
         FROM arplis
         WHERE no_cia = pno_cia;
     EXCEPTION
        WHEN no_data_found THEN
           null;
     END;
    -- total de ingresos en esta planilla
    OPEN c_ting_esta_pla(pno_emple, rDed.grupo_ing);
    FETCH c_ting_esta_pla INTO vtot_ing;
    CLOSE c_ting_esta_pla;
    vtot_ing := nvl(vtot_ing,0);
    -- Debe recuperar
    -- el total de ingresos de planillas anteriores correspondientes
    -- al mismo mes que se encuentran ya en el historico de movims.
    OPEN c_ting_otras_pla(pno_emple, rDed.grupo_ing);
    FETCH c_ting_otras_pla INTO vtot_ing_o;
    CLOSE c_ting_otras_pla;
    vtot_ing := vtot_ing + NVL(vtot_ing_o,0);
    -- ---
    -- calcula el total de deducciones que reducen el imponible
    OPEN c_tded_esta_pla(pno_emple);
    FETCH c_tded_esta_pla INTO vtot_ded;
    CLOSE c_tded_esta_pla;
    vtot_ded := nvl(vtot_ded,0);
    OPEN c_tded_otras_pla(pno_emple);
    FETCH c_tded_otras_pla INTO vtot_ded_o;
    CLOSE c_tded_otras_pla;
    vtot_ded := vtot_ded + NVL(vtot_ded_o,0);
    -- al total ingresos quita las deducciones que reducen
    -- el imponible de renta
    vtot_ing := vtot_ing - vtot_ded;
    -- Si el total de ingresos es superior al minimo grabable
    -- calcula el impuesto al salario
    IF vtot_ing > vsal_min_grab THEN
	    vexceso := 0;
	     BEGIN
	       SELECT e_civil,
	              SUM(DECODE(fe.parentesco,'H',1,0)) cant_hijos
		       INTO v_e_civil,
		       v_cant_hijos
		FROM arplme e, arplmeh fe
		 WHERE e.no_cia  = pno_cia
		   AND e.no_emple = pno_emple
		   AND e.no_cia   = fe.no_cia (+)
		   AND e.no_emple = fe.no_emple (+)
		GROUP BY e.no_emple, e.e_civil;
		   EXCEPTION
		     WHEN OTHERS THEN
		       genera_error('IMP_SAL. ' || sqlerrm);
		     END;
		  FOR f2 IN c_rangos_sal LOOP
		       IF vtot_ing > f2.limitesup THEN
		         vexceso := vexceso + (f2.limitesup - f2.limiteinf) *
		                           (f2.porcentaje/100);
		        ELSE
		          vexceso := vexceso + (vtot_ing - f2.limiteinf)*
		                          (f2.porcentaje/100);
		          EXIT;
		        END IF;
		     END LOOP;
		     --
		     -- Se rebaja ahora los creditos por conyuge e hijos
		     vcreditos := NVL(v_cant_hijos,0) * nvl(rCia.creditoxh,0);
		     IF v_e_civil = 'C' THEN
		        vCreditos := vCreditos + nvl(rCia.creditoxc,0);
		     END IF;
		     vExceso := nvl(vExceso,0) - vCreditos;
		     vExceso := vfr * ROUND(vexceso/vfr,0);	-- redondea el exceso

       END IF; --vtot_ing > vsal_min_grab


        -- Debe contemplar los adelantos de impuesto al salario que se
        -- Diesen en planillas anteriores
        BEGIN
          SELECT SUM(NVL(monto,0)) INTO vt_adelantos
            FROM arplhs
            WHERE no_cia   = pno_cia
              AND no_emple = pno_emple
              AND tipo_m   = 'D'
              AND ano      = rPla.ano_proce
              AND mes      = rPla.mes_proce
              AND codigo   = rCia.cod_ade_impsal;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
             vt_adelantos := 0;
             null;
        END;

       vExceso      := greatest(0, nvl(vExceso,0));
       vT_adelantos := nvl(vT_adelantos,0);

       -- Si el adento de imp. salario es mayor al impuesto al salario
       -- se debe crear un ingreso por devolucion.

       IF nvl(vExceso,0) >= nvl(vT_adelantos,0) THEN
             vExceso := nvl(vExceso,0) - nvl(vT_adelantos,0);
       ELSE
            IF rcia.cod_devol_adeimpsal is not null THEN
       	       vt_adelantos := abs(nvl(vExceso,0) - nvl(vT_adelantos,0));
       	       vExceso := 0;
        	      -- Genera ingreso por devolucion sobre lo que se habia deducido al empleado
       	       INSERT INTO arplppi(no_cia, cod_pla, no_emple,
       	                           no_ingre, ind_gen_auto, cantidad,
       	                           monto, modificado)
	       	       VALUES(pno_cia, pcod_pla, pno_emple,
	       	              rcia.cod_devol_adeimpsal,
	       	              'A', vT_adelantos, vT_adelantos,'N');
            END IF;
       END IF;

       rCalc.monto    := vexceso;
       rCalc.total    := vexceso;

   END;--calc_imp_sal
   --
   --
   PROCEDURE calc_imp_extra_sal(
     pno_cia       in arplme.no_cia%type,
     pcod_pla      in arplcp.codpla%type,
     pno_emple     in arplme.no_emple%type,
     pno_dedu      in arplmd.no_dedu%type
   ) IS
     --
     -- Calcula el monto de deduccion por concepto del Impuesto Extraordinario sobre Renta
     -- Por ser un impuesto transitorio de duracion de un a?o, se programa con los rangos y
     -- porcentajes fijos, es decir :
     --                                Salario hasta 750,000         exento
     --                       Salario de 750,001 a 1,500,000         1.5 %
     --                        Salarios excediendo 1,500,001         3   %
     --
     vfr	            number := rPla.redondeo;
     vGrupo_ing	      arplmd.grupo_ing%type;
     vSal_min_grab    number;
     vTot_ing	        number;
     vTot_ing_o	      number;
     --
     vExceso	        arplppi.monto%type;

     -- Selecciona el total de ingresos a los que se aplica el impuesto
     CURSOR c_ting_esta_pla(pno_emple varchar2, pgrupo_ing varchar2) IS
       SELECT sum( nvl(i.monto,0) )
         FROM arplppi i, arplgid gi
        WHERE i.no_cia   = pno_cia
          AND i.cod_pla  = pcod_pla
          AND i.no_emple = pno_emple
          AND i.no_cia   = gi.no_cia
          AND i.no_ingre = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de otros ingresos (anteriores en el mismo mes) a los que se aplica el impuesto
     CURSOR c_ting_otras_pla(pno_emple varchar2, pgrupo_ing varchar2) IS
       SELECT sum(h.monto)
         FROM arplhs h, arplgid gi
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      = rPla.mes_proce
          AND h.tipo_m   = 'I'
          AND h.no_cia   = gi.no_cia
          AND h.codigo   = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

   BEGIN

     -- ---
     -- Establece el salario minimo grabable
     vSal_min_grab := 750000;

     -- obtiene el total de ingresos en esta planilla
     OPEN  c_ting_esta_pla(pNo_emple, rDed.grupo_ing);
     FETCH c_ting_esta_pla INTO vTot_ing;
     CLOSE c_ting_esta_pla;
     vTot_ing := nvl(vTot_ing,0);

     -- ---
     -- Obtiene el total de ingresos de planillas anteriores correspondientes
     -- al mismo mes que se encuentran ya en el historico de movims.
     OPEN  c_ting_otras_pla(pNo_emple, rDed.grupo_ing);
     FETCH c_ting_otras_pla INTO vTot_ing_o;
     CLOSE c_ting_otras_pla;
     vTot_ing := vTot_ing + nvl(vTot_ing_o,0);

     -- Si el total de ingresos es superior al minimo grabable
     -- calcula el impuesto al salario
     IF vtot_ing > vsal_min_grab THEN
 	     vexceso := 0;

       IF vTot_ing > 1500000 THEN
       	 --
       	 -- si el ingreso es mayor que 1.5 millones, calcula el excedente sobre 1.5 millones y
       	 -- le aplica el 3%
		     vExceso := vExceso + (vTot_ing - 1500001) * (3/100);

		     --
		     -- adicionalmente tambien debe aplicarle el 1.5 % sobre el rango anterior
       	 vExceso := vExceso + (1500000 - 750001) * (1.5/100);

       ELSE
       	 --
       	 -- si el total de ingresos es menor que 1.5 millones, calcula el excedente sobre los 750 mil
       	 -- y le aplica el 1.5 %
       	 vExceso := vExceso + (vTot_ing - 750001) * (1.5/100);
       END IF;

	     vExceso := vfr * round(vexceso/vfr,0);	-- redondea el exceso

     END IF; -- vtot_ing > vsal_min_grab

     rCalc.monto    := vexceso;
     rCalc.total    := vexceso;

   END; -- calc_imp_extra_sal
   --
   --
   FUNCTION obtiene_imponible_ccss(
     pno_cia   arplppd.no_cia%type,
     pcod_pla  arplppd.cod_pla%type,
     pno_emple arplppd.no_emple%type,
     pno_dedu  arplppd.no_dedu%type
   ) RETURN number IS
     --
     -- Obtiene el imponible sobre el cual se calculan las deducciones de la C.C.S.S.
     --
     vmonto_imponible   arplfpp.valor%type;     -- imponible
     vmonto_penvol      arplecl.valor%type;     -- monto x pension voluntaria
     vded_penvol        arplmd.no_dedu%type;    -- deduccion x pension voluntaria
     vcl_penvol 		    arplecl.clase_emp%type; -- clase x pension voluntaria
     vmonto_dedpenvol   arplppd.monto%type;     -- monto ded. x pension voluntaria
     vmonto_gr_ingresos arplppi.monto%type;     -- monto x grupo de ingresos
     vmonto_max_penvol  arplppd.monto%type;     -- monto maximo a deducir x pension voluntaria
 		 vexiste 					  boolean;
   BEGIN
     if gimponible then
       -- el imponible ya habia sido calculado
        vmonto_imponible := rEmp.imponible_ccss;
     else
       -- Se debe calcular el imponible
       -- obtiene el codigo de la clase por pension voluntaria
       vexiste := pllib.trae_parametro('CODCL_PENSIONVOL',vcl_penvol);
       if vexiste then
       	 -- obtiene el monto x pension voluntaria
         vmonto_penvol := pllib.obtiene_valor_emp_clase(pno_cia, pno_emple, vcl_penvol);
       end if;

       -- obtiene el codigo de la deduccion por pension voluntaria
       vexiste := pllib.trae_parametro('CODDED_PENSIONVO',vded_penvol);
       if vexiste then
       	 NULL;
         -- obtiene el monto de la deduccion voluntaria
       	 --vmonto_dedpenvol := pllib.monto_ded_pp(pno_cia, pno_emple, vded_penvol, pcod_pla);
       end if;

       -- obtiene el monto total de ingresos segun un grupo de ingresos
       vmonto_gr_ingresos := pllib.monto_grupo_ing_pp(pno_cia,pno_emple,rDed.grupo_ing,pcod_pla);

       --pllib.guarda_datos_formula(pno_cia,pcod_pla,pno_emple,'CCSS','IMPONIBLE','D',vmonto_gr_ingresos);

       -- el monto a deducir por pensi?n voluntaria no debe ser mayor al 10% del salario
       vmonto_max_penvol := least(nvl(vmonto_gr_ingresos,0)* 0.1,nvl(vmonto_penvol,0)+nvl(vmonto_dedpenvol,0));

       IF rded.solo_cia = 'N' THEN
         -- obtiene el imponible del empleado: total de ingresos - deduccion x pensi?n voluntaria
         vmonto_imponible := nvl(vmonto_gr_ingresos,0) - nvl(vmonto_max_penvol,0);
       ELSE
         -- obtiene el imponible del patrono: total de ingresos.
         -- La pension voluntaria NO es un beneficio del patrono, solo del empleado, por tanto NO
         -- debe restarse.
         vmonto_imponible := nvl(vmonto_gr_ingresos,0);
       END IF;

       -- almacena el imponible en el registro de informaci?n de empleados
       rEmp.imponible_ccss:= vmonto_imponible;
       gImponible := TRUE;
     end if;
     return(nvl(vmonto_imponible,0));
  END;

   -- Calculo de la deducci?n correspondiente a la C.C.S.S
   PROCEDURE calc_ccss( pno_cia       in arplppd.no_cia%type
	  									 ,pcod_pla      in arplppd.cod_pla%type
      								 ,pno_emple     in arplppd.no_emple%type
      								 ,pno_dedu      in arplppd.no_dedu%type
   										) IS
     vimponible number;  -- imponible
	   vmonto     number;  -- monto de la deduccion CCSS
   BEGIN
     if rDed.tipo not in ('1','3') then
	   -- la deducci?n no es porcentual
	    genera_error('La formula de c lculo para la C.C.S.S. solo aplica a deducciones Porcentuales.');
     end if;
     -- obtiene el imponible
     vimponible := obtiene_imponible_ccss(pno_cia,pcod_pla,pno_emple,pno_dedu);
     -- obtiene el monto de la deduccion
     vmonto := vimponible * (rDed.monto/100);
     -- Guarda en el registo de Calculo los resultados
     rCalc.monto := vmonto;
     rCalc.total := vimponible;
     rCalc.tasa  := rDed.monto;
     -- Guarda informaci?n formula
     --pllib.guarda_datos_formula(pno_cia,pcod_pla,pno_emple,'CCSS','IMPONIBLEPV','D',vimponible);
   END;
   /***********************************[ PARTE: PUBLICA ]***********************************
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   --
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
      RETURN(vMensaje_error);
   END ultimo_error;
   --
   -- ---
   PROCEDURE inicializa(pCia varchar2) IS
     CURSOR c_cia IS
       SELECT cod_h_ord,cod_impsal,cod_provi_vac,
              cod_ade_impsal, cod_devol_adeimpsal, creditoxc, creditoxh
       FROM arplpar
       WHERE no_cia = pCia;
   BEGIN
      limpia_error;
      open c_cia;
      fetch c_cia into rCia.cod_h_ord,
                       rCia.cod_impsal,
                       rCia.cod_provi_vac,
                       rCia.cod_ade_impsal,
		       rCia.cod_devol_adeimpsal,
                       rCia.creditoxc,
                       rCia.creditoxh;
      close c_cia;
   END inicializa;
   --
   -- ---
   FUNCTION calcula(
      pno_cia        in arplme.no_cia%type
      ,pcod_pla      in arplppd.cod_pla%type
      ,pno_emple     in arplppd.no_emple%type
      ,pno_dedu      in arplppd.no_dedu%type
      ,pformula_id   in arplmd.formula_id%type
   ) RETURN calculo_r
   IS
   BEGIN
     limpia_error;
     -- limpia el registro del calculo
     rCalc.monto     := null;
     rCalc.total     := null;
     rCalc.tasa      := null;
     --
     if not inicializado(pno_cia) then
        inicializa(pno_cia);
     end if;
     carga_datos_pla(pno_cia, pcod_pla);
     carga_datos_emp(pno_cia, pno_emple, rpla.horasxpla);
     carga_datos_ded(pno_cia, pcod_pla, pno_dedu);
     --
     if pformula_id = 'IMP/RENTA' then
        calc_imp_sal(pno_cia, pcod_pla, pno_emple, pno_dedu);
     elsif pformula_id = 'EXTR/RENTA' then
        calc_imp_extra_sal(pno_cia, pcod_pla, pno_emple, pno_dedu);
     elsif pformula_id = 'CCSS' then
     	  calc_ccss(pno_cia, pcod_pla, pno_emple, pno_dedu);
     else
        genera_error('La l?gica para la f?rmula: '|| pformula_id ||' no ha sido escrita');
     end if;
     RETURN (rCalc);
   END calcula;
   --
END;   -- BODY deducciones_ley_cr
/
