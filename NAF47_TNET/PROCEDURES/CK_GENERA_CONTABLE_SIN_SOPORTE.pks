CREATE OR REPLACE PROCEDURE NAF47_TNET.CK_GENERA_CONTABLE_SIN_SOPORTE ( Pn_NoDocumento   IN     NUMBER,
                                                             Pv_TipoDocumento IN     VARCHAR2,
                                                             Pv_NoCia         IN     VARCHAR2,
                                                             Pn_NoAsiento     IN OUT NUMBER,
                                                             Pv_MensajeError  IN OUT VARCHAR2
                                                           ) IS

/**
* Documentacion para el procedimiento CK_GENERA_CONTABLE_SIN_SOPORTE
* Procedimiento que genera registro contable de una trx migrada desde el SIT
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.0 09-06-2011
* @author Sofia Fernandez <sfernandez@telconet.ec>
* @version 1.1 14-10-2016 Se agrega Validacio para origen WS para el campo fecha
*/

  -- Periodo proceso contable
  CURSOR C_PERIODO_PROCESO_CG IS
    SELECT ANO_PROCE,
           MES_PROCE,
           (ANO_PROCE*100)+MES_PROCE PERIODO_PROCESO
      FROM ARCGMC
     WHERE NO_CIA = Pv_NoCia;
  -- Documento Migrado
  CURSOR C_DOCUMENTO_MIGRADO IS
    SELECT DM.NO_CIA,
           DM.NO_CTA,
           DM.TIPO_DOC,
           DM.NO_DOCU,
           SYSDATE FECHA,
           DM.COMENTARIO COMENTARIO_FECHA,
           DECODE(DM.ORIGEN,'MD','12',CB.COD_DIARIOM) COD_DIARIOM,
           TRIM(TO_CHAR(DM.FECHA,'YYYY-MM-DD'))||' '||DM.COMENTARIO COMENTARIO,
           TD.TIPO_COMPROBANTE,
           CB.NO_CUENTA,
           DECODE(DM.TIPO_DOC,'ND',CB.ID_CTA_PROTESTO, CB.CTA_SIN_SOPORTE) CTA_SIN_SOPORTE,
           DM.NO_FISICO,
           DM.SERIE_FISICO,
           DM.ORIGEN,
           DM.FECHA_CREACION
      FROM MIGRA_ARCKMM DM,
           ARCKTD TD,
           ARCKMC CB
     WHERE DM.TIPO_DOC = TD.TIPO_DOC
       AND DM.NO_CIA = TD.NO_CIA
       AND DM.NO_CTA = CB.NO_CTA
       AND DM.NO_CIA = CB.NO_CIA
       AND DM.NO_DOCU  = Pn_NoDocumento
       AND DM.TIPO_DOC = Pv_TipoDocumento
       AND DM.NO_CIA   = Pv_NoCia;
  --
  CURSOR C_DETALLE_DOC_MIGRADO ( Cn_NoDocumento   NUMBER,
                                 Cv_TipoDocumento VARCHAR2,
                                 Cv_IdCia         VARCHAR2 ) IS
    SELECT DD.*,
           DD.ROWID
      FROM MIGRA_ARCKML DD
     WHERE DD.NO_DOCU  = Cn_NoDocumento
       AND DD.TIPO_DOC = Cv_TipoDocumento
       AND DD.NO_CIA   = Cv_IdCia;
  --
  Lr_AsientoContable ARCGAE%ROWTYPE := NULL;
  Lr_DetalleAsieCont ARCGAL%ROWTYPE := NULL;
  Lr_Proceso         C_PERIODO_PROCESO_CG%ROWTYPE := NULL;
  Lr_CtaContable     CUENTA_CONTABLE.DATOS_R := NULL;
  --
  Le_ErrorProceso EXCEPTION;
  --
