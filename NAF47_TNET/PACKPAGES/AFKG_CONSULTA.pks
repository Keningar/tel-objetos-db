CREATE OR REPLACE PACKAGE NAF47_TNET.AFKG_CONSULTA AS 

    /**
      * Documentación para el paquete 'AFKG_CONSULTA'
      * Paquete que contiene procedimientos para consultar información.
      *
      * @author Kevin Baque Puya <kbaque@telconet.ec>
      * @version 1.0 11-11-2021
    */

    /**
      * Documentación para el procedimiento 'P_CONTROL_CUSTODIO'.
      * Procedimiento que retorna información del control custodio según los parámetros enviado.
      *
      * @author Kevin Baque Puya <kbaque@telconet.ec>
      * @version 1.0 11-11-2021
    */
    PROCEDURE P_CONTROL_CUSTODIO (
        PCL_EXTRA_PARAMS  IN   CLOB,
        PV_STATUS         OUT  VARCHAR2,
        PV_MENSAJE        OUT  VARCHAR2,
        PCL_RESULTADO     OUT  CLOB
    );

END AFKG_CONSULTA;
/

CREATE OR REPLACE PACKAGE BODY NAF47_TNET.AFKG_CONSULTA AS

    PROCEDURE P_CONTROL_CUSTODIO (
        PCL_EXTRA_PARAMS  IN   CLOB,
        PV_STATUS         OUT  VARCHAR2,
        PV_MENSAJE        OUT  VARCHAR2,
        PCL_RESULTADO     OUT  CLOB
    ) IS
        --Cursor para obtener información de la serie.
        CURSOR C_GET_SERIE (
            CV_SERIE           VARCHAR2,
            CN_COD_EMPRESA     NUMBER,
            CV_ESTADO_CUSTODIO VARCHAR2,
            CV_TIPO_CUSTODIO   VARCHAR2,
            CV_TIPO_ARTICULO   VARCHAR2
        ) IS
        SELECT
            CUSTODIO.*
        FROM
            NAF47_TNET.ARAF_CONTROL_CUSTODIO CUSTODIO
        WHERE
            CUSTODIO.ARTICULO_ID       = CV_SERIE
            AND CUSTODIO.ESTADO        = CV_ESTADO_CUSTODIO
            AND CUSTODIO.CANTIDAD      > 0
            AND CUSTODIO.TIPO_CUSTODIO = CV_TIPO_CUSTODIO
            AND CUSTODIO.TIPO_ARTICULO = CV_TIPO_ARTICULO
            AND CUSTODIO.EMPRESA_ID    = CN_COD_EMPRESA
        ORDER BY CUSTODIO.FE_CREACION DESC;
        --Cursor para obtener la foto del empleado
        CURSOR C_GET_FOTO_EMPLEADO (
            CV_ID_PERSONA_ROL VARCHAR2,
            CV_ESTADO        VARCHAR2,
            CN_COD_EMPRESA   NUMBER
        ) IS
        SELECT
            ARPLME.*
        FROM
            DB_COMERCIAL.INFO_PERSONA IPE
            JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
                ON IPER.PERSONA_ID = IPE.ID_PERSONA
            JOIN NAF47_TNET.ARPLME ARPLME
                ON ARPLME.CEDULA   = IPE.IDENTIFICACION_CLIENTE
                AND ARPLME.ESTADO  = CV_ESTADO
                AND ARPLME.NO_CIA  = CN_COD_EMPRESA
        WHERE
            IPER.ID_PERSONA_ROL = CV_ID_PERSONA_ROL;
        --Cursor para obtener información del empleado
        CURSOR C_GET_EMPLEADO (
            CV_EMPLE VARCHAR2
        ) IS
        SELECT
            NVEE.*
        FROM
            NAF47_TNET.V_EMPLEADOS_EMPRESAS NVEE
        WHERE
            NVEE.NO_EMPLE = CV_EMPLE;
        --Declaración de variables
        LR_VISTA_EMPLEADO       NAF47_TNET.V_EMPLEADOS_EMPRESAS%ROWTYPE;
        LR_EMPLEADO             NAF47_TNET.ARPLME%ROWTYPE;
        TYPE T_ARRAY_INFO_SERIE IS
            TABLE OF NAF47_TNET.ARAF_CONTROL_CUSTODIO%ROWTYPE INDEX BY BINARY_INTEGER;
        LT_INFO_SERIE           T_ARRAY_INFO_SERIE;
        LV_SERIE                VARCHAR(100);
        LV_ESTADO_CUSTODIO      VARCHAR(50);
        LV_TIPO_CUSTODIO        VARCHAR(50);
        LV_TIPO_ARTICULO        VARCHAR(50);
        LV_ESTADO_EMPLEADO      VARCHAR(50);
        LV_STATUS_ERROR         VARCHAR(50)    := 'EXITO';
        LV_IP_CREACION          VARCHAR2(100)  := '127.0.1.1';
        LV_MENSAJE_ERROR        VARCHAR2(32767):='Se consultó la información, correctamente.';
        LN_COD_EMPRESA          NUMBER;
        LN_INDICE               NUMBER         := 1;
        LV_JSON                 CLOB           := NULL;
    BEGIN
        --
        APEX_JSON.PARSE(PCL_EXTRA_PARAMS);
        LV_SERIE           := APEX_JSON.GET_VARCHAR2('strSerie');
        LV_ESTADO_CUSTODIO := APEX_JSON.GET_VARCHAR2('strEstadoCustodio');
        LV_TIPO_CUSTODIO   := APEX_JSON.GET_VARCHAR2('strTipoCustodio');
        LV_TIPO_ARTICULO   := APEX_JSON.GET_VARCHAR2('strTipoArticulo');
        LV_ESTADO_EMPLEADO := APEX_JSON.GET_VARCHAR2('strEstadoEmpleado');
        LV_IP_CREACION     := APEX_JSON.GET_VARCHAR2('strIpCreacion');
        LN_COD_EMPRESA     := APEX_JSON.GET_NUMBER('intCodEmpresa');
        --
        LV_JSON := '{' || CHR(10);
        LV_JSON := LV_JSON
                    || LPAD(' ', 3, ' ')
                    || '"jsonData":[';
        IF C_GET_SERIE%ISOPEN THEN
            CLOSE C_GET_SERIE;
        END IF;
        OPEN C_GET_SERIE(LV_SERIE, LN_COD_EMPRESA, LV_ESTADO_CUSTODIO, LV_TIPO_CUSTODIO, LV_TIPO_ARTICULO);
        FETCH C_GET_SERIE BULK COLLECT INTO LT_INFO_SERIE LIMIT 10000000;
        CLOSE C_GET_SERIE;
        --
        WHILE LN_INDICE <= LT_INFO_SERIE.COUNT() LOOP
        --
            IF LT_INFO_SERIE(LN_INDICE).CUSTODIO_ID IS NOT NULL THEN
            --
                IF C_GET_FOTO_EMPLEADO%ISOPEN THEN
                    CLOSE C_GET_FOTO_EMPLEADO;
                END IF;
                OPEN C_GET_FOTO_EMPLEADO(LT_INFO_SERIE(LN_INDICE).CUSTODIO_ID,LV_ESTADO_EMPLEADO,LN_COD_EMPRESA);
                FETCH C_GET_FOTO_EMPLEADO INTO LR_EMPLEADO;
                CLOSE C_GET_FOTO_EMPLEADO;
                --
                IF LR_EMPLEADO.NO_EMPLE IS NOT NULL THEN
                --
                    IF C_GET_EMPLEADO%ISOPEN THEN
                        CLOSE C_GET_EMPLEADO;
                    END IF;
                    OPEN C_GET_EMPLEADO(LR_EMPLEADO.NO_EMPLE);
                    FETCH C_GET_EMPLEADO INTO LR_VISTA_EMPLEADO;
                    CLOSE C_GET_EMPLEADO;
                    --
                    IF LR_VISTA_EMPLEADO.NO_EMPLE IS NOT NULL THEN
                    --
                        LV_JSON     := LV_JSON || 
                            CHR(10)||LPAD(' ',6, ' ')||'{'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strNombre":"'||TRIM(LR_VISTA_EMPLEADO.NOMBRE)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strCedula":"'||TRIM(LR_VISTA_EMPLEADO.CEDULA)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strFoto":"'||TRIM(LR_EMPLEADO.FOTO)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strCargo":"'||TRIM(LR_VISTA_EMPLEADO.DESCRIPCION_CARGO)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strDepartamento":"'||TRIM(LR_VISTA_EMPLEADO.NOMBRE_DEPTO)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strNombreJefe":"'||TRIM(LR_VISTA_EMPLEADO.NOMBRE_JEFE)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strCantonLabora":"'||TRIM(LR_VISTA_EMPLEADO.NOMBRE_CANTON)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strFechaIngreso":"'||TRIM(LR_VISTA_EMPLEADO.F_INGRESO)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strFechaDespacho":"'||TRIM(LT_INFO_SERIE(LN_INDICE).FE_CREACION)||'",'||
                            CHR(10)||LPAD(' ',9, ' ')||'"strEstado":"'||TRIM(LR_VISTA_EMPLEADO.ESTADO)||'"'||
                            CHR(10)||LPAD(' ',6, ' ')||'}';
                        LN_INDICE := LN_INDICE + 1;
                        IF LN_INDICE <= LT_INFO_SERIE.COUNT() THEN
                            LV_JSON := LV_JSON || ',';
                        END IF;
                    END IF;
                END IF;
            END IF;
        END LOOP;
        LV_JSON       := LV_JSON
                          || CHR(10)
                          || LPAD(' ', 3, ' ')
                          || ']';
        PCL_RESULTADO := LV_JSON
                        || CHR(10)
                        || '}';
        PV_STATUS     := LV_STATUS_ERROR;
        PV_MENSAJE    := LV_MENSAJE_ERROR;
    EXCEPTION
        WHEN OTHERS THEN
            PV_STATUS        := 'ERROR';
            PV_MENSAJE       := 'Ha ocurrido un error inesperado';
            LV_MENSAJE_ERROR := 'Ha ocurrido un error inesperado: '
                                || SQLCODE
                                || ' -ERROR- '
                                || SUBSTR(SQLERRM, 1, 1000);
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('NAF',
                                                'NAF47_TNET.AFKG_CONSULTA',
                                                LV_MENSAJE_ERROR,
                                                NVL(SYS_CONTEXT('USERENV', 'HOST'), 'NAF'),
                                                SYSDATE,
                                                NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), '127.0.0.1'));
    END P_CONTROL_CUSTODIO;
END AFKG_CONSULTA;
/