create or replace PROCEDURE            CGMayoriza_Asiento(pNumCia      IN ARCGAE.no_cia%TYPE,
                                               pNum_Asiento IN ARCGAE.no_Asiento%TYPE,
                                               pCta_Nominal IN ARCGMS.cuenta%TYPE,
                                               pCta_Dolares IN ARCGMS.cuenta%TYPE,
                                               pAc_db       IN OUT Arcgae.t_debitos%TYPE,
                                               pAc_DbDol    IN OUT Arcgae.t_debitos%TYPE,
                                               pAc_Cr       IN OUT Arcgae.t_creditos%TYPE,
                                               pAc_CrDol    IN OUT Arcgae.t_creditos%TYPE,
                                               pCont_Lin    IN OUT NUMBER,
                                               pmsg_error   IN OUT VARCHAR2) IS
/**
* Documentacion para procedure CGMayoriza_Asiento 
* Procedimiento genera mayorización de asiento contable.
* @author yoveri <yoveri@yoveri.com>
* @version 1.0 01/01/2007
*
* @author llindao <llindao@telconet.ec>
* @version 1.1 31/08/2020 -  Se modifica para considerar nuevo campo que asocia la distribución de costo con el asiento contable.
*
* @param pNumCia      IN ARCGAE.no_cia%TYPE         Recibe Identificación de compañía
* @param pNum_Asiento IN ARCGAE.no_Asiento%TYPE     Recibe Identificación de asiento contable
* @param pCta_Nominal IN ARCGMS.cuenta%TYPE         Recibe código de cuenta contable nominal
* @param pCta_Dolares IN ARCGMS.cuenta%TYPE         Recibe código de cuenta contable dolares
* @param pAc_db       IN OUT Arcgae.t_debitos%TYPE  Retorna monto total Débito
* @param pAc_DbDol    IN OUT Arcgae.t_debitos%TYPE  Retorna monto total Débito Dolares
* @param pAc_Cr       IN OUT Arcgae.t_creditos%TYPE Retorna monto total Crédito
* @param pAc_CrDol    IN OUT Arcgae.t_creditos%TYPE Retorna monto total Crédito Dolares
* @param pCont_Lin    IN OUT NUMBER                 Retorna Contador linea
* @param pmsg_error   IN OUT VARCHAR2               Retorna mensaje de error 
*/
  --
  --
  error_proceso EXCEPTION;
  --
  cNewLine VARCHAR2(2) := CHR(13);
  --
  vExiste          BOOLEAN;
  vMonto_Total_Nom Arcgal.monto%TYPE;
  vMonto_Total_Dol Arcgal.monto_dol%TYPE;
  --
  vTot_Cred_Enc Arcgae.T_Creditos%TYPE;
  vTot_Deb_Enc  Arcgae.T_Debitos%TYPE;
  vmonto_nomi   ARCGMS.DEBITOS%TYPE := 0;
  vmonto_dol    ARCGMS.DEBITOS%TYPE := 0;
  --
  PerPresicionNom ARCGMS.DEBITOS%TYPE;
  PerPresicionDol ARCGMS.DEBITOS%TYPE;
  --
  ind_utd NUMBER := 0;
  ind_dif NUMBER := 0;
  --
  UltimaLinea          ARCGAL.no_linea%TYPE;
  Mod_Diferencial      BOOLEAN := FALSE;
  cuentaConPresupuesto BOOLEAN;
  Afecta_dist_cc       BOOLEAN := FALSE;
  --
  vAfecto_utilidades BOOLEAN;
  vindicador_util    arcgmc.indicador_utilidad%TYPE;
  --
  CURSOR c_ind_utilidades IS
    SELECT indicador_utilidad
      FROM arcgmc
     WHERE no_cia = pnumCia;
  --
  CURSOR c_Asiento IS
    SELECT no_asiento,
           fecha,
           cod_diario,
           origen,
           ano,
           mes,
           impreso,
           descri1,
           estado,
           autorizado,
           t_debitos,
           t_creditos,
           ROWID,
           t_camb_c_v,
           tipo_cambio,
           tipo_comprobante,
           no_comprobante,
           numero_ctrl,
           a.usuario_creacion,
           a.fecha_ingresa,
           a.usuario_modifica,
           a.fecha_modifica
      FROM arcgae a
     WHERE no_cia = pNumCia
       AND no_asiento = pNum_asiento
       AND estado = 'P'
       AND anulado = 'N'
       AND autorizado = 'S';
  --
  CURSOR c_lineas_Asiento(pno_asiento VARCHAR2) IS
    SELECT AL.cuenta,
           AL.cc_1,
           AL.cc_2,
           AL.cc_3,
           AL.no_linea,
           AL.no_docu,
           AL.monto,
           AL.monto_dol,
           AL.tipo,
           AL.descri,
           MS.clase,
           AL.moneda,
           AL.tipo_cambio,
           MS.IND_PRESUP,
           MS.moneda Moneda_Cta,
           al.codigo_tercero,
           al.usuario_ingresa,
           al.fecha_ingresa,
           al.usuario_modifica,
           al.fecha_modifica,
           al.no_distribucion
      FROM arcgms MS,
           arcgal AL
     WHERE AL.no_cia = pNumCia
       AND no_asiento = pno_asiento
       AND MS.no_cia = AL.no_cia
       AND MS.cuenta = AL.cuenta;
  --
  ae c_asiento%ROWTYPE;
  --
