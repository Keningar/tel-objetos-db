CREATE OR REPLACE PACKAGE            PKG_CODIGOS_ALTERNATIVOS AS
  FUNCTION CODIGO_CLASE(pIndice VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_CATEGORIA(pIndice VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGOS_ALTERNOS_CLASES RETURN VARCHAR2;
  FUNCTION CODIGOS_ALTERNOS_CATEGORIAS RETURN VARCHAR2;
END;
/


CREATE OR REPLACE PACKAGE BODY            PKG_CODIGOS_ALTERNATIVOS AS

-----------CODIGOS ALTERNOS ARINCAT (CATEGORIA)-----------
FUNCTION CODIGO_CATEGORIA(pIndice VARCHAR2) RETURN VARCHAR2 IS
  vNumber ARINCAT.CODIGO%TYPE;
BEGIN
SELECT Upper(pIndice||To_Char(Nvl(Max(CODIGOS),0)+1)) NEWCOD
INTO vNumber
FROM(
SELECT To_Number(
REPLACE(
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(
                        REPLACE(
                          REPLACE(
                            REPLACE(
                              REPLACE(
                                REPLACE(
                                  REPLACE(
                                    REPLACE(
                                      REPLACE(
                                        REPLACE(
                                          REPLACE(
                                            REPLACE(
                                              REPLACE(
                                                REPLACE(
                                                  REPLACE (
                                                    REPLACE(CODIGO, Upper(pIndice))
                                                    , 'A')
                                                  , 'B')
                                                , 'C')
                                              , 'D')
                                            , 'E')
                                          , 'F')
                                        , 'G')
                                      , 'H')
                                    , 'I')
                                , 'J')
                              , 'K')
                            , 'L')
                          , 'M')
                        , 'N')
                      , 'O')
                    , 'P')
                  , 'Q')
                , 'R')
              , 'S')
            , 'T')
          , 'U')
        , 'V')
      , 'W')
    , 'X')
  , 'Y')
, 'Z')
, '999') CODIGOS FROM ARINCAT
WHERE Trim (Upper(CODIGO)) LIKE Upper(pIndice||'%')
ORDER BY (CODIGOS) ASC
);
RETURN vNumber;
--DBMS_OUTPUT.PUT_LINE(vNumber);
EXCEPTION
  WHEN OTHERS THEN
    IF (SQLCODE = '-6502') THEN
      DBMS_OUTPUT.PUT_LINE('El codigo siguiente supera el tama?o del campo de la base de datos pruebe con otro codigo ');
      ELSE
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END IF;
    RETURN '';
END;
-----------CODIGOS ALTERNOS ARINCA (CLASE)-----------

FUNCTION CODIGO_CLASE(pIndice VARCHAR2) RETURN VARCHAR2 IS
  vNumber ARINCA.CODIGO%TYPE;
BEGIN
SELECT Upper(pIndice||To_Char(Nvl(Max(CODIGOS),0)+1)) NEWCOD
INTO vNumber
FROM(
SELECT To_Number(
REPLACE(
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(
                        REPLACE(
                          REPLACE(
                            REPLACE(
                              REPLACE(
                                REPLACE(
                                  REPLACE(
                                    REPLACE(
                                      REPLACE(
                                        REPLACE(
                                          REPLACE(
                                            REPLACE(
                                              REPLACE(
                                                REPLACE(
                                                  REPLACE (
                                                    REPLACE(CODIGO, Upper(pIndice))
                                                    , 'A')
                                                  , 'B')
                                                , 'C')
                                              , 'D')
                                            , 'E')
                                          , 'F')
                                        , 'G')
                                      , 'H')
                                    , 'I')
                                , 'J')
                              , 'K')
                            , 'L')
                          , 'M')
                        , 'N')
                      , 'O')
                    , 'P')
                  , 'Q')
                , 'R')
              , 'S')
            , 'T')
          , 'U')
        , 'V')
      , 'W')
    , 'X')
  , 'Y')
, 'Z')
, '999') CODIGOS FROM ARINCA
WHERE Trim (Upper(CODIGO)) LIKE Upper(pIndice||'%')
ORDER BY (CODIGOS) ASC
);
RETURN vNumber;
EXCEPTION
  WHEN OTHERS THEN
    IF (SQLCODE = '-6502') THEN
      DBMS_OUTPUT.PUT_LINE('El codigo siguiente supera el tama?o del campo de la base de datos pruebe con otro codigo ');
      ELSE
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END IF;
    RETURN NULL;
END;


--BUSCAMOS CODIGOS ALTERNOS CATEGORIAS
FUNCTION CODIGOS_ALTERNOS_CATEGORIAS RETURN VARCHAR2 IS
TYPE vVector IS VARRAY(26) OF VARCHAR2(1);
vLetras vVector;
vCodAlt ARINCA.CODIGO%TYPE;
vCodigos VARCHAR2(30);
vCont NUMBER;
BEGIN
vLetras := vVector('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
vCodAlt := NULL;
vCodigos:= NULL;
vCont := 0;
FOR I IN 1..26 LOOP
  vCodAlt := CODIGO_CATEGORIA(vLetras(I));
  IF (vCodAlt IS NOT NULL) THEN
    vCont := vCont + 1;
    vCodigos := vCodigos||vCodAlt;
    IF (vCont = 3) THEN
      EXIT;
    ELSE
      vCodigos := vCodigos||' - ';
    END IF;
  END IF;
END LOOP;
  RETURN Trim(vCodigos);
END;

--BUSCAMOS CODIGOS ALTERNOS CLASES
FUNCTION CODIGOS_ALTERNOS_CLASES RETURN VARCHAR2 IS
TYPE vVector IS VARRAY(26) OF VARCHAR2(1);
vLetras vVector;
vCodAlt ARINCA.CODIGO%TYPE;
vCodigos VARCHAR2(30);
vCont NUMBER;
BEGIN
vLetras := vVector('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
vCodAlt := NULL;
vCodigos:= NULL;
vCont := 0;
FOR I IN 1..26 LOOP
  vCodAlt := CODIGO_CLASE(vLetras(I));
  IF (vCodAlt IS NOT NULL) THEN
    vCont := vCont + 1;
    vCodigos := vCodigos||vCodAlt;
    IF (vCont = 3) THEN
      EXIT;
    ELSE
      vCodigos := vCodigos||' - ';
    END IF;
  END IF;
END LOOP;
  RETURN Trim(vCodigos);
END;



END PKG_CODIGOS_ALTERNATIVOS;
/
