SET DEFINE OFF;
create or replace PACKAGE                       DB_SOPORTE.SPKG_PLANIFICACION_COMERCIAL
AS
    /**
      * Documentación para el procedimiento P_PROGRAMAR_SOLICITUD
      *
      * Método que se encarga de realizar la programación de solicitudes
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 17-08-2021
      */
    PROCEDURE P_PROGRAMAR_SOLICITUD (Pcl_Request  IN  CLOB,
                                     Pv_Status    OUT VARCHAR2,
                                     Pv_Mensaje   OUT VARCHAR2,
                                     Pcl_Response OUT SYS_REFCURSOR);


     /**
      * Documentación para el procedimiento P_CONFIRMAR_PLANIFICACION
      *
      * Método que se encarga de asignar responsables de solicitudes
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 11-10-2021
      */
    PROCEDURE P_CONFIRMAR_PLANIFICACION (Pcl_Request  IN  CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,
                                         Pv_Observacion OUT VARCHAR2,
                                         Pcl_Response OUT SYS_REFCURSOR); 

     /**
      * Documentación para el procedimiento P_EJECUTA_GESTION_SIMULTANEA
      *
      * Método que se encarga de ejecutar la gestion simultanea de solicitudes
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 11-10-2021
      */
    PROCEDURE P_EJECUTA_GESTION_SIMULTANEA (Pcl_Request  IN  CLOB,
                                            Pv_Status    OUT VARCHAR2,
                                            Pv_Mensaje   OUT VARCHAR2,
                                            Pcl_Response OUT SYS_REFCURSOR);     



