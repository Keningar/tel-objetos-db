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
     WHERE CUENTA IN ('4810102004', '4810102003')
       AND NO_CIA = '33';

  Ln_IdxCuentaCentro number;

begin
  -- respaldando la informacion de cuentas por centros
  open c_obtener_cuentas_centros;
  fetch c_obtener_cuentas_centros bulk collect
    into lst_respaldoCuentasCentros;
  close c_obtener_cuentas_centros;

  delete from NAF47_TNET.ARCGMS_C a
   where a.cuenta IN ('4810102003', '4810102004')
     and a.no_cia = '33';

  UPDATE NAF47_TNET.ARCGMS A
     SET A.CUENTA            = replace(a.cuenta, '481', '461'),
         a.descri            = 'INST. TRASLADOS PORTADOR',
         a.debitos           = 0,
         a.creditos          = 0,
         a.saldo_per_ant     = 0,
         a.saldo_mes_ant     = 0,
         a.saldo_per_ant_dol = 0,
         a.saldo_mes_ant_dol = 0,
         a.debitos_dol       = 0,
         a.creditos_dol      = 0,
         a.permiso_aprov     = 'N',
         A.PERMISO_TPM_INV   = 'N',
         A.PERMISO_TPM_COM   = 'N',
         A.CREDITOS_PEND     = 0,
         A.DEBITOS_PEND      = 0,
         A.PADRE             = replace(A.PADRE, '481', '461'),
         A.DESCRI_LARGA      = 'INST. TRASLADOS PORTADOR'
   where a.cuenta = '4810102003'
     and a.no_cia = '33';

  UPDATE NAF47_TNET.ARCGMS A
     SET A.CUENTA            = replace(a.cuenta, '481', '461'),
         a.descri            = 'INST. TRASLADOS INTERNET',
         a.debitos           = 0,
         a.creditos          = 0,
         a.saldo_per_ant     = 0,
         a.saldo_mes_ant     = 0,
         a.saldo_per_ant_dol = null,
         a.saldo_mes_ant_dol = 0,
         a.debitos_dol       = 0,
         a.creditos_dol      = 0,
         a.permiso_aprov     = 'N',
         A.PERMISO_CCH       = 'S',
         A.PERMISO_TPM_INV   = 'N',
         A.PERMISO_TPM_COM   = 'N',
         A.CREDITOS_PEND     = 0,
         A.DEBITOS_PEND      = 0,
         A.PADRE             = replace(A.PADRE, '481', '461'),
         A.DESCRI_LARGA      = 'INST. TRASLADOS INTERNET'
   where a.cuenta = '4810102004'
     and a.no_cia = '33';

  Ln_IdxCuentaCentro := lst_respaldoCuentasCentros.FIRST;

  --actualizacion de la cuenta
  loop
    exit when Ln_IdxCuentaCentro is null;
    lst_respaldoCuentasCentros(Ln_IdxCuentaCentro).cuenta := replace(lst_respaldoCuentasCentros(Ln_IdxCuentaCentro)
                                                                     .cuenta,
                                                                     '481',
                                                                     '461');
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