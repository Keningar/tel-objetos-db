CREATE OR REPLACE PACKAGE            PLingresos_ley_cr AS
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
END PLingresos_ley_cr;
/


CREATE OR REPLACE PACKAGE BODY            PLingresos_ley_cr AS
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
      ,mes_proce	       arplcp.mes_proce%type
      ,diasxmes          arplte.dias_trab%type
      ,horasxmes         arplte.horxmes%type
      ,horasxpla         arplte.n_horas%type
      ,f_desde		       arplcp.f_desde%type
      ,f_hasta           arplcp.f_hasta%type
      ,ultima_pla        arplcp.ultima_planilla%type
      ,jornada           arplte.jornada%type
      ,planillasxmes	   number
      ,horasxdia         number
      ,diasxpla          number
   );
   --
   TYPE datos_emp_r IS RECORD(
       no_cia                   arplme.no_cia%type
      ,no_emple                 arplme.no_emple%type
      ,estado                   arplme.estado%type
      ,f_ingreso	              arplme.f_ingreso%type
      ,tipo_emp		              arplme.tipo_emp%type
      ,sal_bas 		              number
      ,sal_bas_sem              number
      ,sal_min_ref_ded_sem      number
      ,sal_hora		              number
      ,dias_lab                 arplppo.dias_lab%type
      ,dias_nolab               arplppo.dias_nolab%type
      ,dias_reposo              arplppo.dias_reposo%type
      ,dias_feriados            arplppo.dias_feriados%type
      ,dias_prenatal            arplppo.dias_prenatal%type
      ,dias_postnatal           arplppo.dias_postnatal%type
      ,dias_vacaciones          arplppo.dias_vacaciones%type
      ,dias_fer_en_vacac        arplppo.dias_vacaciones%type
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
               dias_prenatal, dias_postnatal,
               dias_vacaciones, dias_fer_en_vacac
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
         rEmp.dias_lab          := 0;
         rEmp.dias_nolab        := 0;
         rEmp.dias_reposo       := 0;
         rEmp.dias_feriados     := 0;
         rEmp.dias_prenatal     := 0;
         rEmp.dias_postnatal    := 0;
         rEmp.dias_vacaciones   := 0;
         rEmp.dias_fer_en_vacac := 0;
         --
         OPEN c_resum_tiempo(rPla.cod_pla);
         FETCH c_resum_tiempo INTO rEmp.dias_lab, rEmp.dias_nolab,
                                   rEmp.dias_reposo, rEmp.dias_feriados,
                                   rEmp.dias_prenatal, rEmp.dias_postnatal,
                                   rEmp.dias_vacaciones, rEmp.dias_fer_en_vacac;
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
     vcantidad        NUMBER;
     vtot_ing         NUMBER;
     vsal_referencia  NUMBER;
   BEGIN
     vferiados := nvl(rEmp.dias_feriados,0);
     IF vferiados > 0 THEN
        vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        if rIng.dep_sal_hora = 'S' then
          vsal_referencia := vsal_referencia / rPla.horasxdia;
         	vcantidad := vferiados * rPla.horasxdia;
        else
        	vcantidad := vferiados;
        end if;
        rCalc.cantidad  := vcantidad;
        rCalc.monto     := vsal_referencia * rCalc.cantidad;
     END IF;
   END;  -- calc dias feriados
   -- ---
   -- DIAS INCAPACIDAD
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
     vcantidad        NUMBER;
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
        -- obtiene el salario diario
        vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        if rIng.dep_sal_hora = 'S' then
          -- depende del salario Hora
          vsal_referencia := vsal_referencia / rPla.horasxdia;
        	vcantidad := vdias * rPla.horasxdia;
        else
        	vcantidad := vdias;
        end if;
        rCalc.cantidad  := vcantidad;
        rCalc.monto     := vsal_referencia * rCalc.cantidad * rIng.tasa_mult;
     END IF;
   END;  -- -- calc dias reposo
   --
   -- ---
   -- DIAS INCAPACIDAD POR MATERNIDAD
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
     vcantidad        NUMBER;
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
        -- obtiene el salario diario
        vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        if rIng.dep_sal_hora = 'S' then
          -- depende del salario Hora
          vsal_referencia := vsal_referencia / rPla.horasxdia;
        	vcantidad := vdias * rPla.horasxdia;
        else
        	vcantidad := vdias;
        end if;
        rCalc.cantidad  := vcantidad;
        rCalc.monto     := vsal_referencia * rCalc.cantidad * rIng.tasa_mult;
     END IF;
   END;   -- pre-natal y post-natal
   --
   --
   --CALCULO DE DIAS DE VACACIONES
   --
   PROCEDURE calc_vacaciones(
      pNo_cia        arplppi.no_cia%type
     ,pCod_pla       arplppi.cod_pla%type
     ,pNo_emple      arplppi.no_emple%type
     ,pNo_ingre      arplppi.no_ingre%type
   )
   IS
     vVacaciones      NUMBER;
     vCantidad        NUMBER;
     vSal_referencia  NUMBER;
   BEGIN
     --Calcula el monto de acuerdo con la cantidad de dias de vacaciones
     vVacaciones := nvl(rEmp.dias_vacaciones,0)- nvl(rEmp.dias_fer_en_vacac,0) ;
     IF vVacaciones > 0 THEN
        vSal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        IF rIng.dep_sal_hora = 'S' THEN
          vSal_referencia := vSal_referencia / rPla.horasxdia;
         	vCantidad := vVacaciones * rPla.horasxdia;
        ELSE
        	vCantidad := vVacaciones;
        END IF;

        --Almacena la cantidad dias y el monto a pagar por esos dias
        rCalc.cantidad  := vCantidad;
        rCalc.monto     := vSal_referencia * rCalc.cantidad;
     END IF;
   END;  -- calc_vacaciones


   -- ---
   -- CALCULO DEL ADICIONAL DE INCAPACIDAD (eje. 66.00%)
   PROCEDURE calc_adicional_reposos(
      pno_cia      arplppi.no_cia%type
     ,pcod_pla     arplppi.cod_pla%type
     ,pno_emple    arplppi.no_emple%type
     ,pno_ingre    arplppi.no_ingre%type
     ,pclase_mov   varchar2     -- ejemplo, I, M
   )
   IS
     vdias            NUMBER;
     vcantidad        NUMBER;
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
        -- obtiene el salario diario
        vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
        if rIng.dep_sal_hora = 'S' then
           -- depende del salario Hora
           vsal_referencia := vsal_referencia / rPla.horasxdia;
           vcantidad := vdias * rPla.horasxdia;
        else
        	vcantidad := vdias;
        end if;
        rCalc.cantidad  := vcantidad;
        rCalc.monto     := vsal_referencia * rCalc.cantidad * rIng.tasa_mult;
     END IF;
   END;   -- adicional del reposo
   --
   --
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
     elsif pformula_id = 'REPOSO_AD' then
        calc_adicional_reposos(pno_cia, pcod_pla, pno_emple, pno_ingre, 'I');
     elsif pformula_id = 'PYP_NATAL1' then
	     calc_reposo_maternidad(pno_cia, pcod_pla, pno_emple, pno_ingre, 'M');
     elsif pformula_id = 'PYPNATALAD' then
       calc_adicional_reposos(pno_cia, pcod_pla, pno_emple, pno_ingre, 'M');
     elsif pformula_id = 'VACACIONES' then
        calc_vacaciones(pNo_cia, pCod_pla, pNo_emple, pNo_ingre);
     else
       genera_error('La logica para la formula: '|| pformula_id ||' no ha sido escrita');
     end if;
     gNueva_instancia := FALSE;
     RETURN (rCalc);
   END calcula;
   --
END;   -- BODY ingresos_ley_cr
/
