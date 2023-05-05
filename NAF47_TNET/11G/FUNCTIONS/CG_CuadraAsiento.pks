create or replace FUNCTION            CG_CuadraAsiento(
  pcia      in arcgms.no_cia%type,
  pAsiento  in arcgae.no_asiento%type,
  pOrigen   in arcgae.origen%type
) RETURN BOOLEAN
IS
  -- Valida si el asiento esta cuadrado:
  --    1.Para asientos de contabilidad por moneda y tipo de cambio
  --    2.Para asientos de auxiliares por moneda
  --
  CURSOR c_Lineas_CG IS
     SELECT  moneda,
       decode (NVL(pOrigen,'AU'), 'CG', Tipo_cambio, 1) Tipo_cambio,
             SUM(decode(moneda, 'D', Monto_Dol,MONTO)) MONTO
       FROM ARCGAL
      WHERE NO_CIA     = pCIA
      AND NO_ASIENTO = pASIENTO
  GROUP BY MONEDA,decode (NVL(pOrigen,'AU'), 'CG', Tipo_cambio, 1);
  --
  vCuadra  BOOLEAN;
BEGIN
  vCuadra := TRUE;
  FOR L IN c_Lineas_CG LOOP
     vCuadra  := (l.monto = 0);
     if NOT vCuadra THEN
  Exit;
     end if;
  END LOOP;
  RETURN(vCuadra);
END;