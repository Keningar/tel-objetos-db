create or replace PROCEDURE            CPVALIDA_RUC6  (RUC    VARCHAR2,
                                            MENSAJE OUT VARCHAR2) IS
coeficiente  varchar2(8) := '32765432';
suma         number(3) := 0;
producto     number(3) := 0;
verificador  number(1) := 0;
error_proceso     EXCEPTION;

BEGIN
 mensaje := null;
  -- Se verifica la longitud de la cedula
  If length(ruc) != 13 Then
      mensaje := 'El numero de Ruc no es valido.';
      raise error_proceso;
  End if;
  -- Se verifica el codigo de la Provincia que debe estar entre 01 y 22
  If To_number(Substr(ruc,1,2)) not between 1 and 22  Then
      mensaje := 'El codigo de la provincia es valido.';
      raise error_proceso;
  End if;
  If To_number(Substr(ruc,3,1)) != 6   Then
      mensaje := 'El numero de ruc no es valido.';
      raise error_proceso;
  End if;

  If To_number(Substr(ruc,10,4)) <> 1   Then
      mensaje := 'El numero de establecimiento no es valido.';
      raise error_proceso;
  End if;

  For i in 1..8 Loop
    producto :=  To_number(Substr(coeficiente,i,1)) * To_number(Substr(ruc,i,1));
    -- Acumulo el valor resultado del coeficiente con la cedula.
  	suma := suma + producto;
  End loop;

  verificador := 11 -mod(suma,11);
  If To_number(Substr(ruc,10,1)) != verificador  then
    mensaje := 'El digito verificador no es valido.';
    raise error_proceso;
 end if;

EXCEPTION
  WHEN error_proceso THEN
       mensaje := nvl(mensaje, '  en CPVALIDA_RUC6');

  WHEN OTHERS THEN
       mensaje := 'CPVALIDA_RUC6 : '||sqlerrm;
END;