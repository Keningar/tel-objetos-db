/*
* Actualización de cuentas para ECUANET
* Jimmy Gilces V. <jgilces@telconet.ec>
*/
declare

  bulk_errors EXCEPTION;
  PRAGMA EXCEPTION_INIT(bulk_errors, -24381);

  type respaldo_info_argmsc is table of naf47_tnet.arcgms_c%rowtype;
  lst_respaldoCuentasCentros respaldo_info_argmsc;

  cursor c_obtener_cuentas_centros is
    SELECT A.*
      FROM NAF47_TNET.ARCGMS_C A
     WHERE CUENTA IN ('4610102004', '4610102003')
       AND NO_CIA = '33';

  Ln_IdxCuentaCentro number;

begin
  -- respaldando la informacion de cuentas por centros
  open c_obtener_cuentas_centros;
  fetch c_obtener_cuentas_centros bulk collect
    into lst_respaldoCuentasCentros;
  close c_obtener_cuentas_centros;

  delete from NAF47_TNET.ARCGMS_C a
   where a.cuenta IN ('4610102003', '4610102004')
     and a.no_cia = '33';

  UPDATE NAF47_TNET.ARCGMS A
     SET A.CUENTA            = replace(a.cuenta, '461', '481'),
         a.descri            = 'Inst. Translados Portador',
         a.debitos           = null,
         a.creditos          = null,
         a.saldo_per_ant     = null,
         a.saldo_mes_ant     = null,
         a.saldo_per_ant_dol = null,
         a.saldo_mes_ant_dol = null,
         a.debitos_dol       = null,
         a.creditos_dol      = null,
         a.permiso_aprov     = 'N',
         A.PERMISO_TPM_INV   = 'N',
         A.PERMISO_TPM_COM   = 'N',
         A.CREDITOS_PEND     = NULL,
         A.DEBITOS_PEND      = NULL,
         A.PADRE             = replace(A.PADRE, '461', '481'),
         A.DESCRI_LARGA      = 'Inst. Translados Portador'
   where a.cuenta = '4610102003'
     and a.no_cia = '33';

  UPDATE NAF47_TNET.ARCGMS A
     SET A.CUENTA            = replace(a.cuenta, '461', '481'),
         a.descri            = 'Inst. Traslados Internet',
         a.debitos           = null,
         a.creditos          = null,
         a.saldo_per_ant     = null,
         a.saldo_mes_ant     = null,
         a.saldo_per_ant_dol = null,
         a.saldo_mes_ant_dol = null,
         a.debitos_dol       = null,
         a.creditos_dol      = null,
         a.permiso_aprov     = 'N',
         A.PERMISO_CCH       = 'S',
         A.PERMISO_TPM_INV   = 'N',
         A.PERMISO_TPM_COM   = 'N',
         A.CREDITOS_PEND     = NULL,
         A.DEBITOS_PEND      = NULL,
         A.PADRE             = replace(A.PADRE, '461', '481'),
         A.DESCRI_LARGA      = 'Inst. Traslados Internet'
   where a.cuenta = '4610102004'
     and a.no_cia = '33';

  Ln_IdxCuentaCentro := lst_respaldoCuentasCentros.FIRST;

  --actualizacion de la cuenta
  loop
    exit when Ln_IdxCuentaCentro is null;
    lst_respaldoCuentasCentros(Ln_IdxCuentaCentro).cuenta := replace(lst_respaldoCuentasCentros(Ln_IdxCuentaCentro)
                                                                     .cuenta,
                                                                     '461',
                                                                     '481');
    Ln_IdxCuentaCentro := lst_respaldoCuentasCentros.next(Ln_IdxCuentaCentro);
  end loop;

  --creacion de cuentas por centro
  forall idx in 1 .. lst_respaldoCuentasCentros.count SAVE EXCEPTIONS
    insert into NAF47_TNET.ARCGMS_C
    values lst_respaldoCuentasCentros
      (idx);

  COMMIT;

EXCEPTION
  WHEN bulk_errors THEN
    ROLLBACK;

end;
/