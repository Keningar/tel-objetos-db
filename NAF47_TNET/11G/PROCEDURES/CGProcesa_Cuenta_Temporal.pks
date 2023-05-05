create or replace PROCEDURE            CGProcesa_Cuenta_Temporal (
   pcia             Varchar2,
   pAno             Varchar2,
   pMes             Varchar2,
   pCta_Tempo       Varchar2,
   pMto_Nom         Number,
   pMto_Dol         Number,
   pError    IN OUT Varchar2
   )IS
  vError_Proceso EXCEPTION;
  vCta_tmp       Arcgms.cuenta%type;
  vCentro_Cero   Varchar2(9);
BEGIN
   vCentro_Cero := Centro_Costo.RellenaD(pCia, '0');
   -- --
   -- Afecta la cuenta temporal al debito y al credito
   -- Localizacion Colombia
   --
   IF pCta_Tempo IS NOT NULL THEN
      -- --
      -- Aplica resultado al Debito
	  --
      CGMayoriza_Cta(pCia,           pAno,          pMes, pCta_Tempo,
                     ABS(pMto_Nom),  ABS(pMto_Dol), 'D',  pError);
      IF pError IS NOT NULL THEN
      	  Raise vError_Proceso;
      END IF;
      CGProcesa_CC(pCia,          pAno,          pMes,
                   'CG',          pCta_Tempo,    vCentro_Cero,
                   ABS(pMto_Nom), ABS(pMto_Dol), 'D',
                   pError);
      IF pError IS NOT NULL THEN
      	  Raise vError_Proceso;
      END IF;
      -- --
      -- Aplica resultado al Credito
	  --
      CGMayoriza_Cta(pCia,           pAno,           pMes, pCta_Tempo,
                     -ABS(pMto_Nom), -ABS(pMto_Dol), 'C',  pError);
      IF pError IS NOT NULL THEN
      	  Raise vError_Proceso;
      END IF;
      CGProcesa_CC(pCia,           pAno,           pMes,
                   'CG',           pCta_Tempo,     vCentro_Cero,
                   -ABS(pMto_Nom), -ABS(pMto_Dol), 'C',
                   pError);
      IF pError IS NOT NULL THEN
      	  Raise vError_Proceso;
      END IF;
	  vCta_Tmp := pCta_Tempo;
	  LOOP
	     -- El siguiente codigo, se requiere, debido a que se esta aplicando un
		 -- movimiento para el mes de cierre que es anterior al mes en proceso
	     Update arcgms
		    Set debitos      = 0,
			    creditos     = 0,
				debitos_dol  = 0,
			    creditos_dol = 0
 		  Where no_cia = pCia
		    And cuenta = vCta_Tmp;
         --
	     Update arcgms_c
		    Set debitos      = 0,
			    creditos     = 0,
				debitos_dol  = 0,
			    creditos_dol = 0
 		  Where no_cia = pCia
		    And cuenta = vCta_Tmp
			And cc_1   = '000'
			And cc_2   = '000'
			And cc_3   = '000';
		 --
         IF Cuenta_Contable.Nivel(pCia, vCta_Tmp) <= 1 THEN
            EXIT;
         ELSE
            vCta_Tmp := Cuenta_Contable.padre(pCia, vCta_Tmp);
  		    IF vCta_Tmp IS NULL THEN
		       Exit;
  		    END IF;
         END IF;
		 --
	  END LOOP;
   END IF;
EXCEPTION
   	WHEN vError_Proceso THEN
   	    pError := nvl(pError, 'CGProcesa_Cuenta_Temporal');
   	WHEN OTHERS THEN
   	    pError := nvl(SQLERRM, 'CGProcesa_Cuenta_Temporal');
END;