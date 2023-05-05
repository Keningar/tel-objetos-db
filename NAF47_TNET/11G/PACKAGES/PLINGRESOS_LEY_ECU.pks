CREATE OR REPLACE PACKAGE            PLINGRESOS_LEY_ECU IS
-- PL/SQL Specification
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

END PLINGRESOS_LEY_ECU;
/


CREATE OR REPLACE PACKAGE BODY            PLINGRESOS_LEY_ECU IS
/*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   --
   -- ---
   -- TIPOS
   --
   TYPE param_cia_r IS RECORD(no_cia           arplmc.no_cia%type,
                              sal_min_nacional arplmc.salario_min%type
   );
   --
   TYPE datos_pla_r IS RECORD(
       no_cia            arplcp.no_cia%type
      ,cod_pla           arplcp.codpla%type
      ,tipla             arplcp.tipla%type
      ,redondeo          arplcp.redondeo%type
      ,ano_proce         arplcp.ano_proce%type
      ,mes_proce         arplcp.mes_proce%type
      ,diasxmes          arplte.dias_trab%type
      ,horasxmes         arplte.horxmes%type
      ,horasxpla         arplte.n_horas%type
      ,f_desde           arplcp.f_desde%type
      ,f_hasta           arplcp.f_hasta%type
      ,ultima_pla        arplcp.ultima_planilla%type
      ,jornada           arplte.jornada%type
      ,planillasxmes     number
      ,horasxdia         number
      ,diasxpla          number
   );
   --
   TYPE datos_emp_r IS RECORD(
       no_cia                   arplme.no_cia%type
      ,no_emple                 arplme.no_emple%type
      ,estado                   arplme.estado%type
      ,f_ingreso                arplme.f_ingreso%type
      ,tipo_emp                  arplme.tipo_emp%type
      ,sal_bas                   number
      ,sal_bas_sem              number
      ,sal_min_ref_ded_sem       number
      ,sal_hora                   number
      ,clase_ing                 varchar2(1)
      ,dias_lab                 number
      ,dias_nolab               number
      ,dias_reposo              number
      ,dias_feriados            number
      ,dias_prenatal            number
      ,dias_postnatal           number
      ,f_egreso                 arplme.f_egreso%type --18-Dic-2001
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
             pno_cia    arplcp.no_cia%type
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
   CURSOR c_datos_ing(pno_cia   arplmi.no_cia%type,
                      pno_ingre arplmi.no_ingre%type) IS
      SELECT no_cia, no_ingre, tipo_ing, tasa_mult, dep_sal_hora, grupo_ing
        FROM arplmi
       WHERE no_cia   = pno_cia
         AND no_ingre = pno_ingre;
   --
   CURSOR c_datos_emp(pno_cia    arplme.no_cia%type,
                      pno_emple  arplme.no_emple%type,
                      phorasxpla number) IS
      SELECT e.no_cia,   e.no_emple,
             e.estado,   e.f_ingreso,
             e.tipo_emp, s.sal_bas,
             decode(nvl(phorasxpla,0), 0, 0, s.sal_bas / phorasxpla) sal_hora
             ,e.f_egreso --18-Dic-2001
        FROM arplme e, arplnsal s
       WHERE e.no_cia    = pno_cia
         AND e.no_emple  = pno_emple
         AND e.no_cia    = s.no_cia
         AND e.nivel     = s.nivel
         AND e.sub_nivel = s.sub_nivel;

/*--------------------------------------------------------------*/
   CURSOR C_Datos_LiqEmp(pno_cia   ARPLCP.no_cia%TYPE,      -- Codigo Compa?ia
                         pcod_pla  ARPLCP.codpla%TYPE,      -- Codigo Nomina
                         pno_emple ARPLME.no_emple%TYPE) IS -- Codigo Empleado
      SELECT CP.CODPLA, CP.TIPO_EMP, ME.NO_EMPLE
        FROM ARPLME ME, ARPLCP CP
       WHERE ME.NO_CIA   = CP.NO_CIA
         AND ME.TIPO_EMP = CP.TIPO_EMP
         AND ME.NO_EMPLE = pno_emple
         AND CP.TIPLA    = 'M'
         AND CP.TIPO_EMP IN (SELECT TIPO_EMP
                               FROM ARPLCP
                              WHERE NO_CIA = pno_cia
                                AND CODPLA = pcod_pla);
   Lc_Dat_LiqEmp C_Datos_LiqEmp%rowtype;
/*--------------------------------------------------------------*/

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
   n_dias            number;
   --
   vMensaje_error    VARCHAR2(160);
   --
   -- --
   --
   PROCEDURE limpia_error IS
   -- PL/SQL Block
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
   PROCEDURE carga_datos_emp(pno_cia    arplme.no_cia%type,
                             pno_emple  arplme.no_emple%type,
                             phorasxpla number)IS
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
                                rEmp.sal_hora
                               ,rEmp.f_egreso; --18-Dic-2001;
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
         /*IF pllib.Obtiene_clase_var (v_clase_var,msg) AND
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
         END IF;*/
         --
         OPEN c_resum_tiempo(rPla.cod_pla);
         FETCH c_resum_tiempo INTO rEmp.dias_lab, rEmp.dias_nolab,
                                   rEmp.dias_reposo, rEmp.dias_feriados,
                                   rEmp.dias_prenatal, rEmp.dias_postnatal;
         CLOSE c_resum_tiempo;
      end if;
   END;
   --

/*------------------------------------------------------------------*/
   PROCEDURE Carga_Datos_LiqEmp(pno_cia   ARPLCP.no_cia%TYPE,
                                pcod_pla  ARPLCP.codpla%TYPE,
                                pno_emple ARPLME.no_emple%TYPE) IS
   BEGIN
      OPEN  C_Datos_LiqEmp(pno_cia, pcod_pla ,pno_emple);
      FETCH C_Datos_LiqEmp INTO Lc_Dat_LiqEmp;
      CLOSE C_Datos_LiqEmp;
   END;
