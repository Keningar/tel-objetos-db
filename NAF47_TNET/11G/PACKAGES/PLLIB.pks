CREATE OR REPLACE PACKAGE            PLLIB IS
-- PL/SQL Specification
-- ---
   --   Este paquete contiene varios procedimientos y funciones
   -- que facilitan el procesamiento de nomimas.
   --
   --
   -- ***
   --
   -- --
   -- DECLARACION TIPOS
   --
   -- tipo registro para el paquete PLingresos
    TYPE PLingresos_calc_r IS RECORD(
      cantidad         arplppi.cantidad%type
      ,aplica_cantidad varchar2(1)
      ,monto           arplppi.monto%type
      ,monto_aux       arplppi.monto_aux%type
      ,tasa            arplppi.tasa%type
      ,meses           arplppi.meses%type
      ,dias            arplppi.dias%type
   );
   -- tipo registro para el paquete PLdeducciones
   TYPE PLdeducciones_calc_r IS RECORD(
      monto        arplppd.monto%type
      ,total       arplppd.total%type
      ,tasa        arplppd.tasa%type
    ,cantidad    arplppi.cantidad%type
      ,monto_aux   arplppi.monto_aux%type
      ,meses       arplppi.meses%type
      ,dias        arplppi.dias%type
   );
   --
   v_arplth_rg          arplth%ROWTYPE;
   --
   -- --
   -- Determina si el empleado indicado ya posee la clase dada
   FUNCTION existe_empleado_clase(
                  pCia        in arplecl.no_cia%type
                  ,pno_emple  in arplecl.no_emple%type
                  ,pclase_emp in arplecl.clase_emp%type) RETURN BOOLEAN;
   --  --
   --  Determina la cantidad de lunes existentes entre un rango de fechas
   --  (normalmente periodo de planilla)
   FUNCTION CUENTA_DIAS (Fecha1  Date
                         ,Fecha2 Date
                         ,dia    Varchar2) RETURN Number;
   --
   -- --
   -- Cuenta la cantidad de dias feriados que hay entre dos fechas
   FUNCTION CUENTA_FERIADOS (
            pno_cia arpldf.no_cia%type
            ,Fecha1  Date
            ,Fecha2 Date) RETURN NUMBER;
   --
   FUNCTION trae_parametro(pparam_id   IN VARCHAR2
                           ,pdato       IN OUT NUMBER) RETURN BOOLEAN;
   --
   FUNCTION trae_parametro(pparam_id   IN VARCHAR2
                           ,pdato       IN OUT VARCHAR2) RETURN BOOLEAN;
   --
   FUNCTION trae_parametro(pparam_id   IN VARCHAR2
                           ,pdato       IN OUT DATE) RETURN BOOLEAN;
   --
   FUNCTION ing_formulaid(
                 pno_cia       in varchar2
                 ,pcod_pla     in varchar2
                 ,pno_emple    in varchar2
                 ,pformula_id  in varchar2
                 ,ptipo_dato   in varchar2   -- M=monto, %=Porcentaje, T=total
                 ,paplica_a    in varchar2 default null
                 )RETURN NUMBER;
   --
   FUNCTION ded_formulaid(
                 pno_cia       in varchar2
                 ,pcod_pla     in varchar2
                 ,pno_emple    in varchar2
                 ,pformula_id  in varchar2
                 ,ptipo_dato   in varchar2   -- M=monto, %=Porcentaje, T=total
                 ,paplica_a    in varchar2 default null
                 )RETURN NUMBER;
   --
   -- Devuelve el monto correspondiente a un grupo de ingresos para una planilla dada
   FUNCTION monto_grupo_ing_pp(
                 pno_cia     in arplppi.no_cia%type
                ,pno_emple   in arplppi.no_emple%type
                ,pgrupo_ing  in arplgid.grupo_ing%type
                ,pcod_pla    in arplppi.cod_pla%type ) RETURN NUMBER;
   --
   -- Devuelve el monto correspondiente a un grupo de ingresos para un mes dado
   FUNCTION monto_grupo_ing_h(
                 pno_cia      in arplhs.no_cia%type
                 ,pno_emple   in arplhs.no_emple%type
                 ,pgrupo_ing  in arplgid.grupo_ing%type
                 ,pano        in arplhs.ano%type
                 ,pmes        in arplhs.mes%type ) RETURN NUMBER;
   --
   -- Devuelve el monto correspondiente a un ingreso para la planilla en curso
   FUNCTION monto_ing_pp(
     pno_cia      in arplppi.no_cia%type
     ,pno_emple   in arplppi.no_emple%type
     ,pno_ingre   in arplppi.no_ingre%type
     ,pcod_pla    in arplppi.cod_pla%type
   ) RETURN NUMBER;
   --
   -- Devuelve el monto total de un concepto para un determinado mes
   FUNCTION monto_h(
    pno_cia      in arplppi.no_cia%type
    ,pano        in arplhs.ano%type
  ,pmes        in arplhs.mes%type
    ,pno_emple   in arplppi.no_emple%type
    ,ptipo_m     in arplhs.tipo_m%type
    ,pcodigo     in arplhs.codigo%type
   ) RETURN NUMBER;
   --
   -- Devuelve la cantidad correspondiente a un ingreso la planilla en curso
   FUNCTION cantidad_ing_pp(
     pno_cia      in arplppi.no_cia%type
     ,pno_emple   in arplppi.no_emple%type
     ,pno_ingre   in arplppi.no_ingre%type
     ,pcod_pla    in arplppi.cod_pla%type
   ) RETURN NUMBER;
   --
   -- Devuelve el total de ingresos correspondiente a x cantidad de periodos
   -- hacia atras del mes indicado,
   -- tomando los ingresos de la historia hasta un maximo de x cantidad de meses
   FUNCTION monto_grupo_ing_per(
    pno_cia      in arplhs.no_cia%type
    ,pno_emple   in arplhs.no_emple%type
    ,pgrupo_ing  in arplgid.grupo_ing%type
    ,pano        in arplhs.ano%type
    ,pmes        in arplhs.mes%type
    ,pperiodos   in NUMBER
    ,ptotal_dias in NUMBER
    ,pdiasxper   in NUMBER
    ,pmesesatras in NUMBER
   ) RETURN NUMBER;
   --
   -- Verifica si la planilla es la ultima del mes o no .
   FUNCTION es_ultima_planilla (
                 pcia VARCHAR2,
                 pcod_pla VARCHAR2) RETURN BOOLEAN;
   --
   -- --
   -- Salario diario correspondiente a ingresos fijos para un mes dado diferente al de la planill
   -- en curso.
   --
   FUNCTION sal_diario_fijo_mes (
     p_cia       CHAR,
     p_no_emple  CHAR,
     p_grupo_ing CHAR,
     p_diasxmes  NUMBER,
     p_ano       NUMBER,
     p_mes       NUMBER
   )RETURN NUMBER;
   --
   -- --
   -- Salario diario correspondiente a ingresos fijos para el mes de la planilla
   FUNCTION sal_diario_fijo_mes_pla (
     p_cia       CHAR,
     p_cod_pla   CHAR,
     p_no_emple  CHAR,
     p_grupo_ing CHAR,
     p_diasxmes  NUMBER,
     p_ano       NUMBER,
     p_mes       NUMBER
   )RETURN NUMBER;
   --
   -- --
   -- Salario diario correspondiente a ingresos variables
   FUNCTION sal_diario_var (
     p_cia         VARCHAR2,
     p_cod_pla     VARCHAR2,
     p_f_hasta     DATE,
     p_no_emple    VARCHAR2,
     p_f_ingreso   DATE,
     p_ano         NUMBER,
     p_mes         NUMBER,
     p_grupoing    VARCHAR2,
     p_divisor     NUMBER    -- 1 = Mensual
   )RETURN NUMBER;
   --
-- ****************
-- Salario diario correspondiente a ingresos de un grupo en los ultimos x meses
--
   FUNCTION sal_diario_ult_meses (
     p_cia       CHAR,
     p_f_hasta   DATE,
     p_no_emple  CHAR,
     p_f_ingreso DATE,
     p_ano       NUMBER,
     p_mes       NUMBER,
     p_grupoing  CHAR,
     p_diasxmes  NUMBER
   )RETURN NUMBER;
 -- Obtiene la cantidad de ausencias
   FUNCTION Ausencias (
            pno_cia          arplppo.no_cia%type,
            pcod_pla         arplppo.cod_pla%type,
            pno_emple        arplppo.no_emple%type,
            pfecha_desde     DATE,
      pfecha_hasta     DATE,
      pdias_nolab IN OUT arplppo.dias_nolab%type) RETURN NUMBER;
   --
   -- Obtiene el valor para la clase a la que pertenece el empleado
   -- dependiendo de un grupo de clases.
   FUNCTION obtiene_valor_clase(
      pCia          in arplecl.no_cia%type
      ,pGrupo_clase in arplgcl.grupo_clase%type
      ,pNo_emple    in arplecl.no_emple%type
   ) RETURN NUMBER;
   --
   -- Devuelve el valor asociado directamente al empleado, respecto a la clase
   FUNCTION obtiene_valor_emp_clase(
      pCia          in arplecl.no_cia%type
      ,pNo_emple    in arplecl.no_emple%type
      ,pclase_emp   in arplecl.clase_emp%type
   ) RETURN NUMBER;
   -- --
   -- Obtiene el codigo correspondiente a la clase de ingresos variables
   --
   FUNCTION Obtiene_clase_var (
     p_dato IN OUT VARCHAR2,
     msg IN OUT VARCHAR2
   )RETURN BOOLEAN;
   -- --
   -- Obtiene el codigo correspondiente a la clase de ingresos fijos
   --
   FUNCTION Obtiene_clase_fijo (
     p_dato IN OUT VARCHAR2,
     msg IN OUT VARCHAR2
   )RETURN BOOLEAN;
   --
   -- --
   -- Obtiene la cantidad de meses (con fraccion, ej.: 1.5 meses) entre 2 fechas
   --
   FUNCTION obtiene_meses_fraccion (
     p_fecha_ini DATE,
     p_fecha_fin DATE
   )RETURN NUMBER;
   -- --
   -- Obtiene la cantidad de meses entre 2 fechas
   FUNCTION obtiene_meses (
     p_fecha_ini DATE,
     p_fecha_fin DATE
   )RETURN NUMBER;
   --
   FUNCTION Total_Provision_Ultimo_Año (
     p_cia       CHAR,
     p_f_hasta   DATE,
     p_no_emple  CHAR,
     p_no_deduc  CHAR
   )RETURN NUMBER;
   -- Se utiliza para calcular el salario diario para liquidacion de vacaciones
   -- y prestaciones por antiguedad.
   FUNCTION Salario_Diario_Ingresos ( p_cia       Arplhs.no_cia%type
                                     ,p_emple     Arplhs.no_emple%type
                                     ,p_grupo     Arplgie.grupo_ing%type
                                     ,pAno        Arplhs.ano%type
                                     ,pMes        Arplhs.mes%type
                                     ,pDiasMes    Number
                                     ,pTipo_Pla   Arplcp.codpla%type
                             ,pClase_Ing  Varchar2
                             ,pIngreso    DATE
                             ,pHasta      DATE
                                     ) RETURN NUMBER;
   -- --
   -- Devuelve laa descripcion del ultimo error ocurrido
   FUNCTION  ultimo_error RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20017);
   kNum_error      NUMBER := -20017;
   -- ---
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State

