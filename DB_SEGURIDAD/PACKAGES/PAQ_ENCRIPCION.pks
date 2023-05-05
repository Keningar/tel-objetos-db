CREATE EDITIONABLE PACKAGE              PAQ_ENCRIPCION AS
   PROCEDURE PROC_ENCRIPTAR( TXT_ENCRIP VARCHAR2, KEY_ENCRIP  VARCHAR2, VALOR_ENCRIPTADO out RAW);
   PROCEDURE PROC_DESCENCRIPTAR( TXT_DESENCRIP VARCHAR2, KEY_ENCRIP VARCHAR2, VALOR_DESCENCRIPTADO out VARCHAR2);
       
END PAQ_ENCRIPCION;
/
-- new object type path: SCHEMA_EXPORT/PACKAGE/PACKAGE_BODY
CREATE EDITIONABLE PACKAGE BODY                                        PAQ_ENCRIPCION AS
   CRYPT_RAW   RAW(2000);--tipo de datos utilizado para almacenar datos binarios
   CRYPT_STR   VARCHAR(2000);      
   
 /*************************************************************************************
 * PAQUETE QUE CONTIENE FUNCIONES PARA ENCRIPTACION Y
 * DESCENCRIPTACION.
 * CONTIENE LAS UTILIDADES DE ENCRIPCION Y DESENCRIPCION. 
 * ESQUEMA  : UTIL
 * RECIBE POR PARAMETRO LA CADENA A ENCRIPTAR Y DESCENCRIPTAR Y LA LLAVE DE ENCRIPCION
 * PARAMETROS DE SALIDA TEXTOS ENCRIPTADOS Y DESCENCRIPTADOS
  ***************************************************************************************/
  --Procedimiento Encripta 
  PROCEDURE PROC_ENCRIPTAR( TXT_ENCRIP VARCHAR2 ,KEY_ENCRIP VARCHAR2, VALOR_ENCRIPTADO out RAW) is
      L        INTEGER := LENGTH(TXT_ENCRIP);
      I        INTEGER;
      PADBLOCK RAW(2000);--tipo de datos utilizado para almacenar datos binarios
      CLE      RAW(50)  := UTL_RAW.CAST_TO_RAW(KEY_ENCRIP);
      errorProcedure exception;
      nameProcedure varchar2(100) := 'PAQ_ENCRIPCION.PROC_ENCRIPTAR';
      MENSAJE VARCHAR2(100);
     BEGIN
     MENSAJE:='Proceso de Encriptacion de cuenta';
      I := 8-MOD(L,8);
      --function CAST_TO_RAW converts the VARCHAR2 input string into a raw datatype. The data is not altered; only the data type is changed.
      PADBLOCK := UTL_RAW.CAST_TO_RAW(TXT_ENCRIP||RPAD(CHR(I),I,CHR(I)));
      
      DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(
               INPUT          => PADBLOCK,
               KEY            => CLE,
               ENCRYPTED_DATA => CRYPT_RAW );
       VALOR_ENCRIPTADO:= CRYPT_RAW ;               
      if (CRYPT_RAW IS NOT NULL) then               
           VALOR_ENCRIPTADO:= CRYPT_RAW ;
      else
         raise errorProcedure;
      end if;
      
      Exception
     WHEN OTHERS THEN     
      DB_COMERCIAL.Util.PRESENTAERROR(SQLCODE, SQLERRM, 1 , MENSAJE , NAMEPROCEDURE );
      
   END;
   
   --Procedimiento Descencripta
   PROCEDURE PROC_DESCENCRIPTAR( TXT_DESENCRIP VARCHAR2 ,KEY_ENCRIP VARCHAR2,VALOR_DESCENCRIPTADO out VARCHAR2) is
   L          NUMBER;
   CLE        RAW(50)    := UTL_RAW.CAST_TO_RAW('c69555ab183de6672b1ebf6100bbed59186a5d72');
   CRYPT_RAW  RAW(2000) := UTL_RAW.CAST_TO_RAW(UTL_RAW.CAST_TO_VARCHAR2( TXT_DESENCRIP)) ;
   errorProcedure exception;
   nameProcedure varchar2(100) := 'PAQ_ENCRIPCION.PROC_DESCENCRIPTAR';
   MENSAJE VARCHAR2(100);
   BEGIN
   MENSAJE:='Proceso de Descencriptacion de cuenta';
      DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(
               INPUT          =>  TXT_DESENCRIP,
               KEY            =>  CLE,
               DECRYPTED_DATA =>  CRYPT_RAW );
      CRYPT_STR := UTL_RAW.CAST_TO_VARCHAR2(CRYPT_RAW);
      L := LENGTH(CRYPT_STR);
      CRYPT_STR := RPAD(CRYPT_STR,L-ASCII(SUBSTR(CRYPT_STR,L)));
      VALOR_DESCENCRIPTADO:= CRYPT_STR;
      if (CRYPT_STR IS NOT NULL) then               
           VALOR_DESCENCRIPTADO:= CRYPT_STR ;
      else
         raise errorProcedure;
      end if;
      
      Exception
     WHEN OTHERS THEN     
      DB_COMERCIAL.Util.PRESENTAERROR(SQLCODE, SQLERRM, 1 , MENSAJE , NAMEPROCEDURE );
      
   END;
END PAQ_ENCRIPCION;

/**********************************
 * Ejecutar en DB_SEGURIDAD
 **********************************/
/
