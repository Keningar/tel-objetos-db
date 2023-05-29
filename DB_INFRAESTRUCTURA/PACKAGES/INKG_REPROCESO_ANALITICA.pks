CREATE OR REPLACE PACKAGE DB_INFRAESTRUCTURA.INKG_REPROCESO_ANALITICA
AS
  /**
  *Documentacion para REPROCESO_CAMARAS_ANALITICA
  *Este procedimiento se encarga de reporocesar las camaras que fallaron por cualquier
  *motivo en el consumo del WS de analitica durante la activacion, se reprocesan las camaras
  *con la caracteristica ANALITICA_CONSUMO_WS: ERROR
  *
  *@author Leonardo Mero <lemero@telconet.ec>
  *@version 1.0 20-09-2022
  */
  PROCEDURE P_REPROCESO_CAMARAS_ANALITICA;
  /**
  *Documentacion para la funcion F_GET_VALOR_SER_PROD_CARACT
  *
  *Funcion que permite obtener el valor de una caracteristica de INFO_SERVICIO_PROD_CARACT
  *
  *@params Fv_Nombre Nombre de la caracteristica del servico que se desea consultar
  *@params Fn_ServicioId Corresponde al identificador del servicio
  *
  *@return VARCHAR2 Devuelve el valor de la caracterisitica del servicio especificado
  *@author Leonardo Mero <lemero@telconet.ec>
  *@version 1.0 20-09-2022
  */
  FUNCTION F_GET_VALOR_SER_PROD_CARACT(
      FV_NOMBRE     IN VARCHAR2,
      FN_SERVICIOID IN NUMBER)
    RETURN VARCHAR2;
END INKG_REPROCESO_ANALITICA;
/

