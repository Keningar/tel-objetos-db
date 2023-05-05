create or replace FUNCTION            CSsaldo_ctas (
  pCia        varchar2,
  pCta        varchar2,
  pCencos     varchar2,
  pAno        number,
  pMesproc    number,
  pMescierre  number,
  pMoneda     varchar2
) RETURN number IS
  --
  v_ano_hasta number(4) := pAno;
  v_ano_desde number(4) := v_ano_hasta;
  v_mes_hasta number(2) := pMescierre;
  v_mes_desde number(2) := v_mes_hasta;
  v_saldo arcshc.saldo_act%type;
  --
  CURSOR c_saldo_acum IS
    SELECT movim_mes
      FROM arcshc
     WHERE no_cia  = pCia
       AND cuenta  = pCta
       AND cen_cos = pCencos
       AND moneda  = pMoneda
       AND to_number(ano||lpad(mes,2,'0')) between
           to_number(v_ano_desde||lpad(v_mes_desde,2,'0')) and
           to_number(v_ano_hasta||lpad(v_mes_hasta,2,'0'));

BEGIN
  --
  -- calcula el rango de ano/mes desde y ano/mes hasta del periodo fiscal
  FOR i IN 1..11 LOOP
    v_mes_desde := v_mes_desde - 1;
    IF v_mes_desde = 0 THEN
      v_mes_desde := 12;
      v_ano_desde := v_ano_desde - 1;
    END IF;
  END LOOP;

  OPEN  c_saldo_acum;
  FETCH c_saldo_acum INTO v_saldo;
  CLOSE c_saldo_acum;

  return (nvl(v_saldo,0));
END;