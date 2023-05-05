create or replace PROCEDURE            CCAct_historico (
  pCia         IN varchar2,
  pGrupo       IN varchar2,
  pCliente     IN varchar2,
  pSubcliente   IN varchar2,
  pFecha       IN date,
  pMonto       IN number,
  pMoneda      IN varchar2,
  pTipo        IN varchar2,
  pMes_proc    IN number,
  pAno_proc    IN number,
  pTot_ref     IN number,
  ptipo_cambio IN number,
  pCks_dev     IN varchar2,
  pmsg_error   IN OUT varchar2
) IS

  --
  -- Actualiza el saldo historico de la cuenta del cliente en la moneda dada. Se debe recalcular
  -- el saldo de la misma, desde el periodo historico dado hasta el periodo en proceso actual
  -- inclusive.
  --

  -- variables
  vMes_Doc      number(2);
  vAno_Doc      number(4);
  --
  v_ano         number(4);
  v_mes         number(4);
  --
  error_proceso exception;
BEGIN
  vMes_Doc := to_number(to_char(pFecha, 'MM'));
  vAno_Doc := to_number(to_char(pFecha, 'RRRR'));

 	--
	-- Actualiza saldo actual del cliente en la moneda dada, sumando o restando segun sea un
	-- credito o debito respectivamente.
	--
  CCActualiza_saldo_cliente (pCia, pGrupo, pCliente, pSubcliente, pTipo,  pMoneda,  pMonto,
                             pTot_ref, pTipo_cambio, pFecha,  pCks_dev, pmsg_error);

  IF pmsg_error is not null  THEN
  	RAISE error_proceso;
  END IF;

  --
  -- Actualiza el saldo del historico.
  UPDATE arccsa
     SET saldo  = nvl(saldo,0) + decode(pTipo, 'D', nvl(pMonto,0), -nvl(pMonto,0))
   WHERE no_cia     = pCia
     AND grupo      = pGrupo
     AND no_cliente = pCliente
     AND ano        = vAno_doc
     AND mes        = vMes_doc
     AND moneda     = pMoneda;

  IF sql%rowcount = 0 THEN

  	--
  	-- sino encontro el registro historico, lo inserta.
    INSERT INTO arccsa (NO_CIA,  GRUPO,  NO_CLIENTE,  ANO,   MES,  MONEDA,
                        SALDO)
                VALUES (pCia, pGrupo, pCliente, vAno_doc, vMes_doc, pMoneda,
                        decode(pTipo, 'D', nvl(pMonto,0), -nvl(pMonto,0)));
  END IF;

  --
  -- Actualiza los saldos de los meses que estan entre el que se actualiza (historico)
  -- y el de proceso.
  v_ano := vAno_doc;
  v_mes := vMes_doc;
  LOOP
    IF v_mes  = 12 THEN
      v_mes  := 1;
      v_ano  := v_ano + 1;
    ELSE
      v_mes := v_mes + 1;
    END IF;

    EXIT WHEN v_ano = pAno_proc and v_mes = pMes_proc;

    UPDATE arccsa
       SET saldo  = nvl(saldo,0) + decode(pTipo, 'D', nvl(pMonto,0), -nvl(pMonto,0))
     WHERE no_cia     = pCia
       AND grupo      = pGrupo
       AND no_cliente = pCliente
       AND ano        = v_ano
       AND mes        = v_mes
       AND moneda     = pMoneda;

    IF sql%rowcount = 0 THEN
      -- Inserta el registro en el historico de saldos
      INSERT INTO arccsa (NO_CIA, GRUPO,  NO_CLIENTE,  ANO,   MES,  MONEDA,
                          SALDO)
                  VALUES (pCia, pGrupo, pCliente, v_ano, v_mes, pMoneda,
                          decode(pTipo, 'D', nvl(pMonto,0), -nvl(pMonto,0)));
    END IF;
  END LOOP;

EXCEPTION

  WHEN error_proceso THEN
       return;
  WHEN others THEN
       pmsg_error := 'CCACT_HISTORICO : '|| nvl( pmsg_error, sqlerrm);
       return;

END CCAct_historico;