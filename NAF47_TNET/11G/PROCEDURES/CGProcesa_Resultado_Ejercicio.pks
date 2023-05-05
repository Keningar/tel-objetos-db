create or replace PROCEDURE            CGProcesa_Resultado_Ejercicio (
  pcia             varchar2,
  pAno             varchar2,
  pMes             varchar2,
  pCta_Util        varchar2,
  pCta_Perd        varchar2,
  pCta_Tempo       varchar2,
  pMto_Nom         number,
  pMto_Dol         number,
  pError    IN OUT varchar2
) IS
  vError_Proceso   exception;
  vMes_Cierre      arcghc.mes%type;
  vAno_Cierre      arcghc.ano%type;
  vCta_cont        arcghc.cuenta%type;

BEGIN
  IF pCta_Tempo IS NOT NULL THEN
    IF pMes = 1 THEN
      vMes_Cierre := 12;
      vAno_Cierre := pAno - 1;
    ELSE
      vMes_Cierre := pMes - 1;
      vAno_Cierre := pAno;
    END IF;
    CGProcesa_Cuenta_Temporal(pCia,       vAno_Cierre,     vMes_Cierre,
                              pCta_Tempo, pMto_Nom,        pMto_Dol,
	                           pError);
    IF pError IS NOT NULL THEN
      RAISE vError_Proceso;
    END IF;
  END IF;
  IF pMto_Nom != 0 OR pMto_dol != 0 THEN
  	--
  	-- dependiendo del resultado del periodo, contabiliza a la cuenta de perdidas o
  	-- la de ganancias.

  	IF pMto_nom < 0 THEN
    	-- Por ser una cuenta de capital, si el monto es menor que cero, indica que el periodo
    	-- produjo ganancias.
  		vCta_cont := pCta_util;
  	ELSE
  		-- periodo origino perdidas.
  		vCta_cont := pCta_perd;
  	END IF;

    CGMayoriza_Resultado_Ejercicio(pCia,      pAno,     pMes,
	                                 vCta_cont, pMto_Nom, pMto_Dol,
		    		                       pError);
  END IF;
EXCEPTION
   	WHEN vError_Proceso THEN
    	   pError := nvl(pError, 'CGProcesa_Resultado_Ejercicio');
   	WHEN others THEN
    	   pError := nvl(sqlerrm, 'CGProcesa_Resultado_Ejercicio');
END;