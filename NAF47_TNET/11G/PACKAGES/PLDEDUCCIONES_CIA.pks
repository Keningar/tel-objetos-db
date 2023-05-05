CREATE OR REPLACE PACKAGE            PLDEDUCCIONES_CIA IS
-- PL/SQL Specification
-- ---
   --  Este paquete contiene un conjunto de procedimientos y funciones que
   -- que implementan el calculo de deducciones definidos por la compa?ia
   --  Los calculos no realizan redondeos a menos que, las caracteristicas
   -- de la deduccion asi lo exijan.
   --
   -- ***
   --
   --
   SUBTYPE calculo_r IS PLlib.PLdeducciones_calc_r;
   --
   -- ---
   -- Inicializa el paquete, cargando informacion sobre la compa?ia
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

END PLDEDUCCIONES_CIA;
/


CREATE OR REPLACE PACKAGE BODY            PLDEDUCCIONES_CIA IS
/*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   --
   -- ---
   -- TIPOS
   --
   TYPE param_cia_r IS RECORD(
      no_cia               arplmc.no_cia%type
     ,sal_min_nacional     arplmc.salario_min%type
     ,cl_carga_ambulancia  arplecl.clase_emp%type
     ,cuota_ambulancia     number
   );
   --
   TYPE param_pla_r IS RECORD(
       no_cia           arplcp.no_cia%type
      ,cod_pla          arplcp.codpla%type
      ,tipla            arplcp.tipla%type
      ,redondeo         arplcp.redondeo%type
      ,ano_proce        arplcp.ano_proce%type
      ,mes_proce	    arplcp.mes_proce%type
      ,f_hasta          arplcp.f_hasta%type
      ,diasxmes         arplte.dias_trab%type
      ,horasxmes        arplte.horxmes%type
      ,horasxpla        arplte.n_horas%type
      ,jornada          arplte.jornada%type
   );
   --
   TYPE datos_emp_r IS RECORD(
       no_cia           arplme.no_cia%type
      ,no_emple         arplme.no_emple%type
      ,estado           arplme.estado%type
      ,f_ingreso	arplme.f_ingreso%type
      ,tipo_emp		arplme.tipo_emp%type
      ,sal_bas 		number
      ,sal_hora		number
      ,sal_bas_sem      number
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
   -- ---
   -- CURSORES:
   --
   CURSOR c_datos_pla(  pno_cia     arplcp.no_cia%type
                        ,pcod_pla   arplcp.codpla%type
                      ) IS
         SELECT p.no_cia, p.codpla cod_pla, p.tipla,
                p.redondeo, p.ano_proce, p.mes_proce,
                p.f_hasta,
                t.dias_trab   diasxmes,
                t.horxmes     horasxmes,
                t.n_horas     horasxpla,
                t.jornada
         FROM arplcp p, arplte t
          WHERE p.no_cia   = pno_cia
            AND p.codpla   = pcod_pla
            AND p.no_cia   = t.no_cia
            AND p.tipo_emp = t.tipo_emp;
   --
   CURSOR c_datos_ded(  pno_cia     arplmd.no_cia%type
                        ,pno_dedu   arplmd.no_dedu%type
                      ) IS
      SELECT no_cia, no_dedu, tipo, indivi, monto,
             grupo_ing, aplica_a, solo_cia
         FROM arplmd
         WHERE no_cia   = pno_cia
           AND no_dedu = pno_dedu;
   --
   CURSOR c_datos_emp(  pno_cia     arplme.no_cia%type
                        ,pno_emple  arplme.no_emple%type
                        ,phorasxpla number
                      ) IS
      SELECT e.no_cia, e.no_emple, e.estado, e.f_ingreso,
             e.tipo_emp,
             s.sal_bas,
             decode(nvl(phorasxpla,0), 0, 0, s.sal_bas / phorasxpla) sal_hora
         FROM arplme e, arplnsal s
         WHERE e.no_cia     = pno_cia
           AND e.no_emple   = pno_emple
           AND e.no_cia     = s.no_cia
           AND e.nivel      = s.nivel
           AND e.sub_nivel  = s.sub_nivel;
   -- ---
   --
   rCalc             calculo_r;
   rCia              param_cia_r;
   rPla              param_pla_r;
   rDed              datos_ded_r;
   rEmp              datos_emp_r;
   --
   gNueva_instancia  BOOLEAN;
   vMensaje_error    VARCHAR2(160);
   --
   --
   PROCEDURE limpia_error IS
   -- PL/SQL Block
BEGIN
      vMensaje_error := NULL;
   END;
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := 'CIA: '|| msj_error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   --
   PROCEDURE carga_datos_pla(
      pno_cia     arplcp.no_cia%type
      ,pcod_pla    arplcp.codpla%type
   ) IS
     vr        param_pla_r;
   BEGIN
      if gNueva_instancia OR
         rPla.cod_pla is null OR
         (pno_cia != rPla.no_cia OR pcod_pla != rPla.cod_pla) then
         OPEN c_datos_pla(pno_cia, pcod_pla);
         FETCH c_datos_pla INTO vr.no_cia, vr.cod_pla, vr.tipla,
                                vr.redondeo, vr.ano_proce, vr.mes_proce,
                                vr.f_hasta,
                                vr.diasxmes, vr.horasxmes, vr.horasxpla,
                                vr.jornada;
         CLOSE c_datos_pla;
         --
         rpla  := vr;
      end if;
   END;
   --
   --
   PROCEDURE carga_datos_ded(
      pno_cia        arplmd.no_cia%type
     ,pno_dedu       arplmd.no_dedu%type
   ) IS
   BEGIN
      if gNueva_instancia OR
         rDed.no_dedu is null OR
         (pno_cia != rDed.no_cia OR pno_dedu != rDed.no_dedu) then
         OPEN c_datos_ded(pno_cia, pno_dedu);
         FETCH c_datos_ded INTO rDed;
         CLOSE c_datos_ded;
      end if;
   END;
   --
   --
   PROCEDURE carga_datos_emp(
      pno_cia        arplme.no_cia%type
     ,pno_emple      arplme.no_emple%type
     ,phorasxpla     number
   ) IS
     --
     --v_clase_var   arplpgd.dato_caracter%type;
     --v_clase_fijo  arplpgd.dato_caracter%type;
     --msg           varchar2(250);
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
     vfound   boolean;
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
      vfound := PLlib.trae_parametro('AMBUL_CLASE', rCia.cl_carga_ambulancia);
      vfound := PLlib.trae_parametro('AMBUL_CUOTA', rCia.cuota_ambulancia);
      --
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
     carga_datos_ded(pno_cia, pno_dedu);
     --
     if pformula_id = '????' then
       null;
     else
        genera_error('La logica para la formula: '|| pformula_id ||' no ha sido escrita');
     end if;
     gNueva_instancia := FALSE;
     RETURN (rCalc);
   END calcula;
   --
END;   -- BODY PLdeducciones_cia
/
