create or replace PROCEDURE            CGCalcula_Utilidades (
  pNo_cia    in varchar2,
  pAno       in number,
  pMes       in number,
  pmsg_error in out varchar2
) IS
 -- --
 -- Definicion de cursores
 --
  Cursor cRegistra_Ajustes IS
    Select 'x'
	  From arcgtai
	 Where no_cia = pNo_cia;
  Cursor cTotal_Utilidades IS
     Select Sum(nvl(saldo_mes_ant,0)) Saldo_Ant,
	        Sum(nvl(saldo_mes_ant_dol,0)) Saldo_Ant_Dol,
	        SUM(nvl(debitos,0))     debitos,     sum(nvl(creditos,0))     creditos,
	        SUM(nvl(debitos_dol,0)) debitos_dol, sum(nvl(creditos_dol,0)) creditos_dol
	   From arcgms
	  Where no_cia = pNo_Cia
	    And nivel  = 2
		And clase  = '9';
  Cursor cCuenta_Utilidades IS
     Select Cuenta
	   From arcgms
	  Where no_cia = pNo_Cia
	    And nivel  = 1
		And clase  = '9';
 -- --
 -- Definicion de variables
 --
  vUsa_Ajustes   BOOLEAN;
  vDummy         Varchar2(1);
  rUtil          cTotal_utilidades%rowtype;
  vCuenta_Util   arcgms.cuenta%type;
  error_proceso  EXCEPTION;
