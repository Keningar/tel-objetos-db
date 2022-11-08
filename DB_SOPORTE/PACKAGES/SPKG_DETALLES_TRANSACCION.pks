CREATE OR REPLACE PACKAGE DB_SOPORTE.SPKG_DETALLES_TRANSACCION AS 

  /**
   * Documentación para proceso 'P_INSERT_DETALLE'
   *
   * Procedimiento encargado de generar un detalle
   *
   * @param Pcl_Request   IN  CLOB Recibe json request
   * [
   *  idTarea               Id de la tarea,
   *  tipoZona              Tipo de Zona,
   *  longitud              Longitud,
   *  latitud               Latitud,
   *  pesoPresupuestado     Peso presupuestado
   *  pesoReal              Peso real
   *  valorPresupuestado    Valor presupuestado,
   *  valorFacturado        Valor facturado,
   *  valorNoFacturado      Valor no facturado,
   *  fechaHoraSolicitada   Fecha y Hora en que se genera el detalle,
   *  observacion           Observacion para generar el detalle,
   *  esSolucion            Indica si es solución,
   *  idDetalleSolicitud    Id del detalle de solicitud,
   *  idDetalleHipotesis    Id del detalle de hipotesis,
   *  idDetalleRelacionado  Id del detalle relacionado,
   *  idProgresoTarea       Id del progreso de la tarea,
   *  usuario               Usuario quien general el detalle,
   *  ip                    Ip desde donde se genera el detalle
   * ]
   * @param Pn_IdDetalle  OUT INFO_DETALLE.ID_DETALLE%TYPE Retorna id del detalle
   * @param Pv_Status     OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje    OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    06-10-2021
   */                                      
  PROCEDURE P_INSERT_DETALLE(Pcl_Request  IN  CLOB,
                             Pn_IdDetalle OUT INFO_DETALLE.ID_DETALLE%TYPE,
                             Pv_Status    OUT VARCHAR2,
                             Pv_Mensaje   OUT VARCHAR2);

  /**
   * Documentación para proceso 'P_INSERT_CRITERIO_AFECTADO'
   *
   * Procedimiento encargado de generar un criterio afectado
   *
   * @param Pcl_Request     IN  CLOB Recibe json request
   * [
   *  idDetalle  Id del detalle,
   *  criterio   Describe el tipo de afectado,
   *  opcion     Describe la opcion del afectado,
   *  usuario    Usuario quien general el criterio del afectado,
   *  ip         Ip desde donde se genera el criterio del afectado
   * ]
   * Pn_IdCriterioAfectado  OUT INFO_CRITERIO_AFECTADO.ID_CRITERIO_AFECTADO%TYPE Retorna id del criterio afectado
   * @param Pv_Status       OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje      OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    06-10-2021
   */                            
  PROCEDURE P_INSERT_CRITERIO_AFECTADO(Pcl_Request           IN  CLOB,
                                       Pn_IdCriterioAfectado IN OUT INFO_CRITERIO_AFECTADO.ID_CRITERIO_AFECTADO%TYPE,
                                       Pv_Status             OUT VARCHAR2,
                                       Pv_Mensaje            OUT VARCHAR2);

  /**
   * Documentación para proceso 'P_INSERT_PARTE_AFECTADA'
   *
   * Procedimiento encargado de generar una parte afectada
   *
   * @param Pcl_Request IN  CLOB Recibe json request
   * [
   *  idCriterioAfectado    Id del criterio afectado
   *  idDetalle             Id del detalle,
   *  idAfectado            Id del afectado,
   *  tipoAfectado          Tipo de afectado,
   *  nombreAfectado        Nombre de afectado,
   *  descripcionAfectado   Descripción de afectado,
   *  fechaInicioIncidencia Fecha y hora del inicio de la incidencia,
   *  usuario               Usuario quien general la parte afectada,
   *  ip                    Ip desde donde se genera la parte afectada
   * ]
   * Pn_IdParteAfectada OUT INFO_PARTE_AFECTADA.ID_PARTE_AFECTADA%TYPE Retorna id de la parte afectada
   * @param Pv_Status   OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje  OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    06-10-2021
   */  
  PROCEDURE P_INSERT_PARTE_AFECTADA(Pcl_Request        IN  CLOB,
                                    Pn_IdParteAfectada OUT INFO_PARTE_AFECTADA.ID_PARTE_AFECTADA%TYPE,
                                    Pv_Status          OUT VARCHAR2,
                                    Pv_Mensaje         OUT VARCHAR2);

  /**
   * Documentación para proceso 'P_INSERT_DETALLE_ASIGNACION'
   *
   * Procedimiento encargado de generar un detalle de asignacion
   *
   * @param Pcl_Request       IN  CLOB Recibe json request
   * [
   *  idDetalle             Id del detalle,
   *  idAsignado            Id del asignado,
   *  nombreAsignado        Nombre del asignado,
   *  refIdAsignado         Referencia del id del asignado,
   *  refNombreAsignado     Referencia del nombre del asignado
   *  motivo                Motivo por el cual se genera el detalle de asignación,
   *  idPersonaEmpresaRol   Id persona empresa rol del asignado,
   *  tipoAsignado          Tipo del asignado,
   *  idDepartamento        Id del departamento al que pertenece el asignado,
   *  idCanton              Id del cantón al que pertenece el asignado,
   *  fechaAsignacion       Fecha y hora de la asignación,
   *  usuario               Usuario quien general la asignación
   *  ip                    Ip desde donde se genera la asignación
   * ]
   * Pn_IdDetalleAsignacion   OUT INFO_DETALLE_ASIGNACION.ID_DETALLE_ASIGNACION%TYPE Retorna id del detalle asignacion
   * @param Pv_Status         OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje        OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    25-10-2021
   */                                    
  PROCEDURE P_INSERT_DETALLE_ASIGNACION(Pcl_Request             IN  CLOB,
                                        Pn_IdDetalleAsignacion  OUT INFO_DETALLE_ASIGNACION.ID_DETALLE_ASIGNACION%TYPE,
                                        Pv_Status               OUT VARCHAR2,
                                        Pv_Mensaje              OUT VARCHAR2);

  /**
   * Documentación para proceso 'P_INSERT_DETALLE_HISTORIAL'
   *
   * Procedimiento encargado de generar un historial del detalle
   *
   * @param Pcl_Request     IN  CLOB Recibe json request
   * [
   *  idDetalle             Id del detalle,
   *  observacion           Observacion para generar el historial de detalle,
   *  estado                Estado para generar el historial de detalle,
   *  motivo                Motivo por el cual se generará el historial de detalle,
   *  idAsignado            Id del asignado
   *  idPersonaEmpresaRol   Id persona empresa rol del asignado,
   *  idDepartamentoOrigen  Id del departamento origien del asignado,
   *  idDepartamentoDestino Id del departamento destino del asignado,
   *  accion                Acción con el que se genará el historial de detalle,
   *  idTarea               Id de la tarea,
   *  esSolucion            Indica si es solución,
   *  idMotivo              Id del motivo,
   *  motivoFinTarea        Motivo del fin de la tarea
   *  fechaHistorial        Fecha y hora de la generación del historial de detalle,
   *  usuario               Usuario quien general el historial del detalle
   *  ip                    Ip desde donde se genera el historial del detalle
   * ]
   * Pn_IdDetalleHistorial  OUT INFO_DETALLE_HISTORIAL.ID_DETALLE_HISTORIAL%TYPE Retorna id del detalle historial
   * @param Pv_Status       OUT VARCHAR2 Retorna estatus de la transacción
   * @param Pv_Mensaje      OUT VARCHAR2 Retorna mensaje de la transacción
   *
   * @author   David De La Cruz <ddelacruz@telconet.ec>
   * @version  1.0
   * @since    25-10-2021
   */                                       
  PROCEDURE P_INSERT_DETALLE_HISTORIAL(Pcl_Request            IN  CLOB,
                                       Pn_IdDetalleHistorial  OUT INFO_DETALLE_HISTORIAL.ID_DETALLE_HISTORIAL%TYPE,
                                       Pv_Status              OUT VARCHAR2,
                                       Pv_Mensaje             OUT VARCHAR2);                                         