END SPKG_PLANIFICACION_COMERCIAL;
/
create or replace PACKAGE BODY            DB_SOPORTE.SPKG_PLANIFICACION_COMERCIAL AS
  PROCEDURE P_PROGRAMAR_SOLICITUD (Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR)
  IS
  
  CURSOR C_GET_DETALLE_SOLICITUD(Ln_IdFactibilidad NUMBER)
  IS
  SELECT SER.ID_SERVICIO, SER.PRODUCTO_ID, PUN.ID_PUNTO, JUR.ID_JURISDICCION, JUR.CUPO, SER.ESTADO
  FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
  LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
    ON IDS.SERVICIO_ID = SER.ID_SERVICIO
  LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
    ON SER.PUNTO_ID = PUN.ID_PUNTO
  LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JUR
    ON PUN.PUNTO_COBERTURA_ID = JUR.ID_JURISDICCION
  WHERE ID_DETALLE_SOLICITUD = Ln_IdFactibilidad;

  --FETCH C_GET_DETALLE_SOLICITUD INTO Ln_IdServicio, Ln_IdProducto, Ln_IdPunto, Ln_IdJurisdiccion, Ln_Cupo;

  CURSOR C_GET_CARACTERISTICA(Lv_Descripcion VARCHAR2)
  IS
  SELECT ID_CARACTERISTICA
  FROM DB_COMERCIAL.ADMI_CARACTERISTICA
  WHERE DESCRIPCION_CARACTERISTICA = Lv_Descripcion;

  CURSOR C_GET_MOTIVO(Ln_IdMotivo NUMBER)
  IS
  SELECT NOMBRE_MOTIVO
  FROM DB_GENERAL.ADMI_MOTIVO
  WHERE ID_MOTIVO = Ln_IdMotivo;

    CURSOR C_GET_SERVICIOS_SIMULTANEOS(Ln_FactibilidadId NUMBER)
    IS
    SELECT 
       SER.ID_SERVICIO, SER.PRODUCTO_ID, nvl((SELECT ID_DETALLE_SOLICITUD FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD WHERE SERVICIO_ID = SER.ID_SERVICIO AND ESTADO = 'PrePlanificada' and ROWNUM =1), 0)  as SOLICITUD_ID
    FROM
       DB_COMERCIAL.INFO_SERVICIO SER
    WHERE ser.punto_id = (select PUNTO_ID 
                          FROM DB_COMERCIAL.INFO_SERVICIO SER
                           LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                             ON ids.servicio_id = ser.id_servicio
                          WHERE ids.id_detalle_solicitud = Ln_FactibilidadId)
      --AND SER.ESTADO NOT IN ('Activo', 'Rechazado', 'Rechazada', 'Anulado', 'Anulada')
      AND SER.PRODUCTO_ID IS NOT NULL;

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

  Le_Errors              EXCEPTION;
    i PLS_INTEGER						:= 0;

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

  Ln_IdPersonaEmpRolSession NUMBER;
  Lv_Origen                 VARCHAR2(30);
  Ln_IdFactibilidad         NUMBER;
  Ln_IdCuadrilla            NUMBER;
  Lv_Parametro              VARCHAR2(300);
  Lv_ParametroResponsable   VARCHAR2(300);
  Ln_IdPersona              NUMBER;
  Ln_IdPersonaEmpRol        NUMBER;  
  Ln_IdPersonaTecnico       NUMBER;
  Lv_CodEmpresa             VARCHAR2(10);
  Lv_PrefijoEmpresa         VARCHAR2(10);
  Ln_IdDepartamento         NUMBER;
  Ln_IdWifiSim              NUMBER;
  Lv_TipoEsquema            VARCHAR2(300);
  Lv_IdIntCountSim          VARCHAR2(3000);
  Lv_ArraySimultaneos       VARCHAR2(3000);
  Lv_FechaProgramacion      VARCHAR2(30);
  Lv_HoraInicio             VARCHAR2(10);
  Lv_HoraFin                VARCHAR2(10);
  Lv_ObservacionServicio    VARCHAR2(4000);
  Lv_ObservacionPlanif      VARCHAR2(4000);
  Lv_FechaVigencia          VARCHAR2(30);
  Lv_EsHal                  VARCHAR2(1);
  Ln_Opcion                 NUMBER;
  Lv_FechaHoraInicio        VARCHAR2(30);
  Lv_FechaHoraFin           VARCHAR2(30);
  Lv_FechaCombinada         VARCHAR2(30);
  Lv_FechaParametro         VARCHAR2(30);
  Lv_UsrCreacion            VARCHAR2(30);
  Lv_IpCreacion             VARCHAR2(30);
  Lb_ControlaCupo           BOOLEAN := TRUE;
  Ln_IdMotivo               NUMBER := 0;
  Lv_NombreMotivo           VARCHAR2(300);
  Lv_EstadoServicio         VARCHAR2(100);

  Ln_HayProducto         NUMBER;
  Ln_IdServicio          NUMBER := 0;
  Ln_IdProducto          NUMBER;
  Ln_IdServicioHistorial NUMBER;

  Ln_IdPunto             NUMBER := 0;
  Ln_IdJurisdiccion      NUMBER := 0;
  Ln_Cupo                NUMBER := 0;
  Ln_IdCaracteristica    NUMBER;
  Lv_NombreRef           VARCHAR2(300);

   Lv_ParamV1              VARCHAR2(4000);
   Lv_ParamV2              VARCHAR2(300);
   Lv_ParamV3              VARCHAR2(300);
   Lv_ParamV4              VARCHAR2(300);
   Lv_ProductosPlanif          VARCHAR2(4000) := '';


  BEGIN

    APEX_JSON.PARSE(Pcl_Request); 
    Ln_IdPersonaEmpRolSession      := APEX_JSON.get_number(p_path => 'idPersonaEmpRolSession'); 
    Lv_Origen                      := APEX_JSON.get_varchar2(p_path => 'origen');
    Ln_IdFactibilidad              := APEX_JSON.get_number(p_path => 'idFactibilidad');  
    Ln_IdCuadrilla                 := APEX_JSON.get_number(p_path => 'idCuadrilla');  
    Lv_Parametro                   := APEX_JSON.get_varchar2(p_path => 'parametro');
    Lv_ParametroResponsable        := APEX_JSON.get_varchar2(p_path => 'parametroResponsable');
    Ln_IdPersona                   := APEX_JSON.get_number(p_path => 'idPersona'); 
    Ln_IdPersonaEmpRol             := APEX_JSON.get_number(p_path => 'idPersonaEmpRol');
    Ln_IdPersonaTecnico            := APEX_JSON.get_number(p_path => 'idPersonaTecnico');
    Lv_CodEmpresa                  := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Lv_PrefijoEmpresa              := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
    Ln_IdDepartamento              := APEX_JSON.get_number(p_path => 'idDepartamento');
    Ln_IdWifiSim                   := APEX_JSON.get_number(p_path => 'idWifiSim');
    Lv_TipoEsquema                 := APEX_JSON.get_varchar2(p_path => 'tipoEsquema');
    Lv_IdIntCountSim               := APEX_JSON.get_varchar2(p_path => 'idIntCountSim'); 
    Lv_FechaProgramacion           := APEX_JSON.get_varchar2(p_path => 'fechaProgramacion');
    Lv_HoraInicio                  := APEX_JSON.get_varchar2(p_path => 'horaInicio');
    Lv_HoraFin                     := APEX_JSON.get_varchar2(p_path => 'horaFin');   
    Lv_ObservacionServicio         := APEX_JSON.get_varchar2(p_path => 'observacionServicio');
    Lv_ObservacionPlanif           := APEX_JSON.get_varchar2(p_path => 'observacionPlanif');
    Lv_FechaVigencia               := APEX_JSON.get_varchar2(p_path => 'fechaVigencia');
    Ln_Opcion                      := APEX_JSON.get_number(p_path => 'opcion');
    Lv_EsHal                       := APEX_JSON.get_varchar2(p_path => 'esHal');
    Ln_IdMotivo                    := APEX_JSON.get_number(p_path => 'idMotivo');
    Lv_UsrCreacion                 := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_IpCreacion                  := APEX_JSON.get_varchar2(p_path => 'ipCreacion');    


    Lv_FechaHoraInicio     := trim(Lv_FechaProgramacion) || ' ' || trim(Lv_HoraInicio);
    Lv_FechaHoraFin        := trim(Lv_FechaProgramacion) || ' ' || trim(Lv_HoraFin);
    IF (Lv_EsHal = 'S' AND sysdate > to_date(Lv_FechaVigencia,'DD/MM/YYYY HH24:MI:SS') AND Ln_IdMotivo = 0) THEN
      Pv_Mensaje := 'El tiempo de reserva para la sugerencia escogida ha culminado!';
      RAISE Le_Errors;
    END IF;
    OPEN C_GET_DETALLE_SOLICITUD(Ln_IdFactibilidad);
    FETCH C_GET_DETALLE_SOLICITUD INTO Ln_IdServicio, Ln_IdProducto, Ln_IdPunto, Ln_IdJurisdiccion, Ln_Cupo, Lv_EstadoServicio;
    IF C_GET_DETALLE_SOLICITUD%NOTFOUND THEN
      Pv_Mensaje := 'No Existe Solicitud de Planificación!';
      CLOSE C_GET_DETALLE_SOLICITUD; 
      RAISE Le_Errors;
    END IF;
    CLOSE C_GET_DETALLE_SOLICITUD;

    IF (Ln_IdMotivo > 0) THEN
      UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD SET MOTIVO_ID = Ln_IdMotivo WHERE ID_DETALLE_SOLICITUD = Ln_IdFactibilidad;

      OPEN C_GET_MOTIVO(Ln_IdMotivo);
      FETCH C_GET_MOTIVO INTO Lv_NombreMotivo;
      CLOSE C_GET_MOTIVO;

      Lv_ObservacionServicio  := 'Se graba la planificación comercial sin horario. Motivo:' || Lv_NombreMotivo;

      INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (ID_SERVICIO_HISTORIAL, SERVICIO_ID, USR_CREACION, FE_CREACION, IP_CREACION, ESTADO, MOTIVO_ID, OBSERVACION)
      VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, Ln_IdServicio, Lv_UsrCreacion, sysdate, Lv_IpCreacion, Lv_EstadoServicio, Ln_IdMotivo, Lv_ObservacionServicio);

    ELSE
      IF (Ln_Cupo > 0 and Lv_EsHal = 'S') THEN
        Lb_ControlaCupo := FALSE;
      END IF;

      IF (Ln_IdProducto IS NOT NULL AND Lb_ControlaCupo) THEN
        OPEN C_GET_CARACTERISTICA('PRODUCTO CONTROLA CUPO');
        FETCH C_GET_CARACTERISTICA INTO Ln_IdCaracteristica;
        CLOSE C_GET_CARACTERISTICA;
        BEGIN
            SELECT NVL(ID_PRODUCTO_CARACTERISITICA,0) 
            INTO Ln_HayProducto
            FROM DB_COMERCIAL.ADMI_PRODUCTO_CARACTERISTICA 
            WHERE PRODUCTO_ID = Ln_IdProducto AND CARACTERISTICA_ID = Ln_IdCaracteristica;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
              Ln_HayProducto := 0;
        END;

        IF (Ln_HayProducto = 1) THEN
          Lb_ControlaCupo := FALSE;     
        END IF;
      END IF;

      IF (Lv_PrefijoEmpresa = 'MD' AND Ln_Opcion = 0 AND Lb_ControlaCupo) THEN
         Lb_ControlaCupo := FALSE;  
         --se debe quitar la linea superior y poner el llamado a la funcion que controla el cupo web
      END IF;
      IF (Ln_Opcion = 0) THEN
        DB_COMERCIAL.CMKG_PLANIFICACION_COMERCIAL.P_COORDINAR_PLANIFICACION(Pcl_Request, Ln_IdServicioHistorial, Pv_Status, Pv_Mensaje);
        IF (Pv_Status = 'ERROR') THEN
          RAISE Le_Errors;
        END IF;
        DB_COMERCIAL.CMKG_PLANIFICACION_COMERCIAL.P_ASIGNAR_PLANIFICACION(Pcl_Request, Ln_IdServicioHistorial, Pv_Status, Pv_Mensaje, Pcl_Response);
        IF (Pv_Status = 'ERROR') THEN
          RAISE Le_Errors;
        END IF;      

      END IF;
    END IF;  
    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Transacción exitosa';
  EXCEPTION
    WHEN Le_Errors THEN
      DBMS_OUTPUT.PUT_LINE('le_error programar' || Pv_Mensaje);     
      Pv_Status  := 'ERROR';
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM;
      DBMS_OUTPUT.PUT_LINE('other_error programar' || Pv_Mensaje);     

  END P_PROGRAMAR_SOLICITUD;

  PROCEDURE P_CONFIRMAR_PLANIFICACION (Pcl_Request  IN  CLOB,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pv_Observacion OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR)
  IS
    CURSOR C_GET_CUADRILLA(Ln_IdCuadrilla NUMBER)
    IS
    SELECT NOMBRE_CUADRILLA
    FROM DB_COMERCIAL.ADMI_CUADRILLA
    WHERE ID_CUADRILLA = Ln_IdCuadrilla;

    CURSOR C_GET_INTEGRANTES_CUADRILLA(Lv_TipoRol VARCHAR2, Ln_IdCuadrilla NUMBER)
    IS 
    SELECT DISTINCT(IPER.ID_PERSONA) ID_PERSONA, IPER.IDENTIFICACION_CLIENTE, IPER.NOMBRES, IPER.APELLIDOS, IROL.ID_PERSONA_ROL
        FROM DB_COMERCIAL.INFO_PERSONA IPER
        LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IROL
        ON IPER.ID_PERSONA = IROL.PERSONA_ID
        LEFT JOIN DB_COMERCIAL.INFO_EMPRESA_ROL EROL
        ON IROL.EMPRESA_ROL_ID = EROL.ID_EMPRESA_ROL
        LEFT JOIN  DB_COMERCIAL.ADMI_ROL AROL
        ON EROL.ROL_ID = AROL.ID_ROL
        LEFT JOIN DB_COMERCIAL.ADMI_TIPO_ROL ATRO
        ON AROL.TIPO_ROL_ID = ATRO.ID_TIPO_ROL
    WHERE IPER.ESTADO NOT IN ('Cancelado','Inactivo','Anulado','Eliminado')  
      AND IROL.ESTADO NOT IN ('Cancelado','Inactivo','Anulado','Eliminado')
      AND ATRO.DESCRIPCION_TIPO_ROL = Lv_TipoRol
      AND IROL.CUADRILLA_ID = Ln_IdCuadrilla;

    CURSOR C_GET_LIDER_CUADRILLA(Ln_IdPersona NUMBER)
    IS
    SELECT IROL.ID_PERSONA_ROL, IPER.NOMBRES || ' ' || IPER.APELLIDOS AS NOMBRES
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IROL
    LEFT JOIN DB_COMERCIAL.INFO_PERSONA IPER
    ON IROL.PERSONA_ID = IPER.ID_PERSONA
    LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL_CARAC ICAR
    ON ICAR.PERSONA_EMPRESA_ROL_ID = IROL.ID_PERSONA_ROL
    LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA ACAR
    ON ICAR.CARACTERISTICA_ID = ACAR.ID_CARACTERISTICA
    WHERE ACAR.DESCRIPCION_CARACTERISTICA = 'CARGO'
    AND ICAR.VALOR = 'Lider'
    AND IROL.PERSONA_ID = Ln_IdPersona
    AND IROL.ESTADO NOT IN ('Inactivo','Cancelado','Anulado','Eliminado')
    AND ICAR.ESTADO = 'Activo';

    CURSOR C_GET_DETALLE_SOL_HIST_ESTADO(Ln_IdFactibilidad NUMBER, Lv_Estado VARCHAR2)
    IS
    SELECT ID_SOLICITUD_HISTORIAL, OBSERVACION, FE_INI_PLAN, FE_FIN_PLAN
    FROM (SELECT ID_SOLICITUD_HISTORIAL, OBSERVACION, FE_INI_PLAN, FE_FIN_PLAN
          FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST
          WHERE DETALLE_SOLICITUD_ID = Ln_IdFactibilidad
            AND ESTADO = Lv_Estado
            ORDER BY DETALLE_SOLICITUD_ID DESC)
    WHERE ROWNUM = 1;

    CURSOR C_GET_PARTE_AFECTADA(Ln_DetalleId NUMBER)
    IS
    SELECT ID_PARTE_AFECTADA
    FROM DB_SOPORTE.INFO_PARTE_AFECTADA
    WHERE DETALLE_ID = Ln_DetalleId;

    CURSOR C_GET_OBSERVACION(Ln_DetalleId NUMBER)
    IS
    SELECT OBSERVACION
    FROM DB_SOPORTE.info_tarea_seguimiento
    WHERE DETALLE_ID = Ln_DetalleId;

    CURSOR C_GET_DATOS_PUNTO(Ln_IdServicioHistorial NUMBER)
    IS 
    SELECT PUN.ID_PUNTO, PUN.LOGIN, PUN.NOMBRE_PUNTO, SER.ID_SERVICIO,
    CASE WHEN PE1.RAZON_SOCIAL IS NULL THEN PE1.NOMBRES  || ' ' || PE1.APELLIDOS ELSE PE1.RAZON_SOCIAL END,
    PE1.DIRECCION_TRIBUTARIA, PUN.DIRECCION, PUN.DESCRIPCION_PUNTO, PUN.LATITUD, PUN.LONGITUD, PE1.ID_PERSONA, SER.PLAN_ID, JUR.NOMBRE_JURISDICCION, 
    CASE WHEN SER.PLAN_ID IS NULL 
    THEN (SELECT DESCRIPCION_PRODUCTO FROM DB_COMERCIAL.ADMI_PRODUCTO WHERE ID_PRODUCTO = SER.PRODUCTO_ID) 
    ELSE (SELECT NOMBRE_PLAN FROM DB_COMERCIAL.INFO_PLAN_CAB WHERE ID_PLAN = SER.PLAN_ID) END, SER.PRODUCTO_ID
    FROM DB_COMERCIAL.INFO_PUNTO PUN
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
      ON PUN.ID_PUNTO = SER.PUNTO_ID
    LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IROL
      ON PUN.PERSONA_EMPRESA_ROL_ID = IROL.ID_PERSONA_ROL
    LEFT JOIN DB_COMERCIAL.INFO_PERSONA PE1
      ON IROL.PERSONA_ID = PE1.ID_PERSONA
    LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JUR
      ON PUN.PUNTO_COBERTURA_ID = JUR.ID_JURISDICCION
    WHERE SER.ID_SERVICIO = (SELECT SERVICIO_ID 
                             FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL 
                             WHERE ID_SERVICIO_HISTORIAL = Ln_IdServicioHistorial);

    CURSOR C_GET_FORMAS_CONTACTO_PUNTO(Ln_IdPunto NUMBER, Ln_Estado VARCHAR2)  
    IS
    SELECT FOC.DESCRIPCION_FORMA_CONTACTO, IPF.VALOR
    FROM DB_COMERCIAL.INFO_PUNTO_FORMA_CONTACTO IPF
    LEFT JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO FOC
      ON IPF.FORMA_CONTACTO_ID = FOC.ID_FORMA_CONTACTO
    WHERE IPF.PUNTO_ID = Ln_IdPunto
      AND IPF.ESTADO = Ln_Estado
      AND IPF.VALOR IS NOT NULL;

    CURSOR C_GET_DPTO_PERSONA(Ln_IdPersona NUMBER, Lv_CodEmpresa VARCHAR2)
    IS 
    SELECT IROL.DEPARTAMENTO_ID
    FROM DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IROL
    LEFT JOIN DB_COMERCIAL.INFO_OFICINA_GRUPO GRU
      ON IROL.OFICINA_ID = GRU.ID_OFICINA
    WHERE IROL.PERSONA_ID = Ln_IdPersona
      AND GRU.EMPRESA_ID = Lv_CodEmpresa
      and IROL.DEPARTAMENTO_ID IS NOT NULL
      AND IROL.DEPARTAMENTO_ID <> 0
      AND IROL.ESTADO NOT IN ('Inactivo', 'Cancelado', 'Anulado', 'Eliminado');

    CURSOR C_GET_CARACTERISTICA_PLAN (Ln_IdPlan NUMBER,Lv_Descripcion VARCHAR2, Lv_Estado VARCHAR2)      
    IS
    SELECT IPC.ID_PLAN_CARACTERISITCA, IPC.VALOR
    FROM DB_COMERCIAL.INFO_PLAN_CARACTERISTICA IPC 
    LEFT JOIN DB_COMERCIAL.INFO_PLAN_CAB IPB
      ON IPB.ID_PLAN = IPC.PLAN_ID
    LEFT JOIN DB_COMERCIAL.ADMI_CARACTERISTICA AC
      ON AC.ID_CARACTERISTICA = IPC.CARACTERISTICA_ID
    WHERE IPB.ID_PLAN = Ln_IdPlan
      AND AC.DESCRIPCION_CARACTERISTICA = Lv_Descripcion
      AND IPC.ESTADO = Lv_Estado;

   CURSOR C_GET_NOMBRE_TAREA(Ln_DetalleId NUMBER)
   IS 
   SELECT ADM.NOMBRE_TAREA
   FROM DB_SOPORTE.ADMI_TAREA ADM
   LEFT JOIN DB_SOPORTE.INFO_DETALLE DET
     ON ADM.ID_TAREA = DET.TAREA_ID
   WHERE DET.ID_DETALLE = Ln_DetalleId;     

        --CURSOR C_GET_FORMAS_CONTACTO_LOGIN(Lv_Login VARCHAR2, Lv_FormaContacto VARCHAR2)
  Le_Errors         EXCEPTION;
  Lc_Consulta SYS_REFCURSOR := null;

  Ln_IdDetalle           NUMBER;
  Ln_IdComunicacion      NUMBER;
  Ln_IdAsignado          NUMBER;
  Ln_IdServicioHistorial NUMBER;
  Ln_IdFactibilidad      NUMBER;
  Lv_NombreCuadrilla     VARCHAR2(400);
  Ln_RefAsignadoId       NUMBER;
  Lv_NombreRef           VARCHAR2(400);
  Ln_IdPersonaEmpresaRol NUMBER;
  Ln_IdPersona           NUMBER;
  Lv_Identificacion      VARCHAR2(30);
  Lv_Nombres             VARCHAR2(200);
  Lv_Apellidos           VARCHAR2(200);
  Ln_DetalleSolHist      NUMBER;
  Ln_IdParteAfectada     NUMBER;
  Lv_NombrePunto         VARCHAR2(1000);
  Lv_LoginPunto          VARCHAR2(100);
  Ln_IdPunto             NUMBER;
  Ln_IdServicio          NUMBER;
  Lv_CodEmpresa          VARCHAR2(5);

  Lv_FechaHal         VARCHAR2(30);
  Lv_HoraIniHal       VARCHAR2(20);
  Lv_HoraFinHal       VARCHAR2(20);
  Lv_FechaHoraInicio  VARCHAR2(20);
  Lv_FechaHoraFin     VARCHAR2(20);
  Lv_IpCreacion       VARCHAR2(30);
  Lv_FeCreacion       VARCHAR2(30);
  Lv_UsrCreacion      VARCHAR2(30);
  Lb_HayLider         BOOLEAN := false;
  Lv_Observacion      VARCHAR2(4000);
  Lv_ObservacionSol   VARCHAR2(4000);
  Lv_Opcion           VARCHAR2(1000);
  Lv_ObservacionData  VARCHAR2(4000);
  Lv_NombreCliente    VARCHAR2(300);
  Lv_ObservacionPlan  VARCHAR2(4000);
  Lv_DireccionTributa VARCHAR2(400);
  Lv_DireccionPunto   VARCHAR2(400);
  Lv_DescripcionPunto VARCHAR2(400);
  Lv_Latitud          VARCHAR2(50);
  Lv_Longitud         VARCHAR2(50);
  Lb_Primera          BOOLEAN := true;
  Ln_IdDepartamento   NUMBER;
  Ln_IdPlanCaract     NUMBER;
  Lv_ValorCaract      NUMBER;
  Lb_FlujoAsignado    BOOLEAN := false;
  Ln_IdPlan           NUMBER;
  Lv_NombrePlan       VARCHAR2(400);
  Ld_FeIniPlan        DATE;
  Ld_FeFinPlan        DATE;
  Lv_NombreLider      VARCHAR2(400);
  Ln_IdPerLider       NUMBER;
  Ln_IdPerEmpLider    NUMBER;
  Lv_ObservacionSeg   VARCHAR2(400);
  Lv_GestionSimultanea VARCHAR2(1) := 'N';
  Lv_NombreTarea       VARCHAR2(150); 
  Lv_NombreJurisdiccion VARCHAR2(300);
  Ln_IdDetalleAsignacion NUMBER;
  Ln_IdProducto          NUMBER;
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Ln_IdDetalle           := APEX_JSON.get_number(p_path => 'idDetalle');   
    Ln_IdComunicacion      := APEX_JSON.get_number(p_path => 'idComunicacion');
    Ln_IdAsignado          := APEX_JSON.get_number(p_path => 'idAsignado');
    Ln_IdServicioHistorial := APEX_JSON.get_number(p_path => 'idServicioHistorial');
    Ln_IdFactibilidad      := APEX_JSON.get_number(p_path => 'idFactibilidad');
    Lv_CodEmpresa          := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Lv_ObservacionPlan     := APEX_JSON.get_varchar2(p_path => 'observacion');    
    Lv_FechaHal       := APEX_JSON.get_varchar2(p_path => 'fechaHal');
    Lv_HoraIniHal     := APEX_JSON.get_varchar2(p_path => 'horaIniHal');
    Lv_HoraFinHal     := APEX_JSON.get_varchar2(p_path => 'horaFinHal');

    Lv_IpCreacion     := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
    Lv_UsrCreacion    := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
    Lv_GestionSimultanea := APEX_JSON.get_varchar2(p_path => 'gestionSimultanea');

    Lv_FechaHoraInicio     := trim(Lv_FechaHal) || ' ' || trim(Lv_HoraIniHal);
    Lv_FechaHoraFin        := trim(Lv_FechaHal) || ' ' || trim(Lv_HoraFinHal); 


    UPDATE DB_SOPORTE.INFO_DETALLE SET FE_SOLICITADA = to_date(Lv_FechaHoraInicio,'DD/MM/YYYY HH24:MI:SS') WHERE ID_DETALLE = Ln_IdDetalle;
    OPEN C_GET_CUADRILLA(Ln_IdAsignado);
    FETCH C_GET_CUADRILLA INTO Lv_NombreCuadrilla;
    CLOSE C_GET_CUADRILLA; 

    FOR REG IN C_GET_INTEGRANTES_CUADRILLA('Empleado', Ln_IdAsignado) LOOP
      Ln_IdPersonaEmpresaRol := REG.ID_PERSONA_ROL;
      dbms_output.put_line('' || Ln_IdPersonaEmpresaRol || ' ' || Lv_NombreLider);
      Ln_IdPersona           := REG.ID_PERSONA; 
      Lv_NombreRef           := REG.NOMBRES || ' ' || REG.APELLIDOS;
      INSERT INTO DB_SOPORTE.INFO_CUADRILLA_TAREA (ID_CUADRILLA_TAREA, DETALLE_ID, CUADRILLA_ID, PERSONA_ID, USR_CREACION, FE_CREACION, IP_CREACION)
      VALUES(DB_SOPORTE.SEQ_INFO_CUADRILLA_TAREA.NEXTVAL,Ln_IdDetalle, Ln_IdAsignado, REG.ID_PERSONA, Lv_UsrCreacion, to_date(to_char(sysdate, 'DD-MM-YYYY'), 'DD/MM/YYYY')  , Lv_IpCreacion );
          --C_GET_LIDER_CUADRILLA
      IF (Lv_NombreLider IS NULL) THEN    
      dbms_output.put_line('entro al if');
        OPEN C_GET_LIDER_CUADRILLA(Ln_IdPersona);
        FETCH C_GET_LIDER_CUADRILLA INTO Ln_IdPerLider, Lv_NombreLider;
        IF C_GET_LIDER_CUADRILLA%NOTFOUND THEN
          dbms_output.put_line('not found');
          Ln_IdPerLider := 0;
          Lv_NombreLider := NULL;
          Ln_IdPerEmpLider := 0;
        END IF;
        CLOSE C_GET_LIDER_CUADRILLA;  
        Ln_IdPerEmpLider := Ln_IdPerLider;  
        Ln_IdPerLider := Ln_IdPersona;
      END IF;
    END LOOP;
    --CLOSE C_GET_INTEGRANTES_CUADRILLA; 

    IF (Lv_NombreLider IS NULL) THEN
      Ln_IdPerEmpLider := Ln_IdPersonaEmpresaRol;
      Ln_IdPerLider := Ln_IdPersona;
      Lv_NombreLider := Lv_NombreRef;   
    END IF;
    dbms_output.put_line('lider emp rol' || Ln_IdPerEmpLider);  
    dbms_output.put_line('lider ' || Ln_IdPerLider);
    Lb_Primera := TRUE;
    FOR REG IN C_GET_DPTO_PERSONA(Ln_IdPersona, Lv_CodEmpresa) LOOP
      IF (Lb_Primera = TRUE) THEN
        Ln_IdDepartamento := REG.DEPARTAMENTO_ID; 
        Lb_Primera := FALSE;
      END IF;
    END LOOP;      

    --INSERT INTO DB_SOPORTE.INFO_DETALLE_HISTORIAL (ID_DETALLE_HISTORIAL, DETALLE_ID, OBSERVACION, USR_CREACION, ASIGNADO_ID, ACCION, DEPARTAMENTO_ORIGEN_ID, ESTADO, FE_CREACION, IP_CREACION)
    --VALUES (DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL, Ln_IdDetalle, 'Tarea Asignada', Lv_UsrCreacion, Ln_IdAsignado, 'Asignada', Ln_IdDepartamento, 'Asignada', SYSDATE, Lv_IpCreacion);

    INSERT INTO DB_SOPORTE.INFO_DETALLE_ASIGNACION (ID_DETALLE_ASIGNACION, DETALLE_ID, ASIGNADO_ID, ASIGNADO_NOMBRE, REF_ASIGNADO_ID, REF_ASIGNADO_NOMBRE, PERSONA_EMPRESA_ROL_ID, TIPO_ASIGNADO, IP_CREACION, FE_CREACION, USR_CREACION)
    VALUES (DB_SOPORTE.SEQ_INFO_DETALLE_ASIGNACION.NEXTVAL, Ln_IdDetalle, Ln_IdAsignado, Lv_NombreCuadrilla, Ln_IdPerLider, Lv_NombreLider, Ln_IdPerEmpLider, 'CUADRILLA', Lv_IpCreacion, SYSDATE, Lv_UsrCreacion)
    RETURNING ID_DETALLE_ASIGNACION INTO Ln_IdDetalleAsignacion;

    FOR REG IN C_GET_INTEGRANTES_CUADRILLA('Empleado', Ln_IdAsignado) LOOP
      Ln_IdPersonaEmpresaRol := REG.ID_PERSONA_ROL;
      dbms_output.put_line('' || Ln_IdPersonaEmpresaRol || ' ' || Lv_NombreLider);
      Ln_IdPersona           := REG.ID_PERSONA; 
      Lv_NombreRef           := REG.NOMBRES || ' ' || REG.APELLIDOS;

      INSERT INTO DB_SOPORTE.INFO_DETALLE_COLABORADOR(ID_COLABORADOR, DETALLE_ASIGNACION_ID, ASIGNADO_ID, ASIGNADO_NOMBRE, REF_ASIGNADO_ID,  REF_ASIGNADO_NOMBRE, USR_CREACION, FE_CREACION, IP_CREACION)
      VALUES (DB_SOPORTE.SEQ_INFO_DETALLE_COLABORADOR.NEXTVAL, Ln_IdDetalleAsignacion, 128, 'Operaciones Urbanas', Ln_IdPersona, Lv_NombreRef, Lv_UsrCreacion, SYSDATE, Lv_IpCreacion);
    END LOOP;

    OPEN C_GET_DETALLE_SOL_HIST_ESTADO(Ln_IdFactibilidad, 'AsignadoTarea');
    FETCH C_GET_DETALLE_SOL_HIST_ESTADO INTO Ln_DetalleSolHist, Lv_ObservacionSol, Ld_FeIniPlan, Ld_FeFinPlan;
    IF C_GET_DETALLE_SOL_HIST_ESTADO%NOTFOUND THEN
      Ln_DetalleSolHist := 0;
    END IF;

    CLOSE C_GET_DETALLE_SOL_HIST_ESTADO;    

    UPDATE DB_COMERCIAL.INFO_DETALLE_SOL_HIST 
    SET FE_INI_PLAN = to_date(Lv_FechaHoraInicio,'DD/MM/YYYY HH24:MI:SS'),
        FE_FIN_PLAN = to_date(Lv_FechaHoraFin,'DD/MM/YYYY HH24:MI:SS')
    WHERE ID_SOLICITUD_HISTORIAL = Ln_DetalleSolHist;

    OPEN C_GET_OBSERVACION(Ln_IdDetalle);
    FETCH C_GET_OBSERVACION INTO Lv_ObservacionPlan;
    IF C_GET_OBSERVACION%NOTFOUND THEN
       Lv_ObservacionPlan := '';
    END IF;
    CLOSE C_GET_OBSERVACION;  


    Lv_Observacion := '<br>' || Lv_ObservacionPlan || '<br>';
    Lv_Observacion := Lv_Observacion || '<br>Fecha Planificada: ' || Lv_FechaHal;
    Lv_Observacion := Lv_Observacion || '<br>Hora Inicio: ' || Lv_HoraIniHal;
    Lv_Observacion := Lv_Observacion || '<br>Hora Fin: ' || Lv_HoraFinHal;

    UPDATE DB_COMERCIAL.INFO_SERVICIO_HISTORIAL  
    SET OBSERVACION = Lv_Observacion
    WHERE ID_SERVICIO_HISTORIAL = Ln_IdServicioHistorial; 

    Lv_Observacion := Lv_Observacion || '<br>Asignada a: Cuadrilla';
    Lv_Observacion := Lv_Observacion || '<br>Nombre: ' || Lv_NombreCuadrilla;
    Lv_Observacion := Lv_Observacion || '<br>Lider de Cuadrilla: ' || Lv_NombreLider;
    Lv_Observacion := Lv_Observacion || '<br><br>';

    INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST  (ID_SOLICITUD_HISTORIAL, DETALLE_SOLICITUD_ID, FE_INI_PLAN, FE_FIN_PLAN, OBSERVACION,
                                                     IP_CREACION, FE_CREACION, USR_CREACION, ESTADO)
    VALUES(DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL, Ln_IdFactibilidad, to_date(Lv_FechaHoraInicio,'DD/MM/YYYY HH24:MI:SS'),
            to_date(Lv_FechaHoraFin,'DD/MM/YYYY HH24:MI:SS'), Lv_ObservacionSol, Lv_IpCreacion, SYSDATE, Lv_UsrCreacion, 'AsignadoTarea');
    --C_GET_PARTE_AFECTADA  
    OPEN C_GET_PARTE_AFECTADA(Ln_IdDetalle);
    FETCH C_GET_PARTE_AFECTADA INTO Ln_IdParteAfectada;
    IF C_GET_PARTE_AFECTADA%NOTFOUND THEN
       Ln_IdParteAfectada := NULL;
    END IF;
    CLOSE C_GET_PARTE_AFECTADA;  

    --C_GET_NOMBRE_PUNTO
    OPEN C_GET_DATOS_PUNTO(Ln_IdServicioHistorial);
    FETCH C_GET_DATOS_PUNTO INTO Ln_IdPunto, Lv_LoginPunto, Lv_NombrePunto, Ln_IdServicio, Lv_NombreCliente, Lv_DireccionTributa,
                                 Lv_DireccionPunto, Lv_DescripcionPunto, Lv_Latitud, Lv_Longitud, Ln_IdPersona, Ln_IdPlan, Lv_NombreJurisdiccion, Lv_NombrePlan, Ln_IdProducto;
    IF C_GET_DATOS_PUNTO%NOTFOUND THEN
       Lv_NombrePunto := NULL;
    END IF;
    Lv_Opcion := 'Cliente: ' || Lv_NombrePunto || ' | OPCION: Punto Cliente';
    CLOSE C_GET_DATOS_PUNTO;       
    IF (Ln_IdParteAfectada IS NULL) THEN 
      INSERT INTO DB_SOPORTE.INFO_CRITERIO_AFECTADO (ID_CRITERIO_AFECTADO, DETALLE_ID, CRITERIO, OPCION, USR_CREACION, FE_CREACION, IP_CREACION)
      VALUES (DB_SOPORTE.SEQ_INFO_CRITERIO_AFECTADO.NEXTVAL, Ln_IdDetalle, 'Clientes', Lv_Opcion, Lv_UsrCreacion, SYSDATE, Lv_IpCreacion)
      RETURNING ID_CRITERIO_AFECTADO INTO Ln_IdParteAfectada;

      INSERT INTO DB_SOPORTE.INFO_PARTE_AFECTADA(ID_PARTE_AFECTADA, CRITERIO_AFECTADO_ID, DETALLE_ID, AFECTADO_ID, TIPO_AFECTADO, AFECTADO_NOMBRE, AFECTADO_DESCRIPCION, 
                                                 FE_INI_INCIDENCIA, USR_CREACION, FE_CREACION, IP_CREACION)
      VALUES (DB_SOPORTE.SEQ_INFO_PARTE_AFECTADA.NEXTVAL, Ln_IdParteAfectada, Ln_IdDetalle, Ln_IdPunto, 'Cliente', Lv_LoginPunto, Lv_NombrePunto,
              to_date(Lv_FechaHoraInicio,'DD/MM/YYYY HH24:MI:SS'), Lv_UsrCreacion, SYSDATE, Lv_IpCreacion);
    END IF;

    UPDATE DB_COMERCIAL.INFO_SERVICIO SET ESTADO = 'AsignadoTarea' WHERE ID_SERVICIO =  Ln_IdServicio;
    INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (ID_SERVICIO_HISTORIAL, SERVICIO_ID, IP_CREACION, FE_CREACION, USR_CREACION, ESTADO, OBSERVACION)
    VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, Ln_IdServicio, Lv_IpCreacion, SYSDATE, Lv_UsrCreacion, 'AsignadoTarea', Lv_Observacion);

    --aqui los cambios de productos adicionales
    Lv_ObservacionData := '<b>Informaci&oacute;n del Cliente</b><br/>';
    Lv_ObservacionData := Lv_ObservacionData || 'Nombre: ' || Lv_NombreCliente || '<br/>';
    Lv_ObservacionData := Lv_ObservacionData || 'Direcci&oacute;n: ' || Lv_DireccionTributa || '<br/>';
    Lv_ObservacionData := Lv_ObservacionData || '<br/><b>Informaci&oacute;n del Punto</b><br/>';
    Lv_ObservacionData := Lv_ObservacionData || 'Nombre: ' || Lv_NombrePunto || '<br/>';
    Lv_ObservacionData := Lv_ObservacionData || 'Direcci&oacute;n: ' || Lv_DireccionPunto || '<br/>';
    Lv_ObservacionData := Lv_ObservacionData || 'Referencia: ' || Lv_DescripcionPunto || '<br/>';
    Lv_ObservacionData := Lv_ObservacionData || 'Latitud: ' || Lv_Latitud || '<br/>';
    Lv_ObservacionData := Lv_ObservacionData || 'Longitud: ' || Lv_Longitud || '<br/><br/>';

    FOR REG IN C_GET_FORMAS_CONTACTO_PUNTO(Ln_IdPunto, 'Activo') LOOP
      IF (Lb_Primera = TRUE) THEN
        Lv_ObservacionData := Lv_ObservacionData || 'Contactos<br/>';
        Lb_Primera := FALSE;
      END IF;
      Lv_ObservacionData := Lv_ObservacionData || REG.DESCRIPCION_FORMA_CONTACTO || ': ' || REG.VALOR || '<br/>';
    END LOOP;
    Lb_Primera := TRUE;
    FOR REG IN C_GET_DPTO_PERSONA(Ln_IdPersona, Lv_CodEmpresa) LOOP
      IF (Lb_Primera = TRUE) THEN
        Ln_IdDepartamento := REG.DEPARTAMENTO_ID; 
        Lb_Primera := FALSE;
      END IF;
    END LOOP;  
    INSERT INTO DB_SOPORTE.INFO_DETALLE_HISTORIAL(ID_DETALLE_HISTORIAL, DETALLE_ID, OBSERVACION, ESTADO, USR_CREACION, FE_CREACION, IP_CREACION, ASIGNADO_ID, PERSONA_EMPRESA_ROL_ID, DEPARTAMENTO_ORIGEN_ID, DEPARTAMENTO_DESTINO_ID, ACCION)
    VALUES (DB_SOPORTE.SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL, Ln_IdDetalle, 'Tarea Asignada', 'Asignada', Lv_UsrCreacion, SYSDATE, Lv_IpCreacion, null, Ln_IdPersonaEmpresaRol, Ln_IdDepartamento, Ln_IdDepartamento, 'Asignada' );    
    IF (Lv_NombreCuadrilla IS  NULL) THEN
      Lv_ObservacionSeg := 'Tarea Asignada a ' || Lv_NombreLider;
    ELSE
      Lv_ObservacionSeg := 'Tarea Asignada a ' || Lv_NombreCuadrilla;
    END IF;

    INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO(ID_SEGUIMIENTO, DETALLE_ID, OBSERVACION, EMPRESA_COD, USR_CREACION, ESTADO_TAREA, FE_CREACION, INTERNO, DEPARTAMENTO_ID)
    VALUES (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL, Ln_IdDetalle, Lv_ObservacionSeg, Lv_CodEmpresa, Lv_UsrCreacion , 'Asignada', SYSDATE, 'N', Ln_IdDepartamento);

    --Ln_IdPersonaEmpresaRol
    INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO (ID_SEGUIMIENTO, DETALLE_ID, OBSERVACION, EMPRESA_COD, USR_CREACION, ESTADO_TAREA, FE_CREACION, INTERNO, DEPARTAMENTO_ID)
    VALUES (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL, Ln_IdDetalle, Lv_ObservacionData, Lv_CodEmpresa, Lv_UsrCreacion, 'AsignadoTarea', SYSDATE, 'N', Ln_IdDepartamento);
    --C_GET_CARACTERISTICA_PLAN
    OPEN C_GET_CARACTERISTICA_PLAN(Ln_IdPlan, 'FLUJO_PREPLANIFICACION_PLANIFICACION', 'Activo');
    FETCH C_GET_CARACTERISTICA_PLAN INTO Ln_IdPlanCaract, Lv_ValorCaract;
    IF C_GET_CARACTERISTICA_PLAN%NOTFOUND THEN
       Lv_ValorCaract := NULL;
       Ln_IdPlanCaract := 0;
    END IF;
    IF (Ln_IdProducto IS NOT NULL) THEN
      UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD SET ESTADO = 'Asignada' WHERE ID_DETALLE_SOLICITUD = Ln_IdFactibilidad;

      INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST(ID_SOLICITUD_HISTORIAL, DETALLE_SOLICITUD_ID, FE_INI_PLAN, FE_FIN_PLAN, OBSERVACION,
                                                     IP_CREACION, FE_CREACION, USR_CREACION, ESTADO)
      VALUES (DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL, Ln_IdFactibilidad, Ld_FeIniPlan, Ld_FeFinPlan, Lv_ObservacionSol, Lv_IpCreacion, SYSDATE, Lv_UsrCreacion, 'Asignada');

      UPDATE DB_COMERCIAL.INFO_SERVICIO SET ESTADO = 'Asignada' WHERE ID_SERVICIO = Ln_IdServicio;
      INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (ID_SERVICIO_HISTORIAL, SERVICIO_ID, IP_CREACION, FE_CREACION, USR_CREACION, ESTADO, OBSERVACION)
      VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, Ln_IdServicio, Lv_IpCreacion, SYSDATE, Lv_UsrCreacion, 'Asignada', 'Por ser ' || Lv_NombrePlan || ' Pasa a: Asignada'  );      
    ELSE

        INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (ID_SERVICIO_HISTORIAL, SERVICIO_ID, IP_CREACION, FE_CREACION, USR_CREACION, ESTADO, OBSERVACION)
        VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, Ln_IdServicio, Lv_IpCreacion, SYSDATE, Lv_UsrCreacion, 'AsignadoTarea', 'Se graba la planificación comercial con horario ' || Lv_FechaHoraInicio || ' y cuadrilla ' || Lv_NombreCuadrilla);
    END IF;
    DB_SOPORTE.SPKG_INFO_TAREA.P_CREA_INFO_TAREA(Ln_IdDetalle,
                                                 Lv_UsrCreacion,
                                                 Pv_Status,
                                                 Pv_Mensaje);

    IF (lower(Pv_Status) = 'error') THEN
          RAISE Le_Errors;
    END IF;                                                  
    Pv_Status     := 'OK';
    Pv_Mensaje    := 'Se asignaron la(s) Tarea(s) Correctamente.';   
    Pv_Observacion := '<br>Asignada a: Empleado';
    Pv_Observacion := Pv_Observacion || '<br> Nombre: ' || Lv_NombreCuadrilla;
    Pv_Observacion := Pv_Observacion || '<br> Departamento: ' || Lv_NombreCuadrilla;
    COMMIT;
    OPEN C_GET_NOMBRE_TAREA(Ln_IdDetalle);
    FETCH C_GET_NOMBRE_TAREA INTO Lv_NombreTarea;
    IF C_GET_NOMBRE_TAREA%NOTFOUND THEN
       Lv_NombreTarea:= '';
    END IF;

      OPEN Pcl_Response FOR SELECT Ln_IdComunicacion as idTarea,
                                   Lv_NombreCliente as nombreCliente,
                                   Lv_LoginPunto as login, 
                                   Lv_NombreJurisdiccion as nombreJurisdiccion,
                                   Lv_DireccionPunto     as direccion,
                                   Lv_NombrePlan as descripcionProducto,                                   
                                   sysdate as feCreacion,
                                   Lv_UsrCreacion as usrCreacion,
                                   to_date(Lv_FechaHoraFin,'DD/MM/YYYY HH24:MI:SS') as fechaAsignacion,
                                   Lv_HoraIniHal as horaAsignacion,
                                   Lv_UsrCreacion as usrAsignacion,
                                   Lv_NombreTarea as nombreTarea,
                                   Lv_NombreCuadrilla as asignadoNombre,
                                   Lv_NombreCuadrilla as refAsignadoNombre,                                    
                                   'AsignadoTarea' as estadoTarea
                                   FROM DUAL;


    EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      dbms_output.put_line('error confirmar  => ' || Pv_Mensaje);
      --ROLLBACK;
    WHEN OTHERS THEN
      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM; 
      dbms_output.put_line('error confirmar => ' || Pv_Mensaje);
      --ROLLBACK;  
  END P_CONFIRMAR_PLANIFICACION;   


  PROCEDURE P_EJECUTA_GESTION_SIMULTANEA (Pcl_Request  IN  CLOB,
                                   Pv_Status    OUT VARCHAR2,
                                   Pv_Mensaje   OUT VARCHAR2,
                                   Pcl_Response OUT SYS_REFCURSOR)
  IS
      CURSOR C_GET_CARACTERISTICA(Lv_Descripcion VARCHAR2, Lv_Estado VARCHAR2)
      IS
      SELECT ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = Lv_Descripcion
        AND ESTADO = Lv_Estado;  

    CURSOR C_GET_SERVICIOS_SIMULTANEOS(Ln_FactibilidadId NUMBER)
    IS
    SELECT 
       SER.ID_SERVICIO, SER.PRODUCTO_ID, nvl((SELECT ID_DETALLE_SOLICITUD FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD WHERE SERVICIO_ID = SER.ID_SERVICIO AND ESTADO = 'PrePlanificada' and ROWNUM =1), 0)  as SOLICITUD_ID
    FROM
       DB_COMERCIAL.INFO_SERVICIO SER
    WHERE ser.punto_id = (select PUNTO_ID 
                          FROM DB_COMERCIAL.INFO_SERVICIO SER
                           LEFT JOIN DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
                             ON ids.servicio_id = ser.id_servicio
                          WHERE ids.id_detalle_solicitud = Ln_FactibilidadId)
      --AND SER.ESTADO NOT IN ('Activo', 'Rechazado', 'Rechazada', 'Anulado', 'Anulada')
      AND SER.PRODUCTO_ID IS NOT NULL;

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