/*------------------------------------------------------------------*/
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
   PROCEDURE feriados(pno_cia   arplppi.no_cia%type,
                      pcod_pla  arplppi.cod_pla%type,
                      pno_emple arplppi.no_emple%type,
                      pno_ingre arplppi.no_ingre%type) IS
      vferiados       NUMBER;
      vtot_ing        NUMBER;
      vsal_referencia NUMBER;
   BEGIN
      vferiados := nvl(rEmp.dias_feriados,0);
      IF vferiados > 0 THEN
         IF rEmp.clase_ing = 'F' THEN
            vsal_referencia := nvl(rEmp.sal_bas,0) / rPla.diasxpla;
         ELSIF rEmp.clase_ing = 'V' THEN
            vTot_ing    := PLLIB.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
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
   PROCEDURE calc_reposo(pno_cia      arplppi.no_cia%type,
                         pcod_pla     arplppi.cod_pla%type,
                         pno_emple    arplppi.no_emple%type,
                         pno_ingre    arplppi.no_ingre%type,
                         ptipo_mov    varchar2) IS -- I1 o I2
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
            vTot_ing    := PLLIB.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
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
   PROCEDURE calc_reposo_maternidad(pno_cia    arplppi.no_cia%type,
                                    pcod_pla   arplppi.cod_pla%type,
                                    pno_emple  arplppi.no_emple%type,
                                    pno_ingre  arplppi.no_ingre%type,
                                    pclase_mov varchar2) IS -- M
      vdias           NUMBER;
      vtot_ing        NUMBER;
      vsal_referencia NUMBER;
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
            vTot_ing    := PLLIB.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
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
   PROCEDURE calc_adicional_reposos(pno_cia      arplppi.no_cia%type,
                                    pcod_pla     arplppi.cod_pla%type,
                                    pno_emple    arplppi.no_emple%type,
                                    pno_ingre    arplppi.no_ingre%type,
                                    pclase_mov   varchar2) IS  -- ejemplo, I, M
      vdias           NUMBER;
      vtot_ing        NUMBER;
      vsal_referencia NUMBER;
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
            vTot_ing    := PLLIB.Sal_Diario_Var(pNo_Cia,        pCod_Pla,       rPla.f_hasta,
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
   END; -- adicional del reposo
   ---
   ---
   -- ================================================================================================
   -- Decimo Tercer Sueldo...
   -- Este procedimiento obtiene el valor total por concepto de Decimo Tercer Sueldo para el empleado.
   -- Es utilizado para el pago anual y para cuando se le paga lo proporcional a un empleado liquidado.
   -- ================================================================================================
   PROCEDURE LiqAnual_DecimoTercero(pno_cia    in  arplme.no_cia%type,     -- Codigo Compa?ia
                                    pcodpla    in  arplcp.codpla%type,     -- Codigo Nomina   -- 05-12-2001
                                    pno_emple  in  arplme.no_emple%type,   -- Codigo Empleado
                                    pdesde     in  date,                   -- Fecha desde
                                    phasta     in  date,                   -- Fecha hasta
                                    pformulaid in  arplmi.formula_id%type, -- Id. Formula
                                    pmonto     out number) IS              -- Monto a Recibir
      Cursor c_DeTer(cFormulaId in  arplmd.formula_id%type) IS
         SELECT MAX(DECODE(Parametro_id,'1P',
                    DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1P
           FROM ARPLPGD
          WHERE GRUPO_PARAMETRO = cFormulaId;
      Cursor c_Montos(pCodigo varchar2) is
         select sum(monto) monto
           from arplhs
          where no_cia = pno_cia
            and codigo   = pCodigo
            and no_emple = pno_emple
            and ano*100+mes >= TO_NUMBER(to_char(pdesde,'YYYYMM'))
            and ano*100+mes <= TO_NUMBER(to_char(phasta,'YYYYMM'))
            and tipo_m   = 'D';
      vvalor number;
      vprov  arplmd.no_dedu%type;
      vDeTer c_DeTer%rowtype;
   BEGIN
      pmonto:=0;
      Open c_DeTer(pFormulaId);
      If c_DeTer%notfound then
         vvalor :=0;
         vprov  :=null;
      end if;
      Fetch c_DeTer into vDeTer;
      vprov := vDeTer.V1P;
      Close c_DeTer;
      if vprov is not null then
         open c_montos(vprov);
         fetch c_montos into vvalor;
         if c_montos%notfound then
            vvalor :=0;
         end if;
         close c_montos; -- 05-12-2001
      end if;
      pmonto := nvl(vvalor,0);
  END;
   ---
 -- ========================================================================================================================
   -- Decimo Tercer Sueldo (servicios prestados)...
   -- Este procedimiento obtiene el valor total por concepto de Decimo Tercer Sueldo (servicios prestados) para el empleado.
   -- Es utilizado para el pago anual y para cuando se le paga lo proporcional a un empleado liquidado.
   -- ANR 08/12/2010
   -- =======================================================================================================================
   PROCEDURE LiqAnual_DecimoTercero_sp( pno_cia    in  arplme.no_cia%type,     -- Codigo Compania
                                        pcodpla    in  arplcp.codpla%type,     -- Codigo Nomina  
                                        pno_emple  in  arplme.no_emple%type,   -- Codigo Empleado
                                        pdesde     in  date,                   -- Fecha desde
                                        phasta     in  date,                   -- Fecha hasta
                                        pformulaid in  arplmi.formula_id%type, -- Id. Formula
                                        pmonto     out number) IS              -- Monto a Recibir

      Cursor c_Montos is
  --- Hay que buscar en cualquier planilla          
         SELECT  nvl(SUM(NVL(h.monto,0)),0) total
           FROM  ARPLHS h
          WHERE  h.no_cia         = pno_cia
            and  h.no_emple       = pno_emple
            and  h.tipo_m         = 'I'
            and  h.codigo         IN (SELECT a.dato_caracter --- servicios prestados y retroaactivos
                                        FROM ARPLPGD a, arplmi b
                                       WHERE a.GRUPO_PARAMETRO = pformulaid
                                         AND a.parametro_id IN ('I13SP','R13SP')
                                         AND b.no_cia = pno_cia
                                         AND a.dato_caracter = b.no_ingre) --- grupo de ingresos
            and ano*100+mes >= TO_NUMBER(to_char(pdesde,'YYYYMM'))
            and ano*100+mes <= TO_NUMBER(to_char(phasta,'YYYYMM'));
                      
      vvalor number;
   BEGIN
   
      pmonto:=0;
         open c_montos;
         fetch c_montos into vvalor;
         if c_montos%notfound then
            vvalor :=0;
         end if;
         close c_montos; 
      pmonto := nvl(vvalor,0);
      
      --- Divido valor para periodos 
      pmonto := pmonto / round(months_between(phasta,pdesde));
      
      rCalc.cantidad  := 1;
      rCalc.tasa      := 0;
  END;  
   ---
/*-----------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------*/
-- 05-12-2001
 -- =================================================================================================
 -- Decimo Cuarto
 -- Este procedimiento obtiene el valor total por concepto de Decimo Cuarto Sueldo para el empleado.
 -- Es utilizado para el pago anual y para cuando se le paga lo proporcional a un empleado liquidado.
 -- =================================================================================================
PROCEDURE LiqAnual_DecimoCuarto(pno_cia    in  arplme.no_cia%type,     -- Codigo Compa?ia
                                   pcodpla    in  arplcp.codpla%type,     -- Codigo Nomina
                                   pno_emple  in  arplme.no_emple%type,   -- Codigo Empleado
                                   pfdesde    in  date,                   -- Fecha desde
                                   pfhasta    in  date,                   -- Fecha hasta
                                   pfingreso  in  date, -- fecha de ingreso del empleado
                                   pformulaid in  arplmi.formula_id%type, -- Id. Formula
                                   pmonto     out rCalc.monto%type) IS    -- Monto a Recibir
      Cursor c_DeCuarto(cFormulaId in  arplmi.formula_id%type) IS
         SELECT MAX(DECODE(Parametro_id,'1P', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1P,
                MAX(DECODE(Parametro_id,'D4', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) vsmv
           FROM ARPLPGD
          WHERE GRUPO_PARAMETRO = cFormulaId;

      CURSOR C_Sum_Deduc_DecCuarto(pdeduc varchar2) IS
         SELECT  SUM(NVL(h.monto,0)) tot_decimo
           FROM ARPLHS h
          WHERE h.no_cia   = pno_cia
            and h.tipo_m   = 'D'
            and h.codigo   = pdeduc
            and h.no_emple = pno_emple
            and h.ano*100+h.mes >= TO_NUMBER(to_char(pfdesde,'YYYYMM'))
            and h.ano*100+h.mes <= TO_NUMBER(to_char(pfhasta,'YYYYMM'));

      vDeCuarto c_DeCuarto%rowtype;
      vProv     arplmd.no_dedu%type;
      vtasa     Rcalc.monto%type;
      n_valor   number := 0;
      vsmv   NUMBER; -- valor del salario minimo vital
   BEGIN
      Open c_DeCuarto(pFormulaId);
      If c_DeCuarto%notfound then
         vProv :='';
      end if;
      Fetch c_DeCuarto into vDeCuarto;
      vProv := vDeCuarto.V1P;
      Close c_DeCuarto;

      open  C_Sum_Deduc_DecCuarto(vProv);
      fetch C_Sum_Deduc_DecCuarto into n_valor;
      close C_Sum_Deduc_DecCuarto;
      n_valor := vDeCuarto.vsmv * least(12,months_between(pfhasta+1,pfingreso)) / 12;
      pmonto := nvl(n_valor,0);
   END;

/*-----------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------*/
/*                         Proceso de Liquidacion Impuesto a la Renta                       */
/*------------------------------------------------------------------------------------------*/
-- 05-12-2001
   PROCEDURE IMPUESTO_RENTA(pno_cia    in  arplme.no_cia%type,
                            pcodpla    in  arplcp.codpla%type,
                            pfdesde    in  date,
                            pfhasta    in  date,
                            pno_emple  in  arplme.no_emple%type,
                            pformulaid in  arplmi.formula_id%type,
                            pmonto     out rCalc.monto%type) IS
      Cursor c_ImpRenta(cFormulaId in  arplmi.formula_id%type) IS
         SELECT
            MAX(DECODE(Parametro_id,'1P', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1P
           FROM ARPLPGD
          WHERE GRUPO_PARAMETRO= cFormulaId;
      CURSOR  C_Sum_Deduc_ImpRenta(pdeduc varchar2) IS
         SELECT  SUM(NVL(h.monto,0)) tot_imprenta
           FROM ARPLHS h
          WHERE h.no_cia         = pno_cia
            and h.tipo_m         ='D'
            and h.codigo         = pdeduc
            and h.no_emple       = pno_emple
            and h.ano*100+h.mes >= TO_NUMBER(to_char(pfdesde,'YYYYMM'))
            and ano*100+mes     <= TO_NUMBER(to_char(pfhasta,'YYYYMM'));
      vImpRenta c_ImpRenta%rowtype;
      vProv     arplmd.no_dedu%type;
      vtasa     Rcalc.monto%type;
      n_valor   number:=0;
   BEGIN
      Open c_ImpRenta(pFormulaId);
      If c_ImpRenta%notfound then
         vProv :='';
      end if;
      Fetch c_ImpRenta into vImpRenta;
      vProv := vImpRenta.V1P;
      Close c_ImpRenta;
      open C_Sum_Deduc_ImpRenta(vProv);
      fetch C_Sum_Deduc_ImpRenta into n_valor;
      close C_Sum_Deduc_ImpRenta;
      pmonto := nvl(n_valor,0);
   END;
/*-----------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------*/
-- ---
-- LIQUIDACION DE SUELDO A LA FECHA DE SALIDA DEL EMPLEADO
-- Obtiene el Sueldo a la Fecha en que salio el empleado.
-- ---
   PROCEDURE LiqEmp_Salario(pno_cia    in  arplme.no_cia%type,   -- Codigo Compa?ia
                            pcodpla    in  arplcp.codpla%type,   -- Codigo Nomina
                            pno_emple  in  arplme.no_emple%type, -- Codigo Empleado
                            pf_egreso  in  date,                 -- Fecha egreso del empleado
                            pmonto     out number) IS            -- Monto a Recibir
      Cursor C_LiqEmp_Sueldo  is
          Select sal_bas, dias_lab
           from arplho
          where no_cia   = pno_cia
            and cod_pla  = pcodpla
            and no_emple = pno_emple
            and ano*100+mes = TO_NUMBER(to_char(pf_egreso, 'RRRRMM'));

      lc_C_LiqEmp_Sueldo C_LiqEmp_Sueldo%rowtype;
   BEGIN
      Open  C_LiqEmp_Sueldo;
      Fetch C_LiqEmp_Sueldo into lc_C_LiqEmp_Sueldo;
      Close C_LiqEmp_Sueldo;
      rCalc.cantidad := lc_C_LiqEmp_Sueldo.dias_lab;
      pmonto         := nvl(lc_C_LiqEmp_Sueldo.sal_bas,0);
   END; -- LiqEmp_Salario

-- ---
-- LIQUIDACION COMPENSACION SALARIAL
-- Obtiene la Compensacion Salarial a la Fecha en que salio el empleado.
-- ---
   PROCEDURE LiqEmp_CompSalarial(pno_cia    in  arplme.no_cia%type,     -- Codigo Compa?ia
                                 pcodpla    in  arplcp.codpla%type,     -- Codigo Nomina
                                 pno_emple  in  arplme.no_emple%type,   -- Codigo Empleado
                                 pf_egreso  in  date,                   -- Fecha egreso del empleado
                                 pformulaid in  arplmi.formula_id%type, -- Id. Formula
                                 pmonto     out number) IS              -- Monto a Recibir
      CURSOR C_CodIng_CompSalarial IS
         SELECT max(DECODE(Parametro_id,'CI_CS', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) CodIng_CompSal
           FROM ARPLPGD
          WHERE GRUPO_PARAMETRO = pFormulaId;

      Cursor C_LiqEmp_CompSalarial(pcv_CodIng_CompSal varchar2) is
          Select monto, cantidad
           from arplhs
          where no_cia   = pno_cia
            and cod_pla  = pcodpla
            and codigo   = pcv_CodIng_CompSal
            and no_emple = pno_emple
            and ano_mes  = TO_NUMBER(to_char(pf_egreso, 'RRRRMM'))
            and tipo_m   = 'I';

      lc_C_CodIng_CompSal C_CodIng_CompSalarial%ROWTYPE;
      lc_C_LiqEmp_CompSal C_LiqEmp_CompSalarial%ROWTYPE;

   BEGIN
      Open  C_CodIng_CompSalarial;
      Fetch C_CodIng_CompSalarial into lc_C_CodIng_CompSal;
      Close C_CodIng_CompSalarial;

      Open  C_LiqEmp_CompSalarial(lc_C_CodIng_CompSal.CodIng_CompSal);
      Fetch C_LiqEmp_CompSalarial into lc_C_LiqEmp_CompSal;
      Close C_LiqEmp_CompSalarial;
      rCalc.cantidad := lc_C_LiqEmp_CompSal.cantidad;
      pmonto         := nvl(lc_C_LiqEmp_CompSal.monto, 0);
   END; --LiqEmp_CompSalarial

   --
   -- Este es un procedimiento alterno para ayudar a obtener la "fecha desde" cuando quiero liquidar los haberes
   -- por Decimo Tercer Sueldo o por Decimo Cuarto Sueldo para empleados que van a ser liquidados.
   --
   Procedure LiqEmp_DatosNomina(P_No_cia     in varchar2, -- Codigo Compa?ia
                                P_No_emple   in varchar2, -- Codigo Empleado
                                P_IdFormula  in varchar2, -- Id. Formula
                                P_Fdesde    out date) is  -- Fecha desde
      lv_CodDec3 varchar2(3);
      lv_CodDec4 varchar2(3);
   Begin
    --Obtengo los codigos de nomina de Decimo Tercer Sueldo anual para Administracion y POS.
      SELECT MAX(DECODE(Parametro_id,'1P1',
                 DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) LidEmp_CodPlaDec3,
             MAX(DECODE(Parametro_id,'1P2',
                 DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) LidEmp_CodPlaDec4
        into lv_CodDec3, lv_CodDec4
        FROM ARPLPGD
       WHERE GRUPO_PARAMETRO = P_IdFormula;
    --Obtengo la fecha desde de la ultima planilla calculada para ese tipo de empleado, sea para Administracion y POS.
      SELECT cp.f_desde
        into P_Fdesde
        FROM ARPLCP CP, ARPLME ME
       WHERE CP.NO_CIA   = ME.NO_CIA
         AND CP.TIPO_EMP = ME.TIPO_EMP
         AND ME.NO_EMPLE = P_No_emple
         AND CP.TIPLA    = 'A'
         and cp.codpla   in (lv_CodDec3, lv_CodDec4)
         AND CP.NO_CIA   = P_No_cia;
   End;

--
-- Este procedimiento es para obtener los valores que quedaron pendientes de pago al empleado.
-- Es un procedimiento que saca los valores aparte del Sueldo, Compensacion Salarial, Decimo Tercer Sueldo
-- y Decimo Cuarto Sueldo.
--
   Procedure LiqEmp_Ingresos_x_Pagar(P_No_cia    in varchar2,   -- Codigo Compa?ia
                                     P_CodNomAct in varchar2,   -- Nomina Actual de Liquidacion
                                     P_CodNomMen in varchar2,   -- Nomina Mensual de empleados
                                     P_No_emple  in varchar2,   -- Codigo Empleado
                                     P_fegreso   in  date,      -- Fecha egreso del empleado
                                     P_IdFormula in varchar2,   -- Id. Formula
                                     pmonto      out number) IS -- Monto a Recibir
      lv_CodSalBas  varchar2(3);
      lv_CodCompSal varchar2(3);
   Begin
     --Obtengo los codigos de Ingreso de Salario Basico y Componente Salarial.
      SELECT MAX(DECODE(Parametro_id,'SalBas',
                 DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) LidEmp_CodSalBas,
             MAX(DECODE(Parametro_id,'CompSal',
                 DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) LidEmp_CodCompSal
        into lv_CodSalBas, lv_CodCompSal
        FROM ARPLPGD
       WHERE GRUPO_PARAMETRO = P_IdFormula;
   --
   -- Elimino todos los ingresos generados automaticamente a excepcion de los ingresos manuales.
   --
      Delete from arplppi
       where no_cia   = P_No_cia
         and cod_pla  = P_CodNomAct
         and no_emple = P_No_emple
         and no_ingre not in (select no_ingre
                                from ARPLICP
                               where NO_CIA  = P_No_cia
                                 and COD_PLA = P_CodNomAct)
         and no_ingre in (Select CODIGO
                            from arplhs
                           where no_cia   = P_No_cia
                             and cod_pla  = P_CodNomMen
                             and no_emple = P_No_emple
                             and ano_mes  = TO_NUMBER(to_char(P_fegreso, 'RRRRMM'))
                             and tipo_m   = 'I');
   --
   -- Ingreso todos los valores adeudados al empleado para su liquidacion.
   --
       Insert into arplppi (NO_CIA, COD_PLA, NO_EMPLE, NO_INGRE,
                           MONTO, TASA, MODIFICADO, IND_GEN_AUTO, cantidad)
      Select NO_CIA, P_CodNomAct COD_PLA, NO_EMPLE, CODIGO,
             MONTO, TASA, MODIFICADO, IND_GEN_AUTO, cantidad
        from arplhs
       where no_cia   = P_No_cia
         and cod_pla  = P_CodNomMen
         and no_emple = P_No_emple
         and ano_mes  = TO_NUMBER(to_char(P_fegreso, 'RRRRMM'))
         and tipo_m   = 'I'
         and codigo   not in (lv_CodSalBas, lv_CodCompSal);
   --
   -- Devuelvo el valor de cero, ya que este procedimiento esta asociado a un ingreso ficticio.
   --
      pmonto := 0;
   End;
/*-----------------------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------------------*/
   --
   --   ************************************************
   --       Calculo de Distribucion de Utilidades
   --   ************************************************
   PROCEDURE Utilidad(pno_cia   arplme.no_cia%type,
                      pcod_pla  arplppi.cod_pla%type,
                      pno_emple arplme.no_emple%type) IS
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
         vMonto_Ingreso     := ((vSuma_Salarios/vDias_Lab_Periodo)*vDias_Pago*vMeses_Lab_Periodo)/12;
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
   PROCEDURE adicional_antiguedad (p_no_cia   CHAR,
                                   p_cod_pla  CHAR,
                                   p_no_emple CHAR) IS
      vAplica_Desde     Date;
      v_anos            NUMBER(4);
      v_monto_diario    arplhs.monto%type;
      vCod_Provision    arplmd.no_dedu%type;
      v_monto_adicional arplhs.monto%type := 0;
      v_MaxDias         NUMBER;
   BEGIN
     /* En el caso de que cumpla anualidad, calcula el adicional por anno
        Aplica solo cuando el empleado cumple a?os de laborar para la empresa
        (mismo mes de ingreso, a?o superior                                    */
      IF to_char(rEmp.f_ingreso, 'MM')   = to_Char(rPla.f_hasta, 'MM')
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
         v_Monto_Diario := (plLib.Total_Provision_Ultimo_Año (p_no_cia,   rPla.f_hasta,
                                                               p_no_emple, vCod_Provision))/60;
         v_anos := TRUNC(pllib.Obtiene_meses(vAplica_Desde, rPla.f_hasta)/12);
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
   PROCEDURE vacaciones (p_no_cia   CHAR,
                         p_no_emple CHAR) IS
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
      vDias_conv := pllocalizacion.dias_convenio_vac(p_no_cia, p_no_emple);
      IF NOT PLLIB.Trae_Parametro('MESESDER', v_cant_meses_der) THEN
         v_cant_meses_der := '';
      END IF;
      -- Obtiene la cantidad maxima de dias a pagar por adicional de vacaciones
      IF NOT pllib.trae_parametro('MAXADICVAC', v_MaxDias) THEN
         genera_error('No existe el parametro correspondiente a la cantidad maxima de dias de Adicional por Vacaciones');
      END IF;
      -- Obtiene los dias adicionales de disfrute de vacaciones
      v_dias_adicionales := Pllocalizacion.adic_vacaciones(rPla.f_hasta, rEmp.f_ingreso,
                                                           to_date('01/05/1991','dd/mm/yyyy'),
                                                           v_cant_meses_der, v_maxDias);
     --*********************************************
     -- Calculo de bono vacacional
     --*********************************************
      vDias_bono := Pllocalizacion.DIAS_BONO_VAC(p_no_cia, p_no_emple);
     -- Obtiene la cantidad maxima de dias a pagar por adicional de bono vacacional
      IF NOT pllib.trae_parametro('MAXDIASBONO', v_MaxDiasBono) THEN
         genera_error('No existe el parametro correspondiente a la cantidad maxima de dias de Adicional por Bono');
      END IF;
      v_MaxDiasBono := v_MaxDiasBono - vDias_bono;
      -- Obtiene los dias adicionales de bono vacacional
      v_dias_adic_bono := Pllocalizacion.adic_vacaciones(rPla.f_hasta, rEmp.f_ingreso,
                                                         to_date('01/05/1991','dd/mm/yyyy'),
                                                         v_cant_meses_der, v_maxDiasBono);
      -- Obtiene el monto Diario a aplicar como adicional
      v_Monto_Diario := Pllib.Salario_Diario_Ingresos (p_no_cia,
                                                       p_no_emple,
                                                       rIng.grupo_ing,
                                                       rPla.ano_proce,
                                                       rPla.mes_proce,
                                                       rPla.diasxmes,
                                                       rPla.tipla,
                                                       rEmp.clase_ing,
                                                       rEmp.f_ingreso,
                                                       rPla.f_hasta);
      v_dias  := vDias_conv + v_dias_adicionales + vDias_bono + v_dias_adic_bono;
      v_monto := NVL(v_dias,0) * v_monto_diario;
      /* Calcula el monto total por prestaciones */
      rCalc.monto := NVL(v_monto,0);
   END;
   -- ---

/*-------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------*/
--
--
-- 25-06-2002
-- Calculo de la Compensacion Laboral del empleado.
-- Para el primer rol del empleado se le cancela la proporcion desde la fecha en que entro hasta la fecha de cierre
-- de la nonima. De ahi en adelante recibira el valor total de la compensacion sin importar los dias laborados.
--
   PROCEDURE Compensacion_Salarial(pno_cia    in  arplme.no_cia%type,     -- Codigo Compa?ia
                                   pcodpla    in  arplcp.codpla%type,     -- Codigo Nomina
                                   pno_emple  in  arplme.no_emple%type,   -- Codigo Empleado
                                   pdesde     in  date,                   -- Fecha desde
                                   phasta     in  date,                   -- Fecha hasta
                                   pformulaid in  arplmi.formula_id%type, -- Id. Formula
                                   pmonto     out number) IS              -- Monto a Recibir

      CURSOR C_Comp_Salarial IS
         SELECT MAX(DECODE(Parametro_id,'1PCS',
                DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) Valor
           FROM ARPLPGD
          WHERE GRUPO_PARAMETRO = 'COMP_SAL'; --pFormulaId;

      vcomponente C_Comp_Salarial%ROWTYPE;

      ld_fecha_ingreso  date;
      ld_fecha_egreso   date;
      ln_total_dias_mes number := 30;
      ln_valor          number;
   BEGIN
      SELECT NVL(ME.F_REINGRESO, ME.F_INGRESO), NVL(ME.F_FIN_CONTRATO, ME.F_EGRESO)
        INTO ld_fecha_ingreso, ld_fecha_egreso
        FROM ARPLCP CP, ARPLME ME
       WHERE CP.NO_CIA   = ME.NO_CIA
         AND CP.TIPO_EMP = ME.TIPO_EMP
         AND CP.TIPLA    = 'M'
         AND ME.NO_EMPLE = pno_emple
         AND CP.CODPLA   = pcodpla
         AND CP.NO_CIA   = pno_cia;

       Open  C_Comp_Salarial;
       Fetch C_Comp_Salarial into vcomponente;
       Close C_Comp_Salarial;

       if to_char(pdesde, 'RRRRMM') = to_char(ld_fecha_ingreso, 'RRRRMM') or   -- Pregunto si a?o||mes del mes en proceso
           to_char(pdesde, 'RRRRMM') = to_char(ld_fecha_egreso, 'RRRRMM') then  -- es igual a la fecha de entrada o salida
                                                                               -- del empleado, si es asi prorratea.*/
          ln_valor := (vcomponente.Valor / ln_total_dias_mes) * rEmp.dias_lab;
          pmonto   := nvl(ln_valor, 0);
          rCalc.cantidad := rEmp.dias_lab;
       else -- Caso contrario le pone los dias completos del mes contable.
          rCalc.cantidad := 30; -- Son 30 dias por ser el periodo contable para cada nomina.
          pmonto := nvl(vcomponente.Valor, 0);
       end if;
   EXCEPTION
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR('-20000', 'Error en Compensacion_Salarial...!'||SQLERRM);
   END;

   PROCEDURE servicios_prestados(pno_cia   IN  arplppi.no_cia%type,
                                 pno_emple IN  arplppi.no_emple%type,
                                 pcantidad OUT arplppi.cantidad%type,
                                 pmonto    OUT arplppi.monto%type) IS

      Cursor C_Serv_Prest Is
      Select servicios_prestados
       From  Arplme
      Where  no_cia = pno_cia
      And    no_emple = pno_emple
      And    nvl(servicios_prestados,0) > 0;

      Ln_valor Number := 0;

   BEGIN

      Open C_Serv_Prest;
      Fetch C_Serv_Prest into Ln_valor;
      If C_Serv_Prest%notfound Then
      Ln_valor := 0;
      Close C_Serv_Prest;
      else
      Close C_Serv_Prest;
      end if;

        pcantidad  := 1;
        pmonto     := Ln_valor;
        rCalc.monto_aux := 0;
        rCalc.tasa      := 0;
        rCalc.meses     := 0;
        rCalc.dias      := 0;


   END;  -- calculo para servicios prestados

   PROCEDURE desahucio(pno_cia   IN  arplppi.no_cia%type,
                       pno_emple IN  arplppi.no_emple%type,
                       pcantidad OUT arplppi.cantidad%type,
                       pmonto    OUT arplppi.monto%type) IS

      Cursor C_Porcentajes Is
        select dato_numerico
        from   arplpgd
        where  grupo_parametro = 'DESAHUCIO'
        and    parametro_id = '%1';

      --- se aproxima en la fecha de egreso hasta el ultimo dia del mes
      --- para que el calculo entre meses sea mas exacto

      Cursor C_Arplme Is
       select floor(months_between(last_day(f_egreso),f_ingreso)/12),
              sal_bas
       from   arplme
       where  no_cia  = pno_cia
       and    no_emple = pno_emple;

        Ln_porc            Number  := 0;

        Ln_anios_laborados Number := 0;
        Ln_sueldo          Number := 0;

        Ln_valor           Number := 0;

   BEGIN

      Open C_Porcentajes;
      Fetch C_Porcentajes into Ln_porc;
      If C_Porcentajes%notfound Then
       Ln_porc:= 0;
       Close C_Porcentajes;
      else
       Close C_Porcentajes;
      end if;

      Open C_Arplme;
      Fetch C_Arplme into Ln_anios_laborados, Ln_sueldo;
       If C_Arplme%notfound Then
       Ln_anios_laborados := 0;
       Ln_sueldo          := 0;
       Close C_Arplme;
      else
       Close C_Arplme;
      end if;

    /*si trabajas un a?o y 5 meses el desahucio como q hayas trabajado 1 a?o,
      por eso es que se pone floor */
      --- comparacion en anios

        Ln_valor := Ln_anios_laborados * Ln_porc/100 * Ln_sueldo;


        pcantidad  := 1;
        pmonto     := Ln_valor;
        rCalc.monto_aux := 0;
        rCalc.tasa      := 0;
        rCalc.meses     := 0;
        rCalc.dias      := 0;


   END;  -- calculo para desahucio

   PROCEDURE imdemnizacion(pno_cia   IN  arplppi.no_cia%type,
                           pno_emple IN  arplppi.no_emple%type,
                           pcantidad OUT arplppi.cantidad%type,
                           pmonto    OUT arplppi.monto%type) IS

      --- se aproxima en la fecha de egreso hasta el ultimo dia del mes
      --- para que el calculo entre meses sea mas exacto

      Cursor C_Arplme Is
       select ceil(months_between(last_day(f_egreso),f_ingreso)/12), sal_bas
       from   arplme
       where  no_cia  = pno_cia
       and    no_emple = pno_emple;

        Ln_anios_laborados Number := 0;
        Ln_sueldo          Number := 0;

        Ln_valor           Number := 0;

   BEGIN

    /*si trabajas un a?o y 5 meses t indenizan como q hayas trabajado 2 a?os,
      por eso es que se pone ceil */
      --- comparacion en anios

      Open C_Arplme;
      Fetch C_Arplme into Ln_anios_laborados, Ln_sueldo;
       If C_Arplme%notfound Then
       Ln_anios_laborados := 0;
       Ln_sueldo          := 0;
       Close C_Arplme;
      else
       Close C_Arplme;
      end if;

       Ln_valor := Ln_anios_laborados * Ln_sueldo;

        pcantidad  := 1;
        pmonto     := Ln_valor;
        rCalc.monto_aux := 0;
        rCalc.tasa      := 0;
        rCalc.meses     := 0;
        rCalc.dias      := 0;


   END;  -- calculo para indemnizacion

  PROCEDURE Recargo_temporal (Pno_Cia    IN Arplppi.No_Cia%TYPE
                              ,Pno_Emple IN Arplppi.No_Emple%TYPE
                              ,Pcantidad OUT Arplppi.Cantidad%TYPE
                              ,Pmonto    OUT Arplppi.Monto%TYPE) IS
  
   --- Para empleados que son de contrato temporal se recarga el 35% al sueldo
   --- El 35% del sueldo es configurable en arplmi
  
   CURSOR c_Arplme IS
    select nvl(sal_bas,0) sal_bas
    from   arplme 
    where  no_cia = Pno_Cia 
    and    no_emple = Pno_Emple
    and    condicion IN
    (select dato_caracter 
     from   arplpgd 
     where  grupo_parametro = 'PARAM'  --- Recupera solo empleados temporales
     and    parametro_id = 'TEMPORAL');

   Cursor C_Recargo Is
    select * 
    from arplmi 
    where no_cia = Pno_Cia 
    and no_ingre IN
    (select dato_caracter 
     from   arplpgd 
     where  grupo_parametro = 'PARAM'  --- Recupera solo empleados temporales
     and    parametro_id = 'REC_TEMP');
 
  r         C_Recargo%rowtype; 
 
  Ln_salbas Arplme.sal_bas%type;
  
  BEGIN
 
   OPEN c_Arplme;
   FETCH c_Arplme
    INTO Ln_salbas;
   IF c_Arplme%NOTFOUND THEN
     Pcantidad := 0;
     Pmonto    := 0;
    CLOSE c_Arplme;
   ELSE
    CLOSE c_Arplme;
      
          -- El recargo es para el sueldo base, para otros casos es cero
          
          Open C_Recargo;
          Fetch C_Recargo into r;
          If C_Recargo%notfound Then
             Close C_Recargo;
               Pcantidad := 0;
              Pmonto    := 0;
          else
             Close C_Recargo;
             
              Pcantidad       := 1;
              
              If r.dep_sal_hora = 'SB' THEN
                Pmonto := nvl(Pcantidad,1) * r.tasa_mult * Ln_salbas;
              else
                Pmonto := 0;
              End if;       
             
          end if;    
    
   END IF;
  
   Rcalc.Monto_Aux := 0;
   Rcalc.Tasa      := 0;
   Rcalc.Meses     := 0;
   Rcalc.Dias      := 0;  
  
  END; -- calculo para recargo de empleados temporales


  PROCEDURE Recargo_galapagos (Pno_Cia    IN Arplppi.No_Cia%TYPE
                              ,Pno_Emple IN Arplppi.No_Emple%TYPE
                              ,Pcantidad OUT Arplppi.Cantidad%TYPE
                              ,Pmonto    OUT Arplppi.Monto%TYPE) IS
  
   --- Para empleados que son de contrato GALAPAGOS se recarga el 75% al sueldo
   --- El 75% del sueldo es configurable en arplmi
  
   CURSOR c_Arplme IS
    select nvl(sal_bas,0) sal_bas
    from   arplme 
    where  no_cia = Pno_Cia 
    and    no_emple = Pno_Emple
    and    id_provincia IN
    (select dato_caracter 
     from   arplpgd 
     where  grupo_parametro = 'CARGAL'  --- Recupera solo empleados temporales
     and    parametro_id = 'PROV_LABORA');

   Cursor C_Recargo Is
    select * 
    from arplmi 
    where no_cia = Pno_Cia 
    and no_ingre IN
    (select dato_caracter 
     from   arplpgd 
     where  grupo_parametro = 'CARGAL'  --- Recupera solo empleados temporales
     and    parametro_id = 'REC_GALAPAGOS');
 
  r         C_Recargo%rowtype; 
 
  Ln_salbas Arplme.sal_bas%type;
  
  BEGIN
 
   OPEN c_Arplme;
   FETCH c_Arplme
    INTO Ln_salbas;
   IF c_Arplme%NOTFOUND THEN
     Pcantidad := 0;
     Pmonto    := 0;
    CLOSE c_Arplme;
   ELSE
    CLOSE c_Arplme;
      
          -- El recargo es para el sueldo base, para otros casos es cero
          
          Open C_Recargo;
          Fetch C_Recargo into r;
          If C_Recargo%notfound Then
             Close C_Recargo;
               Pcantidad := 0;
              Pmonto    := 0;
          else
             Close C_Recargo;
             
              Pcantidad       := 1;
              
              If r.dep_sal_hora = 'SB' THEN
                Pmonto := nvl(Pcantidad,1) * r.tasa_mult * Ln_salbas;
              else
                Pmonto := 0;
              End if;       
             
          end if;    
    
   END IF;
  
   Rcalc.Monto_Aux := 0;
   Rcalc.Tasa      := 0;
   Rcalc.Meses     := 0;
   Rcalc.Dias      := 0;  
  
  END; -- calculo para recargo de empleados temporales

   -- ===========================================
   --  llindao: Pago Mensual de beneficios Ley --
   -- ===========================================
   PROCEDURE PagoMensualBeneficios( pno_cia     in  arplme.no_cia%type,
                                    pno_emple   in  arplme.no_emple%type,
                                    pcod_pla    in  VARCHAR,
                                    pformulaid  in  arplmd.formula_id%type,
                                    pmonto      out number ) IS
     Cursor c_formulas(cFormulaId in  arplmd.formula_id%type)  IS
       SELECT MAX(DECODE(Parametro_id,'1P', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1P,
              MAX(DECODE(Parametro_Id,'1G', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1G
         FROM ARPLPGD
        WHERE GRUPO_PARAMETRO= cFormulaId;
       --
       vvalor        number;
       vgrupo        arplmi.grupo_ing%type;
       vprom         NUMBER:=0;
       cdescri       VARCHAR2(50);
       vdatosformula c_formulas%rowtype;
   BEGIN
     Open c_formulas(pFormulaId);
     If c_formulas%notfound then
       vvalor :=0;
       vgrupo :=null;
     end if;
     Fetch c_formulas into vdatosformula;
     vvalor := vdatosformula.V1P;
     vgrupo := vdatosformula.V1G;
     Close c_formulas;
     pmonto := vvalor;-- se asigna valor
     
     IF vgrupo IS NOT NULL THEN
       pmonto := pmonto / 100; -- se va a calcular en base a un porcentaje asignado
     -- Grupo de ingresos de la planilla calculada a la fecha
       vprom := Pllib.monto_grupo_ing_pp(pno_cia, pno_emple, vgrupo, pcod_pla);
       pmonto := nvl(pmonto,0) * nvl(vprom,0);    
     END IF;  -- grupo_ing IS NOT NULL
   END;


/*-------------------------------------------------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------------------------------------------------*/

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
   FUNCTION calcula(pno_cia     in arplme.no_cia%type,
                    pcod_pla    in arplppi.cod_pla%type,
                    pno_emple   in arplppi.no_emple%type,
                    pno_ingre   in arplppi.no_ingre%type,
                    pformula_id in arplmi.formula_id%type,
                    pcantidad   in arplppi.cantidad%type) RETURN calculo_r
   IS
      ld_fdesde date; --Fecha para el calculo el Decimo 3ro y 4to Sueldo.
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

      if pformula_id = 'FERIADOS' then
         feriados(pno_cia, pcod_pla, pno_emple, pno_ingre);
      elsif pformula_id = 'DECIMO3' then
         LiqAnual_DecimoTercero(pno_cia, pcod_pla, pno_emple, rpla.f_desde, rpla.f_hasta, pformula_id, rCalc.monto); --05-12-2001
      ---- TELCONET
      ---- Liquidacion de decimo tercero servicios prestados ANR 08/12/2010
      elsif pformula_id = 'DECIMO3_SP' then
         LiqAnual_DecimoTercero_sp(pno_cia, pcod_pla, pno_emple, rpla.f_desde, rpla.f_hasta, pformula_id, rCalc.monto);
      elsif Pformula_id = 'DECIMO4' THEN --05-12-2001
         LiqAnual_DecimoCuarto(pno_cia, pcod_pla, pno_emple, rPla.f_desde, rPla.f_hasta,remp.f_ingreso, pformula_id, rCalc.monto); --05-12-2001
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
     ------- 05-12-2001
      elsif Pformula_id = 'IMP_RENTA' THEN
         IMPUESTO_RENTA(pno_cia,pcod_pla,rPla.f_desde,rPla.f_hasta,pno_emple,pformula_id,rCalc.monto);
  --
  -- Estas Formulas son utilizadas para la liquidacion de empleados.
  --
      ELSIF Pformula_id = 'LIQSU' THEN
            Carga_Datos_LiqEmp(pno_cia, pcod_pla, pno_emple);
            LiqEmp_Salario (pno_cia, Lc_Dat_LiqEmp.CODPLA, pno_emple, remp.f_egreso, rCalc.monto);
      ELSIF Pformula_id = 'LIQCS' THEN
            Carga_Datos_LiqEmp(pno_cia, pcod_pla, pno_emple);
            LiqEmp_CompSalarial(pno_cia, Lc_Dat_LiqEmp.CODPLA, pno_emple, remp.f_egreso, pformula_id, rCalc.monto);
      ELSIF Pformula_id = 'LIQD3' THEN
            LiqEmp_DatosNomina(pno_cia, pno_emple, pformula_id, ld_fdesde);
            LiqAnual_DecimoTercero(pno_cia, pcod_pla, pno_emple, ld_fdesde, remp.f_egreso, pformula_id, rCalc.monto);
      ELSIF Pformula_id = 'LIQD4' THEN
            LiqEmp_DatosNomina(pno_cia, pno_emple, pformula_id, ld_fdesde);
            LiqAnual_DecimoCuarto(pno_cia, pcod_pla, pno_emple, ld_fdesde, remp.f_egreso, remp.f_ingreso, pformula_id, rCalc.monto);
      ELSIF Pformula_id = 'LIQEMP_ING' THEN
            Carga_Datos_LiqEmp(pno_cia, pcod_pla, pno_emple);
            LiqEmp_Ingresos_x_Pagar(pno_cia, pcod_pla, Lc_Dat_LiqEmp.CODPLA, pno_emple, remp.f_egreso, pformula_id, rCalc.monto);
   -----------------------------------
      ELSIF Pformula_id = 'COMP_SAL' THEN
            Compensacion_Salarial(pno_cia, pcod_pla, pno_emple, rPla.f_desde, rPla.f_hasta, pformula_id, rCalc.monto);
      ELSIF Pformula_id = 'SERV_PREST' THEN --- se agrega calculo para servicios prestados ANR 09/07/2010
            servicios_prestados(pno_cia, pno_emple, rCalc.cantidad, rCalc.monto);
      ELSIF Pformula_id = 'DESAHUCIO' THEN --- se agrega calculo para desahucio ANR 15/07/2010
            desahucio(pno_cia, pno_emple, rCalc.cantidad, rCalc.monto);
      ELSIF Pformula_id = 'IMDEM' THEN --- se agrega calculo para imndemnizacion ANR 15/07/2010
            imdemnizacion(pno_cia, pno_emple, rCalc.cantidad, rCalc.monto);
      ELSIF Pformula_Id = 'PARAM' THEN
        --- se agrega calculo para recargo a temporales ANR 12/01/2011
        Recargo_temporal(Pno_Cia,
                         Pno_Emple,
                         Rcalc.Cantidad,
                         Rcalc.Monto);
      ELSIF Pformula_Id = 'CARGAL' THEN
        --- se agrega calculo para recargo a temporales JEO 03/05/2011
        Recargo_galapagos(Pno_Cia,
                         Pno_Emple,
                         Rcalc.Cantidad,
                         Rcalc.Monto);
      
      -- llindao: se aumenta para genertacion de 
      -- Pago de 13cer, 14to y vacaciones mensual
      ELSIF pformula_id IN ('DECIM_3CER','DECIMO_4TO','PAGOVACAC') THEN
        PagoMensualBeneficios(pno_cia,Pno_emple,pcod_pla,pformula_id,rCalc.monto);
        -- es necesario hacer la distincion del 14to xq el monto a calcular no viene
        -- de total de ingresos donde ya se considera solo los dias laborados
        IF pformula_id = 'DECIMO_4TO' THEN
          n_dias:=0;
          n_dias  := nvl(rEmp.dias_lab,0);
          rCalc.monto := (rCalc.monto / 30) * n_dias;
        END IF;
        rCalc.Tasa      := 0;
      else
            genera_error('La logica para la formula: '|| pformula_id ||' no ha sido escrita');
      end if;
      gNueva_instancia := FALSE;
      RETURN (rCalc);
   END calcula;
   --

END;   -- BODY ingresos_ley_ecu
/
