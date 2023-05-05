CREATE OR REPLACE PACKAGE            PLDEDUCCIONES_LEY_ECU_tnet IS
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



/
