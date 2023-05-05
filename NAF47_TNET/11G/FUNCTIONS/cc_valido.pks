create or replace FUNCTION            cc_valido (pno_cia Char, cc1 Char, cc2 Char, cc3 Char) RETURN Boolean IS
-- Funcion que indica si un Centro de costo puede o no aceptar movimientos.
CURSOR Existe IS
  SELECT 'Si'
  FROM ARCGCECO
  WHERE no_cia           = pno_cia and
        (Nvl(cc3,'000')  != '000'   OR
        (Nvl(cc2,'000')  != '000'  and
         Nvl(cc3,'000')   = '000'  and
         0 = (Select Nvl(count(*),0)
                from ARCGCECO
               Where no_cia  = pno_cia and
                     cc_1    = cc1 and
                     cc_2    = cc2 and
                     cc_3   != '000')) OR
        (Nvl(cc1,'000')  != '000' and
         Nvl(cc2,'000')   = '000' and
         Nvl(cc3,'000')   = '000' and
         0 = (Select Nvl(count(*),0)
                from ARCGCECO
               Where no_cia  = pno_cia and
                     cc_1    = cc1 and
                     cc_2   != '000')) OR
        (Nvl(cc1,'000')   = '000' and
         Nvl(cc2,'000')   = '000' and
         Nvl(cc3,'000')   = '000' ));
  Que   Varchar2(2):='No';
BEGIN
  OPEN Existe;
  FETCH EXISTE INTO Que;
  IF EXISTE%NOTFOUND THEN
     Que := 'No';
  END IF;
  CLOSE Existe;
  RETURN( (Que='Si') );
END;