create or replace PROCEDURE            CSMayorizar(
  pNucia   varchar2,
  pAno     number,
  pMes     number,
  pCuenta  varchar2,
  pCentro  varchar2,
  pMonto   number,
  pMoneda  varchar2,
  pTipomov varchar2
) IS
  --
  vCuentaEnProceso  arcshc.cuenta%type;
  vCCqmayo          arcshc.cen_cos%type;
  vEntro            boolean := false;
  vNivel_cc         number ;

BEGIN
  vCuentaenProceso  := pCuenta;
  LOOP
    vCCqmayo  := pCentro;

    --
    -- determina el nivel del centro de costo.
    IF substr(pCentro, 7, 3) <> '000' THEN
      vNivel_cc := 3;
    ELSIF substr(pCentro, 4, 3) <> '000' THEN
    	vNivel_cc := 2;
    ELSIF substr(pCentro, 1, 3) <> '000' THEN
    	vNivel_cc := 1;
    END IF;

    LOOP
      IF pTipoMov = 'D' THEN
        UPDATE arcshc
           SET mov_db    = nvl(mov_db,0) +  nvl(pMonto,0),
               saldo_act = nvl(saldo_ini,0) + nvl(mov_db,0) +  nvl(pMonto,0) + nvl(mov_cr,0),
               movim_mes = nvl(mov_db,0) +  nvl(pMonto,0) + nvl(mov_cr,0)
         WHERE no_cia  = pNucia
           AND ano     = pAno
           AND mes     = pMes
           AND cuenta  = vCuentaEnProceso
           AND cen_cos = vCCqmayo
           AND moneda  = pMoneda;

        IF sql%notfound THEN
          INSERT INTO arcshc (no_cia,    ano,    mes,    cuenta,    cen_cos,
                              saldo_ini, mov_db, mov_cr, saldo_act, movim_mes, moneda)
                      VALUES (pNucia, pAno, pMes, vCuentaenproceso, vCCqmayo,
                              0, nvl(pMonto,0), 0, nvl(pMonto,0), nvl(pMonto,0), pMoneda);
        END IF;
      ELSE
        UPDATE arcshc
           SET mov_cr    = nvl(mov_cr,0) +  nvl(pMonto,0),
               saldo_act = nvl(saldo_ini,0) + nvl(mov_db,0) + nvl(mov_cr,0) +  nvl(pMonto,0),
               movim_mes = nvl(mov_db,0) + nvl(mov_cr,0) + nvl(pMonto,0)
         WHERE no_cia  = pNucia
           AND ano     = pAno
           AND mes     = pMes
           AND cuenta  = vCuentaEnProceso
           AND cen_cos = vCCqmayo
           AND moneda  = pMoneda;

        IF sql%notfound THEN
          INSERT INTO arcshc (no_cia,    ano,    mes,    cuenta,    cen_cos,
                              saldo_ini, mov_db, mov_cr, saldo_act, movim_mes, moneda)
                      VALUES (pNucia, pAno, pMes, vCuentaenproceso, vCCqmayo,
                              0, 0, nvl(pMonto,0), nvl(pMonto,0), nvl(pMonto,0), pMoneda);
        END IF;
      END IF;

      IF vCCqmayo = '000000000' THEN
      	exit;
      END IF;

      vNivel_cc := vNivel_cc - 1;
    	vCCqmayo := rpad(nvl(substr(vCCqmayo, 1, 3*vNivel_cc), '0'), 9, '0');

    END LOOP; -- de centro de costo

    IF cuenta_contable.nivel(pNuCia, vCuentaEnProceso) <= 1 THEN
      exit;
    ELSE
      vCuentaEnProceso := Cuenta_Contable.Padre(pNuCia, vCuentaEnProceso);
    END IF;
  END LOOP; -- de cuenta_contable
END; --- De CSmayorizar