CREATE OR REPLACE PACKAGE BODY DB_INFRAESTRUCTURA.INKG_REPROCESO_ANALITICA
AS
  PROCEDURE P_REPROCESO_CAMARAS_ANALITICA
  IS
    --*********VARIABLES*********
    LV_OPERACION        VARCHAR2(20) := 'ACTIVAR';
    LV_PROCESO          VARCHAR2(20)  := 'REPROCESAMIENTO';
    LV_EMPRESA          VARCHAR2(5)  := 'TN';
    LV_PROYECTO         VARCHAR2(50) := 'safecity';
    LV_NOMBRESERVICIO   VARCHAR2(20) := 'WS-analytics';
    LV_IPORIGEN         VARCHAR2(20) := '127.0.0.1';
    LV_IDORIGEN         VARCHAR2(10) := 'telcos';
    LV_FECHAORIGEN      VARCHAR2(50) := SYSDATE;
    LV_IDTIPOORIGEN     VARCHAR2(5)  := 'prod';    --Entorno de ejecucion
    LN_IDCLIENTE        VARCHAR2(20);
    LV_NOMBRECLIENTE    VARCHAR2(100);
    LV_DIRECCIONCLIENTE VARCHAR2(100);
    LV_IPCAMARA         VARCHAR2(20);
    LV_LOGINAUX         VARCHAR2(50);
    LV_PASSWORD         VARCHAR2(50);
    LV_TIPO             VARCHAR2(100);
    LV_TIPOPOSICION     VARCHAR2(50);
    LV_FPS              VARCHAR2(10);
    LV_RESOLUCION       VARCHAR2(20);
    LV_MODELO           VARCHAR2(20);
    LV_MARCA            VARCHAR2(20);
    LV_CODEC            VARCHAR2(10);
    LV_SERIE            VARCHAR2(20);
    LV_MAC              VARCHAR2(50);
    LB_AUDIO            BOOLEAN := FALSE;
    LB_RECORDING        BOOLEAN := FALSE;
    LF_LATITUD FLOAT;
    LF_LONGITUD FLOAT;
    LV_LOGIN     VARCHAR2(50);
    LV_DIRECCION VARCHAR2(100);
    --Variables utils
    LN_SERVICIOID        NUMBER;
    LN_PERSONAEMPRESAROL NUMBER;
    LV_USUARIO           VARCHAR2(20) := 'telcos_repro';
    LV_URLTOKEN          VARCHAR2(100);
    LV_URLCAMARASETUP    VARCHAR2(100);
    LV_REQ_PASSWORD      VARCHAR2(50);
    LV_TOKEN             VARCHAR2(1500);
    --Variables para el WS ??
    LV_STATUSRESULT VARCHAR2(10);
    LCL_REQUEST CLOB;
    LCL_RESPONSE CLOB;
    LCL_HEADERS CLOB;
    LV_MSGRESULT   VARCHAR2(4000);
    LV_ERROR      VARCHAR2(500);
    LV_RES_CODE   VARCHAR2(100); 
    LV_RES_MSG    VARCHAR2(100);
    LV_APLICACION VARCHAR2(50) := 'application/json';
    LN_CODEREQUEST NUMBER;
    LE_EXCEPTION  EXCEPTION;
    --*********FIN VARIABLES*********
    --*********CURSORES*********
    --Camaras que fallaron en el consumo del WS de ANALITICA
    CURSOR C_CAMARASREPROCESO
    IS
      SELECT INFO_SERVICIO_PROD_CARACT.ID_SERVICIO_PROD_CARACT,
        SERVICIO_ID
      FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
      WHERE VALOR                     = 'ERROR'
      AND ESTADO                      = 'Activo'
      AND PRODUCTO_CARACTERISITICA_ID =
        (SELECT ADMI_PRODUCTO_CARACTERISTICA.ID_PRODUCTO_CARACTERISITICA
        FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA
        WHERE CARACTERISTICA_ID IN
          (SELECT ADMI_CARACTERISTICA.ID_CARACTERISTICA
          FROM DB_COMERCIAL.ADMI_CARACTERISTICA
          WHERE DESCRIPCION_CARACTERISTICA = 'ANALITICA_CONSUMO_WS'
          AND ESTADO                       = 'Activo'
          )
        );
      --
      --Cursor para obtener datos de la camara
      CURSOR C_INFOCAMARA ( CN_SERVICIOID NUMBER)
      IS
        SELECT IE.ID_ELEMENTO,
          IE.SERIE_FISICA,
          MODELO.NOMBRE_MODELO_ELEMENTO,
          MARCA.NOMBRE_MARCA_ELEMENTO
        FROM DB_COMERCIAL.INFO_SERVICIO_TECNICO ISF
        LEFT JOIN DB_INFRAESTRUCTURA.INFO_ELEMENTO IE
        ON IE.ID_ELEMENTO = ISF.ELEMENTO_CLIENTE_ID
        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MODELO_ELEMENTO MODELO
        ON MODELO.ID_MODELO_ELEMENTO = IE.MODELO_ELEMENTO_ID
        LEFT JOIN DB_INFRAESTRUCTURA.ADMI_MARCA_ELEMENTO MARCA
        ON MARCA.ID_MARCA_ELEMENTO = MODELO.MARCA_ELEMENTO_ID
        WHERE ISF.SERVICIO_ID      = CN_SERVICIOID;
      --
      --Cursor para obtener la IP asignada
      CURSOR C_IPASIGNADA ( CN_SERVICIOID NUMBER)
      IS
        SELECT IP FROM DB_INFRAESTRUCTURA.INFO_IP WHERE SERVICIO_ID = CN_SERVICIOID;
      --
      --Cursor para obtener los datos del cliente
      CURSOR C_DATOSCLIENTE ( CN_PERSONAID NUMBER)
      IS
        SELECT IDENTIFICACION_CLIENTE,
          RAZON_SOCIAL,
          DIRECCION
        FROM DB_COMERCIAL.INFO_PERSONA
        WHERE ID_PERSONA =
          (SELECT PERSONA_ID
          FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL
          WHERE ID_PERSONA_ROL = CN_PERSONAID
          );
      --
      --Cursor para obtener los datos del punto
      CURSOR C_DATOSPUNTO ( CN_SERVICIOID NUMBER)
      IS
        SELECT SERVICIO.PUNTO_ID,
          SERVICIO.LOGIN_AUX,
          PUNTO.DIRECCION,
          PUNTO.LOGIN,
          PUNTO.LATITUD,
          PUNTO.LONGITUD,
          PUNTO.PERSONA_EMPRESA_ROL_ID
        FROM DB_COMERCIAL.INFO_SERVICIO SERVICIO
        LEFT JOIN INFO_PUNTO PUNTO
        ON PUNTO.ID_PUNTO = SERVICIO.PUNTO_ID
        WHERE ID_SERVICIO = CN_SERVICIOID;
      --
      --Cursor parametros del WS
      CURSOR C_PARAMETROSWS
      IS
        SELECT VALOR1,
        VALOR2,
        VALOR3,
        VALOR4,
        VALOR5
        FROM DB_GENERAL.ADMI_PARAMETRO_DET
        WHERE DESCRIPCION = 'ANALITICA_WS_PARAMETROS'
        AND ESTADO        = 'Activo';
      --
      --Cursor para realizar el Split
      CURSOR C_SPLIT( CV_URL VARCHAR2)
      IS
        SELECT VAL
        FROM
          (SELECT ROWNUM AS RN,
            COLUMN_VALUE AS VAL
          FROM TABLE(APEX_STRING.SPLIT (
            (SELECT VAL
            FROM
              (SELECT ROWNUM AS RN,
                COLUMN_VALUE AS VAL
              FROM TABLE(APEX_STRING.SPLIT(CV_URL, '#'))
              )
          WHERE RN = 1
            ), ':'))
          )
        WHERE RN = 3;
        --*********FIN CURSORES*********
        --*********VARIABLES CURSORES*********
        LC_DATOSPUNTO C_DATOSPUNTO%ROWTYPE;
        LC_DATOSCLIENTE C_DATOSCLIENTE%ROWTYPE;
        LC_IPASIGNADA C_IPASIGNADA%ROWTYPE;
        LC_INFOCAMARA C_INFOCAMARA%ROWTYPE;
        LC_SPLIT C_SPLIT%ROWTYPE;
        LC_PARAMETROSWS C_PARAMETROSWS%ROWTYPE;
        --*********FIN VARIABLES CURSORES*********
      BEGIN
        FOR LC_CAMARASREPROCESO IN C_CAMARASREPROCESO
        LOOP
          LN_SERVICIOID := LC_CAMARASREPROCESO.SERVICIO_ID;
          --********* APARTIR DE AQUI SE PUEDE PROCESAR LAS CAMARAS UNA POR UNA *********
          --Datos del punto
          IF C_DATOSPUNTO%ISOPEN THEN
            CLOSE C_DATOSPUNTO;
          END IF;
          OPEN C_DATOSPUNTO(LN_SERVICIOID);
          FETCH C_DATOSPUNTO INTO LC_DATOSPUNTO;
          LN_PERSONAEMPRESAROL := LC_DATOSPUNTO.PERSONA_EMPRESA_ROL_ID;
          LV_LOGINAUX          := LC_DATOSPUNTO.LOGIN_AUX;
          LV_DIRECCION         := LC_DATOSPUNTO.DIRECCION;
          LV_LOGIN             := LC_DATOSPUNTO.LOGIN;
          LF_LATITUD           := LC_DATOSPUNTO.LATITUD;
          LF_LONGITUD          := LC_DATOSPUNTO.LONGITUD;
          CLOSE C_DATOSPUNTO;
          --
          --Datos del cliente
          IF C_DATOSCLIENTE%ISOPEN THEN
            CLOSE C_DATOSCLIENTE;
          END IF;
          OPEN C_DATOSCLIENTE(LN_PERSONAEMPRESAROL);
          FETCH C_DATOSCLIENTE INTO LC_DATOSCLIENTE;
          LN_IDCLIENTE        := LC_DATOSCLIENTE.IDENTIFICACION_CLIENTE;
          LV_NOMBRECLIENTE    := LC_DATOSCLIENTE.RAZON_SOCIAL;
          LV_DIRECCIONCLIENTE := LC_DATOSCLIENTE.DIRECCION;
          CLOSE C_DATOSCLIENTE;
          --
          --IP Asignada
          IF C_IPASIGNADA%ISOPEN THEN
            CLOSE C_IPASIGNADA;
          END IF;
          OPEN C_IPASIGNADA(LN_SERVICIOID);
          FETCH C_IPASIGNADA INTO LC_IPASIGNADA;
          LV_IPCAMARA := LC_IPASIGNADA.IP;
          CLOSE C_IPASIGNADA;
          --
          --TIPO_CAMARA
          LV_TIPO := LOWER(INKG_REPROCESO_ANALITICA.F_GET_VALOR_SER_PROD_CARACT('TIPO_CAMARA', LN_SERVICIOID));
          --
          --Posicion camara
          LV_TIPOPOSICION := INKG_REPROCESO_ANALITICA.F_GET_VALOR_SER_PROD_CARACT('POSICION_CAMARA', LN_SERVICIOID);
          --
          --FPS
          LV_FPS := INKG_REPROCESO_ANALITICA.F_GET_VALOR_SER_PROD_CARACT('FPS', LN_SERVICIOID);
          --
          --RESOLUCION
          LV_RESOLUCION := INKG_REPROCESO_ANALITICA.F_GET_VALOR_SER_PROD_CARACT('FORMATO_RESOLUCION', LN_SERVICIOID);
          --
          --CODEC
          LV_CODEC := INKG_REPROCESO_ANALITICA.F_GET_VALOR_SER_PROD_CARACT('CODEC', LN_SERVICIOID);
          --
          --MAC
          LV_MAC := INKG_REPROCESO_ANALITICA.F_GET_VALOR_SER_PROD_CARACT('MAC CLIENTE', LN_SERVICIOID);
          --
          --Obtendremos la clave de la camara
          OPEN C_SPLIT(INKG_REPROCESO_ANALITICA.F_GET_VALOR_SER_PROD_CARACT('URL_CAMARA', LN_SERVICIOID));
          FETCH C_SPLIT INTO LC_SPLIT;
          CLOSE C_SPLIT;
          LV_PASSWORD := LC_SPLIT.VAL;
          --
          --Datos de la camara
          IF C_INFOCAMARA%ISOPEN THEN
            CLOSE C_INFOCAMARA;
          END IF;
          OPEN C_INFOCAMARA(LN_SERVICIOID);
          FETCH C_INFOCAMARA INTO LC_INFOCAMARA;
          LV_MODELO := LC_INFOCAMARA.NOMBRE_MODELO_ELEMENTO;
          LV_MARCA  := LC_INFOCAMARA.NOMBRE_MARCA_ELEMENTO;
          LV_SERIE  := LC_INFOCAMARA.SERIE_FISICA;
          CLOSE C_INFOCAMARA;
          --Parametros WS
          IF C_PARAMETROSWS%ISOPEN THEN
            CLOSE C_PARAMETROSWS;
          END IF;
          OPEN C_PARAMETROSWS;
          FETCH C_PARAMETROSWS INTO LC_PARAMETROSWS;
          LV_URLTOKEN      := LC_PARAMETROSWS.VALOR1||LC_PARAMETROSWS.VALOR4;
          LV_URLCAMARASETUP:=LC_PARAMETROSWS.VALOR1||LC_PARAMETROSWS.VALOR3;
          LV_REQ_PASSWORD  :=LC_PARAMETROSWS.VALOR5;
          CLOSE C_PARAMETROSWS;
          --
          --********* REQUEST TOKEN *********
          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.WRITE('username', LV_IDORIGEN);
          APEX_JSON.WRITE('password', LV_REQ_PASSWORD);
          APEX_JSON.CLOSE_OBJECT;
          Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
          --********* FIN REQUEST TOKEN *********
          DB_GENERAL.GNKG_WEB_SERVICE.P_WEB_SERVICE(Pv_Url             => LV_URLTOKEN,
                                                  Pcl_Mensaje        => Lcl_Request,
                                                  Pv_Application     => LV_APLICACION,
                                                  Pv_Charset         => 'UTF-8',
                                                  Pv_UrlFileDigital  => null,
                                                  Pv_PassFileDigital => null,
                                                  Pcl_Respuesta      => LCL_RESPONSE,
                                                  Pv_Error           => Lv_Error);          APEX_JSON.PARSE(LCL_RESPONSE);
          LV_TOKEN:= APEX_JSON.GET_VARCHAR2(P_PATH=>'access_token');
          --********* HEADERS CON EL TOKEN *********
          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT;
          APEX_JSON.OPEN_OBJECT('headers');
          APEX_JSON.WRITE('Content-Type', Lv_Aplicacion);
          APEX_JSON.WRITE('Accept', Lv_Aplicacion);
          APEX_JSON.WRITE('Authorization', 'Bearer '|| LV_TOKEN);
          APEX_JSON.CLOSE_OBJECT;
          APEX_JSON.CLOSE_OBJECT;
          Lcl_Headers := APEX_JSON.GET_CLOB_OUTPUT;
          --********* FIN HEADERS CON EL TOKEN *********
          --********* ARMAMOS LA ESTRUCUTURA DEL REQUEST *********
          APEX_JSON.INITIALIZE_CLOB_OUTPUT;
          APEX_JSON.OPEN_OBJECT; --Abrimos el objeto del request
          APEX_JSON.WRITE('OP', LV_OPERACION);
          APEX_JSON.WRITE('process', LV_PROCESO);
          APEX_JSON.WRITE('business', LV_EMPRESA);
          APEX_JSON.WRITE('product', LV_PROYECTO);
          APEX_JSON.OPEN_OBJECT('source'); --Abrir Source
          APEX_JSON.WRITE('nameService', LV_NOMBRESERVICIO);
          APEX_JSON.WRITE('originIP', LV_IPORIGEN);
          APEX_JSON.WRITE('originId', LV_IDORIGEN);
          APEX_JSON.WRITE('originDate', LV_FECHAORIGEN);
          APEX_JSON.WRITE('typeOriginID', LV_IDTIPOORIGEN);
          APEX_JSON.CLOSE_OBJECT;           --Cerrar Source
          APEX_JSON.OPEN_OBJECT('data');   --Abrir Data
          APEX_JSON.OPEN_OBJECT('client'); --Abrir Client
          APEX_JSON.WRITE('identification', LN_IDCLIENTE);
          APEX_JSON.WRITE('name', LV_NOMBRECLIENTE);
          APEX_JSON.WRITE('address', LV_DIRECCIONCLIENTE);
          APEX_JSON.CLOSE_OBJECT;          --Cerrar Client
          APEX_JSON.OPEN_OBJECT('camera'); --Abrir Camera
          APEX_JSON.WRITE('IP', LV_IPCAMARA);
          APEX_JSON.WRITE('loginaux', LV_LOGINAUX);
          APEX_JSON.WRITE('password', LV_PASSWORD);
          APEX_JSON.WRITE('type', LOWER(LV_TIPO));
          APEX_JSON.WRITE('position', LV_TIPOPOSICION);
          APEX_JSON.WRITE('FPS', LV_FPS);
          APEX_JSON.WRITE('resolution', LV_RESOLUCION);
          APEX_JSON.WRITE('model', LV_MODELO);
          APEX_JSON.WRITE('brand', LV_MARCA);
          APEX_JSON.WRITE('codec', LV_CODEC);
          APEX_JSON.WRITE('serie', LV_SERIE);
          APEX_JSON.WRITE('MAC', LV_MAC);
          APEX_JSON.WRITE('audio', LB_AUDIO);
          APEX_JSON.WRITE('recording', LB_RECORDING);
          APEX_JSON.OPEN_ARRAY('services');
          APEX_JSON.CLOSE_ARRAY();
          APEX_JSON.OPEN_OBJECT('site'); --Abrir Site
          APEX_JSON.WRITE('latitude', LF_LATITUD);
          APEX_JSON.WRITE('longitude', LF_LONGITUD);
          APEX_JSON.WRITE('login', LV_LOGIN);
          APEX_JSON.WRITE('address', LV_DIRECCION);
          APEX_JSON.CLOSE_OBJECT; --Cerrar Sitio
          APEX_JSON.CLOSE_OBJECT; --Cerrar Camara
          APEX_JSON.CLOSE_OBJECT; --Cerrar Datos
          APEX_JSON.CLOSE_OBJECT;
          Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
          --********* CERRAMOS EL OBJETO DEL REQUEST *********
          APEX_JSON.FREE_OUTPUT;
          --********* LLAMADA AL WS *********
          DB_GENERAL.GNKG_WEB_SERVICE.P_POST(LV_URLCAMARASETUP,Lcl_Headers,Lcl_Request,Ln_CodeRequest,Lv_MsgResult,Lcl_Response);
          APEX_JSON.PARSE(LCL_RESPONSE);
          LV_RES_CODE:= APEX_JSON.GET_VARCHAR2(P_PATH=>'code');
          LV_RES_MSG:= APEX_JSON.GET_VARCHAR2(P_PATH=>'msg');
          IF LV_ERROR       IS NOT NULL THEN
            LV_STATUSRESULT := 'ERROR';
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_REPROCESO_ANALITICA.P_REPROCESO_CAMARAS_ANALITICA', 'Ocurrió un error al reprocesar el servicio ' || LN_SERVICIOID || ' -' || LV_ERROR, LV_USUARIO, SYSDATE, LV_IPORIGEN);
          END IF;
          IF LCL_RESPONSE   IS NOT NULL AND LV_RES_CODE = 201  THEN
            LV_STATUSRESULT := 'OK';
          ELSE
            LV_STATUSRESULT := 'ERROR';
            LV_ERROR := LV_RES_MSG;
            DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_REPROCESO_ANALITICA.P_REPROCESO_CAMARAS_ANALITICA', 'Ocurrió un error al reprocesar el servicio ' || LN_SERVICIOID || ' -' || LV_ERROR, LV_USUARIO, SYSDATE, LV_IPORIGEN);
          END IF;
          --********* FIN LLAMADA AL WS *********
          --********* INGRESO DE RESPUESTA DEL WS *********

          --Poner en estado eliminado la respuesta actual en ISPC
          UPDATE DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT
          SET ESTADO                    = 'Eliminado',
            USR_ULT_MOD                 = LV_USUARIO,
            FE_ULT_MOD                  = SYSDATE
          WHERE ID_SERVICIO_PROD_CARACT =  LC_CAMARASREPROCESO.ID_SERVICIO_PROD_CARACT;
          --Ingresar la nueva respuesta en ISPC
          INSERT
          INTO DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT VALUES
            (
              DB_COMERCIAL.SEQ_INFO_SERVICIO_PROD_CARACT.NEXTVAL,
              LN_SERVICIOID,
              (SELECT ADMI_PRODUCTO_CARACTERISTICA.ID_PRODUCTO_CARACTERISITICA
              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA
              WHERE CARACTERISTICA_ID IN
                (SELECT ADMI_CARACTERISTICA.ID_CARACTERISTICA
                FROM DB_COMERCIAL.ADMI_CARACTERISTICA
                WHERE DESCRIPCION_CARACTERISTICA = 'ANALITICA_CONSUMO_WS'
                )
              ),
              LV_STATUSRESULT,
              SYSDATE,
              NULL,
              LV_USUARIO,
              NULL,
              'Activo',
              NULL
            );
          --********* FIN INGRESO DE RESPUESTA DEL WS *********
        EXIT WHEN C_CAMARASREPROCESO%NOTFOUND;
        END LOOP;
      EXCEPTION
      WHEN LE_EXCEPTION THEN
        DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('Telcos+', 'INKG_REPROCESO_ANALITICA.P_REPROCESO_CAMARAS_ANALITICA', 'Ocurrió un error al reprocesar el servicio ' || LN_SERVICIOID || ' -' || LV_ERROR, LV_USUARIO, SYSDATE, LV_IPORIGEN);
      END P_REPROCESO_CAMARAS_ANALITICA;
        FUNCTION F_GET_VALOR_SER_PROD_CARACT
          (
            FV_NOMBRE     IN VARCHAR2,
            FN_SERVICIOID IN NUMBER
          )
          RETURN VARCHAR2
        IS
          --Cursor que recorre IPSC 
          CURSOR C_INFOSERVPRODCARACT( CN_SERVICIOID IN NUMBER, CV_NOMBRE IN VARCHAR2 )
          IS
            SELECT ISFC.VALOR
            FROM DB_COMERCIAL.INFO_SERVICIO_PROD_CARACT ISFC
            WHERE ISFC.SERVICIO_ID               = CN_SERVICIOID
            AND ESTADO                           = 'Activo'
            AND ISFC.PRODUCTO_CARACTERISITICA_ID =
              (SELECT ID_PRODUCTO_CARACTERISITICA
              FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA
              WHERE ADMI_PRODUCTO_CARACTERISTICA.CARACTERISTICA_ID =
                (SELECT ID_CARACTERISTICA
                FROM DB_COMERCIAL.ADMI_CARACTERISTICA
                WHERE DESCRIPCION_CARACTERISTICA = CV_NOMBRE
                )
            AND ADMI_PRODUCTO_CARACTERISTICA.PRODUCTO_ID =
              (SELECT ID_PRODUCTO
              FROM DB_COMERCIAL.ADMI_PRODUCTO
              WHERE ADMI_PRODUCTO.NOMBRE_TECNICO = 'SAFECITYDATOS'
              AND ESTADO                         = 'Activo'
              )
              );
            --
            LV_RETURN VARCHAR2(100);
            LC_SERVICIOPRODCARACT C_INFOSERVPRODCARACT%ROWTYPE;
          BEGIN
            LC_SERVICIOPRODCARACT.VALOR := '';
            IF C_INFOSERVPRODCARACT%ISOPEN THEN
              CLOSE C_INFOSERVPRODCARACT;
            END IF;
            OPEN C_INFOSERVPRODCARACT(FN_SERVICIOID, FV_NOMBRE);
            FETCH C_INFOSERVPRODCARACT INTO LC_SERVICIOPRODCARACT;
            CLOSE C_INFOSERVPRODCARACT;
            --
            IF LC_SERVICIOPRODCARACT.VALOR IS NULL THEN
              LV_RETURN                    := ' ';
            ELSE
              LV_RETURN := LC_SERVICIOPRODCARACT.VALOR;
            END IF;

            RETURN LV_RETURN;

          END F_GET_VALOR_SER_PROD_CARACT;
        END INKG_REPROCESO_ANALITICA;
/
