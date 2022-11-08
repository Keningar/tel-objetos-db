CREATE OR REPLACE PACKAGE DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC AS 

  /**
   * Documentación para el proceso 'P_INSERT_COMUNICACION'
   *
   * Metodo encargado de generar una comunicación
   *
   * @param Pcl_Request       IN   CLOB Recibe json request con informacion de la comunicacion
   * [
   *  idFormaContacto         Id de la forma contacto,
   *  idTramite               Id de tramite,
   *  idCaso                  Id del caso,           
   *  idDetalle               Id del detalle,
   *  idRemitente             Id del remitente,
   *  nombreRemitente         Nombre del remitente,
   *  claseComunicacion       Clase de comunicación,
   *  fechaComunicacion       Fecha de la comunicación,
   *  descripcionComunicacion Descripción de la comunicación,
   *  estado                  Estado de la comunicación,
   *  idPunto                 Id del punto,
   *  codEmpresa              Código de empresa,
   *  fechaCreacion           Fecha de creación de la comunicación,
   *  usuario                 Usuario quien genera la comunicación,
   *  ip                      Ip de donde se origina la comunicación
   * ]
   * @param Pn_IdComunicacion OUT  INFO_COMUNICACION.ID_COMUNICACION%TYPE Retorna el id de la Comunicacion
   * @param Pv_Status         OUT  VARCHAR2 Retorna estatus de la transaccion
   * @param Pv_Mensaje        OUT  VARCHAR2 Retorna mensaje de la transaccion
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   22-10-2021
   */
  PROCEDURE P_INSERT_COMUNICACION(Pcl_Request  IN  CLOB,
                                  Pn_IdComunicacion OUT INFO_COMUNICACION.ID_COMUNICACION%TYPE,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2);
  
  /**
   * Documentación para el proceso 'P_INSERT_DOCUMENTO'
   *
   * Metodo encargado de generar un documento
   *
   * @param Pcl_Request     IN   CLOB Recibe json request con informacion del documento
   * [
   *  documento                   Documento a registrar,
   *  idTipoDocumento             Id del tipo de documento,
   *  idClaseDocumento            Id de la clase de documento,           
   *  nombreDocumento             Nombre del documento,
   *  ubicacionLogicaDocumento    Ubicación lógica del documento,
   *  ubicacionFisicaDocumento    Ubicación física del documento,
   *  fechaDocumento              Fecha del documento,
   *  idModeloElemento            Id del modelo del elemento,
   *  idElemento                  Id del elemento,
   *  idContrato                  Id del contrato,
   *  idDocumentoFinanciero       Id del documento financiero,
   *  idTareaInterfaceModeloTra   Id de tarea, interface, modelo,
   *  estado                      Estado del documento,
   *  codEmpresa                  Código de empresa,
   *  idTipoDocumentoGeneral      Id del tipo documento general,
   *  fechaDesde                  Fecha desde para el documento,
   *  fechaHasta                  Fecha hasta para el documento,
   *  latitud                     Latitud de ubicación del documento,
   *  longitud                    Longitud de ubicación del documento,
   *  etiquetaDocumento           Etiqueta del documento,
   *  idCuadrillaHistorial        Id Cuadrilla para historial,
   *  fechaCreacion               Fecha de creación del documento,
   *  mensaje                     Mensaje del documento
   *  usuario                     Usuario quien genera el documento,
   *  ip                          Ip de donde se origina el documento
   * ]
   * @param Pn_IdDocumento  OUT  INFO_DOCUMENTO.ID_DOCUMENTO%TYPE Retorna el id del documento
   * @param Pv_Status       OUT  VARCHAR2 Retorna estatus de la transaccion
   * @param Pv_Mensaje      OUT  VARCHAR2 Retorna mensaje de la transaccion
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   25-10-2021
   */                                
  PROCEDURE P_INSERT_DOCUMENTO (Pcl_Request     IN  CLOB,
                                Pn_IdDocumento  OUT INFO_DOCUMENTO.ID_DOCUMENTO%TYPE,
                                Pv_Status       OUT VARCHAR2,
                                Pv_Mensaje      OUT VARCHAR2);
  
  /**
   * Documentación para el proceso 'P_INSERT_DOC_COMUNICACION'
   *
   * Metodo encargado de generar la relación entre el documento y la comunicación
   *
   * @param Pcl_Request           IN   CLOB Recibe json request con información del documento y comunicación
   * [
   *  idDocumento     Id del documento,
   *  idComunicacion  Id de la comunicación,
   *  estado          Estado de la relación entre documento y comunicación,           
   *  fechaCreacion   Fecha de creación,
   *  usuario         Usuario quien genera la relación entre documento y comunicación,
   *  ip              Ip de donde se origina la relación entre documento y comunicación
   * ]
   * @param Pn_IdDocComunicacion  OUT INFO_DOCUMENTO_COMUNICACION.ID_DOCUMENTO_COMUNICACION%TYPE Retorna el id de la relacion del documento y comunicacion
   * @param Pv_Status             OUT  VARCHAR2 Retorna estatus de la transaccion
   * @param Pv_Mensaje            OUT  VARCHAR2 Retorna mensaje de la transaccion
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   25-10-2021
   */                              
  PROCEDURE P_INSERT_DOC_COMUNICACION (Pcl_Request          IN  CLOB,
                                       Pn_IdDocComunicacion OUT INFO_DOCUMENTO_COMUNICACION.ID_DOCUMENTO_COMUNICACION%TYPE,
                                       Pv_Status            OUT VARCHAR2,
                                       Pv_Mensaje           OUT VARCHAR2);
  
  /**
   * Documentación para el proceso 'P_INSERT_DOCUMENTO_RELACION'
   *
   * Metodo encargado de generar la relación entre el documento y la transacción (caso, tarea, etc)
   *
   * @param Pcl_Request           IN   CLOB Recibe json request con información del documento y relación
   * [
   *  idDocumento               Id del documento,
   *  modulo                    Modulo de la transacción (SOPORTE, TECNICO, etc),
   *  idEncuesta                Id de la encuesta,
   *  idServicio                Id del servicio,
   *  idPunto                   Id del punto,
   *  idPersonaEmpresaRol       Id de la persona empresa rol,
   *  idContrato                Id del contrato,
   *  idDocumentoFinanciero     Id del documento financiero,
   *  idCaso                    Id del caso,
   *  idActividad               Id de la actividad,
   *  idTipoElemento            Id del tipo de elemento,
   *  idModeloElemento          Id del modelo de elemento,
   *  idElemento                Id del elemento,
   *  idDetalle                 Id del detalle,
   *  idOrdenTrabajo            Id de la orden de trabajo,
   *  idMantenimientoElemento   Id del mantenimiento del elemento,
   *  estadoEvaluacion          Estado de la evaluación,
   *  evaluacionTrabajo         Evaluación del trabajo,
   *  fechaInicioEvaluacion     Fecha de inicio de evaluación,
   *  usuarioEvaluacion         Usuario de evaluación,
   *  porcentajeEvaluacionBase  Porcentaje de la evaluación base,
   *  porcentajeEvaluado        Porcentaje evaluado,
   *  numeroAdendum             Número del adendum,
   *  idPagoDatos               Id del pago de datos,
   *  estado                    Estado de la relación con documento,           
   *  fechaCreacion             Fecha de creación,
   *  usuario                   Usuario quien genera la relación con el documento
   * ]
   * @param Pn_IdDocRelacion  OUT  INFO_DOCUMENTO_RELACION.ID_DOCUMENTO_RELACION%TYPE Retorna el id de la relacion del documento y relación
   * @param Pv_Status         OUT  VARCHAR2 Retorna estatus de la transaccion
   * @param Pv_Mensaje        OUT  VARCHAR2 Retorna mensaje de la transaccion
   *
   * @author  David De La Cruz <ddelacruz@telconet.ec>
   * @version 1.0 
   * @since   25-10-2021
   */                                      
  PROCEDURE P_INSERT_DOCUMENTO_RELACION (Pcl_Request      IN  CLOB,
                                         Pn_IdDocRelacion OUT INFO_DOCUMENTO_RELACION.ID_DOCUMENTO_RELACION%TYPE,
                                         Pv_Status        OUT VARCHAR2,
                                         Pv_Mensaje       OUT VARCHAR2);                                       
                                  
