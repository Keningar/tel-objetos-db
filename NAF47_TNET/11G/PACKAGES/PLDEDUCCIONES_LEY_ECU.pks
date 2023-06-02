CREATE OR REPLACE PACKAGE NAF47_TNET.PLDEDUCCIONES_LEY_ECU IS
-- PL/SQL Specification
-- PL/SQL Specification
-- ---
   --  Este paquete contiene un conjunto de procedimientos y funciones que
   -- que implementan el calculo de deducciones definidos por la ley del pais
   --  Los calculos no realizan redondeos a menos que, las caracteristicas
   -- de la deduccion asi lo exijan.
   --
   -- ***
   --
   --
   SUBTYPE calculo_r IS pldeducciones.calculo_r;
   --
   -- ---
   -- Inicializa el paquete, cargando informacion sobre la compa?ia
    --
    PROCEDURE inicializa(pCia varchar2);
   --
   -- ---
   -- Realiza el calculo del ingreso indicado por "formula_id"
   FUNCTION calcula(
                pno_cia       in arplme.no_cia%type
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


END PLDEDUCCIONES_LEY_ECU_tnet;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.PLDEDUCCIONES_LEY_ECU IS
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
      ,creditoxc             arplpar.creditoxc%type
      ,creditoxh             arplpar.creditoxh%type
   );
    TYPE datos_pla_r IS RECORD(
       no_cia          arplcp.no_cia%type
      ,cod_pla         arplcp.codpla%type
      ,tipla           arplcp.tipla%type
      ,redondeo        arplcp.redondeo%type
      ,ano_proce       arplcp.ano_proce%type
      ,mes_proce       arplcp.mes_proce%type
      ,diasxmes        arplte.dias_trab%type
      ,horasxmes       arplte.horxmes%type
      ,horasxpla       arplte.n_horas%type
      ,f_desde         arplcp.f_desde%type
      ,f_hasta         arplcp.f_hasta%type
      ,ultima_pla      arplcp.ultima_planilla%type
      ,jornada         arplte.jornada%type
      ,planillasxmes   number
      ,horasxdia       number
      ,diasxpla        number
   );
   --
   TYPE datos_emp_r IS RECORD(
       no_cia          arplme.no_cia%type
      ,no_emple        arplme.no_emple%type
      ,estado          arplme.estado%type
      ,f_ingreso       arplme.f_ingreso%type
      ,tipo_emp         arplme.tipo_emp%type
      ,sal_bas          number
      ,sal_bas_sem     number
      ,sal_min_ref_ded_sem number
      ,sal_hora         number
      ,dias_reposo     number
      ,dias_lab        number
      ,f_egreso        arplme.f_egreso%TYPE
      ,ind_region      arplme.Ind_Region%TYPE
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
     /* SELECT e.no_cia,   e.no_emple,
             e.estado,   nvl(e.f_reingreso,e.f_ingreso) f_ingreso,
             e.tipo_emp, s.sal_bas,
             decode(nvl(phorasxpla,0), 0, 0, s.sal_bas / phorasxpla) sal_hora,
             e.f_egreso
         FROM arplme e---, arplnsal s
         WHERE e.no_cia     = pno_cia
           AND e.no_emple   = pno_emple
           AND e.no_cia     = s.no_cia
          --- AND e.nivel      = s.nivel
         ----  AND e.sub_nivel  = s.sub_nivel;*/
         SELECT e.no_cia,   e.no_emple,
             e.estado,   nvl(e.f_reingreso,e.f_ingreso) f_ingreso,
             e.tipo_emp, e.sal_bas,
             decode(nvl(phorasxpla,0), 0, 0, e.sal_bas / phorasxpla) sal_hora,
             e.f_egreso, e.ind_region
         FROM arplme e---, arplnsal s
         WHERE e.no_cia     = pno_cia
           AND e.no_emple   = pno_emple;
           ----AND e.no_cia     = s.no_cia;
          --- AND e.nivel      = s.nivel
         ----  AND e.sub_nivel  = s.sub_nivel;


/*--------------------------------------------------------------*/
   CURSOR C_Datos_LiqEmp(pno_cia   ARPLCP.no_cia%TYPE,
                         pcod_pla  ARPLCP.codpla%TYPE,
                         pno_emple ARPLME.no_emple%TYPE) IS
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
   rDed              datos_ded_r;
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
         OPEN c_datos_ded (pno_cia, pno_dedu, pcod_pla);
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
     -- v_clase_var   arplpgd.dato_caracter%type;
     --v_clase_fijo  arplpgd.dato_caracter%type;
     --msg           varchar2(250);
     --
     CURSOR c_resum_tiempo(pcod_pla varchar2) IS
        SELECT dias_reposo, dias_lab
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
                                rEmp.sal_hora,
                                rEmp.f_egreso,
                                rEmp.ind_region;
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
     rEmp.dias_reposo:=0;
     rEmp.dias_lab:=0;
         OPEN c_resum_tiempo(rPla.cod_pla);
         FETCH c_resum_tiempo INTO rEmp.dias_reposo,rEmp.dias_lab;
         CLOSE c_resum_tiempo;
      end if;
   END;

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

   --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN IS
   BEGIN
      RETURN ( nvl(rCia.no_cia,'*NULO*') = pCia);
   END inicializado;
   --
   --
   -- ---
   --
   PROCEDURE calc_rciva
      (pno_cia        in arplme.no_cia%type,
      pno_emple     in arplme.no_emple%type,
      pno_dedu      in arplmd.no_dedu%type)
       IS
   BEGIN
      rCalc.monto    := 4 * rEmp.sal_hora;
   END;
   --
   -- ---
   --
   -- ===============================================
   --  Provision para Decimo cuarto
   -- ===============================================
   PROCEDURE ProvisionDecimoCuarto(
                            pno_cia           in  arplme.no_cia%type,
              pformulaid        in  arplmd.formula_id%type,
                pmonto            out rCalc.monto%type) IS
  Cursor c_provDeCua(cFormulaId in  arplmd.formula_id%type)  IS
   SELECT
 --   Valor
     MAX(DECODE(Parametro_id,'1P',
       DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1P
     FROM ARPLPGD
    WHERE GRUPO_PARAMETRO= cFormulaId;
    vProvDeCua c_provDeCua%rowtype;
  vvalor number;
  vtasa  Rcalc.monto%type;
  BEGIN
     Open c_provDecua(pFormulaId);
   If c_provDeCua%notfound then
      vvalor :=0;
   end if;
   Fetch c_provDeCua into vprovDeCua;
   vvalor := vProvDeCua.V1P;
   Close c_provDeCua;
     pmonto := vvalor; --*(vtasa/100);
  END;
   -- ======================================================
   --  Ajuste a los valores Provisionados para Decimo cuarto
   -- ======================================================
   PROCEDURE AjusteProvDecimoCuarto(pno_cia       in  arplme.no_cia%type,
                          pcodpla        in  arplcp.codpla%type,
                          pfdesde         in  date, -- fecha del rol
                          pfhasta          in  date,
                          pno_emple     in  arplme.no_emple%type,
                          pind_region    IN arplme.Ind_Region%TYPE,
                          pfingreso        in  date, -- fecha de ingreso del empleado
                          pformulaid      in  arplmi.formula_id%type,
                          pmonto         out rCalc.monto%type) IS

  Cursor c_DeCuarto(cFormulaId in  arplmi.formula_id%type)  IS
   SELECT
      MAX(DECODE(Parametro_id,'1S', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) SMV,
      MAX(DECODE(Parametro_id,'1D', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) NO_DEDUC,
      MAX(DECODE(Parametro_id,'1R', DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) REGION
   FROM ARPLPGD
  WHERE GRUPO_PARAMETRO= cFormulaId;

   CURSOR  C_Sum_Deduc_DecCuarto(pdeduc varchar2, pregion varchar2) IS
        SELECT  SUM(NVL(h.monto,0)) tot_decimo
    FROM  ARPLHS h, arplme b
          WHERE  h.no_cia  = pno_cia
          and   h.tipo_m    ='D' and h.codigo=pdeduc
           and ano*100+mes >= TO_NUMBER(to_char(pfdesde,'rrrrMM'))
           and ano*100+mes <= TO_NUMBER(to_char(pfhasta,'rrrrMM'))
          AND  h.no_emple  = pno_emple
          and nvl(b.ind_region,'C') = pregion
          and h.no_cia = b.no_cia
          and h.no_emple = b.no_emple;

  CURSOR c_DiasAusencia IS
    SELECT nvl(COUNT(*),0)
      FROM arplappp
     WHERE no_cia = pno_cia
       AND no_emple = pno_emple
       AND tipo_mov = 'AJ' -- ausencias justificadas
       AND clase_mov = 'A' -- ausencias
       AND fecha BETWEEN pfdesde AND pfhasta; -- desde y hasta del ROL

   --- vDeCuarto c_DeCuarto%rowtype;
    vNoDedu  arplmd.no_dedu%type;
    vtasa  Rcalc.monto%type;
    vsmv   NUMBER; -- valor del salario minimo vital
    n_vD14 number:=0; -- valor que se pagaria como 14to al empleado
    n_ausencias NUMBER:=0; -- dias de ausencia
    n_vDEDU number:=0; -- valor acumulado provisionado
    vRegion varchar2(1);

 BEGIN

   Open c_DeCuarto(pFormulaId);
    If c_DeCuarto%notfound then
       vNoDedu :='';
     end if;
    Fetch c_DeCuarto into vsmv, vNoDedu, vRegion;
    Close c_DeCuarto;

   IF pind_region = vRegion THEN

     -- con esta regla de tres transforma el vsmv al proporcional de los meses
     -- desde que ingreso el empleado basado en los 12 meses del a?o
     n_vD14 := vsmv * least(12,months_between(pfhasta+1,pfingreso)) / 12;

     -- si el empleado tuvo ausencias, estas deben ser converditas a un valor por dia
     -- basandose en 360 dias para el vsmv, este valor es restado del valor calculado
     -- solicitado por Patricia Del Pozo
     OPEN c_DiasAusencia;
     FETCH c_DiasAusencia INTO n_ausencias;
     CLOSE c_DiasAusencia;
     IF n_ausencias > 0 THEN
       n_vD14 := n_vD14 - ((vsmv * n_ausencias) / 360);
     END IF;

      open C_Sum_Deduc_DecCuarto(vNoDedu, vRegion);
      fetch C_Sum_Deduc_DecCuarto into n_vDEDU;
      close C_Sum_Deduc_DecCuarto;

      pmonto := nvl(round(n_vD14,2),0) - nvl(round(n_vDEDU,2),0);
   ELSE
     pmonto := 0;
   END IF;

  END;

   -- ===============================================
   --  Provision para Decimo Tercero
   -- ===============================================
   PROCEDURE ProvisionDecimoTercero(
                            pno_cia           in  arplme.no_cia%type,
                            pno_emple         in  arplme.no_emple%type,
                            pcod_pla          in  VARCHAR,
                            pformulaid        in  arplmd.formula_id%type,
                            pmonto            out number) IS
    Cursor c_provDeTer(cFormulaId in  arplmd.formula_id%type)  IS
     SELECT
 --   Valor
       MAX(DECODE(Parametro_id,'1P',
       DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1P,
       MAX(DECODE(Parametro_Id,'1G',
       DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1G
     FROM ARPLPGD
    WHERE GRUPO_PARAMETRO= cFormulaId;
    vvalor number;
    vgrupo arplmi.grupo_ing%type;
    vprom        NUMBER:=0;
    cdescri        VARCHAR2(50);
    vprovDeTer  c_provDeTer%rowtype;
    BEGIN
     Open c_provDeTer(pFormulaId);
     If c_provDeTer%notfound then
        vvalor :=0;
        vgrupo :=null;
     end if;
     Fetch c_provDeTer into vprovDeTer;
     vvalor := vProvDeTer.V1P;
     vgrupo := vProvDeTer.V1G;
     Close c_provDeTer;
     pmonto := vvalor / 100; --*(vtasa/100);
     IF vgrupo IS NOT NULL THEN
    -- Grupo de ingresos de la planilla calculada a la fecha
        vprom := Pllib.monto_grupo_ing_pp(pno_cia, pno_emple, vgrupo, pcod_pla);
        pmonto := nvl(pmonto,0) * nvl(vprom,0);    
    --END IF;    --
     END IF;  -- grupo_ing IS NOT NULL
    END;


   -- ===============================================
   --  Provision para Fondo de Reserva
   -- ===============================================
   /**
  * 
  * @actualiza banton <banton@telconet.ec>
  * @version 1.1 19/05/2020
  * Se agrega condicion para empleados que aplica descuento
  * Se debe sacar valor en base al monto sin descuentos
  */

   /**
  * 
  * @actualiza banton <banton@telconet.ec>
  * @version 1.2 29/06/2020
  * Se agrega condicion para empleados que aplica descuento
  * para empleados de Telconet
  */

  /**
  * 
  * @actualiza banton <banton@telconet.ec>
  * @version 1.3 27/08/2020
  * Se modifica condicion para empleados que aplica descuento
  * para empleados de Megadatos
  */

  PROCEDURE FondoDeReserva(pno_cia    in  arplme.no_cia%type,
                                          pfecha_ref     DATE,
                                          pf_ingreso     DATE,
                                          pno_emple  in  arplme.no_emple%type,
                                          pcod_pla   in  VARCHAR,
                                          pmeses             IN OUT    NUMBER,
                                          pf_desde         DATE,
                                pf_hasta         DATE,
                                          pformulaid in  arplmd.formula_id%type,
                                        pmonto     out rCalc.monto%type) IS
        Cursor c_fondo(cFormulaId in  arplmd.formula_id%type)  IS
           SELECT
 --      Valor
            MAX(DECODE(Parametro_id,'1N',
                DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1N,
            MAX(DECODE(Parametro_Id,'1G',
                DECODE(Tipo_dato,'C',Dato_caracter,'N',TO_CHAR(Dato_numerico),'D',TO_CHAR(Dato_date)),NULL)) V1G
           FROM ARPLPGD
          WHERE GRUPO_PARAMETRO= cFormulaId;
         vfondo       c_fondo%rowtype;
           vvalor       number;
           vtasa        Rcalc.monto%type;
           vgrupo       arplmi.grupo_ing%type;
           vprom            NUMBER;
           cdescri          VARCHAR2(50);
           vanos            NUMBER(4);
           pmeses_desde    NUMBER;
           pdias              NUMBER;
           pcantidad      NUMBER;
           pmonto_aux   NUMBER;
    --
    -- Recupero la historia de empleados para saber el tiempo real que ha laborado en la empresa.
    -- Ya que para provisionar el fondo reserva el empleado debe tener mas de un a?o.
    -- Por ejemplo: Si el empleado trabajo anteriormente 5 meses, y en la actualidad tiene 9 meses
    --              desde la segunda fecha de ingreso, esto quiere decir que en total ha trabajado
    --              un periodo de 1 a?o 2 meses(5 + 9), por esta razon se le debe provisionar el
    --              fondo de reserva.
    --
      Cursor C_ingresos_empleado(pc_no_cia   varchar2,
                                 pc_no_emple varchar2) is
         Select NO_EMPLE, TIPO_EMP, F_INGRESO, F_EGRESO
           from PL_HIS_INGRESOS_EMPLEADO
          where no_cia   = pc_no_cia
            and no_emple = pc_no_emple
            and tipo_emp in (select tipo_emp from arplte where no_cia=pc_no_cia and es_trabajador='S');

      ln_aux    number := 0;
      ln_tiempo number := 0;

      CURSOR C_APLICA_DESCUENTO IS
      SELECT NVL(APLICA_DESCUENTO,'N'),NVL(REDUCCION,0),SAL_BAS
        FROM NAF47_TNET.ARPLME
        WHERE NO_CIA=pno_cia
        AND NO_EMPLE=pno_emple;

      CURSOR C_NO_APLICA_DESC IS
      SELECT PARAMETRO_ALTERNO 
        FROM GE_PARAMETROS x, GE_GRUPOS_PARAMETROS y
        WHERE X.ID_GRUPO_PARAMETRO = Y.ID_GRUPO_PARAMETRO
          AND X.ID_APLICACION = Y.ID_APLICACION
          AND X.ID_EMPRESA = Y.ID_EMPRESA
          AND X.ID_GRUPO_PARAMETRO = 'DESC_NOMINA'
          AND X.PARAMETRO='NO_APLICA'
          AND X.ID_APLICACION = 'PL'
          AND X.ID_EMPRESA = pno_cia
          AND X.ESTADO = 'A'
          AND Y.ESTADO = 'A';


      --SUMA DE INGRESOS QUE APLICARON REDUCCION
      CURSOR C_SUM_ING_DESC (Cv_Grupo NAF47_TNET.arplgid.GRUPO_ING%TYPE ) IS
        SELECT SUM( NVL(MONTO,0) )
        FROM NAF47_TNET.ARPLPPI
        WHERE NO_CIA   = PNO_CIA
          AND COD_PLA  = NVL(PCOD_PLA, COD_PLA)
          AND NO_EMPLE = PNO_EMPLE
          AND NO_INGRE IN (SELECT NO_INGRE
                           FROM NAF47_TNET.ARPLGID
                           WHERE NO_CIA    = PNO_CIA
                             AND GRUPO_ING = CV_GRUPO
                             AND NO_INGRE IN(SELECT x.PARAMETRO_ALTERNO 
                        FROM GE_PARAMETROS x, GE_GRUPOS_PARAMETROS y
                        WHERE X.ID_GRUPO_PARAMETRO = Y.ID_GRUPO_PARAMETRO
                        AND X.ID_APLICACION = Y.ID_APLICACION
                        AND X.ID_EMPRESA = Y.ID_EMPRESA
                        AND X.ID_GRUPO_PARAMETRO = 'DESC_NOMINA'
                        AND X.PARAMETRO LIKE 'ING_REDU%'
                        AND X.ID_APLICACION = 'PL'
                        AND X.ID_EMPRESA = PNO_CIA
                        AND X.ESTADO = 'A'
                        AND Y.ESTADO = 'A')) ;

       --SUMA DE INGRESOS QUE NO APLICARON REDUCCION
       CURSOR C_SUM_ING_SIN_DESC (Cv_Grupo NAF47_TNET.arplgid.GRUPO_ING%TYPE ) IS
        SELECT SUM( NVL(MONTO,0) )
        FROM NAF47_TNET.ARPLPPI
        WHERE NO_CIA   = PNO_CIA
          AND COD_PLA  = NVL(PCOD_PLA, COD_PLA)
          AND NO_EMPLE = PNO_EMPLE
          AND NO_INGRE IN (SELECT NO_INGRE
                           FROM NAF47_TNET.ARPLGID
                           WHERE NO_CIA    = PNO_CIA
                             AND GRUPO_ING = CV_GRUPO
                             AND NO_INGRE NOT IN(SELECT x.PARAMETRO_ALTERNO 
                        FROM GE_PARAMETROS x, GE_GRUPOS_PARAMETROS y
                        WHERE X.ID_GRUPO_PARAMETRO = Y.ID_GRUPO_PARAMETRO
                        AND X.ID_APLICACION = Y.ID_APLICACION
                        AND X.ID_EMPRESA = Y.ID_EMPRESA
                        AND X.ID_GRUPO_PARAMETRO = 'DESC_NOMINA'
                        AND X.PARAMETRO LIKE 'ING_REDU%'
                        AND X.ID_APLICACION = 'PL'
                        AND X.ID_EMPRESA = PNO_CIA
                        AND X.ESTADO = 'A'
                        AND Y.ESTADO = 'A')) ;


      Lv_Aplica  NAF47_TNET.ARPLME.APLICA_DESCUENTO%TYPE;
      Ln_Porcentaje NUMBER;
      Lv_NoAplica VARCHAR2(3);
      Ln_Colectivos NUMBER;
      Ln_SalBas     NUMBER;
      Ln_IngConDesc NUMBER;
      Ln_IngSinDesc NUMBER;

   BEGIN

   OPEN C_NO_APLICA_DESC;
   FETCH C_NO_APLICA_DESC INTO Lv_NoAplica;
   CLOSE C_NO_APLICA_DESC;

   --
   -- Obtengo el total de tiempo laborado anteriormente, antes de la ultima vez que ingreso el empleado.
   --
      for i in C_ingresos_empleado(pno_cia, pno_emple)
      loop
         if i.f_egreso is not null then
            ln_aux    := MONTHS_BETWEEN(TRUNC(i.f_egreso), TRUNC(i.f_ingreso));
            ln_tiempo := ln_tiempo + ln_aux;
         end if;
      end loop;


      Open c_fondo(pFormulaId);
        If c_fondo%notfound then
         vvalor := 0;
             vtasa  := 0;
             vgrupo := 0;
        end if;
        Fetch c_fondo into vfondo;
        vvalor := vfondo.V1N;
          vgrupo := vfondo.V1G;
        Close c_fondo;
        BEGIN
           IF vgrupo IS NOT NULL THEN

            --Se verifica si aplica descuento
            OPEN C_APLICA_DESCUENTO;
            FETCH C_APLICA_DESCUENTO INTO Lv_Aplica,Ln_Porcentaje,Ln_SalBas;
            CLOSE C_APLICA_DESCUENTO;

            --Se adiciona valor de reduccion para MD
            IF nvl(Ln_Porcentaje,0) > 0 AND NVL(Lv_NoAplica,'00') != PNO_CIA THEN

              OPEN C_SUM_ING_DESC(vgrupo);
              FETCH C_SUM_ING_DESC INTO Ln_IngConDesc;
              CLOSE C_SUM_ING_DESC;

              vprom:=(Ln_IngConDesc*100)/(100-Ln_Porcentaje);

              OPEN C_SUM_ING_SIN_DESC(vgrupo);
              FETCH C_SUM_ING_SIN_DESC INTO Ln_IngSinDesc;
              CLOSE C_SUM_ING_SIN_DESC;


              vprom:=vprom+NVL(Ln_IngSinDesc,0);
            ELSE

            -- Calculo de Acumulado
            -- Grupo de ingresos de la planilla calculada a la fecha
            vprom := Pllib.monto_grupo_ing_pp(pno_cia, pno_emple, vgrupo, pcod_pla);

            END IF;

                  ---pmonto := (NVL(vprom,0)/vvalor);
            --- El fondo de reserva (provision) se debe calcular igual que el decimo tercero (provision) 8.3333 ANR 18/08/2010
            pmonto := (NVL(vprom,0)*vvalor/100);

              cdescri := Dif_Fecha(pfecha_ref, pf_ingreso,vanos,pmeses, pdias);
            pmeses_desde := MONTHS_BETWEEN(pfecha_ref,pf_ingreso);

         --
         -- Sumo el tiempo actual de labores con el tiempo anteriormente laborado.
         --
            pmeses_desde := pmeses_desde + nvl(ln_tiempo, 0);

            IF TRUNC(PMESES_DESDE) = 12 AND pdias > 0 THEN
              pmonto := (nvl(pmonto,0)/30)*((30-to_number(to_char(pf_ingreso,'dd')))+1);
              pdias  :=0;
            ELSIF PMESES_DESDE > 12  THEN  
              pmonto := nvl(pmonto,0);
              pdias  := 0;
            ELSE
               pmonto :=0;
               pdias  :=0;
            END IF;

        ELSE
           pmonto     := 0;
           pmeses    := 0;
           pdias     := 0;
        END IF;  -- grupo_ing IS NOT NULL
        pcantidad    := 1;
        pmonto_aux    := NVL(vprom,0);
      END;


  END;

/*------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------*/
--
-- Este procedimiento es para obtener los valores que quedaron pendientes de cobro al empleado.
-- Es un procedimiento que saca todos los valores deducibles al empleado.
--
   Procedure LiqEmp_Deducciones_x_Cobrar(P_No_cia    in varchar2,   -- Codigo de compa?ia
                                         P_CodNomAct in varchar2,   -- Nomina Actual de Liquidacion
                                         P_CodNomMen in varchar2,   -- Nomina Mensual de empleados
                                         P_No_emple  in varchar2,   -- Codigo de empleado
                                         P_fegreso   in  date,      -- Fecha de egreso del empleado
                                         P_IdFormula in varchar2,   -- Codigo de Formula
                                         pmonto      out number) IS -- Monto a recibir
      lv_CodSalBas  varchar2(3);
      lv_CodCompSal varchar2(3);
   Begin
   --
   -- Elimino todos las deducciones generadas automaticamente a excepcion de las deducciones manuales.
   --
      Delete from arplppd
       where no_cia   = P_No_cia
         and cod_pla  = P_CodNomAct
         and no_emple = P_No_emple
         and no_dedu in (Select CODIGO
                           from arplhs
                          where no_cia   = P_No_cia
                            and cod_pla  = P_CodNomMen
                            and no_emple = P_No_emple
                            and solo_cia = 'N'
                            and ano_mes  = TO_NUMBER(to_char(P_fegreso, 'RRRRMM'))
                            and tipo_m   = 'D'
                            and codigo   in (select no_dedu
                                               from arplmd
                                              where no_cia = P_No_cia
                                                and tipo  != '5'));
   --
   -- Ingreso todos los valores a deducir al empleado para su liquidacion.
   --
      insert into arplppd (NO_CIA, COD_PLA, NO_EMPLE, NO_DEDU, NO_OPERA,
                           MONTO, TASA, SOLO_CIA, MODIFICADO, IND_GEN_AUTO)
      Select NO_CIA, P_CodNomAct COD_PLA, NO_EMPLE, CODIGO, NO_OPERA,
             MONTO, TASA, SOLO_CIA, MODIFICADO, IND_GEN_AUTO
        from arplhs
       where no_cia   = P_No_cia
         and cod_pla  = P_CodNomMen
         and no_emple = P_No_emple
         and ano_mes  = TO_NUMBER(to_char(P_fegreso, 'RRRRMM'))
         and tipo_m   = 'D'
         and codigo   in (select cp.no_dedu
                            from ARPLDCP cp, arplmd md
                           where md.no_cia   = cp.NO_CIA
                             and md.no_dedu  = cp.no_dedu
                             and md.estado   = 'A'
                             and md.solo_cia = 'N'
                             and md.tipo    != '5'
                             and cp.NO_CIA   = P_No_cia
                             and cp.COD_PLA  = P_CodNomMen);


   --
   -- Elimino todos las deducciones tipo prestamos generadas automaticamente.
   --
      Delete from arplppd
       where no_cia   = P_No_cia
         and cod_pla  = P_CodNomAct
         and no_emple = P_No_emple
         and no_dedu in (Select CODIGO
                           from arplhs
                          where no_cia   = P_No_cia
                            and cod_pla  = P_CodNomMen
                            and no_emple = P_No_emple
                            and solo_cia = 'N'
                            and ano_mes  = TO_NUMBER(to_char(P_fegreso, 'RRRRMM'))
                            and tipo_m   = 'D'
                            and codigo   in (select no_dedu
                                               from arplmd
                                              where no_cia = P_No_cia
                                                and tipo   = '5'));

   --
   -- Ingreso todos los valores a deducir al empleado tipo prestamos generadas para su liquidacion.
   --
      Insert into arplppd (NO_CIA, COD_PLA, NO_EMPLE, NO_DEDU,
                           MONTO, TASA, SOLO_CIA, MODIFICADO, IND_GEN_AUTO)
      Select pre.NO_CIA, pre.COD_PLA, pre.NO_EMPLE, pre.no_dedu,
             pre.saldo, pre.TASA, md.SOLO_CIA, 'N', 'C'
        from arplpre pre, arplmd md
       where md.no_cia    = pre.no_cia
         and md.no_dedu   = pre.no_dedu
         and pre.no_cia   = P_No_cia
         and pre.cod_pla  = P_CodNomMen
         and pre.no_emple = P_No_emple
         and pre.no_dedu in (select no_dedu
                               from arplmd
                              where no_cia = P_No_cia
                                and tipo   = '5');

   --
   -- Devuelvo el valor de cero, ya que este procedimiento esta asociado a un ingreso ficticio.
   --
      pmonto := 0;
   End;
/*------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------------------*/
  -- ===============================================
   --  Liquidacion de Impuesto a la Renta
   -- ===============================================
     -- Impuesto al salario  PLDEDUCCIONES_LEY_ECU

  PROCEDURE calc_imp_sal (pno_cia       in arplme.no_cia%type,
                          pcod_pla      in arplcp.codpla%type,
                          pno_emple     in arplme.no_emple%type,
                          pno_dedu      in arplmd.no_dedu%type) IS

     vfr             NUMBER := rPla.redondeo;
     vgrupo_ing      ARPLMD.GRUPO_ING%TYPE;
     vsal_min_grab   NUMBER;
     vtot_ing        NUMBER;
     vtot_ing_o      NUMBER;
     vtot_ing1       NUMBER;
     vtot_ing1_o     NUMBER;
     vtodos_ing      NUMBER;
     --
     vtot_ded        NUMBER;
     vtot_ded_o      NUMBER;
     vtot_ded1       NUMBER;
     vtot_ded1_o     NUMBER;
     vtodos_ded      NUMBER;
     Ln_cobrado      NUMBER;
     --
     vexceso         ARPLPPI.MONTO%TYPE;
     vcreditos       ARPLPPI.MONTO%TYPE;
     vt_adelantos    ARPLPPD.MONTO%TYPE;

     -- Selecciona los empledos a los calculara el impuesto
     CURSOR c_emp IS
       SELECT e.no_emple, e.f_ingreso, e.tipo_emp
       FROM arplme e
       WHERE e.no_cia   = pno_cia
         AND e.no_emple = pno_emple
         AND e.estado   = 'A'
         AND nvl(e.ind_imp_renta,'N') = 'S'; -- calcula IR solo si el empleado tiene este indicador ANR 03/08/2010

     -- Selecciona el total de ingresos a los que se aplica el impuesto
     CURSOR c_ting_esta_pla(pno_emple VARCHAR2,pgrupo_ing VARCHAR2) IS
       SELECT NVL(SUM( NVL(i.monto,0)),0)
       FROM arplppi i, arplgid gi
       WHERE i.no_cia   = pno_cia
         AND i.cod_pla  = pcod_pla
         AND i.no_emple = pno_emple
         AND i.no_cia   = gi.no_cia
         AND i.no_ingre = gi.no_ingre
         AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de ingresos a los que se aplica el impuesto
     CURSOR c_ting_otras_pla(pno_emple VARCHAR2,pgrupo_ing VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplgid gi
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      = rPla.mes_proce
          AND h.tipo_m   = 'I'
          AND h.no_cia   = gi.no_cia
          AND h.codigo   = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de ingresos a los que se aplica el impuesto de meses ANTERIORES
     CURSOR c_ing_otros_meses(pno_emple VARCHAR2, pgrupo_ing VARCHAR2, pMes_Ingreso VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplgid gi
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      < rPla.mes_proce
          AND h.mes      >= pMes_Ingreso
          AND h.cod_pla  = pcod_pla
          AND h.tipo_m   = 'I'
          AND h.no_cia   = gi.no_cia
          AND h.codigo   = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de ingresos a los que se aplica el impuesto de meses ANTERIORES otras planillas
     CURSOR c_ting_otros_meses_otras_pla(pno_emple VARCHAR2, pgrupo_ing VARCHAR2, pMes_Ingreso VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplgid gi
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      < rPla.mes_proce
          AND h.mes      >= pMes_Ingreso
          AND h.cod_pla <> pcod_pla
          AND h.tipo_m   = 'I'
          AND h.no_cia   = gi.no_cia
          AND h.codigo   = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de deducciones de la planilla actual
     -- que reducen el monto imponible de renta
     CURSOR c_tded_esta_pla(pno_emple VARCHAR2) IS
       SELECT NVL(SUM( NVL(d.monto,0)),0)
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
        SELECT NVL(SUM(h.monto),0)
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

     -- Selecciona el total de deducciones de otras planilla
     -- que reducen el monto imponible de renta
     CURSOR c_ded_otros_meses(pno_emple VARCHAR2, pMes_Ingreso VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplmd md
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      < rPla.mes_proce
          AND h.mes      >= pMes_Ingreso
          AND h.cod_pla  = pcod_pla
          AND h.tipo_m   = 'D'
          AND h.codigo  != pno_dedu
          AND h.no_cia   = md.no_cia
          AND h.codigo   = md.no_dedu
          AND md.solo_cia = 'N'
          AND md.aplica_renta = 'S';

     -- Selecciona el total de deducciones de otras planilla de otros meses
     -- que reducen el monto imponible de renta
     CURSOR c_ded_otros_meses_otras_pla(pno_emple VARCHAR2, pMes_Ingreso VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplmd md
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      < rPla.mes_proce
          AND h.mes      >= pMes_Ingreso
          AND h.cod_pla <> pcod_pla
          AND h.tipo_m   = 'D'
          AND h.codigo  != pno_dedu
          AND h.no_cia   = md.no_cia
          AND h.codigo   = md.no_dedu
          AND md.solo_cia = 'N'
          AND md.aplica_renta = 'S';


     --- Reduce el valor de los gastos proyectados del empleado
     --- con un valor mensual proporcional
     Cursor C_Gastos Is
      select sum(gastos_vivienda + gastos_salud + gastos_educacion + gastos_alimenta + gastos_vestido) gastos
      from    arplme_impuesto
      where   no_cia = pno_cia
      and     no_emple = pno_emple
      and     ano IN (select ano_proce
                      from   arplcp
                      where  no_cia = pno_cia
                      and    codpla = pcod_pla);

     -- El siguiente cursor extrae los rangos y porcentajes utilizados
     -- en el calculo del impuesto al salario
     CURSOR c_rangos_sal (t_ingresos number)IS
       SELECT  limiteinf,
              limitesup,
              impuesto_min,
              porcentaje
       FROM arplis
       WHERE no_cia =  pno_cia
         and (limiteinf) <= t_ingresos
         and (limitesup)  > t_ingresos
       ORDER BY limiteinf;

    --**************************************************
    --  MONTO  DE  UTILIDADES  
    --**************************************************
    Cursor C_Cod_pla (Lv_temp Varchar2, C_ANIO NUMBER) IS   -- Codigos de nomina por compania y tipo de empleado
      SELECT nvl(monto,0)
             FROM arplhs  WHERE no_cia = pno_cia AND ano= C_ANIO AND tipo_m = 'I' AND NO_emple = pno_emple
      and  cod_pla IN  (  select a.dato_caracter 
                          from   arplpgd a, arplcp b 
                          where  b.no_cia = pno_cia
                          and    b.tipo_emp = Lv_temp
                          and    a.grupo_parametro = 'UTILIDADES' 
                          and    a.parametro_id = 'N2TE'
                          and    a.dato_caracter = b.codpla
                                        UNION
                                                    select a.dato_caracter 
                                                    from   arplpgd a, arplcp b 
                                                    where  b.no_cia = pno_cia
                                                    and    b.tipo_emp = Lv_temp
                                                    and    a.grupo_parametro = 'UTILIDADES' 
                                                    and    a.parametro_id = 'N1TE'
                                                    and    a.dato_caracter = b.codpla );  

    CURSOR C_Anio_proceso IS
     SELECT ano_proce-1, mes_proce FROM arplcp WHERE no_cia = pno_cia AND codpla=pcod_pla;

     Lv_emple       Arplme.no_emple%type;
     Ld_f_ingre     Arplme.f_Ingreso%type;
     Lv_tipo_empl   Arplme.Tipo_Emp%type;
     Lv_cod_nomina  Arplcp.Codpla%type;
     vgastos        Number;
     vImponible     Number;
     vImponible_p   Number;
     Ln_anio        Number;
     Ln_mes         Number;
     Ln_meses       Number;
     Ln_mesDivide   Number;
     Ln_utilidad    NUMBER;
     Ln_Adiciona_UT NUMBER;
     Ln_Anio_proceUt NUMBER;
     Ln_mes_proce   NUMBER;

   BEGIN
        Ln_Adiciona_UT := 0;

    -- Verifica que el empleado tenga marcado o no lo del impuesto a la renta ANR 03/08/2010
    Open c_emp;
    Fetch c_emp into Lv_emple, Ld_f_ingre, Lv_tipo_empl;
    If c_emp%notfound Then
       Close c_emp;
       rCalc.monto := 0;
       rCalc.total := 0;
    else
       Close c_emp;
    END IF;

    -- Divido por el numero de meses del año que se esta trabajando
    Ln_anio := to_number(to_char(Ld_f_ingre,'yyyy'));
    Ln_mes  := to_number(to_char(Ld_f_ingre,'mm'));

    If rPla.ano_proce > Ln_anio Then  -- Entro antes del anio de proceso
       Ln_meses := 1;
       Ln_mesDivide := rPla.mes_proce;
     else  -- Entro en el año de proceso
       -- Desde que mes entro
       Ln_meses := Ln_mes;
       Ln_mesDivide := (rPla.mes_proce - Ln_meses)+1;
    End if;

    --********* INGRESOS DE ESTE MES ******************
    -- total de ingresos en esta planilla
    OPEN c_ting_esta_pla(pno_emple, rDed.grupo_ing);
    FETCH c_ting_esta_pla INTO vtot_ing;
    CLOSE c_ting_esta_pla;

    -- Debe recuperar el total de ingresos de planillas anteriores correspondientes
    -- al mismo mes que se encuentran ya en el historico de movims.
    OPEN c_ting_otras_pla(pno_emple, rDed.grupo_ing);
    FETCH c_ting_otras_pla INTO vtot_ing_o;
    CLOSE c_ting_otras_pla;

    --********* INGRESOS DE MESES ANTERIORES ***************
    -- total de ingresos en esta planilla
    OPEN  c_ing_otros_meses(pno_emple, rDed.grupo_ing, Ln_meses);
    FETCH c_ing_otros_meses INTO vtot_ing1;
    CLOSE c_ing_otros_meses;

    -- Debe recuperar el total de ingresos de planillas anteriores correspondientes
    -- al mismo mes que se encuentran ya en el historico de movims.
    OPEN  c_ting_otros_meses_otras_pla(pno_emple, rDed.grupo_ing, Ln_meses);
    FETCH c_ting_otros_meses_otras_pla INTO vtot_ing1_o;
    CLOSE c_ting_otros_meses_otras_pla;

    --************* DEDUCCIONES MES ACTUAL *****************
    -- calcula el total de deducciones que reducen el imponible
    OPEN c_tded_esta_pla(pno_emple);
    FETCH c_tded_esta_pla INTO vtot_ded;
    CLOSE c_tded_esta_pla;
    vtot_ded := nvl(vtot_ded,0);

    OPEN c_tded_otras_pla(pno_emple);
    FETCH c_tded_otras_pla INTO vtot_ded_o;
    CLOSE c_tded_otras_pla;
    vtot_ded := vtot_ded + NVL(vtot_ded_o,0);

    --*********** DEDUCCIONES MESES ANTERIORES **************
    OPEN  c_ded_otros_meses(pno_emple, Ln_meses);
    FETCH c_ded_otros_meses INTO vtot_ded1;
    CLOSE c_ded_otros_meses;
    vtot_ded := nvl(vtot_ded,0);

    OPEN  c_ded_otros_meses_otras_pla(pno_emple, Ln_meses);
    FETCH c_ded_otros_meses_otras_pla INTO vtot_ded1_o;
    CLOSE c_ded_otros_meses_otras_pla;

    --*********** DEDUCCION POR UTILIDADES  **************
    -- Como desde Enero a Abril no se tomo en cuenta el valor de Utilidades se tendra que 
    -- calcular un valor por mes multiplicarlo por 4 y añadirlo a los ingresos,  para el 
    -- calculo del año 2015 hay que hacerlo sobre 3 meses
    OPEN  C_Anio_proceso;
    FETCH C_Anio_proceso INTO Ln_Anio_proceUt, Ln_mes_proce;
    CLOSE C_Anio_proceso;

    OPEN  C_Cod_pla (Lv_tipo_empl, Ln_Anio_proceUt);  -- Se envia el tipo de empleado
    FETCH C_Cod_pla INTO Ln_utilidad;
    CLOSE C_Cod_pla;

    Ln_Adiciona_UT := ( Ln_utilidad/12 ) * Ln_mes_proce; --  por los meses en que no se tuvo el valor de la Utilidad

    --******************************************************
    --  *****  Totales de Ingresos y Deducciones *****
        --
    vtodos_ing := NVL(vtot_ing,0) + NVL(vtot_ing_o,0) + NVL(vtot_ing1,0) + NVL(vtot_ing1_o,0) + NVL(Ln_Adiciona_UT,0);
    vtodos_ded := NVL(vtot_ded,0) + NVL(vtot_ded_o,0) + NVL(vtot_ded1,0) + NVL(vtot_ded1_o,0);
    --******************************************************

    --- Gastos proyectados
    Open C_Gastos;
    Fetch C_Gastos into vgastos;
    If C_Gastos%notfound Then
     vgastos := 0;
     Close C_Gastos;
    else
     Close C_Gastos;
    end if;

    -- De los datos encontradas dividirlos para los meses
    vImponible_p := (vtodos_ing - vtodos_ded) / Ln_mesDivide;

    -- Del valor proyectado(1 mes) lo llevo al año y le resto los gastos anuales
    vImponible := (vImponible_p * 12) - vgastos;

    -- Si el total de ingresos es superior al minimo grabable calcula el impuesto al salario
    vexceso := 0;

    FOR f2 IN c_rangos_sal(vImponible) LOOP
      IF f2.porcentaje > 0 THEN
        --
        IF (((vImponible - f2.limiteinf) * (f2.porcentaje/100)) + f2.impuesto_min) > 0 THEN
          vexceso := (((vImponible - f2.limiteinf) * (f2.porcentaje/100)) + f2.impuesto_min) / 12;
        END IF;
      END IF;
    END LOOP;
    --
     IF vexceso > 0 THEN
        -- Debe contemplar los adelantos de impuesto al salario que se
        -- Diesen en planillas anteriores
        BEGIN
          SELECT NVL(SUM(NVL(monto,0)),0) INTO vt_adelantos
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
     END IF;  

     vexceso      := greatest(0, nvl(vexceso,0));
     vt_adelantos := nvl(vt_adelantos,0);
     vexceso      := vexceso - vt_adelantos;
     rCalc.monto  := vexceso;
     rCalc.total  := vexceso;

     -- Para evitar un cobro mayor al valor anual a pagar (exceso*12) se va a buscar los 
     -- valores ya pagados para comparar si se debe de seguir cobrando
      BEGIN
        Select (sum(nvl(monto,0)) / Ln_mesDivide) into Ln_cobrado  -- Lo llevo a mes
          From arplhs h, arplpar p 
          where h.no_cia=pno_cia 
          and h.ano=rPla.ano_proce 
          and h.no_emple = pno_emple
          and h.tipo_m = 'D' 
          and h.no_cia=p.no_cia 
          and h.codigo=p.cod_impsal;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           vt_adelantos := 0;
           null;
      END;     

     If Ln_cobrado >= vexceso Then  -- Ya no se cobra nada si el promedio mensual ya cobrado es mayor o igual a lo que se va a cobrar
         rCalc.monto  := 0;
         rCalc.total  := 0;
     End if;
   END;   -- calc_imp_sal


     /*
     PROCEDURE calc_imp_sal(pno_cia       in arplme.no_cia%type,
                            pcod_pla      in arplcp.codpla%type,
                            pno_emple     in arplme.no_emple%type,
                            pno_dedu      in arplmd.no_dedu%type) IS

     vfr             NUMBER := rPla.redondeo;
     vgrupo_ing      ARPLMD.GRUPO_ING%TYPE;
     vsal_min_grab   NUMBER;
     vtot_ing        NUMBER;
     vtot_ing_o      NUMBER;
     vtot_ing1       NUMBER;
     vtot_ing1_o     NUMBER;
     vtodos_ing      NUMBER;
     --
     vtot_ded        NUMBER;
     vtot_ded_o      NUMBER;
     vtot_ded1       NUMBER;
     vtot_ded1_o     NUMBER;
     vtodos_ded      NUMBER;
     --
     vexceso         ARPLPPI.MONTO%TYPE;
     vcreditos       ARPLPPI.MONTO%TYPE;
     vt_adelantos    ARPLPPD.MONTO%TYPE;

     -- Selecciona los empledos a los calculara el impuesto
     CURSOR c_emp IS
       SELECT e.no_emple, e.f_ingreso, e.tipo_emp
       FROM arplme e
       WHERE e.no_cia   = pno_cia
         AND e.no_emple = pno_emple
         AND e.estado   = 'A'
         AND nvl(e.ind_imp_renta,'N') = 'S'; -- calcula IR solo si el empleado tiene este indicador ANR 03/08/2010

     -- Selecciona el total de ingresos a los que se aplica el impuesto
     CURSOR c_ting_esta_pla(pno_emple VARCHAR2,pgrupo_ing VARCHAR2) IS
       SELECT NVL(SUM( NVL(i.monto,0)),0)
       FROM arplppi i, arplgid gi
       WHERE i.no_cia   = pno_cia
         AND i.cod_pla  = pcod_pla
         AND i.no_emple = pno_emple
         AND i.no_cia   = gi.no_cia
         AND i.no_ingre = gi.no_ingre
         AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de ingresos a los que se aplica el impuesto
     CURSOR c_ting_otras_pla(pno_emple VARCHAR2,pgrupo_ing VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplgid gi
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      = rPla.mes_proce
          AND h.tipo_m   = 'I'
          AND h.no_cia   = gi.no_cia
          AND h.codigo   = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de ingresos a los que se aplica el impuesto de meses ANTERIORES
     CURSOR c_ing_otros_meses(pno_emple VARCHAR2, pgrupo_ing VARCHAR2, pMes_Ingreso VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplgid gi
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      < rPla.mes_proce
          AND h.mes      >= pMes_Ingreso
          AND h.cod_pla  = pcod_pla
          AND h.tipo_m   = 'I'
          AND h.no_cia   = gi.no_cia
          AND h.codigo   = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de ingresos a los que se aplica el impuesto de meses ANTERIORES otras planillas
     CURSOR c_ting_otros_meses_otras_pla(pno_emple VARCHAR2, pgrupo_ing VARCHAR2, pMes_Ingreso VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplgid gi
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      < rPla.mes_proce
          AND h.mes      >= pMes_Ingreso
          AND h.cod_pla <> pcod_pla
          AND h.tipo_m   = 'I'
          AND h.no_cia   = gi.no_cia
          AND h.codigo   = gi.no_ingre
          AND gi.grupo_ing = pgrupo_ing;

     -- Selecciona el total de deducciones de la planilla actual
     -- que reducen el monto imponible de renta
     CURSOR c_tded_esta_pla(pno_emple VARCHAR2) IS
       SELECT NVL(SUM( NVL(d.monto,0)),0)
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
        SELECT NVL(SUM(h.monto),0)
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

     -- Selecciona el total de deducciones de otras planilla
     -- que reducen el monto imponible de renta
     CURSOR c_ded_otros_meses(pno_emple VARCHAR2, pMes_Ingreso VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplmd md
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      < rPla.mes_proce
          AND h.mes      >= pMes_Ingreso
          AND h.cod_pla  = pcod_pla
          AND h.tipo_m   = 'D'
          AND h.codigo  != pno_dedu
          AND h.no_cia   = md.no_cia
          AND h.codigo   = md.no_dedu
          AND md.solo_cia = 'N'
          AND md.aplica_renta = 'S';

     -- Selecciona el total de deducciones de otras planilla de otros meses
     -- que reducen el monto imponible de renta
     CURSOR c_ded_otros_meses_otras_pla(pno_emple VARCHAR2, pMes_Ingreso VARCHAR2) IS
        SELECT NVL(SUM(h.monto),0)
        FROM arplhs h, arplmd md
        WHERE h.no_cia   = pno_cia
          AND h.no_emple = pno_emple
          AND h.ano      = rPla.ano_proce
          AND h.mes      < rPla.mes_proce
          AND h.mes      >= pMes_Ingreso
          AND h.cod_pla <> pcod_pla
          AND h.tipo_m   = 'D'
          AND h.codigo  != pno_dedu
          AND h.no_cia   = md.no_cia
          AND h.codigo   = md.no_dedu
          AND md.solo_cia = 'N'
          AND md.aplica_renta = 'S';


     --- Reduce el valor de los gastos proyectados del empleado
     --- con un valor mensual proporcional
     Cursor C_Gastos Is
      select sum(gastos_vivienda + gastos_salud + gastos_educacion + gastos_alimenta + gastos_vestido) gastos
      from    arplme_impuesto
      where   no_cia = pno_cia
      and     no_emple = pno_emple
      and     ano IN (select ano_proce
                      from   arplcp
                      where  no_cia = pno_cia
                      and    codpla = pcod_pla);

     -- El siguiente cursor extrae los rangos y porcentajes utilizados
     -- en el calculo del impuesto al salario
     CURSOR c_rangos_sal (t_ingresos number)IS
       SELECT  limiteinf,
              limitesup,
              impuesto_min,
              porcentaje
       FROM arplis
       WHERE no_cia =  pno_cia
         and (limiteinf) <= t_ingresos
         and (limitesup)  > t_ingresos
       ORDER BY limiteinf;

   Lv_emple       Arplme.no_emple%type;
   Ld_f_ingre     Arplme.f_Ingreso%type;
   Lv_tipo_empl   Arplme.Tipo_Emp%type;
   Lv_cod_nomina  Arplcp.Codpla%type;
   vgastos        Number;
   vImponible     Number;
   vImponible_p   Number;
   Ln_anio        Number;
   Ln_mes         Number;
   Ln_meses       Number;
   Ln_mesDivide   Number;

   BEGIN
    -- Verifica que el empleado tenga marcado o no lo del impuesto a la renta ANR 03/08/2010
    Open c_emp;
    Fetch c_emp into Lv_emple, Ld_f_ingre, Lv_tipo_empl;
    If c_emp%notfound Then
       Close c_emp;
       rCalc.monto := 0;
       rCalc.total := 0;
    else
       Close c_emp;
    END IF;

    -- Divido por el numero de meses del año que se esta trabajando
    Ln_anio := to_number(to_char(Ld_f_ingre,'yyyy'));
    Ln_mes  := to_number(to_char(Ld_f_ingre,'mm'));

    If rPla.ano_proce > Ln_anio Then  -- Entro antes del anio de proceso
       Ln_meses := 1;
       Ln_mesDivide := rPla.mes_proce;
     else  -- Entro en el año de proceso
       -- Desde que mes entro
       Ln_meses := Ln_mes;
       Ln_mesDivide := (rPla.mes_proce - Ln_meses)+1;
    End if;

    --********* INGRESOS DE ESTE MES ******************
    -- total de ingresos en esta planilla
    OPEN c_ting_esta_pla(pno_emple, rDed.grupo_ing);
    FETCH c_ting_esta_pla INTO vtot_ing;
    CLOSE c_ting_esta_pla;

    -- Debe recuperar el total de ingresos de planillas anteriores correspondientes
    -- al mismo mes que se encuentran ya en el historico de movims.
    OPEN c_ting_otras_pla(pno_emple, rDed.grupo_ing);
    FETCH c_ting_otras_pla INTO vtot_ing_o;
    CLOSE c_ting_otras_pla;

    --********* INGRESOS DE MESES ANTERIORES ***************
    -- total de ingresos en esta planilla
    OPEN  c_ing_otros_meses(pno_emple, rDed.grupo_ing, Ln_meses);
    FETCH c_ing_otros_meses INTO vtot_ing1;
    CLOSE c_ing_otros_meses;

    -- Debe recuperar el total de ingresos de planillas anteriores correspondientes
    -- al mismo mes que se encuentran ya en el historico de movims.
    OPEN  c_ting_otros_meses_otras_pla(pno_emple, rDed.grupo_ing, Ln_meses);
    FETCH c_ting_otros_meses_otras_pla INTO vtot_ing1_o;
    CLOSE c_ting_otros_meses_otras_pla;

    --************* DEDUCCIONES MES ACTUAL *****************
    -- calcula el total de deducciones que reducen el imponible
    OPEN c_tded_esta_pla(pno_emple);
    FETCH c_tded_esta_pla INTO vtot_ded;
    CLOSE c_tded_esta_pla;
    vtot_ded := nvl(vtot_ded,0);

    OPEN c_tded_otras_pla(pno_emple);
    FETCH c_tded_otras_pla INTO vtot_ded_o;
    CLOSE c_tded_otras_pla;
    vtot_ded := vtot_ded + NVL(vtot_ded_o,0);

    --*********** DEDUCCIONES MESES ANTERIORES **************
    OPEN  c_ded_otros_meses(pno_emple, Ln_meses);
    FETCH c_ded_otros_meses INTO vtot_ded1;
    CLOSE c_ded_otros_meses;
    vtot_ded := nvl(vtot_ded,0);

    OPEN  c_ded_otros_meses_otras_pla(pno_emple, Ln_meses);
    FETCH c_ded_otros_meses_otras_pla INTO vtot_ded1_o;
    CLOSE c_ded_otros_meses_otras_pla;

    --  *****  Totales de Ingresos y Deducciones *****
    vtodos_ing := NVL(vtot_ing,0) + NVL(vtot_ing_o,0) + NVL(vtot_ing1,0) + NVL(vtot_ing1_o,0);
    vtodos_ded := NVL(vtot_ded,0) + NVL(vtot_ded_o,0) + NVL(vtot_ded1,0) + NVL(vtot_ded1_o,0);

    --- Gastos proyectados
    Open C_Gastos;
    Fetch C_Gastos into vgastos;
    If C_Gastos%notfound Then
     vgastos := 0;
     Close C_Gastos;
    else
     Close C_Gastos;
    end if;

    -- De los datos encontradas dividirlos para los meses
    vImponible_p := (vtodos_ing - vtodos_ded) / Ln_mesDivide;

    -- Del valor proyectado(1 mes) lo llevo al año y le resto los gastos anuales
    vImponible := (vImponible_p * 12) - vgastos;

    -- Si el total de ingresos es superior al minimo grabable calcula el impuesto al salario
    vexceso := 0;

    FOR f2 IN c_rangos_sal(vImponible) LOOP
      IF f2.porcentaje > 0 THEN
        --
        IF (((vImponible - f2.limiteinf) * (f2.porcentaje/100)) + f2.impuesto_min) > 0 THEN
          vexceso := (((vImponible - f2.limiteinf) * (f2.porcentaje/100)) + f2.impuesto_min) / 12;
        END IF;
      END IF;
    END LOOP;
    --
     IF vexceso > 0 THEN
        -- Debe contemplar los adelantos de impuesto al salario que se
        -- Diesen en planillas anteriores
        BEGIN
          SELECT NVL(SUM(NVL(monto,0)),0) INTO vt_adelantos
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
     END IF;

     vexceso      := greatest(0, nvl(vexceso,0));
     vt_adelantos := nvl(vt_adelantos,0);
     vexceso      := vexceso - vt_adelantos;
     rCalc.monto  := vexceso;
     rCalc.total  := vexceso;
   END;

*/

     -- ===============================================
   --  Liquidacion de Impuesto a la Renta anual
   -- ===============================================
   -- Procedimiento creado por Antonio Navarrete 04/08/2010 en base al existente cal_imp_sal
   -- se utiliza en la pantalla de calculo anual del impuesto a la renta (FPL324)
     -- Impuesto al salario  PLDEDUCCIONES_LEY_ECU
   PROCEDURE calc_imp_sal_anual(pv_cia      in arplme.no_cia%type
                               ,pv_emple    in arplme.no_emple%type
                               ,pn_anio     in  Number
                               ,pn_ing      in  Number
                               ,pn_ded      in  Number
                               ,pn_monto    out NUMBER ) IS

     vsal_min_grab   NUMBER;
     vtot_ing        NUMBER;
     vtot_ded        NUMBER;
     --
     vexceso        ARPLPPI.MONTO%TYPE;

     -- Selecciona los empledos a los calculara el impuesto
     CURSOR c_emp IS
       SELECT e.no_emple
       FROM arplme e
       WHERE e.no_cia   = pv_cia
         AND e.no_emple = pv_emple
         AND e.estado   = 'A'
         AND nvl(e.ind_imp_renta,'N') = 'S' --- calcula impuesto a la renta solo si el empleado tiene este indicador ANR 03/08/2010
       GROUP BY e.no_emple, e.e_civil;

     -- El siguiente cursor extrae los rangos y porcentajes utilizados
     -- en el calculo del impuesto al salario
     CURSOR c_rangos_sal (t_ingresos number)IS
       SELECT (limiteinf) limiteinf,
              (limitesup) limitesup,
              (impuesto_min) impuesto_min,
              porcentaje
       FROM arplis_historico
       WHERE no_cia = pv_cia
         and anio   = pn_anio
         and (limiteinf) <=t_ingresos
         and (limitesup)  >t_ingresos
       ORDER BY limiteinf;

   Lv_emple Arplme.no_emple%type;

   BEGIN

   --- Verifica que el empleado tenga marcado o no lo del impuesto a la renta ANR 03/08/2010
   Open c_emp;
   Fetch c_emp into Lv_emple;
   If c_emp%notfound Then
     Close c_emp;
     rCalc.monto := 0;
     rCalc.total := 0;
   else
     Close c_emp;

     -- Saca el salario minimo grabable
     BEGIN
       SELECT MIN(limiteinf) INTO vsal_min_grab
         FROM arplis_historico
         WHERE no_cia = pv_cia
         AND   anio   = pn_anio;
     EXCEPTION
        WHEN no_data_found THEN
           null;
     END;

    vtot_ing := pn_ing; ---- ingresos historicos al anio
    vtot_ded := pn_ded; --- gastos y valores descontados de impuesto a la renta

    -- al total ingresos quita las deducciones que reducen
    -- el imponible de renta
    vtot_ing := vtot_ing - vtot_ded;

    -- Si el total de ingresos es superior al minimo grabable
    -- calcula el impuesto al salario

    vexceso := 0;

       FOR f2 IN c_rangos_sal(vtot_ing) LOOP
           vexceso := ((vtot_ing - f2.limiteinf) * (f2.porcentaje/100)) + f2.impuesto_min;
       END LOOP;
       --

       vexceso      := greatest(0, nvl(vexceso,0));
       pn_monto     := vexceso;

   end if;
   END;

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
              cod_ade_impsal, creditoxc, creditoxh
       FROM arplpar
       WHERE no_cia = pCia;
   BEGIN
      limpia_error;
      open c_cia;
      fetch c_cia into rCia.cod_h_ord,
                       rCia.cod_impsal,
                       rCia.cod_provi_vac,
                       rCia.cod_ade_impsal,
                       rCia.creditoxc,
                       rCia.creditoxh;
      close c_cia;
   END inicializa;
   --
   -- ---
   FUNCTION calcula(pno_cia       in arplme.no_cia%type,
                    pcod_pla      in arplppd.cod_pla%type,
                    pno_emple     in arplppd.no_emple%type,
                    pno_dedu      in arplppd.no_dedu%type,
                    pformula_id   in arplmd.formula_id%type) RETURN calculo_r
   IS
   -- Auxiliares para calculo de proprocion de Tiempo
      Meses_Cia  NUMBER;
      cdescri    VARCHAR2(50);
      vanos      NUMBER(4);
      MESES      NUMBER(2);
      dias       NUMBER(2);
   BEGIN
   --
      IF NOT inicializado(pno_cia) THEN
         inicializa(pno_cia);
      END IF;
      limpia_error;
      -- limpia el registro del calculo
      rCalc.monto     := null;
      rCalc.total     := null;
      rCalc.tasa      := null;
      rCalc.cantidad  := NULL;
      rCalc.monto     := NULL;
      rCalc.monto_aux := NULL;
      rCalc.tasa      := NULL;
      rCalc.MESES     := NULL;
      rCalc.dias      := NULL;
     --
     --
     -- Determino tiempo de trabajo para Aplicar Proporcion
     if not inicializado(pno_cia) then
        inicializa(pno_cia);
     end if;
     carga_datos_pla(pno_cia, pcod_pla);
     carga_datos_emp(pno_cia, pno_emple, rpla.horasxpla);
     carga_datos_ded(pno_cia, pcod_pla, pno_dedu);
     cdescri := Dif_Fecha(Rpla.f_hasta, Remp.f_ingreso, vanos, MESES, dias);
     IF dias >= 30 THEN
        MESES := MESES +1;
        dias  := 0;
     END IF;
     MESES := LEAST(12,(vanos*12)+ MESES);
     IF MESES >= 12 THEN
        MESES := 12;
        dias  := 0;
     END IF;
     --

     If    pformula_id = 'RCIVA' then
           calc_rciva(pno_cia, pno_emple, pno_dedu);
     elsif pformula_id = 'PRODECUA' then
           ProvisionDecimoCuarto(rcia.no_cia,pformula_id,rCalc.monto);

        n_dias:=0;
        n_dias  := nvl(rEmp.dias_lab,0);
        rCalc.monto := (rCalc.monto / 30) * n_dias;

     elsif pformula_id = 'AJUS14TO' then
           AjusteProvDecimoCuarto(pno_cia,pcod_pla,Rpla.f_desde,Rpla.f_hasta,pno_emple,
                                  Remp.ind_region,Remp.f_ingreso,pformula_id,rCalc.monto);
     elsif pformula_id = 'PRODETER' then
           ProvisionDecimoTercero(pno_cia,Pno_emple,pcod_pla,pformula_id,rCalc.monto);

     elsif pformula_id = 'PROV13CI02' then
           ProvisionDecimoTercero(pno_cia,Pno_emple,pcod_pla,pformula_id,rCalc.monto);

     elsif pformula_id = 'PROV13BO02' then
           ProvisionDecimoTercero(pno_cia,Pno_emple,pcod_pla,pformula_id,rCalc.monto);

     elsif pformula_id = 'FONDRESE02' THEN
         FondoDeReserva(pno_cia,Rpla.f_hasta,Remp.f_ingreso,Pno_emple,pcod_pla,rCalc.MESES,Rpla.f_desde,Rpla.f_hasta, pformula_id, rCalc.monto); --03/10/2008

     elsif pformula_id = 'FONDO/RESE' THEN
         FondoDeReserva(pno_cia,Rpla.f_hasta,Remp.f_ingreso,Pno_emple,pcod_pla,rCalc.MESES,Rpla.f_desde,Rpla.f_hasta, pformula_id, rCalc.monto); --05-12-2001
     elsif pformula_id = 'IMP/RENTA' then
        calc_imp_sal(pno_cia, pcod_pla, pno_emple, pno_dedu);
   --18-12-2001
   --Para la liquidacion de empleados
     ELSIF Pformula_id = 'LIQEMP_DED' THEN
         Carga_Datos_LiqEmp(pno_cia, pcod_pla, pno_emple);
        LiqEmp_Deducciones_x_Cobrar(pno_cia, pcod_pla, Lc_Dat_LiqEmp.CODPLA, pno_emple, remp.f_egreso, pformula_id, rCalc.monto);
   --------------
     else
           genera_error('La logica para la formula: '|| pformula_id ||' no ha sido escrita');
     end if;
     RETURN (rCalc);
   END calcula;
   --
END;   -- BODY deducciones_ley_ecu
/