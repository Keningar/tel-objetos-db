create or replace FUNCTION            CGValida_Ctas_Asiento (
  pCia      Varchar2,
  pAsiento  Varchar2
) RETURN BOOLEAN
IS
  -- Valida que todas las cuentas del asiento acepten movimientos
  cursor Ctas_Asiento is
    select 'S'
       from  arcgms MS, arcgal AL
      where AL.no_cia     = pCia
        and no_asiento    = pAsiento
        and MS.no_cia     = AL.no_cia
        and MS.cuenta     = AL.cuenta
        and MS.ind_mov    = 'N';
  vCta_Erronea VArchar2(1);
BEGIN
   Open Ctas_Asiento;
   Fetch Ctas_Asiento Into vCta_Erronea;
   Close Ctas_Asiento;
   IF NVL(vCta_Erronea, 'X') = 'S' THEN
      Return(FALSE);
   ELSE
      Return(TRUE);
   END IF;
END;