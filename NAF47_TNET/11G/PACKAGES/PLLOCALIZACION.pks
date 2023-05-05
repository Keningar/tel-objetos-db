CREATE OR REPLACE PACKAGE            PLLOCALIZACION AS
   -- ---
   --   Este paquete contiene varios requeridos para las localizaciones.
   -- ---
--	*****************************************
--    	Dias disfrute vacaciones
--	*****************************************
   FUNCTION dias_disfrute_vac (
     p_no_cia    CHAR,
     p_no_emple  CHAR
   ) RETURN NUMBER;
--	*****************************************
--    	Dias pagados por convenio colectivo (vacaciones)
--	*****************************************
   FUNCTION dias_convenio_vac (
     p_no_cia    CHAR,
     p_no_emple  CHAR
   ) RETURN NUMBER;
--	*****************************************
--    	Dias de Bono Vacacional
--	*****************************************
   FUNCTION dias_bono_vac (
     p_no_cia    CHAR,
     p_no_emple  CHAR
   ) RETURN NUMBER;
   -- *****************************************************
   --       Dias Adicionales de vacaciones
   -- *****************************************************
   FUNCTION adic_vacaciones (
     p_fecha_ref     DATE
    ,p_fecha_ingreso DATE
	,p_fecha_ley     DATE
    ,p_cant_meses    NUMBER
    ,p_tope          NUMBER
   )RETURN NUMBER;
   -- Obtiene el saldo del mes anterior
   FUNCTION ObtieneSaldoAnt(
      pCia        varchar2
      ,pno_emple  varchar2
      ,pAno       number
      ,pMes       number
   ) RETURN NUMBER;
   -- Se encarga de insertar o actualizar la tabla arplant, segun sea el caso
   PROCEDURE Registra_prestaciones(
      pCia        varchar2
      ,pno_emple  varchar2
      ,pAno       number
      ,pMes       number
      ,psaldo_ant number
      ,pMonto_mes number
      ,pMonto_int number
      ,pMonto_pre number
   );
   -- Obtiene el monto total en prestamos para un empleado
   FUNCTION ObtieneTotalPrest(
      pCia        varchar2
      ,pno_emple  varchar2
   ) RETURN NUMBER;
   -- OBTIENE EL MONTO TOTAL DE PRESTACIONES POR ANTIGUEDAD PARA EL MES.
   FUNCTION MontoPrestaciones(
     pCia        in varchar2
     ,pno_emple  in varchar2
	 ,pano       in number
	 ,pmes       in number
   ) RETURN NUMBER;
   -- Calcula un porcentaje de interes sobre el monto dado
   FUNCTION Calculo_int (
     pMontoPrestaciones NUMBER
	,pInt               NUMBER
   )RETURN NUMBER;
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
   -- --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20025);
   kNum_error      NUMBER := -20025;
END PLLOCALIZACION;
/


