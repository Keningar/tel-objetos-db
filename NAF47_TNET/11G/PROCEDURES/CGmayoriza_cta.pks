create or replace PROCEDURE            CGmayoriza_cta(
   pNUCIA             in varchar2,
   PANO               in number,
   PMES               in number,
   pCUENTAMAYORIZAR   in varchar2,
   pMONTONOMINAL      in number,    -- Monto a mayorizar con signo positivo o negativo
   pMONTODOLARES      in number,
   pTIPOMOV           in varchar2,
   pmsg_error         in out varchar2
 ) IS
  -- --
  -- La reversion de una mayorizacion se identifica porque el
  -- el signo de los montos son invertido al tipo de movimiento
  -- por ejemplo.
  --   En la mayorizacion de un Credito el monto es negativo
  --   mientras que la reversion trae monto positivo
  --
  error_proceso  EXCEPTION;
  --
  cuentaEnProceso Arcgms.cuenta%type;
  vsaldo_nom      Arcghc_c.saldo%type;
  vsaldo_dol      Arcghc_c.saldo_dol%type;
  --
  cursor saldo_cta (pcuenta Varchar2) is
    select nvl(saldo_mes_ant ,0) + nvl(debitos,0) + nvl(creditos,0) saldo,
           nvl(saldo_mes_ant_dol ,0) + nvl(debitos_dol,0) + nvl(creditos_dol,0) saldo_dol
      from arcgms
     where no_cia = pNuCia
     and cuenta = pcuenta;
  --
BEGIN
  CuentaEnProceso := pCuentaMayorizar;
  LOOP
     -- --
     -- El algoritmo de mayorizacion recorre de la cuenta a mayorizar
     -- a la cuenta madre de primer nivel (mayor)
     --
     -- Mayoriza la cuenta
     --
     if pTipoMov = 'D' then
        update arcgms
           set debitos     = nvl(debitos,0)     + pMontoNominal,
               debitos_dol = nvl(debitos_dol,0) + pMontoDolares
         where cuenta  = cuentaEnProceso
           and no_cia  = pNucia;
     else
        update arcgms
           set creditos     = nvl(creditos,0)     + pMontoNominal,
               creditos_dol = nvl(creditos_dol,0) + pMontoDolares
         where cuenta  = cuentaEnProceso
           and no_cia  = pNucia;
     end if;
     -- ----------------------------------------------
     -- Actualiza el Arcghc o inserta si no existe
     -- ----------------------------------------------
     update arcghc
       set saldo      = nvl(saldo,0)      + pMontoNominal,
           saldo_dol  = nvl(saldo_dol,0)  + pMontoDolares,
           movimiento = nvl(movimiento,0) + pMontoNominal,
           mov_db     = nvl(mov_db,0)     + decode(pTipoMov,'D',pMontoNominal,0),
           mov_cr     = nvl(mov_cr,0)     + decode(pTipoMov,'C',pMontoNominal,0),
           mov_db_dol = nvl(mov_db_dol,0) + decode(pTipoMov,'D',pMontoDolares,0),
           mov_cr_dol = nvl(mov_cr_dol,0) + decode(pTipoMov,'C',pMontoDolares,0)
       where cuenta  = cuentaEnProceso
         and no_cia  = pNucia
         and mes     = pMes
         and ano     = pAno;
     if sql%rowcount = 0 then
         Open Saldo_Cta (CuentaEnProceso);
         Fetch Saldo_Cta into vSaldo_Nom, vSaldo_Dol;
         Close Saldo_Cta;
         --
         insert into arcghc (no_cia,    ano,     mes,
                             periodo,   cuenta,  movimiento,
                             mov_db,
                             mov_cr,
                             mov_db_dol,
                             mov_cr_dol,
                             saldo,      saldo_dol)
                      values(
                             pNucia,     pAno,    pMes,
                             (pAno*100) + pMes,   cuentaEnProceso, pmontoNominal,
                             decode(pTipoMov,'D',pmontoNominal,0),
                             decode(pTipoMov,'C',pmontoNominal,0),
                             decode(pTipoMov,'D',pmontoDolares,0),
                             decode(pTipoMov,'C',pmontoDolares,0),
                             vSaldo_Nom,      vSaldo_Dol);
      end if;
      IF Cuenta_Contable.Nivel(pNuCia, CuentaEnProceso) <= 1 THEN
         EXIT;
      ELSE
         CuentaEnProceso := Cuenta_Contable.Padre(pNuCia, CuentaEnProceso);
      END IF;
   END LOOP;
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGmayoriza_cta');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGmayoriza_cta');
END CGmayoriza_cta;