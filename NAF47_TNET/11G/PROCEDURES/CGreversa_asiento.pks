create or replace PROCEDURE            CGreversa_asiento(
  pNumCia       in varchar2,
  pNum_Asiento  in varchar2,
  pmsg_error    in out varchar2
) IS
   --
   -- Programa de actualizacion de asientos, del mes y ano en proceso
   --
   error_proceso  EXCEPTION;
   --
   vExiste              boolean;
   cont_lin             number(10)            := 0;
   vmonto_nomi          arcgal.monto%type     := 0;
   vmonto_dol           arcgal.monto_dol%type := 0;
   ind_utd              number                := 0;
   UltimaLinea          arcgal.no_linea%type;
   cuentaConPresupuesto BOOLEAN;
   vDebxPres            number                := 0;
   vCrexPres            number                := 0;
   Afecta_dist_cc       boolean               := FALSE;
   Rev_AD_dist_cc       boolean               := FALSE;
   Afecta_dif_camb      boolean               := FALSE;
   --
   cursor c_asiento is
      select no_asiento, fecha,      cod_diario, origen, ano,
             mes,        impreso,    descri1,    estado, autorizado,
             t_debitos,  t_creditos, rowid
        from arcgae
       where no_cia     = pNumCia
         and no_asiento = pNum_asiento;
   --
   cursor c_lineas_asiento (mov VARCHAR2) is
      select AL.cuenta,         AL.cc_1,       AL.cc_2,
	         AL.cc_3,           no_linea,      no_docu,
			 monto,             monto_dol,     AL.tipo,
			 AL.descri,         clase,         AL.moneda,
             AL.tipo_cambio,    MS.IND_PRESUP, MS.MONEDA MONEDA_CTA,
             al.codigo_tercero, AL.Linea_Ajuste_Precision
        from  arcgms MS, arcgal AL
       where AL.no_cia     = pNumCia
         and no_asiento    = mov
         and MS.no_cia     = AL.no_cia
         and MS.cuenta     = AL.cuenta;
   --
   ae     c_asiento%rowtype;
