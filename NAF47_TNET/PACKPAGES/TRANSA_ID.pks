CREATE OR REPLACE PACKAGE            TRANSA_ID AS

  /**
  * Documentacion para NAF47_TNET.TRANSA_ID
  * Paquete que contiene varias funciones que devuelven un numero para la identificacion de transacciones en los modulos.
  *  Los numeros se generan a partir de secuencias que se crean
  *  dinamicamente por el procedimiento "crea_seqs"
  *  Los numeros generados llevan un sufijo de 2 digitos que identifican
  *  al modulo al que corresponde,  asi por ejemplo, el primer numero
  *  generado para contabilidad es 101, para cheques 102, mientras que
  *  para inventarios es 105, esto con el proposito de asegurar que el
  *  numero de transaccion sea unico para una compania en todo el NAF.
  *  No es conveniente crear logica que realice acciones a partir del
  *  valor del sufijo, pues esos sufijos podrian variar.
  *
  * @author yoveri <yoveri@yoveri.com>
  * @version 1.0 01/01/2007
  */

   -- Crea la secuencia para la compania y modulo indicados en
   -- el parametro.
   PROCEDURE crea_seqs(pCia  varchar2, pModulo varchar2);
   --
   -- --
   FUNCTION  cg(pCia     varchar2) RETURN VARCHAR2;

  /**
  * Documentacion para NAF47_TNET.TRANSA_ID.CK
  * Funcion que genera la secuencia de las transacciones del modulo Bancos
  * @author llindao <yoveri@yoveri.com>
  * @version 1.0 01/01/2007
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 15/04/2019 Se corrige validacion de 6 digitos a 10 que es lo que soporta el campo ARCKCE.NO_SECUENCIA
  */   
   FUNCTION  ck(pCia     varchar2) RETURN VARCHAR2;

  /**
  * Documentacion para NAF47_TNET.TRANSA_ID.CP
  * Funcion que genera la secuencia de las transacciones del modulo Cuentas Por Pagar
  * @author yoveri <yoveri@yoveri.com>
  * @version 1.0 01/01/2007
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 15/04/2019 Se corrige validacion de 6 digitos a 10 que es lo que soporta el campo ARCPMD.NO_DOCU
  */   
   FUNCTION  cp(pCia     varchar2) RETURN VARCHAR2;
   FUNCTION  cc(pCia     varchar2) RETURN VARCHAR2;
   FUNCTION  fa(pCia     varchar2) RETURN VARCHAR2;

  /**
  * Documentacion para NAF47_TNET.TRANSA_ID.IN
  * Funcion que genera la secuencia de las transacciones del modulo Inventarios
  * @author yoveri <yoveri@yoveri.com>
  * @version 1.0 01/01/2007
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 15/04/2019 Se corrige validacion de 6 digitos a 10 que es lo que soporta el campo ARINME.NO_DOCU
  */   
   FUNCTION  inv(pCia    varchar2) RETURN VARCHAR2;
   FUNCTION  co(pCia     varchar2) RETURN VARCHAR2;

  /**
  * Documentacion para NAF47_TNET.TRANSA_ID.AF
  * Funcion que genera la secuencia de las transacciones del modulo Activos Fijos
  * @author yoveri <yoveri@yoveri.com>
  * @version 1.0 01/01/2007
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 15/04/2019 Se corrige validacion de 6 digitos a 10 que es lo que soporta el campo ARAFMA.NO_ACTI
  */   
   FUNCTION  af(pCia     varchar2) RETURN VARCHAR2;

  /**
  * Documentacion para NAF47_TNET.TRANSA_ID.FF
  * Funcion que genera la secuencia de las transacciones del modulo Fondo Fijo
  * @author yoveri <yoveri@yoveri.com>
  * @version 1.0 01/01/2007
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 15/04/2019 Se corrige validacion de 6 digitos a 10 que es lo que soporta el campo TAFFMD.TRANSA_ID
  */   
   FUNCTION  ff(pCia     varchar2) RETURN VARCHAR2;
   FUNCTION  im(pCia     varchar2) RETURN VARCHAR2;

  /**
  * Documentacion para NAF47_TNET.TRANSA_ID.MIGRA_INV
  * Funcion que genera la secuencia de las transacciones del modulo Inventarios
  * @author yoveri <yoveri@yoveri.com>
  * @version 1.0 01/01/2007
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 15/04/2019 Se corrige validacion de 6 digitos a 10 que es lo que soporta el campo ARINME.NO_DOCU
  */   
   FUNCTION  migra_inv(pCia    varchar2) RETURN VARCHAR2;
   FUNCTION  MIGRA_CG(Pv_NoCia Varchar2) RETURN VARCHAR2;
   FUNCTION  MIGRA_CK(Pv_NoCia Varchar2) RETURN VARCHAR2;

   --
   -- ---
   -- Devuelve un numero de identificacion para los movimientos
   -- del extracto bancario
   FUNCTION  banco(pCia  varchar2) RETURN VARCHAR2;
   -- --
   -- Devuelve laa descripcion del ultimo error ocurrido
   FUNCTION  ultimo_error RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20012);
   kNum_error      NUMBER := -20012;
   --
