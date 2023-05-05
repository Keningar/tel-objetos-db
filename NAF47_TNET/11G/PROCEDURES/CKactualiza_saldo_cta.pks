create or replace PROCEDURE            CKactualiza_saldo_cta(
  pno_cia      IN varchar2,   -- compania
  pno_cta      IN varchar2,   -- cuenta bancaria
  ptipo_doc    IN varchar2,   -- tipo de documento
  pmonto       IN varchar2,   -- monto por el que se afecta el saldo
                              -- las anulaciones se denotan con signo negativo
  ptipo_cambio IN number,
  pestado_mov  IN varchar2,   -- D=Diario, M=Mensual
  pano_mov     IN number,     -- ano al que corresponde el monto
  pmes_mov     IN number,     -- mes al que corresponde el monto
  pfecha_mov   IN date,       -- fecha del movimiento
  msg_error_p  IN OUT varchar2
) IS
  --
  ves_anulacion    boolean;
  vmonto_dia       number;
  vmonto           number;
  vmonto_mes_ant   number;
  vtipo_mov        arcktd.tipo_mov%type;
  vano_mes_mov     number;
  vano_mes_proc    number;
  --
  error_proceso    exception;
  --
  CURSOR c_datos_cta IS
    SELECT ano_proc, mes_proc, ROWID
      FROM arckmc
     WHERE no_cia  = pno_cia
       AND no_cta  = pno_cta;
  --
  CURSOR c_tipo_mov IS
    SELECT tipo_mov
      FROM arcktd
     WHERE no_cia   = pno_cia
       AND tipo_doc = ptipo_doc;
  --
  vrcta     c_datos_cta%rowtype;
  vck_tr    arckhc.che_mes%type := 0;
  vdep      arckhc.dep_mes%type := 0;
  vdeb      arckhc.deb_mes%type := 0;
  vcre      arckhc.cre_mes%type := 0;
