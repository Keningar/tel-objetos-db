create or replace FUNCTION            CGValida_Precision (
  pCia      in varchar2,
  pAsiento  in varchar2
) RETURN boolean IS
  --
  -- Obtiene el monto maximo a ajustar por precision.
  CURSOR c_maximos_aj IS
    SELECT max_ajuste_precision, max_ajuste_precision_dol
      FROM arcgmc
     WHERE no_cia    = pCia;
  --
  -- acumula las diferencias en precision de las lineas
  CURSOR c_precision_linea IS
    SELECT sum(decode (moneda , 'P',
                       0,
                       monto-(monto_dol*tipo_cambio))) Dif_Nom,
           sum(decode (moneda, 'D',
                       0,
                       monto_dol-(monto / tipo_cambio))) Dif_Dol
      FROM arcgal
     WHERE no_cia        = pCia
       AND no_asiento    = pAsiento;
  --
  vAjuste_Nom       arcgal.monto%Type;
  vAjuste_Dol       arcgal.monto_dol%Type;
  vMax_ajuste_Nom   arcgmc.max_ajuste_precision%type;
  vMax_ajuste_Dol   arcgmc.max_ajuste_precision_dol%type;
BEGIN
  OPEN  c_maximos_aj;
  FETCH c_maximos_aj INTO vMax_ajuste_nom, vMax_ajuste_dol;
  CLOSE c_maximos_aj;
  --
  OPEN  c_precision_Linea;
  FETCH c_precision_Linea INTO vAjuste_Nom, vAjuste_Dol;
  CLOSE c_precision_Linea;

  IF abs(vAjuste_Nom) > vMax_ajuste_nom or
     abs(vAjuste_Dol) > vMax_ajuste_dol THEN
    return(FALSE);
  ELSE
    return(TRUE);
  END IF;
END;