/*    -- Verifica si se deben generar cambios x empleado para la CCSS
   FUNCTION genera_movimientos_ccss (pcia VARCHAR2) RETURN BOOLEAN;*/

   FUNCTION existe_cambio_ccss (
     pcia   VARCHAR2,
     pano   NUMBER,
     pmes   NUMBER,
     pemple VARCHAR2,
     ptipo  VARCHAR2
   )
   RETURN BOOLEAN;

   --Suma el tiempo total trabajado de un empleado. Ivan Vega S.
   FUNCTION f_tiempo_laborado_emp(p_no_emple     IN arplme.no_emple%TYPE,
                                  p_no_cia       IN arplme.no_cia%TYPE,
                                  p_tipo_tiempo  IN CHAR DEFAULT NULL,
                                  p_total_aaaa   OUT CHAR,
                                  p_total_mm     OUT CHAR,
                                  p_total_dd     OUT CHAR,
                                  p_fecha_limite IN DATE DEFAULT NULL)
   RETURN CHAR;

   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE ARPLTH.
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_arplth(pa_cia IN CHAR,
                                 pa_no_hora IN CHAR)
   RETURN v_arplth_rg%ROWTYPE;

   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE ARPLME.
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_arplme(pa_cia      IN arplme.no_cia%TYPE,
                                 pa_no_emple IN arplme.no_emple%TYPE)
   RETURN arplme%ROWTYPE;

   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE V_ENTORNO_SISTEMA.
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_entorno_sistema
   RETURN v_entorno_sistema%ROWTYPE;

   /*** Funcion para obtener datos relacionados al SRI RDEP
        Antonio Navarrete 27/07/2010****/

   FUNCTION montos_sri (Pv_cia       IN  Varchar2,
                        Pv_emple     IN  Varchar2,
                        Pn_ano       IN  Number,
                        Pn_mes_ini   IN  Number,
                        Pn_mes_fin   IN  Number,
                        Pv_parametro IN  Varchar2) RETURN NUMBER;


   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE ARPLPAR.
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_arplpar(pa_cia  IN arplsec.no_cia%TYPE)
   RETURN arplpar%ROWTYPE;

   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE ARPLCP
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_arplcp(pa_cia     IN arplcp.no_cia%TYPE,
                                 pa_cod_pla IN arplcp.codpla%TYPE)
   RETURN arplcp%ROWTYPE;
   --

 --Covierte a letras las fechas. Iván Vega S.
  FUNCTION f_fecha_letras(p_fecha    IN DATE,
                          p_lenguaje IN NUMBER DEFAULT NULL) RETURN CHAR;

   -- Devuelve el total de ingresos. Sumatoria ARPLPPI
   FUNCTION f_total_ingresos(
                 pno_cia     in arplppi.no_cia%type
                ,pno_emple   in arplppi.no_emple%type
                ,pcod_pla    in arplppi.cod_pla%type
                ,ptipo_suma  in NUMBER DEFAULT NULL ) RETURN NUMBER;

   --- Devuelve dia de accciones de personal
   --- maternidad, vacaciones, faltas injustificadas, entre otras ANR 10/06/2010

   FUNCTION DIAS_ACCIONES   (pv_cia   in Varchar2,
                             pv_pla   in Varchar2,
                             pv_emple in Varchar2,
                             pn_anio  in Number,
                             pn_mes   in Number,
                             pv_tipo  in Varchar2) return Number;
                             
   FUNCTION Solo_Pago_Liquidacion(Pno_Cia IN VARCHAR2) RETURN VARCHAR2;                             

END PLLIB;
/


CREATE OR REPLACE PACKAGE BODY            PLLIB IS
/*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   * monto_grupo_ing_ant
   */
   -- ---
   -- TIPOS
   --
   TYPE param_cia_r IS RECORD(no_cia            arplmc.no_cia%type,
                              sal_min_nacional  arplmc.salario_min%type);
   --
   -- ----
   -- VARIABLES GLOBALES
   --
   gdummy            varchar2(2);
   rCia              param_cia_r;
   --
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
      vMensaje_error := 'PLLIB: '|| msj_error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   -- --
   PROCEDURE carga_datos_cia(pCia varchar2) IS
     CURSOR c_cia IS
       SELECT no_cia, salario_min
       FROM arplmc
       WHERE no_cia = pCia;
   BEGIN
     if nvl(rCia.no_cia,'*NULO*') != pCia then
        open c_cia;
        fetch c_cia into rCia.no_cia, rCia.sal_min_nacional;
        close c_cia;
     end if;
   END carga_datos_cia;
   --
   --
-- ****************
-- Obtiene la cantidad (con fraccion, ej.: 1.5 meses) de meses entre 2 fechas
--
   FUNCTION obtiene_meses_fraccion (
     p_fecha_ini DATE,
     p_fecha_fin DATE
   )RETURN NUMBER
   IS
     v_meses NUMBER(6,2);
   BEGIN
     v_meses := months_between(p_fecha_fin,p_fecha_ini);
     RETURN v_meses;
   END;
   --
