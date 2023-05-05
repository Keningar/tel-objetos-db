CREATE OR REPLACE package            f is

  -- Author  : DESAROLLO
  -- Created : 9/3/2007 11:24:13 AM
  -- Purpose : 
  
   -- TIPOS
   --
    SUBTYPE calculo_r IS PLlib.PLdeducciones_calc_r;
    
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
      ,dias_vaca       number
      ,f_egreso        arplme.f_egreso%type
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
      SELECT e.no_cia,   e.no_emple,
             e.estado,   nvl(e.f_reingreso,e.f_ingreso) f_ingreso,
             e.tipo_emp, plsueldo(e.no_cia, e.no_emple),
             decode(nvl(phorasxpla,0), 0, 0, plsueldo(e.no_cia, e.no_emple) / phorasxpla) sal_hora,
             e.f_egreso
         FROM arplme e
         WHERE e.no_cia     = pno_cia
           AND e.no_emple   = pno_emple;

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
  
  PROCEDURE limpia_error;

  PROCEDURE genera_error(msj_error IN VARCHAR2);
  
  PROCEDURE carga_datos_pla(pno_cia     arplcp.no_cia%TYPE ,
                                                                pcod_pla    arplcp.codpla%TYPE) ;
   
   PROCEDURE carga_datos_ded( pno_cia        arplmd.no_cia%TYPE ,
                                                                   pcod_pla    arplcp.codpla%TYPE ,
                                                                   pno_dedu       arplmd.no_dedu%TYPE );

   PROCEDURE carga_datos_emp(
      pno_cia        arplme.no_cia%type
     ,pno_emple      arplme.no_emple%type
     ,phorasxpla     number
   );
   
    PROCEDURE Carga_Datos_LiqEmp(pno_cia   ARPLCP.no_cia%TYPE,
                                pcod_pla  ARPLCP.codpla%TYPE,
                                pno_emple ARPLME.no_emple%TYPE);
                                
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN;
   
      PROCEDURE calc_rciva(
       pno_cia        in arplme.no_cia%type
      ,pno_emple     in arplme.no_emple%type
      ,pno_dedu      in arplmd.no_dedu%type
   ) ;
   
      PROCEDURE ProvisionDecimoCuarto(
                            pno_cia           in  arplme.no_cia%type,
              pformulaid        in  arplmd.formula_id%type,
                pmonto            out  rCalc.monto%type) ;
           
         PROCEDURE ProvisionDecimoTercero(
                            pno_cia           in  arplme.no_cia%type,
              pno_emple         in  arplme.no_emple%type,
              pcod_pla          in  VARCHAR,
              pformulaid        in  arplmd.formula_id%type,
                pmonto            out number) ;
                

   PROCEDURE FondoDeReserva(pno_cia    in  arplme.no_cia%type,
                            pfecha_ref     DATE,
                            pf_ingreso     DATE,
                            pno_emple  in  arplme.no_emple%type,
                            pcod_pla   in  VARCHAR,
                            pmeses         IN OUT  NUMBER,
                            pf_desde       DATE,
                            pf_hasta       DATE,
                            pformulaid in  arplmd.formula_id%type,
                            pmonto     out rCalc.monto%type) ;
                            
                            
   Procedure LiqEmp_Deducciones_x_Cobrar(P_No_cia    in varchar2,   -- Codigo de compa?ia
                                         P_CodNomAct in varchar2,   -- Nomina Actual de Liquidacion
                                         P_CodNomMen in varchar2,   -- Nomina Mensual de empleados
                                         P_No_emple  in varchar2,   -- Codigo de empleado
                                         P_fegreso   in  date,      -- Fecha de egreso del empleado
                                         P_IdFormula in varchar2,   -- Codigo de Formula
                                         pmonto      out number) ;
                                         
   FUNCTION ultimo_error RETURN VARCHAR2;
   
   PROCEDURE inicializa(pCia varchar2);
   
      FUNCTION calcula(pno_cia       in arplme.no_cia%type,
                    pcod_pla      in arplppd.cod_pla%type,
                    pno_emple     in arplppd.no_emple%type,
                    pno_dedu      in arplppd.no_dedu%type,
                    pformula_id   in arplmd.formula_id%type) RETURN calculo_r;                                                                                                          

end f;
/



/