BEGIN
  -- --
  -- Lee el encabezado del asientos
  --
  open c_asiento;
  fetch c_asiento into ae;
  vExiste := c_asiento%found;
  close c_asiento;
  if NOT vExiste then
     pmsg_error := 'El asiento numero: '||pnum_asiento||'  NO existe';
     raise error_proceso;
  end if;
  --
  -- Proceso de cada una de las lineas del movimiento
  for al in c_lineas_asiento(AE.no_asiento) loop
     cont_lin := cont_lin + 1;
     if al.moneda = 'D' then
        vmonto_dol  := nvl(al.monto_dol,0);
        vmonto_nomi := nvl(al.monto,0);
     else
        vmonto_nomi := nvl(al.monto,0);
        if nvl(al.tipo_cambio,0) = 0 then
           vmonto_dol := 0;
        else
           vmonto_dol := nvl(al.monto_dol,0);
        end if;
     end if;
     --
     -- para reversar el asiento, se mayoriza con los montos * -1
     vmonto_dol  := nvl(vmonto_dol,0)*-1;
     vmonto_nomi := nvl(vmonto_nomi,0)*-1;
     --
     CGmayoriza_cta(pNumCia,     AE.Ano,     AE.Mes, al.cuenta,
                    vmonto_nomi, vmonto_dol, al.tipo, pmsg_error);
     if pmsg_error is not null then
        raise error_proceso;
     end if;
     -- --
     -- actualiza terceros
     --
     IF nvl(AL.codigo_tercero, '0') != '0' THEN
        CGAplicar_Terceros(pNumCia,     al.cuenta,  al.codigo_tercero,
                           vMonto_Nomi, vMonto_Dol, ae.ano,
                           ae.mes,      Al.tipo,    pmsg_error );
        if pmsg_error is not null then
           raise error_proceso;
         end if;
     END IF;
     --
     --
     IF al.Linea_Ajuste_Precision = 'S' then
        -- si es una linea de ajuste por precision
        IF AL.tipo='D' THEN
           vDebxPres := NVL(vmonto_nomi,0);
           vCrexPres :=0;
        ELSE
           vDebxPres := 0;
           vCrexPres := NVL(vmonto_dol,0);
        END IF;
     ELSE
        -- --
        -- actualiza (agregacion de ) Centros de Costos,
        CGprocesa_cc (pNumCia,     AE.Ano,     AE.Mes,
                      Ae.Origen,   al.cuenta,  al.cc_1 ||al.cc_2 ||al.cc_3,
                      vmonto_nomi, vmonto_dol, al.tipo,
                      pmsg_error);
        if pmsg_error is not null then
           raise error_proceso;
        end if;
        --
        -- verifica si la actualizacion afecta la dist. de costos por Cent.
        --   solo las lineas de AD que corresponden al centro = CIA
        IF afecta_dist_cc = FALSE  AND
           al.cc_1='000' AND al.cc_2='000' AND al.cc_3='000' THEN
           afecta_dist_cc := CGverif_si_afec_distCC ( pNumCia,al.cuenta);
        END IF;
     END IF;
     --
     -- --
     -- Verifica si proceso una cuenta de resultados
     --
     IF (AL.CLASE = 'I' OR AL.CLASE = 'G') AND IND_UTD=0 THEN
        ind_utd := 1;
     END IF;
	 --
     IF nvl(AL.moneda_cta,'N') = 'D' AND nvl(AE.Origen, 'AU') != 'DC' THEN
        Afecta_dif_camb := TRUE;
     END IF;
	 --
     UltimaLinea := al.no_linea;
	 --
  end loop;   -- de las lineas
  -- --
  -- verifica si el asiento es de Distrib.por centros de costo
  --
  IF ae.origen  = 'CE' THEN
     Rev_AD_dist_cc := TRUE;
  END IF;
  -- --
  -- Elimina las lineas del asiento que se esta reversando
  -- en la tabla historica de movimientos
  --
  /* Se pone en comentarios por requerimiento de Mexico
     pues indican que los asientos anulados en la consulta Fcg40_22:consulta de asientos
     muestra el asiento sin detalle

  DELETE FROM arcgMM
     where no_cia     = pNumCia
       and no_asiento = pNum_Asiento;

      */

  -- --
  -- Elimina las lineas de ajuste por perdidas de presicion
  --
  DELETE FROM arcgal
    where no_cia                 = pNumCia
      and no_asiento             = pNum_Asiento
      and Linea_Ajuste_Precision = 'S';
  --
  -- Reversa el estado del movimiento y el ajuste por pres en el historico
  UPDATE ARCGAEH
        SET ANULADO    = 'A',
            T_debitos  =  T_debitos  - nvl(vDebxPres, 0),
            T_creditos =  T_creditos - nvl(vCrexPres, 0)
            where   NO_CIA      = pNumCIA
              AND   NO_ASIENTO  = pNum_Asiento;
   -- Reversa el estado del movimiento y el ajuste por pres.
   UPDATE ARCGAE
        SET anulado    = 'A',
            autorizado = 'N',
            T_debitos  =  T_debitos  - nvl(vDebxPres, 0),
            T_creditos =  T_creditos - nvl(vCrexPres, 0)
        WHERE  ROWID = AE.ROWID;
  --
  --
  -- ============================================================
  -- Se actualizan los indicadores de la compania para efectos de
  --   integridad se actualizan despues de cada AD actualizado
  --
  -- --
  -- Actualiza el indicador de utilidades para la compa?ia en caso
  -- que se haya procesado una cuenta de resultados
  --
   IF IND_UTD = 1 THEN
       CGCalcula_Utilidades (pNumCia, ae.Ano, ae.Mes, pmsg_error);
       if pmsg_error is not null then
          raise error_proceso;
       end if;
    END IF;
    -- se actualiza el de diferencial cambiario
    IF Afecta_dif_camb THEN
        UPDATE ARCGMC
           SET INDICADOR_DIF_CAM = 'N'
           WHERE NO_CIA  = pNumCIA;
    END IF;
    -- se actualiza el de Dist. de Centros de Costo
    IF Rev_AD_dist_CC THEN
         Update ARCGMC
            set indicador_cc_distbs = 'N'
          where no_cia = pNumCia;
    END IF;
    IF afecta_dist_CC THEN
       -- reverso un AD que Afecta una Dist Fija y ya corrio Dist. CC
       Update ARCGMC
          set indicador_cc_distbs = 'M'
        where no_cia              = pNumCia
          AND indicador_cc_distbs = 'S';
    END IF;
EXCEPTION
  WHEN error_proceso THEN
     pmsg_error := nvl(pmsg_error, 'CGreversa_asiento');
  WHEN others THEN
     pmsg_error := nvl(sqlerrm, 'CGreversa_asiento');
END;