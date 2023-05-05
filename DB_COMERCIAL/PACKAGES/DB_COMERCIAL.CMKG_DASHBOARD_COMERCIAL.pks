CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_DASHBOARD_COMERCIAL AS

    /**
      * Documentación para el procedimiento P_GENERA_JSON_CATALOGOS
      *
      * Método que se encarga de generar el JSON de cada uno de los catálogos y cargalos en la tabla
      *
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 20-11-2018
      */
    PROCEDURE P_GENERA_JSON_DASHBOARD(Pv_Empresa     IN  VARCHAR2,
                                      Pv_Descripcion IN  VARCHAR2,
                                      Pv_Error       OUT VARCHAR2);

    /**
      * Documentación para la función F_ANIO_BISIESTO
      *
      * Determina si un año es año bisiesto
      *
      * @param Fn_Anio IN NUMBER Recibe el año a consultar si es bisiesto
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 21-11-2018
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.1 23-04-2019 - Se modifica el order del cursor para mostrar los años de manera descendente
      */
    FUNCTION F_ANIO_BISIESTO(Fn_Anio IN  NUMBER)
    RETURN NUMBER;

END CMKG_DASHBOARD_COMERCIAL;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_DASHBOARD_COMERCIAL AS

  PROCEDURE P_GENERA_JSON_DASHBOARD(Pv_Empresa     IN  VARCHAR2,
                                    Pv_Descripcion IN  VARCHAR2,
                                    Pv_Error       OUT VARCHAR2) AS
    Lv_Json CLOB := '';

    CURSOR C_Vendedores(Cv_EmpresaCod VARCHAR2, Cv_Origen VARCHAR2) IS
    SELECT DISTINCT(CNT.usr_creacion) AS usr_creacion
    FROM DB_COMERCIAL.INFO_CONTRATO CNT
    LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL EMP
      ON CNT.PERSONA_EMPRESA_ROL_ID = EMP.ID_PERSONA_ROL
    LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ROL
      ON EMP.EMPRESA_ROL_ID = ROL.ID_EMPRESA_ROL
    WHERE ROL.EMPRESA_COD = Cv_EmpresaCod
      AND CNT.ORIGEN = Cv_Origen;

    CURSOR C_ContratosAnio(Cv_EmpresaCod VARCHAR2, Cv_Origen VARCHAR2, Cv_Estado VARCHAR2, Cv_Login VARCHAR2, Cv_EstadoServicio VARCHAR2) IS   
     SELECT COUNT(1) AS total, TO_CHAR(CNT.FE_CREACION, 'yyyy') AS anio
      FROM DB_COMERCIAL.INFO_CONTRATO CNT
      LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL EMP
        ON CNT.PERSONA_EMPRESA_ROL_ID = EMP.ID_PERSONA_ROL
      LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ROL
        ON EMP.EMPRESA_ROL_ID = ROL.ID_EMPRESA_ROL
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
        ON CNT.PERSONA_EMPRESA_ROL_ID = PUN.PERSONA_EMPRESA_ROL_ID
      LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
        ON PUN.ID_PUNTO = SER.PUNTO_ID
      WHERE ROL.EMPRESA_COD = Cv_EmpresaCod
        AND CNT.ORIGEN = Cv_Origen
        AND CNT.ESTADO = Cv_Estado
        AND SER.ESTADO = Cv_EstadoServicio
        AND CNT.USR_CREACION = Cv_Login
        AND CNT.FE_CREACION >= ADD_MONTHS(sysdate,-3)
      GROUP BY to_char(CNT.FE_CREACION, 'yyyy')
      ORDER BY TO_CHAR(CNT.FE_CREACION, 'yyyy') DESC;


    CURSOR C_ContratosAnioMes(Cv_EmpresaCod VARCHAR2, Cv_Origen VARCHAR2, Cv_Estado VARCHAR2, Cv_Login VARCHAR2, Cv_Anio VARCHAR2, Cv_EstadoServicio VARCHAR2) IS
    SELECT count(1) AS total, to_char(CNT.FE_CREACION, 'MM') AS mes,
    TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish') AS nombreLargo,
    TO_CHAR(CNT.FE_CREACION, 'Mon','nls_date_language=spanish') AS nombreCorto
    FROM DB_COMERCIAL.INFO_CONTRATO CNT
    LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL EMP
      ON CNT.PERSONA_EMPRESA_ROL_ID = EMP.ID_PERSONA_ROL
    LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ROL
      ON EMP.EMPRESA_ROL_ID = ROL.ID_EMPRESA_ROL
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
      ON CNT.PERSONA_EMPRESA_ROL_ID = PUN.PERSONA_EMPRESA_ROL_ID
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
      ON PUN.ID_PUNTO = SER.PUNTO_ID      
    WHERE ROL.EMPRESA_COD = Cv_EmpresaCod
      AND CNT.ORIGEN = Cv_Origen
      AND CNT.ESTADO = Cv_Estado
      AND to_char(CNT.FE_CREACION, 'yyyy') = Cv_Anio
      AND CNT.USR_CREACION = Cv_Login
      AND SER.ESTADO = Cv_EstadoServicio
    GROUP BY to_char(CNT.FE_CREACION, 'MM'), TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish'),
    TO_CHAR(CNT.FE_CREACION, 'Mon','nls_date_language=spanish')
    ORDER BY to_char(CNT.FE_CREACION, 'MM'), TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish');


    CURSOR C_ContratosAnioMesSemana(Cv_EmpresaCod     VARCHAR2,
                                    Cv_Origen         VARCHAR2,
                                    Cv_Estado         VARCHAR2,
                                    Cv_Login          VARCHAR2,
                                    Cv_Anio           VARCHAR2,
                                    Cv_Mes            VARCHAR2,
                                    Cv_EstadoServicio VARCHAR2) IS
    SELECT count(1) AS total, to_char(CNT.FE_CREACION, 'MM') AS mes,
    TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish') AS nombreLargo,
    TO_CHAR(CNT.FE_CREACION, 'Mon','nls_date_language=spanish') AS nombreCorto,
    TO_CHAR(CNT.FE_CREACION, 'W') AS semanaMes
    FROM DB_COMERCIAL.INFO_CONTRATO CNT
    LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL EMP
      ON CNT.PERSONA_EMPRESA_ROL_ID = EMP.ID_PERSONA_ROL
    LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ROL
      ON EMP.EMPRESA_ROL_ID = ROL.ID_EMPRESA_ROL
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
      ON CNT.PERSONA_EMPRESA_ROL_ID = PUN.PERSONA_EMPRESA_ROL_ID
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
      ON PUN.ID_PUNTO = SER.PUNTO_ID            
    WHERE ROL.EMPRESA_COD = Cv_EmpresaCod
      AND CNT.ORIGEN = Cv_Origen
      AND CNT.ESTADO = Cv_Estado
      AND to_char(CNT.FE_CREACION, 'yyyy') = Cv_Anio
      AND to_char(CNT.FE_CREACION, 'MM') = Cv_Mes
      AND CNT.USR_CREACION = Cv_Login
      AND SER.ESTADO = Cv_EstadoServicio
    GROUP BY to_char(CNT.FE_CREACION, 'MM'), TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish'),
    TO_CHAR(CNT.FE_CREACION, 'Mon','nls_date_language=spanish'),
    TO_CHAR(CNT.FE_CREACION, 'W')
    ORDER BY to_char(CNT.FE_CREACION, 'MM'), TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish'),
             TO_CHAR(CNT.FE_CREACION, 'W');

    CURSOR C_ContratosAnioMesSemanaDia(Cv_EmpresaCod VARCHAR2,
                                       Cv_Origen     VARCHAR2,
                                       Cv_Estado     VARCHAR2,
                                       Cv_Login      VARCHAR2,
                                       Cv_Anio       VARCHAR2,
                                       Cv_Mes        VARCHAR2,
                                       Cv_Semana     VARCHAR2,
                                       Cv_EstadoServicio VARCHAR2) IS
    SELECT count(1) AS total, to_char(CNT.FE_CREACION, 'MM') AS mes,
    TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish') AS nombreLargo,
    TO_CHAR(CNT.FE_CREACION, 'Mon','nls_date_language=spanish') AS nombreCorto,
    TO_CHAR(CNT.FE_CREACION, 'W') AS semanaMes,
    TO_CHAR(CNT.FE_CREACION, 'IW') AS semanaAnio,
    TO_CHAR(CNT.FE_CREACION, 'Day','nls_date_language=spanish') AS dia,
    TO_CHAR(CNT.FE_CREACION, 'dd/mm/yyyy') AS feCreacion
    FROM DB_COMERCIAL.INFO_CONTRATO CNT
    LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL EMP
      ON CNT.PERSONA_EMPRESA_ROL_ID = EMP.ID_PERSONA_ROL
    LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL ROL
      ON EMP.EMPRESA_ROL_ID = ROL.ID_EMPRESA_ROL
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
      ON CNT.PERSONA_EMPRESA_ROL_ID = PUN.PERSONA_EMPRESA_ROL_ID
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
      ON PUN.ID_PUNTO = SER.PUNTO_ID                  
    WHERE ROL.EMPRESA_COD = Cv_EmpresaCod
      AND CNT.ORIGEN = Cv_Origen
      AND CNT.ESTADO = Cv_Estado
      AND to_char(CNT.FE_CREACION, 'yyyy') = Cv_Anio
      AND to_char(CNT.FE_CREACION, 'MM') = Cv_Mes
      AND TO_CHAR(CNT.FE_CREACION, 'W') = Cv_Semana
      AND CNT.USR_CREACION = Cv_Login
      AND SER.ESTADO = Cv_EstadoServicio
    GROUP BY to_char(CNT.FE_CREACION, 'MM'), TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish'),
    TO_CHAR(CNT.FE_CREACION, 'Mon','nls_date_language=spanish'),
    TO_CHAR(CNT.FE_CREACION, 'W'), TO_CHAR(CNT.FE_CREACION, 'IW'),
    TO_CHAR(CNT.FE_CREACION, 'Day','nls_date_language=spanish'),
    TO_CHAR(CNT.FE_CREACION, 'dd/mm/yyyy')
    ORDER BY to_char(CNT.FE_CREACION, 'MM'), TO_CHAR(CNT.FE_CREACION, 'Month','nls_date_language=spanish'),
             TO_CHAR(CNT.FE_CREACION, 'W'), TO_CHAR(CNT.FE_CREACION, 'Day','nls_date_language=spanish');

    Ln_Existe     NUMBER;
    Lv_Leap       VARCHAR2(50);
  BEGIN

  FOR I IN C_Vendedores(Pv_Empresa, 'MOVIL') LOOP
     Lv_Json := EMPTY_CLOB();
     Lv_Json := '{"response":{"entityDashboardList":[{';
     DBMS_LOB.APPEND(Lv_Json, '"description": "' || I.usr_creacion || '", ');
     DBMS_LOB.APPEND(Lv_Json, '"groupBasicModelList": [{');
         DBMS_LOB.APPEND(Lv_Json, '"code":' || 2 || ', ');
         DBMS_LOB.APPEND(Lv_Json, '"description": "' || 'Contratos' || '", ');
         DBMS_LOB.APPEND(Lv_Json, '"basicModelList": [{');
            DBMS_LOB.APPEND(Lv_Json, '"code": "' || 1 || '", '); --aprobadas
            DBMS_LOB.APPEND(Lv_Json, '"description": "' || 'Contratos Finalizados' || '", '); --aprobadas
            DBMS_LOB.APPEND(Lv_Json, '"yearList": [ ');
            FOR I1 IN C_ContratosAnio(Pv_Empresa,
                                      'MOVIL',
                                      'Activo',
                                      I.usr_creacion,
                                      'Activo') LOOP
                Lv_Leap := DB_COMERCIAL.CMKG_DASHBOARD_COMERCIAL.F_ANIO_BISIESTO(I1.anio);
                DBMS_LOB.APPEND(Lv_Json, '{"number": ' || I1.anio || ',');
                DBMS_LOB.APPEND(Lv_Json, '"isLeap": ' || Lv_Leap || ',');
                DBMS_LOB.APPEND(Lv_Json, '"countItems": ' || I1.total || ',');
                DBMS_LOB.APPEND(Lv_Json, '"monthList": [');
                FOR I2 IN C_ContratosAnioMes(Pv_Empresa,
                                             'MOVIL',
                                             'Activo',
                                             I.usr_creacion,
                                             I1.anio,
                                             'Activo') LOOP
                    DBMS_LOB.APPEND(Lv_Json, '{"numberOfMonth": ' || TO_NUMBER(I2.mes) || ',');
                    DBMS_LOB.APPEND(Lv_Json, '"largeName": "' || trim(I2.nombreLargo) || '",');
                    DBMS_LOB.APPEND(Lv_Json, '"shortName": "' || trim(I2.nombreCorto) || '",');
                    DBMS_LOB.APPEND(Lv_Json, '"countItems": ' || I2.total || ',');
                    DBMS_LOB.APPEND(Lv_Json, '"weekList": [');
                    FOR I3 IN C_ContratosAnioMesSemana(Pv_Empresa,
                                                       'MOVIL',
                                                       'Activo',
                                                       I.usr_creacion,
                                                       I1.anio,
                                                       I2.mes,
                                                       'Activo') LOOP
                        DBMS_LOB.APPEND(Lv_Json, '{"description": "sem' || I3.semanaMes  || '",');
                        DBMS_LOB.APPEND(Lv_Json, '"numberOfWeek": ' || TO_NUMBER(I3.semanaMes) || ',');
                        DBMS_LOB.APPEND(Lv_Json, '"countItems": ' || I3.total || '},');
                    END LOOP;
                    Lv_Json := SUBSTR(Lv_Json, 0, LENGTH(Lv_Json) - 1);
                    DBMS_LOB.APPEND(Lv_Json, ']},');
                END LOOP;
                Lv_Json := SUBSTR(Lv_Json, 0, LENGTH(Lv_Json) - 1);
                DBMS_LOB.APPEND(Lv_Json, ']},');
            END LOOP;
            Lv_Json := SUBSTR(Lv_Json, 0, LENGTH(Lv_Json) - 1);
            DBMS_LOB.APPEND(Lv_Json, ']');
            DBMS_LOB.APPEND(Lv_Json, '},{'); -- cierro basiModelList de aprobados
            DBMS_LOB.APPEND(Lv_Json, '"code": "' || 2 || '", '); --aprobadas
            DBMS_LOB.APPEND(Lv_Json, '"description": "' || 'Contratos no Finalizados' || '", '); --aprobadas
            DBMS_LOB.APPEND(Lv_Json, '"yearList": [ ');

            FOR N1 IN C_ContratosAnio(Pv_Empresa,
                                      'MOVIL',
                                      'Activo',
                                      I.usr_creacion,
                                      'PrePlanificada') LOOP
                Lv_Leap := DB_COMERCIAL.CMKG_DASHBOARD_COMERCIAL.F_ANIO_BISIESTO(N1.anio);
                DBMS_LOB.APPEND(Lv_Json, '{"number": ' || N1.anio || ',');
                DBMS_LOB.APPEND(Lv_Json, '"isLeap": ' || Lv_Leap || ',');
                DBMS_LOB.APPEND(Lv_Json, '"countItems": ' || N1.total || ',');
                DBMS_LOB.APPEND(Lv_Json, '"monthList": [');
                FOR I2 IN C_ContratosAnioMes(Pv_Empresa,
                                             'MOVIL',
                                             'Activo',
                                             I.usr_creacion,
                                             N1.anio,
                                             'PrePlanificada') LOOP
                    DBMS_LOB.APPEND(Lv_Json, '{"numberOfMonth": ' || TO_NUMBER(I2.mes) || ',');
                    DBMS_LOB.APPEND(Lv_Json, '"largeName": "' || trim(I2.nombreLargo) || '",');
                    DBMS_LOB.APPEND(Lv_Json, '"shortName": "' || trim(I2.nombreCorto) || '",');
                    DBMS_LOB.APPEND(Lv_Json, '"countItems": ' || I2.total || ',');
                    DBMS_LOB.APPEND(Lv_Json, '"weekList": [');
                    FOR I3 IN C_ContratosAnioMesSemana(Pv_Empresa,
                                                       'MOVIL',
                                                       'Activo',
                                                       I.usr_creacion,
                                                       N1.anio,
                                                       I2.mes,
                                                       'PrePlanificada') LOOP
                        DBMS_LOB.APPEND(Lv_Json, '{"description": "sem' || I3.semanaMes  || '",');
                        DBMS_LOB.APPEND(Lv_Json, '"numberOfWeek": ' || TO_NUMBER(I3.semanaMes) || ',');
                        DBMS_LOB.APPEND(Lv_Json, '"countItems": ' || I3.total || '},');
                    END LOOP;
                    Lv_Json := SUBSTR(Lv_Json, 0, LENGTH(Lv_Json) - 1);
                    DBMS_LOB.APPEND(Lv_Json, ']},');
                END LOOP;
                Lv_Json := SUBSTR(Lv_Json, 0, LENGTH(Lv_Json) - 1);
                DBMS_LOB.APPEND(Lv_Json, ']},');
            END LOOP;
     Lv_Json := SUBSTR(Lv_Json, 0, LENGTH(Lv_Json) - 1);

     DBMS_LOB.APPEND(Lv_Json, ']}]'); -- cierro basiModelList
     DBMS_LOB.APPEND(Lv_Json, '}]'); -- cierrro groupBasicModelList
     DBMS_LOB.APPEND(Lv_Json, '}]},');
     DBMS_LOB.APPEND(Lv_Json, '"status": "200",');
     DBMS_LOB.APPEND(Lv_Json, '"message": "OK",');
     DBMS_LOB.APPEND(Lv_Json, '"success": true,');
     DBMS_LOB.APPEND(Lv_Json, '"token": false');
     DBMS_LOB.APPEND(Lv_Json, '}');

     --aqui reviso en la data
     SELECT COUNT(1)
     INTO Ln_Existe
     FROM DB_COMERCIAL.ADMI_CATALOGOS
     WHERE tipo = 'DASHBOARD' ||  I.usr_creacion
       AND cod_empresa = Pv_Empresa;

     IF Ln_Existe > 0 THEN
        UPDATE DB_COMERCIAL.ADMI_CATALOGOS
        SET JSON_CATALOGO = Lv_Json
        WHERE tipo = 'DASHBOARD' ||  I.usr_creacion
          AND cod_empresa = Pv_Empresa;
     ELSE
        INSERT INTO DB_COMERCIAL.ADMI_CATALOGOS
        VALUES (DB_COMERCIAL.SEQ_ADMI_CATALOGOS.NEXTVAL, Pv_Empresa, 'DASHBOARD' || I.usr_creacion, Lv_Json, null, SYSDATE );
     END IF;
     COMMIT;
  END LOOP;


    -- TAREA: Se necesita implantación para PROCEDURE CMKG_DASHBOARD_COMERCIAL.P_GENERA_JSON_DASHBOARD
  END P_GENERA_JSON_DASHBOARD;


  FUNCTION F_ANIO_BISIESTO(Fn_Anio In Number) RETURN NUMBER IS
  Ln_Retorno NUMBER := 0;
  BEGIN
      -- A year is a leap year if it is evenly divisible by 4
      -- but not if it's evenly divisible by 100
      -- unless it's also evenly divisible by 400
      IF MOD(Fn_Anio, 400) = 0 OR ( MOD(Fn_Anio, 4) = 0 AND MOD(Fn_Anio, 100) != 0) THEN
         Ln_Retorno := 1;
      END IF;
      RETURN Ln_Retorno;
  END F_ANIO_BISIESTO;


END CMKG_DASHBOARD_COMERCIAL;
/
