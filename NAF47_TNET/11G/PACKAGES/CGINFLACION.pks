CREATE OR REPLACE PACKAGE            cginflacion AS
   -- ---
   --   El paquete INFLACION, contiene los procedimientos para
   --   generar el asiento por inflacion en el mes en proceso y
   --   otros meses
   -- ---
   --
   --* INFLACION
   --  Realiza el asiento de inflacion para el mes en proceso.
   --
   --* INFLACION_HIS
   --  Realiza el asiento de inflacion para otros meses.
   --
   --
   --
   PROCEDURE INFLACION(pno_Cia           IN arcgmc.no_cia%type
                      ,pano              IN arcgmc.ano_proce%type
                      ,pmes              IN arcgmc.mes_proce%type
                      ,pcodigo_ajuste    IN arcgtai.codigo_ajuste%type
                      ,pmodulo           IN varchar2
                      );
   --
   --
   FUNCTION  ultimo_error RETURN VARCHAR2;
   FUNCTION  ultimo_mensaje RETURN VARCHAR2;
   --
   error           EXCEPTION;
   PRAGMA          EXCEPTION_INIT(error, -20023);
   kNum_error      NUMBER := -20023;
   -- Define restricciones de procedimientos y funciones
   --    WNDS = Writes No Database State
   --    RNDS = Reads  No Database State
   --    WNPS = Writes No Package State
   --    RNPS = Reads  No Package State
END; -- Inflacion;
/


