CREATE OR REPLACE PACKAGE            conversion AS
   -- ---
   -- El paquete conversion contiene reune una serie de procedimientos y
   -- funciones necesarias para la ejecucion del proceso de conversion de
   -- estados financieros
   --
   -- * --
   -- * Ajusta_Utilidades
   --   Aplica el ajuste necesario a la cuenta temporal de utilidades
   -- * --
   -- * Ajuste
   --   Calcula el ajuste resultante del proceso de conversion, para ello
   --   sigue los siguientes pasos:
   --       Calcula Utilidades de acuerdo al Saldo Convertido
   --       Registra Utilidades del periodo a la cuenta temporal
   --       Calcula el ajuste resultante del proceso de conversion
   --       Determina cuenta a realizar ajuste
   --       Si se trata de conversion Historica, ajusta cuenta de utilidades
   --       Ajusta la cuenta de perdida/ganancia y mayoriza ajuste.
   -- * --
   -- * Aplica_Ajustes_PCGAS
   --   Para cada una de las cuentas a las que se registro el ajuste por  PCGA's, se
   --   hace el llamado al proceso Mayoriza_Hc, el cual aplica el ajuste a la cuenta
   --   correspondiente y mayoriza el monto.
   --
   -- * --
   -- * Convierte_Utilidades
   --   Registra el saldo convertido para la cuenta temporal de utilidades
   -- * --
   -- * Existe_Ajuste_PCGAS
   --   Verifica la existencia del ajuste, en caso de existir, devuelve TRUE
   --   y en caso contrario devuelve FALSE
   -- * --
   -- * Inicializa
   --   Inicializa los saldos convertidos de las cuentas en cero e
   --   Inicializa los datos para las cuentas con tipo de cambio de
   --   conversion historico
   --   Carga las variables necesarias para el proceso de conversion
   -- * --
   -- * Limpia_Ajustes_PCGAS
   --   Inicializa en cero los montos por ajustes de PCGA's, para todas las cuentas de
   --   ArcgHC en el a?o y mes que se va a convertir
   -- * --
   -- * Mayoriza_HC
   --   Mayoriza el monto, ya sea en el ajuste por PCGA's o en el
   --   Saldo convertido, de acuerdo al parametro pMay que toma los valores
   --      A - cuando debe afectar los ajustes por PCGAS y
   --      S - cuando debe afectar los saldos convertidos
   --   Este proceso se ejecuta sobre arcghc
   -- * --
   -- * Mayoriza_HCC
   --   Mayoriza el monto en el Saldo convertido, de acuerdo al parametro
   --   pMay que toma el valor S - cuando debe afectar los saldos convertidos
   --   Este proceso ejecuta sobre Arcghc_C
   -- * --
   -- * Obtiene_CuentasConversion
   --   Obtiene la moneda funcional de la compa?ia y las cuentas contables
   --   para ajustes por conversion (perdida y ganancia para conversion
   --   corriente y historica)
   -- * --
   -- * Promedio_Ponderado
   --   Calcula el promedio ponderado, de acuerdo a los tipos de cambio
   --   del periodo
   -- * --
   -- * Promedio_Simple
   --   Calcula el promedio simple, de acuerdo a los tipos de cambio
   --   del periodo
   -- * --
   -- * Valida_Ajustes_PCGAs
   --   Valida que el ajuste registrado, se encuentre balanceado, en este caso,
   --   devuelve TRUE y en caso contrario devuelve FALSE
   -- * --
   -- * Valida_AnoMes
   --   Valida que el a?o y mes a convertir sea menor o igual al periodo en proceso
   -- * --
   PROCEDURE inicializa(pCia varchar2, pano         Varchar2,
                        pMes Varchar2, pTipo_Cambio Number);
   --
   PROCEDURE Ajuste (pCia Varchar2, pAno Varchar2,
                     pMes Varchar2);
   --
   PROCEDURE Ajusta_Utilidades (pCia          Varchar2, pAno Varchar2,
                                pMes          Varchar2, pCta Varchar2,
                                pMonto_Ajuste Number);
   --
   PROCEDURE Promedio_Ponderado (pAno            Varchar2, pMes          Varchar2,
                                 pMes_Cierre     Varchar2, pClase        VARCHAR2,
                                 pTC         OUT NUMBER,   pClase_Cambio Varchar2);
   --
   PROCEDURE Promedio_Simple (pAno            Varchar2, pMes          Varchar2,
                              pMes_Cierre     Varchar2, pClase        VARCHAR2,
                              pTC         OUT NUMBER,   pClase_Cambio Varchar2);
   --
   PROCEDURE Convierte_Utilidades (pCia    Varchar2, pAno Varchar2,
                                   pMes    Varchar2, pCta Varchar2,
                                   pAjuste Varchar2);
   --
   PROCEDURE Mayoriza_HC ( pNucia    VARCHAR2, pAno             number,
                           pMes      number,   pcuentaMayorizar Varchar2,
                           pMontoMay number,   pMay             Varchar2);
   --
   PROCEDURE Mayoriza_HCC (pNucia    VARCHAR2, pAno number,
                           pMes      number,   pcuentaMayorizar Varchar2,
                           pMontoMay number,   pMay Varchar2,
                           pcentro   Varchar2);
   --
   PROCEDURE Limpia_Ajustes_PCGAs (pCia Varchar2, pAno Varchar2, pMes Varchar2);
   --
   PROCEDURE Aplica_Ajustes_PCGAS  (pCia Varchar2, pAno Varchar2, pMes Varchar2);
   --
   FUNCTION Valida_Ajustes_PCGAs (pCia Varchar2, pAno Varchar2, pMes Varchar2)RETURN BOOLEAN;
   --
   FUNCTION Valida_AnoMes (pCia Varchar2, pAno Varchar2, pMes Varchar2) RETURN BOOLEAN;
   --
   FUNCTION Existe_Ajuste_PCGAs (pCia Varchar2, pAno Varchar2, pMes Varchar2) RETURN BOOLEAN;
   --
   --
   FUNCTION  ultimo_error RETURN VARCHAR2;
   FUNCTION  ultimo_mensaje RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20029);
   kNum_error      NUMBER := -20029;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
