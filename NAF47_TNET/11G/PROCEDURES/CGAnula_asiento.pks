create or replace PROCEDURE            CGAnula_asiento(
  pNumCia      VARCHAR2,
  pNum_Asiento VARCHAR2,
  pmsg_error   IN OUT varchar2
) IS
  -- --
  -- Programa de anulacion  de asientos, del mes y ano en proceso
  --
  error_proceso  EXCEPTION;
  --
  vfound   boolean;
  --
  cursor c_asiento is
     select estado, rowid
       from arcgae
       where no_cia     = pNumCia
         and no_asiento = pNum_asiento;
  --
  vreg_ad     c_asiento%rowtype;
BEGIN
   -- --
   -- Procesa cada uno de los movimientos
   --
   open c_Asiento;
   fetch c_asiento into vreg_ad;
   vfound := c_asiento%found;
   close c_asiento;
   --
   if vfound then
      IF vreg_ad.Estado = 'P' THEN
         -- Reversa el estado del movimiento y el ajuste por pres.
         UPDATE ARCGAE
            SET ANULADO    = 'A',
                AUTORIZADO = 'S',
                ESTADO     = 'A',
                USUARIO_ANULA = UPPER(USER),
                FECHA_ANULA   = TRUNC(SYSDATE)
             WHERE ROWID = vreg_ad.rowid;
         --
         INSERT INTO ARCGAEH (no_cia,           no_asiento,     ano,
                              mes,              impreso,        fecha,
                              descri1,          estado,         autorizado,
                              origen,           t_debitos,      t_creditos,
                              cod_diario,       t_camb_c_v,     tipo_cambio,
                              tipo_comprobante, no_comprobante, anulado)
                     SELECT no_cia,           no_asiento,     ano,
                            mes,              impreso,        fecha,
                            descri1,          estado,         autorizado,
                            origen,           t_debitos,      t_creditos,
                            cod_diario,       t_camb_c_v,     tipo_cambio,
                            tipo_comprobante, no_comprobante, anulado
                      FROM arcgae
                      WHERE rowid = vreg_ad.rowid;
      ELSE
         -- Desmayoriza el asiento y lo deja en estado anulado
         CGreversa_asiento(pNumCia, pNum_Asiento, pmsg_error);
         if pmsg_error is not null then
            raise error_proceso;
         end if;
      END IF;
   end if;  -- vfound
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGanula_asiento');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGanula_asiento');
END;