create or replace PROCEDURE            CCActualiza_saldo_cliente (
  pCia          IN varchar2,
  pGrupo        IN varchar2,
  pCliente      IN varchar2,
  pSubcliente   IN varchar2,
  pTipo_mov     IN varchar2,
  pMoneda       IN varchar2,
  pMonto        IN number,
  pTot_ref      IN number,
  pTipo_cambio  IN number,
  pFecha        IN date,
  pCks_dev      IN varchar2,
  pmsg_error    IN OUT varchar2
) IS

  --
  -- Actualiza el saldo del cliente en la moneda del documento.

   Cursor C_Cliente Is
   select sum(saldo)
   from   arccmd
   where  no_cia = PCia
   and    grupo = pGrupo
   and    no_cliente = pCliente
   and    estado != 'P'
   and    nvl(anulado,'N') = 'N';

   Cursor C_Subcliente Is
   select sum(saldo)
   from   arccmd a
   where  a.no_cia = pCia
   and    grupo = pGrupo
   and    no_cliente = pCliente
   and    sub_cliente = psubcliente
   and    estado != 'P'
   and    nvl(anulado,'N') = 'N';

  Ln_saldo_cliente        Number := 0;
  Ln_saldo_subcliente     Number := 0;
  error_proceso           Exception;

BEGIN

    Open C_Cliente;
    Fetch C_Cliente into Ln_saldo_cliente;
    If C_Cliente%notfound Then
       Ln_saldo_cliente := 0;
       Close C_Cliente;
    else
       Close C_Cliente;
    end if;

	  UPDATE arccms
	     SET saldo_actual = Ln_saldo_cliente,
           saldo_max    = greatest(Ln_saldo_cliente,saldo_actual),
           fecha_max    = decode(Ln_saldo_cliente,greatest(Ln_saldo_cliente,saldo_actual),sysdate,fecha_max)
     WHERE no_cia     = pCia
       AND grupo      = pgrupo
       AND no_cliente = pcliente
       AND moneda     = pMoneda;

    IF sql%rowcount = 0 THEN
      -- Inserta el registro en el historico de saldos
      INSERT INTO arccms (no_cia, grupo, no_cliente, moneda, saldo_max, fecha_max, saldo_actual)
                  VALUES (pcia, pgrupo, pcliente, pmoneda, Ln_saldo_cliente, sysdate, Ln_saldo_cliente);
    END IF;


    Open C_SubCliente;
    Fetch C_SubCliente into Ln_saldo_subcliente;
    If C_SubCliente%notfound Then
       Ln_saldo_subcliente := 0;
       Close C_SubCliente;
    else
       Close C_SubCliente;
    end if;

	  UPDATE arccms_subcliente
	     SET saldo_actual = Ln_saldo_subcliente,
           saldo_max    = greatest(Ln_saldo_subcliente,saldo_actual),
           fecha_max    = decode(Ln_saldo_cliente,greatest(Ln_saldo_subcliente,saldo_actual),sysdate,fecha_max)
     WHERE no_cia     = pCia
       AND grupo      = pgrupo
       AND no_cliente = pcliente
       AND subcliente = pSubcliente
       AND moneda     = pMoneda;

    IF sql%rowcount = 0 THEN
      -- Inserta el registro en el historico de saldos
      INSERT INTO arccms_subcliente (no_cia, grupo, no_cliente, moneda, saldo_max, fecha_max, saldo_actual, subcliente)
                  VALUES (pcia, pgrupo, pcliente, pmoneda, Ln_saldo_subcliente, sysdate, Ln_saldo_subcliente, psubcliente);
    END IF;

EXCEPTION
  WHEN error_proceso THEN
       return;
  WHEN others THEN
       pmsg_error := 'CCACTUALIZA_SALDO_CLIENTE : '||nvl( pmsg_error, sqlerrm);
       return;
END;