-- ****************
-- Obtiene la cantidad de meses entre 2 fechas
--
   FUNCTION obtiene_meses (
     p_fecha_ini DATE,
     p_fecha_fin DATE
   )RETURN NUMBER
   IS
     v_meses NUMBER(4);
   BEGIN
     v_meses := TRUNC(months_between(p_fecha_fin,p_fecha_ini));
     RETURN v_meses;
   END;
   /*******[ PARTE: PUBLICA ]
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   FUNCTION ultimo_error
     RETURN VARCHAR2 IS
   BEGIN
      RETURN(vMensaje_error);
   END ultimo_error;
   --
   --
   FUNCTION existe_empleado_clase(
      pCia        in arplecl.no_cia%type
      ,pno_emple  in arplecl.no_emple%type
      ,pclase_emp in arplecl.clase_emp%type
   ) RETURN BOOLEAN
   IS
      vFound    BOOLEAN;
      CURSOR c_existe_clase IS
        SELECT 'X'
        FROM arplecl
        WHERE no_cia     = pCia
          AND no_emple   = pno_emple
          AND clase_emp  = pclase_emp;
   BEGIN
      OPEN c_existe_clase;
      FETCH c_existe_clase into gdummy;
      vfound := c_existe_clase%FOUND;
      CLOSE c_existe_clase;
      return (vFound);
   END;
   -- Devuelve la cantidad de dias por planilla
   FUNCTION dias_x_pla (
     pno_cia  arplcp.no_cia%type
    ,pcod_pla arplcp.codpla%type
   ) RETURN NUMBER
   IS
     vdiasxpla arplte.dias_trab%type;
     CURSOR c_pla IS
       SELECT DECODE(p.tipla, 'S',  ROUND(t.dias_trab/4.3,0),
                              'B',  ROUND(t.dias_trab/2.1,0),
                              'Q',  ROUND(t.dias_trab/2,0),
                              'M',  t.dias_trab,
                              '2M', ROUND(t.dias_trab*2,0),
                              '3M', ROUND(t.dias_trab*3,0),
                              '6M', ROUND(t.dias_trab*6,0),
                              'A',  ROUND(t.dias_trab*12,0)) DiasxPla
       FROM ARPLCP P,ARPLTE T
       WHERE P.NO_CIA   = pno_cia
         AND P.CODPLA   = pcod_pla
         AND P.NO_CIA   = T.NO_CIA (+)
         AND P.TIPO_EMP = T.TIPO_EMP (+);
   BEGIN
     OPEN c_pla;
     FETCH c_pla INTO vdiasxpla;
     IF c_pla%NOTFOUND THEN
       CLOSE c_pla;
       genera_error('ERROR: El codigo de planilla es incorrecto');
     END IF;
     CLOSE c_pla;
     RETURN vdiasxpla;
   END;
   --
   FUNCTION CUENTA_DIAS (
            Fecha1  Date,
            Fecha2 Date,
      DIA    Varchar2)
     RETURN Number IS
     vDIA          varchar2(20);
     Fecha_Actual  DATE;
     Contador      NUMBER;
   BEGIN
     Contador     := 0;
     Fecha_Actual := Fecha1-1;
     vdia         := UPPER(dia);
     if to_char(TO_DATE('04011999','DDMMYYYY'),'DAY') != 'LUNES' then
      if vDia = 'LUNES' then
         vDia := 'MONDAY';
    elsif vDia = 'MARTES' then
         vDia := 'TUESDAY';
    elsif vDia = 'MIERCOLES' then
         vDia := 'WEDNESDAY';
    elsif vDia = 'JUEVES' then
         vDia := 'THURSDAY';
    elsif vDia = 'VIERNES' then
         vDia := 'FRIDAY';
    elsif vDia = 'SABADO' then
         vDia := 'SATURDAY';
    elsif vDia = 'DOMINGO' then
         vDia := 'SUNDAY';
    end if;
     end if;
     Fecha_Actual := Next_Day(Fecha_Actual, vDia );
     WHILE TRUNC(Fecha_Actual) <= TRUNC(Fecha2) LOOP
        Contador     := NVL(Contador,0) + 1;
        Fecha_Actual := Fecha_Actual + 7;
     END LOOP;
     RETURN(Contador);
   END;
   --
   -- Cuenta la cantidad de dias feriados que hay entre dos fechas
   FUNCTION CUENTA_FERIADOS (pno_cia arpldf.no_cia%type,
                             Fecha1  Date,
                             Fecha2  Date) RETURN Number IS
     vDIA          varchar2(20);
     Fecha_Actual  DATE;
     Contador      NUMBER;
     --
     CURSOR c_dias_fer IS
       SELECT COUNT(*)
         FROM arpldf
        WHERE no_cia = pno_cia
          AND tipo   = 'F'
          AND fecha  between fecha1 and fecha2;
   BEGIN
     OPEN c_dias_fer;
     FETCH c_dias_fer INTO contador;
     CLOSE c_dias_fer;
     RETURN nvl(Contador,0);
   END;
   --
   -- Obtiene la cantidad de ausencias
   FUNCTION Ausencias (
            pno_cia          arplppo.no_cia%type,
            pcod_pla         arplppo.cod_pla%type,
            pno_emple        arplppo.no_emple%type,
            pfecha_desde     DATE,
            pfecha_hasta     DATE,
        pdias_nolab IN OUT arplppo.dias_nolab%type)
     RETURN NUMBER
   IS
     vdomingos  NUMBER;
     vferiados  NUMBER;
     vausencias NUMBER;
   BEGIN
     vdomingos  := CUENTA_DIAS (pfecha_desde, pfecha_hasta, 'DOMINGO');
     vferiados  := CUENTA_FERIADOS (pno_cia, pfecha_desde, pfecha_hasta);
     vausencias := pdias_nolab - vdomingos - vferiados;
     RETURN vausencias;
   END;
   --
   -- Obtiene el valor asociado a la clase, dependiendo del grupo al
   -- que pertenece
   FUNCTION obtiene_valor_clase(
      pCia          in arplecl.no_cia%type
      ,pGrupo_clase in arplgcl.grupo_clase%type
      ,pNo_emple    in arplecl.no_emple%type
   ) RETURN NUMBER
   IS
      vValor    arplcl.valor%type;
      CURSOR c_valor_clase IS
        SELECT c.valor
        FROM arplgcl g, arplcl c, arplecl e
        WHERE g.grupo_clase = pGrupo_clase
          AND g.grupo_clase = c.grupo_clase
          AND e.no_cia      = pCia
          AND c.clase_emp   = e.clase_emp
          AND e.no_emple    = pNo_emple;
   BEGIN
      OPEN c_valor_clase;
      FETCH c_valor_clase into vValor;
      CLOSE c_valor_clase;
      return (vValor);
   END;
   --
   -- Obtiene el valor asociado al empleado con la clase
   FUNCTION obtiene_valor_emp_clase(
      pCia          in arplecl.no_cia%type
      ,pNo_emple    in arplecl.no_emple%type
      ,pclase_emp   in arplecl.clase_emp%type
   ) RETURN NUMBER
   IS
      vValor    arplcl.valor%type;
      CURSOR c_valor_clase IS
        SELECT nvl(e.valor, c.valor)
        FROM arplecl e, arplcl c
        WHERE e.no_cia      = pCia
          AND e.no_emple    = pNo_emple
          AND e.clase_emp   = pclase_emp
          AND e.clase_emp   = c.clase_emp;
   BEGIN
      OPEN c_valor_clase;
      FETCH c_valor_clase into vValor;
      CLOSE c_valor_clase;
      return (vValor);
   END;  -- Obtiene_valor_emp_clase
   --
   -- --
   -- Obtiene el codigo correspondiente a la clase de ingresos variables
   --
   FUNCTION Obtiene_clase_var (
     p_dato IN OUT VARCHAR2,
     msg IN OUT VARCHAR2
   )RETURN BOOLEAN
   IS
   BEGIN
     IF NOT pllib.trae_parametro('PCLV', p_dato) THEN
       msg := 'No se ha encontrado el parametro para la clase de empleados con ingresos variables';
       RETURN FALSE;
     END IF;
     RETURN TRUE;
   END;
   --
   -- --
   -- Obtiene el codigo correspondiente a la clase de ingresos variables
   --
   FUNCTION Obtiene_clase_fijo (
     p_dato IN OUT VARCHAR2,
     msg IN OUT VARCHAR2
   )RETURN BOOLEAN
   IS
   BEGIN
     IF NOT pllib.trae_parametro('PCLF', p_dato) THEN
       msg := 'No se ha encontrado el parametro para la clase de empleados con ingresos fijos';
       RETURN FALSE;
     END IF;
     RETURN TRUE;
   END;
   --
   --
   FUNCTION ing_formulaid(
     pno_cia       in varchar2
     ,pcod_pla     in varchar2
     ,pno_emple    in varchar2
     ,pformula_id  in varchar2
     ,ptipo_dato   in varchar2   -- C=Cantidad, M=monto, %=Porcentaje
     ,paplica_a    in varchar2 default null
   ) RETURN NUMBER
   IS
     vmonto    number;
     CURSOR c_ing_formulaid IS
       SELECT SUM( DECODE(ptipo_dato, 'C', nvl(i.cantidad,0),
                                      'M', nvl(i.monto,0),
                                      '%', nvl(i.tasa,0), 0) )
       FROM arplppi i
       WHERE i.no_cia     = pno_cia
         AND i.cod_pla    = pcod_pla
         AND i.no_emple   = pno_emple
         AND i.no_ingre   IN (SELECT no_ingre FROM arplmi
                              WHERE no_cia      = pno_cia
                                AND formula_id  = pformula_id
                                AND (paplica_a  IS NULL OR aplica_a = pAplica_a));
   BEGIN
     OPEN c_ing_formulaid;
     FETCH c_ing_formulaid INTO vmonto;
     CLOSE c_ing_formulaid;
     RETURN (vmonto);
   END; -- ing_formulaid
   --
   -- --
   FUNCTION ded_formulaid(
     pno_cia       in varchar2
     ,pcod_pla     in varchar2
     ,pno_emple    in varchar2
     ,pformula_id  in varchar2
     ,ptipo_dato   in varchar2   -- M=monto, %=Porcentaje, I=total imponible
     ,paplica_a    in varchar2 default null
   ) RETURN NUMBER
   IS
     vmonto    number;
     CURSOR c_ded_formulaid IS
       SELECT SUM( DECODE(ptipo_dato, 'M', nvl(d.monto,0),
                                      '%', nvl(d.tasa,0),
                                      'I', nvl(d.total,0), 0) )
       FROM arplppd d
       WHERE d.no_cia   = pno_cia
         AND d.cod_pla  = pcod_pla
         AND d.no_emple = pno_emple
         AND d.estatus  = 'A'
         AND d.no_dedu  IN (SELECT no_dedu FROM arplmd
                            WHERE no_cia     = pno_cia
                              AND formula_id = pformula_id
                              AND (paplica_a  IS NULL OR aplica_a = pAplica_a));
   BEGIN
     OPEN c_ded_formulaid;
     FETCH c_ded_formulaid INTO vmonto;
     CLOSE c_ded_formulaid;
     RETURN (vmonto);
   END; -- ded_formulaid
   --
   --
   FUNCTION monto_grupo_ing_pp(
    pno_cia      in arplppi.no_cia%type
    ,pno_emple   in arplppi.no_emple%type
    ,pgrupo_ing  in arplgid.grupo_ing%type
    ,pcod_pla    in arplppi.cod_pla%type
   ) RETURN NUMBER
   IS
     vtot_ing  NUMBER;
   CURSOR c_sum_ing IS
    SELECT SUM( NVL(MONTO,0) )
    FROM ARPLPPI
    WHERE no_cia   = pno_cia
      AND cod_pla  = nvl(pcod_pla, cod_pla)
      AND no_emple = pno_emple
      AND no_ingre IN (select no_ingre
                       from arplgid
                       where no_cia    = pno_cia
                         and grupo_ing = pgrupo_ing);
   BEGIN
      OPEN c_sum_ing;
      FETCH c_sum_ing INTO vtot_ing;
      CLOSE c_sum_ing;
      RETURN (vtot_ing);
   END; -- monto_grupo_ing_pp
   --
   --
   -- Devuelve el monto total de un ingreso para la planilla en curso
   FUNCTION monto_ing_pp(
    pno_cia      in arplppi.no_cia%type
    ,pno_emple   in arplppi.no_emple%type
    ,pno_ingre   in arplppi.no_ingre%type
    ,pcod_pla    in arplppi.cod_pla%type
   ) RETURN NUMBER
   IS
     vtot_ing  NUMBER;
     CURSOR c_sum_ing IS
       SELECT SUM( NVL(MONTO,0) )
       FROM ARPLPPI
       WHERE no_cia   = pno_cia
         AND cod_pla  = nvl(pcod_pla, cod_pla)
         AND no_emple = pno_emple
         AND no_ingre = pno_ingre;
   BEGIN
     OPEN c_sum_ing;
     FETCH c_sum_ing INTO vtot_ing;
     CLOSE c_sum_ing;
     RETURN (NVL(vtot_ing,0));
   END; -- monto_ing_pp
   --
   -- Devuelve el monto total de un concepto para un determinado mes
   FUNCTION monto_h(
    pno_cia      in arplppi.no_cia%type
    ,pano        in arplhs.ano%type
  ,pmes        in arplhs.mes%type
    ,pno_emple   in arplppi.no_emple%type
    ,ptipo_m     in arplhs.tipo_m%type
    ,pcodigo     in arplhs.codigo%type
   ) RETURN NUMBER
   IS
     vtot_ing  NUMBER;
   CURSOR c_sum_ing IS
    SELECT SUM( NVL(MONTO,0) )
    FROM ARPLHS
    WHERE no_cia   = pno_cia
      AND ano      = pano
    AND mes      = pmes
      AND no_emple = pno_emple
      AND tipo_m   = ptipo_m
      AND codigo   = pcodigo;
   BEGIN
    OPEN c_sum_ing;
    FETCH c_sum_ing INTO vtot_ing;
    CLOSE c_sum_ing;
    RETURN (NVL(vtot_ing,0));
   END; -- monto_h
   --
   -- Devuelve la cantidad total de un ingreso para la planilla en curso
   FUNCTION cantidad_ing_pp(
     pno_cia      in arplppi.no_cia%type
     ,pno_emple   in arplppi.no_emple%type
     ,pno_ingre   in arplppi.no_ingre%type
     ,pcod_pla    in arplppi.cod_pla%type
   ) RETURN NUMBER
   IS
     vtotal  NUMBER;
     CURSOR c_sum_ing IS
       SELECT SUM( NVL(CANTIDAD,0) )
       FROM ARPLPPI
       WHERE no_cia   = pno_cia
         AND cod_pla  = nvl(pcod_pla, cod_pla)
         AND no_emple = pno_emple
         AND no_ingre = pno_ingre;
   BEGIN
     OPEN c_sum_ing;
     FETCH c_sum_ing INTO vtotal;
     CLOSE c_sum_ing;
     RETURN (NVL(vtotal,0));
   END; -- cantidad_ing_pp
   --
   -- --
   -- Devuelve el total de ingresos del mes que pertenecen al grupo,
   -- tomando los ingresos de la historia
   FUNCTION monto_grupo_ing_h(
    pno_cia      in arplhs.no_cia%type
    ,pno_emple   in arplhs.no_emple%type
    ,pgrupo_ing  in arplgid.grupo_ing%type
    ,pano        in arplhs.ano%type
    ,pmes        in arplhs.mes%type
   ) RETURN NUMBER
   IS
     vtot_ing  NUMBER;
   CURSOR c_sum_ing IS
       SELECT SUM( NVL(h.monto,0) ) tot_ing
       FROM arplhs h
       WHERE h.no_cia      = pno_cia
         AND h.no_emple    = pno_emple
         AND h.ano         = pano
         AND h.mes         = pmes
         AND h.tipo_m      = 'I'
         AND h.codigo      IN (select no_ingre
                            from arplgid
                            where no_cia    = pno_cia
                              and grupo_ing = pgrupo_ing);
   BEGIN
      OPEN c_sum_ing;
    FETCH c_sum_ing INTO vtot_ing;
    CLOSE c_sum_ing;
    RETURN (vtot_ing);
   END; -- monto_grupo_ing_h
   --
   --
   -- Devuelve el total de ingresos correspondiente a x cantidad de periodos
   -- hacia atras del mes indicado,
   -- tomando los ingresos de la historia hasta un maximo de x cantidad de meses
   FUNCTION monto_grupo_ing_per(
    pno_cia      in arplhs.no_cia%type
    ,pno_emple   in arplhs.no_emple%type
    ,pgrupo_ing  in arplgid.grupo_ing%type
    ,pano        in arplhs.ano%type
    ,pmes        in arplhs.mes%type
    ,pperiodos   in NUMBER
    ,ptotal_dias in NUMBER
  ,pdiasxper   in NUMBER
    ,pmesesatras in NUMBER
   ) RETURN NUMBER
   IS
     vtot_ing  arplhs.monto%type;
     vcant_periodo NUMBER;
     vmonto_ultimo_periodo arplhs.monto%type;
     vcant_dias_ult_per NUMBER;
     vfraccion_ult_per arplhs.monto%type;
     v_fecha_desde DATE;
     v_fecha_hasta DATE;
   CURSOR c_sum_ing IS
       SELECT h.ano,h.mes,h.periodo,NVL(SUM(NVL(h.monto,0)),0) monto
       FROM arplhs h
       WHERE h.no_cia    = pno_cia
         AND h.no_emple  = pno_emple
         AND ano_mes     >= TO_CHAR(v_fecha_desde,'YYYYMM')
         AND ano_mes     <= TO_CHAR(v_fecha_hasta,'YYYYMM')
         AND h.tipo_m      = 'I'
         AND h.codigo      IN (select no_ingre
                               from arplgid
                               where no_cia    = pno_cia
                                 and grupo_ing = pgrupo_ing)
       GROUP BY h.ano ,h.mes ,h.periodo
       ORDER BY h.ano desc,h.mes desc,h.periodo desc;
   BEGIN
     vcant_periodo := 1;
     v_fecha_desde := add_months(to_date('01/'||LTRIM(TO_CHAR(pmes,'00'))||'/'||TO_CHAR(pano),'DD/MM/YYYY'),-pmesesatras);
     v_fecha_hasta := to_date('01/'||LTRIM(TO_CHAR(pmes,'00'))||'/'||TO_CHAR(pano),'DD/MM/YYYY');
     FOR r_sum_ing in c_sum_ing LOOP
       IF vcant_periodo > pperiodos - 1 THEN
         vmonto_ultimo_periodo := r_sum_ing.monto;
         exit;
       END IF;
       vtot_ing := NVL(vtot_ing,0) + NVL(r_sum_ing.monto,0);
       vcant_periodo := vcant_periodo + 1;
     END LOOP;
     -- Determina la cantidad de dias a tomar en cuenta del periodo mas viejo
     vcant_dias_ult_per := ptotal_dias - ((pperiodos - 1) * pdiasxper);
     -- Calcula el promedio diario del periodo mas viejo
     vfraccion_ult_per := (vmonto_ultimo_periodo / pdiasxper) * vcant_dias_ult_per;
   vtot_ing := vtot_ing + vfraccion_ult_per;
     RETURN (vtot_ing);
   END; -- monto_grupo_ing_per
   -- Devuelve el total de ingresos correspondiente a x cantidad de periodos
   -- hacia atras del mes indicado,
   -- tomando los ingresos de la historia hasta un maximo de x cantidad de meses
   FUNCTION monto_grupo_ing_ant(
    pno_cia      in arplhs.no_cia%type
    ,pno_emple   in arplhs.no_emple%type
    ,pgrupo_ing  in arplgid.grupo_ing%type
    ,pano        in arplhs.ano%type
    ,pmes        in arplhs.mes%type
    ,ptotal_dias in NUMBER
    ,pmesesatras in NUMBER
   ) RETURN NUMBER
   IS

     vtot_ing  arplhs.monto%type;
     vtotal_dias NUMBER;
     vmonto_ultimo_periodo arplhs.monto%type;
     vdias_faltan NUMBER;
     vfraccion_ult_per arplhs.monto%type;
     v_fecha_desde DATE;
     v_fecha_hasta DATE;
     vdias_pla arplte.dias_trab%type;
   CURSOR c_sum_ing IS
       SELECT h.cod_pla,h.ano,h.mes,h.periodo,NVL(SUM(NVL(h.monto,0)),0) monto
       FROM arplhs h
       WHERE h.no_cia    = pno_cia
         AND h.no_emple  = pno_emple
         AND ano_mes     >= TO_CHAR(v_fecha_desde,'YYYYMM')
         AND ano_mes     <= TO_CHAR(v_fecha_hasta,'YYYYMM')
         AND h.tipo_m      = 'I'
         AND h.codigo      IN (select no_ingre
                               from arplgid
                               where no_cia    = pno_cia
                                 and grupo_ing = pgrupo_ing)
       GROUP BY h.cod_pla,h.ano,h.mes,periodo
       ORDER BY h.ano desc,h.mes desc, h.periodo desc;
   BEGIN
     vtotal_dias := 0;
     v_fecha_desde := add_months(to_date('01/'||LTRIM(TO_CHAR(pmes,'00'))||'/'||TO_CHAR(pano),'DD/MM/YYYY'),-pmesesatras);
     v_fecha_hasta := to_date('01/'||LTRIM(TO_CHAR(pmes,'00'))||'/'||TO_CHAR(pano),'DD/MM/YYYY');
     FOR r_sum_ing in c_sum_ing LOOP
       -- Obtiene el numero de dias de la planilla
       vdias_pla := dias_x_pla (pno_cia,
                                r_sum_ing.cod_pla);
       vtotal_dias := vtotal_dias + vdias_pla;
       IF vtotal_dias >= ptotal_dias THEN
         vmonto_ultimo_periodo := r_sum_ing.monto;
         -- Determina la cantidad de dias a tomar en cuenta del periodo mas viejo
         vdias_faltan := ptotal_dias - (vtotal_dias - vdias_pla);
         exit;
       ELSE
         vtot_ing := NVL(vtot_ing,0) + NVL(r_sum_ing.monto,0);
       END IF;
     END LOOP;
     -- Calcula el promedio diario del periodo mas viejo
     vfraccion_ult_per := (vmonto_ultimo_periodo / vdias_pla) * vdias_faltan;
     vtot_ing := vtot_ing + nvl(vfraccion_ult_per,0);
     RETURN (vtot_ing);
   END; -- monto_grupo_ing_ant
   -- --
   -- Salario diario correspondiente a ingresos fijos para un mes dado diferente al de la planill
   -- en curso.
   --
   FUNCTION sal_diario_fijo_mes (
     p_cia       CHAR,
     p_no_emple  CHAR,
     p_grupo_ing CHAR,
     p_diasxmes  NUMBER,
     p_ano       NUMBER,
     p_mes       NUMBER
   )RETURN NUMBER
   IS
     v_monto_diario arplhs.monto%type;
   BEGIN
     v_monto_diario := monto_grupo_ing_h(p_cia
                                        ,p_no_emple
                                        ,p_grupo_ing
                                        ,p_ano
                                        ,p_mes) / p_diasxmes;
     RETURN v_monto_diario;
   END;
   -- ****************
   -- Salario diario correspondiente a ingresos fijos para el mes de la planilla
   --
   FUNCTION sal_diario_fijo_mes_pla (
     p_cia       CHAR,
     p_cod_pla   CHAR,
     p_no_emple  CHAR,
     p_grupo_ing CHAR,
     p_diasxmes  NUMBER,
     p_ano       NUMBER,
     p_mes       NUMBER
   )RETURN NUMBER
   IS
     v_monto_diario arplhs.monto%type;
   BEGIN
     v_monto_diario := nvl(monto_grupo_ing_pp(p_cia
                                             ,p_no_emple
                                             ,p_grupo_ing
                                             ,p_cod_pla),0) / p_diasxmes;
     v_monto_diario := v_monto_diario + (nvl(monto_grupo_ing_h(p_cia
                                                              ,p_no_emple
                                                              ,p_grupo_ing
                                                              ,p_ano
                                                              ,p_mes),0) / p_diasxmes);
     RETURN v_monto_diario;
   END;
   --
   -- --
   -- Salario diario correspondiente a ingresos variables
   --
   FUNCTION sal_diario_var (
     p_cia         VARCHAR2,
     p_cod_pla     VARCHAR2,
     p_f_hasta     DATE,
     p_no_emple    VARCHAR2,
     p_f_ingreso   DATE,
     p_ano         NUMBER,
     p_mes         NUMBER,
     p_grupoing    VARCHAR2,
     p_divisor     NUMBER    -- 1 = Mensual
   )RETURN NUMBER
   IS
     v_fecha_desde    date;
     v_fecha_hasta    date;
     v_monto_diario   arplhs.monto%type;
     v_salario_mes    arplhs.monto%type;
     v_meses          number(6,2);
     v_meses_entre    number(4);
   v_acum           number;
   --
   CURSOR c_sum_hs IS
         SELECT SUM(NVL(monto,0)) tot_ing
         FROM arplhs hs
         WHERE hs.no_cia    = p_cia
           AND hs.no_emple  = p_no_emple
           AND hs.ano_mes   >= TO_CHAR(v_fecha_desde,'YYYYMM')
       AND hs.ano_mes   <  TO_CHAR(v_fecha_hasta,'YYYYMM')
           AND hs.tipo_m    = 'I'
           AND hs.codigo    IN (select no_ingre
                                from arplgid
                                where no_cia    = p_cia
                                  and grupo_ing = p_grupoing);
   BEGIN
     -- Obtiene la cantidad de meses que tiene el empleado de trabajar en la empresa
     v_meses := Obtiene_meses_fraccion(p_f_ingreso,p_f_hasta);
     IF v_meses > 1 AND v_meses <= 6 THEN
        v_fecha_desde := add_months(to_date('01/'||LTRIM(TO_CHAR(p_mes,'00'))||'/'||TO_CHAR(p_ano),'DD/MM/YYYY'),-1);
        v_fecha_hasta := to_date('01/'||LTRIM(TO_CHAR(p_mes,'00'))||'/'||TO_CHAR(p_ano),'DD/MM/YYYY');
     ELSIF v_meses > 6 AND v_meses < 12 THEN
        v_fecha_desde := p_f_ingreso;
        v_fecha_hasta := add_months(p_f_ingreso,6);
     ELSIF v_meses >= 12 THEN
        v_fecha_desde := add_months(to_date('01/'||LTRIM(TO_CHAR(p_mes,'00'))||'/'||TO_CHAR(p_ano),'DD/MM/YYYY'),-12);
        v_fecha_hasta := to_date('01/'||LTRIM(TO_CHAR(p_mes,'00'))||'/'||TO_CHAR(p_ano),'DD/MM/YYYY');
     END IF;
     --
     -- En caso de que tenga mas de un mes de laborar en la empresa
     IF v_meses > 1 THEN
       v_meses_entre := months_between(v_fecha_hasta,v_fecha_desde);
       /* Selecciona el promedio del salario mensual*/
     v_acum      := 0;
     OPEN c_sum_hs;
     FETCH c_sum_hs INTO v_acum;
     CLOSE c_sum_hs;
     if v_meses_entre > 0 then
        v_salario_mes := v_acum / v_meses_entre;
     end if;
     ELSE
       v_salario_mes := NVL(rCia.sal_min_nacional,0);
     END IF;
     v_monto_diario := v_salario_mes / nvl(p_divisor,1);
     RETURN v_monto_diario;
   END;
   -- Nuevo: Salario diario correspondiente a ingresos variables OJO: PROBARLO EN MINCO
   --
   FUNCTION nuevo_sal_diario_var (
     p_cia         VARCHAR2,
     pDiasMes      NUMBER,
     pTipo_Pla     Arplcp.codpla%type,
     p_f_hasta     DATE,
     p_no_emple    VARCHAR2,
     p_f_ingreso   DATE,
     p_ano         NUMBER,
     p_mes         NUMBER,
     p_grupo       VARCHAR2
   )RETURN NUMBER
   IS
     v_monto_diario   arplhs.monto%type;
   v_mes            number(2);
   v_ano            number(4);
     vdias            number(4);
     v_meses          number(6,2);
     vfecha_ref       date;
     vfecha_atras     date;
   --
   BEGIN
     v_mes := p_mes;
     v_ano := p_ano;
     v_meses := Obtiene_meses_fraccion(p_f_ingreso,p_f_hasta);
     IF v_meses > 1 AND v_meses <= 6 THEN
       -- 1 mes hacia atras
       vDias := pDiasMes;
     ELSIF v_meses > 6 AND v_meses < 12 THEN
       -- Restar 6 meses a p_mes
       vfecha_ref := to_date('01/' || ltrim(to_char(p_mes,'00')) || '/' || ltrim(to_char(p_ano,'0000')));
       vfecha_atras := add_months(p_f_ingreso,6);
       -- 6 meses hacia atras
       v_mes := to_char(vfecha_atras,'MM');
       v_ano := to_char(vfecha_atras,'YYYY');
       vDias := pDiasMes * 6;
     ELSIF v_meses >= 12 THEN
       IF ptipo_pla = 'S' THEN
         -- 52 semanas hacia atras, i.e. 52 * 7 dias monto_ded_pp
         vDias := 364;
       ELSE
         -- 1 a?o, considerando meses de 30 dias
         vDias := 360;
     END IF;
     END IF;
     --
     -- En caso de que tenga mas de un mes de laborar en la empresa
     IF v_meses > 1 THEN
       /* Selecciona el promedio del salario mensual*/
       v_monto_diario:= nvl(pllib.monto_grupo_ing_ant(p_cia
                                                     ,p_no_emple
                                                     ,p_grupo
                                                     ,p_ano
                                                     ,p_mes
                                                     ,vDias
                                               ,24),0) / vDias;
     ELSE
       v_monto_diario := NVL(rCia.sal_min_nacional,0) / 30;
     END IF;
     RETURN v_monto_diario;
   END;
