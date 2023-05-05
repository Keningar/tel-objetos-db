CREATE OR REPLACE PACKAGE            PLingresos_ley_ven AS
   --
   --  Este paquete contiene un conjunto de procedimientos y funciones que
   --  que implementan el calculo de ingresos definidos por la ley del pais
   --  Los calculos no realizan redondeos a menos que, las caracteristicas
   --  del ingreso asi lo exijan.
   --
   --
   SUBTYPE calculo_r IS PLlib.PLingresos_calc_r;
   --
   -- Inicializa el paquete, cargando informacion sobre la cuenta contable
   PROCEDURE inicializa(pCia varchar2);
   --
   -- Realiza el calculo del ingreso De ley
   FUNCTION calcula(
      pno_cia        in arplme.no_cia%type
      ,pcod_pla      in arplppi.cod_pla%type
      ,pno_emple     in arplppi.no_emple%type
      ,pno_ingre     in arplppi.no_ingre%type
      ,pformula_id   in arplmi.formula_id%type
      ,pcantidad     in arplppi.cantidad%type
   ) RETURN calculo_r;
   --
   -- Devuelve laa descripcion del ultimo error ocurrido
   FUNCTION  ultimo_error RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20015);
   kNum_error      NUMBER := -20015;
END PLingresos_ley_ven;
/