BEGIN
  -- se determina periodo de proceso contable
  IF C_PERIODO_PROCESO_CG%ISOPEN THEN CLOSE C_PERIODO_PROCESO_CG; END IF;
  OPEN C_PERIODO_PROCESO_CG;
  FETCH C_PERIODO_PROCESO_CG INTO Lr_Proceso;
  IF C_PERIODO_PROCESO_CG%NOTFOUND THEN
    Pv_MensajeError := 'No se ha definido Anio y Mes de Proceso Contable.';
    RAISE Le_ErrorProceso;
  END IF;
  CLOSE C_PERIODO_PROCESO_CG;
  --
  -- Se recuperan datos de cabecera de asientos contables
  --
  FOR Lr_DocCkMigrado IN C_DOCUMENTO_MIGRADO LOOP
    -- Determinar la fecha en base al Comentario
    IF Lr_DocCkMigrado.origen = 'MD' THEN
      Lr_DocCkMigrado.Fecha := Lr_DocCkMigrado.Fecha_Creacion;
    ELSE
      IF INSTR(UPPER(Lr_DocCkMigrado.Comentario_Fecha),'TELCOS') > 0  THEN
        Lr_DocCkMigrado.Fecha := TO_DATE(SUBSTR(Lr_DocCkMigrado.Comentario_Fecha, INSTR(UPPER(Lr_DocCkMigrado.Comentario_Fecha),'TELCOS')+7,10),'DD/MM/YYYY');

      ELSIF INSTR(UPPER(Lr_DocCkMigrado.Comentario_Fecha), 'SIT') > 0 THEN
        Lr_DocCkMigrado.Fecha := TO_DATE(SUBSTR(Lr_DocCkMigrado.Comentario_Fecha, INSTR(UPPER(Lr_DocCkMigrado.Comentario_Fecha), 'SIT')+4,10),'DD-MM-YYYY');
      ELSIF Lr_DocCkMigrado.Origen = 'WS' THEN       
         Lr_DocCkMigrado.Fecha := TRUNC(Lr_DocCkMigrado.Fecha_Creacion);
      ELSE
        Pv_MensajeError := 'No se pudo determinar fecha en el comentario, favor revisar.';
        RAISE Le_ErrorProceso;
      END IF;
    END IF;


    -- Variables fijas de asiento contable por ser igual o superior a periodo de proceso
    Lr_AsientoContable.No_Cia     := Lr_DocCkMigrado.No_Cia;
    Lr_AsientoContable.No_Asiento := TRANSA_ID.CG(Lr_AsientoContable.No_Cia);
    --
    -- se debe validar el periodo contable, no siempre esta fecha es superior al periodo contable
    IF Lr_Proceso.Periodo_Proceso > TO_NUMBER(TO_CHAR(Lr_DocCkMigrado.Fecha,'YYYYMM')) THEN
      Lr_AsientoContable.Fecha := LAST_DAY(TO_DATE('01/'||Lr_Proceso.Mes_Proce||'/'||Lr_Proceso.Ano_Proce,'DD/MM/YYYY'));
    ELSE
      Lr_AsientoContable.Fecha := Lr_DocCkMigrado.Fecha;
    END IF;
    --
    Lr_AsientoContable.Ano              := TO_NUMBER(TO_CHAR(Lr_AsientoContable.Fecha,'YYYY'));
    Lr_AsientoContable.Mes              := TO_NUMBER(TO_CHAR(Lr_AsientoContable.Fecha,'MM'));
    Lr_AsientoContable.Estado           := 'P';
    Lr_AsientoContable.Autorizado       := 'N';
    Lr_AsientoContable.Anulado          := 'N';
    Lr_AsientoContable.Cod_Diario       := Lr_DocCkMigrado.Cod_Diariom;
    Lr_AsientoContable.Origen           := 'CK';
    Lr_AsientoContable.Tipo_Comprobante := 'T';
    Lr_AsientoContable.No_Comprobante   := 0;
    Lr_AsientoContable.Descri1          := SUBSTR(Lr_DocCkMigrado.Comentario,1,240);

    -- -------------------------------------------------------------------
    -- Crea el Encabezado del Asiento, posteriormente le pone el total
    -- de debitos y creditos del mismo
    -- -------------------------------------------------------------------
    INSERT INTO ARCGAE
              ( NO_CIA,     ANO,              MES,
                NO_ASIENTO, FECHA,            ESTADO,
                AUTORIZADO, ANULADO,          COD_DIARIO,
                ORIGEN,     TIPO_COMPROBANTE, NO_COMPROBANTE,
                DESCRI1 )
       VALUES ( Lr_AsientoContable.No_Cia,     Lr_AsientoContable.Ano,              Lr_AsientoContable.Mes,
                Lr_AsientoContable.No_Asiento, Lr_AsientoContable.Fecha,            Lr_AsientoContable.Estado,
                Lr_AsientoContable.Autorizado, Lr_AsientoContable.Anulado,          Lr_AsientoContable.Cod_Diario,
                Lr_AsientoContable.Origen,     Lr_AsientoContable.Tipo_Comprobante, Lr_AsientoContable.No_Comprobante,
                Lr_AsientoContable.Descri1 );

    Lr_AsientoContable.t_Debitos  := 0;
    Lr_AsientoContable.t_Creditos := 0;

    --  generacion de detalle contable
    FOR Lr_DetalleDocMigrado IN C_DETALLE_DOC_MIGRADO ( Lr_DocCkMigrado.No_Docu,
                                                        Lr_DocCkMigrado.Tipo_Doc,
                                                        Lr_DocCkMigrado.No_Cia  ) LOOP
      Lr_DetalleAsieCont.No_Cia     := Lr_AsientoContable.No_Cia;
      Lr_DetalleAsieCont.Ano        := Lr_AsientoContable.Ano;
      Lr_DetalleAsieCont.Mes        := Lr_AsientoContable.Mes;
      Lr_DetalleAsieCont.No_Asiento := Lr_AsientoContable.No_Asiento;
      Lr_DetalleAsieCont.No_Linea   := NVL(Lr_DetalleAsieCont.No_Linea,0) + 1;

      -- Se verifica la cuenta contable de bancos para reemplazarla por la cuenta sin soporte
      IF Lr_DetalleDocMigrado.Cod_Cont = Lr_DocCkMigrado.No_Cuenta THEN
        -- Si existe ingresada cuenta sin soporte realizar las debidas validaciones
        -- que se realizan en la pantalla de bancos
        IF Lr_DocCkMigrado.Cta_Sin_Soporte IS NULL THEN
          Pv_MensajeError := 'No se ha configurado Cuenta contable para contabilizacion documentos sin soporte.';
          RAISE Le_ErrorProceso;
        -- verifica si la cuenta existe
        ELSIF NOT CUENTA_CONTABLE.EXISTE(Lr_DocCkMigrado.No_Cia, Lr_DocCkMigrado.Cta_Sin_Soporte) THEN
          Pv_MensajeError := 'Cuenta contable sin soporte no existe o no esta activa.';
          RAISE Le_ErrorProceso;
        -- verifica si la cuenta genera movimientos}
        ELSIF NOT CUENTA_CONTABLE.ACEPTA_MOV(Lr_DocCkMigrado.No_Cia, Lr_DocCkMigrado.Cta_Sin_Soporte) THEN
          Pv_MensajeError := 'Cuenta contable sin soporte no acepta movimientos.';
          RAISE Le_ErrorProceso;
        --Verifica si la cuenta en permitida dentro del modulo de bancos
        ELSIF NOT CUENTA_CONTABLE.PERMITIDA (Lr_DocCkMigrado.No_Cia, Lr_DocCkMigrado.Cta_Sin_Soporte, 'CK') then
          Pv_MensajeError := 'Cuenta contable sin soporte pertenece a otro auxiliar, NO Puede ser Utilizada.';
          RAISE Le_ErrorProceso;
        END IF;

        -- se recuperan datos de la cuenta contable
        Lr_CtaContable := CUENTA_CONTABLE.TRAE_DATOS(Lr_DocCkMigrado.No_Cia, Lr_DocCkMigrado.Cta_Sin_Soporte);

        ----------------------------
        -- SE ASIGNA NUEVA CUENTA --
        ----------------------------
        Lr_DetalleAsieCont.Cuenta := Lr_DocCkMigrado.Cta_Sin_Soporte;

        -- Si cuenta acepta centro de costo se ingresa la del documento migrado
        IF NVL(Lr_CtaContable.Acepta_Cc,'N') = 'S' THEN
          IF Lr_DetalleDocMigrado.Centro_Costo IS NOT NULL THEN
            Lr_DetalleAsieCont.Centro_Costo := Lr_DetalleDocMigrado.Centro_Costo;
          END IF;
        END IF;

        -- Si cuenta permite codigo tercero, se asigna la del documento migrado
        IF CUENTA_CONTABLE.ACEPTA_TERCERO(Lr_DocCkMigrado.No_Cia, Lr_DocCkMigrado.Cta_Sin_Soporte) THEN
          IF Lr_DetalleDocMigrado.Codigo_Tercero IS NOT NULL THEN
            Lr_DetalleAsieCont.Codigo_Tercero := Lr_DetalleDocMigrado.Codigo_Tercero;
          END IF;
        END IF;
      -- Se asignan los datos como viene en documento migrado
      ELSE
        Lr_DetalleAsieCont.Cuenta := Lr_DetalleDocMigrado.Cod_Cont;
        Lr_DetalleAsieCont.Centro_Costo := Lr_DetalleDocMigrado.Centro_Costo;
        Lr_DetalleAsieCont.Codigo_Tercero := Lr_DetalleDocMigrado.Codigo_Tercero;
      END IF; -- fin verifica cta contable de bancos

      Lr_DetalleAsieCont.Tipo := Lr_DetalleDocMigrado.Tipo_Mov;

      -- se determina la naturaleza del detalle de asiento
      IF (Lr_DetalleAsieCont.Tipo = 'C') then
        Lr_DetalleAsieCont.Monto      := Lr_DetalleDocMigrado.Monto * (-1);
        Lr_DetalleAsieCont.Monto_Dol  := Lr_DetalleDocMigrado.Monto_Dol * (-1);
        Lr_AsientoContable.t_Creditos := NVL(Lr_AsientoContable.t_Creditos,0) + NVL(Lr_DetalleDocMigrado.Monto,0);

      ELSE
        Lr_DetalleAsieCont.Monto     := Lr_DetalleDocMigrado.Monto;
        Lr_DetalleAsieCont.Monto_Dol := Lr_DetalleDocMigrado.Monto_Dol;
        Lr_AsientoContable.t_Debitos := NVL(Lr_AsientoContable.t_Debitos,0) + NVL(Lr_DetalleDocMigrado.Monto,0);
      END IF;

      Lr_DetalleAsieCont.Descri := SUBSTR( Lr_DocCkMigrado.tipo_doc||' '||
                                           Lr_DocCkMigrado.no_fisico||'-'||
                                           Lr_DocCkMigrado.serie_fisico||' :'||
                                           Lr_DetalleDocMigrado.glosa, 1, 50);
      Lr_DetalleAsieCont.No_Docu      := Lr_DocCkMigrado.No_Docu;
      Lr_DetalleAsieCont.Cod_Diario   := Lr_DocCkMigrado.Cod_Diariom;
      Lr_DetalleAsieCont.Moneda       := Lr_DetalleDocMigrado.Moneda;
      Lr_DetalleAsieCont.Tipo_Cambio  := Lr_DetalleDocMigrado.Tipo_Cambio;
      Lr_DetalleAsieCont.Centro_Costo := Lr_DetalleDocMigrado.Centro_Costo;
      Lr_DetalleAsieCont.Fecha        := Lr_AsientoContable.Fecha;

      ----------------------------------------------------------------------------
      -- INGRESO DEL DETALLE DE ASIENTO CONTABLE EN BASE AL DOCUMENTO MIGRACION --
      ----------------------------------------------------------------------------
      INSERT INTO ARCGAL (NO_CIA,         ANO,          MES,
                          NO_ASIENTO,     NO_LINEA,     CUENTA,
                          MONTO,          TIPO,         DESCRI,
                          NO_DOCU,        COD_DIARIO,   MONEDA,
                          TIPO_CAMBIO,    CENTRO_COSTO, MONTO_DOL,
                          CODIGO_TERCERO, FECHA)
                 VALUES (Lr_DetalleAsieCont.No_Cia,         Lr_DetalleAsieCont.Ano,          Lr_DetalleAsieCont.Mes,
                         Lr_DetalleAsieCont.No_Asiento,     Lr_DetalleAsieCont.No_Linea,     Lr_DetalleAsieCont.Cuenta,
                         Lr_DetalleAsieCont.Monto,          Lr_DetalleAsieCont.Tipo,         Lr_DetalleAsieCont.Descri,
                         Lr_DetalleAsieCont.No_Docu,        Lr_DetalleAsieCont.Cod_Diario,   Lr_DetalleAsieCont.Moneda,
                         Lr_DetalleAsieCont.Tipo_Cambio,    Lr_DetalleAsieCont.Centro_Costo, Lr_DetalleAsieCont.Monto_Dol,
                         Lr_DetalleAsieCont.Codigo_Tercero, Lr_DetalleAsieCont.Fecha);

      -- Actualiza no_asiento para la linea del documento migrado procesado --
      UPDATE MIGRA_ARCKML
         SET IND_CON    = 'G',
             ANO        = Lr_DetalleAsieCont.Ano,
             MES        = Lr_DetalleAsieCont.Mes,
             NO_ASIENTO = Lr_DetalleAsieCont.No_Asiento
       WHERE ROWID = Lr_DetalleDocMigrado.ROWID;
    END LOOP; -- Fin detalle documento

    -- Actualiza datos del encabezado del asiento generado
    UPDATE ARCGAE
       SET T_DEBITOS      = Lr_AsientoContable.t_Debitos,
           T_CREDITOS     = Lr_AsientoContable.t_Creditos,
           T_CAMB_C_V     = 'V',
           NO_COMPROBANTE = 0
     WHERE NO_CIA     = Lr_AsientoContable.No_Cia
       AND NO_ASIENTO = Lr_AsientoContable.No_Asiento;


  END LOOP; -- Fin documento migrado

  -- SE RETORNA NUMERO DE ASIENTO CONTABLE
  Pn_NoAsiento := Lr_AsientoContable.No_Asiento;

