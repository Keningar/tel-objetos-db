CREATE OR REPLACE procedure DB_COMERCIAL.EscapaCaracteresEspeciales(v_cadena IN VARCHAR2, v_cadena_limpia out VARCHAR2) IS  
  v_caracteres_orig  VARCHAR2(60);
  v_caracteres_reemp VARCHAR2(60);
  errorProcedure exception;
  nameProcedure varchar2(100) := 'DB_COMERCIAL.EscapaCaracteresEspeciales';
  MENSAJE VARCHAR2(100);
   /**
  * Documentacion para procedure EscapaCaracteresEspeciales
  * Especificacion: Procedure que permite quitar los caracteres especiales del login formado por punto cliente
  * caracteres permitidos [^A-Za-z0-9_-]
  * @author Anabelle Penaherrera <apenaherrera@telconet.ec>
  * @version 1.0 05-08-2015
  */
BEGIN
 MENSAJE:='Proceso quita los caracteres especiales del login formado por Punto Cliente';
 v_caracteres_orig  := '������������������������������������������������';
 v_caracteres_reemp := 'naeiouaeiouaoaeiooaeioucNAEIOUAEIOUAOAEIOOAEIOUC';
 v_cadena_limpia           := lower(TRANSLATE(v_cadena,v_caracteres_orig,v_caracteres_reemp));
              
 SELECT
  REGEXP_REPLACE(v_cadena_limpia, '[^A-Za-z0-9_-]', '') into v_cadena_limpia
 FROM dual;
 if v_cadena_limpia is NULL then
     raise errorProcedure;
 end if;
 Exception
     WHEN OTHERS THEN     
      DB_COMERCIAL.Util.PRESENTAERROR(SQLCODE, SQLERRM, 1 , MENSAJE , NAMEPROCEDURE );
END;
/