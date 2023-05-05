create or replace FUNCTION            cgvalida_tipo_cambio (
  pCia                 varchar2,
  pCambio_sis          number,
  pCambio_dig          number,
  pMsg          in out varchar2
) RETURN boolean IS
  --
  -- Valida que el tipo de cambio digitado dado como parametro no la banda de
  -- de variacion definida a nivel de la compa?ia con respecto al tipo de cambio
  -- dado por el sistema (pCambio_sis). Devuelve true si la variacion esta dentro
  -- de la banda o false sino la exede. En este ultimo caso, devuelve en pmsg el
  -- motivo por el que se retorno false.
  --
  --
  CURSOR c_banda IS
    SELECT banda_tasas_camb
      FROM arcgmc
     WHERE no_cia = pCia;
  --
  vbanda         arcgmc.banda_tasas_camb%type;
  error_proceso  exception;
  vencontro      boolean;
BEGIN
  OPEN  c_banda;
  FETCH c_banda INTO vbanda;
  vencontro := c_banda%found;
  CLOSE c_banda;

  IF not vencontro THEN
  	pmsg := 'La compa?ia '||pCia||' no se encuentra definida';
  	RAISE error_proceso;
  END IF;

  IF abs(pCambio_sis - pCambio_dig) > nvl(vbanda,0) THEN
  	pmsg := 'El tipo de cambio exede la banda de variacion definida a nivel de la compa?ia';
  	RAISE error_proceso;
  END IF;

  return(true);
EXCEPTION
  WHEN error_proceso THEN
       return(false);
END;