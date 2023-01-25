create or replace PACKAGE                                                     DB_COMERCIAL.CMKG_PLANIFICACION_COMERCIAL
AS
    /**
      * Documentación para el procedimiento P_GRID_COORDINAR
      *
      * Método que se encarga de devolver los registros para el grid de coordinar
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 17-08-2021
      */
    PROCEDURE P_GRID_COORDINAR (Pcl_Request  IN  CLOB,
                                Pv_Status    OUT VARCHAR2,
                                Pv_Mensaje   OUT VARCHAR2,
                                Pcl_Response OUT SYS_REFCURSOR);

     /**
      * Documentación para el procedimiento P_COORDINAR_PLANIFICACION
      *
      * Método que se encarga de coordinar solicitudes
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 11-10-2021
      */
    PROCEDURE P_COORDINAR_PLANIFICACION (Pcl_Request  IN  CLOB,
                                         Pn_IdServicioHistorial OUT NUMBER,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2
                                         );                                    

     /**
      * Documentación para el procedimiento P_ASIGNAR_PLANIFICACION
      *
      * Método que se encarga de asignar responsables de solicitudes
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 11-10-2021
      */
    PROCEDURE P_ASIGNAR_PLANIFICACION (Pcl_Request  IN  CLOB,
                                       Pn_IdServicioHistorial IN NUMBER,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,
                                       Pcl_Response OUT SYS_REFCURSOR);  


     /**
      * Documentación para el procedimiento P_JSON_SERVICIOS_GESTION
      *
      * Método que se encargar de devolver un json con los servicios adicionales de gestion simultanea
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 24-02-2022
      */
    FUNCTION F_JSON_SERVICIOS_GESTION (Pn_IdSolicitud                  IN NUMBER,
                                        Pv_ParamProdGestionSimultanea   IN VARCHAR2,
                                        Pv_OpcionGestionSimultanea      IN VARCHAR2)
    RETURN CLOB;  
    
     /**
      * Documentación para el procedimiento P_JSON_SERVICIOS_GESTION
      *
      * Método que se encargar de devolver un json con los servicios adicionales de gestion simultanea
      * 
      * @param Pv_Error  OUT VARCHAR2 Retorna un mensaje de error en caso de existir
      *
      * author Edgar Pin Villavicencio <epin@telconet.ec>
      * @version 1.0 24-02-2022
      */
     PROCEDURE P_JSON_SERVICIOS_GESTION (Pn_IdSolicitud                IN NUMBER,
                                       Pv_ParamProdGestionSimultanea   IN VARCHAR2,
                                       Pv_OpcionGestionSimultanea      IN VARCHAR2,
                                       Pv_Status    OUT VARCHAR2,
                                       Pv_Mensaje   OUT VARCHAR2,                                       
                                       Pv_Response                     OUT CLOB);    

