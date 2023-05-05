CREATE OR REPLACE package              VALIDA_IDENTIFICACION is

  /**
  * Documentacion para DB_COMERCIAL.VALIDA_IDENTIFICACION
  * Paquete que contiene procesos y funciones que invocan a proceso en base 19c
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/06/2022
  */
  

  /**
  * Documentacion para VALIDA
  * Procedure que invoca a proceso validacion de tipo identificación en Telcos
  * @author llindao <llindao@telconet.ec>
  * @version 1.0 24/06/2022
  *
  * @param P_TIPO_IDENT     IN     VARCHAR2 Recibe Tipo de identificación
  * @param P_IDENTIFICACION IN     VARCHAR2 Recibe número de identificación a validar.
  * @param P_MENSAJE        IN OUT VARCHAR2 Retorna mensaje error
  */
  PROCEDURE VALIDA (P_TIPO_IDENT     IN VARCHAR2,
                    P_IDENTIFICACION IN VARCHAR2,
                    P_MENSAJE        IN OUT VARCHAR2);

end VALIDA_IDENTIFICACION;
/


CREATE OR REPLACE package body              VALIDA_IDENTIFICACION is

  PROCEDURE VALIDA (P_TIPO_IDENT     IN VARCHAR2,
                    P_IDENTIFICACION IN VARCHAR2,
                    P_MENSAJE        IN OUT VARCHAR2) IS
    --
    Le_Error EXCEPTION;
    --
  BEGIN
     
    DB_COMERCIAL.VALIDA_IDENTIFICACION.VALIDA@GPOETNET ( P_TIPO_IDENT,
                                                         P_IDENTIFICACION,
                                                         P_MENSAJE);
    IF P_MENSAJE IS NOT NULL THEN
      RAISE Le_Error;	
    END IF; 	                                           
  
  EXCEPTION
    WHEN Le_Error THEN
      NULL;
    WHEN OTHERS THEN
      P_MENSAJE := SQLERRM ||' - '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
  END VALIDA;

  
end VALIDA_IDENTIFICACION;
/