END SPKG_DETALLES_TRANSACCION;
/


CREATE OR REPLACE PACKAGE BODY DB_SOPORTE.SPKG_DETALLES_TRANSACCION AS

  PROCEDURE P_INSERT_DETALLE(Pcl_Request  IN  CLOB,
                             Pn_IdDetalle OUT INFO_DETALLE.ID_DETALLE%TYPE,
                             Pv_Status    OUT VARCHAR2,
                             Pv_Mensaje   OUT VARCHAR2) AS
  
  BEGIN 
  
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdDetalle := SEQ_INFO_DETALLE.NEXTVAL;
    
    INSERT INTO DB_SOPORTE.INFO_DETALLE
      (ID_DETALLE,
      TAREA_ID,
      TIPO_ZONA,
      LONGITUD,
      LATITUD,      
      PESO_PRESUPUESTADO,
      PESO_REAL,
      VALOR_PRESUPUESTADO,
      VALOR_FACTURADO,
      VALOR_NO_FACTURADO,
      FE_SOLICITADA,
      OBSERVACION,
      ES_SOLUCION,
      DETALLE_SOLICITUD_ID,
      DETALLE_HIPOTESIS_ID,
      DETALLE_ID_RELACIONADO,
      PROGRESO_TAREA_ID,
      FE_CREACION,
      USR_CREACION,
      IP_CREACION) 
    VALUES
      (Pn_IdDetalle,
      APEX_JSON.get_number('idTarea'),
      APEX_JSON.get_varchar2('tipoZona'),
      APEX_JSON.get_number('longitud'),
      APEX_JSON.get_number('latitud'),
      APEX_JSON.get_number('pesoPresupuestado'),
      APEX_JSON.get_number('pesoReal'),
      APEX_JSON.get_number('valorPresupuestado'),
      APEX_JSON.get_number('valorFacturado'),
      APEX_JSON.get_number('valorNoFacturado'),
      to_date(APEX_JSON.get_varchar2('fechaHoraSolicitada'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_clob('observacion'),
      APEX_JSON.get_varchar2('esSolucion'),
      APEX_JSON.get_number('idDetalleSolicitud'),
      APEX_JSON.get_number('idDetalleHipotesis'),
      APEX_JSON.get_number('idDetalleRelacionado'),
      APEX_JSON.get_number('idProgresoTarea'),
      SYSDATE,
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Detalle creado correctamente';
    
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_DETALLE;
  
  PROCEDURE P_INSERT_CRITERIO_AFECTADO(Pcl_Request           IN  CLOB,
                                       Pn_IdCriterioAfectado IN OUT INFO_CRITERIO_AFECTADO.ID_CRITERIO_AFECTADO%TYPE,
                                       Pv_Status             OUT VARCHAR2,
                                       Pv_Mensaje            OUT VARCHAR2) AS
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    If Pn_IdCriterioAfectado IS NULL THEN
      Pn_IdCriterioAfectado := SEQ_INFO_CRITERIO_AFECTADO.NEXTVAL;
    END IF;
    
    INSERT INTO DB_SOPORTE.INFO_CRITERIO_AFECTADO
      (ID_CRITERIO_AFECTADO,
      DETALLE_ID,
      CRITERIO,
      OPCION,
      USR_CREACION,
      IP_CREACION) 
    VALUES
      (Pn_IdCriterioAfectado,
      APEX_JSON.get_number('idDetalle'),
      APEX_JSON.get_varchar2('criterio'),
      APEX_JSON.get_varchar2('opcion'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Criterio del afectado creado correctamente';
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_CRITERIO_AFECTADO;
  
  PROCEDURE P_INSERT_PARTE_AFECTADA(Pcl_Request        IN  CLOB,
                                    Pn_IdParteAfectada OUT INFO_PARTE_AFECTADA.ID_PARTE_AFECTADA%TYPE,
                                    Pv_Status          OUT VARCHAR2,
                                    Pv_Mensaje         OUT VARCHAR2) AS
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdParteAfectada := SEQ_INFO_PARTE_AFECTADA.NEXTVAL;
    
    INSERT INTO DB_SOPORTE.INFO_PARTE_AFECTADA
      (ID_PARTE_AFECTADA,
      CRITERIO_AFECTADO_ID,
      DETALLE_ID,
      AFECTADO_ID,
      TIPO_AFECTADO,
      AFECTADO_NOMBRE,
      AFECTADO_DESCRIPCION,
      FE_INI_INCIDENCIA,
      USR_CREACION,
      IP_CREACION) 
    VALUES
      (Pn_IdParteAfectada,
      APEX_JSON.get_number('idCriterioAfectado'),
      APEX_JSON.get_number('idDetalle'),
      APEX_JSON.get_number('idAfectado'),
      APEX_JSON.get_varchar2('tipoAfectado'),
      APEX_JSON.get_varchar2('nombreAfectado'),
      APEX_JSON.get_varchar2('descripcionAfectado'),
      To_date(APEX_JSON.get_varchar2('fechaInicioIncidencia'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Parte afectada creada correctamente';
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_PARTE_AFECTADA;
  
  PROCEDURE P_INSERT_DETALLE_ASIGNACION(Pcl_Request             IN  CLOB,
                                        Pn_IdDetalleAsignacion  OUT INFO_DETALLE_ASIGNACION.ID_DETALLE_ASIGNACION%TYPE,
                                        Pv_Status               OUT VARCHAR2,
                                        Pv_Mensaje              OUT VARCHAR2) AS
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdDetalleAsignacion := SEQ_INFO_DETALLE_ASIGNACION.NEXTVAL;
    
    INSERT INTO DB_SOPORTE.INFO_DETALLE_ASIGNACION
      (ID_DETALLE_ASIGNACION,
      DETALLE_ID,
      ASIGNADO_ID,
      ASIGNADO_NOMBRE,
      REF_ASIGNADO_ID,
      REF_ASIGNADO_NOMBRE,
      MOTIVO,
      PERSONA_EMPRESA_ROL_ID,
      TIPO_ASIGNADO,
      DEPARTAMENTO_ID,
      CANTON_ID,
      FE_CREACION,
      USR_CREACION,
      IP_CREACION) 
    VALUES
      (Pn_IdDetalleAsignacion,
      APEX_JSON.get_number('idDetalle'),
      APEX_JSON.get_number('idAsignado'),
      APEX_JSON.get_varchar2('nombreAsignado'),
      APEX_JSON.get_number('refIdAsignado'),
      APEX_JSON.get_varchar2('refNombreAsignado'),
      APEX_JSON.get_clob('motivo'),
      APEX_JSON.get_number('idPersonaEmpresaRol'),
      APEX_JSON.get_varchar2('tipoAsignado'),
      APEX_JSON.get_number('idDepartamento'),
      APEX_JSON.get_number('idCanton'),
      To_date(APEX_JSON.get_varchar2('fechaAsignacion'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Detalle asignacion creado correctamente';
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_DETALLE_ASIGNACION;
  
  PROCEDURE P_INSERT_DETALLE_HISTORIAL(Pcl_Request            IN  CLOB,
                                       Pn_IdDetalleHistorial  OUT INFO_DETALLE_HISTORIAL.ID_DETALLE_HISTORIAL%TYPE,
                                       Pv_Status              OUT VARCHAR2,
                                       Pv_Mensaje             OUT VARCHAR2) AS
  BEGIN    
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdDetalleHistorial := SEQ_INFO_DETALLE_HISTORIAL.NEXTVAL;
    
    INSERT INTO DB_SOPORTE.INFO_DETALLE_HISTORIAL
      (ID_DETALLE_HISTORIAL,
      DETALLE_ID,
      OBSERVACION,
      ESTADO,
      MOTIVO,
      ASIGNADO_ID,
      PERSONA_EMPRESA_ROL_ID,
      DEPARTAMENTO_ORIGEN_ID,
      DEPARTAMENTO_DESTINO_ID,
      ACCION,
      TAREA_ID,
      ES_SOLUCION,
      MOTIVO_ID,
      MOTIVO_FIN_TAREA,
      FE_CREACION,
      USR_CREACION,
      IP_CREACION) 
    VALUES
      (Pn_IdDetalleHistorial,
      APEX_JSON.get_number('idDetalle'),
      APEX_JSON.get_clob('observacion'),
      APEX_JSON.get_varchar2('estado'),
      APEX_JSON.get_varchar2('motivo'),
      APEX_JSON.get_number('idAsignado'),
      APEX_JSON.get_number('idPersonaEmpresaRol'),
      APEX_JSON.get_number('idDepartamentoOrigen'),
      APEX_JSON.get_number('idDepartamentoDestino'),
      APEX_JSON.get_varchar2('accion'),
      APEX_JSON.get_number('idTarea'),
      APEX_JSON.get_varchar2('esSolucion'),
      APEX_JSON.get_number('idMotivo'),
      APEX_JSON.get_clob('motivoFinTarea'),
      To_date(APEX_JSON.get_varchar2('fechaHistorial'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Detalle historial creado correctamente';
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_DETALLE_HISTORIAL;

END SPKG_DETALLES_TRANSACCION;
/