END CMKG_PLANIFICACION_COMERCIAL;
/
create or replace PACKAGE BODY                                        DB_COMERCIAL.CMKG_PLANIFICACION_COMERCIAL AS
  PROCEDURE P_GRID_COORDINAR (Pcl_Request  IN  CLOB,
                              Pv_Status    OUT VARCHAR2,
                              Pv_Mensaje   OUT VARCHAR2,
                              Pcl_Response OUT SYS_REFCURSOR)  
  AS
      Lcl_Query                   CLOB;
      Lcl_Select                  CLOB;
      Lcl_From                    CLOB;
      Lcl_Where                   CLOB;
      Le_Errors              EXCEPTION;
      Ld_FechaDesdePlan      VARCHAR2(30);
      Ld_FechaHastaPlan      VARCHAR2(30);
      Ld_FechaDesdeIng       VARCHAR2(30);
      Ld_FechaHastaIng       VARCHAR2(30);
      Lv_LoginPunto          VARCHAR2(30);
      Lv_DescripcionPunto    VARCHAR2(300);
      Lv_Vendedor            VARCHAR2(300);
      Lv_Ciudad              VARCHAR2(50);
      Lv_UltimaMilla         VARCHAR2(30); 
      Lv_Estado              VARCHAR2(30);
      Lv_TipoSolicitud       VARCHAR2(300);
      Ln_Sector              NUMBER;
      Lv_Identificacion      VARCHAR2(30);
      Lv_Nombres             VARCHAR2(300);
      Lv_Apellidos           VARCHAR2(300);
      Lv_EstadoPunto         VARCHAR2(30);
      Lv_CodEmpresa          VARCHAR2(30) := '18';
      j apex_json.t_values;    
      BEGIN
      dbms_output.put_line('mensaje 1000');
      Lcl_Where := 'WHERE S.ID_SERVICIO = IDS.SERVICIO_ID AND S.PUNTO_ID = P.ID_PUNTO AND IST.SERVICIO_ID = S.ID_SERVICIO  AND ATS.ID_TIPO_SOLICITUD = IDS.TIPO_SOLICITUD_ID AND P.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL AND IER.ID_EMPRESA_ROL = IPER.EMPRESA_ROL_ID
                      AND IER.ROL_ID = AR.ID_ROL AND IPER.PERSONA_ID = IP.ID_PERSONA AND P.SECTOR_ID = ASE.ID_SECTOR AND ASE.PARROQUIA_ID = AP.ID_PARROQUIA AND AP.CANTON_ID = AC.ID_CANTON AND AJ.ID_JURISDICCION = P.PUNTO_COBERTURA_ID AND AR.TIPO_ROL_ID = ATR.ID_TIPO_ROL AND IST.ELEMENTO_CONTENEDOR_ID = ILEM.ID_ELEMENTO
                      AND IER.EMPRESA_COD = ''' ||Lv_CodEmpresa ||''' AND ROWNUM < 500
                      AND SYSDATE <= IDS.FE_CREACION + (to_number((SELECT VALOR1 FROM DB_GENERAL.ADMI_PARAMETRO_DET WHERE PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = ''TIEMPO_BANDEJA_PLAN_AUTOMATICA'' AND MODULO = ''COMERCIAL'' AND ESTADO = ''Activo'')
                                                        AND DESCRIPCION = ''TIEMPO MÁXIMO A MOSTRAR EN LA BANDEJA DE PLANIFICACIÓN AUTOMÁTICA''))/1440)
                      AND (IDS.MOTIVO_ID NOT IN ' || '(SELECT REGEXP_SUBSTR(T1.VALOR1,''[^,]+'', 1, LEVEL) AS VALOR FROM(SELECT VALOR1
                             FROM DB_GENERAL.admi_parametro_Det where PARAMETRO_ID = (SELECT ID_PARAMETRO FROM DB_GENERAL.ADMI_PARAMETRO_CAB WHERE NOMBRE_PARAMETRO = ''PROGRAMAR_MOTIVO_HAL'')) T1
                             CONNECT BY REGEXP_SUBSTR(T1.VALOR1, ''[^,]+'', 1, LEVEL) IS NOT NULL ) OR IDS.MOTIVO_ID IS NULL) 
                       AND not exists(SELECT servicio_id FROM DB_COMERCIAL.INFO_SERVICIO_HISTORIAL WHERE SERVICIO_ID = IDS.SERVICIO_ID AND ESTADO = ''PrePlanificada''
      AND cast(OBSERVACION as VARCHAR(1000)) = ''La solicitud no aplica para Planificación comercial. Se envía la solicitud a PYL.'') ';
      APEX_JSON.PARSE(Pcl_Request);
      Ld_FechaDesdePlan   := APEX_JSON.get_varchar2(p_path => 'fechaDesdePlanif');
      Ld_FechaHastaPlan   := APEX_JSON.get_varchar2(p_path => 'fechaHastaPlanif');
      Ld_FechaDesdeIng    := APEX_JSON.get_varchar2(p_path => 'fechaDesdeIngOrd');
      Ld_FechaHastaIng    := APEX_JSON.get_varchar2(p_path => 'fechaHastaIngOrd');  
      Lv_LoginPunto       := APEX_JSON.get_varchar2(p_path => 'login');
      Lv_DescripcionPunto := APEX_JSON.get_varchar2(p_path => 'descripcionPunto');
      Lv_EstadoPunto      := APEX_JSON.get_varchar2(p_path => 'estadoPunto');    
      Lv_Vendedor         := APEX_JSON.get_varchar2(p_path => 'vendedor');
      Lv_Ciudad           := '';
      apex_json.parse(j, Pcl_Request);
      dbms_output.put_line('mensaje 2000');
      IF (APEX_JSON.get_count(p_path => 'ciudad') > 0) THEN
        FOR i in 1..APEX_JSON.get_count(p_path => 'ciudad') LOOP
            Lv_Ciudad := Lv_Ciudad || apex_json.get_varchar2(p_path=>'ciudad[%d]',p0=> i,p_values=>j) || ',';            
        END LOOP; 
        Lv_Ciudad := SUBSTR(Lv_Ciudad, 0, LENGTH(Lv_Ciudad) - 1);
      END IF;  
      Lv_UltimaMilla      := APEX_JSON.get_varchar2(p_path => 'ultimaMilla');
      Lv_Estado           := APEX_JSON.get_varchar2(p_path => 'estado');
      Lv_TipoSolicitud    := APEX_JSON.get_varchar2(p_path => 'tipoSolicitud');
      Ln_Sector           := APEX_JSON.get_varchar2(p_path => 'idSector');
      Lv_Identificacion   := APEX_JSON.get_varchar2(p_path => 'identificacion');
      Lv_Nombres          := APEX_JSON.get_varchar2(p_path => 'nombres');
      Lv_Apellidos        := APEX_JSON.get_varchar2(p_path => 'apellidos');
      Lv_CodEmpresa       := APEX_JSON.get_varchar2(p_path => 'codEmpresa'); 
      IF Ld_FechaDesdePlan IS  NOT NULL THEN
          Lcl_Where := CONCAT(Lcl_Where, ' AND IDS.FE_CREACION >= ''' || to_date(Ld_FechaDesdePlan , 'dd/mm/yyyy') ||'''');
      END IF;
      IF Ld_FechaHastaPlan IS  NOT NULL THEN
          Lcl_Where := CONCAT(Lcl_Where, ' AND IDS.FE_CREACION < ''' || (to_date(Ld_FechaHastaPlan , 'dd/mm/yyyy') + 1) ||'''');
      END IF;  
      IF Lv_LoginPunto IS NOT NULL THEN
          Lcl_Where := CONCAT(Lcl_Where, ' AND P.LOGIN LIKE ''' || Lv_LoginPunto ||'%''');
      END IF;
      IF Lv_DescripcionPunto IS NOT NULL THEN
          Lcl_Where := CONCAT(Lcl_Where, ' AND P.DESCRIPCION_PUNTO LIKE ''' || Lv_DescripcionPunto ||'%''');
      END IF;    
      IF (Lv_EstadoPunto IS NOT NULL AND Lv_EstadoPunto != 'Todos') THEN
          Lcl_Where := CONCAT(Lcl_Where, ' AND P.ESTADO = ''' || Lv_EstadoPunto || '''');
      END IF;
      IF Lv_Ciudad IS NOT NULL THEN
          Lcl_Where := CONCAT(Lcl_Where, 'AND UPPER(AC.NOMBRE_CANTON) IN (SELECT REGEXP_SUBSTR(T1.VALOR1,''[^,]+'', 1, LEVEL) AS VALOR
                        FROM(SELECT ''' || UPPER(Lv_Ciudad) ||''' as valor1 FROM dual) T1
                             CONNECT BY REGEXP_SUBSTR(T1.VALOR1, ''[^,]+'', 1, LEVEL) IS NOT NULL) ');
      END IF;
      Lv_Estado := 'PrePlanificada';
      IF Lv_Estado IS NOT NULL THEN
         IF Lv_Estado in ('PrePlanificada','Planificada', 'Replanificada', 'Rechazada', 'Detenido', 'AsignadoTarea', 'Asignada') THEN
            Lcl_Where := CONCAT(Lcl_Where, 'AND IDS.ESTADO = ''' || Lv_Estado || '''');
         ELSE
            IF Lv_TipoSolicitud IS NOT NULL AND Lv_TipoSolicitud = 'SOLICITUD MIGRACION' THEN
              Lcl_Where := CONCAT(Lcl_Where, 'AND IDS.ESTADO IN (''PrePlanificada'',''AsignadoTarea'',''Planificada'', ''Replanificada'')');
            ELSIF Lv_TipoSolicitud IN ('SOLICITUD PLANIFICACION', 'SOLICITUD CAMBIO EQUIPO', 'SOLICITUD RETIRO EQUIPO', 'SOLICITUD AGREGAR EQUIPO',
                                        'SOLICITUD AGREGAR EQUIPO MASIVO', 'SOLICITUD REUBICACION', 'SOLICITUD CAMBIO EQUIPO POR SOPORTE',
                                        'SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO', 'SOLICITUD DE INSTALACION CABLEADO ETHERNET') THEN
              Lcl_Where := CONCAT(Lcl_Where, 'AND IDS.ESTADO IN (''PrePlanificada'',''Planificada'',''Replanificada'', ''Detenido'', ''AsignadoTarea'',''Asignada'')');
            ELSE
              Lcl_Where := CONCAT(Lcl_Where, 'AND ATS.DESCRIPCION_SOLICITUD = ''' || Lv_DescripcionPunto ||'''' );
            END IF;
         END IF; 
      END IF;
      IF Lv_TipoSolicitud IS NOT NULL THEN
        IF Lv_TipoSolicitud IN ('SOLICITUD CAMBIO EQUIPO', 'SOLICITUD RETIRO EQUIPO', 'SOLICITUD PLANIFICACION', 'SOLICITUD AGREGAR EQUIPO',
                                'SOLICITUD AGREGAR EQUIPO MASIVO', 'SOLICITUD CAMBIO EQUIPO POR SOPORTE', 'SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO',
                                'SOLICITUD DE INSTALACION CABLEADO ETHERNET') THEN
          Lcl_Where := CONCAT(Lcl_Where, 'AND ATS.DESCRIPCION_SOLICITUD = ''' || Lv_TipoSolicitud ||'''' );  
        END IF;
        IF Lv_TipoSolicitud IN ('SOLICITUD CAMBIO EQUIPO', 'SOLICITUD RETIRO EQUIPO', 'OLICITUD AGREGAR EQUIPO', 'SOLICITUD AGREGAR EQUIPO MASIVO',
                                'SOLICITUD CAMBIO EQUIPO POR SOPORTE', 'SOLICITUD CAMBIO EQUIPO POR SOPORTE MASIVO') THEN
          Lcl_Where := CONCAT(Lcl_Where, 'AND IPER.ESTADO IN (''Activo'',''Cancelado'')');
        ELSIF Lv_TipoSolicitud IN ('SOLICITUD PLANIFICACION', 'SOLICITUD MIGRACION') THEN
          Lcl_Where := CONCAT(Lcl_Where, 'AND IPER.ESTADO = ''Activo''' );  
        END IF;
      END IF;
      IF Ln_Sector IS NOT NULL THEN 
        Lcl_Where := CONCAT(Lcl_Where, 'AND ASE.ID_SECTOR = ''' || Ln_Sector ||'''' );  
      END IF;
      IF Lv_Identificacion IS NOT NULL THEN 
        Lcl_Where := CONCAT(Lcl_Where, 'AND IP.IDENTIFICACION_CLIENTE = ''' || Lv_Identificacion ||'''' );  
      END IF;
      IF Lv_Nombres IS NOT NULL THEN 
        Lv_Nombres := UPPER(CONCAT(Lv_Nombres, '%'));
        Lcl_Where := CONCAT(Lcl_Where, 'AND UPPER(IP.NOMBRES) LIKE ''' || Lv_Nombres ||'''' );  
      END IF;    
      IF Lv_Apellidos IS NOT NULL THEN 
        Lv_Apellidos := UPPER(CONCAT(Lv_Apellidos, '%'));
        Lcl_Where := CONCAT(Lcl_Where, 'AND UPPER(IP.APELLIDOS) LIKE ''' || Lv_Apellidos ||'''' );  
      END IF;   
      IF Lv_Vendedor IS NOT NULL THEN 
        Lv_Vendedor := UPPER(CONCAT(Lv_Vendedor, '%'));
        Lcl_Where := CONCAT(Lcl_Where, 'AND UPPER(PV.NOMBRES) || '' '' || UPPER(PV.APELLIDOS) LIKE ''' || Lv_Vendedor ||'''' );  
      END IF;
      IF Lv_UltimaMilla IS NOT NULL THEN 
        Lcl_Where := CONCAT(Lcl_Where, 'AND IST.ULTIMA_MILLA_ID = ''' || Lv_UltimaMilla ||'''' );  
      END IF;       
      dbms_output.put_line('mensaje 3000');
      Lcl_Select := '
        SELECT IDS.ID_DETALLE_SOLICITUD AS idDetalleSolicitud, S.ID_SERVICIO AS idServicio, P.ID_PUNTO AS idPunto, P.ESTADO AS estadoPunto, IST.TERCERIZADORA_ID AS tercerizadoraId, IST.ID_SERVICIO_TECNICO AS idServicioTecnico,
               ASE.NOMBRE_SECTOR AS nombreSector, AP.NOMBRE_PARROQUIA AS nombreParroquia, AC.NOMBRE_CANTON AS nombreCanton, IP.ID_PERSONA AS idPersona, IP.RAZON_SOCIAL AS razonSocial, IP.NOMBRES AS nombres,
               IP.APELLIDOS AS apellidos, P.USR_VENDEDOR AS usrVendedor, P.LOGIN AS login,
               CASE S.TIPO_ORDEN  WHEN ''N'' THEN ''Nuevo'' 
                                  WHEN ''T'' THEN ''Traslado''
                                  WHEN ''R'' THEN ''Reubicacion'' 
                                  WHEN ''C'' THEN ''Cambio Tipo Medio'' ELSE ''Nuevo'' END AS tipoOrden,
               S.ESTADO AS estadoServicio, AJ.NOMBRE_JURISDICCION  AS nombreJurisdiccion, P.LONGITUD AS longitud, P.LATITUD AS latitud, P.DIRECCION AS direccion, P.RUTA_CROQUIS AS rutaCroquis, IDS.FE_CREACION AS feCreacion,
               IDS.ESTADO              AS estado, ATS.DESCRIPCION_SOLICITUD AS descripcionSolicitud, P.OBSERVACION AS observacion, PV.NOMBRES || '' '' || PV.APELLIDOS AS nombreVendedor, IST.ULTIMA_MILLA_ID AS ultimaMillaId,
               IDS.OBSERVACION         AS observacionSolicitud, ILEM.NOMBRE_ELEMENTO    AS caja,
               CASE WHEN IP.RAZON_SOCIAL IS NULL THEN IP.NOMBRES  || '' '' || IP.APELLIDOS ELSE IP.RAZON_SOCIAL END AS nombreCliente,
               CASE WHEN S.PLAN_ID IS NULL 
               THEN (SELECT DESCRIPCION_PRODUCTO FROM DB_COMERCIAL.ADMI_PRODUCTO WHERE ID_PRODUCTO = S.PRODUCTO_ID)
               ELSE (SELECT NOMBRE_PLAN FROM DB_COMERCIAL.INFO_PLAN_CAB WHERE ID_PLAN = S.PLAN_ID)
               END AS nombreProducto,
               DB_COMERCIAL.CMKG_PLANIFICACION_COMERCIAL.F_JSON_SERVICIOS_GESTION(IDS.ID_DETALLE_SOLICITUD, NULL, ''PLANIFICAR'') AS lstServicios';
          Lcl_From := '
          FROM  DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS, DB_COMERCIAL.INFO_SERVICIO S, DB_COMERCIAL.INFO_SERVICIO_TECNICO IST, DB_INFRAESTRUCTURA.INFO_ELEMENTO ILEM, DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS,
                DB_COMERCIAL.INFO_PERSONA IP, DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER, DB_COMERCIAL.INFO_EMPRESA_ROL IER, DB_COMERCIAL.ADMI_ROL AR, DB_COMERCIAL.ADMI_TIPO_ROL ATR, DB_INFRAESTRUCTURA.ADMI_JURISDICCION AJ,
                DB_COMERCIAL.ADMI_SECTOR ASE, DB_COMERCIAL.ADMI_PARROQUIA AP, DB_COMERCIAL.ADMI_CANTON AC, DB_COMERCIAL.INFO_PUNTO P
                LEFT JOIN DB_COMERCIAL.INFO_PERSONA PV ON PV.LOGIN = P.USR_VENDEDOR ';
      Lcl_Query := Lcl_Select || Lcl_From || Lcl_Where ;  
      dbms_output.put_line('mensaje 4000 ' || Lcl_Query);
      OPEN Pcl_Response FOR Lcl_Query; 
      
      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';
    EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
      WHEN OTHERS THEN
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;
              DB_GENERAL.GNRLPCK_UTIL.INSERT_ERROR('CMKG_PLANIFICACION', 'DB_COMERCIAL.CMKG_PLANIFICACION_COMERCIAL', 'ERROR al procesar COD_ERROR: '||SQLCODE||' - '||SQLERRM ||' ' ||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||' '|| DBMS_UTILITY.FORMAT_ERROR_STACK,
                                                   'telcos', SYSDATE, '127.0.0.1');
    END P_GRID_COORDINAR;

    PROCEDURE P_COORDINAR_PLANIFICACION (Pcl_Request  IN  CLOB,
                                         Pn_IdServicioHistorial OUT NUMBER,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2)
    IS
    CURSOR C_GET_DETALLE_SOLICITUD(Ln_IdFactibilidad NUMBER)
    IS
    SELECT SER.ID_SERVICIO, SER.PRODUCTO_ID,  PUN.ID_PUNTO, SER.ESTADO, JUR.ID_JURISDICCION, JUR.CUPO, ATS.DESCRIPCION_SOLICITUD
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
      ON IDS.SERVICIO_ID = SER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
      ON SER.PUNTO_ID = PUN.ID_PUNTO
    LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JUR
      ON PUN.PUNTO_COBERTURA_ID = JUR.ID_JURISDICCION
    LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
      ON IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
    WHERE ID_DETALLE_SOLICITUD = Ln_IdFactibilidad;

    CURSOR C_GET_CARACTERISTICA(Lv_Descripcion VARCHAR2, Lv_Estado VARCHAR2)
    IS
    SELECT ID_CARACTERISTICA
    FROM DB_COMERCIAL.ADMI_CARACTERISTICA
    WHERE DESCRIPCION_CARACTERISTICA = Lv_Descripcion
      AND ESTADO = Lv_Estado;  

    CURSOR C_GET_PRODUCTO(Ln_IdProducto NUMBER)
    IS 
    SELECT NOMBRE_TECNICO
    FROM DB_COMERCIAL.ADMI_PRODUCTO
    WHERE ID_PRODUCTO = Ln_IdProducto;
    Le_Errors              EXCEPTION;
    Lv_Origen                 VARCHAR2(30);
    Ln_IdFactibilidad         NUMBER;
    Lv_Parametro              VARCHAR2(300); 
    Lv_PrefijoEmpresa         VARCHAR2(10);
    Lv_FechaProgramacion      VARCHAR2(30);
    Lv_HoraInicio             VARCHAR2(10);
    Lv_HoraFin                VARCHAR2(10);
    Lv_ObservacionServicio    VARCHAR2(4000);
    Lv_ObservacionPlanif      VARCHAR2(4000);
    Ln_Opcion                 NUMBER;
    Lv_FechaHoraInicio        VARCHAR2(30);
    Lv_FechaHoraFin           VARCHAR2(30);
    Lv_UsrCreacion            VARCHAR2(30);
    Lv_IpCreacion             VARCHAR2(30); 
    Ln_IdServicio          NUMBER := 0;
    Lv_EstadoServicio      VARCHAR2(30);
    Lv_EstadoAnterior      VARCHAR2(30);
    Ln_IdProducto          NUMBER;
    Ln_IdPunto             NUMBER := 0;
    Ln_IdJurisdiccion      NUMBER := 0;
    Ln_Cupo                NUMBER := 0;
    Lv_DescripcionSol      VARCHAR2(300);
    Ln_HayDetalleSol       NUMBER;
    Lv_EstadoPlanificacion VARCHAR2(300);
    Lv_NombreTecnico       VARCHAR2(300);
    Lb_RequiereFlujo       BOOLEAN := FALSE;
    Lv_PermiteEquipoWyAp   VARCHAR2(2);
    Ln_IdCaracteristica    NUMBER;
    BEGIN
      APEX_JSON.PARSE(Pcl_Request);
      Ln_IdFactibilidad      := APEX_JSON.get_number(p_path => 'idFactibilidad');   
      Lv_PrefijoEmpresa      := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
      Ln_Opcion              := APEX_JSON.get_number(p_path => 'opcion');
      Lv_FechaProgramacion   := APEX_JSON.get_varchar2(p_path => 'fechaProgramacion');
      Lv_HoraInicio          := APEX_JSON.get_varchar2(p_path => 'horaInicio');
      Lv_HoraFin             := APEX_JSON.get_varchar2(p_path => 'horaFin');
      Lv_UsrCreacion         := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
      Lv_IpCreacion          := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
      Lv_Origen              := APEX_JSON.get_varchar2(p_path => 'origen');
      Lv_FechaHoraInicio     := trim(Lv_FechaProgramacion) || ' ' || trim(Lv_HoraInicio);
      Lv_FechaHoraFin        := trim(Lv_FechaProgramacion) || ' ' || trim(Lv_HoraFin);
      OPEN C_GET_DETALLE_SOLICITUD(Ln_IdFactibilidad);
      FETCH C_GET_DETALLE_SOLICITUD INTO Ln_IdServicio, Ln_IdProducto, Ln_IdPunto, Lv_EstadoServicio, Ln_IdJurisdiccion, Ln_Cupo, Lv_DescripcionSol;
      CLOSE C_GET_DETALLE_SOLICITUD;  
      OPEN C_GET_CARACTERISTICA('PRODUCTO_ADICIONAL', 'Activo');
      FETCH C_GET_CARACTERISTICA INTO Ln_IdCaracteristica;
      CLOSE C_GET_CARACTERISTICA;
      SELECT NVL(COUNT(ID_SOLICITUD_CARACTERISTICA), 0)
      INTO Ln_HayDetalleSol
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_CARACT
      WHERE DETALLE_SOLICITUD_ID = Ln_IdFactibilidad AND CARACTERISTICA_ID = Ln_IdCaracteristica;
      IF (Ln_IdServicio IS NOT NULL) THEN  
        IF (Lv_EstadoServicio = 'Activo' 
            AND LOWER(Lv_DescripcionSol) NOT IN ('solicitud migracion', 'solicitud agregar equipo', 'solicitud agregar equipo masivo', 'solicitud cambio equipo por soporte', 'solicitud cambio equipo por soporte masivo', 'solicitud de instalacion cableado ethernet', 'solicitud reubicacion')
            AND Ln_HayDetalleSol = 0) THEN
            Pv_Mensaje    := 'El servicio Actualmente se encuentra con estado Activo, no es posible Coordinar.';
            RAISE Le_Errors;
        END IF;
        IF (Ln_IdProducto IS NOT NULL) THEN
          OPEN C_GET_CARACTERISTICA('VENTA_EXTERNA', 'Activo');
          FETCH C_GET_CARACTERISTICA INTO Ln_IdCaracteristica;
          CLOSE C_GET_CARACTERISTICA;
          OPEN C_GET_PRODUCTO(Ln_IdProducto);
          FETCH C_GET_PRODUCTO INTO Lv_NombreTecnico;
          CLOSE C_GET_PRODUCTO;
        END IF;
        Lv_EstadoPlanificacion := 'Planificada';
        IF (Ln_IdProducto IS NOT NULL AND Lv_NombreTecnico IN ('HOUSING', 'HOSTING') ) THEN
          Lv_EstadoPlanificacion := 'Asignada';
        END IF;
        IF (Ln_IdProducto IS NOT NULL AND Lb_RequiereFlujo ) THEN
          Lv_EstadoPlanificacion := 'AsignadoTarea';
        ELSE
          Lv_PermiteEquipoWyAp := 'NO';
          IF (Lv_NombreTecnico = 'WDB_Y_EDB' AND LOWER(Lv_DescripcionSol) = 'solicitud agregar equipo') THEN
            Lv_PermiteEquipoWyAp := 'SI';
          END IF;  
          IF (LOWER(Lv_DescripcionSol) = 'solicitud planificacion' 
              OR (Lv_NombreTecnico = 'EXTENDER_DUAL_BAND' AND (LOWER(Lv_DescripcionSol) IN ('solicitud agregar equipo', 'solicitud agregar equipo masivo')))
              OR (Lv_NombreTecnico = 'WIFI_DUAL_BAND' AND (LOWER(Lv_DescripcionSol) IN ('solicitud agregar equipo', 'solicitud agregar equipo masivo')))
              OR Lv_PermiteEquipoWyAp = 'SI'
              ) THEN
            IF (Ln_HayDetalleSol = 0) THEN
              UPDATE DB_COMERCIAL.INFO_SERVICIO SET ESTADO = Lv_EstadoPlanificacion WHERE ID_SERVICIO = Ln_IdServicio;
            END IF;
            Lv_ObservacionServicio := CONCAT(Lv_ObservacionServicio, '<br>');
            Lv_ObservacionServicio := CONCAT(Lv_ObservacionServicio, '<br>Fecha Planificada:' || Lv_FechaProgramacion);
            Lv_ObservacionServicio := CONCAT(Lv_ObservacionServicio, '<br>Hora Inicio:' || Lv_HoraInicio);
            Lv_ObservacionServicio := CONCAT(Lv_ObservacionServicio, '<br>Hora Fin:' || Lv_HoraFin || '<br><br>');
            INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (ID_SERVICIO_HISTORIAL, SERVICIO_ID, USR_CREACION, FE_CREACION, IP_CREACION, ESTADO, OBSERVACION)
            VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, Ln_IdServicio, Lv_UsrCreacion, sysdate, Lv_IpCreacion, Lv_EstadoPlanificacion, Lv_ObservacionServicio)
            RETURNING ID_SERVICIO_HISTORIAL INTO Pn_IdServicioHistorial; 
            IF (Ln_HayDetalleSol > 0 AND LOWER(Lv_DescripcionSol) = 'solicitud planificacion') THEN
              Lb_RequiereFlujo := false;
            END IF;
            IF (Lv_Origen = 'MOVIL') THEN
              OPEN C_GET_CARACTERISTICA('Planificacion desde Mobile', 'Activo');
              FETCH C_GET_CARACTERISTICA INTO Ln_IdCaracteristica;
              CLOSE C_GET_CARACTERISTICA;
            END IF;
          ELSIF (LOWER(Lv_DescripcionSol) = 'solicitud de instalacion cableado ethernet')  THEN
            IF (Lv_EstadoServicio != 'Activo') THEN
              Lv_EstadoAnterior := Lv_EstadoServicio;
              UPDATE DB_COMERCIAL.INFO_SERVICIO SET ESTADO = Lv_EstadoPlanificacion WHERE ID_SERVICIO = Ln_IdServicio;
            ELSE
              Lv_EstadoAnterior := 'PrePlanificada';
            END IF;
            Lv_ObservacionServicio := CONCAT(Lv_ObservacionServicio, '<br>');
            Lv_ObservacionServicio := CONCAT(Lv_ObservacionServicio, '<br>Fecha Planificada:' || Lv_FechaProgramacion);
            Lv_ObservacionServicio := CONCAT(Lv_ObservacionServicio, '<br>Hora Inicio:' || Lv_HoraInicio);
            Lv_ObservacionServicio := CONCAT(Lv_ObservacionServicio, '<br>Hora Fin:' || Lv_HoraFin || '<br><br>');        
            INSERT INTO DB_COMERCIAL.INFO_SERVICIO_HISTORIAL (ID_SERVICIO_HISTORIAL, SERVICIO_ID, USR_CREACION, FE_CREACION, IP_CREACION, ESTADO, OBSERVACION)
            VALUES (DB_COMERCIAL.SEQ_INFO_SERVICIO_HISTORIAL.NEXTVAL, Ln_IdServicio, Lv_UsrCreacion, sysdate, Lv_IpCreacion, Lv_EstadoPlanificacion, Lv_ObservacionServicio)
            RETURNING ID_SERVICIO_HISTORIAL INTO Pn_IdServicioHistorial; 
          END IF; 
          IF (Ln_HayDetalleSol = 1) THEN
            Lv_EstadoPlanificacion := 'Asignada';
          END IF;
          UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD 
          SET ESTADO = Lv_EstadoPlanificacion, OBSERVACION = SUBSTR(Lv_ObservacionPlanif,0,1499)
          WHERE ID_DETALLE_SOLICITUD = Ln_IdFactibilidad; 
          INSERT INTO DB_COMERCIAL.INFO_DETALLE_SOL_HIST(ID_SOLICITUD_HISTORIAL, DETALLE_SOLICITUD_ID, FE_INI_PLAN, FE_FIN_PLAN, OBSERVACION, IP_CREACION, FE_CREACION, USR_CREACION, ESTADO)
          VALUES (DB_COMERCIAL.SEQ_INFO_DETALLE_SOL_HIST.NEXTVAL, Ln_IdFactibilidad, to_date(Lv_FechaHoraInicio,'DD/MM/YYYY HH24:MI:SS') , to_date(Lv_FechaHoraFin,'DD/MM/YYYY HH24:MI:SS'), Lv_ObservacionPlanif, Lv_IpCreacion, sysdate, Lv_UsrCreacion, Lv_EstadoPlanificacion);
        END IF;
      ELSE
        Pv_Mensaje := 'No se pudo Coordinar';
        RAISE Le_Errors;
      END IF;
      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';
      COMMIT;
      EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
        dbms_output.put_line('mensaje ' || Pv_Mensaje);
        ROLLBACK;
      WHEN OTHERS THEN
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM;
        dbms_output.put_line('mensaje ' || Pv_Mensaje);
        ROLLBACK;
    END P_COORDINAR_PLANIFICACION; 

    PROCEDURE P_ASIGNAR_PLANIFICACION (Pcl_Request            IN  CLOB,
                                       Pn_IdServicioHistorial IN NUMBER,
                                       Pv_Status              OUT VARCHAR2,
                                       Pv_Mensaje             OUT VARCHAR2,
                                       Pcl_Response           OUT SYS_REFCURSOR)
    IS
      CURSOR C_GET_DETALLE_SOLICITUD(Ln_IdFactibilidad NUMBER)
      IS
      SELECT SER.ID_SERVICIO, SER.PRODUCTO_ID, SER.PLAN_ID, SER.ESTADO, PUN.ID_PUNTO, JUR.ID_JURISDICCION, JUR.CUPO, ATS.DESCRIPCION_SOLICITUD,
           CASE WHEN PER.RAZON_SOCIAL IS NOT NULL THEN PER.RAZON_SOCIAL
                WHEN PER.NOMBRES IS NOT NULL AND PER.APELLIDOS IS NOT NULL THEN PER.NOMBRES || ' ' || PER.APELLIDOS
                WHEN PER.REPRESENTANTE_LEGAL IS NOT NULL THEN REPRESENTANTE_LEGAL
                ELSE '' END, PUN.LONGITUD, PUN.LATITUD, PUN.USR_VENDEDOR, PUN.LOGIN, JUR.NOMBRE_JURISDICCION, PUN.DIRECCION
      FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
      LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
        ON IDS.SERVICIO_ID = SER.ID_SERVICIO
      LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
        ON SER.PUNTO_ID = PUN.ID_PUNTO
      LEFT JOIN DB_INFRAESTRUCTURA.ADMI_JURISDICCION JUR
        ON PUN.PUNTO_COBERTURA_ID = JUR.ID_JURISDICCION
      LEFT JOIN DB_COMERCIAL.ADMI_TIPO_SOLICITUD ATS
        ON IDS.TIPO_SOLICITUD_ID = ATS.ID_TIPO_SOLICITUD
      LEFT JOIN DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL IPER
        ON PUN.PERSONA_EMPRESA_ROL_ID = IPER.ID_PERSONA_ROL
      LEFT JOIN DB_COMERCIAL.INFO_PERSONA PER
        ON IPER.PERSONA_ID = PER.ID_PERSONA 
      WHERE ID_DETALLE_SOLICITUD = Ln_IdFactibilidad;

      CURSOR C_GET_CARACTERISTICA(Lv_Descripcion VARCHAR2, Lv_Estado VARCHAR2)
      IS
      SELECT ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA
      WHERE DESCRIPCION_CARACTERISTICA = Lv_Descripcion
        AND ESTADO = Lv_Estado;  

      CURSOR C_GET_PRODUCTO(Ln_IdProducto NUMBER)
      IS 
      SELECT NOMBRE_TECNICO
      FROM DB_COMERCIAL.ADMI_PRODUCTO
      WHERE ID_PRODUCTO = Ln_IdProducto;      

      CURSOR C_GET_PLAN(Ln_IdPlan NUMBER)
      IS 
      SELECT NOMBRE_PLAN
      FROM DB_COMERCIAL.INFO_PLAN_CAB
      WHERE ID_PLAN = Ln_IdPlan;        

      CURSOR C_GET_PARAMETRO(Lv_NombreParametro VARCHAR2, Lv_Estado VARCHAR2, Lv_Descripcion VARCHAR2)
      IS
      SELECT DET.VALOR1
      FROM DB_GENERAL.ADMI_PARAMETRO_CAB CAB
      LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET DET
      ON CAB.ID_PARAMETRO = DET.PARAMETRO_ID
      WHERE CAB.NOMBRE_PARAMETRO = Lv_NombreParametro
        AND CAB.ESTADO = Lv_Estado
        AND DET.DESCRIPCION = Lv_Descripcion
        AND DET.ESTADO = Lv_Estado;

      CURSOR C_GET_PROCESO(Lv_NombreProceso VARCHAR2)
      IS
      SELECT ID_PROCESO
      FROM DB_SOPORTE.ADMI_PROCESO
      WHERE NOMBRE_PROCESO = Lv_NombreProceso;

      CURSOR C_GET_SERVICIO_ADICIONAL(Ln_IdPunto NUMBER, Lv_NombreTecnico VARCHAR2, Lv_CodEmpresa VARCHAR2)  
      IS
      SELECT SER.*
      FROM INFO_SERVICIO SER
      LEFT JOIN INFO_PLAN_CAB CAB
        ON SER.PLAN_ID = CAB.ID_PLAN
      LEFT JOIN INFO_PLAN_DET DET
        ON CAB.ID_PLAN = DET.PLAN_ID
      LEFT JOIN ADMI_PRODUCTO PRO
        ON DET.PRODUCTO_ID = PRO.ID_PRODUCTO
      WHERE SER.PUNTO_ID = Ln_IdPunto
        AND PRO.NOMBRE_TECNICO = Lv_NombreTecnico
        AND PRO.EMPRESA_COD = Lv_CodEmpresa
        AND SER.ESTADO IN (SELECT PDET.VALOR3
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCAB
                              LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET PDET
                                ON PCAB.ID_PARAMETRO = PDET.PARAMETRO_ID
                              WHERE PCAB.NOMBRE_PARAMETRO = 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
                              AND PDET.VALOR1 = 'ESTADOS_SERVICIOS_IN'
                              AND PDET.VALOR2 = 'EXTENDER_DUAL_BAND'); 

      CURSOR C_COUNT_SERVICIO_ADICIONAL(Ln_IdPunto NUMBER, Lv_NombreTecnico VARCHAR2, Lv_CodEmpresa VARCHAR2)  
      IS
      SELECT COUNT(SER.ID_SERVICIO)
      FROM INFO_SERVICIO SER
      LEFT JOIN INFO_PLAN_CAB CAB
        ON SER.PLAN_ID = CAB.ID_PLAN
      LEFT JOIN INFO_PLAN_DET DET
        ON CAB.ID_PLAN = DET.PLAN_ID
      LEFT JOIN ADMI_PRODUCTO PRO
        ON DET.PRODUCTO_ID = PRO.ID_PRODUCTO
      WHERE SER.PUNTO_ID = Ln_IdPunto
        AND PRO.NOMBRE_TECNICO = Lv_NombreTecnico
        AND PRO.EMPRESA_COD = Lv_CodEmpresa
        AND SER.ESTADO IN (SELECT PDET.VALOR3
                              FROM DB_GENERAL.ADMI_PARAMETRO_CAB PCAB
                              LEFT JOIN DB_GENERAL.ADMI_PARAMETRO_DET PDET
                                ON PCAB.ID_PARAMETRO = PDET.PARAMETRO_ID
                              WHERE PCAB.NOMBRE_PARAMETRO = 'PARAMETROS_ASOCIADOS_A_SERVICIOS_MD'
                              AND PDET.VALOR1 = 'ESTADOS_SERVICIOS_IN'
                              AND PDET.VALOR2 = 'EXTENDER_DUAL_BAND');     

      CURSOR C_GET_TAREAS(Ln_IdProceso NUMBER, Lv_Estado VARCHAR2)
      IS
      SELECT ID_TAREA
      FROM DB_SOPORTE.ADMI_TAREA
      WHERE PROCESO_ID = Ln_IdProceso AND ESTADO NOT LIKE Lv_Estado;

      CURSOR C_GET_DETALLE (Ln_IdFactibilidad NUMBER, Ln_IdTarea NUMBER)
      IS
      SELECT ID_DETALLE
      FROM (SELECT DET.ID_DETALLE
            FROM DB_SOPORTE.INFO_DETALLE DET
            LEFT JOIN DB_SOPORTE.ADMI_TAREA TAR
            ON DET.TAREA_ID = TAR.ID_TAREA
            LEFT JOIN DB_SOPORTE.ADMI_PROCESO PRO
            ON TAR.PROCESO_ID = PRO.ID_PROCESO
            WHERE DET.DETALLE_SOLICITUD_ID = 0
            AND TAR.ID_TAREA = 0
            ORDER BY DET.ID_DETALLE DESC)
      WHERE ROWNUM = 1; 

      CURSOR C_GET_TAREAS_ABIERTAS(Ln_IdDetalle NUMBER)
      IS
      SELECT 
         COM.ID_COMUNICACION ID_COMUNICACION, 
         DET.ID_DETALLE      ID_DETALLE, 
         DH.ESTADO           ESTADOTAREA 
       FROM 
          DB_SOPORTE.INFO_DETALLE            DET, 
          DB_SOPORTE.INFO_DETALLE_ASIGNACION DA, 
          DB_SOPORTE.INFO_DETALLE_HISTORIAL  DH, 
          DB_SOPORTE.INFO_COMUNICACION       COM 
      WHERE DET.ID_DETALLE = DA.DETALLE_ID 
        AND DET.ID_DETALLE = DH.DETALLE_ID 
        AND DET.ID_DETALLE = COM.DETALLE_ID 
        AND DET.ID_DETALLE = Ln_IdDetalle
        AND DH.ESTADO NOT IN ('Finalizada','Cancelada','Anulada')
        AND DA.ID_DETALLE_ASIGNACION = 
        (SELECT MAX(DAMAX.ID_DETALLE_ASIGNACION) 
            FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION DAMAX WHERE DAMAX.DETALLE_ID = DA.DETALLE_ID) 
        AND DH.ID_DETALLE_HISTORIAL = 
        (SELECT MAX(DHMAX.ID_DETALLE_HISTORIAL) 
            FROM DB_SOPORTE.INFO_DETALLE_HISTORIAL DHMAX WHERE DHMAX.DETALLE_ID = DH.DETALLE_ID);    

      CURSOR C_LAST_DETALLE_SOL_HIST(Ln_IdFactibilidad NUMBER)     
      IS 
      SELECT MAX(ID_SOLICITUD_HISTORIAL)
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST
      WHERE DETALLE_SOLICITUD_ID = Ln_IdFactibilidad;

      CURSOR C_GET_DETALLE_SOL_HIST(Ln_IdSolicitudHistorial NUMBER)
      IS 
      SELECT FE_INI_PLAN
      FROM DB_COMERCIAL.INFO_DETALLE_SOL_HIST
      WHERE ID_SOLICITUD_HISTORIAL = Ln_IdSolicitudHistorial;

      CURSOR C_GET_ULTIMA_ASIGNACION(Ln_DetalleId NUMBER)
      IS
      SELECT PERSONA_EMPRESA_ROL_ID
      FROM (SELECT PERSONA_EMPRESA_ROL_ID 
            FROM DB_SOPORTE.INFO_DETALLE_ASIGNACION
            WHERE DETALLE_ID = Ln_DetalleId
            ORDER BY ID_DETALLE_ASIGNACION)
      WHERE ROWNUM = 1;  

      CURSOR C_GET_FORMAS_CONTACTO_LOGIN(Lv_Login VARCHAR2, Lv_FormaContacto VARCHAR2)
      IS
      SELECT AFC.DESCRIPCION_FORMA_CONTACTO, PFC.VALOR
      FROM DB_COMERCIAL.INFO_PERSONA PER
      LEFT JOIN INFO_PERSONA_FORMA_CONTACTO PFC
        ON PER.ID_PERSONA = PFC.PERSONA_ID
      LEFT JOIN DB_COMERCIAL.ADMI_FORMA_CONTACTO AFC
        ON  AFC.ID_FORMA_CONTACTO = PFC.FORMA_CONTACTO_ID
      WHERE LOWER(PER.LOGIN) = LOWER(Lv_Login)
        and LOWER(AFC.DESCRIPCION_FORMA_CONTACTO) = LOWER(Lv_FormaContacto);

      Le_Errors              EXCEPTION;
      Ln_IdPersonaEmpRolSesion NUMBER;
      Lv_EsHal                 VARCHAR2(2);
      Lv_AntenderAntes         VARCHAR2(30);
      Ln_IdSugerenciaHal       NUMBER;
      Lv_ObservacionCoordina   VARCHAR2(4000);
      Ln_IdDetalleExistente    NUMBER;
      Lb_ReplanificaHal        BOOLEAN;
      Lv_Origen                VARCHAR2(30);
      Ln_IdFactibilidad        NUMBER;
      Lv_Parametro             VARCHAR2(300);
      Lv_ParamResponsable      VARCHAR2(4000);
      Ln_IdPerTecnico          NUMBER;
      Lv_CodEmpresa            VARCHAR2(3);
      Ln_IdEmpresa             NUMBER;
      Lv_PrefijoEmpresa        VARCHAR2(10);
      Ln_IdDepartamento        NUMBER;
      Lv_UsrCreacion           VARCHAR2(30);
      Lv_IpCreacion            VARCHAR2(30);
      Ln_IdServicio            NUMBER := 0;
      Lv_EstadoServicio        VARCHAR2(30);
      Ln_IdProducto            NUMBER;
      Ln_IdPlan                NUMBER;
      Ln_IdPunto               NUMBER := 0;
      Ln_IdJurisdiccion        NUMBER := 0;
      Ln_Cupo                  NUMBER := 0;
      Lv_DescripcionSol        VARCHAR2(300);    
      Lv_RequiereTrabajo       VARCHAR2(50) := 'REQUIERE TRABAJO';
      Lb_RequiereFlujo         BOOLEAN := FALSE;
      Lv_SolCableadoEstructura VARCHAR2(100) := 'SOLICITUD CABLEADO ESTRUCTURADO';
      Lb_SigueFlujoPlanif      BOOLEAN := FALSE;
      Lb_GuardarGlobal         BOOLEAN := FALSE;
      Lv_NombreTecnico         VARCHAR2(300);
      Lv_NombrePlan            VARCHAR2(300) := '';
      Lv_NombreCliente         VARCHAR2(300);
      Lv_EsVentaExterna        VARCHAR2(2) := 'NO';
      Ln_HayProducto           NUMBER := 0;
      Ln_IdCaracteristica      NUMBER;
      Lv_ParametroTarea        VARCHAR2(300);
      Lv_ParametroTareaDpto    VARCHAR2(300);
      Lv_NombreProceso         VARCHAR2(100);
      Ln_HayNetLifeCam         NUMBER := 0;
      Ln_IdProceso             NUMBER := NULL;
      Ln_HayExtenderDualBand   NUMBER := 0;
      Ln_CuantosServAdicional  NUMBER := NULL;
      Ln_IdDetalle             NUMBER;
      Ln_IdSolicitudHistorial  NUMBER;
      Lb_HayDetalle            BOOLEAN := FALSE; 
      Ld_FechaIniPlan          DATE := NULL;
      Lv_Longitud              VARCHAR2(100);
      Lv_Latitud               VARCHAR2(100);
      Ln_PersonaEmpRolAsig     NUMBER := NULL;
      Lv_LoginVendedor         VARCHAR2(30);
      Lv_EmailVendedor         VARCHAR2(4000); 
      Lv_LoginPunto            VARCHAR2(100);
      Lv_NombreJurisdiccion    VARCHAR2(300);
      Lv_DireccionPunto        VARCHAR2(4000);
      Lv_DescripcionProducto   VARCHAR2(4000);
      Ln_IdComunicacion        NUMBER;
      Ln_IdDocumento           NUMBER;
      Lv_ModelosEquiposOntXTipoOnt VARCHAR2(300);
      Lv_ModelosEquiposEdbXTipoOnt VARCHAR2(300);
      Lv_ModelosEquiposWdb         VARCHAR2(300);
      Lv_ModelosEquiposEdb         VARCHAR2(300);
      Lv_TieneAlgunEquipoEnlazado  VARCHAR2(300);
      Lv_InfoEquipoEncontrado      VARCHAR2(300);
      Lcl_TrazaElementos           CLOB; 
    BEGIN
      APEX_JSON.PARSE(Pcl_Request);
      Ln_IdPersonaEmpRolSesion      := APEX_JSON.get_number(p_path => 'idPersonaEmpRolSesion');   
      Lv_EsHal                      := APEX_JSON.get_varchar2(p_path => 'esHal');
      Lv_AntenderAntes              := APEX_JSON.get_varchar2(p_path => 'atenderAntes');
      Ln_IdSugerenciaHal            := APEX_JSON.get_number(p_path => 'idSugerenciaHal');
      Lv_ObservacionCoordina        := APEX_JSON.get_varchar2(p_path => 'observacionPlanif');
      Ln_IdDetalleExistente         := APEX_JSON.get_number(p_path => 'idDetalleExistente');
      Lb_ReplanificaHal             := APEX_JSON.get_boolean(p_path => 'replanificaHal');
      Lv_Origen                     := APEX_JSON.get_varchar2(p_path => 'origen');  
      Ln_IdFactibilidad             := APEX_JSON.get_number(p_path => 'idFactibilidad'); 
      Lv_Parametro                  := APEX_JSON.get_varchar2(p_path => 'parametro');
      Lv_ParamResponsable           := APEX_JSON.get_varchar2(p_path => 'paramResponsable');
      Ln_IdPerTecnico               := APEX_JSON.get_number(p_path => 'idPerTecnico');
      Lv_CodEmpresa                 := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
      Ln_IdEmpresa                  := APEX_JSON.get_number(p_path => 'idEmpresa');
      Lv_PrefijoEmpresa             := APEX_JSON.get_varchar2(p_path => 'prefijoEmpresa');
      Ln_IdDepartamento             := APEX_JSON.get_number(p_path => 'idDepartamento');    
      Lv_UsrCreacion                := APEX_JSON.get_varchar2(p_path => 'usrCreacion');
      Lv_IpCreacion                 := APEX_JSON.get_varchar2(p_path => 'ipCreacion');
      IF (Ln_IdEmpresa = 18) THEN
        Ln_IdEmpresa := 10;
      END IF;  
      OPEN C_GET_DETALLE_SOLICITUD(Ln_IdFactibilidad);
      FETCH C_GET_DETALLE_SOLICITUD INTO Ln_IdServicio, Ln_IdProducto, Ln_IdPlan, Lv_EstadoServicio, Ln_IdPunto, Ln_IdJurisdiccion, 
                                         Ln_Cupo, Lv_DescripcionSol, Lv_NombreCliente, Lv_Longitud, Lv_Latitud, Lv_LoginVendedor, 
                                        Lv_LoginPunto, Lv_NombreJurisdiccion, Lv_DireccionPunto;
      CLOSE C_GET_DETALLE_SOLICITUD;  
      IF (Lv_EstadoServicio = 'Activo' 
          AND LOWER(Lv_DescripcionSol) NOT IN ('solicitud migracion', 'solicitud agregar equipo', 'solicitud agregar equipo masivo',
                                               'solicitud cambio equipo por soporte', 'solicitud cambio equipo por soporte masivo', 
                                               'solicitud de instalacion cableado ethernet', 'solicitud reubicacion')) THEN
        Pv_Mensaje    := 'El servicio Actualmente se encuentra con estado Activo, no es posible Coordinar.';
        RAISE Le_Errors;
      END IF;
      OPEN C_GET_PRODUCTO(Ln_IdProducto);
      FETCH C_GET_PRODUCTO INTO Lv_NombreTecnico;
      CLOSE C_GET_PRODUCTO;
      IF (Ln_IdPunto IS NOT NULL 
          AND (Lv_NombreTecnico IN ('EXTENDER_DUAL_BAND', 'WIFI_DUAL_BAND', 'WDB_Y_EDB') AND Lv_EstadoServicio != 'Activo') 
          AND LOWER(Lv_DescripcionSol) IN ('solicitud agregar equipo', 'solicitud agregar equipo masivo')) THEN
        Lb_SigueFlujoPlanif := TRUE;
      END IF;
        DBMS_OUTPUT.PUT_LINE('origen ' || Lv_Origen);           
      Lv_NombreProceso :=  'SOLICITAR NUEVO SERVICIO FIBRA';          
        
      IF (Lv_Origen IN ('local', 'otro', 'otro2', 'MOVIL')) THEN
        Lb_GuardarGlobal := TRUE;
        IF (Ln_IdPlan IS NOT NULL) THEN
          OPEN C_GET_PLAN(Ln_IdPlan);
          FETCH C_GET_PLAN INTO Lv_NombrePlan;
          CLOSE C_GET_PLAN;
        END IF;
        IF (Ln_IdProducto IS NOT NULL) THEN
          OPEN C_GET_CARACTERISTICA('VENTA_EXTERNA', 'Activo');
          FETCH C_GET_CARACTERISTICA INTO Ln_IdCaracteristica;
          CLOSE C_GET_CARACTERISTICA;
          IF (Ln_IdCaracteristica IS NOT NULL) THEN
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
              Lv_EsVentaExterna := 'SI'; 
              OPEN C_GET_PARAMETRO('PARAMETROS NETVOICE', 'Activo', 'TAREA');
              FETCH C_GET_PARAMETRO INTO Lv_ParametroTarea;
              IF (Lv_ParametroTarea IS NOT NULL) THEN
                FETCH C_GET_PARAMETRO INTO Lv_ParametroTareaDpto;
              END IF;
              CLOSE C_GET_PARAMETRO;            
            END IF;        
          END IF;
          IF (LOWER(Lv_DescripcionSol) = 'solicitud cambio equipo') THEN
            Lv_NombreProceso := 'SOLICITAR CAMBIO EQUIPO';
          END IF;
          IF (LOWER(Lv_DescripcionSol) = 'solicitud retiro equipo') THEN
            Lv_NombreProceso := 'SOLICITAR RETIRO EQUIPO';
          END IF;        
          IF (LOWER(Lv_DescripcionSol) = 'solicitud agregar equipo') THEN
            Lv_NombreProceso := 'SOLICITUD AGREGAR EQUIPO';
          END IF;  
          IF (LOWER(Lv_DescripcionSol) = 'solicitud cambio equipo por soporte') THEN
            Lv_NombreProceso := 'SOLICITUD CAMBIO EQUIPO POR SOPORTE';
          END IF;  
          IF (LOWER(Lv_DescripcionSol) = 'solicitud cambio equipo por soporte masivo') THEN
            Lv_NombreProceso := 'SOLICITUD CAMBIO EQUIPO POR SOPORTE';
          END IF; 
          IF (LOWER(Lv_DescripcionSol) = 'solicitud reubicacion') THEN
            Lv_NombreProceso := 'SOLICITUD REUBICACION';
          END IF;         
        END IF;

        DBMS_OUTPUT.PUT_LINE('proceso ' || Lv_NombreProceso);     
        IF (Ln_IdPlan IS NOT NULL AND LOWER(Lv_DescripcionSol) = 'solicitud planificacion') THEN
          BEGIN
            SELECT NVL(CAB.ID_PLAN,0) 
            INTO Ln_HayNetLifeCam
            FROM DB_COMERCIAL.INFO_PLAN_CAB CAB 
            LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET DET
              ON CAB.ID_PLAN = DET.PLAN_ID
            LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO
              ON DET.PRODUCTO_ID = PRO.ID_PRODUCTO
            WHERE CAB.ID_PLAN = Ln_IdPlan AND PRO.ESTADO = 'Activo' AND PRO.NOMBRE_TECNICO = 'CAMARA IP';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              Ln_HayNetLifeCam := 0;
          END;
          IF (Ln_HayNetLifeCam > 0) THEN
            Lv_NombreProceso :=  'SOLICITAR NUEVO SERVICIO NETLIFECAM';
          END IF;
        END IF;
        OPEN C_GET_PROCESO(Lv_NombreProceso);
        FETCH C_GET_PROCESO INTO Ln_IdProceso;
        CLOSE C_GET_PROCESO;      
        IF (Ln_IdProceso IS NOT NULL AND Lv_PrefijoEmpresa = 'MD') THEN
            IF (Ln_IdPlan IS NOT NULL) THEN
                DB_COMERCIAL.TECNK_SERVICIOS.P_VERIFICA_TECNOLOGIA_DB(NULL, NULL, NULL, Ln_IdServicio, Pv_Status, Pv_Mensaje, Lv_ModelosEquiposOntXTipoOnt, Lv_ModelosEquiposEdbXTipoOnt, Lv_ModelosEquiposWdb, Lv_ModelosEquiposEdb);
                IF (Pv_Status = 'OK') THEN 
                  BEGIN
                    SELECT NVL(CAB.ID_PLAN,0) 
                    INTO Ln_HayExtenderDualBand
                    FROM DB_COMERCIAL.INFO_PLAN_CAB CAB 
                    LEFT JOIN DB_COMERCIAL.INFO_PLAN_DET DET
                      ON CAB.ID_PLAN = DET.PLAN_ID
                    LEFT JOIN DB_COMERCIAL.ADMI_PRODUCTO PRO
                      ON DET.PRODUCTO_ID = PRO.ID_PRODUCTO
                    WHERE CAB.ID_PLAN = Ln_IdPlan AND PRO.ESTADO = 'Activo' AND PRO.NOMBRE_TECNICO = 'EXTENDER_DUAL_BAND'; 
                  EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                      Ln_HayExtenderDualBand := 0;
                  END;
                  OPEN C_COUNT_SERVICIO_ADICIONAL(Ln_IdPunto, 'EXTENDER_DUAL_BAND', Lv_CodEmpresa);
                  FETCH C_COUNT_SERVICIO_ADICIONAL INTO Ln_CuantosServAdicional;
                  IF C_COUNT_SERVICIO_ADICIONAL%NOTFOUND THEN
                    Ln_CuantosServAdicional := NULL;
                    CLOSE C_COUNT_SERVICIO_ADICIONAL;
                    RAISE Le_Errors;
                  END IF;
                  CLOSE C_COUNT_SERVICIO_ADICIONAL;   
                  IF (Ln_CuantosServAdicional > 0) THEN
                    DB_COMERCIAL.TECNK_SERVICIOS.P_VERIFICA_EQUIPO_ENLAZADO(Ln_IdServicio, NULL, NULL, NULL, NULL, Pv_Status, Pv_Mensaje, Lv_TieneAlgunEquipoEnlazado, Lv_InfoEquipoEncontrado, Lcl_TrazaElementos);
                    IF Pv_status = 'ERROR' THEN
                      Pv_Mensaje := 'No se ha podido verificar los equipos enlazados. Por favor comuníquese con Sistemas!';
                      RAISE Le_Errors;
                    END IF;  
                  END IF;
              END IF;
           END IF;   
              FOR REG IN C_GET_TAREAS(Ln_IdProceso, 'Eliminado') LOOP
                OPEN C_GET_DETALLE(Ln_IdFactibilidad, REG.ID_TAREA);
                FETCH C_GET_DETALLE INTO Ln_IdDetalle;
                CLOSE C_GET_DETALLE;  
                OPEN C_LAST_DETALLE_SOL_HIST(Ln_IdFactibilidad);
                FETCH C_LAST_DETALLE_SOL_HIST INTO Ln_IdSolicitudHistorial;
                CLOSE C_LAST_DETALLE_SOL_HIST;  
                OPEN C_GET_DETALLE_SOL_HIST(Ln_IdSolicitudHistorial);
                FETCH C_GET_DETALLE_SOL_HIST INTO Ld_FechaIniPlan;
                CLOSE C_GET_DETALLE_SOL_HIST;               
                Lb_HayDetalle := FALSE;
                FOR REG2 IN C_GET_TAREAS_ABIERTAS(Ln_IdDetalle) LOOP
                  Lb_HayDetalle := TRUE;
                  IF (Ld_FechaIniPlan IS NOT NULL) THEN
                    UPDATE DB_SOPORTE.INFO_DETALLE SET FE_SOLICITADA = Ld_FechaIniPlan WHERE ID_DETALLE = Ln_IdDetalle;
                  END IF;
                END LOOP;
                IF (NOT Lb_HayDetalle) THEN
                  INSERT INTO DB_SOPORTE.INFO_DETALLE(ID_DETALLE, DETALLE_SOLICITUD_ID, TAREA_ID, LONGITUD, LATITUD, OBSERVACION, PESO_PRESUPUESTADO, VALOR_PRESUPUESTADO, USR_CREACION, IP_CREACION, FE_CREACION, FE_SOLICITADA)
                  VALUES (DB_SOPORTE.SEQ_INFO_DETALLE.NEXTVAL, Ln_IdFactibilidad, REG.ID_TAREA, Lv_Longitud, Lv_Latitud, Lv_ObservacionCoordina, 0, 0, Lv_UsrCreacion, Lv_IpCreacion, sysdate, Ld_FechaIniPlan)
                  RETURNING ID_DETALLE INTO Ln_IdDetalle;
                END IF;
                OPEN C_GET_ULTIMA_ASIGNACION(Ln_IdDetalle);
                FETCH C_GET_ULTIMA_ASIGNACION INTO Ln_PersonaEmpRolAsig;
                CLOSE C_GET_ULTIMA_ASIGNACION;   
                INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO(ID_SEGUIMIENTO, DETALLE_ID, OBSERVACION, USR_CREACION, ESTADO_TAREA, FE_CREACION, INTERNO, DEPARTAMENTO_ID, PERSONA_EMPRESA_ROL_ID, EMPRESA_COD)
                VALUES (DB_SOPORTE.SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL, Ln_IdDetalle, Lv_ObservacionCoordina, Lv_UsrCreacion, 'AsignadoTarea', sysdate, 'N', Ln_IdDepartamento, Ln_PersonaEmpRolAsig, Lv_CodEmpresa);
                INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO (ID_DOCUMENTO, MENSAJE, NOMBRE_DOCUMENTO, CLASE_DOCUMENTO_ID, FE_CREACION, ESTADO, USR_CREACION, IP_CREACION, EMPRESA_COD)
                VALUES (DB_COMUNICACION.SEQ_INFO_DOCUMENTO.NEXTVAL, 'Tarea generada automáticamente por el sistema Telcos', 'Registro de llamada.', 24, sysdate, 'Activo', Lv_UsrCreacion, Lv_IpCreacion, Lv_CodEmpresa)
                RETURNING ID_DOCUMENTO INTO Ln_IdDocumento;
                INSERT INTO DB_COMUNICACION.INFO_COMUNICACION (ID_COMUNICACION, FORMA_CONTACTO_ID, REMITENTE_ID, REMITENTE_NOMBRE, CLASE_COMUNICACION, DETALLE_ID, FECHA_COMUNICACION, ESTADO, FE_CREACION, USR_CREACION, IP_CREACION, EMPRESA_COD)
                VALUES (DB_COMUNICACION.SEQ_INFO_COMUNICACION.NEXTVAL, 5, Ln_IdPunto, Lv_LoginPunto, 'Recibido', Ln_IdDetalle, sysdate, 'Activo', sysdate, Lv_UsrCreacion, Lv_IpCreacion, Lv_CodEmpresa)
                RETURNING ID_COMUNICACION INTO Ln_IdComunicacion;
                INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION (ID_DOCUMENTO_COMUNICACION, COMUNICACION_ID, DOCUMENTO_ID, FE_CREACION, USR_CREACION, IP_CREACION, ESTADO)
                VALUES (DB_COMUNICACION.SEQ_DOCUMENTO_COMUNICACION.NEXTVAL, Ln_IdComunicacion, Ln_IdDocumento, SYSDATE, Lv_UsrCreacion, Lv_IpCreacion, 'Activo');
              END LOOP;
              IF (Lv_Origen IN('local', 'MOVIL')) THEN
                UPDATE DB_COMERCIAL.INFO_DETALLE_SOLICITUD SET ESTADO = 'AsignadoTarea' WHERE ID_DETALLE_SOLICITUD = Ln_IdFactibilidad;
              END IF;
            END IF;
        END IF;
      Lv_EmailVendedor:= 'notificaciones_telcos@telconet.ec';
      FOR REG IN C_GET_FORMAS_CONTACTO_LOGIN(Lv_LoginVendedor, 'Correo Electronico') LOOP
        Lv_EmailVendedor := Lv_EmailVendedor || ',' ||REG.VALOR;
      END LOOP;
      OPEN Pcl_Response FOR SELECT Ln_IdFactibilidad as idDetalleSolicitud, Lv_NombreCliente as nombreCliente, Lv_LoginPunto as login, Lv_EmailVendedor as destinatarios, Lv_NombreJurisdiccion as nombreJurisdiccion,
                                   Lv_DireccionPunto     as direccion, Lv_NombrePlan as descripcionProducto, sysdate as feCreacion, Lv_UsrCreacion as usrCreacion, Ld_FechaIniPlan as fechaPlanificacion, Lv_UsrCreacion as usrPlanificacion,
                                   Lv_ObservacionCoordina as observacion, 'Planificada' as estado, Ln_IdDetalle as idDetalle, Ln_IdComunicacion as idComunicacion, Pn_IdServicioHistorial as idServicioHistorial FROM DUAL;
      Pv_Status     := 'OK';
      Pv_Mensaje    := 'Transacción exitosa';
      COMMIT;
      EXCEPTION
      WHEN Le_Errors THEN
        Pv_Status  := 'ERROR';
        dbms_output.put_line('asignar mensaje comercial => ' || Pv_Mensaje);
        ROLLBACK;
      WHEN OTHERS THEN
        Pv_Status  := 'ERROR';
        Pv_Mensaje := SQLERRM; 
        dbms_output.put_line('asignar mensaje comercial => ' || Pv_Mensaje);
        ROLLBACK;
    END P_ASIGNAR_PLANIFICACION;

    FUNCTION F_JSON_SERVICIOS_GESTION (Pn_IdSolicitud                  IN NUMBER,
                                       Pv_ParamProdGestionSimultanea   IN VARCHAR2,
                                       Pv_OpcionGestionSimultanea      IN VARCHAR2)
    RETURN CLOB AS
    Lv_JsonRetorno CLOB;
    Pv_Status VARCHAR2(10);
    Pv_Mensaje VARCHAR2(4000);
    BEGIN
     P_JSON_SERVICIOS_GESTION (Pn_IdSolicitud,
                                 Pv_ParamProdGestionSimultanea,
                                 Pv_OpcionGestionSimultanea,
                                 Pv_Status,
                                 Pv_Mensaje,                                       
                                 Lv_JsonRetorno);
    
    
    RETURN Lv_JsonRetorno;
    END F_JSON_SERVICIOS_GESTION;
    
     PROCEDURE P_JSON_SERVICIOS_GESTION (Pn_IdSolicitud                IN NUMBER,
                                         Pv_ParamProdGestionSimultanea   IN VARCHAR2,
                                         Pv_OpcionGestionSimultanea      IN VARCHAR2,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2,                                       
                                         Pv_Response                     OUT CLOB)
    IS
    CURSOR C_GET_SOLICITUD(Ln_ServicioId NUMBER)
    IS
    SELECT 
        ID_DETALLE_SOLICITUD
    FROM     
        DB_COMERCIAL.INFO_DETALLE_SOLICITUD
    WHERE servicio_id = Ln_ServicioId
      and estado = 'PrePlanificada'
      and rownum = 1;

    CURSOR C_GET_SERVICIOS_SIMULTANEOS(Ln_PuntoId NUMBER)
    IS
    SELECT 
       SER.ID_SERVICIO, SER.PRODUCTO_ID
    FROM
       DB_COMERCIAL.INFO_SERVICIO SER
    WHERE SER.PUNTO_ID = Ln_PuntoId
      AND SER.ESTADO NOT IN ('Activo', 'Rechazado', 'Rechazada', 'Anulado', 'Anulada')
      AND SER.PRODUCTO_ID IS NOT NULL;
                             
      
      
    CURSOR C_GET_PUNTO (Ln_SolicitudId NUMBER)
    IS 
    SELECT PUN.ID_PUNTO
    FROM DB_COMERCIAL.INFO_DETALLE_SOLICITUD IDS
    LEFT JOIN DB_COMERCIAL.INFO_SERVICIO SER
      ON IDS.SERVICIO_ID = SER.ID_SERVICIO
    LEFT JOIN DB_COMERCIAL.INFO_PUNTO PUN
      ON SER.PUNTO_ID = PUN.ID_PUNTO
    WHERE ids.id_detalle_solicitud =  Ln_SolicitudId;
      
      
    Lv_JsonRetorno CLOB;
    TYPE Ln_IdSolGestionada    IS TABLE OF NUMBER(10);
    TYPE Lv_DescripTipoSolGestionada     IS TABLE OF VARCHAR2(70);
    TYPE Ln_IdPlanServicioGestionado    IS TABLE OF NUMBER(10);
    TYPE Lv_DescripcionTipoSolGesti     IS TABLE OF VARCHAR2(70);
    TYPE Ln_IdPlanServicioSimultaneo    IS TABLE OF NUMBER(10);
    TYPE Ln_IdServicioSimultaneo        IS TABLE OF NUMBER(10);
    TYPE Ln_IdProdServicioSimultaneo    IS TABLE OF NUMBER(10);
    TYPE Lv_DescripServicioSimultaneo   IS TABLE OF VARCHAR2(300);
    TYPE Lv_EstadoServicioSimultaneo    IS TABLE OF VARCHAR2(100);
    TYPE Ln_IdSolSimultanea             IS TABLE OF NUMBER(10);
    TYPE Lv_DescripTipoSolSimultanea    IS TABLE OF VARCHAR2(70);
    TYPE Lv_EstadoSolSimultanea         IS TABLE OF VARCHAR2(100);
    TYPE Ln_IdDetSolCaract              IS TABLE OF NUMBER(10);
    TYPE Ln_IdPuntoGestionado           IS TABLE OF NUMBER(10);
    TYPE Ln_IdJursidiccionPunto         IS TABLE OF NUMBER(10);
    TYPE Ln_CupoJurisdiccion            IS TABLE OF NUMBER(10);
    TYPE Lv_OpcionGestionSimultanea     IS TABLE OF VARCHAR2(100);
    V_IdSolGestionada                   Ln_IdSolGestionada;
    V_DescripTipoSolGestionada          Lv_DescripTipoSolGestionada;
    V_IdPlanServicioGestionado          Ln_IdPlanServicioGestionado;
    V_DescripcionTipoSolGestionada      Lv_DescripcionTipoSolGesti;
    V_IdPlanServicioSimultaneo          Ln_IdPlanServicioSimultaneo;
    V_IdServicioSimultaneo              Ln_IdServicioSimultaneo;
    V_IdProdServicioSimultaneo          Ln_IdProdServicioSimultaneo;
    V_DescripServicioSimultaneo         Lv_DescripServicioSimultaneo;
    V_EstadoServicioSimultaneo          Lv_EstadoServicioSimultaneo;
    V_IdSolSimultanea                   Ln_IdSolSimultanea;
    V_DescripTipoSolSimultanea          Lv_DescripTipoSolSimultanea;
    V_EstadoSolSimultanea               Lv_EstadoSolSimultanea;
    V_IdDetSolCaract                    Ln_IdDetSolCaract;
    V_IdPuntoGestionado                 Ln_IdPuntoGestionado;
    V_IdJursidiccionPunto               Ln_IdJursidiccionPunto;
    V_CupoJurisdiccion                  Ln_CupoJurisdiccion;
    V_OpcionGestionSimultanea           Lv_OpcionGestionSimultanea;
    i PLS_INTEGER						:= 0;  
    Ln_Numero NUMBER;
    Ln_IdPunto NUMBER := 0;

    Lc_Consulta SYS_REFCURSOR;
    Ln_IdSolicitud NUMBER;
    BEGIN
      Lv_JsonRetorno := Lv_JsonRetorno || '[ ';
      DB_COMERCIAL.TECNK_SERVICIOS.P_GET_INFO_GESTION_SIMULTANEA(Pn_IdSolicitud,
                                                                 NULL,
                                                                 Pv_OpcionGestionSimultanea,
                                                                 Pv_Status,
                                                                 Pv_Mensaje,
                                                                 Lc_Consulta);   

      LOOP
        FETCH Lc_Consulta BULK COLLECT INTO  V_IdSolGestionada, V_DescripTipoSolGestionada, V_IdPlanServicioGestionado, V_IdServicioSimultaneo, V_IdPlanServicioSimultaneo,
                               V_IdProdServicioSimultaneo, V_DescripServicioSimultaneo, V_EstadoServicioSimultaneo, V_IdSolSimultanea, V_DescripTipoSolSimultanea,
                               V_EstadoSolSimultanea, V_IdDetSolCaract, V_IdPuntoGestionado, V_IdJursidiccionPunto, V_CupoJurisdiccion, V_OpcionGestionSimultanea;
        EXIT WHEN V_IdSolGestionada.count=0;
        i := V_IdPlanServicioGestionado.FIRST;
        WHILE (i IS NOT NULL) 
        LOOP
            DBMS_LOB.APPEND(Lv_JsonRetorno, '{"idPlanServicioGestionado":' || nvl(V_IdPlanServicioGestionado(i),0) || ',');
            DBMS_LOB.APPEND(Lv_JsonRetorno, '"descripTipoSolGestionada":"' || trim(V_DescripTipoSolGestionada(i)) || '", ');
            DBMS_LOB.APPEND(Lv_JsonRetorno, '"idPlanServicioSimultaneo":' || nvl(V_IdPlanServicioSimultaneo(i),0) || ', ');
            DBMS_LOB.APPEND(Lv_JsonRetorno, '"idServicioSimultaneo":' || V_IdServicioSimultaneo(i) || ', ');
            DBMS_LOB.APPEND(Lv_JsonRetorno, '"idProdServicioGestionado":"' || V_IdProdServicioSimultaneo(i) || '", ');
            DBMS_LOB.APPEND(Lv_JsonRetorno, '"descripServicioSimultaneo":"' || V_DescripServicioSimultaneo(i) || '", ');
            DBMS_LOB.APPEND(Lv_JsonRetorno, '"estadoServicioSimultaneo":"' || V_EstadoServicioSimultaneo(i) || '", ');
            DBMS_LOB.APPEND(Lv_JsonRetorno, '"idProdServicioSimultaneo":"' || V_IdProdServicioSimultaneo(i) || '",');
            DBMS_LOB.APPEND(Lv_JsonRetorno, '"idSolicitudSimultanea":'   || V_IdSolSimultanea(i) || '');
            Ln_IdPunto := V_IdPuntoGestionado(i);
            DBMS_LOB.APPEND(Lv_JsonRetorno, '},');
            i := V_IdSolGestionada.NEXT(i);
        END LOOP;
      END LOOP;
      dbms_output.put_line('SOLICITUD ' || Pn_IdSolicitud);
      OPEN C_GET_PUNTO(Pn_IdSolicitud);
      FETCH C_GET_PUNTO INTO Ln_IdPunto;
      CLOSE C_GET_PUNTO;  
      dbms_output.put_line('PUNTO ' || Ln_IdPunto);
      FOR REG IN C_GET_SERVICIOS_SIMULTANEOS(Ln_IdPunto) LOOP
            IF (instr(Lv_JsonRetorno, ''||REG.PRODUCTO_ID, 1) = 0) THEN
                OPEN C_GET_SOLICITUD(REG.ID_SERVICIO);
                FETCH C_GET_SOLICITUD INTO Ln_IdSolicitud;
                CLOSE C_GET_SOLICITUD;
                DBMS_LOB.APPEND(Lv_JsonRetorno, '{"idPlanServicioGestionado":' || 0 || ',');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '"descripTipoSolGestionada":"' || '' || '", ');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '"idPlanServicioSimultaneo":' || 0 || ', ');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '"idServicioSimultaneo":' || REG.ID_SERVICIO || ', ');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '"idProdServicioGestionado":"' || 0 || '", ');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '"descripServicioSimultaneo":"' ||'' || '", ');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '"estadoServicioSimultaneo":"' ||'' || '", ');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '"idProdServicioSimultaneo":"' || REG.PRODUCTO_ID || '",');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '"idSolicitudSimultanea":'   || nvl(Ln_IdSolicitud,0) || '');
                DBMS_LOB.APPEND(Lv_JsonRetorno, '},');       
            END IF;    
      END LOOP;
      Lv_JsonRetorno := SUBSTR(Lv_JsonRetorno, 0, LENGTH(Lv_JsonRetorno) - 1);
      DBMS_LOB.APPEND(Lv_JsonRetorno, ']');
      dbms_output.put_line(Lv_JsonRetorno);      
      CLOSE Lc_Consulta;      
      Pv_Status := 'OK';
      Pv_Mensaje := 'Transaccion Exitosa';
      Pv_Response := Lv_JsonRetorno;    
    END P_JSON_SERVICIOS_GESTION;    
       
END CMKG_PLANIFICACION_COMERCIAL;
/