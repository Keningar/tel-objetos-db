create or replace PROCEDURE            CGCalcUtil_Cia(
   PCIA           in     varchar2,
   PANO           in     number,
   PMES           in     number,
   pInd_Ajuste    in     varchar2,
   pmsg_error     in out varchar2
 ) IS
   --
   error_proceso  EXCEPTION;
   -- --
   -- Definicion de Cursores
   --
   -- Cuentas que no reciben los movimientos por ajustes en
   -- una compa?ia que aplica ajustes inflacionales
   --
   cursor obt_utilidad1 is
    select sum(nvl(saldo_mes_ant,0)),
	       sum(nvl(saldo_mes_ant_dol,0)),
	       sum(nvl(debitos,0))    + sum(nvl(creditos,0)),
           sum(nvl(debitos_dol,0) + nvl(creditos_dol,0))
      from arcgms a
     where no_cia    =  pcia
       and ind_mov   =  'S'
       and clase     IN ('I', 'G')
       and not Exists (select cta_correccion
                         From arcgms b
                        Where a.no_cia = b.no_cia
                          AND a.cuenta = b.cta_correccion );
   --
   -- Cuentas que reciben los movimientos por ajustes en
   -- una compa?ia que aplica ajustes inflacionales
   --
   cursor obt_utilidad2 is
    select sum(nvl(saldo_mes_ant,0)),
	       sum(nvl(saldo_mes_ant_dol,0)),
	       sum(nvl(debitos,0))    + sum(nvl(creditos,0)),
           sum(nvl(debitos_dol,0) + nvl(creditos_dol,0))
      from arcgms a
     where no_cia    =  pcia
       and ind_mov   =  'S'
       and clase     IN ('I', 'G')
       and Exists (select cta_correccion
                     From arcgms b
                    Where a.no_cia = b.no_cia
                      AND a.cuenta = b.cta_correccion );
   --
   -- Todas las cuentas en una compa?ia que NO aplica ajustes inflacionales
   --
   cursor obt_utilidad is
    select sum(nvl(saldo_mes_ant,0)),
	       sum(nvl(saldo_mes_ant_dol,0)),
	       sum(nvl(debitos,0))    + sum(nvl(creditos,0)),
           sum(nvl(debitos_dol,0) + nvl(creditos_dol,0))
      from arcgms
     where no_cia    =  pcia
       and nivel     =  1
       and clase     IN ('I', 'G');
   --
   Cursor c_Cta_Util (pAjuste Varchar2) IS
      Select cuenta, debitos, creditos, debitos_dol, creditos_dol
      From arcgms
     Where no_cia    = pCia
       And clase     = '9'
       And nivel     = 2
       And Ajustable = nvl(pAjuste, 'N');
  -- --
  -- Se definen las variables
  --
  vUtil_Per         arcgms.debitos%type      := 0;
  vUtil_Per_Dol     arcgms.debitos_dol%type  := 0;
  vSaldo_Ant        arcghc.saldo%type        := 0;
  vSaldo_Ant_Dol    arcghc.saldo_dol%type    := 0;
  --
  vRegCta_Util      c_Cta_Util%rowtype;
  --
  vAjuste           Varchar2(1);
  vDebitos          ARCGMS.Debitos%type;
  vCreditos         ARCGMS.Creditos%type;
  vDebitos_Dol      ARCGMS.Debitos_Dol%type;
  vCreditos_Dol     ARCGMS.Creditos_Dol%type;
