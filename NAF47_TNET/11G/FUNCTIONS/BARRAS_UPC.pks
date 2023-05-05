create or replace function            BARRAS_UPC(pbarras  varchar2)  return boolean is

  largo_r    number := 0;
  pares_r    number := 0;
  impares_r  number := 0;
  mpares_r   number := 0;
  mimpares_r number := 0;
  suma_r     number := 0;
  digito     number := 0;
  bandera    varchar2(1)  := 'N';
  bandera_s  varchar2(1)  := 'N';

Begin
  largo_r := length(pbarras);
  --
  -- Los UPC comienzan con 0 y tienen longitud de 12 caracteres
  IF (largo_r = 12)          and  SUBSTR(pbarras,1,1) = '0' and
     instr(PBARRAS,'-') = 0  and  instr(PBARRAS,'.') = 0       THEN
      pares_r    := 0;
      impares_r  := 0;
      mpares_r   := 0;
      mimpares_r := 0;
      suma_r     := 0;
      digito     := 0;
      BANDERA    := 'N';
      BANDERA_S  := 'N';  -- En la cadena hay digitos diferentes que no estan entre 48 y 57
      --
      --Bucle para sumar pares e impares
      IF ascii(SUBSTR(pbarras,length(pbarras),1)) between 48 and 57 then -- SI EL ULTIMO CARACTER ES NUMERICO
         FOR z IN 1..LENGTH(pbarras)-1 loop  -- El ultimo digito no se toma en cuenta por ser el validador.
            --
            IF ascii(SUBSTR(pbarras,z,1)) between 48 and 57 then
               --
               IF mod(z,2) = 0  then  -- La posicion en la cadena indica si es un digito par o impar
                  pares_r := pares_r + to_number(SUBSTR(pbarras,z,1));
               else
                  impares_r := impares_r + to_number(SUBSTR(pbarras,z,1));
               end if;
             Else
               bandera_s := 'S'; -- Existen caracteres diferentes a numeros en la cadena de barra.
               EXIT;
            END IF;
         END LOOP;

         --Si la suma se genero normalmente entonces  BANDERA_S = 'N'  Verifica el largo del codigo de barra para la multiplicacion de los pares e impares por 3
         IF BANDERA_S = 'N' then
            largo_r := length(pbarras);
            digito:= to_number(substr(pbarras,largo_r,1));  -- Obtengo el digito verificador
            --
            if largo_r = 12 then
               mpares_r   := pares_r;
               mimpares_r := impares_r*3;
            end if;
            --sumo el resultado anterior para encontrar el digito verificador
            suma_r := mpares_r + mimpares_r;
            IF (MOD(suma_r,10)= 0 and digito = 0) -- El digito verificador = 0
                       OR (DIGITO = 10-mod(suma_r,10)) then -- El digito verificador = residuo
               BANDERA := 'S'; -- Validacion es correcta
            ELSE
               BANDERA := 'N';
            END IF;
            --verifico que si existio y esta bien dicho codigo grabao en la tabla de codigos de barra de lo contrario
            --en la tabla de errores con el error E
            IF BANDERA = 'S' THEN
               return(TRUE);
             ELSE
               return(FALSE);
            END IF;
        END IF;
        --
      ELSE
       return(FALSE);
      END IF;
    --
    ELSE
       return(FALSE);
  END IF;
END BARRAS_UPC;