create or replace FUNCTION            CGPeriodo_valido (
  pCia   varchar2,
  pAno   number,
  pMes   number
) RETURN boolean IS
  --
  -- Valida que el periodo dado no sea menor al periodo en proceso de
  -- la contabilidad.  Esto para efectos de validar que  ningun auxiliar
  -- defina un proceso menor que el de la contabilidad.
  CURSOR c_Conta IS
    SELECT ((ano_proce*100)+mes_proce) Periodo
      FROM arcgct_c
     WHERE no_cia = pCia
       AND modulo = 'CG';
  --
  vProc_conta  number(6);
  vProc_valida number(6);
  --
BEGIN

 vProc_valida := ((pAno*100)+pMes);

  OPEN  c_conta;
  FETCH c_conta INTO vProc_conta;
  CLOSE c_conta;

  --
  -- si la conta va en un mes mayor al dado como parametro, la validacion debe retornar falso.
  IF vProc_Conta > vProc_valida THEN
   return(FALSE);
  ELSE
   return(TRUE);
  END IF;

END;