END;  -- transa_id

/


CREATE OR REPLACE PACKAGE BODY            TRANSA_ID AS
  /*******[ PARTE: PRIVADA ]
  * Declaracion de Procedimientos o funciones PRIVADOS
  *
  */
  kIdCG     constant number(2) := 01;     -- Contabilidad General
  kIdCK     constant number(2) := 02;     -- Cheques
  kIdCP     constant number(2) := 03;     -- CxP
  kIdCO     constant number(2) := 04;     -- Compras
  kIdIN     constant number(2) := 05;     -- Inventario
  kIdFA     constant number(2) := 06;     -- Facturacion
  kIdCC     constant number(2) := 07;     -- CxC
  kIdAF     constant number(2) := 08;     -- Activos Fijos
  kIdIM     constant number(2) := 09;     -- Importaciones
  kIdPL     constant number(2) := 10;     -- Planillas
  kIdRH     constant number(2) := 11;     -- Rec. Humanos
  kIdFF     constant number(2) := 12;     -- Caja Chica
  kIdCKB    constant number(2) := 14;     -- Bancos
  kIdMCG    constant number(2) := 15;     -- Migracion Contabilidad
  kIdMCK    constant number(2) := 16;     -- Migracion Bancos

  --
  kErr_creando_seq   constant varchar2(120) := 'Error al crear secuencia';
  kErr_parseando     constant varchar2(120) := 'Error de parse, al crear secuencia';
  kErr_noexiste_seq  constant varchar2(120) := 'No existe la secuencia';
  kErr_generando_num constant varchar2(120) := 'No pudo generar numero en secuencia';
  vMensaje_error     varchar2(120);
  --
  PROCEDURE limpia_error IS
  BEGIN
    vMensaje_error := NULL;
  END;
  --
  PROCEDURE genera_error(msj_error IN VARCHAR2)IS
  BEGIN
    vMensaje_error := msj_error;
    RAISE_APPLICATION_ERROR(kNum_error, msj_error);
  END;
  --
  --
  PROCEDURE crea_secuencia(
    pnom_seq      varchar2
  ) IS
    vdummy        varchar2(1);
    vfound        boolean;
    vNumero       number;
    vnom_seq      varchar2(30);
    vIdcursor     integer;
    vResultExec   integer;
    vLang_flag    integer:= 1;
    --
    CURSOR c_seq(pnom_seq varchar2) IS
      SELECT 'S'
        FROM seq
       WHERE sequence_name = pnom_seq;
  BEGIN
    limpia_error;
    vnom_seq  := pnom_seq;
    -- --
    -- Valida que la secuencia existe
    --
    OPEN  c_seq(vnom_seq);
    FETCH c_seq INTO vdummy;
    vfound := c_seq%FOUND;
    CLOSE c_seq;
    IF NOT vFound THEN
      BEGIN
        vidCursor := dbms_sql.open_cursor;
        dbms_sql.parse(vidCursor, 'CREATE SEQUENCE '||vnom_seq||
                                  ' INCREMENT BY 1'||
                                  ' START WITH 1'||
                                  ' NOCACHE',   vLang_flag);
        IF dbms_sql.last_error_position > 0 then
           genera_error(kErr_parseando||': '||vnom_seq);
        end if;
        vResultExec := dbms_sql.execute(vIdCursor);
      EXCEPTION
       WHEN OTHERS THEN
          IF dbms_sql.is_open(vidCursor) THEN
             dbms_sql.close_cursor(vIdCursor);
          END IF;
          genera_error('crea_seq: '||sqlerrm);
      END; -- crea_secuencia
      --
      IF dbms_sql.is_open(vidCursor) THEN
         dbms_sql.close_cursor(vIdCursor);
      END IF;
      --
      -- verifica que haya sido crea la secuencia
      OPEN c_seq(vnom_seq);
      FETCH c_seq INTO vdummy;
      vfound := c_seq%FOUND;
      CLOSE c_seq;
      --
      if not vFound then
         genera_error(kErr_creando_seq||': '||vnom_seq);
      end if;
    END IF;
  END;  -- crea_seq
  --
  --
  FUNCTION siguiente_numero(
    pnom_seq      varchar2
  ) RETURN NUMBER IS
    vdummy        varchar2(1);
    vfound        boolean;
    vNumero       number;
    vnom_seq      varchar2(30);
    vIdcursor     INTEGER;
    vResultExec   INTEGER;
    vLang_flag    INTEGER:= 1;
    --
    CURSOR c_seq(pnom_seq varchar2) IS
      SELECT 'S'
      FROM seq
      WHERE sequence_name = pnom_seq;
  BEGIN
    limpia_error;
    vnumero   := NULL;
    vnom_seq  := pnom_seq;
    -- --
    -- Valida que la secuencia existe
    --
    OPEN c_seq(vnom_seq);
    FETCH c_seq INTO vdummy;
    vfound := c_seq%FOUND;
    CLOSE c_seq;
    -- --
    -- Obtiene el siguiente numero en la secuencia
    IF not vFound THEN
      -- ---
      -- NOTA: la creacion de la secuencia NO DEBE hacer aqui, pues
      --       la instruccion de creacion (DDL) tiene un COMMIT implicito
      --
      genera_error(kErr_noexiste_seq||': '||vnom_seq);
    ELSE
      vIdCursor := NULL;
      BEGIN
         vidCursor := dbms_sql.open_cursor;
         dbms_sql.parse(vIdCursor,
                        'SELECT '||vnom_seq||'.NEXTVAL FROM DUAL', vLang_flag);
         dbms_sql.define_column(vidCursor, 1, vNumero);
         vResultExec := dbms_sql.execute_and_fetch(vidCursor);
         dbms_sql.column_value(vIdCursor, 1, vNumero);
      EXCEPTION
         WHEN OTHERS THEN
           NULL;
      END; -- siguiente_valor
      IF dbms_sql.is_open(vidCursor) THEN
         dbms_sql.close_cursor(vIdCursor);
      END IF;
    END IF;
    RETURN (vNumero);
  END;  -- siguiente_numero
  --
  --
  /*******[ PARTE: PUBLICA ]
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
  PROCEDURE crea_seqs(
     pCia     varchar2,
     pModulo  varchar2
  ) IS
  BEGIN
    if pModulo = 'CG' then
       crea_secuencia( 'TRANSAID_CG'||pCia );
    elsif pModulo = 'CK' then
       crea_secuencia( 'TRANSAID_CK'||pCia );
       crea_secuencia( 'TRANSAID_BANCO'||pCia );
    elsif pModulo = 'CP' then
       crea_secuencia( 'TRANSAID_CP'||pCia );
    elsif pModulo = 'CC' then
       crea_secuencia( 'TRANSAID_CC'||pCia );
    elsif pModulo = 'FA' then
       crea_secuencia( 'TRANSAID_FA'||pCia );
    elsif pModulo = 'INV' then
       crea_secuencia( 'TRANSAID_IN'||pCia );
       crea_secuencia( 'TRANSAID_MGIN'||pCia );
    elsif pModulo = 'AF' then
       crea_secuencia( 'TRANSAID_AF'||pCia );
    elsif pModulo = 'FF' then
       crea_secuencia( 'TRANSAID_FF'||pCia );
    elsif pModulo = 'IM' then
       crea_secuencia( 'TRANSAID_IM'||pCia );
    elsif pModulo = 'CO' then
       crea_secuencia( 'TRANSAID_CO'||pCia );
    elsif pModulo = 'MGCG' then
       crea_secuencia( 'TRANSAID_MGCG'||pCia );
    elsif pModulo = 'MGCK' then
       crea_secuencia( 'TRANSAID_MGCK'||pCia );
    else
       genera_error('No esta implementada la creacion de secuencia para: '||pModulo);
    end if;
  END;  -- crea_seqs
  --
  --
  FUNCTION  cg(pCia     varchar2) RETURN VARCHAR2 IS
    vConsec    number;
  BEGIN
    vConsec := siguiente_numero( 'TRANSAID_CG'||pCia );
    vConsec := (vConsec * 100) + kIdCG;
    RETURN ( TO_CHAR(vConsec) );
  END; -- cg
  --
  --
  FUNCTION  ck(pCia     varchar2) RETURN VARCHAR2 IS
    vConsec  number;
    vVuelta  number(3);
  BEGIN
    vConsec := siguiente_numero( 'TRANSAID_CK'||pCia );
    -- lo siguiente solo es necesario si largo de no_secuencia es 8
    if vConsec > 999999 then
       vVuelta := trunc(vConsec/1000000);
       vConsec := greatest(1,mod(vConsec,1000000));
       vConsec := (vConsec * 100) + 30 + (kIdCk * vVuelta);
    else
       vConsec := (vConsec * 100) + kIdCK;
    end if;
    RETURN ( TO_CHAR(vConsec) );
  END; -- ck
  --
  --
  FUNCTION  banco(pCia  varchar2) RETURN VARCHAR2 IS
      vConsec  number;
      vVuelta  number(3);
  BEGIN
      vConsec := siguiente_numero( 'TRANSAID_BANCO'||pCia);
      if vConsec > 999999 then
         vVuelta := trunc(vConsec/1000000);
         vConsec := greatest(1,mod(vConsec,1000000));
         vConsec := (vConsec * 100) + 30 + (kIdCKB * vVuelta);
      else
         vConsec := (vConsec * 100) + kIdCKB;
      end if;
      RETURN ( TO_CHAR(vConsec) );
  END;
  --
  --
  FUNCTION  cp(pCia     varchar2) RETURN VARCHAR2 IS
    vConsec    number;
    vVuelta    number(3);
  BEGIN
    vConsec := siguiente_numero( 'TRANSAID_CP'||pCia );
    if vConsec > 999999 then
       vVuelta := trunc(vConsec/1000000);
       vConsec := greatest(1,mod(vConsec,1000000));
       vConsec := (vConsec * 100) + 30 + (kIdCP * vVuelta);
    else
       vConsec := (vConsec * 100) + kIdCP;
    end if;
    RETURN ( TO_CHAR(vConsec) );
  END; -- cp
  --
  --
  FUNCTION  cc(pCia     varchar2) RETURN VARCHAR2 IS
    vConsec    number;
  BEGIN
    vConsec := siguiente_numero( 'TRANSAID_CC'||pCia );
    vConsec := (vConsec * 100) + kIdCC;
    RETURN ( TO_CHAR(vConsec) );
  END; -- cc
  --
  --
  FUNCTION  fa(pCia     varchar2) RETURN VARCHAR2 IS
    vConsec    number;
    vVuelta    number(3);
  BEGIN
    vConsec := siguiente_numero( 'TRANSAID_FA'||pCia );
    vConsec := (vConsec * 100) + kIdFA;
    RETURN ( TO_CHAR(vConsec) );
  END; -- fa
  --
  --
  FUNCTION  inv(pCia     varchar2) RETURN VARCHAR2 IS
    vConsec    number;
    vVuelta    number(3);
  BEGIN
    -- No debe tener una longitud mayor a 8 por posible interfaz con cxp
    vConsec := siguiente_numero( 'TRANSAID_IN'||pCia );
    if vConsec > 9999999999 then
       vVuelta := trunc(vConsec/1000000);
       vConsec := greatest(1,mod(vConsec,1000000));
       vConsec := (vConsec * 100) + 30 + (kIdIN * vVuelta);
    else
       vConsec := (vConsec * 100) + kIdIN;
    end if;
    RETURN ( TO_CHAR(vConsec) );
  END;   -- inv
  --
  --
  FUNCTION  co(pCia     varchar2) RETURN VARCHAR2 IS
    vConsec  number;
    vVuelta  number(3);
  BEGIN
    vConsec := siguiente_numero( 'TRANSAID_CO'||pCia );
    -- lo siguiente solo es necesario si largo de no_secuencia es 8
    if vConsec > 999999 then
       vVuelta := trunc(vConsec/1000000);
       vConsec := greatest(1,mod(vConsec,1000000));
       vConsec := (vConsec * 100) + 30 + (kIdCO * vVuelta);
    else
       vConsec := (vConsec * 100) + kIdCO;
    end if;
    RETURN ( TO_CHAR(vConsec) );
  END; --  Compras
  --
  --
  FUNCTION  af(pCia     varchar2) RETURN VARCHAR2 IS
     vConsec    number;
     vVuelta  number(3);
   BEGIN
     vConsec := siguiente_numero( 'TRANSAID_AF'||pCia );
     if vConsec > 999999 then
        vVuelta := trunc(vConsec/1000000);
        vConsec := greatest(1,mod(vConsec,1000000));
        vConsec := (vConsec * 100) + 30 + (kIdAF * vVuelta);
     else
        vConsec := (vConsec * 100) + kIdAF;
     end if;
     RETURN ( TO_CHAR(vConsec) );
   END; -- af
   --
   --
   FUNCTION  ff(pCia     varchar2) RETURN VARCHAR2 IS
     vConsec    number;
     vVuelta    number(3);
   BEGIN
     vConsec := siguiente_numero( 'TRANSAID_FF'||pCia );
     if vConsec > 999999 then
        vVuelta := trunc(vConsec/1000000);
        vConsec := greatest(1,mod(vConsec,1000000));
        vConsec := (vConsec * 100) + 30 + (kIdFF * vVuelta);
     else
        vConsec := (vConsec * 100) + kIdFF;
     end if;
     RETURN ( TO_CHAR(vConsec) );
   END; -- ch
   --
   --
   FUNCTION  im(pCia     varchar2) RETURN VARCHAR2 IS
     vConsec    number;
   BEGIN
     vConsec := siguiente_numero( 'TRANSAID_IM'||pCia );
     vConsec := (vConsec * 100) + kIdIM;
     RETURN ( TO_CHAR(vConsec) );
   END;
   --
   --

     -- ======================== --
  -- migracion de inventarios --
  -- ======================== --
  FUNCTION  migra_inv(pCia     varchar2) RETURN VARCHAR2 IS
    vConsec    number;
    vVuelta    number(3);
  BEGIN
    -- No debe tener una longitud mayor a 8 por posible interfaz con cxp
    vConsec := siguiente_numero( 'TRANSAID_MGIN'||pCia );
    if vConsec > 9999999999 then
       vVuelta := trunc(vConsec/1000000);
       vConsec := greatest(1,mod(vConsec,1000000));
       vConsec := (vConsec * 100) + 30 + (kIdIN * vVuelta);
    else
       vConsec := (vConsec * 100) + kIdIN;
    end if;
    RETURN ( TO_CHAR(vConsec) );
  END;   -- inv
  /**
  * Documentacion para el funcion MIGRA_CG
  * Funcion que recupera el secuencial para tabla migra contabilidad
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 04-10-2016
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 20-06-2017  Se modifica para cambiar formato secuencia porque coincide con otras secuencias ya generadas por sistemas SIT / TELCOS
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 27-07-2017  Se modifica para retomar formatos secuencia de NAF en tablas de migracion Contabilidad
  */
  FUNCTION  MIGRA_CG(Pv_NoCia Varchar2) RETURN VARCHAR2 IS
    Ln_Secuencia Number;
  BEGIN
    Ln_Secuencia := siguiente_numero( 'TRANSAID_MGCG'||Pv_NoCia );
    Ln_Secuencia := (Ln_Secuencia * 100) + kIdMCG;
    RETURN ( TO_CHAR(Ln_Secuencia) );
 END; 
    /**
  * Documentacion para el funcion MIGRA_CK
  * Funcion que recupera el secuencial para tabla migra bancos
  * @author Sofia Fernandez <sfernandez@telconet.ec>
  * @version 1.0 04-10-2016
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 20-06-2017  Se modifica para cambiar formato secuencia porque coincide con otras secuencias ya generadas por sistemas SIT / TELCOS
  *
  * @author Luis Lindao <llindao@telconet.ec>
  * @version 1.1 27-07-2017  Se modifica para retomar formatos secuencia de NAF en tablas de migracion bancos
  */
  FUNCTION  MIGRA_CK(Pv_NoCia Varchar2) RETURN VARCHAR2 IS
    Ln_Secuencia Number;
  BEGIN
    Ln_Secuencia := siguiente_numero( 'TRANSAID_MGCK'||Pv_NoCia );
    Ln_Secuencia := (Ln_Secuencia * 100) + kIdMCK;
    RETURN ( TO_CHAR(Ln_Secuencia) );
  END; 



END;  -- transa_id

/
