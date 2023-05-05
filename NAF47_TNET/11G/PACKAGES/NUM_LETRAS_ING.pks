CREATE OR REPLACE PACKAGE            num_letras_ing AS
   -- ---
   --
FUNCTION Unidades (unidad IN NUMBER)
                           RETURN VARCHAR2;
-- Convierte los numero desde 0 hasta 9 a letras
FUNCTION decenas (decena IN NUMBER)
                          RETURN VARCHAR2;
-- Convierte numeros de dos digitos a letras
FUNCTION nombre_decenas (digito IN NUMBER)
                          RETURN VARCHAR2;
FUNCTION cientos (cien IN NUMBER)
 RETURN VARCHAR2;
FUNCTION numero_a_Letras ( numero     in out NUMBER)
                          RETURN VARCHAR2;
END num_letras_ing;
/


CREATE OR REPLACE PACKAGE BODY            num_letras_ing IS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
FUNCTION cientos (cien IN NUMBER) RETURN VARCHAR2 IS
-- convierte numeros de tres o menos digitos as letras

BEGIN
    if cien = 1 then  -- Estos son casos especiales del 10 a 15
      return('ONE HUNDRED ');
    elsif cien = 2 then
      return('TWO HUNDRED ');
    elsif cien = 3 then
      return('THREE HUNDRED ');
    elsif cien = 4 then
      return('FOUR HUNDRED ');
    elsif cien = 5 then
      return('FIVE HUNDRED ');
    elsif cien = 6 then
      return('SIX HUNDRED ');
    elsif cien = 7 then
      return('SEVEN HUNDRED ');
    elsif cien = 8 then
      return('EIGHT HUNDRED ');
    elsif cien = 9 then
      return('NINE HUNDRED ');
    ELSE
    return('');
  end if;
END;

FUNCTION Unidades (unidad IN NUMBER) RETURN VARCHAR2 IS
-- Convierte los numero desde 0 hasta 9 a letras
BEGIN

  if unidad = 1 then
    return('ONE');
  elsif unidad = 2 then
    return('TWO');
  elsif unidad = 3 then
    return('THREE');
  elsif unidad = 4 then
    return('FOUR');
  elsif unidad = 5 then
    return('FIVE');
  elsif unidad = 6 then
    return('SIX');
  elsif unidad = 7 then
    return('SEVEN');
  elsif unidad = 8 then
    return('EIGHT');
  elsif unidad = 9 then
    return('NINE');
  elsif unidad = 10 then
    return('TEN');
  else
    return('');
  end if;
END;
FUNCTION decenas (decena IN NUMBER) RETURN VARCHAR2 IS
-- Convierte numeros de dos digitos a letras

BEGIN
    if decena = 1 then  -- Estos son casos especiales del 10 a 15
      return('ELEVEN');
    elsif decena = 2 then
      return('TWELVE');
    elsif decena = 3 then
      return('THIRTEEN');
    elsif decena = 4 then
      return('FOURTEEN');
    elsif decena = 5 then
      return('FIFTEEN');
    elsif decena = 6 then
      return('SIXTEEN');
    elsif decena = 7 then
      return('SEVENTEEN');
    elsif decena = 8 then
      return('EIGHTEEN');
    elsif decena = 9 then
      return('NINETEEN');
    ELSE
    return('');
  end if;
END;

FUNCTION nombre_decenas (digito IN NUMBER) RETURN VARCHAR2 IS
BEGIN
  if digito = 1 then
    return('TEN');
  elsif digito = 2 then
    return('TWENTY');
  elsif digito = 3 then
    return('THIRTY');
  elsif digito = 4 then
    return('FORTY');
  elsif digito = 5 then
    return('FIFTY');
  elsif digito = 6 then
    return('SIXTY');
  elsif digito = 7 then
    return('SEVENTY');
  elsif digito = 8 then
    return('EIGHTY');
  elsif digito = 9 then
    return('NINETY');
  else
    return('');
  end if;
END;

FUNCTION numero_a_Letras (
  numero     in out NUMBER
) RETURN VARCHAR2
IS
  temp        NUMBER(10,2);

 -- mst1        varchar2(100);
  --mst2        varchar2(100);
  ind         number(2);
 -- Mst2 :=lpad(mst2,length(mst2),'=');
  mST         varchar2(100);
 -- mst := lpad(mst,length(mst),' ');
  val2        varchar2(14):=To_char(numero,'9999999999.99');
  IND2 NUMBER;
  centavos number;
  Wlong  number :=100;
 -- wlong2 number:=100;
 -- xlargo number;
 -- conta  number;