END; -- conversion;
/


CREATE OR REPLACE PACKAGE BODY            conversion AS
   /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   */
   gCta_u_c_cte     arcgms.cuenta%type;
   gCta_p_c_cte     arcgms.cuenta%type;
   gCta_u_c_hist    arcgms.cuenta%type;
   gCta_p_c_hist    arcgms.cuenta%type;
   gCta_util        arcgms.cuenta%type;
   gCta_util_Aj     arcgms.cuenta%type;
   gMon_Funcional   arcgmc.moneda_func%type;
   vencontro        boolean;
   vMensaje_error   varchar2(160);
   vMensaje         varchar2(160);
   --
   PROCEDURE genera_error(msj_error IN VARCHAR2)IS
   BEGIN
      vMensaje_error := msj_error;
      vMensaje       := msj_error;
      RAISE_APPLICATION_ERROR(kNum_error, msj_error);
   END;
   --
   PROCEDURE mensaje(msj IN VARCHAR2) IS
   BEGIN
      vMensaje  := msj;
   END;
   --
   --
  PROCEDURE Obtiene_CuentasConversion (
    pCia varchar2
  ) IS
    --
    CURSOR c_cia_existe IS
      SELECT moneda_Func, cta_u_c_hist, cta_p_c_hist,
             cta_u_c_cte, cta_p_c_cte
        FROM arcgmc
       WHERE no_cia = pcia;
  BEGIN
  	--
    OPEN  c_cia_existe;
    FETCH c_cia_existe INTO gMon_Funcional, gcta_u_c_hist,  gcta_p_c_hist,
                            gcta_u_c_cte,   gcta_p_c_cte;
    vencontro := c_cia_existe%found;
    CLOSE c_cia_existe;

    IF not vencontro THEN
      genera_error('Error al obtener datos para conversion de la compa?ia !!!');
    ELSIF nvl(gMon_Funcional, 'P') = 'P' AND (gCta_u_C_cte IS NULL OR gCta_p_C_cte IS NULL) THEN
      genera_error('Error cuentas para conversion no definidas !!!');
	  ELSIF nvl(gMon_Funcional, 'P') = 'D' AND (gCta_u_C_hist IS NULL OR gCta_p_C_hist IS NULL) THEN
      genera_error('Error cuentas para conversion no definidas !!!');
    END IF;
  END Obtiene_CuentasConversion;
  --
  PROCEDURE Obtiene_CuentasUtilidades (
    pCia   varchar2
  ) IS
    --
    CURSOR c_cta_existe IS
      SELECT cuenta, ajustable
        FROM arcgms
       WHERE no_cia = pcia
         AND clase  = '9'
         AND nivel  = 2;
  BEGIN
    FOR cta IN c_cta_existe LOOP
      IF nvl(cta.ajustable, 'N') = 'S' THEN
        gcta_util_Aj := cta.Cuenta;
      ELSE
        gcta_util    := cta.Cuenta;
      END IF;
    END LOOP;
  END Obtiene_CuentasUtilidades;
  ---
  /*******[ PARTE: PUBLICA ]
  * Declaracion de Procedimientos o funciones PUBLICAS
  *
  */
  --
  FUNCTION ultimo_error RETURN VARCHAR2 IS
  BEGIN
    RETURN(vMensaje_error);
  END ultimo_error;
  --
  FUNCTION ultimo_mensaje RETURN VARCHAR2 IS
  BEGIN
    RETURN(vMensaje);
  END ultimo_mensaje;
  --
  --
  PROCEDURE inicializa(
    pCia         varchar2,
    pAno         varchar2,
    pMes         varchar2,
    pTipo_Cambio number
  ) IS
    -- Inicializa los saldos convertidos de las cuentas en cero e
    -- Inicializa los datos para las cuentas con tipo de cambio de conversion historico
    CURSOR c_historico IS
      SELECT a.cuenta, b.ajuste_pcgas, b.saldo_dol, b.Saldo
        FROM arcgms a, arcghc b
       WHERE a.no_cia                    = pCia
         AND a.no_cia                    = b.No_cia
         AND b.ano                       = pAno
         AND b.mes                       = pMes
         AND a.cuenta                    = b.cuenta
         AND a.ind_mov                   = 'S'
         AND nvl(tCambio_Conversion,'C') = 'H';
    --
    CURSOR c_hist_centro (pCuenta varchar2) IS
      SELECT cc_1||cc_2||cc_3 centro, saldo_dol
        FROM arcghc_c
       WHERE no_cia  = pCia
         AND ano     = pAno
         AND mes     = pMes
         AND cuenta  = pcuenta
         AND cc_1   != '000';
    --
    vMonto_Conv   arcghc.saldo_conv%type;
    vTipo_Cambio  arcghc.tasa_conv%type;
  BEGIN
    Obtiene_CuentasConversion(pCia);
    Obtiene_CuentasUtilidades(pCia);
	  -- --
    -- Se Inicializan los Saldos de HC y HC_C
	  --
    UPDATE arcghc
       SET saldo_conv = 0 ,
           tasa_conv  = 0
     WHERE no_cia = pCia
       AND ano    = pAno
       AND mes    = pMes;
    --
    UPDATE arcghc_C
       SET saldo_conv = 0
     WHERE no_cia = pCia
       AND ano    = pAno
       AND mes    = pMes;
    --
    FOR h IN c_historico LOOP
      --
      -- Se Convierte el Saldo para aquellas cuentas con tipo de
      -- conversion historico
      IF nvl(h.Saldo_Dol,0) != 0 AND nvl(h.Saldo,0) != 0 THEN
        vTipo_Cambio := round(h.Saldo / h.Saldo_Dol,5);
      ELSE
        vTipo_Cambio := pTipo_Cambio;
      END IF;

      IF nvl(h.Saldo,0)= 0 AND nvl(h.Saldo_Dol,0)!= 0 THEN
        vmonto_Conv := moneda.Redondeo(nvl(h.ajuste_PCGAs,0)/ vTipo_Cambio,'D');
      ELSE
        vMonto_Conv := moneda.redondeo(nvl(h.Saldo_DOL,0) +
                                       nvl(h.ajuste_PCGAs,0)/ vTipo_Cambio,'D');
      END IF;
      mayoriza_HC(pCia, pAno, pMes, h.cuenta, vmonto_Conv, 'S');
      mayoriza_HCC(pCia, pAno, pMes, h.cuenta, vmonto_Conv, 'S', '000000000');
      --
      FOR hc in c_hist_centro (h.cuenta) LOOP
        Mayoriza_HCC(pCia, pAno, pMes, h.cuenta, hc.Saldo_Dol, 'S', hc.centro);
      END LOOP;
    END LOOP;
  END inicializa;
  --
  --
  PROCEDURE ajuste (
    pCia   varchar2,
    pAno   varchar2,
    pMes   varchar2
  ) IS
    --  Calcula el ajuste resultante del proceso de conversion, para ello sigue los
    --  siguientes pasos:
    --       Calcula Utilidades de acuerdo al Saldo Convertido
    --       Registra Utilidades del periodo a la cuenta temporal
    --       Calcula el ajuste resultante del proceso de conversion
    --       Determina cuenta a realizar ajuste
    --       Si se trata de conversion Historica, ajusta cuenta de utilidades
    --       Ajusta la cuenta de perdida/ganancia y mayoriza ajuste.
    Mto_Activo    Arcghc.Saldo_Conv%Type := 0;
    Mto_Pasivo    Arcghc.Saldo_Conv%Type := 0;
    Mto_Capital   Arcghc.Saldo_Conv%Type := 0;
    Util_apk      Arcghc.Saldo_Conv%Type := 0;
    Util_del_peri Arcghc.Saldo_Conv%Type := 0;
    Ajuste        Arcghc.Saldo_Conv%Type := 0;
    Cta_Ajuste    Arcghc.cuenta%type;
    -- --
    --
    CURSOR c_apc IS
      SELECT sum(Decode(a.clase, 'A', Nvl(b.Saldo_Conv,0), 0)),
             sum(Decode(a.clase, 'P', Nvl(b.Saldo_Conv,0), 0)),
             sum(Decode(a.clase, 'C', Nvl(b.Saldo_conv,0),
                                 '9', Nvl(b.Saldo_conv,0), 0))
        FROM arcgms a, arcghc b
       WHERE a.no_cia  = pCia
         AND a.no_cia  = b.no_cia
         AND ano       = pAno
         AND mes       = pMes
         AND a.cuenta  = b.cuenta
         AND a.nivel   = 1;
    --
    CURSOR c_calc_util IS
      SELECT sum(decode(a.clase, 'I', nvl(b.saldo_conv,0),
                                 'G', nvl(b.saldo_conv,0))) -
             sum(decode(a.clase, '9', nvl(b.saldo_conv,0), 0))
        FROM arcgms a, arcghc b
       WHERE a.no_cia  = pCia
         AND a.no_cia  = b.no_cia
         AND ano       = pAno
         AND mes       = pMes
         AND a.cuenta  = b.cuenta
         AND a.nivel   = 1;
    --
    vProcesa Varchar2(200);
  BEGIN
    vProcesa := 'Obtiene cuentas de conversion';
    Obtiene_CuentasConversion(pcia);
    vProcesa := 'Obtiene cuentas de utilidades';
    Obtiene_CuentasUtilidades(pcia);
    -- Se hace la conversion de las cuentas de utilidades
    -- ajustadas y sin ajustar
	  vProcesa := 'Convierte Utilidades para cuentas que no son de ajuste';
    Convierte_Utilidades(pCia, pAno, pMes, gCta_Util,    'N');
    --
	  vProcesa := 'Convierte Utilidades para cuentas de ajuste';
    Convierte_Utilidades(pCia, pAno, pMes, gCta_Util_AJ, 'S');
    ----  balanceo Activos, Pasivos y Capital
    vProcesa := 'Obtiene totales Activos, Pasivo y Capital';
    OPEN  c_apc;
    FETCH c_apc INTO Mto_Activo, Mto_Pasivo, Mto_Capital;
    vencontro := c_apc%found;
    CLOSE c_apc;

    IF not vencontro THEN
      genera_error('ERROR '||'Error obteniendo total de ingresos y gastos');
    END IF;
    Util_apk := Mto_Activo + Mto_Pasivo + Mto_Capital;
    Ajuste   := Util_APK;
    IF nvl(gMon_Funcional, 'N') = 'D' THEN
      -- Si es conversion Historica
      Util_del_Peri := Util_apk;  -- se define la Util o Perd como A + P + K
                                  -- y las cuentas de ajuste a resultados
      IF Ajuste < 0 THEN
        cta_Ajuste := gcta_P_c_hist;
      ELSIF Ajuste > 0 THEN
        cta_Ajuste := gcta_U_c_hist;
      END IF;
    ELSE
      -- Si es conversion corriente
      Util_del_peri := Util_apk;
      IF Ajuste < 0 THEN
        cta_Ajuste := gcta_P_c_cte;
      ELSIF Ajuste > 0 THEN
        cta_Ajuste := gcta_U_c_cte;
      END IF;
    END IF;
    IF Nvl(Ajuste,0) != 0 THEN
  	  vProcesa := 'Mayorizando cuenta de ajuste en ARCGHC '||cta_ajuste;
      Mayoriza_HC (pCia, pAno, pMes, cta_Ajuste, -1*Ajuste, 'S');
	    vProcesa := 'Mayorizando cuenta de ajuste en ARCGHC_C '||cta_ajuste;
      Mayoriza_HCC(pCia, pAno, pMes, cta_Ajuste, -1*Ajuste, 'S', '000000000');

      IF nvl(gMon_Funcional, 'N') = 'D' THEN
        OPEN  c_calc_util;
        FETCH c_calc_util INTO util_apk;
        vencontro := c_calc_util%found;
        CLOSE c_calc_util;

        IF not vencontro THEN
          genera_error('ERROR obteniendo total la utilidad calculada');
        END IF;
        vProcesa := 'Mayorizando utilidad calculada '||gcta_util;
        Ajusta_Utilidades(pCia, pAno, pMes, gcta_util, Util_apk);
      END IF;
    END IF;
  EXCEPTION
    WHEN Error THEN
	       genera_error(Ultimo_Error);
    WHEN others THEN
         genera_error('ERROR '||nvl(vProcesa,'Registrando ajuste por conversion'));
  END ajuste;
  --
  --
  PROCEDURE ajusta_utilidades (
    pCia          varchar2,
    pAno          varchar2,
    pMes          varchar2,
    pCta          varchar2,
    pMonto_Ajuste number
  ) IS
    --  Realiza un ajuste a la cuenta temporal de utilidades
  BEGIN
    Mayoriza_HC(pCia, pAno,          pMes,
                pCta, pMonto_Ajuste, 'S');
    Mayoriza_HCC(pCia,       pAno,          pMes,
                 pCta,       pMonto_Ajuste, 'S',
                 '000000000');
  END Ajusta_Utilidades;
  --
  --
  PROCEDURE mayoriza_HC (
    pNucia           varchar2,
    pAno             number,
    pMes             number,
    pcuentaMayorizar varchar2,
    pMontoMay        number,
    pMay             varchar2
  ) IS
    --  Mayoriza el monto 'pMontoMay', ya sea en el ajuste por PCGA's o en el
    --  Saldo convertido, de acuerdo al parametro 'pMay' que toma los valores
    --    A - cuando debe afectar los ajustes por PCGAS y
    --    S - cuando debe afectar los saldos convertidos
    --  Este proceso se ejecuta sobre arcghc
    cuentaEnProceso arcgms.cuenta%type;
    vdeb_dol  arcghc.saldo_conv%type;
    vcred_dol arcghc.saldo_conv%type;
  BEGIN
    CuentaEnProceso := pcuentaMayorizar;
    LOOP
      --
      -- El algoritmo de mayorizacion recorre de cuenta hija a cuenta madre,
      IF pMay = 'A' THEN
        --        Se mayorizara pMontoMay en Ajustes por PCGA's
        UPDATE arcghc
           SET ajuste_PCGAS = nvl(ajuste_pcgas,0) + nvl(pMontoMay,0)
         WHERE cuenta  = CuentaEnProceso
           AND no_cia  = pNucia
           AND mes     = to_number(pMes)
           AND ano     = to_number(pAno);
        --
        IF sql%rowcount = 0 THEN
          genera_Error(' No puede aplicar ajuste por PCGAs a la cuenta '||
                       CuentaEnProceso ||Chr(13)||
                       'La cuenta no estaba activa al cerrar el periodo !!! ');
        END IF;
      ELSIF pMay = 'S' THEN
        --        Se mayorizara pMontoMay en el saldo convertido
        UPDATE arcghc
           SET saldo_conv    = nvl(saldo_conv,0) + nvl(pMontoMay,0)
         WHERE cuenta  = CuentaEnProceso
           AND no_cia  = pNucia
           AND mes     = to_number(pMes)
           AND ano     = to_number(pAno);
        --
        IF SQL%rowcount = 0 THEN
          genera_Error('No puede aplicar ajuste de conversion a la cuenta '||
                       CuentaEnProceso||Chr(13)||
                      'La cuenta no estaba activa al cerrar el periodo !!! ');
        END IF;
      END IF;
      IF Cuenta_Contable.nivel(pnucia, CuentaEnProceso) = 1 THEN
        EXIT;
      ELSE
        CuentaEnProceso := Cuenta_Contable.Padre(pnucia, CuentaEnProceso);
      END IF;
    END LOOP;
  END mayoriza_HC;
  --
  --
  PROCEDURE mayoriza_HCC (
    pNucia           varchar2,
    pAno             number,
    pMes             number,
    pcuentaMayorizar varchar2,
    pMontoMay        number,
    pMay             varchar2,
    pcentro          varchar2
  ) IS
    --  Mayoriza el monto 'pMontoMay', en el Saldo convertido, de acuerdo al parametro
    --  'pMay' que toma el valor S - cuando debe afectar los saldos convertidos
    --  Este proceso ejecuta sobre Arcghc_C
    cuentaEnProceso arcgms.cuenta%type;
    vc1       arcgceco.cc_1%type;
    vc2       arcgceco.cc_2%type;
    vc3       arcgceco.cc_3%type;
    vdeb_dol  arcghc.saldo_conv%type;
    vcred_dol arcghc.saldo_conv%type;
  BEGIN
    cuentaEnProceso := pcuentaMayorizar;
    vc1 := SubStr(pcentro,1,3);
    vc2 := SubStr(pcentro,4,3);
    vc3 := SubStr(pcentro,7,3);
    LOOP
      --
      -- El algoritmo de mayorizacion recorre de cuenta hija a cuenta madre,
      -- la ultima heredera es cuenta actual.
      --
      IF pMay = 'S' THEN
        --        Se mayorizara pMontoMay en el saldo convertido
        UPDATE arcghc_c
           SET saldo_conv  = nvl(saldo_conv,0) + nvl(pMontoMay,0)
         WHERE no_cia  = pNucia
           AND ano     = to_number(pAno)
           AND mes     = to_number(pMes)
           AND cuenta  = CuentaEnProceso
           AND cc_1    = vc1
           AND cc_2    = vc2
           AND cc_3    = vc3;
        --
        IF sql%rowcount = 0 THEN
          INSERT INTO arcghc_c ( no_cia, ano, mes, periodo,
                                 cc_1, cc_2, cc_3, cuenta, saldo_conv)
                        VALUES ( pNucia, pAno, pMes, (pAno * 100) + pMes,
                                 vc1, vc2, vc3, CuentaEnProceso, pMontoMay);
        END IF;
      END IF;
      IF Cuenta_Contable.nivel(pNuCia, CuentaEnProceso) = 1 THEN
        EXIT;
      ELSE
        CuentaEnProceso := Cuenta_Contable.padre(pNuCia, CuentaEnProceso);
      END IF;
    END LOOP;
  EXCEPTION
    WHEN cuenta_contable.error THEN
         genera_error(Cuenta_Contable.Ultimo_Error);
    WHEN others THEN
         genera_error('ERROR '||SQLERRM);
  END mayoriza_HCC;
  --
  --
  PROCEDURE promedio_ponderado (
    pAno          varchar2,
    pMes          varchar2,
    pMes_Cierre   varchar2,
    pClase        varchar2,
    pTC       OUT number,
    pClase_Cambio varchar2
  ) IS
    --
    -- Calcula el promedio ponderado, de acuerdo a los tipos de cambio del mes
    --
    vFecha        date;
    vFecha_Mes    date;
    vFecha_Final  date;
    vFecha_Cambio date;
    vTipo         number;
    vDias         number;
    vAcum_Tipo    number;
  BEGIN
    IF pMes <= pMes_Cierre THEN
      vfecha        := to_date('01'||pMes_Cierre||to_char(pAno-1),'DDMMRRRR');
    ELSE
      vfecha        := to_date('01'||pMes_Cierre||pAno,'DDMMRRRR');
    END IF;
    --
    -- Calculo el primer dia del mes inmediatamente siguiente al cierre fiscal
    vfecha        := last_day(vFecha);
    vFecha        := vfecha + 1;
    -- Calculo el ultimo dia del mes a convertir
    vFecha_Mes    := to_date('01'||pmes||pano,'DDMMRRRR');
    vFecha_Final  := last_day(vfecha_Mes);
    vDias         := (vFecha_Final - vFecha) + 1;
    vAcum_Tipo    := 0;
    WHILE vFecha < vFecha_Final LOOP
      vTipo      := round(tipo_cambio(pClase_Cambio,vfecha, vfecha_cambio,pClase),5);
      vAcum_Tipo := vAcum_Tipo + vTipo;
      vfecha     := vFecha + 1;
    END LOOP;
    vTipo        := round(tipo_cambio(pClase_Cambio,vfecha, vfecha_cambio,pClase),5);
    vAcum_Tipo   := vAcum_Tipo + vTipo;
    pTC          := round((vAcum_Tipo/vDias),5);
  END promedio_ponderado;
  --
  --
  PROCEDURE promedio_simple (
    pAno          varchar2,
    pMes          varchar2,
    pMes_Cierre   varchar2,
    pClase        vARCHAR2,
    pTC       OUT number,
    pClase_Cambio varchar2
  ) IS
    --
    --  Calcula el promedio simple de acuerdo a los tipos de cambio del mes.
    --  Toma el tipo de cambio a inicio de mes, el tipo de cambio a final de
    --  mes, los suma y los divide entre dos.
    --
    vFecha        date;
    vFecha_Mes    date;
    vFecha_Final  date;
    vFecha_Cambio date;
    vTipo_Inicial number;
    vTipo_Final   number;
  BEGIN
    IF pMes <= pMes_Cierre THEN
      vfecha      := to_date('01'||pMes_Cierre||to_char(pAno-1),'DDMMRRRR');
    ELSE
      vfecha      := to_date('01'||pMes_Cierre||pAno,'DDMMRRRR');
    END IF;
    --
    -- Calculo el primer dia del mes inmediatamente siguiente al cierre fiscal
    vfecha        := last_day(vFecha);
    vFecha        := vfecha + 1;
    -- Calculo el ultimo dia del mes a convertir
    vFecha_Mes    := to_date('01'||pMes||pAno,'DDMMRRRR');
    vFecha_Final  := last_day(vfecha_Mes);
    vTipo_Inicial := round(tipo_cambio(pClase_Cambio,vfecha, vfecha_cambio,pClase),5);
    vTipo_Final   := round(tipo_cambio(pClase_Cambio,vfecha_final, vfecha_cambio,pClase),5);
    pTC           := round((vtipo_Inicial + vTipo_Final)/2,5);
  END promedio_simple;
  --
  --
  PROCEDURE convierte_utilidades (
    pCia    varchar2,
    pAno    varchar2,
    pMes    varchar2,
    pCta    varchar2,
    pAjuste varchar2
  ) IS
    --
    CURSOR c_IyG IS
      SELECT sum(decode(a.clase, 'I', nvl(b.saldo_conv,0),0)),
             sum(decode(a.clase, 'G', nvl(b.saldo_conv,0),0))
        FROM arcgms a, arcghc b
       WHERE a.no_cia    = pCia
         AND a.no_cia    = b.no_cia
         AND ano         = pAno
         AND mes         = pMes
         AND a.cuenta    = b.cuenta
         AND a.ind_mov   = 'S'
         AND not exists (SELECT cta_correccion
                           FROM arcgms c
                          WHERE a.no_cia = c.no_cia
                            AND a.cuenta = c.cta_correccion );
    -- --
    --
    CURSOR c_IyG_Aj IS
      SELECT sum(decode(a.clase, 'I', nvl(b.Saldo_Conv,0),0)),
             sum(decode(a.clase, 'G', nvl(b.Saldo_conv,0),0))
        FROM arcgms a, arcghc b
       WHERE a.no_cia    = pCia
         AND a.no_cia    = b.no_cia
         AND ano         = pAno
         AND mes         = pMes
         AND a.cuenta    = b.cuenta
         AND a.ind_mov   = 'S'
         AND exists (SELECT cta_correccion
                       FROM arcgms c
                      WHERE a.no_cia = c.no_cia
                        AND a.cuenta = c.cta_correccion );
    -- --
    --
    Mto_Ingresos  Arcghc.Saldo_Conv%Type := 0;
    Mto_Gastos    Arcghc.Saldo_Conv%Type := 0;
    Util_ig       Arcghc.Saldo_Conv%Type := 0;
    vProcesa      Varchar2(200);
    -- --
    -- Registra el saldo convertido para la cuenta temporal de utilidades
	  --
  BEGIN
    IF pAjuste = 'N' THEN
      OPEN  c_iyg;
      FETCH c_iyg INTO Mto_Ingresos, Mto_Gastos;
      vencontro := c_iyg%found;
      CLOSE c_iyg;

      IF not vencontro THEN
        genera_error('ERROR obteniendo total de ingresos y gastos');
      END IF;
    ELSE
      OPEN  c_IyG_Aj;
      FETCH c_IyG_Aj INTO Mto_Ingresos, Mto_Gastos;
      vencontro := c_IyG_Aj%found;
      CLOSE c_IyG_Aj;

      IF not vencontro THEN
  	    Mto_Ingresos := 0;
	  	  Mto_Gastos   := 0;
      END IF;
    END IF;
    Util_ig  := nvl(Mto_Ingresos,0) + Nvl(Mto_Gastos,0);
    Mayoriza_HC(pCia, pAno,    pMes,
                pCta, Util_IG, 'S');
    Mayoriza_HCC(pCia,       pAno,    pMes,
                 pCta,       Util_IG, 'S',
                 '000000000');
  EXCEPTION
    WHEN others THEN
	       genera_error('Convierte_Utilidades ERROR : '||SQLERRM);
  END convierte_utilidades;
  --
  --
  PROCEDURE limpia_ajustes_PCGAs (
    pCia   varchar2,
    pAno   varchar2,
    pMes   varchar2
  ) IS
    --
    --  Inicializa en cero los montos por ajustes de PCGA's, para todas las cuentas de
    --  ArcgHC en el a?o y mes que se va a convertir
  BEGIN
    UPDATE arcghc
       SET ajuste_PCGAS = 0
     WHERE no_cia  = pcia
       AND ano     = pAno
       AND mes     = pMes;
  END limpia_ajustes_PCGAs;
  --
  --
  PROCEDURE aplica_ajustes_PCGAs  (
    pCia   varchar2,
    pAno   varchar2,
    pMes   varchar2
  ) IS
    --
    --  Para cada una de las cuentas a las que se registro el ajuste por  PCGA's, se
    --  hace el llamado al proceso Mayoriza_Hc, el cual aplica el ajuste a la cuenta
    --  correspondiente y mayoriza el monto.
    CURSOR c_ajuste IS
      SELECT cuenta, decode(nvl(mto_debito,0), 0, -1*nvl(mto_credito,0), nvl(mto_debito,0)) Ajuste
        FROM Arcgpga
       WHERE no_cia  = pCia
         AND ano     = pAno
         AND mes     = pMes ;
  BEGIN
    FOR aj IN c_ajuste LOOP
      Mayoriza_HC(pcia,      pano,      pmes,
                  aj.cuenta, aj.ajuste, 'A' )  ;
    END LOOP;
  END aplica_ajustes_PCGAs;
  --
  --
  FUNCTION valida_ajustes_PCGAs (
    pCia   varchar2,
    pAno   varchar2,
    pMes   varchar2
  ) RETURN boolean IS
    --
    --   Valida que el ajuste registrado, se encuentre balanceado, en este caso, devuelve TRUE
    --   y en caso contrario devuelve FALSE
    CURSOR c_balance IS
      SELECT sum(nvl(mto_credito,0)), sum(nvl(mto_debito,0))
        FROM arcgpga
       WHERE no_cia = pCia
         AND ano    = pAno
         AND mes    = pMes;
    --
    vTotal_db  arcgms.saldo_mes_ant%type := 0;
    vTotal_cr  arcgms.saldo_mes_ant%type := 0;
  BEGIN
    OPEN  c_balance;
    FETCH c_balance INTO vTotal_cr, vTotal_db;
    CLOSE c_balance;
    return ( nvl(vTotal_cr,0) = nvl(vTotal_db,0));
  END valida_ajustes_PCGAs;
  --
  --
  FUNCTION valida_AnoMes (
    pCia   varchar2,
    pAno   varchar2,
    pMes   varchar2
  ) RETURN boolean IS
    --
    -- Valida que el a?o y mes a convertir sea menor o igual al periodo en proceso
    CURSOR c_val_periodo IS
      SELECT ano_proce, mes_proce
        FROM arcgmc
       WHERE no_cia = pCia;
    --
    vano  arcgmc.ano_proce%type;
    vmes  arcgmc.mes_proce%type;
  BEGIN
    OPEN  c_val_periodo;
    FETCH c_val_periodo INTO vano, vmes;
    CLOSE c_val_periodo;

    return(to_char(pano*100+to_number(pmes)) <= to_char(vano*100+vmes));
  END valida_AnoMes;
  --
  --
  FUNCTION existe_ajuste_PCGAs (
    pCia   varchar2,
    pAno   varchar2,
    pMes   varchar2
  ) RETURN boolean IS
    --
    --  Verifica la existencia del ajuste, en caso de existir, devuelve TRUE y en caso
    --  contrario devuelve FALSE
    CURSOR c_ex_ajuste IS
      SELECT 'S'
        FROM arcgpga
       WHERE no_cia = pCia
         AND ano    = pAno
         AND mes    = pMes;
    --
    vAjuste varchar2(1);
  BEGIN
    OPEN  c_ex_ajuste;
    FETCH c_ex_ajuste INTO vajuste;
    CLOSE c_ex_ajuste;

    return(nvl(vAjuste, 'N') = 'S');
  END existe_ajuste_PCGAs;
  ---
END;   -- BODY conversion
/
