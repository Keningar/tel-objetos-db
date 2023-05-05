CREATE OR REPLACE PACKAGE            AFK_CONSULTA_EMPLEADO AS

  /**
  * Documentaci¿n para el paquete 'FK_CONSULTA_EMPLEADO'
  * Paquete que contiene procedimientos para consultar informacion.
  *
  * @author Jorge Luis Veliz <jlveliz@telconet.ec>
  * @version 1.0 06-03-2022
  */
  /**
  * Documentaci¿n para el procedimiento 'P_CONTROL_CUSTODIO'.
  * Procedimiento que retorna informaci¿n del rol de pago de acuerdo a parametros proporcionados.
  *
  * @author Jorge Luis Veliz <jlveliz@telconet.ec>
  * @version 1.0 06-03-2022
  *
  * @author Byron Ant¿n <banton@telconet.ec>
  * @version 1.1 09-05-2022
  * Se ajusta respuesta de salida de funcion
  *
  */
  FUNCTION F_ROL_PAGO(PV_CEDULA      IN VARCHAR2,
                      PV_NOCIA       IN VARCHAR2,
                      PV_CODPLANILLA IN VARCHAR2,
                      PN_ANIO        IN NUMBER,
                      PN_INI_MES     IN NUMBER,
                      PN_FIN_MES     IN NUMBER) RETURN CLOB;

END AFK_CONSULTA_EMPLEADO;
/


