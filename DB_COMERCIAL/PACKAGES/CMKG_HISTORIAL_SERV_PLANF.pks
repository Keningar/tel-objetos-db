CREATE OR REPLACE PACKAGE DB_COMERCIAL.CMKG_HISTORIAL_SERV_PLANF AS 

     /**
      * Documentaci�n para el procedimiento P_INSERTA_HISTORIAL
      *
      * M�todo que se encarga de insertar en el historial de servicio cuando una solicitud ya no se puede
      * planificar desde la planificaci�n comercial
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 11-10-2021
      */
    PROCEDURE P_INSERTA_HISTORIAL (Pv_CodEmpresa  IN  VARCHAR2,
                                   Pv_Tipo        IN VARCHAR2,
                                   Pv_Estado      IN VARCHAR2,
                                   Pv_Status     OUT VARCHAR2,
                                   Pv_Mensaje    OUT VARCHAR2);  
                                   

END CMKG_HISTORIAL_SERV_PLANF;
/

CREATE OR REPLACE PACKAGE BODY DB_COMERCIAL.CMKG_HISTORIAL_SERV_PLANF AS
PROCEDURE P_INSERTA_HISTORIAL (Pv_CodEmpresa  IN  VARCHAR2,
                                   Pv_Tipo        IN VARCHAR2,
                                   Pv_Estado      IN VARCHAR2,
                                   Pv_Status     OUT VARCHAR2,
                                   Pv_Mensaje    OUT VARCHAR2) 
  IS
  CURSOR GET_DETALLE_SOLICITUD(Lv_CodEmpresa VARCHAR2, Lv_Tipo VARCHAR2, Lv_Estado VARCHAR2)
  IS
  SELECT DISTINCT(IDS.SERVICIO_ID), ids.id_detalle_solicitud, ISER.PLAN_ID, ISER.PRODUCTO_ID
  FROM INFO_DETALLE_SOLICITUD IDS
  LEFT JOIN DB_COMERCIAL.INFO_SERVICIO ISER
    ON IDS.SERVICIO_ID = ISER.ID_SERVICIO
  LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
    ON ISER.PUNTO_ID = PUN.ID_PUNTO
  LEFT JOIN DB_COMERCIAL.INFO_ADENDUM ADE
    ON ISER.ID_SERVICIO = ADE.SERVICIO_ID    
  LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IROL
    ON PUN.PERSONA_EMPRESA_ROL_ID = IROL.ID_PERSONA_ROL
  LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EROL
    ON IROL.EMPRESA_ROL_ID = EROL.ID_EMPRESA_ROL
  LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
    ON IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
  WHERE EROL.EMPRESA_COD = Lv_CodEmpresa
    AND ATS.DESCRIPCION_SOLICITUD in (Lv_Tipo, 'SOLICITUD DE INSTALACION CABLEADO ETHERNET')
    AND IDS.ESTADO = Lv_Estado
    AND ISER.ESTADO = 'PrePlanificada'
    AND IDS.MOTIVO_ID IS NULL
    AND SYSDATE > IDS.FE_CREACION + (to_number((SELECT VALOR1
                                                        FROM DB_GENERAL.ADMI_PARAMETRO_DET 
                                                        WHERE PARAMETRO_ID = (SELECT ID_PARAMETRO 
                                                                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB 
                                                                              WHERE NOMBRE_PARAMETRO = 'TIEMPO_BANDEJA_PLAN_AUTOMATICA' 
                                                                                AND MODULO = 'COMERCIAL' 
                                                                                AND ESTADO = 'Activo')
                                                        AND DESCRIPCION = 'TIEMPO M�XIMO A MOSTRAR EN LA BANDEJA DE PLANIFICACI�N AUTOM�TICA'))/1440)
