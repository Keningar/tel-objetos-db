create or replace PROCEDURE            CGmayoriza_resultado_ejercicio(
   pNucia             in varchar2,
   pAno               in number,
   pMes               in number,
   pCuentaMayorizar   in varchar2,
   pMontoNominal      in number,    -- Monto a mayorizar con signo positivo o negativo
   pMontoDolares      in number,
   pmsg_error         in out varchar2
 ) IS
  error_proceso  EXCEPTION;
  --
  CURSOR c_saldo_cta (pcuenta varchar2) IS
    SELECT nvl(saldo_mes_ant ,0) + nvl(debitos,0) + nvl(creditos,0) saldo,
           nvl(saldo_mes_ant_dol ,0) + nvl(debitos_dol,0) + nvl(creditos_dol,0) saldo_dol
      FROM arcgms
     WHERE no_cia = pNuCia
       AND cuenta = pcuenta;
  --
  cuentaEnProceso ARCGMS.cuenta%type;
  cencos1         ARCGCECO.cc_1%type;
  cencos2         ARCGCECO.cc_2%type;
  cencos3         ARCGCECO.cc_3%type;
  --- necesarios para crear la cta en MS_c, si no existe.
  vtipo           ARCGMS.tipo%type;
  vclase          ARCGMS.clase%type;
  vmonetaria      ARCGMS.monetaria%type;
  vajustable      ARCGMS.ajustable%type;
  vmoneda         ARCGMS.moneda%type;
  vsaldo_nom      Arcghc_c.saldo%type;
  vsaldo_dol      Arcghc_c.saldo_dol%type;
  --
  CURSOR c_datos_cta (pCuenta varchar2) IS
    SELECT tipo, clase, monetaria, ajustable, moneda
      FROM arcgms
     WHERE no_cia  = pnucia
       AND cuenta  = pCuenta;
  --
  CURSOR c_saldo_cta_cc (pcuenta varchar2,     pcc1 varchar2,
                         pcc2 varchar2,        pcc3 varchar2) IS
    SELECT nvl(saldo_mes_ant ,0) + nvl(debitos,0) + nvl(creditos,0) saldo,
           nvl(saldo_mes_ant_dol ,0) + nvl(debitos_dol,0) + nvl(creditos_dol,0) saldo_dol
      FROM arcgms_c
     WHERE no_cia = pnucia
       AND cuenta = pcuenta
       AND cc_1   = pcc1
       AND cc_2   = pcc2
       AND cc_3   = pcc3 ;
  --
BEGIN
  CuentaEnProceso := pCuentaMayorizar;
  cencos1         := '000';
  cencos2         := '000';
  cencos3         := '000';
  LOOP
    -- --
    -- Actualiza el Arcghc o inserta si no existe
    --
    UPDATE arcgms
       SET saldo_mes_ant     = nvl(saldo_mes_ant,0)     + pMontoNominal,
           saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + pMontoDolares
     WHERE cuenta  = cuentaEnProceso
       AND no_cia  = pNucia;
    --
    UPDATE arcghc
       SET saldo      = nvl(saldo,0)      + pMontoNominal,
           saldo_dol  = nvl(saldo_dol,0)  + pMontoDolares
     WHERE cuenta  = cuentaEnProceso
       AND no_cia  = pNucia
       AND mes     = pMes
       AND ano     = pAno;

    IF sql%rowcount = 0 THEN
      OPEN  c_saldo_cta (CuentaEnProceso);
      FETCH c_saldo_cta INTO vSaldo_Nom, vSaldo_Dol;
      CLOSE c_saldo_cta;
      --
      INSERT INTO arcghc (no_cia,    ano,     mes,
                          periodo,   cuenta,
                          saldo,      saldo_dol)
                  VALUES (pNucia,     pAno,    pMes,
                          (pAno*100) + pMes,   cuentaEnProceso,
                          vSaldo_Nom,      vSaldo_Dol);
    END IF;

    -- Mayoriza la cuenta, inserta si no existe
    UPDATE arcgms_c
       SET saldo_mes_ant     = nvl(saldo_mes_ant,0) + nvl(pmontoNominal,0),
           saldo_mes_ant_dol = nvl(saldo_mes_ant_dol,0) + nvl(pmontoDolares,0)
     WHERE no_cia   = pnucia
       AND cuenta  = CuentaEnProceso
       and cc_1    = cencos1
       and cc_2    = cencos2
       and cc_3    = cencos3 ;

    IF sql%rowcount = 0 THEN
      OPEN  c_Datos_Cta (CuentaEnProceso);
      FETCH c_Datos_Cta INTO vtipo, vclase, vmonetaria, vajustable, vmoneda;
      CLOSE c_Datos_Cta;

      INSERT INTO arcgms_c(no_cia,            cc_1,    cc_2,          cc_3,
                           cuenta,            tipo,    clase,         monetaria,
                           ajustable,         moneda,  saldo_per_ant, saldo_mes_ant,
                           saldo_per_ant_dol, saldo_mes_ant_dol)
                   VALUES (pnucia,          cencos1, cencos2, cencos3,
                           cuentaEnProceso, vtipo,   vclase,  vmonetaria,
                           vajustable,      vmoneda, 0,       nvl(pMontoNominal,0),
                           0,               nvl(pMontoDolares,0)   );
    END IF;
    -- ----------------------------------------------
    -- Actualiza el Arcghc_c o inserta si no existe
    -- ----------------------------------------------
    UPDATE arcghc_c
       SET saldo      = nvl(saldo,0)      + pMontoNominal,
           Saldo_Dol  = nvl(Saldo_Dol,0)  + pMontoDolares
     WHERE no_cia  = pnucia
       AND mes     = pmes
       AND ano     = pano
       AND cuenta  = CuentaEnProceso
       AND cc_1    = cencos1
       AND cc_2    = cencos2
       AND cc_3    = cencos3;

    IF sql%rowcount = 0 THEN
      OPEN  c_saldo_cta_CC (CuentaEnProceso, cencos1, cencos2, cencos3);
      FETCH c_saldo_cta_CC INTO vSaldo_Nom, vSaldo_Dol;
      CLOSE c_saldo_Cta_CC;

      INSERT INTO arcghc_c(no_cia,  ano,        mes,
                           cc_1,    cc_2,       cc_3,
                           periodo, cuenta,
                           saldo,  saldo_dol )
                    VALUES(pnucia,          pano,            pmes,
                           cencos1,         cencos2,         cencos3,
                           pAno*100+pMes,   cuentaEnProceso,
                           vSaldo_Nom,      vSaldo_Dol);
    END IF;
    IF Cuenta_Contable.Nivel(pNuCia, CuentaEnProceso) <= 1 THEN
      EXIT;
    ELSE
      CuentaEnProceso := Cuenta_Contable.Padre(pNuCia, CuentaEnProceso);
    END IF;
  END LOOP;
EXCEPTION
  WHEN error_proceso THEN
       pmsg_error := nvl(pmsg_error, 'CGmayoriza_Resultado_Ejercicio');
  WHEN others THEN
       pmsg_error := nvl(sqlerrm, 'CGmayoriza_Resultado_Ejercicio');
END CGmayoriza_Resultado_Ejercicio;