-- ****************
-- Salario diario correspondiente a ingresos de un grupo en los ultimos x meses
--
   FUNCTION sal_diario_ult_meses (
     p_cia       CHAR,
     p_f_hasta   DATE,
     p_no_emple  CHAR,
     p_f_ingreso DATE,
     p_ano       NUMBER,
     p_mes       NUMBER,
     p_grupoing  CHAR,
     p_diasxmes  NUMBER
   )RETURN NUMBER
   IS
     v_fecha_desde DATE;
     v_fecha_hasta DATE;
     v_monto_diario arplhs.monto%type;
     v_salario_mes arplhs.monto%type;
     v_meses_trab number(6,2);
     v_frac_meses_trab number(6,2);
     v_meses_entre number(6,2);
     v_dia_ingreso number(2);
   BEGIN
     v_fecha_desde := add_months(to_date('01/'||LTRIM(TO_CHAR(p_mes,'00'))||'/'||TO_CHAR(p_ano),'DD/MM/YYYY'),-12);
     v_fecha_hasta := to_date('01/'||LTRIM(TO_CHAR(p_mes,'00'))||'/'||TO_CHAR(p_ano),'DD/MM/YYYY');
     v_meses_trab  := Obtiene_meses_fraccion(p_f_ingreso,add_months(p_f_hasta,-1));
     v_meses_entre := LEAST(v_meses_trab,12);
     /* Selecciona el promedio del salario mensual*/
     BEGIN
       SELECT SUM(NVL(monto,0))/v_meses_entre
       INTO v_salario_mes
       FROM arplhs hs
       WHERE hs.no_cia    = p_cia
         AND hs.tipo_m    = 'I'
         AND hs.no_emple  = p_no_emple
         AND hs.codigo     IN (select no_ingre
                               from arplgid
                               where no_cia    = p_cia
                               and grupo_ing = p_grupoing)
         AND TO_DATE('01/' || LTRIM(TO_CHAR(mes,'00'))||'/'||TO_CHAR(ano),'DD/MM/YYYY') >= v_fecha_desde
         AND TO_DATE('01/' || LTRIM(TO_CHAR(mes,'00'))||'/'||TO_CHAR(ano),'DD/MM/YYYY') <= v_fecha_hasta;
     END;
     v_monto_diario := v_salario_mes / p_diasxmes;
     RETURN v_monto_diario;
   END;
   --
   FUNCTION trae_parametro(
      pparam_id   IN VARCHAR2
     ,pdato       IN OUT NUMBER
   ) RETURN BOOLEAN
   IS
     vfound       boolean;
     vtipo_dato   arplpgd.tipo_dato%type;
     vdato        arplpgd.dato_numerico%type;
     CURSOR c_param IS
        SELECT tipo_dato, dato_numerico
        FROM arplpgd
        WHERE parametro_id = pparam_id;
   BEGIN
     OPEN c_param;
     FETCH c_param INTO vtipo_dato, vdato;
     vfound := c_param%found;
     CLOSE c_param;
     pdato  := vdato;
     RETURN (vfound);
   END;
   --
   --
   FUNCTION trae_parametro(
      pparam_id   IN VARCHAR2
     ,pdato       IN OUT VARCHAR2
   ) RETURN BOOLEAN
   IS
     vfound       boolean;
     vtipo_dato   arplpgd.tipo_dato%type;
     vdato        arplpgd.dato_caracter%type;
     CURSOR c_param IS
        SELECT tipo_dato, dato_caracter
        FROM arplpgd
        WHERE parametro_id = pparam_id;
   BEGIN
     OPEN c_param;
     FETCH c_param INTO vtipo_dato, vdato;
     vfound := c_param%found;
     CLOSE c_param;
     pdato  := vdato;
     RETURN (vfound);
   END;
   --
   --
   FUNCTION trae_parametro(
      pparam_id   IN VARCHAR2
     ,pdato       IN OUT DATE
   ) RETURN BOOLEAN
   IS
     vfound       boolean;
     vtipo_dato   arplpgd.tipo_dato%type;
     vdato        arplpgd.dato_date%type;
     CURSOR c_param IS
        SELECT tipo_dato, dato_date
        FROM arplpgd
        WHERE parametro_id = pparam_id;
   BEGIN
     OPEN c_param;
     FETCH c_param INTO vtipo_dato, vdato;
     vfound := c_param%found;
     CLOSE c_param;
     pdato  := vdato;
     RETURN (vfound);
   END;
   --
   /* Verifica si la planilla es la ultima del mes o no   */
   FUNCTION es_ultima_planilla (
     pcia VARCHAR2,
     pcod_pla VARCHAR2
   )
   RETURN BOOLEAN
   IS
     vultima_planilla arplcp.ultima_planilla%type;
   BEGIN
     BEGIN
       SELECT ultima_planilla
       INTO vultima_planilla
       FROM arplcp
       WHERE no_cia  = pcia
         AND codpla = pcod_pla;
       IF vultima_planilla = 'S' THEN
         RETURN TRUE;
       ELSE
         RETURN FALSE;
       END IF;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         genera_error('No se ha defindo el codigo de planilla ' || pcod_pla);
     END;
   END;
   --
   FUNCTION Total_Provision_Ultimo_Año (
     p_cia       CHAR,
     p_f_hasta   DATE,
     p_no_emple  CHAR,
     p_no_deduc  CHAR
   )RETURN NUMBER
   IS
     v_fecha_desde           DATE;
     v_fecha_hasta           DATE;
     vFecha_Ref              DATE;
     vTotal_Provision        NUMBER;
     Cursor c_Provision IS
       SELECT SUM(NVL(monto,0))
       FROM arplhs hs
       WHERE hs.no_cia    = p_cia
         AND hs.tipo_m    = 'D'
         AND hs.no_emple  = p_no_emple
         AND hs.codigo    = p_no_Deduc
         AND TO_DATE('01/' || LTRIM(TO_CHAR(mes,'00'))||'/'||TO_CHAR(ano),'DD/MM/YYYY')
             BETWEEN v_fecha_desde AND v_fecha_hasta;
   BEGIN
     /*  Si se ejecuta el proceso para el 31/12/1999, se deben contemplar las provisiones
         entre el 1/12/1998 al 30/11/1999                                       */
     vFecha_Ref    := Last_Day(p_f_hasta);
     v_fecha_desde := add_months(vFecha_Ref, -13)+1;
     v_fecha_hasta := add_months(vFecha_Ref, -1);
     Open  c_Provision;
     Fetch c_Provision INTO vTotal_Provision;
     Close c_Provision;
     RETURN vTotal_Provision;
   END;
   -- Se utiliza para calcular el salario diario para liquidacion de vacaciones
   -- y prestaciones por antiguedad.
   FUNCTION Salario_Diario_Ingresos ( p_cia       Arplhs.no_cia%type
                                     ,p_emple     Arplhs.no_emple%type
                                     ,p_grupo     Arplgie.grupo_ing%type
                                     ,pAno        Arplhs.ano%type
                                     ,pMes        Arplhs.mes%type
                                     ,pDiasMes    Number
                                     ,pTipo_Pla   Arplcp.codpla%type
                             ,pClase_Ing  Varchar2
                             ,pIngreso    DATE
                             ,pHasta      DATE
                                     ) RETURN NUMBER
   IS
   /*   Calcula el salario diario para empleados con ingresos fijos
        diferenciando entre planillas semanales y otras planillas   */
   vMonto    Number;
   vDias     NUMBER;
   vCantPer  NUMBER;
   vDiasXPer NUMBER;
   BEGIN
      IF pTipo_Pla = 'S' THEN
        vDiasxPer := 7;
        IF pClase_Ing = 'F' THEN
           vDias    := pDiasMes;
       vCantPer := 5;
        ELSIF pClase_Ing = 'V' THEN
      /*  En caso de empleados variables (obreros) tomo en cuenta
          los salarios del ultimo a?o (ultimas 52 semanas) y se
        toman 364 dias para calcular el salario diario          */
           vDias    := 364;
       vCantPer := 52;
    ELSE
           genera_error('No se ha definido la clase de ingresos a la que pertenece el empleado '|| p_emple);
        END IF;
      ELSIF pTipo_Pla = 'M' THEN
        vDiasxPer := 30;
        IF pClase_Ing = 'F' THEN
           vDias    := pDiasMes;
       vCantPer := 1;
        ELSIF pClase_Ing = 'V' THEN
           vDias    := 360;
       vCantPer := 12;
        ELSE
           genera_error('No se ha definido la clase de ingresos a la que pertenece el empleado '|| p_emple);
        END IF;
      ELSIF pTipo_Pla = 'Q' THEN
        vDiasxPer := 15;
        IF pClase_Ing = 'F' THEN
           vDias    := pDiasMes;
       vCantPer := 2;
        ELSIF pClase_Ing = 'V' THEN
           vDias    := 360;
       vCantPer := 24;
        ELSE
           genera_error('No se ha definido la clase de ingresos a la que pertenece el empleado '|| p_emple);
        END IF;
      END IF;
      vMonto := nvl(pllib.monto_grupo_ing_ant(p_cia
                                             ,p_emple
                                             ,p_grupo
                                             ,pano
                                             ,pmes
                                             ,vDias
                                   ,24),0) / vDias;
      Return(vMonto);
   END;

