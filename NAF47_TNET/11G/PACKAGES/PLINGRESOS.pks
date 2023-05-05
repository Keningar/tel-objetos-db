CREATE OR REPLACE PACKAGE            PLINGRESOS IS
-- PL/SQL Specification
-- ---
   -- ---
   --   Este paquete define la interfase entre el sistema de nomina y un
   -- conjunto de funciones y procedimientos que implementan el calculo
   -- de ingresos de Ley o propios de una compa?ia.  Las ingresos de ley
   -- son implementadas en el paquete denominado INGRESOS_LEY_<PAIS>.
   --
   -- ***
   --
   --
   SUBTYPE calculo_r IS PLlib.PLingresos_calc_r;
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
               ,pcod_pla      in arplppi.cod_pla%type
               ,pno_emple     in arplppi.no_emple%type
               ,pno_ingre     in arplppi.no_ingre%type
               ,pformula_id   in arplmi.formula_id%type
               ,pind_calculo  in arplmi.ind_calculo%type
               ,pcantidad     in arplppi.cantidad%type
               ) RETURN calculo_r;
   -- --
   -- Devuelve laa descripcion del ultimo error ocurrido
   FUNCTION  ultimo_error RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20015);
   kNum_error      NUMBER := -20015;

END PLINGRESOS;
/


CREATE OR REPLACE PACKAGE BODY            PLINGRESOS IS
/*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
   --
   -- ---
   --
   gno_cia           arplmc.no_cia%type;
   rCalc             calculo_r;
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
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := SUBSTR('ING.' || msj_error,1,160);
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   -- --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN IS
   BEGIN
      RETURN ( nvl(gno_cia,'*NULO*') = pCia);
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
   BEGIN
      limpia_error;
      plingresos_ley_ecu.inicializa(pCia);
      plingresos_cia.inicializa(pCia);
      gno_cia  := pCia;
   END inicializa;
   --
   --
   FUNCTION cuando_aplica_ing (
     pcia      VARCHAR2,
     pno_ingre VARCHAR2
   )
   RETURN VARCHAR2
   IS
     vcuando_aplica arplmi.cuando_aplica%type;
   BEGIN
     BEGIN
       SELECT NVL(cuando_aplica,'T')
         INTO vcuando_aplica
         FROM arplmi
         WHERE no_cia  = pcia
           AND no_ingre = pno_ingre;
       RETURN vcuando_aplica;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         genera_error('No se ha defindo el codigo de ingreso ' || pno_ingre);
     END;
   END;
   --
   -- ---
   FUNCTION calcula(
      pno_cia        in arplme.no_cia%type
      ,pcod_pla      in arplppi.cod_pla%type
      ,pno_emple     in arplppi.no_emple%type
      ,pno_ingre     in arplppi.no_ingre%type
      ,pformula_id   in arplmi.formula_id%type
      ,pind_calculo  in arplmi.ind_calculo%type
      ,pcantidad     in arplppi.cantidad%type
   ) RETURN calculo_r
   IS
     CURSOR c_reg_formula IS
        SELECT pais
	FROM arplregf
	WHERE formula_id = pformula_id;
     --
     vpais                arplregf.pais%type;
     ves_ultima_planilla  BOOLEAN;
     vcuando_aplica       arplmi.cuando_aplica%type;
   BEGIN
     -- limpia el registro del calculo
     rCalc.cantidad  := null;
     rCalc.monto     := null;
     rCalc.monto_aux := null;
     rCalc.tasa      := null;
     rCalc.meses     := null;
     rCalc.dias      := null;
     limpia_error;
     --
     if not inicializado(pno_cia) then
        inicializa(pno_cia);
     end if;
     ves_ultima_planilla := pllib.es_ultima_planilla(pno_cia, pcod_pla);
     vcuando_aplica      := cuando_aplica_ing(pno_cia, pno_ingre);
     --
     if NOT ( vcuando_aplica = 'T' OR
             (vcuando_aplica = 'U' AND ves_ultima_planilla) OR
             (vcuando_aplica = 'A' AND NOT ves_ultima_planilla)) then
	    null;
     elsif pind_calculo = 'L' then
        --
        open c_reg_formula;
        fetch c_reg_formula into vpais;
        close c_reg_formula;
        --
        if vpais = 'CRC' then
           begin
              rCalc := PLingresos_ley_cr.calcula(pno_cia
                                                  ,pcod_pla
                                                  ,pno_emple
                                                  ,pno_ingre
                                                  ,pformula_id
                                                  ,pcantidad);
           exception
              when plingresos_ley_cr.error then
                 genera_error(plingresos_ley_cr.ultimo_error);
          end;
        elsif vpais = 'ECU' then
           begin
              rCalc := PLingresos_ley_ECU.calcula(pno_cia
                                                  ,pcod_pla
                                                  ,pno_emple
                                                  ,pno_ingre
                                                  ,pformula_id
                                                  ,pcantidad);
           exception
              when plingresos_ley_ECU.error then
                 genera_error(plingresos_ley_ECU.ultimo_error);
          end;

        end if;
     elsif pind_calculo = 'C' then
        begin
            rCalc := plingresos_cia.calcula(pno_cia
                                            ,pcod_pla
                                            ,pno_emple
                                            ,pno_ingre
                                            ,pformula_id
                                            ,pcantidad);
        exception
            when plingresos_cia.error then
               genera_error(plingresos_cia.ultimo_error);
        end;
     else
        genera_error('El valor de ind_calculo: '|| pind_calculo ||' no es valido');
     end if;
     RETURN (rCalc);
   END calcula;
   --
   --
END;   -- BODY ingresos
/
