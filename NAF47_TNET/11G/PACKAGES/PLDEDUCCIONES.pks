CREATE OR REPLACE PACKAGE            PLDEDUCCIONES IS
-- PL/SQL Specification
-- ---
   --   Este paquete define la interfase entre el sistema de nomina y un
   -- conjunto de funciones y procedimientos que implementan el calculo
   -- de deducciones de Ley o propias de una compa?ia.  Las deducciones
   -- de ley son implementadas en el paquete denominado DEDUCCIONES_LEY_<PAIS>,
   -- mientras que las de la compa?ia estan en DEDUCCIONES_CIA_<PAIS>.
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
               ,pind_calculo  in arplmd.ind_calculo%type
               ) RETURN calculo_r;
   -- --
   -- Devuelve laa descripcion del ultimo error ocurrido
   FUNCTION  ultimo_error RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20016);
   kNum_error      NUMBER := -20016;

END PLDEDUCCIONES;
/


CREATE OR REPLACE PACKAGE BODY            PLDEDUCCIONES IS
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
      vMensaje_error := SUBSTR('DED.' || msj_error,1,160);
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   -- --
   -- Valida si el paquete ya fue inicializado
   FUNCTION inicializado(pCia varchar2) RETURN BOOLEAN IS
   BEGIN
      RETURN ( nvl(gno_cia,null) = pCia);
   END inicializado;
   --
   -- ---
   --
   /******************************[ PARTE: PUBLICA ]******************************
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
      pldeducciones_cia.inicializa(pCia);
      pldeducciones_ley_cr.inicializa(pCia);
	  gno_cia := pCia;
   END inicializa;
   --
   FUNCTION cuando_aplica_ded (
     pcia      VARCHAR2,
     pno_dedu  VARCHAR2
   ) RETURN VARCHAR2
   IS
     vcuando_aplica  arplmd.cuando_aplica%type;
     CURSOR c_cuando_aplica IS
       SELECT cuando_aplica
       FROM arplmd
       WHERE no_cia   = pcia
         AND no_dedu  = pno_dedu;
   BEGIN
   	 OPEN c_cuando_aplica;
   	 FETCH c_cuando_aplica INTO vcuando_aplica;
   	 CLOSE c_cuando_aplica;
     RETURN NVL(vcuando_aplica,'T');
   END;
   --
   -- ---
   FUNCTION calcula(
      pno_cia        in arplme.no_cia%type
      ,pcod_pla      in arplppd.cod_pla%type
      ,pno_emple     in arplppd.no_emple%type
      ,pno_dedu      in arplppd.no_dedu%type
      ,pformula_id   in arplmd.formula_id%type
      ,pind_calculo  in arplmd.ind_calculo%type
   ) RETURN calculo_r
   IS
     CURSOR c_reg_formula IS
	    SELECT pais
		  FROM arplregf
		  WHERE formula_id = pformula_id;
     --
	   vpais                arplregf.pais%type;
     ves_ultima_planilla  BOOLEAN;
     vcuando_aplica       arplmd.cuando_aplica%type;
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
     --
     ves_ultima_planilla := pllib.es_ultima_planilla(pno_cia, pcod_pla);
     vcuando_aplica      := cuando_aplica_ded(pno_cia, pno_dedu);
     --
     if NOT (vcuando_aplica = 'T' OR
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
              rCalc := pldeducciones_ley_cr.calcula(pno_cia ,pcod_pla ,pno_emple
			                                        ,pno_dedu ,pformula_id);
           exception
              when pldeducciones_ley_cr.error then
                   genera_error(pldeducciones_ley_cr.ultimo_error);
           end;
        end if;
		  if vpais = 'ECU' then
           begin
              rCalc := pldeducciones_ley_ecu.calcula(pno_cia ,pcod_pla ,pno_emple
			                                        ,pno_dedu ,pformula_id);

           exception
              when pldeducciones_ley_ecu.error then
                   genera_error(pldeducciones_ley_ecu.ultimo_error);
           end;
        end if;
     elsif pind_calculo = 'C' then
        begin
           rCalc := pldeducciones_cia.calcula(pno_cia
                                          ,pcod_pla
                                          ,pno_emple
                                          ,pno_dedu
                                          ,pformula_id);
        exception
          when pldeducciones_cia.error then
             genera_error(pldeducciones_cia.ultimo_error);
        end;
     else
        genera_error('El valor de ind_calculo: '|| pind_calculo ||' no es valido');
     end if;
     RETURN (rCalc);
   END calcula;
   --
END;   -- BODY deducciones
/