BEGIN
  vmonto        := nvl(pmonto,0);
  ves_anulacion := (vmonto < 0);
  IF pestado_mov = 'D' THEN
    vmonto_dia  := vmonto;
  ELSE
    vmonto_dia  := 0;
  END IF;
  --
  vtipo_mov := null;
  OPEN  c_tipo_mov;
  FETCH c_tipo_mov INTO vtipo_mov;
  CLOSE c_tipo_mov;

  IF vtipo_mov is null or vtipo_mov not in ('D','C') THEN
    msg_error_p := 'No existe tipo doc. '||ptipo_doc||' en o tiene un tipo de movimiento incorrecto';
    RAISE error_proceso;
  END IF;
  --
  -- obtiene el a?o y mes en proceso
  OPEN  c_datos_cta;
  FETCH c_datos_cta INTO vrcta;
  CLOSE c_datos_cta;
  --
  vano_mes_mov  := (pano_mov * 100) + pmes_mov;
  vano_mes_proc := (vrcta.ano_proc * 100) + vrcta.mes_proc;
  --
  IF vano_mes_mov < vano_mes_proc THEN
  	-- El a?o y mes del movimiento es anterior al periodo en proceso
    IF ves_anulacion and ptipo_doc IN ('CK','TR','AD') THEN
      -- Anulacion de cheques y transferencias
  	  UPDATE arckmc
  	     SET che_anulmesant = nvl(che_anulmesant,0) + abs(vmonto),
               sal_dia_ant    = nvl(sal_dia_ant,0) + abs(vmonto)
       WHERE rowid = vrcta.rowid;
    ELSE
      -- Los debitos aumenta el saldo de la cuenta cuando no son anulaciones
      IF vtipo_mov = 'D' THEN
        vmonto_mes_ant := vmonto;
     	ELSE
        vmonto_mes_ant := - vmonto;
     	END IF;
     	--
     	-- actualiza saldo anterior de la cuenta bancaria
      UPDATE arckmc
         SET sal_mes_ant = nvl(sal_mes_ant,0) + vmonto_mes_ant,
             sal_dia_ant = nvl(sal_dia_ant,0) + vmonto_mes_ant
       WHERE no_cia = pno_cia
         AND no_cta = pno_cta;
      --
      -- actualiza saldos de la historia
      UPDATE arckhc
         SET saldo_fin_c = nvl(saldo_fin_c,0) + vmonto_mes_ant
       WHERE no_cia = pno_cia
         AND no_cta = pno_cta
         AND ((ano * 100) + mes) >= vano_mes_mov;
      --
      UPDATE arcksd
         SET saldo_dia = nvl(saldo_dia,0) + vmonto_mes_ant
       WHERE no_cia = pno_cia
         AND no_cta = pno_cta
         AND dia_cierre >= trunc(pfecha_mov);

      --
      -- actualiza el desglose por documento en la historia
      vck_tr := 0;
      vdep   := 0;
      vdeb   := 0;
      vcre   := 0;

      IF ptipo_doc IN ('CK','TR','AD') THEN
      	vck_tr := vmonto;
      ELSIF ptipo_doc = 'DP' THEN
      	vdep   := vmonto;
      ELSIF vtipo_mov = 'D' THEN
      	vdeb   := vmonto;
      ELSIF vtipo_mov = 'C' THEN
      	vcre   := vmonto;
      END IF;

      UPDATE arckhc
         SET che_mes = nvl(che_mes, 0) + vck_tr,
             dep_mes = nvl(dep_mes, 0) + vdep,
             deb_mes = nvl(deb_mes, 0) + vdeb,
             cre_mes = nvl(cre_mes, 0) + vcre
       WHERE no_cia = pno_cia
         AND no_cta = pno_cta
         AND ((ano * 100) + mes) = vano_mes_mov;
    END IF;
  ELSIF vano_mes_mov = vano_mes_proc THEN

    -- movimiento del mes en proceso
    -- Si ya se hizo el cierre diario debe devolverse a arreglar saldo

    IF pestado_mov = 'M' THEN
      -- Los debitos aumentan el saldo de la cuenta cuando no son anulaciones
      IF vtipo_mov = 'D' THEN
        vmonto_mes_ant := vmonto;
      ELSE
        vmonto_mes_ant := - vmonto;
      END IF;
      --
      -- actualiza saldo diario anterior de la cuenta bancaria
      UPDATE arckmc
         SET sal_dia_ant = nvl(sal_dia_ant,0) + vmonto_mes_ant
       WHERE rowid = vrcta.rowid;

    END IF;

    IF ptipo_doc IN ('CK','TR','AD') THEN
     	-- cheques y transferencias
      UPDATE arckmc
         SET che_dia = nvl(che_dia,0) + vmonto_dia,
             che_mes = nvl(che_mes,0) + vmonto
       WHERE rowid = vrcta.rowid;
    ELSIF ptipo_doc = 'DP' THEN
      -- actualiza DEPOSITOS
      UPDATE arckmc
         SET dep_dia = nvl(dep_dia,0) + vmonto_dia,
             dep_mes = nvl(dep_mes,0) + vmonto
       WHERE rowid = vrcta.rowid;
    ELSE
      -- otros movimientos
      IF vtipo_mov = 'C' THEN
        -- actualiza CREDITOS
        UPDATE arckmc
           SET cre_dia = nvl(cre_dia,0) + vmonto_dia,
               cre_mes = nvl(cre_mes,0) + vmonto
         WHERE rowid = vrcta.rowid;
      ELSE
        -- actualiza DEBITOS
        UPDATE arckmc
           SET deb_dia = nvl(deb_dia,0) + vmonto_dia,
               deb_mes = nvl(deb_mes,0) + vmonto
         WHERE rowid = vrcta.rowid;
      END IF;
    END IF;  -- tipo doc
  END IF;
EXCEPTION
  WHEN error_proceso THEN
     msg_error_p := nvl( msg_error_p, 'Error en ckactualiza_saldo_cta');
     RETURN;
END;