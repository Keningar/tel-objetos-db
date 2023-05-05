create or replace FUNCTION            CGverif_si_afec_distCC(
  PNUCIA   in varchar2,
  pCuenta  in varchar2
) RETURN BOOLEAN
IS
  --
  contador number(4) := 0;
BEGIN
  -- verifica si la cta esta dispuesta a distribuir
  SELECT COUNT(*) INTO contador
     FROM arcgD_CC
     WHERE no_cia  = pNucia
       AND cuenta  = pCuenta
       AND rownum  < 2;
  --
  RETURN ( nvl(contador,0) > 0 );
END;