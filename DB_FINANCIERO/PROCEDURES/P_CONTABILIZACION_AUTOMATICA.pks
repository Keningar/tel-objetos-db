CREATE OR REPLACE procedure DB_FINANCIERO.P_CONTABILIZACION_AUTOMATICA ( Pd_FechaProceso IN DATE,
                                                                         Pv_Proceso      IN VARCHAR2,
                                                                         Pv_NoCia        IN VARCHAR2) is
/**
* Documentacion para procedimiento P_CONTABILIZACION_AUTOMATICA
* Proceso que genera migración de detalle contable al sistema NAF en background
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.0 13-09-2018
*
* @author Luis Lindao <llindao@telconet.ec>
* @version 1.1 27-09-2018 - Se modifica para considerar proceso contabilziacion individual retenciones megadatos
*
* @Param Pd_FechaProceso IN DATE  Recibe fecha que se va a procesar
* @Param Pv_Proceso      IN DATE  Recibe tipo de proceso a ejecutar [FACTURACION][PAGOS][TODOS]
* @Param Pd_NoCia        IN DATE  Recibe Código de compania a procesar
*/

  --
  CURSOR C_PREFIJO IS
    SELECT IEG.PREFIJO
    FROM DB_GENERAL.INFO_EMPRESA_GRUPO IEG
    WHERE IEG.COD_EMPRESA = Pv_NoCia;
  --
  TYPE TypeEmpresa IS RECORD
  (TELCONET  VARCHAR2(2) := 'TN',
   MEGADATOS VARCHAR2(2) := 'MD',
   ECUANET VARCHAR2(2) := 'EN');
  --
  TYPE TypeProceso IS RECORD
  (TODOS                VARCHAR2(20) := 'TODOS',
   PAGOS                VARCHAR2(20) := 'PAGOS',
   FACTURACION          VARCHAR2(20) := 'FACTURACION',
   RETENCIONES          VARCHAR2(20) := 'RETENCIONES',
   RECAUDACIONES        VARCHAR2(20) := 'RECAUDACIONES',
   DEBITOS              VARCHAR2(20) := 'DEBITOS_MASIVOS',
   NOTAS_DEBITOS        VARCHAR2(20) := 'NOTAS_DEBITOS',
   FACTURAS             VARCHAR2(20) := 'FACTURAS',
   ANULA_FACTURA        VARCHAR2(20) := 'ANULA_FACTURA',
   NOTAS_CREDITOS       VARCHAR2(20) := 'NOTAS_CREDITOS',
   ANULA_NOTAS_CREDITOS VARCHAR2(20) := 'ANULA_NOTAS_CREDITOS'
   );
  --
  TYPE TypeParfacturacion IS RECORD
  (ID_EMPRESA     DB_GENERAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE,
   PREFIJO        DB_GENERAL.INFO_EMPRESA_GRUPO.PREFIJO%TYPE,
   TIPO_DOCUMENTO DB_FINANCIERO.ADMI_TIPO_DOCUMENTO_FINANCIERO.CODIGO_TIPO_DOCUMENTO%TYPE,
   TIPO_PROCESO   VARCHAR2(30),
   ID_DOCUMENTO   DB_FINANCIERO.INFO_DOCUMENTO_FINANCIERO_CAB.ID_DOCUMENTO%TYPE,
   FECHA_PROCESO  VARCHAR2(15));
  --
  Lr_Proceso        TypeProceso;
  Lr_ParFacturacion TypeParfacturacion;
  Lr_Empresa        TypeEmpresa;
  --
  Lv_NombreProceso  CONSTANT VARCHAR2(100) := 'DB_FINANCIERO.P_CONTABILIZACION_AUTOMATICA';
  Lv_NombreSistema  CONSTANT VARCHAR2(20) := 'JOB-Telcos+';
  --
  Lv_MensajeError   VARCHAR2(3000) := NULL;
  
  --