AND not exists(SELECT servicio_id
               FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
               WHERE SERVICIO_ID = IDS.SERVICIO_ID
                AND ESTADO = 'PrePlanificada'
                AND cast(SUBSTR(OBSERVACION, 0 , 48) as VARCHAR(100)) = 'Se env�a la solicitud a PYL ya que se excedieron')
      AND ADE.TIPO != 'AS' ;
                

  CURSOR C_GET_PARAMETRO(Lv_NombreParametro VARCHAR2, Lv_Estado VARCHAR2, Lv_Descripcion VARCHAR2)
  IS
  SELECT DET.VALOR1, DET.VALOR2, DET.VALOR3, DET.VALOR4
  FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
  LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
  ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
  WHERE CAB.NOMBRE_PARAMETRO = Lv_NombreParametro
    AND CAB.ESTADO = Lv_Estado
    AND DET.DESCRIPCION = Lv_Descripcion
    AND DET.ESTADO = Lv_Estado; 
    
    CURSOR C_GET_SERVICIOS_SIMULTANEOS(Ln_FactibilidadId NUMBER)
    IS
    SELECT 
       SER.ID_SERVICIO, SER.PRODUCTO_ID, nvl((SELECT ID_DETALLE_SOLICITUD FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD WHERE SERVICIO_ID = SER.ID_SERVICIO AND ESTADO = 'PrePlanificada' and ROWNUM =1), 0)  as SOLICITUD_ID
    FROM
       DB_COMERCIAL.INFO_SERVICIO SER
    LEFT JOIN
       DB_COMERCIAL.INFO_ADENDUM ADE
       ON SER.ID_SERVICIO = ADE.SERVICIO_ID
    WHERE ser.punto_id = (select PUNTO_ID 
                          FROM DB_COMERCIAL.INFO_SERVICIO SER
                           LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                             ON ids.servicio_id = ser.id_servicio
                          WHERE ids.id_detalle_solicitud = Ln_FactibilidadId)
      AND SER.ESTADO NOT IN ('Activo', 'Rechazado', 'Rechazada', 'Anulado', 'Anulada')
      AND SER.PRODUCTO_ID IS NOT NULL
      AND not exists(SELECT servicio_id
                     FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL
                     WHERE SERVICIO_ID = SER.ID_SERVICIO
                      AND ESTADO = 'PrePlanificada'
                      AND cast(SUBSTR(OBSERVACION, 0 , 48) as VARCHAR(100)) = 'Se env�a la solicitud a PYL ya que se excedieron')
  
      AND ADE.TIPO != 'AS';    
       
  
    
    Lv_Tiempo VARCHAR2(10);
    Lv_Observacion VARCHAR2(400);
   Lv_ParamV1              VARCHAR2(4000);
   Lv_ParamV2              VARCHAR2(300);
   Lv_ParamV3              VARCHAR2(300);
   Lv_ParamV4              VARCHAR2(300);
   Lv_ProductosPlanif          VARCHAR2(4000) := '';    
    i PLS_INTEGER						:= 0;
   Ln_IdSolicitudProd NUMBER:=0; 

    Lc_Consulta SYS_REFCURSOR := null;

    TYPE Ln_IdSolGestionada             IS TABLE OF NUMBER(10);
    TYPE Ln_IdPlanServicioGestionado    IS TABLE OF NUMBER(10);
    TYPE Lv_DescripcionTipoSolGesionada IS TABLE OF VARCHAR2(70);
    TYPE Ln_IdPlanServicioSimultaneo    IS TABLE OF NUMBER(10);
    TYPE Ln_IdProdServicioSimultaneo    IS TABLE OF NUMBER(10);
    TYPE Lv_DescripServicioSimultaneo   IS TABLE OF VARCHAR2(100);
    TYPE Lv_EstadoServicioSimultaneo    IS TABLE OF VARCHAR2(30);
    TYPE Ln_IdSolSimultanea             IS TABLE OF NUMBER(10);
    TYPE Ln_IdServicioSimultaneo        IS TABLE OF NUMBER(10);
    TYPE Lv_DescripcionTipoSolSim       IS TABLE OF VARCHAR2(70);
    TYPE Lv_EstadoSolSimultanea         IS TABLE OF VARCHAR2(30);
    TYPE Ln_IdDetSolCaract              IS TABLE OF NUMBER(10);
    TYPE Ln_IdPuntoGestionado           IS TABLE OF NUMBER(10);
    TYPE Ln_IdJurisdiccionPunto         IS TABLE OF NUMBER(10);
    TYPE Ln_CupoJurisdiccionPunto       IS TABLE OF NUMBER(10);
    TYPE Lv_Opcion                      IS TABLE OF VARCHAR2(70);


    V_IdSolGestionada                   Ln_IdSolGestionada; 
    V_IdPlanServicioGestionado          Ln_IdPlanServicioGestionado;
    V_DescripcionTipoSolGesionada       Lv_DescripcionTipoSolGesionada;
    V_IdPlanServicioSimultaneo          Ln_IdPlanServicioSimultaneo;
    V_IdServicioSimultaneo              Ln_IdServicioSimultaneo;
    V_IdProdServicioSimultaneo          Ln_IdProdServicioSimultaneo;
    V_DescripServicioSimultaneo         Lv_DescripServicioSimultaneo;
    V_EstadoServicioSimultaneo          Lv_EstadoServicioSimultaneo; 
    V_IdSolSimultanea                   Ln_IdSolSimultanea;
    V_DescripcionTipoSolSim             Lv_DescripcionTipoSolSim;
    V_EstadoSolSimultanea               Lv_EstadoSolSimultanea; 
    V_IdDetSolCaract                    Ln_IdDetSolCaract; 
    V_IdPuntoGestionado                 Ln_IdPuntoGestionado; 
    V_IdJurisdiccionPunto               Ln_IdJurisdiccionPunto;   
    V_CupoJurisdiccionPunto             Ln_CupoJurisdiccionPunto; 
    V_Opcion                            Lv_Opcion;
    
  BEGIN
  dbms_output.put_line('100');
    OPEN C_GET_PARAMETRO('TIEMPO_BANDEJA_PLAN_AUTOMATICA', 'Activo', 'TIEMPO M�XIMO A MOSTRAR EN LA BANDEJA DE PLANIFICACI�N AUTOM�TICA');
    FETCH C_GET_PARAMETRO INTO Lv_Tiempo, Lv_ParamV2, Lv_ParamV3, Lv_ParamV4;
    CLOSE C_GET_PARAMETRO;
    Lv_Observacion := 'Se env�a la solicitud a PYL ya que se excedieron los ' || Lv_Tiempo || ' minutos de la planificaci�n comercial';
    dbms_output.put_line(Lv_Observacion);
    OPEN C_GET_PARAMETRO('PRODUCTOS ADICIONALES MANUALES', 'Activo', 'Productos adicionales manuales para activar');
    FETCH C_GET_PARAMETRO INTO Lv_ParamV1, Lv_ParamV2, Lv_ParamV3, Lv_ParamV4;
    CLOSE C_GET_PARAMETRO;
    Lv_ProductosPlanif := Lv_ProductosPlanif || Lv_ParamV1 || ',' || Lv_ParamV2 || ',' || Lv_ParamV3 || ',' || Lv_ParamV4;

    FOR REG IN GET_DETALLE_SOLICITUD(Pv_CodEmpresa, Pv_Tipo, Pv_Estado) LOOP
      dbms_output.put_line(REG.SERVICIO_ID);
      Ln_IdSolicitudProd :=  REG.id_detalle_solicitud;
      IF (REG.PLAN_ID > 0) THEN  
      dbms_output.put_line('ingreso');
          
          INSERT INTO INFO_SERVICIO_HISTORIAL(ID_SERVICIO_HISTORIAL, SERVICIO_ID, USR_CREACION, FE_CREACION, IP_CREACION, ESTADO, OBSERVACION)
          VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, REG.SERVICIO_ID, 'PLANIF_COMERCIAL', SYSDATE, '127.0.0.1', Pv_Estado, Lv_Observacion);
      END IF;    
      dbms_output.put_line('despues del historial');

      --servicios adicionales
      DB_COMERCIAL.TECNK_SERVICIOS.P_GET_INFO_GESTION_SIMULTANEA(REG.id_detalle_solicitud,
                                                                 NULL,
                                                                 'PLANIFICAR',
                                                                 Pv_Status,
                                                                 Pv_Mensaje,
                                                                 Lc_Consulta);   

      LOOP
        FETCH Lc_Consulta  BULK COLLECT INTO V_IdSolGestionada, V_DescripcionTipoSolGesionada, V_IdPlanServicioGestionado, V_IdServicioSimultaneo, V_IdPlanServicioSimultaneo, V_IdProdServicioSimultaneo, V_DescripServicioSimultaneo, V_EstadoServicioSimultaneo, V_IdSolSimultanea, 
                                             V_DescripcionTipoSolSim, V_EstadoSolSimultanea, V_IdDetSolCaract, V_IdPuntoGestionado, V_IdJurisdiccionPunto, V_CupoJurisdiccionPunto, V_Opcion LIMIT 100;
        EXIT WHEN V_IdSolGestionada.count=0;
        i := V_IdSolGestionada.FIRST;
        WHILE (i IS NOT NULL) 
        LOOP
          INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (ID_SERVICIO_HISTORIAL, SERVICIO_ID, USR_CREACION, FE_CREACION, IP_CREACION, ESTADO, OBSERVACION)
          VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, V_IdServicioSimultaneo(i), 'PLANIF_COMERCIAL', sysdate, '127.0.0.1', Pv_Estado, Lv_Observacion);
          i := V_IdSolGestionada.NEXT(i);
        END LOOP;
        
      END LOOP;
              dbms_output.put_line(Lv_ProductosPlanif);
              dbms_output.put_line(Ln_IdSolicitudProd);
        
      FOR REG1 IN C_GET_SERVICIOS_SIMULTANEOS(Ln_IdSolicitudProd) LOOP
            IF (REG1.SOLICITUD_ID > 0 AND INSTR(Lv_ProductosPlanif, REG1.PRODUCTO_ID) > 0) THEN
            dbms_output.put_line(REG1.PRODUCTO_ID);
              INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (ID_SERVICIO_HISTORIAL, SERVICIO_ID, USR_CREACION, FE_CREACION, IP_CREACION, ESTADO, OBSERVACION)
              VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, REG1.ID_SERVICIO, 'PLANIF_COMERCIAL', sysdate, '127.0.0.1', Pv_Estado, Lv_Observacion);            
            END IF;
      END LOOP;      

    END LOOP;
    
    COMMIT;
  END P_INSERTA_HISTORIAL;


END CMKG_HISTORIAL_SERV_PLANF;
/