/*     -- Verifica si se deben generar cambios x empleado para la CCSS
   FUNCTION genera_movimientos_ccss (pcia VARCHAR2) RETURN BOOLEAN
   IS
     cursor ccambios is
       select nvl(cambios_ccss,'N')
       from arplpar
       where no_cia = pcia;
     vgenera  varchar2(1) := 'N';
   BEGIN
      open ccambios;
      fetch ccambios into vgenera;
      close ccambios;
      if nvl(vgenera,'N') = 'S' then
        return TRUE;
      else
        return FALSE;
      end if;
   END;*/


   FUNCTION existe_cambio_ccss (
     pcia   VARCHAR2,
     pano   NUMBER,
     pmes   NUMBER,
     pemple VARCHAR2,
     ptipo  VARCHAR2
   )
   RETURN BOOLEAN
   IS
    CURSOR cexiste IS
      select 'x'
      from arplce
      where no_cia   = pcia
        and ano      = pano
        and mes      = pmes
        and no_emple = pemple
        and tipo_cambio = ptipo
        and nvl(borrado,'N')= 'N';
     vdummy  varchar2(1);
     vexiste boolean;
   BEGIN
      open cexiste;
      fetch cexiste into vdummy;
      vexiste := cexiste%found;
      close cexiste;
     return(vexiste);
   END;

   FUNCTION f_tiempo_laborado_emp(p_no_emple     IN arplme.no_emple%TYPE,
                                  p_no_cia       IN arplme.no_cia%TYPE,
                                  p_tipo_tiempo  IN CHAR DEFAULT NULL,
                                  p_total_aaaa   OUT CHAR,
                                  p_total_mm     OUT CHAR,
                                  p_total_dd     OUT CHAR,
                                  p_fecha_limite IN DATE DEFAULT NULL)
   RETURN CHAR
   IS
      CURSOR c_ingresos_emp IS
         SELECT    *
         FROM      pl_his_ingresos_empleado a
         WHERE     a.no_cia = p_no_cia
         AND       a.no_emple = p_no_emple
         and       tipo_emp in (select tipo_emp from arplte where no_cia=p_no_cia and es_trabajador='S');

      CURSOR c_ingresos_emp_last IS
         SELECT    *
         FROM      pl_his_ingresos_empleado a
         WHERE     a.no_cia = p_no_cia
         AND       a.no_emple = p_no_emple
         AND       a.f_egreso IS NULL
         and tipo_emp in (select tipo_emp from arplte where no_cia=p_no_cia and es_trabajador='S');

      v_aa_nr NUMBER(10);
      v_mm_nr NUMBER(10);
      v_dd_nr NUMBER(10);

      v_tot_aa_nr NUMBER(10);
      v_tot_mm_nr NUMBER(10);
      v_tot_dd_nr NUMBER(10);

      v_desc_tiempo_tx VARCHAR2(100);

      v_fecha_ini_dt DATE;
      v_fecha_fin_dt DATE;
   BEGIN
      IF p_tipo_tiempo = 'T' THEN
         FOR d IN c_ingresos_emp LOOP
            v_fecha_ini_dt := d.f_ingreso;
            IF d.f_egreso IS NULL THEN
               IF p_fecha_limite IS NULL THEN
                  v_fecha_fin_dt := TRUNC(SYSDATE);
               ELSE
                  v_fecha_fin_dt := p_fecha_limite;
               END IF;
            ELSE
               v_fecha_fin_dt := d.f_egreso;
            END IF;
            v_desc_tiempo_tx := dif_fecha(v_fecha_ini_dt,
                                          v_fecha_fin_dt,
                                          v_aa_nr,
                                          v_mm_nr,
                                          v_dd_nr);
            v_tot_aa_nr := NVL(v_tot_aa_nr,0) + NVL(v_aa_nr,0);
            v_tot_mm_nr := NVL(v_tot_mm_nr,0) + NVL(v_mm_nr,0);
            v_tot_dd_nr := NVL(v_tot_dd_nr,0) + NVL(v_dd_nr,0);
         END LOOP;
      END IF;
      IF p_tipo_tiempo = 'U' THEN
         FOR d IN c_ingresos_emp_last LOOP
            v_fecha_ini_dt := d.f_ingreso;
            IF p_fecha_limite IS NULL THEN
               v_fecha_fin_dt := TRUNC(SYSDATE);
            ELSE
               v_fecha_fin_dt := p_fecha_limite;
            END IF;
            --v_fecha_fin_dt := TRUNC(SYSDATE);
            v_desc_tiempo_tx := dif_fecha(v_fecha_ini_dt,
                                          v_fecha_fin_dt,
                                          v_tot_aa_nr,
                                          v_tot_mm_nr,
                                          v_tot_dd_nr);
         END LOOP;
      END IF;

      IF v_tot_dd_nr >= 30 THEN
         v_tot_mm_nr := v_tot_mm_nr + TRUNC((v_tot_dd_nr / 30));
         v_tot_dd_nr := v_tot_dd_nr - (TRUNC((v_tot_dd_nr / 30)) * 30);
      END IF;

      IF v_tot_mm_nr >= 12 THEN
         v_tot_aa_nr := v_tot_aa_nr + TRUNC((v_tot_mm_nr / 12));
         v_tot_mm_nr := v_tot_mm_nr - (TRUNC((v_tot_mm_nr / 12)) * 12);
      END IF;

      p_total_aaaa := v_tot_aa_nr;
      p_total_mm   := v_tot_mm_nr;
      p_total_dd   := v_tot_dd_nr;

      v_desc_tiempo_tx := v_tot_aa_nr ||' Año(s)'||' '||
                          v_tot_mm_nr ||' Mes(es)'||' '||
                          v_tot_dd_nr ||' Dia(s).';
      RETURN v_desc_tiempo_tx;
   END;


   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE ARPLTH.
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_arplth(pa_cia IN CHAR,
                                 pa_no_hora IN CHAR)
   RETURN v_arplth_rg%ROWTYPE
   IS
   BEGIN
      SELECT    *
      INTO      v_arplth_rg
      FROM      arplth a
      WHERE     a.no_cia = pa_cia
      AND       a.no_hora = pa_no_hora;

      RETURN v_arplth_rg;
   END;

   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE ARPLME.
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_arplme(pa_cia      IN arplme.no_cia%TYPE,
                                 pa_no_emple IN arplme.no_emple%TYPE)
   RETURN arplme%ROWTYPE IS

      v_reg_arplme_rg  arplme%ROWTYPE;
   BEGIN
      SELECT /*+ FIRST_ROWS +*/
             *
      INTO   v_reg_arplme_rg      FROM   arplme a
      WHERE  a.no_emple = pa_no_emple
      AND    a.no_cia = pa_cia;

      RETURN v_reg_arplme_rg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR
            (-20000,'Error al recuperar registro en ARPLME. '||
             SQLCODE||' '||SQLERRM);
   END;

   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE V_ENTORNO_SISTEMA.
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_entorno_sistema
   RETURN v_entorno_sistema%ROWTYPE
   IS
      v_entorno_sistema_rg v_entorno_sistema%ROWTYPE;
   BEGIN
      SELECT    *
      INTO      v_entorno_sistema_rg
      FROM      v_entorno_sistema;

      RETURN v_entorno_sistema_rg;
   END;

   /*** Funcion para obtener datos relacionados al SRI RDEP
        Antonio Navarrete 27/07/2010****/

   FUNCTION montos_sri (Pv_cia       IN  Varchar2,
                        Pv_emple     IN  Varchar2,
                        Pn_ano       IN  Number,
                        Pn_mes_ini   IN  Number,
                        Pn_mes_fin   IN  Number,
                        Pv_parametro IN  Varchar2) RETURN NUMBER IS

