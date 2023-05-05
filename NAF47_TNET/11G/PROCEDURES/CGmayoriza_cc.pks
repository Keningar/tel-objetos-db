create or replace PROCEDURE            CGmayoriza_cc(
  pnucia            in varchar2,
  pano              in number,
  pmes              in number,
  pcuentamayorizar  in varchar2,
  pcentroqmayoriza  in varchar2,
  pmontonominal     in number,
  pmontodolares     in number,
  ptipomov          in varchar2,
  pmsg_error        in out varchar2
 )
 IS
  -- --
  -- La reversion de una mayorizacion se identifica porque el
  -- el signo de los montos son invertido al tipo de movimiento
  -- por ejemplo.
  --   En la mayorizacion de un Credito el monto es negativo
  --   mientras que la reversion trae monto positivo
  --
  error_proceso  EXCEPTION;
  --
  cuentaEnProceso ARCGMS.cuenta%type;
  cencos1         ARCGCECO.cc_1%TYPE;
  cencos2         ARCGCECO.cc_2%TYPE;
  cencos3         ARCGCECO.cc_3%TYPE;
  --- necesarios para crear la cta en MS_c, si no existe.
  vtipo           ARCGMS.tipo%TYPE;
  vclase          ARCGMS.clase%TYPE;
  vmonetaria      ARCGMS.monetaria%TYPE;
  vajustable      ARCGMS.ajustable%TYPE;
  vmoneda         ARCGMS.moneda%TYPE;
  vsaldo_nom      Arcghc_c.saldo%type;
  vsaldo_dol      Arcghc_c.saldo_dol%type;
  --
  cursor c_datos_cta (pCuenta VARCHAR2) IS
     select tipo, clase, monetaria, ajustable, moneda
       from ARCGMS
      where no_cia  = pnucia
        and cuenta  = pCuenta;
  --
  cursor saldo_cta_cc (pcuenta Varchar2,
                       pcc1 Varchar2,
                       pcc2 Varchar2,
                       pcc3 Varchar2) is
    select nvl(saldo_mes_ant ,0) + nvl(debitos,0) + nvl(creditos,0) saldo,
           nvl(saldo_mes_ant_dol ,0) + nvl(debitos_dol,0) + nvl(creditos_dol,0) saldo_dol
      from arcgms_c
     where no_cia = pnucia
     and cuenta = pcuenta
     and cc_1   = pcc1
     and cc_2   = pcc2
     and cc_3   = pcc3 ;
