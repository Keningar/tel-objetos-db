CREATE OR REPLACE PACKAGE            plantilla IS
  -- ---
  --  Este paquete sirve como plantilla para la creacion de otros paquetes.
  --

/*
  Especificacion de los procedimientos y funciones del paquete.
  PROCEDURE zzz (
    a varchar2,
    b varchar2
  );

  FUNCTION yyy (
    a varchar2,
    c number
  ) return boolean;

*/

  --
  --
  FUNCTION ultimo_error RETURN VARCHAR2 ;
  --
  error           EXCEPTION;
  -- ***** este numero debe actualizarse con base en el archivo NOMBRES.xls ****
  PRAGMA          EXCEPTION_INIT(error, -20035);
  kNum_error      NUMBER := -20035;
END;  -- plantilla
/


CREATE OR REPLACE PACKAGE BODY            plantilla IS
   /*******[ PARTE: PRIVADA ]  ****************
   * Declaracion de Procedimientos o funciones PRIVADOS
   */
   vMensaje_error       VARCHAR2(160);
   PROCEDURE limpia_error IS
   BEGIN
      vMensaje_error := NULL;
   END;
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := substr(msj_error,1,160);
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;


   --
   /*******[ PARTE: PUBLICA ] *************************
   * Declaracion de Procedimientos o funciones PUBLICAS
   *
   */
   --
   FUNCTION ultimo_error RETURN VARCHAR2 IS
   BEGIN
     RETURN(vMensaje_error);
   END ultimo_error;
   --
   --
/*
  PROCEDURE zzz (
    a varchar2,
    b varchar2
  ) IS
  BEGIN
    null;
  END ;

  FUNCTION yyy (
    a varchar2,
    c number
  ) RETURN boolean IS
  BEGIN
    return(true);
  END ;
*/
   --
   --
END;  -- Plantilla BODY
/