CREATE OR REPLACE PACKAGE BODY            PLingresos_ley_ven AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   --
   -- ---
   -- TIPOS
   --
   TYPE param_cia_r IS RECORD(
      no_cia            arplmc.no_cia%type,
      sal_min_nacional  arplmc.salario_min%type
   );
   --
   TYPE datos_pla_r IS RECORD(
       no_cia            arplcp.no_cia%type
      ,cod_pla           arplcp.codpla%type
      ,tipla             arplcp.tipla%type
      ,redondeo          arplcp.redondeo%type
      ,ano_proce         arplcp.ano_proce%type
      ,mes_proce	 arplcp.mes_proce%type
      ,diasxmes          arplte.dias_trab%type
      ,horasxmes         arplte.horxmes%type
      ,horasxpla         arplte.n_horas%type
      ,f_desde		 arplcp.f_desde%type
      ,f_hasta           arplcp.f_hasta%type
      ,ultima_pla        arplcp.ultima_planilla%type
      ,jornada           arplte.jornada%type
      ,planillasxmes	 number
      ,horasxdia         number
      ,diasxpla          number
   );
   --
   TYPE datos_emp_r IS RECORD(
       no_cia           arplme.no_cia%type
      ,no_emple         arplme.no_emple%type
      ,estado           arplme.estado%type
      ,f_ingreso		arplme.f_ingreso%type
      ,tipo_emp			arplme.tipo_emp%type
      ,sal_bas 			number
      ,sal_bas_sem              number
      ,sal_min_ref_ded_sem 	number
      ,sal_hora		   	number
      ,clase_ing           	varchar2(1)
      ,dias_lab                 number
      ,dias_nolab               number
      ,dias_reposo              number
      ,dias_feriados            number
      ,dias_prenatal            number
      ,dias_postnatal           number
   );
   --
   TYPE datos_ing_r IS RECORD(
      no_cia            arplmi.no_cia%type
      ,no_ingre         arplmi.no_ingre%type
      ,tipo_ing         arplmi.tipo_ing%type
      ,tasa_mult        arplmi.tasa_mult%type
      ,dep_sal_hora     arplmi.dep_sal_hora%type
      ,grupo_ing        arplmi.grupo_ing%type
   );
   --
   -- ---
   -- CURSORES:
   --
   CURSOR c_datos_pla(  pno_cia     arplcp.no_cia%type
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
   CURSOR c_salario_empleado(
                        pno_cia     arplcp.no_cia%type
                        ,pcod_pla   arplhs.COD_PLA%type
						,pemple     arplhs.NO_EMPLE%type
						,panno_ini  arplhs.ANO%type
						,panno_fin  arplhs.ANO%type
						,pmes_ini   arplhs.MES%type
						,pmes_fin   arplhs.MES%type
                        ) IS
         SELECT Sum(monto) monto
           FROM arplhs
          WHERE no_cia      =       pno_cia
            AND cod_pla     =       pcod_pla
            AND no_emple    =       pemple
			AND tipo_m      =       'I'
            AND ano*100+mes between panno_ini*100+pmes_ini AND
			                        panno_fin*100+pmes_fin;
   --
   CURSOR c_datos_ing(
                        pno_cia     arplmi.no_cia%type
                        ,pno_ingre  arplmi.no_ingre%type
                        ) IS
      SELECT no_cia, no_ingre, tipo_ing,
             tasa_mult, dep_sal_hora, grupo_ing
         FROM arplmi
         WHERE no_cia   = pno_cia
           AND no_ingre = pno_ingre;
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
   rCalc             calculo_r;
   rCia              param_cia_r;
   rIng              datos_ing_r;
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
      vMensaje_error := SUBSTR('LEY.'|| msj_error,1,160);
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
   PROCEDURE carga_datos_ing(
      pno_cia        arplmi.no_cia%type
     ,pno_ingre      arplmi.no_ingre%type
   ) IS
   BEGIN
      if gNueva_instancia OR
         rIng.no_ingre is null OR
         (pno_cia != rIng.no_cia OR pno_ingre != rIng.no_ingre) then
         OPEN c_datos_ing(pno_cia, pno_ingre);
         FETCH c_datos_ing INTO rIng;
         CLOSE c_datos_ing;
      end if;
   END;
   --
   --
   PROCEDURE carga_datos_emp(
       pno_cia       arplme.no_cia%type
      ,pno_emple     arplme.no_emple%type
      ,phorasxpla    number
   )
   IS
     --
     v_clase_var   arplpgd.dato_caracter%type;
     v_clase_fijo  arplpgd.dato_caracter%type;
     msg           varchar2(250);
     --
     CURSOR c_resum_tiempo(pcod_pla varchar2) IS
        SELECT dias_lab, dias_nolab,
               dias_reposo, dias_feriados,
               dias_prenatal, dias_postnatal
        FROM arplppo
        WHERE no_cia   = pno_cia
          AND cod_pla  = pcod_pla
          AND no_emple = pno_emple;
   BEGIN
      if gNueva_instancia OR
         rEmp.no_emple is null OR
        (pno_cia != rEmp.no_cia OR pno_emple != rEmp.no_emple) then
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
         IF pllib.Obtiene_clase_var (v_clase_var,msg) AND
            pllib.Obtiene_clase_fijo (v_clase_fijo,msg) THEN
            IF pllib.existe_empleado_clase(pno_cia, pno_emple,v_clase_fijo) THEN
               -- El empleado recibe ingresos fijos
               rEmp.clase_ing := 'F';
            ELSIF pllib.existe_empleado_clase(pno_cia, pno_emple, v_clase_var) THEN
               -- El empleado recibe ingresos variables
               rEmp.clase_ing := 'V';
            ELSE
               genera_error('Falta asociar al empleado: '||pno_emple||
                            ' la clase de ingreso de sal. FIJO o VARIABLE');
            END IF;
         ELSE
           genera_error(msg);
         END IF;
         --
         rEmp.dias_lab        := 0;
         rEmp.dias_nolab      := 0;
         rEmp.dias_reposo     := 0;
         rEmp.dias_feriados   := 0;
         rEmp.dias_prenatal   := 0;
         rEmp.dias_postnatal  := 0;
         --
         OPEN c_resum_tiempo(rPla.cod_pla);
         FETCH c_resum_tiempo INTO rEmp.dias_lab, rEmp.dias_nolab,
                                   rEmp.dias_reposo, rEmp.dias_feriados,
                                   rEmp.dias_prenatal, rEmp.dias_postnatal;
         CLOSE c_resum_tiempo;
      end if;
   END;
   --
   -- --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN IS
   BEGIN
      RETURN ( nvl(rCia.no_cia,'*NULO*') = pCia);
   END inicializado;
   --
   --
   --
   -- ---
   -- DIAS FERIADOS
   --
   PROCEDURE feriados(
      pno_cia        arplppi.no_cia%type
     ,pcod_pla       arplppi.cod_pla%type
     ,pno_emple      arplppi.no_emple%type
     ,pno_ingre      arplppi.no_ingre%type
   )
   IS
     vferiados        NUMBER;
     vtot_ing         NUMBER;
     vsal_referencia  NUMBER;
   BEGIN
     vferiados := nvl(rEmp.dias_feriados,0);
     IF vferiados > 0 THEN
        IF rEmp.clase_ing = 'F' THEN
           vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        ELSIF rEmp.clase_ing = 'V' THEN
           vTot_ing    := PLLOCALIZACION.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
                                               pNo_Emple,      rEmp.f_Ingreso, rpla.ano_proce,
                                               rpla.mes_Proce, rIng.grupo_ing, 1);
           vsal_referencia := nvl((nvl(vTot_ing,0) / 30) * 7,0);
        END IF;
        if rIng.dep_sal_hora = 'S' then
           vsal_referencia := vsal_referencia / rPla.horasxdia;
        end if;
        rCalc.cantidad  := vferiados;
        rCalc.monto     := vsal_referencia * rCalc.cantidad;
     END IF;
   END;  -- calc dias feriados
   --
   -- ---
   -- DIAS REPOSO
   --
   PROCEDURE calc_reposo(
      pno_cia      arplppi.no_cia%type
     ,pcod_pla     arplppi.cod_pla%type
     ,pno_emple    arplppi.no_emple%type
     ,pno_ingre    arplppi.no_ingre%type
     ,ptipo_mov    varchar2     -- I1 o I2
   )
   IS
     vdias            NUMBER;
     vtot_ing         NUMBER;
     vsal_referencia  NUMBER;
     --
     CURSOR c_dias IS
       SELECT SUM( nvl(dias,0) ) dias
       FROM arplappp
       WHERE no_cia   = pno_cia
         AND cod_pla  = pcod_pla
         AND no_emple = pno_emple
         AND tipo_mov = ptipo_mov
         AND ind_act  = 'A';
   BEGIN
     if rEmp.dias_reposo > 0 then
        OPEN c_dias;
        FETCH c_dias INTO vdias;
        CLOSE c_dias;
     end if;
     IF vdias > 0 THEN
        IF rEmp.clase_ing = 'F' THEN
           -- obtiene el salario diario
           vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        ELSIF rEmp.clase_ing = 'V' THEN
           vTot_ing    := PLLOCALIZACION.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
                                               pNo_Emple,      rEmp.f_Ingreso, rpla.ano_proce,
                                               rpla.mes_Proce, rIng.grupo_ing, 1);
           vsal_referencia := nvl((nvl(vTot_ing,0) / 30) * 7,0);
        END IF;
        if rIng.dep_sal_hora = 'S' then
           -- depende del salario Hora
           vsal_referencia := vsal_referencia / rPla.horasxdia;
        end if;
        rCalc.cantidad  := vdias;
        rCalc.monto     := vsal_referencia * rCalc.cantidad * rIng.tasa_mult;
     END IF;
   END;  -- -- calc dias reposo
   --
   -- ---
   -- DIAS REPOSO PRE-NATAL y POST-NATAL
   --
   PROCEDURE calc_reposo_maternidad(
      pno_cia      arplppi.no_cia%type
     ,pcod_pla     arplppi.cod_pla%type
     ,pno_emple    arplppi.no_emple%type
     ,pno_ingre    arplppi.no_ingre%type
     ,pclase_mov   varchar2     -- M
   )
   IS
     vdias            NUMBER;
     vtot_ing         NUMBER;
     vsal_referencia  NUMBER;
     --
     CURSOR c_dias IS
       SELECT SUM( nvl(dias,0) ) dias
       FROM arplappp
       WHERE no_cia    = pno_cia
         AND cod_pla   = pcod_pla
         AND no_emple  = pno_emple
         AND clase_mov = 'M'
         AND ind_act   = 'A';
   BEGIN
     if rEmp.dias_prenatal > 0 OR rEmp.dias_postnatal > 0 then
        OPEN c_dias;
        FETCH c_dias INTO vdias;
        CLOSE c_dias;
     end if;
     IF vdias > 0 THEN
        IF rEmp.clase_ing = 'F' THEN
           -- obtiene el salario diario
           vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        ELSIF rEmp.clase_ing = 'V' THEN
           vTot_ing    := PLLOCALIZACION.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
                                               pNo_Emple,      rEmp.f_Ingreso, rpla.ano_proce,
                                               rpla.mes_Proce, rIng.grupo_ing, 1);
           vsal_referencia := nvl((nvl(vTot_ing,0) / 30) * 7,0);
        END IF;
        if rIng.dep_sal_hora = 'S' then
           -- depende del salario Hora
           vsal_referencia := vsal_referencia / rPla.horasxdia;
        end if;
        rCalc.cantidad  := vdias;
        rCalc.monto     := vsal_referencia * rCalc.cantidad * rIng.tasa_mult;
     END IF;
   END;   -- pre-natal y post-natal
   --
   -- ---
   -- CALCULO DEL ADICIONAL AL REPOSO (eje. 66.66%)
   PROCEDURE calc_adicional_reposos(
      pno_cia      arplppi.no_cia%type
     ,pcod_pla     arplppi.cod_pla%type
     ,pno_emple    arplppi.no_emple%type
     ,pno_ingre    arplppi.no_ingre%type
     ,pclase_mov   varchar2     -- ejemplo, I, M
   )
   IS
     vdias            NUMBER;
     vtot_ing         NUMBER;
     vsal_referencia  NUMBER;
     --
     CURSOR c_dias IS
       SELECT SUM( nvl(dias,0) ) dias
       FROM arplappp
       WHERE no_cia    = pno_cia
         AND cod_pla   = pcod_pla
         AND no_emple  = pno_emple
         AND clase_mov = pclase_mov
         AND ((pclase_mov = 'I' AND tipo_mov = 'I2') OR
              (pclase_mov = 'M') )
         AND ind_act  = 'A';
   BEGIN
     if (pClase_mov = 'I' AND rEmp.dias_reposo > 0)
        OR (pClase_mov = 'M' AND rEmp.dias_prenatal > 0 OR rEmp.dias_postnatal > 0) then
        OPEN c_dias;
        FETCH c_dias INTO vdias;
        CLOSE c_dias;
     end if;
     IF vdias > 0 THEN
        IF rEmp.clase_ing = 'F' THEN
           -- obtiene el salario diario
           vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        ELSIF rEmp.clase_ing = 'V' THEN
           vTot_ing    := PLLOCALIZACION.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
                                               pNo_Emple,      rEmp.f_Ingreso, rpla.ano_proce,
                                               rpla.mes_Proce, rIng.grupo_ing, 1);
           vsal_referencia := nvl((nvl(vTot_ing,0) / 30) * 7,0);
        END IF;
        if rIng.dep_sal_hora = 'S' then
           -- depende del salario Hora
           vsal_referencia := vsal_referencia / rPla.horasxdia;
        end if;
        rCalc.cantidad  := vdias;
        rCalc.monto     := vsal_referencia * rCalc.cantidad * rIng.tasa_mult;
     END IF;
   END;   -- adicional del reposo
   --
   --   ************************************************
   --       Calculo de Distribucion de Utilidades
   --   ************************************************
   PROCEDURE Utilidad(
      pno_cia        arplme.no_cia%type
     ,pcod_pla       arplppi.cod_pla%type
     ,pno_emple      arplme.no_emple%type
   )
   IS
      -- Variables para obtener valores de parametros
      vDias_Pago          NUMBER;
	  vMes_Ini            NUMBER;
	  vMes_Fin            NUMBER;
      -- Cantidad de Dias a considerar, de acuerdo al tipo de Ingresos del Empleado
      vDias_Fijo          NUMBER := 360;
	  vDias_Variable      NUMBER := 364;
	  -- Variables de uso general
      vExiste_Parametro   BOOLEAN;
	  vSuma_Salarios      NUMBER;
	  vMonto_Ingreso      NUMBER;
	  vFecha_Inicial      DATE;
	  vFecha_Final        DATE;
	  vMeses_Lab_Periodo  NUMBER;
      vDias_Lab_Periodo   NUMBER;
   BEGIN
      -- Obtiene la cantidad de dias de salario que se pagaran
      vExiste_Parametro := PLLIB.Trae_Parametro('CANT_DIAS', vDias_Pago);
      IF NOT vExiste_Parametro THEN
	     genera_error('No se ha definido el parametro de dias a pagar CANT_DIAS');
	  END IF;
      -- Obtiene el mes a partir del cual se deben considerar los salarios
      vExiste_Parametro := PLLIB.Trae_Parametro('MES_INICIO', vMes_Ini);
      IF NOT vExiste_Parametro THEN
	     genera_error('No se ha definido el parametro de la fecha inicial MES_INICIO');
	  END IF;
      -- Obtiene el mes hasta el cual se consideraran los salarios
      vExiste_Parametro := PLLIB.Trae_Parametro('MES_FINAL', vMes_Fin);
      IF NOT vExiste_Parametro THEN
	     genera_error('No se ha definido el parametro de la fecha final MES_FINAL');
	  END IF;
      IF vMes_Ini < vMes_Fin THEN
         vFecha_Inicial := to_date(to_char(rpla.ano_proce *100+vmes_ini)||01, 'yyyymmdd');
         Open c_Salario_Empleado(pno_cia , pcod_pla, pno_emple,
		                         rpla.ano_proce, rpla.ano_proce, vMes_Ini,
								 vMes_Fin);
         Fetch c_Salario_Empleado INTO vSuma_Salarios;
		 Close c_Salario_Empleado;
	  ELSIF vMes_Ini > vMes_Fin THEN
         vFecha_Inicial := to_date(to_char((rpla.ano_proce-1)*100+vmes_ini)||01, 'yyyymmdd');
         Open c_Salario_Empleado(pno_cia ,   pcod_pla, pno_emple,
		                         rpla.ano_proce-1, rpla.ano_proce, vMes_Ini,
								 vMes_Fin);
         Fetch c_Salario_Empleado INTO vSuma_Salarios;
		 Close c_Salario_Empleado;
	  ELSE
	     genera_error('El mes de inicio no puede ser igual al mes final');
	  END IF;
	  vFecha_Final := to_date(to_char(rpla.ano_proce*100+vmes_fin)||01, 'yyyymmdd');
      vFecha_Final := Last_day(vFecha_Final);
	  IF vFecha_Inicial < remp.f_ingreso THEN
	     -- El empleado ingreso durante el periodo fiscal del cual se estan repartiendo utilidades
         -- Los calculos se realizan de acuerdo al tiempo laborado durante el periodo fiscal
         -- Se obtiene la cantidad de meses ENTEROS laborados para la empresa durante el periodo fiscal
	     vMeses_Lab_Periodo := PlLib.Obtiene_Meses(remp.f_ingreso, vFecha_Final);
		 vDias_Lab_Periodo  := TRUNC(vFecha_Final-remp.f_ingreso);
         vMonto_Ingreso := ((vSuma_Salarios/vDias_Lab_Periodo)*vDias_Pago*vMeses_Lab_Periodo)/12;
	  ELSE
	     -- El empleado laboro todo el periodo fiscal del cual se estan repartiendo utilidades
         -- Se hace diferencia entre ingresos fijos e ingresos variables
         If remp.clase_ing = 'V' THEN
	        vMonto_Ingreso := (vSuma_Salarios/vDias_Variable)*vDias_Pago;
         ELSIF remp.clase_ing = 'F' THEN
            vMonto_Ingreso := (vSuma_Salarios/vDias_Fijo)*vDias_Pago;
         ELSE
            genera_error('El tipo de ingreso del empleado no es valido');
         END IF;
	  END IF;
	  rcalc.monto := vMonto_Ingreso;
   END;
   -- *****************************************************
   --       Adicional de Prestaciones por Antiguedad
   -- *****************************************************
   PROCEDURE adicional_antiguedad (
     p_no_cia    CHAR,
     p_cod_pla   CHAR,
     p_no_emple  CHAR
   )
   IS
     vAplica_Desde      Date;
     v_anos              NUMBER(4);
     v_monto_diario     arplhs.monto%type;
     vCod_Provision     arplmd.no_dedu%type;
     v_monto_adicional  arplhs.monto%type := 0;
     v_MaxDias          NUMBER;
   BEGIN
     /* En el caso de que cumpla anualidad, calcula el adicional por anno
        Aplica solo cuando el empleado cumple a?os de laborar para la empresa
        (mismo mes de ingreso, a?o superior                                    */
     IF      to_char(rEmp.f_ingreso, 'MM')   = to_Char(rPla.f_hasta, 'MM')
         and to_char(rEmp.f_ingreso, 'YYYY') < to_Char(rPla.f_hasta, 'YYYY')  THEN
       /* Tomo el mayor entre la fecha de ingreso del empleado y la fecha en
          que se aprobo la ley y a esta fecha le agrego un a?o, porque en el
          segundo a?o ya debo pagarle                                        */
       vAplica_Desde := GREATEST(TO_DATE('19/06/1997','DD/MM/YYYY'),rEmp.f_ingreso);
       vAplica_Desde := Add_Months(vAplica_Desde, 12);
        /* Obtiene el codigo de la deduccion patronal de provision por antiguedad    */
       IF NOT pllib.trae_parametro('DED_PROVISION', vCod_Provision) THEN
         v_Monto_Adicional := 0;
         genera_error('No existe el parametro correspondiente al codigo de la provision por Antiguedad ');
       END IF;
       /* Obtiene el monto Diario a aplicar como adicional                          */
       v_Monto_Diario := (PLLIB.Total_Provision_Ultimo_Año (p_no_cia,   rPla.f_hasta,
                                                            p_no_emple, vCod_Provision))/60;
       v_anos        := TRUNC(pllib.Obtiene_meses(vAplica_Desde, rPla.f_hasta)/12);
        /* Obtiene la cantidad maxima de dias a pagar por adicional de antiguedad  */
       IF NOT pllib.trae_parametro('MAX_DIAS', v_MaxDias) THEN
         v_Monto_Adicional := 0;
         genera_error('No existe el parametro correspondiente a la cantidad maxima de dias de Adicional por Antiguedad');
       END IF;
        v_monto_adicional := LEAST(v_MaxDias,2*v_anos)* v_monto_diario;
     END IF;
     /* Calcula el monto total por prestaciones */
     rCalc.monto           := NVL(v_monto_adicional,0);
   END;
   --
   -- *****************************************************
   --       Vacaciones
   -- *****************************************************
   PROCEDURE vacaciones (
     p_no_cia    CHAR,
     p_no_emple  CHAR
   )
   IS
     v_monto_diario     arplhs.monto%type;
     v_monto            arplhs.monto%type;
     vDias_conv         NUMBER;
     v_dias             NUMBER;
     v_dias_adicionales NUMBER;
	 vdias_Bono         NUMBER;
	 v_dias_adic_bono   NUMBER;
	 v_cant_meses_der   NUMBER;
     v_MaxDias          NUMBER;
     v_MaxDiasBono      NUMBER;
	 v_DiasDerechoAnt   NUMBER;
   BEGIN
      -- Obtiene la cantidad de dias de salario que se pagaran
     vDias_conv := pllocalizacion.dias_convenio_vac(p_no_cia
	                                               ,p_no_emple);
     IF NOT PLLIB.Trae_Parametro('MESESDER', v_cant_meses_der) THEN
       v_cant_meses_der := '';
     END IF;
     -- Obtiene la cantidad maxima de dias a pagar por adicional de vacaciones
     IF NOT pllib.trae_parametro('MAXADICVAC', v_MaxDias) THEN
       genera_error('No existe el parametro correspondiente a la cantidad maxima de dias de Adicional por Vacaciones');
     END IF;
     -- Obtiene los dias adicionales de disfrute de vacaciones
     v_dias_adicionales := Pllocalizacion.adic_vacaciones(rPla.f_hasta,
	                                                      rEmp.f_ingreso,
                                                          to_date('01/05/1991','dd/mm/yyyy'),
				               						      v_cant_meses_der,
										                  v_maxDias);
     --*********************************************
     -- Calculo de bono vacacional
     --*********************************************
     vDias_bono := Pllocalizacion.DIAS_BONO_VAC(p_no_cia
	                                           ,p_no_emple);
     -- Obtiene la cantidad maxima de dias a pagar por adicional de bono vacacional
     IF NOT pllib.trae_parametro('MAXDIASBONO', v_MaxDiasBono) THEN
       genera_error('No existe el parametro correspondiente a la cantidad maxima de dias de Adicional por Bono');
     END IF;
     v_MaxDiasBono := v_MaxDiasBono - vDias_bono;
     -- Obtiene los dias adicionales de bono vacacional
     v_dias_adic_bono := Pllocalizacion.adic_vacaciones(rPla.f_hasta,
	                                                    rEmp.f_ingreso,
                                                        to_date('01/05/1991','dd/mm/yyyy'),
				            						    v_cant_meses_der,
										                v_maxDiasBono);
     -- Obtiene el monto Diario a aplicar como adicional
     v_Monto_Diario := PLLOCALIZACION.Salario_Diario_Ingresos ( p_no_cia
                                                      ,p_no_emple
                                                      ,rIng.grupo_ing
                                                      ,rPla.ano_proce
                                                      ,rPla.mes_proce
                                                      ,rPla.diasxmes
                                                      ,rPla.tipla
					                            	  ,rEmp.clase_ing
						                              ,rEmp.f_ingreso
						                              ,rPla.f_hasta);
     v_dias  := vDias_conv + v_dias_adicionales + vDias_bono + v_dias_adic_bono;
     v_monto := NVL(v_dias,0) * v_monto_diario;
     /* Calcula el monto total por prestaciones */
     rCalc.monto           := NVL(v_monto,0);
   END;
   -- ---
   --
   /*******[ PARTE: PUBLICA ]
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
       SELECT no_cia, salario_min
       FROM arplmc
       WHERE no_cia = pCia;
   BEGIN
      limpia_error;
      open c_cia;
      fetch c_cia into rCia.no_cia, rCia.sal_min_nacional;
      close c_cia;
      gNueva_instancia := TRUE;
   END inicializa;
   --
   -- ---
   FUNCTION calcula(
      pno_cia        in arplme.no_cia%type
      ,pcod_pla      in arplppi.cod_pla%type
      ,pno_emple     in arplppi.no_emple%type
      ,pno_ingre     in arplppi.no_ingre%type
      ,pformula_id   in arplmi.formula_id%type
      ,pcantidad     in arplppi.cantidad%type
   ) RETURN calculo_r
   IS
   BEGIN
     limpia_error;
     -- limpia el registro del calculo
     rCalc.cantidad  := null;
     rCalc.monto     := null;
     rCalc.monto_aux := null;
     rCalc.tasa      := null;
     rCalc.meses     := null;
     rCalc.dias      := null;
     --
     if not inicializado(pno_cia) then
        inicializa(pno_cia);
     end if;
     carga_datos_pla(pno_cia, pcod_pla);
     carga_datos_emp(pno_cia, pno_emple, rpla.horasxpla);
     carga_datos_ing(pno_cia, pno_ingre);
     --
     if pformula_id = 'FERIADOS' then
	feriados(pno_cia, pcod_pla, pno_emple, pno_ingre);
     elsif pformula_id = 'REPOSO1' then
	calc_reposo(pno_cia, pcod_pla, pno_emple, pno_ingre, 'I1');
     elsif pformula_id = 'REPOSO2' then
	calc_reposo(pno_cia, pcod_pla, pno_emple, pno_ingre, 'I2');
     elsif pformula_id = 'REPOSO5' then
        calc_adicional_reposos(pno_cia, pcod_pla, pno_emple, pno_ingre, 'I');
     elsif pformula_id = 'PYP_NATAL1' then
	calc_reposo_maternidad(pno_cia, pcod_pla, pno_emple, pno_ingre, 'M');
     elsif pformula_id = 'PYP_NATAL5' then
        calc_adicional_reposos(pno_cia, pcod_pla, pno_emple, pno_ingre, 'M');
     elsif pformula_id = 'UTILIDADES' then
        utilidad(pno_cia, pcod_pla, pno_emple);
     elsif pformula_id = 'ADIC_ANT' then
        adicional_antiguedad (pno_cia, pcod_pla, pno_emple);
     elsif pformula_id = 'VACACIONES' then
        vacaciones (pno_cia, pno_emple);
     else
	genera_error('La logica para la formula: '|| pformula_id ||' no ha sido escrita');
     end if;
     gNueva_instancia := FALSE;
     RETURN (rCalc);
   END calcula;
   --
END;   -- BODY ingresos_ley_ven
/