BEGIN
 temp := trunc(numero);
 centavos:= numero - temp;
 IF temp  > 999999999.99 THEN      --    999.999.999
      IF temp  BETWEEN 1000000000 AND 1000999999 THEN
         IND := Substr(val2,1,2);
         IF IND > 0 THEN
             mST := mST || UNIDADES(IND);
         END IF;
      ELSE
         IND2 := 0;
         IF  TEMP BETWEEN  10000000000 AND  10000999999 THEN
            IND := to_NUMBER(SUBSTR(val2,1,1));
            IF IND > 0 THEN
               mST := mST || DECENAS(IND);
            END IF;
            mST := mST || ' THOUSAND MILLONS ';
         ELSE
            IND := To_NUMBER(SUBSTR(val2,1,1));
            IND2 := To_NUMBER(SUBSTR(val2,2,1));
            IF IND = 1 AND IND2 > 0 AND IND2 < 10 Then
               mST := mST || NOMBRE_DECENAS(IND2);
            ELSE
               IF IND > 0 Then
                  mST := mST || DECENAS(IND);
                  IF IND2 > 0 Then
                     mST := mST || ' ' || UNIDADES(IND2);
                  END IF;
               ELSE
                  IF IND2 > 0 Then
                     mST := mST || UNIDADES(IND2);
                  END IF;
               END IF;
            END IF;
            mST := mST || ' THOUSAND ';
         END IF;
         IND := (IND * 10) +  IND2;
         Numero := TEMP - (ind*1000000000);
      END IF;
   END IF;

   IF numero > 99999999.99 Then
      IND := to_number(substr(val2,3,1));
      IF IND > 0 Then
         mST := mST || Cientos(IND);
         IF SUBSTR(val2,4,2) <> '00' AND IND = 1 Then
            mST := mST; -- && +  'TO '
         ELSE
            IF SUBSTR(val2,4,2) = '00' THEN
               mst := mst || ' MILLONS ';
            END IF;
         END IF;
         NUMERO := NUMERO - (IND * 100000000 );
      END IF;
   END IF;

   IF NUMERO > 999999.99 THEN
      IF NUMERO < 10000000 THEN
         IND := TO_NUMBER(SUBSTR(val2,4,2));
         IF IND > 0 THEN
            mST := mST || UNIDADES(IND);
         END IF;
      ELSE
         IND := TO_NUMBER(SUBSTR(val2,4,1));
         IND2 := TO_NUMBER(SUBSTR(val2,5,1));
         IF IND = 1 AND IND2 > 0 AND IND2 < 10 THEN
            mST := mST || NOMBRE_DECENAS(IND2);
         ELSE
            IF IND > 0 THEN
               mST := mST || DECENAS(IND);
               IF IND2 > 0 THEN
                  mST := mST || ' ' || UNIDADES(IND2);
               END IF;
            else
               IF IND2 > 0 THEN
                  mST := mST || UNIDADES(IND2);
               END IF;
            END IF;
         END IF;
      END IF;
      IND := TO_NUMBER(SUBSTR(val2,4,2));
      IF NUMERO BETWEEN 1000000 AND 1999999 THEN
         mST := mST || ' MILLON ';
      ELSE
      mst := mst || ' MILLONS ';
      END IF;
      NUMERO := NUMERO - (ind*1000000);
   END IF;

   IF NUMERO > 99999.99 THEN
      IND := TO_NUMBER(SUBSTR(val2,6,1));
      IF IND > 0 THEN
         mST := mST || CIENTOS(IND);
         IF SUBSTR(val2,7,2) <> '00' AND IND = 1 THEN
            mST := mST; --    &&  +  'TO '
         END IF;
         IF SUBSTR(val2,7,2) = '00' THEN
            mst := mst || ' THOUSAND ';
         END IF;
         NUMERO := NUMERO - (IND * 100000 );
      END IF;
   END IF;
   IF temp > 999.99 then
      IF temp < 10000 then
         IND := to_number(SUBSTR(val2,7,2));
         IF IND > 0 then
            mST := mST || UNIDADES(IND);
         END IF;
      ELSE
         IND := to_number(SUBSTR(val2,7,1));
         IND2 := to_number(SUBSTR(val2,8,1));
         IF IND = 1 AND IND2 > 0 AND IND2 < 10 Then
            mST := mST || DECENAS(IND2);
         ELSE
            IF IND > 0 then
               mST := mST || nombre_decenas(IND);
            END IF;
            IF IND2 > 0 Then
               mST := mST || ' ' || UNIDADES(IND2);
            END IF;
         END IF;
      END IF;
      IND := TO_NUMBER(SUBSTR(val2,7,2));
      TEMP := TEMP - (ind*1000);
      mst := mst || ' THOUSAND ';
   END IF;
      IF TEMP > 99.99 THEN
      IND := TO_NUMBER(SUBSTR(val2,9,1));
      IF IND > 0 THEN
         mST := mST || CIENTOS(IND);
         IF SUBSTR(val2,10,2) <> '00' AND IND = 1 THEN
            mST := mST;    -- && +  'TO '
         END IF;
         TEMP := TEMP - (IND * 100 );
      END IF;
   END IF;
   IF TEMP < 10 THEN
      IND := TO_NUMBER(SUBSTR(val2,10,2));
      IF IND > 0 THEN
         IF IND > 1 THEN
            mST := mST || UNIDADES(IND);
         ELSE
            mST := mST ||'ONE';
         END IF;
      END IF;
   ELSE
      IND := TO_NUMBER(SUBSTR(val2,10,1));
      IND2 := TO_NUMBER(SUBSTR(val2,11,1));
      IF IND = 1 AND IND2 > 0 AND IND2 < 10 THEN
         mST := mST || DECENAS(IND2);
      ELSE
         IF IND > 0 THEN
            mST := mST || NOMBRE_DECENAS(IND);
         END IF;
         IF IND2 > 0 THEN
            IF IND2 > 1 THEN
               mST := mST || ' ' || UNIDADES(IND2);
            ELSE
               mST := mST || ' ONE';
            END IF;
         END IF;
      END IF;
   END IF;
  MST:= (MST||' '||substr(to_char(centavos,'9900.99'),7,2)||'/100')||'********';
 -- mst:= rpad(mst,6,'*');
