CREATE OR REPLACE PACKAGE            PLdeducciones_ley_ven AS
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
END;  -- deducciones_ley_ven;
/


CREATE OR REPLACE PACKAGE BODY            PLdeducciones_ley_ven AS
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
      ,sal_min_nacional     arplmc.salario_min%type
      ,sal_min_ref_ded      number
      ,sal_min_ref_ded_sem  number
      ,clase_imp_renta      arplecl.clase_emp%type
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
      ,clase_ing       varchar2(1)
      ,dias_reposo     number
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
   --
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
         rEmp.dias_reposo := 0;
         --
         OPEN c_resum_tiempo(rPla.cod_pla);
         FETCH c_resum_tiempo INTO rEmp.dias_reposo;
         CLOSE c_resum_tiempo;
      end if;
   END;
   --
   --
   -- --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN IS
   BEGIN
      RETURN ( nvl(rCia.no_cia,'*NULO*') = pCia);
   END inicializado;
   --
   -- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
   -- Esta funcion devuelve TRUE Si el empleado esta jubilado o FALSE si no
   -- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
   Function Empleado_Jubilado (
      pCia        in arplecl.no_cia%type
      ,pno_emple  in arplecl.no_emple%type
   ) RETURN BOOLEAN
   IS
      vExiste_Parametro BOOLEAN;
      vFound            BOOLEAN;
      vJubilado         ARPLPGD.Dato_Caracter%type;
      vDummy            VArchar2(1);
      CURSOR c_existe_clase (pJubilado ARPLPGD.Dato_Caracter%type) IS
        SELECT 'X'
        FROM arplecl
        WHERE no_cia     = pCia
          AND no_emple   = pno_emple
          AND clase_emp  = pJubilado;
   BEGIN
      vExiste_Parametro := PLLIB.Trae_Parametro('PCLJ', vJubilado);
      OPEN c_existe_clase(vJubilado);
      FETCH c_existe_clase into vdummy;
      vFound := c_existe_clase%FOUND;
      CLOSE c_existe_clase;
      return (vFound);
   END;
   /***********************************[ PARTE: FORMULAS ]***********************************
   * En esta seccion se encuenta la implementacion de las formulas predefinidas
   *
   */
   --
   -- --                                                                 ** SEGURO SOCIAL
   -- Procedimiento que calcula el monto de deduccion de Seguro Social
   --
   PROCEDURE calc_sso_sal (
       pno_cia       IN arplme.no_cia%type
      ,pcod_pla      IN arplcp.codpla%type
      ,pno_emple     IN arplme.no_emple%type
      ,pno_dedu      IN arplmd.no_dedu%type
   ) IS
     vTot_Ing             NUMBER;
     vCantidad_Salarios   NUMBER;
     vsal_min_tope        NUMBER;
     vSalario_Referencia  NUMBER;
     vMonto_Deduccion     NUMBER;
     vCant_Lunes          NUMBER;
   BEGIN
     IF rEmp.clase_ing = 'F' THEN
        vSalario_referencia := nvl(rEmp.sal_bas_sem,0);
     ELSIF rEmp.clase_ing = 'V' THEN
        vTot_ing     := PLLOCALIZACION.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
                                             pNo_Emple,      rEmp.f_Ingreso,
                                             rpla.ano_proce, rpla.mes_Proce, rded.grupo_ing, 1);
        vSalario_referencia := nvl((nvl(vTot_ing,0) / 30) * 7,0);
     END IF;
     --
     --  Obtiene la cantidad de salarios minimos
     IF NOT PLLIB.Trae_Parametro('PSALMIN', vCantidad_Salarios) THEN
        Genera_Error('No se ha definido el parametro PSALMIN ');
     ELSE
        vsal_min_tope       := (rCia.sal_min_ref_ded_sem * vCantidad_Salarios);
        vSalario_Referencia := LEAST(vsal_min_tope , vSalario_Referencia);
        --
        vCant_Lunes         := PLLIB.Cuenta_Dias( Greatest(rpla.f_desde, remp.f_ingreso),
                                                  rpla.f_hasta, 'LUNES');
        vMonto_Deduccion    := (vSalario_Referencia * (rDed.Monto / 100)) * vCant_lunes;
        --
        rCalc.total    := vSalario_referencia;
        rCalc.tasa     := rDed.Monto;
        rCalc.monto    := vMonto_Deduccion;
     END IF;
   END; -- calc_sso_sal
   --
   -- --      ** PARO FORZOSO
   -- Procedimiento que calcula el monto de deduccion por paro forzoso
   --
   PROCEDURE calc_paro_forzoso (
       pno_cia       IN arplme.no_cia%type
      ,pcod_pla      IN arplcp.codpla%type
      ,pno_emple     IN arplme.no_emple%type
      ,pno_dedu      IN arplmd.no_dedu%type
   ) IS
     vTot_Ing             NUMBER;
     vCantidad_Salarios   NUMBER;
     vsal_min_tope        NUMBER;
     vSalario_Referencia  NUMBER;
     vMonto_Deduccion     NUMBER;
     vCant_Lunes          NUMBER;
   BEGIN
     IF rEmp.clase_ing = 'F' THEN
        vSalario_Referencia := nvl(rEmp.sal_bas_sem,0);
     ELSIF rEmp.clase_ing = 'V' THEN
        vTot_ing     := PLLOCALIZACION.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
                                             pNo_Emple,      rEmp.f_Ingreso,
                                             rpla.ano_proce, rpla.mes_Proce, rded.grupo_ing, 1);
        vSalario_Referencia := nvl((nvl(vTot_ing,0) / 30) * 7,0);
     END IF;
     --
     --  Obtiene la cantidad de salarios minimos
     IF NOT PLLIB.Trae_Parametro('TOPEPAROFORZO', vCantidad_Salarios) THEN
        Genera_Error('No se ha definido el parametro TOPEPAROFORZO ');
     ELSE
        vsal_min_tope       := (rCia.sal_min_ref_ded_sem * vCantidad_Salarios);
        vSalario_Referencia := LEAST(vsal_min_tope , vSalario_Referencia);
        --
        vCant_Lunes         := PLLIB.Cuenta_Dias( Greatest(rpla.f_desde, remp.f_ingreso),
                                                  rpla.f_hasta, 'LUNES');
        vMonto_Deduccion    := (vSalario_Referencia * (rDed.Monto / 100)) * vCant_lunes;
        --
        rCalc.total    := vSalario_referencia;
	rCalc.tasa     := rDed.Monto;
        rCalc.monto    := vMonto_Deduccion;
     END IF;
   END;  -- paro forsozo
   --
   -- --  ** POLITICA HABITACIONAL
   -- Procedimiento que calcula el monto de deduccion por politica habitacional
   --
   PROCEDURE calc_politica_hab (
       pno_cia       IN arplme.no_cia%type
      ,pcod_pla      IN arplcp.codpla%type
      ,pno_emple     IN arplme.no_emple%type
      ,pno_dedu      IN arplmd.no_dedu%type
   ) IS
     vTot_Ing             NUMBER;
     vSalario_Referencia  NUMBER;
     vMonto_Deduccion     NUMBER;
   BEGIN
        IF rEmp.clase_ing = 'F' THEN
           vSalario_Referencia := nvl(rEmp.sal_bas,0);
        ELSIF rEmp.clase_ing = 'V' THEN
           vTot_ing  := PLLOCALIZACION.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
                                             pNo_Emple,      rEmp.f_Ingreso,
                                             rpla.ano_proce, rpla.mes_Proce, rded.grupo_ing, 1);
           if rpla.jornada = 'S' then
              vSalario_Referencia := vTot_ing * 12 / 52;  -- 52 semanas al a?o
           elsif rpla.jornada = 'B' then
              vSalario_Referencia := vTot_ing * 12 / 26;  -- 26 bisemanas al a?o
           elsif rpla.jornada = 'Q' then
              vSalario_Referencia := vTot_ing / 2;
           elsif rpla.jornada = 'M' then
              vSalario_Referencia := vTot_ing;
           end if;
        END IF;
        --
        vMonto_Deduccion  := (vSalario_Referencia * (rDed.Monto / 100));
        --
        rCalc.total    := vSalario_referencia;
        rCalc.tasa     := rDed.Monto;
        rCalc.monto    := vMonto_Deduccion;
   END;  -- politica habitacional
   --
   -- ****************
   -- Obtiene alicuota por bono vacacional
   --
   FUNCTION Alicuota_bono (
     p_no_cia       VARCHAR2,
     p_cod_pla      VARCHAR2,
     p_no_emple     VARCHAR2,
     p_monto_diario NUMBER
   )RETURN NUMBER
   IS
     v_alicuota arplhs.monto%type;
     v_dias number(3);
     v_dias_anno number(3);
   BEGIN
     /* Obtiene el ingreso correspondiente a Bono Vacacional y su correspondiente grupo
        de ingresos   */
     IF rPla.tipla = 'S' THEN
       IF NOT pllib.trae_parametro('PALIOB',
                                      v_dias) THEN
         genera_error('No se ha definido el numero de dias para el calculo de alicuota para obreros');
       END IF;
       v_dias_anno := 364;
     ELSE
       IF NOT pllib.trae_parametro('PALIEM',
                                      v_dias) THEN
         genera_error('No se ha definido el numero de dias para el calculo de alicuota para empleados');
       END IF;
       v_dias_anno := 360;
     END IF;
     v_alicuota := (v_dias * p_monto_diario) / v_dias_anno;
     RETURN v_alicuota;
   EXCEPTION
     WHEN others THEN
	   genera_error(sqlerrm);
   END;
   --	*****************************************
   --    	Prestaciones por Antiguedad
   --	*****************************************
   --
   PROCEDURE prest_ant (
     p_no_cia    CHAR,
     p_cod_pla   CHAR,
     p_no_emple  CHAR,
     p_grupo_ing CHAR
   )
   IS
     vano               NUMBER(4);
     vmes_ant           NUMBER(2);
     v_clase_var        arplpgd.dato_caracter%type;
     v_clase_fijo       arplpgd.dato_caracter%type;
     v_monto_diario     arplhs.monto%type;
     v_monto_base       arplhs.monto%type;
     v_monto_adicional  arplhs.monto%type;
     v_monto            arplhs.monto%type;
     v_anos             number(3);
     v_anualidades      number(3);
     v_primer_dia_mes   date;
     v_alicuota_diaria  arplhs.monto%type;
     v_MaxDias          number(3);
     msg                varchar2(250);
   BEGIN
     /* Se devenga a partir del cuarto mes   */
     IF pllib.Obtiene_meses(rEmp.f_ingreso,rPla.f_hasta) >= 4 THEN
       /* Obtiene el mes anterior al mes en proceso  */
       IF rPla.mes_proce = 1 THEN
         vano     := rPla.ano_proce - 1;
         vmes_ant := 12;
       ELSE
         vano     := rPla.ano_proce;
         vmes_ant := rPla.mes_proce - 1;
       END IF;
       v_monto_diario := nvl(PLLOCALIZACION.Salario_Diario_Ingresos (p_no_cia,
                                                            p_no_emple,
                                                            p_grupo_ing,
							    vano,
							    vmes_ant,
							    rPla.diasxmes,
 							    rPla.tipla,
							    rEmp.clase_ing,
 							    rEmp.f_ingreso,
							    rPla.f_hasta), 0);
       v_alicuota_diaria := Alicuota_bono(p_no_cia,p_cod_pla,p_no_emple,v_monto_diario);
       v_monto_diario := v_monto_diario + nvl(v_alicuota_diaria,0);
       /* Calcula el monto base por prestaciones */
       v_monto_base := v_monto_diario * 5;
       /* Calcula el monto total por prestaciones */
       rCalc.monto := NVL(v_monto_base,0);
       rCalc.total := NVL(v_monto_base,0);
     ELSE
       rCalc.monto := 0;
       rCalc.total := 0;
     END IF;
   END;
   --
   --
   -- --
   -- Impuesto sobre la renta
   --
   PROCEDURE imp_renta (
     p_no_cia    CHAR,
     p_cod_pla   CHAR,
     p_no_emple  CHAR,
     p_grupo_ing CHAR
   )
   IS
     v_porcImpuesto  number;
     v_totalIng      arplppi.monto%type;
   BEGIN
     -- Obtiene el porcentaje a cobrar de impuesto sobre la renta por empleado
     v_porcImpuesto := PLlib.obtiene_valor_emp_clase(p_no_cia, p_no_emple, rCia.clase_imp_renta);
     --
     v_totalIng  := nvl(pllib.monto_grupo_ing_pp(p_no_cia, p_no_emple, p_grupo_ing, p_cod_pla), 0);
     rCalc.monto := (v_totalIng * NVL(v_porcImpuesto,0))/100;
     rCalc.total := v_totalIng;
     rCalc.tasa  := v_porcImpuesto;
   END;
   --
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
       SELECT no_cia, salario_min
       FROM arplmc
       WHERE no_cia = pCia;
   BEGIN
      limpia_error;
      open c_cia;
      fetch c_cia into rCia.no_cia, rCia.sal_min_nacional;
      close c_cia;
      --
      IF nvl(rCia.sal_min_nacional, 0) = 0 THEN
         Genera_Error('No se ha definido el monto del salario minimo '||chr(13)||
                      'para la compa?ia '||pcia);
      END IF;
      IF NOT PLLIB.Trae_Parametro('SALMIN_DEDUC', rCia.sal_min_ref_ded) THEN
         Genera_Error('No se ha definido el parametro SALMIN_DEDUC ');
      END IF;
      IF NOT PLLIB.trae_parametro('CL_IMP_RENTA',  rCia.clase_imp_renta) THEN
         Genera_Error('No se ha definido el parametro CL_IMP_RENTA');
      END IF;
      rCia.sal_min_ref_ded_sem := rCia.sal_min_ref_ded * 12 / 52;
      gNueva_instancia := TRUE;
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
     if pformula_id = 'IMP_RENTA' then
       imp_renta (pno_cia, pcod_pla, pno_emple, rDed.grupo_ing);
     elsif pformula_id = 'SSO' then
        calc_sso_sal(pno_cia, pcod_pla, pno_emple, pno_dedu);
     elsif pformula_id = 'POLITHABI' then
        calc_politica_hab(pno_cia, pcod_pla, pno_emple, pno_dedu);
     elsif pformula_id = 'PAROFORZO' then
        calc_paro_forzoso(pno_cia, pcod_pla, pno_emple, pno_dedu);
     elsif pformula_id = 'PREST/ANT' then
       prest_ant (pno_cia,
                  pcod_pla,
                  pno_emple,
                  rDed.grupo_ing);
     else
        genera_error('La logica para la formula: '|| pformula_id ||' no ha sido escrita');
     end if;
     gNueva_instancia := FALSE;
     RETURN (rCalc);
   END calcula;
   --
END;   -- BODY deducciones_ley_ven
/