CREATE OR REPLACE PACKAGE BODY            PLLOCALIZACION AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   vMensaje_error    VARCHAR2(160);
   -- VARIABLES GLOBALES
   --
   gdummy            varchar2(2);
   --
   --
   PROCEDURE limpia_error IS
   BEGIN
      vMensaje_error := NULL;
   END;
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := substr('PLLOCALIZACION: '|| msj_error,1,160);
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
      RETURN(vMensaje_error);
   END ultimo_error;
   --
   -- --
   -- OBTIENE EL MONTO TOTAL DE PRESTACIONES POR ANTIGUEDAD PARA EL MES.
   FUNCTION MontoPrestaciones(
     pCia        in varchar2
     ,pno_emple  in varchar2
	 ,pano       in number
	 ,pmes       in number
   ) RETURN NUMBER
   IS
     --
     vMontoPrestaciones arplppi.monto%type;
     v_IngAnt arplmi.no_ingre%type;
   BEGIN
   --
     /* OBTIENE EL PARAMETRO CORRESPONDIENTE AL INGRESO DE PRESTACIONES POR ANTIGUEDAD   */
     IF NOT pllib.trae_parametro('PINGANT',
                                   v_IngAnt) THEN
       genera_error('No se encuentra definido el parametro correspondiente a la tasa de interes para prestaciones por antiguedad');
     END IF;
     /* OBTIENE EL MONTO POR PRESTACIONES PARA EL MES   */
     vMontoPrestaciones := NVL(pllib.monto_h(pCia
 					,pano
					,pmes
                                        ,pno_emple
                                        ,'D'
                                        ,v_IngAnt),0);
     RETURN vMontoPrestaciones;
   END;
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
   )RETURN NUMBER
   IS
     v_monto_diario arplhs.monto%type;
   BEGIN
     v_monto_diario := PLlib.monto_grupo_ing_h(p_cia
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
     v_monto_diario := nvl(PLlib.monto_grupo_ing_pp(p_cia
                                             ,p_no_emple
                                             ,p_grupo_ing
                                             ,p_cod_pla),0) / p_diasxmes;
     v_monto_diario := v_monto_diario + (nvl(PLlib.monto_grupo_ing_h(p_cia
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
     v_meses := PLlib.Obtiene_meses_fraccion(p_f_ingreso,p_f_hasta);
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
      NULL; -- v_salario_mes := NVL(PLlib.salario_minimo_nacional(p_cia),0);
     END IF;
     v_monto_diario := v_salario_mes / nvl(p_divisor,1);
     RETURN v_monto_diario;
   END;
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
     v_meses_trab  := PLlib.Obtiene_meses_fraccion(p_f_ingreso,add_months(p_f_hasta,-1));
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
 /*     vMonto := nvl(pllib.monto_grupo_ing_ant(p_cia
                                             ,p_emple
                                             ,p_grupo
                                             ,pano
                                             ,pmes
                                             ,vDias
  		                             ,24),0) / vDias;
   */   Return(vMonto);
   END;

   -- Calcula un porcentaje de interes sobre el monto dado
   FUNCTION Calculo_int (
     pMontoPrestaciones NUMBER
	,pInt               NUMBER
   )RETURN NUMBER
   IS
   BEGIN
   --
     return (pMontoPrestaciones * pInt)/100;
   END;
   --
   --
   /*******[ PARTE: PUBLICA ]
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   --
   FUNCTION ObtieneSaldoAnt(
      pCia        varchar2
      ,pno_emple  varchar2
      ,pAno       number
      ,pMes       number
   ) RETURN NUMBER
   IS
     v_saldoAnt arplant.saldo_ant%type;
     --
   BEGIN
   --
     BEGIN
       SELECT saldo_ant
            + monto_mes
            + monto_int
            - monto_pre
       INTO v_saldoAnt
       FROM arplant
       WHERE no_cia   = pCia
         AND no_emple = pno_emple
         AND ano      = DECODE(pMes,1,pAno - 1, pAno)
         AND mes      = DECODE(pMes,1,12,pMes - 1);
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_saldoAnt := 0;
     END;
     RETURN v_saldoAnt;
   END;
   --
   --
   PROCEDURE Registra_prestaciones(
      pCia        varchar2
      ,pno_emple  varchar2
      ,pAno       number
      ,pMes       number
      ,psaldo_ant number
      ,pMonto_mes number
      ,pMonto_int number
      ,pMonto_pre number
   )
   IS
     --
   BEGIN
   --
     INSERT INTO arplant(no_cia,
                         no_emple,
                         ano,
                         mes,
                         saldo_ant,
                         monto_mes,
                         monto_int,
                         monto_pre)
     VALUES (pCia,
             pNo_emple,
             pAno,
             pMes,
             psaldo_ant,
             pMonto_mes,
             pMonto_int,
             pMonto_pre);
   EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN
       UPDATE arplant
       SET monto_mes = monto_mes + pMonto_mes,
           monto_int = monto_int + pMonto_int,
           monto_pre = monto_pre + pMonto_pre
       WHERE no_cia = pCia
         AND no_emple = pNo_emple
         AND ano = pAno
         AND mes = pMes;
   END;
   --
   --
   FUNCTION ObtieneTotalPrest(
      pCia        varchar2
      ,pno_emple  varchar2
   ) RETURN NUMBER
   IS
     v_totalPre arplant.monto_pre%type;
     --
   BEGIN
   --
     BEGIN
       SELECT NVL(SUM(NVL(monto_pre,0)),0)
       INTO v_totalPre
       FROM arplant
       WHERE no_cia   = pCia
         AND no_emple = pno_emple;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_totalPre := 0;
     END;
     RETURN v_totalPre;
   END;
   --
   --
--	*****************************************
--    	Dias disfrute vacaciones
--	*****************************************
   FUNCTION dias_disfrute_vac (
     p_no_cia    CHAR,
     p_no_emple  CHAR
   ) RETURN NUMBER
   IS
	 vdias_ley         NUMBER;
   BEGIN
     -- Obtiene la cantidad de dias de disfrute por ley
     IF NOT PLLIB.Trae_Parametro('DLEY', vdias_ley) THEN
       vdias_ley := 0;
     END IF;
     RETURN vDias_ley;
   END;
--	*****************************************
--    	Dias convenio vacaciones
--	*****************************************
   FUNCTION dias_convenio_vac (
     p_no_cia    CHAR,
     p_no_emple  CHAR
   ) RETURN NUMBER
   IS
	 vdias_conv         NUMBER;
   BEGIN
     -- Obtiene la cantidad de dias pagos por convenio colectivo
     IF NOT PLLIB.Trae_Parametro('DCONV', vdias_conv) THEN
       vdias_conv := 0;
     END IF;
     RETURN vDias_conv;
   END;
--	*****************************************
--    	Dias de Bono Vacacional
--	*****************************************
   FUNCTION dias_bono_vac (
     p_no_cia    CHAR,
     p_no_emple  CHAR
   ) RETURN NUMBER
   IS
	 vdias_Bono         NUMBER;
	 v_dias_adic_bono   NUMBER;
   v_MaxDiasBono      NUMBER;
	 v_DiasDerechoAnt   NUMBER;
   BEGIN
     -- Obtiene la cantidad de dias de bono a los que tenia antes del nacimiento de la ley
     --
     v_diasDerechoAnt := PLlib.obtiene_valor_emp_clase(p_no_cia, p_no_emple, 'DBOV');
     --
     -- Obtiene la cantidad de dias de bono vacacional
     IF NOT PLLIB.Trae_Parametro('DIASBONO', vDias_bono) THEN
       Genera_error('No se ha definido el parametro que indica la cantidad del dias de bono');
	 END IF;
     vDias_bono := GREATEST(vDias_bono,v_diasDerechoAnt);
     RETURN vDias_bono;
   END;
   -- *****************************************************
   --       Dias Adicionales de vacaciones
   -- *****************************************************
   FUNCTION adic_vacaciones (
     p_fecha_ref     DATE
    ,p_fecha_ingreso DATE
	,p_fecha_ley     DATE
    ,p_cant_meses    NUMBER
    ,p_tope          NUMBER
   )RETURN NUMBER
   IS
     vAplica_Desde      Date;
     v_anos              NUMBER(4);
     v_dias_adicionales  NUMBER;
     v_MaxDias           NUMBER;
     v_meses             NUMBER;
	 vfraccion          NUMBER;
   BEGIN
     /* Tomo el mayor entre la fecha de ingreso del empleado y la fecha en
        que se aprobo la ley y a esta fecha le agrego un a?o, porque en el
        segundo a?o ya debo pagarle                                        */
     vAplica_Desde := GREATEST(p_fecha_ley,p_fecha_ingreso);
     v_meses   := pllib.Obtiene_meses(vAplica_Desde, p_fecha_ref);
     v_anos        := TRUNC(v_meses/12);
     vfraccion := MOD(v_meses,12);
     -- Si la fraccion de meses es mayor o igual a la cantidad de meses a los cuales obtiene
     -- el derecho a la vacacion, asume un anno mas.
     IF vfraccion >= p_cant_meses AND
       p_cant_meses IS NOT NULL THEN
       v_anos := v_anos + 1;
     END IF;
     v_dias_adicionales := LEAST(p_tope,v_anos);
     RETURN v_dias_adicionales;
   END;
END PLLOCALIZACION;
/
