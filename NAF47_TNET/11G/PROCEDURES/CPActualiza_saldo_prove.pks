create or replace PROCEDURE            CPActualiza_saldo_prove (
  pCia          IN varchar2,
  pProve        IN varchar2,
  pTipo_mov     IN varchar2,
  pMoneda       IN varchar2,
  pMonto        IN number,
  pTipo_cambio  IN number,
  pDocumento    IN varchar2,
  pFecha        IN date,
  pmsg_error    IN OUT varchar2
) IS

  --
  -- Actualiza el saldo del proveedor en la moneda del documento.
  --
  error_proceso exception;

BEGIN

	--
	-- crea la cuenta del proveedor en la moneda necesaria.
 	proveedor.crea_cuenta (pCia, pProve, pMoneda );

 	--
	-- Actualiza saldo del proveedor en la moneda dada, sumando o restando segun sea un
	-- credito o debito respectivamente.
	--
	UPDATE arcpms
	   SET saldo_actual = nvl(saldo_actual,0) + decode(pTipo_mov, 'C', nvl(pMonto,0), -nvl(pMonto,0))
   WHERE no_cia   = pCia
     AND no_prove = pProve
     AND moneda   = pMoneda;


  IF pTipo_mov = 'C' THEN
  	--
  	-- Actualiza fecha de la ultima compra del proveedor
    UPDATE arcpmp
       SET f_u_co   = decode(pDocumento,'F',pFecha, F_U_CO)
     WHERE no_cia   = pCia
       AND no_prove = pProve;

  END IF;

EXCEPTION

  WHEN error_proceso THEN
       return;
  WHEN others THEN
       pmsg_error := 'CPACTUALIZA_SALDO_PROVE : '|| nvl( pmsg_error, sqlerrm);
       return;

END;