END CUKG_COMUNICACIONES_TRANSAC;
/


CREATE OR REPLACE PACKAGE BODY DB_COMUNICACION.CUKG_COMUNICACIONES_TRANSAC AS

  PROCEDURE P_INSERT_COMUNICACION(Pcl_Request  IN  CLOB,
                                  Pn_IdComunicacion OUT INFO_COMUNICACION.ID_COMUNICACION%TYPE,
                                  Pv_Status    OUT VARCHAR2,
                                  Pv_Mensaje   OUT VARCHAR2) AS
  
  BEGIN 
  
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdComunicacion := SEQ_INFO_COMUNICACION.NEXTVAL;
    
    INSERT INTO DB_COMUNICACION.INFO_COMUNICACION
      (Id_Comunicacion,
      Forma_Contacto_Id,
      Tramite_Id,
      Caso_Id,
      Detalle_Id,      
      Remitente_Id,
      Remitente_Nombre,
      Clase_Comunicacion,
      Fecha_Comunicacion,
      Descripcion_Comunicacion,
      Estado,
      Punto_Id,
      Empresa_Cod,
      Fe_Creacion,
      Usr_Creacion,
      Ip_Creacion) 
    VALUES
      (Pn_IdComunicacion,
      APEX_JSON.get_number('idFormaContacto'),
      APEX_JSON.get_number('idTramite'),
      APEX_JSON.get_number('idCaso'),
      APEX_JSON.get_number('idDetalle'),
      APEX_JSON.get_number('idRemitente'),
      APEX_JSON.get_varchar2('nombreRemitente'),
      APEX_JSON.get_varchar2('claseComunicacion'),
      TO_DATE(APEX_JSON.get_varchar2('fechaComunicacion'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_varchar2('descripcionComunicacion'),
      APEX_JSON.get_varchar2('estado'),
      APEX_JSON.get_number('idPunto'),
      APEX_JSON.get_varchar2('codEmpresa'),
      TO_DATE(APEX_JSON.get_varchar2('fechaCreacion'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Comunicacion creada correctamente';
    
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_COMUNICACION;
  
  PROCEDURE P_INSERT_DOCUMENTO (Pcl_Request     IN  CLOB,
                                Pn_IdDocumento  OUT INFO_DOCUMENTO.ID_DOCUMENTO%TYPE,
                                Pv_Status       OUT VARCHAR2,
                                Pv_Mensaje      OUT VARCHAR2) AS
  
    Lcl_Documento clob;
    Lbl_Documento blob;
    Li_DestOffset integer;
    Li_SrcOffset integer;
    Li_LangContext integer;
    Li_Warning integer;
  BEGIN 
    Li_DestOffset := 1;
    Li_SrcOffset := 1;
    Li_LangContext := 0;
    Li_Warning := 0;
    APEX_JSON.PARSE(Pcl_Request);
    Lcl_Documento := APEX_JSON.get_clob('documento');
    Pn_IdDocumento := SEQ_INFO_DOCUMENTO.NEXTVAL;
    
    IF Lcl_Documento IS NOT NULL THEN
      DBMS_LOB.CreateTemporary(Lbl_Documento, true);
      DBMS_LOB.ConvertToBlob(Lbl_Documento, Lcl_Documento, length(Lcl_Documento), Li_DestOffset, Li_SrcOffset, 0, Li_LangContext, Li_Warning);
    END IF;
    
    INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO
      (Id_Documento,
      Tipo_Documento_Id,
      Clase_Documento_Id,
      Nombre_Documento,
      Ubicacion_Logica_Documento,      
      Ubicacion_Fisica_Documento,
      Documento,
      Fecha_Documento,
      Modelo_Elemento_Id,
      Elemento_Id,
      Contrato_Id,
      Documento_Financiero_Id,
      Tarea_Interface_Modelo_Tra_Id,
      Estado,
      Mensaje,
      Empresa_Cod,
      Tipo_Documento_General_Id,
      Fecha_Desde,
      Fecha_Hasta,
      Latitud,
      Longitud,
      Etiqueta_Documento,
      Cuadrilla_Historial_Id,
      Fe_Creacion,
      Usr_Creacion,
      Ip_Creacion) 
    VALUES
      (Pn_IdDocumento,
      APEX_JSON.get_number('idTipoDocumento'),
      APEX_JSON.get_number('idClaseDocumento'),
      APEX_JSON.get_varchar2('nombreDocumento'),
      APEX_JSON.get_varchar2('ubicacionLogicaDocumento'),
      APEX_JSON.get_varchar2('ubicacionFisicaDocumento'),
      Lbl_Documento,
      TO_DATE(APEX_JSON.get_varchar2('fechaDocumento'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_number('idModeloElemento'),
      APEX_JSON.get_number('idElemento'),
      APEX_JSON.get_number('idContrato'),
      APEX_JSON.get_number('idDocumentoFinanciero'),
      APEX_JSON.get_number('idTareaInterfaceModeloTra'),
      APEX_JSON.get_varchar2('estado'),
      APEX_JSON.get_clob('mensaje'),
      APEX_JSON.get_varchar2('codEmpresa'),
      APEX_JSON.get_number('idTipoDocumentoGeneral'),
      TO_DATE(APEX_JSON.get_varchar2('fechaDesde'),'rrrr-mm-dd hh24:mi:ss'),
      TO_DATE(APEX_JSON.get_varchar2('fechaHasta'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_number('latitud'),
      APEX_JSON.get_number('longitud'),
      APEX_JSON.get_varchar2('etiquetaDocumento'),
      APEX_JSON.get_number('idCuadrillaHistorial'),
      TO_DATE(APEX_JSON.get_varchar2('fechaCreacion'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Documento creado correctamente';
    
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_DOCUMENTO;
  
  PROCEDURE P_INSERT_DOC_COMUNICACION (Pcl_Request          IN  CLOB,
                                       Pn_IdDocComunicacion OUT INFO_DOCUMENTO_COMUNICACION.ID_DOCUMENTO_COMUNICACION%TYPE,
                                       Pv_Status            OUT VARCHAR2,
                                       Pv_Mensaje           OUT VARCHAR2) AS
  
  BEGIN 
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdDocComunicacion := SEQ_DOCUMENTO_COMUNICACION.NEXTVAL;
    
    INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_COMUNICACION
      (Id_Documento_Comunicacion,
      Documento_Id,
      Comunicacion_Id,
      Estado,
      Fe_Creacion,
      Usr_Creacion,
      Ip_Creacion) 
    VALUES
      (Pn_IdDocComunicacion,
      APEX_JSON.get_number('idDocumento'),
      APEX_JSON.get_number('idComunicacion'),
      APEX_JSON.get_varchar2('estado'),
      TO_DATE(APEX_JSON.get_varchar2('fechaCreacion'),'rrrr-mm-dd hh24:mi:ss'),
      APEX_JSON.get_varchar2('usuario'),
      APEX_JSON.get_varchar2('ip'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Documento Comunicacion creado correctamente';
    
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_DOC_COMUNICACION;
  
  PROCEDURE P_INSERT_DOCUMENTO_RELACION (Pcl_Request      IN  CLOB,
                                         Pn_IdDocRelacion OUT INFO_DOCUMENTO_RELACION.ID_DOCUMENTO_RELACION%TYPE,
                                         Pv_Status        OUT VARCHAR2,
                                         Pv_Mensaje       OUT VARCHAR2) AS
  
  BEGIN 
    APEX_JSON.PARSE(Pcl_Request);
    Pn_IdDocRelacion := SEQ_INFO_DOCUMENTO_RELACION.NEXTVAL;
    
    INSERT INTO DB_COMUNICACION.INFO_DOCUMENTO_RELACION
      (Id_Documento_Relacion,
      Documento_Id,
      Modulo,
      Encuesta_Id,
      Servicio_Id,
      Punto_Id,
      Persona_Empresa_Rol_Id,
      Contrato_Id,
      Documento_Financiero_Id,
      Caso_Id,
      Actividad_Id,
      Tipo_Elemento_Id,
      Modelo_Elemento_Id,
      Elemento_Id,
      Detalle_Id,
      Orden_Trabajo_Id,
      Mantenimiento_Elemento_Id,
      Estado_Evaluacion,
      Evaluacion_Trabajo,
      Fe_Inicio_Evaluacion,
      Usr_Evaluacion,
      Porcentaje_Evaluacion_Base,
      Porcentaje_Evaluado,
      Numero_Adendum,
      Pago_Datos_Id,
      Estado,
      Fe_Creacion,
      Usr_Creacion
      ) 
    VALUES
      (Pn_IdDocRelacion,
      APEX_JSON.get_number('idDocumento'),
      APEX_JSON.get_varchar2('modulo'),
      APEX_JSON.get_number('idEncuesta'),
      APEX_JSON.get_number('idServicio'),
      APEX_JSON.get_number('idPunto'),
      APEX_JSON.get_number('idPersonaEmpresaRol'),
      APEX_JSON.get_number('idContrato'),
      APEX_JSON.get_number('idDocumentoFinanciero'),
      APEX_JSON.get_number('idCaso'),
      APEX_JSON.get_number('idActividad'),
      APEX_JSON.get_number('idTipoElemento'),
      APEX_JSON.get_number('idModeloElemento'),
      APEX_JSON.get_number('idElemento'),
      APEX_JSON.get_number('idDetalle'),
      APEX_JSON.get_number('idOrdenTrabajo'),
      APEX_JSON.get_number('idMantenimientoElemento'),
      APEX_JSON.get_varchar2('estadoEvaluacion'),
      APEX_JSON.get_varchar2('evaluacionTrabajo'),
      APEX_JSON.get_varchar2('fechaInicioEvaluacion'),
      APEX_JSON.get_varchar2('usuarioEvaluacion'),
      APEX_JSON.get_number('porcentajeEvaluacionBase'),
      APEX_JSON.get_number('porcentajeEvaluado'),
      APEX_JSON.get_varchar2('numeroAdendum'),
      APEX_JSON.get_number('idPagoDatos'),
      APEX_JSON.get_varchar2('estado'),
      SYSDATE,
      APEX_JSON.get_varchar2('usuario'));
    
    Pv_Status := 'OK';
    Pv_Mensaje := 'Documento Relacion creado correctamente';
    
  EXCEPTION 
    WHEN OTHERS THEN  
      Pv_Status :=  'ERROR';
      Pv_Mensaje := 'Error: ' || SQLERRM;
  END P_INSERT_DOCUMENTO_RELACION;

END CUKG_COMUNICACIONES_TRANSAC;

/