--
-- PL/SQL Block
BEGIN
   --
   vAjuste := NVL(pInd_Ajuste, 'N');
   -- --
   -- Obtiene la cuenta de utilidades a calcular
   --
   Open  c_Cta_Util (vAjuste);
   Fetch c_Cta_Util INTO vRegCta_Util;
   Close c_Cta_Util;
   -- --
   --  Obtiene utilidades del mes en proceso
   --
   IF pInd_Ajuste IS NULL THEN
      -- Obtiene las utilidad de las cuentas de Ingreso y Gasto
      -- para la compa?ia general
      OPEN  OBT_UTILIDAD;
      FETCH OBT_UTILIDAD INTO vSaldo_Ant, vSaldo_Ant_Dol, vUtil_Per, vUtil_Per_Dol;
      CLOSE OBT_UTILIDAD;
   ELSIF pInd_Ajuste = 'N' THEN
      -- Obtiene las utilidad de las cuentas de Ingreso y Gasto
      -- que NO se utilizan en los procesos de ajustes inflacionarios
      OPEN  OBT_UTILIDAD1;
      FETCH OBT_UTILIDAD1 INTO vSaldo_Ant, vSaldo_Ant_Dol, vUtil_Per, vUtil_Per_Dol;
      CLOSE OBT_UTILIDAD1;
   ELSE
      -- pInd_Ajuste = 'S'
      -- Obtiene las utilidad de las cuentas de Ingreso y Gasto
      -- que se utilizan en los procesos de ajustes inflacionarios
      OPEN  OBT_UTILIDAD2;
      FETCH OBT_UTILIDAD2 INTO vSaldo_Ant, vSaldo_Ant_Dol, vUtil_Per, vUtil_Per_Dol;
      CLOSE OBT_UTILIDAD2;
   END IF;
   vSaldo_Ant     := nvl(vSaldo_Ant,0);
   vSaldo_Ant_Dol := nvl(vSaldo_Ant_Dol,0);
   vUtil_Per      := nvl(vUtil_Per, 0);
   vUtil_Per_Dol  := nvl(vUtil_Per_Dol, 0);
   -- --
   -- Revisa utilidad o perdida en moneda nominal
   --
   IF NVL(vUtil_Per,0) > 0 THEN
      vDebitos  := NVL(vUtil_Per,0);
      vCreditos := 0;
   ELSE
      vDebitos  := 0;
      vCreditos := NVL(vUtil_Per,0);
   END IF;
   -- --
   -- Revisa utilidad o perdida en dolares
   --
   IF NVL(vUtil_Per_Dol,0) > 0 THEN
      vDebitos_Dol  := NVL(vUtil_Per_Dol,0);
      vCreditos_Dol := 0;
   ELSE
      vDebitos_Dol  := 0;
      vCreditos_Dol := NVL(vUtil_Per_Dol,0);
   END IF;
   Update arcgms
   	  Set Debitos           = nvl(vDebitos,0),
	      Creditos          = nvl(vCreditos,0),
	      Debitos_Dol       = nvl(vDebitos_Dol,0),
		  Creditos_Dol      = nvl(vCreditos_Dol,0)
    Where no_Cia = pCia
      And Cuenta = vRegCta_Util.cuenta;
   Update arcgms_c
	  Set Debitos           = nvl(vDebitos,0),
	      Creditos          = nvl(vCreditos,0),
	      Debitos_Dol       = nvl(vDebitos_Dol,0),
		  Creditos_Dol      = nvl(vCreditos_Dol,0)
    Where no_Cia = pCia
      And Cuenta = vRegCta_Util.cuenta
	  And cc_1   = '000'
	  And cc_2   = '000'
	  And cc_3   = '000';
   Update arcghc
	  Set Saldo       = NVL(vSaldo_Ant,0)     + nvl(vDebitos,0)     + nvl(vcreditos,0),
	      Saldo_dol   = NVL(vSaldo_Ant_Dol,0) + nvl(vDebitos_dol,0) + nvl(vcreditos_dol,0),
	      mov_db      = nvl(vDebitos,0),
	      mov_cr      = nvl(vCreditos,0),
		  movimiento  = nvl(vDebitos,0) + nvl(vCreditos,0),
	      mov_db_Dol  = nvl(vDebitos_Dol,0),
		  mov_cr_Dol  = nvl(vCreditos_Dol,0)
    Where no_Cia = pCia
      And Cuenta = vRegCta_Util.cuenta
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
		(pCia, vRegCta_Util.cuenta, pAno,
		 pMes,  ((pAno*100)+pMes),
		 NVL(vSaldo_Ant,0) + nvl(vDebitos,0) + nvl(vcreditos,0),
		 NVL(vSaldo_Ant_Dol,0) + nvl(vDebitos_dol,0) + nvl(vcreditos_dol,0),
		 nvl(vDebitos,0),  nvl(vCreditos,0),
		 nvl(vDebitos,0) + nvl(vCreditos,0),
	     nvl(vDebitos_Dol,0), nvl(vCreditos_Dol,0)
		 );
   END IF;
   Update arcghc_c
	  Set Saldo       = NVL(vSaldo_Ant,0)     + nvl(vDebitos,0)     + nvl(vcreditos,0),
	      Saldo_dol   = NVL(vSaldo_Ant_Dol,0) + nvl(vDebitos_dol,0) + nvl(vcreditos_dol,0),
	      mov_db      = nvl(vDebitos,0),
	      mov_cr      = nvl(vCreditos,0),
		  movimiento  = nvl(vDebitos,0) + nvl(vCreditos,0),
	      mov_db_Dol  = nvl(vDebitos_Dol,0),
		  mov_cr_Dol  = nvl(vCreditos_Dol,0)
    Where no_Cia = pCia
      And Cuenta = vRegCta_Util.cuenta
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
		(pCia,  vRegCta_Util.cuenta, pAno,
		 pMes,  ((pAno*100)+pMes),
		 '000', '000',               '000',
		 NVL(vSaldo_Ant,0) + nvl(vDebitos,0) + nvl(vcreditos,0),
		 NVL(vSaldo_Ant_Dol,0) + nvl(vDebitos_dol,0) + nvl(vcreditos_dol,0),
		 nvl(vDebitos,0),  nvl(vCreditos,0),
		 nvl(vDebitos,0) + nvl(vCreditos,0),
	     nvl(vDebitos_Dol,0), nvl(vCreditos_Dol,0)
		 );
   END IF;
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGCalcUtil_Cia');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGCalcUtil_Cia');
END;   -- CGCalcUtil_Cia