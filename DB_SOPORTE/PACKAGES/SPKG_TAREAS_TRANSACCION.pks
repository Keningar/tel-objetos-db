CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_TAREAS_TRANSACCION AS 

  /** 
   * Documentación para el proceso 'P_CREAR_TAREA'
   *
   * Procedimiento encargado de registrar una tarea en sus diferentes estructuras
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
   * @param Prf_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    22-10-2021
   */
  PROCEDURE P_CREAR_TAREA (Pcl_Request  IN CLOB,
                           Pv_Status    OUT VARCHAR2,
                           Pv_Mensaje   OUT VARCHAR2,
                           Prf_Response OUT SYS_REFCURSOR);

  /** 
   * Documentación para el proceso 'P_ASIGNAR_RESPONSABLE_TAREA'
   *
   * Procedimiento encargado de asignar a el/los responsable(s) a la tarea, segun la informacion recibida 
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    25-10-2021
   */
  PROCEDURE P_ASIGNAR_RESPONSABLE_TAREA (Pcl_Request  IN CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2);

  /** 
   * Documentación para el proceso 'P_INSERT_TAREA_SEGUIMIENTO'
   *
   * Procedimiento encargado de registrar la información del seguimiento de la tarea
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   * @param Pv_Status      OUT  VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje     OUT  VARCHAR2 Retorna mensaje de la transacción
   * @param Prf_Response   OUT  SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    22-10-2021
   */                         
  PROCEDURE P_INSERT_TAREA_SEGUIMIENTO(Pcl_Request      IN CLOB,
                                       Pn_IdSeguimiento OUT INFO_TAREA_SEGUIMIENTO.ID_SEGUIMIENTO%TYPE,
                                       Pv_Status        OUT VARCHAR2,
                                       Pv_Mensaje       OUT VARCHAR2);                        

  /**
   * Documentación para proceso 'P_ADJUNTAR_DOCUMENTOS_TAREA'
   *
   * Procedimiento encargado de adjuntar uno o varios documentos a la tarea
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la transacción
   * @param Prf_Response  OUT SYS_REFCURSOR Retorna cursor de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    15-11-2021
   */
  PROCEDURE P_ADJUNTAR_DOCUMENTOS_TAREA(Pcl_Request  IN CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Prf_Response OUT SYS_REFCURSOR);

  /** 
   * Documentación para el proceso 'P_INSERT_TAREA_CARACTERISTICA'
   *
   * Procedimiento encargado de relacionar una tarea (actividad) con una caracteristica
   *
   * @param Pcl_Request    IN   CLOB Recibe json request
   * @param Pn_IdTareaCaracteristica  OUT INFO_TAREA_CARACTERISTICA.ID_TAREA_CARACTERISTICA%TYPE
   * @param Pv_Status                 OUT  VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje                OUT  VARCHAR2 Retorna mensaje de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    15-11-2021
   */                                      
  PROCEDURE P_INSERT_TAREA_CARACTERISTICA(Pcl_Request               IN CLOB,
                                          Pn_IdTareaCaracteristica  OUT INFO_TAREA_CARACTERISTICA.ID_TAREA_CARACTERISTICA%TYPE,
                                          Pv_Status                 OUT VARCHAR2,
                                          Pv_Mensaje                OUT VARCHAR2);                                        

END SPKG_TAREAS_TRANSACCION;

/

CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_TAREAS_TRANSACCION AS

  PROCEDURE P_CREAR_TAREA (Pcl_Request  IN CLOB,
                           Pv_Status    OUT VARCHAR2,
                           Pv_Mensaje   OUT VARCHAR2,
                           Prf_Response OUT SYS_REFCURSOR) AS
  
  Lr_InfoTarea          Info_Tarea%ROWTYPE;
  Lr_AdmiTarea          SPKG_TYPES.Ltr_AdmiTarea;
  Lr_AdmiProceso        SPKG_TYPES.Ltr_AdmiProceso;
  Lr_InfoPunto          DB_COMERCIAL.INFO_PUNTO%ROWTYPE;
  Lr_InfoPersona        DB_COMERCIAL.INFO_PERSONA%ROWTYPE;
  Lr_AdmiFormaContacto  DB_COMERCIAL.ADMI_FORMA_CONTACTO%ROWTYPE;
  Lr_AdmiParametroDet   DB_GENERAL.ADMI_PARAMETRO_DET%ROWTYPE;
  Lv_CodEmpresa         DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
  Ln_IdDetalleHipotesis Info_Detalle_Hipotesis.Id_Detalle_Hipotesis%TYPE;
  Ln_IdComunicacion     DB_COMUNICACION.Info_Comunicacion.id_Comunicacion%TYPE;
  Lv_FormaContacto      DB_COMERCIAL.Admi_Forma_Contacto.Codigo%TYPE;
  Ln_IdTareaCaract      Info_Tarea_Caracteristica.Id_Tarea_Caracteristica%TYPE;
  Ln_IdCriterioAfectado Info_Criterio_Afectado.id_Criterio_Afectado%TYPE;
  Ln_IdParteAfectada    Info_Parte_Afectada.id_Parte_Afectada%TYPE;
  Ln_IdCaso             Info_Caso.Id_Caso%TYPE;
  Lv_NombreProceso      Admi_Proceso.Nombre_Proceso%TYPE;
  Lv_NombreTarea        Admi_Tarea.Nombre_Tarea%TYPE;
  Ln_IdDetalle          Info_Detalle.Id_Detalle%TYPE;
  Lrf_Procesos          SYS_REFCURSOR;
  Lrf_Tareas            SYS_REFCURSOR;
  Ln_IdDetalleSolicitud NUMBER;
  Ln_idAsignado         NUMBER;
  Ln_IdDeptoOrigen      NUMBER;
  Lv_FeSolicitud        VARCHAR2(25);
  Lv_TipoAsignado       VARCHAR2(25);
  Lv_Code               VARCHAR2(25);
  Lv_TipoSoporte        VARCHAR2(100);
  Lv_Status             VARCHAR2(25);
  Lv_Mensaje            VARCHAR2(3000);
  Lb_AsignarTarea       BOOLEAN;
  Lb_NoExisteProceso    BOOLEAN := true;
  Lb_NoExisteTarea      BOOLEAN := true;
  Lcl_Request           CLOB;
  Lcl_MotivoTarea       CLOB;
  Lcl_VendedorCliente   CLOB;
  Li_Cont               PLS_INTEGER;
  Le_Error              EXCEPTION;

  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodEmpresa := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Lv_NombreProceso := APEX_JSON.get_varchar2(p_path => 'nombreProceso');
    Lv_NombreTarea := APEX_JSON.get_varchar2(p_path => 'nombreTarea');
    Lv_FormaContacto := APEX_JSON.get_varchar2(p_path => 'formaContacto');
    Lv_FeSolicitud :=  APEX_JSON.get_varchar2(p_path => 'fechaSolicitud');
    Ln_IdCaso :=  APEX_JSON.get_number(p_path => 'idCaso');
    Ln_IdDetalleHipotesis :=  APEX_JSON.get_number(p_path => 'idDetalleHipotesis');
    Lr_InfoTarea.Observacion := APEX_JSON.get_clob(p_path => 'observacion');
    Ln_IdDetalleSolicitud := APEX_JSON.get_number(p_path => 'idDetalleSolicitud');
    Lr_InfoPunto.Id_Punto := APEX_JSON.get_number('punto.idPunto');
    Lr_InfoPunto.Login    := APEX_JSON.get_varchar2('punto.login');
    Lr_InfoPunto.Nombre_Punto := APEX_JSON.get_varchar2('punto.nombrePunto');
    Lr_InfoPersona.Id_Persona := APEX_JSON.get_number('persona.idPersona');
    Lr_InfoPersona.Nombres := APEX_JSON.get_varchar2('persona.nombres');
    Lr_InfoPersona.Apellidos := APEX_JSON.get_varchar2('persona.apellidos');
    Lr_InfoPersona.Razon_Social := APEX_JSON.get_varchar2('persona.razonSocial');
    Lb_AsignarTarea := APEX_JSON.get_boolean('asignarTarea');
    Lv_TipoAsignado := APEX_JSON.get_varchar2('tipoAsignado');
    Ln_idAsignado := APEX_JSON.get_number('idAsignado');
    Ln_IdDeptoOrigen :=  APEX_JSON.get_number('idDepartamentoOrigen');
    Lcl_MotivoTarea := APEX_JSON.get_clob(p_path => 'motivoTarea');
    Lv_TipoSoporte                  := APEX_JSON.get_varchar2('tipoSoporte');
    Lr_InfoTarea.Usr_Creacion := APEX_JSON.get_varchar2(p_path => 'usuario');
    Lr_InfoTarea.Ip_Creacion := APEX_JSON.get_varchar2(p_path => 'ip');

    IF Lv_NombreProceso IS NULL THEN
      Pv_Mensaje := 'El parametro nombreProceso debe ser ingresado';
      RAISE Le_Error;
    END IF;

    IF Lv_NombreTarea IS NULL THEN
      Pv_Mensaje := 'El parametro nombreTarea debe ser ingresado';
      RAISE Le_Error;
    END IF;

    IF Lv_FeSolicitud IS NULL THEN
      Lv_FeSolicitud := To_Char(sysdate,'rrrr-mm-dd hh24:mi:ss');
    END IF;

    --Json para consultar el proceso
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('nombreProceso', Lv_NombreProceso);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    SPKG_SOPORTE_TAREA.P_GET_ADMI_PROCESO(Pcl_Request  => Lcl_Request,
                                          Pv_Status    => Lv_Status,
                                          Pv_Mensaje   => Lv_Mensaje,
                                          Prf_Response => Lrf_Procesos);

    LOOP
      FETCH Lrf_Procesos BULK COLLECT INTO Lr_AdmiProceso LIMIT 10;

      Li_Cont := Lr_AdmiProceso.FIRST;
      WHILE (Li_Cont IS NOT NULL) LOOP
        Lb_NoExisteProceso := false;
        --Json para consultar la tarea
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('idProceso', Lr_AdmiProceso(Li_Cont).Id_Proceso);
        APEX_JSON.WRITE('nombreTarea', Lv_NombreTarea);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        SPKG_SOPORTE_TAREA.P_GET_ADMI_TAREA(Pcl_Request  => Lcl_Request,
                                            Pv_Status    => Lv_Status,
                                            Pv_Mensaje   => Lv_Mensaje,
                                            Prf_Response => Lrf_Tareas);
      Li_Cont:= Lr_AdmiProceso.NEXT(Li_Cont);                                            
      END LOOP;
      EXIT WHEN Lrf_Procesos%NOTFOUND;
    END LOOP;

    IF Lb_NoExisteProceso THEN
      Pv_Mensaje := 'El proceso no existe';
      RAISE Le_Error;
    END IF;

    LOOP
      FETCH Lrf_Tareas BULK COLLECT INTO Lr_AdmiTarea LIMIT 10;
      Li_Cont := Lr_AdmiTarea.FIRST;
      WHILE (Li_Cont IS NOT NULL) LOOP
      Lb_NoExisteTarea := false;
      Li_Cont:= Lr_AdmiTarea.NEXT(Li_Cont);                                            
      END LOOP;
    EXIT WHEN Lrf_Tareas%NOTFOUND;
    END LOOP;

    IF Lb_NoExisteTarea THEN
      Pv_Mensaje := 'La tarea no existe';
      RAISE Le_Error;
    END IF;

    DB_COMERCIAL.CMKG_ADMI_FORMA_CONTACTO_C.P_GET_ADMI_FORMA_CONTACTO(Pv_Codigo            => Lv_FormaContacto,
                                                                      Pr_AdmiFormaContacto => Lr_AdmiFormaContacto,
                                                                      Pv_Status            => Lv_Status,
                                                                      Pv_Code              => Lv_Code,
                                                                      Pv_Msn               => Lv_Mensaje);
    IF Lr_AdmiFormaContacto.Id_Forma_Contacto IS NULL THEN
      Pv_Mensaje := 'No existe idFormaContacto con la formaContacto ingresada';
      RAISE Le_Error;
    END IF;

    --Json para crear el detalle
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idDetalleHipotesis', Ln_IdDetalleHipotesis);
    APEX_JSON.WRITE('pesoPresupuestado', 0);
    APEX_JSON.WRITE('valorPresupuestado', 0);
    APEX_JSON.WRITE('fechaHoraSolicitada', Lv_FeSolicitud);
    APEX_JSON.WRITE('idTarea', Lr_AdmiTarea(1).Id_Tarea);
    APEX_JSON.WRITE('observacion', Lr_InfoTarea.Observacion);
    APEX_JSON.WRITE('idDetalleSolicitud',Ln_IdDetalleSolicitud);
    APEX_JSON.WRITE('usuario', substr(Lr_InfoTarea.Usr_Creacion,1,16));
    APEX_JSON.WRITE('ip' , Lr_InfoTarea.Ip_Creacion);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    SPKG_DETALLES_TRANSACCION.P_INSERT_DETALLE(Pcl_Request  => Lcl_Request,
                                               Pn_IdDetalle => Ln_IdDetalle,
                                               Pv_Status    => Lv_Status,
                                               Pv_Mensaje   => Lv_Mensaje);

    IF Lv_Status <> 'OK' THEN
      Pv_Mensaje := 'Error al insertar detalle: '||Lv_Mensaje;
      RAISE le_Error;
    END IF;

    --Json para crear la comunicacion
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idFormaContacto', Lr_AdmiFormaContacto.Id_Forma_Contacto);
    APEX_JSON.WRITE('idCaso', Ln_IdCaso);
    APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
    APEX_JSON.WRITE('claseComunicacion', 'Enviado');
    APEX_JSON.WRITE('fechaComunicacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('idPunto', Lr_InfoPunto.Id_Punto);
    APEX_JSON.WRITE('idRemitente', Lr_InfoPunto.Id_Punto);
    APEX_JSON.WRITE('nombreRemitente', Lr_InfoPunto.Login);
    APEX_JSON.WRITE('estado', 'Activo');
    APEX_JSON.WRITE('codEmpresa', Lv_CodEmpresa);
    APEX_JSON.WRITE('fechaCreacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', SUBSTR(Lr_InfoTarea.Usr_Creacion,1,35));
    APEX_JSON.WRITE('ip' , Lr_InfoTarea.Ip_Creacion);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC.P_INSERT_COMUNICACION(Pcl_Request       => Lcl_Request,
                                                                      Pn_IdComunicacion => Ln_IdComunicacion,
                                                                      Pv_Status         => Lv_Status,
                                                                      Pv_Mensaje        => Lv_Mensaje);

    IF Lv_Status <> 'OK' THEN
      Pv_Mensaje := 'Error al insertar comunicacion: '||Lv_Mensaje;
      RAISE le_Error;
    END IF;

    IF Lr_InfoPunto.Id_Punto IS NOT NULL THEN
      --Json para crear el criterio afectado
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
        APEX_JSON.WRITE('criterio', 'Clientes');
        APEX_JSON.WRITE('opcion', 'Cliente: '|| Lr_InfoPunto.Nombre_Punto ||' | OPCION: Punto Cliente');
        APEX_JSON.WRITE('usuario', Lr_InfoTarea.Usr_Creacion);
        APEX_JSON.WRITE('ip' , Lr_InfoTarea.Ip_Creacion);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        Ln_IdCriterioAfectado := 1;

        SPKG_DETALLES_TRANSACCION.P_INSERT_CRITERIO_AFECTADO(Pcl_Request           => Lcl_Request,
                                                             Pn_IdCriterioAfectado => Ln_IdCriterioAfectado,
                                                             Pv_Status             => Lv_Status,
                                                             Pv_Mensaje            => Lv_Mensaje);
        IF Lv_Status <> 'OK' THEN
          Pv_Mensaje := 'Error al insertar criterio afectado: '||Lv_Mensaje;
          RAISE le_Error;
        END IF;                                                   

        --Json para crear la parte afectada
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('idCriterioAfectado', Ln_IdCriterioAfectado);
        APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
        APEX_JSON.WRITE('idAfectado', Lr_InfoPunto.Id_Punto);
        APEX_JSON.WRITE('tipoAfectado', 'Cliente');
        APEX_JSON.WRITE('nombreAfectado', Lr_InfoPunto.Login);
        APEX_JSON.WRITE('descripcionAfectado', Lr_InfoPunto.Nombre_Punto);
        APEX_JSON.WRITE('fechaInicioIncidencia', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
        APEX_JSON.WRITE('usuario', Lr_InfoTarea.Usr_Creacion);
        APEX_JSON.WRITE('ip' , Lr_InfoTarea.Ip_Creacion);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;

        SPKG_DETALLES_TRANSACCION.P_INSERT_PARTE_AFECTADA(Pcl_Request        => Lcl_Request,
                                                          Pn_IdParteAfectada => Ln_IdParteAfectada,
                                                          Pv_Status          => Lv_Status,
                                                          Pv_Mensaje         => Lv_Mensaje);

        IF Lv_Status <> 'OK' THEN
          Pv_Mensaje := 'Error al insertar parte afectada: '||Lv_Mensaje;
          RAISE le_Error;
        END IF;                                                          
    END IF;

    IF Lb_AsignarTarea THEN

      IF Lv_TipoAsignado IS NULL THEN
        Pv_Mensaje := 'Si asignarTarea es true, debe ingresar tipoAsignado';
          RAISE le_Error;
      END IF;

      IF Lv_TipoSoporte IS NOT NULL THEN
        DB_GENERAL.GNKG_PARAMETRO_CONSULTA.P_GET_DETALLE_PARAMETRO(Pv_NombreParametro   => 'MS_CORE_SOPORTE', 
                                                                    Pv_Descripcion       => 'TS_'||Lv_TipoSoporte,
                                                                    Pv_Empresa_Cod       => Nvl(Lv_CodEmpresa,10),
                                                                    Pr_AdmiParametroDet  => Lr_AdmiParametroDet,
                                                                    Pv_Status            => Lv_Status,
                                                                    Pv_Mensaje           => Lv_Mensaje);
        Ln_IdAsignado := Lr_AdmiParametroDet.Valor3;                                                                  
      END IF;

      IF Lv_TipoSoporte IN ('COMERCIAL','COBRANZAS') THEN
        --Json para consultar el asesor comercial del cliente
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('codEmpresa', Nvl(Lv_CodEmpresa,'10'));
        APEX_JSON.WRITE('estado','Activo');
        APEX_JSON.WRITE('idPersona',Lr_InfoPersona.Id_Persona);
        APEX_JSON.CLOSE_OBJECT;
        Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        DB_COMERCIAL.CMKG_CONSULTA_CLIENTE.P_CONSULTA_VENDEDOR_CLIENTE(Lcl_Request,
                                                                       Lv_Status,
                                                                       Lv_Mensaje,
                                                                       Lcl_VendedorCliente);

        APEX_JSON.PARSE(Lcl_VendedorCliente);
        Ln_IdAsignado := APEX_JSON.get_varchar2(p_path => 'idPersonaEmpresaRol');
      END IF;

      IF Ln_IdAsignado IS NULL THEN
        Pv_Mensaje := 'Si asignarTarea es true, debe ingresar idAsignado';
        RAISE le_Error;
      END IF;      

      --Json para crear asignar responsable tarea
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('codEmpresa', Lv_CodEmpresa);
      APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
      APEX_JSON.WRITE('tipoAsignado', Lv_TipoAsignado);
      APEX_JSON.WRITE('idAsignado', Ln_IdAsignado);
      APEX_JSON.WRITE('idDepartamentoOrigen', Ln_IdDeptoOrigen);
      APEX_JSON.WRITE('motivoTarea', Lcl_MotivoTarea);
      APEX_JSON.WRITE('nombreProceso', Lv_NombreProceso);
      APEX_JSON.WRITE('idComunicacion', Ln_IdComunicacion);
      APEX_JSON.WRITE('usuario', Lr_InfoTarea.Usr_Creacion);
      APEX_JSON.WRITE('ip' , Lr_InfoTarea.Ip_Creacion);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      P_ASIGNAR_RESPONSABLE_TAREA(Pcl_Request => Lcl_Request,
                                  Pv_Status   => Lv_Status,
                                  Pv_Mensaje  => Lv_Mensaje);

      IF Lv_Status <> 'OK' THEN
        Pv_Mensaje := 'Error al asignar responsable de tarea: '||Lv_Mensaje;
        RAISE le_Error;
      END IF;                                    
    END IF;

    --Json para crer caracteristica a la tarea con la persona que solicita 
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idTarea', Ln_IdComunicacion);
    APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
    APEX_JSON.WRITE('caracteristica', 'REFERENCIA_PERSONA');
    APEX_JSON.WRITE('valor', Lr_InfoPersona.Id_Persona);
    APEX_JSON.WRITE('estado', 'Activo');
    APEX_JSON.WRITE('usuario', Lr_InfoTarea.Usr_Creacion);
    APEX_JSON.WRITE('ip', Lr_InfoTarea.Ip_Creacion);

    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    P_INSERT_TAREA_CARACTERISTICA(Pcl_Request               => Lcl_Request,
                                  Pn_IdTareaCaracteristica  => Ln_IdTareaCaract,
                                  Pv_Status                 => Lv_Status,
                                  Pv_Mensaje                => Lv_Mensaje);

    IF Lv_Status != 'OK' THEN
      Pv_Mensaje := 'No es posible crear la caracteristica a la tarea: '|| Lv_Mensaje;
      RAISE Le_Error;
    END IF;

    COMMIT;

    SPKG_INFO_TAREA.P_CREA_INFO_TAREA(Pn_Id_Detalle   => Ln_IdDetalle,
                                      Pv_Usr_Creacion => Lr_InfoTarea.Usr_Creacion, 
                                      Pv_Status       => Lv_Status,
                                      Pv_Message      => Lv_Mensaje);

    COMMIT;

    OPEN Prf_Response FOR
      SELECT Ico.Id_Comunicacion AS numeroTarea, 
        Ico.Detalle_Id AS idDetalle
    FROM
      Db_Comunicacion.Info_Comunicacion Ico
    WHERE 
      Ico.Id_Comunicacion = Ln_IdComunicacion;

    Pv_Status := 'OK';                                    
    Pv_Mensaje := 'Tarea creada correctamente';

  EXCEPTION
    WHEN Le_Error THEN
      Pv_Status := 'ERROR';
      ROLLBACK;
    WHEN OTHERS THEN
      Pv_Status := 'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
      ROLLBACK;  
  END P_CREAR_TAREA;

  PROCEDURE P_ASIGNAR_RESPONSABLE_TAREA (Pcl_Request  IN CLOB,
                                         Pv_Status    OUT VARCHAR2,
                                         Pv_Mensaje   OUT VARCHAR2) AS

    Lv_Status                 VARCHAR2(25);
    Lv_Mensaje                VARCHAR2(3000);
    Lv_TipoAsignado           VARCHAR2(25);
    Lv_Observacion            VARCHAR2(3000);
    Ln_IdAsignado             NUMBER;
    Ln_IdDeptoOrigen          NUMBER;
    Lcl_MotivoTarea           CLOB;
    Lcl_Request               CLOB;
    Lrf_ClasesDocumento       SYS_REFCURSOR;
    Lrf_Departamento          SYS_REFCURSOR;
    Lrf_Persona               SYS_REFCURSOR;
    Lr_ClaseDocumento         SPKG_TYPES.Ltr_ClaseDocumento;
    Lr_Departamento           DB_GENERAL.GNKG_TYPES.Ltr_Departamento;
    Lr_InfoPersona            SPKG_TYPES.Ltr_InfoPersona;
    Lr_InfoOficinaGrupo       DB_COMERCIAL.INFO_OFICINA_GRUPO%ROWTYPE;
    Lr_InfoPersonaEmpresaRol  DB_COMERCIAL.INFO_PERSONA_EMPRESA_ROL%ROWTYPE;
    Lr_InfoDetalleAsignacion  INFO_DETALLE_ASIGNACION%ROWTYPE;
    Ln_IdDetalle              INFO_DETALLE.ID_DETALLE%TYPE;
    Ln_IdDetalleAsignacion    INFO_DETALLE_ASIGNACION.ID_DETALLE_ASIGNACION%TYPE;
    Ln_IdDetalleHistorial     INFO_DETALLE_HISTORIAL.ID_DETALLE_HISTORIAL%TYPE;
    Ln_IdSeguimiento          INFO_TAREA_SEGUIMIENTO.ID_SEGUIMIENTO%TYPE; 
    Lv_CodEmpresa             DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Ln_IdComunicacion         DB_COMUNICACION.INFO_COMUNICACION.ID_COMUNICACION%TYPE;
    Lv_Usuario                INFO_COMUNICACION.USR_CREACION%TYPE;
    Lv_Ip                     INFO_COMUNICACION.IP_CREACION%TYPE;
    Ln_IdDocumento            DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Ln_IdDocComunicacion      DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION.ID_DOCUMENTO_COMUNICACION%TYPE;      
    Lv_NombreProceso          ADMI_PROCESO.NOMBRE_PROCESO%TYPE;  
    Le_Error                  EXCEPTION;
  BEGIN
    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodEmpresa := APEX_JSON.get_varchar2(p_path => 'codEmpresa');
    Ln_IdDetalle := APEX_JSON.get_number(p_path => 'idDetalle');
    Lv_TipoAsignado := APEX_JSON.get_varchar2(p_path => 'tipoAsignado');
    Ln_IdAsignado := APEX_JSON.get_number(p_path => 'idAsignado'); 
    Ln_IdDeptoOrigen := APEX_JSON.get_number(p_path => 'idDepartamentoOrigen');
    Lcl_MotivoTarea := APEX_JSON.get_clob(p_path => 'motivoTarea');
    Lv_NombreProceso := APEX_JSON.get_varchar2(p_path => 'nombreProceso');
    Ln_IdComunicacion := APEX_JSON.get_number(p_path => 'idComunicacion');
    Lv_Usuario := APEX_JSON.get_varchar2(p_path => 'usuario');
    Lv_Ip := APEX_JSON.get_varchar2(p_path => 'ip');

    IF Lv_TipoAsignado = 'EMPLEADO' THEN

      DB_COMERCIAL.CMKG_INFO_PER_EMPRESA_ROL_C.P_GET_INFO_PERSONA_EMPRESA_ROL(Pn_IdPersonaEmpresaRol   => Ln_IdAsignado,
                                                                              Pv_Estado                => 'Activo',
                                                                              Pr_InfoPersonaEmpresaRol => Lr_InfoPersonaEmpresaRol,
                                                                              Pv_Status                => Lv_Status,
                                                                              Pv_Mensaje               => Lv_Mensaje);

      IF Lv_Status != 'OK' THEN
        Pv_Mensaje := 'Error al consultar persona empresa rol: '|| Lv_Mensaje;
        RAISE Le_Error;
      END IF;

      --Json para consultar el departamento
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('idDepartamento', Lr_InfoPersonaEmpresaRol.Departamento_Id);
      APEX_JSON.WRITE('estado', 'Activo');
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_GENERAL.GNKG_EMPRESA_CONSULTA.P_DEPARTAMENTO_POR(Pcl_Request  => Lcl_Request,
                                                          Pv_Status    => Lv_Status,
                                                          Pv_Mensaje   => Lv_Mensaje,
                                                          Pcl_Response => Lrf_Departamento);

      IF Lrf_Departamento%NOTFOUND THEN
        Pv_Mensaje := 'El departamento no existe';
        RAISE Le_Error;
      END IF;

      LOOP
        FETCH Lrf_Departamento BULK COLLECT INTO Lr_Departamento LIMIT 10;
      EXIT WHEN Lrf_Departamento%NOTFOUND;
      END LOOP;

      DB_COMERCIAL.CMKG_INFO_EMPRESA_ROL_C.P_GET_INFO_OFICINA_GRUPO (Pn_IdOficina         => Lr_InfoPersonaEmpresaRol.Oficina_Id,
                                                                     Pv_Estado            => 'Activo',
                                                                     Pr_InfoOficinaGrupo  => Lr_InfoOficinaGrupo,
                                                                     Pv_Status            => Lv_Status,
                                                                     Pv_Mensaje           => Lv_Mensaje);

      IF Lv_Status != 'OK' THEN
        Pv_Mensaje := 'Error al consultar oficina: '|| Lv_Mensaje;
        RAISE Le_Error;
      END IF;

      --Json para consultar la persona
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('empresaId', To_Number(Lv_CodEmpresa,99));
      APEX_JSON.WRITE('idPersona', Lr_InfoPersonaEmpresaRol.Persona_Id);
      APEX_JSON.WRITE('estado', 'Activo');
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_COMERCIAL.CMKG_PERSONA_CONSULTA.P_PERSONA_POR_EMPRESA(Pcl_Request  => Lcl_Request,
                                                               Pv_Status    => Lv_Status,
                                                               Pv_Mensaje   => Lv_Mensaje,
                                                               Pcl_Response => Lrf_Persona);

      IF Lrf_Persona%NOTFOUND THEN
        Pv_Mensaje := 'La persona no existe';
        RAISE Le_Error;
      END IF;

      LOOP
        FETCH Lrf_Persona BULK COLLECT INTO Lr_InfoPersona LIMIT 10;
      EXIT WHEN Lrf_Persona%NOTFOUND;
      END LOOP;

      Lr_InfoDetalleAsignacion.Detalle_Id := Ln_IdDetalle;
      Lr_InfoDetalleAsignacion.Asignado_Id := Lr_Departamento(1).Id_Departamento;
      Lr_InfoDetalleAsignacion.Asignado_Nombre := Lr_Departamento(1).Nombre_Departamento;
      Lr_InfoDetalleAsignacion.Ref_Asignado_Id := Lr_InfoPersona(1).Id_Persona;
      Lr_InfoDetalleAsignacion.Ref_Asignado_Nombre := Lr_InfoPersona(1).Nombres||' '||Lr_InfoPersona(1).Apellidos;
      Lr_InfoDetalleAsignacion.Motivo := Lcl_MotivoTarea;
      Lr_InfoDetalleAsignacion.Persona_Empresa_Rol_Id := Ln_IdAsignado;
      Lr_InfoDetalleAsignacion.Tipo_Asignado := Lv_TipoAsignado;
      Lr_InfoDetalleAsignacion.Departamento_Id := Lr_Departamento(1).Id_Departamento;
      Lr_InfoDetalleAsignacion.Canton_Id := Lr_InfoOficinaGrupo.Canton_Id;
      Lv_Observacion := 'Tarea fue Asignada a '||Lr_InfoDetalleAsignacion.Ref_Asignado_Nombre;
    END IF;

    --Json para consultar la clase documento
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('nombreClaseDocumento', 'Notificacion');
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMUNICACION.CUKG_COMUNICACIONES_CONSULTA.P_GET_CLASE_DOCUMENTO(Pcl_Request  => Lcl_Request,
                                                                       Pv_Status    => Lv_Status,
                                                                       Pv_Mensaje   => Lv_Mensaje,
                                                                       Prf_Response => Lrf_ClasesDocumento);

    IF Lrf_ClasesDocumento%NOTFOUND THEN
      Pv_Mensaje := 'La clase de documento no existe';
      RAISE Le_Error;
    END IF;

    LOOP
      FETCH Lrf_ClasesDocumento BULK COLLECT INTO Lr_ClaseDocumento LIMIT 10;
    EXIT WHEN Lrf_ClasesDocumento%NOTFOUND;
    END LOOP;

    --Json para crear el documento
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idClaseDocumento', Lr_ClaseDocumento(1).Id_Clase_Documento);
    APEX_JSON.WRITE('nombreDocumento','Asignacion de Tarea | PROCESO: '||Lv_NombreProceso); 
    APEX_JSON.WRITE('mensaje', 'Asignacion de Tarea a '||Lr_InfoDetalleAsignacion.Ref_Asignado_Nombre);
    APEX_JSON.WRITE('estado', 'Activo');
    APEX_JSON.WRITE('codEmpresa', Lv_CodEmpresa);
    APEX_JSON.WRITE('fechaCreacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', Lv_Usuario);
    APEX_JSON.WRITE('ip' , Lv_IP);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC.P_INSERT_DOCUMENTO(Pcl_Request    => Lcl_Request,
                                                                   Pn_IdDocumento => Ln_IdDocumento,
                                                                   Pv_Status      => Lv_Status,
                                                                   Pv_Mensaje     => Lv_Mensaje);

    IF Lv_Status != 'OK' THEN
      Pv_Mensaje := 'No es posible crear el documento: '|| Lv_Mensaje;
      RAISE Le_Error;
    END IF;


    --Json para crear la relacion del documento y la comunicacion
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idDocumento', Ln_IdDocumento);
    APEX_JSON.WRITE('idComunicacion',Ln_IdComunicacion);
    APEX_JSON.WRITE('estado', 'Activo');
    APEX_JSON.WRITE('fechaCreacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', Lv_Usuario);
    APEX_JSON.WRITE('ip' , Lv_IP);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC.P_INSERT_DOC_COMUNICACION(Pcl_Request           => Lcl_Request,
                                                                          Pn_IdDocComunicacion  => Ln_IdDocComunicacion,
                                                                          Pv_Status             => Lv_Status,
                                                                          Pv_Mensaje            => Lv_Mensaje);

    IF Lv_Status != 'OK' THEN
      Pv_Mensaje := 'No es posible relacionar el documento con la comunicacion: '|| Lv_Mensaje;
      RAISE Le_Error;
    END IF;

    --Json para crear el detalle de asignacion
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
    APEX_JSON.WRITE('idAsignado', Lr_InfoDetalleAsignacion.Asignado_Id );
    APEX_JSON.WRITE('nombreAsignado', Lr_InfoDetalleAsignacion.Asignado_Nombre);
    APEX_JSON.WRITE('refIdAsignado', Lr_InfoDetalleAsignacion.Ref_Asignado_Id);
    APEX_JSON.WRITE('refNombreAsignado', Lr_InfoDetalleAsignacion.Ref_Asignado_Nombre);
    APEX_JSON.WRITE('motivo', Lr_InfoDetalleAsignacion.Motivo);
    APEX_JSON.WRITE('idPersonaEmpresaRol', Lr_InfoDetalleAsignacion.Persona_Empresa_Rol_Id);
    APEX_JSON.WRITE('tipoAsignado', Lr_InfoDetalleAsignacion.Tipo_Asignado);
    APEX_JSON.WRITE('idDepartamento', Lr_InfoDetalleAsignacion.Departamento_Id);
    APEX_JSON.WRITE('idCanton', Lr_InfoDetalleAsignacion.Canton_Id);
    APEX_JSON.WRITE('fechaAsignacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', Lv_Usuario);
    APEX_JSON.WRITE('ip' , Lv_IP);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    SPKG_DETALLES_TRANSACCION.P_INSERT_DETALLE_ASIGNACION(Pcl_Request            => Lcl_Request,
                                                          Pn_IdDetalleAsignacion => Ln_IdDetalleAsignacion,
                                                          Pv_Status              => Lv_Status,
                                                          Pv_Mensaje             => Lv_Mensaje);

    IF Lv_Status != 'OK' THEN
      Pv_Mensaje := 'No es posible crear el detalle de asignacion: '|| Lv_Mensaje;
      RAISE Le_Error;
    END IF;

    --Json para crear el detalle historial
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
    APEX_JSON.WRITE('observacion', 'Tarea Asignada' );
    APEX_JSON.WRITE('estado', 'Asignada');
    APEX_JSON.WRITE('idAsignado', Lr_InfoDetalleAsignacion.Asignado_Id);
    APEX_JSON.WRITE('idPersonaEmpresaRol', Lr_InfoDetalleAsignacion.Persona_Empresa_Rol_Id);
    APEX_JSON.WRITE('idDepartamentoOrigen', NVL(Ln_IdDeptoOrigen, Lr_InfoDetalleAsignacion.Departamento_Id));
    APEX_JSON.WRITE('idDepartamentoDestino', Lr_InfoDetalleAsignacion.Departamento_Id);
    APEX_JSON.WRITE('accion', 'Asignada');
    APEX_JSON.WRITE('fechaHistorial', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', substr(Lv_Usuario,1,16));
    APEX_JSON.WRITE('ip' , Lv_Ip);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    SPKG_DETALLES_TRANSACCION.P_INSERT_DETALLE_HISTORIAL(Pcl_Request            => Lcl_Request,
                                                         Pn_IdDetalleHistorial  => Ln_IdDetalleHistorial,
                                                         Pv_Status              => Lv_Status,
                                                         Pv_Mensaje             => Lv_Mensaje);

    IF Lv_Status != 'OK' THEN
      Pv_Mensaje := 'No es posible crear el detalle de historial: '|| Lv_Mensaje;
      RAISE Le_Error;
    END IF;

    --Json para crear la tarea seguimiento
    APEX_JSON.INITIALIZE_CLOB_OUTPUT;
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
    APEX_JSON.WRITE('observacion', Lv_Observacion );
    APEX_JSON.WRITE('codEmpresa', Lv_CodEmpresa);
    APEX_JSON.WRITE('estadoTarea', 'Asignada');
    APEX_JSON.WRITE('interno', 'N');
    APEX_JSON.WRITE('idDepartamento', Lr_InfoDetalleAsignacion.Departamento_Id);
    APEX_JSON.WRITE('idPersonaEmpresaRol', Lr_InfoDetalleAsignacion.Persona_Empresa_Rol_Id);
    APEX_JSON.WRITE('fechaSeguimiento', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
    APEX_JSON.WRITE('usuario', Lv_Usuario);
    APEX_JSON.CLOSE_OBJECT;
    Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
    APEX_JSON.FREE_OUTPUT;

    P_INSERT_TAREA_SEGUIMIENTO(Pcl_Request      => Lcl_Request,
                               Pn_IdSeguimiento => Ln_IdSeguimiento,
                               Pv_Status        => Lv_Status,
                               Pv_Mensaje       => Lv_Mensaje);

    IF Lv_Status != 'OK' THEN
      Pv_Mensaje := 'No es posible crear la tarea de seguimiento: '|| Lv_Mensaje;
      RAISE Le_Error;
    END IF;

    Pv_Status := 'OK';
    Pv_Mensaje := 'Asignacion de Tarea es exitosa';

  EXCEPTION 
  WHEN Le_Error THEN
      Pv_Status := 'ERROR';
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;    
  END;

  PROCEDURE P_INSERT_TAREA_SEGUIMIENTO(Pcl_Request      IN CLOB,
                                       Pn_IdSeguimiento OUT INFO_TAREA_SEGUIMIENTO.ID_SEGUIMIENTO%TYPE,
                                       Pv_Status        OUT VARCHAR2,
                                       Pv_Mensaje       OUT VARCHAR2) AS
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdSeguimiento := SEQ_INFO_TAREA_SEGUIMIENTO.NEXTVAL;

    INSERT INTO DB_SOPORTE.INFO_TAREA_SEGUIMIENTO 
      (ID_SEGUIMIENTO,DETALLE_ID,OBSERVACION,EMPRESA_COD,ESTADO_TAREA,INTERNO,DEPARTAMENTO_ID,PERSONA_EMPRESA_ROL_ID,FE_CREACION,USR_CREACION) 
    VALUES
      (Pn_IdSeguimiento,APEX_JSON.get_number('idDetalle'),APEX_JSON.get_clob('observacion'),APEX_JSON.get_varchar2('codEmpresa'),
      APEX_JSON.get_varchar2('estadoTarea'),APEX_JSON.get_varchar2('interno'),APEX_JSON.get_number('idDepartamento'),APEX_JSON.get_number('idPersonaEmpresaRol'), 
      To_date(APEX_JSON.get_varchar2('fechaSeguimiento'),'rrrr-mm-dd hh24:mi:ss'),APEX_JSON.get_varchar2('usuario'));

    Pv_Status := 'OK';
    Pv_Mensaje := 'Info Tarea Seguimiento creado correctamente';
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_TAREA_SEGUIMIENTO;

  PROCEDURE P_ADJUNTAR_DOCUMENTOS_TAREA(Pcl_Request  IN CLOB,
                                        Pv_Status    OUT VARCHAR2,
                                        Pv_Mensaje   OUT VARCHAR2,
                                        Prf_Response OUT SYS_REFCURSOR) AS

    Ln_CantDocumentos NUMBER;
    Lcl_Request       CLOB;
    Lv_Status         VARCHAR2(25);
    Lv_Mensaje        VARCHAR2(3000);
    Le_Error          EXCEPTION;
    Lv_CodEmpresa     DB_COMERCIAL.INFO_EMPRESA_GRUPO.COD_EMPRESA%TYPE;
    Lv_Usuario        INFO_DETALLE.USR_CREACION%TYPE;
    Lv_Ip             INFO_DETALLE.IP_CREACION%TYPE;
    Ln_IdDetalle      INFO_DETALLE.ID_DETALLE%TYPE;
    Ln_IdDocumento    DB_COMUNICACION.INFO_DOCUMENTO.ID_DOCUMENTO%TYPE;
    Ln_IdDocRelacion  DB_COMUNICACION.INFO_DOCUMENTO_RELACION.ID_DOCUMENTO_RELACION%TYPE;
  BEGIN

    APEX_JSON.PARSE(Pcl_Request);
    Lv_CodEmpresa := APEX_JSON.get_varchar2('codEmpresa');
    Ln_IdDetalle := APEX_JSON.get_number('idDetalle');
    Ln_CantDocumentos := APEX_JSON.get_count('documentos');
    Lv_Usuario := APEX_JSON.get_varchar2('usuario');
    Lv_Ip := APEX_JSON.get_varchar2('ip');

    FOR i IN 1..Ln_CantDocumentos LOOP
      --Json para crear el documento
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('nombreDocumento','Adjunto Tarea'); 
      APEX_JSON.WRITE('mensaje', 'Documento que se adjunta a una tarea');
      APEX_JSON.WRITE('estado', 'Activo');
      APEX_JSON.WRITE('ubicacionLogicaDocumento', APEX_JSON.get_varchar2('documentos[%d].nombreDocumento',i));
      APEX_JSON.WRITE('ubicacionFisicaDocumento', APEX_JSON.get_varchar2('documentos[%d].rutaDocumento',i));
      APEX_JSON.WRITE('codEmpresa', Lv_CodEmpresa);
      APEX_JSON.WRITE('fechaDocumento', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
      APEX_JSON.WRITE('fechaCreacion', TO_CHAR(SYSDATE,'rrrr-mm-dd hh24:mi:ss'));
      APEX_JSON.WRITE('usuario', Lv_Usuario);
      APEX_JSON.WRITE('ip' , Lv_Ip);
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC.P_INSERT_DOCUMENTO(Pcl_Request    => Lcl_Request,
                                                                     Pn_IdDocumento => Ln_IdDocumento,
                                                                     Pv_Status      => Lv_Status,
                                                                     Pv_Mensaje     => Lv_Mensaje);

      IF Lv_Status != 'OK' THEN
        Pv_Mensaje := 'No es posible crear el documento: '|| Lv_Mensaje;
        RAISE Le_Error;
      END IF;    

       --Json para crear el documento y la relación con el caso
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('modulo','SOPORTE'); 
      APEX_JSON.WRITE('estado', 'Activo');
      APEX_JSON.WRITE('idDetalle', Ln_IdDetalle);
      APEX_JSON.WRITE('idDocumento', Ln_IdDocumento);
      APEX_JSON.WRITE('usuario', SUBSTR(Lv_Usuario,1,20));
      APEX_JSON.CLOSE_OBJECT;
      Lcl_Request := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;

      DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC.P_INSERT_DOCUMENTO_RELACION(Pcl_Request       => Lcl_Request,
                                                                              Pn_IdDocRelacion  => Ln_IdDocRelacion,
                                                                              Pv_Status         => Lv_Status,
                                                                              Pv_Mensaje        => Lv_Mensaje);

      IF Lv_Status != 'OK' THEN
        Pv_Mensaje := 'No es posible relacionar el documento con la tarea: '|| Lv_Mensaje;
        RAISE Le_Error;
      END IF;      
      APEX_JSON.PARSE(Pcl_Request);
    END LOOP;

    COMMIT;

    OPEN Prf_Response FOR
      SELECT Ido.Id_Documento AS idDocumento, 
        Ido.Ubicacion_Logica_Documento AS nombreDocumento,
        Ido.Ubicacion_Fisica_Documento AS rutaDocumento
      FROM DB_COMUNICACION.INFO_DOCUMENTO_RELACION Idr
        INNER JOIN DB_COMUNICACION.INFO_DOCUMENTO Ido ON Idr.Documento_Id = Ido.Id_Documento
      WHERE Idr.estado = 'Activo'
        AND Idr.Detalle_Id = Ln_IdDetalle
        AND Ido.estado = 'Activo'
      ORDER BY Ido.fe_creacion DESC;

    Pv_Status := 'OK';
    Pv_Mensaje := 'Documento(s) adjunto(s) correctamente';
  EXCEPTION
    WHEN Le_Error THEN
      Pv_Status := 'ERROR';
      ROLLBACK;
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
      ROLLBACK;
  END P_ADJUNTAR_DOCUMENTOS_TAREA;

  PROCEDURE P_INSERT_TAREA_CARACTERISTICA(Pcl_Request               IN CLOB,
                                          Pn_IdTareaCaracteristica  OUT INFO_TAREA_CARACTERISTICA.ID_TAREA_CARACTERISTICA%TYPE,
                                          Pv_Status                 OUT VARCHAR2,
                                          Pv_Mensaje                OUT VARCHAR2) AS

  CURSOR C_GetAdmiCaracteristica(Cv_Caracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.DESCRIPCION_CARACTERISTICA%TYPE) IS 
    SELECT ID_CARACTERISTICA
      FROM DB_COMERCIAL.ADMI_CARACTERISTICA 
      WHERE 
      DESCRIPCION_CARACTERISTICA = Cv_Caracteristica
      AND TIPO = 'SOPORTE'
      AND ESTADO                 = 'Activo';

    Ln_IdCaracteristica DB_COMERCIAL.ADMI_CARACTERISTICA.ID_CARACTERISTICA%TYPE; 
    Le_Error            EXCEPTION;
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);

    OPEN C_GetAdmiCaracteristica(APEX_JSON.get_varchar2('caracteristica'));
    FETCH C_GetAdmiCaracteristica INTO Ln_IdCaracteristica;
    ClOSE C_GetAdmiCaracteristica;

    IF Ln_IdCaracteristica IS NULL THEN
      Pv_Mensaje := 'Caracteristica no encontrada';
      RAISE Le_Error;
    END IF;

    Pn_IdTareaCaracteristica := SEQ_INFO_TAREA_CARACTERISTICA.NEXTVAL;

    INSERT INTO DB_SOPORTE.INFO_TAREA_CARACTERISTICA 
      (ID_TAREA_CARACTERISTICA,TAREA_ID,DETALLE_ID,CARACTERISTICA_ID,VALOR,ESTADO,FE_CREACION,USR_CREACION,IP_CREACION) 
    VALUES
      (Pn_IdTareaCaracteristica,APEX_JSON.get_number('idTarea'),APEX_JSON.get_number('idDetalle'),Ln_IdCaracteristica,
      APEX_JSON.get_varchar2('valor'),APEX_JSON.get_varchar2('estado'),SYSDATE,substr(APEX_JSON.get_varchar2('usuario'),1,20),
      APEX_JSON.get_varchar2('ip'));

    Pv_Status := 'OK';
    Pv_Mensaje := 'Info Tarea Caracteristica creada correctamente';
  EXCEPTION
    WHEN Le_Error THEN
      Pv_Status := 'ERROR';
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_TAREA_CARACTERISTICA;

END SPKG_TAREAS_TRANSACCION;
/