SET DEFINE OFF;
CREATE OR REPLACE PACKAGE DB_EXTERNO.EXKG_MD_CONSULTS AS

  /**
   * Documentación para el procedimiento 'P_OBTIENE_PROMOCIONES'.
   *
   * Proceso encargado de obtener todas las promociones en estado Pendiente.
   *
   * Costo Query Pr_Promociones : 10
   * Costo Query C_Parametros   : 4
   *
   * @Param Pv_FechaInicio   IN  VARCHAR2      : Fecha Inicio de consulta de las promociones (RRRR-MM-DD).
   * @Param Pv_FechaFin      IN  VARCHAR2      : Fecha Fin de consulta de las promociones (RRRR-MM-DD).
   * @Param Pv_TipoPromocion IN  VARCHAR2      : Tipo de promoción a consultar.
   * @Param Pv_TipoProceso   IN  VARCHAR2      : Tipo de proceso a consultar.
   * @Param Pv_LoginPunto    IN  VARCHAR2      : Login del punto a consultar.
   * @Param Pr_Promociones   OUT SYS_REFCURSOR : Retorna un record de toda las promociones en estado Pendiente.
   * @Param Pv_Mensaje       OUT VARCHAR2      : Mensaje de error en caso de existir.
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.0 16-09-2019
   *
   * @author Germán Valenzuela <gvalenzuela@telconet.ec>
   * @version 1.1 12-11-2019 - Se agrega el cursor 'C_Parametros' para obtener la cantidad de días permitidos
   *                           para consultar los procesos de promoción.
   */
  PROCEDURE P_OBTIENE_PROMOCIONES(Pv_FechaInicio   IN  VARCHAR2,
                                  Pv_FechaFin      IN  VARCHAR2,
                                  Pv_TipoPromocion IN  VARCHAR2,
                                  Pv_TipoProceso   IN  VARCHAR2,
                                  Pv_LoginPunto    IN  VARCHAR2,
                                  Pr_Promociones   OUT SYS_REFCURSOR,
                                  Pv_Mensaje       OUT VARCHAR2);

