create or replace PROCEDURE            CGprocesa_precision (
  pNucia            ARCGAE.no_cia%type,
  pAno              ARCGAE.ano%type,
  pMes              ARCGAE.mes%type,
  no_mov            ARCGAE.no_asiento%type,
  ultimalinea       ARCGAL.no_linea%type,
  PerPresicionNom   ARCGAL.monto%type,
  PerPresicionDol   ARCGAL.monto_dol%type,
  fecha             date,
  cod_diario        ARCGAE.cod_Diario%type,
  ind_utd           in out number,
  ptipo_comprobante ARCGAE.tipo_comprobante%type,
  pno_comprobante   ARCGAE.no_comprobante%type,
  pCta_Dolares      ARCGMS.cuenta%type,
  pCta_Nominal      ARCGMS.cuenta%type,
  pmsg_error        in out varchar2
) IS
  --
  error_proceso  EXCEPTION;
  --
  ultlin      number;
  vcuenta     arcgms.cuenta%type;
  vtipo_mov   arcgal.tipo%type;
BEGIN
   ultlin := ultimalinea;
   IF PerPresicionNom != 0 then
      -- -----------------------------------------------------------------------
      -- Crea linea de ajuste por perdidas de presicion para la moneda nominal
      -- -----------------------------------------------------------------------
      IF PerPresicionNom < 0 then
         vtipo_mov := 'C';
      ELSE
         vtipo_mov := 'D';
      END IF;
      --
      UltLin := UltLin + 1;
      insert into arcgal (no_cia,   ano,         mes,    no_asiento,
                          no_linea, descri,      cuenta, cod_diario,
                          moneda,   tipo_cambio, monto,  tipo,
                          fecha,    cc_1,        cc_2,   cc_3,
                          linea_ajuste_precision)
                    values(
                           pnucia, pano,                   pmes,            no_mov,
                           UltLin, 'Ajuste por Presicion', pcta_nominal,    cod_diario,
                           'P',      0,                    PerPresicionNom, vtipo_mov,
                           fecha,    '000',                '000',           '000',
                          'S');
       --
       insert into arcgmm( no_cia,           cuenta,        CC_1,        CC_2,
                           CC_3,             no_asiento,    no_linea,    ano,
                           mes,              fecha,         monto,       tipo,
                           cod_diario,       moneda,        tipo_cambio, descri,
                           tipo_comprobante, no_comprobante,
                           periodo, linea_ajuste_Precision)
                     values(
                          pnucia,            pcta_nominal,    '000',           '000',
                          '000',             no_mov,          UltLin,        pano,
                          pmes,              fecha,           PerPresicionNom, 'C',
                          cod_diario,        'P',             0,               'Ajuste por Presicion',
                          ptipo_comprobante, pno_comprobante,
                          (pano * 100) + pmes, 'S');
       --
       CGmayoriza_cta(pNucia, pAno, pMes, pcta_nominal,
                   PerPresicionNom, 0,  vtipo_mov, pmsg_error);
       if pmsg_error is not null then
          raise error_proceso;
       end if;
       --
       CGMayoriza_CC(pNucia,  pAno, pMes, pcta_nominal, '000000000',
                     PerPresicionNom, 0,    vtipo_mov, pmsg_error);
       if pmsg_error is not null then
          raise error_proceso;
       end if;
       --
       if ind_utd = 0 then
          ind_utd := 1;
       end if;
   END IF;
   --
   -- ---
   --
   IF PerPresicionDol != 0 then
      --
      IF PerPresicionDol < 0 then
         vtipo_mov := 'C';
      ELSE
         vtipo_mov := 'D';
      END IF;
      --
      UltLin := UltLin + 1;
      -- --
      -- Crea linea de ajuste por perdidas de presicion para la moneda dolares
      --
      INSERT INTO arcgal (no_cia,   ano,         mes,       no_asiento,
                          no_linea, descri,      cuenta,    cod_diario,
                          moneda,   tipo_cambio, monto_dol, tipo,
                          fecha,    cc_1,        cc_2,      cc_3,
                          linea_ajuste_precision)
                   values(
                          pnucia,    pano,       pmes,            no_mov,
                          UltLin,    'Ajuste por Presicion', pcta_dolares,    cod_diario,
                          'D',       0,                      PerPresicionDol, vTipo_Mov,
                          fecha,     '000',                  '000',           '000',
                          'S');
      --
      INSERT INTO arcgmm(
                no_cia,           cuenta,         CC_1,                  CC_2,
                CC_3,             no_asiento,     no_linea,              ano,
                mes,              fecha,          monto_dol,             tipo,
                descri,           cod_diario,     moneda,                tipo_cambio,
                tipo_comprobante, no_comprobante,
                periodo, linea_ajuste_precision )
          values(
                 pnucia,                 pcta_dolares,    '000',           '000',
                 '000',                  no_mov,          UltLin,          pano,
                 pmes,                   fecha,           PerPresicionDol, vTipo_Mov,
                 'Ajuste por Presicion', cod_diario,      'D',             0,
                 ptipo_comprobante,      pno_comprobante,
                 (pano * 100) + pmes, 'S');
      -- --
      CGmayoriza_cta(pNucia, pAno,            pMes,      pcta_dolares,
                  0,      PerPresicionDol, vTipo_mov, pmsg_error);
       if pmsg_error is not null then
          raise error_proceso;
       end if;
      --
      CGMayoriza_CC(pNucia,      pAno, pMes,            pcta_dolares,
                    '000000000', 0,    PerPresicionDol, vTipo_Mov, pmsg_error);
      if pmsg_error is not null then
         raise error_proceso;
      end if;
      --
      if ind_utd = 0 then
         ind_utd := 1;
      end if;
  END IF;
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGprocesa_precision');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGprocesa_precision');
END;