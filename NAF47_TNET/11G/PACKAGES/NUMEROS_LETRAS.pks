CREATE OR REPLACE package            NUMEROS_LETRAS is

  -- Author  : MARCIA
  -- Created : 06/02/2007 17:24:30
  -- Purpose :
 FUNCTION Letras (numero In NUMBER,moneda_cta in VARCHAR2,pcia VARCHAR2) RETURN VARCHAR2;
 FUNCTION millones (millon IN NUMBER) RETURN VARCHAR2;
 FUNCTION miles (mil IN NUMBER) RETURN VARCHAR2;
 FUNCTION cientos (cien IN NUMBER) RETURN VARCHAR2;
 FUNCTION decenas (decena IN NUMBER) RETURN VARCHAR2;
 FUNCTION Unidades (unidad IN NUMBER) RETURN VARCHAR2;
 FUNCTION nombre_decenas (digito IN NUMBER) RETURN VARCHAR2;
end NUMEROS_LETRAS;
/


CREATE OR REPLACE package body            NUMEROS_LETRAS is
 FUNCTION Letras (numero In NUMBER,moneda_cta in VARCHAR2,pcia VARCHAR2) RETURN VARCHAR2 IS
  temp NUMBER;
  va_descmon varchar2(20);
  va_moneda  varchar2(2);
BEGIN
  if moneda_cta='D' then
     va_descmon:= 'DOLARES';
  else
     va_descmon:= moneda.nombre(PCIA, 'P');
  end if;
  temp := trunc(numero);

  IF (NVL(numero,0) - TRUNC(NVL(numero,0))) > 0 THEN
     RETURN(millones(temp)||' '||va_descmon||'PUNTO '||decenas((numero - temp) * 100));
  ELSE
     RETURN(millones(temp)||' '||va_descmon);
  END IF;
  --RETURN(millones(temp)||' '||va_descmon||' CON '||decenas((numero - temp) * 100))||' CTS.';
END;

FUNCTION millones (millon IN NUMBER) RETURN VARCHAR2 IS
  numero    varchar(12);
  digitos   number;
  digito1   number;
  digito2   number;
BEGIN
  numero  := to_char(millon);
  digitos := NVL(length(numero), 0);
  if digitos <= 6 then
    return(miles(millon));
  elsif digitos <= 12 then
    digito1   := to_number(substr(numero,1,(digitos-6)));
    digito2   := to_number(substr(numero,-6,6));
    if digito1 = 1 then
       if digito2 = 0 then
          return('UN MILLON');
       else
          return('UN MILLON '||miles(digito2));
       end if;
    else
       if digito2 = 0 then
          return(miles(digito1)||' MILLONES');
       else
          return(miles(digito1)||' MILLONES '||miles(digito2));
       end if;
    end if;
  else
    return('');
  end if;
END;
FUNCTION miles (mil IN NUMBER) RETURN VARCHAR2 IS
  numero    varchar(6);
  digitos   number;
  digito1   number;
  digito123 number;
BEGIN
  numero  := to_char(mil);
  digitos := NVL(length(numero), 0);
  if digitos <= 3 then
    return(cientos(mil));
  elsif digitos <= 6 then
    digito1   := to_number(substr(numero,1,(digitos-3)));
    digito123 := to_number(substr(numero,-3,3));
    if digito1 = 1 then
       if digito123 = 0 then
          return('MIL');
       else
          return('MIL '||cientos(digito123));
       end if;
    else
       if digito123 = 0 then
          return(cientos(digito1)||' MIL');
       else
          return(cientos(digito1)||' MIL '||cientos(digito123));
       end if;
    end if;
  else
    return('');
  end if;
END;
FUNCTION cientos (cien IN NUMBER) RETURN VARCHAR2 IS
-- convierte numeros de tres o menos digitos as letras
  numero   varchar2(3);
  digitos  number;
  digito1  number;
  digito23 number;