BEGIN
  --
  vAfecto_Utilidades := FALSE;
  vTot_Cred_Enc      := 0;
  vTot_Deb_Enc       := 0;
  --
  -- --
  -- Lee el encabezado del asientos
  --
  OPEN c_asiento;
  FETCH c_asiento
    INTO ae;
  vExiste := c_asiento%FOUND;
  CLOSE c_asiento;
  --
  IF NOT vExiste THEN
    pmsg_error := 'El asiento numero: ' || pnum_asiento || '  NO existe';
    RAISE error_proceso;
  END IF;
  --
  IF NVL(ae.no_comprobante, 0) = '0' THEN
    pmsg_error := 'El asiento numero: ' || pnum_asiento || ', no tiene numero de comprobante';
    RAISE error_proceso;
  END IF;
  --
  --  Inicializo la variable como si no se hubieran utilizado cuentas de
  --  naturaleza dolares (no se afecta el diferencial)
  Mod_Diferencial := FALSE;
  --
  -- Se valida que el asiento cumpla con:
  --   .este cuadrado,
  --   .la fecha del asiento concuerde con el a?o y mes en proceso
  IF NOT CG_CuadraAsiento(pNumCia, ae.no_asiento, ae.origen) THEN
    pmsg_error := ' >> El asiento ' || ae.no_asiento || '  tiene inconsistencias. ' || cNewLine || '    Asiento descuadrado, Favor Verifique !!!';
  ELSIF NOT CGValida_Fecha(ae.fecha, ae.ano, ae.mes) THEN
    pmsg_error := ' >> El asiento ' || ae.no_asiento || '  tiene inconsistencias.' || cNewLine || '    Fecha no coincide con periodo en proceso,  Favor Verifique !!! ';
  ELSIF NOT CGValida_Ctas_Asiento(pNumCia, ae.no_asiento) THEN
    pmsg_error := ' >> El asiento ' || ae.no_asiento || '  tiene inconsistencias. ' || cNewLine || '    Tiene cuentas que no reciben movimientos, Favor Verifique !!!';
  ELSIF ae.origen <> 'AP' THEN
    IF NOT CGValida_Precision(pNumCia, ae.no_asiento) THEN
      pmsg_error := ' >> El asiento ' || ae.no_asiento || '  tiene inconsistencias. ' || cNewLine || '    Error de precision en las lineas, Favor Verifique !!! ';
    END IF;
  END IF;
  --
  IF pmsg_error IS NOT NULL THEN
    RAISE error_proceso;
  END IF;
  --
  PerPresicionNom  := 0;
  PerPresicionDol  := 0;
  vMonto_Total_Dol := 0;
  vMonto_Total_Nom := 0;
  -- --
  -- Proceso de cada una de las lineas del movimiento
  --
  FOR al IN c_lineas_Asiento(AE.no_asiento) LOOP
    --
    pcont_lin := NVL(pcont_lin, 0) + 1;
    IF NVL(al.moneda_Cta, 'N') = 'D' THEN
      --
      -- Si alguna de las cuentas del asiento tienen naturaleza dolares
      -- se afecta el diferencial cambiario
      Mod_Diferencial := TRUE;
    END IF;
    --
    IF al.moneda = 'D' THEN
      -- acumula debitos y creditos en nominal
      -- NOTA: Si es credito al.monto es negativo
      vMonto_Total_Nom := vMonto_Total_Nom + NVL(al.monto, 0);
      --
      vmonto_dol  := NVL(al.monto_dol, 0);
      vmonto_nomi := NVL(al.monto, 0);
    ELSE
      -- acumula debitos y creditos en nominal
      -- NOTA: Si es credito al.monto es negativo
      vMonto_Total_Dol := vMonto_Total_Dol + NVL(al.monto_dol, 0);
      --
      vmonto_nomi := NVL(al.monto, 0);
      vmonto_dol  := NVL(al.monto_dol, 0);
    END IF;
    --
    IF al.tipo = 'D' THEN
      pac_db    := pac_db + vmonto_nomi;
      pac_dbdol := pac_dbdol + vmonto_dol;
    ELSE
      pac_cr    := pac_cr + vmonto_nomi;
      pac_crdol := pac_crdol + vmonto_dol;
    END IF;
    --
    -- --
    -- mayoriza cuentas contables
    CGmayoriza_cta(pNumCia, ae.ano, ae.mes, al.cuenta, vmonto_nomi, vmonto_dol, al.tipo, pmsg_error);
    IF pmsg_error IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
    -- --
    -- actualiza Centros de Costos
    --
    CGprocesa_cc(pNumCia, ae.ano, ae.mes, AE.origen, al.cuenta, al.cc_1 || al.cc_2 || al.cc_3, vmonto_nomi, vmonto_dol, al.tipo, pmsg_error);
    IF pmsg_error IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
    -- --
    -- actualiza terceros
    --
    IF NVL(AL.codigo_tercero, '0') != '0' THEN
      CGAplicar_Terceros(pNumCia, al.cuenta, al.codigo_tercero, vMonto_Nomi, vMonto_Dol, ae.ano, ae.mes, Al.tipo, pmsg_error);
      IF pmsg_error IS NOT NULL THEN
        RAISE error_proceso;
      END IF;
    END IF;
    --
    -- verifica si la actualizacion afecta la dist. de costos por Cent.
    --   solo las lineas de AD que corresponden al centro = CIA
    IF afecta_dist_cc = FALSE AND al.cc_1 = '000' AND al.cc_2 = '000' AND al.cc_3 = '000' THEN
      afecta_dist_cc := CGverif_si_afec_distCC(pNumCia, al.cuenta);
    END IF;
    --
    -- --
    -- Inserta las lineas de los asientos que se estan procesando
    -- en al tabla historica de movimientos
    --
    INSERT INTO arcgmm
      (no_cia,
       cuenta,
       cc_1,
       cc_2,
       cc_3,
       no_asiento,
       no_linea,
       ano,
       mes,
       fecha,
       no_docu,
       tipo,
       descri,
       cod_diario,
       monto,
       moneda,
       tipo_cambio,
       monto_dol,
       tipo_comprobante,
       no_comprobante,
       codigo_tercero,
       linea_ajuste_precision,
       periodo,
       usuario_ingresa,
       fecha_ingresa,
       usuario_modifica,
       fecha_modifica,
       no_distribucion)
    VALUES
      (pNumCia,
       al.cuenta,
       al.cc_1,
       al.cc_2,
       al.cc_3,
       ae.no_asiento,
       al.no_linea,
       ae.ano,
       ae.mes,
       ae.fecha,
       al.no_docu,
       al.tipo,
       al.descri,
       ae.cod_diario,
       al.monto,
       al.moneda,
       al.tipo_cambio,
       al.monto_dol,
       ae.tipo_comprobante,
       ae.no_comprobante,
       al.codigo_tercero,
       'N',
       (ae.ano * 100) + ae.mes,
       al.usuario_ingresa,
       al.fecha_ingresa,
       al.usuario_modifica,
       al.fecha_modifica,
       al.no_distribucion);
    -- --
    -- Verifica si proceso una cuenta de resultados
    --
    IF (AL.CLASE = 'I' OR AL.CLASE = 'G') AND Ind_utd = 0 THEN
      ind_utd            := 1;
      vAfecto_Utilidades := TRUE;
    END IF;
    UltimaLinea := al.no_linea;
  END LOOP; -- de las lineas
  --
  -- --
  -- Crea linea de ajuste por perdidas de precision
  --
  PerPresicionNom := -vMonto_Total_Nom;
  PerPresicionDol := -vMonto_Total_Dol;
  IF vMonto_Total_Dol != 0 OR vMonto_Total_Nom != 0 THEN
    IF PerPresicionNom < 0 THEN
      pac_cr := NVL(pac_cr, 0) + PerPresicionNom;
    ELSIF PerPresicionNom > 0 THEN
      pac_db := NVL(pac_db, 0) + PerPresicionNom;
    END IF;
    IF PerPresicionDol < 0 THEN
      pac_crDol := NVL(pac_crDol, 0) + PerPresicionDol;
    ELSIF PerPresicionDol > 0 THEN
      pac_dbDol := NVL(pac_dbDol, 0) + PerPresicionDol;
    END IF;
    --
    CGprocesa_precision(pNumcia, ae.ano, ae.mes, ae.no_asiento, ultimaLinea + 1, PerPresicionNom, PerPresicionDol, ae.fecha, ae.cod_diario, ind_utd, ae.tipo_comprobante, ae.no_comprobante, pCta_Dolares, pCta_Nominal, pmsg_error);
    IF pmsg_error IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
  END IF;
  --
  -- --
  -- Actualiza el indicador de utilidades para la compa?ia en caso
  -- que se haya procesado una cuenta de resultados
  --
  IF vafecto_utilidades THEN
    UPDATE arcgmc
       SET indicador_utilidad = 'N'
     WHERE no_cia = pNumCia;
  END IF;
  -- --
  -- verifica si el asiento no es de diferencial cambiario
  --
  IF ae.origen != 'DC' AND Mod_Diferencial THEN
    -- El asiento no es de diferencial cambiario y se modificaron cuentas
    -- con naturaleza dolares
    ind_dif := 1;
  END IF;
  -- --
  -- Actualiza el estado de movimiento y ajustes por presicion
  --
  IF PerPresicionNom < 0 AND vMonto_Total_Nom != 0 THEN
    UPDATE ARCGAE
       SET estado            = 'A',
           usuario_actualiza = upper(USER),
           fecha_actualiza   = TRUNC(SYSDATE),
           t_creditos        = t_creditos + PerPresicionNom * -1
     WHERE ROWID = ae.rowid;
    vTot_Cred_Enc := AE.T_CREDITOS + PerPresicionNom * -1;
    vTot_Deb_Enc  := AE.T_Debitos;
  ELSIF PerPresicionNom > 0 AND vMonto_Total_Nom != 0 THEN
    UPDATE ARCGAE
       SET estado            = 'A',
           usuario_actualiza = upper(USER),
           fecha_actualiza   = TRUNC(SYSDATE),
           t_debitos         = t_debitos + PerPresicionNom
     WHERE ROWID = AE.ROWID;
    vTot_Cred_Enc := AE.T_CREDITOS;
    vTot_Deb_Enc  := AE.T_Debitos + PerPresicionNom;
  ELSE
    UPDATE ARCGAE
       SET estado            = 'A',
           usuario_actualiza = upper(USER),
           fecha_actualiza   = TRUNC(SYSDATE)
     WHERE ROWID = AE.ROWID;
    vTot_Cred_Enc := AE.T_CREDITOS;
    vTot_Deb_Enc  := AE.T_Debitos;
  END IF; -- deb. o cred. por precision
  --
  INSERT INTO ARCGAEH
    (no_cia,
     no_asiento,
     ano,
     mes,
     impreso,
     fecha,
     descri1,
     estado,
     autorizado,
     origen,
     t_debitos,
     t_creditos,
     cod_diario,
     t_camb_c_v,
     tipo_cambio,
     tipo_comprobante,
     no_comprobante,
     numero_ctrl,
     usuario_ingresa,
     fecha_ingresa,
     usuario_modifica,
     fecha_modifica,
     usuario_mayoriza,
     fecha_mayoriza)
  VALUES
    (pNumCia,
     ae.no_asiento,
     ae.ano,
     ae.mes,
     ae.impreso,
     ae.fecha,
     ae.descri1,
     'A',
     'S',
     ae.origen,
     vTot_Deb_Enc,
     vTot_Cred_Enc,
     ae.cod_diario,
     ae.t_camb_c_v,
     ae.tipo_cambio,
     ae.tipo_comprobante,
     ae.no_comprobante,
     ae.numero_ctrl,
     ae.usuario_creacion,
     ae.fecha_ingresa,
     ae.usuario_modifica,
     ae.fecha_modifica,
     USER,
     SYSDATE);
  --
  IF ind_dif = 1 THEN
    UPDATE ARCGMC
       SET indicador_dif_cam = 'N'
     WHERE no_cia = pNumCIA;
    ind_utd := 2;
    ind_dif := 0;
  END IF;
  --
  IF afecta_dist_CC THEN
    -- Si ya se corrio, lo actualiza como Modificado,
    -- ello implicara en el Cierre Mensual, que tiene que reversarlo
    -- y volverlo a crear
    UPDATE ARCGMC
       SET indicador_cc_distbs = 'M'
     WHERE no_cia = pNumCia
       AND indicador_cc_distbs = 'S';
  END IF;
  --
  --
  vindicador_util := 'N';
  OPEN c_ind_utilidades;
  FETCH c_ind_utilidades
    INTO vindicador_util;
  CLOSE c_ind_utilidades;
  --
  IF vAfecto_Utilidades OR vindicador_util = 'N' THEN
    CGCalcula_Utilidades(pNumCia, ae.Ano, ae.Mes, pmsg_error);
    IF pmsg_error IS NOT NULL THEN
      RAISE error_proceso;
    END IF;
  END IF;
EXCEPTION
  WHEN error_proceso THEN
    pmsg_error := NVL(pmsg_error, 'CGmayoriza_asiento');
  WHEN OTHERS THEN
    pmsg_error := NVL(SQLERRM, 'CGmayoriza_asiento');
END;