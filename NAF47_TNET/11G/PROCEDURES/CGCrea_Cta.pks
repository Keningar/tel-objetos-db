create or replace PROCEDURE            CGCrea_Cta (
   pCia       in Varchar2,
   pAno       in Varchar2,
   pMes       in Varchar2,
   pRegCta    in Arcgms%rowtype,
   pmsg_error in out Varchar2
)IS
   vCta  Arcgms%rowtype;
BEGIN
  vCta  := pRegCta;
  -- Debido a que este procedimiento solo crea una cuenta, inicializamos los valores
  -- de los campos montos en cero
  pmsg_error := 'Insertando la cuenta en ARCGMS. ';
  --
  INSERT INTO ARCGMS(no_cia,             cuenta,             descri,
                     tipo,               clase,              ind_mov,
                     ind_presup,         presup_cambio,      debitos,
                     creditos,           saldo_per_ant,      saldo_mes_ant,
                     descri_1,           moneda,             activa,
                     f_inactiva,         saldo_per_ant_dol,  saldo_mes_ant_dol,
                     debitos_dol,        creditos_dol,       permiso_con,
                     permiso_che,        permiso_cxp,        permiso_pla,
                     permiso_afijo,      permiso_inv,        permiso_aprov,
                     permiso_fact,       permiso_cxc,        permiso_cch,
                     monetaria,          ajustable,          acepta_cc,
                     creditos_pend,      debitos_pend,       usado_en,
                     compartido,         tcambio_conversion, padre,
                     nivel,              ind_tercero,        cta_ajuste_inflacion,
                     cta_correccion,     cod_ajuste,         descri_larga,
                     naturaleza)
              VALUES(
                     vcta.no_cia,             vcta.cuenta,             vcta.descri,
                     vcta.tipo,               vcta.clase,              vcta.ind_mov,
                     vcta.ind_presup,         vcta.presup_cambio,      0,
                     0            ,           0,                       0,
                     vcta.descri_1,           vcta.moneda,             vcta.activa,
                     vCta.F_inactiva,         0,                       0,
                     0,                       0,                       vCta.permiso_con,
                     vcta.permiso_che,        vcta.permiso_cxp,        vcta.permiso_pla,
                     vcta.permiso_afijo,      vcta.permiso_inv,        vcta.permiso_aprov,
                     vcta.permiso_fact,       vcta.permiso_cxc,        vcta.permiso_cch,
                     vcta.monetaria,          vcta.ajustable,          vcta.acepta_cc,
                     0,                       0,                       vcta.usado_en,
                     vcta.compartido,         vcta.tcambio_conversion, vcta.padre,
                     vcta.nivel,              vcta.ind_tercero,        vcta.cta_ajuste_inflacion,
                     vcta.cta_correccion,     vcta.cod_ajuste,         vcta.descri_larga,
                     vCta.naturaleza);
  --
  pmsg_error := 'Insertando la cuenta en ARCGMS_C';
  INSERT INTO ARCGMS_C(no_cia,            cuenta,        cc_1,
                       cc_2,              cc_3,          tipo,
                       clase,             monetaria,     ajustable,
                       moneda,            saldo_per_ant, saldo_mes_ant,
                       debitos,           creditos,      saldo_per_ant_dol,
                       saldo_mes_ant_dol, debitos_dol,   creditos_dol,
                       nivel)
                VALUES(
                       vcta.no_cia,      vcta.cuenta,        '000',
                       '000',            '000',              vcta.tipo,
                       vcta.clase,       vcta.monetaria,     vcta.ajustable,
                       vcta.moneda,      0,                  0,
                       0,                0,                  0,
                       0,                0,                  0,
                       vcta.nivel);
  --
  pmsg_error := 'Insertando la cuenta en ARCGHC';
  INSERT INTO ARCGHC(no_cia,       ano,        mes,
                     periodo,      cuenta,     movimiento,
					 mov_db,       mov_cr,     saldo,
					 mov_db_dol,   mov_cr_dol, saldo_dol,
					 ajuste_pcgas, saldo_conv, tasa_conv)
              VALUES(
                     pcia,            pano,          pmes,
                     (pano*100)+pmes, vcta.cuenta,   0,
					 0,               0,             0,
					 0,               0,             0,
					 null,            0,             null);
  --
  pmsg_error := 'Insertando la cuenta en ARCGHC_C';
  INSERT INTO ARCGHC_c(no_cia,       ano,         mes,
                       periodo,      cuenta,      cc_1,
                       cc_2,         cc_3,        presu_ini,
                       presu,        pres_ac,     movimiento,
                       mov_db,       mov_cr,      saldo,
                       mov_db_dol,   mov_cr_dol,  saldo_dol,
                       saldo_conv)
                VALUES(
                     pCia,            pAno,          pMes,
                     (pAno*100)+pMes, vCta.CUENTA,   '000',
                     '000',         '000',         null,
                     null,          null,          0,
                     0,             0,             0,
                     0,             0,             0,
                     0);
  pmsg_error := NULL;
EXCEPTION
  WHEN others THEN
     pmsg_error := 'CGCrea_Cta: '||nvl(pmsg_error,sqlerrm);
END;