BEGIN
  -- --
  -- Verifica si la compa?ia requiere ajustes por inflacion,
  -- para determinar el llamado que se debe hacer.
  --
  Open cRegistra_Ajustes;
  Fetch cRegistra_Ajustes INTO vDummy;
  vUsa_Ajustes := cRegistra_Ajustes%FOUND;
  Close cRegistra_Ajustes;
  --
  IF vUsa_Ajustes THEN
     -- Calcula utilidades para las cuentas que reciben ajuste de inflacion
     CGCalcUtil_Cia (pNo_cia, pAno, pMes, 'S', pmsg_error);
     if pmsg_error is not null then
        raise error_proceso;
     end if;
     --
     -- Calcula utilidades para las cuentas que NO reciben ajuste de inflacion
     CGCalcUtil_Cia (pNo_cia, pAno, pMes, 'N', pmsg_error);
     if pmsg_error is not null then
        raise error_proceso;
     end if;
  ELSE
     -- Calcula utilidades para la compa?ia en general
     CGCalcUtil_Cia (pNo_cia, pAno, pMes, NULL, pmsg_error);
     if pmsg_error is not null then
        raise error_proceso;
     end if;
  END IF;
  -- --
  --  Aplica la utilidad a la cuenta de nivel 1 (de mayor)
  --  Obtiene el total de utilidades
  Open  cTotal_Utilidades;
  Fetch cTotal_Utilidades INTO rUtil;
  Close cTotal_Utilidades;
  -- Obtiene la cuenta de utilidades a nivel 1
  Open  cCuenta_Utilidades;
  Fetch cCuenta_Utilidades INTO vCuenta_Util;
  Close cCuenta_Utilidades;
  -- Se actualizan los saldos de la cuenta de utilidades a nivel 1
   Update arcgms
      Set   Debitos           = nvl(rUtil.Debitos,0),
	      Creditos          = nvl(rUtil.Creditos,0),
	      Debitos_Dol       = nvl(rUtil.Debitos_Dol,0),
		  Creditos_Dol      = nvl(rUtil.Creditos_Dol,0)
    Where no_Cia = pNo_Cia
      And Cuenta = vcuenta_util;
   Update arcgms_c
	  Set Debitos           = nvl(rUtil.Debitos,0),
	      Creditos          = nvl(rUtil.Creditos,0),
	      Debitos_Dol       = nvl(rUtil.Debitos_Dol,0),
		  Creditos_Dol      = nvl(rUtil.Creditos_Dol,0)
    Where no_Cia = pNo_Cia
      And Cuenta = vcuenta_util
	  And cc_1   = '000'
	  And cc_2   = '000'
	  And cc_3   = '000';
   Update arcghc
	  Set Saldo       = NVL(rUtil.Saldo_Ant,0)     + NVL(rUtil.Debitos,0)     + NVL(rUtil.Creditos,0),
	      Saldo_dol   = NVL(rUtil.Saldo_Ant_Dol,0) + NVL(rUtil.Debitos_Dol,0) + NVL(rUtil.Creditos_Dol,0),
	      mov_db      = NVL(rUtil.Debitos,0),
	      mov_cr      = NVL(rUtil.Creditos,0),
		  movimiento  = NVL(rUtil.Debitos,0) + NVL(rUtil.Creditos,0),
	      mov_db_Dol  = nvl(rUtil.Debitos_Dol,0),
		  mov_cr_Dol  = nvl(rUtil.Creditos_Dol,0)
    Where no_Cia = pNo_Cia
      And Cuenta = vcuenta_Util
	  And Ano    = pAno
	  And Mes    = pMes;
   IF SQL%rowcount = 0 THEN
      Insert into arcghc
	    (No_Cia,  cuenta,     ano,
		 mes,  	  periodo,
		 saldo,
		 saldo_dol,
		 mov_db,  mov_cr,
		 movimiento,
		 mov_db_dol, mov_cr_Dol) Values
		(pNo_Cia,  vcuenta_util, pAno,
		 pMes,  ((pAno*100)+pMes),
		 NVL(rUtil.Saldo_Ant,0) + nvl(rUtil.Debitos,0) + nvl(rUtil.creditos,0),
		 NVL(rUtil.Saldo_Ant_Dol,0) + nvl(rUtil.Debitos_dol,0) + nvl(rUtil.creditos_dol,0),
		 nvl(rUtil.Debitos,0),  nvl(rUtil.Creditos,0),
		 nvl(rUtil.Debitos,0) + nvl(rUtil.Creditos,0),
	     nvl(rUtil.Debitos_Dol,0), nvl(rUtil.Creditos_Dol,0)
		 );
   END IF;
   Update arcghc_c
	  Set Saldo       = NVL(rUtil.Saldo_Ant,0)     + NVL(rUtil.Debitos,0)     + NVL(rUtil.Creditos,0),
	      Saldo_dol   = NVL(rUtil.Saldo_Ant_Dol,0) + NVL(rUtil.Debitos_Dol,0) + NVL(rUtil.Creditos_Dol,0),
	      mov_db      = nvl(rUtil.Debitos,0),
	      mov_cr      = NVL(rUtil.Creditos,0),
		  movimiento  = NVL(rUtil.Debitos,0) + NVL(rUtil.Creditos,0),
	      mov_db_Dol  = nvl(rUtil.Debitos_Dol,0),
		  mov_cr_Dol  = nvl(rUtil.Creditos_Dol,0)
    Where no_Cia = pNo_Cia
      And Cuenta = vcuenta_util
	  And Ano    = pAno
	  And Mes    = pMes
	  And cc_1   = '000'
	  And cc_2   = '000'
	  And cc_3   = '000';
   IF SQL%rowcount = 0 THEN
      Insert into arcghc_c
	    (No_Cia,  cuenta,     ano,
		 mes,  	  periodo,
		 cc_1,    cc_2,       cc_3,
		 saldo,
		 saldo_dol,
		 mov_db,  mov_cr,
		 movimiento,
		 mov_db_dol, mov_cr_Dol) Values
		(pNo_Cia,  vcuenta_util, pAno,
		 pMes,  ((pAno*100)+pMes),
		 '000', '000',               '000',
		 NVL(rUtil.Saldo_Ant,0) + nvl(rUtil.Debitos,0) + nvl(rUtil.creditos,0),
		 NVL(rUtil.Saldo_Ant_Dol,0) + nvl(rUtil.Debitos_dol,0) + nvl(rUtil.creditos_dol,0),
		 nvl(rUtil.Debitos,0),  nvl(rUtil.Creditos,0),
		 nvl(rUtil.Debitos,0) + nvl(rUtil.Creditos,0),
	     nvl(rUtil.Debitos_Dol,0), nvl(rUtil.Creditos_Dol,0)
		 );
   END IF;
  -- --
  -- Actualiza el indicador de utilidades en el maestro de companias
  --
  UPDATE arcgmc
     SET indicador_utilidad = 'S'
   WHERE no_cia = pNo_Cia;
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGCalcula_Utilidades');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGCalcula_Utilidades');
END;