/*** Sueldos y salarios, sobresueldos y participación utilidades:
     Corresponden al valor en dólares de ingresos gravados, pagados al empleado
     durante el ejercicio impositivo que informa, por los respectivos conceptos. **/

   Cursor C_Sueldo Is
    select nvl(sum(nvl(monto,0)),0) valor
    from   arplhs
    where  no_cia   = Pv_cia
    and    no_emple = Pv_emple
    and    ano      = Pn_ano
    and    mes between Pn_mes_ini and Pn_mes_fin
    and    tipo_m   = 'I'
    and    codigo in (select cod_h_ord from arplpar where no_cia = Pv_cia)
    and    codigo in --- codigos de ingreso del grupo de ingreso para impuesto a la renta
    (select c.no_ingre
     from   arplpar a, arplmd b, arplgid c
     where  a.no_cia     = Pv_cia
     and    a.no_cia     = b.no_cia
     and    a.cod_impsal = b.no_dedu
     and    b.no_cia     = c.no_cia
     and    b.grupo_ing  = c.grupo_ing);

   --- Corresponde a otros beneficios sin considerar el sueldo, que generan el impuesto a la renta

   Cursor C_Sobresueldo Is
    select nvl(sum(nvl(monto,0)),0) valor
    from   arplhs
    where  no_cia   = Pv_cia
    and    no_emple = Pv_emple
    and    ano      = Pn_ano
    and    mes between Pn_mes_ini and Pn_mes_fin
    and    tipo_m   = 'I'
    and    codigo not in (select cod_h_ord from arplpar where no_cia = Pv_cia)
    and    codigo in --- codigos de ingreso del grupo de ingreso para impuesto a la renta
    (select c.no_ingre
     from   arplpar a, arplmd b, arplgid c
     where  a.no_cia     = Pv_cia
     and    a.no_cia     = b.no_cia
     and    a.cod_impsal = b.no_dedu
     and    b.no_cia     = c.no_cia
     and    b.grupo_ing  = c.grupo_ing);

   --- Decimo cuarto sueldo pagado

   Cursor C_14 Is
    select nvl(sum(nvl(monto,0)),0) valor
    from   arplhs
    where  no_cia   = Pv_cia
    and    no_emple = Pv_emple
    and    ano      = Pn_ano
    and    mes between Pn_mes_ini and Pn_mes_fin
    and    tipo_m   = 'I'
    and    codigo in --- decimo cuarto y retroactivo
    (select a.dato_caracter
     from   arplpgd a, arplmI b
     where  b.no_cia = Pv_cia
     and    a.grupo_parametro = 'DECIMO4'
     and    a.parametro_id = 'I14'
     and    a.dato_caracter = b.no_ingre
    UNION
     select a.dato_caracter
     from   arplpgd a, arplmI b
     where  b.no_cia = Pv_cia
     and    a.grupo_parametro = 'DECIMO4'
     and    a.parametro_id = 'R14'
     and    a.dato_caracter = b.no_ingre);

   --- Decimo tercer sueldo

   Cursor C_13 Is
    select nvl(sum(nvl(monto,0)),0) valor
    from   arplhs
    where  no_cia   = Pv_cia
    and    no_emple = Pv_emple
    and    ano      = Pn_ano
    and    mes between Pn_mes_ini and Pn_mes_fin
    and    tipo_m   = 'I'
    and    codigo in --- decimo tercero
    (select a.dato_caracter
     from   arplpgd a, arplmI b
     where  b.no_cia = Pv_cia
     and    a.grupo_parametro = 'DECIMO3'
     and    a.parametro_id = 'I13'
     and    a.dato_caracter = b.no_ingre);

   --- Utilidades

   Cursor C_Utilidad Is
    select nvl(sum(nvl(monto,0)),0) valor
    from   arplhs
    where  no_cia   = Pv_cia
    and    no_emple = Pv_emple
    and    ano      = Pn_ano
    and    mes between Pn_mes_ini and Pn_mes_fin
    and    tipo_m   = 'I'
    and    codigo in --- decimo tercero
    (select a.dato_caracter
     from   arplpgd a, arplmI b
     where  b.no_cia = Pv_cia
     and    a.grupo_parametro = 'UTILIDADES'
     and    a.parametro_id = '9U'
     and    a.dato_caracter = b.no_ingre);