-- PL/SQL Block
BEGIN
  CuentaEnProceso := pCuentaMayorizar;
  cencos1         := substr(pCentroqMayoriza,1,3);
  cencos2         := substr(pCentroqMayoriza,4,3);
  cencos3         := substr(pCentroqMayoriza,7,3);
  --
  LOOP
     -- --
     -- El algoritmo de mayorizacion recorre de la cuenta hija a la cuenta
     -- madre de nivel uno (de mayor)
     --
     -- Mayoriza la cuenta, inserta si no existe
     update arcgms_c
        set debitos     = nvl(debitos,0)      + DECODE(pTipoMov,'D',pmontoNominal,0),
            debitos_dol = nvl(debitos_dol,0)  + DECODE(pTipoMov,'D',pmontoDolares,0),
            creditos    = nvl(creditos,0)     + DECODE(pTipoMov,'C',pmontoNominal,0),
            creditos_dol= nvl(creditos_dol,0) + DECODE(pTipoMov,'C',pmontoDolares,0)
        where no_cia  = pnucia
          and cuenta  = CuentaEnProceso
          and cc_1    = cencos1
          and cc_2    = cencos2
          and cc_3    = cencos3 ;
     if sql%rowcount = 0 then
         Open c_Datos_Cta (CuentaEnProceso);
         Fetch c_Datos_Cta INTO vtipo, vclase, vmonetaria, vajustable, vmoneda;
         Close c_Datos_Cta;
         Begin
         insert into arcgms_c(
                    no_cia,            cc_1,    cc_2,          cc_3,
                    cuenta,            tipo,    clase,         monetaria,
                    ajustable,         moneda,  saldo_per_ant, saldo_mes_ant,
                    saldo_per_ant_dol, saldo_mes_ant_dol,
                    debitos,
                    debitos_dol,
                    creditos,
                    creditos_dol )
              values(
                    pnucia,          cencos1, cencos2, cencos3,
                    cuentaEnProceso, vtipo,   vclase,  vmonetaria,
                    vajustable,      vmoneda, 0,       0,
                    0,               0,
                    DECODE(pTipoMov, 'D', nvl(pMontoNominal,0), 0),
                    DECODE(pTipoMov, 'D', nvl(pMontoDolares,0), 0),
                    DECODE(pTipoMov, 'C', nvl(pMontoNominal,0), 0),
                    DECODE(pTipoMov, 'C', nvl(pMontoDolares,0), 0)  );
          Exception
           When Others then
            pmsg_error := substr('Error arcgms_c '|| cuentaEnProceso||' cc1 '||cencos1||' cc2 '||cencos2||' cc3 '||cencos3||' '||sqlerrm,1,150);
            raise error_proceso;
          end;
     end if;
     -- ----------------------------------------------
     -- Actualiza el Arcghc_c o inserta si no existe
     -- ----------------------------------------------
     update arcghc_c
       set saldo      = nvl(saldo,0)      + pMontoNominal,
           Saldo_Dol  = nvl(Saldo_Dol,0)  + pMontoDolares,
           movimiento = nvl(movimiento,0) + pmontoNominal,
           mov_db     = nvl(mov_db,0)     + decode(pTipoMov,'D',pMontoNominal,0),
           mov_cr     = nvl(mov_cr,0)     + decode(pTipoMov,'C',pMontoNominal,0),
           mov_db_dol = nvl(mov_db_dol,0) + decode(pTipoMov,'D',pMontoDolares,0),
           mov_cr_dol = nvl(mov_cr_dol,0) + decode(pTipoMov,'C',pMontoDolares,0)
        where no_cia  = pnucia
          and mes     = pmes
          and ano     = pano
          and cuenta  = CuentaEnProceso
          and cc_1    = cencos1
          and cc_2    = cencos2
          and cc_3    = cencos3  ;
     if sql%rowcount = 0 then
         Open Saldo_Cta_CC (CuentaEnProceso, cencos1, cencos2, cencos3);
         Fetch Saldo_Cta_CC into vSaldo_Nom, vSaldo_Dol;
         Close Saldo_Cta_CC;
         Insert into arcghc_c(
                   no_cia,  ano,        mes,
                   cc_1,    cc_2,       cc_3,
                   periodo, cuenta, movimiento,
                   mov_db,
                   mov_cr,
                   mov_db_dol,
                   mov_cr_dol,
                   saldo,  saldo_dol )
             values(
                   pnucia,          pano,            pmes,
                   cencos1,         cencos2,         cencos3,
                   pAno*100+pMes,   cuentaEnProceso, pmontoNominal,
                   decode(pTipoMov, 'D', pMontoNominal, 0),
                   decode(pTipoMov, 'C', pMontoNominal, 0),
                   decode(pTipoMov, 'D', pMontoDolares, 0),
                   decode(pTipoMov, 'C', pMontoDolares, 0),
                   vSaldo_Nom,      vSaldo_Dol);
      end if;
      IF Cuenta_Contable.nivel(pNucia, CuentaEnProceso) <= 1 THEN
         EXIT;
      ELSE
         CuentaEnProceso := Cuenta_Contable.padre(pNucia, CuentaEnProceso);
      END IF;
   END LOOP;
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGmayoriza_CC');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGmayoriza_CC');
END CGmayoriza_cc;