BEGIN
  numero  := to_char(cien);
  digitos := NVL(length(numero), 0);
  if digitos <= 2 then     -- En el caso de que el numero sea de uno
    return(decenas(cien)); -- o dos digitos
  elsif digitos = 3 then   -- En el caso de que sean tres digitos
    digito1  := to_number(substr(numero,1,1));
    digito23 := to_number(substr(numero,2,2));
    if digito1 = 1 then     -- El caso del cien
      if digito23 = 0 then
         return('CIEN');
      else
         return('CIENTO '||decenas(digito23));
      end if;
    elsif digito1 = 5 then  -- El caso de los quinientos
      if digito23 = 0 then
         return('QUINIENTOS');
      else
         return('QUINIENTOS '||decenas(digito23));
      end if;
    elsif digito1 = 7 then  -- El caso de los setecientos
      if digito23 = 0 then
         return('SETECIENTOS');
      else
         return('SETECIENTOS '||decenas(digito23));
      end if;
    elsif digito1 = 9 then  -- El caso de los novecientos
      if digito23 = 0 then
         return('NOVECIENTOS');
      else
         return('NOVECIENTOS '||decenas(digito23));
      end if;
    else                    -- El resto de los casos
      if digito23 = 0 then
        return(unidades(digito1)||'CIENTOS');
      else
        return(unidades(digito1)||'CIENTOS '||decenas(digito23));
      end if;
    end if;
  else
    return('');
  end if;
END;
FUNCTION decenas (decena IN NUMBER) RETURN VARCHAR2 IS
-- Convierte numeros de dos digitos a letras
  numero  varchar2(2);
  digitos number;
  digito1 number;
  digito2 number;
BEGIN
  numero  := to_char(decena);
  digitos := NVL(length(numero), 0);
  if digitos = 1 then -- Si tiene solo un digito entoces devuelve unidades
    return unidades(decena);
  elsif digitos = 2 then -- Esto es en el caso de dos digitos
    if decena = 10 then     -- Estos son casos especiales del 10 a 15
      return('DIEZ');
    elsif decena = 11 then
      return('ONCE');
    elsif decena = 12 then
      return('DOCE');
    elsif decena = 13 then
      return('TRECE');
    elsif decena = 14 then
      return('CATORCE');
    elsif decena = 15 then
      return('QUINCE');
    elsif decena = 20 then
      return('VEINTE');
    else
      digito1 := to_number(substr(numero,1,1));
      digito2 := to_number(substr(numero,2,1));
      if digito1 = 1 then    -- Estos los casos de 16 al 19
         return('DIECI'||unidades(digito2));
      elsif digito1 = 2 then -- Estos son los casos del 21 al 29
         return('VEINTI'||unidades(digito2));
      else                   -- El resto de los casos
         if digito2 = 0 then
           return(nombre_decenas(digito1));
         else
           return(nombre_decenas(digito1)||' y '||unidades(digito2));
         end if;
      end if;
    end if;
  else
    return('');
  end if;
END;
FUNCTION Unidades (unidad IN NUMBER) RETURN VARCHAR2 IS
-- Convierte los numero desde 0 hasta 9 a letras
BEGIN
  if unidad = 1 then
    return('UN');
  elsif unidad = 2 then
    return('DOS');
  elsif unidad = 3 then
    return('TRES');
  elsif unidad = 4 then
    return('CUATRO');
  elsif unidad = 5 then
    return('CINCO');
  elsif unidad = 6 then
    return('SEIS');
  elsif unidad = 7 then
    return('SIETE');
  elsif unidad = 8 then
    return('OCHO');
  elsif unidad = 9 then
    return('NUEVE');
  elsif unidad = 0 then
    return('CERO');
  else
    return('');
  end if;
END;
FUNCTION nombre_decenas (digito IN NUMBER) RETURN VARCHAR2 IS
BEGIN
  if digito = 1 then
    return('DIECI');
  elsif digito = 2 then
    return('VEINTI');
  elsif digito = 3 then
    return('TREINTA');
  elsif digito = 4 then
    return('CUARENTA');
  elsif digito = 5 then
    return('CINCUENTA');
  elsif digito = 6 then
    return('SESENTA');
  elsif digito = 7 then
    return('SETENTA');
  elsif digito = 8 then
    return('OCHENTA');
  elsif digito = 9 then
    return('NOVENTA');
  elsif digito = 0 then
    return('CERO');
  else
    return('');
  end if;
END;
end NUMEROS_LETRAS;
/