--OPEN C_GET_PARAMETRO('PRODUCTOS ADICIONALES MANUALES', 'Activo', 'Productos adicionales manuales para activar');
    Ln_IdFactibilidad      NUMBER;
    Lv_PclRequest          VARCHAR2(4000);
    Pv_Observacion         VARCHAR2(4000);
   Lv_ParamV1              VARCHAR2(4000);
   Lv_ParamV2              VARCHAR2(300);
   Lv_ParamV3              VARCHAR2(300);
   Lv_ParamV4              VARCHAR2(300);
   Lv_ProductosPlanif          VARCHAR2(4000) := '';

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

    TYPE Ln_IdDetalleSolicitud     IS TABLE OF NUMBER(10);
    TYPE Lv_NombreCliente          IS TABLE OF VARCHAR2(200);
    TYPE Lv_Login                  IS TABLE OF VARCHAR2(50);
    TYPE Lv_Destinatarios          IS TABLE OF VARCHAR2(4000);
    TYPE Lv_NombreJurisdiccion     IS TABLE OF VARCHAR2(200);
    TYPE Lv_Direccion              IS TABLE OF VARCHAR2(4000);
    TYPE Lv_DescripcionProducto    IS TABLE OF VARCHAR2(1000);
    TYPE Ld_FeCreacion             IS TABLE OF DATE;
    TYPE Lv_UsrCreacion            IS TABLE OF VARCHAR2(50);
    TYPE Ld_FechaPlanificacion     IS TABLE OF DATE;
    TYPE Lv_UsrPlanificacion       IS TABLE OF VARCHAR2(50);
    TYPE Lv_Observacion            IS TABLE OF VARCHAR2(4000);
    TYPE Lv_Estado                 IS TABLE OF VARCHAR2(30);
    TYPE Ln_IdDetalle              IS TABLE OF NUMBER(10);
    TYPE Ln_IdComunicacion         IS TABLE OF NUMBER(10);
    TYPE Ln_IdSevicioHistorial     IS TABLE OF NUMBER(10);
    TYPE Lv_AsignadoNombre         IS TABLE OF VARCHAR2(300);    
    TYPE Lv_RefAsignadoNombre      IS TABLE OF VARCHAR2(300);    
    TYPE Lv_Nombretarea            IS TABLE OF VARCHAR2(300);    

    V_IdDetalleSolicitud Ln_IdDetalleSolicitud;
    V_NombreCliente Lv_NombreCliente;
    V_Login Lv_Login;
    V_Destinatarios Lv_Destinatarios;
    V_NombreJurisdiccion Lv_NombreJurisdiccion;
    V_Direccion Lv_Direccion;
    V_DescripcionProducto Lv_DescripcionProducto;
    V_FeCreacion Ld_FeCreacion;
    V_UsrCreacion Lv_UsrCreacion;
    V_FechaPlanificacion Ld_FechaPlanificacion;
    V_UsrPlanificacion Lv_UsrPlanificacion;
    V_Observacion Lv_Observacion;
    V_Estado Lv_Estado;
    V_IdDetalle Ln_IdDetalle;
    V_IdComunicacion Ln_IdComunicacion;
    V_IdSevicioHistorial Ln_IdSevicioHistorial;
    V_AsignadoNombre Lv_AsignadoNombre;
    V_RefAsignadoNombre Lv_RefAsignadoNombre;
    V_Nombretarea Lv_Nombretarea;

    Le_Errors         EXCEPTION;    
    i PLS_INTEGER						:= 0;
    j PLS_INTEGER						:= 0;
    Ln_IdPunto NUMBER := 0;
  BEGIN
    APEX_JSON.PARSE(Pcl_Request); 

    Ln_IdFactibilidad      := APEX_JSON.get_number(p_path => 'idFactibilidad');
