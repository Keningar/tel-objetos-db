create or replace procedure            CGDesglose(
  pcia       in ARCGMS.NO_CIA%type,
  pcta       in ARCGMS.cuenta%type,
  pmsg_error in out VARCHAR2
) IS
  nueva_cta     ARCGMS.CUENTA%type;
  vProcesando   Varchar2(150);
BEGIN
    -- Define el valor para la nueva cuenta
    vProcesando := 'Formando Cuenta Hija';
    --
    Nueva_Cta   := Cuenta_Contable.Nueva_Hija(pcia, pcta, '1');
    --
    -- crea nueva cuenta en el maestro de saldos
    vProcesando := 'Registrando Cuenta Hija en Maestro de Saldos';
    insert into arcgms
          (no_cia,            cuenta,            padre,
           nivel,             descri,
           tipo,              clase,             ind_mov,
           ind_presup,        debitos,           creditos,
           saldo_per_ant,     saldo_mes_ant,     descri_1,
           moneda,            activa,            debitos_dol,
           creditos_dol,      saldo_per_ant_dol, saldo_mes_ant_dol,
           PERMISO_CON,       PERMISO_CHE,       PERMISO_CXP,
           PERMISO_PLA,       PERMISO_AFIJO,     PERMISO_INV,
           PERMISO_APROV,     PERMISO_FACT,      PERMISO_CXC,
           PERMISO_TPM_INV,   PERMISO_TPM_COM,   PERMISO_TPM_C2P,
           MONETARIA,         acepta_cc,         tcambio_conversion,
           compartido,
           Presup_Cambio,     ajustable,         usado_en,
           permiso_CCH,       ind_tercero,       cta_ajuste_inflacion,
           cta_correccion,    cod_ajuste,        descri_larga,
           naturaleza)
    select no_cia,            nueva_Cta,         pcta,
           nivel+1,           descri,
           tipo,              clase,             ind_mov,
           ind_presup,        debitos,           creditos,
           saldo_per_ant,     saldo_mes_ant,     descri_1,
           moneda,            activa,            debitos_dol,
           creditos_dol,      saldo_per_ant_dol, saldo_mes_ant_dol,
           PERMISO_CON,       PERMISO_CHE,       PERMISO_CXP,
           PERMISO_PLA,       PERMISO_AFIJO,     PERMISO_INV,
           PERMISO_APROV,     PERMISO_FACT,      PERMISO_CXC,
           PERMISO_TPM_INV,   PERMISO_TPM_COM,   PERMISO_TPM_C2P,
           MONETARIA,         acepta_cc,         tcambio_conversion,
           compartido,
           Presup_Cambio,     ajustable,         usado_en,
           permiso_CCH,       ind_tercero,       cta_ajuste_inflacion,
           cta_correccion,    cod_ajuste,        descri_larga,
           naturaleza
      from arcgms
     where no_cia = pcia
       and cuenta = pcta;
    --
    -- crea nueva cuenta en el maestro de saldos de centros de costo
    vProcesando  := 'Registrando Cuenta Hija en Maestro de Saldo por Centros';
    insert into arcgms_c
             (no_cia,       cc_1,              cc_2,              cc_3,
              cuenta,       tipo,              clase,             monetaria,
              moneda,       saldo_per_ant,     saldo_mes_ant,     debitos,
              creditos,     saldo_per_ant_dol, saldo_mes_ant_dol, debitos_dol,
              creditos_dol, nivel,             ajustable)
    select no_cia,        cc_1,              cc_2,              cc_3,
           nueva_cta,     tipo,              clase,             monetaria,
           moneda,        saldo_per_ant,     saldo_mes_ant,     debitos,
           creditos,      saldo_per_ant_dol, saldo_mes_ant_dol, debitos_dol,
           creditos_dol,  nivel+1,           ajustable
      from arcgms_c
     where no_cia = pcia
       and cuenta = pcta;
    --
    vProcesando := 'Registrando cuenta hija en historico';
    -- insert nueva cuenta en el historico de cuentas
    insert into arcghc
           (no_cia,       ano,        mes,          periodo,
            cuenta,       movimiento, mov_db,       mov_cr,
			      saldo,        mov_db_dol, mov_cr_dol,   saldo_dol,
			      ajuste_pcgas, saldo_conv, tasa_conv )
     select no_cia,       ano,        mes,          periodo,
            nueva_cta,    movimiento, mov_db,       mov_cr,
			      saldo,        mov_db_dol, mov_cr_dol,   saldo_dol,
			      ajuste_pcgas, saldo_conv, tasa_conv
       from arcghc
      where no_cia  = pcia
        and cuenta  = pcta;
    --
    vProcesando := 'Registrando cuenta hija en historico por centro';
    insert into arcghc_c
          (no_cia,     ano,        mes,        periodo,
           cuenta,     cc_1,       cc_2,       cc_3,
           presu_ini,  presu,      pres_ac,    movimiento,
           mov_db,     mov_cr,     saldo,      mov_db_dol,
           mov_cr_dol, saldo_dol,  saldo_conv)
       select no_cia,     ano,        mes,        periodo,
              nueva_cta,  cc_1,       cc_2,       cc_3,
              presu_ini,  presu,      pres_ac,    movimiento,
              mov_db,     mov_cr,     saldo,      mov_db_dol,
              mov_cr_dol, saldo_dol,  saldo_conv
         from arcghc_c
        where no_cia  = pcia
          and cuenta  = pcta;
    --
    vProcesando := 'Registrando cuenta hija en historico por tercero';
    insert into arcghc_t
          (no_cia,     ano,             mes,        periodo,
           cuenta,     codigo_tercero,  movimiento, mov_db,
           mov_cr,     saldo,           mov_db_dol, mov_cr_dol,
           saldo_dol)
       select no_cia,     ano,             mes,        periodo,
              nueva_cta,  codigo_tercero,  movimiento, mov_db,
              mov_cr,     saldo,           mov_db_dol, mov_cr_dol,
              saldo_dol
         from arcghc_t
        where no_cia  = pcia
          and cuenta  = pcta;
    --
    vProcesando := 'Borrando cuenta madre en historico por tercero';
    Delete from arcghc_t
      where no_cia = pCia
        and cuenta = pCta;
    --
    -- pone el indicador de movimientos en N de la cuenta desglosada y
    -- desactiva los permisos de los sistemas
    update arcgms
       set PERMISO_CON        = 'N',
           PERMISO_CHE        = 'N',
           PERMISO_CXP        = 'N',
           PERMISO_PLA        = 'N',
           PERMISO_AFIJO      = 'N',
           PERMISO_INV        = 'N',
           PERMISO_APROV      = 'N',
           PERMISO_FACT       = 'N',
           PERMISO_CXC        = 'N',
           PERMISO_CCH        = 'N',
           PERMISO_TPM_INV    = 'N',
           PERMISO_TPM_COM    = 'N',
           PERMISO_TPM_C2P    = 'N',
           ind_mov            = 'N',
           ind_presup         = 'N',
           acepta_cc          = 'N',
           monetaria          = 'N',
           tcambio_conversion = 'X',
           compartido         = 'N'
     where no_cia  = pCia
       and cuenta  = pcta;
   -- cambia la cuenta en las lineas de los asientos por la nueva cuenta
   vProcesando := 'Actualizando cuenta en lineas de asientos';
   update arcgal
        set cuenta  = nueva_cta
      where no_cia  = pcia
        and cuenta  = pcta;
   -- cambia las lineas del historico de movimientos por la nueva cuenta
   vProcesando := 'Actualizando historico de movimientos';
   update arcgmm
        set cuenta = nueva_cta
      where no_cia  = pcia
        and cuenta  = pcta;
   -- cambia las lineas de los Ajustes por PCGA's Utilizados
   vProcesando := 'Actualizando Ajustes por PCGAs';
   Update ARCGPGA
        Set cuenta  = nueva_cta
      Where no_cia  = pcia
        and cuenta  = pcta;
   -- cambia la cuenta en las lineas de los asientos fijos por la nueva cuenta
   vProcesando := 'Actualizando cuenta en lineas de asientos fijos';
   update arcgatl
        set cuenta  = nueva_cta
      where no_cia  = pcia
        and cuenta  = pcta;
   -- cambia la cuenta en el desglose de cuentas por centro
   vProcesando := 'Actualizando cuenta en el desglose de cuentas por centro';
   update arcgd_cc
        set cuenta  = nueva_cta
      where no_cia  = pcia
        and cuenta  = pcta;
EXCEPTION
  WHEN others THEN
    pmsg_error := nvl(vProcesando, sqlerrm(sqlcode));
END;