--- Fondo de reserva pagado y provisionado
Cursor C_Fondo_Reserva_pagado Is
  select nvl(sum(nvl(monto,0)),0) valor
  from   arplhs
  where  no_cia   = Pv_cia
  and    no_emple = Pv_emple
  and    ano      = Pn_ano
  and    mes between Pn_mes_ini and Pn_mes_fin
  and    tipo_m   = 'I'
  and    codigo in (select rubro_fr_ing from arplpar where no_cia = Pv_cia);

Cursor C_Fondo_Reserva_provision Is
  select nvl(sum(nvl(monto,0)),0) valor
  from   arplhs
  where  no_cia   = Pv_cia
  and    no_emple = Pv_emple
  and    ano      = Pn_ano
  and    mes between Pn_mes_ini and Pn_mes_fin
  and    tipo_m   = 'D'
  and    codigo in (select rubro_fdo_res from arplpar where no_cia = Pv_cia);

/**** Rentas exentas de impuesto a la renta recibidas por los trabajadores
      por concepto de bonificaciones de desahucio, indemnización por despido
      intempestivo en la parte que no exceda los límites establecidos en el
      Código de trabajo y los obtenidos por los funcionarios que integran
      las entidades del sector público ecuatoriano dentro de los límites
      que establece la disposición General Segunda de la Codificación de
      la Ley Orgánica de Servicio Civil y Carrera Administrativa y de
      Unificación y Homologación de las Remuneraciones del Sector Público ***/

  Cursor C_Otros_ng Is
    select nvl(sum(nvl(monto,0)),0) valor
    from   arplhs
    where  no_cia   = Pv_cia
    and    no_emple = Pv_emple
    and    ano      = Pn_ano
    and    mes between Pn_mes_ini and Pn_mes_fin
    and    tipo_m   = 'I'
    and    codigo NOT IN --- Grupo de ingresos que no forman parte del grupo de ingreso de impuesto a la renta
    (select c.no_ingre
     from   arplpar a, arplmd b, arplgid c
     where  a.no_cia     = Pv_cia
     and    a.no_cia     = b.no_cia
     and    a.cod_impsal = b.no_dedu
     and    b.no_cia     = c.no_cia
     and    b.grupo_ing  = c.grupo_ing);

  --- Aportes al IESS
   Cursor C_Aporte_IESS Is
    select nvl(sum(nvl(monto,0)),0) valor
    from   arplhs
    where  no_cia   = Pv_cia
    and    no_emple = Pv_emple
    and    ano      = Pn_ano
    and    mes between Pn_mes_ini and Pn_mes_fin
    and    tipo_m   = 'D'
    and    codigo in --- decimo cuarto y retroactivo
    (select a.dato_caracter
     from   arplpgd a, arplmd b
     where  b.no_cia = Pv_cia
     and    a.grupo_parametro = 'LIQ_EMP'
     and    a.parametro_id = 'AP'
     and    a.dato_caracter = b.no_dedu);

 --- Impuesto a la renta causado
 Cursor C_Imp_renta Is
  select nvl(sum(nvl(monto,0)),0) valor
  from   arplhs
  where  no_cia   = Pv_cia
  and    no_emple = Pv_emple
  and    ano      = Pn_ano
  and    mes between Pn_mes_ini and Pn_mes_fin
  and    tipo_m   = 'D'
  and    codigo in (select cod_impsal from arplpar where no_cia = Pv_cia);

 --- Numero de retenciones al anio
 Cursor C_Num_retenciones Is
  select count(*)
  from   arplhs
  where  no_cia   = Pv_cia
  and    no_emple = Pv_emple
  and    ano      = Pn_ano
  and    mes between Pn_mes_ini and Pn_mes_fin
  and    tipo_m   = 'D'
  and    codigo in (select cod_impsal from arplpar where no_cia = Pv_cia);

    Ln_fr_pagado    Number := 0;
    Ln_fr_provision Number := 0;
    Ln_monto        Number := 0;

   BEGIN

   /*** Parametros:
    (S) Sueldo
    (O) Sobresueldos y otros
    (4) decimo cuarto y retroactivo decimo cuarto
    (3) decimo tercero
    (U) utilidad
    (F) Fondo de reserva. Pagado y provision
    (D) Desahucio, despido intempestivo y otros no gravados
    (A) Aporte IESS
    (I) Impuesto a la renta
    (R) Numero de retenciones al anio ***/

   If Pv_parametro = 'S' Then

     Open C_Sueldo;
     Fetch C_sueldo into Ln_monto;
     Close C_Sueldo;

   elsif Pv_parametro = 'O' Then

     Open C_Sobresueldo;
     Fetch C_Sobresueldo into Ln_monto;
     Close C_Sobresueldo;

   elsif Pv_parametro = '4' Then

     Open C_14;
     Fetch C_14 into Ln_monto;
     Close C_14;

   elsif Pv_parametro = '3' Then

     Open C_13;
     Fetch C_13 into Ln_monto;
     Close C_13;

   elsif Pv_parametro = 'U' Then
     Open C_Utilidad;
     Fetch C_Utilidad into Ln_monto;
     Close C_Utilidad;
   elsif Pv_parametro = 'F' Then

     Open C_Fondo_Reserva_pagado;
     Fetch C_Fondo_Reserva_pagado into Ln_fr_pagado;
     Close C_Fondo_Reserva_pagado;

     Open C_Fondo_Reserva_provision;
     Fetch C_Fondo_Reserva_provision into Ln_fr_provision;
     Close C_Fondo_Reserva_provision;

     Ln_monto := Ln_fr_pagado + Ln_fr_provision;

   elsif Pv_parametro = 'D' Then

     Open C_Otros_ng;
     Fetch C_Otros_ng into Ln_monto;
     Close C_Otros_ng;

   elsif Pv_parametro = 'A' Then

     Open C_Aporte_IESS;
     Fetch C_Aporte_IESS into Ln_monto;
     Close C_Aporte_IESS;

   elsif Pv_parametro = 'I' Then

     Open C_Imp_Renta;
     Fetch C_Imp_Renta into Ln_monto;
     Close C_Imp_Renta;

   elsif Pv_parametro = 'R' Then

     Open C_Num_retenciones;
     Fetch C_Num_retenciones into Ln_monto;
     Close C_Num_retenciones;

   else

      Ln_monto := 0;

   end if;

   return (Ln_monto);

   END;

   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE ARPLPAR
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_arplpar(pa_cia   IN arplsec.no_cia%TYPE)
   RETURN arplpar%ROWTYPE
   IS
      v_reg_arplpar_rg  arplpar%ROWTYPE;
   BEGIN
      SELECT    /*+ FIRST_ROWS +*/
                *
      INTO      v_reg_arplpar_rg
      FROM      arplpar a
      WHERE     a.no_cia = pa_cia;

      RETURN v_reg_arplpar_rg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR
            (-20000,'Error al recuperar registro en ARPLPAR. '||
             SQLCODE||' '||SQLERRM);
   END;

   ---------------------------------------------------------
   --FUNCION PARA OBTENER EL REGISTRO COMPLETO DE ARPLCP
   ---------------------------------------------------------
   FUNCTION f_obtiene_reg_arplcp(pa_cia     IN arplcp.no_cia%TYPE,
                                 pa_cod_pla IN arplcp.codpla%TYPE)
   RETURN arplcp%ROWTYPE
   IS
      v_reg_arplcp_rg   arplcp%ROWTYPE;
   BEGIN
      SELECT    /*+ FIRST_ROWS +*/
                *
      INTO      v_reg_arplcp_rg
      FROM      arplcp a
      WHERE     a.codpla = pa_cod_pla
      AND       a.no_cia = pa_cia;

      RETURN v_reg_arplcp_rg;
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR
            (-20000,'Error al recuperar registro en ARPLCP. '||
             SQLCODE||' '||SQLERRM);
   END f_obtiene_reg_arplcp;

      ------------------------------------------------------------
  FUNCTION f_fecha_letras(p_fecha    IN DATE,
                          p_lenguaje IN NUMBER DEFAULT NULL) RETURN CHAR IS
    v_fecha_letras_tx VARCHAR2(200);
  BEGIN
    SELECT TO_CHAR(TRUNC(p_fecha), 'DD') || ' de ' ||
           RTRIM(TO_CHAR(TRUNC(p_fecha),
                         'MONTH',
                         'NLS_DATE_LANGUAGE=SPANISH')) || ' de ' ||
           TO_CHAR(TRUNC(p_fecha), 'RRRR')
      INTO v_fecha_letras_tx
      FROM DUAL;
    RETURN v_fecha_letras_tx;
  EXCEPTION
    WHEN OTHERS THEN
      v_fecha_letras_tx := '*** FECHA NO VALIDA ***';
      RETURN v_fecha_letras_tx;
  END;

   -------------------

   -- Devuelve el total de ingresos. Sumatoria ARPLPPI
   FUNCTION f_total_ingresos(
                 pno_cia     in arplppi.no_cia%type
                ,pno_emple   in arplppi.no_emple%type
                ,pcod_pla    in arplppi.cod_pla%type
                ,ptipo_suma  in NUMBER DEFAULT NULL ) RETURN NUMBER
   IS
      v_total_ing_nr      NUMBER(17,4);
      v_total_ing_sec_nr  NUMBER(17,4);
      v_total_ingresos_nr NUMBER(17,4);
   BEGIN
      --Sumatoria de valores de ARPLPPI.
      BEGIN
         SELECT    SUM(a.monto)
         INTO      v_total_ing_nr
         FROM      arplppi a
         WHERE     a.no_emple = pno_emple
         AND       a.cod_pla = pcod_pla
         AND       a.no_cia = pno_cia;

         RETURN (v_total_ing_nr);

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_total_ing_nr := 0;
         WHEN OTHERS THEN
            v_total_ing_nr := 0;
      END;
    END;

   --- Devuelve dia de accciones de personal
   --- maternidad, vacaciones, faltas injustificadas, entre otras ANR 10/06/2010

  FUNCTION DIAS_ACCIONES   (pv_cia   in Varchar2,
                            pv_pla   in Varchar2,
                            pv_emple in Varchar2,
                            pn_anio  in Number,
                            pn_mes   in Number,
                            pv_tipo    in Varchar2) return Number IS

     --- MA Maternidad
     --- VT Vacaciones tomadas
     --- EN Enfermedad
     --- EI Enfermedad certificada en IESS
     --- PE Permisos
     --- FI Faltas injustificadas
     --- NR Dias no laborados no remunerados
     --- RE Dias no laborados remunerados

      cursor c_dias_maternidad is
       select nvl(sum(nvl(dias,0)),0) maternidad
       from   arplappp a
       where  a.no_cia   = pv_cia
       and    a.cod_pla  = pv_pla
       and    a.no_emple = pv_emple
       and    to_number(to_char(a.fecha,'YYYY')) = pn_anio
       and    to_number(to_char(a.fecha,'MM'))   = pn_mes
       and    a.clase_mov = 'M';

      cursor c_dias_vt is
       select nvl(sum(nvl(dias,0)),0) maternidad
       from   arplappp a
       where  a.no_cia   = pv_cia
       and    a.cod_pla  = pv_pla
       and    a.no_emple = pv_emple
       and    to_number(to_char(a.fecha,'YYYY')) = pn_anio
       and    to_number(to_char(a.fecha,'MM'))   = pn_mes
       and    a.clase_mov = 'V';

      cursor c_dias_enfermedad is
       select nvl(sum(nvl(dias,0)),0) maternidad
       from   arplappp a
       where  a.no_cia   = pv_cia
       and    a.cod_pla  = pv_pla
       and    a.no_emple = pv_emple
       and    to_number(to_char(a.fecha,'YYYY')) = pn_anio
       and    to_number(to_char(a.fecha,'MM'))   = pn_mes
       and    a.tipo_mov = 'I1';

      cursor c_dias_enfermedad_iess is
       select nvl(sum(nvl(dias,0)),0) maternidad
       from   arplappp a
       where  a.no_cia   = pv_cia
       and    a.cod_pla  = pv_pla
       and    a.no_emple = pv_emple
       and    to_number(to_char(a.fecha,'YYYY')) = pn_anio
       and    to_number(to_char(a.fecha,'MM'))   = pn_mes
       and    a.tipo_mov = 'I2';

      cursor c_dias_permisos is
       select nvl(sum(nvl(dias,0)),0) maternidad
       from   arplappp a
       where  a.no_cia   = pv_cia
       and    a.cod_pla  = pv_pla
       and    a.no_emple = pv_emple
       and    to_number(to_char(a.fecha,'YYYY')) = pn_anio
       and    to_number(to_char(a.fecha,'MM'))   = pn_mes
       and    a.clase_mov = 'P';

      cursor c_dias_faltas_injust is
       select nvl(sum(nvl(dias,0)),0) maternidad
       from   arplappp a
       where  a.no_cia   = pv_cia
       and    a.cod_pla  = pv_pla
       and    a.no_emple = pv_emple
       and    to_number(to_char(a.fecha,'YYYY')) = pn_anio
       and    to_number(to_char(a.fecha,'MM'))   = pn_mes
       and    a.tipo_mov = 'AI';

      cursor c_dias_nolab_nr is
       select nvl(sum(nvl(dias,0)),0) maternidad
       from   arplappp a
       where  a.no_cia   = pv_cia
       and    a.cod_pla  = pv_pla
       and    a.no_emple = pv_emple
       and    to_number(to_char(a.fecha,'YYYY')) = pn_anio
       and    to_number(to_char(a.fecha,'MM'))   = pn_mes
       and    a.goce_sueldo = 'N';

      cursor c_dias_nolab_re is
       select nvl(sum(nvl(dias,0)),0) maternidad
       from   arplappp a
       where  a.no_cia   = pv_cia
       and    a.cod_pla  = pv_pla
       and    a.no_emple = pv_emple
       and    to_number(to_char(a.fecha,'YYYY')) = pn_anio
       and    to_number(to_char(a.fecha,'MM'))   = pn_mes
       and    a.goce_sueldo = 'S';


       Ln_dias Number := 0;

   Begin
     If pv_tipo = 'MA' Then --- Maternidad

        Open c_dias_maternidad;
        Fetch c_dias_maternidad into Ln_dias;
        If c_dias_maternidad%notfound Then
        Close c_dias_maternidad;
         Ln_dias := 0;
        else
        Close c_dias_maternidad;
        end if;

     elsif pv_tipo = 'VT' Then --- Vacaciones tomadas
        Open c_dias_vt;
        Fetch c_dias_vt into Ln_dias;
        If c_dias_vt%notfound Then
        Close c_dias_vt;
         Ln_dias := 0;
        else
        Close c_dias_vt;
        end if;

     elsif pv_tipo = 'EN' Then --- Enfermedad
        Open c_dias_enfermedad;
        Fetch c_dias_enfermedad into Ln_dias;
        If c_dias_enfermedad%notfound Then
        Close c_dias_enfermedad;
         Ln_dias := 0;
        else
        Close c_dias_enfermedad;
        end if;

     elsif pv_tipo = 'EI' Then --- Enfermedad certificada IESS
        Open c_dias_enfermedad_iess;
        Fetch c_dias_enfermedad_iess into Ln_dias;
        If c_dias_enfermedad_iess%notfound Then
        Close c_dias_enfermedad_iess;
         Ln_dias := 0;
        else
        Close c_dias_enfermedad_iess;
        end if;

     elsif pv_tipo = 'PE' Then --- Permisos
        Open c_dias_permisos;
        Fetch c_dias_permisos into Ln_dias;
        If c_dias_permisos%notfound Then
        Close c_dias_permisos;
         Ln_dias := 0;
        else
        Close c_dias_permisos;
        end if;

     elsif pv_tipo = 'FI' Then --- Faltas injustificadas
        Open c_dias_faltas_injust;
        Fetch c_dias_faltas_injust into Ln_dias;
        If c_dias_faltas_injust%notfound Then
        Close c_dias_faltas_injust;
         Ln_dias := 0;
        else
        Close c_dias_faltas_injust;
        end if;

     elsif pv_tipo = 'NR' Then --- Dias no laborados no remunerados
        Open c_dias_nolab_nr;
        Fetch c_dias_nolab_nr into Ln_dias;
        If c_dias_nolab_nr%notfound Then
        Close c_dias_nolab_nr;
         Ln_dias := 0;
        else
        Close c_dias_nolab_nr;
        end if;

     elsif pv_tipo = 'RE' Then --- Dias no laborados remunerados
        Open c_dias_nolab_re;
        Fetch c_dias_nolab_re into Ln_dias;
        If c_dias_nolab_re%notfound Then
        Close c_dias_nolab_re;
         Ln_dias := 0;
        else
        Close c_dias_nolab_re;
        end if;


     end if;

     return (Ln_dias);

   End;

FUNCTION Solo_Pago_Liquidacion(Pno_Cia IN VARCHAR2) RETURN VARCHAR2 IS
  
    Vfound            BOOLEAN;
    Vsolo_Liquidacion VARCHAR2(1) := 'N';
  
    CURSOR c_Pago_Liquidacion IS
      SELECT Solo_Pago_Liq
        FROM Arplmc
       WHERE No_Cia = Pno_Cia;
  
  BEGIN
    OPEN c_Pago_Liquidacion;
    FETCH c_Pago_Liquidacion
      INTO Vsolo_Liquidacion;
    Vfound := c_Pago_Liquidacion%FOUND;
    CLOSE c_Pago_Liquidacion;
    RETURN(Vsolo_Liquidacion);
  END;   

END PLLIB;
/
