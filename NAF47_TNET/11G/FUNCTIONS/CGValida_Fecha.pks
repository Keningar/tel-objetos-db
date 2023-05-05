create or replace FUNCTION            CGValida_Fecha (
  pFecha   in date,
  pAno     in arcgae.ano%type,
  pMes     in arcgae.mes%type
) RETURN boolean
IS
  -- Valida que la fecha del asiento corresponda con el a?o y mes
  fAsiento  varchar2(6);
  fProceso  varchar2(6);
BEGIN
  fAsiento := to_char(pfecha, 'RRRRmm');
  fProceso := (pano*100)+pmes;
  RETURN (fAsiento = fProceso);
END;