begin
  --
  --
  IF C_PREFIJO%ISOPEN THEN
    CLOSE C_PREFIJO;
  END IF;
  --
  OPEN C_PREFIJO;
  FETCH C_PREFIJO INTO Lr_ParFacturacion.PREFIJO;
  IF C_PREFIJO%NOTFOUND THEN
    Lr_ParFacturacion.PREFIJO := NULL;
  END IF;
  CLOSE C_PREFIJO;
  --
  --
  Lr_ParFacturacion.ID_EMPRESA := Pv_NoCia;
  Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'dd/mm/yyyy');
  
  IF Pv_Proceso in (Lr_Proceso.NOTAS_DEBITOS, Lr_Proceso.FACTURACION, Lr_Proceso.TODOS) THEN
    BEGIN
      --
      Lr_ParFacturacion.TIPO_DOCUMENTO := 'NDI';
      Lr_ParFacturacion.TIPO_PROCESO := 'MASIVO';
      Lr_ParFacturacion.ID_DOCUMENTO := NULL;
      Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'dd/mm/yyyy');
      --
      DB_FINANCIERO.FNKG_CONTABILIZAR_NDI.P_CONTABILIZAR( Lr_ParFacturacion.ID_EMPRESA,
                                                          Lr_ParFacturacion.PREFIJO,
                                                          Lr_ParFacturacion.TIPO_DOCUMENTO,
                                                          Lr_ParFacturacion.TIPO_PROCESO,
                                                          Lr_ParFacturacion.ID_DOCUMENTO,
                                                          Lr_ParFacturacion.FECHA_PROCESO);

    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                              Lv_NombreProceso,
                                              'Error al invocar a FNKG_CONTABILIZAR_NDI.P_CONTABILIZAR - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                               NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
    END;
  END IF;
  
  -- Proceso Migración detalle contable de pagos de retenciones
  IF Pv_Proceso IN (Lr_Proceso.RETENCIONES, Lr_Proceso.PAGOS, Lr_Proceso.TODOS) THEN
    --
    Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'DD/MM/YYYY');
    --
    IF Lr_ParFacturacion.PREFIJO = Lr_Empresa.TELCONET THEN
      BEGIN
        DB_FINANCIERO.FNKG_CONTABILIZAR_PAGOS_RET.PROCESAR_PAGO_RETENCIONESXDIA( Lr_ParFacturacion.ID_EMPRESA,
                                                                                 Lr_ParFacturacion.FECHA_PROCESO,
                                                                                 Lv_MensajeError);
      EXCEPTION
        WHEN OTHERS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                                Lv_NombreProceso,
                                                'Error al invocar a FNKG_CONTABILIZAR_PAGOS_RET.PROCESAR_PAGO_RETENCIONESXDIA - ERROR_STACK: '||
                                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                 NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                               SYSDATE,
                                                NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
      END;
      --
    ELSIF Lr_ParFacturacion.PREFIJO IN (Lr_Empresa.MEGADATOS, Lr_Empresa.ECUANET) THEN
      --
      BEGIN
        DB_FINANCIERO.FNKG_CONTABILIZAR_PAGOS_RET.P_CONTABILIZAR_INDIVIDUAL( Lr_ParFacturacion.ID_EMPRESA,
                                                                             Lr_ParFacturacion.FECHA_PROCESO,
                                                                             Lv_MensajeError);
      EXCEPTION
        WHEN OTHERS THEN
          DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                                Lv_NombreProceso,
                                                'Error al invocar a FNKG_CONTABILIZAR_PAGOS_RET.P_CONTABILIZAR_INDIVIDUAL - ERROR_STACK: '||
                                                DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                                 NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                               SYSDATE,
                                                NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
      END;
      --
    END IF;
  END IF;
  
  -- Proceso migración detalle contable Recaudaciones TN
  IF Pv_Proceso IN (Lr_Proceso.RECAUDACIONES, Lr_Proceso.PAGOS, Lr_Proceso.TODOS) AND Lr_ParFacturacion.PREFIJO = Lr_Empresa.TELCONET THEN
    BEGIN
      Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'DD/MM/YYYY');
      DB_FINANCIERO.FNKG_RECAUDACIONES.P_CONTABILIZAR( Pv_NoCia, 
                                                       Lr_ParFacturacion.FECHA_PROCESO,
                                                       Lv_MensajeError );
    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                              Lv_NombreProceso,
                                              'Error al invocar a FNKG_RECAUDACIONES.P_CONTABILIZAR - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                               NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
    END;
  END IF;
  
  -- Proceso migración detalle contable Recaudaciones MD
  IF Pv_Proceso IN (Lr_Proceso.RECAUDACIONES, Lr_Proceso.PAGOS, Lr_Proceso.TODOS) AND Lr_ParFacturacion.PREFIJO IN (Lr_Empresa.MEGADATOS, Lr_Empresa.ECUANET) THEN
    BEGIN
      Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'DD/MM/YYYY');
      DB_FINANCIERO.FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR ( Pv_NoCia, 
                                                                 Lr_ParFacturacion.FECHA_PROCESO,
                                                                 Lv_MensajeError );
    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                              Lv_NombreProceso,
                                              'Error al invocar a FNKG_PAGO_LINEA_RECAUDACION.P_CONTABILIZAR - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                               NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
    END;
  END IF;
  
  -- Proceso migración detalle contable Débitos Masivos MD
  IF Pv_Proceso IN (Lr_Proceso.DEBITOS, Lr_Proceso.PAGOS, Lr_Proceso.TODOS) AND Lr_ParFacturacion.PREFIJO IN (Lr_Empresa.MEGADATOS, Lr_Empresa.ECUANET) THEN
    BEGIN
      Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'DD/MM/YYYY');
      DB_FINANCIERO.FNKG_CONTABILIZAR_DEBITOS.P_DEBITOS_MASIVOS_MD ( Pv_NoCia, 
                                                                     Lr_ParFacturacion.FECHA_PROCESO,
                                                                     Lv_MensajeError);
    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                              Lv_NombreProceso,
                                              'Error al invocar a FNKG_CONTABILIZAR_DEBITOS.P_DEBITOS_MASIVOS_MD - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                               NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
    END;
  END IF;
  --
  -- Proceso migración FACTURAS
  IF Pv_Proceso IN (Lr_Proceso.FACTURAS, Lr_Proceso.FACTURACION, Lr_Proceso.TODOS) THEN
    BEGIN
      Lr_ParFacturacion.TIPO_DOCUMENTO := 'FAC';
      Lr_ParFacturacion.TIPO_PROCESO := 'MASIVO';
      Lr_ParFacturacion.ID_DOCUMENTO := NULL;
      Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'YYYY-MM-DD');
      --
      DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_CONTABILIZAR ( Lr_ParFacturacion.ID_EMPRESA,
                                                               Lr_ParFacturacion.PREFIJO,
                                                               Lr_ParFacturacion.TIPO_DOCUMENTO,
                                                               Lr_ParFacturacion.TIPO_PROCESO,
                                                               Lr_ParFacturacion.ID_DOCUMENTO,
                                                               Lr_ParFacturacion.FECHA_PROCESO,
                                                               Lv_MensajeError);
    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                              Lv_NombreProceso,
                                              'Error al invocar a FNKG_CONTABILIZAR_FACT_NC.P_CONTABILIZAR - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                               NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
    END;
  END IF;
  
  -- Proceso migración ANULACIONES FACTURAS
  IF Pv_Proceso in (Lr_Proceso.ANULA_FACTURA, Lr_Proceso.FACTURACION, Lr_Proceso.TODOS) THEN
    BEGIN
      --
      Lr_ParFacturacion.TIPO_DOCUMENTO := 'FAC';
      Lr_ParFacturacion.TIPO_PROCESO := 'ANULA-FAC';
      Lr_ParFacturacion.ID_DOCUMENTO := NULL;
      Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'YYYY-MM-DD');
      --
      DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_CONTABILIZAR ( Lr_ParFacturacion.ID_EMPRESA,
                                                               Lr_ParFacturacion.PREFIJO,
                                                               Lr_ParFacturacion.TIPO_DOCUMENTO,
                                                               Lr_ParFacturacion.TIPO_PROCESO,
                                                               Lr_ParFacturacion.ID_DOCUMENTO,
                                                               Lr_ParFacturacion.FECHA_PROCESO,
                                                               Lv_MensajeError);

    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                              Lv_NombreProceso,
                                              'Error al invocar a FNKG_CONTABILIZAR_NDI.P_CONTABILIZAR - ANULA-FAC - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                               NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
    END;
  END IF;
  
  -- Proceso migración NOTAS CREDITOS
  IF Pv_Proceso IN (Lr_Proceso.NOTAS_CREDITOS, Lr_Proceso.FACTURACION, Lr_Proceso.TODOS) THEN
    BEGIN
      Lr_ParFacturacion.TIPO_DOCUMENTO := 'NC';
      Lr_ParFacturacion.TIPO_PROCESO := 'MASIVO';
      Lr_ParFacturacion.ID_DOCUMENTO := NULL;
      Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'YYYY-MM-DD');
      --
      DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_CONTABILIZAR ( Lr_ParFacturacion.ID_EMPRESA,
                                                               Lr_ParFacturacion.PREFIJO,
                                                               Lr_ParFacturacion.TIPO_DOCUMENTO,
                                                               Lr_ParFacturacion.TIPO_PROCESO,
                                                               Lr_ParFacturacion.ID_DOCUMENTO,
                                                               Lr_ParFacturacion.FECHA_PROCESO,
                                                               Lv_MensajeError);
    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                              Lv_NombreProceso,
                                              'Error al invocar a FNKG_CONTABILIZAR_FACT_NC.P_CONTABILIZAR - NC - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                               NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
    END;
  END IF;
  
  -- Proceso migración ANULACIONES NOTAS CREDITOS
  IF Pv_Proceso in (Lr_Proceso.ANULA_NOTAS_CREDITOS, Lr_Proceso.FACTURACION, Lr_Proceso.TODOS) THEN
    BEGIN
      --
      Lr_ParFacturacion.TIPO_DOCUMENTO := 'NC';
      Lr_ParFacturacion.TIPO_PROCESO := 'ANULA-FAC';
      Lr_ParFacturacion.ID_DOCUMENTO := NULL;
      Lr_ParFacturacion.FECHA_PROCESO := TO_CHAR(Pd_FechaProceso, 'YYYY-MM-DD');
      --
      DB_FINANCIERO.FNKG_CONTABILIZAR_FACT_NC.P_CONTABILIZAR ( Lr_ParFacturacion.ID_EMPRESA,
                                                               Lr_ParFacturacion.PREFIJO,
                                                               Lr_ParFacturacion.TIPO_DOCUMENTO,
                                                               Lr_ParFacturacion.TIPO_PROCESO,
                                                               Lr_ParFacturacion.ID_DOCUMENTO,
                                                               Lr_ParFacturacion.FECHA_PROCESO,
                                                               Lv_MensajeError);

    EXCEPTION
      WHEN OTHERS THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR( Lv_NombreSistema,
                                              Lv_NombreProceso,
                                              'Error al invocar a FNKG_CONTABILIZAR_NDI.P_CONTABILIZAR - ANULA-NC - ERROR_STACK: '||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' ERROR_BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                               NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.HOST), 'DB_FINANCIERO'),
                                              SYSDATE,
                                              NVL(SYS_CONTEXT(FNKG_VAR.Gr_Sesion.USERENV,FNKG_VAR.Gr_Sesion.IP_ADRESS), '127.0.0.1'));
    END;
  END IF;

end P_CONTABILIZACION_AUTOMATICA;
/