CREATE OR REPLACE PACKAGE body            AFK_CONSULTA_EMPLEADO IS
  /**
  * Documentaci¿n para el paquete 'FK_CONSULTA_EMPLEADO'
  * Paquete que contiene procedimientos para consultar informacion.
  *
  * @author Jorge Luis Veliz <jlveliz@telconet.ec>
  * @version 1.0 06-03-2022
  */
  /**
  * Documentaci¿n para el procedimiento 'FK_CONSULTA_EMPLEADO'.
  * Procedimiento que retorna informaci¿n del rol de pago de acuerdo a parametros proporcionados.
  *
  * @author Jorge Luis Veliz <jlveliz@telconet.ec>
  * @version 1.0 06-03-2022
  *
  * @author Byron Ant¿n <banton@telconet.ec>
  * @version 1.1 09-05-2022
  * Se ajusta respuesta de salida de funcion
  *
  */
  FUNCTION F_ROL_PAGO(PV_CEDULA      IN VARCHAR2,
                      PV_NOCIA       IN VARCHAR2,
                      PV_CODPLANILLA IN VARCHAR2,
                      PN_ANIO        IN NUMBER,
                      PN_INI_MES     IN NUMBER,
                      PN_FIN_MES     IN NUMBER) RETURN CLOB IS
    -- Cursor de obtener plantilla
    CURSOR C_GET_PLANTILLA(CV_NOCIA VARCHAR2, CV_CODPLANILLA VARCHAR2) IS
      SELECT NO_CIA, CODPLA, DESCRI, F_DESDE, F_HASTA
        FROM NAF47_TNET.ARPLCP
       WHERE NO_CIA = CV_NOCIA
         AND CODPLA = CV_CODPLANILLA;
    -- OBTENER EMPLEADO
    CURSOR C_GET_DATA_EMPLEADO(CV_NOCIA       VARCHAR2,
                               CV_CODPLANILLA VARCHAR2,
                               CV_CEDULA      VARCHAR2,
                               CN_ANIO        NUMBER,
                               -- CN_NUM_EMPLEADO   NUMBER, --TODO: PUEDE SER LA CEDULA DEL PEMPLEADO O EL CODIGO DEL EMPLEADO
                               CN_INI_MES NUMBER,
                               CN_FIN_MES NUMBER) IS
      SELECT DISTINCT b.mes,
                      E.CEDULA,
                      E.NO_CIA,
                      E.NO_EMPLE,
                      E.NOMBRE,
                      E.F_INGRESO,
                      E.SAL_BAS,
                      E.PUESTO
        FROM NAF47_TNET.ARPLME E, NAF47_TNET.ARPLHS b
       WHERE e.no_cia = CV_NOCIA
         AND e.no_cia = b.no_cia
         AND e.no_emple = b.no_emple
         AND b.cod_pla = CV_CODPLANILLA
         AND e.CEDULA = CV_CEDULA
         AND b.ano = CN_ANIO
         AND b.mes BETWEEN to_number(CN_INI_MES) AND to_number(CN_FIN_MES)
       ORDER BY b.mes;
    -- INGRESOS
    CURSOR C_GET_INGRESO_EMPLEADO(CV_NOCIA       VARCHAR2,
                                  CV_CODPLANILLA VARCHAR2,
                                  CN_ANIO        NUMBER,
                                  CN_MES         NUMBER,
                                  CN_CODEMPLE    NUMBER) IS
      SELECT DISTINCT ARPLHS.MES,
                      ARPLHS.NO_CIA,
                      ARPLHS.NO_EMPLE,
                      ARPLHS.CANTIDAD,
                      ARPLHS.MONTO,
                      ARPLMI.DESCRI
        FROM NAF47_TNET.ARPLHS, NAF47_TNET.ARPLMI
       WHERE ARPLHS.NO_CIA = CV_NOCIA
         AND ARPLHS.COD_PLA = CV_CODPLANILLA
         AND ARPLHS.ANO = CN_ANIO
         AND ARPLHS.TIPO_M = 'I'
         AND ARPLHS.NO_CIA = ARPLMI.NO_CIA
         AND ARPLHS.CODIGO = ARPLMI.NO_INGRE
         AND MES = CN_MES
         AND NO_EMPLE = CN_CODEMPLE;
    -- DEDUCIBLES
    CURSOR C_GET_DEDUCIBLES_EMPLEADO(CV_NOCIA       VARCHAR2,
                                     CV_CODPLANILLA VARCHAR2,
                                     CN_ANIO        NUMBER,
                                     CN_MES         NUMBER,
                                     CN_CODEMPLE    NUMBER) IS
      SELECT DISTINCT ARPLHS.MES,
                      ARPLHS.NO_CIA,
                      ARPLHS.NO_EMPLE,
                      ARPLHS.cantidad,
                      ARPLHS.MONTO,
                      ARPLMD.DESCRI,
                      ARPLHS.NO_OPERA
        FROM NAF47_TNET.ARPLHS, NAF47_TNET.ARPLMD
       WHERE ARPLHS.NO_CIA = CV_NOCIA
         AND ARPLHS.COD_PLA = CV_CODPLANILLA
         AND ARPLHS.ANO = CN_ANIO
         AND ARPLHS.TIPO_M = 'D'
         AND ARPLHS.NO_CIA = ARPLMD.NO_CIA
         AND ARPLHS.CODIGO = ARPLMD.NO_DEDU
         AND ARPLMD.SOLO_CIA = 'N'
         AND MES = CN_MES
         AND NO_EMPLE = CN_CODEMPLE;
    -- PROVISIONES
    CURSOR C_GET_PROVISIONES_EMPLEADO(CV_NOCIA       VARCHAR2,
                                      CV_CODPLANILLA VARCHAR2,
                                      CN_ANIO        NUMBER,
                                      CN_MES         NUMBER,
                                      CN_CODEMPLE    NUMBER) IS
      SELECT DISTINCT a.mes,
                      a.no_cia,
                      a.no_emple,
                      a.codigo,
                      b.descri,
                      a.monto
        FROM NAF47_TNET.arplhs a, NAF47_TNET.arplmd b
       WHERE a.solo_cia = 'S'
         AND a.no_cia = CV_NOCIA
         AND a.cod_pla = CV_CODPLANILLA
         AND a.codigo = b.no_dedu
         AND a.no_cia = b.no_cia
         AND a.ANO = CN_ANIO
         AND a.TIPO_M = 'D'
         AND a.NO_EMPLE = CN_CODEMPLE
         AND a.mes = CN_MES
       ORDER BY a.codigo;
    LV_CEDULA       VARCHAR2(10);
    LV_COD_CIA      VARCHAR2(2);
    LN_ANO          NUMBER;
    LN_INI_MES      NUMBER;
    LN_FIN_MES      NUMBER;
    LV_COD_PLANILLA VARCHAR2(4) := '';
    LV_IP_CREACION  VARCHAR2(100) := '127.0.1.1';
    LN_COD_EMPLE    VARCHAR2(4);
    --NUMERO DE INGRESOS
    TYPE ARR_NUM_INGRESOS_EMPLEADO IS TABLE OF C_GET_INGRESO_EMPLEADO%ROWTYPE INDEX BY BINARY_INTEGER;
    LT_NUM_INGRESOS_EMPLEADO  ARR_NUM_INGRESOS_EMPLEADO;
    LN_TOTAL_INGRESOS         NUMBER;
    LR_C_GET_INGRESO_EMPLEADO C_GET_INGRESO_EMPLEADO%ROWTYPE;
    LN_SUM_TOTAL_INGRESOS     FLOAT := 0;
    --NUMERO DE DEDUCIBLES
    TYPE ARR_NUM_DEDUCIBLES_EMPLEADO IS TABLE OF C_GET_DEDUCIBLES_EMPLEADO%ROWTYPE INDEX BY BINARY_INTEGER;
    LT_NUM_DEDUCIBLES_EMPLEADO   ARR_NUM_DEDUCIBLES_EMPLEADO;
    LN_TOTAL_DEDUCIBLES          NUMBER;
    LR_C_GET_DEDUCIBLES_EMPLEADO C_GET_DEDUCIBLES_EMPLEADO%ROWTYPE;
    LN_SUM_TOTAL_DEDUCIBLES      FLOAT := 0;
  
    --NUMERO DE PROVISIONES
    TYPE ARR_NUM_PROVISIONES_EMPLEADO IS TABLE OF C_GET_PROVISIONES_EMPLEADO%ROWTYPE INDEX BY BINARY_INTEGER;
    LT_NUM_PROVISIONES_EMPLEADO   ARR_NUM_PROVISIONES_EMPLEADO;
    LN_TOTAL_PROVISIONES          NUMBER;
    LR_C_GET_PROVISIONES_EMPLEADO C_GET_PROVISIONES_EMPLEADO%ROWTYPE;
    LN_SUM_TOTAL_PROVISIONES      FLOAT := 0;
  
    LR_C_GET_PLANTILLA C_GET_PLANTILLA%ROWTYPE;
    LR_C_GET_EMPLEADO  C_GET_DATA_EMPLEADO%rowtype;
    LV_JSON            CLOB := NULL;
    LV_STATUS_ERROR    VARCHAR2(50) := 'EXITO';
    LV_MENSAJE_ERROR   VARCHAR2(32767) := 'Se consult¿ la informaci¿n, correctamente.';
    LV_DESCRI_PLANILLA VARCHAR2(60) := '';
  
  BEGIN
    -- LN_COD_EMPLE  := PV_CEDULA;
    LV_CEDULA       := PV_CEDULA;
    LV_COD_CIA      := PV_NOCIA;
    LV_COD_PLANILLA := PV_CODPLANILLA;
    LN_ANO          := PN_ANIO;
    LN_INI_MES      := PN_INI_MES;
    LN_FIN_MES      := PN_FIN_MES;
    LV_STATUS_ERROR := '';
  
    -- CONSULTA LA EL TIPO DE LA PLANILLA
    IF C_GET_PLANTILLA%ISOPEN THEN
      CLOSE C_GET_PLANTILLA;
    END IF;
    OPEN C_GET_PLANTILLA(LV_COD_CIA, LV_COD_PLANILLA);
    FETCH C_GET_PLANTILLA
      INTO LR_C_GET_PLANTILLA;
  
    -- TERMINA CONSULTA TIPO DE PLANILLA
  
    IF LR_C_GET_PLANTILLA.CODPLA IS NULL THEN
      LV_STATUS_ERROR  := '404';
      LV_MENSAJE_ERROR := 'Codigo de planilla invalido';
      LV_JSON          := '{"status":"' || LV_STATUS_ERROR ||
                          '","mensaje":"' || LV_MENSAJE_ERROR || '"}';
      RETURN LV_JSON;
    END IF;
    LV_DESCRI_PLANILLA := LR_C_GET_PLANTILLA.DESCRI;
    CLOSE C_GET_PLANTILLA;
  
    LV_JSON := '{"data":[';
    -- VERIFICO SI EL MES  INICIO O DESDE ES MENOR O IGUAL AL MES HASTA
    IF LN_INI_MES <= LN_FIN_MES THEN
      FOR IDX IN LN_INI_MES .. LN_FIN_MES LOOP
        --Abro los datos del empleado
      
        OPEN C_GET_DATA_EMPLEADO(LV_COD_CIA,
                                 LV_COD_PLANILLA,
                                 LV_CEDULA,
                                 LN_ANO,
                                 IDX,
                                 IDX);
        LOOP
          FETCH C_GET_DATA_EMPLEADO
            INTO LR_C_GET_EMPLEADO;
          -- no existen datos
          IF LR_C_GET_EMPLEADO.NO_EMPLE IS NULL THEN
            LV_STATUS_ERROR  := '404';
            LV_MENSAJE_ERROR := 'No existe rol asociado';
            LV_JSON          := '{"status":"' || LV_STATUS_ERROR ||
                                '","mensaje":"' || LV_MENSAJE_ERROR || '"}';
            RETURN LV_JSON;
          END IF;
        
          EXIT WHEN C_GET_DATA_EMPLEADO%NOTFOUND;
        
          -- PONEMOS DATOS DE EMPLEADO
          LV_JSON := LV_JSON || '{';
          LV_JSON := LV_JSON || '"TIPO_NOMINA": "' || LV_COD_PLANILLA ||
                     ' - ' || LV_DESCRI_PLANILLA || '",';
          LV_JSON := LV_JSON || '"CEDULA": "' || LR_C_GET_EMPLEADO.CEDULA || '",';
          LV_JSON := LV_JSON || '"COD_EMPLEADO": "' ||
                     LR_C_GET_EMPLEADO.NO_EMPLE || '",';
          LV_JSON := LV_JSON || '"NOMBRE_EMPLEADO":"' ||
                     LR_C_GET_EMPLEADO.NOMBRE || '",';
          LV_JSON := LV_JSON || '"PUESTO":"' || LR_C_GET_EMPLEADO.PUESTO || '",';
          LV_JSON := LV_JSON || '"FECHA_INGRESO":"' ||
                     LR_C_GET_EMPLEADO.F_INGRESO || '",';
          LV_JSON := LV_JSON || '"MES":"' || LR_C_GET_EMPLEADO.MES || '",';
          LV_JSON := LV_JSON || '"SAL_BASICO":"' ||
                     LR_C_GET_EMPLEADO.SAL_BAS || '",';
          LV_JSON := LV_JSON || '"INGRESOS":{"DETALLES":[';
        
          -- PONEMOS LOS INGRESOS
          OPEN C_GET_INGRESO_EMPLEADO(LV_COD_CIA,
                                      LV_COD_PLANILLA,
                                      LN_ANO,
                                      IDX,
                                      LR_C_GET_EMPLEADO.NO_EMPLE);
          FETCH C_GET_INGRESO_EMPLEADO BULK COLLECT
            INTO LT_NUM_INGRESOS_EMPLEADO;
          LN_TOTAL_INGRESOS := LT_NUM_INGRESOS_EMPLEADO.COUNT;
          CLOSE C_GET_INGRESO_EMPLEADO;
          OPEN C_GET_INGRESO_EMPLEADO(LV_COD_CIA,
                                      LV_COD_PLANILLA,
                                      LN_ANO,
                                      IDX,
                                      LR_C_GET_EMPLEADO.NO_EMPLE);
          LN_SUM_TOTAL_INGRESOS := 0;
          LOOP
            FETCH C_GET_INGRESO_EMPLEADO
              INTO LR_C_GET_INGRESO_EMPLEADO;
            EXIT WHEN C_GET_INGRESO_EMPLEADO%NOTFOUND;
            LV_JSON               := LV_JSON || '{';
            LV_JSON               := LV_JSON || '"DESCRIPCION":"' ||
                                     LR_C_GET_INGRESO_EMPLEADO.DESCRI || '",';
            LV_JSON               := LV_JSON || '"CANTIDAD":"' ||
                                     LR_C_GET_INGRESO_EMPLEADO.CANTIDAD || '",';
            LV_JSON               := LV_JSON || '"MONTO":"' ||
                                     LR_C_GET_INGRESO_EMPLEADO.MONTO || '"';
            LV_JSON               := LV_JSON || '}';
            LN_SUM_TOTAL_INGRESOS := LN_SUM_TOTAL_INGRESOS +
                                     LR_C_GET_INGRESO_EMPLEADO.MONTO;
            IF C_GET_INGRESO_EMPLEADO%ROWCOUNT < LN_TOTAL_INGRESOS THEN
              LV_JSON := LV_JSON || ',';
            END IF;
          END LOOP;
          LV_JSON := LV_JSON || '], "TOTAL" : ' || LN_SUM_TOTAL_INGRESOS || '},';
        
          CLOSE C_GET_INGRESO_EMPLEADO;
          -- PONEMOS LOS INGRESOS
          -- PONEMOS LOS DEDUCIBLES
          LV_JSON := LV_JSON || '"DEDUCIBLES":{ "DETALLES": [';
          --CV_NOCIA VARCHAR2, CV_CODPLANILLA VARCHAR2, CN_ANIO NUMBER, CN_MES NUMBER, CN_CODEMPLE NUMBER
          OPEN C_GET_DEDUCIBLES_EMPLEADO(LV_COD_CIA,
                                         LV_COD_PLANILLA,
                                         LN_ANO,
                                         IDX,
                                         LR_C_GET_EMPLEADO.NO_EMPLE);
          FETCH C_GET_DEDUCIBLES_EMPLEADO BULK COLLECT
            INTO LT_NUM_DEDUCIBLES_EMPLEADO;
          LN_TOTAL_DEDUCIBLES := LT_NUM_DEDUCIBLES_EMPLEADO.COUNT;
          CLOSE C_GET_DEDUCIBLES_EMPLEADO;
          OPEN C_GET_DEDUCIBLES_EMPLEADO(LV_COD_CIA,
                                         LV_COD_PLANILLA,
                                         LN_ANO,
                                         IDX,
                                         LR_C_GET_EMPLEADO.NO_EMPLE);
          LN_SUM_TOTAL_DEDUCIBLES := 0;
          LOOP
            FETCH C_GET_DEDUCIBLES_EMPLEADO
              INTO LR_C_GET_DEDUCIBLES_EMPLEADO;
            EXIT WHEN C_GET_DEDUCIBLES_EMPLEADO%NOTFOUND;
            LV_JSON                 := LV_JSON || '{';
            LV_JSON                 := LV_JSON || '"DESCRIPCION":"' ||
                                       LR_C_GET_DEDUCIBLES_EMPLEADO.DESCRI || '",';
            LV_JSON                 := LV_JSON || '"CANTIDAD":"' ||
                                       LR_C_GET_DEDUCIBLES_EMPLEADO.CANTIDAD || '",';
            LV_JSON                 := LV_JSON || '"MONTO":"' ||
                                       LR_C_GET_DEDUCIBLES_EMPLEADO.MONTO || '"';
            LV_JSON                 := LV_JSON || '}';
            LN_SUM_TOTAL_DEDUCIBLES := LN_SUM_TOTAL_DEDUCIBLES +
                                       LR_C_GET_DEDUCIBLES_EMPLEADO.MONTO;
          
            IF C_GET_DEDUCIBLES_EMPLEADO%ROWCOUNT < LN_TOTAL_DEDUCIBLES THEN
              LV_JSON := LV_JSON || ',';
            END IF;
          END LOOP;
          CLOSE C_GET_DEDUCIBLES_EMPLEADO;
          LV_JSON := LV_JSON || '],"TOTAL" : ' || LN_SUM_TOTAL_DEDUCIBLES || '},';
          -- FIN PONEMOS LOS DEDUCIBLES
          -- PONEMOS LAS PROVISIONES
          LV_JSON := LV_JSON || '"PROVISIONES":{"DETALLES": [';
          --CV_NOCIA VARCHAR2, CV_CODPLANILLA VARCHAR2, CN_ANIO NUMBER, CN_MES NUMBER, CN_CODEMPLE NUMBER
          OPEN C_GET_PROVISIONES_EMPLEADO(LV_COD_CIA,
                                          LV_COD_PLANILLA,
                                          LN_ANO,
                                          IDX,
                                          LR_C_GET_EMPLEADO.NO_EMPLE);
          FETCH C_GET_PROVISIONES_EMPLEADO BULK COLLECT
            INTO LT_NUM_PROVISIONES_EMPLEADO;
          LN_TOTAL_PROVISIONES := LT_NUM_PROVISIONES_EMPLEADO.COUNT;
          CLOSE C_GET_PROVISIONES_EMPLEADO;
          OPEN C_GET_PROVISIONES_EMPLEADO(LV_COD_CIA,
                                          LV_COD_PLANILLA,
                                          LN_ANO,
                                          IDX,
                                          LR_C_GET_EMPLEADO.NO_EMPLE);
          LN_SUM_TOTAL_PROVISIONES := 0;
          LOOP
            FETCH C_GET_PROVISIONES_EMPLEADO
              INTO LR_C_GET_PROVISIONES_EMPLEADO;
            EXIT WHEN C_GET_PROVISIONES_EMPLEADO%NOTFOUND;
            LV_JSON                  := LV_JSON || '{';
            LV_JSON                  := LV_JSON || '"CODIGO":"' ||
                                        LR_C_GET_PROVISIONES_EMPLEADO.CODIGO || '",';
            LV_JSON                  := LV_JSON || '"DESCRIPCION":"' ||
                                        LR_C_GET_PROVISIONES_EMPLEADO.DESCRI || '",';
            LV_JSON                  := LV_JSON || '"MONTO":"' ||
                                        LR_C_GET_PROVISIONES_EMPLEADO.MONTO || '"';
            LV_JSON                  := LV_JSON || '}';
            LN_SUM_TOTAL_PROVISIONES := LN_SUM_TOTAL_PROVISIONES +
                                        LR_C_GET_PROVISIONES_EMPLEADO.MONTO;
          
            IF C_GET_PROVISIONES_EMPLEADO%ROWCOUNT < LN_TOTAL_PROVISIONES THEN
              LV_JSON := LV_JSON || ',';
            END IF;
          END LOOP;
          CLOSE C_GET_PROVISIONES_EMPLEADO;
          LV_JSON := LV_JSON || '], "TOTAL": ' || LN_SUM_TOTAL_PROVISIONES || '}';
          LV_JSON := LV_JSON || '}'; --fin de cada rol
          IF IDX < LN_FIN_MES THEN
            LV_JSON := LV_JSON || ',';
          END IF;
        END LOOP;
        CLOSE C_GET_DATA_EMPLEADO;
      END LOOP;
    END IF;
  
    LV_JSON := LV_JSON || CHR(10) ||
               '], "status": "200", "mensaje" : "DATOS PROCESADOS CORRECTAMENTE"}';
    RETURN LV_JSON;
  EXCEPTION
    WHEN OTHERS THEN
      LV_STATUS_ERROR  := '404';
      LV_MENSAJE_ERROR := 'Ha ocurrido un error, revisar log';
      DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                           'NAF47_TNET.AFKG_CONSULTA_EMPLEADO',
                                           SQLERRM,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'HOST'),
                                               'NAF'),
                                           SYSDATE,
                                           NVL(SYS_CONTEXT('USERENV',
                                                           'IP_ADDRESS'),
                                               '127.0.0.1'));
      LV_JSON := '{"status":"' || LV_STATUS_ERROR || '","mensaje":"' ||
                 LV_MENSAJE_ERROR || '"}';
      RETURN LV_JSON;
  END F_ROL_PAGO;

END AFK_CONSULTA_EMPLEADO;
/