EXCEPTION
  WHEN Le_ErrorProceso THEN
    Pv_MensajeError := 'ERROR: '||Pv_MensajeError;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH', 
                                         'CK_GENERA_CONTABLE_SIN_SOPORTE', 
                                         'Le_ErrorProceso en CK_GENERA_CONTABLE_SIN_SOPORTE: '|| Pv_MensajeError ||' '||SQLERRM, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         '127.0.0.1'));
 WHEN TRANSA_ID.error THEN
    Pv_MensajeError := transa_id.ultimo_error;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH', 
                                         'CK_GENERA_CONTABLE_SIN_SOPORTE', 
                                         'TRANSA_ID.error en CK_GENERA_CONTABLE_SIN_SOPORTE: '|| Pv_MensajeError ||' '||SQLERRM, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         '127.0.0.1'));
 WHEN OTHERS THEN
    Pv_MensajeError := 'ERROR en CK_GENERA_CONTABLE_SIN_SOPORTE : '||SQLERRM;
    DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('SARH', 
                                         'CK_GENERA_CONTABLE_SIN_SOPORTE', 
                                         'CK_GENERA_CONTABLE_SIN_SOPORTE: '|| Pv_MensajeError ||' '||SQLERRM, 
                                         NVL(SYS_CONTEXT('USERENV','HOST'), USER), 
                                         SYSDATE, 
                                         NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'), 
                                         '127.0.0.1'));
END CK_GENERA_CONTABLE_SIN_SOPORTE;
/