END EXKG_MD_CONSULTS;
/
CREATE OR REPLACE PACKAGE BODY DB_EXTERNO.EXKG_MD_CONSULTS AS

  PROCEDURE P_OBTIENE_PROMOCIONES(Pv_FechaInicio   IN  VARCHAR2,
                                  Pv_FechaFin      IN  VARCHAR2,
                                  Pv_TipoPromocion IN  VARCHAR2,
                                  Pv_TipoProceso   IN  VARCHAR2,
                                  Pv_LoginPunto    IN  VARCHAR2,
                                  Pr_Promociones   OUT SYS_REFCURSOR,
                                  Pv_Mensaje       OUT VARCHAR2) IS

    CURSOR C_Parametros(Cv_NombreParametro VARCHAR2,
                        Cv_Valor1          VARCHAR2,
                        Cv_EstadoCab       VARCHAR2,
                        Cv_EstadoDet       VARCHAR2)
    IS
      SELECT APDET.*
        FROM DB_GENERAL.ADMI_PARAMETRO_CAB APCAB,
             DB_GENERAL.ADMI_PARAMETRO_DET APDET
      WHERE APCAB.ID_PARAMETRO     = APDET.PARAMETRO_ID
        AND APCAB.NOMBRE_PARAMETRO = Cv_NombreParametro
        AND APDET.VALOR1           = Cv_Valor1
        AND APCAB.ESTADO           = Cv_EstadoCab
        AND APDET.ESTADO           = Cv_EstadoDet;

    --Variables Locales
    Ld_FechaInicio     DATE;
    Ld_FechaFin        DATE;
    Lv_Error           VARCHAR2(4000);
    Lv_FechaActual     VARCHAR2(10) := TO_CHAR(SYSDATE,'RRRR-MM-DD');
    Ld_FechaActual     DATE         := TO_DATE(Lv_FechaActual,'RRRR-MM-DD');
    Le_MyException     EXCEPTION;
    Lc_Parametros      C_Parametros%ROWTYPE;
    Ln_DiasPermitidos  NUMBER := 4; --días por defecto

  BEGIN

    IF C_Parametros%ISOPEN THEN
      CLOSE C_Parametros;
    END IF;

    IF Pr_Promociones%ISOPEN THEN
      CLOSE Pr_Promociones;
    END IF;

    --Cursor que obtiene los días permitidos de consulta para los procesos de promoción.
    OPEN C_Parametros('DIAS_CONSULTA_PROCESOS_PROMOCION','DIAS_PERMITIDOS','Activo','Activo');
      FETCH C_Parametros INTO Lc_Parametros;
    CLOSE C_Parametros;

    IF Lc_Parametros.VALOR2 IS NOT NULL THEN
      Ln_DiasPermitidos := COALESCE(TO_NUMBER(REGEXP_SUBSTR(Lc_Parametros.VALOR2,'^\d+')),Ln_DiasPermitidos);
    END IF;

    IF Pv_FechaInicio IS NULL OR Pv_FechaFin IS NULL OR Pv_TipoPromocion IS NULL OR Pv_TipoProceso IS NULL THEN
      Lv_Error := 'Todos los parámetros de entrada deben ser obligatorios '
          ||'(Pv_FechaInicio,Pv_FechaFin,Pv_TipoPromocion,Pv_TipoProceso)';
      RAISE Le_MyException;
    END IF;

    BEGIN
      SELECT TO_DATE(Pv_FechaInicio,'RRRR-MM-DD') INTO Ld_FechaInicio FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        Lv_Error := 'Error en el formato de Fecha Inicio. Formato esperado (YYYY-MM-DD)';
        RAISE Le_MyException;
    END;

    BEGIN
      SELECT TO_DATE(Pv_FechaFin,'RRRR-MM-DD') INTO Ld_FechaFin FROM DUAL;
    EXCEPTION
      WHEN OTHERS THEN
        Lv_Error := 'Error en el formato de Fecha Fin. Formato esperado (YYYY-MM-DD)';
        RAISE Le_MyException;
    END;

    IF Ld_FechaInicio > Ld_FechaFin THEN
      Lv_Error := 'La Fecha Inicio no puede ser mayor a la Fecha Fin.';
      RAISE Le_MyException;
    END IF;

    IF Ld_FechaFin <> Ld_FechaActual THEN
      Lv_Error := 'La Fecha Fin debe ser igual a la Fecha Actual: '||
                  'Fecha Fin: '||Pv_FechaFin||', Fecha Actual: '||Lv_FechaActual;
      RAISE Le_MyException;
    END IF;

    IF Ld_FechaInicio < (Ld_FechaActual - Ln_DiasPermitidos)THEN
      Lv_Error := 'La Fecha Inicio debe ser como máximo '||Ln_DiasPermitidos||' día(s) antes de la Fecha Actual.';
      RAISE Le_MyException;
    END IF;

    OPEN Pr_Promociones FOR
      SELECT IPP.ID_PROCESO_PROMO,
             TO_CHAR(IPP.FE_INI_MAPEO,'RRRR-MM-DD') AS FE_INI_MAPEO,
             TO_CHAR(IPP.FE_FIN_MAPEO,'RRRR-MM-DD') AS FE_FIN_MAPEO,
             IPP.LOGIN_PUNTO,
             IPP.ESTADO_SERVICIO,
             IPP.SERIE,
             IPP.MAC,
             IPP.NOMBRE_OLT,
             IPP.PUERTO,
             IPP.SERVICE_PORT,
             IPP.ONT_ID,
             IPP.TRAFFIC_PROMO,
             IPP.GEMPORT_PROMO,
             IPP.LINE_PROFILE_PROMO,
             IPP.NUM_IPS_FIJAS,
             CAPACIDAD_UP_PROMO,
             IPP.CAPACIDAD_DOWN_PROMO,
             IPP.TIPO_NEGOCIO,
             IPP.TRAFFIC_ORIGIN,
             IPP.GEMPORT_ORIGIN,
             IPP.LINE_PROFILE_ORIGIN,
             IPP.VLAN_ORIGIN,
             IPP.SERVICE_PROFILE,
             CAPACIDAD_UP_ORIGIN,
             IPP.CAPACIDAD_DOWN_ORIGIN,
             IPP.TIPO_PROCESO
          FROM DB_EXTERNO.INFO_PROCESO_PROMO IPP
      WHERE IPP.ESTADO             = 'Pendiente'
        AND UPPER(TIPO_PROMO)      =  UPPER(Pv_TipoPromocion)
        AND UPPER(TIPO_PROCESO)    =  UPPER(Pv_TipoProceso)
        AND UPPER(IPP.LOGIN_PUNTO) =  NVL(UPPER(Pv_LoginPunto),UPPER(IPP.LOGIN_PUNTO))
        AND TO_CHAR(IPP.FE_INI_MAPEO,'RRRR-MM-DD') >= Pv_FechaInicio
        AND TO_CHAR(IPP.FE_INI_MAPEO,'RRRR-MM-DD') <= Pv_FechaFin
      ORDER BY UPPER(TRIM(IPP.NOMBRE_OLT)) ASC;

  EXCEPTION
    WHEN Le_MyException THEN
      Pv_Mensaje := Lv_Error;
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('EXKG_MD_CONSULTS',
                                           'P_OBTIENE_PROMOCIONES',
                                            Lv_Error,
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
    WHEN OTHERS THEN
      Pv_Mensaje := 'Error al devolver los datos';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('EXKG_MD_CONSULTS',
                                           'P_OBTIENE_PROMOCIONES',
                                            SQLCODE||' - ERROR_STACK:'||
                                              DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ERROR_BACKTRACE: '||
                                              DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                                           'telcos_promo_bw',
                                            SYSDATE,
                                            NVL(SYS_CONTEXT('USERENV','IP_ADDRESS'),'127.0.0.1'));
  END P_OBTIENE_PROMOCIONES;

END EXKG_MD_CONSULTS;
/