/*
  -- quita los blancos de la derecha del strig
   mST := RTRIM(mST);
   -- Indica el numero de lineas necesarias
   CONTA := 1;

    --me indica cuantos caracteres tiene el string (numero convertido en letras)
   xlong := LENGTH(mst);
   -- si xlong <= que wlong1 entonces el string ocupa una linea
   -- siempre la 2da linea estar  llena con asteriscos(*)
   -- Necesito una variable que me indique la longitud de la primera
   -- linea porque puede ser menor que la longitud de impresion y se
   -- puede caer el programa = xlargo
   if xlong <= wlong1 then       -- Entra en una sola linea
      xlargo := length(mST);
   else
      xlargo := wlong1;
      xvar   := xlargo;
      For xvar in 1..length(mst) Loop -- mientras sea menor que la longitud total
          xvar  := xvar + wlong2;    -- wlong2 = longitud de las siguientes lineas
         conta := conta + 1;        -- numero de lineas necesarias para imprimir
      end loop;
   end if;
   mst1 := rpad(mst,wlong1," ");
   mst2 := rpad(mts2,wlong2,"=");
   mst1 := substr(mST,1,xlargo);
   -- Siempre muestro mst1
   if length(mST) > wlong1 Then          -- No Entra en una sola linea
      xnum1 := 1;
      xnum2 := 1;
      -- Averigua cuantos espacios hay en la primera linea
      for xnuml in xnum1 > 0 loop
         xnum1 := length(mst1,xnum2,' ',xnum2)
         if xnum1 > 0 Then
            xnum2 := xnum2 + 1;
         end if;
      end loop;
      xnum2 := xnum2 - 1;
      -- xnum2 tiene el numero de espacios en blanco que hay en la 1ra linea
      -- deja la 1ra linea hasta el espacio para no truncar la palabra
      if xnum2 > 1 Then
         xlargo := at(' ',mst1,xnum2);
         mst1 := substr(mST,1,xlargo);
      end if;
   end if;

   if length(mST) <= wlong1  then            -- Entra en una sola linea
      xfal := wlong1 - Len(mst1);       -- Cantidad de caracteres que faltan para completar la linea
      --  lleno mst1 con LINEAS DOBLES los  L caracteres truncados
      mst1 := mst1 + repli("=",xfal);
   else
      xfal  = xlargo + 1               -- Posicion donde empieza la nueva linea
      xcant = len(mST) - xlargo        -- Cantidad de caracteres a sacar
      mst2  = substr(mST, xfal, xcant) + replicate("=",iif((wlong2 - xcant)>0,wlong2 - xcant,0))
   endif
   wval1 = wxval1
   */
 RETURN(MST);
END;
END num_letras_ing;
/