CREATE OR REPLACE PACKAGE BODY            CGINFLACION AS
  --
  /*******[ PARTE: PRIVADA ]
   * Declaracion de Procedimientos o funciones PRIVADOS
   *
   */
  --
  --
  CURSOR c_indice_procesado(pCia     varchar2, pIndice varchar2, pAno_aj number,
                            pMes_aj  number,   pMod    varchar2) IS
    SELECT decode(pMod, 'CON', nvl(procesado_conta,   'N'),
                        'ACT', nvl(procesado_activos, 'N'))
      FROM arcgcai
     WHERE no_cia           = pCia
       AND indice_economico = pIndice
       AND ano              = pAno_aj
       AND mes              = pMes_aj ;
  --
  --
  vMensaje_error   varchar2(160);
  vMensaje         varchar2(160);

  --
  --
  PROCEDURE genera_error(
    msj_error IN varchar2
  ) IS
  BEGIN
    vMensaje_error := substr(msj_error,1,160);
    vMensaje       := vMensaje_error;
    RAISE_APPLICATION_ERROR(kNum_error, msj_error);
  END;
  --
  --
  PROCEDURE inserta_cgal(
    pNo_cia     arcgal.no_cia%type,
    pAsiento    arcgal.no_asiento%type,
    pLinea      arcgal.no_linea%type,
    pDiario     arcgal.cod_diario%type,
    pcta        arcgal.cuenta%type,
    pdescri     arcgal.descri%type,
    ptipo       arcgal.tipo%type,
    pmonto      arcgal.monto%type,
    pmonto_dol  arcgal.monto_dol%type,
    pTipoCambio arcgal.tipo_cambio%type,
    pFecha      arcgal.fecha%type,
    pAno        arcgal.ano%type,
    pMes        arcgal.mes%type
  ) IS
    --
    vMonto      ARCGAL.MONTO%TYPE;
    vMonto_Dol  ARCGAL.MONTO_DOL%TYPE;
    --
  BEGIN
    IF pTipo = 'D' THEN
      vMonto     := abs(pMonto);
      vMonto_Dol := abs(pMonto_Dol);
    ELSE
      vMonto     := -abs(pMonto);
      vMonto_Dol := -abs(pMonto_Dol);
    END IF;
    --
    INSERT INTO arcgal (no_cia,        ano,         mes,
                        no_asiento,    no_linea,    descri,
                        cod_diario,    cuenta,      cc_1,
                        cc_2,          cc_3,        moneda,
                        tipo_cambio,   fecha,       tipo,
                        monto,         monto_dol,   linea_ajuste_precision)
                VALUES (pno_cia,       pano,        pmes,
                        pAsiento,      pLinea,      pDescri,
                        pDiario,       pcta,       '000',
                        '000',         '000',      'P',
                        pTipoCambio,   pFecha,     pTipo,
                        vMonto,        vMonto_Dol, 'N');
  END inserta_cgAL;
  --
  --
  PROCEDURE obtiene_valor_indice (
    pCodAjuste IN     varchar2,
    pCodIndice IN     arcgied.codigo%type,
    pPeriodo   IN     number,
    pValor     IN OUT arcgied.valor%type,
    pValor_Ant IN OUT arcgied.valor%type
  ) IS
    --
    CURSOR c_valor_indice(pindice varchar2, pano_mes number) IS
      SELECT valor
        FROM arcgied
       WHERE codigo                  = pindice
         AND to_char(fecha,'YYYYMM') = pano_mes;
    --
    vPeriodo   Number(6);
    vMes       Number(2);

  BEGIN

    pValor     := 0;
    pValor_Ant := 0;
    --
    OPEN  c_valor_indice(pCodIndice, pPeriodo);
    FETCH c_valor_indice INTO pvalor;
    CLOSE c_valor_indice;
    --
    IF nvl(pValor,0)  = 0 THEN
      genera_error('Valor del Indice: ' ||pCodIndice||
                   ' es 0, para el periodo '||pPeriodo);
    END IF;

    IF pCodAjuste = 'UPAC' THEN
      -- Obtiene el periodo anterior
      vMes := substr(pPeriodo, 5,2);
      IF vMes = 1 THEN
        vPeriodo := ((substr(pPeriodo, 1,4)-1)*100 ) + 12;
      ELSE
        vPeriodo := pPeriodo -1;
      END IF;
      --
      OPEN  c_valor_indice(pCodIndice, vPeriodo);
      FETCH c_valor_indice INTO pValor_Ant;
      CLOSE c_valor_indice;

      IF nvl(pValor_Ant,0) = 0 THEN
        genera_error('Valor del Indice: ' ||pCodIndice||
                     ' es 0, para el periodo '||vPeriodo);
      END IF;
    END IF;
  END;
  --
  --
  PROCEDURE inflacion_mes_proce (
    pNo_Cia           IN arcgmc.no_cia%type
   ,pano              IN arcgmc.ano_proce%type       -- ANO EN PROCESO DEL MODULO
   ,pmes              IN arcgmc.mes_proce%type       -- MES EN PROCESO DEL MODULO
   ,pcodigo_ajuste    IN arcgtai.codigo_ajuste%type
   ,pindice_economico IN arcgtai.indice_economico%type
   ,pcodigo_diario    IN arcgtai.cod_diario%type
   ,pmodulo           IN varchar2
  ) IS
    -- --
    --  Definicion de cursores
    --
    -- En este cursor las condiciones por el campo naturaleza se adicionan
    -- ya que los ajustes por inflacion no se dan para cuentas debito con saldo
    -- negativo, si esta condicion no es cierta, simplemente es eliminar estas
    -- Lineas del codigo.
    --
    CURSOR c_cuenta  IS
      SELECT cuenta,                          clase,
             NVL(saldo_mes_ant,0) saldo_mes_ant,
             cta_ajuste_inflacion, cta_correccion,
             cta_aj_inflac_orden, cta_correccion_orden
        FROM arcgms
       WHERE no_cia               = pno_cia
         AND ind_mov              = 'S'
         AND ajustable            = 'S'
         AND permiso_con          = 'S'
         AND NVL(usado_en, 'CG') != 'AF'
         AND cod_ajuste           = pCODIGO_AJUSTE
         AND activa               = 'S'
       ORDER BY clase, cuenta desc;
    --
    --
    CURSOR c_Clase IS
      SELECT clase_Cambio
        FROM arcgmc
       WHERE no_cia = pNo_Cia;

    -- --
    --  Definicion de variables

    vexiste                boolean;
    --
    vno_asiento            arcgae.no_asiento%type;
    vlinea                 number;
    vdescri1               arcgae.descri1%type     := 'Asiento generado en el modulo de contabilidad por '||Chr(13)||
                                                      'concepto de Ajustes por Inflacion, '||pcodigo_ajuste;
    vdescri                arcgal.descri%type      := 'Gan/Perd. Ajuste Inflacion';
    vt_debitos             arcgae.t_debitos%type;
    vt_creditos            arcgae.t_creditos%type;
    vsaldo_hoy             arcgms.saldo_mes_ant%type;
    vsaldo_mes_ant         arcgms.saldo_mes_ant%type;
    --
    vajuste                arcgal.monto%type       := 0;
    vajuste_dol            arcgal.monto%type       := 0;
    vRegistra_Ajuste       boolean;
    vtipo_mov_ajuste       arcgal.tipo%type;
    vtipo_mov_correccion   arcgal.tipo%type;
    vclase_cambio          arcgmc.clase_cambio%type;
    vfecha_Asiento         arcgae.fecha%type;
    vfecha_Tmp             arcgae.fecha%type;
    vTipoCambio            arcgal.tipo_Cambio%type;
    --
    vPeriodo               varchar2(6)     := to_char((pAno * 100) + pMes);
    vPeriodo_ant           varchar2(6);
    vAno_ant               number(4);
    vMes_ant               number(2);
    --
    vvalor_indice          arcgied.valor%type;
    vvalor_indice_mes_ant  arcgied.valor%type;
    vprocesado             arcgcai.procesado_contA%type;

  BEGIN
    -- --
    -- Calcula la fecha del asiento
    vFecha_Asiento := to_date(vPeriodo, 'YYYYMM');
    vFecha_Asiento := last_day(vFecha_Asiento);

    -- --
    -- Obtiene la clase de cambio de la compa?ia
    OPEN  c_clase;
    FETCH c_clase INTO vClase_Cambio;
    CLOSE c_clase;
    -- --
    -- Obtiene el tipo de cambio
    --
    vTipoCambio := Tipo_Cambio(vClase_Cambio, vFecha_Asiento, vFecha_Tmp, 'V');
    IF nvl(vTipoCambio,0) = 0 THEN
      genera_error('El tipo de cambio es cero . . .');
    END IF;

    -- --
    -- Obtiene el numero de transaccion
    vno_asiento := transa_id.cg(Pno_cia);
    IF nvl(vno_asiento,'0') = '0' THEN
      genera_error('No fue posible generar el numero de transaccion');
    END IF;
    -- --
    -- Genera el encabezado del asiento
    -- Se genera el con tipo de comprobante TRASPASO
    --
    INSERT INTO arcgae (no_cia,         ano,        mes,
                        no_asiento,     fecha,      origen,
                        descri1,        estado,     autorizado,
                        cod_diario,     t_camb_c_v, tipo_comprobante,
                        no_comprobante, tipo_cambio)
                VALUES (Pno_cia,        Pano,             Pmes,
                        vno_asiento,    vFecha_Asiento,   'AJ',
                        vdescri1,       'P',              'N',
                        pCodigo_Diario, 'V',              'T',
                        '0',             vTipoCambio);
    --
    vlinea      := 0;
    vt_debitos  := 0;
    vt_creditos := 0;
    --
    --  Se determina si el asiento ya se genero para ese ano y mes en proceso
    vprocesado := 'N';

    OPEN  c_indice_procesado(pNo_cia, pIndice_economico, pAno, pMes, pModulo);
    FETCH c_indice_procesado INTO vprocesado;
    vexiste := c_indice_procesado%FOUND;
    CLOSE c_indice_procesado;

    --
    IF vprocesado = 'S' THEN
      genera_error('Ya se genero el Asiento de Ajustes por Inflacion para el codigo de ajuste '||pcodigo_ajuste||' en el modulo de '||pmodulo);
    END IF;

    IF not vexiste THEN
      genera_error('No se ha definido el valor del Indice para el mes en proceso del codigo de ajuste '||pcodigo_ajuste);
    END IF;
    --
    Obtiene_Valor_Indice(pcodigo_ajuste, pIndice_Economico, vPeriodo, vValor_Indice, vvalor_indice_mes_ant);

    FOR f IN c_cuenta LOOP

      --  Valida si la cuenta tiene asociadas las cuentas de ajuste
      IF f.cta_ajuste_inflacion is null or f.cta_correccion is null THEN
        genera_error('La cuenta '||f.cuenta||' no tiene asignadas cuentas de ajuste.');
      END IF;
      --
      -- Calcula el ajuste
      IF Pcodigo_ajuste = 'UPAC' THEN
        vsaldo_hoy     := f.saldo_mes_ant/Vvalor_indice;
        vSaldo_mes_Ant := f.saldo_mes_ant/vvalor_indice_mes_ant;
        vajuste        := moneda.redondeo((vsaldo_hoy - vSaldo_Mes_Ant)*Vvalor_indice,'P');
        vajuste_dol    := moneda.redondeo((vAjuste/vTipoCambio),'D');

      ELSE

        vsaldo_hoy  := f.saldo_mes_ant + (f.saldo_mes_ant * (Vvalor_indice / 100));
        vajuste     := moneda.redondeo(vsaldo_hoy - f.saldo_mes_ant,'P');
        vajuste_dol := moneda.redondeo((vAjuste/vTipoCambio),'D');
      END IF;
      -- --
      -- Registra las lineas de ajuste en el asiento

      IF vajuste != 0 THEN
        vRegistra_Ajuste := FALSE;

        IF f.clase IN ('A','G') OR        -- Ctas ACTIVOS y gastos o
           (f.clase = 'O' and substr(f.cuenta,1,1) = '8') THEN    -- Ctas Orden deudoras PUC

          vRegistra_Ajuste := TRUE;

        ELSIF f.clase IN ('P','C','I') OR         -- Ctas Pasivo, Capital e Ingresos o
             (f.clase = 'O' and substr(f.cuenta,1,1) = '9') THEN            -- Ctas de Orden

          vRegistra_Ajuste := TRUE;

        END IF;
        --
        IF vRegistra_Ajuste THEN
          IF vajuste < 0  THEN
            vTipo_Mov_Ajuste     := 'C';
            vTipo_Mov_Correccion := 'D';
          ELSE
            vTipo_Mov_Ajuste     := 'D';
            vTipo_Mov_Correccion := 'C';
          END IF;

          vlinea := vlinea + 1;
          inserta_cgal(pNo_cia,  vno_asiento,  vLinea, pCodigo_diario,
                       f.cta_ajuste_inflacion, vdescri,     vTipo_Mov_Ajuste,
                       vajuste,                vAjuste_Dol, vTipoCambio,
                       vFecha_Asiento,  pAno,  pMes);


          --
          -- registra el movimiento de inflacion a la cuenta de orden respectiva
          vt_creditos := nvl(vt_creditos,0) + abs(vajuste);

          vlinea := vlinea + 1;
          inserta_cgal(pNo_cia,  vno_asiento, vLinea, pCodigo_diario,
                       f.cta_aj_inflac_orden, vdescri,     vTipo_Mov_Ajuste,
                       vajuste,               vAjuste_Dol, vTipoCambio,
                       vFecha_Asiento,  pAno, pMes);


          vt_creditos := nvl(vt_creditos,0) + abs(vajuste);

          -- --
          -- Registra contrapartida (Correccion Monetaria) por ajuste
          --
          vlinea := vlinea + 1;
          inserta_cgal(pNo_cia,  vno_asiento, vLinea, pCodigo_diario,
                       f.cta_correccion, vdescri,     vTipo_Mov_Correccion,
                       vajuste,          vAjuste_Dol, vTipoCambio,
                       vFecha_Asiento,   pAno, pMes);

          vt_debitos := nvl(vt_debitos,0) + abs(vajuste);

          --
          -- registra la contrapartida a la cuenta de orden respectiva.
          vlinea := vlinea + 1;
          inserta_cgal(pNo_cia,  vno_asiento,  vLinea, pCodigo_diario,
                       f.cta_correccion_orden, vdescri,     vTipo_Mov_Correccion,
                       vajuste,          vAjuste_Dol, vTipoCambio,
                       vFecha_Asiento,   pAno, pMes);

          vt_debitos := nvl(vt_debitos,0) + abs(vajuste);

        END IF;
      END IF;
    END LOOP;

    -- ------------------------------------------------------------------
    -- Actualiza total del asiento en la tabla de Encabezado del asiento
    -- ------------------------------------------------------------------
    IF vlinea > 0 THEN
      UPDATE arcgae
         SET t_debitos  = vt_debitos,
             t_creditos = vt_creditos
       WHERE no_cia     = pno_cia
         AND no_asiento = vno_asiento;

    ELSIF vLinea = 0 THEN
      DELETE arcgae
       WHERE no_cia     = pno_cia
         AND no_asiento = vno_asiento;
    END IF;
    --
    IF pModulo = 'CON'  THEN
      --
      -- Actualiza indicador de que el indice economico ya se proceso, por lo que no
      -- deberia permitir variarlo en el mantenimiento.
      UPDATE arcgied
         SET modificable     = 'N'
       WHERE codigo          = pIndice_economico
         AND to_char(fecha,'YYYYMM') = vPeriodo;

      IF SQL%RowCount = 0 THEN
        genera_error('No se ha registrado el Indice Economico correspondiente a '||pIndice_Economico);
      END IF;

      --
      -- Pone el indicador de que el indice economico ya se calculo para el periodo actual.
      UPDATE arcgcai
         SET procesado_conta  = 'S'
       WHERE no_cia           = pNo_cia
         AND indice_economico = pIndice_economico
         AND ano              = pAno
         AND mes              = pMes;

      IF sql%rowcount = 0 THEN
        --
        -- Si no lo encontro, inserta el registro.
        INSERT INTO arcgcai (NO_CIA, INDICE_ECONOMICO, ANO, MES,
                             PROCESADO_CONTA)
                     VALUES (pNo_Cia, pIndice_economico, pAno, pMes,
                             'S');
      END IF;

      -- El Siguiente Segmento de Codigo se realiza para la primera vez que se ejecuta
      -- el asiento de ajuste por UPAC y es que debe colocar los dos valores mensuales
      -- como procesados. Para los siguientes meses, el mes anterior esta ya marcado,
      -- pero volver a realizar un update no genera inconsistencia en la Base de Datos
      IF pMes = 1 THEN
        vPeriodo_Ant := ((pAno-1)*100)+12;
        vAno_ant     := pAno - 1;
        vMes_ant     := 12;
      ELSE
        vPeriodo_Ant := (pAno*100)+pMes-1;
        vAno_ant     := pAno;
        vMes_ant     := pMes - 1;
      END IF;
      --
      UPDATE arcgied
         SET modificable = 'N'
       WHERE codigo                             = pIndice_economico
         AND to_number(to_char(fecha,'YYYYMM')) = vPeriodo_Ant;

      --
      -- Pone el indicador de que el indice economico ya se calculo para el periodo anterior.
      UPDATE arcgcai
         SET procesado_conta  = 'S'
       WHERE no_cia           = pNo_cia
         AND indice_economico = pIndice_economico
         AND ano              = vAno_ant
         AND mes              = vMes_ant;

      IF sql%rowcount = 0 THEN
        --
        -- Si no lo encontro, inserta el registro.
        INSERT INTO arcgcai (NO_CIA, INDICE_ECONOMICO, ANO, MES,
                             PROCESADO_CONTA)
                     VALUES (pNo_Cia, pIndice_economico, vAno_ant, vMes_ant,
                             'S');
      END IF;

    ELSIF pModulo = 'ACT'  THEN
      --
      UPDATE arcgied
         SET modificable       = 'N'
       WHERE codigo                  = pIndice_economico
         AND to_char(fecha,'YYYYMM') = vPeriodo;

      --
      -- Pone el indicador de que el indice economico ya se calculo para el periodo anterior.
      UPDATE arcgcai
         SET procesado_activos = 'S'
       WHERE no_cia            = pNo_cia
         AND indice_economico  = pIndice_economico
         AND ano               = pAno
         AND mes               = pMes;

      IF sql%rowcount = 0 THEN
        --
        -- Si no lo encontro, inserta el registro.
        INSERT INTO arcgcai (NO_CIA, INDICE_ECONOMICO, ANO, MES,
                             PROCESADO_ACTIVOS)
                     VALUES (pNo_Cia, pIndice_economico, pAno, pMes,
                             'S');
      END IF;
    END IF;
  EXCEPTION
    WHEN transa_id.error THEN
         genera_error(transa_id.ultimo_error);
    WHEN others THEN
         genera_error(sqlerrm);
  END;
  --
  --
  PROCEDURE inflacion_his (
    pNO_Cia            IN arcgmc.no_cia%type
   ,pano              IN arcgmc.ano_proce%type       -- ANO DIFERENTE AL DE PROCESO
   ,pmes              IN arcgmc.mes_proce%type       -- MES DIFERENTE AL DE PROCESO
   ,pcodigo_ajuste    IN arcgtai.codigo_ajuste%type
   ,pindice_economico IN arcgtai.indice_economico%type
   ,pcodigo_diario    IN arcgtai.cod_diario%type
   ,pmodulo           IN varchar2
  ) IS
    -- --
    -- Definicion de Cursores
    --
    CURSOR c_cuenta  IS
      SELECT a.cuenta, a.clase,
             NVL(b.saldo,0)     - NVL(b.movimiento,0) saldo_mes_ant,
             a.cta_ajuste_inflacion, a.cta_correccion,
             a.cta_aj_inflac_orden, a.cta_correccion_orden
        FROM arcgms a, arcghc b
       WHERE a.no_cia           = Pno_cia
         AND a.ind_mov          = 'S'
         AND a.ajustable        = 'S'
         AND a.permiso_con      = 'S'
         AND a.cod_ajuste       = PCODIGO_AJUSTE
         AND a.activa           = 'S'
         AND nvl(B.saldo,0) - nvl(B.movimiento,0) != 0
         AND a.no_cia    =  b.no_cia
         AND a.cuenta    =  b.cuenta
         AND b.ano       =  Pano
         AND b.mes       =  Pmes
       ORDER BY a.clase,a.cuenta desc;
    --
    --
    CURSOR c_Clase IS
      SELECT clase_Cambio
        FROM arcgmc
       WHERE no_cia = pNo_Cia;

    -- --
    --  Definicion de variables

    vexiste                boolean;
    --
    vno_asiento            arcgae.no_asiento%type;
    vlinea                 number;
    vdescri1               arcgae.descri1%type     := 'Asiento generado en el modulo de contabilidad por '||Chr(13)||
                                                      'concepto de Ajustes por Inflacion, '||pcodigo_ajuste;
    vdescri                arcgal.descri%type      := 'Gan/Perd. Ajuste Inflacion';
    vt_debitos             arcgae.t_debitos%type;
    vt_creditos            arcgae.t_creditos%type;
    --
    vsaldo_hoy             arcgms.saldo_mes_ant%type;
    vsaldo_mes_ant         arcgms.saldo_mes_ant%type;
    --
    vajuste                arcgal.monto%type       := 0;
    vajuste_dol            arcgal.monto%type       := 0;
    vRegistra_Ajuste       boolean;
    vtipo_mov_ajuste       arcgal.tipo%type;
    vtipo_mov_correccion   arcgal.tipo%type;
    vclase_cambio          arcgmc.clase_cambio%type;
    vfecha_Asiento         arcgae.fecha%type;
    vfecha_Tmp             arcgae.fecha%type;
    vTipoCambio            arcgal.tipo_Cambio%type;
    --
    vPeriodo               varchar2(6)     := TO_CHAR((pANO * 100) + pMES);
    vPeriodo_Ant           varchar2(6);

    vvalor_indice          arcgied.valor%type;
    vvalor_indice_mes_ant  arcgied.valor%type;
    vprocesado             arcgcai.procesado_conta%type;

    -- --
    --

  BEGIN
    -- --
    -- Calcula la fecha del asiento
    vFecha_Asiento := to_date(vPeriodo, 'YYYYMM');
    vFecha_Asiento := last_day(vFecha_Asiento);
    -- --
    -- Obtiene la clase de cambio de la compa?ia
    OPEN  c_clase;
    FETCH c_clase INTO vClase_Cambio;
    CLOSE c_clase;

    -- --
    -- Obtiene el tipo de cambio
    --
    vTipoCambio := Tipo_Cambio(vClase_Cambio, vFecha_Asiento, vFecha_Tmp, 'V');
    -- --
    -- Obtiene el numero de transaccion

    vno_asiento := transa_id.cg(Pno_cia);
    IF nvl(vno_asiento,'0') = '0' THEN
      genera_error('No fue posible generar el numero de transaccion');
    END IF;
    --
    -- --
    -- Genera el encabezado del asiento
    -- Se genera el con tipo de comprobante TRASPASO
    --
    INSERT INTO arcgae (no_cia,        ano,        mes,
                        no_asiento,    fecha,      origen,
                        descri1,       estado,     autorizado,
                        cod_diario,    t_camb_c_v, tipo_comprobante,
                        no_comprobante)
                VALUES (Pno_cia,          Pano,             Pmes,
                        vno_asiento,      vFecha_Asiento,   'AJ',
                        vdescri1,         'O',              'S',
                        pCodigo_Diario,   'V',              'T',
                        '0');
    --
    vlinea      := 0;
    vt_debitos  := 0;
    vt_creditos := 0;
    --
    --  Se determina si el asiento ya se genero para ese ano y mes en proceso
    vprocesado := 'N';
    OPEN  c_indice_procesado(pNo_cia, pindice_economico, pAno, pMes, pModulo);
    FETCH c_indice_procesado into vprocesado;
    vexiste := c_indice_procesado%FOUND;
    CLOSE c_indice_procesado;
    --
    IF vprocesado = 'S' THEN
      genera_error('Ya se genero el Asiento de Ajustes por Inflacion para el codigo de ajuste '||pcodigo_ajuste||' en el modulo de '||pmodulo);
    END IF;
    --
    IF not vexiste THEN
      genera_error('No se ha definido el valor del Indice para el mes en proceso  para el codigo de ajuste '||pcodigo_ajuste);
    END IF;
    --
    Obtiene_Valor_Indice(pcodigo_ajuste, pIndice_Economico, vPeriodo, vValor_Indice, vvalor_indice_mes_ant);

    FOR f IN c_cuenta LOOP

      --  Valida si la cuenta tiene asociadas las cuentas de ajuste
      IF f.cta_ajuste_inflacion is null or f.cta_correccion is null THEN
        genera_error('La cuenta '||f.cuenta||' no tiene asignadas cuentas de ajuste.');
      END IF;
      --
      -- Calcula el ajuste
      IF Pcodigo_ajuste = 'UPAC' THEN

        vsaldo_hoy     := f.saldo_mes_ant/Vvalor_indice;
        vSaldo_mes_Ant := f.saldo_mes_ant/vvalor_indice_mes_ant;
        vajuste        := moneda.redondeo((vsaldo_hoy - vSaldo_Mes_Ant)*Vvalor_indice,'P');
        vajuste_dol    := moneda.redondeo((vAjuste/vTipoCambio),'D');

      ELSE

        vsaldo_hoy  := f.saldo_mes_ant + (f.saldo_mes_ant * (Vvalor_indice / 100));
        vajuste     := moneda.redondeo(vsaldo_hoy - f.saldo_mes_ant,'P');
        vajuste_dol := moneda.redondeo((vAjuste/vTipoCambio),'D');

      END IF;
      -- --
      -- Registra las lineas de ajuste en el asiento

      IF vajuste != 0 THEN
        vRegistra_Ajuste := FALSE;

        IF f.clase IN ('A','G') OR        -- Ctas ACTIVOS y gastos o
          (f.clase = 'O' and substr(f.cuenta,1,1) = '8') THEN    -- Ctas Orden deudoras PUC

          vRegistra_Ajuste := TRUE;

        ELSIF f.clase IN ('P','C','I') OR         -- Ctas Pasivo, Capital e Ingresos o
             (f.clase = 'O' and substr(f.cuenta,1,1) = '9') THEN            -- Ctas de Orden

          vRegistra_Ajuste := TRUE;

        END IF;
        --
        IF vRegistra_Ajuste THEN
          IF vajuste < 0  THEN
            vTipo_Mov_Ajuste     := 'C';
            vTipo_Mov_Correccion := 'D';
          ELSE
            vTipo_Mov_Ajuste     := 'D';
            vTipo_Mov_Correccion := 'C';
          END IF;

          --
          -- registra la partida de ajuste por inflacion
          vlinea := vlinea + 1;
          inserta_cgal(pNo_cia,  vno_asiento, vLinea, pCodigo_diario,
                       f.cta_ajuste_inflacion, vdescri,     vTipo_Mov_Ajuste,
                       vajuste,                vAjuste_Dol, vTipoCambio,
                       vFecha_Asiento,  pAno,  pMes);

          vt_creditos := nvl(vt_creditos,0) + abs(vajuste);

          --
          -- registra la partida de ajuste por inflacion a la cuenta de orden respectiva
          vlinea := vlinea + 1;
          inserta_cgal(pNo_cia,  vno_asiento, vLinea, pCodigo_diario,
                       f.cta_aj_inflac_orden, vdescri,     vTipo_Mov_Ajuste,
                       vajuste,                vAjuste_Dol, vTipoCambio,
                       vFecha_Asiento,  pAno,  pMes);

          vt_creditos := nvl(vt_creditos,0) + abs(vajuste);

          -- --
          -- Registra contrapartida (Correccion Monetaria) por ajuste
          --
          vlinea := vlinea + 1;

          inserta_cgal(pNo_cia,  vno_asiento, vLinea, pCodigo_diario,
                       f.cta_correccion, vdescri,     vTipo_Mov_Correccion,
                       vajuste,  vAjuste_Dol, vTipoCambio,
                       vFecha_Asiento,  pAno, pMes);

          vt_debitos := nvl(vt_debitos,0) + abs(vajuste);

          -- --
          -- Registra la contrapartida (Correccion Monetaria) a la cuenta de orden respectiva
          --
          vlinea := vlinea + 1;

          inserta_cgal(pNo_cia,  vno_asiento, vLinea, pCodigo_diario,
                       f.cta_correccion_orden, vdescri,     vTipo_Mov_Correccion,
                       vajuste,  vAjuste_Dol, vTipoCambio,
                       vFecha_Asiento,  pAno, pMes);

          vt_debitos := nvl(vt_debitos,0) + abs(vajuste);

        END IF;
      END IF;
    END LOOP;
    -- ------------------------------------------------------------------
    -- Actualiza total del asiento en la tabla de Encabezado del asiento
    -- ------------------------------------------------------------------
    IF vlinea > 0 THEN
      UPDATE arcgae
         SET t_debitos  = vt_debitos,
             t_creditos = vt_creditos
       WHERE no_cia     = pno_cia
         AND no_asiento = vno_asiento;
    ELSIF vLinea = 0 THEN
      DELETE arcgae
       WHERE no_cia     = pno_cia
         AND no_asiento = vno_asiento;
    END IF;
    --
    IF pModulo = 'CON' THEN

      --
      -- Pone el indicador de que el indice economico ya se calculo para el periodo anterior.
      UPDATE arcgcai
         SET procesado_conta   = 'S'
       WHERE no_cia            = pNo_cia
         AND indice_economico  = pIndice_economico
         AND (ano*100)+mes     > (pAno*100) + pMes;

    ELSIF pModulo = 'ACT'  THEN
      --
      -- Pone el indicador de que el indice economico ya se calculo para el periodo anterior.
      UPDATE arcgcai
         SET procesado_activos = 'S'
       WHERE no_cia            = pNo_cia
         AND indice_economico  = pIndice_economico
         AND (ano*100)+mes     > (pAno*100) + pMes;
    END IF;

  EXCEPTION
    WHEN transa_id.error THEN
         genera_error(transa_id.ultimo_error);
    WHEN others THEN
         genera_error(sqlerrm);
  END;
  --
  --
  /*******[ PARTE: PUBLICA ]
   * Declaracion de Procedimientos o funciones PUBLICAS
   */
  --
  FUNCTION ultimo_error RETURN varchar2 IS
  BEGIN
    RETURN(vMensaje_error);
  END ultimo_error;
  --
  --
  FUNCTION ultimo_mensaje RETURN varchar2 IS
  BEGIN
    RETURN(vMensaje);
  END ultimo_mensaje;
  --
  --
  PROCEDURE inflacion(
    pNo_Cia           IN arcgmc.no_cia%type
   ,pano              IN arcgmc.ano_proce%type       -- ANO EN PROCESO DEL MODULO
   ,pmes              IN arcgmc.mes_proce%type       -- MES EN PROCESO DEL MODULO
   ,pcodigo_ajuste    IN arcgtai.codigo_ajuste%type
   ,pmodulo           IN varchar2
  ) IS

    vPeriodo_ajuste  number;
    vPeriodo_proce   number;
    --
    CURSOR c_datos_cia IS
      SELECT ((ano_proce * 100) + mes_proce)
        FROM arcgmc
       WHERE no_cia = pno_cia;
    --
    CURSOR c_datos_tai IS
      SELECT a.indice_economico, a.cod_diario
        FROM arcgtai a
       WHERE a.no_cia = pno_cia;
    --
    rtai    c_datos_tai%rowtype;
    --
  BEGIN
    vPeriodo_ajuste  := (pano * 100) + pmes;
    --
    OPEN  c_datos_cia;
    FETCH c_datos_cia INTO vPeriodo_proce;
    CLOSE c_datos_cia;
    --
    OPEN  c_datos_tai;
    FETCH c_datos_tai INTO rtai;
    CLOSE c_datos_tai;

    IF vPeriodo_ajuste = vPeriodo_proce THEN
      inflacion_mes_proce(pno_cia,        pano,                  pmes,
                          pcodigo_ajuste, rtai.indice_economico, rtai.cod_diario,
                          pmodulo);
    ELSIF vPeriodo_ajuste < vPeriodo_proce THEN
      inflacion_his(pno_cia,        pano,                  pmes,
                    pcodigo_ajuste, rtai.indice_economico, rtai.cod_diario,
                    pmodulo);
    END IF;

  EXCEPTION
    WHEN others THEN
         genera_error(sqlerrm);
  END;
  --
  --
END;   -- BODY CGInflacion
/