dbms_output.put_line('fact 0 ' || Ln_IdFactibilidad);
    DB_COMERCIAL.TECNK_SERVICIOS.P_GET_INFO_GESTION_SIMULTANEA(Ln_IdFactibilidad,
                                                                NULL,
                                                                'PLANIFICAR',
                                                                Pv_Status,
                                                                Pv_Mensaje,
                                                                Lc_Consulta);   

      LOOP
        FETCH Lc_Consulta  BULK COLLECT INTO V_IdSolGestionada, V_DescripcionTipoSolGesionada, V_IdPlanServicioGestionado, V_IdServicioSimultaneo, V_IdPlanServicioSimultaneo, V_IdProdServicioSimultaneo, V_DescripServicioSimultaneo, V_EstadoServicioSimultaneo, V_IdSolSimultanea, 
                                             V_DescripcionTipoSolSim, V_EstadoSolSimultanea, V_IdDetSolCaract, V_IdPuntoGestionado, V_IdJurisdiccionPunto, V_CupoJurisdiccionPunto, V_Opcion LIMIT 100;
           dbms_output.put_line('entro');                                             
        EXIT WHEN V_IdSolGestionada.count=0;
        i := V_IdSolGestionada.FIRST;
        WHILE (i IS NOT NULL) 
        LOOP
        dbms_output.put_line('entro 2');                                       
            Ln_IdPunto := V_IdPuntoGestionado(i);
            Lv_PclRequest := '{"idPersonaEmpRolSession": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idPersonaEmpRolSession'); 
            Lv_PclRequest := Lv_PclRequest || ',"origen": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.origen') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"idFactibilidad": ' || V_IdSolSimultanea(i); 
            Lv_PclRequest := Lv_PclRequest || ',"parametro": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.parametro') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"idPersonaTecnico": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idPersonaTecnico'); 
            Lv_PclRequest := Lv_PclRequest || ',"codEmpresa": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.codEmpresa') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"prefijoEmpresa": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.prefijoEmpresa') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"idDepartamento": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idDepartamento') ; 
            Lv_PclRequest := Lv_PclRequest || ',"idWifiSim": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idWifiSim'); 
            Lv_PclRequest := Lv_PclRequest || ',"fechaProgramacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.fechaProgramacion') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"horaInicio": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.horaInicio') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"horaFin": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.horaFin') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"observacionServicio": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.observacionServicio') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"observacionPlanif": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.observacionPlanif') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"fechaVigencia": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.fechaVigencia') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"opcion": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.opcion') ; 
            Lv_PclRequest := Lv_PclRequest || ',"esHal": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.esHal') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"idMotivo": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idMotivo'); 
            Lv_PclRequest := Lv_PclRequest || ',"usrCreacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.usrCreacion') || '"'; 
            Lv_PclRequest := Lv_PclRequest || ',"ipCreacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.ipCreacion') || '"'; 
            Lv_PclRequest := Lv_PclRequest || '}';


           dbms_output.put_line('P_PROGRAMAR_SOLICITUD => ' || Lv_PclRequest);

          DB_SOPORTE.SPKG_PLANIFICACION_COMERCIAL.P_PROGRAMAR_SOLICITUD (Lv_PclRequest, Pv_Status, Pv_Mensaje, Pcl_Response);
          IF (Pv_Status = 'ERROR') THEN
            RAISE Le_Errors;
          END IF;

          APEX_JSON.PARSE(Pcl_Request);
          LOOP
            FETCH Pcl_Response  BULK COLLECT INTO V_IdDetalleSolicitud, V_NombreCliente, V_Login, V_Destinatarios, V_NombreJurisdiccion, V_Direccion, V_DescripcionProducto, V_FeCreacion, V_UsrCreacion, V_FechaPlanificacion,
                                                  V_UsrPlanificacion, V_Observacion, V_Estado, V_IdDetalle, V_IdComunicacion, V_IdSevicioHistorial LIMIT 100;
            EXIT WHEN V_IdDetalleSolicitud.count=0;
            j := V_IdDetalleSolicitud.FIRST;
            WHILE (j IS NOT NULL)

            LOOP
              Lv_PclRequest := '{"idDetalle": ' || V_IdDetalle(j) ;
              Lv_PclRequest := Lv_PclRequest || ',"idComunicacion": ' || V_IdComunicacion(j); 
              Lv_PclRequest := Lv_PclRequest || ',"idAsignado": ' || APEX_JSON.get_number(p_path => 'idAsignado'); 
              Lv_PclRequest := Lv_PclRequest || ',"idServicioHistorial": ' || V_IdSevicioHistorial(j); 
              Lv_PclRequest := Lv_PclRequest || ',"idFactibilidad": ' ||  V_IdSolSimultanea(i); 
              Lv_PclRequest := Lv_PclRequest || ',"codEmpresa": "' || APEX_JSON.get_varchar2(p_path => 'codEmpresa') || '"'; 
              Lv_PclRequest := Lv_PclRequest || ',"fechaHal": "' || APEX_JSON.get_varchar2(p_path => 'fechaHal')  || '"'; 
              Lv_PclRequest := Lv_PclRequest || ',"horaIniHal": "' || APEX_JSON.get_varchar2(p_path => 'horaIniHal')  || '"'; 
              Lv_PclRequest := Lv_PclRequest || ',"horaFinHal": "' || APEX_JSON.get_varchar2(p_path => 'horaFinHal')  || '"'; 
              Lv_PclRequest := Lv_PclRequest || ',"usrCreacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.usrCreacion') || '"'; 
              Lv_PclRequest := Lv_PclRequest || ',"ipCreacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.ipCreacion') || '"'; 
              Lv_PclRequest := Lv_PclRequest || ',"gestionSimultanea": "S"}'; 
              Pv_Observacion := V_Observacion(j);
              j := V_IdDetalleSolicitud.NEXT(j);
            END LOOP;  
         END LOOP;  
          dbms_output.put_line('P_CONFIRMAR_PLANIFICACION => ' || Lv_PclRequest);

          DB_SOPORTE.SPKG_PLANIFICACION_COMERCIAL.P_CONFIRMAR_PLANIFICACION (Lv_PclRequest, Pv_Status, Pv_Mensaje, Pv_Observacion, Pcl_Response);
          IF (Pv_Status = 'ERROR') THEN
            RAISE Le_Errors;
          END IF;  
          i := V_IdSolGestionada.NEXT(i);
        END LOOP;  

      END LOOP;
      CLOSE Lc_Consulta;

        OPEN C_GET_PARAMETRO('PRODUCTOS ADICIONALES MANUALES', 'Activo', 'Productos adicionales manuales para activar');
        FETCH C_GET_PARAMETRO INTO Lv_ParamV1, Lv_ParamV2, Lv_ParamV3, Lv_ParamV4;
        CLOSE C_GET_PARAMETRO;
        Lv_ProductosPlanif := Lv_ProductosPlanif || Lv_ParamV1 || ',' || Lv_ParamV2 || ',' || Lv_ParamV3 || ',' || Lv_ParamV4;
        dbms_output.put_line('entr3 ' || Lv_ProductosPlanif);                                       
        dbms_output.put_line('fact ' || Ln_IdFactibilidad);
      FOR REG IN C_GET_SERVICIOS_SIMULTANEOS(Ln_IdFactibilidad) LOOP
          APEX_JSON.PARSE(Pcl_Request);      
            dbms_output.put_line('fact ' || Ln_IdPunto);
            dbms_output.put_line('solicitud => ' || REG.SOLICITUD_ID);
            IF (REG.SOLICITUD_ID > 0 AND INSTR(Lv_ProductosPlanif, REG.PRODUCTO_ID) > 0) THEN
                Lv_PclRequest := '{"idPersonaEmpRolSession": '  || APEX_JSON.get_number(p_path => 'sugerenciaHal.idPersonaEmpRolSession'); 
                Lv_PclRequest := Lv_PclRequest || ',"origen": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.origen') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"idFactibilidad": ' || REG.SOLICITUD_ID; 
                Lv_PclRequest := Lv_PclRequest || ',"parametro": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.parametro') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"idPersonaTecnico": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idPersonaTecnico'); 
                Lv_PclRequest := Lv_PclRequest || ',"codEmpresa": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.codEmpresa') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"prefijoEmpresa": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.prefijoEmpresa') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"idDepartamento": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idDepartamento'); 
                Lv_PclRequest := Lv_PclRequest || ',"idWifiSim": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idWifiSim'); 
                Lv_PclRequest := Lv_PclRequest || ',"fechaProgramacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.fechaProgramacion') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"horaInicio": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.horaInicio') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"horaFin": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.horaFin') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"observacionServicio": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.observacionServicio') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"observacionPlanif": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.observacionPlanif') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"fechaVigencia": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.fechaVigencia') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"opcion": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.opcion') ; 
                Lv_PclRequest := Lv_PclRequest || ',"esHal": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.esHal') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"idMotivo": ' || APEX_JSON.get_number(p_path => 'sugerenciaHal.idMotivo'); 
                Lv_PclRequest := Lv_PclRequest || ',"usrCreacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.usrCreacion') || '"'; 
                Lv_PclRequest := Lv_PclRequest || ',"ipCreacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.ipCreacion') || '"'; 
            Lv_PclRequest := Lv_PclRequest || '}';

          --dbms_output.put_line('P_PROGRAMAR_SOLICITUD => ' || Lv_PclRequest);

             DB_SOPORTE.SPKG_PLANIFICACION_COMERCIAL.P_PROGRAMAR_SOLICITUD (Lv_PclRequest, Pv_Status, Pv_Mensaje, Pcl_Response);
              IF (Pv_Status = 'ERROR') THEN
                RAISE Le_Errors;
              END IF;

              APEX_JSON.PARSE(Pcl_Request);
              LOOP
                FETCH Pcl_Response  BULK COLLECT INTO V_IdDetalleSolicitud, V_NombreCliente, V_Login, V_Destinatarios, V_NombreJurisdiccion, V_Direccion, V_DescripcionProducto, V_FeCreacion, V_UsrCreacion, V_FechaPlanificacion,
                                                      V_UsrPlanificacion, V_Observacion, V_Estado, V_IdDetalle, V_IdComunicacion, V_IdSevicioHistorial LIMIT 100;
                EXIT WHEN V_IdDetalleSolicitud.count=0;
                j := V_IdDetalleSolicitud.FIRST;
                WHILE (j IS NOT NULL)

                LOOP
                  Lv_PclRequest := '{"idDetalle": ' ;
                  Lv_PclRequest := Lv_PclRequest || V_IdDetalle(j);
                  Lv_PclRequest := Lv_PclRequest || ',"idAsignado": ' || APEX_JSON.get_number(p_path => 'idAsignado'); 
                  Lv_PclRequest := Lv_PclRequest || ',"idComunicacion": ' || V_IdComunicacion(j); 
                  Lv_PclRequest := Lv_PclRequest || ',"idServicioHistorial": ' || V_IdSevicioHistorial(j); 
                  Lv_PclRequest := Lv_PclRequest || ',"idFactibilidad": ' || REG.SOLICITUD_ID; 
                  Lv_PclRequest := Lv_PclRequest || ',"codEmpresa": "'  || APEX_JSON.get_varchar2(p_path => 'codEmpresa') || '"'; 
                  Lv_PclRequest := Lv_PclRequest || ',"fechaHal": "' || APEX_JSON.get_varchar2(p_path => 'fechaHal')  || '"'; 
                  Lv_PclRequest := Lv_PclRequest || ',"horaIniHal": "' || APEX_JSON.get_varchar2(p_path => 'horaIniHal')  || '"'; 
                  Lv_PclRequest := Lv_PclRequest || ',"horaFinHal": "' || APEX_JSON.get_varchar2(p_path => 'horaFinHal')  || '"'; 
                  Lv_PclRequest := Lv_PclRequest || ',"usrCreacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.usrCreacion') || '"'; 
                  Lv_PclRequest := Lv_PclRequest || ',"ipCreacion": "' || APEX_JSON.get_varchar2(p_path => 'sugerenciaHal.ipCreacion') || '"'; 
                  Lv_PclRequest := Lv_PclRequest || ',"gestionSimultanea": "S"}'; 
                  Pv_Observacion := V_Observacion(j);
                  j := V_IdDetalleSolicitud.NEXT(j);
                END LOOP;  
             END LOOP;  
          --dbms_output.put_line('P_CONFIRMAR_PLANIFICACION => ' || Lv_PclRequest);

              DB_SOPORTE.SPKG_PLANIFICACION_COMERCIAL.P_CONFIRMAR_PLANIFICACION (Lv_PclRequest, Pv_Status, Pv_Mensaje, Pv_Observacion, Pcl_Response);
              IF (Pv_Status = 'ERROR') THEN
                RAISE Le_Errors;
              END IF;  
          END IF;   
      END LOOP;
    EXCEPTION
    WHEN Le_Errors THEN
      Pv_Status  := 'ERROR';
      dbms_output.put_line('asignar mensaje => ' || Pv_Mensaje);
      --ROLLBACK;
    WHEN OTHERS THEN

      Pv_Status  := 'ERROR';
      Pv_Mensaje := SQLERRM; 
      dbms_output.put_line('asignar mensaje => ' || Pv_Mensaje);

  END P_EJECUTA_GESTION_SIMULTANEA;


END SPKG_PLANIFICACION_COMERCIAL;
/
